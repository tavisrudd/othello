import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_166_232 : RowResult ⟨166, by decide⟩ ⟨232, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_166_233 : RowResult ⟨166, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_166_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_166_234 : RowResult ⟨166, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_166_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 4 5 6)

theorem row_166_235 : RowResult ⟨166, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_166_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨114, by decide⟩, by decide⟩

theorem row_166_236 : RowResult ⟨166, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_166_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 4 7)

theorem row_166_237 : RowResult ⟨166, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_166_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_166_238 : RowResult ⟨166, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_166_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_166_239 : RowResult ⟨166, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_166_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_166_240 : RowResult ⟨166, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_166_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_166_241 : RowResult ⟨166, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_166_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
