import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_122_210 : RowResult ⟨122, by decide⟩ ⟨210, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_122_211 : RowResult ⟨122, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_122_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 2 5 6)

theorem row_122_212 : RowResult ⟨122, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_122_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_122_213 : RowResult ⟨122, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_122_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_122_214 : RowResult ⟨122, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_122_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 2 4 6)

theorem row_122_215 : RowResult ⟨122, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_122_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_122_216 : RowResult ⟨122, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_122_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_122_217 : RowResult ⟨122, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_122_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
