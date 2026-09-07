# C1102 — Remaining citation adjudication

Date: 2026-09-07. Lane: `clebsch`.
**All 336 original promotions have a recorded disposition; Gate 1 has PASSED with the approved Crossref coverage exception.**

The original adjudication added twenty partial readings. The user-scan follow-up
adds one **full-text** reading of Feng–Luo, resolving the last primary-access gap.
The current technical register has **33 sources: three full text, 29 partial,
one abstract/metadata only**. Current dispositions: **23 primary-comparison
memberships, 47 metadata background, 266 title screens, zero access gaps**.
The full-text readings are Klappenecker–Rötteler, Dai–Fu–Luo and Feng–Luo.
`adjudication-sources.json` pins bytes, versions and read sections. The historical
acquisition snapshot and its counts remain frozen.

The current verdicts live only in `CLAIM-PROOF-NOVELTY.md`, rows N1–N9. In particular,
N1–N6 adjudicate the six required questions; N7–N9 close the writing card's synthesis,
factory and trace-cubic attribution questions. Their bounded statements supersede
the older “unclaimed” labels, without pretending that source access was exhaustive.

The final bounded access follow-up and a **pending, unapplied** gate proposal
are recorded in `GATE-DECISION.md`, with hashed metadata in
`continuation-access.json`. Its access-gap proposal is superseded by the user scans; the user subsequently approved only the Crossref coverage exception (see `gate-approval.json`).

## What changed

1. **Physical versus logical gates in Li–Yeh.** The old C1090 dismissal said that
   the physical transversal operation was a two-qutrit AND. Section 4.4 actually
   specifies three T and three T† physical gates for the logical AND; Appendix C.1
   explicitly applies its decoding argument to distillation of the inner qutrit
   coupled diagonal resource. This is decisive contrary evidence to the broad
   “no qudit synthillation” wording. Read depth: partial; arXiv:2603.04548 version
   and hashes in the source register. It does not equate the characteristic-three
   code with the p>=5 translation or conic constructions.
2. **The Waring-to-circuit bridge already has a direct qudit source.**
   Heyfron–Campbell's arXiv:1902.05634, IV, writes a homogeneous cubic as a weighted
   sum of cubes of linear forms, defines its signature-tensor implementation,
   constructs a circuit, and poses column minimization. Read depth: partial,
   Eqs. (6)–(9), Definition 1, Lemmas 1–2 and Problem 3. N7 records the consequence.
3. **Prime-power MUB magic needs its own citation.** Damski et al.,
   arXiv:2603.15550, III Lemma 6 and IV.A Theorem 1, covers the product-WH L1
   equimodular bound and trace-cubic fiducials over F_(p^n), p>=5. Read depth:
   partial. Its norm is related to M_(1/2), not itself M2. N9 keeps that distinction
   and the separate scope of Knipfer's two-qudit conjecture.
4. **Campbell 2014 does not supply the card's printed parameters.**
   arXiv:1406.3055, main-text Transversal gates / Error correcting properties / MSD,
   uses `d-1` physical sites and maximum distance `floor((d+1)/3)`. Read depth:
   partial. It is related polynomial-code precedent, not a direct citation for
   `[[p,1,(p+2)/3]]_p`. The C1099 length-p table is its own construction and must
   retain its own proof. The bounded benchmark already distinguishes its six-site
   QRM module from the seven-site RS module, so that report needs no correction.
5. **The general state class and broad geometry claims are also taken.**
   The primary-section comparisons for finite-function encoding, multihypergraph
   states and lattice-derived magic distinguish the specific invariant phase from
   those established frameworks. Promotion 326's abstract even describes a
   topological invariant as a logical phase. N4 therefore uses “binary-form phase”
   rather than a broad first-invariant-gate claim.

## Screen and stop condition

The input is exactly the frozen 336 normalized-title promotions from 1,377 graph
memberships. The seven original seeds retain all three independently recorded counts
and both available enumerations in `counts.json`; the earlier nine-seed snapshot
is not overwritten. This pass read every promoted title, individually read selected
abstracts, and compared the closest works at the primary sections named in the
register. The mechanical first discriminator is unchanged in `screen.py`; the human
second discriminator and explicit decisions are in `adjudicate.py` and
`adjudication.json`.

Current disposition totals: **23 primary-comparison memberships, 47 abstract/metadata
background dispositions, 266 title-screen dispositions, zero primary-access gaps**.
These are memberships in the promotion list, not counts of distinct primary papers.
For example, the two Li–Yeh titles resolve to the same pinned arXiv source. The
Campbell–Howard PRL/PRA titles concern companion papers: the PRA reading supplies the
comparison, and is not a claim to have read the PRL full text.

