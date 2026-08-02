# C786 — making the stability threshold explicit (2026-08-01)

**Lane**: `ame-lu`. Read-only outside this report; no artifacts on other stems.

Sources read in full: `papers/ame_lu/sections/03-lu-rigidity.tex` (all of it, including the
quantitative-intertwiner material after `sec:two-uniform`),
`notes/2026-08-01-external-session-notes/approximate_rigidity_of_2uniform_states.md` together with
that directory's `README.md` defect list, and `notes/2026-08-01-c774-two-uniform-rigidity-red-team.md`.

No novelty assertion is made anywhere in this report; no literature audit has been run. Where a
technique is standard I say so.

**Nothing here is established by computation.** Every statement below is a proof. The two arithmetic
tables are evaluations of closed-form expressions, not searches or fits. No evidence bundle ships,
because no claim rests on a run.

---

## 0. Summary

The threshold is now explicit, and the region question is settled.

**Part I (local, the higher-moment route).** For a `k`-uniform state the moments of the summed local
generator `M` up to order `k` are *exactly* the maximally-mixed ones (Lemma 1). This is a two-line
consequence of `k`-uniformity and it replaces the cubic Taylor remainder by an order-`(k+1)`
remainder throughout. The consequence (Theorem 3) is that the region on which the quadratic lower
bound holds, measured by `t = Σ_j ||h_j||_op`, is not the constant `1/2` of the manuscript but a
radius `R_k` growing like `k/e`. For a stabilizer `AME(2m,q)` state `k = m = n/2`, so **the certified
region grows linearly in the party count.** A one-line example (a traceless logarithm of a scalar)
caps any valid radius at `2π(1−1/q)n`, so linear growth is the maximal possible order and the moment
route attains it, within an explicit constant factor of about `2πe`.

This resolves C774's open mystery-ledger item, but by reparameterizing it rather than by proving the
matching lower bound it asked for. The `n^{-1/2}` shrinkage C774 exhibited is **not** a party-count
effect: the Reed–Muller family it uses is `3`-uniform for every length, and at uniformity order `3`
Theorem 3 certifies the manuscript's constant `√(6q/5)` out to `t = 1` while C774's family destroys it
at `t = 1.4656`. The truth at order `3` is therefore bracketed in `[1, 1.466]` — a factor of `1.47` —
and the shrinkage is governed by the uniformity order, not by `n`. The manuscript's sentence that the
certified neighbourhood "cannot" have its party-count dependence removed is a statement about the
`2`-uniform class; it does not apply to the AME class the corollary is stated for.

**Part II (global, the threshold itself).** The compactness step in the decomposition corollary is
removed outright. The chain is: an `(m+1)`-party marginal detects the perturbation and forces every
local factor near a Clifford (this is the manuscript's own quantitative-axes machinery, generalized
from `[6,3,4]_q` to arbitrary `AME(2m,q)`); overlaps of stabilizer states are quantized, so a product
Clifford whose overlap with `ψ` exceeds `p^{-1/2}` is an *exact* symmetry, with no compactness and no
approximation (Lemma 6); dividing that exact symmetry out leaves a product unitary in the small-`t`
region, where Part I or the manuscript's own stability theorem applies. The result (Theorem 8) is

```
eps_0  =  min {  tau_p / (2 q^{(m+1)/2}) ,   1 / (4 sqrt2 pi n q^{(m+2)/2}) } ,
tau_p  =  min { 1/3 , sin(pi/p) / (2 sqrt2) } ,      q = p^e ,  n = 2m .
```

Everything in it is closed form. It is consistent with C774's ceiling `1.34 n^{-1/2}` by an
enormous margin, and that margin is the point: the threshold is explicit but **exponentially small in
the party count**, because it is bought from a single `(m+1)`-party marginal whose Weyl signal has
amplitude `q^{-(m+1)/2}`. Getting to the ceiling order would require a global argument that never
passes through one small marginal. Part III gives the exact form such an argument must take and the
precise point at which the natural candidate stalls.

**Verdict on the companion letter.** A certification statement is now writable with a fully explicit
constant, so the gate is no longer vacuous. Whether it is *worth* writing as a letter depends on
whether a reader will accept a threshold of order `q^{-(n+4)/4}/n`; as a section of the AME rigidity
paper it is unambiguously an improvement, since it converts a compactness existence claim into a
formula.

---

## 1. Notation

`ψ` is a pure state of `n` qudits of local dimension `q`; for the stabilizer statements `q = p^e` and
`L` is the projective label group. `h_1,…,h_n` are traceless Hermitian on `C^q`,
`M = Σ_j h_j^{(j)}`, `U = ⊗_j e^{i h_j}`,

```
t = Σ_j ||h_j||_op  ( ≥ ||M||_op ),      D² = Σ_j ||h_j||_F² ,
eps(U) = min_θ || U ψ − e^{iθ} ψ ||  =  ( 2 − 2 |<ψ|U|ψ>| )^{1/2} .
```

