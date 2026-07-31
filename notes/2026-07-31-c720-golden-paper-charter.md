# C720 frozen charter — the golden conference operator and its shadow sisters

**Lane:** golden

**Date:** 2026-07-31

**Status:** complete; manuscript root admitted

## Decision

The paper is a **go**.

The C704--C710 portfolio has one theorem-level source and one proof order:
a fully marked symmetric conference operator \(C\), with \(C^2=5I\), is
carried by exterior power, commutator, golden compression, adjugation, and
centered squaring to its cubic, polar, determinantal, exceptional, fermionic,
anomaly, and lattice shadows.  The central mechanism is strong enough to
support a standalone paper, and the secondary results admit a strict
hierarchy that keeps the main argument visible.

The authoritative manuscript root is papers/golden-operator/.  Paper III
remains unchanged and outside the Golden write surface.

## Identity, audience, and scope

**Title:** *The golden conference operator and its shadow sisters*.

**Primary audience:** algebraic geometers and invariant theorists working
with the Segre cubic, Igusa quartic, determinantal varieties, and exceptional
\(S_6\).

**Adjacent audiences:** representation theorists, coding theorists, and
mathematical physicists working with conference matrices, Clifford systems,
free fermions, and anomaly equations.

The paper begins with an abstract marked golden presentation.  It does not
require a reader to know how Papers I or III recover that presentation.
Those provenance theorems enter later as corollaries or examples.

The paper proves exact finite free-fermion statements.  It does not construct
a gauge theory, interacting phase, topological qubit, positive dimer model,
or hardware implementation.

## Provisional abstract

Let \(C\) be a marked symmetric conference operator on six axes with
\(C^2=5I\), and let \(C_T\) run through its coherent outer six-family.  We
show that the diagonal of the middle exterior operator
\(*\bigwedge^3C_T\) is the signed Joubert cubic vector.  Its image lies on
the Segre cubic, while centered squaring is the Segre--Igusa polar map.
The same cubics are Pfaffians
\(\operatorname{Pf}[D_x,C_T]=4Z_T(x)\); over the golden splitting they are
determinants of the cross-eigenspace blocks.  Their adjugates produce the
two small resolutions, conjugate rank-one maximal Cohen--Macaulay sheaves,
and the rank-one differential factorization of the polar map.  On the
balanced Boolean layer, \(C^2=5I\) is equivalent to universal
maximum-determinant \(K_{3,3}\) frustration.  The resulting six sign
syndromes form a distance-six simplex code whose transpose constructs an
order-ten conference operator.  Selected coefficients of the determinant
sextic are exactly the four-cycle holonomies of the matching fingerprint,
so this algebraic shadow recovers the same unoriented switching class
without a Pfaffian sign.  The same operator family gives exact Slater
amplitudes, Majorana parity walls, and six-charge anomaly solutions.
We also identify the precise Clifford, exceptional-group, bad-prime, and
\(E_8\)-lattice boundaries of the construction.

The abstract deliberately uses no priority superlative.  Classical geometry
and standard physical interpretations are attributed in the introduction;
the paper-owned result is their common operator propagation theorem and its
exact consequences.

## Principal theorem spine

The formal source theorem is frozen in
notes/2026-07-31-c720-c727-operator-interface.md.  The manuscript states it
near the start in five scales.

1. **Exterior and cubic:** \(K_T=*\bigwedge^3C_T\) yields
   \(Z_T=\frac14\operatorname{diag}K_T\), with
   \(\sum_TZ_T=\sum_TZ_T^3=0\).
2. **Polar and commutator:** centered squares give the Igusa polar, while
   \(\operatorname{Pf}[D_x,C_T]=4Z_T\) and
   \(\det[D_x,C_T]=16Z_T^2\).
3. **Golden determinant:** \(Z_T=\pm10\sqrt5\det B_T(x)\); the adjugate
   gives a matrix factorization, paired small resolutions, and MCM descent.
