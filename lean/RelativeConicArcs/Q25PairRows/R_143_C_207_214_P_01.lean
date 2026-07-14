import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_143_207 : RowResult ⟨143, by decide⟩ ⟨207, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_143_208 : RowResult ⟨143, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_143_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_143_209 : RowResult ⟨143, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_143_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_143_210 : RowResult ⟨143, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_143_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_143_211 : RowResult ⟨143, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_143_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_143_212 : RowResult ⟨143, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_143_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_143_213 : RowResult ⟨143, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_143_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 1 4 7)

theorem row_143_214 : RowResult ⟨143, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_143_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
