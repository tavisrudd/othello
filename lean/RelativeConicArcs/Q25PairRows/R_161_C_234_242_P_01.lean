import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_161_234 : RowResult ⟨161, by decide⟩ ⟨234, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_161_235 : RowResult ⟨161, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_161_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_161_236 : RowResult ⟨161, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_161_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 4 6)

theorem row_161_237 : RowResult ⟨161, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_161_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_161_238 : RowResult ⟨161, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_161_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_161_239 : RowResult ⟨161, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_161_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_161_240 : RowResult ⟨161, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_161_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_161_241 : RowResult ⟨161, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_161_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 1 4 7)

theorem row_161_242 : RowResult ⟨161, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_161_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
