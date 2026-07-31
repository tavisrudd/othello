# C182 — immutable Paper I release

**Lane:** `clebsch`

**Opened:** 2026-07-15

**Status:** external publication deferred behind queued C714; C713's structural
proof pass and the shared trilogy title-page refinement are synchronized, while
the companion pass must refresh the final release surface before publication.

## Objective

Publish the C320-approved focused Paper I source, PDF, verification surface,
toolchain pins, and replay interface as one immutable citable artifact, then
insert its stable identifier into the manuscript.

## Current state

- Every bounded issue from the 2026-07-30 v2 cold read is closed.
- The C713 authoritative source and receipt are frozen at `6e2446bd`; the
  standalone paper is forward-synced at `ea792bd`.
- Both paper trees independently pass all eighteen release checks.
- The aggregate q11 formal package now ships its axiom audit at `35808ac7`,
  and the manifest pins that exact commit.
- The focused human paper and computational companion are the release target;
  the mega-paper fallback is not.
- The manuscript already pins the shared formal repository and names the
  replay interface.
- No paper-code remote, immutable deposit, DOI, or Software Heritage
  identifier exists yet.

Cold-read report:
`notes/2026-07-30-paper-i-v2-referee-cold-read.md`.

## Next action

Complete C714 and freeze its synchronized human, computational, and Lean trust
surfaces. Then, with explicit user authority and publication
credentials:

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

Bounded-revision and local-gate report:
`notes/2026-07-30-c182-paper-i-bounded-revision.md`.
