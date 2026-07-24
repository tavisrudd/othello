# Adversarial proof and evidence audit

This is the C571 referee-facing failure checklist. A row closes only with a
specific proof location or evidence record.

| Risk | Present status | Closure gate |
|---|---|---|
| “LU=LC” is read as the false global conjecture | closed in Theorem 1.1 and Section 8 | exact linear MDS/equal-phase CSS scope stated at first use and in final boundary |
| Equality of orbit partitions is confused with classification of all LU intertwiners | closed in Theorem 1.1 | headline theorem quantifies over every intertwiner; Corollary 1.2 is separate |
| A Pauli or holonomy signature is used as an arbitrary-LU invariant | closed in Sections 4 and 6 | holonomy used only for LC; LU claims use reduced-operator covariance or basis-free contractions |
| The scalar `z` is claimed LU-complete from finite samples | closed in Sections 3--4 | exact bracket quotient plus uniform LU-to-LC rigidity, not interpolation |
| Exceptional characteristics are silently removed | closed in Sections 4, 7, and 8 | admitted pencil equation and detector-only exception table are explicit |
| The H3/GRS theorem is generalized to the whole pencil | closed in Theorem 6.1 | exact odd good non-GRS H3 domain retained |
| Four-copy rank drop is mistaken for a complete coordinate | closed after Theorem A.1 | generic-constancy proposition and closing warning distinguish divisor from coordinate |
| Computational evidence lacks a public replay | closed by C563 | `supplement/EVIDENCE.md`, manifest, exact generators/certificates, and `verify.py --replay` |
| Classical six-point invariant theory is presented as new | closed by C562 and Sections 1/8 | novelty claim restricted to the exact full-Weyl MDS/CSS LU-rigidity scope |
| The manuscript inherits report terminology without defining conventions | closed in Section 2 | projective, monomial, Weyl, Clifford, stabilizer, GRS, and party actions defined |

## C571 independent cold-read closures

The cold reader first read only the manuscript, without the ledgers. The
headline LU-to-LC theorem, arc/code/state dictionary, and diagonal-axis proof
were judged clear and convincing. The following defects were then repaired.

