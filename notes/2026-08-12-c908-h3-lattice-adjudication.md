# C908: H³(M,Z) adjudicated — the exact lattice, the corrected escape group, and gate A re-issued

Date: 2026-08-12

Status: **pass 9 — the three reposed items of
`notes/2026-08-11-c908-h3-resolution-lattice-correction.md` §4 are closed:
the integral structure of `H^3(M,Z)` is pinned with proofs (Theorem A), the
fallen pass-2 Theorem 2 / Corollary 2.1 are re-derived on the corrected
lattice (Theorem B — the escape group is `Z^10`, not `(Z/2)^10`, and pass-2
Corollary 2.2's torsion claim is corrected the other way), and gate A is
re-issued with a sound derivation and ten new test directions.** C908
mathematics only; no manuscript, PDF, mirror, Lean, or C904-surface edit.

Notation as in pass 2 (`notes/2026-08-11-c908-m-cross-m-exceptional-residue.md`)
and pass 6/7: `J` the generic exotic `A5` intermediate Jacobian, `Θ ⊂ J` its
theta divisor with unique ordinary triple point at `0`, projectivized tangent
cone the cubic threefold `X ⊂ P^4`; `σ : M = Bl_0 Θ → Θ`, `b = i∘σ : M → J`,
`e_X : X → M` the exceptional divisor with `N_{X/M} = O_X(−H)`;
`Λ = H^1(J,Z)`, `L_3 = Θ∧(−) : ∧³Λ → ∧⁵Λ` (Smith form `1^110 2^10`,
corpus-certified); `F` the Fano surface, `a : F → J` the Albanese embedding,
`ψ : F×F → J` the difference map (image `Θ`, degree six);
`B = F×F`, `Y = Bl_Δ B` with blowdown `μ : Y → B`, exceptional divisor
`e_E : E → Y`, and `q : Y → M` the degree-six lift of `ψ` (`b∘q = ψ∘μ`).
By the tangent-bundle theorem `E = P(T_F)` is the universal line
`P = {(ℓ,x) : x ∈ ℓ} ⊂ F×X`; write `π_E : E → F` for the bundle projection
(`= μ|_E` onto `Δ_F ≅ F`) and `p = q|_E : E → X` for the evaluation, which is
generically finite of degree six (six lines through a general point of `X`).
`U = Θ∖{0} = M∖X`; `L` the link of the triple point; `π_L : L → X` the circle
bundle. `Sat` denotes the saturation of `L_3∧³Λ` in `∧⁵Λ`;
`[Sat : L_3∧³Λ] = 2^10` from the Smith form.

## 1. The adjudicated structure

**Theorem A (the exact lattice).**

1. `H^3(M,Z)` is torsion-free of rank `130`, and the sequence
   \[ 0 \to \wedge^3\Lambda \xrightarrow{\;b^*\;} H^3(M,\mathbf Z)
      \xrightarrow{\;e_X^*\;} H^3(X,\mathbf Z) \to 0 \]
   is exact (and splits, the quotient being free).
2. `b_*H^3(M,Z) = Sat`, with `[b_*H^3(M,Z) : L_3∧³Λ] = 2^10` exactly, and
   `b_*H^3(M,Z) = L_3∧³Λ + ψ_*H^3(F×F,Z)`.
3. The pair `(b_*, e_X^*)` embeds `H^3(M,Z)` into `∧⁵Λ ⊕ H^3(X,Z)` with
   image
   \[ \hat H \;=\; \{(σ,γ) : σ ∈ \mathrm{Sat},\;
      σ \bmod L_3\wedge^3\Lambda = ρ(γ \bmod 2)\}, \]
   where `ρ : H^3(X,Z)⊗F_2 → Sat/L_3∧³Λ` is an isomorphism of
   ten-dimensional `F_2`-spaces (its matrix in the fixed corpus bases is in
   the certificate). Equivalently: the link classes of the triple point enter
   `H^3(M,Z)` as a full `H^3(X,Z)`, glued to `∧³Λ` by the rule "`b_*` of a
   lift of `γ` is half-integral in exactly the `ρ(γ)`-direction".
4. The transfer identity, corrected: for `T ∈ H^3(F×F,Z)`,
   \[ q_*μ^*T \;=\; \bigl(ψ_*T,\; p_*π_E^*\,i_Δ^*T\bigr)
      \in \hat H \subset \wedge^5\Lambda \oplus H^3(X,\mathbf Z), \]
   and `p_*π_E^* : H^3(F,Z) → H^3(X,Z)` is an isomorphism. This is the exact
   mechanism of the pass-8 measurement: a generator is half-integral
   downstairs precisely when its diagonal restriction is odd.

Conditionality: items 1 and 4, the exactness/splitting, the containment
`b_*H^3(M,Z) ⊆ Sat`, and the well-definedness and injectivity of `ρ` are
human-proved (§2). Item 2's equality (hence the *onto* half of `ρ`, hence
the exact `\hat H`-description in item 3) additionally rests on the
certificate's CHECKs 3–4 (finite integer computations, independently
replayed).

