# C860 execution design — dependency inversion of the shared projective-plane base

**Date:** 2026-08-03
**Lane:** `clebsch` (cross-lane authorization from Tavis 2026-08-03 for the cap-owned and shared
`RelativeConicArcs` edits and the affected foreign gate revalidations)
**Task:** C860 — remove the paper Lean closures' dependency on the cap-game library
**Scope of this record:** design only. No `.lean` file was edited, no generator run, no build, no
staleness probe. Every figure below is from read-only source and import-graph analysis of the
working trees named in section 0.

## 0. Which tree is authoritative, and a correction to the card

The C860 card names `~/src/lean/finitegeom` as "the base package". That is the **filtered export**
used for the Paper I release, not the tree the edits land in. The authority is the monorepo Lean
tree `~/src/othello/lean` (544 `RelativeConicArcs/*.lean` modules, 99 gate modules, plus
`ProjectiveCap/` and `CapGame/`); `~/src/lean/finitegeom` carries a 143-module `RelativeConicArcs`
subset and is downstream per the workspace guide's standalone-mirror rule. All declaration
inventories, use-site counts, and import deltas in this memo are measured against
`~/src/othello/lean`. Export to `finitegeom` and the q11/q13 certificate packages is a separate
forward step after the monorepo is green.

**Audit scope of C860 itself.** C860's referee-standard obligation covers exactly the declarations
it relocates and the import surfaces it touches: the moved projective-plane vocabulary gets its
docstrings during the move, and every module whose header or import block C860 rewrites is reviewed
under the `lean/AGENTS.md` review gate. Cap-game-internal mathematics — the build-game theory in
`CapGame/`, the grid/mirror/certificate layers in `ProjectiveCap/`, their documentation debt, their
certificates, and their generators — is **out of C860's scope and stays out of the finitegeom paper
builds entirely**. C860 does not audit, document, or remediate any declaration it does not move.

## 1. Measured inventory

### 1.1 Use sites

Across `RelativeConicArcs` in the monorepo, **55 distinct non-private cap declarations are
referenced from 33 modules**. The card's "thirty-three modules" is exact; its "thirty-seven
declarations" undercounts by eighteen (the card was written against the narrower finitegeom export,
where the same scan returns 52 declarations from 21 modules).

Method: for each `RelativeConicArcs` module, compute its transitive project-local import closure,
restrict candidate cap declarations to the cap modules actually in that closure, and match both
fully qualified references and bare references in modules that `open ProjectiveCap`. Names that
collide with a `RelativeConicArcs` declaration of the same short name are attributed to
`RelativeConicArcs`. Bare single-letter and heavily overloaded names (`Point`, `Line`, `Plane`,
`Cap`, `Collinear`, `GridPoint`, `Valid`, `Move`, `Win`, `IsP`) are counted only in modules that
open the cap namespace; the execution sub must confirm those attributions by elaboration, not by
grep.

**`ProjectiveCap.Projective`** (5 declarations)

| declaration | sites | `RelativeConicArcs` modules |
|---|---|---|
| `Projective.Cap`            | 10 | `Certificate`, `ProjectiveBridge`, `Q11Coding`, `Q11Residual`, `Q16Classification`, `Q16QuadraticTransport`, `Q16Reduction`, `Q25Coordinates`, `Q5SixArcExclusion`, `Q9Terminal` |
| `Projective.Collinear`      | 4  | `OddSixArcAffinePrism`, `OddSixArcPrismExtraction`, `ProjectiveBridge`, `Q16QuadraticTransport` |
| `Projective.cap_mono`       | 3  | `Q16QuadraticTransport`, `Q16Reduction`, `Q5SixArcExclusion` |
| `Projective.Point`          | 2  | `OddSixArcAffinePrism`, `Q5SixArcExclusion` |
| `Projective.LegalExtensions`| 2  | `ProjectiveBridge`, `Q9Terminal` |

**`ProjectiveCap.PlaneTransitivity`** (14 declarations)

| declaration | sites | `RelativeConicArcs` modules |
|---|---|---|
| `Projective.mapEquiv`                    | 14 | `Averaging`, `Conic`, `ConicSecantInvolution`, `OddSixArcAffinePrism`, `ProjectiveTripleNormalization`, `Q11CodeRigidityBridge`, `Q11DyeAxioms`, `Q16Classification`, `Q16QuadraticTransport`, `Q16Reduction`, `Q25BaseNormalization`, `Q25Normalization`, and two further q=25 modules |
| `Projective.mapEquiv_mk`                 | 9  | `Averaging`, `ConicSecantInvolution`, `Q11CodeRigidityBridge`, `Q16Classification`, `Q16QuadraticTransport`, `Q16Reduction`, `Q25BaseNormalization`, `Q25Normalization`, `Q25ResidualAction` |
| `Projective.cap_map_mapEquiv`            | 5  | `Q16Classification`, `Q16QuadraticTransport`, `Q16Reduction`, `Q25BaseNormalization`, `Q25Normalization` |
| `Projective.collinear_mapEquiv`          | 5  | `Averaging`, `Conic`, `OddSixArcAffinePrism`, `Q16QuadraticTransport`, `Q16Reduction` |
| `Projective.mapEquiv_eq_of_rep_eq`       | 3  | `ProjectiveTripleNormalization`, `Q16Reduction`, `Q25BaseNormalization` |
| `Projective.mapEquiv_mk_eq_mk`           | 3  | `Q16Reduction`, `Q25Normalization`, `Q25ResidualAction` |
| `Projective.collinear_iff_dependent`     | 2  | `ConicSecantInvolution`, `ProjectiveBridge` |
| `Projective.independent_triple_iff`      | 2  | `Nucleus`, `ProjectiveBridge` |
| `Projective.independent_triple_of_li`    | 2  | `Nucleus`, `OrdinaryUncoveredObstruction` |
| `Projective.li_rotate`                   | 1  | `Nucleus` |
| `Projective.exists_cons_li`              | 1  | `Q25BaseNormalization` |
| `Projective.not_collinear_iff_independent`| 1 | `CodingBridge` |
| `Projective.quad_normal_form`            | 1  | `Q16Reduction` |
| `Projective.capTransitiveStatement_four` | 1  | `Q5SixArcExclusion` — **game-flavored, see §3.3** |

