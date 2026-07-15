import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_169_206 : RowResult ⟨169, by decide⟩ ⟨206, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_169_207 : RowResult ⟨169, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_169_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_169_208 : RowResult ⟨169, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_169_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_169_209 : RowResult ⟨169, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_169_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_169_210 : RowResult ⟨169, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_169_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 2 5 7)

theorem row_169_211 : RowResult ⟨169, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_169_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_169_212 : RowResult ⟨169, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_169_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 2 4 6)

theorem row_169_213 : RowResult ⟨169, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_169_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_169_214 : RowResult ⟨169, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_169_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 1 4 7)

theorem row_169_215 : RowResult ⟨169, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_169_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
