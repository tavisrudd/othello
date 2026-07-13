-- Root module for the `RepairCodes` library: LRC repair hypergraph transfer,
-- the coding/MDS sweep's crux novelty
-- (see `notes/handoffs/2026-07-11-lean-formalization-plan.md`, Phase 1).
--
-- Phase 1, step 1 (landed): the concatenation transfer lemma over the
-- abstract-first `ConcatDualWord` interface. The real `𝔽₉` inner generator,
-- `[10,4,6]₉` parameters, coefficient faithfulness, and exact dual distance
-- four are landed; outer-dual membership is proved directly from concatenation
-- orthogonality in `OuterDual`. The code-derived q9 axis repair hypergraph is
-- landed with exact `ν=3, τ=5`; the uniform characteristic-three
-- `[2q+1,4,q-1]` code parameters are landed, and seed-and-lift remains.
import FiniteGeom.AxisTwistedCubicCircuits
import RepairCodes.Transfer
import RepairCodes.AxisTwistedCubic
import RepairCodes.AxisTwistedCubicInvariants
import RepairCodes.ProjectiveAxisTwistedCubic
import RepairCodes.Q9Seed
import RepairCodes.Q9Affine
import RepairCodes.Q9Uniform
import RepairCodes.Q9CircuitInventory
import RepairCodes.SeedLift
import RepairCodes.TransferBoundary
import RepairCodes.Q9SeedLift
import RepairCodes.CodeInstance
import RepairCodes.OuterDual
import RepairCodes.TraceDual
import RepairCodes.Q9ExtensionLift
import RepairCodes.Imported
import RepairCodes.Asymptotic
