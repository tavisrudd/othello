# C1099 — Cubic-phase codes: magic content, distance-three search, and the family question

Date: 2026-09-07. Working directory: `notes/2026-09-07-c1099-cubic-phase-strengthening/`.
Inputs: the C1090 resource classification (`../2026-09-07-c1090-resource-classification/`),
the transcribed matrices in `../2026-09-06-clebsch-quantum-replay/common.py`, the memo's
sections 1.1, 9.2, 9.3, and Paper II sections 3 and 4.

Status: **all three tests complete**, including the exhaustive p = 19 matching search.

## 0. Verdicts

| test | verdict |
|---|---|
| 1. magic content | **Yes, and exact.** The Clebsch state `|F_7>` has stabilizer Rényi entropy `M_2 = log(1977326743/78835) = 10.130` nats against `6 log(49/13) = 7.961` for six cubic-phase qudits and `8.805` for two CCZ blocks; `|F_11>` has `22.870` against `17.513` and `18.834`. `|F_11>` exceeds the additive product bound of every bipartition of its ten qudits, so it is not Clifford-equivalent to any product state; `|F_7>` does not (its `10.130` is below the `(1,5)` bound `10.423`), but two other conic trades at p = 7 do (section 3.1). |
| 2. distance three at p = 7 | **Exhaustive negative.** All 61 927 311 evaluation subspaces `L'` of `L` with `1 ∈ L'` and `dim L' ≥ 3` were examined; for none does the radical of the cubic form on `L'` separate the coordinates that `L'` separates, so every admissible X-space leaves a weight-two undetected Z operator. No `[[14, k', ≥3]]_7` subcode with a nonzero logical cubic exists. |
| 3. family beyond p = 7, 11 | **The code condition is strictly weaker than the geometric one, in two ways.** (a) Inside the conic-matching source, pairs of *translation classes* of matchings (not PGL₂-orbits) give further rigid `[[2p, p-1, 2]]_p` codes: three inequivalent ones at p = 7, two at p = 11, one at p = 13, none at p = 5 or 17 (exhaustive), and none at p = 19 within the AGL-symmetric subdomain. (b) Independently of conics, an explicit "translation trade" gives a rigid `[[2p, p-1, 2]]_p` code with a transversal signed cubic for **every** prime p ≥ 5, with a low-magic logical cubic. (c) Reed–Solomon evaluation spaces cannot reach length 2p over F_p without repeating points, and repetition caps the logical count at `(p-3)/2`. |

Decision and successor: section 4.

## 1. Test 1 — stabilizer Rényi magic from the exact Pauli spectra

Script `test1_magic.py`; output `out/test1.txt`.

For a diagonal cubic phase state `|F> = p^{-k/2} Σ_u ω^{F(u)} |u>` the C1090 report gives
`|<F|X(v)Z(w)|F>| = p^{-r(v)/2}` for `w ∈ Im H_F(v)` and `0` otherwise, `r(v) = rank H_F(v)`.
With `N_r = #{v : r(v) = r}` this collapses every stabilizer Rényi entropy to the Hessian-rank
distribution:

```
Σ_P |<P>|^{2α} = Σ_r N_r p^{r(1-α)},
M_α = (1-α)^{-1} log( p^{-k} Σ_r N_r p^{r(1-α)} ),     M_lin = 1 - p^{-k} Σ_r N_r p^{-r}.
```

Normalization: a stabilizer state gives `M_α = 0`; one cubic-phase qudit (`N_0 = 1`,
`N_1 = p-1`) gives `M_2 = log(p^2/(2p-1))`, i.e. `log(49/13) = 1.3269` at p = 7 and
`log(121/21) = 1.7513` at p = 11, which are the known single-qudit values and are additive
under tensor products (checked: the product rows below equal `k` times these).
The pure-state maximum is `M_2 ≤ log((p^k+1)/2)`, attained only by Pauli-flat states.
The `α → ∞` limit is `0` for every pure state (the identity dominates), so the meaningful
"max-Pauli" statistic is `r_min`, the largest nonscalar `|<P>| = p^{-r_min/2}`.

