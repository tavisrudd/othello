# Clebsch series figure set

Reusable TikZ figures that explain the five-paper Clebsch programme
pictorially.  Each figure lives in its own file, defines a single macro, and
is `\input`-able into any of the manuscripts.  `series-figures.tex` is a
preview sheet that draws all of them; it is a proof sheet, not a paper.

## Building the preview

    nix develop .#manuscript --command latexmk -xelatex \
      -interaction=nonstopmode -halt-on-error series-figures.tex

`make` runs the same command after the shared spacing lint.

## Using a figure in a manuscript

In the host document's preamble:

    \input{../clebsch-series-figures/series-figures-preamble}

That file loads `amsmath`, `array`, `booktabs`, and `tikz` with the
`arrows.meta`, `calc`, `positioning`, `fit`, `backgrounds`, and
`decorations.pathreplacing` libraries, and defines the shared node and
connector styles.  A host that already loads some of those may drop the
duplicate lines; the style definitions are what matter.  Then, in the body:

    \begin{figure}[t]
    \centering
    \input{../clebsch-series-figures/fig-d4-four-shadows}% once, anywhere
    \ClebschFourShadows
    \caption{...}
    \label{fig:...}
    \end{figure}

The `\input` may equally go in the preamble: every figure file only defines
a macro (through `\providecommand`, so a second input is harmless) and draws
nothing on its own.  Captions belong to the host paper, so that each paper
asserts only what it proves or can presently cite.

Every figure is sized to sit inside a 152 mm text block, the width used by
the manuscripts.

| file | macro | what it is for |
|-------------------------------|-------------------------------|------------------------------------------------------------|
| `fig-d1-series-map.tex`       | `\ClebschSeriesMap{<node>}`   | the five-paper series map, with a "you are here" node       |
| `fig-d2-recognition-template.tex` | `\ClebschRecognitionTemplate` | the recognition template and its five instances          |
| `fig-d3-quantifier-ladder.tex`| `\ClebschQuantifierLadder`    | the quantifier range of each portfolio-level general theorem |
| `fig-d4-four-shadows.tex`     | `\ClebschFourShadows`         | the four cubic shadows, billed by what kind of claim each is |
| `fig-d5-minor-ladder.tex`     | `\ClebschMinorLadder`         | principal minors of a Seidel matrix by order                 |
| `fig-d6-causal-spine.tex`     | `\ClebschCausalSpine[<variant>]` | Paper III's chain from incidence cover to shadows          |

## Setting the "you are here" highlight in D1

`\ClebschSeriesMap` takes one argument, the node to emphasise with a heavier
rule and a light grey tint:

    \ClebschSeriesMap{I}      % Paper I's forward version
    \ClebschSeriesMap{II}
    \ClebschSeriesMap{III}
    \ClebschSeriesMap{IV}
    \ClebschSeriesMap{V}
    \ClebschSeriesMap{none}   % no emphasis, e.g. for a portfolio page

Any other argument is treated as `none`.  The central golden-torsor node is
never the highlighted one; it is drawn with a slightly heavier rule in every
variant because it is the object the map is about.  The tint is `black!8`,
chosen to survive black-and-white printing; every other distinction in the
figure set is carried by line style and weight rather than by colour.

## Selecting D6's return arrow

`\ClebschCausalSpine` takes an optional argument choosing which theorem the
return arrow underneath the spine carries:

    \ClebschCausalSpine            % same as [current]
    \ClebschCausalSpine[current]   % the manuscript's reconstruction theorem
    \ClebschCausalSpine[final]     % the triangle–Pfaffian recognition

Any other argument is treated as `current`.  The spine itself — incidence
cover, residue-field pinching, square class, marked bridge datum,
conference operator, shadows — is identical in both.

Use `[current]` in any forward version of Paper III as it stands.  Use
`[final]` only in a version that also states the recognition theorem, since
the drawing tags it as forthcoming and a reader will look for it.

## Which claims are not established, and in which of three senses

Three things in this set fall short of "a theorem the host manuscript
states", in three quite different ways.  They are drawn differently on
purpose and must not be conflated.

* **Unproved — no theorem exists.  The Paper IV edge in D1 is dashed**
  (`csfopen`) **and labelled "recognition genre (bridge unproved)".**  Paper
  IV reconstructs PG(2,13) from the minimum-word layer, which places it
  squarely in the programme's recognition genre, but no current theorem
  carries that reconstructed plane to the oriented cubic torsor.  The bridge
  is an open obligation.  Do not redraw this edge solid, and do not caption
  it as an identification.
* **Unwritten — no paper exists.  The Paper V node in D1 states an intent,
  not a result.**  Paper V is unwritten and the Rosetta theorem — that the
  support cubic, the sheet-sign cubic, and the marked triangle cubic are one
  torsor — is not proved.  The node is labelled "unwritten" and its text
  says "intends".  Until that paper has a stable public locator, captions in
  the numbered papers should point at the identifications rather than at the
  theorem.
* **Proved, awaiting promotion — the theorem exists, the manuscript
  sentence does not.  The return arrow of `\ClebschCausalSpine[final]` is a
  double rule** (`csfforth`) **tagged "proved; awaiting promotion".**  The
  triangle–Pfaffian recognition is proved and formalized; what is pending is
  only its appearance in the Paper III manuscript.  A double rule reads as
  heavier than an ordinary arrow, not lighter, which is the point: this is
  the opposite of the dashed edge above, and drawing it dashed would
  understate it badly.

Everything else in the set is drawn from a manuscript statement, including
D6's `current` return arrow, which is the reconstruction theorem Paper III
proves today.

The `final` label states the human theorem, whose hypotheses are two and do
different jobs: all off-diagonal entries nonzero forces `A² = λI` across the
whole nonzero-edge torus, while the scalar sign locus is what pins the
golden value and yields the unique order-six conference class with its two
outer orientations.  The small note beneath is narrower on purpose: the Lean
formalisation is stated over an integral domain rather than any field of
characteristic ≠ 2, and its orientation split rests on one compiled finite
check rather than on the kernel-checked parity argument of the human proof.
Do not upgrade that note to a claim that the whole statement is
kernel-checked.

## Sources checked

* D1: the ASCII master and the three deliberate features described beneath
  it, in `notes/2026-08-03-clebsch-program-unity-review.md`.
* D2: the abstracts of `clebsch-rigidity`, `clebsch-factorization`,
  `clebsch-passages`, `q13-passant-code`, and `ame_lu`.
* D3: the "Theorems that quantify over infinite families" table of the
  portfolio page, each row rechecked against the paper's own abstract.
* D4 and D5: `clebsch-passages/sections/05-golden-operator.tex` — the
  paragraph before `thm:operator-shadows` and the paragraph "The same
  statement in principal minors".
* D6 (`current`): the `clebsch-passages` abstract and
  `thm:aligned-faithfulness`.
* D6 (`final`): Theorem III and the subsection "Why the recognition occurs
  only in order six" of
  `notes/2026-08-03-c862-paper-iii-spectral-descent-recognition-theorem-packet.md`,
  with the formalisation status taken from
  `notes/2026-08-02-c815-four-shadow-lean-formalization.md`.
