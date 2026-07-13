# Handoff: arcs complete outside a conic — Lean formalization

**Date:** 2026-07-12
**Status:** IN PROGRESS
**Tasks:** C89–C96

## Goal

Formalize the mathematical results of
[`papers/arcs_complete_outside_conic/`](../../papers/arcs_complete_outside_conic/) in a standalone
Lean library under `lean/RelativeConicArcs/`. The delivered formalization should expose the exact
prescribed-hole defect identity, its finite and asymptotic consequences, projective averaging,
the characteristic-two nucleus constraints, and certificate-checked small examples with an
explicit trust boundary.

This is a spinoff of the projective-cap program, not a new dependency of it. Session history belongs
in
[`done/2026-07-12-arcs-complete-outside-conic-formalization-archive.md`](done/2026-07-12-arcs-complete-outside-conic-formalization-archive.md).

## Sources and theorem inventory

The manuscript and its proof audit are the statement-level sources of truth:

- [`README.md`](../../papers/arcs_complete_outside_conic/README.md)
- [`arcs_complete_outside_conic.tex`](../../papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex)
- [`arcs_complete_outside_conic_proof_audit.md`](../../papers/arcs_complete_outside_conic/arcs_complete_outside_conic_proof_audit.md)
- [`lean/TRUST.md`](../../lean/TRUST.md) for the repository's kernel/audit posture

The formalization covers:

1. arc, secant, point-index, prescribed-hole completeness, uncovered locus, existence of maximal
   relative arcs, and `rhoC`;
2. the maximum-index lemma and both classical secant-index equations;
3. the exact prescribed-hole defect identity, coverage/uncovered bounds, equality criterion, and
   quantitative stability;
4. conic specialization, `L1`/`L2`, parity-dependent corrected capacities, and exact finite lower
   bounds;
5. the `sqrt (2q) + 3/2` asymptotic lower bound and liminf statement;
6. projective averaging and the transfer from ordinary complete arcs;
7. both even-characteristic nucleus propositions; and
8. the certified values at `q = 8, 9, 11` and bounds at `q = 16`.

The open problems and novelty/prior-art statements are prose, not Lean targets. The Kim–Vu bound is
an external deep theorem: its Lean corollary must take a named, cited hypothesis rather than add a
global axiom.

## Isolation and reuse boundary

- Add a separate `RelativeConicArcs` Lean library, root module `RelativeConicArcs.lean`, and source
  directory `lean/RelativeConicArcs/`.
- Paper-specific definitions, coordinate conics, asymptotic wrappers, and certificate data stay in
  that directory. Existing `ProjectiveCap`, `FiniteGeom`, and other libraries must not import it.
- Reuse existing assets only through one-way imports, especially
  `ProjectiveCap.Projective`, `ProjectiveCap.PlaneTransitivity`, and the generic pair-cover idea in
  `ProjectiveCap.CompleteCapLowerBound`. Put compatibility results in
  `RelativeConicArcs/ProjectiveBridge.lean`; do not duplicate or move game-side APIs.
- If a genuinely general missing lemma belongs upstream, land it separately with its own consumers
  and validation. Do not make unrelated existing modules paper-aware.
- Namespace all new declarations under `RelativeConicArcs`.

## Proposed module map

| Module | Responsibility |
|---|---|
| `Plane.lean` | Minimal finite projective-plane incidence interface of order `q`; lines, unique joins/intersections, uniform line size, and point count. |
| `Arc.lean` | Arcs, pair secants, point index `r_A`, prescribed holes, covered/uncovered loci, completeness, and `rhoC`. |
| `Moments.lean` | Maximum-index lemma and the first/second secant-index equations by finite double counting. |
| `Defect.lean` | Split moments, exact defect identity, nonnegativity, equality criterion, coverage/uncovered bounds, and stability. |
| `ProjectiveBridge.lean` | Coordinate `PG(2,q)` instance and compatibility with `ProjectiveCap.Projective.Cap`; projective transport. |
| `Conic.lean` | Standard nonsingular conic, parametrization/cardinality, projective normalization/invariance, conic-completeness, conic incidence, `L1`/`L2`, and finite lower bounds. |
| `Asymptotic.lean` | Parity-free necessary inequality, an explicit quantitative lower bound, then Big-O and liminf corollaries. |
| `Averaging.lean` | Finite transitive-action averaging lemma, `GL(3,q)`/projective instantiation, and complete-arc transfer. |
| `Nucleus.lean` | Standard even-field nucleus/tangent facts and the two nucleus incidence propositions. |
| `Certificate.lean`, `CertData/`, `Examples.lean` | Rules-only witness checker, generated witness data for `q=8,9,11,16`, exact `L2` arithmetic, and final small-order theorem. |
| `TRUST.md` | Theorem manifest, printed axiom profiles, conditional external inputs, and certificate provenance. |