4. **Differential adjugate:** the assembled Jacobian satisfies
   \(\operatorname{adj}\mathsf A=6Wq^{\mathsf T}\).
5. **Fermionic rigidity:** universal \(5{:}1\) matching frustration is
   equivalent to \(C^2=5I\); its six projective fingerprints form a
   distance-six simplex and generate the order-ten transpose conference
   shadow.

The Cartan, Coble, Clifford, doily, anomaly, and lattice theorems are
consequences or boundary theorems.  None is an extra hypothesis for this
spine.

## Section plan and length

The target is 72--82 pages including appendices, with 52--58 pages of main
text.

| section | pages | mathematical job |
|---|---:|---|
| 1. Introduction and propagation theorem | 5 | define the object, state the theorem, give the mechanism and novelty boundary |
| 2. Marked conference data and outer covariance | 5 | fix labels, switching, orientation, golden conjugation, and the coherent outer six-family |
| 3. Exterior, Joubert, and commutator cubics | 6 | derive the triangle cubic, Segre equations, Cartan restriction, Pfaffian, and determinant square |
| 4. Polar map and assembled adjugate | 7 | prove centered squaring, inverse polarity, boundary strata, the two kernel lines, and \(\operatorname{adj}\mathsf A=6Wq^{\mathsf T}\) |
| 5. Golden compression and determinantal geometry | 7 | prove the cross-block determinant, matrix factorization, small resolutions, MCM descent, bundle model, and double-six |
| 6. Exceptional parents and marking limits | 7 | treat the \(E_6\) first jet, affine-\(E_8\) parent, Coble restrictions, Lie-\(E_8\) marking torsor, and exact negative boundaries |
| 7. Clifford charts, doily exchange, and codes | 6 | explain the \(A_5\subset S_5\subset S_6\) obstruction filtration, outer exchange, polarity torsor, and code consequences |
| 8. Golden instruments and fermionic shadows | 8 | present the ETFs, real tomography, Slater transfer, sharp optimum, Majorana family, rank strata, outer transform, and anomaly interface |
| 9. Frustration, recovery, and the conference tower | 7 | prove the all-cut theorem, sextic/dimer equivalence, simplex decoder, transpose \(\operatorname{ETF}(5,10)\), and \(S_{10}\) shadow |
| 10. Arithmetic and lattice boundary | 5 | separate primes \(2,3,5\), prove the \(E_8\)--Hamming marking obstruction, and construct \(II_{10,10}\) |
| 11. Boundaries and open problems | 2 | state the exact order-six, Wick, theta, higher-slice, and physical limits |
| Appendix A. Classical and Platonic interfaces | 5 | cite Segre--Igusa input; record tetrahedral/octahedral separators and the bounded later-slice obstruction |
| Appendix B. Finite classifications and exact tables | 6 | place code weights, orbit distributions, rank tables, root exclusions, and normal forms |
| Appendix C. Verification and trust map | 4 | map every finite claim to its exact artifact, replay, and human reduction |

The main text may grow only by replacing an appendix proof with a clearer
conceptual proof.  Raw tables, implementation details, and platform
engineering do not enter the main count.

## Complete result-placement map

Every mathematical conclusion in C704--C710 and the C720 mechanism tests has
an assigned home.

