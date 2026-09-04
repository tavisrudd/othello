# C1061 probe 28h: more context does not buy a commit, and the surface d=9 rows re-derived

**Lane**: `complete-ports` · **Date**: 2026-09-04 · **Code**: ergodis-private `ced13b7` (the matcher
after probe 28g's revert); generator `scripts/margin_radius_grid.sh`; evidence
`benchmarks/tiger-blossom/2026-09-04-probe28h-margin-radius-grid.txt` · **Continues**:
`2026-09-04-c1061-probe28c-blossom-expansion-and-tiger-behind-the-predecoder.md`, items 2 and 3 of
its next list.

Replay: `bash scripts/margin_radius_grid.sh ~/.cache/ergodis/bin/ergodis-tools-ced13b7 4096`
(binary SHA-256 `198fa1f7b91dcc747f909b288735b6c8ffc2c33ac9b68f85d54e0e2f1cc3cdb1`).

## Headline

**The certified margin predecoder is closed, and closed structurally rather than by sampling: at
the smallest sound margin the compiled policy contains no correction-commit entry at all, at every
radius that compiles.** Probe 28c set the gate as "continue only if a radius-3 or
observation-conditioned margin commits real weight at `Delta = 3`". Radius 3 compiles on the
repetition code — a twenty-bit ball, a one-megabyte table per position against radius 1's
sixty-four bytes — and commits exactly zero weight at `Delta = 3`, at both error rates and both
distances. The exhaustive compiled tables say why: over *every* ball syndrome, at radius 1, 2 and 3
and in both code families, a `Delta = 3` policy has two distinct decisions where a `Delta = 2`
policy has three. The missing third is the correction.

**Separately, the surface distance-9 rows invalidated by probe 28c's aliased check-support masks
are re-derived, and exactly one published row changes.** Probe 29's region-shape row for surface
`d = 9` at radius 2 was computed on the corrupted graph; the repaired row restores the saturation
pattern that probe 29's own text claims.

## Part one: does more local context ever commit?

### The margin cliff, measured

`margin-certificate-bench --mode pipeline`, 4,096 planted shots per cell, one line per (family,
distance, radius, margin, rate). `heavier` counts shots where the predecoder-then-kernel pipeline
weighs more than the kernel alone — the certificate failing — and `committed weight` is what the
sweep actually removes before the kernel runs.

| family     | d  | radius | p    | Δ=1 heavier / weight | Δ=2 heavier / weight | Δ=3 heavier / weight |
|------------|----|--------|------|----------------------|----------------------|----------------------|
| repetition | 9  | 1      | 0.01 | 1 / 354              | 0 / 255              | 0 / **0**            |
| repetition | 9  | 1      | 0.05 | 65 / 1,590           | 2 / 818              | 0 / **0**            |
| repetition | 9  | 2      | 0.01 | 0 / 348              | 0 / 271              | 0 / **0**            |
| repetition | 9  | 2      | 0.05 | 20 / 1,475           | 0 / 959              | 0 / **0**            |
| repetition | 9  | 3      | 0.01 | 0 / 357              | 0 / 276              | 0 / **0**            |
| repetition | 9  | 3      | 0.05 | 19 / 1,583           | 2 / 1,113            | 0 / **0**            |
| repetition | 15 | 3      | 0.01 | 0 / 614              | 0 / 527              | 0 / **0**            |
| repetition | 15 | 3      | 0.05 | 25 / 2,539           | 2 / 2,000            | 0 / **0**            |
| surface    | 5  | 2      | 0.05 | 39 / 1,312           | 0 / 366              | 0 / **0**            |
| surface    | 9  | 1      | 0.05 | 378 / 5,214          | 9 / 1,971            | 0 / **0**            |

The residual defect count equals the original at every `Delta = 3` cell, so the kernel receives the
whole syndrome and the sweep in front of it is pure overhead — probe 28c's finding at radius 1 and
2, now also at radius 3.

Two cautions on reading the zeros in the `Delta = 2` column. A zero at 4,096 shots is not
soundness: probe 28c measured 13 heavier shots over 65,536 at repetition `d = 9`, radius 2,
`p = 0.05`, the cell that reads 0 here. And the surface family stops at radius 1 for `d >= 7`
because its radius-2 ball is 28 bits, so its table would be 268 MB per commit position; those cells
are refused by the compile cap rather than measured.

### Why raising the radius cannot help

The pipeline census is sampled, but the compiled policy is not: `--mode compile` enumerates every
ball syndrome and reports how many distinct decisions the table holds. Three means defer, commit
the empty action, and commit a correction; two means the table has no correction entry anywhere.

| family     | radius | ball bits | table bytes | distinct at Δ=2 | distinct at Δ=3 |
|------------|--------|-----------|-------------|-----------------|-----------------|
| repetition | 1      | 6         | 64          | 3               | **2**           |
| repetition | 2      | 12        | 4,096       | 3               | **2**           |
| repetition | 3      | 20        | 1,048,576   | 3               | **2**           |
| surface    | 1      | 10        | 1,024       | 3               | **2**           |
| surface    | 2 (d=5)| 22        | 4,194,304   | 3               | **2**           |

Rows are the largest distance in each family that compiles at that radius; every distance from 5 up
gives the same width and the same counts, and the repetition `d = 3` and surface `d = 3` rows are
2 at both margins because the ball is the whole code.

So a sixteen-thousand-fold increase in the enumerated context — sixty-four bytes to a megabyte —
does not produce one ball syndrome whose local advantage exceeds 3 while carrying a nonzero action.
This is the exhaustive form of probe 30's guess that "a radius-1 ball expresses cost differences of
only 0, 1, 2, so margin 3 exceeds its dynamic range". The guess attributed the failure to the ball
being small. It is not: the ball's dynamic range grows with the radius and the correction still
never qualifies. What does not grow is the advantage a *correction* can have over its alternatives,
because a competing explanation of the same local defects differs from it by a bounded amount that
the surrounding context does not change.

### What that leaves

The gate fails, so probe 28c's instruction applies: treat the certified margin predecoder as a
measured negative and leave it. The observation-conditioned variant is not built, and the reason is
this measurement rather than budget — conditioning on the observable changes which syndromes the
policy considers, not the margin arithmetic that is refusing every correction.

The one direction the evidence does leave open, stated as a direction and not a claim: the whole
construction fails by exactly one unit. At `Delta = 2` the policy commits real weight and is wrong
on 0 to 9 shots in 4,096 at 5% error, and rarely enough at 1% error that this sample catches none
of it — probe 28c's 65,536-shot rows put it at 3 to 6 shots on the surface family there. Anything that
makes `Delta = 2` sound — a tighter soundness argument, or the module's existing `BoundedSafe`
tier used with a declared fault bound as part of a deployment contract rather than a proof —
recovers a predecoder that commits. Whether the residual failures are expressible as such a bound
is not measured here.

## Part two: the surface d=9 rows, re-derived

Probe 28c found that the rotated-surface-code builder's check-support masks were 32 bits wide while
distance 9 has 40 checks, so every distance-9 surface graph built before that fix aliased checks 32
to 39 onto 0 to 7, and it flagged every surface distance-9 number in probes 27, 29, 30 and 31 as
needing re-derivation. Re-run on the repaired graph:

| source                              | quantity                                   | published                        | repaired                          |
|-------------------------------------|--------------------------------------------|----------------------------------|-----------------------------------|
| probe 29 shape, surface d=9, r=1     | ball, interior, crossing, rank, contexts, entries | 10, 12, 28, 8, 256, 2,048  | identical                         |
| probe 29 shape, surface d=9, r=2     | the same six                               | 31, 45, 69, 21, 2.1e6, 4.3e9     | **28, 45, 60, 18, 262,144, 5.37e8** |
| probe 29 compile, surface d=9, r=1   | ball, table bytes, distinct, commit fraction | 10, 1,024, 1, 0.000            | identical                         |
| probe 30 compile, d=9, r=1, Δ=2      | ball, table bytes, distinct, commit fraction | 10, 1,024, 3, 0.188            | identical (0.188477)              |
| probe 30 coverage, d=9, r=1, Δ=2, p=0.01 | clean, committed, corrections          | 0.6763, 0.9692, 0.0043           | 0.6752, 0.9711, 0.0059            |
| probe 30 coverage, d=9, r=1, Δ=3, p=0.01 | clean, committed, corrections          | 0.6763, 0.8752, 0.0000           | 0.6752, 0.8768, 0.0000            |

Exactly one published row changes, and it is the only one whose ball reaches outside the aliased
region: at radius 1 the surface ball is 10 detectors and never touches a high-numbered check, so
every radius-1 quantity — all of them deterministic — is bit-for-bit what was published. The
radius-2 quantities are deterministic too and they do change. The coverage rows are Monte Carlo
over 20,000 shots and move in the third decimal, which is sampling; probe 28c has in any case
already withdrawn the coverage figures as coverage by unsound commits at `Delta = 2`.

The corrected row is also the more believable one. Probe 29's own text asserts that "at fixed
radius the ball width is independent of distance once the ball is in the bulk"; the corrupted row
broke that (31 bits at `d = 9` against 28 at `d = 7`) while the repaired row restores it, with the
same 28-bit ball and rank 18 as distance 7.

Probes 27 and 31 need no re-derivation. Probe 27's distance-9 tables are the repetition code (16
detectors in a `T = 2` window, 256 patterns per round), and its surface section is analytic. Probe
31's surface distance-9 statements are the probe 30 coverage figures, already withdrawn by probe
28c, and its distance-9 test assertion runs against the repaired graph in the current suite.

