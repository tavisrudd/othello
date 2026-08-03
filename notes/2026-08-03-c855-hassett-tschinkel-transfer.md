# C855 — the Hassett–Tschinkel determinantal transfer, proved in the consumed instance

**Date:** 2026-08-03
**Lane:** `clebsch` (Paper I stream)
**Task:** C855 target 6 — replace the cited determinantal converse by a self-contained proof of
the exact instance Paper I consumes, in a shape a later session can formalize.
**Scope:** mathematics only. No Lean file was edited, no Lean build, generator, gate or manifest
was run, and no manuscript was changed. `lean/RelativeConicArcs/PaperIOrientationTraceDual.lean`
was read read-only.

**Verdict: proved, in a form strictly stronger than the citation and with strictly weaker
hypotheses.** The singular locus of the cross-golden determinantal cubic threefold is exactly the
six axis points, with no transversality, Bezout, or smooth-dual-surface input. The proof is four
lemmas of linear algebra over the golden field, two of which are twenty and six explicit
determinants; the smoothness of the Clebsch diagonal surface, which is the hypothesis of the cited
proposition, is not used at all.

---

## 1. What Paper I actually consumes

### 1.1 The passage

`papers/clebsch-rigidity/clebsch_rigidity.tex`, the *node frame* paragraph of the orientation
two-graph section (around line 1370), and the corresponding sentence of the proof-sources section
(around line 1466). After constructing the cross-golden block it says:

> Here the cross-golden four-space `Λ` and its trace orthogonal `Λ^⊥` define exactly the paired
> determinantal hypersurfaces of Hassett and Tschinkel. Their Proposition 10 therefore applies:
> smoothness of the cubic surface `P(Λ) ∩ Σ₂` implies that `det(Φ_x) = 0` in `P(Λ^⊥)` has exactly
> six ordinary double points in linear general position. Pair balance makes each
> `p_a = [1 − 6e_a]` singular, and these six points already form a projective frame. They are
> therefore the complete singular locus.

Three of the four things the cited sentence supplies are already owned locally:

| ingredient | where it really comes from |
|-----------------------------------|------------------------------------------------------------|
| the six points are singular       | pair balance, proved in the manuscript |
| they are in linear general position | `crossGoldenMap_mem_ker_iff_constant`: the kernel of `x ↦ Φ_x` is exactly the all-ones line, so the six images of the coordinate vectors are a projective frame in `P(W) ≅ P⁴` |
| each is an ordinary node          | the Hessian block computation `Mu = 0`, `M² = 5I − uuᵀ`, `χ_M(λ) = λ(λ²−5)²`, proved in the manuscript |
| **nothing else is singular**      | **the citation, and only the citation** |

So the consumed content of the transfer is a single sentence:

> **(HT-consumed)** The cubic threefold `{C = 0} ⊆ P(W) ≅ P⁴` has at most six singular points.

Everything else attributed to Proposition 10 in that passage is either proved in the manuscript or
already kernel-checked in the Lean closure. This note proves (HT-consumed) as an equality, over
the field the paper works in, from the closure's own definitions.

### 1.2 The exact source and its own statement

Brendan Hassett and Yuri Tschinkel, *Flops on holomorphic symplectic fourfolds and determinantal
cubic hypersurfaces*, Journal of the Institute of Mathematics of Jussieu **9** (2010), no. 1,
125–153; doi:10.1017/S1474748009000140; arXiv:0805.4162. Section 3 (“Determinantal cubic surfaces
and threefolds”), Proposition 10 — arXiv page 10. Verified against the cached preprint
`/tmp/persistent/tavis/lit-search/ht-0805.4162.pdf`. The journal page for Proposition 10 is not
determinable from anything in this repository and must be read off the published version before it
is quoted as a page pinpoint; the section-plus-proposition locator already used in the manuscript
is exact and needs no change.

Their statement, with `Σ₁ ⊂ Σ₂ ⊂ P(End V)` the rank-one and determinant loci of a
three-dimensional `V`, `Λ ⊆ End V` four-dimensional, `S = P(Λ) ∩ Σ₂`, `Y = P(Λ^⊥) ∩ Σ₂`:

> **Proposition 10.** `Y` is a cubic threefold with six ordinary double points in linear general
> position if and only if `S` is a smooth cubic surface.

