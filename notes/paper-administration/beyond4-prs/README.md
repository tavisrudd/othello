# IEEE Transactions on Information Theory submission packet

This directory prepares the manuscript for submission without performing any
account or publication action.

Build the single-column IEEEtran review PDF from the paper directory:

```text
make tit-check
```

The output is `prs-beyond-redundancy-four-tit-submission.pdf`. The tracked
build has 49 single-column pages under the strict local target of fewer than
50 pages, leaving one page of headroom. Recheck the page count after every
manuscript change. The canonical preprint PDF remains a separate build from
`main.tex`.

Before submission:

1. supply private affiliation, address, email, and ORCID-linked account data
   through the journal system;
2. complete the venue-required author and manuscript review;
3. run `make check`, `make tit-check`, `make submission-check`, and
   `python3 supplement/verify.py --replay`;
4. package the complete electronic supplement and its
   `TIT-SUPPLEMENT-README.md` for simultaneous peer review;
5. confirm the ScholarOne account's ORCID and corresponding-author metadata;
6. recheck the live journal instructions and page limits.

Do not run `supplement/verify.py --release` for journal submission unless the
public preprint release fields are also complete.  Journal submission and
public preprint publication are separate authorized actions.
