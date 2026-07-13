import RelativeConicArcs.Defect

/-!
# Projective syndrome geometry of a plane arc

For a rank-three parity-check system, projective syndrome directions have distance one on the
selected columns, distance two on the external secant locus, and distance three on the ordinary
uncovered locus.  This file packages that dictionary at the incidence level, where it applies to
every finite projective plane.  `CodingBridge.lean` supplies the coordinate linear-code semantics.
-/

namespace RelativeConicArcs

open Configuration Finset

variable {P L : Type*} [Membership P L]

section FinitePlane

variable [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

/-- The projective syndrome distance determined by an arc's columns: selected, secant-covered,
or uncovered.  Rank three makes these the only three nonzero projective distance classes. -/
noncomputable def projectiveSyndromeDistance (A : Finset P) (x : P) : ℕ := by
  classical
  exact if x ∈ A then 1 else if Covered (L := L) A x then 2 else 3

omit [Fintype P] [DecidableEq L] [Configuration.ProjectivePlane P L] in
@[simp] theorem projectiveSyndromeDistance_eq_one_iff {A : Finset P} {x : P} :
    projectiveSyndromeDistance (L := L) A x = 1 ↔ x ∈ A := by
  classical
  unfold projectiveSyndromeDistance
  split_ifs <;> simp_all

omit [Fintype P] [DecidableEq L] [Configuration.ProjectivePlane P L] in
@[simp] theorem projectiveSyndromeDistance_eq_two_iff {A : Finset P} {x : P} :
    projectiveSyndromeDistance (L := L) A x = 2 ↔ x ∉ A ∧ Covered (L := L) A x := by
  classical
  unfold projectiveSyndromeDistance
  split_ifs <;> simp_all

omit [Fintype P] [DecidableEq L] [Configuration.ProjectivePlane P L] in
@[simp] theorem projectiveSyndromeDistance_eq_three_iff {A : Finset P} {x : P} :
    projectiveSyndromeDistance (L := L) A x = 3 ↔
      x ∉ A ∧ ¬Covered (L := L) A x := by
  classical
  unfold projectiveSyndromeDistance
  split_ifs <;> simp_all

/-- Weight-two leader supports for a projective syndrome direction are the unordered column pairs
whose secant contains that direction. -/
noncomputable abbrev weightTwoLeaderSupports (A : Finset P) (x : P) :
    Finset (ArcPair A) :=
  pairsThrough (L := L) A x

omit [Fintype P] in
/-- The number of weight-two leader supports is the secant index. -/
theorem card_weightTwoLeaderSupports {A : Finset P} (hA : Arc (L := L) A) (x : P) :
    (weightTwoLeaderSupports (L := L) A x).card = pointIndex (L := L) A x := by
  rw [pointIndex_eq_card_pairsThrough hA]

omit [Fintype P] in
/-- A projective distance-two direction has exactly `r_A(x)` minimum weight-two supports. -/
theorem distance_two_leader_support_count {A : Finset P} (hA : Arc (L := L) A) {x : P}
    (_hx : projectiveSyndromeDistance (L := L) A x = 2) :
    (weightTwoLeaderSupports (L := L) A x).card = pointIndex (L := L) A x :=
  card_weightTwoLeaderSupports hA x

omit [Fintype P] in
/-- A projective distance-three direction has no weight-two support. -/
theorem distance_three_weightTwoLeaderSupports_eq_empty {A : Finset P}
    {x : P} (hx : projectiveSyndromeDistance (L := L) A x = 3) :
    weightTwoLeaderSupports (L := L) A x = ∅ := by
  apply Finset.eq_empty_iff_forall_notMem.mpr
  intro e he
  have hcovered : Covered (L := L) A x := by
    rw [covered_iff_exists_secant]
    exact ⟨e.line (L := L),
      (mem_secants.mp (by
        rw [secants_eq_image_pairLine]
        exact Finset.mem_image.mpr ⟨e, Finset.mem_univ _, rfl⟩)),
      mem_pairsThrough.mp he⟩
  exact (projectiveSyndromeDistance_eq_three_iff.mp hx).2 hcovered

/-- The finite set of ordinary projective distance-three syndrome directions. -/
noncomputable def distanceThreeDirections (A : Finset P) : Finset P := by
  classical
  exact Finset.univ.filter fun x => projectiveSyndromeDistance (L := L) A x = 3

omit [DecidableEq L] [Configuration.ProjectivePlane P L] in
@[simp] theorem mem_distanceThreeDirections {A : Finset P} {x : P} :
    x ∈ distanceThreeDirections (L := L) A ↔
      x ∉ A ∧ ¬Covered (L := L) A x := by
  classical
  simp [distanceThreeDirections]

omit [Fintype P] [DecidableEq L] [Configuration.ProjectivePlane P L] in
/-- A fresh projective column is a valid one-column arc/MDS extension exactly when its syndrome
direction has distance three from the old columns. -/
theorem oneColumnExtension_iff_distance_three {A : Finset P} (hA : Arc (L := L) A)
    {x : P} :
    (x ∉ A ∧ Arc (L := L) (insert x A)) ↔
      projectiveSyndromeDistance (L := L) A x = 3 := by
  rw [projectiveSyndromeDistance_eq_three_iff]
  exact and_congr_right fun hx => arc_insert_iff_not_covered hA hx

omit [DecidableEq L] [Configuration.ProjectivePlane P L] in
/-- Relative completeness is exactly confinement of all projective distance-three syndrome
directions to the prescribed hole set.  No covering-radius terminology is needed. -/
theorem completeOutside_iff_distanceThreeDirections_subset {A H : Finset P} :
    CompleteOutside (L := L) A H ↔
      Arc (L := L) A ∧ Disjoint A H ∧ distanceThreeDirections (L := L) A ⊆ H := by
  constructor
  · rintro ⟨hA, hdisj, hcover⟩
    refine ⟨hA, hdisj, ?_⟩
    intro x hx
    have hx' := mem_distanceThreeDirections.mp hx
    by_contra hxH
    exact hx'.2 (hcover x hx'.1 hxH)
  · rintro ⟨hA, hdisj, hsubset⟩
    refine ⟨hA, hdisj, ?_⟩
    intro x hxA hxH
    by_contra hxcover
    exact hxH (hsubset (mem_distanceThreeDirections.mpr ⟨hxA, hxcover⟩))

