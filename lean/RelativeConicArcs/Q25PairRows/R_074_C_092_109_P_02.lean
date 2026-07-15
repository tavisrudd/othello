import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_74_92 : RowResult ⟨74, by decide⟩ ⟨92, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_74_93 : RowResult ⟨74, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_74_92
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨236, by decide⟩, by decide⟩

theorem row_74_94 : RowResult ⟨74, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_74_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 4 5 6)

theorem row_74_95 : RowResult ⟨74, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_74_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_74_96 : RowResult ⟨74, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_74_95
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_74_97 : RowResult ⟨74, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_74_96
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_74_98 : RowResult ⟨74, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_74_97
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_74_99 : RowResult ⟨74, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_74_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 1 4 6)

theorem row_74_100 : RowResult ⟨74, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_74_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_74_101 : RowResult ⟨74, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_74_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_74_102 : RowResult ⟨74, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_74_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_74_103 : RowResult ⟨74, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_74_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_74_104 : RowResult ⟨74, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_74_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_74_105 : RowResult ⟨74, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_74_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_74_106 : RowResult ⟨74, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_74_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 2 4 7)

theorem row_74_107 : RowResult ⟨74, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_74_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_74_108 : RowResult ⟨74, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_74_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_74_109 : RowResult ⟨74, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_74_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
