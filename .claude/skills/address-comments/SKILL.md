---
name: address-comments
description: Find and act on the `% [CLAUDE] ...` directives the author leaves inline in these LaTeX lecture notes — finish a proof, work out an argument that was waved at, insert a figure, elaborate a step — writing as the author would so the result is indistinguishable from their own work. Use when the user says "/address-comments", "address my comments", "do the CLAUDE comments", "handle the TODOs in the notes", or points at one such comment and asks you to deal with it.
---

# Addressing `% [CLAUDE]` comments

While taking notes in a lecture there is no time to finish an argument, draw a
picture, or fill in the arithmetic. So the author leaves a marker:

```tex
% [CLAUDE] insert triangle, pentagon, 7-gon, \cdots here
% [CLAUDE] Finish proof using previous lemma
% [CLAUDE] elaborate on why such a pair always exists by working out the arithmetic. Don't be verbose though, match my expository style.
```

Each one is a small, specific, delegated writing task. This skill executes them.

**The guiding principle is seamlessness.** The deliverable is not "a correct answer
to the comment" — it is a passage that reads as though the author had written it
themselves, at the blackboard, in the same sitting as the paragraph above it. A
reader who never saw the comment should not be able to find the seam. Every rule
below follows from that one.

Read `CLAUDE.md` and `.claude/STYLE.md` before touching anything. `STYLE.md` is the
account of the author's voice and LaTeX conventions, and points at four sibling
repositories written in the same style — [TopologyNotes][t], [LogicNotes][l],
[RepTheoryEPFL][r], [LieAlgebrasNotes][a]. **Read two or three real sections from
those before you write.** The voice does not transfer from a description of it, and
imitation is the entire job here.

A directive that would need a new heading, or would move material between sections,
is a structural change rather than a writing one: read `.claude/ORGANIZATION.md`
before acting on it, and consider whether it is really a job for `/organize`.

[t]: https://github.com/thefundamentaltheor3m/TopologyNotes
[l]: https://github.com/thefundamentaltheor3m/LogicNotes
[r]: https://github.com/thefundamentaltheor3m/RepTheoryEPFL
[a]: https://github.com/thefundamentaltheor3m/LieAlgebrasNotes

## 1. Find them all

```bash
grep -rn "%\s*\[CLAUDE\]" --include=*.tex .
```

Also catch the variants — `% [claude]`, `%[CLAUDE]`, a directive spilling onto a
second comment line — and search `TeX_Setup/` as well as `Chapters/`; a comment about
a macro belongs where the macros are. Quote paths when globbing: some directory names
contain spaces.

If the user named a file, a comment, or a topic, restrict to that. Otherwise take
them all, and list them to the user up front with file, line, and the directive
quoted, so they can see what is in scope before you start writing.

## 2. Read each comment in context, not on its own

A directive is written in the middle of an argument and means almost nothing outside
it. Before writing a single word, for each comment establish:

- **What the surrounding passage is trying to prove**, and how far it has got. Read
  the whole environment it sits in, and the section around that.
- **Which earlier results are in scope.** "Finish proof using previous lemma" names
  a lemma; find it, read its exact statement, and use *that*, not a lemma you would
  have proved. If it does not quite give what the proof needs, that is a finding to
  report, not a license to prove a stronger lemma.
- **What the author already wrote about the same thing.** Often one case of an
  argument is written out and the comment asks for the rest. The written case is
  your template: match its structure, its level of detail, and its phrasing. This is
  the single highest-value thing you can do for seamlessness.
- **Whether the comment is asking for prose, mathematics, a figure, or a macro.**
  These need different things; see §4.

Where a directive is genuinely ambiguous — two readings that lead to materially
different mathematics — ask. One question with the two readings spelled out is
cheap. Guessing wrong and burying it in a plausible paragraph is expensive, because
it is exactly the kind of error that survives review.

## 3. Write it

