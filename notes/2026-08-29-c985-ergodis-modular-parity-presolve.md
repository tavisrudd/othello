# C985 ergodis modular parity presolve

**Lane**: `complete-ports`

**Date**: 2026-08-29
**Status**: exact parity-functional import implemented and validated; shared-host
performance evidence is diagnostic only

## Theorem imported

Let `H` be a binary check matrix.  Every word in `ker(H)` has even weight if
and only if the all-ones coordinate vector lies in the row space of `H`.
Equivalently, there is a check functional `lambda` with

`lambda H = 1`.

For every partial syndrome `s` and every completion support `T` with
`H 1_T = s`, this gives the exact congruence

`|T| = lambda s (mod 2)`.

Consequently any lower bound `L` on the number of completion coordinates can
be rounded to the least integer at least `L` having parity `lambda s`.  This
strengthens both the syndrome-degree bound and the disjoint-neighborhood
packing bound without excluding a feasible completion.

The previous compiler recognized only the special functionals obtained by
summing every presented row or every retained basis row.  The new cold
compiler performs labelled binary elimination and recovers an arbitrary
rowspace functional.  Thus the top-level even-kernel test is now necessary
and sufficient, not merely sufficient.

## Engineering

- The recovered functional is stored as one fixed packed syndrome; no owned
  container enters a hot record.
- Residual parity is computed by XOR-folding the wordwise intersections and
  issuing one final population count.
- Rounding uses a Boolean-to-integer mask.  There is no run-constant branch
  and no allocation in the completion-bound path.
- The search remains iterative and uses its existing pre-sized worker frames.
- Source-bound compiled artifacts retain their format.  Loading independently
  rebuilds and checks the functional from the source matrix.

## Correctness

An adversarial fixture has three independent presented rows: two sum to the
all-ones vector, while all three do not.  The recovered nontrivial functional
matches support-weight parity for all 32 supports.  The pre-existing exhaustive
corpus compares connected, wide syndrome-driven, and brute-force answers for
every two-row binary check presentation on four coordinates and every nonzero
one-row logical observation.  Artifact round trips and the complete all-feature
crate suite also pass.

Validation under `choom -n 1000` in the isolated C985 target:

- `cargo fmt --check`;
- strict all-target, all-feature clippy;
- all-feature tests: 236 library tests plus every integration and doc-test
  target, with no failure.

## Shared-host diagnostic A/B

Adjacent commits `0939adaf4` (old) and `4b5c00615` (new) were built separately.
Three alternating old/new pairs ran 500 warm single-thread Gross
`[[144,12,12]]` searches per process under `choom` and `perf stat`.  Both sides
returned the same distance and witness.  Raw counters are retained at
`/home/tavis/.cache/ergodis/parity-presolve-perf-v1` and are not paper evidence.

The theorem reduces candidates from 55,192 to 39,234, a 28.91% reduction.
Ratios below are old/new, so values above one favor the new implementation.

| counter | paired ratios | geometric mean | paired-log `t` |
|---|---:|---:|---:|
| task clock | 1.2097, 1.1723, 1.1748 | 1.1855 | 16.78 |
| cycles | 1.2154, 1.1857, 1.1752 | 1.1920 | 17.44 |
| instructions | 0.9822, 0.9823, 0.9869 | 0.9838 | -10.40 |
| branches | 1.3120, 1.3110, 1.3126 | 1.3119 | 803.55 |
| branch misses | 1.6557, 1.6414, 1.6281 | 1.6417 | 102.11 |
| cache references | 1.7044, 1.7398, 1.6615 | 1.7016 | 39.91 |
| cache misses | 1.7003, 1.6196, 1.6168 | 1.6451 | 30.13 |

The important negative is also explicit: the new masked parity calculation
retires about 1.65% more instructions.  The state reduction nevertheless wins
about 19.2% in cycles and 18.6% in task time, chiefly by removing branches and
memory work.  A one-round cold diagnostic remains compile-dominated
(`~151 ms` preparation versus `2.6--3.4 ms` search), so its end-to-end time is
essentially unchanged.  This import helps repeated/warm exact searches and
does not yet accelerate cold compilation.

## Next gate

Generalize the same presolve registry from parity to verified small residue and
moment images.  Each invariant must expose a packed residual-state projection,
a reachable-residue table by remaining weight, and an independently replayed
exclusion.  Keep an invariant only when its extra hot instructions are repaid
by end-to-end state reduction on held-out instances.

One immediate generalization was implemented and rejected.  An exact
512-state BFS table combined an eight-bit syndrome projection with completion
parity.  It passed the full correctness gate but removed no additional
candidates on either Gross or BB288; BB288 search increased from `0.6949 s` to
`0.7423 s` in the bounded diagnostic.  Commit `a70b5a9bc` removes the table.
Future finite images need a compile-time selection score predicting a strictly
stronger bound before they are admitted to the hot path.
