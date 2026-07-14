import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_124_208 : RowResult ⟨124, by decide⟩ ⟨208, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_124_209 : RowResult ⟨124, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_124_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 1 4 7)

theorem row_124_210 : RowResult ⟨124, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_124_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_124_211 : RowResult ⟨124, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_124_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_124_212 : RowResult ⟨124, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_124_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 2 4 7)

theorem row_124_213 : RowResult ⟨124, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_124_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 2 4 6)

theorem row_124_214 : RowResult ⟨124, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_124_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_124_215 : RowResult ⟨124, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_124_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 2 5 7)

theorem row_124_216 : RowResult ⟨124, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_124_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨167, by decide⟩, by decide⟩

theorem row_124_217 : RowResult ⟨124, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_124_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 2 5 6)

theorem row_124_218 : RowResult ⟨124, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_124_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨167, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