`ψ` is **`k`-uniform** if every reduced state on at most `k` parties is maximally mixed. An
`AME(2m,q)` state is `m`-uniform; a `2`-uniform state is `2`-uniform and nothing more is assumed.
`s` denotes the largest spectral spread `λ_max(h_j) − λ_min(h_j)` over sites.

Throughout, `<·> = <ψ|·|ψ>` and `τ = q^{-n} Tr(·)` is the tracial (maximally mixed) state.

---

## 2. Part I — the higher-moment route

### 2.1 Moment matching

> **Lemma 1 (tracial agreement).** Let `ψ` be `k`-uniform. Then for every operator `O` supported on
> at most `k` sites, `<ψ|O|ψ> = q^{-n} Tr(O)`. In particular, for every `r ≤ k`,
> ```
> <ψ| M^r |ψ>  =  q^{-n} Tr(M^r)  =  E[ (X_1 + ⋯ + X_n)^r ] ,
> ```
> where the `X_j` are independent, `X_j` taking each eigenvalue of `h_j` with probability `1/q`
> (counted with multiplicity).

**Proof.** If `O` acts on the site set `S` with `|S| ≤ k` then `<ψ|O|ψ> = Tr(ρ_S O_S) =
q^{-|S|} Tr(O_S) = q^{-n} Tr(O)`. Expanding `M^r` gives a sum of products of one-site operators
touching at most `r ≤ k` sites, so each term is of that shape. The tracial state is the product of
the one-site tracial states, under which the site-`j` factor `h_j` is the random variable `X_j` and
distinct sites are independent; `Tr(M^r)/q^n` is then literally `E[(ΣX_j)^r]`. ∎

Two remarks on what this does and does not say. It is exact, not asymptotic, and it needs no
tracelessness. And it is not a statement about `M` as an operator — `M` and `Σ X_j` have very
different spectra in general — only about its first `k` moments *in the state `ψ`*. That is exactly
what a Taylor expansion of the defect consumes.

> **Corollary 2 (characteristic-function comparison).** Let `ψ` be `k`-uniform with `k ≥ 2`. Then
> ```
> | <ψ| e^{iM} |ψ>  −  ∏_j q^{-1} Tr( e^{i h_j} ) |   ≤   2 t^{k−1} D² / ( q (k+1)! ) .
> ```

**Proof.** Write `e^{ix} = Σ_{r ≤ k} (ix)^r/r! + ρ(x)` with `|ρ(x)| ≤ |x|^{k+1}/(k+1)!`. By Lemma 1
the two states assign the same value to every `M^r` with `r ≤ k`, so the difference of the two
expectations is `<ρ(M)> − τ(ρ(M))`. For a state with spectral weights `p_i ≥ 0` summing to `1`,
`|Σ_i p_i ρ(λ_i)| ≤ Σ_i p_i |λ_i|^{k+1}/(k+1)! ≤ ||M||_op^{k−1} Σ_i p_i λ_i² /(k+1)!`, and both
states give `M²` the value `D²/q` (Lemma 1 again, `r = 2 ≤ k`, plus tracelessness for the tracial
side). Since `||M||_op ≤ t`, each of the two terms is at most `t^{k−1}D²/(q(k+1)!)`. Finally
`q^{-n}Tr(e^{iM}) = ∏_j q^{-1}Tr(e^{ih_j})` because the sites commute. ∎

This is the whole gain, and it is algebra: the cubic remainder `t <M²> /6` of the manuscript is the
case `k = 2`, and every extra order of uniformity divides the remainder by another factor of `t/(k+1)`.

### 2.2 The tracial main term

> **Lemma 3 (per-site contraction).** Let `h` be traceless Hermitian on `C^q` with spectral spread
> `s`. Then
> ```
> | q^{-1} Tr( e^{ih} ) |²   ≤   1 − c(s) ||h||_F² / q ,
> c(s) = max { 1 − s²/12 ,  (4/π²)·[s ≤ π] } .
> ```

**Proof.** `q^{-1}Tr(e^{ih}) = E[e^{iX}]` with `X` uniform on the spectrum, so
`|E e^{iX}|² = E cos(X − X')` for an independent copy `X'`, and `|X − X'| ≤ s`. Two elementary bounds:
`cos u ≤ 1 − u²/2 + u⁴/24 ≤ 1 − (u²/2)(1 − s²/12)`, and `cos u ≤ 1 − 2u²/π²` for `|u| ≤ π`. Since
`h` is traceless, `E(X−X')² = 2 Var X = 2 Tr(h²)/q`. Substituting gives both forms. ∎

`c(s) → 1` as `s → 0`, which is where the sharp constant comes from.

### 2.3 The extended-region stability theorem

