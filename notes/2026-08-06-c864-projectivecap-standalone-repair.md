# C864 — repairing the projective-cap library so finitegeom builds standalone

**Lane:** `build-sys`

**Date:** 2026-08-06

The standalone finitegeom build gate left one of seven declared targets red: `ProjectiveCap` did
not elaborate. This report records what the failure actually was, the repair chosen, and the
validation that establishes it.

## Verifying the diagnosis

The reported errors reproduce from the committed trees
(monorepo `ea46e3b1`, finitegeom `278ef6a`, both clean at the start of this work):

```
error: ProjectiveCap/Mirror.lean:203:22: Invalid argument name `K` for function
error: ProjectiveCap/Mirror.lean:204:9: Invalid argument: Variable `InitialPStatement`
       is not a proposition or let-declaration
```

`InitialPStatement` is declared in `ProjectiveCap.ProjectiveCapGame`, one of two projective-cap
modules the monorepo carries and finitegeom does not. Comparing the import lines of every
projective-cap module in finitegeom against its monorepo counterpart gives ten modules that differ,
six of them missing an import of a module finitegeom does not carry:

| finitegeom module | missing import |
|---|---|
| `ProjectiveCap/Binary.lean` | `ProjectiveCap.ProjectiveCapGame` |
| `ProjectiveCap/Mirror.lean` | `ProjectiveCap.ProjectiveCapGame` |
| `ProjectiveCap/EllipticMirror.lean` | `ProjectiveCap.PlaneTransitivityGame` |
| `ProjectiveCap/FrameGridBridge.lean` | `ProjectiveCap.PlaneTransitivityGame` |
| `ProjectiveCap/GridMirror.lean` | `ProjectiveCap.PlaneTransitivityGame` |
| `ProjectiveCap/StableFacts.lean` | `ProjectiveCap.PlaneTransitivityGame` |

### The mechanism is an export that replaced a base module underneath older consumers

The earlier reading — that the modules were carried with their import lines deleted — is not what
the histories show, and the true mechanism matters because it is a class of defect that can recur.

Both game modules were *created* in the monorepo on 2026-08-03, by the two commits that separated
the projective cap achievement game from the projective cap vocabulary and the projective plane
frame reduction from its underlying plane geometry. finitegeom's projective-cap modules were
extracted on 2026-07-26, a week before that split existed, so at extraction time the declarations
they use lived inside `ProjectiveCap.Projective` and `ProjectiveCap.PlaneTransitivity`, which they
already imported. Nothing was dropped then.

What changed is that on 2026-08-05 an area export (the six-arc triple-concurrence boundary) carried
`ProjectiveCap.Projective`, `ProjectiveCap.PlaneTransitivity`, and `ProjectiveCap.PlaneAffineChart`
into finitegeom as part of its closure. Those three arrived in their post-split, game-free form and
replaced the pre-split copies byte for byte. The export's own gate was satisfied — its closure
elaborated, and every file it planned matched the authority exactly — but the declarations the
split had moved out of those base modules vanished from finitegeom, and the six older consumers
that still referenced them were not in the export's closure and were left behind unchanged.

So the failure is not a halfway split. It is an export that correctly updated a shared base module
while consumers outside its closure kept depending on declarations that update removed. The static
resolution gate cannot see it: no import dangles, only declarations disappear.

Three further import differences are unrelated to the failure and involve only modules finitegeom
already carries: `ProjectiveCap/Certificate.lean` imports `ProjectiveCap.Almost.OddEscape` where
the monorepo does not, `ProjectiveCap/ConicLocalization.lean` and `ProjectiveCap/EscapeParity.lean`
do not where the monorepo does, `ProjectiveCap/ExtensionCount.lean` imports
`ProjectiveCap.GridGame` where the monorepo imports `ProjectiveCap.StableFacts`, and
`ProjectiveCap/FrameGridBridge.lean` does not import `ProjectiveCap.PlaneAffineChart`. These are
consequences of finitegeom's projective-cap consumers predating the 2026-08-03 reorganization; they
resolve and are left alone.

