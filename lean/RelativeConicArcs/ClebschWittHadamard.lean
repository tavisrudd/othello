import RelativeConicArcs.ClebschWittHadamardData
import Mathlib.Tactic

/-!
# Finite checks for the ternary Witt--Hadamard configuration

This definitions-only module supplies reducible evaluators and checker predicates for a six-row
ternary generator matrix and explicit degree-twelve permutations.  Separate native-evaluation
leaves exhaustively prove the code, incidence, design, secant, Hadamard, and permutation-action
claims.  The large permutation closures are deliberately not assigned classical group names.

The code has 729 words.  Its 264 minimum words give 132 six-subset supports; exhaustive checking
shows that every five-subset lies in exactly one support.  Its 24 full-support words form twelve
projective sign rows, and the 66 secants of those rows exhaust the 132 projective minimum words.
-/

namespace RelativeConicArcs
namespace ClebschWittHadamard

open scoped BigOperators

set_option maxRecDepth 100000
set_option synthInstance.maxSize 10000

/-- The codeword with coefficient vector `a`. -/
def codeword (a : Fin 6 → F3) : Word12 :=
  fun j => ∑ i, a i * generatorMatrix i j

/-- The explicitly enumerated ternary linear code. -/
def codewords : Finset Word12 :=
  Finset.univ.image codeword

/-- The Hamming support of a word. -/
def support (v : Word12) : Finset (Fin 12) :=
  Finset.univ.filter fun i => v i ≠ 0

/-- The Hamming weight of a word. -/
def weight (v : Word12) : Nat := (support v).card

/-- Delete the distinguished parity coordinate. -/
def puncture (v : Word12) : Fin 11 → F3 :=
  fun i => v i.castSucc

/-- The punctured eleven-coordinate code. -/
def puncturedCodewords : Finset (Fin 11 → F3) :=
  codewords.image puncture

/-- Hamming weight on eleven coordinates. -/
def puncturedWeight (v : Fin 11 → F3) : Nat :=
  (Finset.univ.filter fun i => v i ≠ 0).card

/-- A projective point represented as its two nonzero scalar multiples over `F_3`. -/
def projectivePair (v : Word12) : Finset Word12 := {v, -v}

/-- The six-subset supports of the minimum words. -/
def hexads : Finset (Finset (Fin 12)) :=
  (codewords.filter fun v => weight v = 6).image support

/-- The projective minimum-word points. -/
def minimumProjectivePoints : Finset (Finset Word12) :=
  (codewords.filter fun v => weight v = 6).image projectivePair

/-- Convert an integer sign to its ternary residue. -/
def signToF3 (x : Int) : F3 := x

/-- A sign-matrix row regarded as a ternary word. -/
def hadamardWord (i : Fin 12) : Word12 :=
  fun j => signToF3 (hadamardSign i j)

/-- The twelve projective full-support points represented by the sign rows. -/
def fullSupportPoints : Finset (Finset Word12) :=
  Finset.univ.image fun i : Fin 12 => projectivePair (hadamardWord i)

/-- The two interior projective points on the line through two distinct sign rows. -/
def secantInterior (i j : Fin 12) : Finset (Finset Word12) :=
  {projectivePair (hadamardWord i + hadamardWord j),
   projectivePair (hadamardWord i - hadamardWord j)}

/-- The 66 unordered pairs of sign rows. -/
def rowPairs : Finset (Finset (Fin 12)) :=
  Finset.univ.filter fun e => e.card = 2

/-- All projective interior points on the sign-row secants. -/
def secantInteriorPoints : Finset (Finset Word12) :=
  rowPairs.biUnion fun e =>
    if h : e.card = 2 then
      secantInterior (e.orderIsoOfFin h 0) (e.orderIsoOfFin h 1)
    else ∅

/-- Translate the frozen quadratic-residue block in the cyclic group of order eleven. -/
def residueTranslate (i : Fin 11) : Finset (Fin 11) :=
  residueBlock.image fun x => x + i

/-- The eleven cyclic incidence blocks. -/
def residueBlocks : Finset (Finset (Fin 11)) :=
  Finset.univ.image residueTranslate

