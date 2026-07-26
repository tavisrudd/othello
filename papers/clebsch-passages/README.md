# The Clebsch orientation cubic

This directory contains Paper III of the Clebsch program.  Its main theorem
has two legs:

1. the arithmetic Hitchin--Clebsch orientation cover, including its exact
   golden-fibre specialization modulo `11`; and
2. the identification of its cubic with the degree-six icosahedral
   Gaunt/Steinhardt channel.

The exact Klein relative-commutant test closed negatively and its detachable
section has been removed.  This does not change either theorem above.

## Source

- `clebsch_passages.tex`: manuscript driver.
- `sections/`: one file for each mathematical stage.
- `WORKPLAN.md`: dependency graph and acceptance criteria.
- `verification/trust_manifest.json`: claim/evidence/status ledger.
- `verification/statement_identity.json`: frozen theorem surface.
- `verification/verify_release.py`: aggregate release gate.

Build from the repository root:

```text
cd papers
make -B clebsch-passages
```

Check the manuscript and complete trust surface:

```text
python3 papers/clebsch-passages/verification/verify_release.py
```

The mod-\(11\) assertion concerns the displayed golden fibre and its
integral exchanger.  It does not assert that the full geometric incidence
comparison has good reduction at \(11\).
