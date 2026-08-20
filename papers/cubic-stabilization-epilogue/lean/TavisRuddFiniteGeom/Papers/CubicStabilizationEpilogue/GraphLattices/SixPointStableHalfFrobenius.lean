import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixPointStableHalves

/-!
# Frobenius marking of the stable halves of the six-point coefficient heart

The diagonally stable four-dimensional subspaces of two copies of the explicit
characteristic-two coefficient heart form a five-member packet: the vertical
copy and the graphs of the four matrices `0`, `1`, `W`, `W+1` of the quadratic
commutant, labelled by the affine chart `Option F4` of the projective line over
the field with four elements.  The commutant is a field with four elements, and
its Frobenius automorphism — squaring — permutes the labels.  This module
transports that permutation to the packet and computes its fixed locus.

The transported involution fixes exactly three members, the vertical copy and
the two graphs of the prime-field slopes `0` and `1`, and exchanges the two
remaining members, the graphs of `W` and `W+1`.  Those two are called the
exotic pair below.  On graphs the involution squares the slope, and the slope of
either exotic member has minimal polynomial `t²+t+1` over the field with two
elements, so it generates a quadratic finite-etale extension.

Marking a subspace means asserting that it is moved by this involution.  For a
packet member that assertion is equivalent to membership in the exotic pair, so
it is the selection criterion that distinguishes those two members from the
three defined over the prime field; no strengthening of a hypothesis of
stability under the packet-preserving group can make that distinction, since
every packet member is stable by construction.

Trust boundary.  Everything here is about explicit `F₂`-valued matrices and
subspaces and about the concrete four-element field of the labelling.  No
geometric isogeny kernel, torsion group scheme, Galois action, or arithmetic
Frobenius of an actual family is constructed, and nothing identifies this
involution with a geometric normalizer element.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

open Polynomial

noncomputable section

