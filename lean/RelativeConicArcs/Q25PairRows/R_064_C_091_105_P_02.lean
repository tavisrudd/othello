import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_64_91 : RowResult ⟨64, by decide⟩ ⟨91, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_64_92 : RowResult ⟨64, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_64_91
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_64_93 : RowResult ⟨64, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_64_92
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_64_94 : RowResult ⟨64, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_64_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 1 4 7)

theorem row_64_95 : RowResult ⟨64, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_64_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_64_96 : RowResult ⟨64, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_64_95
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_64_97 : RowResult ⟨64, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_64_96
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_64_98 : RowResult ⟨64, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_64_97
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_64_99 : RowResult ⟨64, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_64_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 4 5 6)

theorem row_64_100 : RowResult ⟨64, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_64_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_64_101 : RowResult ⟨64, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_64_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_64_102 : RowResult ⟨64, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_64_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_64_103 : RowResult ⟨64, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_64_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_64_104 : RowResult ⟨64, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_64_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_64_105 : RowResult ⟨64, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_64_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
