import RelativeConicArcs.PRSResidualQuadratic

/-!
# Projective Reed--Solomon syndrome interfaces

This module supplies common logical interfaces for projective Reed--Solomon syndrome
classifications.  It separates four assertions that require different mathematical inputs:

* a Hankel kernel contains no split squarefree polynomial;
* the corresponding projective syndrome is split-free;
* a covering-radius statement promotes split-freeness to coding-theoretic deepness;
* geometric component and rational-point arguments construct a split squarefree kernel member.

The syndrome and polynomial types are abstract.  Concrete degrees may use coefficient vectors,
binary forms, or projective quotient types without changing the synthesis lemmas.  Divided-power
marker contraction is the definition
`RelativeConicArcs.PRSResidualQuadratic.dividedPowerContraction`; no second contraction
hierarchy is introduced here.

All geometric, rational-point, covering-radius, and orbit-exhaustion assertions are structure
fields.  The terminal theorems only combine these visible hypotheses.
-/

namespace RelativeConicArcs.PRSFoundation

/-- A syndrome has a split squarefree kernel member when some polynomial satisfies both the
specified Hankel-kernel relation and the specified split-squarefree predicate. -/
def HasSplitSquarefreeKernelMember {S P : Type*}
    (inHankelKernel : S → P → Prop) (isSplitSquarefree : P → Prop) (s : S) : Prop :=
  ∃ p, inHankelKernel s p ∧ isSplitSquarefree p

/-- Exact dictionary between split-free syndromes and split squarefree members of their Hankel
kernels.  The predicates deliberately do not mention coding-theoretic covering radius. -/
structure HankelKernelDictionary (S P : Type*) where
  /-- The Hankel-kernel incidence relation between syndromes and polynomials. -/
  inHankelKernel : S → P → Prop
  /-- The predicate that a polynomial splits into distinct factors over the base field. -/
  isSplitSquarefree : P → Prop
  /-- The projective syndrome predicate detected by the absence of such a kernel member. -/
  isSplitFree : S → Prop
  /-- Split-freeness is exactly nonexistence of a split squarefree kernel member. -/
  splitFree_iff_no_kernel_member :
    ∀ s, isSplitFree s ↔
      ¬ HasSplitSquarefreeKernelMember inHankelKernel isSplitSquarefree s

namespace HankelKernelDictionary

/-- A split squarefree Hankel-kernel member contradicts split-freeness. -/
theorem not_splitFree_of_kernel_member {S P : Type*}
    (dictionary : HankelKernelDictionary S P) {s : S} {p : P}
    (hkernel : dictionary.inHankelKernel s p)
    (hsplit : dictionary.isSplitSquarefree p) :
    ¬ dictionary.isSplitFree s := by
  intro hfree
  exact (dictionary.splitFree_iff_no_kernel_member s).1 hfree ⟨p, hkernel, hsplit⟩

/-- Constructively, failure of split-freeness is equivalent to double negation of kernel-member
existence.  Removing the double negation requires an additional decidability or classical-logic
input. -/
theorem not_splitFree_iff_not_not_has_kernel_member {S P : Type*}
    (dictionary : HankelKernelDictionary S P) (s : S) :
    ¬ dictionary.isSplitFree s ↔
      ¬¬ HasSplitSquarefreeKernelMember dictionary.inHankelKernel
        dictionary.isSplitSquarefree s := by
  rw [dictionary.splitFree_iff_no_kernel_member]

/-- Failure of split-freeness is equivalent to existence of a split squarefree Hankel-kernel
member. -/
theorem not_splitFree_iff_has_kernel_member {S P : Type*}
    (dictionary : HankelKernelDictionary S P) (s : S) :
    ¬ dictionary.isSplitFree s ↔
      HasSplitSquarefreeKernelMember dictionary.inHankelKernel
        dictionary.isSplitSquarefree s := by
  rw [dictionary.splitFree_iff_no_kernel_member]
  classical
  tauto