## Gates

The measurements are counts and compiled-table properties, not timings, so no interleaved A/B
applies. The pipeline arm asserts shot by shot that committed weight plus residual minimum equals
the kernel's minimum on the same shot, which is what the `heavier` and `lighter` columns report;
`lighter` is zero in every cell, the kernel's certificate holding. Every cell in the grid comes
from one generator run on one retained binary, recorded whole in the evidence file. The matcher
underneath is `ced13b7`, whose exactness against PyMatching on 360,000 shots is probe 28g's.

## Mystery ledger

- **Why the correction never qualifies at `Delta = 3`.** Settled empirically and exhaustively: no
  ball syndrome at any compiled radius commits a correction at that margin. The mechanism stated
  above — that a competing local explanation differs from a correction by a bounded amount
  independent of the surrounding context — is the reading of the data, not a proof. A short
  argument bounding the local advantage of a correction would turn this measured closure into a
  theorem and would say once and for all which margins can ever commit.
- **`Delta = 2` fails by so little.** Three to six heavier shots in 65,536 at 1% error (probe 28c)
  and 0 to 9 in 4,096 at 5%. Open: whether those failures live inside a declarable fault bound, which is the
  difference between the module's `ProvedSafe` and `BoundedSafe` tiers and the only route left to a
  predecoder that commits.
- **More radius commits more positions and no more weight.** The `Delta = 3` commit fraction over
  all ball syndromes rises with the radius on the repetition code (0.109 at radius 1, 0.150 at
  radius 2, 0.110 at radius 3 for `d = 9`) while the committed weight stays exactly zero and the
  residual defect count stays equal to the original in every cell. More context makes the policy
  more confident about doing nothing. Unexplained, and a hint about where the local cost structure
  saturates.
- **The surface radius-2 memory wall.** A 28-bit ball is 268 MB per commit position, so surface
  `d >= 7` is untestable above radius 1 by direct tabulation. Nothing here needs it, but any future
  surface predecoder does.

## Vibe check

Both halves closed cleanly and negatively, which is the useful kind. The predecoder is not a near
miss waiting on more context — the exhaustive tables say more context cannot help — and the graph
defect turned out to have moved exactly one published number.

## Next

The certified predecoder and the sparse matcher's `touch_node` are both closed as levers. What is
left in the matcher is `solve` at 27.5% of the profile, never attacked directly.