All p = 7 censuses below were recomputed from freshly generated Hessian tensors by the
C1090 Rust census (`rank11`, exhaustive over `F_7^6`); the Clebsch census reproduces C1090's
`(1, 48, 2940, 26502, 88158)` exactly. The p = 11 Clebsch census is C1090's exhaustive one;
the p = 11 comparison rows are exact by multiplicativity over tensor factors.

### p = 7, six qudits (`d = 7^6`; bound `log((d+1)/2) = 10.9823`)

| state | `r_min` | `Σ_P |<P>|^4` (exact) | `M_2` (nats) | per qudit | `M_3` |
|---|---:|---|---:|---:|---:|
| Clebsch `|F_7>` | 3 | `78835/16807` | **10.1299** | 1.6883 | 5.8372 |
| `|M>^{⊗6}` (product cubic phases) | 1 | `4826809/117649` | 7.9612 | 1.3269 | 5.4912 |
| two CCZ blocks `u0u1u2 + u3u4u5` | 2 | `2076481/117649` | 8.8047 | 1.4675 | 5.7848 |
| translation-trade cubic (section 3.2) | 2 | `2419/7` | 5.8303 | 0.9717 | 4.7980 |
| conic trade, dihedral type (section 3.1) | 3 | `58711/16807` | 10.4246 | 1.7374 | — |
| conic trade, Borel type (section 3.1) | 3 | `55327/16807` | **10.4840** | 1.7473 | — |
| `Tr_{F_{7^6}/F_7}(u^3)` (one 7^6-dimensional cubic-phase qudit) | 6 | `235297/117649` | 10.9823 | 1.8304 | 5.8377 |

Exact headline values: `exp M_2(|F_7>) = 1977326743/78835`, `exp M_2(|M>^{⊗6}) = (49/13)^6`.

### p = 11, ten qudits (`d = 11^10`; bound `23.2858`)

| state | `r_min` | `Σ_P |<P>|^4` (exact) | `M_2` | per qudit |
|---|---:|---|---:|---:|
| Clebsch `|F_11>` | 5 | `7151076991/2357947691` | **22.8695** | 2.2869 |
| `|M>^{⊗10}` | 1 | `(21/11)^10` | 17.5127 | 1.7513 |
| three CCZ blocks + one `|M>` | 1 | `4448121692301/25937424601` | 18.8344 | 1.8834 |
| conic trade, Borel type (section 3.1) | 5 | `7082101391/2357947691` | 22.8792 | 2.2879 |
| `Tr_{F_{11^10}/F_11}(u^3)` | 10 | `2 - 11^{-10}` | 23.2858 | 2.3286 |

### What this proves, and the caveat

1. **Coupled beats product, with exact rationals.** `M_2` is a Clifford invariant and is
   additive over tensor products, so `|F_7>` (resp. `|F_11>`) is not Clifford-equivalent to
   `|M>^{⊗6}` (resp. `|M>^{⊗10}`) nor to the CCZ-block resources, by a margin of `2.17`
   (resp. `5.36`) nats. This is the same conclusion as C1090's `r_min` witness, now as an
   entropy with a per-qudit reading (`1.688` vs `1.327` at p = 7; `2.287` vs `1.751` at p = 11).
2. **Product exclusion across every bipartition (p = 11).** Any state that is a product across
   a bipartition `(a, 10-a)` has `M_2 ≤ log((11^a+1)/2) + log((11^{10-a}+1)/2)`, whose maximum
   over `a` is `22.6797` (at `a = 1`). `|F_11>` has `22.8695 > 22.6797`, so it is not
   Clifford-equivalent to any product state on any bipartition of its ten qudits. At p = 7 the
   corresponding maximum is `10.4228 > 10.1299`, so the entropy alone does not exclude all
   products for the Clebsch state, but it does for the two other conic trades at p = 7
   (`10.4246` and `10.4840`; section 3.1).
3. **Caveat: the Clebsch states are not the most magic cubic phase states on their qudits.**
   The trace cubic `Tr(u^3)` of the field `F_{p^k}`, i.e. the single `p^k`-dimensional
   cubic-phase qudit written on `k` qudits, has Hessian rank `k` at every `v ≠ 0` (the bilinear
   forms `Tr(v x y)` are nondegenerate for `v ≠ 0`), so `Σ|<P>|^4 = 2 - p^{-k}` and its `M_2`
   sits `10^{-5}` below the absolute pure-state bound. The Clebsch states reach `92.2 %`
   (p = 7) and `98.2 %` (p = 11) of that bound. Whether the trace cubic itself admits a
   balanced signed `2p`-term decomposition (and hence a `[[2p, p-1, 2]]_p` code realizing it
   transversally) is open; see the ledger.

