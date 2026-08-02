import RelativeConicArcs.CodingBridge
import Mathlib.Data.ZMod.Basic

/-!
# Binary incidence codes from passant lines

This module gives the reusable finite semantics for a binary code whose coordinates are points and
whose parity checks are incidence rows.  The geometric input is an arbitrary decidable incidence
relation; later specializations may take the points to be internal points of a nonsingular conic
and the rows to be its passant lines.

The code is the kernel of the incidence-column linear map over `ZMod 2`.  Minimum supports and
pair/triple concurrence are defined intrinsically on the coordinate set.  No finite classification,
minimum-distance value, conic normalization, or external certificate is asserted here.
-/

namespace RelativeConicArcs.ConicPassantCode

open Finset

variable {Line Point : Type*} [Fintype Line] [DecidableEq Line]
  [Fintype Point] [DecidableEq Point]

/-- The binary entry of a finite incidence relation. -/
def incidenceBit (incident : Line → Point → Prop) [DecidableRel incident]
    (line : Line) (point : Point) : ZMod 2 :=
  if incident line point then 1 else 0

/-- The incidence column indexed by a point, regarded as a vector on the line set. -/
def incidenceColumn (incident : Line → Point → Prop) [DecidableRel incident]
    (point : Point) : Line → ZMod 2 :=
  fun line => incidenceBit incident line point

/-- The binary code checked by the rows of a finite incidence relation. -/
def code (incident : Line → Point → Prop) [DecidableRel incident] :
    Submodule (ZMod 2) (Point → ZMod 2) :=
  CodingBridge.parityCheckCode (incidenceColumn incident)

/-- The support of one incidence row on the point set. -/
def rowSupport (incident : Line → Point → Prop) [DecidableRel incident]
    (line : Line) : Finset Point :=
  Finset.univ.filter (incident line)

/-- The unlabeled family of supports of all incidence rows. -/
def rowSupports (incident : Line → Point → Prop) [DecidableRel incident] :
    Finset (Finset Point) :=
  Finset.univ.image (rowSupport incident)

/-- The supports of all codewords of Hamming weight `d`. -/
noncomputable def supportsOfWeight (incident : Line → Point → Prop) [DecidableRel incident]
    (d : ℕ) : Finset (Finset Point) :=
  CodingBridge.syndromeLeaderSupportsOfWeight
    (K := ZMod 2) (W := Line → ZMod 2) (ι := Point)
    (incidenceColumn incident) 0 d

/-- The number of members of a finite support hypergraph containing a given pair. -/
def pairConcurrence (supports : Finset (Finset Point)) (first second : Point) : ℕ :=
  (supports.filter fun support => first ∈ support ∧ second ∈ support).card

/-- The number of members of a finite support hypergraph containing a given triple. -/
def tripleConcurrence (supports : Finset (Finset Point))
    (first second third : Point) : ℕ :=
  (supports.filter fun support =>
    first ∈ support ∧ second ∈ support ∧ third ∈ support).card

omit [Fintype Line] [DecidableEq Line] [Fintype Point] [DecidableEq Point] in
@[simp] theorem incidenceBit_eq_one_iff (incident : Line → Point → Prop)
    [DecidableRel incident] (line : Line) (point : Point) :
    incidenceBit incident line point = 1 ↔ incident line point := by
  simp [incidenceBit]

omit [Fintype Line] [DecidableEq Line] [Fintype Point] [DecidableEq Point] in
@[simp] theorem incidenceBit_eq_zero_iff (incident : Line → Point → Prop)
    [DecidableRel incident] (line : Line) (point : Point) :
    incidenceBit incident line point = 0 ↔ ¬incident line point := by
  by_cases h : incident line point <;> simp [incidenceBit, h]

omit [Fintype Line] [DecidableEq Line] [DecidableEq Point] in
/-- Code membership is exactly vanishing of every binary incidence-row parity check. -/
theorem mem_code_iff_row_sums (incident : Line → Point → Prop) [DecidableRel incident]
    (word : Point → ZMod 2) :
    word ∈ code incident ↔
      ∀ line : Line, ∑ point : Point, word point * incidenceBit incident line point = 0 := by
  rw [code, CodingBridge.mem_parityCheckCode_iff]
  constructor
  · intro h line
    have hline := congrFun h line
    simpa [incidenceColumn, smul_eq_mul] using hline
  · intro h
    funext line
    simpa [incidenceColumn, smul_eq_mul] using h line

omit [Fintype Line] [DecidableEq Line] [DecidableEq Point] in
@[simp] theorem mem_rowSupport (incident : Line → Point → Prop) [DecidableRel incident]
    (line : Line) (point : Point) :
    point ∈ rowSupport incident line ↔ incident line point := by
  simp [rowSupport]

omit [DecidableEq Line] in
@[simp] theorem mem_supportsOfWeight (incident : Line → Point → Prop)
    [DecidableRel incident] (d : ℕ) (support : Finset Point) :
    support ∈ supportsOfWeight incident d ↔
      ∃ word : Point → ZMod 2,
        word ∈ code incident ∧ CodingBridge.hammingWeight word = d ∧
          CodingBridge.hammingSupport word = support := by
  classical
  simp [supportsOfWeight, code, CodingBridge.parityCheckCode,
    LinearMap.mem_ker, and_left_comm]

omit [Fintype Point] in
theorem pairConcurrence_comm (supports : Finset (Finset Point))
    (first second : Point) :
    pairConcurrence supports first second = pairConcurrence supports second first := by
  apply congrArg Finset.card
  ext support
  by_cases hsupport : support ∈ supports <;> simp [hsupport, and_comm]

omit [Fintype Point] in
/-- Triple concurrence is invariant under exchanging the first two coordinates. -/
theorem tripleConcurrence_swap_first_second (supports : Finset (Finset Point))
    (first second third : Point) :
    tripleConcurrence supports first second third =
      tripleConcurrence supports second first third := by
  apply congrArg Finset.card
  ext support
  by_cases hsupport : support ∈ supports <;>
    simp [hsupport, and_left_comm]

end RelativeConicArcs.ConicPassantCode
