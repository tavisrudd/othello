import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_63_108 : RowResult ⟨63, by decide⟩ ⟨108, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_63_109 : RowResult ⟨63, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_63_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_63_110 : RowResult ⟨63, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_63_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 4 5 6)

theorem row_63_111 : RowResult ⟨63, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_63_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_63_112 : RowResult ⟨63, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_63_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_63_113 : RowResult ⟨63, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_63_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 1 4 6)

theorem row_63_114 : RowResult ⟨63, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_63_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_63_115 : RowResult ⟨63, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_63_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_63_116 : RowResult ⟨63, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_63_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 2 4 6)

theorem row_63_117 : RowResult ⟨63, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_63_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 2 4 7)

theorem row_63_118 : RowResult ⟨63, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_63_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 1 4 7)

theorem row_63_119 : RowResult ⟨63, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_63_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 2 5 6)

theorem row_63_120 : RowResult ⟨63, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_63_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
