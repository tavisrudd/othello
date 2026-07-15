import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_62_109 : RowResult ⟨62, by decide⟩ ⟨109, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_62_110 : RowResult ⟨62, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_62_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_62_111 : RowResult ⟨62, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_62_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_62_112 : RowResult ⟨62, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_62_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 1 4 6)

theorem row_62_113 : RowResult ⟨62, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_62_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_62_114 : RowResult ⟨62, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_62_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 4 5 6)

theorem row_62_115 : RowResult ⟨62, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_62_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_62_116 : RowResult ⟨62, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_62_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_62_117 : RowResult ⟨62, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_62_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
