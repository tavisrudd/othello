# C64 report: completion-poset (Erdos-lens) correlate of the arc-depleted flip

**Date**: 2026-07-09 (run 2026-07-10).

## Result

**Negative.** No completion-spectrum property is a viable mechanism for the
arc-depleted-orders dichotomy. Tested against the strict C55 discipline
(constant within the depleted orders `{11,17}`, constant within the full orders
`{13,19}`, different across, **and** the pattern present for the value-flipping
cohort while absent for the value-constant controls), every candidate fails:

- **min completion size** and **min move-parity**: flip does not switch across a
  pair; where anything switches, the *controls* switch at least as much (the
  wrong direction for a mechanism).
- **parity of the number of maximal completions**: the one property that cleanly
  separated flip from control at the small pair `11/13` (all flips `even -> odd`,
  controls mixed) **does not generalize**. At `17/19` the flip cohort's full-order
  parity is itself mixed, flip and control take *identical* completion counts, and
  more than a quarter of flip configs don't switch parity at all.
- **size-parity availability**: every config at every order has both an
  odd-move and an even-move maximal completion (`has_odd = has_even = True`
  universally), so the "uniform move-parity forces the value" shortcut never
  fires and completion size-parity cannot by itself determine N/P.

Since C64 is negative, and per the C64 queue entry, a C55 negative on the same
119 configs should promote **S1 (Segre-style envelope invariants)** as the
remaining live mechanism candidate for the (ON) route.

## Gate (verbatim)

The run reproduces the 119-obstruction alignment gate before any enumeration:

```text
=== (0) ALIGNMENT GATE (must match 2026-07-09-onconic-child-type-alignment.md) ===
  integral types total=614  appear at >=2 q=169  aligned=50  OBSTRUCTIONS=119
  obstructions N@q=11: 16   N@q=17: 105   N at a full order (13 or 19): 0
  GATE: PASS
```

Cohorts (shared integral types present at both orders of a pair):
`11/13` -> flip 11, control 17; `17/19` -> flip 100, control 30.

## Method

### The completion object

Model reused verbatim from `c55_intruder_skeleton.Conic`. Burned pair
`a=(1:0:0)`, `b=(0:1:0)`; conic `C: r*c=1`, `cell(t)=(t, t^-1)`. Both burned
points lie on the projective closure `xy=z^2`, so the conic is the oval
`{a,b} u {(t,1/t)}` of `q+1` points. A residual-grid legal position is a partial
permutation with no 3 collinear = an arc of PG(2,q) containing `a,b`
(collinearity with `a` <=> shared row `v`; with `b` <=> shared column `u`; no 3
affine cells collinear otherwise).

A **completion** of an on-conic S4 (params `T4`) is a **maximal** such arc (a
complete arc) containing the 4 cells of `T4`. The **completion spectrum** is the
multiset of completion sizes, the count of maximal completions, and parities /
thresholds derived from them.

Two structural facts anchor the spectrum:

- The conic itself is always a completion, of cell-size `q-1` (an even number of
  moves `q-5` for all four `q`). So the max completion size is `q-1` at every
  order (verified by brute force), and it is non-discriminating.
- Because the residual game is normal play and each move adds exactly one cell, a
  completion of cell-size `s` costs `s-4` moves. If every completion had the same
  move-parity the value would be forced (N iff `s-4` odd). The conic supplies an
  even-move completion at every order, so an N verdict must come from a shorter,
  odd-move completion -- the geometric intuition this task tests.

### Enumeration

The "no 3 collinear" constraint is **not** pairwise (three new cells can be
pairwise-legal yet collinear), so plain graph-clique enumeration is invalid.
Maximal arcs are enumerated by incremental legal extension -- a Bron-Kerbosch
recursion over the *independence system* of arcs, whose add-test rechecks the
full triple constraint and whose maximality test is "no single cell is addable".
Cells are bit-indexed; per candidate, precomputed kill-masks give exactly which
ground cells its addition forbids (the row/col lines `a-i`, `b-i`, the affine
triples `{T4cell,i,.}`, and the secants `{i,j,.}`), so each recursion node is a
few big-int operations. The exact **minimum** completion size is found by a
separate branch-and-bound (prune once the partial arc can no longer beat the
current best), which stays cheap even where the full count is large.

### Caps and exhaustiveness

Each config carries a node/time cap; a truncated config would be flagged and its
count/parity treated as unknown (never silently capped). With the bit-mask
enumerator **no sampled config truncated**: full enumeration is
`~0.15 s` at `q=17` (`~37k` completions) and `~2.2 s` at `q=19` (`~440k`
completions), both exact. `q=11` and `q=13` are enumerated exhaustively over
**all** flip and control configs; `q=17/19` over a deterministic seeded sample
(`SEED=20260709`) of 40 flip + 30 control configs, each fully enumerated.

### Sanity checks