The pass-2 measurement (626 of 940 generators half-integral, exactly the
odd-diagonal ones) is reproduced by the pass-9 certificate as a consequence
of items 3–4, not as an unexplained pattern. The certificate moreover finds
that the transfer image lattice is **all** of `\hat H`:
`q_*μ^* : H^3(F×F,Z) → H^3(M,Z)` is integrally surjective (CHECK 7, Smith
form of the quotient trivial, confirmed by the independent PARI check).

## 2. Proofs

### 2.1 The link (the corrected deletion step)

No tangent-cone topology is needed to identify the link: `σ` is an
isomorphism off `X`, so a punctured neighbourhood of `0` in `Θ` is
homeomorphic to `ν(X)∖X` (`ν(X)` a tubular neighbourhood of `X` in `M`),
which deformation-retracts onto `∂ν(X)` — the unit circle bundle of
`N_{X/M} = O_X(−H)`, i.e. of `O_X(−1)`. So the link `L` is that circle
bundle, from the standing corpus facts alone. The Gysin sequence of `π_L : L → X`, with
`H^*(X,Z) = (Z, 0, Zh, Z^{10}, Zℓ, 0, Z)` and `∪h` acting by `1 ↦ h`,
`h ↦ 3ℓ`, `ℓ ↦ [pt]`, gives
\[ H^1(L)=0,\quad H^2(L)=0,\quad H^3(L) = π_L^*H^3(X,\mathbf Z) ≅ \mathbf Z^{10},
   \quad H^4(L) ≅ \mathbf Z^{10} \oplus \mathbf Z/3. \]
(`H^3`: `0 = H^1(X) → H^3(X) → H^3(L) → ker(∪h : H^2 → H^4) = 0`.)

### 2.2 The three exact sequences

**(i) Weak Lefschetz (pass-2 step (i), unaffected by the refutation):**
`H^k(J,Z) ≅ H^k(Θ,Z)` for `k ≤ 3`, integrally. Precise form: the
Goresky–MacPherson/Hamm Lefschetz theorem for the support of an effective
**ample** divisor (ampleness suffices — `Θ` is ample but not very ample —
and the divisor may be singular) in a smooth projective fivefold gives the
homotopy statement `π_i(J,Θ) = 0` for `i ≤ 4` (Goresky–MacPherson,
*Stratified Morse Theory*, Part II §1.2; Hamm–Lê), hence
`H_i(J,Θ;Z) = 0` for `i ≤ 4`, hence the integral cohomology isomorphism for
`k ≤ 3` and injectivity at `k = 4`.

**(ii) The pair `(Θ, U)`:** excising to a cone neighbourhood,
`H^k(Θ,U;Z) ≅ H̃^{k-1}(L,Z)`. With `H^2(L) = 0` this gives the exact
\[ 0 \to H^3(Θ,\mathbf Z) \to H^3(U,\mathbf Z)
   \xrightarrow{\;\mathrm{res}_L\;} H^3(L,\mathbf Z), \]
and `ker(res_L) = im(H^3(Θ))` exactly (the connecting map to `H^4(Θ,U)` is
restriction to `L` under the excision isomorphism).

**(iii) Mayer–Vietoris on `M = ν(X) ∪ U`,** `ν(X) ∩ U ≃ ∂ν(X) = L` (the
blow-up does not change the complement, and the punctured cone neighbourhood
retracts onto the link): since `H^2(L) = 0`,
\[ 0 \to H^3(M,\mathbf Z) \to H^3(X,\mathbf Z) \oplus H^3(U,\mathbf Z)
   \to H^3(L,\mathbf Z), \]
the second map being the difference of restrictions. Because
`π_L^* : H^3(X) → H^3(L)` is an isomorphism (§2.1), the projection
`H^3(M) → H^3(U)` is an isomorphism, `e_X^*` is the `X`-component, and
\[ \ker e_X^* = σ^*H^3(Θ,\mathbf Z) = b^*\wedge^3\Lambda, \qquad
   \mathrm{im}\, e_X^* = (π_L^*)^{-1}\bigl(\mathrm{im}\,\mathrm{res}_L\bigr). \]
(Corroboration by the Gysin sequence of `X ⊂ M`: `e_{X*}` is injective on
`H^2(X,Z) = Zh` because `e_X^*e_{X*}y = y∪(−h)` and `h∪h = 3ℓ ≠ 0`, which
forces `H^3(M) ≅ H^3(U)` again.)

