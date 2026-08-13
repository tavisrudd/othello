# C908: extraction item F — the ℰ-model mutation comparison

Date: 2026-08-12

Status: **in progress (pass 10).** C908 mathematics only; no manuscript, PDF,
mirror, Lean, or C904-surface edit.

## 0. What this pass sets out to prove

The λ-bit of the `(1,5)` channel was settled **negative for the span-model
family** `𝒢` (`notes/2026-08-12-c908-lambda-reduction-and-verdict.md`): the
readout matrix is `N = 120·I`, even in every entry, so `λ_𝒢 = 0`. The scope
sentence of that verdict is the debt this pass pays:

> Transferring the negative to the `ℰ`-model universal family needs the
> mutation comparison (extraction item F, deferred).

`ℰ` is the honest universal family on `X × M` for `M = M_X(v) ≅ Bl_0Θ`,
`v = (3, −H, −H²/2, H³/6)` (Bayer–Beentjes–Feyzbakhsh–Hein–Martinelli–
Rezaee–Schmidt, arXiv:2011.12240 Theorem 7.1; fineness from
Li–Lin–Pertusi–Zhao, arXiv:2406.09124 Corollary 3.9). It is the family whose
`c_4` defines the λ-bit in the pass-5 rigidity theorem
(`notes/2026-08-11-c908-universal-family-even-rigidity.md` §3.1):

\[ N_ℰ(x,a) \;=\; \int_{X×M} p_X^*x \cdot p_M^*\bigl(b^*(Θ∧a)\bigr)\cdot c_4(ℰ) . \]

**Target theorem.** `N_ℰ ≡ N_𝒢 (mod 2)` for the pure antisymmetric tests,
hence `λ_ℰ = λ_𝒢 = 0`, hence *no* universal-family Chern class populates the
`(1,5)` escape channel.

The rest of this note is written as the work lands.

## 1. The mutation, stated exactly

### 1.1 The two sextants and the functor

In the Kuznetsov component `Ku(X)` with numerical lattice
`K_num(Ku(X)) = Zα ⊕ Zβ` (LLPZ Notation 5.2; `γ = −α−β` in the sextant
picture), the span-model objects have class `β+γ` and the ℰ-model objects
class `α+β = v`. The identification is the Serre functor, BBFHMRS (8):

\[ S(F) \;=\; L_{O_X}\bigl(F ⊗ O_X(H)\bigr)[1], \]

giving the moduli isomorphism BBFHMRS (10) and LLPZ Remark 5.5
(`E ∈ M_σ^s(β+γ) ⟺ S(E) ∈ M_σ^s((α+β)[2])`). Concretely on objects,
BBFHMRS Proposition 8.5 / (12): the generic β+γ object is `G = O_Y(D−H)`
and `S(G) = L_{O_X}(O_Y(D))[1] = E_D[2]` with
`E_D = ker(O_X^{⊕3} ↠ O_Y(D))`, `ch(E_D) = v`.

**Chern-character check (the dictionary is exact).** The span-model fibre is
`𝒢_m = ι_*O_{S_{ℓ,ℓ'}}(ℓ'−ℓ)` with `ch(𝒢_m) = (0, H, −H²/2, −H³/6)`
(LLPZ Example 5.7; pass-8 spec §0). Twisting,

\[ ch(𝒢_m ⊗ O_X(H)) \;=\; e^H·(0,H,−H²/2,−H³/6) \;=\; (0,\,H,\,H²/2,\,−H³/6), \]

which is exactly BBFHMRS's `ch(O_Y(D))` in (12). So `𝒢(H)` **is** the
`O_Y(D)`-family, and `ch(ℰ) = 3·ch(O_X) − ch(𝒢(H))`, i.e. `v`. The two models
are related by the mutation triangle, not merely by an abstract sextant
rotation.

### 1.2 The relative form of the mutation — the only statement this pass uses

Let `𝒢_M` denote a family of β+γ objects over a base `B` (below: `B = M`, or
`B = Y = Bl_Δ(F×F)`, pulled back), flat over `B`, on `X × B`. Put
`𝒢_M(H) := 𝒢_M ⊗ p_X^*O_X(H)` and `V := Rp_{B*}(𝒢_M(H)) ∈ D^b(B)`.

**Lemma M (relative mutation).** The relative left mutation of `𝒢_M(H)`
along `O_X` is the cone of the evaluation map, i.e. there is a distinguished
triangle on `X × B`

