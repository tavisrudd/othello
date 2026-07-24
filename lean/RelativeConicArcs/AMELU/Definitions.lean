import FiniteGeom.Code
import Mathlib.Algebra.Group.AddChar
import Mathlib.Analysis.Complex.Exponential
import Mathlib.Analysis.Real.Sqrt
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.FieldTheory.Finite.Trace
import Mathlib.LinearAlgebra.Matrix.ConjTranspose
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

/-!
# Six-party code states and their local actions

This module fixes the conventions used to compare ordered six-arcs, linear
`[6,3,4]` codes, equal-phase six-party states, and local changes of basis.
The local alphabet is a finite field `𝔽`, a computational-basis label is a
function `Fin 6 → 𝔽`, and a state is its complex amplitude function.

An ordered six-arc is represented by six nonzero columns in `𝔽³`; every
three distinct columns must be linearly independent.  Its parity-check
kernel consists of the vectors annihilated by the resulting `3 × 6`
matrix.  The equal-phase state of a code `C` has amplitude
`sqrt(|𝔽|³)⁻¹` on `C` and zero elsewhere.

Party permutations act on labels on the left:
`(π • x) i = x (π⁻¹ i)`.  A local matrix `U i` uses the convention that
`U i y x` is the coefficient from input basis vector `x` to output basis
vector `y`.  The finite-field Weyl matrix is
`W(a,b) = X(a)Z(b)`, so its nonzero entry from `x` to `x+a` is `χ(bx)`.
These choices determine the direction of every projective, monomial,
local-unitary, and local-Clifford action below.

All definitions are ordinary kernel-checked Lean definitions.  This module
uses no generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open scoped BigOperators ComplexConjugate
open Matrix

abbrev Party := Fin 6
abbrev PlaneCoordinate := Fin 3

/-- A six-party computational-basis label over `𝔽`. -/
abbrev BasisLabel (𝔽 : Type*) := Party → 𝔽

/-- A pure six-party state, represented by its computational-basis amplitudes. -/
abbrev State (𝔽 : Type*) := BasisLabel 𝔽 → ℂ

/-- The `3 × 6` matrix whose column at party `i` is `P i`. -/
def parityCheckMatrix (P : Party → PlaneCoordinate → 𝔽) :
    Matrix PlaneCoordinate Party 𝔽 :=
  fun r i => P i r

/-- The three selected representatives, written as the rows of a `3 × 3` matrix.
The determinant is unchanged up to transpose from the column convention. -/
def selectedTripleMatrix (P : Party → PlaneCoordinate → 𝔽) (i j k : Party) :
    Matrix PlaneCoordinate PlaneCoordinate 𝔽 :=
  ![P i, P j, P k]

/-- Six nonzero projective representatives form an ordered six-arc when every
three representatives with distinct indices are linearly independent. -/
def IsSixArc [CommRing 𝔽] (P : Party → PlaneCoordinate → 𝔽) : Prop :=
  (∀ i, P i ≠ 0) ∧
    ∀ i j k, i ≠ j → i ≠ k → j ≠ k →
      (selectedTripleMatrix P i j k).det ≠ 0

/-- The parity-check kernel attached to six projective representatives. -/
def arcKernel [Field 𝔽] (P : Party → PlaneCoordinate → 𝔽) :
    Submodule 𝔽 (BasisLabel 𝔽) :=
  LinearMap.ker (parityCheckMatrix P).mulVecLin

@[simp]
theorem mem_arcKernel [Field 𝔽] {P : Party → PlaneCoordinate → 𝔽}
    {x : BasisLabel 𝔽} :
    x ∈ arcKernel P ↔ parityCheckMatrix P *ᵥ x = 0 := by
  simp [arcKernel]

