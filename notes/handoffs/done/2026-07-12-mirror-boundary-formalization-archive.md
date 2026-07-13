# Mirror-boundary formalization — archive

Append-only companion to
[`../2026-07-12-mirror-boundary-formalization.md`](../2026-07-12-mirror-boundary-formalization.md).
The live handoff holds current state; dated session notes, validation output, superseded plans, and
closed-negative proof routes belong here.

## 2026-07-12 — dedicated lane created

- Allocated C85–C88 for quadratic split isotropy, Hermitian linear classification,
  Baer-semilinear fixed-subgeometry intersection, and elliptic Witt/Scharlau transfer.
- Seeded the lane from the strict-gate audit landed in commit `091bae0`: the hyperbolic positive
  theorem is formal, the parabolic nonsplit linear obstruction is formal, and the common
  eigenline/fixed-point reduction is formal.
- Preserved the general elliptic `Q⁻(2m−1,q)`, `m≥3`, exclusion as conjectural pending C88.
- Routed `AGENTS.md`, the main projective-cap handoff, the detailed boundary specification, and the
  global task queue to the dedicated live handoff.

## 2026-07-12 — C85 reported

- Added `ProjectiveCap/FiniteQuadraticIsotropy.lean`. The reusable theorem
  `exists_ne_zero_quadraticForm_eq_zero` diagonalizes a finite odd-characteristic quadratic form
  and applies Mathlib's Chevalley–Warning theorem to its weighted sum-of-squares polynomial.
- Added the `±1` eigenspace complement and dimension argument in `MirrorBoundary.lean`, then closed
  the adversarial normalization gap: `hasFixedPointOn_quadric_of_sq_square_finrank_five` handles
  the actual projective representative hypothesis `g² = r²I`, proves scalar rescaling leaves its
  projectivization unchanged, and produces an isotropic fixed point.
- The load-bearing parabolic conclusion is
  `parabolic_split_scalar_square_route_not_fixedPointFree`. Together with the already-landed
  determinant-parity theorem, both linear parabolic branches are formal. The Baer-semilinear
  branch remains C87, so the full parabolic row is not yet promoted to Lean-proved.
- Validation:
  - `choom -n 1000 -- nix develop --command lake build ProjectiveCap.FiniteQuadraticIsotropy` — PASS.
  - `choom -n 1000 -- nix develop --command lake build ProjectiveCap.MirrorBoundary` — PASS, clean.
  - `choom -n 1000 -- nix develop --command lake build ProjectiveCap` — PASS (`8656` jobs).
  - Axiom audit of the weighted-squares, general isotropy, eigenspace, normalized and scalar-square
    fixed-point, and parabolic theorems: exactly `[propext, Classical.choice, Quot.sound]`.
  - Source search over both affected files: no `sorry`, `native_decide`, or `axiom` declaration.

## 2026-07-12 — C86 reported

- Added `ProjectiveCap/FiniteHermitian.lean` around the canonical relative Frobenius of a quadratic
  finite-field extension. It proves the exact norm formula, norm surjectivity, and the new
  square-reflection lemma: if `Norm(c)` is square in the base field, then `c` is square upstairs.
- Formalized two-vector Hermitian orthogonalization. A Hermitian form whose diagonal values lie in
  the base field has a nonzero isotropic vector in every dimension at least two; no nondegeneracy
  hypothesis is needed for this existence theorem.
- Closed the split route in `MirrorBoundary.lean`: a scalar-square projective involution in vector
  dimension at least three has a two-dimensional eigenspace and hence an isotropic fixed point.
- Closed the nonsplit route for the standard general-unitary interface: applying a similitude with
  base-field multiplier `μ` twice gives `Norm(c)=μ²`; square reflection contradicts nonsquare `c`.
  This replaces the prose shortcut “`c` lies in the base field,” which is stronger than needed and
  is not used by the formal proof.
- The Hermitian structure explicitly records conjugate symmetry and that diagonal values lie in
  the base field. The nonsplit theorem explicitly requires nondegeneracy and a base-field
  similitude multiplier, so no stabilizer-classification assumption is hidden.
