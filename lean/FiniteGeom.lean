-- Root module for the `FiniteGeom` library: the shared finite-geometry /
-- coding base for the coding-MDS formalization program
-- (see `notes/handoffs/2026-07-11-lean-formalization-plan.md`, §3).
--
-- Kept deliberately minimal per the "abstract-first" decision (§5.1): only the
-- pieces the downstream libraries (`RepairCodes`, `CompletionCore`, …) actually
-- cite are built. Right now that is the q-ary weight-counting layer used by the
-- concatenation transfer lemma.
import FiniteGeom.Weight
