import RelativeConicArcs.BalancedExchangeHalfCut
import RelativeConicArcs.ConferenceExchangeCompression
import RelativeConicArcs.ConferenceExchangeSpectrum

/-!
# Balanced cuts and exchange spectra of order-six conference matrices

This import-only gate exposes the results used by the optional formal companion
to the paper on orientation, exchange statistics, and rigidity in the Golden
six-mode conference interferometer.

`RelativeConicArcs.ConferenceExchangeSpectrum` works at matrix level.  It
proves that the conference equation `C * C = q • 1` forces the cross Gram
identity `S * Sᵀ = q • 1 - A * A` on any two-block splitting, computes the
square of a signed triangle principal block, and derives the characteristic
polynomial, trace, squared trace, determinant, and degree-three exchange
sectors of the normalized exchange operator `5⁻¹ • (S * Sᵀ)` at a three-element
cut of an order-six symmetric conference matrix.

`RelativeConicArcs.ConferenceExchangeCompression` identifies the transfer Gram
operator with a compression of the complementary eigenprojection and with a
quarter of the compressed squared commutator.  The spectrum module connects the
values `16`, `12`, and `-42` directly to an actual cross Gram determinant and
matrix trace; no separately written scalar polynomial is part of this gate.

`RelativeConicArcs.BalancedExchangeHalfCut` supplies the semantic cut theorem:
for a real symmetric conference matrix on six labels and an actual
three-element subset, it constructs an orthonormal eigenframe and proves that
the resulting exchange compression has characteristic polynomial
`(X - 1/5)(X - 4/5)^2`.  More generally, the imported half-cut and spectrum
modules prove the eigenvalue formula, the aligned-four-set purity formula,
nonconstancy for every half-size at least four, the three small principal-block
formulas, and nonexistence at order four.  The two directions of conference
exchange rigidity are exported as separate theorem terminals rather than one
bundled equivalence.

The imported proofs do not formalize the paper's orbit and orientation
classification, its all-orders rigidity converse, its continuous-control
optimum, its Hermitian exchange landscape, its stability bounds, or any
decoding, tomography, optical-compilation, or experimental statement.
-/
