# The arithmetic Hitchin--Clebsch orientation cover

This directory is the working root for Paper III of the Clebsch program.
The intended final paper has two theorem scales:

1. the arithmetic Hitchin--Clebsch orientation cover, including its exact
   specialization modulo `11`; and
2. the identification of its cubic with the degree-six icosahedral
   Gaunt/Steinhardt channel; and
3. the strongest positive Klein-cubic elevation supported by the exact
   relative-commutant and 55-curve calculations.

The manuscript is deliberately modular while those calculations are open.
That structure controls the trust boundary; it does not lower the target for
the final paper.

## Source

- `clebsch_passages.tex`: manuscript driver.
- `sections/`: one file for each mathematical stage.
- `WORKPLAN.md`: dependency graph, acceptance gates, and drafting order.
- `verification/trust_manifest.json`: live claim/evidence/status ledger.
- `verification/verify_scaffold.py`: structural and ledger validation.

Build from the repository root:

```text
cd papers
make -B clebsch-passages
```

Check the current manuscript and trust scaffold:

```text
python3 papers/clebsch-passages/verification/verify_scaffold.py
```

The scaffold checker is not a release runner.  It returns a non-release
status while C652--C654 remain open.  A release surface will add frozen
statement identity, exact evidence bundles, independent replays, manuscript
warning checks, and archival fingerprints.
