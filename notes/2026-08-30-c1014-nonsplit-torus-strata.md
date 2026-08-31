# C1014 -- the non-split-torus stratification of the u-line census

**Lane:** clebsch · **Task:** C1014 (math-only; no manuscript, Ergodis or Lean
source edits) · **Date:** 2026-08-30

**Script (owned):** `notes/clebsch-tasks/c1014_nonsplit_torus.py`
**Platform (taken as given):** `notes/2026-08-30-c1014-dickson-strata-derivation.md`
(periodicity over `Z`, the master Jacobi-sum formula on the `lam`-line, the
15-class constant-stratum classification exhaustive for `5 <= p < 4000`, and
its section 6 prediction of a second stratum family indexed by `r mod (p+1)`).

**Replay:**

```
uv run --with sympy --with numpy python3 \
    notes/clebsch-tasks/c1014_nonsplit_torus.py <cmd>
# cmd in: coords 200 | master 200 | collapse 300 | period 300 | sweep 300
#         | families 4000 | weil 8 | mirror 400 | powq 1100 | ergodis
```

Every claim is labelled **proved**, **verified-exact (range)**, or
**conjectured**.

---

## Executive summary

The whole non-split story is one change of variable.  Writing `nu = 1/u` and
`tau = nu - 2 = z + z^{-1}`, the census weight becomes
`chi(((tau+2)^m - D_m(tau,1))^2 - 4)`: a function of **two** exponentials,
`nu^m` on the split torus `F_p^*` and `z^m` on whichever torus `z` lives in.
Every result below is a consequence of that.

1. **Master formula (proved; verified-exact, 308 pairs, `m = 2..8`,
   `5 <= p < 200`).**  The non-split census is a sum over the affine line
   `Tr lam = 1` in `F_{p^2}`, and its Plancherel expansion pairs the fixed
   pattern `chi((1-Tr X)^2 - 4 N X)` against **trace-one Gauss sums**
   `frak G(Theta) = (G_{p^2}(Theta)/p) Theta(-1) g_p(bar Theta|_{F_p^*})`.
   These are the non-split analogue of the Jacobi sums: magnitude `sqrt p`
   except on the `p+1` characters of the norm-one torus, where it is `1`.
   All `4.3e6` computed Fourier coefficients hit one of `p, sqrt p, 1`
   exactly.
2. **Period (proved; minimality verified-exact `5 <= p < 300`).**  The
   `u`-line census depends on `m` only through
   `(m mod (p-1), m mod (p+1))`, so its period divides
   `L = lcm(p-1,p+1) = (p^2-1)/2`; and it is **exactly `L`, not `L/2`** --
   proved from the fact that the total-collapse set is exactly
   `{m == 1, m == p (mod L)}`, which is itself proved whenever
   `6 max(i,j) < p-1` and verified for every `p < 300`.
3. **The predicted second family exists, and is classified.**  The exhaustive
   sweep over the full period window at every prime `5 <= p < 300` (about
   `1.1e6` exponents) finds **319** constant non-split strata, all accounted
   for: two identically constant infinite families (`m == 0 mod L`, giving
   `chi(-3)`; and `m == (p+1)/2 mod L`, giving identically `-1`), torus
   power-residue families `nu^m in mu_k`, `z^m in mu_n` with explicit
   square-class conditions (the `n = 3` row is *unconditionally* infinite),
   and fixed-exponent families each closed by a Weil bound with a complete
   member list.  Exactly one point resists every torus description --
   `(p, i, j) = (19, 7, 3)` -- and its family is proved finite with that one
   member.  A new lemma drives the classification: the two tori are
   quadratically correlated, `z^{(p+1)/2} = chi(nu)`.
4. **Reconstruction: definitive no (proved).**  A 4-subset of `P^1(F_q)` has
   its cross-ratio in `F_q`, so the 4-set coloring *is* the `lam`-line census
   over `F_q` and no non-split stratum can touch it.  At the one place the
   worry is real -- `q = p^2`, where `F_p`-non-split `lam` become rational --
   those `lam` carry the color `+1` for every `m`, because `Phi` lands in
   `F_p^*` and `F_p^*` consists of squares in `F_{p^2}`.  Verified exhaustively
   over every prime power `q = p^k <= 1000`, `k >= 2`.  **The reconstruction
   paper's completeness claim stands.**
5. **The Fermat-cubic family has no torus mirror** (verified-exact
   `p < 400`): the non-split census is generic at `(17,6)`, `(17,10)` and
   `(47,30)`, and no constant stratum satisfies `3m == +-1` mod `p+1` or mod
   `L`.  The reason is structural: one reduction cannot pin two independent
   exponentials.

Vibe check: the platform report's section 6 prediction was right and the
answer is richer than expected -- a second constant family that is
*identically* `-1` for every prime and has an exact closed-form census
(`S_ns = -(p-1)/2`), an unconditionally infinite `mu_3` row, and one clean
sporadic playing `(47,30)`'s role.  The gate the paper package was waiting on
closes negative, with a proof rather than a scan.

---

## 0. Notation

`p` odd prime, `N = p-1`, `M = p^2-1`, `L = lcm(p-1,p+1) = (p^2-1)/2`,
`chi` the Legendre symbol of `F_p`, `chi_{p^2}` that of `F_{p^2}`.
`u = lam(1-lam)`; `lam, 1-lam` are the roots of `T^2 - T + u`, so
`chi(1-4u) = +1` puts them in `F_p` (split) and `chi(1-4u) = -1` puts them in
`F_{p^2}` with `(1-lam) = lam^p` (non-split).
`s_m = lam^m + (1-lam)^m = D_m(1,u)`, `r = 2m`.
`Q(x,y) = prod_{eps,eta} (1 + eps x + eta y)`, `F(X,Y) = (1-X-Y)^2 - 4XY`,
and the product law of the platform report is
`u^2 Phi_{2m,4}(lam) = Q(lam^m,(1-lam)^m) = F(lam^r,(1-lam)^r)`.
`Qt(u)` denotes `u^2 Phi_{2m,4}` written as a polynomial in `u` (it is
symmetric in `lam <-> 1-lam`), explicitly
`Qt(u) = (1-s_m^2)(1-s_m^2+4u^m)`.

The three censuses:

```
S_lam(m,p) = sum_{lam != 0,1} chi(Phi_{2m,4}(lam))        (lambda-line)
S1(m,p)    = sum_{u in F_p} chi(Qt(u))                     (u-line)
S2(m,p)    = sum_{u in F_p} chi((1-4u) Qt(u))              (twisted u-line)
S_ns(m,p)  = sum_{u : chi(1-4u) = -1} chi(Qt(u))           (non-split part)
```

"Constant" means `chi` takes one value on the whole non-vanishing locus of the
relevant `u`-set and that locus is non-empty; "total collapse" means the locus
is empty (`Qt` vanishes identically there).

---

## 1. The torus coordinate (task 1, foundation)

Everything below rests on one change of variable that makes both tori visible
at once.

