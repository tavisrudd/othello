import RelativeConicArcs.Moments
import RelativeConicArcs.Q11Coding

/-!
# The exact Dye boundary used by Clebsch rigidity

The paper needs two consequences of Dye's equality classification for six-arcs.  They are stated
here, specialized to `PG(2,11)` and to the project's actual incidence model, so every downstream
`#print axioms` exposes the precise external input.  No other geometric or computational claim is
imported through this boundary.

The external source is R. H. Dye, “Hexagons, conics, \(A_5\) and
\(\mathrm{PSL}_2(K)\),” *Journal of the London Mathematical Society* (2) 44
(1991), 270--286, doi:10.1112/jlms/s2-44.2.270. The two declarations below
specialize the ten-point bound in Section 2.2, page 275, and the equality
classification in Theorem 1(ii), page 275.
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

/-- Dye's triple-point bound, specialized to the exact field and arc size used here; the external
input is Dye 1991, Section 2.2, page 275, doi:10.1112/jlms/s2-44.2.270. -/
axiom dye1991_brianchon_bound
    {A : Finset Point11}
    (hA : Arc (L := Point11) A)
    (hcard : A.card = 6) :
    (brianchonPoints A).card ≤ 10

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
