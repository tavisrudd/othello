# C65: q=23 recursive steering-ceiling measurement

Date: 2026-07-09.

## Result

The q=23 measurement is route-deciding, but the complete all-P-reply census is not finished.
With the same C31 definition

```text
Z(S) = 0                                      if S is terminal,
Z(S) = max_m min_{P replies r}
       max(zone(S+m+r), Z(S+m+r))             otherwise,
```

the present exact coverage proves

```text
40 <= Z(23) <= 136.
```

Here `Z(23)` means the C31-style maximum over P-valued size-6 followers of the 22 normalized
q=23 S4 bucket roots.  The lower bound is an exact state solve, independently reproduced by the
original Python C31 recurrence.  The upper bound is coverage-independent: all 22 untruncated
depth-2 enumerations contain every legal size-6 follower and report `legal_max <= 136`; the
off-conic legal zone only shrinks as cells are added, so every descendant zone in the Z recurrence
is at most the starting state's legal-move count.

The fully measured zero-xor-selected bucket `[1,2,3,8]` has exact maximum 40.  The fully measured
maintenance-approved bucket `[1,3,4,9]` has exact maximum 36.  Uniform 25-seed screens of the
other 20 buckets have maxima 36..39.  Thus 40 is the best measured lower bound and no screened
bucket exceeds it, but this report does **not** upgrade 40 to the exact all-bucket value.

The route verdict is plain: the small-uniform-Z base-law route should not be the primary proof
plan.  The measured sequence is now

```text
q       13   17   19    23
max Z    2    9   16   >=40
```

and the q=23 extremum is forced by an immediate zone cost, not persistent recursive complexity.
The amortized-potential / charged-descent form should be primary; a small-Z law remains valuable
as the terminal layer after one expensive repair pair.

## Native instrument

Added `s4zcensus` to `notes/2026-07-06-grid-cap-solver.rs` and documented it in the S4 manual.
It parses `XORRESULT status=hit` followers from one or more `s4xormine` logs, reconstructs and
independently resolves each state as P, canonical-deduplicates it, and computes exact Z with shared
native outcome and Z memos.  It emits:

- `S4ZSTATE`: Z, starting zone, live conic, conic component/defect spectrum, and zone support;
- `S4ZEXTREME`: a locally oriented optimal worst-case trajectory;
- `S4ZCENSUS-DONE`: coverage, histogram, abort and memo counters.

An optional exact raw-P/N lookup path was A/B tested.  It reduced newly solved states but was
slower because random mmap binary searches dominated: 25 q=23 states took 120.5 s with raw lookup
versus 95.5 s natively.  The final runs therefore used the native shared memo.

Build:

```text
rustc -O -C target-cpu=native notes/2026-07-06-grid-cap-solver.rs \
  -o rust/target/gridcap-c65
```

## Exact full buckets

### Maintenance-approved `[1,3,4,9]`

The 26 complete `--require-maintenance` chunks contain 259 accepted followers.  They collapse to
124 canonical states; all independently re-solve as P.

```text
Z=29:2  Z=30:1  Z=31:3  Z=32:25
Z=33:37 Z=34:32 Z=35:14 Z=36:10
max Z = 36
initial zone range = 101..116
outcome memo = 43,676,612
Z memo = 6,969,857
wall = 508.6 s
peak RSS = 3,586,840 KB
```

This is the bucket whose one-pair zero-xor maintenance obligation was previously fully censused.
The recursive ceiling is larger than the one-pair residual `live_on <= 2` majority suggests, but
its extremal lines still descend quickly.  A representative Z=36 trajectory has zone/child-Z
sequence `36/6, 6/0, 0/0`.

### Zero-xor-selected `[1,2,3,8]`

The 262 selected followers were computed in two cap-safe segments.  Deduplicating canonical keys
across the segments gives 225 exact states:

```text
Z=31:3  Z=32:11 Z=33:49 Z=34:74 Z=35:58
Z=36:20 Z=37:4  Z=38:5  Z=40:1
max Z = 40
```

The first segment deliberately stopped at the 60M outcome cap after seed 188; the second resumed
at seed 189 and completed.  There are no missing seeds after combining the segments and no bad
P/N labels.  The 60M segment peaked at 7,066,200 KB RSS, below the 8 GB gate.

## Extremal configuration

The unique Z=40 state in the full `[1,2,3,8]` selected corpus is

```text
t4 = [1,2,3,8]
root cells = (1,1) (2,12) (3,8) (8,3)
first intrusion x = (13,4)
selected P reply y = (9,19)
canonical key = 01885fc712198a1596f1f976abb7b474
initial off-conic zone = 119
live_on = 6
defect/component spectrum = 4,1,1
conic Node-Kayles xor = 0
zone rows/columns = 17/17
row load range = 6..10; column load range = 6..8
row/column odd-load counts = 9/9
```

Its exact optimal worst-case line is

