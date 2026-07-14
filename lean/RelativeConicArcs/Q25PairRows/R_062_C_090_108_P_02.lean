import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_62_90 : RowResult ⟨62, by decide⟩ ⟨90, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_91 : RowResult ⟨62, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_62_90
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_92 : RowResult ⟨62, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_62_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 1 4 7)

theorem row_62_93 : RowResult ⟨62, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_62_92
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_62_94 : RowResult ⟨62, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_62_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 2 5 6)

theorem row_62_95 : RowResult ⟨62, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_62_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_62_96 : RowResult ⟨62, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_62_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 2 4 7)

theorem row_62_97 : RowResult ⟨62, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_62_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 4 5 6)

theorem row_62_98 : RowResult ⟨62, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_62_97
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_99 : RowResult ⟨62, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_62_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 2 4 6)

theorem row_62_100 : RowResult ⟨62, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_62_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_62_101 : RowResult ⟨62, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_62_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_62_102 : RowResult ⟨62, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_62_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_62_103 : RowResult ⟨62, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_62_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_62_104 : RowResult ⟨62, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_62_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_62_105 : RowResult ⟨62, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_62_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_62_106 : RowResult ⟨62, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_62_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_62_107 : RowResult ⟨62, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_62_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_62_108 : RowResult ⟨62, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_62_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
