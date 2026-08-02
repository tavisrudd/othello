# C794 — aligned-design faithfulness literature audit

**Date:** 2026-08-02

**Lane:** `golden`

**Scope:** aligned four-sets of two-graphs, conference determinant designs,
homogeneous-triple reconstruction, and higher block-count moments

## Verdict

Five individually discussed sources were consulted: **zero at full-text
depth**, three at partial depth, and two at abstract/metadata depth.  This is a
bounded adjacent-literature audit, not a priority closure.

Greaves--Suda directly owns the forward determinant-((-3)) design theorem.
Gillespie gives the classical regular-two-graph parameters behind the
coherent/incoherent four-set classes.  The closest reverse result located is
Pouzet--Si Kaddour--Trotignon's classification of pairs of ordinary graphs
with the same three-vertex homogeneous subsets.  C794's derived graph at an
anchor has exactly that invariant, but C794 also uses aligned four-sets not
containing the anchor.  Those extra tests eliminate the balanced-cut
ambiguities on seven vertices.  None of the consulted sources states that
every two-graph of order at least seven is recovered up to complement from
its zero-or-four coherent four-sets.

The safe verdict is therefore:

> The aligned-design faithfulness theorem is a qualified novelty candidate.
> State it as “we prove.”  If absence is mentioned, use “to our knowledge”
> and record the uncovered databases.  Do not use “first.”

The generic factorial-moment identity for block counts is elementary
double-counting and receives no novelty claim.  C794's conference-specific
triple-union profile and exchange interpretation are an application and a
candidate switching invariant; no completeness or actual class-separation
claim is licensed by this audit.

## Source records

### Greaves--Suda, *Constructions of (t)-designs from weighing matrices and association schemes*

- Identifier: arXiv `2402.17528`, v2, 13 April 2026.
- **Read depth: partial.**  Read the introduction, Section 2.1, Section 2.2
  through Examples 2.3--2.4 and Tables 1--4, and the concluding questions;
  C794 rechecked the text of Example 2.3 and its displayed conclusions.
- Access: shared cache key `arXiv:2402.17528`, PDF and text extraction;
  SHA-256
  `230c4cb862cd51f0d51f20af91c56f2e7453f2e2472114bda6c42b3a5af99e32`.
- Load-bearing content: Example 2.3 proves that determinant-((-3))
  principal four-subsets of a symmetric conference matrix of order (4n+2)
  form a (3	ext{-}(4n+2,4,n-1)) design.  It does not discuss recovering
  the matrix switching class or two-graph from that design, nor balanced-half
  third moments.

### Gillespie, *Equiangular lines, Incoherent sets and Quasi-symmetric designs*

- Identifier: arXiv `1809.05739`, v3, 17 November 2018.
- **Read depth: partial.**  Read Section 2.2 and Section 4.1, including
  Proposition 4.1 and Theorem 4.2; C794 also searched the full extraction for
  reconstruction and coherent/incoherent four-set terminology.
- Access: shared cache key `arXiv:1809.05739`, PDF and text extraction;
  SHA-256
  `3d8e2103efefaf7c24a75129584acb9c968248b53e307989f62c7cf4e6c1fa75`.
- Load-bearing content: the paper records regular-two-graph parameters and
  coherent, mixed, and incoherent four-set designs.  It supplies a classical
  forward parameter route but no reverse faithfulness theorem for their
  coherent/incoherent union.

### Pouzet--Si Kaddour--Trotignon, *Claw-freeness, 3-homogeneous subsets of a graph and a reconstruction problem*

- Identifiers: arXiv `1309.1835`, v2, 22 September 2013; published DOI
  `10.55016/ojs/cdm.v6i1.62075` (publication metadata checked on the journal
  page).
- **Read depth: partial.**  Read the abstract and results/motivation,
  Theorems 1.1--1.2, the reconstruction discussion around Problems 1.3--1.5,
  Lemma 2.2, and Section 2.3's proof of Theorem 1.2.
- Access: shared cache key `arXiv:1309.1835`, PDF and text extraction;
  SHA-256
  `a0d71732a15b440d4658dd08eddce29cc544ccde32a5b753911ef9635cf8a39b`.
- Load-bearing content: the paper defines the hypergraph of clique/independent
  triples of a graph and classifies the possible Boolean sums of two graphs
  with the same such hypergraph.  This directly pre-empts any claim that
  C794 invented the homogeneous-triple reconstruction viewpoint.  Its output
  and ambiguity class differ from C794's: it does not use the aligned tests on
  four-sets away from the anchor and does not state the two-graph theorem.

