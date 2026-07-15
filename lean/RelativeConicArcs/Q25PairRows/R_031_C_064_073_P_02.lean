import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_31_64 : RowResult ⟨31, by decide⟩ ⟨64, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨83, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_31_65 : RowResult ⟨31, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_31_64
  exact Or.inr ⟨orbitCodeOfNumber ⟨83, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_31_66 : RowResult ⟨31, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_31_65
  exact Or.inr ⟨orbitCodeOfNumber ⟨83, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_31_67 : RowResult ⟨31, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_31_66
  exact Or.inr ⟨orbitCodeOfNumber ⟨83, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_31_68 : RowResult ⟨31, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_31_67
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) 2 5 7)

theorem row_31_69 : RowResult ⟨31, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_31_68
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 4 5 6)

theorem row_31_70 : RowResult ⟨31, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_31_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 1 2 7)

theorem row_31_71 : RowResult ⟨31, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_31_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 1 4 7)

theorem row_31_72 : RowResult ⟨31, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_31_71
  exact Or.inr ⟨orbitCodeOfNumber ⟨87, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_31_73 : RowResult ⟨31, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_31_72
  exact Or.inr ⟨orbitCodeOfNumber ⟨87, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
