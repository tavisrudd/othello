# C1013 — Modular and transvectant foundations for the Gram–discriminant hierarchy

**Lane:** clebsch
**Date:** 2026-08-30
**Scope:** research computation only. No manuscript, no `ergodis*` source, no Lean source was touched.
**Owned files:** this report and `notes/clebsch-tasks/c1013_modular_foundations.py`.
**Replay:** `uv run --with sympy python3 notes/clebsch-tasks/c1013_modular_foundations.py all`
(sections `t1 t2 t3 t4 t5`; the full run takes a few minutes and prints ~180 lines).

Addresses proof gates 1–3 of `notes/clebsch-tasks/c1013-gram-discriminant-invariant-hierarchy.md`
(characteristic minimization via divided powers, integral root-to-coefficient descent,
transvectant/plethysm decomposition), plus the "modular radical of the form / divided-power
normalization" rows of the mystery ledger in
`notes/clebsch-tasks/c1013-gram-discriminant-classicality-audit.md`.

## 0. Conventions (fixed once, used everywhere below)

* `V = <x,y>`; a linear form is `l = a x + b y`, recorded as `(a,b)`; bracket
  `[l,m] = a_l b_m - b_l a_m`.
* `B_d` is the invariant form on the degree-`d` Veronese module, normalized on pure powers by
  `B_d(l^d, m^d) = [l,m]^d`.
* **Derived Gram matrix.** Expanding `l^d = sum_i C(d,i) a^i b^{d-i} e_i` with `e_i = x^i y^{d-i}`
  and matching `([l,m])^d = sum_i C(d,i) (-1)^{d-i} a^i b^{d-i} a'^{d-i} b'^i` gives, uniquely,

  ```
  B_d(e_i, e_j) = 0 unless i + j = d,       B_d(e_i, e_{d-i}) = (-1)^{d-i} / C(d,i).
  ```

  This is the **apolar / `Sym^d` normalization**: antidiagonal, with binomial coefficients in the
  *denominator*. Passing to the divided-power module `Gamma^d(V)` with basis
  `x^{[i]} y^{[d-i]}` — where the pure power expands **without** binomial coefficients,
  `l^d = sum_i a^i b^{d-i} x^{[i]} y^{[d-i]}` — gives the **divided-power normalization**

  ```
  B_d(x^{[i]}y^{[d-i]}, x^{[j]}y^{[d-j]}) = 0 unless i+j = d,
  B_d(x^{[i]}y^{[d-i]}, x^{[d-i]}y^{[i]}) = (-1)^{d-i} C(d,i),
  ```

  antidiagonal with binomials in the *numerator*, hence integral over `Z` with no division.
* Roots: `l_t = x - t y` (so `[l_s, l_t] = s - t`), `l_inf = y`. Normalized four-point chart
  `(inf, 0, 1, lam)`: `l_1 = y`, `l_2 = x`, `l_3 = x - y`, `l_4 = x - lam y`.
* `G_{d,r} = det([l_i,l_j]^d)`, `Delta = prod_{i<j} [l_i,l_j]^2`, `Phi_{d,r} = G_{d,r}/Delta`.
  In the four-point chart `Delta = lam^2 (1-lam)^2`.
* `I = (lam^2 - lam + 1)` and `J = (lam+1)(lam-2)(2lam-1)` are the note's normalizations; they
  equal `12 * (F,F)_4` and `72 * (F,(F,F)_2)_4` in the transvectant normalization of §5.

**Point of principle used throughout.** `G_{d,r}`, `Delta` and `Phi_{d,r}` are polynomials in the
brackets `[l_i,l_j]` only. They never mention a basis of `Sym^d`, so they are integral over `Z`
independently of which normalization above is chosen. The choice of model matters only for
interpreting `G` as the Gram determinant of an actual lattice, which is §1's subject.

---

## 1. Modular radical of `B_d`

**Method:** exact rational construction of both antidiagonal Gram matrices for every `d` in
`1..29`, reduction mod `p` for `p` in `{2,3,5,7,11,13,17,19,23,29}`, rank by counting nonzero
antidiagonal entries, cross-checked for `d <= 14` against an independent Gaussian elimination mod
`p` written from scratch (agreement in every case).

### 1.1 Exact rank formulas (verified for all `d < 30`, all `p <= 29`)

**Divided-power model `Gamma^d`.** The reduction mod `p` has

```
rank_p B_d = #{ i : C(d,i) != 0 mod p } = prod_k (d_k + 1),   d = sum_k d_k p^k.
```

Verified with zero exceptions. This is Lucas' theorem: `C(d,i) != 0 mod p` iff every base-`p`
digit of `i` is at most the corresponding digit of `d`, and the number of such `i` is the digit
product. So the **radical of `B_d` in the divided-power model is spanned by the monomials
`x^{[i]} y^{[d-i]}` whose index `i` fails Lucas domination by `d`**, and its dimension is
`d + 1 - prod_k (d_k + 1)`.

**Apolar `Sym^d` model.** The literal matrix has entries `1/C(d,i)`, which does not reduce mod `p`
at all when `p | C(d,i)`. Its primitive integral form (multiply by `L_d = lcm_i C(d,i)`) has
antidiagonal entries `L_d / C(d,i)`, and

```
rank_p = #{ i : v_p C(d,i) = M_p(d) },   M_p(d) = max_j v_p C(d,j),
```