| source | conclusion | placement |
|---|---|---|
| C704 | support lattice recovered from \( *\bigwedge^3C\); triangle diagonal and outer covariance | Sections 2--3 |
| C704 | Joubert identification and Segre equations | Section 3 |
| C704 | centered-square Segre--Igusa polarity and five-syntheme identity | Section 4 |
| C704 | commutator Pfaffian/determinant and literal Cartan restriction | Section 3 |
| C704 | cross-golden determinant and rank-one node description | Section 5 |
| C704 | adjugate matrix factorization, small resolutions, MCM/Ulrich descent | Section 5 |
| C704 | projective-bundle model and determinantal double-six | Section 5 |
| C704 | bounded degree-10--50 later-slice failure at the missing support lattice | Appendix A |
| C704 | tetrahedral and octahedral first separator feasibility | Appendix A |
| C704 | fibres at \(2,5,11,23\) and separation from cross-Gram defects | Section 10 and Appendix A |
| C705 | raw block-minor obstruction in the \([4,2]\) carrier | Section 4 |
| C705 | source and target kernel lines; minimal third/fourth compounds | Section 4 |
| C705 | assembled adjugate factorization | Section 4 |
| C705 | base lines, triple-collision planes, plane-to-line contraction, and inverse polarity | Section 4 |
| C705 | operator rank boundary at \(2,3,5\) | Section 10 |
| C705 | Yoshida \(E_6\) first-normal jet and Naruki contractions | Section 6 |
| C705 | affine-\(E_8\) mixed-potential parent | Section 6 |
| C705 | Coble \(\tau^+\) parent, \(\tau^-\) ramification shadow, and failure of ambient corank one | Section 6 |
| C705 | characteristic-zero Coble conormal scalar identity | Section 6; exact reduction in Appendix C |
| C705 | Lie-\(E_8\) stable-trivector route, \(S_6\) marking torsor, residual \(S_5\), and unordered descent | Section 6 |
| C705 | Pauli-doily \(15/10/6\) dictionary, parity code, \(R_{10}\), and naive sign-selector failure | Section 7; tables in Appendix B |
| C706 | nonsplitting of the full Clifford extension over \(S_6\) | Section 7 |
| C706 | four \(A_5\) complement classes and nonzero conference \(H^1\)-class | Section 7 |
| C706 | exact \(S_5\) boundary and two-stage obstruction filtration | Section 7 |
| C706 | six local charts, \(S_4\) overlaps, and global gluing obstruction | Section 7 |
| C706 | removal of the scalar projective multiplier | Section 7; phase table in Appendix B |
| C707 | Naimark-complementary \((6,3)\) real ETFs and real-qutrit reconstruction | Section 8 |
| C707 | failure of complex informational completeness and SIC distinction | Section 8 |
| C707 | cross-golden Kraus/Slater determinant and probability \(Z_T^2/500\) | Section 8 |
| C707 | sharp cube bound, exact \(3+3\) optimum, singular spectrum, and rank strata | Section 8 |
| C707 | middle-layer outer transform, \(1+5+5+9\) harmonics, cubic inverse, and order-two correlation immunity | Section 8 |
| C707 | balanced Majorana energies, query-optimal three-filter protocol, and implementation boundary | Section 8; circuit detail deferred to C719 |
| C707 | response/probability contrast and inverse-polar recovery | Sections 4 and 8 |
| C707 | anomaly-amplitude family, vectorlike Boolean boundary, and explicit chiral attenuated point | Section 8 |
| C708 | mixed operator realizes the exceptional outer exchange | Section 7 |
| C708 | twisted norm equation, 36 polarities, \(F_{20}\) stabilizer, and golden \(6+30\) split | Section 7 |
| C708 | incidence-code ranks, hulls, weights, intersections, and exact \(S_6\) automorphisms | theorem summary in Section 7; tables in Appendix B |
| C708 | unique binary \([[15,5,3]]_2\) CSS output, with no novelty claim | short corollary in Section 7 |
| C708 | incidence codes do not explain the \(2,3,5\) operator boundary | Section 10 |
| C709 | phase-complete Pauli--Majorana dictionary and legitimate gauge quotient | Section 8; table in Appendix B |
| C709 | conference two-graph flux survives, but no quadratic refinement or intrinsic spin structure | Section 8 |
| C709 | total-order antisymmetrization is noncanonical; three finite spectral classes | Appendix B |
| C709 | canonical chiral commutator family and uniqueness in the edge-local ansatz | Sections 3 and 8 |
| C709 | parity wall, complete rank stratification, nodal cross-golden dimers, and chiral small-resolution kernels | Sections 5 and 8 |
| C710 | explicit bare McKay--Hamming \(E_8\) isometry | Section 10 |
| C710 | no Hamming minor, no equivariant rank-eight carrier, and no unmarked \(E_8\) root subsystem in \(Q_{10}\) | Section 10; exhaustive table/tree in Appendix B |
| C710 | self-dual/isodual prime separation | Section 10 |
| C710 | hyperbolic repair \(L\oplus L^*\cong II_{10,10}\), self-adjoint exchanges, and recovery of the 36/6 polarity sets | Section 10 |
| C720 | synchronized product of six pure-spinor cells; Wick-parent claim false | short proposition and boundary remark in Section 8 |
| C720 | all-cut \(5{:}1\) frustration, universal Boolean extremality, five-cycle classification, and exact order-six boundary | Section 9 |
| C720 | six \(A_5/D_5\) fingerprints, distance-six simplex, two-error correction, and minimal three-sign identification | Section 9 |
| C720 | transpose \(\operatorname{ETF}(5,10)\), \(R^{\mathsf T}R=6I+2S_{10}\), and order-ten conference shadow | Section 9 |
| C720 | order-ten failure of universal extremality and 36 extremal cuts | Section 9 boundary; sequel C729 owns classification |
| C720 ej | determinant-square reverse faithfulness and exact \(W=0\) ten-node base locus | Section 9 |
| C720 ej2 | sextic \((2,2,1,1)\)-coefficients equal dimer four-cycle holonomies | Section 9 |

