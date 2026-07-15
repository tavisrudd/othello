import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_43_207 : RowResult ⟨43, by decide⟩ ⟨207, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_43_208 : RowResult ⟨43, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_43_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_43_209 : RowResult ⟨43, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_43_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_43_210 : RowResult ⟨43, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_43_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_43_211 : RowResult ⟨43, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_43_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_43_212 : RowResult ⟨43, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_43_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 2 4 7)

theorem row_43_213 : RowResult ⟨43, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_43_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 1 4 7)

theorem row_43_214 : RowResult ⟨43, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_43_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 2 5 7)

theorem row_43_215 : RowResult ⟨43, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_43_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_43_216 : RowResult ⟨43, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_43_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
