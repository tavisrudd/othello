# C290 — Closed polyhedral congruence laws

**Date:** 2026-07-18 (task dated 2026-07-17). **Lane:** `dihedral`. **Status:** COMPLETE.

Derives, as proved theorems, the split-indicator congruences and the closed full-board
Grundy laws that [C288](2026-07-17-c288-polyhedral-embedding-census.md) verified
empirically on `q ≤ 101`, by substituting the
[C284](2026-07-17-c284-dihedral-polyhedral-coset-templates.md) template table into the
orbit formulas. Includes exact periods, P/N classification, prime-density corollaries,
and print-ready statements. Evidence bundle:
`2026-07-17-c290-polyhedral-congruence-laws.{py,json,sha256}` (adjacent in `notes/`).

Notation follows the manuscript and C284: `q` an odd prime power, `p = char F_q`,
`χ` the quadratic character of `F_q^×`, `ε_d ∈ {0,1}` the split indicator of the cyclic
subgroup type `C_d` (1 iff it has rational fixed points on `P¹(F_q)`), `m₁` the number of
free orbits, `v(σ;ρ)` the full-board Node-Kayles Grundy value of the refined triple class.
`[P]` denotes the 0/1 indicator of a proposition `P`. Tame means `p ∤ |G|`.

## 1. Result

For every tame realization of `S₄` or `A₅` inside `PGL₂(q)` (any odd prime power `q`,
no restriction to `q ≤ 101`, no uniqueness assumption):

```text
S4  (p ∉ {2,3}):          v(2,3,3;4) = 2·[2 ∉ (F_q^×)²]        = 2  iff q ≡ 3,5 (mod 8)
                          v(2,3,4;3) = v(3,3,3;4) = v(3,4,4;3)
                                     = [−2 ∈ (F_q^×)²]         = 1  iff q ≡ 1,3 (mod 8)

A5  (p ∉ {2,3,5},         v(2,3,5;5) = [χ(6)=−1] ⊕ [q≡1 (5)]   (= m₁ mod 2)
     q ≡ ±1 (mod 5)):     v(2,5,5;3) = [6 ∉ (F_q^×)²]
                          v(3,3,5;3) = 0
                          v(3,5,5;3) = [q≡1 (3)] ⊕ [q≡1 (5)]
                          v(3,5,5;5) = 0
                          v(5,5,5;5) = [q ≡ 1 (mod 4)]
```

The `S₄` board value is a function of `q mod 8` with exact period 8; the `A₅` board value
is a function of `q mod 120`, with per-class minimal moduli `120, 24, 1, 15, 1, 4`. The
`A₅` free-orbit parity has the closed form `m₁ ≡ [χ(6)=−1] + [q ≡ 1 (mod 5)] (mod 2)`.
Among primes, every nonconstant class is an N-position with relative Dirichlet (indeed
natural) density exactly 1/2. All laws were re-verified against the complete committed
C288 census (§8).

The congruence skeleton (Theorems B–D) is proved from the group theory of `PGL₂(q)`; the
sole computational input to the value laws (Theorem E) is the finite, `q`-independent
C284 template-nimber table. §9 delimits this precisely.

## 2. Two fixed-point criteria in `PGL₂(q)` (Lemmas A1–A2, proved)

Throughout, an element of `PGL₂(q)` is a class `g = [M]`, `M ∈ GL₂(F_q)`; its fixed
points on `P¹(F_q)` are the `F_q`-rational eigenvector directions of `M`. The
determinant induces a surjection `δ: PGL₂(q) → F_q^×/(F_q^×)² ≅ Z/2` with kernel
`PSL₂(q)` (a class `[M]` lies in `PSL₂(q)` iff `det M` is a square: `det(λM') = λ²` for
`det M' = 1`).

**Lemma A1 (semisimple criterion, `d ≥ 3`).** Let `g ∈ PGL₂(q)` have order `d ≥ 3` with
`p ∤ d`. Then either `d | q−1`, and `g` has exactly two rational fixed points, or
`d | q+1`, and `g` has none.

