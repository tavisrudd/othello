# C32 Report: Composite-Mirror Stuck-Free Probe

Date: 2026-07-09

## Verdict

The primary point-reflection composite mirror is **not stuck-free** in the plane variant at
`q = 9, 11, 13`, even allowing P2 existential choice of:

- affine seed reply / center,
- line-at-infinity reply `h'`,
- double-pencil exception cell.

The small cases still pass: `q = 3, 5, 7`.

For `PG(4,3)`, the fixed elliptic-`rho` primary variant fails the seed obligation immediately
for every affine seed: the seed-pair direction `h0` is dead, P1 can legally play
`rho^{-1}(h0)`, and P2's forced `rho` reply is the dead point `h0`.

Reflection towers and non-`rho` higher-dimensional variants were not implemented here. The
primary candidate and the plane adaptive `h'` / exception-cell family are closed negative.

## Artifact

Script added:

```text
rust/scripts/projcap_composite_mirror_probe.py
```

The plane verifier uses homogeneous projective coordinates and determinant collinearity. It
treats P1 choices universally and P2 policy choices existentially, memoized by selected set and
the optional selected infinity pair. The model self-checks:

- `PG(2,q)` has `q^2 + q + 1` lines,
- every line has `q + 1` points,
- every point lies on `q + 1` lines,
- determinant collinearity matches an independently computed line-equation check.

## Diff Against 2026-07-05 Central Symmetry

The 2026-07-05 failure was in the **post-frame residual grid**: the opening pair burned two
directions, creating row/column capacity-1 constraints, and central symmetry failed on the
center row/column.

This C32 plane probe is a different full-plane policy. It does **not** use row/column residual
constraints and does seed the center by P2's first reply. The new failures are:

- `q = 9`: after one infinity pair and one double-pencil exception, the exception points break
  the global reflection condition enough that a later ordinary bulk reflection is illegal.
- `q = 11, 13`: after three ordinary reflected affine pairs, P1 has a legal infinity move with
  no legal infinity reply.

So the composite removes the old row/column-center obstruction, but replaces it with
line-at-infinity and exception-symmetry obstructions.

## Commands and Output

Small-case sanity:

```text
$ python3 scripts/projcap_composite_mirror_probe.py --plane 3 --plane 5 --plane 7 --seed-log none --node-cap 1000000 --trace-limit 20
CHECK plane q=3 lines=13 line_size=4 point_line_count=4 det_vs_line_mismatches=0
PLANE q=3 points=13 affine=9 H=4 seeds=8
RESULT plane q=3 STUCK_FREE seed=A(0,1) center=A(0,2) nodes=6 elapsed=0.001s
CHECK plane q=5 lines=31 line_size=6 point_line_count=6 det_vs_line_mismatches=0
PLANE q=5 points=31 affine=25 H=6 seeds=24
RESULT plane q=5 STUCK_FREE seed=A(0,1) center=A(0,3) nodes=43 elapsed=0.021s
CHECK plane q=7 lines=57 line_size=8 point_line_count=8 det_vs_line_mismatches=0
PLANE q=7 points=57 affine=49 H=8 seeds=48
RESULT plane q=7 STUCK_FREE seed=A(0,1) center=A(0,4) nodes=263 elapsed=0.132s
```

Main C32 run:

