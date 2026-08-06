# C864 — Clebsch passages re-export, and an unregistered export area in finitegeom

**Lane:** `build-sys`

**Date:** 2026-08-05

## Summary

The quiet window opened, and the work it was holding turned out to be smaller than the card
predicted in one respect and blocked by a previously unrecorded defect in another.

The Clebsch passages area is re-exported and adopted in finitegeom.  The support-cubic orientation
rename had already reached finitegeom before this window, so the "atomic re-export and re-seal"
requirement no longer binds the export half; only the certificate package's forward re-pin remains.
Separately, the finitegeom modules that the card expected this window to repair belong to an export
area whose configuration has never been tracked in the monorepo, so no registered export can repair
them.

## The passages trust fact was stale, and re-extracting it unblocked the area

`lean-area-export.py ... clebsch_passages plan` refused with

```
refused: generated closure and import closure disagree:
import-only ['RelativeConicArcs.AlignedFamilyFaithfulness', 'RelativeConicArcs.AlignedQueryFamily'],
fact-only []
```

`lean-trust-extract.py plan --area relconic` reported `quiet window: yes`, so the fact was
re-extracted through the guarded single-unit path:

```sh
python3 lean/scripts/lean-trust-extract.py run --unit RelativeConicArcs.Gates.ClebschPassages
```

The regenerated `lean/trust/facts/RelativeConicArcs.Gates.ClebschPassages.json` gained 341 lines and
no deletions, carrying the two modules and their declarations.  Committed as `c822cef0`; the
exporter reads the fact from the source commit rather than the worktree, so the commit precedes the
export.

## The adopted passages delta

Exported from monorepo `c822cef0` onto finitegeom `1ec95df`, materialized twice with byte-identical
repeats, `prose_drift` empty, 289 modules in closure.  Forward delta of eighteen files:

| kind | paths |
|----------|--------------------------------------------------------------------------|
| added    | `RelativeConicArcs/AlignedTwoGraph.lean`, `AlignedQueryFamily.lean`, `AlignedFamilyFaithfulness.lean` |
| modified | `ClebschInvariantCubic.lean`, `ClebschPassagesCorrespondence.lean`, `Gates/ClebschPassages.lean`, `GoldenQuadraticCharacters.lean`, `InvolutiveOddUnit.lean`, `PetersenHarmonicKernel.lean` |
| modified | `TARGET_MANIFEST.json`, `lakefile.toml`, `PROVENANCE.md`, `README.md` |
| modified | `trust/CLEBSCH_PASSAGES.md`, `trust/ClebschPassagesAxiomAudit.lean`, `trust/areas/clebsch_passages.toml`, `trust/manifests/clebsch_passages.json`, `trust/source-manifests/clebsch_passages.json` |

The gate rebuilt green inside finitegeom through the guarded queue —
`RelativeConicArcs.Gates.ClebschPassages`, 2m12s wall, 3,432,916 kB peak, aggregate gate passed,
run `20260806-034904-71f3079f`.  Adopted as finitegeom forward commit `bb31411`.  A second export
against the adopted revision reports an empty delta over 24 planned files, which is the idempotence
check.

This delivers the signed two-graph core into finitegeom, which is also the first step of the
Paper I v2 sequence.

## The orientation rename had already reached finitegeom

The card records that finitegeom still carried the eleven `PaperIOrientation*` names at both the
pinned revision and its own `HEAD`, making the finitegeom re-export and the order-eleven package
re-seal one atomic window.  That is no longer the state.  finitegeom's `main` carries eleven
`SupportOrientation*` modules and zero `PaperIOrientation*`; the rename landed there on 2026-08-05
in `99aaf0f`, reapplied as `ac7e4ee`.  The support-cubic orientation export accordingly reports an
empty delta over 27 planned files.

The old names survive only at the revision the certificate package pins,
`85dfde9e`, which carries eleven `PaperIOrientation*` and no `SupportOrientation*` and is seventeen
commits behind finitegeom's `main`.  The package is therefore internally consistent and buildable as
it stands, and the breakage the card warns about occurs precisely when the package re-pins forward.

The consequence for sequencing: the export half of the atomic window is already done, so the
remaining work is the package's own forward re-pin, gate rebuild, axiom-audit refresh and re-seal.
That no longer has to share a window with an export.

## Registered area status after this window

