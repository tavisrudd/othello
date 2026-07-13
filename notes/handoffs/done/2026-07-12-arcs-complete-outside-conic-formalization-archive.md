# Arcs complete outside a conic formalization — archive

Append-only companion to
[`../2026-07-12-arcs-complete-outside-conic-formalization.md`](../2026-07-12-arcs-complete-outside-conic-formalization.md).
The live handoff holds current state; dated session notes, validation output, superseded plans, and
closed-negative proof routes belong here.

## 2026-07-12 — dedicated spinoff lane created

- Allocated C89–C96 for the isolated incidence foundation, moment equations, defect identity,
  conic lower bounds, asymptotic theorem, projective averaging, even-characteristic nucleus facts,
  and certified small examples.
- Chose a standalone `lean/RelativeConicArcs/` library with one-way reuse from existing Lean code;
  existing projective-cap/game libraries are not consumers of the spinoff.
- Read the manuscript README, theorem statements, proof audit, current Lean trust document, existing
  projective-cap abstractions, and the live handoff/task-queue conventions before fixing the plan.
- Set the trust boundary to kernel-checked elementary claims plus named hypotheses for deep external
  inputs. In particular, the Kim–Vu corollary will not introduce a global axiom.
- Split the implementation into abstract incidence, coordinate conic, analytic, averaging/nucleus,
  and rules-only certificate layers so each headline claim has a legible axiom profile.

## 2026-07-12 — C89 incidence foundation and coordinate bridge landed

- Reused pinned Mathlib's `Configuration.ProjectivePlane` instead of creating a competing incidence
  structure. Its existing API supplies unique joins/intersections, plane order, uniform line size,
  `q²+q+1` point count, and the dual-vector coordinate plane instance.
- Added the standalone `RelativeConicArcs` Lake target and modules `Plane.lean`, `Arc.lean`, and
  `ProjectiveBridge.lean`; no existing Lean target imports the spinoff.
- Formalized arcs, secants, point indices, prescribed required/covered/uncovered loci, relative
  completeness, and `rho`. A maximal-cardinality admissible arc proves that complete relative arcs
  always exist; `Nat.sInf_mem` then proves `rho` is attained.
- Proved the coordinate plane has order `Fintype.card K` and proved incidence `Arc` equivalent to
  `ProjectiveCap.Projective.Cap`. The bridge reduces coordinate collinearity to a `3×3` determinant
  and uses Mathlib's projective cross product for the unique common line.
- Validation: `nix develop --command lake build RelativeConicArcs` completed successfully with 3010
  jobs and no source warnings. A separate `lake env lean` audit printed
  `[propext, Classical.choice, Quot.sound]` for `card_points`, the uncovered characterization,
  maximal completion, attained `rho`, coordinate order, and cap compatibility. A source scan found
  no `sorry`, `native_decide`, `admit`, or custom `axiom`.

## 2026-07-12 — C90 classical secant moments landed

- Added `RelativeConicArcs/Moments.lean`. An `ArcPair A` is a literal unordered two-subset of the
  arc; Mathlib's unique-line axiom supplies its canonical secant line. Arc-ness proves this map is
  injective, so the line-based `pointIndex` agrees with the pair count.
- Proved the maximum-index lemma by showing endpoint pairs of secants through an external point are
  pairwise disjoint. Their union has cardinality `2r_A(x)` and lies in `A`, yielding
  `r_A(x) ≤ floor (|A|/2)`.
- Proved the first moment by swapping the finite point/pair sums. Each endpoint pair's line contains
  exactly `q−1` points outside the arc.
- Proved the second moment through ordered distinct secant pairs. Fibers over external intersection
  points are pairwise disjoint and their union is exactly the ordered disjoint endpoint-pair set;
  its cardinality is `C(k,2)C(k−2,2)=6C(k,4)`. Cancelling the ordering factor gives
  `Σ C(r_A(x),2)=3C(k,4)`.
- Validation: `nix develop --command lake build RelativeConicArcs` completed successfully with 3011
  jobs and no source warnings. A separate axiom audit printed
  `[propext, Classical.choice, Quot.sound]` for pair-line injectivity, pair/line index agreement,
  the maximum-index theorem, and both moment equations. Source and import-isolation scans passed.

## 2026-07-12 — C91 prescribed-hole defect identity landed

- Added `RelativeConicArcs/Defect.lean`. Disjointness of `A` and `H` splits the external locus into
  the holes and required locus; indices vanish on its uncovered part, yielding split forms of both
  C90 moment equations.
- Defined the hole incidence and scaled defect over `ℤ`, while retaining
  `m = floor (|A|/2)` as a natural number before casting. Two termwise binomial identities reduce
  the defect exactly to the sum of required-point terms `(r−1)(m−r)` and hole terms `r(m−r)`.
- Applied the C90 maximum-index theorem termwise to prove nonnegativity. Vanishing of the two
  nonnegative sums gives the exact equality criterion: required covered indices lie in `{1,m}` and
  hole indices in `{0,m}`.
- Derived subtraction-free natural-number coverage and uncovered-locus bounds. Filtered sets of
  intermediate required and hole indices give the stability estimate
  `(m−2)|M| + (m−1)|J| ≤ mΔ`.
