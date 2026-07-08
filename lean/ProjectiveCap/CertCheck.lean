import ProjectiveCap.Certificate

/-!
# Boolean checker for generated residual-grid certificates

This file is the reflection layer for Route C certificate data.  Generated
files provide concrete list-backed books; this checker evaluates them with
`Bool` combinators and a soundness theorem converts a successful check into
the semantic `GridClassCert.Valid` contract from `ProjectiveCap.Certificate`.
-/

namespace ProjectiveCap
namespace Certificate
namespace CertCheck

open FiniteBuildGame

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

def allShort {α : Type*} (p : α -> Bool) : List α -> Bool
  | [] => true
  | x :: xs => if p x then allShort p xs else false

def anyShort {α : Type*} (p : α -> Bool) : List α -> Bool
  | [] => false
  | x :: xs => if p x then true else anyShort p xs

@[simp]
theorem allShort_eq_all {α : Type*} (p : α -> Bool) :
    ∀ xs : List α, allShort p xs = xs.all p
  | [] => rfl
  | x :: xs => by
      cases h : p x <;> simp [allShort, h, allShort_eq_all p xs]

@[simp]
theorem anyShort_eq_any {α : Type*} (p : α -> Bool) :
    ∀ xs : List α, anyShort p xs = xs.any p
  | [] => rfl
  | x :: xs => by
      cases h : p x <;> simp [anyShort, h, anyShort_eq_any p xs]

theorem allShort_append {α : Type*} (p : α -> Bool) :
    ∀ xs ys : List α, allShort p (xs ++ ys) = (allShort p xs && allShort p ys)
  | [], ys => by simp [allShort]
  | x :: xs, ys => by
      cases h : p x <;> simp [allShort, h]

theorem allShort_flatten_true {α : Type*} (p : α -> Bool) :
    ∀ {chunks : List (List α)},
      allShort (fun xs => allShort p xs) chunks = true ->
        allShort p chunks.flatten = true
  | [], _h => rfl
  | xs :: xss, h => by
      cases hx : allShort p xs
      · simp only [allShort, hx, reduceIte, Bool.false_eq_true] at h
      · have htail : allShort (fun xs => allShort p xs) xss = true := by
          simpa only [allShort, hx, reduceIte] using h
        change allShort p (xs ++ xss.flatten) = true
        rw [allShort_append, hx, allShort_flatten_true p htail]
        rfl

def checkRowPair (p q : GridPoint K) : Bool :=
  decide (p.1 = q.1 -> p = q)

def checkColPair (p q : GridPoint K) : Bool :=
  decide (p.2 = q.2 -> p = q)

def checkAffineTriple (a b c : GridPoint K) : Bool :=
  decide (a ≠ b -> a ≠ c -> b ≠ c -> ¬ Collinear (K := K) a b c)

def checkRows (xs : List (GridPoint K)) : Bool :=
  allShort (fun p => allShort (fun q => checkRowPair (K := K) p q) xs) xs

def checkCols (xs : List (GridPoint K)) : Bool :=
  allShort (fun p => allShort (fun q => checkColPair (K := K) p q) xs) xs

def checkAffine (xs : List (GridPoint K)) : Bool :=
  allShort
    (fun a => allShort
      (fun b => allShort (fun c => checkAffineTriple (K := K) a b c) xs) xs)
    xs

/-- Executable cap check for a concrete list of grid cells. -/
def checkCap (xs : List (GridPoint K)) : Bool :=
  checkRows (K := K) xs && checkCols (K := K) xs && checkAffine (K := K) xs

omit [Field K] [Fintype K] in
theorem checkRows_sound {xs : List (GridPoint K)} (h : checkRows (K := K) xs = true) :
    RowSparse (K := K) xs.toFinset := by
  intro p q hp hq hrow
  have hpList : p ∈ xs := List.mem_toFinset.mp hp
  have hqList : q ∈ xs := List.mem_toFinset.mp hq
  unfold checkRows at h
  simp only [allShort_eq_all] at h
  have hpAll : (xs.all fun q => checkRowPair (K := K) p q) = true :=
    (List.all_eq_true.mp h) p hpList
  have hpq : checkRowPair (K := K) p q = true :=
    (List.all_eq_true.mp hpAll) q hqList
  unfold checkRowPair at hpq
  exact (of_decide_eq_true hpq) hrow

