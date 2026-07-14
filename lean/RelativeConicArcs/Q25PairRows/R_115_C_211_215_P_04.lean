import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_115_211 : RowResult ⟨115, by decide⟩ ⟨211, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_115_212 : RowResult ⟨115, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_115_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_115_213 : RowResult ⟨115, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_115_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_115_214 : RowResult ⟨115, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_115_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_115_215 : RowResult ⟨115, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_115_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
