---
name: check-correctness
description: Check that the mathematics in these lecture notes is actually correct, and fix what is not — a quantifier over the wrong set, a bound off by a factor of two, a hypothesis the lecture said aloud but nobody wrote down, a sentence with two readings of which only one is true. Every candidate correction is put to an independent agent for adjudication before it is applied, and every run that changes anything is reviewed by two further independent agents on the pull request. Use when the user says "/check-correctness", "/fix-correctness", "check my maths", "check the mathematics", "is what I wrote correct", "sanity-check the lecture", or points at a passage and asks whether it is right.
---

# Checking the mathematics

Notes taken at speed, in a room, while someone is still talking, come out *nearly*
right. A maximum is taken over the wrong set. A `\subseteq` stands where an `\in`
was meant. A bound is stated with $<$ where the argument gives $\leq$. A hypothesis
the lecturer said aloud never made it onto the page, and the statement as written is
false without it. None of this is a failure of the author's — it is what live notes
are — but all of it is a trap for the author re-reading them in six months.

This skill finds those and fixes them. It is the only skill in the repository whose
subject is the *truth* of what is written rather than its wording, its placement or
its completeness.

Read `CLAUDE.md` and `.claude/STYLE.md` before touching anything. The corrections you
make are prose in the author's voice like any other, and a fix that reads as though
an assistant wrote it has failed even when the mathematics is right.

## The guiding principle: change as little as possible

**The author's text is the default, and the burden of proof is on you.** Every edit
here is you overwriting the record of what a lecturer said with what you believe is
true, in someone else's notes, in someone else's voice. That is worth doing when the
notes are wrong. It is expensive when they are not.

So the target is the smallest edit that makes the passage correct and clear. In order
of preference:

1. **A one-token repair.** `\subseteq` to `\in`, `v \in H` to `v \in V(H)`, a
   subscript that clashes with a bound variable, a $2^k$ that should be $2^{k-1}$.
   Nothing around it moves.
2. **An inserted clause.** The missing hypothesis, the quantifier that was implicit,
   the "for $n \geq 3$" that the statement needs. Added inside the existing sentence,
   in the author's phrasing.
3. **One sentence rewritten.** The statement was wrong in a way that a repair cannot
   reach, so it is restated — as close to the original wording as the mathematics
   allows.
4. **The passage reworked.** Reserved for something actually false. Rare, and it
   comes with a marker and a paragraph in the report.

Never take a correction as license to improve the exposition around it. Tightening a
proof you happened to be reading, adding a remark you think is missing, renaming
notation you find clumsy — all out of scope, all `/organize`'s or nobody's. If a
passage is genuinely unsalvageable, say so in the report and leave it.

## What is not a correction

More candidate corrections are wrong than right, and the ones that are wrong are
wrong in a predictable way: the author is compressing, and you have read the
compression as an error. Before anything becomes a candidate, rule out all of these.

- **The corpus's own idioms.** These notes and the four sibling repositories that
  share their style — [TopologyNotes][t], [LogicNotes][l], [RepTheoryEPFL][r],
  [LieAlgebrasNotes][a] — have settled conventions. Writing $x \in L$ for an element
  of a Lie algebra and $\brac{x, y}$ for its bracket without restating either is an
  abuse of notation the author uses deliberately and consistently. Grep the corpus before calling one an error: an
  abuse used everywhere is notation, and an abuse used once is a slip.
- **Deliberate terseness.** "This is essentially just definitions." is not a gap.
  `STYLE.md` says steps that are genuinely mechanical get compressed, and a
  compression is not an omission.
- **A gap that is marked.** A `\sorry` is an acknowledged hole and belongs to
  `/fill-sorries`. A `% [CLAUDE]` directive is delegated work and belongs to
  `/address-comments`. Neither is a correctness defect; leave both exactly where they
  are, even when you can see what should fill them.
- **A gap that is not marked.** An argument that simply stops, a case never covered,
  a result asserted and never proved: incomplete is not incorrect. Report it and
  suggest a `\sorry` site. Do not fill it, and do not fix the surrounding statement
  to make the missing part unnecessary.
