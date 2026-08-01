# C740 — residual LP(333) multiplier orbit-lock census

**Lane:** `gem-mining`
**Date:** 2026-07-31
**Verdict:** residual stable subgroup ID 2 `<112>` is impossible by the same
shift-111 orbit lock that closed C738.  The screen is exact for all six residual
IDs `0,1,2,3,4,5`; the criterion does not exclude IDs `0,1,3,4,5`.  The fixed
common-multiplier census therefore advances from 24/30 to 25/30 impossible.
This does not exclude unrestricted Legendre pairs of length 333 or Hadamard
matrices of order 668.

## Exact criterion

For a multiplier subgroup `H` and nonzero shift `s`, let `L_H(s)` be the number
of positions `x` for which `x` and `x+s` lie in the same `H`-orbit.  Every
`H`-invariant sign sequence is equal at those positions, so

```text
D_u(s) <= 333 - L_H(s).
```

A Legendre pair must have joint Hamming distance 334 at every nonzero shift.
Thus one shift excludes `H` whenever

```text
2*(333-L_H(s)) < 334,
```

equivalently whenever `L_H(s) >= 167`.

The complete six-case census is:

| ID | subgroup | orbit sizes | spectrum `locked: shifts` | maximum | joint Hamming upper bound | result |
|---:|---|---|---|---:|---:|---|
| 0 | `{1}` | `1^333` | `0:332` | 0 | 666 | not excluded |
| 1 | `{1,73}` | `1^9 2^162` | `0:296, 9:36` | 9 | 648 | not excluded |
| 2 | `{1,112,223}` | `1^111 3^74` | `0:330, 222:2` | **222** at 111,222 | **222** | **excluded** |
| 3 | `{1,10,100}` | `1^9 3^108` | `0:296, 18:36` | 18 | 630 | not excluded |
| 4 | `{1,121,322}` | `1^3 3^110` | `0:222, 6:110` | 6 | 654 | not excluded |
| 5 | `{1,211,232}` | `1^3 3^110` | `0:222, 6:110` | 6 | 654 | not excluded |

`NOT_EXCLUDED` is only a statement about this orbit-lock criterion.  It is not
a compressed witness, an orbit-level solution, or evidence that a Legendre
pair exists.

## ID 2 obstruction

The C738 proof did not actually use multiplier 73.  For all `x=1 (mod 3)`,

```text
112*x = x+111 (mod 333),
```

and for all `x=2 (mod 3)`,

```text
223*x = x+111 (mod 333).
```

Both multipliers already lie in ID 2, `H={1,112,223}`.  Hence every ID-2
invariant sequence is locked at shift 111 on the 222 nonmultiples of 3.  Two
such sequences have joint Hamming distance at most 222, contradicting the
required value 334.  Shift 222 gives the symmetric second copy of the same
obstruction.

The other spectra have a direct arithmetic explanation.  For fixed `h`, the
locked positions solve `(h-1)x=s (mod 333)`.  Their counts are controlled by
`gcd(h-1,333)`: ID 1 contributes 9 solutions on 36 shifts; the two nonidentity
elements of ID 3 contribute disjoint sets of 9, giving 18; and those of IDs 4
and 5 contribute disjoint sets of 3, giving 6.  None approaches the threshold
167.

## Positive controls

The certificate preserves C736's feasible 9-compression witnesses for IDs 2,
4, and 5 and recomputes their row sums, joint norms, and full nonzero-shift PAF
profiles.  Each has row sums `(1,1)`, joint squared norm 594, and joint PAF
`-74` at all eight nonzero shifts.  ID 2 is therefore a sharp positive control:
its quotient relaxation is feasible even though its exact orbit action is
impossible.  IDs 4 and 5 are positive controls for the screen's boundary: they
share a feasible quotient witness and their exact maximum lock is only 6.

For IDs 0, 1, and 3, C736's quotient enumerations exceeded their declared
prefix budget.  C740 records no invented witness for them; their only positive
control is the exact finding that the orbit-lock criterion itself does not
exclude them.

## Reproducibility

From `rust/`:

```bash
python3 ../notes/2026-07-31-c740-hadamard-668-residual-orbit-locks.py \
  --check ../notes/2026-07-31-c740-hadamard-668-residual-orbit-locks.json
python3 ../notes/2026-07-31-c740-hadamard-668-residual-orbit-locks-replay.py \
  ../notes/2026-07-31-c740-hadamard-668-residual-orbit-locks.json
```

The generator reconstructs every subgroup and orbit partition, exhausts all
332 nonzero shifts, records the full lock-count spectra, applies the exact
threshold, and verifies the three committed compression controls.  The
independent replay shares no code: it tests the congruences `h*x=x+s` directly
without constructing orbit partitions and recomputes the compression PAFs
with the opposite index convention.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-31-c740-hadamard-668-residual-orbit-locks.py` | 5,478 | `adafa60780bb1931c3c4b26a0f0c208f40de90bab0d536266941ffb46674af04` |
| `notes/2026-07-31-c740-hadamard-668-residual-orbit-locks-replay.py` | 3,351 | `6d61922c3654a67e3c0a528febb1b154245017482f25e8c8e77acf0e1bb70dc8` |
| `notes/2026-07-31-c740-hadamard-668-residual-orbit-locks.json` | 14,168 | `eb2b58d210d8a5e6d8fa0a0d9b5aa096a7878af4f9483165591492a69cb9b231` |

The adjacent `.sha256` manifest freezes these hashes.  The trusted boundary is
Python integer arithmetic, the stable generators in Table A1 of
Ramos--Hulak--de Queiroz (arXiv:2607.20765v1), and the elementary PAF--Hamming
identity.  No priority claim is made.

## Scope and residual frontier

The fixed common-multiplier census now has five survivors: IDs `0,1,3,4,5`.
Their orders are respectively 1, 2, 3, 3, and 3.  The one-shift orbit-lock
mechanism is completely exhausted for them, so any further exclusion must use
joint information across shifts, a stronger compression/lift model, or another
analytic invariant.  IDs 4 and 5 are the smallest exact orbit models (113
orbits each) and share the same feasible 9-compression witness, making their
paired 37-compression or joint-lift analysis the highest-value next target.

## `ej` + `tt` closeout and mystery ledger

The closeout promoted C738's congruence into the exact threshold criterion,
screened every residual subgroup rather than checking ID 2 alone, retained the
failed-exclusion cases as explicit method controls, and reduced the repeated
ID-4/ID-5 spectrum to the gcd solution counts above.

| mystery | status | exact evidence gap / owner |
|---|---|---|
| Why does C738's proof also kill the smaller ID 2? | settled | multiplier 73 is irrelevant; `{112,223}` alone locks all 222 nonmultiples of 3 at shift 111. |
| Why do distinct IDs 4 and 5 have the same lock spectrum? | settled | each nonidentity multiplier yields three solutions of `(h-1)x=s`; the two solution sets are disjoint on exactly the 110 nonzero shifts divisible by 3. |
| Is any one-shift orbit-lock obstruction left among IDs 0,1,3,4,5? | settled | no: their exact maxima are `0,9,18,6,6`, all below the sharp threshold 167. |
| Do IDs 4 or 5 lift their common feasible 9-compression witness? | open | requires an exact 37-compression or joint orbit-level model; successor task. |
| Does Hadamard order 668 exist? | open | 25/30 fixed common-multiplier cases are excluded, but this is only one LP(333) construction route. |
