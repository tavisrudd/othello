import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_31_74 : RowResult ⟨31, by decide⟩ ⟨74, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨83, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_31_75 : RowResult ⟨31, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_31_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_31_76 : RowResult ⟨31, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_31_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_31_77 : RowResult ⟨31, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_31_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_31_78 : RowResult ⟨31, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_31_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_31_79 : RowResult ⟨31, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_31_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_31_80 : RowResult ⟨31, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_31_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_31_81 : RowResult ⟨31, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_31_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 1 4 6)

theorem row_31_82 : RowResult ⟨31, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_31_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 2 4 7)

theorem row_31_83 : RowResult ⟨31, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_31_82
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_31_84 : RowResult ⟨31, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_31_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 4 5 6)

theorem row_31_85 : RowResult ⟨31, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_31_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 2 5 7)

theorem row_31_86 : RowResult ⟨31, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_31_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_31_87 : RowResult ⟨31, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_31_86
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_31_88 : RowResult ⟨31, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_31_87
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_31_89 : RowResult ⟨31, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_31_88
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_31_90 : RowResult ⟨31, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_31_89
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