Verdict for the note: keep the "coupled resource" framing, state it as the `M_2` theorem with
the exact rationals and the bipartition bound, and state the trace-cubic comparison next to it.

## 2. Test 2 — no distance-three subcode at p = 7

Binary `search/` (`c1099 dist3`), output `out/dist3.txt`, 18.6 s on 24 cores.

**Reduction.** Fix `L' ⊆ L` with `1 ∈ L'` and let `R(L') = {s ∈ L' : T(s, L', L') = 0}` be the
radical of the restricted trilinear form; `1 ∈ R(L')` always (signed isotropy of `L`). Every
admissible X-space is a subspace `S ⊆ R(L')`, the logical cubic is nonzero iff `R(L') ≠ L'`,
and `d_X' = min wt(L' \ S) ≥ min wt(L \ <1>) = 6` automatically. For `d_Z' ≥ 3`: a weight-one
`e_i` is never in `S^⊥` once `1 ∈ S`; a weight-two vector in `S^⊥` is (up to scalar)
`e_i - e_j` with columns `i, j` of `S` equal, and it is a Z-stabilizer iff columns `i, j` of
`L'` are equal. So `d' ≥ 3` iff **the column partition of `S` equals that of `L'`**. Enlarging
`S` refines its partition, hence it suffices to test `S = R(L')`; the memo's caveat about
degenerate weight-two pairs is exactly this equality test, not a distinct-column count.

**Domain.** All subspaces `U ⊆ F_7^6` with `2 ≤ dim U ≤ 6`, `L' = <1> + E_7 U`, enumerated as
reduced row echelon forms: `Σ_{m=2}^{6} [6, m]_7 = 6 865 251 + 48 177 200 + 6 865 251 + 19 608 + 1
= 61 927 311`, matching the enumerated total exactly.

**Result.** Zero hits. Tally by `dim L'` (total / cubic vanishes on `L'` / cubic nonzero /
largest number of coordinate classes any `R(L')` achieves among the cubic-nonzero cases):

| `dim L'` | subspaces | `T|_{L'} = 0` | cubic nonzero | max classes of `R(L')` | classes of `L'` needed |
|---:|---:|---:|---:|---:|---|
| 3 | 6 865 251 | 3 690 | 6 861 561 | 7 | 6–14 |
| 4 | 48 177 200 | 16 | 48 177 184 | 13 | 8–14 |
| 5 | 6 865 251 | 0 | 6 865 251 | 7 | 12–14 |
| 6 | 19 608 | 0 | 19 608 | 1 | 13–14 |
| 7 | 1 | 0 | 1 | 1 | 14 |

In every cubic-nonzero case some pair of coordinates is separated by `L'` but not by `R(L')`
(the full tally of `(dim L', dim R, #classes L', #classes R)` is in `out/dist3.txt`). The
closest approach is `dim L' = 4` with `dim R = 2` and thirteen classes of `R` against fourteen
of `L'`. Since the enumeration is complete, this is an exhaustive negative for the memo's
section 9.2 problem at p = 7, over the stated domain (`1 ∈ L'`; the requirement `1 ∈ S` is
automatic for the maximal `S`).

**Benchmark.** The polynomial (Reed–Solomon) construction of section 3.3 gives `[[7, 1, 3]]_7`
with a transversal cubic; the Clebsch `L` contains no `[[14, k' ≥ 1, 3]]_7` analogue.

## 3. Test 3 — is there a family?

### 3.1 (a) Conic-matching source: translation classes and orbit pairs

Binary `c1099 trades P` and `c1099 orbits P`; verification `test3a_verify.py`
(`out/test3a_verify.txt`), which rebuilds every hit in pure Python from the memo's recipe
(`x_M = (P_M - P_{M_0})/Q`, exact division) and checks the code conditions independently of
the Rust code.

