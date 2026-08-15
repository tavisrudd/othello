# C913 cold read, round 5 — gauged transport and the one-chart appendix

Independent referee read. No prior involvement with this manuscript.

Manuscript: `papers/cubic-stabilization-irrationality/`, frozen at `46500c918`. The working
tree at `652732667` has no diff under `papers/cubic-stabilization-irrationality/` against
that commit (`git diff --stat 46500c918 HEAD -- papers/cubic-stabilization-irrationality/`
is empty), so the frozen text and the tracked text are the same bytes. The LaTeX log has no
undefined-reference, undefined-citation, or multiply-defined warnings.

## Scope and method

Read in full and judged:

- `sections/08-global-transport.tex`, lines 1–914: section opening, `def:gauged-admissible`,
  `rem:iv-semistable-restriction`, the clause-by-clause standing paragraph,
  `rem:endpoint-only`, `lem:point-insertion-row`, `prop:support-collapse`,
  `lem:orbit-cylinder-disjoint`, the Włodarczyk-completion discussion,
  `prop:gamma-ratio-reduction`, `rem:higher-pole-localization-boundary`,
  `rem:neutral-boundary`, `thm:tailwise-derived`, and
  `prop:clutching-tail-holonomicity` through the end of its proof.
- `sections/appendix-one-chart.tex` in full.
- `sections/08-scope.tex` item (5).
- The `sections/01-introduction.tex` paragraph beginning "The conditional proof uses a smooth
  projective equivariant completion" (lines 110–118), plus the surrounding
  `thm:intro-birational-conditional` and standing-assumption paragraphs for context.
- `sections/02-point-row.tex` in full, for `eq:gamma-framed-section`,
  `eq:flat-euler-pairing`, and `def:point-row`.

### Independent recomputation

Every algebraic identity in scope was recomputed from scratch rather than accepted:

- The Gamma index factor `eq:gamma-index-factor` on both degree rays, including the `n<0`
  empty-product convention and the resulting `H^1` Euler class as a product of `|n|-1`
  linear factors.
- The adjacent Gamma ratio `eq:adjacent-gamma-ratio`.
- The moving-character residue `eq:simple-gamma-residue`, from the residue of `Γ` at `-m`
  and the Jacobian of `w = hσ + α`.
- The Riemann–Roch slope identity `eq:total-moving-slope`, from `χ(O(n)) = n+1` on both rays.
- The full Stirling expansion of `log|c_k|` in `prop:clutching-tail-holonomicity`, term by
  term including the `log|ζ|` scale term and the `h_a = 0` roots.
- The distributional argument: summability of `b_k = c_k/(ik)^q` for `q > N+2`, uniform
  convergence for `r ≤ 1`, and recovery by `∂_θ^q`.
- Mumford's numerical criterion in the fibre-weight form `eq:gm-weight-criterion`, rederived
  from `[v_{k_min}]`, `[v_{k_max}]`, the weight `-k` of `O(1)` at `[v_k]`, and
  `0 ∉ closure(G·v)`; then all three parts of `lem:orbit-cylinder-disjoint`.
- The pairing computation behind `eq:point-insertion-row`: `ch(O_p) = [pt]`, triviality of
  `Γ̂` and `z^{c_1}` on the top class, `z^{-μ}[pt] = z^{-n/2}[pt]`, and the unitarity
  cancellation.
- The attractor-algebra computation of `lem:app-graded-extension` and `prop:app-one-chart`,
  checked against the worked example `A = C[u,v]` with weights `±1`.
- The tangent-weight sign flip in `lem:app-cech` (`aw ≤ 0` for tangent directions versus
  `aw ≥ 0` for functions), checked on `A^1` with both signs of the weight.
- The degree bookkeeping of the total complex `[F^0_{≤0}V ⊕ F^∞_{≤0}V → V]`, confirming
  `h^{-1} = ` stabilizer Lie algebra and support in degrees 0 and 1.
- The `μ_k` bookkeeping of `prop:app-mu-k`: `a = b/k`, `aw < 0 ⟺ bw < 0`,
  `φ̃(θ) = θ^b` depending only on `b mod k`.
- Freeness/torsion-freeness and the localization argument of
  `rem:iv-semistable-restriction`.

### Sources consulted

All from the shared disk-backed cache at `/tmp/persistent/tavis/lit-search/`, read as
`pdftotext` extractions with the overline caveat applied:

| Source | Cache key | sha256 (prefix) |
|---|---|---|
| Woodward, Quantum Kirwan III | `arXiv:1408.5869` | `5aa794f4d83dd8d1` |
| Woodward, Quantum Kirwan II  | `arXiv:1408.5864` | (cache `ok`) |
| González–Woodward            | `arXiv:1208.1727` | (cache `ok`) |
| Włodarczyk                   | `arXiv:math/9904074` | (cache `ok`) |
| Aleshkin–Liu                 | `arXiv:2301.01266` | `921af8ed2105d6a5` |

Locators checked one by one against the extracted text: Woodward III Definition 7.13(a),
Proposition 7.14(b), Example 7.1 and equation (35), Definition 9.7, Lemmas 9.8 and 9.9,
Corollary 9.10 including part (c), equations (54)–(57), equation (59) and the Euler-class
display, equations (63)–(64), Example 9.15, Section 9.4 and equation (68); Woodward II
Section 4.3 and Example 4.3(f),(g), Proposition 5.21(a), Example 6.6(c), Section 6;
González–Woodward Proposition 3.15(c), Lemma 3.17, Proposition 3.18, Remark 3.19,
Corollary 3.20, Lemma 3.21 and its proof, Remark 1.18(d), Remark 4.6, equation (47),
Remark 4.7; Włodarczyk Lemma 5 and Proposition 2 with its proof; Aleshkin–Liu
Definition 5.18, Remark 5.20, Theorem 5.21.

---

## Required repairs

**One.**

### R1. `prop:app-cutting`: the fibre-product presentation in part (a) is not the one part (b) argues from

**Where.** `sections/appendix-one-chart.tex`, lines 685–738.

**The text.** The proposition sets up its object as

> Let \(\mathfrak F\) be the fixed graph stack obtained from \(\mathfrak S_{a_-,a_+}\) by
> attaching the fixed stable-map factors of [equations (54)–(57)] along the two inertia
> evaluations, as a derived fibre product.

so `𝔉` has three factors, `M_- ×_I 𝔖_{a_-,a_+} ×_I M_+`, glued along **two** inertia
evaluations — this is Woodward's equation (54). But the proof of (a) computes the cotangent
triangle of a **different**, two-factor presentation:

> (a) is the cotangent triangle of a derived fibre product, applied to
> \(\mathfrak F=\mathfrak F_-\times^{\mathbf R}_{I}\mathfrak F_+\) with \(I\) the inertia
> stack of the quotient: the triangle reads
> \(\operatorname{ev}^*L_I\to L_{\mathfrak F_-}\oplus L_{\mathfrak F_+}\to L_{\mathfrak F}\)
> after pullback to \(\mathfrak F\).

with a single inertia term. That is Woodward's equation (57),
`F^G_{n_-}(d_-) ×_{Ī_{X//G}} F^G_{n_+}(d_+)`.

Part (b) then argues:

> The degree shift changes only the principal factor. The attached stable-map factors and
> their obstruction theories are the fixed proper stable-map data at a fixed ordinary degree
> and marking set, and the inertia term is determined by the stabilizer congruence class …
> Hence the comparison map is the identity on those two terms, and
> Proposition~\ref{prop:app-square} supplies the map on the third; a map of triangles with
> two identity legs and one quasi-isomorphism is an isomorphism of triangles.

**Why this does not work as written.** I checked Woodward's (55)–(57) in the cache
(`arXiv:1408.5869`, lines 2248–2273 of the extraction). His factors are

> `F^G_{n_±}(φ̃_±, d_±) := {([u],x) ∈ M̄_{0,n_±+1}(X,d_-) × X | u(z_{n_±+1}) = lim φ̃_±(z)x}//G`

so each `F^G_{n_±}` already contains **both** an ordinary stable-map space **and** half of
the principal clutching datum, namely the cocharacter `φ̃_±`. The affine degree shift
therefore changes `𝔉_-` *and* `𝔉_+`. In the two-factor triangle of proof (a), the three
legs are `ev^*L_I`, `L_{𝔉_-} ⊕ L_{𝔉_+}`, and `L_𝔉`; neither of the two outer legs is a
stable-map term that the shift fixes, and `prop:app-square` — which compares
`E_a → L_{t_0 𝔖_{a_-,a_+}/𝔐}` with the `𝔷`-side, i.e. the *whole two-chart principal
component* — has no leg of that triangle to act on. So (b)'s "two identity legs and one
quasi-isomorphism" cannot be run against (a)'s triangle.

Against the three-factor presentation named in the proposition's own setup sentence, (b) is
correct and immediate: the triangle is
`(ev^*L_I)^{⊕2} → L_{M_-} ⊕ L_{𝔖_{a_-,a_+}} ⊕ L_{M_+} → L_𝔉`, the comparison is the
identity on `L_{M_±}` and on both inertia pullbacks, and `prop:app-square` supplies the
quasi-isomorphism on `L_{𝔖_{a_-,a_+}}`.

**Corroborating internal evidence that the two-factor clause is the slip.** The
corresponding passage in the main text uses the three-factor reading:

> For an attached stable-map factor, the fixed graph stack is a derived fibre product over
> its inertia evaluation. Its cotangent triangle is the direct sum of the two factor
> obstruction theories with the pullback of the inertia cotangent complex removed. The
> comparison above is the identity on the stable-map and inertia terms
> (`08-global-transport.tex`, lines 766–771)

— one attached factor at a time, glued to `𝔖` over one inertia evaluation. That is the
presentation (b) needs.

**Verdict: required.** The mathematical content is not in doubt — the three-factor cotangent
triangle is the standard one for an iterated derived fibre product and (b), (c) go through
verbatim against it — but as printed, the proof of (b) refers to terms that are not in the
triangle established in (a).

**Suggested repair.** Replace the two-factor `𝔉 = 𝔉_- ×^R_I 𝔉_+` in proof (a) by the
three-factor product already named in the proposition's setup, and correct statement (a)'s
singular "the pullback of the cotangent complex of the inertia stack" to the two inertia
pullbacks (or to `ev^*L_{I × I}`). Alternatively, if the two-factor form is wanted, (b) must
be rewritten to say which legs the degree shift fixes in that presentation, which it does
not.

---

## Optional improvements

Labelled optional. None of these is a defect in the sense above; each is either a notation
collision, a locator that could be sharper, or a sentence that is true on the intended
reading but literally false or under-specified on the printed one.

- **O1.** `prop:app-one-chart`: the target of the limit morphism is written `Spec A_0`, which
  collides with `A_0` as fixed by `eq:app-grading`.
- **O2.** The letter `k` carries three distinct meanings across the scope (affine degree
  index, orbifold/stabilizer order, and a tangent weight in one example).
- **O3.** `eq:virtual-normal-euler` cites "equations (59) and (64)"; the Euler-class display
  is the unnumbered line following (59), and the `∓ζ(∓ζ−ψ)` normalization sits in the
  sentence introducing (64) rather than in (64).
- **O4.** `Example 9.15` is used twice for a general statement, but it is stated for toric
  quotients; the general proviso is in the prose attached to (59).
- **O5.** The `W = A^1` illustration in `lem:app-cech` implicitly assumes a positive weight.
- **O6.** The appendix opening says it expands the theorem "at the three places where it is
  compressed", but has a fourth expansion subsection (`app:cutting`), which the main text
  never cross-references.
- **O7.** The appendix opening's "what follows adds no new assumption" sits uneasily with
  `conv:app-obstruction-morphism`, which fixes an input Woodward does not state.
- **O8.** The main text pointer "Appendix~\ref{app:square} also records what the argument
  imports" points at `app:square`, while the dedicated import ledger `rem:app-imports` lives
  in `app:cutting`.
- **O9.** The appendix never fixes which of `a_-`, `a_+` goes with which chart.
- **O10.** `prop:app-mu-k(d)` mixes `k` and `r` for the same stabilizer order in one sentence.

---

## Verdict table