### 2.3 Base change through the degree-six model

**Lemma (clean base change).** `q^{-1}(X) = E` scheme-theoretically
(multiplicity one), and for every `α ∈ H^3(Y,Z)`:
`e_X^*\,q_*α = p_*\,e_E^*α` in `H^3(X,Z)`.

*Proof.* Set-theoretically `q^{-1}(X) = E`: the inclusion `q(E) ⊆ X` is
immediate from `b∘q = ψ∘μ` and `b^{-1}(0) = X` (the exceptional `E` maps
into the fibre over `0`); conversely `Y∖E ≅ B∖Δ` maps into `U = M∖X`
because `ψ^{-1}(0) = Δ` — i.e. the Albanese embedding of `F` is injective
(classical; corpus: pass-2 §5.2, `a_s` injective with `a_s^{-1}(0) = {s}`).
Multiplicity: `E` is irreducible, so `q^*X = mE`; for a `π_E`-fibre `C`
(mapped isomorphically to a line `ℓ ⊂ X ⊂ M`),
`q^*X·C = X·q_*C = deg\,N_{X/M}|_ℓ = deg\,O_X(−H)|_ℓ = −1`
and `E·C = deg\,O_{P(T_F)}(−1)|_C = −1`, so `m = 1`,
hence `q^*O_M(X) ≅ O_Y(E)` and `q^*N_{X/M}|_E ≅ N_{E/Y}`.

Push–pull first: `q^*e_{X*} = e_{E*}p^*`. The Gysin map of a smooth divisor
is the Thom isomorphism of its normal bundle followed by
`H^*(V, V∖D) → H^*(V)`; both steps are natural under `q` given
`q^*(\text{Thom class of } N_{X/M}) = \text{Thom class of } N_{E/Y}`. The
bundle isomorphism `q^*N_{X/M}|_E ≅ N_{E/Y}` alone gives
`q^*τ_X = c·τ_E` for some `c ∈ Z` (the relative `H^2` is free of rank one
on `τ_E`); restricting to the zero section pins `c`:
`q^*τ_X|_E = p^*e(N_{X/M}) = e(N_{E/Y}) = τ_E|_E`, and `e(N_{E/Y})` (degree
`−1` on fibres) is non-torsion in `H^2(E,Z)`, so `c = 1`.

Now dualize. For `y ∈ H^3(X,Z)`:
\[ \int_X e_X^*(q_*α)∪y = \int_M q_*α ∪ e_{X*}y = \int_Y α ∪ q^*e_{X*}y
   = \int_Y α ∪ e_{E*}p^*y = \int_X p_*(e_E^*α) ∪ y . \]
`H^3(X,Z)` is torsion-free with unimodular cup pairing, so the two classes
agree. ∎

Applying this to `α = μ^*T` and using `μ∘e_E = i_Δ∘π_E`:
\[ e_X^*\,q_*μ^*T = p_*π_E^*\,(i_Δ^*T), \]
and `b_*q_*μ^*T = ψ_*μ_*μ^*T = ψ_*T`. This is Theorem A.4 except for:

**Lemma (cylinder adjoint).** `p_*π_E^* : H^3(F,Z) → H^3(X,Z)` is an
isomorphism.

*Proof.* For `x ∈ H^3(F,Z)`, `β ∈ H^3(X,Z)`:
`⟨p_*π_E^*x, β⟩_X = ⟨x, π_{E*}p^*β⟩_F` (projection formula on `E`, both ways).
So `p_*π_E^*` is the adjoint of the cylinder map
`π_{E*}p^* : H^3(X,Z) → H^1(F,Z)` with respect to the cup pairing on
`H^3(X,Z)` and the Poincaré pairing `H^3(F,Z) × H^1(F,Z) → Z`. Both
pairings are unimodular: `H^3(X,Z)` is torsion-free with unimodular cup
form (classical, corpus-standing), and `H^*(F,Z)` is torsion-free — corpus
locus: extraction note
`notes/2026-08-11-c908-fano-schubert-restriction-extraction.md` item A5.a
(Voisin arXiv:2212.03046 Remark 3.8, citing Collino, *The fundamental group
of the Fano surface I, II*; secondary-depth). (Even without A5.a the lemma
holds with `H^3(F,Z)/tors` throughout, which is all §2.4 uses: the target
is torsion-free, so `p_*π_E^*` factors through the free quotient, and the
certificate reads parities through `a_* : H^3(F)/tors ≅ ∧⁹Λ` anyway.)

