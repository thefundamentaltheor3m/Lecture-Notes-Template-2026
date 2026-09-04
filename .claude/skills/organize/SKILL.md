---
name: organize
description: Refactor the chapter, section and subsection structure of these lecture notes so that what is already written sits where it belongs, and maintain TOPICS.md as the record of that structure. Use when the notes have outgrown or drifted from their current arrangement — a section doing the work of three, a chapter whose title no longer describes its contents, material in the wrong place, a heading level that should not exist — or when TOPICS.md needs rebuilding. Also owns the mechanics of opening a new chapter — creating its directory and chapter file, moving the section files and the staging file into it, rewriting the \input lines in main.tex and the Ch<N> label prefixes. Triggers on "/organize", "organize the notes", "reorganize the chapters", "restructure this", "open a new chapter", "sort out TOPICS.md". Not for absorbing a new lecture: that is /integrate.
---

# Organising the notes

There is no syllabus for this course. The structure of `Chapters/` was therefore
never designed — it accreted, one lecture at a time, and every lecture was placed
using only the information available before the next one happened. This skill is the
correction pass: it takes the notes as they stand and rearranges *them*, adding
nothing and removing nothing.

Read these first, in order:

- `.claude/ORGANIZATION.md` — what earns a chapter, a section and a subsection, the
  naming conventions, and the format and ownership of `TOPICS.md`. **This skill's job
  is to make the document match that file** — which means matching its account of the
  generality ladder, not its size table.
- `CLAUDE.md` — build commands, preamble layout, authoring conventions.
- `.claude/STYLE.md` — the voice, for the connecting prose that restructuring
  inevitably needs rewritten.

## Scope: what this skill is and is not

`/organize` and `/integrate` share their format, their guiding principles and their
respect for the author's mathematics. They do not share a scope, and confusing the
two is the main way either can do damage.

| | `/integrate` | `/organize` |
| --- | --- | --- |
| Input | one lecture's raw notes | the notes as they already stand |
| Adds material | yes, that is the point | **never** |
| Restructures | only enough to house the new material | yes, that is the point |
| `TOPICS.md` | appends its own entries | **owns the file** |
| Ends with | the raw file dissolved | the same content, better arranged |

**This skill adds no mathematics and no exposition beyond connecting prose.** If you
find yourself writing a definition, finishing a proof, or supplying an example, stop:
that is `/address-comments`, `/fill-sorries`, or a lecture's job, not this one. The
content going in is the content coming out.

**This skill deletes nothing.** Not a duplicate, not a triviality, not a stray aside.
Restructuring that loses a sentence has failed, however much better the outline
looks.

If the notes contain a `Lecture_*.tex` staging file, this skill is the wrong one —
that file is `/integrate`'s. Say so and stop. Running `/organize` first on unintegrated
material would restructure around content that is about to move anyway.

## Procedure

### 1. Take inventory

Before forming any opinion, read the notes and say what is in them. For every
chapter, section and subsection, write down **what idea or line of enquiry it
actually contains** — one sentence, in your own words, of the form "this establishes
X" or "this is the definition of Y and what it is for". If you cannot write that
sentence for a heading, that is your first finding.

Then, for each unit: its title, its file, and whether the sentence you wrote matches
the title. Sizes are worth noting in passing but they decide nothing; see
`ORGANIZATION.md` on how little they are worth.

Also record

- every `\subsubsection` (there should be none — that one is a real rule),
- every heading whose title no longer describes what you just wrote down about it,
- every place where consecutive material is really one idea under two headings, or two
  ideas under one,
- every label, and every `\Cref` that points at one — this is the map of what
  renumbering will break.

Keep the inventory for the rest of the run. Nothing may be dropped, so an
unrecorded item is an item at risk.

### 2. Read the corpus, not just the notes

The standard is the author's other notes, not your instincts about how a textbook
should look. `ORGANIZATION.md` summarizes them, but when a specific call is close —
is this one subsection or two? does this deserve a section? — go and look at how a
comparable piece of material is handled in [TopologyNotes][t], [LogicNotes][l],
[RepTheoryEPFL][r] or [LieAlgebrasNotes][a]. Find the nearest analog and follow it.

[t]: https://github.com/thefundamentaltheor3m/TopologyNotes
[l]: https://github.com/thefundamentaltheor3m/LogicNotes
[r]: https://github.com/thefundamentaltheor3m/RepTheoryEPFL
[a]: https://github.com/thefundamentaltheor3m/LieAlgebrasNotes

