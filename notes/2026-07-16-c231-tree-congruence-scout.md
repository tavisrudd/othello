# C231 tail: bounded scalar-message congruence scout

**Lane:** `rp-next`
**Status:** PASSED PRE-ALLOCATION GATE. On the exhaustive simple binary pointed catalog inside
`PG(2,2)`, the one-step scalar-response signature is already the minimal behavioral congruence for
the seed/core/depth count profile. This is bounded evidence for C232, not an unbounded tree-of-2-sums
theorem.

## Candidate finite state

Fix a locality radius `r` and write

```text
Q_r = {0,1,...,r,infinity},
```

where all interface costs above `r` are identified with `infinity`. A state `x=(M,p,A)` consists of
a pointed component and its current active private set. Its observable output is

```text
o(x) = (|E(M)-p|, |A|, beta_r(A)),
```

and its transition under an incoming interface cost `q` is C231's local update

```text
delta_q(A) = A union {
  e : iota_e(A) <= r or alpha_e(A) + q <= r
}.
```

The proposed signature is the first Moore refinement

```text
sigma_1(x) = (o(x), (o(delta_q(x)))_(q in Q_r)).
```

The private ground size is retained because the terminal core size is ground size minus active
count. The sequence of active counts recovers the synchronous depth histogram, while `beta_r` is
exactly the message seen by a neighboring component.

The decisive gate is not merely signature collision-freedom. It is transition congruence:

```text
sigma_1(x) = sigma_1(y)
  implies sigma_1(delta_q(x)) = sigma_1(delta_q(y)) for every q in Q_r.
```

If this holds, equal-signature states have the same output under every input word. Since a 2-sum
partner supplies precisely such an input word through its own `beta_r` outputs, replacement by an
equal-signature state preserves both sides' active-count/message traces and hence the combined
seed/core/depth count profile.

## Exhaustive bounded gate

[`2026-07-16-c231-tree-congruence-scout.py`](2026-07-16-c231-tree-congruence-scout.py) enumerates
every simple binary pointed restriction with fixed interface column `1`, distinct private columns
chosen from the other six nonzero vectors of `GF(2)^3`, private size two through six, and the
interface non-coloop. This gives 41 represented components and all 636 component/seed states:

| private size | components | seed states |
| ---: | ---: | ---: |
| 2 | 3 | 12 |
| 3 | 16 | 128 |
| 4 | 15 | 240 |
| 5 | 6 | 192 |
| 6 | 1 | 64 |

For each radius, the script compares three partitions: output alone, `sigma_1`, and the stable
Moore partition obtained by repeated transition refinement.

| `r` | output classes | output violations | `sigma_1` classes | further refinements | partner replays |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 25 | 302 | 40 | 0 | 379,056 |
| 2 | 33 | 226 | 47 | 0 | 374,604 |
| 3 | 36 | 162 | 45 | 0 | 375,876 |
| 4 | 36 | 162 | 45 | 0 | 375,876 |
| 5 | 36 | 162 | 45 | 0 | 375,876 |

Thus `sigma_1` is a transition congruence at every checked radius and equals the minimal behavioral
partition on this catalog. It compresses 636 represented seed states to 40--47 behavior classes.
The independent contextual replay compares every nonrepresentative state in each `sigma_1` class
against every one of the 636 partner states: all 1,881,288 comparisons have identical two-sided
count/message traces.

The coarser output-only state is decisively insufficient. At `r=3`, for example, the represented
component with columns `(1,2,3,4)` has singleton active sets `{1}` and `{3}` with the same output
`(3,1,infinity)`. Pair either with the fully active `(1,2,3)` component, whose outgoing cost is two:
`{1}` grows to a two-element state with outgoing cost two, whereas `{3}` does not grow. The response
table in `sigma_1` separates them. Actual bounded partners expose output-only collisions for radii
two through five; at radius one the output partition survives all catalog partners despite failing
the stronger arbitrary-input transition gate.

The machine-readable certificate is
[`2026-07-16-c231-tree-congruence-scout.json`](2026-07-16-c231-tree-congruence-scout.json).

## Boundary and disposition

This scout proves a finite statement about the enumerated one-interface catalog. It does **not**
yet prove that one refinement suffices for arbitrary represented matroids, remove the explicit
private-size observable, or handle a decomposition node with several virtual gluing coordinates.
Those are exactly the points at which a genuine tree-of-2-sums transfer theorem can fail.

The gate nevertheless passes strongly enough to allocate C232. The next task is to define the
multi-interface transition system, prove contextual replacement for a decomposition tree, and then
either prove a radius/width-bounded finite transfer algebra or exhibit the first family forcing
unbounded refinement or state growth. No algorithmic or fixed-parameter claim is made before that
theorem-level boundary is settled.
