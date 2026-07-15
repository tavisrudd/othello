import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_124_160 : RowResult ⟨124, by decide⟩ ⟨160, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_124_161 : RowResult ⟨124, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_124_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_124_162 : RowResult ⟨124, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_124_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_124_163 : RowResult ⟨124, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_124_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_124_164 : RowResult ⟨124, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_124_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_124_165 : RowResult ⟨124, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_124_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_124_166 : RowResult ⟨124, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_124_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
