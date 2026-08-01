# C755 — Golden operator manuscript: literature and novelty audit

**Lane:** `golden`

**Date:** 2026-08-01

**Audited object:** `papers/golden-operator/golden_operator.tex` (the manuscript as frozen on
2026-08-01), together with the frozen C704–C710 / C715–C717 / C727–C729 source reports consulted
where a manuscript claim needed pinning down.

**Deliverable:** a novelty verdict. `notes/literature-audit-conventions.md` binds in full.

---

## Opening summary

Three sources were read at **full text**: Goethals–Seidel (1967), Howard–Millson–Snowden–Vakil
(JCTA 2008), and Howard–Millson–Snowden–Vakil (arXiv:0906.2437). Eight further sources were read
at **partial** depth with the sections recorded, four at **abstract/metadata only**, and six
intended sources could **not be accessed**. Every source named below — including those named only
to be dismissed — carries a read-depth field in § Sources.

The audit found **five clean pre-emptions**, of which two are close to verbatim. Read them before
anything else:

1. **The centered-square formula is Howard–Millson–Snowden–Vakil's, verbatim.** Theorem 2.3(iv)'s
   \(W_T=Z_T^2-\tfrac16\sum_U Z_U^2\) is printed as the Segre-to-Igusa duality map in HMSV (JCTA
   2008) § 2.2, together with the Igusa equation \(\sum w=0,\ (\sum w^2)^2-4\sum w^4=0\) and the
   inverse map. The manuscript derives it via Newton's identities and cites HMSV only for the
   Joubert coordinates.
2. **The six sisters, the five-cycle normal form, and the unordered support split are HMSV's and
   Seidel's.** HMSV § 1.1 gives the six "mystic pentagons" (two-colourings of \(K_5\) whose colour
   classes are 5-cycles) and § 1.6 gives the twelve 5-cycles pairing into six under
   complementation — the manuscript's Theorem 2.6(iv) and its twelve-to-six count. HMSV § 1.2 gives
   the six splits of the twenty triangles into complementary ten-sets under exactly the manuscript's
   two conditions, and identifies the \(S_6\)-action as the outer automorphism — the manuscript's
   Proposition 3.1 and its coherent outer six-family. Bussemaker–Mathon–Seidel, *Tables of
   two-graphs*, Ch. 5–6, states that the order-six conference two-graph is unique, is represented by
   the pentagon-plus-isolated-vertex switching class, and has automorphism group \(A_5\).
3. **The Fano-component realization is largely Gripaios–Nguyen's.** arXiv:2607.09879 § 1 and § 4
   own the 15 planes + 6 split degree-five del Pezzo components, the transitive \(S_6\)-action with
   stabilizer \(S_5\), the syntheme labelling of the plane images, "a generic line meets five
   planes," and the count of exactly six lines through a generic point of the Segre cubic. The
   manuscript cites that paper only for the component classification.
4. **The order-ten shadow is a classical object.** Fickus–Mixon identify symmetric conference
   matrices of order \(N\) with the sign Gram matrices of real \(\mathrm{ETF}(N/2,N)\);
   Bussemaker–Mathon–Seidel state that the order-ten conference two-graph is unique, has eigenvalues
   \(\pm3\), automorphism group \(\mathrm{Sp}(4,2)\cong S_6\), and a switching class containing the
   Petersen graph and \(T(5)\). Corollary 2.7's ETF, its \(S_{10}^2=9I\), and its switching-class
   uniqueness are that statement.
5. **The rational anomaly inverse is prior art** — already conceded in the manuscript's own text,
   and the concession is correct.

What survives is a coherent and defensible core: the **commutator-Pfaffian and middle-exterior
presentations** of the Joubert cubics, the **golden eigenspace compression** and its
determinantal/MCM package, the **Jacobian adjugate identity**, the **balanced-cut
maximum-determinant characterization** of \(C^2=5I\), the **synchronized pure-spinor product**, the
**unmarked-reconstruction boundary**, and the **exact anomaly-cost clauses**. None of these has a
located predecessor — but see § Coverage for how strong that negative is.

**Vibe check:** the operator layer holds; the classical-geometry layer is thinner than the
manuscript's framing suggests. Four theorems need attribution surgery, not retraction. The paper is
better after this, and it would have been worse to meet HMSV § 2.2 in a referee report.

---

## Verdict table

Legend: **PE** pre-empted · **PPE** partially pre-empted · **NPL** no predecessor located ·
**NA** not audited.