| Statement | Location | Verdict |
|---|---|---|
| `def:gauged-admissible` (i)–(iv) | 08, 12–45 | Sound as a register; assumptions correctly labelled as assumptions |
| Clause-by-clause standing paragraph | 08, 81–105 | Accurate; matches what Włodarczyk supplies and what he does not |
| `rem:iv-semistable-restriction` | 08, 47–79 | Correct; recomputed freeness + localization ⟹ injectivity |
| `rem:endpoint-only` | 08, 107–124 | Correct; the universal quantifier is correctly not dropped |
| `lem:point-insertion-row` | 08, 152–195 | Correct given the flagged unitarity input, which is registered |
| `prop:support-collapse` | 08, 197–331 | Correct; every González–Woodward and Woodward locator verified |
| `lem:orbit-cylinder-disjoint` (a)(b)(c) | 08, 344–414 | Correct; numerical criterion rederived independently |
| Włodarczyk terminology paragraph | 08, 451–464 | Correct; "projective = quasiprojective" caveat is real and well put |
| `prop:gamma-ratio-reduction` | 08, 493–600 | Correct; all Gamma and Riemann–Roch identities recomputed |
| `rem:higher-pole-localization-boundary` | 08, 602–608 | Correct and appropriately limiting |
| `rem:neutral-boundary` | 08, 610–632 | Correct; Aleshkin–Liu and González–Woodward locators verified |
| `thm:tailwise-derived` | 08, 634–795 | Correct; the sign-only dependence is the load-bearing step and holds |
| `prop:clutching-tail-holonomicity` | 08, 800–914 | Correct; Stirling expansion and distribution order recomputed |
| `conv:app-obstruction-morphism` | app, 62–73 | Legitimate; Woodward's Def 7.13(a) does specify only the complex |
| `def:app-fixed-section` | app, 98–112 | Sound |
| `lem:app-graded-extension` (a)(b) | app, 139–173 | Correct |
| `lem:app-sign` | app, 182–199 | Correct |
| `prop:app-one-chart` | app, 207–303 | Correct; see O1 for the notation slip |
| `prop:app-descent` | app, 305–337 | Correct |
| `lem:app-cech` | app, 361–417 | Correct; sign flip and both equivalences verified |
| `rem:app-degree-one` | app, 419–430 | Correct; degree bookkeeping checked |
| `lem:app-truncation` | app, 432–494 | Correct at the level at which it is stated |
| `prop:app-square` | app, 496–593 | Correct; Behrend–Fantechi realization step honestly flagged as imported |
| `prop:app-mu-k` (a)–(d) | app, 609–680 | Correct; rigidification matches Woodward II Example 4.3(g) |
| `prop:app-cutting` (a)–(d) | app, 685–754 | **R1** in (a) versus (b); (c), (d) correct |
| `rem:app-imports` | app, 756–789 | Accurate ledger |
| `08-scope.tex` item (5) | scope, 25–52 | Complete for `prop:support-collapse`; no unregistered input found |
| Introduction completion paragraph | intro, 110–118 | Accurate summary of §8 |

---

## Findings in detail

### F1 (required) — see R1 above

Written out in full in the required-repairs section.

### F2 (verified, no defect) — `lem:orbit-cylinder-disjoint` and the numerical criterion

**The text.**

> a point \(y\) is semistable for an equivariant ample \(M\) if and only if
> \(\mu_M(y_\infty)\leq 0\leq\mu_M(y_0)\) … the fibre of \(\OO(1)\) at the fixed point
> \([v_k]\) has weight \(-k\); and \([v]\) is semistable exactly when
> \(k_{\min}\leq0\leq k_{\max}\).

**My computation.** Embed `W ⊂ P(V)` by sections of a power of `M`. For `v = Σ_k v_k` with
`t·v_k = t^k v_k`, factoring `t^{k_min}` gives `lim_{t→0}[t·v] = [v_{k_min}]` and
`lim_{t→∞}[t·v] = [v_{k_max}]`. The fibre of `O(-1)` at `[v_k]` is `C·v_k`, on which `t` acts
with weight `k`, so `O(1)` has weight `-k` there — the manuscript's sign is right.
Semistability of `[v]` means `0 ∉ closure(G·v)`; the closure contains `0` iff `k_min > 0`
(as `t → 0`) or `k_max < 0` (as `t → ∞`), so semistable iff `k_min ≤ 0 ≤ k_max`. Translating,
`μ_M(y_0) = -k_min ≥ 0` and `μ_M(y_∞) = -k_max ≤ 0`, which is exactly the displayed
criterion. Stability is the strict version, `k_min < 0 < k_max`. Raising `M` to a power
scales all weights positively and does not affect the inequalities.

Parts (a), (b), (c) then follow as printed. I checked each step: triviality of the stabilizer
from freeness on the semistable loci; extension of `t ↦ t·x` across `P^1` by properness;
affineness of `u ↦ μ_u(w) = (1-u)μ_{L_-}(w) + u μ_{L_+}(w)` and hence sign persistence on
`[0,1]`; local constancy of `μ_u` on a connected fixed component; ampleness of `L_u` for
rational `u ∈ [0,1]` as a positive combination of ample classes, which the criterion needs;
and the support argument for `a|_F = 0` (the class comes from cohomology supported on
`closure(O)`, restriction to the open complement kills it, and `F` lies in that complement).

**Verdict: correct.** No repair.

### F3 (verified, no defect) — `eq:liouville-character` against Woodward III Corollary 9.10(c)

**The text.**

> On a graph fixed locus their contribution is
> \(\exp(\sum_j t_j D_j)\prod_j x_j^{D_j\cdot\widetilde d_+}\), \(x_j=\exp(t_j\zeta)\),
> where \(\widetilde d_+\) is the total infinity-side equivariant degree: the bubble degree
> together with the affine cocharacter degree of the gauged principal component
> \cite[Corollary~9.10(c)]{WoodwardQKIII}.

**The source** (`arXiv:1408.5869`, extraction lines 2213–2217):

> (c) The restriction of `λ(γ)` to a fixed point component of `M^G_n(P,X)` in (54) is equal
> to `exp(γ̄ + (d_+ + φ_+, γ)ζ)` where `γ̄` is the image of `γ` under `H^2_G(X) → H(Ī_{X//G})`
> and `φ_+ ∈ g_Q ≅ H_2(X,Q)` is considered an element of `H^G_2(X)` via the push-forward
> `H(BG) → H^G_2(X)`.

**Comparison.** Put `γ = Σ_j t_j D_j`. Then `γ̄ = Σ_j t_j D̄_j` and
`(d_+ + φ_+, γ) = Σ_j t_j (D_j · (d_+ + φ_+))`, so Woodward's restriction is
`exp(Σ_j t_j D̄_j) · exp(ζ Σ_j t_j D_j·(d_+ + φ_+))`, and
`∏_j x_j^{D_j·d̃_+} = exp(ζ Σ_j t_j D_j·d̃_+)`. The two agree exactly with
`d̃_+ = d_+ + φ_+`, and the manuscript's gloss — "the bubble degree together with the affine
cocharacter degree of the gauged principal component" — is precisely `d_+` plus `φ_+`.
**Verdict: the citation supports the claim exactly, including the split of `d̃_+`.**

### F4 (verified, no defect) — the semistability of the distinguished output evaluation

This is the load-bearing step of `prop:support-collapse`, and it rests on three separate
locators. All three check out.

