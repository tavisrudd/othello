import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_42_82 : RowResult ⟨42, by decide⟩ ⟨82, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_42_83 : RowResult ⟨42, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_42_82
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_42_84 : RowResult ⟨42, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_42_83
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_42_85 : RowResult ⟨42, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_42_84
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_42_86 : RowResult ⟨42, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_42_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_42_87 : RowResult ⟨42, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_42_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 1 4 7)

theorem row_42_88 : RowResult ⟨42, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_42_87
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_42_89 : RowResult ⟨42, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_42_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 2 5 6)

theorem row_42_90 : RowResult ⟨42, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_42_89
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_42_91 : RowResult ⟨42, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_42_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 4 5 6)

theorem row_42_92 : RowResult ⟨42, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_42_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