That the cylinder map through this exact correspondence is an integral
isomorphism is Clemens–Griffiths: the correspondence is `T = P`, the
universal line, and its `(1,3)`-action `H^3(X,Z) → H^1(F,Z)` is `φ^*` of CG
(2.7)/(2.8) (p. 291); §11 (Lemmas 11.2, 11.6 and conclusion (0.8)) makes it
an isomorphism over `Z`, and (11.4) (p. 330) an anti-isometry onto
`(Λ, S)` after `a^*`. Corpus locus with quotations: extraction note item
E.4. The adjoint of an isomorphism between unimodular pairings on
torsion-free lattices of equal rank (ten on both sides) is an isomorphism;
the anti-isometry sign is immaterial to every image/parity statement used
here. ∎

### 2.4 Assembling Theorem A

`e_X^*` **is surjective**: `e_X^*(q_*μ^*(β⊗1)) = p_*π_E^*β` sweeps
`H^3(X,Z)` as `β` sweeps `H^3(F,Z)` (`i_Δ^*(β⊗1) = β`). With §2.2(iii) this
gives exactness of `0 → ∧³Λ → H^3(M,Z) → H^3(X,Z) → 0`; the quotient is
free, so the sequence splits and `H^3(M,Z)` is torsion-free of rank 130.
(Retroactively `res_L` is onto `H^3(L)`, i.e. the connecting map
`H^3(L) → H^4(Θ)` vanishes — every link direction survives into `H^3(U)`.)

**Injectivity of `(b_*, e_X^*)`**: on `ker e_X^* = b^*∧³Λ`, `b_*b^* = L_3`
is injective.

**`b_*H^3(M,Z) = Sat` (the sandwich).** Lower bound:
`ψ_*T = b_*(q_*μ^*T) ∈ b_*H^3(M,Z)`, and the certificate computes
`L_3∧³Λ + ψ_*H^3(F×F,Z) = Sat` exactly (CHECK 4). Upper bound: `q_*q^* = 6`
gives, for `ξ ∈ H^3(M,Z)`,
`b_*ξ = (1/6)\,ψ_*(μ_*q^*ξ) ∈ ψ_*H^3(F×F,\mathbf Q) ⊆ L_3∧³Λ ⊗ \mathbf Q`
(the containment is CHECK 3: denominators divide 2 on an integral generating
set), so `b_*H^3(M,Z) ⊆ (L_3∧³Λ⊗Q) ∩ ∧⁵Λ = Sat`. Both bounds meet at index
`2^10`, forcing `b_*H^3(M,Z) = L_3∧³Λ + ψ_*H^3(F×F,Z) = Sat`.

**The glue `ρ`.** The map `H^3(X,Z) → Sat/L_3∧³Λ`, `γ ↦ b_*ξ mod L_3∧³Λ`
for any `ξ` with `e_X^*ξ = γ`, is well defined (two lifts differ by
`b^*∧³Λ`) and kills `2H^3(X)` (because `2\,Sat ⊆ L_3∧³Λ`, the quotient having
exponent two). It is onto by the sandwich, hence an isomorphism `ρ` of
ten-dimensional `F_2`-spaces. The image description `\hat H` of Theorem A.3
follows, and with it the measured dichotomy: a transfer class is
half-integral downstairs iff its `X`-component `p_*π_E^*i_Δ^*T` is odd, iff
`i_Δ^*T` is odd (the cylinder adjoint is an isomorphism, so preserves
parity). The certificate verifies `ρ`'s existence, linearity and
invertibility over all 940 generators (CHECK 5) — an independent numerical
confirmation of the base-change and cylinder-adjoint lemmas.

## 3. Theorem B: the corrected Theorem 2, Corollary 2.1, and Corollary 2.2

**Theorem B.** On `H^5`:

1. `b_* : H^5(M,Z)/tors → ∧⁷Λ` is **surjective** with kernel a **primitive
   sublattice of rank ten** — pass-2 Theorem 2 claimed an isomorphism; the
   surjectivity half survives, the injectivity half falls.
2. That kernel is exactly `e_{X*}H^3(X,Z)`: the exceptional Gysin image is
   **not torsion** (pass-2 Corollary 2.2 corrected — its proof had cited the
   fallen Theorem 2). `e_{X*} : H^3(X,Z) → H^5(M,Z)/tors` is injective with
   primitive image, and is still killed by `b_*` (`b∘e_X` constant — pass-2
   Theorem 3 and its blindness mechanism are unaffected).
3. The escape group is **free**:
   \[ E \;:=\; H^5(M,\mathbf Z)\big/\bigl(b^*H^5(J,\mathbf Z)+\mathrm{tors}\bigr)
      \;\cong\; \mathbf Z^{10}, \]
   canonically `Hom(\ker b_*|_{H^3(M)}, \mathbf Z)` — pass-2 Corollary 2.1's
   identification with `coker(L_5) = (Z/2)^{10}` is false.
