import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_124_219 : RowResult ⟨124, by decide⟩ ⟨219, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_124_220 : RowResult ⟨124, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_124_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_124_221 : RowResult ⟨124, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_124_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_124_222 : RowResult ⟨124, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_124_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 4 5 6)

theorem row_124_223 : RowResult ⟨124, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_124_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_124_224 : RowResult ⟨124, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_124_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