omit [Field K] [Fintype K] in
theorem checkCols_sound {xs : List (GridPoint K)} (h : checkCols (K := K) xs = true) :
    ColSparse (K := K) xs.toFinset := by
  intro p q hp hq hcol
  have hpList : p ∈ xs := List.mem_toFinset.mp hp
  have hqList : q ∈ xs := List.mem_toFinset.mp hq
  unfold checkCols at h
  simp only [allShort_eq_all] at h
  have hpAll : (xs.all fun q => checkColPair (K := K) p q) = true :=
    (List.all_eq_true.mp h) p hpList
  have hpq : checkColPair (K := K) p q = true :=
    (List.all_eq_true.mp hpAll) q hqList
  unfold checkColPair at hpq
  exact (of_decide_eq_true hpq) hcol

omit [Fintype K] in
theorem checkAffine_sound {xs : List (GridPoint K)} (h : checkAffine (K := K) xs = true) :
    AffineCap (K := K) xs.toFinset := by
  intro a b c ha hb hc hab hac hbc hcol
  have haList : a ∈ xs := List.mem_toFinset.mp ha
  have hbList : b ∈ xs := List.mem_toFinset.mp hb
  have hcList : c ∈ xs := List.mem_toFinset.mp hc
  unfold checkAffine at h
  simp only [allShort_eq_all] at h
  have haAll :
      (xs.all fun b => xs.all fun c => checkAffineTriple (K := K) a b c) = true :=
    (List.all_eq_true.mp h) a haList
  have habAll : (xs.all fun c => checkAffineTriple (K := K) a b c) = true :=
    (List.all_eq_true.mp haAll) b hbList
  have habc : checkAffineTriple (K := K) a b c = true :=
    (List.all_eq_true.mp habAll) c hcList
  unfold checkAffineTriple at habc
  exact (of_decide_eq_true habc) hab hac hbc hcol

omit [Fintype K] in
theorem checkCap_sound {xs : List (GridPoint K)} (h : checkCap (K := K) xs = true) :
    GridCap (K := K) xs.toFinset := by
  unfold checkCap at h
  rw [Bool.and_eq_true, Bool.and_eq_true] at h
  rcases h with ⟨⟨hrows, hcols⟩, haffine⟩
  exact ⟨⟨checkRows_sound (K := K) hrows, checkCols_sound (K := K) hcols⟩,
    checkAffine_sound (K := K) haffine⟩

omit [Field K] [Fintype K] in
theorem checkRows_complete {xs : List (GridPoint K)}
    (h : RowSparse (K := K) xs.toFinset) : checkRows (K := K) xs = true := by
  unfold checkRows
  simp only [allShort_eq_all]
  rw [List.all_eq_true]
  intro p hp
  rw [List.all_eq_true]
  intro q hq
  unfold checkRowPair
  exact decide_eq_true (fun hrow =>
    h (List.mem_toFinset.mpr hp) (List.mem_toFinset.mpr hq) hrow)

omit [Field K] [Fintype K] in
theorem checkCols_complete {xs : List (GridPoint K)}
    (h : ColSparse (K := K) xs.toFinset) : checkCols (K := K) xs = true := by
  unfold checkCols
  simp only [allShort_eq_all]
  rw [List.all_eq_true]
  intro p hp
  rw [List.all_eq_true]
  intro q hq
  unfold checkColPair
  exact decide_eq_true (fun hcol =>
    h (List.mem_toFinset.mpr hp) (List.mem_toFinset.mpr hq) hcol)

