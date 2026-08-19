import Mathlib.Algebra.MvPolynomial.Variables

/-!
# Forms that split into separated groups of variables

A polynomial in finitely many variables is *separated with block bound `b`*
when the variables can be partitioned into groups of at most `b` of them and
the polynomial written as a sum of polynomials, one per group, each involving
only the variables of its own group.  This is the shape of hypersurface
equation to which Colliot-Thélène's universal zero-cycle triviality criterion
applies: Jean-Louis Colliot-Thélène, *CH₀-trivialité universelle
d'hypersurfaces cubiques presque diagonales*, Algebraic Geometry 4 (2017),
597--602, arXiv:1607.05673v3, Théorème 2.8, which states that a smooth cubic
hypersurface of dimension at least two over the complex numbers whose equation
is a sum of forms in separated variables, each involving at most three of them,
is universally `CH₀`-trivial.

This module fixes the combinatorial notion and proves that the Fermat form
`∑ Xᵢ³` in any number of variables is separated with block bound one: the
partition into singletons works, and each summand is a power of a single
variable.  Since the bound is monotone, the Fermat cubic in five variables is
separated with block bound three, which is the hypothesis of the cited
criterion.

Nothing about hypersurfaces, smoothness, Chow groups, or the criterion itself
is constructed here: this module is about polynomials only.  All proofs are
symbolic and kernel checked, with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Applications

open scoped BigOperators

/-- A presentation of `form` as a sum of polynomials in pairwise disjoint
groups of at most `blockBound` variables.  The groups are indexed by
`Fin groupCount`, the variable `j` belongs to the group `group j`, and the
summand `part i` involves no variable outside the group `i`. -/
structure SeparatedVariableDecomposition {R : Type*} [CommSemiring R] {n : ℕ}
    (blockBound : ℕ) (form : MvPolynomial (Fin n) R) where
  /-- The number of groups the variables are partitioned into. -/
  groupCount : ℕ
  /-- The group a variable belongs to. -/
  group : Fin n → Fin groupCount
  /-- The summand attached to a group. -/
  part : Fin groupCount → MvPolynomial (Fin n) R
  /-- No group contains more than `blockBound` variables. -/
  groupCard : ∀ index, (Finset.univ.filter fun coordinate => group coordinate = index).card ≤
    blockBound
  /-- A summand involves only the variables of its own group. -/
  partVars : ∀ index, (part index).vars ⊆ Finset.univ.filter fun coordinate =>
    group coordinate = index
  /-- The summands add up to the given form. -/
  isSum : form = ∑ index, part index

/-- The polynomial `form` splits into separated groups of at most `blockBound`
variables. -/
def HasSeparatedVariableDecomposition {R : Type*} [CommSemiring R] {n : ℕ}
    (blockBound : ℕ) (form : MvPolynomial (Fin n) R) : Prop :=
  Nonempty (SeparatedVariableDecomposition blockBound form)

/-- Raising the permitted group size preserves separatedness. -/
theorem HasSeparatedVariableDecomposition.mono {R : Type*} [CommSemiring R] {n : ℕ}
    {smallBound largeBound : ℕ} {form : MvPolynomial (Fin n) R}
    (separated : HasSeparatedVariableDecomposition smallBound form)
    (bound : smallBound ≤ largeBound) :
    HasSeparatedVariableDecomposition largeBound form := by
  obtain ⟨decomposition⟩ := separated
  exact ⟨{ decomposition with
    groupCard := fun index => (decomposition.groupCard index).trans bound }⟩

/-- The Fermat form in `n` variables, the sum of the cubes of the variables. -/
noncomputable def fermatCubicForm (R : Type*) [CommSemiring R] (n : ℕ) :
    MvPolynomial (Fin n) R :=
  ∑ index, MvPolynomial.X index ^ 3

/-- The Fermat form is a sum of forms in separated single variables: taking the
partition of the variables into singletons, the summand attached to a variable
is its cube, which involves that variable only. -/
theorem fermatCubicForm_separatedVariable_singletons (R : Type*) [CommSemiring R]
    [Nontrivial R] (n : ℕ) :
    HasSeparatedVariableDecomposition 1 (fermatCubicForm R n) :=
  ⟨{ groupCount := n
     group := id
     part := fun index => MvPolynomial.X index ^ 3
     groupCard := fun index => by
       classical
       have singleton : (Finset.univ.filter fun coordinate : Fin n => id coordinate = index) =
           {index} := by
         ext coordinate
         simp
       rw [singleton, Finset.card_singleton]
     partVars := fun index => by
       classical
       refine (MvPolynomial.vars_pow _ 3).trans ?_
       rw [MvPolynomial.vars_X]
       intro coordinate member
       simp only [Finset.mem_singleton] at member
       simp [member]
     isSum := rfl }⟩

/-- The Fermat cubic form in five variables is a sum of cubic forms in pairwise
disjoint groups of at most three variables, the hypothesis of the
almost-diagonal universal zero-cycle triviality criterion. -/
theorem fermatCubicForm_separatedVariable_five (R : Type*) [CommSemiring R] [Nontrivial R] :
    HasSeparatedVariableDecomposition 3 (fermatCubicForm R 5) :=
  (fermatCubicForm_separatedVariable_singletons R 5).mono (by norm_num)

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
