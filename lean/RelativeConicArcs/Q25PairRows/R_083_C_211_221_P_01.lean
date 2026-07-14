import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_83_211 : RowResult ⟨83, by decide⟩ ⟨211, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_83_212 : RowResult ⟨83, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_83_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 2 5 7)

theorem row_83_213 : RowResult ⟨83, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_83_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 2 5 6)

theorem row_83_214 : RowResult ⟨83, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_83_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_83_215 : RowResult ⟨83, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_83_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_83_216 : RowResult ⟨83, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_83_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_83_217 : RowResult ⟨83, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_83_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 4 5 6)

theorem row_83_218 : RowResult ⟨83, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_83_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 2 4 6)

theorem row_83_219 : RowResult ⟨83, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_83_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_83_220 : RowResult ⟨83, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_83_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_83_221 : RowResult ⟨83, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_83_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