**Match the density of the prose around it.** This is what "don't be verbose" means
in practice: not "be terse", but "write at the same resolution as the neighboring
sentences". If the proof around your insertion moves in one-sentence steps, your
insertion moves in one-sentence steps. If the author compressed a routine
verification into "This is essentially just definitions.", do not expand the next one
into a display and three lines of justification.

A comment that says *elaborate* is asking for the missing idea, not for volume. Work
out the arithmetic, state the resulting bound or count, and stop. Three sentences
that make the argument land beat two paragraphs that restate it.

**But do not leave the reader stranded.** The author writes to be re-read months
later. The load-bearing step — the inequality that forces the conclusion, the choice
of vertex, the reason the pigeonhole applies — must actually be on the page. Terse is
a style; incomplete is a bug. If the important detail needs a display, give it a
display.

**Voice, from `STYLE.md`:** first-person plural doing real work ("We now show…",
"Indeed, …", "It turns out that…"); a one-sentence bridge before every boxed
environment; American spelling; `` ``LaTeX quotes'' ``; `ie,` and `cf.` inline;
`align*` for displays; one paragraph per source line with no hard wrapping; `\Cref`
and never `\cref`. Case splits go in a `description` with
`\item[\underline{Case…}]`.

**If you cannot honestly complete something, leave `\sorry`** — the red marker the
author uses for a real gap — and say so in the report. A flagged gap is house style,
and `/fill-sorries` is the skill that comes back for it later with a license to work
the mathematics out. A confident hand-wave in its place is the worst possible outcome,
because it looks finished.

**Never silently change the surrounding mathematics.** If the comment's context
contains an error — a statement that is false as written, a case that cannot be
closed the way the author intended — write what you can, flag the problem in the
report, and leave their statement alone. It may well be a slip in the notes; it may
equally be you having misread the lecture.

**Delete the comment once you have satisfied it.** The whole point is that no trace
remains. If you have only partly satisfied it, rewrite it to name precisely what is
still outstanding rather than leaving the original standing as though nothing had
happened. Never delete a directive you did not address.

**Touch nothing else.** No reflowing, no re-indenting, no fixing a typo three
paragraphs away, no "while I was here" improvements. Every hunk in the diff should
be traceable to a comment. Unrelated changes bury the work the user actually needs
to check.

## 4. Macros

**Use the author's macros. Grep before you write any math.**

```bash
grep -n "newcommand\|newenvironment" TeX_Setup/shortcuts.tex
```

`shortcuts.tex` is long and idiosyncratic and there is almost always already a macro:
`\parenth`, `\brac`, `\set`, `\setst{elts}{cond}`, `\abs`, `\floor`, `\ceil`,
`\cycl`, `\R`, `\Z`, `\N`, `\pgcd`, `\pdim`, `\pker`, `\Span`, `\Sym`, `\of`,
`\dist`, … Writing `(x + y)` where `\parenth{x + y}` was available, or `|S|` for
`\abs{S}`, is a visible seam even when the output looks similar — and it is the
first thing the author will notice in the diff.

**The bar for a new macro is high.** Not "this would be tidier" — the bar is that
the notes will genuinely use it repeatedly, or that writing it out inline each time
would be unreadable. When it clears that bar, add it; when it does not, write the
expression out.

The paradigm case that *does* clear the bar is **a picture the course will want
again in a different size or shape**. `shortcuts.tex` already establishes the
pattern in its `% TIKZ:` block — `\drawplane`, `\drawsquare{halfwidth}`,
`\labeledpoint{x}{y}{dx}{dy}{label}` — reusable pictures parameterized by the one
thing that varies. A comment asking for a triangle, a pentagon and a 7-gon is not
asking for three hand-placed `tikzpicture`s; it is asking for one command used
three times:

```tex
% CYCLES:

\newcommand{\cyclegraph}[1]{ % n vertices, drawn on the unit circle
    ...
}
```

