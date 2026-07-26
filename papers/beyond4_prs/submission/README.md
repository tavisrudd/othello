# IEEE Transactions on Information Theory submission packet

This directory prepares the manuscript for submission without performing any
account or publication action.

Build the single-column IEEEtran review PDF from the paper directory:

```text
make tit-check
```

The output is `prs-beyond-redundancy-four-tit-submission.pdf`.  The current
build has 23 single-column pages, below the 50-page submission limit effective
since 2025-05-01.  The canonical preprint PDF remains a separate build from
`main.tex`.

Before submission:

1. replace every `[[AUTHOR INPUT: ...]]` field in this directory;
2. obtain the two independent signoffs in
   `supplement/FINAL-READER-SIGNOFF.md`;
3. run `make check`, `make tit-check`, and
   `python3 supplement/verify.py --replay`;
4. package the complete electronic supplement and its
   `TIT-SUPPLEMENT-README.md` for simultaneous peer review;
5. confirm the ScholarOne account's ORCID and corresponding-author metadata;
6. recheck the live journal instructions and page limits.

Do not run `supplement/verify.py --release` for journal submission unless the
public preprint release fields are also complete.  Journal submission and
public preprint publication are separate authorized actions.
