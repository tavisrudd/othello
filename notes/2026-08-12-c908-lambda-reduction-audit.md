# C908 hostile proof audit: the λ-reduction theorem and swap-duality control

Date: 2026-08-12. Auditor: Fable sub-agent (adversarial pass, same stance and
severity taxonomy as `notes/2026-08-12-c908-h3-lattice-proof-audit.md`:
FATAL / GAP / NIT, with independent re-derivations inline).

Target: `notes/2026-08-12-c908-lambda-reduction-and-verdict.md` §§1–3, and the
four audit obligations its §7 names. Context read in full: the pass-8 spec
(`2026-08-12-c908-lambda-leg-spec.md`), pass 9
(`2026-08-12-c908-h3-lattice-adjudication.md`), pass 9b
(`2026-08-12-c908-h3-compression.md`), and the prior audit.

Status: COMPLETE. Follow-up 2026-08-12: the G1–G3 repairs and NITs N1–N3
were applied to the target note in place (its §1–§3 proofs, §6 ledger, §7
audit status); the target's reduction-audit-pending flag is cleared.

## Verdict (up front)

- **The reduction theorem (§2) STANDS, but not by the proof as written.** The
  written proof's central step — "`δ_4` is a Z-linear combination of
  codimension-4 cycle classes (the leading ch-term of a K-theory class
  supported in codimension four…)" — is unjustified: the naive model `m` is a
  formal cohomological expression, never exhibited as `ch` of any K-theory
  class, so the quoted (true) K-theory principle does not apply to
  `δ = ch(𝒢) − m`. Support alone gives only **rational** codimension-4
  coefficients, and a coefficient with denominator 4 would make `−6δ_4` pair
  oddly. This is Finding G1 (GAP, load-bearing). A complete repair is supplied
  in this audit (integral `c_4`-difference + componentwise even pairing); with
  it the theorem's conclusion `N ≡ M (mod 2)` is proved without ever deciding
  the integrality of `δ_4`.
- **The swap-duality control identity (§3) STANDS as written.** Every sign,
  shift, and coefficient was independently re-derived and confirmed: the
  Grothendieck-duality K-class shape `[RHom(𝒢,O)] = −[ι_*(ℒ^{[-1]}(S))] +
  [defect]`, `ch^∨ = Σ(−1)^k ch_k`, the change-of-variables sign
  `∫c_4(σ^*𝒢)·(x⊗T) = −N`, and the degree-four coefficients
  `37/12, 6, 1, 10` (with the `h_4`-terms cancelling exactly, as the design
  requires). Here — unlike §2 — the defect IS an authentic K-class (a
  difference of genuinely defined derived objects), so `K_4`-integrality is
  sound. One NIT: the "even ambiguity of `δ_4`-terms" clause is vacuous.
