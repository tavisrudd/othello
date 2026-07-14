import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_82_234 : RowResult ⟨82, by decide⟩ ⟨234, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_82_235 : RowResult ⟨82, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_82_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_82_236 : RowResult ⟨82, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_82_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 2 4 6)

theorem row_82_237 : RowResult ⟨82, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_82_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 2 5 7)

theorem row_82_238 : RowResult ⟨82, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_82_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_82_239 : RowResult ⟨82, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_82_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_82_240 : RowResult ⟨82, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_82_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_82_241 : RowResult ⟨82, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_82_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 2 5 6)

theorem row_82_242 : RowResult ⟨82, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_82_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_82_243 : RowResult ⟨82, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_82_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
