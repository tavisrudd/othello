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


## 3. The mutation difference, in closed form

Apply Lemma M with `𝒜 := 𝒢_M` the rank-zero (β+γ) family, so
`[ℰ'] = [p_B^*V] − [𝒢_M(H)]` with `V = Rp_{B*}(𝒢_M(H))` of rank three.
Total Chern classes multiply: `c(ℰ') = c(p_B^*V)·c(𝒢_M(H))^{-1}`. Write
`c_k := c_k(𝒢_M(H))`, `G := c_1^{(0,2)}`, and `s := c(𝒢_M(H))^{-1}`, so

\[ s_1 = −c_1,\quad s_2 = c_1^2−c_2,\quad s_3 = −c_1^3+2c_1c_2−c_3,\quad
   s_4 = c_1^4−3c_1^2c_2+c_2^2+2c_1c_3−c_4 . \]

Because `c_i(V)` is pulled back from `B` (Künneth type `(0,2i)`) and
`s_1^{(3,·)} = 0`,

\[ c_4(ℰ')^{(3,5)} \;=\; s_4^{(3,5)} \;+\; c_1(V)\,s_3^{(3,3)}
   \;+\; c_2(V)\,s_2^{(3,1)} , \]

and, extracting blocks exactly as in Lemma N (one odd factor, all other
factors of `X`-degree zero),

\[ s_2^{(3,1)} = −c_2^{(3,1)},\qquad s_3^{(3,3)} = 2G\,c_2^{(3,1)} − c_3^{(3,3)}, \]
\[ s_4^{(3,5)} = −3G^2c_2^{(3,1)} + 2c_2^{(0,4)}c_2^{(3,1)} + 2G\,c_3^{(3,3)} − c_4^{(3,5)} . \]

**Theorem F1 (the mutation difference).** With all Chern classes taken of the
rank-zero model `𝒢_M` (legitimate by Lemma X, which makes every block above
insensitive to the `⊗p_X^*O(H)`),

\[ \boxed{\;c_4(ℰ')^{(3,5)} \;\equiv\; c_4(𝒢_M)^{(3,5)}
  \;+\; c_1(V)\,c_3^{(3,3)} \;+\;\bigl(c_2(V) + G^2\bigr)c_2^{(3,1)}
  \pmod 2 .\;} \]

*Proof.* Substitute the three displays; the `−c_4^{(3,5)}` in `s_4` supplies
`c_4(𝒢_M(H))^{(3,5)}` with a sign that is invisible mod 2, and the remaining
integral terms reduce as written (`−3 ≡ 1`, `2·(\text{integral}) ≡ 0`; note
`2c_2^{(0,4)}c_2^{(3,1)}` and `2Gc_3^{(3,3)}` are even integral classes, and
`c_1(V)·2Gc_2^{(3,1)}` likewise). Lemma X gives
`c_4(𝒢_M(H))^{(3,5)} = c_4(𝒢_M)^{(3,5)}`,
`c_2^{(3,1)}(𝒢_M(H)) = c_2^{(3,1)}(𝒢_M)`,
`c_3^{(3,3)}(𝒢_M(H)) = c_3^{(3,3)}(𝒢_M)` and `G(𝒢_M(H)) = G(𝒢_M)`. ∎

**Self-consistency check (twist covariance).** Replace `𝒢_M` by
`𝒢_M ⊗ p_B^*N`. Then `V ↦ V⊗N`, so `c_1(V) ↦ c_1(V)+3n ≡ c_1(V)+n` and
`c_2(V) ↦ c_2(V)+2c_1(V)n+3n^2 ≡ c_2(V)+n^2`, while `G ↦ G` (rank zero!),
`c_2^{(3,1)} ↦ c_2^{(3,1)}`, `c_3^{(3,3)} ↦ c_3^{(3,3)} − 2nc_2^{(3,1)} ≡ c_3^{(3,3)}`.
The right-hand side therefore changes by `n c_3^{(3,3)} + n^2c_2^{(3,1)}`,
which is exactly the change of `c_4(𝒢_M)^{(3,5)}` predicted by Lemma T at
`r = 0` — and the left-hand side is unchanged, as Lemma T at `r = 3` requires.
The formula is covariant under the whole twist torsor. ✓

**Reduction achieved.** The entire ℰ-versus-span comparison is now the single
mod-two class

\[ Δ \;:=\; c_1(V)\,c_3^{(3,3)}(𝒢_M) \;+\;\bigl(c_2(V)+G^2\bigr)c_2^{(3,1)}(𝒢_M)
   \;\in\; H^8(X×M,\mathbf F_2), \]

paired against `x ⊗ b^*(Θ∧a)`. Everything else — the shift, the `X`-twist,
the base-twist ambiguity on both sides, and all of `ch_4` — has cancelled.

## 4. The `t`-independence control already computed half of `Δ`

The span-model certificate carries the twist parameter `t` symbolically:
`ℒ = O_𝒮(Z'−Z+t·ι^*G)`, i.e.

\[ 𝒢^{(t)} \;=\; 𝒢^{(0)} ⊗ p_B^*O(tG),\qquad n = tG . \]

By Lemma T at `r = 0`, the readout class changes by
`tG\,c_3^{(3,3)} + t^2G^2c_2^{(3,1)} \pmod 2`. The certificate **verified**
that the readout `N` is integrally `t`-dependent but **`t`-independent mod
two** (`notes/2026-08-12-c908-lambda-reduction-and-verdict.md` §4, controls).
Taking `t` odd, that verified control is precisely

\[ \int_{X×M} (x⊗b^*(Θ∧a))\cdot\bigl[\,G\,c_3^{(3,3)} + G^2c_2^{(3,1)}\,\bigr]
   \;\equiv\; 0 \pmod 2 \qquad\text{for every tested pair.} \tag{4.1} \]

So if `c_1(V) ≡ G` and `c_2(V) ≡ 0 (mod 2)`, then `Δ` is exactly the class of
(4.1) and the ℰ-model readout is **congruent to the span-model readout**,
giving `λ_ℰ = λ_𝒢 = 0`. The comparison has been reduced to the mod-two Chern
classes of one rank-three bundle on the base.

## 5. What `V` is, and the descent question

### 5.1 `V` is the relative blow-down bundle; `𝒢` really does descend

Fibrewise `V_m = H^0(S_m, O_{S_m}(D_m))` with `S_m = X ∩ P_{ℓ,ℓ'}` a cubic
surface and `D_m = (ℓ'−ℓ) − K_{S_m}`. On a smooth cubic surface,
`(ℓ'−ℓ)^2 = −2`, `(ℓ'−ℓ)·K = 0`, `K^2 = 3`, so

\[ D^2 = 1,\qquad D·K = −3,\qquad χ(O_S(D)) = 1 + \tfrac{D^2−D·K}{2} = 3, \]

and `h^{>0} = 0`. A class with `D^2 = 1`, `D·K = −3` on a cubic surface is
exactly a **blow-down class** (the pullback of a line under one of the 72
morphisms `S → P^2`), and `|D|` realizes that blow-down. So `P(V^∨)` is the
relative `P^2` and `𝒮 → P(V^∨)` the relative blow-down at six sections.

This also settles a live inconsistency in the corpus. The classes
`δ = ℓ'−ℓ` for ordered skew pairs are the `72` roots of the `E_6` lattice
`K^⊥ ⊂ \mathrm{Pic}(S)`, and there are `27·16 = 432` ordered skew pairs, so
`(ℓ,ℓ') ↦ ℓ'−ℓ` is exactly `6:1` onto the roots. That is the same `6` as the
degree of `ẽ_{β,γ} : Bl_Δ(F×F) → M_σ^s(β+γ)` and it factors the span map's
degree as `432 = 6 × 72` (LLPZ's 72), so:

> **the six points of a general `q`-fibre carry the *same* divisor class on
> the *same* cubic surface, hence isomorphic sheaves.** The span-model family
> therefore **does** descend: `(1×q)^*𝒢_M ≅ 𝒢 ⊗ p_Y^*N` for a line bundle
> `N` on `Y`, `𝒢_M` the universal family of `M_σ^s(β+γ)`.

This contradicts the parenthetical in
`notes/2026-08-12-c908-lambda-reduction-and-verdict.md` §1 / audit Finding G3
item 3 ("`𝒢` does not descend along `q`", justified by "`ℒ` is
swap-antisymmetric while the deck action swaps `Z ↔ Z'`"). The factor swap
`σ` is **not** a deck transformation of `q`: `ψ∘σ = −ψ`, so `σ` covers
`(−1)_J`, not the identity. The correct statement is that `σ` descends to the
involution of `M` induced by `(−1)_J`, under which `𝒢_M ↦ 𝒢_M^{[-1]}`. The
consequence is favourable: the span-model integral
`∫_{X×Y}c_4(𝒢)(x⊗μ^*T_a)` differs from the honest downstairs readout
`∫_{X×M}c_4(𝒢_M)(x⊗b^*(Θ∧a))` only by the `p_Y^*N`-twist correction of
Lemma T at `r = 0` — the same shape as `Δ`, and again controlled by (4.1)
whenever `c_1(N) ≡ G` or `≡ 0`.

### 5.2 The one remaining unknown

Both open items are the same two mod-two classes:

\[ c_1(V) \bmod 2 \in H^2(M,\mathbf F_2), \qquad c_2(V) \bmod 2 \in H^4(M,\mathbf F_2), \]

together with the analogous `c_1(N)` for the descent twist. By
Grothendieck–Riemann–Roch for `p_B : X×B → B`, with
`\mathrm{td}(T_X) = 1 + H + \tfrac23H^2 + \tfrac13H^3` and
`e^{H}\mathrm{td}(T_X) = 1 + 2H + \tfrac{13}{2}[\ell] + 5[\mathrm{pt}]`
(using `H^2 = 3[\ell]`, `H^3 = 3[\mathrm{pt}]`), writing
`ch(𝒢) = A_0 + A_1H + A_2[\ell] + A_3[\mathrm{pt}] + (\text{odd-}X\text{ terms})`
with `A_i ∈ H^*(B)`:

\[ ch(V) \;=\; 5A_0 + \tfrac{13}{2}A_1 + 2A_2 + A_3 . \]

*Rank check.* In `B`-degree zero `A_0 = 0`, `A_1 = 1`, `A_2 = −\tfrac32`,
`A_3 = −\tfrac12` (from the fibrewise `ch(𝒢_m) = (0,H,−H^2/2,−H^3/6)`), giving
`\mathrm{rk}\,V = \tfrac{13}{2} − 3 − \tfrac12 = 3` ✓.

So `c_1(V)` and `c_2(V)` are determined by the `B`-degree-2 and -4 parts of
the same `ι_*(D^k)` inventory the committed main-term certificate already
builds. This is a bounded extension of that certificate, not new geometry.

## 6. Evaluating the two unknowns

Throughout this section the base is `B = F×F` with the μ-pushed span model, the
notation of the pass-8 spec (`P_k := ι_*(d^k)`, `d := Z'−Z`,
`D = d + ι^*H` since `−K_{S}= H|_S`), and

\[ C_i := pr_i^*C_s,\qquad G = ψ^*Θ = 2C_1+2C_2−[I]\ \ (\text{extraction B1/C2}),
   \qquad σ = \text{factor swap},\ σ^*d = −d,\ σ^*G = G. \]

### 6.0 `G` is a `Θ`-pullback, so `G^2 ≡ 0`

`Θ^{[2]} = Θ^2/2` is integral on the ppav `J`, hence
`G^2 = ψ^*(Θ^2) = 2ψ^*Θ^{[2]}` is **divisible by two in `H^4(B,Z)`**:

\[ G^2 \equiv 0 \pmod 2 . \tag{6.0} \]

(The same holds downstairs, `G_M = b^*Θ − 2[X]` on `M`, and upstairs on `Y`.)

### 6.1 The Künneth pieces of the span model that the readout sees

From `[P] = 1⊗[\ell] + Ξ + C_s⊗H + 6[pt]_F⊗1` (extraction item E) the two
cylinders are `Z = [\ell]·1 + Ξ_1 + H\,C_1 + 6\,pr_1^*[pt]_F` and likewise for
`Z'`; the `[\ell]`-terms cancel in `d`, so

\[ P_1 = d\text{-push} = ΔΞ + H\,ΔC + 6\,Δpt,\qquad ΔΞ = Ξ_2−Ξ_1,\ ΔC = C_2−C_1 . \]

Hence, with `ι_*(D) = P_1 + H(H+G)` and `ι_*(D^2) = P_2 + 2HP_1 + H^2(H+G)`,

\[ c_2^{(3,1)} = −h_2^{(3,1)} = −ΔΞ \equiv Ξ_1+Ξ_2, \qquad
   c_3^{(3,3)} = P_2^{(3,3)} − 2G\,ΔΞ \equiv P_2^{(3,3)} \pmod 2 . \]

Both are **`σ`-symmetric mod two** (`σ^*d = −d`, so `d^2` and hence `P_2` are
`σ`-invariant, and `Ξ_1+Ξ_2` is manifestly symmetric).

### 6.2 `c_1(V) ≡ G (mod 2)`

Over the locus of smooth fibres, `|D|` is the blow-down `f : 𝒮 → P := P(V^∨)`
(Fulton convention: lines in `V^∨`, `π^P_*O(1) = V`, `f^*O_P(1) = O_𝒮(D)`), a
blow-up along a relative-dimension-zero centre `Z_6` of degree six. Then
`f_*[Exc] = 0`, so `π_*(D\,Exc) = π_*(D^2Exc) = 0`, and the Segre formulas give
`π_*(D^2) = 1`, `π_*(D^3) = s_1(V^∨) = c_1(V)`. The relative Euler sequence
gives `−K_{P/B} = 3ξ + π^*c_1(V)`, hence

\[ κ := −K_{𝒮/B} = ι^*(H−G) = 3D + π^*c_1(V) − Exc,\qquad
   π_*(D^2κ) = 3c_1(V) + c_1(V) = 4c_1(V). \]

The virtual relative tangent is `T_π = ι^*T_X − O(S)|_𝒮`, so with
`c(T_X) = 1+2H+4H^2−2H^3` and `S = H+G`,

\[ c_1(T_π) = κ,\qquad c_2(T_π) = ι^*\bigl(3H^2 + G^2\bigr). \]

*Rank control.* `\mathrm{rk}\,V = π_*[e^D\mathrm{td}(T_π)]_2
= \tfrac12π_*(D^2) + \tfrac12π_*(Dκ) + \tfrac1{12}π_*(κ^2+c_2(T_π))
= \tfrac12 + \tfrac32 + \tfrac{3+9}{12} = 3` ✓ (`π_*κ^2 = K_S^2 = 3`,
`π_*c_2(T_π) = χ_{top}(S) = 9`).

*Degree one.* Ambient computation of the two remaining pushforwards, using
`p_{B*}(H^3β) = 3β` and the Künneth degrees above:

\[ π_*(κ\,c_2(T_π)) = p_{B*}\bigl[(H−G)(3H^2+G^2)(H+G)\bigr] = 0
   \quad(\text{no }X\text{-degree-3 term}), \]
\[ π_*\bigl(D(κ^2+c_2(T_π))\bigr) = p_{B*}\bigl[(P_1+H^2+HG)(4H^2−2HG+2G^2)\bigr]
   = 12\,ΔC + 6\,G . \]

Then `ch_1(V) = \tfrac16π_*(D^3) + \tfrac14π_*(D^2κ) + \tfrac1{12}π_*(D(κ^2+c_2)) + \tfrac1{24}π_*(κc_2)`
becomes `c_1(V) = \tfrac16c_1(V) + c_1(V) + ΔC + \tfrac12G`, i.e.

\[ \boxed{\;c_1(V) \;=\; −6\,ΔC − 3\,G \;=\; 3[I] − 12\,C_2 ,\qquad
   c_1(V) \equiv [I] \equiv G \pmod 2 .\;} \tag{6.2} \]

*Robustness.* The blow-down relations hold over the open locus of smooth
fibres; a defect concentrated on the degenerate locus is a multiple of the
divisor `[I]` (the diagonal `Δ` has codimension two and cannot contribute to
`H^2`). Since `[I] ≡ G (mod 2)`, **every** possible outcome is
`c_1(V) ≡ m\,G` with `m ∈ \{0,1\}` — the conclusion used below survives the
defect either way.

### 6.3 `c_2(V) ≡ π_*(d^4)`, and it is `σ`-symmetric

`π_*(D^4) = s_2(V^∨) = c_1(V)^2 − c_2(V)`, so by (6.0) and (6.2)

\[ c_2(V) = c_1(V)^2 − π_*(D^4) \equiv π_*(D^4) \pmod 2 . \]

Expanding `D = d + ι^*H` and pushing (`H^4 = 0`):
`π_*(D^4) = π_*(d^4) + 4p_{B*}(HP_3) + 6p_{B*}(H^2P_2) + 4p_{B*}(H^3P_1)`.
Each correction is even: `p_{B*}(H^3P_1) = 3·6Δpt = 18Δpt` (times 4),
`p_{B*}(H^2P_2) = 3·P_2^{(2,\cdot)\text{-coeff}}` (times 6), and
`p_{B*}(HP_3)` (times 4). Hence

\[ c_2(V) \;\equiv\; π_*(d^4) \pmod 2 , \]

and since `σ^*d = −d` and `d^4` is an even power, **`c_2(V) mod 2` is
`σ`-symmetric** — a conclusion that needs no evaluation of `π_*(d^4)` and is
therefore immune to every non-Cartier / degenerate-fibre correction (those
loci, `I` and `Δ`, are `σ`-invariant, and the defect class of a `σ`-invariant
cycle computation is `σ`-invariant).

*For the record, the value.* Mod two, `d^4 ≡ Z^4 + Z'^4`. With
`ν := c_1(N_{Z/𝒮}) = c_1(N_{Z/A}) − S|_Z = 2H − 2ζ − 3C_1 − (H+G) ≡ H + C_1 + G`
and `π_{Z*}(1)=0`, `π_{Z*}(H|_Z)=1`, `π_{Z*}(H^2|_Z) = 3C_1`,
`π_{Z*}(H^3|_Z) = 18\,pr_1^*[pt]_F`, one gets
`π_*(Z^4) = π_{Z*}(ν^3) ≡ G\,C_1` and `π_*(Z'^4) ≡ G\,C_2`, i.e.
`c_2(V) ≡ G(C_1+C_2) (mod 2)` — visibly `σ`-symmetric, as required.

## 7. Theorem F2: the negative transfers — `λ_ℰ = 0`

Two kill lemmas close the two surviving terms of `Δ`.

**Lemma S (symmetric coefficients die against pure tests).** Let
`θ ∈ H^4(F×F,\mathbf Z)` be `σ`-symmetric and let `T` be one of the pure
antisymmetric tests, i.e. an integral combination of `pr_1^*b − pr_2^*b` with
`b ∈ H^3(F,\mathbf Z)` (compression note §2). Then for every
`γ ∈ H^1(F,\mathbf Z)`

\[ \int_{F×F} T·θ·\bigl(pr_1^*γ + pr_2^*γ\bigr) \;\equiv\; 0 \pmod 2 . \]

*Proof.* Mod two `T ≡ Σ_k c_k(b_{k,1}+b_{k,2})`, so it suffices to treat
`(b_1+b_2)(γ_1+γ_2)θ = [b_1γ_1 + b_2γ_2]θ + [b_1γ_2 + b_2γ_1]θ`. The second
bracket is exchanged by `σ`, which is a holomorphic automorphism, so
`∫b_1γ_2θ = ∫σ^*(b_1γ_2θ) = ∫b_2γ_1θ` (using `σ^*θ = θ`) and the two terms sum
to an even integer. For the first bracket, `b_iγ_i = pr_i^*(bγ) = n\,[pt]_i`
with `n = ∫_F bγ`, and again by `σ`-symmetry of `θ`
`∫[pt]_1θ = ∫[pt]_2θ`, so the first bracket contributes `2n∫[pt]_1θ`. ∎

**Lemma C (the `G`-coefficient dies by the certified `t`-control).** For every
tested pair, `∫_{X×B}(x⊗T_a)·G·c_3^{(3,3)} ≡ 0 (mod 2)`.

*Proof.* Lemma T at `r = 0` says the `t`-twist `𝒢^{(t)} = 𝒢^{(0)}⊗p_B^*O(tG)`
changes the readout class by `tG\,c_3^{(3,3)} + t^2G^2c_2^{(3,1)}` mod 2. The
committed main-term certificate verifies that the readout matrix is
`t`-independent mod two. Taking `t` odd gives
`∫(x⊗T_a)[G c_3^{(3,3)} + G^2c_2^{(3,1)}] ≡ 0`. The second summand is itself
even: `G^2` is `σ`-symmetric (indeed `≡ 0` by (6.0)) and
`c_2^{(3,1)} ≡ Ξ_1+Ξ_2`, so Lemma S applies slotwise. ∎

**Theorem F2 (the ℰ-model verdict).** Let `ℰ` be the universal family of
`M = M_X(v) ≅ Bl_0Θ` on `X×M`. Then for every pure antisymmetric test and
every `x ∈ H^3(X,\mathbf Z)`,

\[ N_ℰ(x,a) \;=\; \int_{X×M}p_X^*x·p_M^*\bigl(b^*(Θ∧a)\bigr)·c_4(ℰ)
   \;\equiv\; N_𝒢(x,a) \;\equiv\; 0 \pmod 2 , \]

i.e. **`λ_ℰ = λ_𝒢 = 0`**: the `(3,5)`-legs of `c_4(ℰ)` all lie in
`b^*H^5(J,\mathbf Z) + \mathrm{tors}`, and the `(1,5)` escape channel is **not**
populated by the universal family.

*Proof.* Work on `X×Y`, `Y = Bl_Δ(F×F)`, where the honest transfer identity
`∫_{X×Y}c_4((1×q)^*𝒰)(x⊗μ^*T_a) = ∫_{X×M}c_4(𝒰)(x⊗q_*μ^*T_a)
= ∫_{X×M}c_4(𝒰)(x⊗b^*(Θ∧u_k))` holds for any family `𝒰` on `X×M`
(projection formula plus the compression note's exact pure tests). Set
`ℰ_Y := L_{O_X}(𝒢(H))[−1]` with `𝒢` the span model itself. By fineness of
`M` and the classifying property of `q`, `(1×q)^*ℰ ≅ ℰ_Y ⊗ p_Y^*N` for a line
bundle `N` on `Y`, and by **Lemma T at rank three** that twist is invisible
mod two. So `N_ℰ ≡ ∫_{X×Y}c_4(ℰ_Y)^{(3,5)}(x⊗μ^*T_a)`.

Theorem F1 evaluates that class as
`c_4(𝒢)^{(3,5)} + c_1(V)c_3^{(3,3)} + (c_2(V)+G^2)c_2^{(3,1)}` mod two. The
first summand pairs to `N_𝒢 = 0` (committed certificate). The second pairs to
zero by (6.2) plus Lemma C (in the defect case `c_1(V) ≡ 0` it is zero
outright). The third pairs to zero by (6.0), §6.3 and Lemma S: `c_2(V)+G^2` is
`σ`-symmetric mod two and `c_2^{(3,1)} ≡ Ξ_1+Ξ_2` splits slotwise into the
`γ_1+γ_2` shape Lemma S consumes. ∎

**Corollary (channel closure).** Combining with pass-5 Theorem E, pass-1
Theorem B, pass-2 Theorems 1–3 and the span/incidence product dictionary: the
`(1,5)` Hodge channel on `M` is unpopulated by *every* candidate source named
in the C908 corpus — pullbacks from `J×J`, exceptional-divisor cycles, the
span/incidence dictionary, `c_4` of the span model, and now `c_4` of the
`ℰ`-model universal family and all of its Chern polynomials with `(3,5)`
readout. Extraction item F is discharged.

**Exact family class covered.** The statement covers: every family on `X×M`
whose K-class is `ε([p_M^*W] − [𝒢_M ⊗ p_X^*L])⊗[p_M^*N]` for `W ∈ K^0(M)`,
`L ∈ Pic(X)`, `N ∈ Pic(M)`, `ε = ±1`, with `𝒢_M` the `β+γ` universal family —
in particular every sextant translate of the universal family under the Serre
functor and its inverse, every shift, and every line-bundle normalization.
It does **not** claim anything about non-mutation-related families, nor about
the `(2,4)` channel.
