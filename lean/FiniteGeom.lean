-- Root module for the `FiniteGeom` library: the shared finite-geometry /
-- coding base for the coding-MDS formalization program
-- (see `notes/handoffs/2026-07-11-lean-formalization-plan.md`, §3).
--
-- Kept deliberately minimal per the "abstract-first" decision (§5.1): only the
-- pieces the downstream libraries (`RepairCodes`, `CompletionCore`, …) actually
-- cite are built. Right now that is the q-ary weight-counting layer used by the
-- concatenation transfer lemma.
import FiniteGeom.Weight
import FiniteGeom.Hypergraph
import FiniteGeom.Code
import FiniteGeom.EvalCode
import FiniteGeom.EvalCodeInstance
import FiniteGeom.MomentCurve
import FiniteGeom.ColumnCode
import FiniteGeom.ColoredCompleteGraph
import FiniteGeom.ZeroSumTriple
import FiniteGeom.Completion
import FiniteGeom.Repair
import FiniteGeom.BaerCompletion.Obstruction
import FiniteGeom.BaerCompletion.Clutter
import FiniteGeom.BaerCompletion.Weighted
import FiniteGeom.BaerCompletion.MultiInsertion
import FiniteGeom.BaerCompletion.Secant
import FiniteGeom.BaerCompletion.BaerPlane
import FiniteGeom.BaerCompletion.PairExtension
import FiniteGeom.BaerCompletion.OrbitCounting
import FiniteGeom.BaerCompletion.OrbitSaturation
import FiniteGeom.BaerCompletion.RobustHole
import FiniteGeom.BaerCompletion.Core
