# C897 Paper III cold read — Andrew Snowden persona

Date: 2026-08-09
Frozen manuscript: `clebsch-passages` commit `7208275e6b5f979fea487d2130943bbd979aed37`
Rendered PDF: `clebsch_passages.pdf`, SHA-256 `6794202d653d6908b495120c47848162a15d357c1438611e9e42f10384472622`
Packet source: Howard--Millson--Snowden--Vakil, *A description of the outer automorphism of S6, and the invariants of six points in projective space*, cached DOI key `10.1016/j.jcta.2008.01.004`, SHA-256 `a875f0bccccc42db97703e9cadf52648a3f4e41b429abd0b05ef84bf6725043c`, §§1.1--1.6 and 2.1--2.2. The companion HMSV item, *The equations for the moduli space of n points on the line*, was retained at the dossier's metadata/preview depth and was not fetched or used as a proof premise.

## Evidence boundary

This is a sealed cold read. Before freezing the assessment below I read the rendered PDF and the assigned HMSV source, but no supplement, manuscript source, verification file, prior review, lane material, or other persona report. I independently recomputed the six rows of Table (5.1), the odd-relabelling action, centered squaring, and the diagonal Clebsch section. The supplement was inspected only after the PDF-only assessment had been written to disk; its effect is recorded separately below. It is never a premise of the human-proof assessment.

## Frozen PDF-only proof assessment

### Bottom line

The outer-invariant-theory passage is mathematically coherent and its exact sign and coefficient conventions survive independent calculation. In particular, the paper does more than identify a projective Segre model: after the marked orientation is fixed, its six displayed cubics are exactly the signed HMSV coordinate polynomials. The sole substantive defect I find in this passage is a short but load-bearing proof compression in the complementary-minor calculation. It is locally repairable.

### Earliest unsupported implication

The earliest implication in the assigned proof spine that I cannot reconstruct from the printed argument alone occurs in the proof of Theorem 5.5(1):

> “Two dihedral representatives and complementation give \((K_T)_{SS}=4(C_T)_{ij}(C_T)_{jk}(C_T)_{ki}\).”

The text does not say which dihedral action is being used on triples, why it has the claimed representatives, how complementation interacts with the chosen middle-degree Hodge sign, or show either representative calculation. This identity is the nonformal bridge from complementary minors to triangle holonomy; the paper itself has just emphasized that this is the one of the four shadow equalities that can fail for a general symmetric matrix. My direct computation from the displayed conference matrix confirms the identity for all twenty triples, with the important convention

\[
(\ast\!\bigwedge^3 C)_{S,S}=\operatorname{sgn}(S^c,S)\det C[S^c,S]
=4\prod_{\{i,j,k\}=S}C_{ij}C_{jk}C_{ki}.
\]

Thus this is a proof gap in presentation, not a false statement. Two explicit representative calculations plus the orbit/complement argument, or a short uniform determinant calculation from the pentagon gauge, would close it.

At this implication the relevant checks are clean: the field is characteristic zero; no base change or normality claim enters; labels are the ordered set \(X=\{0,\ldots,5\}\); diagonal switching fixes triangle products; odd relabelling changes the oriented coordinate by the sign character; and equality is meant in the polynomial ring, not merely after projectivization. There is no exceptional-order issue because the assertion is confined to the order-six conference class.

### Independent recomputations

1. **Table (5.1).** From the displayed matrix \(C\), I computed the twenty products \(C_{ij}C_{jk}C_{ki}\) in the stated lexicographic triangle order. Transport by the six displayed permutations using
   \[
   \epsilon_{pT_0}(S)=\operatorname{sgn}(p)\epsilon_{T_0}(p^{-1}S)
   \]
   gives, exactly,

   ```text
   012345  --+++-++--++--+---++
   012354  ++----++-+-+--++++--
   012435  +-+-+---++--+++-+-+-
   012453  -+-+++---+-+++---+-+
   012534  -++--++-+-+-+--++--+
   012543  +--+-+-++-+--+-+-++-
   ```

   These are all six printed rows. Coefficientwise summation gives \(\sum_TJ_T=0\), and direct sparse polynomial expansion gives \(\sum_TJ_T^3=0\) with no surviving coefficient.

