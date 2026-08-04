# Paper III formalization gap inventory

**Lane:** `clebsch`
**Date:** 2026-08-03
**Task:** C815 (continuing), feeding C800/C816/C823/C824

## Standard applied

The measuring stick is the Paper I referee-artifact standard recorded in
`notes/clebsch-tasks/c855-paper-i-lean-referee-artifact-remediation.md` and the
Paper II closure standard recorded in
`notes/2026-08-02-c856-paper-ii-lean-standards-closure.md`:

1. every mathematical assertion in the manuscript maps to a kernel-checked Lean
   declaration, recorded in a bidirectional correspondence map;
2. no public gate terminal carries a native-execution axiom, an ad hoc project
   axiom, a `sorry`, or a trusted-execution boundary;
3. no conclusion-bearing hypothesis is assumed where the manuscript says it is
   derived;
4. every scholarly-public declaration in the complete project-owned transitive
   closure carries a self-contained docstring, and every module comment agrees
   exactly with the elaborated statement;
5. the trust manifest, formal map, axiom report, and manuscript prose describe
   the same surface, with no row overstated and none understated.

Author instruction governing this pass: gaps are closed by strengthening the
Lean side. No manuscript claim is narrowed, reworded, or demoted to make the
formal surface agree with it, and Lean comments are brought into line with the
paper rather than the reverse. Structural, human-readable proofs are preferred
to finite certificates; where a finite check is unavoidable it must be
compressed behind a proved structural reduction.

## Present formal surface

Three gates carry Paper III: `RelativeConicArcs.Gates.ClebschPassages` (43
audited terminals), `RelativeConicArcs.Gates.ClebschGoldenReturn` (28), and
`RelativeConicArcs.Gates.FourShadowRecognition` (16). Their tracked axiom
reports are `papers/clebsch-passages/verification/passages_axioms.txt`,
`golden_return_axioms.txt`, and `four_shadow_axioms.txt`.

Every one of the nine manuscript claim rows is recorded as
`partial mechanism; no full row claim`, and the manifest's own summary states
`partial mechanisms; no complete manuscript row claimed`. Under the standard
above this is the headline gap: Paper III currently claims *no* fully
formalized manuscript row, where Paper I requires all of them.

## Gap class A — native-execution axioms at public terminals

Twenty-seven of the eighty-seven audited terminals depend on a
`_native.native_decide.ax` declaration-local axiom. Paper I's condition 6
forbids this at any terminal. Counted from the tracked reports:

| gate | terminals | carrying a native axiom |
|---|---|---|
| `ClebschPassages` | 43 | 10 |
| `ClebschGoldenReturn` | 28 | 13 |
| `FourShadowRecognition` | 16 | 4 |

Passages terminals: `GoldenQuadraticCharacters.exchanger_eq_reflection_mul`,
`GoldenQuadraticCharacters.exchanger_reflection_factorization`,
`GoldenQuadraticCharacters.two_not_square_zmod11`,
`ClebschGoldenConference.conferenceMatrixOver_sq`,
`ClebschInvariantCubic.eq_gauntCoefficient_mul_sigmaThree`,
`AlignedTwoGraph.anchorSignature_eq_false_iff_balanced`,
`AlignedTwoGraph.pairSignature_classification`,
`AlignedTwoGraph.normalizedSevenSignature_injective`,
`ClebschPassagesCorrespondence.normalizedMarked_chart_value`,
`ClebschPassagesCorrespondence.markedValue_determines_gauntCoefficient`.

Golden-return terminals: `ClebschGoldenConference.conferenceMatrix_sq`,
`conferenceMatrix_transpose`, `conferenceMatrixOver_sq`,
`conference_triangleSigns`, `conference_triangleCubic_translate`,
`ClebschMiddleExterior.hodgeMatrix_sq`, `middleExterior_sq`,
`middleExterior_diagonal`, `middleExterior_mod_two_eq_one_iff`,
`commonIntersectionOneNeighbors_eq`,
`commonIntersectionOneNeighbors_eq_zero_iff`,
`ClebschGoldenDescent.conference_mul_degreeTenComparison`,
`degreeTenComparison_det`.

