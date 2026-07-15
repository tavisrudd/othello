import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_144_235 : RowResult ⟨144, by decide⟩ ⟨235, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_144_236 : RowResult ⟨144, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_144_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_144_237 : RowResult ⟨144, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_144_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_144_238 : RowResult ⟨144, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_144_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_144_239 : RowResult ⟨144, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_144_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 4 7)

theorem row_144_240 : RowResult ⟨144, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_144_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_144_241 : RowResult ⟨144, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_144_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_144_242 : RowResult ⟨144, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_144_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 4 5 6)

theorem row_144_243 : RowResult ⟨144, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_144_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 2 4 6)

theorem row_144_244 : RowResult ⟨144, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_144_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
