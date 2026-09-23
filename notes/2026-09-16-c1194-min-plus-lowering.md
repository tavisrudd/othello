# C1194 — min-plus carrier and term-level arithmetic through the Rel lowering

**Lane**: `ergodis`
**Date**: 2026-09-16
**Status**: QUEUED. Ranked third among the Datalog programme's next steps
(`2026-09-16-ergodis-datalog-programme-review.md`); independent of C1192/C1193.
**Gate (C1204 finding F, C1208 triage 2026-09-21)**: satisfied 2026-09-23 by the
C1211 architecture decision (`2026-09-22-c1211-min-plus-design.org`). Tavis delegated
the choice with an opt-in certification/performance constraint. Implement a separate
weighted relaxation kernel that shares cold admission and join/index shapes with
Boolean Demand where measured safe. Use a detached source/result-bound value
certificate: the independent checker reconstructs support and checks closure
from the canonical prepared source and ordinary result. Do not add a witness,
rank, certificate branch, hash or proof row to the weighted evaluator hot path
or normal result. Measure evaluator and checker costs separately, including
opt-in evaluator code shape and byte-for-byte ordinary result. The existing
grounded min-plus certificate does not apply to the relational path.

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
- Core: implement the selected weighted evaluator and detached value certificate.
  The checker independently proves source-rooted finite support and global
  closure; an envelope without a successful check is only a claim. Preserve
  the existing Lean oracle route (C1164) and record the relational claim.
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