/-- The two exotic members of the stable-half packet: the graphs of the two
commutant matrices annihilated by `t²+t+1`. -/
def SixPointHeartExoticHalfPair :
    Set (Submodule F2 (SixPointHeart × SixPointHeart)) :=
  {LinearMap.range (graphEmbedding (K := F2)
      (Matrix.toLin' sixPointHeartCommutantRoot)),
    LinearMap.range (graphEmbedding (K := F2)
      (Matrix.toLin' (sixPointHeartCommutantRoot + 1)))}

/-- The three members of the stable-half packet defined over the prime field:
the vertical copy and the graphs of the two prime-field slopes. -/
def SixPointHeartPrimeFieldHalfTriple :
    Set (Submodule F2 (SixPointHeart × SixPointHeart)) :=
  {LinearMap.range (verticalEmbedding (K := F2) (H := SixPointHeart)),
    LinearMap.range (graphEmbedding (K := F2)
      (Matrix.toLin' (0 : Matrix (Fin 4) (Fin 4) F2))),
    LinearMap.range (graphEmbedding (K := F2)
      (Matrix.toLin' (1 : Matrix (Fin 4) (Fin 4) F2)))}

/-- The five affine-chart labels name the vertical copy and the four commutant
graphs. -/
theorem sixPointHeartStableHalfOfProjectiveChart_values :
    sixPointHeartStableHalfOfProjectiveChart none =
        LinearMap.range (verticalEmbedding (K := F2) (H := SixPointHeart)) ∧
      sixPointHeartStableHalfOfProjectiveChart (some 0) =
        LinearMap.range (graphEmbedding (K := F2)
          (Matrix.toLin' (0 : Matrix (Fin 4) (Fin 4) F2))) ∧
      sixPointHeartStableHalfOfProjectiveChart (some 1) =
        LinearMap.range (graphEmbedding (K := F2)
          (Matrix.toLin' (1 : Matrix (Fin 4) (Fin 4) F2))) ∧
      sixPointHeartStableHalfOfProjectiveChart
          (some sixAxisQuadraticSlopeRootInF4) =
        LinearMap.range (graphEmbedding (K := F2)
          (Matrix.toLin' sixPointHeartCommutantRoot)) ∧
      sixPointHeartStableHalfOfProjectiveChart
          (some (sixAxisQuadraticSlopeRootInF4 + 1)) =
        LinearMap.range (graphEmbedding (K := F2)
          (Matrix.toLin' (sixPointHeartCommutantRoot + 1))) := by
  refine ⟨rfl, ?_, ?_, ?_, ?_⟩ <;>
    simp only [sixPointHeartStableHalfOfProjectiveChart,
      sixPointHeartCommutantMatrixOfF4_marked_values.1,
      sixPointHeartCommutantMatrixOfF4_marked_values.2.1,
      sixPointHeartCommutantMatrixOfF4_marked_values.2.2.1,
      sixPointHeartCommutantMatrixOfF4_marked_values.2.2.2]

/-- A chart label names a prime-field member exactly when it is the vertical
label or one of the two prime-field scalars. -/
theorem sixPointHeartStableHalfOfProjectiveChart_mem_primeFieldTriple_iff
    (point : Option F4) :
    sixPointHeartStableHalfOfProjectiveChart point ∈
        SixPointHeartPrimeFieldHalfTriple ↔
      point = none ∨ point = some 0 ∨ point = some 1 := by
  obtain ⟨vertical, zero, one, _, _⟩ :=
    sixPointHeartStableHalfOfProjectiveChart_values
  constructor
  · intro membership
    simp only [SixPointHeartPrimeFieldHalfTriple, Set.mem_insert_iff,
      Set.mem_singleton_iff] at membership
    rcases membership with atVertical | atZero | atOne
    · exact Or.inl (sixPointHeartStableHalfOfProjectiveChart_injective
        (atVertical.trans vertical.symm))
    · exact Or.inr (Or.inl (sixPointHeartStableHalfOfProjectiveChart_injective
        (atZero.trans zero.symm)))
    · exact Or.inr (Or.inr (sixPointHeartStableHalfOfProjectiveChart_injective
        (atOne.trans one.symm)))
  · rintro (rfl | rfl | rfl) <;>
      simp only [SixPointHeartPrimeFieldHalfTriple, Set.mem_insert_iff,
        Set.mem_singleton_iff]
    · exact Or.inl vertical
    · exact Or.inr (Or.inl zero)
    · exact Or.inr (Or.inr one)

/-- A chart label names an exotic member exactly when it is the transported
marked quadratic root or its conjugate. -/
theorem sixPointHeartStableHalfOfProjectiveChart_mem_exoticPair_iff
    (point : Option F4) :
    sixPointHeartStableHalfOfProjectiveChart point ∈
        SixPointHeartExoticHalfPair ↔
      point = some sixAxisQuadraticSlopeRootInF4 ∨
        point = some (sixAxisQuadraticSlopeRootInF4 + 1) := by
  obtain ⟨_, _, _, root, conjugate⟩ :=
    sixPointHeartStableHalfOfProjectiveChart_values
  constructor
  · intro membership
    simp only [SixPointHeartExoticHalfPair, Set.mem_insert_iff,
      Set.mem_singleton_iff] at membership
    rcases membership with atRoot | atConjugate
    · exact Or.inl (sixPointHeartStableHalfOfProjectiveChart_injective
        (atRoot.trans root.symm))
    · exact Or.inr (sixPointHeartStableHalfOfProjectiveChart_injective
        (atConjugate.trans conjugate.symm))
  · rintro (rfl | rfl) <;>
      simp only [SixPointHeartExoticHalfPair, Set.mem_insert_iff,
        Set.mem_singleton_iff]
    · exact Or.inl root
    · exact Or.inr conjugate

/-- Frobenius of the labelling field, transported to the five-member packet of
diagonally stable halves through the affine-chart equivalence. -/
def sixPointHeartStableHalfPacketFrobenius
    (member : {subspace // subspace ∈ SixPointHeartStableHalfPacket}) :
    {subspace // subspace ∈ SixPointHeartStableHalfPacket} :=
  sixPointHeartProjectiveChartEquivStableHalfPacket
    (f4ProjectiveFrobenius
      (sixPointHeartProjectiveChartEquivStableHalfPacket.symm member))

/-- On a labelled member the transported involution applies Frobenius to the
label. -/
theorem sixPointHeartStableHalfPacketFrobenius_chart (point : Option F4) :
    sixPointHeartStableHalfPacketFrobenius
        (sixPointHeartProjectiveChartEquivStableHalfPacket point) =
      sixPointHeartProjectiveChartEquivStableHalfPacket
        (f4ProjectiveFrobenius point) := by
  unfold sixPointHeartStableHalfPacketFrobenius
  rw [Equiv.symm_apply_apply]

/-- The subspace named by a chart label. -/
theorem sixPointHeartProjectiveChartEquivStableHalfPacket_val
    (point : Option F4) :
    (sixPointHeartProjectiveChartEquivStableHalfPacket point).1 =
      sixPointHeartStableHalfOfProjectiveChart point :=
  rfl

/-- The transported involution is an involution. -/
theorem sixPointHeartStableHalfPacketFrobenius_involutive :
    Function.Involutive sixPointHeartStableHalfPacketFrobenius := by
  intro member
  obtain ⟨point, rfl⟩ :=
    sixPointHeartProjectiveChartEquivStableHalfPacket.surjective member
  rw [sixPointHeartStableHalfPacketFrobenius_chart,
    sixPointHeartStableHalfPacketFrobenius_chart,
    f4ProjectiveFrobenius_involutive point]

/-- The fixed members of the transported involution are exactly the three
members defined over the prime field. -/
theorem sixPointHeartStableHalfPacketFrobenius_fixed_iff
    (member : {subspace // subspace ∈ SixPointHeartStableHalfPacket}) :
    sixPointHeartStableHalfPacketFrobenius member = member ↔
      member.1 ∈ SixPointHeartPrimeFieldHalfTriple := by
  obtain ⟨point, rfl⟩ :=
    sixPointHeartProjectiveChartEquivStableHalfPacket.surjective member
  rw [sixPointHeartStableHalfPacketFrobenius_chart,
    sixPointHeartProjectiveChartEquivStableHalfPacket_val,
    sixPointHeartStableHalfOfProjectiveChart_mem_primeFieldTriple_iff,
    ← f4ProjectiveFrobenius_fixed_iff point]
  exact ⟨fun equality ↦
      sixPointHeartProjectiveChartEquivStableHalfPacket.injective equality,
    fun equality ↦ congrArg sixPointHeartProjectiveChartEquivStableHalfPacket
      equality⟩

/-- The members moved by the transported involution are exactly the two exotic
members. -/
theorem sixPointHeartStableHalfPacketFrobenius_nonfixed_iff_exotic
    (member : {subspace // subspace ∈ SixPointHeartStableHalfPacket}) :
    sixPointHeartStableHalfPacketFrobenius member ≠ member ↔
      member.1 ∈ SixPointHeartExoticHalfPair := by
  obtain ⟨point, rfl⟩ :=
    sixPointHeartProjectiveChartEquivStableHalfPacket.surjective member
  rw [sixPointHeartStableHalfPacketFrobenius_chart,
    sixPointHeartProjectiveChartEquivStableHalfPacket_val,
    sixPointHeartStableHalfOfProjectiveChart_mem_exoticPair_iff,
    ← f4ProjectiveFrobenius_nonfixed_iff_markedProjectivePair point]
  exact ⟨fun moved equality ↦
      moved (congrArg sixPointHeartProjectiveChartEquivStableHalfPacket
        equality),
    fun moved equality ↦ moved
      (sixPointHeartProjectiveChartEquivStableHalfPacket.injective equality)⟩

/-- The transported involution exchanges the two exotic members. -/
theorem sixPointHeartStableHalfPacketFrobenius_exchanges_exoticPair :
    (sixPointHeartStableHalfPacketFrobenius
        (sixPointHeartProjectiveChartEquivStableHalfPacket
          (some sixAxisQuadraticSlopeRootInF4))).1 =
        LinearMap.range (graphEmbedding (K := F2)
          (Matrix.toLin' (sixPointHeartCommutantRoot + 1))) ∧
      (sixPointHeartStableHalfPacketFrobenius
          (sixPointHeartProjectiveChartEquivStableHalfPacket
            (some (sixAxisQuadraticSlopeRootInF4 + 1)))).1 =
        LinearMap.range (graphEmbedding (K := F2)
          (Matrix.toLin' sixPointHeartCommutantRoot)) := by
  obtain ⟨_, _, _, root, conjugate⟩ :=
    sixPointHeartStableHalfOfProjectiveChart_values
  constructor
  · rw [sixPointHeartStableHalfPacketFrobenius_chart,
      sixPointHeartProjectiveChartEquivStableHalfPacket_val,
      sixAxisQuadraticSlope_markedProjectivePair.1]
    exact conjugate
  · rw [sixPointHeartStableHalfPacketFrobenius_chart,
      sixPointHeartProjectiveChartEquivStableHalfPacket_val,
      sixAxisQuadraticSlope_markedProjectivePair.2.1]
    exact root

/-- The square of the distinguished commutant element is its conjugate. -/
theorem sixPointHeartCommutantRoot_sq :
    sixPointHeartCommutantRoot ^ 2 = sixPointHeartCommutantRoot + 1 := by
  ext row column
  fin_cases row <;> fin_cases column <;> decide

/-- The square of the conjugate commutant element is the distinguished one. -/
theorem sixPointHeartCommutantRootConjugate_sq :
    (sixPointHeartCommutantRoot + 1) ^ 2 = sixPointHeartCommutantRoot := by
  ext row column
  fin_cases row <;> fin_cases column <;> decide

/-- The conjugate commutant element satisfies the same irreducible quadratic
relation. -/
theorem sixPointHeartCommutantRootConjugate_quadratic :
    (sixPointHeartCommutantRoot + 1) ^ 2 + (sixPointHeartCommutantRoot + 1) +
      1 = 0 := by
  ext row column
  fin_cases row <;> fin_cases column <;> decide

/-- Frobenius of the labelling field squares the labelled commutant matrix, so
the transported involution squares the slope of a graph member. -/
theorem sixPointHeartCommutantMatrixOfF4_frobenius (scalar : F4) :
    sixPointHeartCommutantMatrixOfF4 (f4Frobenius scalar) =
      sixPointHeartCommutantMatrixOfF4 scalar ^ 2 := by
  obtain ⟨zero, one, root, conjugate⟩ :=
    sixPointHeartCommutantMatrixOfF4_marked_values
  have frobeniusRoot : f4Frobenius sixAxisQuadraticSlopeRootInF4 =
      sixAxisQuadraticSlopeRootInF4 + 1 :=
    sixAxisQuadraticSlopeRootInF4_frobenius_eq_add_one
  have frobeniusConjugate :
      f4Frobenius (sixAxisQuadraticSlopeRootInF4 + 1) =
        sixAxisQuadraticSlopeRootInF4 := by
    have involution := f4Frobenius_involutive sixAxisQuadraticSlopeRootInF4
    rwa [frobeniusRoot] at involution
  rcases f4_eq_zero_or_one_or_markedRoot_or_conjugate scalar with
    atZero | atOne | atRoot | atConjugate <;> subst scalar
  · rw [show f4Frobenius (0 : F4) = 0 by simp [f4Frobenius], zero]
    simp
  · rw [show f4Frobenius (1 : F4) = 1 by simp [f4Frobenius], one]
    simp
  · rw [frobeniusRoot, conjugate, root, sixPointHeartCommutantRoot_sq]
  · rw [frobeniusConjugate, root, conjugate,
      sixPointHeartCommutantRootConjugate_sq]

/-- The distinguished commutant element is annihilated by the irreducible
quadratic polynomial under matrix evaluation. -/
theorem sixPointHeartCommutantRoot_aeval :
    aeval sixPointHeartCommutantRoot sixAxisQuadraticSlopePolynomial = 0 := by
  simpa [sixAxisQuadraticSlopePolynomial] using
    sixPointHeartCommutantRoot_quadratic

/-- The conjugate commutant element is annihilated by the same polynomial. -/
theorem sixPointHeartCommutantRootConjugate_aeval :
    aeval (sixPointHeartCommutantRoot + 1) sixAxisQuadraticSlopePolynomial =
      0 := by
  simpa [sixAxisQuadraticSlopePolynomial] using
    sixPointHeartCommutantRootConjugate_quadratic

/-- The distinguished commutant element has minimal polynomial `t²+t+1` over
the field with two elements. -/
theorem sixPointHeartCommutantRoot_minpoly :
    minpoly F2 sixPointHeartCommutantRoot = sixAxisQuadraticSlopePolynomial :=
  (minpoly.eq_of_irreducible_of_monic
    sixAxisQuadraticSlopePolynomial_irreducible
    sixPointHeartCommutantRoot_aeval
    sixAxisQuadraticSlopePolynomial_monic).symm

/-- The conjugate commutant element has the same minimal polynomial. -/
theorem sixPointHeartCommutantRootConjugate_minpoly :
    minpoly F2 (sixPointHeartCommutantRoot + 1) =
      sixAxisQuadraticSlopePolynomial :=
  (minpoly.eq_of_irreducible_of_monic
    sixAxisQuadraticSlopePolynomial_irreducible
    sixPointHeartCommutantRootConjugate_aeval
    sixAxisQuadraticSlopePolynomial_monic).symm

/-- Either exotic member is the graph of a slope whose minimal polynomial over
the field with two elements is the irreducible quadratic `t²+t+1`, so the
algebra generated by that slope is a quadratic finite-etale extension. -/
theorem sixPointHeartExoticHalfPair_graphSlope
    {subspace : Submodule F2 (SixPointHeart × SixPointHeart)}
    (member : subspace ∈ SixPointHeartExoticHalfPair) :
    ∃ slope : Matrix (Fin 4) (Fin 4) F2,
      subspace = LinearMap.range (graphEmbedding (K := F2)
          (Matrix.toLin' slope)) ∧
        slope ^ 2 + slope + 1 = 0 ∧
        minpoly F2 slope = sixAxisQuadraticSlopePolynomial := by
  simp only [SixPointHeartExoticHalfPair, Set.mem_insert_iff,
    Set.mem_singleton_iff] at member
  rcases member with rfl | rfl
  · exact ⟨sixPointHeartCommutantRoot, rfl,
      sixPointHeartCommutantRoot_quadratic,
      sixPointHeartCommutantRoot_minpoly⟩
  · exact ⟨sixPointHeartCommutantRoot + 1, rfl,
      sixPointHeartCommutantRootConjugate_quadratic,
      sixPointHeartCommutantRootConjugate_minpoly⟩

/-- Frobenius marking of a stable half of the coefficient heart: whenever the
subspace is a member of the five-member packet, its packet class is moved by the
transported Frobenius involution. -/
def SixPointHeartFrobeniusMarked
    (subspace : Submodule F2 (SixPointHeart × SixPointHeart)) : Prop :=
  ∀ member : subspace ∈ SixPointHeartStableHalfPacket,
    sixPointHeartStableHalfPacketFrobenius ⟨subspace, member⟩ ≠
      ⟨subspace, member⟩

/-- For a packet member, Frobenius marking is exactly membership in the exotic
pair.  This is the selection criterion: the three members defined over the prime
field are fixed, so a marked member is one of the two exotic graphs. -/
theorem sixPointHeartFrobeniusMarked_iff_exotic
    {subspace : Submodule F2 (SixPointHeart × SixPointHeart)}
    (member : subspace ∈ SixPointHeartStableHalfPacket) :
    SixPointHeartFrobeniusMarked subspace ↔
      subspace ∈ SixPointHeartExoticHalfPair := by
  constructor
  · intro marked
    exact (sixPointHeartStableHalfPacketFrobenius_nonfixed_iff_exotic
      ⟨subspace, member⟩).mp (marked member)
  · intro exotic other
    exact (sixPointHeartStableHalfPacketFrobenius_nonfixed_iff_exotic
      ⟨subspace, other⟩).mpr exotic

/-- A marked packet member is the graph of a slope with minimal polynomial
`t²+t+1`. -/
theorem sixPointHeartFrobeniusMarked_graphSlope
    {subspace : Submodule F2 (SixPointHeart × SixPointHeart)}
    (member : subspace ∈ SixPointHeartStableHalfPacket)
    (marked : SixPointHeartFrobeniusMarked subspace) :
    ∃ slope : Matrix (Fin 4) (Fin 4) F2,
      subspace = LinearMap.range (graphEmbedding (K := F2)
          (Matrix.toLin' slope)) ∧
        slope ^ 2 + slope + 1 = 0 ∧
        minpoly F2 slope = sixAxisQuadraticSlopePolynomial :=
  sixPointHeartExoticHalfPair_graphSlope
    ((sixPointHeartFrobeniusMarked_iff_exotic member).mp marked)

end

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
