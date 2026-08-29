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

**Everything under `Chapters/` is placeholder, with one exception.**
`0_Overview.tex`, `1_Intro/1_1_Imp_Defs.tex`, `1_Intro/1_2_Another_Section.tex`,
`2_Another Chapter/` and `Appendices/` exist to demonstrate the layout and to give the
template something to compile. A new notes repository clears them as real material
arrives; see the scaffolding sections of `/integrate` and `/organize`.

The exception is `1_Intro/todays_lecture.tex`, the lecture inbox described under
[Lecture workflow](#lecture-workflow). It is infrastructure rather than scaffolding:
it stays, it gets emptied rather than deleted, and its `\input` line stays last in
whichever chapter file is current.

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
kept distinct. Raw notes go into a **reusable inbox** in whichever chapter is current:

```
Chapters/1_Intro/todays_lecture.tex
```

It is `\input` last from its chapter file, so the document always compiles and the
Overleaf preview builds live during the lecture. `/integrate` redistributes the
content into the proper sections by topic and then **empties the file, keeping it** —
the author reuses it every lecture, and deleting it or its `\input` line breaks the
preview. Do not treat anything in it as settled content.

The inbox is a convenience, not the definition of what is new. **`/integrate` works
out the latest lecture's material from the git history** — a watermark commit, the
diff from there to `HEAD`, and the uncommitted working tree — so material typed
straight into a real section file is still found. A date or heading the author wrote
live is a cross-check on that, not the source of truth; where the two disagree, ask.

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
that broke off. The `/fill-sorries` skill (`.claude/skills/fill-sorries/`) closes them.
Where a `% [CLAUDE]` directive sits on the same gap as a `\sorry`, the directive wins
and `/address-comments` takes it: a scoped instruction the author wrote by hand beats
a bare marker.

Three further markers record where the notes are no longer purely the lecturer's, and
all of them are written by a skill rather than by the author:

| Marker | Written by | Means |
| --- | --- | --- |
| `% [FILLED]` | `/fill-sorries` | an argument supplied here that the lecture did not give |
| `% [CORRECTED]` | `/check-correctness` | a statement changed, with the original quoted so it can be reverted by eye |
| `% [SUSPECT]` | `/check-correctness` | believed wrong, left unchanged, awaiting the author |

Never write a `% [CLAUDE]` marker yourself. That is the author's channel for
delegating work, and one you write is work the next `/post-lecture` run will silently
do.

### The one you usually want

**`/post-lecture`** (`.claude/skills/post-lecture/`) is the whole after-lecture
routine in one pass and one pull request: fill the gaps, address the directives, check
the mathematics, fix the spellings, integrate the result. It is a *composition* — it
adds no rules of its own, and each phase is the component skill read and followed as
written. Reach for it by default after a lecture; reach for a component directly when
you want only that one thing.

Its five phases run in a fixed order — write, then check, then tidy, then move — and
one branch carries five commits, one per phase, so the author can tell invented
mathematics from a cosmetic spelling sweep in review.

### The seven, by how much latitude each has

| Skill | Acts on | Latitude |
| --- | --- | --- |
| `/post-lecture` | one lecture, end to end | composition; owns scope and order only |
| `/address-comments` | `% [CLAUDE]` directives | do exactly what the directive says |
| `/fill-sorries` | `\sorry` markers | work out the mathematics; decide and report |
| `/check-correctness` | what is already written | fix what is false; every change adjudicated |
| `/integrate` | one lecture's raw notes | place new material; never restructure |
| `/organize` | the notes as they stand | rearrange only; add and delete nothing |
| `/americanise` | British spellings | spelling only; never the mathematics |

`/organize` is deliberately **not** part of `/post-lecture`: restructuring renumbers
every result under the heading it touches, so it belongs in a diff of its own, run
when `TOPICS.md` has accumulated enough structural pressure to justify it.

**Two skills do mathematics, under opposite constraints.** `/fill-sorries` supplies an
argument that does not exist, so it has the freest hand in the repository.
`/check-correctness` overwrites one that does, so it changes as little as it can and
puts *every* candidate correction to an independent agent before applying it — then,
if it changed anything, has the result reviewed by two further independent agents on
the pull request. A statement found false while filling a gap belongs to it, not to
`/fill-sorries`.

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

**TeX Live comes from a mirror, and mirrors go down.** The install tries
`texlive-repo` first and then each of `texlive-fallback-repos` in turn, twice each,
with a connect timeout — because a single pinned mirror with no fallback once took
every repository's build down at once. Two things make that failure mode worse than it
looks and are worth knowing:

- **A cold install is not rare.** GitHub scopes caches per branch, so a tree cached on
  a pull request branch is invisible to `main`; the first run after any merge is a
  cold install and always exercises this path.
- **The job carries `timeout-minutes`**, so a network call that hangs rather than
  failing is bounded instead of sitting on the six-hour default.

If every mirror is down the build says so explicitly and prints how to point at
another one — `with: texlive-repo: …` on the caller, no template change needed.

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
