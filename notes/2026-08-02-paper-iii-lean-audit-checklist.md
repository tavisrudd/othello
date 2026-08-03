# Paper III Lean audit checklist

**Lane:** `clebsch`

This checklist records the repair obligations found by reviewing every Paper
III formal commit from 2026-08-01 onward together with the unfinished
four-shadow worktree.  A box may be checked only after the stated evidence is
committed.

## Build and lifecycle integrity

- [ ] Remove every direct `nix ... lake` invocation from the Paper III replay
  programs.  Repository validation must enter through the guarded Lean
  wrappers and consume a supplied, disk-backed axiom log.
- [ ] Require an explicit source-only mode or an explicit axiom log; never
  print a full-replay pass when no live gate output was checked.
- [ ] Reopen C815 in the lane handoff and task card until its source, focused
  gate, axiom audit, manifest, and paper-local replay are terminal green.
- [ ] Keep the gate, verifier, manifest, axiom report, task report, and source
  in coherent validated commits; do not land a failing proof or placeholder
  evidence.
- [ ] Record exact guarded run directories and terminal results in the C815
  report.  A wrapper returning before `result.yaml` exists is not success.

## Pinned formal closure

- [ ] Pin every project-owned file in the transitive import closure of
  `RelativeConicArcs.Gates.ClebschPassages`.
- [ ] Pin every project-owned file in the transitive import closure of
  `RelativeConicArcs.Gates.ClebschGoldenReturn`.
- [ ] Pin each replay verifier itself and reject verifier drift.
- [ ] Make the verifier scan the complete pinned closure for `sorry`, explicit
  axioms, unsafe declarations, workflow identifiers, and forbidden scholarly
  status prose.
- [ ] Verify that every declaration in a claim row belongs to its stated main
  or supplemental gate; reject duplicate or unclassified supplemental entries.
- [ ] Correct OPER-3 and OPER-4 so `signedTriangle_sq`,
  `triangleSign_four_point`, and `switch_eq_reconstructed_triangleSign` are
  assigned to the gate that actually audits them.

## Aligned-design API and claims

- [ ] State exactly that `normalizedSevenSignature_injective` concerns the
  normalized seven-point data type.
- [ ] State exactly that `global_agreement_of_common_seven_restrictions` is a
  conditional overlap theorem whose co-containment and normalization inputs
  remain external.
- [ ] Do not call `selectedQueryCount_eq` a proved family cardinality unless a
  query family, distinctness theorem, and cardinality theorem are formalized.
- [ ] Do not call `sixPointAnchor_testCount` deterministic anchor discovery;
  separate the numerical `Nat.choose 6 3 = 20` identity from the external
  Ramsey existence input.
- [ ] Synchronize the C799 task card, handoff, formal map, and report with those
  exact strengths.
- [ ] Add missing public documentation for the three balanced-cut constants.

## Four-shadow weighted converse

- [x] Replace the matrix-expanded pair-by-pair mixed-difference proof with a
  reducible coefficient evaluator and a symbolic monomial-extraction bridge.
- [x] Remove the local heartbeat and recursion-depth overrides.  The twelve
  labelled cubic identities are now separate declarations, each within the
  default elaboration budget.
- [x] Keep `triangleSign` opaque during coefficient extraction and isolate the
  small label normalization from polynomial matrix algebra.
- [x] Prove translation invariance implies every pair moment through the new
  bridge, then reuse the existing pair-moment/matrix-square API.
- [x] Make every public docstring agree exactly with its hypotheses, including
  the theorem whose scalar-square conclusion does not require symmetry; that
  docstring now states that symmetry and a vanishing diagonal are unused.

## Four-shadow normalized classification

- [x] Replace three repeated whole-domain native decisions with one reducible
  orientation classifier and symbolic transport theorems.  The classifier is
  one closed decidable statement over the `2^10` signings; the orientation
  dichotomy, the two fibre projections, and their disjointness are derived
  from it symbolically.
- [x] Derive the labelled six-code fibres from the pentagon structure, or state
  and audit the finite classification as the exact proof step rather than a
  corroborating replay.  The finite classification is the exact proof step and
  is disclosed as such in the module header and the focused gate.
- [ ] Formalize root normalization by switching for arbitrary scalar sign
  matrices, or narrow every objective and completion claim to normalized
  scalar sign matrices.
- [ ] Formalize the promised uniqueness of the conference switching class, or
  remove that strength from task and handoff claims.
- [x] Explain in the module header the native domain, kernel bridge, normalized
  scope, and the external rank-14 weighted-Jacobian boundary.  The header now
  also states that compiled evaluation introduces a declaration-local axiom
  rather than a named global one.
- [x] Make the focused manifest disclose every native terminal, including the
  orientation dichotomy.  The manifest names the one compiled-evaluation
  theorem and the four declarations that inherit its declaration-local axiom.

## Referee-facing prose

- [ ] Qualify the Petersen kernel and Gram definitions as algebraic operators
  encoding the two orbit values; keep the face-axis addition theorem and
  geometric identification visibly external.
- [ ] Add a docstring for `legendreSix_one`.
- [ ] Audit every touched module and gate for workflow vocabulary, status
  prose, missing public documentation, overstated strength, and unresolved
  repository-local references.

## Corrections found while validating

- [x] `shadowCoefficient012` carried the sign of the lower-left block
  determinant rather than of the cubic coefficient it is documented to be, so
  both orientation predicates named the opposite fibre.  The definition and its
  docstring are corrected, and an exact recomputation of the twelve balanced
  signings is committed with the report.

## Acceptance evidence

- [x] Single-file elaboration of each changed source reaches a terminal green
  `result.yaml` through `lean/scripts/guarded-lean`.
- [x] The focused four-shadow gate elaborates and its complete `#print axioms`
  output matches the committed report.
- [ ] Both Paper III gates pass through the supported guarded queue, followed
  by exact-target trace confirmation.
- [ ] Paper-local source, axiom-log, statement-identity, trust-map, and release
  replays pass without invoking Lean outside the guarded build window.
- [ ] Source hashes, verifier hashes, axiom-report hashes, declaration maps,
  task cards, handoff, and reports agree with the final committed tree.
- [ ] Run the required `ej` and `tt` closeout, settle or assign every mystery,
  and complete the C815 task lifecycle only after all preceding boxes pass.