Two features of their surrounding text matter here. First, they observe directly that `Y` is
necessarily singular along `P(Λ^⊥) ∩ Σ₁`, which is the same rank-one mechanism this note uses.
Second, their identification of the singular locus with that rank-one set is obtained from Bezout
under an assumed transversality of `P(Λ^⊥)` with `Σ₁` and with the smooth points of `Σ₂`. That
transversality is exactly the part which is hard to verify for one concrete `Λ`, and it is what
the proof below replaces by a finite check.

### 1.3 The instance, spelled out

Fix a field `K` with a root `t` of `T² = T + 1` and with `5 ≠ 0` in `K` (equivalently `2t ≠ 1`).
The paper takes `K = E = ℚ(√5)`, `t = t₊ = (1+√5)/2`, and `1 − t = t₋`; note `√5 = 2t − 1`.

* `B` is the six-by-six symmetric conference matrix of the section: zero diagonal, entries `±1`
  off the diagonal, `B² = 5I`. Two gauges appear and are bridged by
  `paperConferenceMatrix_eq_transport`: the manuscript's `B` and the repository's
  `conferenceMatrix`. Everything below is invariant under row permutation and diagonal sign
  switching, so it holds verbatim in both.
* `U(t)` is the displayed six-by-three matrix (`paperGoldenEigenspaceBasis`, transported to
  `goldenEigenspaceBasis`), and `V_± ⊆ K⁶` are the column spaces of `U(t₊)`, `U(t₋)`. They are the
  `±√5` eigenspaces of `B`: `B U(t) = (2t−1) U(t)`.
* `Φ_x = U(t₋)ᵀ D_x U(t₊)` for `D_x = diag(x₀,…,x₅)` — the cross-golden block, `crossGoldenBlock`.
  Equivalently `Φ_x` is the matrix of the bilinear pairing `(q, p) ↦ Σᵢ xᵢ qᵢ pᵢ` on `V₋ × V₊`.
* `C(x) = Σ_{i<j<k} c_{ijk} xᵢxⱼx_k` with `c_{ijk} = B_{ij}B_{jk}B_{ki}` is the support cubic
  (`triangleCubic`), and `det Φ_x = −C(x)` (`det_crossGoldenBlock_eq_neg_supportCubic`).
* `W = im(x ↦ Φ_x)` is five-dimensional with kernel the all-ones line, so `P(W) ≅ P(K⁶/K·1) ≅ P⁴`,
  and the cubic threefold in question is `{C = 0} ⊆ P⁴`. `Λ = W^⊥` under the trace pairing is
  four-dimensional.
* `p_a = [1 − 6e_a] = [Φ_{e_a}]`, since `Φ_1 = 0` gives `Φ_{1−6e_a} = −6 Φ_{e_a}`.

**Theorem (consumed instance, proved in §3).** Let `K` have a golden root `t` and `5 ≠ 0`. For
`x ∈ K⁶` write `∇C(x) = (∂C/∂x₀, …, ∂C/∂x₅)`. Then

    ∇C(x) = 0   ⟺   x ∈ span(1, e_a)  for some a ∈ {0,…,5}.

Consequently the cubic threefold `{C = 0} ⊆ P(W) ≅ P⁴` has exactly six singular points, namely
`p₀,…,p₅`, and they are a projective frame.

Because `Σᵢ ∂C/∂xᵢ = 0` identically (this is the infinitesimal form of `C(x + λ1) = C(x)`), the
gradient is a well-defined differential on the quotient `K⁶/K·1`, so the displayed condition is
exactly singularity of the threefold in `P⁴`. If `char K ≠ 3`, Euler's identity
`3C = Σ xᵢ ∂ᵢC` makes `C(x) = 0` automatic at such a point.

---

## 2. The two finite inputs

Both are statements about the six rows `r₀,…,r₅` of `U(t)`, read as points of `P²(K)`. In the
manuscript gauge these are

    (t,t,−1), (t,1,−t), (1,t,−t), (1,0,0), (0,1,0), (0,0,1),

and in the repository gauge they are the same six points of `P²` after a permutation and sign
changes, so the two lemmas are gauge-independent.

### Lemma A (arc / MDS). Every three of the six rows are independent.

