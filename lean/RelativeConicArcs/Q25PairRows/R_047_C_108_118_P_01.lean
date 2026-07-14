import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_47_108 : RowResult ⟨47, by decide⟩ ⟨108, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_47_109 : RowResult ⟨47, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_47_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_47_110 : RowResult ⟨47, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_47_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 2 5 6)

theorem row_47_111 : RowResult ⟨47, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_47_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 4 5 6)

theorem row_47_112 : RowResult ⟨47, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_47_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_47_113 : RowResult ⟨47, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_47_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_47_114 : RowResult ⟨47, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_47_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_47_115 : RowResult ⟨47, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_47_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_47_116 : RowResult ⟨47, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_47_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 2 4 6)

theorem row_47_117 : RowResult ⟨47, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_47_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 2 4 7)

theorem row_47_118 : RowResult ⟨47, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_47_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
