# C913 Package D — source extraction from Woodward's Quantum Kirwan papers

**Purpose**: verbatim source material for the appendix supporting the rank-one tailwise derived
clutching/identification theorem in `papers/cubic-stabilization-irrationality`. Extraction only —
no interpretation, no repair, no extension. All quotes are from `pdftotext` output of the cached
PDFs; line breaks and math have been re-flowed by the extractor, so treat displayed formulas as
transcriptions to be re-checked against the page image before typesetting.

## Sources and provenance (shared lit cache, `/tmp/persistent/tavis/lit-search/`)

| bib key | cache key | URL fetched | pages | sha256 (first 16) |
|---|---|---|---|---|
| `WoodwardQKII`     | `arXiv:1408.5864` | `https://arxiv.org/pdf/1408.5864v4` | 41 | `018530b8cc031ab5` |
| `WoodwardQKIII`    | `arXiv:1408.5869` | `https://arxiv.org/pdf/1408.5869`   | 39 | `5aa794f4d83dd8d1` |
| `GonzalezWoodward` | `arXiv:1208.1727` | `https://arxiv.org/pdf/1208.1727`   | 65 | `2c99203c8e1d7dd3` |

- QK II = "Quantum Kirwan morphism and Gromov–Witten invariants of quotients II",
  published Transformation Groups **20** (2015) 881–920 (per QK III's own reference [27]).
- QK III = "…III", arXiv:1408.5869, math.SG.
- QK I = arXiv:1204.1765, Transformation Groups **20** (2015) 507–556 — QK III's reference [26];
  cited below only where QK III defers to it.
- González–Woodward = "A wall-crossing formula for Gromov–Witten invariants under variation of
  GIT quotient", J. Algebraic Geom. **24** (2015) 171–198; page numbers below are the **arXiv**
  pagination of the cached PDF.

Page numbers for QK III are the printed running-head pages (identical to PDF pages in the cached
file; verified by re-extracting PDF p. 36 with `pdftotext -layout -f 36 -l 36`).

---

## A. QK III, Definition 7.13 — virtual classes / obstruction theory for gauged maps

Located in §7.4 "Gauged Gromov-Witten invariants", statement begins on **p. 10**, parts (a)–(c) on
**pp. 11–12**.

> **Definition 7.13.** (Virtual fundamental classes for moduli stacks of gauged maps) Let `X` be a
> smooth projective `G`-variety.
>
> (a) (Combinatorial type with a single vertex) We already remarked in [27, Example 6.6] that if
> `M^G_n(C, X)` is a Deligne-Mumford stack, then it has a perfect obstruction theory, given by the
> dual of the derived push-forward of the pull-back of the tangent complex `(Rp_* e^* T(X/G))^∨`
> where `p : C^G_n(X, d) → M^G_n(X, d)` is the universal curve, `e : C^G_n(X, d) → X/G` the
> universal stable gauged map, and `T(X/G)` the tangent complex to `X/G`. Hence one obtains a
> virtual fundamental class of expected dimension `[M^G_n(C, X, d)] ∈ A(M^G_n(C, X, d))`.
>
> (b) (Connected combinatorial type) More generally, given any connected rooted tree `Γ` we denote
> by `M^G_{n,Γ}(C, X, d)` resp. `M^{G,fr}_{n,Γ}(C, X, d)` the moduli stack of stable gauged maps
> resp. with framings at the markings of combinatorial type `Γ` and class `d`. Under the assumption
> that `M^G_n(C, X, d)` is Deligne-Mumford, the action of `G^n` on `M^{G,fr}_{n,Γ}(C, X, d)` is
> locally free. The same construction gives a virtual fundamental class
> `[M^G_{n,Γ}(C, X, d)] ∈ A(M^G_{n,Γ}(C, X, d)) ≅ A_{G^n}(M^{G,fr}_{n,Γ}(C, X, d))`.
>
> (c) (Disconnected combinatorial type) Suppose `Γ = Γ_0 ∪ … ∪ Γ_l` with `Γ_0` containing the root
> vertex is given the additional datum of a map from the non-root components to the root edges: …
> `Γ_j` has semi-infinite edges `I_j`, and for each `j = 1, …, l` is given a semi-infinite edge
> `e(j)` of `Γ_0`. We denote by
> `M^{G,f}_{n,Γ}(C, X, d) = (M^{G,fr}_{n_0,Γ_0}(C, X, d_0) × ∏_{j=1}^{l} M_{0,n_j,Γ_j}(X, d_j))/G^{n_0}`
> where the action of the `i`-th factor in `G^{n_0}` acts at the `i`-th framing on the principal
> component, and diagonally on the components corresponding to `Γ_j` with `e(j) = i`. We have
> virtual fundamental classes … and so a virtual fundamental class
> `[M^G_{n,Γ}(C, X, d)] = ∪_{d=d_0+…+d_l} [M^G_{n_0,Γ_0}(C, X, d_0)] × ∏_{j=1}^{l} [M_{0,n_j,Γ_j}(X, d_j)]`
> in `A_{G^{n_0}}(M^{G,fr}_{n_0,Γ_0}(C, X, d) × ∏_j M_{0,n_j}(X, d_j)) ≅ A(M^{G,f}_{n,Γ}(C, X, d))`.

**Base of the obstruction theory.** As stated, 7.13(a) says "perfect obstruction theory" with no
base named; the base is supplied by the cited [27, Example 6.6] (= QK II, p. 38), and by QK III's
own §8.3 restatement:

> QK III, §8.3, **p. 24**: "Recall from [27, Theorem 5.35] the stack `M^G_{n,1}(C, X)` of scaled
> gauged maps from `C` to `X`. Under the stable=semistable assumption it has a perfect relative
> obstruction theorem over `M^{tw}_{n,1}(C)`, whose complex is dual to `Rp_* e^* T(X/G)`, and so a
> virtual fundamental class."

> QK II, **Example 6.6**, p. 38: "(a) (Stable Maps) … the moduli stack `M_{g,n,Γ}(X, d)` … is a
> proper Deligne-Mumford stack equipped with a perfect relative obstruction theory over
> `M_{g,n,Γ}` … (b) (Stable gauged maps) For a type `Γ` and non-negative integer `n` if
> `M^G_{n,Γ}(C, X)` is a Deligne-Mumford substack (equivalently in characteristic zero, all
> automorphism groups are finite) then it has a virtual fundamental class
> `[M^G_{n,Γ}(C, X)] ∈ A(M^G_{n,Γ}(C, X))`, by Example 6.4 (e). (c) Recall that
> `M^G_{n,1}(A, X)` admits a forgetful morphism to `M^{tw}_{n,1}(A)` (where the superscript `tw`
> indicates that we allow orbifold structures at the nodes with infinite scaling, in the case that
> `X//G` is only locally free) and to `M_{n,1}(A)`, the latter collapsing components that become
> unstable after forgetting the morphism to `X/G`. `M^G_{n,1}(A, X)` has a canonical perfect
> relative obstruction theory over `M^{tw}_{n,1}(A)`, whose complex is dual to the push-forward of
> `u^* T(X/G)` over the universal curve over `M^G_{n,1}(A, X)`, by Example 6.4 and so a virtual
> fundamental class `[M^G_{n,1}(A, X)]`."

**Companion index-complex definitions used in §7.1** (QK III, pp. 3–4). For stable maps Woodward
writes `E_Γ(X) := (Rπ_* ev^* TX)^∨` and derives cutting-edge compatibility from the short exact
sequence `0 → ev^* TX → p_* p^* ev^* TX → x_* x^* ev^* TX → 0` and its exact triangle

> `Rπ_* ev^* TX → Rπ''_* p^* ev^* TX → x_* ev^* TX → Rπ_* ev^* TX[1]`   (35)   [p. 3]

together with `Ψ^* L_Δ[-1] → M(Υ, X)^* E_{Γ''}(X) → E_Γ(X) → Ψ^* L_Δ` (p. 4). The twisted-bundle
version (§7.3, p. 9) uses the same triangle with `E` in place of `TX`:
`Rπ_* ev^* E → Rπ''_* p^* ev^* E → x_* ev^* E → Rπ_* ev^* E[1]`.

## B. QK III, Proposition 7.14 — splitting/compatibility axioms (p. 12)

Preceded by "These classes satisfy the following properties similar to those in [3]:" ([3] =
Behrend, *Gromov-Witten invariants in algebraic geometry*, Invent. Math. 127 (1997) 601–617).

> **Proposition 7.14.**
> (a) (Constant maps) If `d = 0` and `genus(C) = 0` then
> `M^G_{Γ,n}(C, X, d) = (X//G) × M_{Γ,n}(C)` and `[M^G_{n,Γ}(C, X, d)] = [X//G × M_{n,Γ}(C)]`.
> (b) (Cutting edges) If `Γ'` is obtained from `Γ` by cutting an edge then (with the obvious
> labelling of the additional component) `[M^G_{n,Γ}(C, X, d)] = Δ^! [M^G_{n+2,Γ'}(C, X, d)]`.
> (c) (Collapsing edges) If `Υ : Γ' → Γ` is a morphism collapsing an edge then
> `M(Υ)^! [M^G_{n,Γ}(C, X, d)]` is the push-forward of `∑_{d' ↦ d} [M^G_{n,Γ'}(C, X, d')]` under
> `F(Υ, X) : M^G_{n,Γ'}(C, X, d') → M_{n,s(Γ')}(C) ×_{M_{n,s(Γ)}(C)} M^G_{n,Γ}(C, X, d)`.
> (d) (Forgetting tails) If `Υ : Γ → Γ'` is a morphism forgetting a tail then
> `M(Υ)^! [M^G_{n,Γ'}(C, X, d)] = [M^G_{n+1,Γ}(C, X, d)]`.

Proof note (p. 12): "(a), (b) and (d) are similar to the ordinary Gromov-Witten case considered in
Behrend [3] … For a morphism `Υ` cutting an edge for gauged maps, recall from [27, Proposition
5.21] that `M^G_{n,Γ}(C, X)` may be identified with the fiber product
`M^G_{n,Γ'}(C, X) ×_{(X/G)^2} (X/G)` over the diagonal `Δ : (X/G) → (X/G)^2`."

## C. QK III, §9.3 — clutching, Corollary 9.10, and equations (54)–(59)

**Definition 9.7** (Clutching construction for gauged maps from `P`), p. 29. For one-parameter
subgroups `φ_± : C^× → G`, `X^{φ_±} := {x ∈ X | ∃ lim_{z→0} φ_±(z)x}`; "If `X` is projective then
`X^{φ_±} = X` but if `X` is linear then `X^{φ_±}` is the sum of the positive weight spaces."
`P(φ_+, φ_-) = (C × G) ∪_{φ_+ φ_-^{-1}} (C × G)` and, for `x ∈ X^{φ_+} ∩ X^{φ_-}`,
`(r_±^* u(φ_+, φ_-, x))(z) = φ_±(z)x, z ∈ C^×`. Orbifold case: `k`-fold cover `π : C^× → C^×`,
`θ` a `k`-th root of unity, `φ̃_±(θ^i)` fixes `x`, `φ̃_+ φ̃_-^{-1}` admits a `k`-th root `φ`, and
`P(φ̃_+, φ̃_-) = (C ∪ G) ∪_φ (C ∪ G)`, `(r_±^* u)(z) = φ̃_±(z^{1/k}) x`.

**Lemma 9.8** (Every fixed point arises from clutching), p. 29. **Lemma 9.9** (Semistability of
gauged maps formed by clutching), p. 30: for `G` a torus and `ρ` sufficiently large,
`(P = P(φ̃_-, φ̃_+), u = u(φ̃_-, φ̃_+, x))` is Mundet semistable iff `x` is semistable.

> **Corollary 9.10.** (Clutching description of the circle-fixed gauged maps) [p. 30] Suppose that
> `G` is a torus. For `ρ` sufficiently large:
> (a) Each component of `M^G_2(P, X, d)^{C^×}` with markings at `0, ∞` is isomorphic to a subset of
> `X//G` with evaluation maps given by `lim_{z→0} φ̃_±(z)x` for some one-parameter subgroups
> `φ̃_± : C^× → G`.
> (b) The fixed point set `M^G_n(P, X, d)^{C^×}` is isomorphic to a union of quotients
> `(M_{0,n_-+1}(X, d_-) ×_{I_{X//G}} M^{G,fr}_2(P, X, d_0)^{C^×} ×_{I_{X//G}} M_{0,n_++1}(X, d_+)) // G^2`  **(54)**
> for some `d_- + d_0 + d_+ = d` and `n_- + n_+ = n`, where the stability condition is induced from
> that on the middle factor.
> (c) The restriction of `λ(γ)` to a fixed point component of `M^G_n(P, X)` in (54) is equal to
> `exp(γ̄ + (d_+ + φ_+, γ)ζ)` where `γ̄` is the image of `γ` under `H^2_G(X) → H(I_{X//G})` and
> `φ_+ ∈ g_Q ≅ H^G_2(X, Q)` is considered an element of `H^G_2(X)` via the push-forward
> `H(BG) → H^G_2(X)`.

Proof (p. 30): (a) from Lemmas 9.8/9.9; "(b) includes the components `C_-`, `C_+` attached to
`0, ∞` and is immediate"; for (c) "the class `[ω_{C,C^×}]` restricts to `0, ζ` respectively at
`0, ∞`", the integral over `C_+` is `(γ, d_+)ζ`, and the principal-component integral is computed
by `C^×`-localization: "Since `C^×` acts on the fiber at `∞` via the one-parameter subgroup
`φ_+`, the restriction of `e^*γ ∪ e_C^*[ω_{C,C^×}]` to the node at `∞` in the universal curve is
`(γ + (γ, φ_+)ζ)ζ`. After dividing by the Euler class, one obtains that the integral over the point
`∞` is `γ + (γ, φ_+)ζ`."

**Factorization reformulation** (p. 31). For `φ̃_±, d_±` and `x` with stabilizer order `k_±`,

> `F^G_{n_±}(φ̃_±, d_±) := {([u], x) ∈ M_{0,n_±+1}(X, d_-) × X | u(z_{n_±+1}) = lim_{z→±∞} φ̃_±(z)x} // G`.
> "Since `x` is stabilized by `φ̃_±(θ)`, where `θ` is a `k`-th root of unity, we have natural maps
> `F^G_{n_±}(φ̃_±, d_±) → I_{X//G}, (u, x) ↦ [x, φ̃_±(θ)]`."  **(55)**
> `F^G_{n_±}(d) := ∪_{φ_± + d_± = d} F^G_{n_±}(φ̃_±, d_±)`.  **(56)**
> "Corollary 9.10 implies
> `M^G_n(P, X, d)^{C^×} ≅ ∪_{d_-+d_+=d} ∪_{n_-+n_+=n} F^G_{n_-}(d_-) ×_{I_{X//G}} F^G_{n_+}(d_+)`."  **(57)**

**Nodal-degeneration picture and the normal-complex splitting** (p. 31):

> "Consider a degeneration of `P^1` to a nodal curve with two components, each projective weighted
> lines `P(1, k)` with node at the orbifold singularity `BZ_k`. Let `P(φ), P(φ_+), P(φ_-)` denote
> the (possibly orbifold) bundles defined by clutching maps `φ, φ_+, φ_-`. Then `P(φ)` degenerates
> to a principal bundle over the nodal line with restrictions `P(φ_+)` and `P(φ_-)`. Each
> `C^×`-fixed section `u` degenerates to a pair of sections `(u_-, u_+)` of `P(φ_-) ∪ P(φ_+)`,
> given by `x` in the trivializations near the node and `φ_±(z)x` in the trivializations near `0`
> in the two copies of `P(1, k)`. … Deforming the node gives rise to an embedding
> `F^G_{n_-}(d_-) ×_X F^G_{n_+}(d_+) → M^G_n(P, X, d)^{C^×}`, and the pullback of the K-class of
> the normal complex is independent of the deformation parameter. It follows that there is an
> isomorphism in K-theory
> `[N(M^G_n(P, X, d)^{C^×})] = [N_-] ⊕ [N_+]`."  **(58)**

with `N_- := N(F^G_{n_-}(d_-))`, `N_+ := N(F^G_{n_+}(d_+))`, the normal complexes of
`M^G_n(P, X, d)^{C^×}` resp. `F^G_{n_∓}(d_∓)` in `M^G_n(P, X, d)` resp.
`M^G_{n_∓}(P(1, k), X, d_∓)`.

> "Explicitly for any type with more than two components in the domain, the normal complex receives
> contributions from deformations of the map, deformations of the node at the principal component,
> and deformations of the attaching point to the principal component, assuming there is some
> non-trivial component attached: In K-theory
> `N_± ≅ (Rp_* e^*(T(X/G)))_{mov} ⊕ (T^∨_{w_+} C ⊗ T^∨_{w_-} Ĉ^ρ) ⊕ T_{w_+} C`"  **(59)**  [p. 31]

> [p. 32] "where `(Rp_* e^*(T(X/G)))_{mov}` is the moving part (under the action of `C^×`) of the
> index of the tangent complex of `X/G` and `w_± ∈ Ĉ^ρ` are the preimages of the node connecting to
> the principal component at `0` in the normalization `Ĉ^ρ`, so that `w_+ = 0` in the principal
> component identified with `C`. The first factor in (59) represents deformations of the map, the
> second deformation of the node, and the third the deformation of the attaching point to the
> principal component. The Euler class is
> `Eul(N_±) = Eul((Rp_* e^*(T(X/G)))_{mov})(∓ζ)(∓ζ - ψ)`
> where `ψ` is the cotangent line of the node of the component attached at `0 ∈ P`."

Pushforward over (55) then gives `ev_∞^*(ev_1^* × … × ev_n^*) : H_G(X)^{⊗n} → H_{C^×}(I_{X//G})`
**(60)** (p. 32). **Example 9.12** (Vector spaces), p. 32, identifies (60) with a cup-product map
`Ψ^{φ_±}` computed as `(p_1, …, p_n)(·) ↦ (κ^G_X|_{q=0})(p_1 … p_n)(· + φ_±)`. **Definition 9.13**
(Localized Gauged Graph Potentials), p. 33, defines `τ^G_{X,±} : QH_G(X) → QH(X//_ρ G)[ζ, ζ^{-1}]]`
as integrals over `F^G_{n_±}(d_±)` of (56).

## D. QK III, Example 9.15 — toric localized gauged graph potential / I-function (pp. 33–34)

> **Example 9.15.** (Localized gauged graph potential for toric quotients) Let `G` be a torus acting
> on a vector space `X` is a vector space with weights `µ_1, …, µ_k` and weight spaces
> `X_1, …, X_k` with free quotient `X//G`. Let `D_j ∈ H^2(X//G)` denote the divisor class
> corresponding to `µ_j`. For any given class `φ ∈ H^G_2(X, Z) ≅ g_Z`, the loci `X^φ` are sums of
> weight spaces `X^φ := {x | ∃ lim_{z→0} φ(z)x} = ⊕_{µ_j(φ)≥0} X_j`. Since there are no
> non-constant stable maps to `X`, `F^G(φ, 0)` is isomorphic to `X^φ//G` under evaluation at any
> generic point. The domain of any gauged map without markings is irreducible and the normal complex
> to `F^G(φ, 0)` is the moving part `Rp_* e^*(T(X/G))_{mov}`. This splits as a sum of `µ_j(φ)`
> copies of `X_j` with weights `1, …, µ_j(φ)` for `µ_j(φ)` negative, and `-µ_j(φ) - 2` copies of the
> normal complex for `µ_j(φ) ≤ 0` with weights `µ_j(φ) + 1, …, -1`. Putting this together with the
> normal bundle of `X^φ//G` in `X//G` and replacing `φ` with `d` we obtain
> `τ^{G,0}_{X,-}(ζ, q) = ∑_{d ∈ H^G_2(X)} q^d · (∏_{j=1}^{k} ∏_{m=-∞}^{0} (D_j + mζ)) / (∏_{j=1}^{k} ∏_{m=-∞}^{µ_j(d)} (D_j + mζ))`  **(63)**

> "Note that the terms with `X^d//G = ∅` contribute zero in the above sum, since in this case the
> factor in the numerator `∏_{µ_j(d)<0} D_j` vanishes."

The marked version is obtained via `∫_{[M_{0,n+1}]} α^n (ζ)^{-2} (ψ_{n+1}/∓ζ)^{n-2}` **(64)**,
which equals `(α/ζ)^n` by the string/dilaton-type relation `ψ_{n+1} = f_i^* ψ_n + [D_{…}]`; hence

> `τ^G_{X,-}(α, ζ, q) = ∑_{d ∈ H^G_2(X)} q^d exp(Ψ^d(α)/ζ) · (∏_{j=1}^{k} ∏_{m=-∞}^{0} (D_j + mζ)) / (∏_{j=1}^{k} ∏_{m=-∞}^{µ_j(d)} (D_j + mζ))`  **(65)**  [p. 34]
>
> "Thus `τ^G_{X,-}` is the generalization of Givental's I-function, see [15], considered in
> Ciocan-Fontanine–Kim [8, Section 5.3]."

Erratum note, QK III acknowledgements (p. 1): "We thank I. Ciocan-Fontanine and B. Kim for pointing
out a missing circle-equivariant term in Example 9.15."

## E. QK III, equation (68) — localized adiabatic limit identity (§9.4, p. 36)

Setting (pp. 35–36): `F^G_{n_±,1}(d)` is "a proper Deligne-Mumford stack. It admits a relative
perfect obstruction theory over `M_{n_±,1}(P(1, k))` induced from the relative perfect obstruction
theory on `M^G_{n_±,1}(P(1, k), X, d)^{C^×}`." For `g ∈ G` of finite order `k`,
`F^G_{n_±,1}(d, [g]) ⊂ F^G_{n_±,1}(d)` is "the locus of bundles-with-sections whose sections take
values in the twisted sector corresponding to `[g] ∈ G/Ad(G)` at `BZ_k`", with
`π_± : F^G_{n_±,1}(d_±, [g]) → M_{0,1}(P(1, k)) ≅ P`. Then

> `π^{-1}_±(ρ) = ∪_{d_-+φ_-=d, φ̃_-(θ)=g} F^G_{n_±}(d_-, φ_-)`  **(66)**  [p. 35]
> `π^{-1}_±(∞) = ∪ (∏_{j=1}^{r} M^G_{i_j,1}(A, X)) ×_{(I_{X//G})^r} M_{0,r+1}(X//G, d) ×_{I_{X//G}} (X^g//Z_g)`  **(67)**  [p. 35]

and `F^G_{n,1}(d) = ∪_{d_-+d_+=d, n_-+n_+=n} ∪_{[g] ∈ G/Ad(G)} F^G_{n_-,1}(d_+, [g]) ×_{I_{X//G} × P} F^G_{n_+,1}(d_-, [g])`.

> Proof (of [26, Theorem 1.6]) [p. 36]: "The divisor class relation `[π^{-1}(0)] = [π^{-1}(∞)]`
> implies that the integrals over (66), (67) are equal. Hence for any
> `α_∞ ∈ H(X^g//Z_g) ⊂ H(I_{X//G})`, we have
> `∑_{[I_1,…,I_r]} ∫_{[I_{X//G}]} (τ^r_{X//G,-}(κ^{G,|I_1|}_X(α_{I_1}, 1), …, κ^{G,|I_r|}_X(α_{I_r}, 1), 1) ∪ α_∞) = ∫_{[I_{X//G}]} τ^{G,n}_{X,-}(α_1, …, α_n, 1) ∪ α_∞.`"  **(68)**

(Summing over `n` with `α_1 = … = α_n = α` then gives
`∫_{[I_{X//G}]} (τ_{X//G,-} ∘ κ^G_X)(α) ∪ α_∞ = ∫_{[I_{X//G}]} τ^G_{X,-}(α) ∪ α_∞`.)
Here `[26] = QK I` and `[26, Theorem 1.6]` is the localized refinement of the adiabatic limit
theorem `[26, Theorem 1.5]`.

## F. Conventions used in QK III §§7–9

- **Framework: classical stacks with (relative) perfect obstruction theories, not derived stacks.**
  No occurrence of "derived stack" anywhere in QK III. Woodward uses Behrend–Fantechi-style perfect
  obstruction theories, Artin stacks of prestable curves as bases, and Vistoli bivariant Chow theory
  for representable morphisms: QK III, Example 7.2, p. 4 — "morphisms of Artin resp.
  Deligne-Mumford stacks `M(Υ) : M_{g,n,Γ'} → M_{g,n,Γ}`, `M(Υ) : M_{g,n,Γ'}(X) → M_{g,n,Γ}(X)`" and
  "All the squares are Cartesian and it follows as in [3] (see especially [3, Proposition 8], which
  uses bivariant Chow theory for representable morphisms of Artin stacks)". "Derived" appears only
  in the phrase "derived push-forward"/"derived category of bounded complexes of coherent sheaves"
  (Def. 7.13(a); §7.3, p. 9).
