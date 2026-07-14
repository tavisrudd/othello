import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_44_96 : RowResult ⟨44, by decide⟩ ⟨96, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_44_97 : RowResult ⟨44, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_44_96
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_44_98 : RowResult ⟨44, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_44_97
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_44_99 : RowResult ⟨44, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_44_98
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_44_100 : RowResult ⟨44, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_44_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_44_101 : RowResult ⟨44, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_44_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_44_102 : RowResult ⟨44, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_44_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_44_103 : RowResult ⟨44, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_44_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_44_104 : RowResult ⟨44, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_44_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_44_105 : RowResult ⟨44, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_44_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_44_106 : RowResult ⟨44, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_44_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_44_107 : RowResult ⟨44, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_44_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_44_108 : RowResult ⟨44, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_44_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
