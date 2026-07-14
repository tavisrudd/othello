import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_186_232 : RowResult ⟨186, by decide⟩ ⟨232, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_186_233 : RowResult ⟨186, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_186_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_186_234 : RowResult ⟨186, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_186_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_186_235 : RowResult ⟨186, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_186_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_186_236 : RowResult ⟨186, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_186_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 4 6)

theorem row_186_237 : RowResult ⟨186, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_186_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 4 5 6)

theorem row_186_238 : RowResult ⟨186, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_186_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 2 5 6)

theorem row_186_239 : RowResult ⟨186, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_186_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_186_240 : RowResult ⟨186, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_186_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_186_241 : RowResult ⟨186, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_186_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 1 4 7)

theorem row_186_242 : RowResult ⟨186, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_186_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
