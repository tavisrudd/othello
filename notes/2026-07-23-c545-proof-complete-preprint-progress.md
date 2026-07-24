# C545 proof-complete preprint progress

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** active,
external release blocked

## Result

The manuscript is now a proof-complete **pre-release candidate** at its
printed mathematical boundaries.  This pass did not upload, publish, create a
DOI, create a public repository, or claim independent referee approval.

Closed local gates:

- the assertion-map and adversarial proof rows are green through R9, ordered
  Hessian, Lucas, and `e_7`;
- public R5--R7 records give canonical representatives, stabilizers,
  invariants, Frobenius links, separate status flags, and exact exhaustion
  identities;
- every prime power below the R5/R6/R7 geometric thresholds has an explicit
  certificate, bridge, radius boundary, or geometric disposition;
- paper-facing certificate names and normalization/tie-breaking rules are
  stable;
- the source is split into eleven numbered sections and a separate
  statement-adequacy appendix, with a thin driver and dependency-aware
  Makefile;
- the role-based audit records read depth for all 15 bibliography entries,
  reconciles DOI metadata, qualifies three absence findings, and makes no
  priority claim for the Hessian/Lucas layer;
- rendered cold reads close the notation, roadmap, mathematical-comparison,
  public-verification-table, and source-layout gates.

## Verification

These checks pass:

```text
cd papers/beyond4_prs
python3 supplement/build_classification_records.py --check
cd supplement && sha256sum -c CLASSIFICATION-RECORDS.sha256
jq -e 'all(.records[].fields[]; .exhaustion_identity == true)' \
  CLASSIFICATION-RECORDS.json
cd ..
make check
```

The public record contains 19 R5 fields, 11 R6 fields, and 14 R7 fields
without a failed exhaustion identity.  The warning-strict TeX build produces
a 35-page A4 PDF.  Expanding the new `\input` files reproduces the pre-split
TeX byte-for-byte.  The roadmap renders on page 5; the public verification
table occupies page 31, while page 30 has 43 nonblank lines.

Task-owned commits include:

- `be96a646` — public R5--R7 classification records;
- `aa0e03ef` — refreshed proof/adversarial gates;
- `556ef704` and `29a099c4` — field/schema/policy reconciliation;
- `129634ba` — sectioned source layout;
- `3f597f01` — role-based literature gate;
- `9d8d63fa` — rendered exposition gates.

## Venue and DOI boundary

The provisional journal family is IEEE Transactions on Information Theory.
Current journal and IEEE policy pages approve arXiv/TechRxiv preprints and do
not treat them as prior publication.  The direct TechRxiv service returned
HTTP 403, so operational submission and DOI issuance are not confirmed.  See
`notes/2026-07-23-c545-preprint-venue-policy.md`.

The intended route remains one identical PDF/title/abstract/author set on
arXiv and TechRxiv, only after account-level confirmation.  No arbitrary DOI
repository may be substituted without establishing IEEE PSPB approval.

## Exact remaining blockers

1. **Formal aggregate:** C540--C544 must provide one pinned
   shared-public-Lean commit, target list, axiom audit, and manuscript
   reconciliation.  C545 does not absorb those separately allocated tasks.
2. **Independent reader:** an independent final cold reader must sign every
   L1 headline claim green or supply a closed correction.
3. **Public replay/export:** the paper-only fresh-history export must use
   stable public paths and build/replay from a clean checkout.
4. **Immutable identifiers:** repository URL, tag/commit, archive identifier,
   DOI, URLs, hashes, and byte counts require the reviewed export.
5. **Human confirmation:** author/order, affiliation, ORCID,
   acknowledgements, account authority, and licenses require the author.
6. **External publication:** upload is irreversible and remains a separate
   explicitly authorized action.

## Vibe check

The paper has crossed the important line from research announcement to
proof-complete local candidate.  The remaining risk is release trust and
external authority, not a hidden R5/R6/R8/R9 proof gap.  That is a good
position, but it is not “nearly published”: the formal aggregate,
independent reader, clean export, and author confirmation are real gates.
