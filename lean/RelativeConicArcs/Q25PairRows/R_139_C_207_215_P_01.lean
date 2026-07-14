import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_139_207 : RowResult ⟨139, by decide⟩ ⟨207, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_139_208 : RowResult ⟨139, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_139_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_139_209 : RowResult ⟨139, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_139_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_139_210 : RowResult ⟨139, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_139_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_139_211 : RowResult ⟨139, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_139_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_139_212 : RowResult ⟨139, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_139_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 2 4 6)

theorem row_139_213 : RowResult ⟨139, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_139_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_139_214 : RowResult ⟨139, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_139_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 1 4 6)

theorem row_139_215 : RowResult ⟨139, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_139_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
