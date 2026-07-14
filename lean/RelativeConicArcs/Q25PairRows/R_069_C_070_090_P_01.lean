import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_69_70 : RowResult ⟨69, by decide⟩ ⟨70, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 0 4 6)

theorem row_69_71 : RowResult ⟨69, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_69_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 0 4 6)

theorem row_69_72 : RowResult ⟨69, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_69_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 0 4 6)

theorem row_69_73 : RowResult ⟨69, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_69_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 0 4 6)

theorem row_69_74 : RowResult ⟨69, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_69_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 0 4 6)

theorem row_69_75 : RowResult ⟨69, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_69_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_69_76 : RowResult ⟨69, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_69_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_69_77 : RowResult ⟨69, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_69_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_69_78 : RowResult ⟨69, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_69_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_69_79 : RowResult ⟨69, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_69_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_69_80 : RowResult ⟨69, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_69_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_69_81 : RowResult ⟨69, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_69_80
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_69_82 : RowResult ⟨69, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_69_81
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_69_83 : RowResult ⟨69, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_69_82
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_69_84 : RowResult ⟨69, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_69_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 4 5 6)

theorem row_69_85 : RowResult ⟨69, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_69_84
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_69_86 : RowResult ⟨69, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_69_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_69_87 : RowResult ⟨69, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_69_86
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_69_88 : RowResult ⟨69, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_69_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 2 4 6)

theorem row_69_89 : RowResult ⟨69, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_69_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 1 4 7)

theorem row_69_90 : RowResult ⟨69, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_69_89
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
