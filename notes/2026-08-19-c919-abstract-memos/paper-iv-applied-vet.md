# Paper IV — cold vet of the applied abstract (`papers/q13-passant-code/passant_code_q13.tex`)

**Date:** 2026-08-20 · **Task:** C919 follow-up, read-only referee vet of the working-tree abstract (no manuscript edit, no build, no git write)

**Verdict:** Every mathematical claim in the new abstract is supported by the body, including the two flagged risks — dropping "the code" from the concurrence list is faithful because "pair parity alone recovers \(K\)" is the stronger statement the theorem actually proves, and "exclude" is the correct verb because the weight-eight and weight-ten arguments terminate in impossibility, not in a further reduction. No blockers. Three wording repairs are recommended, the sharpest being that the third paragraph no longer says *what* the two exclusions establish (the minimum distance).

All line numbers are `papers/q13-passant-code/passant_code_q13.tex`. The diff hunk is length-preserving (`@@ -38,28 +38,28 @@`), so body line numbers are identical in `HEAD` and the working tree.

---

## 1. What changed, and how long it is

New abstract occupies lines 41–62. Word counts on the raw LaTeX abstract body: previous 184, new 185 — no net length change.

Structural changes relative to `HEAD`:

| # | Change | Character |
|---|--------|-----------|
| 1 | Opening rhetorical question "How little of an incidence code is needed…" deleted | Rhetoric only; the sentence survives verbatim as the first sentence of the introduction (75–76) |
| 2 | Orbit spanning demoted from an independent clause to the participle "each spanning \(K\)" | Same claim (110, 791) |
| 3 | "the code" dropped from the concurrence-recovery list | Covered by "pair parity alone recovers \(K\)" — see §3(a) |
| 4 | Scheme-automorphism and ambient-plane sentences merged into one | Introduces an "its"/"its" collision — see §4 |
| 5 | New capstone sentence: weighted 2-section "is therefore a complete invariant of the marked presentation up to isomorphism" | New to the abstract; sourced from the conclusion (1046–1050), not from Theorem 1.1 |
| 6 | "The distance proof reduces weight eight to … and weight ten to …" → "We exclude weight eight by … and weight ten by …" | Verb is correct and stronger — see §3(b) — but the words "distance proof" are lost |
| 7 | "making it twelve-dimensional" → "making \(K\) twelve-dimensional" | Strict improvement; removes a dangling pronoun |

The working-tree text is a further edit past the recommended version in `paper-iv-q13.md` §5 (2026-08-19): items 3, 5 and 7 match that recommendation; items 4 and 6 do not (the memo used the unambiguous relative "whose Sylow-\(13\) subgroups…" and deliberately kept "The distance proof reduces…").

## 2. Claim-by-claim check against the body

