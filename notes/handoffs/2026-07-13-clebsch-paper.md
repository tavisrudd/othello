# The Clebsch hexagon code — paper lane (`clebsch`)

**Lane**: `clebsch` — see `AGENTS.md` § Lane routing.

**Date**: 2026-07-23

> **LIVE MAP ONLY. DO NOT APPEND SESSION LOGS, EXPLORATION, REVIEW TRANSCRIPTS, OR
> SUPERSEDED PLANS HERE.** Put history in
> [`done/2026-07-13-clebsch-paper-archive.md`](done/2026-07-13-clebsch-paper-archive.md),
> and put individual findings in dated `notes/` reports.

## Goal and current verdict

Finish the Clebsch-hexagon paper as a self-contained, exactly attributed,
computer-assisted rigidity/classification paper with archived reproducibility artifacts.
Current assessment: **the existing 19-page manuscript and local reproducibility package remain the
protected baseline.  C399 is the selected portable upgrade for that version.  The new-paper plan
uses the C406+C411 replacement spine, selectively sharpened by C412's all-degree parity theorem,
intrinsic `1:4:6` recovery, and projective-cover explanation of the depth rank drop.  C412's
relative-cubic Tate plane is appendix-level naturality machinery and is not identified with the
depth plane.  The opening exposition is now a proof-free graphic sweep of the
forgetting--balanced-recovery--cubic-orientation--parent-reconstruction arc.  Paper 1 closes with an
exact survival/forgetting ledger and the C445 arithmetic-gluing theorem; C469+C470 upgrade C464's
perfect-code row to the full-support/secant-shadow/Hadamard--Mathieu capstone, while C465+C471 form
the top-ranked Paper-2 modular-sandwich/Hadamard-degeneration mechanism and quaternion, descent,
torsor, Dickson, signed-Weil, and zeta mechanisms remain Paper-2
pointers.  The user has selected the replacement spine for Lean formalization, queued as
C420--C428, while manuscript integration remains a separate owner action before release.
C485's proof-only six-arc uncovered-locus reconstruction lemma is now imported into the arcs paper,
strengthened there to `q+1 > binom(k,2)` for arbitrary fixed `k`, upgraded to a canonical
reconstruction/stabilizer theorem with a sharp `q=5` equality-boundary counterexample, and used
only as a conclusion-level contrast in Clebsch.  C521 closes the bounded theory: the Clebsch
fixed-child fibre is the classical homogeneous space `PGL_2(11)/A5` of size 22, its intrinsic
determinant-orientation quotient is two `PSL_2(11)` orbits of size 11 with no preferred sign, and
C490's 79 certified disagreement masks are exactly all complements of at most two conic points,
so every triple and no pair recovers by a proof-only incidence deduction.  The collision
multiplicities now have an exact orbit explanation: the 1320 single-agreement instances form one
regular `PGL_2(11)` orbit, while the 95 witnesses over an edge split under its `D20` stabilizer as
`10^8+5^2+2^2+1`, with the fixed point equal to C447's canonical shared-edge pair.  The result is
a companion excluded from Paper 1; the C486 bridge reaches the matching torsor but not the
decoder's support chirality**.

The current decision and novelty map is
[`2026-07-20-clebsch-paper-planning.md`](../2026-07-20-clebsch-paper-planning.md); its Verdict,
Shipping revision, and Close revision are authoritative for what ships — the upgraded
replacement-spine manuscript ending in the certified torsor-Rosetta closing theorem (C480, upgraded
to a complete rank-three trichotomy with a characteristic-zero realization row by C486/C487). A
cold session takes the manuscript shipping decision and close from those blocks, not from the
protected-baseline framing above.
The copy-ready abstract and section plan are
[`2026-07-21-clebsch-paper-abstract-outline.md`](../2026-07-21-clebsch-paper-abstract-outline.md),
the proof-free opening and conclusion prose draft is
[`2026-07-21-clebsch-paper-guided-tour-conclusion-draft.md`](../2026-07-21-clebsch-paper-guided-tour-conclusion-draft.md),
and the complete C440--C471 paper-disposition inventory, including the editorial ranking, is
[`2026-07-21-clebsch-weil-roof-results-ledger.md`](../2026-07-21-clebsch-weil-roof-results-ledger.md).
The proof/evidence, formalization-readiness, and bounded novelty audit predating C465 and
C469--C471 is
[`2026-07-21-clebsch-weil-roof-proof-evidence-audit.md`](../2026-07-21-clebsch-weil-roof-proof-evidence-audit.md).
Use the later exact reports and the updated result ledger for C465 and C469--C471 unless a
proof-audit addendum is requested.
The ranked runner-up novelty spot-check is
[`2026-07-22-clebsch-weil-roof-runner-up-novelty-audit.md`](../2026-07-22-clebsch-weil-roof-runner-up-novelty-audit.md).
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

