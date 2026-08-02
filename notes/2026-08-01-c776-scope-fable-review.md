# C776 scope decision — Fable review of the adopt/hold split

**Lane**: `ame-lu`
**Date**: 2026-08-01
**Status**: COMPLETE (single read-only pass; this file is the only write).

Reviewer: Fable sub-agent. Read in full: `papers/ame_lu/main.tex` and all eleven section files;
`theorem-map.md`, `claim-proof-novelty-ledger.md`, `adversarial-proof-evidence-audit.md`,
`formal-statement-adequacy.md`; the external-session README and all three notes;
`2026-08-01-external-chat-artifact-gap-review.md`; `2026-07-24-c581-phase-space-robust-rigidity.md`;
the lane handoff; the C774--C777 and C782--C785 queue rows; `papers/style-guide.md`.

Standing caveats. (1) Everything below assumes the C774 red-team passes; I checked the external
note's arguments for structural soundness (see §4 defects), not line-by-line correctness — C774
owns that. (2) C775 has not run; no novelty is asserted anywhere below, and each item's
audit-dependence is stated explicitly. (3) The stability threshold ε₀ is non-explicit; no
certification claim is treated as available.

Notation used throughout: Theorem A = discreteness of the product-symmetry group from 2-uniformity
alone; Theorem B/B′ = the stability bound `D ≤ √(6q/5)·eps` and its decomposition corollary;
Prop C = exact quantum-Fisher isotropy; Cor D = finiteness of local gauge groups of 2-unitary
gates; C581 = the existing `[6,3,4]_q` intertwiner bound `2√2·q²·ε` with explicit threshold τ_p.

---

## 1. Verdict on the split

**Verdict: the direction is right; the boundary is drawn one notch too coarse.** Adopt
discreteness and stability as recommended, and additionally adopt (i) the Fisher-isotropy
*identity* as a remark attached to the stability theorem, and (ii) the C581 intertwiner bound into
the same quantitative section. Hold only the metrology-complementarity *exposition*, the
certification/self-testing story, and (pending C775) the 2-unitary gauge corollary.

### The strongest case against the recommended split, argued first

**(a) Stability without Fisher is expositionally incoherent — and the objection is half right.**
The second-moment identity (★) — `⟨M²⟩ = (1/q)·Σ‖h_j‖²_F`, the sum-of-local-generators map is an
isometry up to `1/√q` — is simultaneously the entire proof engine of Theorems A and B *and* the
Fisher-isotropy statement: Prop C's proof in the source note is literally "Immediate from (★) and
⟨M⟩ = 0", since `F_Q = 4·Var(M)`. Adopting B while holding C means the paper proves the identity,
uses it, states that the constant is party-count independent, and withholds the one-sentence
explanation of *why* (the Hessian of the defect function is exactly the QFI form, and 2-uniformity
makes that form exactly isotropic — no enhanced direction, no degenerate direction). The style
guide's central injunction is "expand the point where understanding is won"; the n-independence of
the constant is precisely such a point, and its explanation costs two to four sentences. So the
objection succeeds against holding the *identity*, and fails against holding the *narrative*: the
Bell/GHZ complementarity discussion, the standard-quantum-limit framing, and the certification
protocol are a genuine register shift serving a physics-estimation audience, are the bulk of the
held material's length, and are exactly what a companion letter is for. The correct cut is
identity-in (as a remark), story-out.

