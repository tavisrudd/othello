import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_69_108 : RowResult ⟨69, by decide⟩ ⟨108, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_69_109 : RowResult ⟨69, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_69_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_69_110 : RowResult ⟨69, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_69_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_69_111 : RowResult ⟨69, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_69_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_69_112 : RowResult ⟨69, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_69_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 2 5 6)

theorem row_69_113 : RowResult ⟨69, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_69_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_69_114 : RowResult ⟨69, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_69_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 1 4 7)

theorem row_69_115 : RowResult ⟨69, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_69_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 2 4 7)

theorem row_69_116 : RowResult ⟨69, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_69_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_69_117 : RowResult ⟨69, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_69_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
