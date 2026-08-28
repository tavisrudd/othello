# C987 observational application integration

**Lane**: `complete-ports`

**Date**: 2026-08-28

## Goal

Determine whether C983's observational compiler accelerates an existing
ergodis recovery or resource-optimization workflow rather than only its
standalone minimization benchmarks.

## Acceptance gate

- Select an existing repeated application subproblem with exact witness use.
- Integrate through the existing typed observational API without duplicating
  domain logic or weakening verification.
- Preserve deterministic outputs and an independent oracle/parity route.
- Measure build cost, repeated-query cost, peak memory, and reuse break-even.
- Retain a production path only on a favorable application-level result;
  otherwise keep at most a benchmark/control and state the bounded negative.
- Make no manuscript, mirror, export, push, deposit, or public-surface change.

## Initial hypothesis

The best candidate is a repeated finite resource or recovery interface whose
syntactic state table has equivalent rows. One-time quotient compilation can
pay off only if downstream composition or query replay avoids enough repeated
state work to amortize compilation and proof verification.
