import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_82_159 : RowResult ⟨82, by decide⟩ ⟨159, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_82_160 : RowResult ⟨82, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_82_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_82_161 : RowResult ⟨82, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_82_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_82_162 : RowResult ⟨82, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_82_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_82_163 : RowResult ⟨82, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_82_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_82_164 : RowResult ⟨82, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_82_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 2 4 6)

theorem row_82_165 : RowResult ⟨82, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_82_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
