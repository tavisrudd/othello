# C913 cold read, round 4 — gauged transport, one-chart appendix, scope item (5)

**Date**: 2026-08-15
**Manuscript**: `papers/cubic-stabilization-irrationality/`, frozen at `8bdc3a890`
**Reader**: independent referee, no prior involvement with this text

---

## 1. Scope and method

### What I read

Read in full and judged:

- `sections/08-global-transport.tex`, all 1362 lines. The primary scope was lines 1–904 (from the
  start of the section through the end of the proof of `prop:clutching-tail-holonomicity`); I also
  read and judged the remainder (lines 905–1362), which was the secondary scope.
- `sections/appendix-one-chart.tex`, all 785 lines.
- `sections/08-scope.tex`, item (5) in detail and the other items for context.
- `sections/01-introduction.tex`, the paragraph beginning "The conditional proof uses a smooth
  projective equivariant completion" (lines 110–135), plus the two paragraphs after it.
- `sections/02-point-row.tex` in full, for the Gamma-framed section `s_Y(E)`, the twisted pairing
  `[·,·)`, and the point row `\rrow_{Y,p}`.

### What I recomputed independently

Nothing below was accepted because it looked standard.

- **Mumford's numerical criterion in fibre-weight form** (`eq:gm-weight-criterion`), re-derived from
  the weight decomposition of a lift in `P(V)`: limits, the weight `-k` of the `O(1)` fibre at
  `[v_k]`, and the semistability condition `k_min ≤ 0 ≤ k_max`.
- **Every inequality in `lem:orbit-cylinder-disjoint`**: affineness of `μ_u` in `u`, positivity of
  `μ_u(w_0)` on `[0,1]`, the fixed-component vanishing, the Poincaré-dual restriction arguments in
  (c), and the closedness of `O` in `W^ss(L_±)` that (c) needs to make `PD[O]` a point class.
- **The Gamma index identity `eq:gamma-index-factor`** on both degree rays, including the claim that
  the `H^1` Euler class on the `n<0` ray is a product of exactly `|n_a|-1` factors.
- **`eq:adjacent-gamma-ratio`** and **`eq:simple-gamma-residue`** (residue in `σ`, Jacobian `1/h`).
- **The Stirling expansion of `log|c_k|`** in `prop:clutching-tail-holonomicity`, term by term, on
  both rays, including the `ζ`-scale term and the treatment of roots with `h_a = 0`.
- **The distributional boundary-value argument**: the choice `q > N+2`, absolute convergence of
  `∑ b_k` with a `(log k)^M` factor present, uniform convergence for `r ≤ 1`, recovery by
  `∂_θ^q`, and the order bound.
- **`χ(O(n)) = n+1` bookkeeping** behind `eq:total-moving-slope`, and `c_1(T(W/\Gm)) = c_1^{\Gm}(TW)`.
- **`ch(O_p) = [pt]`** and the action of `z^{-μ}`, `z^{c_1}`, `\hat Γ`, `(2πi)^{deg/2}` on the top
  class, i.e. the scalar `c_n(z)` of `lem:point-insertion-row`.
- **The graded-extension computation** of `lem:app-graded-extension`, the attractor algebra
  `A/(A_w : aw < 0)`, and the identification of `Spec A_0` with the fixed locus of the chart.
- **The tangent-weight sign flip** in `lem:app-cech`, checked by an explicit computation on
  `W = A^1` with `t·y = t^k y`: the invariant section is `z^{ak}∂_y`, regular exactly when
  `aw ≤ 0` for `w = -k`. This confirms both the `-aw` exponent and the `F_{≤0}` convention.
- **The `P^1` chart-dependence counterexample** in `prop:app-one-chart`.
- **The `Bl_p P^2` calibration arithmetic** in `rem:verification-status`: the two chamber maps
  `(x,y) ↦ (H,0)` and `(x,y) ↦ (H-E,E)` are consistent with the Stanley–Reisner relations of both
  chambers, and `x(x+y)` is the point class in both.
- **`lem:cyclic-row-support`** (Bézout projector argument) and the Neumann-series surjectivity
  argument in "The finite cyclic packet".

### Sources checked at the locator

All from the disk cache `/tmp/persistent/tavis/lit-search/` (text extractions are pdftotext
reconstructions; where the reading was delicate I state the control I used).

