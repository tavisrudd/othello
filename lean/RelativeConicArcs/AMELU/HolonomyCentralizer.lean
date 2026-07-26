import Mathlib.GroupTheory.Subgroup.Centralizer

/-!
# Compatible gauge families as holonomy centralizers

A chosen transport from one base vertex to every vertex trivializes a
group-valued transition atlas.  Each remaining transition then determines a
loop holonomy at the base.  Compatible vertex gauges are determined uniquely
by their base value, and the possible base values are exactly the elements
commuting with every loop holonomy.

One equivalence restricts this statement to a normal subgroup.  A second,
exact version for an arbitrary subgroup retains the condition that every
propagated block lies in that subgroup.  In the prime-dimensional Clifford
application the ambient group is `GL₂`, the normal subgroup is `SL₂`, and the
transitions are the pushing maps between local Weyl label planes.  In
extension dimension the arbitrary-subgroup form applies to `Sp(2e,p)`.

This module is symbolic and kernel checked.  It contains no generated data,
native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

/-- A transition atlas equipped with one chosen transport from the base to
each vertex.  The edge type may contain every chart transition, including
redundant transitions that generate loop holonomy. -/
structure HolonomyAtlas (ι ε G : Type*) [Group G] where
  /-- Distinguished vertex at which gauges and holonomies are evaluated. -/
  base : ι
  /-- Source vertex of a transition. -/
  src : ε → ι
  /-- Destination vertex of a transition. -/
  dst : ε → ι
  /-- Chosen transport from the base to a vertex. -/
  transport : ι → G
  /-- Transition from `src e` to `dst e`. -/
  transition : ε → G
  /-- The chosen transport at the base is trivial. -/
  transport_base : transport base = 1

namespace HolonomyAtlas

variable {ι ε G : Type*} [Group G] (atlas : HolonomyAtlas ι ε G)

/-- The based loop obtained by following the chosen path to the source,
the displayed transition, and the inverse chosen path from the destination. -/
def holonomy (e : ε) : G :=
  (atlas.transport (atlas.dst e))⁻¹ *
    atlas.transition e * atlas.transport (atlas.src e)

/-- Commuting with every displayed holonomy is membership in the ordinary
group centralizer of their range. -/
theorem mem_centralizer_holonomy_range_iff (g : G) :
    g ∈ Subgroup.centralizer (Set.range atlas.holonomy) ↔
      ∀ e, Commute g (atlas.holonomy e) := by
  rw [Subgroup.mem_centralizer_iff]
  constructor
  · intro h e
    show g * atlas.holonomy e = atlas.holonomy e * g
    exact (h (atlas.holonomy e) ⟨e, rfl⟩).symm
  · intro h x hx
    obtain ⟨e, rfl⟩ := hx
    exact (h e).eq.symm

/-- A gauge family intertwines the chosen base transports and every displayed
transition. -/
def IsCompatibleGauge (F : ι → G) : Prop :=
  (∀ i, F i * atlas.transport i =
      atlas.transport i * F atlas.base) ∧
  (∀ e, F (atlas.dst e) * atlas.transition e =
      atlas.transition e * F (atlas.src e))

/-- Intertwining the chosen base transport determines every gauge block from
the block at the base. -/
theorem gauge_eq_transport_conj
    (F : ι → G)
    (hbase :
      ∀ i, F i * atlas.transport i =
        atlas.transport i * F atlas.base)
    (i : ι) :
    F i =
      atlas.transport i * F atlas.base *
        (atlas.transport i)⁻¹ := by
  calc
    F i = (F i * atlas.transport i) *
        (atlas.transport i)⁻¹ := by simp
    _ = (atlas.transport i * F atlas.base) *
        (atlas.transport i)⁻¹ := by rw [hbase i]

/-- After gauges are propagated from the base, one transition intertwines
exactly when the base gauge commutes with its loop holonomy. -/
theorem transition_intertwines_iff_commute_holonomy
    (F : ι → G)
    (hbase :
      ∀ i, F i * atlas.transport i =
        atlas.transport i * F atlas.base)
    (e : ε) :
    F (atlas.dst e) * atlas.transition e =
        atlas.transition e * F (atlas.src e) ↔
      Commute (F atlas.base) (atlas.holonomy e) := by
  have hdst :=
    atlas.gauge_eq_transport_conj F hbase (atlas.dst e)
  have hsrc :=
    atlas.gauge_eq_transport_conj F hbase (atlas.src e)
  rw [hdst, hsrc]
  constructor
  · intro hedge
    rw [Commute]
    calc
      F atlas.base * atlas.holonomy e =
          (atlas.transport (atlas.dst e))⁻¹ *
            ((atlas.transport (atlas.dst e) * F atlas.base *
              (atlas.transport (atlas.dst e))⁻¹) *
              atlas.transition e) *
            atlas.transport (atlas.src e) := by
              simp [holonomy, mul_assoc]
      _ = (atlas.transport (atlas.dst e))⁻¹ *
            (atlas.transition e *
              (atlas.transport (atlas.src e) * F atlas.base *
                (atlas.transport (atlas.src e))⁻¹)) *
            atlas.transport (atlas.src e) := by rw [hedge]
      _ = atlas.holonomy e * F atlas.base := by
            simp [holonomy, mul_assoc]
  · intro hcomm
    rw [Commute] at hcomm
    calc
      atlas.transport (atlas.dst e) * F atlas.base *
          (atlas.transport (atlas.dst e))⁻¹ *
          atlas.transition e =
        atlas.transport (atlas.dst e) *
          (F atlas.base * atlas.holonomy e) *
          (atlas.transport (atlas.src e))⁻¹ := by
            simp [holonomy, mul_assoc]
      _ = atlas.transport (atlas.dst e) *
          (atlas.holonomy e * F atlas.base) *
          (atlas.transport (atlas.src e))⁻¹ := by rw [hcomm]
      _ = atlas.transition e *
          (atlas.transport (atlas.src e) * F atlas.base *
            (atlas.transport (atlas.src e))⁻¹) := by
            simp [holonomy, mul_assoc]

