import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_42_159 : RowResult ⟨42, by decide⟩ ⟨159, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨64, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_42_160 : RowResult ⟨42, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_42_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨238, by decide⟩, by decide⟩

theorem row_42_161 : RowResult ⟨42, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_42_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_42_162 : RowResult ⟨42, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_42_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 1 4 7)

theorem row_42_163 : RowResult ⟨42, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_42_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_42_164 : RowResult ⟨42, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_42_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_42_165 : RowResult ⟨42, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_42_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
