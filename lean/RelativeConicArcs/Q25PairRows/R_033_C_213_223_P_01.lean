import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_33_213 : RowResult ⟨33, by decide⟩ ⟨213, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_33_214 : RowResult ⟨33, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_33_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_33_215 : RowResult ⟨33, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_33_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 4 5 6)

theorem row_33_216 : RowResult ⟨33, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_33_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_33_217 : RowResult ⟨33, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_33_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_33_218 : RowResult ⟨33, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_33_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_219 : RowResult ⟨33, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_33_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 2 4 7)

theorem row_33_220 : RowResult ⟨33, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_33_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_33_221 : RowResult ⟨33, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_33_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 2 5 6)

theorem row_33_222 : RowResult ⟨33, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_33_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_223 : RowResult ⟨33, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_33_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
