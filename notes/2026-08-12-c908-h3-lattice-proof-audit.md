# C908 pass-9 hostile proof audit of the H^3(M,Z) adjudication note

Date: 2026-08-12

Verbatim report of the adversarial proof audit (Fable sub-agent) run against
the DRAFT of `notes/2026-08-12-c908-h3-lattice-adjudication.md`. The FATAL
finding (section 4 gate congruence) had been independently caught and fixed in
the note before this audit landed; the audit derivation confirms the fix. All
GAP/COSMETIC findings were applied to the committed version of the note.

# Hostile proof audit: `notes/2026-08-12-c908-h3-lattice-adjudication.md`

Auditor: Fable sub-agent, 2026-08-12. Scope: human-proof sections 1-4, 6-8 (section 5 hashes ignored per instruction). Context read: the correction of record (`2026-08-11-c908-h3-resolution-lattice-correction.md`) and pass 2 (`2026-08-11-c908-m-cross-m-exceptional-residue.md`).

Verdict up front: Theorem A and Theorem B survive hostile reading (modulo the certificate-conditional CHECKs the note already flags, and three citable-but-uncited classical inputs). **Section 4's gate derivation contains a genuine FATAL error**: the displayed congruence `q_*μ^*T'' ≡ b^*v(T'') (mod 2H^3(M,Z))` is false whenever `i_Δ^*T'' ≡ 2 (mod 4)` in an odd direction; the stated gate conditions (i)+(ii) are NOT equivalent to reading `b^*(Θ∧a)`. The corrected gate is derived in Finding 1, together with the reason the operational λ-verdict is probably salvageable (the discrepancy class pairs evenly with every candidate in `b^*H^5 + e_{X*}H^3 + tors`).

---

## Finding 1 (FATAL). §4: the mod-2 transfer congruence is false; gate conditions (i)+(ii) are not the right equivalence

**The broken step.** §4 asserts: condition (ii) (`i_Δ^*T'' ≡ 0 mod 2`) "gives `q_*μ^*T'' ≡ b^*v(T'') (mod 2H^3(M,Z))`".

**Why it fails.** Work in the note's own `Ĥ`-coordinates (Theorem A.3, image of the embedding `(b_*, e_X^*)`), which identify `H^3(M,Z) ≅ Ĥ` and hence `2H^3(M,Z) ≅ 2Ĥ` — exactly `2Ĥ = {(2σ,2γ) : (σ,γ) ∈ Ĥ}`, not `Ĥ ∩ 2(∧⁵Λ ⊕ H^3(X))`. Under (ii), write `i_Δ^*T'' = 2s`, `s ∈ H^3(F,Z)` (unique; `H^3(F)` torsion-free), and `g := p_*π_E^* s ∈ H^3(X,Z)` (cylinder adjoint of the half). Then

```
q_*μ^*T'' − b^*v(T'') = (ψ_*T'' − L_3 v, g' − 0) = (0, 2g),   g' = p_*π_E^* i_Δ^*T'' = 2g.
```

Membership test: `(0,2g) ∈ 2Ĥ ⟺ (0,g) ∈ Ĥ ⟺ ρ(g mod 2) = 0 ⟺ g even ⟺ s even ⟺ i_Δ^*T'' ≡ 0 (mod 4)` (the last two steps use that `p_*π_E^*` is an integral iso, hence parity-faithful). Note `(0,2g)` IS in `Ĥ` (`ρ(2g mod 2) = ρ(0) = 0`), which is presumably what misled the author: both coordinates of the difference are even, but "coordinates even" is membership in `Ĥ ∩ 2(∧⁵Λ⊕H^3(X))`, a strictly larger group than `2Ĥ` (larger by exactly `(Z/2)^10`, the classes `(0,2g)` with `g` odd — these lie in `ker b_*|_{H^3}` at odd depth). So:

**The congruence holds iff `i_Δ^*T'' ≡ 0 (mod 4)`, not mod 2.** For `i_Δ^*T'' ≡ 2s` with `s` odd it is false, full stop.

**Consequently the stated equivalence is wrong.** The true statement (derived below in the note's own Smith coordinates for `L_3`: bases `(f_i)` of `∧³Λ`, `(g_i)` of `∧⁵Λ`, `L_3 f_i = g_i` (i ≤ 110), `= 2g_i` (111 ≤ i ≤ 120); `Sat = span(g_1..g_120)`, `Sat/L_3∧³Λ = ⟨ḡ_111..ḡ_120⟩`):

An element `L_3 u` lies in `2·Sat` iff `u_i` is even for `i ≤ 110` (the doubled coordinates `u_{111..120}` are unconstrained), and then `(L_3u)/2 ≡ (u_i mod 2)_{i>110}` in `Sat/L_3∧³Λ`. Applying this to `δ := q_*μ^*T'' − b^*(Θ∧a) = (L_3(v − Θ∧a), 2g)` and unwinding `δ ∈ 2Ĥ`:

**Corrected gate A (exact equivalence).** For `T'' ∈ H^3(F×F,Z)`, `a ∈ Λ`:
`q_*μ^*T'' ≡ b^*(Θ∧a) (mod 2H^3(M,Z))` **iff**

- (ii°) `i_Δ^*T'' ≡ 0 (mod 2)` — equivalently (via ρ, this part of §4 is correct) `ψ_*T''` is integrally `L_3`-solvable; and
- (i°) `ψ_*T'' ≡ L_3(Θ∧a) + 2·ρ̃(ḡ)  (mod 2·L_3∧³Λ)`, where `ḡ := p_*π_E^*(i_Δ^*T''/2) mod 2 ∈ H^3(X)⊗F_2` and `ρ̃(ḡ) ∈ Sat` is any lift of `ρ(ḡ) ∈ Sat/L_3∧³Λ` (well defined: changing the lift moves `2ρ̃(ḡ)` by `2L_3∧³Λ`).

Equivalently, in `v`-form: `v(T'') − Θ∧a` must have even Smith-coordinates on `f_1..f_110` AND Smith-coordinates on `f_111..f_120` congruent mod 2 to the `ρ`-coordinates of `ḡ`. The note's condition (i) (`v ≡ Θ∧a mod 2∧³Λ`) forces ALL coordinates even, which matches (i°) only when `ρ(ḡ) = 0`, i.e. only when `i_Δ^*T'' ≡ 0 (mod 4)`.

Special case check: if `i_Δ^*T'' ≡ 0 (mod 4)` then `ḡ = 0` and (i°) collapses to the note's (i) — the note's sub-claim `(L_3v, 0) ∈ 2Ĥ ⟺ v ∈ 2∧³Λ` is TRUE (verified: `(L_3v,0) = 2(σ,0)` needs `σ ∈ Sat`, `σ ≡ ρ(0) = 0 mod L_3∧³Λ`, i.e. `L_3v ∈ 2L_3∧³Λ`, i.e. `v ∈ 2∧³Λ` by injectivity of `L_3`). The error is solely the first link of the chain.

**What a (i)+(ii)-passing test with `i_Δ^*T'' ≡ 2 (mod 4)` actually reads.** Exactly:

```
q_*μ^*T'' ≡ b^*(Θ∧a) + κ(ḡ)   (mod 2H^3(M,Z)),
```

where `κ : H^3(X)⊗F_2 → H^3(M,Z)/2H^3(M,Z)` sends `ḡ ↦ class of (0, 2g̃)` (any lift `g̃`); `κ` is injective (`(0,2g̃) ∈ 2Ĥ ⟺ g̃ even`), with image the mod-2 shadow of `ker b_*|_{H^3}` at odd depth. So the test reads the intended `λ`-functional PLUS an extra mod-2 pairing of the candidate against the odd-depth kernel direction `ḡ`.

**Why the headline verdict is probably salvageable (the repair).** Pair the discrepancy `(0,2g)` against the three known candidate populations of §3:
- against `b^*H^5(J)`: `⟨(0,2g), b^*w⟩ = ⟨b_*(0,2g), w⟩ = 0` (it is in `ker b_*`);
- against `e_{X*}H^3(X)`: `⟨(0,2g), e_{X*}β⟩ = ⟨e_X^*(0,2g), β⟩ = ⟨2g, β⟩ ∈ 2Z`;
- against torsion: integral pairing kills it.

So the extra term vanishes mod 2 on every class of `b^*H^5 + e_{X*}H^3(X) + tors` — i.e. on everything at even depth in `E`. A candidate at odd `E`-depth (the half-exceptional escape, the very thing §4.2 wants to probe) DOES see the extra term. Therefore:

1. As a reader of the λ-bit against the known/even-depth candidate classes, gate A with (i)+(ii) still functions, but this needs to be SAID and PROVED via the pairing computation above — it is not what the note proved.
2. As an exact equivalence ("T'' reads b^*(Θ∧a) iff (i)+(ii)"), the statement is false; use (i°)+(ii°), or strengthen (ii) to `i_Δ^*T'' ≡ 0 (mod 4)` to get pure λ-tests at the cost of shrinking the test family.
3. The certified arithmetic ("every direction `a` reachable subject to (i)+(ii)") does not, as it stands, certify reachability under the corrected gate. Either re-run requiring `i_Δ^*T'' ≡ 0 (mod 4)`, or re-run with the coupled condition (i°). Until then, "the pass-8 verdict stands: the degree-six span model can read λ" (§4) and "gate A is sound" (§8) and "Stands, now with proof instead of assumption: the gate-A arithmetic verdict and the pass-8 gate conditions (i)+(ii)" (§6) are all overstated.
4. §4.2's interpretation ("tests with odd X-component probe E/2E") is incomplete one 2-adic level down: tests with EVEN X-component but `i_Δ^* ≡ 2 (mod 4)` also carry an odd-depth kernel component mod 2 and hence also probe the candidate's `E/2E`-class (in direction `ρ`-matched to `ḡ`), mixed into the λ-reading.

Severity: **FATAL** for §4's derivation and stated equivalence; the downstream verdict is downgraded to open-pending-recheck with a concrete, cheap repair path (mod-4 restriction or coupled condition, one certificate re-run).

---

## Finding 2 (GAP). §2.3: the cylinder-map integrality attribution has a hole

The cylinder-adjoint lemma's load-bearing input is: `π_{E*}p^* : H^3(X,Z) → H^1(F,Z)` is an integral isomorphism ("the Clemens–Griffiths integral isomorphism (an anti-isometry onto `(Λ,S)` after `a^*`; corpus: pass-2 §1.2, pass-8 §3b)").

- Pass-2 §1.2 establishes only that the Abel–Jacobi map `φ : H^3(X,Z) → Λ` is an integral isometry. It says nothing about the specific geometric correspondence `π_{E*}p^*` through `E = P(T_F) = P ⊂ F×X` computing `φ` (composed with `a^* : H^1(J) ≅ H^1(F)`). That identification — "the incidence/cylinder correspondence of the universal line induces the Abel–Jacobi isomorphism integrally" — is a distinct theorem. Classically it is Clemens–Griffiths (1972) territory (the cylinder map on `H_1(F) → H_3(X)` plus the tangent-bundle theorem), but the note cites no precise locus, and pass-8 §3b is not among the auditable corpus in this bundle.
- Everything in Theorem A.4, the surjectivity of `e_X^*` (§2.4), hence exactness/splitting in Theorem A.1, and the parity dichotomy all route through this lemma. It is the single most load-bearing uncited input in the note.
- Mitigation: CHECK 5 (existence/linearity/invertibility of `ρ` over all 940 generators) is, as the note itself says, an independent numerical confirmation — if `π_{E*}p^*` were not an integral iso, `ρ` would generically fail to be well defined or invertible. So the risk is low; the citation hole is real.

Severity: **GAP** (repair: cite the exact Clemens–Griffiths statement — the integral cylinder isomorphism — or the corpus note that proves `π_{E*}p^* = ±φ⁻¹-adjoint` on the nose; pass-8 §3b if it truly contains it, quoted with its own provenance).

## Finding 3 (GAP). §2.3: torsion-freeness of `H^*(F,Z)` asserted without provenance

The cylinder-adjoint proof needs the pairing `H^3(F,Z) × H^1(F,Z) → Z` unimodular. Poincaré duality gives unimodularity mod torsion for free; what is actually needed is torsion-freeness of `H^3(F,Z)`, equivalently (universal coefficients + PD on the surface `F`) torsion-freeness of `H_1(F,Z)`. The note asserts parenthetically "(`H^*(F,Z)` and `H^3(X,Z)` are torsion-free)". For `X` this is classical and corpus-used throughout. For the Fano surface, `H_1(F,Z) ≅ Z^10` torsion-free is a known classical fact, but neither of the two corpus notes read here establishes it and no citation is given. Severity: **GAP** (one citation; note the proof needs only `H^1`/`H^3` torsion-free, not all of `H^*(F,Z)` — stating the weaker requirement would also shrink the exposure).

## Finding 4 (GAP, minor). §2.3: Thom-class naturality is one line short

"Both steps are natural under `q` once `q^*(Thom class of N_{X/M}) = Thom class of N_{E/Y}`, which is exactly `q^*N_{X/M}|_E ≅ N_{E/Y}`." The bundle isomorphism alone does not identify `q^*τ_X` (a class of the pair `(Y, Y∖E)`) with `τ_E`: a priori `q^*τ_X = c·τ_E` for some `c ∈ Z`, since `H^2(Y,Y∖E) ≅ H^0(E) = Z·τ_E` by the Thom isomorphism. The missing line: restrict to the zero section — `q^*τ_X|_E = p^*e(N_{X/M}) = e(N_{E/Y})` by the bundle iso, while `τ_E|_E = e(N_{E/Y})`; since `e(N_{E/Y}) = −ξ` (tautological class of `P(T_F)`) is non-torsion in `H^2(E,Z)` (degree −1 on fibres), `c = 1`. Alternatively invoke clean base change / excess intersection with zero excess bundle. Conclusion correct; proof as written skips the normalization step. Severity: **GAP** (cosmetic-adjacent; one-line repair as above).

## Finding 5 (GAP, minor). §2.3: set-theoretic base change silently uses `ψ^{-1}(0) = Δ`

"Set-theoretically `q^{-1}(X) = E` because `Y∖E ≅ B∖Δ` maps into `U = M∖X`." That inclusion is exactly the statement `ψ^{-1}(0) = Δ`, i.e. `a(s) = a(t) ⟹ s = t` — injectivity of the Albanese embedding of `F`. True and classical (Clemens–Griffiths / Tyurin: `F ↪ J`), used without statement or citation. Also note the reverse inclusion `q(E) ⊆ X` (needed for `q^{-1}(X) ⊇ E`) is immediate from `b∘q = ψ∘μ` and `b^{-1}(0) = X` but is likewise unstated. Severity: **GAP** (two sentences and a citation).

## Finding 6 (GAP, minor). §2.1: the "link of the cone" justification is misdirected

"The triple point is an isolated hypersurface singularity whose projectivized tangent cone `X` is smooth, so its link `L` is the link of the cone." As literally argued, this is the topological cone-equivalence of a singularity with its tangent cone — for a general isolated hypersurface singularity with smooth projectivized tangent cone this needs an argument (semiquasihomogeneous topological triviality / μ-constancy plus Lê–Ramanujam, valid here since the ambient dimension is 5 ≠ 3, with `f = f_3 + higher` and `f_3` defining smooth `X`). The note asserts it with "so".

The cleaner argument, fully available from the note's own standing hypotheses (M = Bl_0 Θ smooth, `N_{X/M} = O_X(−H)`), avoids all of that: `σ` is an isomorphism off `X`, so a punctured neighbourhood of `0` in `Θ` is homeomorphic to `ν(X)∖X`, which retracts onto `∂ν(X)` = the unit circle bundle of `O_X(−1)`. Every later use of `L` (the pair sequence via a cone neighbourhood — the image `N = σ(ν(X))` is contractible since `ν(X)` retracts to `X` which maps to the point — and Mayer–Vietoris) needs only this. Severity: **GAP** (the stated justification invokes an unproved classical step; the correct one-paragraph replacement uses only standing corpus facts. Conclusion — and the whole Gysin table — verified correct: `H^1(L)=H^2(L)=0`, `H^3(L) = π_L^*H^3(X) ≅ Z^10` integrally since `∪h : H^2(X) → H^4(X)` is `×3` injective and `H^1(X)=0`, `H^4(L) ≅ Z^10 ⊕ Z/3`; sign of the Euler class `±h` is immaterial to every kernel/cokernel used).

## Finding 7 (COSMETIC). §2.2(i): the weak Lefschetz invocation is correct but should state its true strength

The claim `H^k(J,Z) ≅ H^k(Θ,Z)` for `k ≤ 3` integrally is TRUE at the stated strength: Hamm / Goresky–MacPherson prove the homotopy statement `π_i(J,Θ) = 0` for `i ≤ dim J − 1 = 4` for the support of an effective ample divisor in a smooth projective variety (ampleness suffices; very-ampleness is not needed — relevant since `Θ` on a ppav is ample but not very ample, so it is NOT a hyperplane section in any embedding; the theorem covers it via the general Hamm–Lê/GM form, or via `|mΘ|` on the support). The homotopy statement gives `H_i(J,Θ;Z) = 0` for `i ≤ 4`, hence the integral cohomology isomorphism for `k ≤ 3` and injectivity at `k = 4` by universal coefficients. No error; the note should name the precise theorem (GM, Stratified Morse Theory II.1.2, or Hamm) because "possibly singular" and "ample, not very ample" are both load-bearing edge conditions. Severity: **COSMETIC**.

Also verified in §2.2, no findings: the excision identification `H^k(Θ,U;Z) ≅ H̃^{k-1}(L,Z)` (cone neighbourhood contractible, `N∖0 ≃ L`); the connecting map `H^3(U) → H^4(Θ,U)` IS restriction-to-`L` under that identification (naturality of the pair sequences for `(N,N∖0) → (Θ,U)` plus `δ` iso for contractible `N`), so `ker(res_L) = im H^3(Θ)` exactly; `ν(X)∩U ≃ L` in MV; the `X`-side MV restriction IS `π_L^*` (inclusion `∂ν ⊂ ν` composed with the retraction `ν → X` is `π_L`); the kernel/image identifications and the `H^3(M) ≅ H^3(U)` projection argument; the Gysin corroboration (`e_X^*e_{X*} = ∪(−h)`, `h∪h = 3ℓ ≠ 0`). All correct integrally.

---

## Verified sound (adversarially checked, no finding)

**§2.3 remainder.** Multiplicity-one: `E` irreducible (`P(T_F)` over irreducible `F`) so `q^*X = mE`; the fibre-curve test is legitimate (`∫_C q^*[X] = ∫_M [X]·q_*[C]` is the cohomological projection formula; `q_*[C] = [ℓ]` because `C = {ℓ}×ℓ` maps isomorphically onto the line `ℓ`; `X·ℓ = deg N_{X/M}|_ℓ = −1`; `E·C = deg O_{P(T_F)}(−1)|_C = −1`), giving `m = 1`, `q^*O_M(X) ≅ O_Y(E)`, `q^*N_{X/M}|_E ≅ N_{E/Y}`. Dualization: all four projection-formula steps check (proper maps of compact oriented manifolds, integral); the conclusion `e_X^*q_*α = p_*e_E^*α` follows since `H^3(X,Z)` is torsion-free with unimodular (hence perfect) cup pairing. `μ∘e_E = i_Δ∘π_E` is right (`μ|_E : P(N_{Δ/B}) → Δ`, `N_{Δ/B} ≅ T_F`, and `π_E` is that projection under `Δ_F ≅ F`). `b_*q_*μ^*T = ψ_*μ_*μ^*T = ψ_*T`: proper-pushforward functoriality on `b∘q = ψ∘μ` plus `μ_*μ^* = id` (projection formula, `μ_*1 = 1`, `μ` birational). `q_*` on odd cohomology is integrally fine (PD-transport of `H_*`-pushforward on smooth projectives).

**§2.3 cylinder-adjoint bookkeeping.** `⟨p_*π_E^*x, β⟩_X = ∫_E π_E^*x ∪ p^*β = ⟨x, π_{E*}p^*β⟩_F`: both projection formulas legitimate; degrees: `p_* : H^6(E) → H^6(X)` degree-preserving (`dim E = dim X = 3`), `π_{E*} : H^3(E) → H^1(F)` drops by 2 (`P^1`-fibres), products land in the top degree on both sides. Adjoint-of-iso over `Z`: with both pairings unimodular and torsion-free lattices, `D = (PD_X)^{-1}∘C^∨∘PD_F` is an iso when `C` is; ranks 10 = 10 on both sides (`b_3(F) = b_1(F) = 10`, `b_3(X) = 10`). Sound (conditional on Findings 2-3).

**§2.4.** `e_X^*` surjectivity via `i_Δ^*(β⊗1) = β` and the cylinder adjoint: correct. Exactness `0 → ∧³Λ → H^3(M,Z) → H^3(X,Z) → 0` with `b^*` injectivity from `b_*b^* = L_3` injective (Smith form has no zero divisor): correct; free quotient ⟹ split ⟹ torsion-free rank 130 (torsion-freeness also directly from the MV injection into `H^3(X)⊕H^3(U)`, both torsion-free — `H^3(U)` is an extension of a subgroup of `H^3(L) = Z^10` by `∧³Λ`). Retroactive surjectivity of `res_L`: correct. Injectivity of `(b_*, e_X^*)`: correct. Sandwich upper bound: `q_*q^* = 6·id` holds integrally on all of `H^*(M,Z)` (projection formula with `q_*(1) = 6 ∈ H^0(M) ≅ Z`; the coefficient is the generic degree — `H^0` has no room for corrections from the non-finite locus, which affects nothing cohomological here); `b_*ξ = (1/6)ψ_*(μ_*q^*ξ)` correct; the containment into `L_3∧³Λ⊗Q` is honestly labeled certificate-conditional (CHECK 3, a rational statement so generator-checking suffices); `(L_3∧³Λ⊗Q) ∩ ∧⁵Λ = Sat` is the correct definition of saturation. `ρ`: well-definedness (lifts differ by `b^*∧³Λ`, `b_*b^* = L_3`), kills `2H^3(X)` since `2·Sat ⊆ L_3∧³Λ` — verified from the Smith form (`Sat = span(g_1..g_120)`, `L_3∧³Λ = span(g_1..g_110, 2g_111..2g_120)`, quotient `(Z/2)^10` exponent two, index `2^10`); onto by the sandwich; equal `F_2`-dimensions 10 ⟹ iso. The `Ĥ`-image description: both inclusions verified (given `(σ,γ)` compatible, adjust any lift of `γ` by `b^*L_3^{-1}(σ − b_*ξ_0)`). Parity-preservation of the cylinder adjoint (integral iso ⟹ `γ` odd iff preimage odd): correct.

**§3 Theorem B, every duality step.** PD `H^5(M,Z)/tors ≅ Hom(H^3(M,Z),Z)` unimodular (compact oriented 8-manifold, `H^3` torsion-free by Theorem A): correct. (1): `b_*` on `H^5/tors` = `(b^*)^∨` via projection formula composed with the unimodular `(∧³Λ)^∨ ≅ ∧⁷Λ` (wedge pairing on a free lattice is unimodular): correct; Theorem A's SPLIT sequence makes `b^*∧³Λ` a direct summand, so restriction of functionals is surjective and the kernel — functionals vanishing on a summand = functionals through the complement — is exactly the functionals factoring through `e_X^*`; primitivity: kernel of a map into a torsion-free group. All correct, and the splitness is genuinely used (for a non-split exact sequence surjectivity of restriction would fail; here it is established). (2): `β ↦ ⟨β, e_X^*(−)⟩` lands in `(b^*∧³Λ)^⊥` and is an iso onto it by surjectivity of `e_X^*` plus unimodularity of the cup pairing on `H^3(X,Z)`: correct; combined with `b_*e_{X*} = (b∘e_X)_* = 0` (constant map, `π_* : H^3(X) → H^{-3}(pt) = 0`): B.2 correct. (3): the lattice lemma "P unimodular, S ⊆ P primitive ⟹ P → S^∨ surjective" is TRUE (primitive ⟹ P/S free ⟹ Hom(P,Z) → Hom(S,Z) onto; unimodularity gives P ≅ Hom(P,Z)); `Sat` is saturated by construction; functionals vanishing on `ker b_*` = functionals factoring through `b_*` onto its image `Sat` (first isomorphism theorem — image equality from Theorem A.2 is what's used, certificate-conditional via CHECK 4); `ker b_*|_{H^3}` saturated (kernel into torsion-free) ⟹ direct summand ⟹ restriction `Hom(H^3(M),Z) → Hom(ker b_*,Z)` surjective ⟹ `E ≅ Hom(ker b_*,Z) ≅ Z^10`. Correct. (4): `ker b_* = {(0,γ) : ρ(γ̄) = 0} = {(0,γ) : γ ∈ 2H^3(X,Z)}` — verified with `ρ` iso; `e_X^*` on it injective with image `2H^3(X,Z)`; `f_β|_{ker b_*} : (0,2δ) ↦ 2⟨β,δ⟩` = twice the unimodular dual under the halving identification `ker b_* ≅ H^3(X,Z)`; image in `E` = `2E` since `β ↦ ⟨β,−⟩` is onto `Hom(H^3(X),Z)`. Correct.

