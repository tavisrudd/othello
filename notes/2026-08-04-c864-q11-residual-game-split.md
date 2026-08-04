# C864 — splitting the order-eleven residual module into game-free and game halves

**Date:** 2026-08-04
**Lane:** `build-sys`
**Scope:** the base-library export defect recorded in
`notes/build-sys-tasks/c864-external-certificate-closeout-and-audit.md`. Source split only; the
base re-export and re-pin remain batched with the order-eleven externalization so the base is
regenerated once.

## The defect, confirmed exactly

`~/src/lean/finitegeom` ships `RelativeConicArcs/Q11Residual.lean` and
`RelativeConicArcs/Q11Coding.lean`, but not `RelativeConicArcs/CapGameHoleLocalization.lean` and
not `ProjectiveCap/ProjectiveCapGame.lean`. Both shipped files are byte-identical to the monorepo
sources except that the exporter dropped their `import RelativeConicArcs.CapGameHoleLocalization`
line. Each therefore names declarations it cannot see:

- `Q11Residual` used `ProjectiveBridge.ParametrizedHoleValid` (game-free) in
  `parametrizedHoleValid_iff`, and `ProjectiveBridge.isP_parametrizedHoles_iff` (normal-play
  vocabulary) in `seed_isP`.
- `Q11Coding` used `ProjectiveBridge.ParametrizedHoleValid` only, in three proofs. It has no
  game content at all.

`RelativeConicArcs/Q9Terminal.lean` is the only other monorepo importer of the game localization;
the base does not ship it, so this defect has exactly the two instances above.

## The split as landed

**New `RelativeConicArcs/ParametrizedHoles.lean`.** Holds `ParametrizedHoleValid`, moved verbatim
out of `CapGameHoleLocalization` together with its variable and local-instance context, so the
elaborated signature and the fully qualified name
`RelativeConicArcs.ProjectiveBridge.ParametrizedHoleValid` are unchanged and no consumer reference
moved. The predicate is a plain projective-cap statement about `A ∪ T.map e` and mentions no game.

The predicate was deliberately not added to `RelativeConicArcs/ProjectiveBridge.lean` itself, even
though that is the module owning the namespace: the bridge has 11,411 transitive dependents, 93.1%
of the project's modules, so a declaration added there invalidates nearly everything. The new leaf
keeps the invalidated set at the 161 modules downstream of `Q11Residual`, which must rebuild in any
case.

**`RelativeConicArcs/Q11Residual.lean`, game-free.** Retains the twelve-point conic
parametrization, the conic embedding and its range characterization, the determinant conflict
relation and its identification with the icosahedral graph, and both directions of the validity
dictionary — `continuation_rawArc_iff` and `parametrizedHoleValid_iff`. Its imports are now
`RelativeConicArcs.ExampleChecks.Q11`, `RelativeConicArcs.ParametrizedHoles` and
`CapGame.GraphMirror`, all of which the base already carries apart from the new leaf. The module
header no longer claims a game value.

**New `RelativeConicArcs/Q11ResidualGame.lean`.** Holds the two terminals `isP` and `seed_isP`
unchanged, in the new namespace `RelativeConicArcs.Examples.Q11ResidualGame`. It is the only
module in this family that still imports `CapGameHoleLocalization`. A distinct namespace was used
rather than extending `Q11Residual`'s: extending a sibling module's namespace is what hid the
consumers of the order-eleven decoding module, and nothing outside the module named either
terminal, so the rename costs only documentation references.

**Consumer updates.** `Q11Coding` imports `ParametrizedHoles` in place of the game localization;
`CapGameHoleLocalization` imports `ParametrizedHoles` in place of `ProjectiveBridge` and its header
now points at the predicate's new home; `RelativeConicArcs.lean` and
`RelativeConicArcs/Gates/Relconic.lean` list the two new modules, so both terminals stay inside the
relative-conic verification boundary.

**Documentation.** `lean/RelativeConicArcs/TRUST.md`, the `comp-q11-icosahedral` row of
`papers/papers-index.md`, and the auxiliary P-value paragraph of
`papers/arcs_complete_outside_conic/arcs_complete_outside_conic_proof_audit.md` now name the module
that declares each result. No manuscript LaTeX source cites either terminal.

## Validation

Single-file elaboration of `RelativeConicArcs/ParametrizedHoles.lean` through `guarded-lean`:
exit 0, 11s.

Focused build of `RelativeConicArcs.Q11ResidualGame` through the guarded queue: success, 2m19s
wall, 8.44 GiB peak, run `20260804-202446-e34c57ad`.

