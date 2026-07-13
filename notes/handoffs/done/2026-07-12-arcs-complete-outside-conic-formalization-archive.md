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

## 2026-07-12 — C95 characteristic-two nucleus constraints landed

- Added `RelativeConicArcs/Nucleus.lean`. First proved abstractly that every line meets a
  `(q+2)`-arc in zero or two points: a hypothetical tangent would give an injection from the other
  `q+1` arc points onto the `q+1` lines through its unique intersection point, forcing a second
  point on that line.
- Defined the standard nucleus `[0:1:0]`. Determinant factorizations for three Veronese vectors and
  for the nucleus plus two Veronese vectors prove that the standard conic together with the nucleus
  is a hyperoval when `(2 : K)=0`. It follows that a line meets the conic once exactly when it
  contains the nucleus, and otherwise meets it zero or two times.
- Re-expressed hole incidence as a line-first sum over secants. This proves that its parity is the
  tangent-secant count and that it is at least that count. At an arc point the secant index is
  `|A|-1`, while at an external nucleus relative completeness and the maximum-index lemma give
  `1≤r_A(ν)≤floor(|A|/2)`.
- Proved both manuscript cases: nucleus-in has exactly `|A|-1` tangent secants; nucleus-out has
  exactly `r_A(ν)`. Both expose incidence lower bounds, parity, and the strengthened corrected
  inequalities in subtraction-free natural-number form.
- Validation: `nix develop --command lake build RelativeConicArcs.Nucleus RelativeConicArcs`
  completed successfully with 3057 jobs and no source warnings. Forbidden-token and import-isolation
  scans passed. The hyperoval, tangent classification, parity, both constraint packages, and both
  corrected inequalities audit to `[propext, Classical.choice, Quot.sound]`.

## 2026-07-12 — C96 certified examples and end-to-end trust audit landed

- Added explicit computational models of `GF(8)`, `GF(9)`, and `GF(16)` with the manuscript's
  polynomial-basis encodings. All field laws are discharged by kernel `decide`.
- Added a field-generic raw-coordinate checker for conic disjointness, the arc condition, and
  relative coverage. A normalization theorem proves it is enough to inspect the canonical charts
  `[1:y:z]`, `[0:1:z]`, and `[0:0:1]`; `check_sound` transports acceptance to semantic
  `CompleteOutside`, and `rhoC_le_length_of_check` does not assume normalized or distinct data.
- Copied the four witness lists verbatim from the manuscript verifier. The `q=16` certificate was
  split into disjointness, arc, four affine coverage chunks, tail coverage, and aggregates to keep
  kernel reduction within memory limits. The `q=8,9,11` checks and every split `q=16` leaf pass.
- Proved exact arithmetic thresholds `L2(8)=L2(9)=L2(11)=6` and `L2(16)=8`, then combined them
  with the checked witnesses to prove `rhoC=6` over the explicit fields of orders 8, 9, and 11 and
  `8≤rhoC≤9` over `GF(16)`.
- Re-ran the source verifier at SHA-256
  `e9508958d604e68c6c3d09fd3afadfaa8a3126508a51f1dfa993e7a7aed5d36a`; its four output rows
  match the frozen trust manifest. The standalone `RelativeConicArcs` aggregate builds without
  warnings. Forbidden-token and reverse-import scans pass. The certificate bridge, arithmetic
  thresholds, and final numerical results all audit to `[propext, Classical.choice, Quot.sound]`.
- Final consequence review separated formal facts from novelty claims. Besides the generic
  certificate strengthenings, the declarations immediately yield a cap-game localization reading
  of `CompleteOutside`, field-isomorphism and arbitrary-hole checker extensions are cheap next
  targets, and the `q=11` witness's `I_C=0` gives an exterior-secant design with forced required
  index distribution `(N₁,N₂,N₃)=(90,15,10)`. The latter interpretation warrants a focused
  literature check before any novelty claim.
- Synchronized the manuscript abstract and finite-example discussion, proof audit, package README,
  and `papers/papers-index.md` with the completed strict-trust Lean package. The paper now spells out
  the `q=11` exterior-secant consequence and distinguishes it from a novelty claim. Rebuilt
  `arcs_complete_outside_conic.pdf` successfully with Tectonic.
- Follow-up registry audit found that the results table still compressed the formalization into five
  rows. Expanded it to record the relative-completeness foundation, both secant moments, defect
  corollaries/stability, conic normalization, corrected finite bound, reusable transitive-action
  lemma, certificate soundness, exact `L2` arithmetic, and the `q=11` exterior-secant design.
- Odd-plane relevance check reconstructed the residual conic game of every frozen witness directly
  from the certified coordinates. At `q=8,9,16` every conic point is already covered, so those
  witnesses are ordinary complete arcs with empty residual. At `q=11` all 12 conic points are live;
  the residual has 30 edges, constant degree 5, exact Grundy value zero, and an explicit graph
  isomorphism to the icosahedral graph. Its antipodal symmetry supplies a conceptual P proof. This
  gives a concrete depleted-order/polyhedral base object but does not bridge the active size-3 to
  size-4 odd-plane escape step.
