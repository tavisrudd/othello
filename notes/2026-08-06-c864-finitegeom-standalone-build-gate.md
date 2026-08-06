# C864 — the standalone finitegeom build, and what it found

**Lane:** `build-sys`

**Date:** 2026-08-06

Phases 1 and 2 of the export-completion execution plan
(`2026-08-06-c864-export-completion-execution-plan.md`) are complete. The gate that phase 2 asked
for — build finitegeom on its own, before any package pins it — found that finitegeom had never
built standalone at all, for two independent reasons. One is fixed here; the other is a defect in
the projective-cap area, which this plan excludes and another lane owns.

## What was done

**Stale build residue swept** (phase 1 step 4). A build output whose Lean source no longer exists in
its root was deleted, and nothing else: 264 files and 28.4 MB across the monorepo (11 modules), the
finitegeom repository (13), and the order-eleven certificate package (9). The measurement matched
the figures the plan recorded. A re-run of
`lean-certificate-portfolio-audit.py --build-artifacts` reports no built module without a source in
any of the three roots. The build owner was free before and during the sweep.

**Golden quantum statistics adopted into finitegeom** (phase 1 step 6). The area exported to a
twelve-file delta, its gate `RelativeConicArcs.Gates.GoldenQuantumStatistics` built green inside
finitegeom, the delta was adopted as one forward commit, and the re-export is empty. All twelve
configured areas now report an empty forward delta against the current monorepo and finitegeom
commits, so every registered area is idempotent and finitegeom carries a counterpart for every
export configuration.

**The order-eleven pending-family entry removed** (phase 1 step 7). None of the seven modules
carries a generated banner, which was the decision's stated falsifier, so the entry naming them was
removed and the seven stay in the shared library. `lean-certificate-boundary.py` is green.

## The two guards phase 2 asked for

**A package module colliding with the pinned shared library is now rejected.** Lean module names are
global across a dependency graph, so a package defining a name its own dependency defines makes that
name ambiguous in every consumer, and no source-level ownership rule sees it because each repository
is internally consistent on its own. `lean-certificate-boundary.py --verify-official-libraries`
now compares a package's modules — those its manifest seals and those merely present in its tree —
against the module set of the exact revision it pins, read from the shared-library checkout rather
than from a resolved build directory, so the check holds before anything is built. It refuses a
package whose `lakefile.toml` and `lake-manifest.json` disagree about which revision that is, since
then there is no pinned revision to compare against.

On the real tree the rule fires on eight modules of the order-eleven package: the seven theory
modules and the gate `RelativeConicArcs.Gates.ClebschRigidityTrust`. These are the exact collisions
of 2026-08-06, and they clear when phase 3 commits the package's deletions and its gate rename and
reseals the manifest.

**An export that would not resolve as a repository of its own is now refused.** The area exporter
checks the candidate for a library root whose module file is absent, a module rooted by two
libraries, and an import naming a module the subset does not carry. A gate build sees none of these
because it elaborates only its own closure. The check is static, so it runs on every export rather
than waiting for a build window.

**A root-insertion defect was the cause of the first failure.** `insert_lakefile_roots` searched for
the named library's `roots = [` list with a pattern that ran past the end of that library's section,
so a library declaring no roots donated its modules to the next library that declared any. That is
how ten repair-code and eight repair-port modules became roots of the relative-conic-arcs library
and three capped-game modules roots of the projective-cap library. The search is now anchored to the
named library's own section, and a library with no roots list is refused as the docstring always
said.

Each of the two rules has adversarial fixtures. `test_lean_certificate_boundary.py`,
`test_lean_area_export.py` and `test_lean_trust_spine.py` all pass.

## What the standalone build found

finitegeom declares seven default targets. Building them through the guarded queue against the
finitegeom root failed immediately on the first one, before any module was elaborated:

```
failed           Sumfree
  ! error: Sumfree: some modules have bad imports
```

