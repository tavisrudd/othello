# ergodis

**Exact Recovery, Global Optimization, and Invariant Synthesis**

ergodis is a structure-aware exact finite-domain solver for linear-code
recovery, capacitated repair scheduling, and finite algebraic search. It
compiles quotient structure, functional labels, conserved gradings, generated
spans, and reconstructible coefficient blocks before optimization. Problems
that are enormous in their raw support or coefficient representation can
therefore collapse to small exact state spaces.

Every successful solve returns more than an optimum: depending on the command,
the JSON result includes helper choices, resource loads, intermediate labels,
coefficient lifts, support families, or a replayable obstruction. ergodis is
specialized for algebraically structured finite domains; it is not a
general-purpose constraint-programming replacement.

“Invariant synthesis” means constructing the exact labelled cost state needed
by later composition; it does not mean conjecturing new mathematical
invariants.

![ergodis compilation pipeline](docs/pipeline.svg)

## Install

ergodis requires Rust 1.82 or later.

```text
cargo install --path . --features parallel
ergodis --help
```

For a repository-local build:

```text
cargo build --release --all-features
./target/release/ergodis --help
```

## Start here

The bundled inputs exercise the main workflows:

```text
# Expose equal scalar recovery costs but different exact GF(4) transfer costs.
ergodis transfer --input examples/data/f4-scalar-separation.json

# Analyze and replay an arbitrary-rank target subspace.
ergodis transfer-subspace --input examples/data/transfer-subspace.json

# Compose labelled costs through a hierarchy and expand its witness tree.
ergodis transfer-tower --input examples/data/transfer-tower.json

# Maximize simultaneous repairs under resource capacities.
ergodis schedule --input examples/data/schedule.json

# Run a storage application example.
ergodis application --input examples/data/ceph-repair.json
```

Every command accepts `--input -` for JSON on standard input and writes JSON to
standard output. Invalid dimensions, unsupported fields, exhausted candidate
or witness budgets, and inconsistent algebraic data fail closed with a
nonzero exit status.

For example, the bundled scheduling input returns the complete assignment,
aggregate loads, selected backend, and auditable work counters:

```json
{
  "repaired_count": 2,
  "complete": true,
  "assignment": [
    {"demand": 0, "loads": [0, 1]},
    {"demand": 1, "loads": [1, 0]}
  ],
  "total_loads": [1, 1],
  "backend": "dense-lattice",
  "transitions_examined": 8
}
```

## Commands

| command             | use                                                                 |
| :------------------ | :------------------------------------------------------------------ |
| `compose`           | compose an existing labelled cost table through one outer layer     |
| `transfer`          | derive exact rank-one transfer data from represented inner encoders |
| `transfer-subspace` | analyze an explicit normalized target subspace of arbitrary rank     |
| `transfer-tower`    | compile through several layers and replay coefficient witnesses      |
| `schedule`          | optimize alternative recovery systems under resource capacities     |
| `application`       | run a tagged storage, repair-DAG, QC-LDPC, vector, or GPU model       |

Use `ergodis <command> --help` for command-specific options. The input schemas
are represented by complete examples in `examples/data/`; these are also used
by the end-to-end CLI tests.

### Parallel execution

`compose`, `transfer-tower`, and `schedule` accept `--parallel`. The worker
count defaults to the machine's available CPU count and can be bounded
explicitly:

```text
ergodis transfer-tower \
  --input examples/data/transfer-tower.json \
  --parallel --threads 8
```

Parallel execution requires the Cargo feature `parallel`. Small instances may
be faster sequentially; outputs and canonical witnesses are identical.

## Application examples

`ergodis application` accepts one tagged JSON document and returns the exact
application result together with a replayable witness, support family, or
obstruction and explicit work counters. These built-in applications are worked examples of the solver's
compilation model, not an exhaustive application catalogue or separate
general-purpose products. Each preserves its mathematical structure instead
of flattening the problem into generic Boolean variables.

