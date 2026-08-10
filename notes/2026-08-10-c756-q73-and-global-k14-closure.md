# C756 q=73 and global k=14 closure

**Date:** 2026-08-10

**Scope:** exact thirteen-line mixed secant/passant dual-star search over
\(\mathbf F_{73}\), completing the fixed-size k=14 ledger

**Status:** q=73 and the complete k=14 layer are closed

## Verdict

Deleting an external point from a hypothetical conic-filling 14-arc gives
thirteen polar lines of mixed secant/passant type whose 78 pairwise nodes are
internal and distinct.  The complete normalized q=73 search visits all 37
central-inversion seed representatives and 4,198,162,536 recursion states.
There is no thirteen-line geometric star.

The all-passant branch was independently closed at zero stars in 38,310,405
states.  Consequently

\[
 \boxed{\text{No conic-filling }14\text{-arc exists over }\mathbf F_{73}.}
\]

The direction bound left only q=61,67,71,73 at k=14.  The earlier exact
closures at the first three fields and the present q=73 result therefore give

\[
 \boxed{\text{No conic-filling }14\text{-arc exists over any finite field.}}
\]

The q=73 simultaneous-projection window would begin with \(E_6=0\), but no
geometric leaf exists, so no divided-coefficient test is needed.  This is a
fixed-size theorem, not the all-k classification.

## Independent engine and acceptance checks

The q=73 mixed run uses a compact C++ implementation of the same exact
normalized graph and no-three-concurrent clique search:
`notes/2026-08-10-c756-mixed-star-geometry.cpp`.

Before use, it was checked against the established Python generator at q=71:

- seed 0: both implementations return 64,626,335 search nodes and zero stars;
- seed 1: both return 77,878,824 search nodes and exactly two stars, and the
  Python best witness occurs in the C++ leaf set after canonical sorting.

A field-specific q=73 replay then checks seed 31 with the original Python
implementation; both return 100,452,157 search nodes and zero stars.  The
aggregate checker also reloads the original Python geometry at q=73, verifies
the pinned source hashes and shard metadata, and would independently recheck
every returned leaf's node character, distinctness, concurrence, complete
centers, type profile, and divided-coefficient window.  The leaf set is empty.

## Certificate and replay

Sources:

- `notes/2026-08-10-c756-mixed-star-geometry.cpp`;
- `notes/2026-08-10-c756-q73-mixed-star-aggregate.py`;
- pinned reference `notes/2026-08-09-c756-q59-k13-star-search.py`.

Certificate:
`notes/2026-08-10-c756-q73-k14-mixed.json`.

Exact replay from repository root:

```bash
g++ -std=c++20 -O3 -march=native -Wall -Wextra -pedantic notes/2026-08-10-c756-mixed-star-geometry.cpp -o /tmp/c756-mixed-star-geometry
mkdir -p /tmp/persistent/tavis/c756-q73-k14-mixed-cpp
seq 0 36 | xargs -P8 -I{} /tmp/c756-mixed-star-geometry 73 {} /tmp/persistent/tavis/c756-q73-k14-mixed-cpp/c756-q73-mixed-seed-{}.json
PYTHONDONTWRITEBYTECODE=1 python3 notes/2026-08-10-c756-q73-mixed-star-aggregate.py --shard-directory /tmp/persistent/tavis/c756-q73-k14-mixed-cpp --check notes/2026-08-10-c756-q73-k14-mixed.json
PYTHONDONTWRITEBYTECODE=1 python3 notes/2026-08-09-c756-q59-k13-star-search.py --q 73 --target-size 13 --mode mixed --seed-s 31 --output /tmp/persistent/tavis/c756-q73-k14-mixed-python-seed31-audit.json
```

The 37 compact shards remain in the durable ZFS directory named above; the
tracked certificate records each shard's filename, byte count, SHA-256, search
count, and leaf count.  Outputs are deterministic and contain no timestamps or
host paths.  The trusted boundary is the C++ implementation and compiler,
CPython and its exact modular arithmetic in the aggregate checker, and the
mathematical dual-star reduction.  No Lean-kernel proof is claimed.

The independent Python seed-31 audit is 949 bytes with SHA-256
`06b7de81da1a16a92a2f28c392b50d84eab850c80cc644ae340786f52f653209`.
It remains in the durable directory named by the replay command.

## EJ + TT closeout

**EJ.**  The independent engine turns the hardest census from an hours-scale
Python run into a nine-minute exact run and simultaneously strengthens the
evidence boundary.  More importantly, the result ends the fixed-size ladder:
k=12,13,14 are now all impossible over every finite field.  No k=15 census is
authorized or mathematically attractive.

**TT.**  The useful pattern is not the sequence of field closures but the
sharp dichotomy behind them.  At q=67 the all-passant branch has 92 geometric
stars killed by its first coefficient; at q=71 the mixed branch has 39 stars
killed by its first coefficient; at q=73 both branches die geometrically.  A
uniform proof should separate two mechanisms: a coherent-star stability
theorem that forces near-pencil structure, and a low-degree masked Rédei theorem
that kills the residual geometry by too many center roots.  The next work must
extract those mechanisms symbolically rather than extend the census ladder.

## Mystery ledger

| feature | status | exact gap / owning next gate |
|---|---|---|
| q=73 mixed thirteen-line geometry | settled computationally | no star in 4,198,162,536 states |
| q=73 fixed-field k=14 layer | settled negative | mixed and all-passant branches both closed |
| global k=14 layer | settled negative | q=61,67,71,73 exhaust the direction-bound frontier |
| transition 92 all-passant / 39 mixed / 0 stars | exact but unexplained | derive coherent-star stability or orbit/root-count law |
| nonsaturated all-k branch | open | masked Rédei missing-direction theorem for arbitrary defect |
| saturated-internal all-k branch | open | coherent dual-star nonblocking theorem |

## SHA-256 and byte counts

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-10-c756-mixed-star-geometry.cpp` | 8,108 | `44d881d50dd9fa4c2d73be99cae907956094c2cf2472aa7d13b5777aaaa45f02` |
| `notes/2026-08-10-c756-q73-mixed-star-aggregate.py` | 7,153 | `1f88a388405daf89aecebcadd8f42729079e8fdeeb6da88d8d8d2dc571b07600` |
| `notes/2026-08-10-c756-q73-k14-mixed.json` | 9,297 | `b2e25af01dad6860a7f152b4928132ea846527db67be9a0d93293e078191551c` |
| `notes/2026-08-09-c756-q59-k13-star-search.py` | 30,888 | `f5d0d53cf687bd44fda0f8e89584930983eac4d22905807d22901e4ee105c3d6` |
