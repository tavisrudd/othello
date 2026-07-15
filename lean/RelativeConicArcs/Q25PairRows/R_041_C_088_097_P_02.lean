import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_41_88 : RowResult ⟨41, by decide⟩ ⟨88, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_41_89 : RowResult ⟨41, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_41_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 2 4 7)

theorem row_41_90 : RowResult ⟨41, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_41_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 4 5 6)

theorem row_41_91 : RowResult ⟨41, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_41_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 1 4 6)

theorem row_41_92 : RowResult ⟨41, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_41_91
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_41_93 : RowResult ⟨41, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_41_92
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_41_94 : RowResult ⟨41, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_41_93
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_41_95 : RowResult ⟨41, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_41_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_41_96 : RowResult ⟨41, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_41_95
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_41_97 : RowResult ⟨41, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_41_96
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