end HankelKernelDictionary

/-- Covering-radius input that relates the split-free syndrome predicate to the
coding-theoretic deep-syndrome predicate.  The forward implication is structural; the reverse
implication is required only on the explicitly stated radius range. -/
structure CoveringRadiusInput (S : Type*) where
  /-- Projective syndromes whose Hankel kernels have no split squarefree member. -/
  isSplitFree : S → Prop
  /-- Coding-theoretic deepest-syndrome predicate. -/
  isDeep : S → Prop
  /-- The field-length-radius condition under which split-free syndromes are deepest. -/
  radiusRange : Prop
  /-- A deepest syndrome is split-free independently of the radius-promotion theorem. -/
  deep_implies_splitFree : ∀ {s}, isDeep s → isSplitFree s
  /-- In the declared radius range, split-freeness promotes to coding-theoretic deepness. -/
  splitFree_implies_deep : radiusRange → ∀ {s}, isSplitFree s → isDeep s

namespace CoveringRadiusInput

/-- On the stated covering-radius range, coding-theoretic deepness is exactly split-freeness. -/
theorem deep_iff_splitFree {S : Type*} (input : CoveringRadiusInput S)
    (hradius : input.radiusRange) (s : S) :
    input.isDeep s ↔ input.isSplitFree s :=
  ⟨input.deep_implies_splitFree, input.splitFree_implies_deep hradius⟩

end CoveringRadiusInput

/-- Predicate-level geometric witness construction.  This is the common interface when a
degree-specific development has already packaged “there exists a split squarefree Hankel-kernel
member” as one proposition. -/
structure WitnessConstructionInput (S : Type*) (q threshold : ℕ) where
  /-- Syndromes to which the transverse construction is applied. -/
  exceptional : S → Prop
  /-- The component or slice assertion required by the construction. -/
  componentCondition : S → Prop
  /-- Existence of a rational point outside all declared deletion divisors. -/
  rationalPointOutsideDeletedDivisors : q ≥ threshold → S → Prop
  /-- Existence of a split squarefree polynomial in the syndrome's Hankel kernel. -/
  hasKernelMember : S → Prop
  /-- A suitable component and undeleted rational point supply the kernel member. -/
  pointGivesKernelMember :
    ∀ (hq : q ≥ threshold) {s}, exceptional s →
      componentCondition s →
      rationalPointOutsideDeletedDivisors hq s →
      hasKernelMember s

namespace WitnessConstructionInput

/-- Component and rational-point inputs produce the packaged kernel-member witness for every
exceptional syndrome. -/
theorem exceptional_has_kernel_member {S : Type*} {q threshold : ℕ}
    (input : WitnessConstructionInput S q threshold) (hq : q ≥ threshold)
    (hcomponent : ∀ s, input.exceptional s → input.componentCondition s)
    (hpoint : ∀ s (_hs : input.exceptional s),
      input.rationalPointOutsideDeletedDivisors hq s) :
    ∀ s, input.exceptional s → input.hasKernelMember s := by
  intro s hs
  exact input.pointGivesKernelMember hq hs (hcomponent s hs) (hpoint s hs)

end WitnessConstructionInput

/-- Explicit geometric inputs for constructing a split squarefree Hankel-kernel member outside a
distinguished locus.  The threshold, component assertion, rational-point assertion, and
point-to-witness bridge remain separate fields. -/
structure GeometricWitnessInput (S P : Type*) (q threshold : ℕ) where
  /-- Syndromes to which the transverse geometric construction is applied. -/
  exceptional : S → Prop
  /-- The required geometrically suitable component exists for the syndrome. -/
  componentCondition : S → Prop
  /-- A rational point remains after all determinant, branch, diagonal, and collision deletions. -/
  rationalPointOutsideDeletedDivisors : q ≥ threshold → S → Prop
  /-- Hankel-kernel incidence for the constructed polynomial. -/
  inHankelKernel : S → P → Prop
  /-- Split-squarefree predicate for the constructed polynomial. -/
  isSplitSquarefree : P → Prop
  /-- The geometric point supplies a polynomial with both required properties. -/
  pointGivesKernelMember :
    ∀ (hq : q ≥ threshold) {s}, exceptional s →
      componentCondition s →
      rationalPointOutsideDeletedDivisors hq s →
      ∃ p, inHankelKernel s p ∧ isSplitSquarefree p