4. Under that identification `e_{X*}H^3(X,Z)` lands in `E` as exactly `2E`,
   so
   \[ H^5(M,\mathbf Z)\big/\bigl(b^*H^5(J,\mathbf Z)+e_{X*}H^3(X,\mathbf Z)
      +\mathrm{tors}\bigr) \;\cong\; E/2E \;\cong\; (\mathbf Z/2)^{10}. \]
   The pass-2 §8 reposed target group was numerically right with the wrong
   decomposition: the genuinely unreachable directions are the ten
   **half-exceptional** classes — an odd `(1,5)` second leg must realize a
   generator of `E`, of which the geometric classes `e_{X*}H^3(X,Z)` supply
   only the doubles.

*Proofs.* Poincaré duality on `M` identifies `H^5(M,Z)/tors` with
`Hom(H^3(M,Z),Z)` (unimodularly; `H^3` torsion-free by Theorem A). Under
this:

- `b_*` on `H^5/tors` is `(b^*)^∨`, restriction of functionals along
  `b^* : ∧³Λ ↪ H^3(M,Z)` (projection formula), composed with the unimodular
  `(∧³Λ)^∨ ≅ ∧⁷Λ`. Theorem A makes `b^*∧³Λ` a direct summand, so `(b^*)^∨`
  is surjective; its kernel is `(b^*∧³Λ)^⊥`, the functionals factoring
  through `e_X^*`, which is a primitive rank-ten sublattice. (1)
- `⟨e_{X*}β, ξ⟩_M = ⟨β, e_X^*ξ⟩_X`. Since `e_X^*` is surjective and the cup
  pairing on `H^3(X,Z)` unimodular, `β ↦ ⟨β, e_X^*(−)⟩` identifies
  `H^3(X,Z)` with exactly `(b^*∧³Λ)^⊥`. (2)
- `b^*w` for `w ∈ ∧⁵Λ` is the functional `ξ ↦ ⟨w, b_*ξ⟩_J`. The composite
  `∧⁵Λ → Hom(b_*H^3(M),Z) = Sat^∨` is **surjective** because the wedge
  pairing on `∧⁵Λ` is unimodular and `Sat` is saturated; hence
  `b^*H^5(J,Z) + tors` fills exactly the functionals vanishing on
  `ker b_*|_{H^3}` (which is saturated in `H^3(M,Z)`), and
  `E ≅ Hom(ker b_*|_{H^3}, Z)`, free of rank ten. (3)
- In `\hat H`-coordinates `ker b_*|_{H^3} = \{(0,γ) : ρ(γ \bmod 2) = 0\}
  = \{(0,γ) : γ ∈ 2H^3(X,Z)\}`, on which `e_X^*` is injective with image
  `2H^3(X,Z)`. Restricting the functionals of (2) to it multiplies the
  unimodular duality by two: the image of `e_{X*}H^3(X,Z)` in
  `E = Hom(ker b_*,Z)` is `2E`. (4) ∎

The certificate verifies (3) and (4) by explicit Smith forms on the
130-dimensional functional lattice (CHECKs 8–9).

**What this does to the readout.** The `(1,5)` residue functional reads a
second leg `β` only through `b_*β ∈ ∧⁷Λ` (pass-2 §1); by Theorem B.1 every
value in `Q_15 = coker(L_5)` is still realized by classes on `M` — the
pass-2 §8 "odd residues exist cohomologically" conclusion survives with the
corrected proof. The refined statement is new: the obstruction to realizing
them **algebraically** now has an integral home, `E ≅ Z^10`, in which all
known geometric classes (`b^*`-pullbacks: zero; exceptional classes: `2E`)
sit at even depth.

## 4. Gate A re-issued

The pass-8 gate conditions (scratchpad spec, now promoted by this note) were
stated as: a test `T'' ∈ H^3(F×F,Z)` reads the downstairs test `b^*(Θ∧a)`
iff

- (i) `v(T'') := L_3^{-1}(ψ_*T'') ≡ Θ∧a (mod 2∧³Λ)`, and
- (ii) `i_Δ^*T'' ≡ 0 (mod 2)`.

**Neither the old derivation nor the old conditions survive unchanged.** The
old derivation assumed every `ψ_*T''` is integrally `L_3`-solvable (false
for the 626). On the corrected lattice the invariant criterion is:

> `T''` is a valid transfer test for the direction `a` **iff**
> `q_*μ^*T'' ≡ b^*(Θ∧a) (mod 2H^3(M,Z))`, i.e. iff
> `(ψ_*T'',\,γ(T'')) ≡ (L_3(Θ∧a),\,0) (mod 2\hat H)`.

