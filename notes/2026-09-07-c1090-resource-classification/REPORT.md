# C1090 — Pauli-spectrum resource classification of the Clebsch phase states

Date: 2026-09-07. Working directory: `notes/2026-09-07-c1090-resource-classification/`.
Inputs: `notes/2026-09-06-clebsch-quantum-replay/memo-data.md` and `common.py`
(matrices `E_7`, `E_11`, sign vector `eps`, claimed raw phase polynomials `B1`, `B2`).

Status: **complete**. Both rank censuses are exhaustive, not sampled.

---

## 0. Setup and the formula used

Fix an odd prime `p`, put `k = p-1`, `omega = exp(2 pi i / p)`. The decoded resource state is

```
|F> = p^{-k/2} sum_{u in F_p^k} omega^{F(u)} |u>,
```

with `F` the homogeneous cubic `F(u) = sum_{i=0}^{2p-1} eps_i (x_i . u)^3`, where `x_i` is the
`i`-th row of `E_p` and `eps = (+1^p, -1^p)`.

Generalized Paulis on `(C^p)^{otimes k}`: `X(v)|u> = |u+v>`, `Z(w)|u> = omega^{w.u}|u>`,
for `v, w in F_p^k`. There are `p^{2k}` such operators up to phase.

### 0.1 Reduction of the expectation to a Gauss sum

```
X(v)Z(w)|F> = p^{-k/2} sum_u omega^{F(u) + w.u} |u+v>
<F|X(v)Z(w)|F> = p^{-k} sum_u omega^{F(u) + w.u - F(u+v)}.
```

Let `T` be the symmetric trilinear polarization of `F`, so `F(u) = T(u,u,u)` and

```
F(u+v) = F(u) + 3 T(u,u,v) + 3 T(u,v,v) + F(v).
```

Hence the exponent is `-Q_{v,w}(u)` with

```
Q_{v,w}(u) = 3 T(u,u,v) + (3 T(u,v,v) - w.u) + F(v)
           = (1/2) u^T H(v) u + (c_v - w).u + F(v),
```

where `H(v)` is the **Hessian of F at v**, `H(v)_{jl} = d^2 F / du_j du_l (v) = 6 T(e_j, e_l, v)`,
and `c_v = grad F(v)`, `(c_v)_j = 3 T(e_j, v, v)`. Note the Euler-type identity

```
H(v) v = (6 T(e_j, v, v))_j = 2 grad F(v) = 2 c_v,     so  c_v in Im H(v).
```

`H(v)` is symmetric, so `Im H(v) = (rad H(v))^perp` where `rad H(v) = ker H(v)`.

Write `r(v) = rank H(v)`. Split `F_p^k = rad H(v) oplus C` with `C` a complement. On
`rad H(v)` the quadratic part vanishes identically, so the sum over that direction is
`p^{k-r(v)}` if the linear form `(c_v - w).u` vanishes on `rad H(v)`, and `0` otherwise. The
remaining sum over `C` is a nondegenerate rank-`r(v)` Gauss sum of modulus `p^{r(v)/2}`.
Therefore

```
| <F| X(v)Z(w) |F> | = { p^{-r(v)/2}   if  w - c_v in (rad H(v))^perp = Im H(v),
                       { 0             otherwise.
```

Since `c_v in Im H(v)` already, the condition is simply **`w in Im H(v)`**, independent of `c_v`.

### 0.2 The histogram formula

Let `N_r = #{ v in F_p^k : rank H(v) = r }`, `r = 0..k`. Then

* the number of Pauli pairs `(v,w)` with `|<F|X(v)Z(w)|F>| = p^{-r/2}` is `N_r * p^r`;
* all other `sum_r N_r (p^k - p^r)` Paulis have expectation exactly `0`.

**Sum-of-squares check (Parseval).** `sum_{v,w} |<F|X(v)Z(w)|F>|^2 = sum_r N_r p^r p^{-r} =
sum_r N_r = p^k`, the required value for a pure state. This is used as an arithmetic check
throughout.