| # | Manuscript claim | Verdict | What the prior source owns / what survives |
|---|---|---|---|
| C1 | Lemma 2.2, primitive-kernel cofactor | PPE | Ambient: adjugate columns lie in the kernel of a corank-one matrix; graded-UFD primitivity then forces the rank-one form. Textbook-level; no named predecessor located and none sought beyond a keyword sweep. **Do not claim novelty.** Surviving: nothing worth claiming — present it as a stated convenience lemma. |
| C2 | Thm 2.3(i), six \(c_T\) a regular-simplex frame of \(\mathcal I_3\cong S^{(3,3)}\); \(F_C\) identifies \(\mathcal I_3^*\) with the signed outer augmentation module; commuting square and lift uniqueness | PPE | HMSV JCTA § 2.1: \(H^0(S_3,\mathcal O(1))\) is the signed outer automorphism representation \(O_5'\). HMSV JCTA § 2.4: explicit linear dictionary \(X_{13\cdot26\cdot45}=(Z_a+Z_b)/2\) between Kempe matching brackets and the \(Z\)'s, invertible. HMSV arXiv:0906.2437 § 1: the degree-one part carries the irreducible \(S^{(n/2,n/2)}\). **Surviving:** that the six functionals arise from conference matrices, that they form a *regular simplex*, and the one-dimensional-Hom + primitive-integrality + Pfaffian-orientation uniqueness of the upper arrow. |
| C3a | Thm 2.3(ii), \(F_C\mathcal J_3=4Z\), \(\sum Z_T=\sum Z_T^3=0\), the coloured-triangle cubics | PE | HMSV JCTA § 2.1 gives \(Z_x=\sum\pm p_Ap_Bp_C\) with the sign from the black/white triangle colouring, and \(\sum Z_x=0\); the Segre relation \(\sum Z=\sum Z^3=0\) is Joubert/Coble (Dolgachev, arXiv:1501.06432 § 2, quoting Joubert 1867 and Coble). |
| C3b | Thm 2.3(ii), \(\Pf[D_x,C_T]=4Z_T\), \(\det[D_x,C_T]=16Z_T^2\), and the identification with \((*\bigwedge^3C_T)_{SS}\) | NPL | Searched: arXiv full-text, OpenAlex/Semantic Scholar forward sets of Goethals–Seidel and HMSV, zbMATH, general web. The triangle-holonomy description of a two-graph (\(S_{ij}S_{jk}S_{ki}\)) is standard; presenting the Joubert cubic as the Pfaffian of \([D_x,C]\) and as a middle-exterior diagonal is not located. |
| C4 | Thm 2.3(iii), golden compression \(Z_T=\pm10\sqrt5\det B_T\); compound grades \(1,B_T,\operatorname{adj}B_T,\det B_T\); two small resolutions and rank-one MCM objects | PPE | Ambient, classical: a \(3\times3\) linear determinantal representation yields two small resolutions via left/right kernels and rank-one MCM/matrix-factorization modules — Dolgachev arXiv:1501.06432 § 3 (Thm 3.5, Rem. 3.8, crediting Hassett–Tschinkel, with the Beauville–Donagi Pfaffian analogue). **Surviving:** the specific \(\mathbb Q(\sqrt5)\) eigenspace block \(B_T\), the scalar \(10\sqrt5\), the exterior-exponential grade statement, and golden conjugation as the exchange of the two resolutions. |
| C5a | Thm 2.3(iv) first sentence, \(W_T=Z_T^2-\tfrac16\sum_U Z_U^2\) is the Segre–Igusa polar vector; Igusa quartic equation | **PE (verbatim)** | HMSV JCTA § 2.2 prints exactly this as the duality map \(S_3\dashrightarrow I_4\), the Igusa equations in \(S_6\)-symmetric form, and the inverse map \(I_4\dashrightarrow S_3\); credits van der Geer (1982) for the \(S_6\)-symmetric form and Igusa (1964) for the original. |
| C5b | Thm 2.3(iv), \(\operatorname{adj}\mathsf A=6\widehat Wq^{\mathsf T}\) with the two kernel lines and the constant | NPL | The two kernel directions individually are forced (congruence/Euler and the Segre differential); the assembled adjugate identity and its normalization are not located. |
| C6a | Thm 2.4, GIT stability \(h<m\) / \(h=m\) / \(h>m\) for equal-weight points on \(\mathbf P^1\) | PE | Classical GIT for points on the line; standard in every treatment of \((\mathbf P^1)^n/\!/\mathrm{PGL}_2\) including HMSV arXiv:0906.2437 § 1. The manuscript reproves it by Hilbert–Mumford without citation. |
| C6b | Thm 2.4, matching base = reduced \((m+1)\)-equals arrangement | PPE | McDaniel–Watanabe (cited) own the two-row Specht-ideal perfection/reducedness that upgrades support to scheme. The support identification itself is an elementary Hall-type argument. |
| C6c | Thm 2.4, \(I_{r+s-1}(d\mu)=\mathfrak u^s\mathfrak v^{r-1}+\mathfrak u^{s-1}\mathfrak v^r\) for the Segre map; square-zero length-four defect at \(3+3\) points | NPL | Plausibly folklore in the determinantal-ideal literature; the spanning-tree minor computation is short. Not located under the queries run. Flag rather than claim. |
| C7 | Prop 2.5, synchronized pure-spinor quotient | PPE | Ambient: the graph of an alternating form is maximal isotropic and its Cartan big-cell coordinates are the principal Pfaffians — Chirivì–Maffei (cited); Chevalley classically. The Segre cubic as a Pfaffian on the target is Tschinkel–Zhang (cited). **Surviving:** the six-fold synchronized product, its outer equivariance including half-spin signs, the image ideal, and the fifteen-line base / ten nodal images (the latter inherited from C6). |
| C8a | Thm 2.6, (iii)⇔(iv) five-cycle normal form; twelve labelled five-cycles pairing into six projective fingerprints | PE | Bussemaker–Mathon–Seidel Ch. 5–6: unique order-six conference two-graph, pentagon-plus-isolated-vertex switching class, \(\mathrm{Aut}=A_5\). HMSV JCTA § 1.1 and § 1.6: six mystic pentagons; twelve 5-cycles in opposite pairs. |
| C8b | Thm 2.6, (i)⇔(ii)⇔(iii): universal balanced-cut \(5{:}1\) sign split ⇔ every cross determinant \(=\pm4\) ⇔ \(B^2=5I\) | NPL | The bound \(|\det|\le4\) for \(3\times3\) sign matrices is classical (Hadamard). The *equivalence* — universal attainment of the maximum on balanced cuts characterizes the conference identity — is not located in the conference-matrix, signed-graph-frustration, or maximum-determinant literature searched. **This is the strongest surviving conference-side claim.** |
| C8c | Thm 2.6, Gram identity \(RR^{\mathsf T}=12(I_6-\tfrac16J_6)\) | PPE | Immediate from the \(O_5'\) description (C2) plus two-transitivity; the derivation from ten-cut sign words is the paper's presentation. |
| C9 | Cor 2.7, ten balanced cuts, real \(\mathrm{ETF}(5,10)\), \(S_{10}^2=9I\), uniqueness of the sign Gram factorization up to monomial actions | PE | Fickus–Mixon arXiv:1504.00253: symmetric conference matrices of order \(N\) are exactly the sign Gram patterns of real \(\mathrm{ETF}(N/2,N)\). Bussemaker–Mathon–Seidel Ch. 6: the order-ten conference two-graph is unique, \(\rho=\pm3\), \(\mathrm{Aut}\cong\mathrm{Sp}(4,2)\cong S_6\), switching class contains the Petersen graph and \(T(5)\). Uniqueness up to monomial actions is switching-class uniqueness. **Surviving only as presentation:** that \(R\) is read off the six order-six sisters' balanced-cut determinant signs. Use "we identify"; do not use "first". |
| C10 | \(S_6/F_{20}\simeq X\times\cT\) | PPE | Ingredients classical: 36 Sylow 5-subgroups, \(N_{S_6}(\mathrm{Syl}_5)=F_{20}\), and HMSV JCTA § 1.4's order-20 subgroup giving the outer \(S_5\). The packaged equivariant product bijection was not located in that form; treat the assembly, not the ingredients, as the contribution. |
| C11 | Prop 3.1, the support split is the conference two-graph | PPE | Structurally pre-empted twice over: the two-graph ↔ switching-class correspondence via \(C_{ij}C_{jk}C_{ki}\) and the regular-two-graph ⇔ two-eigenvalue criterion (Seidel; stated in Bussemaker–Mathon–Seidel, whose Ch. 6 defines the Paley two-graph by exactly this non-square triple-product criterion on \(\mathrm{PG}(1,q)\), 2-transitive under \(\mathrm{PSL}(2,q)\) — \(q=5\) is the case at hand); and HMSV JCTA § 1.2's six triangle-colourings under the same two conditions. **Surviving:** the identification of the two \(A_5\)-orbits of the *Clebsch code's* coordinate triples with that two-graph. |
| C12 | Thm 3.2, recovery–propagation and minimal marking | NPL | Statement about the monomial Clebsch code class; internal to the programme. Coverage is thin — no Clebsch/deep-hole-code sweep was run here (owned by the Clebsch lane's own audits). Carry "to our knowledge". |
| C13 | Thm 3.3, boundary of unmarked reconstruction (Hom dimensions \(1\) and \(0\); Fitting-support non-descent) | NPL | Routine character theory plus a diagonal-congruence argument; no named predecessor expected or located. |
| C14a | Prop 3.4, base locus = ten nodes; resolved Gauss map birational; fifteen Segre planes contracted to the fifteen singular lines of \(I_4\) | PE | Kondō arXiv:1110.1126 § 2: "the dual of \(X\) is a quartic 3-fold \(Y\) called the Igusa quartic; the dual map \(d:X\to Y\) is defined on \(X\) except ten nodes and is birational; it is given by the linear system of quadrics through the ten nodes," referring to Hunt Ch. 3 for details. Classical ancestry Baker. |
| C14b | Prop 3.4, explicit fibre conic \((\beta-\gamma)a^2-(\alpha-\gamma)b^2+(\alpha-\beta)c^2=0\) through four Segre nodes; six-line fibre closure at the fifteen triple points | NPL **with a stated access gap** | Hunt, *The Geometry of Some Special Arithmetic Quotients*, Ch. 3 was NOT ACCESSED, and that is precisely where such a fibre computation would sit. The negative is weak here; keep "we have not located". |
| C15a | Thm 4.1, rational preimage of a rational Segre point; fibre is one \(\mathrm{PGL}_2\)-orbit; classical cross-ratio inverse | PE — already conceded in-text | Costa–Dobrescu–Fox arXiv:1905.13729 (general integer solution of \(\sum z=\sum z^3=0\) in \(n-2\) parameters); Gripaios–Nguyen arXiv:2508.11583 (unirational parametrization of the anomaly cubic); Gripaios–Nguyen arXiv:2607.09879 § 4 (Richmond's map, birational over \(\mathbb Q\)); HMSV JCTA § 2.4 (inverse dictionary). The manuscript's own concession paragraph is accurate. |
| C15b | Thm 4.1, \(e_5(Z(x))=32\prod_{i<j}(x_j-x_i)\) and \(\prod_{T<U}(Z_T+Z_U)=-e_5(Z)^3\) | PPE | Given HMSV JCTA § 2.4's \(X_{13\cdot26\cdot45}=(Z_a+Z_b)/2\), the second identity is the product of the fifteen matching brackets up to scale — a short classical consequence, not an independent discovery. Assembled form not located. |
| C15c | Thm 4.1, \(p_T^{(3)}=\lambda^2q_T^2/500\); the height-three census; the seven-chamber quartic real optimization and \(\kappa(t)^2=1.141\ldots\) | NPL | These are the paper's own physical-cost clauses; no comparable optimization appears in the anomaly literature searched. |
| C16a | Thm 4.2(i)(ii)(v), 21 Fano components as 15 planes + 6 split dP5; syntheme labelling; exactly six chiral lines through a generic point | PE | Gripaios–Nguyen arXiv:2607.09879 § 1 and § 4, read at the relevant sections: the component classification, the transitive \(S_6\)-action with stabilizer \(S_5\), the plane-to-syntheme table, "a generic line intersects five distinct planes," and the explicit six-lines-through-a-point construction. The manuscript's citation covers only the classification. |
| C16b | Thm 4.2(ii)(iii)(iv), the six components as one-moving-path families with \(\overline M_{0,5}\) parameter surfaces; synthematic-total structure of the five vectorlike crossings; minimality of degree-one homogeneous control | PPE | \(\overline M_{0,5}\cong\) split dP5 is classical and the dP5 statement is Gripaios–Nguyen's. **Surviving:** the six-points-on-\(\mathbf P^1\) "moving path" identification of the components, the synthematic-total labelling of the crossings, and the control-degree minimality. |
| C16c | Boxed mixed-anomaly identities \(\sum_T\det A_T(x)\Pf A_T(y)=0\), \(\sum_T\Pf A_T(x)\det A_T(y)=0\) | NPL | Depends on C3b; same coverage. |
| C17 | Appendix A, collision filtration; Luna slice passage; the explicit unstable-chart minor identities | NPL | Luna's slice theorem is cited correctly. The \(15/20/15\) filtration and the chart computations are the paper's. |
| C18 | Clifford/doily, \(E_8\)–Hamming and \(II_{10,10}\), McKay, Sylvester graph and \(K^2=10K+75I\), Bose–Mesner, class-D Altland–Zirnbauer / \(SO(6)/U(3)\) parity chambers, Kasteleyn/dimer orientation theory, Coble/Burkhardt/Vinberg/Rains–Sam, Reid pagodas | **NA** | None of this appears in `golden_operator.tex`. It lives in C717 (sequel-only by C735's placement ledger), C729, and C739 report material. The task's verdict scope is the manuscript's claims; auditing sequel-only material would have diluted coverage on what is actually in the paper. **These need their own audit before any sequel manuscript.** Two are already partly settled inside the lane: C729 concedes \(K=-3A_1+A_2-A_3\) as Sylvester Bose–Mesner primitive-idempotent machinery, and C739's post-closeout sweep positions the matching/Specht/Catalan skeleton as classical. |

Counts: **PE 7** (C3a, C5a, C6a, C8a, C9, C14a, C15a, C16a — eight rows, seven distinct
theorem-level pre-emptions since C15a is self-conceded), **PPE 10**, **NPL 10**, **NA 1 (a block)**.
The exact row tallies are: PE 8 rows, PPE 10 rows, NPL 10 rows, NA 1 row.

---

## Adjacent-crown extraction (per `notes/novelty-extraction-conventions.md`)

The pre-emptions are attribution failures, not crown failures: no theorem in the manuscript loses
its principal claim, because the principal claim (Theorem 2.3's propagation square) survives.
One bounded extraction pass was run anyway on the two heaviest concessions.

**Exact pre-emption.** HMSV JCTA 2008 owns the outer six-family, the mystic-pentagon/triangle-split
combinatorics, the coloured-triangle Joubert cubics, and the centered-square polar map.
Gripaios–Nguyen arXiv:2607.09879 owns the Fano-component realization of the two-\(U(1)\) anomaly
lines.

**Surviving result.** The conference-operator layer: \(\Pf[D_x,C_T]=4Z_T\), the golden compression
\(Z_T=\pm10\sqrt5\det B_T\) with its determinantal/MCM package, the Jacobian adjugate identity, and
the balanced-cut characterization of \(C^2=5I\).

**Adjacent gaps inspected (three).** (a) HMSV JCTA § 1.3 notes that an icosahedron embedded in
\(\mathbb Q(\varphi)^3\) is sent to its opposite by \(\mathrm{Gal}(\mathbb Q(\varphi)/\mathbb Q)\) —
a classical golden conjugation exchanging the two halves of the support split, sitting directly
beside the manuscript's golden conjugation. (b) Gripaios–Nguyen's Richmond-map chart is a rational
inverse independent of the C715 chart, so the two give a cross-check the manuscript does not use.
(c) Fickus–Mixon's conference-matrix ↔ ETF dictionary is stated for every order, so the
\(6\to10\) step is one rung of a ladder the manuscript treats as a single event.

**Candidates formulated (six).**
1. State the golden compression as a *new determinantal representation of the cubic wall*
   \(\{Z_T=0\}\subset\mathbf P(A_X)\) and count its nodes against the classical six-node bound for
   \(3\times3\) linear determinantal cubic threefolds.
2. Promote Theorem 2.6(i)⇔(iii) to arbitrary even order: does universal balanced-cut maximum
   determinant characterize \(B^2=(n-1)I\) for all \(n\equiv2\bmod4\)?
3. Cross-validate the C715 inverse against Richmond's map and publish the comparison as a
   verification item.
4. Read HMSV § 1.3's Galois-conjugate icosahedra as the classical shadow of golden conjugation and
   cite it where the manuscript introduces the \(\sqrt5\) bit.
5. Extend the commutator-Pfaffian identity to skew conference matrices (order \(\equiv0\bmod4\)).
6. Ask whether Theorem 2.3(iv)'s adjugate identity has an order-\(2m\) analogue on the universal
   matching carrier.

**Cheap-tested (top two).** Candidate 2 is the highest value and is cheap: the manuscript's own
proof of Theorem 2.6 uses only that a \(3\times3\) sign determinant is \(0\) or \(\pm4\) and a
two-regularity count, both of which have order-\(m\) analogues; the obstruction is that
\(m\times m\) sign matrices have no single maximal-determinant value for \(m>3\), so the "universal
maximum" formulation does not transpose verbatim. It becomes "every balanced cross determinant is
nonzero and of extremal Hadamard type." **Passes the cheap gate as a well-posed question, fails as
a verbatim generalization.** Candidate 1 is also cheap and passes: the manuscript already knows
\(\det B_T\doteq Z_T\), so the node count of \(\{Z_T=0\}\) follows from the rank-one locus of
\(B_T\) and can be settled by a short symbolic computation.

**Allocation:** none made. Both passing candidates are within the existing manuscript's reach as
strengthenings rather than new tasks, and this audit does not hold the allocation gate. They are
carried as recommendations R6 and R7 below for the owning lane to allocate normally.

---

## Recommendations for the golden lane

Wording only — the manuscript, handoff and queue were not touched.

**R1 (must).** Add an explicit attribution sentence to Theorem 2.3(iv). Proposed:

> The centered square is the classical Segre–Igusa duality map; the formula
> \(W_T=Z_T^2-\tfrac16\sum_UZ_U^2\) and the \(S_6\)-symmetric Igusa equation are stated in
> \cite{HMSVOuter}, following van der Geer. What is new here is the adjugate identity
> \(\operatorname{adj}\mathsf A=6\widehat Wq^{\mathsf T}\), which identifies that polar direction
> with the left kernel of the Joubert Jacobian.

**R2 (must).** Add to Theorem 2.6 and Proposition 3.1 a joint attribution to \cite{HMSVOuter}
§ 1.1–1.2 and to the two-graph literature. Proposed for Theorem 2.6:

> Conditions (iii) and (iv), the count of twelve labelled five-cycles, and their pairing into six
> classes are classical: the six classes are the mystic pentagons of \cite{HMSVOuter}, and the
> order-six conference two-graph is unique with automorphism group \(A_5\) \cite{BMS}. The content
> of the theorem is the equivalence of (i) and (ii) with them.

and for Proposition 3.1:

> The passage between a two-graph and the switching class of a sign matrix through
> \(C_{ij}C_{jk}C_{ki}\), and the equivalence of regularity with \(C^2=(n-1)I\), are Seidel's; the
> six unordered splits of the twenty triples are \cite{HMSVOuter} § 1.2. What is proved here is
> that the \(A_5\)-orbit split carried by the monomial Clebsch code class is that two-graph.

**R3 (must).** Expand the Gripaios–Nguyen citation in Theorem 4.2. As written, `\cite{GripaiosNguyenTwo}`
supports only the component classification, while that paper also owns the transitive \(S_6\)-action
with stabilizer \(S_5\), the syntheme labelling of the plane images, "a generic line meets five
planes," and the six-lines-through-a-generic-point count. Restrict the theorem's own assertion to
the marked realization: the moving-path identification of the six components, the synthematic-total
labelling of the crossings, and the control-degree minimality.

**R4 (must).** Add an attribution sentence to Corollary 2.7 naming the classical order-ten object
(unique conference two-graph, \(\mathrm{Sp}(4,2)\cong S_6\), Petersen switching class) and the
general conference-matrix ↔ real \(\mathrm{ETF}(N/2,N)\) dictionary. Use "we identify"; do not use
"first" or "new" anywhere in that corollary.

**R5 (should).** Cite classical GIT for Theorem 2.4's stability trichotomy rather than reproving it
silently, and state explicitly that the manuscript's contribution there is the critical-ideal
formula and the nilpotent-defect identification.

**R6 (should, allocatable).** Settle the node count of the cubic wall \(\{Z_T=0\}\) under the golden
determinantal representation and compare with the classical bound for \(3\times3\) linear
determinantal cubic threefolds. Cheap symbolic computation; strengthens Theorem 2.3(iii).

**R7 (may, allocatable).** Pose the even-order form of Theorem 2.6(i)⇔(iii) as a question rather
than attempting a verbatim generalization; the maximal-determinant formulation does not transpose.

**R8 (must, before any priority language).** MathSciNet is NOT COVERED. Every claim marked NPL above
must carry "to our knowledge" or "we have not located," never "first." This applies in particular to
C3b, C4, C5b, C8b, C14b and C16c.

**R9 (should).** The verification supplement should record the Richmond-map cross-check of the C715
inverse (candidate 3) if it is cheap; an independent rational inverse from the literature is a
stronger replay than a second in-house chart.

**R10 (should).** `\cite{HMSV}` points at arXiv:0906.2437, a six-page announcement. It does carry
the statement the manuscript needs ("the degree 1 part \(R_1\) of the ring carries the irreducible
\(S_n\) representation corresponding to \(n/2+n/2\)"), so the citation is sound; but if the
manuscript wants the multiplicity-one and Plücker-generation details, the long HMSV paper is the
right target. Resolve from a consulted source, not from recall.

---

## Sources, with read depth

Every source named in this report appears here. Cache keys are in the shared lit-search cache
(`/tmp/persistent/tavis/lit-search`); SHA-256 values are in the evidence JSON and are re-verified by
the replay command.

### Full text (3)

| Source | Version read | Access | Sections relied on |
|---|---|---|---|
| J. M. Goethals, J. J. Seidel, *Orthogonal matrices with zero diagonal*, Canad. J. Math. (1967), DOI 10.4153/CJM-1967-091-8 | published, as cached | cache key `10.4153/CJM-1967-091-8` | whole paper; §§ 1–3 for the definition \(CC^{\mathsf T}=(v-1)I\), the equivalence (switching) relation, and Belevitch/Raghavarao necessary conditions |
| B. Howard, J. Millson, A. Snowden, R. Vakil, *A description of the outer automorphism of \(S_6\), and the invariants of six points in projective space*, J. Combin. Theory Ser. A 115 (2008), 1296–1303, DOI 10.1016/j.jcta.2008.01.004 | published | cache key `10.1016/j.jcta.2008.01.004` | whole paper; § 1.1 mystic pentagons, § 1.2 labelled triangles, § 1.3 icosahedra, § 1.4 pentads and the order-20 subgroup, § 1.5–1.6 the five-dimensional representations, § 2.1 Joubert cubics, § 2.2 Segre–Igusa duality, § 2.4 matching-bracket dictionary |
| B. Howard, J. Millson, A. Snowden, R. Vakil, *The relations among invariants of points on the projective line*, arXiv:0906.2437 | arXiv v1 preprint (six-page announcement); the long published version was NOT read | cache key `arXiv:0906.2437` | whole announcement; § 1 for \(R_1\cong S^{(n/2,n/2)}\) and the Segre cubic as the unique non-quadric case |

### Partial (8)

| Source | Version | Access | Sections read |
|---|---|---|---|
| F. C. Bussemaker, R. A. Mathon, J. J. Seidel, *Tables of two-graphs*, DOI 10.1007/BFb0092256 | published, as cached | cache key `10.1007/BFb0092256` | narrative chapters only: the \(n=6\) and \(n=10\) discussions in Ch. 5 (pentagon switching class with \(A_5\); Petersen two-graph with \(\mathrm{Sp}(4,2)\cong S_6\)) and Ch. 6 (Paley two-graph definition by non-square triple product; unique conference two-graphs at \(n=6\) and \(n=10\); eigenvalue lists). The bulk numeric tables were not read. |
| B. Gripaios, K. Le Nguyen Nguyen, *Anomaly cancellation for two \(U(1)\) factors*, arXiv:2607.09879 | arXiv preprint | cache key `arXiv:2607.09879` | § 1 introduction in full; § 4 (Segre cubic primal, Richmond map, plane-to-syntheme table, the six \(D\) components, twisted-cubic component); reference list |
| B. Gripaios, K. Le Nguyen Nguyen, *Anomaly cancellation for a \(U(1)\) factor*, arXiv:2508.11583 | arXiv v2 | cache key `arXiv:2508.11583` | abstract and § 1–2.2 (unirationality, secant/tangent parametrization) |
| D. B. Costa, B. A. Dobrescu, P. J. Fox, *General solution to the \(U(1)\) anomaly equations*, arXiv:1905.13729 (published as Phys. Rev. Lett. 123 (2019) 151601 per the manuscript's own citation) | arXiv v1 preprint; the published version was NOT read | cache key `arXiv:1905.13729` | abstract and the opening section stating the \(n-2\)-parameter general integer solution |
| I. Dolgachev, *Corrado Segre and nodal cubic threefolds*, arXiv:1501.06432 | arXiv preprint | cache key `arXiv:1501.06432` | § 2 (10 nodes, 15 planes, the \((15_4,10_6)\) configuration, Castelnuovo–Richmond equations, Joubert 1867, Coble's \((\mathbf P^1)^6/\!/\mathrm{SL}_2\cong S_3\)); § 3 (determinantal representations, Thm 3.5, Rem. 3.8, small-resolution counts) |
| S. Kondō, *The Segre cubic and Borcherds products*, arXiv:1110.1126 | arXiv preprint | cache key `arXiv:1110.1126` | § 1–2 (Cayley cubics, 15 planes, the dual map to the Igusa quartic defined off the ten nodes, quadrics through the nodes, pointer to Hunt Ch. 3) |
| M. Fickus, D. G. Mixon, *Tables of the existence of equiangular tight frames*, arXiv:1504.00253 | arXiv preprint | cache key `arXiv:1504.00253` | § 1 introduction; § 2 (real ETF ↔ strongly regular graph correspondence, Naimark complements); the conference-matrix subsection identifying symmetric conference matrices of order \(N\) with the sign Gram matrices of real \(\mathrm{ETF}(N/2,N)\) |
| N. I. Gillespie, P. Ó Catháin, C. E. Praeger, *Construction of the outer automorphism of \(S_6\) via a complex Hadamard matrix*, arXiv:1805.01273 (DOI 10.1007/s11786-018-0382-0) | arXiv v1 preprint; the published version was NOT read | cache key `arXiv:1805.01273` | § 1 introduction and § 2 (the order-six complex Hadamard matrix over third roots of unity), plus a keyword sweep of the full text for conference/two-graph/switching/Segre/Pfaffian, all absent. **Named to be dismissed: it is an adjacent construction of the same outer automorphism from a different order-six matrix, and pre-empts nothing here.** |

### Abstract / metadata only (5)

| Source | Retrieved | From |
|---|---|---|
| R. Chirivì, A. Maffei, *Pfaffians and shuffling relations for the spin module*, arXiv:1203.2943 | title, abstract, PDF bytes | arXiv API `id_list` query; cache key `arXiv:1203.2943`. Cited by the manuscript for the Cartan big-cell principal-Pfaffian expansion; the body was not read, so the manuscript's use of it is **unverified against the paper**. |
| C. McDaniel, J. Watanabe, *Principal radical systems, Lefschetz properties and perfection of Specht ideals of two-rowed partitions*, arXiv:2103.00759 | title, abstract | arXiv API; cache key `arXiv:2103.00759`. Abstract confirms perfection of two-rowed Specht ideals in characteristic zero or bounded below; the reducedness use in Theorem 2.4 is **unverified against the paper**. |
| Y. Tschinkel, Z. Zhang, *Stable equivariant birationalities of cubic and degree 14 Fano threefolds*, arXiv:2409.08392 | title, abstract | arXiv API; cache key `arXiv:2409.08392` |
| J.-Y. Cai, A. Gorenstein, *Matchgates revisited*, arXiv:1303.6729 | title, abstract | arXiv API; cache key `arXiv:1303.6729` |
| F. C. Bussemaker, I. Kaplansky, B. D. McKay, J. J. Seidel, *Determinants of matrices of the conference type*, Linear Algebra Appl. 261 (1997) 275–292, DOI 10.1016/s0024-3795(96)00412-0 | authors, title, journal, volume, pages, year from Crossref; subject matter (maximum determinants of odd-order conference-type matrices) from a search-engine summary and therefore **attributed to that summary and unverified against the paper** | Crossref API + web search. Named because it is the nearest-titled candidate for a predecessor of C8b; on the retrieved description it concerns odd \(n\) and does not address the balanced-cut equivalence. |

Not separately listed: E. Early(?), *Generalized permutohedra, scattering amplitudes, and a cubic three-fold*, arXiv:1709.03686 — **abstract/metadata only**, retrieved from the Semantic Scholar citing set and a keyword sweep of the cached text; it treats the Segre cubic in an amplitudes context and pre-empts nothing audited here. Cache key `arXiv:1709.03686`.

### NOT ACCESSED (carried forward as open gaps)

| Source | Why it mattered | Why not accessed |
|---|---|---|
| B. Hunt, *The Geometry of Some Special Arithmetic Quotients*, LNM 1637, Ch. 3 | The reference Kondō defers to for the Segre–Igusa duality details; the natural home for a fibre computation like C14b | Book, not obtainable in this session |
| J. J. Seidel, *A survey of two-graphs* (identified via OpenAlex, DOI 10.1016/b978-0-12-189420-7.50018-9) | Canonical statement of the two-graph/switching-class and regularity theorems | Not obtainable; content substituted by Bussemaker–Mathon–Seidel at partial depth |
| J. H. van Lint, J. J. Seidel, *Equilateral point sets in elliptic geometry* (1966) | The origin of equiangular lines from conference matrices | Not obtainable |
| P. W. H. Lemmens, J. J. Seidel, *Equiangular lines*, J. Algebra 24 (1973) 494–512 (bibliographic detail from a search-engine summary, unverified) | Maximum equiangular line sets in \(\mathbb R^5\), the ambient for C9 | Not obtainable |
| I. Dolgachev, *Classical Algebraic Geometry: A Modern View*, § 9.4 | Standard modern treatment of the Segre cubic and Joubert coordinates | Book, not obtainable |
| D. Luna, *Slices étales* (cited by the manuscript's Appendix A) | The slice theorem underwriting the off-node exclusion | Not obtainable; the manuscript's use is **unverified against the source** |

---

## Screened sets

**Set 1 — forward citations of Howard–Millson–Snowden–Vakil (JCTA 2008).**
Provenance: Semantic Scholar Graph API, `paper/DOI:10.1016/j.jcta.2008.01.004/citations`,
`fields=title,year,externalIds&limit=100`. Size retrieved: 40, matching the service's reported
`citationCount`. Fields screened: title and year only. Discriminator: manual read of every title for
any of {conference matrix, Hadamard, two-graph, equiangular, Segre cubic, Igusa, Pfaffian,
determinantal, anomaly}. Promoted for individual discussion: *Construction of the outer automorphism
of \(S_6\) via a complex Hadamard matrix* and *Generalized permutohedra, scattering amplitudes, and
a cubic three-fold* (both carry read-depth fields above). The remainder — Pascal-line geometry,
eight-point invariant theory, spin curves, Burkhardt/Coble geometry, puzzle papers, quiver moduli —
was excluded as off-question by that discriminator.

**Set 2 — forward citations of Goethals–Seidel (1967).**
Provenance: OpenAlex `works?filter=cites:W2042826512&per-page=200`. Service count: 213; retrieved
200 (first page). Fields screened: title only. Discriminator, mechanical, applied verbatim as a
Python regular expression over the title field:

```
segre|igusa|joubert|two-graph|two graph|equiangular|frame|pfaffian|determinant|frustrat|matching|dimer|spinor|anomal|switching|outer automorphism|cubic
```

Hits: 21. Promoted for individual discussion: *Tables of two-graphs* (partial), *Determinants of
matrices of the conference type* (abstract/metadata only), *A survey of two-graphs* (NOT ACCESSED).
The remaining hits — complex conference matrices, equiangular-line bounds and the Lemmens–Seidel
conjecture, lattices from tight frames, frames-and-erasures papers — were excluded because none
addresses a balanced-cut determinant characterization, a commutator Pfaffian, or the Segre cubic.
**The screen is incomplete**: 13 of 213 records were not retrieved (single-page fetch), so this set
supports "no predecessor located," not exhaustion.

**Three-service counts, recorded separately, as of 2026-08-01.**

| Seed | OpenAlex | Crossref | Semantic Scholar |
|---|---|---|---|
| `10.1016/j.jcta.2008.01.004` (HMSV outer) | 28 | 9 | 40 |
| `10.4153/CJM-1967-091-8` (Goethals–Seidel) | 213 | 117 | 146 |

The disagreement is large and is itself a reportable finding: Crossref undercounts both seeds
substantially (arXiv-only citing works and book chapters are missing), and OpenAlex and Semantic
Scholar disagree in opposite directions on the two seeds. The largest set was screened in each case
(Semantic Scholar for HMSV, OpenAlex for Goethals–Seidel), per convention.

---

## Coverage statement

**Searched and found nothing** (licenses the NPL verdicts, at the strength stated):

- **arXiv**: full-text PDF retrieval and keyword sweeps over the ten cached preprints listed above;
  identifier resolution for every manuscript citation via the arXiv API `id_list` endpoint. Every
  bibliography entry in `golden_operator.tex` resolved to a real record with a matching title.
- **OpenAlex**: DOI resolution and the forward-citation screen of Set 2.
- **Crossref**: metadata resolution for two DOIs and citation counts for both seeds.
- **Semantic Scholar Graph API**: citation counts for both seeds and the full citing set of Set 1.
- **zbMATH Open**: six queries run (verbatim in the evidence JSON). Five returned zero documents;
  one returned a single irrelevant conference-proceedings record. Empty results are distinguished
  from errors by HTTP status: zbMATH returns HTTP 200 with a populated `result` array on a match and
  HTTP 404 on zero matches, verified in both directions against a known-good query
  (`Seidel two-graph switching class` → 200) and a nonsense token (→ 404); network failures surface
  as a `URLError`, which did not occur.
- **General web search**: the queries listed verbatim in the evidence JSON, covering conference
  matrices and maximum determinants, equiangular tight frames and Naimark complements, Segre–Igusa
  duality and the Gauss map, Joubert coordinates, Pfaffians of commutators, Seidel-matrix exterior
  powers, and the \(S_6\) Sylow/\(F_{20}\) combinatorics.

**Could not access** (licenses nothing; carried forward):

- **MathSciNet** — NOT COVERED, requires institutional authentication. Every NPL verdict above
  remains gated on it; recommendation R8 keeps "to our knowledge" on all of them.
- **Google Scholar** — NOT COVERED, blocks automated access.
- The six printed/unavailable sources in § Sources → NOT ACCESSED, individually with the reason.
- Set 2's forward screen is partial (200 of 213 records).

**Not attempted, and stated as such rather than as a negative:** no sweep was run over the Clebsch
deep-hole coding literature (bearing on C12), and none over the Clifford/lattice/Altland–Zirnbauer
material (C18), which is not in the manuscript.

---

## Attribution notes

- Every bibliographic field above comes from a consulted source: Crossref or the arXiv API for
  metadata, the cached PDF text for content. Where a field came from a search-engine summary
  (Lemmens–Seidel's volume and pages; the subject matter of Bussemaker–Kaplansky–McKay–Seidel) it is
  marked as such and is unverified against the paper.
- Characterisations of what a paper "owns" in the verdict table are the auditor's inferences from
  the sections recorded, kept distinct from the sources' own framing. In particular, HMSV JCTA 2008
  does not present § 2.2 as a result about conference operators; the claim that it pre-empts
  Theorem 2.3(iv) is the auditor's reading of an identical formula in an identical setting.
- No citation in `golden_operator.tex` was repaired from recall. `\cite{GripaiosNguyenTwo}`,
  `\cite{HMSV}`, `\cite{HMSVOuter}`, `\cite{KondoSegre}`, `\cite{McDanielWatanabe}`,
  `\cite{ChiriviMaffei}`, `\cite{CaiGorenstein}`, `\cite{TschinkelZhang}`,
  `\cite{CostaDobrescuFox}` and `\cite{GripaiosNguyen}` were each resolved to an existing record
  with the stated title; `\cite{LunaSlices}` was not resolved and remains an open gap.

---

## Evidence bundle and replay

Committed alongside this report, same stem:

- `notes/2026-08-01-c755-golden-operator-literature-audit.json` — every load-bearing query verbatim,
  the pinned identifiers, the three-service counts as of 2026-08-01, the screened-set records, and
  the cache key + SHA-256 + byte count of every cached source.
- `notes/2026-08-01-c755-golden-operator-literature-audit.py` — the checker.
- `notes/2026-08-01-c755-golden-operator-literature-audit.sha256` — hashes of the report, the JSON,
  and the script.

Replay, from the repository root:

```
python3 notes/2026-08-01-c755-golden-operator-literature-audit.py --check
```

What it certifies: that every source this report calls cached is present in the shared lit-search
cache at the recorded SHA-256 and byte count, so a later reader is looking at the same bytes; and
that every pinned arXiv identifier still resolves to a record with the recorded title. It re-queries
OpenAlex, Crossref and Semantic Scholar and **reports** count drift without failing, because
citation counts are not stable artifacts. What it does not certify: read depth, the verdicts, or
that a search was exhaustive. The trusted boundary is the shared cache's own integrity check
(`litcache.py verify`) plus the three service APIs.

The blobs themselves are outside git by the cache contract (copyright and size). The manifest
metadata mirrored into the JSON is the in-repository record.

**Independent cross-check:** the two heaviest pre-emptions do not rest on a single service. HMSV
JCTA 2008 was reached through the shared cache and independently confirmed through a general web
search that surfaced the mystic-pentagon description from a third-party mirror; the order-six and
order-ten conference two-graph facts appear both in Bussemaker–Mathon–Seidel (cached, read) and in
Fickus–Mixon (cached, read) through an independent route. The Gripaios–Nguyen pre-emption rests on
one source read directly, with no independent cross-check available — it is a 2026 preprint.

---

## Mystery ledger

| Open question | Status after the `ej`+`tt` pass | Owner / gate |
|---|---|---|
| Does universal balanced-cut maximum determinant characterize \(B^2=(n-1)I\) in every even order? | Settled as ill-posed in verbatim form: for \(m>3\) there is no single maximal determinant value for \(m\times m\) sign matrices, so the statement must be reformulated as "every balanced cross determinant is nonzero of extremal Hadamard type" | R7; unallocated |
| How many nodes does the cubic wall \(\{Z_T=0\}\) have under the golden determinantal representation, against the classical six-node bound for \(3\times3\) linear determinantal cubic threefolds? | Open; cheap symbolic computation identified | R6; unallocated |
| Is the explicit Gauss-map fibre of Proposition 3.4 in Hunt Ch. 3? | Open, and the gap is an access gap, not a search gap | Hunt LNM 1637 Ch. 3, NOT ACCESSED |
| Does `\cite{ChiriviMaffei}` actually support the Cartan big-cell claim as used? | Open; abstract only | Read the body before submission |
| Does `\cite{LunaSlices}` page range match the saturated slice statement used in Appendix A? | Open; source not resolved | Verify against a consulted copy |
| Why does the golden \(\sqrt5\) conjugation have a classical shadow in HMSV § 1.3's Galois-conjugate icosahedra? | Noted, not explained: the same \(\mathrm{Gal}(\mathbb Q(\varphi)/\mathbb Q)\) exchanges the two halves of the support split there and the two cross-golden resolutions here | Logged to the discovery track; no allocation |

No manufactured mysteries. The genuinely surprising finding of this audit is how much of the
manuscript's classical layer is in one eight-page paper the manuscript already cites.
