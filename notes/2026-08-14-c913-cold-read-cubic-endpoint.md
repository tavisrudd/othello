# Cold read: `09-cubic-endpoint.tex`, subsection "The point coefficient"

Date: 2026-08-14
Target: `papers/cubic-stabilization-irrationality/sections/09-cubic-endpoint.tex`
(subsection "The point coefficient", incl. `lem:cubic-central-charge`)
Context read: `sections/02-point-row.tex` (`eq:gamma-framed-section`, `eq:flat-euler-pairing`),
`papers/cubic-stabilization-irrationality/refs.bib`,
`papers/cubic-stabilization-irrationality/verification/check_cubic_endpoint.py`.

## Sources actually consulted

- **DLMF §16.11** fetched live from <https://dlmf.nist.gov/16.11> (two independent fetches, one
  for the formula bodies, one for the case labels and hypotheses). Not read from memory.
- **Iritani, "Gamma classes and quantum cohomology", arXiv:2307.15938** — in the shared cache
  (`/tmp/persistent/tavis/lit-search/text/arXiv_2307.15938.txt`, key `arXiv:2307.15938`,
  status `ok`). Cache consulted first per the README contract; no re-fetch needed. Equations
  (1.4)–(1.7) and the definition of the grading operator read verbatim from the extraction.
- **Cai, arXiv:2608.01577** — NOT in the cache and not fetched. Everything I checked against Cai
  is internal arithmetic on the matrices as transcribed in the manuscript; I did **not** verify
  that `eq:cai-cubic-matrices` faithfully reproduces Cai's Section 3. That transcription is
  UNVERIFIED here.
- Exact arithmetic done with `sympy`, numerics with `mpmath`, both via `uv run --with ...`.

## Verdict summary

| # | Claim | Verdict |
|---|--------------------------------------------------|-----------|
| 1 | `ch(O_p) = [p]`, no lower terms | CONFIRMED |
| 2 | Gamma class, `(2 pi i)^{deg/2}`, `z^{c_1}` on top class | CONFIRMED |
| 3 | `mu[p] = (3 - 3/2)[p]`, `z^{-mu}[p] = z^{-3/2}[p]` | CONFIRMED |
| 4 | Pairing `L[p]` against `1` = coeff. of `1` in small `J` | CONFIRMED |
| 5 | Small `I`-function, `z^{-2d}`, trivial mirror map, `P=0` | CONFIRMED (one omitted factor, harmless) |
| 6 | `(3d)! = 27^d d! (1/3)_d (2/3)_d` and the `2F3` form | CONFIRMED |
| 7 | Barnes algebraic part, DLMF locators, two coefficients | Formula, locators, coefficients CONFIRMED; **stated hypothesis `p <= q` WRONG** |
| 8 | `x = 27q/z^2`, `z^{-5/6}` and `z^{-1/6}`, monodromy factors | CONFIRMED |
| 9 | Zero block <-> algebraic part, `+-6 sqrt3 u` <-> exponentials | CONFIRMED |
| 10 | Half-turn pairs `lambda` with `lambda^{-1}`; both lines nonzero | CONFIRMED (one unstated nondegeneracy step; causal wording loose) |
| 11 | `C` nonzero constant and `k` integer absorb all conventions | CONFIRMED (I pin `C = -i(2 pi)^{3/2}`, `k = 0`) |
| — | Indicial computation vs. Barnes exponents | CONSISTENT (exact match, not merely mod `Z`) |

No error was found that affects the proof. One statement is over-general and should be narrowed
(item 7); one factor is dropped from a standard display (item 5); two steps are asserted where a
one-line justification would help (items 4 and 10). Details below.

---

## Item-by-item

### 1. `ch(O_p) = [p]` with no lower-degree terms — CONFIRMED

Text judged:

> For a point on a smooth threefold \(\operatorname{ch}(\OO_p)=[p]\) with no lower-degree terms,
> and \([p]\) has cohomological degree \(6\)