## Selected C406+C411 replacement spine

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

C412 strengthens rather than lengthens this spine.  The all-degree antipodal formula and primitive
`1:4:6` dependence belong in the main proof; the depth plane's modular description
`P(1)^A4/soc(P(1))` is a compact conceptual proposition.  Two independent constructions of a
canonical relative-cubic Tate plane belong in an appendix, together with the proved boundary that
divided transfer and the other natural routes do not identify it with the depth plane.  See
[`2026-07-20-c412-relative-cubic-depth-plane.md`](../2026-07-20-c412-relative-cubic-depth-plane.md).

This version should replace weaker descriptive material and compress the cubic, quantum, and free
arrangement-code consequences; it must not enlarge the paper into parallel coequal spines.

Detailed result/proof history is preserved in the archive and in reports C180–C187.

## Submission-critical work, in order

1. **Freeze the selected new-paper spine.**  Preserve the C399-led manuscript as a fallback, but
   plan the new paper around C406+C411 with only the selective C412 upgrades stated above.  Extend
   only the claim-specific source gaps needed for manuscript wording.  Do not wait for C405, C401,
   C402, C413--C419, or other companion gates.
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
from the former `clebsch-next` lane is now crowns-owned; the historical handoff remains
[`2026-07-16-clebsch-next.md`](2026-07-16-clebsch-next.md).

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
- **C406+C411 complete as the selected new-paper replacement:** C406's exact theorem and bounded
  priority audit support likely-new wording only for the conic-quotient/moment/Fourier composition.
  C411 supplies the source-surviving conceptual double-coset/mixed-bi-Hecke proof and is the one
  successor admitted under the single-promotion rule.  C412 contributes a selective proof upgrade,
  not a coequal spine; C413--C417 remain companions.  No manuscript source edit is implicit in this
  planning decision.
- **C407--C409 are not additional flagships:** C407 consists of conventional free corollaries;
  C408 is a companion limitation theorem showing global data forget pointed repair; and C409 is a
  classical/formal exact-strength-two normalization.  C410 now closes every spanning q=7
  six-point external-line closure; C418/C419 own its active larger-trade and fixed-incidence-moduli
  successors.  C405 is independent, and none of these directions delays the paper decision.

## Closed reconstruction follow-up

- **C521 reported 2026-07-23 — companion, excluded from Paper 1:** the fixed-child orbit lemma,
  `PGL_2(11)/A5` specialization, intrinsic but unlabelled `11+11` determinant-orientation torsor,
  and the exact proof-versus-certificate split for C490's sharp base three are recorded in
  `notes/2026-07-23-c521-clebsch-fixed-conic-reconstruction.md`.
  The follow-up collision-orbit certificate proves the regular 1320-orbit and the
  `95=8*10+2*5+2*2+1` edge-fibre decomposition.  No support-chirality identification or manuscript
  edit is asserted.

## Optional formal upgrade

