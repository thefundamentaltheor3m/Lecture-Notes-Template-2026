---
name: integrate
description: Absorb the latest lecture's raw notes into the structured chapter/section hierarchy of these lecture notes. Finds what is new from the git history rather than from any naming convention, so it works wherever the author happened to type. Use when the user has just taken notes and wants them redistributed by topic, matching the existing expository style, boxed environments, numbering, and labels. Triggers on "/integrate", "integrate my notes", "integrate today's lecture", "fold in the last lecture".
---

# Integrating a lecture into the notes

Raw notes are taken linearly, in lecture order. The notes themselves are organized
by topic. This skill is the translation between the two: it takes one lecture's
worth of unsorted material and distributes it into the right chapters, sections and
subsections, writing whatever connecting prose is needed to make the result read as
though it had always been there.

Read these first; everything below assumes them.

- `CLAUDE.md` — build commands, preamble layout, authoring conventions.
- `.claude/STYLE.md` — the voice, the LaTeX mechanics, the label scheme and the macro
  conventions, with pointers into the author's other notes repositories when a
  question is not settled there.
- `.claude/ORGANIZATION.md` — what earns a chapter, a section and a subsection, and
  the format of `TOPICS.md`. Here it is a **constraint**, not a target: it tells you
  whether this lecture's material fits an existing section or has earned one of its
  own. Making the document match it is `/organize`'s job, not yours.

## Finding the new material

**The git history is the source of truth for what is new.** Not a filename, not a
`\section{Lecture …}` heading, not a date comment. Those are conventions the author
may or may not have followed on any given day, and a skill that depends on one of them
breaks the first time a lecture is typed somewhere unexpected. The history cannot be
wrong about what changed.

The author writes in Overleaf during the lecture and syncs, so raw material arrives as
ordinary commits — `feat: Lecture 2`, `Updates from Overleaf` — touching whatever files
were open. It may be one commit or several, one file or several, and it need not be
committed at all yet.

### Establish the watermark

Find where integration last reached. `TOPICS.md` is the sharpest signal available,
because `/integrate` and `/organize` are the only things that touch it:

```bash
git log --oneline -- TOPICS.md            # the last few integration passes
git log --oneline -20 -- Chapters/ TeX_Setup/   # and the rhythm of raw arrivals
```

Read both before deciding. **The watermark is a starting heuristic, not an oracle**: a
commit can touch `TOPICS.md` for reasons that are not an integration — a spelling
sweep, a rename — and taking such a commit as the watermark would narrow the diff and
hide material. So pick the most recent commit you can actually justify as "the notes
were settled here", and say which one you picked and why.

### Take the diff, from every angle

```bash
git diff <watermark>..HEAD -- Chapters/ TeX_Setup/     # everything added since
git log --diff-filter=A --name-only <watermark>..HEAD -- Chapters/   # new files
git status --short && git diff -- Chapters/ TeX_Setup/ # NOT YET COMMITTED
```

That last one matters as much as the others. Notes typed minutes ago may still be
sitting unstaged in the working tree, and material that is not in a commit is still
material. Take the **union** of every signal; when they disagree, prefer the wider
reading and say what you took.

Then **cross-check against the current tree.** Anything the diff surfaces that already
sits under a real heading in a settled section is already integrated — the diff shows
it because the watermark was conservative, not because it needs moving. Drop those and
say so.

### Get the date from the commit

```bash
git log -1 --format='%ad' --date=short <the commit that brought the material>
```

`TOPICS.md` annotates every entry with the lecture date, and the commit date is a fact
rather than a convention. Prefer it. If the author also wrote a date in the file — a
leading `% 26 Aug 2026`, a `\section{Lecture …}` heading — use it as a cross-check, and
if the two disagree, ask: one of them is a typo and guessing picks the wrong one.

### The staging file, when there is one

The author keeps a reusable inbox in whichever chapter is current:

```
Chapters/1_Intro/todays_lecture.tex
```

It is `\input` from its chapter file, so the notes always compile and the Overleaf
preview builds live during the lecture. When the new material is in there, **empty the
file rather than deleting it**: the author reuses it every lecture, and deleting it or
its `\input` line would break the preview and force them to recreate it. Leave behind
only a short header comment saying what the file is for.

