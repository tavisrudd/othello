# BP reliability-order probe

This retained C985 side experiment tests whether posterior BP ordering alone
improves Ergodis' order-two information-set search on the BB756 instance.
It is deliberately outside the public crate: the measured adapter was rejected.

`preordered-target.patch` applies to commit `4a846af33` and exposes the exact
targeted trial used by the standalone probe. Apply it from the repository root,
generate the BB756 input with the command recorded in C985, then run:

```sh
git apply ergodis-private/experiments/c985_bp_order/preordered-target.patch
cd ergodis-private/experiments/c985_bp_order
uv run --with ldpc --with numpy python3 generate_orders.py \
  --input <hx-gz.json> --helper ../../../notes/2026-08-31-c1018-756-helper.py \
  --prefix <workspace>/orders --trials 2048 --seed 1018003
CARGO_TARGET_DIR=<workspace>/target cargo build --release \
  --manifest-path probe/Cargo.toml
<workspace>/target/release/c985-bp-order-probe \
  <hx-gz.json> <workspace>/orders-llr-desc.bin
```

The binary order files are disposable generated data. The compact retained
result and hashes are in `../../evidence/c985-bp-reliability-order-probe.json`.