Two immediate remarks.

* `v = 0` gives `H = 0`, `r = 0`, `Im H = {0}`, so exactly one Pauli (the identity) with
  `|<P>| = 1`. Any *other* `v` with `r(v) = 0` would give further modulus-1 Paulis, i.e. a
  stabilizer direction; none occur below.
* `r(v)` is invariant under `v -> t v` for `t in F_p^*` (since `H(tv) = t H(v)`), so the rank
  distribution is determined by one representative per projective point, with multiplicity
  `p-1`, plus `v = 0`.

The factor `6` in `H(v)_{jl} = 6 T(e_j,e_l,v)` is invertible mod `p` for `p >= 5`, so all rank
computations below use the unscaled matrix `T(v)_{jl} = T(e_j, e_l, v)`; ranks are identical.

---

(sections 1-5 appended as they are computed)

## 1. p = 7: exhaustive Hessian-rank census and Pauli-spectrum histogram

Scripts: `check1.py` (rebuild `F_7` from `E_7`, verify against `B1`, emit the tensor
`tensor7.txt`), `check2.py` (exhaustive census and histograms), `rank11/` (independent
Rust re-computation of the same census).

**Input validation** (`check1.py`, 1.2 s for both primes).

* `F(u) = sum_i eps_i (x_i . u)^3` rebuilt from `E_7` equals the memo's `B1` mod 7: **True**.
* Same for `E_11` vs `B2` mod 11: **True**.
* The stored tensor satisfies `d^2 F/du_j du_l = 6 * sum_m v_m A[m][j][l]` identically
  mod `p` for both primes: **True** (0 mismatches out of `k^2` entries each).

**Exhaustive census over all `7^6 = 117649` vectors `v`** (`check2.py`, 1.7 s):

| rank `r` | `N_r` = #{v : rank H(v) = r} |
|---:|---:|
| 0 | 1 |
| 1 | 0 |
| 2 | 0 |
| 3 | 48 |
| 4 | 2940 |
| 5 | 26502 |
| 6 | 88158 |
| **total** | **117649 = 7^6** |

The Rust program independently reproduces this projectively (8 / 490 / 4417 / 14693 lines at
ranks 3 / 4 / 5 / 6, total 19608 = (7^6-1)/6), a second implementation agreeing exactly.

Note `N_1 = N_2 = 0`: the memo's rank-one exclusion holds, and rank two is excluded too.

**Pauli-spectrum histogram of `|F_7>`** (6 qudits of dimension 7, `7^12 = 13841287201` Paulis):

| `|<P>|` | value | # Paulis |
|---|---:|---:|
| `7^0` | 1 | 1 |
| `7^{-3/2}` | 0.0539949 | 16464 |
| `7^{-2}` | 0.0204082 | 7058940 |
| `7^{-5/2}` | 0.0077136 | 445419114 |
| `7^{-3}` | 0.0029155 | 10371700542 |
| `0` | 0 | 3017092140 |
| **total** | | **13841287201 = 7^12** |

`sum |<P>|^2 = 117649 = 7^6` exactly (rational arithmetic): the Parseval check passes.

### Comparison resources on the same six 7-dimensional qudits

(a) the product of single-qudit cubic-phase states, `F = sum_{i=0}^{5} u_i^3`;
(b) two disjoint three-qudit "CCZ" phases, `F = u_0u_1u_2 + u_3u_4u_5`.

Rank census (all three exhaustive over `7^6` vectors, all three pass Parseval):

| rank `r` | `F_7` (Clebsch) | `sum u_i^3` | `u_0u_1u_2 + u_3u_4u_5` |
|---:|---:|---:|---:|
| 0 | 1 | 1 | 1 |
| 1 | 0 | 36 | 0 |
| 2 | 0 | 540 | 252 |
| 3 | 48 | 4320 | 432 |
| 4 | 2940 | 19440 | 15876 |
| 5 | 26502 | 46656 | 54432 |
| 6 | 88158 | 46656 | 46656 |