- **Relative virtual classes**: QK II §6, p. 38, item (c): "Let `f : X → Y` be a representable
  morphism of algebraic stacks, and `A^∨(X → Y)` the bivariant Chow group constructed by Vistoli
  [53] … Given a relative perfect obstruction theory let `[X] ∈ A_{dim(Y)+rk(E)}(X)` be the relative
  virtual fundamental class given by intersecting `C_E` with the zero section of `E^{∨,1}`."
- **Gauged maps**: objects are `(P → C, u : Ĉ → P(X))` with a principal component `C_0` and bubble
  components; stability is Mundet semistability with polarization/area parameter `ρ` (QK III Lemma
  9.9, p. 30; González–Woodward §3, quoted below). Section 9 fixes `C = P` (the projective line with
  its `C^×`-action) and works with the graph space `M^G_n(P, X, d)` and its `C^×`-fixed locus.
- **Scaling / curves with scaling**: `M^G_{n,1}(C, X)` is the stack of *scaled* gauged maps from
  [27, Theorem 5.35]; scaled invariants `⟨α, β⟩_{d,1,E} = ∫_{[M^G_{n,1}(C,X,d)]} ev^*α ∪ f^*β ∪ ε(E)`
  **(48)**, QK III Definition 8.11, p. 24. The adiabatic limit theorem follows from the divisor class
  relation `[M_n(C)] = [∪_{r,[I_1,…,I_r]} D_{I_1,…,I_r}] ∈ H(M_{n,1}(C))` **(49)**, p. 24.
