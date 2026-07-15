import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_62_172 : RowResult ⟨62, by decide⟩ ⟨172, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_62_173 : RowResult ⟨62, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_62_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_62_174 : RowResult ⟨62, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_62_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_62_175 : RowResult ⟨62, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_62_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_62_176 : RowResult ⟨62, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_62_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_62_177 : RowResult ⟨62, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_62_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_62_178 : RowResult ⟨62, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_62_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_62_179 : RowResult ⟨62, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_62_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_62_180 : RowResult ⟨62, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_62_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_62_181 : RowResult ⟨62, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_62_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_62_182 : RowResult ⟨62, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_62_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_62_183 : RowResult ⟨62, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_62_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 2 4 6)

theorem row_62_184 : RowResult ⟨62, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_62_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_62_185 : RowResult ⟨62, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_62_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
