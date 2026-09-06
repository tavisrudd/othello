# Verification

Every theorem in the manuscript has a mathematical proof, and each of the
five exclusions is a hand calculation of the kind shown for `PG(4,7)` in
Section 7.  The deterministic script `check_secant_hyperplane_defects.py`,
its certificate `secant-hyperplane-checks.json`, and the digest
`secant-hyperplane-checks.sha256` replay those calculations and establish
the negative statement that no other parameter set in the scanned domain
is excluded at the counting bound.

From this directory (or from the root of the standalone repository), run

```text
nix shell nixpkgs#python3 --command \
  python3 verification/check_secant_hyperplane_defects.py check
```

The check uses only Python's standard library and exact integer and
rational arithmetic.  It scans every prime power `q ≤ 128` for `d = 3`,
`q ≤ 64` for `d = 4`, `q ≤ 16` for `d = 5`, and `q ≤ 9` for `d = 6`, and
every `k` from the counting bound to twelve above it.  For each `(d,q,k)`
it computes the overlap loss, the admissible set of hyperplane section
sizes, the secant–hyperplane constants, and applies the tests of
Sections 5 and 6 of the manuscript: global character infeasibility (exact
when the admissible set has at most three sizes), secant degree
infeasibility (a dynamic programme), the secant congruence, the bracket
lower bound on every `T_ℓ`, the coverage budget, and the concentration
ceiling, each in its two-sided and one-sided form.  The certificate
records the summary for every `(d,q)`, the full record of every excluded
row, and the five named cases with the intermediate quantities printed in
Table 1 of the manuscript.  The script asserts that exactly the five named
parameter sets are excluded at the counting bound in dimension at least
four, each with a gain of one.

The scan is a trusted execution, not a certificate-checked computation:
the tests it applies are sufficient conditions proved in the manuscript,
and an independent replay consists of running the script and comparing
the digest.  It does not search for caps and proves no existence
statement.  The limits of the scanned domain in dimensions five and six
are set by the running time of the dynamic programme (about forty seconds
in total), not by any mathematical stop.
