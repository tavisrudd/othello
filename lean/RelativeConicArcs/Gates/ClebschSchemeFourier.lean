import RelativeConicArcs.ClebschSchemeFourier

/-!
# Import-only gate for q = 11 character sums and frozen Fourier-table checks

This gate re-exports a kernel proof of the abstract `F_11` scalar-line character identity and exact
checks of frozen data: table dimensions, the `11*z-ell` entry formula, equality of the candidate
`P` and `Q` tables, `P*Q = P^2 = schemeOrder*I`, equality of candidate valencies with row zero of
`Q`, exhaustive mask coverage, and successful additive-nonclosure witness classification for every
proper nonempty union of the seven nonidentity labels.

The identification of the frozen relations, matrices, counts, and witnesses with the translation
association scheme of the reduced projective icosahedral action on `F_11^3` is an external exact-
enumeration boundary. In particular, this gate does not itself prove scheme rank, Fourier
self-duality, or primitivity of that geometric scheme.

It asserts nothing about the full intersection tensor, the Krein/intersection equality, the fusion
census, separability, or automorphism groups; those remain outside this gate. It adds no content;
see `RelativeConicArcs.ClebschSchemeFourier`.
-/
