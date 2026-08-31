# C1014 -- the finite-field stratification of the Phi_{2m,4} census, derived

**Lane:** clebsch · **Task:** C1014 (math-only; no manuscript, Ergodis or Lean
source edits) · **Date:** 2026-08-30

**Script (owned):** `notes/clebsch-tasks/c1014_dickson_strata.py`
**Replay:**

```
uv run --with sympy --with numpy python3 \
    notes/clebsch-tasks/c1014_dickson_strata.py <cmd>
# cmd in: periodicity 120 | master 200 | scan 4000 | cells 12 1200
#         | fixedm 9 | fermat | p47 | uline 24 | ergodis
```

Every claim below is labelled **proved**, **verified-exact (range)**, or
**conjectured**.  Taken as given from the prior C1014 reports (not reproved
here): the product law `u^2 Phi_{2m,4} = prod_{eps,eta} (1 + eps lam^m + eta
(1-lam)^m)`; the genus law `g(C_m) = 2m-4-2[m == 1 mod 3]`; the four named
constant-character strata; the classification data for `p <= 300`.

---

## Executive summary

The whole stratification is one statement: **for `lam` outside `{0,1}` the
census only sees the pair `(lam^m, (1-lam)^m)`, so it is a character sum
pulled back along the `m`-th power map, and the census degenerates exactly
when that pullback factors through a *fixed* curve of small genus.**

1. **Periodicity (proved, verified-exact for all `m < 3p`, `p < 120`).**
   `u^2 Phi_{2m,4}(lam) = G_r(lam)` with `r = 2m` and
   `G_r = (1 - lam^r - (1-lam)^r)^2 - 4 (lam(1-lam))^r`, an *identity of
   polynomials over Z*.  Hence the `chi(Phi)` census depends on `m` only
   through `r = 2m mod (p-1)`; the 16-stratum Fermat coloring only through
   `m mod (p-1)`.
2. **Master formula (proved, verified-exact 308 pairs, `m = 2..8`,
   odd `p < 200`).**  With `d = gcd(r,p-1)`, `e = (p-1)/d`, the census is a
   Plancherel pairing between a matrix of Jacobi sums of characters of order
   dividing `e` and the Fourier matrix of `chi(F)` on the subgroup
   `H = {lam^r}`.
3. **Classification (proved family-by-family; verified-exact and complete for
   `5 <= p < 4000`, every even `r`).**  Exactly fifteen classes occur, and
   they split into three provable kinds: two identically degenerate families
   (`m == 0` and `m == 1 mod p-1`), three power-residue families
   (`lam^m in mu_n`, `n in {3,4,8}`, each infinite by Chebotarev with an
   explicit square-class condition on `p`), and ten finite sporadic families,
   each closed by a Weil bound on **one** fixed curve plus exhaustive search.
4. **(47,30) is settled (proved + verified-exact).**  It is the reduction
   `3m == -1 (mod p-1)`: the census becomes a character sum over the **Fermat
   cubic** `xi^3 + eta^3 = 1`, a fixed genus-1 curve, of a fixed degree-4
   function whose double cover has genus 13.  Weil closes that family at
   `p <= 889`; exhaustive search gives exactly three members,
   `(17,6)`, `(17,10)`, `(47,30)`.  **There are no further members, ever.**
   So `(47,30)` is neither an isolated accident nor the seed of an infinite
   family: it is the last member of a new *finite* family, and it shares its
   mechanism with the two `p = 17` points that the previous report had
   classified separately.
5. **Bonus (verified-exact, `p <= 23`).**  The `u`-line (descent-quotient)
   census has minimal period `lcm(p-1,p+1)` in `m`, not `(p-1)/2`: the
   `u`-line sees the non-split torus, the `lam`-line only the split one.