- Validation:
  - `choom -n 1000 -- nix develop --command lake build ProjectiveCap.FiniteHermitian` — PASS, clean.
  - `choom -n 1000 -- nix develop --command lake build ProjectiveCap.MirrorBoundary` — PASS, clean.
  - `choom -n 1000 -- nix develop --command lake build ProjectiveCap` — PASS (`8657` jobs).
  - Axiom audit of the norm, square-reflection, isotropy, multiplier, split, and nonsplit theorems:
    exactly `[propext, Classical.choice, Quot.sound]`.
  - Source search over both affected files: no `sorry`, `native_decide`, or `axiom` declaration.

## 2026-07-12 — C87 coordinate layer landed; general descent remains open

- Added `ProjectiveCap/BaerSemilinear.lean`. Coordinatewise relative Frobenius over a quadratic
  finite-field extension is formalized as an injective semilinear map; its square is the identity,
  its projectivization is an involution, and every projective point represented over the base field
  is fixed.
- Proved that a quadratic board whose restriction is a base-field quadratic form meets this fixed
  subgeometry in vector dimension at least three. The parabolic coordinate theorem exposes that
  restriction/descent statement as a hypothesis rather than hiding it.
- For Hermitian boards, constructed the base-field quadratic restriction internally from
  `IsHermitian.diagonal_mem_base`, proved its quadratic laws by mapping them into the extension,
  and applied finite quadratic isotropy. Thus every nontrivial Hermitian board has a fixed point
  under coordinate Frobenius without an external descent hypothesis.
- Added `hasFixedPointOn_of_conjugate`, the exact final transport interface for a future general
  semilinear classification.
- Adversarial Mathlib inventory found projectivization support for injective semilinear maps and
  scalar Hilbert 90 for `Lˣ`, but no nonabelian Hilbert-90/descent theorem for `GL_n` or `PGL_n`.
  The remaining C87 core is therefore real mathematics: from `A·τ(A)=cI`, normalize the scalar and
  prove the matrix cocycle is a coboundary; then descend a preserved parabolic zero locus to the
  fixed field. The general parabolic and Hermitian semilinear rows remain unpromoted.
- Validation:
  - `choom -n 1000 -- nix develop --command lake build ProjectiveCap.BaerSemilinear` — PASS,
    warning-free (`3001` jobs).
  - `choom -n 1000 -- nix develop --command lake build ProjectiveCap` — PASS (`8658` jobs).
  - Axiom audit of coordinate involutivity, fixed base points, Hermitian restriction, conjugacy
    transfer, both intersection theorems, and both route conclusions: exactly
    `[propext, Classical.choice, Quot.sound]`.
  - Source search over the mirror-boundary files: no `sorry`, `native_decide`, or `axiom`
    declaration.

## 2026-07-12 — C87 general Baer conjugacy and Hermitian branch closed

- Replaced the anticipated nonabelian-Hilbert-90 dependency with a constructive order-two proof.
  For every vector `v`, two explicit fixed vectors formed from `v`, `S(v)`, and a scalar moved by
  Frobenius recover `v`; hence fixed vectors span. Mathlib's `Basis.ofSpan` extracts a basis
  contained in that set, and reindexing it by `Fin (finrank K V)` conjugates `S` to coordinate
  Frobenius.
- Extended from literal involutions to projective square-scalar representatives. The square scalar
  is Frobenius-fixed, the finite Galois fixed-field theorem descends it to the base field, and norm
  surjectivity supplies a scalar normalization. The resulting projective equivalence theorem
  handles arbitrary nonzero square scalars.
- Pulled arbitrary Hermitian forms back through the fixed basis and applied the intrinsic
  base-quadratic restriction. This proves every modeled Baer-semilinear projective involution fixes
  a point on every Hermitian board of vector dimension at least three; board preservation is not
  needed for the intersection.
- The remaining C87 blocker is solely parabolic: turn preservation of a nondegenerate projective
  quadratic zero locus into a semisimilitude and descend/normalize its form.
- Validation:
  - `choom -n 1000 -- nix develop --command lake build ProjectiveCap.BaerSemilinear` — PASS,
    warning-free (`3001` jobs).
  - `choom -n 1000 -- nix develop --command lake build ProjectiveCap` — PASS (`8658` jobs).
  - New spanning, basis, fixed-field, vector/projective conjugacy, and full Hermitian theorems have
    axiom profile exactly `[propext, Classical.choice, Quot.sound]`.

