-- Root module for the `RepairCodes` library: LRC repair hypergraph transfer,
-- the coding/MDS sweep's crux novelty
-- (see `notes/handoffs/2026-07-11-lean-formalization-plan.md`, Phase 1).
--
-- Phase 1, step 1 (landed): the concatenation transfer lemma over the
-- abstract-first `ConcatDualWord` interface. The real `𝔽₉` inner generator,
-- `[10,4,6]₉` parameters, coefficient faithfulness, and exact dual distance
-- four are landed; the outer-dual decomposition remains. Still to come here: the
-- concrete repair hypergraph, the uniform `q = 3^h` theorem, and seed-and-lift.
import RepairCodes.Transfer
import RepairCodes.Q9Seed
import RepairCodes.CodeInstance
