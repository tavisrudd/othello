# C1159 — one-sided completion screen

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: COMPLETE as an opt-in private kernel. Final source `be611e9`,
accepted evidence/private closeout `8b79a73`.

The compiled completion index now has an optional immutable bitset screen.
Unset bits prove no indexed key matches; set bits still require the existing
full-key and exact-support checks. No foreign library, new default kernel or
new WASM provider operation was introduced. Counting and throughput
instantiations are separate, with native/32-bit field offsets preserved.

## Gate

On the frozen reduced C1143 development source (252 detectors, 2,232 faults),
radius five, the screen removes 1,294,210 of 1,394,089 completion lookups (92.8%),
leaving 99,879. Both arms retain 4,761,457 candidates, all 2,232 completed roots,
the same verdict and witnesses, for both one and three workers.

Eleven interleaved pairs per worker configuration give median paired search
ratios 0.8885 / 0.8917: about 11% less search time. Whole-process cycle ratios
are 0.8885 / 0.8882, with 82–83% event multiplexing. Exact screen storage is
8 KiB; preparation remains about 0.23 ms. The final eleven-pair old-binary null
control has no regression (search ratios 0.9942 / 0.9960; instruction ratios
0.9999 / 0.9995). An initial layout-induced perturbation was detected, corrected
and retained as rejected evidence; no latest claim relies on that older build.

Seven sparse integration tests and two focused unit tests pass, including
240 generated oracle models, radii 1–4, budget boundaries, collisions,
zero allocation, existing continuation/shard checks and mutable-buffer
cache-line separation. Strict library/test Clippy, CLI compilation and the
WASM fault-provider target check pass. WASM compilation is not a timing claim.

Independent Python reconstruction binds the filter bytes to the Rust hash,
checks every indexed key and all 2,489,796 unordered residual pairs, with zero
false rejections. Corrupt-digest and duplicate-parity controls pass. The frozen
input, receipts and verifier are committed; 16 task/source/binary hashes verify.

Full report, source hashes, retained binary names and exact replay commands:
`ergodis-private/analysis/external-benchmarks/2026-09-12-completion-screen.md`.
No broader workload or default-adoption claim is made.

## Post-gate ej + tt / Mystery ledger

- Settled operationally: preserving old field offsets and compiling out reset
  writes restored the baseline. The exact compiler-level cause was not isolated;
  any causal/layout claim requires a one-factor A/B and disassembly.
- Settled: collision freedom is unnecessary. Immutable construction plus full
  support checking preserves one-sidedness; forced-collision tests exercise it.
- Open: globally optimal bitset sizing and broader/default adoption require a
  workload gate. Only this frozen development model is measured.
- Open: a future mutable index must keep the screen synchronized. Current plans
  are immutable, so public APIs cannot produce a stale screen.

These are targeted findings; no incidental discovery entry was warranted.
The remaining continuation moves to already allocated C1155. Deadline remains
2026-09-13 07:24:50 UTC; C1170 retains its explicit pending gates.