Unwinding with Theorem A.3: condition (ii) is still necessary, and by `ρ` it
is equivalent to integral solvability of `ψ_*T''`, so `v(T'')` exists; write
`γ(T'') = 2g`. But the residual class
`q_*μ^*T'' − b^*v(T'') = (0, 2g)` is **not** generally in `2\hat H`:
`(0,2g) ∈ 2\hat H ⟺ (0,g) ∈ \hat H ⟺ ρ(g \bmod 2) = 0 ⟺ γ(T'') ∈ 4H^3(X,Z)`.
The correct sufficient pair is (ii) together with the **matched** congruence

- (i′) `v(T'') − Θ∧a ∈ Λ'` and `τ(v(T'') − Θ∧a) = ρ(g \bmod 2)`,

where `Λ' := L_3^{-1}(2\,\mathrm{Sat}) ⊇ 2∧³Λ` (index `2^{110}` in `∧³Λ`,
with `Λ'/2∧³Λ ≅ (Z/2)^{10}`) and `τ : Λ'/2∧³Λ → Sat/L_3∧³Λ`,
`τ(w) = (L_3 w)/2 \bmod L_3∧³Λ`, is the induced isomorphism. The old pair
(i)+(ii) is the special case `τ = 0`, which is sufficient **only when**
`i_Δ^*T'' ≡ 0 (mod 4)`.

What an old-gate test with `g` odd actually reads (hostile-audit finding 1,
confirmed): exactly `q_*μ^*T'' ≡ b^*(Θ∧a) + κ(\bar g) (mod 2H^3(M,Z))`,
where `κ : H^3(X)⊗F_2 → H^3(M,Z)/2H^3(M,Z)` sends `\bar g` to the class of
`(0,2\tilde g)` — injective, with image the mod-two shadow of
`\ker b_*|_{H^3}` at odd depth. The contamination `κ(\bar g)` pairs to zero
mod two against **every** class of `b^*H^5(J,Z) + e_{X*}H^3(X,Z) + tors`
(it lies in `\ker b_*`, and its `e_{X*}`-pairings are even), so old-gate
tests still read λ correctly against all even-`E`-depth candidates — but a
candidate at odd `E`-depth (the half-exceptional escape, precisely what
§4.2 probes) sees the extra term. Pure λ-tests therefore need
`i_Δ^*T'' ≡ 0 (mod 4)` or the matched condition (i′).

**Consequently the committed gate-A certificate's formal answer ("(i)+(ii)
solvable in every direction") is not a gate verdict on the corrected
lattice.** The re-issued gate verdict is the solvability, for each `a`, of
`(L_3(Θ∧a), 0) ∈ \mathrm{Im} + 2\hat H` (`Im` the integral transfer-image
lattice) — computed in the pass-9 certificate (CHECK 10, revision 2).

**Certified verdict: the gate is open everywhere, with room to spare.** The
certificate finds `\mathrm{Im} = \hat H` **exactly** (Smith form of
`\hat H/\mathrm{Im}` trivial): the transfer
`q_*μ^* : H^3(F×F,Z) → H^3(M,Z)` is **integrally surjective**. Hence:

- all ten downstairs directions `a` are readable on the corrected criterion
  (measured per direction, not deduced);
- all ten new `X`-block test directions are readable, and every mod-two
  coset is fully covered (`d_2 = 130` of 130);
- even the conservative old-style gate (`i_Δ^*T'' ≡ 0 (mod 4)` with
  `v ≡ Θ∧a (mod 2)`) is open in all ten directions.

So the pass-8 conclusion — the degree-six span model can read λ — is
restored, now on a sound criterion, and strengthened: every integral test
class on `M`, not just every mod-two direction, is realized by a transfer.

**What is new on the corrected lattice:**

1. **Ten new test directions.** The transfer image also contains classes
   with odd `X`-component (`β⊗1` gives `(ψ_*(β⊗1), p_*π_E^*β)`), so the
   reachable test space mod two inside `H^3(M,Z)⊗F_2` (dimension 130) is
   strictly larger than the `b^*`-block. The certificate computes the exact
   transfer-image lattice `\hat H/\mathrm{Im}` and the mod-two reachable
   dimension (CHECKs 7, 10).
2. **What the new directions read.** A test with odd `X`-component pairs a
   candidate's `H^5`-legs through the `E`-coordinate of §3 rather than
   through `b_*`: the ten new directions probe the candidate's position in
   `E/2E` — precisely the half-exceptional escape that the λ-bit's
   downstairs tests cannot see. The gate now tests **more** than λ; the
   pass-8 fear ("detection blocked") is inverted ("detection finer"), as the
   correction note anticipated.
3. **The λ leg computation is unblocked.** Its spec (pass-8 scratchpad
   working draft) survives unchanged through the correction: the gate
   conditions it consumes are re-justified above; its class inventory, the
   conifold correction, the `R`-stratum risk item and its resolution options
   are untouched by the lattice correction (they live upstairs on `X×B`).
   That computation is the successor pass.

