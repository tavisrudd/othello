# C1023 — An effective threshold for cyclic-carrier deep holes

**Lane:** `gem-mining`
**Date:** 2026-08-31
**Status:** complete as a well-diagnosed negative.  The threshold does **not**
close, for two independent and precisely located reasons (§3, §4).  What lands
is a corrected structural picture — Lemma 1, Theorem A, and the `(1,…,1)`
complete-intersection normal form for the secant condition — plus a redirection
(§9) to the tool that is probably right.

Predecessor: `notes/2026-08-31-c1018-prs-deephole-conjecture.md` §7, whose
heuristic count this task is to make rigorous, and whose §5d fixed-locus lemma
supplies the structural setting.  Notation (`PRS_k(q)`, NRC rank `w(s)`,
persistent locus `P_r`, carrier stratum) is defined there and in
`notes/2026-08-30-c1018-hunt-prs-deepholes.md` §1, and is not restated.

Persona routing consulted: `notes/2026-07-07-named-expert-personas-context.md`
routes `papers/high_weight_grs_cosets/` to
`papers/expert-profiles/08-beyond-four-prs.md`, which was read in full and
nothing else.  Its hard-proof routing puts characteristic-aware polynomial
obstructions with Sziklai, normal-rational-curve normal forms with
Ball–Lavrauw, and covering-radius-to-deep-hole promotion with Wan–Kaipa; the
argument below is a Sziklai-shaped obstruction sitting on a Ball–Lavrauw normal
form, with the radius input imported rather than reproved.

## 0. Executive summary, stated before the details

The §7 heuristic, taken literally, **cannot** be made rigorous: it counts split
squarefree forms in the apolar space as if that space were a generic linear
subspace of the space of all binary forms, and for the cases that matter it is
not — it is contained in the multiples of the lower apolar generator.  That is
not a technical slip; it is the exact mechanism by which the persistent locus is
deep at *every* `q`, so any argument that survives it would prove something
false.  §2 replaces it.

What does work is a **torus-equivariant** count, which is available precisely
because a carrier point is an eigenvector of the order-`m` torus.  It collapses
the annihilation conditions from `d-j+1` to about `(d-j)/m + 1`, and it replaces
"split squarefree degree-`j` form" by "degree-`L` form with `L` distinct roots,
all `m`-th powers".  The resulting threshold is

```text
C_heur(r,m) = ( m^{M-1} · (M-1)! )^{1/(M-2)} ,        M = (r-3)/m + 1 ,
```

for the `a = b = 1` carriers, which is finite exactly when `M ≥ 3`.  Numerically
`C_heur(9,3) = 18` against an observed last-firing field of 13 and a clean
census from 16 up — the right constant to within the width of one field.

**The threshold does not close.**  That is the verdict, and it is a verified
negative rather than a budget failure:

* The equivariant count **fails structurally on the `M = 2` locus** — two-index
  carriers, `deg G = 1` — where the solution space for `Φ` is a single point and
  there is nothing to count.  That locus is a divisor inside every `M ≥ 3`
  stratum, and it is where three of the six known carrier orbits live:
  `(6,3)`, `(8,5)`, `(10,13)`.
* Worse, the count does not close on the `M = 3` strata either.  Exhaustive
  computation over the `(9, m=3)` stratum for `13 ≤ q ≤ 79` (§3) shows the set
  of points the argument fails to certify sitting **flat at 100–150** across a
  six-fold range of `q`, while the true exceptional deep count is 4 at `q = 13`
  and 0 above.  A residual that stable is structure, not a tail.
* Dropping equivariance gives a clean object — `V_s` is a complete intersection
  of two divisors of multidegree `(1,…,1)` in `(P^1)^{d-1}` (§4) — but its
  Lang–Weil constant is driven by the Segre degree `(d-1)!`, giving a threshold
  around `10^{14}` at `r = 9` against an observed 16.  A Betti-number bound
  would improve that to perhaps `10^6`.  Both are useless.
* And the geometric-irreducibility hypothesis any such theorem needs is **false
  exactly where the interesting behaviour is**: persistent points are deep at
  every `q`, so verifying the hypothesis per point *is* the classification
  problem restated.

`C_heur` is a mean-crossing, not a bound: it is the field at which the expected
count reaches one, with no error term, and §7 exhibits a cell — `(12,3)` — where
the carrier fires slightly *above* it.  Reading it as a threshold was the error
in the original §7.

