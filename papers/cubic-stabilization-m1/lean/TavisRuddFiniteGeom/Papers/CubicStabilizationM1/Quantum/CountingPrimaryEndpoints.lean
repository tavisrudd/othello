import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SeventeenExactSignatures
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ExactPrimaryOccurrenceDescent

/-!
# Actual primary-block endpoint expressions for the counting labels

Rank-two endpoints carry an adapted paired connection identified with the
actual zero block of a complete normalized counting-system gauge. Their
exact signatures follow from the computed elementary-modification residues.
Rank-three endpoints have full odd ranks 104, 60, 40 and 28; simple factors
are represented by rank-one blocks with zero odd part. The resulting block
multisets have precisely the seventeen computed exact signatures.

Geometric identification of these full block multisets and the four odd
ranks is an explicit realization input. A signature equality is derived
from the connections and block expressions, rather than supplied as input.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- An adapted paired rank-two factor realized by the zero block of an
actual normalized gauge of one of the nine counting systems. -/
structure RankTwoCountingEndpoint (label : RankTwoCountingLabel) where
  connection : AdaptedRankTwoConnection ℚ
  gauge : ℕ → Matrix (Fin 4) (Fin 4) ℚ
  reduced : ℕ → Matrix (Fin 4) (Fin 4) ℚ
  normalized : IsNormalizedGauge twoByTwoBlockLabel
    (invertibleComplementSystem label.complementTrace label.complementParameter
      (rankTwoCountingRegular label)) gauge reduced
  loopIdentification : connection.loop=lastRankTwoBlockSeries reduced

/-- The exact atom of an actual endpoint connection is computed from its
normalized gauge, including the nonzero resonant discriminant one. -/
theorem RankTwoCountingEndpoint.atom_eq
    {label : RankTwoCountingLabel} (endpoint : RankTwoCountingEndpoint label) :
    rankTwoExactSpectrumAtom endpoint.connection.loop=
      exactDiscriminantAtom (residueDiscriminant (rankTwoCountingResidue label)) := by
  unfold rankTwoExactSpectrumAtom
  rw [endpoint.loopIdentification,
    invertibleComplementNormalizedGauge_modifiedResidue label.complementTrace
      (rankTwoCounting_complement_nonzero label) (rankTwoCountingRegular label) endpoint.normalized]
  rfl

/-- A rank-two endpoint consists of the actual paired zero block and two
rank-one simple complementary factors. -/
def RankTwoCountingEndpoint.blocks
    {label : RankTwoCountingLabel} (endpoint : RankTwoCountingEndpoint label) :
    Multiset (ExactPrimaryBlock ℚ) :=
  {.rankTwo endpoint.connection, pointPrimaryBlock, pointPrimaryBlock}

/-- The full block expression has the computed rank-two exact signature. -/
theorem RankTwoCountingEndpoint.weight_eq
    {label : RankTwoCountingLabel} (endpoint : RankTwoCountingEndpoint label) :
    primaryBlockMultisetWeight endpoint.blocks=rankTwoCountingExactSignature label := by
  simp [blocks, primaryBlockMultisetWeight, ExactPrimaryBlock.weight, pointPrimaryBlock,
    endpoint.atom_eq, rankTwoCountingExactSignature]

/-- A full rank-three factor with the stated full odd dimension,
plus its rank-one complementary factor. -/
def rankThreeEndpointBlocks (oddRank : ℕ) : Multiset (ExactPrimaryBlock ℚ) :=
  {.other 3 oddRank (by decide), pointPrimaryBlock}

/-- The rank-three block expression contributes exactly its full odd dimension. -/
theorem rankThreeEndpointBlocks_weight (oddRank : ℕ) :
    primaryBlockMultisetWeight (rankThreeEndpointBlocks oddRank)=(0,oddRank) := by
  simp [rankThreeEndpointBlocks, primaryBlockMultisetWeight, ExactPrimaryBlock.weight, pointPrimaryBlock]

/-- Four simple rank-one factors form the simple-spectrum endpoint expression. -/
def simpleCountingEndpointBlocks : Multiset (ExactPrimaryBlock ℚ) :=
  {pointPrimaryBlock,pointPrimaryBlock,pointPrimaryBlock,pointPrimaryBlock}

/-- Simple-spectrum endpoints have zero exact-primary weight. -/
theorem simpleCountingEndpointBlocks_weight :
    primaryBlockMultisetWeight simpleCountingEndpointBlocks=0 := by
  simp [simpleCountingEndpointBlocks, primaryBlockMultisetWeight, ExactPrimaryBlock.weight, pointPrimaryBlock]

/-- The full primary block expressions for all seventeen counting labels,
using actual normalized rank-two endpoint connections. -/
def countingEndpointBlocks (rankTwo : ∀ label, RankTwoCountingEndpoint label) :
    CountingMatrixLabel → Multiset (ExactPrimaryBlock ℚ)
  | .genus2 => rankThreeEndpointBlocks 104
  | .genus3 => rankThreeEndpointBlocks 60
  | .genus4 => rankThreeEndpointBlocks 40
  | .genus5 => rankThreeEndpointBlocks 28
  | .genus6 => (rankTwo .genus6).blocks
  | .genus7 => (rankTwo .genus7).blocks
  | .genus8 => (rankTwo .genus8).blocks
  | .genus9 => (rankTwo .genus9).blocks
  | .genus10 => (rankTwo .genus10).blocks
  | .degree1 => (rankTwo .degree1).blocks
  | .degree2 => (rankTwo .degree2).blocks
  | .degree3 => (rankTwo .degree3).blocks
  | .degree4 => (rankTwo .degree4).blocks
  | .genus12 | .degree5 | .quadric | .projectiveSpace => simpleCountingEndpointBlocks

/-- Every endpoint signature is derived from its actual block expression. -/
theorem countingEndpointBlocks_weight
    (rankTwo : ∀ label, RankTwoCountingEndpoint label) (label : CountingMatrixLabel) :
    primaryBlockMultisetWeight (countingEndpointBlocks rankTwo label)=countingExactSignature label := by
  cases label <;> simp only [countingEndpointBlocks, countingExactSignature,
    rankThreeEndpointBlocks_weight, RankTwoCountingEndpoint.weight_eq, simpleCountingEndpointBlocks_weight]

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
