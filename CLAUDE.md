# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

The LaTeX lecture-notes template the author's notes repositories are cut from
(`book` class). There is no code, no tests, and no linter — the deliverable is
`main.pdf`.

**This repository is the template, so it is also the upstream.** Two things here are
consumed by the repositories cut from it, and changing either changes them too:

- `.github/workflows/latex-build-deploy.yml` and `latex-preview-cleanup.yml`, which
  those repositories call rather than copy (see [Publishing](#publishing));
- `.claude/`, `CLAUDE.md` and the skills, which they copy and then adapt.

A change that only makes sense for one course does not belong here. Make it there.

## Building

`latexmk`, `pdflatex`, `biber`, and `make4ht` are all available locally.

```bash
# Full build with bibliography, output into TeX_Outputs/ (matches .vscode config)
latexmk -pdf -outdir=TeX_Outputs main.tex

# What CI runs — the same tool, into its own (gitignored) output directory.
# The second, forced invocation guarantees a second pdflatex pass.
latexmk -pdf -halt-on-error -file-line-error -interaction=nonstopmode \
        -outdir=TeX_Outputs_CI main.tex
latexmk -pdf -halt-on-error -file-line-error -interaction=nonstopmode \
        -g -outdir=TeX_Outputs_CI main.tex
```

Compile **at least twice**: `cleveref` and the ToC depend on the `.aux` files, and
citations need a `biber` pass in between. `latexmk` works that out for itself, which
is why CI uses it — but CI also forces a second pass with `-g`, because a warm
auxiliary-file cache can otherwise leave it satisfied after one.

`TeX_Outputs/main.pdf` is **committed** (a general `*.pdf` ignore is deliberately
commented out in `.gitignore`); CI republishes it as `public/LastLocallyCompiled.pdf`.
Keep it refreshed when making substantive content changes.

## Structure

`main.tex` is the only root document. It defines course metadata as macros
(`\COURSENUMBER`, `\COURSENAME`, `\LECTURER`, `\SCRIBE`, `\UNIVERSITY`, `\TERM`,
`\REPONAME`) that are consumed by the title block and by the "latest version" URLs.
**Setting these is the first thing a repository cut from this template does**;
`\REPONAME` in particular must match the GitHub repository name, or the URLs on the
title page point nowhere.

`main.tex` then `\input`s the four preamble files in a fixed order, and they are not
interchangeable:

- `TeX_Setup/packages.tex` — all `\usepackage` calls, `hyperref` colors, `biblatex` + bib resource, TikZ libraries
- `TeX_Setup/format.tex` — sans-serif default font, `fancyhdr` headers, 1.5 line spacing, `parskip` (no paragraph indents), color definitions
- `TeX_Setup/environments.tex` — `amsthm` theorem declarations and the boxed variants
- `TeX_Setup/shortcuts.tex` — all custom macros

Content lives in `Chapters/`, one directory per multi-section chapter. A chapter file
holds `\chapter{...}`, intro prose, and `\input`s of its sections; sections are
separate files named `<chapter>_<section>_<Name>.tex`. Note `Chapters/2_Another Chapter/`
contains a space in its path — quote paths when scripting over it.
`Chapters/Appendices/` and the reference-list `\chapter*` in `main.tex` are currently
commented out.

Adding a chapter means: create the directory, write the chapter file with its section
`\input`s, and add one `\input` line to `main.tex`.

**Everything under `Chapters/` is placeholder.** `0_Overview.tex`,
`1_Intro/1_1_Imp_Defs.tex`, `1_Intro/1_2_Another_Section.tex`, `2_Another Chapter/`
and `Appendices/` exist to demonstrate the layout and to give the template something
to compile. A new notes repository clears them as real material arrives; see the
scaffolding sections of `/integrate` and `/organize`.

## Authoring conventions

Every theorem-like environment has a plain form and a boxed `box*` form; **prefer the
boxed form in the notes** — that is what the existing content uses.

- Orange box: `boxtheorem`, `boxproposition`, `boxlemma`, `boxcorollary`
- Cyan box: `boxdefinition`
- Magenta box: `boxconvention`, `boxnotation`, `boxlnotation` (local notation), `boxabbrev`
- Green/red box: `boxexample`, `boxnexample` (non-example), `boxcexample` (counterexample)
- Gray/red box: `boxexercise`, `boxproblem`, `boxwarning`

Numbering: `theorem` and everything sharing its counter number per *section*;
`remark`, `solution`, `convention`, `notation`, `warning`, `abbreviation` are unnumbered.
Cross-reference with `cleveref` — **always `\Cref`, never `\cref`** — and label as
`Ch<N>:<Kind>:<Name>`, with chapters as `Ch<N>:CH`.

Two reference files under `.claude/` carry the conventions, and the skills point at
them rather than restating them:

- **`.claude/STYLE.md`** — how a passage *reads*: the prose voice, the LaTeX
  mechanics, the label scheme, the macro naming conventions, and pointers into the
  author's four sibling lecture-note repositories, which share this template and
  this style and are the corpus to imitate. Read it before writing any prose or
  math into the notes.
- **`.claude/ORGANIZATION.md`** — where a passage *lives*: the generality ladder that
  decides what earns a chapter, a section and a subsection, read off those same
  repositories, plus the naming conventions and the format and ownership of
  `TOPICS.md`. Read it before deciding where anything goes.

`TeX_Setup/shortcuts.tex` is large and worth grepping before writing raw math — it
already defines auto-sized delimiters (`\parenth`, `\brac`, `\set`, `\setst`, `\abs`,
`\norm`, `\floor`, `\ceil`, `\cycl`), number sets (`\R`, `\Z`, `\N`, `\Q`, `\C`, `\F`),
operator wrappers (`\pgcd`, `\plcm`, `\rank`, `\pker`, `\pim`, `\Span`, `\ord`, `\sgn`,
`\Sym`, `\Aut`, `\Spec`, …), the `cd`/`cd*` commutative-diagram environments, and
`\sorry` (red `sorry` marker for gaps to fill in later). Add new macros there rather
than defining them inline; course-specific ones go under the `% COURSE-SPECIFIC:`
banner at the end of the file.

## Lecture workflow

Notes are taken linearly but organized by topic, so raw and integrated material are
kept distinct. A lecture's raw notes go in a throwaway section file inside whatever
chapter is current, with `Lecture_` in its basename and the date as its title:

```
Chapters/1_Intro/1_4_Lecture_0824.tex     ->  \section{Lecture 2026-08-24}
```

It is `\input` from its chapter file like any other section, so the document always
compiles. The `/integrate` skill (`.claude/skills/integrate/`) then redistributes that
content into the proper sections by topic and deletes the staging file. Do not treat a
`Lecture_*.tex` file as settled content.

`TOPICS.md` at the repo root is the running map of topic to chapter/section, and is
the authority on where new material belongs. `/organize` owns it; `/integrate`
appends to it.

**These notes assume no syllabus.** The author's courses have not come with one, so
`TOPICS.md` is built up lecture by lecture from what was actually taught, and the
chapter structure stays provisional. Never add a section because a course on the
subject "usually" covers that topic. If a course *does* publish a syllabus, that is a
per-repository fact worth recording in that repository's `CLAUDE.md` — it does not
change anything here.

The two structural skills divide as follows, and the division matters because
restructuring renumbers results:

- **`/integrate`** (`.claude/skills/integrate/`) absorbs one lecture's raw notes. It
  may create a heading for material that has nowhere to go, but it does **not**
  restructure what is already written. When it sees that the structure has stopped
  fitting, it records the pressure in `TOPICS.md` and recommends `/organize`.
- **`/organize`** (`.claude/skills/organize/`) refactors the existing chapter,
  section and subsection structure against `ORGANIZATION.md`, and rebuilds
  `TOPICS.md`. It adds no material and deletes none — the same content, better
  arranged.

## `% [CLAUDE]` comments

Notes taken live contain delegated tasks, marked inline:

```tex
% [CLAUDE] Finish proof using previous lemma
% [CLAUDE] insert triangle, pentagon, 7-gon, \cdots here
```

Each is a small, specific writing job — finish an argument, draw a figure, work out
arithmetic the lecture skipped. The `/address-comments` skill
(`.claude/skills/address-comments/`) executes them, writing in the author's voice and
deleting the marker once satisfied. Do not treat a `% [CLAUDE]` line as ordinary
commented-out content, and do not delete one without addressing it.

`\sorry` is the other inline marker, and it means something different: not a scoped
instruction but an unfilled gap — a proof not given, a case not covered, a development
that broke off. The `/fill-sorries` skill (`.claude/skills/fill-sorries/`) closes them,
and it is the one skill authorized to work the mathematics out for itself rather than
following an instruction. It marks what it supplied with a `% [FILLED]` comment, so
the notes stay honest about which arguments came from the lecturer.

The five skills divide by how much latitude each has:

| Skill | Acts on | Latitude |
| --- | --- | --- |
| `/address-comments` | `% [CLAUDE]` directives | do exactly what the directive says |
| `/fill-sorries` | `\sorry` markers | work out the mathematics; decide and report |
| `/integrate` | one lecture's raw notes | place new material; never restructure |
| `/organize` | the notes as they stand | rearrange only; add and delete nothing |
| `/americanise` | British spellings | spelling only; never the mathematics |

## Publishing

`.github/workflows/publish-latex.yml` runs on every push/PR to `main`. It is a
**caller**: the build itself is `.github/workflows/latex-build-deploy.yml`, a
reusable workflow that this repository publishes and every notes repository invokes
rather than copying. The caller exists only because a reusable workflow cannot
declare its own `on:` triggers.

The build compiles `main.pdf` with `latexmk` (so `biber` runs and the bibliography
resolves) and uploads it as an artifact; where that PDF then goes depends on the
trigger:

- **push to `main`** — published to the `gh-pages` root, so
  `https://thefundamentaltheor3m.github.io/<REPONAME>/main.pdf` (the URL printed on
  the title page) updates, and attached to the `Current` release. The committed
  `TeX_Outputs/main.pdf` is republished alongside it as `LastLocallyCompiled.pdf`.
- **pull request** — published to `preview-<PR number>/` on the same site and linked
  from a comment on the pull request, so an unmerged draft never overwrites the
  published notes. `preview-cleanup.yml` deletes the directory when the PR closes.
  Pull requests from forks only get the artifact: their token cannot push.

The build fails loudly (`-halt-on-error`), so a broken document breaks CI rather than
publishing a broken PDF — compile locally before pushing.

CI does not install `texlive-full`. It installs exactly the packages listed in
`.github/texlive-packages.txt` into a cached tree, which is why a run takes about a
minute rather than ten. **Adding a `\usepackage` to `TeX_Setup/packages.tex` therefore
means accounting for it in that manifest too**: either add its TeX Live package
(`tlmgr info <file>.sty` names it, and it is often called something else — `authblk`
ships in `preprint`, `tikz` in `pgf`), or, if an entry already there installs it, add
the style file to that entry's `# provides:` list.

That manifest is shared: a notes repository with no `.github/texlive-packages.txt` of
its own uses this one, so **a package added here becomes available to all of them**,
and a package removed here can break one of them. The same goes for
`.github/scripts/`. Prefer adding to the shared manifest over giving one repository a
local copy — the local copy then has to be maintained separately, which is the thing
this arrangement exists to avoid.

`.github/scripts/check-manifest.sh` greps for this as the build's first step, so a
forgotten package fails in seconds with the name and the file that loads it, rather
than minutes later inside a pdflatex log. Run it locally to check before pushing:

```bash
.github/scripts/check-manifest.sh
```

The HTML (`make4ht`) path is not wired up.

## Setting up a new notes repository from this template

1. Copy the tree, and set the metadata macros at the top of `main.tex` — including
   `\REPONAME`, which must match the new repository's name.
2. Keep `.github/workflows/publish-latex.yml` and `preview-cleanup.yml`, changing the
   `uses:` line in each from the local `./` form to the absolute one, so that they
   track this template:

   ```yaml
   uses: thefundamentaltheor3m/Lecture-Notes-Template-2026/.github/workflows/latex-build-deploy.yml@main
   ```

3. Do **not** copy `.github/scripts/` or `.github/texlive-packages.txt`. They are
   resolved from here at run time; a local copy overrides them and then has to be
   maintained.
4. Enable GitHub Pages on the `gh-pages` branch, and create a release tagged
   `Current` for the PDF to attach to.
5. Adapt `CLAUDE.md`, `.claude/STYLE.md` and `.claude/ORGANIZATION.md` to the course:
   the voice and the ladder carry over unchanged, but the worked examples in them are
   worth replacing with ones from the actual subject.
6. Clear the placeholder chapters as real material arrives — `/organize`'s job, not
   something to do up front.