/-- The exact `[6,3,4]` convention: dimension three and minimum Hamming
distance four.  The length is fixed by the coordinate type `Fin 6`. -/
def IsMDSCode634 [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    (C : Submodule 𝔽 (BasisLabel 𝔽)) : Prop :=
  Module.finrank 𝔽 C = 3 ∧ FiniteGeom.minDist C = 4

/-- The exact-parameter convention implies the shared coding layer's
Singleton-equality definition of an MDS code. -/
theorem isMDS_of_isMDSCode634 [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (h : IsMDSCode634 C) :
    FiniteGeom.IsMDS C := by
  simp [FiniteGeom.IsMDS, h.1, h.2]

/-- A six-arc together with the assertion that its parity-check kernel has
the manuscript's `[6,3,4]` parameters. -/
structure SixArcMDSKernel (𝔽 : Type*) [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽] where
  /-- The ordered nonzero column representatives. -/
  points : Party → PlaneCoordinate → 𝔽
  /-- No three represented projective points are collinear. -/
  isSixArc : IsSixArc points
  /-- The parity-check kernel has dimension three and distance four. -/
  kernel_isMDSCode634 : IsMDSCode634 (arcKernel points)

/-- The positive real normalization `|𝔽|^{-3/2}`, embedded in `ℂ`. -/
noncomputable def codeStateNormalization (𝔽 : Type*) [Fintype 𝔽] : ℂ :=
  ((Real.sqrt ((Fintype.card 𝔽 : ℝ) ^ 3))⁻¹ : ℝ)

/-- The normalized equal-phase state
`|𝔽|^{-3/2} ∑_{c ∈ C} |c⟩` of a length-six code. -/
noncomputable def equalPhaseState [Fintype 𝔽] [DecidableEq 𝔽] [Field 𝔽]
    (C : Submodule 𝔽 (BasisLabel 𝔽)) : State 𝔽 :=
  by
    classical
    exact fun x => if x ∈ C then codeStateNormalization 𝔽 else 0

@[simp]
theorem equalPhaseState_apply_of_mem [Fintype 𝔽] [DecidableEq 𝔽] [Field 𝔽]
    {C : Submodule 𝔽 (BasisLabel 𝔽)} {x : BasisLabel 𝔽} (hx : x ∈ C) :
    equalPhaseState C x = codeStateNormalization 𝔽 := by
  classical
  simp [equalPhaseState, hx]

@[simp]
theorem equalPhaseState_apply_of_not_mem [Fintype 𝔽] [DecidableEq 𝔽] [Field 𝔽]
    {C : Submodule 𝔽 (BasisLabel 𝔽)} {x : BasisLabel 𝔽} (hx : x ∉ C) :
    equalPhaseState C x = 0 := by
  classical
  simp [equalPhaseState, hx]

/-- Assemble subsystem coordinates `x` and complementary coordinates `e`
into one six-party computational-basis label. -/
def assembleLabel (S : Finset Party) (x : (i : S) → 𝔽)
    (e : (i : {i : Party // i ∉ S}) → 𝔽) : BasisLabel 𝔽 :=
  fun i => if h : i ∈ S then x ⟨i, h⟩ else e ⟨i, h⟩

@[simp]
theorem assembleLabel_apply_mem (S : Finset Party) (x : (i : S) → 𝔽)
    (e : (i : {i : Party // i ∉ S}) → 𝔽) (i : Party) (hi : i ∈ S) :
    assembleLabel S x e i = x ⟨i, hi⟩ := by
  simp [assembleLabel, hi]

@[simp]
theorem assembleLabel_apply_not_mem (S : Finset Party) (x : (i : S) → 𝔽)
    (e : (i : {i : Party // i ∉ S}) → 𝔽) (i : Party) (hi : i ∉ S) :
    assembleLabel S x e i = e ⟨i, hi⟩ := by
  simp [assembleLabel, hi]

/-- A matrix entry of the reduced density operator on the parties in `S`.
The environment is summed in the computational basis. -/
noncomputable def marginalEntry [Fintype 𝔽] (ψ : State 𝔽) (S : Finset Party)
    (x y : (i : S) → 𝔽) : ℂ :=
  ∑ e : (i : {i : Party // i ∉ S}) → 𝔽,
    ψ (assembleLabel S x e) * conj (ψ (assembleLabel S y e))

/-- A state has unit norm in the computational basis. -/
def IsNormalized [Fintype 𝔽] (ψ : State 𝔽) : Prop :=
  ∑ x, Complex.normSq (ψ x) = 1

/-- The six-party absolutely-maximally-entangled condition: the state is
normalized and every reduction on at most three parties is the normalized
identity. -/
def IsAME [Fintype 𝔽] [DecidableEq 𝔽] (ψ : State 𝔽) : Prop :=
  IsNormalized ψ ∧
    ∀ (S : Finset Party), S.card ≤ 3 →
      ∀ x y : (i : S) → 𝔽,
        marginalEntry ψ S x y =
          if x = y then (((Fintype.card 𝔽 : ℝ) ^ S.card)⁻¹ : ℝ) else 0

/-- Left action of a party permutation on a basis label:
`(π • x) i = x (π⁻¹ i)`. -/
def permuteLabel (π : Equiv.Perm Party) (x : BasisLabel 𝔽) : BasisLabel 𝔽 :=
  fun i => x (π.symm i)

/-- Action induced by a party permutation on state amplitudes. -/
def permuteState (π : Equiv.Perm Party) (ψ : State 𝔽) : State 𝔽 :=
  fun x => ψ (permuteLabel π.symm x)

@[simp]
theorem permuteLabel_apply (π : Equiv.Perm Party) (x : BasisLabel 𝔽) (i : Party) :
    permuteLabel π x i = x (π.symm i) :=
  rfl

@[simp]
theorem permuteState_apply (π : Equiv.Perm Party) (ψ : State 𝔽) (x : BasisLabel 𝔽) :
    permuteState π ψ x = ψ (fun i => x (π i)) :=
  rfl

/-- The label convention is a left action: applying `π` and then `σ`
agrees with the composite permutation `π.trans σ`. -/
theorem permuteLabel_trans (π σ : Equiv.Perm Party) (x : BasisLabel 𝔽) :
    permuteLabel (π.trans σ) x = permuteLabel σ (permuteLabel π x) := by
  rfl

/-- The induced state permutations obey the same composition order as the
party permutations. -/
theorem permuteState_trans (π σ : Equiv.Perm Party) (ψ : State 𝔽) :
    permuteState (π.trans σ) ψ = permuteState σ (permuteState π ψ) := by
  rfl

/-- A column multiplier followed by a party permutation on codewords. -/
def monomialLabel [Monoid 𝔽] (π : Equiv.Perm Party) (u : Party → 𝔽ˣ)
    (x : BasisLabel 𝔽) : BasisLabel 𝔽 :=
  fun i => (u i : 𝔽) * x (π.symm i)

@[simp]
theorem monomialLabel_apply [Monoid 𝔽] (π : Equiv.Perm Party) (u : Party → 𝔽ˣ)
    (x : BasisLabel 𝔽) (i : Party) :
    monomialLabel π u x i = (u i : 𝔽) * x (π.symm i) :=
  rfl

/-- Two length-six codes are monomially equivalent when one is exactly the
image of the other under the displayed multiplier-permutation convention. -/
def MonomiallyEquivalent [Field 𝔽] (C D : Submodule 𝔽 (BasisLabel 𝔽)) : Prop :=
  ∃ (π : Equiv.Perm Party) (u : Party → 𝔽ˣ),
    ∀ x, x ∈ D ↔ ∃ c ∈ C, monomialLabel π u c = x

/-- Two ordered representative systems are projectively equivalent when a
linear coordinate change, a party permutation, and independent nonzero
column scalars carry the first system to the second. -/
def ProjectivelyEquivalent [Field 𝔽]
    (P Q : Party → PlaneCoordinate → 𝔽) : Prop :=
  ∃ (g : (PlaneCoordinate → 𝔽) ≃ₗ[𝔽] (PlaneCoordinate → 𝔽))
      (π : Equiv.Perm Party) (u : Party → 𝔽ˣ),
    ∀ i, Q i = (u i : 𝔽) • g (P (π.symm i))

/-- A single-party matrix uses row=output, column=input indexing. -/
abbrev LocalMatrix (𝔽 : Type*) := Matrix 𝔽 𝔽 ℂ

/-- Column-orthonormality for a finite square complex matrix. -/
def IsUnitaryMatrix [Fintype 𝔽] [DecidableEq 𝔽] (U : LocalMatrix 𝔽) : Prop :=
  ∀ x y, (∑ z, conj (U z x) * U z y) = if x = y then 1 else 0

/-- Tensor-product action of six single-party matrices on a state. -/
noncomputable def localAction [Fintype 𝔽] (U : Party → LocalMatrix 𝔽)
    (ψ : State 𝔽) : State 𝔽 :=
  fun y => ∑ x, (∏ i, U i (y i) (x i)) * ψ x

/-- Local-unitary equivalence, allowing the manuscript's party permutation
and one physically irrelevant global phase. -/
def LocallyUnitaryEquivalent [Fintype 𝔽] [DecidableEq 𝔽]
    (ψ φ : State 𝔽) : Prop :=
  ∃ (π : Equiv.Perm Party) (U : Party → LocalMatrix 𝔽) (phase : ℂ),
    (∀ i, IsUnitaryMatrix (U i)) ∧
      Complex.normSq phase = 1 ∧
      localAction U (permuteState π ψ) = phase • φ

/-- A nontrivial additive character used in the finite-field Weyl system.
The character is an explicit parameter so the interface also covers
non-prime finite fields without hiding a choice of trace or primitive root. -/
structure WeylConvention (𝔽 : Type*) [AddCommGroup 𝔽] where
  /-- The additive character `χ`. -/
  character : AddChar 𝔽 ℂ
  /-- The character is not identically one. -/
  character_nontrivial : character ≠ 1

/-- The manuscript's scalar phase
`exp(2πi Tr(a)/p)`, where `p` is the characteristic and the field trace
takes values in `ZMod p`.  The representative in `[0,p)` is used only to
embed that residue in `ℂ`; changing it by `p` leaves the exponential fixed. -/
noncomputable def tracePhase [Field 𝔽] [Fintype 𝔽]
    [Algebra (ZMod (ringChar 𝔽)) 𝔽] (a : 𝔽) : ℂ :=
  Complex.exp
    (2 * Real.pi * Complex.I *
      ((Algebra.trace (ZMod (ringChar 𝔽)) 𝔽 a).val : ℂ) / (ringChar 𝔽 : ℂ))

/-- A Weyl convention uses exactly the finite-field trace character fixed in
the manuscript, rather than an unspecified nontrivial additive character. -/
def UsesTracePhase [Field 𝔽] [Fintype 𝔽]
    [Algebra (ZMod (ringChar 𝔽)) 𝔽] (w : WeylConvention 𝔽) : Prop :=
  ∀ a, w.character a = tracePhase a

/-- The finite-field Weyl matrix `W(a,b)=X(a)Z(b)`.  Its entry from input
`x` to output `y` is `χ(bx)` when `y=x+a`, and zero otherwise. -/
def weylMatrix [Field 𝔽] [DecidableEq 𝔽] (w : WeylConvention 𝔽) (a b : 𝔽) :
    LocalMatrix 𝔽 :=
  fun y x => if y = x + a then w.character (b * x) else 0

@[simp]
theorem weylMatrix_apply [Field 𝔽] [DecidableEq 𝔽] (w : WeylConvention 𝔽)
    (a b x y : 𝔽) :
    weylMatrix w a b y x = if y = x + a then w.character (b * x) else 0 :=
  rfl

@[simp]
theorem weylMatrix_zero_zero [Field 𝔽] [DecidableEq 𝔽] (w : WeylConvention 𝔽) :
    weylMatrix w 0 0 = 1 := by
  ext y x
  rw [Matrix.one_apply]
  simp [weylMatrix]

/-- Equality of nonzero matrix axes: `A` is a nonzero scalar multiple of `B`. -/
def SameMatrixAxis (A B : LocalMatrix 𝔽) : Prop :=
  ∃ z : ℂ, z ≠ 0 ∧ A = z • B

/-- Matrix multiplication in the row=output, column=input convention. -/
noncomputable def matrixProduct [Fintype 𝔽] (A B : LocalMatrix 𝔽) :
    LocalMatrix 𝔽 :=
  A * B

/-- A unitary is Clifford for `w` when conjugation sends every Weyl axis
to a Weyl axis.  The identity label is included; no choice of conjugation
phase is built into the definition. -/
def IsCliffordMatrix [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    (w : WeylConvention 𝔽) (U : LocalMatrix 𝔽) : Prop :=
  IsUnitaryMatrix U ∧
    ∀ a b, ∃ a' b',
      SameMatrixAxis (matrixProduct (matrixProduct U (weylMatrix w a b)) U.conjTranspose)
        (weylMatrix w a' b')

/-- Local-Clifford equivalence uses the same party-action and global-phase
conventions as `LocallyUnitaryEquivalent`. -/
def LocallyCliffordEquivalent [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    (w : WeylConvention 𝔽) (ψ φ : State 𝔽) : Prop :=
  ∃ (π : Equiv.Perm Party) (U : Party → LocalMatrix 𝔽) (phase : ℂ),
    (∀ i, IsCliffordMatrix w (U i)) ∧
      Complex.normSq phase = 1 ∧
      localAction U (permuteState π ψ) = phase • φ

/-- The convention dictionary exposed to later theorem packages: one
six-arc/MDS kernel together with its equal-phase state and Weyl choice. -/
structure ConventionDictionary (𝔽 : Type*) [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    [Algebra (ZMod (ringChar 𝔽)) 𝔽] where
  /-- The geometric and coding data. -/
  arcCode : SixArcMDSKernel 𝔽
  /-- The finite-field additive-character convention for Weyl matrices. -/
  weyl : WeylConvention 𝔽
  /-- The additive character is the trace phase `exp(2πi Tr(a)/p)`. -/
  weyl_usesTracePhase : UsesTracePhase weyl

namespace ConventionDictionary

/-- The `[6,3,4]` kernel selected by a convention dictionary. -/
def code [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    [Algebra (ZMod (ringChar 𝔽)) 𝔽]
    (d : ConventionDictionary 𝔽) : Submodule 𝔽 (BasisLabel 𝔽) :=
  arcKernel d.arcCode.points

/-- The equal-phase CSS state selected by a convention dictionary. -/
noncomputable def state [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    [Algebra (ZMod (ringChar 𝔽)) 𝔽]
    (d : ConventionDictionary 𝔽) : State 𝔽 :=
  equalPhaseState d.code

end ConventionDictionary

@[simp]
theorem permuteLabel_refl (x : BasisLabel 𝔽) :
    permuteLabel (Equiv.refl Party) x = x := by
  rfl

@[simp]
theorem permuteState_refl (ψ : State 𝔽) :
    permuteState (Equiv.refl Party) ψ = ψ := by
  rfl

theorem locallyCliffordEquivalent_implies_locallyUnitaryEquivalent
    [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    (w : WeylConvention 𝔽) {ψ φ : State 𝔽}
    (h : LocallyCliffordEquivalent w ψ φ) :
    LocallyUnitaryEquivalent ψ φ := by
  obtain ⟨π, U, phase, hU, hphase, hstate⟩ := h
  exact ⟨π, U, phase, fun i => (hU i).1, hphase, hstate⟩

end RelativeConicArcs.AMELU
