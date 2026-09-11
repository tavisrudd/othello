# C1133 — reconstruction transcription repair

**Lane:** `cubic-threefolds`

## Finding and disposition

The author supplied Astra/ChatGPT feedback from an all-32-page mathematical
and selected-source read, without repository replay or formalization review.
No grades are recorded. Its definite correction is confirmed against the
rendered printed page 10 of Przyjalkowski, arXiv:math/0410327v4,
Proposition 6.2.2. Cached PDF SHA-256:
`39c13194bcc63073d38f403a739f403028c3a5516ba72934ee03ba99179fbde2`.
The correct polynomial is

`-495*d3*d5 + 261*d2*d3^2 - 312*d4*d2^2 + 432*d4^2 + 56*d2^4`.

The preceding response transposed the last two coefficients in the manuscript,
source registry, executable formula and denominator cross-check. Thus those
checks proved arithmetic agreement for the wrong source transcription. The
historical report now carries an explicit supersession notice.

All four corrected values are nonzero:

| Genus | Exact value | Prime | Residue |
|---|---:|---:|---:|
| 2 | -21557023506468450000 | 19 | 7 |
| 3 | -7881883610832 | 13 | 3 |
| 4 | -9929755332 | 11 | 9 |
| 5 | -173747920 | 7 | 4 |

For regularized coefficients r_n=n! d_n, 144 times the polynomial is
`-99*r3*r5 + 522*r2*r3^2 - 468*r4*r2^2 + 108*r4^2 + 504*r2^4`.
No matrix, classification-table entry, theorem statement, hypothesis,
title or abstract changes. The four geometric identifications retain their
previous scope, now supported by the correctly transcribed criterion.

## Reproducibility and regression boundary

Exact script and certificate:
`papers/cubic-stabilization-m1/verification/fano-matrices/reconstruction_check.py`
and its adjacent JSON. Inputs remain the literal matrix entries in
`finite_checks.py` and period entries in `source_check.py`, pinned by SHA-256
in the certificate. README, script and certificate hashes are refreshed in
`manifest.json` and `SHA256SUMS`. From the paper root:

```
python3 verification/fano-matrices/reconstruction_check.py --check
make check
```

The added modular checks recompute directly in the finite fields and compare
with the four independently supplied expected residues. Restoring both former
transposed formulas in an in-memory mutation is rejected by the modular
check. This regression check closes this error, not the general problem of
source transcription; mathematical source theorems remain imported.

## Editorial dispositions and remaining review

Applied: distinguish I_exp from I_lat in the 0,1 residue example; cite
Iritani Remark 1.5 at the positive-z assertion; identify Naive Atoms as
arXiv:2606.17884v2 (matching its cached header); remove direct/directly.
Remark 1.5 was checked at https://arxiv.org/html/2307.13555v3,
using the rendered HTML text of the numbered remark. It explicitly rewrites the comparison ring as a
graded positive-z power-series ring. This is a citation clarification, not
an independent audit of the whole comparison adaptation.

The current cubic-first title is retained in accordance with the established
headline hierarchy. No additional consequences are added. The supplied
review's assessment of the comparison and Hodge arguments is feedback,
not new independent kernel evidence. Its proposed focused review of Lemmas
3.1 and 7.1 remains relevant. The author additionally requests a Lean
coverage/trust review after export.

## Validation

Authority full `make check` passes. Run log:
`/tmp/claude-run-quiet/20260910-222407-make-C-cubic-stabilization-m1-check`.
Full theorem/lemma/proposition/corollary environment comparisons pass; abstract
unchanged and below 200 words. Changed pages 1, 5, 8, 29, 32 visually checked.
PDF: 32 pages, 251259 bytes, SHA-256
`33d39d37048a7c99c2d01c1b8ee14d8265a604bb9a50fc969219e79ba2e18472`.
Standalone export identity follows in the closeout record.

## EJ + TT closeout / Mystery ledger

Settled: the two internally agreeing formulas shared one transcription
mistake. An externally supplied modular regression catches that failure even
when both formulas are mutated back together. This is the cheap additional
upgrade beyond editing the displayed equation. No unexplained arithmetic
remains for these four nonvanishing checks. Remaining evidence gap: the
complete geometric comparison adaptation and its precise Lean coverage;
the author-requested successor review owns that gap. No new Lean replay or
coverage promotion is claimed by this repair.