All nine gates reaching the residual module, built in one queued run
`20260804-202811-b2209b6c` with cores 20-23: success, with the final trace-only aggregate gate
passed.

| gate | outcome | wall | peak |
|---|---|---|---|
| `RelativeConicArcs.Gates.Relconic`                            | built           | 11:20 | 9.63 GiB  |
| `RelativeConicArcs.Gates.ArcsCompleteOutsideConic`            | built           | 3:55  | 5.07 GiB  |
| `RelativeConicArcs.Gates.ClebschGateway`                      | built           | 0:53  | 5.61 GiB  |
| `RelativeConicArcs.Gates.ClebschPaperTrust`                   | built           | 31:04 | 11.70 GiB |
| `RelativeConicArcs.Gates.ClebschReflectionArrangementDecoding`| trace-current   | —     | —         |
| `RelativeConicArcs.Gates.ClebschReplacementSpine`             | trace-current   | —     | —         |
| `RelativeConicArcs.Gates.ClebschRigidityTrust`                | built           | 21:02 | 5.34 GiB  |
| `RelativeConicArcs.Gates.ClebschTorsorRosetta`                | trace-current   | —     | —         |
| `RelativeConicArcs.Gates.ClebschWeightedAdjoint`              | trace-current   | —     | —         |

The four trace-current gates were confirmed current after the earlier targets in the same run
built their shared closure, not skipped from stale artifacts.

## The pruning is not use-checked, and fifteen more base modules are pruned

Comparing every base module's import list against its monorepo counterpart shows that the export
prunes imports from seventeen files. Two are the modules repaired here, and two more are those same
two files reported against the post-split monorepo sources. The remaining fifteen are:

| base module | import pruned |
|---|---|
| `ProjectiveCap/GridMirror.lean`                        | `ProjectiveCap.PlaneTransitivityGame` |
| `ProjectiveCap/ExtensionCount.lean`                    | `ProjectiveCap.StableFacts` |
| `ProjectiveCap/Mirror.lean`                            | `ProjectiveCap.ProjectiveCapGame` |
| `ProjectiveCap/Binary.lean`                            | `ProjectiveCap.ProjectiveCapGame` |
| `ProjectiveCap/StableFacts.lean`                       | `ProjectiveCap.PlaneTransitivityGame` |
| `ProjectiveCap/EscapeParity.lean`                      | `ProjectiveCap.Almost.OddEscape` |
| `ProjectiveCap/FrameGridBridge.lean`                   | `ProjectiveCap.PlaneAffineChart`, `ProjectiveCap.PlaneTransitivityGame` |
| `ProjectiveCap/ConicLocalization.lean`                 | `ProjectiveCap.Almost.OddEscape` |
| `ProjectiveCap/EllipticMirror.lean`                    | `ProjectiveCap.PlaneTransitivityGame` |
| `RelativeConicArcs/Certificate.lean`                   | `ProjectiveCap.PlaneAffineChart` |
| `RelativeConicArcs/ProjectiveTripleNormalization.lean` | `ProjectiveCap.PlaneAffineChart` |
| `RelativeConicArcs/Q11DyeAxioms.lean`                  | `RelativeConicArcs.SixArcConcurrenceBound` |
| `RelativeConicArcs/OddSixArcAffinePrism.lean`          | `ProjectiveCap.PlaneAffineChart` |
| `RelativeConicArcs/Gates/AMELUAggregate.lean`          | `RelativeConicArcs.AMELU.SyndromeGeometry` |
| `RelativeConicArcs/Gates/ClebschPassages.lean`         | `RelativeConicArcs.AlignedTwoGraph` |

No base module imports a module the base does not ship, so a pruned import is invisible to any
name-resolution check and shows up only as an unresolved identifier during elaboration. Whether
each of these fifteen is a genuine defect or a redundant import correctly dropped cannot be settled
by reading import lists: it depends on whether the file uses a declaration from the pruned module,
including through an opened namespace. The standalone base build is the decisive check, which is
one more reason to make it an export gate rather than a manual step.

## What the batched base re-export must do

When the order-eleven externalization re-exports and re-pins the base:

- add `RelativeConicArcs/ParametrizedHoles.lean` to the base module set;
- refresh the base copies of `Q11Residual.lean` and `Q11Coding.lean`;
- keep `Q11ResidualGame.lean` out of the base, along with `CapGameHoleLocalization.lean` and
  `ProjectiveCap/ProjectiveCapGame.lean`, which it needs;
- gate the export on a standalone build of the base, which is the second open consequence recorded
  in the task card and is what would have caught this defect before a consumer's three-hour build.