| Cold-read finding | Revision | Closure |
|---|---|---|
| `T_p` in (A.2) had no `p`-dependence | Appendix A now defines the systematic matrix `Q_p` after each party assignment and derives the block operator and rank bridge as (A.2)--(A.4) | displayed-definition contradiction closed |
| LC holonomy was undefined and the 450-entry collision claim was asserted | Section 4 now defines `K_T`, `M_T(i,j)`, and `Hol(T,U;i,j)`, proves LC covariance, states the symbolic/certificate bridge, and gives the complete multiplicity-collision argument | central `LC ⇒ z` proof made referee-followable |
| “fixed-party symplectic kernel” and its propagation were undefined | Section 5 now defines the kernel, gives the four multiplier inclusions (5.2), derives code--dual equivalence from a nondiagonal block, cites the six-point self-association theorem, and states the GRS converse | fixed-party theorem proof expanded |
| party-moving normalizer sounded unconditional | Theorem 5.1 now says an isoduality generates the normalizer only when present; the order `2420` is explicitly restricted to the two certificate-checked `q=11` non-GRS classes | scope corrected |
| Weyl phases were underspecified | Section 2 fixes the exact CSS lift `X(c)Z(h)` and explains why its multiplication phases vanish | (2.1), (3.3), and (6.1) use one exact convention |
| “odd good residue field” was undefined | Theorem 6.1 now quantifies over a prime ideal of `Z[τ]`, names the residue field, and defines goodness by the six-arc condition | arithmetic domain explicit |
| marginal rank/concurrency bridge was asserted | Section 6 derives the trace normalization, addition-map kernel count, Gale-dual split, and graph-type reduction | conceptual bridge constructed in prose |
| q=13 copy pattern and party action were absent | Section 6 displays the six permutations, defines `πσ`, states the rank field, and names the complete C397 replay | finite domain explicit |
| generic constancy was false on reducible families | Proposition 6.3 now assumes an irreducible reduced parameter variety and regular constant-dimension chart, states componentwise scope, and separates geometric density from finite rational points | theorem corrected |
| transport type exhaustion, minors, and double cosets were hidden | Appendix A distinguishes the conceptual systematization from certificate-supported cycle-cover exhaustion, exact minors, representatives, stabilizers, intersections, and supports | trust boundary and completeness bridge explicit |
| exceptional-characteristic table lacked derivation | Appendix A displays the characteristic `3,5,7` factor identities and gives the exact-minor reason that `7,11,13,41` have no larger kernel | exceptional arithmetic reconciled with theorem |
| the paper ended administratively | Section 8 now ends with the mathematical contrast between Weyl-axis covariants and generically blind scalars | hierarchy restored |
| second cold read found that full extension-field Cliffords are larger than `SL₂(q)` | Theorems 4.1, 5.1, and Corollary 1.2 now restrict their quantum clauses to odd prime fields; Section 4 records the exact admitted `q=25` Frobenius counterexample `t=s`, `u=-s`, `z(s)≠z(-s)` | release-blocking scope error corrected; all-prime-power Theorem 1.1 remains unchanged |
| the displayed definition of \(\mathcal K_C\subseteq\mathrm{SL}_2(q)^6\) could recreate the retracted extension-field claim | Section 5 now assumes \(q\) odd prime before defining \(\mathcal K_C\) and contrasts its blocks with the full \(\mathrm{Sp}_{2e}(\F_p)\) extension-field action | scope caveat moved to first use |
| the proof asserted the unsupported exact set \(b\in\{0,1,2,3,4,6\}\) although it established only \(b\leq6\) | Theorem 6.1 now states only the needed bound and records the octahedral equality case | stronger unproved exclusion removed; \(70>66\) argument unchanged |
| the logical-phase positioning did not separate prior GRS gate constructions from the paper's contribution | the introduction now credits quantum RS encoders, polynomial-code gate procedures, and general stabilizer Clifford gadgets, disclaims priority for the GRS constructions, and identifies the new claim as the fixed-party self-association iff classification | novelty boundary made explicit |
| Theorem A.1 did not quantify the party assignment | It now states `∃ p∈S₆` for nonconstant sections and follows with the generic number of such assignments | quantifier repaired |
| Theorem 6.1's characteristic-five vacuity appeared only in the proof | the theorem statement now says explicitly that the non-GRS hypothesis is vacuous in characteristic five | exceptional-field scope visible at first use |
| the octahedral equality case was phrased as though every field contained the required subgroup | the proof now conditions attainment on the existence of an octahedral \(S_4\subseteq\mathrm{PGL}_2(q)\) | equality case no longer overgeneralized |
| Proposition 6.3 used one field both as parameter base and local Hilbert-space cardinality without saying so | the proposition names \(k\), identifies \(q=|k|\) with the local dimension under the code--state dictionary, and declares \(X/k\) | the two roles are explicit |
| “redundant witness” had no local referent | the introduction now says that the appendix witness is redundant specifically by Corollary 1.2 | redundancy claim is theorem-linked |
| the fixed-party dichotomy novelty sentence lacked a stated search scope | the introduction now lists the quantum RS/polynomial-code, stabilizer-Clifford, and transversal-gate literatures screened | bounded search scope stated without an exhaustive priority claim |

## Formal-coverage adversarial checklist

| Required check | Evidence | Verdict |
|---|---|---|
| Two-way manuscript/declaration coverage | Main table and reverse map in `formal-statement-adequacy.md`; all 33 declarations in `AMELUAggregateAxioms` are represented | closed |
| Every conditional field has a source | Field-by-field table maps every field of `PencilClassificationInputs`, `LogicalPhaseInputs`, `MarginalMomentModel`, `MarginalLUSeparatorInputs`, `FourCopySeparatorInputs`, `TransportCycleCoverInputs`, `TransportRankBridgeInputs`, and `TransportOrbitGeometryInputs` | closed |
| Full project-owned transitive referee-prose review | Reviewed the nine `RelativeConicArcs.AMELU` source modules and all AMELU gate/axiom terminals; no task IDs, temporary paths, `TODO`/`FIXME`, workflow residue, hidden `sorry`, project axiom, or unsafe declaration occurs in the closure | closed |
| Separate formalized implication, constructed hypothesis, and certificate-supported hypothesis | Section 8 and the field map use these categories explicitly; mixed rows name both roles | closed |
| Release includes adequacy and exact aggregate audit | `second-draft-fix-plan.md` assigns both exact artifacts and their immutable identity to C572 | closed for C571; immutable hashes remain C572-owned |
