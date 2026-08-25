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
set -euo pipefail

TEXLIVE_DIR="${TEXLIVE_DIR:-$HOME/texlive}"
TEXLIVE_REPO="${TEXLIVE_REPO:?TEXLIVE_REPO must be set}"
MANIFEST="${MANIFEST:-.github/texlive-packages.txt}"

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

if ! tlmgr="$(find_tlmgr)"; then
    echo "::group::Bootstrapping TeX Live infrastructure"
    bootstrap="$(mktemp -d)"
    trap 'rm -rf "$bootstrap"' EXIT
    curl -fsSL "$TEXLIVE_REPO/install-tl-unx.tar.gz" \
        | tar xz -C "$bootstrap" --strip-components=1

    # Everything, including the user-level trees, is kept under TEXLIVE_DIR so
    # that one cache entry captures the whole installation and nothing is
    # written to $HOME behind the cache's back.
    cat > "$bootstrap/profile" <<PROFILE
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

    "$bootstrap/install-tl" \
        --profile="$bootstrap/profile" \
        --repository="$TEXLIVE_REPO" \
        --no-interaction
    echo "::endgroup::"

    tlmgr="$(find_tlmgr)"
else
    echo "Restored an existing TeX Live tree; topping it up."
fi

echo "::group::tlmgr install (${#packages[@]} requested packages)"
"$tlmgr" --repository="$TEXLIVE_REPO" install "${packages[@]}"
echo "::endgroup::"

"$tlmgr" --version
du -sh "$TEXLIVE_DIR"
