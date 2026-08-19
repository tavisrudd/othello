# Paper IV review memo — q13-passant-code (`papers/q13-passant-code/passant_code_q13.tex`)

**Date:** 2026-08-19 · **Task:** C919 follow-up, review of external abstract-tightening proposal (read-only; no manuscript edit made)

**Verdict:** Proposal is mathematically accurate but *longer* than the current abstract (194 vs 184 words); its one real improvement is the explicit "weighted 2-section is a complete invariant" headline. Recommend my 182-word version below: same claim set, adds that headline, cuts the rhetorical opener.

## 1. Word counts (uniform `wc -w` on the raw LaTeX abstract body)

| Version                          | Words |
|----------------------------------|-------|
| Current abstract (tex 41–63)     | 184   |
| Proposed replacement             | 194   |
| Recommended version (this memo)  | 182   |

The proposal *lengthens* the abstract of the one paper whose current abstract it itself calls "already good". Against the author's standing tight-and-short preference, verbatim adoption is not justified; the content is.

## 2. Claim-by-claim verification of the proposed replacement

All line numbers refer to `papers/q13-passant-code/passant_code_q13.tex`.

| Proposed claim | Verdict | Evidence |
|---|---|---|
| `[78,36,12]_2` parameters | correct | Theorem 1.1 at 106; dim 36 via Madison–Wu at 227–228; DMM Table 8 report at 196–198 |
| exactly 364 minimum words | correct | 106–107; count `56·78/12 = 364` at 478–479 |
| four `PGL(2,13)`-orbits, one octahedral (stab `S_4`) + three chord-indexed punctured-conic (stab `D_{24}`) | correct | 107–110; toric families 505–530; octahedral 531–539 |
| every orbit spans `K` | correct | 110; Gram-scalar proof 769–791 |
| weighted 2-section is a complete invariant of the marked (conic-plane) presentation | correct in substance | Theorem: "the weighted 2-section of H reconstructs the incidence matrix, code, and elliptic scheme" 118–119; conclusion states it verbatim as "a complete invariant of the marked presentation up to isomorphism" 1046–1050. Two quibbles: (a) the proposal coins "marked conic-plane presentation" — the paper's terms are "marked code–hypergraph presentation" (646–647) and "marked presentation" (1050); (b) the proposal drops "up to isomorphism", which the paper carries (134, 648, 1050) and the proposal's own cross-check item 4 demands. Partially recovered later by "without coordinates or a projective frame", but the words should be restored. |
| pair concurrences recover the 78 passant incidence rows, the code, the six-class elliptic scheme | correct | rows: `c(P,Q)=8` neighborhoods = 78 rows of `M`, 116–117 and 618–628; code 630–638; six relations: ρ takes six values 559–561, fusion split by pair-derived `d_7` 587–598; "six-class" naming already in current abstract 51–52 and keywords 66–67 |
| pair parity alone recovers `K` (= `im R_H = K`) | correct | Theorem 115–118; `R_H = A_10 + A_12`, rank 36, `im R_H = K` at 630–638 |
| recovered scheme has automorphism group `PGL(2,13)` | correct | Theorem 125–128; four-anchor rigidity 793–828; `Aut(K)=Aut(H)` 830–833 |
| Sylow-13 subgroups and involutions reconstruct all 183 points and lines, conic, polarity | correct | Theorem 120–123 ("fourteen Sylow-13 subgroups and 169 involutions"; 14+169=183); Section 5 at 835–899; adjoint trace model 869–884 |
| "without coordinates or a projective frame" | correct | 131–135 (no ordered frame, field labeling, or conic equation; 2184-triple torsor); 646–648 |
| unary statistics constant ⇒ exact arity two | correct | every coordinate lies in 56 minimum supports, 638–640; arity-two exactness 640–645; Theorem 124–125. Proposal red-team correctly scopes it to minimum-support statistics. |
| binary relation algebra acts on `K` through `F_8`; `K` twelve-dimensional over it | correct | Proposition 4.1 at 718–727; `B^3+B^2+I=0`, `K ≅ F_8^{12}` 729–742. Body warns this is an operator-field structure, "not a relabeling as a length-26 code over F_8" (740–742) — the abstract's wording ("acts on K through F_8") stays on the right side of that line. |
| distance proof: weight 8 by PSD clique obstruction, weight 10 by line-moment profiles + bounded stabilizer exhaustion | correct | weight 8: seven-clique vs clique bound 5 from rank-28 PSD form, 237–358; weight 10: moment (eq. at 380–382) → two shapes 384–394, closed by 4 `D_14`-orbit and 33 `D_28`-orbit checks 396–431. Proposal drops "two" (profiles); harmless, but the current wording is one word and more informative — keep "two". |
| "intentionally specific to q=13" scope caveat | correct and required | current abstract 61–62; intro 80–84; conclusion 1041–1044 |
| proposed title matches actual title | correct | 32–33 |

No claim in the proposed replacement is unsupported by the paper. Nothing in it needs to be declined for mathematical reasons.

## 3. Macro check

Macros used in the proposed block: `\PG` (tex 26), `\PGL` (tex 27), `\F` (tex 25). All defined in this paper's preamble. No `\PP`, `\cU`, `\Q`, or other foreign macros leak in from the other papers' sections. Plain `\( \)` math and `---` dashes match house usage. **All macros defined; nothing missing.**

## 4. Judgment of the proposal's own red-team notes

All six Paper IV notes and all five cross-paper item-4 bullets are correct:

