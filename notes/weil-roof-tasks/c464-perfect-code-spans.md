# C464 — perfect-code spans of the cross-sheet QR designs

**Context:** parallel and non-blocking; promoted from the C452 executor's post-closure probe (see
the 2026-07-21 perfect-code entry in the crowns discovery track). C452 certified the two
cross-sheet disjointness designs as QR difference sets `(7,3,1)` and `(11,5,2)`; the probe
indicates their cyclic incidence spans are the perfect binary `[7,4,3]` Hamming code over `F_2`
and the perfect ternary `[11,6,5]` Golay code over `F_3`. This card makes that durable.

## Inputs

- C452 bundle (`notes/2026-07-21-c452-qr-barker.md` and its certificate/JSON) — canonical
  translation, difference sets, and frozen sheet reconstruction
- C450 bundle — certified modular ranks of the cross matrices, consumed only as the independent
  rank cross-check
- C406 canonical matching-orbit certificate, pinned by SHA, as in C452

## Task

Over `F_2` at `q=7` and `F_3` at `q=11`, certify the cyclic incidence spans of the disjointness
designs: rank, minimum distance, and the complete weight distribution, all computed exhaustively.
Certify the perfection (sphere-packing) equalities exactly, and identify the `q=7` span with the
`[7,4,3]` Hamming code by an explicit generator-matrix equivalence. Cross-check every rank against
C450's certified modular nullities and state agreement or a blocker.

Also record the complementary (shared-edge) spans at both primes in the same characteristics, so
the design/complement pair is covered once and completely.

Deliver a C452-style atomic bundle: dated report, exact generator/checker, canonical JSON with all
matrices, distributions, and equalities, checksum manifest, and an independent replay.

## Boundaries

- The van Lint–Tietäväinen classification is consumed only as C452 scoped it: a cited wall with
  literal hypotheses. No new classification or nonexistence claim.
- The symmetry door — `GL_3(2)` on the Hamming code and `M_11`/`L_2(11)` on the ternary Golay
  code against the frozen actions — is the named successor, pre-allocation gated. Do not certify
  equivariance here; one discovery-log entry per incidental observation, no card expansion.
- Compute, never recall: every distribution, distance, and equivalence is computed, not cited.