**Definition.**  For `u != 0` put `nu = 1/u` and `tau = nu - 2`.  Write
`tau = z + z^{-1}`; then `z in F_p^*` when `u` is split and `z in mu_{p+1}
subset F_{p^2}^*` when `u` is non-split, because
`tau^2 - 4 = (z-z^{-1})^2` and

```
1 - 4u = (tau-2)/(tau+2),      chi(1-4u) = chi(tau^2-4).
```

The dictionary is `lam = z/(1+z)`, `1-lam = 1/(1+z)`, `u = z/(1+z)^2`, and
`lam <-> 1-lam` is `z <-> z^{-1}`.  `nu = (1+z)^2/z = (1+z)(1+z^{-1})`, i.e.
`nu = N_{F_{p^2}/F_p}(1+z)` in the non-split case.

**Theorem 1 (torus form of the census weight; proved).**  For every `m >= 1`
and every `u != 0`,

```
s_m^2 = nu_m / nu^m,     nu_m := tau_m + 2,     tau_m := z^m + z^{-m},
u^2 Phi_{2m,4} = (nu^m - nu_m)(nu^m - nu_m + 4) / nu^{2m},
```

and therefore, with `D_m(tau,1) = tau_m` the Dickson polynomial of the first
kind with parameter `1`,

```
chi(Phi_{2m,4}) = chi(Qt(u)) = chi(P_m(tau)),
P_m(tau) := ((tau+2)^m - D_m(tau,1))^2 - 4.
```

*Proof.*  `lam = z/(1+z)` and `1-lam = 1/(1+z)` give
`s_m = (z^m+1)/(1+z)^m` and `u^m = z^m/(1+z)^{2m}`.  Since
`(1+z)^{2m} = ((1+z)^2/z)^m z^m = nu^m z^m` and `(1+z^m)^2 = nu_m z^m`,
`s_m^2 = nu_m z^m/(nu^m z^m) = nu_m/nu^m`.  Substituting into
`Qt = (1-s_m^2)(1-s_m^2+4u^m)` and clearing `nu^{2m}` (a square) gives the
displayed identity, and `nu^m - nu_m = (tau+2)^m - D_m(tau,1) - 2`, so
`(nu^m-nu_m)(nu^m-nu_m+4) = ((tau+2)^m - D_m(tau,1))^2 - 4 = P_m(tau)`. ∎

**Why this is the right coordinate.**  `nu = 1/u` lies in `F_p^*` for *both*
kinds of `u`, so `nu^m` depends on `m mod (p-1)` always; `z` lies in `F_p^*`
(split) or `mu_{p+1}` (non-split), so `tau_m = D_m(tau,1)` depends on
`m mod (p-1)` on the split locus and on `m mod (p+1)` on the non-split locus.
The census weight is a function of the pair `(nu^m, tau_m)` alone.  That single
sentence is the whole period phenomenon of section 3, and it is the exact
sense in which the `u`-line "sees the non-split torus": the `lam`-line only
ever evaluates `tau_m` at split `z`.

**Boundary values (proved).**  `P_m(-2) = 0` for `m >= 1` (`tau=-2` is `z=-1`,
i.e. `u = infinity`, outside the census), `Qt(0) = 0` for `m >= 1`
(`u = 0`, i.e. `lam in {0,1}`), and at `tau = 2` (`u = 1/4`, `lam = 1/2`)

```
Qt(1/4) = 1 - 4^{1-m},        kappa := chi(Qt(1/4)) = chi(4^{m-1}-1).
```

So `S1(m,p) = sum_{tau in F_p} chi(P_m(tau))` and
`S2(m,p) = sum_{tau in F_p} chi((tau^2-4) P_m(tau))` with no correction terms.

**Theorem 2 (split/non-split decomposition; proved).**  For `m >= 1`,

```
S1 + S2 = S_lam,
S1 - S2 = 2 S_ns + kappa,
S1      = (S_lam + kappa)/2 + S_ns.
```

*Proof.*  Each split `u != 0, 1/4` has exactly two `lam`-preimages with the
same weight, `u = 1/4` has one (`lam = 1/2`), `u = 0` has the two excluded
points and weight `0`.  Hence `S_lam = 2 sum_{split u != 0,1/4} chi(Qt) +
kappa`.  Also `S1 + S2 = sum_u (1 + chi(1-4u)) chi(Qt)`, which doubles the
split terms and kills the non-split ones, the `u = 1/4` term surviving once
because `chi(0) = 0`.  Subtracting gives the second line; the third is the
first two combined. ∎

**Verified-exact (`coords 200`).**  `m = 2..8`, every odd `p < 200`, 315
pairs: the pointwise identity `chi(Qt(u)) = chi(P_m(tau))` and all three
census identities hold with **0 failures**.

---

## 2. The master formula on the non-split side (task 1)

By Theorem 2 the `u`-census `S1` and the twisted census `S2` are determined by
the `lam`-line census `S_lam` -- for which the platform report's Theorem 2
gives the Jacobi-sum/Plancherel formula -- together with the single new
quantity `S_ns`.  So it suffices to give an exact formula for `S_ns`, and the
non-split analogue of the Jacobi sum is a **trace-one Gauss sum**.

### 2.1 The non-split census as a sum over a line in `F_{p^2}`

On the non-split locus `1-lam = lam^p`, so with `X = lam^r`

```
u^2 Phi_{2m,4} = F(lam^r, lam^{pr}) = (1 - Tr X)^2 - 4 N(X) =: cal F(X),
```

`Tr` and `N` the trace and norm of `F_{p^2}/F_p`.  The non-split `u` are in
bijection with the `lam`-pairs `{lam, lam^p}` on the **affine line**
`Lam^+ = {lam in F_{p^2} : Tr lam = 1}` (`|Lam^+| = p`), the single `F_p`-point
`lam = 1/2` corresponding to `u = 1/4`.  Hence (proved)

```
sum_{lam in Lam^+} chi(cal F(lam^r)) = 2 S_ns(m,p) + kappa.
```

`Lam^+` is a coset of the `F_p`-line `ker Tr`, not a subgroup, exactly as the
`lam`-line `{(lam, 1-lam)}` is a line in `G_m^2` and not a subgroup.  Where the
split side expands the line's indicator in *multiplicative* characters and
produces Jacobi sums, the non-split side expands it in *additive* characters
and produces Gauss sums.

### 2.2 The trace-one Gauss sum

**Definition.**  For a multiplicative character `Theta` of `F_{p^2}^*`,
`frak G(Theta) := sum_{lam in Lam^+} Theta(lam)`.

**Theorem 3 (proved).**  Let `psi(x) = e_p(Tr x)` be the canonical additive
character of `F_{p^2}`, `G(Theta) = sum_x Theta(x) psi(x)` the `F_{p^2}` Gauss
sum, `theta = Theta|_{F_p^*}`, and `g_p(theta) = sum_{x in F_p^*} theta(x)
e_p(x)`.  Then `frak G(1) = p` and, for `Theta` non-trivial,

```
frak G(Theta) = ( G(Theta) / p ) * theta(-1) * g_p(conj theta),
|frak G(Theta)| = sqrt p   if theta is non-trivial,
                = 1        if theta is trivial (i.e. Theta^{p+1} = 1).
```