## 5. Certificate bundle and replay

Main certificate (assertion suite; also dumps the full generator table for
the independent check):

```sh
nix shell nixpkgs#sage -c sage \
  notes/2026-08-12-c908-h3-lattice-adjudication.sage \
  --json notes/2026-08-12-c908-h3-lattice-adjudication.json \
  --out notes/2026-08-12-c908-h3-lattice-adjudication.out
```

Independent check (different backend — PARI `matsnf`/`mathnf` on the dumped
integer matrices; independent at the lattice-arithmetic level, while the
`ψ_*`-computation itself has its separate independent path in the committed
`notes/2026-08-11-c908-halfint-independent-check.{sage,out}`):

```sh
nix shell nixpkgs#sage -c sage \
  notes/2026-08-12-c908-h3-lattice-independent-check.sage
```

Certified (main suite 52/52 assertions, independent PARI check 22/22):
Smith of `L_3` and `[Sat : L_3∧³Λ] = 2^10`; the 626/940 half-integral
pattern and its equivalence with diagonal parity (generator-by-generator
agreement with the committed gate-A json, including the per-block
denominator profile); the sum lattice `L_3∧³Λ + ψ_*H^3(F×F,Z) = Sat`;
existence, linearity and invertibility of `ρ` (matrix recorded);
`\mathrm{Im} = \hat H` exactly (transfer surjectivity) and `d_2 = 130`;
`E ≅ Z^10` free and `[E : e_{X*}\text{-image}] = 2^{10}` with quotient
`(Z/2)^{10}`; the per-direction gate verdicts of §4. Human proofs, not
certified: §2–§3 (weak Lefschetz, the link and pair sequences,
Mayer–Vietoris, clean base change, the cylinder adjoint, duality
bookkeeping).

| artifact | SHA-256 |
|---|---|
| `notes/2026-08-12-c908-h3-lattice-adjudication.sage` | `d7ae4202b893b582d1fab2e9f412628be2c421501b0e607ce50481d6d702e19b` |
| `notes/2026-08-12-c908-h3-lattice-adjudication.out`  | `a6d7fa6deec48819df0ee7c68525e1842c8ac30baffcfc83c48b0d2705e58c15` |
| `notes/2026-08-12-c908-h3-lattice-adjudication.json` | `3c9519fbb1a6f2fdc1ddb8dc5332d691915ea36332f91b505bd2b2bcb80efaf6` |
| `notes/2026-08-12-c908-h3-lattice-independent-check.sage` | `eb621876245b409a5e2c54c29de7aecae774ca31687d76d7877edacd75ed5cdc` |
| `notes/2026-08-12-c908-h3-lattice-independent-check.out`  | `10d008cf9481a69cbe13bc79f47df59ac2e838fd47d7ec187e05f8e54c0315c5` |
| input `notes/2026-08-11-c908-gate-a-transfer.sage` | `82ced36dff77732282a47e43a30735b04f476013a3758b31a4e032b25ea2f84d` |
| input `notes/2026-08-11-c908-span-incidence-residues.sage` | `6f7f015c864884059d21f75c790aa382f8ca353fe4a21d617560588baddb323d` |

## 6. Dependency map update

- **Stands:** pass-2 Theorem 3 and the exceptional-blindness mechanism of
  the `(1,5)` readout; all pass-6/7 verdicts (`J`-level, unaffected
  throughout); pass-2 §8's target group `(Z/2)^10`, re-realized as `E/2E`;
  the committed gate-A certificate's *arithmetic* content (the 940-generator
  transfer table, reused by the pass-9 certificate).
- **Corrected:** the pass-8 gate conditions (i)+(ii) were necessary but not
  sufficient — the matched condition (i′) of §4 replaces them, and the gate
  verdict is re-computed on the corrected criterion by the pass-9
  certificate; the old "gate opens in every direction" reading is
  withdrawn.
- **Corrected and closed:** pass-2 Theorem 2 → Theorem B.1 (surjective,
  kernel rank ten — not an isomorphism); Corollary 2.1 → Theorem B.3 (escape
  group `Z^10`, not `(Z/2)^10`); Corollary 2.2 → Theorem B.2 (`e_{X*}H^3(X,Z)`
  is primitive rank ten, not torsion; the `Z/3` remark in pass-2 §3 about its
  three-primary invisibility is moot).
- **The correction note's §3 directional sketch is overturned:** it
  predicted `b_*` on `H^5/tors` injective with finite-index image, reasoning
  from a finite-index guess for `b^*∧³Λ ⊂ H^3(M,Z)`; the index is in fact
  infinite (corank ten), and Theorem B proves the opposite split
  (surjective, kernel rank ten). Readers of the correction of record should
  not carry that expectation forward.
