# Sub-A extraction: universal family on Bl_0 Theta as a Kuznetsov moduli space

Sources (fetched fresh from arXiv 2026-08-11; **not** in the lit-search cache — `litcache.py get`
returned `not cached` for both keys, so they were downloaded to the scratchpad):

| key | version read | pages | local path |
|---|---|---|---|
| arXiv:2011.12240 | **v2** [math.AG] 23 Mar 2022 | 26 | `.../scratchpad/papers/2011.12240.pdf`, text `p1.txt` |
| arXiv:2406.09124 | **v1** [math.AG] 13 Jun 2024 | 68 | `.../scratchpad/papers/2406.09124.pdf`, text `p2.txt` |

Note: 2011.12240v2 is the arXiv version, not the published Geometry & Topology 28 (2024) version;
numbering below is the **arXiv v2** numbering.

Line numbers cited as `p1:NNN` / `p2:NNN` refer to the `pdftotext` extractions in the scratchpad,
for re-checking. Formulas are quoted as they appear (pdftotext mangles some sub/superscripts;
where it did I reconstructed and flag it).

---

## 1. The class v and what the objects E_m are (2011.12240)

### 1a. Chern character in H^*(X)

Stated in the abstract (p1:5-8) and again at p1:50-51, p1:715-721, p1:1060-1066:

> the moduli space `M_X(v)` of Gieseker stable sheaves on a smooth cubic threefold X with Chern
> character `v = (3, −H, −H²/2, H³/6)`

i.e. verbatim in display form (p1:718-721):

```
v := ( 3, −H, −(1/2) H², (1/6) H³ )
```

So `ch_0 = 3`, `ch_1 = −H`, `ch_2 = −H²/2`, `ch_3 = H³/6`. With `H³ = 3`, `H²/3` = class of a line,
`H³/3` = class of a point (Lemma 2.8, p1:327-332): so `ch_2 = −(3/2)·(H²/3)` = −3/2 lines and
`ch_3 = (1/2)·(H³/3)` = 1/2 point. `M_X(v)` denotes Gieseker-semistable sheaves of class v;
`M_X(v)` (unbarred, written `MX(v)` in the source) is the **open locus of Gieseker-semistable
vector bundles** (p1:1067).

Useful companions:
- Todd class (Lemma 2.7, p1:306-308): `td(X) = (1, H, (2/3)H², (1/3)H³)`, hence
  `χ(E) = ch_3(E) + H·ch_2(E) + (2/3)H²·ch_1(E) + (1/3)H³·ch_0(E)`.
- `χ(v,v) = −3` (used in Cor. 6.9 / Lemma 8.3, p1:1057, p1:1245).

### 1b. Class in the Kuznetsov lattice

`N(Ku(X)) ≅ Z² ≅ Z[I_ℓ] ⊕ Z[S(I_ℓ)]` (p1:1215-1218, citing [BMMS12, Prop. 2.7]), `ℓ` a line,
`S` the Serre functor of `Ku(X)`, with Euler form in that basis (p1:1222-1225)

```
χ(−,−) = [ −1  −1 ]
         [  0  −1 ]
```

Lemma 8.4 (p1:1275-1278) states the class explicitly:

> an embedding `M_X(v) ↪ M_{σ(α)}([I_ℓ] + [S(I_ℓ)])` ... for
> `v = ch(I_ℓ) + ch(S(I_ℓ)) = (3, −H, −H²/2, H³/6)`

So **`v = [I_ℓ] + [S(I_ℓ)]` in `N(Ku(X))`**, and consistently
- `ch(I_ℓ) = (1, 0, −(1/3)H², 0)` (p1:1226),
- `ch(S(I_ℓ)) = (2, −H, −(1/6)H², (1/6)H³)` (Lemma 8.2, p1:1228),
- `ch(S²(I_ℓ)) = (1, −H, (1/6)H², (1/6)H³)`, and `[S²(I_ℓ)] = [S(I_ℓ)] − [I_ℓ]` (Lemma 8.2).

Lemma 8.3 (p1:1245-1246): the classes `[A]` with `χ([A],[A]) = −3` are, up to sign, exactly
`[K_P] = [I_ℓ] + [S(I_ℓ)]`, `[S(K_P)] = −[I_ℓ] + 2[S(I_ℓ)]`, `[S²(K_P)] = −2[I_ℓ] + [S(I_ℓ)]`.

The introduction's framing (p1:67-69): v is chosen as the class of the projection `K_P` of a
skyscraper `O_P`, `P ∈ X`, defined by `0 → K_P → O^{⊕4} → I_P(1) → 0`.

### 1c. What the objects are, geometrically

**Theorem 6.1(ii)** (p1:728-730) is the complete set-theoretic classification:

> A sheaf E with Chern character v is Gieseker-semistable if and only if it is either equal to the
> reflexive sheaf `K_P` for a point `P ∈ X` (2), or the vector bundle `E_D` for a Weil divisor D on
> a hyperplane section `Y ⊂ X` (1) with `ch(O_Y(D)) = (0, H, (1/2)H², −(1/6)H³)`.

