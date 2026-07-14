import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_109_210 : RowResult ⟨109, by decide⟩ ⟨210, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 2 5 6)

theorem row_109_211 : RowResult ⟨109, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_109_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_109_212 : RowResult ⟨109, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_109_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_109_213 : RowResult ⟨109, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_109_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_109_214 : RowResult ⟨109, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_109_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_109_215 : RowResult ⟨109, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_109_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_109_216 : RowResult ⟨109, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_109_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
