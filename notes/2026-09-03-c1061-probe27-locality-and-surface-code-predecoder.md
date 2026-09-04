# C1061 probe 27: spatial locality, and the predecoder on the rotated surface code

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 27, continuing `notes/2026-09-03-c1061-probe23-context-certified-predecoder.md`.

Two parts. **(A)** The spatial locality argument probe 23 named as its highest-value follow-on:
prove and test that a defect farther than radius `r` from the commit region cannot change the commit
decision, so enumeration becomes `2^neighbourhood` instead of `2^((d-1)T)`, then compile the `T = 4`
and `T = 6` tiers at distance 7 and 9. **(B)** Redo the whole probe-23 pipeline on the rotated
surface code, which is the brief's actual target, and say plainly how the two-dimensional boundary
changes the picture.

Status: in progress; part B's surface census is still running.

## Part A — the spatial locality argument is false, and the measurement says exactly why

### What was tested

The decision function is tabulated over **every** syndrome of a window, and each detector is then
tested for influence: if flipping detector `(round, column)` never changes the decision, the policy
does not depend on it and factors through the rest. The largest influential column is the spatial
dependency radius, and `factors_through` re-checks that the decision really is constant on each
class of syndromes agreeing inside that radius — measured, not inferred.

### Result

Proved-only policy, commit region one round:

| `d` | `T` | detectors | influential | influential per round | influential columns | **radius** | full enumeration | neighbourhood enumeration | reduction |
|---|---|---|---|---|---|---|---|---|---|
| 3 | 2 | 4 | 2 | [2, 0] | 0, 1 | 1 | 2^4 | 2^4 | **none** |
| 3 | 4 | 8 | 5 | [2, 2, 1, 0] | 0, 1 | 1 | 2^8 | 2^8 | **none** |
| 3 | 6 | 12 | 9 | [2, 2, 2, 2, 1, 0] | 0, 1 | 1 | 2^12 | 2^12 | **none** |
| 5 | 2 | 8 | 4 | [4, 0] | 0–3 | 3 | 2^8 | 2^8 | **none** |
| 5 | 4 | 16 | 12 | [4, 4, 4, 0] | 0–3 | 3 | 2^16 | 2^16 | **none** |
| 7 | 2 | 12 | 6 | [6, 0] | 0–5 | 5 | 2^12 | 2^12 | **none** |
| 7 | 3 | 18 | 12 | [6, 6, 0] | 0–5 | 5 | 2^18 | 2^18 | **none** |
| 9 | 2 | 16 | 8 | [8, 0] | 0–7 | 7 | 2^16 | 2^16 | **none** |

**Every spatial column is influential at every distance.** The radius is always the full code width,
so the neighbourhood is the whole window and the enumeration is not reduced at all. The hoped-for
`2^neighbourhood` does not exist.

### Why, and it is not an artifact

The committed quantity is the **logical parity** contributed by the commit region, and the logical
operator spans the entire code. A defect at the far edge changes which side of the code a correction
chain runs down, and that flips the logical parity. So the commit decision is inherently spatially
global: there is no radius beyond which a defect is irrelevant, because the thing being decided is
itself a global observable. Any locality argument would have to be about a *different* committed
quantity — a local correction rather than a logical parity.

**Temporal structure does survive.** The final round is never influential at any distance
(`influential per round` always ends in 0), which is exactly right: the last round's detectors only
move the seam state, and the certificate already quantifies over every seam. At `d = 3` the
second-to-last round is only half influential. That is real structure, but it saves one round of
enumeration, not an exponent.

### The fallback route, and how far it gets

If the decision cannot be localized spatially, the other way to avoid enumerating `2^((d-1)T)`
syndromes is to enumerate the analysis's own **reachable normalized states**. The analysis carries
two min-plus vectors over the `W` boundary states, one per commit parity; adding a constant to both
changes no argmin, so the normalized pair is a sufficient statistic for every future round. Closure
exploration over that set compiles the policy without touching the syndrome space.

| `d` | `T` | patterns per round | reachable states per depth | syndrome enumeration | outcome |
|---|---|---|---|---|---|
| 3 | 6 | 4 | 4, 16, 56, 190, 506, **832** | 2^12 = 4,096 | 4.9x smaller |
| 5 | 4 | 16 | 16, 256, 2800, **19,252** | 2^16 = 65,536 | 3.4x smaller |
| 5 | 6 | 16 | 16, 256, 2800, 19252, 72264, **150,820** | 2^24 = 16,777,216 | **111x smaller** |
| 7 | 4 | 64 | 64, 4096, 121824, **capped at 200,000** | 2^24 = 16,777,216 | **infeasible** |
| 9 | 4 | 256 | — | 2^32 | **infeasible** |

