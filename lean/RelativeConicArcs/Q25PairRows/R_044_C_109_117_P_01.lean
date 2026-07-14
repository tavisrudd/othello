import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_44_109 : RowResult ⟨44, by decide⟩ ⟨109, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_110 : RowResult ⟨44, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_44_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_44_111 : RowResult ⟨44, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_44_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_44_112 : RowResult ⟨44, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_44_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_44_113 : RowResult ⟨44, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_44_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_114 : RowResult ⟨44, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_44_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 1 4 7)

theorem row_44_115 : RowResult ⟨44, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_44_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_44_116 : RowResult ⟨44, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_44_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 2 5 6)

theorem row_44_117 : RowResult ⟨44, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_44_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
