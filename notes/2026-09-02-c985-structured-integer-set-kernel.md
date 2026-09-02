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

The retained counter does not enumerate `A` or `B`. It counts compatible
residue progressions in the exact overlap interval, then subtracts pairs hit by
left holes or right holes and adds back their overlap. Witness extraction walks
only compatible progressions and skips excluded values. An adaptive work gate
uses the smaller exact-set scan instead when the least-common-multiple period
plus hole counts exceeds the smaller set cardinality; the two routes implement
the same observable certificate.

## Representation and performance boundary

The residue universe is at most 256 and uses one asserted 32-byte four-word
mask. Sparse holes are a sorted boxed slice. Construction additionally compiles
one `u16` next-allowed-residue delta per active modulus position. Iteration then
jumps directly between members of the interval/residue base and only checks
sparse holes; it does not scan forbidden interval positions. A one-of-256
residue presentation therefore visits roughly one base value per 256 interval
positions before holes.

Membership, iteration, both fixed-target counting routes, witness production, and replay
are iterative and allocate nothing. The permanent allocation regression runs
500 targets through production plus verifier and records zero allocations,
reallocations, and deallocations. Small moduli/residue masks are exhaustively
checked against direct enumeration, including negative values, and a separate
flat oracle checks every target in a two-set control. Malformed residue, hole,
span, and forged-certificate cases fail closed.

This is a new standalone theorem/query kernel rather than a changed solve hot
loop. A retained private harness now compares the natural flat member scan with
the structural counter on a g133-shaped modulus-64/range/sparse-hole workload.
Its first diagnostic run is intentionally not retained because it preceded the
commit containing the strengthened counter; the exact seven-pair run must be
repeated from the committed revision before any speed ratio is recorded here.

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

Focused exact/oracle/allocation tests, strict all-target/all-feature clippy, and
the full all-target/all-feature suite pass. From exact commit `701f19542`, the
retained seven-pair counter A/B (100 rounds by 257 queries per arm, order
rotated, pinned to CPU 2) reports the following paired medians:

| Measure | Flat / structured | Paired-log t |
|---|---:|---:|
| wall | 67.860x | 254.09 |
| cycles | 92.818x | 1660.30 |
| instructions | 77.196x | 58948940.40 |
| branches | 89.507x | 30630825.26 |
| branch misses | 143.180x | 507.99 |

Every arm reports `work=25700` and the same checksum. This is a deliberately
application-shaped g133 control of the imported kernel, not a direct C1016
end-to-end speed claim. The exact harness, raw perf counters, streamed stdout,
metadata, summary, and SHA-256 manifest are retained at
`ergodis-private/evidence/c985-structured-set-ab-20260902/`.

Independent replay:

```sh
nix shell nixpkgs#python3 -c python3 \
  ergodis-private/benchmarks/summarize_paired_ab.py \
  ergodis-private/evidence/c985-structured-set-ab-20260902/samples.tsv \
  /tmp/persistent/c985-structured-set-summary.tsv
cmp ergodis-private/evidence/c985-structured-set-ab-20260902/summary.tsv \
  /tmp/persistent/c985-structured-set-summary.tsv
(cd ergodis-private/evidence/c985-structured-set-ab-20260902 && \
  sha256sum -c SHA256SUMS)
```

A direct C1016 adapter remains separate so no active private campaign code or
vocabulary moves into core.