All twenty three-by-three minors of `U(t)`, reduced modulo `T² − T − 1`, lie in `{±1, ±t}`. The
ten minors that use two of `r₃, r₄, r₅` are, up to sign, single entries of the remaining row, all
of which are `±1` or `±t`. The remaining ten evaluate, in the manuscript gauge, to

    {0,1,2}: t     {0,1,3}: −t    {0,1,4}: 1     {0,1,5}: −1
    {0,2,3}: −1    {0,2,4}: t     {0,2,5}: 1     {1,2,3}: 1
    {1,2,4}: 1     {1,2,5}: t

Since `t = 0` would force `0 = 1` in `t² = t + 1`, all twenty are units.

**Consequence (the only form used below).** Every nonzero `v ∈ V₊` has at least four nonzero
coordinates, and likewise for `V₋`. Indeed `v = U(t)α` has `vᵢ = 0` exactly when `rᵢ` lies on the
line `α^⊥`, and by Lemma A a line carries at most two of the six points. Equivalently `V_±` are
`[6,3]` MDS codes. Two shortening facts follow and are used verbatim:

* `dim(V_± ∩ {v_a = 0}) = 2` for each `a`;
* `dim(V_± ∩ {v_a = v_b = 0}) = 1` for each `a ≠ b`;
* `V_± ∩ {v_a = v_b = v_c = 0} = 0` for distinct `a,b,c`.

### Lemma B (no conic). The six rows of `U(t)` lie on no conic of `P²`.

Because `r₃, r₄, r₅` are the coordinate points, a conic through them has the shape
`α yz + β zx + γ xy = 0`. Substituting the other three rows gives

    r₀: −αt − βt + γt + γ = 0,   r₁: −α − βt + γ = 0,   r₂: −αt − β + γ = 0.

Subtracting the last two gives `(t−1)(α−β) = 0`, and `t = 1` would force `−1 = 0`, so `α = β`.
Then `γ = α(1+t) = αt²`, and substituting into the first equation, using `t² = t+1` and
`t³ = 2t+1`, leaves `α(t+2) = 0`. Since `t = −2` would force `4 = −1`, i.e. `5 = 0`, which is
excluded, `α = β = γ = 0`.

Equivalently, the six-by-six Veronese matrix of the rows has determinant `±√5·t² = ±(5+3√5)/2 ≠ 0`.
This is the only place the hypothesis `5 ≠ 0` is used.

**Consequence.** `V₋` is not a generalized Reed–Solomon code: there are no `q ∈ K⁶` with all
coordinates nonzero and no six distinct scalars `ξ₀,…,ξ₅` with
`V₋ = { (f(ξᵢ) qᵢ)ᵢ : deg f ≤ 2 }`, since such a presentation puts the six points on the conic
`b² = ac`.

---

## 3. The proof

Throughout, `⟨·,·⟩` is the standard symmetric bilinear form on `K⁶`.

### Step 0. Orthogonality and the perpendicular of `V₊`.

`conjugateGoldenBases_orthogonal` gives `U(t₋)ᵀU(t₊) = 0`, i.e. `V₋ ⊆ V₊^⊥`. Lemma A gives
`dim V₊ = dim V₋ = 3`, and the standard form is nondegenerate, so `dim V₊^⊥ = 3` and

    V₊^⊥ = V₋.

### Step 1. The corank of `Φ_x` is a `D_x`-stability dimension.

A row vector `αᵀ` kills `Φ_x` on the left exactly when `(U(t₋)α)ᵀ D_x U(t₊) = 0`, that is, exactly
when `q = U(t₋)α ∈ V₋` satisfies `⟨D_x q, p⟩ = 0` for all `p ∈ V₊`, that is `D_x q ∈ V₊^⊥ = V₋`.
Since `α ↦ U(t₋)α` is an isomorphism `K³ → V₋`,

    rank Φ_x = 3 − dim U_x,      U_x := { q ∈ V₋ : D_x q ∈ V₋ }.

Note `U_{x+λ1} = U_x`, matching `crossGoldenBlock_translation_invariant`.

### Step 2. Rank-one classification: `rank Φ_x ≤ 1 ⟺ x ∈ span(1, e_a)`.

