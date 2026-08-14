import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixPointCoefficientHeart
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisSlopeModels
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisTwoPrimaryDiscriminant
import Mathlib.Data.Set.Card

/-!
# Stable halves of the six-point coefficient heart

Let `H` be the explicit four-dimensional characteristic-two coefficient heart
with its translation and inversion generators.  This module studies
four-dimensional subspaces of `H × H` stable under the diagonal action of both
generators.  Lean proves that every such half is either the vertical copy of
`H` or the graph of one of the four endomorphisms in the quadratic commutant
`{0, 1, W, W + 1}`.  The converse is also proved: the displayed vertical copy
and four graphs all have dimension four and are diagonally stable.  Their graph
slopes and first projections distinguish them, so the packet has five members.
The coefficient-heart form induces an explicit nondegenerate alternating
pairing on `H × H`; all five packet members are maximal isotropic for this
pairing.

The argument is structural.  Simplicity of `H` makes the first projection and
the vertical kernel either zero or the whole heart.  A half with surjective
first projection and zero vertical kernel is the graph of a unique linear
endomorphism; diagonal stability makes that endomorphism commute with both
generators, so the previously proved commutant classification applies.  No
geometric isogeny kernel or family local system is identified here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

open scoped Matrix

/-- The explicit four-dimensional characteristic-two coefficient heart. -/
abbrev SixPointHeart := Fin 4 → F2

/-- Diagonal stability of a subspace of two copies of the coefficient heart
under the displayed translation and inversion generators. -/
def SixPointHeartPairGeneratorStable
    (subspace : Submodule F2 (SixPointHeart × SixPointHeart)) : Prop :=
  (∀ vector ∈ subspace,
    (Matrix.mulVec sixPointHeartTranslation vector.1,
      Matrix.mulVec sixPointHeartTranslation vector.2) ∈ subspace) ∧
  (∀ vector ∈ subspace,
    (Matrix.mulVec sixPointHeartInversion vector.1,
      Matrix.mulVec sixPointHeartInversion vector.2) ∈ subspace)

/-- The image of a pair subspace under first projection. -/
def sixPointHeartPairFirstRange
    (subspace : Submodule F2 (SixPointHeart × SixPointHeart)) :
    Submodule F2 SixPointHeart :=
  subspace.map (LinearMap.fst F2 SixPointHeart SixPointHeart)

/-- The vectors occurring in the vertical part of a pair subspace. -/
def sixPointHeartPairVerticalPart
    (subspace : Submodule F2 (SixPointHeart × SixPointHeart)) :
    Submodule F2 SixPointHeart :=
  subspace.comap (LinearMap.inr F2 SixPointHeart SixPointHeart)

/-- Diagonal generator stability descends to the first-projection image. -/
theorem sixPointHeartPairFirstRange_generatorStable
    (subspace : Submodule F2 (SixPointHeart × SixPointHeart))
    (stable : SixPointHeartPairGeneratorStable subspace) :
    SixPointHeartGeneratorStable (sixPointHeartPairFirstRange subspace) := by
  constructor
  · intro vector member
    rcases member with ⟨pair, pairMember, rfl⟩
    refine ⟨(Matrix.mulVec sixPointHeartTranslation pair.1,
      Matrix.mulVec sixPointHeartTranslation pair.2),
      stable.1 pair pairMember, rfl⟩
  · intro vector member
    rcases member with ⟨pair, pairMember, rfl⟩
    refine ⟨(Matrix.mulVec sixPointHeartInversion pair.1,
      Matrix.mulVec sixPointHeartInversion pair.2),
      stable.2 pair pairMember, rfl⟩

/-- Diagonal generator stability descends to the vertical part. -/
theorem sixPointHeartPairVerticalPart_generatorStable
    (subspace : Submodule F2 (SixPointHeart × SixPointHeart))
    (stable : SixPointHeartPairGeneratorStable subspace) :
    SixPointHeartGeneratorStable (sixPointHeartPairVerticalPart subspace) := by
  constructor
  · intro vector member
    change (0, vector) ∈ subspace at member
    change (0, Matrix.mulVec sixPointHeartTranslation vector) ∈ subspace
    simpa using stable.1 (0, vector) member
  · intro vector member
    change (0, vector) ∈ subspace at member
    change (0, Matrix.mulVec sixPointHeartInversion vector) ∈ subspace
    simpa using stable.2 (0, vector) member

/-- A stable pair subspace has simple first image and simple vertical part. -/
theorem sixPointHeartPair_projection_and_vertical_simple
    (subspace : Submodule F2 (SixPointHeart × SixPointHeart))
    (stable : SixPointHeartPairGeneratorStable subspace) :
    (sixPointHeartPairFirstRange subspace = ⊥ ∨
      sixPointHeartPairFirstRange subspace = ⊤) ∧
    (sixPointHeartPairVerticalPart subspace = ⊥ ∨
      sixPointHeartPairVerticalPart subspace = ⊤) :=
  ⟨sixPointHeartGeneratorStable_simple _
      (sixPointHeartPairFirstRange_generatorStable subspace stable),
    sixPointHeartGeneratorStable_simple _
      (sixPointHeartPairVerticalPart_generatorStable subspace stable)⟩

