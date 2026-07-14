import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_39_90 : RowResult ⟨39, by decide⟩ ⟨90, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_39_91 : RowResult ⟨39, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_39_90
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_39_92 : RowResult ⟨39, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_39_91
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_39_93 : RowResult ⟨39, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_39_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 2 5 6)

theorem row_39_94 : RowResult ⟨39, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_39_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 1 4 7)

theorem row_39_95 : RowResult ⟨39, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_39_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_39_96 : RowResult ⟨39, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_39_95
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_39_97 : RowResult ⟨39, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_39_96
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_39_98 : RowResult ⟨39, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_39_97
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
