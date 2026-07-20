# The Clebsch hexagon code — paper lane (`clebsch`)

**Lane**: `clebsch` — see `AGENTS.md` § Lane routing.

**Date**: 2026-07-20

> **LIVE MAP ONLY. DO NOT APPEND SESSION LOGS, EXPLORATION, REVIEW TRANSCRIPTS, OR
> SUPERSEDED PLANS HERE.** Put history in
> [`done/2026-07-13-clebsch-paper-archive.md`](done/2026-07-13-clebsch-paper-archive.md),
> and put individual findings in dated `notes/` reports.

## Goal and current verdict

Finish the Clebsch-hexagon paper as a self-contained, honestly attributed,
computer-assisted rigidity/classification paper with archived reproducibility artifacts.
Current assessment: **the existing 19-page manuscript and local reproducibility package are closed;
the selected C399 portable theorem must now be integrated under its audited classical/new boundary,
followed by mixed-verification policy integration, exact shared-Lean pinning, the `arcs`
publication-allocation edge, and immutable archival release**.

Authoritative manuscript and checkers:
[`papers/clebsch-hexagon-code/`](../../papers/clebsch-hexagon-code/).
Rendered paper:
[`clebsch_hexagon_code.pdf`](../../papers/clebsch-hexagon-code/clebsch_hexagon_code.pdf).
Paper registry: [`papers-index.md`](../../papers/papers-index.md), alias `clebsch`.

## Integrated theorem spine

- Rigidity: among six-arcs of `PG(2,11)`, conic containment of the full
  maximum-distance syndrome locus characterizes the Clebsch class and recovers `A5`.
- Quantitative refinements: sharp nearest-conic gap and 252 perturbations in eight `A5` orbits.
- Decoding: the syndrome conic is a constant-time distance oracle; the complete ambiguity
  census reconstructs the Brianchon/Petersen support geometry and the intrinsic unordered
  `10+10` leader-support bipartition (support chirality).
- Conceptual geometry: the `A5` point-orbit decomposition is
  `[6,10,12,15,30,30,30]`; the unique 12-orbit supplies the conic.
- Low-degree rigidity: only Clebsch lies on a curve of degree at most three; one sharp
  quartic companion class begins the minimal-exact-degree ladder.
- Small-arc classification: for `4 <= k <= 7`, a full conic extension locus occurs only
  for the `PG(2,5)` frame and the `PG(2,11)` Clebsch hexagon.
- Selected portable upgrade: for `A3/B3/H3`, the reflection-arrangement complement code has exact
  parameters `[(q-h/2)(q-h+1),3,(q-h/2-1)(q-h+1)]`, with nonmirror maximum `q-h+1`; at `q=h+1`
  it becomes the full-conic extended GRS code.  Edge/Dye own the individual configurations,
  `5,14,22` marker fibres, and substantial relation geometry.

Detailed result/proof history is preserved in the archive and in reports C180–C187.

## Submission-critical work, in order

1. Integrate C399 as the rank-three explanation of the q=11 phase.  Lead with the exact
   nonmirror-line/distance theorem; credit Edge and Dye for the exceptional conic geometry and
   avoid novelty claims for `5,14,22`, parent ambiguity, the B3 `3+6` split, or conic--GRS.
   Source of truth: [`2026-07-20-c399-literature-audit.md`](../2026-07-20-c399-literature-audit.md).
2. Apply the repository mixed-verification policy: keep the existing conceptual/replay/Lean
   boundary explicit, print the adequacy appendix for the headline Lean statements, and add the
   final AI/provenance disclosure.
3. Pin the exact validated commit and target list in the shared Lean repository; copy no Lean
   sources into the paper repository.
4. Preserve the publication-allocation edge: `arcs` supplies the public provenance target before
   this paper's release pass.
5. **Immutable artifact — C182.** Archive code, certificates, sources, and rendered PDF under a
   stable DOI; cite the artifact from the paper.

## Completed bounded paper upgrade

