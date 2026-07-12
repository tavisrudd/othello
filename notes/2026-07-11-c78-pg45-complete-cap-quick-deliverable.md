# C78 — `PG(4,5)` complete-cap quick deliverable

**Date:** 2026-07-11
**Status:** REPORTED — secant-cover lower bound Lean-checked; exact orbit census closed through
size 6 and bounded size-7 probe measured.

## Result

Every complete cap `C` in `PG(4,5)` has at least 21 points.  The proof is the elementary
secant-cover count:

```text
|PG(4,5)| = (5^5 - 1)/(5 - 1) = 781.

A k-cap has choose(k,2) distinct secants.
Each secant contains 5+1 points, hence at most 4 points outside the cap.
Completeness gives 781 - k <= 4 choose(k,2), equivalently 781 <= 2k^2-k.
At k=20 the right side is 780, so k >= 21.
```

This is only a lower bound, not an exact determination of `t₂(4,5)`.

## Lean artifact

New module: `lean/ProjectiveCap/CompleteCapLowerBound.lean`, imported by
`lean/ProjectiveCap.lean`.

- `card_le_card_add_mul_choose_two`: the general finite pair-cover theorem
  `|X| <= |S| + r * choose(|S|,2)`.
- `card_ge_21_of_pg45_pair_cover`: the checked `781`-point, four-points-per-pair numerical
  specialization.
- `pg45_point_card`: checks directly from mathlib's projectivization cardinality theorem that
  `Nat.card PG(4,5) = 781` over `ZMod 5`.

The module deliberately separates the counting kernel from the projective adapter.  The two
adapter hypotheses say that every outside point is on a selected secant and that each secant's
outside-point fiber has cardinality at most four.  Those are exactly completeness and the
six-points-per-projective-line fact; their one-paragraph mathematical proof is above.  Formalizing
the general line-cardinality adapter is not needed for the numerical counting kernel and remains a
small independent Lean cleanup, not an unreported assumption in the mathematics.

Validation:

```text
$ choom -n 1000 -- nix develop --command lake build ProjectiveCap.CompleteCapLowerBound
✔ [2989/2989] Built ProjectiveCap.CompleteCapLowerBound (1.4s)
Build completed successfully (2989 jobs).
```

## Exact early-orbit sizing

New probe: `rust/src/bin/c78_pg45_orbit_probe.rs`.

It uses:

- the honest 781-point `PG(4,5)` board;
- a 13-word (`[u64; 13]`) point mask;
- exhaustive frame canonicalization with a torus fallback, so the completed layer counts are
  exact `PGL(5,5)` orbit counts, not hashes or heuristic classes;
- hyperplane-intersection spectra only as a sound pre-bucket;
- wall checks within the child loop; and
- terminal-orbit counts while expanding each completed parent layer.

The older Python wide-integer probe independently returned
`[1,1,1,1,2,4]` through size 5, then failed to honor its nominal wall inside the size-6
factorial canon.  It was interrupted.  The compiled probe reproduces those layers and closes the
next one:

```text
$ target/release/c78_pg45_orbit_probe 6 120
board=PG(4,5) points=781 words=13 build_s=0.077
orbits_2=1 parent_terminal_orbits=0 elapsed_s=0.001
orbits_3=1 parent_terminal_orbits=0 elapsed_s=0.003
orbits_4=2 parent_terminal_orbits=0 elapsed_s=0.005
orbits_5=4 parent_terminal_orbits=0 elapsed_s=0.552
orbits_6=10 parent_terminal_orbits=0 elapsed_s=42.087
PG45_ORBIT_RESULT counts=[1, 1, 1, 1, 2, 4, 10] timed_out=false elapsed_s=42.087
```

The bounded next-layer run stopped cleanly:

```text
$ target/release/c78_pg45_orbit_probe 7 120
...
orbits_6=10 parent_terminal_orbits=0 elapsed_s=42.421
cutoff_during_size=7 elapsed_s=120.023
PG45_ORBIT_RESULT counts=[1, 1, 1, 1, 2, 4, 10] timed_out=true elapsed_s=120.023
```

Interpretation: board representation is no longer an obstacle, and orbit growth is still tiny
through size 6.  Exact frame canonicalization, rather than memory or orbit count, is already the
measured bottleneck at size 7.  The next engineering lever is stabilizer-aware orderly generation
or a faster exact canonical labeling path.  Extrapolating the current factorial canon to sizes near
21 would not be evidence for feasibility.

## Rust validation

```text
$ make release
Finished `release` profile [optimized] target(s) in 1m 05s

$ make clippy
Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.15s

$ make test
exit=0 time=3min 35sec
```

## Verdict

The quick deliverable is complete:

1. the universal lower bound `t₂(4,5) >= 21` is proved and its counting kernel is Lean-checked;
2. the exact early `PGL(5,5)` orbit curve is measured through size 6 as
   `[1,1,1,1,2,4,10]`; and
3. the 120-second size-7 cutoff localizes the first scaling issue to exact canonicalization.

This does not establish the exact value of `t₂(4,5)`.
