# C1016: matched candidate-selection and escape comparison

Private native authority: `~/src/ergodis-worktrees/c1016-full-2092/ergodis-private`, checkpoint `b417e8d`. Frozen protocol: `154c669`; implementation: `48593b9`. Full evidence, hashes and replay commands: `evidence/margin-escape-report.md` in that authority.

Matching disabled kicks and tenure support does not remove the sampled policy’s deficit on these development controls.

| Arm | Improved runs / 48 | Best score |
|---|---:|---:|
| Sampled, no kicks, tenure 6–12 | 0 | 23,152 |
| Full neighbourhood, no kicks, tenure 6–12 | 14 | 23,152 |
| Full neighbourhood, no kicks, tenure 6–11 | 26 | 23,152 |
| Existing full tabu defaults | 29 | 22,736 |

These are twelve source/seed pairs repeated in four balanced rotations, each with twenty thread-CPU seconds. They are not 48 independent starts. Matching tenure support does not match RNG consumption, tie ordering or candidate coverage per CPU second. No default tuning or general superiority claim follows.

Validation: 753 release workspace tests; 384 independently replayed best/final witnesses; four artifact mutation tests; CLI admission and actual configuration checks; hardware counters retained for every arm. Hot solver sources are byte-identical to the preceding checkpoint. No public core, WASM or live demo changes.

## Correctness frontier

Review found that the existing tabu kick can pass through a better state without retaining it. This is a code-level defect; this experiment did not demonstrate an actually lost solution. The frozen default comparator was left unchanged; both no-kick comparisons avoid the defect. The report `evidence/tabu-kick-retention-gap.md` specifies the repair, independent trajectory regression and native performance gates.

## Next decision and mystery ledger

The next priority is to retain best states throughout kicks, with a non-vacuous independent trajectory test. Then profile exact candidate selection before investing in a residual index: the current full kernel already maintains correlation/Gram information, and index refresh may cost more than scanning.

The ej/tt pass settled one confound: missing kicks and tenure-support differences alone do not explain the sampled deficit on this corpus. Selection coverage, ties and RNG effects remain unresolved. The known-containing-fibre recovery gate remains approximately 14,800; none of these policies passes it. No order-2092 matrix or negative coverage result was obtained. Broader transfer remains untested.