*Proof.* Since `p ∤ d`, `M` is semisimple, and it is nonscalar, so it has two distinct
eigenvalues `λ₁, λ₂` over `F̄_q`; the ratio `ζ = λ₁/λ₂` is well defined up to inversion
and has order exactly `d` (`g^k = 1` iff `M^k` scalar iff `ζ^k = 1`). The
characteristic polynomial lies in `F_q[X]`, so either both eigenvalues lie in `F_q` —
then `ζ ∈ F_q^×`, so `d | q−1`, and both eigenvector directions are rational — or they
are `F_{q²}/F_q`-conjugate: `λ₂ = λ₁^q`. In that case `ζ^{q+1} = λ₁^{(1−q)(1+q)} = 1`
(as `λ₁^{q²−1} = 1`), so `d | q+1`; the Frobenius swaps the two eigenvector directions,
so neither fixed point is rational, and a rational fixed point of `g` other than an
eigendirection cannot exist. For `d ≥ 3` the two cases are exclusive
(`gcd(q−1, q+1) = 2`). ∎

**Lemma A2 (involution criterion).** Let `g = [M] ∈ PGL₂(q)` be an involution, `q` odd.
Then `tr M = 0`, and with `D = det M`:

1. `g` has rational fixed points iff `−D ∈ (F_q^×)²`;
2. `g ∈ PSL₂(q)` iff `D ∈ (F_q^×)²`;
3. hence `g` has rational fixed points iff (`g ∈ PSL₂(q)` ⟺ `q ≡ 1 (mod 4)`).

*Proof.* `M² = cI` with `M` nonscalar; Cayley–Hamilton gives
`(tr M)·M = M² + (det M)I = (c + D)I`, so `tr M = 0`. The characteristic polynomial is
`X² + D`, with roots `±√(−D)`: rational eigenvalues — equivalently rational fixed
points, by the dichotomy in Lemma A1's proof — exist iff `−D` is a square. Claim 2 is
the kernel description of `δ`, and claim 3 combines 1 and 2 with
`χ(−D) = χ(−1)χ(D)` and `χ(−1) = 1 ⟺ q ≡ 1 (mod 4)` (the unique element of order 2 of
the cyclic group `F_q^×` is a square iff `4 | q−1`). ∎

**Lemma A3 (supplement laws over `F_q`, `q` odd).** In `F_q^×`: `−1` is a square iff
`q ≡ 1 (mod 4)`; `2` is a square iff `q ≡ ±1 (mod 8)`; `−2` is a square iff
`q ≡ 1,3 (mod 8)`; for `p ≠ 3`, `−3` is a square iff `q ≡ 1 (mod 3)`; for `p ≠ 5`, `5`
is a square iff `q ≡ ±1 (mod 5)`.

*Proof.* First claim as in A2. For `2`: let `ζ ∈ F̄_q` be a primitive 8th root of unity
and `τ = ζ + ζ^{−1}`, so `τ² = ζ² + ζ^{−2} + 2 = 2`. Then `2` is a square in `F_q` iff
`τ ∈ F_q` iff `τ^q = τ`; `τ^q = ζ^q + ζ^{−q}` equals `τ` for `q ≡ ±1 (mod 8)` and
`ζ³ + ζ^{−3} = −τ` for `q ≡ ±3 (mod 8)`. `−2` follows via `χ(−2) = χ(−1)χ(2)`. For
`−3`: `σ = 2ζ₃ + 1` satisfies `σ² = −3` and `σ^q = 2ζ₃^q + 1 = ±σ` according to
`q ≡ 1, 2 (mod 3)`. For `5`: `σ = 2(ζ₅ + ζ₅^{−1}) + 1` satisfies `σ² = 5` and is fixed
by Frobenius iff `q ≡ ±1 (mod 5)`. ∎

## 3. Theorem B: the `S₄` split laws (proved)

**Theorem B.** Let `G ≅ S₄` be a subgroup of `PGL₂(q)`, `q` odd, `p ≠ 3`. Then

- `ε₄ = ε₂ᵦ = [q ≡ 1 (mod 4)] = [χ(−1) = 1]`;
- `ε₃ = [q ≡ 1 (mod 3)] = [χ(−3) = 1]`;
- `ε₂ₐ = [q ≡ 1, 3 (mod 8)] = [χ(−2) = 1]`.

Moreover `G ≤ PSL₂(q)` iff `q ≡ ±1 (mod 8)`, and otherwise `G ∩ PSL₂(q) = A₄`.

