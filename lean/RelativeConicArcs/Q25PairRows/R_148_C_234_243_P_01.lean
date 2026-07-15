import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_148_234 : RowResult ⟨148, by decide⟩ ⟨234, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_148_235 : RowResult ⟨148, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_148_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_148_236 : RowResult ⟨148, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_148_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_148_237 : RowResult ⟨148, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_148_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_148_238 : RowResult ⟨148, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_148_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 2 4 6)

theorem row_148_239 : RowResult ⟨148, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_148_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_148_240 : RowResult ⟨148, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_148_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨217, by decide⟩, by decide⟩

theorem row_148_241 : RowResult ⟨148, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_148_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 2 4 7)

theorem row_148_242 : RowResult ⟨148, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_148_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 2 5 6)

theorem row_148_243 : RowResult ⟨148, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_148_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