The direction `⇐` is immediate: for `x = e_a`, `D_x q = q_a e_a`, and `e_a` has weight one, so by
Lemma A it lies in `V₋` only if it is zero; hence `U_{e_a} = {q ∈ V₋ : q_a = 0}`, which has
dimension two, so `rank Φ_{e_a} = 1`. In particular `Φ_{e_a} ≠ 0`, and it is the rank-one matrix
`ρ_a σ_aᵀ` where `ρ_a`, `σ_a` are the `a`-th rows of `U(t₋)`, `U(t₊)`.

For `⇒`, assume `dim U_x ≥ 2` and choose a two-dimensional `U ⊆ U_x`. Then `U ⊆ V₋` and
`D_x U ⊆ V₋`, so `U + D_x U ⊆ V₋` has dimension two or three.

**Case A: `D_x U ⊆ U`.** `D_x` is diagonal, hence diagonalizable, so `U` has a basis of
`D_x`-eigenvectors `q, q'` with eigenvalues `λ, λ'`. The support of `q` is contained in
`T_λ = {i : xᵢ = λ}` and has size at least four, so `|T_λ| ≥ 4`, and likewise `|T_{λ'}| ≥ 4`. If
`λ ≠ λ'` these index sets are disjoint, which is impossible in a six-element set. So `λ = λ'` and
`U ⊆ V₋ ∩ K^{T_λ}`. If `|T_λ| = 4` that intersection has dimension one, contradicting
`dim U = 2`; so `|T_λ| ≥ 5`. Translating `x` by `−λ1` leaves `U_x` unchanged and makes `x`
supported on at most one coordinate, i.e. `x ∈ span(1, e_a)`.

**Case B: `dim(U + D_x U) = 3`, so `U + D_x U = V₋`.** The induced map `U → V₋/U` is nonzero onto a
one-dimensional space, so it has a one-dimensional kernel: there is `q₀ ≠ 0` in `U` with
`D_x q₀ ∈ U`.

*Case B1: `D_x q₀ ∈ K q₀`.* Then `q₀` is an eigenvector with some eigenvalue `λ`; translate
`x ↦ x − λ1` so that `λ = 0`. Then `x` vanishes on `supp(q₀)`, which has at least four elements,
so `|supp(x)| ≤ 2`. If `|supp(x)| ≤ 1` we are done. If `supp(x) = {a, b}` with `a ≠ b`, then for
every `q ∈ U` the vector `D_x q = x_a q_a e_a + x_b q_b e_b` lies in `V₋` and has weight at most
two, hence is zero by Lemma A; so `q_a = q_b = 0` for all `q ∈ U`, putting the two-dimensional `U`
inside the one-dimensional `V₋ ∩ {v_a = v_b = 0}` — a contradiction.

*Case B2: `q₀` and `D_x q₀` are independent.* Then they span `U`, and since
`D_x U = ⟨D_x q₀, D_x² q₀⟩` while `U + D_x U` is three-dimensional, `q₀, D_x q₀, D_x² q₀` is a
basis of `V₋`. All three are supported inside `Σ = supp(q₀)`, so `V₋ ⊆ K^Σ`. If some `a ∉ Σ` then
every vector of `V₋` vanishes at `a`, contradicting `dim(V₋ ∩ {v_a = 0}) = 2`. So `q₀` has full
support, and

    V₋ = { f(D_x) q₀ : deg f ≤ 2 } = { (f(xᵢ) q₀ᵢ)ᵢ : deg f ≤ 2 },

the map `f ↦ f(D_x)q₀` being injective on polynomials of degree at most two. Now let `ξ ≠ η` be
two values taken by `x` and put `f = (T−ξ)(T−η)`. The codeword `f(D_x)q₀` is nonzero and vanishes
at every `i` with `xᵢ ∈ {ξ, η}`, so by Lemma A at most two coordinates of `x` take a value in
`{ξ, η}`. Applying this to every pair of distinct values forces every value class to be a
singleton, so `x₀,…,x₅` are pairwise distinct. But then the displayed presentation of `V₋` is
exactly a generalized Reed–Solomon presentation with evaluation points `xᵢ` and multipliers
`q₀ᵢ`, and its generator matrix has columns `q₀ᵢ(1, xᵢ, xᵢ²)` lying on the conic `b² = ac`. That
contradicts Lemma B.

So Case B2 is empty and Step 2 is proved. In particular the rank-one elements of `W` are exactly
the nonzero scalar multiples of the six matrices `Φ_{e_a}`.

