import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_173_234 : RowResult ⟨173, by decide⟩ ⟨234, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨114, by decide⟩, by decide⟩

theorem row_173_235 : RowResult ⟨173, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_173_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 5 7)

theorem row_173_236 : RowResult ⟨173, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_173_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_173_237 : RowResult ⟨173, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_173_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_173_238 : RowResult ⟨173, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_173_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_173_239 : RowResult ⟨173, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_173_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_173_240 : RowResult ⟨173, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_173_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_173_241 : RowResult ⟨173, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_173_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_173_242 : RowResult ⟨173, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_173_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 4 5 6)

theorem row_173_243 : RowResult ⟨173, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_173_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