*Proof.* `ε₄` and `ε₃` are Lemma A1 (`d = 4`: `4 | q−1 ⟺ q ≡ 1 (mod 4)` since `q` is
odd; `d = 3` likewise). The double transpositions lie in `V₄ < A₄ = [S₄, S₄]`, and the
abelianized character `δ|_G` kills the derived subgroup, so they lie in `PSL₂(q)`; Lemma
A2.3 gives `ε₂ᵦ = [q ≡ 1 (mod 4)]`. (Consistently with C284's remark, when
`ε₂ᵦ = ε₄ = 1` the fixed points of the double transposition `s²` carry full `C₄`
stabilizers: the 4-cycle `s` is split too, `fix(s) ⊆ fix(s²)`, and both sets have
exactly two elements, so they coincide.)

For `ε₂ₐ`: `δ|_G : S₄ → Z/2` is a homomorphism, hence trivial or the sign character.
Evaluate it on a 4-cycle `s`, which is an odd permutation.

- If `q ≡ 1 (mod 4)`, then by A1 `s` lies in a split torus, conjugate to the diagonal
  one; write `s = [diag(λ, 1)]` with `λ` of order 4 in `F_q^×`. Then
  `δ(s) = λ mod (F_q^×)²`, and an element of order 4 of the cyclic group `F_q^×` is a
  square iff `8 | q−1`. So `δ(s)` is trivial iff `q ≡ 1 (mod 8)`.
- If `q ≡ 3 (mod 4)`, then `4 | q+1` and `s` lies in a nonsplit torus
  `T ≅ F_{q²}^×/F_q^×`, cyclic of order `q+1`, with `δ([μ]) = N(μ) = μ^{q+1}` modulo
  squares. A generator `μ₀` of `F_{q²}^×` has `N(μ₀)` of order `q−1`, a primitive root,
  so `δ(T) = Z/2` and `T ∩ PSL₂(q)` is the subgroup of squares of the cyclic group `T`.
  The order-4 element of `T` is a square in `T` iff `8 | q+1`. So `δ(s)` is trivial iff
  `q ≡ 7 (mod 8)`.

Hence `δ|_G` is trivial iff `q ≡ ±1 (mod 8)` (the final claim), and the transpositions —
odd permutations — lie in `PSL₂(q)` iff `q ≡ ±1 (mod 8)`. Lemma A2.3 now gives
`ε₂ₐ = 1` iff (`q ≡ 1 (mod 4)` and `q ≡ ±1 (mod 8)`) or (`q ≡ 3 (mod 4)` and
`q ≡ ±3 (mod 8)`), i.e. iff `q ≡ 1, 3 (mod 8)`, which is `χ(−2) = 1` by Lemma A3. ∎

## 4. Theorem C: the `A₅` split laws (proved)

**Theorem C.** Let `G ≅ A₅` be a subgroup of `PGL₂(q)`, `q` odd, `p ∉ {3,5}`. Then
`G ≤ PSL₂(q)`, and

- `ε₂ = [q ≡ 1 (mod 4)]`, `ε₃ = [q ≡ 1 (mod 3)]`, `ε₅ = [q ≡ 1 (mod 5)]`.

Such a subgroup exists iff `q ≡ ±1 (mod 5)`.

*Proof.* `A₅` is perfect, so the abelianized character `δ|_G` is trivial: `G ≤ PSL₂(q)`.
Lemma A2.3 gives `ε₂`; Lemma A1 gives `ε₃` and `ε₅` (`5 | q−1 ⟺ q ≡ 1 (mod 5)`).
Necessity of `q ≡ ±1 (mod 5)`: a tame element of order 5 requires `5 | q²−1` (Lemma A1),
i.e. `q ≡ ±1 (mod 5)` — equivalently `√5 ∈ F_q` (Lemma A3). Sufficiency is Dickson's
subgroup classification, cited (and verified on the census domain by C288). ∎

## 5. Theorem D: orbit equations and free-orbit parity (proved)

By C284's framework (tame point stabilizers are cyclic; each split maximal cyclic type
contributes exactly one exceptional orbit of size `|G|/d`, by the fixed-point double
count), the orbit decomposition of `P¹(F_q)` gives

```text
S4:  q + 1 = 12 ε₂ₐ + 8 ε₃ + 6 ε₄ + 24 m₁
A5:  q + 1 = 30 ε₂ + 20 ε₃ + 12 ε₅ + 60 m₁.
```