| area | state |
|--------------------------------|-------------------------------------------------------|
| `clebsch_passages`             | re-exported and adopted this window; idempotent        |
| `clebsch_support_cubic_orientation` | already current; empty delta over 27 planned files |
| `clebsch_six_arc_concurrence`  | already current; empty delta over 33 planned files     |
| `mds_css_transversal_groups`   | current from the previous window                       |
| `golden_quantum_statistics`    | not on finitegeom `main`; exporting adopts a new area  |

`clebsch_six_arc_concurrence` is a registered area the card's step 11 does not list; step 11 names
four areas and there are five configurations under `lean/trust/export/`.

## An unregistered export area in finitegeom

finitegeom carries `RelativeConicArcs/Q11Residual.lean` and `RelativeConicArcs/Q11Coding.lean`, and
the card expects this window to refresh them and to add
`RelativeConicArcs/ParametrizedHoles.lean`.  No registered area can do so: neither module appears in
any of the five configurations' plans.

They belong to an area named `arcs_complete_outside_conic_human`, recorded only downstream in
finitegeom's `trust/source-manifests/arcs_complete_outside_conic_human.json`:

- root gate `RelativeConicArcs.Gates.ArcsCompleteOutsideConic`
- 77 sealed sources
- `source_commit` `10d1941a`, a monorepo commit dated 2026-07-28

There is no `lean/trust/export/arcs*` configuration in the monorepo, and none has ever been tracked
in its history.  The area's trust fact is also absent: `lean-trust-extract.py plan --area relconic`
reports `RelativeConicArcs.Gates.ArcsCompleteOutsideConic` as `[missing]`.

So a 77-source area of the published shared library was exported by a configuration that does not
exist in the authority tree and cannot be replayed from it.  This is the reproducibility hole that
C864's acceptance items 11 and 12 exist to catch, and it is why finitegeom's copy of `Q11Residual`
is the pre-split version: its imports are `RelativeConicArcs.ExampleChecks.Q11` and
`CapGame.GraphMirror`, predating the monorepo's game-free/game split, so it consumes a validity
predicate whose defining module was never exported.  finitegeom remains unbuildable standalone for
this reason.

Repairing it requires a deliberate decision rather than a mechanical export, because it means
constructing and tracking an export configuration for an area that was published without one, and
extracting a trust fact that has never been generated.  Nothing in the current window can
substitute for that.

### The arcs area is not the exception; it is the majority

Enumerating every area finitegeom seals against the configurations under `lean/trust/export/` shows
that most of the published library was exported without a tracked configuration.  finitegeom seals
eleven areas; four have a registered configuration here, and a fifth registered configuration
(`golden_quantum_statistics`) corresponds to no area on finitegeom's `main`.

| area | registered | modules | source commit | root gate |
|---------------------------------------|--------------|--------:|---------------|--------------------------------------------------------|
| `ame_lu`                              | UNREGISTERED |      68 | `10d1941a`    | `RelativeConicArcs.Gates.AMELUAggregate`                 |
| `arcs_complete_outside_conic_additions` | UNREGISTERED |    33 | `29c8946c`    | `RelativeConicArcs.Gates.ArcsCompleteOutsideConicAdditions` |
| `arcs_complete_outside_conic_human`   | UNREGISTERED |      77 | `10d1941a`    | `RelativeConicArcs.Gates.ArcsCompleteOutsideConic`       |
| `clebsch_factorization`               | UNREGISTERED |      37 | `10d1941a`    | `RelativeConicArcs.Gates.ClebschArithmeticGluing`        |
| `clebsch_rigidity_human`              | UNREGISTERED |      27 | `10d1941a`    | `RelativeConicArcs.Gates.ClebschRigidityTrust`           |
| `complete_ports`                      | UNREGISTERED |      31 | `77e5454b`    | `RepairPorts.Gates.CompletePorts`                        |
| `prs_beyond_redundancy_four`          | UNREGISTERED |      17 | `10d1941a`    | `RelativeConicArcs.Gates.PRSFoundation`                  |
| `clebsch_passages`                    | registered   |      17 | —             | `RelativeConicArcs.Gates.ClebschPassages`                |
| `clebsch_six_arc_concurrence`         | registered   |      26 | —             | `RelativeConicArcs.SixArcConcurrenceSpine`               |
| `clebsch_support_cubic_orientation`   | registered   |      21 | —             | `RelativeConicArcs.SupportOrientationSpine`              |
| `mds_css_transversal_groups`          | registered   |      66 | —             | `RelativeConicArcs.Gates.MDSCSSTransversalGeometry`      |

