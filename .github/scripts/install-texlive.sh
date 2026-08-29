#!/usr/bin/env bash
#
# Install, or top up, the TeX Live tree that CI compiles the notes with.
#
# The old workflow ran `apt install texlive-full`: six-odd gigabytes and the
# better part of ten minutes on every run, with a cache that pointed at
# /usr/local/texlive and so never held anything (apt puts TeX Live in
# /usr/share/texlive). This installs only what main.tex actually loads, into a
# directory the workflow can cache and restore in seconds.
#
# The package list lives in .github/texlive-packages.txt and doubles as the
# cache key. Two cases to handle:
#
#   * nothing restored          -> bootstrap install-tl, then install the list
#   * an older tree restored    -> just install the list; tlmgr skips whatever
#     (partial cache-key hit)      is already present and fetches the rest
#
# EVERY NETWORK CALL HERE IS BOUNDED AND RETRIED ACROSS MIRRORS. An earlier
# version piped a single pinned mirror straight into tar:
#
#     curl -fsSL "$TEXLIVE_REPO/install-tl-unx.tar.gz" | tar xz ...
#
# which had no connect timeout, no retry and nowhere else to go. When that
# mirror stopped answering, the call sat for five minutes and then produced
#
#     curl: (28) SSL connection timeout
#     gzip: stdin: unexpected end of file
#     tar: Child returned status 1
#
# on every repository at once, because the mirror is shared. Note also that
# GitHub scopes caches per branch: a tree cached on a pull request branch is
# invisible to `main`, so the first run after a merge is always a cold install
# and always exercises this path.
#
set -euo pipefail

TEXLIVE_DIR="${TEXLIVE_DIR:-$HOME/texlive}"
TEXLIVE_REPO="${TEXLIVE_REPO:?TEXLIVE_REPO must be set}"
TEXLIVE_FALLBACK_REPOS="${TEXLIVE_FALLBACK_REPOS:-}"
MANIFEST="${MANIFEST:-.github/texlive-packages.txt}"

# How long to wait, and how often to try again, before moving to the next
# mirror. Deliberately short: a mirror that has not answered in 20 seconds is
# not about to, and there is another one to try.
CONNECT_TIMEOUT="${TEXLIVE_CONNECT_TIMEOUT:-20}"
MAX_TIME="${TEXLIVE_MAX_TIME:-600}"
ATTEMPTS_PER_REPO="${TEXLIVE_ATTEMPTS_PER_REPO:-2}"

# The first entry is the preferred mirror; the rest are tried in order. Passing
# TEXLIVE_REPO alone still works and simply means "no fallback".
mapfile -t REPOS < <(
    printf '%s\n%s\n' "$TEXLIVE_REPO" "$TEXLIVE_FALLBACK_REPOS" \
        | tr -s '[:space:]' '\n' | sed '/^$/d' | awk '!seen[$0]++'
)

# Strip comments and blank lines; whitespace-separate what is left.
mapfile -t packages < <(sed -e 's/#.*//' "$MANIFEST" | tr -s '[:space:]' '\n' | sed '/^$/d')
[ "${#packages[@]}" -gt 0 ] || { echo "$MANIFEST lists no packages" >&2; exit 1; }