**Theorem D.** With the indicators of Theorems B–C, the right-hand sides are automatic:
for every `q` coprime to 6 (resp. coprime to 30 with `q ≡ ±1 (mod 5)`) the displayed
differences are divisible by 24 (resp. 60), so `m₁ ∈ Z_{≥0}` is well defined, and

```text
A5:  m₁ ≡ [χ(−2)=1] + [χ(−3)=1] + [q ≡ 1 (mod 5)]
        ≡ [χ(6)=−1] + [q ≡ 1 (mod 5)]                  (mod 2).
```

The parity is a function of `q mod 120` and of no smaller modulus (among divisors of
120, on admissible residues). For `S₄`, `m₁ mod 2` is a function of `q mod 48` (odd on
the classes `q ≡ 1, 23, 29, 31, 35, 37, 41, 43 (mod 48)`); it enters no board value,
because every `S₄` regular template has `t₁ = 0`.

*Proof.* Divisibility: check modulo the prime powers of 24 resp. 60 separately, using
the congruence laws; e.g. mod 8 for `S₄`: `q+1 − 4ε₂ₐ − 6ε₄ ≡ 0` in each of the four
odd classes of `q mod 8` (`2−4−6`, `4−4`, `6−6`, `8`), and mod 3: `q+1 − 2ε₃ ≡ 0`; the
`A₅` cases (mod 4, 3, 5) are identical one-line checks.

Parity for `A₅`: reduce the orbit equation mod 8. `60m₁ ≡ 4m₁`, `30ε₂ ≡ 6ε₂`,
`20ε₃ ≡ 4ε₃`, `12ε₅ ≡ 4ε₅ (mod 8)`, so `4m₁ ≡ (q+1−6ε₂) − 4ε₃ − 4ε₅ (mod 8)`. Since
`ε₂ = [q ≡ 1 (mod 4)]`, the term `q+1−6ε₂` is divisible by 4, and dividing by 4:
`m₁ ≡ (q+1−6ε₂)/4 + ε₃ + ε₅ (mod 2)`. The four classes of `q mod 8` give
`(q+1−6ε₂)/4 ≡ 1, 1, 0, 0 (mod 2)` for `q ≡ 1, 3, 5, 7 (mod 8)` respectively, i.e.
`(q+1−6ε₂)/4 ≡ [q ≡ 1,3 (mod 8)] = [χ(−2)=1] (mod 2)`. Substituting
`ε₃ = [χ(−3)=1]`, `ε₅ = [q≡1 (5)]` and `χ(−2)χ(−3) = χ(6)` gives both displayed forms.
The `S₄` statement follows by the same reduction mod 16 (modulus divides
`lcm(16,3) = 48`); the class list and both minimality claims are finite residue
enumerations, certified by the adjacent checker (§8). ∎

## 6. Theorem E: closed full-board value laws

The C284 orbit formula `G = (m₁ mod 2)t₁ ⊕ ε₂t₂ ⊕ ε₃t₃ ⊕ ε₄t₄` (resp. `ε₅t₅`), with the
template-nimber table

```text
S4: (2,3,3;4): t=(0,2,0,2)   (2,3,4;3): (0,1,0,0)   (3,3,3;4): (0,1,0,0)   (3,4,4;3): (0,1,0,0)
A5: (2,3,5;5): (1,0,0,0)     (2,5,5;3): (1,0,0,1)   (3,3,5;3): (0,0,0,0)
    (3,5,5;3): (0,0,1,1)     (3,5,5;5): (0,0,0,0)   (5,5,5;5): (0,1,0,0)
```

(`t = (t₁,t₂,t₃,t₄/₅)`; `ε₂` multiplies `t₂` = the involution-stabilizer template,
`ε₂ₐ` for `S₄`), yields, after substituting Theorems B–D:

**Theorem E.** For every tame `S₄` (resp. `A₅`) realization in `PGL₂(q)`, the ten
refined classes have the full-board values displayed in §1. Consequences:

- **`S₄` period 8.** `v(2,3,3;4) = 2(ε₂ₐ ⊕ ε₄) = 2[χ(2)=−1]` (since
  `χ(−2)χ(−1) = χ(2)`), the other three classes equal `ε₂ₐ = [χ(−2)=1]`. The value
  vector by `q mod 8` is `(0,1), (2,1), (2,0), (0,0)` for `q ≡ 1, 3, 5, 7`: all four
  distinct, so the period is exactly 8. Value 2 occurs iff `q ≡ 3, 5 (mod 8)`; value 1
  and value 2 never occur in the same field's `S₄` board.
