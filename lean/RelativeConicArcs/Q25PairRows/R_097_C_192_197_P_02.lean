import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_97_192 : RowResult ⟨97, by decide⟩ ⟨192, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨238, by decide⟩, by decide⟩

theorem row_97_193 : RowResult ⟨97, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_97_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_97_194 : RowResult ⟨97, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_97_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_97_195 : RowResult ⟨97, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_97_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_97_196 : RowResult ⟨97, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_97_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 4 5 6)

theorem row_97_197 : RowResult ⟨97, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_97_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
