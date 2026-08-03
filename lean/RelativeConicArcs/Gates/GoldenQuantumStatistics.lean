import RelativeConicArcs.ConferenceExchangeSpectrum
import RelativeConicArcs.GoldenBalancedCut

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

`RelativeConicArcs.GoldenBalancedCut` proves the same order-six determinant and
trace values as scalar identities over an arbitrary commutative ring.

The imported proofs do not formalize the paper's orbit and orientation
classification, its all-orders rigidity converse, its continuous-control
optimum, its Hermitian exchange landscape, its stability bounds, or any
decoding, tomography, optical-compilation, or experimental statement.  They
also do not identify the normalized exchange operator with a compression of a
diagonal control between orthonormal eigenframes; the exported results apply to
that compression only through the equality of the two spectra.
-/
