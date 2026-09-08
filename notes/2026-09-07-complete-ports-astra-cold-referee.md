# Complete-ports: independent Astra cold referee report

Date: 2026-09-07. Reviewer: GPT-6 Astra. Manuscript: *Exact Compositional Transfer of Bounded Linear Recovery*, 43-page supplied PDF.

Read-snapshot SHA-256: main TeX `88a895b0ac150a156977c3fc1b49cd9bf3b0842af1da9b8826905461b62f739d`; PDF `3f7915129e8fbffc48b7799dc959d4d490ea2bff7d28ee906b9ae4fd1bedcbc7`.

## Assessment and scope

The main two-sector nonconfinement formula has a coherent human proof. A global dual system induces a map into the outer functional dual; nonzero labels force external activity because the target projection is surjective; fixed labels permit independent blockwise support minimization. The zero-label sector requires a local recovery plus a nonzero external inner-dual map. These are exhaustive cases, and the proposed costs are attained. I found no counterexample to this theorem or to the stronger minimal-support confinement theorem on the stated nonzero-target domain.

The most useful distinction is between preserving all coefficient systems and preserving operational recovery alternatives. The target-touching-distance proof deletes external coefficients after proving that the target block's functional label vanishes. It therefore transfers minimal supports under a weaker condition than equation confinement, and its pointwise availability assertion genuinely supports arbitrary availability laws with the same local marginal. The fractional and integral allocation consequences are justified for the explicitly defined support-load model.

The manuscript nevertheless needs corrections before it can serve as a precise account of its numerical interface and empirical evidence. The findings below distinguish incorrect or incomplete claims from optional improvements. None is a verdict about novelty or priority. The paper situates its component ideas among several established theories, but I did not perform an external literature audit.

All paths below are relative to `papers/complete-repair-ports/`. Semantic labels identify mathematical statements independently of their rendered numbers.

## Severity-ranked findings

### Substantive correction — NONZERO-KERNEL-STATE: fibre minima alone do not determine the nonconfinement response

Locations: `figures/information-hierarchy.tex:11–16,24,29–35`; `sections/03a-exact-recovery-optimization.tex:131–137`. Relevant statements: `thm:ungated-ranked-confinement`, `eq:weighted-subspace-cost`, `eq:dual-distance-composition`.

The diagram sends “minimum support cost for each induced functional” directly to the exact nonconfinement cost. The optimizer discussion likewise says the resulting table supplies all costs needed by the finite confinement formula, including its zero sector. This omits a datum: the minimum cost of a **nonzero** kernel lift. Ordinary zero-label fibre minimization returns zero and discards that information.

A same-length counterexample makes the distinction exact. Work over the binary base field, identify the two-dimensional message space with the same extension field L, target the first coordinate, and use generator columns

```
G1 = (e1 | e2, e1+e2, 0),
G2 = (e1 | e2, e1+e2, e2).
```

Both ordinary prescribed-label cost functions are identical, including their joint-map versions: a zero column never improves a support minimum, and any use of a repeated e2 column can be merged into the original e2 column with no larger support. The target-normalized cost functions are identical for the same reason, since that merger involves helpers only. Both have rho_T = 2 for T = span(e1).

But G1 has an inner-dual word supported on the zero coordinate, so d(I1-perp) = 1. G2 has no zero column and has two equal columns, so d(I2-perp) = 2. For the full outer code O = L^2, the functional dual is zero and the exact formula gives Gamma = 3 for G1 and Gamma = 4 for G2. Thus even identical labelled ordinary and target-normalized fibre minima do not determine Gamma.

This does **not** invalidate min–sum composition of the fibre cost tables, the quotient-lifting theorem, or the central formula: the central formula correctly retains d(I-perp), and `sections/03-positive-density.tex:461–475` explicitly gives its separate recursion. The correction is to identify the actual nonconfinement interface as the labelled costs **together with** the nonzero-kernel cost (and target split/normalization), and to show that additional input in the diagram and optimizer description. Numerical composition of ordinary fibre minima and numerical sufficiency for Gamma must remain distinct claims.

