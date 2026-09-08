# Explicit recovery examples

From the paper root, run `python3 verification/replay_examples.py --check`.
To regenerate the canonical certificate and its checksum manifest, run the
same command with `--write`. Python 3.11 or later and its standard library
are sufficient. No external algebra package or Lean run is involved.

The release gate runs this read-only replay and compares the displayed TeX
matrices with the certificate, so numerical edits cannot silently drift.
`explicit-examples.json` gives two 4-by-10 generator matrices over the prime
field of order 101. Column 0 is the target; columns 1 through 9 are helpers
labelled 0 through 8 in the manuscript. The five four-column circuits through
the target are exactly the stated radius-three repair families. All helper
quadruples and all triples of columns are independent. Consequently the code
has rank four, dual distance four, and minimum distance six: any hyperplane
contains at most four columns, and a displayed target circuit attains four.

The deterministic construction chooses the first admissible projective points
in the declared coordinate order, then tests at most 10000 height vectors
from Python's seeded pseudorandom generator (seeds 1938 and 2005). Exhaustion
raises an error; it is not evidence of nonexistence. Gaussian elimination checks
the construction. An independent permutation expansion of every square minor
crosschecks all 120 triples and 210 quadruples for each matrix. Enumerating all
512 availability subsets per matrix checks the radius-three reliability
difference. No exhaustive enumeration of all codewords is claimed.

The same script enumerates all 2048 binary helper coefficient choices in each
of the two twelve-coordinate hierarchy scenarios, checks the recovery equation,
and compares its optimum with the two-branch composition calculation. The
printed example uses zero-based certificate helper indices 1 for its initial
repair and 4,8 for the repair after failure (coordinates a12 and b11,c11).

`explicit-examples.checksums.json` records SHA-256 hashes and byte counts for
the generator, canonical output, and this report. The checks are trusted Python
executions with the independent minor and direct-enumeration crosschecks stated
above. They audit concrete illustrations; the general existence, confinement,
composition, and reliability-separation theorems have independent human proofs.
