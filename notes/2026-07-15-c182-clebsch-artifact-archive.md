# C182 — Immutable Clebsch computation artifact

**Date**: 2026-07-15
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **QUEUED — EXTERNAL ARCHIVE GATE**. Local preparation belongs to C168; minting a DOI
or publishing a release requires the user's external action or explicit authority.

## Referee trigger

A PDF-only adversarial review graded reproducibility `B`: the manuscript names every checker and a
Lean root, but does not tell a reader where an immutable copy can be obtained. This criticism is
correct. A repository-relative path is useful inside the source tree but is not a citable research
artifact.

The same review made three adjacent editorial requests. Two are already handled locally:

- the rigidity theorem now has a **Computer-assisted proof**, not a “Proof sketch”;
- Proposition 3.3 now proves syndrome transitivity from the `A5` action on the twelve conic rays
  and the scalar action within each ray; checker attestations have been moved outside proof
  environments;
- the hexad working note is no longer a mathematical dependency: the only identity used from it
  is derived directly from the manuscript's chord-defect lemma.

The archive/DOI request cannot be honestly simulated by prose and remains this task.

## Required artifact

Create an immutable release, preferably a GitHub release archived by Zenodo, containing:

- the exact manuscript source and rendered PDF;
- the eight-item computation manifest from C168, with every script at the recorded Git blob;
- the cited Lean root and the minimal tracked import closure needed to replay its claims;
- a top-level `README` giving environment setup, exact commands, expected PASS sentinels, typical
  runtime, and the distinction between strict-kernel Lean results and executable Python checks;
- license files covering code and manuscript/source redistribution;
- the commit hash, release tag, and machine-readable SHA-256 manifest.

After Zenodo mints the DOI, add a short **Data and code availability** paragraph to the manuscript
and cite the archived release, not a mutable branch URL.

## Exit gate

- C153/C161 have fixed final claim and attribution wording;
- C168 passes its clean-HEAD eight-source replay and PDF audit;
- release tag points to that exact clean commit;
- archive download is independently unpacked and replayed in a fresh directory;
- DOI resolves and the manuscript bibliography/availability paragraph names the same version;
- the final PDF is rebuilt after inserting the DOI.

Until these conditions hold, the manuscript should not claim that the artifact is archived.
