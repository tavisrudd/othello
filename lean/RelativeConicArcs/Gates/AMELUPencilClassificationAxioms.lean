import RelativeConicArcs.Gates.AMELUPencilClassification

/-!
# Axiom audit for the admitted non-GRS pencil classification

This audit prints the dependencies of the algebraic quotient identity and
the hypothesis-explicit classification terminal.  It performs no
computation.
-/

open RelativeConicArcs.AMELU

#print axioms pencilZ_eq_pencilZFromY
#print axioms pencilZFromY_eq_of_sameOrbit
#print axioms samePencilYOrbit_iff_pencilZFromY_eq
#print axioms admitted_nonGRS_pencil_classified_by_z