Four libraries — `Sumfree`, `CapGame`, `RepairCodes`, `RepairPorts` — declared no roots at all, so
each took its own name as its single root and named a top-level module file the repository does not
carry. Their modules were roots of unrelated libraries instead, by the insertion defect above.
Every library now declares its own roots, no module is a root of two libraries, and no root names an
absent module.

Six of the seven targets then build green: `Sumfree`, `CapGame`, `FiniteGeom`, `RepairCodes`,
`RepairPorts` and `RelativeConicArcs`.

## The remaining failure: the projective-cap library does not compile

`ProjectiveCap` fails to elaborate:

```
error: ProjectiveCap/Mirror.lean:203:22: Invalid argument name `K` for function
error: ProjectiveCap/Mirror.lean:204:9: Invalid argument: Variable `InitialPStatement`
       is not a proposition or let-declaration
```

`InitialPStatement` is declared in `ProjectiveCap.ProjectiveCapGame`, which finitegeom does not
carry. Comparing every projective-cap module against its monorepo authority shows nine modules whose
export dropped an import line, six of them dropping an import of a module finitegeom does not carry:

| finitegeom module | dropped import that resolves nowhere |
|---|---|
| `ProjectiveCap/Binary.lean` | `ProjectiveCap.ProjectiveCapGame` |
| `ProjectiveCap/Mirror.lean` | `ProjectiveCap.ProjectiveCapGame` |
| `ProjectiveCap/EllipticMirror.lean` | `ProjectiveCap.PlaneTransitivityGame` |
| `ProjectiveCap/FrameGridBridge.lean` | `ProjectiveCap.PlaneTransitivityGame` |
| `ProjectiveCap/GridMirror.lean` | `ProjectiveCap.PlaneTransitivityGame` |
| `ProjectiveCap/StableFacts.lean` | `ProjectiveCap.PlaneTransitivityGame` |

The shape is a game-free/game split like the one the order-eleven residual received: the
game-carrying modules were left behind, but the modules depending on them were carried with only
their import line removed, so they reference declarations that no longer exist. The static
resolution gate cannot see this — there is no dangling import, only a missing declaration — which is
why the plan was right to require a real build.

This is mathematical content of the projective-cap area. It has no export configuration under
`lean/trust/export/`, the projective-cap externalizations are out of this plan's scope, and the
repair needs a determination about which side of the game-free split each declaration belongs on.
It is therefore recorded rather than repaired here, and it is the one target that keeps the
standalone build from being green.

The thirteen `trust/*AxiomAudit.lean` modules belong to no library and so are built by no target.
They are elaborated during export validation, not by `lake build`, so this is a coverage
observation rather than a defect.

Two further coverage gaps surfaced while reviewing the projective-cap repair
(`2026-08-06-c864-projectivecap-standalone-repair.md`), both predating it. `TARGET_MANIFEST.json`
describes itself as content-addressing the complete reviewed library state, but six modules —
`RelativeConicArcs.ClebschFamilyRegimes`, `.CodeArcDictionaryTransport`,
`.ComplementaryTriangleSign`, `.ConicFillingOrderElimination`, `.GoldenOrderConductorTwo` and
`.PartialLinearSpaceCodeWeight` — are present in the tree and absent from its `sources` list, so
their bytes are sealed by nothing. The same six are roots of no library, so a target builds them
only if something a root imports reaches them. Whether each is live content or residue is not
established here.

## Replay

```sh
python3 lean/scripts/lean-certificate-portfolio-audit.py --build-artifacts \
  ~/src/othello/lean ~/src/lean/finitegeom ~/src/lean/finitegeom-clebsch-q11-certificates
python3 lean/scripts/lean-build-queue.py build \
  Sumfree CapGame ProjectiveCap FiniteGeom RepairCodes RepairPorts RelativeConicArcs \
  --lean-root ~/src/lean/finitegeom --cores 20-23
python3 lean/scripts/lean-certificate-boundary.py --verify-official-libraries
cd lean/scripts && python3 -m unittest \
  test_lean_certificate_boundary test_lean_area_export test_lean_trust_spine
```

The twelve-area idempotence loop is the one printed in the execution plan's phase 1, run with the
current monorepo and finitegeom commits.
