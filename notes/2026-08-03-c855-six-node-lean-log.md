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
* The Section 9 pin block still names the pre-six-node export state; see the blocked-export
  section below for why it cannot be refreshed yet.
* `papers/clebsch-rigidity/verification/build_trust_manifest.py` still lists
  `RelativeConicArcs.PaperIOrientationTraceDual.hassettTschinkel_six_nodes_of_traceDual` in its
  `TERMINALS` orientation group and does not list the two new node theorems; its `parse_axioms`
  raises on any mismatch with the audit, so `trust_manifest.json` cannot be regenerated until that
  list is edited. That edit belongs with the manuscript rewrite and the full release replay
  documented in `papers/clebsch-rigidity/verification/README.md` (regenerate statement identity and
  trust manifest, refresh `verify-release-output.json` with `--update-output`, rerun
  `build_trust_manifest.py`, then the clean-source release run). Left untouched here.

## Export refresh attempt: blocked upstream of the q11 package (2026-08-03)

Goal: republish the standalone q11 certificate package so the manuscript's Section 9 pin block
names an export whose aggregate gate carries the 52-terminal audit, and retire the pinned state in
which `hassettTschinkel_six_nodes_of_traceDual` is still an axiom-bearing terminal.  The refresh was
not performed.  Nothing was written to either export tree.

### Current pinned state (unchanged)

Manuscript `papers/clebsch-rigidity/clebsch_rigidity.tex`, Section 9:

| Pinned artifact | Value |
|---|---|
| certificate-package commit | `09d8e174880e7370966da788da3c5d303df8af4f` |
| base-library commit        | `570086982b26075a71a331a81bb1b519e9a27e7f` |
| aggregate gate digest      | `c5d532dbd79dcb2eef602ced85105b72943a0a1af05de11c3c008c1ed9a1d747` |
| Mathlib commit             | `571b8a8e54219b4d393f75f4b8653fac08197fcc` |

The certificate package's `MANIFEST.json` records `source_commit`
`81bae5e0eb02c26992f21b71808ef74a22e3b406` (its own gate commit) and pins the base library at the
same `570086982b…` revision in `lakefile.toml` and `lake-manifest.json`.  The pinned base revision
is an ancestor of the base library's public `origin/main`.

### Why the refresh cannot proceed

1. **The changed declarations live in the base library, not in the certificate package.**  The
   six-node change edits `RelativeConicArcs/PaperIOrientationNodes.lean` and
   `RelativeConicArcs/PaperIOrientationTraceDual.lean`, both of which the certificate package
   obtains from its pinned base dependency; the package itself ships only the q11 tables and the
   aggregate gate.  At the pinned base revision — and also at the base checkout's current local
   head — `PaperIOrientationTraceDual` still declares
   `hassettTschinkel_six_nodes_of_traceDual` and `PaperIOrientationNodes` contains neither
   `derivative_crossGoldenDeterminantLine_eval` nor
   `singularPoints_crossGoldenDeterminant_eq_axisClasses`.  The new gate's two added
   `#print axioms` lines therefore cannot elaborate against any published base revision.

2. **The base library must be republished first, and its local commits are unpublished.**  The
   canonical base checkout is eight commits ahead of its public remote, and even that head predates
   the six-node change (its `PaperIOrientationNodes.lean` differs in content from the authority
   file).  Because the certificate package resolves its dependency by Git URL and revision, no
   re-pin can build until a base revision containing the new theorems exists on the public remote.
   Publishing is out of scope for this task.

3. **No guarded procedure targets the certificate package.**  The companion exporter
   `lean/scripts/lean-companion-export.py` materializes an area unit onto the canonical base
   repository only: its canonical-base default is the base checkout, and it explicitly refuses any
   suffixed `finitegeom-*` clone as authority or output.  The tracked export configurations under
   `lean/trust/export/` cover only the Golden companion, and `lean/trust/areas/` has no Paper I or
   Clebsch area.  There is consequently no guarded entry point that can regenerate the certificate
   package's module set, `MANIFEST.json`, or its axiom audit.  Per the Lean guide, the correct
   action when a guarded procedure cannot target a root is to stop.

### What a future refresh must do, in order

1. Adopt the six-node change into the canonical base library through the guarded companion-export
   path (which requires an area configuration that does not yet exist for Paper I), then publish
   the resulting base revision.
2. Re-pin the certificate package's `lakefile.toml`, `lake-manifest.json`, and `MANIFEST.json`
   dependency revision to that published base commit.
3. Copy the authority's aggregate gate into the package.  The authority's current gate file has
   SHA-256 `4bc2adb5f64df0a0f3490a948020fbe200d9169d6c08d232a0ed2879e7ab6319`; the historical export
   gate is a byte-identical copy of the authority's pre-change gate, so a plain copy is the expected
   transformation and the new digest is the value the manuscript must pin.
4. Rebuild the aggregate gate in the package under the owning build window and regenerate
   `verification/clebsch_rigidity_trust/axiom-audit.txt` from that build's standard output; refresh
   `MANIFEST.json` module digests and `source_commit`.
5. Only then update the manuscript pin block and rerun the release chain in
   `papers/clebsch-rigidity/verification/README.md`: statement identity, trust manifest against both
   roots, `--update-output`, PDF rebuild, and the clean-source release run.

### Authority state after this attempt

No git state was changed in the authority.  The only authority edit is this log section plus the
cross-reference added to the preceding section.
