# C1130 overnight Evolve and WASM demo work

**Lane:** `ergodis` · **Date:** 2026-09-09 · **Private, not to ship.**

The user authorized three hours of continued work, with independent red-team
reviews at least every twenty minutes, real benchmark inputs, and no supplied
answers or fixture-specific discovery hints. The timed work window is
08:19:37–11:19:37 UTC. C1130 itself remains open after this chunk.

## Current implementation

- Shared private source-only incidence symmetry proposals run natively and via
  WASM in a separate worker. Both source row spaces and the combined orbit
  transversal are independently checked before root reduction.
- The CSS provider uses the existing optimized core partition kernel through
  an owned cooperative wrapper. Native optimized entry points and hot records
  are unchanged. Large/extra-wide/huge/colossal dimension dispatch is present.
- Loaded QDistSAT matrices support either Pauli direction or a generic direct
  sum of both directions. Primary inputs, source hashes, licenses and published
  table links are retained; published times are context, not matched speedup
  ratios. No matrix name, known distance or published result reaches discovery.
- Capacity, CSS, full Hadamard and repair have learned-only reruns. Retained
  proofs are rechecked; discovery is off; workspaces are fresh. CSS can retain
  immutable loaded providers/plans on both arms and reports that setup reuse.
- Below-fold compilation views show the actual representation and proof
  obligations. The certificate panel has a local Verify button and timer.
  CSS negative search is not independently certified except where the separate
  graph-cover verifier applies. A checked symmetry is not itself proof of a
  minimum distance.

## Accepted code and evidence

Core `e0f77ef`; private `18fa651`, `db73684`, `8094302`, `953ac91`, `52f9a48`,
`55668ac`, `6408bf4`, `6a51324`, `9754808`. Private reports/scripts retain exact tests, artifact hashes and native
counter evidence:

- `analysis/module-loading/overnight-demo-review.md`
- `analysis/module-loading/race-performance.md`
- `analysis/module-loading/hadamard-preview.md`
- `analysis/module-loading/css-provider-oracle-evidence.json`
- `analysis/module-loading/resource-native-performance-evidence.json`
- `analysis/module-loading/williamson-performance-evidence.json`
- `docs/adr/0002-checked-rule-compilation-and-warm-start.md`

Core fmt, all-target/all-feature Clippy, all-feature tests and independent ABI
oracles pass. CSS has eight provider contract tests, 1,200 small-source solve
oracles across branch batches1/4/64 and 25,197 independent proposal/support checks. Resource and Hadamard
acceptance includes retained native single/four-process counters, exact work or
oracle comparisons, and allocation/ownership checks. Native hot-path changes
were not accepted from browser timings alone.

The canonical core WASM remains SHA-256
`b9df85fa7a2f4d9abff378adce198e871858cb217d72cf3fe81267a5aa441903`.
No public export or push was performed.

## Red-team and open limits

Ten independent review rounds have been requested so far. Fixed findings
include cross-mode run-ID collisions, retaining stopped partial traces, binding
shown quotient counts to replayed receipts, and optional discovery/admission
budgets aborting otherwise valid solves. No reported answer-soundness issue was
left knowingly accepted. All ten rounds and the final late-knowledge followup completed; concrete
findings and fixes are in the private review report.

A 360-qubit, both-direction radius-20 run completed with Evolve in 48.71 seconds;
control was unfinished at 90.05 seconds. Four checked generators reduced 720
anchors to one. This is a bounded search with no witness through radius20,
not a new independently certified distance or a hardware-matched comparison
against published solvers. Small cold runs can lose to preparation/discovery
costs; those negative results are retained rather than hidden.

The harder TN source solved correctly but exposed unbounded branch-sample
retention (50 MB trace), fixed with50ms ordinary sampling, bounded retained history and preservation of
every reduction/final event. The real TN108 both-direction source now passes
cold/warm/certificate/import gates; distance12,216→72 roots. Adaptive coarse
ABI batching amortizes transport without changing native default calls or kernels. Other open work: incidence grammar misses row-space-only
symmetries, root quotienting does not eliminate inner-root search complexity,
general multiplicity lowering remains unimplemented, and a portable persistent
learned-artifact format is not yet standardized. Full WASM feature completeness
and CampaignSession integration remain separate acceptance gates.

## Final closeout and next move

The LP source-only probe confirms the general proposer can find340→34 roots.
A cold browser race applied no rule but retained one proposal received after
the evolved arm finished. The learned-only rerun rechecked it before solving
and used34 roots. Such knowledge has an explicit future-execution role and no
retroactive epoch or pruning credit. Independent source-row-space replay and
cold/warm certificate checks pass.

The private ADR and terminology pass now distinguish late knowledge, active
admission, root quotienting, finite bound compilation, query reuse, progress
sampling and certificate scope. Shipping documentation remains unchanged.

Next EV: let campaign knowledge contexts outlive individual query executions,
with portable source-bound proof artifacts, then pursue stabilizer-aware inner
search and general multiplicity lowering behind the same independent admission
boundary. Full WASM coverage and main CampaignSession integration are still open.

The cache-GC dry run completed without deleting foreign/unreferenced artifacts.
The demo servers remain on0.0.0.0 ports8769/8770. No public export or push occurred.