again verified with zero exceptions. The maximum itself has an exact combinatorial law, which is
*not* "number of base-`p` digits minus one" (that guess is false, first at `(d,p) = (3,2)`):
writing `d = sum_{k=0}^{n} d_k p^k` with `d_n != 0`, Kummer's carry criterion gives

```
M_p(d) = n - min{ k < n : d_k <= p-2 },    and M_p(d) = 0 if no such k exists.
```

Verified for all `d < 30`, all `p <= 29`. (Reason: a carry can start at position `k` only when
`d_k <= p-2`, and once started it can be continued through every higher position.)

### 1.2 Where the form is nondegenerate

Both models have **the same** nondegeneracy locus, and it is exactly

```
B_d is nondegenerate over F_p  <=>  writing d + 1 = a p^k with p not dividing a, one has a < p
                               <=>  d = a p^k - 1 for some 1 <= a <= p.
```

Verified for all `d < 30`, `p <= 29`. (The two models agree because `C(d,0) = 1` forces
`M_p(d) = 0` whenever the `Sym` model is nondegenerate, and then the two rank formulas coincide.)
Examples: `p=2` gives `d in {1,3,7,15,...}`; `p=3` gives `d in {1,2,5,8,17,26,...}`;
`p=5` gives `d in {1,2,3,4,9,14,19,24,...}`. In particular `d < p` is always nondegenerate,
recovering the naive "large characteristic" hypothesis as the `k = 0` case.

### 1.3 Rank table (witness)

| d  | dim | gamma-rank p=2,3,5,7 | sym-rank p=2,3,5,7 |
|---:|----:|:---------------------|:-------------------|
|  2 |   3 | 2, 3, 3, 3           | 1, 3, 3, 3         |
|  3 |   4 | 4, 2, 4, 4           | 4, 2, 4, 4         |
|  4 |   5 | 2, 4, 5, 5           | 2, 1, 5, 5         |
|  5 |   6 | 4, 6, 2, 6           | 2, 6, 4, 6         |
|  6 |   7 | 4, 3, 4, 7           | 1, 4, 3, 7         |
|  7 |   8 | 8, 6, 6, 2           | 8, 2, 2, 6         |
|  8 |   9 | 2, 9, 8, 4           | 4, 9, 1, 5         |
|  9 |  10 | 4, 2, 10, 6          | 4, 6, 10, 4        |
| 10 |  11 | 4, 4, 3, 8           | 2, 3, 8, 3         |
| 11 |  12 | 8, 6, 6, 10          | 4, 6, 6, 2         |
| 12 |  13 | 4, 4, 9, 12          | 2, 4, 4, 1         |
| 13 |  14 | 8, 8, 12, 14         | 2, 2, 2, 14        |
| 14 |  15 | 8, 12, 15, 3         | 1, 3, 15, 12       |

The two models have genuinely different radicals away from the nondegenerate locus (e.g.
`d = 12, p = 7`: rank 12 versus rank 1). The divided-power model is the correct integral
one — its rank is the honest "how much of `Gamma^d` still pairs" number, and it is the model in
which the Gram determinant `G_{d,r}` is literally a determinant of a matrix over `Z`.

---

## 2. Integrality and content of `Phi_{2m,4}`

**Method:** exact symbolic `4x4` determinant over `Q[lam]` in the `(inf,0,1,lam)` chart, exact
polynomial division by `lam^2(1-lam)^2`, then gcd of the integer coefficients.

**Result.** `Phi_{2m,4}(lam)` is in `Z[lam]` for every `m` (automatic: `G` has integer bracket
entries and the division is exact). The interesting datum is the content
`c(m) = cont(Phi_{2m,4})`, computed exactly for `m = 2..18`:

| m | deg | c(m) | m | deg | c(m) | m | deg | c(m) |
|--:|----:|-----:|--:|----:|-----:|--:|----:|-----:|
| 2 |   2 | 16   | 8 |  26 | 16   | 14 |  50 | 1  |
| 3 |   6 | 3    | 9 |  30 | 3    | 15 |  54 | 1  |
| 4 |  10 | 16   |10 |  34 | 1    | 16 |  58 | 16 |
| 5 |  14 | 5    |11 |  38 | 11   | 17 |  62 | 17 |
| 6 |  18 | 1    |12 |  42 | 1    | 18 |  66 | 1  |
| 7 |  22 | 7    |13 |  46 | 13   |    |     |    |

**Exact content law (verified `m = 2..18`).**

```
c(m) = 16  if m is a power of 2;
     = p   if m = p^k for an odd prime p;
     = 1   otherwise.
```

Equivalently `c(m) = 8^{[m a power of 2]} * Phi_m^{cyc}(1)`, where `Phi_m^{cyc}` is the `m`-th
cyclotomic polynomial. Only powers of 2 and 3 do **not** exhaust the primes that occur: every
prime occurs, at the single index family `m = p^k`.

**Mechanism (identified, not just observed).** With `s = lam^m + (1-lam)^m`,
`t = lam^m - (1-lam)^m`, the determinant factors exactly as
`G_{2m,4} = (1-s)(1+s)(1-t)(1+t)`, and the three collision factors sit in three different
factors: `lam(1-lam) | (1-s)`, `lam | (1+t)`, `(1-lam) | (1-t)`. Factorwise contents are

