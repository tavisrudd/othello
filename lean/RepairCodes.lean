-- Root module for the `RepairCodes` library: LRC repair hypergraph transfer,
-- the coding/MDS sweep's crux novelty
-- (see `notes/handoffs/2026-07-11-lean-formalization-plan.md`, Phase 1).
--
-- Phase 1, step 1 (landed): the concatenation transfer lemma over the
-- abstract-first `ConcatDualWord` interface, discharged by a concrete witness.
-- Still to come: the concrete `𝔽_q` NRC instance, `δ_x = τ`, the uniform
-- `q = 3^h` theorem, and the seed-and-lift corollary.
import RepairCodes.Transfer
import RepairCodes.Q9Seed
import RepairCodes.CodeInstance
