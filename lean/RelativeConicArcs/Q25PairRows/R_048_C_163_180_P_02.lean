import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_48_163 : RowResult ⟨48, by decide⟩ ⟨163, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_48_164 : RowResult ⟨48, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_48_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 4 5 6)

theorem row_48_165 : RowResult ⟨48, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_48_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_48_166 : RowResult ⟨48, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_48_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_48_167 : RowResult ⟨48, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_48_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 2 5 7)

theorem row_48_168 : RowResult ⟨48, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_48_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 2 4 7)

theorem row_48_169 : RowResult ⟨48, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_48_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 2 4 6)

theorem row_48_170 : RowResult ⟨48, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_48_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_48_171 : RowResult ⟨48, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_48_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_48_172 : RowResult ⟨48, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_48_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_48_173 : RowResult ⟨48, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_48_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 1 4 6)

theorem row_48_174 : RowResult ⟨48, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_48_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_48_175 : RowResult ⟨48, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_48_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_48_176 : RowResult ⟨48, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_48_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_48_177 : RowResult ⟨48, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_48_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_48_178 : RowResult ⟨48, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_48_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_48_179 : RowResult ⟨48, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_48_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_48_180 : RowResult ⟨48, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_48_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