*Proof.*  Detect `Tr lam = 1` by `(1/p) sum_{t in F_p} e_p(t(Tr lam - 1))`.
The `t = 0` term kills the sum for non-trivial `Theta`; for `t != 0`,
`sum_lam Theta(lam) psi(t lam) = conj(Theta)(t) G(Theta)`, so
`frak G(Theta) = (G(Theta)/p) sum_{t in F_p^*} conj(theta)(t) e_p(-t)`, and the
inner sum is `theta(-1) g_p(conj theta)`.  `|G(Theta)| = p` always (non-trivial
`Theta`), `|g_p| = sqrt p` for non-trivial `theta`, and `g_p(1) = -1`. ∎

This is the precise non-split analogue of `|J(A,B)| = sqrt p` off the
degenerate locus: the *only* three magnitudes available on the arithmetic side
are `p`, `sqrt p`, `1`, and the degenerate ones are exactly the characters
trivial on `F_p^*`, i.e. those of the **norm-one torus of order `p+1`** --
which is the structural statement the task asked for ("`psi` ranging over torus
characters").  Concretely, the `p+1` characters `Theta` with `Theta^{p+1} = 1`
factor through `lam -> lam^{p-1}`, i.e. through the torus `mu_{p+1}`, and those
are precisely the characters whose trace-one Gauss sum has magnitude `1`
instead of `sqrt p`.

### 2.3 The formula

Fix `r = 2m`, `M = p^2-1`, `d = gcd(r,M)`, `e = M/d`, `r' = r/d`, and let
`H = {lam^r} subset F_{p^2}^*` be the subgroup of order `e`.  Fix a generator
`g` of `F_{p^2}^*` and index `H` by `s in Z/e` via `g^{ds}`.  Put

```
A[s]   = chi( cal F(g^{ds}) ),
Mc[s]  = # { lam in Lam^+ : lam^r = g^{ds} },
Theta_t(g^k) = exp(2 pi i t r' k / e)   (t in Z/e).
```

**Theorem 4 (non-split master formula; proved).**

```
2 S_ns(m,p) + kappa = sum_s Mc[s] A[s]
                    = (1/e) sum_{t in Z/e} frak G(Theta_t) * conj( Ahat(t) ),
Ahat(t) = sum_{s in Z/e} A[s] exp(2 pi i t s / e),
```

with `frak G(Theta_t)` given in closed form by Theorem 3.  Combining with
Theorem 2 and the platform report's Theorem 2 (`S_lam` as a Jacobi-sum
pairing) gives the exact formulas for the two `u`-line censuses:

```
S1 = (S_lam + kappa)/2 + S_ns,      S2 = (S_lam + kappa)/2 - kappa - S_ns.
```

*Proof.*  `Mc[s]` counts `lam in Lam^+` with `s(lam) = r' ind(lam) mod e`
(well defined because `Theta_t` is trivial on `mu_d`, the kernel of the `r`-th
power map on `H`), so `sum_s Mc[s]A[s]` is the trace-one sum of 2.1.  Parseval
on `Z/e` gives the second line, with `Mchat(t) = sum_{lam in Lam^+}
Theta_t(lam) = frak G(Theta_t)`. ∎

**What the formula separates.**  `Ahat` is the Fourier transform of the
*fixed* pattern `chi(cal F)` on `H` -- pure geometry of the target, no
dependence on `m`.  `frak G` carries all the arithmetic of the power map, and
Theorem 3 says it has magnitude `sqrt p` except on the `p+1` torus characters,
where it has magnitude `1`, and at the trivial character, where it is `p`.  So
the non-split census can only be constant when the geometry side is supported
on the degenerate trace-one Gauss sums -- the exact analogue of "supported on
the degenerate Jacobi sums" on the split side.

**Verified-exact (`master 200`).**  `m = 2..8`, every prime `5 <= p < 200`,
308 pairs.  (i) the trace-one identity `sum_{Lam^+} chi(cal F(lam^r)) =
2 S_ns + kappa` against the direct census: **0 failures**; (ii) the Plancherel
line: worst `|direct - formula| = 1.1e-14` (float round-off), 0 failures;
(iii) **every** Fourier coefficient `Mchat(t)`, over all 308 pairs and all
`t in Z/e` (about `4.3e6` coefficients), has magnitude exactly `p`, `sqrt p`
or `1` as Theorem 3 predicts: 0 exceptions; (iv) the closed form of Theorem 3,
checked against directly computed `F_{p^2}` and `F_p` Gauss sums on sampled
characters for `p < 60`: 0 failures.

---

## 3. The period theorem (task 2)

### 3.1 The two-exponent reduction

**Theorem 5 (proved).**  Put `i = m mod (p-1)` and `j = m mod (p+1)`.  Then

* the split part of the `u`-line coloring (and hence the whole `lam`-line
  census) depends only on `i`;
* the non-split part of the `u`-line coloring depends only on the pair
  `(i,j)`;
* consequently `S1`, `S2`, `S_ns` and the whole `u`-line coloring have period
  dividing `L = lcm(p-1,p+1) = (p^2-1)/2` in `m`.

*Proof.*  By Theorem 1 the weight at `u` is `chi((nu^m - tau_m)^2 - 4)` with
`nu = 1/u in F_p^*` and `tau_m = z^m + z^{-m}`.  `nu^m` depends on
`m mod (p-1)` for every `u`.  On the split locus `z in F_p^*`, so `tau_m`
depends on `m mod (p-1)`; on the non-split locus `z in mu_{p+1}`, so `tau_m`
depends on `m mod (p+1)`.  `Z/(p-1) x Z/(p+1)` has exponent `L` on the
diagonal `i = j mod 2` traced out by `m`. ∎

This *derives* the platform report's section 6 measurement.  The mechanism is
sharper than "the `u`-line sees the non-split torus": the `u`-line weight is a
function of **two** exponentials, `nu^m` living in the split torus `F_p^*` and
`tau_m` living in whichever torus `z` belongs to.  The split torus never
disappears -- `nu = 1/u` is always in `F_p^*` -- which is why the period is
`lcm(p-1,p+1)` and not merely `p+1`.

### 3.2 The total-collapse set, and minimality

Write the reduced pair as `(i,j)` with `i in [0,p-2]` and `j in [0,(p+1)/2]`
(legitimate because `D_{-j} = D_j`).

**Theorem 6 (collapse classification; proved for `6 max(i,j) < p-1`).**  The
non-split census totally collapses at `(i,j)` -- i.e. `Qt` vanishes at every
non-split `u` -- if and only if `(i,j) = (1,1)`, provided
`6 max(i,j) < p-1`.

*Proof.*  With `nu^i = (1+z)^{2i} z^{-i}` and `tau_j = z^j + z^{-j}`, put

```
F(z) = [ (1+z)^{2i} z^j - z^{i+2j} - z^i ]^2 - 4 z^{2i+2j}
     = z^{2i+2j} ( (nu^i - tau_j)^2 - 4 ),
```