omit [Fintype K] in
theorem checkAffine_complete {xs : List (GridPoint K)}
    (h : AffineCap (K := K) xs.toFinset) : checkAffine (K := K) xs = true := by
  unfold checkAffine
  simp only [allShort_eq_all]
  rw [List.all_eq_true]
  intro a ha
  rw [List.all_eq_true]
  intro b hb
  rw [List.all_eq_true]
  intro c hc
  unfold checkAffineTriple
  exact decide_eq_true (fun hab hac hbc hcol =>
    h (List.mem_toFinset.mpr ha) (List.mem_toFinset.mpr hb)
      (List.mem_toFinset.mpr hc) hab hac hbc hcol)

omit [Fintype K] in
theorem checkCap_complete {xs : List (GridPoint K)}
    (h : GridCap (K := K) xs.toFinset) : checkCap (K := K) xs = true := by
  unfold checkCap
  rw [Bool.and_eq_true, Bool.and_eq_true]
  exact ⟨⟨checkRows_complete (K := K) h.1.1, checkCols_complete (K := K) h.1.2⟩,
    checkAffine_complete (K := K) h.2⟩

/-- Executable one-move legality check. -/
def checkMove (S : List (GridPoint K)) (x : GridPoint K) : Bool :=
  decide (x ∉ S.toFinset) && checkCap (K := K) (x :: S)

omit [Fintype K] in
theorem checkMove_true {S : List (GridPoint K)} {x : GridPoint K}
    (h : Move (GridCap (K := K)) S.toFinset x) :
    checkMove (K := K) S x = true := by
  unfold checkMove Move at *
  rw [Bool.and_eq_true]
  exact ⟨decide_eq_true h.1,
    have hchild : (x :: S).toFinset = insert x S.toFinset := by
      simp
    have hcap : GridCap (K := K) (x :: S).toFinset := by
      simpa [hchild] using h.2
    checkCap_complete (K := K) hcap⟩

omit [Fintype K] in
theorem checkMove_sound {S : List (GridPoint K)} {x : GridPoint K}
    (h : checkMove (K := K) S x = true) :
    Move (GridCap (K := K)) S.toFinset x := by
  unfold checkMove Move at *
  rw [Bool.and_eq_true] at h
  rcases h with ⟨hfresh, hcap⟩
  refine ⟨of_decide_eq_true hfresh, ?_⟩
  have hchild : (x :: S).toFinset = insert x S.toFinset := by
    simp
  simpa [hchild] using checkCap_sound (K := K) hcap

/-- Concrete row data: node list, mover move, responder reply, and child list. -/
structure RowData (K : Type*) where
  node : List (GridPoint K)
  mover : GridPoint K
  reply : GridPoint K
  child : List (GridPoint K)

namespace RowData

def toBookRow (r : RowData K) : ReplyBookRow (GridPoint K) where
  mover := r.mover
  reply := r.reply
  child := r.child.toFinset

def toEntry (r : RowData K) : Finset (GridPoint K) × ReplyBookRow (GridPoint K) :=
  (r.node.toFinset, r.toBookRow)

end RowData

/-- Concrete reply-book data emitted by the generator. -/
structure BookData (K : Type*) where
  cells : List (GridPoint K)
  root : List (GridPoint K)
  nodes : List (List (GridPoint K))
  rows : List (RowData K)

namespace BookData

def nodesFinset (b : BookData K) : Finset (Finset (GridPoint K)) :=
  (b.nodes.map List.toFinset).toFinset

def rowsFinset (b : BookData K) :
    Finset (Finset (GridPoint K) × ReplyBookRow (GridPoint K)) :=
  (b.rows.map RowData.toEntry).toFinset

def toDAG (b : BookData K) : ReplyBookDAG (GridPoint K) where
  root := b.root.toFinset
  Node := fun S => S ∈ b.nodesFinset
  Row := fun S row => (S, row) ∈ b.rowsFinset

def checkCells (b : BookData K) : Bool :=
  decide (∀ x ∈ (Finset.univ : Finset (GridPoint K)), x ∈ b.cells)