**`ProjectiveCap.FrameGridBridge`** (17 declarations, all in the `Projective.FrameGridBridge.Coordinate`
namespace except the bare `FrameGridBridge` token, which appears only as a namespace prefix in
`open` lines of `Certificate`, `OddSixArcAffinePrism`, and `ProjectiveTripleNormalization`; the
`FrameGridBridge` *structure* has no `RelativeConicArcs` use site — the execution sub must confirm
this by elaboration before dropping it from the move):

`Coordinate.mk_collinear_iff_det_eq_zero` (5 sites: `Certificate`, `ClebschGateway`,
`OddSixArcAffinePrism`, `Q16Classification`, `Q16QuadraticTransport`); `Coordinate.affineVec`,
`Coordinate.colDirectionVec`, `Coordinate.rowDirectionVec` (2 sites each: `OddSixArcAffinePrism`,
`ProjectiveTripleNormalization`); and, all in `OddSixArcAffinePrism` alone,
`Coordinate.affinePoint`, `affinePoint_injective`, `affineVec_ne_zero`, `colDirection`,
`colDirectionVec_ne_zero`, `collinear_colDirection_affine_iff`,
`collinear_rowDirection_affine_iff`, `det_rowDirection_colDirection_vec`,
`not_collinear_row_col_affine`, `point_eq_affine_or_collinear_row_col`, `rowDirection`,
`rowDirectionVec_ne_zero`.

**`ProjectiveCap.Grid`** (1): `ProjectiveCap.GridPoint` (= `K × K`), used by `OddSixArcAffinePrism`
and `ProjectiveTripleNormalization`.

**`ProjectiveCap.Sym2ConicBridge`** (14, all in namespace `ProjectiveCap.Sym2Bridge`):
`conicForm` (11 sites: `C637WitnessData`, `Certificate`, `Conic`, `ConicSecantInvolution`,
`ExampleChecks.Q5`, `Nucleus`, `Q11SemanticSynthesis`, `Q16Classification`,
`Q16ExceptionalArithmetic`, `SmallOddRelativeConicWitnessData`, `TangentPairFourGroup`);
`veronesePoint` (6); `onConic_mk` (5); `veronesePoint_mk` (4); `OnConic`, `veronese`,
`veronese_ne_zero` (3 each); `veronesePointEmb` (2); `Line`, `Plane`, `lineEquiv`, `lineEquiv_apply`,
`veronesePoint_injective`, `veronesePoint_onConic` (1 each).

**`CapGame.BuildGame`** (3): `FiniteBuildGame.win_iff_exists_move` (`ProjectiveBridge`),
`FiniteBuildGame.isP_equiv` (`Q11Residual`), `FiniteBuildGame.isP_of_no_moves` (`Q9Terminal`).

**`CapGame.GraphMirror`** (1): `ConflictGraph.initialIndepP_of_fpf_adjPreserving_involution`
(`Q11Residual`).

### 1.2 The twelve direct import edges

`RelativeConicArcs/OddSixArcAffinePrism.lean` → `ProjectiveCap.FrameGridBridge`;
`Certificate.lean` → `ProjectiveCap.FrameGridBridge`;
`ProjectiveTripleNormalization.lean` → `ProjectiveCap.FrameGridBridge`, `ProjectiveCap.PlaneTransitivity`;
`Conic.lean` → `ProjectiveCap.Sym2ConicBridge`;
`Averaging.lean`, `ProjectiveBridge.lean`, `Q16Reduction.lean`, `Q25Normalization.lean`,
`Q5SixArcExclusion.lean` → `ProjectiveCap.PlaneTransitivity`;
`Q9Terminal.lean` → `CapGame.BuildGame`;
`Q11Residual.lean` → `CapGame.GraphMirror`.

### 1.3 Gate exposure

Of the 99 modules under `RelativeConicArcs/Gates/`, **51 carry at least one `ProjectiveCap`/`CapGame`
module in their transitive closure**. Representative roots:

| gate | closure size | foreign modules |
|---|---|---|
| `Gates.AMELUAggregate` / `AMELUAggregateAxioms` | 67 / 68 | `CapGame.BuildGame`, `ProjectiveCap.PlaneTransitivity`, `ProjectiveCap.Projective` |
| `Gates.PassantCodeQ13` / `PassantCodeQ13AxiomAudit` | 18 / 19 | same three |
| `Gates.ClebschFactorization` / `ClebschFactorizationAxiomAudit` | 16 / 17 | those three plus `ProjectiveCap.Sym2ConicBridge` |
| `Gates.ClebschPaperTrust` | 119 | all ten (adds `FrameGridBridge`, `Grid`, `GridGame`, `GridSeed`, `CapGame.Mirror`, `CapGame.GraphMirror`) |
| `Gates.ArcsCompleteOutsideConic` | 1401 | all ten |
| `Gates.ArcsCompleteOutsideConicAdditions` | 32 | eight (no `CapGame.Mirror`/`GraphMirror`) |
| `Gates.PRSBeyondRedundancyFour` / `…AxiomAudit` | 15 / 16 | **none** |

