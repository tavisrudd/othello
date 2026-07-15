import RelativeConicArcs.Q25Coordinates

/-!
# Reflected normalized pair-extension problem in `PG(2,25)`

The executable proposition in this file is deliberately small: it checks only freshness and the
new determinant conditions introduced by adjoining a point and then its conjugate.  The soundness
lemmas prove that a successful reflected check gives an actual projective cap extension.
-/

namespace RelativeConicArcs
namespace Q25PairCertificate

open Q25Coordinates FiniteFields
open scoped LinearAlgebra.Projectivization

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

/-- A duplicate-free, explicitly enumerable code for the 310 nonfixed conjugate point orbits.

For an encoded field element `a+bω`, coefficient conjugation sends `b` to `-b`.  The representative
with smaller field code has `b=1` or `b=2`; the constructors record the first nonfixed coordinate
of a canonical projective point.
-/
inductive OrbitCode where
  | affineY (a : Fin 5) (b : Fin 2) (z : K25)
  | affineZ (y : Fin 5) (a : Fin 5) (b : Fin 2)
  | infinity (a : Fin 5) (b : Fin 2)
deriving DecidableEq, Fintype

theorem card_orbitCode : Fintype.card OrbitCode = 310 := by decide

def smallNonfixed (a : Fin 5) (b : Fin 2) : K25 :=
  GF25.encode a.val (b.val + 1)

def orbitIdx : OrbitCode → Idx25
  | .affineY a b z => .affine (smallNonfixed a b) z
  | .affineZ y a b => .affine (GF25.encode y.val 0) (smallNonfixed a b)
  | .infinity a b => .infinity (smallNonfixed a b)

theorem orbitIdx_lt_conj (o : OrbitCode) :
    rank (orbitIdx o) < rank (conjIdx (orbitIdx o)) := by
  revert o
  decide

def orbitRep (o : OrbitCode) : OrbitRep := ⟨orbitIdx o, orbitIdx_lt_conj o⟩

/-- The orbit codes cover every selected representative exactly once.  This finite statement is
proved by kernel reduction from the definitions, not assumed from the external enumerator. -/
theorem orbitRep_bijective : Function.Bijective orbitRep := by decide

/-- A stable number used to order the three selected nonfixed orbits. -/
def orbitNumber : OrbitCode → Nat
  | .affineY a b z => (a.val * 2 + b.val) * 25 + z.val
  | .affineZ y a b => 250 + (y.val * 5 + a.val) * 2 + b.val
  | .infinity a b => 300 + a.val * 2 + b.val

theorem orbitNumber_lt (o : OrbitCode) : orbitNumber o < 310 := by
  cases o <;> simp [orbitNumber] <;> omega

theorem orbitNumber_injective : Function.Injective orbitNumber := by decide

def orbitPair (o : OrbitCode) : Finset Idx25 :=
  {orbitIdx o, conjIdx (orbitIdx o)}

theorem card_orbitPair (o : OrbitCode) : (orbitPair o).card = 2 := by
  unfold orbitPair
  rw [Finset.card_pair]
  intro h
  have hr := congrArg rank h
  have := orbitIdx_lt_conj o
  omega

theorem orbitPair_injective : Function.Injective orbitPair := by decide

/-- The standard ordered pair of fixed points `[0:0:1]`, `[0:1:0]`. -/
def fixedPair : Finset Idx25 := {.vertical, .infinity 0}

theorem card_fixedPair : fixedPair.card = 2 := by decide

/-- The normalized invariant eight-set determined by three nonfixed orbits. -/
def normalizedConfig (a b c : OrbitCode) : Finset Idx25 :=
  fixedPair ∪ orbitPair a ∪ orbitPair b ∪ orbitPair c

/-- The determinant conditions newly introduced by adjoining one point. -/
def RawExtension (S : Finset Idx25) (x : Idx25) : Prop :=
  ∀ a ∈ S, ∀ b ∈ S, a ≠ b → Matrix.det ![vec a, vec b, vec x] ≠ 0

instance (S : Finset Idx25) (x : Idx25) : Decidable (RawExtension S x) := by
  unfold RawExtension
  infer_instance

