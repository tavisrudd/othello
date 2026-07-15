import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_99_157 : RowResult ⟨99, by decide⟩ ⟨157, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_99_158 : RowResult ⟨99, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_99_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_99_159 : RowResult ⟨99, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_99_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 1 4 7)

theorem row_99_160 : RowResult ⟨99, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_99_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_99_161 : RowResult ⟨99, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_99_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_99_162 : RowResult ⟨99, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_99_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_99_163 : RowResult ⟨99, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_99_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 4 5 6)

theorem row_99_164 : RowResult ⟨99, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_99_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_99_165 : RowResult ⟨99, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_99_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