**Consequence for the `r ≥ 11` hope, stated plainly:** no threshold is proved,
so nothing is supplied for the missing field-ranged theorem above `r = 10`.
Even granting one, §6 shows it would not have been enough: it would close one
split stratum at a time, whereas the fixed-locus lemma needs every prime-order
locus including the order-two one, whose dimension grows like `r/2` and which is
not sweepable to any of the constants in play.  The position at `r ≥ 11` is
unchanged by this task.

**What does land**, and is worth having independently of the threshold:
Lemma 1 (§1), which kills the original heuristic and reproves the persistent
locus in a line; Theorem A (§2), a verified structural reduction collapsing the
annihilation conditions from `d-j+1` to `M-L_g`; and the observation (§4) that
the secant condition is a complete intersection of two multidegree-`(1,…,1)`
divisors in `(P^1)^{d-1}`, which is the right normal form for any successor.

## 1. Why the §7 heuristic cannot be repaired as written

§7 of the C1018 report reasoned: the apolar space at level `j` has
`(q^{k_j}-1)/(q-1) ≈ q^{k_j-1}` members, the split squarefree fraction of
degree-`j` forms is `1/j! + O(q^{-1/2})`, so the expected number of split
squarefree annihilators is about `q^{k_j-1}/j!`, positive past an explicit
constant.

The second step is false in exactly the cases the argument is needed for.  Write
`s^⊥ ⊂ K[u,v]` for the apolar (annihilator) ideal of the binary form `s` of
degree `d`.  Classically `s^⊥` is a complete intersection generated by two forms
`F`, `H` of degrees `e ≤ d+2-e`, with `e = e(s)` the apolar degree, and

```text
(s^⊥)_j  =  F · K[u,v]_{j-e}  ⊕  H · K[u,v]_{j-(d+2-e)} ,
```

the sum being direct for `j ≤ d` because the first syzygy sits in degree
`e + (d+2-e) = d+2`.  Two consequences:

1. For `j ≤ d+1-e` every element of `(s^⊥)_j` is a multiple of `F`.  A product
   `F·G` is split squarefree only if `F` is.  So **if `F` is not split
   squarefree, the number of split squarefree elements at every level
   `j ≤ d+1-e` is exactly zero**, not `q^{k_j-1}/j!`.  The `1/j!` density is a
   statement about a generic subspace and `(s^⊥)_j` is never generic.
2. This is not a corner case.  It *is* the persistent locus.  `e = 2` with `F` a
   perfect square is the tangent family; `e = 2` with `F` irreducible over `F_q`
   is the conjugate-secant family.  In both, `d+1-e = d-1`, so every level up to
   `d-1` is killed by (1) and the point is deep — at **every** `q`.  An argument
   that pushed the §7 count through would therefore prove the persistent locus
   is eventually not deep, which is false for all `q`.

So the §7 count is not merely imprecise; any repair of it that does not see the
generator `F` is refuted by the persistent locus.  The correct statement of the
elementary part is:

> **Lemma 1 (apolar dichotomy).**  Let `char K > d` and let `s` have apolar
> degree `e` with lower generator `F`.
> (i) If `F` is split squarefree then `w(s) = e`.
> (ii) If `F` is not split squarefree and `e ≤ 2`, then `s` is deep.
> (iii) If `F` is not split squarefree and `e ≥ 3`, then `w(s) ≤ d-1` can only
> be witnessed at a level `j` with `d+2-e ≤ j ≤ d-1`, an interval of `e-2`
> values, and every witness involves the second generator `H` nontrivially.

*Proof.* (i) `F` itself is a split squarefree annihilator of degree `e`, and no
annihilator of lower degree exists.  (ii) and (iii) are the display above plus
the remark that `F·G` split squarefree forces `F` split squarefree. ∎

Lemma 1(ii) reproves the deepness of the persistent locus in one line and,
more importantly, tells us the counting problem only ever concerns `e ≥ 3` and
the short window `[d+2-e, d-1]`.  Every carrier orbit found in C1018 has
`e ≥ 3`: `e = 5` at `(9,13)`, `e = 4` at `(8,11)`, `e = 3` at `(10,13)`,
`e = 8` at `(15,17)`.

