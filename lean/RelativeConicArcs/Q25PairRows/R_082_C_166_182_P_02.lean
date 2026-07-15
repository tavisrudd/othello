import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_82_166 : RowResult ⟨82, by decide⟩ ⟨166, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_82_167 : RowResult ⟨82, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_82_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_82_168 : RowResult ⟨82, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_82_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 4 5 6)

theorem row_82_169 : RowResult ⟨82, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_82_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_82_170 : RowResult ⟨82, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_82_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_82_171 : RowResult ⟨82, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_82_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 2 4 7)

theorem row_82_172 : RowResult ⟨82, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_82_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 1 4 7)

theorem row_82_173 : RowResult ⟨82, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_82_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_82_174 : RowResult ⟨82, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_82_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_82_175 : RowResult ⟨82, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_82_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_82_176 : RowResult ⟨82, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_82_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_82_177 : RowResult ⟨82, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_82_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_82_178 : RowResult ⟨82, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_82_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_82_179 : RowResult ⟨82, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_82_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_82_180 : RowResult ⟨82, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_82_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_82_181 : RowResult ⟨82, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_82_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_82_182 : RowResult ⟨82, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_82_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
