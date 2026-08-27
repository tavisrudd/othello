# C962 published benchmark audit

**Date:** 2026-08-26
**Lane:** `complete-ports`
**Scope:** Select a realistic external instance for ERGO-comp, require exact
model parity against direct and equivalently preprocessed CP-SAT, and prefer a
coding-theory application over a generic optimization benchmark.

## Summary

Three primary sources were consulted; zero were read at full-text depth. Jin--Fu
was read partially at the construction and selected-example level, Ochei--Petrovski--Bass
was read partially at the model/evaluation/limitations level, and the
Mansini--Zanotti article was available only at abstract/metadata depth while its
six-page results supplement and public instance documentation were inspected
separately.

The accepted benchmark is Jin and Fu's published GF(4) cyclic `[43,36,5]`
outer code from Example 5.7, concatenated with their fixed binary `[3,2,2]`
inner code to obtain a `[129,72,10;2]` LRC. This is the strongest match because
it exercises the exact mathematical object compiled by ERGO-comp rather than
only sharing the scheduler's generic optimization shape.

ERGO-comp derives the outer dual basis from the paper's generator polynomial,
compiles the labelled inner costs, examines the complete set of 16,383 nonzero
outer functionals, and returns

| quantity                          | exact value |
| :-------------------------------- | ----------: |
| relative rank-one weight          |           2 |
| zero-functional escape cost       |           5 |
| best nonzero-functional cost      |          26 |
| exact nonconfinement cost `Gamma` |           5 |
| maximum confined radius           |           4 |

The seven-round pinned-core medians are:

| backend          | exact time   | peak RSS   | relative time   |
| :--------------- | -----------: | ---------: | --------------: |
| ERGO-comp        |    20.938 ms |    2.2 MiB |              1x |
| direct CP-SAT    |       4.07 s |   78.5 MiB |            195x |
| labelled CP-SAT  |       4.91 s |   79.2 MiB |            235x |

All three backends return checksum `5`. Direct CP-SAT receives the binary inner
coefficient variables, row-support objective, and exact GF(4) parity equations.
The labelled control receives the same four-entry ordinary and target-normalized
tables as ERGO-comp. Both CP-SAT models prove the nonzero-sector minimum `26`
before comparison with the zero-sector value `5`; thus neither baseline is
allowed to skip the sector that could have defeated the scalar bound.

This computation adds exact recovery/confinement information to the published
code. Jin and Fu do not claim these values, and the benchmark is not evidence
for their minimum-distance theorem.

## Reproduction boundary

Authority paths:

- `papers/complete-repair-ports/algorithms/rust/src/bin/bench_kernels.rs`;
- `papers/complete-repair-ports/algorithms/rust/benchmark_python.py`;
- `papers/complete-repair-ports/algorithms/rust/run_benchmarks.py`;
- `papers/complete-repair-ports/algorithms/rust/evidence/benchmarks.json`, key
  `jin_fu_concatenated_lrc`.

Replay after building the release benchmark binary with the documented
`x86-64-v3` flags:

```text
ERGO_BENCH_BINARY=<release-binary> python3 run_benchmarks.py \
  --write --jin-fu-only --ab-rounds 7
```

The evidence record carries the exact binary and source hashes, raw samples,
work counters, RSS, protocol, and code parameters.

## Candidates not selected

### Multidimensional multiple-choice knapsack suite

The public Mansini--Zanotti suite is a principled generic scheduler benchmark:
up to 700 groups, 25 alternatives, and 25 resource dimensions, with published
best values. Its arbitrary-profit objective is not the current public scheduler
objective. A mathematically exact reduction adds a profit-gap resource and asks
for the least capacity serving every group, but this destroys the small-state
geometry on which the present scheduler specializes. A bounded probe of the
first 100-group, 10-choice, 10-resource instance did not complete within 30
seconds. It is therefore a useful future red-team and profit-aware-backend
target, not a current performance claim.

### Cloud deployment instance

Ochei, Petrovski, and Bass publish a 500-group, 20-choice, four-resource cloud
deployment instance and explicitly report that an exact optimum was not
obtainable in their study. This is attractive as a previously infeasible
application. The current scheduler did not complete even the feasibility-only
projection within a bounded 15-second probe, and the paper's updated objective
contains decimal-valued rewards not represented by the public scheduler. A
profit-aware core/branch-and-bound backend would be required before this can be
claimed fairly.

## Sources and read depth

1. Hengfeng Jin and Fang-Wei Fu, *Constructions of Locally Repairable Codes via
   Concatenated Codes*, arXiv:2605.04618v1 (2026). **Read depth: partial** --
   cached PDF, Section 3 (especially Construction 3.2) and Example 5.7 in
   Section 5. Cache key `arXiv:2605.04618`, SHA-256
   `69847fc4ed1ada75f615ab8d2b2c08484da31253d278f9485cd03f5ab9587d93`.

2. Renata Mansini and Roberto Zanotti, *A Core-Based Exact Algorithm for the
   Multidimensional Multiple Choice Knapsack Problem*, INFORMS Journal on
   Computing 32(4) (2020), DOI `10.1287/ijoc.2019.0909`. **Read depth:
   abstract/metadata only** -- publisher abstract and bibliographic page. The
   authors' public benchmark documentation and six-page detailed-results
   supplement were inspected separately; supplement SHA-256
   `32ae8372ee4b01a8881e186ea28a2eb75c2a273cdc3f267ae6b81e529678379a`,
   instance archive SHA-256
   `c11aac9778b5219bc580476a2b32237ea595a6e43dca1749e7711326f0156135`.

3. Laud Charles Ochei, Andrei Petrovski, and Julian M. Bass, *Optimal
   deployment of components of cloud-hosted application for guaranteeing
   multitenancy isolation*, Journal of Cloud Computing 8, article 1 (2019),
   DOI `10.1186/s13677-018-0124-5`. **Read depth: partial** -- open-access HTML,
   problem formalization, dataset generation, evaluation, and limitations.
   The large original and updated instance supplements were inspected;
   SHA-256 values
   `c8a4474ea8fb787749aaa073aea00741cd5543558e405db990b6716651a7ea1e`
   and
   `da25b1dfb12653622159f1d2b0e19fd7736ffef31d7630898c881dc12abe6db4`.

## Coverage boundary

This was a benchmark-selection audit, not a novelty or priority audit. It does
not license an absence claim about exact concatenated recovery analysis. The
accepted source was chosen for model fit and public reproducibility; the two
generic candidates were used to test whether their published instance geometry
matches the current engine.
