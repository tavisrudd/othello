# C908: the λ-bit — reduction theorem (all deep-stratum defects die mod 2) and verdict

Date: 2026-08-12

Status: **pass 9c, part 1 — the reduction is proved and recorded before the
main-term certificate runs; the verdict section is filled by that
certificate.** C908 mathematics only; no manuscript, PDF, mirror, Lean, or
C904-surface edit.

Notation: pass-8 spec (`notes/2026-08-12-c908-lambda-leg-spec.md`, promoted
this pass), pass 9 (`notes/2026-08-12-c908-h3-lattice-adjudication.md`),
compression pass (`notes/2026-08-12-c908-h3-compression.md`).
`B = F×F`, `A = X×B` (`dim A = 7`), `𝒮 ⊂ A` the universal span divisor with
class `S = H + G` (`H = p_X^*H`, `G = p_B^*ψ^*Θ`), `ι : 𝒮 → A`,
`ℒ = O_𝒮(Z' − Z + t·ι^*G)` the divisorial (rank-one reflexive, non-Cartier
along the node section `T_I` over `I∖Δ` and a priori also along the
Δ-cylinder `T_Δ = {(x,ℓ,ℓ) : x ∈ ℓ}`; `Z∩Z' = T_I ∪ T_Δ`, both of dim 3)
span-model sheaf, `𝒢 = ι_*ℒ`,
`D := c_1(ℒ) = [Z']_𝒮 − [Z]_𝒮 + t·ι^*G`. `σ` is the factor swap on `B`,
acting on `A` fixing `X`. The λ-bit reads
`N(x,a) = ∫ p_X^*x · (\text{test}) · c_4` mod 2 with `S(x,a)` odd
(pass-8 §0), and the pass-9b **pure antisymmetric tests** `T_{a_k}`
(swap-antisymmetric integral combinations of `β_m⊗1 − 1⊗β_m` with
`q_*μ^*T_{a_k} = b^*(Θ∧u_k)` exactly, coefficients in the compression
json) replace the old gate conditions.

## 1. Exactness of the working model against pure tests

**Lemma 1.** For a pure test `T` (so `i_Δ^*T = 0` in `H^3(F,Z)` and
`σ^*T = −T`), every step of the model-comparison chain is exact, not merely
even:

1. any class supported on `X×E ⊂ X×Y` or on `X×Δ ⊂ X×B` pairs to zero
   against `x⊗μ^*T` resp. `x⊗T`: for `j_{Δ*}γ` supported on `X×Δ`,
   `∫ j_{Δ*}γ·(x⊗T) = ∫ γ·(x⊗i_Δ^*T) = 0`, and on `X×E` the restriction is
   `(μ^*T)|_E = π_E^*(i_Δ^*T) = 0`;
2. hence `N(x,a)` computed with the actual family on `X×Y`, with its
   `(1×q)`-comparison to `X×M`, and with the μ-pushed span model on `X×B`
   all agree **integrally**: the pass-8 §3.1 derivation obligation is
   discharged exactly, and the downstairs readout equals
   `N = ∫_{A} c_4(𝒢)·(x⊗T_a)`.

*Proof.* (1) is the displayed projection-formula computation plus
`μ∘e_E = i_Δ∘π_E`; no integrality is needed — supported classes of any
coefficients pair to zero on the nose. (2), μ-leg: the family on `X×Y` and
the `(1×μ)`-pull of the span model (resp. the `(1×μ)`-push and the model on
`X×B`) are canonically isomorphic off `X×E` (resp. `X×Δ`), both being the
span construction over `B∖Δ ≅ Y∖E`; hence their ch's differ by classes
supported on those loci, and since `c_4` is a polynomial in `ch_{1..4}`,
every term of the `c_4`-difference carries a supported factor
(`j_*u·v = j_*(u·j^*v)`), so the `c_4`-difference is itself supported there
and pairs to zero by (1). The `X×M`-comparison is the projection-formula
transfer: for any family pulled back from `X×M`,
`∫ c_4((1×q)^*𝒰)·(x⊗μ^*T) = ∫ c_4(𝒰)·(x⊗q_*μ^*T) = ∫ c_4(𝒰)·(x⊗b^*(Θ∧a))`,
and the span model **is** such a pullback up to a base twist, by §1.1. Support
details: `notes/2026-08-12-c908-lambda-reduction-audit.md`, Finding G3. ∎