| m | cont (1-s)/lam(1-lam) | cont (1+s) | cont (1+t)/lam | cont (1-t)/(1-lam) |
|--:|---:|---:|---:|---:|
| 2 | 2 | 2 | 2 | 2 |
| 3 | 3 | 1 | 1 | 1 |
| 4 | 2 | 2 | 2 | 2 |
| 5 | 5 | 1 | 1 | 1 |
| 6 | 1 | 1 | 1 | 1 |
| 7 | 7 | 1 | 1 | 1 |
| 8 | 2 | 2 | 2 | 2 |
| 9 | 3 | 1 | 1 | 1 |
| 11| 11| 1 | 1 | 1 |

so `c(m)` is the product of four factorwise contents, and the factor of `16 = 2^4` for
`m = 2^k` is four independent factors of 2. The prime-power criterion is Frobenius: mod `p`,
`1 - lam^m - (1-lam)^m == 0` identically iff `m = p^k`, since then
`lam^m + (1-lam)^m == lam^m + 1 - lam^m == 1`. For `m` not a `p`-power the binomial expansion of
`(1-lam)^m` mod `p` retains a term that cannot cancel.

**Boundary value.** `Phi_{2m,4}(0) = Phi_{2m,4}(1) = 4 m^2`, verified exactly for `m = 2..14`
(local expansion: `G ~ (m lam)(2)(m lam)(2)` at `lam -> 0`). More generally §4 gives
`Phi_{d,4}(0) = d^2` for every `d`.

**I,J-basis denominators.** In the note's `I, J` generators the coefficients are *not* integral;
the exact denominators, recomputed here, reproduce the note's table and extend it:

| d = 2m | 4 | 6 | 8 | 10 | 12 | 14 | 16 | 18 | 20 |
|---|---|---|---|---|---|---|---|---|---|
| denom | 1 | `3^2` | `3^3` | `3^6` | `3^8` | `3^9` | `3^12` | `3^14` | `3^14` |

These are pure powers of 3 and are an **artifact of the `I, J` normalization**, not of the
invariant: `I` is `12 x` and `J` is `72 x` the transvectant generators, a mismatched pair of
rescalings whose 3-adic discrepancy is exactly what appears. §4.4 and §5 give two different
denominator-free presentations.

---

## 3. Small-characteristic validity of `G = Delta * Phi`

**Method:** for `m = 2..8` and `p in {2,3,5,7,11,13}`, reduce the exact `Z[lam]` identity into
`F_p[lam]` (sympy `GF(p)` polynomial domain) and test `G - Delta*Phi == 0`; separately test the
content-primitive identity `G/c(m) = Delta * (Phi/c(m))` and the order of vanishing of the
primitive residual at `lam = 0, 1`.

**Result.** *The identity never fails.* Because `G`, `Delta`, `Phi` are integral bracket
polynomials, `G = Delta * Phi` is an identity in `Z[lam]` and reduces mod every prime. What
varies is whether the reduction is *informative*:

| verdict | when | (m,p) observed |
|---|---|---|
| holds, `Phi mod p` nonzero with `Phi(0) != 0` | `p` does not divide `4m^2` | most cells |
| holds after renormalizing by the content | `p \| c(m)`, i.e. `m = p^k` (and `p=2` with `m=2^k`) | (2,2),(3,3),(4,2),(5,5),(7,7),(8,2) |
| holds, but `Delta` divides `G` to higher order mod `p` | `p \| 4m^2/c(m)` | (3,2),(5,2),(6,2),(6,3),(7,2) |

Full table (`raw id` = the identity as reduced; `prim id` = the content-primitive identity;
`ord0/ord1` = vanishing order of the primitive residual at `lam = 0` and `lam = 1`;
`rank` = divided-power rank of `B_{2m}` over `F_p` out of `2m+1`):

| m | p | raw id | `Phi==0` | c(m) | `p\|c` | prim id | ord0 | ord1 | rank | verdict |
|--:|--:|---|---|---:|---|---|--:|--:|---|---|
| 2 | 2 | yes | yes | 16 | yes | yes | 0 | 0 | 2/5 | renormalize |
| 2 | 3,5,7,11,13 | yes | no | 16 | no | yes | 0 | 0 | 4/5, 5/5, 5/5, 5/5, 5/5 | holds |
| 3 | 2 | yes | no | 3 | no | yes | 2 | 2 | 4/7 | extra `Delta` order |
| 3 | 3 | yes | yes | 3 | yes | yes | 2 | 2 | 3/7 | renormalize |
| 3 | 5,7,11,13 | yes | no | 3 | no | yes | 0 | 0 | 4/7, 7/7, 7/7, 7/7 | holds |
| 4 | 2 | yes | yes | 16 | yes | yes | 2 | 2 | 2/9 | renormalize |
| 4 | 3,5,7,11,13 | yes | no | 16 | no | yes | 0 | 0 | 9/9, 8/9, 4/9, 9/9, 9/9 | holds |
| 5 | 2 | yes | no | 5 | no | yes | 2 | 2 | 4/11 | extra `Delta` order |
| 5 | 5 | yes | yes | 5 | yes | yes | 4 | 4 | 3/11 | renormalize |
| 5 | 3,7,11,13 | yes | no | 5 | no | yes | 0 | 0 | 4/11, 8/11, 11/11, 11/11 | holds |
| 6 | 2 | yes | no | 1 | no | yes | 6 | 6 | 4/13 | extra `Delta` order |
| 6 | 3 | yes | no | 1 | no | yes | 4 | 4 | 4/13 | extra `Delta` order |
| 6 | 5,7,11,13 | yes | no | 1 | no | yes | 0 | 0 | 9/13, 12/13, 4/13, 13/13 | holds |
| 7 | 2 | yes | no | 7 | no | yes | 2 | 2 | 8/15 | extra `Delta` order |
| 7 | 7 | yes | yes | 7 | yes | yes | 6 | 6 | 3/15 | renormalize |
| 7 | 3,5,11,13 | yes | no | 7 | no | yes | 0 | 0 | 12/15, 15/15, 8/15, 4/15 | holds |
| 8 | 2 | yes | yes | 16 | yes | yes | 6 | 6 | 2/17 | renormalize |
| 8 | 3,5,7,11,13 | yes | no | 16 | no | yes | 0 | 0 | 12/17, 8/17, 9/17, 12/17, 8/17 | holds |

