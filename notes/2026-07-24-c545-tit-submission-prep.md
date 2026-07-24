# C545 IEEE Transactions on Information Theory submission preparation

Date: 2026-07-24

## Result

The selected journal target is the *IEEE Transactions on Information Theory*.
A venue-specific, single-column IEEEtran review manuscript and author-ready
submission packet now build from the same mathematical sources as the
canonical preprint.  No ScholarOne action, journal submission, preprint
upload, or public release was attempted.

## Current TIT requirements checked

- Submitted manuscripts must use a single-column review format and, from
  2025-05-01, may not exceed 50 pages without prior editor-in-chief approval.
- The abstract must be one self-contained paragraph of at most 250 words,
  without abbreviations, citations, displayed equations, or tables.
- Five to ten index terms are required.
- The corresponding author must have an ORCID linked to the journal's
  ScholarOne account.
- Supplementary material intended for publication must be submitted with the
  manuscript so that it is peer reviewed.
- IEEE requires AI-generated article content to be disclosed in the
  Acknowledgment, identifying the system, affected content, and level of use.
- A final accepted manuscript is ordinarily limited to 25 two-column pages.

## Changes

- Extracted one shared 228-word abstract, six index terms, and the
  Acknowledgment into `frontmatter/`.
- Replaced the abstract's unexplained `MDS` abbreviation by
  “maximum-distance-separable” and made the redundancy-seven scope explicit
  as an all-field syndrome classification with a separate radius gate.
- Identified OpenAI Codex and stated that drafting assistance affected prose
  throughout the manuscript and electronic supplement.
- Added `main-tit.tex`, an IEEEtran one-column driver with IEEE bibliography
  style, and a `make tit-check` gate that rejects warnings and more than 50
  pages.
- Added a cover letter, submission checklist, submission manifest, and
  IEEE-style supplement README under `papers/beyond4_prs/submission/`.
- Kept the canonical preprint and TIT review PDFs as separate builds over the
  same theorem sources.

## Validation

```text
make -C papers/beyond4_prs check
exit=0

make -C papers/beyond4_prs tit-check
exit=0
TIT single-column pages: 32 / 50

python3 papers/beyond4_prs/supplement/verify.py
verified 57 bundled evidence artifacts
classification records: PASS
verified classification-record hashes
verified release-manifest local artifact rows
```

The rendered inspection covered the title/abstract/index-term page, the
public verification table, the finite-data appendix and Acknowledgment, and
the final bibliography page.  Tables fit, the title page leads with the coding
claim, and no content clips or escapes the page.

Local TIT candidate:

- PDF: `prs-beyond-redundancy-four-tit-submission.pdf`
- pages: `32`
- bytes: `289637`
- SHA-256:
  `bbd3be493093f65df61a24c0558046e4acdcafab9445b96d195264673413d5d7`

## Author-only gates

- affiliation, postal address, email, and ORCID-linked ScholarOne account;
- funding, acknowledgments beyond the required disclosure, and license;
- related-submission, public-preprint, editor, and reviewer-conflict
  disclosures;
- two independent specialist signoffs on the final source commit and both PDF
  hashes;
- explicit authority to submit through ScholarOne.

The 25-page final two-column limit is not a submission blocker, but it is a
production risk.  The current long tables will require deliberate two-column
layout work after acceptance rather than automatic conversion.

## Vibe check

The paper now looks like a TIT submission rather than a generic mathematical
preprint: its coding claim is first, the front matter is compliant, and the
review PDF is comfortably within the submission limit.  The remaining work is
author metadata, independent review, and eventual two-column production—not
venue repositioning.
