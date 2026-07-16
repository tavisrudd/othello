# The Clebsch hexagon code — paper lane (`clebsch`)

**Lane**: `clebsch` — see `AGENTS.md` § Lane routing.

**Date**: 2026-07-15

> **LIVE MAP ONLY. DO NOT APPEND SESSION LOGS, EXPLORATION, REVIEW TRANSCRIPTS, OR
> SUPERSEDED PLANS HERE.** Put history in
> [`done/2026-07-13-clebsch-paper-archive.md`](done/2026-07-13-clebsch-paper-archive.md),
> and put individual findings in dated `notes/` reports.

## Goal and current verdict

Finish the Clebsch-hexagon paper as a self-contained, honestly attributed,
computer-assisted rigidity/classification paper with archived reproducibility artifacts.
Current assessment: **manuscript and local reproducibility closed; immutable archival release still
required**.

Authoritative manuscript and checkers:
[`papers/clebsch-hexagon-code/`](../../papers/clebsch-hexagon-code/).
Rendered paper:
[`clebsch_hexagon_code.pdf`](../../papers/clebsch-hexagon-code/clebsch_hexagon_code.pdf).
Paper registry: [`papers-index.md`](../../papers/papers-index.md), alias `clebsch`.

## Integrated theorem spine

- Rigidity: among six-arcs of `PG(2,11)`, conic containment of the full
  maximum-distance syndrome locus characterizes the Clebsch class and recovers `A5`.
- Quantitative refinements: sharp nearest-conic gap, 252 perturbations in eight `A5`
  orbits, and the intrinsic unordered `10+10` leader-support chirality.
- Decoding: the syndrome conic is a constant-time distance oracle; the complete ambiguity
  census reconstructs the Brianchon/Petersen support geometry.
- Conceptual geometry: the `A5` point-orbit decomposition is
  `[6,10,12,15,30,30,30]`; the unique 12-orbit supplies the conic.
- Low-degree rigidity: only Clebsch lies on a curve of degree at most three; one sharp
  quartic companion class begins the minimal-exact-degree ladder.
- Small-arc classification: for `4 <= k <= 7`, a full conic extension locus occurs only
  for the `PG(2,5)` frame and the `PG(2,11)` Clebsch hexagon.

Detailed result/proof history is preserved in the archive and in reports C180–C187.

## Submission-critical work, in order

1. **Immutable artifact — C182.** Archive code, certificates, sources, and rendered PDF under a
   stable DOI; cite the artifact from the paper.

## Optional high-value follow-ons

- **C206:** conceptual proof/stability theory for the nearest-conic gap.
- **C207:** intrinsic coding interpretation of chirality and the outside `S5` normalizer coset.
- **C208:** all-field `A5` orbit decomposition of uncovered loci, including the `q=19` foil.

These are upgrades, not submission gates unless the manuscript adopts their claims.

## Verification map

- Computation inventory, hashes, clean-source replay, Lean gates, and PDF audit: C168 report above
  (**reported 2026-07-15**).
- The 21-page manuscript now includes a compact frame-normalized census argument, a
  synthematic--Petersen figure, a trust/verification table, the exact two-axiom Dye boundary,
  bounded open problems, and the correct hyperfocused-arc priority chain for the six-arc line bound.
- Priority boundary: C153/C161 are closed by
  [`2026-07-15-dye-bsw-primary-source-audit.md`](../2026-07-15-dye-bsw-primary-source-audit.md)
  and [`2026-07-14-c161-tfae-iv-v-priority.md`](../2026-07-14-c161-tfae-iv-v-priority.md).
- Discovery/open-question log:
  [`2026-07-14-clebsch-discovery-track.md`](../2026-07-14-clebsch-discovery-track.md).
- Literature/priority sources: permanent OCR/images under
  `/tmp/persistent/tavis/lit-search/`, with conclusions recorded in dated git-visible notes.
- Lean roots are listed in C168. Do not launch broad Lean builds from this lane; use the guarded
  single-file or unattended queue tooling described by the Lean build guidance.
- Paper render: from `papers/`, run `make -B clebsch`; inspect the exact Clebsch log for warnings.

## Lane boundaries

This lane owns the Clebsch manuscript, its checker scripts, Clebsch reports, and its exact queue
rows. It does not own Baer/alternate-orbit extensions or the gem-mining lane. Treat their working
changes as foreign unless the user explicitly switches or expands scope.

## Closed-history pointers

- Full accumulated handoff history:
  [`done/2026-07-13-clebsch-paper-archive.md`](done/2026-07-13-clebsch-paper-archive.md).
- Adversarial review, novelty/literature, formalization, decoding, curve, orbit, and small-`k`
  reports are indexed from the archive and discovery track; do not duplicate their prose here.