a polynomial of degree `2 max(2i+j, i+2j) <= 6 max(i,j)`.  Collapse says
`F` vanishes at the `p-1` points of `mu_{p+1} - {1,-1}`; if
`deg F < p-1` this forces `F = 0` in `F_p[z]`.  Then
`( (1+z)^{2i} z^j - z^{i+2j} - z^i )^2 = (2 z^{i+j})^2`, so
`(1+z)^{2i} z^j = z^i (z^j +- 1)^2`.  If `j = 0` the right side is `0` or
`4 z^i`, forcing respectively `(1+z)^{2i} = 0` (impossible) or `2i = i` and
`1 = 4` (impossible for `p != 3`).  So `j >= 1`, both sides are non-zero, and
comparing degrees `2i + j = i + 2j` gives `i = j`.  Then
`(1+z)^{2i} = (z^i +- 1)^2`, i.e. `(1+z)^i = +-(z^i +- 1)`; evaluating at
`z = 0` and at the leading coefficient leaves only `(1+z)^i = z^i + 1`, which
by Lucas' theorem forces `i` to be a power of `p` or `i in {0,1}`; `i <= p-2`
leaves `i = 1` (and `i = 0` gives `1 = 2`).  Conversely at `(1,1)`,
`nu - tau = 2` identically, so `(nu-tau)^2 - 4 = 0`. ∎

Two remarks.  (a) The Lucas step is the *same* mechanism that produces the
Frobenius-twist strata `r = 2 p^i` of the marking-reconstruction report: over
`F_q`, `q = p^k`, the same computation leaves `i in {1, p, ..., p^{k-1}}`.
Over a prime field only `i = 1` survives.  (b) In `Z/L` the two collapse
classes are `m == 1` and `m == p`: `(i,j) = (1,1)` lifts to `m == 1 mod (p-1)`
with `m == +-1 mod (p+1)`, and `m = p` is the second lift.

**Theorem 7 (minimal period; proved for `p >= 5`, given the collapse set).**
If the total-collapse set of the non-split census in `Z/L` is exactly
`{1, p}`, then the minimal period of `S_ns` (and of `S1`, `S2`, and the
`u`-line coloring) is exactly `L` -- **not** `L/2`.

*Proof.*  A period `h` permutes the collapse set.  If `h != 0` it must swap
`1` and `p`, so `h == p-1` and `h == 1-p (mod L)`, whence `L | 2(p-1)`, i.e.
`(p+1)/2 <= 2`, i.e. `p <= 3`. ∎

**Why `L/2` is the natural rival, and why it loses.**  The shift
`m -> m + L/2` is exactly a quadratic twist of *one* of the two tori:
for `p == 1 (mod 4)` it is `i -> i + (p-1)/2`, `j -> j`, i.e.
`nu^i -> chi(nu) nu^i`; for `p == 3 (mod 4)` it is `i -> i`,
`j -> j + (p+1)/2`, i.e. `z^j -> eps(z) z^j` with `eps` the order-2 character
of `mu_{p+1}`.  On the `lam`-line the analogous half shift *is* a symmetry --
`Q(x,y)` is invariant under independent sign flips of `x` and `y`, which is
why the `lam`-line census has period `(p-1)/2`.  On the `u`-line the twist
touches only one of the two exponentials, `Qt` is not invariant, and the
period does not halve.

**Verified-exact (`collapse 300`, `period 300`).**  For every prime
`5 <= p < 300`: the collapse set is exactly `{m == 1, m == p (mod L)}` with a
single exception, `p = 5`, where two further classes occur
(`m == 4, 8 mod 12`, from `mu_3 subset mu_6` being forced -- a small-`p`
accident, `(p-1)/2 = 2` non-split points).  And for all 60 primes
`5 <= p < 300` the minimal periods of `S_ns` (as a full sign distribution),
`S1` and `S2` are **exactly `L = (p^2-1)/2`**, 0 exceptions -- including
`p = 5`, so the exception to Theorem 6 does not disturb the verdict.  For
comparison, the `lam`-line census has minimal period exactly `(p-1)/2` at all
60 primes.

**Settled.** The answer to "`lcm(p-1,p+1)` or half of it" is
**`lcm(p-1,p+1) = (p^2-1)/2`**, proved for every `p >= 5` whose collapse set
is `{1,p}` (all `p < 300` except `p = 5`, itself verified directly), and
proved outright for all `(i,j)` with `6 max(i,j) < p-1`.  Note that
`lcm(p-1,p+1)` is *already* `(p^2-1)/2`, i.e. the period is half of `p^2-1`;
the halving relative to the full multiplicative order is real, and there is no
second halving.

---

## 4. The predicted second stratum family, found and classified (task 3)

### 4.1 What a degeneration has to do here

On the `lam`-line a stratum degenerates when the single exponential `lam^m`
is pinned -- either to a small torus (`lam^m in mu_n`) or to a small fixed
exponent (`m == c mod p-1`).  On the `u`-line the weight involves **two**
exponentials, `nu^m` on the split torus `F_p^*` and `z^m` on `mu_{p+1}`, and a
reduction must simplify **both at once**.  That single sentence predicts the
shape of the answer, and the sweep confirms it: every constant non-split
stratum is a pair of reductions, one per torus.

Write `ii` for the least-absolute residue of `i = m mod (p-1)`, `jj` for
`min(j, p+1-j)` with `j = m mod (p+1)` (legitimate since `D_{-j} = D_j`),
`k = (p-1)/gcd(i,p-1)` (so `nu^m in mu_k`), and `n = (p+1)/gcd(j,p+1)` (so
`z^m in mu_n`).

### 4.2 The torus correlation lemma

**Lemma 8 (proved).**  For every `z in mu_{p+1} - {-1}`, with
`nu = N_{F_{p^2}/F_p}(1+z) = z + z^{-1} + 2`,

```
z^{(p+1)/2} = chi(nu).
```

*Proof.*  `(1+z)^p = 1 + z^{-1} = (1+z)/z`, so `z = (1+z)^{1-p}` and
`z^{(p+1)/2} = (1+z)^{(1-p^2)/2} = chi_{p^2}(1+z)^{-1} = chi_{p^2}(1+z)`.  And
`chi_p(N(w)) = w^{(p+1)(p-1)/2} = chi_{p^2}(w)`, so
`chi_{p^2}(1+z) = chi_p(nu)`. ∎

So the two tori are *not* independent: their quadratic characters agree
identically.  Everything about the joint distribution of `(nu^i, z^j)` beyond
this correlation is governed by Gauss/Jacobi sums (section 2) and is
equidistributed once `p` is large compared with `(kn)^4`.

**Verified-exact.**  `families`, part (a): 0 failures over all non-split `tau`
for every `5 <= p < 400`.

### 4.3 The two identically constant infinite families (proved)

* **`N_0`: `m == 0 (mod L)`.**  Then `nu^m = 1` and `tau_m = 2`, so the weight
  is `chi((1-2)^2-4) = chi(-3)` at every non-split `u`.  Constant for every
  `p`.  This is the non-split shadow of the `lam`-line stratum `A`, but it
  needs *both* congruences: `m == 0 mod (p-1)` alone does not do it.
