# C1130 parameterization discovery checkpoint

**Lane**: `ergodis`. Private, not-to-ship. Umbrella C1130 remains in progress.

## Current capability

The private shared native/WASM provider supports exact polynomial substitutions,
signed sharing/orbits, sparse monomial images and generic tensor-axis hypotheses.
The original source and array shape are supplied; factor entries are searched.
No named Hadamard construction or solution is supplied to these new proposers.
Checked embeddings authorize witness lifts only, not complete search coverage.
The existing large Hadamard runs retain their supplied-family labels, including
Goethals–Seidel at order 140. No discovery of that construction is claimed.

Live 8770 includes four discovery examples: 4×4 signs, coupled polynomials,
8×8 arrays and 16×16 arrays. At 8×8, 64 source signs reduce to 12 factor parameters;
at 16×16, 256 signs reduce to 16. Native/WASM selected maps and witnesses match,
and independent Python substitution/original-equation replay passes. Browser proof
buttons replay embeddings, modular rejections and original witnesses; cancellation,
cache/offline restart of unrelated Hadamard runs and visual inspection pass.

General modular arithmetic rejects impossible residual families before enumeration.
On the earlier 8×8 bipartition portfolio, assignments fell 7,013,207 → 3,277,655 → 66,391.
Retained native residual-portfolio medians were 42.08 → 16.92 ms, then a separately
matched 16.65 → 2.56 ms. These are within-portfolio comparisons, not speedups over
unrestricted original search. Arithmetic laws are supplied generic checker knowledge;
Evolve derives source-specific obligations rather than discovering those laws.

A separate packed pair-join fingerprint optimization is live for the supplied
order 140 model. The completed 8-thread Chrome run was 68.49 s, including 14.71 s join
compilation, with a verified full matrix. This is not parameterization discovery.

## Evidence and design authorities

All paths below are in `ergodis-private/analysis/interface-review/`:

- `parameterization-synthesis-plan.md` and `adr-parameterization-synthesis.md`:
  current staged plan and proof/coverage decisions.
- `parameterization-provider.md`: current wire forms, resource limits and lifecycle.
- `2026-09-11-array-partitions.md/json`: source-to-witness provenance and exact replay.
- `2026-09-11-tensor-parity.md` and `2026-09-11-tensor-mod4.md`: retained A/B counters,
  independent contradiction replay and generality reviews.
- `2026-09-11-array-holdout.md`: frozen bipartition transfer results with misses.
- `2026-09-11-partition-holdout.md`: independently chosen frozen multi-factor
  contingency test, 68 cases, 13 feasible, 1 found, no false lift or family rejection.
- `2026-09-11-full-fingerprint-wasm.json`: completed supplied-model order 140 evidence.

These are small research prototypes, not a full CEGAR implementation. Sparse source
IDs remove the earlier 63-bit representation restriction, but resource/work budgets
remain explicit. No public-core implementation changed in this slice.

## Frontier / ej + tt mystery ledger

Settled: many failed representation hypotheses can be rejected by generic arithmetic
before assignment search. A generic factor-count cost tie-break exposed a 16×16
family within the fixed 128-map budget; the failed earlier ordering is recorded.

Open: adaptive grammar expansion, affine elimination from consistent obligations,
block/permutation hypotheses beyond pure tensors, repeated normalization/round-trip
cost and broad held-out transfer. The 1/13 contingency result is a clear limit on
current grammar coverage. Order140 is still an open structure-discovery application.
Do not retroactively tune the frozen holdouts or label development examples held out.

The subsequent native-only C1016 phase and timed-block audit are recorded in
`2026-09-11-ergodis-timed-work-audit.md`. This checkpoint does not complete C1130;
the grammar, transfer and order-140 gaps above remain active.
