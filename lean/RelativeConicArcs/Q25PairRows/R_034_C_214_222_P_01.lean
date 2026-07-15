import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_34_214 : RowResult ⟨34, by decide⟩ ⟨214, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_34_215 : RowResult ⟨34, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_34_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_34_216 : RowResult ⟨34, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_34_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 4 5 6)

theorem row_34_217 : RowResult ⟨34, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_34_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 2 5 7)

theorem row_34_218 : RowResult ⟨34, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_34_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_34_219 : RowResult ⟨34, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_34_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_34_220 : RowResult ⟨34, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_34_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_34_221 : RowResult ⟨34, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_34_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_34_222 : RowResult ⟨34, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_34_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
