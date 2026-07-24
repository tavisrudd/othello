# C545 preprint and venue policy check

**Lane:** `reed-solomon` · **Date checked:** 2026-07-23

## Decision boundary

The provisional journal family is **IEEE Transactions on Information
Theory**.  This is a reversible planning choice, not an authorized
submission: the paper is about coding theory, its closest predecessor papers
appeared in that journal, and the journal's current scope expressly includes
coding theory.  Author confirmation, account authority, and a same-day policy
recheck remain mandatory before upload.

No external upload was attempted.  The proof-complete candidate still fails
the literature, aggregate-formalization, clean-export, immutable-manifest,
independent-reader, and author-confirmation gates.

## Current primary policy evidence

1. **Journal fit and arXiv.**  The IEEE Information Theory Society,
   *Information for Authors*, was read in full as rendered on 2026-07-23:
   <https://www.itsoc.org/it-trans/author-info>.  It places coding theory
   within scope, requires a strong conceptual or analytical contribution,
   gives a 50-page single-column submission limit and 25-page final
   two-column limit from 2025-05-01, and encourages authors to post submitted
   papers on arXiv.
2. **IEEE preprint status.**  IEEE Author Center, *Post-Publication
   Policies*, preprint and accepted-article sections, read in full as
   rendered on 2026-07-23:
   <https://journals.ieeeauthorcenter.ieee.org/become-an-ieee-journal-author/publishing-ethics/guidelines-and-policies/post-publication-policies/>.
   IEEE lists arXiv, TechRxiv, and PSPB-approved not-for-profit preprint
   servers and says posting there is not prior publication.  The same page
   states the replacement/copyright-notice obligations after acceptance.
3. **No duplicate refereed submission.**  IEEE Author Center, *Submission
   and Peer Review Policies*, prior-publication and electronic-reprint
   sections, read in full as rendered on 2026-07-23:
   <https://journals.ieeeauthorcenter.ieee.org/become-an-ieee-journal-author/publishing-ethics/guidelines-and-policies/submission-and-peer-review-policies/>.
   The work may not be simultaneously submitted to another refereed
   publication, and any prior related publication must be disclosed and
   cited.
4. **TechRxiv status.**  IEEE's current TechRxiv product page, read in full
   as rendered on 2026-07-23:
   <https://innovate.ieee.org/techrxiv/>.  It describes TechRxiv as a free,
   moderated, pre-review repository for unpublished work, says submissions
   are screened but not peer reviewed, and presents precedence as a benefit.
   The direct `https://www.techrxiv.org/` landing page returned HTTP 403 to
   this audit session, so account/submission availability was **not
   confirmed**.
5. **DOI semantics.**  Crossref, *Preprints*, read in full as rendered on
   2026-07-23: <https://www.crossref.org/community/preprints>.  Crossref
   requires preprints to be labelled as such, supports version relationships,
   and recommends a distinct DOI for each version.  This verifies the DOI
   metadata model, but it does not by itself prove that a particular
   TechRxiv upload path is currently operational.

## Route verdict

The journal-safe dissemination route is **arXiv plus the exact same-file
TechRxiv record**, with one title, abstract, author list, and claim set, only
if the TechRxiv submission service and DOI issuance are confirmed from the
authorized account immediately before upload.  IEEE's current policy
explicitly approves both servers.

The old plan's generic statement that “TechRxiv supplies DOIs” is not yet a
green operational gate: the direct service could not be reached in this
session.  Do not substitute an arbitrary DOI repository, because the IEEE
page approves only arXiv, TechRxiv, and other not-for-profit servers approved
by PSPB; approval of a substitute has not been established.

If TechRxiv remains unavailable, release on arXiv alone or obtain written
venue confirmation for another DOI-bearing server.  In either case, keep the
paper visibly labelled “unrefereed preprint,” cross-link later journal
metadata, and treat the preprint as Version 1 of the same paper rather than a
second publication.

## Upload-time recheck

- Confirm the author list, order, affiliations, ORCIDs, acknowledgements, and
  authority to use both accounts.
- Re-open the two IEEE policy pages and the journal author guide on the
  upload date.
- Confirm TechRxiv account access, moderation scope, DOI/version behavior,
  license, and withdrawal terms from the live submission interface.
- Compare the arXiv and DOI-bearing PDF hashes before either upload.
- Add the IEEE submission notice when the paper is submitted to the journal,
  and apply the accepted-version replacement/copyright rules if accepted.
