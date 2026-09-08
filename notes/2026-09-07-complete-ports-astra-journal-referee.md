# Journal-style referee report: Exact Compositional Transfer of Bounded Linear Recovery

Reviewer: GPT-6 Astra. Date: 2026-09-07.

This report assesses the frozen 43-page manuscript read for the independent cold review. It does not assess subsequent repairs. The original technical report is preserved in `notes/2026-09-07-complete-ports-astra-cold-referee.md`; its semantic finding identifiers are used below to avoid duplicating full counterexamples. The frozen main TeX has SHA-256 `88a895b0ac150a156977c3fc1b49cd9bf3b0842af1da9b8826905461b62f739d`, and the PDF has SHA-256 `3f7915129e8fbffc48b7799dc959d4d490ea2bff7d28ee906b9ae4fd1bedcbc7`.

## Summary and recommendation

The manuscript studies which information about linear recovery must be retained to answer exact recovery questions after concatenation. It first identifies minimum helper unions with relative generalized Hamming weights of a canonical puncturing–shortening pair. It then decomposes recovery equations according to the functional induced on each inner block, obtaining an exact two-sector formula for the first nonconfined recovery system. Labelled lift costs compose by min–sum substitution. A separate theorem shows that inclusion-minimal recovery supports remain local under a weaker target-touching outer-distance condition, yielding transfer of availability events and support-based service regions. Further results address finite contextual tests, information lost by coarser invariants, extremal codes, and fixed-query optimization.

The natural primary audience is coding theorists interested in locality, concatenation, generalized weights, and recovery-set structure. Researchers in exact algorithms, represented matroids, and distributed-storage optimization form a plausible secondary audience. The paper has enough common structure to serve these readers, but the present organization does not consistently distinguish the central coding-theoretic results from the broader software and interface programme.

**Recommendation: major revision.** This recommendation concerns the organization of the contribution, precision of the stated numerical interface, and presentation of empirical evidence. I did not find a failure of the main two-sector formula, the minimal-support transfer theorem, or the labelled-lift composition proof. The paper nevertheless needs more than local copyediting: the opening should state an evaluable principal result, the theorem hierarchy should reflect the operational distinction the paper establishes, and the software section should be brought into proportion with the mathematics and attached to an unambiguous evidence contract. The technical corrections identified in the original report are specific and appear repairable.

## Contribution, significance, and coherence

The contribution I can assess from the manuscript is a precise synthesis around a well-defined question: which local distinctions can a subsequent linear-code context observe? The answer separates several notions that are easy to conflate. Relative weights retain minimum helper counts; supports retain availability and overlap; functional labels retain compatibility under concatenation; coefficient lifts supply witnesses. This separation is useful because it explains why a summary adequate for locality need not be adequate for exact composition or scheduling.

The clearest mathematical payoff is the difference between equation confinement and minimal-support confinement. An irrelevant external dual equation can destroy the former without creating any new operational recovery option. The target-touching-distance argument captures that distinction with a short proof and gives immediate, accurately scoped consequences for reliability and capacity sharing. This result deserves prominence comparable to the exact escape formula.

The general lifting and min–sum arguments use accessible linear algebra, and the manuscript usually explains their mechanism rather than concealing it behind formalization. The finite outer-test bound supplies a more specific structural statement than the bare assertion that contextual equivalence exists: a distinction below a helper budget has a bounded witness. The separation examples also help establish why the selected data matter.

These observations support the relevance and internal coherence of the project; they do not establish historical novelty. Several component theories are classical and are identified as such in the paper. I have not checked the original articles or conducted a search sufficient to determine whether the particular synthesis, separator bounds, or operational formulation have close predecessors. My recommendation assumes that the author will maintain an appropriately qualified contribution account and complete that separate literature check.

## Major comments

### 1. State the actual optimization problem before announcing its characterization

The introduction is conceptually intelligible but too indirect mathematically. The main theorem appears on rendered page 4, after an information-flow figure and a six-question table. Its value Gamma has only been described schematically. As a result, the statement that the minimum nonconfined cost equals Gamma is not yet an evaluable characterization for a reader who stops at the theorem.

I suggest reorganizing the opening around one small example and two principal statements. Introduce the represented encoder, the functional label, and the distinction between ordinary and target-normalized fibre costs in the minimum detail needed to display the two-sector formula. Then state the operational minimal-support theorem alongside it. Immediately explain why the zero sector contains an unrelated external dual perturbation and why that perturbation disappears when only minimal supports are observed. The full higher-rank definitions can follow if a rank-one opening makes the statement easier to read.

