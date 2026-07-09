# S4 Two-Ply Conic Depletion Bound

Date: 2026-07-08.

## Statement

Work in the normalized affine-grid model for an S4 root in `PG(2,q)`.

- The affine board is `F_q x F_q`.
- The root affine conic is

```text
C = { (t, t^-1) : t in F_q^* }.
```

- The S4 root selects four distinct points of `C`.
- A legal move cannot share a row or column with a selected point and cannot lie on an affine line
  determined by two selected points.

Let `live_on` be the number of currently legal, unselected points of `C` after two additional
legal moves from the S4 root.  Then:

```text
two off-conic moves:      live_on >= max(0, q - 19)
one off + one on-conic:   live_on >= max(0, q - 13)
two on-conic moves:       live_on =  q - 7
```

In particular, for odd finite-field orders `q >= 23`, no two-move root reply can empty the live
affine conic.  The empty-conic root-reply phenomenon is therefore confined to the small/boundary
range `q <= 19` at this layer.

## Incidence Facts

These are the only geometric inputs needed.

1. A row or column meets `C` in at most one affine point.
2. An affine line meets `C` in at most two affine points.  For nonvertical lines this is a
   quadratic after substituting into `r*c = 1`; vertical lines are columns and meet `C` once.
3. A line through a selected point of `C` and an off-conic point can kill at most one additional
   live point of `C`.
4. A line through two off-conic points can kill at most two live points of `C`.
5. A line through two selected points of `C` kills no live point of `C`, since its conic
   intersections are already the two selected endpoints.

The S4 root itself has:

```text
total affine-conic cells = q - 1
selected conic cells     = 4
dead conic cells         = 0
live conic cells         = q - 5
```

The dead count is zero because rows/columns through a conic point contain no other affine-conic
cell, and each line through two selected conic points has only those selected conic endpoints.

## Proof Sketch

Start from `q - 5` live conic cells.

### First off-conic move

An off-conic move can newly kill at most:

```text
2  from its row and column
4  from the four lines through the original S4 conic points
--
6
```

So after one off-conic move, `live_on >= q - 11`.

### Second off-conic move

Given one previous off-conic move, another off-conic move can newly kill at most:

```text
2  from its row and column
4  from the four lines through the original S4 conic points
2  from the line through the previous off-conic move
--
8
```

Therefore two off-conic moves leave:

```text
live_on >= q - 5 - 6 - 8 = q - 19.
```

Clamp at zero for small `q`.

### One off-conic and one on-conic move

If the off-conic move is first, it kills at most 6 live conic cells.  The later on-conic move
selects one live conic point and, via the line through the off-conic point, can kill at most one
additional live conic point:

```text
live_on >= q - 5 - 6 - 2 = q - 13.
```

If the on-conic move is first, it selects one live conic point.  The later off-conic move has row
and column kills plus at most one conic kill on each line through the five selected conic points:

```text
live_on >= q - 5 - 1 - 7 = q - 13.
```

Again clamp at zero for small `q`.

### Two on-conic moves

An on-conic move selects its own conic cell but adds no row/column conic kills, and lines between
selected conic points have no live conic intersections.  Therefore two on-conic moves leave exactly:

```text
live_on = q - 5 - 2 = q - 7.
```

## Mining Check

The current generated check is:

```text
rust/s4-dumps/2026-07-08/ml/conic-bound-report.txt
```

It parses S4 reply rows for q=9,11,13,17,19,23,25 root samples and currently reports:

```text
groups=54 failures=0
```

This check is regression evidence only.  The proof above is the part to formalize.

## Lean Target

Suggested theorem shape:

```text
S4.normalized_liveOn_after_two_moves_lower_bound
```

Inputs:

- normalized S4 root on `C = { (t, t^-1) }`;
- two legal extensions `x`, `y`;
- classification of `x`, `y` as on/off the affine conic.

Outputs:

- `liveOn >= max 0 (q - 19)` for off/off;
- `liveOn >= max 0 (q - 13)` for mixed on/off;
- `liveOn = q - 7` for on/on.

This lemma is purely incidence/counting.  It should not depend on recursive game values, memo dumps,
or certificate data.
