import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_132_206 : RowResult ⟨132, by decide⟩ ⟨206, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_132_207 : RowResult ⟨132, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_132_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 1 4 6)

theorem row_132_208 : RowResult ⟨132, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_132_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_132_209 : RowResult ⟨132, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_132_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_132_210 : RowResult ⟨132, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_132_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_132_211 : RowResult ⟨132, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_132_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_132_212 : RowResult ⟨132, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_132_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 2 4 7)

theorem row_132_213 : RowResult ⟨132, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_132_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 2 4 6)

theorem row_132_214 : RowResult ⟨132, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_132_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_132_215 : RowResult ⟨132, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_132_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
