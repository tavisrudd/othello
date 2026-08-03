# C855 step 1 — Paper I ownership and release-closure freeze

**Date:** 2026-08-02
**Lane:** `clebsch` (Paper I stream)
**Task:** C855 — Paper I Lean referee-artifact standards remediation
**Scope of this record:** checklist section 1 only (freeze ownership and the exact
release closure). No source, generated leaf, manifest, or manuscript was edited.

## Frozen roots

| role | repository | recorded state |
|---|---|---|
| manuscript authority          | `~/src/othello`                                  | `8c5437ef`, no dirty path under `papers/clebsch-rigidity` |
| Lean base package (authority) | `~/src/lean/finitegeom`                          | `HEAD = 0b3f37d264f54b52e6c703a75e2704a3f9cbe4b4`, clean |
| Lean base package (export)    | `~/src/lean/finitegeom-paper-i-base`             | `HEAD = 81227352974bf7d28f84cb6866936f842fb4de02`, clean |
| q11 certificate package       | `~/src/lean/finitegeom-clebsch-q11-certificates` | `HEAD = 09d8e174880e7370966da788da3c5d303df8af4f`, clean |
| standalone paper mirror       | `~/src/math-papers/clebsch-rigidity`             | not yet touched; downstream of the authority |

Working trees carry unrelated dirty paths belonging to other lanes (Paper III Lean
sources, `beyond4_prs`, `q13-passant-code`). None of them is Paper I-owned, and none
is staged or modified by this step.

## Status of the three audit-boundary commits

- `570086982b26075a71a331a81bb1b519e9a27e7f` — the audited base commit. It exists in
  `finitegeom` and is an ancestor of that repository's current `HEAD`. It is the
  commit pinned by the paper's trust manifest as `lean_repository.finitegeom_commit`.
  The base package has since advanced by other lanes' work, so the pinned commit and
  the current base `HEAD` are not the same tree.
- `81bae5e0eb02c26992f21b71808ef74a22e3b406` — the q11 source/gate commit. It is an
  ancestor of the q11 certificate package's `HEAD`.
- `09d8e174880e7370966da788da3c5d303df8af4f` — the q11 manifest-seal commit. It is
  exactly the q11 certificate package's current `HEAD`, and it is the commit recorded
  as `lean_repository.commit` in the paper's trust manifest.

Neither `570086982b26075a71a331a81bb1b519e9a27e7f` nor
`81bae5e0eb02c26992f21b71808ef74a22e3b406` is reachable from the export package
`finitegeom-paper-i-base`; that package is a filtered export rather than a branch of
either history, so it cannot be used to verify the audit boundary.

## Recomputed release closure

The Paper I public gate is `RelativeConicArcs.Gates.ClebschRigidityTrust` in the q11
certificate package. Its transitive import closure, recomputed from the gate root
rather than taken from the frozen figure, contains **198 project-owned modules**, not
188:

| namespace | modules in closure |
|---|---|
| `RelativeConicArcs` | 188 |
| `ProjectiveCap`     | 7   |
| `CapGame`           | 3   |

The frozen count of 188 therefore counted only the `RelativeConicArcs` namespace and
silently excluded ten modules owned by the projective-cap and cap-game lanes. Those
ten are genuinely inside the verification closure, reached through exactly three
crossing imports:

- `RelativeConicArcs.Certificate` → `ProjectiveCap.FrameGridBridge`, which pulls in
  `ProjectiveCap.Grid`, `ProjectiveCap.GridSeed`, `ProjectiveCap.GridGame`,
  `ProjectiveCap.PlaneTransitivity`, and `ProjectiveCap.Projective`;
- `RelativeConicArcs.Conic` → `ProjectiveCap.Sym2ConicBridge`;
- `RelativeConicArcs.Q11Residual` → `CapGame.GraphMirror`, which pulls in
  `CapGame.Mirror` and `CapGame.BuildGame`.

The closure also depends on 43 distinct `Mathlib` roots; no other external package
appears.

This changes the shape of checklist section 7. The contamination is not only that the
audited base commit happens to carry unrelated projective-cap and cap-game changes in
the same distributed repository. Ten modules of that foreign work are load-bearing
dependencies of the Paper I gate. Any narrow Paper I allowlist must therefore either
include and fully audit those ten modules to the same scholarly standard, or the three
crossing imports must be removed by relocating the shared content into the Paper I
closure under its own semantic names.

