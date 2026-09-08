# Complete-ports: operational recovery revision

**Lane:** `complete-ports`
**Scope:** user-requested manuscript update from the supplied ChatGPT feedback,
including the current separate Ergodis system and the programme connection.
No Ergodis implementation, Lean declaration, benchmark run, push, or deposit.

## Mathematical disposition

The authority is `papers/complete-repair-ports/`.

- Added `thm:minimal-support-confinement`: target-touching outer dual distance
  greater than r+1 forces minimal bounded supports to be local. Only the target
  block functional must vanish. The proof works even for a locally
  unrecoverable prescribed target, when both bounded families are empty.
- Strengthened `cor:service-rate-transfer` and `cor:positive-density`:
  support-based fractional and integral regions transfer without the inner
  additive ceiling; arbitrary availability laws transfer with the same local
  marginal. Equation-level theorems and their exact thresholds remain distinct.
- Defined essential nonconfinement by failure of local recoverability on the
  target-block portion, with its equivalent minimal-external-support definition.
  The full outer code separates infinite essential confinement from finite
  coefficient nonconfinement.
- Added `thm:quotient-lifting-composition`, preserving both numerator and kernel
  through inverse images of an outer nested pair. Human proof, no computational
  dependency. Included heterogeneous finite-linear interfaces, explicit
  surjective target projection, and the available quotient-direction profile.
- Added labelled support-antichain composition and additive Pareto semantics.
  Pruning is within labels and the declared observation; unit-cost minimizers
  cannot be reused for arbitrary repricing.
- Added `prop:pricing-availability-equivalence`: all nonnegative prices, the
  minimal family, availability indicators, and independent heterogeneous
  reliability determine each other. No efficiency or witness-counting claim.
- Added fixed-query `prop:boundary-width-compilation` on a supplied binary tree:
  affine boundary state count q^(t w), O(n q^(2tw)) pair combinations, local
  compilation charged separately, explicit support-budget factor and witness
  lifting. Normalization width and frontier costs are additional charges.
- Added fractional column-generation dual certification and graph-potential
  optimality checking, each with the completeness obligation explicit.
- Added the worked bilinear three-worker reduction and separating functional
  impossibility certificate. Compression must preserve worker/task relations.
- Corrected the support-overlap example to the complete radius-three clutter.
  The four-set {0,1,2,4} is an additional minimal support in configuration A.
- Scoped one-shot bandwidth and transmission-subspace alignment in the conclusion.
  A new quantum example, arbitrary stabilizer formalism, code-design search,
  GRS fast paths, design cuts, and a full probability compiler are not added.
  They would displace the recovery proof spine and require separate evidence.

## Ergodis source review

Reviewed current local core at `67d929b0bf8f0be371911dd8d9cc52b193cd3d28`.
Entry sources: README, OPTIMIZATION, DESIGN, glossary, observable-admission,
verification, summary-transitions, run-repository, and headers/contracts in
observational, scheduler_bound, semantic_symmetry, css_distance and contextual.
The complete-ports manuscript now links `https://github.com/tavisrudd/ergodis`
and describes the September development system rather than a bundled engine.
It distinguishes development capabilities from smaller release snapshots.
The public branch inspected locally was `9ed76b3`; no publication is implied.

The overview includes finite observational minimization, additional-readout
admission, Pareto/Lagrangian scheduling, structural/CSS search, portable campaigns
and saved runs, and independent verification with bounded contracts. The
min-plus checker authenticates supplied summaries, not source lowering or
arbitrary domain optimality. Native/browser hosting and candidate generation
are not mathematical proof authorities. Old speedups remain historical
recovery-snapshot measurements and are not extended to current engines.
No benchmark or engine test was rerun for this manuscript revision.

## Representative-catalog follow-up

The later user feedback is a coherent separate contribution, not another
instance of pairwise contextual equivalence. The conclusion records its
lower-envelope observation contract and its classical representative-family
starting point. The full sparse-dual/probability development is retained here
as follow-up scope, not claimed as a new main theorem or novel implementation.

The central quantifiers are `for every context, for every full witness, there
exists a retained no-worse witness`; the replacement can vary by context.
For an f-complete catalog with core U, the replacement proof uses
J=(D intersect U) minus H_x. Under |D intersect U|<=f it produces a retained
support whose affected portion is contained in H_x's, with no larger baseline
cost. Thus every monotone adverse penalty is preserved. Applied to dual prices
this establishes omitted dual constraints when their positive support in each
core is small enough. Subtracting a source-certified conserved grading is valid
only when the residual prices are nonnegative. An integral primal attaining a
full LP dual bound certifies an integer optimum; arbitrary fractional optima
do not. The shared-failure coupling gives the core-tail distribution bound.