## 1.1 The span model descends along `q`

**Lemma D.** `𝒢` descends along the degree-six map `q : Y → M`: writing `𝒢_M`
for the universal family of `M_σ^s(β+γ) ≅ M`, there is a line bundle
`N ∈ Pic(Y)` with `(1×q)^*𝒢_M ≅ 𝒢 ⊗ p_Y^*N`.

*Proof.* Over a general point of `M` the fibre of the span construction is
`ι_*O_{S_{ℓ,ℓ'}}(ℓ'−ℓ)`, so it is enough that the six points of a `q`-fibre
carry the same cubic surface and the same divisor class on it. The span map
factors through `M`: `deg(g : F×F ⇢ (P^4)^∨) = 27·16 = 432` (ordered pairs of
skew lines on a smooth cubic surface — each of the 27 lines meets 10 others,
hence is skew to 16) and `deg(M_σ^s(β+γ) ⇢ (P^4)^∨) = 72` (LLPZ Example 5.7),
so the surface `S_{ℓ,ℓ'}` is constant on `q`-fibres. On `S`, adjunction gives
`ℓ·K_S = −1` for every line, so `δ = ℓ'−ℓ` satisfies `δ·K_S = 0` and, for
skew lines, `δ^2 = −2`: `δ` is a **root of the `E_6` lattice `K_S^⊥`**, of
which there are exactly 72. The map `(ℓ,ℓ') ↦ δ` from the 432 ordered skew
pairs to the 72 roots is `W(E_6)`-equivariant, and `W(E_6)` is transitive on
both sets, so it is surjective with all fibres of size `432/72 = 6`. Those six
pairs are exactly a `q`-fibre, and they give the same divisor class, hence the
same sheaf. Universality of `𝒢_M` then yields the stated isomorphism up to a
twist by a line bundle from the base. ∎

Consequently the readout computed below is the honest downstairs readout of
`𝒢_M`, up to the rank-zero base-twist correction recorded in §4. The factor
swap `σ` is **not** a deck transformation of `q` — it covers `(−1)_J`, since
`ψ∘σ = −ψ` — which is why the swap-antisymmetry of `ℒ` is no obstruction to
descent. Derivation, and the superseded reasoning it replaces:
`notes/2026-08-12-c908-e-model-mutation-comparison.md` §5.1.

## 2. The reduction theorem: `−6·ch_4` kills every deep defect

Write the Newton expression for a rank-zero sheaf class
(`h_k := ch_k(𝒢)`, `h_0 = 0`, `h_1 = S`):

\[ c_4(𝒢) \;=\; \tfrac{1}{24}\bigl[S^4 − 12S^2h_2 + 12h_2^2 + 48S\,h_3
   − 144\,h_4\bigr], \]

so `ch_4` enters `c_4` with the **even multiplier −6**.

**Theorem (reduction).** Let `m_k := ι_*[(e^{D}·\mathrm{td}(O(S))^{-1})]_{k-1}`
be the naive GRR terms (valid where `ℒ` is Cartier), and let
`M(x,T) := ∫ c_4^{\mathrm{main}}·(x⊗T)` be the contraction of the Newton
expression built from the `m_k`. Then for every pure test:

\[ N(x,a) \;\equiv\; M(x, T_a) \pmod 2 . \]

In particular the conifold correction at `T`, the `A_2`/`Cl = Z/3`
reflexive-hull discrepancies over the deep stratum `R`, and every other
sheaf-theoretic defect of the span model are **invisible in the λ-readout**:
the pass-8 §3.4 frontier is dissolved for the mod-2 computation.

*Proof.* Let `W` be the union of the non-Cartier locus of `ℒ` and the locus
where the ambient surrogate rules for `ι_*(D^k)` fail to restrict to the
intrinsic classes: `W ⊆ T_I ∪ T_Δ ∪ (\text{deep strata over } R)`, whose
dim-3 components are `T_I` and `T_Δ` only (the deep `R`-strata have
dim ≤ 2). On `U = A∖W` the embedding is lci with `ℒ|_U` a line bundle, so
Riemann–Roch sans dénominateurs gives `c_4(𝒢)|_U = c_4^{main}|_U` and GRR
gives `δ_k|_U = 0`; since `H^{2k}_W(A,\mathbf Q) ≅ H^{BM}_{14−2k}(W,\mathbf Q)
= 0` for `2k < 8`, `δ_1 = δ_2 = δ_3 = 0` exactly (`δ_1 = 0` also directly:
`ch_1(𝒢) = S = m_1`). By the Newton expression the substitution `h_k → m_k`
therefore changes `c_4(𝒢)` by exactly `−6·δ_4`, with no cross terms.

