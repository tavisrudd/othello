# C909 Google Scholar/Publish-or-Perish integrity manifest

**Date:** 2026-08-12  
**Lane:** C909 / clebsch  
**Scope:** provenance and integrity check of the user-supplied /tmp/google-scholar bundle; no
manuscript, PDF, mirror, or Lean edits.

## Acceptance verdict

The bundle contains two Google Scholar searches, each with exactly 200 CSV records and a matching
200-paper Publish-or-Perish (PoP) basic report. Both searches reached the 200-row boundary:
GSRank is the complete sequence 1--200, and each RTF reports Papers: 200. The records are
therefore bounded top-200 results, not an exhaustive Scholar result set.

The finite-etale CSV and RTF are internally aligned. The other pair is also aligned by query date,
rank order, titles, citation totals, and first/last records, but its filename is stale: the RTF
named as an “integral Hodge/product of elliptic curves” search actually records the submitted query
“cubic threefold” “P^1” irrational. The CSV has the same query timestamp and the same 200 records.
The filename must not be used as query provenance.

No checksum or format failure was found. The remaining quality issues are ordinary Scholar
deduplication/version records and the 200-result truncation. No result should be promoted to a
source claim without stable-identifier and primary-text verification.

## File-level manifest

All hashes below are SHA-256 of the exact bytes in /tmp/google-scholar on 2026-08-12.

| file | format/bytes | records | query evidence | SHA-256 |
|---|---:|---:|---|---|
| search1-finite-etale.csv | UTF-8 CSV with BOM, 153626 bytes, 201 physical lines | 200 | every QueryDate = 2026-08-12 11:22:16; ranks 1--200 | f2dbd34510c6aec4fedc4a7a6f1ea3203ed0f170295bc65b9b7a7e21274e578f |
| “finite étale” “Néron-Severi” graph isogeny.rtf | ANSI/CP1252 RTF, 38206 bytes, 238 lines | 200 result blocks | Search date 2026-08-12 11:22:16 -0700; cache 11:22:44 -0700; Google Scholar; [0] No error | 915e0f5d36b3f15d760e56a28319978eb88e2b764f2cb532b8ee07cc92dc1bec |
| “integral Hodge” “product of elliptic curves” divisor -K3 -hyperkähler.csv | UTF-8 CSV with BOM, 147015 bytes, 201 physical lines | 200 | every QueryDate = 2026-08-12 11:27:08; ranks 1--200 | a2020e8ef66b27807cd33afeeb63638eba75d8d08b756508e7c982eda824e649 |
| “integral Hodge” “product of elliptic curves” divisor -K3 -hyperkähler.rtf | ANSI/CP1252 RTF, 38659 bytes, 238 lines | 200 result blocks | Search date 2026-08-12 11:27:08 -0700; cache 11:31:13 -0700; Google Scholar; [0] No error | e544c3ee7520c7f49455e2f4d707db56d241e36f44199424b8c8b2c6fb0bfc81 |

The fourth hash is intentionally recorded exactly as supplied; the RTF is the authoritative
internal-query record despite its stale filename. The filename and hash should not be silently
renamed in an evidence ledger.

Both CSVs have the same 26-field header:

Cites, Authors, Title, Year, Source, Publisher, ArticleURL, CitesURL, GSRank, QueryDate, Type, DOI,
ISSN, CitationURL, Volume, Issue, StartPage, EndPage, ECC, CitesPerYear, CitesPerAuthor, AuthorCount,
Age, Abstract, FullTextURL, RelatedURL.

## Exact query provenance

### Finite-etale/NS search

The RTF records:

* Keywords: “finite étale” “Néron-Severi” graph isogeny
* Years: all
* Other options: include citations; include patents; any articles
* Data source: Google Scholar
* Search result: [0] No error
* Papers: 200
* Citation sum: 4267
* Publication years: 1972--2026

The CSV has the same 200-row citation sum (the sum of its Cites column is 4267), the same
publication-year range, and the same timestamp in every row. The generic filename
search1-finite-etale.csv is not itself evidence of the query string; the RTF is.

### Cubic/P1 search

The RTF records:

* Keywords: “cubic threefold” “P^1” irrational
* Years: all
* Other options: include citations; include patents; any articles
* Data source: Google Scholar
* Search result: [0] No error
* Papers: 200
* Citation sum: 5129
* Publication years: 1972--2026

The CSV has the same 200-row citation sum (the sum of its Cites column is 5129), the same
publication-year range, and the same timestamp in every row. Its filename claims an unrelated
integral-Hodge/elliptic-product query, while the RTF content and rows are the cubic/P1 search.
Treat the internal RTF query as the submitted-query record and mark the filename as stale.

## CSV/RTF alignment

The two RTF files each contain exactly 200 result blocks. I compared them to the CSV paired by
query timestamp:

* finite-etale pair: all 200 titles align in rank order after RTF control-word/encoding
  normalization; all 149 RTF rows that print an explicit cited by N count agree with the CSV
  Cites field. The other 51 RTF rows omit an explicit citation count, generally corresponding
  to CSV zero/missing display values.
* cubic/P1 pair: 199 of 200 titles align under the same normalization. The one apparent mismatch
  is rank 76, Coble fourfold, 𝔖6-invariant quartic threefolds, and Wiman–Edge sextics; the RTF's
  CP1252/control-word rendering drops the blackletter 𝔖 and displays 6, not a different record.
  All 150 RTF rows with explicit cited by N counts agree with CSV Cites; 50 RTF rows omit an
  explicit count.

