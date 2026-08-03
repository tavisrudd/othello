import RelativeConicArcs.CodingBridge
import RelativeConicArcs.Certificate
import Mathlib.GroupTheory.Perm.Sign

/-!
# Stable foundations for the Clebsch gateway

This module contains presentation-independent interfaces for the following constructions:

* projective distance-three directions are uncovered one-column arc extensions;
* an indexed projective arc gives transparent codimension-three MDS columns;
* a faithful decoration recovers its parent;
* two actions on two-element torsors with the same kernel have the same character; and
* an exact orbit classifier can be transported across a certified fusion.

The fixed `q = 11` computations live in separate bounded modules.  This module does not define a
cubic-surface or tensor interpretation, nor does it assert that a concrete geometric transform has
a two-element fibre.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace ClebschGateway

open Configuration Finset

variable {P L : Type*} [Membership P L]

section DeepTransform

variable [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

/-- The presentation-independent deep transform: the projective distance-three directions. -/
noncomputable abbrev deepTransform (A : Finset P) : Finset P :=
  distanceThreeDirections (L := L) A

/-- Membership in the deep transform of a point set: a point belongs to it exactly when it lies
outside the set and is covered by no secant of the set. -/
@[simp] theorem mem_deepTransform {A : Finset P} {x : P} :
    x ∈ deepTransform (L := L) A ↔ x ∉ A ∧ ¬Covered (L := L) A x :=
  mem_distanceThreeDirections

/-- A deep direction is exactly a fresh one-column arc extension. -/
theorem oneColumnArcExtension_iff_mem_deepTransform {A : Finset P}
    (hA : Arc (L := L) A) {x : P} :
    (x ∉ A ∧ Arc (L := L) (insert x A)) ↔ x ∈ deepTransform (L := L) A := by
  rw [oneColumnExtension_iff_distance_three hA, mem_distanceThreeDirections]
  exact projectiveSyndromeDistance_eq_three_iff

end DeepTransform

section ProjectiveMDS

open CodingBridge

variable {K ι : Type*} [Field K] [DecidableEq K] [Fintype ι] [DecidableEq ι]

/-- A point of the coordinate projective plane over `K`, in the coding-bridge representation used
for the projective maximum-distance-separable columns below. -/
abbrev PlanePoint (K : Type*) [Field K] := CodingBridge.PlanePoint K

noncomputable local instance : DecidableEq (PlanePoint K) := Classical.decEq _

/-- Append one projective column, indexed by `none`, to an indexed family. -/
def appendPoint (p : ι → PlanePoint K) (x : PlanePoint K) : Option ι → PlanePoint K
  | none => x
  | some i => p i

/-- Appending a point outside the image of an injective indexed family preserves injectivity. -/
theorem appendPoint_injective (p : ι → PlanePoint K) (x : PlanePoint K)
    (hp : Function.Injective p) (hx : x ∉ Finset.univ.image p) :
    Function.Injective (appendPoint p x) := by
  intro i j hij
  cases i with
  | none =>
      cases j with
      | none => rfl
      | some j =>
          exfalso
          exact hx (Finset.mem_image.mpr ⟨j, Finset.mem_univ _, hij.symm⟩)
  | some i =>
      cases j with
      | none =>
          exfalso
          exact hx (Finset.mem_image.mpr ⟨i, Finset.mem_univ _, hij⟩)
      | some j =>
          exact congrArg some (hp hij)

/-- The image of an appended indexed family is the old image with the new point inserted. -/
theorem image_appendPoint (p : ι → PlanePoint K) (x : PlanePoint K) :
    Finset.univ.image (appendPoint p x) = insert x (Finset.univ.image p) := by
  classical
  ext y
  constructor
  · intro hy
    obtain ⟨i, _hi, rfl⟩ := Finset.mem_image.mp hy
    cases i <;> simp [appendPoint]
  · intro hy
    rw [Finset.mem_insert] at hy
    rcases hy with rfl | hy
    · exact Finset.mem_image.mpr ⟨none, Finset.mem_univ _, rfl⟩
    · obtain ⟨i, _hi, rfl⟩ := Finset.mem_image.mp hy
      exact Finset.mem_image.mpr ⟨some i, Finset.mem_univ _, rfl⟩

/-- An injectively indexed projective arc with at least three columns supplies the transparent
`[n,n-3,≥4]` parity-check package on any chosen projective representatives. -/
theorem codimThreeMDSColumns_of_arc (p : ι → PlanePoint K)
    (hp : Function.Injective p) (hcard : 3 ≤ Fintype.card ι)
    (hArc : Arc (L := PlanePoint K) (Finset.univ.image p)) :
    CodimThreeMDSColumns (K := K) (fun i => (p i).rep) := by
  classical
  have hdistinct := (arc_image_iff_triples_linearIndependent p hp).mp hArc
  have htriple (T : Finset ι) (hT : T.card = 3) :
      LinearIndependent K (fun i : T => (p i.1).rep) := by
    let e : T ≃ Fin 3 := T.equivFinOfCardEq hT
    have hli : LinearIndependent K
        ![(p (e.symm 0).1).rep, (p (e.symm 1).1).rep, (p (e.symm 2).1).rep] := by
      apply hdistinct
      · intro h
        exact (by decide : (0 : Fin 3) ≠ 1) (e.symm.injective (Subtype.ext h))
      · intro h
        exact (by decide : (0 : Fin 3) ≠ 2) (e.symm.injective (Subtype.ext h))
      · intro h
        exact (by decide : (1 : Fin 3) ≠ 2) (e.symm.injective (Subtype.ext h))
    have hli' : LinearIndependent K (fun n : Fin 3 => (p (e.symm n).1).rep) := by
      convert hli using 1
      funext n
      fin_cases n <;> rfl
    have hcomp := hli'.comp e e.injective
    have hfam : ((fun n : Fin 3 => (p (e.symm n).1).rep) ∘ e) =
        (fun i : T => (p i.1).rep) := by
      funext i
      rw [Function.comp_apply, e.symm_apply_apply]
    rw [hfam] at hcomp
    exact hcomp
  have hsmall : ∀ S : Finset ι, S.card ≤ 3 →
      LinearIndependent K (fun i : S => (p i.1).rep) :=
    small_independent_of_triple_independent (fun i => (p i).rep) hcard htriple
  refine ⟨by simp, ?_, hsmall⟩
  obtain ⟨S, _hSuniv, hScard⟩ := Finset.exists_subset_card_eq
    (s := (Finset.univ : Finset ι)) hcard
  have hSli := hsmall S (by omega)
  let U := Submodule.span K (Set.range fun i : S => (p i.1).rep)
  have hUrank : Module.finrank K U = 3 := by
    have h := finrank_span_eq_card hSli
    simpa [U, hScard] using h
  have hUS : U ≤ Submodule.span K (Set.range fun i : ι => (p i).rep) := by
    apply Submodule.span_mono
    rintro _ ⟨i, rfl⟩
    exact ⟨i.1, rfl⟩
  apply Submodule.eq_top_of_finrank_eq
  have hle := Submodule.finrank_mono hUS
  have htop : Module.finrank K (Fin 3 → K) = 3 := by simp
  have hspanRank : Module.finrank K
      (Submodule.span K (Set.range fun i : ι => (p i).rep)) = 3 := by
    apply le_antisymm
    · simpa [htop] using
        (Submodule.finrank_le (Submodule.span K (Set.range fun i : ι => (p i).rep)))
    · omega
  exact hspanRank.trans htop.symm

section FinitePlane

variable [Fintype K]

noncomputable local instance : Fintype (PlanePoint K) := Fintype.ofFinite _
noncomputable local instance : DecidableEq (PlanePoint K) := Classical.decEq _

/-- The arc-extension bridge really produces MDS parity-check columns after adjoining a deep
projective syndrome direction. -/
theorem oneColumnMDS_of_mem_deepTransform (p : ι → PlanePoint K)
    (hp : Function.Injective p) (hcard : 3 ≤ Fintype.card ι)
    (hArc : Arc (L := PlanePoint K) (Finset.univ.image p)) {x : PlanePoint K}
    (hx : x ∈ deepTransform (L := PlanePoint K) (Finset.univ.image p)) :
    CodimThreeMDSColumns (K := K) (fun i => ((appendPoint p x) i).rep) := by
  have hext := (oneColumnArcExtension_iff_mem_deepTransform hArc).mpr hx
  apply codimThreeMDSColumns_of_arc (appendPoint p x)
  · exact appendPoint_injective p x hp hext.1
  · simp
    omega
  · rw [image_appendPoint]
    exact hext.2

end FinitePlane
end ProjectiveMDS

section RawCoverage

open Certificate Conic ProjectiveBridge Projectivization

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

noncomputable local instance : Fintype (Conic.Point K) := Fintype.ofFinite _
noncomputable local instance : DecidableEq (Conic.Point K) := Classical.decEq _

private theorem gateway_normalized_rep (p : Conic.Point K) :
    (∃ y z : K, ∃ hn : (![1, y, z] : Vec K) ≠ 0,
      Projectivization.mk K ![1, y, z] hn = p) ∨
    (∃ z : K, ∃ hn : (![0, 1, z] : Vec K) ≠ 0,
      Projectivization.mk K ![0, 1, z] hn = p) ∨
    ∃ hn : (![0, 0, 1] : Vec K) ≠ 0,
      Projectivization.mk K ![0, 0, 1] hn = p := by
  by_cases h0 : p.rep 0 = 0
  · by_cases h1 : p.rep 1 = 0
    · right; right
      have h2 : p.rep 2 ≠ 0 := by
        intro h2
        apply p.rep_nonzero
        funext i
        fin_cases i <;> assumption
      have hn : (![0, 0, 1] : Vec K) ≠ 0 := by
        intro h
        have hh := congrFun h 2
        simp at hh
      refine ⟨hn, ?_⟩
      rw [← Projectivization.mk_rep p]
      apply (Projectivization.mk_eq_mk_iff' K _ _ hn p.rep_nonzero).mpr
      refine ⟨(p.rep 2)⁻¹, ?_⟩
      funext i
      fin_cases i <;> simp [h0, h1, h2]
    · right; left
      let z := p.rep 2 / p.rep 1
      have hn : (![0, 1, z] : Vec K) ≠ 0 := by
        intro h
        have hh := congrFun h 1
        simp at hh
      refine ⟨z, hn, ?_⟩
      rw [← Projectivization.mk_rep p]
      apply (Projectivization.mk_eq_mk_iff' K _ _ hn p.rep_nonzero).mpr
      refine ⟨(p.rep 1)⁻¹, ?_⟩
      funext i
      fin_cases i <;> simp [z, h0, h1, div_eq_mul_inv, mul_comm]
  · left
    let y := p.rep 1 / p.rep 0
    let z := p.rep 2 / p.rep 0
    have hn : (![1, y, z] : Vec K) ≠ 0 := by
      intro h
      have hh := congrFun h 0
      simp at hh
    refine ⟨y, z, hn, ?_⟩
    rw [← Projectivization.mk_rep p]
    apply (Projectivization.mk_eq_mk_iff' K _ _ hn p.rep_nonzero).mpr
    refine ⟨(p.rep 0)⁻¹, ?_⟩
    funext i
    fin_cases i <;> simp [y, z, h0, div_eq_mul_inv] <;> ac_rfl

/-- A raw determinant arc plus coverage of every normalized projective representative is an
ordinary complete arc. -/
theorem rawArc_complete_empty {xs : List (RawPoint K)} (hArc : RawArc xs)
    (hcoverage : RawOrdinaryCoverage xs) :
    CompleteOutside (L := Conic.Point K) (pointSet xs) ∅ := by
  classical
  have hSemanticArc : Arc (L := Conic.Point K) (pointSet xs) := by
    rw [ProjectiveBridge.arc_iff_projectiveCap]
    exact rawArc_iff_projectiveCap.mp hArc
  refine ⟨hSemanticArc, by simp, ?_⟩
  intro p hpA _hpEmpty
  obtain ⟨n, hn, hnp, hncover⟩ : ∃ n : Vec K, ∃ hn : n ≠ 0,
      Projectivization.mk K n hn = p ∧ RawOrdinaryCovered xs n := by
    rcases gateway_normalized_rep p with ⟨y, z, hn, hp⟩ | ⟨z, hn, hp⟩ | ⟨hn, hp⟩
    · exact ⟨![1, y, z], hn, hp, hcoverage.1 y z⟩
    · exact ⟨![0, 1, z], hn, hp, hcoverage.2.1 z⟩
    · exact ⟨![0, 0, 1], hn, hp, hcoverage.2.2⟩
  let x : RawPoint K := ⟨n, hn⟩
  rcases hncover with hmember | hsec
  · obtain ⟨a, ha, hxa⟩ := hmember
    exfalso
    apply hpA
    apply mem_pointSet.mpr
    refine ⟨a, ha, ?_⟩
    exact ((rayEq_iff_mk_eq x a).mp ((rayEq_eq_true_iff _ _).mp hxa)).symm.trans hnp
  · obtain ⟨a, ha, b, hb, hab, hdet⟩ := hsec
    have habp : toPoint a ≠ toPoint b := fun heq => by
      have ht := (rayEq_eq_true_iff _ _).mpr ((rayEq_iff_mk_eq a b).mpr heq)
      rw [hab] at ht
      contradiction
    apply covered_of_collinear_pair (L := Conic.Point K)
      (mem_pointSet.mpr ⟨a, ha, rfl⟩) (mem_pointSet.mpr ⟨b, hb, rfl⟩) habp
    rw [ProjectiveBridge.collinear_iff_projective_collinear, ← hnp]
    exact (ProjectiveCap.Projective.FrameGridBridge.Coordinate.mk_collinear_iff_det_eq_zero
      x.2 a.2 b.2).mpr hdet

end RawCoverage

section DecoratedTransform

/-- A transform equipped with the hypothesis that its child and decoration jointly determine the
parent.  The `faithful` field is an assumption about a concrete transform, not a consequence of
bundling its three underlying maps. -/
structure DecoratedTransform (Parent Child Decoration : Type*) where
  child : Parent → Child
  decoration : Parent → Decoration
  faithful : Function.Injective fun p => (child p, decoration p)

/-- The faithfulness assumption restated as an equivalence: two parents agree exactly when their
children and decorations agree.  This is the form used when recovering a parent object from its
transform together with the recorded decoration. -/
theorem DecoratedTransform.recovers_parent
    {Parent Child Decoration : Type*} (T : DecoratedTransform Parent Child Decoration)
    {p q : Parent} :
    (T.child p, T.decoration p) = (T.child q, T.decoration q) ↔ p = q := by
  constructor
  · intro h
    exact T.faithful h
  · intro h
    subst q
    rfl

end DecoratedTransform

section QuotientCharacter

/-- `Perm (Fin 2)` has only the identity and the transposition. -/
theorem perm_fin_two_eq_one_or_swap (σ : Equiv.Perm (Fin 2)) :
    σ = 1 ∨ σ = Equiv.swap 0 1 := by
  have fin_two_cases (i : Fin 2) : i = 0 ∨ i = 1 := by omega
  rcases fin_two_cases (σ 0) with h0 | h0 <;>
    rcases fin_two_cases (σ 1) with h1 | h1
  · exfalso
    exact (by decide : (0 : Fin 2) ≠ 1) (σ.injective (h0.trans h1.symm))
  · left
    ext i
    fin_cases i <;> simp [h0, h1]
  · right
    ext i
    fin_cases i <;> simp [h0, h1]
  · exfalso
    exact (by decide : (0 : Fin 2) ≠ 1) (σ.injective (h0.trans h1.symm))

/-- Any two nonidentity permutations of a two-element set are equal. -/
theorem perm_fin_two_eq_of_ne_one {σ τ : Equiv.Perm (Fin 2)}
    (hσ : σ ≠ 1) (hτ : τ ≠ 1) : σ = τ := by
  rcases perm_fin_two_eq_one_or_swap σ with h | h
  · exact (hσ h).elim
  · rcases perm_fin_two_eq_one_or_swap τ with h' | h'
    · exact (hτ h').elim
    · exact h.trans h'.symm

/-- A two-sheet character is determined by its kernel.  This is the abstract inference used to
identify blowdown exchange with code-chirality exchange without naming either sheet. -/
theorem twoSheetCharacter_eq_of_ker_eq {G : Type*} [Group G]
    (χ₁ χ₂ : G →* Equiv.Perm (Fin 2)) (hker : χ₁.ker = χ₂.ker) : χ₁ = χ₂ := by
  apply MonoidHom.ext
  intro g
  have hk : χ₁ g = 1 ↔ χ₂ g = 1 := by
    change g ∈ χ₁.ker ↔ g ∈ χ₂.ker
    rw [hker]
  by_cases h₁ : χ₁ g = 1
  · exact h₁.trans (hk.mp h₁).symm
  · have h₂ : χ₂ g ≠ 1 := fun h => h₁ (hk.mpr h)
    exact perm_fin_two_eq_of_ne_one h₁ h₂

/-- If two actions of `S5` on a two-element set are trivial exactly on the even permutations, then
their permutation characters agree.  This theorem is conditional: it does not construct either
action or prove the two kernel hypotheses for a geometric example. -/
theorem s5_quotientCharacter_inference
    (blowdown codeChirality : Equiv.Perm (Fin 5) →* Equiv.Perm (Fin 2))
    (hblowdown : ∀ g, blowdown g = 1 ↔ Equiv.Perm.sign g = 1)
    (hcode : ∀ g, codeChirality g = 1 ↔ Equiv.Perm.sign g = 1) :
    blowdown = codeChirality := by
  apply twoSheetCharacter_eq_of_ker_eq
  apply Subgroup.ext
  intro g
  change blowdown g = 1 ↔ codeChirality g = 1
  exact (hblowdown g).trans (hcode g).symm

end QuotientCharacter

section OrbitFusion

/-- A complete color classification of the orbits of a group action. -/
structure OrbitClassifier (G X Color : Type*) [Group G] [MulAction G X] where
  color : X → Color
  color_eq_iff_orbit : ∀ x y, color x = color y ↔ y ∈ MulAction.orbit G x

/-- If equality of fused colors is equivalent to membership in an `H`-orbit for every pair of
points, then the fused color is an orbit classifier for the `H`-action.  The orbit equivalence is
an explicit hypothesis; this constructor does not verify a concrete finite group closure. -/
def OrbitClassifier.fuse {G H X Fine Coarse : Type*}
    [Group G] [Group H] [MulAction G X] [MulAction H X]
    (fine : OrbitClassifier G X Fine) (fusion : Fine → Coarse)
    (hfusion : ∀ x y,
      fusion (fine.color x) = fusion (fine.color y) ↔ y ∈ MulAction.orbit H x) :
    OrbitClassifier H X Coarse where
  color := fusion ∘ fine.color
  color_eq_iff_orbit := by simpa [Function.comp_apply] using hfusion

end OrbitFusion

#print axioms oneColumnArcExtension_iff_mem_deepTransform
#print axioms oneColumnMDS_of_mem_deepTransform
#print axioms rawArc_complete_empty
#print axioms DecoratedTransform.recovers_parent
#print axioms s5_quotientCharacter_inference
#print axioms OrbitClassifier.fuse

end ClebschGateway
end RelativeConicArcs