def checkRoot (b : BookData K) : Bool :=
  decide (b.root.toFinset ∈ b.nodesFinset)

def checkNodes (b : BookData K) : Bool :=
  allShort (fun S => checkCap (K := K) S) b.nodes

def checkRowMatch (b : BookData K) (S : List (GridPoint K)) (x : GridPoint K)
    (r : RowData K) : Bool :=
  decide
    (r.node.toFinset = S.toFinset ∧
      r.mover = x ∧
        r.reply ∉ insert x S.toFinset ∧
          checkCap (K := K) r.child = true ∧
          r.child.toFinset = insert r.reply (insert x S.toFinset) ∧
            r.child.toFinset ∈ b.nodesFinset)

def checkRow (b : BookData K) (S : List (GridPoint K)) (x : GridPoint K) : Bool :=
  anyShort (fun r => checkRowMatch (K := K) b S x r) b.rows

def checkNodeCell (b : BookData K) (S : List (GridPoint K)) (x : GridPoint K) : Bool :=
  if checkMove (K := K) S x then checkRow (K := K) b S x else true

def checkNodeStepOn (b : BookData K) (S : List (GridPoint K))
    (cells : List (GridPoint K)) : Bool :=
  allShort (fun x => checkNodeCell (K := K) b S x) cells

def checkNodeStepChunks (b : BookData K) (S : List (GridPoint K))
    (chunks : List (List (GridPoint K))) : Bool :=
  allShort (fun cells => checkNodeStepOn (K := K) b S cells) chunks

def checkNodeStep (b : BookData K) (S : List (GridPoint K)) : Bool :=
  checkNodeStepOn (K := K) b S b.cells

omit [Fintype K] in
theorem checkNodeStepOn_of_chunks {b : BookData K} {S : List (GridPoint K)}
    {chunks : List (List (GridPoint K))}
    (h : checkNodeStepChunks (K := K) b S chunks = true) :
    checkNodeStepOn (K := K) b S chunks.flatten = true := by
  exact allShort_flatten_true (fun x => checkNodeCell (K := K) b S x) h

def checkNodeStepOld (b : BookData K) (S : List (GridPoint K)) : Bool :=
  allShort
    (fun x => if checkMove (K := K) S x then checkRow (K := K) b S x else true)
    b.cells

def checkSteps (b : BookData K) : Bool :=
  allShort (fun S => checkNodeStep (K := K) b S) b.nodes

def checkBook (b : BookData K) : Bool :=
  checkCells (K := K) b && checkRoot (K := K) b &&
    checkNodes (K := K) b && checkSteps (K := K) b

omit [Field K] in
theorem checkCells_sound {b : BookData K} (h : checkCells (K := K) b = true) :
    ∀ x : GridPoint K, x ∈ b.cells := by
  unfold checkCells at h
  have hprop : ∀ x ∈ (Finset.univ : Finset (GridPoint K)), x ∈ b.cells :=
    of_decide_eq_true h
  intro x
  exact hprop x (Finset.mem_univ x)

omit [Field K] [Fintype K] in
theorem checkRoot_sound {b : BookData K} (h : checkRoot (K := K) b = true) :
    b.root.toFinset ∈ b.nodesFinset := by
  unfold checkRoot at h
  exact of_decide_eq_true h

omit [Field K] [Fintype K] in
theorem mem_nodesFinset_iff {b : BookData K} {S : Finset (GridPoint K)} :
    S ∈ b.nodesFinset ↔ ∃ xs ∈ b.nodes, xs.toFinset = S := by
  unfold nodesFinset
  rw [List.mem_toFinset]
  constructor
  · intro h
    rcases List.mem_map.mp h with ⟨xs, hxs, hS⟩
    exact ⟨xs, hxs, hS⟩
  · rintro ⟨xs, hxs, hS⟩
    exact List.mem_map.mpr ⟨xs, hxs, hS⟩