Pauli histograms side by side (counts of Paulis at each modulus):

| `|<P>|` | `F_7` (Clebsch) | `sum u_i^3` | `u_0u_1u_2+u_3u_4u_5` |
|---|---:|---:|---:|
| `1` | 1 | 1 | 1 |
| `7^{-1/2}` | 0 | 252 | 0 |
| `7^{-1}` | 0 | 26460 | 12348 |
| `7^{-3/2}` | 16464 | 1481760 | 148176 |
| `7^{-2}` | 7058940 | 46675440 | 38118276 |
| `7^{-5/2}` | 445419114 | 784147392 | 914838624 |
| `7^{-3}` | 10371700542 | 5489031744 | 5489031744 |
| `0` | 3017092140 | 7519924152 | 7399138032 |

**What separates the three.** The multiset `{ |<F|P|F>| : P a generalized Pauli }` is a
Clifford invariant: a Clifford unitary permutes the Pauli group up to phases, so it permutes
this multiset. Three statistics already separate `|F_7>` from both comparisons.

1. **Largest nonscalar Pauli expectation.** `7^{-3/2} = 0.05399` for `|F_7>`, versus
   `7^{-1/2} = 0.37796` for the product state and `7^{-1} = 0.14286` for the two-CCZ state.
   Equivalently `r_min = 3` versus `1` and `2`. This single number is the cleanest witness.
2. **Vanishing of the low-rank strata.** `|F_7>` has *no* Pauli with modulus `7^{-1/2}` or
   `7^{-1}` at all; both comparisons have some.
3. **Weight at the bottom of the spectrum.** `|F_7>` puts `10371700542` Paulis at the minimum
   modulus `7^{-3}`, versus `5489031744` for each comparison — the Clebsch state is much
   flatter, i.e. much closer to a Pauli-uniform state.

Statement 1 is an explicit Clifford-invariant witness that `|F_7>` is not Clifford-equivalent
to `|M>^{otimes 6}` nor to a pair of three-qudit CCZ-type states, in agreement with (and
independent of) the centroid argument that rules out direct sums.

## 2. p = 11: exhaustive Hessian-rank census

Exhaustive, not sampled. `rank11/src/main.rs` (Rust + rayon, target dir under
`~/.cache/ergodis/c1090-target`, so no build tree lives under `notes/`) enumerates one
representative per projective point of `PG(9,11)` — `v` with leading nonzero coordinate `1`,
`(11^10-1)/10 = 2593742460` of them — updating `H(v) = sum_m v_m A[m]` incrementally down an
odometer recursion and computing the rank of a `10 x 10` matrix over `F_11` at each leaf.

Timing: **82.2 s wall** on 24 cores (9450 work items), i.e. about `0.76 us` of single-core
time per projective point. The estimate that motivated the design (about 30 min on one core)
was correct to within a factor of two; no sampling fallback was needed.

Validation: the same binary run on `tensor7.txt` reproduces the `p=7` census computed
independently in Python (8 / 490 / 4417 / 14693 lines).

Exhaustive projective census, `p = 11`, `k = 10`:

| rank `r` | # projective points | `N_r` = # vectors (`= lines x 10`) |
|---:|---:|---:|
| 0 | — | 1 (`v = 0`) |
| 1-4 | 0 | 0 |
| 5 | 12 | 120 |
| 6 | 1452 | 14520 |
| 7 | 8052 | 80520 |
| 8 | 2144296 | 21442960 |
| 9 | 238748521 | 2387485210 |
| 10 | 2352840127 | 23528401270 |
| **total** | **2593742460** | **25937424601 = 11^10** |

Pauli-spectrum histogram of `|F_11>` (10 qudits of dimension 11):