### Seidel, *Two-graphs, a second survey*

- Identifier: DOI `10.1016/B978-0-12-189420-7.50022-0`.
- **Read depth: abstract/metadata only.**  Read the ScienceDirect title,
  chapter metadata, publisher summary, and displayed definition of regular
  two-graphs.  Full text was not available in the shared cache.
- Access: ScienceDirect metadata page; no cached bytes.
- Screening result: the survey is a necessary classical-context warning.  At
  the accessible depth it describes switching, regular two-graphs,
  equiangular lines, and classifications, but the metadata does not expose an
  aligned-four-set reconstruction result.  This limited depth licenses no
  negative about the body of the chapter.

### Bahmanian--Suda, *Hadamard hypercubes*

- Identifier: arXiv `2605.16722`, v1, 16 May 2026.
- **Read depth: abstract/metadata only.**  Read the arXiv title, authors,
  identifier, version, abstract, and subject metadata during the same-day
  C788 forward-citation screen; C794 inherited and rechecked that durable
  record.
- Access: arXiv HTML; no cached bytes because the source was screened out at
  abstract depth.
- Screening result: this was the sole Semantic Scholar forward citation of
  Greaves--Suda returned in the valid C788 query.  Its abstract concerns
  higher-dimensional Hadamard arrays, not determinant-four-set reconstruction
  or balanced-half block moments.

## Search and screening record

The load-bearing web discovery queries were, verbatim:

1. `"two-graph" "coherent four" reconstruction`
2. `"two-graph" reconstruction "four-subsets"`
3. `"determinant -3" design conference matrix reconstruction`
4. `"regular two-graph" "incoherent four-sets"`
5. `site:arxiv.org two-graphs switching reconstruction coherent triples`
6. `graphs same 3-homogeneous subsets determined up to complement`
7. `"3-homogeneous subsets" graph complement`
8. `"aligned four-set" two-graph`
9. `"determinant-design" two-graph reconstruction`

The first five exact two-graph/design queries returned no relevant exact
predecessor among the displayed results; the homogeneous-subset queries
promoted the Pouzet--Si Kaddour--Trotignon paper.  The result pages were
screened over title and snippet.  Because the search engine does not expose a
stable total result count, this is recorded as discovery rather than as an
exhaustive screened set.

As a separate reproducible top-result screen, OpenAlex and Crossref were each
queried on 2026-08-02 with the following three strings, screening the first 25
records over title:

- `two-graph aligned four-set reconstruction`;
- `two-graph determinant design reconstruction`;
- `graph homogeneous triples reconstruction complement`.

OpenAlex reported respectively 98,436, 30,646, and 2,094 total matches;
Crossref reported 2,825,040, 4,796,838, and 695,192.  The mechanical title
discriminator was the occurrence of `two-graph`, `two graph`, `homogeneous`,
`conference`, or `reconstruct`.  The huge totals and poor precision make
these only top-25 screens, not database closures.  The third query recovered
the Pouzet paper in both services; the first two promoted no exact
two-graph/design predecessor.

## Greaves--Suda forward citations

The seed was pinned as arXiv `2402.17528` and DataCite DOI
`10.48550/arXiv.2402.17528`.

- OpenAlex returned the valid work `W4392271278` with
  `cited_by_count=0` on 2026-08-02.
- Semantic Scholar returned HTTP 429 in the C794 recheck.  The valid earlier
  C788 query on the same date returned one citation, Bahmanian--Suda above,
  and `next=None`; that source was screened over title, abstract, year, and
  external identifiers.
- Crossref returned HTTP 404 for the pinned DOI.  A title query did not
  resolve a published record.  This is an error/unresolved seed, not a valid
  zero count.

The service disagreement is retained.  Since Crossref supplied no valid
count, the three-graph forward-citation gate is not closed.

## Coverage gaps and safe wording

- **MathSciNet: NOT COVERED.**  Institutional authentication was unavailable.
- **Google Scholar: NOT COVERED.**  Automated access was unavailable.
- **zbMATH Open: only web-discovery coverage.**  No exact theorem surfaced;
  no exhaustive MSC screen was attempted.
- **Greaves--Suda Crossref forward graph: NOT COVERED.**  The pinned seed was
  unresolved.
- **Subject-expert check: NOT COVERED.**
- **Seidel survey full text: NOT COVERED.**

These are access/coverage gaps, not searches that found nothing.  They block
“first” and any unqualified absence sentence.  They do not affect the
mathematical proof or the direct attribution to Greaves--Suda, Gillespie, and
Pouzet--Si Kaddour--Trotignon.