### Step 3. No rank-one matrix is trace-orthogonal to `W`.

For any three-by-three `N`,

    tr(N Φ_y) = tr(N U(t₋)ᵀ D_y U(t₊)) = tr(D_y · U(t₊) N U(t₋)ᵀ) = Σᵢ yᵢ · (U(t₊) N U(t₋)ᵀ)ᵢᵢ,

so `N ∈ Λ = W^⊥` if and only if the diagonal of `U(t₊) N U(t₋)ᵀ` vanishes. If `N = αβᵀ` has rank
one, that diagonal is `(pᵢ qᵢ)ᵢ` with `p = U(t₊)α ∈ V₊` and `q = U(t₋)β ∈ V₋` both nonzero. By
Lemma A each of `p`, `q` has at least four nonzero coordinates, so their supports meet: some
`pᵢqᵢ ≠ 0`. Hence

    Λ contains no nonzero matrix of rank one.

This is precisely the hypothesis Hassett–Tschinkel extract from smoothness of `S`, namely
`P(Λ) ∩ Σ₁ = ∅`. It is proved here directly, and the rest of their smoothness hypothesis is never
needed.

### Step 4. The gradient criterion, and the conclusion.

For a fixed `y`, the derivative of `x ↦ det Φ_x` in the direction `y` is `tr(adj(Φ_x) Φ_y)`, by
multilinearity of the determinant in the columns together with `Φ` being linear in `x`. Taking
`y = eᵢ` and using `det Φ_x = −C(x)`,

    ∂C/∂xᵢ (x) = − tr( adj(Φ_x) · Φ_{eᵢ} ).

Hence `∇C(x) = 0` if and only if `adj(Φ_x) ∈ Λ`.

Suppose `∇C(x) = 0` and `Φ_x ≠ 0`, so `adj(Φ_x) ∈ Λ`. First, `Φ_x` is singular: `Φ_x` itself lies
in `W`, so `tr(adj(Φ_x) Φ_x) = 0`, while `Φ_x adj(Φ_x) = det(Φ_x) I` gives
`tr(adj(Φ_x) Φ_x) = 3 det Φ_x`. Hence `3 det Φ_x = 0`, and for `char K ≠ 3` we get `det Φ_x = 0`,
i.e. `rank Φ_x ≤ 2`.

If `rank Φ_x = 2` then `Φ_x adj(Φ_x) = det(Φ_x) I = 0`, so the columns of `adj(Φ_x)` lie in the
one-dimensional kernel of `Φ_x`, and `adj(Φ_x) ≠ 0` because some two-by-two minor of a rank-two
matrix is nonzero. So `adj(Φ_x)` has rank one and lies in `Λ`, contradicting Step 3.

Therefore `rank Φ_x ≤ 1`, and Step 2 gives `x ∈ span(1, e_a)`. Conversely each such `x` has
`rank Φ_x ≤ 1`, hence `adj(Φ_x) = 0 ∈ Λ`, hence `∇C(x) = 0`. ∎

The six points `[Φ_{e_a}]` are distinct and form a projective frame in `P(W) ≅ P⁴` because the
kernel of `x ↦ Φ_x` is exactly `K·1`, so the only linear relation among `Φ_{e_0},…,Φ_{e_5}` is
`Σ_a Φ_{e_a} = 0` and any five of them are independent. That is
`crossGoldenMap_mem_ker_iff_constant`, already kernel-checked.

### Hypotheses actually used

A golden root `t ∈ K`; `5 ≠ 0` (Lemma B only); `char K ≠ 3` (only to pass from `3 det Φ_x = 0` to
`det Φ_x = 0`, that is, only to exclude an invertible `Φ_x` — see the mystery ledger).
Characteristic two is allowed. No smoothness, no transversality, no Bezout, no
characteristic-zero geometry.

### Corroboration

