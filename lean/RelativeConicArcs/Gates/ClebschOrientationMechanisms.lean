import RelativeConicArcs.InvolutiveOddUnit
import RelativeConicArcs.KneserPairEigenspace

/-!
# Import gate for involutive splitting and Kneser pair sums

This gate exposes two symbolic mechanisms.  The first decomposes an
involutive commutative ring after an odd element becomes a unit.  The second
identifies the standard sum-zero vertex representation with the pair-sum
eigenspace of `K(n,2)` and, for `n = 5`, with the full four-dimensional
Petersen `-2` eigenspace.

Both modules use finite sums and kernel-checked algebraic tactics.  They import
no generated certificate, native evaluation, or project-specific axiom.
-/

#print axioms RelativeConicArcs.InvolutiveOddUnit.map_evenPart
#print axioms RelativeConicArcs.InvolutiveOddUnit.map_oddPart
#print axioms RelativeConicArcs.InvolutiveOddUnit.evenPart_add_oddPart
#print axioms RelativeConicArcs.InvolutiveOddUnit.invariant_eq_zero_of_antiInvariant
#print axioms RelativeConicArcs.InvolutiveOddUnit.oddMulEquiv
#print axioms RelativeConicArcs.InvolutiveOddUnit.existsUnique_invariant_add_mul_invariant
#print axioms RelativeConicArcs.InvolutiveOddUnit.localized_existsUnique_invariant_add_mul_invariant

#print axioms RelativeConicArcs.KneserPairEigenspace.adjacency_pairSum_of_sum_eq_zero
#print axioms RelativeConicArcs.KneserPairEigenspace.pairSum_injective_on_sumZero
#print axioms RelativeConicArcs.KneserPairEigenspace.existsUnique_pairSum_of_petersenEigen
#print axioms RelativeConicArcs.KneserPairEigenspace.standardEquivPetersenNegTwo
#print axioms RelativeConicArcs.KneserPairEigenspace.finrank_petersenNegTwoEigenspace
