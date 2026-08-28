---
name: post-lecture
description: Everything that needs doing after a lecture, in one pass and one pull request — fill the `\sorry` gaps, address the `% [CLAUDE]` directives, check the mathematics for correctness, convert spellings to American, and integrate the result into the chapter structure. Works out which material is the latest lecture's from the git diff. Use when the user says "/post-lecture", "do the post-lecture pass", "process today's lecture", "I've just finished a lecture", or otherwise asks for the whole after-lecture routine rather than one part of it.
---

# The post-lecture pass

Five things need doing after a lecture, and doing them separately means five branches,
five pull requests and five reviews for one lecture's worth of work. This skill runs
all five on one branch and opens one pull request.

**It is a composition, not a skill with a scope of its own.** It adds no rules about
how to write, what mathematics to work out, where material goes, or which spellings
are house style — each component skill owns that, and duplicating any of it here would
just create two copies to drift apart. Read each component skill when you reach its
phase and follow it as written. The only things this file decides are what counts as
this lecture's material, the order of the phases, the branching, and how the phases
report.

## The phases, and why in this order

| | Phase | Skill |
| --- | --- | --- |
| 1 | Fill the marked gaps | `.claude/skills/fill-sorries/SKILL.md` |
| 2 | Address the inline directives | `.claude/skills/address-comments/SKILL.md` |
| 3 | Check the mathematics | `.claude/skills/check-correctness/SKILL.md` |
| 4 | Convert spellings | `.claude/skills/americanise/SKILL.md` |
| 5 | Integrate the new material | `.claude/skills/integrate/SKILL.md` |

The order is not arbitrary and should not be rearranged. The shape of it is: **write
the material, then check it, then tidy it, then move it** — every phase that produces
text runs before every phase that inspects text, and integration goes last because it
should be moving finished passages rather than half-finished ones.

**`/fill-sorries` goes first** because it writes the most and reaches the furthest. It
is authorized to reshape the passage it is filling — split a proof into a lemma, add
an example, promote a remark — and doing that after the other phases have worked over
the same passage would waste their work and strand their edits. It also runs while the
lecture's own context is still intact and in one place, which is exactly what a
half-written argument needs to be reconstructed.

**`/address-comments` goes second**, on arguments that are now complete. A directive
like "finish proof using previous lemma" reads very differently before and after the
gap two lines above it has been closed.

> Where a `% [CLAUDE]` directive sits on the same gap as a `\sorry` — a marker with
> "prove this" written beside it — **the directive wins and phase 1 leaves it alone.**
> A scoped instruction the author wrote by hand is `/address-comments`' job, as
> `fill-sorries/SKILL.md` says itself. Phase 1 fills the bare markers; phase 2 fills
> the ones that came with instructions.

**`/check-correctness` goes third**, once every word this lecture is going to acquire
has been written. It checks the author's raw notes *and* what phases 1 and 2 wrote,
which is the point of putting it after them: the passages this run generated are new,
unreviewed mathematics and want checking more than the settled notes do. It also runs
while the material is still in lecture order and in one place, so a statement and the
argument that depends on it are still adjacent.

**`/americanise` goes fourth**, so that it catches the prose of all three phases
before it. The author writes British English by habit and the raw notes need
converting; phases 1 through 3 also write prose, and sweeping first would miss every
word of it.

**`/integrate` goes last.** Everything it moves is by then finished, checked and
correctly spelled, which is a much better thing to redistribute than raw notes. The
cost is that the linking prose `/integrate` writes itself never sees the spelling
sweep — so **phase 5 writes American spellings directly** (`STYLE.md` requires it
anyway), and the verification step below re-greps the diff for British spellings as a
cheap backstop. Do not "fix" this by running `/americanise` again as a sixth phase:
one spelling commit per lecture, and a handful of words caught in the final grep.

## Finding the latest lecture

Every phase here is scoped to **one lecture's material**, and working out which
material that is happens once, up front, before phase 1 starts.

**The git diff is the source of truth.** `/integrate` carries the full procedure —
establish a watermark, take the diff from there to `HEAD`, and take the union with the
uncommitted working tree — and it is worth reading before you start rather than
reinventing it. The short version:

```bash
git log --oneline -- TOPICS.md                    # the last integration pass
git log --oneline -20 -- Chapters/ TeX_Setup/     # the rhythm of raw arrivals
git diff <watermark>..HEAD -- Chapters/ TeX_Setup/
git status --short && git diff -- Chapters/ TeX_Setup/   # not yet committed
```

**The author's own markers narrow it.** Raw notes usually carry something that says
where the lecture starts — a leading `% 26 Aug 2026`, a `\subsection{Ramsey Numbers}`
written live, the reusable inbox at `Chapters/1_Intro/todays_lecture.tex`. Use them,
because they are the only thing that can separate two lectures that arrived inside one
diff window, and because the date on one is the sharpest indicator of which lecture
this is. But use them **as corroboration, not as the definition**: they are
conventions the author may not have followed today, and material typed without one is
still this lecture's material. Where a written date and the commit date disagree, ask
— one of them is a typo and guessing picks the wrong one.

Write the scope down as a list of files and line ranges, and **give the same scope to
every phase.** This is the one thing this file adds to the component skills, and it
matters, because three of them will otherwise take the whole document: `/fill-sorries`
sweeps every `\sorry` in the repository, `/address-comments` every directive,
`/americanise` every British spelling. Under `/post-lecture` all three are confined to
this lecture. A marker from three lectures ago that nobody has closed is not this
run's business; note it in the report and leave it.

