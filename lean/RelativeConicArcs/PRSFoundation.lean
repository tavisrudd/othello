import RelativeConicArcs.PRSContraction

/-!
# Projective Reed--Solomon syndrome interfaces

These common interfaces separate four assertions used in projective Reed--Solomon syndrome
classifications:

* a Hankel kernel contains no split squarefree polynomial;
* the corresponding projective syndrome is split-free;
* a covering-radius statement promotes split-freeness to the deep syndrome property;
* geometric component and rational-point arguments construct a split squarefree kernel member.

The syndrome and polynomial types are abstract.  Concrete degrees may use coefficient vectors,
binary forms, or projective quotient types without changing the synthesis lemmas.  Divided-power
marker contraction is the definition
`RelativeConicArcs.PRSResidualQuadratic.dividedPowerContraction`; no second contraction
hierarchy is introduced here.

Here a deep syndrome represents a deep-hole coset under the projective syndrome/coset dictionary;
a shallow syndrome represents a coset that is not deep.  Geometric, rational-point,
covering-radius, and exhaustion assertions remain structure fields.
-/

namespace RelativeConicArcs.PRSFoundation

/-- Existence of a polynomial satisfying the kernel and split squarefree predicates. -/
def HasSplitSquarefreeKernelMember {S P : Type*}
    (inHankelKernel : S → P → Prop) (isSplitSquarefree : P → Prop) (s : S) : Prop :=
  ∃ p, inHankelKernel s p ∧ isSplitSquarefree p

/-- Dictionary between split-freeness and absence of a split squarefree kernel member. -/
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

/-- Classically, failure of split-freeness is equivalent to a split squarefree kernel member. -/
theorem not_splitFree_iff_has_kernel_member {S P : Type*}
    (dictionary : HankelKernelDictionary S P) (s : S) :
    ¬ dictionary.isSplitFree s ↔
      HasSplitSquarefreeKernelMember dictionary.inHankelKernel
        dictionary.isSplitSquarefree s := by
  rw [dictionary.splitFree_iff_no_kernel_member]
  classical
  tauto

end HankelKernelDictionary

/-- Covering-radius input relating split-freeness to the deep syndrome predicate. -/
structure CoveringRadiusInput (S : Type*) where
  /-- Projective syndromes whose Hankel kernels have no split squarefree member. -/
  isSplitFree : S → Prop
  /-- Coding-theoretic deep syndrome predicate. -/
  isDeep : S → Prop
  /-- The field-length-radius condition under which split-free syndromes are deep. -/
  radiusRange : Prop
  /-- A deep syndrome is split-free independently of the radius-promotion theorem. -/
  deep_implies_splitFree : ∀ {s}, isDeep s → isSplitFree s
  /-- In the declared radius range, split-freeness implies that a syndrome is deep. -/
  splitFree_implies_deep : radiusRange → ∀ {s}, isSplitFree s → isDeep s

namespace CoveringRadiusInput

/-- On the stated radius range, a syndrome is deep exactly when it is split-free. -/
theorem deep_iff_splitFree {S : Type*} (input : CoveringRadiusInput S)
    (hradius : input.radiusRange) (s : S) :
    input.isDeep s ↔ input.isSplitFree s :=
  ⟨input.deep_implies_splitFree, input.splitFree_implies_deep hradius⟩

end CoveringRadiusInput

/-- Predicate-level input for a geometric kernel-member construction. -/
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

/-- Component, rational-point, and bridge inputs for a geometric kernel member. -/
structure GeometricWitnessInput (S P : Type*) (q threshold : ℕ) where
  /-- Syndromes to which the transverse geometric construction is applied. -/
  exceptional : S → Prop
  /-- The required geometrically suitable component exists for the syndrome. -/
  componentCondition : S → Prop
  /-- A rational point remains after all determinant, branch, diagonal, and collision deletions. -/
  rationalPointOutsideDeletedDivisors : q ≥ threshold → S → Prop
  /-- Hankel-kernel incidence for the constructed polynomial. -/
  inHankelKernel : S → P → Prop
  /-- Split squarefree predicate for the constructed polynomial. -/
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

/-- Pointwise-compatible geometric witnesses make exceptional syndromes non-split-free. -/
theorem exceptional_not_splitFree_of_compatible_geometric_kernel_member
    {S P : Type*} {q threshold : ℕ}
    (dictionary : HankelKernelDictionary S P)
    (geometry : GeometricWitnessInput S P q threshold)
    (hq : q ≥ threshold)
    (hcomponent : ∀ s, geometry.exceptional s → geometry.componentCondition s)
    (hpoint : ∀ s (_hs : geometry.exceptional s),
      geometry.rationalPointOutsideDeletedDivisors hq s)
    (hkernel : ∀ s p,
      geometry.inHankelKernel s p ↔ dictionary.inHankelKernel s p)
    (hsplit : ∀ p,
      geometry.isSplitSquarefree p ↔ dictionary.isSplitSquarefree p) :
    ∀ s, geometry.exceptional s → ¬ dictionary.isSplitFree s := by
  intro s hs
  obtain ⟨p, hpKernel, hpSplit⟩ :=
    geometry.exceptional_has_kernel_member hq hcomponent hpoint s hs
  exact dictionary.not_splitFree_of_kernel_member
    ((hkernel s p).1 hpKernel) ((hsplit p).1 hpSplit)