```text
$ python3 scripts/projcap_composite_mirror_probe.py --plane 9 --plane 11 --plane 13 --seed-log none --node-cap 5000000 --trace-limit 20 --pg43-seed
CHECK plane q=9 lines=91 line_size=10 point_line_count=10 det_vs_line_mismatches=0
PLANE q=9 points=91 affine=81 H=10 seeds=80
RESULT plane q=9 NO_STUCK_FREE_SEED tested=80 nodes=121360 elapsed=3.887s
FAIL q=9 kind=bulk_reply_illegal seed=A(0,1) state={A(0,0), A(0,1), A(1,2), A(8,8), H(1:0), H(1:8)} detail=sigma(x)=A(2,7) is not legal
FAIL_P1 A(1,3)
TRACE 01 P1 A(0,0)  # normalized first affine move
TRACE 02 P2 A(0,1)  # seed reply
TRACE 03 P1 H(1:0)  # line-at-infinity move
TRACE 04 P2 H(1:8)  # adaptive H reply
TRACE 05 P1 A(1,2)  # enters poisoned pencil
TRACE 06 P2 A(8,8)  # double-pencil exception reply
TRACE 07 P1 A(1,3)  # unanswered legal move
CHECK plane q=11 lines=133 line_size=12 point_line_count=12 det_vs_line_mismatches=0
PLANE q=11 points=133 affine=121 H=12 seeds=120
RESULT plane q=11 NO_STUCK_FREE_SEED tested=120 nodes=870 elapsed=1.270s
FAIL q=11 kind=h_reply_nonexistence seed=A(0,1) state={A(0,0), A(0,1), A(1,0), A(1,2), A(4,2), A(7,10), A(10,1), A(10,10)} detail=no legal H reply; legal_h_after_x=0
FAIL_P1 H(1:4)
TRACE 01 P1 A(0,0)  # normalized first affine move
TRACE 02 P2 A(0,1)  # seed reply
TRACE 03 P1 A(1,0)  # bulk affine move
TRACE 04 P2 A(10,1)  # bulk reflection reply
TRACE 05 P1 A(1,2)  # bulk affine move
TRACE 06 P2 A(10,10)  # bulk reflection reply
TRACE 07 P1 A(4,2)  # bulk affine move
TRACE 08 P2 A(7,10)  # bulk reflection reply
TRACE 09 P1 H(1:4)  # unanswered legal move
CHECK plane q=13 lines=183 line_size=14 point_line_count=14 det_vs_line_mismatches=0
PLANE q=13 points=183 affine=169 H=14 seeds=168
RESULT plane q=13 NO_STUCK_FREE_SEED tested=168 nodes=4290 elapsed=3.361s
FAIL q=13 kind=h_reply_nonexistence seed=A(0,1) state={A(0,0), A(0,1), A(1,0), A(1,2), A(3,8), A(10,6), A(12,1), A(12,12)} detail=no legal H reply; legal_h_after_x=0
FAIL_P1 H(1:10)
TRACE 01 P1 A(0,0)  # normalized first affine move
TRACE 02 P2 A(0,1)  # seed reply
TRACE 03 P1 A(1,0)  # bulk affine move
TRACE 04 P2 A(12,1)  # bulk reflection reply
TRACE 05 P1 A(1,2)  # bulk affine move
TRACE 06 P2 A(12,12)  # bulk reflection reply
TRACE 07 P1 A(3,8)  # bulk affine move
TRACE 08 P2 A(10,6)  # bulk reflection reply
TRACE 09 P1 H(1:10)  # unanswered legal move
PG43_SEED_OBSTRUCTION seeds=80 failures=80 points=121 affine=81 H=40
PG43_FAIL_EXAMPLE 0 seed=A(1, 0, 0, 0) center=A(2, 0, 0, 0) P1=H(0, 1, 0, 0) rho_reply=H(1, 0, 0, 0)
PG43_FAIL_EXAMPLE 1 seed=A(2, 0, 0, 0) center=A(1, 0, 0, 0) P1=H(0, 1, 0, 0) rho_reply=H(1, 0, 0, 0)
PG43_FAIL_EXAMPLE 2 seed=A(0, 1, 0, 0) center=A(0, 2, 0, 0) P1=H(1, 0, 0, 0) rho_reply=H(0, 1, 0, 0)
```

## Interpretation

The plane result is a stronger negative than a fixed-heuristic failure: the verifier exhausts all
legal adaptive `h'` replies and all legal double-pencil exception replies under the primary
policy shape. At `q = 9` the failure is caused by exception asymmetry; at `q = 11,13` the failure
is an infinity-reply exhaustion after reflected affine play.

The `PG(4,3)` primary fixed-`rho` variant fails before the expensive reachable-position search:
the seed pair itself creates a dead H direction, and fixed `rho` lets P1 force that dead point as
P2's first H reply.

Next useful direction: do not try to prove this primary composite as stated. If the even-dimensional
route stays alive, it needs a seed rule that also protects `rho^{-1}(h0)` or a genuine reflection
tower/non-fixed-H policy; the simple point-reflection + fixed elliptic `rho` kernel is dead.
