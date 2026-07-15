import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_69_235 : RowResult ⟨69, by decide⟩ ⟨235, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨216, by decide⟩, by decide⟩

theorem row_69_236 : RowResult ⟨69, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_69_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_69_237 : RowResult ⟨69, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_69_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_69_238 : RowResult ⟨69, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_69_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨217, by decide⟩, by decide⟩

theorem row_69_239 : RowResult ⟨69, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_69_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 4 7)

theorem row_69_240 : RowResult ⟨69, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_69_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 2 4 6)

theorem row_69_241 : RowResult ⟨69, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_69_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_69_242 : RowResult ⟨69, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_69_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
