# Topics

Where each topic lives. Owned by `/organize`; `/integrate` appends to it.
What earns a chapter, a section and a subsection: `.claude/ORGANIZATION.md`.

**This is the template's copy, and it is empty on purpose.** A repository cut from
this template starts here and fills it in as lectures arrive — the first `/integrate`
or `/organize` run writes the first real entries. What follows is the format, kept as
a worked shape rather than as prose about a format.

Every line in a real `TOPICS.md` must be traceable to a lecture. A section appears
because a lecture put material in it, not because the topic is one the course will
presumably reach.

---

<!-- INFERENCE, not a plan. There is no syllabus for this course and none is coming,
     so every line below traces to a lecture. On the evidence so far the shape reads
     as: <what the chapters look like they are becoming>. The next run should feel
     free to disagree with all of this. -->

## 1. <Chapter Title>  ->  `Chapters/1_Intro/`

```
1.1 <Section Title>                                 [<lecture date>]
    <One sentence: what this line of enquiry is trying to establish.>
      <material that sits above the first subsection>        (preamble)
    1.1.1 <Subsection Title>                        [<lecture date>]
      <one idea>
      <another result under the same idea>
    1.1.2 <Subsection Title>                        [<lecture date>]
      <one idea>
```

`Chapters/1_Intro/` is the author's directory name for chapter 1 across three of
the four sibling repositories, whatever that chapter is titled. It is a convention,
not template residue. Leave it.

## Deliberate deviations

Places where the structure does not yet look like `ORGANIZATION.md` describes,
tolerated on purpose, with the condition that ends each one. Early in a course there
is usually at least one, because there is not yet enough material to look like the
corpus.

```
<the deviation, in one line>
    Why tolerated: <the argument, from the ideas rather than from the line counts>
    Ends when: <the observable condition that should change the answer>
```

## Signposted

Topics a lecture pointed at without reaching. Not sections, and not to be promoted
to sections until a lecture supplies content.

```
<topic>                          posed <date>. <where the notes break off, if they do>
<result asserted without proof>  asserted <date> without justification.
```

## Unplaced

Material `/integrate` could not confidently place. Nothing yet.

## Structural pressure

What `/integrate` noticed but is not allowed to fix — a section doing the work of
three, a chapter whose title has stopped describing its contents. Each entry is a
standing recommendation to run `/organize`. Nothing yet.

## Template scaffolding

What remains of the placeholder content this repository was cut from, and what has
been cleared. Everything under `Chapters/` starts out on this list.

```
Chapters/0_Overview.tex                     placeholder -- one template sentence
Chapters/1_Intro/1_1_Imp_Defs.tex           placeholder section
Chapters/1_Intro/1_2_Another_Section.tex    placeholder section
Chapters/2_Another Chapter/                 placeholder chapter, two placeholder sections
Chapters/Appendices/                        placeholder, \input commented out in main.tex
```

Clear these as real material arrives, not up front, and never one that has acquired
real content.

Three of the four sibling repositories keep an `Appendices/` directory, two of those
with the `\input` still commented out — so leaving that one standing is in keeping
rather than an oversight.

`Chapters/1_Intro/todays_lecture.tex` is **not** on that list. It is the lecture
inbox: infrastructure that stays, gets emptied rather than deleted after each
`/integrate`, and moves to whichever chapter is current with its `\input` line last
in that chapter file.