- Validation: `nix develop --command lake build RelativeConicArcs.Defect RelativeConicArcs`
  completed successfully with 3012 jobs and no source warnings. Source and import-isolation scans
  passed. A separate audit printed `[propext, Classical.choice, Quot.sound]` for both split moments,
  the exact identity, nonnegativity, equality, coverage, uncovered, and stability theorems.

## 2026-07-12 — C92 conic specialization and finite lower bounds landed

- Added `RelativeConicArcs/Conic.lean` and reused `ProjectiveCap.Sym2ConicBridge` for the Veronese
  map and quadratic equation. Proved that the standard finite conic is exactly the projective zero
  locus `XZ=Y²`, is parametrized injectively by `PG(1,K)`, and has `|K|+1` points.
- Represented a nonsingular conic by a linear projective image of the standard conic. This orbit
  presentation makes the normalization projectivity explicit and avoids importing an unformalized
  quadratic-form classification. Proved relative completeness and `rho` invariant under every
  collinearity-preserving point equivalence, then instantiated the result to show `rhoC` is
  independent of the represented nonsingular conic.
- Specialized C91 first at the abstract `q+1`-hole level, matching the manuscript audit that the
  finite conic bound uses only cardinality. Derived the exact bound retaining conic incidence, the
  corrected capacity after dropping that nonnegative term, and the first-moment capacity bound.
- Defined subtraction-free `L1Admissible` and `L2Admissible` thresholds, proved every complete arc
  has at least three points, and proved the headline chain `L1(q) ≤ L2(q) ≤ rhoC(q)`. Also proved
  the manuscript's rational corrected-capacity formulas separately for `k=2n` and `k=2n+1`.
- Validation: `nix develop --command lake build RelativeConicArcs.Conic RelativeConicArcs`
  completed successfully with 3014 jobs and no source warnings. Source and import-isolation scans
  passed. A separate audit printed `[propext, Classical.choice, Quot.sound]` for the coordinate
  collinearity bridge, conic equation/cardinality, normalization invariance, exact conic bound,
  both parity formulas, and the finite lower-bound theorem.

## 2026-07-12 — C93 additive-3/2 asymptotic landed

- Added `RelativeConicArcs/Asymptotic.lean`. Starting from subtraction-free `L2Admissible`, proved
  the parity-free cubic necessary inequality over both `ℚ` and `ℝ`; the proof explicitly uses
  `floor(k/2) ≤ k/2` and `24*C(k,4)=k(k−1)(k−2)(k−3)`.
- Proved the elementary first-moment estimate `sqrt(2q) ≤ k`. In the branch `k<sqrt(2q)+2`, set
  `a=k−sqrt(2q)`, established `0≤a≤2`, expanded the cubic exactly, and bounded its lower-order
  remainder by `4s²`. This yields the concrete finite theorem
  `k ≥ sqrt(2q)+3/2−8/sqrt(2q)`.
- Applied the finite theorem to the attained standard-conic parameter, proving the same bound for
  `rhoC` at every finite-field cardinality. Indexed families are actual finite fields, so the
  asymptotic wrapper does not quantify over unrealized natural-number orders.
- Defined the positive shortfall and proved it is `O(1/sqrt(2q))`. Proved unconditionally that every
  real `b<3/2` is eventually below `rhoC(q)−sqrt(2q)` along any unbounded realized family. Because
  Mathlib's real-valued `Filter.liminf` cannot represent `+∞`, the literal `liminf` wrapper records
  its required coboundedness side condition; the operational theorem covers both finite and
  `+∞` lower limits.
- Validation: `nix develop --command lake build RelativeConicArcs.Asymptotic RelativeConicArcs`
  completed successfully with 3015 jobs and no source warnings. Source and isolation scans passed.
  All audited cubic, explicit-bound, `rhoC`, Big-O, eventual, and liminf theorems report only
  `[propext, Classical.choice, Quot.sound]`.

## 2026-07-12 — C94 projective averaging transfer landed

- Added `RelativeConicArcs/Averaging.lean`. The reusable finite-action theorem proves that a
  transitive action on finite `X` has a translate of `A` disjoint from `B` whenever
  `|A||B|<|X|`. The proof counts action fibers as stabilizer torsors and applies a finite union
  bound; it does not invoke probability or division.
- Instantiated the theorem with linear automorphisms of `K³` acting on `PG(2,K)`. The projective
  point count `q²+q+1` and conic count `q+1` turn `|A|≤q` into the strict averaging inequality.
  Existing `Projective.mapEquiv` collinearity transport proves that ordinary completeness survives
  the chosen projectivity.
- Defined `t2` as the attained minimum `rho ∅` and proved `rhoC(q)≤t2(2,q)` under `t2(2,q)≤q`.
  The separate `KimVuBound` predicate supplies a named conditional interface for the deep external
  small-complete-arc result; no global axiom is introduced.
- Validation: `nix develop --command lake build RelativeConicArcs.Averaging RelativeConicArcs`
  completed successfully with 3055 jobs and no source warnings. Forbidden-token and import-isolation
  scans passed. The finite averaging, projective disjointness, completeness transport, `t2`
  transfer, and Kim--Vu conditional theorem all audit to
  `[propext, Classical.choice, Quot.sound]`.