**Correction to the card's table:** `beyond4_prs` is listed as carrying `BuildGame`,
`PlaneTransitivity`, and `Projective`. Its gates carry none, and neither do the other eight `PRS*`
gates except `PRSBalancedQuantumExtension` (and its axiom audit), which carry the three. The
Beyond-four PRS release surface therefore needs no C860 work and no revalidation beyond a
reverse-import re-check.

## 2. The blocker: stage 1 as written clears nothing

The card's stage 1 is "split the game-localization section out of
`RelativeConicArcs.ProjectiveBridge` into its own module, so the `FiniteBuildGame` API leaves the
paper closures." That step alone removes `CapGame.BuildGame` from **no** paper closure, because:

1. **`ProjectiveCap/Projective.lean` line 1 is `import CapGame.BuildGame`.** Every closure that
   touches any projective-plane vocabulary at all therefore contains `CapGame.BuildGame`
   unconditionally. `Projective.lean` is 123 lines: lines 14–71 are pure plane vocabulary (`Point`,
   `Collinear`, `Cap`, `cap_mono`, `cap_of_card_le_two`, `cap_pair`), and only the `Game` section
   (lines ~72–120: `LegalExtensions`, `mem_legalExtensions`, `Win`, `InitialPStatement`,
   `CapTransitiveStatement`, `initialPStatement_iff_isP_frame`) needs `BuildGame`.
2. **`ProjectiveCap/PlaneTransitivity.lean` states game theorems in the middle of its plane
   material.** `capTransitiveStatement_one` through `_four` and
   `initialPStatement_iff_isP_frame_of_finrank` mention `CapTransitiveStatement`/`InitialPStatement`,
   and `quad_normal_form` — which `Q16Reduction` uses — sits at line 839 *inside* the
   `Transitivity` section between `capTransitiveStatement_three` and `capTransitiveStatement_four`.
3. **`ProjectiveCap/FrameGridBridge.lean` mixes the same way.** Its first namespace block (the
   `FrameGridBridge` structure, `FixedValid`, `win_fixedValid_iff_grid`, `isP_fixedValid_iff_grid`,
   `isP_projectiveFrame_iff_standardResidualSeed`, `Statement`) is game material; everything that
   `RelativeConicArcs` actually uses is the disjoint `FrameGridBridge.Coordinate` namespace
   (lines 101 onward), which is ordinary affine-chart-in-a-projective-plane coordinate geometry.

**Consequence for sequencing.** Stage 1 must be widened from one split to four splits, all
relocation-only and all inside the cap-owned files, before it delivers anything. Its measurable
deliverable is then real and large: `CapGame.BuildGame` leaves 49 of the 51 exposed gates,
including every AME-LU, Paper IV, and Paper II gate. Section 3 gives the widened stage 1.

**Second, smaller blocker (not fixable by relocation).** `RelativeConicArcs.Q11Residual` uses
`ConflictGraph.initialIndepP_of_fpf_adjPreserving_involution` and `FiniteBuildGame.isP_equiv` to
prove that the six-point projective cap position is a previous-player win, via the icosahedral
independent-set game and its antipodal mirror. That is genuine cap-game mathematics, not
relocatable vocabulary. Paper I (`Gates.ClebschPaperTrust`, `Gates.ClebschRigidityTrust`) and the
arcs paper reach `Q11Residual`, so they keep `CapGame.BuildGame`, `CapGame.Mirror`, and
`CapGame.GraphMirror` in their closures after all four stages. Two smaller instances of the same
kind: `RelativeConicArcs.Q9Terminal` uses `FiniteBuildGame.isP_of_no_moves` and
`Projective.LegalExtensions`, and `RelativeConicArcs.Q5SixArcExclusion` uses
`Projective.capTransitiveStatement_four`.

This is a decision for Tavis, not something the execution sub can settle: either those three
`RelativeConicArcs` modules and the three `CapGame` modules they need are accepted inside the
Paper I and arcs closures as genuine game-theoretic content (and then documented to referee
standard by whoever owns that mathematics — explicitly **not** C860), or the affected Paper I
claims are re-routed away from `Q11Residual`. C860 cannot remove them.

## 3. Stage plan

### 3.1 Stage 1a — split `ProjectiveCap.Projective`

New module `ProjectiveCap/ProjectiveCapGame.lean`, `import ProjectiveCap.Projective` and
`import CapGame.BuildGame`, namespace `ProjectiveCap.Projective` (unchanged, so no use site moves).
Move `LegalExtensions`, `mem_legalExtensions`, `Win`, `InitialPStatement`, `CapTransitiveStatement`,
and `initialPStatement_iff_isP_frame`. `ProjectiveCap/Projective.lean` then imports only
`Mathlib.LinearAlgebra.Projectivization.Collinear`.

Import delta: `ProjectiveCap.Projective` loses `→ CapGame.BuildGame`. Every cap module that used the
`Game` section gains `import ProjectiveCap.ProjectiveCapGame`. Cap-side consumers to rewire
(measured): `PlaneTransitivity`, `GridGame`, `Certificate`, `CertCheck`, `Binary`, `Mirror`,
`GridMirror`, `EllipticMirror`, `EscapeParity`, `ExtensionCount`, `IntrusionCalculus`,
`PlaneOutcome`, `StableFacts`, `ConicLocalization`. These are import-line edits only.