What the family is depends on the course — cycle and complete graphs in
combinatorics, Hasse diagrams in order theory, exact sequences in homological
algebra — but the test does not: will the notes draw another one of these?

When you do add one, it must look like it belongs:

- **Append it under the right banner comment** in `shortcuts.tex` (`% TIKZ:`,
  `% DELIMITERS:`, …), or open a new all-caps banner in the existing style if the
  group genuinely does not exist yet. Course-specific additions go under
  `% COURSE-SPECIFIC`.
- **Follow the naming conventions:** `p`-prefix for a parenthesised operator
  (`\pgcd`, `\pdim`), `of`-suffix for parenthesised function application (`\fof`,
  `\Tof`), `\operatorname{}` rather than `\mathrm{}`, and `\!` before the delimiter
  so there is no gap.
- **Parameterise the thing that varies and nothing else.** `\cyclegraph{5}`, not
  `\cyclegraph{5}{1cm}{blue}{above}`. Optional arguments with sensible defaults are
  better than four mandatory ones.
- **Use it everywhere it applies**, including in any existing figure that was doing
  the same thing by hand — but only where a comment sent you.
- **Never define a macro inline** in a chapter file.

`TeX_Setup/packages.tex` lists the available TikZ libraries: `positioning`, `cd`,
`shapes.geometric`, `arrows`, `decorations.markings`. Do not add a package to get a
picture drawn; draw it with what is there.

## 5. Verify

1. **Every comment accounted for.** Re-run the grep. What remains should be exactly
   the directives you consciously left, and you should be able to say why for each.
2. **It compiles.** `latexmk -pdf -outdir=TeX_Outputs main.tex`, run twice or via
   `latexmk` so `cleveref` and the ToC settle. Read the log for undefined references
   and duplicate labels.
3. **Look at the figures you drew.** A `tikzpicture` that compiles is not a
   `tikzpicture` that is right — check the rendered page, and check the graph has the
   number of vertices and edges the surrounding prose claims it has.
4. **Refresh `TeX_Outputs/main.pdf`** if the content changed; it is tracked
   deliberately.
5. **Read your own diff as the author would.** `git diff`, hunk by hunk, asking:
   could I have written this? Is there a sentence here I would not have bothered to
   write? A macro I already had? A paragraph that says in five sentences what I would
   have said in two? Fix those now — this pass is where seamlessness is actually won,
   and it is the pass that gets skipped.

## 6. Commit, push, PR

Never work directly on `main`.

```bash
git checkout -b address-comments/<short-description>
git add -A && git commit    # subject: "Address CLAUDE comments in <area>"
git push -u origin address-comments/<short-description>
```

Then open the PR. `gh` is present on some of the author's machines and not others, so
check rather than assume:

```bash
gh auth status
gh pr create --base main --title "Address CLAUDE comments in <area>" --body-file <file>
```

Write the body to a file rather than inline, so it survives shell quoting. If `gh` is
missing or unauthenticated, say so plainly and print the compare URL instead — that
is not a failure of the work:

```
https://github.com/thefundamentaltheor3m/<REPO>/compare/main...address-comments/<short-description>
```

## Report back

One entry per comment, in file order: the directive, what you wrote, and — where it
matters — why you wrote it that way rather than another. Then, separately, the things
the author must check:

- **Mathematics you supplied**, called out as such. Anything you proved, counted or
  bounded that the lecture did not, is the highest-risk content in the diff and
  should be at the top of the list. Name the earlier results you leaned on.
- **New macros**, with what they do and where they are used.
- **Anything left `\sorry`**, and what is missing.
- **Anything you think is wrong** in the surrounding notes, quoted, left unchanged.
- **Ambiguous directives** and the reading you took.
- The build result.

Be specific and be brief. The author is going to read this and then read the diff;
the report's job is to point at the parts of the diff that need their judgment, not
to summarize the parts that do not.
