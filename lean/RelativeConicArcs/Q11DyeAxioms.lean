import RelativeConicArcs.Moments
import RelativeConicArcs.Q11Coding
import RelativeConicArcs.SixArcConcurrenceBound

/-!
# The six-arc concurrence boundary used by Clebsch rigidity

Two statements about six-arcs of `PG(2,11)` are needed by the Clebsch rigidity development, both
phrased in the project's incidence model: a bound of ten on the off-arc points lying on three
secants, and the classification of the arcs attaining that bound as a single projective class.

The bound is a theorem here, specialized from
`RelativeConicArcs.SixArcConcurrence.card_triplePoints_le_ten`, which proves it for every finite
field in which two is invertible.

The classification is the single external input of this module, and every downstream
`#print axioms` exposes it.  Its source is R. H. Dye, “Hexagons, conics, \(A_5\) and
\(\mathrm{PSL}_2(K)\),” *Journal of the London Mathematical Society* (2) 44
(1991), 270--286, doi:10.1112/jlms/s2-44.2.270, Theorem 1(ii), page 275, whose ten-point count in
Section 2.2, page 275 is the same bound proved here.  No other geometric or computational claim is
imported through this boundary.
-/

namespace RelativeConicArcs.ClebschDye

open Certificate Configuration

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

abbrev K11 := ZMod 11
abbrev Point11 := Conic.Point K11
abbrev Space11 := Fin 3 → K11

noncomputable local instance : Fintype Point11 := Fintype.ofFinite _
noncomputable local instance : DecidableEq Point11 := Classical.decEq _

/-- The displayed six-point Clebsch witness used by the certified `q=11` development. -/
noncomputable def clebschWitness : Finset Point11 :=
  pointSet Examples.q11Witness

/-- Off-arc points incident with exactly three secants of `A`. -/
noncomputable def brianchonPoints (A : Finset Point11) : Finset Point11 :=
  (Finset.univ \ A).filter fun x => pointIndex (L := Point11) A x = 3

/-- Projective equivalence to the displayed certified Clebsch hexagon. -/
noncomputable def IsClebschHexagon (A : Finset Point11) : Prop :=
  ∃ g : Space11 ≃ₗ[K11] Space11,
    A.map (ProjectiveCap.Projective.mapEquiv g).toEmbedding = clebschWitness

/-- The triple-point bound for a six-arc of `PG(2,11)`: at most ten points off the arc lie on
three of its secants.  This is the specialization to `PG(2,11)` of
`RelativeConicArcs.SixArcConcurrence.card_triplePoints_le_ten`, which proves the bound by an
incidence count over the arc's fifteen secants together with the non-collinearity of the diagonal
points of a complete quadrangle.  The same statement appears as the ten-point bound of Dye 1991,
Section 2.2, page 275, doi:10.1112/jlms/s2-44.2.270. -/
theorem dye1991_brianchon_bound
    {A : Finset Point11}
    (hA : Arc (L := Point11) A)
    (hcard : A.card = 6) :
    (brianchonPoints A).card ≤ 10 := by
  classical
  have h2 : (2 : K11) ≠ 0 := by decide
  simpa [brianchonPoints, SixArcConcurrence.triplePoints] using
    SixArcConcurrence.card_triplePoints_le_ten (K := K11) h2 hA hcard

/-- Dye's equality classification, specialized to `PG(2,11)`; the external input is Dye 1991,
Theorem 1(ii), page 275, doi:10.1112/jlms/s2-44.2.270. -/
axiom dye1991_equality_classification
    {A : Finset Point11}
    (hA : Arc (L := Point11) A)
    (hcard : A.card = 6)
    (heq : (brianchonPoints A).card = 10) :
    IsClebschHexagon A

#print axioms dye1991_brianchon_bound
#print axioms dye1991_equality_classification

end RelativeConicArcs.ClebschDye