- **`A₅` free-parity cancellation.** `v(2,5,5;3) = ε₅ ⊕ (m₁ mod 2)`: the `ε₅` from the
  `t₅ = 1` template cancels against the `ε₅` inside the parity law, leaving
  `[χ(6)=−1]` — minimal modulus 24, not 120.
- **Minimal moduli** (among divisors of 120, over the 16 admissible residue classes):
  `v(2,3,5;5): 120`, `v(2,5,5;3): 24`, `v(3,5,5;3): 15`, `v(5,5,5;5): 4`, constants
  `1`; the six-component `A₅` value vector has minimal modulus 120.

*Status.* The congruence skeleton is Theorems B–D (proved). The ten template vectors
are the C284 exact finite computation on `q`-independent abstract coset graphs
(dual-solver checked; the six regular zeros of the mirror classes are proved by C289
Theorem 4, and `t₁ = 1` for `(2,3,5)`, `(2,5,5)` plus all nonregular entries remain
machine-verified finite facts). Given that finite table, Theorem E holds for **every**
admissible tame `q`, with no upper bound; the C288 census is an independent
verification on `q ≤ 101`, not part of the proof.

## 7. Corollary F: P/N classification and prime densities

**P/N laws** (P ⟺ board value 0):

```text
S4:  (2,3,3;4)  P iff q ≡ ±1 (mod 8);   N with value 2 iff q ≡ 3,5 (mod 8)
     other 3    P iff q ≡ 5,7 (mod 8);  N with value 1 iff q ≡ 1,3 (mod 8)
A5:  (2,3,5;5)  N iff [χ(6)=−1] ⊕ [q≡1 (5)] = 1
     (2,5,5;3)  N iff 6 is a nonsquare in F_q
     (3,5,5;3)  N iff exactly one of q ≡ 1 (mod 3), q ≡ 1 (mod 5) holds
     (5,5,5;5)  N iff q ≡ 1 (mod 4)
     (3,3,5;3), (3,5,5;5)  P for every admissible q.
```

**Densities.** Analytic input: the prime number theorem for arithmetic progressions
(equivalently Dirichlet's theorem in its natural-density form) — primes equidistribute
among the reduced residue classes of any fixed modulus; everything else is finite
residue counting, certified by the checker.

- `S₄` (all primes `p ≥ 5`; the single wild prime `p = 3` is negligible): each of the
  four classes is N on exactly 2 of the 4 odd residue classes mod 8 — density **1/2**.
  In particular Grundy value 2, the only tame polyhedral board value exceeding 1,
  occurs for a set of primes of density 1/2.
- `A₅` (admissible primes `p ≡ ±1 (mod 5)`, themselves of density 1/2): each of the
  four nonconstant classes is N on exactly 8 of the 16 admissible reduced classes mod
  120 — relative density **1/2**; the two constant classes are P for all admissible `q`.
  The free-orbit count `m₁` is likewise odd with relative density 1/2.

## 8. Verification (exact command, counts, trusted boundary)

Checker: `notes/2026-07-17-c290-polyhedral-congruence-laws.py` (Python 3 stdlib,
deterministic, no randomness/timestamps/host paths). From the repo root:

```bash
python3 notes/2026-07-17-c290-polyhedral-congruence-laws.py \
    > notes/2026-07-17-c290-polyhedral-congruence-laws.json
(cd notes && sha256sum -c 2026-07-17-c290-polyhedral-congruence-laws.sha256)
```

The script asserts (aborting on any mismatch) and prints `ALL CHECKS PASSED` to stderr;
the canonical JSON records:

1. **Census comparison** against the committed
   `notes/2026-07-17-c288-polyhedral-embedding-census.json`: 38 embeddings; 140 split
   indicators, 38 exact `m₁` values (plus the `A₅` parity law on each), 176 per-class
   board values from the closed laws, and 114 direct-solver values recomputed by C288 —
   0 mismatches. The census orbit multisets are re-summed to `q+1` independently.
2. **Character forms on primes**: Euler's-criterion verification of every quadratic
   character identity used (`−1, 2, −2, −3, 5, 6`) for all 1,227 primes `5 ≤ p < 10⁴`.
3. **Arithmetic-identity sweep**: 24- resp. 60-divisibility of the orbit equations and
   the `A₅` parity law over all admissible integers `q < 6000` (1,999 `S₄` / 799 `A₅`
   instances — integers, not only prime powers, since Theorem D is a congruence
   identity); the `S₄` mod-48 parity classes are recomputed there.
4. **Minimal moduli and balance**: exhaustive over admissible residues (odd classes mod
   8; the 16 admissible unit classes mod 120), establishing the stated minimal moduli
   and the exact 1/2 residue-class balance behind every density claim.

Trusted boundary: the checker re-implements only congruence arithmetic and residue
enumeration; board values, orbit data, and split indicators on `q ≤ 101` come from the
committed C288 JSON (whose own trusted boundary is stated in the C288 report), and the
template nimbers from the committed C284 table. The checker shares no solver code with
C284/C288. What the checker does *not* certify: Dickson existence for `q > 101`, the
template nimbers themselves, or anything about wild characteristic or the full
`PSL₂/PGL₂` escape residual.

## 9. Proved versus verified-on-domain — summary

- **Proved, unconditional** (for any tame realization, any admissible `q`): Lemmas
  A1–A3; Theorems B, C (split-indicator congruence laws — these are now theorems, with
  the C288 census as independent verification only); Theorem D (orbit-equation
  divisibility and the `m₁` parity laws); the `S₄ ∩ PSL₂` dichotomy `q ≡ ±1 (mod 8)`;
  all quadratic-character reformulations; the minimal-modulus and residue-balance facts
  (finite enumerations); Corollary F given Theorem E.
- **Proved modulo the finite template table**: Theorem E's ten closed value laws. The
  table is `q`-independent and exactly computed (C284, dual solver); within it, the six
  mirror-class regular zeros are proved (C289), while `t₁ = 1` for `(2,3,5)`/`(2,5,5)`
  and the nonregular entries are machine-verified finite facts. No claim in this report
  is limited to `q ≤ 101`.
- **Verified on domain** (`q ≤ 101`): the full agreement of every law with the C288
  census, counts in §8.
- **Cited**: Dickson's classification (existence of `S₄` for all odd `q`, `A₅` for
  `q ≡ ±1 (mod 5)`; uniqueness up to conjugacy is *not* used by any law); PNT for
  arithmetic progressions for the density corollaries.