- **González–Woodward Lemma 3.17** (extraction lines 3392–3405): "For any class `d` there
  exists a `ρ_0` such that for `ρ > ρ_0`, any Mundet-semistable fixed map for polarization
  `L_t` must consist of a principal component mapping to `X^{ζ,t}/G_ζ` and bubbles mapping to
  `X/G_ζ`", with `X^{ζ,t}` defined immediately above as "the (possibly empty) locus of
  `L_t`-semistable points in `X^ζ`". The manuscript's degreewise quantifier ("For each fixed
  degree and sufficiently large area") correctly mirrors the source's "for any class `d`
  there exists a `ρ_0`".
- **González–Woodward Remark 3.19**: the isomorphism is
  `M^{G_ζ,fr}_r(C, X^{ζ,t}) ×_{(X^ζ)^r} ∏_j M̄_{|I_j|+1}(X)`. The framings are compared in
  `(X^ζ)^r`, the *ambient* fixed locus, while only the principal factor carries `X^{ζ,t}`.
  The manuscript's sentence "note that the framings are compared in the ambient `W^w`, so it
  is the principal side that carries the semistability" is exactly right, and it is exactly
  the point on which the argument turns.
- **González–Woodward Proposition 3.15(c)**: "any node or marking of `Ĉ` maps to the fixed
  point set `P(X^Z)`" — no semistability. The manuscript's contrast ("a marking carried off
  on a bubble tree may land on a fixed component that is unstable for every interpolated
  polarization") is faithful.
- **Woodward III Lemma 9.9 and (55)**: the clutching value `x` at a generic point of the
  principal component is semistable, and the inertia evaluation is `(u,x) ↦ [x, φ̃_±(θ)]` —
  a principal-component value. This is what the manuscript means by "Its value is the
  principal-component value, because the section is constant near that point".

For `G = G_m` the wall cocharacter has `G_w = G_m` and `W^w = W^{G_m}`, so the components
reached are components `F` of `W^{G_m}` with `μ_t(F) = 0` — literally the class of components
that `def:gauged-admissible`(iv) and `lem:orbit-cylinder-disjoint`(b) cover. The register and
the use match.

**Verdict: correct, and the citation direction is right in each case.**

### F5 (verified, no defect) — `eq:virtual-normal-euler`

The Euler-class display in the source (`arXiv:1408.5869`, immediately after equation (59)) is

> `Eul(N_±) = Eul((Rp_*e^*(T(X/G)))_mov)(∓ζ)(∓ζ − ψ)`

which is `eq:virtual-normal-euler` verbatim with `X/G` written `W/G_m`. Equation (59) itself
lists the K-theory splitting `(Rp_*e^*T(X/G))_mov ⊕ T^∨_{w_+}C ⊗ T^∨_{w_-}Ĉ^ρ ⊕ T_{w_+}C`
and identifies the second summand as node deformation and the third as attaching-point
deformation. Matching Euler classes, `(∓ζ) = Eul(T_{w_+}C)` is the attaching point and
`(∓ζ − ψ) = Eul(T^∨_{w_+}C ⊗ T^∨_{w_-}Ĉ^ρ)` is the node. The manuscript's gloss "The last
two factors move the attaching point and smooth the node, respectively" reads the factors in
its own display's order and is correct. The proviso "assuming there is some non-trivial
component attached" is in the source prose and is what the manuscript's restriction to types
with an attached component reflects. See O3 and O4 for the two locator refinements.

### F6 (verified, no defect) — the growth estimate in `prop:clutching-tail-holonomicity`

**The text.**

> for \(n_a\geq0\) the factor \eqref{eq:gamma-index-factor} … has log-magnitude
> \(-\sum_{m=0}^{n_a}\log|\alpha_a+m\zeta| = -(n_a+1)\log|\zeta|-\sum_{m=0}^{n_a}\log|m+x_a|\),
> which is \(-n_a\log n_a+n_a-n_a\log|\zeta|+O(\log n_a)\), and for \(n_a<0\) the \(H^1\)
> Euler class … has log-magnitude \(|n_a|\log|n_a|-|n_a|+|n_a|\log|\zeta|+O(\log|n_a|)\)

**My computation.** With `x_a = α_a/ζ`, `α_a + mζ = ζ(x_a + m)`, so the first identity is
exact. Stirling gives `Σ_{m=0}^{n} log|m + x| = log|Γ(n+1+x)/Γ(x)| = n log n − n + O(log n)`
for fixed `x`, so the `n_a ≥ 0` branch is `−n_a log n_a + n_a − n_a log|ζ| + O(log n_a)`.
For `n_a < 0` the product `∏_{m=n_a+1}^{-1}(α_a + mζ)` has `|n_a| − 1` factors and
log-magnitude `|n_a| log|n_a| − |n_a| + |n_a| log|ζ| + O(log|n_a|)`; substituting
`|n_a| = −n_a` turns this into `−n_a log|n_a| + n_a − n_a log|ζ| + O(log|n_a|)`, the same
expression as the first branch. The claim "The two rays therefore contribute the same
expression, the `ζ`-scale term included" is correct.

Substituting `n_a = h_a k + s_a` and expanding `log|n_a| = log k + log|h_a| + O(1/k)`:

```
log|c_k| = -(Σ h_a) k log k  -  k Σ h_a log|h_a|  +  (Σ h_a) k  -  (Σ h_a) k log|ζ|  +  O(log k)
```

which is the manuscript's display exactly, including the sign of every term. Neutrality
`Σ h_a = c_1^{G_m}(TW)·δ = 0` kills the first, third and fourth terms and leaves
`−k Σ h_a log|h_a|`, linear in `k`, removed by one exponential rescaling — as stated. The
manuscript's care in restricting the sums to `h_a ≠ 0` is necessary and present.

The nilpotent-correction claim also checks: expanding `1/(α + mζ + ε)` with `ε^{N+1} = 0`
produces at most `N` derivative terms, each contributing a factor like
`Σ_m 1/(α + mζ) = O(log n_a)`, so the nilpotent parts are polylogarithmically bounded, as
asserted.

The distributional step: `|c_k| ≤ C k^N (log k)^M` and `q > N + 2` give
`|b_k| = |c_k|/k^q ≤ C k^{N-q}(log k)^M` with `N − q < −2`, hence `Σ|b_k| < ∞`; so
`Σ b_k r^k e^{ikθ}` converges uniformly in `θ` for `r ≤ 1` and its `r → 1` limit is
continuous; `∂_θ^q` multiplies the `k`-th term by `(ik)^q` and recovers `Σ c_k r^k e^{ikθ}`;
a uniform limit differentiated `q` times converges in `D'(S^1)` with order at most `q`.
Correct throughout.

