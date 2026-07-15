import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_91_232 : RowResult ⟨91, by decide⟩ ⟨232, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨215, by decide⟩, by decide⟩

theorem row_91_233 : RowResult ⟨91, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_91_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_91_234 : RowResult ⟨91, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_91_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_91_235 : RowResult ⟨91, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_91_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_91_236 : RowResult ⟨91, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_91_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 4 7)

theorem row_91_237 : RowResult ⟨91, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_91_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 2 5 6)

theorem row_91_238 : RowResult ⟨91, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_91_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 2 4 7)

theorem row_91_239 : RowResult ⟨91, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_91_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_91_240 : RowResult ⟨91, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_91_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_91_241 : RowResult ⟨91, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_91_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 1 4 6)

theorem row_91_242 : RowResult ⟨91, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_91_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_91_243 : RowResult ⟨91, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_91_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
