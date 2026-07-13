import RelativeConicArcs.Certificate
import RelativeConicArcs.FiniteFields
import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv

/-!
# Projective classification certificates for eight-arcs in `PG(2,16)`

This module is the rules-only semantic kernel for C101.  Generated data enumerate projective
classes by extending the standard four-frame.  Every transition carries an explicit invertible
`3 x 3` matrix, so soundness depends only on finite-field arithmetic and projective linear maps,
not on a trusted canonical-labeling program.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace Q16Classification

open Certificate Conic FiniteFields ProjectiveBridge
open Projectivization

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

abbrev Idx := Fin 273
abbrev Point16 := Conic.Point GF16

noncomputable local instance : Fintype Point16 := Fintype.ofFinite _
noncomputable local instance : DecidableEq Point16 := Classical.decEq _

/-- Canonical representative number `0` is `[0:0:1]`, numbers `1..16` are `[0:1:z]`,
and the remaining 256 numbers are `[1:y:z]` in lexicographic order. -/
def vec (i : Idx) : Vec GF16 :=
  if _ : i.1 = 0 then ![0, 0, 1]
  else if _ : i.1 < 17 then ![0, 1, GF16.ofNat (i.1 - 1)]
  else ![1, GF16.ofNat ((i.1 - 17) / 16), GF16.ofNat ((i.1 - 17) % 16)]

theorem vec_ne_zero (i : Idx) : vec i ≠ 0 := by
  intro h
  by_cases h0 : i.1 = 0
  · simp only [vec, dif_pos h0] at h
    have hz := congrFun h 2
    simp at hz
  · by_cases h1 : i.1 < 17
    · simp only [vec, dif_neg h0, dif_pos h1] at h
      have hz := congrFun h 1
      simp at hz
    · simp only [vec, dif_neg h0, dif_neg h1] at h
      have hz := congrFun h 0
      simp at hz

def rawPoint (i : Idx) : RawPoint GF16 := ⟨vec i, vec_ne_zero i⟩
def point (i : Idx) : Point16 := toPoint (rawPoint i)

private theorem ofNat_val_of_lt {n : ℕ} (hn : n < 16) : (GF16.ofNat n).val.1 = n := by
  simp [GF16.ofNat, Nat.mod_eq_of_lt hn]

theorem rayEq_vec_iff_eq (i j : Idx) : RayEq (vec i) (vec j) ↔ i = j := by
  constructor
  · rintro ⟨a, ha⟩
    by_cases hi0 : i.1 = 0
    · by_cases hj0 : j.1 = 0
      · apply Fin.ext
        exact hi0.trans hj0.symm
      · by_cases hj1 : j.1 < 17
        · simp only [vec, dif_pos hi0, dif_neg hj0, dif_pos hj1] at ha
          have h1 := congrFun ha 1
          have h2 := congrFun ha 2
          simp only [Pi.smul_apply, smul_eq_mul, Matrix.cons_val_one, Matrix.cons_val_two,
            Matrix.head_cons, Matrix.tail_cons] at h1 h2
          have ha0 : a = 0 := by simpa using h1
          rw [ha0, zero_mul] at h2
          exact False.elim (zero_ne_one h2)
        · simp only [vec, dif_pos hi0, dif_neg hj0, dif_neg hj1] at ha
          have h0 := congrFun ha 0
          have h2 := congrFun ha 2
          simp only [Pi.smul_apply, smul_eq_mul, Matrix.cons_val_zero,
            Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons] at h0 h2
          have ha0 : a = 0 := by simpa using h0
          rw [ha0, zero_mul] at h2
          exact False.elim (zero_ne_one h2)
    · by_cases hi1 : i.1 < 17
      · by_cases hj0 : j.1 = 0
        · simp only [vec, dif_neg hi0, dif_pos hi1, dif_pos hj0] at ha
          have h1 := congrFun ha 1
          simp at h1
        · by_cases hj1 : j.1 < 17
          · simp only [vec, dif_neg hi0, dif_pos hi1, dif_neg hj0, dif_pos hj1] at ha
            have h1 := congrFun ha 1
            have h2 := congrFun ha 2
            simp only [Pi.smul_apply, smul_eq_mul, Matrix.cons_val_one, Matrix.cons_val_two,
              Matrix.head_cons, Matrix.tail_cons] at h1 h2
            have ha1 : a = 1 := by simpa using h1
            rw [ha1, one_mul] at h2
            have hv := congrArg (fun x : GF16 => x.val.1) h2
            rw [ofNat_val_of_lt (by omega), ofNat_val_of_lt (by omega)] at hv
            apply Fin.ext
            omega
          · simp only [vec, dif_neg hi0, dif_pos hi1, dif_neg hj0, dif_neg hj1] at ha
            have h0 := congrFun ha 0
            have h1 := congrFun ha 1
            simp only [Pi.smul_apply, smul_eq_mul, Matrix.cons_val_zero,
              Matrix.cons_val_one] at h0 h1
            have ha0 : a = 0 := by simpa using h0
            rw [ha0, zero_mul] at h1
            exact False.elim (zero_ne_one h1)
      · by_cases hj0 : j.1 = 0
        · simp only [vec, dif_neg hi0, dif_neg hi1, dif_pos hj0] at ha
          have h0 := congrFun ha 0
          simp at h0
        · by_cases hj1 : j.1 < 17
          · simp only [vec, dif_neg hi0, dif_neg hi1, dif_neg hj0, dif_pos hj1] at ha
            have h0 := congrFun ha 0
            simp at h0
          · simp only [vec, dif_neg hi0, dif_neg hi1, dif_neg hj0, dif_neg hj1] at ha
            have h0 := congrFun ha 0
            have h1 := congrFun ha 1
            have h2 := congrFun ha 2
            simp only [Pi.smul_apply, smul_eq_mul, Matrix.cons_val_zero, Matrix.cons_val_one,
              Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons] at h0 h1 h2
            have ha1 : a = 1 := by simpa using h0
            rw [ha1, one_mul] at h1 h2
            have hv1 := congrArg (fun x : GF16 => x.val.1) h1
            have hv2 := congrArg (fun x : GF16 => x.val.1) h2
            rw [ofNat_val_of_lt (by omega), ofNat_val_of_lt (by omega)] at hv1
            rw [ofNat_val_of_lt (by omega), ofNat_val_of_lt (by omega)] at hv2
            apply Fin.ext
            have hi := Nat.div_add_mod (i.1 - 17) 16
            have hj := Nat.div_add_mod (j.1 - 17) 16
            omega
  · rintro rfl
    exact ⟨1, by simp⟩

