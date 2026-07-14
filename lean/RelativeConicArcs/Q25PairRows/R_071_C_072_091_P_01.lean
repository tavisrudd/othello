import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_71_72 : RowResult ⟨71, by decide⟩ ⟨72, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 0 4 6)

theorem row_71_73 : RowResult ⟨71, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_71_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 0 4 6)

theorem row_71_74 : RowResult ⟨71, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_71_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 0 4 6)

theorem row_71_75 : RowResult ⟨71, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_71_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_71_76 : RowResult ⟨71, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_71_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_71_77 : RowResult ⟨71, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_71_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_71_78 : RowResult ⟨71, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_71_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_71_79 : RowResult ⟨71, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_71_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_71_80 : RowResult ⟨71, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_71_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_71_81 : RowResult ⟨71, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_71_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 1 4 7)

theorem row_71_82 : RowResult ⟨71, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_71_81
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_71_83 : RowResult ⟨71, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_71_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 2 5 7)

theorem row_71_84 : RowResult ⟨71, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_71_83
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_71_85 : RowResult ⟨71, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_71_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 2 5 6)

theorem row_71_86 : RowResult ⟨71, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_71_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_71_87 : RowResult ⟨71, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_71_86
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_71_88 : RowResult ⟨71, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_71_87
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_71_89 : RowResult ⟨71, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_71_88
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_71_90 : RowResult ⟨71, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_71_89
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_71_91 : RowResult ⟨71, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_71_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