This file is a convenience, not the definition of the input. Do not require it, do not
assume the material is confined to it, and do not stop because it is absent or empty
while the history plainly shows new material elsewhere.

### When there is genuinely nothing to do

If every signal is empty — no commits since the watermark, nothing unstaged, an empty
inbox — then there is nothing to integrate. Say so and stop; do not go hunting.

**If the notes contain nothing to integrate *into*** — a first lecture, or a repository
still all template placeholders — then the right skill is `/organize`: the task is
arranging one lecture's material sensibly, not folding it into an existing arrangement.
Say so and stop.

## The author's structure is a gift

The author writes real headings as the lecture happens — `\subsection{Ramsey Numbers}`
— rather than dumping unstructured prose. **Assume every bit of that structure is
deliberate and meant to help you.** It is the judgment of the person who was actually
in the room, and it tells you things the text alone does not: what they considered one
idea, where they felt a topic began, which results they saw as belonging together.

So: read the headings before you place anything, and treat them as the author's
proposal about where the material goes. Start from that proposal. Most of the time it
will be right, and following it costs you nothing.

**You may overrule it.** These are choices made mid-lecture, at speed, without knowing
what the rest of the course holds, and `ORGANIZATION.md` is still the standard: a
heading that splits one line of enquiry in two, or fuses two into one, or reaches for a
fourth level of depth, should be changed. The author expects that — it is why the notes
get integrated at all rather than just accumulating.

But overruling carries two obligations:

- **Never silently.** Every structural choice of theirs that you changed goes in the
  plan and in the report, named, with the reason. A reader of the diff should not have
  to reverse-engineer which headings were theirs and which are yours.
- **Make it cheap to reverse.** The author has the final say when they review the pull
  request, so each overruled choice should be individually revertable — which in
  practice means saying plainly what you did, not burying three structural decisions in
  one hunk.

Flattening or discarding a heading without mentioning it is the one thing that is
always wrong here, because it destroys information the author cannot get back.

## There is no syllabus

**No list of topics for the course will ever be provided.** Nobody knows what
`Chapters/` should eventually look like — not the user, not you. That single fact
drives most of the judgment calls in this skill:

- `TOPICS.md` is a **record of what the lectures have actually covered**, not a plan
  derived from a syllabus. Never invent sections for topics no lecture has reached
  because a course like this "usually" covers them.
- The chapter and section structure is therefore **provisional**, and stays
  provisional. Early lectures land in whatever chapter looked right at the time; by
  lecture ten it may be obviously wrong. That is expected. It is also not yours to
  fix — see the boundary below.
- What you *may* do is infer where things seem to be heading from the lecture itself
  — a result stated but not proved, a definition introduced for later use, an
  explicit "we'll come back to this". Record those under `## Signposted` in
  `TOPICS.md`, clearly marked as the lecturer's signposting rather than as structure.
  They are the closest thing to a syllabus that exists.

## Scope: this skill does not restructure

`/integrate` and `/organize` share their format, their guiding principles and their
respect for the author's mathematics. They do not share a scope.

| | `/integrate` | `/organize` |
| --- | --- | --- |
| Input | whatever the history shows is new | the notes as they already stand |
| Adds material | yes, that is the point | never |
| Restructures | only enough to house the new material | yes, that is the point |
| `TOPICS.md` | appends its own entries | owns the file |
| Ends with | the inbox emptied and kept | the same content, better arranged |

**Restructuring what already exists is out of scope here.** Concretely, you may:

- create a new section or subsection for material that has nowhere to go, sized
  according to `ORGANIZATION.md`;
- adjust a heading title that *this lecture's material* has made inaccurate;
- add a cross-reference in either direction between new and existing material.

You may not: move settled material between sections or chapters, split or merge
existing headings, rename or split a chapter, promote a subsection to a section, or
renumber anything that was already in place. Those are `/organize`'s, and they are
out of scope even when they are obviously right, because they renumber results and
the author has to review the fallout.

When you see one — a chapter whose title stopped describing its contents three
lectures ago, a section doing the work of three —
**record it and recommend `/organize`**. Note it under a `## Structural pressure`
heading in `TOPICS.md` and raise it in the report. A wedged-in placement that you have
flagged is recoverable; a unilateral reorganization buried in an integration diff is
not.