- **Anything true under any reasonable reading.** If the sentence is true as written,
  it is not a candidate, however you would have phrased it.

[t]: https://github.com/thefundamentaltheor3m/TopologyNotes
[l]: https://github.com/thefundamentaltheor3m/LogicNotes
[r]: https://github.com/thefundamentaltheor3m/RepTheoryEPFL
[a]: https://github.com/thefundamentaltheor3m/LieAlgebrasNotes

## What is

Three tiers, and the tier decides how much you may move.

| Tier | What it is | What you do |
| --- | --- | --- |
| **Ambiguity** | The text admits two readings, and one of them is false or the two prove different things. A quantifier whose scope is unclear; a symbol reused for two objects; "this" with two antecedents. | Disambiguate towards the reading that makes the surrounding argument work, with the smallest insertion that closes the other reading off. Say in the report that you chose, and what the other reading was. |
| **Inaccuracy** | One reading, and it is wrong in a way that does not break the argument: a constant, an index, an inequality direction, a missing hypothesis, a cross-reference pointing at the wrong result, a number that does not come out. | Repair it in place, tier 1 or 2 above. The argument is the author's and survives intact. |
| **Flaw** | The statement is false, or the proof does not prove it, or two passages contradict each other. | Fix it properly if you can see how — and mark it, because you have changed the mathematics. If you cannot see how, **flag it and change nothing.** |

**Flaws are unlikely.** These notes are taken by someone who knows the material from
a lecturer who knows it better. If your sweep turns up several, the probability is
overwhelming that you have misread the notation, not that the lecture was wrong.
Go back and re-read the section from the top before you believe yourself.

Not knowing how to fix something is a perfectly good outcome and much better than a
guess. Leave the text untouched, mark the site, and put it in the report:

```tex
% [SUSPECT] the bound $3.8^k$ does not match the $4^k$ standard in the literature; left as written pending the author
```

## Marking what you changed

Provenance matters here for the same reason it matters in `/fill-sorries`: the notes
are a record of what a lecturer said, and you are editing that record.

**Anything that changes what a statement says gets a marker**, on its own line, above
the passage, carrying the original so the author can revert it by eye rather than by
git archaeology:

```tex
% [CORRECTED] was: $\Delta = \max_{v \in H} \dots$ — the maximum is over vertices, and $\Phi_i$ took a bound argument
```

**Pure notational slips do not.** A `\subseteq` that should be an `\in` where no
reading of the original was true does not need a comment line in the source; a line
in the report is enough. Markers exist so the author can find the places where the
mathematics is no longer theirs, and burying those among a dozen typo notices defeats
the purpose.

**Never write a `% [CLAUDE]` marker.** That is the author's channel for delegating
work, and a `% [CLAUDE]` line you write is work the next `/post-lecture` run will
silently do. If you want something done that you are not doing, the report is where
it goes.

## Every candidate correction is adjudicated

This is the part of the skill that is not negotiable, and it applies to *every*
candidate — the one-token typo as much as the false theorem. **You do not get to
decide that the notes are wrong.** An independent agent does.

The reason is specific rather than ceremonial. By the time you have a candidate you
have already built a story in which the notes are mistaken, and every further look at
the passage is spent confirming it. That is exactly the state in which the corpus's
own notation looks like an error. An agent that has never seen your story cannot
inherit it.

### Launch one agent per candidate, with a fresh context

A new `Agent` call every time — `subagent_type: "general-purpose"`, so it can read
the repository for itself. **Never** `SendMessage` to an agent that has already ruled
on something: its context is no longer neutral. Independent candidates can and should
go out in one message so they run concurrently.

One agent covers one *correction*, not one edit site. The same slip repeated at five
places in a passage — a notational change applied throughout, one constant wrong in
every line of a derivation — is one candidate and one agent. Two unrelated candidates
in adjacent lines are two agents.

### The brief

The agent's sole job is to reconcile the two statements and rule between them. Give
it everything it needs to do the mathematics, and nothing that tells it what you
concluded.