### 3.2 Stage 1b — split `ProjectiveCap.PlaneTransitivity`

New module `ProjectiveCap/PlaneTransitivityGame.lean`, importing `ProjectiveCap.PlaneTransitivity`
and `ProjectiveCap.ProjectiveCapGame`, receiving `capTransitive_of_mapEquiv`,
`capTransitiveStatement_one` … `_four`, the `Extendability` section's `cap_extendable`, and the
`FrameReduction` section's `exists_frame` and `initialPStatement_iff_isP_frame_of_finrank`.
`quad_normal_form` **stays** in `PlaneTransitivity` and must be lifted out of the `Transitivity`
section, which is the one non-mechanical edit in this stage.

### 3.3 Stage 1c — split `ProjectiveCap.FrameGridBridge`

New module `ProjectiveCap/PlaneAffineChart.lean` carrying the entire
`Projective.FrameGridBridge.Coordinate` namespace (from line 101 to the end), importing
`ProjectiveCap.PlaneTransitivity` and `ProjectiveCap.Grid` only — no `GridGame`, no `GridSeed`, no
`BuildGame`. `ProjectiveCap/FrameGridBridge.lean` keeps the structure and its game lemmas and
imports the new module.

The five `RelativeConicArcs` modules currently importing `ProjectiveCap.FrameGridBridge` repoint to
`ProjectiveCap.PlaneAffineChart`. This is what removes `GridGame` and `GridSeed` from the Paper I,
arcs, and Clebsch gate closures.

### 3.4 Stage 1d — split `RelativeConicArcs.ProjectiveBridge`

New module `RelativeConicArcs/CapGameHoleLocalization.lean`, importing
`RelativeConicArcs.ProjectiveBridge` and `ProjectiveCap.ProjectiveCapGame`, receiving the eight
declarations of the `GameLocalization` section (lines 165–332):
`projectiveCap_subset_union_of_completeOutside`, `move_mem_holes_of_completeOutside`,
`legalExtensions_subset_holes_of_completeOutside`, `legalExtensions_subset_holes`,
`legalExtensions_sdiff_holes_eq_uncovered`, `ParametrizedHoleValid`, `win_parametrizedHoles_iff`,
`isP_parametrizedHoles_iff`. `arc_iff_projectiveCap` **stays** in `ProjectiveBridge`: it mentions
`Projective.Cap` only, which is plane vocabulary, and five modules (`Certificate`, `ClebschGateway`,
`CodingBridge`, `Nucleus`, `Q11Coding`, `Q16Reduction`) depend on it.

Consumers of the moved section: `Q11Coding` (`ParametrizedHoleValid`) and `Q11Residual`
(`ParametrizedHoleValid`, `isP_parametrizedHoles_iff`) gain
`import RelativeConicArcs.CapGameHoleLocalization`.

### 3.5 Predicted stage-1 outcome

`CapGame.BuildGame`, `ProjectiveCap.GridGame`, and `ProjectiveCap.GridSeed` leave every gate closure
except those reaching `RelativeConicArcs.Q11Residual`, `Q9Terminal`, or `Q5SixArcExclusion`. In
particular the AME-LU, Paper IV, and Paper II gates lose all `CapGame` content, and their remaining
foreign modules are the plane library `ProjectiveCap.Projective`, `PlaneTransitivity`, and
`Sym2ConicBridge`, which stages 2–4 relocate. **The execution sub must measure this rather than
assert it**, by recomputing every gate's closure before and after and recording the delta in the
stage-1 report.

### 3.6 Stages 2–4 — the relocation proper (one build window)

Destination layout under `RelativeConicArcs`. Names describe the objects, carry no manuscript,
lane, or task reference, and get their docstrings written during the move.

| new module | receives | from |
|---|---|---|
| `RelativeConicArcs/CoordinateProjectivePlane.lean` | `Point`, `Collinear`, `Cap`, `cap_mono`, `cap_of_card_le_two`, `cap_pair` | `ProjectiveCap/Projective.lean` (post-1a) |
| `RelativeConicArcs/ProjectivePointIndependence.lean` | `collinear_iff_dependent`, `not_collinear_iff_independent`, `independent_triple_iff`, `independent_triple_of_li`, `li_rotate`, `li_with_sum12/13/23`, `sum_ne_zero_of_li`, `exists_cons_li`, `quad_normal_form`, and the private helpers they need | `ProjectiveCap/PlaneTransitivity.lean` (post-1b) |
| `RelativeConicArcs/ProjectiveLinearTransport.lean` | `mapEquiv`, `mapEquiv_mk`, `mapEquiv_mk_eq_mk`, `mapEquiv_eq_of_rep_eq`, `collinear_mapEquiv`, `cap_map_mapEquiv`, `cap_triple_of_independent`, `cap_quad_of_independent` | `ProjectiveCap/PlaneTransitivity.lean` (post-1b) |
| `RelativeConicArcs/AffineChartCollinearity.lean` | the `Coordinate` namespace: `PlaneVec`, `rowDirectionVec`, `colDirectionVec`, `affineVec` and their nonvanishing, `rowDirection`, `colDirection`, `affinePoint`, `affinePoint_injective`, `affineEmbedding`, `mk_collinear_iff_det_eq_zero`, the `det_*` family, `collinear_rowDirection_affine_iff`, `collinear_colDirection_affine_iff`, `not_collinear_row_col_affine`, `point_eq_affine_or_collinear_row_col`; plus `GridPoint` (as an affine-cell abbreviation with a semantic name) and the affine `Collinear` predicate | `ProjectiveCap/PlaneAffineChart.lean` (post-1c) and `ProjectiveCap/Grid.lean` |
| `RelativeConicArcs/VeroneseConicBridge.lean` | the whole `ProjectiveCap.Sym2Bridge` namespace: `Plane`, `Line`, `conicForm`, `OnConic`, `onConic_mk`, `veronese`, `veronese_ne_zero`, `veronesePoint`, `veronesePoint_mk`, `veronesePoint_injective`, `veronesePoint_onConic`, `veronesePointEmb`, `lineEquiv`, `lineEquiv_apply` | `ProjectiveCap/Sym2ConicBridge.lean` |