### Substantive correction — TIMING-CONTRACT: the retained measurement descriptions disagree

Locations: `sections/03a-exact-recovery-optimization.tex:354–370,378–383,393–415,421–431`; `figures/ergodis-benchmark-highlights.tex:26–36`. Rendered pages 32–33.

The measurement protocol says elapsed times are monotonic **in-process** times, application controls use eleven rounds, Rust kernels use seven, and the only exceptions are identified single completed solves. The table caption instead specifies fresh-process cold solves and eight-solve warm batches normalized by **external wall time**. The later published-code comparison uses three corrected cold pairs, and the tower discussion also uses three paired rounds. These cannot be read as one unqualified protocol.

There is also a definite stale reference: lines 366–370 refer to the cloud-LRC table's displayed “<1 microsecond” value, but the displayed table contains ratios and no such timing. The prose therefore does not identify which measurement its qualification applies to.

Provide a workload-to-protocol mapping, or rewrite the protocol around exactly the retained tables and graph. Distinguish kernel-only amortized timing, in-process construction-and-solve timing, and external fresh-process timing, with the relevant sample count for each. This is an evidence-description defect, not evidence that the reported ratios are numerically false. I did not run the benchmarks.

### Substantive evidence limitation — SNAPSHOT-IDENTITY: software and benchmark claims lack a fixed artifact identifier in the manuscript

Locations: `sections/03a-exact-recovery-optimization.tex:9–24,48–58,362–364,429–431`; `sections/07-verification-provenance.tex:4–39`.

The broad implemented-interface claims refer to a September 2026 development system, while explicitly warning that release snapshots may expose less. The numerical evidence is directed to generic repository paths and a mutable repository URL. No commit, release tag, or archived version identifies the exact development surface or benchmark snapshot being described. The Lean section pins Lean and Mathlib, but gives no companion release URL/version identifying the audited paper-owned source and audit output.

A reader cannot determine solely from the paper which exact implementation and evidence bundle support these historical claims. Pin the software/evidence version separately from the Lean companion, and provide the corresponding artifact locations. This request does not ask to expand formal coverage: the narrow formalization boundary is already stated honestly. I have not verified availability or contents of the external repositories and am not alleging that the artifacts are absent.

### Local mathematical correction — MINIMAL-SUPPORT-IFF: the pointed proof asserts an equivalence that fails for minimal supports

Location: `sections/03-positive-density.tex:968–970`, in the proof of `thm:weighted-pointed-confinement`. Compare its correctly one-way statement at lines 943–944 and `thm:minimal-support-confinement`.

The proof says that the equivalence also holds for exact helper-support families “and their inclusion-minimal members.” Read as an equivalence for minimal members, this is false. Let I be the binary code with generator columns (e1 | e2,e1+e2), target its first coordinate, and let O = L^2. The local minimal support is the pair of helpers. All global minimal supports are local at every radius because the outer blocks are independent. Yet an external inner-dual word of weight three can be appended to the local recovery, producing a nonconfined equation with five helpers. At radius five, minimal-support equality holds while the strict pointed confinement inequality fails.

The theorem statement already handles this correctly: exact equation/support equality is equivalent to the threshold, and minimal-support equality follows when that threshold holds. Remove the final proof sentence's extension of the iff to minimal members. The stronger minimal-support theorem supplies the correct operational conclusion.

### Local convention correction — F4-TRACE-LABELS: the separation table needs its functional identification stated

Location: `sections/03-positive-density.tex:315–349`, `prop:functional-label-separation`; compare the trace identification at lines 57–65.

The example explicitly interprets the displayed field elements as binary generator columns in the basis (1, omega). For the corresponding encoder on message coordinates in that basis, a column represented by a field element c induces the functional

```
a |-> Tr(omega^2 c a),
```

