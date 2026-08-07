# Cold referee review: the harmonic-realization formalization route

**Lane:** `clebsch`
**Date:** 2026-08-07

Subject: `notes/2026-08-07-c815-harmonic-realization-scope.md`, the certificate
pair `notes/2026-08-07-c815-harmonic-realization-checks.py` /
`notes/2026-08-07-c815-harmonic-realization-checks.json`, and the two landed
modules `lean/RelativeConicArcs/IcosahedralFaceAxes.lean` and
`lean/RelativeConicArcs/AlternatingComparisonLine.lean`, measured against
`papers/clebsch-passages/sections/05-harmonic-realization.tex` and the standard
in `notes/2026-08-03-c815-paper-iii-formalization-gap-inventory.md` ("Standard
applied") together with `lean/AGENTS.md` ("Referee-facing prose and names",
"Review gate").

## Verdict

**Accept with repairs.** The mathematical route is correct: I recomputed every
claimed identity from scratch — the moment-functional recursion and its
uniqueness, the orthogonal-invariance argument, the apolar identity for
harmonic pairs, all four Leibniz evaluations, the constants `10395 = 11!!` and
`13!! = 135135`, the face-axis geometry, the Legendre orbit values, the Gram
identity `G = K/13` with eigenvalues `110/1053, 140/1053, 28/1053` of
multiplicities `1, 4, 5`, and the quadratic and cubic identities on the
sum-zero module, the last by the independent method of substituting
`y5 = -(y1+y2+y3+y4)` rather than ideal reduction — and found no false,
circular, or under-hypothesized step in the route to the main theorem.  The
two landed Lean modules prove what their statements say, the finite `decide`
propositions check the intended facts, and the committed certificate replays
byte-identically with the recorded hashes.  The repairs are: one docstring
that asserts the reverse of the geometry its theorem proves, the still-assumed
coordinate representative in the comparison theorem, three manuscript
paragraphs that no route row or module owns, and several smaller prose and
plan-table corrections listed below.

## Findings

1. **MAJOR — docstring inverts the angle dichotomy.**
   `lean/RelativeConicArcs/IcosahedralFaceAxes.lean`, docstring of
   `coordinateForm_doubledFaceAxis_sq` (lines 72–76): "So the wider of the two
   angles between distinct axes occurs exactly on the edges of the Kneser
   graph `K(5,2)`."  This is false.  Kneser edges are the disjoint label
   pairs, which the theorem itself sends to squared inner product `80`,
   i.e. squared cosine `5/9`, i.e. the *narrower* axis angle (about 41.8
   degrees versus about 70.5 degrees on meeting pairs).  The sentence also
   contradicts the module header's own correct formulation ("the squared angle
   is the smaller one", lines 28–30).  Under standard item 4 (comments agree
   exactly with elaborated statements) this blocks referee-readiness of the
   module.  Repair: replace with "the narrower of the two angles ... occurs
   exactly on the edges", or phrase it directly in squared inner products.

2. **MAJOR — the coordinate representative `T` is assumed, not constructed.**
   `lean/RelativeConicArcs/AlternatingComparisonLine.lean`,
   `exists_scalar_of_equivariant_comparison` (line 236): the theorem takes as
   hypotheses a linear `T` with `∑ i, T y i = 0` and `pairSum (T y) = Φ y` on
   sum-zero vectors.  The docstring discloses this accurately, the cited
   bijection `RelativeConicArcs.KneserPairEigenspace.existsUnique_pairSum_of_petersenEigen`
   exists and says what the docstring claims, and the HARM-1 ledger row
   records the construction as open — so nothing is misrepresented.  But the
   manuscript derives scalarity from equivariance alone, so under standard
   item 3 the hypothesis cannot stand in for the construction in the final
   surface, and the scope note's module-plan row saying the module "closes
   abstract `A5` comparison of HARM-1" overstates the present state.  Repair:
   add a theorem that, from the hypothesis that `Φ` sends sum-zero vectors to
   Petersen `-2` eigenvectors, builds `T` through the inverse of the pair-sum
   bijection and discharges both `T`-hypotheses; until then, correct the
   plan-table row to name the representative construction as the remaining
   clause.