- **Generic point of M (the open locus `M_X(v)` of bundles): rank-3 vector bundles `E_D`, not
  rank two and not twisted ideal sheaves.** Construction (Section 5, p1:643-648): for a hyperplane
  section `Y ⊂ X`, an effective Weil divisor `D` on Y, and `V ⊂ H⁰(O_Y(D))`, `**E**_{D,V}` is the
  cone of `O_X ⊗ V → O_Y(D)`, and `E_{D,V} := H^{-1}(**E**_{D,V})`, so

  ```
  0 → E_{D,V} → O_X ⊗ V → O_Y(D) → H^0(**E**_{D,V}) → 0.
  ```

  For the relevant class, `h⁰(O_Y(D)) = 3` and `O_Y(D)` is globally generated (Theorem 6.1(i),
  p1:725-727), one takes `V = H⁰(O_Y(D))` (drop V from the notation, write `E_D`), `H^0 = 0`, and
  `ch(E_D) = (3, −H, −H²/2, H³/6)` (p1:684-688). Lemma 5.1: `E_{D,V}` is slope-stable and reflexive,
  and a vector bundle when `H^0(**E**_{D,V}) = 0`.

  Equivalently by Theorem 6.1(i) there is a **smooth twisted cubic `C ⊂ Y` of class D**, so the
  generic member is `E_C` = kernel of `O_X^{⊕3} ↠ O_Y(C)` for a twisted cubic C in its unique
  hyperplane section. Proposition 7.2 (p1:1078-1079): `ϕ_0 : T → M_X(v)`, `C ↦ E_C`, is surjective
  from the (open) Hilbert scheme of smooth twisted cubics onto the bundle locus.

- **Over the exceptional divisor `X ⊂ M_X(v)`: the non-locally-free reflexive sheaves `K_P`.**
  Corollary 5.2 (p1:689-698): with `h⁰(I_P(H)) = 4`,

  ```
  (2)   0 → K_P → O_X^{⊕4} → I_P(H) → 0
  ```

  and `ch(K_P) = (3, −H, −H²/2, H³/6)`; `K_P` is reflexive, slope-stable, **locally free except at
  P** (not locally free at P since `Ext¹(O_P, K_P) ≅ Ext¹(O_P, I_P(H)) ≠ 0`). Theorem 7.1
  (p1:56-58): the exceptional divisor "is isomorphic to the cubic threefold X itself, and
  parametrizes non-locally free sheaves". So: **rank-3 reflexive, not rank two, not a twisted ideal
  sheaf** — it is the Kuznetsov projection of the skyscraper `O_P`.

---

## 6. (Answered here, since it is 2011.12240-internal) M → Theta / M → J, fibres, wall-crossing

### 6a. The Abel–Jacobi morphism on the moduli side

**Theorem 7.1** (p1:1069-1074), verbatim:

> The moduli space `M_X(v)` is smooth and irreducible of dimension 4. Moreover, there is an
> Abel-Jacobi morphism `Ψ : M_X(v) → J(X)` sending `E ↦ c̃_2(E) − H²` whose image is a theta
> divisor `Θ` in the intermediate Jacobian `J(X)`. The theta divisor has a unique singular point,
> and `M_X(v)` is the blow up of `Θ` in this point. The exceptional divisor is isomorphic to the
> cubic threefold X itself.

