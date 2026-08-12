# C909 V14/\(\mathbf P^1\) Google Scholar screen

**Date:** 2026-08-12  
**Lane:** C909 / clebsch  
**Scope:** row-level screen of the user-supplied Google Scholar/Publish-or-Perish export; no
manuscript, PDF, mirror, or Lean edits.

## Verdict

This search does not contain a direct preemption of irrationality for
\(V_{14}\times\mathbf P^1\), stable irrationality of \(V_{14}\), or a
one-step quantum/monodromy obstruction. The result quality is poor: only 10
rows are mathematically adjacent, one is a quantum false positive, and the
remaining 189 rows are lexical noise. Two adjacent rows are especially worth
retrieving as primary sources:

* Gross--Popescu, *Calabi--Yau three-folds and moduli of abelian surfaces II*
  (rank 39), whose abstract explicitly mentions comparing with \(V_{14,y}\)
  and an irrationality conclusion for a related threefold;
* Golyshev, *Deresonating a Tate period* (rank 1), whose abstract mentions
  \(V_{14}\) among Mukai threefolds and Apéry-type recurrences, not stable
  irrationality.

The search therefore supports only the bounded statement “no direct candidate
appeared in this 200-row export.” It is not an absence result beyond this
screen, and none of the 10 adjacent records was individually read.

## Export provenance and integrity

The source files were supplied in /tmp/google-scholar and were not copied
into Git. Both CSV and RTF are PoP 8.19.5300.9483 basic Google Scholar reports.

| artifact | bytes/format | rows or blocks | SHA-256 |
|---|---:|---:|---|
| "V14" "P^1" irrational.csv | 150402, UTF-8 CSV with BOM | 200 data rows, physical lines 201 | 9982b9f66869773971277745397b2e1a66c3c443e23652968659adbf51c95b2c |
| "V14" "P^1" irrational.rtf | 42028, ANSI/CP1252 RTF | 200 result blocks, physical lines 238 | 2d5eb6dc5782e206060a84d8cdfa10f69ff4fa1eecbe6cf4d104776ce40806d5 |

The RTF records the exact submitted query and retrieval metadata:

* Keywords: "V14" "P^1" irrational
* Years: all
* Other options: include citations; include patents; any articles
* Data source: Google Scholar
* Search date: 2026-08-12 11:33:38 -0700
* Cache date: 2026-08-12 11:35:45 -0700
* Search result: [0] No error
* Papers: 200
* Citation sum: 3914
* Publication years: 1893--2026

The CSV has the same 200 rows, rank sequence 1--200, query timestamp
2026-08-12 11:33:38 in every row, citation sum 3914, and publication-year
range 1893--2026. Its first and last records are respectively *Deresonating a
Tate period* and *MEDIA-TING NIGERIAN ISLAMOPHOBIA: MINORITY QUESTION AND
CONNECTIONS*. All 200 RTF result blocks align with the CSV title/rank order
after RTF control-word and encoding normalization; all 112 RTF records that
print an explicit cited by N count agree with the CSV Cites field. The
200-row boundary is reached, so this is a truncated top-200 result set.

## Screen protocol

No scholarly full text was read in this pass: full-text count is **0**. The
200 records have abstract/metadata only depth from the supplied CSV/RTF.
The screen used title, authors, year, source, DOI, article URL, citation URL,
abstract, and rank. The mechanical prefilter was:

V14|V_{14}|cubic threefold|Fano threefold|stable rational|stably rational|stable birational|irrationality|birational|quantum|monodromy|projective bundle|blow-up|intermediate Jacobian|Calabi-Yau

Because the query is dominated by the ordinary word “irrational” and the
literal search-token fragment “V14”, the prefilter was followed by manual
row-level classification. This is a screened set, not a source-reading set.

Disposition codes:

* A = adjacent mathematical lead; no direct preemption, primary text not
  read;
* Q = quantum-themed false positive, unrelated to cubic/Fano/V14
  irrationality;
* N = non-target/noise after title-plus-abstract inspection;
* D = direct preemption. No row received D.

## Adjacent rows (A)