/-- Periodic correlation of a length-eleven integer word. -/
def periodicCorrelation (b : Fin 11 → Int) (d : Fin 11) : Int :=
  ∑ i, b i * b (i + d)

/-- The incidence sign word attached to the residue block. -/
def residueSign (i : Fin 11) : Int :=
  if i ∈ residueBlock then -1 else 1

/-- Aperiodic correlation of the normalized length-eleven Barker word. -/
def barkerAperiodicCorrelation (d : Fin 11) : Int :=
  ((List.range (11 - d.val)).map fun i =>
    barkerWord.getD i 0 * barkerWord.getD (i + d.val) 0).sum

/-- Permute coordinates by pulling a word back along `p`. -/
def permuteWord (p : Perm12) (v : Word12) : Word12 :=
  fun i => ∑ j, if p j = i then v j else 0

/-- Signed coordinate action in old-to-new image convention. -/
def signedPermuteWord (p : Perm12) (signs v : Word12) : Word12 :=
  fun i => ∑ j, if p j = i then signs j * v j else 0

/-- Image of a support under a degree-twelve permutation. -/
def permuteSupport (p : Perm12) (s : Finset (Fin 12)) : Finset (Fin 12) :=
  s.image p

/-- Composition in image-list convention. -/
def compPerm (p q : Perm12) : Perm12 := fun i => p (q i)

/-- Simultaneous one-step expansion of a point orbit under two generators. -/
def pointOrbitStep (generators : Fin 2 → Perm12) (s : Finset (Fin 12)) :
    Finset (Fin 12) :=
  s ∪ s.biUnion fun i => Finset.univ.image fun g : Fin 2 => generators g i

/-- A bounded point orbit; twelve rounds suffice for every displayed action. -/
def pointOrbit (generators : Fin 2 → Perm12) (seed : Fin 12) : Finset (Fin 12) :=
  ((pointOrbitStep generators)^[12]) {seed}

/-- A degree-twelve map is a permutation when its image contains all twelve points. -/
def isPermutation (p : Perm12) : Bool :=
  (Finset.univ.image p).card == 12

/-- A 48-bit packed image representation used by the large finite-action checker. -/
abbrev PermutationKey := UInt64

/-- Convert a displayed degree-twelve map to its packed image key. -/
def permutationKey (p : Perm12) : PermutationKey :=
  (List.range 12).foldl (fun key i =>
    key + UInt64.shiftLeft (UInt64.ofNat (p ⟨i % 12, Nat.mod_lt _ (by omega)⟩).val)
      (UInt64.ofNat (4 * i))) 0

/-- Identity packed image key. -/
def identityKey : PermutationKey :=
  permutationKey fun i => i

/-- Extract one image from a packed key. -/
def keyAt (p : PermutationKey) (i : Nat) : Nat :=
  ((UInt64.shiftRight p (UInt64.ofNat (4 * i))) &&& 15).toNat

/-- Place one four-bit image in a packed key. -/
def packedImage (x i : Nat) : PermutationKey :=
  UInt64.shiftLeft (UInt64.ofNat x) (UInt64.ofNat (4 * i))

/-- Composition of two packed image keys. -/
def composeKey (p q : PermutationKey) : PermutationKey :=
  packedImage (keyAt p (keyAt q 0)) 0 +
  packedImage (keyAt p (keyAt q 1)) 1 +
  packedImage (keyAt p (keyAt q 2)) 2 +
  packedImage (keyAt p (keyAt q 3)) 3 +
  packedImage (keyAt p (keyAt q 4)) 4 +
  packedImage (keyAt p (keyAt q 5)) 5 +
  packedImage (keyAt p (keyAt q 6)) 6 +
  packedImage (keyAt p (keyAt q 7)) 7 +
  packedImage (keyAt p (keyAt q 8)) 8 +
  packedImage (keyAt p (keyAt q 9)) 9 +
  packedImage (keyAt p (keyAt q 10)) 10 +
  packedImage (keyAt p (keyAt q 11)) 11