The title-screen stop rule is explicit: a title that does not identify a target
mechanism, phase-state construction, entropy/product bound, geometry/invariant
construction or synthesis question is not promoted further. A metadata disposition
does not prove that the unread body contains no relevant example. In particular,
this is **not** “336 papers technically ruled out.” The residual risk is carried
in every instance-priority ledger row. Abstracts themselves remain in the hashed
original graph caches; the Git artifact carries metadata and judgments, not copied
paper text.

The writing card's named distance-side works were compared at their actual result
statements: arXiv:2408.10140 (introduction), 2502.01864 (Theorems 1.1–1.2),
2507.05392 (introduction/Theorem 1.1 opening), 2408.07764 (Theorems 1.1–1.2),
2512.21874 (II/Table I/Theorem 1), and 2510.10852 (2, puncturing construction).
All six have **partial** read depth. Their domains and the preprint/publication
distinction are in the source register. No superiority to those families is claimed.

## Graph and access resolution

The literal requests and response hashes are in `adjudication-graph-access.json`
and `adjudication-hessian-enumeration.json`.

| Added Hessian seed, arXiv:2602.23687 | Observed result | Interpretation |
|---|---|---|
| OpenAlex, original pinned DOI request | 0, successful empty enumeration | One indexed zero, unchanged from the acquired snapshot |
| Semantic Scholar `ARXIV:2602.23687` retry | HTTP 200, count 0; resolved paper `db79e31f1d0d66ece3e069e0c4c6eb6049bbfc69`; citations endpoint HTTP 200, `data=[]`, no next page | Second indexed zero; earlier 429 resolved |
| Semantic Scholar DOI alias | HTTP 404 | Identifier alias missing despite successful arXiv resolution; not another citation count |
| Crossref `10.48550/arXiv.2602.23687` | HTTP 404 | Missing Crossref record, not zero citations |
| DataCite same DOI | HTTP 200, publisher arXiv | Confirms DOI registration; not a substitute Crossref citation count |

The original gate demands three-source counts for citation-graph negatives. The
DataCite result explains the Crossref gap; it does not waive that requirement.
No three-source absence verdict is issued for later odd-prime rank-formula work.
The missing count is external coverage, not a remaining technical reading task.

**Feng–Luo primary access is now resolved.** The user supplied original PNG spreads
covering all nine published pages of *Optimality of the Howard–Vala T-gate in
stabilizer quantum computation*, DOI `10.1088/1402-4896/ad80e7`. Read depth:
**full text**, including Appendices A–C and references. The source register pins
all five image hashes, provenance and the scan manifest in the shared
`feng-luo-2024/` cache. No OCR was used; formulas were read from the images.
Earlier publisher-HTML and preview failures remain historical acquisition evidence.

Proposition 1 reduces both average and maximum stabilizer-input L1 magic to the
uniform-input diagonal phase state. Proposition 2, for prime d>=5, establishes
`M_max = 1+(d-1)sqrt(d)` and
`M_ave = d(2+(d-1)sqrt(d))/(d+1)` for nonzero powers of the Howard–Vala gate.
Appendix C splits off the k=0 WH sector, uses purity to fix the remaining squared
mass, and applies Cauchy–Schwarz. The equality condition is constant modulus
`1/sqrt(d)` for all k!=0 and all l; cubic finite differences reduce the amplitudes
to nondegenerate quadratic Gauss sums, proving attainment. Clifford invariance
then gives the stated gate-equivalence extension. Page 5 relates the Watson gate
to the sixth power of the Howard–Vala gate with diagonal Clifford factors.

The comparison and positioning consequences are in ledger N5/N9. The paper's
classification of all optimal diagonal gates is explicitly conjectural (p. 5),
not a theorem. The larger pure-state SIC ceiling on p. 3 is distinct from the
diagonal-orbit optimum. No source-wide absence claim follows beyond what was
actually read; this source does not repair the independent Crossref coverage gap.

Wang–Li, Dai–Fu–Luo and Alltop retain the resolved access recorded in the previous
follow-ups. No new scan request is needed for them. MathSciNet remains **NOT
COVERED** (no institutional access); Google Scholar and zbMATH are not represented
as searched negatives. Title-search discovery at MathNet supplied metadata for
the diagonal-group classification, not a reading of its full text.

Supplementary web queries (verbatim, 2026-09-07) are recorded in
`adjudication-web-queries.json`. Search snippets were used only to resolve discovery
identifiers and metadata; unrelated returned results were not consulted sources or
evidence for a negative. The graph snapshot is the finite screened set.

## Bounded extraction and post-adjudication ej + tt

This closes the named source-adjudication pass, not C1102's manuscript acceptance
gate. The construction-paper task is not pre-empted as a whole. One bounded
extraction considered the two displaced broad claims using Li–Yeh's Appendix C.1,
Heyfron–Campbell IV and Watson's VIII discussion; no recursive citation sweep or
new C task follows.