So the map is `Ψ(E) = c̃_2(E) − H²`, using the **rational-equivalence** (tilde) second Chern class
`c̃_2 ∈ CH²(X)`, with base class `H²` (matching Prop. 2.2's base point of class `H²`, p1:243).
`J(X) := H^{2,1}(X)^∨ / H_3(X,Z) = H¹(Ω²_X)^∨ / H_3(X,Z)` (p1:182), a ppav of dimension 5.

The compatibility is Proposition 7.2 (p1:1078-1094): `Ψ|_{M_X(v)} ∘ ϕ_0 = ϕ|_T`, the classical
Abel–Jacobi map on twisted cubics, because for a twisted cubic `C ⊂ Y`, `0 → O_Y → O_Y(C) → T → 0`
gives `c̃h_{≤2}(O_Y(C)) = (0, H, C − H²/2)`, hence `c̃h_{≤2}(E_C) = (3, −H, H²/2 − C)` and
therefore **`c̃_2(E_C) = C`** (p1:1098-1103). Prop. 2.2 (Beauville [Bea02, Prop. 5.2], p1:243-244):
`ϕ : T̄ → J(X)` with base point of class `H²` is algebraic, its image is a theta divisor Θ, and its
generic fibre is `P²`.

### 6b. Fibres, and the fibre over the singular point

**Lemma 7.4** (p1:1149-1150): `Ψ` induces an **isomorphism `M_X(v) → Θ \ {0}`** on the bundle
locus, and **contracts the irreducible divisor `M̄_X(v) \ M_X(v)` to the zero point**; in
particular Θ is smooth away from 0. Proof detail (p1:1161): `c̃_2(K_P) = H²` by definition, so
`Ψ(K_P) = 0` for **every** `P ∈ X`; hence `Ψ^{-1}(0) = M̄_X(v) \ M_X(v) ≅ X`.

So: the fibre over the singular point `0 ∈ Θ` is the whole exceptional divisor `X`, a copy of the
cubic threefold, parametrizing exactly the sheaves `K_P`. All other fibres are single reduced
points (`Ψ|_{M_X(v)}` is an open embedding). Note the contrast with the twisted-cubic
parametrization, whose generic fibre is `P²` — the `P²` is exactly `P(H⁰(O_Y(D)))`, collapsed by
`C ↦ E_C` (Remark 2.3, p1:249-252, and Prop. 7.2).

**Lemma 7.3** (p1:1108-1109): `i : X → M̄_X(v)`, `P ↦ K_P`, is an embedding with normal bundle
`O_X(−H)` (so anti-ample conormal — this is what drives the blow-down).

**Lemma 7.5** (p1:1165-1167): the formal neighbourhood of `0 ∈ Θ` is the vertex of the affine cone
over `X ⊂ P⁴`; `M̄_X(v) = Bl_0(Θ)`; `X` is the union of all rational curves in `M̄_X(v)` and the
unique divisor contracted by any morphism to a complex abelian variety. Explicit formula quoted
(p1:1177-1182):

```
Spec lim_n H^0(X, O_{M̄_X(v)} / I^{n+1})  =  Spec lim_n ⊕_{0 ≤ k ≤ n} H^0(X, O_X(k))
```

(contraction via Artin's criterion [Art70, Cor. 6.12, Thm. 6.2]).

### 6c. Wall-crossing description of the objects, including over the exceptional locus

There is a **single actual wall**, `W` (p1:735-741):

```
(3)    α² + ( β − 1/2 )²  =  1/4
```

At W the two defining sequences become destabilizing sequences in `Coh^β(X)` (p1:742-745):

```
0 → O_Y(D) → E_D[1] → O_X[1]^{⊕3} → 0        and        0 → I_P(H) → K_P[1] → O_X[1]^{⊕4} → 0
```

Lemma 6.8 (p1:957) : W is the unique actual wall for objects of Chern character v, and every object
is destabilized there with a destabilizing sequence of one of these two shapes.

Proposition 6.2 (p1:747-760) classifies the partner side, objects `G` with
`ch(G) = (0, H, (1/2)H², −(1/6)H³)`:
- **above W**: Gieseker-semistable sheaves, either `G = I_{P/Y}(H)` (`Y ∈ |H|`, `P ∈ Y`) or
  `G = O_Y(D)`;
- **below W**: either the unique non-trivial extension
  `(4)  0 → O_X[1] → G_P → I_P(H) → 0` for `P ∈ X`, or `G = O_Y(D)`.

The exceptional-locus objects are produced by the Serre functor from the `G_P` branch
(p1:1334-1339): the triangle `O_X[1] → G_P → I_P(H) → O_X[2]` gives
`L_{O_X}(G_P) = L_{O_X}(I_P(H)) = K_P[1]`, hence

```
(11)   S(G_P) = K_P[2]
```

while the divisor branch gives (p1:1342-1352)

```
(12)   S(O_Y(D−H)) = L_{O_X}(O_Y(D))[1] = L_{O_X}(E_D[1])[1] = E_D[2] .
```

So under `S : M_{σ(α)}(2[I_ℓ] − [S(I_ℓ)]) → M_{σ(α)}([I_ℓ] + [S(I_ℓ)])` (isomorphism (10),
p1:1300-1308, using S-invariance of `σ(α)` from [PY20, Cor. 5.6]), the locus of `G_P(−H)`'s — i.e.
a copy of X — maps to the `K_P` locus, and the `O_Y(D−H)` locus maps to the bundles `E_D`.
Proposition 8.5 (p1:1313-1315) is the classification on that side.

**Theorem 8.7** (p1:1355-1356): `M_{σ(α)}([I_ℓ] + [S(I_ℓ)]) ≅ M̄_X(v)`. **Proposition 8.10**
(p1:1369-1370): σ-stability of class-`[I_ℓ]+[S(I_ℓ)]` objects is the same for any two Serre-invariant
stability conditions; so the identification holds for every Serre-invariant σ (Theorem 1.1,
p1:75-76).

Deformation theory input, **Corollary 6.9** (p1:1041-1051), verbatim:

> Every Gieseker-semistable sheaf E with `ch(E) = (3, −H, −H²/2, H³/6)` satisfies
> `Ext^i(E,E) = C` if `i = 0`, `= C⁴` if `i = 1`, `= 0` otherwise. In particular, the moduli space
> `M_X(v)` is smooth and 4-dimensional.

(So `M` is smooth with `ext¹ = 4 = dim M`, `ext² = ext³ = 0` — obstruction-free.)

---

## 1'. The same class in 2406.09124's notation

Notation 5.2 (p2:1414-1423). `β := [I_ℓ]`, `α := S β[−2]`, `γ := S^{-1} β[2] = S α[1]`, and
`α + γ = β`. Explicit Chern characters, verbatim (5.2):

```
α = (2, −H, −L/2, P/2),    β = (1, 0, −L, 0),    γ = (−1, H, −L/2, −P/2)
```

with `H` the hyperplane class, `L` the class of a line, `P` the class of a point. Euler form
(p2:1425): `χ(α,α) = χ(β,α) = χ(γ,β) = −1`; `χ(α,β) = χ(β,γ) = χ(γ,α) = 0`; `χ(α,γ) = 1`.

**Dictionary to 2011.12240** (using `L = H²/3`, `P = H³/3` from that paper's Lemma 2.8):
`β = [I_ℓ]` with `ch = (1,0,−H²/3,0)` ✓; `α = [S(I_ℓ)]` with `ch = (2,−H,−H²/6,H³/6)` ✓.
Therefore

> **`v = α + β` in 2406.09124's notation `=` `[I_ℓ] + [S(I_ℓ)]` in 2011.12240's**, with
> `χ(v,v) = −3` and `dim M = 1 − χ(v,v) = 4`.

Note also `β + γ = 2β − α`, which is 2011.12240's other class `2[I_ℓ] − [S(I_ℓ)]` (Prop. 8.5
there); the two are exchanged by `S` and give isomorphic moduli spaces. 2406.09124 works with
`β + γ`, whose `ch = (0, H, −3L/2, −P/2)`. **Figure 1** (p2:1467-1493) labels the lattice point for
this class `Bl_p Θ`, and labels `2β` by `Bl_{F(Y3)} J(Y3)`, `β` by `M^s_σ(β) ≅ F(Y3)`.

Phases in the hexagonal normalization (p2:1432-1461):
`Z(E) = e^{πi/3} rk(E) + (√3/3) i H² ch_1(E)`, `φ_σ(I_ℓ) = 1/3`;
`φ_σ(α) = 0`, `φ_σ(β) = 1/3`, `φ_σ(γ) = 2/3`, and `φ_σ(S v) − φ_σ(v) = 5/3`.
`Ku(Y3)` is `(5/3)`-Calabi–Yau, `S³ = [5]`, `S = L[1]` where `L(−) := L_O(− ⊗ O(H))` (p2:1410-1413).

---

## 2. Fine moduli and the universal family

### 2a. 2406.09124 — Corollary 3.9 (confirmed; this is the right locus)

**Corollary 3.9** (p2:928-930), verbatim:

> Let X be a smooth cubic threefold or a smooth Fano threefold with index 1 and genus 8. Then for
> every primitive character `v ∈ K_num(Ku(X))`, the moduli space `M_σ^s(v)` is a smooth
> irreducible projective **fine** moduli space of dimension `1 − χ(v,v)`.

The fineness argument is given in full (p2:936-942) and is the load-bearing part:

> To see that `M_σ^s(v)` is a fine moduli space, it is enough to observe that, by elementary
> calculation, for every primitive v there exists a character w such that `χ(w,v) = 1`. Take an
> object `E_w` of character w, and consider the object `E := p_{1,*} Hom(p_2^*(E_w), U)` on the
> moduli stack `M_σ^s(v)`. Here `U` denotes the universal object on `M_σ^s(v) × X` and `p_i`'s
> denote the projections to the two factors. Note that `U` defines an **α-twisted** object on
> `M_σ^s(v) × X` of a certain Brauer class α, and `E` defines an α-twisted object on `M_σ^s(v)` of
> rank `χ(w,v) = 1`. As the rank of `E` is a multiple of the order of α, we see that **α is
> trivial** and we have a universal family.

(The α here is a Brauer class, unrelated to the character α of Notation 5.2 — the paper reuses the
letter. Other ingredients cited: smoothness from [PY22, Thm. 1.2]; projectivity via a
Bayer–Macrì divisor [BM14] plus [VP21, Cor. 3.4]; irreducibility by "Mukai's trick"
[LMS15, proof of Thm. 2.12, Step 3].)

**Verified here for `v = α + β`** (the paper only asserts existence "by elementary calculation"
for all primitive v). Writing `w = nα + mβ` and using the Euler values above,

```
χ(w, α+β) = n·χ(α,α) + n·χ(α,β) + m·χ(β,α) + m·χ(β,β) = −n + 0 − m − m = −n − 2m ,
```

so `χ(w, α+β) = 1` iff `n = −1 − 2m`. Two convenient solutions with an actual object available:
`w = −α = [α[1]]` (take `E_w = E_ℓ[1]`, `E_ℓ` the rank-2 bundle of Example 5.6), and
`w = α − β = −γ = [γ[1]]` (take `E_w = F_ℓ[1]`). So the argument does go through for
`v = α + β`: the Brauer class is trivial and **`M_σ^s(α+β) ≅ Bl_0 Θ` is a fine moduli space with an
untwisted universal family `U` on `Bl_0 Θ × Y3`**.

### 2b. The twist ambiguity and its normalization

Neither paper states a uniqueness theorem for `U`. What is present:

- **2406.09124, Section 7.2, properties (a)/(b)** (p2:2974-2976), stated as a bare list, no proof:
  > (a) There is a universal family `U → M_σ^s(v) × Y3`;
  > (b) For any `E, F ∈ M_σ^s(v)`, `Ext^i(E,F) = 0` except for `i = 0, 1`.
- **The only normalization anywhere**, in the proof of Proposition 7.6 (p2:3026):
  > **We can choose a universal family `U` such that `a_1 = 0`.**

  where `a_1` is defined by the Künneth decomposition (p2:3016-3023)

  ```
  ch_i(U) = a_i ⊗ 1 + e_i ⊗ H + Σ_{j=1}^{10} f_{i,j} ⊗ ρ_j + g_i ⊗ H² + h_i ⊗ H³,
  ```

  `{ρ_j}_{j=1..10}` a basis of `H³(Y3;Q)`. So `a_1 ∈ H²(M;Q)` is the `H⁰(Y3)`-Künneth component of
  `ch_1(U)`, i.e. `c_1` of the "determinant along M". Twisting `U ↦ U ⊗ p_M^*(N)` for a line
  bundle `N` on M shifts `a_1 ↦ a_1 + rk(v)·c_1(N)`, so `a_1 = 0` is exactly the normalization that
  kills the twist ambiguity, **rationally**. The paper does not say the choice is unique, does not
  discuss the integral obstruction to `a_1 = 0` (divisibility by `rk(v)`), and does not name the
  residual ambiguity (torsion / roots). For `v = α+β`, `rk(v) = rk α + rk β = 3`, so the normalizing
  twist would require `a_1` divisible by 3 in `H²(M;Z)` — **not addressed**.

### 2c. 2011.12240 — no general universal family statement

`rg` over the full text finds the word "universal" exactly once, at p1:1125, and "fine moduli",
"Künneth", "Albanese" (except in the historical remark p1:112) do not appear at all.

- **Corollary 6.9** is *not* about universal families: it is the `Ext^i(E,E)` computation
  (`C, C⁴, 0, 0`) giving smoothness and dim 4. Correcting the brief: Cor. 6.9 is the deformation
  theory input, not a fineness statement.
- **Lemma 7.5** in 2011.12240 is *not* about cohomology generation either: it is the formal
  neighbourhood / `Bl_0 Θ` statement (see §6 above). The cohomology-generation lemma numbered 7.5
  is in the *other* paper.
- The single universal family that does appear is a **partial** one, over the exceptional divisor
  only. Lemma 7.3 proof (p1:1125-1127):
  > The universal family inducing i is given by the sheaf `K` on `X × X` fitting into the short
  > exact sequence
  > ```
  > 0 → K → p^* Ω_{P⁴}|_X (H) → I_Δ(0, H) → 0,
  > ```
  > where `p : X × X → X` is the projection to the first factor.

  This is the family of the `K_P`'s: it realizes `i : X ↪ M̄_X(v)`, `P ↦ K_P`, and is used to
  compute `i^* T_{M̄_X(v)} = H^1(p_* Hom(K,K))` and the normal bundle `O_X(−H)`. It is a genuine
  (untwisted) sheaf on `X × X` because `Ω_{P⁴}|_X(H)` and `I_Δ(0,H)` are, but it only covers the
  exceptional divisor, not all of `M̄_X(v)`.

**So: no statement in 2011.12240 asserts a universal family over all of `M̄_X(v)`.** The only
source for that is 2406.09124 Corollary 3.9 (via the Brauer-class argument), plus its unproved
listing as property (a) in Section 7.2.

---

## 3. Cohomology generation: 2406.09124 Lemma 7.5 and its mechanics

Setting (Section 7.2, "The relative Néron–Severi group", p2:2972-2978): `v` primitive in
`K_num(Ku(Y3))`, `M := M_σ^s(v)`, `m := dim M = 1 − χ(v,v)`, properties (a) and (b) above.

**Lemma 7.5**, verbatim:

> The cohomology algebra `H^*(M_σ^s(v); Q)` is generated by the Künneth components over
> `M_σ^s(v)` of Chern classes `c_i(U)`.

Followed immediately by (p2:3012-3013):

> The statement still holds if we replace "Chern classes" by "Chern characters", which is more
> convenient for our next application.

### The projection object and the exact mechanics

Proof, verbatim and complete (p2:2979-3010), with the displayed formulas:

> For simplicity we write `M = M_σ^s(v)` and `m = dim M` in the proof. Let `δ` denote the class of
> the diagonal in `M × M`. Note that if `δ` can be written in the form
>
> ```
> (7.3)     δ = Σ_i  pr_1^* η_i · pr_2^* ξ_i ,
> ```
>
> where `pr_1` and `pr_2` denote the projections, then the cohomology algebra is generated by
> `{η_i}_i`.
>
> Let `π_{ij}` denote the projection from `M × M × X` onto the i-th and j-th factors. Let
>
> ```
> H  =  RHom_{π_{12}} ( π_{13}^* U , π_{23}^* U ) [1] .
> ```
>
> By [BM02, Proposition 5.4], the object `H` can be represented by a complex
> `K^• = { K^{-1} --u--> K^0 }` of locally free sheaves in degrees −1 and 0. For a point
> `x = (E,F) ∈ M × M`, we have an exact sequence
>
> ```
> 0 → Hom(E,F) → K^{-1}(x) --u(x)--> K^0(x) → Ext^1(E,F) → 0
> ```
>
> by Cohomology and Base Change. Note that `Hom(E,F) ≠ 0` if and only if `x ∈ Δ ⊂ M × M`, and when
> it is nonzero, it has dimension 1. Thus by **Porteous' formula**, the cohomology class of the
> diagonal is a **multiple of `c_m(K^0 − K^{-1}) = c_m(H)`**. By **Grothendieck–Riemann–Roch**, the
> diagonal indeed can be written in the form (7.3), with `{η_i}_i` being the Künneth components of
> the Chern classes.

Precise readings of the requested details:

- **Which `RHom` pushforward, over which projection.** `RHom_{π_{12}}` is the *relative* `RHom`,
  i.e. `R π_{12,*} RHom(−,−)`, over `π_{12} : M × M × Y3 → M × M` — the projection that **kills the
  threefold factor**. The two arguments are the pullbacks of the *same* universal family `U` on
  `M × Y3` along `π_{13}` (first M-factor) and `π_{23}` (second M-factor). Note that `U` appears
  twice with opposite variance, so **the twist ambiguity `U ↦ U ⊗ p_M^* N` cancels in `H` only up
  to `pr_1^* N^∨ ⊗ pr_2^* N`** — the paper does not remark on this; it is a genuine gap if one wants
  `H` (and hence `c_m(H)`) canonical. (The Brauer twist likewise cancels, which is why the formula
  is written even when only a twisted `U` exists.)
- **Rank.** `rk H = −χ(v,v) = m − 1` (from `χ = hom − ext¹ = rk K^{-1} − rk K^0` and the `[1]`
  shift). So the Chern class taken is `c_m`, i.e. **one degree above the rank** — a top Chern class
  in the Porteous sense (degeneracy of `u` by one step has expected codimension
  `rk K^0 − rk K^{-1} + 1 = −χ(v,v) + 1 = m`), not the top Chern class of a rank-`m` bundle.
- **The exact `c_top`/diagonal statement.** `[Δ] = (nonzero rational multiple of) c_m(H)` in
  `H^{2m}(M × M; Q)`. The paper says "a multiple" and does not pin the constant. It is degeneracy
  of `u` along `Δ` (where `hom = 1`) that identifies `Δ` as the Porteous locus; the `Ext^{≥2} = 0`
  property (b) is what makes `H` a two-term complex.
- **From `c_m(H)` to (7.3):** by GRR applied to `π_{12}`, `ch(H)` is a polynomial in the Künneth
  components of `ch(U)` (pulled back along `pr_1`, `pr_2`), so `c_m(H)` expands as
  `Σ pr_1^* η_i · pr_2^* ξ_i` with `η_i` Künneth components of `ch(U)` / `c(U)`. This is
  **Beauville's diagonal trick** ([Bea95] is cited as the model at p2:2972; the intro calls it
  "Beauville's diagonal trick", p2:166).

`[BM02]` in the bibliography is the Bridgeland–Maciocia "Fourier–Mukai transforms for K3 and
elliptic fibrations"-type reference supplying the two-term locally-free representative.

**Applicability to `v = α + β` (our `Bl_0 Θ`):** Lemma 7.5 is stated for primitive `v` with only
(a) and (b) as hypotheses. `α + β` is primitive; (b) holds (2011.12240 Cor. 6.9 gives it for
`E = F`, and Serre-invariance plus `φ_σ(S E) − φ_σ(E) = 5/3` gives `Ext^{≥2} = 0` in general).
`m = 4`, `rk H = 3`, class taken is `c_4(H)`. **However** the Betti-number corollary
(Proposition 7.6) and the Néron–Severi corollary (7.7) below are stated only for
`χ(v,v) < −4` and so **do not formally cover `α+β` (`χ = −3`)**.

---

## 4. Universal family ↔ Abel–Jacobi / `H³(X)` ↔ `H¹(M)`

### 4a. 2406.09124

The Abel–Jacobi map is defined **by the cycle-theoretic second Chern class**, in the introduction
(p2:143-145) and in Section 5.2 (p2:1522-1531):

```
Φ : M_σ(v) → J(Y3) : F ↦ c_2(F) − c_2(F_0)      (base point F_0)
Φ_v : M_σ(v) → J_v(Y3) : F ↦ c_2(F)             (J_v = the component of CH_1(Y3) hit)
```

`J(Y3) := H^{2,1}(Y3)^* / H_3(Y3, Z)`, viewed as a subgroup of `CH_1(Y3)` of a given algebraic
equivalence class. The construction is stated to work even for non-primitive `v` where no universal
family exists: take a smooth presentation `U → M_σ(v)` of the smooth Artin moduli stack, pull back
the universal object, get `U → J_v(Y3)` as a morphism of schemes, descend to the good moduli space
via [Alp13, Thm. 6.6]. Additivity (p2:1538-1543): `Φ_v(E_v) + Φ_w(E_w) = Φ_{v+w}(E_f)` for
`E_f = Cone(E_v → E_w[1])[−1]`.

**The `H³(Y3) → H¹(M)` statement is not isolated as a theorem, but it is exactly what the proof of
Proposition 7.6 produces** (p2:3016-3027). With the Künneth expansion
`ch_i(U) = a_i ⊗ 1 + e_i ⊗ H + Σ_j f_{i,j} ⊗ ρ_j + g_i ⊗ H² + h_i ⊗ H³` and the normalization
`a_1 = 0`:

> By Lemma 7.5, the space `H¹(M_σ^s(v); Q)` is generated by `{ f_{2,j} }_j` and `H²(M_σ^s(v); Q)`
> is generated by `{ e_2, g_3, h_4, f_{2,j_1} ∪ f_{2,j_2} }_{j_1,j_2}`. In particular
> `b_1(M_σ^s(v)) ≤ 10`.

So the map is `ρ_j ↦ f_{2,j}` : the `H³(Y3;Q)`-Künneth component of **`ch_2(U)`** lands in
`H¹(M;Q)`, and it is surjective; combined with injectivity of `Φ_v^*` on cohomology (surjective map
to an abelian variety, [Voi02, p. 177]) and `b_1(J_v(Y3)) = 10`, one gets `b_1(M) = 10` and hence
`H¹(M;Q) ≅ H¹(J;Q) ≅ H³(Y3;Q)` as vector spaces. **Proposition 7.6** (p2:3015) states only the
numbers:

> For every primitive `v ∈ K_num(Ku(Y3))` with `χ(v,v) < −4`, we have Betti numbers of the moduli
> space `b_1(M_σ^s(v)) = 10` and `b_2(M_σ^s(v)) = 46`.

Two explicit relations come out of `Rp_* Hom(O, U) = 0 = Rp_* Hom(O(H), U)` (the defining
orthogonality of `Ku`) plus GRR, with `p : M × Y3 → M` and `td Y3 = 1 + H + (2/3)H² + (1/3)H³`
(p2:3028-3047):

```
p_*( ch(U) · td Y3 ) = p_*( ch(U) · ch(O(−H)) · td Y3 ) = 0
```

degree-2 part gives

```
h_4 + (2/3) g_3 + (1/3) e_2 = 0 ,        (1/3) h_4 + (1/6) e_2 = 0 .
```

Hence `H²(M;Q)` is generated by `{ e_2, f_{2,j_1} ∪ f_{2,j_2} }` and `b_2 ≤ 46 = 1 + 45`.
`b_2(J) = 45`, and `b_2(M) > b_2(J)` because `Φ_v` is surjective with positive-dimensional fibres,
forcing positive relative Néron–Severi rank; so `b_2 = 46`.

**Corollary 7.7** (p2:3061-3062): for primitive `v` with `χ(v,v) < −4`, the **relative
Néron–Severi group of `Φ_v : M_σ^s(v) → J_v(Y3)` has rank 1**.

**No explicit normalization of the identification `H³(Y3) ≅ H¹(M)` is given** beyond `a_1 = 0`;
in particular there is no statement that `ρ_j ↦ f_{2,j}` is an isometry / preserves the polarization
/ is integral, and no comparison of the resulting `H¹(M;Z)` with `H³(Y3;Z)`.

### 4b. 2011.12240

The Abel–Jacobi map on the moduli side is `Ψ(E) = c̃_2(E) − H²` (Theorem 7.1), matched to the
classical `ϕ : T̄ → J(X)` on twisted cubics with base point `H²` via `c̃_2(E_C) = C`
(Proposition 7.2). **There is no statement relating a universal family to `H³(X)` or `H¹` of
anything**; `H¹` of the moduli space is never discussed, and the Albanese only appears in a
historical remark about `F(X)` (p1:112).

---

## 5. Integral (Z-coefficient) statements — what exists

Searched: full text of both papers for `Z)`, `; Z`, `integral`, `Künneth`, `Néron–Severi`,
`Picard`, `primitive`.

**2406.09124** — the cohomological results are stated over `Q`:
- Lemma 7.5 and Prop. 7.6 are explicitly `H^*(−; Q)`, `H^i(−; Q)`.
- The **one integral-coefficient cohomology sentence** is in the introduction (p2:167-168), in the
  proof sketch, not in a numbered theorem:
  > It follows that the image of `H²(M_σ(v), Z) → H²(M_σ(v,c), Z)` has **rank at most 1**.

  This is a rank statement about an integral map, deduced from the rational generation lemma; it is
  not a statement about the integral lattice structure.
- **Corollary 7.7**: relative Néron–Severi group of `Φ_v` has rank 1 (Néron–Severi is integral, but
  again only the rank is asserted).
- **Theorem 7.10** (p2:3314-3316) contains a genuinely integral conclusion:
  > for every primitive `v` with `χ(v,v) < −4` and general `c_v ∈ J_v(Y3)`, the space
  > `M_σ^s(v,c_v)` is a smooth Fano variety with **primitive canonical class**.

  Proved by exhibiting a line `ℓ` in an extension locus `E(E_1,E_2) ≅ P^{r_v − 1}` with
  `ω|_{E(E_1,E_2)} ≅ O_{P^{r_v−1}}(−1)`, `r_v = −χ(v_+, v_-)`, hence `ω_{M_σ^s(v,c_v)} · ℓ = −1`,
  which forces primitivity in `Pic`. This is integral, but it is about the *fibre* of the
  Abel–Jacobi map, not about `M` or about Künneth components of `ch(U)`.

**2011.12240** — no integral cohomology statement about `M̄_X(v)` at all. The integral-flavoured
facts present are: `CH_n^*(X)` has `Z`-basis `1, H, H²/3, H³/3` and consequently
`ch_2(E) ∈ (1/6)H²·Z`, `ch_3(E) ∈ (1/6)H³·Z` (Lemma 2.8, p1:327-328); `N(Ku(X)) ≅ Z²` with the
given Euler matrix (p1:1215-1225); the normal bundle `O_X(−H)` (Lemma 7.3); and the graded ring
`⊕_k H⁰(X, O_X(k))` for the formal neighbourhood (Lemma 7.5).

> **Bottom line for item 5: neither paper contains an integral (Z-coefficient) statement about the
> cohomology of `M`, nor about Künneth components of `c_i(U)` / `ch_i(U)` integrally.** The
> generation result is rational (Lemma 7.5, `Q`), the normalization `a_1 = 0` is rational, and the
> only integral assertions are rank-of-image / primitivity-of-a-divisor statements. Sections
> checked: 2406.09124 §§1, 5, 7 in full and §§3, 4, 6, 8 in relevant part; 2011.12240 in full.

---

## 6'. 2406.09124's own description of `M → Θ` (complements §6 above)

**Example 5.7** (p2:1572-1740), citing `[BBF+24, Theorem 7.1]` — i.e. exactly Theorem 7.1 of
2011.12240 — gives an independent, more explicit geometric model for the class `β + γ`:

- Let `U_β, U_γ` be the universal families on `M_σ^s(β) ≅ M_σ^s(γ) ≅ F(Y3)`. Form the **relative
  `Ext¹` sheaf** `H¹( p_{12,*} Hom(p_{23}^* U_γ, p_{13}^* U_β) )` and let `P̃_σ(β,γ)` be its
  projectivization over `M_σ^s(β) × M_σ^s(γ)`. Since
  `hom(E_γ, E_β[1]) = 2` when `E_β = L(E_γ)[−1]` and `= 1` otherwise, the map
  `π_{β,γ} : P̃_σ(β,γ) → M_σ^s(β) × M_σ^s(γ)` is one-to-one off the diagonal and has `P¹` fibres on
  it. **`P̃_σ(β,γ) ≅ Bl_Δ( F(Y3) × F(Y3) )`**, and `ẽ_{β,γ} : P̃_σ(β,γ) → M_σ^s(β+γ)` is a dominant
  generically finite morphism **of degree 6**.
- **Generic object**: for `ℓ ≠ ℓ'`, with `P_{ℓ,ℓ'} ≅ P³` the span of `ℓ, ℓ'` (or the tangent space
  at `ℓ ∩ ℓ'`), `S_{ℓ,ℓ'} := P_{ℓ,ℓ'} ∩ Y3` the cubic surface, `ι : S_{ℓ,ℓ'} ↪ Y3`:
  > a general object in `M_σ^s(β+γ)` is of the form `ι_* O_{S_{ℓ,ℓ'}}( ℓ' − ℓ )`.

  (This is the "difference of lines" picture; it induces a rational map `M_σ^s(β+γ) ⇢ (P⁴)^*` of
  degree 72, and the 6 ordered pairs `(ℓ_i, ℓ'_i)` on a smooth `S_{ℓ,ℓ'}` with
  `[ℓ_i − ℓ'_i] = [ℓ − ℓ']` explain `deg ẽ_{β,γ} = 6`.)
- **Objects over the exceptional locus**: when `ℓ' = ℓ`, `Hom(F_ℓ[−1], I_ℓ) ≅ Hom(O_ℓ(−H), O_ℓ) ≅ C²`
  and, for `f` with cokernel `O_p`, `p ∈ ℓ`,
  ```
  Cone(f)  ≅  Cone( I_p[−1] --ev--> O(−H)[1] )  =  R_{O(−H)}( I_p ) .
  ```
  So the exceptional divisor is `{ R_{O(−H)}(I_p) : p ∈ Y3 } ≅ Y3` — the **right mutation of the
  ideal sheaf of a point**, the `β+γ`-side avatar of 2011.12240's `K_P` (which is
  `S` of these, cf. (11) there).
