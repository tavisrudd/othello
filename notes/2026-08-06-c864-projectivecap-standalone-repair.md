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

(recorded below as the work lands)

## Validation

(recorded below as each gate passes)