Three questions worth asking of the corpus every time:

- **Is this material one idea or several?** That is the subsection test, and the corpus
  is full of worked examples of where the author draws the line — including very short
  subsections (*Ideals*, *Quotients*) kept separate because they are separate ideas.
- **Where is this line of enquiry going?** If you can name the destination, you have a
  section; if the destination is the same as the section it follows, you have a
  subsection of that section.
- **Would the author have given this its own heading?** Look for the nearest analog
  and see whether they did. Do not reason from length — the author does not.

### 3. Diagnose

State what is wrong with the current arrangement, as a list of specific findings,
each argued from the ideas. A finding names the mismatch between what a unit contains
and what its heading claims: "the material in 1.2 asks the same question of a more
general object, so it continues 1.1's line of enquiry rather than starting a new one,
but it currently sits unheaded inside a subsection about the special case". "Section 1.2 is 45
lines, below the corpus median" is not a finding — it is at best a hint that sent you
to look. "The structure could be cleaner" is not a finding either.

Every finding must survive the question **"what would a reader misunderstand?"** If
nothing, there is nothing to fix, whatever the numbers say.

Then say what is *right*, and leave it alone. A correction pass that rewrites
everything it touches is indistinguishable from noise, and the author has to review
every line of it.

Where the notes cannot satisfy the norms at all — early in a course they cannot —
apply the self-healing rule from `ORGANIZATION.md`: favor the arrangement whose
deviations resolve themselves as lectures arrive, and record the deviation in
`TOPICS.md` with the condition that will end it.

### 4. Plan, and get it approved

Produce the plan and **stop for confirmation before moving anything.** The plan
states:

