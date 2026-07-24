# C287 first-tag referee review

**Lane**: `build-sys`
**Status**: FAILED EARLY; source boundary remains exact, public-prose blocker set expanded

## Result

The first referee-facing pass over all 26 module headers and the previously identified comment
blocks rejects the earlier seven-file rewrite estimate. The content-addressed source boundary
remains exactly 26 files and 8,954 code lines, but at least 17 modules contain private provenance,
workflow labels, status prose, or retrospective implementation language that cannot enter the
public artifact.

This is an early failed gate, not a completed whole-module review. Once the header and comment
failures were established, no source-owner module was edited and no claim was made that the
remaining declarations, names, or docstrings had passed semantic review.

## Definite rewrite set

The original seven files remain blocked:

- `ProjectiveCap/ConicLocalization.lean`
- `ProjectiveCap/EscapeParity.lean`
- `ProjectiveCap/FrameGridBridge.lean`
- `ProjectiveCap/GridMirror.lean`
- `ProjectiveCap/IntrusionCalculus.lean`
- `ProjectiveCap/PlaneOutcome.lean`
- `Sumfree/RankCounts.lean`

Ten further files fail the same referee-facing standard:

- `CapGame/Affine.lean` derives its presentation from unnamed private notes.
- `CapGame/BuildGame.lean` describes a Lean “scaffold” and a hypothetical future parser/checker.
- `ProjectiveCap/Almost/OddEscape.lean` presents declarations as open proof-search targets and
  labels an interface “legacy.”
- `ProjectiveCap/Binary.lean` describes the module as the start of unfinished bridge work.
- `ProjectiveCap/Grid.lean` cites projective-cap notes and narrates work not yet stated.
- `ProjectiveCap/GridCounting.lean` defines its scope by work at which it “stops short.”
- `ProjectiveCap/GridSeed.lean` describes its definitions as part of a frame-reduction “story.”
- `ProjectiveCap/Projective.lean` labels hypotheses as remaining obligations.
- `ProjectiveCap/StableFacts.lean` is framed as statement stubs to be proved later and retains
  superseded abstract scaffolding.
- `Sumfree/MirrorLemmas.lean` calls its contents the first formalization targets from private notes.

The mathematical limitations in these comments should be retained where they affect hypotheses or
conclusions. They must be stated directly, without plans, task history, private evidence, or
instructions to future proof search.

## Structural decisions for source owners

Two public path/name families require a source-owner decision rather than sentence-level cleanup:

- `ProjectiveCap/Almost/OddEscape.lean` and namespace `ProjectiveCap.Almost` encode partial-work
  status. A public mathematical namespace should identify the residual escape proposition rather
  than its place in a proof campaign.
- `ProjectiveCap/StableFacts.lean` and namespace `ProjectiveCap.Stable` encode development status
  and contain retained superseded interfaces. The owner must either remove unused interfaces from
  the first-tag closure or give the surviving propositions a mathematical module and namespace.

These decisions can change import paths and inventory hashes. C287 must not guess them or create a
public compatibility layer before the owning mathematical lane reviews the API.

## Documentation gate

The closure also has widespread non-private declarations without adjacent self-contained
docstrings. A mechanical declaration scan is useful only as triage: it cannot decide whether a
helper is scholarly-public or whether prose agrees with a theorem type. The acceptance gate is
therefore semantic and module-wide:

1. Every non-private declaration imported across the closure must be classified as
   scholarly-public or deliberately made private.
2. Every scholarly-public theorem and every non-obvious scholarly-public definition must have a
   self-contained docstring matching its elaborated type.
3. Strength-bearing names must be justified by their types; repository-local references must name
   only enduring verification artifacts.
4. The complete 26-file closure must be rescanned for private paths, task identifiers, workflow
   labels, status language, and indirect reverse references after the source-owner changes.

The first-tag closure is not referee-ready until this pass succeeds. Removing the known strings
alone is insufficient.

## Evidence boundary and next gate

The pass read all 26 module headers and exact surrounding comment blocks for every detected private
reference, task identifier, `WP-1`/`WP-2` label, and status phrase. It did not run Lean, Lake, a
generator, a build, a process probe, or an export. The seven named source paths were clean before
review, and no mathematical source was changed.

Source owners should rewrite the 17 files above, decide the two public path/name families, and
complete the module-wide declaration/docstring review. C287 then regenerates the content-addressed
inventory, verifies that every hash change is owned and reviewed, and repeats this gate before any
fresh-history source commit.

The dispatch-ready ownership split, deletion-first API recommendations, fallback names, and
per-module acceptance contract are recorded in
`notes/2026-07-24-c287-source-owner-rewrite-packet.md`.