/-! ## Simultaneous extensions: pair conflicts plus triple conflicts -/

/-- Two singly admissible new points conflict when they are collinear with an old column. -/
def PairExtensionConflict (A : Finset P) (x y : P) : Prop :=
  ∃ a ∈ A, Collinear (L := L) a x y

/-- Independence for the pair-conflict graph on a proposed extension set. -/
def PairExtensionIndependent (A T : Finset P) : Prop :=
  ∀ ⦃x y : P⦄, x ∈ T → y ∈ T → x ≠ y → ¬PairExtensionConflict (L := L) A x y

omit [Fintype P] [Fintype L] [DecidableEq L]
  [Configuration.ProjectivePlane P L] in
/-- General simultaneous extension criterion.  The `Arc T` term is exactly the triple-conflict
hypergraph among new columns; `PairExtensionIndependent` is the pair-conflict graph coming from
one old and two new columns. -/
theorem arc_union_iff_extension_hypergraph {A T : Finset P}
    (hA : Arc (L := L) A) (hdisj : Disjoint A T)
    (hsingle : ∀ x ∈ T, Arc (L := L) (insert x A)) :
    Arc (L := L) (A ∪ T) ↔
      Arc (L := L) T ∧ PairExtensionIndependent (L := L) A T := by
  constructor
  · intro hAT
    refine ⟨arc_mono (Finset.subset_union_right) hAT, ?_⟩
    intro x y hx hy hxy
    rintro ⟨a, ha, hcol⟩
    have hax : a ≠ x := fun h =>
      (Finset.disjoint_left.mp hdisj) ha (h ▸ hx)
    have hay : a ≠ y := fun h =>
      (Finset.disjoint_left.mp hdisj) ha (h ▸ hy)
    exact hAT (Finset.mem_union_left T ha) (Finset.mem_union_right A hx)
      (Finset.mem_union_right A hy) hax hay hxy hcol
  · rintro ⟨hT, hpair⟩
    intro a b c ha hb hc hab hac hbc hcol
    simp only [Finset.mem_union] at ha hb hc
    rcases ha with ha | ha <;> rcases hb with hb | hb <;> rcases hc with hc | hc
    · exact hA ha hb hc hab hac hbc hcol
    · exact hsingle c hc (Finset.mem_insert_of_mem ha) (Finset.mem_insert_of_mem hb)
        (Finset.mem_insert_self c A) hab hac hbc hcol
    · exact hsingle b hb (Finset.mem_insert_of_mem ha) (Finset.mem_insert_self b A)
        (Finset.mem_insert_of_mem hc) hab hac hbc hcol
    · exact hpair hb hc hbc ⟨a, ha, hcol⟩
    · exact hsingle a ha (Finset.mem_insert_self a A) (Finset.mem_insert_of_mem hb)
        (Finset.mem_insert_of_mem hc) hab hac hbc hcol
    · exact hpair ha hc hac ⟨b, hb, (collinear_swap_left (L := L)).mp hcol⟩
    · exact hpair ha hb hab ⟨c, hc,
        (collinear_rotate (L := L)).mp ((collinear_rotate (L := L)).mp hcol)⟩
    · exact hT ha hb hc hab hac hbc hcol