## Repair options weighed

**Carry the two missing modules and restore the six imports.** Chosen. The closure is minimal and
stays inside the projective-cap namespace: `ProjectiveCap.ProjectiveCapGame` imports
`ProjectiveCap.Projective` and `CapGame.BuildGame`, both already carried and both already library
roots in finitegeom; `ProjectiveCap.PlaneTransitivityGame` imports `ProjectiveCap.PlaneTransitivity`
and `ProjectiveCap.ProjectiveCapGame`. Nothing outside `ProjectiveCap.*` is added. Both modules are
short. Both are taken byte-identically from the monorepo authority, which restores exactly the
declarations the 2026-08-05 export removed, so finitegeom's projective-cap content becomes a
truthful subset of the authority rather than a fork of it.

**Delete the unbuildable modules.** Rejected on evidence. The game declarations are referenced
across most of the library — thirteen of the twenty-two projective-cap modules mention them — so
removing the consumers would remove nearly the whole published library, including the certificate
interface and the residual-grid content that other exported material sits beside.

**Split each consumer along the game-free boundary.** Rejected as unnecessary. The monorepo already
performed exactly that split on 2026-08-03 and kept both halves; reproducing a different split
downstream would make finitegeom diverge further from the authority, which is the opposite of what
the failure calls for.

## What changed

Everything below is in the finitegeom repository. No monorepo Lean source was touched: the
authority already carries the correct content, and the defect was entirely downstream.

`ProjectiveCap/ProjectiveCapGame.lean` and `ProjectiveCap/PlaneTransitivityGame.lean` were added,
byte-identical to `lean/ProjectiveCap/` in the monorepo at `094aebe5`. Six modules each regained
exactly one import line and changed in no other way: `Binary.lean` and `Mirror.lean` import
`ProjectiveCap.ProjectiveCapGame`; `EllipticMirror.lean`, `FrameGridBridge.lean`, `GridMirror.lean`
and `StableFacts.lean` import `ProjectiveCap.PlaneTransitivityGame`. Every project-namespace import
under `ProjectiveCap/` now resolves inside the tree, and the only import leaving the namespace is
`CapGame.BuildGame`, which finitegeom already carried as a root of its own library.

The bookkeeping that no tool models had to be done by hand:

- `lakefile.toml` roots both new modules in the `ProjectiveCap` library, which goes from twenty-two
  roots to twenty-four, in the sorted order the exporter's insertion produces.
- `TARGET_MANIFEST.json` gains a `sources` entry for each new module and its `module_count` rises
  from 317 to 319. The manifest's `roots` list is untouched: it holds the gate and area roots the
  exporter accumulates, not every module, and neither new module is one. `external_imports` is
  likewise unchanged, confirmed by reading both modules' import lines — neither imports Mathlib.
- `README.md` and `PROVENANCE.md` each state the library-state module count in prose; both were
  moved from 317 to 319. Leaving either at 317 makes every area export refuse with
  `base prose disagrees with the base manifest`.

One further manifest edit was needed and is worth recording, because the first export attempt found
it rather than review. `TARGET_MANIFEST.json` content-addresses every module, so adding an import
line to the six consumers invalidated their recorded `bytes` and `sha256`. All twelve exports
refused with `base manifest entry for ProjectiveCap/Binary.lean does not match the base tree` until
those six digests were refreshed. Recomputing digests across the whole manifest changed exactly the
six modules edited here and nothing else, which is independent confirmation that the source change
is confined to those six files.

## Validation

**The projective-cap library builds.** Exit 0, no `resume:` line:

```sh
python3 lean/scripts/lean-build-queue.py build ProjectiveCap \
  --lean-root ~/src/lean/finitegeom --cores 20-23
```

```
state:   success
  cache-restored   <mathlib cache get>  0:08.54 wall, 456664 kB peak
  built            ProjectiveCap  0:34.29 wall, 1911396 kB peak
  gate-passed      <aggregate>
```