theorem vec_projectively_distinct :
    ∀ i j : Idx, i ≠ j → rayEq (vec i) (vec j) = false := by
  intro i j hij
  rw [rayEq_eq_false_iff]
  exact fun h => hij ((rayEq_vec_iff_eq i j).mp h)

theorem point_injective : Function.Injective point := by
  intro i j hij
  by_contra hne
  have hray : RayEq (vec i) (vec j) :=
    (rayEq_iff_mk_eq (rawPoint i) (rawPoint j)).mpr hij
  have ht := (rayEq_eq_true_iff _ _).mpr hray
  rw [vec_projectively_distinct i j hne] at ht
  contradiction

theorem card_point16 : Fintype.card Point16 = 273 := by
  rw [← Nat.card_eq_fintype_card,
    Projectivization.card_of_finrank GF16 (Fin 3 → GF16) (n := 3) (by simp)]
  norm_num [Finset.sum_range_succ]

/-- The canonical representatives give an actual equivalence with all 273 projective points. -/
noncomputable def pointEquiv : Idx ≃ Point16 :=
  Fintype.equivOfCardEq (by simp [card_point16])

-- We retain the coordinate ordering, rather than `Fintype.equivOfCardEq`'s arbitrary ordering.
noncomputable def canonicalPointEquiv : Idx ≃ Point16 :=
  Equiv.ofBijective point ((Fintype.bijective_iff_injective_and_card point).2
    ⟨point_injective, by simp [card_point16]⟩)

@[simp] theorem canonicalPointEquiv_apply (i : Idx) : canonicalPointEquiv i = point i := rfl

noncomputable def pointSetIdx (S : Finset Idx) : Finset Point16 :=
  S.map canonicalPointEquiv.toEmbedding

/-- Coordinate arc validity on indexed canonical representatives. -/
def RawCap (S : Finset Idx) : Prop :=
  ∀ a ∈ S, ∀ b ∈ S, ∀ c ∈ S,
    a ≠ b → a ≠ c → b ≠ c → Matrix.det ![vec a, vec b, vec c] ≠ 0

instance (S : Finset Idx) : Decidable (RawCap S) := by
  unfold RawCap
  infer_instance

theorem rawCap_iff_projectiveCap (S : Finset Idx) :
    RawCap S ↔ ProjectiveCap.Projective.Cap GF16 (Fin 3 → GF16) (pointSetIdx S) := by
  let xs := S.toList.map rawPoint
  have hpoint : pointSet xs = pointSetIdx S := by
    classical
    ext p
    rw [mem_pointSet]
    constructor
    · rintro ⟨v, hv, rfl⟩
      obtain ⟨i, hi, rfl⟩ := List.mem_map.mp hv
      exact Finset.mem_map.mpr ⟨i, by simpa using hi, rfl⟩
    · intro hp
      obtain ⟨i, hi, hip⟩ := Finset.mem_map.mp hp
      exact ⟨rawPoint i, List.mem_map.mpr ⟨i, by simpa using hi, rfl⟩, hip⟩
  have hraw : RawArc xs ↔ RawCap S := by
    classical
    unfold RawArc RawCap xs
    simp only [List.mem_map, Finset.mem_toList]
    constructor
    · intro h a ha b hb c hc hab hac hbc
      exact h (rawPoint a) ⟨a, ha, rfl⟩ (rawPoint b) ⟨b, hb, rfl⟩
        (rawPoint c) ⟨c, hc, rfl⟩
        (vec_projectively_distinct a b hab)
        (vec_projectively_distinct a c hac)
        (vec_projectively_distinct b c hbc)
    · intro h va hva vb hvb vc hvc hab hac hbc
      obtain ⟨a, ha, rfl⟩ := hva
      obtain ⟨b, hb, rfl⟩ := hvb
      obtain ⟨c, hc, rfl⟩ := hvc
      have hab' : a ≠ b := by
        intro heq; subst b
        have : rayEq (vec a) (vec a) = true := (rayEq_eq_true_iff _ _).mpr ⟨1, by simp⟩
        change rayEq (vec a) (vec a) = false at hab
        rw [hab] at this
        contradiction
      have hac' : a ≠ c := by
        intro heq; subst c
        have : rayEq (vec a) (vec a) = true := (rayEq_eq_true_iff _ _).mpr ⟨1, by simp⟩
        change rayEq (vec a) (vec a) = false at hac
        rw [hac] at this
        contradiction
      have hbc' : b ≠ c := by
        intro heq; subst c
        have : rayEq (vec b) (vec b) = true := (rayEq_eq_true_iff _ _).mpr ⟨1, by simp⟩
        change rayEq (vec b) (vec b) = false at hbc
        rw [hbc] at this
        contradiction
      exact h a ha b hb c hc hab' hac' hbc'
  rw [← hpoint, ← rawArc_iff_projectiveCap, hraw]

/-- Compact encoding of a `3 x 3` matrix by nine field-element indices. -/
abbrev MatrixCode := Fin 9 → Fin 16

def decodeMatrix (m : MatrixCode) : Matrix (Fin 3) (Fin 3) GF16 :=
  fun i j => GF16.ofNat (m ⟨i.1 * 3 + j.1, by omega⟩).1

/-- One explicit source/target/scalar equality for a projective matrix row. -/
structure MapWitness where
  source : Idx
  target : Idx
  scalar : Fin 16
deriving DecidableEq

/-- A matrix code and its pointwise witnesses are a checked projective equivalence between two
indexed sets. Explicit scalars avoid an expensive finite search inside every `RayEq`. -/
def MatrixMaps (m : MatrixCode) (ws : List MapWitness) (S T : Finset Idx) : Prop :=
  Matrix.det (decodeMatrix m) ≠ 0 ∧
    (ws.map MapWitness.source).toFinset = S ∧ S.card = T.card ∧
      ∀ w ∈ ws, w.target ∈ T ∧
        Matrix.mulVec (decodeMatrix m) (vec w.source) =
          GF16.ofNat w.scalar.1 • vec w.target

instance (m : MatrixCode) (ws : List MapWitness) (S T : Finset Idx) :
    Decidable (MatrixMaps m ws S T) := by
  unfold MatrixMaps
  infer_instance