Integrality enters through the difference of Chern classes, not through
`δ_4` itself (whose own integrality remains open):
`δc := c_4(𝒢) − c_4^{main} = −6δ_4` is a difference of two **integral**
classes (`c_4` of a coherent sheaf; the certified-integral main term)
vanishing on `U`, hence lies in the image of
`H^8_W(A,\mathbf Z) ≅ H^{BM}_6(W,\mathbf Z) = \mathbf Z[T_I] ⊕ \mathbf Z[T_Δ]`
— free on the dim-3 components (`T_I` irreducible via the irreducibility of
the incidence divisor `I`). So `δc = n_I[T_I] + n_Δ[T_Δ]` with
`n_I, n_Δ ∈ \mathbf Z`. Against a pure test, `[T_Δ] ⊂ X×Δ` pairs to zero
exactly (Lemma 1(1)); and `∫[T_I]·(x⊗T_a) ∈ 2\mathbf Z`: the `(3,5)`-part
of `[Z]·[Z'] = [T_I] + (X×Δ\text{-supported})` (multiplicity one along
`T_I` by pass-8 §3b's generic transversality) consists solely of
`Ξ`-times-(X-degree-0) terms with coefficient 6 — the X-degrees available
in `[P]` are `4,3,2,0`, so X-degree 3 forces exactly one `Ξ` — and the
`Δ`-part pairs to zero. Hence
`N − M = ∫δc·(x⊗T_a) = n_I·(\text{even}) + 0 ∈ 2\mathbf Z`. Lemma 1
removes every other discrepancy exactly. ∎ Full derivation and audit trail:
`notes/2026-08-12-c908-lambda-reduction-audit.md`, Finding G1.

The mechanism is general and worth stating once: **`c_4` mod 2 of any
coherent class on a smooth variety is insensitive to integral
`ch_4`-perturbations**. For naive-model comparisons, where the perturbation
is not a priori a K-class, the mod-two readout is still blind to
codimension-4 corrections whenever the main term is integral and the
support cycles pair evenly against the tests — the two hypotheses the proof
above verifies; corpus reuse of this slogan must carry them. (The original swap-duality attack plan conjectured a
collapse of the swap-antisymmetric part of `c_4`; the true mechanism is
this even multiplier, found while executing that plan. The swap-duality
relation itself survives as a control — §3.)

## 3. The swap–duality control identity

`σ^*ℒ ≅ ℒ^{[-1]}` at the divisor-class level (`σ` swaps `Z ↔ Z'`, fixes
`G`; take `t = 0`), and Grothendieck duality for the divisor embedding
gives, in K-theory,
`[R\mathcal Hom_A(𝒢, O_A)] = −[ι_*(ℒ^{[-1]}(S))] + [\text{defect}]` with the
defect supported in codimension `≥ 4`. With `ch` of a derived dual being
`ch^∨ = Σ(−1)^k ch_k`:

\[ ch(σ^*𝒢) = −e^{−S}\,ch^∨(𝒢) + e^{−S}\,K,\qquad K = K_4 + \dots \]

Degreewise this returns `ch_1(σ^*𝒢) = S` and
`ch_2(σ^*𝒢) = −h_2 − S^2` (verified independently by direct GRR for
`ℒ^{-1}`), and in degree four produces, after Newton and pairing against a
pure test (using `∫c_4(σ^*𝒢)·(x⊗T) = −N` by the change of variables
`σ`):

\[ \int\Bigl[\tfrac{37}{12}S^4 + 6S^2h_2 + h_2^2 + 10S\,h_3\Bigr]\!\cdot\!(x⊗T_a)
   \;=\; 6\int K_4·(x⊗T_a) . \]

The left side is an explicit main-term contraction; the right side is six
times an integer. **Control:** the certificate must find the left side
divisible by six after substituting `h_k → m_k`, exactly — the left side is
`h_4`-free and `δ_2 = δ_3 = 0`, so the substitution is lossless, and the
identity binds at `t = 0` — a global integrality check on the entire class
inventory that also *measures* the duality-defect pairing instead of
assuming it.

## 4. What remains to compute: the main-term contraction

By §§1–2, λ is decided by finite explicit intersection theory on `A`:

1. `ι_*(1) = S = H+G`; `ι_*(D)`, `ι_*(D^2)`, `ι_*(D^3)` from the pass-8 §2
   inventory (cylinders `Z, Z'` via the universal-line class `[P]` with its
   Künneth parts from the extraction note; `Z·Z'` via the incidence
   cylinder; `Z^2, Z^3` via `N_{P/X×F}` and the relative Euler sequence;
   the `t·G`-twist carried symbolically).
2. Assemble `m_2, m_3, m_4` by GRR for the divisor embedding
   (`td(O(S))^{-1} = 1 − S/2 + S^2/6 − S^3/24`), then `c_4^{main}` by the
   Newton expression, with exact rational arithmetic; only the total is
   asserted integral.
3. Contract against `x_j ⊗ T_{a_k}` for the ten pure antisymmetric tests
   (compression json) and ten `x`-basis classes; the only surviving Künneth
   shape is `H^3(X)⊗(H^1⊗H^4 + H^4⊗H^1)(B)`-legs against
   `(3,0)+(0,3)`-tests.
4. Controls: fiberwise `ch = (0, H, −H²/2, −H³/6)`; `t`-independence mod 2;
   rigidity `N ≡ λ·S(x,a) mod 2` for a single `λ ∈ {0,1}`; the ablation
   (unit cylinder tensor `Ξ → 0` must force all-even); `ψ_*(1⊗1) = 6Θ`;
   and the §3 divisibility identity.

**Verdict: λ = 0 for the span-model family — an informed negative.** The
certificate computes the full 10×10 readout matrix `N = 120·I` integrally
(`120 ≡ 0 mod 2` in every entry against every pure test), with all controls
passing: fiberwise `ch`, rigidity (`N ≡ λ·S` with `λ = 0`), the ablation
(`Ξ → 0` gives zero identically), the duality-pairing divisibility by six,
`ψ`-sanity, and both sign-discriminating self-intersection controls
(`[Z]² = c_2(N_{Z/A})·[Z]` with Künneth value `6C_s⊗[pt]_X + 27[pt]_F⊗[line]`,
compared in true cohomology through slotwise `a_*`). `N` is t-dependent
integrally but t-independent mod two, as the twist lemma requires.

Scope of the negative. This settles the λ-bit for the **span-model family
`𝒢`** in the normalization used here, i.e. for the descended family `𝒢_M` up
to the base twist of Lemma D. That twist is not free for a rank-zero family:
by `notes/2026-08-12-c908-e-model-mutation-comparison.md` Lemma T, twisting by
`N` changes the `(3,5)` readout class by `n c_3^{(3,3)} + n^2 c_2^{(3,1)}` mod
two, `n = p_Y^*c_1(N)`. The `t`-control above is exactly the `n = tG` case of
that formula, and it is verified even — which is what makes the transfer to
the universal family go through.

**Transfer (extraction item F, discharged 2026-08-12).** The mutation
comparison is carried out in
`notes/2026-08-12-c908-e-model-mutation-comparison.md`: the Serre functor
relating `M_σ^s(β+γ)` to `M_X(v)` acts on the odd `X`-legs of `ch` by `∓1`,
the residual even-block change is `c_1(V)c_3^{(3,3)} + (c_2(V)+G^2)c_2^{(3,1)}`
mod two for the rank-three relative blow-down bundle `V = Rp_*(𝒢_M(H))`, and
every term is even. Hence `λ_ℰ = λ_𝒢 = 0`: the channel-population question is
closed negative for the `ℰ`-model universal family as well, and the `(1,5)`
channel remains open only through non-deformation-canonical, deck-asymmetric
sources.

## 5. Certificate bundle

Replay from the repository root:

```sh
nix shell nixpkgs#sage -c sage \
  notes/2026-08-12-c908-lambda-main-term.sage \
  --json notes/2026-08-12-c908-lambda-main-term.json \
  --out notes/2026-08-12-c908-lambda-main-term.out
```

| artifact | SHA-256 |
|---|---|
| `notes/2026-08-12-c908-lambda-main-term.sage` | `70ce714cd626265f1f15fbc06d58e4bdbf5f9a08a3501b6d9e121b3bf2dea553` |
| `notes/2026-08-12-c908-lambda-main-term.out`  | `a51c980b4baca0199182e83977e860e932a0c5c42c22bad032d56d0eb7835236` |
| `notes/2026-08-12-c908-lambda-main-term.json` | `edbecaf4dc96e27ebbf40147a8b9223d79c5aa0b1b4be9021c71b9e209817d54` |

Development provenance: the certificate was implemented by a sub-agent
whose session terminated at the two sign-validation controls; its own
diagnosis (free-slot-model artifact — raw key equality is finer than
equality of classes since `a^*Θ = 2C_s` is not imposed) was verified and
the two controls repaired to compare through the script's `normalize`
(slotwise `a_*`), plus the integral-t-independence control demoted to
report-only per the spec. The derivation log is preserved in the session
scratchpad report. The Newton coefficients, GRR shapes, and the degree-two
duality identity were independently re-derived by hand in a separate
review (clean).

## 6. Mystery ledger (interim; quota-shortened session)

- **Settled: λ = 0 for the span model**, by an integral computation with the
  scalar-identity shape `N = 120·I` — the deformation-rigidity pattern
  (`c·I` with even `c`) extends from the pass-7 product dictionary to the
  universal-family Chern route. `v_2(120) = 3`: the 2-adic depth is again
  strictly positive, consistent with the pass-7 "`v_2 ≥ 2` on every
  deformation-canonical class" lead (here through a non-product source).
- **Settled (methodological):** codimension-four sheaf defects can never
  affect a mod-two `c_4`-readout (§2). This retroactively dissolves the
  pass-8 R-stratum frontier and should be reusable wherever the corpus
  reads `c_4` mod 2.
- **Settled: the span model descends** along the degree-six map (Lemma D,
  §1.1), the number six being the size of the fibres of
  `(ℓ,ℓ') ↦ ℓ'−ℓ` from the 432 ordered skew pairs onto the 72 roots of `E_6`.
  The factor swap covers `(−1)_J` and is not a deck transformation, so
  swap-antisymmetry never obstructed descent.
- **Settled (successor, 2026-08-12): the `ℰ`-model transfer.** Extraction item
  F is discharged and `λ_ℰ = 0`
  (`notes/2026-08-12-c908-e-model-mutation-comparison.md`, Theorem F2). With
  the span model dead and the universal family dead, an odd `(1,5)` class must
  come from outside every named source: pullbacks, exceptional transforms, the
  span/incidence product dictionary, `c_4` of the span model, and `c_4` of the
  `ℰ`-model. The informed conjecture stands that the channel obstruction is
  real and `E`-depth parity is the invariant blocking it.
- **Settled (audit debt):** the reduction theorem's hostile audit is done
  (§7); its one major finding (the `δ_4`-integrality step) is repaired in
  the §2 proof above, and the §3 control identity was verified clean.

## 7. Audit status

Done: the Fable-grade hostile audit is recorded in
`notes/2026-08-12-c908-lambda-reduction-audit.md` (2026-08-12). Findings:
0 FATAL, 3 GAP (one major — the original `δ_4`-integrality step invoked a
K-theory principle whose hypothesis was never established; two minor — the
`T_Δ` support component and Lemma 1(2)'s support wording), 3 NIT. All
repairs are incorporated above: the §2 proof now runs through the integral
`c_4`-difference in `H^{BM}_6(W,\mathbf Z)` with per-component even
pairing, the support locus includes `T_Δ`, and Lemma 1's proof states its
sheaf-agreement input, the cross-term support argument, and the test-side
`(1×q)`-mechanism. The §3 control identity was verified clean (all signs,
the GRR/duality shape, and the `37/12, 6, 1, 10` coefficients independently
re-derived; the `K_4`-integrality is sound there since the duality defect
is an authentic K-class). The reduction theorem and the control identity
stand; the λ = 0 verdict is now **certificate-conditional only**.