| input `kind`     | exact question                                                  | principal reduction                      |
| :--------------- | :-------------------------------------------------------------- | :--------------------------------------- |
| `ceph-xor`       | minimal helper supports through recursive XOR coding layers     | monotone antichain or compressed ZDD     |
| `azure-lrc`      | simultaneous LRC(12,2,2) repairs across nine upgrade domains    | six load types plus capacity bounds      |
| `repair-dag`     | minimum slots for precedence-constrained unit repair tasks      | ready-set dominance plus capacity search |
| `qc-ldpc`        | bounded trapping- or stopping-set existence in a QC lift        | cyclic quotient or degree-two components |
| `vector-repair`  | minimum storage nodes spanning a vector/subpacketized target    | quotient of generated node subspaces     |
| `gpu-checkpoint` | simultaneous MDS checkpoint recovery across node and rack links | aggregate capacities and cyclic witness  |

Additional examples:

```text
ergodis application --input examples/data/azure-repair-batch.json
ergodis application --input examples/data/repair-dag.json
ergodis application --input examples/data/qc-ldpc-search.json
ergodis application --input examples/data/vector-repair.json
ergodis application --input examples/data/gpu-checkpoint-recovery.json
```

The GPU front end solves the MDS/AEC recovery problem after placement is fixed;
it does not model GPU execution or checkpoint-copy overlap. The QC-LDPC front
end distinguishes trapping sets, which bound odd neighboring checks, from
stopping sets, which forbid neighboring checks of degree one.

## What ergodis computes

- prescribed-coset support costs and associative min--sum composition;
- exact finite confinement costs, including zero and nonzero functional
  sectors;
- coefficient-level recovery and tower witnesses;
- capacitated simultaneous repair with heterogeneous node, rack, link, or
  service limits;
- compressed minimal-support families, exact reliability counts, and
  scheduling views;
- generated-span optimization for vector and subpacketized repair; and
- orbit-, incidence-, and moment-structured finite-field searches.

Prime fields are statically dispatched, and canonical polynomial-basis GF(4)
is supported by the public composition and transfer paths. Hot states use
compact contiguous representations; minimizing lifts are stored separately
from numerical labelled costs so witnesses can be propagated without bloating
the dynamic-programming state.

## Performance highlights

These are bounded exact comparisons, not universal solver rankings. Every
control reproduces the same exact support family, optimum, or feasibility
verdict, as applicable; timing includes input or model construction.

| workload                    | scale                                  | ergodis | matched control         | control time | speedup  |
| :-------------------------- | :------------------------------------- | ------: | :---------------------- | -----------: | -------: |
| Ceph XOR support family     | 8 diamonds, 256 minimal supports       |  102 us | Graphillion ZDD closure |       864 us |       8x |
| represented GF(4) tower     | depth 6, fanout 4; 4,096 leaves        |  766 us | direct CP-SAT           |     263.76 s | 344,300x |
| published Hamming-outer LRC | binary `[4095,2718,6;2]`               |   231 ms | direct CP-SAT           |        100 s |     432x |
| GPU MDS checkpoint recovery | 10,000 shards, 6,000 data, 64 failures |  100 us | OR-Tools bipartite flow |   103,061 us |   1,029x |

See `BENCHMARKS.md` for all comparison tables, peak RSS, protocols,
architecture flags, profiling results, limits probes, and exact replay
commands. Machine-readable samples and artifact hashes are in
`evidence/benchmarks.json`.

## Rust library

The CLI is the stable documented entry point. The same engines are exported by
the `ergodis` crate for callers that need in-process composition, confinement,
scheduling, generated-span, or application APIs. Generate the current API
documentation with:

```text
cargo doc --all-features --open
```

The crate is at version 0.1.0; lower-level library interfaces may still evolve.

## Mathematical and evidence boundary

The companion paper, `../complete_repair_ports.pdf`, proves the labelled
composition and transfer laws from which the recovery compiler is derived.
ergodis evaluates finite instances and returns replayable witnesses; neither
its executions nor its benchmarks are premises of those proofs. The Python
code in `python/` is an independent reference and evidence layer, not the
production solver.

## Validate

From this directory, using the repository Nix toolchain:

```text
nix shell nixpkgs#python3 --command python3 python/generate_fixtures.py --check
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo fmt --check
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy --command \
  cargo clippy --all-targets --all-features -- -D warnings
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo test --all-features
```

The test corpus includes exhaustive small-field checks, seeded property tests,
CLI workflows, GF(4) labelled-transfer witnesses, orbit and scheduling
certificates, and independent differential fixtures. Performance claims are
accepted only after exact output and witness parity.

## License

ergodis is distributed under the repository's MIT License.