**All seven declared targets build together.** Exit 0; the six that were already green stayed
trace-current and the aggregate gate passed:

```sh
python3 lean/scripts/lean-build-queue.py build \
  Sumfree CapGame ProjectiveCap FiniteGeom RepairCodes RepairPorts RelativeConicArcs \
  --lean-root ~/src/lean/finitegeom --cores 20-23
```

```
state:   success
  skipped-current  Sumfree
  skipped-current  CapGame
  skipped-current  ProjectiveCap
  skipped-current  FiniteGeom
  skipped-current  RepairCodes
  skipped-current  RepairPorts
  skipped-current  RelativeConicArcs
  gate-passed      <aggregate>
```

This is the first time finitegeom has built every target it declares.

**All twelve area exports remain idempotent.** Against monorepo `094aebe5` and finitegeom
`dca9ce75`, every configuration exits 0 with `forward_delta.file_count` 0: `ame_lu`,
`arcs_complete_outside_conic_additions`, `arcs_complete_outside_conic_human`,
`clebsch_factorization`, `clebsch_passages`, `clebsch_rigidity_human`,
`clebsch_six_arc_concurrence`, `clebsch_support_cubic_orientation`, `complete_ports`,
`golden_quantum_statistics`, `mds_css_transversal_groups`, `prs_beyond_redundancy_four`. Because
the exporter now also refuses a candidate that would not resolve as a repository of its own, this
gate covers the new roots and imports as well as the hand edits.

**The certificate boundary is green.** `python3 lean/scripts/lean-certificate-boundary.py` exits 0
with `certificate boundary ok`. It was run without `--verify-official-libraries`, which stays red
until the order-eleven package's deletions, gate rename and manifest reseal land.

## Found and deliberately not touched

**finitegeom's projective-cap consumers still predate the 2026-08-03 reorganization.** Five import
differences from the authority remain, all resolving inside the tree and none blocking a build:
`Certificate.lean` imports `ProjectiveCap.Almost.OddEscape` where the monorepo does not;
`ConicLocalization.lean` and `EscapeParity.lean` do not where the monorepo does;
`ExtensionCount.lean` imports `ProjectiveCap.GridGame` where the monorepo imports
`ProjectiveCap.StableFacts`; and `FrameGridBridge.lean` does not import
`ProjectiveCap.PlaneAffineChart`.

That last one has substance behind it. finitegeom's `FrameGridBridge.lean` is 841 lines against the
authority's 294, because it still holds the affine-chart incidence dictionary inline that the
monorepo moved into `ProjectiveCap.PlaneAffineChart` on 2026-08-03. finitegeom also carries
`PlaneAffineChart.lean` byte-identically, arrived by the 2026-08-05 export, so the same declarations
exist twice in the repository. This compiles because no module imports both, and
`PlaneAffineChart.lean` is imported by nothing in finitegeom at all. Adding the authority's
`import ProjectiveCap.PlaneAffineChart` to `FrameGridBridge.lean` would collide the duplicates, so
it was not added. Resolving this means bringing finitegeom's projective-cap consumers up to the
authority's post-reorganization form — a content refresh of the area, not an import fix.

**The projective-cap area has no export configuration.** Nothing under `lean/trust/export/` covers
it, which is why its content drifted from the authority without any gate noticing and why the
divergences above persist. The area's modules enter finitegeom only as incidental closure of other
areas' exports, which is exactly the mechanism that caused this failure.

**The general defect the failure exposes.** An area export byte-identically replacing a shared base
module can delete declarations that consumers outside the export's closure depend on. Every
existing gate passed while finitegeom was broken: the export's own closure elaborated, no import
dangled, and the module-resolution check saw a consistent tree. Only a full library build catches
it, and only because finitegeom now declares every module as a root of some library. No guard for
this class was added here; a reverse-declaration-use check against the modules an export replaces
would be the shape of one.
