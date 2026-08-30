# C985 private adapters and parallel root execution

## Result

The projective-grid and alignment-attachment research adapters no longer live
in the publicly consumable Ergodis package.  A repository-top-level,
unpublished `ergodis-private` package now depends one-way on the public core.
The public core gained only a domain-neutral independent-root execution API.

The projective-grid adapter is the first end-to-end parallel control.  On a
fixed deterministic 10,000-root q=11 workload, 24 Rust workers reproduce the
single-worker metrics exactly and reduce mean wall time from 5.710495 seconds
to 0.561006 seconds, a 10.1831x geometric-mean speedup across seven interleaved
pairs.  The paired log-ratio t statistic is 196.040.

## Boundary

Public, under `papers/complete-repair-ports/ergodis`:

- `src/root_execution.rs`: stable `u32` root ordinals, one worker-local
  workspace per Rayon worker, and an associative reduction boundary;
- no projective-grid or alignment-campaign adapter type in the library API;
- the generic Hall example is named by its domain rather than a task ID.

Unpublished, under repository-top-level `ergodis-private`:

- `src/projective_grid.rs` and `src/bin/projective_grid_scout.rs`;
- `src/alignment_control.rs` and `src/bin/alignment_controlled.rs`;
- campaign documentation, project-specific fixtures, oracle scripts, and
  external-solver research drivers.

The dependency direction is enforced by Cargo: `ergodis-private` depends on
Ergodis with `parallel` and `control-plane`; Ergodis has no dependency on the
private package.

Historical benchmark evidence under Ergodis still has task-ID-prefixed file
names.  That 106-file evidence-name migration is separate mechanical debt: it
must preserve SHA manifests and public replay paths and was not mixed into the
root-executor change.

## Hot-path design

The public executor constructs worker state through `RootKernel::create_worker`
once per participating Rayon worker.  `RootKernel::evaluate` receives only a
mutable worker-local workspace, a stable ordinal, and an immutable root.  It
does not serialize, allocate evidence, inspect environment variables, or touch
another worker's state.

The private projective-grid adapter uses:

- a 40-byte, five-word `repr(C)` bitset with compile-time size/alignment gates;
- iterative fixed-array legality, collinearity, defect, and potential
  computations;
- no recursion and no owned dynamic container in per-root evaluation;
- one presized root vector allocated before parallel execution; and
- an associative fixed-width metrics reduction, so worker completion order
  cannot affect the result.

Root generation remains serial and is included in every timing.  The q=11
worker result is exact at all measured thread counts:

| threads | one-round wall (s) | speedup |
| ---: | ---: | ---: |
| 1 | 5.6285 | 1.00x |
| 2 | 2.9413 | 1.91x |
| 4 | 1.5992 | 3.52x |
| 8 | 1.0782 | 5.22x |
| 12 | 0.7656 | 7.35x |
| 24 | 0.5659 | 9.95x |

The final rebuilt private-package diagnostic measured 1,544 KiB peak RSS at
one worker and 2,060 KiB at 24 workers.  This is dramatically smaller than the
discarded Python process experiment and is the relevant Rust result.

## Correctness

The private independent Python oracle was extended only to reproduce the
Rust xorshift root sampler.  On 1,000 q=11 roots it agrees exactly on all nine
reported fields:

```text
states                         1000
complete exchanges             7138
exchanges with new defects      6652
new defects                    10974
maximum new defects                2
nondecreasing exchanges          242
complete-relation failures         0
support-first failures             0
omega-first failures               0
```

The historical projective Hall certificate also replays unchanged with
SHA-256 `564d92e45dd472beffbf36744baeabbb93e64b89d1ea1a2c3f5a8b69bfb6ed32`.

Validation:

- public `cargo fmt --check`;
- public `cargo clippy --all-targets --all-features -- -D warnings`;
- public `cargo test --all-features`;
- private `cargo fmt --check`;
- private `cargo clippy --all-targets -- -D warnings`;
- private `cargo test --all-targets`;
- exact 1/4-worker unit parity;
- exact 1/24-worker 10,000-root parity; and
- seven interleaved 1/24-worker benchmark pairs.

Raw timing evidence is
`ergodis-private/evidence/projective-grid-parallel-7round.tsv`; the summary is
`ergodis-private/evidence/projective-grid-parallel-summary.json`.  Replay after
building the release binary:

```sh
ergodis-private/scripts/benchmark_projective_grid_parallel.sh \
  target-c985-private/release/projective-grid-scout 7 10000 24
```

## Next gate

The next generic feature is a parallel root control surface: a cache-line
isolated per-worker heartbeat, compiled root-to-plan dispatch, and off-thread
deterministic evidence merging.  The projective-grid and alignment-attachment
adapters should exercise that API from `ergodis-private`; neither domain may
add fields or scheduling semantics to the public executor.
