import PassantCodeQ13.AssociationAlgebra
import PassantCodeQ13.AssociationTransport.RelationData

/-!
# Displayed row masks of the three elliptic relations carrying the anchor pattern

The anchor relation pattern `(10, 3, 9)` reads three of the six elliptic relations on the 78
normalized internal points.  Their adjacency matrices are displayed as lists of row masks in
`PassantCodeQ13.AssociationTransport.RelationData`, a generated file whose lists carry no trust:
each is compared here, entry by entry, with the normalized polar invariant it is meant to encode.
Bit `second` of row `first` is set exactly when the two points are distinct and their invariant is
the relation's value.

Each comparison is exhaustive over the 6084 ordered pairs of internal points and is discharged by
kernel reduction, so none of these declarations uses compiled evaluation.  The three comparisons
are stated directly on the polar invariant rather than through a matrix presentation, which keeps
this module's import closure to the executable association algebra and the generated data.
-/

namespace PassantCodeQ13.Automorphisms

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.AssociationAlgebra
open PassantCodeQ13.AssociationTransport

/-- The displayed row masks of one elliptic relation agree entrywise with the polar invariant. -/
def relationRowsCertificate (rows : List Nat) (value : Field13) : Bool :=
  (List.range 78).all fun first =>
    (List.range 78).all fun second =>
      (rows.getD first 0).testBit second == (first != second && rhoAt first second == value)

/-- Reading the entrywise check at one ordered pair of internal-point indices. -/
theorem testBit_of_relationRowsCertificate {rows : List Nat} {value : Field13}
    (certificate : relationRowsCertificate rows value = true)
    {first second : Nat} (first_lt : first < 78) (second_lt : second < 78) :
    (rows.getD first 0).testBit second = (first != second && rhoAt first second == value) := by
  have outer :=
    List.all_eq_true.mp certificate first (List.mem_range.mpr first_lt)
  have inner := List.all_eq_true.mp outer second (List.mem_range.mpr second_lt)
  exact eq_of_beq inner

/-- The displayed rows of the relation of polar invariant three. -/
theorem relationRowsRhoThree_certificate :
    relationRowsCertificate relationRowsRhoThree 3 = true := by
  decide +kernel

/-- The displayed rows of the relation of polar invariant nine. -/
theorem relationRowsRhoNine_certificate :
    relationRowsCertificate relationRowsRhoNine 9 = true := by
  decide +kernel

/-- The displayed rows of the relation of polar invariant ten. -/
theorem relationRowsRhoTen_certificate :
    relationRowsCertificate relationRowsRhoTen 10 = true := by
  decide +kernel

end PassantCodeQ13.Automorphisms