**Sharp statement.** Over `F_p`, `Delta` divides `G_{2m,4}` to order exactly
`2 + ord_0(Phi_prim mod p)`, and `ord_0 > 0` iff `p` divides `4m^2 / c(m)`. Note that the
degeneracy of `B_{2m}` itself (last column) is **decoupled** from the identity's validity: at
`(m,p) = (8,3)` the form has rank 12 out of 17 and the identity still holds with no correction,
while at `(2,3)` the form has rank 4 out of 5 and likewise. Degeneracy of `B_d` costs the
*interpretation* of `G` as a nondegenerate Gram determinant; it costs the factorization nothing.

---

## 4. General `(d,r)` beyond `r = 4`

**Method:** exact symbolic determinants. `r = 3` uses fully generic affine roots `t_1,t_2,t_3`;
`r >= 4` uses the normalized chart `(inf, 0, 1, lam_4, ..., lam_r)`. The chart is not a loss of
generality: `G`, `Delta`, `Phi` are `SL_2`-invariant polynomials in the `l_i`, so by the first
fundamental theorem they are bracket polynomials, homogeneous of a fixed degree, and a
homogeneous identity is determined by its restriction to the chart's slice. Divisibility is
tested by exact multivariate polynomial division with a zero-remainder assertion, never by
`simplify`.

### 4.1 Parity dichotomy — verified

`G_{d,r} == 0` identically at `(5,3), (7,3), (7,5)`, and (with fully generic roots) at `(d,3)`
for `d = 5,7,9` — every tested case with `d` odd and `r` odd. For `d` odd and `r` even, `G = Pf^2`
was verified exactly at `(5,4), (7,4), (7,6)`.

### 4.2 `Delta | G` — verified in every nonzero case

| (d,r) | e = d-r+1 | `G == 0` | `Delta \| G` | chart-degree of `Phi` |
|---|---:|---|---|---:|
| (4,3) | 2 | no  | yes | 6 (generic roots) |
| (5,3) | – | yes | –   | – |
| (6,3) | 4 | no  | yes | 12 (generic roots) |
| (7,3) | – | yes | –   | – |
| (4,4) | 1 | no  | yes | 2 |
| (5,4) | 2 | no  | yes | 4 |
| (6,4) | 3 | no  | yes | 6 |
| (7,4) | 4 | no  | yes | 8 |
| (6,5) | 2 | no  | yes | 6 |
| (7,5) | – | yes | –   | – |
| (8,5) | 4 | no  | yes | 12 |
| (6,6) | 1 | no  | yes | 4 |
| (7,6) | 2 | no  | yes | 8 |
| (8,6) | 3 | no  | yes | 12 |

### 4.3 `r = 3`: exact closed form

```
G_{d,3} = 0                         for d odd;
Phi_{d,3} = 2 * Delta_3^{(d-2)/2}   for d even,
```

where `Delta_3 = prod_{i<j}(t_i - t_j)^2` is the cubic discriminant. Verified symbolically with
generic roots for `d = 4, 6, 8` (and `G = 0` for `d = 5,7,9`). This is forced: the invariant ring
of a binary cubic is `K[Delta_3]` with `deg Delta_3 = 4`, and `Phi_{d,3}` has coefficient degree
`2(d-2)`, leaving only the stated power. The constant is exactly 2 in the bracket normalization,
because the `3x3` permanent of a zero-diagonal symmetric matrix is `2 u_{12}u_{13}u_{23}`.

### 4.4 `r = 4`: complete closed-form solution of the four-point hierarchy

This is the strongest new result of the pass. The Plücker/Jacobi relation for four binary linear
forms,

```
[12][34] - [13][24] + [14][23] = 0,
```

says that the triple `x = [12][34]`, `y = -[13][24]`, `z = [14][23]` satisfies `x + y + z = 0`.
Set `e_2 = xy + yz + zx`, `e_3 = xyz`, and define the two bracket-normalized invariants

```
I     = -e_2 = ( [12]^2[34]^2 + [13]^2[24]^2 + [14]^2[23]^2 ) / 2     (coefficient degree 2)
Delta = e_3^2 = ( prod_{i<j} [ij] )^2                                  (coefficient degree 6)
```