Correct. For `i : pt -> X` with `X` smooth of dimension `n`, Grothendieck–Riemann–Roch for the
proper map `i` gives `ch(i_* O_p) td(T_X) = i_*(ch(O_p) td(T_pt)) = [p]`. Since `[p]` is the top
class, `[p] cup td(T_X) = [p]` (only the degree-0 part of `td` survives), so
`ch(i_* O_p) = [p]` on the nose. Equivalently: `O_p` has rank 0 and is supported in codimension
`n`, so `ch_i = 0` for `i < n`, `ch_n = [p]`, and `ch_i = 0` for `i > n` because `H^{>2n}(X) = 0`.
For `n = 3`, `[p] in H^6(X)`, so `deg = 6`. Both halves of the sentence hold.

### 2. Gamma class, `(2 pi i)^{deg/2}`, `z^{c_1(X)}` on the top class — CONFIRMED

Text judged:

> \((2\pi i)^{\deg/2}\operatorname{ch}(\OO_p)=(2\pi i)^3[p]\). Every positive-degree term of
> \(\Ghat_X\) annihilates the top class, so \(\Ghat_X[p]=[p]\), and \(c_1(X)\cup[p]=0\) gives
> \(z^{c_1(X)}[p]=[p]\).

All three are correct.

- `(2 pi i)^{deg/2}` acts on `H^6` by `(2 pi i)^3`. Consistent with the operator convention in
  `eq:gamma-framed-section`, which matches Iritani (1.6) verbatim (see item 11).
- `Ghat_X = 1 + (positive-degree terms)`; those terms cup `[p] in H^6` into `H^{>6}(X) = 0`.
  Hence `Ghat_X [p] = [p]`.