Stage 2 is the first three rows (coordinate transport, collinearity and the determinant criterion,
independent-triple equivalences, `Cap`, `cap_mono`, `cap_map_mapEquiv`); stage 3 is the affine chart
and the Veronese bridge; stage 4 repoints the cap modules at the new base and deletes every
`ProjectiveCap`/`CapGame` import from `RelativeConicArcs` other than the three genuine game
consumers of §2.

**Namespace decision the execution sub must not improvise.** The moved declarations currently live
in `ProjectiveCap.Projective` and `ProjectiveCap.Sym2Bridge`. Two options: (i) keep the leaf
namespaces (`RelativeConicArcs.Projective`, `RelativeConicArcs.Sym2Bridge`), which makes every use
site a one-token change and the `open` lines nearly unchanged; (ii) rename to
`RelativeConicArcs.CoordinateProjectivePlane` etc., which is better scholarly naming but rewrites
55 declarations × 33 modules of use sites. Recommendation: (i) for the move, with the module names
carrying the semantics, because the move must be provably behaviour-preserving; a namespace rename
is a separate, cheap, later change once the import graph is clean. Confirm with Tavis before
starting stage 2.

**No cap-game mathematics is touched.** Stages 1–4 relocate declarations and rewrite import lines.
No statement, proof, or definition changes. Any proof that does not compile after a move is a
missing dependency to carry along, not a proof to repair.

## 4. Import-graph delta per stage

| stage | edges removed | edges added | net effect on paper closures |
|---|---|---|---|
| 1a | `ProjectiveCap.Projective → CapGame.BuildGame` | `ProjectiveCap.ProjectiveCapGame → {Projective, CapGame.BuildGame}`; ~14 cap modules gain `→ ProjectiveCapGame` | none yet on its own (PlaneTransitivity still pulls the game module) |
| 1b | `PlaneTransitivity → ProjectiveCapGame` (after the game theorems leave) | `PlaneTransitivityGame → {PlaneTransitivity, ProjectiveCapGame}`; `FrameGridBridge` and the cap game layer gain `→ PlaneTransitivityGame` | AME-LU, Paper IV, Paper II gates lose `CapGame.BuildGame` |
| 1c | `PlaneAffineChart` does not import `GridGame`/`GridSeed`; the five `RelativeConicArcs` importers move off `FrameGridBridge` | `PlaneAffineChart → {PlaneTransitivity, Grid}`; `FrameGridBridge → PlaneAffineChart` | Paper I, arcs, Clebsch gates lose `FrameGridBridge`, `GridGame`, `GridSeed` |
| 1d | `ProjectiveBridge` no longer needs the game API | `CapGameHoleLocalization → {ProjectiveBridge, ProjectiveCapGame}`; `Q11Coding`, `Q11Residual` gain it | isolates the residual game dependency in three named modules |
| 2 | the twelve direct `RelativeConicArcs → ProjectiveCap` import edges begin to disappear | new base modules import Mathlib only | `ProjectiveCap.Projective`, `PlaneTransitivity` leave every gate closure that reaches only the base |
| 3 | `Conic → Sym2ConicBridge`, `OddSixArcAffinePrism/ProjectiveTripleNormalization → Grid` | `VeroneseConicBridge`, `AffineChartCollinearity` | `Sym2ConicBridge`, `Grid` leave |
| 4 | every remaining `RelativeConicArcs → ProjectiveCap` edge | `ProjectiveCap.* → RelativeConicArcs.<base>` (inverted direction) | only `Q9Terminal`, `Q11Residual`, `Q5SixArcExclusion` retain a `CapGame`/game-module import |

Stage 4 inverts the package dependency direction: `ProjectiveCap` will import `RelativeConicArcs`.
`~/src/othello/lean/lakefile.toml` declares `CapGame`, `ProjectiveCap`, and `RelativeConicArcs` as
three sibling `lean_lib` entries of one package (alongside `NodeKayles`, `Sumfree`, `Queens`,
`FiniteGeom`, `RepairCodes`, `RepairPorts`, `DihedralSchreier`), all listed in `defaultTargets`,
with no declared inter-library dependency or ordering. Lake resolves module imports across
libraries within a package, so the inversion is permitted by the build configuration and needs no
lakefile change. The stage-1 sub should still confirm this by elaborating one probe module before
stage 2 begins, and must check the same question separately for the exported packages
`~/src/lean/finitegeom` and `~/src/lean/finitegeom-clebsch-q11-certificates`, whose lakefiles are
narrower and whose `defaultTargets` name individual modules.

## 5. Revalidation per stage, with guarded commands

