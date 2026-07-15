import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_71_172 : RowResult ⟨71, by decide⟩ ⟨172, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_71_173 : RowResult ⟨71, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_71_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_71_174 : RowResult ⟨71, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_71_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 4 5 6)

theorem row_71_175 : RowResult ⟨71, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_71_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_71_176 : RowResult ⟨71, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_71_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_71_177 : RowResult ⟨71, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_71_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_71_178 : RowResult ⟨71, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_71_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_71_179 : RowResult ⟨71, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_71_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_71_180 : RowResult ⟨71, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_71_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_71_181 : RowResult ⟨71, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_71_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 1 4 7)

theorem row_71_182 : RowResult ⟨71, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_71_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_71_183 : RowResult ⟨71, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_71_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_71_184 : RowResult ⟨71, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_71_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 2 4 6)

theorem row_71_185 : RowResult ⟨71, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_71_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_71_186 : RowResult ⟨71, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_71_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