Method. Every perfect matching `M` of `P^1(F_p)` gives a point `x_M`; a subgroup orbit of size
`p` is necessarily a translation class `{M + j}` (for p ≥ 13 no other subgroup of `PGL_2(p)`
has an orbit of size p; for p = 5, 7, 11 the `PSL_2` sheets are translation classes too).
So the search is over unordered pairs of translation classes with equal signed moments of
orders 0, 1, 2 and different order 3; classes were bucketed by an exact `(μ_1, μ_2)` key and
candidate pairs verified exactly. Separately, all pairs of `PGL_2(p)`- and `PSL_2(p)`-orbits of
equal size were tested for p ≤ 13.

| p | translation classes (all matchings / p) | equal-`(μ_0..μ_2)` pairs with `μ_3` different | `AGL(1,p)`-inequivalent | `PGL_2` orbit pairs | `PSL_2` orbit pairs |
|---:|---:|---:|---:|---:|---:|
| 5 | 3 | 0 | 0 | 0 | 0 |
| 7 | 15 | 6 | **3** | 0 | 4 (Clebsch, plus three `42`-point pairs of size-21 orbits, affine rank 7) |
| 11 | 945 | 3 (one bucket of three classes) | **2** | 0 | 254 (sizes 11, 55, 66, 110, 165, 330; longer codes) |
| 13 | 10 395 | 6 | **1** | 0 | 0 |
| 17 | 2 027 025 | 0 | 0 | — | — |
| 19 | 34 459 425 | 0 (no two classes share `(μ_1, μ_2)`) | 0 | — | — |
| 23 | not searched (the AGL-symmetric subdomain run stalled in its single-threaded enumeration and was abandoned; the full domain has `1.4 × 10^10` classes) | — | — | — | — |

The p = 19 run is exhaustive over all translation classes (`out/trades19.txt`); the p = 17 and
p = 19 buckets are all singletons, so at those primes no two translation classes even agree
in their first two signed moments.

Every hit is a `2p`-point configuration whose affine span is `(p-1)`-dimensional, so
`dim L = p` (Lagrangian) and the code is `[[2p, p-1, 2]]_p`; every hit is rigid
(`dim L^{∘2} = 2p - 1`, so `ε` is the only transversal cubic direction, as in Paper II).

| p | type | `PGL_2(p)` set-stabilizer (sheet-preserving + swapping) | `d_X` | Hessian census of the logical cubic | `r_min` | `M_2` |
|---:|---|---|---:|---|---:|---:|
| 7 | Clebsch (`PSL_2` sheets) | 168 + 168 | 6 (exact) | `(1, 48, 2940, 26502, 88158)` | 3 | 10.1299 |
| 7 | dihedral: `Ω_- = -Ω_+` | 7 + 7 | 6 (exact) | `(1, 6, 1092, 20202, 96348)` at ranks 0,3,4,5,6 | 3 | 10.4246 |
| 7 | Borel: sheets are `C_7 ⋊ C_3` orbits | 21 + 0 | 6 (exact) | `(1, 6, 588, 20286, 96768)` | 3 | 10.4840 |
| 11 | Clebsch | 660 + 660 | 8 (memo) | C1090 census | 5 | 22.8695 |
| 11 | Borel: sheets are `C_11 ⋊ C_5` orbits | 55 + 0 | ≤ 11 (sampled) | `(1, 10, 660, 23760, 20002290, 2358511760, 23558886120)` at ranks 0,5,…,10 (exact, 82 s) | 5 | 22.8792 |
| 13 | dihedral: `Ω_- = -Ω_+` | 13 + 13 | ≤ 15 (sampled) | sampled 20 000 vectors: ranks `10: 9, 11: 1507, 12: 18484` | ≥ 10 observed | not exact |

Representative matchings (partner lists, index p = ∞; `+` class first):

```
p=7  dihedral  [1,0,5,4,3,2,7,6] | [1,0,6,4,3,7,2,5]
p=7  Borel     [1,0,4,6,2,7,3,5] | [1,0,6,5,7,3,2,4]
p=11 Borel     [1,0,5,7,9,2,8,3,6,4,11,10] | [1,0,10,9,8,7,11,5,4,3,2,6]
p=13 dihedral  [1,0,4,6,2,8,3,11,5,12,13,7,9,10] | [1,0,5,7,13,2,9,3,11,6,12,8,10,4]
```

Observations.

