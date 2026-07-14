import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_43_84 : RowResult ⟨43, by decide⟩ ⟨84, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_43_85 : RowResult ⟨43, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_43_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 2 4 6)

theorem row_43_86 : RowResult ⟨43, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_43_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_43_87 : RowResult ⟨43, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_43_86
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_43_88 : RowResult ⟨43, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_43_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 1 4 7)

theorem row_43_89 : RowResult ⟨43, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_43_88
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_43_90 : RowResult ⟨43, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_43_89
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_43_91 : RowResult ⟨43, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_43_90
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_43_92 : RowResult ⟨43, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_43_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 4 5 6)

theorem row_43_93 : RowResult ⟨43, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_43_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 1 4 6)

theorem row_43_94 : RowResult ⟨43, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_43_93
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_43_95 : RowResult ⟨43, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_43_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
