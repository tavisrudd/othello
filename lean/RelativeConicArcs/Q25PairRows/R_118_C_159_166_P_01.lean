import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_118_159 : RowResult ⟨118, by decide⟩ ⟨159, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_118_160 : RowResult ⟨118, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_118_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨236, by decide⟩, by decide⟩

theorem row_118_161 : RowResult ⟨118, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_118_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_118_162 : RowResult ⟨118, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_118_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_118_163 : RowResult ⟨118, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_118_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 1 4 7)

theorem row_118_164 : RowResult ⟨118, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_118_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_118_165 : RowResult ⟨118, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_118_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_118_166 : RowResult ⟨118, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_118_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
