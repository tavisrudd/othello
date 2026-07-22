# Klein cubic threefold over F_11: Frobenius spectrum probe (C-unallocated exploratory lead)

Date: 2026-07-21. Exploratory research note; no task ID allocated, no completion claimed.
Scripts and the Rust point-counter live under
`/tmp/claude-1000/-home-tavis-src-othello-rust/986b1b19-1fd0-481d-802d-b67c3b2f4681/scratchpad/klein/`
(referenced below by basename; short ones are inlined in full).

Object: X = {f = 0} ⊂ P^4, f = x0²x1 + x1²x2 + x2²x3 + x3²x4 + x4²x0, over F_11.

## 1. Verdict

**The premise of the question fails: the Klein cubic is SINGULAR mod 11, and its zeta
function over F_11 is exactly that of P³.** In detail:

- **Q1 (the ten eigenvalues / characteristic polynomial).** They do not exist. We prove
  #X(F_{11^k}) = 1 + q + q² + q³ (q = 11^k) **for every k ≥ 1**, so
  Z(X/F_11, T) = 1 / ((1−T)(1−11T)(1−121T)(1−1331T)) exactly. There is no degree-10
  weight-3 factor; the "characteristic polynomial of Frobenius on H³" of a smooth model
  does not apply — X ⊗ F_11 is not smooth. Any hypothetical multiset of 10 nonzero
  eigenvalues would need all power sums to vanish for all k (Section 3.4), which forces
  all eigenvalues to 0 by Newton's identities — a contradiction with |α| = 11^{3/2}. So
  no consistent pure weight-3 spectrum exists, full stop.
- **Q2 (eigenvalue field).** Vacuous. The zeta function is rational with "eigenvalues"
  1, 11, 121, 1331 ∈ Q. Neither ζ5 nor √−11 (nor anything ζ11-related) appears.
- **Q3 (ζ5-closure explaining the trace vanishings).** The observed vanishings
  tr(F) = tr(F²) = 0 are real but their mechanism is not quintic symmetry of a spectrum:
  **every** trace tr(F^k) vanishes, k = 1, 2, 3, 4, 5 by direct computation and all k by
  the closed form. The mechanism is total collapse of H³ under a wild singularity (below).
- **Q4 (eigenvalues 11√−11 · root of unity).** No; no eigenvalues at all.

**The geometry behind it.** X ⊗ F_11 has exactly one singular point,
P = (1, 3, 9, 5, 4) = (1, ζ, ζ², ζ³, ζ⁴) with ζ = 3 a primitive **fifth root of unity**
in F_11. It is an isolated corank-1 double point with local equation
(nondegenerate quadric in 3 variables) + 3·s^11 + 7·s^12 + 5·s^13 + O(s^14) — an
"A_10-type" singularity that is **wild** (the exponent 11 equals p). Its Tjurina scheme
has length 11 and every local coordinate is nilpotent of order exactly 11 = p. The ten
vanishing cycles of this A_10-type point absorb the entire b₃ = 10 of the smooth cubic
threefold, which is why the zeta function degenerates to that of P³. The singular point
exists mod p exactly when p | 33 = 2⁵ + 1 (the Delsarte determinant of the cyclic
exponent matrix): the gradient at the ζ5-point (1, ζ, …, ζ⁴) vanishes iff 2ζ³ + 1 = 0,
and Π_{ζ⁵=1} (2ζ³ + 1) = 2⁵ + 1 = 33. (Mod 3 the relevant point (1,1,1,1,1) satisfies
∇f = 0 but f = 2 ≠ 0, and X/F_3 has no F_3-rational singular point; only p = 11 is
established as bad here.)

**Program headline ("golden C4 meets Q(√−11)?"):** not in this zeta function. At p = 11
the meeting is pre-empted by bad reduction: the intermediate Jacobian (ppav of dim 5)
degenerates totally at 11, and both actors instead conspire in the degeneration itself —
the singular point is the ζ5-CM point, and the obstruction norm is 33 = 3·11. See
Section 5 for what this suggests next.

## 2. Exact zeta function and the refuted fits

Proven closed form (all k ≥ 1, q = 11^k):

    #X(F_q) = 1 + q + q² + q³,      Z(X/F_11, T) = 1 / ((1−T)(1−11T)(1−121T)(1−1331T)).