- **C222 completed 2026-07-21 — final independent review `GO`:** the compact coordinate and decoder
  leaves include the
  explicit invertible projective transport, two-sided `A3` equality, actual affine-ray nearest-leader
  bridge, factor-ten count, and `90+6` one-leader decomposition. Both leaves and the import-only gate
  `RelativeConicArcs.Gates.ClebschReflectionArrangementDecoding` build cleanly; all 47 terminal probes
  report only `propext`, `Classical.choice`, and `Quot.sound`, and the bounded Clebsch slice manifest
  is present. The validated bundle is pinned at `098fa74bfe4d39fc015ad63cced2a811c867a95c`;
  the manuscript verification row names both modules and the paper renders cleanly. Final report:
  [`2026-07-16-c222-lean-a3-h3-closure.md`](../2026-07-16-c222-lean-a3-h3-closure.md).

## Replacement-spine Lean campaign

- **C527 complete with final independent review `GO` — Paper-2 modular contraction
  package:** C433's divided-Fourier contraction and valency/flag rigidity are packaged with C526's
  negative source-Tate flag-orbit obstruction as one local Modular Gateway theorem/boundary block.
  The compact import-only Lean gate checks 27 terminals on standard axioms and preserves the
  C425/C426 external-semantics boundary; the strengthened artifact is pinned at
  `bf01d4156811cf0715ac6775efa0cab45d3ff818`.  It does not
  widen Paper 1, draft all of Paper 2, or formalize general Brauer/Tate theory.  Report and proposed
  C320 delta:
  [`2026-07-23-c527-modular-contraction-paper-lean-packaging.md`](../2026-07-23-c527-modular-contraction-paper-lean-packaging.md).
- **C420 complete (F1 foundation, reported 2026-07-20):** the signed moment/trade foundation is
  landed and green as `RelativeConicArcs.ClebschMomentTrade` with the import-only gate
  `RelativeConicArcs.Gates.ClebschMomentTrade` — affine covariance / first survival, antipodal
  even-moment cancellation, degree-one barycentre cancellation, and the elementary C408 cubic
  witness of exact strength two, plus a functional-shadow vector layer, all on standard axioms with
  no Clebsch tables. It imports only pinned Mathlib and is the campaign root for F4/F5/F6. Report:
  [`2026-07-20-c420-clebsch-moment-trade-lean.md`](../2026-07-20-c420-clebsch-moment-trade-lean.md).
- **C421 complete (F2 pairing-forgetting quotient, reported 2026-07-20):** landed and green as
  `RelativeConicArcs.ClebschConicMatchingQuotient` with the import-only gate
  `RelativeConicArcs.Gates.ClebschConicMatchingQuotient` — secant/conic Veronese pullback, the
  Plücker four-endpoint switch identity `L_ab L_cd − L_ac L_bd = [a,d][b,c](XZ−Y²)` and its
  conic-ideal divisibility, list-permutation parent forgetting, the generic rank-one
  augmentation-kernel calculation (`finrank = card ι−1`), pointwise factor-product and finite-field
  boundary-form identities, arbitrary-size switch reversibility, and complete `Fin 4` switch
  connectivity; all on standard axioms, no matching census. A 2026-07-20 cold review repaired prose
  that had overstated these as a geometric restriction-map kernel, exact projective zero-set/weight,
  full-endpoint product bridge, switch span, and arbitrary-`2n` connectivity. Those stronger claims
  are not Lean-formalized and are unused by F3. It imports the existing conic API and pinned Mathlib
  and is the F3 input. Report:
  [`2026-07-20-c421-clebsch-conic-matching-quotient-lean.md`](../2026-07-20-c421-clebsch-conic-matching-quotient-lean.md).
- **C422 complete (F3, final independent review `GO` 2026-07-21):** the symbolic conic Laplacian,
  degree-`1/2/4` harmonic/radial existence and uniqueness, exact characteristic-5/7 obstructions,
  dimensions `1,3,6,15 / 1,6 / 3,5,9`, prime-field instances, and F2 switch-radial bridge are
  landed as `RelativeConicArcs.ClebschHarmonicQuotient`; its import-only gate and 34-terminal axiom
  audit are green. The initial reviewer found three boundary/evidence issues; `0373a6db` narrowed
  the source prose and authoritative campaign exit and added a committed 34-terminal audit harness.
  The exact theorem boundary, hashes, validation, findings, dispositions, and review checklist are
  in [`2026-07-20-c422-clebsch-harmonic-quotient-lean.md`](../2026-07-20-c422-clebsch-harmonic-quotient-lean.md).
  The same user-launched reviewer accepted all fixes and returned final `GO`; the completed record is
  archived from the live queue.
