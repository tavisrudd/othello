# Fano counting matrices

The nine detected families use the full rank-four even Euler matrices printed
in the manuscript. The finite checker additionally retains eight control rows
and optional rank-three jet checks. Only rank-two residues and whole primary
ranks enter the classification and Hodge conservation theorems.

From the paper root, with SymPy 1.14.0:

```
uv run --with sympy==1.14.0 python verification/fano-matrices/finite_checks.py --check
python3 verification/fano-matrices/independent_checks.py --check
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
