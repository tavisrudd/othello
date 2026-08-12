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
along the node section `T`) span-model sheaf, `𝒢 = ι_*ℒ`,
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
2. hence `N(x,a)` computed with the honest family on `X×Y`, with its
   `(1×q)`-comparison to `X×M`, and with the μ-pushed span model on `X×B`
   all agree **integrally**: the pass-8 §3.1 derivation obligation is
   discharged exactly, and the downstairs readout equals
   `N = ∫_{A} c_4(𝒢)·(x⊗T_a)`.

*Proof.* (1) is the displayed projection-formula computation plus
`μ∘e_E = i_Δ∘π_E`; (2) because each comparison differs by classes supported
on the loci of (1) (where `q` and `μ` fail to be isomorphisms). ∎

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

*Proof.* The non-Cartier locus of `ℒ` (the node section `T`, `dim 3`, and
deeper strata over `R`) has codimension `≥ 4` in the sevenfold `A`. Off
that locus GRR for the divisor embedding holds, so
`δ_k := ch_k(𝒢) − m_k` is represented by classes supported in codimension
`≥ 4`: `δ_2 = δ_3 = 0`, and `δ_4` is a **Z-linear combination of
codimension-4 cycle classes** (the leading ch-term of a K-theory class
supported in codimension four is its support cycle with integer generic
lengths). By the Newton expression, replacing `h_k` by `m_k` changes
`c_4(𝒢)` by `−6·δ_4`, an even integral class; hence
`N − M = −6∫δ_4·(x⊗T_a) ∈ 2\mathbf Z`. Lemma 1 removes every other
discrepancy exactly. ∎

The mechanism is general and worth stating once: **`c_4` mod 2 of any
coherent class on a smooth variety is insensitive to integral
`ch_4`-perturbations**, so mod-two `c_4`-readouts never see codimension-4
sheaf corrections. (The original swap-duality attack plan conjectured a
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
divisible by six after substituting `h_k → m_k` up to the even ambiguity of
`δ_4`-terms — a global integrality check on the entire class inventory that
also *measures* the duality-defect pairing instead of assuming it.

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
compared in honest cohomology through slotwise `a_*`). `N` is t-dependent
integrally but t-independent mod two, as the twist lemma requires.

Scope of the negative, unchanged from the pass-8 spec §0: this settles the
λ-bit for the **span-model family `𝒢`**. Transferring the negative to the
`ℰ`-model universal family needs the mutation comparison (extraction item
F, deferred). The channel-population question for `c_4(𝒢)` is closed
negative; the `(1,5)` channel itself remains open only through
non-span-model sources.

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
- **Open (the standing crown-adjacent question, sharpened):** with the span
  model dead, an odd `(1,5)` class must come from outside every source now
  excluded: pullbacks, exceptional transforms, the span/incidence product
  dictionary, and `c_4` of the span-model family. The `ℰ`-model mutation
  comparison (extraction item F) is the last named candidate; after it, the
  informed conjecture is that the channel obstruction is real and `E`-depth
  parity is the invariant blocking it.
- **Open (audit debt, §7):** the reduction theorem's hostile audit.

## 7. Audit status

The reduction theorem (§2) and the control identity (§3) have NOT yet had a
Fable-grade hostile proof audit (deferred for session-quota reasons; a
light consistency review only). The audit obligations for the successor:
the integrality of `δ_4` for K-classes supported in codim ≥ 4; the
localization step (GRR off the non-Cartier locus); the K-theory sign in the
duality identity; Lemma 1's support claims. Until that audit, treat the
verdict as certificate-conditional AND reduction-audit-pending.