## 2026-07-12 — C87 quadratic semisimilitude descent landed

- Added `ProjectiveCap/BaerQuadraticDescent.lean` with an elementary order-two scalar Hilbert-90
  proof, including the exceptional multiplier `-1` case.
- Constructed a base-field quadratic form from Frobenius-fixed values by mapping the quadratic and
  polar identities through the injective algebra map.
- Proved that a nonzero coordinate-Frobenius quadratic semisimilitude has norm-one multiplier,
  normalizes to Frobenius-fixed values, and fixes a point on its projective quadric in dimension at
  least three. The parabolic-dimensional not-fixed-point-free wrapper is formal.
- The only remaining C87 theorem package is the geometric rigidity bridge: a semilinear projective
  transformation preserving a nondegenerate parabolic zero locus must act by a scalar
  semisimilitude of the defining quadratic form.
- Validation:
  - `choom -n 1000 -- nix develop --command lake build ProjectiveCap.BaerQuadraticDescent` — PASS,
    warning-free (`3002` jobs).
  - `choom -n 1000 -- nix develop --command lake build ProjectiveCap` — PASS (`8659` jobs).
  - Scalar normalization, descended form, multiplier norm, and coordinate parabolic obstruction
    axioms: exactly `[propext, Classical.choice, Quot.sound]`.

## 2026-07-12 — C87 stabilizer theorem imported conditionally

- Added `ProjectiveCap/BaerQuadraticStabilizerAssumption.lean`, quarantining the standard
  odd-characteristic theorem that an injective semilinear map preserving the zero locus of a
  nondegenerate quadratic form in vector dimension at least three is a semisimilitude. The
  characteristic and dimension hypotheses are explicit; omitting them would overstate the theorem
  (an anisotropic binary zero locus does not determine a form).
- Added `ProjectiveCap/BaerQuadraticStabilizer.lean`. It feeds the imported multiplier into the
  already-proved scalar Hilbert-90 and quadratic descent chain, yielding the coordinate parabolic
  fixed-point obstruction from zero-locus preservation. The module is imported by `ProjectiveCap`.
- Trust status is deliberately conditional. `#print axioms` on the imported declaration and both
  consequences reports the named stabilizer axiom in addition to
  `[propext, Classical.choice, Quot.sound]`; C87 therefore remains active under the strict gate.
- Cheap-discharge assessment: for the standard Witt form `d z² + Σ xᵢyᵢ`, coefficient rigidity
  should be elementary. Totally singular coordinate subspaces remove pure terms; mixed isotropic
  vectors remove off-diagonal coefficients; two-pair cancellations identify diagonal
  coefficients and remove the `z`-mixed terms. The remaining cost is arbitrary-form transport:
  the local Mathlib inventory has weighted-sum-of-squares diagonalization, but no located
  parabolic Witt-basis/normal-form theorem. The two viable strict routes are therefore (a) prove
  the standard-model coefficient lemma plus a Witt-normalization theorem, or (b) develop the
  coordinate-free tangent-hyperplane/polarity argument.
- Literature status: this is standard classical-polar-space geometry (the full ambient
  collineation group of a nondegenerate quadric is the corresponding projective semisimilarity
  group), not a theorem previously proved in the project prose. The prose had used `PΓO` as the
  stabilizer notation without supplying the bridge.
- Validation:
  - `nix develop --command lake build ProjectiveCap.BaerQuadraticStabilizer` — PASS (`3006` jobs).
  - `nix develop --command lake build ProjectiveCap` — PASS (`8661` jobs) after the final scope
    tightening.
  - Source contains the one intentional quarantined `axiom`; no `sorry` or `native_decide` was
    introduced.

## 2026-07-12 — C87 strict parabolic closure reported

- Replaced and deleted `ProjectiveCap/BaerQuadraticStabilizerAssumption.lean`; the temporary
  literature axiom no longer occurs in the import graph.
- Added `ProjectiveCap/BaerQuadraticUntwist.lean`. For a relative-Frobenius semilinear map `S`, it
  packages `v ↦ conj (Q (S v))` as an ordinary quadratic form and converts proportionality of that
  form to the required semisimilitude multiplier.
