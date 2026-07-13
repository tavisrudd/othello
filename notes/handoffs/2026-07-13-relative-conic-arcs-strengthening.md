# Handoff: relative-conic arcs — evaluation, coding, and icosahedral strengthening

**Date:** 2026-07-13
**Status:** QUEUED
**Tasks:** C106–C110

## Goal

Strengthen the completed `arcs_complete_outside_conic` paper and Lean development with three
downstream theorem packages:

1. an exact finite-field evaluation-avoidance dichotomy;
2. a projective arc–MDS/deep-hole/extension bridge; and
3. the exceptional `q=11` icosahedral symmetry, orbit, syndrome, and MDS-extension structure.

The work is a continuation of the finished
[C89–C96 formalization](done/2026-07-12-arcs-complete-outside-conic-formalization.md), not a reopening
of it. Session history, experimental output, literature-search trails, and superseded formulations
belong in the
[companion archive](done/2026-07-13-relative-conic-arcs-strengthening-archive.md).

## Scope and isolation

- Extend only the standalone `lean/RelativeConicArcs/` library. Existing `ProjectiveCap`,
  `FiniteGeom`, generated `Q16CertificateData`, and unrelated targets must not import the new
  modules.
- Reuse the existing one-way foundations, especially `EvaluationObstruction.lean`,
  `ProjectiveBridge.lean`, `Q11Residual.lean`, and `Q16QuadraticAvoidance.lean`.
- Put coding terminology over semantic finite linear algebra and projective incidence; do not make
  the result depend on an opaque or paper-specific coding framework.
- Keep external computation outside the trust boundary. Lean must check the finite certificates and
  the semantic bridges from checked data to the published theorems.
- Heavy temporary build artifacts must use disk-backed storage under `/home`; `/tmp` is tmpfs.

## Exact theorem targets

### T1 — evaluation-avoidance dichotomy

For a finite field `F` of cardinality `q`, a finite-dimensional `F`-space `V`, evaluations
`ev x : V →ₗ[F] F`, and finite sets `U` and `A`, let
`K = ker (evaluationMap ev U)`. Under `|A| < q`, prove

```text
∃ f ∈ K, f ≠ 0 ∧ ∀ a ∈ A, ev a f ≠ 0
↔
K ≠ ⊥ ∧ ∀ a ∈ A, K ⊄ ker (ev a).
```

Then prove the finite-dimensional dual reformulation
`K ≤ ker (ev a) ↔ ev a ∈ span (ev '' U)` and the degree-`d` Veronese/evaluation-closure corollary.
The core existence proof is the sharp union-of-fewer-than-`q` proper hyperplanes count. The strict
`|A| < q` hypothesis must be retained unless a stronger, independently proved covering theorem
supports a replacement.

### T2 — projective arc and coding bridge

For a projective `k`-arc represented by the columns of a rank-three matrix `H_A`, define
`C_A = ker H_A` and prove:

- `A` is an arc iff every three columns are independent, equivalently `C_A` has parameters
  `[k,k-3,4]_q` and is MDS;
- projective syndrome distance is one on `A`, two on its secant-covered locus, and three on its
  ordinary uncovered locus;
- an uncovered point is exactly a one-column MDS extension of `C_A`;
- completeness outside a conic is exactly confinement of all projective deep-hole syndromes to the
  conic; and
- compatible simultaneous one-column extensions are the independent sets of the secant-conflict
  graph.

If Mathlib lacks a suitable coding API, state and prove support-size/syndrome semantics first, then
add conventional parameter corollaries. The geometric theorem must not be blocked by library
terminology.

### T3 — the `q=11` icosahedral package

For the certified six-arc already used by `Q11Residual.lean`, prove:

- the conic-projectivity stabilizer is an explicit group of order 60, with a checked isomorphism to
  `AlternatingGroup (Fin 5)`;
- its point-orbit sizes on `PG(2,11)` are `6,12,10,15,30,30,30`;
- secant index is constant on the relevant orbits and gives `(N₁,N₂,N₃)=(90,15,10)`;
- the six admissible conic witnesses give perfect matchings partitioning the 30 edges of the
  icosahedron;
