import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_42_66 : RowResult ⟨42, by decide⟩ ⟨66, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_42_67 : RowResult ⟨42, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_42_66
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) 1 4 6)

theorem row_42_68 : RowResult ⟨42, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_42_67
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_42_69 : RowResult ⟨42, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_42_68
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_42_70 : RowResult ⟨42, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_42_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 1 2 7)

theorem row_42_71 : RowResult ⟨42, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_42_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 4 5 6)

theorem row_42_72 : RowResult ⟨42, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_42_71
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_42_73 : RowResult ⟨42, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_42_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 2 5 6)

theorem row_42_74 : RowResult ⟨42, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_42_73
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_42_75 : RowResult ⟨42, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_42_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_42_76 : RowResult ⟨42, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_42_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_42_77 : RowResult ⟨42, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_42_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_42_78 : RowResult ⟨42, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_42_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_42_79 : RowResult ⟨42, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_42_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_42_80 : RowResult ⟨42, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_42_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_42_81 : RowResult ⟨42, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_42_80
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
