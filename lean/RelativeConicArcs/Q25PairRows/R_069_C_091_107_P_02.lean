import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_69_91 : RowResult ⟨69, by decide⟩ ⟨91, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_69_92 : RowResult ⟨69, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_69_91
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_69_93 : RowResult ⟨69, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_69_92
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_69_94 : RowResult ⟨69, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_69_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 1 4 6)

theorem row_69_95 : RowResult ⟨69, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_69_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_69_96 : RowResult ⟨69, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_69_95
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_69_97 : RowResult ⟨69, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_69_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 2 4 7)

theorem row_69_98 : RowResult ⟨69, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_69_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 2 5 7)

theorem row_69_99 : RowResult ⟨69, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_69_98
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_69_100 : RowResult ⟨69, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_69_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_69_101 : RowResult ⟨69, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_69_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_69_102 : RowResult ⟨69, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_69_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_69_103 : RowResult ⟨69, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_69_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_69_104 : RowResult ⟨69, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_69_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_69_105 : RowResult ⟨69, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_69_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_69_106 : RowResult ⟨69, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_69_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_69_107 : RowResult ⟨69, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_69_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