- `C_A` is a non-GRS `[6,3,4]₁₁` MDS code of covering radius three whose projective deep-hole
  syndrome set is exactly the 12-point conic;
- the affine coset-distance distribution is `(1,60,1150,120)`, and the distance-two cosets split as
  `(900,150,100)` according to whether they have one, two, or three minimum-weight leaders; and
- the simultaneous MDS-extension complex is the independence complex of the icosahedron.

The non-GRS proof target is coordinate-free: quadratic evaluation on the six projective columns has
rank six, so no conic contains the arc. The `A5` label requires an explicit checked group
isomorphism; order and element-order statistics alone are supporting checks, not the proof.

## Work packages

| Task | Work | Completion gate |
|---|---|---|
| **C106 [QUEUED]** | Run the cheap refutation suite and freeze independent small certificates for T1–T3. | Every count agrees across coordinate changes and two independent implementations; negative controls fail as predicted; the exact theorem statements are frozen. |
| **C107 [QUEUED]** | Formalize T1 in `EvaluationDichotomy.lean`, kernel form first and dual/Veronese closure second. | Focused and aggregate builds pass; small-field boundary tests justify `|A|<q`; public theorems have the accepted Mathlib-only axiom profile. |
| **C108 [QUEUED]** | Formalize T2 in `SyndromeGeometry.lean` and `CodingBridge.lean`. | Arc, syndrome-distance, deep-hole confinement, and one-/multi-column extension equivalences are kernel-checked without importing this spinoff into existing consumers. |
| **C109 [QUEUED]** | Formalize T3 in downstream `Q11IcosahedralAction.lean` and `Q11MDSCode.lean`. | Explicit 60-element action and `A5` isomorphism, orbit/secant certificates, code distributions, and extension complex all build under strict trust. |
| **C110 [QUEUED]** | Complete the rigorous novelty/citation audit, adversarial proof review, consumer review, and publication synchronization. | Claim ledger has safe wording and primary citations; paper, proof audit, Lean TRUST manifests, `papers-index.md`, and relevant projective-cap handoff are synchronized; at least one mutation/adversarial round passes. |

## Cheap refutation gates

Run these in C106 before substantial T3 proof engineering.

| Gate | Required check | Failure response |
|---|---|---|
| **R0 — source regeneration** | Recompute the stabilizer, point orbits, secant indices, quadratic rank, syndrome distances, leader multiplicities, extension columns, and extension graph from the certified coordinates. | Block every affected statement until the discrepancy is resolved. |
| **R1 — coordinate invariance** | Repeat after a nontrivial projective transform and independent relabelling of both arc and conic parameters. | Treat any failure as a representation artifact. |
| **R2 — independent implementation** | Reproduce the group and code calculations with a separately written implementation or GAP/Sage, not shared helper code. | Do not freeze a certificate from agreeing variants of one implementation. |
| **R3 — negative controls** | Perturb a witness coordinate and generator/table entry; the exceptional symmetry, orbit, and extension assertions should break. | If they persist, strengthen the characterization or identify the genuinely generic theorem. |
| **R4 — syndrome enumeration** | Enumerate all 133 projective syndrome directions and all 1331 affine syndromes independently; reproduce the claimed projective and affine distributions. | Reframe or reject the coding statement. |
| **R5 — extension exhaustiveness** | Check every projective column: exactly the 12 conic directions extend singly, and pair compatibility is exactly the icosahedral nonedge relation. | Reject the claimed exact extension complex. |
| **R6 — T1 boundary search** | Exhaustively test small finite spaces, including searches at `|A|=q` for covering counterexamples. | Correct the hypotheses before Lean formalization. |

All certificate-generation scripts must record command, source hash, output hash, and an independent
semantic cross-check in the companion archive. Small finite proof data may be generated, but the
Lean checker must remain visibly simpler than the generator.

## Lean attack order

1. **C106 statement freeze.** Run R0–R6 and record exact representatives, generators, orbit tables,
   and counterexamples at sharp hypothesis boundaries.
2. **C107 reusable algebra.** Prove the kernel-form union bound. Add the annihilator/span theorem
   only after the core statement builds, then specialize to evaluation and Veronese closure.
