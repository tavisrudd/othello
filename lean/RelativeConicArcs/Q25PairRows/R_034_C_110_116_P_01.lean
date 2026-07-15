import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_34_110 : RowResult ⟨34, by decide⟩ ⟨110, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_34_111 : RowResult ⟨34, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_34_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_34_112 : RowResult ⟨34, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_34_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_34_113 : RowResult ⟨34, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_34_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_34_114 : RowResult ⟨34, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_34_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_34_115 : RowResult ⟨34, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_34_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 4 5 6)

theorem row_34_116 : RowResult ⟨34, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_34_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
