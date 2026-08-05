import RelativeConicArcs.ClebschGoldenConference
import Mathlib.Tactic.Ring

/-!
# The Segre relations of the six outer cubics

The oriented triangle cubic of the fixed order-six integral conference matrix
has an orbit of six signed translates under relabelling of the six affine
coordinates.  A transversal for that orbit is given here by the six
reorderings that fix the labels `0`, `1`, `2` and permute the labels `3`, `4`,
`5` in every order; each translate is the triangle cubic evaluated on the
reordered coordinates, weighted by the sign of the reordering.  These six
cubics are the signed Joubert coordinates: the relabelling rule
`g · Z_T = sgn(g) · Z_{gT}` turns the sign vector of one translate into the
sign vectors of all six, so the transversal below reproduces the classical
signed coloured-triangle frame.

The two theorems here are the equations cutting out the Segre cubic: the six
translates sum to zero and their cubes sum to zero.  Both are polynomial
identities in the six coordinates over an arbitrary commutative ring, proved
by expanding the twenty triangle monomials of each translate.  They say that
the map sending six labelled coordinates to their six translates lands in the
Segre cubic threefold; nothing here identifies that map with a classical
construction, and the Segre--Igusa polar map built from the centered squares
of these coordinates is not treated.
-/

namespace RelativeConicArcs.ClebschOuterSegreRelations

open RelativeConicArcs.ClebschGoldenConference

/-- The six coordinate reorderings indexing the outer family, each fixing the
labels `0`, `1`, `2` and permuting `3`, `4`, `5`.  They are listed in the
lexicographic order of their images. -/
def outerReindex : Fin 6 → Fin 6 → Fin 6 :=
  ![![0, 1, 2, 3, 4, 5],
    ![0, 1, 2, 3, 5, 4],
    ![0, 1, 2, 4, 3, 5],
    ![0, 1, 2, 4, 5, 3],
    ![0, 1, 2, 5, 3, 4],
    ![0, 1, 2, 5, 4, 3]]

/-- The sign of each of the six reorderings, as a parity of transpositions of
the labels `3`, `4`, `5`. -/
def outerSign (R : Type*) [CommRing R] : Fin 6 → R :=
  ![1, -1, -1, 1, 1, -1]

/-- The six outer cubics of the fixed conference matrix: the oriented triangle
cubic evaluated on each reordering of the coordinates, weighted by the sign of
that reordering. -/
def outerCubic {R : Type*} [CommRing R] (x : Fin 6 → R) (t : Fin 6) : R :=
  outerSign R t *
    triangleCubic (conferenceMatrixOver R) (fun i => x (outerReindex t i))

/-- The first Segre equation: the six outer cubics sum to zero, identically in
the six coordinates and over every commutative ring. -/
theorem sum_outerCubic {R : Type*} [CommRing R] (x : Fin 6 → R) :
    ∑ t, outerCubic x t = 0 := by
  simp [Fin.sum_univ_six, outerCubic, outerSign, outerReindex, triangleCubic,
    cubicTerm, triangleSign, conferenceMatrixOver, conferenceMatrix]
  ring

/-- The second Segre equation: the cubes of the six outer cubics sum to zero,
identically in the six coordinates and over every commutative ring.  Together
with the linear relation this places the six coordinates on the Segre cubic
threefold. -/
theorem sum_outerCubic_cube {R : Type*} [CommRing R] (x : Fin 6 → R) :
    ∑ t, outerCubic x t ^ 3 = 0 := by
  simp [Fin.sum_univ_six, outerCubic, outerSign, outerReindex, triangleCubic,
    cubicTerm, triangleSign, conferenceMatrixOver, conferenceMatrix]
  ring

end RelativeConicArcs.ClebschOuterSegreRelations
