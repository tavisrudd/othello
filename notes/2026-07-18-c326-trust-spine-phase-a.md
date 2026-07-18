# C326 Phase A — declared-intent/Lean-facts trust spine, and what the pilot found

**Lane**: `build-sys`
**Date**: 2026-07-18
**Status**: Phase A landed except Lean extraction; Phase B blocked on a build window.

Plan: [`2026-07-18-c326-trust-spine-and-dependency-graph-plan.md`](2026-07-18-c326-trust-spine-and-dependency-graph-plan.md).

## What was built

`lean/scripts/lean-trust-spine.py` compares two things that the repository previously kept only in
prose: what reviewers *declare* about the trust boundary, and what the tree *exhibits*. Declarations
live in `lean/trust/` as TOML. Facts come from tracked bytes and — once a build window exists — from
a Lean environment export. Every check is a comparison between the two, and none of them promotes a
declaration into evidence.

Modes: `audit` (read-only comparison), `generate` (the only mutating mode), `graph` (canonical JSON),
`render` (Mermaid/DOT from that JSON), `check` (read-only regeneration plus byte comparison).

## Bounded findings from the RelativeConicArcs pilot

These are the substantive results. Each was established from the tracked source import graph, and
each is stated with its exact limit below.

**1. Fourteen handwritten `RelativeConicArcs` modules are outside all five declared gates.**

```text
Affine  Asymptotic  Averaging  BaerIncidence  CompletionDistance
OddSixArcAffinePrism  OddSixArcLineBound  OddSixArcPrismExtraction
ProjectiveTripleNormalization  Q11DecodingSynthesis  Q9Sylvester
SixArcDefectBridge  SmallKChordMoments  SmallKGeometricBridge
```

At least three carry theorems that `lean/RelativeConicArcs/TRUST.md` names in its axiom-audit
paragraph. `completeAffine_bound_eq_iff` is at `RelativeConicArcs/Affine.lean:57`, and the audit
paragraph claims "the complete-affine specialization and equality criterion" reports exactly
`[propext, Classical.choice, Quot.sound]`. No declared gate imports `Affine`, and no module in the
tree imports it either.

**2. `Gates.Baer` covers six of the twelve `FiniteGeom.BaerCompletion` modules.**

| In the gate closure | Outside it |
|---------------------|--------------|
| `BaerPlane`, `CollisionProfile`, `Obstruction`, `OrbitCounting`, `PairExtension`, `Secant` | `Clutter`, `Core`, `MultiInsertion`, `OrbitSaturation`, `RobustHole`, `Weighted` |

The Baer manifest's audit claim ranges over "the new lane and its `RelativeConicArcs` consumers",
and its stated validation command builds four targets (`FiniteGeom.BaerCompletion.CollisionProfile`,
`RelativeConicArcs.BaerArithmetic`, `RelativeConicArcs.QuadraticCollision`,
`RelativeConicArcs.Q25PairResult`) — none of which is `Gates.Baer`, the gate that
`lean/TRUST.md` names for that area. The manifest's claim is therefore broader than the gate the
portfolio index assigns to it. This resolves the plan's Baer coverage question mechanically; which
way to close the gap belongs to the `baer` lane.

**3. `RepairPorts/FunctionalCost.lean` is tracked but no lake target builds it.**

`lakefile.toml` declares no `RepairPorts` library and there is no `RepairPorts.lean` root. No gate
can reach it under any registry change, so nothing kernel-checks it.

**4. `DihedralSchreier/DensityAxioms.lean` declares a project-local axiom that
`lean/TRUST.md` does not list.**

`DihedralSchreier.DensityAxioms.primes_equidistribute`. The portfolio's named-classical-inputs table
records the Stichtenoth axiom but not this one. The other three project-local axioms in the tree
(two Dye, one Stichtenoth) are accounted for.

**5. Every generated data tree is `legacy-unverified`.** All fifteen declared `*Data`/`*Rows` trees
under `RelativeConicArcs/` lack a provenance header. Their tracked bytes have an identity; no
regeneration has been demonstrated. C324 owns changing that, and nothing in this work converts an
identity hash into a regeneration claim.

## What the computation does and does not establish

It establishes, over the git-tracked `*.lean` files under `lean/` at commit `36ccdff0`: the module
import graph as written in source headers; which modules are transitively reachable from each
declared gate module; which files sit in each declared data tree and whether they match a declared
member rule; and which source lines declare an `axiom` under which namespace.

It does **not** establish that any theorem is true, that any listed module was never checked, or
that a terminal collects a particular axiom set. Finding 1 says no *declared gate build* re-checks
those modules; someone may well have elaborated them directly or run `#print axioms` by hand. The
distinction the tool can make is between a claim covered by a standing gate and a claim that is not.

**Trusted boundary.** The source scanner parses import lines from file headers and follows
`namespace`/`end` pairs; it does not elaborate Lean, so `open`, `export`, macro-generated
declarations, and `section` interleaving are outside what it can see. Lean's resolved closure —
not this parse — is authoritative for trust, and it is unavailable until extraction runs. The
namespace-qualified axiom names are a corroborating signal, deliberately not the audit. Deriving a
qualified name from a file path would have been wrong: `RelativeConicArcs/Q11DyeAxioms.lean`
declares into `RelativeConicArcs.ClebschDye`.