```
The repository in the working directory holds LaTeX lecture notes for a
university mathematics course. Read whatever you need from it — the files under
`Chapters/`, `TeX_Setup/shortcuts.tex` for what the macros mean,
`TeX_Setup/environments.tex`. Do not edit any file.

Here is a passage from `<file>`, lines <a>-<b>, verbatim:

    <the passage, with enough of what surrounds it that the notation is determined>

The definitions, notation and earlier results in force at that point:

    <quoted from the notes — do not paraphrase them>

Two statements are in play:

  (A) <one of them, verbatim>
  (B) <the other, verbatim>

Work the mathematics out yourself, from first principles, before you compare
them. Then rule, in exactly one of these ways:

  - A is correct and B is wrong
  - B is correct and A is wrong
  - both are wrong, and the correct statement is <yours>
  - both are defensible: they differ in a convention, not in mathematics
  - undecidable from what you were given: the text admits both readings and
    nothing here settles which was meant

Then give the derivation that supports the ruling, and name the single weakest
step in your own reasoning.

Do not propose rewordings, restructurings or improvements to the exposition.
The question is which statement is true, and nothing else.
```

What the brief must **not** contain, in any form:

- **Which of A and B came from the notes**, or which one you favor. Put the notes'
  reading in slot A for some candidates and slot B for others, so that a positional
  bias cannot systematically favor your own proposal.
- **Your reasoning**, your confidence, or how you came to look at this passage.
- **The rulings of other adjudicators**, or how many candidates this run has.
- **Anything that reads as a request for agreement.** "I think the notes have this
  wrong, can you confirm?" is not an adjudication, it is a rubber stamp.

### Acting on the ruling

| Ruling | What you do |
| --- | --- |
| **The notes are correct** | Drop the candidate; change nothing. Report it as a false alarm, with what misled you — that list is the most useful thing this skill produces, because it is what stops the next run from making the edit. |
| **Your reading is correct** | Apply the smallest edit that makes the notes say it, per the tiers above. |
| **Both are wrong** | The agent's statement is now itself a candidate. Adjudicate it with a *fresh* agent before you write a word of it. |
| **A convention, not a discrepancy** | Change nothing — unless the notes use both conventions in one argument, in which case make them consistent, preferring the author's more frequent usage, and report it. |
| **Undecidable** | The tier-1 ambiguity case. Disambiguate towards the reading that makes the surrounding argument work, with the smallest insertion, and report the choice. If neither reading makes it work, that is a flaw you cannot fix: `% [SUSPECT]` and flag. |

**Never apply a correction that no adjudicator ruled for.** Not the obvious ones, not
the trivial ones, and not the one you are quite sure about. The whole design is that
the passages you are most confident about are the ones where confidence is worth
least.

## Style is not relaxed

The prose you write is prose in these notes. `.claude/STYLE.md` governs it exactly as
it governs everything else: first-person plural, one-sentence bridge before every
boxed environment, `align*` for displays, one paragraph per source line and no hard
wrapping, `` ``LaTeX quotes'' ``, `---` for dashes, `\Cref` and never `\cref`, case
splits in a `description`, American spelling. Grep `TeX_Setup/shortcuts.tex` before
writing raw math.

Two mechanical rules matter more here than anywhere else, because this skill's diffs
are small and surgical and a stray reflow buries them:

- **Never reflow a line you were not otherwise changing.** A correctness diff should
  be readable line by line.
- **Keep the author's phrasing** wherever the mathematics does not force a change.
  Restating a theorem in your own words when a single symbol was wrong throws away
  the author's voice for nothing.

## Procedure

### 1. Establish the scope

Whatever the user named — a file, a section, a theorem, a passage they pasted. If
they named nothing, take **the latest lecture's material**, found the way
`/integrate` finds it: a watermark commit, the diff from there to `HEAD`, and the
uncommitted working tree, taken as a union. `.claude/skills/integrate/SKILL.md`
carries that procedure in full; do not reinvent it, and do not depend on a filename
or a heading to tell you what is new.

A sweep of the whole document is available on request and only on request. It is
unbounded, and settled material has usually been read several times already.