No mathematical conclusion is assigned only to an evidence supplement.
Appendix C contains verification metadata, not substitute theorem statements.

## Dependency graph

\[
\begin{array}{ccccc}
C^2=5I
&\longrightarrow& *\bigwedge^3C
&\longrightarrow& Z\in\mathrm{Segre}\\
\downarrow &&&& \downarrow\ \mathrm{centered\ square}\\
[D_x,C]
&\longrightarrow& \operatorname{Pf}=4Z,\ \det=16Z^2
&& W\in\mathrm{Igusa}\\
\downarrow && \downarrow && \downarrow\\
B_x
&\longrightarrow& \det B_x,\operatorname{adj}B_x
&\longrightarrow& \text{resolutions/MCM}\\
\downarrow &&&&\\
\text{Slater/Majorana}
&\longrightarrow& K_{3,3}\text{ frustration}
&\longrightarrow& R_{6\times10}\longrightarrow S_{10}.
\end{array}
\]

The differential branch is

\[
 Z\longrightarrow dZ=\mathsf A
 \longrightarrow
 \operatorname{adj}\mathsf A=6Wq^{\mathsf T},
\]

which supplies the \(E_6\), Coble, and inverse-polar interfaces.  The
Clifford/doily branch tracks the two six-point actions and their failure to
glue.  The lattice branch begins with the doily \(R_{10}\) code and ends in
the hyperbolic double.  These branches explain or bound the central theorem;
they do not prove the Segre or Pfaffian identities.

## Human-proof plan

1. Derive triangle holonomy from the middle exterior operator and identify
   the signed outer module.  Import only the classical Joubert--Segre
   relation after fixing one coefficient.
2. Expand the commutator Pfaffian by complementary triples.  This proves the
   central operator identity before any physical interpretation.
3. Split by the golden projectors and take determinants.  The adjugate,
   small resolutions, MCM sheaves, and chiral kernels then follow from one
   determinantal presentation.
4. Derive the two null directions of \(dZ\) from congruence invariance and
   the differentiated Segre equation.  Rank four plus one coefficient forces
   the assembled adjugate.
5. Use the same operator on the Boolean layer.  A five-vertex graph lemma
   proves the all-cut conference characterization; outer two-transitivity
   proves the simplex Gram matrix.
