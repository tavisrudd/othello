import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_48_111 : RowResult ⟨48, by decide⟩ ⟨111, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨63, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_48_112 : RowResult ⟨48, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_48_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 4 5 6)

theorem row_48_113 : RowResult ⟨48, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_48_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨67, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_48_114 : RowResult ⟨48, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_48_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_48_115 : RowResult ⟨48, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_48_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_48_116 : RowResult ⟨48, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_48_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_48_117 : RowResult ⟨48, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_48_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨241, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