## Procedure

### 1. Build the ledger, from the diff

Build the ledger **out of the diff you established above**, not by reading a file. That
is what makes it trustworthy: the diff is the complete set of what is new, so a ledger
derived from it cannot quietly omit material that was typed somewhere you did not think
to look.

Enumerate **every** discrete piece: each theorem-like environment, each displayed
derivation, each figure or TikZ picture, each paragraph of prose, each aside — and each
heading the author wrote, recorded as their placement proposal (see **The author's
structure is a gift**). Give every item a short handle, quote its opening words, and
note which commit or which unstaged hunk it came from.

Keep the ledger for the rest of the run. It is the only guard against silently dropping
something, and the inbox is emptied at the end, so an unledgered item is a lost item.

### 2. Read the surrounding notes

- `TOPICS.md` — the running topic map (see below). The primary placement authority.
- `.claude/ORGANIZATION.md` — the generality ladder, which decides whether this
  lecture's material joins an existing section or earns a new one. The question is
  conceptual, not dimensional: material that continues an existing line of enquiry
  becomes a subsection of that section however much of it there is, and only material
  asking a different question earns a section of its own.
- `.claude/STYLE.md` — the house style, and the corpus it points at. If you have not
  read a real section of the notes end to end in this session, read two now; the
  voice does not transfer from a description of it.
- `main.tex` — chapter order and which chapters are commented out.
- Every chapter file, and any section file the ledger might touch.
- `TeX_Setup/shortcuts.tex` and `TeX_Setup/environments.tex` — the available macro
  and environment vocabulary. Grep these before writing raw math; the notes have a
  house macro for most things.

### 3. Plan, and get it approved

Produce a plan and **stop for confirmation before writing anything**. The plan states,
for each ledger item, where it goes and why; then separately lists

- new sections or subsections to create, with their titles,
- **every heading the author wrote that you are keeping**, and
- **every one you are overruling** — quoting theirs, giving yours, and saying which
  rule in `ORGANIZATION.md` makes the change necessary. This list is the one the
  author will read first, because it is where your judgment overrides theirs,
- existing material to be moved, quoting what and from where to where,
- new linking prose to be written, with a sentence on what each passage will argue,
- anything you cannot place confidently.

Placement is editorial judgment and the user is the editor. Never skip this step,
even when the answer looks obvious.

For items you genuinely cannot place, prefer parking them over guessing: leave them
in a clearly-marked holding section and record them under `## Unplaced` in
`TOPICS.md`. A wrong confident placement is worse than a flagged one.

### 4. Apply

Working rules, in order of importance:

**Never lose or alter mathematics.** Definitions, theorem/lemma/proposition
statements, and proofs move *verbatim* — copy them, do not retype or paraphrase them.
If a statement seems wrong or incomplete, move it unchanged and flag it in the report;
do not fix it silently. `/check-correctness` is the skill that acts on those flags.

**Rewrite freely at the level of connective tissue.** Transitions, motivating
sentences, section titles and ordering are yours to adjust so the result reads
continuously. This is the whole point of the skill — a purely additive integration
would leave the notes a pile of lectures.

**Never delete a statement.** Not a duplicate, not a triviality, not an aside. If two
lectures state the same result, merge them into one environment, keep the stronger or
better-worded statement, and say so in the report.

#### Expository style, in brief

`.claude/STYLE.md` is the full account and takes precedence over this summary. The
parts that bite hardest during an integration:

- **Every boxed environment gets a one-sentence bridge before it.** This is the most
  visible signature of the notes and the thing a raw lecture file most reliably
  lacks. "We have a special term for Lie algebras whose derived series stabilizes at
  $0$." / "There is also a less trivial example." / "The following is thus obvious."
  One clause of signposting, then the box. Writing these is most of the work.
- **First-person plural, colloquial but not chatty.** "We begin by…", "Next, we…",
  "It turns out that…". Dry humor where it lands naturally ("Here's a cool result.")
  and nowhere else. American spelling: *coloring*, *neighborhood*, *generalization*.
- **Boxed environments always** — `boxdefinition`, `boxtheorem`, `boxlemma`,
  `boxexample`, … (`CLAUDE.md` has the family). Raw notes are written loosely;
  converting them is expected. Definitions carry a title, `[Coloring]`; results
  usually do not. `\hfill` after `\begin{box…}` or `\begin{proof}` when the body
  opens with a list. `\textbf{}` the term being defined, in the definition body.
