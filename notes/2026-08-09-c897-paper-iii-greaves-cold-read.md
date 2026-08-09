# C897 Paper III sealed cold read — Gary Greaves persona

Date: 2026-08-09
Persona: Gary Greaves / conference-design referee (kept separate from Suda)
Frozen manuscript: `clebsch-passages` commit `7208275e6b5f979fea487d2130943bbd979aed37`
Frozen PDF: `clebsch_passages.pdf`, SHA-256 `6794202d653d6908b495120c47848162a15d357c1438611e9e42f10384472622`

## Sources and seal

Before the manuscript I read only dossier Extracts G1, E1, T1, Packet G, and the neutral protocol. I then read the assigned portions of:

- Greaves--Suda, arXiv:2402.17528, SHA-256 `230c4cb862cd51f0d51f20af91c56f2e7453f2e2472114bda6c42b3a5af99e32`;
- Haemers--Parsaei Majd, DOI 10.1007/s10623-021-00858-8, SHA-256 `86a4d6e41f62ef224f5a410653120794bf756ad9a9e2dc2aaa4bdc2f4f4c799e`;
- Gillespie, arXiv:1809.05739, SHA-256 `3d8e2103efefaf7c24a75129584acb9c968248b53e307989f62c7cf4e6c1fa75`;
- Jolliffe, arXiv:2009.05202, SHA-256 `704ce59ca9808d05bd1405f71f651d05ae3b8b6692f3920d1336519190c05578`.

I read all 30 pages of the PDF before inspecting any supplement. The next section is the frozen PDF-only assessment; later evidence must not rewrite it.

## Frozen PDF-only proof assessment

### Assessment and earliest unsupported implication

Within the assigned conference/operator domain, the paper has a coherent and mostly self-contained theorem package: the balanced exchange spectrum is the squared cut-block singular spectrum; cut-independence characterizes the realized order-six case; the determinant-`(-3)` fibre is the aligned-four-set 3-design; and, from seven vertices on, the aligned-four-set indicator reconstructs a two-graph up to complement, hence a Seidel signing up to switching and global negation. The inclusion-rank and Ramsey steps are correctly scoped.

The earliest implication I cannot justify is the claim immediately after Table (5.1) that applying

`epsilon_{pT0}(S) = sgn(p) epsilon_{T0}(p^{-1}S)`

to the displayed conference matrix gives all six printed rows. It does not give printed row `r=2`, `p=012435`. In the stated triangle order, the printed row is

`+-+-+---++--++-+-+-+`,

whereas direct transport gives

`+-+-+---++--+++-+-+-`.

The six wrong positions are `135, 145, 234, 235, 245, 345`; every displayed sign there must be reversed. This is not merely a convention choice: the printed row violates the four-point two-graph identity on eight four-sets, and the six printed rows have nonzero coefficient sum in precisely those six positions. Thus the printed coordinates do not satisfy the claimed relation `sum_T Z_T = 0`. Replacing those six signs repairs both checks. This is the earliest explicit failure in the assigned section and the only one I found that affects a theorem as printed.

PDF-only provisional verdict: **MINOR**. The error is real and load-bearing for the printed proof of the Joubert/Segre identification, but it appears locally repairable by correcting six signs in one row and rechecking the downstream classical coordinate convention.

### Independent conference-design recomputation

For a symmetric conference matrix of order `2d=4m+2`, one has `m=(d-1)/2`. On a four-set `K`,

`det C[K] = 3 - 2w(K)`, with `w(K)` equal to `3` or `-1`.

Therefore the aligned fibre `w(K)=3` is exactly the determinant-`(-3)` fibre. Greaves--Suda Example 2.3 gives

`3-(2d,4,(d-3)/2)`

for this fibre, while the determinant-`5` fibre has parameter `3(d-1)/2`. These sum to `2d-3`, as they must for the two fibres through a fixed triple. For the aligned design,

- `lambda_3=(d-3)/2`;
- `lambda_2=(d-3)(d-1)/2`;
- `lambda_1=(d-3)(d-1)(2d-1)/6`;
- `b=d(d-1)(2d-1)(d-3)/12`;
- block density `rho=b/binom(2d,4)=(d-3)/(2(2d-3))`.

