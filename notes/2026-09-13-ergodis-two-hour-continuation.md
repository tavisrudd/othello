# Ergodis — two-hour continuation, 2026-09-13

**Lane**: `ergodis`
**Window**: 05:24:50–07:24:50 UTC; user-authorized lane-wide queue work.

## Completed queue slices

- C1154: owned offline feature intervals, successful-value/error-domain audit
  and directed-identity weak-term-acyclicity check. Private `89f7ccf`; report
  `2026-09-12-c1154-feature-intervals.md`. Conservative false positives are
  explicitly allowed; selected-root simplification must preserve totality.
- C1159: opt-in completion screen, independent no-false-rejection gate and
  retained interleaved performance evidence. Source `be611e9`, evidence
  `8b79a73`; report `2026-09-12-c1159-completion-screen.md`. Frozen development
  workload: about 11% less search time at one/three workers, 92.8% of index
  lookups removed. Corrected unchanged-kernel null passes. No default adoption
  or broad-workload performance claim.
- C1155: exact wide min-plus costs, potential normalization and finite weighted
  bisimulation/quotient audits. Private `73e1d29`; report
  `2026-09-13-c1155-weighted-normalization.md`. The existing core already has
  the exact coarsest quotient compiler; the C1151 study is corrected.
  No duplicate quotient backend or global weighted-language minimum claim.

## C1170 remains active

Owned parser/diagnostic checkpoint `cfae073`, native/WASM and review fixes
`a644dad`, diagnostic/stress refinement `6290979`, final allocation and canonical-record census `9cdc124`. The report is
`2026-09-12-c1170-owned-rel-frontend.md`; replay artifacts live under private
`analysis/rel-frontend/`.

Thirteen frontend tests and the native probe pass, strict scoped Clippy passes,
and 142 native/WASM cases produce identical full canonical records and rendered
diagnostics. All 16,105 short expression suffixes in the declared stress domain
pass span/progress checks. Prepared repeated parsing, including the newly fixed
lexer paths, remains allocation-free. These are prototype gates: semantic
admission, full Rel syntax, rich recovery trees and parser speed measurements
remain open. Tree-sitter and executable reference semantics remain deferred.

Next highest-value gate is retained parser/diagnostic performance with setup,
UTF-8 validation, materialization, error enrichment and source/pool ownership
accounted separately. The storage census motivates that boundary: about 14.9×
source bytes in occupied syntax records on the 512-definition fixture. This is
logical record size, not measured traffic or resident memory.

No Lean commands, foreign evaluator adoption, publication or push occurred.
Foreign campaign-console/interface edits were preserved. Completed task rows
were archived and removed from the live queue; C1170 remains allocated/open.


Final bookkeeping verifies each closed row is archived exactly once and absent
from the live queue; C1170 is still in progress. All eight final parser receipt
source hashes match. The task-close cache-GC audit completed in dry-run mode;
no cache entries were deleted. Owned source and report paths are committed.
