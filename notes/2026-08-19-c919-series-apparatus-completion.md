# C919 — de-branded paper fronts and post-conclusion programme codas: completion report

**Lane:** `clebsch` · **Date:** 2026-08-19 · **State:** complete. All five
manuscripts edited, rebuilt, committed, and forward-committed to their
standalone repositories.

Authority commit: `1142b4bad`. Governing documents: the author's implementation
packet `2026-08-18-c919-author-implementation-packet.md` and the revised plan
`2026-08-18-c919-series-apparatus-and-epigraph-plan.md`.

## Preflight result (plan §0)

The checkout already contained Paper II's `\section*{Conclusion}` immediately
before `\appendix` in `clebsch_factorization.tex`. Nothing had to be
reconciled, and no conclusion was drafted, replaced, or added. Every passage
was matched by content and label rather than by the plan's advisory line
numbers, all of which had moved.

## What changed, per paper

### Paper I — `clebsch-rigidity`

- Removed the banner group and the page-1 verse. The title page now carries
  title, author, date, abstract, keywords, and subject classification only.
- Interlude: the motivating-question sentence and the field-uniformity scope
  sentence merged into the opening introduction paragraph; the sentence "Here
  the invariant is the maximum-distance syndrome locus and the source is a
  projective MDS code" was cut as a restatement of the paragraph above it; the
  later-papers sentence and the figure pointer moved to the coda.
- The separate end-of-introduction block moved out: the cross-paper
  architecture sentence was absorbed by the coda's map and independence
  sentence, and the Paper IV citation sentence now closes the coda paragraph so
  the reference survives.
- The programme map moved from the introduction to the coda and its label
  became `fig:programme-map`.

### Paper II — `clebsch-factorization`

- Removed the banner group; the paper had no page-1 verse.
- Interlude: "The classification ranges over every odd prime power" and the
  exceptional-output sentence merged into the opening introduction paragraph;
  the affine-quotient sentence was cut as duplication of the paragraphs on
  either side of it; the standalone-classification sentence moved to the coda.
- Existing conclusion preserved verbatim. The coda sits between it and
  `\appendix`.
- Gained the programme map, which the paper did not previously carry.

### Paper III — `clebsch-passages`

- Removed the banner group.
- Interlude: the three-question roadmap stays in the introduction with the
  `\Needspace`, `\medskip`, and "Reconstruction perspective." wrapper removed,
  so it reads as ordinary introductory prose. The Paper V comparison sentence
  moved to the coda and carries the `RuddCompanion2026` citation with it.
- The coda is a new file, `sections/09-programme-coda.tex`, inputted between
  the conclusion and `\appendix`, and added to `release_files.json`.
- Gained the programme map. Its own route figure `fig:source-shadow-return`
  stays in the introduction.

### Paper IV — `q13-passant-code`

- Removed the whole title group. The first attempt kept its
  `\par\vspace*{12mm}\noindent`, which the plan read as page-1 spacing; the
  cold read showed that spacing was added with the banner and now pushed the
  title below the other four, so it went too.
- Interlude: the fixed-field framing and the least-arity question merged into
  the opening paragraph; the exact-arity sentence landed in the introduction as
  required, shortened to "Unary data there are constant, so the exact
  reconstruction arity is two" because the preceding sentence already names
  \(q=13\) and the recovered plane and polarity. The independence sentence and
  the different-sparse-shadow sentence moved to the coda.
- Coda inserted between the conclusion and the bibliography, and its first
  paragraph names the 364 minimum words plainly, as poem line IV requires.
- Gained the programme map.

### Paper V — `chordal-conference-reconstruction`

- Removed the banner group.
- Interlude: moved to the coda whole, except the clause "the classification
  itself is formulated on the fixed metric carrier", which describes this
  paper's own scope and merged into the first introduction paragraph.
- Conclusion replaced by the two standalone paragraphs fixed in plan §6.1,
  preserving the `\section{Conclusion}` heading and its `sec:conclusion` label.
  The programme-level material became the coda's three paragraphs from §6.2,
  keeping "The scattered shadows gather on one carrier, but not by becoming
  equal" as their opening sentence.
- The programme map moved from the introduction to the coda.

## The coda, identical in all five

Order: `\section*{Clebsch: Rigidity from Sparse Shadows}`, the five-line poem,
the programme map, the logical-independence sentence, then the paper-specific
prose. No prose sits between poem and map.

The poem is set as a two-column tabular with `\scriptsize` Roman numerals in a
subordinate leading column and the five lines beside them, none of which wraps.
The owning paper's whole line is bold; nothing inside a line is emphasized
separately, and the poem reads normally when the emphasis is ignored. The
matching map box is the shaded `active` box. Bold line plus shaded box is the
single emphasis mechanism used in all five.

Map changes: caption language is "Programme map"; the upper-node labels are
`deep-hole conference cubic`, `matching-quotient chordal cubic`,
`golden-descent conference cubic`, and `marked cubic correspondence`, so
Papers I and III are no longer duplicate "conference companion" labels and
"companion" is left to Paper V's technical use; the Paper IV target is the
common two-line `marked conic plane and polarity / with an \(\F_8\)-marking`;
Paper V's box carries a slightly stronger border than the plain boxes; and the
Paper IV branch sits 2.4 cm below the Paper III box so the upper cubic-shadow
cluster and the independent lower branch read apart. The caption and the
independence sentence use the plan's exact wording.

## Layout decisions the source structure forced

- Box labels needed explicit line breaks. At the widths that keep the map
  inside the text block, "deep-hole conference cubic" hyphenated as
  "con-ference"; each upper label now breaks explicitly after its first word
  group.