Gate reproduced (above). Independent brute-force `is_arc` / `is_maximal` checks
confirm the enumerator's completions are genuine maximal arcs and that the whole
conic is a complete arc:

```text
=== sanity: spot-check completions are genuine maximal arcs ===
  q=11 key=((-3, -2, -1), 1): sample completion size=6 is_arc=True is_maximal=True | whole-conic complete arc(size 10)=True
  q=11 key=((-3, -2, -1), 2): sample completion size=7 is_arc=True is_maximal=True | whole-conic complete arc(size 10)=True
  q=17 key=((-3, -2, -1), 2): sample completion size=10 is_arc=True is_maximal=True | whole-conic complete arc(size 16)=True
  q=17 key=((-3, -2, -1), 1): sample completion size=10 is_arc=True is_maximal=True | whole-conic complete arc(size 16)=True
  (4 spot-checks passed)
```

The enumeration makes no game-value claim of its own: the only value-relevant
deduction the spectrum permits (uniform move-parity => value forced) never fires
(see `has_odd`/`has_even` below), so there is nothing that could disagree with the
corpus `val`. The branch-and-bound min agrees with the full-enumeration min on
every non-truncated config (`minmatch`).

## Contingency tables (verbatim)

### Pair 11/13 (depleted q=11 -> full q=13), all flip+control

```text
-- (A) MIN completion cell-size  paired (dep q=11, full q=13) --
   flip    n= 11  (min_dep,min_full)-> count : {(6, 6):11}
   flip            (minMoveParity_dep,_full)   : {(0, 0):11}
   control n= 17  (min_dep,min_full)-> count : {(6, 6):5, (6, 7):12}
   control         (minMoveParity_dep,_full)   : {(0, 0):5, (0, 1):12}

-- (C) #completions and parity (exhaustive; None=truncated) --
   q=11 flip    count-parity dist: {0:11}   (distinct counts: {40:11})  truncated=0
   q=11 control count-parity dist: {0:11, 1:6}   (distinct counts: {29:6, 30:3, 42:8})  truncated=0
   q=13 flip    count-parity dist: {1:11}   (distinct counts: {305:6, 341:5})  truncated=0
   q=13 control count-parity dist: {0:10, 1:7}   (distinct counts: {235:2, 302:10, 305:2, 341:3})  truncated=0

-- (D) PAIRED count-parity (dep,full) [both exhaustive] --
   flip    (parity_dep,parity_full)->count : {(0, 1):11}
   control (parity_dep,parity_full)->count : {(0, 0):7, (0, 1):4, (1, 0):3, (1, 1):3}

-- (E) representative full size-distributions --
   q=11 flip    distinct dists(1): {6:15, 7:24, 10:1}
   q=11 control distinct dists(3): {6:26, 7:15, 10:1}; {6:18, 7:9, 8:1, 10:1}; {6:24, 7:2, 8:3, 10:1}
   q=13 flip    distinct dists(2): {6:2, 7:154, 8:147, 10:1, 12:1}; {6:1, 7:197, 8:141, 10:1, 12:1}
   q=13 control distinct dists(4): {7:168, 8:132, 10:1, 12:1}; {6:1, 7:197, 8:141, 10:1, 12:1}; {7:96, 8:135, 10:3, 12:1}; {6:2, 7:154, 8:147, 10:1, 12:1}
```

At `11/13`, table (D) is the *only* clean flip/control separation in the whole
study: every flip config flips completion-count parity `even -> odd`; controls
are spread over all four parity transitions. This is what motivated carrying the
count-parity property to the larger pair.

### Pair 17/19 (depleted q=17 -> full q=19), sample 40 flip + 30 control

```text
-- (A) MIN completion cell-size  paired (dep q=17, full q=19) --
   flip    n= 40  (min_dep,min_full)-> count : {(8, 8):40}
   flip            (minMoveParity_dep,_full)   : {(0, 0):40}
   control n= 30  (min_dep,min_full)-> count : {(8, 8):30}
   control         (minMoveParity_dep,_full)   : {(0, 0):30}

-- (C) #completions and parity (exhaustive; None=truncated) --
   q=17 flip    count-parity dist: {0:40}   (distinct counts: {36742:12, 36944:3, 37052:5, 37360:3, 38342:17})  truncated=0
   q=17 control count-parity dist: {0:14, 1:16}   (distinct counts: {32934:4, 33773:8, 35610:10, 35819:8})  truncated=0
   q=19 flip    count-parity dist: {0:13, 1:27}   (distinct counts: {414761:2, 428013:2, 431104:2, 437127:3, 437813:1, 438551:5, 441106:3, 442861:7, 453648:8, 453691:7})  truncated=0
   q=19 control count-parity dist: {0:15, 1:15}   (distinct counts: {409050:2, 413294:3, 429969:2, 431104:6, 437127:5, 437813:4, 438551:1, 441106:3, 453648:1, 453691:3})  truncated=0

-- (D) PAIRED count-parity (dep,full) [both exhaustive] --
   flip    (parity_dep,parity_full)->count : {(0, 0):13, (0, 1):27}
   control (parity_dep,parity_full)->count : {(0, 0):8, (0, 1):6, (1, 0):7, (1, 1):9}

-- (E) representative full size-distributions --
   q=17 flip    distinct dists(5): {8:2073, 9:27269, 10:8842, 11:146, 12:11, 16:1}; ...
   q=17 control distinct dists(4): {8:2096, 9:25524, 10:7846, 11:130, 12:13, 16:1}; ...
   q=19 flip    distinct dists(10): {8:45, 9:54258, 10:329058, 11:43350, 12:1301, 18:1}; ...
   q=19 control distinct dists(10): {8:42, 9:56029, 10:334376, 11:45491, 12:1188, 18:1}; ...
```