- **Hostile audit:** the drafted proofs were audited adversarially
  (`notes/2026-08-12-c908-h3-lattice-proof-audit.md`, verbatim); its one
  FATAL finding (the §4 gate congruence) had been caught and corrected
  before the audit landed and the audit's independent derivation matches
  the corrected (i′)+(ii); all GAP findings (citation loci for the cylinder
  isomorphism and `H^*(F,Z)` torsion-freeness, the Thom normalization line,
  Albanese injectivity, the link identification, conditionality marking)
  are repaired in this version.
- **The reposed items 1–3 of the correction note §4 are closed by this
  pass.** Item 4 (the `(Z/2)^10` coincidence) is largely resolved — see the
  ledger.

## 7. Mystery ledger (EJ + TT closeout)

- **Settled: the three-way `(Z/2)^10` coincidence (correction-note item 4),
  for two and a half of the three.** All are mod-two shadows of the single
  integral object `H^3(X,Z)` entering `H^*(M)`: `Sat/L_3∧³Λ ≅ H^3(X)⊗F_2`
  canonically via `ρ` (degree three), and `E/2E ≅ H^3(X)⊗F_2` via Theorem
  B.4 (degree five); `coker(L_5) = Q_{15} ≅ Λ_2^∨ ≅ (H^3(X)⊗F_2)^∨` via the
  corpus perfect pairing and the Clemens–Griffiths isometry. What remains of
  item 4 is only naturality: whether the composite identifications commute
  with the geometric maps (`ρ` versus the `P`-pairing dual) — the
  certificate's `ρ`-matrix makes this a finite comparison, left to the
  successor.
- **Settled:** the measured diagonal-parity dichotomy has a one-line
  mechanism (`e_X^*q_*μ^* = p_*π_E^*i_Δ^*`, a clean excess-zero base
  change), and the enlargement of `H^3(M,Z)` is exactly one copy of
  `H^3(X,Z)` — no more, no less (`res_L` is onto; the connecting map to
  `H^4(Θ)` vanishes).
- **Settled, and a genuine bonus (certified, not predicted):** the transfer
  is integrally surjective — `H^3(M,Z)` is *generated* by the classes
  `q_*μ^*T`, `T ∈ H^3(F×F,Z)`. The blown-up theta divisor's entire
  degree-three lattice comes from the Fano surface through the degree-six
  model, with nothing left over. (The human proofs only give surjectivity
  onto the `X`-block plus the saturation statement; exact integral
  surjectivity is the measured refinement.)
- **Settled:** the escape lattice is free; "escape mod two" was the shadow
  of an integral rank-ten freedom, and the exceptional divisor populates
  exactly its doubles. The sharp successor question is no longer "find any
  class outside `b^* + tors`" (the exceptional classes already are) but
  "find an algebraic class of **odd depth** in `E`".
- **Open (successor, spec frozen):** the λ leg computation per the promoted
  pass-8 spec — now with the bonus that its gate tests can also read the
  candidate's `E/2E`-class directly (§4.2), so a single certificate can
  settle both the λ-bit and the half-exceptional escape for the span-model
  family.
- **Open (small, logged to the discovery track):** the fourth `(Z/2)^10` —
  `coker(C_s∪(−) : H^1(F,Z) → H^3(F,Z))` from the extraction note §A5 —
  should be the `a_*`-image of the same shadow; with `ρ` pinned this is a
  cheap naturality check.
- **Process note, kept from the correction:** the refutation and this
  adjudication both came from certificates that *asserted* rather than
  assumed integral solvability. The pass-9 certificate continues that
  pattern: `ρ`'s existence is asserted over every generator, so a single
  counterexample to the base-change mechanism would fail loudly.

## 8. Verdict

The reposed adjudication is complete: `H^3(M,Z)` is the torsion-free
rank-130 extension of `H^3(X,Z)` by `∧³Λ` glued by `ρ`; `b_*H^3(M,Z)` is
exactly the saturation, index `2^10`; the escape group is `Z^10` with the
exceptional classes at depth two; gate A is re-issued on the corrected
criterion with its verdict certified per direction (§4, CHECK 10); the λ
leg computation is the next pass with its spec intact modulo the corrected
gate conditions.

Priority: a bounded literature audit
(`notes/2026-08-12-c908-h3-lattice-priority-audit.md`) found no prior
computation of the singular, integral, or intersection cohomology of `Θ` or
`Bl_0Θ` for cubic threefolds, and nothing near the extension or saturation
statements; the closest prior work is Bayer–Beentjes–Feyzbakhsh–Hein–
Martinelli–Rezaee–Schmidt (arXiv:2011.12240, Theorem 7.1), which identifies
`M = Bl_0Θ` with a moduli space of Gieseker-stable sheaves but computes no
cohomology.
