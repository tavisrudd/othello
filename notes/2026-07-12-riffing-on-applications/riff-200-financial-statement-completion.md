# Financial-statement completion and consistency certificates

Status: exploratory paper agenda  
Primary source: `RIFF_183`, `RIFF_200`, `RIFF_201`  
Scope boundary: ambiguity and consistency analysis, not automatic fraud detection or investment
advice

## Mathematical spine

- [`MATH_17`](math.md#math_17--minimal-inconsistencyrepair-duality) — minimum fact repairs are
  transversals of the minimal-inconsistency hypergraph.

## Thesis

Structured filings define a partially observed constraint system. Rather than impute one completed
financial model, an analyzer should expose materially different valid completions, conclusions
shared by every completion, minimal inconsistent fact sets, and the smallest defining evidence for
a target interpretation. Every result should retain exact filing provenance and a replayable
certificate.

## Minimum publishable contribution

1. Define a restricted, auditable completion language for one family of financial-statement facts.
2. Produce minimal inconsistency witnesses and alternative completions on a curated filing corpus.
3. Define material completion distance relative to a declared target conclusion.
4. Compare with deterministic validation rules and single-imputation baselines.

## Research agenda

### Phase 1 — Restrict the domain

Start with one manageable slice:

- balance-sheet roll-forwards;
- cash-flow reconciliation;
- segment totals;
- debt maturity and covenant tables;
- share-count and per-share bridges.

Avoid attempting arbitrary footnote understanding in the first paper.

### Phase 2 — Data and semantics

- Preserve filing timestamp, accession, taxonomy, units, period, and amendment lineage.
- Normalize only transformations with explicit provenance.
- Encode hard accounting identities separately from analyst assumptions and materiality thresholds.
- Build hand-reviewed cases for valid irregularity, taxonomy mismatch, amendment, and real
  inconsistency.

### Phase 3 — Completion engine

- Enumerate or compactly represent compatible completions.
- Extract conclusions common to all completions.
- Find the nearest completion changing the target conclusion.
- Generate minimal inconsistent subsets and smallest defining fact sets.

### Phase 4 — Evaluation

- Precision of inconsistency reports under expert review.
- Number and materiality of alternative completions.
- Stability across amended filings and taxonomy changes.
- Certificate size and independent replay time.

## Paper spine

1. **Introduction:** filings are partial constraint systems, not clean matrices.
2. **Restricted statement semantics and provenance.**
3. **Completion, ambiguity, and defining evidence.**
4. **Minimal inconsistency certificates.**
5. **Dataset and hand-reviewed benchmark.**
6. **Evaluation against validation and imputation baselines.**
7. **Case studies.**
8. **Limits, legal cautions, and extension to richer disclosures.**

## Shallow literature and novelty check

Closest precedents found:

- XBRL already has layered validation, calculation consistency, mandatory-fact, and table-constraint
  machinery: [XBRL validation](https://www.xbrl.org/the-standard/what/key-concepts-in-xbrl/validation/)
  and [Calculations 2.0 requirements](https://www.xbrl.org/REQ/calculation-requirements-2.0/REQ-2019-02-06/calculation-requirements-2.0-2019-02-06.html).
- Financial-statement verification benchmarks are emerging; FinVerBench studies numerical
  consistency under incomplete observability and realistic rendering:
  [FinVerBench](https://arxiv.org/abs/2605.29586).
- Database standardization discrepancies in financial statements are already known to affect
  empirical inference:
  [Lost in Standardization](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3781979).

Preliminary verdict: **possible application novelty, but validation itself is not new**. The likely
gap is returning the *family* of materially different valid completions, facts invariant across that
family, minimum defining facts, and minimal assumption/fact edits changing a target conclusion—with
replayable provenance. The first paper must outperform or complement XBRL Formula/Calculation rules,
not reimplement them.

Required deeper audit:

- database repairs, consistent query answering, and provenance semirings;
- missing-fact inference in XBRL and accounting knowledge graphs;
- minimal unsatisfiable subsets and explanation systems for reporting rules.

## Kill criteria

- Taxonomy normalization errors dominate the purported structural findings.
- Expert review cannot distinguish useful ambiguity reports from routine filing complexity.
- Existing XBRL validation systems already provide the full claimed completion functionality.
- The paper implies misconduct from inconsistency or ambiguity alone.
