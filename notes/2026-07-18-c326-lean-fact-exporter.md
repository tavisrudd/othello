# C326 — the Lean fact exporter, and what the self-test settled

**Lane**: `build-sys`
**Date**: 2026-07-18
**Status**: extraction path built and validated against core Lean; project extraction still awaits a
quiet Lean worktree.

Plan: [`2026-07-18-c326-trust-spine-and-dependency-graph-plan.md`](2026-07-18-c326-trust-spine-and-dependency-graph-plan.md).
Phase A: [`2026-07-18-c326-trust-spine-phase-a.md`](2026-07-18-c326-trust-spine-phase-a.md).

## What was built

Phase A shipped the half of the spine that compares declarations with tracked bytes, and reported
`facts-missing` for all five declared gates because nothing extracted Lean's own view. This is the
other half.

`lean/scripts/trust-spine-export.lean` is a metaprogram over the resolved environment. It reports the
project-local module closure, every project-local declaration and which module defines it, every
declaration Lean represents as an axiom, the exact axiom set of each declared terminal via
`Lean.collectAxioms`, the constants each declaration's type and proof term mention, and any genuine
opaque boundary. It is never imported and belongs to no lake library, so nothing here changes package
boundaries.

`lean/scripts/lean-trust-extract.py` is the only component that puts Lean in the loop. It reads the
registry, wraps the exporter with one `import` of the extraction unit and one `#eval`, elaborates the
wrapper through `guarded-lean`, and canonicalizes the result into `lean/trust/facts/<unit>.json`.
`lean-trust-spine.py` stays read-only; a missing artifact remains a finding there rather than
something an audit can quietly fill in.

Canonicalization is deliberately on the Python side. The exporter reports in whatever order the
constant map yields, and the driver sorts, deduplicates, drops `uses` edges whose target is not a
listed declaration, and rejects output whose internal references do not resolve. Two runs over the
same environment therefore produce byte-identical artifacts, and the metaprogram stays small enough
to audit by reading it.

## The decision gate the plan flagged, resolved

The plan says to stop for review before deciding "whether declaration proof bodies are unavailable
and therefore make the theorem graph partial." They are available, and it is not partial.

The first self-test run reported 33 opaque boundaries among 49 core `Classical` declarations, and
every one of them was a theorem. The cause was a defect in this work, not a property of Lean:
`ConstantInfo.value?` hides theorem and opaque values behind its `allowOpaque` flag *by definition*
(`Lean/Declaration.lean:482`), so testing `value? (allowOpaque := false)` for emptiness classifies
every theorem as bodyless. Passing `allowOpaque := true` returns the proof term.

The corrected exporter treats only `opaque` declarations as boundaries. The evidence that proof terms
are genuinely reached, rather than merely requested:

```text
Classical.byContradiction : ¬¬a → a   uses -> Classical.propDecidable
```

That type names no `Classical` constant, so the edge exists only in the proof term. Both facts are
now assertions in `selftest` rather than observations in prose: a regression to type-level-only
extraction fails on the missing edge, and a regression to misclassifying theorems fails on the opaque
count.

Under this toolchain the exporter therefore records complete declaration-level dependencies for
theorems and definitions. Inductive types, constructors, and recursors carry type-level edges only;
they have no proof term to lose.

## Validating extraction without a build window

The project extraction that Phase A left open needs a quiet Lean worktree, and the tree currently
carries the `relconic` lane's in-flight Q25 work. Waiting is the only correct response to that. It is
not a reason to leave the extraction path itself unexercised.

`selftest` renders the same wrapper shape with no project import and elaborates it against core
`Lean` alone. It reads no project module and builds nothing, so it runs while another lane holds the
tree. It exercises the wrapper, the `#eval`, `collectAxioms`, the JSON write, canonicalization, and
the environment checks, and asserts a specific known-non-empty result rather than merely well-formed
output:

```text
selftest ok: lean 4.32.0-rc1
  49 declaration(s) under Init.Classical
  Classical.em -> Classical.choice, Quot.sound, propext
  uses edges: 41, opaque boundaries: 0
```

`Classical.em`'s axiom set is independently checkable with `#print axioms Classical.em`. When the
build window arrives, the only untested variable left is the project closure itself.