3. **MAJOR — three manuscript paragraphs have no owning row or module.**
   The manuscript section asserts, beyond the main theorem: (i) the
   covariant-obstruction paragraph ("Nor can a rotation-equivariant polynomial
   covariant induce this linear bridge", resting on
   `Hom_{SO_3}(H_R, H_6) = 0` and the homogeneous-parts argument); (ii) the
   Gaunt-factorization paragraph's non-arithmetic content (the Wigner value
   `(6 6 6; 0 0 0)^2 = 400/46189`, the "universal degree-six Wigner
   denominator" reading, and the multiplicity-one reduction); (iii) the
   Condon–Shortley remark with its two displayed conversion constants.  None
   of these appears in the HARM-1/HARM-2 row scopes, in the scope note's
   module plan, or anywhere else in the gap inventory (checked by search).
   Under the standard, every manuscript assertion needs a kernel-checked
   target or a tracked owner; these currently have neither.  The note's
   sentence "One classical statement is not closed by the route above" is
   true of the route to `thm:harmonic-main` but not of the section.  Repair:
   either allocate inventory rows for (i)–(iii) or state in the scope note
   exactly which paragraphs fall outside the HARM rows and where they are
   owned; scope the "one classical statement" sentence explicitly to the main
   theorem.  For calibration: I verified that the pure arithmetic of those
   paragraphs is right — `46189 = 11·13·17·19`, `46189·27 = 1247103`,
   `400·1960 = 784000`, `13·1247103 = 4563·3553`, and the displayed
   `W_6(F_y)` constant follows exactly from the stated conversion factor
   `-130/sqrt(3553 π)` and the theorem's coefficient — so what is missing is
   ownership of the representation-theoretic and special-function inputs, not
   the arithmetic.

