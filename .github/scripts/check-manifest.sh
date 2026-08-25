#!/usr/bin/env bash
#
# Fail fast when the sources load something .github/texlive-packages.txt does
# not account for.
#
# CI installs exactly the packages that manifest lists, so a new \usepackage
# that nobody added to it breaks the build -- but it breaks it several minutes
# in, inside a pdflatex log, with a "File `foo.sty' not found" buried in it.
# This is grep over the .tex files and the manifest: it costs a second or two
# and runs before anything is downloaded.
#
# Line-based on purpose. A \usepackage whose argument is split across lines
# would be missed, and would then fail the slow way, in the compile.
#
set -euo pipefail

MANIFEST="${MANIFEST:-.github/texlive-packages.txt}"

# Comments to end-of-line, but a \% is an escaped percent sign and not a
# comment. Applied before anything is extracted, so a commented-out
# \usepackage -- of which packages.tex has a few -- does not count as loaded.
strip_comments() {
    sed -e 's/^[[:space:]]*%.*//' -e 's/\([^\\]\)%.*/\1/'
}

# What the manifest makes available: the TeX Live package names, plus the style
# files named in `# provides:` annotations for the entries whose package name
# and style-file name differ.
available="$(
    {
        sed -e 's/#.*//' "$MANIFEST"
        sed -n 's/.*#[[:space:]]*provides:[[:space:]]*//p' "$MANIFEST" | tr ',' '\n'
    } | tr -s '[:space:]' '\n' | sed '/^$/d' | sort -u
)"

# What the sources load.
requested="$(
    grep -rhE --include='*.tex' --exclude-dir=.git \
        '\\(usepackage|RequirePackage|documentclass)' . \
        | strip_comments \
        | grep -oE '\\(usepackage|RequirePackage|documentclass)[[:space:]]*(\[[^]]*\])?[[:space:]]*\{[^}]*\}' \
        | sed -e 's/.*{//' -e 's/}.*//' \
        | tr ',' '\n' | tr -d '[:blank:]' | sed '/^$/d' | sort -u
)"

missing="$(comm -23 <(printf '%s\n' "$requested") <(printf '%s\n' "$available"))"

if [ -z "$missing" ]; then
    printf '%s accounts for all %d loaded packages.\n' \
        "$MANIFEST" "$(printf '%s\n' "$requested" | wc -l)"
    exit 0
fi

echo "::group::Unaccounted-for packages"
while IFS= read -r name; do
    [ -n "$name" ] || continue
    # Where it is loaded, for the error message.
    where="$(grep -rlE --include='*.tex' --exclude-dir=.git \
        "\\\\(usepackage|RequirePackage|documentclass)[^{]*\\{[^}]*\\b${name}\\b" . \
        | sed 's|^\./||' | paste -sd', ' -)"
    echo "::error file=${MANIFEST},title=Package not in the TeX Live manifest::\
${name} is loaded by ${where:-the sources} but no entry in ${MANIFEST} provides it"
done <<< "$missing"
echo "::endgroup::"

cat >&2 <<MESSAGE

CI installs only the packages listed in ${MANIFEST}, so the compile would fail
on this several minutes from now with "File \`<name>.sty' not found".

To fix, for each name above, either:

  * add its TeX Live package to ${MANIFEST} -- \`tlmgr info <name>.sty\` names
    it, and it is often not called <name>: authblk ships in preprint, tikz in
    pgf; or
  * if an entry already there installs it, add <name> to that entry's
    \`# provides:\` list. Style files that share a package with something
    already listed -- tabularx in tools, say -- need nothing installed, only
    recording.
MESSAGE
exit 1
