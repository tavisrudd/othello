import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_49_88 : RowResult ⟨49, by decide⟩ ⟨88, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_49_89 : RowResult ⟨49, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_49_88
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_49_90 : RowResult ⟨49, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_49_89
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_49_91 : RowResult ⟨49, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_49_90
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_49_92 : RowResult ⟨49, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_49_91
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_49_93 : RowResult ⟨49, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_49_92
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_49_94 : RowResult ⟨49, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_49_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 2 5 7)

theorem row_49_95 : RowResult ⟨49, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_49_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_49_96 : RowResult ⟨49, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_49_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