- **Affine gauged maps**: QK III §8.1, p. 16 — invariants defined by integration over the moduli
  stack of affine gauged maps `M^G_{n,1}(A, X, d)`, virtual classes in Definition 8.1(a)(b)(c)
  (pp. 16–17); "because the source moduli space `M_{n,1}(A)` is not smooth, not every boundary
  divisor is Cartier and so there is a new collapsing edges with relations axiom". Standing
  hypothesis there: "Let `X` be a smooth polarized quasiprojective variety such that the git quotient
  `X//G` is a (necessarily smooth) Deligne-Mumford stack." The quantum Kirwan morphism is
  Definition 8.5, p. 20.
- **Inertia / rigidified inertia / twisted sectors**: QK III §7.2, p. 7 — "The moduli stack of
  twisted stable maps admits evaluation maps `ev : M_{g,n}(X) → I_X^n`, `ev̄ : M_{g,n}(X) → Ī_X^n`,
  where the second is obtained by composing with the involution of the rigidified inertia stack
  `Ī_X → Ī_X` induced by the automorphism of the group `µ_r` of `r`-th roots of unity
  `µ_r → µ_r, ϕ ↦ ϕ^{-1}`. (See [27, Section 4.3] for the definition of the rigidified inertia
  stack.)" The referenced QK II Proposition 4.3(f),(g), p. 10: `I_X = ∪_{[g] ∈ G/Ad(G)} X^g/Z_g` for
  a global finite quotient; `I_X = ∪_{r>0} I_{X,r}`, `I_{X,r} := Hom_{rep}(Bµ_r, X)`; and
  **rigidification** `Ī_X = ∪_{r>0} Ī_{X,r}`, `Ī_{X,r} := I_{X/r}/Bµ_r`, "the rigidified inertia
  stack of representable morphisms from `Bµ_r` to `X` … There is a canonical quotient cover
  `π : I_X → Ī_X` which acts on cohomology as an isomorphism `π^* H^*(Ī_X, Q) → H^*(I_X, Q)` so for
  the purposes of defining orbifold Gromov-Witten invariants, `Ī_X` can be replaced by `I_X` at the
  cost of additional factors of `r` on the `r`-twisted sectors. If `X = X/G` is a global quotient of
  a scheme `X` by a finite group `G` then `Ī_{X/G} = ⨿_{(g)} X^{ss,g}/(Z_g/⟨g⟩)`."
  Note that §9 writes the fibre products in (54)/(57)/(67) over `I_{X//G}` (unrigidified).