omit [Fintype P] [Fintype L] [DecidableEq L]
  [Configuration.ProjectivePlane P L] in
/-- If the single-extension locus is itself an arc, triple conflicts disappear and simultaneous
extensions are exactly independent sets of the pair-conflict graph. -/
theorem arc_union_iff_pairExtensionIndependent_of_arc_locus {A E T : Finset P}
    (hA : Arc (L := L) A) (hE : Arc (L := L) E) (hdisj : Disjoint A E)
    (hTE : T ⊆ E) (hsingle : ∀ x ∈ E, Arc (L := L) (insert x A)) :
    Arc (L := L) (A ∪ T) ↔ PairExtensionIndependent (L := L) A T := by
  rw [arc_union_iff_extension_hypergraph hA (hdisj.mono_right hTE)
    (fun x hx => hsingle x (hTE hx))]
  simp [arc_mono hTE hE]

/-- A set maximal among simultaneous extensions drawn from `E`. -/
def MaximalExtensionIn (A E T : Finset P) : Prop :=
  T ⊆ E ∧ Arc (L := L) (A ∪ T) ∧
    ∀ x ∈ E, x ∉ T → ¬Arc (L := L) (A ∪ insert x T)

/-- Maximal independence in the pair-conflict graph restricted to `E`. -/
def MaximalPairExtensionIndependent (A E T : Finset P) : Prop :=
  T ⊆ E ∧ PairExtensionIndependent (L := L) A T ∧
    ∀ x ∈ E, x ∉ T → ¬PairExtensionIndependent (L := L) A (insert x T)

omit [Fintype P] [Fintype L] [DecidableEq L] [Configuration.ProjectivePlane P L] in
/-- Under an arc-confined single-extension locus, sets maximal among extensions drawn from `E`
are exactly maximal independent sets of the residual pair-conflict graph. -/
theorem maximalExtensionIn_iff_maximalPairExtensionIndependent {A E T : Finset P}
    (hA : Arc (L := L) A) (hE : Arc (L := L) E) (hdisj : Disjoint A E)
    (hsingle : ∀ x ∈ E, Arc (L := L) (insert x A)) :
    MaximalExtensionIn (L := L) A E T ↔
      MaximalPairExtensionIndependent (L := L) A E T := by
  constructor
  · rintro ⟨hTE, hAT, hmax⟩
    refine ⟨hTE,
      (arc_union_iff_pairExtensionIndependent_of_arc_locus hA hE hdisj hTE hsingle).mp hAT,
      ?_⟩
    intro x hxE hxT hxind
    exact hmax x hxE hxT
      ((arc_union_iff_pairExtensionIndependent_of_arc_locus hA hE hdisj
        (by simp [Finset.insert_subset_iff, hxE, hTE]) hsingle).mpr hxind)
  · rintro ⟨hTE, hind, hmax⟩
    refine ⟨hTE,
      (arc_union_iff_pairExtensionIndependent_of_arc_locus hA hE hdisj hTE hsingle).mpr hind,
      ?_⟩
    intro x hxE hxT hxarc
    exact hmax x hxE hxT
      ((arc_union_iff_pairExtensionIndependent_of_arc_locus hA hE hdisj
        (by simp [Finset.insert_subset_iff, hxE, hTE]) hsingle).mp hxarc)

