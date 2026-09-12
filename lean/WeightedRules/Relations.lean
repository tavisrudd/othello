import WeightedRules.Contract

/-!
# Relational coordinates and source preservation

A finite relation signature lists arities over a common finite domain. A coordinate
encoding is a bijection from ground relation tuples to scalar positions; it cannot
omit or identify tuples. If the encoding commutes with source and scalar rule
evaluation, a scalar convergence certificate transports to a least source valuation.
The commutation hypothesis is explicit: a parser or compiler is not certified merely
by supplying a coordinate map. All proofs are symbolic kernel proofs.
-/

namespace WeightedRules

/-- Ordered arities of the relations, including any explicitly declared auxiliary relations. -/
structure RelationSignature where
  arities : List Nat

/-- Number of scalar tuples over a domain of the given cardinality. -/
def RelationSignature.scalarCount (signature : RelationSignature) (domain : Nat) : Nat :=
  signature.arities.foldl (fun total arity => total + domain ^ arity) 0

/-- A ground atom consists of a relation index and one domain value per argument. -/
abbrev GroundAtom (signature : RelationSignature) (domain : Nat) :=
  (relation : Fin signature.arities.length) ×
    (Fin signature.arities[relation] → Fin domain)

/-- A relational valuation assigns a weight to every ground atom. -/
abbrev RelationState (W : Type) (signature : RelationSignature) (domain : Nat) :=
  GroundAtom signature domain → W

/-- A complete coordinate encoding is a bijection, including nullary relation tuples. -/
abbrev CoordinateEncoding (signature : RelationSignature) (domain : Nat) :=
  GroundAtom signature domain ≃ Fin (signature.scalarCount domain)

variable {W : Type} {signature : RelationSignature} {domain : Nat}

/-- Encode relational values in the chosen complete scalar coordinate system. -/
def encodeRelations (e : CoordinateEncoding signature domain)
    (x : RelationState W signature domain) : State W (signature.scalarCount domain) :=
  fun i => x (e.symm i)

/-- Read a scalar valuation in its relation coordinates. -/
def decodeRelations (e : CoordinateEncoding signature domain)
    (x : State W (signature.scalarCount domain)) : RelationState W signature domain :=
  fun atom => x (e atom)

/-- Decoding after encoding preserves every ground atom. -/
theorem decode_encode (e : CoordinateEncoding signature domain)
    (x : RelationState W signature domain) : decodeRelations e (encodeRelations e x) = x := by
  funext atom
  simp only [decodeRelations, encodeRelations, Equiv.symm_apply_apply]

/-- Encoding after decoding preserves every scalar coordinate. -/
theorem encode_decode (e : CoordinateEncoding signature domain)
    (x : State W (signature.scalarCount domain)) : encodeRelations e (decodeRelations e x) = x := by
  funext i
  simp only [decodeRelations, encodeRelations, Equiv.apply_symm_apply]

/-- Complete coordinate encoding cannot merge distinct relational valuations. -/
theorem encode_injective (e : CoordinateEncoding signature domain) :
    Function.Injective (encodeRelations (W := W) e) := by
  intro x y h
  have decoded := congrArg (decodeRelations e) h
  simpa only [decode_encode] using decoded

/-- Under the source-to-scalar commutation square, a scalar certificate gives
the least fixed relational valuation in pointwise information order. -/
theorem relational_certificate_least (A : ScalarAlgebra W)
    (P : Program W (signature.scalarCount domain))
    (e : CoordinateEncoding signature domain)
    (sourceStep : RelationState W signature domain → RelationState W signature domain)
    (commute : ∀ x, encodeRelations e (sourceStep x) = step A P (encodeRelations e x))
    (bound : Nat) (certificate : Certificate A P bound) :
    sourceStep (decodeRelations e (iterate A P certificate.rounds)) =
      decodeRelations e (iterate A P certificate.rounds) ∧
    ∀ y, sourceStep y = y → ∀ atom,
      InfoLe A (decodeRelations e (iterate A P certificate.rounds) atom) (y atom) := by
  constructor
  · apply encode_injective e
    rw [commute, encode_decode, certificate.fixed]
  · intro y hy atom
    have fixed : step A P (encodeRelations e y) = encodeRelations e y := by
      rw [← commute, hy]
    have least := iterate_le_fixed A P (encodeRelations e y) fixed certificate.rounds (e atom)
    simpa only [decodeRelations, encodeRelations, Equiv.symm_apply_apply] using least

/-- A binary edge relation, unary distance relation and nullary unit have 21
ground scalar coordinates over a four-element domain. -/
theorem distance_signature_count : (RelationSignature.mk [2, 1, 0]).scalarCount 4 = 21 := by
  decide

end WeightedRules