theorem rawCap_insert {S : Finset Idx25} {x : Idx25}
    (hS : RawCap S) (hx : x ∉ S) (hext : RawExtension S x) :
    RawCap (insert x S) := by
  have det_cycle (u v w : Fin 3 → K25) :
      Matrix.det ![u, v, w] = Matrix.det ![v, w, u] := by
    simp [Matrix.det_fin_three]
    ring
  have det_swap (u v w : Fin 3 → K25) :
      Matrix.det ![u, v, w] = -Matrix.det ![u, w, v] := by
    simp [Matrix.det_fin_three]
    ring
  intro a ha b hb c hc hab hac hbc
  simp only [Finset.mem_insert] at ha hb hc
  rcases ha with rfl | ha
  · rcases hb with rfl | hb
    · exact False.elim (hab rfl)
    · rcases hc with rfl | hc
      · exact False.elim (hac rfl)
      · intro hz
        exact hext b hb c hc hbc ((det_cycle (vec a) (vec b) (vec c)).symm.trans hz)
  · rcases hb with rfl | hb
    · rcases hc with rfl | hc
      · exact False.elim (hbc rfl)
      · intro hz
        apply hext a ha c hc hac
        have hneg : -Matrix.det ![vec a, vec b, vec c] = 0 := by rw [hz, neg_zero]
        exact (det_swap (vec a) (vec c) (vec b)).trans hneg
    · rcases hc with rfl | hc
      · exact hext a ha b hb hab
      · exact hS a ha b hb c hc hab hac hbc

theorem rawCap_mono {S T : Finset Idx25} (hST : S ⊆ T) (hT : RawCap T) : RawCap S := by
  intro a ha b hb c hc
  exact hT a (hST ha) b (hST hb) c (hST hc)

/-- A candidate orbit is a legal two-point extension in the reflected coordinate model. -/
def LegalPair (S : Finset Idx25) (o : OrbitCode) : Prop :=
  orbitIdx o ∉ S ∧
    RawExtension S (orbitIdx o) ∧
    conjIdx (orbitIdx o) ∉ insert (orbitIdx o) S ∧
    RawExtension (insert (orbitIdx o) S) (conjIdx (orbitIdx o))

instance (S : Finset Idx25) (o : OrbitCode) : Decidable (LegalPair S o) := by
  unfold LegalPair
  infer_instance

/-- Two explicit orbit codes are distinct legal extensions of the same normalized configuration. -/
def TwoLegalPairs (S : Finset Idx25) (q r : OrbitCode) : Prop :=
  q ≠ r ∧ LegalPair S q ∧ LegalPair S r

instance (S : Finset Idx25) (q r : OrbitCode) : Decidable (TwoLegalPairs S q r) := by
  unfold TwoLegalPairs
  infer_instance

theorem LegalPair.rawCap_union {S : Finset Idx25} {o : OrbitCode}
    (hS : RawCap S) (h : LegalPair S o) :
    RawCap (S ∪ orbitPair o) := by
  have h1 : RawCap (insert (orbitIdx o) S) := rawCap_insert hS h.1 h.2.1
  have h2 : RawCap (insert (conjIdx (orbitIdx o)) (insert (orbitIdx o) S)) :=
    rawCap_insert h1 h.2.2.1 h.2.2.2
  have heq :
      S ∪ orbitPair o = insert (conjIdx (orbitIdx o)) (insert (orbitIdx o) S) := by
    ext y
    simp [orbitPair, or_comm, or_left_comm, or_assoc]
  rw [heq]
  exact h2

/-- The set-level criterion used to transport a legal pair through a projective permutation. -/
def PairFresh (S : Finset Idx25) (o : OrbitCode) : Prop :=
  Disjoint S (orbitPair o)

theorem LegalPair.pairFresh {S : Finset Idx25} {o : OrbitCode} (h : LegalPair S o) :
    PairFresh S o := by
  unfold PairFresh
  rw [Finset.disjoint_left]
  intro x hxS hxo
  simp only [orbitPair, Finset.mem_insert, Finset.mem_singleton] at hxo
  rcases hxo with rfl | rfl
  · exact h.1 hxS
  · exact h.2.2.1 (Finset.mem_insert_of_mem hxS)

