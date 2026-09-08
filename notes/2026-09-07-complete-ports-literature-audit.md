# Complete-ports: theorem-level literature audit

Date: 2026-09-07. Scope: the current operational revision of *Exact Compositional
Transfer of Bounded Linear Recovery*, especially its new related-work wording.

## Summary and limits

**Read depth: 0 sources read in full in this audit; 11 primary sources read
partially at the exact passages listed below.** Cached full PDFs were available
for all eleven. This is a theorem-level attribution and positioning audit,
with a bounded keyword search, not a complete reading of the bibliography or a
forward-citation closure. Earlier lane audits are historical inputs, not evidence
that their sources were read again here.

The manuscript now credits three existing ingredients more precisely: prescribed
coset-tuple support costs, recovery methods carried by dual words, and preservation
of service regions on restricting to minimal recovery sets. It compares its
confinement conclusions with transport of recovery sets in matrix-product codes,
and gives exact source locators for the classical message-passing and interface
minimization mechanisms. The contemporary batch-code citation uses the September
2026 revision and its revised title.

The owning claim–proof–novelty ledger is
`2026-09-07-complete-ports-claim-proof-novelty-ledger.md`. Its rows are deliberately
qualified: this search does not establish publication priority. No source located
in the inspected passages forces replacement of the exact confinement formula or
the target-touching minimal-support transfer proof. This is a bounded comparison,
not a claim that the entire literature lacks either theorem.

## Source register

All eleven entries have depth **partial**. Access was the shared cache's PDF and
searchable `pdftotext` extraction under `/tmp/persistent/tavis/lit-search/`.
Keys and PDF hashes identify the bytes. No scan/OCR source was used. Original
formula text was inspected where needed; the badly extracted formulas in S07
were not used to infer a new mathematical identity. The report's comparisons
are the auditor's inferences from the specified passages.

| ID | Source, version read, cache key | Passages actually read and use | SHA-256 |
|---|---|---|---|
| S01 | Márquez-Corbella–Martínez-Moro–Munuera, *Computing Sharp Recovery Structures for Locally Recoverable Codes*, arXiv v1 (2019), `arXiv:1907.05316` | Introduction and §2 through Corollary 3 (text lines 1–224). Proposition 1 relates recovery to dual words; Corollary 2 treats minimality. The opening announces an algorithm returning recovery methods. The algorithm and experiments were not audited. | `a9060ca8f7901885f1e077076c73dd7d03f8ae995a2232e891ce74c39e4ea927` |
| S02 | Alfarano–Ravagnani–Soljanin, *Dual-Code Bounds on Multiple Concurrent (Local) Data Recovery*, arXiv v2, 14 May 2022, `arXiv:2201.07503` | Opening metadata; §2 definitions 2.2–2.5; §3 in full, especially Proposition 3.3 and its flow-reassignment proof (text lines 95–155, 215–254). The dual-distance bounds in later sections were not read. | `75dfdc9b233c2f091e987790b6cff029551b59d0289d85f0b9b3d8b30a712bbc` |
| S03 | Zhang–Yaakobi–Etzion–Schwartz, *On the Access Complexity of PIR Schemes*, arXiv v1 (2018), `arXiv:1804.02692` | §IV-B definition of tuple coset weight and Lemma 7 (text lines 582–597; heading recovered at 628 due to two-column extraction). Both a fixed tuple minimum and the worst-case code invariant occur here. The cited 2019 proceedings version was not separately read. | `904ff548b692a9a44ff89f238f0240004cc6cb2201b3f2e2e4b823dd16f83ccc` |
| S04 | Elimelech–Firer–Schwartz, *The Generalized Covering Radii of Linear Codes*, arXiv v1, 11 December 2020, `arXiv:2012.06467` | §III, Definition 1 and opening of Lemma 2 (text lines 195–230): maximum over syndrome sets of minimum column support. The cited 2021 published version was not separately read. | `3824adb41a84705d902d9d4933a9467103129c9e32a83f122b36da09eefc71f2` |
| S05 | Jin–Fu, *Constructions of Locally Repairable Codes via Concatenated Codes*, arXiv v1, 6 May 2026, `arXiv:2605.04618` | Construction 3.2 and beginning of proof (text lines 455–494): binary [3,2,2] inner code and F4 outer code. No verdict on all their constructions or bounds. | `69847fc4ed1ada75f615ab8d2b2c08484da31253d278f9485cd03f5ab9587d93` |
| S06 | Galindo–Hernando–Munuera–Ruano, *Locally Recoverable Codes from the Matrix-Product Construction*, arXiv v1 (2023), `arXiv:2310.15703v1` | §3 opening, §3.1 Lemma 7, Proposition 8 and its proof, Remark 1 (text lines 305–351); preceding construction notation (245–305). A recovery set and its coefficients pass to a matrix-product block. This is explicitly the old v1; no attribution is transferred to the replacement at the unversioned identifier. | `14775402dc5e622dad2c5a57f4cf148b25b15340a7515688d369a1372e0de12e` |
| S07 | Aji–McEliece, *The Generalized Distributive Law*, published paper (2000), DOI/cache key `10.1109/18.825794` | §III scheduling statement and surrounding message-trellis explanation, Theorem 3.1 (text lines 838–888). Supports the established general message-passing principle; appendix proof and full complexity analysis were not read. | `6aed6b53e9c21951f801b4bac509db26c6a68b65aa26c5a1de690cff0277779a` |
| S08 | Kashyap, *On Minimal Tree Realizations of Linear Codes*, arXiv v1, 9 November 2007, `arXiv:0711.1383` | §2.2 cut-state quotient and dimension formulas (text lines 305–390); §3 Theorem 3.4, its proof, Corollary 3.5 and the construction-cost caveat (490–559). The analogy with the paper's affine contribution-space boundary is our inference. §5's alternative construction was not read. | `3bd157d011afbb63807a80576584c172eede6758584500c12602b04b8ad68add` |
| S09 | Mohri, *Weighted Automata Algorithms*, author-hosted handbook chapter associated with DOI/cache key `10.1007/978-3-642-01492-5_6` (2009) | §6.4 through Theorem 8 and its complexity paragraph (text lines 2329–2361). Deterministic weighted automata; weight pushing and its semiring applicability assumptions precede minimization. Publisher pagination was not separately checked against this author manuscript. | `f7976bf3d934654c2f56af38637e11a526b8d3201803b8c77b9c53ad5472399d` |
| S10 | Funk–Mayhew–Newman, *Tree Automata and Pigeonhole Classes of Matroids: I*, arXiv v5, 6 November 2022 (first posted 2019), `arXiv:1910.04360` | §2 definitions 2.1–2.2, Proposition 2.3 with proof, Proposition 2.4 and definition 2.5 (text lines 175–245). Exterior indistinguishability and union congruence are established. No full audit of their algorithmic theorems. | `690781fe527daa510f56a23e527eab3c0461e972ae4968465545a65a2011ba70` |
| S11 | Düzgün–Hollmann–Riet–Skachek–Taranchuk, *Recovery Models for Linear Batch Codes*, arXiv v2, 1 September 2026, `arXiv:2605.09748v2` | Abstract and §I (text lines 1–110), describing online/asynchronous selection and the hierarchy of models. Later proofs were not read; cited only to locate these problem variants. Search snippets still used the earlier title *Recovery Algorithms for Linear Batch Codes*. The live primary record and cached v2 settle the current title. | `ec3208a3f9503e9ed62e147f23e9776f54652f56fb262e28554e5e084c084bf9` |

