import PassantCodeQ13.Automorphisms.Base

/-!
# The forced fourth anchor

Among the 78 internal points of the normalized conic model, `(1,1,3)` is the unique point whose
polar-relation signature relative to the first three anchors is `(3,1,9)`.  The claim is decided by
kernel reduction over the 78 coordinates, three polar invariants each, so it carries no
compiled-evaluation axiom.
-/

namespace PassantCodeQ13.Automorphisms

/-- The signature `(3,1,9)` relative to the first three anchors forces the fourth anchor. -/
theorem firstThreeSignature_eq_iff (point : Coordinate) :
    firstThreeSignature point = ![3, 1, 9] ↔ point = anchors 3 := by
  decide +kernel +revert

end PassantCodeQ13.Automorphisms
