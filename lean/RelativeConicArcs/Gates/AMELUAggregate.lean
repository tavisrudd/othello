import RelativeConicArcs.Gates.AMELUDefinitions
import RelativeConicArcs.AMELU.GenericMDS
import RelativeConicArcs.AMELU.GenericDiagonalTensor
import RelativeConicArcs.AMELU.GenericLURigidity
import RelativeConicArcs.AMELU.ProductUnitaryAutomorphismGroup
import RelativeConicArcs.AMELU.AutomorphismExactSequence
import RelativeConicArcs.AMELU.NonabelianExtensionInvariant
import RelativeConicArcs.AMELU.PartyExtensionSplitting
import RelativeConicArcs.AMELU.EncoderTransversal
import RelativeConicArcs.AMELU.DiagonalIsoduality
import RelativeConicArcs.Gates.AMELUDictionary
import RelativeConicArcs.Gates.AMELUStabilizerDictionary
import RelativeConicArcs.Gates.AMELUPencilClassification
import RelativeConicArcs.AMELU.LUPencilClassification
import RelativeConicArcs.Gates.AMELUMarginalMoment
import RelativeConicArcs.Gates.AMELULogicalPhaseFourCopy
import RelativeConicArcs.Gates.AMELUTransportDivisor

/-!
# Aggregate import gate for MDS--CSS AME local-unitary results

This terminal imports the length-generic code, state, exact-MDS
shortening, marginal covariance, arbitrary-arity diagonal-axis theorem,
the full-Weyl diagonal intertwining criterion, unconditional LU-to-LC
terminal, projective Clifford finiteness, explicit
product-unitary topological groups and scalar-phase quotient groups, and the
closed scalar-torus exact sequences, finite discrete quotients, intrinsic
adjoint-signature homomorphisms, closed Hausdorff discrete intrinsic
Clifford quotients, finite scalar-torus component covers, the realized
party-permutation extension, its section-free outer action, normalized
nonabelian factor set, change-of-section law, and splitting obstruction, and
scalar-phase identity-component theorem, the one-leg encoder parameter and
Choi bridges, Clifford transpose closure, transversal no-go, exact
fixed-party affine special-linear/split-torus carrier, and exact GRS
transversal-group interface, the zero-or-one-dimensional diagonal
code-to-dual multiplier space, its exact nullity test and projectively unique
witness ratios, the shared six-party conventions, the
arc--MDS--CSS--AME and stabilizer dictionaries, the admitted-pencil
local-Clifford and local-unitary classifications, the six-party
LU-to-LC rigidity theorem, the marginal-moment separator, the
fixed-party logical phase, the exact four-copy separator, and the transport
divisor.

The dictionary statements are unconditional.  The classification,
marginal-moment, logical-phase, four-copy, transport, and exact GRS terminals derive
their conclusions from structures whose fields state the geometric,
analytic, finite-certificate, or orbit-recognition inputs that are not
proved in their modules.  Importing this gate therefore does not turn those
named inputs into axioms or unconditional theorems.
-/
