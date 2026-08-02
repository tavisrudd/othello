# Golden quantum-statistics editorial A/B

## Outcome

The repaired thirteen-page manuscript was frozen as anonymous baseline A, and
a hierarchy-first twelve-page variant B was built without changing the proved
mathematics.  A context-free reader received only two aliased PDFs and selected
B for Physical Review A, grading it **A-minus** against baseline A's **B-plus**.
The selected paper is commit `50161828`, tagged
`golden-quantum-statistics-observable-hierarchy-selected`.

## Frozen comparison

| role | semantic tag | commit | anonymous alias | PDF SHA-256 |
|---|---|---|---|---|
| baseline A | `golden-quantum-statistics-ab-baseline-a` | `c88c4ef5` | Slate | `d0c61850d741c8d4c3013a6b530f102350b8ffe2cc1735c0cd02fdb0bf8d8fda` |
| tested variant B | `golden-quantum-statistics-ab-variant-b` | `9c42409e` | Orchid | `7b73a978606d080f322c9fb20fad86a5d9d6c62038afdd9d494483b5af73013e` |
| selected final | `golden-quantum-statistics-observable-hierarchy-selected` | `50161828` | post-test refinement | `20cbfa987ad87be5ab038f11a1848bcadb9739e28c3d356e649d7b9c400ef330` |

The anonymous files used publication-safe descriptive names and carried no
task identifiers or private workflow paths.  The reader was instructed to
inspect only the aliased PDFs, not the repository, history, sources, or prior
reviews.

## Variant B

- Retitled the paper *Orientation and exchange statistics in the Golden
  six-mode conference interferometer*.  The introduction explains that
  “Golden” preserves the Clebsch-series identity while “conference
  interferometer” names the operational realization.
- Reopened the abstract and introduction around the unframed--calibrated--
  oriented observable hierarchy.
- Promoted the uniform balanced spectrum `{1/5,4/5,4/5}` beside the orbit and
  minimal-orientation-carrier theorem, and stated that its proof is structural
  rather than a census.
- Removed the bounded anomaly corollary and all downstream chiral-filter
  thresholds from the main paper.  The exact arithmetic bundle remains clearly
  marked as supplementary data not invoked by the manuscript.
- Reduced the body decoder material to the operational schedules and initially
  moved the complete table to the certificate.
- Kept the structural balanced-spectrum proof, exact conference matrix,
  marking convention, imported theorem interface, mesh, tomography gate,
  balanced trial budgets, and source-quality boundary.
- Updated the README, trust map, submission record, evidence prose, manifest,
  PDF, and hashes with no internal identifier leakage.

## Blind verdict

The reader retained three headlines from B:

1. the determinant is the unique minimal-degree carrier of relative port
   orientation, while the permanent is calibrated rather than intrinsic;
2. every balanced Boolean control has the exact common spectrum, sharp
   `20/44` boundary, and exchange-sector values;
3. the distance-six determinant code is operational, while direct fermionic
   emulation remains conditional on an undemonstrated antisymmetric
   three-photon qutrit source.

The reader found that B lost no essential reproducibility, mathematical
motivation, Golden/Clebsch identity, or useful experimental content.  The
removed anomaly branch was not missed; in A it read as a second paper and made
the extreme filtered branch dominate a design-limit discussion that should be
about the balanced benchmark.  B's decisive gain was one recognizable PRA
identity: an exact observable hierarchy in a solvable conference
interferometer.

The only mild loss was the compact three-cut decoder table.  The selected
final restores it as a three-row horizontal table, not the full ten-cut
ledger.  A small bibliography-font reduction keeps the final PDF at twelve
pages.  The opening also now states candidly that elementary singular-value
classification supplies the language, while the contribution is its minimal
orientation carrier combined with the exact conference spectrum and calibrated
readout boundary.

## Validation

- baseline A frozen before B edits;
- variant B and selected final frozen under separate semantic tags;
- final paper-local `make check`: green, including all independent source
  replays, public-hygiene checks, TeX build, and warning scan;
- selected final extracted from its tag with no TeX auxiliaries: complete
  `make check` green and fresh twelve-page build;
- final visual inspection: title/abstract, compact decoder, figure, tables,
  references, and all twelve pages sound;
- final source/PDF closure hashes and byte counts recorded in `SUBMISSION.md`;
- no internal task identifier or private path appears in paper-facing files.

The tracked PDF and the fresh extracted build differ by one byte because the
PDF backend metadata is not claimed to be byte-reproducible; the mathematical
manifest and source/replay gates are deterministic, and the frozen PDF hash is
the publication artifact identity.

## `ej` + `tt` closeout and Mystery ledger

The closeout took three cheap gains exposed by the comparison: preserve the
Golden naming bridge, restore the operational decoder in compact form, and
state precisely why the standard orbit language is present.  No removed
mathematical claim was needed to understand or verify the selected paper.

- **Settled:** the anomaly specialization is exact but rhetorically belongs to
  supplementary data or a separate note; a blind reader independently
  preferred its removal.
- **Settled:** “Golden” and “conference interferometer” are complementary names,
  not competing brands; the paper now states the bridge for readers of both
  literatures.
- **Settled:** the complete three-cut decoder earns its space when compressed;
  the full ten-cut ledger remains supplemental.
- **Open and owned:** whether the common balanced spectrum extends to a clean
  order-`2d` theory is the queued pure-theory task C788.
- **External publication gate:** the imported Clebsch theorem remains a visible
  dependency and its public locator is user-owned.  This is not a mathematical
  gap in the local package.
- **Non-goal:** the PDF backend is not byte-reproducible across clean builds;
  the frozen PDF is hash-identified, while all mathematical evidence is
  deterministically replayed.

No further genuine mystery remains in the editorial comparison.  The
discovery-track discriminator sends nothing to the discovery log: every
finding above was sought by the A/B task, and the only research continuation
already has its own allocated owner.