- The summary diagram (p2:1709-1739): `Bl_{Bl_1^{-1}(Δ_F)}` structure with
  `Bl_∆(F(Y3)×F(Y3)) --6:1--> M_σ^s(β+γ)`, `Bl_1^{-1}(Δ_{F(Y3)}) → Y3 → {pt}`, and
  `F(Y3) × F(Y3) --Abel–Jacobi--> J(Y3) ⊃ Θ_{J(Y3)}`.

In the proof of Theorem 7.2 this is used as the `n = 1` base case (p2:2894-2896):

> The space `M_σ^s(β + α) ≅ M_σ^s(β + γ)`, and as that in Example 5.7, the map `Φ_{β+γ}` is the
> **resolution of the Theta divisor** in `J_{β+γ}(Y3)`.

Adjacent facts worth having: `dim M_σ^s(2β) = 5` and `M_σ(2β) ≅ Bl_{F(Y3)} J(Y3)` (p2:2905-2908);
**Theorem 7.2** (p2:2885-2889): for `χ(v,v) ≤ −4`, `Φ_v : M_σ(v) → J_v(Y3)` is surjective with
connected fibres, and for primitive `v,w` with `χ < −22` general fibres are stably birational;
**Corollary 7.11** (p2:3347-3349): for primitive `v` with `χ(v,v) ≤ −4`, the MRC quotient of
`M_σ^s(v)` is `J(Y3)`.

