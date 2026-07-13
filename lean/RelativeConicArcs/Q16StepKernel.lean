import RelativeConicArcs.Q16CertificateLevels

/-!
# Lightweight composition kernel for the `GF(16)` augmentation books

The generated row modules already prove every retained matrix transition semantically.  This file
packages those theorems without rebuilding a monolithic list of their full matrix/witness payloads.
-/

namespace RelativeConicArcs.Q16Classification

open Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

/-- The semantic conclusion supplied by one checked augmentation row. -/
def StepFor (next : List (Finset Idx)) (parent : Finset Idx) (x : Idx) : Prop :=
  ∃ child ∈ next, RawProjectiveEquiv (insert x parent) child

theorem ExtensionRow.ValidFor.toStep {next : List (Finset Idx)} {parent : Finset Idx}
    {r : ExtensionRow} (h : r.ValidFor next parent) : StepFor next parent r.move := by
  obtain ⟨child, hchild, hmaps⟩ := h
  refine ⟨child, ?_, matrixMaps_sound hmaps⟩
  exact List.mem_iff_getElem?.mpr ⟨r.child, hchild⟩

/-- Reflected extension test over an explicit duplicate-free enumeration of the parent. -/
def FastRawExtensionBy {n : ℕ} (members : Fin n → Idx) (x : Idx) : Prop :=
  ∀ i j, i < j → fastDet3 (vecCode (members i)) (vecCode (members j)) (vecCode x) ≠ 0

instance {n : ℕ} (members : Fin n → Idx) (x : Idx) :
    Decidable (FastRawExtensionBy members x) := by
  unfold FastRawExtensionBy
  infer_instance

theorem fastRawExtensionBy_of_rawExtension {n : ℕ} {members : Fin n → Idx}
    {parent : Finset Idx} (hinj : Function.Injective members)
    (hmem : ∀ i, members i ∈ parent) {x : Idx} (hraw : RawExtension parent x) :
    FastRawExtensionBy members x := by
  intro i j hij
  have hdet := hraw (members i) (hmem i) (members j) (hmem j)
    (fun h => (ne_of_lt hij) (hinj h))
  intro hzero
  apply hdet
  rw [← det3_eq_det]
  have hd := congrArg decode16 hzero
  rw [decode16_fastDet3, decode16_vecCode, decode16_vecCode, decode16_vecCode] at hd
  have hz : decode16 (0 : Fin 16) = (0 : FiniteFields.GF16) :=
    (decode16_eq_zero_iff 0).2 rfl
  rwa [hz] at hd

/-- One lightweight reference to an already checked transition row. -/
structure StepEntry (next : List (Finset Idx)) (parent : Finset Idx) where
  move : Idx
  step : StepFor next parent move

/-- A parent representative, lightweight semantic entries, and a checked proof that their move
numbers cover every legal extension.  Full matrix payloads stay in the row modules. -/
structure StepBook (next : List (Finset Idx)) where
  parent : Finset Idx
  entries : List (StepEntry next parent)
  coverage : ∀ x : Idx, x ∉ parent → RawExtension parent x →
    x ∈ entries.map StepEntry.move

theorem StepBook.step {next : List (Finset Idx)} (book : StepBook next) {x : Idx}
    (hx : x ∉ book.parent) (hraw : RawExtension book.parent x) :
    StepFor next book.parent x := by
  have hm := book.coverage x hx hraw
  obtain ⟨entry, _hentry, hmove⟩ := List.mem_map.mp hm
  rw [← hmove]
  exact entry.step

/-- The lightweight books cover the current level in exactly its listed order. -/
def StepBooksValid (current next : List (Finset Idx)) (books : List (StepBook next)) : Prop :=
  books.map StepBook.parent = current

theorem StepBooksValid.step {current next : List (Finset Idx)} {books : List (StepBook next)}
    (hbooks : StepBooksValid current next books) {A : Finset Idx} (hA : A ∈ current)
    {x : Idx} (hx : x ∉ A) (hcap : RawCap (insert x A)) : StepFor next A x := by
  have hAm : A ∈ books.map StepBook.parent := by
    rw [hbooks]
    exact hA
  obtain ⟨book, hb, hparent⟩ := List.mem_map.mp hAm
  subst A
  exact book.step hx (rawExtension_of_rawCap_insert hx hcap)

theorem ClassifiedAt.extendStep {current next : List (Finset Idx)}
    {books : List (StepBook next)} (hbooks : StepBooksValid current next books)
    {S : Finset Idx} (hS : ClassifiedAt current S) {x : Idx} (hx : x ∉ S)
    (hcap : RawCap (insert x S)) : ClassifiedAt next (insert x S) := by
  obtain ⟨A, hA, hSA⟩ := hS
  obtain ⟨y, hinsert⟩ := rawProjectiveEquiv_insert hSA x
  have hy : y ∉ A := by
    intro hyA
    have hc1 := card_eq_of_rawProjectiveEquiv hSA
    have hc2 := card_eq_of_rawProjectiveEquiv hinsert
    rw [Finset.card_insert_of_notMem hx, Finset.card_insert_of_mem hyA, hc1] at hc2
    omega
  have hcap' : RawCap (insert y A) :=
    (rawCap_iff_of_rawProjectiveEquiv hinsert).mp hcap
  obtain ⟨child, hchild, hychild⟩ := hbooks.step hA hy hcap'
  exact ⟨child, hchild, rawProjectiveEquiv_trans hinsert hychild⟩

end RelativeConicArcs.Q16Classification