/-- Explicit positive-word closure of a generator array. -/
def generatorClosure (generators : Array PermutationKey) : Std.HashSet PermutationKey := Id.run do
  let mut seen : Std.HashSet PermutationKey := {identityKey}
  let mut todo : Array PermutationKey := #[identityKey]
  while !todo.isEmpty do
    let p := todo.back!
    todo := todo.pop
    for g in generators do
      let q := composeKey p g
      if !seen.contains q then
        seen := seen.insert q
        todo := todo.push q
  return seen

/-- Convert a pair of displayed generators to image-list form. -/
def generatorKeys (generators : Fin 2 → Perm12) : Array PermutationKey :=
  #[permutationKey (generators 0), permutationKey (generators 1)]

/-- Positive-word closure of the two displayed frozen generators. -/
def frozenClosure : Std.HashSet PermutationKey :=
  generatorClosure (generatorKeys frozenGenerators)

/-- Positive-word closure of the transitive parent generators. -/
def transitiveParentClosure : Std.HashSet PermutationKey :=
  generatorClosure (generatorKeys transitiveParentGenerators)

/-- Positive-word closure of the parent generators fixing the parity coordinate. -/
def fixedPointParentClosure : Std.HashSet PermutationKey :=
  generatorClosure (generatorKeys fixedPointParentGenerators)

/-- Positive-word closure of the full minimum-support design generators. -/
def designClosure : Std.HashSet PermutationKey :=
  generatorClosure (generatorKeys designGenerators)

/-- The group generated jointly by the two parent generator pairs. -/
def parentJoinClosure : Std.HashSet PermutationKey :=
  generatorClosure (generatorKeys transitiveParentGenerators ++
    generatorKeys fixedPointParentGenerators)

/-- The row action transported to the coordinate carrier. -/
def alignedRowGenerator (g : Fin 2) : Perm12 :=
  compPerm rowCarrierRelabellingInverse
    (compPerm (rowGenerators g) rowCarrierRelabelling)

/-- Positive-word closure of the row generators transported to the coordinate carrier. -/
def alignedRowClosure : Std.HashSet PermutationKey :=
  generatorClosure (generatorKeys alignedRowGenerator)

/-- Simultaneous word closure of the coordinate generators and their aligned row images.

The two projections record the same positive word in the source and target generators.  Equality
of the pair-closure size with both projection sizes certifies that the generator assignment is a
well-defined bijection, rather than merely an equality between two generated subgroups. -/
structure GeneratorAssignmentClosure where
  pairs : Std.HashSet (PermutationKey × PermutationKey)
  forward : Std.HashMap PermutationKey PermutationKey
  reverse : Std.HashMap PermutationKey PermutationKey
  consistent : Bool

/-- Enumerate the graph generated by corresponding source and target generator pairs, stopping
immediately if it exceeds the claimed 95,040-element domain. -/
def generatorAssignmentClosure
    (source target : Array PermutationKey) : GeneratorAssignmentClosure := Id.run do
  let identityPair := (identityKey, identityKey)
  let mut pairs : Std.HashSet (PermutationKey × PermutationKey) := {identityPair}
  let mut forward : Std.HashMap PermutationKey PermutationKey :=
    ({} : Std.HashMap PermutationKey PermutationKey).insert identityKey identityKey
  let mut reverse : Std.HashMap PermutationKey PermutationKey :=
    ({} : Std.HashMap PermutationKey PermutationKey).insert identityKey identityKey
  let mut consistent := true
  let mut todo : Array (PermutationKey × PermutationKey) := #[identityPair]
  while !todo.isEmpty && pairs.size ≤ 95040 do
    let p := todo.back!
    todo := todo.pop
    for i in [0 : source.size] do
      if _h : i < target.size then
        let q := (composeKey p.1 source[i]!, composeKey p.2 target[i]!)
        if !pairs.contains q then
          pairs := pairs.insert q
          todo := todo.push q
          match forward[q.1]? with
          | some image => if image != q.2 then consistent := false
          | none => forward := forward.insert q.1 q.2
          match reverse[q.2]? with
          | some preimage => if preimage != q.1 then consistent := false
          | none => reverse := reverse.insert q.2 q.1
  return ⟨pairs, forward, reverse, consistent⟩

