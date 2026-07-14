import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_71_92 : RowResult ⟨71, by decide⟩ ⟨92, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_71_93 : RowResult ⟨71, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_71_92
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_71_94 : RowResult ⟨71, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_71_93
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_71_95 : RowResult ⟨71, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_71_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_71_96 : RowResult ⟨71, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_71_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 1 4 6)

theorem row_71_97 : RowResult ⟨71, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_71_96
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_71_98 : RowResult ⟨71, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_71_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 2 4 7)

theorem row_71_99 : RowResult ⟨71, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_71_98
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_71_100 : RowResult ⟨71, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_71_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_71_101 : RowResult ⟨71, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_71_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_71_102 : RowResult ⟨71, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_71_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_71_103 : RowResult ⟨71, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_71_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_71_104 : RowResult ⟨71, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_71_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_71_105 : RowResult ⟨71, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_71_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_71_106 : RowResult ⟨71, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_71_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 1 4 7)

theorem row_71_107 : RowResult ⟨71, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_71_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_71_108 : RowResult ⟨71, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_71_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
