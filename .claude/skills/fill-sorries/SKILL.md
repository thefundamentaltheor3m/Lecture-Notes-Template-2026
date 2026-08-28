---
name: fill-sorries
description: Fill the `\sorry` markers in these LaTeX lecture notes — the red flags the author leaves where a proof was not given, a case was not covered, a computation was skipped, or a lecture broke off mid-argument. Unlike the other skills, this one is authorized to do the mathematics itself: work out the proof, add whatever lemmas and examples it needs, and write the passage. Use when the user says "/fill-sorries", "fill in the sorries", "fill the gaps", "prove the sorries", "close the sorries", or points at one and asks you to do it.
---

# Filling `\sorry`

`\sorry` is borrowed from Lean, and it means the same thing here: *there is supposed
to be an argument here and there isn't one*. The author leaves one when a lecture
skipped a proof, waved at a case, asserted a computation, or simply ran out of time
mid-development.

```tex
Every finitely generated nilpotent Lie algebra therefore admits such a basis. \sorry
```

Closing one is not a patching job. It is a writing job with mathematics in it, and it
is the place in this repository where **you are expected to work things out for
yourself** with the freest hand. (`/check-correctness` also does mathematics, but under
the opposite constraint: it is overwriting the author's, so it changes as little as it
can and has every change adjudicated.)

## You are authorized to work autonomously

This skill is deliberately looser than the others. Read that as permission, and use it.

**Do the mathematics.** Find the proof. If the standard argument needs a lemma the
notes do not have, state and prove the lemma. If it needs a construction, build it. If
a worked example would carry the idea better than another paragraph, write the example.
You do not need to ask before doing any of this.

