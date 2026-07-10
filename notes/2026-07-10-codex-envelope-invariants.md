# C69 (promoted S1) — envelope / derived-curve invariants for the flipping configs

Date: 2026-07-10 (Claude).  Task: [`2026-07-07-codex-task-queue.md`](2026-07-07-codex-task-queue.md) §C69.
Promoted after C55 ([group-side](2026-07-09-codex-d-lattice-side-switch.md)) and C64
([extremal-side](2026-07-09-codex-completion-poset.md)) both reported NEGATIVE; this is the
algebraic-geometry-side mechanism candidate for the arc-depleted-orders dichotomy (119 configs
N@{11,17}, P@{13,19}).

## Verdict

**NEGATIVE.  No envelope / derived-curve invariant is a mechanism for the flip.**  With C55 and C64,
**all three configuration-level mechanism candidates for the dichotomy are now dead** (group /
extremal / algebraic).  The (ON) uniform route rests on the q-dependent A5 arc-depletion
arithmetic — *which* orders deplete and by how much — with no configuration-level mechanism.  No
q=23/q=25 flip prediction is emitted.

The one near-hit (a genus-2 point-count coincidence) is a small-field artifact of q=11 that
collapses at q=17 — the same failure shape C64's count-parity near-hit had.

## Part A — the naive tangent envelope is provably non-discriminating

Segre's literal tangent-envelope readings carry no order signal, and the script confirms it:

- **No 3 of the 6 tangents are ever concurrent** (`0/1716` concurrent triples over all finite conic
  params at q ∈ {11,13,17,19}).  The tangents at distinct conic points are the dual-conic points, no
  3 of which are collinear — general position at every q, by a Vandermonde determinant.
- The 6 tangents **envelope the dual conic**, which has `q+1` rational points at every q — constant.
- Every chord of the 6 points is a **secant** (both ends on C), so all 15 chord poles are external
  points — no internal/external split to read.

So an order-dependent envelope invariant can only live in the **arithmetic of a derived curve**.

## Part A2 — residual tangent/secant partition on off-conic points (all null)

The residual partition S1 names: for every off-conic rational point, how many of the 6 selected
tangents and 15 selected secants pass through it.  Every q-comparable feature of this partition
(occupied-bin count, max selected-secants through a point, #points on ≥3 selected secants and its
parity/mod-3/χ, #points on ≥1 selected secant, secant-hit defect) **fails** the verdict discipline —
none is constant-within-{11,17}/{13,19} and differs-across while separating flip from control.  The
only constant feature (`max selected-secants through a point = 5` for every config at every order) is
constant *everywhere*, so it differs across nothing.

### Residual-partition contingency tables (verbatim)

```text
-- feature: occupied incidence bins --
   flip    depleted dist={9: 36, 10: 64, 11: 11}  full dist={9: 51, 10: 46, 11: 14}
   control depleted dist={11: 18, 10: 10, 9: 19}  full dist={11: 10, 10: 30, 9: 7}  => VIABLE=False
-- feature: max selected-secants through a point --
   flip    depleted dist={5: 111}  full dist={5: 111}
   control depleted dist={5: 47}  full dist={5: 47}  => VIABLE=False
-- feature: # points on >=3 selected secants --
   flip    depleted dist={4: 39, 5: 56, 3: 10, 6: 6}  full dist={4: 46, 5: 36, 3: 13, 6: 11, 7: 4, 8: 1}
   control depleted dist={5: 7, 6: 15, 7: 13, 8: 4, 4: 6, 3: 2}  full dist={5: 25, 6: 4, 7: 5, 8: 2, 4: 10, 3: 1}  => VIABLE=False
-- feature: triple-point count parity --
   flip    depleted dist={0: 45, 1: 66}  full dist={0: 58, 1: 53}
   control depleted dist={1: 22, 0: 25}  full dist={1: 31, 0: 16}  => VIABLE=False
-- feature: triple-point count mod 3 --
   flip    depleted dist={1: 39, 2: 56, 0: 16}  full dist={1: 50, 2: 37, 0: 24}
   control depleted dist={2: 11, 0: 17, 1: 19}  full dist={2: 27, 0: 5, 1: 15}  => VIABLE=False
-- feature: chi_q(triple-point count) --
   flip    depleted dist={1: 44, -1: 67}  full dist={1: 89, -1: 22}
   control depleted dist={-1: 37, 1: 10}  full dist={1: 31, -1: 16}  => VIABLE=False
-- feature: secant-hit defect (#hit-15q) --
   flip    depleted dist={-56: 39, -55: 56, -57: 10, -54: 6}  full dist={-56: 46, -55: 36, -57: 13, -54: 11, -53: 4, -52: 1}
   control depleted dist={-55: 7, -54: 15, -53: 13, -52: 4, -56: 6, -57: 2}  full dist={-55: 25, -54: 4, -53: 5, -52: 2, -56: 10, -57: 1}  => VIABLE=False
-- feature: chi_q(secant-hit count) --
   flip    depleted dist={-1: 49, 1: 57, 0: 5}  full dist={1: 55, -1: 43, 0: 13}
   control depleted dist={1: 23, -1: 24}  full dist={-1: 18, 1: 27, 0: 2}  => VIABLE=False
```

## Part B — genus-2 hyperelliptic arithmetic of the 6 branch points

The derived curve is `y² = f(x)`, `f = ∏(x − r)` over the finite branch params `{0,t1,t2,t3,t4}`
(the 6th param ∞ is the branch point at infinity), a genus-2 curve.  Its character sum
`a2 = Σ_x χ(f(x))` and point count `#C(F_q) = q+1+a2` vary with q for FIXED integral params — the
degree of freedom C18's static 6-point χ dictionary lacked (`a2` is a global sum over the whole
line, not a count of `χ(t_i − t_j)`).

