import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_109_160 : RowResult ⟨109, by decide⟩ ⟨160, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_109_161 : RowResult ⟨109, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_109_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_109_162 : RowResult ⟨109, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_109_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_109_163 : RowResult ⟨109, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_109_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_109_164 : RowResult ⟨109, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_109_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 2 5 7)

theorem row_109_165 : RowResult ⟨109, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_109_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 2 5 6)

theorem row_109_166 : RowResult ⟨109, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_109_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 2 4 7)

theorem row_109_167 : RowResult ⟨109, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_109_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_109_168 : RowResult ⟨109, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_109_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
