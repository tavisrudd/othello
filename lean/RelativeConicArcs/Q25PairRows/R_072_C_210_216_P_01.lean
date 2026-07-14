import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_72_210 : RowResult ⟨72, by decide⟩ ⟨210, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_72_211 : RowResult ⟨72, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_72_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_72_212 : RowResult ⟨72, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_72_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_72_213 : RowResult ⟨72, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_72_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨231, by decide⟩, by decide⟩

theorem row_72_214 : RowResult ⟨72, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_72_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_72_215 : RowResult ⟨72, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_72_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_72_216 : RowResult ⟨72, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_72_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