Vibe check: the tt-pass guess ("the Dickson pullback should derive the
stratification and absorb `(47,30)`") was right, and cheaper than expected --
the classification is a one-page reduction plus a Weil bound per family, and
the last open sporadic of the modular-structure report is now a theorem with
a complete member list.

---

## 0. Notation

`p` odd prime, `N = p-1`, `chi` the Legendre symbol, `u = lam(1-lam)`.
`x = lam^m`, `y = (1-lam)^m`,
`Q(x,y) = prod_{eps,eta in {+-1}} (1 + eps x + eta y) = (1-(x+y)^2)(1-(x-y)^2)`,
`F(X,Y) = (1-X-Y)^2 - 4XY`,
`G_r(lam) = F(lam^r, (1-lam)^r)`.
The census is `S(m,p) = sum_{lam != 0,1} chi(Phi_{2m,4}(lam))` and
`(N+,N-,N0)` is its sign distribution on `F_p - {0,1}`.
"Constant" means: `chi` takes one value on the whole non-vanishing locus and
that locus is non-empty.

---

## 1. The periodicity theorem (task 1)

**Proposition 1 (proved, an identity over Z).**
`Q(x,y) = F(x^2, y^2)`.

*Proof.* Group the four factors in pairs:
`(1+x+y)(1-x-y) = 1-(x+y)^2` and `(1+x-y)(1-x+y) = 1-(x-y)^2`, so
`Q = 1 - (x+y)^2 - (x-y)^2 + (x^2-y^2)^2 = 1 - 2x^2 - 2y^2 + (x^2-y^2)^2`.
Expanding `F(X,Y) = (1-X-Y)^2 - 4XY = 1 - 2X - 2Y + (X-Y)^2` and substituting
`X = x^2, Y = y^2` gives the same polynomial. ∎

**Theorem 1 (periodicity; proved).**  Let `p` be odd and `lam in F_p - {0,1}`.
Then
`u^2 Phi_{2m,4}(lam) = G_{2m}(lam)` and therefore

* `chi(Phi_{2m,4}(lam))` depends on `m` only through `r = 2m mod (p-1)`;
* the full census `(N+,N-,N0)` at `(m,p)` depends only on `r = 2m mod (p-1)`;
* the 16-stratum Fermat coloring `lam -> (chi(A_{eps,eta}))` depends only on
  `m mod (p-1)`.

*Proof.*  The product law gives `u^2 Phi_{2m,4} = Q(lam^m, (1-lam)^m)`, and by
Proposition 1 this equals `F(lam^{2m}, (1-lam)^{2m}) = G_{2m}(lam)`.  Both
sides are polynomials with integer coefficients, so the identity survives
reduction mod `p` for every `p` (no content or normalisation prime is
involved: the leading content of `Phi_{2m,4}` is absorbed on the left, and the
identity is monic-free).  For `lam != 0,1` both `lam` and `1-lam` lie in
`F_p^*`, so `lam^{2m}` and `(1-lam)^{2m}` depend only on `2m mod (p-1)` by
Fermat's little theorem, and `u^2` is a nonzero square, so
`chi(Phi) = chi(G_{2m})` is a function of `r = 2m mod (p-1)` alone.  For the
refined coloring the same argument applies to each factor
`1 + eps lam^m + eta (1-lam)^m`, which depends on `m mod (p-1)`. ∎

**Two boundary remarks that the statement needs.**
(i) The excluded points `lam in {0,1}` are genuinely excluded: there
`u = 0`, the identity `chi(Phi) = chi(G_r)` loses its `u^2`, and
`Phi_{2m,4}(0) = Phi_{2m,4}(1)` is a fixed nonzero integer, so those two
points contribute a `p`-dependent but `m`-independent constant.  Every census
in this report is the punctured one.
(ii) The half shift `m -> m + (p-1)/2` replaces `lam^m` by `chi(lam) lam^m`,
a quadratic twist of each Fermat factor.  It fixes `r`, hence fixes the
`chi(Phi)` census, but generically moves the 16-stratum coloring: the
refinement doubles the resolution of the exponent stratification.

**Verified-exact.**  `periodicity 120`: 4736 pairs `(m,p)` with `p < 120` and
`1 <= m < 3p` -- `chi(Phi)` census equals the `G_r` census and equals the
census at the reduced exponent in every case, 0 failures.  For the coloring,
90 pairs (`p < 60`, `m = 2..7`): period `p-1` holds with 0 failures; the
*distribution* happens to coincide across the half shift at exactly two pairs,
`(m,p) = (6,13)` and `(7,29)` (the pointwise colorings still differ -- these
are distribution coincidences, not period failures).

---

## 2. The master character-sum formula (task 2)

Fix `r` and put `N = p-1`, `d = gcd(r,N)` (with `d = N` when `r == 0`),
`e = N/d`, and `H = {lam^r : lam in F_p^*}`, the subgroup of order `e`; the
`r`-th power map hits each element of `H` exactly `d` times.  Write
`theta_t`, `t in Z/e`, for the `e` characters of `F_p^*` of order dividing
`e`, and for `X in H` set `alpha_t(X) = theta_t(lam)` for any `lam` with
`lam^r = X`.

**Lemma 2 (proved).**  `alpha_t` is well defined.  If `lam^r = lam'^r` then
`(lam/lam')^d = 1`, and `theta_t` is trivial on `mu_d` precisely because its
order divides `e = N/d`.

**Theorem 2 (master formula; proved).**

```
S(r,p) = (1/e^2) * sum_{t1,t2 in Z/e}  J(theta_{-t1}, theta_{-t2}) * conj(K(t1,t2)),

K(t1,t2) = sum_{X,Y in H} chi(F(X,Y)) * conj( alpha_{t1}(X) alpha_{t2}(Y) ),
J(A,B)   = sum_{lam != 0,1} A(lam) B(1-lam)      (Jacobi sum).
```

*Proof.*  Let `s(lam) = r' * ind(lam) mod e` with `r' = r/d`, so that
`lam^r = g^{d s(lam)}` for a primitive root `g`; `s` is the coordinate of
`lam^r` on `H`.  Let `M[s1,s2] = #{lam != 0,1 : s(lam) = s1, s(1-lam) = s2}`
and `A[s1,s2] = chi(F(g^{d s1}, g^{d s2}))`.  Then
`S = sum_{s1,s2} M[s1,s2] A[s1,s2]` because `chi(Phi)` at `lam` equals
`A[s(lam), s(1-lam)]` (Theorem 1).  Apply Parseval for the `(Z/e)^2` discrete
Fourier transform.  The transform of `M` at `(t1,t2)` is
`sum_{lam} theta_{-r' t1}(lam) theta_{-r' t2}(1-lam)`, a Jacobi sum of two
characters of order dividing `e`; the transform of `A` is `K`. ∎

**What the formula separates.**  `K` is the Fourier matrix of the *fixed*
pattern `chi(F)` on the torus `H x H` -- pure geometry of the target, no
dependence on how `lam` moves.  `J` carries all the arithmetic of the power
map: `|J(A,B)| = sqrt(p)` whenever `A`, `B`, `AB` are all nontrivial, and
`J = p-2`, `-1`, `-A(-1)` in the three degenerate cases.  So the census is a
pairing `<geometry, Jacobi sums>`, and a census can only be constant when the
geometry side is supported on the few degenerate Jacobi sums -- which is
exactly the "small `e`, or small effective degree" condition made explicit in
section 3.

**Verified-exact.**  `master 200`: `m = 2..8`, every odd `p < 200`, 308 pairs;
worst `|direct - formula| = 4.3e-14` (float round-off), 0 failures.  The
transform entries were separately checked *against the definition* of the
Jacobi sum and against `|J| = sqrt p` off the degenerate locus at
`(p,r) = (13,4), (31,10), (41,8), (61,12), (47,30)`; worst deviation
`3.2e-13`.  The direct censuses the formula is compared against are the same
ones the Hasse/Sato-Tate report already cross-checked against the Ergodis
kernel over exactly this grid (`m = 2..8`, every odd `p < 200`, 315 censuses,
no disagreements); the six exceptional strata are re-checked on the kernel
here in section 4.3.

**Specialisation used below (proved).**  When `lam^m` takes values in `mu_n`
(i.e. `n m == 0 mod N`), `H` is finite and the formula collapses to the
classical cyclotomic form

```
S = sum_{a,b in Z/n} M_n(a,b) * chi( Q(zeta^a, zeta^b) ),
```

with `M_n(a,b)` the cyclotomic numbers of order `n` -- themselves the
`n^2`-term Jacobi-sum expansion `M_n(a,b) = (1/n^2) sum_{i,j} zeta^{-ai-bj}
J(psi^i, psi^j)`, whence `M_n(a,b) = p/n^2 + O(sqrt p)` and all cells are
non-empty once `p` is large compared with `n^4`.

---

## 3. The classification (task 3)

### 3.1 The reduction that generates every stratum

**Definition.**  For a pair `(m,p)` and any integer `k >= 1` put
`c = k m mod N`, taken with `|c| <= N/2`.  Then

```
x^k = lam^c,        y^k = (1-lam)^c,      x = lam^m, y = (1-lam)^m,
```

so the point `(x,y)` runs over the `F_p`-points of the curve
`Gamma_{k,c}` obtained by eliminating `lam` from those two equations -- a
curve depending on `(k,c)` **only**, not on `p`.  The census is the character
sum of the fixed degree-4 function `Q` over `Gamma_{k,c}(F_p)`, weighted by
the fibre multiplicity of `lam -> (x,y)`.

**Theorem 3 (reduction; proved, in the three cases actually used).**  Let
`D_{k,c}` be the smooth projective model of the double cover `w^2 = Q` over
`Gamma_{k,c}` -- a curve defined over `Q`, with genus `g(k,c)` and branch
number `B(k,c)` independent of `p`.

* **(a) `k = 1`.**  `Gamma_{1,c}` is the `lam`-line itself, `Q(lam^c,(1-lam)^c)`
  is a fixed rational function, and no hypothesis is needed:
  `|S| <= 2 g(1,c) sqrt p + B(1,c)`.
* **(b) `gcd(m,N) = gcd(k,N) = 1`.**  Then `lam -> (lam^m, (1-lam)^m)` is a
  bijection from `F_p - {0,1}` onto `{(x,y) in Gamma_{k,c}(F_p) : xy != 0}`,
  each point counted once, and
  `|S| <= (2 g(k,c) + 2 g(Gamma_{k,c})) sqrt p + B(k,c)`.
* **(c) `c = 0`.**  `Gamma` is the finite set `mu_k x mu_k` and the census is
  the cyclotomic form of section 2; Theorem 4 below replaces the Weil bound.

In cases (a) and (b), a constant census forces `|S| = p - 2 - z` with `z` at
most the number of zeros of `Q` on `Gamma`, so

```
p - 2 - z  <=  (2g + 2g_Gamma) sqrt p + B   ==>   p <= P(k,c),
```

an explicit bound.  Hence **for each such `(k,c)` with `D_{k,c}`
non-degenerate the constant stratum has finitely many members, and they can be
enumerated by direct census below `P(k,c)`.**  The degenerate alternative --
`Q` a constant times a square on `Gamma_{k,c}`, or identically 0 -- gives an
*infinite* family, constant at every admissible `p`.

The only `p`-dependence left is the reduction of `D_{k,c}` mod `p`: the bound
uses the geometric genus, so primes dividing the discriminant of the branch
divisor need a separate word.  Those primes are finite in number, computed
per family, and checked individually.

Three corners of Theorem 3 carry the whole classification.

* **`k = 1`** (`x = lam^c` literally): `Gamma` is the `lam`-line, and
  `D_{1,c}` is the fixed curve `C_{|c|}` of the tower itself.  The census at
  `m == c (mod N)` is the Frobenius trace on `C_{|c|}` -- this is the
  fixed-`m`/newform frame (section 5).
* **`c = 0`** (`lam^m in mu_k`): `Gamma` is the finite set `mu_k x mu_k`, and
  the census is the cyclotomic form of section 2.
* **`c = +-1`, `gcd(k,N) = 1`**: `Gamma` is the **Fermat curve**
  `x^k + y^k = 1` (or its reciprocal), of genus `(k-1)(k-2)/2`.  This is the
  corner that contains `(47,30)`.

### 3.2 The two identically degenerate families (proved, infinite)

* `m == 0 (mod N)`: `x = y = 1`, `Q = (1-4)(1-0) = -3`, so
  `chi(Phi) = chi(-3)` at every `lam`.  Constant for every `p`.
  (This is the old stratum A, `r = 0`.)
* `m == 1 (mod N)`: `Q(lam, 1-lam) = (1 - 1)(1 - (2lam-1)^2) = 0`
  identically, so the census is total collapse `N0 = p-2`.
  (Old stratum B, `r = 2`.)

No other `(k,c)` occurring in the `p < 4000` scan degenerates identically: for
every one of them the square-class computation of 3.3/3.4 returns a
non-constant square class, so Theorem 3's finiteness alternative applies.
That no *further* `(k,c)` degenerates is **conjectured**, not proved -- a
general degeneracy criterion would need the divisor of `Q` on `Gamma_{k,c}`
for all `(k,c)`, which is mystery-ledger item 6.

### 3.3 The power-residue families `lam^m in mu_n` (proved + Chebotarev)

Let `V_n = { Q(zeta^a, zeta^b) : a,b in Z/n } subset Z[zeta_n]` -- a *fixed*
finite set.  Computed (proved, symbolic):

```
V_1 = V_2 = {-3}
V_3 = V_6 = { -3, 0, 5+4w, 5+4w^2, 4+5w, 4+5w^2 }      (w = zeta_3)
V_4 = { -3, 5 }
V_8 = { -3, 3, 5, 1+4i, 1-4i, -1+4i, -1-4i }
|V_5| = 16, |V_7| = 28, |V_9| = 34   (no square-class collapse; see below)
```

**Theorem 4 (power-residue strata; proved for `p` large, verified-exact
otherwise).**  Suppose `n | N` and `lam^m in mu_n`.  If every cyclotomic
number `M_n(a,b)` is positive -- which holds once `p > c n^4` by the
Jacobi-sum bound of section 2 -- then the census is constant **iff all
non-zero elements of `V_n mod p` lie in a single square class.**  In
particular the family is infinite of positive density whenever that condition
is a satisfiable Frobenius condition in `Q(zeta_n, sqrt v : v in V_n)`, and
empty otherwise.

Explicit conditions:

| n | condition on `p` | primes `p < 4000` meeting it |
|---|------------------|------------------------------|
| 1, 2 | none (`chi(Phi) = chi(-3)` for every `p`) | all 548 |
| 3, 6 | `3 \| p-1` and `4+5w`, `5+4w` both squares mod `p` (`chi(-3) = +1` is then automatic) | 64 |
| 4 | `4 \| p-1` and `chi(-3) = chi(5)`, i.e. `chi(-15) = +1` | 126 |
| 8 | `8 \| p-1` and `chi(3) = chi(5) = chi(1+4i) = chi(1-4i)` (`chi(-1) = chi(2) = +1` are automatic) | 11 |
| 5, 7, 9, 10, 11, 12 | unsatisfiable -- `V_n` never collapses to one square class | 0 |

(The `n = 3` and `n = 8` rows contribute two constant `r` per prime, `n = 4`
one, which is why the scan of 3.5 counts 128, 126 and 22 strata.)

**Verified-exact (`cells 12 1200`).**  For every `n <= 12` and every prime
`p < 1200` with `n | p-1`, the biconditional "census constant iff `V_n` in one
square class" holds, with exactly four exceptions -- `(n,p) = (3,7)`,
`(9,73)`, `(10,11)`, `(12,13)` -- all of them in the small-`p` regime
`p < n^4` where some cyclotomic number vanishes and the empty cells relax the
condition.  Those four are not counterexamples to Theorem 4; they are the
reason its hypothesis is there, and `(9,73)` is exactly the sporadic
`(p,r) = (73,16)` seen from the cell side.

### 3.4 The fixed-exponent families `m == c (mod N)` (proved, all finite)

Here the census *is* the Frobenius trace on the single curve
`y^2 = sqcl(G_{2c})` over `Q`; the square-class degree `D` and genus `g` are
computed symbolically, and Theorem 3 gives the bound.  Members below the
bound, by direct census (`fixedm 9`), restricted to `p-1 > 2|c|` so that `c`
really is the least residue:

| c | deg sqcl | genus | Weil bound on p | complete member list |
|----|----|----|------|-------------------------------|
| -9 | 72 | 35 | 5192 | none |
| -8 | 60 | 29 | 3608 | (47,30) |
| -7 | 56 | 27 | 3144 | none |
| -6 | 48 | 23 | 2312 | (23,10) |
| -5 | 36 | 17 | 1304 | (17,6), (23,12) |
| -4 | 32 | 15 | 1032 | (17,8), (19,10) |
| -3 | 24 | 11 | 583 | (17,10) |
| -2 | 12 | 5 | 151 | (17,12) |
| -1 | 8 | 3 | 70 | (7,4), (11,8), (13,10), (19,16) |
| 2 | 2 | 0 | 8 | (7,4) |
| 3 | 6 | 2 | 42 | (17,6) |
| 4 | 6 | 2 | 42 | (11,8), (17,8) |
| 5 | 14 | 6 | 203 | (13,10), (17,10), (19,10), (23,10) |
| 6 | 18 | 8 | 331 | (17,12), (23,12) |
| 7 | 18 | 8 | 331 | (61,14) |
| 8 | 26 | 12 | 683 | (19,16), (73,16) |
| 9 | 30 | 14 | 907 | none |

No prime dividing the discriminant of the square-class model exceeds its own
family's Weil bound, so each row is a complete list -- **proved**, not merely
searched.  The genus column reproduces the genus law
`2|c| - 4 - 2[|c| == 1 mod 3]` (e.g. `c = 7` gives 8, `c = 4` gives 2),
which is a consistency check on the whole reduction.

Overlaps between rows are expected and real: a given `(p,r)` can sit in
several families, because `r` has two `m`-lifts and `m` has several small
representatives mod `N`.  `(17,6)` for instance is both `m == 3` and
`m == -5`.

### 3.5 The complete classification, `5 <= p < 4000`

`scan 4000` tests **every** even `r` in `[0,p-2]` at **every** prime
`5 <= p < 4000` -- an exhaustive enumeration, not a sample -- and tags each
constant stratum by its cheapest `(k,c)` reduction (cost `k(1+|c|)`, a proxy
for the genus of `D_{k,c}`).  Result (verified-exact):

| (k,c) | count | shape | members |
|-------|-------|-------|---------|
| (1,0) | 548 | `lam^m = 1`, `chi = chi(-3)` | every `p` |
| (1,1) | 548 | `Q == 0`, total collapse | every `p` |
| (3,0) | 128 | `lam^m in mu_3` | Theorem 4, `n = 3` |
| (4,0) | 126 | `lam^m in mu_4` | Theorem 4, `n = 4` |
| (8,0) | 22 | `lam^m in mu_8` | Theorem 4, `n = 8` |
| (1,-1) | 4 | fixed curve `C_1` | (7,4), (11,8), (13,10), (19,16) |
| (1,-2) | 1 | fixed curve `C_2` | (17,12) |
| (1,3) | 1 | fixed curve `C_3` | (17,6) |
| (1,-3) | 1 | fixed curve `C_3` | (17,10) |
| (1,-4) | 1 | fixed curve `C_4` | (19,10) |
| (1,5) | 1 | fixed curve `C_5` | (23,10) |
| (1,-5) | 1 | fixed curve `C_5` | (23,12) |
| (1,7) | 1 | fixed curve `C_7` | (61,14) |
| (1,8) | 1 | fixed curve `C_8` | (73,16) |
| **(3,-1)** | **1** | **Fermat cubic** | **(47,30)** |

**Theorem 5 (classification; proved for the families, verified-exact and
complete for `p < 4000`).**  Every constant-character stratum is
(i) one of the two identically degenerate families of 3.2, or
(ii) a power-residue family of 3.3 with `n in {1,2,3,4,6,8}`, or
(iii) a member of a finite family of 3.4 / the Fermat-cubic family of
section 4, each of which is closed by an explicit Weil bound and exhaustively
listed.  For `5 <= p < 4000` the list above is complete.

**Reconciliation with the named strata of the modular-structure report**
(verified-exact, `scan 300` reproduces its counts):

| old name | old description | `(k,c)` here | count `p < 300` (old / new) |
|----------|-----------------|--------------|------------------------------|
| A | `r = 0` | `(1,0)` | 61 (incl. `p=3`) / 60 |
| B | `r = 2` | `(1,1)` | 60 / 60 |
| A* | `r = -2` | `(1,-1)` | 3 / 4 (adds `(7,4)`, which is also stratum G) |
| C | `r = (p-1)/2` | `(4,0)`, i.e. `lam^m in mu_4` | 14 / 14 |
| G | `r = (p-1)/2 + 1` | `(1,-1)` at `p=7`, `(1,-4)` at `p=19`, `(1,-5)` at `p=23` | 3 / 3 |
| H | `r = (p-1)/2 + 2`, i.e. `(17,10)` | `(1,-3)` | 1 / 1 |
| "other" (20 rows) | `mu_3`, `mu_4`, and 5 unexplained | `(3,0)` 10, `(8,0)` 4, `(1,c)` 5, `(3,-1)` 1 | 20 / 20 |

So the "other" column dissolves completely: ten rows are the `mu_3` family,
four the `mu_8` family, five are fixed-exponent sporadics on the curves
`C_2, C_3, C_5, C_7, C_8`, and the last one is `(47,30)`.  The old theorems A,
B, C, G, H are the corners of one reduction rather than five separate
phenomena, as the modular-structure report conjectured.

**What is *not* proved.**  There is no unconditional finiteness statement
covering all `(k,c)` at once: as `p` grows the cheapest reduction of a random
`m` has `k|c|` of order `p`, and the Weil bound is then vacuous.  The honest
general statement is the contrapositive: *a constant census at `(m,p)` forces
`m/N` to admit no rational approximation `c/k` with `k(1+|c|)` small compared
with `sqrt p`*; combined with the exhaustive scan this closes the range
`p < 4000` but not the general case.  See the mystery ledger.

---

## 4. `(p,r) = (47,30)` settled (task 4)

### 4.1 The mechanism, out of the formula

`p = 47`, `N = 46 = 2 * 23`, `r = 30`, so `m = 15` (or the other lift
`m = 38`).  `gcd(15,46) = 1`, so `lam -> lam^15` is a bijection of `F_47^*`
and the map `lam -> (lam^m, (1-lam)^m)` is injective (`fermat`/`p47` verify
this directly).  The reduction of section 3.1 at `k = 3`:

```
3 * 15 = 45 == -1 (mod 46)      =>   (k,c) = (3,-1).
```

Put `xi = 1/x = lam^{-15}`, `eta = 1/y`.  Then `xi^3 = lam`, `eta^3 = 1-lam`,
hence

```
xi^3 + eta^3 = 1        -- the Fermat cubic.
```

The census becomes a character sum over its `F_47`-points:

```
S = sum over { (xi,eta) : xi^3+eta^3 = 1, xi eta != 0 }
      chi( (xi eta + xi + eta)(xi eta - xi - eta)(xi eta + xi - eta)(xi eta - xi + eta) )
  = sum chi( (e2^2 - e1^2)(e2^2 - e1^2 + 4 e2) ),   e1 = xi+eta, e2 = xi eta.
```

Both identities are verified symbolically over `Q(xi,eta)` (`fermat`), and
the sum is verified numerically to equal the census bias `-39` at `p = 47`
(`p47`).  Nothing here was read off the data: `(k,c) = (3,-1)` is what the
minimisation of section 3.1 returns for `(47,30)`, and it is the *only*
stratum in the whole `p < 4000` scan whose cheapest reduction has `k > 1` and
`c != 0`.

The base curve is genus 1 with `j = 0`; because `47 == 2 (mod 3)`, cubing is a
bijection of `F_47^*`, the cubic is **supersingular**, and it has exactly
`p+1 = 48` points, of which 45 are the ones the census uses (verified).  That
supersingularity is what makes the reduction lossless: the map
`lam -> (xi,eta)` is a bijection, not a `3`-to-`1` cover.

### 4.2 Why the family is finite -- and complete

The zero divisor of `P = prod (xi eta +- xi +- eta)` on the cubic: each of the
four conics meets the cubic in 6 points; the four sextic resultants are
squarefree and pairwise coprime (verified symbolically), so there are 24
distinct simple zeros.  Homogenising, `P = N/Z^8` and the line `Z = 0` meets
the cubic in three simple points at which `N = (xi eta)^4 != 0`, so all poles
have even order 8 and are unramified.  Riemann-Hurwitz:

```
2 g_D - 2 = 2 (2 g_Gamma - 2) + B = 0 + 24     =>   g_D = 13.
```

Weil, with `g_Gamma = 1`:

```
p - 2 - z <= 28 sqrt(p) + 28,  z <= 24    =>    p <= 889.
```

The primes at which the 24 zeros could collide (so at which the genus argument
would need care) are `{2,3,5,17,19,73,2251}`; only `2251` exceeds the bound,
and `2251 == 1 (mod 3)`, so `3m == +-1 (mod p-1)` has no solution there and the
family is empty at `2251` for a trivial reason.

The same bad-prime check was run for every fixed-exponent family of 3.4: the
discriminants of the square-class models are `127`-smooth (largest prime
factor `127` at `c = -6` and `c = 8`, `73` at `c = -8`, `61` at `c = -9`), so
no bad prime of any family exceeds that family's Weil bound and every member
list in 3.4 is complete.

**Theorem 6 (proved + verified-exact).**  The stratum `3m == +-1 (mod p-1)`
has exactly three members:

```
(p,r) = (17,6)   with 3m = +1,
(p,r) = (17,10)  with 3m = -1,
(p,r) = (47,30)  with 3m = -1.
```

Exhaustive census over every `p < 1088` with `p == 2 (mod 3)` confirms the
list, and the Weil bound `p <= 889` proves there is nothing beyond it.

### 4.3 Verdict

`(47,30)` is **not** genuinely isolated and **not** the seed of an infinite
family.  It is the largest and last member of a new *finite* family -- the
Fermat-cubic stratum -- which also contains the two `p = 17` points that the
previous classification had filed under separate `(n,j)` labels.  The
requested "next member" prediction therefore has a definite answer: **there is
none, and that is a theorem, not a search result.**

Two further closed descriptions of the same point, each an independent
confirmation:

* `m == -8 (mod p-1)`: the fixed-exponent family of 3.4 with `c = -8`, genus
  29, Weil bound `p <= 3608`; `(47,30)` is its unique member.
* `m == 15 (mod p-1)`: the fixed curve `C_15`, genus 26, Weil bound
  `p <= 2916`, inside the exhaustive scan range; again unique.

The Fermat-cubic description is the cheapest of the three (genus 13 against
26 and 29) and is the one that explains the point rather than merely bounding
it: `(47,30)` and the two `p = 17` points are the same phenomenon.

A bookkeeping note, so the tables do not read as a contradiction: at `p = 17`
the *cheapest* reduction of `(17,6)` and `(17,10)` is the fixed-exponent one
(`m == 3` and `m == -3`, genus 2 and 11), which is why the scan of 3.5 tags
them `(1,3)` and `(1,-3)` rather than `(3,+-1)`.  Membership in several
families is normal and is what makes the classification robust: at `p = 17`
both the fixed-exponent and the Fermat-cubic bound are available, at `p = 47`
only the Fermat-cubic one is sharp.

**Independent-engine check.**  `ergodis` reduces `G_r` mod `lam^p - lam` to an
integer-coefficient polynomial and runs one `polynomial_census` request per
stratum on the Ergodis kernel
(`ergodis::character_sum::PrimeQuadraticCharacter`).  All six exceptional
strata `(47,30), (17,6), (17,10), (23,12), (61,14), (73,16)` agree exactly
with the Python census after removing the `lam in {0,1}` contributions.

---

## 5. The geometric statement (task 5)

**The pullback.**  Let `T = G_m^2` be the two-dimensional torus with
coordinates `(X,Y)`, `L subset T` the line `X + Y = 1` minus its two boundary
points, `[r] : T -> T` the `r`-th power map, and `S -> T` the fixed double
cover `w^2 = F(X,Y) = (1-X-Y)^2 - 4XY`.  Then, for every `m` and every `p`,

```
C_m  =  L  x_{[r], T}  S,           r = 2m,
```

i.e. the tower `{C_m}` is the pullback of **one** fixed double cover along the
power map, restricted to **one** fixed line.  Equivalently, on the `u`-line
the same statement reads through Dickson polynomials: with
`s_m = lam^m + (1-lam)^m = D_m(1,u)`, the descent quotient
`D_1 : y^2 = 1 - s_m^2` is the pullback of the fixed conic-cover
`y^2 = 1 - v^2` along the degree-`m` Dickson map `u -> D_m(1,u)`.  "Dickson
pullback" and "power map" are the same statement in the two coordinates.

In sheaf language, the census is `-Tr(Frob_p | H^1_c(A^1, [r]^* L_chi(F)))`,
and the whole stratification is the statement that a Kummer pullback
`[r]^* (fixed sheaf)` degenerates exactly when `r` is close to a small
rational multiple of `p-1`, which is section 3.1.

**Exact relationship with the modular / newform frame.**  The modular results
of the previous reports (conductors 90 and 14 at `m = 3,4`; the split
quotients at `m = 5,6,7`; the `USp(4)` and `USp(8)` Sato-Tate verdicts at
`m = 8`) are statements about **one fixed curve `C_m` over `Q` and growing
`p`**.  In the language above they are exactly the corner `k = 1` of Theorem
3: `m == c (mod p-1)` with `c = m` fixed, which requires `p - 1 > 2m`.  So:

* For `p > 2m` the two frames describe the same object.  The newform gives the
  exact trace; the reduction gives the bound `|S| <= (4m-8) sqrt p + O(1)`.
* Constancy is possible in that overlap only while `p` is small compared with
  `g(C_m)^2`, i.e. in the window `2m < p <~ 16 m^2`.  Every `k = 1` sporadic
  in the table of 3.4 lives in that window, `(73,16)` (`m = 8`,
  `2m = 16 < 73 < 683`) included.
* For `p < 2m` the fixed-`m` frame simply does not apply -- `m` reduces and
  the census is governed by a *different, smaller* curve.  That is the regime
  the power-map frame owns, and it is where the power-residue families of 3.3
  live (there `m` is a large multiple of `(p-1)/n`).
* What the modular frame adds that the character-sum frame cannot: the exact
  value of the trace (hence the exact bias, its congruences, and the
  supersingular locus), the level and conductor, and the Sato-Tate law.  What
  the character-sum frame adds that the modular frame cannot: a *uniform*
  statement across all `m` at fixed `p`, and -- crucially -- a **smaller**
  curve than `C_m` whenever `m` has a good rational approximation mod `p-1`.
  `(47,30)` is the sharp illustration: the modular frame sees genus 26 and
  bounds `p <= 2916`; the Fermat-cubic frame sees genus 13 and bounds
  `p <= 889`, and only the second one is an explanation.

No hand-waving is needed about the overlap: it is the single condition
`p - 1 > 2m`, and both frames are Frobenius traces on curves, differing only
in which curve.

---

## 6. Open observations

Each item states its exact searched range.

1. **The `u`-line census has period `lcm(p-1,p+1)` (verified-exact,
   `p <= 23`).**  `sum_{u in F_p} chi(1 - D_m(1,u)^2)` has minimal period
   exactly `lcm(p-1,p+1)` in `m` -- `12, 24, 60, 84, 144, 180, 264` at
   `p = 5,...,23`, with zero failures of that period over two full periods.
   Reason: `1 - 4u` a non-square puts `lam` in `F_{p^2}` on the **non-split**
   torus, where `lam^m` has period `p+1`.  The `lam`-line census only sees the
   split torus, hence `(p-1)/2`.  This is the correct home for the descent
   quotients `D_1, D_2`, which live on the `u`-line, and it predicts a second
   family of exceptional strata indexed by `r mod (p+1)`, invisible on the
   `lam`-line.  Not yet searched.
2. **Density predictions for the power-residue families (conjectured).**
   Theorem 4 turns each family into a Chebotarev condition, so the densities
   should be exactly `1/[K_n : Q]` times the number of admissible Frobenius
   classes.  Measured frequencies over `p < 4000` (128 for `n = 3`, 126 for
   `n = 4`, 22 for `n = 8`) are consistent with `~1/8`, `~1/4`, `~1/16` but
   the exact class counts were not computed.
3. **The `(k,c)` cost function is a proxy, not an invariant.**  Ordering
   reductions by `k(1+|c|)` reproduces the genus ordering in every case that
   occurs, but the genuine invariant is `g(D_{k,c})`, and computing it in
   general (rather than case by case) needs the fibre-product genus formula
   for `Gamma_{k,c}`.  This is the one place where the derivation is
   case-by-case rather than uniform.
4. **The fixed-exponent sporadics sit at the bottom of their Weil windows**
   (verified-exact, table of 3.4): each family is closed at
   `p <= P(c) ~ 16 c^2` but its members occur at `p` of order `|c|` --
   `(17,+-3)`, `(17,-2)`, `(19,-4)`, `(23,+-5)` -- with `(61,7)` and `(73,8)`
   the only members above `4|c|`.  No mechanism proposed.  The plausible
   reading is that an extremal-trace coincidence is likeliest just above the
   applicability threshold `p > 2|c|`, where the Weil interval is widest
   relative to the number of available `lam`; nothing here proves it.
5. **`(47,30)`'s six zeros all lie on one conic (verified-exact).**  The 24
   geometric branch points of the Fermat-cubic cover are the intersections of
   the cubic with the four conics `xi eta +- xi +- eta = 0`, six each.  At
   `p = 47` exactly six are `F_47`-rational, and all six lie on the single
   conic `xi eta - xi - eta = 0`, i.e. `(xi-1)(eta-1) = 1`: that conic's
   sextic splits completely mod 47 while the other three have no rational
   root.  So the presence of zeros at `(47,30)` -- absent at the `(6,23)`
   collapse -- is a total-splitting statement about one fixed sextic at one
   prime, not a feature of the stratum.

---

## Mystery ledger

| # | Surprising / unexplained | settled by this pass? | evidence gap / owner |
|---|--------------------------|-----------------------|----------------------|
| 1 | `(47,30)`: the one constant-character stratum with no short-character-sum reduction (prior report) | **Settled.**  It is the `3m == -1` Fermat-cubic stratum; the family is finite with exactly three members, proved by Weil (`p <= 889`) plus exhaustive census | none -- closed |
| 2 | Why the "other" column of the `p <= 300` table had 20 entries with no common shape | **Settled.**  All are `(1,c)` fixed-exponent or `(k,0)` power-residue strata; the classification of section 3.5 accounts for every one | none -- closed |
| 3 | Whether the exceptional strata are finite or infinite in number | **Partly settled.**  Two identically degenerate infinite families, three infinite power-residue families (Chebotarev), and ten finite families, each with an explicit bound | no unconditional statement covering all `(k,c)` simultaneously; needs an effective lower bound on `k(1+\|c\|)` for the best approximation of `m/N`.  Owner: a successor task |
| 4 | Whether the `p+1` (non-split torus) side carries its own strata | **Opened, not settled.**  The `u`-line census has period `lcm(p-1,p+1)`, verified `p <= 23` | no scan of `r mod (p+1)` strata has been run.  Owner: successor |
| 5 | The exact densities of the `mu_3`, `mu_4`, `mu_8` families | **Not settled.**  Conditions are explicit; the Galois group degrees are not computed | needs `[Q(zeta_n, sqrt V_n) : Q]` and the admissible-class count |
| 6 | Whether the reduction ordering `k(1+\|c\|)` is canonical | **Not settled.**  It agrees with the genus ordering on every occurring case | needs a general genus formula for `D_{k,c}` |
| 7 | The `m = 3` bias `== 1 (mod 4)` rigidity (inherited open item) | **Not addressed** here | belongs to the `E_1` torsion argument flagged in the tt-pass frontier, not to this derivation |

No manufactured mysteries: items 1 and 2 are genuinely closed, item 3 is
closed in the computed range and open in general, and items 4-6 are new
questions this derivation created rather than old ones it failed.

---

## Ergodis interface notes

**Fit.**  `polynomial_census` on the reduced polynomial `G_r mod (lam^p - lam)`
is an exact fit for cross-checking any single `(p,r)` census, and was used for
all six exceptional strata (section 4.3).  Reducing the exponent first is
essential: the naive `G_r` has degree `2r` and the kernel wants a polynomial
of degree `< p`.

**Misfit (interface-improvement notes, C1013 card section 7 discipline).**

1. No multiplicative characters of order `> 2`.  The master formula of
   section 2 is a pairing of Jacobi sums of characters of order dividing `e`;
   Ergodis can express none of them.  A typed `JacobiSum(order, chi_1, chi_2)`
   or a general `MultiplicativeCharacter<n>` census would make section 2
   replayable on the kernel.
2. No subgroup-restricted or coset-restricted sums.  The cyclotomic numbers
   `M_n(a,b)` of section 3.3 are exactly "count `lam` with `ind(lam) == a`,
   `ind(1-lam) == b (mod n)`"; there is no way to ask for that.
3. No two-variable or curve-supported censuses.  The Fermat-cubic sum of
   section 4.1 is a character sum over `Gamma(F_p)`, not over `F_p`; it had to
   be done in Python.
4. No square-class/squarefree-part primitive, so the fixed-exponent genus
   table of 3.4 was computed in sympy.

Everything else (all direct censuses, all scans) was done in Python because
the scan is over `~p/2` polynomials per prime and the per-request reduction
cost would dominate; that is a shape mismatch, not a missing primitive.

---

**Status: complete.**
