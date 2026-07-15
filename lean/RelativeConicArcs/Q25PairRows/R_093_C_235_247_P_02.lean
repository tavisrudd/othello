import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_93_235 : RowResult ⟨93, by decide⟩ ⟨235, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_93_236 : RowResult ⟨93, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_93_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_93_237 : RowResult ⟨93, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_93_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_93_238 : RowResult ⟨93, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_93_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 1 4 7)

theorem row_93_239 : RowResult ⟨93, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_93_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_93_240 : RowResult ⟨93, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_93_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 4 5 6)

theorem row_93_241 : RowResult ⟨93, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_93_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨48, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_93_242 : RowResult ⟨93, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_93_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 2 5 7)

theorem row_93_243 : RowResult ⟨93, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_93_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 1 4 6)

theorem row_93_244 : RowResult ⟨93, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_93_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_93_245 : RowResult ⟨93, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_93_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_93_246 : RowResult ⟨93, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_93_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_93_247 : RowResult ⟨93, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_93_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
