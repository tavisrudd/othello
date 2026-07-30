# C182 — immutable Paper I release

**Lane:** `clebsch`

**Opened:** 2026-07-15

**Status:** queued; the 2026-07-30 referee cold read requires a bounded
revision before the external publication gate.

## Objective

Publish the C320-approved focused Paper I source, PDF, verification surface,
toolchain pins, and replay interface as one immutable citable artifact, then
insert its stable identifier into the manuscript.

## Current state

- The prior independent `GO` is superseded by the 2026-07-30 v2 cold read.
- The six-nodal cubic attribution is repaired in authoritative commit
  `67a5a249` and standalone commit `cddeb19`.
- Before release, correct the rational \(A_5\)-module field-of-definition
  sentence, align the orientation theorem's computational/formal boundary,
  add the closest q13/two-graph literature, and integrate the v2 theorem
  into the novelty paragraph and conclusion.
- The focused human paper and computational companion are the release target;
  the mega-paper fallback is not.
- The manuscript already pins the shared formal repository and names the
  replay interface.
- No paper-code remote, immutable deposit, DOI, or Software Heritage
  identifier exists yet.

Cold-read report:
`notes/2026-07-30-paper-i-v2-referee-cold-read.md`.

## Next action

First close the bounded cold-read revisions and rerun the paper/companion
gates.  Then, with explicit user authority and publication credentials:

1. create the public paper repository/release package;
2. freeze the exact approved source, PDF, manifest, pins, licences, and
   replay commands;
3. archive that release under an immutable identifier;
4. independently unpack and replay it; and
5. add the identifier to the availability paragraph and rebuild the PDF.

## Acceptance

The public archive resolves, reproduces the approved Paper I surface in a
fresh directory, and is cited by the rebuilt manuscript.  No mutable URL or
local-only package satisfies C182.

## Boundaries and records

Do not include Paper II, Paper III, unused fallback claims, private workflow
records, or fallback-only evidence.

Full specification and final-report surface:
`notes/2026-07-15-c182-clebsch-artifact-archive.md`.