2. **Odd relabelling.** The exact affine action is the signed outer action:
   \[
   J_{gT}=\operatorname{sgn}(g)\,(g\cdot J_T)
   \]
   for the corresponding pullback convention on variables. An odd relabelling therefore negates as well as permutes the six coordinates. After projectivization the common sign is invisible, which is why the projective Segre action is the ordinary outer permutation action. These are different assertions; the paper correctly retains the former for its oriented cubic and uses the latter for the projective moduli model.

3. **Centered square.** Put \(p_r=\sum_i z_i^r\), \(a=p_2/6\), and \(w_i=z_i^2-a\). On \(p_1=p_3=0\), Newton's identities give, with elementary symmetric functions \(e_2,e_4,e_6\),
   \[
   \sum_iw_i^2=4(e_2^2/3-e_4),\qquad
   \sum_iw_i^4=4(e_2^2/3-e_4)^2.
   \]
   Hence \(\sum_iw_i=0\) and \((\sum_iw_i^2)^2=4\sum_iw_i^4\) exactly. This verifies the coefficient \(1/6\) and the displayed Igusa normalization, not merely the projective image.

4. **Diagonal Clebsch section.** Setting one Segre coordinate, say \(z_0\), equal to zero leaves
   \[
   \sum_{i=1}^5z_i=0,\qquad \sum_{i=1}^5z_i^3=0
   \]
   in \(\mathbf P^4\), which is the diagonal Clebsch cubic surface in its standard five-coordinate model. Eliminating \(z_5=-\sum_{i=1}^4z_i\) gives the exact cubic polynomial
   \[
   \sum_{i=1}^4z_i^3-\left(\sum_{i=1}^4z_i\right)^3=0.
   \]
   Calling another scalar multiple or linearly changed equation “the Clebsch cubic” is projective equivalence; the coordinate section asserted here is stronger and holds as the exact displayed equations.

### Neutral protocol

1. **Strongest theorem package believed.** The paper proves a marked source--shadow--return package: the rational incidence double cover has function field \(\mathbf Q(\mathbf P(H))(\sqrt{5J_0})\); a marked sheet determines an oriented order-six conference source; its six signed outer translates have four exact operator descriptions and give the Joubert--Segre--Igusa--Clebsch models; and the marked Petersen four-space returns the same invariant cubic \(\sigma_3\) with an exact degree-six spherical normalization. It also proves independent exchange-rigidity and two-graph reconstruction theorems.

2. **Causal proof without supplement.** Hitchin's generic degree and branch sextic reduce the incidence field to a constant twist of \(J_0\); the complete fibre at \([xyz]\) evaluates the constant as \([5]\). Pullback to the Clebsch chart splits after normalization, and a complete marking transports the chosen odd generator to the conference sign. The conference equation \(C^2=5I\) links triangle holonomy to complementary minors, the commutator Pfaffian, and the golden eigenspace determinant. The six coherently signed outer translates are then the explicit HMSV coordinates, so their Segre relations, centered-square polar map, and coordinate Clebsch section follow. Separately, the Petersen pair-sum map identifies the four-dimensional coefficient module and one fixed-line moment determines the spherical cubic scalar.

3. **Earliest unjustified implication.** The unexpanded “two dihedral representatives and complementation” step in Theorem 5.5(1), described above.

4. **Boundary checks there.** Characteristic zero; no base-change or normality dependence; ordered labels and Hodge orientation are essential; switching is quotiented but global negation is not; odd relabelling carries the sign character; the identity is exact polynomial equality; order six is an explicit hypothesis of this step.

5. **Defect separation.** No false statement found. One local proof gap is ranked below. No citation overreach found in the assigned HMSV comparison: HMSV states both the signed outer representation and the Segre/Igusa formulas, while this paper supplies the exact table needed to fix its convention. No surviving normalization ambiguity remains after the marked datum is fixed. One exposition friction is ranked below.

6. **Categorical verdict.** **MINOR**.

