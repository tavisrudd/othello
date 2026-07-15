import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_44_136 : RowResult ⟨44, by decide⟩ ⟨136, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_44_137 : RowResult ⟨44, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_44_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_44_138 : RowResult ⟨44, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_44_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 2 4 6)

theorem row_44_139 : RowResult ⟨44, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_44_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 1 4 7)

theorem row_44_140 : RowResult ⟨44, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_44_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_44_141 : RowResult ⟨44, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_44_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_44_142 : RowResult ⟨44, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_44_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 4 5 6)

theorem row_44_143 : RowResult ⟨44, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_44_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_44_144 : RowResult ⟨44, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_44_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
