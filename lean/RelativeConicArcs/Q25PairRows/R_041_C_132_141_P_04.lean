import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_41_132 : RowResult ⟨41, by decide⟩ ⟨132, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_41_133 : RowResult ⟨41, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_41_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_41_134 : RowResult ⟨41, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_41_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩, by decide⟩

theorem row_41_135 : RowResult ⟨41, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_41_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_41_136 : RowResult ⟨41, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_41_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 1 4 7)

theorem row_41_137 : RowResult ⟨41, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_41_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_41_138 : RowResult ⟨41, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_41_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_41_139 : RowResult ⟨41, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_41_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 2 5 6)

theorem row_41_140 : RowResult ⟨41, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_41_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_41_141 : RowResult ⟨41, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_41_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