The seven unregistered areas seal 290 modules against 130 in the four registered ones.  Five of the
seven name the same source commit `10d1941a` of 2026-07-28, which is when the untracked export
apparatus was evidently used; the additions area names `29c8946c` and `complete_ports` names
`77e5454b`.

They span several lanes' deliverables — the AME/LU aggregate, both arcs areas, Clebsch
factorization, Clebsch rigidity, complete ports, and the beyond-four PRS foundation — so registering
them is not a build-sys-local edit.

The immediate consequence for the Dye audit is that the divergence is the same defect in another
area.  The monorepo proves both Dye statements as theorems in
`lean/RelativeConicArcs/Q11DyeAxioms.lean` (`dye1991_brianchon_bound` and
`dye1991_equality_classification` are `theorem` declarations), while finitegeom declares both as
`axiom` at the pinned revision `85dfde9e` and identically at its current `main`.  Those declarations
belong to `clebsch_rigidity_human`, an unregistered area, so finitegeom cannot be brought into
agreement with the monorepo's proofs by any registered export either.

The order-eleven certificate package is unaffected in the meantime: its gate closure no longer
reaches any order-eleven semantic module, following the umbrella-import removal in package commit
`d780520`, so it builds against a finitegeom revision carrying the broken copy.

## The order-eleven package cannot re-pin forward until the arcs area is repaired

With finitegeom `bb31411` published, the package re-pin was attempted: the revision was updated in
`lakefile.toml`, `lake-manifest.json` (`rev` and `inputRev`) and the README pin, and the eleven
`RelativeConicArcs.PaperIOrientation*` references in
`RelativeConicArcs/Gates/ClebschRigidityTrust.lean` — one import and the axiom-audit names — were
renamed to `SupportOrientation*`, all of which exist at the new revision.

The gate build then failed inside the dependency, not in package sources:

```
RelativeConicArcs/Q11Residual.lean:302:4: Unknown identifier `ProjectiveBridge.ParametrizedHoleValid`
RelativeConicArcs/Q11Residual.lean:326:17: Unknown identifier `ProjectiveBridge.isP_parametrizedHoles_iff`
RelativeConicArcs/Q11Residual.lean:322:31: unsolved goals
```

This is the predicted consequence of the unregistered arcs area, now demonstrated rather than
inferred: the two unknown identifiers are exactly what `RelativeConicArcs/ParametrizedHoles.lean`
defines, and that module has never been exported to finitegeom.  The expectation that the package's
gate closure avoids the order-eleven semantic modules after the umbrella-import removal in `d780520`
does not hold once the package pins a finitegeom revision whose own sources cannot compile.

The package therefore stays at its old pin until `arcs_complete_outside_conic_human` is registered
and re-exported.  The re-pin edits are left uncommitted in the package working tree
(`lakefile.toml`, `lake-manifest.json`, `README.md`, `RelativeConicArcs/Gates/ClebschRigidityTrust.lean`)
so they can be reused once the dependency is repaired.

## Upstream finitegeom does not yet match the monorepo on Dye

Upstream `main` resolves to `bb31411b9a74d93f74d89bc9fe06f68e343fc339`, confirmed by
`git ls-remote https://github.com/tavisrudd/finitegeom main`, which is the revision adopted in this
window.  At that revision `RelativeConicArcs/Q11DyeAxioms.lean` declares

```
47:axiom dye1991_brianchon_bound
55:axiom dye1991_equality_classification
```

while the monorepo proves both as `theorem` declarations.  The two trees do not agree, and no
registered export can make them agree, because those declarations belong to `clebsch_rigidity_human`.
Any axiom fact sealed from a package pinning this revision would record both Dye statements as
trusted inputs, which is no longer true of the mathematics.

## Two areas registered and re-exported

Both blocking areas are now tracked, replayable, and adopted.

