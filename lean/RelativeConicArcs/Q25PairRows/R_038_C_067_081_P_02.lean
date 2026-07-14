import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_38_67 : RowResult ⟨38, by decide⟩ ⟨67, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_38_68 : RowResult ⟨38, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_38_67
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) 1 4 7)

theorem row_38_69 : RowResult ⟨38, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_38_68
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_38_70 : RowResult ⟨38, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_38_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 1 2 7)

theorem row_38_71 : RowResult ⟨38, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_38_70
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_38_72 : RowResult ⟨38, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_38_71
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_38_73 : RowResult ⟨38, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_38_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 2 5 7)

theorem row_38_74 : RowResult ⟨38, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_38_73
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_38_75 : RowResult ⟨38, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_38_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_38_76 : RowResult ⟨38, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_38_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_38_77 : RowResult ⟨38, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_38_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_38_78 : RowResult ⟨38, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_38_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_38_79 : RowResult ⟨38, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_38_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_38_80 : RowResult ⟨38, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_38_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_38_81 : RowResult ⟨38, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_38_80
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