namespace GeometricWitnessInput

/-- Component and rational-point inputs produce a split squarefree member of every exceptional
syndrome's Hankel kernel. -/
theorem exceptional_has_kernel_member {S P : Type*} {q threshold : ℕ}
    (input : GeometricWitnessInput S P q threshold) (hq : q ≥ threshold)
    (hcomponent : ∀ s, input.exceptional s → input.componentCondition s)
    (hpoint : ∀ s (_hs : input.exceptional s),
      input.rationalPointOutsideDeletedDivisors hq s) :
    ∀ s, input.exceptional s →
      HasSplitSquarefreeKernelMember input.inHankelKernel input.isSplitSquarefree s := by
  intro s hs
  exact input.pointGivesKernelMember hq hs (hcomponent s hs) (hpoint s hs)

end GeometricWitnessInput

/-- A geometric kernel-member construction makes every exceptional syndrome non-split-free once
its kernel incidence and split-squarefree predicates are identified with the Hankel dictionary. -/
theorem exceptional_not_splitFree_of_geometric_kernel_member
    {S P : Type*} {q threshold : ℕ}
    (dictionary : HankelKernelDictionary S P)
    (geometry : GeometricWitnessInput S P q threshold)
    (hq : q ≥ threshold)
    (hcomponent : ∀ s, geometry.exceptional s → geometry.componentCondition s)
    (hpoint : ∀ s (_hs : geometry.exceptional s),
      geometry.rationalPointOutsideDeletedDivisors hq s)
    (hkernel : geometry.inHankelKernel = dictionary.inHankelKernel)
    (hsplit : geometry.isSplitSquarefree = dictionary.isSplitSquarefree) :
    ∀ s, geometry.exceptional s → ¬ dictionary.isSplitFree s := by
  intro s hs
  obtain ⟨p, hpKernel, hpSplit⟩ :=
    geometry.exceptional_has_kernel_member hq hcomponent hpoint s hs
  rw [hkernel] at hpKernel
  rw [hsplit] at hpSplit
  exact dictionary.not_splitFree_of_kernel_member hpKernel hpSplit

/-- A geometric split squarefree Hankel-kernel member proves coding-theoretic shallowness without
using the covering-radius promotion theorem.  Covering radius is needed for the converse direction,
from split-freeness to deepness, not for this witness-to-shallow implication. -/
theorem exceptional_not_deep_of_geometric_kernel_member
    {S P : Type*} {q threshold : ℕ}
    (dictionary : HankelKernelDictionary S P)
    (radius : CoveringRadiusInput S)
    (geometry : GeometricWitnessInput S P q threshold)
    (hq : q ≥ threshold)
    (hcomponent : ∀ s, geometry.exceptional s → geometry.componentCondition s)
    (hpoint : ∀ s (_hs : geometry.exceptional s),
      geometry.rationalPointOutsideDeletedDivisors hq s)
    (hkernel : geometry.inHankelKernel = dictionary.inHankelKernel)
    (hsplit : geometry.isSplitSquarefree = dictionary.isSplitSquarefree)
    (hsplitFree : radius.isSplitFree = dictionary.isSplitFree) :
    ∀ s, geometry.exceptional s → ¬ radius.isDeep s := by
  have hnotSplitFree :=
    exceptional_not_splitFree_of_geometric_kernel_member dictionary geometry hq
      hcomponent hpoint hkernel hsplit
  intro s hs hdeep
  apply hnotSplitFree s hs
  rw [← hsplitFree]
  exact radius.deep_implies_splitFree hdeep

