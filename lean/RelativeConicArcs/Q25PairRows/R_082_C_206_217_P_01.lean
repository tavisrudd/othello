import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_82_206 : RowResult ⟨82, by decide⟩ ⟨206, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_82_207 : RowResult ⟨82, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_82_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 1 4 6)

theorem row_82_208 : RowResult ⟨82, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_82_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_82_209 : RowResult ⟨82, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_82_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_82_210 : RowResult ⟨82, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_82_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_82_211 : RowResult ⟨82, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_82_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_82_212 : RowResult ⟨82, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_82_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_82_213 : RowResult ⟨82, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_82_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 2 5 7)

theorem row_82_214 : RowResult ⟨82, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_82_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 2 4 7)

theorem row_82_215 : RowResult ⟨82, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_82_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 2 5 6)

theorem row_82_216 : RowResult ⟨82, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_82_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 4 5 6)

theorem row_82_217 : RowResult ⟨82, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_82_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