| `|<P>|` | # Paulis |
|---|---:|
| `1` | 1 |
| `11^{-5/2}` | 19326120 |
| `11^{-3}` | 25723065720 |
| `11^{-7/2}` | 1569107008920 |
| `11^{-4}` | 4596488910927760 |
| `11^{-9/2}` | 5629565238216150110 |
| `11^{-5}` | 610266133922697643270 |
| `0` | 56849697687885887300 |
| **total** | **672749994932560009201 = 11^20** |

`sum |<P>|^2 = 25937424601 = 11^10` exactly: Parseval passes.

## 3. Minimum Hessian rank and the locus attaining it

| | `p = 7` | `p = 11` |
|---|---|---|
| `k = p-1` | 6 | 10 |
| `r_min` over `v != 0` | **3** | **5** |
| max nonscalar `|<P>|` | `7^{-3/2} = 0.0539949` | `11^{-5/2} = 0.00249213` |
| # vectors attaining it | 48 | 120 |
| # projective points | 8 `= p+1` | 12 `= p+1` |

In both cases `r_min = (p-1)/2 = k/2`, and the number of projective points attaining it is
exactly `p+1`.

**Identification of the locus** (`check3.py`, `check4.py`). In the memo's normal-form
coordinates the `u`-space splits as `Sym^{p-3} (binary forms of degree p-3) + <s>`:
`p=7` uses `u = (a, b, s+c, 3s+c, d, e)` with `(a,b,c,d,e)` the binomial coefficients of a
binary quartic; `p=11` uses `u = (z0, z1, 7z2, 6z3, 3s+6z4, s+3z4, 6z5, 7z6, z7, z8)` with
`z_0..z_8` the binomial coefficients of a binary octic. The minimum-rank locus is exactly

```
{ s = 0,  f = (S + cT)^{p-3} : c in F_p }  union  { s = 0, f = T^{p-3} },
```

the rational normal curve of perfect `(p-3)`-th powers inside the `Sym^{p-3}` summand,
`p+1` points. Verified: all `p+1` of these points have Hessian rank exactly `r_min`
(`3` for `p=7`, `5` for `p=11`), and the exhaustive censuses give exactly `p+1` projective
points of that rank, so the containment is an equality.

For `p = 7` these points are also the Veronese image of the base conic: writing the
`u`-coordinates in the memo's monomial order `X^2, XY, XZ, Y^2, YZ, Z^2`, the eight points
are `nu(1 : a : a^2) = (1, a, a^2, a^2, a^3, a^4)` for `a in F_7` together with
`nu(0 : 0 : 1) = (0,0,0,0,0,1)`. Explicitly:

```
1 0 0 0 0 0      1 1 1 1 1 1      1 2 4 4 1 2      1 3 2 2 6 4
1 4 2 2 1 4      1 5 4 4 6 2      1 6 1 1 6 1      0 0 0 0 0 1
```

**Symmetry and orbit structure (`p = 7`).** `PGL_2(7)` acts on the `u`-space through
`Sym^2` of its `3`-dimensional action on `(X,Y,Z)` (the conic-stabiliser embedding
`PGL_2 -> PGL_3`). Checked on generators `a -> a+1`, `a -> 1/a`, `a -> 3a`:
`F_7(S(g) v) = F_7(v)` exactly (the scalar is `1`, not merely a cube), so `F_7` is a strict
`PGL_2(7)`-invariant and the Hessian rank is constant on orbits. Applying all
`|PGL_2(7)| = 336` elements to all `19608` points of `PG(5,7)` gives `129` orbits, with rank
constant on every one:

| rank | # points | orbit sizes |
|---:|---:|---|
| 3 | 8 | `1 x 8` |
| 4 | 490 | `2 x 21, 2 x 28, 2 x 42, 1 x 56, 3 x 84` |
| 5 | 4417 | `1 x 1, 2 x 24, 8 x 84, 16 x 168, 3 x 336` |
| 6 | 14693 | `5 x 21, 6 x 28, 13 x 84, 2 x 112, 46 x 168, 16 x 336` |