The first and last rows also agree:

* finite-etale: rank 1 On elementary equivalence, isomorphism and isogeny; rank 200
  Geometricity of local p-adic representations;
* cubic/P1: rank 1 Irrationality of generic cubic threefold via Weil's conjectures; rank 200
  Birational rigidity of Fano 3-folds and Mori dream spaces.

Thus the pairings are evidentially sound even though the second filename is wrong.

## Duplicate/version audit

Duplicates were tested on case-folded, whitespace-normalized (Title, Authors) pairs. They are
not byte duplicates: the ranks, years, URLs, and often publication versions differ.

Finite-etale/NS CSV — seven repeated keys:

* Derived isogenies and isogenies for abelian surfaces, Z. Li/H. Zou: ranks 18 (2021,
  arXiv:2108.08710) and 42 (2026, msp.org);
* Isogenies between K3 surfaces over ..., Z. Yang: ranks 40 (2022, Oxford) and 53 (2018,
  arXiv:1810.08546);
* Lectures on Shimura varieties, A. Genestier/B. C. Ngô: ranks 63 (2020, Google Books) and
  84 (2006, ResearchGate);
* A variational Tate conjecture in crystalline cohomology, M. Morrow: ranks 73 (2019,
  DOI 10.4171/JEMS/907) and 122 (2014, arXiv:1408.6783);
* K3 surfaces associated with varieties of generalized Kummer type, S. Floccari: ranks 103
  (2025, arXiv:2501.02315) and 125 (2026, msp.org);
* Convex Fujita numbers are not determined by the fundamental group, J. Chen/A. Küronya/
  Y. Mustopa/J. Stix: ranks 148 (2023, arXiv:2301.06367) and 176 (2024,
  DOI 10.1515/advgeom-2024-0029);
* Stability of Hodge bundles and a numerical characterization of Shimura varieties,
  M. Möller/E. Viehweg/M. Zuo: ranks 169 (2007, arXiv:0706.3462) and 191 (2012,
  DOI 10.4310/jdg/1352211224).

Cubic/P1 CSV — three repeated keys:

* The intermediate Jacobian of the cubic threefold, C. H. Clemens/P. A. Griffiths: ranks 41
  (1972, JSTOR) and 43 (1973, UCSD PDF);
* Derived categories of nodal del Pezzo threefolds, N. Pavic/E. Shinder: ranks 93 (2021,
  arXiv:2108.04499) and 115 (2025, DOI 10.11650/tjm/250907);
* Classical algebraic geometry, O. Debarre/D. Eisenbud/G. Farkas/R. Vakil: ranks 141 (2022,
  Oberwolfach/EMS) and 164 (2015, Oberwolfach/EMS).

These should be deduplicated by DOI/arXiv/landing-page identity before screening; retaining both
versions is useful for Scholar coverage but they must not count as two independent predecessors.

## Result quality and recommended next Scholar queries

The cubic/P1 search has a strong top layer: ranks 1--8 include cubic irrationality,
intermediate Jacobians, low-dimensional cubic rationality, and Fano-surface measures. It then
contaminates into cubic fourfolds, broad rationality surveys, and unrelated low-dimensional
questions. The finite-etale/NS search is broader still: ranks 1--2 are directly relevant
isogeny/NS papers, while rank 3 onward rapidly mixes Picard functors, specialization, Brauer,
Shimura, K3, and p-adic topics. This is useful discovery coverage but not a clean candidate set.

Run these next, one per PoP/Scholar folder, preserving exact query strings and fresh RTF/CSV pairs:

1. “V14” “cubic threefold” birational
2. “degree 14” Fano “stable rationality”
3. “cubic threefold” “P^1” “stable rationality”
4. “finite étale” “graph divisor” abelian
5. “Néron-Severi” “elliptic power” graph
6. “primitive sixth” “formal monodromy” cubic threefold

The first three tighten the classical/stable-irrationality priority boundary. The last three
separate the graph-divisor finite-etale mechanism from generic NS/isogeny literature and target
the nu6 quantum package. Because the supplied searches hit 200 records, use exact phrases and
do not interpret a future sub-200 result as evidence of global exhaustion without recording the
reported result count.

## Integrity limits and handoff action

* The RTFs prove that PoP received [0] No error; they do not prove that Scholar returned all
  matching works. Both searches hit 200 and are truncated at that boundary.
* No browser HTML, authenticated-session metadata, or PoP archive was supplied. The evidence is
  therefore a CSV plus basic RTF report, not a reproducible browser/API transcript.
* The stale second filename is the only provenance defect found. Preserve the original bytes and
  hash, but pair it in future records by the internal RTF query and timestamp.
* Before any source is promoted, resolve DOI/arXiv identity, obtain/read the primary text, and
  ingest a lawful PDF through the shared litcache with its cache key and SHA. Scholar metadata and
  PoP rows do not constitute a full text read.

**EJ+TT closeout:** the surprising result is that the “integral Hodge/product of elliptic curves”
filename actually contains the cubic/P1 query; the checksum, rank alignment, citation sum, and
timestamp settle this as a naming defect rather than data corruption. No further mystery remains
in the supplied files. The open gate is only the truncated 200-row boundary and the need for
narrower authenticated searches.
