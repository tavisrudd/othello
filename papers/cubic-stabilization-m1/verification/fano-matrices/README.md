# Fano counting matrices

The nine detected families use the full rank-four even Euler matrices printed
in the manuscript. The finite checker additionally retains eight control rows
and optional rank-three jet checks. Rank-two residues, whole primary ranks and odd dimensions enter the
classification and Hodge conservation theorems. The geometric identification
of the four index-one genus-two-through-five matrices also uses the
reconstruction criterion described below.

From the paper root, with SymPy 1.14.0:

```
uv run --with sympy==1.14.0 python verification/fano-matrices/finite_checks.py --check
python3 verification/fano-matrices/independent_checks.py --check
python3 verification/fano-matrices/reconstruction_check.py --check
uv run --with sympy==1.14.0 python verification/fano-matrices/source_check.py --source-dir SOURCE_DIR
sha256sum -c verification/fano-matrices/SHA256SUMS
```

Obtain `fano_threefolds_rk1index1.py` and `fano_threefolds_rk1index2.py`
from https://doi.org/10.5281/zenodo.20625923 into SOURCE_DIR. Their exact
SHA-256 values are checked before execution by source_check.py. The comparison
checks 15 entrywise matrix normalizations and period coefficients through
degree eight against independently transcribed CCGK formulas/tables. It
neither downloads nor executes any other program implicitly.

All calculations use rational arithmetic, deterministic input order and no
random seed. finite_checks.py uses SymPy projectors and reduced inverses;
independent_checks.py uses only Python Fraction, elimination, explicit Jordan
frames and Faddeev--LeVerrier characteristic polynomials. Both must report PASS.
The latter checks all 17 characteristic polynomials, cyclicity and nine
rank-two residues; the optional rank-three jet checks have no independent
implementation here and are not premises of the two main theorems.

The two --check commands compare regenerated data without changing the JSON
certificates. Omit --check to regenerate their adjacent certificates. SHA256SUMS pins the
scripts, certificates and this explanation. These are trusted exact executions
with an independent implementation, not Lean kernel proofs. No script proves
geometric identification, the GW formulas, deformation, classification,
comparison faithfulness, surface vanishing or Hodge descent. The small tables
require no specialized hardware.

## Reconstruction premise for genera two through five

Przyjalkowski, arXiv:math/0410327v4, Proposition 6.2.2, recovers the
five-coefficient index-one counting matrix from normalized period coefficients
of degrees two through six when its displayed discriminant is nonzero.
The geometric period input is CCGK, arXiv:1303.3288v3, Corollary D.5 and
Proposition D.9 as applied in Sections 8--11. The manuscript checks their
ampleness/divisibility and normalization assumptions explicitly.

`reconstruction_check.py` uses Python 3's standard library and exact Fractions.
It reads only literal entries for these four families from finite_checks.py
and the regularized period inputs from source_check.py, without executing
either script. After subtracting the scalar Euler shift it solves the counting
matrix differential recursion through degree eight. Independently, it checks
the degree-two-through-four formulas in the source's Example 5.4 and the
reconstruction discriminant by clearing factorial denominators to an integer
polynomial. It also checks externally supplied nonzero residues for genera
2, 3, 4, 5: respectively 7 modulo 19, 3 modulo 13, 9 modulo 11, and 4 modulo 7.
These regression values are recomputed directly in the finite fields from
the period inputs. The last two source terms are `432*d4^2 + 56*d2^4`;
their coefficients must not be transposed. The JSON pins its input hashes
and records the exact results.
The `--check` mode compares regenerated data without writing; omit it to
regenerate the certificate. This is a trusted exact execution with explicit
cross-checks, not a proof of the imported geometric periods or reconstruction.

The certificate field `O3` is the full odd dimension on even-rank-three
primary factors. It is twice `h21` for the four relevant Fano rows:
104, 60, 40, 28 in genera 2, 3, 4, 5. Explicit regression assertions check
these values and zero for all other rows. This is the manuscript's
normalization; the separate Lean numerical ledger uses half this dimension.