- **Orbifold Gromov–Witten input**: Chen–Ruan [6] and Abramovich–Graber–Vistoli [1] (QK III §7.2,
  p. 7), "needed in our case if the geometric invariant theory quotient `X//G` is an orbifold".

## G. QK II, Example 5.23 — `P^2` and its blow-up as a rank-two-weight quotient (p. 24)

> **Example 5.23.** (The projective plane and its blow-up as a quotient of affine fourspace)
> Suppose that `X = C^4` and `G = (C^×)^2` acting with weights `(1, 0), (1, 0), (1, 1), (0, 1)`.
> (a) For `ν = (1, 2)` the unstable locus has a component given by the sum of the weight spaces with
> weights `(1, 0), (1, 1)` and a component equal to the weight space with weight `(0, 1)`. The
> quotient `X//G` is isomorphic to `P^2` via the map `[x_1, x_2, x_3, x_4] ↦ [x_1, x_2, x_3 x_4^{-1}] ∈ P^2`.
> (b) For `ν = (2, 1)`, the unstable locus has a component given by the sum of the weight spaces
> with weights `(0, 1), (1, 1)` and a component with weight `(0, 1)`. The quotient `X//G` is
> isomorphic to the blow-up of `P^2` with the map to `P^2` blowing down the exceptional divisor
> given by `[x_1, x_2, x_3, x_4] ↦ [x_1, x_2, x_3 x_4^{-1}]`. See Figure 13.