Factorization questions over Q(ζ5), Q(√−11) etc. are moot: all inverse roots are integer
powers of 11.

Two natural "fits" are refuted by the data:

- Supersingular model (all ten = ±11√−11, multiplicity 5/5): predicts
  #X(F_121) = 1799634 ≠ 1786324. (Already known; re-confirmed.)
- Smoothness-assuming fit from t₁..t₅ = 0 plus the symplectic functional equation
  (det F|H³ = q^15 for GSp₁₀ with multiplier q³): gives P(T) = T^10 + 11^15, i.e.
  α^10 = −11^15. This predicts #X(F_{11^10}) = 1 + q + q² + q³ + 10·11^15, contradicting
  the closed form. Both fits die; only the singular story is consistent.

## 3. Methods and consistency checks

### 3.1 Reduction chain (point counts)

For the count, write f as a quadratic in x4 (root count 1 + χ(D), χ = quadratic
character, D = x3⁴ − 4·x0·a, a = x0²x1 + x1²x2 + x2²x3), scale to the x0 = 1 slice, then
collapse the x1-sum (χ of a quadratic in x1 has a closed form). Result:

    #X(F_q) = q³ + q² + 2q + 1 + S(q),   S(q) = q·T(q),
    S(q)    = Σ_{x1,x2,x3} χ(x3⁴ − 4(x1 + x1²x2 + x2²x3)),
    T(q)    = Σ_{(x2,x3) ∈ C(F_q)} χ(−4x2),  C: x2·x3⁴ − 4·x2³·x3 + 1 = 0, x2 ≠ 0,

so tr(F^k|H³) "=" −q(1 + T(q)) under the (false) smoothness reading. T(q) is an O(q²)
computation; over F_{11^k} it runs in log/Zech-table representation
(`klein_zeta/src/main.rs`, mode `curve`).

Results (every run below reproduced the closed form):

| k | q      | T(q) | #X(F_q)          | tr |
|---|--------|------|------------------|----|
| 1 | 11     | −1   | 1464             | 0  |
| 2 | 121    | −1   | 1786324          | 0  |
| 3 | 1331   | −1   | 2359720584       | 0  |
| 4 | 14641  | −1   | 3138642750244    | 0  |
| 5 | 161051 | −1   | 4177274107001304 | 0  |

### 3.2 Independent verifications of the counts

- k=1: full no-tricks brute force over P⁴(F_11) (`verify11.py`): 1464 ✓; equals the
  session-given anchor 1 + 11 + 11² + 11³ ✓.
- k=1: quadratic-trick S-sum and curve-sum T both give S = qT = −11 (`reduce_check.py`) ✓.
- k=2: independent Python GF(121) implementation, both the triple-loop S-sum and the
  curve sum (`check121.py`): 1786324 ✓ = the session's numpy count ✓.
- k=3: Rust `direct` mode (triple loop over F_1331³ with full add/mul tables, no
  x1-collapse) agrees with `curve` mode: N = 2359720584 ✓.
- k=1..5: closed form 1+q+q²+q³ equals every computed count (`strata_sing.py`) ✓.
- Weil-machinery control (per the "compute, never recall" instruction): each stratum
  formula of Section 3.3 was verified by direct torus counting at q = 11
  (9090, 900, 100, 0 — all ✓). An initial mis-derivation (wrong (q−1) prefactor) was
  caught exactly by this control and corrected; the corrected prefactor is
  (q−1)^{n−J+1}/q per stratum (n vars, J monomials).

### 3.3 Proof sketch of the all-k closed form (Weil/Delsarte character sums)

Stratify the cone of X by the support S ⊆ Z/5 of nonvanishing coordinates. On each
stratum, Fourier-expand the additive character over F_q* via Gauss sums; nontrivial
multiplicative character tuples (χ_j = ω^{m_j}) survive iff A_Sᵀ m ≡ 0 and Σm_j ≡ 0
mod q−1, where A_S is the exponent matrix of the surviving monomials.