**Verdict: correct.**

### F7 (verified, no defect) — `(D)`-finiteness and the recurrence

The proof takes a first-order rational system of size `m = r·dim_C R_N` over `C(k)` and
extracts a relation among the first `m+1` shifts. That is right: `c_k, …, c_{k+m}` are `m+1`
vectors in an `m`-dimensional `C(k)`-vector space, hence linearly dependent over `C(k)`, and
clearing denominators gives scalar `p_i ∈ C[k] ⊂ R_N[k]`. The system is genuinely rational:
for integer `h_a`, `Γ(h_a(k+1)+s)/Γ(h_a k+s)` is a product (or inverse product) of `|h_a|`
linear factors in `k`. The manuscript's refusal of the word "holonomic" over a ring with
nilpotents, and its explicit definition of `(D)`-finite as the recurrence property, mean the
statement and the proof are exactly matched — the proposition claims no more than the
recurrence, which is what is established. **Verdict: correct.**

### F8 (verified, no defect) — `lem:point-insertion-row`

Writing `s_Y(O_p)` from `eq:gamma-framed-section` with `ch(O_p) = [pt]`: `Γ̂_Y` and
`z^{c_1(Y)}` act as the identity on the top class, `(2πi)^{deg/2}` contributes `(2πi)^n`,
`(2π)^{-n/2}` is a scalar, and `z^{-μ}` contributes `z^{-n/2}` since `μ = n/2` on `H^{2n}`.
So `s_Y(O_p) = c_n(z) L_Y(τ,z)[pt]` with `c_n(z)` invertible and depending only on `n` and
the conventions — as claimed. With `D τ_{Y,-} = L_Y` unitary for `eq:flat-euler-pairing`,

```
𝔯_{Y,p}(Dτ_{Y,-} v) = [Dτ_{Y,-} v, s_Y(O_p)) = (L(e^{-πi}z)v, c_n(z)L(z)[pt])_Y = c_n(z)(v,[pt])_Y
```

which is `eq:point-insertion-row`. Composing with `Dκ` gives the last assertion. The one
unproved input (unitarity of the graph fundamental solution) is flagged inside the proof and
registered in `08-scope.tex` item (5): "Lemma~\ref{lem:point-insertion-row} takes from
Woodward's graph-space normalization that \(D\tau_{Y,-}\) is the genus-zero fundamental
solution of the quantum connection and is unitary for the twisted pairing". The register is
complete on this point. **Verdict: correct, and the input is registered.**

### F9 (verified, no defect) — Włodarczyk Proposition 2(B') and the terminology caveat

