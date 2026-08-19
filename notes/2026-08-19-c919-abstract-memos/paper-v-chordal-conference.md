# Paper V — Chordal and Conference Cubics (chordal-conference-reconstruction)

**Date:** 2026-08-19 · **Reviewer:** read-only abstract-proposal review (C919 follow-up)

**Verdict:** the proposal's replacement is mathematically accurate but over-compresses two things — the mod-8 dichotomy (a stated conclusion of an intro theorem; keep it) and the two-graph defect definitions; use the counter-proposal below (264 words, current 342, proposal 248).

All line references are to
`papers/chordal-conference-reconstruction/chordal_conference_reconstruction.tex`
at the current working tree.

## 1. Word counts

| Version                      | Words |
|------------------------------|-------|
| Current abstract (lines 50–102)   | 342   |
| Proposal replacement         | 248   |
| Counter-proposal (Section 6) | 264   |

Method: `wc -w` on the abstract body with identical extraction for all three, math tokens counted as words. The counter-proposal is 22 % shorter than current; its 16-word excess over the proposal is exactly the restored mod-8 dichotomy clause plus the defect definitions (see Sections 3 and 6).

## 2. Claim-by-claim check of the proposed replacement

Every sentence of the proposal's LaTeX block was checked against theorem statements, introduction, and conclusion.