- |S|=5 (A = circulant(2,1,0,0,0)): constraints m_{i−1} ≡ −2m_i force 33·m ≡ 0, so
  ord(m) | gcd(33, 11^k−1) ∈ {1, 3} (3 iff k even). For order-3 solutions all m_i are
  equal and Σm_j = 5m_0 = 2m_0 ≠ 0 in the 3-torsion — killed by the Σ-condition. Only
  m = 0 survives, any k. N*₅ = ((q−1)⁵ − (q−1))/q.
- |S|=4 (chain of 3 monomials): the chain forces m = 0 exactly (coefficient-1
  eliminations from the free end; the 2m₁ ≡ 0 condition is redundant).
  N*₄ = ((q−1)⁴ − (q−1)²)/q.
- |S|=3 consecutive: m = 0 similarly. N*₃ = ((q−1)³ + (q−1)²)/q.
- |S|=3 split / |S|=2 adjacent: a single surviving monomial, no torus zeros: 0.
- |S|=2 non-adjacent and |S|=1: f ≡ 0: (q−1)² resp. (q−1) points each, five of each.

Total: (q−1)·#X = N*₅ + 5N*₄ + 5N*₃ + 5(q−1)² + 5(q−1), which telescopes to
#X = q³ + q² + q + 1 identically in q. No nontrivial character ever contributes — for
any k. (This is the rigorous backbone; it uses only finite-group Fourier inversion and
was numerically validated stratum-by-stratum and total-by-total as listed above.)

### 3.4 Why no pure weight-3 spectrum can exist

If H³ had eigenvalues α₁..α_r (r ≤ 10, all |α_i| = 11^{3k/2}-pure), then
Σα_i^k = (1+q+q²+q³) − #X(F_{11^k}) = 0 for k = 1..r suffices, via Newton's identities,
to force the characteristic polynomial T^r — i.e. all α_i = 0. Contradiction unless
r = 0. The closed form gives the vanishing for ALL k, so this is airtight: the pure
weight-3 part of the cohomology of any smooth-model surrogate contributes nothing —
because there is no smooth model to speak of; see 3.5.

### 3.5 The singularity (all statements computed, exact mod 11)

- Brute force over P⁴(F_11) (`strata_sing.py`, `badprimes.py`): exactly one point with
  f = 0 and ∇f = 0: P = (1,3,9,5,4). Same scan finds no F_p-rational singular points for
  p ∈ {2,3,5,7,13,17,19,23}.
- Torus-reduction singular scan over F_{11^k}, k = 1..4 (`klein_zeta` mode `sing`; all
  singular cone points provably lie in the open torus, by the coordinate-vanishing chain
  argument in the source comment): exactly 1 projective singular point at every level.
- Jacobian-ideal Gröbner basis mod 11 (`hilbert.py`, `support.py`): Hilbert function of
  S/J stabilizes at **11** → the singular scheme is 0-dimensional of length 11 (Tjurina
  number τ = 11); at infinity (x0 = 0) it is empty; in the affine chart translated to P,
  the quotient has dimension 11 and each coordinate y_i is nilpotent with y_i^11 = 0 →
  support is exactly {P}, geometrically.
- Local type (`aktype2.py`, `aktype3.py`): 5×5 Hessian at P has rank 3; affine Hessian on
  the chart is rank 3 on 4 variables (corank 1), kernel direction v = (7,1,2,1). Formal
  implicit-function elimination (Newton iteration on mod-11 power series, residuals
  pushed beyond the read-off order; result invariant under 3 randomized complement
  bases) gives the branch function
  h(s) = 3s^11 + 7s^12 + 5s^13 + O(s^14).
  So P is a corank-1 double point of "A_10 type", **wild** since ord = 11 = p (in char p,
  s ↦ s + bs² has (s+bs²)^11 = s^11 + b^11 s^22, so the subleading terms are not
  removable by tame reparametrization; the wildness is also visible in τ = 11 = μ+1 and
  in y_i^11 = 0).
- Milnor-number bookkeeping: total vanishing-cycle dimension available to an isolated
  corank-1 point of order 11 is 10, and b₃(smooth cubic threefold) = 10 — the global
  point-count result (H³ contributes 0) says the singularity eats all of it. This
  consistency is exact: 10 = 10.