## 2. Theorem A: the torus-equivariant reduction

The one piece of structure a carrier has that a general syndrome does not is
that it is an eigenvector of the order-`m` torus.  Exploiting that is what makes
a small count possible at all.

**Setup.**  Let `char F_q = p > d`, let `m | q-1`, and let
`T = μ_m ⊂ F_q^*` act by `X ↦ X`, `Y ↦ ζ^{-1} Y`.  A point of the stratum
`Σ = { s : s_i = 0 unless i ≡ a (mod m) }` is a `T`-eigenvector; writing
`I = {i : i ≡ a}`, `M = |I|`, `α = min I`, `β = d - max I`, it is

```text
s  =  X^α Y^β G(X^m, Y^m),      deg G = M-1,      d = α + β + m(M-1).
```

Work with dual variables `u = ∂/∂X`, `v = ∂/∂Y` (legitimate because `p > d`).

**Theorem A.**  Let `L = u^{a'} v^{b'} Φ(u^m, v^m)` with `deg Φ = L_g` and
`j = a' + b' + m L_g`.  Then:

1. *(Splitting criterion.)*  `L` is split squarefree over `F_q` — `j` distinct
   roots, all in `P^1(F_q)` — **iff** `a', b' ∈ {0,1}`, and `Φ` has `L_g`
   distinct roots, all lying in `(F_q^*)^m`.
2. *(Row collapse.)*  In the Hankel system `H^{(j)}_s · l = 0` for this `l`, the
   row indexed by `v` is identically zero unless `v ≡ α - a' (mod m)`.  Hence
   `L ∘ s = 0` is equivalent to a system of at most `M - L_g` equations rather
   than the `d-j+1` rows the unreduced system carries.
3. *(Linearity.)*  Each surviving equation is **linear** in the coefficients of
   `Φ`, so the annihilating `Φ` form a linear subspace `Λ_s ⊆ P^{L_g}` of
   dimension at least `L_g - (M - L_g) = 2L_g - M`.

*Proof.*  (1) `u^{a'}` and `v^{b'}` contribute the roots `0` and `∞` with
multiplicities `a'`, `b'`, so simplicity forces `a', b' ≤ 1`.  Writing
`Φ(z,w) = ∏_{i}(z - c_i w)` up to scalar, `Φ(u^m,v^m) = ∏_i (u^m - c_i v^m)`,
and `u^m - c v^m` splits into `m` distinct `F_q`-rational linear factors exactly
when `c ∈ (F_q^*)^m`; factors for distinct `c_i` share no root.  Counting,
`a' + b' + m L_g = j`.

(2) Expand.  With `s = Σ_n g_n X^{α+mn} Y^{β+m(M-1-n)}` and
`L = Σ_l φ_l u^{a'+ml} v^{b'+m(L_g-l)}`,

```text
L ∘ s  =  Σ_{l,n} φ_l g_n · c(l,n) · X^{(α-a')+m(n-l)} Y^{(β-b')+m((M-1-L_g)-(n-l))},
```

with `c(l,n)` a product of falling factorials, nonzero in `char p > d`.  The
monomial depends on `(l,n)` only through `ν = n - l`, so terms sharing a value
of `ν` collapse onto one coefficient, and every monomial of `L ∘ s` has
`X`-exponent congruent to `α - a'` mod `m`.  The admissible `ν` run over
`0 ≤ ν ≤ M-1-L_g` when `α = a'` and `β ≥ b'`, giving `M - L_g` equations.

(3) Immediate: the coefficient of each surviving monomial is
`Σ_l φ_l g_{l+ν} c(l, l+ν)`, linear in `φ`. ∎

**Consequence.**  Taking `α = a' = 1`, `b' = 0` and `L_g = M-1` (the largest
value with `j ≤ d-1`) gives exactly **one** equation, so `Λ_s` is a hyperplane
in `P^{M-1}`, of dimension `M-2`.  A carrier point is certified *not deep* as
soon as `Λ_s` contains one `Φ` with `M-1` distinct roots all `m`-th powers.

**Heuristic count.**  There are `C((q-1)/m, M-1) ≈ q^{M-1}/(m^{M-1}(M-1)!)` such
`Φ` in `P^{M-1}`, and `Λ_s` is a hyperplane, so the expected number inside it is

