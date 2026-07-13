# Handoff: arcs complete outside a conic — Lean formalization

**Date:** 2026-07-12
**Status:** COMPLETE
**Tasks:** C89–C96

## Goal

Formalize the mathematical results of
[`papers/arcs_complete_outside_conic/`](../../../papers/arcs_complete_outside_conic/) in a standalone
Lean library under `lean/RelativeConicArcs/`. The delivered formalization should expose the exact
prescribed-hole defect identity, its finite and asymptotic consequences, projective averaging,
the characteristic-two nucleus constraints, and certificate-checked small examples with an
explicit trust boundary.

This is a spinoff of the projective-cap program, not a new dependency of it. Session history belongs
in
[`2026-07-12-arcs-complete-outside-conic-formalization-archive.md`](2026-07-12-arcs-complete-outside-conic-formalization-archive.md).

## Sources and theorem inventory

The manuscript and its proof audit are the statement-level sources of truth:

- [`README.md`](../../../papers/arcs_complete_outside_conic/README.md)
- [`arcs_complete_outside_conic.tex`](../../../papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex)
- [`arcs_complete_outside_conic_proof_audit.md`](../../../papers/arcs_complete_outside_conic/arcs_complete_outside_conic_proof_audit.md)
- [`lean/TRUST.md`](../../../lean/TRUST.md) for the repository's kernel/audit posture

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
| `FiniteFields.lean`, `Certificate.lean`, `Examples.lean`, `ExampleChecks/`, `Results.lean` | Explicit small fields, rules-only generic witness checker, frozen witness data and split checks for `q=8,9,11,16`, exact `L2` arithmetic, and final small-order theorems. |
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
| generic raw-coordinate checker, canonical projective normalization, and semantic certificate bridge | `RelativeConicArcs/Certificate.lean` | Lean-proved for every finite field |
| explicit `GF(8)`, `GF(9)`, and `GF(16)` models with kernel-checked field laws | `RelativeConicArcs/FiniteFields.lean` | Lean-proved |
| frozen witnesses and split kernel checks at `q=8,9,11,16` | `RelativeConicArcs/Examples.lean`, `RelativeConicArcs/ExampleChecks/` | Lean-proved |
| `L2(8)=L2(9)=L2(11)=6`, `L2(16)=8`; exact `rhoC` at 8, 9, 11, 16 | `RelativeConicArcs/Results.lean`, `RelativeConicArcs/Q16Result.lean` | Lean-proved (q=16 closed by C101) |

The standalone `RelativeConicArcs` target builds without warnings. The C89–C96 headline axiom profiles
are `[propext, Classical.choice, Quot.sound]`; no proof uses `sorry`, `native_decide`, `admit`, or a
custom axiom. Existing Lean targets do not import the spinoff.

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
| **C96 [REPORTED 2026-07-12]** | Build a no-`native_decide` rules-only certificate checker; import/regenerate the four manuscript witnesses; prove `rhoC(8)=rhoC(9)=rhoC(11)=6` and `8≤rhoC(16)≤9`; complete the theorem manifest and trust audit. | C92; independent witness work can begin after C89 | Finite examples and the end-to-end paper audit landed. |

## Discovery track for final review

Keep a running classification of consequences noticed during C96, and return to it after the trust
audit: proved corollaries, cheap formal extensions, genuine paper strengthenings, applications, and
speculative directions must be distinguished explicitly.

- **Proved strengthening:** certificate coverage needs only the canonical representatives
  `[1:y:z]`, `[0:1:z]`, and `[0:0:1]` (`q²+q+1` cases); a generic normalization theorem transports
  this check to every nonzero coordinate representative.
- **Proved reusable corollary:** any accepted raw-vector certificate over any finite field gives
  `rhoC ≤ witness.length`, without requiring normalized, duplicate-free, or projectively distinct
  input data.
- **Proved but not separately named:** conic normalization transports the four numerical results
  from the standard conic to every represented nonsingular conic over the same field. The general
  finite transitive-action lemma and the abstract fact that every line meets a `(q+2)`-arc in zero
  or two points are also reusable independently of this conic problem.
- **Proved application bridge:** `projectiveCap_subset_union_of_completeOutside` shows every cap
  continuation containing `A` lies in `A ∪ H`; `move_mem_holes_of_completeOutside` and
  `legalExtensions_subset_holes_of_completeOutside` show that every later legal move remains
  confined to `H`. Thus the conic case is formally a persistent conic-residual localization gadget,
  without making a game-value or reachability claim.
- **Cheap formal extensions:** prove invariance under finite-field isomorphism so the small results
  quantify over every field of the stated order; factor the checker through an arbitrary
  projectively invariant decidable hole predicate; and add exact point-set cardinality when the
  input list is pairwise projectively distinct.
- **Concrete surprise / literature-audit candidate:** the `q=11` witness has `I_C=0`, hence all 15
  secants are exterior to the conic. The two moment equations then force the required-point index
  distribution to be exactly 90 points of index 1, 15 of index 2, and 10 of index 3. The manuscript
  records `I_C=0` but does not draw out this external-secant design interpretation; formalizing and
  checking its prior art is a focused follow-on.
- **Odd-`q` game use (exact computation, not yet Lean-packaged):** after the certified `q=11`
  six-arc is occupied, every off-conic point is sealed and all 12 conic points remain legal. Their
  residual conflict graph is the icosahedral graph (12 vertices, 30 edges, degree 5), whose
  antipodal involution proves Node--Kayles value zero. Thus the witness is an explicit P-position
  and an `A5`/polyhedral boundary object for the depleted `q=11` odd-plane lane. The `q=9` witness
  is stronger still as an ordinary complete six-arc (empty residual). These are possible descent
  targets/base cases, not a proof of the size-3 to size-4 escape lemma.
- **Uniform odd-`q` limitation/use:** relative completeness supplies a rigorous sealing endpoint and
  the uncovered/defect inequalities can feed a drain potential, but the lower bound shows that an
  intruder-only conic seal needs order `sqrt(q)` points. It therefore cannot by itself be the
  bounded-size forcing mechanism sought by (ON); a containment, descent, or exchange lemma is still
  required.
- **Novelty boundary:** the localization corollary and the `q=11` design interpretation are logical
  consequences, not priority claims. Field-isomorphism transport and the arbitrary-hole checker
  are engineering/generalization opportunities. Any assertion that these are new requires a
  targeted literature audit.

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

The formalization lane is closed. The named cap-game localization bridge and q=11 icosahedral
residual P theorem have landed under C100. Optional follow-ons include field-isomorphism transport
of the small results, a Lean theorem capturing the `q=11` exterior-secant/index distribution, and
the broader theorem-mining/literature review tracked separately as C98. C101 closed the remaining
finite gap with the exact value `rhoC(16)=9`; see the
[finished C101 handoff](2026-07-12-rhoc16-exact-value.md).