\[ p_B^*V \;\longrightarrow\; 𝒢_M(H) \;\longrightarrow\;
   L_{O_X}\bigl(𝒢_M(H)\bigr) \xrightarrow{\;+1\;} , \]

so in `K^0(X × B)`

\[ \bigl[L_{O_X}(𝒢_M(H))\bigr] \;=\; \bigl[𝒢_M(H)\bigr] \;−\; \bigl[p_B^*V\bigr]. \]

Fibrewise `V` is `RΓ(X, O_Y(D))`, concentrated in degree zero of rank three
(BBFHMRS §5–6: `h^0(O_Y(D)) = 3`, higher cohomology vanishing), so `V` is a
rank-three object of `D^b(B)` — a vector bundle where the fibre dimension is
constant. Applying the shift, the family of `E_D`'s is
`ℰ' := L_{O_X}(𝒢_M(H))[−1]` and

\[ \boxed{\;[ℰ'] \;=\; [p_B^*V] \;−\; [𝒢_M ⊗ p_X^*O_X(H)] \;\in\; K^0(X×B).\;} \]

*Proof.* Left mutation along an exceptional object is by definition the cone
of the evaluation `RHom(O_X, −) ⊗ O_X → (−)`; relatively over `B` this is
`p_X^*O_X ⊗ p_B^*Rp_{B*}(−) → (−)` by base change (flatness of `𝒢_M(H)` over
`B` and constancy of the fibre cohomology give commutation of `Rp_{B*}` with
base change, so the relative construction restricts to the fibrewise one).
`p_X^*O_X = O_{X×B}`. The K-theory statement is the additivity of `[·]` on
triangles. ∎

**The three moving parts, named.** Passing from the span model to the ℰ-model
changes the family by exactly three operations:

1. a twist by a class pulled back from the **X factor** (`p_X^*O_X(H)`);
2. subtraction of a class pulled back from the **base factor**
   (`p_B^*V`, whose Chern character has only `H^0(X)`-legs);
3. a shift (sign in K-theory) and the residual **twist ambiguity**
   `ℰ ≅ ℰ' ⊗ p_B^*N` of the universal family (pass-5 §2).

## 2. Theorem F: the λ-readout is invariant under all three

**Theorem F (mutation invariance of the λ-readout).** Let `B` be smooth
projective, `t ∈ H^3(B,Z)` any class, `x ∈ H^3(X,Z)`, and let `𝒜, 𝒜'` be two
classes in `K^0(X×B)` related by

\[ [𝒜'] \;=\; ε\Bigl([p_B^*V] \;−\; [𝒜 ⊗ p_X^*O_X(H)]\Bigr) ⊗ [p_B^*N], \qquad ε = ±1, \]

for any `V ∈ K^0(B)` and any line bundle `N` on `B` (the `⊗[p_B^*N]` being
the twist ambiguity). Then

\[ \int_{X×B} p_X^*x·p_B^*t·c_4(𝒜') \;\equiv\;
   \int_{X×B} p_X^*x·p_B^*t·c_4(𝒜) \pmod 2 . \]

In fact the two integrals agree **integrally up to an explicit even
correction** computed in §2.3; only the `(3,\,·)` Künneth block matters and it
is *invariant on the nose* at the level of `ch`.

### 2.1 Step 1 — the `(3,·)` block of `ch` is untouched by all three moves

Write `ch(𝒜) = Σ_{i,j} ch^{(i,j)}` for the Künneth decomposition in
`H^i(X)⊗H^j(B)`. Since `H^1(X,Z) = H^5(X,Z) = 0` and `H^0, H^2, H^4, H^6` are
rank one generated by `1, H, [line], [pt]`, the only odd `X`-degree present is
`3`.

(a) *The `X`-twist.* `ch(𝒜 ⊗ p_X^*O(H)) = e^{H}·ch(𝒜)` with `H = p_X^*H`.
Its `(3,j)` component is `Σ_{k≥0} (H^k/k!)·ch^{(3−2k,\,j)}(𝒜)`. For `k ≥ 1`
the second factor sits in `H^{3−2k}(X)`, i.e. `H^1(X) = 0` or negative degree.
Hence

\[ ch^{(3,j)}\bigl(𝒜 ⊗ p_X^*O(H)\bigr) \;=\; ch^{(3,j)}(𝒜) \quad\text{for all } j. \]

(b) *The base-pullback summand.* `ch(p_B^*V) = p_B^*ch(V)` has `X`-degree `0`
only, so `ch^{(3,j)}(p_B^*V) = 0`.

(c) *The base twist.* `ch(𝒜⊗p_B^*N) = e^{n}·ch(𝒜)`, `n = p_B^*c_1(N)`, whose
`(3,j)` part is `Σ_k (n^k/k!)·ch^{(3,\,j−2k)}(𝒜)` — this one does **not**
preserve the block; it is handled in §2.3 by the pass-5 twist lemma, which is
exactly the statement that its contribution dies in the readout.

(d) *The shift.* `ch(𝒜[1]) = −ch(𝒜)`, so `ch^{(3,j)}` changes sign.

Combining (a)–(b) and (d): with `𝒜' = ε([p_B^*V] − [𝒜(H)])` before the base
twist,

\[ ch^{(3,j)}(𝒜') \;=\; −ε\; ch^{(3,j)}(𝒜) \qquad\text{for every } j. \tag{2.1} \]

**This is the mutation comparison in one line: the mutation acts on the odd
`X`-legs of the Chern character by `∓1` and nothing else.** It is the
statement extraction item F reported as *absent from the literature* and
required to be derived here (F.3, "Do not interpolate"). It is now derived,
from the relative mutation triangle and `H^1(X,Z) = 0` alone — no Abel–Jacobi
additivity, no comparison of the `Φ_v`-torsors, and in particular **no use of
the polarization matrix `S` or of any `S² = −I` centrality shortcut** (see the
sibling naturality report `notes/2026-08-12-c908-z2-naturality-checks.md`,
which shows that shortcut is invalid in this basis; nothing here touches it).

### 2.2 Step 2 — the closed form of the `(3,5)` block of `c_4`

Write `h_k := ch_k`, `g_1 := h_1^{(0,2)}`, `g_2 := h_2^{(0,4)}` (the
`X`-degree-zero Künneth parts, i.e. the Chern data of the restriction
`𝒜|_{\{x\}×B}` to a slice). Newton's identities give, **independently of the
rank**,

\[ c_4 \;=\; \tfrac{1}{24}h_1^4 \;−\;\tfrac12 h_1^2h_2 \;+\;\tfrac12 h_2^2
   \;+\;2h_1h_3\;−\;6h_4 . \]

**Lemma N (the `(3,5)` block).** For any `𝒜 ∈ K^0(X×B)` with `B` smooth
projective,

\[ c_4(𝒜)^{(3,5)} \;=\; \bigl(g_2 − \tfrac12 g_1^2\bigr)\,h_2^{(3,1)}
   \;+\; 2\,g_1\,h_3^{(3,3)} \;−\; 6\,h_4^{(3,5)}
   \;=\; −\,c_2^{(0,4)}\,h_2^{(3,1)} + 2c_1^{(0,2)}h_3^{(3,3)} − 6h_4^{(3,5)} . \]

*Proof.* `H^1(X,Z) = H^5(X,Z) = 0`, so the only odd `X`-degree present is 3,
and `H^3(X)·H^3(X) ⊆ H^6(X)` has `X`-degree 6 ≠ 3. Hence each monomial of
`c_4` contributing to the `(3,·)` block carries **exactly one** factor of odd
`X`-degree, and all its other factors must have `X`-degree 0 (degrees are
non-negative and must sum to 3). `h_1` has total degree 2 and therefore no
`(3,·)` part. So the surviving monomials are: `−\tfrac12 h_1^2h_2` giving
`−\tfrac12 g_1^2h_2^{(3,1)}`; `\tfrac12h_2^2` giving `g_2h_2^{(3,1)}`;
`2h_1h_3` giving `2g_1h_3^{(3,3)}`; and `−6h_4` giving `−6h_4^{(3,5)}`. The
`B`-degrees match (`4+1`, `2+3`, `0+5`). Finally `c_2 = \tfrac12h_1^2 − h_2`
gives `c_2^{(0,4)} = \tfrac12g_1^2 − g_2`. ∎

Two integrality facts used repeatedly below (both because `h_1` has no
`(3,·)` part):

\[ h_2^{(3,1)} = −c_2^{(3,1)}, \qquad 2h_3^{(3,3)} = c_3^{(3,3)} − g_1c_2^{(3,1)}, \]

so `h_2^{(3,1)}` and `2h_3^{(3,3)}` are **integral** classes.

### 2.3 Step 3 — the two twists

**Lemma X (the `X`-twist is exactly invisible).** For any `𝒜 ∈ K^0(X×B)` and
any `L ∈ Pic(X)`, `c_4(𝒜 ⊗ p_X^*L)^{(3,5)} = c_4(𝒜)^{(3,5)}` **exactly**.

*Proof.* `ch(𝒜⊗p_X^*L) = e^{c_1(L)}ch(𝒜)` with `c_1(L)` of `X`-degree 2.
Odd parts: `h_k^{(3,j)}` gains `Σ_{i≥1}(c_1(L)^i/i!)h_{k−i}^{(3−2i,\,j)}`,
which vanishes since `H^1(X) = 0`. Even parts: `g_1` gains
`(r·c_1(L))^{(0,2)} = 0` and `g_2` gains `(c_1(L)h_1 + \tfrac r2c_1(L)^2)^{(0,4)} = 0`,
both because `c_1(L)` has positive `X`-degree. Now apply Lemma N. ∎

**Lemma T (base twist; the rank-three case is even, the rank-zero case is
not).** For `𝒜` of rank `r` on `X×B` and `N ∈ Pic(B)`, `n := p_B^*c_1(N)`,

\[ c_4(𝒜⊗p_B^*N)^{(3,5)} − c_4(𝒜)^{(3,5)}
 \;=\; (2r−6)\,n\,h_3^{(3,3)} \;+\;\bigl[(3−r)ng_1 − (\tbinom r2+3)n^2\bigr]h_2^{(3,1)} . \]

Consequently:

* `r = 3`: the difference is `−6n^2h_2^{(3,1)} = 6n^2c_2^{(3,1)}`, an
  **even integral class**. So `c_4(ℰ⊗p_M^*N)^{(3,5)} ≡ c_4(ℰ)^{(3,5)} (mod 2)`
  unconditionally — the universal family's twist ambiguity is invisible to the
  λ-readout with no lattice input at all.
* `r = 0`: the difference is `≡ n\,c_3^{(3,3)} + n^2c_2^{(3,1)} (mod 2)`,
  which is **not** identically even. The span model is genuinely twist-sensitive.

*Proof.* `g_1 ↦ g_1 + rn`, `g_2 ↦ g_2 + ng_1 + \tfrac r2n^2`, so
`c_2^{(0,4)} ↦ c_2^{(0,4)} + (r−1)ng_1 + \binom r2 n^2`; on the odd side
`h_2^{(3,1)} ↦ h_2^{(3,1)}`, `h_3^{(3,3)} ↦ h_3^{(3,3)} + nh_2^{(3,1)}`,
`h_4^{(3,5)} ↦ h_4^{(3,5)} + nh_3^{(3,3)} + \tfrac12n^2h_2^{(3,1)}`. Substitute
into Lemma N and collect. For `r=0` use
`−6nh_3^{(3,3)} = −3n(c_3^{(3,3)} − g_1c_2^{(3,1)})` and
`3n(g_1−n)h_2^{(3,1)} = −3n(g_1−n)c_2^{(3,1)}`; adding and reducing mod 2
gives `nc_3^{(3,3)} + n^2c_2^{(3,1)}`. ∎

**Audit consequence (a repair owed upstream).** The pass-5 twist lemma
(`notes/2026-08-11-c908-universal-family-even-rigidity.md` §3.2) proved
twist-invariance of the readout by asserting that "every such correction leg
is a product of `b^*(odd)` with classes `b^*t` and `[X]`". For the `r = 1`
branch (odd leg in `H^1(M,Z) = b^*Λ`) that is right; for the **`r = 3` branch
it is false on the corrected lattice**, because `H^3(M,Z)` is a *nonsplit
enlargement* of `b^*∧³Λ` by `H^3(X,Z)` (pass-9 Theorem A), and for a
half-integral class `β` with `b_*β ≡ Θ^{[2]}∧z` the pass-5 kill fails: the
readout of `b_*β∧τ` is `3∫_JΘ^{[3]}∧u_l∧z∧τ`, which is **odd-capable**
(take `u_l = e_1, z = f_1, τ = e_2∧f_2` in a symplectic basis). Lemma T above
repairs the conclusion for the case that matters — rank three — by a purely
integral argument that never touches `H^3(M,Z)`. The pass-5 lemma's *other*
use (the relative-Ext object `E` on `M×M`) is not covered by Lemma T and is
recorded as an open audit item in §6.