1. "2-section complete invariant = the main theorem/conclusion's claim" — right (118–119, 1046–1050), with the two wording quibbles in §2 above ("marked conic-plane presentation" is coined; "up to isomorphism" silently dropped from the abstract text even though the note set itself requires that scoping).
2. "pair parity alone recovers K matches im R_H = K; don't extend to the full plane" — right; the full plane needs weighted concurrences plus the pair-derived common-neighbor count (587–598) and the group (835–899).
3. "full plane via recovered scheme/group, Sylow-13 + involutions" — right (120–123, 835–899).
4. "no canonical frame / field labeling / conic equation claimed" — right (131–135, 646–648).
5. "exact arity two is about the specified minimum-support statistics only" — right (638–645).
6. "keep the fixed-q=13 caveat" — right; it is a scope qualification and stays.

Cross-paper item 4's `F_8` bullet ("relation-algebra action on the binary code, not natural `F_8`-linearity of the incidence matrix") matches the body's own disclaimer at 740–742 exactly.

The one thing the red-team notes miss: the proposal's replacement is longer than the abstract it replaces, and it states the threshold twice (headline sentence + later arity sentence), which is where the extra length comes from.

## 5. Recommended abstract (182 words, paste-ready)

```latex
\begin{abstract}
Let \(K\) be the binary nullspace of the passant-by-internal
incidence matrix of a nonsingular conic in \(\PG(2,13)\).  We prove that
\(K\) has parameters \([78,36,12]_2\) and exactly \(364\) minimum words,
forming four \(\PGL(2,13)\)-orbits---one octahedral family and three
chord-indexed punctured-conic families---each spanning \(K\).

Weighted pair concurrences in the minimum supports recover the \(78\)
passant incidence rows and the six-class elliptic association scheme; pair
parity alone recovers \(K\).  The recovered scheme has automorphism group
\(\PGL(2,13)\), whose Sylow-\(13\) subgroups and involutions reconstruct
all \(183\) points and lines of \(\PG(2,13)\), the distinguished conic,
and its polarity, without coordinates or a projective frame.  Thus the
weighted \(2\)-section of the minimum-support hypergraph is a complete
invariant of the marked presentation up to isomorphism, while its unary
statistics are constant: reconstruction has exact arity two.  The binary
relation algebra acts on \(K\) through \(\F_8\), making \(K\)
twelve-dimensional over that field.

The distance proof reduces weight eight to a positive-semidefinite clique
obstruction and weight ten to two line-moment profiles followed by bounded
stabilizer exhaustion.  The theorem is intentionally specific to \(q=13\):
it gives complete ambient reconstruction, not a uniform distance formula.
\end{abstract}
```

**What I cut and why.**
- The opening rhetorical question ("How little of an incidence code…?", 16 words). It duplicates the introduction's first sentence verbatim (tex 41–42 vs 75–76), and the complete-invariant/exact-arity sentence now states the same inverse-problem thesis mathematically. Not a theorem and not a scope qualification.
- "the code" from the concurrence list: "pair parity alone recovers \(K\)" in the same sentence already advertises code recovery; listing it twice was redundant in both the current abstract and the proposal.
- The proposal's double statement of the threshold (headline sentence *and* a separate arity sentence). Merged into one capstone sentence placed after the reconstruction chain, where "the marked presentation" is grounded by the objects just named — the proposal's headline-first placement uses the term before any of its content appears.

**What I refused to cut.**
- Every number: `[78,36,12]_2`, 364, four orbits, 78 rows, 183, six-class, twelve-dimensional over `F_8`.
- Orbit spanning ("each spanning \(K\)").
- All scope qualifications: "without coordinates or a projective frame"; "up to isomorphism" (restored — the proposal dropped it); the unary-constancy basis for "exact arity two"; the whole fixed-`q=13` final sentence.
- "two line-moment profiles" (the proposal's "line-moment profiles" loses the shape count for zero savings).
- The proof-method sentence: it shows the minimum distance is proved, not assumed (the proposal's own note 6 rationale).

**Pre-release DOI / advertised claim set.** No theorem is added to or removed from the advertised set. Removals are the rhetorical question (not a claim) and a redundant mention of code recovery (still claimed via pair parity). The one addition — "complete invariant of the marked presentation up to isomorphism" — is a compact restatement of claims the current abstract already advertises jointly (full recovery chain + exact arity two) and is stated verbatim in the paper's conclusion (1046–1050). Substantively the advertised claim set is unchanged; if the bar is "not even a reformulation under the published DOI", the fallback is to keep the current abstract and apply only the antecedent fix noted in §6.1.

Layout: 182 < 184 words, so no page-1 risk relative to the current build.

## 6. Separate manuscript issues (noted, not fixed)

1. Current abstract, tex 56–57: "The binary relation algebra acts on \(K\) through \(\F_8\), making **it** twelve-dimensional over that field" — ambiguous antecedent ("it" could read as the algebra, whose image is 1-dimensional over `F_8`). Both the proposal and my version fix this to "making \(K\)".
2. Current abstract, tex 51–53: "Pair parity recovers \(K\), while unary minimum-support statistics are constant; reconstruction **therefore** has exact arity two" — the "therefore" overreaches from that sentence alone (exact arity two needs full pair-data sufficiency, stated in the *previous* sentence, not just parity → `K`). Both replacements repair the logic by attaching the arity claim to the full reconstruction.
3. The keywords (tex 66–67) list "weighted hypergraph \(2\)-section" but the current abstract never uses the term; either replacement closes that gap.
4. Abstract/introduction duplication: the current abstract's opening question is repeated verbatim as the introduction's first sentence (75–76). My version removes the abstract copy; if the question is kept in the abstract, consider varying the intro instead. (Observation only — no edit made.)
5. Spot-checked arithmetic while verifying (all consistent, no issue found): concurrence census 273/1092/546/546/546 sums to `C(78,2)=3003` and total incidence `66·364=24024` (582–585); `56·78/12=364` (479); valencies 7+5·14=77 (574–576); 14+169=183 (121–122, 889–893).