* At p = 7 the Clebsch trade is the **least** magic of the three conic trades: its
  minimum-rank stratum is the whole conic (8 projective points, C1090), the other two have a
  single projective point of rank 3. Both non-Clebsch trades exceed every bipartition product
  bound (`10.4228`), so they are Clifford-inequivalent to any product state; the Clebsch
  state is not excluded by `M_2` alone.
* The p = 13 configuration is new: a `[[26, 12, 2]]_13` code with a transversal signed cubic,
  rigid, with a dihedral symmetry (translations and `x ↦ -x + d`, which swaps the sheets),
  and an apparently much flatter Pauli spectrum (`r_min ≥ 10` of a possible 12 in the sample).
* The translation-class source is exhausted at p = 17 and p = 19: no two of the 2 027 025
  (resp. 34 459 425) classes even share `(μ_1, μ_2)`. Together with p = 5 this makes the conic
  source a finite list `p ∈ {7, 11, 13}` for every prime up to 19.
* `PGL_2` orbit pairs never work; `PSL_2` orbit pairs of size larger than p work at p = 7
  (`[[42, 6, 2]]_7`) and p = 11 (many, lengths 110 to 660, affine ranks 10 to 16), i.e.
  non-Lagrangian codes with few logical qudits per physical qudit. At p = 11 and 13 there are
  also many `PGL_2`-orbit pairs with equal moments through order **three** (`μ_1 = 0`, equal
  nonzero `μ_2, μ_3`); these are candidates for transversal degree-four phases (memo 9.3) and
  are logged to the discovery track, not pursued here.

### 3.2 (b) A conic-free family for every prime: the translation trade

Script `test3b_family.py`; output `out/test3b.txt`.

In characteristic p the first moment of p points is translation invariant. Take `Ω_+` to be
p points with zero sum spanning a `(p-2)`-flat and `Ω_- = Ω_+ + t` with `t` outside the flat's
direction space. Then the signed moments of orders 0, 1, 2 vanish identically and the signed
third moment is `-3 t ⊙ μ_2^+`, nonzero iff the second moment tensor of one sheet is nonzero.
Explicit member: `Ω_+` = the images of the standard basis of `F_p^p` in `F_p^p/<1>` (one
`S_p`-orbit, so each sheet has a transitive symmetry), `t` = the image of `e_1`.

Verified for `p ∈ {5, 7, 11, 13, 17, 19, 23}`: `dim L = p`, distinct points, `ε ⊥ L^{∘2}`,
`ε ⊥̸ L^{∘3}`, `d_Z = 2`, and `dim L^{∘2} = 2p - 1` (rigid, contrary to the naive guess that
two parallel flats would leave a second trade). `d_X = 4` exactly at p = 5 and 7. A random
point-reflection member `Ω_- = -Ω_+ + t` passes the same checks at p ≤ 13. The logical cubic
is `F(u) = -3 (t·u) q(u)` with `q` the rank-`(p-2)` form `Σ u_i^2 + (Σ u_i)^2`: a
controlled-quadratic (controlled-Clifford) gate. Its p = 7 census `(1; 2: 16806; 5: 14406;
6: 86436)` gives `M_2 = 5.83`, below even the product cubic-phase resource.

So a `[[2p, p-1, 2]]_p` code with a transversal signed cubic exists for every prime p ≥ 5, by
a two-line construction. What the exceptional conic trades add is not the code parameters
but the magic: `r_min = (p-1)/2` and `M_2` within 2–8 % of the pure-state bound, against
`r_min = 2` for the translation trade.

### 3.3 (c) Reed–Solomon / GRS evaluation spaces with weights

Script `test3c_rs.py`; output `out/test3c.txt`.

Single-copy polynomial codes on the p affine points (X-space `RS_a`, evaluation space `RS_b`,
weights `w ⊥ RS_a ∘ RS_b ∘ RS_b`, logical cubic nonzero iff `w ⊥̸ RS_b^{∘3}`) give, with exact
distances at p = 7 and MDS values otherwise, the best `k` at each distance:

| p | d = 2 | d = 3 | d = 4 | d = 5 | signed `±1` weight exists |
|---:|---|---|---|---|---|
| 7 | `[[7, 2, 2]]` | `[[7, 1, 3]]` | — | — | yes for both |
| 11 | `[[11, 4, 2]]` | `[[11, 3, 3]]` | `[[11, 1, 4]]` | — | yes except `[[11,1,4]]` |
| 13 | `[[13, 5, 2]]` | `[[13, 4, 3]]` | `[[13, 2, 4]]` | `[[13, 1, 5]]` | yes |