- Added `ProjectiveCap/QuadraticNullCone.lean`. The proof constructs a normalized hyperbolic pair,
  proves that isotropic vectors span, splits off the pair, and shows its orthogonal complement is
  nondegenerate of dimension at least three. Applying isotropic spanning in the complement kills
  all cross terms and proves coordinate-free that any quadratic form with the same null cone as a
  nondegenerate form is a nonzero scalar multiple in vector dimension at least five. This avoids a
  Witt-normal-form dependency and is uniform over odd finite fields, including `𝔽₃`.
- Reworked `ProjectiveCap/BaerQuadraticStabilizer.lean` to derive the semisimilitude locally, feed it
  through the already-proved descent obstruction, and transport the fixed point through the
  general projective conjugacy. The final
  `parabolic_baer_boardStabilizer_not_fixedPointFree` theorem takes projective board preservation
  directly, so no vector/projective zero-locus equivalence is left implicit.
- C87a–d all close: semilinear untwisting, null-cone rigidity, arbitrary-form transport, axiom
  deletion, and strict audit. The modeled parabolic and Hermitian square-scalar Baer-semilinear
  branches are now Lean-proved. C88 is the only remaining mirror-boundary math package.
- Validation:
  - `nix develop --command lake build ProjectiveCap.QuadraticNullCone` — PASS (`1908` jobs).
  - `nix develop --command lake build ProjectiveCap.BaerQuadraticStabilizer` — PASS (`3008` jobs).
  - `nix develop --command lake build ProjectiveCap` — PASS (`8662` jobs), including the final
    projective-interface wrapper.
  - Axiom audit of the normalized pair, isotropic spanning, complement, null-cone rigidity,
    untwisting, semisimilitude, coordinate obstruction, full conjugacy transport, and projective
    board-stabilizer theorem: exactly `[propext, Classical.choice, Quot.sound]`.
  - Source search over the three C87 files: no `sorry`, `native_decide`, or `axiom` declaration.

## 2026-07-12 — C88 elliptic conjecture overturned and reported

- The proposed `Q⁻(2m−1,q)` exclusion is false. For a nonsquare `δ`, the uniform block map
  `(x,y)↦(δy,x)` squares to `δI`, has no projective fixed point, and can scale an anisotropic
  binary tail by the same factor `δ` as every hyperbolic pair.
- Added `ProjectiveCap/EllipticQuadricMirror.lean`. A three-variable Chevalley–Warning zero proves
  existence of `u,w` with `u≠0` and `discrim u w (uδ)=δ`. The binary form
  `u x² + wxy + uδy²` is therefore anisotropic, and the standard form consisting of any number
  of hyperbolic pairs plus this tail is a factor-`δ` similarity for the block map.
- The resulting projective involution preserves the standard elliptic quadric and the generic
  sub-board mirror theorem proves its cap game P in every even vector dimension. A separate theorem
  transports P/N values through any supplied projective linear equivalence, keeping the strict
  coordinate theorem distinct from the conventional classification of presentations of `Q⁻`.
- The earlier `Q⁻(5,3)` negative machine anchor had applied the block map to an incompatible tail;
  it did not test the full similitude family and is superseded. The false result was never promoted
  beyond conjectural status, so no proved theorem was retracted.
- Mathematical strengthening: the quadratic mirror boundary is parity-based, not type-based.
  Hyperbolic and elliptic even-dimensional forms are positive mirror families; the modeled
  odd-dimensional parabolic branch is method-negative. This does not affect the odd-`q`
  projective-plane conjecture, whose vector dimension is three.
- Validation:
  - `nix develop --command lake build ProjectiveCap.EllipticQuadricMirror` — PASS, warning-free
    (`2998` jobs).
  - `nix develop --command lake build ProjectiveCap` — PASS (`8663` jobs).
  - Axiom audit of anisotropy, coefficient existence, similarity, projective preservation, the P
    theorem, and equivalence transport: exactly `[propext, Classical.choice, Quot.sound]`.
  - Source search: no `sorry`, `native_decide`, or `axiom` declaration.