The sign and fibre used in the manuscript agree with Greaves--Suda; there is no reversal of the two designs.

### Independent exchange-moment recomputation

With `q=2d-1`, cut block `A`, and aligned count `c_Y`, the spectrum formula gives

`tr(H_Y)=d-tr(A^2)/q=d^2/q`,

since `tr(A^2)=d(d-1)`. Also

`tr(H_Y^2)=d-2 tr(A^2)/q+tr(A^4)/q^2`.

Sorting closed four-walks gives

`tr(A^4)=d(d-1)+12 binom(d,3)-8 binom(d,4)+32c_Y`,

because `sum_K w(K)=4c_Y-binom(d,4)`. Hence

`tr(H_Y^2)=(F_d+32c_Y)/q^2`

with exactly the manuscript's `F_d`. Thus cut-independence of the second exchange moment is equivalent to constancy of `c_Y`.

For a uniform balanced half,

`E c_Y = rho binom(d,4)`.

The 3-design condition places the centered block indicator in the top Johnson constituent. The inclusion operator from four-sets to `d`-sets has squared factor `binom(2d-8,d-4)` there, yielding

`Var(c_Y) = [binom(2d,4) binom(2d-8,d-4)/binom(2d,d)] rho(1-rho)`,

which matches the PDF. At order ten (`d=5`), `rho=1/7`, so `E c_Y=5/7` and `Var(c_Y)=10/49`. Equivalently, the aligned design is a `3-(10,4,1)` design, so two distinct blocks cannot lie in one five-set; hence `c_Y` is always `0` or `1`. The 252 labelled halves split as 72/180, and modulo complementation the 126 cuts split as 36/90, exactly as stated.

### Separate audit of the six-row outer table

I recomputed all 120 entries directly from the displayed `6 x 6` matrix, the twenty triples in the stated order, and the displayed permutation rule. Rows `0,1,3,4,5` agree entry-for-entry. Row `2` has the six discrepancies listed above. Independently:

- the corrected row obeys the two-graph four-point identity; the printed row fails it;
- the corrected six-row coefficient sum is zero in all twenty positions; the printed table has residual coefficients `-2,+2,-2,+2,-2,+2` in positions `135,145,234,235,245,345`;
- this audit uses neither the design theorem nor any supplement.

### PDF-only classification of findings

1. **False statement:** Table (5.1), row `r=2`, has six wrong signs, so the six displayed cubics do not satisfy the stated linear Segre relation. Local correction appears sufficient.
2. **Proof gap:** Theorem 5.5(3), as printed, invokes the erroneous table to identify the six operator cubics with the signed Joubert coordinates. It must be rerun after correcting the row; the abstract operator identities themselves are unaffected.
3. **Citation overreach:** none found in the assigned packet. Greaves--Suda is used only in the forward direction and with the correct determinant fibre; Haemers--Parsaei Majd is not asked to prove the new cut-rigidity classification; Jolliffe's characteristic-zero rank theorem applies because `4 <= d`.
4. **Normalization ambiguity:** the cross-golden formula retains a displayed `+/-` after determinant-line orientation is invoked. This is not a mathematical contradiction, but the text should state the actual transported sign if Table (5.1) is advertised as fixing every sign.
5. **Exposition friction:** the section should say explicitly that realized symmetric conference order `2d` forces `d` odd. The proof correctly distinguishes the formal `d=2` calculation from the realized uniqueness claim, but the convention is easy to miss.

## Permitted supplement audit

The supplement was opened only after the preceding PDF-only assessment had been written. I did not use it as a premise in any human-proof judgment.

Files inspected and their exact effect:

