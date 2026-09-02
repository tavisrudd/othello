# C985 structured integer-set theorem kernel

**Lane:** `complete-ports`

**Status:** implementation and exact controls pass; first private application adapter remains open

**Date:** 2026-09-02

## Purpose

C1016 exposed a reusable gap between flat-row evolution and the exact sets its
proof compilers manipulate. Many attainable-value fibres have the form

```text
([minimum, maximum] intersect selected residues modulo m) minus sparse holes.
```

Flattening that set enumerates the interval, duplicates the same congruence
semantics across clients, and makes a zero-sum or fixed-target join look like a
large certificate. The public kernel now gives this representation one bounded,
canonical implementation and an exact replay boundary. It contains no C1016
names, parameters, masks, or conclusions.

## Exact semantics

For an interval `I`, nonempty canonical residue set `R` modulo `m`, and sorted
hole set `H` contained in the residue base, the compiled set is

```text
S = {x in I : x mod m is in R} minus H.
```

Construction validates the modulus, span, residues, holes, and configured
resource ceilings. Cardinality is computed by summing the exact arithmetic-
progression count for each residue and subtracting the hole count. Negative
integers use Euclidean residues.

For two compiled sets `A,B` and target `t`, the fixed-target sum kernel computes

```text
N_t = |{a in A : t-a in B}|.
```

It returns `N_t` and the canonical first witness when `N_t>0`. The verifier
recomputes the count and witness from the two set objects; changing the target,
count, or witness fails replay. Thus emptiness of the target fibre is the
structural statement `N_t=0`, not an opaque enumerated miss.

## Representation and performance boundary

The residue universe is at most 256 and uses one asserted 32-byte four-word
mask. Sparse holes are a sorted boxed slice. Construction additionally compiles
one `u16` next-allowed-residue delta per active modulus position. Iteration then
jumps directly between members of the interval/residue base and only checks
sparse holes; it does not scan forbidden interval positions. A one-of-256
residue presentation therefore visits roughly one base value per 256 interval
positions before holes.

Membership, iteration, fixed-target counting, witness production, and replay
are iterative and allocate nothing. The permanent allocation regression runs
500 targets through production plus verifier and records zero allocations,
reallocations, and deallocations. Small moduli/residue masks are exhaustively
checked against direct enumeration, including negative values, and a separate
flat oracle checks every target in a two-set control. Malformed residue, hole,
span, and forged-certificate cases fail closed.

This is a new standalone theorem/query kernel rather than a changed solve hot
loop, so it makes no end-to-end speed claim yet. The first application adapter
must retain a flat implementation for an interleaved counter A/B and separately
measure theorem-hit coverage and clean-miss cost.

## Classical and new boundary

Arithmetic progressions, residue filtering, sparse exceptions, and fixed-target
sum counting are classical. The contribution here is engineering and semantic
integration: one bounded typed representation, canonical validation, exact
replay, sparse-hole handling, and an allocation-free consumer suitable for
Ergodis theorem evolution and certified search. It should be described as an
imported general kernel, not a new additive-combinatorics theorem.

## Reach

Immediate candidate adapters are:

- C1016 attainable-value fibres and hole-covered sum relations;
- modular resource and scheduling states whose attainable loads are intervals
  with congruence restrictions;
- bounded integer moment images;
- exact automata/counter-system guards; and
- sparse exceptional-value projections from Evolve feature DAGs.

The next general extensions, only when demanded by an application, are typed
intersection/preimage, bounded multi-sum convolution, Pareto-valued witnesses,
and a measured representation crossover for dense holes. Elias--Fano, a bitmap,
or a complement representation is a policy candidate for that crossover, not a
default.

## Acceptance and next gate

Focused exact/oracle/allocation tests and strict all-target/all-feature clippy
pass. The full all-target/all-feature suite is the remaining code-acceptance
gate. After it passes, land the kernel and adapt one existing private
interval/residue/hole client without moving any private vocabulary into core.
