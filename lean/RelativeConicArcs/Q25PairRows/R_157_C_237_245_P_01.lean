import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_157_237 : RowResult ⟨157, by decide⟩ ⟨237, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_157_238 : RowResult ⟨157, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_157_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 4 5 6)

theorem row_157_239 : RowResult ⟨157, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_157_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_157_240 : RowResult ⟨157, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_157_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_157_241 : RowResult ⟨157, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_157_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_157_242 : RowResult ⟨157, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_157_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_157_243 : RowResult ⟨157, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_157_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_157_244 : RowResult ⟨157, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_157_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_157_245 : RowResult ⟨157, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_157_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