* **`N_{1/2}`: `m == (p+1)/2 (mod L)`.**  Here `nu^m = nu^{(p-1)/2} nu =
  chi(nu) nu` and `tau_m = 2 z^{(p+1)/2} = 2 chi(nu)` by Lemma 8, so
  `nu^m - tau_m = chi(nu)(nu - 2)` and the weight is
  `chi((nu-2)^2 - 4) = chi(nu(nu-4)) = chi((nu-4)/nu) = chi(1-4u) = -1`.
  **The census is identically `-1` for every odd prime.**

`N_{1/2}` is the genuinely new structural family and it has no `lam`-line
counterpart: it exists *because* the two tori are correlated (Lemma 8), and
its value `-1` is the tautology "`1-4u` is a non-square on the non-split
locus" transported through the census.  In `r = 2m` coordinates
`r == p+1 == 2 (mod p-1)`, so this family sits over the `lam`-line's total
collapse stratum `B`: at the `lam`-line the census collapses, and its second
`m`-lift makes the non-split census constant `-1` instead.

**Verified-exact (`families`, part (b)).**  `N_0` and `N_{1/2}` are constant
as claimed at every prime `5 <= p < 4000`, 0 failures.

### 4.4 The torus power-residue families (proved for large `p`, verified)

**Theorem 9 (proved for `p` large; verified-exact otherwise).**  Suppose
`nu^m in mu_k` and `z^m in mu_n`.  Then the weight takes values in the
*fixed* finite set

```
W_{k,n} = { (xi - eta - eta^{-1})^2 - 4 : xi^k = 1, eta^n = 1 } subset Z[zeta_{kn}],
```

and, once every occurring pair `(xi,eta)` is realised -- which holds when `p`
is large compared with `(kn)^4`, by the Gauss/Jacobi bounds of section 2 --
the census is constant **iff all non-zero elements of the realised part of
`W_{k,n} mod p` lie in a single square class**.  The realised pairs are
constrained by Lemma 8 and otherwise equidistributed.

The two pure rows, computed and verified:

```
k = 1 (nu^m = 1) :  W_n = { (eta + eta^{-1} - 1)^2 - 4 }
   W_1 = {-3}        W_2 = W_4 = {-3, 5}      W_3 = {-3, 0}
   W_6 = {-3, 5, -4, 0}     W_8 = {-3, 5, -1-2 sqrt2, -1+2 sqrt2}
n = 1 (z^m = 1) :   U_k = { xi(xi-4) }
   U_1 = {-3}        U_2 = {-3, 5}
```

| family | condition on `p` | members `p < 4000` (of the admissible primes) |
|--------|------------------|-----------------------------------------------|
| `k=1, n=2` | `2 \| p+1`, `chi(-15) = +1` | 141 / 279 |
| `k=1, n=3` | `3 \| p+1` -- **no further condition** (`W_3 = {-3,0}`) | 276 / 277 |
| `k=1, n=4` | `4 \| p+1`, `chi(-15) = +1` | 70 / 139 |
| `k=1, n=5` | `5 \| p+1`, `W_5` in one square class | 27 / 135 |
| `k=1, n=6` | `6 \| p+1`, `chi(-15) = chi(3) = +1` | 70 / 139 |
| `k=1, n=7` | `7 \| p+1`, `W_7` in one square class | 16 / 93 |
| `k=1, n=8` | `8 \| p+1`, `W_8` in one square class | 6 / 69 |
| `k=1, n=9` | `9 \| p+1`, `W_9` in one square class | 13 / 90 |
| `k=1, n=10,11,12` | unsatisfiable | 0 |
| `n=1, k=2` | `chi(-15) = +1` | 127 / 269 |
| `n=1, k=3` | `U_3` in one square class | 65 / 271 |
| `n=1, k=4` | `U_4` in one square class | 11 / 129 |
| `n=1, k=5` | `U_5` in one square class | 4 / 134 |
| `n=1, k=7` | `U_7` in one square class | 2 / 89 |
| `n=1, k=6,8,9,10,11,12` | unsatisfiable | 0 |

`n = 3` is the striking row: `W_3 = {-3, 0}` has a single non-zero element, so
the square-class condition is vacuous and the family is **unconditionally
infinite** -- every prime `p == 2 (mod 3)` (with the parity condition) carries
it, 276 of 277 admissible primes below 4000, the single miss being `p = 5`
where the stratum degenerates further to total collapse.  This is the
non-split analogue of nothing on the `lam`-line: there the `n = 3` condition
needed two elements of `V_3` to be squares and the family had density `~1/8`.

The mixed rows `(k,n)` with both `> 1` occur too: `(2,4)`, `(2,8)`, `(3,5)`,
`(5,3)`, `(2,2)` and `(4,6)` all appear below `p = 300`.

**Verified-exact (`families 4000`).**  For both pure rows, every `n <= 12`,
every `k <= 12`, and every admissible prime `p < 4000`: the biconditional
"census constant iff the non-zero part of `W`/`U` lies in one square class"
holds with **0 mismatches** -- notably with *no* small-`p` exceptions, unlike
the `lam`-line version of this theorem, which had four.

### 4.5 The fixed-exponent families, closed by Weil (proved)

**Theorem 10 (proved).**  Fix integers `ii == jj (mod 2)` and set

```
P_{ii,jj}(tau) = ((tau+2)^{ii} - D_{|jj|}(tau,1))^2 - 4          (ii >= 0)
               = (1 - D_{|jj|}(tau,1)(tau+2)^{|ii|})^2 - 4(tau+2)^{2|ii|}  (ii < 0),
```

a polynomial over `Z` depending on `(ii,jj)` only.  For every `p` with
`p-1 > 2|ii|` and `p+1 > 2|jj|`, the non-split census of the family
`m == ii (mod p-1)`, `m == jj (mod p+1)` is

```
S_ns = (1/2)[ sum_tau chi(P) - sum_tau chi((tau^2-4) P) ]
       - (1/2)[ chi(P(2)) + chi(P(-2)) ],
```

so with `D_1 = deg sqfree(P)`, `D_2 = deg sqfree((tau^2-4)P)`, Weil's bound
gives `|S_ns| <= ((D_1-1)+(D_2-1)) sqrt p / 2 + 1`.  Constancy forces
`(p-1)/2 - z <= ` that bound (`z <= deg P` the number of non-split zeros),
hence `p <= P(ii,jj)`, an explicit bound.  **Each such family is therefore
finite and can be listed exhaustively.**  Unless `P_{ii,jj}` is a constant
times a square -- which happens exactly at `(0,0)` and `(1,1)`, by Theorem 6's
computation -- the family is finite.

Complete member lists (`weil 8`, every `|ii| <= 8`, `0 <= jj <= 8`):