- **Excluded**: wild characteristic (`p | |G|`, C283 boundary); the full `PSL₂/PGL₂`
  escape residual.

## 10. Title/abstract-ready corollaries (print-ready)

> **Corollary P1 (octahedral boards have period eight).** Let `q` be an odd prime power,
> `p ≠ 3`, and let the selected points induce a tame `S₄ ≤ PGL₂(q)`. Then the
> projective-line Node-Kayles value of the class `(2,3,3)` is `2·[2 ∉ (F_q^×)²]` — the
> value is 2 precisely when `q ≡ 3, 5 (mod 8)` — while each of the classes `(2,3,4)`,
> `(3,3,3)`, `(3,4,4)` has value `[−2 ∈ (F_q^×)²]`, i.e. 1 precisely when
> `q ≡ 1, 3 (mod 8)`. The `S₄` board value is periodic in `q` with exact period 8, and
> Grundy value 2 — the only tame polyhedral board value exceeding 1 — occurs for
> exactly half of all primes.

> **Corollary P2 (icosahedral boards have period 120).** Let `q ≡ ±1 (mod 5)` be an odd
> prime power, `p ∉ {3,5}`, and let the selected points induce a tame `A₅ ≤ PGL₂(q)`.
> Then `v(2,3,5) = [χ(6)=−1] ⊕ [q ≡ 1 (mod 5)]`, `v(2,5,5) = [6 ∉ (F_q^×)²]`,
> `v(3,5,5; ρ=3) = [q ≡ 1 (mod 3)] ⊕ [q ≡ 1 (mod 5)]`, `v(5,5,5) = [q ≡ 1 (mod 4)]`,
> and `v(3,3,5) = v(3,5,5; ρ=5) = 0`. The `A₅` board value is determined by `q mod 120`
> and by no smaller modulus; the individual classes have minimal moduli 120, 24, 15,
> and 4.

> **Corollary P3 (equidistribution of polyhedral outcomes).** Among odd primes, each of
> the four `S₄` classes is an N-position with natural density 1/2; among the admissible
> primes `p ≡ ±1 (mod 5)`, each of the four nonconstant `A₅` classes is an N-position
> with relative density 1/2, and the two remaining classes are P-positions for every
> admissible field.