/-- Projective equivalence of indexed point sets, retaining the inducing linear map. -/
def RawProjectiveEquiv (S T : Finset Idx) : Prop :=
  ∃ e : (Fin 3 → GF16) ≃ₗ[GF16] (Fin 3 → GF16),
    (pointSetIdx S).map (ProjectiveCap.Projective.mapEquiv e).toEmbedding = pointSetIdx T

theorem rawProjectiveEquiv_refl (S : Finset Idx) : RawProjectiveEquiv S S := by
  refine ⟨LinearEquiv.refl GF16 (Fin 3 → GF16), ?_⟩
  ext p
  simp [ProjectiveCap.Projective.mapEquiv]

theorem rawProjectiveEquiv_trans {S T U : Finset Idx}
    (hST : RawProjectiveEquiv S T) (hTU : RawProjectiveEquiv T U) :
    RawProjectiveEquiv S U := by
  obtain ⟨e, he⟩ := hST
  obtain ⟨f, hf⟩ := hTU
  refine ⟨e.trans f, ?_⟩
  have hcomp :
      (ProjectiveCap.Projective.mapEquiv e).toEmbedding.trans
          (ProjectiveCap.Projective.mapEquiv f).toEmbedding =
        (ProjectiveCap.Projective.mapEquiv (e.trans f)).toEmbedding := by
    ext p
    induction p using Projectivization.ind with
    | h v hv =>
        simp [ProjectiveCap.Projective.mapEquiv_mk, LinearEquiv.trans_apply]
  rw [← hcomp, ← Finset.map_map, he, hf]

theorem rawCap_iff_of_rawProjectiveEquiv {S T : Finset Idx}
    (hST : RawProjectiveEquiv S T) : RawCap S ↔ RawCap T := by
  obtain ⟨e, he⟩ := hST
  rw [rawCap_iff_projectiveCap, rawCap_iff_projectiveCap, ← he,
    ProjectiveCap.Projective.cap_map_mapEquiv]

theorem card_eq_of_rawProjectiveEquiv {S T : Finset Idx}
    (hST : RawProjectiveEquiv S T) : S.card = T.card := by
  obtain ⟨e, he⟩ := hST
  have hc := congrArg Finset.card he
  simpa [pointSetIdx] using hc

