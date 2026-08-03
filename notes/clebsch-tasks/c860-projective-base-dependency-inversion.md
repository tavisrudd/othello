# C860 — remove the paper Lean closures' dependency on the cap-game library

**Lane:** pending confirmation (`clebsch` proposed; the work edits shared
`RelativeConicArcs` infrastructure that `relconic`, `ame-lu`, and `cap` also use)

**Status:** queued; scoped 2026-08-02, superseding the original
"document the cap modules" framing

**Route decision (Tavis, 2026-08-03):** dependency inversion, staged per the
staging section below. Move the shared projective-plane vocabulary out of the
cap modules into `RelativeConicArcs` in stages; keep all cap-game material —
especially cap-game certificates — out of the finitegeom builds and paper
closures. Re-derivation is rejected.

**Sequencing and authorization (Tavis, 2026-08-03):** pegged to `clebsch` with
explicit cross-lane authorization for the cap-owned and shared
`RelativeConicArcs` edits and the affected foreign gate revalidations,
executed by sub-agents under the C855 management session. Stage 1 lands
immediately in the next free finitegeom build window; stages 2--4 execute as
one window with a single revalidation sweep; the C855 rename/gate/manifest
window runs only after that; Paper II repackaging under C577 waits for
stages 2--4. The general Paper II/III Lean plan review that follows C860 and
the hard Paper I parts is its own task, C861, not a C860 subtask.

**Q11Residual residue decision (Tavis, 2026-08-03):** the genuine cap-game
content in `RelativeConicArcs.Q11Residual` (with `Q9Terminal` and
`Q5SixArcExclusion`) is accepted for now: Paper I and the arcs paper keep
`CapGame.BuildGame`/`Mirror`/`GraphMirror` in their closures, and only those
three modules get the narrow to-standard audit as load-bearing dependencies.
Re-routing those claims off the game formulation may happen in the future but
is a bigger task, explicitly not now, and is not part of C860 or C855.

## Why this exists

The Paper II standards closure found that the four Paper II Lean gates import
eight `ProjectiveCap`/`CapGame` modules transitively. Those modules carry
scholarly-artifact debt — undocumented public declarations and internal
work-item references — that no Paper II work can clear.

Measuring the same dependency across every paper shows it is not a Paper II
problem. Of the gate modules in the workspace, roughly half have
`ProjectiveCap`/`CapGame` in their transitive closure:

| paper root | cap modules in closure |
|---|---|
| `clebsch-passages` (Paper III) | none |
| `golden-operator` | none |
| `mds_css_transversal_groups` | none |
| `ame_lu` | `BuildGame`, `PlaneTransitivity`, `Projective` |
| `beyond4_prs` | `BuildGame`, `PlaneTransitivity`, `Projective` |
| `q13-passant-code` (Paper IV) | `BuildGame`, `PlaneTransitivity`, `Projective` |
| `clebsch-factorization` (Paper II) | those plus `FrameGridBridge`, `Grid`, `GridGame`, `GridSeed`, `Sym2ConicBridge` |
| `equivariant-robust-completion` | same eight |
| `clebsch-rigidity` (Paper I) | those eight plus `Mirror`, `GraphMirror` |
| `arcs_complete_outside_conic` | same ten |
| `clebsch-hexagon-code` (fallback) | same ten |

Two of these are released (Paper I, the arcs paper) and one is in active
release preparation (Paper IV). The debt in the cap modules is roughly 110
undocumented scholarly-public declarations, plus three internal work-item
references in `ProjectiveCap.Sym2ConicBridge`.

The dependency enters through a small number of choke points:

- `RelativeConicArcs.ProjectiveBridge` → `ProjectiveCap.PlaneTransitivity`
  (this is what reaches AME/LU and Paper IV, through `CodingBridge`);
- `RelativeConicArcs.Certificate` → `ProjectiveCap.FrameGridBridge`
  (Paper II);
- `RelativeConicArcs.OddSixArcAffinePrism` → `ProjectiveCap.FrameGridBridge`
  (Paper I);
- `RelativeConicArcs.Averaging` → `ProjectiveCap.PlaneTransitivity`
  (the arcs paper);
- `RelativeConicArcs.Conic` → `ProjectiveCap.Sym2ConicBridge`.

## What is actually used

Across all of `RelativeConicArcs`, thirty-seven distinct cap declarations are
referenced from thirty-three modules. The heavy ones are the projective
coordinate-change transport `Projective.mapEquiv` and its lemmas, the
collinearity predicate `Projective.Collinear` with the determinant criterion
`FrameGridBridge.Coordinate.mk_collinear_iff_det_eq_zero` and the
independent-triple equivalences, the arc/cap predicate `Projective.Cap` with
`cap_mono` and `cap_map_mapEquiv`, and the Veronese conic bridge
`Sym2Bridge.conicForm`, `veronese`, `veronesePoint`, `OnConic`, and `lineEquiv`.

None of that is cap-game mathematics. It is ordinary projective-plane
vocabulary that the cap game happens to host. The only genuinely game-flavored
uses are `Projective.LegalExtensions` and `mem_legalExtensions`, confined to one
section of `RelativeConicArcs.ProjectiveBridge`.

## Two shapes

**Dependency inversion (recommended).** Move the used projective-plane
vocabulary out of the cap modules into a new referee-standard base module under
`RelativeConicArcs`, and have the cap modules import *that*. No declaration is
duplicated; the cap game becomes a downstream application of the shared plane
library rather than its host. Every paper closure loses
`ProjectiveCap`/`CapGame` at once, and the moved declarations get their
docstrings as part of the move rather than as a separate audit.

This edits cap-owned files, but only to relocate declarations and adjust
imports; it does not audit or rewrite cap's own mathematics.

**Re-derivation.** Prove the thirty-seven declarations again inside
`RelativeConicArcs` from Mathlib and leave the cap modules untouched. Avoids
foreign edits at the cost of two definitions of collinearity and of the cap
predicate in one repository, which will drift.

## Staging

1. Split the game-localization section out of
   `RelativeConicArcs.ProjectiveBridge` into its own module, so the
   `FiniteBuildGame` API leaves the paper closures. Measure which papers this
   alone clears.
2. Create the shared projective-plane base module and move the coordinate,
   collinearity, and cap-predicate declarations into it with docstrings.
3. Move the Veronese conic bridge.
4. Repoint the cap modules at the new base and drop every `ProjectiveCap`
   import from `RelativeConicArcs`.
5. Revalidate every affected reverse-import gate, not only Paper II's, and
   refresh each affected paper's checksum manifest and fingerprint.

## Open decisions for the user

- The lane peg. The edits land in shared `RelativeConicArcs` infrastructure and
  in cap-owned modules, and they change the release surface of Paper I,
  Paper II, Paper IV, AME/LU, and the arcs paper.
- Whether Paper II repackaging under C577 waits for this, or proceeds with the
  dependency recorded as a known closure defect.
- Whether stage 1 alone is worth landing immediately for AME/LU, Paper IV, and
  `beyond4_prs`, which only need the game API removed.