/-- The displayed candidate halves: the vertical copy and the graphs of the
four matrices in the quadratic commutant. -/
def SixPointHeartStableHalfPacket : Set
    (Submodule F2 (SixPointHeart × SixPointHeart)) :=
  {LinearMap.range (verticalEmbedding (K := F2) (H := SixPointHeart))} ∪
    {LinearMap.range (graphEmbedding (K := F2) (Matrix.toLin' (0 :
        Matrix (Fin 4) (Fin 4) F2))),
      LinearMap.range (graphEmbedding (K := F2) (Matrix.toLin' (1 :
        Matrix (Fin 4) (Fin 4) F2))),
      LinearMap.range (graphEmbedding (K := F2)
        (Matrix.toLin' sixPointHeartCommutantRoot)),
      LinearMap.range (graphEmbedding (K := F2)
        (Matrix.toLin' (sixPointHeartCommutantRoot + 1)))}

/-- The vertical copy of the coefficient heart is diagonally stable. -/
theorem sixPointHeartVertical_generatorStable :
    SixPointHeartPairGeneratorStable
      (LinearMap.range (verticalEmbedding (K := F2) (H := SixPointHeart))) := by
  constructor
  · rintro pair ⟨vector, rfl⟩
    refine ⟨Matrix.mulVec sixPointHeartTranslation vector, ?_⟩
    rfl
  · rintro pair ⟨vector, rfl⟩
    refine ⟨Matrix.mulVec sixPointHeartInversion vector, ?_⟩
    rfl

/-- A matrix commuting with both heart generators has a diagonally stable
graph. -/
theorem sixPointHeartGraph_generatorStable_of_commutes
    (matrix : Matrix (Fin 4) (Fin 4) F2)
    (commutes :
      matrix * sixPointHeartTranslation = sixPointHeartTranslation * matrix ∧
      matrix * sixPointHeartInversion = sixPointHeartInversion * matrix) :
    SixPointHeartPairGeneratorStable
      (LinearMap.range (graphEmbedding (K := F2) (Matrix.toLin' matrix))) := by
  constructor
  · rintro pair ⟨vector, rfl⟩
    refine ⟨Matrix.mulVec sixPointHeartTranslation vector, ?_⟩
    apply Prod.ext
    · rfl
    · simpa [graphEmbedding, Matrix.mulVec_mulVec] using
        congrArg (fun value => Matrix.mulVec value vector) commutes.1
  · rintro pair ⟨vector, rfl⟩
    refine ⟨Matrix.mulVec sixPointHeartInversion vector, ?_⟩
    apply Prod.ext
    · rfl
    · simpa [graphEmbedding, Matrix.mulVec_mulVec] using
        congrArg (fun value => Matrix.mulVec value vector) commutes.2

/-- Every displayed commutant graph is diagonally stable. -/
theorem sixPointHeartGraph_generatorStable_of_mem_commutant
    (matrix : Matrix (Fin 4) (Fin 4) F2)
    (member : matrix = 0 ∨ matrix = 1 ∨
      matrix = sixPointHeartCommutantRoot ∨
      matrix = sixPointHeartCommutantRoot + 1) :
    SixPointHeartPairGeneratorStable
      (LinearMap.range (graphEmbedding (K := F2) (Matrix.toLin' matrix))) :=
  sixPointHeartGraph_generatorStable_of_commutes matrix
    ((sixPointHeart_commonCommutant_classification matrix).mpr member)

/-- The vertical copy has the dimension of one coefficient heart. -/
theorem sixPointHeartVertical_finrank :
    Module.finrank F2
      (LinearMap.range (verticalEmbedding (K := F2) (H := SixPointHeart))) = 4 := by
  calc
    Module.finrank F2
        (LinearMap.range (verticalEmbedding (K := F2) (H := SixPointHeart))) =
        Module.finrank F2 SixPointHeart := by
      apply LinearMap.finrank_range_of_inj
      intro left right equality
      exact congrArg Prod.snd equality
    _ = 4 := by simp [SixPointHeart]

/-- Every displayed commutant graph has the dimension of one coefficient
heart. -/
theorem sixPointHeartGraph_finrank
    (matrix : Matrix (Fin 4) (Fin 4) F2) :
    Module.finrank F2
      (LinearMap.range (graphEmbedding (K := F2) (Matrix.toLin' matrix))) = 4 := by
  simpa [SixPointHeart] using
    finrank_graphEmbedding_range (K := F2) (H := SixPointHeart)
      (Matrix.toLin' matrix)

/-- The graph range determines its linear slope. -/
theorem sixPointHeartGraphRange_injective : Function.Injective
    (fun slope : SixPointHeart →ₗ[F2] SixPointHeart ↦
      LinearMap.range (graphEmbedding (K := F2) slope)) := by
  intro left right rangeEquality
  apply LinearMap.ext
  intro vector
  have member : graphEmbedding (K := F2) left vector ∈
      LinearMap.range (graphEmbedding (K := F2) right) := by
    have sourceMember : graphEmbedding (K := F2) left vector ∈
        LinearMap.range (graphEmbedding (K := F2) left) := ⟨vector, rfl⟩
    simpa only [rangeEquality] using sourceMember
  rcases member with ⟨preimage, equality⟩
  have firstEquality := congrArg Prod.fst equality
  have secondEquality := congrArg Prod.snd equality
  change preimage = vector at firstEquality
  change right preimage = left vector at secondEquality
  rw [firstEquality] at secondEquality
  exact secondEquality.symm

/-- The vertical range differs from every graph range. -/
theorem sixPointHeartVertical_ne_graphRange
    (slope : SixPointHeart →ₗ[F2] SixPointHeart) :
    LinearMap.range (verticalEmbedding (K := F2) (H := SixPointHeart)) ≠
      LinearMap.range (graphEmbedding (K := F2) slope) := by
  intro rangeEquality
  let vector : SixPointHeart := ![1, 0, 0, 0]
  have member : graphEmbedding (K := F2) slope vector ∈
      LinearMap.range (verticalEmbedding (K := F2) (H := SixPointHeart)) := by
    rw [rangeEquality]
    exact ⟨vector, rfl⟩
  rcases member with ⟨preimage, equality⟩
  have firstEquality := congrArg (fun pair : SixPointHeart × SixPointHeart =>
    pair.1 0) equality
  norm_num [verticalEmbedding, graphEmbedding, vector] at firstEquality

/-- Distinct matrices give distinct graph ranges. -/
theorem sixPointHeartMatrixGraphRange_ne
    {left right : Matrix (Fin 4) (Fin 4) F2} (different : left ≠ right) :
    LinearMap.range (graphEmbedding (K := F2) (Matrix.toLin' left)) ≠
      LinearMap.range (graphEmbedding (K := F2) (Matrix.toLin' right)) := by
  intro rangeEquality
  apply different
  apply Matrix.toLin'.injective
  exact sixPointHeartGraphRange_injective rangeEquality

/-- The displayed packet contains exactly five distinct subspaces. -/
theorem sixPointHeartStableHalfPacket_ncard :
    SixPointHeartStableHalfPacket.ncard = 5 := by
  classical
  let vertical := LinearMap.range
    (verticalEmbedding (K := F2) (H := SixPointHeart))
  let graphZero := LinearMap.range
    (graphEmbedding (K := F2)
      (Matrix.toLin' (0 : Matrix (Fin 4) (Fin 4) F2)))
  let graphOne := LinearMap.range
    (graphEmbedding (K := F2)
      (Matrix.toLin' (1 : Matrix (Fin 4) (Fin 4) F2)))
  let graphRoot := LinearMap.range
    (graphEmbedding (K := F2) (Matrix.toLin' sixPointHeartCommutantRoot))
  let graphRootOne := LinearMap.range
    (graphEmbedding (K := F2)
      (Matrix.toLin' (sixPointHeartCommutantRoot + 1)))
  have matrixZeroOne :
      (0 : Matrix (Fin 4) (Fin 4) F2) ≠ 1 := by decide
  have matrixZeroRoot :
      (0 : Matrix (Fin 4) (Fin 4) F2) ≠
        sixPointHeartCommutantRoot := by decide
  have matrixZeroRootOne :
      (0 : Matrix (Fin 4) (Fin 4) F2) ≠
        sixPointHeartCommutantRoot + 1 := by decide
  have matrixOneRoot :
      (1 : Matrix (Fin 4) (Fin 4) F2) ≠
        sixPointHeartCommutantRoot := by decide
  have matrixOneRootOne :
      (1 : Matrix (Fin 4) (Fin 4) F2) ≠
        sixPointHeartCommutantRoot + 1 := by decide
  have matrixRootRootOne :
      sixPointHeartCommutantRoot ≠
        sixPointHeartCommutantRoot + 1 := by decide
  have verticalNeZero : vertical ≠ graphZero := by
    exact sixPointHeartVertical_ne_graphRange _
  have verticalNeOne : vertical ≠ graphOne := by
    exact sixPointHeartVertical_ne_graphRange _
  have verticalNeRoot : vertical ≠ graphRoot := by
    exact sixPointHeartVertical_ne_graphRange _
  have verticalNeRootOne : vertical ≠ graphRootOne := by
    exact sixPointHeartVertical_ne_graphRange _
  have zeroNeOne : graphZero ≠ graphOne :=
    sixPointHeartMatrixGraphRange_ne matrixZeroOne
  have zeroNeRoot : graphZero ≠ graphRoot :=
    sixPointHeartMatrixGraphRange_ne matrixZeroRoot
  have zeroNeRootOne : graphZero ≠ graphRootOne :=
    sixPointHeartMatrixGraphRange_ne matrixZeroRootOne
  have oneNeRoot : graphOne ≠ graphRoot :=
    sixPointHeartMatrixGraphRange_ne matrixOneRoot
  have oneNeRootOne : graphOne ≠ graphRootOne :=
    sixPointHeartMatrixGraphRange_ne matrixOneRootOne
  have rootNeRootOne : graphRoot ≠ graphRootOne :=
    sixPointHeartMatrixGraphRange_ne matrixRootRootOne
  have verticalNotMem : vertical ∉
      ({graphZero, graphOne, graphRoot, graphRootOne} :
        Set (Submodule F2 (SixPointHeart × SixPointHeart))) := by
    simp [verticalNeZero, verticalNeOne, verticalNeRoot, verticalNeRootOne]
  have zeroNotMem : graphZero ∉
      ({graphOne, graphRoot, graphRootOne} :
        Set (Submodule F2 (SixPointHeart × SixPointHeart))) := by
    simp [zeroNeOne, zeroNeRoot, zeroNeRootOne]
  have oneNotMem : graphOne ∉
      ({graphRoot, graphRootOne} :
        Set (Submodule F2 (SixPointHeart × SixPointHeart))) := by
    simp [oneNeRoot, oneNeRootOne]
  have rootNotMem : graphRoot ∉
      ({graphRootOne} :
        Set (Submodule F2 (SixPointHeart × SixPointHeart))) := by
    simpa using rootNeRootOne
  change Set.ncard (insert vertical
    ({graphZero, graphOne, graphRoot, graphRootOne} :
      Set (Submodule F2 (SixPointHeart × SixPointHeart)))) = 5
  rw [Set.ncard_insert_of_notMem verticalNotMem (Set.toFinite _),
    Set.ncard_insert_of_notMem zeroNotMem (Set.toFinite _),
    Set.ncard_insert_of_notMem oneNotMem (Set.toFinite _),
    Set.ncard_insert_of_notMem rootNotMem (Set.toFinite _)]
  simp

/-- The four field elements label the four matrices in the quadratic
commutant, with the transported marked root sent to `W`. -/
noncomputable def sixPointHeartCommutantMatrixOfF4 (scalar : F4) :
    Matrix (Fin 4) (Fin 4) F2 := by
  classical
  exact if scalar = 0 then 0
    else if scalar = 1 then 1
    else if scalar = sixAxisQuadraticSlopeRootInF4 then
      sixPointHeartCommutantRoot
    else sixPointHeartCommutantRoot + 1

/-- The marked labels `0`, `1`, the transported root, and its conjugate map to
the four displayed commutant matrices. -/
theorem sixPointHeartCommutantMatrixOfF4_marked_values :
    sixPointHeartCommutantMatrixOfF4 0 = 0 ∧
    sixPointHeartCommutantMatrixOfF4 1 = 1 ∧
    sixPointHeartCommutantMatrixOfF4
        sixAxisQuadraticSlopeRootInF4 = sixPointHeartCommutantRoot ∧
    sixPointHeartCommutantMatrixOfF4
        (sixAxisQuadraticSlopeRootInF4 + 1) =
      sixPointHeartCommutantRoot + 1 := by
  letI : Algebra (ZMod 2) F4 :=
    FiniteField.instAlgebraExtension (ZMod 2) 2 2
  letI : CharP F4 2 :=
    charP_of_injective_algebraMap' (ZMod 2) 2
  let root := sixAxisQuadraticSlopeRootInF4
  have rootZero : root ≠ 0 :=
    sixAxisQuadraticSlopeRootInF4_equation_and_exotic.2.1
  have rootOne : root ≠ 1 :=
    sixAxisQuadraticSlopeRootInF4_equation_and_exotic.2.2
  have oneAddOne : (1 : F4) + 1 = 0 :=
    CharTwo.add_self_eq_zero 1
  have rootOneZero : root + 1 ≠ 0 := by
    intro equality
    apply rootOne
    have := congrArg (fun value : F4 => value + 1) equality
    simpa [add_assoc, oneAddOne] using this
  have rootOneOne : root + 1 ≠ 1 := by
    intro equality
    apply rootZero
    have := congrArg (fun value : F4 => value + 1) equality
    simpa [add_assoc, oneAddOne] using this
  have rootOneRoot : root + 1 ≠ root := by
    intro equality
    have := congrArg (fun value : F4 => value + root) equality
    simp [add_assoc] at this
  simp [sixPointHeartCommutantMatrixOfF4, root, rootZero, rootOne,
    rootOneZero, rootOneOne, rootOneRoot]

/-- The field labelling of the quadratic commutant is injective. -/
theorem sixPointHeartCommutantMatrixOfF4_injective :
    Function.Injective sixPointHeartCommutantMatrixOfF4 := by
  intro left right equality
  have matrixZeroOne :
      (0 : Matrix (Fin 4) (Fin 4) F2) ≠ 1 := by decide
  have matrixZeroRoot :
      (0 : Matrix (Fin 4) (Fin 4) F2) ≠
        sixPointHeartCommutantRoot := by decide
  have matrixZeroRootOne :
      (0 : Matrix (Fin 4) (Fin 4) F2) ≠
        sixPointHeartCommutantRoot + 1 := by decide
  have matrixOneRoot :
      (1 : Matrix (Fin 4) (Fin 4) F2) ≠
        sixPointHeartCommutantRoot := by decide
  have matrixOneRootOne :
      (1 : Matrix (Fin 4) (Fin 4) F2) ≠
        sixPointHeartCommutantRoot + 1 := by decide
  have matrixRootRootOne :
      sixPointHeartCommutantRoot ≠
        sixPointHeartCommutantRoot + 1 := by decide
  rcases f4_eq_zero_or_one_or_markedRoot_or_conjugate left with
    leftZero | leftOne | leftRoot | leftConjugate <;>
  rcases f4_eq_zero_or_one_or_markedRoot_or_conjugate right with
    rightZero | rightOne | rightRoot | rightConjugate <;>
  subst left <;> subst right
  all_goals
    simp only [sixPointHeartCommutantMatrixOfF4_marked_values.1,
      sixPointHeartCommutantMatrixOfF4_marked_values.2.1,
      sixPointHeartCommutantMatrixOfF4_marked_values.2.2.1,
      sixPointHeartCommutantMatrixOfF4_marked_values.2.2.2] at equality ⊢
  all_goals exfalso
  all_goals first
    | exact matrixZeroOne equality
    | exact matrixZeroOne equality.symm
    | exact matrixZeroRoot equality
    | exact matrixZeroRoot equality.symm
    | exact matrixZeroRootOne equality
    | exact matrixZeroRootOne equality.symm
    | exact matrixOneRoot equality
    | exact matrixOneRoot equality.symm
    | exact matrixOneRootOne equality
    | exact matrixOneRootOne equality.symm
    | exact matrixRootRootOne equality
    | exact matrixRootRootOne equality.symm

/-- The affine projective chart sends `none` to the vertical half and a scalar
to the graph of its labelled commutant matrix. -/
noncomputable def sixPointHeartStableHalfOfProjectiveChart :
    Option F4 → Submodule F2 (SixPointHeart × SixPointHeart)
  | none => LinearMap.range
      (verticalEmbedding (K := F2) (H := SixPointHeart))
  | some scalar => LinearMap.range
      (graphEmbedding (K := F2)
        (Matrix.toLin' (sixPointHeartCommutantMatrixOfF4 scalar)))

/-- Every affine-chart point labels a member of the stable-half packet. -/
theorem sixPointHeartStableHalfOfProjectiveChart_mem (point : Option F4) :
    sixPointHeartStableHalfOfProjectiveChart point ∈
      SixPointHeartStableHalfPacket := by
  cases point with
  | none => simp [sixPointHeartStableHalfOfProjectiveChart,
      SixPointHeartStableHalfPacket]
  | some scalar =>
      rcases f4_eq_zero_or_one_or_markedRoot_or_conjugate scalar with
        zero | one | root | conjugate <;> subst scalar <;>
      simp [sixPointHeartStableHalfOfProjectiveChart,
        SixPointHeartStableHalfPacket,
        sixPointHeartCommutantMatrixOfF4_marked_values]

/-- The affine-chart labelling of stable halves is injective. -/
theorem sixPointHeartStableHalfOfProjectiveChart_injective :
    Function.Injective sixPointHeartStableHalfOfProjectiveChart := by
  intro left right equality
  cases left with
  | none =>
      cases right with
      | none => rfl
      | some scalar =>
          exact (sixPointHeartVertical_ne_graphRange
            (Matrix.toLin' (sixPointHeartCommutantMatrixOfF4 scalar))
            equality).elim
  | some leftScalar =>
      cases right with
      | none =>
          exact (sixPointHeartVertical_ne_graphRange
            (Matrix.toLin' (sixPointHeartCommutantMatrixOfF4 leftScalar))
            equality.symm).elim
      | some rightScalar =>
          apply congrArg some
          apply sixPointHeartCommutantMatrixOfF4_injective
          apply Matrix.toLin'.injective
          exact sixPointHeartGraphRange_injective equality

/-- The chart labelling, regarded as a map into the subtype of packet
members. -/
noncomputable def sixPointHeartStableHalfPacketFromChart (point : Option F4) :
    {subspace // subspace ∈ SixPointHeartStableHalfPacket} :=
  ⟨sixPointHeartStableHalfOfProjectiveChart point,
    sixPointHeartStableHalfOfProjectiveChart_mem point⟩

/-- Every member of the stable-half packet has one of the five affine-chart
labels. -/
theorem sixPointHeartStableHalfPacketFromChart_surjective :
    Function.Surjective sixPointHeartStableHalfPacketFromChart := by
  intro target
  have member := target.property
  simp only [SixPointHeartStableHalfPacket, Set.mem_union,
    Set.mem_singleton_iff, Set.mem_insert_iff] at member
  rcases member with vertical | zero | one | root | rootOne
  · refine ⟨none, Subtype.ext ?_⟩
    simpa [sixPointHeartStableHalfPacketFromChart,
      sixPointHeartStableHalfOfProjectiveChart] using vertical.symm
  · refine ⟨some 0, Subtype.ext ?_⟩
    simpa [sixPointHeartStableHalfPacketFromChart,
      sixPointHeartStableHalfOfProjectiveChart,
      sixPointHeartCommutantMatrixOfF4_marked_values] using zero.symm
  · refine ⟨some 1, Subtype.ext ?_⟩
    simpa [sixPointHeartStableHalfPacketFromChart,
      sixPointHeartStableHalfOfProjectiveChart,
      sixPointHeartCommutantMatrixOfF4_marked_values] using one.symm
  · refine ⟨some sixAxisQuadraticSlopeRootInF4, Subtype.ext ?_⟩
    simpa [sixPointHeartStableHalfPacketFromChart,
      sixPointHeartStableHalfOfProjectiveChart,
      sixPointHeartCommutantMatrixOfF4_marked_values] using root.symm
  · refine ⟨some (sixAxisQuadraticSlopeRootInF4 + 1), Subtype.ext ?_⟩
    simpa [sixPointHeartStableHalfPacketFromChart,
      sixPointHeartStableHalfOfProjectiveChart,
      sixPointHeartCommutantMatrixOfF4_marked_values] using rootOne.symm

/-- The affine projective chart is explicitly equivalent to the stable-half
packet. -/
noncomputable def sixPointHeartProjectiveChartEquivStableHalfPacket :
    Option F4 ≃ {subspace // subspace ∈ SixPointHeartStableHalfPacket} :=
  Equiv.ofBijective sixPointHeartStableHalfPacketFromChart
    ⟨fun _ _ equality =>
      sixPointHeartStableHalfOfProjectiveChart_injective
        (congrArg Subtype.val equality),
      sixPointHeartStableHalfPacketFromChart_surjective⟩

/-- The actual projective line over `F4` is explicitly equivalent to the
stable-half packet through its vertical-plus-affine chart. -/
noncomputable def sixPointHeartProjectiveLineEquivStableHalfPacket :
    Projectivization F4 (F4 × F4) ≃
      {subspace // subspace ∈ SixPointHeartStableHalfPacket} :=
  (optionEquivProjectiveLine F4).symm.trans
    sixPointHeartProjectiveChartEquivStableHalfPacket

/-- The projective-chart equivalence sends the marked points to the vertical
half and the four displayed commutant graphs. -/
theorem sixPointHeartProjectiveChartEquivStableHalfPacket_marked_values :
    (sixPointHeartProjectiveChartEquivStableHalfPacket none).1 =
        LinearMap.range
          (verticalEmbedding (K := F2) (H := SixPointHeart)) ∧
    (sixPointHeartProjectiveChartEquivStableHalfPacket (some 0)).1 =
        LinearMap.range
          (graphEmbedding (K := F2)
            (Matrix.toLin' (0 : Matrix (Fin 4) (Fin 4) F2))) ∧
    (sixPointHeartProjectiveChartEquivStableHalfPacket (some 1)).1 =
        LinearMap.range
          (graphEmbedding (K := F2)
            (Matrix.toLin' (1 : Matrix (Fin 4) (Fin 4) F2))) ∧
    (sixPointHeartProjectiveChartEquivStableHalfPacket
        (some sixAxisQuadraticSlopeRootInF4)).1 =
        LinearMap.range
          (graphEmbedding (K := F2)
            (Matrix.toLin' sixPointHeartCommutantRoot)) ∧
    (sixPointHeartProjectiveChartEquivStableHalfPacket
        (some (sixAxisQuadraticSlopeRootInF4 + 1))).1 =
        LinearMap.range
          (graphEmbedding (K := F2)
            (Matrix.toLin' (sixPointHeartCommutantRoot + 1))) := by
  simp [sixPointHeartProjectiveChartEquivStableHalfPacket,
    sixPointHeartStableHalfPacketFromChart,
    sixPointHeartStableHalfOfProjectiveChart,
    sixPointHeartCommutantMatrixOfF4_marked_values]

/-- The alternating polarization form on two heart copies. -/
def sixPointHeartPairPolarizationForm
    (left right : SixPointHeart × SixPointHeart) : F2 :=
  sixPointHeartCoefficientForm left.1 right.2 +
    sixPointHeartCoefficientForm left.2 right.1

/-- The two-copy polarization pairing bundled as an `F₂`-bilinear form. -/
def sixPointHeartPairPolarizationBilinForm :
    LinearMap.BilinForm F2 (SixPointHeart × SixPointHeart) :=
  LinearMap.mk₂ F2 sixPointHeartPairPolarizationForm
    (by
      intro left₁ left₂ right
      simp [sixPointHeartPairPolarizationForm,
        sixPointHeartCoefficientForm_add_left]
      abel)
    (by
      intro scalar left right
      simp [sixPointHeartPairPolarizationForm,
        sixPointHeartCoefficientForm_smul_left, mul_add])
    (by
      intro left right₁ right₂
      simp [sixPointHeartPairPolarizationForm,
        sixPointHeartCoefficientForm_add_right]
      abel)
    (by
      intro scalar left right
      simp [sixPointHeartPairPolarizationForm,
        sixPointHeartCoefficientForm_smul_right, mul_add])

/-- Evaluation of the bundled two-copy form is the explicit polarization
pairing. -/
@[simp]
theorem sixPointHeartPairPolarizationBilinForm_apply
    (left right : SixPointHeart × SixPointHeart) :
    sixPointHeartPairPolarizationBilinForm left right =
      sixPointHeartPairPolarizationForm left right :=
  rfl

/-- The bundled two-copy polarization form is alternating. -/
theorem sixPointHeartPairPolarizationBilinForm_isAlt :
    sixPointHeartPairPolarizationBilinForm.IsAlt := by
  intro pair
  rw [sixPointHeartPairPolarizationBilinForm_apply]
  change sixPointHeartCoefficientForm pair.1 pair.2 +
    sixPointHeartCoefficientForm pair.2 pair.1 = 0
  rw [sixPointHeartCoefficientForm_comm pair.2 pair.1]
  exact sixAxisF2Module_add_self_eq_zero _

/-- The bundled two-copy polarization form is symmetric in characteristic
two. -/
theorem sixPointHeartPairPolarizationBilinForm_comm
    (left right : SixPointHeart × SixPointHeart) :
    sixPointHeartPairPolarizationBilinForm left right =
      sixPointHeartPairPolarizationBilinForm right left := by
  simp only [sixPointHeartPairPolarizationBilinForm_apply,
    sixPointHeartPairPolarizationForm]
  rw [sixPointHeartCoefficientForm_comm left.1 right.2,
    sixPointHeartCoefficientForm_comm left.2 right.1]
  exact add_comm _ _

/-- The two-copy polarization form is nondegenerate. -/
theorem sixPointHeartPairPolarizationBilinForm_nondegenerate :
    sixPointHeartPairPolarizationBilinForm.Nondegenerate := by
  constructor
  · intro pair annihilates
    apply Prod.ext
    · apply sixPointHeartCoefficientForm_nondegenerate pair.1
      intro test
      simpa [sixPointHeartPairPolarizationForm,
        sixPointHeartCoefficientForm_zero_left,
        sixPointHeartCoefficientForm_zero_right] using annihilates (0, test)
    · apply sixPointHeartCoefficientForm_nondegenerate pair.2
      intro test
      simpa [sixPointHeartPairPolarizationForm,
        sixPointHeartCoefficientForm_zero_left,
        sixPointHeartCoefficientForm_zero_right] using annihilates (test, 0)
  · intro pair annihilates
    apply Prod.ext
    · apply sixPointHeartCoefficientForm_nondegenerate pair.1
      intro test
      have evaluated : sixPointHeartCoefficientForm test pair.1 = 0 := by
        simpa [sixPointHeartPairPolarizationForm,
          sixPointHeartCoefficientForm_zero_left,
          sixPointHeartCoefficientForm_zero_right] using annihilates (0, test)
      rwa [sixPointHeartCoefficientForm_comm] at evaluated
    · apply sixPointHeartCoefficientForm_nondegenerate pair.2
      intro test
      have evaluated : sixPointHeartCoefficientForm test pair.2 = 0 := by
        simpa [sixPointHeartPairPolarizationForm,
          sixPointHeartCoefficientForm_zero_left,
          sixPointHeartCoefficientForm_zero_right] using annihilates (test, 0)
      rwa [sixPointHeartCoefficientForm_comm] at evaluated

/-- Every matrix in the quadratic commutant is self-adjoint for the explicit
heart coefficient form.  The zero and identity cases are symbolic; kernel
reduction checks all `16²` ordered heart-vector pairs for `W` and `W+1`. -/
theorem sixPointHeartCommutant_selfAdjoint
    (matrix : Matrix (Fin 4) (Fin 4) F2)
    (member : matrix = 0 ∨ matrix = 1 ∨
      matrix = sixPointHeartCommutantRoot ∨
      matrix = sixPointHeartCommutantRoot + 1)
    (left right : SixPointHeart) :
    sixPointHeartCoefficientForm (Matrix.mulVec matrix left) right =
      sixPointHeartCoefficientForm left (Matrix.mulVec matrix right) := by
  rcases member with zero | one | root | rootOne <;> subst matrix
  · simp [sixPointHeartCoefficientForm_zero_left,
      sixPointHeartCoefficientForm_zero_right]
  · simp [sixPointHeartCoefficientForm]
  · revert left right
    decide
  · revert left right
    decide

/-- Every displayed stable half is isotropic for the two-copy polarization
form. -/
theorem sixPointHeartStableHalfPacket_isotropic
    (subspace : Submodule F2 (SixPointHeart × SixPointHeart))
    (member : subspace ∈ SixPointHeartStableHalfPacket) :
    subspace ≤ sixPointHeartPairPolarizationBilinForm.orthogonal subspace := by
  simp only [SixPointHeartStableHalfPacket, Set.mem_union,
    Set.mem_singleton_iff, Set.mem_insert_iff] at member
  rcases member with vertical | zero | one | root | rootOne
  · subst subspace
    rintro _ ⟨left, rfl⟩ _ ⟨right, rfl⟩
    simp [sixPointHeartPairPolarizationForm, verticalEmbedding,
      sixPointHeartCoefficientForm_zero_left,
      sixPointHeartCoefficientForm_zero_right]
  all_goals
    subst subspace
    rintro _ ⟨left, rfl⟩ _ ⟨right, rfl⟩
    simp only [sixPointHeartPairPolarizationBilinForm_apply,
      sixPointHeartPairPolarizationForm, graphEmbedding,
      LinearMap.prod_apply, LinearMap.id_coe, Function.prod_apply,
      id_eq, Matrix.toLin'_apply]
  · rw [sixPointHeartCommutant_selfAdjoint 0 (Or.inl rfl)]
    exact sixAxisF2Module_add_self_eq_zero _
  · rw [sixPointHeartCommutant_selfAdjoint 1 (Or.inr (Or.inl rfl))]
    exact sixAxisF2Module_add_self_eq_zero _
  · rw [sixPointHeartCommutant_selfAdjoint sixPointHeartCommutantRoot
      (Or.inr (Or.inr (Or.inl rfl)))]
    exact sixAxisF2Module_add_self_eq_zero _
  · rw [sixPointHeartCommutant_selfAdjoint
      (sixPointHeartCommutantRoot + 1) (Or.inr (Or.inr (Or.inr rfl)))]
    exact sixAxisF2Module_add_self_eq_zero _

/-- Every member of the stable-half packet is maximal isotropic for the
explicit two-copy polarization form. -/
theorem sixPointHeartStableHalfPacket_maximalIsotropic
    (subspace : Submodule F2 (SixPointHeart × SixPointHeart))
    (member : subspace ∈ SixPointHeartStableHalfPacket) :
    IsMaximalIsotropic sixPointHeartPairPolarizationBilinForm subspace := by
  have finrankFour : Module.finrank F2 subspace = 4 := by
    have classified := member
    simp only [SixPointHeartStableHalfPacket, Set.mem_union,
      Set.mem_singleton_iff, Set.mem_insert_iff] at classified
    rcases classified with vertical | zero | one | root | rootOne
    · subst subspace
      exact sixPointHeartVertical_finrank
    · subst subspace
      exact sixPointHeartGraph_finrank 0
    · subst subspace
      exact sixPointHeartGraph_finrank 1
    · subst subspace
      exact sixPointHeartGraph_finrank sixPointHeartCommutantRoot
    · subst subspace
      exact sixPointHeartGraph_finrank (sixPointHeartCommutantRoot + 1)
  apply isMaximalIsotropic_of_isotropic_of_twice_finrank_eq
    sixPointHeartPairPolarizationBilinForm
    sixPointHeartPairPolarizationBilinForm_nondegenerate subspace
    (sixPointHeartStableHalfPacket_isotropic subspace member)
  rw [finrankFour, Module.finrank_prod]
  simp [SixPointHeart]

/-- Every four-dimensional diagonally stable subspace of two coefficient-heart
copies is one of the vertical half or the four quadratic-commutant graphs. -/
theorem sixPointHeartPair_stableHalf_classification
    (subspace : Submodule F2 (SixPointHeart × SixPointHeart))
    (stable : SixPointHeartPairGeneratorStable subspace)
    (halfDimension : Module.finrank F2 subspace = 4) :
    subspace ∈ SixPointHeartStableHalfPacket := by
  classical
  obtain ⟨firstRangeSimple, verticalPartSimple⟩ :=
    sixPointHeartPair_projection_and_vertical_simple subspace stable
  rcases firstRangeSimple with firstRangeZero | firstRangeFull
  · rcases verticalPartSimple with verticalPartZero | verticalPartFull
    · have subspaceZero : subspace = ⊥ := by
        apply bot_unique
        intro pair pairMember
        have firstMember : pair.1 ∈ sixPointHeartPairFirstRange subspace :=
          ⟨pair, pairMember, rfl⟩
        have firstZero : pair.1 = 0 := by
          have : pair.1 ∈ (⊥ : Submodule F2 SixPointHeart) := by
            simpa [firstRangeZero] using firstMember
          simpa using this
        have secondMember : pair.2 ∈
            sixPointHeartPairVerticalPart subspace := by
          change (0, pair.2) ∈ subspace
          have pairEquality : pair = (0, pair.2) := by
            apply Prod.ext firstZero
            rfl
          rwa [← pairEquality]
        have secondZero : pair.2 = 0 := by
          have : pair.2 ∈ (⊥ : Submodule F2 SixPointHeart) := by
            simpa [verticalPartZero] using secondMember
          simpa using this
        exact Prod.ext firstZero secondZero
      have impossible : False := by
        rw [subspaceZero] at halfDimension
        norm_num at halfDimension
      exact impossible.elim
    · have verticalEquality : subspace =
          LinearMap.range (verticalEmbedding (K := F2) (H := SixPointHeart)) := by
        ext pair
        constructor
        · intro pairMember
          have firstMember : pair.1 ∈ sixPointHeartPairFirstRange subspace :=
            ⟨pair, pairMember, rfl⟩
          have firstZero : pair.1 = 0 := by
            have : pair.1 ∈ (⊥ : Submodule F2 SixPointHeart) := by
              simpa [firstRangeZero] using firstMember
            simpa using this
          refine ⟨pair.2, ?_⟩
          ext <;> simp [verticalEmbedding, firstZero]
        · rintro ⟨vector, rfl⟩
          have vectorMember : vector ∈
              sixPointHeartPairVerticalPart subspace := by
            simp [verticalPartFull]
          exact vectorMember
      simp [SixPointHeartStableHalfPacket, verticalEquality]
  · rcases verticalPartSimple with verticalPartZero | verticalPartFull
    · let projection : subspace →ₗ[F2] SixPointHeart :=
        (LinearMap.fst F2 SixPointHeart SixPointHeart).domRestrict subspace
      have projectionInjective : Function.Injective projection := by
        intro left right equality
        apply Subtype.ext
        apply Prod.ext equality
        have differenceMember : left.1.2 - right.1.2 ∈
            sixPointHeartPairVerticalPart subspace := by
          change (0, left.1.2 - right.1.2) ∈ subspace
          have member := subspace.sub_mem left.2 right.2
          have pairEquality : left.1 - right.1 =
              (0, left.1.2 - right.1.2) := by
            apply Prod.ext
            · exact sub_eq_zero.mpr equality
            · rfl
          rwa [← pairEquality]
        have differenceZero : left.1.2 - right.1.2 = 0 := by
          have : left.1.2 - right.1.2 ∈
              (⊥ : Submodule F2 SixPointHeart) := by
            simpa [verticalPartZero] using differenceMember
          simpa using this
        exact sub_eq_zero.mp differenceZero
      have projectionSurjective : Function.Surjective projection := by
        intro vector
        have vectorMember : vector ∈ sixPointHeartPairFirstRange subspace := by
          simp [firstRangeFull]
        rcases vectorMember with ⟨pair, pairMember, equality⟩
        exact ⟨⟨pair, pairMember⟩, equality⟩
      let projectionEquiv : subspace ≃ₗ[F2] SixPointHeart :=
        LinearEquiv.ofBijective projection
          ⟨projectionInjective, projectionSurjective⟩
      let slope : SixPointHeart →ₗ[F2] SixPointHeart :=
        (LinearMap.snd F2 SixPointHeart SixPointHeart).comp
          (subspace.subtype.comp projectionEquiv.symm.toLinearMap)
      have graphValue (vector : SixPointHeart) :
          (projectionEquiv.symm vector :
              subspace).1 = graphEmbedding (K := F2) slope vector := by
        apply Prod.ext
        · exact projectionEquiv.apply_symm_apply vector
        · rfl
      have subspaceGraph : subspace =
          LinearMap.range (graphEmbedding (K := F2) slope) := by
        ext pair
        constructor
        · intro pairMember
          let member : subspace := ⟨pair, pairMember⟩
          refine ⟨pair.1, ?_⟩
          rw [← graphValue]
          have subtypeEquality : projectionEquiv.symm pair.1 = member := by
            apply projectionEquiv.injective
            exact projectionEquiv.apply_symm_apply pair.1
          exact congrArg Subtype.val subtypeEquality
        · rintro ⟨vector, rfl⟩
          rw [← graphValue]
          exact (projectionEquiv.symm vector).2
      have slopeCommutes
          (generator : Matrix (Fin 4) (Fin 4) F2)
          (generatorStable : ∀ pair ∈ subspace,
            (Matrix.mulVec generator pair.1,
              Matrix.mulVec generator pair.2) ∈ subspace)
          (vector : SixPointHeart) :
          slope (Matrix.mulVec generator vector) =
            Matrix.mulVec generator (slope vector) := by
        let lifted : subspace := projectionEquiv.symm vector
        let acted : subspace :=
          ⟨(Matrix.mulVec generator lifted.1.1,
              Matrix.mulVec generator lifted.1.2),
            generatorStable lifted.1 lifted.2⟩
        have actedEquality : acted =
            projectionEquiv.symm (Matrix.mulVec generator vector) := by
          apply projectionInjective
          calc
            projection acted = Matrix.mulVec generator vector := by
              change Matrix.mulVec generator lifted.1.1 =
                Matrix.mulVec generator vector
              rw [show lifted.1.1 = vector by
                exact projectionEquiv.apply_symm_apply vector]
            _ = projection
                (projectionEquiv.symm (Matrix.mulVec generator vector)) := by
              exact (projectionEquiv.apply_symm_apply _).symm
        have secondEquality := congrArg (fun value : subspace => value.1.2)
          actedEquality
        change Matrix.mulVec generator lifted.1.2 =
          slope (Matrix.mulVec generator vector) at secondEquality
        have liftedSecond : lifted.1.2 = slope vector := by
          have := congrArg Prod.snd (graphValue vector)
          exact this
        rw [liftedSecond] at secondEquality
        exact secondEquality.symm
      let slopeMatrix : Matrix (Fin 4) (Fin 4) F2 :=
        LinearMap.toMatrix' slope
      have matrixCommutesTranslation :
          slopeMatrix * sixPointHeartTranslation =
            sixPointHeartTranslation * slopeMatrix := by
        apply Matrix.toLin'.injective
        apply LinearMap.ext
        intro vector
        simpa [slopeMatrix] using
          slopeCommutes sixPointHeartTranslation stable.1 vector
      have matrixCommutesInversion :
          slopeMatrix * sixPointHeartInversion =
            sixPointHeartInversion * slopeMatrix := by
        apply Matrix.toLin'.injective
        apply LinearMap.ext
        intro vector
        simpa [slopeMatrix] using
          slopeCommutes sixPointHeartInversion stable.2 vector
      have matrixClassification :=
        (sixPointHeart_commonCommutant_classification slopeMatrix).mp
          ⟨matrixCommutesTranslation, matrixCommutesInversion⟩
      have slopeFromMatrix : Matrix.toLin' slopeMatrix = slope := by
        simp [slopeMatrix]
      rcases matrixClassification with
          matrixZero | matrixOne | matrixRoot | matrixRootOne
      · have graphZero : subspace = LinearMap.range
            (graphEmbedding (K := F2) (Matrix.toLin' (0 :
              Matrix (Fin 4) (Fin 4) F2))) := by
          rw [subspaceGraph, ← slopeFromMatrix, matrixZero]
        simp [SixPointHeartStableHalfPacket, graphZero]
      · have graphOne : subspace = LinearMap.range
            (graphEmbedding (K := F2) (Matrix.toLin' (1 :
              Matrix (Fin 4) (Fin 4) F2))) := by
          rw [subspaceGraph, ← slopeFromMatrix, matrixOne]
        simp [SixPointHeartStableHalfPacket, graphOne]
      · have graphRoot : subspace = LinearMap.range
            (graphEmbedding (K := F2)
              (Matrix.toLin' sixPointHeartCommutantRoot)) := by
          rw [subspaceGraph, ← slopeFromMatrix, matrixRoot]
        simp [SixPointHeartStableHalfPacket, graphRoot]
      · have graphRootOne : subspace = LinearMap.range
            (graphEmbedding (K := F2)
              (Matrix.toLin' (sixPointHeartCommutantRoot + 1))) := by
          rw [subspaceGraph, ← slopeFromMatrix, matrixRootOne]
        simp [SixPointHeartStableHalfPacket, graphRootOne]
    · have subspaceFull : subspace = ⊤ := by
        apply top_unique
        intro pair _
        have firstMember : pair.1 ∈ sixPointHeartPairFirstRange subspace := by
          simp [firstRangeFull]
        rcases firstMember with ⟨lift, liftMember, firstEquality⟩
        have verticalMember : pair.2 - lift.2 ∈
            sixPointHeartPairVerticalPart subspace := by
          simp [verticalPartFull]
        change (0, pair.2 - lift.2) ∈ subspace at verticalMember
        have sumMember := subspace.add_mem liftMember verticalMember
        have pairEquality : lift + (0, pair.2 - lift.2) = pair := by
          apply Prod.ext
          · simpa using firstEquality
          · simp
        rwa [pairEquality] at sumMember
      have impossible : False := by
        rw [subspaceFull] at halfDimension
        norm_num [Module.finrank_prod] at halfDimension
      exact impossible.elim

/-- Membership in the displayed packet is equivalent to being a
four-dimensional diagonally stable subspace. -/
theorem sixPointHeartStableHalfPacket_iff
    (subspace : Submodule F2 (SixPointHeart × SixPointHeart)) :
    subspace ∈ SixPointHeartStableHalfPacket ↔
      SixPointHeartPairGeneratorStable subspace ∧
        Module.finrank F2 subspace = 4 := by
  constructor
  · intro member
    simp only [SixPointHeartStableHalfPacket, Set.mem_union,
      Set.mem_singleton_iff, Set.mem_insert_iff] at member
    rcases member with vertical | zero | one | root | rootOne
    · subst subspace
      exact ⟨sixPointHeartVertical_generatorStable,
        sixPointHeartVertical_finrank⟩
    · subst subspace
      exact ⟨sixPointHeartGraph_generatorStable_of_mem_commutant 0
          (Or.inl rfl),
        sixPointHeartGraph_finrank 0⟩
    · subst subspace
      exact ⟨sixPointHeartGraph_generatorStable_of_mem_commutant 1
          (Or.inr (Or.inl rfl)),
        sixPointHeartGraph_finrank 1⟩
    · subst subspace
      exact ⟨sixPointHeartGraph_generatorStable_of_mem_commutant
          sixPointHeartCommutantRoot (Or.inr (Or.inr (Or.inl rfl))),
        sixPointHeartGraph_finrank sixPointHeartCommutantRoot⟩
    · subst subspace
      exact ⟨sixPointHeartGraph_generatorStable_of_mem_commutant
          (sixPointHeartCommutantRoot + 1) (Or.inr (Or.inr (Or.inr rfl))),
        sixPointHeartGraph_finrank (sixPointHeartCommutantRoot + 1)⟩
  · rintro ⟨stable, halfDimension⟩
    exact sixPointHeartPair_stableHalf_classification
      subspace stable halfDimension

/-- A maximal isotropic subspace for the explicit nondegenerate alternating
form has dimension four. -/
theorem sixPointHeartPairPolarization_maximalIsotropic_finrank
    (subspace : Submodule F2 (SixPointHeart × SixPointHeart))
    (maximal :
      IsMaximalIsotropic sixPointHeartPairPolarizationBilinForm subspace) :
    Module.finrank F2 subspace = 4 := by
  have orthogonalLe :
      sixPointHeartPairPolarizationBilinForm.orthogonal subspace ≤
        subspace := by
    by_contra notLe
    have unequal : subspace ≠
        sixPointHeartPairPolarizationBilinForm.orthogonal subspace := by
      intro equality
      apply notLe
      rw [← equality]
    have strict : subspace <
        sixPointHeartPairPolarizationBilinForm.orthogonal subspace :=
      lt_of_le_of_ne maximal.1 unequal
    obtain ⟨vector, vectorOrthogonal, vectorOutside⟩ :=
      SetLike.exists_of_lt strict
    let larger : Submodule F2 (SixPointHeart × SixPointHeart) :=
      subspace ⊔ F2 ∙ vector
    have contains : subspace ≤ larger := le_sup_left
    have largerIsotropic :
        larger ≤ sixPointHeartPairPolarizationBilinForm.orthogonal larger := by
      intro left leftMember right rightMember
      obtain ⟨leftBase, leftBaseMember, leftSpan, leftSpanMember, rfl⟩ :=
        Submodule.mem_sup.mp leftMember
      obtain ⟨rightBase, rightBaseMember, rightSpan, rightSpanMember, rfl⟩ :=
        Submodule.mem_sup.mp rightMember
      obtain ⟨leftScalar, rfl⟩ :=
        Submodule.mem_span_singleton.mp leftSpanMember
      obtain ⟨rightScalar, rfl⟩ :=
        Submodule.mem_span_singleton.mp rightSpanMember
      have baseBase :
          sixPointHeartPairPolarizationBilinForm rightBase leftBase = 0 :=
        maximal.1 leftBaseMember rightBase rightBaseMember
      have baseVector :
          sixPointHeartPairPolarizationBilinForm rightBase vector = 0 :=
        vectorOrthogonal rightBase rightBaseMember
      have vectorBase :
          sixPointHeartPairPolarizationBilinForm vector leftBase = 0 := by
        rw [sixPointHeartPairPolarizationBilinForm_comm]
        exact vectorOrthogonal leftBase leftBaseMember
      have vectorVector :
          sixPointHeartPairPolarizationBilinForm vector vector = 0 :=
        sixPointHeartPairPolarizationBilinForm_isAlt vector
      simp only [map_add, map_smul, LinearMap.add_apply,
        LinearMap.smul_apply, baseBase, baseVector, vectorBase,
        vectorVector, smul_zero, add_zero]
    have largerEquality := maximal.2 larger contains largerIsotropic
    have vectorLarger : vector ∈ larger :=
      Submodule.mem_sup_right
        (Submodule.mem_span_singleton_self vector)
    exact vectorOutside (by simpa [largerEquality] using vectorLarger)
  have orthogonalEquality :
      sixPointHeartPairPolarizationBilinForm.orthogonal subspace =
        subspace :=
    le_antisymm orthogonalLe maximal.1
  have rankEquality :=
    sixPointHeartPairPolarizationBilinForm.finrank_orthogonal
      sixPointHeartPairPolarizationBilinForm_nondegenerate subspace
  rw [orthogonalEquality] at rankEquality
  have ambientRank :
      Module.finrank F2 (SixPointHeart × SixPointHeart) = 8 := by
    simp [SixPointHeart, Module.finrank_prod]
  omega

/-- The five displayed halves are exactly the diagonally stable maximal
isotropic subspaces for the explicit two-copy polarization. -/
theorem sixPointHeartStableHalfPacket_iff_stable_maximalIsotropic
    (subspace : Submodule F2 (SixPointHeart × SixPointHeart)) :
    subspace ∈ SixPointHeartStableHalfPacket ↔
      SixPointHeartPairGeneratorStable subspace ∧
        IsMaximalIsotropic
          sixPointHeartPairPolarizationBilinForm subspace := by
  constructor
  · intro member
    exact ⟨(sixPointHeartStableHalfPacket_iff subspace).mp member |>.1,
      sixPointHeartStableHalfPacket_maximalIsotropic subspace member⟩
  · rintro ⟨stable, maximal⟩
    exact (sixPointHeartStableHalfPacket_iff subspace).mpr
      ⟨stable,
        sixPointHeartPairPolarization_maximalIsotropic_finrank subspace maximal⟩

/-- Choosing the standard symplectic basis of the two-dimensional torsion
factor identifies the rank-eight discriminant coordinates with two copies of
the six-point coefficient heart. -/
def sixAxisStandardDiscriminantPairLinearEquiv :
    SixAxisStandardDiscriminantCoordinates ≃ₗ[F2]
      (SixPointHeart × SixPointHeart) where
  toFun vector :=
    (sixAxisStandardDiscriminantFirst vector,
      sixAxisStandardDiscriminantSecond vector)
  invFun pair :=
    sixAxisStandardDiscriminantOfFirst pair.1 +
      sixAxisStandardDiscriminantOfSecond pair.2
  left_inv vector := by
    funext index coordinate
    fin_cases coordinate <;>
      simp [sixAxisStandardDiscriminantFirst,
        sixAxisStandardDiscriminantSecond,
        sixAxisStandardDiscriminantOfFirst,
        sixAxisStandardDiscriminantOfSecond]
  right_inv pair := by
    ext index <;>
      simp [sixAxisStandardDiscriminantFirst,
        sixAxisStandardDiscriminantSecond,
        sixAxisStandardDiscriminantOfFirst,
        sixAxisStandardDiscriminantOfSecond]
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- The standard tensor-product discriminant form becomes the explicit
two-heart polarization form under the chosen-coordinate equivalence. -/
theorem sixAxisStandardDiscriminantPairLinearEquiv_preserves_form
    (left right : SixAxisStandardDiscriminantCoordinates) :
    sixPointHeartPairPolarizationBilinForm
        (sixAxisStandardDiscriminantPairLinearEquiv left)
        (sixAxisStandardDiscriminantPairLinearEquiv right) =
      sixAxisStandardDiscriminantBilinForm left right :=
  rfl

/-- Diagonal generator stability for a subspace of the standard
discriminant coordinates, transported to the two-heart model. -/
def SixAxisStandardDiscriminantGeneratorStable
    (subspace : Submodule F2 SixAxisStandardDiscriminantCoordinates) : Prop :=
  SixPointHeartPairGeneratorStable
    (subspace.map sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap)

/-- Maximal isotropy is invariant under the chosen symplectic coordinate
equivalence between the standard discriminant and the two-heart model. -/
theorem sixAxisStandardDiscriminant_maximalIsotropic_iff_pair
    (subspace : Submodule F2 SixAxisStandardDiscriminantCoordinates) :
    IsMaximalIsotropic sixAxisStandardDiscriminantBilinForm subspace ↔
      IsMaximalIsotropic sixPointHeartPairPolarizationBilinForm
        (subspace.map sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap) := by
  constructor
  · rintro ⟨isotropic, maximal⟩
    constructor
    · intro left leftMember right rightMember
      obtain ⟨leftPreimage, leftPreimageMember, rfl⟩ := leftMember
      obtain ⟨rightPreimage, rightPreimageMember, rfl⟩ := rightMember
      change sixAxisStandardDiscriminantBilinForm
        rightPreimage leftPreimage = 0
      exact isotropic leftPreimageMember rightPreimage rightPreimageMember
    · intro larger contains largerIsotropic
      let preimage := larger.comap
        sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap
      have preimageContains : subspace ≤ preimage := by
        intro vector vectorMember
        exact contains (Submodule.mem_map_of_mem vectorMember)
      have preimageIsotropic :
          preimage ≤ sixAxisStandardDiscriminantBilinForm.orthogonal preimage := by
        intro left leftMember right rightMember
        have mappedLeft :
            sixAxisStandardDiscriminantPairLinearEquiv left ∈ larger := leftMember
        have mappedRight :
            sixAxisStandardDiscriminantPairLinearEquiv right ∈ larger := rightMember
        have mappedZero := largerIsotropic mappedLeft
          (sixAxisStandardDiscriminantPairLinearEquiv right) mappedRight
        change sixAxisStandardDiscriminantBilinForm right left = 0 at mappedZero
        exact mappedZero
      have preimageEquality := maximal preimage preimageContains preimageIsotropic
      ext vector
      constructor
      · intro vectorMember
        have preimageMember :
            sixAxisStandardDiscriminantPairLinearEquiv.symm vector ∈ preimage := by
          change sixAxisStandardDiscriminantPairLinearEquiv
              (sixAxisStandardDiscriminantPairLinearEquiv.symm vector) ∈ larger
          simpa using vectorMember
        have sourceMember :
            sixAxisStandardDiscriminantPairLinearEquiv.symm vector ∈ subspace := by
          rw [← preimageEquality]
          exact preimageMember
        exact Submodule.mem_map.mpr
          ⟨sixAxisStandardDiscriminantPairLinearEquiv.symm vector,
            sourceMember, by simp⟩
      · intro vectorMember
        exact contains vectorMember
  · rintro ⟨isotropic, maximal⟩
    constructor
    · intro left leftMember right rightMember
      have mappedLeft :
          sixAxisStandardDiscriminantPairLinearEquiv left ∈
            subspace.map sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap :=
        Submodule.mem_map_of_mem leftMember
      have mappedRight :
          sixAxisStandardDiscriminantPairLinearEquiv right ∈
            subspace.map sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap :=
        Submodule.mem_map_of_mem rightMember
      have mappedZero := isotropic mappedLeft
        (sixAxisStandardDiscriminantPairLinearEquiv right) mappedRight
      change sixAxisStandardDiscriminantBilinForm right left = 0 at mappedZero
      exact mappedZero
    · intro larger contains largerIsotropic
      let image := larger.map
        sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap
      have imageContains :
          subspace.map sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap ≤ image :=
        Submodule.map_mono contains
      have imageIsotropic :
          image ≤ sixPointHeartPairPolarizationBilinForm.orthogonal image := by
        intro left leftMember right rightMember
        obtain ⟨leftPreimage, leftPreimageMember, rfl⟩ := leftMember
        obtain ⟨rightPreimage, rightPreimageMember, rfl⟩ := rightMember
        change sixAxisStandardDiscriminantBilinForm
          rightPreimage leftPreimage = 0
        exact largerIsotropic leftPreimageMember
          rightPreimage rightPreimageMember
      have imageEquality := maximal image imageContains imageIsotropic
      apply le_antisymm
      · intro vector vectorMember
        have mappedMember :
            sixAxisStandardDiscriminantPairLinearEquiv vector ∈ image :=
          Submodule.mem_map_of_mem vectorMember
        rw [imageEquality] at mappedMember
        obtain ⟨source, sourceMember, sourceEquality⟩ := mappedMember
        have sourceEqualsVector :=
          sixAxisStandardDiscriminantPairLinearEquiv.injective sourceEquality
        exact sourceEqualsVector ▸ sourceMember
      · exact contains

/-- The five transported projective-line halves are exactly the diagonally
stable maximal-isotropic subspaces of the standard rank-eight discriminant. -/
theorem sixAxisStandardDiscriminant_stablePacket_iff
    (subspace : Submodule F2 SixAxisStandardDiscriminantCoordinates) :
    subspace.map sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap ∈
        SixPointHeartStableHalfPacket ↔
      SixAxisStandardDiscriminantGeneratorStable subspace ∧
        IsMaximalIsotropic sixAxisStandardDiscriminantBilinForm subspace := by
  rw [sixPointHeartStableHalfPacket_iff_stable_maximalIsotropic]
  exact and_congr_right fun _ ↦
    sixAxisStandardDiscriminant_maximalIsotropic_iff_pair subspace |>.symm

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
