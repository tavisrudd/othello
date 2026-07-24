import RelativeConicArcs.Gates.AMELUMarginalMoment

/-!
# Axiom audit for the triple-marginal moment separator

This audit prints the dependencies of the finite graph counts, the
concurrency-count reduction, and the final local-unitary separator.  The
small graph enumerations are checked exhaustively by `native_decide`; their
printed dependencies expose the native-evaluation trust boundary.
-/

open RelativeConicArcs.AMELU

#print axioms card_marginalTriples
#print axioms card_marginalStars
#print axioms card_perfectMatchings
#print axioms rankFourMultiplicity_eq_sixty_add_concurrency
#print axioms not_locallyUnitaryEquivalent_of_ten_vs_atMostSix_concurrences
