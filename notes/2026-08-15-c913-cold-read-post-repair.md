# C913 — adversarial cold read of the post-repair gauged/derived text

**Date:** 2026-08-15
**Manuscript:** `papers/cubic-stabilization-irrationality/`, frozen at `5c8d0957a`
**Role:** referee, adversarial. Findings only; no manuscript edits made.

---

## 1. Scope and method

### Read in full

| File | Range read |
|---|---|
| `sections/08-global-transport.tex`                | lines 1–797 (start through end of proof of `prop:clutching-tail-holonomicity`) |
| `sections/appendix-one-chart.tex`                 | lines 1–734 (complete) |
| `sections/08-scope.tex`                           | complete (item (5) judged; rest read for consistency) |
| `sections/01-introduction.tex`                    | lines 95–149 (the completion paragraph and its neighbours) |
| `refs.bib`                                        | entries `MumfordGIT`, `BehrendFantechi`, `GraberPandharipande`, `SchurgToenVezzosi`, `ToenVezzosiHAGII`, `Wlodarczyk` |

Context read but not re-reviewed: `notes/2026-08-14-c913-cold-read-derived-gauged.md`,
`notes/2026-08-15-c913-support-collapse-output-node-repair.md`,
`notes/2026-08-14-c913-woodward-qk-extraction.md`.

### Verified against primary sources (not against the extraction note)

All from the shared disk-backed cache `/tmp/persistent/tavis/lit-search/`.

| Source | Cache key | What I read directly |
|---|---|---|
| González–Woodward | `arXiv:1208.1727` (`text/arXiv_1208.1727.txt`) | Prop. 3.15(a)(b)(c) (l. 3360–3374); Def. 3.16 (l. 3375–3391); Lem. 3.17 statement **and proof** (l. 3392–3405); Prop. 3.18 statement and proof (l. 3406–3432); **Rem. 3.19 in full, untruncated** (l. 3435–3450); Cor. 3.20 and its proof (l. 3452–3462); bibliography entries [30], [31], [41] (l. 4379–4407) |
| Woodward QK III | `arXiv:1408.5869` (`text/arXiv_1408.5869.txt`) | §9.4 opening and the `F^G_{n±,1}(d)` obstruction-theory sentence and the `BZ_k` evaluation map (l. 2580–2660) |
| Woodward QK II | `arXiv:1408.5864` | not re-read this pass; relied on the extraction note (marked UNVERIFIED where load-bearing) |

The extraction note's own caveat that González–Woodward Remark 3.19 was truncated by `pdftotext`
is now discharged: I read the full remark from the cached text, and it materially changes one of
the manuscript's characterizations (see §5.1 below).

### Method

Every algebraic identity below was recomputed from scratch (Gamma recurrences, Stirling
expansions, the Białynicki-Birula weight bookkeeping, the fibre-weight form of the numerical
criterion, the two-ray index estimate, the distributional boundary-value argument). Nothing was
accepted because it looked standard. Where I could not verify, the item is marked UNVERIFIED with
what verification would take.

Verdict vocabulary, kept distinct throughout:

- **WRONG** — the statement itself is false.
- **GAP** — the statement is plausibly right but the given argument does not establish it.
- **CITATION** — the argument works but the cited locator does not support it.
- **PRESENTATION** — correct and supported; wording, notation, or typesetting defect.

---

## 2. Required repairs, in priority order

1. **`lem:app-truncation` proves strictly less than `prop:app-square` consumes.** The lemma's
   proof explicitly bounds itself to square-zero extensions of classical test schemes ("no more is
   claimed"); `prop:app-square` then concludes an isomorphism *of morphisms to the cotangent
   complex* and invokes Behrend–Fantechi, which needs the homotopy class of the morphism, not its
   deformation–obstruction assignment. The bridging step is missing. (§7.1)
2. **`thm:tailwise-derived` contradicts `prop:app-square` about the comparison homotopy.** Section 8
   still says "both composites are the same difference of restrictions … so the comparison homotopy
   may be taken to be the identity (Proposition `prop:app-square`)". `prop:app-square` says in terms
   that the strict identification "says nothing about the classical truncations through which the
   two composites factor". One of the two sentences must go. (§7.2)
3. **The "attaching node" gloss in `prop:support-collapse` describes a different evaluation from
   Woodward's, and a weaker one.** QK III §9.4's distinguished evaluation is at `BZ_k`, where the
   section is *constant in a trivialization*; the bubble trees attach at the `0`/`∞` markings, whose
   value is `lim φ̃_±(z)x`, which is a cocharacter limit and has no claim to `L_t`-semistability.
   The sentence as written invites the reader to a slot where the vanishing argument fails.
   Replacing it with the principal-component value `x` makes the argument stronger, not weaker.
   (§5.1)
4. **`rem:iv-semistable-restriction` derives injectivity from freeness, which is a non-sequitur.**
   Freeness over `H^*(BG_m;Q)` gives torsion-freeness. Injectivity of restriction to the fixed
   locus additionally needs the Borel/Atiyah–Bott localization theorem (the kernel is a torsion
   module). One clause. (§6)
5. **QK III Section 9.4 does not say what the appendix attributes to it, and does not cite
   Graber–Pandharipande.** §9.4 puts a relative perfect obstruction theory on `F^G_{n±,1}(d)`
   *induced from* the one on the `C^×`-fixed locus — the opposite direction from "on the fixed
   locus, induced from the ambient one", and a different stack. The statement the manuscript
   actually wants, with Graber–Pandharipande named, is **González–Woodward Corollary 3.20**. (§9.1)
6. **`prop:app-one-chart`'s family form uses the wrong open cover.** `x ∈ U` does not put the
   `z = 0` value of the section `z ↦ z^a x` in `U`. The cover must be by
   `U_F := \{x ∈ U : \lim_{t→0} t^a x ∈ U ∩ F\}`, which is open in `W_F^a`. (§8.3)
7. **The endpoint normalization of the Kalkman identity is asserted, not computed.** "Their signs
   and node factors agree with Woodward's localized adiabatic identity" is the only support for the
   *unsigned* `eq:support-collapse-row`. The two polarization endpoints of a Kalkman sweep carry
   their own virtual normal Euler normalizations, and none is exhibited. (§5.4)
8. **`ζ` denotes two different objects inside `sections/08-global-transport.tex`** — the wall
   cocharacter in `g` (l. 210–228) and Woodward's rotation equivariant parameter (l. 436, 455–458,
   764) — while `\hbar` is used for the rotation parameter at l. 178 and 188 only. Three-way
   collision in one section. (§10.1)
9. **The `\log|c_k|` display omits one term.** The exact expansion carries
   `-(\sum_a h_a)\,k\log|ζ|`, which vanishes only after `eq:neutral-direction` is applied. The
   display is presented as the general expansion. (§7 of the Stirling section, §4.2)
10. **The introduction misattributes the wall removal to rotation localization.** The wall terms are
    killed by the polarization (Kalkman/VGIT) sweep plus the vanishing of `a_p`; rotation
    localization is what produces the graph factor and the Liouville degree extraction. (§10.3)

---

## 3. Verdict table

