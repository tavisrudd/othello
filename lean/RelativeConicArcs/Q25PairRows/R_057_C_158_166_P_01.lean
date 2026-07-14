import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_57_158 : RowResult ⟨57, by decide⟩ ⟨158, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_57_159 : RowResult ⟨57, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_57_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 4 5 6)

theorem row_57_160 : RowResult ⟨57, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_57_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_57_161 : RowResult ⟨57, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_57_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_162 : RowResult ⟨57, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_57_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_57_163 : RowResult ⟨57, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_57_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_57_164 : RowResult ⟨57, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_57_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_57_165 : RowResult ⟨57, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_57_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_57_166 : RowResult ⟨57, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_57_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