- **C426 complete (F7, final independent review `GO` 2026-07-21):** landed the abstract `F_11`
  character identity and scalar-line `11z-ell` aggregation plus exact kernel checks of the frozen
  candidate `P/Q` tables (`P=Q`, `PQ=P^2=1331I`, shape and row-zero/valency identities) and all 126
  option-safe additive-nonclosure witnesses. The gate deliberately exports literal checks only:
  geometric scheme rank, Fourier self-duality, and primitivity remain decomposed with the exact
  external orbit bridge; intersection/Krein equality and the 877-partition fusion census remain
  external certificates. A stable neutral bundle now reproduces the orbit construction, complete
  tensor/fusion certificate, Lean data, and six-entry manifest. Two review repair rounds closed the
  trust/provenance findings; exact terminals, hashes, build/axiom evidence, exclusions, and C320 rows
  are in [`2026-07-20-c426-clebsch-scheme-fourier-lean.md`](../2026-07-20-c426-clebsch-scheme-fourier-lean.md).
- **C423--C425 are complete with final independent review `GO`; C427 is complete by explicit user
  override after its initial review repairs:** C423's
  sharded A3/B3/H3 leaves prove ranks `3/6/10`, signed first/second-moment cancellation, and named
  nonzero cubic witnesses. C424 formalizes the abstract radical--Hadamard balanced-sheet theorem,
  concrete B3/H3 signed actions, cubic orientation and exact stabilizers, and plane syzygies without
  balanced-half enumeration. Both import-only gates and audit surfaces passed final independent
  review `GO`. C425's six-module gate derives the `1,4,6 / 1,4,6` orbits, all six secant-incidence
  profiles, involution sign, rank-two/four-kernel facts, cubic-first pushforward, and singleton
  matching-row recovery; its report explicitly retains the named abstract-group identification and
  scheme-theoretic Fourier semantics at replay/external level. C427 landed the committed C373
  intrinsic chirality endpoint and replacement-spine gate and handed its verification-map delta to
  C320; its initial review found and repaired order-four/provenance prose, and the user explicitly
  waived a separate post-fix reviewer before archival. Exact evidence and exclusions:
  [`2026-07-20-c423-clebsch-factorization-leaves-lean.md`](../2026-07-20-c423-clebsch-factorization-leaves-lean.md)
  [`2026-07-20-c424-clebsch-balanced-sheets-lean.md`](../2026-07-20-c424-clebsch-balanced-sheets-lean.md),
  and [`2026-07-20-c425-clebsch-double-coset-depth-lean.md`](../2026-07-20-c425-clebsch-double-coset-depth-lean.md).
- **C428 complete with final independent review `GO` (2026-07-23):** the separate
  `RelativeConicArcs.Gates.ClebschWeightedAdjoint` gate proves the conditional weighted-depth
  identities, actual finite-field evaluation and injectivity bridge, and exhaustive displayed
  `A3/F_5`, `B3/F_11`, and `H3/F_11` enumerator/minimum-distance rows. All 22 terminal probes report
  only standard axioms; the classical coordinate-to-Coxeter identifications remain explicit
  inputs. Exact source hashes, theorem types, validation, exclusions, and C320 delta:
  [`2026-07-20-c428-clebsch-weighted-adjoint-lean.md`](../2026-07-20-c428-clebsch-weighted-adjoint-lean.md).