theorem legalPair_of_pairFresh_rawCap_union {S : Finset Idx25} {o : OrbitCode}
    (hfresh : PairFresh S o) (hcap : RawCap (S ∪ orbitPair o)) : LegalPair S o := by
  have hpS : orbitIdx o ∉ S := by
    intro hp
    exact (Finset.disjoint_left.mp hfresh hp) (by simp [orbitPair])
  have hqS : conjIdx (orbitIdx o) ∉ S := by
    intro hq
    exact (Finset.disjoint_left.mp hfresh hq) (by simp [orbitPair])
  have hpq : orbitIdx o ≠ conjIdx (orbitIdx o) := by
    intro h
    have hr := congrArg rank h
    exact (Nat.ne_of_lt (orbitIdx_lt_conj o)) hr
  refine ⟨hpS, ?_, ?_, ?_⟩
  · intro a ha b hb hab
    exact hcap a (Finset.mem_union_left _ ha) b (Finset.mem_union_left _ hb)
      (orbitIdx o) (Finset.mem_union_right _ (by simp [orbitPair])) hab
      (fun h => hpS (h ▸ ha)) (fun h => hpS (h ▸ hb))
  · simp [hqS, hpq.symm]
  · intro a ha b hb hab
    exact hcap a (by
        simp only [Finset.mem_insert] at ha
        rcases ha with rfl | ha
        · exact Finset.mem_union_right _ (by simp [orbitPair])
        · exact Finset.mem_union_left _ ha)
      b (by
        simp only [Finset.mem_insert] at hb
        rcases hb with rfl | hb
        · exact Finset.mem_union_right _ (by simp [orbitPair])
        · exact Finset.mem_union_left _ hb)
      (conjIdx (orbitIdx o)) (Finset.mem_union_right _ (by simp [orbitPair])) hab
      (fun h => by
        simp only [Finset.mem_insert] at ha
        rcases ha with rfl | ha
        · exact hpq h
        · exact hqS (h ▸ ha))
      (fun h => by
        simp only [Finset.mem_insert] at hb
        rcases hb with rfl | hb
        · exact hpq h
        · exact hqS (h ▸ hb))

/-- Every increasing normalized invariant triple that is an arc has a checked conjugate-pair
extension.  Generated leaf modules will prove slices of this proposition by `decide`; a separate
composition theorem will combine the slices. -/
def NormalizedExtensionStatement : Prop :=
  ∀ a b c : OrbitCode,
    orbitNumber a < orbitNumber b → orbitNumber b < orbitNumber c →
      RawCap (normalizedConfig a b c) →
        ∃ q : OrbitCode, LegalPair (normalizedConfig a b c) q

instance : Decidable NormalizedExtensionStatement := by
  unfold NormalizedExtensionStatement
  infer_instance

/-- Strong normalized target: every increasing normalized arc has two distinct legal pairs. -/
def NormalizedTwoExtensionStatement : Prop :=
  ∀ a b c : OrbitCode,
    orbitNumber a < orbitNumber b → orbitNumber b < orbitNumber c →
      RawCap (normalizedConfig a b c) →
        ∃ q r : OrbitCode, TwoLegalPairs (normalizedConfig a b c) q r

instance : Decidable NormalizedTwoExtensionStatement := by
  unfold NormalizedTwoExtensionStatement
  infer_instance

/-- One fixed-first-orbit slice of the normalized certificate. -/
def FirstSlice (a : OrbitCode) : Prop :=
  ∀ b c : OrbitCode,
    orbitNumber a < orbitNumber b → orbitNumber b < orbitNumber c →
      RawCap (normalizedConfig a b c) →
        ∃ q : OrbitCode, LegalPair (normalizedConfig a b c) q

instance (a : OrbitCode) : Decidable (FirstSlice a) := by
  unfold FirstSlice
  infer_instance