So the minimum-rank locus is a **single `PGL_2(7)`-orbit of size 8**, the conic itself — the
smallest orbit in `PG(5,7)` apart from one fixed point. That fixed point is the unique
`PGL_2(7)`-invariant point `v = (0,0,1,3,0,0)`, i.e. the functional `c -> 2 c_{XZ} - c_{Y^2}`
obtained by apolarity against the base conic `Q = XZ - Y^2`; it has Hessian rank `5`, not the
minimum. (Cost of identifying the action: about 10 minutes, inside the stated budget.)

## 4. Waring-rank bracket for `F_7`

Scripts: `check5.py` (output archived in `check5-out.txt`), `check6.py`.

### 4.0 Where the existing bracket comes from

`F_7 = sum_{i=0}^{13} eps_i (x_i . u)^3` with `eps_i = +-1`, and `-1 = (-1)^3` in `F_7`, so
each signed term is literally a cube: absorb the sign into the linear form. Row index `1` of
`E_7` is identically zero, so one term drops and

```
F_7 = sum over the 13 nonzero rows of ( +- x_i . u )^3      (verified mod 7: True)
```

giving `r <= 13`. Those 13 cubes are **linearly independent** in the 56-dimensional space of
cubic forms (rank 13 of 13), so the representation on that particular column set is unique
and no sub-multiset of the 13 works. Any improvement must use different linear forms.

The classical lower bound: `rank Cat_(1,2)(F_7) = 6` (the six first partials are independent),
giving only `r >= 6`; the `r >= 7` in the memo is one step past that.

### 4.1 Lower bound: `r >= 9` from the exhaustive rank census

This is the one place where the section-1 census pays off directly.

If `F = sum_{i=1}^r c_i l_i^3` with coefficient vectors `a_i` (a shortest decomposition, so
the `[a_i]` are pairwise distinct projective points), then

```
H_F(v) = 6 sum_i c_i l_i(v) a_i a_i^T,     hence   rank H_F(v) <= #{ i : l_i(v) != 0 }.
```

The `a_i` span `F_7^6`, since `rank H_F(v) = 6` occurs. Pick any 5 linearly independent `a_i`
and let `v != 0` span their common kernel: then `rank H_F(v) <= r - 5`. The census gives
`rank H_F(v) >= 3` for every `v != 0`, so **`r >= 8`** — that is the two-line improvement.

One more step excludes `r = 8`. If `r = 8` and some 6 of the `a_i` were dependent, a `v != 0`
in the perp of their span would give `rank H_F(v) <= 2`, impossible; so every 6-subset is
independent (the 8 points form an arc in `PG(5,7)`). Then each of the `C(8,5) = 56` 5-subsets
spans a distinct hyperplane — two 5-subsets sharing a hyperplane would put 6 points in a
5-space — and each such hyperplane's perp is a point `v` with `rank H_F(v) <= 3`, hence `= 3`.
That needs 56 distinct minimum-rank points, but there are exactly **8**. Contradiction.

```
9 <= r(F_7) <= 13          (was 7 <= r <= 13)
```

The same mechanism applied to `p = 11` (`k = 10`, `r_min = 5`, 12 minimum-rank points,
`C(14,9) = 2002 > 12`) gives, as a free by-product, `15 <= r(F_11) <= 21`, where the upper
bound is the 21 nonzero rows of `E_11` (row `0` is zero; those 21 cubes are again linearly
independent in the 220-dimensional cubic space). Both computed in `check6.py`.

### 4.2 Upper bound attempt (i): the `4sI + 3J` normal form

Verified: with `u = (a, b, s+c, 3s+c, d, e)`, `F_7 = 4 s I + 3 J` mod 7 (True).
The Gram matrix of `I = ae - 4bd + 3c^2` over `F_7` has rank 5, and symmetric elimination
gives `I = 3 y_0^2 + 3 y_1^2 + y_2^2 + y_3^2 + 5 y_4^2`. With

```
s y^2 = ( (s+y)^3 + (s-y)^3 - 2 s^3 ) / 6
```