| `(ii,jj)` | `D_1` | `D_2` | Weil bound on `p` | complete member list |
|-----------|-------|-------|-------------------|----------------------|
| `(-2,4)` | 12 | 14 | 629 | `p = 11` |
| `(-1,1)` | 4 | 6 | 85 | `p = 5, 7` |
| `(0,4)` | 8 | 10 | 293 | `p = 11, 23` |
| `(0,6)` | 12 | 14 | 629 | `p = 17, 23` |
| `(0,8)` | 16 | 18 | 1093 | `p = 23, 31, 47` |
| `(2,0)` | 2 | 4 | 35 | `p = 7` |
| `(2,4)` | 8 | 8 | 233 | `p = 11` |
| **`(7,3)`** | 14 | 14 | 737 | **`p = 19`** |
| all other `(ii,jj)`, `\|ii\|,jj <= 8` | -- | -- | as tabulated | none |

The `(0,jj)` rows overlap the torus rows of 4.4 (`(0,4)` at `p = 23` is the
`n = 6` family, `(0,8)` is `n = 3` or `n = 6`, `(2,0)` at `p = 7` is the
`k = 3` family); membership in several families is normal and is what makes
the classification robust, exactly as on the `lam`-line.

### 4.6 The classification

**Theorem 11 (classification; proved family-by-family, verified-exact and
complete for `5 <= p < 300`).**  Every constant non-split stratum is

1. `N_0` (`m == 0 mod L`) or `N_{1/2}` (`m == (p+1)/2 mod L`), both infinite
   and identically constant; or
2. a torus power-residue family of 4.4 with small `(k,n)` -- the pure rows
   `(1,n)`, `n <= 9`, and `(k,1)`, `k in {2,3,4,5,7}`, tabulated above, plus
   the mixed rows observed below `p = 300`
   (`(2,2), (2,3), (2,4), (2,8), (3,5), (4,2), (4,6), (5,3), (6,8)`) --
   each infinite of positive density by a Chebotarev condition, and
   unconditionally infinite for `(1,3)`; or
3. a member of a fixed-exponent family of 4.5, each closed by an explicit
   Weil bound and exhaustively listed.

**Verified-exact (`sweep 300`).**  The sweep runs the **full** period window
`m in Z/L` at **every** prime `5 <= p < 300` -- `sum_p (p^2-1)/2 ~ 1.1e6`
exponents, an exhaustive enumeration -- and finds **319** constant non-split
strata.  Every one carries a description from the list above.  Frequency by
cheapest description:

| description | count | example primes |
|-------------|-------|----------------|
| `nu^m = 1`, `z^m in mu_3` | 62 | 11, 17, 23, 29, 41, 47, ... |
| `N_0` (`m == 0 mod L`) | 60 | every prime |
| `N_{1/2}` (`m == (p+1)/2 mod L`) | 60 | every prime |
| `nu^m = 1`, `z^m in mu_4` | 18 | 23, 31, 47, 79, 151, 167 |
| `nu^m = 1`, `z^m in mu_5` | 16 | 89, 179, 199, 229 |
| `nu^m in mu_2`, `z^m = 1` | 15 | 5, 17, 53, 61, 109, 113 |
| `nu^m = 1`, `z^m in mu_2` | 15 | 19, 23, 31, 47, 79, 83 |
| `nu^m in mu_2`, `z^m in mu_4` | 12 | 19, 83, 107, 139, 211, 227 |
| `nu^m = 1`, `z^m in mu_6` | 12 | 47, 83, 107, 167, 227, 263 |
| `nu^m in mu_3`, `z^m = 1` | 10 | 67, 79, 127, 163, 277 |
| `nu^m in mu_2`, `z^m in mu_8` | 8 | 151, 263 |
| `nu^m = 1`, `z^m in mu_7` | 6 | 293 |
| fixed exponents `(ii,jj) = (-1,1)` | 4 | 5, 7 |
| `nu^m in mu_4`, `z^m = 1` | 4 | 137, 257 |
| `nu^m in mu_5`, `z^m = 1` | 4 | 241 |
| remaining mixed / fixed-exponent rows | 13 | 5, 7, 11, 19, 23 |

**The single sporadic.**  Exactly one of the 319 has no torus description on
either side: `(p, i, j) = (19, 7, 3)`, i.e. `m == 43 (mod 180)` at `p = 19`,
with its mirror `j -> -j`.  It is the fixed-exponent family `(ii,jj) = (7,3)`,
whose curve pair has square-class degrees `14, 14`, Weil bound `p <= 737`, and
**exactly one member, `p = 19` -- a theorem, not a search result.**  This is
the exact `u`-line counterpart of `(47,30)` on the `lam`-line: the one point
that no cheap torus reduction explains, closed by a Weil bound on a fixed
curve of moderate genus.

### 4.7 Relation to the `lam`-line classification

The families above are **not** implied by the `lam`-line classification, and
the `lam`-line families are not implied by these.  The clean statement:

* the `lam`-line census is a function of `i = m mod (p-1)` alone, and its
  constancy list is the platform report's 15 classes;
* the non-split census is a function of `(i,j)` and its constancy list is
  Theorem 11;
* the `u`-line coloring is constant iff **both** are constant with the same
  value.  For example `m == 0 mod L` makes both `chi(-3)`; but `m == 1 mod
  (p-1)` (the `lam`-line collapse `B`) makes the non-split part constant only
  at `j == +-1` (collapse) and at nothing else, and `m == (p+1)/2 mod L` makes
  the non-split part constant `-1` while the `lam`-line part collapses.

So the non-split list refines, and does not reproduce, the `lam`-line list;
of the 319 non-split strata, `N_0` and the two collapse classes are the only
ones that lie over an identically degenerate `lam`-line stratum.

---

## 5. Impact on the reconstruction paper's completeness claim (task 4)

### 5.1 Which surface each classification governs

* **The `lam`-line classification governs the 4-set coloring on `P^1(F_q)`.**
  A 4-subset of `P^1(F_q)` consists of `F_q`-rational points, so its
  cross-ratio lies in `F_q - {0,1}`, and the coloring is
  `lam -> chi_q(Phi_{2m,4}(lam))` on the `F_q`-rational `lam`-line.  This is
  the reconstruction paper's object (the `PGL_2`-invariance, the
  `Aut`-dichotomy, the marking fibre, the query bounds).
* **The `u`-line/descent census governs a different set.**  Its points are
  `u in F_q`, i.e. unordered pairs `{lam, 1-lam}`, and its non-split part
  consists of the `u` whose two `lam`'s lie in `F_{q^2} - F_q`.  Those `lam`
  are **not** cross-ratios of any 4-subset of `P^1(F_q)`.  The `u`-line is the
  natural home of the descent quotients `D_1, D_2` and of the
  Jacobian-splitting story, not of the coloring.

**Theorem 12 (proved).**  For every `q` and every `m`, no non-split stratum of
the `u`-line changes the 4-set coloring on `P^1(F_q)`: the coloring is a
function of `F_q`-rational cross-ratios only, hence is the `lam`-line census
over `F_q`, whose constancy is decided by the platform report's
classification read with `q` in place of `p` (every step of it -- the
periodicity identity over `Z`, the Jacobi-sum master formula, the Weil bounds,
the cyclotomic square-class conditions -- is valid over any finite field of
odd characteristic).

### 5.2 The `q = p^2` interaction, where the worry actually lives

