import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_43_117 : RowResult ⟨43, by decide⟩ ⟨117, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_43_118 : RowResult ⟨43, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_43_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 1 4 6)

theorem row_43_119 : RowResult ⟨43, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_43_118
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_43_120 : RowResult ⟨43, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_43_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_43_121 : RowResult ⟨43, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_43_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 4 5 6)

theorem row_43_122 : RowResult ⟨43, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_43_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨241, by decide⟩, by decide⟩

theorem row_43_123 : RowResult ⟨43, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_43_122
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_43_124 : RowResult ⟨43, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_43_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 2 4 6)

theorem row_43_125 : RowResult ⟨43, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_43_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_43_126 : RowResult ⟨43, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_43_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_43_127 : RowResult ⟨43, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_43_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_43_128 : RowResult ⟨43, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_43_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_43_129 : RowResult ⟨43, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_43_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_43_130 : RowResult ⟨43, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_43_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_43_131 : RowResult ⟨43, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_43_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_43_132 : RowResult ⟨43, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_43_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 2 4 6)

theorem row_43_133 : RowResult ⟨43, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_43_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
