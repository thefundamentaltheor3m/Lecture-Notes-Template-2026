---
name: americanise
description: Convert British spellings to American spellings across these lecture notes. American spelling is the house standard (see `.claude/STYLE.md`), so lecture notes that were taken with British spellings should be run through this before they settle. Triggers on "/americanise", "/americanize", "americanise the notes", "americanize spellings", "fix spellings to American".
---

# Americanising the notes

The house style for these notes is **American spelling** (see `.claude/STYLE.md`).
The author writes British English by habit, so a lecture's raw notes may come in
with *colouring*, *neighbour*, *organise*, *centre*, *analyse*, and the like.
This skill converts them.

The skill name is deliberately spelt with an `s`. Someone who already writes in
American English will not think to invoke `/americanise`; someone writing in
British English will.

## Scope

- **Files touched:** `*.tex` under `Chapters/` and `TeX_Setup/`, plus `TOPICS.md`,
  `README.md`, `CLAUDE.md`, and the files under `.claude/`. American spelling
  is uniform across the repo — instructions to future assistants should read the
  same way as the notes they describe. Do **not** touch `LICENSE`, `.git*`, or
  `TeX_Outputs/`.
- **Do not touch citation keys, labels, or macro names.** `\label{Ch1:Colorings}`
  and `\Cref{...}` targets must match the file that defines them; if a label
  needs renaming, that is a separate refactor.
- **Do not touch bibliography entries** (`TeX_Setup/References.bib`): titles are
  quoted verbatim from their source.
- **Do not touch `LICENSE`, `LICENCE`, or the word `licence` inside a legal file.**

## Substitutions

Apply these transformations, case-preserved (upper, lower, and title-case as
they appear). The list is not exhaustive; if you spot another British spelling
in the changed files, convert it and note it in the report.

| British | American |
| --- | --- |
| colour, colouring, coloured, colourable, colourability, colouration, colourful | color, coloring, colored, colorable, colorability, coloration, colorful |
| neighbour, neighbourhood | neighbor, neighborhood |
| organise, organised, organising, organisation | organize, organized, organizing, organization |
| generalise, generalisation | generalize, generalization |
| realise, realisation | realize, realization |
| recognise, recognisable | recognize, recognizable |
| characterise, characterisation | characterize, characterization |
| utilise, utilisation | utilize, utilization |
| optimise, optimisation | optimize, optimization |
| summarise | summarize |
| specialise, specialisation | specialize, specialization |
| categorise | categorize |
| centralise, centraliser | centralize, centralizer |
| stabilise, stabilises | stabilize, stabilizes |
| parameterise, parameterised | parameterize, parameterized |
| analyse, analysed | analyze, analyzed |
| labelled, labelling | labeled, labeling |
| modelling | modeling |
| travelling | traveling |
| cancelled, cancelling | canceled, canceling |
| grey | gray |
| centre, metre, litre, theatre | center, meter, liter, theater |
| defence, offence | defense, offense |
| licence (noun) | license |
| practise (verb) | practice |
| programme | program |
| catalogue, dialogue, analogue | catalog, dialog, analog |
| whilst, amongst | while, among |
| learnt, dreamt, spelt | learned, dreamed, spelled |
| rigour, savour, humour, vigour, honour, favour, labour | rigor, savor, humor, vigor, honor, favor, labor |
| acknowledgement | acknowledgment |

## Procedure

1. **Enumerate the target files.** Files under `Chapters/`, `TeX_Setup/*.tex`,
   `TOPICS.md`, `README.md`, `CLAUDE.md`. Skip `TeX_Setup/References.bib`.
2. **Apply the substitutions.** A `sed -i -e 's/…/…/g'` pass per pattern is
   fine; case-preserving `perl -pi` also works. Keep upper/lower/title-case
   forms separate — do not blindly lowercase.
3. **Rename files whose names carry a British spelling.** Use `git mv`, and
   update every `\input{…}` and `\include{…}` pointing at them. Grep the repo
   after the rename to catch stale references.
4. **Rebuild the PDF.** `latexmk -pdf -outdir=TeX_Outputs main.tex`, twice if
   `latexmk` does not decide to run pdflatex again on its own. Confirm the PDF
   still compiles and commit the refreshed `TeX_Outputs/main.pdf`.
5. **Report.** List which files changed, which files were renamed, and any
   British spellings you deliberately left alone (labels, bibliography, quoted
   source).

## What this skill does not do

- It does not touch the mathematics.
- It does not rewrap paragraphs or reformat code.
- It does not reorganize the notes — that is `/organize`.
- It does not fill `\sorry` markers or answer `% [CLAUDE]` directives.
- It does not rename the skill itself. `/americanise` is spelt with an `s` on
  purpose: someone who already writes American English will never think to
  invoke it, and someone writing British English will.
- It does not touch the British column of the table above, for the same reason.
