import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_74_110 : RowResult ⟨74, by decide⟩ ⟨110, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_74_111 : RowResult ⟨74, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_74_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_74_112 : RowResult ⟨74, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_74_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_74_113 : RowResult ⟨74, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_74_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 2 4 6)

theorem row_74_114 : RowResult ⟨74, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_74_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_74_115 : RowResult ⟨74, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_74_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_74_116 : RowResult ⟨74, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_74_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 2 5 6)

theorem row_74_117 : RowResult ⟨74, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_74_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 2 5 7)

theorem row_74_118 : RowResult ⟨74, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_74_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