```text
q^{M-2} / ( m^{M-1} (M-1)! ) ,    positive in mean once   q > C_heur = ( m^{M-1}(M-1)! )^{1/(M-2)} .
```

`C_heur(9,3) = (3^2·2!)^{1/1} = 18`, against an observed last-firing field of 13
and a clean census from 16 up.  That agreement is what made this route look
promising.

### 2a. Theorem A is verified, not asserted

`notes/2026-08-31-c1023-carrier-threshold-check.py` checks parts (1) and (2)
against the raw definitions — Hankel contraction for annihilation, explicit root
enumeration for splitting — with no use of the reduction being tested.  The
row-collapse claim is checked as a hard assertion: the script raises if any
Hankel row outside the residue class `v ≡ α - a' (mod m)` carries a nonzero
entry.

| carrier | `(r, m, class, q)` | stratum indices | (point, `Φ`) pairs checked | mismatches |
|---|---|---|---:|---:|
| cubic, `a=b=1`   | `(9, 3, 1, 13)`  | `{1,4,7}` | 110,715 | **0** |
| quartic, `a=b=1` | `(11, 4, 1, 13)` | `{1,5,9}` | 110,715 | **0** |
| cubic, char two  | `(9, 3, 1, 16)`  | `{1,4,7}` | 242,151 | **0** |
| `(a,b) = (0,1)`  | `(10, 4, 0, 13)` | `{0,4,8}` |  43,737 | **0** |

507,318 pairs, zero mismatches, assertion never fired.  Note the third row is
`char 2 ≤ d`, outside Theorem A's stated hypothesis `p > d`; the reduction still
held there, which is suggestive but is *not* claimed — the falling factorials
`c(l,n)` can vanish in small characteristic and the proof does not go through.

## 3. Theorem A does not close, and here is exactly why

Theorem A certifies "not deep" for every stratum point whose hyperplane `Λ_s`
meets the good-`Φ` locus.  So the set of points it *fails* to certify is an
upper bound for the deep set.  If the argument closed, that upper bound would
shrink to the persistent points as `q` grows.  It does not.

Computed exhaustively over the `(9, m=3, class 1)` stratum, counting points with
**no** torus-equivariant split squarefree annihilator of any admissible shape
and degree `≤ d-1`:

| `q` | 13 | 16 | 19 | 25 | 31 | 37 | 43 | 49 | 61 | 64 | 79 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| stratum points | 183 | 273 | 381 | 651 | 993 | 1,407 | 1,893 | 2,451 | 3,783 | 4,161 | 6,321 |
| Theorem-A upper bound, off `P_r` | 108 | 131 | 144 | 144 | 150 | 120 | 112 | 96 | 100 | 127 | 130 |
| **true exceptional deep count** | **4** | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |

The true row is the committed C1018 stratum census.  The bound is loose by a
factor of 25 or more at every field and, decisively, **it is flat**: it does not
decay across a six-fold range of `q`.  A residual that stable is not a Poisson
tail; it is structure.

Splitting the residual by support:

| `q` | 31 | 49 | 61 |
|---|---:|---:|---:|
| residual with some `s_i = 0` | 20 | 32 | 40 |
| residual with all `s_i ≠ 0` | 130 | 64 | 60 |

The first row grows linearly in `q` — a one-dimensional family.  Its points are
exactly those with the middle coefficient vanishing, i.e. support `{1,7}` with
gap 6: **a two-index carrier sitting inside the three-index stratum**.  For
`M = 2` the Consequence above gives `dim Λ_s = M - 2 = 0`, a single point, and a
single `Φ` either is or is not good — there is nothing to count.  So the
equivariant argument has no purchase on the `M = 2` locus *by construction*, and
that locus is a divisor in every `M = 3` stratum.

This is a **structural obstruction, not a missing error term**.  It also
disqualifies the mechanism for three of the six known carrier orbits outright:
`(6,3)`, `(8,5)` and `(10,13)` all have `M = 2` sparsest support (`{1,4}`,
`{1,6}`, `{0,8}`).

## 4. The unrestricted route, and why its constant is useless

Dropping equivariance, the object to count is the honest one.  `w(s) ≤ d-1`
holds iff `s` lies on a secant `(d-2)`-plane of the normal rational curve, so
set