Surrounding conventions (p. 24): `X//G` is a toric stack with residual `(C^×)^k/G`-action;
"One has stable=semistable if `µ_i(ν) ≠ 0` for all `i`"; "The components of the complements of the
hyperplanes `ker µ_i` are called chambers for `ν`". Immediately after, for genus zero and
`c_1(P) = d`, `H^0(C, P ×_G X) → X(d) := ⊕_j X_j^{⊕ max(0, (d, µ_j)+1)}` **(31)**, and
**Proposition 5.24** (p. 24): for `ρ > ρ_0`, `M^G(C, X, d) ≅ H^0(C, P ×_G X)//G = X(d)//G`.

## H. González–Woodward — fixed-locus / marking statements (arXiv pp. 49–51)

> **Proposition 3.15.** [p. 49] Let `Z ⊂ G` be a central subgroup. The fixed point locus for the
> action of `Z` on `M^G_n(C, X)` is the substack whose objects are tuples
> `(p : P → C, u : Ĉ → P(X), z)` such that
> (a) `u` takes values in `P(X^Z)` on the principal component `C_0`;
> (b) for any bubble component `C_i ⊂ Ĉ` mapping to a point in `C`, `u` maps `C_i` to a
> one-dimensional orbit of `Z` on `P(X)`; and
> **(c) any node or marking of `Ĉ` maps to the fixed point set `P(X^Z)`.**