**Every pooled q-comparable feature of `a2` is null** (`sign`, `a2==0`, `|a2|`, parity, mod 3, mod 4,
`χ_q(a2)`, and the point-count analogues): none is constant-within-side and differs-across while
sparing controls.  (`a2 mod 4 = 0` and both parities are constant *everywhere* — the projective
genus-2 point count is even here — so they differ across nothing.)

### Pooled branch-curve contingency tables (verbatim)

```text
-- feature: sign(a2) --
   flip    depleted dist={-1: 40, 0: 35, 1: 36}  full dist={-1: 31, 1: 33, 0: 47}
   control depleted dist={-1: 13, 1: 5, 0: 29}   full dist={0: 34, 1: 3, -1: 10}  => VIABLE=False
-- feature: a2==0 --
   flip    depleted dist={False: 76, True: 35}  full dist={False: 64, True: 47}
   control depleted dist={False: 18, True: 29}  full dist={True: 34, False: 13}  => VIABLE=False
-- feature: abs(a2) --
   flip    depleted dist={4: 76, 0: 35}  full dist={4: 52, 8: 12, 0: 47}
   control depleted dist={4: 18, 0: 29}  full dist={0: 34, 8: 4, 4: 9}  => VIABLE=False
-- feature: a2 squared --
   flip    depleted dist={16: 76, 0: 35}  full dist={16: 52, 64: 12, 0: 47}
   control depleted dist={16: 18, 0: 29}  full dist={0: 34, 64: 4, 16: 9}  => VIABLE=False
-- feature: a2 parity / a2 mod 4 / #C(F_q) parity --
   flip    depleted dist={0: 111}  full dist={0: 111}
   control depleted dist={0: 47}  full dist={0: 47}  => VIABLE=False (all three)
-- feature: a2 mod 3 --
   flip    depleted dist={2: 40, 0: 35, 1: 36}  full dist={2: 37, 0: 47, 1: 27}
   control depleted dist={2: 13, 1: 5, 0: 29}  full dist={0: 34, 2: 8, 1: 5}  => VIABLE=False
-- feature: chi_q(a2), zero->0 --
   flip    depleted dist={1: 76, 0: 35}  full dist={-1: 33, 0: 47, 1: 31}
   control depleted dist={1: 12, 0: 29, -1: 6}  full dist={0: 34, -1: 5, 1: 8}  => VIABLE=False
-- feature: #C(F_q) mod 3 --
   flip    depleted dist={2: 40, 0: 35, 1: 36}  full dist={1: 37, 2: 47, 0: 27}
   control depleted dist={2: 13, 1: 5, 0: 29}  full dist={2: 34, 1: 8, 0: 5}  => VIABLE=False
```

### The near-hit, and why it is a q=11 small-field artifact

The minimal witness has a suggestive per-config side pattern:

```text
q=11 value=N  a2= 0  #C(F_q)=12
q=13 value=P  a2=-4  #C(F_q)=10
q=17 value=N  a2= 0  #C(F_q)=18
q=19 value=P  a2=-4  #C(F_q)=16
```

`a2 = 0 ⟺ N`, `a2 = -4 ⟺ P` — side-constant and side-differing.  Over configs present at all four
orders (only 21 survive the intersection), this pattern is exact for **both NPNP (double-flip)
configs** and fails for every other value-pattern:

```text
value-pattern NPNP: n= 2  a2 side-constant&differ= 2   a2-vectors (0,-4,0,-4), (0,-4,0,-4)
value-pattern NPPP: n= 4  a2 side-constant&differ= 0   e.g. (0,0,-4,0)   [a2=-4 at a P order]
value-pattern PPNP: n=13  a2 side-constant&differ= 0   e.g. (0,0,0,8),(0,-4,4,0)
value-pattern PPPP: n= 2  a2 side-constant&differ= 0   e.g. (-4,0,4,0)
```

The two NPNP configs are `{−4,−3,−2}` child 1 and `{1,2,4}` child 5 — genuinely distinct integral
configurations, so `(0,−4,0,−4)` is a real coincidence, not one orbit counted twice.  But it does
**not** generalize: for NPPP the same `a2=-4` value lands on a **P** order (q=17), and for PPNP/PPPP
`a2` is not even side-constant.  `a2` therefore does not determine the value.

