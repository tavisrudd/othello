import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_118_233 : RowResult ⟨118, by decide⟩ ⟨233, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_118_234 : RowResult ⟨118, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_118_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 4 5 6)

theorem row_118_235 : RowResult ⟨118, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_118_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 4 7)

theorem row_118_236 : RowResult ⟨118, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_118_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_118_237 : RowResult ⟨118, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_118_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 2 5 7)

theorem row_118_238 : RowResult ⟨118, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_118_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 1 4 7)

theorem row_118_239 : RowResult ⟨118, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_118_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_118_240 : RowResult ⟨118, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_118_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_118_241 : RowResult ⟨118, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_118_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 2 5 6)

theorem row_118_242 : RowResult ⟨118, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_118_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_118_243 : RowResult ⟨118, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_118_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 1 4 6)

theorem row_118_244 : RowResult ⟨118, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_118_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_118_245 : RowResult ⟨118, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_118_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_118_246 : RowResult ⟨118, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_118_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