```text
V_s  =  { (t_1,…,t_{d-1}) ∈ (P^1)^{d-1}  :  s ∈ span{ P_{t_1},…,P_{t_{d-1}} } }.
```

Since `span{P_t : t ∈ T}` has codimension 2 in `PG(d,q)`, membership is two
conditions, and the linear functionals vanishing on the `P_{t_i}` are
`L_T · u` and `L_T · v` for `L_T = ∏_i (v - t_i u)`.  The coefficients of `L_T`
are the elementary symmetric functions `e_k(t)`, each **multilinear**.  Hence:

> `V_s` is the intersection of two divisors of multidegree `(1,1,…,1)` in
> `(P^1)^{d-1}`, and `s` is not deep as soon as `V_s` has an `F_q`-point with
> pairwise distinct coordinates.

That is a clean and genuinely small description — two equations, each linear in
each variable separately — and it is where an effective bound has to be applied.
The trouble is the constant.

**Via Lang–Weil in the Segre embedding.**  `(P^1)^{d-1} ⊂ P^{2^{d-1}-1}` has
degree `(d-1)!`, and the `V_s` are hyperplane sections of it, so for a proper
intersection `deg V_s = (d-1)!` and `dim V_s = d-3`.  The Ghorpade–Lachaud form
of effective Lang–Weil for a geometrically irreducible variety of dimension `n`
and degree `δ` gives

```text
| #V(F_q) − q^n |  ≤  (δ-1)(δ-2) q^{n-1/2} + C(n,δ) q^{n-1},
```

so positivity needs roughly `q > ((δ-1)(δ-2))^2 ≈ δ^4 = ((d-1)!)^4`.  At
`d = 8` that is `5040^4 ≈ 6.5·10^{14}`.  The bound is explicit and it is
worthless: the phenomenon it is meant to control switches off at 16.

**Via Betti numbers of the ambient product.**  The Segre degree is the wrong
invariant here — it is huge only because the embedding is.  Deligne's bound in
the form `| #V(F_q) − q^n | ≤ (Σ_i b_i) q^{n-1/2}` with `b_i` the compactly
supported Betti numbers is the right shape, and for `(P^1)^{d-1}` the total
Betti number is `2^{d-1}`; cutting by two divisors multiplies this by a bounded
factor via the Koszul complex, giving a total of order `c^{d}` for a small
absolute `c` rather than `(d-1)!`.  That improves the threshold from
`((d-1)!)^4` to something like `c^{4d}` — at `d = 8`, from `10^{14}` to perhaps
`10^6`.  **Still four orders of magnitude above the truth, and still far above
any field the strata can be swept over.**

Neither version was carried out in detail, because neither can produce a usable
number and the second requires Betti bounds for a possibly singular complete
intersection that are themselves a small project.

**The deeper problem is not the constant.**  Geometric irreducibility of `V_s`
is not a technicality that can be assumed away: it is *false* exactly where the
interesting behaviour lives.  For a persistent point, `s` is deep at every `q`,
so `V_s(F_q)` has no point with distinct coordinates for any `q` whatever — the
`F_q`-points all sit on the diagonal locus.  Any theorem of the form "`V_s`
geometrically irreducible of dimension `d-3` ⟹ threshold" therefore carries a
hypothesis that must be verified per point, and verifying it *is* the
classification problem restated.  Lemma 1 tells us where the failure comes from
(the ideal is contained in the multiples of `F`), but turning that into a proof
that irreducibility holds off the persistent locus is not done here and is the
actual open step.

## 5. What a corrected hypothesis would have to supply

Stated precisely, so a successor is not left guessing:

1. **A dichotomy replacing geometric irreducibility.**  Prove: for `s` with
   apolar degree `e ≥ 3` and lower generator `F` not split squarefree, the
   complete intersection `V_s ⊂ (P^1)^{d-1}` is geometrically irreducible of
   dimension `d-3` unless `s` lies in an explicitly described degeneration
   locus.  Lemma 1 is the natural starting point: the two defining equations are
   the pairing of `L_T·u` and `L_T·v` against `s`, so their degeneracy is
   governed by the generators `F, H`, which are computable from `s`.
2. **Betti bounds for that complete intersection**, so the effective constant is
   `c^d` rather than `(d-1)!`.  The multidegree `(1,…,1)` structure is very
   special and should make this tractable — these are the "multilinear
   hypersurfaces" whose cohomology is accessible by Koszul resolution on
   `(P^1)^{d-1}`.
