# C545 final-reader, export, and DOI release gates

Date: 2026-07-24

## Decision

**NO-GO for public release.**  The local candidate and clean paper-only build
gate are green, but publication remains blocked on two independent specialist
signoffs, a publicly fetchable and flake-pinned Lean revision, author metadata
and account authority, an immutable paper-export repository/archive, and the
live DOI-bearing submission record.  No upload, repository publication, tag,
archive registration, or DOI request was attempted.

## Closed in this pass

- The title page now identifies the document as
  `Unrefereed preprint, Version 1`.
- The PDF build sets a fixed `SOURCE_DATE_EPOCH` and
  `FORCE_SOURCE_DATE=1`.  Two independent clean rebuilds produced identical
  bytes.
- A paper-only archive of commit `a7ac1e83` rebuilt from clean source and
  passed the 57-artifact local verifier.  The resulting PDF has 43 pages,
  306748 bytes, and SHA-256
  `fb3dd8d477e96af1854d51d0a6153f8046d9f11519ad0d92abcf6b21c675cf3e`.
- `supplement/FINAL-READER-SIGNOFF.md` names the exact mathematical and
  computational checks required from the two independent readers.
- `python3 supplement/verify.py --release` is fail-closed.  It requires the
  public repository, tag, commit, Lean revision, archive, DOI, released PDF,
  and two green reader records; it also requires the public Lean revision to
  occur in the flake lock.
- The unused Q25 certificate-repository dependency was removed from the
  release contract.  Every certificate used by the adopted theorem set is
  paper-local, so no external certificate-package input belongs in the
  release flake.
- The IEEE/TechRxiv policy was rechecked.  IEEE still permits arXiv and
  TechRxiv preprints and does not treat them as prior publication.  TechRxiv's
  direct service still returns HTTP 403 from this environment, so live
  account access and DOI issuance remain unconfirmed.

## Failed preflight that exposed the repair

The first clean paper-only export rebuilt to a PDF six bytes longer than the
tracked candidate.  The existing release-manifest check correctly rejected
the stale hash.  The difference came from an unpinned PDF build identity, not
from manuscript content.  Pinning the source date made subsequent clean
rebuilds byte-identical.

## Remaining gates

1. Publish the formal verification repository at a reviewed immutable commit,
   add that exact revision as a `finitegeom` flake input, refresh the lock, and
   run the aggregate Lean gate from the public checkout.
2. Freeze the exact paper-export commit and PDF hash, then obtain both
   independent specialist verdicts recorded by the signoff file.
3. Confirm author name/order, affiliation, ORCID, acknowledgements, license,
   and authority over the arXiv and TechRxiv accounts.
4. Create the paper-only fresh-history public repository and immutable source
   archive, then fill the repository, tag, commit, archive, hash, and byte
   fields.
5. Recheck the live IEEE and TechRxiv policies from the authorized account.
   Upload the identical author-approved PDF and metadata only after explicit
   authorization, then record and cross-link the arXiv identifier and DOI.

The two advertised GitHub verification repositories were not anonymously
fetchable during this pass.  Their current revisions therefore cannot be
treated as public immutable inputs.

## Vibe check

The release engineering is materially stronger: a real nondeterminism bug and
an unused external dependency were caught before publication, and the public
gate now fails mechanically instead of relying on prose.  The remaining
blockers are genuinely external and identity-bearing, not another local
manuscript-polish loop.
