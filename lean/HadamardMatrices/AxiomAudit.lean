/-
# Axiom audit for the Hadamard matrix of order 668

Elaborating this file prints the axiom dependencies of the terminal statements
of `HadamardMatrices`.  Each of them should depend on `propext`,
`Classical.choice` and `Quot.sound` only: no `sorryAx`, and in particular no
`Lean.ofReduceBool`, which would indicate that a finite check had been delegated
to compiled native code rather than to the kernel.

This module is not imported by the library root, so an ordinary build does not
print its output.
-/
import HadamardMatrices.Order668.Orthogonality

#print axioms HadamardMatrices.Order668.matrixOrder668_mul_transpose
#print axioms HadamardMatrices.Order668.matrixOrder668_entry_sq
#print axioms HadamardMatrices.Order668.card_arrayIndex_order668
#print axioms HadamardMatrices.Order668.reindex_mul_transpose
#print axioms HadamardMatrices.borderedArray_mul_transpose
#print axioms HadamardMatrices.Order668.pafSum_eq_neg_four