**Internal-consistency check requested:** `e_X^*e_{X*} = ∪(−h) = 0` on `H^3(X,Z)` (since `H^5(X) = 0`). Nothing in the note contradicts it: the `H^2`-level use in §2.2(iii) (`h∪(−h) = −3ℓ ≠ 0`) is a different degree; B.2's injectivity of `e_{X*}` mod torsion is proved by pairing against `e_X^*`-surjectivity (an `H^3(M)×H^5(M)` pairing), not via `e_X^*e_{X*}`. Consistent.

**§3 readout paragraph.** "Every value in `Q_15 = coker(L_5)` is still realized by classes on `M`" follows from B.1 surjectivity: correct, and correctly labeled cohomological.

---

## Finding 8 (COSMETIC). §3 vs the correction of record: the interim dualization sketch is silently overturned

The correction note §3 predicted "duality gives `b_*` on `H^5/tors` injective with image of index `2^k` — not surjective", reasoning from the (then-open) guess that `b^*∧³Λ ⊆ H^3(M,Z)` has FINITE index. Theorem A shows the index is infinite (corank 10), and Theorem B proves the exact opposite split (surjective, kernel rank 10). Pass 9 is right; but since the correction note is "the correction of record", one sentence noting that its §3 directional sketch was wrong (and why: the finite-index assumption) would prevent a reader of the record from carrying the stale expectation. Severity: **COSMETIC**.

