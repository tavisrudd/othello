# C908: the pass-8 λ leg spec (promoted from the scratchpad working draft)

Date drafted: 2026-08-11 (pass-8 session scratchpad); promoted 2026-08-12 with pass 9c.

Supersessions on promotion: the gate conditions of §1 are superseded by the pass-9
corrected gate and the exact integral pure tests of the compression certificate
(`notes/2026-08-12-c908-h3-compression.md` §2); the §3.4 R-stratum frontier and §3.1
obligation are dissolved for the mod-2 readout by the reduction theorem of
`notes/2026-08-12-c908-lambda-reduction-and-verdict.md` §2. The class inventory of §2
and the controls of §4 remain the working plan and are used by the main-term certificate.

# C908 pass-8 working spec: the λ-bit through the degree-six span model

Working draft (scratchpad). Notation: pass-5 §6, pass-7 report
(notes/2026-08-11-c908-span-incidence-parity-no-go.md). B := F×F,
Y := Bl_Δ(B), q : Y → M degree six, ψ̃ = b∘q = ψ∘μ.

## 0. Architecture

Target: λ ∈ {0,1} — does c_4 of a universal family on X×M have (3,5)-legs
escaping b^*H^5(J,Z)+tors? By rigidity λ = N(x,a) mod 2 for one pair with
S(x,a) odd, N(x,a) = ∫_{X×M} p_X^*x · p_M^*(b^*(Θ∧a)) · c_4.

