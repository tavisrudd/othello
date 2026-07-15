import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_68_210 : RowResult ⟨68, by decide⟩ ⟨210, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_68_211 : RowResult ⟨68, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_68_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 2 5 6)

theorem row_68_212 : RowResult ⟨68, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_68_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_68_213 : RowResult ⟨68, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_68_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 1 4 7)

theorem row_68_214 : RowResult ⟨68, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_68_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 2 4 7)

theorem row_68_215 : RowResult ⟨68, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_68_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_68_216 : RowResult ⟨68, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_68_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_68_217 : RowResult ⟨68, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_68_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 4 5 6)

theorem row_68_218 : RowResult ⟨68, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_68_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 1 4 6)

theorem row_68_219 : RowResult ⟨68, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_68_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_68_220 : RowResult ⟨68, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_68_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_68_221 : RowResult ⟨68, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_68_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_68_222 : RowResult ⟨68, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_68_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