6. Read selected sextic coefficients as four-cycle holonomies.  This gives
   the direct determinant/dimer reconstruction equivalence.
7. Treat exceptional parents, Clifford charts, incidence codes, and lattices
   only after the common operator proof is complete.

Each proof begins with its conceptual reduction.  Finite computation may
fix a scalar, verify a bounded orbit table, or close an explicitly finite
exclusion; it may not carry Steps 1--6.

## Novelty matrix and permitted language

| claim family | established background | paper-owned statement | permitted language |
|---|---|---|---|
| Joubert/Segre/Igusa | signed outer covariant, Segre equations, centered-square duality | lift from \( *\bigwedge^3C_T\) and common commuting diagram | “operator realization”; no priority claim |
| Pfaffian/Cartan | Pfaffian algebra and Cartan cubic restriction formalism | \(\operatorname{Pf}[D_x,C_T]=4Z_T\) for the same marked family | “literal restriction” |
| determinantal geometry | standard \(3\times3\) determinant, small resolutions, Ulrich/MCM theory | golden cross-block, conjugate pair, and descent with \(J^2=5I\) | “the operator produces” |
| differential adjugate | rank-\(n-1\) adjugate lemma and classical polar geometry | assembled cross-golden response factorization | “we prove”; no “first” |
| exceptional parents | Naruki/Yoshida, Coble, stable trivector, and McKay theories | exact restriction, scalar, marking, and obstruction interfaces | “parent” or “boundary,” not “new sister” |
| Clifford/doily | two-qubit Clifford extension, doily, standard CSS code | conference \(H^1\)-class, gluing obstruction, and operator outer exchange | “selected by the marking” |
| ETF/tomography | conference ETFs, Naimark complements, frame reconstruction | coherently signed transfer determinant and six-protocol polar response | “operational realization” |
| free fermions | Slater determinants, Majorana Pfaffian parity, matchgate cells | golden family, sharp optimum, synchronized cells, and frustration theorem | “exact finite model,” not a phase-of-matter claim |
| anomaly equations | \(\sum q_i=\sum q_i^3=0\) | golden amplitude parametrization and Boolean/chiral boundary | “same equations”; no gauge-theory construction |
| dimer/syndrome | determinant expansion and coding bounds | all-cut equivalence, six-simplex code, sextic coefficient conversion, and \(6\to10\) shadow | “we classify/prove”; priority remains unaudited |
| \(E_8\)/lattice | McKay and Hamming \(E_8\), hyperbolic doubling | exact incompatibility and \(II_{10,10}\) repair of the marked sister exchange | “obstruction and replacement” |

The current audits license accurate attribution and the descriptive title.
They do not license “new,” “first,” or an absence-of-prior-work claim for the
full synthesis.  Any such language requires a later claim-level audit under
the literature conventions.

## Proof, computation, and Lean boundary

### Human or cited proof required in the text

- the central propagation theorem and all covariance statements;
- the determinantal small-resolution and MCM consequences;
- the two kernel lines and assembled adjugate;
- the all-cut conference characterization and sextic/dimer equivalence;
- the distinction among orientation, switching, golden conjugation, and
  projective scaling;
- every negative scope statement used to organize the paper.

### Exact computation retained as finite evidence

- orbit, rank, weight, and hull tables in C705--C708;
- the Coble conormal polynomial reduction and displayed scalar;
- the bounded later-\(E_8\) census and Platonic transvectant ranks;
- the six order classes for noncanonical antisymmetrization;
- the \(R_{10}\) minor census and \(Q_{10}\) root-exclusion tree;
- the \(2^{10}\) signing distribution, determining cut families, and
  explicit \(S_{10}\)-to-Paley switch.

Each finite claim must state its domain, symmetry reduction, stopping
criterion, exact arithmetic, and independent replay or the reason none is
available.  Appendix C points to committed source bundles and records hashes.