At distance 2 the pattern is `k = (p-3)/2`; at distance 3 it is `k = (p-5)/2` (this is the
qudit polynomial-code family of Campbell–Anwar–Browne type, with the weight freedom of memo
9.3, and it is the benchmark that Test 2 failed to match at length 14).

Length `2p` over `F_p` is reachable by GRS only by repeating evaluation points. With every
point used twice and `1 ∈ L`, the two multipliers of a repeated point coincide, so the weight
condition only sees `w̄(α) = w_i + w_j`, the logical cubic equals that of the single-copy code
with weights `w̄`, and the doubled positions contribute only weight-two Z-stabilizers. Hence
the logical count is capped at `(p-3)/2` at distance 2 (verified numerically: `k ≤ 2, 4, 5`
at p = 7, 11, 13), against `p - 1` for every trade code. Weighted GRS at length `2p` is
therefore not a competitor of the trade construction; the trade codes carry more than twice
the logical qudits at the same distance and length, and the distance-2 GRS codes of length p
carry `(p-3)/2` logical qudits in half the length.

## 4. Decision

**Category: strong construction paper**, by the card's rule (a magic theorem from Test 1 and
hits in Test 3), but with a different centre of gravity than C1090 assumed. The defensible
contents are now:

1. the trade-to-code dictionary with the general existence theorem (translation trade, every
   prime), so that `[[2p, p-1, 2]]_p` with a transversal signed cubic is a family, and the
   rigidity statement `dim L^{∘2} = 2p - 1` holds for every member found;
2. the magic theorem: `M_α` of any diagonal cubic phase state is a function of the Hessian
   rank distribution, the exact values for the Clebsch and the two other conic trades, the
   product/CCZ comparison, and the bipartition product-exclusion for `|F_11>` and for the
   two non-Clebsch p = 7 trades;
3. the exact classification of the conic-matching source up to p = 17 (translation-class
   pairs and orbit pairs), with the new p = 13 code and the two non-Clebsch trades at p = 7 and
   one at p = 11, all with their `PGL_2` stabilizers and rank censuses;
4. the exhaustive distance-three negative at p = 7 and the Reed–Solomon benchmark;
5. the Waring bracket and the factory with exact enumerators, carried over from C1090.

The Clebsch trades keep their distinguished role through symmetry (`PGL_2(p)` against
dihedral or Borel stabilizers), the invariant-theoretic normal forms, and the rational-normal-
curve extremal locus, but not through code parameters or through being the most magic member.