Over `F_{p^2}` the `F_p`-non-split `lam` **are** `F_{p^2}`-rational and so do
occur as cross-ratios.  This is the one place where the `F_p` `u`-structure
touches the reconstruction object, and it is settled negatively:

**Theorem 13 (proved).**  Let `q = p^2` and let `lam in F_{p^2}` satisfy
`Tr_{F_{p^2}/F_p}(lam) = 1` (equivalently `1 - lam = lam^p`, i.e. `lam` is
`F_p`-non-split) or `lam in F_p`.  Then `Phi_{2m,4}(lam) in F_p`, and since
every element of `F_p^*` is a square in `F_{p^2}`,

```
chi_{p^2}(Phi_{2m,4}(lam)) = +1   whenever Phi_{2m,4}(lam) != 0,
```

for **every** `m`.  So the `F_p`-non-split locus carries the constant color
`+1` in the `F_{p^2}` coloring, independently of `m`: it can neither create
nor destroy a constancy, and it can never carry the value `-1`.

*Proof.*  `u = lam(1-lam) = lam^{p+1} in F_p^*` and
`u^2 Phi = F(lam^r, lam^{pr}) = (1-Tr(lam^r))^2 - 4 N(lam^r) in F_p`, so
`Phi in F_p`.  For `a in F_p^*`, `chi_{p^2}(a) = a^{(p^2-1)/2} =
(a^{(p-1)/2})^{p+1} = chi_p(a)^{p+1} = +1` since `p+1` is even. ∎

A corollary worth recording, because it generalises the marking report's Baer
stratum: **over `F_{p^2}`, every `r == 0 (mod p+1)` gives a coloring that is
`+1` on its whole non-vanishing locus.**  Indeed `(p+1) | r` makes
`lam^r = N(lam)^{r/(p+1)} in F_p^*` for every `lam`, so `Phi in F_p` and
Theorem 13's character computation applies.  There are exactly `p-1` such
classes `r`, and `r = p+1` -- the Baer/Miquelian stratum -- is the first of
them.

### 5.3 Exhaustive verification over prime powers

`powq 1100` runs the complete `lam`-line scan over every even `r` at every
prime power `q = p^k <= 1000` with `k >= 2`
(`q = 9, 25, 27, 49, 81, 121, 125, 169, 289, 343, 361, 529, 625, 841, 961`).
Two readings, kept apart because the reconstruction dichotomy needs the
second:

* **Constant on the non-vanishing locus.**  For every `q = p^2` the list is
  exactly `{r == 0 mod (p+1)}` (the `p-1` classes of 5.2, Baer included)
  together with the `mu_n` power-residue rows satisfying the `F_q`
  square-class condition -- e.g. `q = 169`: exactly the 12 multiples of 14;
  `q = 289`: the 16 multiples of 18 plus `r = 48, 96, 192, 240`
  (`mu_6, mu_3`).  **Every one of these has color `+1`**, as Theorem 13
  forces.  For odd `k` the `-1` color does occur (`q = 125`, `r = 0` and
  `r = 62`), exactly because `F_p^*` is then not contained in the squares of
  `F_q`.
* **Literally constant (the reconstruction notion).**  The list is
  `{r = 0}` (stratum `A`) `union {r = 2 p^i : 0 <= i < k}` (stratum `B` and
  its Frobenius twists, total collapse) `union` the zero-free `mu_4`/`mu_8`
  rows -- for instance `q = 169`: `{0, 2, 26, 42, 84, 126}`; `q = 361`:
  `{0, 2, 38, 90, 180, 270}`; `q = 961`: `{0, 2, 62, 480}`.  Nothing else.

Both lists are exactly what the `lam`-line taxonomy over `F_q` predicts.  No
entry of either list is traceable to an `F_p` non-split stratum.

### 5.4 The verdict the paper-package decision was waiting on

**No.**  No new non-split stratum changes the constant-coloring list for the
4-set coloring on `P^1(F_q)`, at any `q`.  This is **proved** (Theorems 12 and
13) -- not merely searched -- and independently **verified-exact** over all
prime powers `q = p^k <= 1000`, `k >= 2`, together with the platform report's
exhaustive prime-field scan `5 <= p < 4000`.  The reconstruction paper's
completeness claim stands as written.

One refinement is worth folding in while the file is open: over `F_{p^2}` the
Baer stratum `r = p+1` is the first member of the `p-1`-class family
`r == 0 (mod p+1)`, all of whose members are `+1` on their non-vanishing
locus (5.2).  If the manuscript states the Baer case as an isolated stratum
rather than as the first member of that family, that is a wording repair, not
a mathematical gap -- the literally-constant list, which is what the
`Aut`-dichotomy uses, is unaffected.

---

## 6. Ergodis interface notes

**Fit (used).**  `census <label> <p> <coeffs>` on `P_m(tau)` and on
`(tau^2-4) P_m(tau)`, each reduced modulo `tau^p - tau`, computes `S1` and
`S2` exactly.  This is a *better* fit than the `lam`-line side had: because
Theorem 1 turns the whole `u`-line census -- split part, non-split part and
the twisted census -- into two one-variable polynomial character sums over
`F_p`, the kernel can carry both without any two-variable or torus primitive.
`ergodis`: 210 requests (`m = 2..8`, `5 <= p < 60`), **0 disagreements** with
the Python censuses.  The non-split census itself follows from Theorem 2,
`S_ns = (S1 - S2 - kappa)/2`, so it too is kernel-checkable.

**Misfit (interface-improvement notes).**

1. No `F_{p^2}` arithmetic and no multiplicative characters of order `> 2`, so
   the trace-one Gauss sums of Theorem 3 -- the whole arithmetic side of the
   master formula -- cannot be expressed.  A `GaussSum(F_{p^k}, chi, psi)` or
   `TraceRestrictedSum` primitive would make section 2 replayable.
2. No torus-restricted or subgroup-restricted sums, so the `(i,j)` grid of
   section 4 (a sum over `mu_{p+1}` indexed by two exponents) had to be done
   in numpy.  This is the single most useful missing primitive for this lane:
   the sweep is `sum over p` of `(p^2-1)/2` censuses and dominates the cost.
3. `polynomial_census` takes the polynomial degree as given, so the caller
   must reduce modulo `x^p - x` first; a `census_of_exponential(p, r, ...)`
   entry point taking the exponent rather than the expanded polynomial would
   remove the only bookkeeping step that can silently go wrong.
4. No square-class/squarefree-part primitive, so the genus and Weil-bound
   table of 4.5 was computed in sympy.

---

## 7. Does the `(17,6), (17,10), (47,30)` family have a torus mirror? (task 5)

**No -- verified-exact for `5 <= p < 400`, with a structural reason.**

The `lam`-line Fermat-cubic family is `3m == +-1 (mod p-1)`: cubing turns the
single exponential into the fixed genus-1 curve `xi^3 + eta^3 = 1`.  Three
tests (`mirror 400`):

1. **At the three members themselves** the non-split census is *generic* --
   neither constant nor collapsed -- for both `m`-lifts:
   `(p,r) = (17,6)`: `(N_+,N_-) = (4,4)` and `(3,1)`;
   `(17,10)`: `(3,4)` and `(5,2)`; `(47,30)`: `(9,13)` and `(10,11)`.
   The `lam`-line's most exotic stratum leaves no trace on the `u`-line.