1. **Setting (Ω, V, quadratic form).** Supported: lines 172–181 (`k=F_11`, `Ω_0=Syl_5(G)`, `A_0=Aug(k^{Ω_0})`, `Q_0`), dim 5 at line 180. The abstract's Ω/V naming matches the current abstract's own convention (lines 54–56).
2. **Pencil membership and singular types.** Pencil is 2-dimensional (`dim Π = 2`, line 726). Conference cubic has six isolated nodes: line 504 (imported from RuddRigidity2026, also line 707 "exactly six ordinary nodes in projective-frame position"). Chordal cubics singular along a rational normal quartic: Definition metric-chordal-shadow lines 196–199, Lemma hankel-singular-locus lines 519–523. Exactly two chordal lines, both over k: Lemma two-chordal-lines lines 789–798.
3. **Non-projective-isomorphism over the algebraic closure.** Supported but composite: no single numbered statement asserts it. It follows from six isolated nodes (line 504) vs. singular along a curve (lines 196–199, 801), singular-locus dimension being a projective invariant over any field; the body says "spans a different line" (line 505), "the conference and chordal lines are distinct" (lines 708–709), and the conclusion says "geometrically distinct" (line 1539). The current abstract already makes the identical claim (lines 58–60), so the proposal introduces nothing new here. See Section 7 for the observation.
4. **"Recover the same marked six-axis carrier."** Supported: introduction lines 119–121 ("either shadow reconstructs the other and their common six-axis carrier"), conclusion lines 1539–1540 (verbatim "recover the same marked six-axis carrier"). The current abstract's weaker "encode the same marked carrier" (lines 60–61) is upgraded by the proposal to the conclusion's own phrasing; justified.
5. **Constant double cover A_5/C_5 → Ω = A_5/D_10.** Supported: Proposition special-orbit lines 559–571 ("canonical double cover Z_5 → Ω_0", degree-twelve split étale, stabilizer map gC_5 ↦ gN_G(C_5) at lines 597–600); "constant" justified by lines 603–606 (pairs reduced, disjoint, constant; commutes with every scalar extension) and the conclusion's identical wording (line 1541).
6. **Mutually inverse reconstruction functors and their required markings.** Supported: Theorem intrinsic-companion-classification lines 221–258 gives, *for every extension K/k*, equivalences C_conf^L(K) ≃ G_met(K) ≃ C_ch(K) via *neutral scalar extension* — so the qualifications required are (a) selected chordal line L (line 233, 925–927), (b) normalized chordal generator (α² = 8², Definition lines 194–210, Proposition outer-pencil-action lines 744–760), (c) oriented conference generator c = 8^{-1}(q_Π−1)h (lines 240–244, Corollary selected-line-bridge lines 839–852), (d) fixed metric carrier / neutrality (lines 212–216, scope paragraph lines 375–382). The proposal keeps all four qualifications ("either chordal line L … is selected", "normalized chordal generator", "oriented conference generator", "neutral scalar extensions over every field extension of F_11"). Correct.
7. **Free quotient (L,h,c) ↦ (qL,−qh,c).** Supported: Theorem item (iv) lines 249–256 (uq: (L,h,c) ↦ (qL,−qh,c), quotient C_ch/⟨uq⟩, "residual C_2-torsor, not an equivalence"); freeness at line 990 ("fixed-point free on objects") and conclusion line 1549 ("free action"). Distinctness from the conference-orientation torsor: dependency-lattice table lines 1031–1035 — the orientation torsor is u: (h,c) ↦ (−h,−c) while the line-forgetting torsor is uq, which fixes c. The proposal drops the current abstract's "which fixes c" (line 69), which is the visible reason the two torsors differ; cheap to restore (counter-proposal does).
8. **Recognition identity.** Supported: Lemma six-point-alignment-recognition lines 641–662 — 16|A(Δ)| = Σ_{{x,y}} m(xy)², and A(Δ) = ∅ iff S² = 5I (lines 654–659). The proposal's compression leaves "signed pair defect" undefined (the intro uses the phrase informally at line 144, but the abstract's displayed identity is then unverifiable from the abstract alone); the current abstract defines σ and m (lines 74–77). Counter-proposal keeps one-line definitions.
9. **Lattice theorem.** Supported: Theorem conference-saturation lines 1195–1214 — normalized symmetric conference B, n ≡ 2 (mod 4), D_n^∨ = Z^n + Z·1/2 is the minimal φ_B-stable over-lattice of Z^n, φ² − φ = (n−2)I/4, algebra F_4 for n ≡ 6 (mod 8) and F_2×F_2 for n ≡ 2 (mod 8); restated as intro Theorem normalization-residue lines 260–301. The proposal's "normalized" (unspecified) matches the theorem's own level of detail (line 1197); the current abstract spells the first-row normalization out (lines 86–87). Either is defensible.
10. **n = 6 specialization: binary heart, Frobenius, torsor identification.** Supported: heart H_Ω common to both lattices (Proposition common-heart lines 1158–1171, conclusion lines 1552–1555), H the natural 2-dimensional F_4A_5-module with End_{A_5}(H) = F_4 (lines 285–296), reversal and outer normalizer both restrict to Frobenius, torsors identified (Theorem golden-frobenius lines 1403–1429, Cartesian square of principal C_2-torsors). One clarity loss: the proposal's closing "an equivariant identification of the corresponding principal C_2-torsors" never says which torsors — it dropped the map [B] ↦ φ̄|_H and the set {ω, ω²}, so "corresponding" dangles. Counter-proposal restores the map in one clause.

No claim in the proposal is unsupported by the body. The issues are compression losses, not errors.

## 3. The mod-8 dichotomy decision (the flagged open question)

**Recommendation: keep the dichotomy in the abstract, in one compact clause.** Grounds:

1. It is a stated conclusion of *both* headline theorem displays: intro Theorem normalization-residue lines 277–278 and Theorem conference-saturation lines 1212–1213. It is the entire general-n content of the residue half; without it the general statement reduces to the lattice identification alone.
2. It is what scopes the F_4 claim. The proposal's compressed paragraph does *not* literally assert F_4 at every admissible order — "At n = 6" scopes the F_4A_5-module sentence — but it presents the general theorem and then produces an F_4 structure with no signal that the algebra depends on n mod 8. A skimming reader will infer the F_4 structure is generic; the F_2×F_2 half is the only thing in the paper that blocks that reading. The proposal's own red-team bullet ("Do not accidentally imply the F_4 conclusion holds for every admissible order") is satisfied only marginally by its text.
3. Cost is one clause (~20 words; see counter-proposal). The current abstract's φ² − φ = (n−2)I/4 display can be cut instead — the dichotomy carries its content in the abstract, and the identity survives in both theorem statements.