- the target outline, in full, as it will appear in `TOPICS.md`;
- for each move: what content, from where, to where, and which finding it answers;
- every heading created, deleted, promoted or demoted, with its title;
- every file created, renamed or deleted;
- if a chapter is being opened, renumbered or renamed: its number, its directory, the
  section files moving into it, any placeholder directory it displaces, where the
  staging file ends up, and the label prefixes that change — see
  [Opening a new chapter](#opening-a-new-chapter) for what that commits you to;
- every renumbering the move causes, and every `\Cref` that will need checking;
- the connecting prose to be rewritten, with a sentence on what each passage will
  now have to do — a section that acquires a new neighbor usually needs its opening
  sentence changed;
- anything you have decided to leave alone despite it being off-norm, and why.

Structure is editorial judgment and the author is the editor. Restructuring is also
the most expensive thing to undo in these notes, because it renumbers results. Never
skip this step, even when the diagnosis looks unarguable.

If the run is happening in a context where you cannot stop and ask — an automated
pass, a one-shot request for a finished branch — then say so plainly, apply the
plan, and put the full plan and its rationale in the commit message and the pull
request body instead. What is not acceptable is moving things silently.

### 5. Apply

Working rules, in order of importance:

**Content is invariant.** Every definition, statement, proof, display, figure and
paragraph comes out the other side character-for-character identical, unless it is
connecting prose. Move by cutting and pasting whole blocks; do not retype, do not
"tidy while moving". If a passage seems wrong, leave it wrong and report it.

**Rewrite connecting tissue freely, and only that.** Section and subsection titles,
opening and closing sentences, the one-sentence bridges that carry the reader between
environments, chapter intro prose. These are what make a rearrangement read as though
it had always been that way, and rewriting them is the whole point. `STYLE.md` has
the voice.

**Move whole ideas.** Do not split a definition from the example that motivates it,
or a theorem from its proof, across a heading boundary. If a section boundary would
land in the middle of an argument, the boundary is in the wrong place.

**Preserve labels wherever possible.** A label's `Ch<N>:` prefix should match its new
chapter, so a cross-chapter move means renaming labels and updating every `\Cref` to
them. A same-chapter move should leave labels untouched — renaming a label nobody
asked you to rename is churn that shows up in the diff and helps nobody.

**File and directory names follow the content.** A section that moves to slot 1.3
becomes `1_3_<Abbrev>.tex`, and its `\input` moves with it. Use `git mv` so the
rename is visible in the diff rather than appearing as a delete plus an add. Quote
paths: some directory names contain spaces. Chapter 1's directory stays `1_Intro`
regardless of the chapter's title — see `ORGANIZATION.md`. Opening a chapter is more
than a rename, and has its own procedure below.

**No subsubsections, ever.** If the plan wanted one, the section above it was wrong.

**Placeholders left over from the template** — `Chapters/0_Overview.tex`,
`Chapters/2_Another Chapter/`, `Chapters/Appendices/` — are in scope for this skill
in a way they are not for `/integrate`, since they are a structural problem. Propose
clearing them; never clear a file that has acquired real content.

#### Opening a new chapter

A new chapter is not a heading. It is a directory, a chapter file, a line in
`main.tex`, whatever section files have moved into it, and every label underneath them
rewritten — and the failure mode is doing the interesting part and leaving the rest.
That is what strands a `\chapter` heading in the middle of the previous chapter's last
section, or leaves a directory nothing `\input`s and that therefore renders nowhere,
or two directories both claiming to be chapter 2. **When the plan opens a chapter, do
all of the following, in this order.** Read symmetrically, the same procedure
renumbers or renames an existing one.

Let `<N>` be the number the new chapter takes and `<Abbrev>` the short CamelCase or
Snake_Case abbreviation of its title, per `ORGANIZATION.md`.

1. **Free the number first.** No two directories under `Chapters/` may carry the same
   `<N>_` prefix. If a template placeholder is sitting on it — `Chapters/2_Another
   Chapter/` is the usual culprit — settle that before creating anything: `git mv` the
   placeholder to the next free number, renaming its chapter and section files and its
   `\input` line in `main.tex` to match, or clear it outright if the author has
   confirmed nothing is planned for it. Renumbering a placeholder needs no approval —
   nothing references it and its content does not change.

2. **Create the directory and the chapter file.**
   `Chapters/<N>_<Abbrev>/<N>_<Abbrev>.tex`, holding `\chapter{<Title>}` with
   `\label{Ch<N>:CH}`, `\thispagestyle{empty}`, the chapter's intro prose, any
   chapter-wide `boxnotation` or `boxconvention`, and then one `\input` per section in
   reading order. Nothing else lives in a chapter file.

3. **Move the sections that belong to it, with `git mv`.** A section moving out of
   chapter `<M>` goes from `<M>_<K>_<Topic>.tex` to `<N>_<J>_<Topic>.tex`, `<J>` being
   its position in the new chapter's reading order; close the gap it leaves by
   renumbering the sections that stay, so neither chapter has a hole in its numbering.
   Use `git mv` rather than a copy and a delete — the rename is the reviewable part of
   the diff — and quote every path, because `Chapters/2_Another Chapter/` has a space
   in it. **There may be no sections to move**: a chapter opened for material that is
   about to be written into it starts empty, and steps 1, 2, 4, 5 and 6 are still all
   of the work.

4. **Rewrite the `\input` lines — all three sets.** The donor chapter file loses the
   lines for what left and keeps the rest in reading order; the new chapter file gains
   them; `main.tex` gains `\input{Chapters/<N>_<Abbrev>/<N>_<Abbrev>.tex}` in chapter
   order, above the commented-out placeholder chapters and the appendices rather than
   below them. **The order of the `\input`s in `main.tex` is what actually numbers the
   chapters**, so a mismatch between a directory's `<N>_` prefix and its position there
   is a bug even though it compiles. An `\input` may omit the `.tex`, so grep for the
   stem rather than the filename.

5. **Move the staging file into the chapter the course is now in.** If the notes keep a
   per-lecture inbox — whatever `/integrate` reads from — and it sits in a chapter
   directory that is no longer the current one, `git mv` it into the new chapter's
   directory and move its `\input` line to the end of the new chapter file. Keep the
   file and its header comment. This one is easy to skip because nothing breaks: the
   notes still compile, and the next lecture merely previews as the tail of the wrong
   chapter. **Say in the report that the path changed**, because the author types into
   it every lecture and may have it open.

6. **Rewrite the labels of everything that moved.** A label carries its chapter, so
   `Ch<M>:Def:Foo` in a file now under chapter `<N>` becomes `Ch<N>:Def:Foo`. Rewrite
   the label and every `\Cref` to it in the same pass, repository-wide rather than only
   in the files that moved, then grep for the old prefix to confirm none survives. This
   is the step that breaks the build when it is done by halves.

7. **Record the chapter when you rebuild `TOPICS.md`** in step 6 of the skill's
   procedure, below: the chapter, its directory, what moved into it and from where,
   and — if it was opened at a heading the author wrote live — that fact and the words
   they wrote, which are the justification for the bet. `ORGANIZATION.md` is explicit
   that a chapter *is* a bet on where the course is going, so the reason for opening it
   belongs on the record beside it.

**Steps 1 and 5 are not `## Structural pressure`.** That heading is for what a run
*noticed and was not allowed to fix*. A directory collision and a stranded staging file
caused by a chapter this very run opened are neither: they are consequences of your
own move, they are mechanical, and nobody else is coming for them. Filing them instead
of doing them is how a half-opened chapter survives three passes. The test is
authorship — if the run before yours would not have had to fix it, it is yours.

### 6. Rebuild TOPICS.md

`/organize` owns this file; rewrite it to describe the new structure, in the format
`ORGANIZATION.md` specifies. In particular:

- the leading inference note about where the structure looks to be heading, marked as
  inference and left open for the next run to disagree with;
- every line traceable to a lecture, with its date;
- `## Signposted` kept separate from the outline, so a topic a lecture merely pointed
  at cannot harden into a section nobody asked for;
- any deliberate deviation from the norms, with the condition that will end it.

### 7. Verify

1. **Inventory check** — walk the inventory and name the file and heading each item
   now sits under. Anything unaccounted for is a bug; find it before continuing.
2. **Content diff** — `git diff` and confirm that every changed line of mathematics
   is a pure move. `git diff --stat` should show a lot of renames and few
   modifications outside titles and bridging prose. This is the check that catches
   the failure mode of this skill, which is rewriting while rearranging.
3. **Chapter plumbing**, whenever a chapter was opened, renumbered or renamed:

   ```bash
   ls Chapters | sed -n 's/^\([0-9][0-9]*\)_.*/\1/p' | sort | uniq -d
   grep -rho '\\input{[^}]*}' main.tex Chapters | sed 's/.*{\(.*\)}/\1/' | sort
   grep -rn 'label{Ch[0-9]*:' Chapters
   ```

   The first prints any number claimed by two directories at once, and must print
   nothing. The second is every `\input` path in the document: check that each one
   resolves — with or without the `.tex` — and that every `.tex` file under
   `Chapters/` appears in it or is deliberately unreferenced, catching both a dangling
   `\input` and the orphaned file. The third is every label prefix: read each against
   the directory its file sits in, and against that chapter's position in `main.tex`.
   Then find the staging file and confirm it is in the current chapter.
4. **Build** — `latexmk -pdf -outdir=TeX_Outputs main.tex`. Read the log for
   undefined references and duplicate labels: those are the symptoms of a botched
   move. Grep for `\Cref`s to anything that moved.
5. **Numbering** — check the rendered ToC against the outline in `TOPICS.md`, and
   spot-check that results renumbered the way the plan said they would.
6. **Refresh `TeX_Outputs/main.pdf`** — it is tracked deliberately.

### 8. Branch, commit, PR

Never restructure directly on `main`.

```bash
git checkout -b organize/<short-description>
git add -A && git commit    # subject: "Reorganize <what>"
git push -u origin organize/<short-description>
```

Then attempt the PR — `gh` is on some of the author's machines and not others, so
check rather than assume:

```bash
gh auth status
gh pr create --base main --title "Reorganize <what>" --body-file <file>
```

Write the body to a file so it survives shell quoting, and put the diagnosis and the
plan in it: for a restructuring PR, the rationale *is* the reviewable content, since
the diff is mostly moves. Follow the build with `gh pr checks --watch`; a red build
on `main` breaks the published PDF. If `gh` is unavailable, say so and print the
compare URL instead:

```
https://github.com/thefundamentaltheor3m/<REPO>/compare/main...organize/<short-description>
```

## Report back

- **The diagnosis**: each finding, argued from what the material is about and what a
  reader would otherwise misunderstand.
- **The moves**: what went where, and which finding each one answers.
- **What was left alone**, including anything off-norm you decided to tolerate and
  the condition that would change your mind.
- **Any chapter opened, renumbered or renamed**: its directory, everything that moved
  into it and out of what, the placeholder it displaced if it displaced one, and where
  the staging file ended up. That is not a detail — the author types into that path.
- **Renumbering**: what changed number, and every `\Cref` you checked.
- **Prose you rewrote** — titles, bridges, intros. These are the only places where
  words changed, so they are what the author needs to read.
- **Anything you think is wrong** in the notes, quoted, left unchanged.
- The build result.

Be specific about the prose. In a restructuring pass the moves are mechanical and
verifiable, but the rewritten sentences are yours, and they are the part the author
cannot check from the outline alone.
