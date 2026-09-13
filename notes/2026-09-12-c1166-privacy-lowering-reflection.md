# C1166 — kernel-checked finite privacy lowering

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: IN PROGRESS.

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

Validation: guarded compilation of generic modules, guarded private elaboration
against that current closure, exact axiom audits, malformed-table controls and
the prior independent Python semantic oracle. Keep the existing private JSON
in place; do not copy campaign data into the core or the generic Lean modules.