/-- Identified geometric and dictionary predicates make exceptional syndromes non-split-free. -/
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
  exact exceptional_not_splitFree_of_compatible_geometric_kernel_member
    dictionary geometry hq hcomponent hpoint
    (fun s p => by rw [hkernel])
    (fun p => by rw [hsplit])

/-- Pointwise-compatible geometric, Hankel, and coding predicates prove a syndrome shallow. -/
theorem exceptional_not_deep_of_compatible_geometric_kernel_member
    {S P : Type*} {q threshold : ℕ}
    (dictionary : HankelKernelDictionary S P)
    (radius : CoveringRadiusInput S)
    (geometry : GeometricWitnessInput S P q threshold)
    (hq : q ≥ threshold)
    (hcomponent : ∀ s, geometry.exceptional s → geometry.componentCondition s)
    (hpoint : ∀ s (_hs : geometry.exceptional s),
      geometry.rationalPointOutsideDeletedDivisors hq s)
    (hkernel : ∀ s p,
      geometry.inHankelKernel s p ↔ dictionary.inHankelKernel s p)
    (hsplit : ∀ p,
      geometry.isSplitSquarefree p ↔ dictionary.isSplitSquarefree p)
    (hsplitFree : ∀ s, radius.isSplitFree s ↔ dictionary.isSplitFree s) :
    ∀ s, geometry.exceptional s → ¬ radius.isDeep s := by
  have hnotSplitFree :=
    exceptional_not_splitFree_of_compatible_geometric_kernel_member dictionary geometry hq
      hcomponent hpoint hkernel hsplit
  intro s hs hdeep
  apply hnotSplitFree s hs
  exact (hsplitFree s).1 (radius.deep_implies_splitFree hdeep)

/-- A geometric split squarefree kernel member proves that an exceptional syndrome is shallow. -/
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
  exact exceptional_not_deep_of_compatible_geometric_kernel_member
    dictionary radius geometry hq hcomponent hpoint
    (fun s p => by rw [hkernel])
    (fun p => by rw [hsplit])
    (fun s => by rw [hsplitFree])

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

/-- Exhaustion predicates and numerical orbit-count hypotheses for a persistent classification.
Any group-action justification for the supplied numbers is external to this structure. -/
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

/-- Persistent syndromes are exactly the deep ones when the complement is shallow. -/
theorem deep_iff_mem_persistent_of_exceptional_shallow
    {S : Type*} [DecidableEq S]
    (isDeep exceptional : S → Prop) (persistent : Finset S)
    (exceptional_iff : ∀ s, exceptional s ↔ s ∉ persistent)
    (persistentDeep : ∀ s, s ∈ persistent → isDeep s)
    (exceptionalShallow : ∀ s, exceptional s → ¬ isDeep s) :
    ∀ s, isDeep s ↔ s ∈ persistent := by
  intro s
  constructor
  · intro hdeep
    by_contra hmem
    exact exceptionalShallow s ((exceptional_iff s).2 hmem) hdeep
  · exact persistentDeep s

/-- Pointwise-compatible dictionary, radius, and exhaustion inputs classify deep syndromes. -/
theorem deep_iff_mem_persistent_of_compatible
    {S P OrbitCase : Type*} [DecidableEq S]
    (dictionary : HankelKernelDictionary S P)
    (radius : CoveringRadiusInput S)
    (exhaustion : OrbitExhaustionInput S OrbitCase)
    (hradiusPredicate : ∀ s, radius.isSplitFree s ↔ dictionary.isSplitFree s)
    (hexhaustionPredicate : ∀ s,
      exhaustion.isSplitFree s ↔ dictionary.isSplitFree s)
    (hradius : radius.radiusRange) (s : S) :
    radius.isDeep s ↔ s ∈ exhaustion.persistent := by
  rw [radius.deep_iff_splitFree hradius]
  exact (hradiusPredicate s).trans
    ((hexhaustionPredicate s).symm.trans
      (exhaustion.splitFree_iff_mem_persistent s))

/-- Compatibility wrapper for models whose split-free predicates are literally equal. -/
theorem deep_iff_mem_persistent {S P OrbitCase : Type*} [DecidableEq S]
    (dictionary : HankelKernelDictionary S P)
    (radius : CoveringRadiusInput S)
    (exhaustion : OrbitExhaustionInput S OrbitCase)
    (hradiusPredicate : radius.isSplitFree = dictionary.isSplitFree)
    (hexhaustionPredicate : exhaustion.isSplitFree = dictionary.isSplitFree)
    (hradius : radius.radiusRange) (s : S) :
    radius.isDeep s ↔ s ∈ exhaustion.persistent := by
  exact deep_iff_mem_persistent_of_compatible dictionary radius exhaustion
    (fun s => by rw [hradiusPredicate])
    (fun s => by rw [hexhaustionPredicate])
    hradius s

end RelativeConicArcs.PRSFoundation
