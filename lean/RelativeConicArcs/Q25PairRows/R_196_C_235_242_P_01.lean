import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_196_235 : RowResult ⟨196, by decide⟩ ⟨235, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_196_236 : RowResult ⟨196, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_196_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_196_237 : RowResult ⟨196, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_196_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_196_238 : RowResult ⟨196, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_196_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_196_239 : RowResult ⟨196, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_196_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_196_240 : RowResult ⟨196, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_196_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_196_241 : RowResult ⟨196, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_196_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_196_242 : RowResult ⟨196, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_196_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