> **Corollary P4 (free-orbit parity).** The number `m₁` of free `A₅`-orbits on
> `P¹(F_q)` satisfies `m₁ ≡ [χ(6) = −1] + [q ≡ 1 (mod 5)] (mod 2)`: the icosahedral
> free part has odd multiplicity exactly when precisely one of "6 is a nonsquare in
> `F_q`" and "`q ≡ 1 (mod 5)`" holds. This parity — the only global datum the regular
> template contributes — is determined by `q mod 120` and by no smaller modulus.

## 11. Draft paper text for C264 (manuscript not edited here)

Proposed section, immediately after the polyhedral coset-template section (C284's
proposed addition) and before the Discussion; numbering left to the coordinator.
Manuscript conventions: `χ` the quadratic character, indicators as in §8 of the paper.

> **Closed congruence laws for the polyhedral classes.** The split indicators of a tame
> polyhedral subgroup are governed by quadratic residues. A tame semisimple element of
> order `d ≥ 3` of `PGL₂(q)` has rational fixed points exactly when `d | q−1`; an
> involution `[M]` (`tr M = 0`) has rational fixed points exactly when `−det M` is a
> square, while it lies in `PSL₂(q)` exactly when `det M` is: so an involution class is
> split exactly when its `PSL₂`-membership agrees with `q ≡ 1 (mod 4)`. For
> `S₄ ≤ PGL₂(q)` the determinant character is trivial or the sign character, and
> evaluating it on a 4-cycle inside its (split or nonsplit) torus shows it is trivial
> exactly when `q ≡ ±1 (mod 8)`; hence `ε₂ₐ = [χ(−2) = 1]`,
> `ε₄ = ε₂ᵦ = [χ(−1) = 1]`, `ε₃ = [χ(−3) = 1]`. For `A₅`, perfectness forces
> `A₅ ≤ PSL₂(q)`, giving `ε₂ = [q ≡ 1\ (4)]`, `ε₃ = [q ≡ 1\ (3)]`, `ε₅ = [q ≡ 1\ (5)]`.
> Reducing the orbit equation `q + 1 = 30ε₂ + 20ε₃ + 12ε₅ + 60m₁` modulo 8 yields the
> free-orbit parity `m₁ ≡ [χ(6) = −1] + [q ≡ 1\ (5)] \pmod 2`.
>
> Substituting these laws and the template nimbers of Tables [C284-TABLES] into the
> orbit formula gives closed values for all ten refined classes. For `S₄` the board
> value depends only on `q mod 8`: the class `(2,3,3)` has value `2·[χ(2) = −1]`, equal
> to 2 precisely when `q ≡ 3, 5 (mod 8)`, and the classes `(2,3,4)`, `(3,3,3)`,
> `(3,4,4)` have value `[χ(−2) = 1]`. For `A₅`,
> `v(2,3,5) = [χ(6)=−1] ⊕ [q ≡ 1\ (5)]` (minimal modulus 120),
> `v(2,5,5) = [χ(6) = −1]` (the `ε₅` of the stabilizer template cancels against the
> free-orbit parity; minimal modulus 24), `v(3,5,5;ρ{=}3) = [q≡1\ (3)] ⊕ [q≡1\ (5)]`
> (modulus 15), `v(5,5,5) = [q ≡ 1\ (4)]` (modulus 4), and
> `v(3,3,5) = v(3,5,5;ρ{=}5) = 0` identically. By the prime number theorem for
> arithmetic progressions, each nonconstant class is an N-position with relative
> density `1/2` among (admissible) primes — in particular the value 2, the only tame
> polyhedral board value exceeding 1, occurs for exactly half of all primes — and the
> two constant `A₅` classes are P-positions over every admissible field. These laws
> hold for every tame realization over every admissible odd prime power; the census of
> Appendix [C288-APPENDIX] verifies them exhaustively for `q ≤ 101`.

(If the abstract is updated: one candidate sentence — "For the polyhedral boundary we
prove closed congruence laws: the `S₄` board value is periodic in `q` with period 8 and
achieves Grundy value 2 exactly when `2` is a nonsquare, the `A₅` board value is
periodic with modulus 120, and every nonconstant polyhedral class is an N-position for
exactly half of all admissible primes.")
