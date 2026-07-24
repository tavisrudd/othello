# C545 — rapid beyond-four PRS preprint and DOI

**Lane:** `reed-solomon` · **Status:** queued after the second-draft proof gates; DOI publication
blocked for the current research-announcement artifact

## Objective

Publish a proof-complete Version 1 of the merged beyond-redundancy-four PRS work after the
referee-response gates in `papers/beyond4_prs/second-draft-fix-plan.md` close, creating a public
priority timestamp and DOI without creating a competing second publication or compromising later
journal submission.  The current fifteen-page research-announcement draft is not eligible for a
proof-complete release.

## Publication model

The release is a **preprint version of the same paper**, not a separately titled journal note.
It must use consistent authorship, title family, theorem map, and version history.  The later full
paper will cite and explicitly supersede Version 1.

Current general policy evidence permits this route:

- IEEE treats preprints on arXiv, TechRxiv, and approved not-for-profit preprint servers as not
  prior publication; TechRxiv supplies DOIs.
- Elsevier permits electronic preprints and allows authors to share them at any time, subject to
  journal-specific exceptions.
- Springer Nature states that posting a preprint is not prior publication.

These are general policies, not a substitute for the selected journal's current Guide for Authors.

## Work

1. Verify that the expanded manuscript, not the fifteen-page announcement, contains every
   priority-bearing theorem with enough proof detail to establish the claimed result independently.
   The contained-component, degree/deletion, ordered-Hessian, and `e_7` gates must be fully closed.
2. Run a claim/proof/citation audit and verify every computational statement against its committed
   reproducibility bundle.
3. Select the likely journal family before release and archive its current preprint/prior-
   publication policy with date and stable URL.
4. Prefer an exact same-file dual record:
   - TechRxiv for an IEEE-recognized preprint DOI and timestamp;
   - arXiv for the mathematical community and versioned dissemination.
   If the selected venue's guide makes that combination ambiguous, use its explicitly approved
   DOI-bearing preprint route instead.
5. Cross-link the identifiers and mark the document visibly as an unrefereed preprint.  Do not
   manufacture two titles, abstracts, or claims for the same result.
6. Preserve the exact released PDF/source/artifact bundle and checksums in
   `papers/beyond4_prs/`.

## Release gate

- The second-draft fix plan has no open proof-critical, classification-record, literature, or
  immutable-archive gate.
- The note is proof-complete for every theorem in its abstract.
- The claim-level trust ledger and adversarial proof-evidence audit are green.
- The statement-adequacy appendix reproduces every adopted Lean headline statement and exact
  paper-to-formal boundary.
- The paper contains a titled provenance and responsibility section.
- No result relies solely on untracked data or an unreviewed generated claim.
- All authors and affiliations are confirmed.
- The exact selected-journal policy is checked immediately before upload.
- The public metadata identifies the object as a preprint/technical report, not peer-reviewed
  publication.
- DOI, timestamp, version, source commit, artifact hashes, and public URLs are recorded.
- A paper-only fresh-history public export builds and replays from a clean checkout.  It includes
  tracked `flake.nix` and `flake.lock` files that resolve the exact `finitegeom` commit, every
  required external certificate-package commit, the Lean toolchain, and system dependencies
  without machine-local paths; its target lists and axiom audits name those same pins.  The
  development monorepo is not published or used as the public release repository.
- The later journal manuscript contains the required disclosure/citation and uses the preprint as
  an earlier version of the same work.

External upload and publication are irreversible public actions.  Prepare and validate the release
bundle first; publish only the exact reviewed artifact through the authorized account.

## Owned paths

- `papers/beyond4_prs/`
- the C545 policy/release report and immutable release manifest
- the `reed-solomon` handoff and lifecycle rows