omit [Field K] [Fintype K] in
theorem mem_rowsFinset_of_mem {b : BookData K} {r : RowData K} (hr : r ∈ b.rows) :
    r.toEntry ∈ b.rowsFinset := by
  unfold rowsFinset
  rw [List.mem_toFinset]
  exact List.mem_map.mpr ⟨r, hr, rfl⟩

omit [Fintype K] in
theorem checkNodes_sound {b : BookData K} (h : checkNodes (K := K) b = true) :
    ∀ S ∈ b.nodesFinset, GridCap (K := K) S := by
  unfold checkNodes at h
  simp only [allShort_eq_all] at h
  intro S hS
  rcases mem_nodesFinset_iff.mp hS with ⟨xs, hxs, rfl⟩
  have hxcheck : checkCap (K := K) xs = true :=
    (List.all_eq_true.mp h) xs hxs
  exact checkCap_sound (K := K) hxcheck

omit [Fintype K] in
theorem checkRow_sound {b : BookData K} {S : List (GridPoint K)} {x : GridPoint K}
    (h : checkRow (K := K) b S x = true) :
    ∃ entry ∈ b.rowsFinset,
      entry.1 = S.toFinset ∧
        entry.2.mover = x ∧
          Move (α := GridPoint K) (GridCap (K := K)) (insert x S.toFinset) entry.2.reply ∧
              entry.2.child = insert entry.2.reply (insert x S.toFinset) ∧
                entry.2.child ∈ b.nodesFinset := by
  unfold checkRow at h
  simp only [anyShort_eq_any] at h
  rcases List.any_eq_true.mp h with ⟨r, hr, hmatch⟩
  unfold checkRowMatch at hmatch
  have hprop :
      r.node.toFinset = S.toFinset ∧
        r.mover = x ∧
          r.reply ∉ insert x S.toFinset ∧
            checkCap (K := K) r.child = true ∧
            r.child.toFinset = insert r.reply (insert x S.toFinset) ∧
              r.child.toFinset ∈ b.nodesFinset :=
    of_decide_eq_true hmatch
  rcases hprop with ⟨hnode, hmover, hfresh, hcap, hchild, hchildNode⟩
  refine ⟨r.toEntry, mem_rowsFinset_of_mem (K := K) hr, ?_, ?_, ?_, ?_, ?_⟩
  · exact hnode
  · exact hmover
  · show Move (α := GridPoint K) (GridCap (K := K)) (insert x S.toFinset) r.reply
    refine ⟨hfresh, ?_⟩
    simpa [hchild] using checkCap_sound (K := K) hcap
  · show r.child.toFinset = insert r.reply (insert x S.toFinset)
    exact hchild
  · show r.child.toFinset ∈ b.nodesFinset
    exact hchildNode

omit [Fintype K] in
theorem checkNodeStep_sound {b : BookData K} {S : List (GridPoint K)}
    (hcells : ∀ x : GridPoint K, x ∈ b.cells)
    (h : checkNodeStep (K := K) b S = true) :
    ∀ x : GridPoint K, Move (α := GridPoint K) (GridCap (K := K)) S.toFinset x ->
      ∃ entry ∈ b.rowsFinset,
        entry.1 = S.toFinset ∧
          entry.2.mover = x ∧
            Move (α := GridPoint K) (GridCap (K := K)) (insert x S.toFinset) entry.2.reply ∧
              entry.2.child = insert entry.2.reply (insert x S.toFinset) ∧
                entry.2.child ∈ b.nodesFinset := by
  intro x hxmove
  have hxmem : x ∈ b.cells := hcells x
  unfold checkNodeStep checkNodeStepOn checkNodeCell at h
  simp only [allShort_eq_all] at h
  have hxcheck : (if checkMove (K := K) S x then checkRow (K := K) b S x else true) = true :=
    (List.all_eq_true.mp h) x hxmem
  have hmoveBool : checkMove (K := K) S x = true := checkMove_true (K := K) hxmove
  rw [hmoveBool] at hxcheck
  exact checkRow_sound (K := K) hxcheck