In the `(inf,0,1,lam)` chart these are exactly `(x,y,z) = (lam-1, -lam, 1)`, `I = lam^2-lam+1`,
`Delta = lam^2(1-lam)^2` — verified, including `x+y+z = 0` and `Delta = (xyz)^2`.

Let `p_k = x^k + y^k + z^k`. Since `e_1 = 0`, Newton's identities collapse to a three-term
recurrence with **no denominators**:

```
p_0 = 3,  p_1 = 0,  p_2 = 2I,        p_k = I * p_{k-2} + e_3 * p_{k-3}.
```

**Theorem (verified symbolically for `d = 4..16`).**

```
G_{d,4} = 2 p_{2d} - p_d^2      for d even,
G_{d,4} = p_d^2                 for d odd  (so Pf_{d,4} = p_d),
```

and in both cases `e_3^2 = Delta` divides the right-hand side exactly, with

```
Phi_{d,4} = (2 p_{2d} - p_d^2) / Delta   (d even),
Phi_{d,4} = (p_d / e_3)^2 = pi_{d,4}^2   (d odd).
```

The verification checked, for each `d` in `4..16`, both that the division by `e_3^2` is exact in
`Z[I, e_3]` and that the quotient equals the independently computed `Phi_{d,4}(lam)`.

**Consequence — integrality (gate 2, four-point case).** `p_k in Z[I, e_3]` by the recurrence, so
`Phi_{d,4} in Z[I, Delta]`, with **no denominators at all**. Explicitly:

```
Phi_{4,4}  = 16 I
Phi_{5,4}  = 25 I^2
Phi_{6,4}  = 36 I^3 - 3 Delta
Phi_{7,4}  = 49 I^4
Phi_{8,4}  = 64 I^5 + 16 I^2 Delta
Phi_{9,4}  = 81 I^6 + 54 I^3 Delta + 9 Delta^2
Phi_{10,4} = 100 I^7 + 125 I^4 Delta + 40 I Delta^2
Phi_{11,4} = 121 I^8 + 242 I^5 Delta + 121 I^2 Delta^2
Phi_{12,4} = 144 I^9 + 420 I^6 Delta + 304 I^3 Delta^2 - 3 Delta^3
Phi_{13,4} = 169 I^10 + 676 I^7 Delta + 676 I^4 Delta^2
Phi_{14,4} = 196 I^11 + 1029 I^8 Delta + 1372 I^5 Delta^2 + 56 I^2 Delta^3
Phi_{15,4} = 225 I^12 + 1500 I^9 Delta + 2590 I^6 Delta^2 + 300 I^3 Delta^3 + 9 Delta^4
Phi_{16,4} = 256 I^13 + 2112 I^10 Delta + 4608 I^7 Delta^2 + 1040 I^4 Delta^3 + 64 I Delta^4
```

The leading coefficient is always `d^2`, which is the invariant form of the boundary value
`Phi_{d,4}(0) = d^2` recorded in §2 (`Delta(0) = 0`, `I(0) = 1`). Since
`J^2 = 4 I^3 - 27 Delta` in these normalizations (verified symbolically), this is the same information as the
note's `I, J` presentation, with the powers-of-3 denominators of §2 removed: **`Phi_{d,4}` is an
integral polynomial in the apolar invariant and the discriminant, and it is only the choice of
`J` as a second generator that introduces denominators.**

Representation in `I, Delta` is unique despite the chart relation `Delta = (1-I)^2`, because the
monomials `I^k Delta^l` of a fixed coefficient degree have pairwise distinct `lam`-degrees.

**Pfaffian residual.** For `d` odd, `pi_{d,4} = p_d / e_3` is exact and integral, of coefficient
degree `d - 3`, with leading coefficient `d`:

```
pi_{5,4}  = 5 I                     pi_{11,4} = 11 I (I^3 + Delta)
pi_{7,4}  = 7 I^2                   pi_{13,4} = 13 I^2 (I^3 + 2 Delta)
pi_{9,4}  = 3 (3 I^3 + Delta)       pi_{15,4} = 15 I^6 + 50 I^3 Delta + 3 Delta^2
```

and `Phi_{d,4} = pi_{d,4}^2` in every case. So the "Pfaffian residual" the task asked about
exists, is integral, and is exactly `p_d/e_3`.

### 4.5 `r = 5, 6`

`Delta | G` holds exactly in all four nonzero cases tested (`(6,5), (8,5), (6,6), (7,6), (8,6)`).
For `(7,6)`, `G = Pf^2`, `Pf = (prod [ij]) * pi` exactly, and `Phi = pi^2` with `pi` of chart
total degree 4. No attempt was made to express `Phi_{d,5}` or `Phi_{d,6}` in generators of the
quintic/sextic invariant rings.

---

## 5. Transvectant decomposition (gate 3)

### 5.1 Transvectant normalization

```
(f,g)_k = ((m-k)!(n-k)! / (m! n!)) * sum_{i=0}^{k} (-1)^i C(k,i)
          * d^k f / dx^{k-i} dy^i * d^k g / dx^i dy^{k-i},   m = deg f, n = deg g.
```

For `F = y * x * (x-y) * (x - lam y)` (roots `inf, 0, 1, lam`) this gives, exactly,

```
(F,F)_4        = (lam^2 - lam + 1) / 6 = I / 6
(F,(F,F)_2)_4  = (lam-2)(lam+1)(2lam-1) / 72 = J / 72
```

