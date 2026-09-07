# C1108 — continuation reconstruction reconciliation

**Lane:** `continuation`. **Status:** complete.

The draft now states the C295 reconstruction/isomorphism corollary explicitly,
including field-order recovery and uniqueness. This is a consequence of the
existing frame automorphism theorem, not a newly discovered independent theorem.
The public paper retains its own proof and makes no dependency on private reports.

## Bounded literature comparison

One source was read in full text; one was read partially from its published PDF.
This is a claim-specific comparison, not a refreshed comprehensive priority or
forward-citation audit. No new global novelty verdict is assigned.

- Bhattacharya–Godinho–Majumder–Singhi, *Reconstruction of hypergraphs from line
  graphs and degree sequences*, arXiv:2104.14863v1 (2021): **full text**, all
  sections; Section 2 is the relevant part. Cache key `arXiv:2104.14863`, SHA-256
  `192b23ba8ab7153a70a241cd3b7bd4145db7ee60e05df817779611291e5ac75b`.
  Lemma 2.3 gives star-clique threshold pk²+(p−2)k+2, hence 14 at k=4,p=1.
  Our centre-resolved bound gives 10. Lemma 2.4 bounds outside adjacency by pk;
  our selected-centre argument gives three for a frame trace. Theorem 1.1 and
  Section 2 impose a minimum edge-degree threshold; they are not an unconditional
  recognition theorem for arbitrary intersection graphs. None of these results
  is imported as a premise of our proof. Identifying recovered symbols with
  centre classes and extending to a semilinear map remain separate obligations.
- Gardiner–Praeger–Zhou, *Cross ratio graphs*, published JLMS paper (2001):
  **partial**, Sections 1, 3, and Section 7 statements with the beginning of the
  isomorphism proof. Cache key `10.1112/S0024610701002150`, SHA-256
  `2ecfdef1048f5ded44ec627a20216c1788691d41f1c2713fd19138d512ba18ed`.
  Definitions 3.2/3.4 and Theorems 7.1/7.2 supply the exact comparison: ordered
  distinct pairs on PG(1,q), q(q+1) vertices, and cross-ratio orbit adjacency.
  The current frame graph has (q−2)(q−3) vertices and fibre-coincidence adjacency.
  This identifies different constructions at the same field order; it is not a
  theorem excluding every possible indirect relationship or later generalization.

Access URLs: https://arxiv.org/pdf/2104.14863 and
https://researchers.ms.unimelb.edu.au/~sanming%40unimelb/PDF/JLMS64.pdf.
The preceding conversational literature-map queries included `linear hypergraphs
reconstruct line graph Krausz recognition clique large cliques` and
`Cross ratio graphs Gardiner Praeger Zhou`; this task fetched the two exact
identified papers after checking their cache keys. MathSciNet/zbMATH citation-chain
closure was not performed. C271/N2 remains separate and open.

## Acceptance and closeout

The theorem/corollary are explicit; the public source-only claim map records absent
Lean coverage rather than implied formalization. No standalone code-reconstruction
or game-value theorem is claimed. Source-level validation is recorded with the
companion C1109/C1110 reports.

The ej/tt pass identified the constructive gap in C295's informal recovery
algorithm: uniqueness up to isomorphism does not by itself give a practical
coordinate finder. C1109 owns the completed division-table construction and exact
small-order checks.

## Mystery ledger

- Settled: C295 was a completed downstream corollary that had never been integrated.
- Settled: generic large-clique reconstruction and the centre/Frobenius steps are
  distinct; the exact compared thresholds are 14 versus 10.
- Open: a fresh comprehensive N1 forward-citation audit; this bounded comparison
  does not discharge it. N2's named full-text/citation gate remains C271.