## Finding 9 (GAP). §1/§6/§8 conditionality bookkeeping (beyond Finding 1's overstatements)

- Theorem A as displayed in §1 does not mark which parts are certificate-conditional. From the §2 proofs: A.2 (`b_* = Sat`, the index, and the sum-lattice equality) and hence the "onto" half of A.3's `ρ` rest on CHECKs 3-4; §5 does disclose this split ("Human proofs, not certified: §2-§3" plus the certified list), but §1, §6 and §8 state A.2/A.3 unconditionally. With the §5 hashes still TBD at audit time, the certificate-conditional halves are currently backed by nothing committed. Severity: **GAP** (bookkeeping, not mathematics; resolves when the bundle is committed — but §6's "Stands, now with proof instead of assumption" for the gate verdict is wrong independently, per Finding 1).
- §7 ledger, "Settled: the enlargement is exactly one copy of `H^3(X,Z)` — no more, no less": proved (Theorem A.1) conditional on Finding 2's cylinder input and CHECKs; fair as stated given §5's disclosure.
- §8 "gate A is sound, finer than designed, and open": overstated per Finding 1 (the "finer" claim survives in spirit — Finding 1 shows even MORE fine structure than §4.2 claims — but "sound" is exactly the part that is broken).

---

## Summary

| # | Section | Finding | Severity |
|---|---------|---------|----------|
| 1 | §4 (+§6, §8) | `q_*μ^*T'' ≡ b^*v(T'') mod 2H^3(M,Z)` false unless `i_Δ^*T'' ≡ 0 (mod 4)`; gate (i)+(ii) is not the claimed equivalence; corrected gate (i°)+(ii°) derived; verdict "can read λ" downgraded to open-pending-recheck (salvage path given) | FATAL |
| 2 | §2.3 | Cylinder-map integral-iso attribution: pass-2 §1.2 proves only the Abel–Jacobi iso, not that `π_{E*}p^*` computes it; precise Clemens–Griffiths locus needed | GAP |
| 3 | §2.3 | `H^*(F,Z)` torsion-freeness (really: `H_1(F,Z)`) asserted without citation; needed for unimodularity of the `H^3(F)×H^1(F)` pairing | GAP |
| 4 | §2.3 | Thom-class naturality: bundle iso alone doesn't pin `q^*τ_X = τ_E`; needs the Euler-class/non-torsion normalization line | GAP (minor) |
| 5 | §2.3 | Set-theoretic `q^{-1}(X) = E` silently uses `ψ^{-1}(0) = Δ` (Albanese injectivity) | GAP (minor) |
| 6 | §2.1 | "Link of the cone" justified by tangent-cone smoothness alone; needs Lê–Ramanujam/semiquasihomogeneity — or, better, the available blow-up tubular-neighbourhood argument | GAP (minor) |
| 7 | §2.2(i) | Weak Lefschetz correctly invoked; should cite the precise Hamm/GM form (ample-not-very-ample, singular divisor, homotopy version ⟹ integral coefficients) | COSMETIC |
| 8 | §3 | Silently overturns the correction note's §3 interim expectation (injective-not-surjective) without flagging it | COSMETIC |
| 9 | §1/§6/§8 | Certificate-conditional halves of Theorem A stated unconditionally outside §5; §6/§8 gate-soundness claims overstated (see Finding 1) | GAP |

Clean under hostile reading: §2.1 Gysin table (integrally), all of §2.2's sequence bookkeeping including the two restriction-map identifications, §2.3's multiplicity-one and dualization computations, §2.4 entire assembly (sandwich, `ρ`, `Ĥ`), §3 Theorem B all four duality steps including the ×2 depth computation, and the requested `e_X^*e_{X*} = 0` consistency check.

Totals: 1 FATAL, 6 GAP (three minor), 2 COSMETIC.


