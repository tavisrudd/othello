import RelativeConicArcs.Q25MinimumMaskMicro

/-!
# C151 reflected mask certificate for row `(5,58,169)`

This module completes the micro-prototype's first soundness leaf.  The set-bit list was regenerated
with

```
python3 notes/2026-07-15-c151-mask-generator.py --format summary
```

and is, in ascending stable `orbitNumber` order,
`32,34,36,38,43,46,81,84,85,87,90,97,112,115,124,134,138,143,147,186,187,190,
191,192,193,211,218,224,234,235,240,246`.

The soundness dispatcher uses `fin_cases` in the same ascending order over all `310` orbit
numbers.  Each set-bit goal is closed by its named determinant leaf; every other branch reduces
the contradictory literal-mask hypothesis with `norm_num`.  Thus the generated branch coverage
is visible and independently auditable without trusting the proposal generator.
-/

namespace RelativeConicArcs
namespace Q25MinimumMaskRow0058169

open Q25Coordinates Q25PairCertificate Q25OrbitDecomposition Q25MinimumChecker
  Q25MinimumMask Q25MinimumMaskMicro

set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000

theorem reflected_034 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨34, by decide⟩) := by decide

theorem reflected_036 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨36, by decide⟩) := by decide

theorem reflected_038 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨38, by decide⟩) := by decide

theorem reflected_043 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨43, by decide⟩) := by decide

theorem reflected_046 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨46, by decide⟩) := by decide

theorem reflected_081 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨81, by decide⟩) := by decide

theorem reflected_084 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨84, by decide⟩) := by decide

theorem reflected_085 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨85, by decide⟩) := by decide

theorem reflected_087 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨87, by decide⟩) := by decide

theorem reflected_090 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨90, by decide⟩) := by decide

theorem reflected_097 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨97, by decide⟩) := by decide

theorem reflected_112 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨112, by decide⟩) := by decide

theorem reflected_115 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨115, by decide⟩) := by decide

theorem reflected_124 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨124, by decide⟩) := by decide

theorem reflected_134 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨134, by decide⟩) := by decide

theorem reflected_138 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨138, by decide⟩) := by decide

theorem reflected_143 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨143, by decide⟩) := by decide

theorem reflected_147 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨147, by decide⟩) := by decide

theorem reflected_186 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨186, by decide⟩) := by decide

theorem reflected_187 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨187, by decide⟩) := by decide

theorem reflected_190 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨190, by decide⟩) := by decide

theorem reflected_191 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨191, by decide⟩) := by decide

theorem reflected_192 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨192, by decide⟩) := by decide

theorem reflected_193 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨193, by decide⟩) := by decide

theorem reflected_211 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨211, by decide⟩) := by decide

theorem reflected_218 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨218, by decide⟩) := by decide

theorem reflected_224 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨224, by decide⟩) := by decide

theorem reflected_234 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨234, by decide⟩) := by decide

theorem reflected_235 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨235, by decide⟩) := by decide

theorem reflected_240 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨240, by decide⟩) := by decide

theorem reflected_246 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨246, by decide⟩) := by decide

/-- Exhaustive generated soundness dispatch for the literal equality mask. -/
theorem equalityMask_sound :
    ∀ n : Fin 310, maskBit equalityMask n = true →
      ReflectedLegal equalityRepresentative (orbitCodeOfNumber n) := by
  intro n
  fin_cases n
  all_goals first
    | exact fun _ => reflected_032
    | exact fun _ => reflected_034
    | exact fun _ => reflected_036
    | exact fun _ => reflected_038
    | exact fun _ => reflected_043
    | exact fun _ => reflected_046
    | exact fun _ => reflected_081
    | exact fun _ => reflected_084
    | exact fun _ => reflected_085
    | exact fun _ => reflected_087
    | exact fun _ => reflected_090
    | exact fun _ => reflected_097
    | exact fun _ => reflected_112
    | exact fun _ => reflected_115
    | exact fun _ => reflected_124
    | exact fun _ => reflected_134
    | exact fun _ => reflected_138
    | exact fun _ => reflected_143
    | exact fun _ => reflected_147
    | exact fun _ => reflected_186
    | exact fun _ => reflected_187
    | exact fun _ => reflected_190
    | exact fun _ => reflected_191
    | exact fun _ => reflected_192
    | exact fun _ => reflected_193
    | exact fun _ => reflected_211
    | exact fun _ => reflected_218
    | exact fun _ => reflected_224
    | exact fun _ => reflected_234
    | exact fun _ => reflected_235
    | exact fun _ => reflected_240
    | exact fun _ => reflected_246
    | decide

theorem equalityMaskCertificate :
    ReflectedMaskCertificate equalityRepresentative equalityMask where
  card_le := card_equalityMask.ge
  sound := equalityMask_sound

theorem equalityRepresentative_conjInvariant :
    IsConjInvariant equalityRepresentative := by
  exact normalizedConfig_isConjInvariant _ _ _

theorem card_legalOrbitSet_equalityRepresentative_ge_32 :
    32 ≤ (legalOrbitSet equalityRepresentative).card :=
  card_legalOrbitSet_ge_32 equalityRepresentative_conjInvariant equalityMaskCertificate

end Q25MinimumMaskRow0058169
end RelativeConicArcs