Preceded by (p. 49): "The following is similar to the description of fixed point sets in the case of
stable maps in Kontsevich [42] and Graber–Pandharipande [31, Section 4]."

> **Definition 3.16.** (Fixed point stacks) [p. 50] For any `ζ ∈ g` generating a one-parameter
> subgroup `C^×_ζ ⊂ G`, `G_ζ` denotes the centralizer of `C^×_ζ` … For each rational `ζ ∈ g` let
> `M^{G_ζ}_n(C, X, L_t, ζ, d) ⊂ M^{G_ζ}_n(C, X, L_t, d)` denote the stack of `L_t`-Mundet-semistable
> morphisms from `C` to `X/G_ζ` that are `C^×_ζ`-fixed and take values in `X^ζ` on the principal
> component.

> **Lemma 3.17.** (Large-area limit of fixed gauged maps) [p. 50] For any class `d` there exists a
> `ρ_0` such that for `ρ > ρ_0`, any Mundet-semistable fixed map for polarization `L_t` must consist
> of a principal component mapping to `X^{ζ,t}/G_ζ` and bubbles mapping to `X/G_ζ`.

(`X^{ζ,t}` = "the (possibly empty) locus of `L_t`-semistable points in `X^ζ`"; the proof compares
the Hilbert weight `µ_H(σ, λ)` with `ρ^{-1}` times minus the Ramanathan weight `µ_R(σ, λ)`, using
`-⟨c_1(P), ζ⟩ ≤ c(d)‖ζ‖`, and cites [41, Lemma 3.12] and [30, Lemma 6.3].)

