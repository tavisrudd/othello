import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_143_234 : RowResult ⟨143, by decide⟩ ⟨234, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_143_235 : RowResult ⟨143, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_143_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 5 6)

theorem row_143_236 : RowResult ⟨143, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_143_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨215, by decide⟩, by decide⟩

theorem row_143_237 : RowResult ⟨143, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_143_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_143_238 : RowResult ⟨143, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_143_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 1 4 7)

theorem row_143_239 : RowResult ⟨143, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_143_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_143_240 : RowResult ⟨143, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_143_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨217, by decide⟩, by decide⟩

theorem row_143_241 : RowResult ⟨143, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_143_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 4 5 6)

theorem row_143_242 : RowResult ⟨143, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_143_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_143_243 : RowResult ⟨143, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_143_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
