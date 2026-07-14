import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_34_85 : RowResult ⟨34, by decide⟩ ⟨85, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_34_86 : RowResult ⟨34, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_34_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_34_87 : RowResult ⟨34, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_34_86
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_34_88 : RowResult ⟨34, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_34_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 2 4 7)

theorem row_34_89 : RowResult ⟨34, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_34_88
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩, by decide⟩

theorem row_34_90 : RowResult ⟨34, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_34_89
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_34_91 : RowResult ⟨34, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_34_90
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_34_92 : RowResult ⟨34, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_34_91
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
