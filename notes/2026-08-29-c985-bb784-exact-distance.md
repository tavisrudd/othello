# C985 BB784 exact-distance certificate

**Lane:** `complete-ports`

**Date:** 2026-08-29
**Literature depth:** 0 sources read at full text; the construction was checked against the
Bravyi et al. source repository and the parameter table in arXiv:2308.07915.

## Outcome

Ergodis now certifies the published bivariate-bicycle code `[[784,24,24]]` at its exact distance.
The 16-thread native search found a weight-24 logical and exhaustively excluded every smaller
weight in 127.077243335 seconds.  It examined 29,319,071,014 candidates with 23.4 MiB peak RSS.

This is a larger-code result, not a new-code or priority claim.  It extends the opt-in large backend
from 768 to 832 coordinates while leaving the compact, wide, and extra-wide monomorphs unchanged.
The fixed search state is still stack-/workspace-resident and allocation-free per candidate.

## Construction and exactness

The deterministic generator instantiates

```text
ell,m = 28,14
A = x^26 + y^6 + y^8
B = y^7 + x^9 + x^20
Hx = [A | B]
Hz = [B^T | A^T]
```

It verifies CSS commutation, `rank(Hx)=rank(Hz)=380`, and quotient dimension 24.  Translation
symmetry reduces the complete anchor set to `[0,392]`.  Every presented physical column has odd
weight, so every kernel support has even cardinality; the exhaustive radius-24 run therefore also
closes the odd shells.  The retained witness is

```text
[0,2,4,6,8,10,12,30,34,36,40,56,62,64,84,427,448,511,532,602,616,686,735,770].
```

The independent Python replay checks that these 24 distinct coordinates have zero `Hx` syndrome
and nonzero observation in `ker(Hz)/row(Hx)`.  Block swap followed by torus inversion exchanges the
two CSS directions, so the certified X distance is also the Z distance.  Thus the quantum distance
is exactly 24.

## Scaling measurements

Cold compilation took 1.666088212 seconds and 24,248 KiB peak RSS; artifact writing took
0.017125525 seconds.  The cached artifact payload BLAKE3 is
`36699e25f428c8c32c24d99fa2958e270f14d39d76c1a8161da10af2a5d65d5a`.  The large artifact
version was bumped because its support width changed from 12 to 13 machine words.

Measured search shells were:

| Radius | Candidates | 16-thread seconds | Result |
| ---: | ---: | ---: | --- |
| 20 | 1,115,482,648 | 4.270381723 | no logical |
| 22 | 9,846,492,784 | 42.233224143 | no logical |
| 24 | 29,319,071,014 | 127.077243335 | distance 24 |

Only the radius-24 exact run is retained as repository evidence; the earlier shells are redundant
performance waypoints in the durable cache.

## Evidence and replay

Tracked evidence:

- `ergodis/evidence/c985-bb784-hx-gz-w24.jsonl`, 1,254 bytes,
  SHA-256 `2bc4ca2b0d9e65f36ca6ac344c96a3477da4c64aefd7242a65961723a9f2a8cc`.
- `ergodis/python/generate_bb_native.py`, 5,553 bytes,
  SHA-256 `41fce30d7c0633c5b38b6d8521909b8879a977a0e9c2d9c215d8454e6b56fd88`.

The canonical generated input is 18,727 bytes with SHA-256
`722349c07c40318c1dea3a643b525b33896269f7bc4cb1b3673eedc5a1856368`.
Replay from the ergodis root without using `/tmp`:

```bash
ERGODIS_CACHE=/home/tavis/.cache/ergodis/c985
python3 python/generate_bb_native.py \
  --ell 28 --m 14 --a 26:0,0:6,0:8 --b 0:7,9:0,20:0 \
  --direction x --label bb784-x --maximum-weight 24 \
  --out "$ERGODIS_CACHE/bb784-x.json"

cargo run --release --features parallel,large-css --bin css_distance_native -- \
  --input "$ERGODIS_CACHE/bb784-x.json" \
  --compiled-out "$ERGODIS_CACHE/bb784-x.ergocss" \
  --maximum-weight 2 --threads 1

cargo run --release --features parallel,large-css --bin css_distance_native -- \
  --input "$ERGODIS_CACHE/bb784-x.json" \
  --compiled-in "$ERGODIS_CACHE/bb784-x.ergocss" \
  --maximum-weight 24 --threads 16 \
  --evidence "$ERGODIS_CACHE/bb784-x-w24.jsonl"

python3 python/check_bb_native.py \
  --input "$ERGODIS_CACHE/bb784-x.json" \
  --evidence "$ERGODIS_CACHE/bb784-x-w24.jsonl" --minimum-rounds 1
```

The trusted lower-bound boundary is the reviewed Rust enumerator, its verified two-orbit cover,
and the even-kernel theorem.  The Python replay independently checks construction ranks and witness
semantics, but does not independently repeat the 29.3-billion-candidate exhaustion.

## Next gate

BB784 validates the next width and supplies a published control.  The higher-EV discovery step is
now a deterministic algebraic prefilter over inequivalent weight-six BB constructors, followed by
cheap radius shells and exact promotion only for candidates whose certified `k d^2/n` lower bound
can exceed the BB360 frontier `19.2`.  Candidates must also be rejected when Tanner decomposition
shows they are merely direct sums of known shorter codes.