> **Proposition 3.18** (Fixed points as reducible gauged maps). [p. 50] Any `C^×`-fixed component of
> `M^G_n(C, X, L_-, L_+)` is in the image of `M^{G_ζ}_n(C, X, L_t, ζ)` in `M^G_n(C, X, L_-, L_+)` for
> some `t ∈ (-1, 1)` where `ζ ∈ g` is a non-zero element, `G_ζ` is stabilizer, and `C^×_ζ ⊂ G_ζ` the
> unparametrized one-parameter subgroup generated by `ζ`, consisting of maps `u : Ĉ → X/G_ζ` taking
> values in `X^ζ/G_ζ` on the principal component, and `X/G_ζ` on the bubbles.

Proof (pp. 50–51): a fixed object not in `M^{G}_n(C, X, L_±)` carries `ψ_α : P → P`, `φ_α : Ĉ → Ĉ`
trivial on `C_0` with `ψ_α(X) ∘ u = u ∘ φ_α`; "The structure group of `P` reduces to the centralizer
`G_ζ`, and the section `u` takes values in the fixed point set `P(X^ζ) = P(X)^ζ` of `ζ` on the
principal component."

> **Remark 3.19.** [p. 51] "The fixed point locus admits a description in terms of 'bubble trees' as
> follows: There is an isomorphism
> `M^{G_ζ}_n(C, X, L_t, ζ) → (∪ ∏_r M^{G_ζ,fr}_r(C, X^{ζ,t}) ×_{(X^ζ)^r} …)^{C^×_ζ}`" — transcription
> truncated by the extractor; re-read the page image before quoting this one.

---

### Transcription caveats

1. All displayed formulas above are `pdftotext` reconstructions. Superscript/subscript placement,
   bars over `γ`/`ev`/`I`, and the `∪`/`∏` index ranges in (54), (57), (63), (65), (67), (68) and
   Remark 3.19 must be checked against the page images before being copied into the manuscript.
2. QK III's Corollary 9.10 is stated only for `G` a torus and only "for `ρ` sufficiently large".
3. Definition 7.13(a) as printed says "perfect obstruction theory" without naming a base; the
   relative-over-`M^{tw}_{n,1}` form is what QK III §8.3 (p. 24) and QK II Example 6.6(c) (p. 38)
   state.
4. QK II is cached at `v4`; QK III and González–Woodward at the default (latest) arXiv version.
   The published González–Woodward pagination (JAG 24 (2015) 171–198) differs from the arXiv
   pagination used here.