**The route works at distance 5 and dies at distance 7.** It makes `T = 6` at `d = 5` compilable —
150,820 states against 16.7 million syndromes — but at `d = 7` the state count is already 121,824 at
depth 3 and growing about 30x per round, so depth 4 would be several million states of 1 KB each.
At `d = 9` a state is 4 KB and the growth is worse.

### Consequence for the predicted speedup

Probe 23 predicted that compiling `T = 4` and `T = 6` at distance 7 would take the defer rate from
6.3% to 0.08% and the composed speedup from 10.2x to roughly 28x. **That is not achievable by either
route measured here.** Where the deeper tiers *can* now be compiled — distance 5 — they barely
matter: the `T = 2, 4` cascade already defers only 1 shot in 2,000 at 1% error, so adding `T = 6`
moves the composed speedup from 13.8x to about 13.9x. The tiers are compilable exactly where they
are not needed, and needed exactly where they are not compilable.

That is the honest state of route 1's scaling story, and it is a harder constraint than probe 23
suggested.

*(part B to follow)*

## Part B — the rotated surface code

### Building it, and the one thing that had to change

The repetition code is one-dimensional: its check matrix has a one-dimensional kernel, so the
minimum-weight error consistent with a round's syndrome is *forced* and probe 23's leaf transfer
matrix was closed form. The rotated surface code's one-basis check matrix has kernel dimension
`(d^2+1)/2`, so there is no closed form.

What the leaf needs is `min_weight[y][c]`: the least number of single-qubit errors in one round with
syndrome `y` and logical class `c`. That is a shortest-path problem in the abelian group
`F_2^m x F_2` with one unit-weight generator per data qubit, so **a breadth-first search from the
identity compiles the whole table once** and every leaf thereafter is a table lookup. The
certificate, the tier cascade and the automaton minimization then carry over unchanged: only the
leaf changed.

Gates, all passing (8 tests):

| Gate | What it establishes |
|---|---|
| `the_code_has_the_right_shape_and_a_commuting_logical` | `(d^2-1)/2` checks; every check touches an even number of qubits on the logical operator; the logical is a nontrivial cycle (zero syndrome, flips the class) |
| `the_metric_closure_matches_brute_force_at_distance_three` | the BFS table equals exhaustive enumeration over all `2^9` single-round error patterns, state by state |
| `every_syndrome_and_class_is_reachable` | the metric is finite everywhere at `d = 3` and `d = 5` |
| `a_certified_surface_commit_preserves_the_minimum_weight` | **exhaustive**: over every syndrome of a two-round window at `d = 3`, a certified commit never raises the achievable minimum weight, brute-forced over every data and measurement pattern |
| `the_matrix_free_analysis_agrees_with_the_materialized_one` | the two implementations agree on both class costs, the floor and the reachable count over 500 histories and both commit sizes |

**The certificate transfers to two dimensions.** That is the main positive result of part B: the
splicing argument and its exhaustive verification are not artifacts of the repetition code.

### How the two-dimensional boundary changes the picture

Plainly: it makes the boundary alphabet explode, and that is the whole story.

| `d` | qubits | checks in one basis | **boundary width `2^(m+1)`** | repetition-code width at the same distance | dense leaf matrix |
|---|---|---|---|---|---|
| 3 | 9 | 4 | **32** | 8 | 4 KB |
| 5 | 25 | 12 | **8,192** | 32 | **268 MB** |
| 7 | 49 | 24 | **2^25** | 128 | ~4.5 PB |

The repetition code's width is `2^d`, linear in the exponent. The surface code's is `2^((d^2-1)/2 + 1)`,
**quadratic in the exponent**. At distance 5 the dense leaf transfer matrix is 268 MB, and the first
attempt to materialize it overflowed the stack — an unambiguous, measured wall.

The repair is to never materialize it: every entry is a lookup into the compiled metric, so the
forward sweep computes entries on the fly at `O(W^2)` work and `O(W)` memory. That turns distance 5
from impossible into merely slow, about 4 seconds per shot at `T = 6`. **Distance 7 is out of reach
by any variant of this representation**: the boundary alphabet alone is `2^25`.

The metric closure itself is small and stays small — 32 states at `d = 3`, 8,192 at `d = 5`, with
diameters 4 and 9 — so the *leaf* compilation is not the problem. The problem is entirely the
boundary the leaves are composed over.

### Coverage

Certified coverage, commit region one round, bounded slack 2. Distance 3 uses 2,000 shots; distance
5 uses 40, because each shot costs about 4 seconds at width 8,192 — those rows are indicative, not
tight.