Primary URLs: S01–S06, S08, S10 and S11 use `https://arxiv.org/pdf/` followed
by the identifier and stated version. S07 was obtained from
`https://authors.library.caltech.edu/records/sw1pm-bwj40/files/AJIieeetit00.pdf?download=1`.
S09 was obtained from `https://cs.nyu.edu/~mohri/pub/hwa.pdf`.
Cache lookup preceded retrieval; only S11 required a new download in this pass.
S02 and S11 live arXiv metadata were also opened on the audit date.

## Dispositions

1. **Coset terminology corrected.** The previous sentence made a misleading
   division between generalized coset weights and generalized covering radii.
   S03 already has both levels. The ordinary local cost is the fixed-tuple
   quantity; target normalization, the outer compatibility relation and the
   nonzero kernel sector are the extra information in the transfer problem.
2. **Coefficient attribution corrected.** The previous grouped description
   could suggest that S01 omitted recovery coefficients. It does not. The
   manuscript now credits its dual-word characterization and recovery methods.
   What subsequent composition needs is the induced functional label.
3. **Minimal-support service principle credited.** S02 Proposition 3.3 is an
   explicit predecessor for passing to inclusion-minimal recovery sets. The
   paper proves preservation of that family under a target-touching outer
   distance condition; the ensuing capacity and reliability conclusions use
   that preservation. Its arbitrary capacities/radius restriction are checked
   directly by the manuscript's same load-decreasing reassignment argument.
4. **One-way transport distinguished from confinement.** S06 Proposition 8
   transports local repairs, including coefficients. It is not being described
   as a mere parameter construction. The manuscript's reverse control over all
   bounded global equations/minimal supports is stated separately.
5. **Generic algorithms credited rather than advertised.** S07–S10 receive
   precise locators. Width-based elimination and contextual equivalence are
   classical frameworks. The recovery statements declare the labels, target
   normalization, witness lifting, bounded observations and explicit separator
   bounds. The width proof now counts pair combinations separately from field
   arithmetic, and distinguishes affine compatibility from table realization.
6. **Current operational boundary added.** S11 places online/asynchronous
   batch recovery beside the present simultaneous capacity model. No guarantee
   about adversarial request histories is inferred from the allocation LP.