**Title recommendation** (author's call; conventional terminology only):
*Strength-two trades, transversal cubic gates, and the magic of the Clebsch codes* — or,
closer to C1090's working title, *Quadratic trades as certificates for coupled cubic-phase
quantum resources*, which still fits if "coupled" is read through the `M_2` theorem.

**Successor.** The writing task is allocated as C1102 (`clebsch`, queued): forward-citation
closure on Haah 2018, Campbell–Howard 2017, Krishna–Tillich 2019, Prakash–Saha 2025, plus
Campbell–Anwar–Browne 2012 and the stabilizer-Rényi-entropy literature (Leone–Oliviero–Hamma
2022 and its qudit extensions), is its first gate; no manuscript text before that gate.

## 5. Files, replay, checks

All paths relative to this directory. Rust target directory is
`~/.cache/ergodis/c1099-target` (via `search/.cargo/config.toml`); no build tree under `notes/`.

| file | what | runtime |
|---|---|---|
| `search/` (`c1099 dist3`) | Test 2 exhaustive subspace search | 18.6 s (24 cores) |
| `search/` (`c1099 trades P [--sym]`) | Test 3(a) translation-class search | p ≤ 13: < 1 s; p = 17: 9.7 s; p = 19 full: 4 m 51 s (24 cores) |
| `search/` (`c1099 orbits P`) | Test 3(a) `PGL_2`/`PSL_2` orbit pairs | p = 13: 65 s |
| `test1_magic.py` | Test 1 entropies (calls C1090's `rank11`) | 3 s |
| `test3a_verify.py` | independent rebuild and invariants of every hit; censuses | 3 m 15 s (two p = 11 censuses) |
| `test3b_family.py` | translation trade for p ≤ 23 | 9 s |
| `test3c_rs.py` | Reed–Solomon table and doubling cap | 26 s |
| `conic.py` | shared exact conic recipe, linear algebra mod p | — |
| `out/*.txt` | raw outputs; `out/t*.txt` are the Hessian tensors fed to `rank11` | — |

Replay:

```
cd search && cargo build --release && cd ..
B=~/.cache/ergodis/c1099-target/release/c1099
$B dist3 > out/dist3.txt
for p in 5 7 11 13 17; do $B trades $p > out/trades$p.txt 2>&1; done
choom -n 1000 -- $B trades 19 > out/trades19.txt 2>&1          # 34.5 M classes
for p in 5 11 13; do $B orbits $p > out/orbits$p.txt 2>&1; done
uv run --with numpy python test1_magic.py | tee out/test1.txt
uv run python test3a_verify.py 7 11 13 | tee out/test3a_verify.txt
uv run python test3b_family.py | tee out/test3b.txt
uv run python test3c_rs.py 7 11 13 | tee out/test3c.txt
```

Checks that passed: the p = 7 Clebsch census regenerated from `E_7` by `test1_magic.py`
equals C1090's; the Rust conic recipe reproduces the Clebsch pair as a hit at p = 7 and
p = 11 and `test3a_verify.py` rebuilds it in Python with the C1090 census exactly; the
Test 2 subspace count equals the Gaussian-binomial total; product rows equal `k` times the
single-qudit entropy; every hit's signed moments were rechecked independently in Python;
the doubling cap in 3.3 matches the predicted `(p-3)/2` at all three primes.

Not independently replayed: the exhaustive Test 2 negative has only its count check and
the internal consistency of its tally (no second implementation); the p = 13 Hessian census
is sampled, not exhaustive; `d_X` for the new p = 11 and p = 13 codes is only an upper bound.

## 6. Mystery ledger (`ej` + `tt` closeout)

1. **Is the trace cubic realizable?** `Tr_{F_{p^k}/F_p}(u^3)` is the most magic cubic on
   `k = p - 1` qudits (Hessian rank `k` everywhere). The rank-census Waring argument only
   forces `r ≥ 2k - 1 = 2p - 3` cubes, so a balanced signed `2p`-term decomposition is not
   excluded. Open; the natural next computation is a search for `2p`-point trades whose
   logical cubic is Clifford-equivalent to the trace cubic (compare Hessian censuses first).
   Owner: the writing task can state it as a question; a search would be a new C item.
2. **Why does the conic source stop?** Translation-class trades exist at p = 7, 11, 13 and
   not at 5 or 17 (and not in the AGL-symmetric part of 19). The dihedral members
   (`Ω_- = -Ω_+`) at 7 and 13 and the Borel members at 7 and 11 suggest character-sum
   conditions on the matching; no mechanism was derived. Open; the evidence is exhaustive
   through p = 19, the gap is a proof (and p = 23, whose full domain is out of reach by this
   method).
3. **Why is the Clebsch trade the least magic conic trade at p = 7?** Settled descriptively:
   its minimum-rank locus is the whole conic (8 points) while the other two have one point;
   the `PGL_2(7)` symmetry forces the large locus. Not settled conceptually (no bound linking
   symmetry to `r_min` multiplicity).
4. **Strength-three orbit pairs.** `PGL_2(11)` and `PGL_2(13)` orbit pairs of sizes 660 and
   1092 with `μ_1 = 0` and equal `μ_2, μ_3`: candidates for transversal degree-four phases on
   very long codes. Incidental; logged to the discovery track; whether the signed `μ_4` is
   nonzero was not checked.
5. **Exact `d_X` and exact p = 13 census.** Both are well-defined finite computations
   (a proper minimum-weight algorithm; a `13^12`-point census, about a day at C1090's rate).
   Gap only, no mystery.
6. **Rigidity is generic.** Every trade found, including the trivial translation trade, has
   `dim L^{∘2} = 2p - 1`. Paper II's rigidity therefore does not distinguish the exceptional
   configurations at the code level; only the symmetry and the magic do. Settled by
   computation; a one-line proof for the translation trade would be a free upgrade for the
   note.