---

## Reading log

**2011.12240 v2 (26 pp).** Read in full: §1 (introduction + notation), §2 (cubic threefolds and
intermediate Jacobians), §5 (construction of sheaves), §7 (proof of the main theorem), §8
(Kuznetsov component). Read the statements and skimmed the proofs of: §3 (divisors on hyperplane
sections), §4 (notions of stability), §6 (variation of stability — read Thm 6.1, Prop 6.2, Lemma
6.8, Cor 6.9 in full; skimmed Lemmas 6.3–6.7 tilt-stability computations).

**2406.09124 v1 (68 pp).** Read in full: §1 (introduction), §5 (moduli spaces on `Ku(Y3)`,
including Notations 5.1–5.3, §5.2 Abel–Jacobi, Examples 5.6–5.7), §7.1–7.2 (Abel–Jacobi map,
irreducibility of fibres, relative Néron–Severi, Lemma 7.5 / Prop. 7.6 / Cor. 7.7), Theorem 7.10 and
Corollary 7.11. Read statements + proof of Cor. 3.9; read Definitions 4.6–4.11 (relative `Ext¹`,
Brauer–Severi structure). Skimmed: §2 (stability-condition generalities), §3.1, §6 (stable
birationality, Props 6.2–6.17), §7.3 (quiver model for the tangent bundle degree), §8 (Lagrangians,
Hilbert schemes), Appendices.

