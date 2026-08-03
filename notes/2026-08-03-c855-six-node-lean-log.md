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

## Aggregate gate and audit refresh (2026-08-03, later session)

* `lean/scripts/lean-build-queue.py run RelativeConicArcs.Gates.ClebschRigidityTrust --profile
  single --threads 1 --cores 20-23` — run `~/.cache/othello-lean-build/run-20260803-201132-5b9abc76`,
  state `success`: `built RelativeConicArcs.Gates.ClebschRigidityTrust` (24:29 wall, 11.5 GB peak
  RSS) followed by `gate-passed <aggregate>` (the trace-only exact-target confirmation).
* `lean/scripts/guarded-lean RelativeConicArcs/Gates/ClebschRigidityTrust.lean` — `exit=0`,
  156 stdout lines. That stdout is copied verbatim to
  `lean/verification/clebsch_rigidity_trust/axiom-audit.txt`, per the audit convention that the
  file is the raw standard output of a successful gate elaboration.
* Counts: the gate now issues 52 `#print axioms` directives (previously 51 — one deleted terminal
  removed, two new ones added), and the audit contains 52 declaration rows in the same order.
* Audit content checks: no `sorry`/`sorryAx`, no native-execution or oracle axiom, and the only
  axioms outside `propext`/`Classical.choice`/`Quot.sound` remain the two classical Dye
  assumptions `RelativeConicArcs.ClebschDye.dye1991_brianchon_bound` and
  `RelativeConicArcs.ClebschDye.dye1991_equality_classification`. Both
  `derivative_crossGoldenDeterminantLine_eval` and
  `singularPoints_crossGoldenDeterminant_eq_axisClasses` report exactly
  `[propext, Classical.choice, Quot.sound]`.
* `lean/scripts/paper-facts.py check` and `lean-trust-spine.py check` report only pre-existing
  cross-lane drift (stale facts artifacts, citation-title drift, foreign undeclared axioms); no
  finding names the Paper I gate, its terminals, or the audit artifact.

## Left for the owning gate build window

* The manuscript passages `papers/clebsch-rigidity/clebsch_rigidity.tex` around lines 1370 and
  1466 still attribute singular-locus completeness to the cited proposition; they should be
  rewritten to cite the proved Lean theorem, with Hassett–Tschinkel demoted to context.
* `papers/clebsch-rigidity/verification/build_trust_manifest.py` still lists
  `RelativeConicArcs.PaperIOrientationTraceDual.hassettTschinkel_six_nodes_of_traceDual` in its
  `TERMINALS` orientation group and does not list the two new node theorems; its `parse_axioms`
  raises on any mismatch with the audit, so `trust_manifest.json` cannot be regenerated until that
  list is edited. That edit belongs with the manuscript rewrite and the full release replay
  documented in `papers/clebsch-rigidity/verification/README.md` (regenerate statement identity and
  trust manifest, refresh `verify-release-output.json` with `--update-output`, rerun
  `build_trust_manifest.py`, then the clean-source release run). Left untouched here.
