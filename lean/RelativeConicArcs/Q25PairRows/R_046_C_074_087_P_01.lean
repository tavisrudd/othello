import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_46_74 : RowResult ⟨46, by decide⟩ ⟨74, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_46_75 : RowResult ⟨46, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_46_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_46_76 : RowResult ⟨46, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_46_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_46_77 : RowResult ⟨46, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_46_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_46_78 : RowResult ⟨46, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_46_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_46_79 : RowResult ⟨46, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_46_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_46_80 : RowResult ⟨46, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_46_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_46_81 : RowResult ⟨46, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_46_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 1 4 7)

theorem row_46_82 : RowResult ⟨46, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_46_81
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_46_83 : RowResult ⟨46, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_46_82
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_46_84 : RowResult ⟨46, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_46_83
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_46_85 : RowResult ⟨46, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_46_84
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_46_86 : RowResult ⟨46, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_46_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_46_87 : RowResult ⟨46, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_46_86
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