Four-shadow terminals: `cubicsProportional_four_of_sixTests`,
`cubicsProportional_neg_four_of_sixTests`,
`exists_nonzero_cubicsProportional_iff_conferenceSquare`,
`exists_nonzero_cubicsProportional_smul_iff_conferenceSquare`, all inheriting
the single classifier axiom
`FourShadowRecognition.sixTestCode_classification_of_balanced._native.native_decide.ax_1_6`.

Route. These divide into three kinds, and none needs the manuscript weakened:

- *Literal finite matrix identities* (`conferenceMatrix_sq`,
  `conferenceMatrix_transpose`, `hodgeMatrix_sq`, the middle-exterior rows,
  `degreeTenComparison_det`). The identity is a fixed integer matrix equation;
  the correct replacement is kernel reduction with the entries expanded through
  `Matrix.ext` and `Fin` case analysis, or, better, the structural proof the
  manuscript already gives — the tight-frame Gram identity for the conference
  square and Hodge complementation for the middle exterior. Structural first,
  kernel `decide` only where the structural route needs a bounded residue.
- *Finite classification over a parameter space* (`pairSignature_classification`,
  `anchorSignature_eq_false_iff_balanced`, `normalizedSevenSignature_injective`,
  the four-shadow classifier). The Lean guide's own rule applies: run the
  exhaustive predicate on the small parameter space and transport symbolically,
  and prefer the structural argument that the human proof already supplies. For
  the four-shadow classifier that structural argument exists in the frozen human
  proof — pentagon-stabilizer parity splitting the twelve labelled pentagons
  into two sets of six.
- *Small arithmetic leaves* (`two_not_square_zmod11`). Kernel `decide` over
  `ZMod 11` is available and cheap; native evaluation is unnecessary.

## Gap class B — manuscript clauses with no formal counterpart

Taken verbatim from the `excluded` fields of
`papers/clebsch-passages/verification/passages_formal.json` and the trust
manifest's `formal_coverage.boundary`, with the structural route proposed for
each.

| row | excluded clause | proposed route |
|---|---|---|
| ARITH-1 | Hitchin incidence geometry, global Stein algebra, branch divisor, geometric Clebsch-chart correspondence | formalize the Stein algebra as the rank-one reflexive trace-split extension with `z^2 = 5J0`; the pinching/conductor mechanisms already exist, so the gap is the algebra presentation and the chart-descent diagram, not new mathematics |
| ARITH-2 | geometric identification of the complete Hitchin fibre; general spinor-norm API | formalize the reduced local fibre as the residue algebra of the pinching at `xyz`, and give the spinor class a definition-level API rather than a displayed witness |
| ORIENT-1 | scheme normalization of the incidence pullback; geometric marked identification | formalize the two-component normalization statement relative to the explicit marked datum the manuscript already conditions on |
| OPER-1 | coherence of the outer six-family; determinant-square identity; cross-golden determinant comparison | the determinant square follows from the Pfaffian identity already formalized, by `det = Pf^2` on the bracket matrix; the cross-golden comparison is a block determinant over `Q(sqrt 5)` |
| OPER-2 | outer matching-frame identification, Joubert and Segre equations, diagonal Clebsch section, Segre--Igusa polar map | the Segre equations `sum Z = sum Z^3 = 0` are symbolic identities in the six outer cubics and should be proved directly; the literature attribution stays as attribution, not as the proof |
| OPER-3 | cross-block spectrum formula, closed-walk count, inclusion-rank descent, higher-order Ramsey exclusion, aligned-design consequences | formalize the cross-block spectrum and the signed closed-four-walk count symbolically; the Ramsey input is `R(3,3)=6`, which is a short structural pigeonhole proof, not a citation |
| OPER-4 | classical Ramsey theorem; finite-set extension to a common seven-set; normalization from arbitrary labels to the cut API; identification of the determinant-minus-three family with the aligned family | all four are formalizable: `R(3,3)=6` structurally, the seven-set extension by the existing overlap-consistency theorem, and label normalization by an explicit switching/relabelling transport |
| HARM-1 | face-axis geometry, spherical addition theorem, abstract `A5` comparison | the addition theorem is the standard zonal-harmonic identity; the face-axis labelling is a finite explicit datum that should be defined structurally and then verified once |
| HARM-2 | invariant-line input for the geometric spherical cubic; raw spherical moment | the invariant-line argument is the uniqueness of an `A5`-equivariant cubic line, provable from the existing eigenspace results |

## Gap class C — claims recorded as strengths without matching statements

