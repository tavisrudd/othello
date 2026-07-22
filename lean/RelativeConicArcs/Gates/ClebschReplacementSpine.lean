import RelativeConicArcs.Gates.ClebschGateway
import RelativeConicArcs.Gates.ClebschMomentTrade
import RelativeConicArcs.Gates.ClebschConicMatchingQuotient
import RelativeConicArcs.Gates.ClebschHarmonicQuotient
import RelativeConicArcs.Gates.ClebschFactorization
import RelativeConicArcs.Gates.ClebschBalancedSheets
import RelativeConicArcs.Gates.ClebschDoubleCosetDepth
import RelativeConicArcs.Gates.ClebschSchemeFourier
import RelativeConicArcs.ClebschSchemeChirality

/-!
# Import-only gate for the Clebsch replacement spine

This module imports the signed-moment, conic-quotient, harmonic, factorization, balanced-sheet,
matching-depth, Fourier-table, gateway, and intrinsic-chirality terminals.  It adds no theorem and
does not strengthen the trust tier of any imported result.  In particular, frozen tables retain
the external geometric-identification boundaries stated in their source modules.
-/

#print axioms RelativeConicArcs.ClebschSchemeChirality.intrinsicComponents_eq_scalarLineBlocks
#print axioms RelativeConicArcs.ClebschSchemeChirality.scalarLineBlock_card
#print axioms RelativeConicArcs.ClebschSchemeChirality.triple_card
#print axioms RelativeConicArcs.ClebschSchemeChirality.triple_range_complete
#print axioms RelativeConicArcs.ClebschSchemeChirality.triple_list_nodup
#print axioms RelativeConicArcs.ClebschSchemeChirality.generatorTripleAction_semantics
#print axioms RelativeConicArcs.ClebschSchemeChirality.positive_generatedOrbit
#print axioms RelativeConicArcs.ClebschSchemeChirality.negative_generatedOrbit
#print axioms RelativeConicArcs.ClebschSchemeChirality.generator_preserves_sheet
#print axioms RelativeConicArcs.ClebschSchemeChirality.sheetExchangeTriple_semantics
#print axioms RelativeConicArcs.ClebschSchemeChirality.sheetExchange_swaps_sheets
#print axioms RelativeConicArcs.ClebschSchemeChirality.sheetExchange_fourth_power
#print axioms RelativeConicArcs.ClebschSchemeChirality.unorderedChiralityCharacter_unique
