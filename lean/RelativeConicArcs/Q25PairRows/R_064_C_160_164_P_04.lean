import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_64_160 : RowResult ⟨64, by decide⟩ ⟨160, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_64_161 : RowResult ⟨64, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_64_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_64_162 : RowResult ⟨64, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_64_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 2 5 7)

theorem row_64_163 : RowResult ⟨64, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_64_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 4 5 6)

theorem row_64_164 : RowResult ⟨64, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_64_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