State the scope before you start, and stay inside it. A correctness pass that wanders
into chapter 1 while nominally checking lecture 7 produces a diff nobody can review.

### 2. Read the section, not the passage

Read every section your scope touches from its first line, plus the definitions and
results it depends on wherever they live. Most false candidates come from reading a
line without the notation that governs it. Then grep `shortcuts.tex` and
`environments.tex` so you know what every macro in the passage actually expands to —
`\setst`, `\parenth`, `\of`, `\abs` — before you judge what it says.

### 3. Build the candidate list

Go through the scope statement by statement and derivation by derivation. Check, at
minimum:

- **Quantifiers and the sets they range over.** The most common live-notes error by
  some distance: a max or sum indexed over the wrong object, a bound variable reused
  as the argument of the thing being defined.
- **Inequality directions and strictness**, and every constant and exponent.
- **The arithmetic.** Actually do it. Every number the notes assert, recomputed.
- **Hypotheses.** Is the statement true as written, or true only with something the
  lecture said and nobody wrote?
- **Whether each proof proves its statement** — not whether it is complete, which is
  a different skill's question, but whether the thing proved is the thing claimed.
  Converses asserted as if proved live here.
- **Notation introduced twice, or used before it is introduced.**
- **Cross-references.** Every `\Cref` points at the result the sentence claims it
  does. Results are numbered per section, so a moved theorem breaks these silently.
- **Consistency with the rest of the notes.** A statement that contradicts something
  earlier is a candidate even when it looks fine locally.

Write the list down, with file, line, what you think is wrong, and what you think it
should say — before adjudicating any of it. A candidate you never wrote down is one
you will forget you dropped.

### 4. Adjudicate, then apply

One fresh agent per candidate, per the section above; batch the independent ones into
one message. Then apply only what came back ruled for, smallest edit first, marking
what changed what a statement says.

### 5. Verify

1. **Re-derive every passage you touched**, adversarially, in its corrected form.
   A correction that introduces a new error is the worst outcome this skill has.
2. **Re-read every edit as a diff.** Is it the smallest edit that does the job? Did
   anything reflow? Is the author's phrasing still there?
3. **Check the corrected statement against the rest of the notes** — earlier results
   it now depends on, later results that depend on it, `\Cref`s in both directions.
4. **Every candidate accounted for**: applied, dropped with a reason, or flagged.
5. **Build.** `latexmk -pdf -outdir=TeX_Outputs main.tex`. Read the log for undefined
   references and duplicate labels.
6. **Refresh `TeX_Outputs/main.pdf`** — it is tracked deliberately.

### 6. Branch, commit, PR

Never work directly on `main`. If nothing was ruled correctable, there is nothing to
commit: say so, report the false alarms and the flags, and stop.

```bash
git checkout -b check-correctness/<scope>
git add -A && git commit    # subject: "Correct the mathematics in <scope>"
git push -u origin check-correctness/<scope>
```

Then open the pull request as a **draft** — the two review rounds below happen on it,
and it should not read as finished until they have.

```bash
gh auth status
gh pr create --draft --base main --title "Correct the mathematics in <scope>" --body-file <file>
```

Write the body to a file so it survives shell quoting. The body must let a reader
check each correction without reconstructing it from the LaTeX: for each one, what
the notes said, what they now say, and the mathematical reason. Where `gh` is absent
or unauthenticated, the GitHub MCP tools (`mcp__github__*`) do the same work; where
neither is available, say so plainly and print the compare URL — but then say equally
plainly in the report that **the review rounds did not happen**, because they cannot
happen off the pull request.

## The two review rounds

**If this run changed anything, its work gets independently reviewed, twice, in
public on the pull request.** Not in your own head, and not in the report — on the
thread, where the author can read both halves of the exchange and see what was
challenged and what was conceded.

Two rounds, two *different* agents, and then it stops.

### Round one

**Launch a reviewer with an empty context.** A fresh `Agent`, given the branch, the
diff and the repository, and told that its sole job is to ascertain whether the
mathematics in the change is correct. It gets:

- the diff, and the files it touches in full;
- the notes' definitions and notation, which it can read for itself;
- the standing instruction to check the *corrected* text on its own merits, not to
  grade your reasoning.

It does **not** get: your candidate list, the adjudicators' rulings, which edits you
were unsure about, or any suggestion of what to look for. An empty context is the
whole value of the thing, and every hint you add spends some of it. Ask it in
particular whether any correction introduced a new error, and whether anything was
changed that did not need changing.

**Post its findings on the pull request, verbatim**, as a review thread — inline on
the lines in question where the findings are line-specific:

```bash
gh api repos/thefundamentaltheor3m/<REPO>/pulls/<n>/comments \
  -F body=@r1-findings.md -f commit_id=<sha> -f path=<file> -F line=<n> -f side=RIGHT
```

A single top-level `gh pr comment` carrying the whole report is acceptable when the
findings are not line-specific. What is not acceptable is summarizing it: the
reviewer's own words go up, and the block says plainly that it is round one of an
independent review by an agent with no prior context.

**Then answer it in the same thread.** Finding by finding: agree and fix, or disagree
and give the mathematical reason. Push the fixes as their own commit — a finding you
accepted and did not push is a finding you ignored. Reply in-thread rather than
opening a new one, so the exchange reads as an exchange:

```bash
gh api repos/thefundamentaltheor3m/<REPO>/pulls/<n>/comments/<id>/replies \
  -F body=@r1-response.md
```

### Round two

**A new agent, with an empty context.** Not the round-one reviewer, and not a message
to it: by the end of round one it has a position to defend, which is precisely what a
second opinion is for. Launch it fresh.

Its brief is the same review task against the branch as it now stands, with one
addition: after it has reached its own conclusions, it should read the round-one
thread on the pull request and say where it disagrees with either side. In that
order — its own reading first, so the exchange it is auditing cannot frame it.

Post its findings and your response the same way, on the same pull request, clearly
labeled round two.

### Then stop

**Two rounds is the whole budget**, and it is spent whether the reviewers found
anything or not; a clean round one is not a reason to skip round two, and a
contentious round two is not a reason to open a third. Anything still unresolved when
round two closes goes into the report and stays in the notes **unfixed**, marked
`% [SUSPECT]`. An unresolved disagreement between two independent readings of a
passage is exactly the situation in which the author, who was in the room, should
decide — and exactly the situation in which a third round of agents would converge on
something confident and wrong.

Mark the pull request ready for review once round two closes (`gh pr ready`), and
follow the build (`gh pr checks --watch`).

## Report back

Corrections first, one entry each, in document order:

- **Where it was**, and which tier.
- **What the notes said and what they now say** — quoted, both.
- **The mathematical reason**, in a sentence or two. Enough that the author can check
  it without opening the file.
- **The adjudicator's ruling**, and the weak step it named in its own reasoning.

Then:

- **False alarms** — every candidate an adjudicator ruled against, with what misled
  you. Do not omit these to make the run look cleaner: they are how the notes' real
  conventions get learned, and a run of nothing but false alarms is a good run.
- **Flagged and unfixed** — what you believe is wrong, why, what it would take, and
  where the `% [SUSPECT]` marker sits.
- **Ambiguities you resolved by choosing**, with the reading you closed off. These are
  the likeliest to want reverting, because the author knows what they meant.
- **Unmarked gaps** you noticed, with a suggested `\sorry` site, not filled.
- **The two review rounds**: what each reviewer raised, what you fixed, what you
  disagreed with and why, and what remains open. Link the threads.
- The build result.

## Where this sits among the skills

Every other skill in this repository is forbidden from doing what this one does.
`/integrate` moves a doubtful statement unchanged and flags it. `/fill-sorries` is
told not to fix the surrounding mathematics to make its proof work. `/address-comments`
does what the directive says and no more. Each of them ends up with a list of things
that look wrong and a standing instruction to leave them alone.

**This is where that list gets acted on.** Which is also the boundary: it corrects
what is written and does not complete it, does not place it, and does not rearrange
it. A gap belongs to `/fill-sorries`, a directive to `/address-comments`, a
misplacement to `/integrate` or `/organize`.