- `README.md`: confirmed the advertised operator, exchange, and reconstruction claims; changed no finding.
- `ARTIFACT.md`: confirmed that the paper presents the operator/formal material as partial mechanism coverage and reserves human proof boundaries; changed no mathematical finding.
- `literature-boundaries.md`: confirmed the forward-only Greaves--Suda attribution, the separate paper-owned inverse theorem, and the bounded/non-priority wording for `OPER-3` and `OPER-4`; it confirmed that there is no citation overreach in my packet.
- `clebsch_passages.tex`: confirmed that the abstract promotes the six signed outer translates and the reconstruction theorem, so the table defect touches an advertised claim; it did not alter severity.
- `sections/05-golden-operator.tex`: confirmed that the source contains exactly the erroneous row printed in the PDF. This confirms finding 1 rather than changing it.
- `sections/08-verification.tex`: confirmed that the manuscript appendix still describes outer-family coherence and the classical Joubert--Segre--Igusa identifications as human boundaries. It does not disclose or catch the table mismatch.
- `verification/README.md`: says the golden-return map checks the six signed translates, their two Segre equations, and their two-graph words. This localizes the likely defect to manuscript transcription, but is not used to prove the theorem.
- `verification/golden_return_formal.json`: records coefficientwise outer words, four-point identities, distinctness, and both Segre relations. It confirms that a corrected intended frame exists in the verification surface; it does not identify the printed bad row or compare the two surfaces.
- `verification/passages_formal.json`: confirms that the aligned-design faithfulness and Seidel-signing consequences have much stronger formal mechanism coverage than my PDF-only proof needed. It changed no finding.
- `verification/trust_manifest.json`: marks `OPER-2` as coefficientwise formal coverage of explicit words and `OPER-4` as covering the reconstruction mechanism. This again reduces the likely repair size but supplies no human-proof premise.
- `verification/statement_identity.json`: freezes Theorem 5.5 and the hash of `sections/05-golden-operator.tex`, but Table (5.1) is not a separately compared statement. It explains no mathematics and changes no finding.
- `verification/verify_release.py`: checks statement/trust identity, hashes, formal source closures when available, and a clean manuscript build, but has no comparison from the formal outer words back to Table (5.1). This confirms a verification-surface blind spot: a malformed displayed word can pass while the intended formal word is correct.

The supplement also reveals an exposition/trust-map mismatch: `sections/08-verification.tex` says outer-family coherence remains a human boundary, while `verification/README.md`, `verification/golden_return_formal.json`, and `verification/trust_manifest.json` say that the outer matching frame and coefficientwise words are formalized. This does not weaken the human proof, but the public surfaces should agree.

## Neutral protocol answers

### 1. Strongest theorem package

The strongest coherent package is the marked conference-operator passage: a chosen golden sheet, after the explicitly separate marking, supplies an oriented order-six conference source; its cut blocks give the exchange spectrum, its aligned fourth-order minors both form the classical conference 3-design and reconstruct the entire two-graph from seven vertices onward, and its six outer translates realize the Joubert--Segre--Igusa--Clebsch cubic package. The sharp aligned-design faithfulness theorem is the strongest packet-independent discrete result.

### 2. Causal proof reconstruction without supplement

Hitchin's degree and irreducible sextic branch divisor reduce the rational incidence field to `Q(P(H))(sqrt(cJ0))`; the complete etale fibre over `xyz`, where `J0` has square value and the residue algebra is `Q(sqrt(5))`, fixes `c=[5]`. Pullback to the Clebsch chart factors as two normalized components, and a marked bridge datum attaches their odd sign to `C` and `-C`.

For a balanced cut of any symmetric conference matrix, the commutator with the cut involution identifies the exchange compression with the squared singular values of the cross block. The block equation `RR^T=qI-A^2` gives the spectrum. The second trace is the support-sorted fourth closed-walk sum and is affine in the aligned count `c_Y`. If that count were constant for `d>=4`, Jolliffe's full-column-rank inclusion matrix would force every four-set to have one common type; a rooted switching gauge and `R(3,3)=6` exclude both possible types. The small cases give the order-six spectrum directly.

Independently, `det C[K]=3-2w(K)` identifies aligned four-sets with the Greaves--Suda determinant-`(-3)` 3-design. Rooting a two-graph turns alignment through the root into homogeneous triples of a graph. On seven vertices an aligned anchor, four one-point signatures, six pair signatures, and the third outside point recover all rooted triangle values up to a single complement bit. Overlapping seven-sets propagate that bit, and switching then recovers a Seidel signing up to global negation.

At order six, complementary minors give the middle-exterior diagonal and commutator Pfaffian; the conference identity identifies that diagonal with triangle holonomy, while golden eigenspaces rewrite the same square as a cross-block determinant. The correctly transported outer family then invokes the classical Joubert/Segre/Igusa identities. Finally the marked pair-sum map lands in the Petersen `(-2)`-eigenspace, and one invariant-line spherical moment fixes the degree-six cubic scalar.