3. **A separate treatment of the `M = 2` locus**, which §3 shows the
   equivariant argument cannot see and which is a divisor in every larger
   stratum.  Since `M = 2` means `G` is linear, `s = X^α Y^β (g_0 Y^m + g_1 X^m)`
   is a one-parameter family after torus normalisation, so this may be
   accessible by hand — and it is where `(6,3)`, `(8,5)` and `(10,13)` live, so
   it is worth doing on its own even without the rest.

Item 3 is the cheapest and highest-value of the three.

## 6. What this does and does not do for redundancies eleven and up

The motivation was that C1018's fixed-locus closure stops at `r = 10` because no
field-ranged theorem exists above it to pair the sweep against.  Being exact
about what a stratum threshold would and would not supply:

* A proved threshold `C(r,m)` would close **one stratum at a time**, not the
  non-regular class.  The fixed-locus lemma needs *every* prime-order fixed
  locus swept — unipotent, split for each `ℓ | q-1`, non-split for each
  `ℓ | q+1`.  A carrier threshold speaks only to the split loci, and only to
  those with `M ≥ 3`.
* The binding locus is `ℓ = 2`, of projective dimension about `(d-1)/2`.  Even
  granting a threshold, sweeping it up to `q ≈ C` costs `Σ_{q ≤ C} q^{(d-1)/2}`
  points; at `r = 11` and `C = 10^6` that is beyond astronomical.  With the
  realistic `C ≈ 10^6` from §4 the sweep is not merely expensive, it is
  impossible.
* Even in the fantasy where `C` were around 400, the C1018 drivers cap at
  `q ≤ 251` because field elements are `u8`.  Sweeping past that needs a `u16`
  element type — a real but modest change, worth recording as a prerequisite
  rather than a blocker.

So the honest statement of the combined position, which is weaker than the one
the task hoped for:

> The fixed-locus lemma closes the **non-regular** class at redundancies eight
> and nine because an imported field-ranged theorem covers the tail.  At
> `r ≥ 11` no such theorem exists, and the work here does **not** supply one.
> What it supplies is a correct structural reduction (Theorem A), a proof that
> the `§7` heuristic is unrepairable (Lemma 1), and a precise account of the two
> obstructions — the `M = 2` locus and the effective constant — that a successor
> must clear.

And, for completeness, the limit that predates all of this: a stratum threshold
would say nothing about orbits with **trivial** stabilizer, which C1018 §8
item 11 already identifies as the entire residual at redundancies eight and
nine.  Even a fully successful C1023 would not touch that class.

## 7. Numerical sanity, against C1018's own cells

The instruction was that a threshold contradicting the observed exceptional
fields is wrong and one predicting them is evidence.  Checking `C_heur`:

| carrier | `M` | `C_heur = (m^{M-1}(M-1)!)^{1/(M-2)}` | least admissible `q` | observed firing | verdict |
|---|---:|---:|---:|---|---|
| `(9, m=3)`  | 3 | 18   | 13 | fires at 13, clean 16 → 49 | consistent: 13 < 18, and no firing above |
| `(11, m=4)` | 3 | 32   | 13 | fires at 13, clean 16 → 25 | consistent |
| `(12, m=3)` | 4 | 12.7 | 13 | fires at 13 | **tension**: 13 > 12.7 |
| `(15, m=4)` | 4 | 22.6 | 17 | fires at 17 | consistent: 17 < 22.6 |
| `(13, m=5)` | 3 | 50   | 16 | clean at 16 and 31 | vacuous: no firing predicted or seen |

Four of five are consistent.  The `(12,3)` row is the informative one: the
heuristic says no firing above 12.7 and the carrier fires at 13.  The expected
count there is `q^2/(m^{M-1}(M-1)!) = 169/162 = 1.04`, i.e. the mean crosses one
essentially *at* the observed field, so a mean-based threshold has no margin.
That cell also has `k = q+1-r = 2`, the near-degenerate boundary C1018 flags.
Either way it shows `C_heur` is a mean-crossing, not a threshold: it carries no
error term and is not a bound in either direction.

