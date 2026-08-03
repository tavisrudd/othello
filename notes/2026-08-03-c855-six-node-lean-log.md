# C855 — Lean closure of the six-node transfer: working log

**Date:** 2026-08-03
**Lane:** `clebsch` (Paper I stream)
**Scope:** Lean only. Retire the assumed Hassett–Tschinkel interface in
`lean/RelativeConicArcs/PaperIOrientationTraceDual.lean` in favour of a proved theorem.

## Decision record

1. Read `lean/AGENTS.md` and `notes/2026-08-03-c855-hassett-tschinkel-transfer.md` in full.
2. **The transfer note's coverage map (§4.1) is incomplete.** It lists eight new Lean
   obligations, of which the substantial one is a rank-one classification of the cross-golden
   block. That work is unnecessary: the repository already contains a kernel-checked
   elimination of the five gradient quadrics of the centered golden cubic,
   `RelativeConicArcs.GoldenCubicNodes.nonzero_gradient_zero_iff_projective_centeredNode`,
   re-exported as
   `RelativeConicArcs.PaperIOrientationNodes.supportCubic_singularLocus_eq_frame`:
   over any characteristic-zero field, a nonzero centered five-vector has vanishing gradient
   exactly when it is a nonzero multiple of one of the six centered nodes `1 - 6 e_i`.
   The axiom audit records only `propext`/`Classical.choice`/`Quot.sound` for it.
3. Consequently the only missing link between that classification and the determinantal
   picture is the statement that the polynomial being differentiated is the determinant of the
   cross-golden block. `det_crossGoldenBlock_eq_neg_supportCubic` already gives
   `det (crossGoldenBlock t y) = - triangleCubic (conferenceMatrixOver R) y` over any
   commutative ring with a golden root, so the bridge is obtained by evaluating it over the
   polynomial ring and differentiating along one centered coordinate line — the same device
   already used by `GoldenCubicNodesBase.derivative_coordinatePolynomial_eval`.
4. Plan actually implemented:
   * new declarations in `RelativeConicArcs/PaperIOrientationNodes.lean`
     (`crossGoldenDeterminantLine`, `derivative_crossGoldenDeterminantLine_eval`,
     `singularPoints_crossGoldenDeterminant_eq_axisClasses`);
   * deletion of `HassettTschinkelProposition10` and
     `hassettTschinkel_six_nodes_of_traceDual` from
     `RelativeConicArcs/PaperIOrientationTraceDual.lean`, with the module header rewritten;
   * gate line swap in `RelativeConicArcs/Gates/ClebschRigidityTrust.lean`.
5. The Hassett–Tschinkel citation survives only as provenance inside the new theorem's
   docstring, as the transfer note recommends (§5.2).

## Elaboration evidence

All commands run from `/home/tavis/src/othello`.

* `lean/scripts/lean-build-queue.py run RelativeConicArcs.PaperIOrientationNodes
  --profile single --threads 1 --cores 20-23` — first attempt failed on an ambiguity between
  `_root_.gradient` (Mathlib) and `GoldenCubicNodesBase.gradient` inside a `simp` set; fixed by
  qualifying the name. Second attempt: `passed RelativeConicArcs.PaperIOrientationNodes`,
  trace-only aggregate gate complete
  (run `~/.cache/othello-lean-build/run-20260803-200339-166ed0f1`).
* `lean/scripts/guarded-lean RelativeConicArcs/PaperIOrientationNodes.lean` — `exit=0`.
  `#print axioms` reports `[propext, Classical.choice, Quot.sound]` for
  `derivative_crossGoldenDeterminantLine_eval` and
  `singularPoints_crossGoldenDeterminant_eq_axisClasses`.
* `lean/scripts/lean-build-queue.py run RelativeConicArcs.PaperIOrientationSymmetryCore ...` —
  passed. This covers the reverse-import closure of the edited modules inside the Paper I
  stream (`PaperIOrientationSpine`, `PaperIOrientationSymmetryCore`).

## Left for the owning gate build window

* `RelativeConicArcs/Gates/ClebschRigidityTrust.lean` was edited (one `#print axioms` line
  replaced by two) but not elaborated: its dependency closure is the full Paper I terminal set.
* `verification/clebsch_rigidity_trust/axiom-audit.txt` still names the deleted theorem. It is a
  generated audit artifact and must be regenerated with the gate.
* The manuscript passages `papers/clebsch-rigidity/clebsch_rigidity.tex` around lines 1370 and
  1466 still attribute singular-locus completeness to the cited proposition; they should be
  rewritten to cite the proved Lean theorem, with Hassett–Tschinkel demoted to context.