The driver also refuses to extract while `git status` shows changes under `lean/` outside
`lean/scripts/` and `lean/trust/`, naming the intruding paths. An extraction taken across another
lane's edits would describe a tree that exists at no commit. `plan` reports that state directly:

```text
quiet window: no — 7 foreign path(s)
```

## What this establishes and what it does not

It establishes that the extraction path runs end to end under
`leanprover/lean4:v4.32.0-rc1` with Mathlib `571b8a8e`, that terminal axiom sets come from the same
routine `#print axioms` uses, that proof-term dependencies are recorded, and that malformed,
environment-mismatched, or internally inconsistent exporter output is refused rather than written.

It does **not** establish anything about `RelativeConicArcs`. No project module has been extracted,
all five gates still report `facts-missing`, and every declared terminal-axiom set in `lean/trust/`
remains unverified. Phase A's findings 1–4 are untouched and still belong to their owning lanes.

**Trusted boundary.** The exporter trusts Lean's environment, which is the right authority for this
question, but it sees only what the extraction unit imports — a module no unit imports contributes
nothing, which is why the portfolio inventory units exist. Compiler-internal names are filtered from
nodes and edges alike, so the graph carries no edge to a declaration the artifact omits. The driver
verifies that a facts artifact matches the tree's pinned toolchain, the manifest's Mathlib revision,
and the tracked exporter's digest; an artifact that disagrees is refused, because it is a fact about a
different checkout rather than a weaker fact about this one.

## Replay

Working directory `/home/tavis/src/othello/lean`:

```text
python3 scripts/test_lean_trust_extract.py              # 36 hermetic tests, no Lean, no build
python3 scripts/lean-trust-extract.py plan              # declared units and quiet-window state
python3 scripts/lean-trust-extract.py selftest          # full path against core Lean; no project import
scripts/guarded-lean scripts/trust-spine-export.lean    # exporter elaborates against core Lean alone
```

Once the Lean worktree is quiet, extraction is:

```text
python3 scripts/lean-trust-extract.py run --area relconic
python3 scripts/lean-trust-spine.py audit
```

The wrapper actually elaborated for a unit can be inspected without running Lean:

```text
python3 scripts/lean-trust-extract.py wrapper RelativeConicArcs.Gates.Baer \
  --out /home/<dir>/wrapper.lean --raw-out /home/<dir>/raw.json
```

## Artifacts

| Path | SHA-256 | Bytes |
|---|---|---|
| `lean/scripts/trust-spine-export.lean` | `ce3851267ab4afcd5e15271d36219efdee0ccecf0bf01a003352b73d1df07baa` | 6100 |
| `lean/scripts/lean-trust-extract.py` | `6dc1d5c8c18ecb23d8efe20cea87ea6e6c1cae93dffe1cd5b9f31f6d475b664c` | 26488 |
| `lean/scripts/test_lean_trust_extract.py` | `921a96879f7bb5b85ac1faa1ebe5b76177f0a54679025e5a8695e18e188138bc` | 14637 |

No facts artifact is tracked yet; `lean/trust/facts/` does not exist, which is the state Phase A's
`facts-missing` findings describe. The exporter digest is embedded in each artifact the driver writes,
so a facts file produced by a different exporter is refused rather than trusted.

## Cross-checks

The hermetic suite builds throwaway trees, breaks exactly one thing per case, and asserts the
specific refusal: schema drift, facts labelled with the wrong unit, an axiom absent from the
declaration list, a declaration with no defining module, an unusable name, a `uses` object that is
not an object, a toolchain/Mathlib/exporter-digest mismatch, an exporter edited after extraction, a
hostile module name reaching a Lean literal, a `/tmp` scratch path, and a foreign edit in the tree.
Invariants covered: shuffled exporter output canonicalizes identically, non-project and self edges
are dropped, imports appear only in the wrapper header, and wrapper generation is deterministic.

The independent cross-check on the Lean side is `selftest`, whose expected values come from core
Lean rather than from this tool: `Classical.em`'s axiom set is what `#print axioms` reports, and the
`byContradiction` proof edge is checkable by reading the declaration's type.