## Search record and screened sets

Service: web search tool, 2026-09-07. No date filter unless noted; Q17–Q20 used
the `arxiv.org` domain filter. Screened fields were displayed titles and search
snippets/abstracts, not full texts. The discriminator was: “Promote works
concerning linear-code recovery, prescribed coset support, composition, service
regions, or finite-interface minimization. Discard lexical matches outside
these subjects.” Search-engine results are neither a complete database query
nor an exhaustive set of publications. Many exact-phrase hits were off-topic.

The initial exploratory batch was:

```
Q01 "linear recovery" "concatenation" "functional" code
Q02 "minimal recovery sets" "dual distance" concatenated
Q03 "prescribed" "coset" "support" concatenated code
Q04 "contextual equivalence" "linear codes" recovery
```

Its durable result set/count was not retained; it is excluded from any negative
coverage claim. It supplied the lead to S02, subsequently checked directly.

Verbatim Q05–Q16, all displayed result titles/URLs and pooled batch counts are
in `2026-09-07-complete-ports-literature-search.json`: 22, 24 and 22 entries.
One Q05–Q08 entry had no title and is recorded as such. Q17–Q20 and their nine
entries are in `2026-09-07-complete-ports-literature-search-arxiv.json`.
Thus the retained search record contains **77 returned entries**, with duplicates
across queries and batches retained. These are result-entry counts, not unique
works or an estimate of the size of the literature. No per-query counts are
inferred from pooled responses. S02, S05, S08 and S11 were promoted from these
searches or the initial batch; the other sources were selected from the existing
paper bibliography for exact comparisons. Unpromoted hits are covered only by
the title/snippet screen, not by an individual source verdict.

## Access gaps and novelty boundary

- All eleven intended primary texts were accessible. S03/S04 were read as
  preprints, not their later published versions; the bibliography now also
  exposes those exact preprint identifiers. S09 used the author version.
- MathSciNet: **NOT COVERED**, no institutional session. Google Scholar:
  **NOT COVERED**, no automated-access coverage claimed. zbMATH Open:
  **NOT COVERED**, not queried in this pass.
- OpenAlex, Crossref and Semantic Scholar citing-set enumeration:
  **NOT COVERED**. No count, zero, or exhaustive forward-citation claim is made.
  A future citation-graph negative must independently obtain all three counts
  and screen the largest resolved set under the conventions.
- This pass did not audit every cited relative-weight, repair-bandwidth, coded
  computation, or representative-family paper. It establishes no novelty verdict
  for the adversity-catalog sequel or a general quantum extension.
- The lack of a matching theorem in the inspected passages is distinct from a
  complete absence claim. The ledger preserves that distinction.

## Surface reconciliation

| Surface | Check and disposition |
|---|---|
| Manuscript | Related-work subsection rewritten; service-region source added; exact preprint access and current v2 batch-code citation added. No independent “first” or “to our knowledge” sentence introduced. |
| Claim–proof–novelty ledger | Created the owning rows with this audit's limited coverage. No universal priority assertion. |
| Paper README | Inspected the finite-cost and composition descriptions; no erroneous coset-weight contrast or assertion that earlier recovery methods lacked coefficients. Unchanged. |
| Public portfolio authority `papers/summary/README.md` | Inspected the complete-ports entry (around line 809) and selected table rows. It states positive theorem content and does not repeat the corrected source comparisons. Its old bundled-Ergodis link/older abstract are a separate stale surface; noted here, not edited across lanes. |
| `notes/2026-07-31-results-summary-snapshot.md` | Inspected complete-ports transfer/composition passage around lines 2438–2468 and targeted matches. It does not repeat the corrected comparison. Historical snapshot unchanged; not cited as evidence for the paper. |
| Earlier positioning report | The historical C976 audit is not rewritten. This report supersedes any implication that S03 discusses only fixed cosets, or that recovery-method predecessors omit coefficients. |

## Closeout and mystery ledger

The `ej`/`tt` pass asks whether the attribution repair reveals a simpler account
of the contribution. Settled: the central distinction is now one-way local
transport versus exact reverse confinement; generic min–sum computation is not
asked to carry the novelty claim. The explicit rational incidence seed also
removes an implicit properness assumption from the reliability example, and the
width invariant handles infeasible tables without an unstated realization
assumption. No additional unexplained mathematical phenomenon was found in this
bounded pass. Publication-level novelty remains an evidence gap requiring broader
primary reading and, if used, a recorded three-service citation-graph audit.

One output-shaping failure occurred when several cache records were printed in
bulk and tool output was truncated. The records were subsequently queried in
bounded form, and all source hashes and read depths above were recovered from
the actual cache and reading trace. Truncated output supports no claim here.

Build, rendered-page review and synchronization outcomes are recorded in the
companion improvement report after the final gate. No referee grades are stored.
