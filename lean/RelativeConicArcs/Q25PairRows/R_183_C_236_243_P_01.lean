import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_183_236 : RowResult ⟨183, by decide⟩ ⟨236, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_183_237 : RowResult ⟨183, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_183_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_183_238 : RowResult ⟨183, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_183_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_183_239 : RowResult ⟨183, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_183_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_183_240 : RowResult ⟨183, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_183_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 2 5 7)

theorem row_183_241 : RowResult ⟨183, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_183_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_183_242 : RowResult ⟨183, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_183_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_183_243 : RowResult ⟨183, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_183_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
