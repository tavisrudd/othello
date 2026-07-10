# C59 — exact arc-to-conic bounds for large terminals

Date: 2026-07-10.

## Result

**[PROVEN-PROSE + primary-source transcription]** A terminal of the projective cap game is a
complete planar arc.  For odd `q`, Segre gives the terminal dichotomy

```text
projective terminal size = q+1 (the full conic),
or projective terminal size <= B(q),
```

where the verified Ball--Lavrauw/Voloch rows below give an explicit `B(q) < q+1` whenever they
improve Segre.  Thus every terminal strictly larger than `B(q)` is the full conic.  This is a
terminal-structure constraint, not a strategy or `Good`-closure theorem.

**[COMPUTED SANITY]** A new terminal profile in `s4pncheck` was run against existing solved
on-conic S4 DAGs at `q=11,13,17,19`.  Every observed off-conic terminal obeys the applicable bound,
and every observed conic-contained terminal is the full `q+1` conic.  No new solve was launched.

The initial draft overclaimed three literature consequences.  They are corrected here:

- Kestenband's cited theorem constructs a non-conic arc of size `q-sqrt(q)+1`; the transcribed
  statement does **not** call that arc complete.  Completing it proves existence of some non-conic
  complete arc in an explicit interval, not necessarily at the construction size.
- The in-repo census does not source the exact second-largest complete-arc value at `q=25` or
  `q=31`; neither is asserted here.
- The odd-square error term `sqrt(q)/p+3` is not uniformly `O(1)` when the characteristic is fixed.
  The exact threshold is retained instead of being weakened to a misleading asymptotic slogan.

## 1. Verified imported statements

The statements below were transcribed from primary PDFs in
[`2026-07-07-relatedwork-o4.md`](2026-07-07-relatedwork-o4.md), Part A, item 1a.

- **Segre (1955):** for odd `q`, a planar arc has size at most `q+1`, with equality exactly for a
  conic.
- **Ball--Lavrauw, Planar arcs, Theorem 3:** if `q` is prime, an arc of size at least
  `q-sqrt(q)+7/2` is contained in a conic.
- **Ball--Lavrauw, Theorem 2 / survey Theorem 55:** if `q=p^(2h)` is odd square, an arc of size at
  least `q-sqrt(q)+sqrt(q)/p+3` is contained in a conic.
- **Voloch, survey Theorem 52:** if `q` is prime, an arc of size larger than
  `(44/45)q+8/9` is contained in a conic.
- **Voloch, survey Theorem 53:** if `q` is odd non-square, an arc of size larger than
  `q-(1/4)sqrt(pq)+(29/16)p-1` is contained in a conic.
- **Kestenband, survey Theorem 56:** for odd square `q>4`, the intersection of two suitable
  Hermitian curves is a non-conic planar arc of size `q-sqrt(q)+1`.

If an integer arc size `k >= T` forces containment, a non-conic arc has
`k <= ceil(T)-1`.  If `k > T` forces containment, it has `k <= floor(T)`.  Combining each row with
Segre (`k <= q` for a non-conic arc) gives

```text
B(q) = min(q, all applicable integer upper bounds).
```

For the orders checked by the companion script:

| `q` | arithmetic type | strongest verified `B(q)` |
|---:|:---|---:|
| 11 | prime | 11 |
| 13 | prime | 12 |
| 17 | prime | 16 |
| 19 | prime | 18 |
| 23 | prime | 21 |
| 25 | odd square | 23 |
| 27 | odd non-square | 27 (refined row is vacuous here) |
| 29 | prime | 27 |
| 31 | prime | 28 |

These are theorem bounds, not claimed exact values of `m'(2,q)`.

## 2. Why “contained in a conic” becomes “the full conic” at a terminal

A proper subset of a conic is extendable by any missing conic point: a line meets a nondegenerate
conic in at most two points, so adding another conic point cannot create three collinear points.
Consequently, a **complete** arc contained in a conic must be the whole `q+1` conic.  Applying an
arc-to-conic threshold to a terminal therefore yields the dichotomy in the result, rather than a
third class of proper conic-contained terminals.