(`6` invertible mod 7), `4 s I` costs `2*5 + 1 = 11` cubes: ten forms `(s +- y_i)` plus one
`s^3`. `J = det [[a,b,c],[b,c,d],[c,d,e]]` involves no `s`, and `rank Cat_(1,2)(J) = 5`, so
the Waring rank of `J` is at least 5. The route therefore costs **at least `11 + 5 = 16`
cubes**, strictly worse than the 13 already in hand. Recorded as a measured negative: the
normal form is the wrong handle for the upper bound, because splitting off `s I` spends 11
cubes on a piece that the raw 13-term decomposition covers for free.

### 4.3 Upper bound attempt (ii): sparse search over `{0,+-1}` linear forms

There are `3^6 - 1 = 728` nonzero linear forms with coefficients in `{0,+-1}`, i.e. `364` up
to sign (over `F_7` the cubes are `{1,6} = {+-1}`, so `l` and `-l` span the same line of
cubes). Their 364 cubes span the **whole** 56-dimensional cubic space, so `F_7` is in their
span (verified True), and a solution always exists.

Search as specified: 10^4 restarts of Gaussian elimination with a random column order,
keeping the sparsest solution, then a greedy pruning pass on the best one.

| candidate pool | restarts | time | sparsest support seen | after pruning |
|---|---:|---:|---:|---:|
| the 364 `{0,+-1}` forms | 10000 | 44.5 s | 37 | 37 |
| those plus the 13 rows of `E_7` | 10000 | 55.0 s | 37 | 37 |

Support-size distribution is tightly concentrated near the information-set size: minimum 37,
maximum 56, with only 2 restarts out of 10000 reaching 37. **No improvement on 13.** This is
the expected outcome and not evidence against a short decomposition: a random information set
of 56 columns out of 364 contains a specific 12-element support with probability about
`(56/364)^12 ~ 6 x 10^{-11}`, so 10^4 Prange-style restarts have essentially no chance of
finding a short one even if it exists. The search establishes only that no short decomposition
falls out by luck.

### 4.4 Apolarity, for the record

`F^perp_2 = ker( T_2 -> S_1, y_i y_j |-> H_ij )` has dimension `21 - 6 = 15`. Its common zero
locus in `PG(5,7)` is **empty** (all 19608 points checked). Since `I(Z)_2 subset F^perp_2` for
any decomposition set `Z`, an empty `V(F^perp_2)` imposes no condition at all; the degree-2
part of the apolar ideal is too large to localise a decomposition. Improving the upper bound
would need the degree-3 part or a structured ansatz, neither of which is cheap.

**Result of task 4.** Upper bound unchanged at 13; lower bound improved from 7 to **9**, so
the bracket is now `9 <= r(F_7) <= 13`, and the bonus bracket `15 <= r(F_11) <= 21`.

## 5. Files, replay commands, and timings

All paths relative to `notes/2026-09-07-c1090-resource-classification/`.

| file | what it does | runtime |
|---|---|---|
| `check1.py` | rebuild `F_p` from `E_p`, verify vs `B1`/`B2`, verify and emit the Hessian tensors `tensor7.txt`, `tensor11.txt` | 1.2 s |
| `check2.py` | exhaustive `p=7` rank census + Pauli histograms for `F_7` and the two comparison resources; writes `minrank7.txt` | 4.1 s (3.8 s of census) |
| `check3.py` | `PGL_2(7)` action, invariance of `F_7`, conic identification, orbit decomposition of `PG(5,7)` | 3.8 s (3.9 s reported for the orbit pass alone on a colder cache) |
| `check4.py` | `p=11` Pauli histogram from the Rust census; identifies both minimum-rank loci as rational normal curves | 0.26 s |
| `check5.py` | Waring: 13-term decomposition and its rigidity, apolarity, `4sI+3J` route, `{0,+-1}` sparse search (output in `check5-out.txt`) | 118 s (44.5 s + 55.0 s in the two searches) |
| `check6.py` | `p=11` Waring bracket and the rank-census lower bounds for both primes | 0.44 s |
| `rank11/` | Rust + rayon exhaustive projective rank census | 82.2 s (24 cores) |