**Reach outside the course when you need to.** These are notes for one course, but the
mathematics does not stop at its boundary. Use a standard theorem the course has not
covered if that is the honest route to the result — just say in the text that you are
doing so, the way any lecturer would ("by a standard compactness argument", "this is
Ramsey's theorem, which we will not prove"). Prefer machinery the course already has,
because a proof the reader can follow from what they have seen is worth more than a
slicker one they cannot.

**Write as much as the mathematics needs.** `/address-comments` is told to match the
density of the surrounding prose because it is finishing someone else's sentence. You
are supplying material that does not exist. If the gap needs three sentences, write
three; if it honestly needs a lemma, a proof, a corollary and an example, write all
four. Length is decided by the argument, not by the size of the hole.

**Reshape the immediate passage.** You may reorder a proof, split one into a lemma plus
a short main argument, promote a remark to a numbered result, add a `\subsection` if the
material you produced genuinely needs one, and add macros to `shortcuts.tex`. What you
may not do is reorganize beyond the passage you are filling — moving settled material
between sections or renaming a chapter is `/organize`'s, and if your fill turns out to
need that, say so and stop at the boundary.

**Decide, then say what you decided.** Where a `\sorry` admits several readings, pick
the one that best fits what the surrounding argument is trying to do and record the
choice in the report. Only ask when the readings lead to genuinely different
mathematics *and* you cannot tell which the lecture meant.

## What autonomy does not license

Four things, and they are not negotiable.

**Correctness.** A wrong proof is far worse than a `\sorry`, because a `\sorry` is
honest and a wrong proof is a trap the author will re-read months later and believe.
Every step must actually follow. Prove it to yourself adversarially — look for the case
you have not handled, the hypothesis you have quietly used, the "clearly" doing real
work — before you write it down.

**Honesty about what you could not do.** If you cannot close a gap, **leave the
`\sorry` where it is** and say why in the report. Partial progress is welcome: write
what you can, leave the `\sorry` on the part you cannot, and narrow the surrounding
text to say precisely what remains. Never remove a marker you did not earn.

**The author's existing mathematics.** Do not silently change a statement, strengthen a
hypothesis, or fix an error in the surrounding text to make your proof work. If the
result as stated is false or unprovable, say so in the report, and either prove the
corrected statement — flagging loudly that you changed it — or leave the `\sorry`.

**Provenance.** This is the counterweight to the autonomy, and it matters more here
than anywhere else in the repository: the notes are a record of what a lecturer said,
and you are about to put mathematics into them that the lecturer did not say. Mark each
filled gap in the source with a single comment line, invisible in the PDF:

```tex
% [FILLED] proof supplied here; the lecture stated the result without proving it
```

and account for all of it in the report. The author must be able to tell, at a glance
and months later, which arguments are theirs.

## Style is not relaxed

The autonomy is about *what* you write, not *how*. Read `.claude/STYLE.md` and follow
it exactly — first-person plural, a one-sentence bridge before every boxed environment,
American spelling, `` ``LaTeX quotes'' ``, `align*` for displays, one paragraph per
source line with no hard wrapping, `---` for dashes, `\Cref` and never `\cref`, case
splits in a `description`. Read two or three real sections from the sibling
repositories — [TopologyNotes][t], [LogicNotes][l], [RepTheoryEPFL][r],
[LieAlgebrasNotes][a] — before writing; the voice does not transfer from a description
of it.

[t]: https://github.com/thefundamentaltheor3m/TopologyNotes
[l]: https://github.com/thefundamentaltheor3m/LogicNotes
[r]: https://github.com/thefundamentaltheor3m/RepTheoryEPFL
[a]: https://github.com/thefundamentaltheor3m/LieAlgebrasNotes

Grep `TeX_Setup/shortcuts.tex` before writing any raw math — `\parenth`, `\set`,
`\setst`, `\abs`, `\floor`, `\ceil`, `\R`, `\Z`, `\N`, `\pgcd`, `\Sym`, `\dist`, … A
new macro is welcome when the material you are writing will use it repeatedly; append
it under `% COURSE-SPECIFIC` following the existing naming conventions, never
inline.

## Procedure

### 1. Find them

```bash
grep -rn "\\\\sorry" --include=*.tex .
```

Ignore the definition in `TeX_Setup/shortcuts.tex`. If the user named one, or a file,
or a topic, restrict to that; otherwise take them all and list them up front with file,
line, and the sentence the marker sits in.

**Only marked gaps are in scope.** The notes contain unfinished arguments that nobody
has marked — an argument that simply stops, a result asserted and never revisited. If
you spot one, report it and suggest a `\sorry`; do not fill it. The marker is the
author's signal that they want it filled, and filling unmarked gaps would make every
run unbounded.

### 2. Work out what each gap actually is

The kind of gap decides the shape of the fill:

| The gap | What closing it means |
| --- | --- |
| A stated result with no proof | Prove it. |
| A case missing from a proof | Write that case, mirroring the structure of the cases that are there. |
| An assertion with no support | Either prove it, or find the counterexample — the lecture may have been wrong. |
| A skipped computation | Do the arithmetic and show the step that makes it come out. |
| A development that breaks off | The open-ended case. Establish where the argument was going, then take it there. |

For each, before writing: read the whole section it sits in, not just the paragraph.
Know exactly which results are already available to you and what the notation means.
When one case of an argument is written and the marker asks for the rest, the written
case is your template — match its structure and phrasing.

The last row is the hard one. A lecture that breaks off mid-argument leaves you to
reconstruct a destination as well as a route. Say in the report what you took the
destination to be, and how confident you are; if the lecture was heading somewhere you
cannot identify, that is a case for leaving the `\sorry` and saying so.

### 3. Write it

Then check it. Then write the `% [FILLED]` comment and remove the `\sorry`.

If the fill introduces a result the rest of the notes should know about, label it
(`Ch<N>:<Kind>:<Name>`, per `STYLE.md`) and add `\Cref`s in both directions.

### 4. Verify

1. **Every marker accounted for.** Re-run the grep. What remains should be exactly the
   gaps you consciously left, and you should be able to say why for each.
2. **Re-derive every proof you wrote, adversarially.** This is the step that matters
   and the step that gets skipped. Take each argument apart looking for the hole. Check
   the edge cases: $n = 0$, the empty graph, the degenerate case the general argument
   quietly assumes away. If you cannot convince yourself, you have not finished — put
   the `\sorry` back.
3. **Check it against the surrounding notes.** Your proof must not use a result stated
   later in the document, and must not contradict anything stated earlier.
4. **Build.** `latexmk -pdf -outdir=TeX_Outputs main.tex`. Read the log for undefined
   references and duplicate labels. Look at the rendered pages, especially any figure.
5. **Refresh `TeX_Outputs/main.pdf`** — it is tracked deliberately.

### 5. Branch, commit, PR

Never work directly on `main`.

```bash
git checkout -b fill-sorries/<short-description>
git add -A && git commit    # subject: "Fill the sorries in <area>"
git push -u origin fill-sorries/<short-description>
```

Then attempt the PR — `gh` is on some of the author's machines and not others:

```bash
gh auth status
gh pr create --base main --title "Fill the sorries in <area>" --body-file <file>
```

Write the body to a file so it survives shell quoting, and put the mathematics in it:
for this skill the diff is new mathematical content, so the PR body must let a reader
check the arguments without reconstructing them from the LaTeX. Follow the build with
`gh pr checks --watch`. If `gh` is unavailable, print the compare URL instead.

## Report back

The report carries more weight here than in any other skill in this repository,
because everything you wrote is new and unverified by anyone else. For each gap:

- **Where it was**, and what kind of gap it was.
- **The argument, in prose** — the actual mathematical idea, in two or three sentences,
  so the author can check the reasoning without reading the LaTeX.
- **What it depends on**: which results from the notes, and which results from outside
  the course. Call the outside ones out individually; they are where a reader is most
  likely to want a reference.
- **How confident you are, and where the weak point is.** Every proof has a step you
  are least sure of. Name it. "I am confident in all of it" is almost never true and is
  the least useful thing you can say.
- **Anything you changed** in the surrounding text, and why it was unavoidable.

Then, separately:

- **Gaps left unfilled**, with what is missing and what it would take.
- **Unmarked gaps you noticed**, with a suggested `\sorry` site — not filled.
- **New macros, labels and cross-references.**
- **Anything you think is wrong** in the existing notes, quoted, left unchanged.
  That list is the input to `/check-correctness`, which is the skill that acts on it.
- The build result.

## Where this sits among the skills

- **`/address-comments`** executes bounded, specific instructions the author wrote by
  hand. Tight scope, minimal diff, match the surrounding density, ask when unsure.
- **`/fill-sorries`** — this skill — closes gaps the author flagged but did not
  specify. Broad scope, write what the mathematics needs, decide and report.
- **`/check-correctness`** asks whether what is *already written* is true, and fixes
  it as minimally as it can. It is the other skill allowed to do mathematics, but with
  the opposite disposition to this one: here you are supplying an argument that does
  not exist, there you are overwriting one that does, so every correction it makes is
  adjudicated by an independent agent first. A statement you found false while filling
  a gap belongs to it, not to you.
- **`/integrate`** absorbs a lecture. It *creates* `\sorry` markers rather than
  filling them, and does not do mathematics of its own.
- **`/organize`** rearranges. It neither adds nor removes mathematics.

A `% [CLAUDE]` comment that says "prove this" is an `/address-comments` job, because
the author wrote it deliberately and scoped it. A bare `\sorry` is this one.
