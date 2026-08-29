# ergodis

**Exact Recovery, Global Optimization, and Invariant Synthesis**

**Optimization and operations-research readers:** start with
[ergodis for optimization researchers](OPTIMIZATION.md). It explains the
mathematical results and solver design in optimization language and assumes no
coding-theory background.

ergodis is a compiler and exact solver for finite algebraic optimization
problems whose raw combinatorial state admits a much smaller mathematically
derived quotient. Its Rust library provides kernels for linear-code recovery,
hierarchical composition, capacitated scheduling, and finite algebraic search.
It compiles functional labels, conserved gradings, generated spans, symmetries,
and reconstructible coefficient blocks before optimization.

Every successful computation returns more than an optimum. Library answer
types, and their CLI JSON representations, retain helper choices, resource
loads, intermediate labels, coefficient lifts, support families, or replayable
obstructions. ergodis is specialized for algebraically structured finite
domains; it is not a general-purpose constraint-programming replacement.

“Invariant synthesis” means constructing the exact labelled cost state needed
by later composition; it does not mean conjecturing new mathematical
invariants.

## Scope and limits

ergodis is designed for exact finite problems with exploitable linear,
quotient, symmetry, span, syndrome, orbit, or repeated-interface structure. It
is most useful when many raw assignments collapse to a much smaller exact state
and an original-space witness must be reconstructed.

