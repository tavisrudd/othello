import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_49_206 : RowResult ⟨49, by decide⟩ ⟨206, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_49_207 : RowResult ⟨49, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_49_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨63, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_49_208 : RowResult ⟨49, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_49_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_49_209 : RowResult ⟨49, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_49_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 1 4 7)

theorem row_49_210 : RowResult ⟨49, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_49_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_49_211 : RowResult ⟨49, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_49_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_49_212 : RowResult ⟨49, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_49_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 4 5 6)

theorem row_49_213 : RowResult ⟨49, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_49_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_49_214 : RowResult ⟨49, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_49_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
