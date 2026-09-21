# C1194 — min-plus carrier and term-level arithmetic through the Rel lowering

**Lane**: `ergodis`
**Date**: 2026-09-16
**Status**: QUEUED. Ranked third among the Datalog programme's next steps
(`2026-09-16-ergodis-datalog-programme-review.md`); independent of C1192/C1193.
**Gate (C1204 finding F, C1208 triage 2026-09-21)**: do not scope or start before the precursor
design decision — whether the min-plus relational evaluator reuses `Demand`'s plan, index and
workspace machinery or is a second kernel, and what a min-plus relational certificate carries. The
demand path is Boolean with set semantics in the evaluator and in both certificate formats, and
the prepared seam has no carrier or fact cost, so the Deliverable's "the certificate is the
existing min-plus certificate" holds only on the grounded path (two-atom bodies, small bounds).
See `2026-09-21-c1208-c1204-findings-triage-report.md`, decision 1.

## Why

The programme's goal is *recursive exact optimization* with a declarative rule input. The core
already has the bounded-min-plus carrier, its Lean-proved convergence (C1165/C1174) and
certificates, and C1182's demand evaluator on the Boolean carrier. The Rel path, however, reaches
only the Boolean carrier: milestone (a) refuses arithmetic in a term position, milestone (c)
records "min-plus carrier selection is structurally deferred, since the fragment has no term-level
arithmetic". So the optimization half of the goal is unreachable from source. SSSP and connected
components, two of the five benchmark rows step 5 names, need this.

## Deliverable

- Lowering: term-level `+` on integer-typed columns and integer constants, admitted with `REL05xx`
  diagnostics for anything beyond the fragment (multiplication, subtraction, non-integer operands);
  carrier selection per layer (a layer whose head carries a cost column and whose aggregate is
  `min` over a `+` term lowers to the bounded-min-plus program; everything else stays Boolean);
  the u32 sentinel precondition surfaced as a diagnostic, not a silent saturation.
- Core: the demand evaluator or the existing grounded `Prepared` path evaluating the min-plus
  layer; whichever is chosen, the certificate is the existing min-plus certificate and the Lean
  oracle route (C1164) is unchanged. Record which path and why.
- Reference evaluator: min-plus fixed point (naive, over the admitted AST) so the differential
  covers cost programs; generated corpus with seeds.

## Acceptance

- SSSP and CC from Rel source, checked certificates, zero differential disagreements; the
  Addendum A equations still lower; parity gate extended.
- Lowering-stage A/B against `ergodis-tools-e0e7331`: scan/parse/admit unity, lowering cost stated.
- Report with Mystery ledger and the explicit coverage rows (parsed / admitted / lowered /
  executed / certified) for every arithmetic form; audit.

## Out of scope

General arithmetic (multiplication, division), floating carriers, the lifted-real MLM row.
