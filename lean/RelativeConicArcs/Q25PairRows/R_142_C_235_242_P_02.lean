import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_142_235 : RowResult ⟨142, by decide⟩ ⟨235, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_142_236 : RowResult ⟨142, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_142_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_142_237 : RowResult ⟨142, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_142_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 4 7)

theorem row_142_238 : RowResult ⟨142, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_142_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_142_239 : RowResult ⟨142, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_142_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_142_240 : RowResult ⟨142, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_142_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 4 5 6)

theorem row_142_241 : RowResult ⟨142, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_142_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 2 5 6)

theorem row_142_242 : RowResult ⟨142, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_142_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
