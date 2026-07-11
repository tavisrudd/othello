import FiniteGeom.EvalCode
import Mathlib.FieldTheory.Finite.GaloisField

/-!
# Concrete Reed–Solomon MDS instances over genuine finite fields (`FiniteGeom` non-vacuity)

The eval-code layer (`FiniteGeom.EvalCode`) proves `rsCode_isMDS` *in general* over any
`[Field 𝔽] [DecidableEq 𝔽]`. Plan §5 decision 1 (abstract-first) is only discharged once the
general statement is exercised by at least one **concrete** instance — otherwise the MDS layer
is vacuous in the intended sense. This file supplies two, mirroring the `𝔽₅` non-vacuity witness
in `FiniteGeom.Code`:

* **`ZMod 7`** — a full-length Reed–Solomon `[7, 3, 5]₇` code on all seven field elements as
  evaluation points (`rsCode_zmod7_isMDS`, `rsCode_zmod7_minDist`). Prime field, fully
  `decide`-able injectivity.
* **`GaloisField 3 2 = 𝔽₉`** — the *target* non-prime field of the `q = 9` seed lane. A
  `[3, 2, 2]₉` Reed–Solomon code on the three prime-subfield elements (`rsCode_gf9_isMDS`,
  `rsCode_gf9_minDist`). Point-injectivity comes from `algebraMap (ZMod 3) 𝔽₉` being a ring hom
  out of a field (hence injective), composed with the distinctness of `0,1,2 : ZMod 3` — no
  `decide` over `𝔽₉` (its equality is not by `rfl`). This de-risks instance resolution over a
  genuine `GaloisField` before the `q = 9` NRC discharge (`RepairCodes.Q9Seed`) depends on it.

Pure finite algebra, no imported input; every result `#print axioms`-clean apart from the
classical `DecidableEq (GaloisField 3 2)` used only to *state* the `𝔽₉` code (a data instance,
not a proof axiom).
-/

namespace FiniteGeom

open Finset

section ZMod7

local instance : Fact (Nat.Prime 7) := ⟨by decide⟩

/-- The seven evaluation points `0, 1, …, 6 : 𝔽₇` are distinct. -/
theorem rs7_points_injective :
    Function.Injective (fun i : Fin 7 => ((i : ℕ) : ZMod 7)) := by decide

/-- A genuine Reed–Solomon `[7, 3, 5]₇` code is MDS: `d + k = 5 + 3 = 8 = n + 1`. Exercises the
general `rsCode_isMDS` on a concrete prime field. -/
theorem rsCode_zmod7_isMDS :
    IsMDS (rsCode (n := 7) (fun i : Fin 7 => ((i : ℕ) : ZMod 7)) 3) :=
  rsCode_isMDS rs7_points_injective (by decide) (by decide)

/-- Its minimum distance is exactly `5` (dimension `3`, length `7`). -/
theorem rsCode_zmod7_minDist :
    minDist (rsCode (n := 7) (fun i : Fin 7 => ((i : ℕ) : ZMod 7)) 3) = 5 := by
  have h := rsCode_zmod7_isMDS
  have hk := finrank_rsCode rs7_points_injective (by decide : (3 : ℕ) ≤ 7)
  unfold IsMDS at h
  rw [hk] at h
  omega

end ZMod7

section GF9

open scoped Classical

local instance : Fact (Nat.Prime 3) := ⟨by decide⟩

/-- Evaluation points for the `𝔽₉` Reed–Solomon code: the image of the prime subfield `𝔽₃`. -/
noncomputable def gf9Points : Fin 3 → GaloisField 3 2 :=
  fun i => algebraMap (ZMod 3) (GaloisField 3 2) ((i : ℕ) : ZMod 3)

/-- The three prime-subfield evaluation points `algebraMap (ZMod 3) 𝔽₉ (0,1,2)` are distinct:
`algebraMap` out of the field `ZMod 3` is injective, and `0, 1, 2 : ZMod 3` are distinct. -/
theorem gf9_points_injective : Function.Injective gf9Points := by
  have h1 : Function.Injective (fun i : Fin 3 => ((i : ℕ) : ZMod 3)) := by decide
  exact (RingHom.injective (algebraMap (ZMod 3) (GaloisField 3 2))).comp h1

/-- A Reed–Solomon `[3, 2, 2]₉` code over the genuine (non-prime) field `𝔽₉ = GaloisField 3 2`
is MDS: `d + k = 2 + 2 = 4 = n + 1`. The point of the instance is the *field*: it confirms the
eval-code MDS machinery resolves all instances (`Field`, `DecidableEq`, injectivity via
`algebraMap`) over a `GaloisField`, the setting the `q = 9` seed lane needs. -/
theorem rsCode_gf9_isMDS : IsMDS (rsCode (n := 3) gf9Points 2) :=
  rsCode_isMDS gf9_points_injective (by decide) (by decide)

/-- Its minimum distance is exactly `2` (dimension `2`, length `3`). -/
theorem rsCode_gf9_minDist : minDist (rsCode (n := 3) gf9Points 2) = 2 := by
  have h := rsCode_gf9_isMDS
  have hk := finrank_rsCode gf9_points_injective (by decide : (2 : ℕ) ≤ 3)
  unfold IsMDS at h
  rw [hk] at h
  omega

end GF9

end FiniteGeom
