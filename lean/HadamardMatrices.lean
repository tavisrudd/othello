/-
# Hadamard matrices from circulant sequences

`HadamardMatrices.BorderedGoethalsSeidel` builds, from four `±1` sequences of
length `m` and a shift parameter, a bordered Goethals–Seidel array of order
`4 * m + 4`, and proves it orthogonal under an explicit autocorrelation and row
sum hypothesis on the sequences.  `HadamardMatrices.Order668` supplies four such
sequences of length 166 and derives a Hadamard matrix of order 668.
-/
import HadamardMatrices.BorderedGoethalsSeidel
import HadamardMatrices.Order668.Sequences
import HadamardMatrices.Order668.Correlations
import HadamardMatrices.Order668.Orthogonality