> **Theorem 3 (stability on a large region).** Let `ψ` be `k`-uniform, `k ≥ 2`, with `h_j`, `t`, `D`,
> `s`, `U` as above. Put
> ```
> c = c(s) ,     λ = 2 t^{k−1} / (k+1)! ,     ρ = c − c² D² / (4q) − 2λ .
> ```
> Then
> ```
> eps(U)²  ≥  ρ · D² / q ,
> ```
> so `ρ > 0` gives `D ≤ √(q/ρ) · eps(U)`.

**Proof.** By Corollary 2 and Lemma 3,

```
|<e^{iM}>|  ≤  ∏_j |q^{-1}Tr e^{ih_j}|  +  λ D²/q
            ≤  ∏_j ( 1 − c ||h_j||_F²/q )^{1/2}  +  λ D²/q
            ≤  exp( − c D² / (2q) )  +  λ D²/q ,
```

using `1 − y ≤ e^{−y}` and that each factor is nonnegative. With `x = cD²/(2q)` and
`1 − e^{−x} ≥ x − x²/2`,

```
eps² = 2 − 2|<e^{iM}>|  ≥  2x − x²  −  2λ D²/q  =  (D²/q)( c − c²D²/(4q) − 2λ ) . ∎
```

In the limit `s, t, D → 0` one has `c → 1`, `λ → 0`, `ρ → 1`, recovering the sharp constant
`D ≤ √q · eps` that C774 identified as the true asymptotic. The theorem is *worse* than the
manuscript's at `k = 2` — it routes through the tracial term, which the manuscript's direct argument
does not need — and better from `k = 3` on. Both belong in the paper; they answer different questions.

