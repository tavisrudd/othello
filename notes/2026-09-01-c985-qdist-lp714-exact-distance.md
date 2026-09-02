# C985 QDistSAT LP714 exact-distance certificate

**Lane:** `complete-ports`

**Date:** 2026-09-01

## Result

Ergodis certifies both CSS directions of the official QDistSAT
`LP_714_100_?` matrices at exact distance 16. The supplied matrices therefore
define a `[[714,100,16]]` code.

| direction | result | candidates | preparation (s) | search (s) |
|---|---:|---:|---:|---:|
| X (`Hz/Gx`) | 16 | 230,314,871 | 0.710041 | 1.767141 |
| Z (`Hx/Gz`) | 16 | 134,141,286 | 0.732233 | 0.977534 |

These are one-round certificate timings, not a multiround performance
estimate. The official QDistSAT table reports that none of its 46
SAT/MaxSAT/SMT/MIP/algebra configurations completed the distance scan under
its 7,200-second limit; the retained partial bounds range up to 9 and the
known upper bound is 16. On that published stop condition, the combined
Ergodis cold time gives a conservative cross-machine lower bound of about
`7200 / 4.187 = 1,719x`. The exact result is deterministic and does not depend
on this timing comparison.

The retained witnesses are:

- X: `[0,5,9,14,16,25,26,28,37,42,45,67,70,72,77,87]`;
- Z: `[0,4,15,20,118,123,324,328,330,333,334,420,424,429,439,440]`.

An independent checker confirms for each witness that its coordinates are
distinct and in range, its physical syndrome is zero, its logical observation
is nonzero, and its weight is 16.

## Source and theorem boundary

The source is QDistSAT commit
`9fb224b0fa372161fb3933034016bc8dc423a5ab`, licensed
GPL-3.0-or-later. Its matrices are not redistributed here.

| source matrix | SHA-256 |
|---|---|
| `LP_714_100_?_Hx.txt` | `1f8a5719b25374bcb9b9d2016c226b50590835fc18f8b4ed99cf4507b26e35b8` |
| `LP_714_100_?_Hz.txt` | `3cc95acd01d9032ca645d43a0d6932aa0dcea295f0be43953b104fd609f3f501` |
| `LP_714_100_?_Gx.txt` | `480c34d2f4c563ac7809f00870564c2fe73caf5ba1cfc802568efe923fd1bd16` |
| `LP_714_100_?_Gz.txt` | `f33a3df176159d3f8831fc1a4fd75550b6a3e05045c3232fcd99543d7a71d91f` |

Private importer commits `4389cf24b` and `190909141` parse and hash all four
matrices, verify `Hx Hz^T = 0`, compute ranks 307 and 307, derive encoded
dimension 100, and check that each 100-row logical family has full rank and is
independent modulo its physical row space. The importer deliberately retains
all 315 sparse physical rows: emitting an arbitrary 307-row algebraic basis is
semantically equivalent but destroys the Tanner presentation and was more
than 60 seconds slower on the BB288 control.

The same importer discovers a length-21 cyclic action on each of 34 coordinate
blocks. It proves that the action preserves both the physical row space and
the physical-plus-logical observable row space, then emits the permutation
itself. The public solver independently re-verifies that permutation and the
34-anchor orbit transversal on every run; every orbit has exactly 21 points.
Thus the lower-bound search does not trust an asserted quasi-cyclic label.

Deterministic imported-input hashes are:

- X: `c412aceb7f55168e66c54bd424b3d8cb4ea1e7d68490bf44c0ad411249df3f83`;
- Z: `7fdef8d4a3b8a3ed4780e2af4a7085dfd3a406766f12cab4ba346e9358d0dd3f`.

The retained v6 evidence is
`ergodis-private/evidence/c985-qdist-lp714-x-w16.jsonl` and
`ergodis-private/evidence/c985-qdist-lp714-z-w16.jsonl`; their SHA-256 hashes
are, respectively,
`6f7823d6af4c32b53d0b3d1ded7f072cf79d5869f18f5702d34f825e66020322`
and
`ee3972f48373c84b9ce06f68c4d27b0155acbf7c4bda7072a392bbc856291539`.
The load-bearing source tree used for the retained run is commit `6e99f2ef0`;
the last CSS-kernel change in that tree is the mutation-control commit
`61ef12f9b`. Current v6 evidence verification, including fail-closed
global-scope and anchor-mode checks, is also `6e99f2ef0`.

## Replay

Use a disk-backed work directory; this host's ordinary `/tmp` is tmpfs.

```bash
QDIST_ROOT=/path/to/QDistSAT
WORK_ROOT=/path/to/disk-backed/ergodis-lp714
REV=9fb224b0fa372161fb3933034016bc8dc423a5ab

git -C "$QDIST_ROOT" checkout "$REV"
cargo +1.87.0 build --manifest-path ergodis-private/Cargo.toml \
  --bin qdist_to_ergodis
cargo +1.87.0 build --release \
  --manifest-path papers/complete-repair-ports/ergodis/Cargo.toml \
  --features large-css,parallel --bin css_distance_native

for direction in x z; do
  ergodis-private/target/debug/qdist_to_ergodis \
    --stem "$QDIST_ROOT/data/LP2/LP_714_100_?" \
    --direction "$direction" --maximum-weight 16 \
    --upstream-revision "$REV" --discover-symmetry \
    --out "$WORK_ROOT/lp714-$direction.json"
  papers/complete-repair-ports/ergodis/target/release/css_distance_native \
    --input "$WORK_ROOT/lp714-$direction.json" \
    --maximum-weight 16 --threads 12 \
    --evidence "$WORK_ROOT/lp714-$direction-w16.jsonl"
  python3 papers/complete-repair-ports/ergodis/python/check_bb_native.py \
    --input "$WORK_ROOT/lp714-$direction.json" \
    --evidence "$WORK_ROOT/lp714-$direction-w16.jsonl" \
    --minimum-rounds 1
done
```

All outputs use exclusive creation. The run used Rust 1.87.0 and the
`x86-64-avx2-bmi-popcnt` kernel on an AMD Ryzen AI 9 HX 370 with 12 workers,
no explicit affinity, and low-priority OOM protection through `choom`.

## Scope

This certifies the exact distance of these four supplied matrices. It does not
claim decoder performance, optimality among lifted-product constructions, or
a statistically controlled cross-machine speed ratio. The exhaustion trusts
the public connected-support theorem implementation; the independent checker
replays the positive witnesses but is not a second implementation of the
364-million-candidate lower-bound search.
