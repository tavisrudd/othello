import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_108_209 : RowResult ⟨108, by decide⟩ ⟨209, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_108_210 : RowResult ⟨108, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_108_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_108_211 : RowResult ⟨108, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_108_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 2 4 7)

theorem row_108_212 : RowResult ⟨108, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_108_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_108_213 : RowResult ⟨108, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_108_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_108_214 : RowResult ⟨108, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_108_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 2 5 7)

theorem row_108_215 : RowResult ⟨108, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_108_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_108_216 : RowResult ⟨108, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_108_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_108_217 : RowResult ⟨108, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_108_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