It is less suitable when arbitrary side constraints, continuous variables, or
strong linear relaxations dominate the model, or when no compact algebraic
state is known. It does not model repair bandwidth, network timing, GPU
execution, or storage-system dynamics unless those quantities are explicitly
encoded in the finite input. CP-SAT, MILP, flow, or decision-diagram solvers may
remain the right backend or the better standalone tool. The
[optimization guide](OPTIMIZATION.md#scope-and-limits) gives the detailed
crossover criteria.

![ergodis compilation pipeline](docs/pipeline.svg)

## Use as a Rust library

The crate is the primary integration surface. The `ergodis` executable calls
the same public APIs and provides JSON interfaces for examples, shell workflows,
and independent replay.

Add the crate from its repository, or by path after cloning it:

```toml
[dependencies]
ergodis = { git = "https://github.com/tavisrudd/ergodis" }
```

Enable `features = ["parallel"]` when independent subproblems are large enough
to benefit from Rayon. Sequential execution remains available and avoids the
parallel setup cost on small instances.

This example compiles a binary two-block cost table and queries an exact cost
with its minimizing local labels:

```rust
use ergodis::{CompositionTable, CostTable, Matrix};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let zero = Matrix::new::<2>(1, 1, vec![0])?;
    let one = Matrix::new::<2>(1, 1, vec![1])?;
    let inner = CostTable::from_entries::<2>(
        1,
        1,
        [(zero, 0), (one.clone(), 1)],
    )?;
    let blocks = [one.clone(), one.clone()];
    let compiled = CompositionTable::compose::<2>(&blocks, &inner)?;
    let answer = compiled.answer::<2>(&one)?.expect("reachable label");

    assert_eq!(answer.cost, 1);
    assert_eq!(answer.local_labels.len(), 2);
    Ok(())
}
```

Run the checked version as `cargo run --release --example library_composition`.

The main library surfaces are:

| API                                                   | Use it for                                                      |
| :---------------------------------------------------- | :-------------------------------------------------------------- |
| `CostTable`, `CompositionTable`, `CompositionTower`   | labelled min-sum composition and expanded tower witnesses       |
| `compile_binary_*`, `confinement_*`, contextual plans | recovery profiles, confinement certificates, and context caches |
| scheduler functions and workspaces                    | capacitated and coefficient-weighted simultaneous recovery      |
| span, orbit, incidence, and projective modules        | compiled finite-field and symmetry-reduced search               |
| `CompiledCssDistance`                                 | exact bounded CSS distance from connected-support elimination    |
| application types and functions                       | worked storage, sparse-code, and dependent-task models          |

Generate the complete API documentation with:

```text
cargo doc --all-features --open
```

The crate is at version 0.1.0; lower-level interfaces may still evolve.

## Build and use the CLI

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
    { "demand": 0, "loads": [0, 1] },
    { "demand": 1, "loads": [1, 0] }
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
| `transfer-subspace` | analyze an explicit normalized target subspace of arbitrary rank    |
| `transfer-tower`    | compile through several layers and replay coefficient witnesses     |
| `schedule`          | optimize alternative recovery systems under resource capacities     |
| `application`       | run a tagged storage, repair-DAG, QC-LDPC, vector, or GPU model     |

Use `ergodis <command> --help` for command-specific options. The input schemas
are represented by complete examples in `examples/data/`; these are also used
by the end-to-end CLI tests.

The separate `css_distance_native` binary consumes sparse physical checks,
logical observations, verified coordinate-orbit anchors, and an optional
incumbent support. It independently replays the incumbent and exhaustively
closes every smaller connected-support class. `--rounds` reuses the compiled
residual-syndrome filters; `--evidence` writes one create-only JSONL record.

### Contextual-state library APIs

The Rust library exposes three exact shortcuts derived from the compositional
state theorem:

- `certify_rank_one_transfer_by_generators` decides whether every bounded
  recovery system through a supplied radius transfers completely. It checks
  the zero sector first, evaluates the target block first, prunes partial costs
  above the radius, and stops at the first obstruction. Use the full
  `confinement_by_generators` API when the exact losing nonzero-sector minimum
  is also required.
- `RankOneProbeCache` stores the zero-truncated projective line-probe profile
  lazily. It is intended for repeated compatible outer contexts over the same
  scalar-labelled inner state.
- `RankBoundedContextCache` decomposes a rank-`t` query into canonical outer
  functional-dual subspaces of dimension at most `t` and reuses exact results
  across contexts. It never merges differently labelled maps merely because
  they generate the same subspace.
- `context_cost` defaults to a safe one-query `Auto` forecast.
  `context_cost_cached` requests cache admission explicitly, while
  `context_cost_planned` accepts `Direct`, `Cached`, or a caller-supplied
  `Auto` forecast.
  `Auto` admits state only when the measured reuse threshold is met and a
  conservative query-cache estimate, including actual key width, fits the
  caller's byte budget; otherwise
  it executes the exact direct scan without mutating the cache. A context
  already complete in the cache is reused without a new admission, even when
  its fresh-query forecast would select direct execution.

The Rust hot scans use preallocated coefficient, label, elimination, and RREF
scratch. Persistent keys occupy one flat byte pool behind compact 16-byte
records and integer open-addressing slots; local table lookups consume slices,
so candidate enumeration does not allocate. Allocation is confined to
validation/setup, reserved state admission, and final witness materialization.

The two context caches currently specialize to scalar labels over the outer
field. A flattened base-field representation of a proper extension does not
carry enough information to recover extension-field scalar multiplication; a
future generalized API must receive that action explicitly.

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
obstruction and explicit work counters. The second column below states the
decision problem in operational terms; the third names the mathematical
reduction ergodis uses. These built-in applications are worked examples of the
solver's compilation model, not an exhaustive application catalogue or
separate general-purpose products.

| input `kind`     | exact question                                                   | principal reduction                              |
| :--------------- | :--------------------------------------------------------------- | :----------------------------------------------- |
| `ceph-xor`       | in distributed storage, list every minimal repair set            | shared decision graph for set families           |
| `azure-lrc`      | in cloud storage, serve the most losses within domain capacities | six recurring load types and capacity bounds     |
| `repair-dag`     | finish dependent repair tasks in the fewest capacity-safe slots  | equivalent ready-task sets plus capacity search  |
| `qc-ldpc`        | find a small failure-causing pattern in a repeated sparse code   | cyclic symmetry and graph components             |
| `vector-repair`  | find the fewest physical nodes whose symbols span the target     | merge identical generated node spans             |
| `gpu-checkpoint` | assign helpers without overloading nodes or rack links           | aggregate capacities, then construct the witness |

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

| workload                    | scale                                  | cold wall/solve       | cold speedup | warm-batch wall/solve | warm speedup |
| :-------------------------- | :------------------------------------- | :-------------------- | -----------: | :-------------------- | -----------: |
| Ceph XOR support family     | 8 diamonds, 256 minimal supports       | 3.014 / 101.628 ms    |       33.71x | 0.547 / 12.598 ms     |       22.94x |
| represented GF(4) tower     | depth 6, fanout 4; 4,096 leaves        | 4.559 ms / >400 s     |   >87,743.5x | 1.109 ms / >50 s      |   >45,103.0x |
| published Hamming-outer LRC | binary `[4095,2718,6;2]`               | 442.573 ms / 270.939 s|      657.88x | 254.452 ms / >50 s    |      >196.50x |
| GPU MDS checkpoint recovery | 10,000 shards, 6,000 data, 64 failures | 3.803 / 393.213 ms    |      102.42x | 0.682 / 70.449 ms     |      103.23x |

Each cell is `ergodis / control`. Cold samples run one solve per fresh process;
warm-batch samples run eight solves per fresh process on both sides and divide
external wall time by eight. The tower and warm Hamming controls exceeded the
400-second batch limit, so those entries are lower bounds. The cold Hamming
ratio is the median of three paired completed runs (`t = 49.09`).

See `BENCHMARKS.md` for all comparison tables, peak RSS, protocols,
architecture flags, profiling results, limits probes, and exact replay
commands. Corrected raw samples, summaries, and artifact hashes are in
`evidence/c985-application-readme-ab*` and
`evidence/c985-application-long-{cold,warm}*`.

## Mathematical and evidence scope

The companion paper, `../compositional_recovery.pdf`, proves the labelled
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

ergodis is distributed under the GNU Affero General Public License, version
3.0 (AGPL-3.0); see `LICENSE` in this directory. Contact the author for
commercial licensing.
