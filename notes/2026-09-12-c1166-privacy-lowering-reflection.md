# C1166 — kernel-checked finite privacy lowering

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: COMPLETE. Generic proof support `f144c82aa`; private proof/evidence `5446efb`.

Import the retained finite privacy lowering certificate into Lean and connect
its tables to independently stated packed binary observation semantics. Reuse
the existing symbolic event-square and trace theorems. Generic checked-table
support belongs under `othello/lean/WeightedRules`; family data and its formal
instance stay under `ergodis-private`.

The concrete family has 256 subsets of eight binary linear observations, eight
append events and 16 joint-span summaries. The existing 15-state privacy readout
quotient is an additional closeout target if its semantic gate fits this slice.
No Rust implementation, subprocess or parser becomes a theorem assumption.
The retained certificate remains untrusted data; finite checks use ordinary
kernel reduction. No toolchain upgrade, public export or live runtime change.

## Delivered

Generic modules under `lean/WeightedRules/`:

- `FiniteTableImport.lean`: `nat_table_from_json` embeds only bounded natural
  literals from a file-relative JSON object path. Reading stops after at most
  one MiB plus one rejection byte, with 65,536-entry and 32-bit numeric limits.
- `FiniteLoweringReflection.lean`:
  `WeightedRules.EventLowering.checkLoweringCertificate_sound` and
  `WeightedRules.EventLowering.CheckedLowering.trace` prove the supplied square
  and arbitrary finite trace transport after exact coverage and range checking.
- `ReadoutMinimality.lean`:
  `WeightedRules.EventLowering.separated_readouts_card_le` proves a cardinality
  lower bound for every finite deterministic summary preserving a source readout,
  from any family of pairwise trace-distinguished representatives.
- `FiniteLoweringChecks.lean`: a complete parity control, five rejected
  coverage/range/semantic cases and six malformed JSON table controls.

Private authority: `ergodis-private/lean/PrivacyLowering.lean`.
`BinaryPrivacy.joint_exact_determination` proves the meaning of every imported
joint-summary row against all physical worlds; `BinaryPrivacy.jointCertificate`
and `BinaryPrivacy.readoutCertificate` check both complete 2,048-cell squares.
`BinaryPrivacy.semanticPrivacyReadout` is defined solely by physical-world
agreement, without any imported table. `BinaryPrivacy.privacyReadout_exact`
connects the table readout to it. `BinaryPrivacy.privacy_semantic_trace` proves
preservation after every finite append trace.

`BinaryPrivacy.privacy_summary_card_lower_bound` proves that every finite
deterministic summary commuting with append and preserving that independently
defined readout has at least fifteen states. Fifteen representatives and their
empty/one-event separating traces supply the injection. The checked fifteen-state
certificate attains the lower bound. No enumeration of alternative summaries or
assumption that they use the same representation is needed.

## Validation and reproducibility

Generic gate: `run-20260913-034358-a745e273`,
`WeightedRules.FiniteLoweringChecks`, with all imported modules trace-current.
Private guarded elaboration through `scripts/check_privacy_lean.sh` passes in
about 42 seconds. Its retained nineteen-terminal audit and fourteen exact source
inputs, with SHA-256 and byte counts, are in private
`evidence/2026-09-12-privacy-lean.json`. Replay, generator and exact trust scope:
private `evidence/2026-09-12-privacy-lean.md`. The independent Python
physical-assignment oracle agrees with both certificates and minimality controls.

Private audit: the cardinality lower bound uses only propext, Classical.choice
and Quot.sound; all other terminals use subsets of propext and Quot.sound, with
both table-coverage terminals axiom-free. No sorry, native-decision or
foreign-process axiom occurs. The generic checker/trace and parity/rejection
terminals use only propext; its cardinality theorem uses standard logical axioms.
Every new Lean module was reviewed in full for semantics, docstrings and trust
claims. The private certificate and formal instance stay private.

## Mystery ledger — ej + tt

After the main semantic/minimality gate passed, the closeout pass formalized
the explanation for 16 versus 15 and the failure of the tempting current-readout
summary:

- Settled: `BinaryPrivacy.joint_summary_collapse` identifies exactly the two
  already fully leaked joint states; `BinaryPrivacy.readout_factors_joint`
  transports this comparison to all sources.
- Settled: `BinaryPrivacy.no_current_readout_square` rules out every deterministic
  update on the current leakage readout alone. Observing r versus nothing and
  then appending s+r is the exact witness.
- Settled: certificate import alone would not establish source semantics. The
  independent physical-world readout and its kernel-checked equality close that
  gap for this finite model.
- Boundary: no claim about Rust correctness, costs, observation order, duplicate
  multiplicities, unbounded source families or an external IR's interpretation.
- No genuine mathematical mystery remains in this finite instance. No incidental
  discovery-track entry: the closeout claims are task-owned.

The standard `bv_decide` route uses native LRAT checking and adds the compiler
to the trusted base, as described by the official
[tactic API](https://lean-lang.org/doc/api/Lean/Elab/Tactic/BVDecide.html)
(read 2026-09-13 UTC). This slice's small finite domains were practical with
`decide +kernel`; its actual axiom audits establish the retained proof route.

Validation: guarded compilation of generic modules, guarded private elaboration
against that current closure, exact axiom audits, malformed-table controls and
the prior independent Python semantic oracle. Keep the existing private JSON
in place; do not copy campaign data into the core or the generic Lean modules.