- Lines through P (`klein_zeta` mode `lines`): the directions v with line(P,v) ⊂ X form
  a curve C' = {B(v)=0, f(v)=0} (B = Hessian quadratic form; a (2,3) curve in the P³ of
  directions) with #C'(F_11) = 12, #C'(F_121) = 122. Projection from P is birational
  X → P³, giving the identity #X = 1 + |P³(F_q)| − #Q(F_q) + q·#C'(F_q) with
  Q the rank-3 quadric cone (#Q = q²+q+1 for all q, since the rank-3 part has unit
  determinant 9 mod 11). Verified numerically at q = 11: 1 + 1464… = 1 + 1464 − 133 +
  132 = 1464 ✓. Combined with the proven #X formula this forces **#C'(F_q) = q + 1 for
  every q** — the line-cone curve counts like P¹ at every level. X ⊗ F_11 is rational
  with a completely "motive-free" decomposition; that is the geometric face of
  Z(X) = Z(P³).

### 3.6 The ζ5-point structure of P

P = (1, ζ, ζ², ζ³, ζ⁴), ζ = 3, ζ⁵ = 1 in F_11 (11 ≡ 1 mod 5). This point lies on X in
every characteristic (f(1,ζ,…) = ζ·Σ(ζ³)^i = 0) and is fixed (projectively) by the
cyclic symmetry σ: x_i ↦ x_{i+1}. Its gradient components are ζ^{2i−2}(2ζ³ + 1), so P is
singular iff 2ζ³ + 1 = 0 alongside ζ⁵ = 1, which happens iff p | Res = Π_{ζ⁵=1}(2ζ³+1)
= 2⁵ + 1 = 33. At p = 11, exactly one of the four primitive-ζ5 points goes singular
(ζ = 3: 2·27+1 = 55 ≡ 0; the others give nonzero). The determinant of the circulant
exponent matrix of f is the same 33 — the Delsarte "quotient-of-Fermat degree" —
and the same 33 = gcd-bound appeared in the character analysis of 3.3. One integer, three
roles: character-lattice torsion, discriminant divisor, CM-point degeneration.

## 4. Replay commands

All in `/tmp/claude-1000/-home-tavis-src-othello-rust/986b1b19-1fd0-481d-802d-b67c3b2f4681/scratchpad/klein/`;
because that path is RAM-backed and session-local, a durable copy of every script (and the Rust
`main.rs`/`Cargo.toml`) is committed at `notes/2026-07-21-klein-cubic-zeta-probe-scripts/`.

```
python3 verify11.py                # N(11) = 1464 brute force, no tricks
python3 reduce_check.py            # S = qT = -11 at q=11; N from S = 1464
python3 check121.py                # GF(121): S = -121, N = 1786324, T = -1
python3 strata_sing.py             # stratum controls; closed form vs counts k=1..5; sing scan p in {11,7,13,5,3,2}
python3 badprimes.py               # sing scan with f=0 enforced, p <= 23; zeta5 structure of P
uv run --with sympy python3 geometry.py   # Hessian rank 3 at P; Jacobian GB mod 11
uv run --with sympy python3 aktype2.py    # h(s) = 3 s^11 + ... (A_10-type, wild)
uv run --with sympy python3 aktype3.py    # invariance of ord = 11 under random bases
uv run --with sympy python3 hilbert.py    # Hilbert function of S/J: 1,5,10,11,11,...
uv run --with sympy python3 support.py    # length 11 at P only; empty at infinity; y_i^11 = 0

cd klein_zeta && cargo build --release
./target/release/klein_zeta K curve    # T(11^K), N, tr  (K = 1..5; K=5 ~ 6 s wall / 2 min CPU)
./target/release/klein_zeta K direct   # independent triple-loop S (K <= 3)
./target/release/klein_zeta K sing     # singular point count over F_{11^K} (K <= 4 used)
./target/release/klein_zeta K lines    # V(B=0,f=0) and #C' (K <= 2 used)
```

The Rust binary needs only stable cargo; fields are built as F_11[t]/(t^k − r) with t
primitive, exp/log/Zech tables (the chosen reduction is printed on stderr per run).

## 5. Interpretation for the program

