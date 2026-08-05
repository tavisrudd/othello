# Shared pinned TeX toolchain and byte-reproducible manuscript gate

**Date:** 2026-08-04

This is the recipe the four Clebsch-series papers now follow, written so another
lane can apply it to its own paper root without rediscovering the failure modes.
It is a reference note, not a task: each paper root belongs to its own lane, and
adopting the recipe is that lane's decision and commit.

## What problem it solves

A release gate that compares a fresh manuscript build against the tracked PDF
byte for byte is the only check that catches a manuscript edit committed without
refreshing the PDF. That check is sound only when the build is deterministic in
both of its inputs:

- **The clock.** `SOURCE_DATE_EPOCH` plus `FORCE_SOURCE_DATE` fix the timestamps
  TeX and the PDF writer embed. The epoch is a normalization constant, not a
  claim about when the paper was written.
- **The toolchain.** A paper resolving TeX with `nix shell nixpkgs#...` takes it
  from the mutable flake registry, so the engine version — and with it the
  embedded producer string and font subset tags — changes whenever the registry
  moves. Paper I hit exactly this: its gate called a correct tracked PDF stale
  after the registry moved, and the obvious fix, regenerating the PDF, would have
  destroyed a good artifact and re-armed the same failure.

Pinning the clock alone leaves the second source of drift open, which is worse
than no check: it fails against correct artifacts.

## The recipe

1. **Copy the shared flake verbatim.** `papers/flake.nix` and `papers/flake.lock`
   go into the paper root unchanged. Every paper carries the same nixpkgs
   revision, so the authority tree, a standalone mirror, and another machine all
   build the same bytes. Do not fork the file for one paper's dependency: it
   already exposes a shell per capability set — `manuscript` (Python, full
   TeX Live, git, coreutils), `manuscript-cas` (adds Singular),
   `manuscript-cas-full` (adds Macaulay2), `manuscript-pdf` (adds
   poppler-utils), and `manuscript-sympy`. Enter the narrowest one the paper's
   verification actually needs; Nix realizes only the shell entered. If a paper
   needs a capability none of the shells provides, add a shell to
   `papers/flake.nix` and re-copy it to every paper rather than editing one copy.

2. **Point the Makefile at the pinned shell** and export the epoch:

   ```make
   export SOURCE_DATE_EPOCH = 1767225600
   export FORCE_SOURCE_DATE = 1

   LATEXMK ?= nix develop .\#manuscript --command latexmk
   LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
   ```

   The epoch above is the one the Clebsch papers use; any fixed value works as
   long as the Makefile and the checker agree.

3. **Adopt the manuscript checker.** Copy
   `papers/clebsch-passages/verification/check_manuscript_build.py` and change
   its `SOURCE`, `TRACKED_PDF`, and `EXPECTED_PAGES` constants. It copies the
   tracked source into a temporary directory, builds there with the pinned epoch,
   rejects TeX warnings, and requires the result to equal the tracked PDF byte
   for byte. `--update` refreshes the tracked PDF from that same deterministic
   build, and is the only supported way to regenerate it — a hand build without
   the pinned epoch produces different bytes and fails the check.

4. **Wire it into the release gate.** Add the checker to the paper's release
   allowlist (`release_files.json`) and call it from `verify_release.py`. Delete
   any older step that ran `make` in place: rebuilding the tracked PDF as part of
   verification means the gate can never detect a stale one, which is how two
   Paper III source commits shipped with a stale PDF and nothing objected.

5. **Run it once and expect a PDF change.** A paper previously built against the
   registry will produce different bytes on the pinned toolchain even when the
   page count and file size are unchanged, so refresh the tracked PDF with
   `--update`, inspect the changed pages, and then refresh every hash that
   records it — evidence fingerprints, trust manifests, and release-surface
   hashes — before calling the gate green.

## Mirrors

The paper exporter carries `flake.nix` and `flake.lock` into the standalone
repository like any other tracked file, so a mirror rebuilds the same PDF with no
extra step. Keep both files in the authority: a flake left only in a mirror is
mirror-only drift and blocks every later synchronization.

## Current adoption

Papers I--IV (`papers/clebsch-rigidity`, `papers/clebsch-factorization`,
`papers/clebsch-passages`, `papers/q13-passant-code`) carry the shared flake and
gate on byte equality. `papers/ame_lu`, `papers/golden-operator`, and
`papers/golden-quantum-statistics` still resolve TeX from the flake registry;
the two golden roots additionally pin no epoch. The Nofil work has no manuscript
root yet, so the recipe applies when one is created.