not `a |-> Tr(c a)`. Indeed the columns e1 and e2 have trace coefficients omega^2 and 1. Consequently, under the preceding trace-coefficient convention, the ordinary costs in label order (1, omega, omega^2) are (1,2,1) and (2,1,1), and the target-normalized costs are (2,1,0) and (1,2,0). The table prints the costs for a different identification of field elements with functionals.

This is a convention defect, not a failure of the claimed separation. The common multiplier omega^2 merely reindexes the nonzero multiples of the same outer line. For the fixed outer trace-dual line spanned by (1,omega), the corrected total costs in row order s = 1, omega, omega^2 are (4,2,1) and (2,3,2); the minima remain one and two. Either specify the alternate functional identification used in the table or use trace-dual encoders/corrected table entries consistently. This example is the reader's principal concrete evidence for label sensitivity, so its identification should not be implicit.

## Optional improvements and scope clarifications

1. **Front-load an evaluable main statement.** `compositional_recovery.tex:184–218` introduces Gamma only schematically before declaring the main characterization. In the PDF the main theorem is on page 4, after a large figure and a six-question table. Its statement becomes an exact computational characterization only after the definitions of lambda, mu, and the two-sector formula on later pages. A compact rank-one formula or the full finite formula earlier would let the reader see the optimization content immediately. The current opening explains motivation clearly but repeats its information hierarchy in the abstract, figure, table, and surrounding paragraphs.

2. **Make the leaf-relative congruence contract explicit in the headline wording.** `thm:rank-one-contextual-state` and `cor:bounded-contextual-state` restrict later contexts to the same distinguished target leaf and induced image. Within that contract, flattening later layers to C composed with A justifies the argument. It does not establish arbitrary replacement under changed target sets, changed observables, or a changed definition of which block constitutes escape. The detailed text acknowledges this; the introduction's bare “congruence” and “smallest exact bounded state” language could carry the leaf-relative numerical qualification more visibly. I found no counterexample within the stated restricted contract.

3. **State the simplex characterization's comparison class.** `sections/06-geometric-flagships.tex:196–199` says that at the same helper length, attaining the first recovery cost characterizes the simplex multiset. The intended comparison should specify an m-dimensional linear helper code with zero lower code, or the corresponding exact nested-pair hypotheses. Length and one recovery minimum alone do not characterize a general nested pair. Under the intended m-dimensional code interpretation, supply the short averaging step forcing equidistance before applying the cited classification. This is a request to make the scope of an unnumbered claim explicit, not a literature-based rejection of the intended statement.

4. **Reduce the software detour for a theorem-led reading.** The implemented interfaces and verification mechanisms at `sections/03a-exact-recovery-optimization.tex:20–64` include CSS search, campaign control, browser surfaces, readout admission, and four-by-four transition summaries. Most are not needed to understand or verify the recovery theorem. The scalar optimizer, support antichains, price/availability equivalence, and fixed-query width proof directly develop the mathematics; the broader system inventory competes with that development. Moving the inventory and measurement detail into a clearly scoped artifact appendix would improve the hierarchy without changing the contribution.

## Proof and evidence audit

I read every displayed human proof, rather than relying on the formal-coverage annotations. In addition to the central arguments described above, the following mechanisms survived this audit:

- The puncturing/shortening description and support-preserving correspondence with relative generalized weights follow from the displayed linear maps and taking complements to the helper kernel.
- General quotient-labelled lifting and target-normalized tower composition minimize over independent lifts on disjoint blocks. The target contribution variables retain the normalization constraint, and the trace-transitivity paragraph justifies the change between tower levels.
- The small-context argument retains the span of the image and at most r external active blocks. Its final witness paragraph correctly retains coefficient activity even when a block's functional label is zero; otherwise the witness claim would fail.
- Restricting a nonconfined higher-rank system to a line on which an external map is nonzero proves the all-rank bottleneck. This is a statement about simultaneous confinement across ranks, not equality of each rank's escape cost.
- The support-antichain substitution, all-prices/availability equivalence, and boundary-coordinate dynamic program have direct proofs. The width bound charges local compilation separately and does not promise to construct all label tables cheaply.
- The best-target generalized-weight identity, MDS spanning argument and rigidity, positive-density random-code argument, and service-region transfer are supported by the text. The best-target proof explicitly handles dependent target columns using target-only kernel relations.
- The reliability separation supplies a human representation argument, inclusion–exclusion data, and a direct-sum extension to all quotient ranks. The plane arrangement's genericity argument is compressed, but I found no forced-incidence counterexample in either specified skeleton. The projective-simplex weights and stochastic rank law have transparent counting proofs. The latter concerns retaining some t-dimensional recovery space, as its statement says, rather than recovering every prescribed t-space.
- The bilinear example has the claimed unique coefficient vector by comparison of its four tensor coefficients. Its impossibility certificate is appropriately scoped to linear aggregation of the specified worker outputs.

