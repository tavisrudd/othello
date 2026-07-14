import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_69_133 : RowResult ⟨69, by decide⟩ ⟨133, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_69_134 : RowResult ⟨69, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_69_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 2 5 7)

theorem row_69_135 : RowResult ⟨69, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_69_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_69_136 : RowResult ⟨69, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_69_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 2 4 7)

theorem row_69_137 : RowResult ⟨69, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_69_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_69_138 : RowResult ⟨69, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_69_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_69_139 : RowResult ⟨69, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_69_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 1 4 7)

theorem row_69_140 : RowResult ⟨69, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_69_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_69_141 : RowResult ⟨69, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_69_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_69_142 : RowResult ⟨69, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_69_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_69_143 : RowResult ⟨69, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_69_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 2 5 6)

theorem row_69_144 : RowResult ⟨69, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_69_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 1 4 6)

theorem row_69_145 : RowResult ⟨69, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_69_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
