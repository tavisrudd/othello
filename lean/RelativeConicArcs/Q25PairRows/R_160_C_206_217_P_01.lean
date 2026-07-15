import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_160_206 : RowResult ⟨160, by decide⟩ ⟨206, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_160_207 : RowResult ⟨160, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_160_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 2 4 7)

theorem row_160_208 : RowResult ⟨160, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_160_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 2 5 7)

theorem row_160_209 : RowResult ⟨160, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_160_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_160_210 : RowResult ⟨160, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_160_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 1 4 6)

theorem row_160_211 : RowResult ⟨160, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_160_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_160_212 : RowResult ⟨160, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_160_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 4 5 6)

theorem row_160_213 : RowResult ⟨160, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_160_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_160_214 : RowResult ⟨160, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_160_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_160_215 : RowResult ⟨160, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_160_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 1 4 7)

theorem row_160_216 : RowResult ⟨160, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_160_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_160_217 : RowResult ⟨160, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_160_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
