# Prime-field AME recognition

This reference implementation solves the compact symplectic recognition problem
in the paper's fast prime-field recognition corollary. It returns exact local
symplectic frames; it does not construct dense Clifford matrices or perform the
subsequent stabilizer-character repair.

## Run

Python 3.10 or newer is sufficient; no third-party package is required.

```sh
python3 recognition.py --input example.json --seed 1139
python3 recognition.py --input example.json --decision-only
python3 test_recognition.py --check
python3 bundle.py --check
```

The example is the paper's four-qutrit state compared to itself. Omit `--seed`
for system-provided randomness. A fixed seed is for reproducibility; it is not
part of the theorem's uniform-random runtime model.

## Input and output

Input is one JSON object containing `prime` and either:

- `G`, `H`: square arrays of invertible two-by-two party blocks. Each block is
  a four-element row-major array `[a,b,c,d]`; or
- `check_G`, `check_H`, `half`: full stabilizer check matrices and an ordered
  list of half the parties. Rows are labels; columns are interleaved
  `(x_0,z_0,x_1,z_1,...)`. The complementary party order is increasing.

For `n=2m` parties, each check matrix has `2m` rows and `4m` columns.
Primality, stabilizer isotropy, full rank and the AME property are **input
promises**. The implementation checks shapes, invertibility of party blocks
and the chosen half projection, but is not a primality or AME recognizer.
The domain is prime local dimension, not arbitrary prime powers.

Output contains `equivalent`. With a positive answer, construction mode adds
`row_frames` and `column_frames`, which satisfy

```text
row_frames[i] * G[i][j] = H[i][j] * column_frames[j]
det(row_frames[i]) = det(column_frames[j]) = 1.
```

These identities are checked before returning. The decision is deterministic;
the witness procedure is Las Vegas: all answers are exact and only runtime
is random. A negative result on arbitrary invertible block arrays refers to
this block-equivalence problem; the LU interpretation requires the AME promise.
Party permutations are not searched.

## Algorithm and cost

Solve the homogeneous intertwining equations in four matrix entries. Restrict
`det` to that solution space. In odd characteristic diagonalize the quadratic
form: rank zero has no solution, rank one needs a square-class test, and rank at
least two always represents one. Sampling a binary subform and using Cipolla's
square-root method constructs a witness in expected `O(log q)` field operations.
At `q=2`, at most sixteen matrices suffice.

The complete arithmetic cost is `O(m^3+log q)` from check matrices, or
`O(m^2+log q)` from systematic matrices; the construction bound is expected.
With schoolbook arithmetic and `b=ceil(log_2 q)`, a sufficient bit bound is
`O(m^3 b^2+b^3)`. The mathematical proof is in the manuscript. The quadratic
and square-root steps are classical methods; the README of the paper and its
bibliography give the literature context.

## Tests and evidence boundary

`test_recognition.py --check` repeats a seeded exact test suite and compares
canonical output to `test-results.json`. It includes every subspace of
`M_2(F_q)` for `q=2,3,5,7`, every single-matrix pair for `q=2,3`, random
simultaneous tuples and invertible block arrays, genuine CSS AME states and
large-prime witnesses. Exhaustive reference routines enumerate vectors or
local frames directly; they do not use the production quadratic reduction or
cycle equations. Unit tests additionally cover square roots, redundant bases,
a nonzero polar form with zero initial diagonal, singular forms, malformed
shapes, and the command-line interface.

This finite evidence checks the implementation; it is not a proof for all
fields or all AME states. `test-results.json` records exact domains, counts
and witness digests, with seed 1139. There is no wall-clock speed claim.
`bundle.py --check` verifies byte counts and SHA-256 identities for the
implementation, tests, example, documentation and output.

To intentionally regenerate after a reviewed code change:

```sh
python3 test_recognition.py --write
python3 bundle.py --write
python3 test_recognition.py --check
python3 bundle.py --check
```

No command modifies a supplied input file, publishes data or invokes Lean.