Both gauges were checked symbolically in exact `ℚ(√5)` arithmetic: `B² = 5I`; `BU(t) = (2t−1)U(t)`
for both roots; `U(t₋)ᵀU(t₊) = 0`; the twenty three-by-three minors of `U(t)` taking values in
`{±1, ±t}`; the Veronese determinant of the six rows equal to `±(5+3√5)/2`; `det Φ_x = −C(x)` as
polynomials in `x₀,…,x₅`; and, by solving `∇C = 0` chart by chart after the normalization
`x₅ = 0`, exactly six projective solutions `e₀,…,e₄` and `(1,1,1,1,1)` — the latter being
`1 − e₅` — with no positive-dimensional component. These runs are corroboration, not the
deliverable: the proof above is complete on paper. **Open reproducibility item:** the two scripts
currently live only in a session scratchpad and are therefore not evidence under
`notes/research-reproducibility-conventions.md`. A session that wants to quote the numbers must
re-create them as `notes/2026-08-03-c855-ht-transfer-checks.py` and commit them with the note.

---

## 4. Map to the Lean closure

### 4.1 Already kernel-checked, reusable as-is

All in `RelativeConicArcs.PaperIOrientationTraceDual` unless noted.

| step of §3 | existing declaration |
|---|---|
| `B² = 5I` over any base ring | `ClebschGoldenConference.conferenceMatrixOver_sq` |
| `V_±` are the `±√5` eigenspaces | `goldenEigenspaceBasis_eigen` |
| manuscript gauge ↔ repository gauge | `paperConferenceMatrix_eq_transport`, `goldenEigenspaceBasis_eq_paper_transport` |
| `V₋ ⊆ V₊^⊥` (Step 0, half) | `conjugateGoldenBases_orthogonal` |
| `Φ` is linear in `x` (Step 4) | `crossGoldenMap` |
| `Φ_{x+λ1} = Φ_x` (Step 1 remark) | `crossGoldenBlock_translation_invariant` |
| kernel of `Φ` is the all-ones line — projective frame | `crossGoldenMap_mem_ker_iff_constant` |
| `dim W = 5`, `dim Λ = 4`, perfect trace pairing | `finrank_crossGoldenMap_range`, `finrank_traceAnnihilator`, `tracePairing_nondegenerate` |
| `det Φ_x = −C(x)` | `det_crossGoldenBlock_eq_neg_supportCubic` |
| node type at each `p_a` | the manuscript Hessian argument; the `B² = 5I` block identity is available, the Hessian statement itself is not yet a declaration in this module |

Note that `finrank_crossGoldenMap_range` and `finrank_traceAnnihilator` are convenient but not
load-bearing for the new proof: Step 3 works with the diagonal criterion for membership in `Λ` and
never needs its dimension.

### 4.2 New obligations, in dependency order

1. `goldenEigenspaceBasis_minor_isUnit` — for each three-element `S ⊆ Fin 6`, the `S`-rows minor of
   `goldenEigenspaceBasis t` is `±1` or `±t`, hence nonzero. Shape: `fin_cases` over the twenty
   subsets, `Matrix.det_fin_three`, `ring_nf`, then rewrite with `ht : t^2 = t + 1`. This is the
   same tactic pattern already used by `det_crossGoldenBlock_eq_neg_supportCubic`, at a fifth of
   the size.
2. `goldenEigenspaceBasis_support_card` (Lemma A consequence) — for `α : Fin 3 → K` nonzero, the
   set `{i | (goldenEigenspaceBasis t *ᵥ α) i ≠ 0}` has at least four elements. Proof: if three
   coordinates vanish, the corresponding minor annihilates `α`, contradicting step 1. Corollaries
   for the shortened dimensions `2`, `1`, `0`.
3. `goldenEigenspaceBasis_not_on_conic` (Lemma B) — if a symmetric three-by-three `Q` over `K`
   satisfies `rᵢᵀ Q rᵢ = 0` for the six rows `rᵢ`, then `Q = 0`, given `5 ≠ 0`. The three
   coordinate rows give the diagonal, and the elimination of §2 gives the rest; no six-by-six
   determinant is needed.
4. `crossGoldenBlock_rank_le_one_iff` (Step 2) — the substantial one, roughly the length of the
   existing `crossGoldenMap_mem_ker_iff_constant`. Its inner case analysis is finite once the
   support lemmas are available; Case B2 is the only place Lemma B is consumed, and it can be
   phrased without codes as: *if `q₀, D_x q₀, D_x² q₀` is a basis of `V₋` then the six rows of
   `U(t₋)` lie on a conic*.
