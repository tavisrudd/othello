import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_119_163 : RowResult ⟨119, by decide⟩ ⟨163, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_119_164 : RowResult ⟨119, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_119_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 1 4 7)

theorem row_119_165 : RowResult ⟨119, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_119_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_119_166 : RowResult ⟨119, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_119_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 2 5 7)

theorem row_119_167 : RowResult ⟨119, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_119_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 4 5 6)

theorem row_119_168 : RowResult ⟨119, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_119_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_119_169 : RowResult ⟨119, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_119_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 1 4 6)

theorem row_119_170 : RowResult ⟨119, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_119_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_119_171 : RowResult ⟨119, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_119_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 2 4 6)

theorem row_119_172 : RowResult ⟨119, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_119_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_119_173 : RowResult ⟨119, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_119_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨241, by decide⟩, by decide⟩

theorem row_119_174 : RowResult ⟨119, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_119_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_119_175 : RowResult ⟨119, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_119_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_119_176 : RowResult ⟨119, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_119_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_119_177 : RowResult ⟨119, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_119_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_119_178 : RowResult ⟨119, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_119_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_119_179 : RowResult ⟨119, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_119_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_119_180 : RowResult ⟨119, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_119_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