| Abstract claim (line) | Verdict | Body evidence |
|---|---|---|
| \(K\) = binary nullspace of the passant-by-internal incidence matrix of a nonsingular conic in \(\PG(2,13)\) (41–43) | correct | 86–92 (definition of passant, polarity identification of the 78 internal points with the 78 passant lines, \(K=\ker_{\F_2}M\subseteq\F_2^{78}\)); coordinate set fixed as the internal points at 94 |
| parameters \([78,36,12]_2\) (43) | correct as stated, but see note below | Theorem 1.1 at 106; \(\dim K=36\) from the Madison–Wu formula with independent elimination check of rank 42 at 227–229; \(d=12\) proved at 223–443 |
| exactly \(364\) minimum words (43) | correct | 106–107; fixed-point exhaustion gives 56 words at a point, transported by \(56\cdot78/12=364\) at 470–480 |
| four \(\PGL(2,13)\)-orbits (44) | correct | 107–108 ("four orbits of size \(91\)"); \(4\times91=364\) |
| one octahedral family (44) | correct | 108–109 (octahedral homogeneous space, stabilizer \(S_4\)); construction 531–539 |
| three chord-indexed punctured-conic families (44–45) | correct | 109–110 ("chord-indexed punctured conics with stabilizer \(D_{24}\)"); \(S_r(e)\) is the punctured pencil conic \(\{y^2=rxz\}(\F_{13})\setminus e\) at 501–530 |
| "each spanning \(K\)" (45) | correct | Theorem 110 "Every orbit spans \(K\)"; proved by orbit-Gram scalars at 769–791; unmarked-irreducibility remark at 209 |
| weighted pair concurrences recover the \(78\) passant incidence rows (47–48) | correct | Theorem 113–114; \(Q\in P^\perp\iff\beta=0\iff\rho=0\iff c(P,Q)=8\) at 618–628 |
| …and the six-class elliptic association scheme (48) | correct | \(\rho\) takes six values on distinct points (561–563); \(A_1/A_3\) fusion split by the *pair-derived* common-neighbor count \(d_7\) (587–598); Theorem 114–115. The extra ingredient is a function of the 2-section, not new input — the body itself calls it "pair-derived" (597) |
| pair parity **alone** recovers \(K\) (48–49) | correct | Theorem 115–118; \(R_{\mathcal H}=A_{10}+A_{12}\), rank 36, \(A_0R_{\mathcal H}=0\), so \(\operatorname{im}R_{\mathcal H}=K\) (630–638); "recovers the code without first naming a row" (630) |
| recovered scheme has automorphism group \(\PGL(2,13)\) (49–50) | correct | 827–828; four-anchor rigidity 793–828; \(\Aut(K)=\Aut(\mathcal H)\) at 830–833 |
| Sylow-13 subgroups and involutions reconstruct all \(183\) points and lines, the conic, and the polarity (50–52) | correct | Theorem 120–123; \(|\Omega|=14\) from normalizer order 156 (847); \(|\mathcal I|=169\) (856, 886–893), \(14+169=183\); intrinsic incidence rules 856–865; adjoint trace model 867–884 |
| "without coordinates or a projective frame" (52) | correct and required | 131–135 (no ordered frame, field labeling, or conic equation; the 2184 ordered conic triples are a \(\PGL(2,13)\)-torsor); 646–648; 867–871 |
| weighted 2-section is a complete invariant of the marked presentation **up to isomorphism** (52–55) | supported, but sourced from the conclusion only | Conclusion 1046–1050 states it in these words; Theorem 1.1 states the operational form "the weighted \(2\)-section of \(\mathcal H\) reconstructs the incidence matrix, code, and elliptic scheme" (118–119). "Marked presentation" itself is used at 643 and defined obliquely at 646–648 as "the marked code–hypergraph presentation" |
| unary statistics are constant (54–55) | correct | every coordinate lies in \(364\cdot12/78=56\) minimum supports (638–640); 84 |
| reconstruction has exact arity two (55) | correct | 640–645, including the equivariance argument that constant unary data has automorphism group \(S_{78}\) while the marked presentation has \(\PGL(2,13)\); Theorem 124 |
| binary relation algebra acts on \(K\) through \(\F_8\), \(K\) twelve-dimensional over it (56–57) | correct | Proposition 4.1 at 718–727; \(B^3+B^2+I=0\) and \(36/3=12\) at 729–742; the body's own guard rail "not a relabeling as a length-26 code over \(\F_8\)" (742) is not violated by "acts on \(K\) through \(\F_8\)" |
| weight eight excluded by a positive-semidefinite clique obstruction (59) | correct | 237–358: saturated pencils force an 8-arc and a seven-clique; rank-28 PSD form gives \(0\le v^{\mathsf T}Cv=10c(5-c)\), so \(c\le5\) (344–350); "the seven-clique required by a weight-eight word cannot occur" (357–358) |
| weight ten excluded by two line-moment profiles + bounded stabilizer exhaustion (59–61) | correct | moment identity (380–382) leaves exactly two shapes (384–394); \(m=6\) closed by four \(D_{14}\) orbits (396–413), \(m=10\) closed by thirty-three \(D_{28}\) orbits (415–431) |
| "intentionally specific to \(q=13\)" (61–62) | correct and required | 80–84, 219–221, 1041–1044; general bounds \(8\le d\le12\) at 196–200 |

**Note on \([78,36,12]_2\).** The abstract says "We prove", which is accurate — the paper proves \(d=12\) and independently checks rank 42 — but the introduction credits Droms–Mellinger–Meyer's Table 8 with *reporting* the same \(q=13\) parameters (196–198) and Madison–Wu with the nullity formula (201–203). A referee reading only the abstract could take the whole triple as new. This wording is unchanged from the previous abstract, so it is not a regression; if the author wants the priority signalled in the abstract, the fix is one clause ("we prove the reported parameters…").

## 3. The two flagged risks

**(a) Dropping "the code" from the concurrence list — faithful.** The previous abstract said concurrences recover "the \(78\) passant incidence rows, the code, and the six-class elliptic association scheme", and then separately said "Pair parity recovers \(K\)". The new text keeps only the second route to the code. This loses nothing, because parity is strictly less information than the weights: \(R_{\mathcal H}\) is defined as \(c(P,Q)\bmod2\) (631–632) and the body proves \(\operatorname{im}R_{\mathcal H}=K\) (636–638), so recovery from parity implies recovery from the weighted 2-section. The theorem's own summary line still lists all three ("reconstructs the incidence matrix, code, and elliptic scheme", 118–119), so the abstract is a weaker-input, same-output rendering of it. The word "alone" is earned and should stay.

