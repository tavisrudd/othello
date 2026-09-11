# C1143 — BB circuit-distance input gate

**PRIVATE — not to ship. Lane:** `ergodis`. Status: in progress.

Programme and ordering: `2026-09-11-ergodis-external-benchmark-programme.md`.
Initial gate committed in private Ergodis at `6a4dc10`:
`analysis/external-benchmarks/README.md`, pinned corpus manifest, independent
filter/census replay and four tests including 200 exhaustive small random oracles.
All seven source hashes, census replays and comparisons with the pinned upstream
filter passed. No native solve or performance comparison is claimed.

The external runner filters faults to one detector basis. This is preserved as
an explicitly restricted variant alongside each full model; distance equivalence
is not assumed. Smallest full/filtered fault-coordinate counts: 17,244 / 2,592.
Largest: 1,112,454 / 154,224. Current native/WASM provider allows 1,792 coordinates,
so even the smallest filtered model is not admitted. Fault coordinates are not
physical qubits. Most faults are genuine hyperedges. Every variant has no logical
fault of weight one or two under the intact unit-cost DEM objective; that bounded
check is not a full circuit-distance proof.

Next: inspect existing sparse execution facilities and implement a bounded exact
fault-column path without inflating or slowing the existing optimized kernels.
First case is development; remaining six are frozen performance holdouts. Preserve
original labels for witness replay, and compare unrestricted and published-model
objectives separately. Performance rules and the shared playbook were loaded.

The ej/tt closeout clarified semantic restriction versus checked reduction and
fault-coordinate versus qubit geometry. Open mysteries: filter equivalence,
useful deep residual bounds, temporal-boundary symmetries, and lower-bound proof
cost. Detailed ledger and exact replay commands are in the private README.