The present small example in `sections/03-positive-density.tex:202–223` would work well earlier. It shows both the additive escape cost and a concrete allocation constraint. The functional-label separation can then explain why the scalar answer cannot be used as the next composition state. That sequence would make the paper's purpose, main result, and limitation available without requiring the reader to traverse several layers of forward references.

### 2. Give the theorem hierarchy a clear center

The manuscript contains a substantial number of theorem-like statements, but their rhetorical weight is relatively uniform. The exact sequence is a short linear-algebra observation; its recovery interpretation, the exact escape formula, the operational transfer theorem, contextual separator bounds, and application consequences do different jobs. Readers should not have to infer which are definitions made useful, which are the principal structural assertions, and which are consequences.

A workable hierarchy would be:

- Core recovery model and associated nested pair.
- Exact labelled escape formula and the distinct minimal-support transfer theorem.
- Composition and the finite numerical context tests.
- Separations explaining which coarser data fail.
- Consequences and a worked family.
- Algorithmic realization and separately scoped artifact evidence.

This is a suggested organization, not a request to adopt these exact section titles. In particular, the relative-weight correspondence should remain, but its classical role can be explained briefly before the paper moves to the compositional question. The quotient-lifting theorem may be introduced as the general form of an already understood mechanism rather than as another abstraction before the reader has seen the main concatenation example.

The rank-one bottleneck should also be worded consistently as a criterion for *simultaneous confinement over all recoverable ranks*. It is not an assertion that the first escape cost at each rank is identical. The detailed proof is clear on this point; the compact summary language should be equally precise.

### 3. Make the exact retained state explicit, including its observation contract

The information-hierarchy figure is useful, but its left branch is currently incomplete for computing nonconfinement. As explained in finding **NONZERO-KERNEL-STATE**, ordinary and target-normalized fibre minima can agree for two same-length encoders while their nonconfinement costs differ. The missing quantity is the minimum cost of a nonzero kernel lift, recorded here by the inner-dual distance. The central formula includes that quantity correctly, and its separate recursive formula is supplied later.

Specify the actual retained data whenever the paper claims numerical sufficiency for Gamma. The diagram, optimizer discussion, and recursion should use the same description. At the same time, keep the valid statement that ordinary fibre-cost tables compose by min–sum substitution: that statement does not require the same extra activity information.

The contextual quotient also needs its contract attached whenever it is called “minimal” or a “congruence.” The detailed definition fixes the same target leaf and induced target image and compares numerical escape responses under compatible outer contexts. This is a meaningful result. It does not automatically preserve coefficients, support overlap, new prices, or a changed target. The manuscript recognizes these boundaries, but readers encounter the broad terminology before all the qualifications. One compact definition of the observation contract, used consistently thereafter, would be preferable to repeated later disclaimers.

### 4. Rebalance the software discussion and make the retained evidence self-contained

The mathematical algorithmic section contains useful results: exact dynamic programming, support-antichain composition, the equivalence between all nonnegative prices and availability, and the boundary-width bound. These follow directly from the paper's recovery model. They should be easy for a reader to distinguish from the inventory of capabilities in a separately developed system.

The material on CSS-distance search, campaign control, browser surfaces, readout admission, and specialized transition checkers is not required for the recovery proofs. It makes the section read partly as a system description whose specification and evaluation live elsewhere. I would keep the mathematical optimizer and its complexity statements in the main text, shorten the software overview substantially, and move the broader feature inventory and detailed measurements to an artifact section or appendix. If the author instead intends a combined mathematics-and-systems paper, the system's scope, exact release, supported interfaces, and evaluation questions need a fuller independent specification.

The retained measurements require correction regardless of placement. Finding **TIMING-CONTRACT** identifies incompatible descriptions of timing boundaries and sample counts, plus a reference to a timing no longer displayed in the table. Finding **SNAPSHOT-IDENTITY** identifies the missing immutable artifact version. Readers need to know exactly what was timed, what preprocessing was charged, which release produced it, and where the raw evidence for that release resides.

The tower comparison is potentially illustrative, but the statement that it isolates the theorem's reduction should be qualified while the labelled-table control has not been rerun under the same protocol. The current evidence may compare complete approaches; that is not the same as separating the effects of mathematical reduction, implementation, and solver choice. This is a request for an accurately framed experimental claim, not a claim that the reported speedups are false.

### 5. Improve accessibility at changes of mathematical language

The exposition is strongest where it explains a proof mechanism directly: the zero/nonzero-label split, the removal of external coefficients for minimal supports, and independent block lifts. It becomes harder to follow when target-coordinate vectors, recovered subspaces, extension-field elements, and dual functionals appear in rapid succession.

