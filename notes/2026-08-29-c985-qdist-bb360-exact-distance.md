# C985 QDistSAT BB360 exact-distance certificate

**Lane**: `complete-ports`

**Date**: 2026-08-29

## Result

Ergodis certifies both CSS directions of the official QDistSAT
`BB_360_12_?` instance at exact distance 24.  Thus the supplied matrices define
a `[[360,12,24]]` code.  The result closes the published `d <= 20` scan and the
previous weight-24 upper bound:

| direction | searched radius | result | candidates | search time |
|---|---:|---:|---:|---:|
| `Hx/Gz` | 20 | no nontrivial support | 2,827,258,588 | 6.152045423 s |
| `Hz/Gx` | 20 | no nontrivial support | 2,707,051,664 | 6.318846902 s |
| `Hx/Gz` | 24 | exact 24 | 98,075,453,712 | 239.297633640 s |
| `Hz/Gx` | 24 | exact 24 | 93,926,330,468 | 230.024455304 s |

The exact radius-24 runs therefore enumerate 192,001,784,180 candidates in
469.322088944 seconds of combined search time.  They retain distinct weight-24
witnesses.  An independent checker also proves that block swap followed by
torus inversion `(r,c) -> (-r,-c)` maps the first physical row space to the
second and maps the first observability quotient to the second.  It transports
the first witness to another valid weight-24 witness for the second direction.
Either direct exhaustive record plus that isomorphism suffices; the second
direct record is an independent implementation control.

QDistSAT commit `9fb224b0fa372161fb3933034016bc8dc423a5ab` reports all
46 configurations timing out at 7,200 seconds on the radius-20 scan, with
partial lower bounds mostly 8--11 and a Magma upper bound of 24.  Against that
published stop condition, Ergodis' two-direction radius-20 search gives a
conservative cross-machine lower bound of `7200 / 12.470892325 = 577.34x` warm.
Including both first compilations gives 22.353529959 seconds and a `322.10x`
cold lower bound.  These are single-round exploratory timing comparisons, not
multiround statistical estimates.  The exact-distance result itself is
deterministic and does not depend on the timing comparison.

The run used an AMD Ryzen AI 9 HX 370, 24 hardware threads, the performance
governor, enabled boost, no CPU isolation, and worker affinity `0..23`.  The
machine was otherwise quiet.  The extra-wide compiled artifacts are about
25 MiB per CSS direction and remain cache artifacts rather than Git evidence.

## Source and import boundary

The load-bearing matrices are the GPL-3.0-or-later QDistSAT files at the pinned
upstream commit; they are not redistributed in this bundle.  Their SHA-256
hashes are:

| file | bytes | SHA-256 |
|---|---:|---|
| `BB_360_12_?_Hx.txt` | 129,600 | `82ee8b8c47923d5aab484d61b3adb4076089460cabbad0a768d637fc5b09b4eb` |
| `BB_360_12_?_Hz.txt` | 129,600 | `381b7fe94dcda5b5d0d76363a4e965c3e73c305bdad8bcdd4fd3ac85014ae102` |
| `BB_360_12_?_Gx.txt` | 8,713 | `15c773fa3b548313924612d113a089c038a8a8110d0dc561fd9f884ce6d0ca60` |
| `BB_360_12_?_Gz.txt` | 8,713 | `d79d59ceb14cbbdc38cfca984be24a40474b5c79cdbf36316e825686a6a82594` |

`python/import_qdist_native.py` rejects malformed dense rows, reduces the
logical observations to a deterministic basis, checks that they are
independent modulo the physical constraints, and verifies both torus
translations on the physical row space and the observability quotient.  For
this instance each physical matrix has rank 174, each logical-observation
quotient has rank 12, the torus shape is `6 x 30`, and the verified coordinate
cover has anchors `[0,180]`.

The importer and the paired checker deliberately verify invariance on row
spaces and quotient observability, not by requiring a supplied logical basis
to be pointwise fixed.  The latter would be an invalid stronger condition.

The tracked checksum manifest is
`evidence/c985-qdist-bb360.sha256`.  Load-bearing bundle byte counts are:

| path | bytes |
|---|---:|
| `Cargo.lock` | 25,556 |
| `src/css_distance.rs` | 121,823 |
| `src/bin/css_distance_native.rs` | 14,563 |
| `src/lib.rs` | 5,944 |
| `python/import_qdist_native.py` | 6,282 |
| `python/check_bb_native.py` | 3,975 |
| `python/check_qdist_bb_pair.py` | 6,750 |
| `evidence/c985-qdist-bb360-hx-gz-w20.jsonl` | 1,202 |
| `evidence/c985-qdist-bb360-hz-gx-w20.jsonl` | 1,200 |
| `evidence/c985-qdist-bb360-hx-gz-w24.jsonl` | 1,364 |
| `evidence/c985-qdist-bb360-hz-gx-w24.jsonl` | 1,362 |

## Replay

Starting in `papers/complete-repair-ports/ergodis`, with the pinned QDistSAT
checkout under the disk-backed cache:

```bash
QDIST_ROOT=/home/tavis/.cache/ergodis/QDistSAT
ERGODIS_CACHE=/home/tavis/.cache/ergodis/css-native/qdist
CARGO_TARGET_DIR=/home/tavis/.cache/ergodis/target

git -C "$QDIST_ROOT" checkout 9fb224b0fa372161fb3933034016bc8dc423a5ab

nix develop .. --command python python/import_qdist_native.py \
  --physical "$QDIST_ROOT/data/BB/BB_360_12_?_Hx.txt" \
  --logical "$QDIST_ROOT/data/BB/BB_360_12_?_Gz.txt" \
  --label 'QDistSAT BB_360_12_? Hx/Gz' --maximum-weight 24 \
  --torus-shape 6,30 --out "$ERGODIS_CACHE/bb360-hx-gz-w24.json"

nix develop .. --command python python/import_qdist_native.py \
  --physical "$QDIST_ROOT/data/BB/BB_360_12_?_Hz.txt" \
  --logical "$QDIST_ROOT/data/BB/BB_360_12_?_Gx.txt" \
  --label 'QDistSAT BB_360_12_? Hz/Gx' --maximum-weight 24 \
  --torus-shape 6,30 --out "$ERGODIS_CACHE/bb360-hz-gx-w24.json"

nix develop .. --command cargo run --release --features parallel \
  --bin css_distance_native -- --input "$ERGODIS_CACHE/bb360-hx-gz-w24.json" \
  --compiled-out "$ERGODIS_CACHE/bb360-hx-gz-xwide-v1.bin" \
  --evidence "$ERGODIS_CACHE/bb360-hx-gz-w24-replay.jsonl" \
  --threads 24 --worker-cpus 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23

nix develop .. --command cargo run --release --features parallel \
  --bin css_distance_native -- --input "$ERGODIS_CACHE/bb360-hz-gx-w24.json" \
  --compiled-out "$ERGODIS_CACHE/bb360-hz-gx-xwide-v1.bin" \
  --evidence "$ERGODIS_CACHE/bb360-hz-gx-w24-replay.jsonl" \
  --threads 24 --worker-cpus 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23

nix develop .. --command python python/check_qdist_bb_pair.py \
  --first-input "$ERGODIS_CACHE/bb360-hx-gz-w24.json" \
  --second-input "$ERGODIS_CACHE/bb360-hz-gx-w24.json" \
  --first-evidence evidence/c985-qdist-bb360-hx-gz-w24.jsonl \
  --second-evidence evidence/c985-qdist-bb360-hz-gx-w24.jsonl
```

The output files use exclusive creation.  Remove or rename stale cache outputs
before replaying; do not target `/tmp`, which is RAM-backed on this host.

## Trusted boundary and checks

The independent Python checkers replay witness weight, physical syndrome,
logical nontriviality, the source/input radius, the X/Z row-space isomorphism,
and transported-witness validity.  The lower-bound exhaustion trusts the Rust
connected-support theorem implementation.  That implementation is checked
against exhaustive enumeration on all small binary fixtures, and the full
release suite passes `214` library, `3` kernel-binary, `5` CLI-binary, `7` CLI,
`9` allocation, `10` observational, and `1` Python-parity tests.

The new six-word backend is a separate const-generic monomorphization with its
own artifact magic.  Inputs through 320 coordinates retain the prior five-word
layout and artifact format.  A seven-round BB288 control after this change has
median 0.140481061 seconds versus the previous 0.144370631 seconds, a 2.69%
decrease within favorable noise; no smaller-solve regression was observed.

## Scope

This bundle proves the distance of these exact supplied matrices.  It does not
prove optimality among all weight-six codes, decoder threshold, circuit-level
performance, or a multiround wall-time distribution.  The next code-discovery
step is an algebraically filtered search for a qubit weight-six candidate with
`k d^2 / n > 19.2`, followed by exact certification only for Pareto survivors.