so the note's generators are `I = 12 (F,F)_4` and `J = 72 (F,(F,F)_2)_4` — a mismatched pair
(`12^2 != 72`, and `v_3(12) = 1` versus `v_3(72) = 2`), which is precisely the source of the
powers-of-3 denominators in §2.

### 5.2 The note's `I,J` table reproduced, and its transvectant form

The `I,J` expansions of the note were recomputed independently and agree exactly:

```
Phi_{4,4}  = 16 I
Phi_{6,4}  = (320 I^3 + J^2) / 9
Phi_{8,4}  = (1792 I^5 - 16 I^2 J^2) / 27
Phi_{10,4} = (87040 I^7 - 3695 I^4 J^2 + 40 I J^4) / 729
```

In the transvectant generators `T2 = (F,F)_4` and `T3 = (F,(F,F)_2)_4` the same invariants are
denominator-free:

```
Phi_{4,4}  = 96 T2
Phi_{6,4}  = 7680 T2^3 + 576 T3^2
Phi_{8,4}  = 516096 T2^5 - 110592 T2^2 T3^2
Phi_{10,4} = 33423360 T2^7 - 34053120 T2^4 T3^2 + 8847360 T2 T3^4
```

`J` occurs only in even powers, but that is forced, not a discovery: `2a + 3b = 2(d-3)` is even,
so `b` is even. The substantive statement is §4.4's: in `I` and the discriminant the coefficients
are small integers rather than these large ones.

### 5.3 The Wronskian identification — verified where it is a linear identification

For `r = d` the classical isomorphism specializes to
`wedge^d Sym^d V = (Sym^d V)^* = Sym^d V` (the last step by `B_d`), so `Psi_{d,d}(F)` must be a
scalar multiple of `F`. Computing `Psi` as the Vandermonde-divided vector of `d x d` Plücker
minors of the pure-power coordinate matrix, then raising the index by
`v_i = (-1)^{d-i} C(d,i) Psi_{d-i}`, gives exactly

```
Psi_{4,4}(F) = 96 * F,        Psi_{6,6}(F) = -162000 * F.
```

Both verified as exact polynomial identities in `lam` (resp. in the three chart variables) and in
`x, y`. The `(4,4)` scalar 96 is the same 96 that appears in `Phi_{4,4} = 96 (F,F)_4` above — a
consistency check across two independent computations.

### 5.4 The sharp permanent guess — stated, tested, and **refuted**

The task's sharp guess unfolds to a concrete testable identity. If the Wronskian isomorphism
`wedge^r Sym^d = Sym^r(Sym^{d-r+1})` carried the invariant form of the left side to the canonical
symmetric-power form of the right side (whose Gram evaluation on a product of pure powers is a
**permanent**, not a determinant), then with `e = d - r + 1`:

```
CONJECTURE:  Phi_{d,r}(F) = c_{d,r} * perm( [l_i, l_j]^e ).
```

The degrees match perfectly (`perm` has degree `2e = 2(d-r+1)` in each root, exactly the degree
of `Phi`), so this is a genuine test and not a degree tautology. Tested by exact proportionality
(evaluate at a rational point to get the candidate constant, then verify
`Phi - c * perm == 0` symbolically):

| (d,r) | e | `Phi = c * perm([ij]^e)` | c |
|---|---:|---|---|
| (4,3) | 2 | **yes** | 1 |
| (6,3) | 4 | **yes** | 1 |
| (4,4) | 1 | **yes** | 4 |
| (5,4) | 2 | **yes** | 25/4 |
| (6,4) | 3 | **NO** | – |
| (7,4) | 4 | **yes** | 49/4 |
| (6,5) | 2 | **yes** | 45/2 |
| (8,5) | 4 | **NO** | – |
| (6,6) | 1 | **yes** | 225 |
| (7,6) | 2 | **NO** | – |
| (8,6) | 3 | **NO** | – |

**The conjecture is false**, first at `(d,r) = (6,4)`. The `r = 4` power-sum calculus of §4.4
explains exactly why, and exactly why the small cases succeeded. Writing
`D(k) = 2 p_{2k} - p_k^2` and `S(k) = p_k^2`, the computations give

```
G_{d,4}      = D(d) if d even,  S(d) if d odd;
perm([ij]^e) = S(e) if e even,  D(e) if e odd.
```

(both halves verified symbolically: the `G` line for `d = 4..8`, the `perm` line for `e = 1..7`).
So the conjecture compares `G` at exponent `d` with the *same two* polynomial shapes evaluated at
exponent `e = d - 3`. In the `I, Delta` basis:

| d | `perm([ij]^{d-3})` | `Phi_{d,4}` |
|---|---|---|
| 4 | `4 I` | `16 I` |
| 5 | `4 I^2` | `25 I^2` |
| 6 | `4 I^3 - 3 Delta` | `36 I^3 - 3 Delta` |
| 7 | `4 I^4` | `49 I^4` |
| 8 | `4 I^5 + 5 I^2 Delta` | `64 I^5 + 16 I^2 Delta` |
| 9 | `4 I^6 + 12 I^3 Delta + 9 Delta^2` | `81 I^6 + 54 I^3 Delta + 9 Delta^2` |
| 10 | `4 I^7 + 21 I^4 Delta + 28 I Delta^2` | `100 I^7 + 125 I^4 Delta + 40 I Delta^2` |

