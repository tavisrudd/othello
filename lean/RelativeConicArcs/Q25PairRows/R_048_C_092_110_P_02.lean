import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_48_92 : RowResult ⟨48, by decide⟩ ⟨92, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_48_93 : RowResult ⟨48, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_48_92
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_48_94 : RowResult ⟨48, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_48_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 2 5 6)

theorem row_48_95 : RowResult ⟨48, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_48_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_48_96 : RowResult ⟨48, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_48_95
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_48_97 : RowResult ⟨48, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_48_96
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_48_98 : RowResult ⟨48, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_48_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 1 4 6)

theorem row_48_99 : RowResult ⟨48, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_48_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 2 4 7)

theorem row_48_100 : RowResult ⟨48, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_48_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_48_101 : RowResult ⟨48, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_48_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_48_102 : RowResult ⟨48, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_48_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_48_103 : RowResult ⟨48, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_48_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_48_104 : RowResult ⟨48, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_48_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_48_105 : RowResult ⟨48, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_48_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_48_106 : RowResult ⟨48, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_48_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_48_107 : RowResult ⟨48, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_48_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_48_108 : RowResult ⟨48, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_48_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 1 4 7)

theorem row_48_109 : RowResult ⟨48, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_48_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_48_110 : RowResult ⟨48, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_48_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