- **Lemma 1's conclusion stands**; its proof of the support claims is
  under-specified (Finding G3, repair supplied: the sheaf-agreement-off-locus
  statement, the polynomial cross-term argument for `c_4`-differences, and a
  restatement of the `(1×q)`-clause, which as written appeals to "where `q`
  fails to be an isomorphism" although `q` is nowhere an isomorphism).
- **Counts: 0 FATAL, 3 GAP (one major, two minor), 3 NIT.**
- Obligation closure: §7-obligation 1 SETTLED-WITH-REPAIR, obligation 2
  SETTLED-WITH-REPAIR, obligation 3 SETTLED-SOUND, obligation 4
  SETTLED-WITH-REPAIR. Details in the closing section.

With the supplied repairs, and given the already-committed certificate, the
verdict `λ = 0` for the span-model family survives this audit. The
reduction-audit-pending flag of the target's §7 can be cleared once the
repairs of G1–G3 are folded into the note.

---

## A. Independent re-derivations

### A.1 The Newton expression and the −6 multiplier (confirmed)

For a K-class with Chern roots' power sums `p_k = k!·h_k` (`h_k = ch_k`),
`h_0 = 0`, `h_1 = S`, Newton's identities give `e_1 = S`,
`e_2 = (e_1p_1 − p_2)/2 = S²/2 − h_2`,
`e_3 = (p_3 − e_1p_2 + e_2p_1)/3 = S³/6 − S h_2 + 2h_3`, and

```
4e_4 = e_1p_3 − e_2p_2 + e_3p_1 − p_4
     = 6S h_3 − (S²/2 − h_2)(2h_2) + (S³/6 − S h_2 + 2h_3)S − 24h_4
     = S⁴/6 − 2S²h_2 + 2h_2² + 8S h_3 − 24h_4,
```

so `c_4 = (1/24)[S⁴ − 12S²h_2 + 12h_2² + 48S h_3 − 144h_4]` — exactly the
note's display; the `ch_4`-multiplier is `−144/24 = −6`, even. Sanity test on
the rank-zero class `[O] − [L^{−1}]` (`h_k = −(−S)^k/k!`, true `c = 1/(1−S)`):
the formula returns `(1/24)[1+6+3+8+6]S⁴ = S⁴` ✓.

Substitution `h_k → m_k`: `c_4` is a polynomial in `h_1,…,h_4` in which `h_4`
enters only linearly with coefficient `−6`; with `δ_1 = 0` (see NIT N2:
`ch_1(𝒢) = S = m_1` exactly, both being the support divisor with generic
multiplicity one) and `δ_2 = δ_3 = 0`, the change is exactly `−6δ_4`, no cross
terms. Confirmed.

### A.2 The duality identity: shape, signs, and the 37/12–6–1–10 coefficients (confirmed)

**K-shape.** `𝒮 ⊂ A` is a hypersurface in a smooth variety, hence Gorenstein
with `ι^!O_A = ω_{𝒮/A}[−1] = O_𝒮(S)[−1]`. Grothendieck duality:
`RHom_A(ι_*ℒ, O_A) ≅ ι_*RHom_𝒮(ℒ, O_𝒮(S))[−1]`. Where `ℒ` is a line bundle
this is `ι_*(ℒ^{−1}(S))[−1]`, K-class `−[ι_*(ℒ^{−1}(S))]`; globally
`RHom_𝒮(ℒ,O_𝒮(S))` has `H^0 = ℒ^{[-1]}(S)` (sheaf dual; `𝒮` is normal —
hypersurface, singular in codim ≥ 2 — so the reflexive inverse is the sheaf
Hom) and `H^{i≥1} = Ext^i_𝒮(ℒ,O)(S)` supported on the non-Cartier locus. So
`[RHom_A(𝒢,O_A)] = −[ι_*(ℒ^{[-1]}(S))] + [defect]`,
`[defect] = Σ_{i≥1}(−1)^{i−1}[ι_*(Ext^i(ℒ,O_𝒮)(S))]` — an authentic K-class
supported on the non-Cartier locus. Confirmed, including the sign from the
`[−1]`-shift. Note the contrast with §2: HERE the defect is a difference of
genuinely defined objects, so the "leading term = support cycle with integer
lengths" principle (obligation 1's statement) legitimately applies to it, and
`K_4` is an integral codimension-4 cycle class; its pairing with the integral
test is an integer. `6∫K_4·(x⊗T_a) ∈ 6Z` is sound.

**σ-side.** `σ` preserves `𝒮` (the span divisor is symmetric; `G` is
σ-invariant since `(−1)^*Θ = Θ`), `σ(Z) = Z'`, and at `t = 0`
`σ^*ℒ ≅ O_𝒮(Z−Z') = ℒ^{[-1]}` as reflexive sheaves (divisorial sheaves on a
normal variety depend only on the Weil class). `σ^*𝒢 = ι_*(σ^*ℒ)` by
equivariance. Then, with `ι_*(ℒ^{[-1]}(S)) ⊗ O_A(−S) = ι_*(ℒ^{[-1]})`
(projection formula) and `ch(dual) = ch^∨` (valid: `𝒢` is perfect on smooth
`A`):

`ch(σ^*𝒢) = e^{−S}·ch(ι_*(ℒ^{[-1]}(S))) = e^{−S}(−ch^∨(𝒢) + K)` ✓.

**Degreewise.** `−ch^∨ = (0, S, −h_2, h_3, −h_4)`; multiplying by `e^{−S}`:
`h'_1 = S` ✓; `h'_2 = −h_2 − S²` ✓ (independently re-checked against direct
GRR for `ℒ^{−1}` on the Cartier locus: both give `−ι_*D − S²/2`);
`h'_3 = h_3 + S h_2 + S³/2`;
`h'_4 = −h_4 + K_4 − S h_3 − S²h_2/2 − S⁴/6`.

**Degree four.** Newton on the primed class (`h'_1 = S`):

```
24·c_4(σ^*𝒢) = S⁴ − 12S²h'_2 + 12h'_2² + 48S h'_3 − 144h'_4
  = (1+12+12+24+24)S⁴ + (12+24+48+72)S²h_2 + 12h_2² + (48+144)S h_3
    + 144h_4 − 144K_4
  = 73S⁴ + 156S²h_2 + 12h_2² + 192S h_3 + 144h_4 − 144K_4 .
```

Adding `24·c_4(𝒢) = S⁴ − 12S²h_2 + 12h_2² + 48S h_3 − 144h_4`:

`c_4(σ^*𝒢) + c_4(𝒢) = (37/12)S⁴ + 6S²h_2 + h_2² + 10S h_3 − 6K_4`,

the `h_4`-terms cancelling identically (so the control is `ch_4`-free — the
design requirement — and `δ_4` never enters it; see NIT N1). Toy check with
`𝒢 = [O_A]−[O_A(−S)]`, `σ = id`, `K = 0`: LHS `= 2S⁴`; RHS
`(37/12 − 3 + 1/4 + 5/3)S⁴ = 2S⁴` ✓.

**Change-of-variables sign.** `σ` is a holomorphic automorphism of `A`
(orientation-preserving), `σ² = id`, so `∫σ^*u·v = ∫u·σ^*v`. It fixes the
`X`-factor: `σ^*(p_X^*x·p_B^*T) = p_X^*x·p_B^*(σ_B^*T) = −(x⊗T)` for a pure
test (no Künneth sign: `deg x·deg 1 = 0` interchange; the minus is solely
`σ_B^*T = −T`). Hence
`∫c_4(σ^*𝒢)(x⊗T) = ∫σ^*(c_4(𝒢))·(x⊗T) = ∫c_4(𝒢)·σ^*(x⊗T) = −N` ✓ — the
sign the note uses, verified. Pairing the displayed sum against `x⊗T_a` and
using this gives `0 = LHS − 6∫K_4(x⊗T_a)`… i.e. exactly the note's displayed
identity `∫[(37/12)S⁴ + 6S²h_2 + h_2² + 10S h_3]·(x⊗T_a) = 6∫K_4·(x⊗T_a)`.
All four coefficients confirmed.

### A.3 Test integrality and pure-test properties (confirmed)

`T_{a_k}` are integer combinations of `β_m⊗1 − 1⊗β_m` (compression note §2,
`det c = 1`, a Z-basis of the swap-antisymmetric sublattice; coefficients in
the committed json), so `x⊗T_{a_k}` is an integral class — the hypothesis
"even integral class pairs into 2Z" is available. `i_Δ^*(β⊗1 − 1⊗β) = 0`
integrally and `σ^*(β⊗1 − 1⊗β) = −(β⊗1 − 1⊗β)` (Künneth interchange sign
`(−1)^{3·0} = +1`), so both pure-test properties hold exactly, not just mod 2.

---

## B. Findings

### Finding G1 (GAP, major, load-bearing). §2: the integrality of `δ_4` is unproven — the naive model is not a K-class, so the quoted K-theory principle does not apply

**The broken step.** The proof of the reduction theorem argues: off the
non-Cartier locus GRR holds, "so `δ_k := ch_k(𝒢) − m_k` is represented by
classes supported in codimension ≥ 4: `δ_2 = δ_3 = 0`, and `δ_4` is a
Z-linear combination of codimension-4 cycle classes (the leading ch-term of a
K-theory class supported in codimension four is its support cycle with
integer generic lengths)."

**What is true.** The parenthetical principle is a correct theorem about
K-classes: for a class in the image of `G_0(W) → G_0(A)` (`A` smooth,
`codim W ≥ c`), `ch_j = 0` for `j < c` in `H^{2j}(A,Q)` and `ch_c` is the
support cycle with integer multiplicities — Riemann–Roch for torsion sheaves
(Fulton, *Intersection Theory*, §18.3 and Ex. 18.3.11 / SGA6; via
`ch(F)·td(A) = cycle class of τ(F)` with `τ(F)` concentrated in dimensions
`≤ dim supp F` and leading term the support cycle, `td` invertible with
constant term 1; a virtual class is an integer combination of such). Also
sound is the support half: `δ|_U = 0` for `U = A∖W` gives, via the exact
sequence `H^{2k}_W(A,Q) → H^{2k}(A,Q) → H^{2k}(U,Q)` and
`H^{2k}_W(A,Q) ≅ H^{BM}_{14−2k}(W,Q) = 0` for `2k < 8` (`dim_R W ≤ 6`),
exactly `δ_2 = δ_3 = 0`, and `δ_4 ∈` Q-span of the dim-3 components of `W`.

**What is not proved.** The principle's hypothesis. `δ = ch(𝒢) − m` where
`m = ι_*(e^D·td(O(S))^{−1})` is a formal cohomological expression — `D`-powers
interpreted through the certificate's ambient surrogate rules (`Z·Z'` as a
proper ambient intersection, `Z²` through `N_{P/X×F}`, …) — because `ℒ` is
NOT a line bundle and no sheaf, complex, or K-class with Chern character `m`
is exhibited anywhere. So `δ` is a rational cohomology class supported on
`W`, and nothing more: `δ_4 = Σ q_i [W_i]` with `q_i ∈ Q`. The integrality of
the `q_i` is precisely the content the K-theory principle was supposed to
supply, and it is not available. This is cycle-level reasoning passed off as
K-theory — the exact failure mode this audit was asked to hunt.

**Why it is load-bearing.** `N − M = −6∫δ_4·(x⊗T_a)`. Evenness needs
`6q_i·∫[W_i]·test ∈ 2Z`. If some `q_i` had denominator 4 (a priori possible:
`ch`- and `td`-expansions in degree 4 carry denominators up to 24, and the
difference of two such expressions supported on `W` has no automatic
integrality), the conclusion fails. Nothing in the note bounds the
denominators. An attempted local repair by computing the generic transverse
defect at the node section (a 3-fold ordinary double point with the Weil
divisor difference `Z'−Z`, which locally generates twice the class group) is
a genuine conifold computation the note does not perform; the audit did not
find a way to force `q ∈ Z` from support alone, and does not believe one
exists.

**The repair (complete, and cheap).** Bypass `δ_4`-integrality entirely.

1. *The `c_4`-difference is integral.* Both `c_4(𝒢)` (Chern class of a
   coherent sheaf on smooth `A`) and `c_4^{main}` (certified integral by the
   main-term certificate — "only the total is asserted integral", target §4.2;
   structurally guaranteeable by Riemann–Roch sans dénominateurs, Jouanolou /
   Fulton §15.3, per compression note §4.1) are integral classes. Hence
   `δc := c_4(𝒢) − c_4^{main}` is an **integral** class, and by A.1,
   `δc = −6δ_4` rationally.
2. *`δc` is supported on `W`, integrally.* On `U = A∖W`: `ℒ|_U` is a line
   bundle on the divisor `𝒮∩U` (an lci, hence regular, embedding — no
   smoothness of `𝒮` needed), so Riemann–Roch sans dénominateurs gives
   `c_4(𝒢)|_U` as the universal integer polynomial `P_4(S, D)`; the
   Newton-assembled `c_4^{main}` restricts to the same universal expression
   (two universal polynomials in `(S,D)` agreeing on all line-bundle
   instances agree formally), provided the certificate's ambient surrogate
   representatives of `ι_*(D^k)` restrict on `U` to the intrinsic classes —
   true for the stated rules (`Z·Z'` is supported on `Z∩Z' ⊂ W`, restricting
   to 0 on `U`, matching `Z∩Z'∩U = ∅`; the normal-bundle rule for `Z²` is
   the standard self-intersection formula, valid where `Z` is Cartier on
   `𝒮`), but this restriction-compatibility must be STATED (it is needed by
   the note's own route too). Then `δc|_U = 0` in `H^8(U,Z)`, so
   `δc ∈ im(H^8_W(A,Z) → H^8(A,Z))`, and `H^8_W(A,Z) ≅ H^{BM}_6(W,Z) =
   ⊕_i Z·[W_i]` — free on the dim-3 components, integrally, no torsion in the
   top degree. Hence `δc = Σ n_i[W_i]` with `n_i ∈ Z`.
3. *Componentwise even pairing.* The dim-3 components of `W` are: the node
   section `T_I` over `I∖Δ` (closure), any components inside `X×Δ` (see
   Finding G2), and nothing else (the deep strata over `R` have dim ≤ 2 and
   contribute no `H^{BM}_6`). Components inside `X×Δ` pair to zero EXACTLY
   against `x⊗T_a` (Lemma 1(1), which needs no integrality — the pairing is
   zero on the nose). For `T_I`: pass-8 §3b's Künneth-parity argument gives
   `∫[Z]·[Z']·(x⊗T_a) ∈ 2Z` — the (3,5)-part of `[Z][Z']` consists of
   `Ξ × (X-degree-0)`-terms only (X-degrees available in
   `[P] = 1⊗[line] + Ξ + C_s⊗H + 6[pt]_F⊗1` are `{4,3,2,0}`; `3 = 3+0`
   forces one `Ξ` and one X-degree-0 factor, whose coefficient is 6) — and
   `[Z][Z'] = [T_I] + (X×Δ-supported)`, the latter pairing to zero, so
   `∫[T_I]·(x⊗T_a) ∈ 2Z`. (This needs multiplicity one of `Z·Z'` along
   `T_I` — generic transversality, dimensionally expected `5+5−7 = 3` ✓,
   asserted in pass-8 §3b; a one-line generic tangent-space check should
   accompany it. Note the repair is insensitive to the multiplicity along
   the `Δ`-components.)
4. Then `N − M = ∫δc·(x⊗T_a) = n_{T_I}·(even) + 0 ∈ 2Z`. ∎

The repair proves `N ≡ M (mod 2)` — the theorem as stated — while leaving
the integrality of `δ_4` itself OPEN (all the argument shows is
`δ_4 = −δc/6 ∈ (1/6)·H^8(A,Z)` on the dim-3 components). Consequences for
the note's prose: the sub-claim "`δ_4` is a Z-linear combination of
codimension-4 cycle classes" should be withdrawn or re-labelled as
unproven; the §2 closing "general mechanism" paragraph and the §6 ledger
item ("codimension-four sheaf defects can never affect a mod-two
`c_4`-readout … reusable wherever the corpus reads `c_4` mod 2") are true
for authentic K-class perturbations but, as a portable slogan covering
naive-model comparisons like this one, inherit the gap and should carry the
repair's actual hypotheses (integral main term + componentwise even pairing
of the support cycles).

Severity: **GAP** (major). Not FATAL: the theorem's statement survives, with
the complete repair above; but the proof as written does not establish it.

### Finding G2 (GAP, minor). §2: the non-Cartier/support locus is misidentified — `Z∩Z'` has a second three-dimensional component over `Δ`, omitted from `W`

The note (following pass-8 §3b) writes `T = Z∩Z'` and calls it the node
section over `I`, dim 3; the reduction proof takes the non-Cartier locus to
be "the node section `T` … plus deeper strata over `R`". But set-theoretically

`Z∩Z' = {(x,ℓ₁,ℓ₂) : x ∈ ℓ₁∩ℓ₂} = T_I ∪ T_Δ`,
`T_I = {(x,ℓ₁,ℓ₂) : (ℓ₁,ℓ₂) ∈ I∖Δ, x = ℓ₁∩ℓ₂}` (dim 3) and
`T_Δ = {(x,ℓ,ℓ) : x ∈ ℓ}` (dim `2+1 = 3`) — TWO dim-3 components. The
Krull-height argument the corpus itself uses ("`Z∩Z'` of dim 3 is impossible
for two Cartier divisors on the 6-fold `𝒮`": two locally principal ideals
cut height ≤ 2) applies verbatim along `T_Δ`: `Z` and `Z'` cannot both be
Cartier there either, and in fact `𝒮` must be singular along `T_Δ` (on a
smooth variety two distinct prime divisors meet in codim ≤ 2). So either
`ℒ = O_𝒮(Z'−Z+tG)` happens to be locally principal along `T_Δ` (not shown,
and the geometry of `𝒮` over `Δ` — the closure of the span family, whose
`Δ`-fibers are degenerate and possibly of excess dimension — is nowhere
pinned down in the corpus), or `W` has a third dim-3 component the proof's
support statement omits.

**Why it is only minor.** `T_Δ ⊂ X×Δ`, and Lemma 1(1) kills every
`X×Δ`-supported class exactly against a pure test (`i_Δ^*T_a = 0`
integrally); the repair in G1 step 3 already routes all `Δ`-components
through that kill, with no integrality or multiplicity input. So the
theorem is unaffected. But the note must either prove `ℒ` is Cartier along
`T_Δ` or (simpler, one line) enlarge `W` by the `Δ`-components and cite
Lemma 1(1). Relatedly, pass-8 §3b's "`[T] = [Z]·[Z']` (proper ambient
intersection, generically transverse)" conflates the two components; as an
equation about the node section it is wrong as stated (the product also
carries the `T_Δ`-term), though every USE of it in the audited chain pairs
against pure tests, where the discrepancy vanishes.

Severity: **GAP** (minor; one-paragraph repair, supplied).

### Finding G3 (GAP, minor). Lemma 1(2): the support claims and the `(1×q)`-clause are under-specified; the needed arguments are supplied here

Lemma 1(1) is sound as displayed (see A.3 and the projection-formula checks:
`∫ j_{Δ*}γ·(x⊗T) = ∫γ·(x⊗i_Δ^*T) = 0` for ANY `γ` — integral, rational, or
torsion — and on `X×E`, `e_E^*μ^*T = π_E^*i_Δ^*T = 0` using
`μ∘e_E = i_Δ∘π_E`, which pass 9 §2.3 establishes). Three holes in (2):

1. **The sheaf-agreement input is tacit.** "Each comparison differs by
   classes supported on the loci of (1)" needs, as its first input: the
   actual family on `X×Y` and the span model pulled along `1×μ` (resp. the
   μ-pushforward and the model on `X×B`) are canonically isomorphic off
   `X×E` (resp. `X×Δ`). That is true by construction — both restrict to the
   same span construction over `B∖Δ ≅ Y∖E` — but it is a statement about the
   families, used and never stated. It should be displayed as a hypothesis
   discharged by the construction.
2. **"Differs by supported classes" at the `c_4`-level needs the cross-term
   argument.** `c_4` is not additive. The correct statement: if two K-classes
   agree on the complement of a closed `V`, their ch's differ by classes
   supported on `V` (ch commutes with open restriction), and `c_4` of each is
   the same polynomial in `ch_{1..4}`; expanding, every difference term
   contains at least one supported factor, and (supported)·(anything) is
   supported (`j_*u·v = j_*(u·j^*v)`). Hence `c_4`-difference supported on
   `V` — note `V = X×E` is a DIVISOR, so the difference has terms in every
   degree and the cross-term argument, not a codimension bound, is what
   carries the claim. With (1), the difference pairs to zero exactly. This
   paragraph is missing from the note; without it "differs by classes
   supported on" is a cycle-level gesture.
3. **The `(1×q)`-clause is mis-argued.** The proof attributes all three
   agreements to "the loci … where `q` and `μ` fail to be isomorphisms" —
   but `q` is generically 6:1 and fails to be an isomorphism EVERYWHERE, so
   for the `q`-leg the quoted mechanism is vacuous. The span family does not
   descend along `q` (`ℒ` is swap-antisymmetric while the deck action of the
   degree-six model swaps `Z ↔ Z'`), so no supported-difference comparison on
   `X×M` exists. What is true, and what the pass-9b tests were engineered
   for, is a TEST-side projection-formula identity: for any family pulled
   back from `X×M`, `∫_{X×Y}c_4((1×q)^*𝒰)·(x⊗μ^*T) =
   ∫_{X×M}c_4(𝒰)·(x⊗q_*μ^*T) = ∫ c_4(𝒰)·(x⊗b^*(Θ∧a))`; for the span-model
   family itself (the scope of the verdict), the downstairs readout is
   DEFINED through this transfer, and the mathematical content of Lemma 1(2)
   is the `μ`-leg alone: `∫_{X×Y}c_4(𝒢_Y)·(x⊗μ^*T) =
   ∫_{X×B}(1×μ)_*c_4(𝒢_Y)·(x⊗T)` (projection formula, exact) plus
   `(1×μ)_*c_4(𝒢_Y) − c_4(𝒢)` supported on `X×Δ` (items 1–2). The clause
   should be restated accordingly; as written it claims a support argument
   in a place where none can exist.

Also answering the audit brief's question: the "supported on" statements do
NOT need K-theoretic integrality at the `ch_4` level — the pure tests
annihilate supported classes exactly, so rational coefficients suffice
throughout Lemma 1. (The integrality pressure lives only in §2, Finding G1.)

Severity: **GAP** (minor; conclusions stand, repairs supplied above).

### Finding N1 (NIT). §3: "up to the even ambiguity of `δ_4`-terms" is vacuous

The control's left side `(37/12)S⁴ + 6S²h_2 + h_2² + 10S h_3` contains no
`h_4` (the `h_4`-terms cancel in `c_4(σ^*𝒢) + c_4(𝒢)`, see A.2), and
`δ_2 = δ_3 = 0` exactly (sound, by the support/local-cohomology argument of
G1's "what is true" paragraph). So substituting `h_k → m_k` changes the left
side by NOTHING: the divisibility-by-six control is exact, with no
`δ_4`-ambiguity of any parity. The clause should be deleted — it currently
suggests the control is weaker than it is, and it invokes the very
`δ_4`-integrality that Finding G1 shows unproven.

### Finding N2 (NIT). §2: `δ_1 = 0` is used but never stated

The no-cross-terms claim ("replacing `h_k` by `m_k` changes `c_4` by
`−6δ_4`") needs `m_1 = h_1` as well as `δ_2 = δ_3 = 0`. True and immediate —
`ch_1(𝒢) = [𝒮]·(generic rank of ℒ) = S = ι_*(1) = m_1`, both exactly — but
the note's list starts at `δ_2`. One clause.

### Finding N3 (NIT). §3 scope: the control identity is derived at `t = 0` only

`σ^*ℒ ≅ ℒ^{[-1]}` uses `t = 0` ("take `t = 0`", correctly flagged), so the
§3 identity constrains the `t = 0` specialization of the certificate's
inventory, while §§2, 4 carry `t` symbolically. Harmless (a control, not a
step in the reduction), but the certificate-facing sentence should say the
divisibility check binds at `t = 0` (for `t ≠ 0`, `σ^*ℒ ≅ ℒ^{[-1]}(2t·ι^*G)`
would add explicit `G`-twist terms to the identity, not currently displayed).

---

## C. Obligation-by-obligation closure (target note §7)

**Obligation 1 — integrality of `δ_4` for K-classes supported in codim ≥ 4:
SETTLED-WITH-REPAIR.** The abstract principle is TRUE in the generality of
K-classes: for `ε ∈ im(G_0(W) → G_0(A))`, `codim W ≥ 4`, `ch_j(ε) = 0` for
`j < 4` and `ch_4(ε)` is the integral support cycle (Fulton §18.3 /
Ex. 18.3.11; contributions beyond the leading term exist but sit in degree
> 4 and are irrelevant to `c_4`; components of codim > 4 contribute nothing
to `ch_4`; the class lands in the image of `H^8(A,Z)`, and torsion ambiguity
is invisible to the top-degree pairing). BUT the hypothesis fails in the
generality actually used in §2: `δ` is not shown to be such an `ε` (Finding
G1), so `δ_4`-integrality is unproven there and the theorem is re-proved by
the G1 repair instead. Where the principle IS legitimately invoked — the
duality defect `K` of §3, an authentic K-class — it applies soundly.

**Obligation 2 — the localization step: SETTLED-WITH-REPAIR.** The clean and
correct content: `δ|_U = 0` (GRR sans dénominateurs for the lci divisor
embedding on `U`, where `ℒ` is a line bundle — no smoothness of `𝒮` needed —
plus restriction-compatibility of the ambient surrogate representatives,
which must be stated); then the support long exact sequence gives
`δ_2 = δ_3 = 0` exactly and `δ_4` supported on the dim-3 components of `W`.
There is no legitimate "on the nose" K-theory comparison — the naive model
is not a K-class, so the comparison lives only in cohomology after
restriction/excision, which suffices for the vanishing but NOT for
integrality (Finding G1). The claimed support set is additionally incomplete
(`T_Δ` omitted, Finding G2); with `W` enlarged and the G1 repair, the step
closes.

**Obligation 3 — K-theory sign and shape of the duality identity:
SETTLED-SOUND.** All checked independently and confirmed (A.2): the
Grothendieck-duality shift and sign, the reflexive-dual identification on
normal `𝒮`, the defect as an authentic K-class supported on the non-Cartier
locus (integrality of `K_4` legitimate here), `ch^∨`, the degree-2
cross-check, the degree-4 coefficients `37/12, 6, 1, 10` (with `h_4`
cancelling), and the change-of-variables sign `∫c_4(σ^*𝒢)(x⊗T) = −N` (`σ`
orientation-preserving; `σ^*(x⊗T) = x⊗σ_B^*T = −x⊗T`, no hidden Künneth
sign). Residual notes: N1 (vacuous ambiguity clause), N3 (`t = 0` scope) —
NITs only.

**Obligation 4 — Lemma 1's support claims: SETTLED-WITH-REPAIR.** The
pairing computations are exact and integral as displayed; the support claims
need the sheaf-agreement statement and the polynomial cross-term argument,
and the `(1×q)`-clause must be restated as a test-side projection-formula /
definitional step (Finding G3, repairs supplied). No K-theoretic integrality
is needed anywhere in Lemma 1 — pure tests kill supported classes exactly.

## D. Consequences for the verdict chain

1. The reduction theorem `N ≡ M (mod 2)` stands, via the G1 repair; its
   published proof should be rewritten to the repair's shape (integral
   `c_4`-difference; `H^{BM}_6(W,Z)` free on components; `T_I` pairs evenly
   by the pass-8 §3b Künneth-parity mechanism, promoted to a lemma with the
   multiplicity-one tangent check; `Δ`-components killed by Lemma 1(1)).
2. The control identity stands as written and is exact (N1), strengthening
   it: any certificate failure of divisibility-by-six at `t = 0` would be a
   genuine contradiction, not `δ_4`-slack.
3. The λ = 0 verdict for the span-model family remains
   certificate-conditional in exactly the sense the target already declares,
   and is no longer reduction-audit-pending once G1–G3 and N1–N3 are folded
   in. Nothing found here touches the certificate's arithmetic itself.
4. The §6 ledger's portable slogan ("codim-4 sheaf defects never affect a
   mod-two `c_4`-readout") must be re-scoped before corpus reuse: it is a
   theorem for authentic K-class defects, and for naive-model comparisons it
   additionally needs an integral main term plus componentwise even pairing
   of the support cycles (the two repair hypotheses).
