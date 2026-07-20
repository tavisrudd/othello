# C385 — Clebsch factorization versus Kotzig's perfect-one-factorization problem

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `BOUNDED NEGATIVE; BOTH SHEETS HAVE CYCLE TYPE 6+6 FOR EVERY FACTOR PAIR`

## Question and gate

Test whether either of C379's two canonical one-factorizations of `K_12` is perfect: every pair of
one-factors must have Hamiltonian union.  This exact check precedes all analogy or literature work.

If neither factorization is perfect, close immediately.  If one is perfect, identify its standard
isomorphism class and close unless the `A5<PSL_2(11)<PGL_2(11)` construction exposes a group-theoretic
ingredient that can be stated for an infinite set of even orders.  C379 proves that the unchanged
matching construction forces q=11, so a single known `K_12` factorization is not a new route to
Kotzig's conjecture.

Any positive family wording requires primary and forward-citation closure.  The task claims no
progress from a small example alone.

## Result

Neither C379 one-factorization is perfect.  In each of the `tau=8` and `tau=4` sheets, all
`binom(11,2)=55` unordered pairs of one-factors have union equal to two disjoint six-cycles.  Thus
each sheet has zero Hamiltonian factor pairs, and the prescribed first-failure gate closes C385
before any analogy, identification, or literature work.

The result is stronger than the minimum kill witness but remains exactly bounded to C379's two
certified `K_12` factorizations.  It says nothing about other one-factorizations of `K_12`, larger
orders, or Kotzig's conjecture.

## Exact certificate

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-19-c385-clebsch-perfect-one-factorization-gate.py --check
sha256sum -c notes/2026-07-19-c385-clebsch-perfect-one-factorization-gate.sha256
```

Intentional regeneration is:

```bash
python3 notes/2026-07-19-c385-clebsch-perfect-one-factorization-gate.py --write
```

The checker pins C379's canonical certificate by SHA-256, verifies that each sheet really is an
eleven-factor edge partition of `K_12`, and tests all 110 factor pairs.  Its primary check computes
the connected-component sizes of each two-factor union.  An independent invariant check composes
the two fixed-point-free matching involutions: the union type `6+6` corresponds to product cycle
type `3+3+3+3`, and both methods agree on every pair.  The trusted boundary is Python 3, exact
finite tuple/set arithmetic, and the pinned C379 matching fixture.

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | 6,615 | `4926be19263a5be1db8043f9df1f7b2937179f76230fad93afc205aa817637e6` |
| certificate `.json` | 1,488 | `ab6a4a6a867fc12da3c4dc86178e75bacdb4025c87d9c0eb8513cb13cc7deaad` |

## Hand-back

C385 closes at its mandatory first gate.  The C379 one-factorizations are maximally uniform in the
opposite direction from perfectness: every pair splits `12` as `6+6`.  No successor is allocated.