| # | Item | Verdict | Severity |
|---|---|---|---|
| 1a | Existence of a distinguished output slot in Woodward's localized graph potential | **Supported.** Verified: QK III §9.4 evaluation `F^G_{n±,1}(d) → I_{X//G}` at `BZ_k`; α_∞ slot in eq. (68) | — |
| 1b | It is a parametrized-point evaluation computed from the principal side | **Supported** — but the manuscript's "attaching node" gloss is **WRONG** for that slot | required repair 3 |
| 1c | Wall vanishing on a polarization-wall fixed locus | **Supported.** GW Lem. 3.17 + Rem. 3.19 (read in full) do put the principal factor over `X^{ζ,t}` | — |
| 1d | `lem:point-insertion-row` lives in that slot | **Supported** as a slot claim; the Gamma/unitarity content is **UNVERIFIED** (no citation) | medium |
| 1e | Endpoint contribution is exactly `c_n(z)^{-1} 𝔯_{Y,p} Dτ_{Y,-} Dκ`, stable under further derivatives | **Algebra checked and correct**; the Kalkman normalization behind it is a **GAP** | required repair 7 |
| 1f | Coverage of every wall fixed-locus type | **Complete** (reducible, irreducible-unstable, and non-endpoint types all covered by GW Prop. 3.18) | — |
| 1g | Anything elsewhere assuming `a_p` at an ordinary marking | **None found** in §8; §3's `a_p` is an unrelated Gu–Yu–Yu object reusing the symbol | PRESENTATION |
| 2 | `rem:iv-semistable-restriction` | Conclusion **true**; argument has a **GAP** (freeness ⇒ injectivity) | required repair 4 |
| 3a | `eq:total-moving-slope` as equivariant Riemann–Roch | **Correct**, recomputed independently | — |
| 3b | Fixed part and gauge Lie algebra have affine slope zero | **Correct** given `thm:tailwise-derived`; orbifold/finite-cover descent is a **GAP** | low-medium |
| 3c | `\log|c_k|` expansion, both rays, `h_a = 0` roots, componentwise sizes | **Three displayed terms verified correct**; one term omitted | required repair 9 |
| 4 | Finite-order boundary-value paragraph | **Correct**, recomputed end to end (`q > N+2`, `b_0 = 0`, `∂_θ^q`, `D'(S^1)` order ≤ q) | — |
| 4b | "(D)-finite" used consistently | Meaning consistent; **PRESENTATION** defect at l. 752, 754 and in the label | low |
| 5a | The `P^1` counterexample to the separatedness argument | **Correct**, recomputed | — |
| 5b | The invariance argument, including negative exponent | **Correct** for every `a ≠ 0` | — |
| 5c | Charts disjoint from `F` must be excluded | **Correct**, and the counterexample is exactly an instance | — |
| 5d | Family form over arbitrary test algebras | **GAP**: wrong cover | required repair 6 |
| 6a | `conv:app-obstruction-morphism` | Legitimate as a convention; see 6b | — |
| 6b | `lem:app-truncation` internal argument sufficient for equality of virtual classes | **GAP** — the claim is bounded, but `prop:app-square` needs more than the bound | required repair 1 |
| 6c | Demotion of "comparison homotopy = identity" consistent with `thm:tailwise-derived` | **Inconsistent** | required repair 2 |
| 7a | QK III §9.4 for the relative POT on the fixed locus | **CITATION** — names a statement about a different stack, opposite induction direction | required repair 5 |
| 7b | Graber–Pandharipande for the fixed-part step | Content **correct**; attached to the wrong locator (see 7a) | required repair 5 |
| 7c | Behrend–Fantechi for invariance of virtual classes | **Supported** by the construction; bare locator, and see repair 1 | low |
| 7d | `\cite[Cor. 9.10(c)]{WoodwardQKIII}` for `\widetilde d_+` | **Verified correct**: `exp(γ̄ + (d_+ + φ_+, γ)ζ)` | — |
| 7e | `\cite[Lem. 3.17 and Prop. 3.18]{GonzalezWoodward}` | **Verified correct** against the source text | — |
| 7f | `\cite[Rem. 3.19]{GonzalezWoodward}` | **Verified correct**, and now untruncated | — |
| 7g | `\cite[Prop. 3.15(c)]{GonzalezWoodward}` used as the weaker marking statement | **Verified correct** | — |
| 7h | `\cite[Ch. 2, §2.1, Thm. 2.1]{MumfordGIT}` | **UNVERIFIED** (GIT not in cache); the manuscript's own derivation of the fibre-weight form is correct | low |
| 7i | `\cite[Prop. 2(B')]{Wlodarczyk}` | **UNVERIFIED** (not in cache) | medium |

---

## 4. Item 1 — the support-collapse repair

### 4.1 Is there a distinguished output slot, and is it a parametrized-point evaluation?

Manuscript, `prop:support-collapse`:

> The distinguished class \(a_p\) is inserted at the distinguished output evaluation of the graph
> factor, not at an ordinary input marking. This is the evaluation through which Woodward's
> localized graph potential is defined by pushforward: it is the evaluation of the principal
> component at a fixed parametrized point of the domain, so when a bubble tree sits over that point
> it is the evaluation at the attaching node, computed from the principal side.

**Source check, done directly.** QK III §9.4 (cached text, l. 2630–2660) reads:

> Let `F^G_{n±,1}(d) ⊂ M^G_{n±,1}(P(1,k), X, d)^{C^×}` denote **the locus of bundles with sections
> that are constant in some trivialization in a neighborhood of `BZ_k`** and `n_±` markings map to
> `0 ∈ P(1,k)` … Consider **the evaluation map `F^G_{n±,1}(d) → I_{X//G}` at `BZ_k ⊂ P(1,k)`.**

and equation (68) pairs the graph potentials against `α_∞ ∈ H(X^g//Z_g) ⊂ H(I_{X//G})` through
exactly that `I_{X//G}` evaluation, on both sides of the divisor relation (66)/(67). The
factorization (55) gives the same map concretely as `(u, x) ↦ [x, φ̃_±(θ)]`.

**Verdict on existence and type.** Yes, the slot exists, it is Woodward's own, and it is an
evaluation at a *fixed parametrized point of the domain* — the orbifold point `BZ_k` of `P(1,k)`.
The manuscript's claim on this point is **supported**, and it is supported by a locator the
manuscript already carries.

### 4.2 The "attaching node" gloss is wrong for that slot

Two distinct points of the domain are in play, and the manuscript merges them:

| point | value of the section there | semistability |
|---|---|---|
| `BZ_k` (the distinguished evaluation) | `x`, the value of the principal component; the section is *constant* near `BZ_k` by the definition of `F^G_{n±,1}(d)` | on a wall: `x ∈ X^{ζ,t}`, i.e. `L_t`-semistable — exactly what condition (iv) covers |
| `0`, `∞` (where the bubble trees attach) | `lim_{z→±∞} φ̃_±(z)x`, per (55) | a cocharacter limit; no semistability claim in any cited statement |

So the sentence "when a bubble tree sits over that point it is the evaluation at the attaching node"
names a value that (a) is not the one Woodward's slot evaluates, and (b) is precisely the kind of
value the manuscript's own caveat paragraph (via GW Prop. 3.15(c)) says can land on an unstable
fixed component. For `G = G_m` the two values happen to coincide, because the principal component
maps into `W^{G_m}` on which the gauge group acts trivially, so `φ̃_±(z)x = x`; but the manuscript
never says that, and the sentence is stated in general terms.

