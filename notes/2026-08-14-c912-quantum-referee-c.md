# Quantum Referee C — independent recomputation (C912)

**Date**: 2026-08-14
**Paper**: `papers/cubic-stabilization-m1/`, `sections/04-one-step.tex`
**Charge**: recompute, from scratch, (1) the cubic-threefold value of the framed
sixth-root multiplicity `nu_6` asserted in `prop:cubic-packet`, and (2) the
divisor-tagging endpoint (`lem:divisor-tagging` with
`def:strict-novikov-admissible`). Manuscript used for setup and conventions only;
every intermediate re-derived.
**Read-only**: nothing under `papers/` was modified.

---

## Overall verdict: **GO**, conditional on one moderate repair

- **Recomputation 1 (cubic block, `prop:cubic-packet`): CONFIRMED.** Every
  intermediate quantity in the manuscript — connection matrices, change of basis,
  determinant, block reduction, `D_0`, `E_0`, indicial polynomial, roots, framed
  eigenvalues, the rank-one unramifiedness, the Frobenius recursion matrix and its
  determinant — reproduces exactly under independent derivation. No discrepancy in
  value, sign, normalization, or convention. `nu_6(X) = 2` is correct.
- **Recomputation 2 (divisor tagging, `lem:divisor-tagging`): CONFIRMED with a
  moderate gap.** The lemma's conclusion is right and the mechanism is right, but
  the proof never places the tagged module's *own* framed operator in the same
  coefficient ring as the base-shift lemma's transported operator, so the middle
  link of the chain `p^int = p^tag = p^spec` is asserted rather than established.
  The repair is cheap and is already built elsewhere in the same section (the
  graded Hahn receiver of `prop:framed-operations`); I verify below that it works.
  Separately, the manuscript's explicit accounting of where the
  domain-associated-graded hypothesis is consumed is wrong at both of the two
  places it names — the hypothesis is in fact consumed at neither.

---

## Recomputation 1 — the cubic block

### 1.1 The small even quantum connection, derived independently

`X` is a smooth cubic threefold, `H^even(X) = C<1, P, P^2, P^3>` with `P` the
hyperplane class, `int_X P^3 = 3`, `c_1(X) = 2P`. Numerical curve lattice
`N_1(X) = Z*l` with `P.l = 1`, Novikov variable `q = Q^l`, `deg_C q = c_1.l = 2`.
Poincaré pairing: `g(1,P^3) = g(P,P^2) = 3`, all other pairs of even classes zero.

Small quantum multiplication by `P`, matrix `M` in the ordered basis
`(1, P, P^2, P^3)` (columns = images):

- `P * 1 = P`.
- `P * P = P^2 + a q`, `P * P^2 = P^3 + b q P`, `P * P^3 = c q P^2 + e q^2`
  (forced by the grading `deg_C q = 2`).
- `a`: divisor axiom twice gives `a = (1/3) <P,P^3>_{0,2,1} = (1/3) <P^3>_{0,1,1}
  = (1/3)*3*<pt>_{0,1,1} = <pt>_{0,1,1} = 6`, the classical count of **six lines
  through a general point of a smooth cubic threefold**.
- Frobenius (self-adjointness of `*`) applied to `g(P*P^3, P) = g(P^3, P*P)` gives
  `3cq = 3aq`, so `c = a = 6`.
- `b` and `e` from **Beauville's complete-intersection quantum relation**
  `h^{*(n+1)} = (prod d_i^{d_i}) q h^{*(sum d_i - r)}`, which for `(n,r,d) = (3,1,3)`
  reads `P^{*4} = 27 q P^{*2}`. (Cross-check of the formula on the quadric
  threefold: `h^{*4} = 4qh`, the standard relation for `Q^3`.) Expanding
  `P^{*4} = (c+a+b) q P^2 + (e + a(a+b)) q^2` against
  `27q P^{*2} = 27q(P^2 + aq)` gives `c+a+b = 27 => b = 15`, and
  `e + 6*21 = 27*6 => e = 36`.

Hence, independently of the manuscript,

```
M = [[0, 6q, 0, 36q^2],
     [1, 0, 15q, 0],
     [0, 1, 0, 6q],
     [0, 0, 1, 0]],      K_X = c_1 * = 2M.
```

Grading operator `mu|_{H^k} = (k - 3)/2`, i.e. `mu = diag(-3/2,-1/2,1/2,3/2)`.
With `nabla_{z d_z} = z d_z - z^{-1}(c_1 *) + mu`, flat sections satisfy
`z^2 d_z S = (K_X - z mu) S`, so `G_X = -mu = (1/2) diag(3,1,-1,-3)`.
This is exactly the manuscript's (4.9a). **Matches.**

(Note the count is insensitive to the sign convention on `G_X`: flipping it sends
the indicial roots `rho` to `-rho`, and the eigenvalue pair
`{e^{i pi/3}, e^{-i pi/3}}` is closed under inversion. So `nu_6 = 2` is robust here.)

### 1.2 Constant block basis and `K_0`

`charpoly(M) = x^2 (x - 3r)(x + 3r)` with `r = (3q)^{1/2}`, so
`charpoly(K_X) = x^2 (x-6r)(x+6r)`. The `0`-eigenspace of `M` is one-dimensional
(spanned by `(0,-6q,0,1) = (0,-2r^2,0,1)`), so `0` carries a single Jordan block of
size two — the `1|1|2` partition the manuscript uses.