### 3. Earliest unsupported implication

Table (5.1)'s assertion that its six rows are obtained from the displayed transport rule fails first at row `r=2`; the exact correction and failed invariants are recorded in the frozen assessment.

### 4. Boundary checks at that implication

There is no field, base-change, normality, or exceptional-order issue at the failure: all coefficients are integral signs at realized order six. Labels and the twenty-triple order are explicit. The permutation `012435` is odd, so the displayed `sgn(p)` factor is fixed. Switching cannot repair the row because it fixes every triangle product; global negation would reverse all twenty coefficients, not only six; relabelling is already prescribed by `p^{-1}`. The failure is therefore a transcription/error in the claimed labelled representative, not an equivalence-convention ambiguity.

### 5. Ranked findings by type

1. **False statement:** Table (5.1), row `r=2`, has six incorrect signs and fails both the two-graph parity test and the linear Segre relation.
2. **Proof gap:** The proof of Theorem 5.5(3) points to that table to fix the coefficientwise Joubert identification. The row must be corrected and the classical convention rechecked before the printed proof establishes the advertised six-coordinate statement.
3. **Normalization ambiguity:** `Z_T=+/-10 sqrt(5) det B_T` remains unsigned even after the text says the determinant lines have been oriented. Either specify the transported orientation and one sign, or state that the theorem is only an equality up to the remaining orientation choice.
4. **Exposition friction:** the manuscript appendix and public verification map disagree about formal coverage of the outer frame, and the release gate does not compare its verified sign words with the displayed table. A single generated-table or invariant check would close both problems.

**Citation overreach:** none found in the assigned domain.

### 6. Verdict

**MINOR**

The central conference-design, exchange, and reconstruction results survive the cold audit. The one false displayed row is theorem-adjacent and must be repaired before release, but the correction is local and the permitted verification surface strongly suggests that the intended six-word frame is already correct elsewhere.

### 7. Contribution relative to the packet

Relative to the packet's forward conference-design theorem, the paper's contribution is that the same aligned four-set observable simultaneously controls balanced cut moments and, despite that low-moment appearance, is a faithful inverse code for every two-graph from seven vertices onward, with the order-six source feeding the classical cubic shadows.

### 8. *Advances in Mathematics* bar

Assuming every proof and the table are repaired, the mathematical significance meets the bar: the arithmetic orientation, conference-operator synthesis, sharp inverse two-graph theorem, and harmonic return form a distinctive package. Cross-field readability is borderline rather than fully at the bar. A conference-design reader can follow Section 5, but an adjacent reader must carry too many marking actions and trust-boundary qualifications while also crossing arithmetic geometry, invariant theory, and harmonic analysis. A shorter operator roadmap, the explicit realized-order convention, and synchronized verification prose would likely clear that remaining bar.

## `ej` + `tt` closeout and mystery ledger

The cheap high-value closeout was to test the table against invariants before comparing it with the supplement. That settled that row 2 is not an alternative signing convention: it violates the defining four-point identity and `sum_T Z_T=0`. The natural robustness upgrade is to generate Table (5.1) from the same six relabellings used by the public formal surface, or at minimum make the release gate compare all 120 signs and the two elementary invariants.

- **Settled:** determinant sign and design parameter. Aligned means determinant `-3`, with `lambda_3=(d-3)/2`; no fibre reversal remains.
- **Settled:** second exchange moment. Both the closed-walk formula and the Johnson inclusion variance reproduce the displayed values, including the order-ten 36/90 split.
- **Settled:** whether the bad row is harmless convention. It is not; exact six-entry correction is known.
- **Open, exact evidence gap:** the human manuscript still needs the corrected row checked against the cited Joubert convention. Owner: manuscript revision; gate: coefficientwise table/formal comparison plus the two Segre identities.
- **Open, normalization gate:** the actual sign of the cross-golden determinant after the advertised transported determinant-line orientation is not written. Owner: the orientation convention in Theorem 5.5.
- **Open, documentation gate:** reconcile `sections/08-verification.tex` with the later public formal maps. Owner: artifact/trust prose synchronization.

No further conference-design mystery remains inside this sealed packet.