A sequel should gate: label/degree-aware construction; source-family coverage;
independent optimality for implicit-oracle construction; actual coefficient
lifts; adverse versus favourable edits; binary versus variable resource loads;
and novelty against representative-family, product, and sensitivity literature.
No task ID is allocated by recording this direction.

## Supplied prototype replay

Preserved the four input files byte-for-byte under
`notes/2026-09-07-complete-ports-feedback-prototype/`, with archive/source/output
SHA-256 hashes and byte counts in `provenance.json`.
From that directory: `python3 test_adversity_cores.py`.
Python version is recorded in the provenance; no third-party dependencies.
Seed 20260905; exact finite domains and stop conditions are in the test script.

The replay passed 6,964 core-local failure comparisons, 3,600 sampled nonlinear
monotone penalty comparisons, 120 independently recomputed exterior-feature
certificate checks, 3,248 XOR-label/exact-degree composition comparisons, and
160 two-demand capacitated packing comparisons. It reproduced the 298 sparse-dual
example, the 7/250 probability error, and five rejected certificate mutations.
The resulting JSON is byte-identical to the supplied output.

This was a fresh execution of the supplied suite, not a separately authored
external audit. The suite checks against direct enumeration; the producer uses
minors and the checker uses iterative wedge products, with shared input helpers.
`Witness` contains only support and integer cost. XOR-labelled test grouping is
not a general coefficient-witness compiler. The oracle wrapper trusts oracle
optimality and does not construct an optimality/branch-coverage proof object.
No general probability backend, sparse-dual solver, production integration,
performance result, or Lean formalization follows from this replay.
The prototype is private reference material and is not part of the paper export.

## Programme and literature boundary

The programme overview was consulted as user-supplied context. The author
rejected citing it in the manuscript; that citation and repository link were
removed. The unnumbered coda now states the reconstruction connection directly
from this paper’s results, distinguishing objects, behaviours, and optimal
decisions. No other programme manuscript was changed or re-audited.
The representative-family citation is Fomin--Lokshtanov--Panolan--Saurabh,
JACM 63(4), 2016, DOI 10.1145/2886094, used only as the established starting
point in the conclusion. Primary search records also identify arXiv:1304.4626
and the product-family paper arXiv:1402.3909. No novelty verdict is claimed.

## Validation and closeout

The 43-page deterministic PDF build passes with no TeX warnings. Source-only
formal checks pass 32 claims and four reviewer terminals. All four added
statements are absent from Lean; only the associated-pair exact sequence is
formalized. The validation metadata was updated to the actual claim and page
counts. The incoming handoff's 40-page/31-claim description was stale against
this checkout's 37-page/28-claim baseline.

Rendered review covered the abstract, quotient theorem, minimal-support proof,
Ergodis overview/figure, price equivalence, boundary-width proof, and coda.
The first build correctly rejected the stale page-count pin; it was updated
without relaxing warning, reference, PDF-identity, or formal-coverage checks.
A read command initially combined oversized sources and truncated output;
subsequent reads used explicit section ranges. This command-shaping failure
had no source or mathematical effect.

### Mystery ledger — explicit ej + tt pass

- Settled: the inner additive ceiling is a coefficient artifact for these
  operational queries; the full outer code and target-block deletion proof
  explain it. No mystery remains about the stronger support transfer.
- Settled: target rank multiplies boundary dimension, not ambient dimension,
  for a fixed feasible affine interface. Local and frontier construction are
  separate costs; no unexplained speedup claim remains.
- Open, sequel: when can the price/availability contract be compiled compactly
  without enumerating the raw carrier? The paper proves semantic equivalence
  and a conditional local-table bound, not an unconditional construction theorem.
- Open, sequel: source-certified representative catalogs and sparse-dual
  completeness. The supplied prototype proves neither general source lowering
  nor novelty; the exact gates are listed above.
- Open, C953: independent aggregate theorem/literature/referee review. This
  revision does not claim to close that publication gate or the appendix C325.

The cheap closeout upgrades were the locally-unrecoverable-target scope,
essential-threshold equivalence, integral feasible-region transfer, empty-family
price convention, explicit arithmetic/budget charges, and prototype trust
boundary. These arose directly from the requested review, so none is an
incidental discovery-track entry.
