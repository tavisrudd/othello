# C1023 — An effective threshold for cyclic-carrier deep holes

**Lane:** `gem-mining`
**Date:** 2026-08-31
**Status:** in progress (written incrementally)

Predecessor: `notes/2026-08-31-c1018-prs-deephole-conjecture.md` §7, whose
heuristic count this task is to make rigorous, and whose §5d fixed-locus lemma
supplies the structural setting.  Notation (`PRS_k(q)`, NRC rank `w(s)`,
persistent locus `P_r`, carrier stratum) is defined there and in
`notes/2026-08-30-c1018-hunt-prs-deepholes.md` §1, and is not restated.

Persona routing consulted: `notes/2026-07-07-named-expert-personas-context.md`
routes `papers/high_weight_grs_cosets/` to
`papers/expert-profiles/08-beyond-four-prs.md`, which was read in full and
nothing else.  Its hard-proof routing puts characteristic-aware polynomial
obstructions with Sziklai, normal-rational-curve normal forms with
Ball–Lavrauw, and covering-radius-to-deep-hole promotion with Wan–Kaipa; the
argument below is a Sziklai-shaped obstruction sitting on a Ball–Lavrauw normal
form, with the radius input imported rather than reproved.

## 0. Executive summary, stated before the details

The §7 heuristic, taken literally, **cannot** be made rigorous: it counts split
squarefree forms in the apolar space as if that space were a generic linear
subspace of the space of all binary forms, and for the cases that matter it is
not — it is contained in the multiples of the lower apolar generator.  That is
not a technical slip; it is the exact mechanism by which the persistent locus is
deep at *every* `q`, so any argument that survives it would prove something
false.  §2 replaces it.

What does work is a **torus-equivariant** count, which is available precisely
because a carrier point is an eigenvector of the order-`m` torus.  It collapses
the annihilation conditions from `d-j+1` to about `(d-j)/m + 1`, and it replaces
"split squarefree degree-`j` form" by "degree-`L` form with `L` distinct roots,
all `m`-th powers".  The resulting threshold is

```text
C_heur(r,m) = ( m^{M-1} · (M-1)! )^{1/(M-2)} ,        M = (r-3)/m + 1 ,
```

for the `a = b = 1` carriers, which is finite exactly when `M ≥ 3`.  Numerically
`C_heur(9,3) = 18` against an observed last-firing field of 13 and a clean
census from 16 up — the right constant to within the width of one field.

The rigorous version of that count carries a Weil error term, and the honest
outcome is stated up front:

* **It closes**, with an explicit constant, for carriers with `M ≥ 3`, i.e.
  `m ≤ (r-3)/2`, **conditional** on one geometric hypothesis (§4) that is
  verified computationally for the carriers in range but not proved in general.
* **It does not close at all** for `M = 2` — the two-index carriers, `deg G = 1`
  — where the solution space is a single point and there is no room to count.
  `(6,3)`, `(8,5)` and `(10,4)` are all of this type, so the mechanism that
  produces three of the six known carrier orbits is *outside* the reach of this
  argument. That is a structural failure, not a missing epsilon.
* The explicit constant is roughly `20 √q`-driven and lands near **400** for
  `(9,3)`, against a heuristic 18 and an observed 16.  So the theorem is
  rigorous and effective but around 25× too weak to be swept against.

**Consequence for the `r ≥ 11` hope, stated plainly:** the threshold does *not*
supply a usable substitute for the missing field-ranged theorem above `r = 10`.
It would require sweeping the carrier strata up to `q ≈ C`, and while the small
`m ≥ 3` strata are cheap enough for that, the `m = 2` stratum — which is the
order-two locus the fixed-locus lemma needs — has dimension growing like `r/2`
and is not sweepable to `q ≈ 400` at any `r ≥ 11`.  §6 states exactly what
would and would not close.

