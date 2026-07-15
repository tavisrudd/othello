import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_171_234 : RowResult ⟨171, by decide⟩ ⟨234, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_171_235 : RowResult ⟨171, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_171_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 4 6)

theorem row_171_236 : RowResult ⟨171, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_171_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 2 5 6)

theorem row_171_237 : RowResult ⟨171, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_171_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_171_238 : RowResult ⟨171, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_171_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨217, by decide⟩, by decide⟩

theorem row_171_239 : RowResult ⟨171, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_171_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_171_240 : RowResult ⟨171, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_171_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 4 5 6)

theorem row_171_241 : RowResult ⟨171, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_171_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_171_242 : RowResult ⟨171, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_171_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_171_243 : RowResult ⟨171, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_171_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨217, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
