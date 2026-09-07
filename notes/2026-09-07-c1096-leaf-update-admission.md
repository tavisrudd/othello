# C1096 — Domain-checked leaf updates

**Lane:** ergodis. **Date:** 2026-09-07. **Status:** complete. Private commit `b6307ed`.

## Decision and scope

Before extracting generic transition certificates into core, make their missing domain obligation
executable against the existing LRC fleet. The private cold module `lrc_update_admission` checks
that a proposed after-state actually follows from a stated event and that its proposed leaf
summary evaluates that after-state. It mints an opaque in-memory `CheckedLeafUpdate`. Applying the
token first compares current schema and source leaf parameters, then invokes existing retained-tree
rebind mechanics. Stale or malformed claims cannot partially mutate the tree through this API.

The checker executes event mutation separately from the tree's mutation method, while summary
evaluation still uses the same existing `pod_summary` kernel. This is domain-transition admission,
not an independent optimality certificate. No caller-provided summary is installed into the tree.
The application deliberately recomputes it. A future independent summary checker needs a separate
implementation and declared algebra/source assumptions; a table commitment is insufficient.

## Admitted arithmetic and event family

Supported events change one pod's capacity, availability or demand. Structural events require
recompilation. Reject invalid pod/domain indices, wrong boundary width, zero pod count, unknown
availability bits and budget grain whose maximum level multiplication overflows u32. The maximum
leaf cost remains bounded by u16 demand times 100 plus three budget levels times seven.

This opt-in contract additionally rejects capacity top-ups that would saturate, matching the prior
literal-budget query admission. It is deliberately narrower than the legacy evaluator, which
saturates. Both source and result must fit this contract; moving a previously out-of-contract
source into it requires rebinding/recompilation through a separately admitted path. Nothing changes
the legacy evaluator's behavior or accepted input domain.

## Reuse and identity

A token binds schema, leaf, before and after. It does not bind a process, run ID or global revision.
Changes to other leaves do not invalidate a leaf-local transition. The same schema/source on a
second tree permits reuse; returning to the exact old state also permits it. This is semantic
precondition checking, not exactly-once delivery, ABA prevention or a persisted event receipt.
Runtime delivery/revision rules stay in the control bounded context above the solver.

The wrapper works for value-only and witnessed FleetTree instantiations without changing either
hot layout or loop. It is a separate compilation unit, contains no new serialized format, and
remains private because its semantics are domain-specific. Existing generic tree/certificate
machinery is not copied or moved.

## Validation

Passed 13 integration tests across `leaf_update_admission` (six), `composition_construction`
(two), `semantic_contract_lrc` (three) and `semantic_contract_updates` (two). Library and new-test
clippy pass with warnings denied; changed Rust files pass formatting. The new corpus checks all
three event kinds in value-only and witnessed modes against fresh rebuilt roots, forged after/
summary rejection, schema/source mismatch with no mutation, unrelated-leaf reuse, malformed
availability and indices, excessive grain, the maximum safe grain, and availability-dependent
capacity overflow.
Parent owns the single build window; Luna implements integration tests and Terra audits bounds.
No performance claim; no existing hot function, record or constructor changed.

## Next

Extract independent summary-transition checking with explicit source/event prerequisites and
mutation rejection. Keep event admission, summary composition validity, claim coverage, search
mode and provenance as separate obligations. Avoid a universal trait before a second concrete
adapter establishes common semantics.

Replay from `ergodis-private`:

```sh
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy --command cargo clippy -p ergodis-private --lib -- -D warnings
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy nixpkgs#rustfmt --command bash -c 'rustfmt --edition 2021 --check src/lrc_update_admission.rs tests/leaf_update_admission.rs && cargo clippy -p ergodis-private --test leaf_update_admission -- -D warnings && cargo test -p ergodis-private --test leaf_update_admission --test semantic_contract_updates --test semantic_contract_lrc --test composition_construction'
```

Captured logs under `/tmp/claude-run-quiet/`: library lint `20260907-114505`, final
integration gate `20260907-114719`, cache dry run `20260907-114734`. No cache entries removed.
The first test draft had lint issues and an incorrect expected error for a forged after-state;
these were corrected before acceptance, with invalid-source availability tested separately.
Core/WASM sources and kernels are unchanged; no new WASM support claim or benchmark measurement.

## Closeout judgment

The useful extra is semantic leaf-local reuse: changing an unrelated leaf does not invalidate
this transition. That behavior is now tested and distinguished from runtime revision checking.
No incidental discovery needs logging. The remaining gap is an explicitly independent checker
for composed summaries, not a mystery about the admitted event relation.