5. `traceAnnihilator_rankOne_eq_zero` (Step 3) — if `N ∈ traceAnnihilator t` and `N = vecMulVec α β`
   then `N = 0`. Two lines given obligation 2, via the identity
   `tr(N Φ_y) = Σᵢ yᵢ (U(t₊) N U(t₋)ᵀ)ᵢᵢ`, which is itself a short `Matrix.trace_mul_comm`
   computation.
6. `deriv_det_crossGoldenBlock` (Step 4 bridge) — `∂ᵢ(det Φ_x) = tr(adj (Φ_x) * Φ_{eᵢ})`. Because
   `C` is an explicit polynomial, the cleanest Lean form avoids analysis entirely: state it as the
   polynomial identity `supportCubicPartial C x i = − trace (adjugate (crossGoldenBlock t x) *
   crossGoldenBlock t (Pi.single i 1))` with `supportCubicPartial` a new explicit quadratic, and
   discharge it by expansion. Mathlib supplies `Matrix.mul_adjugate`, `Matrix.adjugate_mul`,
   `Matrix.trace_mul_comm`, and `Matrix.det_fin_three`.
7. `singularPoints_supportCubic_eq_axisClasses` — the theorem of §1.3. Assembles 4, 5, 6.
8. Optional but recommended, since the manuscript states it and it is currently prose only:
   `hessian_supportCubic_rank_eq_four` at each `p_a`, from `Mu = 0` and `M² = 5I − uuᵀ`.

Obligations 1, 3 and 6 are finite explicit computations; 2 and 5 are short; 4 is the only one with
real mathematical content, and it is elementary linear algebra with no algebraic geometry.

### 4.3 What disappears

`HassettTschinkelProposition10` and `hassettTschinkel_six_nodes_of_traceDual` become dead once
obligation 7 lands, together with the hypothesis threaded through every use site. The manuscript's
node-frame paragraph then cites nothing: the sentence *“their Proposition 10 therefore applies”*
is replaced by a reference to the paper's own lemma, and Hassett–Tschinkel is demoted to a
context remark (“this is the determinantal duality of [HT, §3, Prop. 10], here proved directly in
the case at hand”). The proof-sources section drops the transfer from its list of external inputs.

---

## 5. Rename and docstring proposal

### 5.1 If the interface is kept as an interim step

The current name encodes an author pair and a proposition number, which the naming rules of
`lean/AGENTS.md` and checklist item 3 of the C855 card both forbid. The declaration is a
`Prop`-valued interface for one implication, so it should be named for the implication.

```lean
/-- Determinantal trace-dual node transfer, as an explicitly supplied hypothesis.

For a three-dimensional vector space `V`, a four-dimensional subspace of `End V` and its
orthogonal complement under the trace pairing cut, from the determinant hypersurface, a cubic
surface and a cubic threefold respectively.  This predicate packages the single implication used
downstream: if the two hypersurfaces are a trace-dual pair and the surface is a smooth section,
then the paired threefold carries six ordinary double points in linear general position.  The
predicate is an assumption, not a theorem; its algebro-geometric content is not formalized in this
development, and each use site supplies it explicitly.

Reference: Brendan Hassett and Yuri Tschinkel, *Flops on holomorphic symplectic fourfolds and
determinantal cubic hypersurfaces*, Journal of the Institute of Mathematics of Jussieu 9 (2010),
no. 1, 125-153, doi:10.1017/S1474748009000140, Section 3, Proposition 10.  The published statement
is an equivalence; only the stated direction is used here. -/
def TraceDualSixNodeTransfer ...
```

and correspondingly `hassettTschinkel_six_nodes_of_traceDual` becomes
`sixNodes_of_smooth_traceDualPartner`. Both names avoid strength words and name the mathematical
content rather than a source.

### 5.2 Recommended

Do not keep the interface. Land obligations 1–7 and delete both declarations, replacing them with