The per-pair-cohort test (over the real 119, not just the all-four intersection) pins it as a
small-field artifact:

```text
pair 11/13 (depleted q=11 N-side -> full q=13 P-side)
   flip    n= 11  a2 changed across pair: 5/11
           a2@depleted(11) dist={0: 11}          <- all 11 N-flip configs are a2=0 at q=11
           a2@full(13)     dist={-4:4, 0:6, 4:1}
   control n= 17  a2 changed across pair: 11/17
           a2@depleted(11) dist={-4:6, 0:9, 4:2}

pair 17/19 (depleted q=17 N-side -> full q=19 P-side)
   flip    n=100  a2 changed across pair: 66/100
           a2@depleted(17) dist={-4:40, 0:24, 4:36}   <- NOT concentrated at 0
           a2@full(19)     dist={-8:3, -4:24, 0:41, 4:23, 8:9}
   control n= 30  a2 changed across pair: 17/30
           a2@depleted(17) dist={-4:7, 0:20, 4:3}
```

At q=11 all 11 N-flip configs have `a2 = 0` — but (i) it is **not sufficient** (9 of the 17 P-valued
controls also have `a2 = 0` at q=11), and (ii) it **does not hold at the other depleted order**: at
q=17 the N-flip configs have `a2 ∈ {−4,0,4}` spread across all three values, not concentrated at 0.
`a2 = 0` characterizing N is an accident of q=11's tiny Weil range (`|a2| ≤ 4√11 ≈ 13`, observed
values only `{−4,0,4}`).  And `a2` does not even change across the pair more for flips than controls
(11/13: 5/11 vs 11/17; 17/19: 66/100 vs 17/30).

## Part C — χ_q of derived integer resultants (Igusa-flavored, all null)

For each config the elementary-symmetric integers of the branch points (`e2`, `e4`), the branch
`Σ r²`, and the (square) Vandermonde `∏(r_i−r_j)²` are fixed integers; `χ_q` of each is q-comparable.
All fail the verdict discipline — none is constant-within-side and differs-across while sparing
controls.  (`χ_q(vandermonde_sq) = +1` wherever nonzero, as expected of a square — a correctness
check, non-discriminating.)

### Resultant contingency tables (verbatim)

```text
-- feature: chi_q(e2) --
   flip    depleted dist={1: 59, -1: 49, 0: 3}  full dist={-1: 49, 1: 58, 0: 4}
   control depleted dist={-1: 16, 1: 24, 0: 7}  full dist={1: 21, -1: 22, 0: 4}  => VIABLE=False
-- feature: chi_q(e4) --
   flip    depleted dist={-1: 62, 1: 49}  full dist={1: 52, -1: 59}
   control depleted dist={-1: 18, 1: 29}  full dist={-1: 21, 1: 26}  => VIABLE=False
-- feature: chi_q(sum_sq) --
   flip    depleted dist={1: 45, -1: 62, 0: 4}  full dist={-1: 53, 1: 55, 0: 3}
   control depleted dist={1: 20, -1: 22, 0: 5}  full dist={-1: 27, 1: 17, 0: 3}  => VIABLE=False
-- feature: chi_q(vandermonde_sq) --
   flip    depleted dist={1: 111}  full dist={1: 111}
   control depleted dist={1: 47}  full dist={1: 47}  => VIABLE=False
```

## Interpretation

The dichotomy has resisted, in order: static 6-subset features (C18), the group-side d-lattice
side-switch (C55), the extremal completion poset (C64), and now the algebraic envelope / genus-2
arithmetic (C69).  The recurring failure shape is instructive: each candidate produces a **clean
signal at q=11 that collapses at q=17** (C64: completion-count parity; C69: `a2 = 0`).  q=11 is the
smallest arc-depleted order and its invariants have tiny ranges, so a two- or three-valued invariant
lands "by luck" on the value at q=11 and disperses once q grows.  The value is genuinely a property
of the full game tree at each q (C64's `has_odd=has_even=True` finding), and the *fact* of depletion
is q-arithmetic (A5), not configuration-geometric.

## Consequence for the program

All three configuration-level dichotomy mechanisms are dead.  The (ON) uniform lower bound cannot be
discharged by a config→value dictionary of any of the tested kinds; it must engage the q-dependent
arc-depletion arithmetic (A5) directly — the number-theoretically irregular "which orders deplete,
by how much" quantity, exactly what the witness-count / erratic-margin notes already isolate.  Sweep
S1 is now spent; no fourth configuration-level mechanism candidate is queued.

## Reproduce

```bash
python3 rust/scripts/c69_envelope.py     # parts A, A2, B, C, D (gate + all verdicts)
```

Parts A (tangent triviality) and A2 (residual partition) run first; B/C are the pooled arithmetic
verdicts; D is the per-config all-four-orders side pattern.  The per-pair-cohort tracking table
(Part E above) is reproducible from the same `a2_trace` / `signed_roots_of_key` helpers.
