import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false
set_option linter.unusedVariables false

theorem row_73_90 : RowResult ⟨73, by decide⟩ ⟨90, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_73_91 : RowResult ⟨73, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_73_90
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_73_92 : RowResult ⟨73, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_73_91
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_73_93 : RowResult ⟨73, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_73_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 4 5 6)

theorem row_73_94 : RowResult ⟨73, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_73_93
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_73_95 : RowResult ⟨73, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_73_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_73_96 : RowResult ⟨73, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_73_95
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_73_97 : RowResult ⟨73, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_73_96
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_73_98 : RowResult ⟨73, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_73_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