The distinction matters and is worth stating flatly, because it was implicit in
§7 of C1018: **the field at which the expected count crosses one is not the
field beyond which the count is positive.** A rigorous uniform threshold has to
dominate the fluctuation, which is what drives §4's constants from 18 up to
`10^6` and beyond.

## 8. Prior art — bounded pass, not an audit

Per the task instruction this is a bounded check with read depths recorded, not
a novelty audit under `notes/literature-audit-conventions.md`.

* **Lemma 1 is essentially classical, and I should not have called it new.**
  The Apolarity Lemma plus Sylvester's theorem on binary forms gives: with
  `Ann(F) = (G_1,G_2)`, `deg G_1 ≤ deg G_2`, `deg G_1 + deg G_2 = d+2`, the rank
  is `deg G_1` if `G_1` is squarefree and `deg G_2 = d+2-e` otherwise.  Over an
  algebraically closed field that is exactly Lemma 1(i)–(ii).  *Read depth:
  search snippets only* (a Springer "Final Comments and Further Reading"
  chapter and a talk-slide deck on the Waring rank of binary binomial forms);
  the primary sources were not obtained.
  What is **not** classical is the `F_q`-rational refinement: over `F_q` the
  relevant condition is "split squarefree", so a `G_1` that is irreducible over
  `F_q` but squarefree over `F̄_q` — the conjugate-secant family — falls into
  the bad case with no classical counterpart, and that family is half the
  persistent locus.  So Lemma 1 should be presented as the finite-field
  refinement of Sylvester, with the arithmetic case being the only new part.
* The same snippet records that **Waring rank over finite fields is not always
  well defined** in the naive sense (`xy` over `F_2`), which is consistent with
  this repository's insistence on `p > d` and on distinct rational base points.
* **PRS deep-hole literature.** Searching the deep-hole/covering-radius corpus
  surfaces the expected body — explicit deep holes of RS codes, deep holes of
  PRS codes, even-characteristic PRS deep holes, deep holes and MDS extensions —
  and one item worth flagging: the covering-radius conjecture in the literature
  is stated as `q-k+1` when `q` is even and `k ∈ {2,q-2}`, and `q-k` otherwise,
  which is C1018's Conjecture A verbatim.  C1018 already labels that as
  imported, which is correct.  *Read depth: titles and abstracts via search;
  no paper newly read in this task.*
* **No predecessor found for the specific bound sought here** — an effective
  threshold for cyclic-carrier strata via point counting.  That is a bounded
  negative from two searches, not a cleared novelty claim.  Given that Dye 1991
  pre-empted this repository twice today, the working assumption should remain
  that a predecessor exists, particularly on the multiplicative-subgroup side
  identified in §9.
* **Effective Lang–Weil** is quoted in the Ghorpade–Lachaud shape from memory
  for the *form* of the error term only; no constant in this report depends on
  the precise statement, and none is claimed as verified.

## 9. `ej` + `tt` closeout

**`tt` — the attack this report used is probably the wrong one.**  The
good-`Φ` condition is "all roots lie in `(F_q^*)^m`", a *multiplicative*
condition, and it is being intersected with `Λ_s`, a *linear* condition.  That
is not naturally a Lang–Weil problem at all; it is a multiplicative-subgroup
versus affine-subspace incidence problem, where the sharp tools are character
sums over subgroups and sum-product estimates (Heath-Brown–Konyagin,
Bourgain–Glibichuk–Konyagin and successors) rather than variety point counts.
Those bounds are sensitive to the subgroup index `m` and to the dimension of the
subspace, and are typically *polynomial* in the relevant parameters where
Lang–Weil is exponential in `d`.  Concretely, for `M = 3` the question
"does a line in `P^2` contain a quadratic whose two roots both lie in the
index-`m` subgroup" is an incidence question between a line and the product set
`H · H` for `H = (F_q^*)^m`, which is exactly the regime those methods address.
**This is the single most promising redirection this task produces, and it was
not pursued.**

**`ej` — what is cheap and in reach now.**

1. The `M = 2` locus is one parameter after torus normalisation
   (`s = X^α Y^β (g_0 Y^m + g_1 X^m)`, and `g_1/g_0` normalises into
   `F_q^*/(F_q^*)^m`).  It is small enough to settle by hand, it is where three
   of the six known carrier orbits live, and §3 shows it is precisely what the
   equivariant argument cannot see.  Highest value per unit effort here.
