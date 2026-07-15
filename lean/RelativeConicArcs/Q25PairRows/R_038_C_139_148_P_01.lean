import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_38_139 : RowResult ⟨38, by decide⟩ ⟨139, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_38_140 : RowResult ⟨38, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_38_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 2 5 7)

theorem row_38_141 : RowResult ⟨38, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_38_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_38_142 : RowResult ⟨38, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_38_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_38_143 : RowResult ⟨38, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_38_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 1 4 7)

theorem row_38_144 : RowResult ⟨38, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_38_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_38_145 : RowResult ⟨38, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_38_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_38_146 : RowResult ⟨38, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_38_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_38_147 : RowResult ⟨38, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_38_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_38_148 : RowResult ⟨38, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_38_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
