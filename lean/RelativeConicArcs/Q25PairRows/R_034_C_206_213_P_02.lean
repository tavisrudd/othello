import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_34_206 : RowResult ⟨34, by decide⟩ ⟨206, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_34_207 : RowResult ⟨34, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_34_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 2 4 7)

theorem row_34_208 : RowResult ⟨34, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_34_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_34_209 : RowResult ⟨34, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_34_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 1 4 6)

theorem row_34_210 : RowResult ⟨34, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_34_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨66, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_34_211 : RowResult ⟨34, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_34_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_34_212 : RowResult ⟨34, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_34_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_34_213 : RowResult ⟨34, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_34_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
