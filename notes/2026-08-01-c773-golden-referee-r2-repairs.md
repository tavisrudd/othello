# Golden quantum-statistics referee-round-two repairs

**Lane:** `golden`

**Date:** 2026-08-01

## Result

The second cold-referee package defects are closed except for the source-paper
access question, which the user explicitly removed from the next referee's
scope. The paper now ships a standalone evidence supplement, distinguishes
the rounded and full-precision optical netlists, and incorporates every
requested minor presentation repair.

No file exported under `papers/golden-quantum-statistics/` contains an internal
task identifier in its filename or text. The release verifier enforces this
boundary and rejects private dated-report paths.

## Manuscript repairs

- The Golden amplitude, Segre nulls, balanced characteristic polynomial,
  determinant perturbation bound, shot budget, and fidelity gates now have
  numbered equations.
- The balanced-spectrum proof derives the first trace from the displayed
  conference matrix and records the exact fourth-word trace
  `tr((C_0 D C_0 D)^2) = -42` that yields `tr(H^2) = 33/25` on all ten
  projective balanced supports.
- The complete three-cut protocol decoder is printed, while the supplemental
  certificate retains all six ten-sign words.
- Fidelity is explicitly the squared Uhlmann convention.
- The six-decimal angle table now claims the certified error
  `6.817741856623982e-7`; the supplemental full-precision netlist separately
  certifies `1.1371144305660282e-16`.
- Referee-response history was removed from submission-facing metadata.

The warning-free manuscript is thirteen pages. Its final source has 40,626
bytes and SHA-256
`486882a1092e09a5f03282a0a9310a7755759aad5fe9f16e10d9d88c675be534`;
the PDF has 119,415 bytes and SHA-256
`2bab40161ba09d7035fe9e5a93feba65a525b7d9956839c2324d5a3b3592dca6`.

## Standalone evidence package

The three frozen computational bundles were exported with mathematical,
publication-facing names under `verification/evidence/`. Each has a generator,
canonical JSON certificate, and independent replay. No private report or
repository-external dependency is included. `verification/EVIDENCE.md` states
the exact domain and trust boundary of each bundle.

`verification/evidence_certificate.json` now exposes the full decoder words,
three-cut signatures, path permutations, input phase signs, full-precision
Givens netlist, and separate rounded/full-precision reconstruction errors.
`verification/evidence_manifest.json` pins every load-bearing source,
certificate, replay, trust document, environment lock, Makefile, verifier, and
manuscript source. The manifest has 2,734 bytes and SHA-256
`ceb214c1b45c58b2ef5b26c7ad7c8befa23a551a1f94cc9464344678f8ee6f45`.

## Replay and trust boundary

From `papers/golden-quantum-statistics/`:

```text
python3 verification/verify.py --check
make verify-sources
make check
```

The compact verifier uses the Python standard library. The symbolic replay
uses the exact environment pinned by `pyproject.toml` and `uv.lock`. The three
independent replay programs are distinct from their generators. A copy of the
paper directory with repository-external paths excluded passes both the
compact gate and the full source replay, establishing that the supplement is
portable rather than accidentally importing the monorepo's `notes/` tree.

The evidence certifies the finite arithmetic, exact exchange-sector values,
decoder, and optical compilation. It does not certify experimental component
availability, literature priority, or the human orbit and rank proofs.

## Next cold-referee instruction

The next referee subagent should receive read access to the related paper
repositories under `~/src/math-papers/`, including the Clebsch source papers.
It should treat those local papers as available referee materials and must not
raise public posting or public-locator availability as a review concern. It
should still check theorem identity, marking, normalization, and citation
accuracy against those sources.

## Closeout: extra-juice and Tao pass

The closeout pass found two cheap structural upgrades and completed both:

1. The standalone-copy replay tests the actual portability claim rather than
   merely checking the package in its monorepo location.
2. The release verifier now rejects internal task identifiers and private
   report paths in exported filenames and text, preventing recurrence of the
   packaging defect.

The manuscript's new trace calculation also removes an avoidable hidden
finite step at the exact point a referee would test.

## Mystery ledger

- **Rounded versus full-precision optical accuracy — settled.** The exact
  evidence records both residuals and the prose assigns each claim to the
  correct representation.
- **Portable replay boundary — settled.** An extracted paper-only copy passes
  the compact verifier and all three generator/replay pairs.
- **Internal workflow leakage — settled.** No identifier remains in the
  exported tree, and the verifier enforces the rule.
- **Source-paper public locator — intentionally outside this task.** This is a
  user-owned publication action, not a mathematical mystery or a gate for the
  next local referee round.

No genuine mathematical mystery remains from this repair task.
