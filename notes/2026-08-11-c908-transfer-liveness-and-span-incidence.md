# C908: the Fano transfer is fully live, and the span-incidence design

Date: 2026-08-11

Status: **pass-6 interim: topological liveness theorem certified; the naive
cycle candidates are proved dead by a divisor-parity mechanism; the
span-incidence family is the designed successor.** C908 mathematics only; no
manuscript, PDF, mirror, Lean, or C904-surface edit.

Notation as in `notes/2026-08-11-c908-universal-family-even-rigidity.md`
(pass 5), plus: `F` the Fano surface of lines, `a : F → J` the Albanese
embedding with `[a(F)] = Θ^{[3]} = Θ³/3!`, `C_s` the incidence divisor class
with `a^*Θ = 2C_s` and `H^2(F,Z) = a^*H^2(J,Z) + Z·C_s` of index two
(corpus: `notes/2026-08-10-c904-primitive-theta-fano-resolution-lattice.md`
§1), `ψ : F×F → J` the difference map `(ℓ,ℓ') ↦ a(ℓ') − a(ℓ)`, and `⋆` the
Pontryagin product `x⋆y = PD^{-1}(PD x ∧ PD y)`.

## 1. Certified: the ψ-transfer hits the whole escape lattice

Certificate bundle (replay command in the script header; run from the
repository root):
`notes/2026-08-11-c908-pontryagin-transfer-image.{sage,out,json,md}`,
SHA-256 script
`c7bdd9d266b97fe10d58be7fccef04a138ed05f2d9eb82c91ac1e97f55ed3d96`, out
`ac90daa1278b452e2da9fbe8a6775500b5e878cd5f1279dc19c6a3afe143da27`, json
`072629f70c202dae22b2e24d139c6dc38b7958bcca0ce6a3e03d692d01095402`.

For `u ∈ ∧²Λ` and `z ∈ Λ` (as the `∧⁹Λ`-dual), set
`E(u,z) = (u∧Θ^{[3]}) ⋆ ẑ ∈ ∧⁷Λ` — the ψ-pushforward of an
`H^2(F)⊗H^3(F)`-class with `a^*u`-leg and `z`-dual leg. Results:

1. **Liveness.** The 450 classes `[E(u,z)]` span all of
   `Q_15 = (Z/2)^10`; integrally, `L_5∧⁵Λ` + the `E`-lattice is all of
   `∧⁷Λ` with elementary divisors `1^120`. **Unhit escape dimension zero.**
   So every `(1,5)` residue direction is topologically reachable by classes
   pushed from `F×F`. No exclusion theorem exists at this level; the
   construction route is licensed.
2. **Dead subfamilies, exactly two, both certified and both humanly proved:**
   `Λ∧Θ^{[3]}` (the `H^1⊗H^4`-channel: `3(Θ^{[3]}∧a) ∈ L_5∧⁵Λ` over `Z` and
   3 is odd — the factor three is load-bearing, the classes themselves are
   not in the image over `Z`), and the `u = Θ` line
   (`Θ∧Θ^{[3]} = 4Θ^{[4]}`, content four). Also `a_*C_s = 2Θ^{[4]}` is even,
   so the index-two class of `H^2(F,Z)` contributes nothing mod two and the
   `a^*`-restricted computation is complete.
3. **Fine structure** (recorded, one open item): each fixed `z` yields
   exactly a hyperplane of `Q_15` (dimension nine, ten distinct hyperplanes
   with rank-ten annihilator set); over the 45 basis `u` the `z`-span
   dimension is bimodal `{2: 24, 8: 21}` and correlates with neither the
   vanishing nor the parity of `S_ij` — unexplained; cheapest probe is the
   same histogram in a symplectic basis. Logged as a genuine small mystery,
   not manufactured.

Divided powers `Θ^{[k]}`, `k ≤ 5`, were verified integral both by
`k!·Θ^{[k]} = Θ^k` and by independent reconstruction from the five
symplectic pairs.

## 2. The divisor-parity no-go for the naive candidates

Candidate cycles of pullback-product shape on `(F×F)×(F×F)` — e.g. the
middle diagonal `{ℓ₂ = ℓ₃}` times the outer incidence `{ℓ₁ ∩ ℓ₄ ≠ ∅}` —
have their `(1,5)` second legs forced into `H^1⊗H^4` and
`(divisor)⊗H^3`-components. The first family is dead by §1.2; and on the
very general cubic threefold `NS(J) = ZΘ`, so `NS(F) ⊗ Q = Q·C_s` and every
divisor-restriction leg is a `C_s`-multiple up to torsion — dead by
`a_*C_s = 2Θ^{[4]}`. Hence:

> **Lemma (naive-candidate no-go).** Any codimension-three class on
> `(F×F)×(F×F)` that is a product of pullbacks of divisor classes and at
> most one diagonal `Δ_F` has `(1,5)` residue zero mod two on the very
> general member — and therefore, by local constancy, identically over the
> family.

The live directions `u∧Θ^{[3]} ⋆ ẑ` with `u` outside `ZΘ + 2∧²Λ` require a
**transcendental** `H^2(F)`-Künneth leg, which no divisor pullback and no
single-diagonal product can supply (a `Δ_F`-`(2,2)`-component forces
first-factor degree at least two, leaving the `(1,5)` bidegree).

## 3. The span-incidence family — the designed successor

The canonical source of transcendental `H^2(F)`-legs is the geometry of the
spanning surface: for lines `ℓ₁, ℓ₂` on `X`, let `S(ℓ₁,ℓ₂) = X ∩ P³(ℓ₁,ℓ₂)`
be the cubic-surface span (tangent `P³` on the incident locus). Define the
**span-incidence cycle**

\[ Z_{sp} \;=\; \{(ℓ₁,ℓ₂,ℓ₃) : ℓ₃ ⊂ S(ℓ₁,ℓ₂)\} \;⊂\; F×F×F , \]

of codimension two (27 lines on the generic span). Its Künneth components
couple three slots at once, and its `H^2`-legs sweep the 27-lines Picard
local system of the span family — transcendentally rich, exactly the live
directions. Candidate codimension-three classes on `(F×F)×(F×F)` are then
built as `Z_{sp}`-pullbacks (slots `(1,2,3)` or permutations) times one
incidence or diagonal divisor, e.g.

\[ W \;=\; (pr_{123})^*[Z_{sp}] \cdot (pr_{24})^*[I_F] \quad\text{and permutation variants.} \]

All are deformation-canonical, so Theorem E pins each residue to `{0, I_10}`
— a built-in validation: any computed residue outside that set flags an
error. If any variant computes to `I_10`, the `(1,5)` channel-population
question (pass-4 §6.3, pass-5 §6) is settled **positively by an explicit
cycle**, with the bit `λ`-computation for `c_4(ℰ)` no longer needed for the
channel question.

Computation plan (next pass):

1. `[Z_{sp}] ∈ H^4(F³)`: via the span map `g : F×F ⇢ (P⁴)^∨` and the flag
   incidence `{ℓ₃ ⊂ H}` in `Gr(2,5) × (P⁴)^∨` — a Schubert-class pullback
   computation. Inputs: the classical restriction `H^*(Gr(2,5),Z) → H^*(F,Z)`
   (tautological Chern classes of the Fano surface — Clemens–Griffiths-era
   numerology, to be extracted with loci), the class of the span-map graph,
   and the boundary corrections on the incident locus (where the span
   degenerates to the tangent `P³`).
2. Push the `(1,5)` legs through `ψ` by the certified Pontryagin machinery;
   the readout of `(q×q)_*`-pushed classes needs only `ψ_*π_*` (the blowup
   `π` is `π_*π^* = 1`, and exceptional corrections die on
   `r^*`-shaped tests since `ψ(Δ) = {0}` — pass-2 Theorem 3 mechanism).
   Parity survives pushforward: `q_*` is difference-adjoint on legs, not
   multiplication by `deg q = 6`; only pulled-back tests die.
3. Assemble the residue matrices for the variant library; check against the
   `{0, I}` pin; report the first variant with residue `I`, or the informed
   negative.

## 4. Mystery ledger (EJ + TT, interim)

- **Settled (certified + human proofs for the dead parts):** the ψ-transfer
  image is everything — the escape lattice is fully reachable from `F×F`.
- **Settled:** the two dead subfamilies and the `C_s`-evenness; together
  they explain why every "obvious" candidate cycle was silently parity-dead,
  and they defuse a would-be false exclusion proof that examined only those
  subfamilies.
- **Settled (lemma):** divisor-legged naive candidates are all dead; the
  game is transcendental `H^2(F)`-legs.
- **Open (designed, next pass):** the span-incidence residue computation.
- **Open (small, logged):** the bimodal `{2: 24, 8: 21}` per-`u` span
  histogram resists the two obvious explanations; retry in a symplectic
  basis.
- **Open (inherited):** everything in pass-5 §5 (the odd witness profile)
  stands; a span-incidence success would populate the channel but its trace
  is still even — oddness continues to require the deck-asymmetric special
  construction.