```text
opponent (10,15), reply (0,7):   child zone 40, child Z 7
opponent (6,20),  reply (4,10):  child zone 7,  child Z 0
opponent (7,5),   reply (11,9):  child zone 0,  child Z 0
terminal
```

So the 40 is an immediate repair cost: after paying it, recursion returns to a genuinely small
base layer.  This is not a Θ(q)-sized persistent defect skeleton.  The starting zone is large
(119), while the conic defect is only one 4-path plus two isolates.  Geometry forces many legal
intruders to survive, and P2's best answer to the worst move can cut that reservoir only to 40 in
one pair; subsequent pairs collapse it to 7 and then 0.

## Cross-bucket screen

For each remaining bucket, the first 25 selected seeds were evaluated exactly with a 12M outcome
cap.  Two slices had one canonical duplicate, so this is 498 per-bucket-canonical state rows total.
Every slice completed with `aborted=0` and `bad-labels=0`.

| bucket t4 | seeds / canonical | slice max Z |
|---|---:|---:|
| `[1,2,3,5]` | 25 / 25 | 36 |
| `[1,2,5,11]` | 25 / 25 | 37 |
| `[1,2,5,10]` | 25 / 24 | 37 |
| `[1,2,6,8]` | 25 / 25 | 36 |
| `[1,3,4,11]` | 25 / 25 | 38 |
| `[1,2,3,11]` | 25 / 25 | 37 |
| `[1,2,3,4]` | 25 / 25 | 38 |
| `[1,2,3,7]` | 25 / 25 | 38 |
| `[1,2,5,15]` | 25 / 24 | 37 |
| `[1,2,5,18]` | 25 / 25 | 38 |
| `[1,2,5,6]` | 25 / 25 | 37 |
| `[1,2,3,6]` | 25 / 25 | 37 |
| `[1,2,5,7]` | 25 / 25 | 36 |
| `[1,2,6,19]` | 25 / 25 | 36 |
| `[1,2,3,10]` | 25 / 25 | 37 |
| `[1,2,6,14]` | 25 / 25 | 36 |
| `[1,2,6,10]` | 25 / 25 | 36 |
| `[1,2,3,12]` | 25 / 25 | 39 |
| `[1,2,3,13]` | 25 / 25 | 36 |
| `[1,3,7,10]` | 25 / 25 | 37 |

The screen is evidence that 40 is near the selected-corpus ceiling, not a proof that no unscreened
state exceeds it.  Completing the other 20 selected buckets would take several more single-core
hours and would still not enumerate every P reply: `s4xormine` selects one zero-xor P follower per
first move, whereas C31's original q=13/17/19 census included all P replies.  The honest full-C31
deliverable is therefore the interval `40..136`.

## Growth-shape reading

Four points still underdetermine an asymptotic law, and q=23 is presently a lower bound.  Simple
through-origin least-squares fits to `(2,9,16,40)` nevertheless rank linear above square-root and
bounded shapes (RMSE 10.96, 12.66, and 14.31 respectively).  Affine fits give RMSE 4.26 for linear
and 4.89 for square-root.  These fits are descriptive only; the more robust facts are:

- `Z(23) >= 40` is already 2.5 times the exact q=19 value 16;
- `Z/q` rises from `0.15, 0.53, 0.84` to at least `1.74`;
- the Z=40 witness pays 40 immediately but then has child Z only 7.

Thus a bounded ceiling is empirically untenable, and an `O(sqrt(q))` interpretation now needs a
large constant plus a sharp q=23 jump.  Linear-scale immediate repair cost is the cleanest reading
of the available extremal witness.  This does not prove `Theta(q)` growth.

## Validation

1. Rust/Python smoke state: `[1,3,4,9] + (0,0) + (7,21)` gives `Z=34` in both engines.
2. Independent Python check of the extremum gives:

   ```text
   value False (P)
   Z 40
   zone 119
   trace (245, 7, 40, 7) = (10,15) -> (0,7), zone 40, child Z 7
   ```

3. Every logged `XORRESULT status=hit` follower is re-solved before Z; all reported runs have
   `bad-labels=0`.
4. The complete maintenance bucket has `aborted=0`.  The split selected bucket covers seeds
   0..188 and 189..261; its first segment's cap is explicit and the resumed segment completes.
5. All 20 screens have `aborted=0`; the S4 depth-2 enumerations used for the upper bound are
   `truncated=false`.

## Route verdict

Promote the amortized-potential/dual-certificate lane (C63) over a proof that tries to hold a
uniform small Z.  Preserve the C31 descent anatomy as the terminal mechanism:

```text
one possibly linear-cost repair pair
-> small recursive ceiling (7 in the extremal q=23 line)
-> empty/small-zone base law.
```

The most useful next C65 refinement, if desired, is not a blind full selected sweep.  It is to
classify the size-8 repair states attaining child zone 36..40 and prove/fit a charged decrease from
starting reservoir 119 to repair zone 40 to child ceiling 7.  That feeds the amortized invariant
directly and targets the geometric reason the immediate cost is linear.