| rank | year | record | row-level reason |
|---:|---:|---|---|
| 1 | 2009 | V. Golyshev, *Deresonating a Tate period*, arXiv:0908.1458 | Abstract names Mukai \(V_{10},V_{12},V_{14},V_{16},V_{18}\) and Apéry-type recurrences; no \(V_{14}\times\mathbf P^1\) or stable obstruction. |
| 4 | 2022 | N. Minami, *Generalized Luroth problems, hierarchized I* (arXiv:2210.12225) | General stable-birational/retract-rationality theory; no V14/cubic specialization in the row metadata. |
| 9 | 2020 | V. Przyjalkowski, C. Shramov, *Bounds for smooth Fano weighted complete intersections*, DOI 10.4310/CNTP.2020.v14.n3.a3 | Fano weighted-complete-intersection context; no V14 stabilization or quantum atom. |
| 10 | 2014 | S. Galkin, E. Shinder, *The Fano variety of lines and rationality problem for a cubic hypersurface*, arXiv:1405.5154 | Cubic irrationality/rationality background; no one-step \(P^1\) theorem in the row metadata. |
| 13 | 2012 | J. Blanc, S. Lamy, *Weak Fano threefolds obtained by blowing-up a space curve and construction of Sarkisov links*, DOI 10.1112/plms/pds023 | Birational/Fano-threefold background; no V14 or stable-irrationality claim. |
| 25 | 2025 | B. Church, *Obstructions to unirationality for product-quotient surfaces over...*, arXiv:2508.14876 | Unirationality obstruction in surfaces; adjacent only by birational-obstruction theme. |
| 31 | 2023 | C. T. Brooke, *Lines on cubic threefolds and fourfolds containing a plane* | Cubic irrationality background/dissertation record; no stabilized V14 theorem. |
| 39 | 2011 | M. Gross, S. Popescu, *Calabi-Yau three-folds and moduli of abelian surfaces II* | Abstract explicitly mentions comparing a threefold with \(V_{14,y}\) and an irrationality result for a related threefold; highest-value retrieval lead, not preemption. |
| 57 | 2007 | A. Iliev, D. Markushevich, *Parametrization of Sing for a Fano 3-fold of Genus 7 by Moduli of Vector Bundles* | Fano-threefold/moduli birational context, but genus 7 rather than \(V_{14}\) (genus 8). |
| 147 | 2023 | A. Kuznetsov, *Semiorthogonal decompositions in families* | Author/topic adjacency to the Kuznetsov geometric route; row metadata does not state the V14/cubic stable-irrationality claim. |

The 10 rows above are all abstract/metadata only; they are leads for a
separate primary-source audit, not evidence that their papers contain the
desired theorem.

## Quantum false positive (Q)

| rank | year | record | disposition |
|---:|---:|---|---|
| 19 | 2020 | E. Frenkel, D. Gaiotto, *Quantum Langlands dualities of boundary conditions, D-modules, and conformal blocks*, DOI 10.4310/CNTP.2020.v14.n2.a1 | The word “irrational” concerns the level \(\kappa\), not quantum cohomology, V14, cubic threefolds, or birational obstruction. |

## Non-target rows (N)

Every row not listed above received N. To make the disposition genuinely
row-level, the complete rank partition is:

* N: 2--3, 5--8, 11--12, 14--18, 20--24, 26--30, 32--38,
  40--56, 58--146, 148--200 (189 rows);
* Q: 19 (1 row);
* A: 1, 4, 9, 10, 13, 25, 31, 39, 57, 147 (10 rows);
* D: empty (0 rows).

The N block includes the many lexical hits where “V14” is a volume/figure/
variable label or “irrational” is used in economics, psychology, engineering,
medicine, physics, or general number theory. It also includes duplicate or
near-duplicate bibliographic versions that are not themselves target results.

## Recommended follow-up Scholar queries

The export is too noisy to support another broad exact-string search. Preserve
fresh RTF/CSV pairs and use narrower, source-oriented queries:

1. “V14” “cubic threefold” birational
2. “V14” Kuznetsov “derived categories”
3. “V14” “stable rationality”
4. “V14” “P^1” birational
5. “degree 14” Fano “stable rationality”
6. “cubic threefold” “P^1” “stable rationality”
7. “Calabi-Yau three-folds and moduli of abelian surfaces II” V14
8. “primitive sixth” “formal monodromy” cubic threefold
9. “V14” quantum connection

The first six address direct/stable-birational precedence; rank 39 motivates
query 7; the last two target the separate quantum package. A result under
200 is not “exhaustive” unless its reported count and source behavior are
recorded.

## Source and coverage boundary

This note names the 11 metadata leads above, but none is individually promoted
as a consulted scholarly source: each has abstract/metadata only depth from
the supplied export, with no cache key or PDF SHA. The RTF/CSV pair is evidence
of a bounded Google Scholar screen, not a reproducible API transcript. Google
Scholar/PoP does not supply a theorem claim or a full-text marker. The next
owner should retrieve the Gross--Popescu and Golyshev records first, then
re-screen any exact V14/Kuznetsov hits using the narrower queries.

**EJ+TT closeout:** the query's strongest surprise is not a hidden V14
stable-irrationality theorem but severe lexical contamination. The 200-row
screen settles that the only true V14-adjacent hits are rank 1 and rank 39;
the 200-result truncation and metadata-only depth remain the exact evidence
gates. No other mystery remains.