Replay:

```
uv run --with numpy --with sympy python check1.py     # writes tensor7.txt, tensor11.txt
uv run --with numpy --with sympy python check2.py
uv run --with numpy --with sympy python check3.py
cd rank11 && cargo build --release && cd ..
/home/tavis/.cache/ergodis/c1090-target/release/rank11 tensor7.txt  --low 3   # cross-check
/home/tavis/.cache/ergodis/c1090-target/release/rank11 tensor11.txt --low 6 > rank11-out.txt
uv run --with numpy --with sympy python check4.py
uv run --with numpy --with sympy python check5.py
uv run --with numpy --with sympy python check6.py
```

`rank11/.cargo/config.toml` sends the build tree to `~/.cache/ergodis/c1090-target`; no
`target/` directory exists under `notes/`.

**Checks that passed.** `F` rebuilt from `E_p` equals the memo's `B1`/`B2` (both primes);
Hessian tensor equals `(1/6) d^2 F` symbolically (both primes); Python and Rust rank censuses
agree exactly at `p = 7`; both censuses sum to `p^k`; both Pauli histograms sum to `p^{2k}`
operators and to `p^k` in squared modulus (exact rational arithmetic); Hessian rank is constant
on all 129 `PGL_2(7)`-orbits; the `4sI+3J` normal form and the rank-5 claim for `I` both
reproduce.

---

## What was established, and what was not

Established, by exhaustive computation rather than sampling: the Hessian-rank distribution of
the Clebsch phase cubic is `(N_0,N_3,N_4,N_5,N_6) = (1, 48, 2940, 26502, 88158)` over all
`7^6` vectors, and `(N_0,N_5,N_6,N_7,N_8,N_9,N_10) = (1, 120, 14520, 80520, 21442960,
2387485210, 23528401270)` over all `11^10` vectors, both verified against the Parseval identity
`sum_{v,w} |<F|X(v)Z(w)|F>|^2 = p^k`; the resulting Pauli-spectrum histograms; the fact that
the largest nonscalar Pauli expectation is `7^{-3/2}` for `|F_7>` against `7^{-1/2}` for six
independent cubic-phase qudits and `7^{-1}` for two disjoint three-qudit CCZ-type phases, which
is an explicit Clifford invariant separating `|F_7>` from both and confirming the centroid
argument's conclusion by a completely different route; that the minimum-rank locus is in both
cases exactly the `p+1` points of the rational normal curve of perfect `(p-3)`-th powers at
`s = 0`, a single `PGL_2(p)`-orbit (checked as an orbit computation for `p = 7`, where `F_7`
turns out to be a strict `PGL_2(7)`-invariant, not merely invariant up to scalar); and a
Waring-rank lower bound `r(F_7) >= 9`, improved from 7 by the rank census itself, together with
`r(F_11) >= 15` and `r(F_11) <= 21` by the same argument at the other prime.

Not established: no improvement to the Waring upper bound `r(F_7) <= 13`. The `4sI + 3J` route
provably cannot beat it (it costs at least 16 cubes), the degree-2 apolar ideal gives no
localisation because its zero locus in `PG(5,7)` is empty, and 10^4 random-information-set
eliminations over the 364 cubes of `{0,+-1}` linear forms never got below 37 — which, given the
`~6 x 10^{-11}` per-restart hit probability for a 12-element support, says nothing about whether
a decomposition of length 9-12 exists. Closing the remaining gap `9 <= r(F_7) <= 13` needs
either the degree-3 apolar ideal or a genuine short-support search (meet-in-the-middle or an
exact solver), neither of which was in scope here. The `p = 11` orbit structure was also not
computed: only the minimum-rank stratum was identified, and the analogue of the `PGL_2(7)`
orbit decomposition of `PG(9,11)` is out of reach by the direct method used at `p = 7`.