4. **MINOR — the certificate's recursion domain is misdescribed.**
   `notes/2026-08-07-c815-harmonic-realization-scope.md` (certificate
   description, "the integration-by-parts recursion on every monomial of
   degree at most nine"): the script's loop
   `itertools.product(range(4), repeat=3)` checks the monomials with **each
   exponent at most three** — for example `x1^5 x2^2` has degree seven and is
   not checked.  Repair: correct the sentence (or widen the loop and
   regenerate).  The identity itself is fine: I proved it by hand on general
   monomials and checked all exponents up to four in each variable.

5. **MINOR — `A5` generation is asserted but neither certified nor assigned.**
   The scope note states "those three generate the alternating group" and the
   HARM-2 route leans on it (the invariance of `y ↦ M(F_y^3)` under all of
   `A5` needs every even label permutation realized).  Neither the
   certificate nor any planned module checks generation.  I verified it: the
   closure of `(2 5)(3 4)`, `(3 5 4)`, `(1 2)(3 5)` has order 60 and consists
   of even permutations.  Repair: add the closure check to the certificate
   (cheap) and either prove generation in the Lean development or restructure
   `SphericalCubicRestriction` to prove the symbolic identity directly — the
   certificate already shows the identity holds for arbitrary sum-zero `y`,
   so the invariant-line argument is dispensable, but then the route prose
   should stop relying on generation.

6. **MINOR — the surface-integral identification has no plan-table row.**
   The scope note's "What stays outside" correctly isolates the single
   analytic input (that the monomial functional is the normalized surface
   integral) and even names the Mathlib ingredients, but the module-plan
   table has no row for that module and no inventory row owns it.  Under the
   reaffirmed no-permanent-carve-out rule the boundary must be tracked.
   Repair: add the identification module to the plan table, marked as the one
   module that imports measure theory.

7. **MINOR — the quadratic identity is certified but unassigned.**
   The certificate proves `M(F_y^2) = (140/351) ∑ y_i^2` on the sum-zero
   module and the manuscript asserts it (with marked value `2800/351`), but
   no module-plan row lists the quadratic identity; `SphericalCubicRestriction`
   names only the cubic and its marked value.  Repair: add the quadratic
   identity to that row or to `FaceAxisHarmonicGram`'s.

8. **PROSE — transport claim slightly overstates.**
   `IcosahedralFaceAxes.lean` header (lines 18–21): "All finite statements
   are proved by kernel decision in `ℤ√5` and then transported along the
   unique ring homomorphism..."  Only the squared-length and inner-product
   statements have transported `...Over` versions; the rotation statements do
   not.  Repair: say which statements are transported.

9. **PROSE — decide-count sentence inexact.**
   `AlternatingComparisonLine.lean` header (lines 22–25): "only the two
   auxiliary statements about avoiding a pair of labels are decided."  The
   proofs also decide the sign product at line 69 and `(0 : Fin 5) ≠ 1` at
   lines 111 and 119, and `exists_ne_label` avoids one label, not a pair.
   Repair: "only finite auxiliary statements — label avoidance and sign
   arithmetic — are decided", or drop the count.

10. **PROSE — banned word in the scope note.**
    `notes/2026-08-07-c815-harmonic-realization-scope.md` line 98 ("Every
    theorem stated in terms of `M` is ... without it") uses the sincerity
    adjective forbidden by the workspace documentation style.  Repair:
    "remains correct as stated without it".

11. **PROSE — conventions the future modules must pin down.**
    (i) The certificate computes `sigma_3` as `(1/3) ∑ y_i^3` while the
    manuscript's `σ_3` is the elementary symmetric function; they agree
    exactly on the sum-zero module (I checked the identity under the
    substitution), and the eventual `SphericalCubicRestriction` must fix one
    definition and record the equivalence.  (ii) The planned names
    `SphericalMomentFunctional` / `SphericalCubicRestriction` and the
    certificate keys `spherical_*` describe the monomial functional as
    spherical while the identification with the sphere integral is the
    declared trust boundary; per `lean/AGENTS.md` the module docstrings must
    state that boundary explicitly so no theorem about the functional is read
    as a theorem about the integral.  Today no landed Lean statement mentions
    the functional at all, so no current statement can be misread.

## Checked and found correct

- **Moment functional.** `N(1) = 1` and `N(x_i p) = N(∂_i p)` hold on the
  stated monomial formula (hand proof on general monomials; machine check on
  all monomials with each exponent up to four).  The two properties determine
  a linear functional uniquely by strong induction on degree (any monomial of
  positive degree factors as `x_i m`, reducing to degree two lower; degree-one
  values are forced to zero).  The invariance argument is sound: for
  orthogonal `R`, the chain rule and `R Rᵀ = 1` show `p ↦ N(p ∘ R)` satisfies
  both properties, hence equals `N`; `M` on forms inherits invariance
  degreewise, and `N((x·x)p) = (d+3) N(p)` by Euler's relation gives
  `M((x·x)p) = M(p)`.  The apolar identity `N(pq) = p(∂)q` for `p` harmonic
  homogeneous and `q` homogeneous of the same degree: the sketched induction
  (Euler, one recursion step, `Δp = 0`, and `∑_i ⟨∂_i p, ∂_i q⟩ = d ⟨p, q⟩`)
  goes through over the reals, where the note places the functional; machine
  spot-checks agree.

- **Addition theorem.** All four Leibniz evaluations verified symbolically
  with the `u·u` factors kept explicit:
  `(u·∂)^6 (v·x)^6 = 720 (u·v)^6`,
  `(u·∂)^6 ((v·x)^4 (x·x)) = 720 (u·v)^4 (u·u)`,
  `(u·∂)^6 ((v·x)^2 (x·x)^2) = 720 (u·v)^2 (u·u)^2`,
  `(u·∂)^6 (x·x)^3 = 720 (u·u)^3` — so the unit hypothesis enters exactly
  where the note says.  `231·45 = 10395 = 11!!`, `13!! = 135135 = 13·10395`,
  hence `M(Z_u Z_v) = P_6(u·v)/13`.  Harmonicity of `Z_u` and the full
  pairing `Z_u(∂) Z_v = 10395 P_6(u·v)` confirmed exactly at rational unit
  vectors such as `(3,4,12)/13` and `(2,3,6)/7`, independent of the
  certificate's Groebner reduction.

- **Face axes.** The ten displayed vectors have squared norm `3`; squared
  inner products are `5` exactly on disjoint label pairs and `1` exactly on
  meeting pairs.  The Lean doubled coordinates are precisely twice the
  manuscript's vectors under the label shift `v_{ij} ↦ {i-1, j-1}` (all ten
  entries compared by hand against `Zsqrtd` values, e.g.
  `⟨1,-1⟩ = 1 - √5 = -2φ⁻¹`); doubled squared norm `12 = 4·3` and squared
  products `80 = 16·5` / `16 = 16·1`, with the `if Disjoint ... then 80 else
  16` branch matching Kneser adjacency, not its complement.

- **Legendre and Gram.** `P_6(1) = 1`, `P_6(√5/3) = -65/243`,
  `P_6(1/3) = 47/243`; `196 + 47 = 243` and `47 - 112 = -65`; the ten-by-ten
  Gram matrix of the unit-axis zonal harmonics equals `(196I + 47J - 112A) /
  (243·13)` entrywise, with eigenvalues `110/1053, 140/1053, 28/1053` of
  multiplicities `1, 4, 5`, agreeing with the Petersen eigenvalues `3, -2, 1`
  through `(196 + 47j - 112a)/3159`.  Positivity gives injectivity into the
  polynomial model of `H_6`; the passage to functions on the sphere is
  harmless for homogeneous polynomials (a homogeneous polynomial vanishing on
  the unit sphere vanishes identically by scaling), so no hidden analysis
  enters there.

- **Cubic and quadratic.** By substitution of `y5 = -(y1+y2+y3+y4)` — a
  method independent of the certificate's reduction modulo the ideal
  `(∑ y_i)` — both `M(F_y^2) = (140/351) ∑ y_i^2` and
  `M(F_y^3) = -(784000/1247103) σ_3(y)` hold identically in four free
  variables; marked values `2800/351`, `-15680000/1247103`, `σ_3 = 20`
  confirmed, as is `-784000/1247103 · 20 = -15680000/1247103` and the
  pair-sum tightness `∑_{i<j}(y_i+y_j)^2 = 3 ∑ y_i^2` on sum-zero vectors.
  The certificate's `spherical_cubic_residual_mod_sum_zero = "0"` does
  establish the identity for arbitrary sum-zero `y`, not merely at a point:
  the residual's normal form modulo the principal ideal generated by
  `y1+...+y5` vanishes if and only if the residual is divisible by that
  linear form, which over the rationals is equivalent to vanishing on the
  whole hyperplane.  The marked field times `24/35` is indeed a ten-monomial
  cubic form in the squared coordinates with coefficients in `ℤ[√5]`.

- **Rotations.** All three matrices are orthogonal with determinant one; they
  permute the ten axes up to sign, inducing exactly the label permutations
  `(2 5)(3 4)`, `(3 5 4)`, `(1 2)(3 5)` (one-based), which match the Lean
  `labelPermutation` tables `(1 4)(2 3)`, `(2 4 3)`, `(0 1)(2 4)` (zero-based)
  and the certificate JSON; their closure has order 60 and is contained in
  the even permutations, so they generate the alternating group.  The Lean
  scaled forms are exactly four times these matrices; rows orthogonal of
  squared length `16` and determinant `64 = 4^3` say precisely
  "four times a rotation".

- **`AlternatingComparisonLine` internals.** The two-transitivity witness is
  valid in every case, including `i = k`, `j = l`, and swaps that collapse to
  the identity (`Equiv.swap a a` is the identity, and each step's
  side-conditions were checked against the degenerate instantiations); the
  parity correction always exists on five letters and fixes the target pair.
  The commutant computation is coherent: `T y i = ∑_j y_j M i j` expands to
  `(M 0 0 - M 0 1) · y_i + M 0 1 · ∑_j y_j`, matching the returned constants,
  and on sum-zero vectors the `b`-term drops, so the final scalar `c = a` is
  the right one.  The equivariance bookkeeping (`pairMap`, `pairSum_comp`,
  the projection trick making the representative's equivariance
  unconditional) is correct, and the hypotheses `3 ≠ 0`, `5 ≠ 0`, `60 ≠ 0`
  appear exactly where the proofs need them.  The normalization pair is
  right: the witness `(4,-1,-1,-1,-1)` has cube sum sixty, and
  `c^3 = 1 ⟹ c = 1` over a linearly ordered field via
  `4(c^2+c+1) = (2c+1)^2 + 3 > 0`.

- **Certificate reproducibility.** `--check` against the tracked JSON reports
  a byte-exact match; SHA-256 hashes and byte counts of both tracked files
  equal the values in the scope note's table.

- **Review-gate scan.** Neither Lean module contains task IDs, lane names,
  agent or session identifiers, internal paths, or status prose; both headers
  state their finite-check method (kernel `decide`) and scope.
