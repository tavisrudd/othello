# ergodis Python reference layer

The production solver and public CLI are the Rust crate one directory above.
This directory contains transparent reference algorithms, differential-oracle
fixtures, benchmark controls, and evidence generators used to audit ergodis.
It is intentionally secondary to the Rust interface.

The `recovery_algorithms` package implements direct finite-field and
combinatorial formulations. Its simple representations make it useful for
independent checking on bounded instances; they are not the high-performance
execution path.

## Run the reference tests

From the ergodis root:

```text
nix shell nixpkgs#python3 --command python3 python/test_algorithms.py
nix shell nixpkgs#python3 --command python3 python/generate_fixtures.py --check
```

`generate_fixtures.py` compares the reference algorithms with the canonical
Rust fixture in `tests/fixtures/python_span_cases.json`. The corpus includes
small-field exhaustive checks, labelled composition, exact confinement, GF(4)
transfer witnesses, orbit search, and capacitated scheduling.

## Evidence and controls

- `generate_evidence.py` regenerates or checks the exact mathematical evidence
  bundle and `SHA256SUMS`.
- `run_benchmarks.py` runs the interleaved Rust/control protocols documented in
  `../BENCHMARKS.md`.
- `benchmark_python.py` contains the CP-SAT, HiGHS, CryptoMiniSat,
  Graphillion, max-flow, and direct-reference controls.
- `verify_baseline_encodings.py` checks that the formulation-specific controls
  encode the same bounded application examples.
- `gf27_defect_cpsat.py` is the conditioned GF(27) comparison model.
- `run_c997_gurobi.py` replays the three committed C997 Gross-code
  formulations with single-threaded Gurobi, streams logs/evidence to files,
  validates the source action and quotient algebra, and exactly replays every
  returned witness. `check_c997_gurobi.py` checks the retained JSONL evidence
  and reports same-backend node, work, iteration, and wall-time ratios without
  requiring Gurobi.
- `check_c997_parity_ab.py` checks the retained C997 physical-parity A/B. The
  adapter exposes binary-slack, exhaustive forbidden-set, compact cascaded, and
  root-cut controls; the latter three are research controls, not production
  defaults.
- `analyze_c997_support_orbits.py` derives the complete translation orbit of
  retained C997 witnesses, replays every translated support, and measures the
  exact multiplicity left by coordinate anchoring.
- `export_c997_native.py` exports the verified C997 matrices, orbit anchors,
  and a replayed incumbent to the native sparse CSS-distance interface.
  `check_c997_native.py` independently replays the native witness and reports
  cold and warm speedups against the retained single-threaded Gurobi control.
- `generate_bb_native.py` constructs published bivariate-bicycle codes directly
  from their two torus polynomials, checks commutation and ranks, derives a
  quotient-observation basis, and emits a sparse native input without a matrix
  download. `export_bb_native.py` also exposes the BB360 and BB756 controls to
  the independent `bposd` construction.

For normal use, installation, commands, JSON examples, and output semantics,
start with `../README.md`.
