# Clebsch → quantum: reproducibility bundle

Prepared 4 September 2026 for Tavis Rudd.

Start with `clebsch_quantum_research_memo.md`. It gives the mathematical derivations, explicit quantum codes and gates, exact error formulas, limitations, and source references. The Markdown uses LaTeX mathematics.

## Files

- `clebsch_quantum_research_memo.md`: complete research memo.
- `clebsch_quantum_verify.py`: reconstructs the two configurations from their base matchings and performs the finite-field checks.
- `weight_enumerator.cpp`: specialized exact subset-rank enumeration for the two signed-self-dual codes.
- `clebsch_quantum_data.json`: generated matrices, ordered matchings, phase polynomials, algebraic certificates, complete weight enumerators, minimum-weight witnesses, and numerical error examples.
- `SHA256SUMS`: checksums of these files, excluding the checksum manifest itself.

## Running the checks

Python 3.10 or later is required. Basic algebraic checks use only the standard library:

```sh
python clebsch_quantum_verify.py --output recomputed.json
```

Recomputing the complete weight enumerators additionally requires `g++` or `clang++` with C++17 support:

```sh
python clebsch_quantum_verify.py --enumerators --output recomputed.json
```

For an independent direct enumeration of all 823,543 classical codewords over F_7, install NumPy and run:

```sh
python clebsch_quantum_verify.py --enumerators --bruteforce-seven --output recomputed.json
```

The last command was executed successfully to generate the included JSON. A default run omits weight enumerators and related noise data. Do not run Python with `-O`: the mathematical verification conditions are assertions. The C++ program is a specialized component, not a general arbitrary-code enumerator; its complementary-subset shortcut uses signed self-duality, which the Python driver checks first.

All finite-field calculations are exact. Noise examples use 45-digit decimal arithmetic. No network connection or original manuscript checkout is required to reproduce the finite computations.

On systems providing `sha256sum`, verify package integrity with:

```sh
sha256sum -c SHA256SUMS
```

## Scope

The checks establish the concrete algebraic calculations, not an independent formal proof of every prose argument. The memo distinguishes proofs, exhaustive finite computations, literature background, and open research tasks. It does not claim optimal synthesis costs, novelty priority, a circuit-level fault-tolerance threshold, or competitive hardware performance. Its error-suppression numbers assume independent input Z errors and ideal Clifford operations.