Two exceptions, both narrow. `/check-correctness` follows a correction into an earlier
section when the passage it is checking depends on one — a `\Cref` pointing at the
wrong result, a definition that contradicts this lecture's use of it. And `/integrate`
necessarily writes into the sections it places material in. Neither licenses a general
sweep of settled notes.

## One branch, five commits, one pull request

Each component skill has its own "branch, commit, PR" step. **Those are overridden
here.** Do not create five branches and do not open five pull requests.

```bash
git checkout -b post-lecture/<lecture-date>
```

Commit **once per phase**, with the phase named in the subject. Five commits rather
than one, because the phases are very different kinds of change and the author needs
to tell them apart in review: what was invented to close a gap, what was written to
satisfy a directive, what was corrected, what is a cosmetic spelling sweep, and what
merely moved. `/americanise` in particular touches a lot of lines shallowly, and
folded into one commit it would swamp the changes that need real attention.

### The pull request opens after phase 3

`/check-correctness` requires a pull request to exist, because its two independent
review rounds happen on the review thread rather than in the report. So:

1. After phase 3's commit, push the branch and open the pull request **as a draft**.
2. Run `/check-correctness`'s two review rounds there, against the phase-3 commit,
   while that diff is still the head of the branch and still reviewable on its own.
   Waiting until the end would hand the reviewers a diff in which every corrected
   line had also been respelled and moved to another file.
3. Then carry on with phases 4 and 5 on the same branch.
4. Update the pull request body at the end (`gh pr edit --body-file`) so it covers all
   five phases, and mark it ready (`gh pr ready`).

If phase 3 corrected nothing, there are no review rounds and no reason to push early:
open the pull request at the end as usual.

## Phases that have nothing to do

Skip them. A lecture with no `\sorry` markers makes no phase-1 commit; a lecture whose
mathematics is clean makes no phase-3 commit; already-American spellings make no
phase-4 commit. Say so in the report. **Never create an empty commit to mark a phase
as having run**, and never manufacture work for a phase to justify its existence —
phase 3 finding nothing to correct is a good outcome, not a failed sweep.

If phase 5 finds nothing new at all, then there was no lecture to process: stop, say
so, and do not open a pull request.

## When a phase cannot finish

Do not abandon the run. Complete the phases that can be completed, and be exact in the
report about what was left and why. A lecture where the gaps were filled, the
directives addressed, the mathematics corrected and the material integrated, with one
`\sorry` left open and two suspect statements flagged, is a good outcome; a lecture
where nothing happened because one directive was unclear is not.

The component skills each say when to stop and ask rather than guess — an ambiguous
`% [CLAUDE]` directive, two readings of a `\sorry`, a statement that is wrong in a way
you cannot fix, a date that disagrees with the commit. Honor that, but **batch it**:
gather the questions and ask them together, at the end, rather than interrupting five
times.

## The approval gate

`/integrate` says to produce a plan and stop for confirmation before writing anything.
That gate exists because placement is editorial judgment and the author is the editor.

When `/post-lecture` is invoked as a single autonomous pass, you cannot stop for it.
`/integrate` already provides for this: say plainly that you are proceeding without
approval, apply the plan, and put the full plan and its rationale in the commit message
and the pull request body instead. The pull request *is* the approval step — which is
why the placement rationale and every overruled heading of the author's have to be
legible there, not merely implied by the diff.

If the author is present and interactive, prefer the gate: show the plan after phase 4
and wait.

**Phase 3's gate is not waivable in the same way.** Its adjudication step — an
independent agent per candidate correction — and its two review rounds are not
approval checkpoints that an autonomous run may skip; they are how the phase works.
An autonomous `/post-lecture` run does all of it.

## Verify once, at the end

Each phase has its own checks; run them. But the build is what matters and it only
needs to pass once, on the final state:

```bash
latexmk -pdf -outdir=TeX_Outputs main.tex
```

Read the log for undefined references and duplicate labels, refresh the committed
`TeX_Outputs/main.pdf`, and confirm the inbox came out as `/integrate` requires. Then
two closing greps over the branch diff:

```bash
git diff main...HEAD -- '*.tex' | grep -nEi '\+.*(colour|neighbour|\wis(e|ing|ation)\b|centre|analyse|labelled|whilst)'
git diff main...HEAD -- '*.tex' | grep -n '^\+.*\\cref{'
```

the first for British spellings phase 5 introduced after the sweep, the second for the
lowercase `\cref` that appears nowhere in these notes.

## Report back

One report, five sections, in phase order — each as its component skill specifies, so
nothing about what to report is decided here. Then, across the whole run:

- **What you took to be this lecture's material, and how you identified it** — the
  watermark, the commits and unstaged hunks, and which in-file marker or date
  corroborated it. If the signals disagreed, say how you resolved it.
- **Which phases ran and which were skipped**, with why.
- **Everything batched for the author**: questions, ambiguities, anything flagged.
- **The corrections and the flags**, hoisted from the phase-3 section, together with
  the outcome of the two review rounds. This and the item below are the two places
  where your judgment overrode the author's, and they should not have to be dug out
  of the middle of a five-part report.
- **The overruled structure**, hoisted from the phase-5 section. It is the single most
  likely thing to want reverting.
- **Markers left in the notes** — `\sorry` you could not close, `% [SUSPECT]` you
  flagged, and any out-of-scope marker from an earlier lecture you deliberately left.
- The build result.

## What this skill deliberately does not include

- **`/organize`.** That is the periodic restructuring pass over the notes as a whole,
  not a per-lecture chore. `/integrate` records structural pressure in `TOPICS.md`
  when it sees it; `/organize` gets run when that has accumulated. Restructuring
  renumbers every result under the heading it touches, and that belongs in a diff of
  its own rather than at the end of a routine pass.

That omission is not an oversight, so do not helpfully add it.