`lean/AGENTS.md` binds all of this: never run `lake` or `nix … lake` directly; single-file work goes
through `lean/scripts/guarded-lean`; anything wider goes through
`lean/scripts/lean-build-queue.py`; a single-file elaboration against last-built foreign
dependencies is a smoke test and must be labeled as such, never a gate; `--old` is forbidden for a
gate; the shared build-owner lock is host-wide and only one heavy build may run.

**Smoke tests while editing** (from `~/src/othello`, one at a time):

```sh
lean/scripts/guarded-lean ProjectiveCap/Projective.lean
lean/scripts/guarded-lean ProjectiveCap/ProjectiveCapGame.lean
lean/scripts/guarded-lean RelativeConicArcs/ProjectiveBridge.lean
```

**Gate revalidation** after each stage, as one unattended queue run holding the build-owner lock:

```sh
lean/scripts/lean-build-queue.py plan --profile single --threads 1
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.Gates.AMELUAggregate \
  RelativeConicArcs.Gates.AMELUAggregateAxioms \
  RelativeConicArcs.Gates.PassantCodeQ13 \
  RelativeConicArcs.Gates.PassantCodeQ13AxiomAudit \
  RelativeConicArcs.Gates.ClebschFactorization \
  RelativeConicArcs.Gates.ClebschFactorizationAxiomAudit \
  RelativeConicArcs.Gates.ClebschPaperTrust \
  RelativeConicArcs.Gates.ArcsCompleteOutsideConicAdditions \
  RelativeConicArcs.Gates.PRSBeyondRedundancyFour \
  RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit \
  --profile single --threads 1 --cores 20-23 --detach
lean/scripts/lean-build-queue.py status ~/.cache/othello-lean-build/run-<id>
```

`Gates.ArcsCompleteOutsideConic` has a 1401-module closure and must be planned separately with its
own measured profile rather than folded into the list above; add it only from a representative
`time -v` measurement per the profile rules, and land it as the last target of the window.

Which gate answers for which paper:

| paper | gate roots to revalidate | needed after |
|---|---|---|
| Paper I, *clebsch-rigidity* | `Gates.ClebschPaperTrust` (monorepo) and, on export, `RelativeConicArcs.Gates.ClebschRigidityTrust` in `~/src/lean/finitegeom-clebsch-q11-certificates` | stages 1c, 2, 3, 4 |
| Paper II, *clebsch-factorization* | `Gates.ClebschFactorization`, `Gates.ClebschFactorizationAxiomAudit`, `Gates.ClebschPaperIIStructural` | stages 1b, 2, 3, 4 |
| arcs, *arcs_complete_outside_conic* | `Gates.ArcsCompleteOutsideConic`, `Gates.ArcsCompleteOutsideConicAdditions` | stages 1c, 2, 3, 4 |
| AME-LU | `Gates.AMELUAggregate`, `Gates.AMELUAggregateAxioms` | stages 1a+1b, 2, 4 |
| `beyond4_prs` | `Gates.PRSBeyondRedundancyFour`, `…AxiomAudit` — closures are already cap-free; a reverse-import re-check suffices, no build unless the check shows an edge | confirmation only |
| Paper IV, *q13-passant-code* | `Gates.PassantCodeQ13`, `Gates.PassantCodeQ13AxiomAudit` | stages 1a+1b, 2, 4 |