- **`align*` for every display**, even one-liners. One paragraph per source line, no
  hard wrapping — and never reflow a line you were not otherwise changing.
- **Case splits use `description`** with `\item[\underline{Case…}]` or
  `\item[$\parenth{\implies}$]`.
- **Replace ad-hoc math with house macros:** `\parenth`, `\set`, `\setst`, `\abs`,
  `\floor`, `\ceil`, `\R`, `\Z`, `\N`, `\pgcd`, `\Sym`, … Grep `shortcuts.tex`
  first; it almost always already has one. A genuinely new one is appended to the
  `% COURSE-SPECIFIC` block following the existing naming conventions, never
  defined inline.
- **Mark a gap the lecture left** — a proof not given, a case not covered, an argument
  that simply stops — with `\sorry`. Do not quietly fill it with a hand-wave, and do
  not work it out yourself: marking is your job, and `/fill-sorries` is the skill that
  closes them. An unmarked gap is one nobody will come back for.

Then, mechanically:

- One file per section, named `<chapter>_<section>_<Topic>.tex`, `\input` from the
  chapter file in reading order. Quote paths: directory names may contain spaces.
- Labels are `Ch<N>:<Kind>:<Name>` — `Def`, `Thm`, `Prop`, `Lemma`, `Cor`, `Eg`,
  `CEg`, `Eq`, `Sec`, `Subsec` — with chapters as `Ch<N>:CH`; see `STYLE.md` for the
  full table. **Label only what is actually referenced**; most environments in the
  notes carry no label. Cross-reference with `\Cref` (capital C — `\cref` appears
  nowhere in the notes), and add references both ways when a new result depends on
  an older one.
- Remember results are numbered per *section*, so moving a theorem across a section
  boundary renumbers it. Grep for stale `\Cref`s to anything you moved.
- Empty the inbox last, once every ledger item is placed: leave the file, a short
  header comment saying what it is for, and its `\input` line. Delete neither the file
  nor the line — the author reuses it every lecture and the Overleaf preview depends
  on it. Material that came from somewhere other than the inbox leaves that file as it
  finds it, minus what moved.

### 5. Append to TOPICS.md

`ORGANIZATION.md` specifies the format and `/organize` owns the file. Your job is to
**append, not to rewrite**: a line for each section this lecture put material in,
dated; new entries under `## Signposted` for what the lecture pointed at without
reaching; anything you could not place under `## Unplaced`. Leave the outline's shape,
the inference note and the existing annotations alone.

If you find yourself wanting to rewrite the outline rather than add to it, that is
the signal that this lecture has broken the structure. Add your entries where they
least distort it, note the problem under `## Structural pressure`, and recommend
`/organize` in the report.

Create the file on first run if it is absent, following the format in
`ORGANIZATION.md`. Every line must be traceable to a lecture: a section exists in
`TOPICS.md` because a lecture put material in it, or because the lecturer explicitly
said we would come back to it, never because the topic is one a course on this
subject would normally reach.

```
<!-- No syllabus for this course. Structure is inferred from lectures and revised
     as they arrive. Currently reads as: <the basic objects> first, with <the running
     thread> tying them together; <later topic> may want its own chapter. -->

## 1. <Chapter Title>  -> Chapters/1_Intro/
  1.1 <Section Title>        [<date>]

## Signposted
  <result the lecturer stated and did not prove> — posed <date>, left open

## Unplaced
  <topic> (mentioned <date>)

## Structural pressure
  1.1 is at 340 lines across 6 subsections [noted 2026-09-02] — over the corpus
  range for a section; probably wants splitting. Run /organize.
```

If this run's material makes the existing structure wrong rather than incomplete,
record it under `## Structural pressure` with what you observed, and recommend
`/organize` in the report. Do not act on it here: renaming a chapter renumbers every
label under it, and that belongs in a diff of its own.

### 6. Verify

1. **Ledger check** — walk the ledger and name the file and section each item landed
   in. Anything unaccounted for is a bug; find it before continuing.