Eigenvectors, derived from `Mv = lambda v` with `v_3 = 1`:
`v = (lambda(lambda^2 - 21q), lambda^2 - 6q, lambda, 1)`, giving
`(6r^3, 7r^2, 3r, 1)` for `lambda = 3r` and `(-6r^3, 7r^2, -3r, 1)` for `lambda = -3r`.
The fourth column `(-7r^2, 0, 1, 0)` satisfies `M * col4 = col3`, i.e.
`K_X col4 = 2 col3`. These are exactly the four columns of the manuscript's `C`
in (4.9b). Verified symbolically: `det C = -486 r^5` and

```
K_0 = C^{-1} K_X C = diag(6r, -6r) (+) [[0,2],[0,0]].
```

**Matches (4.9b), (4.9c) including the determinant.**

### 1.3 `G_0`, the gauge, and the reduced coefficients

Computed symbolically (`C^{-1} G_X C`):

```
G_0 = [[     0,   1/18,  -2/9,  -7/(27r)],
       [  1/18,      0,  -2/9,   7/(27r)],
       [ -14/9,  -14/9, -19/18,       0 ],
       [-4r/3,    4r/3,      0,   19/18]]
```

The splitting gauge `A(z) = I + sum_{n>=1} A_n z^n` with block-off-diagonal `A_n`
is determined at order `n` by the Sylvester equation `[K_0, A_n] = B_n`. The three
diagonal blocks of `K_0` have spectra `{6r}`, `{-6r}`, `{0}`, pairwise disjoint for
`r != 0`, so `ad(K_0)` is invertible on block-off-diagonal matrices and `A_n` is
unique; the inverses involve only `1/(6r)` and `1/(6r)^2`, so
`A_n in Mat_4(C[r,r^{-1}])` as claimed. **Matches (4.9d).**

Order-by-order the reduced coefficients are
`N_0 = K_0`, `N_1 = G_0 + [K_0,A_1]`, `N_2 = [K_0,A_2] + A_1[A_1,K_0] + [G_0,A_1] - A_1`.
Since `[K_0, A_n]` is block-off-diagonal, `bd(N_1) = bd(G_0)`. Computed:

- `(G_0)_{11} = (G_0)_{22} = 0` — **the rank-one blocks have no `z^1` term**. This
  is load-bearing: a nonzero entry would give a factor `z^lambda` and could itself
  produce a primitive sixth root. Confirmed zero.
- `D_0 = bd(G_0)|_{34} = diag(-19/18, 19/18)`. **Matches (4.9e).**
- `E_0 = bd(N_2)|_{34} = [[0, -14/(81 r^2)], [-8/81, 0]]`. **Matches (4.9e).**
- Not stated in the manuscript, recorded here for completeness: the `z^2`
  coefficients of the two scalar blocks are `+19/(144 r)` and `-19/(144 r)`,
  consistent with the manuscript's `O(z^2)`.

`J_0 = [[0,2],[0,0]]` is the `34`-block of `K_0`. **Matches.**

### 1.4 Indicial polynomial and roots

Two independent routes, both giving the same answer.

**Route A (shearing, mine).** Put `T = diag(1,z)` and `Stilde_{34} = T Y`. Then
`T^{-1} N T - diag(0,z) = z [ R + O(z) ]` with

```
R = [[ d_1,  2 ], [ e_21, d_2 - 1 ]] = [[-19/18, 2], [-8/81, 1/18]],
```

so `z Y' = (R + O(z)) Y` is **regular singular** — the rank-two block carries no
exponential factor and needs no ramification of `z`. Its characteristic polynomial
is `lambda^2 + lambda + 5/36`, with `disc = 1 - 5/9 = 4/9`, roots

```
rho = -1/6 and rho = -5/6.
```

The eigenvalue difference `2/3` is not an integer: no resonance, no logarithms.