So: not a case for "retain the existing final paragraph instead" (the proposal's fallback, which would keep the Ext/nonsplit-extension detail too), but the dichotomy sentence itself must survive.

## 4. Macro check

Macros used in the proposed LaTeX block: `\F` (line 25), `\PP` (line 28), `\Z` (line 27), plus standard LaTeX/amsmath/amssymb (`\overline`, `\varnothing`, `\pmod`, `\varphi`, `\mathbf`, `\sum`, `\to`, `\longmapsto`). All defined in the preamble (lines 25–40) or by the loaded packages (line 7: amsmath, amssymb, amsthm, mathtools, mathrsfs). **No undefined macros.** The counter-proposal additionally uses `\bar\varphi`, `\mapsto`, `\notin`, `\subset` — all standard; `\vee`, `\omega` standard. The paper has no separate style file; everything is in the single preamble.

## 5. Judgment of the proposal's red-team notes

All seven bullets check out; two annotations:

1. "Safe: the paper proves non-projective-isomorphism over the algebraic closure" — supported but composite (see Section 2 item 3): the six-node count is imported from the companion deep-hole paper (RuddRigidity2026) at line 504, and the non-isomorphism is the singular-locus-type contrast, never a numbered statement. "Proves" is fair; "asserts, with an immediate two-line justification distributed across lines 504–507 and 707–711" is exact.
2. The final bullet correctly identifies the mod-8 omission as the one open author decision and correctly states the misreading risk. Its binary fallback (keep the whole old final paragraph) is coarser than needed — Section 3 gives the middle path.
3. Cross-paper check item 5 (all five sub-bullets) verified: nonisomorphism over the closure (Section 2 item 3); fixed metric/marked carrier with selected line and normalized generators (Theorem lines 221–258, scope lines 375–382); two distinct C_2-torsors (table lines 1031–1035); recognition weaker than the marking — "there are twelve labeled conference switching classes" (lines 146–149); general lattice theorem vs. n = 6 specialization kept separate (Theorems at lines 1195 and 1403). All correct.

## 6. Recommended abstract (paste-ready)

264 words. Shorter than current by 78 words; 16 over the proposal, all of it the restored dichotomy clause and the σ/m definitions.

```latex
\begin{abstract}
Different lossy invariants of the same source need not have the same
geometry.  Let \(\Omega\) be the six Sylow-\(5\) subgroups of \(A_5\) and
\(V\) the five-dimensional augmentation module of \(\F_{11}^{\Omega}\) with
its standard quadratic form.  The \(A_5\)-invariant cubic pencil in
\(\PP(V)\) contains a conference cubic with six isolated nodes and two
chordal cubics, each singular along a rational normal quartic; over
\(\overline{\F}_{11}\) the conference cubic is not projectively isomorphic
to either chordal cubic.  We prove that they nevertheless recover the same
marked six-axis carrier.  The singular quartic recovers the constant double
cover \(A_5/C_5\to\Omega=A_5/D_{10}\).  If either chordal line \(L\) of the
invariant pencil is selected, the outer involution \(q\) gives mutually
inverse reconstruction functors between a normalized chordal generator
\(h\in L\) and an oriented conference generator \(c\), for neutral scalar
extensions over every field extension of \(\F_{11}\).  Forgetting \(L\) is
exactly the free quotient \((L,h,c)\mapsto(qL,-qh,c)\), which fixes
\(c\): a residual \(C_2\)-torsor distinct from the conference-orientation
torsor.

The conference locus also has an intrinsic six-point recognition theorem.
If a Seidel matrix \(S\) represents a two-graph \(\Delta\) on a six-set,
with triple signs \(\sigma(xyz)=S_{xy}S_{yz}S_{zx}\), pair defects
\(m(xy)=\sum_{z\notin\{x,y\}}\sigma(xyz)\), and \(A(\Delta)\) the family of
four-sets with constant triple sign, then
\(16|A(\Delta)|=\sum_{\{x,y\}}m(xy)^2\), so \(A(\Delta)=\varnothing\)
exactly when \(S^2=5I\).

Finally, for every normalized symmetric conference matrix \(B\) of order
\(n\equiv2\pmod4\), the least \(\varphi=(I+B)/2\)-stable lattice containing
\(\Z^n\) is \(D_n^\vee=\Z^n+\Z\mathbf1/2\), and the induced algebra
\(\F_2[\bar\varphi]\) on \(D_n^\vee/2D_n^\vee\) is \(\F_4\) for
\(n\equiv6\pmod8\) and \(\F_2\times\F_2\) for \(n\equiv2\pmod8\).  At
\(n=6\) the binary heart is the natural \(\F_4A_5\)-module \(H\); the map
\([B]\mapsto\bar\varphi|_H\) identifies \(\{[B],[-B]\}\) with
\(\{\omega,\omega^2\}\subset\F_4\), and conference reversal acts by
Frobenius, an equivariant identification of principal \(C_2\)-torsors.
\end{abstract}
```

**Cut, and why:**

1. Second sentence of the current abstract ("We ask when two such cubic shadows…") — restates sentence one plus the later results; the proposal cuts it too.
2. "where L is a one-dimensional subspace of the invariant pencil" (current lines 62–63) — folded into "chordal line L of the invariant pencil"; the body itself writes "chordal line L ⊂ Π" (line 841) without gloss.
3. The display φ² − φ = (n−2)I/4 (current lines 90–91) — its abstract-level content is the dichotomy, which is kept; the identity stays in both theorem statements.
4. The Ext/nonsplit-extension detail ("unique nonsplit extension … of a trivial line by the natural module H, with End_{A_5}(H) = F_4", current lines 93–96) — interior structure of the n = 6 residue; the abstract-level claims (natural F_4A_5-module heart, Frobenius, torsor identification) are kept.
5. "conference reversal corresponds to Frobenius z ↦ z²" — the formula z ↦ z² (current line 99); "Frobenius" on F_4 is unambiguous.
6. The proposal's wrap-up sentence "Thus the two invariant cubic lines remain genuinely distinct while retaining equivalent marked-source information" — restates items already in the first paragraph; also "the two invariant cubic lines" is loose (the pencil has three distinguished lines: one conference, two chordal — the conclusion at lines 1546–1547 has the same looseness, see Section 7).

**Refused to cut:**

1. Non-projective-isomorphism over the closure (the hook).
2. Every marking/normalization qualification on the reconstruction: selected L, normalized h, oriented c, neutral scalar extensions, every extension of F_11.
3. "which fixes c" — restored against the proposal; it is the one-glance reason the two torsors differ.
4. The mod-8 dichotomy — restored against the proposal (Section 3).
5. The σ/m/A(Δ) definitions — restored against the proposal; without them the displayed identity is unverifiable from the abstract and "signed pair defect" is an undefined term.
6. "normalized" on B, and the map [B] ↦ φ̄|_H with {ω, ω²} naming the second torsor — the proposal's "corresponding principal C_2-torsors" left both torsors unnamed.

## 7. Separate manuscript issues (noted, not fixed)

1. Line 138: "The resulting categories are therefore honest metric groupoids" — uses a word on the author's forbidden list for all docs; needs rewording (e.g. "genuine metric groupoids" or drop the adjective).
2. The non-projective-isomorphism over the closure, asserted in the abstract (lines 58–60), has no numbered statement in the body; it is carried by the node-vs-curve contrast at lines 504–507 and 707–711 plus "geometrically distinct" (line 1539). A one-line remark or corollary would close the abstract-to-body gap.
3. Conclusion lines 1546–1547: "without identifying the two invariant cubic lines themselves" — the pencil carries three distinguished lines (one conference, two chordal); "the two invariant cubic lines" presumably means the selected chordal line and the conference line, but as written it undercounts. Same phrase inherited by the proposal's wrap-up sentence (cut in the counter-proposal).
4. Abstract line 60–61 says "encode the same marked carrier" while the introduction (line 120) and conclusion (line 1540) say "reconstructs/recover … six-axis carrier"; the current abstract is the odd one out (moot if replaced).
