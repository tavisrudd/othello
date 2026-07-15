import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_62_139 : RowResult ⟨62, by decide⟩ ⟨139, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_62_140 : RowResult ⟨62, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_62_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_62_141 : RowResult ⟨62, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_62_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_62_142 : RowResult ⟨62, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_62_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 1 4 7)

theorem row_62_143 : RowResult ⟨62, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_62_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 2 4 7)

theorem row_62_144 : RowResult ⟨62, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_62_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_62_145 : RowResult ⟨62, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_62_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_62_146 : RowResult ⟨62, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_62_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_62_147 : RowResult ⟨62, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_62_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨241, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