## Replay

Working directory `/home/tavis/src/othello/lean`:

```text
python3 scripts/lean-trust-spine.py audit          # read-only; exits 1 while findings remain
python3 scripts/lean-trust-spine.py check          # read-only regeneration + byte comparison
python3 scripts/lean-trust-spine.py graph --out /home/<dir>/graph.json
python3 scripts/lean-trust-spine.py render --format mermaid --view data-provenance
python3 scripts/test_lean_trust_spine.py           # 45 hermetic tests, no Lean, no build
```

Findings 1 and 2 replay directly:

```text
python3 - <<'PY'
import importlib.util, sys
from pathlib import Path
spec = importlib.util.spec_from_file_location("ts", "scripts/lean-trust-spine.py")
m = importlib.util.module_from_spec(spec); sys.modules["ts"] = m; spec.loader.exec_module(m)
reg = m.load_registry(Path("trust")); inv = m.scan_sources(Path("."), reg)
cl = m.source_closure(inv, ["RelativeConicArcs.Gates.Baer"])
allb = {f.module for f in inv.files if f.module.startswith("FiniteGeom.BaerCompletion")}
print(sorted(allb - cl))
PY
```

## Artifacts

| Path | SHA-256 | Bytes |
|---|---|---|
| `lean/scripts/lean-trust-spine.py` | `2f0db2bcc65e0f0f3d406e937914e18e63e16a99394b67d06599841bbb58cf9c` | 69248 |
| `lean/scripts/test_lean_trust_spine.py` | `adb782c25030f8cc61b1a35fdbd6b2a649d9afeff25219b9df17b1c8f02337dd` | 25198 |
| `lean/trust/portfolio.toml` | `7b0321d5e4f60226a6e2df9324d23853332fc42fb94a285105e22d9125c3a12b` | 3952 |
| `lean/trust/areas/relconic.toml` | `a2c46951c3c25c00df50ebf978c91ad211595c3d8bb6928efc595a8cdac90bb4` | 11777 |
| `lean/trust/graph-manifest.json` | `2cad91d249127aecc85039594e220b37e0c27ae42c0b0709989c553ee710905a` | 490 |
| `lean/trust/PORTFOLIO.md` | `29681d4de3f1acc818c1943b450b4438b2915a67cfd5e7b76fee481094149161` | 12718 |

The canonical graph itself is **not tracked**. It is 12,044,457 bytes and its content changes
whenever the module topology does, so tracking it would put a large churning blob in every diff.
`graph-manifest.json` pins its canonical SHA-256, byte count, and node/edge counts by kind, and the
graph regenerates from the command above. `check` rebuilds the graph and compares digests, so a
stale graph is caught exactly as it would be if the bytes were tracked. **This departs from the
plan's "canonical graph JSON is tracked" wording and is offered for review.**

## Cross-checks

Adversarial tests are the cross-check available at this stage. `lean/scripts/test_lean_trust_spine.py`
builds throwaway git-backed Lean trees, breaks exactly one thing per case, and asserts the specific
code that fires: an axiom in a module outside every gate; a terminal collecting an area-permitted
but terminal-unexpected axiom; a terminal in no gate; a multi-gate terminal being *accepted*; a new
unclassified library; a module outside every library; untracked, unmatched, and missing data-tree
leaves; a missing generator and a generator digest mismatch; malformed, duplicated, nested,
unclosed, undeclared, and hand-edited Markdown regions; a stale graph while docs match; and that a
renderer cannot alter the canonical artifact. Invariants covered: two `generate` runs are
byte-identical, `check` leaves `git status` unchanged, `audit` never writes, and a body-only proof
edit does not invalidate the graph manifest.

Two defects in the tool were found by these tests and fixed: a library the lakefile builds but the
registry does not classify was being reported as "not built at all", and the axiom source signal
originally derived qualified names from file paths.

## Not delivered

- **Lean fact extraction.** No exporter has been run, so all five gates report `facts-missing` and
  every terminal-axiom claim in `lean/trust/` is unverified. This is the intended failure state, not
  a pass. It needs a build window and a quiescent Lean worktree; the tree currently carries the
  `relconic` lane's in-flight Q25 residual work.
- **Terminal declarations beyond two.** Only `Certificate.check_sound` and
  `Q25AllProfiles.pair_extension` have namespace-confirmed fully-qualified names. The rest of the
  manifest's named theorems are deliberately absent from the spine: a guessed name would produce a
  green check for a declaration that does not exist.
- **Phase C/D.** Strict provenance, regeneration, and portfolio rollout are untouched.

## Decisions taken, and one to review

Taken: the classification boundary is read from `lakefile.toml`'s `lean_lib` entries rather than
restated, so a new top-level area cannot appear without being classified or reported; extraction
units are gates plus optional inventory units, which lets the portfolio inventory reach modules no
gate imports without a second mechanism; the graph is topology-only.

For review: tracking the graph manifest rather than the canonical graph JSON, described above.

## Open frontier

Findings 1–4 are defects in other lanes' declared state, not in this tooling. Under cross-lane
hygiene, `build-sys` reports them and does not fix them. Finding 1 needs the `relconic` lane to
either add the modules to a gate or narrow the manifest's audit paragraph; finding 2 needs the
`baer` lane; finding 4 needs `dihedral`.
