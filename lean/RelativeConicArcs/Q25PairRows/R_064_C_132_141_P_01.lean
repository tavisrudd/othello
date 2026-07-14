import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_64_132 : RowResult ⟨64, by decide⟩ ⟨132, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_64_133 : RowResult ⟨64, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_64_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 2 5 7)

theorem row_64_134 : RowResult ⟨64, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_64_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_64_135 : RowResult ⟨64, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_64_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 2 4 6)

theorem row_64_136 : RowResult ⟨64, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_64_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_64_137 : RowResult ⟨64, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_64_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_64_138 : RowResult ⟨64, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_64_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_64_139 : RowResult ⟨64, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_64_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 1 4 6)

theorem row_64_140 : RowResult ⟨64, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_64_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_64_141 : RowResult ⟨64, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_64_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