Each gate build is followed by the exact-target `lake build --no-build` confirmation the shared-library
protocol requires (issued by the queue runner's trace-only aggregate gate, not by hand) and the
lane's documented axiom audit. Manifest and fingerprint refreshes for each affected paper happen
once, at the end of the stages-2-4 window, not per stage.

## 6. Collision with the C855 Paper I rename plan

The rename plan is `notes/2026-08-03-c855-rename-plan.md`. Interaction, site by site against its §5
change-set table:

- **Rows 1–3 (the eleven `PaperIOrientation*` modules, their imports, the q11 gate's import and 23
  `#print axioms` lines, the eleven `lakefile.toml` `defaultTargets` strings).** No collision. None
  of those modules appears in C860's move list or import delta; C860 touches no `PaperIOrientation*`
  file.
- **Rows 4 and 5 (`finitegeom/TARGET_MANIFEST.json` and the q11 `MANIFEST.json`).** Hard collision.
  Both carry per-file SHA-256 digests, byte counts, a module count, and a root list. C860 stage 3
  changes the file bytes of `Certificate.lean`, `Conic.lean`, `Averaging.lean`,
  `OddSixArcAffinePrism.lean`, `OddSixArcPrismExtraction.lean`, `ProjectiveTripleNormalization.lean`,
  `ProjectiveBridge.lean`, `Q11Coding.lean`, `Q11Residual.lean`, `Q16Reduction.lean`,
  `ClebschGateway.lean`, `Nucleus.lean`, `CodingBridge.lean`, and `Q11SemanticSynthesis.lean` — all
  inside the Paper I closure — and adds five new modules to it while removing up to seven foreign
  ones. Every digest and both counts move.
- **Row 6 (`verification/clebsch_rigidity_trust/axiom-audit.txt`).** Build-produced. C860 does not
  rename a declaration, so the 23 recorded lines keep their names, but the audit must be regenerated
  anyway if the closure changes; the execution sub must regenerate rather than assume it is stable.
- **Rows 7–9 (`build_trust_manifest.py`, `trust_manifest.json`, `verify_trust_manifest.py`).** The
  hard-coded orientation declaration list and the `ODD_A5_COMMUTANT_TERMINALS` allowlist name no
  relocated declaration, so C860 does not force an edit there — but `trust_manifest.json` carries
  `lean_repository.commit` and `lean_repository.finitegeom_commit`, so it is rebuilt after C860
  regardless.
- **Rows 10–12 (audited negatives).** Unchanged by C860; the q11 point-action generator emits only
  `RelativeConicArcs.Examples.Q11A5PointOrbits` names, and no manuscript `.tex` names a relocated
  declaration.

**Regeneration requirement.** The C855 rename plan's §1 argument — that the renames are one batched
window because the manifests and the axiom audit cannot be produced incrementally — applies verbatim
to C860's manifest impact. The two windows must not overlap, and **the rename plan must be
regenerated after C860 stage 3**, because its §5 rows 4 and 5 are computed against a Paper I closure
that stage 3 changes in membership, not only in bytes. The plan's §2 module table, §3 declaration
table, and §4 false-strength findings survive unchanged; only §5 and the closure figure in the
preamble need recomputation. The sequencing Tavis set — stage 1, then stages 2–4 as one window, then
the C855 rename/gate/manifest window — is exactly the order that keeps this from becoming circular.

One further C855 interaction: its checklist section 5 defers the `WP-1` removal in
`ProjectiveCap.FrameGridBridge` and the planning prose in `ProjectiveCap.Grid`, `GridSeed`,
`Projective`, and `CapGame.BuildGame` to their owners. C860 stage 1c splits `FrameGridBridge` and
stage 3 moves the `Grid` vocabulary, so the `Coordinate` half and the `GridPoint` abbreviation come
into C860's audit scope and are documented during the move. The `WP-1` reference and the planning
prose in the *game* halves stay with the cap owner and stay out of the paper closures — after stage
1c and stage 3 those files are no longer in any paper's verification closure, which is the point.

## 7. Ordered checklist — stage-1 sub

Read `lean/AGENTS.md` completely first; it binds every step below. Work in `~/src/othello/lean`.
Relocation and import adjustment only; change no statement or proof.

1. Re-confirm the Lake topology finding of §4 by elaborating one probe module that imports across
   the library boundary in the intended new direction, and check the exported packages' narrower
   lakefiles for the same question. Stop and report if either forbids the inversion. *Validation:
   one `guarded-lean` probe, labeled a smoke test.*
2. Confirm by elaboration, not grep, that the `FrameGridBridge` *structure* has no
   `RelativeConicArcs` use site and that the bare `FrameGridBridge` tokens in `Certificate`,
   `OddSixArcAffinePrism`, and `ProjectiveTripleNormalization` are namespace prefixes only.
   *Validation: `guarded-lean` on those three files after a trial removal of the structure from the
   import path, labeled a smoke test.*
3. Stage 1a: create `ProjectiveCap/ProjectiveCapGame.lean`, move the six `Game`-section
   declarations, drop `import CapGame.BuildGame` from `ProjectiveCap/Projective.lean`, add the new
   import to the ~14 cap consumers. *Validation: `guarded-lean ProjectiveCap/Projective.lean`, then
   `ProjectiveCap/ProjectiveCapGame.lean`, then each rewired consumer.*
4. Stage 1b: create `ProjectiveCap/PlaneTransitivityGame.lean`, move `capTransitive_of_mapEquiv`,
   `capTransitiveStatement_one`…`_four`, `cap_extendable`, `exists_frame`, and
   `initialPStatement_iff_isP_frame_of_finrank`; lift `quad_normal_form` out of the `Transitivity`
   section so it stays behind. Repoint `RelativeConicArcs/Q5SixArcExclusion.lean` at the new game
   module. *Validation: `guarded-lean` on both halves and on `Q5SixArcExclusion.lean`.*
5. Stage 1c: create `ProjectiveCap/PlaneAffineChart.lean` with the whole
   `FrameGridBridge.Coordinate` namespace; repoint `RelativeConicArcs/Certificate.lean`,
   `OddSixArcAffinePrism.lean`, and `ProjectiveTripleNormalization.lean` at it. *Validation:
   `guarded-lean` on the two cap halves and the three `RelativeConicArcs` modules.*
6. Stage 1d: create `RelativeConicArcs/CapGameHoleLocalization.lean` with the eight
   `GameLocalization` declarations; leave `arc_iff_projectiveCap` in `ProjectiveBridge`; add the new
   import to `Q11Coding.lean` and `Q11Residual.lean`. *Validation: `guarded-lean` on
   `ProjectiveBridge.lean`, the new module, `Q11Coding.lean`, `Q11Residual.lean`.*
7. Write module headers and docstrings for the four new modules and re-audit the four split source
   modules under the `lean/AGENTS.md` review gate — whole module, not changed lines. Do **not** audit
   or edit any declaration that was not moved or whose import block was not rewritten.
8. Recompute every gate closure and record the before/after foreign-module delta per gate.
   *Validation: the recorded delta must show `CapGame.BuildGame`, `ProjectiveCap.GridGame`, and
   `ProjectiveCap.GridSeed` gone from every gate not reaching `Q11Residual`, `Q9Terminal`, or
   `Q5SixArcExclusion`.*
9. Run the gate revalidation queue of §5 in one build window. *Validation: green status plus the
   trace-only aggregate gate; a red gate stops the stage.*
10. Commit the monorepo change with explicit whole-file pathspecs, and write the dated stage-1
    report to `notes/` with the measured closure delta.

## 8. Ordered checklist — stages-2-4 sub

One build window. Prerequisite: stage 1 committed and green, and Tavis's answer on the namespace
question of §3.6.

1. Re-read `lean/AGENTS.md` and `papers/style-guide.md` (the moved declarations get referee-facing
   docstrings, which is a prose edit in a Lean source).
2. Stage 2: create `RelativeConicArcs/CoordinateProjectivePlane.lean`,
   `ProjectivePointIndependence.lean`, and `ProjectiveLinearTransport.lean`; move their declarations
   out of `ProjectiveCap/Projective.lean` and `ProjectiveCap/PlaneTransitivity.lean`, writing each
   docstring during the move. *Validation: `guarded-lean` on each new module.*
3. Stage 3: create `RelativeConicArcs/AffineChartCollinearity.lean` and
   `VeroneseConicBridge.lean`; move `ProjectiveCap/PlaneAffineChart.lean`, the `GridPoint`
   abbreviation and affine collinearity from `ProjectiveCap/Grid.lean`, and the whole
   `ProjectiveCap.Sym2Bridge` namespace. *Validation: `guarded-lean` on each new module.*
4. Stage 4: rewrite `ProjectiveCap/Projective.lean`, `PlaneTransitivity.lean`,
   `PlaneAffineChart.lean`, `Grid.lean`, `Sym2ConicBridge.lean`, and `FrameGridBridge.lean` to
   import the new `RelativeConicArcs` base and re-export or alias nothing; delete every
   `import ProjectiveCap.*` and `import CapGame.*` line from `RelativeConicArcs` except in
   `Q9Terminal.lean`, `Q11Residual.lean`, `Q5SixArcExclusion.lean`, and
   `CapGameHoleLocalization.lean`. *Validation: a repository-wide grep for
   `^import (ProjectiveCap|CapGame)` under `RelativeConicArcs` must return exactly those four files.*
5. Update the 33 use-site modules for whatever namespace decision §3.6 settled. *Validation:
   `guarded-lean` per module, then the gate queue.*
6. Run the full gate revalidation of §5, including `Gates.ArcsCompleteOutsideConic` as a separately
   profiled last target. *Validation: green status and the trace-only aggregate gate.*
7. Run each affected paper's axiom audit gate and diff against its recorded transcript. *Validation:
   no new axiom, no lost terminal.*
8. Refresh each affected paper's checksum manifest and fingerprint, once, at the end. Regenerate,
   never hand-edit. *Validation: each paper's release verifier.*
9. Forward-export to `~/src/lean/finitegeom` and the certificate packages through
   `lean/scripts/lean-companion-export.py … plan` then `run`, per `lean/AGENTS.md`; adopting the
   delta is a separate explicit decision, not part of this window.
10. Commit and write the dated stages-2-4 report, including the recomputed Paper I closure figures
    that C855's rename plan will be regenerated against.

## 9. Paper-lane Lean cards adjusted, and the ones that do not exist

Adjusted with a short dated sequencing note (cross-lane authorization from Tavis 2026-08-03):

- `notes/clebsch-tasks/c857-paper-iv-lean-standards-closure.md` — its section D names
  `ProjectiveCap/PlaneTransitivity.lean` explicitly as a documentation target. After C860 stage 1
  that file is no longer in the Paper IV gate closure, and after stages 2–4 its shared content lives
  in the relocated `RelativeConicArcs` base, documented by C860 during the move.
- `notes/clebsch-tasks/c577-factorization-paper.md` — repackaging and the new standalone forward
  commit wait for C860 stages 2–4, because those stages change the Paper II gate closure membership
  and therefore every hash in the export manifest.
- `notes/clebsch-tasks/c834-paper-iv-full-lean-release-closure.md` — informational only; stage 1
  removes `CapGame.BuildGame` from the Paper IV closure with no action required of C834.
- `notes/2026-08-02-c859-mds-css-formal-remediation-checklist.md` — the AME-LU lane's Lean-facing
  card. Its section 2 requires auditing the full transitive project-owned closure; that instruction
  would otherwise pull `ProjectiveCap.Projective` and `PlaneTransitivity` into an AME-LU audit.

**No `beyond4_prs` Lean closure card exists.** A narrow search of `notes/clebsch-tasks/`,
`notes/handoffs/`, and the live queue found no allocated task for the PRS Lean release surface, and
none is needed: every `PRSBeyondRedundancy*`, `PRSFoundation`, `PRSRedundancy*`,
`PRSPolarInduction*`, `PRSStableComponents`, and `PRSCharacteristicTwoHessianLucas` gate has an
entirely cap-free closure. Only `Gates.PRSBalancedQuantumExtension` and its axiom audit carry
`ProjectiveCap.Projective`, `PlaneTransitivity`, and `CapGame.BuildGame`; if that gate is ever
promoted to a release surface it inherits the C860 sequencing automatically.

**Scope rule applied to all four cards.** None of them audits, documents, or remediates a
`ProjectiveCap` or `CapGame` module. Each consumes the audited, relocated shared base that C860
delivers, and reports any residual cap-game import in its paper's closure to C860 rather than fixing
it locally.

## 10. What this record does not establish

No Lean source was edited, no build or staleness probe was run, and no closure figure here has been
confirmed by elaboration. The use-site attribution in §1.1 is textual and import-closure-restricted;
bare-name attributions in modules that `open ProjectiveCap` are the least certain and are exactly
what step 2 of the stage-1 checklist exists to confirm. The Lake library topology of §4 is
unverified and is the first thing the stage-1 sub must check.