The exact file split may be compressed when adjacent modules remain small, but the abstraction,
coordinate, analytic, and certificate layers must remain visibly separate.

## Landed foundation

| Result | Lean location | Status |
|---|---|---|
| Mathlib projective-plane order, point count, and uniform line-cardinality wrappers | `RelativeConicArcs/Plane.lean` | Lean-proved |
| arc, secant, point index, covered/required/uncovered loci, relative completeness, and `rho` | `RelativeConicArcs/Arc.lean` | Lean-defined |
| uncovered-locus characterization; maximal relative arc exists; `rho` is attained and minimal | `RelativeConicArcs/Arc.lean` | Lean-proved |
| coordinate `PG(2,K)` has order `|K|` | `RelativeConicArcs/ProjectiveBridge.lean` | Lean-proved |
| incidence `Arc` agrees with `ProjectiveCap.Projective.Cap` on coordinate `PG(2,K)` | `RelativeConicArcs/ProjectiveBridge.lean` | Lean-proved |
| unordered endpoint pairs correspond injectively to secant lines; line-based and pair-based point indices agree | `RelativeConicArcs/Moments.lean` | Lean-proved |
| external maximum-index bound `r_A(x) ≤ floor (|A|/2)` | `RelativeConicArcs/Moments.lean` | Lean-proved |
| first moment `Σ_{x∉A} r_A(x) = C(|A|,2)(q−1)` | `RelativeConicArcs/Moments.lean` | Lean-proved |
| second moment `Σ_{x∉A} C(r_A(x),2) = 3C(|A|,4)` | `RelativeConicArcs/Moments.lean` | Lean-proved |
| split first/second moments over covered required points and prescribed holes | `RelativeConicArcs/Defect.lean` | Lean-proved |
| exact integer-normalized defect identity and nonnegativity | `RelativeConicArcs/Defect.lean` | Lean-proved |
| coverage and uncovered-locus bounds; exact equality criterion; quantitative stability | `RelativeConicArcs/Defect.lean` | Lean-proved |
| standard Veronese conic equals `XZ=Y²`, is parametrized by `PG(1,K)`, and has `q+1` points | `RelativeConicArcs/Conic.lean` | Lean-proved |
| nonsingular conics as projective images; completeness and `rhoC` are invariant under normalization | `RelativeConicArcs/Conic.lean` | Lean-proved |
| conic-loss/corrected-capacity inequalities and `L1 ≤ L2 ≤ rhoC` | `RelativeConicArcs/Conic.lean` | Lean-proved |
| even/odd closed forms for the rational corrected capacity | `RelativeConicArcs/Conic.lean` | Lean-proved |
| parity-free cubic necessary inequality and explicit `sqrt(2q)+3/2-8/sqrt(2q)` bound | `RelativeConicArcs/Asymptotic.lean` | Lean-proved |
| shortfall is `O(1/sqrt(2q))`; operational and literal liminf wrappers for realized field families | `RelativeConicArcs/Asymptotic.lean` | Lean-proved |
| finite transitive-action averaging: `|A||B|<|X|` gives a disjoint translate | `RelativeConicArcs/Averaging.lean` | Lean-proved |
| projective averaging moves every arc of size at most `q` off any nonsingular conic | `RelativeConicArcs/Averaging.lean` | Lean-proved |
| `rhoC(q) ≤ t2(2,q)` when `t2(2,q) ≤ q`; named Kim--Vu hypothesis interface and transfer | `RelativeConicArcs/Averaging.lean` | Lean-proved, conditional input explicit |
| in characteristic two, the standard conic plus `[0:1:0]` is a hyperoval; tangents are exactly the lines through the nucleus | `RelativeConicArcs/Nucleus.lean` | Lean-proved |
| nucleus-in and nucleus-out tangent counts, conic-incidence lower bounds/parity, and corrected inequalities | `RelativeConicArcs/Nucleus.lean` | Lean-proved |

The standalone `RelativeConicArcs` target builds without warnings. The C89–C95 headline axiom profiles
are `[propext, Classical.choice, Quot.sound]`; its source contains no `sorry`, `native_decide`,
`admit`, or custom axioms. Existing Lean targets do not import the spinoff.

## Work packages

