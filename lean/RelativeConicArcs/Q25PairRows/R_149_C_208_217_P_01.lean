import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_149_208 : RowResult ⟨149, by decide⟩ ⟨208, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_149_209 : RowResult ⟨149, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_149_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 1 4 7)

theorem row_149_210 : RowResult ⟨149, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_149_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 2 4 7)

theorem row_149_211 : RowResult ⟨149, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_149_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_149_212 : RowResult ⟨149, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_149_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

theorem row_149_213 : RowResult ⟨149, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_149_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 4 5 6)

theorem row_149_214 : RowResult ⟨149, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_149_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 2 5 7)

theorem row_149_215 : RowResult ⟨149, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_149_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_149_216 : RowResult ⟨149, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_149_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_149_217 : RowResult ⟨149, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_149_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