Two cheap candidates were tested:

* A new qudit synthesis/distillation mechanism: rejected by the explicit Li–Yeh
  decoding extension and the existing weighted signature-tensor compiler.
* A same-target instance comparison using the geometric phase: retained within
  N8's already approved menu. The benchmark already excludes joint synthillation,
  so the predecessor requires attribution, not a new benchmark run.

The **ej** pass adds the direct compiler citation and fixes Campbell's parameters.
The **tt** pass asks whether a broad novelty sentence survives changing the
representation: N4 must distinguish a binary-form phase from lattice amplitudes,
enumerator invariants and topological intersection phases. Those distinctions are
now explicit in the ledger. No incidental gem outside the named questions was
found, so no discovery-track entry or successor allocation is needed.

### Mystery ledger

* **Settled by the scan follow-up ej + tt pass:** the optimality proof is accessible;
  the remaining equality-class question is a stated conjecture, not missing proof
  of Proposition 2. No new task or incidental discovery is allocated.

* **Settled:** the apparent absence of qudit synthillation came from confusing
  the logical AND with its physical transversal factors.
* **Settled:** the missing Waring-to-circuit bridge was a missing citation,
  not missing mathematics.
* **Settled:** the Campbell length-p attribution was a mismatch with a length-(p-1)
  source; it does not change the separately certified length-p construction.
* **Not a mathematical mystery:** Crossref cannot supply a count for this absent
  record; Semantic Scholar now can. Exact remaining gate: a supported third count
  or an explicitly authorized revision of the count requirement. The user approved that narrow revision after the scan follow-up;
  `gate-approval.json` preserves the missing count as null, not zero.
* **Not settled by this audit:** equivalence of the explicit translation/conic
  codes with all instances of general published constructions, and unrestricted
  factory optimality. N2–N4/N8 state those limits. No new genuine mathematical
  mystery was created; the prior task-owned open questions remain with C1102.

## Validation, cache repair, and propagation

The original acquisition checker and the new adjudication checker validate the
frozen membership identity, complete disposition coverage, read-depth markers,
source and response hashes, and deterministic regeneration. They do not certify
novelty, a mathematical proof, or that metadata screening equals full-text reading.

An initial combined prerequisite read exceeded the 10,000-token producer cap and
was replaced by bounded source sections; that was a command-shaping failure.
Concurrent calls to the cache importer then collided on its shared temporary
manifest path. The corrupt bytes were preserved; 1,048 independently parsable
entries were retained and two damaged records were reconstructed from intact
metadata plus their hash-matching adjacent PDFs/texts. Missing task acquisitions
were re-ingested serially. The recovery is recorded in `cache-recovery.json`;
the subsequent whole-cache check matched all 1,045 then-registered PDF records.
No fetched PDF was lost. Future cache ingests in this task were serialized.

Updated surfaces: this report, canonical pre-draft ledger, source/disposition/access
records, task card, original audit's continuation pointer, and the Clebsch live
handoff. C1102 remains active in the queue because the manuscript task is unfinished.
Historical C1090/C1099 reports are preserved, now explicitly subordinated to N1–N9
by the card/report pointers. The benchmark report's scope already agrees with N8.
No companion manuscript, public snapshot or public summary exists at the proposed
companion root; none is created. No series manuscript, Lean source, mirror or public
release changes. The optional unverified cross-lane apolarity citation stays unused.

Replay from the repository root:

```sh
python3 notes/2026-09-07-c1102-forward-citations/verify.py
python3 notes/2026-09-07-c1102-forward-citations/verify_adjudication.py
```

**Next C1102 action:** resolve the two explicit Gate-1 coverage limits (Crossref
count and Feng–Luo primary access), or obtain an explicit author decision on a
revised bounded gate. No manuscript text is authorized by the current verdict.

## Approved citation closure (2026-09-07)

The user confirmed the Hessian source is preprint-only and explicitly approved
its Crossref coverage exception. This closes Gate 1 and the remaining citation
adjudication, with the N1–N9 restrictions intact. C1102 itself remains active as
a writing task. The original acquisition report/checker remain frozen historical
artifacts; the adjudication checker validates the current approval and evidence.

Post-gate **ej + tt**: separate literature availability from technical novelty.
No further paper access is required for this citation decision, and the absence
of a Crossref record supplies no mathematical distinction or priority evidence.
The mystery ledger's open equivalence and unrestricted-factory questions remain
outside this bounded result. No new mystery, incidental discovery, or successor
allocation arises from the approval.

Propagation: current ledger, task card and live handoff updated; the original
acquisition snapshot and historical proposals are labeled as such. No companion
manuscript or public summary yet exists to update. The next work is the approved
four-part companion draft; title/directory proposals remain provisional.