/-- Compatible gauges are exactly transported base blocks that centralize all
displayed loop holonomies. -/
def compatibleGaugeEquivHolonomyCentralizer :
    {F : ι → G // atlas.IsCompatibleGauge F} ≃
      {g : G // ∀ e, Commute g (atlas.holonomy e)} where
  toFun F :=
    ⟨F.1 atlas.base, fun e =>
      (atlas.transition_intertwines_iff_commute_holonomy
        F.1 F.2.1 e).mp (F.2.2 e)⟩
  invFun g :=
    ⟨fun i => atlas.transport i * g.1 * (atlas.transport i)⁻¹,
      ⟨fun i => by
          simp [atlas.transport_base, mul_assoc],
        fun e =>
          (atlas.transition_intertwines_iff_commute_holonomy
            (fun i =>
              atlas.transport i * g.1 * (atlas.transport i)⁻¹)
            (fun i => by
              simp [atlas.transport_base, mul_assoc])
            e).mpr (by
              simpa [atlas.transport_base] using g.2 e)⟩⟩
  left_inv F := by
    apply Subtype.ext
    funext i
    simpa [atlas.transport_base] using
      (atlas.gauge_eq_transport_conj F.1 F.2.1 i).symm
  right_inv g := by
    apply Subtype.ext
    simp [atlas.transport_base]

/-- Compatible gauges whose blocks lie in a subgroup of the ambient
transition group. -/
def CompatibleGaugesIn (N : Subgroup G) :=
  {F : {F : ι → G // atlas.IsCompatibleGauge F} //
    ∀ i, F.1 i ∈ N}

/-- The centralizer of the loop holonomies inside a specified subgroup. -/
def HolonomyCentralizerIn (N : Subgroup G) :=
  {g : {g : G // ∀ e, Commute g (atlas.holonomy e)} // g.1 ∈ N}

/-- Base blocks that centralize every holonomy and whose propagated blocks
all lie in a specified subgroup.  Unlike `HolonomyCentralizerIn`, this is
the exact target for an arbitrary, not necessarily normal, subgroup. -/
def HolonomyCentralizerWithPropagatesIn (N : Subgroup G) :=
  {g : {g : G // ∀ e, Commute g (atlas.holonomy e)} //
    ∀ i, atlas.transport i * g.1 *
      (atlas.transport i)⁻¹ ∈ N}

/-- Without a normality hypothesis, compatible subgroup-valued gauges are
the holonomy-centralizing base blocks whose transports remain in the
subgroup at every vertex.  This is the form relevant to extension-field
local Clifford blocks, where `Sp(2e,p)` need not be normal in the ambient
general linear group. -/
def compatibleGaugesInSubgroupEquiv
    (N : Subgroup G) :
    atlas.CompatibleGaugesIn N ≃
      atlas.HolonomyCentralizerWithPropagatesIn N where
  toFun F :=
    ⟨atlas.compatibleGaugeEquivHolonomyCentralizer F.1,
      fun i => by
        change
          atlas.transport i * F.1.1 atlas.base *
            (atlas.transport i)⁻¹ ∈ N
        rw [← atlas.gauge_eq_transport_conj F.1.1 F.1.2.1 i]
        exact F.2 i⟩
  invFun g :=
    ⟨atlas.compatibleGaugeEquivHolonomyCentralizer.symm g.1,
      fun i => g.2 i⟩
  left_inv F := by
    apply Subtype.ext
    exact atlas.compatibleGaugeEquivHolonomyCentralizer.left_inv F.1
  right_inv g := by
    apply Subtype.ext
    exact atlas.compatibleGaugeEquivHolonomyCentralizer.right_inv g.1

/-- For a normal subgroup, evaluation at the base identifies compatible
subgroup-valued gauges with the holonomy centralizer inside that subgroup. -/
def compatibleGaugesInNormalSubgroupEquiv
    (N : Subgroup G) [N.Normal] :
    atlas.CompatibleGaugesIn N ≃ atlas.HolonomyCentralizerIn N where
  toFun F :=
    ⟨atlas.compatibleGaugeEquivHolonomyCentralizer F.1,
      F.2 atlas.base⟩
  invFun g :=
    ⟨atlas.compatibleGaugeEquivHolonomyCentralizer.symm g.1,
      fun i => by
        change atlas.transport i * g.1.1 *
            (atlas.transport i)⁻¹ ∈ N
        exact ‹N.Normal›.conj_mem _ g.2 _⟩
  left_inv F := by
    apply Subtype.ext
    exact atlas.compatibleGaugeEquivHolonomyCentralizer.left_inv F.1
  right_inv g := by
    apply Subtype.ext
    exact atlas.compatibleGaugeEquivHolonomyCentralizer.right_inv g.1

end HolonomyAtlas

end RelativeConicArcs.AMELU