I recommend one compact notation panel, placed at the first full concatenation definition, that records the domains and roles of the target space T, the normalization alpha, the helper map beta, the induced map into L-star, and its trace coefficient. Explain explicitly that recovered dimension counts independent target combinations, not erased positions. Keep the helper-cost versus total-word-weight convention attached to the one-coordinate specialization.

The shift from lambda/mu to capital Lambda in tower composition is explained, but still imposes a reading cost. Either retain a common notation with level subscripts or provide a small correspondence immediately before the formulas. The related F4 example needs a consistent trace convention; finding **F4-TRACE-LABELS** gives the exact issue and confirms that the intended numerical separation survives.

The projective-simplex application is an effective final worked family because its weights and reliability follow from transparent counts. Make its change of reliability question explicit: it asks whether *some* t-dimensional recovery space remains, whereas earlier operational statements may concern a prescribed T. The theorem itself is correctly stated; a transition sentence would prevent an adjacent-field reader from treating these as identical events.

## Specific editorial and minor comments

1. **Abstract:** reduce its catalogue of secondary outputs. The exact escape law, minimal-support distinction, and compositional mechanism can carry the abstract. The general lifting extension, price equivalence, boundary width, bilinear example, numerical quotient, and software need not all receive separate abstract sentences.

2. **Opening figure and table:** both are legible and useful individually, but together with the surrounding introduction they repeat the same map. Keep one as the primary overview and shorten or relocate the other. The large early floats delay the precise theorem.

3. **Forward definition:** `sections/02-confinement-transfer.tex:215` uses rho_T before its definition in the following section. Define it there in a short clause or defer the reference.

4. **Pointed proof:** correct **MINIMAL-SUPPORT-IFF**. The threshold is equivalent to equation/exact-support confinement; it is sufficient, not necessary, for equality of inclusion-minimal supports. The theorem statement already makes the appropriate one-way assertion.

5. **Reliability separation:** the geometric realization is the most compressed existence argument in the paper. A short explicit parameter choice, or a more explicit explanation of why unwanted incidences are not forced before the lift, would make it easier to audit. Keep the radius-three qualifier visible when describing the five triples: larger minimal supports are expressly present.

6. **Simplex characterization:** at `sections/06-geometric-flagships.tex:196–199`, specify the comparison class and fixed dimension for the final characterization claim. Explain the averaging step from the extremal first weight to equidistance before invoking the cited classification. Length and one recovery minimum alone are insufficient hypotheses for a general nested pair.

7. **Formal evidence:** the limited Lean scope is stated honestly. Retain that precision, supply the companion's version/location, and consider moving the long declaration table to the artifact appendix. Formalizing the exact sequence should not distract from the fact that the main results rely on the human proofs.

8. **Measured table:** the six-application table on PDF page 32 is much smaller than the surrounding text. Moving exact instance descriptions to adjacent prose, or splitting the table, would improve readability. Avoid requiring the reader to decode several application acronyms and a timing protocol inside a small caption.

9. **Local prose and cross-references:** change “is an separately developed compiler” in the introduction to “is a separately developed compiler.” The end of the confinement section says that the next section shows the separation, although a related-work subsection intervenes. Review transitions after reorganization rather than retaining navigation inherited from the present order.

10. **Conclusion:** the first three paragraphs synthesize the mathematical contribution well. The bandwidth and witness-catalog directions are intelligible but add several new concepts at the end. Select the most immediate open question and state its missing theorem or algorithmic guarantee concretely; the remainder can be a shorter outlook. The programme perspective is optional and should not replace a final mathematical impression.

## Conditions for a satisfactory revision

A satisfactory revision should let a reader identify the exact problem, the two principal transfer statements, and the retained state without consulting later sections or external software documentation. It should correct the specific interface and local convention defects, reconcile the empirical protocols, and identify fixed artifacts. It should preserve the complete human proofs while reducing repeated orientation and separating mathematical results from the broader software inventory.

I do not regard a broader Lean formalization, more benchmarks, or additional application families as necessary responses to this report. The immediate work is to make the existing contribution precise, proportionate, and independently assessable.

## Review limits

This assessment is based on a complete read of the main TeX, every included section and figure source, annotation definitions, and all bibliography entries. I visually inspected PDF pages 1–4, 27, 32–33, and 40; this is not an exhaustive typography audit. The exact per-file coverage is recorded in the original cold report.

I did not consult prior reviews or revision reports, and I have not evaluated the ongoing repair. I did not retrieve the cited original literature, inspect external implementation or evidence bundles, run Lean/Lake, or run benchmarks. Thus this report assesses the human arguments, internal claim boundaries, and exposition; it does not certify novelty, bibliographic accuracy, implementation correctness, formal audit results, or empirical reproducibility. The report makes no numerical grade, prestige judgment, or percentile assessment.
