import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_140_208 : RowResult ⟨140, by decide⟩ ⟨208, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_140_209 : RowResult ⟨140, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_140_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_140_210 : RowResult ⟨140, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_140_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 1 4 7)

theorem row_140_211 : RowResult ⟨140, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_140_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_140_212 : RowResult ⟨140, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_140_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_140_213 : RowResult ⟨140, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_140_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_140_214 : RowResult ⟨140, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_140_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 2 4 7)

theorem row_140_215 : RowResult ⟨140, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_140_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 1 4 6)

theorem row_140_216 : RowResult ⟨140, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_140_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 2 5 7)

theorem row_140_217 : RowResult ⟨140, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_140_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_140_218 : RowResult ⟨140, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_140_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
