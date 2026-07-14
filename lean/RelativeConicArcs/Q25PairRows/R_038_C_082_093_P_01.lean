import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_38_82 : RowResult ⟨38, by decide⟩ ⟨82, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_38_83 : RowResult ⟨38, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_38_82
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_38_84 : RowResult ⟨38, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_38_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 2 4 6)

theorem row_38_85 : RowResult ⟨38, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_38_84
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_38_86 : RowResult ⟨38, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_38_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_38_87 : RowResult ⟨38, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_38_86
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_38_88 : RowResult ⟨38, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_38_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 1 4 6)

theorem row_38_89 : RowResult ⟨38, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_38_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 4 5 6)

theorem row_38_90 : RowResult ⟨38, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_38_89
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_38_91 : RowResult ⟨38, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_38_90
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_38_92 : RowResult ⟨38, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_38_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 2 4 7)

theorem row_38_93 : RowResult ⟨38, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_38_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