/-- Persistent tangent and sigma families, recorded as finite subsets with their exact union.
No claim that this union exhausts split-free or deep syndromes is built into the data. -/
structure PersistentFamilies (S : Type*) [DecidableEq S] where
  /-- Persistent tangent-family syndromes. -/
  tangent : Finset S
  /-- Persistent conjugate-sigma-family syndromes. -/
  sigma : Finset S
  /-- Their declared union. -/
  persistent : Finset S
  /-- The two parametrized families are disjoint. -/
  tangent_sigma_disjoint : Disjoint tangent sigma
  /-- The persistent locus is exactly the union of the two families. -/
  persistent_eq : persistent = tangent ∪ sigma

namespace PersistentFamilies

/-- Cardinality of the persistent union before any degree-specific arithmetic is substituted. -/
theorem persistent_card {S : Type*} [DecidableEq S]
    (families : PersistentFamilies S) :
    families.persistent.card = families.tangent.card + families.sigma.card := by
  rw [families.persistent_eq,
    Finset.card_union_of_disjoint families.tangent_sigma_disjoint]

end PersistentFamilies

/-- Visible exhaustion and orbit-count inputs for a persistent family classification.  The
projective and projective-semilinear counts are supplied by the concrete group-action argument;
this structure does not infer them from a numerical table. -/
structure OrbitExhaustionInput (S OrbitCase : Type*) [DecidableEq S] where
  /-- The persistent finite subset whose orbits are classified. -/
  persistent : Finset S
  /-- Split-free syndrome predicate to be exhausted. -/
  isSplitFree : S → Prop
  /-- Every split-free syndrome lies in the persistent subset. -/
  splitFree_mem_persistent : ∀ {s}, isSplitFree s → s ∈ persistent
  /-- Every persistent syndrome is split-free. -/
  persistent_isSplitFree : ∀ {s}, s ∈ persistent → isSplitFree s
  /-- Arithmetic case controlling the two orbit decompositions. -/
  orbitCase : OrbitCase
  /-- Number of projective-linear orbits in each arithmetic case. -/
  projectiveOrbitCount : OrbitCase → ℕ
  /-- Number of projective-semilinear orbits in each arithmetic case. -/
  semilinearOrbitCount : OrbitCase → ℕ

namespace OrbitExhaustionInput

/-- Exact exhaustion of split-free syndromes by the persistent subset. -/
theorem splitFree_iff_mem_persistent {S OrbitCase : Type*} [DecidableEq S]
    (input : OrbitExhaustionInput S OrbitCase) (s : S) :
    input.isSplitFree s ↔ s ∈ input.persistent :=
  ⟨input.splitFree_mem_persistent, input.persistent_isSplitFree⟩

end OrbitExhaustionInput

/-- Common synthesis theorem: a Hankel dictionary, an explicit covering-radius input, and an
explicit orbit-exhaustion input yield the coding-theoretic classification without identifying
the three hypotheses. -/
theorem deep_iff_mem_persistent {S P OrbitCase : Type*} [DecidableEq S]
    (dictionary : HankelKernelDictionary S P)
    (radius : CoveringRadiusInput S)
    (exhaustion : OrbitExhaustionInput S OrbitCase)
    (hradiusPredicate : radius.isSplitFree = dictionary.isSplitFree)
    (hexhaustionPredicate : exhaustion.isSplitFree = dictionary.isSplitFree)
    (hradius : radius.radiusRange) (s : S) :
    radius.isDeep s ↔ s ∈ exhaustion.persistent := by
  rw [radius.deep_iff_splitFree hradius]
  rw [hradiusPredicate, ← hexhaustionPredicate]
  exact exhaustion.splitFree_iff_mem_persistent s

end RelativeConicArcs.PRSFoundation
