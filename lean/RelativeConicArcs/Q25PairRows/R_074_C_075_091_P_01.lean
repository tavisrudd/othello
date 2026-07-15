import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_74_75 : RowResult ⟨74, by decide⟩ ⟨75, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_74_76 : RowResult ⟨74, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_74_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_74_77 : RowResult ⟨74, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_74_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_74_78 : RowResult ⟨74, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_74_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_74_79 : RowResult ⟨74, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_74_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_74_80 : RowResult ⟨74, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_74_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_74_81 : RowResult ⟨74, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_74_80
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_74_82 : RowResult ⟨74, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_74_81
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_74_83 : RowResult ⟨74, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_74_82
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_74_84 : RowResult ⟨74, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_74_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 1 4 7)

theorem row_74_85 : RowResult ⟨74, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_74_84
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_74_86 : RowResult ⟨74, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_74_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_74_87 : RowResult ⟨74, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_74_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 2 5 7)

theorem row_74_88 : RowResult ⟨74, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_74_87
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨235, by decide⟩, by decide⟩

theorem row_74_89 : RowResult ⟨74, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_74_88
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_74_90 : RowResult ⟨74, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_74_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 2 4 6)

theorem row_74_91 : RowResult ⟨74, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_74_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