/-- Graph of the row/column generator assignment on the full design closure. -/
def rowColumnAssignmentClosure : GeneratorAssignmentClosure :=
  generatorAssignmentClosure (generatorKeys designGenerators)
    (generatorKeys alignedRowGenerator)

/-- Preimage of one point, with malformed missing images sent to zero. -/
def keyPreimage (x : PermutationKey) (i : Nat) : Nat :=
  if keyAt x 0 = i then 0 else if keyAt x 1 = i then 1 else
  if keyAt x 2 = i then 2 else if keyAt x 3 = i then 3 else
  if keyAt x 4 = i then 4 else if keyAt x 5 = i then 5 else
  if keyAt x 6 = i then 6 else if keyAt x 7 = i then 7 else
  if keyAt x 8 = i then 8 else if keyAt x 9 = i then 9 else
  if keyAt x 10 = i then 10 else if keyAt x 11 = i then 11 else 0

/-- Inverse of a packed permutation key, with malformed missing images sent to zero. -/
def inverseKey (x : PermutationKey) : PermutationKey :=
  packedImage (keyPreimage x 0) 0 +
  packedImage (keyPreimage x 1) 1 +
  packedImage (keyPreimage x 2) 2 +
  packedImage (keyPreimage x 3) 3 +
  packedImage (keyPreimage x 4) 4 +
  packedImage (keyPreimage x 5) 5 +
  packedImage (keyPreimage x 6) 6 +
  packedImage (keyPreimage x 7) 7 +
  packedImage (keyPreimage x 8) 8 +
  packedImage (keyPreimage x 9) 9 +
  packedImage (keyPreimage x 10) 10 +
  packedImage (keyPreimage x 11) 11

/-- Conjugation of packed image keys. -/
def conjugateKey (x g : PermutationKey) : PermutationKey :=
  composeKey x (composeKey g (inverseKey x))

/-- Finite graph criterion for the row/column generator assignment to be a bijective
automorphism whose square is the displayed inner conjugation. -/
abbrev rowColumnAssignmentChecks : Prop :=
  let assignment := rowColumnAssignmentClosure
  let image := fun x =>
    match assignment.forward[x]? with
    | some y => y
    | none => identityKey
  assignment.pairs.size = 95040 ∧
    assignment.forward.size = 95040 ∧
    assignment.reverse.size = 95040 ∧
    assignment.consistent = true ∧
    ∀ g : Fin 2,
      image (image (permutationKey (designGenerators g))) =
        conjugateKey (permutationKey dualitySquareConjugator)
          (permutationKey (designGenerators g))

/-- Exact closure orders, intersection inclusions, and parent-join equality. -/
abbrev parentClosureChecks : Prop :=
  let h := frozenClosure
  let p := transitiveParentClosure
  let k := fixedPointParentClosure
  let m := designClosure
  let j := parentJoinClosure
  h.size = 660 ∧
    p.size = 7920 ∧
    k.size = 7920 ∧
    m.size = 95040 ∧
    j.size = 95040 ∧
    (h.all fun x => p.contains x && k.contains x) = true ∧
    (p.all fun x => !k.contains x || h.contains x) = true ∧
    (j.all fun x => m.contains x) = true ∧
    (m.all fun x => j.contains x) = true

/-- Equality of the transported row closure and the coordinate design closure. -/
abbrev rowClosureChecks : Prop :=
  let r := alignedRowClosure
  let m := designClosure
  r.size = 95040 ∧
    (r.all fun x => m.contains x) = true ∧
    (m.all fun x => r.contains x) = true

/-- Exhaustive absence of an inner element realizing the row/column generator assignment. -/
abbrev rowColumnNonInnerCheck : Prop :=
  let m := designClosure
  (m.all fun x =>
    !(conjugateKey x (permutationKey (designGenerators 0)) ==
        permutationKey (alignedRowGenerator 0) &&
      conjugateKey x (permutationKey (designGenerators 1)) ==
        permutationKey (alignedRowGenerator 1))) = true

end ClebschWittHadamard
end RelativeConicArcs