- **C211 reported 2026-07-16:** the Clebsch secants are connected to the projectivized `H3`
  mirrors by an exact `F_11` projectivity; the q=5 frame joins are `A3`; their intersection lattices
  now synthesize the complement formulas, decoder strata, and two conic-filling cases in the
  19-page manuscript. The novelty audit conservatively credits Edge/Calvo for the icosahedral
  geometry and Jurrius--Pellikaan for the general arrangement--decoder mechanism. Exact proof,
  sources, and validation: [`2026-07-16-c211-clebsch-reflection-arrangements.md`](../2026-07-16-c211-clebsch-reflection-arrangements.md).
  A fresh referee-style read found no mathematical blocker; its organizational and precision
  recommendations were integrated in one late capstone subsection:
  [`2026-07-16-c211-clebsch-cold-read.md`](../2026-07-16-c211-clebsch-cold-read.md).

This is not a submission gate unless the manuscript adopts the claims. Broader follow-up research
has moved to the separate [`clebsch-next`](2026-07-16-clebsch-next.md) lane.

## Selected crowns import

- **C399 selected 2026-07-20:** integrate the uniform rank-three complement-code theorem into this
  paper rather than spawning a separate submission.  The literature audit found no exact
  predecessor for the uniform nonmirror maximum/distance law or `q=h+1` Coxeter-number package,
  but it found strong positive pre-emption for the surrounding geometry in Edge and Dye.  C403 may
  later streamline the proof interface; C404 is closed as pre-empted; C405 remains a separate
  companion gate.  The theorem report and source boundary are
  [`2026-07-20-c399-coxeter-number-conic-phase.md`](../2026-07-20-c399-coxeter-number-conic-phase.md)
  and [`2026-07-20-c399-literature-audit.md`](../2026-07-20-c399-literature-audit.md).

## Optional formal upgrade

- **C222 active but not release-blocking under the mixed-verification policy:** Lean-formalize
  precisely the new C211 `A3/H3` coordinate bridge,
  intersection ledgers, complement counts, and decoder-stratum consequences. This is gated on a
  compact theorem-level development: do not generate large certificate trees, and re-scope or stop
  if kernel closure would require them. The compact geometry leaf now passes guarded elaboration;
  its sole uncommitted path, `lean/RelativeConicArcs/ReflectionArrangementDecoding.lean`, awaits a
  focused build after the foreign Q25 owner releases the shared Lean lock. Task boundary and success criteria:
  [`2026-07-16-c222-lean-a3-h3-closure.md`](../2026-07-16-c222-lean-a3-h3-closure.md).
  If the paper labels these bridge claims Lean-formalized, C222 becomes a gate for that label;
  otherwise the verification map must retain their conceptual/replay route.

## Verification map

- Computation inventory, hashes, clean-source replay, Lean gates, and PDF audit: C168 report above
  (**reported 2026-07-15**).
- The 19-page manuscript now uses layered exposition for the finite-geometry/coding
  interface and includes a compact frame-normalized census argument, a grayscale-safe
  synthematic--Petersen figure, split trust/verification tables, the exact two-axiom Dye
  boundary, bounded open problems, and the correct hyperfocused-arc priority chain.
- Two paragraph-level cold reads are recorded in
  [`2026-07-15-clebsch-cold-prose-read.md`](../2026-07-15-clebsch-cold-prose-read.md)
  and
  [`2026-07-15-clebsch-revised-cold-prose-read.md`](../2026-07-15-clebsch-revised-cold-prose-read.md).
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

The `crowns` C295/C296 work may consume the committed q=11 rigidity, code, graph, and foil artifacts
read-only. The immediate implication “uncoloured continuation graph has twelve vertices, therefore
Clebsch” is a recognition corollary and does not widen this manuscript. A genuine C295 result must
recover the matching/port decomposition intrinsically; any proposed paper import returns to the
`clebsch` owner. The `clebsch-next` C212 arrangement/decoder reconstruction remains distinct from
C295 continuation-to-matching recovery and coordinates only if C295 reaches the `H3`/decoder layer.

## Closed-history pointers

- Full accumulated handoff history:
  [`done/2026-07-13-clebsch-paper-archive.md`](done/2026-07-13-clebsch-paper-archive.md).
- Adversarial review, novelty/literature, formalization, decoding, curve, orbit, and small-`k`
  reports are indexed from the archive; the discovery track is only the companion record of
  incidental observations and promotion pointers. Do not duplicate their prose here.