### Lean

The existing C712 package formalizes the sub-700 source interface, not the
post-700 propagation theorem.  The Golden paper therefore makes no blanket
“verified in Lean” claim.

The best bounded formalization targets are:

1. commutator Pfaffian and determinant from triangle coefficients;
2. centered-square identities and the \(W=0\) node locus;
3. the five-cycle proof of the all-cut conference theorem;
4. the sextic coefficient/four-cycle identity; and
5. elementary switching reconstruction.

Classical Segre--Igusa geometry, Coble duality, exceptional compactifications,
MCM sheaf descent, and lattice root exclusion remain human/citation or exact
finite arguments.  No finite certificate or Lean theorem is allowed to
replace the conceptual proof spine.

## Cross-paper independence map

| source | what Paper IV may import | what Paper IV does not do |
|---|---|---|
| Paper I | after C727, a theorem recovering a marked or partially marked conference class from syndrome data | edit Paper I, make its proof depend on Paper IV, or suppress residual torsors |
| Paper III | the arithmetic--harmonic provenance of the source class \(([C],[Z_C])\), including any C730 strengthening | extract or relocate its exposition, edit its review-facing source, or make the propagation theorem depend on that provenance |
| C704--C710 reports | frozen theorem interfaces, proofs, computations, and exact boundaries | mutate the source packages or reassign their conclusions to a Clebsch manuscript |
| C715--C719 successors | later results only after their interfaces freeze | reserve unsupported claims or create dependencies on unfinished work |

Paper IV states its main theorem on an abstract fully marked presentation.
Thus it is logically complete without Papers I or III.  Provenance results
become corollaries of the form “this source supplies the marked input.”  No
Clebsch manuscript is changed by C720, and no post-review relocation is
recommended before a stable Golden draft exists.

## Paper-root and verification gate

The admitted root contains:

- papers/golden-operator/golden_operator.tex — title, abstract, marked source,
  principal theorem, and proof roadmap;
- papers/golden-operator/README.md — authority and boundary;
- papers/golden-operator/Makefile — isolated manuscript build;
- papers/golden-operator/verification/README.md — paper-owned trust policy and
  import ledger.

No computational statement enters the manuscript merely because its source
report exists.  The verification ledger must map it to an exact committed
bundle before paper-facing use.

## Acceptance and mystery ledger

- **Settled:** every C704--C710 conclusion has a main-text or appendix home.
- **Settled:** the theorem order is operator-first; exceptional and physical
  readings are consequences, not parallel motivations.
- **Settled:** the novelty language is proportionate to the completed audits.
- **Settled:** Paper III remains unchanged and logically independent.
- **Settled:** the manuscript root and paper-owned verification gate are
  admitted.
- **Settled by the post-gate ej pass:** the direct sextic/dimer coefficient
  bridge is promoted into the abstract; it is the shortest statement showing
  that the algebraic and fermionic branches are one construction.
- **Settled by the post-gate tt pass:** Sections 6, 7, and 10 are
  consequence/boundary sections that a reader may skip without losing the
  proof of the propagation theorem.  Exceptional parents do not become
  hidden hypotheses.
- **Open, owned by C727:** descent and reverse recovery from Paper I's exact
  input hierarchy.
- **Open, owned by C728:** intrinsic geometry of the synchronized spinor
  product.
- **Open, owned by C729:** functorial meaning of the \(6\to10\) conference
  shadow and its 36 extremal cuts.
- **Open, owned by C715--C719:** optional strengthenings; none blocks the
  present paper.
- **No architecture mystery remains.**  The remaining work is theorem prose,
  source-level citation verification, and the already allocated mathematical
  successors.

**Vibe check:** the portfolio is large but no longer shapeless.  One operator
proof carries the paper, and the placement ledger prevents the exceptional,
physical, and computational branches from competing with it.
