import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_33_74 : RowResult ⟨33, by decide⟩ ⟨74, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_33_75 : RowResult ⟨33, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_33_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_33_76 : RowResult ⟨33, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_33_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_33_77 : RowResult ⟨33, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_33_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_33_78 : RowResult ⟨33, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_33_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_33_79 : RowResult ⟨33, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_33_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_33_80 : RowResult ⟨33, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_33_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_33_81 : RowResult ⟨33, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_33_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 4 5 6)

theorem row_33_82 : RowResult ⟨33, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_33_81
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_33_83 : RowResult ⟨33, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_33_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 1 4 6)

theorem row_33_84 : RowResult ⟨33, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_33_83
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_33_85 : RowResult ⟨33, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_33_84
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_33_86 : RowResult ⟨33, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_33_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_33_87 : RowResult ⟨33, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_33_86
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_33_88 : RowResult ⟨33, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_33_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 2 5 6)

theorem row_33_89 : RowResult ⟨33, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_33_88
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
