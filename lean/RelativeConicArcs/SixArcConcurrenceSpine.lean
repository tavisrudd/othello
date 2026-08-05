import RelativeConicArcs.SixArcConcurrenceBound
import RelativeConicArcs.SixArcChordMatchings
import RelativeConicArcs.SixArcOneFactorization
import RelativeConicArcs.SixArcHexagonalOrder
import RelativeConicArcs.SixArcGoldenNormalForm
import RelativeConicArcs.Q11GoldenHexagonWitness

/-!
# Proof spine for six-arc triple concurrence and the golden hexagon

This import-only module collects the results about a six-arc `A` of a projective plane and the
points off `A` lying on three of its secants, called here its triple-concurrence points.  Two
statements are the endpoints of the development.  Over any field in which two is invertible a
six-arc has at most ten such points; over the field of eleven elements a six-arc attaining ten is
carried by a linear automorphism of `(ZMod 11)³` onto the displayed six-point witness
`RelativeConicArcs.Examples.q11Witness`.

The route between them has four stages.  Sending a triple-concurrence point to the three chords of
`A` through it is a bijection onto the chord matchings whose three chords are concurrent, so the
bound and the equality case can be counted among the fifteen chords rather than among the points of
the plane.  At exactly ten triple-concurrence points every chord lies in exactly one non-concurrent
matching and there are five such matchings, so they partition the chords.  Two chord matchings
without a common chord list the six points as a hexagon `p₁, …, p₆` whose two matchings are the
alternating chord triples.  Frame arithmetic then puts a hexagon whose four named chord triples are
concurrent into the coordinates

`(1 : 0 : 0)`, `(φ : 1 : 1)`, `(0 : 1 : 0)`, `(1 : φ : 1)`, `(0 : 0 : 1)`, `(1 : 1 : 2 - φ)`

with `φ * φ = φ + 1`; in particular the ground field of such a plane contains a root of that
relation.  At order eleven the two roots are `4` and `8`, and an explicit projectivity for each
carries its golden hexagon onto the witness.

Both endpoints appear in R. H. Dye, "Hexagons, conics, \(A_5\) and \(\mathrm{PSL}_2(K)\)",
*Journal of the London Mathematical Society* (2) 44 (1991), 270--286,
doi:10.1112/jlms/s2-44.2.270: the ten-point count in Section 2.2, page 275, and the classification
of the arcs attaining it in Theorem 1(ii), page 275.  That paper is the cited antecedent; the
proofs collected here are the ones checked in this repository and import no claim from it.

The development stands on its own.  It shares no declaration with the orientation spine
`RelativeConicArcs.SupportOrientationSpine`, which treats the antipodal cover, determinant pencil,
and singular locus of the support cubic; neither uses the other, and the two are distributed as
separate companion boundaries.  The order-eleven module `RelativeConicArcs.Q11DyeAxioms` records
the two endpoints below, specialized to order eleven, and derives them from the terminals collected
here.

Every terminal below is a kernel proof.  The general statements quantify over an arbitrary field
with two invertible, or over an arbitrary finite point type with the incidence hypotheses named in
their statements; only the order-eleven identification fixes a field.  The closure contains no
generated certificate, native evaluation, imported external data, user axiom, unsafe declaration,
or admitted proof.
-/