**Route B (the manuscript's coefficient comparison, checked).** With
`Stilde_3 = z^rho(1+O(z))`, `Stilde_4 = c z^{rho+1}(1+O(z))`, the coefficient of
`z^{rho+1}` in row 1 gives `rho = 2c - 19/18` and the coefficient of `z^{rho+2}` in
row 2 gives `c(rho+1) = (19/18)c - 8/81`. Eliminating `c = (rho + 19/18)/2`:
`(1/2)(rho + 19/18)(rho - 1/18) = -8/81`, i.e. `rho^2 + rho + 5/36 = 0`.
**Matches (4.9g), (4.9h), (4.9i) verbatim, including the intermediate displayed
factored form.**

### 1.5 Framed eigenvalues

`C` is `z`-independent and `A(z)`, `A(z)^{-1}` and the shearing use only integral
powers of `z`, so exponent classes mod `Z` are preserved back to the original
`z`-disc frame. The manuscript's framing convention (4.0) assigns
`Exp_V(rho) = e^{2 pi i rho}` on rational residue classes, which is the ordinary
monodromy of `z^rho`. Hence

```
Exp_V(-1/6) = e^{-i pi/3},     Exp_V(-5/6) = e^{-5 i pi/3} = e^{i pi/3}.
```

Both are primitive sixth roots of unity. **Matches (4.9j).**

### 1.6 The two rank-one factors

`z^2 d_z Stilde_± = (±6r + h_±(z)) Stilde_±` with `h_± in z^2 R[[z]]`,
`R = C[r,r^{-1}]` — the `z^1` term vanishes by §1.3. Removing the exponential
`e^{∓6r/z}` leaves `d_z u_± = z^{-2} h_± u_±` with `z^{-2}h_± in R[[z]]`, so
`u_± in 1 + zR[[z]]` is a unit and there is no `z^lambda` factor and no log. The
exponential `e^{∓6r/z}` uses only `z^{-1}` (integral), so it is single-valued for
the framed turn and the block is **unramified** with framed regular-monodromy
eigenvalue `1`. Note `r = (3q)^{1/2}` is a Novikov-coefficient extension inside
`K_X = closure(Frac C[[q]])`, not a ramification of `z` — the manuscript's
insistence on this distinction is correct and necessary. **Matches (4.9k), (4.9l).**

### 1.7 Multiplicity count

Frobenius recursion: with `Stilde_3 = z^rho sum a_n z^n`,
`Stilde_4 = z^{rho+1} sum b_n z^n`, matching coefficients of `z^{rho+n+1}` in row 1
and `z^{rho+n+2}` in row 2 gives exactly the manuscript's

```
L_s = [[s + 19/18, -2], [8/81, s - 1/18]],   det L_s = (s+1/6)(s+5/6),
```

re-derived: `det L_s = s^2 + s - 19/324 + 16/81 = s^2 + s + 5/36`. **Matches (4.9m).**
The roots differ by `2/3 not in Z`, so `L_{rho+n}` is invertible for all `n >= 1`;
`ker L_rho` is one-dimensional with nonzero first coordinate (if `a_0 = 0` then row
1 forces `b_0 = 0`), so `a_0 = 1` fixes `b_0 = (rho + 19/18)/2 = c`. One solution
per root; two independent formal solutions exhaust the rank-two space, which also
rules out any hidden exponential factor there.

Spectrum of the framed operator: `{1, 1, e^{-i pi/3}, e^{i pi/3}}`, so each
primitive sixth root has algebraic multiplicity one and

```
nu_6(X) = 1 + 1 = 2.
```

**Confirms (4.9) / (4.9n).** Only `H^even` (dimension 4) enters; `H^3` (dimension
10) is outside the small even connection, as the manuscript notes.

### 1.8 Comparison against Cai

Derivation was completed before consulting the cache; the cached text
`/tmp/persistent/tavis/lit-search/text/arXiv_2608.01577.txt` (Cai, *The cubic
threefold is symplectically irrational*, arXiv:2608.01577v1) then confirms, and
also confirms the manuscript's page citations:

- Cai p.4: same `K` and `G` as (4.9a). Manuscript citation correct.
- Cai p.4: Jordan form `Kbar = 2 * (diag(3 sqrt(3q), -3 sqrt(3q)) (+) [[0,1],[0,0]])`
  = the manuscript's `K_0`, and `Gbar = (1/18)[[0,1,-4,-14/(3 sqrt(3q))],
  [1,0,-4,14/(3 sqrt(3q))], [-28,-28,-19,0], [-24 sqrt(3q), 24 sqrt(3q), 0, 19]]`,
  which is **entry-for-entry my independently computed `G_0`**.
- Cai p.5: `M_1 = diag(0,0,-19/18,19/18)` and `M_2` rank-two block
  `[[0, -14/(243q)], [-8/81, 0]]`. Since `81 r^2 = 243 q`, this is identical to the
  manuscript's `E_0`. The manuscript merely rewrites it in `r`.
- Cai p.6: `rho^2 + rho + 5/36 = 0`, `rho = -1/6, -5/6`, "fractional powers
  congruent to `±1/6` mod `Z`". Same.

No discrepancy anywhere, in value, sign, normalization or convention.

### 1.9 Script relied on

Saved at
`/tmp/claude-1000/-home-tavis-src-othello-rust/1c33d520-efc3-4bc3-9568-446c296c49cc/scratchpad/cubic_reduce.py`;
reproduced here in full so the report is self-contained. Run with
`uv run --with sympy python3 cubic_reduce.py`.

```python
import sympy as sp

r = sp.symbols('r', positive=True); z = sp.symbols('z')
q = r**2/sp.Integer(3)                      # r = (3q)^{1/2}
M = sp.Matrix([[0,6*q,0,36*q**2],[1,0,15*q,0],[0,1,0,6*q],[0,0,1,0]])
K = 2*M                                     # c_1 = 2P
G = sp.Rational(1,2)*sp.diag(3,1,-1,-3)     # = -mu
C = sp.Matrix([[6*r**3,-6*r**3,0,-7*r**2],[7*r**2,7*r**2,-2*r**2,0],
               [3*r,-3*r,0,1],[1,1,1,0]])
Ci = C.inv()
K0 = sp.simplify(Ci*K*C); G0 = sp.simplify(Ci*G*C)

blocks = [[0],[1],[2,3]]
def bd(X):
    Y = sp.zeros(4,4)
    for b in blocks:
        for i in b:
            for j in b: Y[i,j]=X[i,j]
    return Y
def od(X): return sp.simplify(X - bd(X))

def solve_sylv(B):                          # [K0, A] = B on block-off-diagonals
    ent = [(i,j) for i in range(4) for j in range(4)
           if not any(i in b and j in b for b in blocks)]
    syms = sp.symbols('a0:%d'%len(ent))
    A = sp.zeros(4,4)
    for s,(i,j) in zip(syms,ent): A[i,j]=s
    eqs = sp.simplify(K0*A - A*K0 - B)
    sol = sp.solve([eqs[i,j] for i,j in ent], syms, dict=True)
    return sp.simplify(A.subs(sol[0]))

