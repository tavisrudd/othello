# C913 — round-2 adjudication of the post-repair cold-read fixes

**Date:** 2026-08-15
**Manuscript:** `papers/cubic-stabilization-irrationality/`
**Commit range compared:** `5c8d0957a` (the tree reviewed in
`notes/2026-08-15-c913-cold-read-post-repair.md`) → `9043b8131` (the repairs).
`76077e1c5` sits between them and touches only `notes/`, so the manuscript delta is exactly
`git diff 5c8d0957a..9043b8131 -- papers/cubic-stabilization-irrationality/sections`.
**Files changed in scope:** `01-introduction.tex`, `08-global-transport.tex`,
`appendix-one-chart.tex`. `08-scope.tex` was **not** touched — see new defects N3 and N4.
**Role:** referee, adversarial. Findings only; no manuscript edits made.

Sources re-consulted directly this round (shared cache `/tmp/persistent/tavis/lit-search/`):
González–Woodward `arXiv:1208.1727` — Corollary 3.20 and its proof, Lemma 3.21 and its proof,
Definition 3.22, and the equivariant-parameter conventions at lines 131, 153–154, 241, 528, 941–942
of the text extraction; Woodward QK III `arXiv:1408.5869` §9.4 (lines 2580–2660). Włodarczyk
Proposition 2(B') was spot-checked against `notes/2026-08-14-c913-wlodarczyk-2bprime-extraction.md`
rather than re-fetched, as instructed. `02-point-row.tex` lines 1–46 were read to check the new
pairing pointer.

---

## 1. Verdict table

| # | Finding | Verdict | One-line reason |
|---|---|---|---|
| 1 | Virtual-class bridge | **Partially closed** | Right bridge, correct `h^0`/`h^1` bookkeeping, but "those points are exactly the square-zero extension data" still needs a realization step, and the statement's "isomorphic as morphisms to the cotangent complex" holds only after truncating `L` to `[-1,0]` |
| 2 | Homotopy contradiction | **Closed** | Both passages now say 2-commutativity comes from functoriality at `ev_1` and the Čech presentation identifies only the left vertical arrow |
| 3 | Evaluation slot | **Closed** | Matches QK III §9.4 verbatim; not overstated in the other direction — the Remark 3.19 sentence is exactly right about `(X^ξ)^r` |
| 4 | Freeness/injectivity | **Closed** | Filtrability, even cells, degenerate Gysin, torsion-freeness, localization theorem, and an explicit "freeness alone would not give this"; antecedent fixed |
| 5 | Locator | **Partially closed** | §9.4 correctly demoted, but González–Woodward Corollary 3.20 is about the *master-space* circle, not the domain-rotation circle, so "exactly this way" overstates; and `rem:app-imports` was left unsynchronized |
| 6 | Family cover | **Closed** | `U_F` is open in `W_F^a` for the stated reason, is exactly what the preceding paragraph proves, and now carries the `z = 0` value |
| 7 | Kalkman normalization | **Partially closed** | Disclosure is honest and explicit, but the structural claim is uncited (and is cheaply sourceable), and routing it to `def:gauged-admissible`(ii) is a stretch that (ii) does not support |
| 8 | Notation | **Partially closed — new defect** | `\hbar` gone and `ζ` uniform, but `ξ` is González–Woodward's own symbol for the equivariant parameter, so the two symbols are now swapped against the source cited four times in the same paragraph |
| 9 | Stirling term | **Closed** | Four-term display now matches my independent expansion exactly; `ζ`-specialization stated |
| 10 | Introduction | **Closed** | Wall vanishing attributed to the polarization sweep; rotation localization given its actual job |
| E1 | Liouville linear independence | **Closed** | Argument as written is the correct one |
| E2 | Moving Chern roots carry a nonzero weight | **Closed** | States exactly the invertibility hypothesis the localization needs |
| E3 | Orbifold slope bookkeeping | **Partially closed** | The per-unit-`δ` normalization answers the indexing mismatch I raised; descent of the index from the cover and the absence of age contributions to the slope are still unstated |
| E4 | `lem:point-insertion-row` normalization input | **Closed as disclosure, with two consequences** | Now explicit and honest, but points at the wrong label and is not registered in `08-scope.tex` |
| E5 | `eq:endpoint-gauged-maps` definition/citation split | **Closed** | — |
| E6 | `a_p` disambiguation | **Closed** | — |
| E7 | `(D)`-finite typesetting | **Closed** | Only remaining plain occurrence is inside a LaTeX comment |
| E8 | `holonomicity` label comment | **Closed** | — |
| E9 | "Uniform on the tail" | **Closed** | Now says something checkable, and the finiteness it relies on is established earlier in the section |
| W | Włodarczyk Proposition 2(B') | **Discharged** | All three manuscript uses check out against the extraction note; one standard-property step noted below |

---

## 2. Findings not fully closed

### 2.1 Finding 1 — the virtual-class bridge (partially closed)

Current text, `prop:app-square` proof, final paragraph:

> A morphism of Picard stacks is determined by its values on points with values in test schemes, and
> by the construction of the intrinsic normal sheaf **those points are exactly the square-zero
> extension data** compared in Lemma~\ref{lem:app-truncation}: an extension of the test scheme with
> a given ideal, its obstruction class, and the torsor of its extensions when that class vanishes.
> The comparison there is by one recipe applied to both morphisms, so it is natural in the test
> scheme.

**What is now right.** The bridge targets the correct object. Behrend–Fantechi's class is built from
`𝔠 ⊂ 𝔑 → h^1/h^0(E_a^∨)`, and `h^1/h^0` is an equivalence between `D^{[0,1]}` and Picard stacks
(Deligne, as used in Behrend–Fantechi §2), so the embedding does remember more than `h^0` and `h^{-1}`
separately — which is exactly why my round-1 objection was not vacuous. The `h^0`/`h^1` bookkeeping
is correct: `E_a^∨ = (Rπ_* u_a^* T([W/\Gm]))^{\mathrm{rot}}` sits in degrees `0` and `1` by
`lem:app-cech`, `π_0` of the Picard stack is the obstruction side and `\operatorname{Aut}` is the
deformation side, so the sentence "the `h^0` half of the comparison is what the deformation side of
the cone needs" is right, and it correctly motivates the torsor clause in
`conv:app-obstruction-morphism`. "Determined by its values on test-scheme points" is legitimate:
a morphism of stacks *is* its collection of functors on `T`-points together with the naturality
data, by 2-Yoneda, and the manuscript is careful to include the automorphisms (the torsor) and not
only `π_0`.

"The comparison there is by one recipe applied to both morphisms, so it is natural in the test
scheme" is also sound as an argument shape: naturality of each assignment is automatic, and the
content is that the two coincide, which follows from both being computed by the same restrict-to-two-charts-and-difference recipe. That substantive claim was already in the previous version and I do
not reopen it.

**What is still open.** The sentence "those points are exactly the square-zero extension data" is
not an identity; it is an assertion that needs a realization step. Concretely,
`π_0(𝔑_{t_0𝔖/𝔐}(T)) = \operatorname{Ext}^1(g^*L, \mathcal O_T)` and
`\operatorname{Aut} = \operatorname{Hom}(g^*L, \mathcal O_T)`, whereas the obstruction classes
actually arising from square-zero extensions of that particular `T` by an ideal `J` are the images
of `[T'] ∈ \operatorname{Ext}^1(L_T, J)` under `\operatorname{Ext}^1(L_T,J) → \operatorname{Ext}^1(g^*L,J)`.
That map need not be surjective for a fixed `T`; the standard remedy — and it is the content of
Behrend–Fantechi's Theorem 4.5 argument — is to vary `T` over a suitable (for instance affine,
smooth-chart) cover so that every class is realized. Without that step, "exactly" is doing
unearned work, and the paragraph reads as if it were a definition chase when it is in fact the
substance of Behrend–Fantechi §4.

Second, smaller: the proposition's statement says "the two perfect obstruction theories are
isomorphic as morphisms to the cotangent complex". What the Picard-stack bridge delivers is equality
after composing with `L \to τ_{[-1,0]}L`, since only that truncation is visible to `h^1/h^0`. That is
all the virtual class needs and all Behrend–Fantechi uses, but the statement as printed asserts the
untruncated version.

Third, presentational but consequential: the paragraph order runs backwards. Paragraph three already
concludes "the two perfect obstruction theories are isomorphic as morphisms to the cotangent
complex" and "Taking `t_0` and using Lemma `lem:app-truncation` identifies the upper row with
Woodward's relative perfect obstruction theory"; paragraph four then opens "One step must be spelled
out, because Lemma `lem:app-truncation` compares the two morphisms on square-zero extensions while
the virtual class is built from more than that comparison at first sight." A reader who stops at the
end of paragraph three has been given the conclusion without the step. Move the bridge before the
`t_0` sentence, or forward-reference it there.

**What would close it:** one sentence naming the realization step (vary the test scheme so that every
class in `\operatorname{Ext}^1(g^*L, J)` is the obstruction of an actual square-zero extension), a
`τ_{[-1,0]}` qualifier in the proposition statement, and the paragraph reorder.

### 2.2 Finding 5 — the replacement locator (partially closed)

The removal is clean and I verified it: `Section~9.4` now appears exactly once in the whole
`sections/` tree, at `08-global-transport.tex:236`, in its new and correct role as the source for the
distinguished evaluation slot. No dangling reference to the old "relative perfect obstruction theory
on the rotation-fixed locus, induced from the ambient one" survives in the appendix opening, in the
import list, or in `lem:app-truncation`.

What remains is a mismatch of fixed-point problems. Appendix opening, current text:

> the fixed part of an ambient relative perfect obstruction theory as a relative perfect obstruction
> theory on the fixed locus \cite{GraberPandharipande}, applied in the gauged setting **exactly this
> way** in \cite[Corollary~3.20]{GonzalezWoodward}

I read Corollary 3.20 and its proof directly:

> The relatively perfect obstruction theory `M^{G_ζ}_n(C, X, L_t, ζ)` is pulled back from that on the
> `C^×`-fixed point set in `M^G_n(C, X, L_-, L_+)^{C^×}` in Proposition 3.18. The latter is a special
> case of existence of relatively perfect obstruction theories on fixed point loci discussed in [31].

`[31]` is Graber–Pandharipande, so the attribution half is now correct and sourced — a real
improvement over QK III §9.4, which names neither. But the `C^×` in Corollary 3.20 is the
**master-space circle** of the VGIT wall crossing, acting on `M^G_n(C,X,L_-,L_+)`; the appendix needs
the principle for the **domain-rotation circle** acting on the graph space `M^G_n(P,X,d)`, whose
fixed locus contains `𝔖_{a_-,a_+}`. These are different group actions on different moduli stacks.
"Applied in the gauged setting exactly this way" therefore overstates: the *principle* is the same
and Graber–Pandharipande covers both, but Corollary 3.20 is not an instance of the manuscript's
application. Weaken to "applied in the gauged setting, for the wall-crossing circle, in
\cite[Corollary~3.20]{GonzalezWoodward}", or drop "exactly this way".

`rem:app-imports` was not synchronized — see N1.

### 2.3 Finding 7 — the Kalkman endpoint normalization (partially closed)

Current text, `prop:support-collapse`:

> Two things about that identity are used and neither is proved here. The two surviving components
> are the gauged-map stacks at \(L_-\) and \(L_+\), sitting in the polarization master stack with
> **opposite normal weights along the master-space direction**, so that after the residue extraction
> their contributions enter with opposite signs and a common normalization; … Both the localized
> formula and this endpoint normalization are **part of the large-area package assumed in
> Definition~\ref{def:gauged-admissible}\textup{(ii)}**; we do not exhibit the master-space normal
> complex.

**The disclosure itself is honest and is a real improvement.** "Neither is proved here" and "we do
not exhibit the master-space normal complex" are exactly the right sentences, and the reason for
caring — equality rather than proportionality — is now stated instead of assumed.

Two things remain.

*The structural claim is uncited, and it is cheaply sourceable.* "Opposite normal weights along the
master-space direction" is not a definitional truth; it is a fact about how the master space is
built. It happens to be supported by the very source the section already cites four times.
González–Woodward's proof of Lemma 3.21 reads:

> By definition the obstruction theory for `M^G_n(C, X, L_-, L_+)` fits into an exact triangle with
> that of `M^G_n(C, X)` and **a trivial factor corresponding to the fiber of `P(D(L_-) ⊕ D(L_+))`**.

That `P^1`-fibre is precisely the master-space direction, and its two sections carry opposite `C^×`
weights. So a pointer to Lemma 3.21 (or to the master-space construction it refers to) would turn an
assertion into a citation at zero cost. Leaving it uncited is the weakest remaining sentence in the
support-collapse proof, because it is the sentence that converts the wall vanishing into
`eq:support-collapse-row`.

*The routing to `def:gauged-admissible`(ii) is a stretch.* Clause (ii) reads in full:

> Degree by degree, the polarization master stacks are proper Deligne--Mumford stacks with
> Woodward's relative perfect obstruction theories, and the localized large-area formula applies
> coefficientwise.

It names the master stacks, their obstruction theories, and "the localized large-area formula". It
says nothing about a virtual Kalkman or residue formula, and nothing about an endpoint
normalization. Claiming both are "part of the large-area package assumed in (ii)" reads more into
(ii) than (ii) contains. Either amend (ii) to name the virtual Kalkman formula and its endpoint
normalization explicitly, or say in the proof that this is an additional standing assumption. As it
stands the manuscript points at a hypothesis that does not cover the thing being assumed — see N4,
and N3 for the scope-section consequence.

### 2.4 Finding 8 — the notation repair introduced a worse collision (partially closed)

The mechanical part is done and I verified it: `\hbar` occurs nowhere in `sections/`; `ζ` is the
rotation equivariant parameter uniformly, matching Woodward QK III's own `ζ` in
`Eul(N_±) = Eul(...)(∓ζ)(∓ζ-ψ)` and in Corollary 9.10(c), so the section is now *more* faithful to
QK III than it was with `\hbar`; and `\xi` occurs only at `08-global-transport.tex` lines 200 and
243–266, with no collision anywhere else in the manuscript.

But the letter chosen is the wrong one. Current text:

> a wall cocharacter \(\xi\) --- written \(\zeta\) in \cite{GonzalezWoodward}, renamed here because
> \(\zeta\) is the rotation equivariant parameter throughout this section

In González–Woodward, `ξ` **is** the equivariant parameter. Verified in four places in their text:

> We identify `H(BG)` with the polynomial ring `Q[ξ]` in a single element `ξ` of degree 2 (l. 131)
> `Eul_G(ν_{X^{G,t}})^{-1} ∈ H(X^{G,t})[ξ, ξ^{-1}]` after inverting **the equivariant parameter `ξ`** (l. 153–154)
> `= QH(X//G)[ξ]` where **`ξ` is the equivariant parameter** (l. 528)
> `Eul(ν_t) ∈ H(M^{G_ζ}_n(C,X,L_t,ζ))[ξ, ξ^{-1}]` its (invertible) Euler class, where **`ξ` is the
> equivariant parameter** (l. 941–942)

So the manuscript has now **swapped** González–Woodward's two symbols: their `ζ` (wall cocharacter)
is the manuscript's `ξ`, and their `ξ` (equivariant parameter) is the manuscript's `ζ`. This happens
inside the one paragraph that cites González–Woodward Lemma 3.17, Proposition 3.18, Remark 3.19 and
Proposition 3.15(c). A reader checking those locators against the source will read every formula
with the two letters exchanged. The parenthetical warns about one direction of the swap and is
silent about the other, which is the more dangerous one, since a reader who trusts the note will
assume `ξ` carries its source meaning.

**Fix:** either choose a letter González–Woodward do not use for either role (`\eta`, `\lambda`, or a
sans-serif `\mathsf w` for "wall"), or extend the parenthetical to say both halves: "written `ζ` in
\cite{GonzalezWoodward}, where `ξ` denotes instead the equivariant parameter that we write `ζ`."
The first is safer.

### 2.5 Finding E3 — orbifold slope bookkeeping (partially closed)

Current text, `prop:gamma-ratio-reduction`:

> Pass to a finite cover which clears stabilizer denominators and apply the splitting principle; the
> domain there is an ordinary line, and slopes are counted per unit of the primitive affine direction
> \(\delta\) on both sides of the identity below, while consecutive degrees inside a tail differ by
> the stabilizer order of Proposition~\ref{prop:app-mu-k}\textup{(b)}.

This addresses the concrete complaint I raised — that `\chi(\mathcal O(n)) = n+1` is the smooth-`P^1`
statement while a tail steps by `k`, so the two sides of `eq:total-moving-slope` were normalized
differently. Fixing both sides to "per unit of `δ`" is the right normalization and closes that
mismatch.

What is still unstated: that the index downstairs is the `μ_k`-invariant part of the index on the
cover, and that the orbifold Riemann–Roch age/degree-shift terms do not contribute to the *slope*.
The second is true for a robust reason — age terms are bounded independently of `k`, so they enter
the rank as `O(1)` and cannot move a coefficient of `k` — and saying that one sentence would close
the item. As printed, the passage relocates the computation to the cover without saying how it comes
back.

### 2.6 Finding E4 — the new normalization input in `lem:point-insertion-row`

Current text:

> One input is taken from the normalization and not proved here: in Woodward's graph-space
> normalization, \(D\tau_{Y,-}\) is the genus-zero fundamental solution of the quantum connection on
> \(Y\), and it is unitary for the \(z\mapsto e^{-\pi i}z\)-twisted pairing of
> Definition~\ref{def:point-row}.

**As a disclosure this is exactly what I asked for and it is closed.** Two consequences that are not:

- The pointer is wrong. `def:point-row` (`02-point-row.tex` l. 18–27) defines the Gamma point row
  `𝔯_{Y,p}(v) := [v, s_Y(\mathcal O_p))`. The `z ↦ e^{-πi}z`-twisted pairing is
  `eq:flat-euler-pairing` (l. 12–15), in the preamble *before* that definition. Point at
  `\eqref{eq:flat-euler-pairing}` or at `Section~\ref{sec:point-row}`.
- It is not registered in `08-scope.tex`. See N3.

### 2.7 Włodarczyk Proposition 2(B') — discharged, with one noted step

Spot-checked the three manuscript uses against
`notes/2026-08-14-c913-wlodarczyk-2bprime-extraction.md` (cache key `arXiv:math/9904074`, sha256
`ac86c460…`), as instructed.

1. *"its source and sink pieces are punctured line-bundle opens with the two endpoint varieties as
   geometric quotients."* Supported: the proof of (B') gives
   `B_+ = O_{X'}(D')^∞ \ S_∞` and `B_- = O_X(-D) \ S_0` with `B_±/K^* ≃ X', X`, and Definition 2
   requires these to be geometric quotients.
2. *"admits a smooth projective equivariant completion whose source and sink quotients are the two
   endpoints."* Supported by the construction in the proof — `B̄(X,D;X',0)` is the canonical
   `K^*`-equivariant resolution of a `K^*`-equivariant projective completion, hence smooth and
   projective — together with Lemma 7(B) for the source/sink structure.
3. *The terminology paragraph.* Exactly right: Definition 5 reads "A cobordism `B` is projective if
   `B` is a quasiprojective variety."

One step to note, which the manuscript makes and Włodarczyk does not: "The glued space is smooth, so
the canonical resolution is an isomorphism over it." The extraction note records that Włodarczyk
"does not name a locus over which [the resolution] is an isomorphism". The inference is sound —
`L(X,D;X',0)` is glued from two line bundles over smooth varieties and is therefore smooth, and a
canonical (functorial) resolution is an isomorphism over the smooth locus — but it rests on a
standard property of canonical resolution, not on anything in the cited proposition. The manuscript
does not attribute it to Włodarczyk, so this is a note rather than a defect; a half-clause naming the
property would make the reader's job easier.

---

## 3. New defects introduced by the repairs

This is the part that matters most, so I checked each changed hunk for collateral damage.

**N1. `rem:app-imports` was not synchronized with repairs 1 and 5.** The remark is the manuscript's
own audit of its import boundary, and it is now out of date in two ways.

> Everything else is either the graded computation of Lemma~\ref{lem:app-graded-extension} and its
> module form, or **a statement of Woodward's** cited at the locators given at the start of this
> appendix.

After repair 5, the locators at the start of the appendix include Graber–Pandharipande and
González–Woodward Corollary 3.20. Neither is "a statement of Woodward's". The inventory sentence is
now false as written.

Second, the remark's account of the comparison stops where the previous version stopped:

> the comparison is then made in Lemma~\ref{lem:app-truncation} on square-zero extensions of
> classical test schemes, in the \v{C}ech presentation of Lemma~\ref{lem:app-cech}.

It says nothing about the Picard-stack bridge that repair 1 added to `prop:app-square`, which is now
the step that carries the comparison from square-zero data to virtual classes. Since this remark is
where a referee will look to see what the appendix assumes and what it proves, it should name the
bridge.

**N2. The `ξ` collision** — see §2.4. This is a defect the repair itself created; the previous
`\hbar`/`ζ` collision was internal to the manuscript, whereas the new one is against a cited source
in the paragraph that cites it. Net, I judge the notation strictly better than before (the internal
three-way collision is gone and `ζ` now matches QK III), but the residual hazard is sharper.

**N3. `08-scope.tex` was not updated, and it now under-reports.** The scope section is the
manuscript's register of "statements of different kinds … their logical roles explicitly". Repair 7
and finding E4 both introduced *new explicit unproved inputs* into Section 8:

- the virtual Kalkman endpoint normalization and the opposite-normal-weight structure
  (`prop:support-collapse`);
- `Dτ_{Y,-}` being the genus-zero fundamental solution, unitary for the twisted pairing
  (`lem:point-insertion-row`).

Item (5) of `08-scope.tex` still reads as it did before the repairs, listing only the proper-DM
master-stack, obstruction-theory, stability, and numerical-separation conditions as assumptions. A
reader auditing what the conditional theorem rests on will not find either new input there. This is
the most consequential of the new defects, because the whole value of that section is that it is
complete.

**N4. `def:gauged-admissible`(ii) is now claimed to contain something it does not.** See §2.3. The
proof asserts that the endpoint normalization is "part of the large-area package assumed in
Definition~\ref{def:gauged-admissible}(ii)"; (ii) names the localized large-area formula and nothing
about Kalkman or endpoint normalization. Either amend (ii) or relabel the assumption. Paired with
N3, the effect is that a genuinely new hypothesis has entered the proof without appearing in either
of the two places the manuscript uses to track hypotheses.

**N5. Mis-pointer to `def:point-row`** for the twisted pairing — see §2.6.

**N6. Paragraph order in `prop:app-square`** — the conclusion precedes the step that was added to
justify it. See §2.1.

**Checked for and not found:** stray `\hbar` (none); `ξ` colliding with another use inside the
manuscript (none — it occurs only in the eleven places in `08-global-transport.tex`); dangling
references to QK III §9.4 in its old role (none); plain-text `(D)-finite` outside a LaTeX comment
(none); broken cross-references introduced by the edits (`def:point-row`, `prop:app-mu-k`,
`prop:app-square`, `lem:app-truncation`, `lem:orbit-cylinder-disjoint`, `prop:support-collapse` all
resolve, and `make check` reports warning-free, so no undefined references); any weakening of
`lem:orbit-cylinder-disjoint`, which is unchanged and which I re-verified in round 1.

---

## 4. Re-verification of the two computational repairs

**Finding 9, the Stirling display.** Current text:

    log|c_k| = -(∑_a h_a) k log k - k ∑_a h_a log|h_a| + (∑_a h_a) k - (∑_a h_a) k log|ζ| + O(log k)

Recomputed independently a second time, with `n_a = h_a k + s_a`:

- `h_a > 0`: `log = -(n_a log n_a - n_a) - n_a log|ζ| + O(log n_a)`
  `= -h_a k log k - h_a k log h_a + h_a k - h_a k log|ζ| + O(log k)`.
- `h_a < 0`: `log = |n_a| log|n_a| - |n_a| + |n_a| log|ζ| + O(log|n_a|)`
  `= -h_a k log k - h_a k log|h_a| + h_a k - h_a k log|ζ| + O(log k)`.

Summing over `h_a ≠ 0` reproduces the display term for term, including the sign of the new fourth
term. The accompanying sentence — that it "is the one contributed by the scale of `ζ`" and "is
written out because the display is the general expansion, before neutrality is imposed" — is
accurate, and neutrality does kill it, since its coefficient is again `∑_a h_a = c_1^{\Gm}(TW)·δ`.
The specialization "after specializing the rotation parameter `ζ` to a nonzero complex number" is
now stated where magnitudes are taken, which was the latent issue behind the omission. **Closed.**

One residual ambiguity, pre-existing: "kills the `k log k` term, the linear term, and that scale
term" — `-k ∑_a h_a log|h_a|` is also linear in `k` and is *not* killed; it is the term removed by
the rescaling in the next sentence. "The linear term" should be "the term `(∑_a h_a)k`".

**Finding 6, the family cover.** Current text:

> take instead \(U_F:=\{x\in U\cap W^{\mathrm{gen}}:\ \lim_{t\to0}t^ax\in U\cap F\}\), which is open
> in \(W_F^a\), since the limit map \(W_F^a\to F\) is a morphism and \(U\cap F\) is open in \(F\).

Checked: `U_F = (U ∩ W_F^a) ∩ λ^{-1}(U ∩ F)` where `λ: W_F^a → F` is the Białynicki-Birula limit
map. `U` is open in `W` so `U ∩ W_F^a` is open in `W_F^a`; `λ` is a morphism hence continuous and
`U ∩ F` is open in `F`, so `λ^{-1}(U ∩ F)` is open. The intersection is open. The containment
`U_F ⊆ W_F^a` holds because `\lim ∈ U ∩ F ⊆ F`. The preceding invariance paragraph proves exactly
that for each `x ∈ W_F^a` there is an invariant affine `U` with the whole completed orbit — `x`, the
orbit, and the limit — inside `U`, which is precisely membership in some `U_F`; so "The previous
paragraph proves precisely that these `U_F` cover `W_F^a`" is accurate, not a restatement. With the
cover by `U_F`, the section `z ↦ z^a x` including its `z = 0` value factors through `U`. **Closed.**

Two nits: `W^{\mathrm{gen}}` in the definition is redundant, since `W_F^a` already imposes it, and
harmless; and the openness argument uses that the limit map is a morphism, which is standard
Białynicki-Birula but is asserted without a pointer — as is the rest of the surrounding paragraph,
so this is consistent rather than a new gap.

---

## 5. Re-verification of finding 3, including the "overstated in the other direction" question

Current text:

> on the locus of bundles with sections that are constant in some trivialization near the
> distinguished parametrized point, it is the evaluation there, valued in the inertia stack of the
> quotient \cite[Section~9.4]{WoodwardQKIII}. Its value is the principal-component value, because
> the section is constant near that point; it is not the value at \(0\) or \(\infty\), where the
> bubble trees attach and where the value is a cocharacter limit carrying no semistability.

Compared against QK III §9.4 as printed:

> denote the locus of bundles with sections that are constant in some trivialization in a
> neighborhood of `BZ_k` and `n_±` markings map to `0 ∈ P(1,k)` … Consider the evaluation map
> `F^G_{n±,1}(d) → I_{X//G}` at `BZ_k ⊂ P(1,k)`.

The gloss now tracks the source clause by clause, including the inertia-stack target. The negative
half — "not the value at `0` or `∞`" — is correct and is what (55)'s constraint
`u(z_{n_±+1}) = \lim_{z→±∞} φ̃_±(z)x` says. **Not overstated.**

The Remark 3.19 sentence:

> note that the framings are compared in the ambient \(W^\xi\), so it is the principal side that
> carries the semistability

is also correct and correctly restrained. Remark 3.19's fibre product is over `(X^ζ)^r`, not over
`(X^{ζ,t})^r`, so the bubble side genuinely carries no semistability, while the principal factor
`M^{G_ζ,fr}_r(C, X^{ζ,t})` has `X^{ζ,t}` as its target and therefore does. The manuscript claims
exactly this and no more. The load-bearing inference — distinguished slot is a principal-component
value, principal component maps to `W^{ξ,t}/G_ξ` by Lemma 3.17, hence the slot lands in a
`L_t`-semistable fixed component — is now direct and does not route through the framings at all.

---

## 6. Coverage — what this round did not re-examine

- Everything in `08-global-transport.tex` after the proof of `prop:clutching-tail-holonomicity`.
  Note that `hyp:marked-threshold-wall` refers back to `eq:support-collapse-row`, so the residual in
  finding 7 touches what that hypothesis is comparing.
- `rem:neutral-boundary`'s characterizations of Aleshkin–Liu and of González–Woodward Remarks
  1.18(d), 4.6, 4.7 — unchanged by these repairs and still unverified against Aleshkin–Liu, which is
  not in the cache.
- QK II directly (Proposition 5.21, Example 6.6(c), §4.3, Proposition 4.3(f),(g), §6) — still relied
  on via the extraction note.
- `prop:app-mu-k` and `prop:app-cutting` — unchanged by these repairs; not re-read this round beyond
  the cross-reference from the new slope sentence to `prop:app-mu-k`(b), which resolves and says what
  the slope sentence claims it says.
- Mumford GIT Chapter 2 §2.1 Theorem 2.1 — still not in the cache, still **UNVERIFIED**, still
  mitigated by the manuscript's self-contained derivation.
- No LaTeX build was run; I relied on the reported warning-free `make check` for reference
  resolution and checked the substantive cross-references by grep.