3. **C108 geometric semantics.** Define support-bounded syndrome representation and prove the
   arc/secant/uncovered trichotomy. Derive MDS parameters and extension language afterward.
4. **C109 finite structure.** Check the explicit 60-element action and orbit certificates first;
   add the abstract `A5` isomorphism and code corollaries downstream.
5. **C110 review and publication.** Perform novelty collision searches and citation chasing in
   parallel with C107–C109, but decide claim wording only after the Lean statements stabilize.

C107 and C108 may proceed independently once their C106 subgates pass. C109 remains gated by the
full q11 refutation suite and the early exact-object literature search.

## Novelty-search strategy

Maintain a claim matrix with columns: exact proposed claim, nearest source, exact overlap,
distinction that remains, proof status, and safe manuscript wording. Search primary literature and
follow both backward references and forward citations.

1. **Coding/deep-hole stream:** non-GRS `[6,3,4]₁₁` MDS codes; projective syndromes and deep holes;
   conic syndrome sets; covering-radius-three MDS codes; one-column and simultaneous MDS
   extensions; extension graphs/complexes; refined coset-leader distributions. Begin with
   Kaipa, Zhang–Wan–Kaipa, and current non-GRS MDS/deep-hole construction literature.
2. **Finite-geometry/group stream:** six-arcs in `PG(2,11)`; `A5 < PSL(2,11)` on the conic;
   icosahedral chord systems; exterior sets; arc stabilizer/orbit classifications; Witt-design and
   `M12` constructions.
3. **Evaluation/Veronese stream:** finite vector spaces covered by hyperplanes; blocking-set duals;
   evaluation matroid closure; Veronese and projective Reed–Muller codes. Expect the hyperplane
   lemma to be classical; audit novelty of the exact avoidance equivalence and this application.
4. **Secondary application stream:** independent domination in collinear-triple hypergraphs,
   line-arrangement/net interpretations of the matching equality case, and higher-moment/coherent-
   configuration refinements. These do not enter the paper without a proved statement and a
   separate collision search.

Novelty verdicts are: **known**, **known components/new synthesis candidate**, or **no exact match
located**. Never convert the third verdict into a priority claim without an external specialist
bibliographic check. If the exact q11 object is already classified, retain only the checked
reconstruction and genuinely additional syndrome/extension invariants.

## Trust, adversarial, and publication gate

- No `sorry`, `native_decide`, `admit`, paper-specific axiom, or unproved semantic bridge.
- Print and record axioms for every public theorem. Unconditional targets should use only accepted
  Mathlib foundations.
- Build focused leaves before aggregates, especially around generated finite data; never trigger a
  missing heavy import closure with a raw aggregate build.
- Regenerate finite data and compare hashes, then run at least one mutation round against the Lean
  checker and one independent mathematical review of the theorem hypotheses.
- Keep universal theorems, checked finite facts, computed exploratory evidence, and novelty claims
  in visibly distinct trust tiers.
- Update both manuscript sources and rendered PDF, the proof audit, `lean/RelativeConicArcs/TRUST.md`,
  top-level `lean/TRUST.md` if its manifest changes, and the table of results in
  `papers/papers-index.md`.
- Review T2/T3 against C84 and C100. Record only an actual new consumer theorem or a scoped negative
  relevance verdict in the projective-cap handoff.
- At closure, revisit the discovery ledger and classify every noticed corollary, cheap extension,
  surprise, implication, application, or speculative novel direction. Move a completed live
  handoff to `notes/handoffs/done/`.

## Packaging gate

- T1 and a concise T2 dictionary belong in the main paper if proved.
- Add the q11 code parameters and exact distributions to the main paper when they remain compact.
- Include the full T3 section only if the explicit `A5` proof is conceptually readable and the
  novelty audit supports the synthesis. Otherwise publish it as a companion note on the
  icosahedral MDS-extension complex and cite it from the arcs paper.

## Next step

Start C106 with R0, R4, and R5 from the frozen q11 witness, using two independent implementations
and disk-backed scratch space. In parallel, run the exact-object collision search before committing
to the generated `A5` proof table.
