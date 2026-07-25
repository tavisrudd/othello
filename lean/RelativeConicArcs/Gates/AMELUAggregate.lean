import RelativeConicArcs.Gates.AMELUDefinitions
import RelativeConicArcs.AMELU.GenericMDS
import RelativeConicArcs.AMELU.GenericDiagonalTensor
import RelativeConicArcs.Gates.AMELUDictionary
import RelativeConicArcs.Gates.AMELUStabilizerDictionary
import RelativeConicArcs.Gates.AMELUPencilClassification
import RelativeConicArcs.AMELU.LUPencilClassification
import RelativeConicArcs.Gates.AMELUMarginalMoment
import RelativeConicArcs.Gates.AMELULogicalPhaseFourCopy
import RelativeConicArcs.Gates.AMELUTransportDivisor

/-!
# Aggregate import gate for six-party AME local-unitary results

This terminal imports the length-generic code, state, exact-MDS
shortening, and diagonal-axis foundations, the shared six-party conventions, the
arc--MDS--CSS--AME and stabilizer dictionaries, the admitted-pencil
local-Clifford and local-unitary classifications, the six-party
LU-to-LC rigidity theorem, the marginal-moment separator, the
fixed-party logical phase, the exact four-copy separator, and the transport
divisor.

The dictionary statements are unconditional.  The classification,
marginal-moment, logical-phase, four-copy, and transport terminals derive
their conclusions from structures whose fields state the geometric,
analytic, finite-certificate, or orbit-recognition inputs that are not
proved in their modules.  Importing this gate therefore does not turn those
named inputs into axioms or unconditional theorems.
-/
