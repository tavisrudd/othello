# C545 — rapid beyond-four PRS preprint and DOI

**Lane:** `reed-solomon` · **Status:** queued immediately after C538; before the Lean closure chain

## Objective

Publish a concise, proof-complete Version 1 of the merged beyond-redundancy-four PRS work quickly
enough to create a public priority timestamp and DOI without creating a competing second
publication or compromising later journal submission.

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

1. From C538's frozen theorem map, produce a compact proof note containing every priority-bearing
   theorem and enough proof detail to establish the claimed result independently.  Omit extended
   exposition, optional sharpening, and unfinished redundancy-ten material.
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

- The note is proof-complete for every theorem in its abstract.
- No result relies solely on untracked data or an unreviewed generated claim.
- All authors and affiliations are confirmed.
- The exact selected-journal policy is checked immediately before upload.
- The public metadata identifies the object as a preprint/technical report, not peer-reviewed
  publication.
- DOI, timestamp, version, source commit, artifact hashes, and public URLs are recorded.
- The later journal manuscript contains the required disclosure/citation and uses the preprint as
  an earlier version of the same work.

External upload and publication are irreversible public actions.  Prepare and validate the release
bundle first; publish only the exact reviewed artifact through the authorized account.

## Owned paths

- `papers/beyond4_prs/`
- the C545 policy/release report and immutable release manifest
- the `reed-solomon` handoff and lifecycle rows