omit [Fintype P] [DecidableEq L] [Configuration.ProjectivePlane P L] in
/-- If `E` is the full one-point extension locus of `A`, maximality inside `E` upgrades to
ordinary completeness of the resulting arc. -/
theorem completeOutside_empty_of_maximalExtensionIn_full {A E T : Finset P}
    (hfull : ∀ x, x ∈ E ↔ x ∉ A ∧ Arc (L := L) (insert x A))
    (hmax : MaximalExtensionIn (L := L) A E T) :
    CompleteOutside (L := L) (A ∪ T) ∅ := by
  refine ⟨hmax.2.1, by simp, ?_⟩
  intro x hxAT _
  by_contra hxCovered
  have hxArc : Arc (L := L) (insert x (A ∪ T)) :=
    (arc_insert_iff_not_covered hmax.2.1 hxAT).mpr hxCovered
  have hxA : x ∉ A := fun hx => hxAT (Finset.mem_union_left T hx)
  have hxArcA : Arc (L := L) (insert x A) := by
    apply arc_mono (B := insert x (A ∪ T))
    · intro y hy
      rcases Finset.mem_insert.mp hy with hyx | hyA
      · exact Finset.mem_insert.mpr (Or.inl hyx)
      · exact Finset.mem_insert_of_mem (Finset.mem_union_left T hyA)
    · exact hxArc
  have hxE : x ∈ E := (hfull x).mpr ⟨hxA, hxArcA⟩
  have hxT : x ∉ T := fun hx => hxAT (Finset.mem_union_right A hx)
  exact hmax.2.2 x hxE hxT (by
    have heq : A ∪ insert x T = insert x (A ∪ T) := by ext y; simp
    rw [heq]
    exact hxArc)

/-- First secant moment in leader language. -/
theorem first_weightTwoLeader_moment {A : Finset P} (hA : Arc (L := L) A) :
    (∑ x ∈ (Finset.univ \ A),
        (weightTwoLeaderSupports (L := L) A x).card) =
      Nat.choose A.card 2 * (PlaneOrder P L - 1) := by
  simpa only [card_weightTwoLeaderSupports hA] using first_secant_moment (L := L) hA

/-- Second secant moment in leader-collision language. -/
theorem second_weightTwoLeader_collision_moment {A : Finset P}
    (hA : Arc (L := L) A) :
    (∑ x ∈ (Finset.univ \ A),
        Nat.choose (weightTwoLeaderSupports (L := L) A x).card 2) =
      3 * Nat.choose A.card 4 := by
  simpa only [card_weightTwoLeaderSupports hA] using second_secant_moment (L := L) hA

/-- The paper's exact prescribed-hole defect identity, rewritten as a collision identity for
weight-two leader-support multiplicities. -/
theorem scaledDefect_eq_weightTwoLeader_remainders {A H : Finset P}
    (hA : Arc (L := L) A) (hdisj : Disjoint A H) :
    scaledDefect (L := L) A H =
      (∑ x ∈ coveredRequired (L := L) A H,
        (((weightTwoLeaderSupports (L := L) A x).card : ℤ) - 1) *
          (((A.card / 2 : ℕ) : ℤ) -
            (weightTwoLeaderSupports (L := L) A x).card)) +
      (∑ y ∈ H, ((weightTwoLeaderSupports (L := L) A y).card : ℤ) *
        (((A.card / 2 : ℕ) : ℤ) -
          (weightTwoLeaderSupports (L := L) A y).card)) := by
  rw [scaledDefect_eq_remainders hA hdisj, requiredRemainder, holeRemainder]
  simp only [card_weightTwoLeaderSupports hA]

end FinitePlane

end RelativeConicArcs
