import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_61_88 : RowResult ⟨61, by decide⟩ ⟨88, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_61_89 : RowResult ⟨61, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_61_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 2 5 6)

theorem row_61_90 : RowResult ⟨61, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_61_89
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_61_91 : RowResult ⟨61, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_61_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 1 4 7)

theorem row_61_92 : RowResult ⟨61, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_61_91
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_61_93 : RowResult ⟨61, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_61_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 2 4 6)

theorem row_61_94 : RowResult ⟨61, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_61_93
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_61_95 : RowResult ⟨61, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_61_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_61_96 : RowResult ⟨61, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_61_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 4 5 6)

theorem row_61_97 : RowResult ⟨61, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_61_96
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_61_98 : RowResult ⟨61, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_61_97
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
