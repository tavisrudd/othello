import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_57_234 : RowResult ⟨57, by decide⟩ ⟨234, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_57_235 : RowResult ⟨57, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_57_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 4 5 6)

theorem row_57_236 : RowResult ⟨57, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_57_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_57_237 : RowResult ⟨57, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_57_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_57_238 : RowResult ⟨57, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_57_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 2 5 7)

theorem row_57_239 : RowResult ⟨57, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_57_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_57_240 : RowResult ⟨57, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_57_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_57_241 : RowResult ⟨57, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_57_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_57_242 : RowResult ⟨57, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_57_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_57_243 : RowResult ⟨57, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_57_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
