# Native BP spike

This private C985 experiment tests a reusable native sparse GF(2) normalized
min-sum kernel and an allocation-free-after-setup OSD-0 handoff.  It consumes
the retained BB756 target stream from `c985_bp_order`; no BB756 facts are baked
into either algorithm.

The BP state retains both the hard decision and posterior LLR vector.  The OSD
workspace is pre-sized and uses signed posterior ordering, matching `ldpc`'s
OSD-0 convention.  Every OSD result is independently checked against the full
stacked physical/logical syndrome.

Build with an isolated target directory, then compare the Rust binary with
`bench_ldpc.py` under `ldpc==2.4.1` and `numpy==2.5.1`.  The first admission
gate is exact syndrome validity.  Similar long-loop BP quality and higher-order
OSD are still required before this can replace `ldpc`.

The corrected five-pair BB756 sample measured 0.8018 s mean for native versus
2.0178 s for `ldpc` 2.4.1 (2.516x, paired t=192.64).  Both returned 128/128
valid affine solutions, and their complete candidate streams match: best
weight 88, weight sum 17,536, and FNV-1a checksum
17,365,681,124,003,376,817.  The durable raw sample and counter snapshot are
in `../../evidence/c985-native-bp-spike.json`.

The key fidelity constraint is floating-point association.  The variable
update must use the reference prefix/suffix accumulators; replacing it with
the algebraically equivalent `posterior - incoming` expression changes later
loopy-BP trajectories.  `osd0-provided` remains as a diagnostic mode that can
consume a retained external order and isolate BP from elimination.

Bounded higher-order modes are `osdcs10` (combination sweep) and `osde10`
(exhaustive over the first ten non-pivot columns).  On the 128-target sample,
both reproduce the complete `ldpc` candidate stream.  CS-10 is 3.235x faster
(`t=18.80`); exhaustive-10 is 3.710x faster (`t=8.64`).  On all 2,048 retained
targets, exhaustive-10 recovers best weight 56 and the same candidate checksum
in 26.00 s versus 68.48 s, a 2.633x full-run speedup.  The test binary's
thread-local allocator gate observes zero allocation, reallocation, or
deallocation in the actual BP and higher-order OSD regions.

The same unmodified kernel also reproduces complete reference streams on
BB288 and the C997 Gross [[144,12,12]] code.  Five-pair OSD-0 means improve
`ldpc` by 1.450x (`t=5.64`) and 1.308x (`t=6.22`), respectively.  C997 first
failed the no-small-regression gate; replacing branchy first/second-minimum
selection by an equivalent min/max network preserved every binary64 posterior
while turning the regression into a measured win.  `generate_targets.py`
creates deterministic neutral target streams for additional matrices.

## Typed Rust API

The crate now separates one immutable `BinaryParityCheck` from any number of
worker-owned `NativeBpOsd` workspaces.  Configuration and OSD bounds are
validated once at workspace construction.  The hot method accepts
`&[BinaryValue]`, a `repr(u8)` type that makes non-binary syndromes
unrepresentable without rescanning values:

```rust
use c985_native_bp::{
    BinaryParityCheck, BinaryValue, DecodeConfig, NativeBpOsd,
    OrderedStatistics,
};

let code = BinaryParityCheck::from_rows(3, [vec![0, 1], vec![1, 2]])?;
let mut workspace = NativeBpOsd::new(
    &code,
    DecodeConfig::default(),
    OrderedStatistics::CombinationSweep { order: 10 },
)?;
let answer = workspace.decode(&code, &[BinaryValue::One, BinaryValue::Zero])?;
assert!(answer.syndrome_satisfied);
```

`decode_bytes` is a checked convenience boundary for ordinary byte slices;
the typed `decode` call is the zero-rescan hot interface.  The replay binary is
a one-function adapter over the library.  On x86-64, ordered finite-message
min/max uses explicit mandatory-SSE2 scalar instructions so moving the kernel
behind the library boundary cannot reintroduce the compiler's branchy lowering.