## The crossing imports are shared, not Paper I-local

Severing the three crossing imports is not a change Paper I can make on its own. Recomputing
the same closure from the other papers' gate roots in the base package shows that the
dependency is carried by the shared modules `RelativeConicArcs.Certificate` and
`RelativeConicArcs.Conic`, which several papers sit on:

| gate | reaches `ProjectiveCap.FrameGridBridge` | foreign modules | project-owned closure |
|---|---|---|---|
| `Gates.ArcsCompleteOutsideConicHuman`     | yes | 10 | 77 |
| `Gates.ArcsCompleteOutsideConicAdditions` | yes | 8  | 33 |
| `Gates.AMELUAggregate`                    | no  | 3  | 67 |
| `Gates.PRSBeyondRedundancyFour`           | no  | 0  | 16 |
| `Gates.ClebschRigidityHuman`              | no  | 0  | 10 |

The arcs paper therefore carries exactly the same ten foreign modules Paper I does, and
AME-LU carries three. Repointing `Certificate` or `Conic` is a change to `relconic`-owned and
`ame-lu`-owned verification surfaces and obliges revalidating every affected gate in one
quiescent window.

The proof work itself is small. Inside the ten-module foreign closure, `FrameGridBridge` is
reached for a single lemma: three coordinate-lifted points are collinear exactly when their
determinant vanishes, used ten times across four `RelativeConicArcs` modules. That lemma needs
only the collinear-versus-dependent dictionary and two independence helpers, all of which
could be reproved against `ProjectiveCap.Projective` and Mathlib, so severing it would remove
`FrameGridBridge`, `PlaneTransitivity`, `Grid`, `GridSeed`, and `GridGame` — five of the ten —
from every dependent closure at once. The remaining coupling through
`ProjectiveCap.Sym2ConicBridge` and `ProjectiveCap.Projective` is the ambient projective plane,
conic form, and Veronese embedding on which the whole `RelativeConicArcs` conic layer is built,
and is a relocation rather than a severance.

Consequently the decoupling is one coordinated shared-library relocation serving Paper I, the
arcs paper, and AME-LU together, with a separate owner and build window, rather than a step
inside the Paper I remediation.

## Recomputed proof-mode inventory

The paper-side trust surfaces confirm how far the artifact is from theorem-complete.

The computational companion's trust record declares five proof modes
(`human-structural-proof`, `published-theorem`, `lean-theorem`, `finite-certificate`,
`trusted-execution`) across thirteen claims. Their current distribution is: finite
certificate six, human structural proof three, trusted execution two, published theorem
one, Lean theorem one. Twelve of the thirteen companion claims therefore have no Lean
terminal at all.

The main paper's trust manifest carries nineteen claim rows. Every row is routed
`mixed` (seventeen rows) or `conceptual-cited-inputs` (two rows); no row is routed as a
pure Lean theorem. Their recorded trust boundaries name, among other residual
obligations, the two declared Dye consequences, the classical `3+3'` odd `A5` splitting
interface, the exhaustive execution over all 160,930 nonsingular conics, the complete
normalized enumerations and conic audit, the q=13 minimum-layer classification, and the
finite certificates for weight ten, the q=11 and q=13 seven-arc leaves, and the sharp
q=13, 17, 19 maximum-six assertion.

## Task-ID contamination in the distributed paper package

Eleven tracked files in `papers/clebsch-rigidity` carry internal task identifiers in
their filenames, all under `verification/`: the clique-structure script and its data,
the q13 weight-ten independent replay, profile script, and profile data, and the
terminal orbit DAG generator, compressed data, hash file, replay script, and replay
data, together with the finite-boundary manifest. These are part of the distributed
reproducibility apparatus and are named by the release verifier, so renaming them is a
coordinated change across the manifests, the verifier, the README, and the manuscript
prose rather than a file rename.

## What this step does not establish

No generated-leaf provenance, manifest reconciliation, docstring adjudication, gate
build, axiom audit, or release replay was run. Sections 2 through 11 of the C855
checklist remain entirely open.
