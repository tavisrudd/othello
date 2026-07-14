import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_67_207 : RowResult ⟨67, by decide⟩ ⟨207, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_67_208 : RowResult ⟨67, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_67_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 2 5 6)

theorem row_67_209 : RowResult ⟨67, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_67_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_67_210 : RowResult ⟨67, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_67_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_67_211 : RowResult ⟨67, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_67_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_67_212 : RowResult ⟨67, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_67_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 1 4 7)

theorem row_67_213 : RowResult ⟨67, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_67_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_67_214 : RowResult ⟨67, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_67_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_67_215 : RowResult ⟨67, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_67_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_67_216 : RowResult ⟨67, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_67_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 4 5 6)

theorem row_67_217 : RowResult ⟨67, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_67_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 1 4 6)

theorem row_67_218 : RowResult ⟨67, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_67_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