Compute upstairs with the SPAN-model family (canonical, explicit):
𝒢 = ι_{𝒮*}ℒ on X×Y, fiberwise ι_*O_{S_{ℓ,ℓ'}}(ℓ'−ℓ), ch fiberwise
(0, H, −H²/2, −H³/6) (LLPZ Example 5.7). Positive λ_𝒢 settles
channel-population for any universal source; transferring a negative to the
ℰ-model needs the mutation comparison (deferred — extraction item F).

## 1. Gate A (decisive; certificate requested from the impl sub)

Pulled-back tests die (deg 6 even). Need T'' ∈ H^3(B) with
q_*μ^*T'' ≡ b^*(Θ∧a) mod 2·H^3(M). Via b_*: b_*q_*μ^*T'' = ψ_*T'' and
b_*b^*v = L_3(v), L_3 Smith 1^110 2^10, so the comparison lives in ∧³Λ:
  (i)  v(T'') := L_3^{-1}(ψ_*T'') ≡ Θ∧a (mod 2∧³Λ)
  (ii) i_Δ^*T'' ≡ 0 (mod 2)  [kills E-supported family corrections against
       the test: (μ^*T'')|_E = (μ|_E)^*(T''|_Δ)]
The E-summand of H^3(Y) contributes nothing (H^1(X) = 0 kills its q_*).
Gate output: the subspace of reachable directions a ∈ Λ_2. If empty for
every a with an S-odd partner: the degree-six route cannot read λ; the
attack moves downstairs (harder; separate design).

## 2. Class inventory for the leg computation (gate-conditional)

On A := X×B (work μ-pushed; Δ/E-corrections die against gate-(ii) tests;
verify that claim once more when assembling — the correction classes are
(1×j_E)_*-supported and pair against (μ^*T'')|_E):

- [𝒮] = H + G, H := p_X^*H, G := p_B^*(ψ^*Θ).
- Line cylinders Z := {x ∈ ℓ_1}, Z' := {x ∈ ℓ_2} ⊂ 𝒮 ⊂ A, codim 2 in A;
  [Z] = (1×pr_1)^*[P], [P] ∈ H^4(F×X) the universal-line class
  (extraction item E: Künneth parts incl. the cylinder unit tensor in
  (1,3)/(3,1) — THE source of Λ-legs).
- D := c_1(ℒ) = [Z']_𝒮 − [Z]_𝒮 + (twist t·ι^*G, carried symbolically;
  rank 0 ⇒ ch_1 twist-invariant; readout must be t-independent mod 2 —
  assert as control).
- GRR: ch(ι_*ℒ) = ι_*(e^D)·(series in (H+G)) via td(O(𝒮))^{-1}; needed
  pushforwards ι_*(D^k), k ≤ 3:
  · ι_*(1) = H+G; ι_*(D) = [Z'] − [Z] (+t·G(H+G));
  · ι_*(D²): from Z², Z'², Z·Z'. Z·Z' = the incidence cylinder
    {x = ℓ_1∩ℓ_2} — class from P×_X P/CG §10-11 data (extraction has the
    resolution Ĩ = P×_X P). Z² via N_{L/𝒮}: ι_{L*}c_1(N_{L/A}) − [Z](H+G),
    N_{L/A} = pullback of N_{P/X×F}; c_1(N_{P/X×F}) = c_1(T(X×F))|_P −
    c_1(T_P) — classical: c(T_F) = 1 − 3C_s + 27[pt],
    c(T_X) = 1 + 2H + 4H² − 2H³ (χ(X) = −6 ✓), P = P(T_F) (Roulleau
    Thm 7) so T_P from the relative Euler sequence.
  · ι_*(D³): same tools one degree up (fiberwise checks: (ℓ'−ℓ)² = −2 on
    a cubic surface fiber, ℓ² = −1, ℓ·ℓ'-skew = 0, (ℓ'−ℓ)·K_S = 0).
- Fiberwise ch-controls: restricting ch(𝒢) to X×{pt} must give
  (0, H, −H²/2, −H³/6); restriction of ι_*(D) to a fiber: ℓ'−ℓ ✓.

Then: extract the (3,5)-part of c_4(𝒢) (equivalently work with ch_4 and
convert — fix the exact integral bookkeeping when writing the certificate;
mod 2 c_4 ≡ ch-polynomial with known denominators cleared — verify
integrality explicitly, no silent division), pair against
p_X^*x · p_B^*T'' with the gate-A solution T'', reduce mod 2. Output:
λ-matrix N(x, a) over the reachable (x,a); consistency N ≡ λS (rigidity
control); verdict λ ∈ {0,1}.

## 3. My open derivation obligations

1. Re-verify the μ-pushed working model drops nothing odd: the honest
   family lives on X×Y; its classes = μ-pushed span-model classes +
   E-supported corrections; corrections pair only through (μ^*T'')|_E ≡ 0
   (gate (ii)) — write this argument out properly (the correction classes
   also enter through ι_*(D^k)-boundary behavior over Δ where S degenerates
   to the tangent-hyperplane section with a double point).
2. The t-independence control derivation (why mod-2 independence is
   guaranteed by the downstairs twist lemma once E/Δ-junk dies).
3. If λ_𝒢 = 0: the mutation comparison (extraction F) to transfer the
   negative to ℰ; if sources are silent, derive the ±1-leg action or
   record the exact gap.
4. Fiber degeneration audit (analyzed; one genuine frontier item):
   - Over I∖Δ: S = X∩T_xX nodal at x = ℓ_1∩ℓ_2; the six lines through x
     are exactly the lines of S through the node. Both ℓ, ℓ' pass through
     the node; each generates the local class group Cl(A_1) = Z/2
     nontrivially, so the DIFFERENCE ℓ'−ℓ is locally trivial: ℒ stays a
     line bundle over I∖(deeper strata). The total space 𝒮 is smooth
     there (the node unfolds versally along the I-transverse direction),
     and GRR needs only lci, which a divisor in smooth X×B always is. So
     the generic-I behavior needs NO correction.
   - Over the deeper stratum — pairs meeting at a relatively-parabolic
     point, which is exactly the pass-7 residual surface R (fiber degree
     4 on each C_ℓ) — the fiber singularity is A_2 with Cl = Z/3, the
     local line classes live in odd-order groups, and a reflexive-hull
     discrepancy there is 3-primary: 3 ≡ 1 mod 2, NOT parity-invisible.
     The correction classes are supported on X×R and can carry (3,5)-legs
     through j_{R*}H^1(R̃). Resolution options, in preference order:
     (a) add gate condition (iv): ∫_B T''·j_{R*}(η) ≡ 0 for all η — i.e.
     T''|_R ≡ 0 mod 2 (needs only the restriction-pairing against R, not
     the full [R]-excess theory); (b) compute the A_2-discrepancy class
     explicitly (heavy). This is the main mathematical risk of the pass;
     the certificate is not trusted until (a) or (b) is in place, and R's
     geometry (class, normalization, H^1) enters the story for the first
     time — the pass-7 "excess is even" shortcut does NOT cover it.

## 3b. Post-extraction refinements (2026-08-11, after item E landed)

- [P] = 1⊗[line] + Ξ + C_s⊗H + 6[pt]_F⊗1 on F×X; (3,1) = 0 since
  H^1(X,Z) = 0; the cylinder map is an ANTI-isometry (CG (11.4)+(13.2)) —
  carry the sign.
- **ℒ is non-Cartier along the node section T** (Krull height: Z∩Z' = T
  has dim 3, impossible for Cartier divisors on the 6-fold 𝒮; conifold-
  type total-space geometry; the earlier fiberwise Cl(A_1) = Z/2 argument
  used the wrong local model). Consequences: (a) the naive
  D = [Z']−[Z]-calculus needs a T-supported ch-correction; (b) its leading
  term is m_T·[T] with [T] = [Z]·[Z'] (proper ambient intersection,
  generically transverse), and the (3,5)-part of [Z][Z'] is EVEN: every
  (3,5)-term contains exactly one Ξ (only X-degree-3 class available,
  H^1(X) = 0), and [P]'s X-degree-0 components all carry coefficient 6.
  So the conifold correction is parity-dead at leading order regardless
  of m_T; deeper-supported corrections fall under the R-gate (§3.4).
- **Death-rule changes vs pass 7**: the readout pairs B-legs against T''
  directly (no a_*), so C_s-legs are NOT auto-dead here. Surviving
  odd-capable (3,5)-terms after the Frobenius/deg-6 sweeps: the
  Z²-normal-bundle correction terms of shape
  Ξ · (c_1-legs of N_{P/X×F}, odd C_s-coefficients from c_1(T_F) = −3C_s)
  · (one P-cross from an S̄ = (H+G)-factor) — one tensor of each support,
  all coefficients odd-capable. λ rides on the exact integer contraction
  of these; not hand-decidable. This is where the certificate earns its
  keep.
- Mutation action on H^3(X)-legs: clean literature negative (extraction
  item F); derive only if λ_𝒢 = 0 must transfer to the ℰ-model.

## 4. Controls for the eventual certificate

ψ_*(1) = 6Θ; fiberwise ch = (0,H,−H²/2,−H³/6); t-independence mod 2;
N ≡ λS (rigidity pin); gate-A consistency (the chosen T'' re-verified);
the pass-7 all-even sweep reproduced by setting the cylinder tensor to zero
(ablation: the unit tensor is the only odd hope — with it removed the
computation must collapse to even).