The four Lean declarations are expressly confined to the associated-pair exact sequence; the text does not claim that they verify the main transfer theorem. No benchmark execution appears as a premise in the human theorem proofs. Conversely, descriptions of checker contracts and witness reconstruction are not, by themselves, evidence of source-model optimality; the manuscript generally observes this distinction well.

## Exact read coverage and limitations

Read in full:

- `compositional_recovery.tex`, lines 1–343.
- `formal-annotations.tex`, lines 1–21.
- `sections/01-complete-ports.tex`, lines 1–86.
- `sections/02-confinement-transfer.tex`, lines 1–283.
- `sections/03-positive-density.tex`, lines 1–1063.
- `sections/03b-related-work.tex`, lines 1–52.
- `sections/05-pointed-tutte.tex`, lines 1–276.
- `sections/03a-exact-recovery-optimization.tex`, lines 1–442.
- `sections/04-reliability-exit.tex`, lines 1–331.
- `sections/06-geometric-flagships.tex`, lines 1–199.
- `sections/07-verification-provenance.tex`, lines 1–61.
- `sections/08-conclusion.tex`, lines 1–72.
- All three included figure sources: `information-hierarchy.tex` (39 lines), `ergodis-pipeline.tex` (26), and `ergodis-benchmark-highlights.tex` (39).
- `refs.bib`, lines 1–650, including entries not cited in the rendered bibliography.

I checked the include directives to confirm the coverage above. I inspected rendered PDF pages **1, 2, 3, 4, 27, 32, 33, and 40** as images, covering the opening, main theorem, all three figures, benchmark table, and formal-coverage table. I also extracted the PDF text to locate these pages; I did not visually inspect every PDF page and make no claim of exhaustive typography/reference validation. The inspected figures are readable; the application table is substantially denser and smaller than the surrounding prose. The PDF has 43 pages.

For routing and instructions, I read the root `AGENTS.md`, the selected complete-ports entry handoff, and `papers/style-guide.md`. The handoff was used as routing context only, and no linked revision report or archive was opened. I did not read prior conversation, prior reviews, revision reports, brainstorms, expert dossiers, or `REVIEWER_GUIDE.md`.

I did not read or execute the Lean source, run Lean/Lake, run benchmarks, inspect external software source/evidence, or retrieve the bibliography's original articles. Bibliography coverage means the manuscript entries were read, not that their metadata, theorem citations, or completeness were independently validated. Accordingly there is no novelty, priority, citation-accuracy, kernel-audit, or empirical-replay verdict here. No manuscript files were edited. This report is intentionally left uncommitted for the requesting parent to verify and commit.

## Closeout and mystery ledger

An explicit extra-value and alternative-view closeout pass tested whether the interface descriptions preserve zero-label **activity**, whether the operational theorem accidentally retains the equation threshold, and whether numerical costs are being conflated with witnesses or probability events. It produced the nonzero-kernel counterexample above and confirmed that the small-context witness proof already handles zero-label activity correctly.

No unresolved mathematical mystery was discovered that warrants a new research task. The remaining uncertainties are specified audit limits: external literature comparison, original-source citation verification, fixed-version artifact identification, and independent empirical/formal replay. The main acceptance question for this report is correction of the explicit interface and evidence descriptions, followed by the separate audits actually needed for release.