**(b) Is discreteness alone too thin to be worth a section?** As a *section*, yes — it is a
two-line second-moment proof. But nobody needs to give it a section. The manuscript already has
`cor:discrete-lu-symmetry` in Section 3 proving finiteness of the projective product-symmetry
group *from Cliffordness* for stabilizer AME states. Theorem A is the exact complement: finiteness
from *entanglement alone*, for arbitrary (including nonstabilizer) 2-uniform states, with the
stabilizer hypothesis demoted to its true job of identifying *which* finite group appears. It
slots into the existing subsection as a theorem preceding the corollary, cleanly splitting the
rigidity phenomenon into an entanglement half and an algebraic half — which is the four-step
mechanism story the introduction already tells, sharpened. And it patches a limitation the
manuscript states in its own introduction: the paragraph citing Ramadas–Lakshminarayan 2025
currently ends "nonlinear orthogonal arrays and nonstabilizer AME states are not covered."
After adoption that paragraph gains a genuinely memorable contrast: arbitrary phased AME(6,d)
states fall into infinitely many LU classes, yet every one of them has a finite product-symmetry
group modulo phase. Thinness is not a defect here; a two-line proof that removes a stated
hypothesis from a headline-adjacent result is the best kind of addition. Verdict: the objection
fails; adopt, but as a theorem-plus-remark inside Section 3, not a new section.