## Gaps / negatives, explicit

1. **No uniqueness statement for the universal family in either paper.** Neither says "`U` is unique
   up to `⊗ p_M^* N`". 2406.09124 only says a universal family exists (Cor. 3.9, and restated as
   property (a) in §7.2) and that one may *choose* it with `a_1 = 0` (proof of Prop. 7.6). Sections
   checked: 2406.09124 §3.2, §4.2, §5.2, §7.2; 2011.12240 all sections (`universal` occurs once).
2. **No integral cohomology statement about `M`, and no integral statement about Künneth components
   of `ch(U)`/`c(U)`, in either paper.** See §5 above for the sections checked.
3. **No statement identifying `H³(X;Z)` with `H¹(M;Z)`.** The rational version is implicit in the
   proof of Prop. 7.6 (`ρ_j ↦ f_{2,j}`), not stated as a theorem, and no normalization of that
   identification beyond `a_1 = 0` is given, nor any compatibility with the principal polarization.
4. **`χ(v,v) < −4` gates Props 7.6 / 7.7 / Thm 7.10 / Cor 7.11 out of the `Bl_0 Θ` case**
   (`v = α+β`, `χ = −3`). Only Corollary 3.9 (fineness, smoothness, dim 4) and Lemma 7.5
   (rational cohomology generation) apply to it directly.
5. **The `w` with `χ(w,v) = 1` needed for fineness is not exhibited by the paper** for any specific
   `v` — Cor. 3.9's proof asserts existence "by elementary calculation". For `v = α+β` I verified it
   directly: `χ(nα+mβ, α+β) = −n − 2m`, so `w = −α` or `w = α − β = −γ` works (§2a). Fineness for
   `Bl_0 Θ` therefore holds on the paper's own argument.
