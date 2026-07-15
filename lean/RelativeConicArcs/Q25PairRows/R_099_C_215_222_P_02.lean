import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_99_215 : RowResult ⟨99, by decide⟩ ⟨215, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_99_216 : RowResult ⟨99, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_99_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_99_217 : RowResult ⟨99, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_99_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_99_218 : RowResult ⟨99, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_99_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_99_219 : RowResult ⟨99, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_99_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_99_220 : RowResult ⟨99, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_99_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_99_221 : RowResult ⟨99, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_99_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 2 5 7)

theorem row_99_222 : RowResult ⟨99, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_99_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
