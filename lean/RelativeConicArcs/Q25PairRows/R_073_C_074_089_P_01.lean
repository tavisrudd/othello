import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false
set_option linter.unusedVariables false

theorem row_73_74 : RowResult ⟨73, by decide⟩ ⟨74, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 0 4 6)

theorem row_73_75 : RowResult ⟨73, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_73_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_73_76 : RowResult ⟨73, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_73_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_73_77 : RowResult ⟨73, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_73_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_73_78 : RowResult ⟨73, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_73_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_73_79 : RowResult ⟨73, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_73_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_73_80 : RowResult ⟨73, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_73_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_73_81 : RowResult ⟨73, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_73_80
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_73_82 : RowResult ⟨73, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_73_81
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_73_83 : RowResult ⟨73, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_73_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 1 4 7)

theorem row_73_84 : RowResult ⟨73, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_73_83
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_73_85 : RowResult ⟨73, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_73_84
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_73_86 : RowResult ⟨73, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_73_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_73_87 : RowResult ⟨73, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_73_86
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_73_88 : RowResult ⟨73, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_73_87
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_73_89 : RowResult ⟨73, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_73_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