The permanent always has leading coefficient 4; `Phi` always has leading coefficient `d^2`. They
are proportional exactly while `p_d` and `p_e` are both monomials in `I` and `e_3`, which holds
only for small indices (`p_2 = 2I`, `p_3 = 3e_3`, `p_4 = 2I^2`, `p_5 = 5 I e_3`, `p_7 = 7 I^2 e_3`;
the pattern first breaks at `p_6 = 2 I^3 + 3 e_3^2` and `p_8 = 2 I^4 + 8 I e_3^2`). The observed
successes at `(4,4), (5,4), (7,4)` are exactly the cases living in that monomial regime.

**Correct statement of gate 3.** `Phi_{d,r}(F) = <Psi_{d,r}(F), Psi_{d,r}(F)>` under the form
induced by `B_d` on `wedge^r Sym^d`. Transporting along the Wronskian isomorphism to
`Sym^r(Sym^{d-r+1})` transports that form to *some* invariant symmetric form there — but
`Sym^r(Sym^e)` is a reducible `SL_2`-module, so its space of invariant forms has dimension equal
to the number of irreducible summands, and the transported form is not the canonical
(permanent) one. The isomorphism is not an isometry. It **is** forced to be one, up to scalar,
exactly when `Sym^r(Sym^e)` is irreducible, i.e. when `e = 1`, i.e. `r = d` — which is precisely
the case verified in §5.3 (`(4,4)` and `(6,6)`, and the `r = 3` cases where the invariant space
is one-dimensional for a different reason). A closed transvectant formula for general `(d,r)`
therefore requires the actual plethysm decomposition of `Sym^r(Sym^{d-r+1})`, not the naive
permanent. **This is the concrete obstruction gate 3 has to clear, and it was not visible before
this pass.**

---

## 6. Divided powers: sharpest verified all-characteristic statement (gate 1)

Marked explicitly as **computational verification plus precise conjecture**, not a proof.

**Verified over `Z`, no exceptional primes.** For every tested `(d,r)` the identity

```
det( [l_i, l_j]^d )  =  ( prod_{i<j} [l_i, l_j]^2 ) * Phi_{d,r}(l_1, ..., l_r)
```

is an identity of polynomials with integer coefficients in the brackets, hence holds over every
commutative ring, in particular over `F_p` for every `p`, with no characteristic hypothesis. The
tested set is `(d,r)` in `{(4,3),(6,3),(4,4),(5,4),(6,4),(7,4),(6,5),(8,5),(6,6),(7,6),(8,6)}`
plus `(d,4)` for `d = 4..16`; the `(d,3)` and `(d,4)` families are closed-form and integral for
all `d` by §4.3 and §4.4.

**Where divided powers are needed.** Not for the identity — for the *interpretation*. The Gram
matrix of `B_d` in the monomial basis of `Sym^d` has entries `(-1)^{d-i}/C(d,i)`, which are not
`p`-integral once `p | C(d,i)`; in `Gamma^d(V)` the same form has entries `(-1)^{d-i} C(d,i)`
and defines an honest `Z`-lattice with an integral pairing. So the correct all-characteristic
formulation is: *take `B_d` on the divided-power module `Gamma^d(V_Z)`; then `G_{d,r}` is the
determinant of an integral Gram matrix, and `G = Delta * Phi` holds over `Z`.* The
characteristic-`p` phenomena are then exactly the two independent ones isolated above:

1. **Radical of the form** (§1): `B_d mod p` has rank `prod_k (d_k+1)`, nondegenerate iff
   `d + 1 = a p^k` with `a < p`. This bounds how large `r` can be before `G_{d,r} == 0` for
   trivial reasons, and it destroys the "nondegenerate quadratic space" reading of `Phi`. It does
   **not** invalidate the factorization.
2. **Content of the residual** (§2, §3): `Phi mod p` can vanish identically, exactly when
   `p | c(m)`; dividing by the content restores an informative identity. And `Delta` can divide
   `G mod p` to order higher than 2, exactly when `p | 4m^2/c(m)` in the four-point family.

**Conjecture (four points, all `d`, all characteristics).** `Phi_{d,4} in Z[I, Delta]` with
`Phi_{d,4} = (2 p_{2d} - p_d^2)/Delta` for `d` even and `(p_d/e_3)^2` for `d` odd, where `p_k` is
the power sum of the Plücker triple. Verified `d = 4..16`; a proof needs only Newton's identities
for `e_1 = 0` plus the statement that `e_3^2` divides `2 p_{2d} - p_d^2` and `p_d^2`, which is the
`r = 4` case of `Delta | G`. There are **no exceptional primes** for this family.

**Conjecture (three points).** `Phi_{d,3} = 2 Delta_3^{(d-2)/2}` for `d` even, `G_{d,3} = 0` for
`d` odd, over `Z`. Verified `d = 4,6,8`; the only prime that could ever matter is 2, through the
explicit constant 2, and even there the identity is integral.

---

## 7. Ergodis interface notes

Per the coordinator's directive, the Ergodis engine
(`papers/complete-repair-ports/ergodis`, release CLI at `target/release/ergodis`) was tried first
for task 1 (rank of `B_d` over `F_p`) and task 3 (mod-`p` validity table). **Neither leg fits the
existing typed surface**, so both were done in the sympy script. Recorded for the C1013 card's
§7 interface-improvement notes:

