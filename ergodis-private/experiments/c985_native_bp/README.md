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

The first five-round BB756 sample measured 1.0040 s mean for native versus
2.8859 s for `ldpc` 2.4.1 (2.874x, Welch t=497.26).  Both returned 128/128 valid
affine solutions.  Native best weight was 102 versus 88, so the speed gate
passes but the replacement-quality gate fails.  The durable raw sample and
counter snapshot are in `../../evidence/c985-native-bp-spike.json`.