- **Where the golden C4 and the Gauss field "meet" at 11:** not in a Frobenius spectrum
  — in the degeneration. The unique singular point is the ζ5-CM point of the cyclic
  coordinate system, the wild exponent is p = 11 itself, and the obstruction integer is
  33 = 2⁵ + 1 = 3·11. The "Gauss sum cubed" value 11√−11 never materializes because the
  weight-3 motive of X collapses at exactly the prime where √−11 lives. If one wants a
  slogan: at p = 11 the Klein cubic does not have a supersingular spectrum, it has **no
  spectrum**; 11 is the unique prime of (wild, totally degenerate) bad reduction visible
  in this model, rather than a prime of special symmetry of good reduction.
- **F^5/F^10 quasi-scalarity:** vacuous on the weight-3 part (it is zero). On all of the
  cohomology that survives, Frobenius acts by 11-power scalars — "supersingular in
  weight 3" is the wrong frame; "cohomologically P³" is the right one.
- **Intermediate Jacobian:** the ppav 5-fold JX degenerates at 11 with no abelian part
  visible in the counts (an abelian or even toric part of positive dimension would leave
  q-power-times-root-of-unity traces; all vanish identically). Consistent with total
  wild degeneration. The Néron model / monodromy at 11 (conductor exponent, Swan = 10
  accounting) is a well-posed follow-up that the point counts alone cannot settle.
- **Live spectra exist at good primes.** For p ∤ 33, p ≡ 1 (mod 5) (e.g. p = 31, 41, 61,
  71), X mod p is a smooth cubic threefold (smoothness to be re-verified per prime by
  the same scan) and the |S|=5 stratum analysis has gcd(33, p^k−1) picking up genuine
  quintic/cubic character contributions — that is where quintic Jacobi sums (abs value
  √p, in Z[ζ5]) can genuinely populate H³ and where the "does Q(ζ5) meet Q(√−p*)"
  question is non-vacuous. The T(q) curve-sum reduction here (O(q²), and O(q·polylog)
  via cubic root-finding) transfers verbatim with 11 → p and makes k ≤ 4 cheap and k = 5
  feasible. That is the natural next probe if the program wants the C4/Gauss-field
  meeting inside an actual zeta function.
- **Character-sum aesthetics:** the reason ALL traces vanish is a precise conspiracy —
  the Σχ_j-trivial condition (from projectivity) kills exactly the order-3 tuples that
  the circulant lattice admits, and 11 | 33 prevents order-11 tuples from ever forming.
  The Klein cubic mod 11 is a Delsarte hypersurface whose entire character spectrum is
  self-annihilating.

## 6. What is proved vs computed vs conjectured

**Proved (computationally certified, exact integer/mod-p arithmetic):**
- #X(F_{11^k}) = 1 + q + q² + q³ for k = 1..5 (multiple independent algorithms per k for
  k ≤ 3; two session-independent anchors at k = 1, 2).
- Sing(X ⊗ F̄_11) = {P} as a set, P = (1,3,9,5,4); singular scheme length 11, empty at
  infinity, all local coordinates nilpotent (Gröbner certificates mod 11).
- Hessian corank 1 at P; branch series h(s) = 3s^11 + 7s^12 + 5s^13 + O(s^14) (Newton
  residuals certified past the read-off order; basis-independent).
- #C'(F_11) = 12, #C'(F_121) = 122; projection identity verified at q = 11.
- The two refuted models of Section 2 are refuted by exact counts.

**Proved modulo standard theory (finite-field Fourier inversion; each branch numerically
controlled):** the all-k closed form of Section 3.3, hence Z(X) = Z(P³) and the
nonexistence of any pure weight-3 eigenvalue (Section 3.4 is then unconditional).
The det = q^15 symplectic fact was only used for the refuted fit, not for the verdict.

**Computed but with a theory-shaped reading (flagged):** the identification "corank-1,
ord 11 ⇒ wild A_10-type absorbing 10 vanishing cycles" uses char-p vanishing-cycle
bookkeeping directionally; the global collapse itself is proved by the counts, not by
this local reading. Conductor/Swan details at 11 are not computed.

**Conjectured / unchecked:** that 11 is the ONLY bad prime of this integral model
(checked only for F_p-rational singular points, p ≤ 23, plus the ζ5-family argument;
a full discriminant computation was not done). Literature status (this bad-reduction
fact is very likely classical — Klein cubic / PSL₂(11) / Adler et al.) was NOT searched;
per conventions, nothing here is a novelty claim. C' being a rational sextic (rather
than some other q+1-count configuration) is suggested but not decomposed.
