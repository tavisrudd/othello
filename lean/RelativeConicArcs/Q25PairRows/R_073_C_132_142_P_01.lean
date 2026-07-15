import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false
set_option linter.unusedVariables false

theorem row_73_132 : RowResult ⟨73, by decide⟩ ⟨132, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_73_133 : RowResult ⟨73, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_73_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 1 4 7)

theorem row_73_134 : RowResult ⟨73, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_73_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_73_135 : RowResult ⟨73, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_73_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_73_136 : RowResult ⟨73, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_73_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_73_137 : RowResult ⟨73, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_73_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_73_138 : RowResult ⟨73, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_73_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 2 4 7)

theorem row_73_139 : RowResult ⟨73, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_73_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_73_140 : RowResult ⟨73, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_73_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 2 5 7)

theorem row_73_141 : RowResult ⟨73, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_73_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_73_142 : RowResult ⟨73, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_73_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
