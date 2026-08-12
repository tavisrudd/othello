# C907/C909 — two-row Scholar screen for primitive-sixth quantum/monodromy priority

Date: 2026-08-12

Status: durable metadata screen; no manuscript, bibliography, ledger, PDF,
mirror, or Lean file was changed.

## Opening record and coverage boundary

**New full-text count: 0.** This is a complete screen of the supplied
two-row Google Scholar export, not a source-reading or exhaustive priority
verdict. The only source bytes inspected were the CSV export itself. No
OpenAlex/Crossref/Semantic Scholar cited-by closure was attempted, because
the task is a two-row content screen rather than a citation-graph negative.

Local export:

- Path: `/tmp/google-scholar/"primitive sixth" formal monodromy quantum.csv`
- SHA-256: `693f05ac165074dfcb006a47d32d3505fdd4c261384b49b207478b1be3773f5d`
- Format: UTF-8 CSV with BOM; 26 columns; header plus exactly 2 data rows.
- Data source: Google Scholar, imported by Publish or Perish (the CSV does
  not carry an RTF report or software-version block).
- Query date in every row: `2026-08-12 11:40:51`.
- Query recovered verbatim from both `RelatedURL` values:
  `"primitive sixth" formal monodromy quantum` (URL-encoded as
  `scioq=%22primitive+sixth%22+formal+monodromy+quantum`).
- No matching RTF/report file exists beside the CSV, so there is no separate
  report-level result count or cache date to record.

The screen used the full row metadata available in the export: rank, authors,
title, year, source/publisher, ArticleURL, CitesURL, query date, type, DOI,
abstract snippet, FullTextURL, and RelatedURL. A row's `abstract/metadata only`
depth means that no linked paper or thesis was downloaded or read; the
abstract field is the abbreviated Scholar snippet, not the source abstract.

## Row-level screen

| Rank | Authors | Title | Year | ArticleURL | DOI | Disposition | Read depth | Reason |
|---:|---|---|---:|---|---|---|---|---|
| 1 | D Tan | *Vertex operator algebras, modular tensor categories and a Kazhdan–Lusztig correspondence at a non-negative integral level* | 2020 | https://researchers.ms.unimelb.edu.au/~dridout@unimelb/students/Tan.MScThesis.pdf | — | EXCLUDE-BACKGROUND | abstract/metadata only | The snippet concerns VOAs, quantum groups, and an sl2 quantum group at a primitive sixth root. It does not identify small quantum cohomology, formal monodromy of a cubic/V14, or the C909 abelian divisor/Hodge lattice. |
| 2 | L Biroth | *Integrable systems and a moduli space for (1, 6)-polarised abelian surfaces Dissertation zur Erlangung des Grades* | — | https://openscience.ub.uni-mainz.de/server/api/core/bitstreams/a4c2ab2e-d772-4daf-9ad3-043d043213f1/content | — | READ-TARGET-ADJACENT | abstract/metadata only | The title is genuinely adjacent through a (1,6)-polarised abelian-surface moduli space and integrable systems; the snippet mentions a primitive sixth root, H6-invariance, and classical/quantum terms. It still gives no explicit formal-monodromy operator, cubic/V14 quantum calculation, or C909 PD/product statement. |

## Exact row provenance

The following URLs are copied from the CSV rather than reconstructed:

1. Rank 1 `CitesURL`: `https://scholar.google.com/scholar?cites=3592257809883759558&as_sdt=2005&sciodt=2007&hl=en`.
   `FullTextURL` equals the ArticleURL above. `RelatedURL`:
   `https://scholar.google.com/scholar?q=related:xoO-C3JD2jEJ:scholar.google.com/&scioq=%22primitive+sixth%22+formal+monodromy+quantum&hl=en&as_sdt=2007`.
2. Rank 2 has an empty `CitesURL`. `FullTextURL` equals the ArticleURL
   above. `RelatedURL`:
   `https://scholar.google.com/scholar?q=related:Su9un-r9vWEJ:scholar.google.com/&scioq=%22primitive+sixth%22+formal+monodromy+quantum&hl=en&as_sdt=2007`.

Both rows have an empty DOI field. No bibliographic volume, issue, or page
data was supplied, so none is asserted here. No source cache key or source
SHA exists because neither linked work was fetched.

## Reading targets and bounded priority consequence

The only worthwhile immediate source-reading target is rank 2, Biroth's
dissertation. If pursued, read the passages indexed by the primitive sixth
root `ξ`, the H6-invariant image, and the classical/quantum integrable-system
construction; specifically test for a named monodromy representation or
operator and distinguish it from a modular-function symmetry. Its present
status is **metadata-only**, not a source characterization.

Rank 1 is a low-priority background target only if C907 later needs
root-of-unity VOA/quantum-group formalism. It is not a plausible predecessor
for either the cubic quantum invariant or the C909 integral Hodge/product
claims on the present evidence.

This export therefore yields one adjacent read target (rank 2), one unrelated
root-of-unity background hit (rank 1), and no preemption. It does **not**
license “no predecessor,” “to our knowledge,” or any change to the owning
claim–proof–novelty ledger; a future priority sentence must use the pinned
primary-source and citation-graph protocol.

No manuscript or ledger edit was made.