/-- Extend a retained projective equivalence by one indexed source point. -/
theorem rawProjectiveEquiv_insert {S T : Finset Idx} (hST : RawProjectiveEquiv S T)
    (x : Idx) :
    ∃ y : Idx, RawProjectiveEquiv (insert x S) (insert y T) := by
  obtain ⟨e, he⟩ := hST
  let y := canonicalPointEquiv.symm (ProjectiveCap.Projective.mapEquiv e (point x))
  refine ⟨y, e, ?_⟩
  have he' :
      S.map (canonicalPointEquiv.toEmbedding.trans
        (ProjectiveCap.Projective.mapEquiv e).toEmbedding) =
        T.map canonicalPointEquiv.toEmbedding := by
    simpa [pointSetIdx, Finset.map_map] using he
  simp only [pointSetIdx, Finset.map_insert, Finset.map_map]
  rw [he']
  congr 1
  simp [y]

/-- A checked matrix row denotes a genuine projective equivalence. -/
theorem matrixMaps_sound {m : MatrixCode} {ws : List MapWitness} {S T : Finset Idx}
    (h : MatrixMaps m ws S T) : RawProjectiveEquiv S T := by
  let M := decodeMatrix m
  have hunit : IsUnit M.det := isUnit_iff_ne_zero.mpr h.1
  let e : (Fin 3 → GF16) ≃ₗ[GF16] (Fin 3 → GF16) :=
    Matrix.toLinearEquiv (Pi.basisFun GF16 (Fin 3)) M hunit
  have e_apply (i : Idx) : e (vec i) = Matrix.mulVec M (vec i) := by
    change Matrix.toLinearEquiv (Pi.basisFun GF16 (Fin 3)) M hunit (vec i) = _
    rw [Matrix.toLinearEquiv_apply, Matrix.toLin_eq_toLin', Matrix.toLin'_apply]
  have map_point (i j : Idx) (a : Fin 16)
      (hij : Matrix.mulVec M (vec i) = GF16.ofNat a.1 • vec j) :
      ProjectiveCap.Projective.mapEquiv e (point i) = point j := by
    rw [point, toPoint, rawPoint, ProjectiveCap.Projective.mapEquiv_mk]
    apply (rayEq_iff_mk_eq
      ⟨Matrix.mulVec M (vec i), by
        rw [← e_apply]
        simpa only [map_zero] using e.injective.ne (vec_ne_zero i)⟩ (rawPoint j)).mp
    exact ⟨GF16.ofNat a.1, hij.symm⟩
  refine ⟨e, Finset.eq_of_subset_of_card_le ?_ ?_⟩
  · intro p hp
    obtain ⟨q, hqS, hqp⟩ := Finset.mem_map.mp hp
    obtain ⟨i, hiS, rfl⟩ := Finset.mem_map.mp hqS
    have hiw : i ∈ (ws.map MapWitness.source).toFinset := by simpa [h.2.1] using hiS
    obtain ⟨w, hw, hwi⟩ := List.mem_map.mp (List.mem_toFinset.mp hiw)
    obtain ⟨hwt, hwmap⟩ := h.2.2.2 w hw
    have hpj : p = point w.target := hqp.symm.trans
      (map_point i w.target w.scalar (by simpa [hwi] using hwmap))
    rw [hpj]
    exact Finset.mem_map.mpr ⟨w.target, hwt, rfl⟩
  · simp [pointSetIdx, h.2.2.1]

/-- The only new triple condition when adjoining `x` to an already valid cap. -/
def RawExtension (S : Finset Idx) (x : Idx) : Prop :=
  ∀ a ∈ S, ∀ b ∈ S, a ≠ b → Matrix.det ![vec a, vec b, vec x] ≠ 0

instance (S : Finset Idx) (x : Idx) : Decidable (RawExtension S x) := by
  unfold RawExtension
  infer_instance

theorem rawExtension_of_rawCap_insert {S : Finset Idx} {x : Idx}
    (hx : x ∉ S) (h : RawCap (insert x S)) : RawExtension S x := by
  intro a ha b hb hab
  exact h a (by simp [ha]) b (by simp [hb]) x (by simp) hab
    (fun hax => hx (hax ▸ ha)) (fun hbx => hx (hbx ▸ hb))

/-- One locally checkable canonical-augmentation row. -/
structure ExtensionRow where
  move : Idx
  child : Nat
  matrix : MatrixCode
  witnesses : List MapWitness
deriving DecidableEq

/-- Rows for one parent representative. -/
structure NodeBook where
  parent : Finset Idx
  rows : List ExtensionRow
deriving DecidableEq

/-- The locally checked arithmetic payload of one transition row. -/
def ExtensionRow.ValidFor (next : List (Finset Idx)) (parent : Finset Idx)
    (r : ExtensionRow) : Prop :=
  ∃ child, next[r.child]? = some child ∧
    MatrixMaps r.matrix r.witnesses (insert r.move parent) child

instance (next : List (Finset Idx)) (parent : Finset Idx) (r : ExtensionRow) :
    Decidable (r.ValidFor next parent) := by
  unfold ExtensionRow.ValidFor
  infer_instance

def RowListValid (next : List (Finset Idx)) (parent : Finset Idx)
    (rows : List ExtensionRow) : Prop :=
  ∀ r ∈ rows, r.ValidFor next parent

instance (next : List (Finset Idx)) (parent : Finset Idx) (rows : List ExtensionRow) :
    Decidable (RowListValid next parent rows) := by
  unfold RowListValid
  infer_instance

theorem RowListValid.append {next : List (Finset Idx)} {parent : Finset Idx}
    {xs ys : List ExtensionRow} (hx : RowListValid next parent xs)
    (hy : RowListValid next parent ys) : RowListValid next parent (xs ++ ys) := by
  intro r hr
  rcases List.mem_append.mp hr with hr | hr
  · exact hx r hr
  · exact hy r hr

/-- Every legal one-point extension of the parent has an explicitly mapped child in the next
level. Duplicate rows are harmless. -/
def NodeBook.ValidFor (next : List (Finset Idx)) (book : NodeBook) : Prop :=
  RowListValid next book.parent book.rows ∧
    ∀ x : Idx, x ∉ book.parent → RawExtension book.parent x →
      ∃ r ∈ book.rows, r.move = x

instance (next : List (Finset Idx)) (book : NodeBook) : Decidable (book.ValidFor next) := by
  unfold NodeBook.ValidFor
  infer_instance

def BookListValid (next : List (Finset Idx)) (books : List NodeBook) : Prop :=
  ∀ b ∈ books, b.ValidFor next

instance (next : List (Finset Idx)) (books : List NodeBook) :
    Decidable (BookListValid next books) := by
  unfold BookListValid
  infer_instance

theorem BookListValid.append {next : List (Finset Idx)} {xs ys : List NodeBook}
    (hx : BookListValid next xs) (hy : BookListValid next ys) :
    BookListValid next (xs ++ ys) := by
  intro b hb
  rcases List.mem_append.mp hb with hb | hb
  · exact hx b hb
  · exact hy b hb

/-- A chunk checks a subset of parent books against one shared next level. -/
def BooksValid (current next : List (Finset Idx)) (books : List NodeBook) : Prop :=
  books.map NodeBook.parent = current ∧ BookListValid next books

instance (current next : List (Finset Idx)) (books : List NodeBook) :
    Decidable (BooksValid current next books) := by
  unfold BooksValid
  infer_instance

theorem NodeBook.ValidFor.step {next : List (Finset Idx)} {book : NodeBook}
    (hbook : book.ValidFor next) {x : Idx} (hx : x ∉ book.parent)
    (hcap : RawCap (insert x book.parent)) :
    ∃ child ∈ next, RawProjectiveEquiv (insert x book.parent) child := by
  obtain ⟨hrows, hcover⟩ := hbook
  obtain ⟨r, hr, hrx⟩ := hcover x hx (rawExtension_of_rawCap_insert hx hcap)
  subst x
  obtain ⟨child, hchild, hmaps⟩ := hrows r hr
  refine ⟨child, ?_, matrixMaps_sound hmaps⟩
  exact List.mem_iff_getElem?.mpr ⟨r.child, hchild⟩

theorem BooksValid.step {current next : List (Finset Idx)} {books : List NodeBook}
    (hbooks : BooksValid current next books) {A : Finset Idx} (hA : A ∈ current)
    {x : Idx} (hx : x ∉ A) (hcap : RawCap (insert x A)) :
    ∃ child ∈ next, RawProjectiveEquiv (insert x A) child := by
  have hAm : A ∈ books.map NodeBook.parent := by simpa [hbooks.1] using hA
  obtain ⟨book, hb, hparent⟩ := List.mem_map.mp hAm
  subst A
  exact (hbooks.2 book hb).step hx hcap

/-- An indexed cap is classified at a level when it is explicitly projectively equivalent to a
listed representative. -/
def ClassifiedAt (level : List (Finset Idx)) (S : Finset Idx) : Prop :=
  ∃ A ∈ level, RawProjectiveEquiv S A

theorem ClassifiedAt.extend {current next : List (Finset Idx)} {books : List NodeBook}
    (hbooks : BooksValid current next books) {S : Finset Idx}
    (hS : ClassifiedAt current S) {x : Idx} (hx : x ∉ S)
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
  obtain ⟨child, hchild, hstep⟩ := hbooks.step hA hy hcap'
  exact ⟨child, hchild, rawProjectiveEquiv_trans hinsert hstep⟩

/-! ## Quadratic equations and leaf rejection -/

/-- Degree-two monomials in the order `X²,Y²,Z²,XY,XZ,YZ`. -/
def monomial (v : Vec GF16) : Fin 6 → GF16 :=
  ![v 0 ^ 2, v 1 ^ 2, v 2 ^ 2, v 0 * v 1, v 0 * v 2, v 1 * v 2]

theorem dotProduct_monomial_smul (a : GF16) (v : Vec GF16) (q : Fin 6 → GF16) :
    dotProduct (monomial (a • v)) q = a ^ 2 * dotProduct (monomial v) q := by
  simp [monomial, dotProduct, Fin.sum_univ_succ]
  ring

theorem dotProduct_sum_smul (c : Fin 6 → GF16) (v : Fin 6 → Fin 6 → GF16)
    (q : Fin 6 → GF16) :
    dotProduct (∑ i, c i • v i) q = ∑ i, c i * dotProduct (v i) q := by
  simp only [dotProduct, Finset.sum_apply, Pi.smul_apply, smul_eq_mul,
    Finset.sum_mul, Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro j _
  ring

/-- Coefficients of `conicForm (M v)` in the six degree-two monomials. -/
def quadraticCoeffs (M : Matrix (Fin 3) (Fin 3) GF16) : Fin 6 → GF16 :=
  ![M 1 0 ^ 2 - M 0 0 * M 2 0,
    M 1 1 ^ 2 - M 0 1 * M 2 1,
    M 1 2 ^ 2 - M 0 2 * M 2 2,
    2 * M 1 0 * M 1 1 - (M 0 0 * M 2 1 + M 0 1 * M 2 0),
    2 * M 1 0 * M 1 2 - (M 0 0 * M 2 2 + M 0 2 * M 2 0),
    2 * M 1 1 * M 1 2 - (M 0 1 * M 2 2 + M 0 2 * M 2 1)]

theorem conicForm_mulVec_eq_dotProduct (M : Matrix (Fin 3) (Fin 3) GF16)
    (v : Vec GF16) :
    ProjectiveCap.Sym2Bridge.conicForm (Matrix.mulVec M v) =
      dotProduct (monomial v) (quadraticCoeffs M) := by
  simp [ProjectiveCap.Sym2Bridge.conicForm, Matrix.mulVec, dotProduct,
    monomial, quadraticCoeffs, Fin.sum_univ_succ]
  ring

/-- Every nonsingular conic supplies a nonzero homogeneous quadratic equation in the fixed
coordinates, and every point of the conic satisfies it. -/
theorem exists_nonzero_equation (C : NonsingularConic (K := GF16)) :
    ∃ q : Fin 6 → GF16, q ≠ 0 ∧
      ∀ p, dotProduct (monomial p.rep) q = 0 ↔ p ∈ C.points := by
  let f := C.coordinateChange.symm
  let M := LinearMap.toMatrix (Pi.basisFun GF16 (Fin 3)) (Pi.basisFun GF16 (Fin 3))
    f.toLinearMap
  let q := quadraticCoeffs M
  have hMv (v : Vec GF16) : Matrix.mulVec M v = f v := by
    simp [M]
  have hformula (v : Vec GF16) :
      ProjectiveCap.Sym2Bridge.conicForm (f v) =
        dotProduct (monomial v) q := by
    rw [← hMv]
    exact conicForm_mulVec_eq_dotProduct M v
  have hq : q ≠ 0 := by
    intro hzero
    let w : Vec GF16 := ![1, 0, 1]
    let v := C.coordinateChange w
    have hf : f v = w := C.coordinateChange.symm_apply_apply w
    have hz := hformula v
    rw [hf, hzero] at hz
    simp [ProjectiveCap.Sym2Bridge.conicForm, w, dotProduct] at hz
  refine ⟨q, hq, ?_⟩
  intro p
  rw [← hformula]
  rw [NonsingularConic.points, Finset.mem_map_equiv,
    mem_standardConic_iff_onConic]
  change ProjectiveCap.Sym2Bridge.conicForm (f p.rep) = 0 ↔
    ProjectiveCap.Sym2Bridge.OnConic (ProjectiveCap.Projective.mapEquiv f p)
  conv_rhs => rw [← Projectivization.mk_rep p]
  rw [ProjectiveCap.Projective.mapEquiv_mk,
    ProjectiveCap.Sym2Bridge.onConic_mk]

/-- An indexed point is ordinarily uncovered by the secants of `S`. -/
def det3 (u v w : Vec GF16) : GF16 :=
  u 0 * (v 1 * w 2 - v 2 * w 1) -
    u 1 * (v 0 * w 2 - v 2 * w 0) +
      u 2 * (v 0 * w 1 - v 1 * w 0)

theorem det3_eq_det (u v w : Vec GF16) : det3 u v w = Matrix.det ![u, v, w] := by
  rw [Matrix.det_fin_three]
  simp [det3]
  ring

/-! A compact reflected arithmetic layer for the millions of leaf-incidence reductions.  Its
connection to the field is proved once below; certificate leaves then perform table lookups. -/

def fastMulTable : Fin 256 → Fin 16 := ![
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
  0,2,4,6,8,10,12,14,3,1,7,5,11,9,15,13,0,3,6,5,12,15,10,9,11,8,13,14,7,4,1,2,
  0,4,8,12,3,7,11,15,6,2,14,10,5,1,13,9,0,5,10,15,7,2,13,8,14,11,4,1,9,12,3,6,
  0,6,12,10,11,13,7,1,5,3,9,15,14,8,2,4,0,7,14,9,15,8,1,6,13,10,3,4,2,5,12,11,
  0,8,3,11,6,14,5,13,12,4,15,7,10,2,9,1,0,9,1,8,2,11,3,10,4,13,5,12,6,15,7,14,
  0,10,7,13,14,4,9,3,15,5,8,2,1,11,6,12,0,11,5,14,10,1,15,4,7,12,2,9,13,6,8,3,
  0,12,11,7,5,9,14,2,10,6,1,13,15,3,4,8,0,13,9,4,1,12,8,5,2,15,11,6,3,14,10,7,
  0,14,15,1,13,3,2,12,9,7,6,8,4,10,11,5,0,15,13,2,9,6,4,11,1,14,12,3,8,7,5,10]

def fastMulTable2 : Fin 16 → Fin 16 → Fin 16 := ![
  ![0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  ![0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],
  ![0,2,4,6,8,10,12,14,3,1,7,5,11,9,15,13],
  ![0,3,6,5,12,15,10,9,11,8,13,14,7,4,1,2],
  ![0,4,8,12,3,7,11,15,6,2,14,10,5,1,13,9],
  ![0,5,10,15,7,2,13,8,14,11,4,1,9,12,3,6],
  ![0,6,12,10,11,13,7,1,5,3,9,15,14,8,2,4],
  ![0,7,14,9,15,8,1,6,13,10,3,4,2,5,12,11],
  ![0,8,3,11,6,14,5,13,12,4,15,7,10,2,9,1],
  ![0,9,1,8,2,11,3,10,4,13,5,12,6,15,7,14],
  ![0,10,7,13,14,4,9,3,15,5,8,2,1,11,6,12],
  ![0,11,5,14,10,1,15,4,7,12,2,9,13,6,8,3],
  ![0,12,11,7,5,9,14,2,10,6,1,13,15,3,4,8],
  ![0,13,9,4,1,12,8,5,2,15,11,6,3,14,10,7],
  ![0,14,15,1,13,3,2,12,9,7,6,8,4,10,11,5],
  ![0,15,13,2,9,6,4,11,1,14,12,3,8,7,5,10]]

def fastMul (a b : Fin 16) : Fin 16 :=
  ⟨GF16.reduce4 (GF16.carryless4 a.1 b.1) % 16, Nat.mod_lt _ (by omega)⟩

def fastAdd (a b : Fin 16) : Fin 16 :=
  ⟨(a.1 ^^^ b.1) % 16, Nat.mod_lt _ (by omega)⟩

def decode16 (a : Fin 16) : GF16 := GF16.ofNat a.1

theorem decode16_eq_ofNat (a : Fin 16) : decode16 a = GF16.ofNat a.1 := rfl

@[simp] theorem decode16_fastMul (a b : Fin 16) :
    decode16 (fastMul a b) = decode16 a * decode16 b := by decide +revert

@[simp] theorem decode16_fastAdd (a b : Fin 16) :
    decode16 (fastAdd a b) = decode16 a + decode16 b := by decide +revert

@[simp] theorem decode16_val (a : GF16) : decode16 a.val = a := by
  rcases a with ⟨⟨n, hn⟩⟩
  simp [decode16, GF16.ofNat, Nat.mod_eq_of_lt hn]

@[simp] theorem ofNat_val (a : GF16) : GF16.ofNat a.val.1 = a := by
  simpa only [decode16_eq_ofNat] using decode16_val a

@[simp] theorem decode16_eq_zero_iff (a : Fin 16) : decode16 a = 0 ↔ a = 0 := by
  rcases a with ⟨n, hn⟩
  constructor
  · intro h
    apply Fin.ext
    have hx := congrArg (fun x : GF16 => x.val.val) h
    simp only [decode16, GF16.ofNat, Nat.mod_eq_of_lt hn] at hx
    change n = 0 at hx
    exact hx
  · intro h
    have hn0 : n = 0 := congrArg Fin.val h
    subst n
    rfl

def fastDet3 (u v w : Fin 3 → Fin 16) : Fin 16 :=
  fastAdd
    (fastAdd
      (fastMul (u 0) (fastAdd (fastMul (v 1) (w 2)) (fastMul (v 2) (w 1))))
      (fastMul (u 1) (fastAdd (fastMul (v 0) (w 2)) (fastMul (v 2) (w 0)))))
    (fastMul (u 2) (fastAdd (fastMul (v 0) (w 1)) (fastMul (v 1) (w 0))))

theorem decode16_fastDet3 (u v w : Fin 3 → Fin 16) :
    decode16 (fastDet3 u v w) =
      det3 (fun i => decode16 (u i)) (fun i => decode16 (v i))
        (fun i => decode16 (w i)) := by
  have neg_self (x : GF16) : -x = x := rfl
  simp [fastDet3, det3, sub_eq_add_neg, neg_self]

theorem fastDet3_swap_ne (u v w : Fin 3 → Fin 16) :
    fastDet3 u v w ≠ 0 ↔ fastDet3 u w v ≠ 0 := by
  have swap (x y : Fin 3 → Fin 16) (h : fastDet3 u x y ≠ 0) :
      fastDet3 u y x ≠ 0 := by
    intro hzero
    apply h
    rw [← decode16_eq_zero_iff, decode16_fastDet3]
    have hfield : det3 (fun i => decode16 (u i)) (fun i => decode16 (y i))
        (fun i => decode16 (x i)) = 0 := by
      rw [← decode16_fastDet3]
      exact congrArg decode16 hzero
    have hanti : det3 (fun i => decode16 (u i)) (fun i => decode16 (x i))
        (fun i => decode16 (y i)) =
          -det3 (fun i => decode16 (u i)) (fun i => decode16 (y i))
            (fun i => decode16 (x i)) := by
      simp [det3]
      ring
    rw [hanti, hfield, neg_zero]
  exact ⟨swap v w, swap w v⟩

def vecCode (i : Idx) : Fin 3 → Fin 16 := fun j => (vec i j).val

theorem decode16_vecCode (i : Idx) : (fun j => decode16 (vecCode i j)) = vec i := by
  funext j
  exact decode16_val _

def OrdinaryUncovered (S : Finset Idx) (i : Idx) : Prop :=
  i ∉ S ∧ ∀ a ∈ S, ∀ b ∈ S, a ≠ b →
    fastDet3 (vecCode i) (vecCode a) (vecCode b) ≠ 0

instance (S : Finset Idx) (i : Idx) : Decidable (OrdinaryUncovered S i) := by
  unfold OrdinaryUncovered
  infer_instance

/-- The 28 unordered pairs of an eight-element enumeration. -/
def pair8 : Fin 28 → Fin 8 × Fin 8 := ![
  (0,1),(0,2),(0,3),(0,4),(0,5),(0,6),(0,7),
  (1,2),(1,3),(1,4),(1,5),(1,6),(1,7),
  (2,3),(2,4),(2,5),(2,6),(2,7),
  (3,4),(3,5),(3,6),(3,7),
  (4,5),(4,6),(4,7),(5,6),(5,7),(6,7)]

theorem pair8_complete (a b : Fin 8) (hab : a ≠ b) :
    ∃ k, pair8 k = (a, b) ∨ pair8 k = (b, a) := by decide +revert

/-- A bounded checker for ordinary uncoveredness, using an explicit eight-entry enumeration of
the leaf and its 28 unordered pairs.  This avoids a `273²` kernel reduction. -/
def OrdinaryUncoveredBy (S : Finset Idx) (members : Fin 8 → Idx) (i : Idx) : Prop :=
  i ∉ S ∧ ∀ k : Fin 28,
    fastDet3 (vecCode i) (vecCode (members (pair8 k).1))
      (vecCode (members (pair8 k).2)) ≠ 0

instance (S : Finset Idx) (members : Fin 8 → Idx) (i : Idx) :
    Decidable (OrdinaryUncoveredBy S members i) := by
  unfold OrdinaryUncoveredBy
  infer_instance

theorem ordinaryUncovered_of_by {S : Finset Idx} {members : Fin 8 → Idx} {i : Idx}
    (hmembers : Finset.univ.image members = S) (h : OrdinaryUncoveredBy S members i) :
    OrdinaryUncovered S i := by
  refine ⟨h.1, ?_⟩
  intro a ha b hb hab
  rw [← hmembers] at ha hb
  obtain ⟨ia, _hia, rfl⟩ := Finset.mem_image.mp ha
  obtain ⟨ib, _hib, rfl⟩ := Finset.mem_image.mp hb
  obtain ⟨k, hk | hk⟩ := pair8_complete ia ib (fun hij => hab (congrArg members hij))
  · simpa [hk] using h.2 k
  · exact (fastDet3_swap_ne _ _ _).mpr (by simpa [hk] using h.2 k)

theorem raw_equation_iff_mem (C : NonsingularConic (K := GF16))
    {q : Fin 6 → GF16} (hqC : ∀ p, dotProduct (monomial p.rep) q = 0 ↔ p ∈ C.points)
    (i : Idx) : dotProduct (monomial (vec i)) q = 0 ↔ point i ∈ C.points := by
  obtain ⟨a, ha⟩ := Projectivization.exists_smul_eq_mk_rep GF16 (vec i) (vec_ne_zero i)
  have ha0 : (a : GF16) ^ 2 ≠ 0 := pow_ne_zero 2 a.ne_zero
  have hscale : dotProduct (monomial (point i).rep) q =
      (a : GF16) ^ 2 * dotProduct (monomial (vec i)) q := by
    change dotProduct (monomial
      ((Projectivization.mk GF16 (vec i) (vec_ne_zero i)).rep)) q = _
    rw [← ha]
    exact dotProduct_monomial_smul (a : GF16) (vec i) q
  rw [← hqC, hscale]
  exact (mul_eq_zero_iff_left ha0).symm

theorem uncovered_mem_conic {S : Finset Idx} {i : Idx}
    (hi : OrdinaryUncovered S i) (C : NonsingularConic (K := GF16))
    (hcomplete : CompleteOutside (L := Point16) (pointSetIdx S) C.points) :
    point i ∈ C.points := by
  by_contra hiC
  have hiA : point i ∉ pointSetIdx S := by
    intro hip
    obtain ⟨j, hjS, hji⟩ := Finset.mem_map.mp hip
    exact hi.1 (point_injective (by simpa using hji.symm) ▸ hjS)
  have hcovered := hcomplete.2.2 (point i) hiA hiC
  obtain ⟨pa, hpa, pb, hpb, hpab, hcol⟩ :=
    (covered_iff_collinear_pair (L := Point16)).mp hcovered
  obtain ⟨a, haS, rfl⟩ := Finset.mem_map.mp hpa
  obtain ⟨b, hbS, rfl⟩ := Finset.mem_map.mp hpb
  have hab : a ≠ b := fun hab => hpab (hab ▸ rfl)
  apply hi.2 a haS b hbS hab
  rw [← decode16_eq_zero_iff, decode16_fastDet3,
    decode16_vecCode, decode16_vecCode, decode16_vecCode]
  exact det3_eq_det _ _ _ |>.trans
    ((ProjectiveCap.Projective.FrameGridBridge.Coordinate.mk_collinear_iff_det_eq_zero
      (vec_ne_zero i) (vec_ne_zero a) (vec_ne_zero b)).mp
      (ProjectiveBridge.collinear_iff_projective_collinear.mp hcol))

/-- Six uncovered points whose quadratic monomial rows are invertible. -/
abbrev MatrixCode6 := Fin 36 → Fin 16

def decodeMatrix6 (m : MatrixCode6) : Matrix (Fin 6) (Fin 6) GF16 :=
  fun i j => GF16.ofNat (m ⟨i.1 * 6 + j.1, by omega⟩).1

structure FullRankReject where
  members : Fin 8 → Idx
  points : Fin 6 → Idx
  inverse : MatrixCode6
deriving DecidableEq

def FullRankReject.matrix (r : FullRankReject) : Matrix (Fin 6) (Fin 6) GF16 :=
  fun i j => monomial (vec (r.points i)) j

def inverseCodeEntry (r : FullRankReject) (i j : Fin 6) : Fin 16 :=
  r.inverse ⟨i.1 * 6 + j.1, by omega⟩

def matrixCodeEntry (r : FullRankReject) (i j : Fin 6) : Fin 16 :=
  (monomial (vec (r.points i)) j).val

def fastDot6 (u v : Fin 6 → Fin 16) : Fin 16 :=
  fastAdd (fastMul (u 0) (v 0))
    (fastAdd (fastMul (u 1) (v 1))
      (fastAdd (fastMul (u 2) (v 2))
        (fastAdd (fastMul (u 3) (v 3))
          (fastAdd (fastMul (u 4) (v 4)) (fastMul (u 5) (v 5))))))

theorem decode16_fastDot6 (u v : Fin 6 → Fin 16) :
    decode16 (fastDot6 u v) = ∑ i, decode16 (u i) * decode16 (v i) := by
  simp [fastDot6, Fin.sum_univ_succ]

def FastInverseValid (r : FullRankReject) : Prop :=
  ∀ i j : Fin 6,
    fastDot6 (fun k => inverseCodeEntry r i k) (fun k => matrixCodeEntry r k j) =
      if i = j then 1 else 0

instance (r : FullRankReject) : Decidable (FastInverseValid r) := by
  unfold FastInverseValid
  infer_instance

theorem fastInverseValid_sound {r : FullRankReject} (h : FastInverseValid r) :
    decodeMatrix6 r.inverse * r.matrix = 1 := by
  funext i j
  have hij := congrArg decode16 (h i j)
  rw [decode16_fastDot6] at hij
  have hzeroone : decode16 (if i = j then 1 else 0) =
      (if i = j then 1 else 0 : GF16) := by
    split <;> rfl
  rw [hzeroone] at hij
  simpa [Matrix.mul_apply, decodeMatrix6, FullRankReject.matrix, inverseCodeEntry,
    matrixCodeEntry, decode16_eq_ofNat, decode16_val, Fin.sum_univ_succ,
    Matrix.one_apply] using hij

def FullRankReject.ValidFor (S : Finset Idx) (r : FullRankReject) : Prop :=
  Finset.univ.image r.members = S ∧
  (∀ i, OrdinaryUncoveredBy S r.members (r.points i)) ∧
    FastInverseValid r

instance (S : Finset Idx) (r : FullRankReject) : Decidable (r.ValidFor S) := by
  unfold FullRankReject.ValidFor
  infer_instance

theorem FullRankReject.not_complete {S : Finset Idx} {r : FullRankReject}
    (hr : r.ValidFor S) (C : NonsingularConic (K := GF16)) :
    ¬ CompleteOutside (L := Point16) (pointSetIdx S) C.points := by
  intro hcomplete
  obtain ⟨q, hq, hqC⟩ := exists_nonzero_equation C
  have hrow (i : Fin 6) : dotProduct (monomial (vec (r.points i))) q = 0 := by
    exact (raw_equation_iff_mem C hqC (r.points i)).mpr
      (uncovered_mem_conic (ordinaryUncovered_of_by hr.1 (hr.2.1 i)) C hcomplete)
  have hmul : Matrix.mulVec r.matrix q = 0 := by
    funext i
    simpa [Matrix.mulVec, FullRankReject.matrix] using hrow i
  apply hq
  rw [← Matrix.one_mulVec q, ← fastInverseValid_sound hr.2.2,
    ← Matrix.mulVec_mulVec, hmul,
    Matrix.mulVec_zero]

/-- A selected point whose monomial row is an explicit linear combination of six uncovered
rows. This is the rank-five rejection used by the three exceptional leaf classes. -/
structure ForcedHitReject where
  members : Fin 8 → Idx
  points : Fin 6 → Idx
  coeffs : Fin 6 → Fin 16
  hit : Idx
deriving DecidableEq

def ForcedHitReject.ValidFor (S : Finset Idx) (r : ForcedHitReject) : Prop :=
  Finset.univ.image r.members = S ∧ r.hit ∈ S ∧
    (∀ i, OrdinaryUncoveredBy S r.members (r.points i)) ∧
    monomial (vec r.hit) =
      ∑ i, GF16.ofNat (r.coeffs i).1 • monomial (vec (r.points i))

instance (S : Finset Idx) (r : ForcedHitReject) : Decidable (r.ValidFor S) := by
  unfold ForcedHitReject.ValidFor
  infer_instance

theorem ForcedHitReject.not_complete {S : Finset Idx} {r : ForcedHitReject}
    (hr : r.ValidFor S) (C : NonsingularConic (K := GF16)) :
    ¬ CompleteOutside (L := Point16) (pointSetIdx S) C.points := by
  intro hcomplete
  obtain ⟨q, _hq, hqC⟩ := exists_nonzero_equation C
  have hrow (i : Fin 6) : dotProduct (monomial (vec (r.points i))) q = 0 :=
    (raw_equation_iff_mem C hqC (r.points i)).mpr
      (uncovered_mem_conic (ordinaryUncovered_of_by hr.1 (hr.2.2.1 i)) C hcomplete)
  have hhit : dotProduct (monomial (vec r.hit)) q = 0 := by
    rw [hr.2.2.2]
    calc
      dotProduct (∑ i, GF16.ofNat (r.coeffs i).1 • monomial (vec (r.points i))) q =
          ∑ i, GF16.ofNat (r.coeffs i).1 *
            dotProduct (monomial (vec (r.points i))) q := by
              exact dotProduct_sum_smul _ _ _
      _ = 0 := by simp_rw [hrow, mul_zero]; exact Finset.sum_const_zero
  have hhitC : point r.hit ∈ C.points :=
    (raw_equation_iff_mem C hqC r.hit).mp hhit
  have hhitA : point r.hit ∈ pointSetIdx S :=
    Finset.mem_map.mpr ⟨r.hit, hr.2.1, rfl⟩
  exact (Finset.disjoint_left.mp hcomplete.2.1) hhitA hhitC

inductive LeafReject where
  | fullRank (r : FullRankReject)
  | forcedHit (r : ForcedHitReject)
deriving DecidableEq

def LeafReject.ValidFor (S : Finset Idx) : LeafReject → Prop
  | .fullRank r => r.ValidFor S
  | .forcedHit r => r.ValidFor S

instance (S : Finset Idx) (r : LeafReject) : Decidable (r.ValidFor S) := by
  cases r <;> simp only [LeafReject.ValidFor] <;> infer_instance

theorem LeafReject.not_complete {S : Finset Idx} {r : LeafReject} (hr : r.ValidFor S)
    (C : NonsingularConic (K := GF16)) :
    ¬ CompleteOutside (L := Point16) (pointSetIdx S) C.points := by
  cases r with
  | fullRank r => exact r.not_complete hr C
  | forcedHit r => exact r.not_complete hr C

structure RejectedLeaf where
  leaf : Finset Idx
  reject : LeafReject
deriving DecidableEq

def LeafListValid (leaves : List RejectedLeaf) : Prop :=
  ∀ x ∈ leaves, x.reject.ValidFor x.leaf

instance (leaves : List RejectedLeaf) : Decidable (LeafListValid leaves) := by
  unfold LeafListValid
  infer_instance

theorem LeafListValid.append {xs ys : List RejectedLeaf}
    (hx : LeafListValid xs) (hy : LeafListValid ys) : LeafListValid (xs ++ ys) := by
  intro x hxmem
  rcases List.mem_append.mp hxmem with hxmem | hxmem
  · exact hx x hxmem
  · exact hy x hxmem

def RejectsLevel (level : List (Finset Idx)) (leaves : List RejectedLeaf) : Prop :=
  leaves.map RejectedLeaf.leaf = level ∧ LeafListValid leaves

instance (level : List (Finset Idx)) (leaves : List RejectedLeaf) :
    Decidable (RejectsLevel level leaves) := by
  unfold RejectsLevel
  infer_instance

theorem RejectsLevel.not_complete {level : List (Finset Idx)} {leaves : List RejectedLeaf}
    (h : RejectsLevel level leaves) {S : Finset Idx} (hS : S ∈ level)
    (C : NonsingularConic (K := GF16)) :
    ¬ CompleteOutside (L := Point16) (pointSetIdx S) C.points := by
  have hSm : S ∈ leaves.map RejectedLeaf.leaf := by simpa [h.1] using hS
  obtain ⟨x, hx, hleaf⟩ := List.mem_map.mp hSm
  subst S
  exact x.reject.not_complete (h.2 x hx) C

end Q16Classification
end RelativeConicArcs