7. **Contribution relative to the packet.** Relative to HMSV, the paper realizes the signed outer six-coordinate system as four normalized shadows of one marked order-six conference operator and connects that oriented source, rather than merely its projectivization, to golden descent and a Petersen harmonic return.

8. **Advances bar assuming repair.** Yes on significance: the common conference mechanism and its arithmetic and harmonic endpoints form a substantial coherent package. Cross-field readability is nearly at the bar, but the one nonformal operator identity should be expanded and the exact-versus-projective action convention should be stated once in a compact formula before the theorem proof.

### Ranked findings

1. **Proof gap — minor, headline-adjacent.** The complementary-minor/triangle-holonomy identity is load-bearing and nonformal, but the printed “two representatives and complementation” sentence does not expose a checkable reduction. The identity is true in all twenty cases. Add the orbit statement and representative calculations, or a uniform pentagon-gauge proof.

2. **Exposition friction — minor.** The manuscript distributes the exact signed action among the colouring rule, Table (5.1), the Hodge warning, and the theorem proof. A single displayed convention distinguishing \(J_{gT}=\operatorname{sgn}(g)(g\cdot J_T)\) from the induced projective outer permutation action would reduce the main normalization hazard.

No false statement, citation overreach, or unresolved normalization ambiguity was found in the assigned outer-invariant-theory passage.

## Post-freeze supplement audit

The supplement changed no finding and did not change the **MINOR** verdict. Its formal and computational checks corroborate the truth of the identities I recomputed, but they do not supply the missing sentences in the printed human proof.

Files inspected, and their exact effect:

- `README.md`: confirmed the same four-shadow headline and the claimed distinction between the conference-specific triangle bridge and the formal identities. No finding changed.
- `ARTIFACT.md`: confirmed that the public trust boundary treats the operator synthesis as a human argument with partial formal mechanism coverage, and that no complete manuscript claim uses the supplement as a proof premise. No finding changed.
- `literature-boundaries.md`: confirmed the separation of paper-owned operator synthesis (`OPER-1`) from the classical HMSV Joubert--Segre--Igusa input (`OPER-2`). This supports the no-citation-overreach assessment; no finding changed.
- `clebsch_passages.tex`: confirmed the manuscript driver and section ordering. It added no mathematical evidence and changed no finding.
- `sections/05-golden-operator.tex`, especially the theorem and proof at source lines 591--684: confirmed that the source contains exactly the same compressed “two dihedral representatives and complementation” sentence as the rendered PDF, with no hidden expansion or source comment. This confirmed Finding 1 unchanged.
- `release_files.json`: confirmed that the files named below are on the public release surface. It added no proof evidence and changed no finding.
- `verification/README.md`: confirmed that the released golden-return map checks the fixed conference middle-exterior diagonal, commutator Pfaffian, six signed translates, Segre relations, and centered-square relation, while retaining human-proof boundaries. This corroborates that Finding 1 concerns the printed proof rather than the statement's truth; it does not repair that finding.
- `verification/statement_identity.json`: the `thm:operator-shadows` entry confirmed that the exact theorem surface includes the coefficient (4), the determinant factor (16), the cross-golden factor (10\sqrt5), both Segre equations, the exact coordinate section, and the coefficient (1/6) in centered squaring. No normalization finding was added.
- `verification/trust_manifest.json`: rows `OPER-1` and `OPER-2` confirmed the declared human/classical/formal-partial evidence split and the exact claim-to-evidence boundary. This confirmed, without changing, the proof-gap and citation assessments.
- `verification/golden_return_formal.json`: rows `OPER-1` and `OPER-2` confirmed partial formal declarations for the twenty middle-exterior diagonals, fixed-conference Pfaffian identity, all six sign words, both Segre relations, the diagonal section, and the centered-square Igusa relation. Its stated exclusions preserve a human boundary around the determinant-line interpretation. The file confirms the identities but is not a human-proof premise; no finding changed.
- `verification/passages_formal.json`: only its top-level public-map structure was inspected; it supplied no evidence relevant to the assigned outer-invariant-theory finding and changed nothing.

The supplement therefore confirms the frozen distinction: the polynomial identities and normalizations are correct, and the repair needed is expository proof completion at the one conference-specific bridge.