> **Corollary 4 (the manuscript's constant on a growing region).** Suppose every `h_j` has spectral
> spread at most `1/2` and `D ≤ √q / 2`. If
> ```
> t = Σ_j ||h_j||_op   ≤   R_k := ( (k+1)! / 48 )^{1/(k−1)} ,
> ```
> then `D ≤ √(6q/5) · eps(U)` — the manuscript's conclusion, on the region `t ≤ R_k` instead of
> `t ≤ 1/2`.

**Proof.** Spread `≤ 1/2` gives `c ≥ 1 − 1/48 = 0.97917`; `D² ≤ q/4` gives `c²D²/(4q) ≤ c/16`, so
`c − c²D²/(4q) ≥ 0.91924`; and `t^{k−1} ≤ (k+1)!/48` gives `2λ ≤ 1/12 = 0.08333`. Hence
`ρ ≥ 0.83591 > 5/6`, and `√(q/ρ) ≤ √(6q/5)`. ∎

Closed-form values of `R_k`, and `k/e` for comparison:

| `k`  | `R_k`  | `k/e`  |
|------|--------|--------|
| 3    | 0.707  | 1.104  |
| 4    | 1.357  | 1.472  |
| 5    | 1.968  | 1.839  |
| 6    | 2.537  | 2.207  |
| 10   | 4.548  | 3.679  |
| 20   | 8.888  | 7.358  |
| 30   | 12.927 | 11.036 |

By Stirling, `log R_k = (log (k+1)! − log 48)/(k−1) = log k − 1 + O(log k / k)`, so `R_k ∼ k/e`.

The shape of the region is worth naming, because it is exactly the self-testing regime. The
constraint traded away is the global `ℓ¹` budget over sites; the constraints kept are per-site
`ℓ^∞` ones (spread `≤ 1/2`) and one global `ℓ²` one (`D ≤ √q/2`). The moment method certifies *many
small kicks*, which is what a union bound over parties produces, and refuses *one large kick*, which
is what would take a single site outside the injectivity radius.

### 2.4 The region has the maximal possible order

> **Proposition 5 (ceiling).** For any `q ≥ 2` and any `n`, there are traceless `h_j` with
> `Σ_j ||h_j||_op = 2π(1 − 1/q) n` and `⊗_j e^{ih_j} = I`, hence `eps = 0` while `D > 0`. No
> quadratic lower bound of the form `eps² ≥ ρ D²/q` with `ρ > 0` can hold on a region of `ℓ¹` radius
> exceeding `2π(1 − 1/q) n`.

**Proof.** Take `h_j = (2π/q)·diag(q−1, −1, …, −1)` at every site. It is traceless, `e^{ih_j}` has
every eigenvalue `e^{2πi(q−1)/q}` or `e^{−2πi/q}`, both equal to `e^{−2πi/q}`, so `e^{ih_j}` is that
scalar; the product of `n` of them is `e^{−2πin/q}I`, a global phase, so `eps = 0`. And
`||h_j||_op = 2π(q−1)/q`. ∎

This is the manuscript's own `q = 2` remark ("the size constraint cannot be dropped") in general form,
read as a sharpness statement rather than a caveat. Combining Corollary 4 at `k = m = n/2` with
Proposition 5: for stabilizer `AME(2m,q)` states the maximal `ℓ¹` radius of any quadratic-growth
region lies between `R_{n/2} ∼ n/(2e)` and `2π(1−1/q)n`, a ratio of at most `4πe(1−1/q) ≈ 34` and at
least `2πe ≈ 17`. **The order is linear in the party count and the moment route attains it.**

### 2.5 What this does to C774's obstruction

C774 proved that no threshold uniform in `n` exists over the class of all `2`-uniform states, using
the equal-phase CSS state of `RM(1,m)`, and left open whether the exhibited rate `n^{-1/2}` is the
truth. The reparameterization above answers the question that was actually being asked.

The Reed–Muller state has `d(C) = N/2` and `d(C^⊥) = 4`, so its uniformity order is
`min(4, N/2) − 1 = 3` **for every length** `N ≥ 8`. Its party count grows; its uniformity order does
not. Theorem 3 is indexed by uniformity order, and at `k = 3` with `c ≈ 1` and `D` small it certifies
`ρ ≥ 5/6` — the manuscript's own constant — as soon as `2λ = 4t²/24 ≤ 1/6`, i.e. `t ≤ 1`. C774's
family violates that conclusion at `t = θ* = 1.4656…`. So:

- at uniformity order `3` the exact `ℓ¹` radius for the constant `√(6q/5)` lies in `[1, 1.466]`,
  a factor of `1.47`, with the lower bound proved here for *every* `3`-uniform state and the upper
  bound proved in C774 for one family;
- the manuscript's hypothesis `t ≤ 1/2` is a factor of `2` to `2.9` from sharp at that order;
- and the `n^{-1/2}` appearing in C774 is the image of a *constant* `ℓ¹` radius under the
  even-spreading bound `D ≤ √(q/n)·t`. Once the radius grows linearly, that image is `D ≲ √(qn)`,
  which does not shrink at all.

The matching lower bound C774 asked for therefore does not exist in the form requested, and should
not be sought: the rate is not a function of `n`. What replaces it is the bracket above, plus the
Θ(n) statement of §2.4 for the AME class.

One consequence for the manuscript's prose. The sentence following the decomposition corollary —
that `ε₀` depends on the party count and that by the Reed–Muller proposition "its dependence on the
party count cannot be removed" — attributes to the AME corollary an obstruction proved for a
`3`-uniform non-AME state. The obstruction is real for the `2`-uniform class and should stay, stated
against that class.

---

## 3. Part II — an explicit threshold

Fix a stabilizer `AME(2m,q)` state `ψ`, `q = p^e`, `m ≥ 2`, `n = 2m`. Write `G(ψ)` for its
product-unitary symmetry group.

### 3.1 Overlaps of stabilizer states are quantized

> **Lemma 6 (overlap gap).** Let `ψ, φ` be stabilizer states on `n` qudits over `F_q = F_{p^e}`, with
> label groups `L_ψ, L_φ` and characters `χ_ψ, χ_φ`. Then
> ```
> |<ψ|φ>|²  =  |L_ψ ∩ L_φ| / q^n   if  χ_ψ = χ_φ on L_ψ ∩ L_φ ,  and  0 otherwise.
> ```
> In particular `|<ψ|φ>|² ∈ {0} ∪ { p^{−j} : j ≥ 0 }`, so `|<ψ|φ>| > p^{-1/2}` forces `φ = e^{iθ}ψ`.

**Proof.** `ρ_ψ = q^{-n} Σ_{ℓ∈L_ψ} χ_ψ(ℓ) W_ℓ` and likewise for `φ`. Weyl orthogonality
`Tr(W_ℓ^† W_{ℓ'}) = q^n δ_{ℓ,ℓ'}` gives
`|<ψ|φ>|² = Tr(ρ_ψ ρ_φ) = q^{-n} Σ_{ℓ ∈ L_ψ ∩ L_φ} (χ_ψ \bar χ_φ)(ℓ)`. The summand is a character of
the group `L_ψ ∩ L_φ`, so the sum is `|L_ψ ∩ L_φ|` if it is trivial and `0` otherwise. The group has
order a power of `p` and `q^n = p^{en}`, giving the quantization; the value `1` occurs only when
`L_ψ = L_φ` and the characters agree, i.e. when the states coincide up to phase. ∎

This is standard stabilizer formalism. Its role here is decisive and worth stating plainly: **on the
set of product Cliffords, the defect function has no small nonzero values.** Either `K ∈ G(ψ)`, or
`eps(K)² ≥ 2 − 2p^{-1/2} ≥ 2 − √2 = 0.5858`. No compactness argument, no minimum over a compact
remainder, and no dependence on `n` or on which AME state was chosen. This is also, in closed form,
everything route 4 (Gaussian character sums for stabilizer states) could have supplied: the
character sum is evaluated exactly by the lemma.

### 3.2 A small marginal forces the local factors near Clifford

The manuscript proves this for `[6,3,4]_q` codes (its quantitative-intertwiner proposition). Only two
numbers in that proof depend on the code, and both generalize immediately.

> **Proposition 7 (quantitative axes at general `m`).** Let `ψ` be a stabilizer `AME(2m,q)` state,
> `m ≥ 2`, let `U = ⊗_j U_j` be a product unitary with `eps(U) = eps`, and put
> ```
> δ = 2 q^{(m+1)/2} eps .
> ```
> If `δ < τ_p := min{1/3, sin(π/p)/(2√2)}` then for every party `i` there is a single-qudit Clifford
> `K_i` with
> ```
> q^{-1/2} || U_i − K_i ||_HS  ≤  √2 δ .
> ```

**Proof.** Fix an `(m+1)`-set `A`. The support proposition gives `|L(A)| = q²` with every coordinate
projection `L(A) → F_q²` bijective, so
`ρ_A^ψ = q^{-(m+1)} Σ_{ℓ ∈ L(A)} W̃_ℓ` and its nonidentity part is

```
T_A = q^{-(m+1)} Σ_{ℓ ≠ 0} W̃_ℓ = a Σ_{v ≠ 0} λ_v ⊗_{i∈A} (W_{p_i(v)} / √q) ,
a = q^{-(m+1)/2} ,   |λ_v| = 1 ,   N = q² − 1 ,   r = m+1 ≥ 3 ,
```

which is the hypothesis of the quantitative diagonal-tensor axes lemma. Two unit vectors at
phase-optimized distance `eps` have density matrices at trace distance `2 eps √(1 − eps²/4) ≤ 2 eps`;
partial trace contracts the trace norm and the Hilbert–Schmidt norm is no larger; the identity
components of `ρ_A^ψ` and `ρ_A^{Uψ}` agree because both marginals have unit trace. Hence the two
tensors `T_A` and `(⊗_i \mathrm{Ad}_{U_i}) T_A` differ by at most `η = 2eps`, and `δ = η/a =
2q^{(m+1)/2}eps`, matching Weyl axes within `κ = √2 δ`. Note the two tensors are built from the
*same* state, so the lemma is applied with `T' = T` in the same bases — strictly easier than the
intertwiner case the manuscript writes out. The remaining three steps of the manuscript's proof —
additivity of the matched label permutation (needs `δ < 1/3`), preservation of the symplectic form
(needs `δ < sin(π/p)/(2√2)`), and the phase step producing `K_i` with the displayed bound — use only
`κ`, not the code. Every party lies in some `(m+1)`-set. ∎

The only quantity that moved from the manuscript's `m = 3` statement is `a`: `q^{-2}` there,
`q^{-(m+1)/2}` in general, i.e. `2q²eps` becomes `2q^{(m+1)/2}eps`. **This is where the exponential
comes from, and it is not an artifact of the estimate.** The nonidentity part of an `(m+1)`-party
marginal of an `AME(2m,q)` state has Hilbert–Schmidt norm `q^{-(m+1)/2}·√(q²−1)`: the marginal is
almost exactly maximally mixed, and the Weyl signal that reveals the local factors is that small. A
global defect `eps` dilutes to that scale before it can be read off.

*Dependency note.* Proposition 7 is a generalization of a manuscript proof I have read but which has
not been independently red-teamed (C774 reviewed the external note, which contains no quantitative
intertwiner material). If that proof has a defect, Theorem 8 inherits it. The generalization step
itself — recomputing `a` and `N`, and specializing to `φ = ψ` — is routine.

### 3.3 From a nearby Clifford to an exact symmetry

> **Lemma 7' (minimal logarithm).** Let `W` be unitary on `C^q` with
> `σ := min_φ ||W − e^{iφ}I||_op ≤ 1`. Then `W = e^{iφ'} e^{ih}` for some real `φ'` and some traceless
> Hermitian `h` with `||h||_op ≤ π σ`.

**Proof.** Choose the optimal phase and diagonalize: the eigenvalues of `e^{-iφ}W` are `e^{iμ_a}`
with `2|sin(μ_a/2)| ≤ σ` and `μ_a ∈ (−π,π]`, so `|μ_a| ≤ 2 arcsin(σ/2) ≤ πσ/2`. Put
`h = Σ_a μ_a P_a − \barμ I` with `\barμ` the mean; then `||h||_op ≤ 2 max_a |μ_a| ≤ πσ`. ∎

### 3.4 The theorem

> **Theorem 8 (explicit decomposition threshold).** Let `ψ` be a stabilizer `AME(2m,q)` state,
> `q = p^e`, `m ≥ 2`, `n = 2m`. Put
> ```
> eps_0 = min {  tau_p / ( 2 q^{(m+1)/2} ) ,   1 / ( 4 √2 π n q^{(m+2)/2} )  } ,
> tau_p = min { 1/3 , sin(π/p) / (2√2) } .
> ```
> Every product unitary `U` with `eps(U) < eps_0` factors as
> ```
> U = g · ⊗_j e^{i h_j} ,     g ∈ G(ψ) an exact product-Clifford symmetry,
> ```
> with the `h_j` traceless Hermitian, `Σ_j ||h_j||_op ≤ 1/2`, and
> `( Σ_j ||h_j||_F² )^{1/2} ≤ √(6q/5) · eps(U)`.

**Proof.** Write `eps = eps(U)` and `B = 2√2 n q^{(m+2)/2} eps`, so that `eps < eps_0` gives
`B < 1/(2π)`.

*Step A.* `2q^{(m+1)/2}eps < τ_p`, so Proposition 7 supplies Cliffords `K_i` with
`||U_i − K_i||_op ≤ ||U_i − K_i||_HS ≤ √q · √2 δ = 2√2 q^{(m+2)/2} eps`. Summing over the `n` parties,
`Σ_i ||U_i − K_i||_op ≤ B < 1/(2π) < 1`.

*Step B.* Put `K = ⊗_i K_i`, a product Clifford, so `Kψ` is a stabilizer state. Then
`||U − K||_op ≤ Σ_i ||U_i − K_i||_op ≤ B`, hence

```
|<ψ|K|ψ>|  ≥  |<ψ|U|ψ>| − B  ≥  1 − eps²/2 − B .
```

Now `B < 1/(2π) = 0.1592` and `eps ≤ eps_0 ≤ τ_p/(2q^{(m+1)/2}) ≤ 1/(6·2^{3/2}) < 0.06`, so the right
side exceeds `1 − 0.0018 − 0.1592 = 0.839 > 1/√2 ≥ p^{-1/2}`. By Lemma 6, `Kψ = e^{iθ}ψ`: the nearby
product Clifford is an **exact** symmetry. Set `g = K ∈ G(ψ)`.

*Step C.* Put `V = g^† U = ⊗_i (K_i^† U_i)`. Each factor satisfies
`min_φ ||K_i^†U_i − e^{iφ}I||_op ≤ ||U_i − K_i||_op ≤ B < 1`, so Lemma 7' writes
`K_i^†U_i = e^{iφ_i} e^{ih_i}` with `h_i` traceless and `||h_i||_op ≤ π ||U_i − K_i||_op`. Hence
`Σ_i ||h_i||_op ≤ π B < 1/2`. The collected phases `∏_i e^{iφ_i}` are a global phase, absorbed into
`g` (which contains the scalars). Finally `eps(V) = eps(U)`, because `g` fixes the ray of `ψ` and the
defect depends only on `|<ψ|·|ψ>|`; the manuscript's local stability theorem applies to `V` on its
hypothesis `Σ_i||h_i||_op ≤ 1/2` and gives `D ≤ √(6q/5) eps(V) = √(6q/5) eps(U)`. ∎

Two things to note about the proof. First, there is no compactness anywhere: the finite zero set is
never enumerated, and no minimum over a compact remainder is invoked. The role played by compactness
in the manuscript's proof is played here by Lemma 6, which is a closed-form gap. Second, the
factorization is *constructive* in the sense that matters: `g` is produced from `U` by rounding each
local factor to a Clifford, and the rounding is certified by the marginal.

### 3.5 What the threshold costs, and why

Written in the party count, `eps_0 ≍ q^{-(n+4)/4} / n`. Against C774's ceiling `1.34 n^{-1/2}` this is
smaller by a factor exponential in `n`. Locating the loss precisely:

- Step A costs `q^{(m+1)/2}`. This is marginal dilution, discussed after Proposition 7. It is a real
  feature of AME states, not a slack estimate: the `(m+1)`-party marginal genuinely is within
  `q^{-(m+1)/2}√(q²−1)` of maximally mixed in Hilbert–Schmidt norm, so a marginal-based detector
  cannot do better.
- Steps B and C cost a further factor `n√q`, from summing `n` per-site errors in operator norm and
  from the per-site logarithm. This is a union bound and is the honest price of a per-site
  conclusion.
- Part I does **not** help here. Its improvement is to the `ℓ¹` radius, and in this chain the
  generators arrive already spread over all `n` sites with each one tiny; the binding constraints in
  Step C are the per-site ones, not the `ℓ¹` budget. Substituting Corollary 4 for the manuscript's
  stability theorem changes `eps_0` by a bounded factor and by nothing structural. The two parts of
  this report improve genuinely different things, and I record that rather than compounding them
  cosmetically.

So the honest boundary is: **explicit, yes; of the right order, no.** The gap between
`q^{-(n+4)/4}/n` and `n^{-1/2}` is open and is the single most valuable remaining target in this
lane.

---

## 4. Part III — the Weyl-expansion route, and why it is the right place to look next

Route 2 of the brief (Weyl expansion of the defect, as the source note proposes) does not close the
threshold, but it produces one exact inequality that is worth having on the record, because it is the
only global statement I found that loses nothing to marginal dilution.

For a product unitary `U = ⊗_j U_j` set `a_j(v) = q^{-1} Tr(W_v^† U_j)`, so that
`Σ_{v ∈ F_q²} |a_j(v)|² = 1` for each `j`: each site carries a probability distribution
`p_j(v) = |a_j(v)|²` on the local Weyl labels.

> **Proposition 9 (half-splitting bound).** Let `ψ` be a stabilizer `AME(2m,q)` state with label
> group `L`, and let `A` be any `m`-subset of the parties. Define `u, v ∈ R^L` by
> ```
> u(ℓ) = ∏_{j ∈ A} |a_j(ℓ_j)| ,      v(ℓ) = ∏_{j ∈ A^c} |a_j(ℓ_j)| .
> ```
> Then `||u|| = ||v|| = 1` and
> ```
> |<ψ|U|ψ>|  ≤  <u, v>  =  1 − ½ ||u − v||²  ,     hence     eps(U)²  ≥  ||u − v||² .
> ```

**Proof.** Since `|A^c| = m`, the AME support structure makes the coordinate restriction
`π_A : L → (F_q²)^A` injective (its kernel is the set of labels supported in `A^c`, which is trivial),
and both sides have `q^{2m}` elements, so `π_A` is a bijection; likewise `π_{A^c}`. Hence
`||u||² = Σ_{x ∈ (F_q²)^A} ∏_{j∈A} p_j(x_j) = 1`, and similarly for `v`. From
`ρ_ψ = q^{-n}Σ_{ℓ∈L}χ(ℓ)W_ℓ` and `Tr(W_ℓ U) = ∏_j Tr(W_{ℓ_j}U_j)`, taking moduli termwise gives
`|<ψ|U|ψ>| ≤ Σ_{ℓ∈L} ∏_j |a_j(ℓ_j)| = <u,v>`, the relabelling `ℓ ↦ −ℓ` being a bijection of `L`.
Cauchy–Schwarz for unit vectors is the stated identity. ∎

The bound is exact at both ends: for `U` a Pauli with label in `L` both `u` and `v` are the same
standard basis vector and the bound reads `≤ 1`; for a Pauli with label outside `L` they are distinct
basis vectors, the bound reads `eps² ≥ 2`, and indeed the overlap vanishes.

Read as a rigidity statement it says: *a product unitary with small defect must have its `A`-side and
`A^c`-side Weyl amplitude profiles agree, in Hellinger distance on `L`, to within `eps`.* Since each
side is a product distribution over `m` sites and the identification `π_{A^c} π_A^{-1}` is an MDS
transition map, this is a strong structural constraint of exactly the kind that could yield an
`n^{-1/2}`-order threshold — it is global, and it never passes through a diluted marginal.

**Where it stalls, precisely.** The bound discards all phase information: the stabilizer character
`χ(ℓ)` and the arguments of the `a_j(v)`. Consequently it cannot separate an exact symmetry from a
unitary that merely has symmetric moduli. The concrete blocking example: at `q = 2` take `U_j = H`
at every site, so `p_j` is uniform on `{X, Z}` at each site; then `u` and `v` are both proportional
to the indicator of `{ℓ ∈ L : ℓ_j ∈ {X,Z} ∀ j}` restricted to the respective half, and whenever `L`
is symmetric enough under the splitting these coincide, giving `<u,v> = 1` and a vacuous bound —
while `H^{⊗n}` need not be a symmetry, the obstruction being a phase. Any repair must reinstate the
phases, which is where a Gauss-sum evaluation would enter; but for product *Clifford* `U` those sums
are already evaluated exactly by Lemma 6, so the phases only matter in the genuinely non-Clifford
directions. **That is the precise open problem**: bound `|<ψ|U|ψ>|` away from `1` for product
unitaries whose local factors are far from Clifford, without passing to a marginal.

**Route 3, the Łojasiewicz fallback, is superseded and I do not develop it.** For the record, it was
never attractive on the stated criterion: `f(U) = 2 − 2|<ψ|U|ψ>|` is semialgebraic of degree `2n` in
`2nq²`-ish real coordinates, and the standard effective Łojasiewicz exponent bounds for a degree-`d`
polynomial in `N` variables are of the shape `d(3d−3)^{N−1}` — explicit, doubly astronomical, and
supplying an *exponent* only; the accompanying constant needs an effective Positivstellensatz and is
not writable in closed form. Theorem 8 gives a genuine formula by a structural route, so the fallback
has no remaining role. Route 4 is absorbed into Lemma 6, as noted there.

---

## 5. What the manuscript would need

All of this is reportable; none of it is written into `papers/ame_lu` by this task.

1. **Replace the closing paragraph of `cor:approximate-decomposition`'s discussion.** The sentence
   "The threshold `ε₀` comes from compactness and is not explicit" becomes false. Theorem 8 goes in
   as a proposition immediately after the corollary, and the corollary's proof can keep its
   compactness argument as the short conceptual version with Theorem 8 as the quantitative one.
2. **Add Lemma 6** (quantized stabilizer overlap) as a standalone lemma. It is standard stabilizer
   formalism and is the load-bearing step. State it against `p`, not `q`.
3. **Generalize `prop:quantitative-intertwiner` to arbitrary `m`,** recording `a = q^{-(m+1)/2}` and
   `N = q² − 1`, and note the `φ = ψ` specialization used by Theorem 8. The manuscript currently
   states it only for `[6,3,4]_q`; nothing in the proof needs that.
4. **Add Lemma 1 and Theorem 3** as a `k`-uniform strengthening of `thm:two-uniform-stability`,
   with Corollary 4's `R_k` table. The natural place is right after the current stability theorem,
   since it is the same estimate with the remainder taken at order `k` instead of order `2`.
5. **Correct the scope of `prop:stability-region`'s consequence.** It is a theorem about the
   `2`-uniform class, proved with a state of uniformity order `3`; the paragraph after it, and the
   last sentence of the paragraph after `cor:approximate-decomposition`, currently read as if it
   constrained the AME class. Add §2.5's bracket `[1, 1.466]` at order `3` and §2.4's `Θ(n)` for the
   AME class.
6. **Add Proposition 9** if the open problem in §4 is to be flagged to a referee; otherwise it can be
   dropped, since nothing downstream uses it.

---

## 6. Mystery ledger

- **Is the `n^{-1/2}` rate of C774 the truth?** *Settled, by reparameterization.* It is not a rate in
  `n` at all. The certified `ℓ¹` radius is a function of the uniformity order `k`, equal to `Θ(k)`
  (§2.3–2.4), and C774's family has `k = 3` at every length. For the AME class the radius grows
  linearly in `n` and cannot grow faster (Proposition 5). C774's ledger entry asked for a matching
  lower bound on `ε₀` uniform over `2`-uniform states at fixed `n`; that request should be retired
  rather than answered.
- **The exact `ℓ¹` radius at uniformity order 3.** *Open, but bracketed to a factor 1.47*: in
  `[1, 1.466]` for the constant `√(6q/5)`. Evidence gap: either sharpen Lemma 3 / Corollary 2 at
  `k = 3`, or find a `3`-uniform family failing below `1.466`. Low value; recorded for completeness.
- **The gap between the explicit `eps_0 ≍ q^{-(n+4)/4}/n` and the ceiling `1.34 n^{-1/2}`.** *Open,
  and this is the one that matters.* The obstruction is named and localized: Step A of Theorem 8
  reads the perturbation off a single `(m+1)`-party marginal whose Weyl signal has amplitude
  `q^{-(m+1)/2}`, and no marginal-based detector can beat that. The successor must be global.
  Proposition 9 is the global object to attack, and §4 names the exact missing ingredient (phase
  information in the non-Clifford directions).
- **Why is the overlap gap `p^{-1/2}` and not something that degrades with `n`?** *Settled.* Because
  stabilizer overlaps are quantized by a subgroup index (Lemma 6), and an index is a power of `p`
  regardless of how many parties there are. This is the reason the compactness step could be removed
  at all, and it is worth a sentence in the manuscript: the finite symmetry group is not merely
  discrete, it is *uniformly* separated in defect, by a constant depending only on the
  characteristic.
- **Surprising and unexplained: none remaining.** The one feature that looked odd going in — that a
  `2`-uniform bound would have an `n`-independent constant but an `n`-dependent region — is fully
  explained by §2.5 and is not a coincidence.

---

## 7. Method labels

- §2 (Lemmas 1, 3, Theorem 3, Corollaries 4, Proposition 5) and §3 (Lemmas 6, 7', Propositions 7,
  Theorem 8) and §4 (Proposition 9): proved here, by hand, every step written out above.
- The two tables are evaluations of the closed-form expressions `((k+1)!/48)^{1/(k−1)}` and `k/e`.
  They establish nothing; they display a formula.
- The numbers `θ* = 1.4656…` and the failure of the bound at that point are C774's, not re-derived
  here; §2.5 uses them as an upper bound and cites that task's certificate for them.
- Proposition 7 depends on the correctness of the manuscript's quantitative-axes proof, which is not
  independently verified anywhere in the corpus. Flagged in §3.2.
- The scope judgments — that the marginal route's exponential loss is intrinsic, that Proposition 9
  is the right next object, that the Łojasiewicz fallback is superseded — are my judgment.
</content>