**The source** (`arXiv:math/9904074`). Lemma 5 constructs
`L(X,D;X',D') := O_X(−D) ∪_{V×K^*} O_{X'}(D')_∞`, a gluing of two line-bundle total spaces
along a trivialized cylinder `V × K^*` with `V ⊆ U`, the common open. Proposition 2(B')
takes a `K^*`-equivariant *projective* completion of `L(X,D;X',0)` and then its canonical
`K^*`-equivariant resolution. The proof of case A contains the sentence "which means that
`L̄(X,D;X',D')` is a projective variety and `L(X,D;X',D')` is quasiprojective", and the open
cobordism is `B(X,X') := B̄ ∖ S_0 ∖ S_∞`, with
`B_+(X,X') = O_{X'}(D')_∞ ∖ S_∞`, `B_-(X,X') = O_X(−D) ∖ S_0`, and "In both cases evidently
`B_+/K^* ≃ X'` and `B_-/K^* ≃ X`".

Every manuscript claim about this source is accurate:

- "punctured line-bundle opens with the two endpoint varieties as geometric quotients" —
  exactly `B_±` and `B_±/K^*`.
- "Włodarczyk calls the open cobordism *projective* when it is quasiprojective" — the source
  proves quasiprojectivity of the open cobordism and projectivity of the completion.
- "the glued space is smooth, being glued from two line bundles over smooth varieties" —
  correct from Lemma 5's construction.
- "a canonical resolution is functorial and therefore an isomorphism over the smooth
  locus — a standard property of canonical resolution, not part of the cited proposition" —
  correctly flagged as an import beyond the cited statement, and correctly deployed: `L` is
  smooth and contains the source, sink, and cylinder, so the resolution is an isomorphism
  over all three.
- "The cited cobordism theorem supplies the underlying completion and cylinder; it does not
  by itself verify conditions (i)–(iii)" — correct.

**Verdict: correct, and unusually careful about the boundary between what the source proves
and what the manuscript adds.**

### F10 (verified, no defect) — rigidified versus unrigidified inertia in `prop:app-mu-k`(d)

**The text.**

> Rigidification replaces the inertia stack by its quotient by the finite central
> \(B\mu_k\), \(\bar I_{X,r}=I_{X,r}/B\mu_r\) \cite[Section~4.3, Example~4.3(f),(g)]{WoodwardQKII}
> … The fibre products of \cite[equations~(54) and~(57)]{WoodwardQKIII} are taken over the
> \emph{rigidified} inertia stack … passage between the two changes rational cohomology only
> by the factors of \(r\) on \(r\)-twisted sectors.

**The source.** Woodward II Example 4.3(f) gives the unrigidified `I_X = ∪_r I_{X,r}`,
`I_{X,r} := Hom_rep(Bμ_r, X)`; Example 4.3(g) gives the rigidified
`Ī_X = ∪_r Ī_{X,r}`, `Ī_{X,r} := I_{X,r}/Bμ_r`, plus "There is a canonical quotient cover
`π: I_X → Ī_X` which acts on cohomology as an isomorphism … so for the purposes of defining
orbifold Gromov-Witten invariants, `Ī_X` can be replaced by `I_X` at the cost of additional
factors of `r` on the `r`-twisted sectors." Both manuscript claims are verbatim from the
source.

**On the overline caveat.** I applied the prompt's warning that `pdftotext` drops overlines
and replaces them by a space. In `arXiv:1408.5869` both spellings occur — 14 occurrences of
`I X//G` (rigidified) and 14 of `IX//G` (unrigidified). The occurrences inside equations (54)
(extraction lines 2203–2204), (55) (line 2255) and (57) (line 2273) all carry the space, i.e.
they are the **rigidified** inertia. So the manuscript's claim that (54) and (57) are fibre
products over the rigidified inertia stack is right, and it is right for the reason that
would be easiest to get backwards. **Verdict: correct.**

### F11 (verified, no defect) — `rem:neutral-boundary`'s two source comparisons

**Aleshkin–Liu.** `arXiv:2301.01266` Definition 5.18 is the wall hemisphere partition
function for two maximal cones `C_±` of the secondary fan adjacent along a codimension-one
wall, with the circuit `h = (h_1,…,h_{n+κ})`, the Calabi–Yau condition `Σ h_i = 0` following
from `Σ D_i = 0`, and the grade-restriction inequality (5.37); Remark 5.20 names (5.37) the
grade restriction rule; Theorem 5.21 is the wall-crossing statement. The manuscript's
description — "a finite-dimensional linear abelian GLSM with adjacent secondary-fan chambers,
a circuit, Calabi–Yau charges, and a grade-restriction window" — matches each element, and
the paper's own title is "Higgs–Coulomb correspondence and wall-crossing in abelian GLSMs".
The disclaimer "Proposition `gamma-ratio-reduction` does not construct those data for a
nonlinear virtual fixed graph. Their theorem therefore supplies neither the
derived-intersection argument below nor the marked threshold comparisons" is correct and is
the right disclaimer.

**González–Woodward.** Remark 1.18(d): "In the crepant case the (almost) invariance under
this action implies that, after summing over degrees, the wall-crossing term is a sum of
derivatives of delta-functions in the quantum parameter" — exactly the manuscript's "neutral
Picard shifts produce sums of derivatives of delta distributions". Remark 4.6 supplies the
distributional framework and the statement that `Σ f(d) q^d` for polynomial `f` is a sum of
derivatives of the delta function. Equation (47) is the vanishing-almost-everywhere identity,
with the source's own pointer "see Remark 4.6". Remark 4.7: "The above results say nothing
about convergence of the gauged Gromov-Witten potentials … However, if the potentials … have
expressions as analytic functions with overlapping regions of definition … then they are
equal on that region" — exactly "the authors explicitly do not deduce analytic continuation
without an independent convergence input". **Verdict: all four locators support what they
are cited for, in the same direction.**

### F12 (verified, no defect) — Woodward III equation (68) and `eq:endpoint-gauged-maps`

Equation (68) reads

```
Σ_{[I_1,…,I_r]} ∫_{[Ī_{X//G}]} ( τ^r_{X//G,-}(κ^{G,|I_1|}_X(α_{I_1},1), …, κ^{G,|I_r|}_X(α_{I_r},1), 1) ∪ α_∞ )
 = ∫_{[Ī_{X//G}]} τ^{G,n}_{X,-}(α_1,…,α_n,1) ∪ α_∞
```

and the line immediately below sums it to
`∫(τ_{X//G,-} ∘ κ^G_X)(α) ∪ α_∞ = ∫ τ^G_{X,-}(α) ∪ α_∞`. The manuscript's characterization —
"the localized adiabatic identity [(68)], which equates the composite `τ_{Y_±,-} ∘ κ_±` with
the gauged graph potential in the distinguished output slot, and `eq:endpoint-gauged-maps` is
its derivative in the input directions" — is exactly what (68) says, with `α_∞ ∈ H(Ī_{X//G})`
occupying the distinguished output slot. The manuscript is also right that the display
`A_± = Dτ_{Y_±,-}Dκ_±` "is a definition", with only (68) cited. **Verdict: correct.**

### F13 (verified, no defect) — the degree-shift core of `thm:tailwise-derived`

The structural point is that `𝔷 = [W^{a_-}_{F_-}/G_m] ×^R_{[W/G_m]} [W^{a_+}_{F_+}/G_m]`
depends on `(a_-,a_+)` only through the two signs (`lem:app-sign`), so two exponents in the
same tail give **the same** `𝔷`; `prop:app-square` then identifies each `𝔖_a` with that
common `𝔷` as a perfect obstruction theory over `𝔐`, hence identifies the two `𝔖_a` with
each other. That is a clean and correct way to get a degree-shift isomorphism without
comparing the two `𝔖_a` directly, and the manuscript's caveat "The universal gauged maps
`z ↦ z^a x` themselves are not identified when `a` changes" is the right one — it is exactly
the universal section, not the stratum, that varies.

I verified the supporting computations independently:

- `I_a = (A_w : aw < 0)` depends only on `sign(a)`, and `A^a = A/I_a` is non-negatively
  graded, so its positive part is an ideal and the quotient by it is
  `A/(A_{w≠0})`, the fixed-point scheme of the chart. (See O1: the manuscript writes the
  target as `Spec A_0`, which is a different ring; on `A = C[u,v]` with weights `±1`,
  `A_0 = C[uv]` while the fixed locus is the origin. The intended reading, "the weight-zero
  part of `A^a`", is correct.)
- The tangent-weight sign flip: functions of weight `w` acquire `z^{aw}` and are regular when
  `aw ≥ 0`, while tangent vectors of weight `w` acquire `z^{-aw}` and are regular when
  `aw ≤ 0`. Checked against `A^1` with the weight of both signs; the manuscript's worked
  example is consistent, subject to O5.
- The total complex `[F^0_{≤0}V ⊕ F^∞_{≤0}V → V]` with `V = ev_1^*T([W/G_m])` a two-term
  complex in degrees `-1,0`: `h^{-1}` is the diagonal stabilizer Lie algebra, zero on the
  generic semistable locus, so the complex is supported in degrees 0 and 1, exactly as
  `rem:app-degree-one` says.
- The fibre sequence `T_{𝔷/𝔐} → T_- ⊕ T_+ → V` for a homotopy pullback, giving the second
  equivalence of `lem:app-cech`.
- Chart independence: the counterexample `W = P^1`, `a = +1` genuinely shows chart dependence
  of the naive extension condition, and the `U_F` covering argument repairs it correctly,
  including the family form over `Spec R`.
- Descent to `[W^a_F/G_m]`: the rotation-invariant gauge transformations over `P^0` are the
  degree-zero units of `R[z]`, which are `R^×`. Correct.

**Verdict: correct.** One input I could not check from first principles is the graded Picard
computation — see the coverage section.

### F14 (verified, no defect) — `08-scope.tex` item (5) as a register

Item (5) records, for `prop:support-collapse`: the Włodarczyk import and its limits; that the
proper-DM master-stack, obstruction-theory, stability, and numerical-separation conditions
remain assumptions; that bistability of the cylinder orbit is itself an assumption, with the
exact content of that assumption spelled out ("the identification of the extreme quotients in
Definition (i) restricts over the common birational open to the cobordism quotients, so that
the free semistable fibre over each endpoint point is the cylinder orbit"); that the
master-space normal complex is not exhibited; and that `lem:point-insertion-row` takes the
unitarity of `Dτ_{Y,-}` from Woodward's normalization.

I looked for an input used in the proofs in scope that appears in neither
`def:gauged-admissible` nor item (5), and found none. Specifically:

- Invertibility of the virtual normal Euler class is used in `prop:gamma-ratio-reduction` and
  is explicitly attributed to `def:gauged-admissible`(ii) ("since virtual localization
  inverts that class"), with the independent reason (the roots are moving) also given.
- The imports in the appendix — the Toën–Vezzosi mapping-stack cotangent formula, used as
  precedent only, and the Behrend–Fantechi realization step, used and flagged as used — are
  citations of published theorems, not unproved hypotheses, and `rem:app-imports` lists them.
  They do not belong in a register of assumptions.
- `conv:app-obstruction-morphism` fixes a reading rather than assuming a fact, and says so.

The one place where the appendix's own framing is slightly over-broad is its opening claim
that "what follows adds no new assumption" (O7).

**Verdict: the register is complete for the material in scope.**

### F15 (verified, no defect) — the introduction paragraph

> The conditional proof uses a smooth projective equivariant completion of one W{\l}odarczyk
> cobordism. A point in the common birational open sweeps out an orbit cylinder. Its
> equivariant class restricts to the two endpoint point classes and vanishes on every fixed
> stratum that is semistable for an interpolated polarization. That class is inserted at the
> output evaluation of the graph factor, which is computed from the principal component and
> so lands in exactly such a stratum, and every wall term of the polarization sweep therefore
> vanishes. Rotation localization does different work: it produces the graph factor and the
> degree extraction that isolates it.

Every clause corresponds to a statement I verified in §8: the completion is
`Prop 2(B')` plus canonical resolution; the cylinder is `V × K^*` from Włodarczyk's Lemma 5;
the restriction and vanishing are `lem:orbit-cylinder-disjoint`(c) and (b); the placement and
the principal-component reading are `prop:support-collapse` on González–Woodward Lemma 3.17
and Woodward III (55); and the division of labour between rotation and polarization
localization is exactly as the proof executes it. The sentence "Its equivariant class
restricts to the two endpoint point classes" is stated flatly, but the paragraph opens with
"The conditional proof", the assumption division is given three paragraphs later, and
`def:gauged-admissible`(iv) carries the pointer to the registered bistability input. No
repair. **Verdict: accurate.**

---

## Optional improvements, in detail

**O1 — `Spec A_0` in `prop:app-one-chart`.** The sentence

> The subalgebra of positive-degree elements of \(A^a\) is an ideal, so the projection to the
> weight-zero part is a ring map and defines the limit morphism
> \(\operatorname{Spec}A^a\to\operatorname{Spec}A_0\) onto the fixed locus of the chart.

is correct if `A_0` means the weight-zero part of `A^a`, which is `A/(A_{w≠0})`, the fixed
point scheme. But `eq:app-grading` has already fixed `A_0` as the weight-zero graded piece of
`A`, and these differ: for `A = C[u,v]` with `u` of weight `+1` and `v` of weight `-1`,
`A_0 = C[uv]` is a line while the fixed locus is the origin. Writing `(A^a)_0` would remove
the collision. Nothing downstream uses `A_0` in the wrong sense, which is why this is
optional.

**O2 — `k` carries three meanings.** In `prop:gamma-ratio-reduction` and
`prop:clutching-tail-holonomicity` `k` is the affine degree index (`n_a(k) = h_a k + s_a`,
`c_k`, `F(x) = Σ c_k x^k`). In `thm:tailwise-derived` and throughout `app:rigidification` it
is the orbifold/stabilizer order (`[Spec R[z^{1/k}]/μ_k]`, `a = b/k`). In `lem:app-cech` it is
a tangent weight ("`W = A^1` with `t·y = t^k y`"). The manuscript avoids an actual collision
inside any one formula by writing "the stabilizer order of Proposition~\ref{prop:app-mu-k}(b)"
in prose rather than `k`, which shows the hazard was noticed; but `prop:app-mu-k`(b)'s
"consecutive affine degrees differ by `k`" reads badly next to `n_a(k) = h_a k + s_a`.
Renaming the orbifold order (say `ℓ`, or `r` consistently with Woodward II) would help.

**O3 — the "(59) and (64)" locator.** Equation (59) is the K-theory splitting; the
Euler-class identity is the *unnumbered* display immediately after it. Equation (64) is
`∫_{[M̄_{0,n+1}]} α^n (ζ)^{-2}(ψ_{n+1}/∓ζ)^{n-2}` — the `∓ζ(∓ζ − ψ)` normalization that the
manuscript is pointing at appears in the sentence introducing (64), not in (64). Since the
manuscript's stated purpose is to fix the *sign convention*, the honest locator is "(59) and
the display following it, with the sign convention of the sentence preceding (64)". The claim
is fully supported either way; this is precision, not correctness.

**O4 — Example 9.15 for a general claim.** Both uses ("in the irreducible unstable type those
factors are absent and only the moving index remains", `08-global-transport.tex` line 520;
"by [Example 9.15] the domain is irreducible and the normal complex is the moving index
alone", `appendix-one-chart.tex` line 709) rest on a source statement made for *toric*
quotients: "Let `G` be a torus acting on a vector space `X` … The domain of any gauged map
without markings is irreducible and the normal complex to `F^G(φ,0)` is the moving part
`Rp_*e^*(T(X/G))_mov`." The general form of the claim is available in the source without the
toric restriction, in the prose attached to (59): "assuming there is some non-trivial
component attached". Citing that proviso alongside, or instead of, Example 9.15 would make
the locator match the generality of the use. The manuscript already cites (59) in the same
equation, so nothing is unsupported.

**O5 — the `A^1` example in `lem:app-cech`.** "For `W = A^1` with `t·y = t^k y` and `a > 0`,
the attracting locus is all of `A^1`" holds for `k > 0`; for `k < 0` the attracting locus is
the origin, and the displayed condition then correctly excludes the tangent direction. Adding
"`k > 0`" makes the illustration exact. (The example remains a correct illustration for both
signs if the reader tracks the case split.)

**O6 — "the three places where it is compressed".** The appendix opening promises three
expansions, and `app:attractor`, `app:square`, `app:rigidification` are the three that the
main text points to. `app:cutting`, containing `prop:app-cutting`, is a fourth, and the main
text's corresponding paragraph (`08-global-transport.tex` lines 766–773) never cites it.
Adding the pointer, and adjusting the opening sentence, would close the loop.

**O7 — "adds no new assumption".** The appendix opens: "The hypotheses, the statement, and
the conclusions of that theorem are unchanged; what follows adds no new assumption and
asserts nothing stronger." `conv:app-obstruction-morphism` then fixes what Woodward's
obstruction morphism *is*, which Definition 7.13 does not state — the convention is
well-justified ("This is the reading under which his virtual classes are formed") and
`rem:app-imports` is candid about it, but a reader who takes the opening sentence literally
will be surprised. A half-sentence acknowledging the convention in the opening would remove
the tension.

**O8 — the `app:square` pointer.** "Appendix~\ref{app:square} also records what the argument
imports, what it fixes by convention, and what it proves internally"
(`08-global-transport.tex` line 764). `app:square` does some of this inside
`lem:app-truncation`'s proof, but the dedicated ledger is `rem:app-imports`, in `app:cutting`.
Pointing at the remark directly would be sharper.

**O9 — chart/sign pairing.** `app:setup` says "We record an exponent `a_± ∈ Z` in each
chart's own coordinate" without saying which sign goes with which chart;
`lem:app-cech` then implicitly pairs `F^0 ↔ (a_-, F_-)` and `F^∞ ↔ (a_+, F_+)`. Woodward's
Definition 9.7 uses the opposite pairing (clutching function `φ_+(z)φ_-(z^{-1})^{-1}`, so
`φ_+` on the chart at 0). The manuscript never cites the source for the pairing, so nothing
is wrong; stating the convention once would prevent a reader from importing Woodward's.

**O10 — `k` versus `r` in `prop:app-mu-k`(d).** "Rigidification replaces the inertia stack by
its quotient by the finite central `Bμ_k`, `Ī_{X,r} = I_{X,r}/Bμ_r`" uses both letters for the
same order in one sentence, then continues with `Bμ_r` and "factors of `r`". Woodward II uses
`r`; the appendix uses `k` everywhere else. Pick one.

---

## Coverage: what I did not reach, and what is UNVERIFIED

**Read but not independently reverified**, because earlier rounds concentrated there and the
brief asked me to weight the later appendix material: I read the whole of
`prop:support-collapse` and checked all of its citations and its logical structure, but I did
not re-derive the virtual Kalkman residue extraction itself — the manuscript explicitly does
not exhibit the master-space normal complex and registers that as
`def:gauged-admissible`(ii), so there is nothing there to re-derive. Likewise I checked the
character-independence degree extraction for internal consistency rather than reconstructing
Woodward's Liouville-class formalism.

**UNVERIFIED — sources not in the cache.** Four cited works could not be opened:

| Source | Cited for | What verification would take |
|---|---|---|
| Behrend–Fantechi, *The intrinsic normal cone* | `[Section 4]`, for the realization step in `prop:app-square` (every class in `h^1/h^0(E^∨)` over a test scheme comes from a square-zero extension after a smooth cover) | Open the paper and confirm §4 is the obstruction-theory section and contains that passage. §4 of that paper is titled "Obstruction theory", so the locator is almost certainly right, but I did not see it. |
| Graber–Pandharipande, *Localization of virtual classes* | the fixed part of an ambient relative perfect obstruction theory is a relative perfect obstruction theory on the fixed locus | Standard and cited without a locator; González–Woodward Corollary 3.20 cites it for exactly this and I did verify Corollary 3.20. |
| Toën–Vezzosi, HAG II | cotangent complex of a derived mapping stack, cited as precedent only | The manuscript says it does not invoke the general form and derives the equivariant relative form itself from `def:app-fixed-section`, with perfectness from `lem:app-cech`. That derivation I did check. |
| Schürg–Toën–Vezzosi | precedent for reading a classical obstruction theory off a derived enhancement | Cited as precedent, not as a source of any statement used. |
| Mumford–Fogarty–Kirwan, GIT, Ch. 2 §2.1 Thm 2.1 | the numerical criterion | I rederived the criterion in the fibre-weight form from first principles (F2), so the mathematics is verified independently of the locator. Ch. 2 of GIT is "Analysis of stability" and §2.1 is the numerical criterion, so the locator is the standard one, but I did not open the book. |

**UNVERIFIED — one computation I accepted rather than proved.** In `prop:app-one-chart`:

> equivariantly, such a bundle is a graded invertible \(R[z]\)-module, and the graded Picard
> group of \(R[z]\) is \(\operatorname{Pic}(R)\times\mathbf Z\) … The nonequivariant analogue
> is false for nonreduced \(R\), which is why the equivariant statement is the one used.

The parenthetical is right and important — `Pic(R[z]) = Pic(R)` requires seminormality
(Traverso/Bass), so the nonequivariant route genuinely fails for the nonreduced test algebras
this appendix needs, and the manuscript is right to flag it. The graded statement
`Pic^{gr}(R[z]) = Pic(R) × Z` is the equivariant Picard group of `[A^1_R/G_m]` and follows
from the graded form of "projective modules over a polynomial extension are extended", which
I believe but did not prove. Verification would take checking the graded-projective-extension
theorem in the form needed over a simplicial commutative base. Nothing else in the appendix
depends on it beyond local triviality of the rotation-equivariant `G_m`-bundle.

**UNVERIFIED — one geometric claim taken on the manuscript's own registration.** In
`prop:support-collapse`: "the two ends of the master-space fibre … whose two sections carry
opposite weights". This is the standard master-space picture and the manuscript explicitly
declines to exhibit the normal complex, registering the normalization under
`def:gauged-admissible`(ii) and again in `08-scope.tex` item (5). Verification would require
constructing the master space for the given completion, which is outside what the manuscript
claims.

**Out of scope, not read:** `sections/03-simple-wall.tex` through `sections/07-two-wall-criterion.tex`,
`sections/09-cubic-endpoint.tex`, `08-global-transport.tex` from `rem:two-tail-threshold-obstruction`
(line 916) to the end, `08-scope.tex` items (1)–(4) and (6)–(8) except where item (5) or the
scope-boundary paragraphs bear on §8, and the `verification/` artifact. Statements defined
there and used in scope — `hyp:marked-threshold-wall`, `hyp:marked-threshold-zero`,
`prop:punctual-corner`, `thm:birational-point-primary` — I read only for their role, not for
their internal correctness.

---

## Bottom line

- **Required repairs: 1** (R1, `prop:app-cutting`(a) versus (b)).
- **Optional improvements: 10.**
- Everything else in the primary scope that I checked is correct, and every citation I could
  open supports what it is cited for, in the same direction, at a locator naming a statement
  about the same object. The two places where a locator could be sharper (O3, O4) do not
  leave any claim unsupported, because a correct locator for the same claim is cited
  alongside.
- The registers of assumptions (`def:gauged-admissible` and `08-scope.tex` item (5)) are
  complete for the material in scope: I found no input used in a proof in scope that appears
  in neither.