* **Every CLI front end refuses odd characteristic.** `compose`, `transfer`, `transfer-subspace`
  and `transfer-tower` all hard-fail with `"... currently requires base_prime 2"`
  (`src/bin/ergodis.rs`, four separate guards). Task 1 needs `F_p` for `p` up to 29 and task 3
  needs `p in {2,3,5,7,11,13}`, so both are out of scope by construction.
* **Even the characteristic-2 leg is not reachable.** A minimal probe feeding a `5x5` rank query
  as a `transfer-subspace` target normalization over `GF(2)` was rejected:

  ```
  ergodis transfer-subspace --input <probe>.json
  Error: the target-subspace front end currently requires GF(4) with modulus [1, 1, 1]
  ```

  So the front end is pinned to a single field, `GF(4)`, not merely to characteristic 2.
* **The new rank kernels are library-internal and single-field.** The "table-driven exact
  small-field rank kernels" work (commit `0766fc6f2`) lives in `ergodis-private/src/semantic_rank.rs`
  as `BlockSystem<F: SmallField>` / `compile_semantic_rank_core`, with `SmallField` implemented
  only for `Gf9` (plus a `Gf2` test shim). There is no binary exposing it and no `F_p` instance
  for `p in {3,5,7,11,13,...}`. Using it would have required editing `ergodis-private`, which is
  out of scope for this task.
* **Missing typed operation, stated precisely.** What both legs needed is a first-class
  *"exact rank / radical of an explicit `n x n` integer matrix reduced modulo a supplied prime
  `p`"* entry point — inputs: `p`, `n`, dense or sparse integer entries; outputs: rank, a basis
  of the radical, and optionally the Smith normal form or elementary divisors. Task 3 additionally
  needed *"exactness of a polynomial identity in `F_p[t]`"*, i.e. reduce given `Z[t]` polynomials
  mod `p` and test divisibility with the vanishing order at named points — a univariate
  `F_p`-polynomial layer that Ergodis does not have at all. Both are natural companions to the
  existing rank core; neither is coding-theory-specific.

---

## 8. Open observations

Stated precisely, no speculation. Each is a fact established above whose *reason* is not yet
established.

1. **The `16` in the content law.** `c(m) = 16` for `m` a power of 2, versus `c(m) = p` for
   `m = p^k` with `p` odd. The Frobenius mechanism of §2 explains one factor of `p` (resp. 2) per
   vanishing factor. For odd `p` only the factor `(1-s)/lam(1-lam)` picks up a `p`; for `p = 2`
   all four factors pick up a 2, giving `2^4`. Why the odd primes see one factor and 2 sees four
   is explained factorwise in the table but not by a single argument.
2. **Sign alternation of the pure-`Delta` coefficient.** In §4.4 the coefficient of the top
   `Delta` power, which is present exactly when `3 | d`, alternates: `-3` at `d = 6, 12`, `+9` at
   `d = 9, 15`. No mechanism identified.
3. **The `d^2` leading coefficient.** `Phi_{d,4} = d^2 I^{d-3} + ...` and `pi_{d,4} = d I^{(d-3)/2}
   + ...` exactly, for every `d` from 4 to 16. This follows from the boundary value
   `Phi_{d,4}(0) = d^2` (proved by local expansion in §2), but its invariant-theoretic meaning —
   why the residual's leading apolar coefficient is the Veronese degree squared — is unexplained.
4. **The failure pattern of the permanent conjecture.** Successes at
   `(4,3), (6,3), (4,4), (5,4), (7,4), (6,5), (6,6)`; failures at `(6,4), (8,5), (7,6), (8,6)`.
   For `r = 4` the reason is completely understood (§5.4: the power sums `p_k` cease to be
   monomials at `k = 6`). For `(6,5)` succeeding with `c = 45/2` while `(8,5)` and `(7,6)` fail,
   no analogous calculus was built, so those three data points remain unexplained coincidences and
   non-coincidences.
5. **Independence of form degeneracy and identity validity.** At `(m,p) = (8,3)` the form `B_16`
   has rank 12 out of 17 yet the factorization needs no correction, and at `(2,3)` rank 4 out of 5
   likewise. Across the whole §3 table the divided-power rank column never predicts the verdict
   column. This is presumably because `G` and `Delta` are bracket polynomials that never see the
   module, but it means the "modular Gram shadow" of the classicality audit's open row is weaker
   than the identity: the identity survives everywhere, the *quadratic-space interpretation* does
   not.
6. **`Sym`-model versus divided-power radical.** The two normalizations agree exactly on the
   nondegeneracy locus but can differ wildly off it (`d = 12, p = 7`: rank 12 versus rank 1;
   `d = 13, p = 5`: rank 12 versus rank 2). Which of the two ranks controls any downstream
   arithmetic statement is not determined here.

---

**Status: complete** for tasks 1–7 as scoped. Tasks 1, 2, 3, 4 (including the `r=3` and `r=4`
closed forms), 5 and 6 are all answered with exact symbolic or exact mod-`p` verification, and
task 5's sharp guess is refuted with a mechanism. The one deliberate non-delivery is expressing
`Phi_{d,5}` and `Phi_{d,6}` in generators of the quintic/sextic invariant rings, which the task
scoped out.