**The human Arcs area.** Registration needed three fixes before the exporter would accept it.  The
gate `RelativeConicArcs.Gates.ArcsCompleteOutsideConic` audits 48 declarations but the registry
declared an empty terminal list, so the exporter refused the area outright and no terminal was
covered; each is now declared with the axioms extraction measured, 46 depending on `propext`,
`Classical.choice` and `Quot.sound` and two on `propext` and `Quot.sound` alone.  The candidate then
refused for a work-item identifier used as a noun in six docstrings of
`RelativeConicArcs/ExampleChecks/Q5.lean`, which is a referee-facing violation and was replaced by
the objects it denoted.  The forward delta adds `RelativeConicArcs/ParametrizedHoles.lean` and the
gate, and refreshes `Q11Residual.lean` and `Q11Coding.lean` to their game-free form.  The gate
rebuilt green inside finitegeom in 12m08s at a 9.8 GiB peak, adopted as `0974e45`.

**The human Clebsch rigidity area.** Its gate `RelativeConicArcs.Gates.ClebschRigidityTrust` was
declared in no area registry at all, which left 35 spine findings standing open against it.
Declaring the gate, its 48 terminals with measured axioms, and its extracted fact dropped the
repository-wide spine check from 161 findings to 126.  The extracted closure spans 94 modules and
declares no project axiom.  The forward delta refreshes `Q11DyeAxioms.lean` so both Dye statements
are theorems rather than axioms, and brings across the rigidity spine, the code-rigidity bridge, the
decoding synthesis and the Dye consequences.  The gate rebuilt green inside finitegeom in 17m19s at
a 5.7 GiB peak, adopted as `4571ee3`.

## An exporter defect: cited Lean modules were carried as apparatus

The Arcs export refused with `the candidate manifest entry for ProjectiveCap/Mirror.lean does not
match its bytes`.  The cause is an asymmetry between the two halves of the citation rule.
`dangling_citations`, which reports citations a release would not resolve, exempts `.lean`, `.md`,
`.toml`, `.lock` and `.nix` — a cited Lean module is covered by a closure and its manifest entry, not
by apparatus carriage.  `cited_apparatus`, which carries the files, applied no such exemption and
copied any cited path resolving under the source `lean/` root.

So a docstring naming another module by path caused that module to be copied in beside the closure,
overwriting whatever the destination sealed at that path while leaving the seal describing the
previous bytes.  The exporter's own manifest check then refused the candidate it had just built.
Both sides now apply the same exemptions, with a regression test asserting that a cited Lean module
is not carried.  The fix also removes a quieter hazard: exporting one area could silently rewrite a
module that area does not own.

## State at the end of this window

- Monorepo `c822cef0` carries the re-extracted passages fact.
- finitegeom `bb31411` carries the adopted passages delta, gate-green, and is published on `main`.
- The order-eleven package still pins `85dfde9e` in its committed state; its attempted forward
  re-pin is uncommitted and blocked on the arcs area.
- Four of five registered areas are current on finitegeom; golden quantum statistics is deliberately
  untouched.

## Open

- Publish finitegeom `4571ee3`, then rebuild, re-audit and re-seal the order-eleven package forward
  onto it, and update the monorepo's pinned copy of its fact and the Clebsch-rigidity trust manifest.
  Both blockers are cleared: the dependency now compiles, and its axiom fact will record the Dye
  statements as proved rather than trusted.  The `SupportOrientation*` renames and the revision
  updates the re-pin needs are already prepared, uncommitted, in the package working tree, and must
  be repointed from `bb31411` to the published revision before the rebuild.
- Register the five remaining unregistered areas: `ame_lu`, `arcs_complete_outside_conic_additions`,
  `clebsch_factorization`, `complete_ports`, and `prs_beyond_redundancy_four`.  The two done here
  give the pattern — declare the gate and its terminals from the gate's own audit list, extract the
  fact, write the configuration against the destination file names finitegeom already publishes,
  then export, build and adopt.
- Decide how the seven unregistered areas become registered, replayable exports.  This is the
  precondition for acceptance items 11 and 12, which cannot be satisfied while most of the published
  library has no configuration to replay.  It spans several lanes and needs its own scope decision
  rather than absorption into C864's owned paths.
- Through the registered `arcs_complete_outside_conic_human` area, repair finitegeom's stale
  `Q11Residual`/`Q11Coding` and missing `ParametrizedHoles`.
- Through the registered `clebsch_rigidity_human` area, replace finitegeom's two Dye `axiom`
  declarations with the monorepo's proved theorems, then re-derive the order-eleven package's axiom
  list from a fresh gate run rather than carrying the published one forward.
- Add a standalone finitegeom build to the export tooling as a gate, which is what would have caught
  the stale copy at export time rather than inside a consumer's build.
