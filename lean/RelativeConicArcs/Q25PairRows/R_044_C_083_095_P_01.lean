import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_44_83 : RowResult ⟨44, by decide⟩ ⟨83, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_44_84 : RowResult ⟨44, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_44_83
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_44_85 : RowResult ⟨44, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_44_84
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_44_86 : RowResult ⟨44, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_44_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_44_87 : RowResult ⟨44, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_44_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 2 5 7)

theorem row_44_88 : RowResult ⟨44, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_44_87
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_44_89 : RowResult ⟨44, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_44_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 1 4 7)

theorem row_44_90 : RowResult ⟨44, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_44_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 2 4 7)

theorem row_44_91 : RowResult ⟨44, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_44_90
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_44_92 : RowResult ⟨44, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_44_91
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_44_93 : RowResult ⟨44, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_44_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 4 5 6)

theorem row_44_94 : RowResult ⟨44, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_44_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 1 4 6)

theorem row_44_95 : RowResult ⟨44, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_44_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