| rate | `T` | `d` | shots | clean syndrome | proved | bounded | ambiguous | forced |
|---|---|---|---|---|---|---|---|---|
| 0.001 | 2 | 3 | 2,000 | 0.9715 | 0.9965 | 0.0000 | 0.0035 | 0.9965 |
| 0.001 | 2 | 5 | 40 | 0.8500 | 1.0000 | 0.0000 | 0.0000 | 1.0000 |
| 0.001 | 4 | 3 | 2,000 | 0.9505 | 1.0000 | 0.0000 | 0.0000 | 1.0000 |
| 0.001 | 6 | 3 | 2,000 | 0.9375 | 1.0000 | 0.0000 | 0.0000 | 1.0000 |
| 0.005 | 2 | 3 | 2,000 | 0.8825 | 0.9815 | 0.0000 | 0.0185 | 0.9815 |
| 0.005 | 2 | 5 | 40 | 0.6250 | 0.9750 | 0.0250 | 0.0000 | 0.9750 |
| 0.005 | 4 | 3 | 2,000 | 0.8115 | 1.0000 | 0.0000 | 0.0000 | 1.0000 |
| 0.005 | 6 | 3 | 2,000 | 0.7185 | 1.0000 | 0.0000 | 0.0000 | 1.0000 |
| 0.005 | 6 | 5 | 40 | 0.3750 | 1.0000 | 0.0000 | 0.0000 | 1.0000 |
| 0.01 | 2 | 3 | 2,000 | 0.7965 | 0.9740 | 0.0000 | 0.0260 | 0.9740 |
| 0.01 | 2 | 5 | 40 | 0.5750 | 0.9500 | 0.0250 | 0.0250 | 0.9500 |
| 0.01 | 4 | 3 | 2,000 | 0.6265 | 0.9995 | 0.0000 | 0.0005 | 0.9995 |
| 0.01 | 4 | 5 | 40 | 0.3250 | 1.0000 | 0.0000 | 0.0000 | 1.0000 |
| 0.01 | 6 | 3 | 2,000 | 0.4965 | 1.0000 | 0.0000 | 0.0000 | 0.9990 |
| 0.01 | 6 | 5 | 40 | 0.1500 | 1.0000 | 0.0000 | 0.0000 | 1.0000 |
| 0.02 | 2 | 3 | 2,000 | 0.6360 | 0.9380 | 0.0015 | 0.0605 | 0.9380 |

**Coverage behaves exactly as it did on the repetition code**: it rises steeply with lookahead
(97.4% at `T = 2` to 100.0% at `T = 6` at distance 3 and 1% error), falls with error rate, and the
`forced` column tracks `proved`, so commits carry information rather than being "either action
works". At `d = 5`, `T = 6`, 1% error only 15% of windows have a clean syndrome yet all 40 sampled
are certified.

So the *certificate* works just as well in two dimensions. What does not carry over is the
compilation.

### Compilation: the part that does not survive

| | repetition code | rotated surface code |
|---|---|---|
| detector patterns per round | `2^(d-1)`: 4 at `d=3`, 256 at `d=9` | `2^((d^2-1)/2)`: 16 at `d=3`, **4,096** at `d=5` |
| syndromes in a `T = 2` window | 65,536 at `d = 9` | 256 at `d=3`, **16,777,216** at `d=5` |
| syndromes in a `T = 4` window | `2^32` at `d = 9` | 65,536 at `d=3`, `2^48` at `d=5` |
| compiled automaton (probe 23) | 6 states, 6,150 bytes at `d = 9, T = 2` | feasible at `d = 3` only |

Probe 23's headline — a distance-9 policy as a six-state automaton — depended on enumerating 65,536
syndromes. On the surface code the same window at distance 5 has 16.7 million syndromes, and at
`T = 4` it has `2^48`. **The compiled-LUT result does not transfer past distance 3**, and part A
showed that neither spatial locality nor reachable-state closure rescues it.

Two further rows at the high end, from the completed rerun (distance 5 at `n = 12` there):

| rate | `T` | `d` | shots | clean | proved | bounded | ambiguous |
|---|---|---|---|---|---|---|---|
| 0.05 | 2 | 3 | 2,000 | 0.3335 | 0.8640 | 0.0050 | 0.1310 |
| 0.05 | 4 | 3 | 2,000 | 0.1030 | 0.9910 | 0.0005 | 0.0085 |
| 0.05 | 6 | 3 | 2,000 | 0.0375 | 0.9985 | 0.0000 | 0.0015 |
| 0.05 | 6 | 5 | 12 | 0.0000 | 1.0000 | 0.0000 | 0.0000 |

At 5% error and `T = 6`, distance 3 certifies 99.85% of windows while only 3.75% have a clean
syndrome, and distance 5 certifies every sampled window with *none* clean. The certificate is doing
real work on defect-carrying two-dimensional syndromes.