| Task | Required theorem package | Depends on | Completion effect |
|---|---|---|---|
| **C89 [REPORTED 2026-07-12]** | Scaffold `RelativeConicArcs`; define the minimal incidence/arc/hole interfaces; instantiate coordinate `PG(2,q)` and prove compatibility with the existing projective-cap predicate. | None | Isolated library boundary and statement vocabulary landed. |
| **C90 [REPORTED 2026-07-12]** | Prove `r_A(x) ≤ floor (k/2)` and both classical moment equations by explicit finite bijections/double counts. | C89 | Combinatorial engine landed. |
| **C91 [REPORTED 2026-07-12]** | Prove the prescribed-hole defect identity, nonnegativity, coverage and uncovered-locus bounds, exact equality criterion, and quantitative stability. | C90 | Paper's central new identity landed. |
| **C92 [REPORTED 2026-07-12]** | Define the standard conic and its `q+1` parametrization; prove projective transport and normalization of nonsingular plane conics; specialize C91; formalize `L1`, `L2`, parity capacities, and the exact finite lower-bound theorem. | C89–C91 | Finite universal lower-bound layer and conic independence landed. |
| **C93 [REPORTED 2026-07-12]** | Derive the parity-free inequality and formalize the additive `3/2` asymptotic, first as an explicit error bound and then as the manuscript's Big-O/liminf statements along prime powers. | C92 | Analytic headline theorem landed with explicit constant `8`. |
| **C94 [REPORTED 2026-07-12]** | Prove the finite transitive-action averaging lemma, instantiate projective transport, and prove `rhoC(q) ≤ t2(2,q)` under `t2(2,q) ≤ q`; expose Kim–Vu only as a cited named hypothesis. | C89, C92 | Upper-bound transfer landed with the external input represented by `KimVuBound`, not an axiom. |
| **C95 [REPORTED 2026-07-12]** | In even characteristic, prove the standard conic's nucleus/tangent incidence facts and both nucleus-in/nucleus-out propositions, including parity and corrected inequalities. | C89, C92 | Characteristic-two structural section landed, with `(2 : K) = 0` explicit. |
| **C96** | Build a no-`native_decide` rules-only certificate checker; import/regenerate the four manuscript witnesses; prove `rhoC(8)=rhoC(9)=rhoC(11)=6` and `8≤rhoC(16)≤9`; complete the theorem manifest and trust audit. | C92; independent witness work can begin after C89 | Closes the finite examples and the end-to-end paper audit. |

## Dependency and attack order

Begin with **C89**, then take the thin vertical slice **C90 → C91** before investing in coordinate
or analytic infrastructure: the exact defect identity is the paper's core and exercises the
incidence interface directly. Proceed with **C92**, which unlocks C93, C94, and C95. Start C96's
certificate schema after C89, but state the final numerical theorem only after C92 supplies the
analytic lower bounds.

The likely proof-risk order is C90's second-moment bijection, C93's asymptotic packaging, C94's
finite projective-action cardinality, then C95's coordinate tangent classification. Preserve the
paper's elementary proof structure rather than replacing it with opaque computation.

Before editing a nontrivial Lean proof, load the named-expert umbrella and relevant Lean,
combinatorics, finite-geometry, and analysis dossiers as required by `AGENTS.md`.

## Trust and statement gate

- No `sorry`, `native_decide`, `admit`, paper-specific `axiom`, or unproved bridge assumption in
  delivered source.
- Elementary projective-plane, conic, counting, and asymptotic claims used by headline theorems are
  proved. Deep external results are named hypotheses with citations and do not enter the global
  environment as axioms.
- Certificate theorems use generated immutable data plus a small rules-only checker. Record the
  generator/verifier hashes and prove the semantic bridge from checker success to arc,
  disjointness, and relative coverage.
- Every headline theorem has a recorded `#print axioms` result. Unconditional results should show
  only accepted Mathlib foundations; conditional results should expose their imported mathematical
  assumptions in the theorem signature.
- Keep abstract-plane results distinct from coordinate `PG(2,q)` instantiations so the formal claim
  never silently exceeds the available incidence hypotheses.

## Validation gate

For each closed task:

1. Build the smallest affected `RelativeConicArcs` modules, then the library target; do not run a
   heavyweight aggregate with a missing generated-certificate import closure.
2. Search new source for `sorry`, `native_decide`, `admit`, and new `axiom` declarations.
3. Print the axiom profiles of new load-bearing theorems.
4. For certificate tasks, regenerate data from the manuscript verifier inputs, compare frozen
   hashes, build leaves before the aggregate, and cross-check checker conclusions against the
   source witness coordinates.
5. Update this handoff and the global task queue in the same commit; append commands, outputs,
   proof choices, and closed-negative routes only to the companion archive.
6. Verify that no existing Lean target imports `RelativeConicArcs` and that existing unrelated
   targets still build when a shared upstream lemma was changed.

## Next step

Begin C96 by designing the rules-only certificate checker and semantic bridge from accepted
coordinate data to `CompleteOutside`. Import the manuscript witnesses for `q=8,9,11,16`, freeze and
record their provenance, build generated leaves before aggregates, and combine them with exact
`L2` arithmetic to prove the reported values and bounds. Finish with the standalone theorem
manifest and trust audit; do not use `native_decide`.