theorem checkSteps_sound {b : BookData K}
    (hcells : ∀ x : GridPoint K, x ∈ b.cells) (h : checkSteps (K := K) b = true) :
    ∀ S ∈ b.nodesFinset, ∀ x ∈ (Finset.univ : Finset (GridPoint K)),
      Move (α := GridPoint K) (GridCap (K := K)) S x ->
        ∃ entry ∈ b.rowsFinset,
          entry.1 = S ∧
            entry.2.mover = x ∧
              Move (α := GridPoint K) (GridCap (K := K)) (insert x S) entry.2.reply ∧
                entry.2.child = insert entry.2.reply (insert x S) ∧
                  entry.2.child ∈ b.nodesFinset := by
  intro S hS x _hxUniv hxmove
  unfold checkSteps at h
  simp only [allShort_eq_all] at h
  rcases mem_nodesFinset_iff.mp hS with ⟨xs, hxs, rfl⟩
  have hnode : checkNodeStep (K := K) b xs = true :=
    (List.all_eq_true.mp h) xs hxs
  exact checkNodeStep_sound (K := K) hcells hnode x hxmove

theorem checkBook_sound {b : BookData K} (h : checkBook (K := K) b = true) :
    b.toDAG.ValidFor (GridCap (K := K)) := by
  have hparts :
      checkCells (K := K) b = true ∧
        checkRoot (K := K) b = true ∧
          checkNodes (K := K) b = true ∧
            checkSteps (K := K) b = true := by
    simpa [checkBook, Bool.and_eq_true, and_assoc] using h
  rcases hparts with ⟨hcells, hroot, hnodes, hsteps⟩
  have hcells' : ∀ x : GridPoint K, x ∈ b.cells := checkCells_sound (K := K) hcells
  unfold toDAG
  exact ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := b.root.toFinset)
    (nodes := b.nodesFinset)
    (rows := b.rowsFinset)
    (checkRoot_sound (K := K) hroot)
    (checkNodes_sound (K := K) hnodes)
    (checkSteps_sound (K := K) hcells' hsteps)

end BookData

/-- Concrete class certificate data emitted by the parser/generator. -/
structure ClassData (K : Type*) where
  classIndex : Nat
  sizeThree : List (GridPoint K)
  witness : GridPoint K
  book : BookData K

namespace ClassData

def toCert (c : ClassData K) : GridClassCert K where
  classIndex := c.classIndex
  sizeThree := c.sizeThree.toFinset
  witness := c.witness
  book := c.book.toDAG

def checkClass (c : ClassData K) : Bool :=
  decide (c.sizeThree.toFinset.card = 3) &&
    checkCap (K := K) c.sizeThree &&
      checkMove (K := K) c.sizeThree c.witness &&
        decide (c.book.root.toFinset = insert c.witness c.sizeThree.toFinset) &&
          BookData.checkBook (K := K) c.book

theorem valid_of_check {c : ClassData K} (h : checkClass (K := K) c = true) :
    c.toCert.Valid := by
  have hparts :
      decide (c.sizeThree.toFinset.card = 3) = true ∧
        checkCap (K := K) c.sizeThree = true ∧
          checkMove (K := K) c.sizeThree c.witness = true ∧
            decide (c.book.root.toFinset = insert c.witness c.sizeThree.toFinset) = true ∧
              BookData.checkBook (K := K) c.book = true := by
    simpa [checkClass, Bool.and_eq_true, and_assoc] using h
  rcases hparts with ⟨hcard, hcap, hmove, hroot, hbook⟩
  unfold toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true hcard
  · exact checkCap_sound (K := K) hcap
  · exact GridGame.mem_legalExtensions.mpr (checkMove_sound (K := K) hmove)
  · exact of_decide_eq_true hroot
  · exact BookData.checkBook_sound (K := K) hbook

end ClassData

end CertCheck
end Certificate
end ProjectiveCap