**(b) "Exclude" versus "reduces to" — "exclude" is the right verb.** Both arguments terminate in an impossibility, with no residual step:

- weight eight: "In particular the seven-clique required by a weight-eight word cannot occur" (357–358). The clique bound \(c\le5\) is a closed inequality from a certified rank-28 PSD matrix (324–342), not a reduction to further casework. The sharpening that classifies the extremal five-cliques is explicitly marked as *not* used for the exclusion (350–352).
- weight ten: "Thus the \(m=6\) shape is impossible" (413) and "Thus \(m=10\) is impossible as well" (431).

Together with even weight (231–232) and the weight-\(\ge8\) pencil bound (232–235), these give \(d(K)=12\) at 443. So "exclude" is stronger than "reduces" and still true.

The cost of the rewrite is elsewhere: the new sentence never says what the exclusions are *for*. "The distance proof" was the only occurrence of the word "distance" in the abstract, and its removal leaves the third paragraph as two unattached exclusions whose purpose the reader must infer from \([78,36,12]_2\) two paragraphs earlier. Recommended repair keeps the new verb and restores the label: *"The distance proof excludes weight eight by a positive-semidefinite clique obstruction and weight ten by two line-moment profiles followed by bounded stabilizer exhaustion."* One word longer.

A secondary point a referee may raise: the weight-eight exclusion depends on a cited classical input, Segre's lemma of tangents in the Ball–Lavrauw form (271–274, and named as a retained classical input at 1031–1032). "We exclude weight eight by a positive-semidefinite clique obstruction" attributes the whole step to the authors. This is inherited from the previous abstract and is normal abstract compression; no change needed.

## 4. Scope qualifiers and prose

Nothing that the previous abstract carried as a *scope* qualifier was dropped: "up to isomorphism", "without coordinates or a projective frame", and the whole fixed-\(q=13\) closing sentence all survive. Three prose defects, all repairable in a few words:

1. **"while its unary statistics are constant" (54–55) — wrong nearest antecedent, and a lost scoping.** The intended referent is the minimum-support hypergraph (or the minimum layer), but the nearest candidate nouns are "the marked presentation" and "isomorphism". The previous abstract said "unary **minimum-support** statistics are constant", which both fixed the referent and scoped the claim; the new text drops that scoping. The proved statement is narrow — each coordinate lies in exactly 56 minimum supports (638–640) — and "its unary statistics" as written can be read as a claim about unary statistics in general. Suggested: "…while the unary statistics of that hypergraph are constant" or restore "unary minimum-support statistics".
2. **Two different antecedents for "its" in one sentence (49–52).** "The recovered scheme has automorphism group \(\PGL(2,13)\), and from **its** Sylow-\(13\) subgroups and involutions we reconstruct … the distinguished conic, and **its** polarity." The first "its" must be the group (a scheme has no Sylow subgroups) and the second is \(\PG(2,13)\). It resolves, but only after the reader supplies mathematics. The 2026-08-19 memo's "whose Sylow-\(13\) subgroups and involutions reconstruct…" avoids this at zero cost.
3. **"the marked presentation" (54) arrives cold.** In the body the term is grounded at 646–648 ("the marked code–hypergraph presentation up to isomorphism"). In the abstract nothing has been called "marked", so an abstract-only reader has no referent. Cheapest fix is "the marked code–hypergraph presentation".

Everything else in the block checks out:

- **Grammar and parallelism.** "forming four \(\PGL(2,13)\)-orbits" attaches correctly to "\(364\) minimum words"; "each spanning \(K\)" attaches to the orbits across the em-dash appositive. Three trailing modifiers in one sentence is dense but not incorrect. The three families are parallel ("one octahedral family and three chord-indexed punctured-conic families"). The colon in "constant: reconstruction has exact arity two" is used correctly as an inference marker.
- **Hyphenation.** "passant-by-internal", "chord-indexed", "punctured-conic families", "minimum-support hypergraph", "positive-semidefinite clique obstruction", "line-moment profiles", "twelve-dimensional" are all correct attributive compounds. See §5(2) for a body inconsistency this exposes.
- **TeX delimiters.** Inline math uses `\( \)` throughout, matching the body (the only `$…$` in the file is the pre-existing title, 32–33). Em dashes are `---` (44–45); these are the file's only `---` occurrences, and they were also in the previous abstract. Two spaces after sentence-ending periods, matching house usage.
- **Macros.** Only `\PG` (26), `\PGL` (27), `\F` (25) are used, all defined in this preamble. No macro from a sibling paper leaks in. `\(2\)-section` matches the body (118, 1042, 1048) and the keywords (66).
- **Terminology drift, both inherited, both harmless.** "six-class" (48) versus the body's "six-relation" (597) and "six level relations" (660) — "class" is standard association-scheme usage. "binary relation algebra" (56) versus the body's "binary Bose–Mesner algebra" (720, 740) — "relation algebra" is also a term of art for a different object (Tarski), so a purist referee could prefer "Bose–Mesner"; the reading map already says "Relation operators" (174).

## 5. Separate manuscript issues spotted (not fixed)

1. **The "only … are used" claim at 663 is contradicted at 814.** Line 663 says "Only the following integral intersection rows are used", and the table at 665–674 lists \(A_0^2, A_0A_9, A_0A_{10}, A_0A_{12}, A_9^2, A_{10}^2, A_{12}^2\). The four-anchor count at 812–814 then uses \(p^{10}_{3,9}=2\), which is the \(A_{10}\)-coefficient of \(A_3A_9\) and is not among the displayed rows. Either add that row or soften "only" to name the later use.
2. **Hyphenation inconsistency for the same attributive phrase.** "positive semidefinite form" (146, reading-map box) versus "positive-semidefinite form" (241) versus predicative "The matrix is positive semidefinite" (324, correct unhyphenated). The new abstract's hyphenated form (59) is right; 146 is the outlier.
3. **Digits versus math mode for the same counts.** Bare "364" (158), "78" (536, 538, 806, 824), "91-by-78" (769) against `\(78\)` (88, 886), `\(364\)` (106, 966, 1028), `\(183\)` (122). Likewise "Sylow-13" plain (181) against "Sylow-\(13\)" (121, 847).
4. **Undefined parenthetical at 536–538.** "matching profile \((2,3)\) inside those orbits selects a unique 12-point suborbit \(X_O\) (and two crossing pairs)" — "crossing pairs" appears nowhere else and is not defined; a referee will ask what is being excluded.
5. **"These six level relations" (660).** "Level relation" is not defined anywhere in the paper; the surrounding text says "elliptic relations". Probable leftover from an earlier draft.
6. **Compressed case elimination at 384.** "The degree condition and \eqref{eq:weight-ten-moment} leave exactly" the two tabulated shapes. The elimination of \(m\in\{0,\dots,5,7,8,9\}\) is correct — \(4n_4=10-m\) forces \(m\equiv2\pmod4\), \(m=2\) is killed by "two degree-two vertices cannot by themselves form a cycle" (392), and \(m\le10\) since \(n_4\ge0\) — but that reasoning is left implicit. One added clause would close it for a referee.
7. **Bibliography key versus year.** `Tranchida2024` (1160) carries the published year 2025 (1164–1166). Cosmetic; the in-text citation shows no year.

## 6. Independent spot checks performed

Numeric consistency of the claims the abstract compresses, all confirmed against the body: \(4\times91=364\) and \(56\cdot78/12=364\) (478–479); \(2184/24=91=\binom{14}{2}\) (542); pair census \(273+1092+546+546+546=3003=\binom{78}{2}\) (583–584); \(14+169=183\) (847, 856, 893); \(\deg\chi_C=14+2+2+12+12=42\) with nullity 14 hence rank 28 (327–340); \(40c-20\binom c2=10c(5-c)\) (346–348); \(\sum_i i(i-2)n_i/2=10-m\) from \(\sum i n_i=70\) and \(\sum\binom i2 n_i=45-m\) (369–382); \(1+t+t^2+t^4=(t+1)(t^3+t^2+1)\) over \(\F_2\) (734); \(\Delta=1-r^{-1}\) nonsquare and \(\chi(r)=-1,\chi(r-1)=1\) for \(r\in\{2,5,11\}\) (511–518); discriminant identity \(B^2-4AC=B^2(1-r)\) with \(1-r\) square in all three cases (520–524); parity reduction \(R_{\mathcal H}=A_{10}+A_{12}\) from the concurrence row \(8,6,6,12,7,9\) (572–577, 634); orbit Gram reductions \((A_9,A_9,A_{12},A_{10})\) from the four counts at 774–787. No arithmetic discrepancy found.
