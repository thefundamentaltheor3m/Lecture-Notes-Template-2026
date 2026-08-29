# Document organization

How these notes are carved into chapters, sections and subsections, and what
`TOPICS.md` records. `STYLE.md` is the companion: it governs how a passage *reads*,
this file governs where the passage *lives*.

Read by both skills, for different reasons:

- **`/organize`** treats this file as its standard. Its job is to make the document
  match it.
- **`/integrate`** treats it as a constraint. Its job is to put new material where it
  belongs without disturbing what is already there, and this file tells it whether
  the new material fits an existing section or has earned one of its own.

## There is no syllabus

No list of topics for this course exists and none is coming. Nobody knows what
`Chapters/` should eventually look like. Everything below is therefore a description
of how the author's *other* notes ended up, applied as a target — not a plan handed
down from a course outline.

Three consequences run through the whole file:

1. **Structure is provisional and stays provisional.** Early lectures land wherever
   looked right at the time. By lecture ten it may be obviously wrong. That is
   expected, not a failure.
2. **Nothing exists because a course on this subject "usually" covers it.**
   Every chapter, section and `TOPICS.md` line traces to a lecture, or to a lecture
   explicitly saying we would come back to something.
3. **Prefer the arrangement whose mistakes self-heal.** Some structural mistakes
   correct themselves as lectures arrive; others harden. See
   [Which mistakes to prefer](#which-mistakes-to-prefer).

## The generality ladder

The three levels are three degrees of generality, and that — not size — is what
decides where something goes:

| | holds | answers |
| --- | --- | --- |
| **Chapter** | a body of theory with its own objects and vocabulary | *what are we studying?* |
| **Section** | one line of enquiry within that theory, with a destination | *what are we trying to establish about it?* |
| **Subsection** | one idea | *what is this particular thing?* |

Read down a real chapter from the corpus — [TopologyNotes][t], [LogicNotes][l],
[RepTheoryEPFL][r], [LieAlgebrasNotes][a] — and the ladder is unmistakable:

```
Propositional Logic                          <- the theory
  Propositional Formulae                     <- what the objects are
      Propositions and Connectives
      Truth Functions
      Adequacy
  A Formal System for Propositional Logic    <- how we reason about them
      Formal Deduction Systems
      Constructing a Formal System for Propositional Logic
      Deductions in L
  Important Properties of L                  <- and what that system is worth
      Propositional Valuations
      Soundness
      Consistency
      Completeness
```

[t]: https://github.com/thefundamentaltheor3m/TopologyNotes
[l]: https://github.com/thefundamentaltheor3m/LogicNotes
[r]: https://github.com/thefundamentaltheor3m/RepTheoryEPFL
[a]: https://github.com/thefundamentaltheor3m/LieAlgebrasNotes

Each section has a destination its subsections walk towards, and each subsection is
one nameable thing. That is the whole standard.

**There are no subsubsections.** One appears in 12,277 lines of the corpus. Depth
stops at subsection; below it, use a paragraph break, or `description`/`enumerate`
inside an environment. If material seems to want a fourth level, the section above it
is holding more than one line of enquiry.

## What earns each level

### Subsection — one idea

A definition and what it is for; a single theorem and its proof; one construction;
one property. **The test is nameability: can you title it in a noun phrase, without
an "and" that joins two unrelated things?** *Adequacy*, *Soundness*, *Ideals*,
*Quotients*, *Subnets*, *Cluster Points*, *Tychonoff's Theorem*. "Directed Sets and
Nets" passes, because nets are defined *in terms of* directed sets; "Colorings and
Ramsey Numbers" would not.

**Size is emphatically not the test.** The corpus settles this. *Important Definitions
and First Examples* in LieAlgebrasNotes carries ten subsections — Algebras,
Subalgebras and Homomorphisms, Isomorphisms, Ideals, Quotients, Isomorphism Theorems,
Adjoints, Derivations, Structure Constants, Direct Sums — several only a few lines
long, because each is a distinct idea and the author names each one. In the other
direction, TopologyNotes' *Relating Filters to Nets* is a whole section with no
subsections at all, because it is one idea that happens to be a whole line of enquiry.
Two short ideas are two subsections; one long idea is one.

### Section — one line of enquiry, with a destination

**The test is whether the subsections go somewhere together.** Name the destination in
a sentence: *Important Properties of $\bL$* arrives at soundness, consistency and
completeness, and sets up valuations first because the rest needs them. *The Theory of
Irreducible Characters* arrives at understanding the irreducible characters, via
central functions and the orthogonality theorem. If you cannot say what a prospective
section is trying to establish, it is not a section.

The corollary is the practical rule: **material that continues an existing line of
enquiry becomes a subsection of that section, however much of it there is.** A new
section is for material asking a different question. If two subsections could be read
in either order and neither needs the other, they are probably two lines of enquiry,
and want two sections.

### Chapter — a body of theory

**The test is vocabulary.** A chapter introduces its own objects and the words for
talking about them, and everything under it is about those objects: *Propositional
Logic*, *Character Theory*, *Nets and Filters*, *Set Theory*. If you could imagine a
textbook giving it a chapter, it is a chapter; if it is one thing you want to prove
about objects introduced elsewhere, it is a section.

This is where the absent syllabus hurts most, because a new chapter is a bet on where
the course is going and the bet is expensive to unwind — renaming or splitting a
chapter renumbers every result under it. So:

- Do not open a chapter for material that could be a section of an existing one.
- Do open one when a section's contents have visibly stopped being about what its
  title says, or when the notes have started developing a genuinely new class of
  object.
- Chapter 1 is allowed to look thin early on, because everything starts there. Do not
  "fix" that by inventing chapters 2 and 3.

### Which mistakes to prefer

Early in a course the notes cannot look like the corpus, because there is not enough
material yet. When you have to choose, prefer the arrangement whose mistakes
*self-heal*:

- **A chapter with too few sections self-heals.** Lecture 2 adds section 1.2, with no
  edits to anything already written.
- **A misjudged idea boundary does not.** Splitting one line of enquiry across two
  sections, or fusing two into one, is a conceptual error that stays wrong and gets
  more expensive to undo as material piles on top of it — you are splitting or merging
  files later, renumbering results and chasing stale `\Cref`s.

So a chapter that is temporarily one coherent section beats a chapter of three
sections carved out of one line of enquiry. Record the deviation in `TOPICS.md`
rather than structuring around it.

## The numbers, and how little they are worth

Sizes in the corpus are a *consequence* of the judgments above, not a criterion. They
are recorded here only so that a borderline call has something to fall back on, and
they carry far less weight than anything in the previous section.

<details>
<summary>Measured over 12,277 lines: 14 chapters, 66 sections, 181 subsections</summary>

| Unit | Lines | Contains | Boxed environments |
| --- | --- | --- | --- |
| Chapter | median ≈ 830, range 313–1844 | 2–8 sections, typically 3–6 | — |
| Section | median 148, IQR 99–229 | median 3 subsections, IQR 2–3 | median 9, IQR 5–13 |
| Subsection | median 48, IQR 30–79 | prose and environments only | median 3, IQR 2–5 |

54 of 66 sections have two or more subsections; 8 have none and 4 have exactly one.

</details>

Use them **only** when you have genuinely failed to decide on the ideas, and only in
one direction: as a prompt to go back and look at the ideas again. A section far
outside the range is a reason to re-read it and ask whether it is really one line of
enquiry — it is never, by itself, a reason to split it. Never cite a line count as the
justification for a structural decision; if that is the best reason available, you
have not understood the material well enough to reorganize it.

## Naming

**Chapter directories** are `Chapters/<N>_<Abbrev>/`, with `<Abbrev>` a short
CamelCase or Snake_Case abbreviation of the topic: `2_Nets`, `3_Set_Theory`,
`4_Func_Anal`, `5_Algebraic_Topology`, `2_Char`, `3_Root`.

**Chapter 1's directory is `1_Intro`, by convention, whatever the chapter is called.**
Three of the four sibling repositories do this — including ones whose chapter 1 is
titled *A Recap of Undergraduate Topology* and *Character Theory* — so `1_Intro` is
not template residue and is not a misnomer. Leave it.

**Chapter files** are `<N>_<Abbrev>.tex` inside their own directory, matching the
directory name: `Chapters/2_Nets/2_Nets.tex`. They hold `\chapter{...}`,
`\thispagestyle{empty}`, the chapter's intro prose, any chapter-wide
`boxnotation`/`boxconvention`, and then one `\input` per section in reading order.

**Section files** are `<N>_<M>_<Abbrev>.tex`, abbreviated the same way:
`1_1_Metric_Spaces.tex`, `2_1_Combinatorics.tex`, `1_3_Algebras.tex`. Subsections do
not get their own files — they live inside their section's file.

**Titles** are noun phrases in title case: *Nets and Filters*, *Solvability and
Nilpotency*, *Convergence of Nets*, *Some "Completely Trivial Combinatorics"*. The
author's idiom for a first chapter that really is introductory is *An Introduction to
the Theory of X*, but a chapter 1 with a plain topic title is equally in keeping.

**Labels** follow `STYLE.md`: `Ch<N>:CH` for chapters, `Ch<N>:Sec:<Name>` and
`Ch<N>:Subsec:<Name>` where a section or subsection is actually referenced. Adding a
label to every heading is not house style.

## `TOPICS.md`

The running map of topic to location, at the repository root.

**`/organize` owns this file.** It decides the outline, the annotations and the
inference note. **`/integrate` appends to it**: a line for each section it added
material to, dated with the lecture. If `/integrate` finds itself wanting to rewrite
the outline rather than add to it, that is the signal to stop and hand over to
`/organize`.

Sections:

- A leading HTML comment saying what the structure currently looks like it is
  becoming, explicitly flagged as inference, and free for the next run to disagree
  with.
- The outline: chapters mapped to directories, sections and subsections beneath them,
  each annotated with the lecture date that supplied it.
- `## Signposted` — topics a lecture pointed at without reaching, annotated with the
  lecture that signposted them. Not sections, and not to be promoted to sections
  until a lecture supplies content.
- `## Unplaced` — material that could not be confidently placed.
- Any deviation from the norms above that is being tolerated deliberately, with the
  condition that would end it ("one section for now; revisit at ~3 sections").

Every line must be traceable to a lecture. A section appears here because a lecture
put material in it, not because the topic is one the course will presumably reach.

## Restructuring costs, and who pays them

Results are numbered **per section** (`\newtheorem{theorem}{Theorem}[section]`), so
moving material across a section boundary renumbers it, and moving a section between
chapters renumbers everything in both. After any restructuring:

- grep for `\Cref`s to anything that moved, and for labels whose `Ch<N>:` prefix no
  longer matches their chapter;
- rebuild and read the log for undefined references and duplicate labels;
- check the ToC against the outline in `TOPICS.md`.

Because these costs are real, **`/integrate` does not restructure**. It may create a
section or subsection for material that has nowhere to go, and it may adjust a title
that its new material has made inaccurate — nothing else. Everything beyond that is
`/organize`'s, and `/organize` proposes before it moves.