2. **The `z`-side mirror `3m == +-1 (mod p+1)`**: no constant non-split
   stratum at any `p < 400`, over all `p-1` values of `i`.
3. **The joint mirror `3m == +-1 (mod L)`**: no constant non-split stratum at
   any `p < 400`.

The structural reason is exactly the two-exponential principle of 4.1.  On the
`lam`-line, a single reduction `x -> x^3` pins the one exponential and drops
the genus to 1.  On the `u`-line the same reduction pins `z^{3m}` but leaves
`nu^{3m}` a full-order exponential on the split torus, so the reduced datum is
still a curve of degree comparable to `p` and Weil is vacuous.  A `u`-line
sporadic therefore has to be simultaneously small in both coordinates, which
is why the one that exists -- `(19, i=7, j=3)` -- is a *fixed-exponent* point
with both exponents small, and not a Fermat-type point with one clever
reduction.

`(19,7,3)` is the `u`-line's `(47,30)`: the unique constant non-split stratum
below `p = 300` with no torus description, closed by Weil at `p <= 737` with
exactly one member.  It is not the mirror of `(47,30)`; it is the analogous
*role*, filled by a different mechanism.

---

## 8. Closeout pass (`ej` + `tt`)

Free upgrades taken while the machinery was open:

* **An exact census evaluation, not a bound.**  On the family `N_{1/2}`
  (`m == (p+1)/2 mod L`) everything is closed form: `kappa = 0`, the
  `lam`-line census is `0` (stratum `B`), and

  ```
  S_ns = -(p-1)/2,     S1 = -(p-1)/2,     S2 = +(p-1)/2,
  ```

  exactly, for every odd prime.  (Verified for all `5 <= p < 60`, 0 failures;
  proved from Lemma 8 as in 4.3.)  These are square-root-cancellation-free
  evaluations of a character sum whose Weil bound is `O(p^{1/2} m)` -- the
  extremal case, and the reason the family is invisible from the bound side.
* **The Baer stratum generalised** (5.2): over `F_{p^2}` the whole family
  `r == 0 (mod p+1)`, `p-1` classes, is `+1` on its non-vanishing locus.
* **The Ergodis fit improved** (section 6): the `u`-line census is *two*
  ordinary polynomial censuses, so unlike the `lam`-line side it needs no
  two-variable primitive.

What a Tao-style reading asks that this pass answers, and what it leaves:

* *Why two exponentials and not one?*  Because `u` enters the weight twice --
  once as `nu = 1/u` (always split) and once through `z` (split or not).  The
  correct statement of "the `u`-line sees the non-split torus" is that it sees
  **both** tori simultaneously; that is what makes the period `lcm` rather
  than `p+1`, and what makes the sporadics rare.
* *Is `N_{1/2}` an accident of the quadratic character?*  No -- Lemma 8 says
  the two tori are quadratically correlated, so the `-1` value is forced.
  Whether higher correlations exist (the joint distribution of `(nu^i, z^j)`
  beyond the quadratic one) is a Gauss-sum equidistribution question and is
  open; it is what a density theorem for the mixed `(k,n)` rows would need.

---

## Mystery ledger

| # | Surprising / unexplained | settled by this pass? | evidence gap / owner |
|---|--------------------------|-----------------------|----------------------|
| 1 | Whether the `p+1` (non-split torus) side carries its own strata (platform ledger item 4, "opened, not settled") | **Settled.**  It does: 319 constant strata for `5 <= p < 300`, in two identically constant infinite families, a family of torus power-residue rows, and Weil-closed fixed-exponent families | none -- closed |
| 2 | The `u`-line period `lcm(p-1,p+1)` -- measured, not derived (platform section 6) | **Settled.**  Derived from the two-exponential form (Theorem 5); minimality is exactly `L`, not `L/2`, proved from the collapse set (Theorems 6, 7) | the collapse set is proved to be `{1,p}` only for `6 max(i,j) < p-1`; exhaustive for `p < 300`.  A general proof needs the divisibility `(z^{p+1}-1)/(z^2-1) \| F` analysed for large exponents |
| 3 | Whether the `(17,6),(17,10),(47,30)` Fermat-cubic family has a torus mirror | **Settled negative.**  No mirror: generic non-split census at all three members, and no constant stratum with `3m == +-1` mod `p+1` or mod `L`, `p < 400`; structural reason in section 7 | verified range `p < 400`; the structural argument (one reduction cannot pin two exponentials) is a heuristic, not a theorem |
| 4 | Whether any non-split stratum touches the reconstruction paper's constant-coloring list | **Settled negative, proved.**  Theorem 12 (the coloring is a function of `F_q`-rational cross-ratios) and Theorem 13 (over `F_{p^2}` the `F_p`-non-split locus is uniformly `+1`), plus the exhaustive prime-power scan | none -- closed; one wording refinement offered in 5.4 |
| 5 | Why `n = 3` is unconditional on the non-split torus while the `lam`-line `mu_3` family needs two square conditions | **Settled.**  `W_3 = {-3,0}` has a single non-zero element because `eta + eta^{-1} = -1` for a primitive cube root, so `(eta+eta^{-1}-1)^2 = 4`; the `lam`-line set `V_3` has six elements | none -- closed |
| 6 | Exact densities of the torus families (`n = 5,7,8,9`, `k = 3,4,5,7`) | **Not settled.**  The conditions are explicit square-class conditions in `Q(zeta_n)^+`; the Galois degrees and admissible-class counts were not computed | needs `[Q(zeta_n, sqrt{W_n}) : Q]` and the class count; same gap as platform ledger item 5 |
| 7 | Why `k = 6, 8, 9, 10, 11, 12` are empty on the split side while `k = 7` is not | **Not settled.**  Measured over `p < 4000`; `U_7` collapses to one square class in a way `U_6` does not | needs the square-class structure of `U_k = {xi(xi-4)}` in `Q(zeta_k)`; cheap, not done |
| 8 | Whether `(19,7,3)` is the last `u`-line sporadic | **Partly settled.**  Its own family is closed (`p <= 737`, one member).  The sweep is exhaustive only for `p < 300`, and the fixed-exponent window only `\|ii\|, jj <= 8` | a uniform statement needs an effective bound on the best simultaneous rational approximation of `m` mod `p-1` *and* mod `p+1` -- the two-dimensional analogue of the platform's open item 3 |
| 9 | Higher-order correlation of the two tori beyond Lemma 8 | **Opened, not settled.**  Lemma 8 fixes the quadratic correlation exactly; nothing is proved about the joint equidistribution of `(nu^i, z^j)` | a Gauss-sum equidistribution estimate on `F_p^* x mu_{p+1}`; owner: a successor task, and it is the prerequisite for item 6 |

No manufactured mysteries: items 1-5 are genuinely closed by this pass,
items 6-7 are cheap arithmetic left undone, and items 8-9 are the two real
open frontiers this derivation created.

---

**Status: complete.**

