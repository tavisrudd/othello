import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_134_207 : RowResult ⟨134, by decide⟩ ⟨207, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_134_208 : RowResult ⟨134, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_134_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_134_209 : RowResult ⟨134, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_134_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 1 4 6)

theorem row_134_210 : RowResult ⟨134, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_134_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_134_211 : RowResult ⟨134, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_134_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_134_212 : RowResult ⟨134, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_134_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨196, by decide⟩, by decide⟩

theorem row_134_213 : RowResult ⟨134, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_134_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
