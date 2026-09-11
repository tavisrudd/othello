# C1016: shrinking private tabu state machines

Authority: `~/src/ergodis-worktrees/c1016-full-2092/ergodis-private`.
Implementation and validation: `evidence/state-machine-properties-report.md`.

Four proptest properties exercise eight scopes: Carrier Fibre/Column, Phase
Full/Q58/Q87/Q174, Margin Fibre and Q29 margin. Each generates 32 cases with
1–12 mixed steps, explicit kicks and resets, with a 2048-iteration shrinking
budget. A shared independent specification recomputes direct cyclic scores,
preserved projections/inventories, strict best witnesses and reset epochs.
All current, intermediate and best states receive explicit domain checks.

The test oracle uses no optimized delta or score calculation. Raw transformations
replay kick draws, with CRT indices reconstructed from their defining congruences.
Q29 inputs satisfy energy 2020 before search. No successful target or trajectory
is supplied. The independent red-team found no blocking issue after the requested
domain checks were added. Test-only modules and dev dependencies leave production
hot loops unchanged. No new native performance claim is made.

Persistent failure seeds and compact initial-bit/action diagnostics support replay;
real minimized failures should also become concrete deterministic regressions.
The first scoped run passed all four properties in 32.62 seconds. Final gate
results and implementation checkpoint follow below.

## Remaining coverage

Step checks state consistency, not an independently enumerated best legal move.
Stall=0 deliberately excludes automatic-kick triggers, tabu expiry/clearing and
aspiration policy. Explicit transfer/twist actions and mid-run objective changes
remain open. Generated tests supplement the existing deterministic intermediate
best-state regressions; they do not guarantee every important event in each run.

## Mystery ledger — ej + tt

- Settled: a single raw-state specification can cover all eight scopes without
  coupling correctness to optimized score or delta code.
- Open: validate automatic kicks and tabu policy against a small reference state
  machine before extending that coverage claim.
- Cheap upgrade retained: save minimized concrete failures alongside seed replay,
  since generator evolution can change what a saved seed generates.
- The scientific recovery gate at 14,800 is unchanged. No search-quality gain,
  matrix construction or negative coverage result follows from these tests.

Final gate: **769 passed, 0 failed, 1 ignored** (explicit performance driver).
Private implementation checkpoint: `b966a7d`. The user's next priority is now
usable order-2092 structure; the remaining policy properties stay an open gap.
