# Projectively completed cubic–axis RepairCodes — C111–C114

**Date**: 2026-07-13
**Status**: ACTIVE. C111 is kernel-proved and independently replayed; C112 is next. No claim is
paper-promoted until the downstream proof and publication gates pass.
**Parent track**: [completed RepairCodes formalization](2026-07-11-lean-formalization-plan.md)
**Paper**: [`coding-repair-hypergraphs`](../../papers/coding-repair-hypergraphs/README.md)
**Companion log**: [archive](done/2026-07-13-projective-completion-repaircodes-archive.md)

## Goal and claim ledger

Study the full projective twisted cubic over a finite characteristic-three field together with its
common osculating axis. Keep the existing affine-cubic seed unchanged; this is a candidate second,
Pareto-incomparable seed and asymptotic family.

| Claim | Current status | Permitted wording |
|---|---|---|
| completed seed has parameters `[2q+2,4,q]_q` and exact global dual distance `3` | strict-trust Lean, independent q=3,9,27 replay/mutations, aggregate build, and XH1 passed | proved; not paper-promoted before C114 |
| completed seed has exactly cubic and axis repair row types | proposed; q=3,9 exhaustively checked from circuits | diagnostic conjecture only; no group-orbit claim |
| radius-three rows are cubic `((q-1)/2,q-1)` and axis `((5q-3)/6,2q-1-Z3(q))` | proposed; q=3,9 checked by exact set packing/transversal | diagnostic conjecture only |
| radius four exhausts the complete inner minimal port | generic rank-four proof obligation open | standard consequence if proved |
| radius-four/full-inner rows are cubic `((q-1)/2,q-1)` and axis `((5q-3)/6,2q-3)` | proposed; q=3,9 checked by exact circuit enumeration | diagnostic conjecture only |
| q9 lift has rate `1/10` and eventual relative distance above every `c<351/1600` | arithmetic consequence conditional on prior gates | do not state as theorem yet |
| theorem package is novel | targeted search found no exact construction | candidate contribution; no priority claim |

Here `Z3(q)` is the already formalized maximum size of a zero-sum-free subset of the additive
group, represented in Lean by `zeroSumCapNumber`.

## Task and gate map

| Task | Deliverable | Hard completion gates |
|---|---|---|
| C111 | completed projective seed | independent small-field replay and mutations; written proof; strict-trust Lean theorem; axiom scan; focused and aggregate builds |
| C112 | exact radius-three and radius-four/full-inner ports | complete circuit/clutter classification; matching and transversal lower and upper bounds; `q=3` audit; independent enumeration; strict-trust Lean |
| C113 | finite lift and asymptotic family | transfer inequalities checked at radius four; exact multiplicities; analytic arithmetic; only the existing quarantined Stichtenoth import; Lean and PDF builds |
| C114 | novelty and publication closure | exact-claim primary-source citation chains; adversarial review; claim-strength audit; paper/ledger/TRUST/index synchronization |

## Current implementation state

- `FiniteGeom/ProjectiveAxisTwistedCubic.lean` defines the completed indices and columns and proves
  the exact one-point cubic section for planes containing the axis, the full-cubic section bounds,
  maximum section `q+2`, spanning dimension four, minimum distance `q`, and the bundled
  `[2q+2,4,q]_q` theorem.
- `RepairCodes/ProjectiveAxisTwistedCubic.lean` packages the row code, proves all columns nonzero
  and every distinct pair linearly independent, and proves exact global dual distance `3` from an
  explicit three-axis-point dual word.
- `RepairCodes.lean` imports the module. The focused modules and aggregate build pass; every
  printed headline has exactly the standard axiom profile. The independent verifier passes at
  q=3,9,27 with coordinate conjugation, affine deletion, duplicate rejection, and a nonduplicate
  spectrum-changing mutation. The forbidden-token and whitespace scans pass.
- C112 has started with the projective-boundary circuit hinge:
  `FiniteGeom/ProjectiveAxisTwistedCubicCircuits.lean` proves that two distinct finite cubic
  points `s,t`, cubic infinity, and axis point `s+t` form a four-circuit, and proves uniqueness of
  that normalized axis completion. The all-finite completion theorem remains the existing
  determinant result; the complete repair-clutter classification is still open.
- The independent verifier now enumerates every circuit of size at most five at q=3 and q=9 and
  solves the resulting matching and transversal problems exactly. It confirms all proposed
  radius-three and radius-four rows, including the q=3 boundary. This is a refutation gate, not a
  substitute for the general Lean proofs.
- `RepairCodes/ProjectiveAxisTwistedCubicInvariants.lean` proves the D-PC10 projective parameter
  permutation and its ambient invertible linear realization, including normalized action formulas
  on every finite, pole, and infinity case. It now packages the full index permutation and
  everywhere-nonzero column scales and proves preservation of linear independence for every
  indexed column family and every finite selected support, then proves exact preservation of the
  column-circuit predicate including all one-point deletions. The generic minimal-dual-support/
  column-circuit bridge and exact zero-sum clutter identification are the current XH2 obligations.
- `RepairCodes/ProjectiveAxisTwistedCubic.lean` now exposes the complete and inclusion-minimal
  repair hypergraphs, proves every repair edge nonempty, reduces their matching/transversal
  invariants to the minimal clutter, and supplies the circuit-to-actual-repair bridge.

## Mandatory xhigh review checkpoints

Lower-effort implementation may proceed between these checkpoints, but must not close or publish
the corresponding claim before xhigh review.

1. **XH1 — C111 final audit.** Review the finite/infinity section split, projective-distinctness
   statement, exact dual-distance proof, small-field edge case `q=3`, and independent mutation
   controls before marking C111 reported.