For an odd square, Kestenband's arc can be extended (on the finite board) to a complete arc.  That
completion cannot lie in a conic, because it contains the original non-conic arc.  The verified
consequence is therefore

```text
q-sqrt(q)+1 <= size of some non-conic complete arc
                 <= ceil(q-sqrt(q)+sqrt(q)/p+3)-1.
```

At `q=25` this interval is `[21,23]`.  Calling the size exactly `21`, or identifying the
second-largest complete arc as `21`, requires an additional sourced completeness/classification
statement that the current in-repo census does not provide.  The construction still makes odd
squares a sensible falsification target, but it does not prove a game-value exception.

## 3. Residual-grid translation

The normalized residual game includes two burned projective direction points.  An S4 state has
four selected affine points on the root conic; a later state with `a` further on-conic points and
`b` off-conic points corresponds to a projective arc of size

```text
k = 2 + 4 + a + b = 6+a+b.
```

Rows and columns are precisely the lines through the two burned direction points.  A point on the
deleted opening line is illegal because it forms a triple with the opening pair.  Hence “no legal
residual-grid extension” is equivalent to completeness of the associated projective arc; the
row/column capacity does not create artificial grid-only terminals.

The completed root conic has `q-1` affine grid points plus the two burned directions.  It is a
permutation graph, so selecting all `q-1` affine points respects row and column capacity and gives
the reachable projective conic terminal of size `q+1`.

What does **not** carry:

- the theorem does not choose replies or show the conic terminal is reachable under optimal play;
- it does not say all terminals have one parity;
- it says nothing about the P/N value of a live conic move;
- a terminal spectrum cannot by itself prove the initial position P.

## 4. C46/C47 combined constraint

This adds the following row to the minimal-counterexample package.

> **[PROVEN-PROSE + citation]** From an on-conic S4 root, C46 guarantees a live conic cell for every
> continuation depth `t<T(q)`, where
> `T(q)=ceil((sqrt(4q+5)-5)/2)`.  Any eventual terminal has projective size at least the C47
> secant-cover lower bound `floor(b2(q))+1`.  At the other end, it is either the full conic of size
> `q+1`, or a non-conic complete arc of size at most the exact `B(q)` above.

Thus C46 constrains the early depletion time, C47 constrains the minimum terminal length, and C59
removes the large non-conic terminal band.  None supplies the missing mid-game steering closure.

## 5. Solved-data sanity gate

`s4pncheck` now reports a `terminal-profile` keyed by projective size and geometry (`c` = contained
in the completed root conic, `o` = off-conic).  It traverses the existing certified P/N DAG and
counts canonical terminal nodes; these counts are not labelled-arc counts or a classification.

| `q` | stored roots checked | observed off-conic sizes | conic-contained sizes | verdict |
|---:|:---|:---|:---|:---:|
| 11 | stored `1,2,3,4` S4 root | 8, 9 | 12 | PASS |
| 13 | stored `1,2,3,4` S4 root | 8, 9, 10, 12 | 14 | PASS |
| 17 | stored `1,2,3,4` S4 root | 10, 11, 12, 13, 14 | 18 | PASS |
| 19 | all 13 stored full-PGL S4 buckets | 10, 11, 12, 13, 14 | none observed | PASS |

The q=19 DAGs contain no terminal near the theorem cutoff; that row is consistency evidence, not a
sharpness claim.  Early-break N records omit losing continuations, so the profiles describe the
stored solved DAGs, not all complete arcs through each root.

The sourced full spectra at `q=23,27,29` provide an independent arithmetic check: their exact
second-largest sizes are respectively `17,22,24`, and every non-conic spectrum entry obeys the
applicable `B(q)`.  No exact `m'` is inferred at `q=25` or `q=31`.

## 6. Reproduce

```bash
python3 rust/scripts/c59_arc_stability_check.py
rustc -O notes/2026-07-06-grid-cap-solver.rs -o /tmp/gridcap-c59
/tmp/gridcap-c59 s4pncheck 17 1,2,3,4 \
  --raw rust/s4-dumps/2026-07-08/q17-root-1234-1-2-3-4.raw
```

The q=19 aggregate uses the thirteen `q19-bucket00` through `q19-bucket12` raw files under
`rust/s4-dumps/2026-07-08/`.