The `11/13` count-parity signal collapses at `17/19`:

- `q=19` flip parity is **mixed** (`{0:13, 1:27}`), so it is not constant within
  the full orders `{13,19}` (`q=13` was all-odd).
- flip and control take **identical** completion counts at `q=19` (e.g. `453691`,
  `431104`, `437127`, `437813`, `438551`, `441106`, `453648` all appear in both
  cohorts), so the count does not separate flip from control there.
- More than a quarter of flip configs (`(0,0):13`) do not even switch parity
  across the `17/19` pair, versus every flip switching at `11/13`.

## Strict verdict test (verbatim)

Flip / control configs pooled across both pairs by order-role
(depleted `{11,17}` vs full `{13,19}`):

```text
-- property: count_parity --
   flip    depleted{11,17} dist={0:51}  full{13,19} dist={0:13, 1:38}
   flip    const-within-dep=True const-within-full=False differ-across=False
   control depleted{11,17} dist={0:25, 1:22}  full{13,19} dist={0:25, 1:22}
   => VIABLE MECHANISM: False

-- property: min_size --
   flip    depleted{11,17} dist={6:11, 8:40}  full{13,19} dist={6:11, 8:40}
   flip    const-within-dep=False const-within-full=False differ-across=False
   control depleted{11,17} dist={6:17, 8:30}  full{13,19} dist={6:5, 7:12, 8:30}
   => VIABLE MECHANISM: False

-- property: min_move_parity --
   flip    depleted{11,17} dist={0:51}  full{13,19} dist={0:51}
   flip    const-within-dep=True const-within-full=True differ-across=False
   control depleted{11,17} dist={0:47}  full{13,19} dist={0:35, 1:12}
   => VIABLE MECHANISM: False

-- property: has_odd --
   flip    depleted{11,17} dist={True:51}  full{13,19} dist={True:51}
   control depleted{11,17} dist={True:47}  full{13,19} dist={True:47}
   => VIABLE MECHANISM: False

-- property: has_even --
   flip    depleted{11,17} dist={True:51}  full{13,19} dist={True:51}
   control depleted{11,17} dist={True:47}  full{13,19} dist={True:47}
   => VIABLE MECHANISM: False
```

`min_move_parity` is a constant `0` for the flip cohort at every order, so it
cannot differ across; `has_odd`/`has_even` are constant `True` for every config
at every order (each completion poset always contains both an odd-move and an
even-move maximal arc), so the parity of the completion set never forces the
value; `min_size` scales with `q` and, within a pair, only *controls* ever move
it (`11/13`); `count_parity` is the near-miss killed by `17/19` as detailed above.

## Interpretation

The `11/13` completion-count-parity split is a small-field artifact: at `q=11`
all 11 flip configs share one completion spectrum (`{6:15, 7:24, 10:1}`, count
exactly `40`), so a single orbit's parity was mistaken for a cohort law. At
`q=17` and `q=19` the completion counts spread into overlapping ranges shared by
flip and control, and the parity of a ~4x10^5 count carries no cohort signal.

The deeper structural reason the completion poset cannot carry the value: every
config, at every order, admits both odd-move and even-move complete arcs
(`has_odd = has_even = True` throughout). The residual game is therefore always
genuinely branching -- neither player is forced into a fixed move-count -- so the
N/P value is a property of the full game tree, not of any coarse summary of the
terminal (maximal-arc) layer. An Erdos-style extremal correlate of the flip does
not exist at the resolution of the completion spectrum.

## Promotion

C64 is negative. Combined with a C55 negative on the same 119 configs, **S1
(Segre-style envelope invariants)** is the remaining mechanism candidate and
should be promoted per the C64 queue entry.

## Reproduce

From the repo root:

```bash
python3 rust/scripts/c64_completion_poset.py           # full report (~4 min; q=19 sample dominates)
python3 rust/scripts/c64_completion_poset.py --quick   # 11/13 only, fast
```

Deterministic: the `q=17/19` config sample is seeded (`SEED=20260709`,
40 flip + 30 control). All four orders are enumerated exhaustively (no config
truncated in this run); the gate and sanity spot-checks run first and must pass.