/-- Strong fixed-first-orbit slice used by the two-witness certificate. -/
def FirstSliceTwo (a : OrbitCode) : Prop :=
  ∀ b c : OrbitCode,
    orbitNumber a < orbitNumber b → orbitNumber b < orbitNumber c →
      RawCap (normalizedConfig a b c) →
        ∃ q r : OrbitCode, TwoLegalPairs (normalizedConfig a b c) q r

instance (a : OrbitCode) : Decidable (FirstSliceTwo a) := by
  unfold FirstSliceTwo
  infer_instance

def codeFin5 (n : Nat) : Fin 5 := ⟨n % 5, Nat.mod_lt _ (by decide)⟩
def codeFin2 (n : Nat) : Fin 2 := ⟨n % 2, Nat.mod_lt _ (by decide)⟩

/-- Inverse of the stable orbit-number encoding, used to index generated certificate rows. -/
def orbitCodeOfNumber (n : Fin 310) : OrbitCode :=
  if n.val < 250 then
    .affineY (codeFin5 (n.val / 50)) (codeFin2 (n.val / 25)) (GF25.ofNat n.val)
  else if n.val < 300 then
    let m := n.val - 250
    .affineZ (codeFin5 (m / 10)) (codeFin5 (m / 2)) (codeFin2 m)
  else
    let m := n.val - 300
    .infinity (codeFin5 (m / 2)) (codeFin2 m)

@[simp] theorem orbitCodeOfNumber_orbitNumber (o : OrbitCode) :
    orbitCodeOfNumber ⟨orbitNumber o, orbitNumber_lt o⟩ = o := by
  revert o
  decide

/-- The eight explicitly ordered points of a normalized three-orbit configuration. -/
def configPoint (a b c : OrbitCode) : Fin 8 → Idx25 := ![
  .vertical, .infinity 0,
  orbitIdx a, conjIdx (orbitIdx a),
  orbitIdx b, conjIdx (orbitIdx b),
  orbitIdx c, conjIdx (orbitIdx c)]

theorem configPoint_mem (a b c : OrbitCode) (i : Fin 8) :
    configPoint a b c i ∈ normalizedConfig a b c := by
  fin_cases i <;> simp [configPoint, normalizedConfig, fixedPair, orbitPair]

/-- A compact, independently checkable certificate that a normalized configuration is not a cap. -/
def BadWitnessValid (a b c : OrbitCode) (i j k : Fin 8) : Prop :=
  configPoint a b c i ≠ configPoint a b c j ∧
  configPoint a b c i ≠ configPoint a b c k ∧
  configPoint a b c j ≠ configPoint a b c k ∧
  Matrix.det ![vec (configPoint a b c i), vec (configPoint a b c j),
    vec (configPoint a b c k)] = 0

instance (a b c : OrbitCode) (i j k : Fin 8) : Decidable (BadWitnessValid a b c i j k) := by
  unfold BadWitnessValid
  infer_instance

theorem not_rawCap_of_badWitness {a b c : OrbitCode} {i j k : Fin 8}
    (h : BadWitnessValid a b c i j k) : ¬ RawCap (normalizedConfig a b c) := by
  intro hcap
  exact (hcap (configPoint a b c i) (configPoint_mem a b c i)
    (configPoint a b c j) (configPoint_mem a b c j)
    (configPoint a b c k) (configPoint_mem a b c k) h.1 h.2.1 h.2.2.1) h.2.2.2

@[simp] theorem orbitCodeOfNumber_five :
    orbitCodeOfNumber ⟨5, by decide⟩ = .affineY 0 0 (GF25.ofNat 5) := by decide

/-- One classified normalized row: either a concrete obstruction proves the input is not an arc,
or two concrete distinct legal orbits extend it. -/
def RowResult (b c : Fin 310) : Prop :=
  ¬ RawCap (normalizedConfig (orbitCodeOfNumber ⟨5, by decide⟩)
    (orbitCodeOfNumber b) (orbitCodeOfNumber c)) ∨
  ∃ q r : OrbitCode,
    TwoLegalPairs
      (normalizedConfig (orbitCodeOfNumber ⟨5, by decide⟩)
        (orbitCodeOfNumber b) (orbitCodeOfNumber c)) q r

end Q25PairCertificate
end RelativeConicArcs
