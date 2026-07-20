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
Current assessment: **the existing 19-page manuscript and local reproducibility package remain the
protected baseline.  C399 is the selected portable upgrade for that version.  C406 has passed its
mathematical gate and bounded claim-by-claim audit as a likely-new conic-quotient/moment/Fourier
composition, and C411 has supplied the missing conceptual double-coset/Hecke derivation.  The
C406+C411 form is therefore the recommended replacement spine.  The user has now selected that
spine for Lean formalization, queued as C420--C428, while manuscript integration remains a separate
owner action before release**.

The current decision and novelty map is
[`2026-07-20-clebsch-paper-planning-sweep.md`](../2026-07-20-clebsch-paper-planning-sweep.md).
The red-team-approved formalization campaign is
[`2026-07-20-clebsch-lean-formalization-plan.md`](../2026-07-20-clebsch-lean-formalization-plan.md).

Authoritative manuscript and checkers:
[`papers/clebsch-hexagon-code/`](../../papers/clebsch-hexagon-code/).
Rendered paper:
[`clebsch_hexagon_code.pdf`](../../papers/clebsch-hexagon-code/clebsch_hexagon_code.pdf).
Paper registry: [`papers-index.md`](../../papers/papers-index.md), alias `clebsch`.

## Protected theorem spine

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

## Candidate C406+C411 replacement spine

C403--C406 now support one tighter mechanism:

```text
Coxeter conic phase
  -> conic restriction forgets secant pairing
  -> conic-ideal quotient remembers the symmetry-selected factorizations
  -> balanced second moments recover the two sheets
  -> cubic signed memory orients them
  -> H3 depth profiles enter C378's odd Fourier sector
  -> singleton matching data recover the Clebsch parent through C379.
```

The exact C406 theorem has harmonic/radial image ranks `3,6,10`, unique balanced halves in B3/H3,
first nonzero signed tensor moment in degree three, and an H3 six-profile information lattice of
sizes `1,4,6 / 1,4,6`.  The raw one-factorizations, matching-design interpretation, `5/14/22`
marker spaces, and coarse Hadamard orbital geometry are classical.  What the audit finds likely new
within bounded coverage is their composition with the conic-ideal quotient, balanced reconstruction,
cubic tensor memory, and explicit depth--Fourier map.  Unrestricted priority remains open behind
the access gaps recorded in
[`2026-07-20-c406-priority-audit.md`](../2026-07-20-c406-priority-audit.md).

C411 makes the profile step conceptual: `A4` subgroup marks derive the two `1,4,6` triples, one
canonical secant-incidence evaluation per double coset derives the six vectors, and antipodality
plus the weighted barycentre relation gives the cubic-first pushforward.  The coordinates are mixed
`A4`--`A5` matrix-coefficient data, not zonal spherical functions; the linear map has rank two and
kernel dimension four while separating all six labels.  See
[`2026-07-20-c411-double-coset-hecke.md`](../2026-07-20-c411-double-coset-hecke.md).

This version should replace weaker descriptive material and compress the cubic, quantum, and free
arrangement-code consequences; it must not enlarge the paper into parallel coequal spines.

Detailed result/proof history is preserved in the archive and in reports C180–C187.

## Submission-critical work, in order

1. **Choose the paper fork.**  C411 has passed, so the decision is ripe.  The default-safe option
   remains the protected C399-led paper; the recommended higher-ceiling option is the C406+C411
   replacement.  Extend only the claim-specific source gaps needed for manuscript wording.  Do not
   wait for C405, C401, C402, C412--C419, or other companion gates.
2. **Integrate one spine.**  In the baseline version, integrate C399 as the rank-three explanation
   of the q=11 phase.  In the replacement version, use C399 as the phase prelude and C403/C406 as
   the central forgetting-and-memory theorem.  In either case credit Edge and Dye for the
   exceptional conic geometry and avoid novelty claims for `5/14/22`, parent ambiguity, the B3
   `3+6` split, or conic--GRS.  Sources of truth are
   [`2026-07-20-c399-literature-audit.md`](../2026-07-20-c399-literature-audit.md),
   [`2026-07-20-c406-matching-module.md`](../2026-07-20-c406-matching-module.md), and the C406
   priority audit above.
3. Apply the repository mixed-verification policy: keep the existing conceptual/replay/Lean
   boundary explicit, print the adequacy appendix for the headline Lean statements, and add the
   final AI/provenance disclosure.
4. Pin the exact validated commit and target list in the shared Lean repository; copy no Lean
   sources into the paper repository.
5. Preserve the publication-allocation edge: `arcs` supplies the public provenance target before
   this paper's release pass.
6. **Immutable artifact — C182.** Archive code, certificates, sources, and rendered PDF under a
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

- **C399 selected as the protected upgrade:** integrate the uniform rank-three complement-code
  theorem rather than spawning a separate submission.  The audit found no exact predecessor for
  the uniform nonmirror maximum/distance law or `q=h+1` package, but strong pre-emption for the
  surrounding geometry in Edge and Dye.  The theorem report and source boundary are
  [`2026-07-20-c399-coxeter-number-conic-phase.md`](../2026-07-20-c399-coxeter-number-conic-phase.md)
  and [`2026-07-20-c399-literature-audit.md`](../2026-07-20-c399-literature-audit.md).
- **C403 complete:** the weighted 2-adjoint theorem, stabilizer-stratified Coxeter word orbits, and
  all-degree conic matching quotient are available.  Bare nonfactorized dual supports factor
  through the standard GRS matroid and retain no parent data.
- **C406+C411 complete as the recommended replacement candidate:** C406's exact theorem and bounded
  priority audit support likely-new wording only for the conic-quotient/moment/Fourier composition.
  C411 supplies the source-surviving conceptual double-coset/mixed-bi-Hecke proof and is the one
  successor admitted under the single-promotion rule.  C412--C417 remain companions.  No manuscript
  edit is implicit until the explicit fork decision.
- **C407--C409 are not additional flagships:** C407 consists of conventional free corollaries;
  C408 is a companion limitation theorem showing global data forget pointed repair; and C409 is a
  classical/formal exact-strength-two normalization.  C410 now closes every spanning q=7
  six-point external-line closure; C418/C419 own its active larger-trade and fixed-incidence-moduli
  successors.  C405 is independent, and none of these directions delays the paper decision.

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

## Replacement-spine Lean campaign

- **C420--C427 queued:** signed-moment foundation, conic pairing quotient, bounded harmonic
  decomposition, sharded A3/B3/H3 factorization leaves, balanced-sheet/cubic orientation,
  C411's six-representative depth--Fourier--parent bridge, q=11 Fourier self-duality, and the
  committed C373 intrinsic chirality endpoint. C427 owns the new import-only
  `RelativeConicArcs.Gates.ClebschReplacementSpine` gate and hands its verification-map delta to
  C320.
- **C428 queued after C222 and the spine:** weighted 2-adjoint arrangement-code closure with a
  separate `RelativeConicArcs.Gates.ClebschWeightedAdjoint` gate. It consumes C222's committed
  terminal without touching `ReflectionArrangementDecoding.lean`.
- The campaign is mixed-verification by design: C399's current Lean arithmetic terminals and
  reproducible incidence/conic certificates are the entry boundary. Every new finite leaf requires
  a checker theorem, provenance, hash, independent replay, and explicit axiom audit; otherwise its
  claim remains honestly external.

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
