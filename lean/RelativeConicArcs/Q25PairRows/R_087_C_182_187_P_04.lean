import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_87_182 : RowResult ⟨87, by decide⟩ ⟨182, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_87_183 : RowResult ⟨87, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_87_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_87_184 : RowResult ⟨87, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_87_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 2 4 7)

theorem row_87_185 : RowResult ⟨87, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_87_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_87_186 : RowResult ⟨87, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_87_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 2 5 6)

theorem row_87_187 : RowResult ⟨87, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_87_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