- Each coda begins on its own page. The first attempt used
  `\Needspace{34\baselineskip}`, which kept the heading, poem, and map together
  but left three papers starting the coda mid-page and two with a half-blank
  page before it. A `\clearpage` before the heading makes the break uniform and
  deliberate in all five, and a second `\clearpage` before `\appendix` in
  Papers II and III keeps appendix front matter off the coda page. This is the
  glue the plan asked to be retuned; the interludes' own `\Needspace` lines
  were removed with them.
- The coda is an unnumbered `\section*`, so it produces no PDF bookmark and no
  contents entry, exactly as the existing AI-assistance disclosure does.

## Gates

- **Statement identity.** Every theorem-like environment in all five sources is
  byte-identical to its committed predecessor, and every per-statement hash in
  Papers II and III is unchanged; only file hashes and source line numbers
  moved. The two tracked `statement_identity.json` manifests were resealed and
  both `--check` runs pass. Paper I's extractor fails before and after this
  task with the same "the theorem-like statements do not match the published
  claim map" error, which is C855's open remediation, not a C919 regression.
- **Builds.** All five rebuild warning-free through their own gates: Paper I 29
  pages (companion 14), Paper II 47, Paper III 35, Paper IV 16, Paper V 22. The
  page-count constants in the manuscript checkers of Papers II, III, and IV
  were updated to match, and every tracked PDF was refreshed through the
  checker's `--update` mode rather than by hand.
- **References.** No `fig:series-map` reference survives anywhere; the two
  forward references from the introductions of Papers I and V moved with the
  figure. No source retains the strings "Reconstruction perspective", "Series
  map", or the banner text.
- **Release surfaces.** Paper III's release verifier still fails only at the
  pre-existing "Paper III" README vocabulary gate, and its allowlist check
  passes with the new coda file included. Paper II's `verify_release.py` fails
  at "evidence fingerprint is stale"; that fingerprint already disagreed with
  the committed manuscript before this task, so the staleness predates C919 and
  belongs to C892, whose refresh path needs the Lean companion. Paper IV's
  evidence verifier fails on a missing Lean source path, also pre-existing.
- **Style guide.** `papers/style-guide.md` gained a "Programme papers"
  subsection recording the front-matter convention adopted here.

## Standalone repositories

All five were synchronized from the authority commit with
`export-paper-repos.py sync`, replayed their own manuscript gate inside the
repository, and were committed forward. `verify` reports each tracked tree in
agreement with its export manifest at `1142b4bad`. Nothing was pushed.

## Metadata consequence

No `.zenodo.json` carried a series label, so removing the banner introduces no
divergence between the PDFs and the deposits. A forward Paper V release will
correct that record's stale title from the deposit metadata alone, closing the
first of the two decisions C918 left open.

## Rebuilt PDFs for review

- `papers/clebsch-rigidity/clebsch_rigidity.pdf` — coda on page 27 of 29.
- `papers/clebsch-factorization/clebsch_factorization.pdf` — coda on page 27 of 47.
- `papers/clebsch-passages/clebsch_passages.pdf` — coda on page 30 of 35.
- `papers/q13-passant-code/passant_code_q13.pdf` — coda on page 15 of 16.
- `papers/chordal-conference-reconstruction/chordal_conference_reconstruction.pdf` — coda on page 21 of 22.

## Cold-read repairs

An independent cold read of the five built PDFs is recorded in
`2026-08-19-c919-cold-read.md`. Its findings that this task caused were repaired
in the manuscripts; findings about text C919 did not touch are documented there
and left alone by explicit instruction.

- **Paper V's stale map reference.** Page 19 still read "explains the last
  arrow in the series map", a positional pointer into a figure that C919 renamed
  and moved to the coda. The clause is gone; the sentence keeps its
  mathematical content. The earlier all-clear missed it because the check was
  case-sensitive and the surviving phrase is lowercase.
- **Paper I's dangling back reference.** The coda said "the \(q=13\) consequence
  recorded above", whose antecedent had stayed twenty-five pages behind. It now
  names the theorem and says where it was noted.
- **Paper I's motivating-question sentence** was merged too early, disclaiming
  specificity to a configuration the introduction had not yet named. It now
  follows the recognition-theorem sentence, where it widens the scope instead.
- **Verbatim repeats between introduction and coda.** Plan §5 merged several
  sentences into the introduction and plan §6's coda prose then contained them
  again. The coda copies were cut: Paper I's field-uniformity sentence and
  Paper IV's arity sentence, the latter of which the reader met on the facing
  page in the conclusion and twice earlier. Paper II's introduction lost the
  merged "The classification ranges over every odd prime power", which restated
  "Over all odd finite fields" three clauses earlier in the same sentence.
- **Paper V's contrastless "itself".** The merged clause "The classification
  itself is formulated on the fixed metric carrier" had lost the foil it
  contrasted with; it now states the contrast locally.
- **Paper IV's title height.** The `\par\vspace*{12mm}` kept inside its title
  group was added in the same commit that introduced the banner, to clear the
  banner from the top margin, and with the banner gone it pushed Paper IV's
  title 34 pt below the other four. The whole title group is gone; all five
  first-word baselines now measure 124.95 pt. Paper IV returns to 16 pages.

## Later refinements

Commit `5d54c316d` replaced the coda's `\Needspace` glue with an explicit page
break in all five papers and started the appendices of Papers II and III on the
page after the coda. Paper II grew from 46 to 47 pages; the other four kept
their page counts. All five standalone repositories were re-synced from
`92486f293` and verified against their export manifests.
