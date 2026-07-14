import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_69_208 : RowResult ⟨69, by decide⟩ ⟨208, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_69_209 : RowResult ⟨69, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_69_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_69_210 : RowResult ⟨69, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_69_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_69_211 : RowResult ⟨69, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_69_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_69_212 : RowResult ⟨69, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_69_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_69_213 : RowResult ⟨69, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_69_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_69_214 : RowResult ⟨69, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_69_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 1 4 7)

theorem row_69_215 : RowResult ⟨69, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_69_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨231, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