- `z^{c_1(X)} = exp(c_1(X) log z)`; every term beyond the identity involves `c_1 cup [p] in H^8 = 0`.
  Hence `z^{c_1(X)}[p] = [p]`. (Note the argument does not need `c_1(X) = 2P` specifically;
  degree alone suffices. The manuscript's phrasing `c_1(X) cup [p] = 0` is the correct reason.)

The non-commutativity of `z^{-mu}` and `z^{c_1}` is not an issue here: applied right-to-left to
`[p]`, `z^{c_1}` acts as the identity first, and `z^{-mu}` then acts on `[p]` alone.

### 3. `mu[p] = (3 - 3/2)[p]`, hence `z^{-mu}[p] = z^{-3/2}[p]` — CONFIRMED

Text judged:

> The grading operator satisfies \(\mu[p]=(3-\tfrac32)[p]\), whence \(z^{-\mu}[p]=z^{-3/2}[p]\).

Checked against the convention the manuscript actually imports. `eq:gamma-framed-section` is
character-for-character Iritani's (1.6):

    s(V)(tau,z) = L(tau,z) z^{-mu} z^{c_1(X)} (2 pi)^{-n/2} Ghat_X (2 pi i)^{deg/2} ch(V)

and in the same paper `mu` is defined by `mu(phi_i) = (deg(phi_i)/2 - n/2) phi_i`. With
`deg[p] = 6`, `n = 3`: `mu[p] = (3 - 3/2)[p] = (3/2)[p]`, so `z^{-mu}[p] = z^{-3/2}[p]`.

Sign and shift are both right, and independently corroborated by Iritani's own display of the
same operator as `z^{(n - deg)/2}` in his (1.2): `z^{(3-6)/2} = z^{-3/2}`.

### 4. `(L_X(0,z)[p], 1)` = the one-point descendant series = coefficient of `1` in small `J` — CONFIRMED

Text judged:

> Pairing against the unit and expanding the fundamental solution in descendants leaves the
> one-point generating function with a point insertion,
> \(\sum_dq^d\langle[p]/(z-\psi)\rangle_{0,1,d}\), which is the coefficient of \(\mathbf 1\) in
> the small \(J\)-function.

Both halves hold, though the manuscript asserts them rather than deriving them. The checks:

*Second half.* `J(0,z) = z + sum_{d>0} q^d sum_alpha phi^alpha <phi_alpha/(z-psi)>_{0,1,d}` in the
Givental normalization. With `phi_0 = 1`, Poincaré duality gives `phi^0 = [p]` (since
`(1,[p]) = 1`). The term contributing to the coefficient of `1` is the one with `phi^alpha = 1`,
i.e. `phi_alpha = [p]`. So the coefficient of `1` in `J(0,z)` is exactly
`sum_d q^d <[p]/(z-psi)>_{0,1,d}` (with the `d=0` term `z`). Correct.

*First half.* Using the standard flatness identity `(L(tau,-z) a, L(tau,z) b) = (a,b)` and
Iritani's `J_X(tau,z) = L(tau,z)^{-1} 1`:

    (L(0,z)[p], 1) = (L(0,z)[p], L(0,-z) J(0,-z)) = ([p], J(0,-z))
                   = coefficient of 1 in J(0,-z).

So the identification is exact, not merely up to convention, and the only discrepancy is
`z -> -z` — which the manuscript explicitly covers in the paragraph after the lemma. This is a
stronger statement than the manuscript's own hedge, and it is what makes item 11 come out clean.

### 5. Small `I`-function, `z^{3d-5d} = z^{-2d}`, trivial mirror map, `P = 0` — CONFIRMED, with one omission

Text judged:

> \(I(q,z)=z\sum_{d\geq0}q^d \frac{\prod_{m=1}^{3d}(3P+mz)}{\prod_{m=1}^{d}(P+mz)^5}\)
> ... The degree-\(d\) term here carries \(z^{3d-5d}=z^{-2d}\), so \(I=z\mathbf 1+O(z^{-1})\) and
> the mirror map is trivial.

- **Shape of `I`.** Correct for a degree-3 hypersurface in `P^4`: numerator `prod_{m=1}^{3d}(3P+mz)`
  is the Euler twist by `O(3)`, denominator `prod_{m=1}^{d}(P+mz)^5` has exponent 5 = number of
  homogeneous coordinates of `P^4`. Covered by the cited `GiventalToricCI` / `CoatesGivental`
  (the twist is by a convex line bundle, so the quantum Lefschetz hypotheses hold).
- **Omission.** The standard display carries an extra factor `e^{(P log q)/z}`, absent here. With
  it, `I = z + P log q + O(1/z)`, so the mirror map is `tau(q) = (log q) P` — the "trivial" one in
  the sense of no `q`-corrections, which is the sense used. Without it (a Novikov-variable
  convention where `J` is written the same way) the sentence is literally correct as printed.
  Either way `P = 0` kills the factor, so the conclusion is unaffected. Worth restoring the factor
  or saying the exponential prefactor has been absorbed, since a referee will notice.
- **Degree count.** The degree-`d` summand is homogeneous of degree `3d - 5d = -2d` in `(P,z)`,
  so its top `z`-power is `z^{-2d}` and the full term is `z^{1-2d}`. For `d >= 1` this is `O(z^{-1})`.
  Correct. Note the argument implicitly uses Fano index `>= 2`: index 1 would leave a `z^0` term
  and a nontrivial mirror map. The cubic threefold has index `5 - 3 = 2`, exactly on the boundary,
  which is why the count works. This deserves half a sentence.
- **`I = z*1 + O(z^{-1})` implies trivial mirror map.** Correct: `J(tau,z) = z + tau + O(1/z)`, so
  the vanishing `z^0` term forces `tau = 0`.
- **`P = 0` specialization.** Setting `P = 0` extracts the coefficient of `1` in the expansion
  along `1, P, P^2, P^3`. Then `prod_{m=1}^{3d}(mz) = (3d)! z^{3d}` and
  `prod_{m=1}^{d}(mz)^5 = (d!)^5 z^{5d}`, giving

      z sum_d q^d (3d)! z^{3d} / ((d!)^5 z^{5d}) = z sum_d (q/z^2)^d (3d)!/(d!)^5 = z F(q/z^2).

  Confirmed by direct substitution.

### 6. `(3d)! = 27^d d! (1/3)_d (2/3)_d` and the `2F3` form — CONFIRMED

Text judged:

> the equality of the two expressions being the identity \((3d)!=27^d\,d!\,(1/3)_d(2/3)_d\).

Verified symbolically in `sympy` for `d = 0..6` (exact integer equality each time; e.g.
`d=4`: both sides `479001600`). The identity is the triplication formula in Pochhammer form:
`(3d)! = 27^d (1/3)_d (2/3)_d (1)_d` and `(1)_d = d!`.

Consequently

    (3d)!/(d!)^5 t^d = (1/3)_d (2/3)_d / ((d!)^4) (27t)^d
                     = [(1/3)_d (2/3)_d / ((1)_d (1)_d (1)_d)] (27t)^d / d!,

which is exactly the `2F3(1/3,2/3; 1,1,1; 27t)` summand. `eq:cubic-quantum-period` is correct as
printed, including the `27t` argument.

### 7. Barnes algebraic part and the DLMF locators — formula/locators/coefficients CONFIRMED; **stated hypothesis WRONG**

Text judged:

> For \({}_pF_q\) with \(p\leq q\) and \(a_k\) distinct modulo the integers, its algebraic terms are
> [`eq:barnes-algebraic-part`] \cite[Equations~16.11.2 and 16.11.8]{DLMF}.

**Locators: correct.** Fetched from <https://dlmf.nist.gov/16.11>. DLMF 16.11.2 is the definition

    H_{p,q}(z) = sum_{m=1}^{p} sum_{k=0}^{inf} [(-1)^k/k!] Gamma(a_m+k)
                 [prod_{l != m} Gamma(a_l - a_m - k) / prod_l Gamma(b_l - a_m - k)] z^{-a_m-k},

and DLMF 16.11.8 is the case `p = q-1`:

    (prod_{l=1}^{q-1} Gamma(a_l) / prod_{l=1}^{q} Gamma(b_l)) * {}_{q-1}F_q(a; b; -z)
        ~ H_{q-1,q}(z) + E_{q-1,q}(z e^{-pi i}) + E_{q-1,q}(z e^{pi i}),   z -> inf, |ph z| <= pi.

For `2F3` we have `p = 2`, `q = 3`, so `p = q - 1` and 16.11.8 is precisely the right locator.
These are the right two equations to cite.

**Displayed formula: correct.** Moving the DLMF prefactor to the right-hand side gives
`{}_pF_q(a;b;-z) ~ (prod Gamma(b_j)/prod Gamma(a_j)) (H + E + E)`, and the `k = 0` term of `H` is
`Gamma(a_m) prod_{l!=m} Gamma(a_l - a_m) / prod_l Gamma(b_l - a_m) * z^{-a_m}`. With the
manuscript's variable `x = -z` (its hypergeometric argument), `z^{-a_m} = (-x)^{-a_m}` and the
`k >= 1` tail is `O(x^{-1})` relative to it. `eq:barnes-algebraic-part` matches term for term.

**Hypothesis: wrong as stated.** The condition is **not** `p <= q`. DLMF 16.11.9 covers
`p <= q-2` and reads

    (prod Gamma(a_l)/prod Gamma(b_l)) {}_pF_q(a;b;-z) ~ E_{p,q}(z e^{-pi i}) + E_{p,q}(z e^{pi i}),

with **no `H` term at all** — there are no algebraic terms in that range. The `H` term appears for
`p = q+1` (16.11.6), `p = q` (16.11.7, with argument `z e^{-+ pi i}` chosen by half-plane), and
`p = q-1` (16.11.8). So the correct hypothesis for the displayed statement is `p = q-1` (or, more
loosely, `p >= q-1` with a phase caveat at `p = q`) — close to the opposite of what is printed.
This does not touch the application, since `2F3` satisfies `p = q-1` exactly; but as a general
lemma the sentence is false and should be narrowed to `p = q-1`.

The secondary hypotheses are right: DLMF requires that no `a_j` be a nonpositive integer
(here `1/3, 2/3`, fine), and states that if two `a_j` differ by an integer the definition of
`H_{p,q}` must be modified for multiple poles "and logarithmic terms may appear". The manuscript's
"the difference `1/3` is not an integer, so no logarithms occur and the two algebraic series are
distinct" is exactly the DLMF condition.

**Prefactor and the two coefficients: correct.** With `a = (1/3, 2/3)`, `b = (1,1,1)`:

    prod Gamma(b_j)/prod Gamma(a_j) = Gamma(1)^3 / (Gamma(1/3) Gamma(2/3)) = 1/(Gamma(1/3)Gamma(2/3)),

matching "The prefactor is \(1/(\Gamma(1/3)\Gamma(2/3))\)". Then

    a_k = 1/3:  Gamma(1/3) * Gamma(2/3 - 1/3) / Gamma(1 - 1/3)^3 = Gamma(1/3)^2 / Gamma(2/3)^3,
                times prefactor = Gamma(1/3)/Gamma(2/3)^4.
    a_k = 2/3:  Gamma(2/3) * Gamma(1/3 - 2/3) / Gamma(1 - 2/3)^3 = Gamma(2/3)Gamma(-1/3)/Gamma(1/3)^3,
                times prefactor = Gamma(-1/3)/Gamma(1/3)^4.

Both agree with `eq:cubic-barnes-coefficients`, including the intermediate unsimplified forms.
Nonvanishing is right: `Gamma` has no zeros, and `-1/3` is not a pole (poles are at
`0, -1, -2, ...`). `Gamma(-1/3) < 0`, so `C_{2/3}` is negative — nonzero, which is all that is used.

**Independent numerical confirmation** (`mpmath`, 60 dps): on the negative real axis, where the two
`E` terms are oscillatory of size `|x|^{-3/4}` and the algebraic terms dominate,

    C_{1/3} = 0.7967769879908849...,  C_{2/3} = -0.07887270747033973...

    x = -10^3 : 2F3 = 0.0785549660472,  C_{1/3}(-x)^{-1/3} + C_{2/3}(-x)^{-2/3} = 0.0788889717244
    x = -10^4 : 2F3 = 0.0366637609662,  predicted 0.0368131856063
    x = -10^5 : 2F3 = 0.0171237120944,  predicted 0.0171294303636
    x = -10^6 : 2F3 = 0.00796439360426, predicted 0.00795988260916

The residual divided by `(-x)^{-3/4}` stays bounded near `0.03..0.15` and changes sign
(`-0.059, -0.149, -0.032, +0.143`) — exactly the signature of the oscillatory exponential terms
of order `z^{nu/kappa} = z^{-3/4}` (`nu = -3/2`, `kappa = 2`). The algebraic coefficients are
therefore confirmed numerically as well as symbolically.

### 8. `x = 27q/z^2`, the exponents `z^{-5/6}` and `z^{-1/6}`, and the monodromy factors — CONFIRMED

Text judged:

> \(z^{-3/2}x^{-1/3}\sim z^{-5/6}\), \qquad \(z^{-3/2}x^{-2/3}\sim z^{-1/6}\)
> ... whose exponents reduce modulo the integers to the roots \(-5/6\) and \(-1/6\) of
> \eqref{eq:cubic-indicial-polynomial}, with monodromy factors \(\zetaSix\) and \(\zetaSix^{-1}\).

- **Substitution.** `F(t) = 2F3(...; 27t)`, so `F(q/z^2) = 2F3(...; 27q/z^2)`, i.e. `x = 27q/z^2`.
  Correct.
- **Exponent arithmetic.** `x^{-1/3} = (27q)^{-1/3} z^{2/3}` and `x^{-2/3} = (27q)^{-2/3} z^{4/3}`,
  so `z^{-3/2} x^{-1/3} = (27q)^{-1/3} z^{-3/2+2/3} = (27q)^{-1/3} z^{-5/6}` and
  `z^{-3/2} x^{-2/3} = (27q)^{-2/3} z^{-3/2+4/3} = (27q)^{-2/3} z^{-1/6}`. Both exponents are exactly
  as displayed. The `~` absorbs the `q`-dependent nonzero constant and the branch phase from
  `(-x)^{-a}` versus `x^{-a}`; that is legitimate here since only the `z`-exponent is used.
- **"Reduce modulo the integers".** The exponents are `-5/6` and `-1/6` **on the nose**, matching the
  indicial roots exactly; no reduction is needed. Harmless overstatement of what is required.
- **Monodromy factors.** `e^{2 pi i (-5/6)} = e^{-5 pi i/3} = e^{pi i/3} = zeta_6` and
  `e^{2 pi i (-1/6)} = e^{-pi i/3} = zeta_6^{-1}`. Matches the display, and matches the pairing
  `(-1/6, -5/6) <-> (zeta_6^{-1}, zeta_6)` asserted earlier at line 44–45. Internally consistent.

### 9. Zero block <-> algebraic terms, `+-6 sqrt3 u` <-> exponential terms — CONFIRMED

Text judged:

> The eigenvalues \(\pm6\sqrt3u\) of \(K\) produce the exponentially large and small terms of the
> expansion, while the rank-two zero block---the one carrying the primitive-sixth formal
> monodromy---is regular singular and produces the algebraic terms.

Checked in three ways.

- **Spectrum of `K`.** `sympy` on the transcribed matrix gives characteristic polynomial
  `rho^2 (rho^2 - 108 q)` and eigenvalues `{6 sqrt3 sqrt q, -6 sqrt3 sqrt q, 0 (mult. 2)}`. With
  `q = u^2` these are `+-6 sqrt3 u`, as claimed. Also `rank K = 3` and `rank K^2 = 2`, so the
  eigenvalue 0 has geometric multiplicity 1 and algebraic multiplicity 2: it is a **single**
  rank-two Jordan block, confirming the earlier subsection's assertion.
- **Exponential side.** For `z^2 d_z S = (K + zG)S` a scalar eigenvalue `lambda` gives
  `S ~ e^{-lambda/z}`, so the exponential factors are `e^{-+ 6 sqrt3 u / z}`. From the Barnes side,
  `kappa = q_DLMF - p + 1 = 2` and the exponential terms are
  `exp(kappa * (z_DLMF)^{1/kappa})` with `z_DLMF = -x = -27q/z^2`. Taking `x > 0` (the regime
  `z -> 0`, `q > 0`), `ph(z_DLMF) = +- pi`, and the two terms `E(z_DLMF e^{-+ pi i})` give
  `exp(+- 2 sqrt(x)) = exp(+- 2 sqrt(27 q)/z) = exp(+- 6 sqrt3 u / z)`. Exact match, both magnitude
  and the fact that there are exactly two of them (one large, one small).
- **Elementary cross-check.** `(3d)!/(d!)^5 ~ 27^d/(d!)^2` by Stirling, so `F(t)` behaves like
  `I_0(2 sqrt(27 t))`, i.e. `F(q/z^2) ~ e^{6 sqrt3 u/z}` on the positive axis — the same growth
  rate, independently of DLMF.
- **Algebraic side.** `H_{q-1,q}` contributes the pure powers `z^{-a_m-k}`, which are the
  regular-singular (algebraic) terms; these are the ones attached to the `kappa`-free part of the
  expansion, i.e. to the block with no exponential factor — the rank-two zero block of `K`. The
  correspondence "exponential blocks <-> nonzero eigenvalues of `K`, regular-singular block <->
  zero eigenvalue" is the standard Levelt–Turrittin splitting for `z^2 d_z S = (K + zG)S` with `K`
  having distinct nonzero eigenvalues plus a zero block. Correct as stated.

The sentence "The packet in question is therefore read from the algebraic part alone" follows.

### 10. From section to row: the half-turn pairs `lambda` with `lambda^{-1}` — CONFIRMED, with two remarks

Text judged:

> The row is \(v\mapsto[v,s_X(\OO_p))\), and \eqref{eq:flat-euler-pairing} is nondegenerate;
> because of the half-turn \(z\mapsto e^{-\pi i}z\) in its first slot, it pairs a formal line of
> monodromy \(\lambda\) with the line of monodromy \(\lambda^{-1}\). ... Both coefficients are
> nonzero here, so the conclusion is the same for both packets and does not depend on resolving
> which line is paired with which.

`eq:flat-euler-pairing` is verbatim Iritani (1.7), `[s1,s2) = (s1(tau, e^{-pi i} z), s2(tau,z))`,
with `[s(V1),s(V2)) = chi(V1,V2)`, and Iritani states it is nondegenerate. The manuscript's import
is faithful.

**The conclusion is right.** `[s1,s2)` is independent of `z` (that is what the half-turn buys), so
it is invariant under the monodromy `M : z -> e^{2 pi i} z` acting on both slots:
`[M s1, M s2)(z) = [s1,s2)(e^{2 pi i} z) = [s1,s2)`. Hence if `M s_i = lambda_i s_i` then
`lambda_1 lambda_2 [s1,s2) = [s1,s2)`, so the pairing vanishes unless `lambda_1 lambda_2 = 1`.
Concretely, for lines with leading behavior `z^{rho_1}`, `z^{rho_2}` the pairing behaves like
`e^{-pi i rho_1} z^{rho_1 + rho_2}`, constant only if `rho_1 + rho_2 in Z`. Here
`-5/6 + (-1/6) = -1 in Z`, while `-5/6 + (-5/6) = -5/3` and `-1/6 + (-1/6) = -1/3` are not. So on
this rank-two block the pairing is strictly off-diagonal, pairing the `zeta_6` line with the
`zeta_6^{-1}` line. Exactly as claimed, and the "does not depend on resolving which line is paired
with which" is then trivially true because both coefficients are nonzero.

**Remark A (wording).** "because of the half-turn ... it pairs `lambda` with `lambda^{-1}`" states
the right conclusion but the mechanism is monodromy-invariance of a `z`-independent pairing; the
half-turn is what makes the pairing `z`-independent in the first place. Defensible, but a reader
checking the logic has to supply the intermediate step.

**Remark B (unstated step).** The argument needs the pairing restricted to the rank-two block to be
nondegenerate, not just globally nondegenerate. That follows because the block pairs only with
itself (the exponential blocks pair with the opposite-exponential blocks, and the `lambda lambda' = 1`
constraint isolates the `+-6 sqrt3 u` pair from the zero block), so global nondegeneracy restricts.
This is one sentence that is currently missing.

**Remark C (the inference from a scalar to a vector component).** The lemma computes only the
scalar `Z_p = (s_X(O_p), 1)_X`, but the conclusion is about the components of the vector
`s_X(O_p)` along the two formal lines. The inference is valid in the direction used: writing
`s_X(O_p) = sum_i c_i S_i` in a formal basis, a nonzero `z^{-5/6}` coefficient in `Z_p` forces
`c_i != 0` for the `-5/6` line, because the only other regular-singular solution contributes powers
in `-1/6 + Z` (distinct mod `Z`) and the remaining solutions carry exponential factors. Correct,
but again asserted rather than shown; the "distinct modulo the integers" clause earlier is doing
this work and could be pointed at explicitly.

### 11. Do `C` and `k` really absorb every glossed discrepancy? — CONFIRMED; I can pin them

Text judged:

> The accumulated factors---\((2\pi)^{-3/2}(2\pi i)^3\), the sign convention relating
> \(L_X(0,z)\) to \(J\), and the overall power of \(z\) in the \(I\)- and \(J\)-function
> conventions---are a nonzero constant times an integral power of \(z\).

This was the item most at risk, since a half-integral `z`-power hidden in a convention would shift
`-5/6, -1/6` by `1/2` to `-4/3, -2/3` and destroy the match with the indicial roots. It survives.

- **The `(2 pi)^{-3/2}` factor is `z`-free.** Verified directly against Iritani (1.6) in the cached
  text: the normalization is `(2 pi)^{-n/2}`, not `(2 pi z)^{-n/2}`. This is the one place where a
  common variant convention *would* have injected `z^{-3/2}`. It does not. The manuscript's
  `eq:gamma-framed-section` reproduces Iritani's factor ordering and content exactly.
- **The only half-integral power in the whole derivation is `z^{-mu}[p] = z^{-3/2}[p]`,** and that
  is fixed by the same convention (item 3).
- **`L` versus `J`.** Iritani's `J_X(tau,z) = L(tau,z)^{-1} 1` has leading term `1`, whereas
  Givental's `I` in `eq:cubic-i-function` has leading term `z`. The discrepancy is `z^{+-1}` —
  integral, exactly as the manuscript says.
- **Putting it together.** Using `(L(tau,-z)a, L(tau,z)b) = (a,b)` and `J = L^{-1}1`,

      (L(0,z)[p], 1) = ([p], J(0,-z)) = coefficient of 1 in J(0,-z)
                     = (1/(-z)) * [coefficient of 1 in Givental's I at -z]
                     = (1/(-z)) * (-z) F(q/(-z)^2) = F(q/z^2),

  since `F(q/z^2)` is even in `z`. Hence

      Z_p(z) = (2 pi)^{-3/2} (2 pi i)^3 z^{-3/2} F(q/z^2) = -i (2 pi)^{3/2} z^{-3/2} F(q/z^2),

  i.e. `C = -i (2 pi)^{3/2}` and `k = 0` under Iritani's stated conventions. So not only is `k` an
  integer, it is zero; the lemma is safe by a comfortable margin.
- **Residual risk.** The only remaining assumption is the exact sign convention in the flatness
  identity `(L(-z)a, L(z)b) = (a,b)` versus `(L(z)a, L(-z)b) = (a,b)`; either way the discrepancy is
  `z -> -z`, which is a phase, not an exponent shift, and the manuscript already disposes of that in
  the paragraph beginning "Only the fractional part of the exponent of `z` is used below".

**Verdict:** the lemma's `C` and `k` do absorb every discrepancy the proof glosses, and none of the
glossed factors can be a non-integral power of `z`. The proof would be materially stronger if it
recorded the `(2 pi)^{-n/2}`-not-`(2 pi z)^{-n/2}` point in one clause, since that is the single
place where the argument could have failed.

---

## Consistency of the "primitive-sixth block" indicial computation with the Barnes exponents

**CONSISTENT — and exactly, not merely modulo `Z`.**

- `eq:cubic-indicial-polynomial` expands correctly: `sympy` gives
  `(rho + 19/18)(rho - 1/18) + 16/81 = rho^2 + rho + 5/36` (the constant is
  `-19/324 + 64/324 = 45/324 = 5/36`).
- Its roots are `-5/6` and `-1/6` (`sympy`: `[-5/6, -1/6]`), matching line 44.
- Formal monodromy `e^{2 pi i rho}`: `rho = -1/6 -> zeta_6^{-1}`, `rho = -5/6 -> zeta_6`, matching
  the order in which line 44–45 lists them.
- The Barnes exponents computed in item 8 are `-5/6` and `-1/6` on the nose. The two routes are
  genuinely different: the connection route produces them from `M_1 = diag(-19/18, 19/18)` and the
  Sylvester correction `(R_2)_{21} = -16/81`; the Barnes route produces them from `-3/2` (the
  grading operator) plus `2/3` or `4/3` (the hypergeometric parameters `1/3, 2/3` against the
  quadratic substitution `x = 27q/z^2`). Their agreement is a meaningful cross-check on both the
  transcription of Cai's matrices and the Gamma-framing normalization.

**What I did not verify** in that subsection: the derivation of `M_1` and `(R_2)_{21}` themselves,
and the shift from `19/18` to `1/18` in the second factor of the indicial polynomial (which is
presumably the Jordan-link shear shifting one exponent by 1 — plausible and consistent with the
normalization "when the Jordan link is normalized to one", but I did not reproduce the block
reduction). The repository's `verification/check_cubic_endpoint.py` asserts exactly these values
(`M1W`, `B2W` with entry `Fraction(-16, 81)`, and the indicial polynomial and its roots), so they
are covered by the paper's own certificate; I am flagging only that I did not independently redo it
here. Likewise, whether `eq:cai-cubic-matrices` faithfully transcribes Cai's Section 3 is
UNVERIFIED — Cai (arXiv:2608.01577) is not in the shared literature cache and I did not fetch it.

## Recommended edits (all minor)

1. **Item 7, required.** Change "For `{}_pF_q` with `p <= q`" to "For `{}_pF_q` with `p = q-1`".
   As printed the hypothesis is false: DLMF 16.11.9 shows there is no algebraic part at all when
   `p <= q-2`.
2. **Item 5, recommended.** Either restore the `e^{(P log q)/z}` factor in `eq:cubic-i-function` or
   state that it has been absorbed into the Novikov-variable convention. Add half a sentence noting
   that the `z^{1-2d}` count uses Fano index `>= 2`, which the cubic threefold meets exactly.
3. **Item 11, recommended.** Add a clause recording that the normalization in
   `eq:gamma-framed-section` is `(2 pi)^{-dim/2}` and not `(2 pi z)^{-dim/2}`; this is the only
   convention that could have produced a non-integral `k`, and naming it closes the lemma's one
   real gap.
4. **Item 10, optional.** One sentence for why the pairing is nondegenerate *on the rank-two block*
   (the `lambda lambda' = 1` constraint isolates it), and one pointing the "distinct modulo the
   integers" clause at the scalar-to-component inference.
5. **Item 8, cosmetic.** "reduce modulo the integers to the roots" understates the result — the
   exponents equal the roots exactly.