2. Theorem A's row collapse held at `q = 16` with `p = 2 ≤ d = 8`, outside its
   own hypothesis.  A characteristic-free proof — replacing falling factorials
   by divided powers / Hasse derivatives, which is the Ball–Lavrauw idiom the
   dossier points at — would extend every consequence to even characteristic at
   no cost.
3. The `V_s` description as a complete intersection of two `(1,…,1)` divisors in
   `(P^1)^{d-1}` is a clean, small object that did not exist before this task.
   Even without a threshold it is the right normal form for a successor.

**Surprising and unexplained:** the Theorem-A residual with *all* coefficients
nonzero sits at 130, 64, 60 for `q = 31, 49, 61` — it falls and then stops
falling, rather than continuing to decay as the mean-count heuristic predicts.
The `M = 2` sub-locus explains the part that grows linearly, not this part.

## 10. Mystery ledger

1. **Is the §7 heuristic salvageable?**  *Settled: no.*  Lemma 1 shows the
   apolar space is contained in the multiples of the lower generator at every
   level up to `d+1-e`, so the `1/j!` density is wrong by an unbounded factor
   exactly where it is needed, and any repair not seeing the generator would
   contradict the persistent locus being deep at all `q`.  Nothing open.
2. **Does the torus-equivariant count close?**  *Settled: no*, and for a
   structural reason rather than a constant.  The `M = 2` sub-locus is a divisor
   in every larger stratum on which the solution space is a single point, and
   the exhaustive check over `13 ≤ q ≤ 79` shows the uncertified residual flat
   rather than decaying.  Nothing open about the verdict; the residual's
   full-support part (§9) is open.
3. **Can any effective bound reach the observed threshold?**  *Open, and this is
   the real question.*  Observed `≈ 16`; mean-crossing heuristic `18`;
   Lang–Weil via Segre degree `≈ 10^{14}`; via Betti numbers perhaps `10^6`.
   The gap is four to twelve orders of magnitude.  §9's redirection to
   multiplicative-subgroup incidence is the untried route.  Owner: a successor;
   this is not a matter of tightening constants in the present argument.
4. **Why does the full-support residual stop decaying?**  *Open.*  See §9.
   Either there is a second degeneration locus not yet identified, or the
   fluctuation is genuinely heavy-tailed in this range.  Cheap to probe: extend
   the exhaustive sweep to `q ≈ 150` and fit.
5. **Does Theorem A hold in small characteristic?**  *Open, with evidence.*  It
   held on 242,151 pairs at `q = 16`, `p = 2 ≤ d`.  The proof does not cover it.
   Evidence gap: a divided-power reformulation.
6. **Nothing anomalous in the verification layer.**  507,318 (point, `Φ`) pairs
   across four carriers, two characteristics and both exponent shapes, checked
   against the raw definitions with zero mismatches and a hard assertion on the
   row-collapse claim that never fired.  No mystery here and none is claimed.

## 11. Evidence bundle

```text
notes/2026-08-31-c1023-lang-weil-carrier-threshold.md   this report
notes/2026-08-31-c1023-carrier-threshold-check.py       verification + bound generator
```

Replay:

```bash
cd ~/src/othello/notes
python3 2026-08-31-c1023-carrier-threshold-check.py verify 9  3 1 13
python3 2026-08-31-c1023-carrier-threshold-check.py verify 11 4 1 13
python3 2026-08-31-c1023-carrier-threshold-check.py verify 9  3 1 16
python3 2026-08-31-c1023-carrier-threshold-check.py verify 10 4 0 13
for q in 13 16 19 25 31 37 43 49 61 64 79; do
  python3 2026-08-31-c1023-carrier-threshold-check.py bound 9 3 1 $q
done
```

`verify` re-runs the Theorem A check; it raises on any row outside the predicted
residue class and reports the mismatch count, which must be zero.  `bound`
recomputes the residual table of §3.  The script imports only the `GF` class of
`notes/2026-08-30-c1018-prs-helper.py`; the "true exceptional deep count" row of
§3 is read from the committed C1018 evidence, not recomputed here.

**What this certifies:** Theorem A parts (1) and (2), exhaustively, on the four
listed cells; and the residual counts of §3, exhaustively over the named
strata.  **What it does not certify:** any threshold, since none is proved; and
nothing at all about orbits with trivial stabilizer.