| Locator in manuscript | Source key | Verdict |
|---|---|---|
| `[Prop. 2(B')]{Wlodarczyk}` | `arXiv:math/9904074` | Supports. B' is the smooth projective cobordism; its proof is "equivariant projective completion, then canonical equivariant resolution"; `B_±/K^* ≅ X', X` for punctured line-bundle opens. |
| Włodarczyk terminology remark | same | Supports. "Definition 5. A cobordism `B` is projective if `B` is a quasiprojective variety." |
| glued double line-bundle space, trivialized cylinder | same | Supports. `L(X,D;X',D') := O_X(-D) ∪_{V×K^*} O_{X'}(D')_∞`; the overlap is literally `V × K^*`. |
| `[Cor. 9.10(c)]{WoodwardQKIII}` for `eq:liouville-character` | `arXiv:1408.5869` | Supports exactly. `exp(γ + (d_+ + φ_+, γ)ζ)`, with `φ_+` the affine cocharacter degree. |
| `[Section 9.4]{WoodwardQKIII}` for the distinguished output evaluation | same | Supports exactly, including the phrase "bundles with sections that are constant in some trivialization in a neighbourhood of `BZ_k`" and the evaluation to the inertia stack. |
| `[eqs. (59) and (64)]{WoodwardQKIII}` for `eq:virtual-normal-euler` | same | Supports. The Euler-class display `Eul((Rp_*e^*T(X/G))_mov)(∓ζ)(∓ζ-ψ)` is the unnumbered display attached to (59); (64) corroborates the `∓ζ(∓ζ-ψ)` convention. |
| `[eqs. (54),(56),(57)]{WoodwardQKIII}` | same | Supports as a fibre-product description. See required repair R1 for the inertia-stack variant. |
| `[eqs. (58)–(59)]{WoodwardQKIII}` "weaker than" | same | Supports. (58) is a K-theory identity of normal complexes. |
| `[Example 9.15]{WoodwardQKIII}` irreducible unstable type | same | Supports exactly: "The domain of any gauged map without markings is irreducible and the normal complex … is the moving part". |
| `[Def. 7.13]{WoodwardQKIII}`, `[Def. 7.13(a)]` | same | Supports, including the appendix's claim that it fixes the complex and not the morphism. |
| `[Prop. 7.14(b)]{WoodwardQKIII}` cutting axiom | same | Supports: `[M^G_{n,Γ}] = Δ^![M^G_{n+2,Γ'}]`. |
| `[Section 8.3]{WoodwardQKIII}` relative form | same | Supports exactly: perfect relative obstruction theory over `M^{tw}_{n,1}(C)`, complex dual to `Rp_*e^*T(X/G)`. |
| `[eq. (68)]{WoodwardQKIII}` localized adiabatic identity | same | Supports; the `τ_{Y,-} ∘ κ` form is the unnumbered display obtained by summing (68) over `n`. |
| `[Example 6.6(c)]{WoodwardQKII}` | `arXiv:1408.5864` | Supports: relative obstruction theory for affine gauged maps. |
| `[Prop. 5.21]{WoodwardQKII}` fibre product over the diagonal | same | Supports, at part (a). |
| `[Example 5.23]{WoodwardQKII}` | same | Supports; weights and both quotients match. |
| `[Section 4.3, Prop. 4.3(f),(g)]{WoodwardQKII}` | same | Content supports; environment is *Example* 4.3, not Proposition — see optional item O1. |
| `[Lem. 3.17 and Prop. 3.18]{GonzalezWoodward}` | `arXiv:1208.1727` | Supports exactly, including the degree-then-area order of quantifiers. |
| `[Remark 3.19]{GonzalezWoodward}` framings in the ambient `W^w` | same | Supports exactly: the fibre product is over `(X^ζ)^r`, while the principal factor is over `X^{ζ,t}`. |
| `[Cor. 3.20]{GonzalezWoodward}` | same | Supports; its own proof cites Graber–Pandharipande. |
| `[Lem. 3.21 and its proof]{GonzalezWoodward}` | same | Supports exactly: the trivial factor is "the fiber of `P(D(L_-) ⊕ D(L_+))`", and it is in the proof. |
| `[Prop. 3.15(c)]{GonzalezWoodward}` | same | Supports exactly: nodes and markings land in `P(X^Z)` with no semistability. |
| symbol note: GW write `ζ` for the cocharacter, `ξ` for the equivariant parameter | same | Supports: "We identify `H(BG)` with the polynomial ring `Q[ξ]`". |
| `[Rem. 1.18(d), Rem. 4.6, eq. (47)]{GonzalezWoodward}` | same | Supports exactly, including "in the crepant case … sum of derivatives of delta-functions". |
| `[Rem. 4.7]{GonzalezWoodward}` | same | Supports exactly: no convergence statement is made. |
| `[Def. 5.18, Rem. 5.20, Thm 5.21]{AleshkinLiu}` | `arXiv:2301.01266` | Supports, and all four descriptors (adjacent secondary-fan chambers, circuit, Calabi–Yau charges, grade-restriction window) are hypotheses there. |
| `[Section 1]{IritaniGamma}` for `eq:gamma-framed-section`, `eq:flat-euler-pairing` | `arXiv:2307.15938` | Supports exactly: his (1.6), (1.7), and `[s(V_1),s(V_2)) = χ(V_1,V_2)`. |
| `[Thms 6.1 and 6.3]{CoatesIritaniJiang}` | `arXiv:1410.0024` | Supports exactly, including the pairing convention `(Θ(y,-z)α, Θ(y,z)β) = (α,β)` that the manuscript's three-step display uses. |
| `[Thms 1.3, 7.25, 7.31, 7.33]{IritaniToricGlobal}` | `arXiv:1906.00801` | Supports the sectorial/K-group half; see optional item O6 for the global-Brieskorn-module half. |
| `[Ch. 2, §2.1, Thm 2.1]{MumfordGIT}` | not in cache | **UNVERIFIED** at the locator (book). The locator is the standard one for the Hilbert–Mumford numerical criterion, and the manuscript re-derives the `\Gm` case from scratch, so nothing depends on it. |
| `{BehrendFantechi}` Section 4, `{GraberPandharipande}`, `{ToenVezzosiHAGII}`, `{SchurgToenVezzosi}` | not in cache | **UNVERIFIED** at the locator. Each is cited for the statement it is famous for, and the appendix flags precisely which part is imported. |

---

## 2. Required repairs

Two, both local and both leaving every conclusion intact.

**R1.** `appendix-one-chart.tex`, proof of `prop:app-mu-k`, part (d): the sentence about which
inertia stack Woodward's equations (54) and (57) use is reversed relative to the source.

**R2.** `appendix-one-chart.tex`, `prop:app-mu-k`(b): the displayed cocharacter `φ̃(t) = t^{b/k}` is
inconsistent with the evaluation `φ̃(θ) = θ^b` asserted in the same clause, with the section
convention `z ↦ φ̃(z^{1/k})x` stated two paragraphs earlier, and with Woodward's Definition 9.7.

Details, quoted text, and the repairs are in §5.

I found no required repair anywhere else in the primary scope. In particular I found no place where a
proof bounds less than a later step consumes, no place where an input used in a primary-scope proof
is absent from both `def:gauged-admissible` and `08-scope` item (5), and no citation that points at a
statement about a different object or in the wrong direction.

---

## 3. Optional improvements

Ordered roughly by how much a reader gains.

**O1.** `[Proposition~4.3(f),(g)]{WoodwardQKII}` should be `[Example~4.3(f),(g)]`. The environment in
Woodward's paper is `Example 4.3`; there is no Proposition 4.3. (Woodward's own text at his page 12
writes "as in Proposition 4.3 (g)", so the manuscript is reproducing a slip in the source. The
content at that locator is exactly what is cited for.) Two occurrences, both in the appendix.

**O2.** `prop:clutching-tail-holonomicity`, proof: "the nilpotent parts of the moving roots
contribute only bounded factors" is stronger than true. A nilpotent shift `x_a = w_a + ν_a` gives
`∏_{m≤n}(m + w_a + ν_a) = ∏(m+w_a)·(1 + ν_a ∑_m (m+w_a)^{-1} + …)`, and `∑_{m≤n}(m+w)^{-1} ~ log n`,
so the nilpotent correction is polylogarithmic, not bounded. Nothing downstream changes: the display
two lines later already carries `O(log k)`, and the distributional step already allows a `(log k)^M`
factor. Replace "bounded" with "polylogarithmically bounded".

**O3.** `prop:clutching-tail-holonomicity`, proof: state whether the `p_i(k) ∈ R_N[k]` in the
recurrence are scalars or matrices. `c_k` is vector-valued in `R_N^r`, and "clearing denominators" of
a first-order rational recurrence naturally yields *matrix* polynomial coefficients. A scalar-
coefficient recurrence of order `d` does exist — choose a `C`-basis of `R_N`, view the recurrence as
first order of size `r·dim_C R_N` over `C(k)`, and take a linear relation among the first
`r·dim_C R_N + 1` shifts — but the one line that produces it is currently absent. The device (a
fixed `C`-basis of `R_N`) is already used in the growth estimate, so the addition is cheap.

**O4.** `prop:gamma-ratio-reduction`, proof: "it is the standing hypothesis that the virtual normal
Euler class is invertible" has no pointer. This is the only occurrence of that phrase in the section,
and the hypothesis is not named in `def:gauged-admissible` or `08-scope` item (5). It is genuinely
implied by `def:gauged-admissible`(ii) ("the localized large-area formula applies coefficientwise"),
since virtual localization inverts that class; a cross-reference to (ii) would close the loop and
would cost one clause.

**O5.** The paragraph after `lem:orbit-cylinder-disjoint` argues bistability of the cylinder orbit
("It is semistable for both chamber polarizations because …") while `def:gauged-admissible`(iv) and
`08-scope` item (5) both register bistability as an unproved input. The argument silently uses more
than (i) states: it uses that the identification of the extreme quotients with `Y_±` restricts over
the common open to the cobordism quotients. Either mark the "because" clause as the heuristic it is,
or make that restriction property the explicit content of the registered assumption. The paper is not
missing an assumption here — item (5) covers it — but the register and the prose currently point in
different directions at the same sentence.

**O6.** `rem:verification-status`: the clause "Iritani constructs one global Landau–Ginzburg Brieskorn
module whose chamber completions are the toric quantum D-modules" is carried by
`IritaniToricGlobal` Theorem 1.1 / Theorem 5.16 and the global mirror construction, not by the four
locators given (1.3, 7.25, 7.31, 7.33), which support only the second clause about the sectorial
decomposition and the Gamma-framed ambient and residual K-groups. Add the first locator.

**O7.** `rem:verification-status`: "the graph Fourier–Mukai transform sends `O_p` to `O_{p'}` for a
point in the common open" is asserted without a locator. Coates–Iritani–Jiang Theorem 6.1(3) supplies
*a* Fourier–Mukai transform; that it is the one with the fibre-product kernel, hence acts as claimed
on skyscrapers of the common open, needs the kernel description. The rest of that display (the
pairing chain) is exact and correct.

**O8.** Notation collisions inside Section 8 that a cold reader can stumble on. None of them makes a
statement false; all are cheap to relieve.
- `k` is the affine degree index in `eq:affine-moving-degree` (`n_a(k) = h_a k + s_a`) and in
  `F(x) = ∑_{k≥k_0} c_k x^k`, and simultaneously the orbifold/stabilizer order in "On a `k`-fold
  orbifold chart", in `[Spec R[z^{1/k}]/μ_k]`, and throughout `prop:app-mu-k`. The sentence
  "consecutive degrees inside a tail differ by the stabilizer order of
  Proposition~\ref{prop:app-mu-k}(b)" is where the two meet; the referenced clause calls that order
  `k` while the ambient text calls the degree `k`.
- `a` is the clutching exponent (`W_F^a`, `a_±`, `E_a`), the index labelling virtual lines
  (`α_a`, `h_a`, `n_a`, `s_a`, `x_a`), and the Poincaré dual `a = PD[\bar O]` in
  `lem:orbit-cylinder-disjoint`.
- `x_j = exp(t_j ζ)` in `eq:liouville-character` versus `x_a = α_a/ζ` in
  `prop:clutching-tail-holonomicity`; and `x` is also the point of `W`, the `R`-point in the
  appendix, and the formal variable of `F(x)`.

The `a_p` collision with the Gu–Yu–Yu wall-local class and the `ζ`/`\mathsf w` collision with
González–Woodward are both already disarmed in the text, and well.

**O9.** `prop:gamma-ratio-reduction`, proof: "The last two factors smooth the node and move the
attaching point" pairs the two descriptions in the reverse order of the display. In
`eq:virtual-normal-euler` the factor `(∓ζ)` is `T_{w_+}C` (deformation of the attaching point) and
`(∓ζ - ψ)` is `T^∨_{w_+}C ⊗ T^∨_{w_-}Ĉ^ρ` (node smoothing), per Woodward's own reading of his (59).
Swap the two verbs.

**O10.** Three displays are followed by a sentence continuation but end in a full stop:
`eq:endpoint-gauged-maps` ("… `D\kappa_\pm.`" then "are the endpoint localized gauged maps."),
`eq:marked-class-restrictions` ("… `a_p|_F=0.`" then "for every fixed component …"), and
`eq:liouville-character` ("… `x_j=\exp(t_j\zeta).`" then "where `\widetilde d_+` is …").

**O11.** `prop:support-collapse`'s statement says the identity "reads
`eq:support-collapse-row`" only "after Rees homogenization", but the Rees substitution
`eq:rees-substitution` is introduced 280 lines later, and the proof's closing sentence asserts
`eq:support-collapse-row` directly without that step. Either add a forward pointer to
`eq:rees-substitution` in the statement, or say in the proof which of the two forms it establishes.

---

## 4. Verdict table

| Statement | Verdict |
|---|---|
| `def:gauged-admissible` (i)–(iv) as an assumption register | Complete for everything the primary scope uses. The four-paragraph discussion of the differing standing of (i)–(iv) is accurate, including the point that projectivity does not supply separation of the affine cocharacter degree. |
| `rem:iv-semistable-restriction` | Correct. Freeness of `H^*_{\Gm}(W)` over `H^*(B\Gm)` from perfect filtrable Białynicki-Birula, torsion kernel from localization, and the two combining to injectivity — all reverified. Both justifications of perfectness (weight purity, Frankel) are correct, and the disclaimer that perfectness is not a parity statement is right. |
| `rem:endpoint-only` | Correct. The universal quantifier over maps is genuinely forced by the shape of the contradiction, and the manuscript says so. |
| `lem:point-insertion-row` | Correct, given the normalization input it declares and `08-scope` item (5) registers. I recomputed `c_n(z)` from `eq:gamma-framed-section`: `\hat Γ` and `z^{c_1}` act trivially on the top class, and the residue is `z^{-n/2}(2π)^{-n/2}(2πi)^n`, invertible and depending only on `n`. |
| `prop:support-collapse` | Correct, given (i)–(iv) and the two declared inputs. The character-independence extraction is valid, the placement argument at the distinguished output evaluation is exactly right against Woodward §9.4 and GW Lemma 3.17 / Remark 3.19, and the cancellation of `c_{\dim Y_±}(z)` is legitimate since birational endpoints have equal dimension. |
| `lem:orbit-cylinder-disjoint` | Correct. Fully reverified from the weight criterion up. The step that `O` is closed in `W^ss(L_±)`, which (c) needs before `PD[O]` can be a point class, is supplied by (c)'s own first sentence. |
| the Włodarczyk terminology and resolution paragraph | Correct, and unusually careful: the "projective means quasiprojective" point, the smoothness of the glued space, and the flag that functoriality of canonical resolution is a standard property and not part of the cited proposition. |
| `prop:gamma-ratio-reduction` | Correct. `eq:gamma-index-factor` holds verbatim on both rays; `eq:total-moving-slope` follows from `χ(O(n)) = n+1` with no ray sign, exactly as argued; `eq:simple-gamma-residue` is `(-1)^m/(h·m!)`; the nonneutral Laurent-finiteness follows from the virtual-dimension equation. |
| `rem:higher-pole-localization-boundary` | Correct and needed. |
| `rem:neutral-boundary` | Correct. Every one of the six locators supports the sentence attached to it. |
| `thm:tailwise-derived` | Correct, modulo the appendix. The sign-only dependence of the strata, the constancy of the two extension subcomplexes along a tail, and the distinction between identifying a complex and identifying a morphism to the cotangent complex are all handled properly. |
| `prop:clutching-tail-holonomicity` | Correct. Both growth rays give the same expression, neutrality kills exactly the three terms claimed, the residual linear rate `-∑ h_a log|h_a|` is correctly identified as surviving, and the distributional argument is valid. See O2, O3 for two wording/detail improvements that change nothing. |
| `rem:two-tail-threshold-obstruction` | Correct. `2^k` and `3^{-k}` do give `1/(1-2x)` and `3/(x-3)`, both first-order hypergeometric, annihilated by `(E-2)(E-1/3)` away from the threshold, and not branches of one meromorphic function. |
| appendix `conv:app-obstruction-morphism` | Correct and well placed; Woodward's Definition 7.13 does fix only the complex. |
| appendix `lem:app-graded-extension`, `lem:app-sign` | Correct. |
| appendix `prop:app-one-chart` | Correct. The chart-dependence counterexample is genuine, and the `U_F` fix handles the family case that the counterexample shows is not automatic. |
| appendix `prop:app-descent` | Correct. |
| appendix `lem:app-cech`, `rem:app-degree-one` | Correct. The `-aw` exponent and the `aw ≤ 0` selection agree with a direct computation; the `h^{-1}` vanishing from finite stabilizers is right. |
| appendix `lem:app-truncation`, `prop:app-square` | Correct as far as I can check without the four uncached references. The logic is sound: naturality of `𝔛 ↦ (τ_{[-1,0]}L → L_{t_0})` at an equivalence, plus an explicitly flagged import of the Behrend–Fantechi realization step. The strict identification of the left vertical arrow, and the accompanying warning that it says nothing about the classical truncations, are both correct. |
| appendix `prop:app-mu-k` | Correct except for R2 in (b) and R1 in the proof of (d). |
| appendix `prop:app-cutting`, `rem:app-imports` | Correct. |
| `08-scope` item (5) | Complete for the primary scope. Every input I found the proofs using that is not proved appears there: the four gauged-admissibility conditions, bistability of the cylinder orbit, the virtual Kalkman endpoint normalization with the master-space normal complex not exhibited, and the Woodward normalization behind `lem:point-insertion-row`. |
| introduction paragraph (lines 110–118) | Accurate. It correctly separates the two roles of the two circle actions — the orbit-cylinder class and the polarization sweep on one side, rotation localization producing the graph factor and the degree extraction on the other — and does not overstate the wall vanishing. |
| secondary scope (lines 905–1362) | No required repairs found. `lem:cyclic-row-support` is correct; the Neumann-series surjectivity is correct; `lem:finite-threshold-gluing` and `thm:birational-point-primary` do exactly what their hypotheses allow; `conj:gamma-window`'s implication sketch is explicitly incomplete at the one place it is incomplete, and says so. |

---

## 5. Findings in detail

### R1 (required). The inertia-stack direction in `prop:app-mu-k`(d) is reversed

**Quoted text**, `appendix-one-chart.tex`, proof of `prop:app-mu-k`, part (d):

> The fibre products of \cite[equations~(54) and~(57)]{WoodwardQKIII} are taken over the
> unrigidified inertia stack, so the constructions above take place there; passage to the rigidified
> inertia stack used for the evaluation maps changes rational cohomology only by the factors of \(r\)
> on \(r\)-twisted sectors recorded in \cite[Proposition~4.3(f),(g)]{WoodwardQKII}, and those factors
> depend only on the order of the stabilizer, which is constant along a tail by (b).

**Source comparison.** In `arXiv:1408.5869`, equations (54), (55) and (57) all take the fibre product
over, respectively map into, the **rigidified** inertia stack `\bar I_{X//G}`. Equation (60), which
is the induced map in equivariant cohomology, and equation (68) and its integrals, use the
**unrigidified** `I_{X//G}`. That is the opposite assignment to the one the manuscript states, in
both halves of the sentence.

**How I read the overline.** The pdftotext extraction drops overlines but inserts a space, so
`\bar I_{X//G}` comes out as `I X//G` and `I_{X//G}` as `IX//G`. I confirmed this is reliable using a
control inside `arXiv:1408.5864` Example 4.3, where the prose disambiguates and both forms occur
within a few lines:

- "(f) (Inertia stacks) The inertia stack … is `IX := X ×_{X×X} X`" — no space, unrigidified.
- "(g) … `I X = ∪_{r>0} I X ,r , I X ,r := IX /r /Bµr` … is the rigidified inertia stack" — the
  rigidified object has the space, the unrigidified one on the right-hand side does not, in the same
  line.
- "(h) … `IX//G = ⊔ X^{ss,g}/Z_g`" (no space, no `⟨g⟩` quotient) versus
  "`I X//G = ⊔ X^{ss,g}/(Z_g/⟨g⟩)`" (space, with the `⟨g⟩` quotient).

Applying that control to `arXiv:1408.5869`: the raw bytes of equation (54) read
`M0,n− +1 (X, d− ) ×I X//G MG,fr … ×I X//G M0,n+ +1 (X, d+ )` — space, twice, so rigidified. Equation
(57) reads `FnG− (d− ) ×I X//G FnG+ (d+ )` — space, so rigidified. Equation (60) reads
`HG (X)⊗n → HC× (IX//G )` — no space, so unrigidified.

**Verdict: required repair.** A statement is attributed to two numbered equations and is the reverse
of what those equations say. The fix is one sentence and does not disturb the conclusion of (d): the
first three sentences of (d) already establish that `π^*` along the `Bμ_k`-gerbe is fully faithful
and conservative, so a `μ_k`-equivariant equivalence upstairs descends. Suggested replacement: "The
fibre products of \cite[equations~(54) and~(57)]{WoodwardQKIII} are taken over the rigidified inertia
stack; the constructions above take place on the unrigidified cover and descend along the
`Bμ_r`-gerbe by the previous paragraph, changing rational cohomology only by the factors of `r` …".

**Confidence.** High, but the evidence is a pdftotext reconstruction with an internal control rather
than the typeset PDF. Confirm against the typeset arXiv:1408.5869v7 (pages 30–32) before editing.

### R2 (required). `φ̃(t) = t^{b/k}` contradicts `φ̃(θ) = θ^b` in `prop:app-mu-k`(b)

**Quoted text**, `appendix-one-chart.tex`, `prop:app-mu-k`(b) and its proof:

> (b) The stabilizer element of the clutching datum is \(\widetilde\varphi(\theta)=\theta^{\,b}\) …

> (b)  The stabilizer of the orbifold point acts through \(\widetilde\varphi(\theta)\), which for
> \(G=\Gm\) and \(\widetilde\varphi(t)=t^{b/k}\) is \(\theta^{\,b}\); this depends only on
> \(b\bmod k\).

**Independent computation.** With `a = b/k`, the section on the orbifold chart is
`s(z) = φ̃(z^{1/k})·x`, as the manuscript itself states in the paragraph introducing
`prop:app-mu-k` and as Woodward's Definition 9.7 states. For that composite to be `z^{b/k}x = z^a x`,
the cocharacter `φ̃` must be the integral one `φ̃(t) = t^b` on the `k`-fold cover. The `μ_k` deck
generator sends `z^{1/k} ↦ θ z^{1/k}`, so `s ↦ φ̃(θ)·s = θ^b s`, giving `φ̃(θ) = θ^b` and dependence
on `b mod k` only. If instead `φ̃(t) = t^{b/k}` as written, then `φ̃(z^{1/k}) = z^{b/k^2}`, which is
not the section the construction uses, and `φ̃(θ) = θ^{b/k}`, which is not `θ^b` and is not even
single-valued.

Woodward's Definition 9.7 is unambiguous on this: "`φ̃_± : C̃^× → G` are one-parameter subgroups such
that `φ̃_±(θ^i)` fixes `x` for all `i`", with `(r^*_± u)(z) = φ̃_±(z^{1/k})x`. His `φ̃` is integral;
what is rational is the composite.

**Verdict: required repair.** One symbol: `\widetilde\varphi(t)=t^{b/k}` should be
`\widetilde\varphi(t)=t^{b}`. The conclusion `θ^b`, the `b mod k` dependence, and everything
downstream (the fixed inertia label, the constancy of the twisted-sector evaluation along a tail, the
step size `k` between consecutive affine degrees) are all correct as stated. While making the change,
consider also adjusting the sentence two paragraphs earlier — "the cocharacters `φ̃_±` are taken with
values in `(1/k)Z`" — which describes the composite rather than `φ̃` itself and is what makes the
`t^{b/k}` slip natural.

### What I checked and found sound at the places most likely to hide a defect

Recorded because "no finding" is a result, and because the next reader should not repeat the work.

**The two-circle combination in `prop:support-collapse`.** The proof runs the rotation localization
of `WoodwardQKIII` and the polarization sweep of `GonzalezWoodward` simultaneously, and the wall
vanishing depends on the word "principal component" meaning the same thing in both. It does: in
Woodward, the localized gauged graph potential is defined by pushforward along the map his (55),
`(u,x) ↦ [x, φ̃_±(θ)]`, whose value `x` is the value of the section on the open orbit, that is, the
principal-component value, and not `lim φ̃_±(z)x`, which is the value at `0` or `∞`; in
González–Woodward, Lemma 3.17 places the principal component of a Mundet-semistable `L_t`-fixed map in
`X^{ζ,t}/G_ζ` with `X^{ζ,t}` the `L_t`-semistable locus of the `ζ`-fixed locus, and Remark 3.19
shows the framings are compared in the ambient `X^ζ` so that only the principal factor carries
semistability. The manuscript's sentence about the framings is a precise reading of Remark 3.19, and
the contrast it draws with Proposition 3.15(c) — where an arbitrary node or marking lands in the full
fixed locus with no semistability — is exactly what that proposition says. For `G = \Gm` the wall
cocharacter's fixed locus is the full `\Gm`-fixed locus, so `lem:orbit-cylinder-disjoint`(b), which
quantifies over components of `W^{\Gm}`, covers every component that can arise.

**Order of quantifiers on "sufficiently large area".** González–Woodward's Lemma 3.17 gives
`ρ_0 = ρ_0(d)`. The manuscript writes "For each fixed degree and sufficiently large area", which is
the right order. Woodward's Corollary 9.10 likewise says "For `ρ` sufficiently large" after fixing
`d`. `def:gauged-admissible`(ii) says "Degree by degree", and the section preamble says "We work
coefficientwise at sufficiently large area". Consistent throughout.

**Whether `lem:point-insertion-row` is applied in the slot it is stated for.** It is. The lemma says
"The insertion is at the output of `Dτ_{Y,-}`", and `prop:support-collapse` says "Lemma … is stated
for that slot, so it applies verbatim". The distinguished output evaluation of the graph factor is
the slot through which `τ_{Y_±,-}` is defined, per Woodward §9.4, which is what makes the two agree.

**Whether the growth estimate is uniform enough for the distributional step.** The estimate produces
`log|c_k| = -(∑h_a)k log k - k∑h_a log|h_a| + (∑h_a)k - (∑h_a)k log|ζ| + O(log k)`. Under
`eq:neutral-direction` and `eq:total-moving-slope` the first, third and fourth terms vanish, leaving a
purely linear rate that one rescaling removes, after which `|c_k| ≤ Ck^N(log k)^M`. The distributional
step then needs a single `q` for all tails, threshold classes and basis components at a fixed Artin
level, and the manuscript supplies exactly that argument from the finiteness of the tail and graph-type
count. Nothing is consumed that was not bounded.

**Whether `08-scope` item (5) under-registers.** It does not. I tried to construct a list of inputs
that the primary-scope proofs use and that item (5) omits, and every candidate turned out to be
either proved in place (the reachability statement, `lem:orbit-cylinder-disjoint`), covered by
`def:gauged-admissible`(ii) (the Kalkman identity, the large-area localized formula, and by
implication the invertibility of the virtual normal Euler class — see O4 for the missing
cross-reference), or already listed (bistability, the normalization behind `lem:point-insertion-row`,
the unexhibited master-space normal complex).

---

## 6. Coverage

**Reached and judged**: all of `sections/08-global-transport.tex` (primary and secondary scope), all
of `sections/appendix-one-chart.tex`, `sections/08-scope.tex` item (5), the introduction paragraph
named in the brief and the two paragraphs following it, and `sections/02-point-row.tex`.

**Not reached**: `sections/03-simple-wall.tex`, `04-ordinary-flop.tex`, `05-incomplete-gamma.tex`,
`06-fourier-boundary.tex`, `07-two-wall-criterion.tex`, `09-cubic-endpoint.tex`, the rest of
`01-introduction.tex`, and the `verification/` artifact. Consequently I did not check
`thm:simple-wall-point-column`, `thm:ordinary-flop-point-row`, `cor:simple-wall-rank`,
`prop:incomplete-gamma`, `prop:punctual-corner`, `hyp:rank-zero-target`, `prop:cubic-endpoint`,
`lem:cubic-central-charge`, or `thm:intro-cubic-conditional`, nor the scope items that describe them.
Where the primary scope refers to those results — item (5) of the scope section calls
`prop:punctual-corner` the obstruction behind `rem:neutral-boundary`, and `rem:endpoint-only` refers
to `thm:intro-cubic-conditional` — I took the referenced statement at face value and checked only
that the reference is used consistently.

**Marked UNVERIFIED, with what verification would take**:

1. `[Chapter~2, §2.1, Theorem~2.1]{MumfordGIT}`. The book is not in the cache. Verification: open
   Mumford–Fogarty–Kirwan 3rd ed. and confirm that Theorem 2.1 of §2.1 is the numerical criterion in
   the `μ`-form. Nothing depends on it: the manuscript re-derives the `\Gm` case in full from the
   weight decomposition, and I reverified that derivation.
2. `{BehrendFantechi}` Section 4, `{GraberPandharipande}`, `{ToenVezzosiHAGII}`,
   `{SchurgToenVezzosi}`. None is in the cache. Verification: fetch the four papers and confirm that
   BF §4 contains the realization step ("every class over a test scheme comes from an actual
   square-zero extension after passing to a smooth cover"), that GP gives the fixed part of an
   ambient relative perfect obstruction theory as a relative perfect obstruction theory on the fixed
   locus, and that the two derived-geometry citations are used only as precedent, as
   `rem:app-imports` claims. The manuscript's own framing of each is unusually explicit about what is
   imported versus proved internally, which limits the exposure.
3. "the graded Picard group of `R[z]` is `Pic(R) × Z`", in the descent step of `prop:app-one-chart`.
   I did not construct a proof. The statement is the classification of `\Gm`-equivariant line bundles
   on `A^1`, and the manuscript's accompanying warning that the non-equivariant analogue fails for
   non-reduced `R` (Traverso) is correct and is the right reason to prefer the equivariant form.
   Verification: a short direct argument that a graded invertible `R[z]`-module is `L ⊗ R[z](d)`, or a
   citation.
4. `eq:rees-homogeneity`, `μ_Y A - A μ_W = ½A - Θ_Q A`, in the secondary scope. I did not derive the
   `½`. It is the half-Tate shift for a one-dimensional acting group, and the argument only ever uses
   that the shift is the *same* at both endpoints, so an error in the constant would not affect
   `thm:birational-point-primary`. Verification: re-derive the homogeneity of `Dκ` from the
   virtual-dimension identity.
5. `rem:verification-status`'s claim that `x(x+y)` "restricts to zero on the intermediate fixed
   quotient" in the `Bl_p P^2` model. I verified the two chamber images and the point-class identity;
   I checked the intermediate claim only to the extent of confirming that the wall cocharacter's
   fixed quotient is zero-dimensional, which makes the restriction of a degree-four class vanish for
   degree reasons. Verification: state which fixed quotient is meant.