2. **XH2 — completion-fiber equivalence.** Review the claimed equivalence between every projective
   cubic-triple completion fiber and the existing zero-sum hypergraph before using it to derive the
   uniform axis row. This is the main new finite-geometry hinge.
3. **XH3 — complete-inner-port theorem.** Review the rank-four circuit cutoff together with the
   blocker/local-primal equivalence and all off-by-one conventions. The theorem may identify the
   full *inner* minimal port only; it must not silently become the unbounded port of a lift.
4. **XH4 — exact radius-four axis row.** Review both the weighted matching upper bound and the
   target-conditioned primal/section calculation giving `tau=2q-3`, including `q=3`.
5. **XH5 — transfer/asymptotic promotion.** Review `r=4` transfer gates, coordinate
   multiplicities, rate/distance arithmetic, and the exact scope of transferred supports before
   C113 is stated in prose.
6. **XH6 — novelty and headline language.** Review the primary-source citation chain and separate
   classical geometry, standard matroid consequences, family-specific repair formulas, and the
   asymptotic synthesis before any novelty or priority wording is committed.
7. **XH7 — exact section/weight distribution.** Before expanding scope, review the moment-count
   derivation, its dependence on the complete triple classification, the conversion from
   projective plane classes to codeword multiplicities, and the twisted-cubic/code weight-enumerator
   literature.

## Discovery Track register

This register contains only unplanned mathematical findings encountered while executing C111–C114.
It does not duplicate planned deliverables, implementation progress, validation results, or task
closure. `CHECKED` means independently replayed finite evidence; `LEAN` means kernel-proved;
`LIT-OPEN` means no exact predecessor has yet been located; and `PAPER` is allowed only after proof
and novelty promotion.

| ID | Discovery | Proof status | Novelty posture | Next gate / destination |
|---|---|---|---|---|
| D-PC9 | The completed seed appears to have exactly five nonzero weights: projective section counts `N1=q(q²-1)/3`, `N2=q(q²-1)/2`, `N3=q(q+1)`, `N4=q(q²-1)/6`, `N(q+2)=q+1`; hence exactly `q²-1` minimum-weight words | `CHECKED` independently at q=3,9,27; general moment proof sketched, not Lean | potentially stronger coding-theoretic contribution; `LIT-OPEN` | XH7; prove from plane moments/triple classification, then targeted weight-enumerator search |
| D-PC10 | Projective shifted inversion is induced by the explicit ambient coordinate change `(x₀,x₁,x₂,x₃) ↦ (a³x₀+x₃, a²x₀-ax₁+x₂, ax₀+x₁, x₀)`; it preserves the completed cubic–axis system and sends finite axis target `A(a)` to `A(∞)` | full monomial action and exact preservation of arbitrary indexed families, finite supports, and column circuits `LEAN`; repair-clutter consequence awaits a generic minimal-support bridge | structural unification, not by itself a novelty claim | XH2; prove minimal target-dual support iff target-containing column circuit, then the axis-infinity zero-sum clutter equality |

When a discovery becomes planned work, allocate it separately but keep this row as the concise
discovery verdict. Negative investigations belong in the companion archive.

## C111 proof obligations and refutation gates

1. Define the cubic index `F + Unit`, with infinity column `(0,0,0,1)`, and keep the axis index
   `F + Unit` with columns `(0,1,u,0)` and `(0,0,1,0)`.
2. Prove all columns are nonzero and no projective duplicate occurs, including across the two
   blocks.
3. Prove a plane containing the axis meets the full cubic in exactly one point: if the `X3`
   coefficient vanishes the point is cubic infinity; otherwise Frobenius gives the unique finite
   point.
4. Prove a plane not containing the axis meets it in at most one point and the full cubic in at
   most three points, treating the cubic-infinity branch explicitly.
5. Exhibit a `q+2` section, prove spanning dimension four, and derive `[2q+2,4,q]_q`.
6. Prove dual distance three from axis triples and pairwise projective independence.
7. Refute against independent exhaustive data at `q=3,9,27` where feasible; require coordinate
   conjugation and one-column mutation controls. Failed formulas are rewritten or demoted before
   further formalization.

## C112 proof obligations and off-ramps

1. Classify all minimal circuits through each target at helper radii three and four. Never infer
   completeness from a selected repair family.
2. Cubic target, radius three: identify every edge with a pair of other projective cubic points
   and its unique axis completion; prove `nu=(q-1)/2` and `tau=q-1`.
3. Axis target, radius three: split the clutter into the complete pair graph on the other `q` axis
   points and a projective cubic-triple completion fiber; prove the fiber is equivalent to the
   existing zero-sum system and derive `nu=(5q-3)/6`, `tau=2q-1-Z3(q)`.
4. Prove the rank-four circuit-size bound in the code-derived API, so radius four contains every
   minimal inner repair.
5. Prove the full-inner transversal formula from a kernel-checked blocker/local-primal statement
   or an equally explicit direct argument. Prove the axis matching upper bound by a weighted
   vertex budget and reuse the radius-three matching for equality.
6. State separately what transfers to a lift: equality of bounded radius-four supports, not the
   unbounded full port of the concatenated code.

If the general projective completion fiber does not reduce cleanly to the existing zero-sum
hypergraph, retain C111 as a seed theorem and demote C112–C113. If exact radius-four transversals
require substantial new finite-geometry input, ship the proved radius-three family first and keep
the full-port result queued.

## Publication gate

No abstract, introduction, table-of-results, `papers-index.md`, or novelty wording changes until
C114. Formal correctness is not novelty evidence. The bare twisted cubic, common axis, and generic
rank-four circuit cutoff are classical/standard; novelty review targets the exact union-code repair
profiles and their bounded-support asymptotic transfer.