**Verdict: WRONG as written, harmless to the conclusion, actively harmful to the reader.** Required
repair 3: say the slot evaluates the principal-component value `x` at the distinguished parametrized
point (Woodward's `BZ_k` evaluation, equivalently (55)), and drop the attaching-node gloss — or
keep it only with the `G = G_m` triviality argument attached.

### 4.3 Does the wall vanishing hold, and for every type?

Manuscript:

> its principal component maps to \(W^{\zeta,t}/G_\zeta\), where \(W^{\zeta,t}\) is the locus of
> \(L_t\)-semistable points of the \(\zeta\)-fixed locus … In the bubble-tree description of that
> fixed locus, the principal factor is a gauged-map stack over \(W^{\zeta,t}\) framed at its
> attaching points, and the bubble factors are glued to it along those framings.

I read González–Woodward Remark 3.19 in full (the extraction note had it truncated):

> There is an isomorphism `M^{G_ζ}_n(C, X, L_t, ζ) → ⋃_{r,[I_1,…,I_r]} ( M^{G_ζ,fr}_r(C, X^{ζ,t})
> ×_{(X^ζ)^r} ∏_{j=1}^{r} M_{|I_j|+1}(X) )/(G_ζ)^r )^{C^×_ζ}` … Indeed, by definition each object
> of `M^{G_ζ}_n(C, X, L_t, ζ)` consists of a principal component mapping to `X^{ζ,t}/G_ζ` and a
> collection of bubble trees in `X` fixed (up to reparametrization) by the action of `C^×_ζ`.

This is exactly what the manuscript says, and Lemma 3.17's proof (also read: "Then any
`L_t`-semistable pair `(P,u)`, the section `u` takes values in `P(X^{ζ,t})`") confirms it. Note the
fibre product is taken over `(X^ζ)^r`, **not** `(X^{ζ,t})^r` — so the *bubble-side* node value is
only constrained to `X^ζ`. Since the manuscript's evaluation is on the principal side, this does not
hurt it; it does mean repair 3 is not cosmetic.

**Type coverage.** GW Proposition 3.18 (read directly) says *any* `C^×`-fixed component of the
master space not among the two endpoint components `M^G_n(C, X, L_±)` is in the image of
`M^{G_ζ}_n(C, X, L_t, ζ)` for some `t ∈ (-1,1)` and some **non-zero** `ζ ∈ g`. So the case split is
exhaustive: endpoint components, and everything else with the principal component in `X^{ζ,t}`.
The irreducible unstable type (QK III Example 9.15) has no bubbles at all, so its distinguished
evaluation is the principal value directly. I found no uncovered type.

**Verdict: the vanishing argument is complete.** For `G = G_m`, `X^ζ = W^{G_m}`, `G_ζ = G_m`, and a
fixed point is `L_u`-semistable exactly when its fibre weight vanishes — which is precisely the
hypothesis of `lem:orbit-cylinder-disjoint`(b). The chain closes.

### 4.4 The endpoint contribution and further derivatives

`lem:point-insertion-row` states `𝔯_{Y,p} Dτ_{Y,-} = c_n(z) ε_{Y,p}`, hence
`ε_{Y,p} = c_n(z)^{-1} 𝔯_{Y,p} Dτ_{Y,-}` and `ε_{Y,p} ∘ Dκ = c_n(z)^{-1} 𝔯_{Y,p} Dτ_{Y,-} Dκ`.
**The algebra is consistent**, and the cancellation of `c_{\dim Y_\pm}(z)` between the two endpoints
is legitimate because birational smooth projective varieties have equal dimension.

The stability under further input and bulk derivatives is also sound as stated: those derivatives
add and differentiate ordinary input markings, and by the chain rule the `α_∞` slot is untouched.
Woodward's Corollary 9.10 is stated for arbitrary `n`, so adding markings does not break the
`d̃_+ = 0` extraction.

**But** the mathematical content of `lem:point-insertion-row` itself is **UNVERIFIED**. Its proof
asserts that "the Gamma framing of `O_p` is the graph fundamental solution applied to the top
cohomology class" and appeals to "unitarity of the fundamental solution", with no citation anywhere.
Woodward's `τ_{X//G,-}` is called a generalization of Givental's `I`-function (QK III after eq. (65)),
which is suggestive but not the same as the fundamental solution `S(z)`, and the passage from `I` to
`S` is exactly a mirror-map statement. Verifying this would take: a locator identifying
`Dτ_{Y,-}` with the genus-zero fundamental solution of the quantum connection on `Y` (equivalently,
a statement that the localized graph potential's derivative is the `S`-matrix in Woodward's
normalization), plus the unitarity relation in the same normalization. The repair report itself
lists "a citation for `Dτ_{Y,-}` being the graph fundamental solution" as an item not taken; it is
load-bearing for the endpoint identification and should be promoted.

### 4.5 The Liouville extraction

Manuscript, `eq:liouville-character`:

> \(\exp(\sum_j t_jD_j)\prod_j x_j^{D_j\cdot\widetilde d_+}\), \(x_j = \exp(t_j\hbar)\)

Recomputed from Corollary 9.10(c), `λ(γ)|_F = exp(γ̄ + (d_+ + φ_+, γ)ζ)`, with `γ = ∑_j t_j D_j`:

    λ(γ)|_F = exp(∑_j t_j D̄_j) · exp(ζ ∑_j t_j (D_j, d̃_+))
            = exp(∑_j t_j D̄_j) · ∏_j exp(t_j ζ)^{(D_j, d̃_+)}

which is the display with `x_j = exp(t_j ζ)` and `d̃_+ = d_+ + φ_+`. **Both the formula and the
identification of `d̃_+` with "bubble degree together with the affine cocharacter degree" are
verified correct against the source.**

One presentational-plus point. "Extracting the trivial character in all `x_j` forces `d̃_+ = 0`"
reads as though `x_j` and `t_j` were independent variables; they are not — `x_j = exp(t_j ħ)`. The
argument that actually works is linear independence of characters: the total is a finite sum of
(polynomial in `t`) × `exp(ħ ∑_j t_j (D_j, d̃_+))` over the allowed degrees, and picking the terms
whose exponential rate vanishes identically as a linear form in `t` forces `(D_j, d̃_+) = 0` for all
`j`, hence `d̃_+ = 0` by condition (iii). This should be said, since without it the step looks like a
variable-independence error.

Pointedness then forces `d_+ = 0` and `φ_+ = 0` separately — but note that this requires the
cocharacter degree `φ_+` to lie in the "effective infinity-side degree semigroup", which is a
reading of condition (iii) the definition does not spell out.

### 4.6 Nothing else assumes an ordinary marking

`a_p` occurs in `sections/08-global-transport.tex` at l. 28, 116–117, 143, 201, 222, 261, 272, 350.
Every occurrence is either the definition, the restriction display, or the output-slot discussion.
No residual "ordinary marking" reading survives in §8. `sections/03-simple-wall.tex` uses the same
symbol `a_p` for a different (Gu–Yu–Yu simple-wall) class — a symbol reuse across sections, worth a
sentence disambiguating them, but not a logical defect.

---

## 5. Item 1 continued — the Kalkman normalization (required repair 7)

Manuscript:

> Only the two endpoints survive the virtual Kalkman identity. Their signs and node factors agree
> with Woodward's localized adiabatic identity.

This is the entire justification for `eq:support-collapse-row` being an *unsigned* equality
`𝔯_{Y_-,p_-}A_- = 𝔯_{Y_+,p_+}A_+`. A Kalkman/VGIT sweep produces
`(endpoint at L_-) − (endpoint at L_+) = ∑_{walls} (wall terms)`, and each endpoint contribution is
divided by its own virtual normal Euler class in the master space. Two things are asserted without
computation:

1. that the two endpoint normal normalizations are equal (so that no relative factor survives);
2. that the sign convention makes the surviving identity an equality rather than a difference with a
   sign.

Note also that `eq:virtual-normal-euler`'s `(∓ζ)(∓ζ-ψ)` factors are the **rotation** localization's
node and attaching factors, not the polarization master space's, so they cannot be the source of the
claimed agreement. Nothing in the read scope exhibits the polarization-side normalization.

**Verdict: GAP.** The identity is very likely right; the argument for it is one sentence of
assertion. What it would take: write out the two `t = ±1` fixed-component contributions of the
master space with their normal Euler classes, or cite a statement of the Kalkman formula in
Woodward's normalization (QK III does not state one in the read scope).

---

## 6. Item 2 — `rem:iv-semistable-restriction`

Manuscript:

> For a smooth projective \(W\) with \(\Gm\)-action the Bia{\l}ynicki--Birula decomposition makes
> \(H^*_{\Gm}(W;\Q)\) a free module over \(H^*(B\Gm;\Q)\), so the restriction
> \(H^*_{\Gm}(W)\to H^*_{\Gm}(W^{\Gm})\) is injective.

**Hypotheses check.** Freeness: correct. `W` smooth projective with a `G_m`-action has a filtrable
Białynicki-Birula decomposition into affine bundles over the (automatically smooth, in
characteristic zero) fixed components; all cells are even-dimensional, the Gysin sequences
degenerate, and `H^*_{G_m}(W;Q)` is free over `H^*(BG_m;Q)`. The remark does not need the fixed
locus to be assumed smooth (it is), but it *does* need filtrability, which holds for `W` projective
and should be named. Rational coefficients are the right choice and are used.

**The implication is a non-sequitur.** Freeness gives torsion-freeness, and nothing more. The step
that makes restriction injective is the Borel/Atiyah–Bott localization theorem: the kernel and
cokernel of `H^*_T(W) → H^*_T(W^T)` are `H^*(BT)`-torsion. Combining "kernel is torsion" with
"module is torsion-free" gives injectivity. The manuscript's "so" skips the localization theorem
entirely.

**Is the conclusion the one the manuscript needs?** Yes. It needs: no nonzero class vanishes on
every fixed component, hence condition (iv) cannot be widened. That follows once injectivity is
established, together with `[p_\pm] \ne 0` in `H^{2\dim Y_\pm}(Y_\pm)`, which holds since `Y_\pm` is
a projective GIT quotient and the class sits in top degree. Degree bookkeeping checks out:
`a = PD[\bar O]` has equivariant degree `2(\dim W - 1) = 2\dim Y`.

**Verdict: conclusion TRUE, argument has a one-clause GAP.** Required repair 4.

A secondary wording issue: "The vanishing needed in the polarization sweep is only on the fixed
components that the distinguished output evaluation can reach … and those are semistable …; that is
what Lemma `lem:orbit-cylinder-disjoint`(b) supplies." Clause (b) supplies the *vanishing on*
semistable components; the *reachability* claim comes from González–Woodward Lemma 3.17, proved
inside `prop:support-collapse`. The antecedent of "that" is ambiguous and reads, on a cold pass, as
attributing reachability to (b).

### 6.1 `lem:orbit-cylinder-disjoint` itself — recomputed, correct

I verified the whole lemma independently.

*Fibre-weight criterion.* Embedding `W ⊂ P(V)` by sections of a power of `M`, for
`v = ∑_k v_k`: `lim_{t→0}[t·v] = [v_{k_min}]`, `lim_{t→∞}[t·v] = [v_{k_max}]`; the fibre of `O(-1)`
at `[v_k]` is `C·v_k` with weight `k`, so `O(1)` has fibre weight `-k`; Hilbert–Mumford gives
semistability iff `k_min ≤ 0 ≤ k_max`. Translating, `μ_M(y_0) = -k_min` and
`μ_M(y_∞) = -k_max`, so the criterion becomes `μ_M(y_∞) ≤ 0 ≤ μ_M(y_0)` — **exactly**
`eq:gm-weight-criterion`. Correct, including the strict form for stability and the fixed-point
corollary `μ_M(w) = 0`.

*(a)* Trivial stabilizer from freeness ⇒ `O ≅ G_m`; closure in projective `W` is the image of
`P^1 → W`, adding exactly the two limits. Strictness at `L_-` gives `μ_0(w_0) > 0 > μ_0(w_∞)`, hence
`w_0 ≠ w_∞`. Correct.

*(b)* `μ_u(w) = (1-u)μ_-(w) + u μ_+(w)` is affine in `u`; positive at both endpoints ⇒ positive on
`[0,1]`; a fixed component semistable at `L_u` has `μ_u ≡ 0` on it; `μ_u` is constant on a connected
`F`. Hence `\bar O ∩ F = ∅`. Correct.

*(c)* Restriction of an equivariant Poincaré dual to an open invariant subset is the dual of the
intersected cycle; under a free quotient `PD[O]` becomes the point class. The vanishing `a|_F = 0`
follows because the class factors through cohomology supported on `\bar O`, and
`\bar O ∩ F = ∅`. Correct.

I found no error in this lemma. It is the strongest-standing piece of the read scope.

---

## 7. Item 3 — `eq:total-moving-slope` and the Stirling estimate

### 7.1 The slope identity

Manuscript:

    ∑_a h_a = c_1^{G_m}(TW) · δ

Independent derivation. `T([W/G_m])` is the cone `g ⊗ O → TW`, so
`c_1(T([W/G_m])) = c_1^{G_m}(TW)` (the Lie-algebra term is a trivial bundle of degree zero for
abelian `G`). For a genus-zero domain and degree `d = d_0 + kδ`,
`χ(u^*T([W/G_m])) = c_1^{G_m}(TW)·d + \mathrm{rk}`, whose slope in `k` is `c_1^{G_m}(TW)·δ`.
Splitting the index into a virtual line of degree `n_a(k) = h_a k + s_a` gives
`χ = ∑_a (n_a + 1) = k∑_a h_a + ∑_a(s_a + 1)`, slope `∑_a h_a`. Subtracting the fixed part (constant
along a tail by `thm:tailwise-derived`) and the gauge Lie algebra (degree zero) leaves the moving
index carrying the whole slope. **Verified correct**, including the unsigned form: `χ(O(n)) = n+1`
holds for every `n ∈ Z` on `P^1`, and for `n < 0` it is `-h^1`, which is exactly what removes the
temptation to insert `sign(n_a)`. The manuscript's explanation of that point is correct.

`eq:adjacent-gamma-ratio`, `(hk+a)^{-1} = Γ(hk+a)/Γ(hk+a+1)`, is correct from `Γ(x+1) = xΓ(x)`, and
contributes zero slope. `eq:gamma-index-factor` is correct in both directions:
`ζ^{-n-1}Γ(α/ζ)/Γ(α/ζ+n+1) = 1/∏_{m=0}^{n}(α+mζ)` for `n ≥ 0`, and for `n ≤ -2` the same expression
equals `∏_{m=n+1}^{-1}(α+mζ)`, which has `-n-1` factors — the rank of `H^1(P^1, O(n))`. I checked
`n = -1` (empty product, `H^1 = 0`, Euler class 1) and `n = -3` (`(α-ζ)(α-2ζ)` both ways) explicitly.
`eq:simple-gamma-residue` is also correct: `Res_{u=-m}Γ(u) = (-1)^m/m!` and `du = h\,dσ` give
`(-1)^m/(h\,m!)`.

**Two GAPs remain.**

*Orbifold Riemann–Roch.* `χ(O(n)) = n+1` is the smooth `P^1` statement. The manuscript's domains are
weighted lines `P(1,k)` with a `BZ_k` point, and it disposes of this with "Pass to a finite cover
which clears stabilizer denominators". That relocates the computation but does not show the slope
identity descends: an orbifold index carries age/degree-shift corrections, and consecutive affine
degrees along a tail differ by `k` (`prop:app-mu-k`(b)), not by 1. Nothing in the read scope
reconciles the two indexings. This is a bookkeeping gap, not a demonstrated error.

*Invertibility versus nilpotence.* The proof says Chern roots `α_a` are "nilpotent at Artin level",
and the closeout of `prop:clutching-tail-holonomicity` repeats that "the nilpotent Chern roots
contribute only bounded factors". But `eq:gamma-index-factor` inverts `∏_{m=0}^{n}(α_a + mζ)`,
whose `m = 0` factor is `α_a` itself. A genuinely nilpotent `α_a` is not invertible. What is meant
is presumably that `α_a` has a nonzero equivariant weight plus a nilpotent correction — which is the
usual localization hypothesis that the virtual normal Euler class is invertible. It is never said.

### 7.2 The `\log|c_k|` expansion — recomputed end to end

Manuscript:

    log|c_k| = -(∑_a h_a) k log k - k ∑_a h_a log|h_a| + (∑_a h_a) k + O(log k)

My independent computation, `n_a = h_a k + s_a`:

*`h_a > 0` (so `n_a → +∞`).* `|1/∏_{m=0}^{n_a}(α_a + mζ)| ≍ 1/(n_a! · |ζ|^{n_a})` up to bounded
factors, so

    log = -(n_a log n_a - n_a) - n_a log|ζ| + O(log n_a)
        = -h_a k log k - h_a k log h_a + h_a k - h_a k log|ζ| + O(log k).

*`h_a < 0` (so `n_a → -∞`).* The `H^1` Euler class `∏_{m=n_a+1}^{-1}(α_a + mζ)` has
`|n_a| - 1` factors of magnitude `≍ m|ζ|`, so

    log = |n_a| log|n_a| - |n_a| + |n_a| log|ζ| + O(log|n_a|)
        = -h_a k log k - h_a k log|h_a| + h_a k - h_a k log|ζ| + O(log k),

using `|n_a| = -n_a` and `\log|n_a| = \log k + \log|h_a| + O(1/k)`.

**The two rays give literally the same expression** — the manuscript's key uniformity claim, and it
is correct. The manuscript's per-root statements are also correct as printed: `-n_a\log n_a + n_a`
for `n_a ≥ 0`, and `|n_a|\log|n_a| - |n_a| = -n_a\log|n_a| + n_a` for `n_a < 0`. The `h_a = 0`
treatment is correct: `n_a` is then constant along the tail, so the factor is `k`-independent and
bounded, `log|h_a|` would be undefined, and excluding those roots does not change `∑_a h_a`.

**The one discrepancy** is the term `-(∑_a h_a)k\log|ζ|`, present in my computation and absent from
the display. Under `eq:neutral-direction` it vanishes, so no downstream conclusion moves; but the
display is stated as the general expansion and then neutrality is applied to it, so the omission is
in the wrong order. Required repair 9.

*Sizes componentwise in a `C`-basis of `R_N`.* This is the right device — `R_N` is a
finite-dimensional `C`-algebra, so coefficientwise magnitudes in a fixed basis are equivalent up to
constants to any submultiplicative norm — and it makes the nilpotent Chern-root contributions
bounded (subject to §7.1's invertibility caveat). Accepted. Note that `ζ` is treated as having a
magnitude, i.e. specialized to a nonzero complex number; the manuscript never says so, and this is
the same latent issue as the omitted term.

*The rescaling.* "The remaining exponential rate `-∑_a h_a log|h_a|` is removed by one rescaling" is
correct: it is a term linear in `k`, so it is absorbed by `x ↦ λx`.

---

## 8. Item 4 — the finite-order boundary-value paragraph

Manuscript:

> Choose an integer \(q>N+2\) and set \(b_k=c_k/(ik)^q\) for \(k\neq0\) and \(b_0=0\); the one
> omitted term is a constant and changes nothing. Then \(\sum_kb_k\) converges absolutely …
> applying \(\partial_\theta^q\) recovers \(\sum_kc_kr^ke^{ik\theta}\).

**Recomputed, and correct.**

- Convergence: `|b_k| ≤ C k^{N-q}(\log k)^M`, and `∑ k^{N-q}(\log k)^M < ∞` iff `q - N > 1`. The
  chosen `q > N+2` is comfortably sufficient (`q > N+1` would already do; the extra margin is
  harmless).
- Uniformity: Weierstrass `M`-test gives uniform convergence in `θ` for all `r ≤ 1` simultaneously,
  so the radial limit at `r = 1` is the uniform limit of continuous functions, hence continuous.
- The exponent bookkeeping: `∂_θ^q (b_k r^k e^{ikθ}) = (ik)^q b_k r^k e^{ikθ} = c_k r^k e^{ikθ}`.
  Correct for every `k ≠ 0`.
- The omitted constant term: with `b_0 = 0`, the reconstruction misses `c_0`, a constant function of
  `θ`, i.e. an order-zero distribution. "Changes nothing" is right. (For a tail beginning at
  `k_0 > 0` the term is not even present.)
- `D'(S^1)`: uniform convergence implies convergence in `D'`, distributional differentiation is
  continuous, so `∂_θ^q` of a continuous function has order at most `q`. Correct.

**"Uniform on the tail".** The sentence "The bound on `q` depends only on the exponents `N, M`,
which are uniform on the tail, so the order is uniform as well" is true but nearly tautological as
stated: `N` and `M` are the exponents in a bound asserted to hold for all `k` on the tail, so their
"uniformity on the tail" is part of the hypothesis, not a conclusion. If the intended content is
uniformity *across* the finitely many tails, threshold classes, or Artin levels, it should say so;
as written it justifies nothing that was in doubt. Presentational.

**"(D)-finite" usage.** The meaning is used consistently: a linear recurrence with polynomial
coefficients in the degree, i.e. `P`-recursive. The equivalence with a linear ODE with polynomial
coefficients is a purely formal substitution valid over any commutative ring, so calling this
"(D)-finite over `R_N`" is defensible and the disclaimer about "holonomic" is well taken. Two
defects:

- `sections/08-global-transport.tex` l. 752 and 754 set `(D)-finite` in **text mode**, while every
  other occurrence in the manuscript (l. 706, 710, 801, 815, 882, 897, 1178, 1254; `08-scope.tex`
  l. 46, 67; `01-introduction.tex` l. 124) uses `\((D)\)-finite`. Inconsistent typesetting inside
  the very proof that establishes the property.
- The label `prop:clutching-tail-holonomicity` and the phrase "holonomicity" survive in
  `08-scope.tex` l. 46's cross-reference target. The repair report says the label was kept
  deliberately for anchor stability, which is a reasonable trade; it should be noted in the source
  so the next reader does not "fix" it.

---

## 9. Item 5 — chart independence in `prop:app-one-chart`

### 9.1 The counterexample

Manuscript: `W = P^1`, `t·y = ty`, `a = +1`; on `V_0 = Spec C[y]` the coordinate has weight `+1`, no
weight space is killed, no condition; on `V_∞ = Spec C[y^{-1}]` the coordinate has weight `-1`, so
`I_a = (y^{-1})` and the chart imposes `y^{-1} = 0`.

**Recomputed and correct.** `I_a = (A_w : aw < 0)`: for `A = C[y]` with `y` of weight `+1` and
`a = +1`, all weights are `≥ 0`, so `I_a = 0`. For `A = C[y^{-1}]` with `y^{-1}` of weight `-1`,
`I_a = (y^{-1})`. On the overlap `G_m = \{y ≠ 0, ∞\}` the first condition holds everywhere and the
second holds nowhere, so they disagree at every overlap point. The refutation of the old
separatedness argument is sound, and the accompanying sentence — "Separatedness makes an extension
unique once it exists in a given chart; it does not make it exist" — states the correct logic.

The counterexample is also a clean instance of the exclusion clause: with `a = +1`, `F = \{y = 0\}`
and `W_F^a = A^1 = V_0`; the chart `V_∞` is disjoint from `F` and its chartwise condition selects
`\{∞\}`, which is `W_{F'}^{a}` for the *other* fixed component `F' = \{∞\}`. So "charts disjoint
from `F` compute a different stratum" is literally true here. **Verified correct.**

### 9.2 The invariance argument, including negative exponent

Manuscript: given `x ∈ W_F^a` and `y = \lim_{t→0} t^a x ∈ F`, choose an invariant affine `U ∋ y`;
by continuity of `A^1 → W`, `t ↦ t^a x`, `t^a x ∈ U` for small `t ≠ 0`; by invariance `x ∈ U`; hence
the whole completed orbit lies in `U`.

**Correct for every `a ≠ 0`, negative included.** For `a < 0`, `t ↦ t^a x` is a morphism on `G_m`
which extends across `t = 0` precisely because `x ∈ W_F^a`; the extension is a morphism `A^1 → W`,
so continuity applies unchanged. The invariance step is `x = (t^a)^{-1}·(t^a x) ∈ U`, which uses
only that `U` is `G_m`-invariant and `t^a ≠ 0`. The sign of `a` never enters. The conclusion "the
whole completed orbit lies in `U`" is right: the orbit by invariance, the limit by choice of `U`.

`lem:app-sign` is likewise correct: `aw < 0` is `sign(a)w < 0`, so `I_a` depends only on `sign(a)`,
and `I_0 = 0`. `lem:app-cech`'s sign convention is also correct — I checked the stated example
(`W = A^1`, `t·y = t^k y`, `a > 0`: the coordinate has weight `k`, `∂_y` has weight `-k`, and
`aw ≤ 0` retains it, matching the attracting locus being all of `A^1`), and the opposite case
(`k < 0`: attractor `\{0\}`, `∂_y` of weight `|k| > 0`, excluded).

### 9.3 The family form — GAP (required repair 6)

Manuscript:

> the invariant affine charts meeting \(F\) are opens of \(W\) covering \(W_F^a\) by the previous
> paragraph, so for an \(R\)-point \(x\) of \(W_F^a\) their preimages \(x^{-1}(U)\) are an open cover
> of \(\operatorname{Spec}R\); Zariski-locally on \(\operatorname{Spec}R\) the point \(x\) factors
> through one such \(U\), and then so does the whole section \(z\mapsto z^ax\), by invariance of
> \(U\) again.

Invariance of `U` gives `z^a x ∈ U` only for `z ≠ 0`. The value of the section at `z = 0` is the
limit, and `x ∈ U` does **not** imply `\lim_{t→0} t^a x ∈ U` — that is precisely the content the
counterexample two paragraphs earlier exhibits. So the cover `\{x^{-1}(U)\}` is the wrong one.

The fix is one line and uses only what the previous paragraph already proved. Set

    U_F := { x ∈ U : lim_{t→0} t^a x ∈ U ∩ F },

which is open in `W_F^a` (the limit map `W_F^a → F` is a morphism, `U ∩ F` is open in `F`, and `U`
is open in `W`). The previous paragraph shows exactly that the `U_F` cover `W_F^a`. Taking
`x^{-1}(U_F)` then gives an open cover of `Spec R` on which the whole section, `z = 0` included,
factors through `U`.

Non-reduced and simplicial test algebras are handled correctly otherwise: the underlying topological
space of `Spec R` is that of `Spec π_0(R)`, and the graded splitting of
`lem:app-graded-extension` is levelwise in the simplicial direction, which the lemma's proof states
explicitly and correctly.

### 9.4 Descent to the quotient stack, and absence of derived structure

The graded-Picard argument is correct and the caveat is well placed: a rotation-equivariant
`G_m`-bundle on `P^0_R` is a graded invertible `R[z]`-module, the graded Picard group of `R[z]` is
`Pic(R) × Z`, and the nonequivariant analogue does fail for non-reduced `R`. The identification of
rotation-invariant gauge transformations over `P^0` with the constants `G_m(R)` is correct.

The absence of derived structure is argued correctly: quasicoherent cohomology of
`[A^1/C^×_{rot}]` vanishes in positive degrees (affine plus exactness of invariants in
characteristic zero), so the deformation complex is concentrated in degree zero and the stack is
smooth and classical. Consistent with Białynicki-Birula, as the manuscript notes.

---

## 10. Item 6 — the obstruction-theory import boundary

### 10.1 The bound is honest, but `prop:app-square` spends more than it (required repair 1)

`lem:app-truncation` proof, final sentences:

> Hence the two morphisms have the same deformations and obstructions for every square-zero
> extension of classical test schemes, which is the level at which Woodward's morphism is specified
> and at which the virtual class is formed; no more is claimed, and no general recognition theorem
> is used.

`prop:app-square` proof, final sentences:

> A commuting square whose verticals are quasi-isomorphisms is an isomorphism of the two morphisms
> to the cotangent complex, which is the assertion for obstruction theories. … An isomorphism of
> relative perfect obstruction theories over a common base induces equality of the associated
> virtual classes, because the intrinsic normal cone and its embedding into the obstruction bundle
> depend only on the morphism to the cotangent complex \cite{BehrendFantechi}.

These do not match. Behrend–Fantechi's virtual class is built from the closed embedding
`𝔑_X ↪ 𝔈 = h^1/h^0(E^∨)`, which is `h^1/h^0` applied to `φ^∨`. Since `h^1/h^0` is an equivalence
between `D^{[0,1]}` and Picard stacks (Behrend–Fantechi §2), that embedding remembers the *homotopy
class* of `φ`, not merely its induced deformation–obstruction assignment. The lemma delivers the
latter; the proposition consumes the former.

There is a plausible bridge — sections of `𝔑_X` are classified by square-zero extension data, and
`conv:app-obstruction-morphism` deliberately includes "the torsor structure on its extensions", which
is the `h^0` half — so the gap is likely closable. But it is not closed in the text, and the
proposition's phrasing "no more is claimed" in the lemma directly advertises the shortfall.

**Verdict: GAP.** What it would take: a statement (with proof or citation) that two morphisms
`E → L_{t_0 𝔛/𝔐}` inducing the same obstruction class and the same torsor of extensions for every
square-zero extension of every classical test scheme induce the same morphism of Picard stacks
`𝔑 → 𝔈`; then Behrend–Fantechi applies as cited.

The statement of `lem:app-truncation` is itself stated as an equality of morphisms ("… is the
composite …"), which the proof does not establish. Either the statement should be qualified or the
proof extended.

### 10.2 `thm:tailwise-derived` contradicts `prop:app-square` (required repair 2)

`thm:tailwise-derived` (§8, l. 664–669):

> on the two-chart \v{C}ech presentation both composites are the same difference of restrictions to
> the open orbit, so the comparison homotopy may be taken to be the identity
> (Proposition~\ref{prop:app-square}).

`prop:app-square` (appendix, l. 528–534):

> What this identifies strictly is the left vertical arrow, together with its source and target: it
> compares the differentials of the two presentations of the same two-term complex, and **it says
> nothing about the classical truncations through which the two composites factor.** The
> \(2\)-commutativity of the square is the previous paragraph and does not depend on it.

The section-8 sentence asserts a property *of the composites*; the appendix explicitly withholds
exactly that property and attributes it to nothing. The cross-reference makes the appendix the
authority for a claim the appendix denies. Required repair 2: rewrite the section-8 sentence to say
that `2`-commutativity comes from functoriality of the truncation transformation at the equivalence
`ev_1`, and that the Čech computation identifies the left vertical arrow strictly.

The appendix paragraph is itself muddled: it first computes "both composites in the square" and
concludes "the two representatives are equal", then says the computation identifies only the left
vertical arrow. Those two sentences need reconciling regardless of what section 8 says.

### 10.3 `conv:app-obstruction-morphism`

As a convention this is legitimate and the honest move: QK III Definition 7.13 does specify only the
complex `(Rp_* e^* T(X/G))^∨` and does not write a morphism to the cotangent complex — I confirmed
that from the extraction of Definition 7.13(a)–(c), which names the complex and jumps straight to
"Hence one obtains a virtual fundamental class". Fixing the Illusie–Kodaira–Spencer reading is the
standard one and makes the comparison a statement. No objection, subject to §10.1.

---

## 11. Item 7 — citations and locators in the read scope

### 11.1 QK III Section 9.4 (required repair 5)

Appendix opening:

> the relative perfect obstruction theory on the rotation-fixed locus, induced from the ambient one
> \cite[Section~9.4]{WoodwardQKIII}, whose fixed-part step is \cite{GraberPandharipande}

`lem:app-truncation` repeats the same characterization. What §9.4 actually says (read directly from
the cache, l. 2642–2646):

> It follows that `F^G_{n±,1}(d)` is a proper Deligne-Mumford stack. It admits a relative perfect
> obstruction theory over `M_{n±,1}(P(1,k))` **induced from the relative perfect obstruction theory
> on `M^G_{n±,1}(P(1,k), X, d)^{C^×}`**.

Three mismatches, all in the same sentence:

1. **Direction.** §9.4 induces *from* the fixed locus *to* `F^G_{n±,1}(d)`. The manuscript wants
   induction *from the ambient* stack *to* the fixed locus. §9.4 assumes the latter has already been
   done, and does not do it.
2. **Object.** `F^G_{n±,1}(d)` is the "contribution from `0`/`∞`" locus including attached stable
   maps; the manuscript's `𝔖_{a_-,a_+}` is the principal clutching factor
   (`M^{G,fr}_2(P,X,d_0)^{C^×}` in (54)). Different stacks.
3. **Attribution.** §9.4 contains no reference to Graber–Pandharipande at all.

The statement the manuscript wants, with exactly the attribution it wants, is **González–Woodward
Corollary 3.20** (read directly, l. 3452–3462):

> **Corollary 3.20.** (Obstruction theory for the fixed point components) `M^{G_ζ}_n(C, X, L_t, ζ)`
> is an Artin stack, and if every automorphism group is finite modulo `C^×_ζ`, each substack with
> fixed homology class `d` is a proper Deligne-Mumford stack with a `C^×`-equivariant relatively
> perfect obstruction theory over `M_n(C)`. *Proof.* The relatively perfect obstruction theory … is
> pulled back from that on the `C^×`-fixed point set in `M^G_n(C, X, L_-, L_+)^{C^×}` in Proposition
> 3.18. **The latter is a special case of existence of relatively perfect obstruction theories on
> fixed point loci discussed in [31].**

and González–Woodward's `[31]` is Graber–Pandharipande, *Localization of virtual classes*, Invent.
Math. 135 (1999) 487–518 — I checked the bibliography line (l. 4381). This is a clean, exact
locator for both halves of what the manuscript asserts.

**Verdict: CITATION.** The mathematical content is fine; the locator names a statement about a
different object and omits the source that does say it.

### 11.2 Locators verified correct

- `\cite[Corollary~9.10(c)]{WoodwardQKIII}` for `\widetilde d_+`: verified, `exp(γ̄ + (d_+ + φ_+, γ)ζ)`
  is exactly bubble degree plus affine cocharacter degree.
- `\cite[Lemma~3.17 and Proposition~3.18]{GonzalezWoodward}`: verified statement and proof; the
  principal component maps to `X^{ζ,t}/G_ζ` with `X^{ζ,t}` the `L_t`-semistable locus of `X^ζ`, and
  every non-endpoint `C^×`-fixed component of the master space arises this way with `ζ ≠ 0`.
- `\cite[Remark~3.19]{GonzalezWoodward}`: verified in full; the extraction note's truncation warning
  is discharged. The manuscript's paraphrase is accurate. (Caveat recorded in §4.3: the fibre
  product is over `(X^ζ)^r`, not `(X^{ζ,t})^r`.)
- `\cite[Proposition~3.15(c)]{GonzalezWoodward}` as the weaker marking statement: verified; it does
  place any node or marking only in `P(X^Z)`, with no semistability, and `C^×_ζ` is central in
  `G_ζ` (Definition 3.16 says so explicitly), so the application is legitimate.
- `\cite[Example~9.15]{WoodwardQKIII}` for the irreducible unstable type: consistent with the
  extraction ("The domain of any gauged map without markings is irreducible and the normal complex …
  is the moving part").
- `refs.bib` metadata for `BehrendFantechi`, `GraberPandharipande`, `SchurgToenVezzosi`,
  `ToenVezzosiHAGII`, `MumfordGIT`, `Wlodarczyk`: all correct as bibliographic records.

### 11.3 Locators not verifiable this pass

- `\cite[Chapter~2, \S2.1, Theorem~2.1]{MumfordGIT}` — GIT is not in the cache. **UNVERIFIED.**
  Mitigating: the manuscript does not lean on the citation, since it derives the fibre-weight form
  explicitly and correctly from the projective embedding, and that derivation is self-contained.
  Verification would take a copy of GIT (3rd ed.) and a check that Theorem 2.1 of Chapter 2 is the
  numerical criterion rather than a neighbouring statement.
- `\cite[Proposition~2(B')]{Wlodarczyk}` — not in the cache. **UNVERIFIED**, and it is load-bearing
  three times in the read scope (l. 72, 269, 384) for the existence of the smooth projective
  equivariant completion with the two endpoint quotients and the cylinder, and for the terminology
  point about "projective" meaning quasiprojective. Verification would take fetching
  `arXiv:math/9904074` into the cache and reading Proposition 2 and its proof.
- `\cite{BehrendFantechi}` for invariance of virtual classes: the content is immediate from their
  construction, but the citation is bare (no section or theorem number) for a claim the manuscript
  states as a named implication. Adding a locator would make it checkable.
- QK II Proposition 5.21, QK III Proposition 7.14(b), QK II §4.3 / Proposition 4.3(f),(g), QK II §6 —
  used in the appendix, verified only against the extraction note, not against the PDF this pass.
  **UNVERIFIED** at the primary-source level.

---

## 12. Presentational findings

1. **Notation collision on `ζ`** (required repair 8). In `sections/08-global-transport.tex`, `ζ` is
   the wall cocharacter in `g` at l. 210–228 and Woodward's rotation equivariant parameter at
   l. 436, 455–458, 764. Meanwhile `\hbar` is introduced for the rotation parameter at l. 178 and
   188 and used nowhere else, so the same object has two names and one of those names has two
   meanings. Both conventions are inherited from the sources (González–Woodward's `ζ ∈ g`,
   Woodward's `ζ` for the equivariant parameter), which is why it needs an explicit remark rather
   than a silent choice.
2. **`eq:endpoint-gauged-maps` attributed to equation (68).** Equation (68) is the identity
   `τ_{X//G,-} ∘ κ^G_X = τ^G_{X,-}` paired against `α_∞`. The manuscript's display defines
   `A_± = Dτ_{Y_±,-} Dκ_±` and calls that "the localized adiabatic identity (68)". The derivative
   form follows by the chain rule, but the display as printed is a definition, not the cited
   identity. One clause would fix it.
3. **Intro misattribution** (required repair 10). `01-introduction.tex` l. 116–117: "and rotation
   localization then removes every wall contribution". The wall contributions are polarization-wall
   terms in the Kalkman sweep; rotation localization produces the graph factor and the Liouville
   degree extraction. Say "the polarization sweep's wall terms then vanish".
4. **`(D)`-finite typesetting** at `08-global-transport.tex` l. 752, 754 (text mode, versus math mode
   everywhere else).
5. **Symbol reuse of `a_p`** between `03-simple-wall.tex` (Gu–Yu–Yu class) and
   `08-global-transport.tex` (orbit-cylinder class). A one-sentence disambiguation at the second
   introduction would help a cold reader.
6. **Ambiguous antecedent** in `rem:iv-semistable-restriction` (see §6): "that is what
   Lemma …(b) supplies" appears to attribute reachability to clause (b), which supplies vanishing.
7. **`prop:app-square`'s internal tension** (see §10.2), independent of the section-8 sentence.
8. **`08-scope.tex` item (5)** is accurate as rewritten and matches the mechanism the proof runs. I
   found nothing to repair there beyond the consequences of repairs 3 and 7 propagating into its
   wording ("computed from the principal component" is right; if repair 3 is applied, the scope item
   needs no change).

---

## 13. Answers to the specific questions posed

- *Is there really a distinguished output slot in Woodward's localized graph potential?* Yes —
  QK III §9.4's evaluation `F^G_{n±,1}(d) → I_{X//G}` at `BZ_k`, equivalently the map (55), and it is
  the slot `α_∞` occupies in equation (68).
- *Is it a parametrized-point evaluation?* Yes: `BZ_k ⊂ P(1,k)` is a fixed point of the parametrized
  domain, and the section is constant in a trivialization near it by the definition of
  `F^G_{n±,1}(d)`.
- *Is the evaluation at a parametrized point over which a bubble tree sits genuinely the
  principal-side value?* The premise is off: at the slot in question, no bubble tree sits, because
  the defining condition of `F^G_{n±,1}(d)` is constancy near `BZ_k`. The bubble trees attach at
  `0`/`∞`, at the value `lim φ̃_±(z)x`. Required repair 3.
- *Does `lem:point-insertion-row` live in that slot?* Yes as a slot claim; its Gamma/unitarity
  content is UNVERIFIED for want of a citation.
- *Does the endpoint contribution remain exactly `c_n(z)^{-1} 𝔯_{Y,p} Dτ_{Y,-} Dκ`, including under
  further derivatives?* The algebra is consistent and the derivative commutation argument is sound.
  The Kalkman-side normalization behind the unsigned equality is a GAP (repair 7).
- *Does anything elsewhere still assume `a_p` at an ordinary marking?* No.
- *Is the vanishing complete for every wall fixed-locus type?* Yes; González–Woodward Proposition
  3.18 makes the case split exhaustive, and the irreducible unstable type is covered.
- *Does any required repair change a theorem statement?* No. Every finding is a repair to a proof
  step, a citation, or wording. The two that would matter most if they could not be repaired —
  repair 1 (virtual-class equality) and repair 3 (the evaluation slot) — both have visible fixes
  that leave `thm:tailwise-derived`, `prop:support-collapse`, and
  `thm:birational-point-primary` as stated.

---

## 14. Coverage — what I did not reach

- `sections/08-global-transport.tex` beyond l. 797: `rem:two-tail-threshold-obstruction`,
  `def:finite-dual-cyclic-rees`, `hyp:marked-threshold-wall`, `def:reduced-nearby`,
  `hyp:marked-threshold-zero`, and everything after them. Out of scope by instruction, but note
  that `hyp:marked-threshold-wall` refers back to `eq:support-collapse-row` and to the `(D)`-finite
  tails, so repairs 7 and 9 touch its statement of what is being compared.
- `rem:neutral-boundary`'s characterizations of Aleshkin–Liu Definition 5.18 / Theorem 5.21 and
  González–Woodward Remarks 1.18(d), 4.6, 4.7 and equation (47). Read but not source-checked; the
  prior cold read also left these open. Aleshkin–Liu is not in the cache.
- Wlodarczyk Proposition 2(B') — not in the cache, not fetched.
- Mumford GIT Chapter 2 §2.1 Theorem 2.1 — not in the cache.
- QK II directly (Proposition 5.21, Example 6.6(c), §4.3, Proposition 4.3(f),(g), §6). I relied on
  the extraction note for these; the note's own caveat about `pdftotext` index ranges applies.
- QK III Proposition 7.14(b) and equations (54)–(59) beyond the extraction note's transcription.
- The appendix's `prop:app-mu-k` and `prop:app-cutting` were read and no error surfaced, but I did
  not independently verify the rigidified-inertia factor-of-`r` bookkeeping in
  `prop:app-mu-k`(d) against QK II Proposition 4.3(f),(g), nor the derived cotangent triangle of
  `prop:app-cutting`(a) against QK III equation (35) and §7.1, beyond the extraction.
- `sections/03-simple-wall.tex` was grepped for `a_p` only; not reviewed.
- No LaTeX build was run; all findings are from source, not from the compiled PDF.