find_tlmgr() {
    local candidate
    for candidate in "$TEXLIVE_DIR"/bin/*/tlmgr; do
        [ -x "$candidate" ] && { echo "$candidate"; return 0; }
    done
    return 1
}

# Download to a file rather than into a pipe. A truncated transfer then shows up
# as a failed curl and a failed `tar -t`, both of which we can retry, instead of
# as a corrupt stream that has already been half-unpacked.
fetch() {
    local url=$1 dest=$2
    curl --fail --location --silent --show-error \
         --connect-timeout "$CONNECT_TIMEOUT" --max-time "$MAX_TIME" \
         --output "$dest" "$url"
}

# One mirror, one full bootstrap: fetch the installer, verify the archive, and
# run install-tl against that same mirror. Any failure leaves the caller free to
# try the next mirror from scratch.
bootstrap_from() {
    local repo=$1 dir=$2
    local tarball="$dir/install-tl-unx.tar.gz"

    rm -rf "$dir"; mkdir -p "$dir"
    fetch "$repo/install-tl-unx.tar.gz" "$tarball" || return 1
    tar tzf "$tarball" >/dev/null 2>&1 || { echo "  archive is not a readable gzip tar" >&2; return 1; }
    tar xzf "$tarball" -C "$dir" --strip-components=1 || return 1
    [ -x "$dir/install-tl" ] || { echo "  no install-tl in the archive" >&2; return 1; }

    # Everything, including the user-level trees, is kept under TEXLIVE_DIR so
    # that one cache entry captures the whole installation and nothing is
    # written to $HOME behind the cache's back.
    cat > "$dir/profile" <<PROFILE
selected_scheme scheme-infraonly
TEXDIR $TEXLIVE_DIR
TEXMFLOCAL $TEXLIVE_DIR/texmf-local
TEXMFSYSVAR $TEXLIVE_DIR/texmf-var
TEXMFSYSCONFIG $TEXLIVE_DIR/texmf-config
TEXMFVAR $TEXLIVE_DIR/user-var
TEXMFCONFIG $TEXLIVE_DIR/user-config
TEXMFHOME $TEXLIVE_DIR/texmf-home
instopt_adjustpath 0
instopt_adjustrepo 0
tlpdbopt_install_docfiles 0
tlpdbopt_install_srcfiles 0
tlpdbopt_autobackup 0
PROFILE

    "$dir/install-tl" --profile="$dir/profile" --repository="$repo" --no-interaction
}

# Run an operation over the mirror list, retrying each a few times before moving
# on. Echoes the mirror that worked so the caller can keep using it.
over_mirrors() {
    local what=$1 fn=$2 repo attempt
    for repo in "${REPOS[@]}"; do
        for attempt in $(seq 1 "$ATTEMPTS_PER_REPO"); do
            echo "  $what: $repo (attempt $attempt/$ATTEMPTS_PER_REPO)" >&2
            if "$fn" "$repo"; then
                WORKING_REPO="$repo"
                return 0
            fi
            [ "$attempt" -lt "$ATTEMPTS_PER_REPO" ] && sleep 5
        done
        echo "  giving up on $repo" >&2
    done
    return 1
}

mirrors_exhausted() {
    cat >&2 <<MESSAGE

None of the ${#REPOS[@]} configured TeX Live mirrors could be reached:

$(printf '  %s\n' "${REPOS[@]}")

This is an upstream availability problem, not a problem with the notes. If it
persists, point the build at a working mirror without changing the template:

  jobs:
    latex:
      uses: thefundamentaltheor3m/Lecture-Notes-Template-2026/.github/workflows/latex-build-deploy.yml@main
      with:
        texlive-repo: https://<a mirror that answers>/systems/texlive/<year>/tlnet-final

TeX Live historic mirrors are listed at https://tug.org/historic/.
MESSAGE
    exit 1
}

if ! tlmgr="$(find_tlmgr)"; then
    echo "::group::Bootstrapping TeX Live infrastructure"
    bootstrap="$(mktemp -d)"
    trap 'rm -rf "$bootstrap"' EXIT

    bootstrap_here() { bootstrap_from "$1" "$bootstrap"; }
    over_mirrors "bootstrapping from" bootstrap_here || mirrors_exhausted

    echo "::endgroup::"
    tlmgr="$(find_tlmgr)"
else
    echo "Restored an existing TeX Live tree; topping it up."
    WORKING_REPO=""
fi

echo "::group::tlmgr install (${#packages[@]} requested packages)"
# Prefer the mirror the bootstrap already succeeded against; on a restored tree
# there is none, so start at the top of the list again.
if [ -n "${WORKING_REPO:-}" ]; then
    REPOS=("$WORKING_REPO" "${REPOS[@]}")
    mapfile -t REPOS < <(printf '%s\n' "${REPOS[@]}" | awk '!seen[$0]++')
fi

tlmgr_install() { "$tlmgr" --repository="$1" install "${packages[@]}"; }
over_mirrors "installing packages from" tlmgr_install || mirrors_exhausted
echo "::endgroup::"

"$tlmgr" --version
du -sh "$TEXLIVE_DIR"
