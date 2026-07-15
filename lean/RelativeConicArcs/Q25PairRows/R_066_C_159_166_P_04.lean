import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_66_159 : RowResult ⟨66, by decide⟩ ⟨159, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_66_160 : RowResult ⟨66, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_66_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_66_161 : RowResult ⟨66, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_66_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 1 4 7)

theorem row_66_162 : RowResult ⟨66, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_66_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_66_163 : RowResult ⟨66, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_66_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 2 4 6)

theorem row_66_164 : RowResult ⟨66, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_66_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_66_165 : RowResult ⟨66, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_66_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_66_166 : RowResult ⟨66, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_66_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