**(c) Do C581 and the new bound genuinely belong together, or merely look similar?** They are
genuinely different theorems that answer each other's obvious referee question, which is the
strongest form of belonging together. Verified differences: C581 bounds the distance of each local
factor of an approximate *intertwiner between two* `[6,3,4]_q` MDS–CSS states from the Clifford
*group*, constant `2√2·q²`, with a fully explicit threshold (`2q²ε < τ_p`, no compactness);
Theorem B/B′ bounds the *generators* of an approximate *symmetry of one* 2-uniform state, constant
`√(6q/5)` independent of party count, threshold non-explicit. Different objects, different
conclusions, different constants, different hypotheses. Adopt only B and a referee asks "what
about intertwiners between two states?" — C581 answers it. Adopt only C581 and a referee asks
"does the constant degrade with system size?" — B answers it for the symmetry problem. The C581
successor note (2026-08-01) already makes this argument and I find it correct. Two further facts
sharpen the pairing rather than blur it. First, C581's threshold is explicit where B′'s is not, so
in the assembled section each theorem covers the other's visible weakness. Second — my own
observation, judgment not verified computation — the two constants are *structurally* different,
not cosmetically: C581's `q²` is the reciprocal of the normalized four-party marginal Weyl
coefficient, and running the same argument on the `(m+1)`-party marginal of a general AME(2m,q)
state would give a coefficient `q^{-(m+1)/2}`, i.e. an intertwiner constant that *grows with m*,
whereas B's Hessian constant is exactly n-independent. Whether the intertwiner bound can be made
party-count independent by relativizing the Hessian argument over an exact base intertwiner
(the source note's follow-up item 2) is a well-posed successor question, not a reason to keep the
results apart. Verdict: adopt both into one quantitative subsection; the "merely look similar"
worry is unfounded.

**(d) Is a companion letter viable at all if the threshold computation fails?** No — and that is
an argument for refining the split, not against it. If the explicit-ε₀ computation fails, the
held bucket contains: a one-line identity (Prop C), a definitional translation (Cor D), and a
certification story that cannot be written without a threshold. That is a remark and a citation,
not a letter. The gate is correctly placed (a letter is only worth writing with an explicit
threshold), but it follows that nothing of standalone manuscript value should be held hostage to
it. Under the refined split, the hostages are freed: the Fisher identity rides with Theorem B, Cor
D is decided by C775 rather than by the letter's fate, and the only thing gated on the threshold
is the certification narrative — which genuinely cannot exist without it. If the threshold
computation succeeds, the letter has real content: the explicit self-testing statement, the full
complementarity exposition, and the protocol. Either outcome is clean.

**(e) One contingency the recommendation does not state.** The source note itself flags
(Rather–Burchardt–Życzkowski line) that discreteness precedents for special cases exist and a
referee may locate partial precedents. If C775 finds a *full* precedent for "2-uniform ⇒ finite
product-symmetry group mod phase, arbitrary states," Theorem A degrades from adopted theorem to
cited remark, and the adoption headline becomes stability alone. The split decision should record
this branch now so the cold read is not surprised by it. The same applies item-by-item below.

---

## 2. Inclusion guidance, concretely

| Item | Call | Where | Cost to focus | Lean (C777) |
|---|---|---|---|---|
| Theorem A (discreteness from 2-uniformity) | **adopt** | Section 3, new short subsection before `cor:discrete-lu-symmetry` | ~1 page + intro/abstract touch-ups | formalize (already in C777's row) |
| Theorem B (explicit local stability) | **adopt** | same subsection, after Theorem A | ~1 page | formalize; heaviest new item |
| Corollary B′ (decomposition below ε₀) | **adopt with visible caveat** | same subsection | ~0.5 page | conditional interface only |
| C581 intertwiner bound | **adopt** | same subsection, as the two-state counterpart | ~1 page | conditional interface or defer |
| Prop C (Fisher isotropy) | **adopt the identity as a remark; hold the exposition** | remark attached to Theorem B | 2–4 sentences | prose-only |
| Cor D (2-unitary gauge groups) | **conditional adopt as remark, gated on C775; else hold** | end of the subsection or conclusion | 3–5 sentences | prose-only |
| Certification / self-testing story | **hold**, gated on explicit ε₀ | companion letter | zero | n/a |

Details, per item.

**Theorem A — adopt.** Placement: `sections/03-lu-rigidity.tex`, immediately before
`cor:discrete-lu-symmetry`; the corollary then reads as the stabilizer specialization in which the
finite group is identified as local Clifford. Required structural changes elsewhere: (1) the
introduction's Ramadas–Lakshminarayan limitation paragraph must be rewritten — nonstabilizer AME
states remain unclassified, but their symmetry *discreteness* is now covered; (2) one sentence in
the abstract; (3) a new row in `tab:result-scopes` (domain: arbitrary 2-uniform pure states,
n ≥ 4, all q — strictly larger than every other row's domain, worth displaying); (4) rows in
`theorem-map.md`, the claim/proof/novelty ledger, the frozen boundary table, and the Section 8
claim-to-trust map. Exposition requirement found in my pass (see §4): the manuscript proof must
state that the product map `U(q)^n → U(q^n)` is a Lie-group homomorphism with compact image, so
that a one-parameter subgroup of G(ψ) has a generator of the summed local form — the source note
assumes this silently. Free addition (see §3): a two-sentence boundary remark that stabilizer plus
2-uniform does *not* suffice for the Clifford half — the 16-qubit Reed–Muller RM(1,4) coset state
is 3-uniform and carries the non-Clifford transversal-T symmetry via triple-evenness, a
textbook-credited mechanism — so Theorem A's finite group genuinely contains non-Clifford elements
off the AME locus. This makes the two-halves separation sharp in both directions without
importing any of the gated C778–C780 programme.

**Theorem B — adopt.** Same subsection. The statement is unconditional and the constant explicit;
the smallness condition `t ≤ 1/2` is on the *total* generator norm and should be displayed as
such. State the asymptotic sharpness (`D/(√q·eps) → 1`) as the source note does; the 5/6 is
Taylor-cutoff slack, not structure. The AME(4,3)/GHZ numerics belong in the C774 evidence bundle
and, if cited at all, in the supplement under the reproducibility conventions — the theorem does
not need them.

**Corollary B′ — adopt with the compactness caveat in the statement, not a footnote.** The
manuscript's existing discipline (conditional Lean interfaces, named hypotheses) is the right
model: ε₀ exists by compactness, is not explicit, and the follow-up that would make it explicit is
a named successor task. Do not let "approximate rigidity of stabilizer AME states" be quotable
without the ε₀ qualifier.

**C581 — adopt, presented per its own literature note.** As the two-state counterpart: explicit
threshold τ_p, constant `2√2·q²`, scope `[6,3,4]_q` equal-phase MDS–CSS pairs, with the
Auddy–Yuan odeco-perturbation line cited and the result framed as the specialization needed here,
never as a general tensor-perturbation theorem (C581's own gate requires exactly this). Also adopt
its negative half as one sentence: no bound tending to zero with ε can target the semilinear
subgroup or split torus, by C623's exact witnesses — this is the same "ambient Clifford, nothing
finer" boundary the paper already draws for exact results, now quantitative. Cost: about a page.
Do not claim any composition between C581 and B′ (a near-Clifford product from C581 is not
automatically near an element of G(ψ)); the two bounds are complementary, not chained.

**Prop C — split the item itself.** Adopt: a remark after Theorem B stating `F_Q = (4/q)·Σ‖h_j‖²_F`
exactly, that kernel directions of the QFI form are exactly continuous product symmetries (the
Bell `U ⊗ Ū` line) and Heisenberg-enhanced directions require the pair correlations that
2-uniformity forbids (GHZ), hence the flat metric *is* the inverse stability constant. Hold: all
further metrology exposition. Audit dependence: QFI statements about k-uniform states plausibly
have precedents in the metrology literature; if C775 finds the identity known, the remark keeps
its explanatory role with a citation and loses any novelty coloring — adoption survives either
way, which is exactly why remark-status is the right level.

**Cor D — conditional.** Value is real (it ports the headline finiteness into the dual-unitary
circuit literature, where local gauge freedom is the standing nuisance) but it is a definitional
vectorization whose worth is almost entirely novelty-dependent, and the gauge-metric normalization
(`q^{-1}‖·‖_F` on gates) is exactly the kind of factor C774 must verify. If C775 clears it: a
three-to-five sentence remark, prose-only, no Lean. If precedents exist: reduce to a citation in
the introduction's related-work paragraph, or drop.

**What gets displaced.** Nothing must be cut; net growth ≈ 3–4 pages on a ~23-page paper. If the
cold read reports crowding, the one passage I would compress first is the displayed nonabelian
factor-set calculus inside `cor:discrete-lu-symmetry` (the cocycle identities and
change-of-section law), which can move to the party-extensions appendix where its only consumers
live. Do not change the title: the headline remains stabilizer rigidity; the 2-uniform theorems
are supporting structure, and "Stabilizer AME" in the title remains accurate for the results that
name it.

**Lean boundary under C777.** Formalizable at reasonable cost: the traceless decomposition, the
single-exponential identity, (★), and Theorem A's finiteness (the compact-Lie step needs the
homomorphism-image lemma; Mathlib has the compact-group topology). Theorem B needs the integral-
remainder Taylor bound for the operator exponential against a state — analysis-flavored, the
heaviest item, but named in C777's row already. B′'s compactness argument and C581 should enter as
conditional interfaces with named hypotheses, consistent with the paper's existing practice; do
not let C777 balloon into formalizing compactness extractions.

---

## 3. Extra juice (`ej`)

Cheap upgrades to do during C776 integration (task-owned deliverables, not discovery-track):

1. **The RM(1,4) boundary remark** (§2, Theorem A entry). Two sentences, textbook-credited
   mechanism, makes the entanglement-half/algebraic-half split sharp in both directions. This was
   found by reading the two companion external notes against Theorem A — the discreteness theorem
   plus the triply-even transversal-T witness give "finite symmetry group containing a
   non-Clifford element of order 8," the exact failure mode showing the Clifford identification
   needs more than stabilizer + 2-uniform.
2. **The Bell-boundary rederivation.** The source note's Remark 2 re-derives the sharp `m ≥ 2`
   boundary as a two-line marginal computation (the cross term in (★) survives for a Bell pair and
   is exactly the `U ⊗ Ū` gauge line). The introduction's existing sharpness sentence can absorb
   this in one clause.
3. **The infinitely-many-classes / finite-symmetry contrast sentence** in the rewritten
   Ramadas–Lakshminarayan paragraph. Free and memorable.
4. **State asymptotic sharpness of the stability constant** (already in Theorem B's statement;
   keep it — the Hessian constant is exactly `1/q`, the `√(6/5)` is within 10% of optimal).

To queue (needs allocation; these answer questions I was sent to ask, so they are deliverables of
this review, but each is new work):

5. **Explicit ε₀ for stabilizer states** (source note follow-up 1). Highest-EV successor: it is
   the gate for the entire held bucket. Two viable routes worth naming in the task: the proposed
   Weyl expansion of the defect function, and — my addition — the observation that C581's
   machinery (Weyl-axis matching with explicit thresholds τ_p) already delivers explicit
   thresholds in the intertwiner setting and may adapt. A third route is in §4 item 1 below
   (higher moments), which I judge the most promising.
6. **Party-count-independent intertwiner stability** (source note follow-up 2, sharpened by the
   §1(c) observation that the marginal-coefficient route forces `q^{(m+1)/2}` growth): relativize
   the Hessian argument over an exact base intertwiner. Would unify B′ and C581 and retroactively
   improve C581's constant from `q²` toward `√q`.

Discovery-track candidates (I was not looking for these; log, do not queue):

7. The network/perfect-tensor-tiling corollary (source note follow-up 4): propagate Theorem B
   through one tiling to bound network-state symmetry groups — speculative programme material.
8. The Gorenstein-socle echo: the phase-boundary note identifies its Schur-cube trilinear
   obstruction with the socle pairing in the reconstruction corpus; if that identification
   survives C778-line scrutiny it is a cross-lane bridge, but it is not this manuscript's
   business.

Surprising or suspiciously constrained values (full disposition in §5): the *exactness* of the
isometry (★) with no error term; the exact n-independence (both explained by the same
cancellation); the `q²` vs `√q` gap between the intertwiner and symmetry constants (open,
successor-owned); the fact that the entire held bucket collapses to nearly nothing if ε₀ stays
non-explicit (a structural observation about the split, resolved by the refined cut in §1(d)).

---

## 4. Terence Tao pass (`tt`)

Opportunities first.

1. **You used only the second moment; your states satisfy an m-th moment condition.** (★) is a
   second-moment identity requiring only 2-uniformity, but an AME(2m,q) state is m-uniform: every
   moment `⟨M^r⟩` with `r ≤ m` equals its maximally-mixed-marginal value and is therefore an
   explicit universal polynomial in the local generator norms. This converts the Taylor-remainder
   step of Theorem B from a crude `|x|³/6` cutoff into exact control through order m, with error
   entering only at order m+1 — quantitative quality *improving with party count*, and a concrete
   route to an explicit ε₀ for the actual AME family that bypasses both the compactness step and
   the Weyl expansion. This is, in my judgment, the single best unexploited lever in the material
   and should be written into the ε₀ successor task (§3 item 5).
2. **Effective compactness.** The defect function is a polynomial on a compact real-algebraic
   group; its zero set is a finite union of torus translates. A Łojasiewicz-type inequality with
   a degree-controlled exponent gives an ε₀ that is explicit-in-principle (ugly but uniform) for
   every stabilizer ψ, independent of the Weyl route. Worth one sentence in the successor task as
   the fallback that guarantees the letter's gate is not vacuous.
3. **The complementarity begs for a perturbative converse.** Prop C is exact at the 2-uniform
   point; the natural next statement is quantitative: pair-marginal deviation `max‖ρ_jk − I/q²‖ ≤ δ`
   bounds the QFI form's anisotropy linearly in δ, interpolating Bell/GHZ degeneracies. Cheap
   lemma, letter material, and it would make the complementarity a theorem rather than an
   interpretation.
4. **The two-state/one-state unification** (already §3 item 6): Tao would observe the defect
   function on the double coset space and ask why the intertwiner problem should have a worse
   constant than the symmetry problem at all.

Defects (referee-visible, all fixable in drafting; none invalidates the split):

5. **The Lie-lift step in Theorem A.** "Let t ↦ U(t) be a one-parameter subgroup of G(ψ) with
   generator (iH_1,…,iH_n)" assumes the generator is a sum of local terms. Correct via: the
   product map `U(q)^n → U(q^n)` is a Lie homomorphism, its image is a compact (hence closed) Lie
   subgroup whose Lie algebra is the image of `⊕u(q)`, and G(ψ) is a closed subgroup of that
   image. Must be written; C774 should confirm.
6. **B′'s right-invariance and decomposition steps** check out (I verified `f(Vg) = f(V)` and
   that the near-identity logarithm with traceless split exists below threshold), but the
   manuscript version should say where finiteness of G(ψ) enters (isolation of zeros) versus
   where the Hessian bound enters (uniform quadratic growth), since the source note compresses
   the two.
7. **Cor D's metric bookkeeping** (`q^{-1}‖·‖_F` on gates) is the classic place to lose a factor
   of q; verify under C774 before any adoption.
8. **Do not overstate n-independence.** The constant is n-independent; the smallness domain
   `t ≤ 1/2` constrains the total generator norm across all parties. One honest sentence.

Alternative methods: the character-sum route (for stabilizer ψ and product U, `⟨ψ|U|ψ⟩` is an
explicitly computable Gaussian-type sum; perturbing around product Cliffords gives a third,
representation-theoretic path to explicit stability) — worth recording in the successor task,
not pursuing now.

---

## 5. Mystery ledger

| Feature | Status | Disposition / owner |
|---|---|---|
| Exactness of the isometry (★) — no error term at all | **settled** | Cross terms cancel precisely because pair marginals are exactly `I/q²` and generators are traceless; 2-uniformity is the minimal hypothesis, and the Bell pair shows its failure mode exactly. |
| Party-count independence of the stability constant | **settled** | It is the exact isotropy of the QFI form (Prop C); this is why the Fisher identity must ride with Theorem B rather than being held. |
| The constant `√(6q/5)` versus the true Hessian constant `√q` | **settled — slack by design** | Taylor cutoff at `t ≤ 1/2`; numerics confirm the Hessian is exactly `1/q`. Not a mystery; state sharpness. |
| Non-explicit ε₀ | **open** | Compactness only. Owner: the ε₀ successor task (§3 item 5), with three named routes (higher moments — §4 item 1, Weyl expansion, Łojasiewicz fallback). Gates the companion letter. |
| `q²` (intertwiner, C581) versus `√q` (symmetry, B) — and the `q^{(m+1)/2}` growth the marginal route forces at general m | **open** | Genuine structural gap, not sloppiness in either proof. Owner: the relativized-Hessian successor (§3 item 6). |
| Whether the Clifford identification descends below AME uniformity | **settled negatively at uniformity ~n^{1/3}** | The RM(r,3r+1) family (corrected per the README) carries exact non-Clifford transversal T; RM(1,4) is the 16-qubit witness. The strip between exponents 1/3 and 1/2 is open and owned by the C778–C785 programme, not this manuscript. |
| Novelty of Theorem A, Prop C, Cor D | **open by construction** | C775. The split decision should pre-register the degradation branches (§1(e), §2): A→cited remark if fully pre-empted; C's remark survives with citation; D→citation or drop. |
| Whether the held bucket has standalone value if ε₀ stays non-explicit | **settled by the refined split** | Under the refined cut, only the certification narrative is gated on the threshold, and it genuinely cannot exist without one. Nothing else is stranded. |

No manufactured mysteries: the two genuinely open mathematical items are the explicit threshold
and the intertwiner-constant gap, and both have named owners and named attack routes.

---

## Sources read and verification boundary

Verified by direct reading: the full manuscript (all section files and `main.tex`), all four
ledgers, all three external notes plus the README defect list, the gap review, the C581 report
including its successor note, the lane handoff in full, and the exact C774–C777 and C782–C785
queue rows. Checked by my own reasoning (not delegated, not replayed computationally): the
cross-term cancellation in (★); the right-G-invariance in B′; the Lie-lift gap in Theorem A's
proof and its standard repair; the RM(1,4) uniformity arithmetic from the note's stated distances
(standard Reed–Muller facts); the `q^{-(m+1)/2}` marginal-coefficient scaling for the general-m
intertwiner route. Everything labeled "judgment" above is mine; the correctness of the external
note's theorems remains C774's to certify, and every novelty-dependent valuation is C775's.