```lean
/-- The singular points of the cross-golden determinantal cubic are exactly the six axis
classes.

Over a field carrying a root `t` of `t^2 = t + 1` and in which `5` is invertible, the support
cubic `C` attached to the golden conference matrix has vanishing gradient at `x` if and only if
`x` lies in the span of the all-ones vector and one coordinate vector.  Since the gradient
annihilates the all-ones direction, this identifies the singular locus of the cubic threefold
`{C = 0}` in the projective space of the cross-golden image with the six classes `[e a]`.

Mechanism: the corank of the cross-golden block `Φ x` is the dimension of the space of vectors of
the negative golden eigenspace that `diag x` keeps inside it; the six rows of the golden
eigenspace basis form a plane arc lying on no conic, which bounds that dimension by one except in
the six listed cases and simultaneously prevents any rank-one matrix from being trace-orthogonal
to the cross-golden image, so the adjugate criterion for a singular point forces the block to have
rank at most one.

This is the case at hand of the determinantal duality of Brendan Hassett and Yuri Tschinkel,
*Flops on holomorphic symplectic fourfolds and determinantal cubic hypersurfaces*, Journal of the
Institute of Mathematics of Jussieu 9 (2010), no. 1, 125-153,
doi:10.1017/S1474748009000140, Section 3, Proposition 10, proved here directly and without that
result's smoothness and transversality hypotheses. -/
theorem singularPoints_supportCubic_eq_axisClasses ...
```

The citation survives as provenance in a docstring, which is what checklist item 5 of the C855
card asks for, while acceptance condition 5 — every used mathematical transfer proved in Lean or
imported as an audited library theorem — is met by proof rather than by an audited import.

---

## 6. Verdict

**Proved.** The Hassett–Tschinkel instance Paper I consumes — that the cross-golden determinantal
cubic threefold has no singular points beyond the six axis points — follows from four elementary
lemmas over the golden field: a twenty-minor arc computation, a six-point no-conic computation, a
kernel-dimension classification of the cross-golden block, and the adjugate criterion for
singularity. The cited proposition's hypothesis (smoothness of the paired Clebsch diagonal
surface) and its proof mechanism (Bezout plus assumed transversality) are both unnecessary. The
transfer is therefore removable from the manuscript's external-input list and from the Lean
closure's axiom-shaped interfaces, and the residual work is formalization, not mathematics.

## 7. Mystery ledger

* *Why does an arc condition control a singular locus?* Settled. Both finite inputs are statements
  about the six rows of `U(t)` as a plane six-arc: “no three collinear” is the minimum-weight-four
  property that makes supports of eigenvectors too large to be disjoint, and “not on a conic” is
  exactly the failure of the negative eigenspace to be a generalized Reed–Solomon code, which is
  the only way a cyclic `diag(x)`-orbit could fill it. So the singular locus is controlled by the
  same six-arc data that the rest of Paper I is about.
* *Cross-lane echo.* The six rows of `U(t)` form a plane six-arc on no conic — the same shape as
  the order-eleven Clebsch hexagon of `notes/2026-08-03-c855-dye-orbit-uniqueness.md`, there in
  characteristic eleven and here over `ℚ(√5)`. Whether the characteristic-zero arc reduces to the
  order-eleven one is not settled and was not investigated; the twenty minors here take values in
  `{±1, ±t}` and the twenty there in `{±1, ±(x−1), ±(x−2), x}`, which is suggestive but not a
  proof. Recorded as a descriptive question with no owning successor; it is a discovery-track
  candidate rather than task scope.
* *The characteristic-three side condition.* Open, and cheap. Step 4 excludes an invertible `Φ_x`
  through `3 det Φ_x = 0`, which needs `char K ≠ 3`. The alternative route is to show directly
  that `Λ` contains no invertible matrix: by Step 3's criterion that would mean an invertible `N`
  with all six entries `(U(t₊) N U(t₋)ᵀ)ᵢᵢ` zero, i.e. six of the nine coefficients of an
  invertible bilinear form vanishing on a spanning configuration. Whether that is impossible was
  not checked. Evidence gap: one six-equation computation over `ℤ[t]/(t²−t−1)`. It does not affect
  Paper I, which works in characteristic zero. Owning successor: the formalization task for
  obligation 7.
* *Smoothness of the Clebsch diagonal surface is now decorative.* Settled as a status change, not
  a gap. It is proved independently in the manuscript and remains the point of the identification
  with the Clebsch cubic, but it is no longer load-bearing for singular-locus completeness. In the
  other direction, the theorem here plus the converse half of Proposition 10 would re-derive that
  smoothness; a direct proof from the present setup would need five conditions on a four-parameter
  family and was not attempted.
* *No genuine mystery remains in the transfer itself.* The statement, its hypotheses, and its use
  are all pinned down, and the residual items above are side conditions and cross-lane curiosity.
