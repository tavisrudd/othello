import RelativeConicArcs.ClebschWittHadamard

/-!
# Steiner supports, Hadamard rows, and secant geometry

This leaf checks the `S(5,6,12)` minimum-support design, the twelve projective full-support words,
the integer Hadamard Gram identity, and exhaustion of all projective minimum words by the 66
sign-row secants.  In the pinned toolchain the shared native-evaluation certificate exposes a
declaration-local `_native.native_decide.ax_1_1` dependency.
-/

namespace RelativeConicArcs
namespace ClebschWittHadamard

private theorem checkedGeometry :
    (let c := codewords
     let h := hexads
     let f := fullSupportPoints
     let s := secantInteriorPoints
     h.card = 132 ∧
       (∀ block ∈ h, block.card = 6) ∧
       (∀ subset : Finset (Fin 12), subset.card = 5 →
         (h.filter fun block => subset ⊆ block).card = 1) ∧
       (f.card = 12 ∧
         f = (c.filter fun v => weight v = 12).image projectivePair) ∧
       (∀ i j : Fin 12,
         (∑ k, hadamardSign i k * hadamardSign j k) = if i = j then 12 else 0) ∧
       rowPairs.card = 66 ∧ s.card = 132 ∧ s = minimumProjectivePoints) := by
  native_decide

/-- The 132 minimum supports form a Steiner `5-(12,6,1)` design. -/
theorem hexads_steiner_five :
    hexads.card = 132 ∧
    (∀ h ∈ hexads, h.card = 6) ∧
    ∀ s : Finset (Fin 12), s.card = 5 →
      (hexads.filter fun h => s ⊆ h).card = 1 :=
  ⟨checkedGeometry.1, checkedGeometry.2.1, checkedGeometry.2.2.1⟩

/-- There are twelve projective full-support points, represented by the displayed sign rows. -/
theorem fullSupportPoints_complete :
    fullSupportPoints.card = 12 ∧
    fullSupportPoints =
      (codewords.filter fun v => weight v = 12).image projectivePair :=
  checkedGeometry.2.2.2.1

/-- The sign rows satisfy the exact order-twelve Hadamard Gram identity. -/
theorem hadamard_gram :
    ∀ i j : Fin 12,
      (∑ k, hadamardSign i k * hadamardSign j k) = if i = j then 12 else 0 :=
  checkedGeometry.2.2.2.2.1

/-- There are 66 secants, and their two interior points exhaust all projective minimum words. -/
theorem secant_exhaustion :
    rowPairs.card = 66 ∧
    secantInteriorPoints.card = 132 ∧
    secantInteriorPoints = minimumProjectivePoints :=
  ⟨checkedGeometry.2.2.2.2.2.1, checkedGeometry.2.2.2.2.2.2.1,
    checkedGeometry.2.2.2.2.2.2.2⟩

end ClebschWittHadamard
end RelativeConicArcs
