# C985 ergodis commutant foundation

**Lane**: `complete-ports`

**Date**: 2026-08-29
**Status**: correctness foundation complete; application and performance gates open

## Result

Ergodis now has a generic verified `GF(2)` linear-action layer beneath its
coordinate-orbit compiler.  It can induce an action from coordinate
permutations onto the canonical basis of any invariant binary row space, or
onto a nested quotient `D/K`, of rank at most 63; compute the full commuting
endomorphism algebra; find a nontrivial central-idempotent split when one
occurs in a bounded search; and convert ambient vectors to compact coordinates
in both invariant summands.  The quotient reducer retains labels while
eliminating ambient rows, so a representative may move by an element of `K`
without losing the induced action on `D/K`.

The same layer can certify that a supplied commuting operator generates an
actual extension field `GF(2^d)`, for `2 <= d <= 16`.  It does not infer this
from the operator order.  It recovers the first polynomial relation among
`1,A,...,A^d` and checks that the resulting degree-`d` minimal polynomial is
irreducible over `GF(2)`.  This proves that the generated algebra is a field.

An exhaustive reference path separately checks that

1. `1,A,...,A^(d-1)` are independent;
2. `A^d` lies in their span, so the span is an algebra; and
3. every nonzero element of the `2^d`-element algebra has full binary rank.

The last condition rejects product algebras and zero divisors.  Differential
tests compare the theorem and exhaustive paths for every monic odd binary
polynomial through degree eight.  A successful certificate therefore supplies
a genuine scalar-field action, the mechanism needed by the portfolio's
hidden-`F_8` example.

## Public interfaces

`src/commutant.rs` provides:

- `PackedBinaryLinearMap` and `PackedBinaryAction`;
- `compile_binary_subspace_action` and exact replay;
- `compile_binary_quotient_action` and exact replay;
- `compile_binary_css_logical_action`, which constructs and verifies the
  observable quotient from physical checks and logical representatives;
- `compile_binary_commutant` and a dimension-and-equation verifier;
- bounded `BinaryCommutant::find_central_split`;
- allocation-free coordinate conversion through `PackedBinarySubspace`;
- `certify_binary_extension_field` and exact replay.
- `certify_binary_extension_field_exhaustive`, retained as a differential and
  performance-counter reference rather than the default algorithm.

An induced coordinate action is rejected unless each supplied map is a true
permutation and preserves the supplied row space exactly.  A commutant
certificate is rejected unless every basis element commutes, the basis is
independent, and its dimension is the nullity of all `XG=GX` equations.  A
central split is checked for idempotence, commutation with the original action
and the full commutant, complementary dimensions, and standard-basis
round trips.

## Engineering properties

- Packed vectors and map rows use `u64`; the present rank bound is 63.
- Ambient-to-block coordinate conversion allocates nothing.
- The bounded central-idempotent scan updates candidates in Gray-code order
  and allocates nothing in its scan loop.
- The exhaustive field check preallocates combination and rank workspaces and
  allocates nothing per candidate field element.
- Compilation owns its equation matrices and bases; no hot search backend has
  been changed yet.
- Dense commutant compilation computes a conservative equation-workspace upper
  bound before allocation and refuses requests above 128 MiB.  This includes
  both packed row payloads and per-row vector headers.
- Builds, tests, profiles, and future benchmarks run under `choom -n 1000` so
  task-owned work is preferred for OOM termination over unrelated processes.
- No instance names, expected distances, construction-family tables, or
  benchmark-derived answers enter the API or implementation.

## Correctness fixtures

The tests cover every single-generator two-dimensional binary action, replay
of the resulting full commutant, an order-three irreducible action induced by
the coordinate cycle on the binary even-parity code, a central split into
nonisomorphic dimensions one and two, compact-coordinate round trips, action
compatibility of both summands, rejection of a non-invariant coordinate
action, rejection of a dependent commutant basis, and rejection of the
identity as a fake quadratic-field generator.  A quotient fixture realizes the
same irreducible order-three action on
`F_2^3 / span((1,1,1))`, certifies its `F_4` scalar structure, and rejects both
nonnested inputs and a permutation that preserves `D` but not `K`.

The complete crate test suite and strict library clippy gate pass with all
features in an isolated disk-backed Cargo target.  No benchmark, profile,
timing comparison, or performance claim was run because another computation
owned the machine when the foundation first landed.

### Shared-host diagnostic A/B

After diagnostic measurements were authorized, the committed
`examples/commutant_field_probe.rs` compared 20,000 certifications of the AES
degree-eight field in three alternating exhaustive/theorem pairs.  Both the
probe and `perf stat` ran under `choom -n 1000`.  Raw counter files are retained
privately at `/home/tavis/.cache/ergodis/commutant-field-perf-v1`; they are not
paper evidence.

| counter, exhaustive/theorem | paired ratios | geometric mean | paired-log `t` |
|---|---:|---:|---:|
| cycles | 19.720, 20.818, 19.208 | 19.904 | 126.24 |
| instructions | 19.971, 19.749, 20.559 | 20.090 | 250.27 |
| branches | 28.623, 27.890, 29.148 | 28.549 | 261.80 |
| branch misses | 24.094, 22.232, 41.659 | 28.154 | 16.92 |
| task clock | 12.991, 14.387, 18.419 | 15.100 | 26.19 |

Cache-reference and cache-miss ratios were unstable under contention and are
not interpreted.  The robust conclusion is algorithmic: minimal-polynomial
irreducibility removes about twenty times the retired instructions of the
degree-eight exhaustive certificate.  These are diagnostic counters, not a
clean machine-level benchmark claim.

## Exact boundary

This is the algebraic foundation, not yet the Work Package A acceptance result.

1. The rank-63 packed representation is sufficient for many logical and
   portfolio observation modules, but not for the full syndrome spaces of the
   larger qLDPC targets.  A naive segmented dense commutant is forbidden: its
   equation storage grows as generators times the fourth power of state rank.
   Large-rank support must use sparse or block equations, streamed elimination,
   and an explicit memory budget.
2. Extension-field certification currently consumes a proposed operator; a
   structural discovery pass over the commutant is still required.
3. A central idempotent gives exact invariant blocks but is not, without
   additional semisimplicity hypotheses, advertised as a complete isotypic
   decomposition.
4. The CSS backend does not yet store syndrome or logical keys in the compiled
   block coordinates.
5. No end-to-end speed or memory effect is claimed until the machine is clear
   and held-out measurements are authorized.

## Next gate

1. Add bounded discovery of field-generating commutant elements, retaining the
   exact field verifier as the admission gate.
2. Add a segmented binary-map representation for ranks above 63 without
   changing the packed fast path.
3. Extend the CSS adapter from the now-implemented logical quotient to the
   physical-syndrome space, using segmented state when its rank exceeds 63.
4. Compile completion keys in block coordinates and prove exact agreement with
   the unreduced backend on small exhaustive codes.
5. Only after an all-clear, measure gross, BB784, R2Elite, LP1768, and held-out
   controls under the protocol in the portfolio-theorem workplan.