2. **Diff check** — re-run the diff from the watermark and confirm every added line is
   now accounted for, either placed or consciously left. This catches the failure the
   ledger cannot: material that was never ledgered because you did not see it.
3. **The inbox** — if the material came from `todays_lecture.tex`, that file still
   exists, holds nothing but its header comment, and is still `\input` from its
   chapter file. An emptied inbox renders nothing.
4. **Build** — `latexmk -pdf -outdir=TeX_Outputs main.tex`. It must compile. Check
   the log for undefined references and duplicate labels, which are the usual
   symptoms of a botched move.
5. Refresh the committed `TeX_Outputs/main.pdf` (it is tracked deliberately).

### 7. Branch, commit, PR

Never integrate directly on `main`.

```bash
git checkout -b integrate/<lecture-date>
git add -A && git commit    # subject: "Integrate lecture of <date>"
git push -u origin integrate/<lecture-date>
```

If the push fails on credentials, the remote is HTTPS but the machine may only have
an SSH key. Retry once over SSH without rewriting the remote:

```bash
git push git@github.com:thefundamentaltheor3m/<REPO>.git HEAD:refs/heads/integrate/<lecture-date>
```

Then **always attempt the PR** — `gh` is present on some of the user's machines and
not others, so check rather than assume:

```bash
gh auth status                  # gh installed and authenticated?
gh pr create --base main --title "Integrate lecture of <date>" --body-file <file>
```

Write the body to a file rather than passing `--body` inline, so the report survives
shell quoting, and do not use `--fill` — the commit message is not a substitute for
the placement rationale a reviewer needs. The body should carry the substance of the
report below: where each group of material went, what existing content moved or was
rewritten, and anything left unplaced.

With `gh` available, use the rest of it too:

- `gh pr view --web` to hand the user a live link, and `gh pr diff` to sanity-check
  the diff you just produced.
- `gh pr checks --watch` to follow the LaTeX build the PR triggers
  (`.github/workflows/publish-latex.yml`). If it fails, read the log with
  `gh run view --log-failed` and fix it on the branch — a red build on `main` breaks
  the published PDF.
- `gh pr edit --add-label` / `gh pr comment` for anything worth flagging separately,
  such as a result you moved but are unsure about.

If `gh` is missing or unauthenticated, say so plainly and print the compare URL
instead — do not treat that as a failure of the integration:

```
https://github.com/thefundamentaltheor3m/<REPO>/compare/main...integrate/<date>
```

## Report back

Close with:

- **What you took as input, and how you found it** — the watermark commit you picked
  and why, the commits and unstaged hunks the material came from, and anything the
  diff surfaced that turned out to be already integrated. If the signals disagreed,
  say how.
- **The date you recorded, and where it came from** — the commit, and whether a date
  written in the file agreed with it.
- **Every heading of the author's that you overruled**, quoting theirs and giving
  yours, with the reason. Put this near the top: it is where your judgment overrode
  the judgment of the person who was in the room, and they have the final say on it
  when they review the pull request.
- Where each group of material went.
- Every existing passage you moved or rewrote, and why.
- The linking prose you added.
- Anything left unplaced or flagged, and the build result.

Be specific about the edits to existing content and about the overruled structure —
those are the ones the author most needs to check, and burying them defeats the
propose-then-apply step.

## Leftover template scaffolding

A repository cut from this template starts out as nothing but scaffolding, and the
first few integrations happen while it is still standing:

```
Chapters/0_Overview.tex                     one template sentence
Chapters/1_Intro/1_1_Imp_Defs.tex           placeholder section
Chapters/1_Intro/1_2_Another_Section.tex    placeholder section
Chapters/2_Another Chapter/                 placeholder chapter, two placeholder sections
Chapters/Appendices/                        placeholder, \input commented out in main.tex
```

Offer to clear whichever ones are actually in your way — but ask first, and never
delete a file that has acquired real content. Scaffolding is a structural problem
rather than an integration one, so otherwise leave it and recommend `/organize`.

Note in particular that `Chapters/1_Intro/` is **not** a misnomer once chapter 1
acquires a real title: `1_Intro` is the author's directory name for chapter 1 across
three of the four sibling repositories — including ones whose chapter 1 is titled
*A Recap of Undergraduate Topology* and *Character Theory* — so it is a convention
rather than template residue. Leave it alone.