A1 = solve_sylv(-od(G0))
N2_bd = bd(sp.simplify(A1*(A1*K0-K0*A1) + (G0*A1-A1*G0) - A1))
D0, E0 = bd(G0)[2:4,2:4], N2_bd[2:4,2:4]
R = sp.Matrix([[D0[0,0], 2], [E0[1,0], D0[1,1]-1]])     # shearing T=diag(1,z)
lam = sp.Symbol('lam')
print(sp.factor(M.charpoly(sp.Symbol('x')).as_expr()), sp.factor(C.det()))
print(K0, D0, E0, G0[0,0], G0[1,1], N2_bd[0,0], N2_bd[1,1])
print(sp.expand(R.charpoly(lam).as_expr()), sp.solve(R.charpoly(lam).as_expr(),lam))
```

Observed output (abridged): `x**2*(x-3r)*(x+3r)`; `det C = -486*r**5`;
`K0 = diag(6r,-6r) (+) [[0,2],[0,0]]`; `D0 = diag(-19/18, 19/18)`;
`E0 = [[0, -14/(81 r**2)], [-8/81, 0]]`; `G0[0,0] = G0[1,1] = 0`;
scalar `z^2` coefficients `19/(144 r)`, `-19/(144 r)`;
indicial `lam**2 + lam + 5/36`, roots `[-5/6, -1/6]`.

### 1.10 Comparison table (Recomputation 1)

| Quantity                          | Manuscript (`04-one-step.tex`)          | Independent recomputation                | Verdict |
|-----------------------------------|-----------------------------------------|------------------------------------------|---------|
| `K_X` (4.9a), line 969            | `2*[[0,6q,0,36q^2],[1,0,15q,0],[0,1,0,6q],[0,0,1,0]]` | same (Beauville relation + 6 lines/point) | match |
| `G_X` (4.9a), line 975            | `(1/2) diag(3,1,-1,-3)`                 | `-mu`, same                              | match |
| `r`                               | `(3q)^{1/2}`                            | same                                     | match |
| `C` (4.9b), line 993              | as displayed                            | eigenvectors + Jordan chain, same        | match |
| `det C`, line 999                 | `-486 r^5`                              | `-486 r^5`                               | match |
| `K_0` (4.9c), line 1007           | `diag(6r,-6r) (+) [[0,2],[0,0]]`        | same                                     | match |
| `A_n` coefficient ring, line 1021 | `Mat_4(C[r,r^{-1}])`                    | same (Sylvester inverse uses `1/(6r)`)   | match |
| `J_0` (4.9e), line 1037           | `[[0,2],[0,0]]`                         | same                                     | match |
| `D_0` (4.9e), line 1038           | `diag(-19/18, 19/18)`                   | same                                     | match |
| `E_0` (4.9e), line 1039           | `[[0,-14/(81r^2)],[-8/81,0]]`           | same (= Cai's `[[0,-14/(243q)],[-8/81,0]]`) | match |
| rank-one `z^1` term, line 1040    | absent (`O(z^2)`)                       | `(G_0)_{11} = (G_0)_{22} = 0` confirmed  | match |
| rank-one `z^2` term               | not stated                              | `±19/(144 r)`                            | consistent |
| indicial (4.9h), line 1078        | `rho^2 + rho + 5/36 = 0`                | same, by two routes                      | match |
| roots (4.9i), line 1087           | `-1/6, -5/6`                            | same                                     | match |
| framed eigenvalues (4.9j)         | `e^{-i pi/3}`, `e^{i pi/3}`             | same                                     | match |
| rank-one blocks (4.9l), line 1123 | unramified, eigenvalue `1`              | same                                     | match |
| `L_s`, `det L_s` (4.9m), line 1149| `[[s+19/18,-2],[8/81,s-1/18]]`, `(s+1/6)(s+5/6)` | same                            | match |
| multiplicities                    | `1` each                                | `1` each                                 | match |
| `nu_6(X)` (4.9)                   | `2`                                     | `2`                                      | **CONFIRMED** |

**Verdict, Recomputation 1: CONFIRMED.** No defects. Two cosmetic notes are in the
defect list below (items 5 and 6).

---

## Recomputation 2 — the divisor-tagging endpoint

### 2.1 What is being claimed

`def:strict-novikov-admissible` (lines 711-722): `chi : Lambda_T -> A` is a monomial
map, `A` is a complete separated valued domain with domain associated graded, every
monomial has nonzero image, and `v(chi(Q^d)) = l(d)` with `l` positive and proper on
the effective numerical monoid.

`lem:divisor-tagging` (lines 736-741): if the intrinsic small even quantum
connection of `T` has no primitive-sixth framed monodromy, neither does its
specialization along `chi`.

The point of the lemma is that the center maps in the blowup formula (4.3) need not
be injective, so intrinsic vanishing for the center does not automatically transfer.

### 2.2 Reconstruction of the argument

**(a) Trivial case.** `N_1(T) = 0` forces the numerical effective monoid to be
`{0}` and `Lambda_T = C`, so `chi` is injective. Correct.

**(b) Tagging map.** `N_1(T)` is torsion-free and separated by integral divisors
(established at the top of the section), so integral divisors `D_1,...,D_rho` with
separating pairings exist. Set
`chi_t(Q^d) = chi(Q^d) exp(sum_i t_i (D_i . d))` into `A[[t]]`. The tag lies in
`Q[[t]] . 1_A`; it is a unit, and so is its inverse `exp(-...)`. `chi_t` is a
monoid character composed with `chi`, hence a ring map; it is defined on the
*completed* monoid ring because `l` is proper and `A` is complete, so each
`t`-coefficient is a convergent sum in `A`.

**(c) Finite support at the minimal valuation.** For `f = sum c_d Q^d != 0`, set
`mu = min{ l(d) : c_d != 0 }` and `S_mu = { d : c_d != 0, l(d) = mu }`. Properness
of `l` makes `{d : l(d) <= c}` finite for every `c`, so the minimum is attained and
`S_mu` is finite and nonempty. Properness also gives a positive gap between `mu` and
the next attained value, so the infinite tail genuinely lies in `F^{>mu}` — this is
needed and is implicit in the manuscript.

**(d) Initial form.** In `gr_v(A)[[t]]` (the filtration on `A[[t]]` taken
coefficientwise, whose graded pieces are `gr_v^mu(A)[[t]]`),

```
in_mu(chi_t(f)) = sum_{d in S_mu} c_d in_v(chi(Q^d)) exp(sum_i t_i (D_i . d)).
```

Each summand's coefficient `c_d in_v(chi(Q^d))` is nonzero. Note that
`v(chi(Q^d) . tag) = v(chi(Q^d))` holds for *any* filtration, since both the tag and
its inverse have valuation `0`: `v(xu) >= v(x)` and `v(x) = v(xu u^{-1}) >= v(xu)`.

**(e) Integral direction and Vandermonde.** The exponent vectors
`n(d) = (D_i . d)_i in Z^rho` are pairwise distinct for `d in S_mu` because the
`D_i` separate `N_1(T)`. Choose `a in Z^rho` off the finitely many hyperplanes
`<a, n(d) - n(d')> = 0`; substituting `t_i = a_i s` makes the exponents
`m_d = <a, n(d)>` distinct integers. If `sum_d gamma_d e^{m_d s} = 0`, the
`s`-derivatives at `0` of orders `0..|S_mu|-1` give `V gamma = 0` with
`V = (m_d^k)` Vandermonde, `det V = prod (m_d - m_{d'})` a nonzero integer. Since
`gr_v(A)` is a `C`-algebra, `det V` is invertible there and `gamma = 0`, a
contradiction. Hence the initial form is nonzero, so `chi_t(f) != 0`.
Substitution `t_i = a_i s` is a ring map, so nonvanishing after substitution implies
nonvanishing before. **`chi_t` is injective.**

**(f) `p^tag = p^int`.** `Lambda_T` is a domain and `A[[t]]` is a domain
(`A` is), so injectivity of `chi_t` embeds `Frac(Lambda_T)` in `Frac(A[[t]])`
fixing `C`. Over a common algebraic closure the `chi_t`-module *is* the scalar
extension of the intrinsic module, so the framed characteristic polynomials agree.
The section's choice-independence paragraph covers exactly this move ("unchanged
when the chosen algebraic closure of the original coefficient field is replaced by a
common algebraically closed overfield"). **This link is sound.**

**(g) `p^tag = p^spec`.** By the divisor equation, the small quantum connection at
bulk point `eta = sum_i t_i D_i in H^2(T)` equals the small connection with
`Q^d -> e^{<eta,d>} Q^d`, i.e. the `chi_t`-module. Since `eta in H^2`, the Euler
field is still `c_1` (the coefficient `1 - deg_C/2` vanishes on `H^2`), so this
identification is exact for the `z`-direction connection. `lem:formal-base-shift` is
then applied with `a_0 = 0`, `a_2^circ = 0`, `eta in F^1 B (x) H^2(T)`,
`A = k_chi`, `B = k_chi[[t]]`, `F = (t)`-adic. The lemma's normalized bulk gauge
`G` (solving `d_{eta_i} G = -z^{-1}(phi_i *_eta) G`, `G|_0 = 1`) trivializes the
`eta`-dependence of the `z`-connection by flatness, and at `eta = 0` returns the
small `chi`-connection. Its substitution (4.1) is the identity because
`a_2^circ = 0`.

I checked the mechanism against `T = P^1` to make sure the two apparently competing
descriptions really coexist: the tagged connection is the small one with
`q -> q e^t`, its leading term has eigenvalues `±2 sqrt(q) e^{t/2}`, and the gauge
that connects it to `q` contains `exp(-2 sqrt(q)(e^{t/2}-1)/z)`, whose `t^n`
coefficient carries `z^{-n}`. That is precisely the unbounded-below Laurent order
that `def:pro-laurent-gauge-group` and `rem:pro-laurent-concrete` are built to
accommodate — so the pro-Laurent apparatus is genuinely load-bearing here, not
decorative. (The `P^1` diagonal check also gives framed eigenvalues `1,1` both
before and after tagging, consistent with `nu_6(P^1) = 0`.)

**(h) Evaluation at `zeta`.** `zeta = e^{± i pi/3} in C`, and every embedding in
play fixes `C`. Given the two polynomial identities, `p^int(zeta) = 0` iff
`p^tag(zeta) = 0` iff `p^spec(zeta) = 0`, and the lemma only needs
`p^int(zeta) != 0 => p^spec(zeta) != 0`.

### 2.3 Answers to the four specific questions

**Q1. Is the definition's hypothesis set exactly what the proof consumes?**
No — it is loose in both directions, though harmlessly.

*Used but not assumed:*
- **Characteristic zero / `C`-algebra structure.** The Vandermonde step explicitly
  invokes "that field has characteristic zero" (line 785). Nothing in
  `def:strict-novikov-admissible` says `A` is a `C`-algebra or that `chi` is a
  `C`-algebra map; it says only "a monomial map `chi : Lambda_T -> A`" into "a
  complete separated valued domain". In context this is obviously intended, but as
  written the hypothesis the proof consumes is absent from the definition.
- **A positive gap above `mu`.** That the tail lies in `F^{>mu}` rather than merely
  having each term of valuation `> mu` follows from properness, but is not stated.
- **`Lambda_T` is a domain**, needed for "the intrinsic Novikov fraction field" at
  line 806. True (positive functional plus lowest-term argument) but not recorded.

*Assumed but not used:*
- **"every monomial has nonzero image"** is redundant: `v(chi(Q^d)) = l(d) < inf`
  already forces it, given the usual `v(0) = inf`.
- **"`l` positive"** is never consumed by the displayed proof; properness alone does
  all the work there. Positivity is needed upstream, so that `chi(Q^d)` is
  topologically nilpotent and the specialized quantum products converge — worth
  saying where it is used, since the proof does not use it.
- **"domain associated graded"** — see Q2.

**Q2. Where exactly does the domain hypothesis on `gr_v(A)` enter, and is the
manuscript's account correct?**
The manuscript devotes a paragraph (lines 788-798) to asserting the hypothesis is
"used twice, and only twice": (i) to supply `Frac(gr_v A)` for the Vandermonde step,
and (ii) to make `v` multiplicative so that the tag, "a unit of valuation zero",
preserves the value `l(d)`. **Both attributions are wrong; the hypothesis is
consumed at neither.**

- On (i): the Vandermonde matrix has determinant a *nonzero integer*, so it is
  invertible over any commutative `Q`-algebra by the adjugate. `gr_v(A)` is a
  `C`-algebra. Passing to a fraction field is a convenience, not a necessity, and no
  domain property is needed.
- On (ii): the tag lies in `Q[[t]] . 1_A`, a scalar series, and both it and its
  inverse have valuation `0`. For *any* filtration `v`, `v(xu) = v(x)` whenever
  `v(u) = v(u^{-1}) = 0`. Multiplicativity of `v` is not consumed.
- There is also a definitional wobble underneath. If "valued" in
  `def:strict-novikov-admissible` means what it normally means — `v` multiplicative
  — then "with domain associated graded" is automatic and redundant, and the
  manuscript's sentence "it makes `v` multiplicative on `A`" is circular. If
  "valued" is meant loosely as "filtered", the implication is correct but, per the
  previous bullet, still not used. The manuscript's own closing sentence ("Were the
  associated graded to have zero divisors, `v` would be a filtration rather than a
  valuation") shows it is aware of the equivalence, which makes the redundancy in
  the definition the more visible.

Net effect: the hypothesis is a strengthening that costs nothing — the actual center
maps in (4.3) satisfy it (the associated graded Laurent monoid ring of a torsion-free
monoid over `C` is a domain, as the manuscript checks at line 734) — but the
paragraph that claims to pin down its role is inaccurate and should be rewritten or
deleted.

**Q3. Does the evaluation at a primitive sixth root really run in both directions,
and are multiplicities preserved?**
Both directions: yes in substance, because (4.6a) and (4.6b) are asserted as
equalities of polynomials, not one-sided divisibilities, and `zeta in C` is fixed by
every embedding used. The lemma's statement is one-directional and the proof
correctly notes the converse is not needed.
Multiplicities: **not established as displayed.** (4.6a) lives over an algebraically
closed field, where multiplicity is well defined. (4.6b) is delivered by
`lem:pv-base-change` as an identity in `Ltilde_{B,F}[X]`, and `Ltilde_{B,F}` is
nowhere shown to be a domain; multiplicity of a root is not well defined over a ring
with zero divisors. The manuscript writes "with equal multiplicities" and then
immediately disclaims needing it, so nothing downstream breaks, but the phrase
overstates what has been proved. Delete it or move (4.6b) into the field receiver
described under Q4.

**Q4. Base-shift lemma: hypotheses and conclusion.**
*Hypotheses.* All are met, with `A = k_chi = closure(Frac A_val)`,
`B = k_chi[[t]]`, `F^N = (t)^N`:
- `A` is a `C`-domain (a field). ✓
- `B` is complete, separated, multiplicatively filtered over `A`, and
  `A -> L_{B,F} = lim_N (k_chi[[t]]/t^N)((z))` is injective because `A` is a field
  and the target is nonzero. ✓
- The pullback of the even quantum connection is defined over `B`, and the small
  connection over `Frac(A) = k_chi`. ✓
- Bulk coordinate `a_0 . 1 + a_2^circ + eta` with `a_0 = 0`, `a_2^circ = 0`,
  `eta = sum t_i D_i in F^1 B (x) H^2(T) subset F^1 B (x)^ H^ev(T)`. ✓
- `a_0`, `a_2^circ` constant in the positive filtration: trivially. ✓
- The units `e^{<a_2^circ,d>}` exist, form a multiplicative character, and define a
  coefficient automorphism: vacuous, all equal `1`. ✓
- The lemma's proof explicitly commits to removing `eta` "including its component in
  `H^2(T)`" (line 277), which is exactly the case here. ✓

So placing the whole tagging direction in the positive filtration is consistent with
the lemma, and the manuscript's own closing paragraph (lines 845-857) correctly
explains why the divisor substitution (4.1) and the bulk gauge are not in
competition: a filtration-constant divisor component becomes the substitution, a
positive-filtration component is gauged away, and tagging is purely the second.
That account is right.

*Conclusion.* With the identity substitution, the lemma yields: the characteristic
polynomial of the transported operator `M^bulk = G M_f^{small} G^{-1}` equals the
small (i.e. `chi`-specialized) framed characteristic polynomial, in
`Ltilde_{B,F}[X]`. The manuscript draws exactly this. **But that is not yet
`p^tag = p^spec`,** because `p^tag` was defined at line 803 as the framed
characteristic polynomial of the `chi_t`-module — an object built by
Levelt–Turrittin over `closure(Frac(A[[t]]))((z))`, whereas the lemma only ever
places the *specialized* module's framed operator in `Ltilde_{B,F}`
(`lem:pv-base-change` says "containing the framed operator `M_{f,V}(D)`", with `D`
the module over `K supset Frac(A)`, i.e. the `chi`-module). The gauge `G` is not a
gauge over `Frac(A[[t]])((z))` at all — its negative `z`-order is unbounded, which
is the whole reason for the pro-Laurent construction — so the tagged module's own
framed operator and the transported operator are never placed in one ring, and the
identification `char(M^bulk) = p^tag` is asserted rather than proved. Note also that
`Frac(A[[t]])` cannot be inside `Ltilde_{B,F}`: `t` is topologically nilpotent
there, not invertible.

*Repair, verified.* Use the same device the manuscript already builds in the proof
of `prop:framed-operations`: a graded Hahn receiver. Order
`Gamma = Z^rho (+) Z e_z` lexicographically by (total `t`-degree, a fixed lex order
on the `t`-exponents, `z`-degree); each component is a homomorphism to `Z` and they
jointly separate points, so this is an ordered abelian group. The pro-Laurent
condition — for every `N`, all but finitely many `k < 0` have `c_k in (t)^N` —
implies that for each fixed `t`-multi-index `alpha` the set
`{k < 0 : c_{alpha,k} != 0}` is finite (take `N = |alpha| + 1`). Since `t`-degrees
are bounded below by `0` and each slice is bounded below in `k`, every permitted
support is well ordered. Hence `L_{k_chi[[t]],F}` embeds in the Hahn *field*
`k_chi((Gamma))`, which also contains `A[[t]]`. Take its algebraic closure and
universal exponential field; then the `chi_t`-module's framed operator, the
`chi`-module's framed operator, and `G` all live in one field, choice independence
applies, and `p^tag = p^spec` follows with multiplicities. This is two or three
sentences of text reusing machinery already in the section.

### 2.4 Comparison table (Recomputation 2)

| Step                                            | Manuscript claim                                  | Independent check                                             | Verdict |
|-------------------------------------------------|---------------------------------------------------|---------------------------------------------------------------|---------|
| `N_1(T)=0` base case, line 744                  | nothing to tag                                    | correct (`Lambda_T = C`)                                       | match |
| tagging map (4.6), line 751                     | into `A[[t]]`, injective                          | correct; convergence needs completeness + properness           | match |
| minimal support `S_mu`, line 758                | finite, nonempty                                  | correct; also needs a positive gap above `mu` (from properness) | match, gap unstated |
| initial form, line 769                          | as displayed, coefficients nonzero                | correct                                                        | match |
| valuation preserved under the tag, line 793     | needs multiplicativity of `v`                     | **false** — holds for any filtration, `v(u)=v(u^{-1})=0`        | over-attributed |
| integral direction `a`, line 779                | avoid finitely many hyperplanes                   | correct                                                        | match |
| Vandermonde, line 782                           | needs `Frac(gr_v A)`, char `0`                    | **char `0` yes, domain no** — `det V` is a nonzero integer      | over-attributed |
| domain hypothesis "used twice, only twice", 788 | two named uses                                    | **used at neither**; hypothesis is a harmless strengthening     | DEFECT (minor) |
| `p^tag = p^int` (4.6a), line 812                | scalar extension along an injection               | correct                                                        | match |
| base-shift hypotheses, line 819                 | `a_0 = 0`, `a_2^circ = 0`, `eta in F^1`           | all satisfied with `A = k_chi`, `B = k_chi[[t]]`                | match |
| `p^tag = p^spec` (4.6b), line 826               | from `lem:formal-base-shift`                      | lemma gives `char(M^bulk) = p^spec`; `char(M^bulk) = p^tag` unproved | DEFECT (moderate) |
| "with equal multiplicities", line 843           | multiplicities preserved                          | not well defined in `Ltilde_{B,F}[X]` (no domain shown); disclaimed | DEFECT (minor) |
| substitution vs gauge, lines 845-857            | tagging uses only the gauge mechanism             | correct                                                        | match |
| lemma conclusion, line 738                      | specialization inherits absence of primitive sixth | correct once the receiver is fixed                             | **CONFIRMED (with repair)** |

**Verdict, Recomputation 2: CONFIRMED, with one moderate repairable gap.** The
conclusion is right and the strategy is right; the middle equality needs the field
receiver.

---

## Severity-ranked defect list

All line numbers in
`papers/cubic-stabilization-m1/sections/04-one-step.tex`.

1. **MODERATE — `p^tag` is never placed in the same coefficient ring as the
   transported operator.** Lines 800-829 (definition of `p^tag` at 803, the
   application at 818-824, the conclusion (4.6b) at 826). `lem:formal-base-shift`
   and `lem:pv-base-change` deliver only
   `char(G M_f^{small} G^{-1}) = char(M_f^{small})` in `Ltilde_{B,F}[X]`; nothing
   identifies `char(G M_f^{small} G^{-1})` with the framed characteristic polynomial
   of the `chi_t`-module, which is defined over `closure(Frac(A[[t]]))((z))`. The
   gauge `G` has unbounded negative `z`-order, so it is not a gauge over that field,
   and `Frac(A[[t]])` is not contained in `Ltilde_{B,F}` (`t` is topologically
   nilpotent there). Fix: replace `Ltilde_{B,F}` with the algebraic closure of the
   graded Hahn field `k_chi((Z^rho (+) Z e_z))`, ordered by `t`-degree then
   `t`-lex then `z`-degree, exactly as in `prop:framed-operations` (lines 516-553).
   I verified in §2.3 that the pro-Laurent support condition gives well-ordered
   support in that order, so the embedding exists and the repair closes the chain.
   The lemma's conclusion is not in doubt; only its proof is incomplete.

2. **MINOR — the "used twice, and only twice" paragraph is wrong at both places.**
   Lines 788-798. The Vandermonde step needs only that `gr_v(A)` is a `Q`-algebra
   (`det V` is a nonzero integer), not a domain; and the valuation is preserved
   under multiplication by the tag for any filtration, because the tag and its
   inverse both have valuation `0`, so multiplicativity of `v` is not consumed.
   Compounding this, `def:strict-novikov-admissible` (line 716) already says
   "valued", under which "domain associated graded" is automatic — so the sentence
   "it makes `v` multiplicative on `A`" is circular on the natural reading. Rewrite
   or drop the paragraph; keep the hypothesis (the center maps satisfy it anyway).

3. **MINOR — "with equal multiplicities" is unsupported at (4.6b).** Line 842-843.
   Root multiplicity is not well defined over `Ltilde_{B,F}`, which is never shown
   to be a domain. Harmless because the next clause disclaims needing it, and it
   disappears entirely under fix 1.

4. **MINOR — hypothesis set of `def:strict-novikov-admissible` is loose.** Lines
   711-722. Missing: `A` a `C`-algebra and `chi` a `C`-algebra map (the proof uses
   characteristic zero explicitly at line 785). Redundant: "every monomial has
   nonzero image" (implied by (4.5)); "domain associated graded" given "valued".
   Unused in the proof: positivity of `l` (it is needed upstream, for the
   specialized quantum products to converge — say so).

5. **COSMETIC — dangling antecedent.** Line 28: "Let `K_T` be an algebraic closure
   of its fraction field." The nearest noun is `N_1(T)`, a lattice with no fraction
   field; the intended referent is `Lambda_T`, defined two sentences earlier.

6. **COSMETIC — under-specified lemma invocation.** Line 819: "Apply
   `lem:formal-base-shift` with `eta = sum_i t_i D_i`" does not say what the lemma's
   `A`, `B` and `F` are. They are forced (`A = k_chi`, `B = k_chi[[t]]`,
   `F^N = (t)^N`), and the invocation is valid, but the reader has to reconstruct
   them. One clause fixes it.

7. **COSMETIC — the rank-two block is never called regular singular.** Lines
   1055-1083. It is (shear by `diag(1,z)`; the residue is
   `[[-19/18,2],[-8/81,1/18]]`), and the manuscript's alternative — exhibiting two
   independent formal solutions in a rank-two system, which by dimension count
   forbids any exponential factor — is rigorous as written. Saying it explicitly
   would save the reader the shearing computation.

Nothing in `prop:cubic-packet` requires any change.

---

## What I could not verify, and why

1. **Iritani's blowup theorem and the Iritani–Koto projective-bundle theorem.**
   `prop:framed-operations` rests on `[IritaniBlowup, Thm 5.18]`,
   `[IritaniKoto, Thm 5.1, Prop 5.6]`, including the fourth-version correction to
   Theorem 5.1(5) cited at line 652. Those sources were outside my charge and are
   not in the local literature cache; I checked only that the manuscript's use of
   them is internally coherent with the receiver it builds. Both `nu_6` formulas
   (4.2) and (4.3) are therefore unverified inputs here.
2. **Whether `Ltilde_{B,F}` is a domain.** I did not settle this either way. It
   matters only for defect 3 and evaporates under defect 1's fix, so I did not
   pursue it.
3. **Kuznetsov's genus-eight flop** (`cor:v14-one-step`, lines 1229-1243) and the
   `[KKPYY, Claim 6.15]` input to `prop:low-dimensional-vanishing` (line 873). Out
   of charge; not checked.
4. **`prop:low-dimensional-vanishing` itself.** I checked only the piece the tagging
   lemma feeds (`nu_6(P^1) = 0`, recomputed directly in §2.2(g) as a by-product of
   the `P^1` sanity check). The nef-canonical `z^g`-conjugation argument at lines
   871-897 was not re-derived.
5. **Cai's paper beyond Section 3.** I read the cached OCR text
   (`/tmp/persistent/tavis/lit-search/text/arXiv_2608.01577.txt`) only as far as
   needed for the line-by-line comparison in §1.8. I did not check the bulk-quantum
   extension or Cai's own irrationality conclusion, and the cache is an OCR
   reconstruction rather than the authoritative page images.
6. **Bibliography.** `papers/cubic-stabilization-m1/` has no `.bib`; the
   references are inline `\bibitem`s in `cubic_stabilization_m1.tex`. I did
   not audit citation targets beyond the Cai page numbers, which are correct
   (pp. 4-6 as claimed at lines 989, 1050, 1083, 1109, 1139, 1184-1187).

---

## Reproducibility

- Script: `cubic_reduce.py`, reproduced in full in §1.9 (also at
  `/tmp/claude-1000/-home-tavis-src-othello-rust/1c33d520-efc3-4bc3-9568-446c296c49cc/scratchpad/cubic_reduce.py`,
  which is scratch and not durable — the in-report copy is authoritative).
- Replay: `uv run --with sympy python3 cubic_reduce.py`. Runtime a few seconds.
  Output as recorded at the end of §1.9.
- Everything in Recomputation 2 is a pen-and-paper check; no script.
