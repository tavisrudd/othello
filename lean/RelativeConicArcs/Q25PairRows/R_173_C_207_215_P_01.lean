import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_173_207 : RowResult ⟨173, by decide⟩ ⟨207, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_173_208 : RowResult ⟨173, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_173_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 1 4 7)

theorem row_173_209 : RowResult ⟨173, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_173_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_173_210 : RowResult ⟨173, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_173_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 2 4 7)

theorem row_173_211 : RowResult ⟨173, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_173_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_173_212 : RowResult ⟨173, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_173_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_173_213 : RowResult ⟨173, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_173_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_173_214 : RowResult ⟨173, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_173_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_173_215 : RowResult ⟨173, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_173_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
