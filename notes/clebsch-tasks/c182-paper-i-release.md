# C182 — immutable Paper I release

**Lane:** `clebsch`

**Opened:** 2026-07-15

**Status:** queued; local Paper I gates are complete, external publication
authority and credentials are unavailable in this workspace.

## Objective

Publish the C320-approved focused Paper I source, PDF, verification surface,
toolchain pins, and replay interface as one immutable citable artifact, then
insert its stable identifier into the manuscript.

## Current state

- Paper I has final independent `GO`.
- The focused human paper and computational companion are the release target;
  the mega-paper fallback is not.
- The manuscript already pins the shared formal repository and names the
  replay interface.
- No paper-code remote, immutable deposit, DOI, or Software Heritage
  identifier exists yet.

## Next action

With explicit user authority and publication credentials:

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
