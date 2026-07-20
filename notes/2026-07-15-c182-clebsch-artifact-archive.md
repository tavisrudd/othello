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
- the C168 thirteen-source executable manifest (twelve replay commands), with every source at the
  recorded Git blob, plus the five cited Lean roots and their guarded elaboration commands;
- the five cited Lean roots and the minimal tracked import closures needed to replay their claims;
- a top-level `README` giving environment setup, exact commands, expected PASS sentinels, typical
  runtime, and the distinction between strict-kernel Lean results and executable Python checks;
  it must also document the `C01`--`C15` canonical-key order, print or point to the complete class
  listing, and map any renamed artifact paths;
- license files covering code and manuscript/source redistribution;
- the commit hash, release tag, and machine-readable SHA-256 manifest.

After Zenodo mints the DOI, add a short **Data and code availability** paragraph to the manuscript
and cite the archived release, not a mutable branch URL.

## Exit gate

- C153/C161 have fixed final claim and attribution wording;
- C168 has passed its clean-source thirteen-file executable replay, five-root Lean gate, and PDF
  audit;
- release tag points to that exact clean commit;
- archive download is independently unpacked and replayed in a fresh directory;
- the availability paragraph's paths match the frozen archive layout, including
  `check_low_degree_loci.sh` and `check_low_degree_loci.sing`;
- the primary scan confirms that Clebsch's configuration is correctly pinpointed at p. 336;
- the companion-paper citation is updated from “working paper, 2026” if an arXiv identifier or
  other stable public record exists at freeze time;
- DOI resolves and the manuscript bibliography/availability paragraph names the same version;
- the final PDF is rebuilt after inserting the DOI.

Until these conditions hold, the manuscript should not claim that the artifact is archived.

## Required durable report and standards

This file is both the cold-read task specification and the required final report. Complete it in
place with the exact archived commit/tag, packaging allowlist, file manifest, byte counts and
SHA-256 hashes, DOI/version, replay commands and results, independent unpack/replay evidence, paper
availability wording, and every deviation from the intended package. A chat summary, mutable branch,
local cache, or claimed successful upload is not evidence.

The public artifact must be self-contained for a referee. It must exclude task queues, handoffs,
agent/session records, private notes, machine-local paths, secrets, and workflow IDs unless a file is
itself indispensable scholarly evidence and has been rewritten for that audience. Public comments,
names, manifests, diagnostics, and provenance use mathematical/semantic language rather than C-task
history. Every manuscript claim names its actual trust route; archiving a checker or source does not
upgrade an external/computer-assisted claim to Lean-formalized.

## Required judgment-call record

Record every choice about package contents, exclusions, version/tag, durable repository, DOI
metadata, license, large-artifact handling, replay environment, source-versus-generated inclusion,
and failed or partial replay. For each give the options, chosen route, evidence, effect on referee
access and trust, rejected alternatives, and reopening condition. “Whatever Zenodo accepted” and an
unrecorded omission are not dispositions.

## Required closing review and archival checklist

**Reviewer-launch authority:** the implementing agent must not spawn, delegate to, select, simulate,
or substitute for the independent reviewer. After completing the artifact, durable report, checklist,
and proposed ledger delta, it must stop, keep the task live, and tell the user that the task is ready
for review. The user will launch Codex as the reviewer. After fixing review findings, the implementer
must stop again and ask the user to launch the post-fix review. Only a review explicitly launched by
the user counts toward the required final `GO`.


Keep C182 live until this checklist is complete. Explicitly request an independent referee-style
review of the frozen download, report, manuscript wording, and replay. Any finding or `NO-GO`
blocks task archival: fix it, mint/update the version when necessary, update hashes/report, and
request post-fix review. Only a recorded final `GO` permits C182 to be completed and archived.

- [ ] Identify the exact clean commit and immutable tag; prove all package inputs are committed.
- [ ] Define and record a reproducible packaging allowlist and verify that no internal workflow,
  secret, machine-local, build-cache, or unrelated Q25/foreign artifact is included.
- [ ] Record every archived path, semantic role, byte count, SHA-256, generator/schema relationship,
  and whether it is source, untrusted data, checker, replay, manuscript, or environment metadata.
- [ ] Run every documented verifier from the staged archive, not the working tree, then independently
  download/unpack and replay in a fresh disk-backed directory.
- [ ] Confirm generated evidence matches its final generator/schema and that hashes establish
  identity only; record the checker/soundness or external trust route establishing mathematics.
- [ ] Reconcile every paper claim and availability citation with C320's final trust ledger and the
  exact archived theorem/gate/checker paths.
- [ ] Confirm DOI, version, bibliography, public URLs, license, and availability prose all identify
  the same immutable object and that the final PDF was rebuilt from it.
- [ ] Complete the judgment-call record and state every excluded, failed, optional, or external
  component without implying completeness beyond the archived package.
- [ ] Record the independent reviewer, date, findings, fixes, post-fix review, and final `GO`.
- [ ] Only after final `GO`, archive the live task row together with this completed report.