These are the items the earlier audit checklist proposed to close by narrowing
the claim. Under the current instruction they are closed by proving the claim.

1. `AlignedTwoGraph.selectedQueryCount_eq` is presented as a family
   cardinality. Formalize an explicit query family, its distinctness, and its
   cardinality `3n^2 - 23n + 45`.
2. `AlignedTwoGraph.sixPointAnchor_testCount` mixes the arithmetic identity
   `Nat.choose 6 3 = 20` with deterministic anchor discovery. Formalize the
   existence half — every two-colouring of the triangles on six points contains
   an aligned anchor — from a Lean proof of `R(3,3) = 6`.
3. `AlignedTwoGraph.normalizedSevenSignature_injective` is stated only for the
   normalized seven-point data type while the manuscript's Theorem
   `thm:aligned-faithfulness` quantifies over every two-graph on at least seven
   labelled vertices. Formalize the normalization transport so the general
   statement is the theorem.
4. `global_agreement_of_common_seven_restrictions` leaves co-containment and
   normalization external. Formalize the finite-set extension so the theorem is
   unconditional in the manuscript's quantifier range.
5. Four-shadow: root normalization by switching is proved only for normalized
   scalar sign matrices, and uniqueness of the conference switching class is
   claimed but unproved. Both are to be formalized.
6. The rank-14 local weighted Jacobian rigidity calculation is an external
   rational certificate. It backs C809, which is not yet in the manuscript;
   before C816 promotes it, it needs either a structural rank argument or a
   Lean-checked rational rank computation compressed behind a proved reduction.

## Gap class D — documentation and ledger alignment

- The manuscript's reproducibility section states the Lean coverage in prose;
  the trust manifest, the three formal maps, and the module headers must state
  exactly the same surface. Any disagreement is repaired on the Lean side.
- Module headers currently describe native evaluation as an accepted internal
  method. Once class A is cleared, every such sentence must be rewritten to the
  actual method, in the same change as the proof.
- The claim map assigns `signedTriangle_sq`, `triangleSign_four_point`, and
  `switch_eq_reconstructed_triangleSign` to gates that do not audit them; the
  assignment must match the gate that actually exports each terminal.
- No Paper III module may cite an internal record; the reference-direction rule
  is checked as part of the closure sweep, not only on changed files.

## Ownership and permission map

Reverse-import closure over `lean/RelativeConicArcs` shows which Paper III
modules are shared with other papers' gates:

| module | gates that depend on it | edit status |
|---|---|---|
| `ClebschGoldenConference` | `ClebschPassages`, `ClebschGoldenReturn`, `FourShadowRecognition`, `ClebschRigidityTrust`, `GoldenCubicNodes`, `GoldenProofSpine` | shared with Paper I and the golden-operator lane — needs explicit author permission and widened validation before any edit |
| `ClebschTwoGraph` | `ClebschPassages`, `ClebschGoldenReturn`, `ClebschRigidityTrust` | shared with Paper I — same condition |
| `AlignedTwoGraph`, `FourShadowRecognition`, `ClebschMiddleExterior*`, `GoldenQuadraticCharacters`, `ClebschInvariantCubic`, `ClebschGoldenDescent`, `PetersenHarmonicKernel`, `ClebschPassagesCorrespondence`, `MarkedClebschBridge` | Paper III gates only | Paper III owns them |

Work order therefore starts inside the Paper III-exclusive modules.

## Priority order

1. Four-shadow classifier: replace compiled evaluation by the pentagon-parity
   structural proof, clearing the whole four-shadow native class and C815's own
   trust boundary.
2. `AlignedTwoGraph` class A and class C items, including `R(3,3)=6` and the
   general-quantifier faithfulness statement, since they carry OPER-4.
3. `ClebschMiddleExterior*` and `ClebschGoldenDescent` literal-matrix
   terminals, replaced by the Hodge-complementation and Gram routes.
4. `GoldenQuadraticCharacters`, `ClebschInvariantCubic`, and
   `ClebschPassagesCorrespondence` leaves.
5. Shared `ClebschGoldenConference` and `ClebschTwoGraph` work, after
   permission.
6. Class B geometric rows, in manuscript order.
7. Ledger reconciliation and the full gate replays.

Every step lands with a cold sub-agent referee review of the Lean change and of
the affected mathematical statement before it is committed.