### The surface tier cascade

Proved-only, commit one round. Distance 3 uses 2,000 shots; distance 5 uses 12 and is indicative.

| rate | `d` | settled at `T=2` | at `T=4` | at `T=6` | deferred to the strong decoder |
|---|---|---|---|---|---|
| 0.001 | 3 | 0.99800 | 0.00200 | 0.00000 | **0.00000** |
| 0.005 | 3 | 0.98900 | 0.01100 | 0.00000 | **0.00000** |
| 0.01 | 3 | 0.97050 | 0.02800 | 0.00150 | **0.00000** |
| 0.02 | 3 | 0.94150 | 0.05450 | 0.00400 | **0.00000** |
| 0.05 | 3 | 0.86500 | 0.12700 | 0.00600 | **0.00200** |
| 0.01 | 5 | 0.91667 | 0.08333 | 0.00000 | **0.00000** |
| 0.05 | 5 | 0.75000 | 0.25000 | 0.00000 | **0.00000** |

**The cascade behaves on the surface code exactly as it did on the repetition code**: the strong
decoder sees nothing at all up to 2% error at distance 3, and 1 shot in 500 at 5%. The certificate's
*coverage* story transfers in full.

## Verdict

**Part A: the spatial locality argument is false, measured, with a clear reason.** Every spatial
column influences the commit decision at every distance tested, because the committed quantity is a
logical parity and the logical operator spans the code. The enumeration cannot be reduced to a
neighbourhood. The fallback — closure over reachable normalized states — gives a real 111x reduction
at distance 5 but dies at distance 7, so the `T = 4` and `T = 6` tiers at distance 7 and 9 remain
uncompilable and probe 23's predicted 28x is not reachable by this route. The tiers compile where
they are not needed and do not compile where they are.

**Part B: the certificate transfers to the surface code; the compilation does not.** The safety
argument, the exhaustive brute-force verification, the coverage curve and the tier behaviour all
carry over intact once the leaf is a compiled metric closure instead of a closed form. But the
boundary alphabet goes from `2^d` to `2^((d^2+1)/2)`, which is 268 MB of dense leaf matrix at
distance 5 and `2^25` wide at distance 7, so the compiled-automaton result stops at distance 3.

Taken together the two parts say the same thing from different directions: **route 1's certificate is
sound and general, and route 1's compilation is bounded by an exponential the certificate does not
control.** The next move is not another compilation trick against `2^boundary`; it is to change what
is committed — a local correction rather than a global logical parity — so that the decision has a
locality to exploit in the first place.

## Mystery ledger

- **The last round is never influential, at any distance or window height.** Clean, expected, and it
  gives one free round of enumeration. Worth remembering if the enumeration ever becomes the binding
  constraint again by a factor of `2^(d-1)`.
- **The reachable-state count grows about 30x per round at `d = 7`** but only about 7x at `d = 5`.
  The growth rate itself scales with the pattern alphabet, which is why the route dies so sharply.
  Not characterized beyond the measured counts.
- **Distance-5 surface rows are `n = 40`.** They are consistent with the distance-3 trend and with
  the repetition-code behaviour, but they are indicative. The four-second-per-shot cost is itself the
  measurement that matters.
- **Why six states at `d = 9` in probe 23, if every column is influential?** Part A resolves the
  apparent paradox: the decision depends on all detectors but only through a very coarse function of
  them. Characterizing *that* function — not localizing it — is what would unlock deeper tiers, and
  it is still uncharacterized.

## Files

- `/home/tavis/src/ergodis-private/src/certified_predecoder.rs` — `DecisionTable` (influence and
  radius), `reachable_states` (closure compilation), `analyze_leaves` (shared certificate).
- `/home/tavis/src/ergodis-private/src/surface_predecoder.rs` — the rotated surface code, its
  compiled metric closure, the matrix-free analysis, coverage and tiers.
- `/home/tavis/src/ergodis-private/tasks/tools/src/certified_predecoder_bench.rs` — `locality-census`,
  `reachable-census`.
- `/home/tavis/src/ergodis-private/tasks/tools/src/surface_predecoder_bench.rs` — `shape`,
  `coverage`, `tiers`.

Committed as `afd9e54` (pathspec form). All tests pass; `cargo clippy -p ergodis-private --lib` is
clean on my files (the remaining workspace errors are in the concurrent TigerBlossom agent's
`tiger_blossom.rs`).

## Log addendum, 2026-09-03: commit provenance

Code for this probe is in ergodis-private `fe4d6a3`, `9e64308`, `afd9e54`, `130b0fa`, `b7e7c6d`;
26 tests across four modules.
