# C1192 — sparse join index in the demand evaluator, with an exact crossover policy

**Lane**: `ergodis`
**Date**: 2026-09-16
**Status**: QUEUED. Rule-contract programme step 4a (engine). Ranked first among the Datalog
programme's next steps (`2026-09-16-ergodis-datalog-programme-review.md`).

## Why

The demand evaluator's join index is direct-addressed: `domain^arity` keys against
`MAX_INDEX_KEYS = 2^24`. That is the bound that now decides the negation/comparison reach on two
of C1191's four cohorts, and it also caps every binary relation at a domain of 4,096 values and
every ternary one at 256, whatever the relation's actual size. No real workload (a graph of 10^5
vertices is a binary relation over 10^5 values) fits under it. C1182 recorded "exact crossover
unmeasured; a hashed variant is a separate change". This is that change.

## Deliverable

- A second index kind in core `crates/rules/src/demand.rs` for relations whose key universe
  exceeds the direct-addressed budget (or whose density is below a measured threshold): open
  addressing or a sorted CSR with binary probe, presized from the relation's known row capacity,
  allocation-free and call-free in the derivation loop, Tiger layout, one asserted stride.
- A selection policy made once at preparation from the relation's universe and expected rows,
  with the crossover measured, not guessed; the decision recorded in the prepared plan and
  readable from the CLI/report.
- `MAX_INDEX_KEYS` stops being a program-level refusal; the replacement bounds (rows, memory)
  are named with numbers.
- Same certificates, same checkers, closure SHA-256 identical to the direct-addressed path on
  every existing cohort and fixture; C1189 differential zero disagreements.

## Acceptance

- Allocation regression entering the derivation loop repeatedly at zero; kernel-scoped profile
  with every out-of-line call listed.
- Interleaved A/B against the retained control (`ergodis-tools-e0e7331` for the frontend path,
  and the private Datalog harness's retained control for the closure/same-generation families)
  on all existing cohorts; the direct-addressed path must not move where it is still selected.
- New cohorts beyond the old reach: closure and same generation at N = 16,384 and 65,536, the
  C1191 boundary cohorts (`stratified`, `columns`, `columns3`) pushed until the next bound binds,
  with that bound named; peak RSS on each.
- Report in the playbook's shape with a Mystery ledger; independent read-only audit.

## Out of scope

Bodies of more than two atoms (C1193); the certificate encoding (C1196); the layer memory model
(C1191 remaining gap 4, unallocated).