- **The Paper-1 close now has an explicit Lean expansion:** C494 has closed C434's B3/H3 middle
  information lattice with exact `(sheet,D')`-fibre/`K`-orbit equivalences, strict
  `1 < 2 < 6 < 14/22` rational function-subalgebra towers, and a 31-terminal standard-axiom gate;
  its final prose-only review repair closed by explicit user waiver
  ([report](../2026-07-22-c494-c434-information-lattice-lean.md)). C503 has closed the bounded
  rank-three arithmetic-gluing theorem with a
  workflow-free certificate bundle, 23-terminal gate, and final independent-review `GO`
  ([report](../2026-07-22-c503-clebsch-arithmetic-gluing-lean.md)); C504 has closed the
  C452/C464/C469/C470 Witt--Hadamard--Mathieu finite capstone with a sharded 25-terminal gate,
  exact upstream replay, quantified finite assignment/normalizer checks, and final
  independent-review `GO`, with the validated Lean repair pinned at `42683dff`
  ([report](../2026-07-22-c504-clebsch-witt-hadamard-lean.md)); C506 has closed the bounded finite
  survival/erasure negatives and exact conditional mod-40 law with a definitions-only data leaf,
  fourteen-terminal standard-axiom gate, complete upstream replay, and final independent-review
  `GO` ([report](../2026-07-22-c506-clebsch-survival-boundaries-lean.md)); C505 has closed the
  C417/C448/C473/C474/C480/C486/C487 torsor-Rosetta close with actual finite root torsors,
  explicit mixed-verification certificate interfaces, an eleven-terminal gate, exact replay
  ledger, and final independent-review `GO`
  ([report](../2026-07-22-c505-clebsch-torsor-rosetta-lean.md)); C507 has closed the finite
  theta/Arf, scoped Fourier, monomial/fixed-party quantum-erasure, and `A5` bitorsor interfaces
  with a repaired twenty-two-terminal standard-axiom gate and final post-fix independent-review
  `GO`.  Scalar-extended eigenspace multiplicities, the true common ambient Weil restriction,
  arbitrary LU classification, and the unadopted C471 Paper-1 shadow remain explicitly external
  ([report](../2026-07-22-c507-clebsch-passage-interfaces-lean.md)).  Their exact trust and
  exclusion boundaries are frozen in
  [`2026-07-20-clebsch-lean-formalization-plan.md`](../2026-07-20-clebsch-lean-formalization-plan.md)
  and their task reports.  C503--C507 were reserved as one block in commit `5fa7dc97`.
- **C320 is active as an early incremental foundation and remains the release-blocking
  trust-ledger capstone:** by explicit user authorization it has begun deterministic manuscript
  statement extraction, fail-closed manifest validation, and reviewed-slice intake.  All
  Paper-adopted C420--C428, C494, and C503--C507 slices are now final and admitted.  C320 must next
  migrate the adopted dated-note evidence into stable workflow-free bundles, reconcile the
  replacement manuscript, and publish one claim-by-claim ledger with exact
  theorem/gate/axiom evidence, external
  certificate and cited-input boundaries, a pinned commit, and one verify-all entry point. No
  replacement-spine claim is called Lean-formalized before this reconciliation and independent
  review. The user, not the implementing agent, launches Codex for the initial and post-fix reviews;
  the implementer stops and requests each review and may not spawn or simulate its reviewer. In
  particular, C421 proves only the `Fin 4` switch base plus arbitrary-size reversibility;
  C426 treats Krein/intersection equality and the 877-fusion census as external exact certificates
  unless their separate kernel checker leaves actually land.
- **C321 has one conditional mandatory target identified by C320:** if the protected manuscript's
  smooth genus-three `C02` quartic sharpness sentence survives, replace the sole load-bearing
  Singular Jacobian-ideal smoothness check with an independently specified exact
  certificate/checker.  The Python replay already owns irreducibility and the 18-point equality;
  deleting or weakening the smooth/genus clause removes this mandatory target.
- The campaign is mixed-verification by design: C399's current Lean arithmetic terminals and
  reproducible incidence/conic certificates are the entry boundary. Every new finite leaf requires
  a checker theorem, provenance, hash, independent replay, and explicit axiom audit; otherwise its
  claim remains explicitly external.

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
