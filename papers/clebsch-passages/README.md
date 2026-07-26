# The arithmetic Hitchin--Clebsch orientation cover

This directory is the working root for Paper III of the Clebsch program.
The intended final paper has two theorem scales:

1. the arithmetic Hitchin--Clebsch orientation cover, including its exact
   specialization modulo `11`; and
2. the identification of its cubic with the degree-six icosahedral
   Gaunt/Steinhardt channel.

The exact Klein relative-commutant test closed negatively and its detachable
section has been removed.  This does not change either theorem above.

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

The scaffold checker is not a release runner.  A release surface will add frozen
statement identity, exact evidence bundles, independent replays, manuscript
warning checks, and archival fingerprints.
