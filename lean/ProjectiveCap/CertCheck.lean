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

theorem anyShort_append {α : Type*} (p : α -> Bool) :
    ∀ xs ys : List α, anyShort p (xs ++ ys) = (anyShort p xs || anyShort p ys)
  | [], ys => by simp [anyShort]
  | x :: xs, ys => by
      cases h : p x <;> simp [anyShort, h]

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

theorem anyShort_flatten_true {α : Type*} (p : α -> Bool) :
    ∀ {chunks : List (List α)},
      anyShort (fun xs => anyShort p xs) chunks = true ->
        anyShort p chunks.flatten = true
  | chunks, h => by
      simp only [anyShort_eq_any] at h ⊢
      rcases List.any_eq_true.mp h with ⟨chunk, hchunk, hhit⟩
      rcases List.any_eq_true.mp hhit with ⟨x, hx, hp⟩
      exact List.any_eq_true.mpr ⟨x, List.mem_flatten.mpr ⟨chunk, hchunk, hx⟩, hp⟩

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

def checkMoveRowColPair (x p : GridPoint K) : Bool :=
  decide (p.1 ≠ x.1 ∧ p.2 ≠ x.2)

def checkMoveAffinePair (x a b : GridPoint K) : Bool :=
  decide (a = b ∨ ¬ Collinear (K := K) x a b)

def checkMoveAffinePairs (x : GridPoint K) : List (GridPoint K) -> Bool
  | [] => true
  | a :: rest =>
      allShort (fun b => checkMoveAffinePair (K := K) x a b) rest &&
        checkMoveAffinePairs x rest

/-- Executable one-move legality check optimized for an already-certified cap node. -/
def checkMoveFast (S : List (GridPoint K)) (x : GridPoint K) : Bool :=
  decide (x ∉ S.toFinset) &&
    allShort (fun p => checkMoveRowColPair (K := K) x p) S &&
      checkMoveAffinePairs (K := K) x S

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
theorem checkMoveAffinePairs_true {S : List (GridPoint K)} {x : GridPoint K}
    (h : Move (GridCap (K := K)) S.toFinset x) :
    checkMoveAffinePairs (K := K) x S = true := by
  induction S with
  | nil =>
      rfl
  | cons a rest ih =>
      unfold checkMoveAffinePairs
      rw [Bool.and_eq_true]
      refine ⟨?_, ?_⟩
      · simp only [allShort_eq_all, List.all_eq_true]
        intro b hb
        unfold checkMoveAffinePair
        exact decide_eq_true (by
          by_cases hab : a = b
          · exact Or.inl hab
          · refine Or.inr ?_
            intro hcol
            have haFin : a ∈ (a :: rest).toFinset := by simp
            have hbFin : b ∈ (a :: rest).toFinset :=
              List.mem_toFinset.mpr (List.mem_cons_of_mem a hb)
            have hxIns : x ∈ insert x (a :: rest).toFinset :=
              Finset.mem_insert_self x (a :: rest).toFinset
            have haIns : a ∈ insert x (a :: rest).toFinset :=
              Finset.mem_insert_of_mem haFin
            have hbIns : b ∈ insert x (a :: rest).toFinset :=
              Finset.mem_insert_of_mem hbFin
            have hxa : x ≠ a := by
              intro hxa
              exact h.1 (by simp [hxa])
            have hxb : x ≠ b := by
              intro hxb
              exact h.1 (by simpa [hxb] using hbFin)
            exact h.2.2 hxIns haIns hbIns hxa hxb hab hcol)
      · have hrest : Move (GridCap (K := K)) rest.toFinset x := by
          refine ⟨?_, ?_⟩
          · intro hxrest
            exact h.1 (List.mem_toFinset.mpr
              (List.mem_cons_of_mem a (List.mem_toFinset.mp hxrest)))
          · exact gridCap_mono (K := K) (T := insert x (a :: rest).toFinset)
              (by
                intro y hy
                rw [Finset.mem_insert] at hy ⊢
                rcases hy with hy | hy
                · exact Or.inl hy
                · exact Or.inr (List.mem_toFinset.mpr
                    (List.mem_cons_of_mem a (List.mem_toFinset.mp hy))))
              h.2
        exact ih hrest

omit [Fintype K] in
theorem checkMoveFast_true {S : List (GridPoint K)} {x : GridPoint K}
    (h : Move (GridCap (K := K)) S.toFinset x) :
  checkMoveFast (K := K) S x = true := by
  unfold checkMoveFast
  rw [Bool.and_eq_true]
  refine ⟨?_, ?_⟩
  · rw [Bool.and_eq_true]
    refine ⟨decide_eq_true h.1, ?_⟩
    simp only [allShort_eq_all, List.all_eq_true]
    intro p hp
    unfold checkMoveRowColPair
    exact decide_eq_true (by
      have hpFin : p ∈ S.toFinset := List.mem_toFinset.mpr hp
      have hpIns : p ∈ insert x S.toFinset := Finset.mem_insert_of_mem hpFin
      have hxIns : x ∈ insert x S.toFinset := Finset.mem_insert_self x S.toFinset
      have hpx : p ≠ x := by
        intro hpx
        exact h.1 (by simpa [hpx] using hpFin)
      constructor
      · intro hrowEq
        exact hpx (h.2.1.1 hpIns hxIns hrowEq)
      · intro hcolEq
        exact hpx (h.2.1.2 hpIns hxIns hcolEq))
  · exact checkMoveAffinePairs_true (K := K) h

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

/-- Local reply rows for one book node.  This is a generated-checker convenience:
the semantic DAG can use a permissive row predicate once each local row is checked
to have the right mover, legal reply, and certified child node. -/
structure StepData (K : Type*) where
  node : List (GridPoint K)
  rows : List (RowData K)

structure RowRefData (K : Type*) where
  row : RowData K
  childGroup : Nat
  childChunk : Nat
  childSlot : Nat

structure StepRefData (K : Type*) where
  node : List (GridPoint K)
  rows : List (RowRefData K)

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

def toLooseDAG (b : BookData K) : ReplyBookDAG (GridPoint K) where
  root := b.root.toFinset
  Node := fun S => S ∈ b.nodesFinset
  Row := fun _ _ => True

def checkCells (b : BookData K) : Bool :=
  decide (∀ x ∈ (Finset.univ : Finset (GridPoint K)), x ∈ b.cells)

def checkRoot (b : BookData K) : Bool :=
  decide (b.root.toFinset ∈ b.nodesFinset)

def checkNodes (b : BookData K) : Bool :=
  allShort (fun S => checkCap (K := K) S) b.nodes

def checkNodesChunks (_b : BookData K) (chunks : List (List (List (GridPoint K)))) : Bool :=
  allShort (fun nodes => allShort (fun S => checkCap (K := K) S) nodes) chunks

def checkRowMatch (b : BookData K) (S : List (GridPoint K)) (x : GridPoint K)
    (r : RowData K) : Bool :=
  decide
    (r.node.toFinset = S.toFinset ∧
      r.mover = x ∧
        r.reply ∉ insert x S.toFinset ∧
          checkCap (K := K) r.child = true ∧
            r.child.toFinset = insert r.reply (insert x S.toFinset) ∧
              r.child.toFinset ∈ b.nodesFinset)

def checkNodeMemberOn (S : Finset (GridPoint K)) (nodes : List (List (GridPoint K))) : Bool :=
  anyShort (fun xs => decide (xs.toFinset = S)) nodes

def checkNodeMemberChunks (S : Finset (GridPoint K))
    (chunks : List (List (List (GridPoint K)))) : Bool :=
  anyShort (fun nodes => checkNodeMemberOn (K := K) S nodes) chunks

def checkRowMatchWithNodes (_b : BookData K) (nodeChunks : List (List (List (GridPoint K))))
    (S : List (GridPoint K)) (x : GridPoint K) (r : RowData K) : Bool :=
  decide
    (r.node.toFinset = S.toFinset ∧
      r.mover = x ∧
        r.reply ∉ insert x S.toFinset ∧
          checkCap (K := K) r.child = true ∧
          r.child.toFinset = insert r.reply (insert x S.toFinset)) &&
    checkNodeMemberChunks (K := K) r.child.toFinset nodeChunks

def checkRow (b : BookData K) (S : List (GridPoint K)) (x : GridPoint K) : Bool :=
  anyShort (fun r => checkRowMatch (K := K) b S x r) b.rows

def checkRowOn (b : BookData K) (S : List (GridPoint K)) (x : GridPoint K)
    (rows : List (RowData K)) : Bool :=
  anyShort (fun r => checkRowMatch (K := K) b S x r) rows

def checkRowChunks (b : BookData K) (S : List (GridPoint K)) (x : GridPoint K)
    (chunks : List (List (RowData K))) : Bool :=
  anyShort (fun rows => checkRowOn (K := K) b S x rows) chunks

def checkRowOnWithNodes (b : BookData K) (nodeChunks : List (List (List (GridPoint K))))
    (S : List (GridPoint K)) (x : GridPoint K) (rows : List (RowData K)) : Bool :=
  anyShort (fun r => checkRowMatchWithNodes (K := K) b nodeChunks S x r) rows

def checkRowChunksWithNodes (b : BookData K)
    (nodeChunks : List (List (List (GridPoint K)))) (S : List (GridPoint K))
    (x : GridPoint K) (rowChunks : List (List (RowData K))) : Bool :=
  anyShort (fun rows => checkRowOnWithNodes (K := K) b nodeChunks S x rows) rowChunks

def checkNodeCell (b : BookData K) (S : List (GridPoint K)) (x : GridPoint K) : Bool :=
  if checkMove (K := K) S x then checkRow (K := K) b S x else true

def checkNodeCellWithRows (b : BookData K) (S : List (GridPoint K))
    (rowChunks : List (List (RowData K))) (x : GridPoint K) : Bool :=
  if checkMove (K := K) S x then checkRowChunks (K := K) b S x rowChunks else true

def checkNodeCellWithChunks (b : BookData K)
    (nodeChunks : List (List (List (GridPoint K)))) (rowChunks : List (List (RowData K)))
    (S : List (GridPoint K)) (x : GridPoint K) : Bool :=
  if checkMove (K := K) S x then
    checkRowChunksWithNodes (K := K) b nodeChunks S x rowChunks
  else
    true

def checkNodeStepOn (b : BookData K) (S : List (GridPoint K))
    (cells : List (GridPoint K)) : Bool :=
  allShort (fun x => checkNodeCell (K := K) b S x) cells

def checkNodeStepOnWithRows (b : BookData K) (S : List (GridPoint K))
    (rowChunks : List (List (RowData K))) (cells : List (GridPoint K)) : Bool :=
  allShort (fun x => checkNodeCellWithRows (K := K) b S rowChunks x) cells

def checkNodeStepOnWithChunks (b : BookData K)
    (nodeChunks : List (List (List (GridPoint K)))) (rowChunks : List (List (RowData K)))
    (S : List (GridPoint K)) (cells : List (GridPoint K)) : Bool :=
  allShort (fun x => checkNodeCellWithChunks (K := K) b nodeChunks rowChunks S x) cells

def checkNodeStepChunks (b : BookData K) (S : List (GridPoint K))
    (chunks : List (List (GridPoint K))) : Bool :=
  allShort (fun cells => checkNodeStepOn (K := K) b S cells) chunks

def checkNodeStepChunksWithRows (b : BookData K) (S : List (GridPoint K))
    (rowChunks : List (List (RowData K))) (cellChunks : List (List (GridPoint K))) : Bool :=
  allShort (fun cells => checkNodeStepOnWithRows (K := K) b S rowChunks cells) cellChunks

def checkNodeStepChunksWithAll (b : BookData K)
    (nodeChunks : List (List (List (GridPoint K)))) (rowChunks : List (List (RowData K)))
    (S : List (GridPoint K)) (cellChunks : List (List (GridPoint K))) : Bool :=
  allShort (fun cells =>
    checkNodeStepOnWithChunks (K := K) b nodeChunks rowChunks S cells) cellChunks

def checkNodeCellWithLocalRows (b : BookData K)
    (nodeChunks : List (List (List (GridPoint K)))) (S : List (GridPoint K))
    (rows : List (RowData K)) (x : GridPoint K) : Bool :=
  if checkMoveFast (K := K) S x then
    checkRowOnWithNodes (K := K) b nodeChunks S x rows
  else
    true

def checkNodeStepOnWithLocalRows (b : BookData K)
    (nodeChunks : List (List (List (GridPoint K)))) (S : List (GridPoint K))
    (rows : List (RowData K)) (cells : List (GridPoint K)) : Bool :=
  allShort (fun x => checkNodeCellWithLocalRows (K := K) b nodeChunks S rows x) cells

def checkNodeStepChunksWithLocalRows (b : BookData K)
    (nodeChunks : List (List (List (GridPoint K)))) (S : List (GridPoint K))
    (rows : List (RowData K)) (cellChunks : List (List (GridPoint K))) : Bool :=
  allShort (fun cells =>
    checkNodeStepOnWithLocalRows (K := K) b nodeChunks S rows cells) cellChunks

def checkStepData (b : BookData K) (nodeChunks : List (List (List (GridPoint K))))
    (cellChunks : List (List (GridPoint K))) (d : StepData K) : Bool :=
  checkNodeStepChunksWithLocalRows (K := K) b nodeChunks d.node d.rows cellChunks

def checkStepDataList (b : BookData K) (nodeChunks : List (List (List (GridPoint K))))
    (cellChunks : List (List (GridPoint K))) (steps : List (StepData K)) : Bool :=
  allShort (fun d => checkStepData (K := K) b nodeChunks cellChunks d) steps

def checkStepDataChunks (b : BookData K) (nodeChunks : List (List (List (GridPoint K))))
    (cellChunks : List (List (GridPoint K))) (chunks : List (List (StepData K))) : Bool :=
  allShort (fun steps => checkStepDataList (K := K) b nodeChunks cellChunks steps) chunks

def checkStepDataNodes : List (StepData K) -> List (List (GridPoint K)) -> Bool
  | [], [] => true
  | d :: ds, node :: nodes =>
      decide (d.node = node) && checkStepDataNodes ds nodes
  | _, _ => false

def checkStepDataNodeChunks
    (stepChunks : List (List (StepData K))) (nodeChunks : List (List (List (GridPoint K)))) :
    Bool :=
  checkStepDataNodes (K := K) stepChunks.flatten nodeChunks.flatten

def checkStepDataNodeChunkGroups :
    List (List (List (StepData K))) -> List (List (List (List (GridPoint K)))) -> Bool
  | [], [] => true
  | stepChunks :: stepGroups, nodeChunks :: nodeGroups =>
      checkStepDataNodeChunks (K := K) stepChunks nodeChunks &&
        checkStepDataNodeChunkGroups stepGroups nodeGroups
  | _, _ => false

def childAt (nodeChunkGroups : List (List (List (List (GridPoint K)))))
    (g c i : Nat) : Option (List (GridPoint K)) := do
  let chunks <- nodeChunkGroups[g]?
  let nodes <- chunks[c]?
  nodes[i]?

def checkRowRefMatch (nodeChunkGroups : List (List (List (List (GridPoint K)))))
    (S : List (GridPoint K)) (x : GridPoint K) (rr : RowRefData K) : Bool :=
  let r := rr.row
  decide
    (r.mover = x ∧
        r.reply ∉ insert x S.toFinset ∧
          r.child.toFinset = insert r.reply (insert x S.toFinset)) &&
    decide
      (childAt (K := K) nodeChunkGroups rr.childGroup rr.childChunk rr.childSlot =
        some r.child)

def checkRowRefOn (nodeChunkGroups : List (List (List (List (GridPoint K)))))
    (S : List (GridPoint K)) (x : GridPoint K) (rows : List (RowRefData K)) : Bool :=
  anyShort (fun rr => checkRowRefMatch (K := K) nodeChunkGroups S x rr) rows

def checkNodeCellWithLocalRowRefs
    (nodeChunkGroups : List (List (List (List (GridPoint K)))))
    (S : List (GridPoint K)) (rows : List (RowRefData K)) (x : GridPoint K) : Bool :=
  if checkMoveFast (K := K) S x then
    checkRowRefOn (K := K) nodeChunkGroups S x rows
  else
    true

def checkNodeStepOnWithLocalRowRefs
    (nodeChunkGroups : List (List (List (List (GridPoint K)))))
    (S : List (GridPoint K)) (rows : List (RowRefData K))
    (cells : List (GridPoint K)) : Bool :=
  allShort (fun x =>
    checkNodeCellWithLocalRowRefs (K := K) nodeChunkGroups S rows x) cells

def checkNodeStepChunksWithLocalRowRefs
    (nodeChunkGroups : List (List (List (List (GridPoint K)))))
    (S : List (GridPoint K)) (rows : List (RowRefData K))
    (cellChunks : List (List (GridPoint K))) : Bool :=
  allShort (fun cells =>
    checkNodeStepOnWithLocalRowRefs (K := K) nodeChunkGroups S rows cells) cellChunks

def checkStepRefData (nodeChunkGroups : List (List (List (List (GridPoint K)))))
    (cellChunks : List (List (GridPoint K))) (d : StepRefData K) : Bool :=
  checkNodeStepChunksWithLocalRowRefs (K := K) nodeChunkGroups d.node d.rows cellChunks

def checkStepRefDataList (nodeChunkGroups : List (List (List (List (GridPoint K)))))
    (cellChunks : List (List (GridPoint K))) (steps : List (StepRefData K)) : Bool :=
  allShort (fun d => checkStepRefData (K := K) nodeChunkGroups cellChunks d) steps

def checkStepRefDataChunks (nodeChunkGroups : List (List (List (List (GridPoint K)))))
    (cellChunks : List (List (GridPoint K)))
    (chunks : List (List (StepRefData K))) : Bool :=
  allShort (fun steps =>
    checkStepRefDataList (K := K) nodeChunkGroups cellChunks steps) chunks

def checkStepRefDataNodes : List (StepRefData K) -> List (List (GridPoint K)) -> Bool
  | [], [] => true
  | d :: ds, node :: nodes =>
      decide (d.node = node) && checkStepRefDataNodes ds nodes
  | _, _ => false

def checkStepRefDataNodeChunks
    (stepChunks : List (List (StepRefData K)))
    (nodeChunks : List (List (List (GridPoint K)))) : Bool :=
  checkStepRefDataNodes (K := K) stepChunks.flatten nodeChunks.flatten

def checkStepRefDataNodeChunkGroups :
    List (List (List (StepRefData K))) -> List (List (List (List (GridPoint K)))) -> Bool
  | [], [] => true
  | stepChunks :: stepGroups, nodeChunks :: nodeGroups =>
      checkStepRefDataNodeChunks (K := K) stepChunks nodeChunks &&
        checkStepRefDataNodeChunkGroups stepGroups nodeGroups
  | _, _ => false

def checkNodeStep (b : BookData K) (S : List (GridPoint K)) : Bool :=
  checkNodeStepOn (K := K) b S b.cells

omit [Fintype K] in
theorem checkNodeStepOn_of_chunks {b : BookData K} {S : List (GridPoint K)}
    {chunks : List (List (GridPoint K))}
    (h : checkNodeStepChunks (K := K) b S chunks = true) :
    checkNodeStepOn (K := K) b S chunks.flatten = true := by
  exact allShort_flatten_true (fun x => checkNodeCell (K := K) b S x) h

omit [Fintype K] in
theorem checkNodes_of_chunks {b : BookData K}
    {chunks : List (List (List (GridPoint K)))}
    (hflat : chunks.flatten = b.nodes)
    (h : checkNodesChunks (K := K) b chunks = true) :
    checkNodes (K := K) b = true := by
  unfold checkNodes
  unfold checkNodesChunks at h
  rw [← hflat]
  exact allShort_flatten_true (fun S => checkCap (K := K) S) h

omit [Fintype K] in
theorem checkRow_of_chunks {b : BookData K} {S : List (GridPoint K)} {x : GridPoint K}
    {chunks : List (List (RowData K))}
    (hflat : chunks.flatten = b.rows)
    (h : checkRowChunks (K := K) b S x chunks = true) :
    checkRow (K := K) b S x = true := by
  unfold checkRow
  unfold checkRowChunks checkRowOn at h
  rw [← hflat]
  exact anyShort_flatten_true (fun r => checkRowMatch (K := K) b S x r) h

omit [Field K] [Fintype K] in
theorem checkNodeMember_of_chunks {b : BookData K} {S : Finset (GridPoint K)}
    {chunks : List (List (List (GridPoint K)))}
    (hflat : chunks.flatten = b.nodes)
    (h : checkNodeMemberChunks (K := K) S chunks = true) :
    S ∈ b.nodesFinset := by
  unfold checkNodeMemberChunks checkNodeMemberOn at h
  have hmem :
      anyShort (fun xs : List (GridPoint K) => decide (xs.toFinset = S))
        chunks.flatten = true :=
    anyShort_flatten_true (fun xs : List (GridPoint K) => decide (xs.toFinset = S)) h
  rw [hflat] at hmem
  simp only [anyShort_eq_any] at hmem
  rcases List.any_eq_true.mp hmem with ⟨xs, hxs, hxsS⟩
  unfold nodesFinset
  rw [List.mem_toFinset]
  exact List.mem_map.mpr ⟨xs, hxs, of_decide_eq_true hxsS⟩

omit [Fintype K] in
theorem checkRowWithNodes_of_chunks {b : BookData K} {S : List (GridPoint K)}
    {x : GridPoint K} {nodeChunks : List (List (List (GridPoint K)))}
    {rowChunks : List (List (RowData K))}
    (hnodes : nodeChunks.flatten = b.nodes)
    (hrows : rowChunks.flatten = b.rows)
    (h : checkRowChunksWithNodes (K := K) b nodeChunks S x rowChunks = true) :
    checkRow (K := K) b S x = true := by
  unfold checkRow
  rw [← hrows]
  apply anyShort_flatten_true
  unfold checkRowChunksWithNodes checkRowOnWithNodes at h
  simp only [anyShort_eq_any] at h ⊢
  rcases List.any_eq_true.mp h with ⟨rows, hrowsMem, hrowsHit⟩
  refine List.any_eq_true.mpr ⟨rows, hrowsMem, ?_⟩
  rw [← anyShort_eq_any]
  simp only [anyShort_eq_any] at hrowsHit ⊢
  rcases List.any_eq_true.mp hrowsHit with ⟨r, hr, hrmatch⟩
  unfold checkRowMatchWithNodes at hrmatch
  rw [Bool.and_eq_true] at hrmatch
  rcases hrmatch with ⟨hfront, hchildNode⟩
  have hfrontProp :
      r.node.toFinset = S.toFinset ∧
        r.mover = x ∧
          r.reply ∉ insert x S.toFinset ∧
            checkCap (K := K) r.child = true ∧
            r.child.toFinset = insert r.reply (insert x S.toFinset) :=
    of_decide_eq_true hfront
  have hnode : r.child.toFinset ∈ b.nodesFinset :=
    checkNodeMember_of_chunks (K := K) hnodes hchildNode
  unfold checkRowMatch
  rcases hfrontProp with ⟨hnodeEq, hmover, hfresh, hcap, hchildEq⟩
  have hprop :
      r.node.toFinset = S.toFinset ∧
        r.mover = x ∧
          r.reply ∉ insert x S.toFinset ∧
            checkCap (K := K) r.child = true ∧
            r.child.toFinset = insert r.reply (insert x S.toFinset) ∧
              r.child.toFinset ∈ b.nodesFinset :=
    ⟨hnodeEq, hmover, hfresh, hcap, hchildEq, hnode⟩
  exact List.any_eq_true.mpr ⟨r, hr, decide_eq_true hprop⟩

omit [Fintype K] in
theorem checkNodeStepOn_of_row_chunks {b : BookData K} {S : List (GridPoint K)}
    {rowChunks : List (List (RowData K))} {cells : List (GridPoint K)}
    (hrows : rowChunks.flatten = b.rows)
    (h : checkNodeStepOnWithRows (K := K) b S rowChunks cells = true) :
    checkNodeStepOn (K := K) b S cells = true := by
  unfold checkNodeStepOnWithRows checkNodeStepOn at *
  simp only [allShort_eq_all] at h ⊢
  rw [List.all_eq_true] at h ⊢
  intro x hx
  have hxcheck := h x hx
  unfold checkNodeCellWithRows at hxcheck
  unfold checkNodeCell
  cases hmove : checkMove (K := K) S x <;> simp [hmove] at hxcheck ⊢
  exact checkRow_of_chunks (K := K) hrows hxcheck

omit [Fintype K] in
theorem checkNodeStepOn_of_all_chunks {b : BookData K} {S : List (GridPoint K)}
    {nodeChunks : List (List (List (GridPoint K)))}
    {rowChunks : List (List (RowData K))} {cells : List (GridPoint K)}
    (hnodes : nodeChunks.flatten = b.nodes)
    (hrows : rowChunks.flatten = b.rows)
    (h : checkNodeStepOnWithChunks (K := K) b nodeChunks rowChunks S cells = true) :
    checkNodeStepOn (K := K) b S cells = true := by
  unfold checkNodeStepOnWithChunks checkNodeStepOn at *
  simp only [allShort_eq_all] at h ⊢
  rw [List.all_eq_true] at h ⊢
  intro x hx
  have hxcheck := h x hx
  unfold checkNodeCellWithChunks at hxcheck
  unfold checkNodeCell
  cases hmove : checkMove (K := K) S x <;> simp [hmove] at hxcheck ⊢
  exact checkRowWithNodes_of_chunks (K := K) hnodes hrows hxcheck

omit [Fintype K] in
theorem checkNodeStep_of_row_cell_chunks {b : BookData K} {S : List (GridPoint K)}
    {rowChunks : List (List (RowData K))} {cellChunks : List (List (GridPoint K))}
    (hrows : rowChunks.flatten = b.rows)
    (hcells : cellChunks.flatten = b.cells)
    (h : checkNodeStepChunksWithRows (K := K) b S rowChunks cellChunks = true) :
    checkNodeStep (K := K) b S = true := by
  unfold checkNodeStep
  rw [← hcells]
  apply checkNodeStepOn_of_chunks (K := K)
  unfold checkNodeStepChunks checkNodeStepChunksWithRows at *
  simp only [allShort_eq_all] at h ⊢
  rw [List.all_eq_true] at h ⊢
  intro cells hmem
  exact checkNodeStepOn_of_row_chunks (K := K) hrows (h cells hmem)

omit [Fintype K] in
theorem checkNodeStep_of_all_chunks {b : BookData K} {S : List (GridPoint K)}
    {nodeChunks : List (List (List (GridPoint K)))} {rowChunks : List (List (RowData K))}
    {cellChunks : List (List (GridPoint K))}
    (hnodes : nodeChunks.flatten = b.nodes)
    (hrows : rowChunks.flatten = b.rows)
    (hcells : cellChunks.flatten = b.cells)
    (h : checkNodeStepChunksWithAll (K := K) b nodeChunks rowChunks S cellChunks = true) :
    checkNodeStep (K := K) b S = true := by
  unfold checkNodeStep
  rw [← hcells]
  apply checkNodeStepOn_of_chunks (K := K)
  unfold checkNodeStepChunks checkNodeStepChunksWithAll at *
  simp only [allShort_eq_all] at h ⊢
  rw [List.all_eq_true] at h ⊢
  intro cells hmem
  exact checkNodeStepOn_of_all_chunks (K := K) hnodes hrows (h cells hmem)

omit [Fintype K] in
theorem checkRowOnWithNodes_sound {b : BookData K}
    {nodeChunks : List (List (List (GridPoint K)))} {S : List (GridPoint K)}
    {x : GridPoint K} {rows : List (RowData K)}
    (hnodes : nodeChunks.flatten = b.nodes)
    (h : checkRowOnWithNodes (K := K) b nodeChunks S x rows = true) :
    ∃ row : ReplyBookRow (GridPoint K),
      row.mover = x ∧
        Move (α := GridPoint K) (GridCap (K := K)) (insert x S.toFinset) row.reply ∧
          row.child = insert row.reply (insert x S.toFinset) ∧
            row.child ∈ b.nodesFinset := by
  unfold checkRowOnWithNodes at h
  simp only [anyShort_eq_any] at h
  rcases List.any_eq_true.mp h with ⟨r, _hr, hrmatch⟩
  unfold checkRowMatchWithNodes at hrmatch
  rw [Bool.and_eq_true] at hrmatch
  rcases hrmatch with ⟨hfront, hchildNode⟩
  have hfrontProp :
      r.node.toFinset = S.toFinset ∧
        r.mover = x ∧
          r.reply ∉ insert x S.toFinset ∧
            checkCap (K := K) r.child = true ∧
            r.child.toFinset = insert r.reply (insert x S.toFinset) :=
    of_decide_eq_true hfront
  rcases hfrontProp with ⟨_hnodeEq, hmover, hfresh, hcap, hchildEq⟩
  have hnode : r.child.toFinset ∈ b.nodesFinset :=
    checkNodeMember_of_chunks (K := K) hnodes hchildNode
  refine ⟨r.toBookRow, hmover, ?_, ?_, hnode⟩
  · show Move (α := GridPoint K) (GridCap (K := K)) (insert x S.toFinset) r.reply
    refine ⟨hfresh, ?_⟩
    simpa [hchildEq] using checkCap_sound (K := K) hcap
  · show r.child.toFinset = insert r.reply (insert x S.toFinset)
    exact hchildEq

omit [Fintype K] in
theorem checkNodeStepOnWithLocalRows_sound {b : BookData K}
    {nodeChunks : List (List (List (GridPoint K)))} {S : List (GridPoint K)}
    {rows : List (RowData K)} {cells : List (GridPoint K)}
    (hnodes : nodeChunks.flatten = b.nodes)
    (h : checkNodeStepOnWithLocalRows (K := K) b nodeChunks S rows cells = true) :
    ∀ x ∈ cells, Move (α := GridPoint K) (GridCap (K := K)) S.toFinset x ->
      ∃ row : ReplyBookRow (GridPoint K),
        row.mover = x ∧
          Move (α := GridPoint K) (GridCap (K := K)) (insert x S.toFinset) row.reply ∧
            row.child = insert row.reply (insert x S.toFinset) ∧
              row.child ∈ b.nodesFinset := by
  unfold checkNodeStepOnWithLocalRows at h
  simp only [allShort_eq_all] at h
  intro x hxmem hxmove
  have hxcheck :
      checkNodeCellWithLocalRows (K := K) b nodeChunks S rows x = true :=
    (List.all_eq_true.mp h) x hxmem
  unfold checkNodeCellWithLocalRows at hxcheck
  have hmoveBool : checkMoveFast (K := K) S x = true := checkMoveFast_true (K := K) hxmove
  rw [hmoveBool] at hxcheck
  exact checkRowOnWithNodes_sound (K := K) hnodes hxcheck

omit [Fintype K] in
theorem checkStepData_sound {b : BookData K}
    {nodeChunks : List (List (List (GridPoint K)))}
    {cellChunks : List (List (GridPoint K))} {d : StepData K}
    (hnodes : nodeChunks.flatten = b.nodes)
    (hcells : cellChunks.flatten = b.cells)
    (hcellsAll : ∀ x : GridPoint K, x ∈ b.cells)
    (h : checkStepData (K := K) b nodeChunks cellChunks d = true) :
    ∀ x : GridPoint K,
      Move (α := GridPoint K) (GridCap (K := K)) d.node.toFinset x ->
        ∃ row : ReplyBookRow (GridPoint K),
          row.mover = x ∧
            Move (α := GridPoint K) (GridCap (K := K)) (insert x d.node.toFinset)
              row.reply ∧
              row.child = insert row.reply (insert x d.node.toFinset) ∧
                row.child ∈ b.nodesFinset := by
  intro x hxmove
  have hxmem : x ∈ cellChunks.flatten := by
    rw [hcells]
    exact hcellsAll x
  unfold checkStepData checkNodeStepChunksWithLocalRows at h
  have hflat :
      checkNodeStepOnWithLocalRows (K := K) b nodeChunks d.node d.rows
        cellChunks.flatten = true :=
    allShort_flatten_true
      (fun x => checkNodeCellWithLocalRows (K := K) b nodeChunks d.node d.rows x) h
  exact checkNodeStepOnWithLocalRows_sound (K := K) hnodes hflat x hxmem hxmove

omit [Fintype K] in
theorem checkStepDataList_sound {b : BookData K}
    {nodeChunks : List (List (List (GridPoint K)))}
    {cellChunks : List (List (GridPoint K))} {steps : List (StepData K)}
    (hnodes : nodeChunks.flatten = b.nodes)
    (hcells : cellChunks.flatten = b.cells)
    (hcellsAll : ∀ x : GridPoint K, x ∈ b.cells)
    (hcover : steps.map StepData.node = b.nodes)
    (h : checkStepDataList (K := K) b nodeChunks cellChunks steps = true) :
    ∀ S ∈ b.nodesFinset, ∀ x : GridPoint K,
      Move (α := GridPoint K) (GridCap (K := K)) S x ->
        ∃ row : ReplyBookRow (GridPoint K),
          row.mover = x ∧
            Move (α := GridPoint K) (GridCap (K := K)) (insert x S) row.reply ∧
              row.child = insert row.reply (insert x S) ∧
                row.child ∈ b.nodesFinset := by
  unfold checkStepDataList at h
  simp only [allShort_eq_all] at h
  intro S hS x hxmove
  have hSList : S ∈ b.nodes.map List.toFinset := by
    unfold nodesFinset at hS
    exact List.mem_toFinset.mp hS
  rcases List.mem_map.mp hSList with ⟨xs, hxs, hxsS⟩
  have hxsMap : xs ∈ steps.map StepData.node := by
    rw [hcover]
    exact hxs
  rcases List.mem_map.mp hxsMap with ⟨d, hd, hdnode⟩
  have hdcheck : checkStepData (K := K) b nodeChunks cellChunks d = true :=
    (List.all_eq_true.mp h) d hd
  have hdS : d.node.toFinset = S := by
    rw [hdnode, hxsS]
  have hxmove' :
      Move (α := GridPoint K) (GridCap (K := K)) d.node.toFinset x := by
    simpa [hdS] using hxmove
  rcases checkStepData_sound (K := K) hnodes hcells hcellsAll hdcheck x hxmove' with
    ⟨row, hmover, hreply, hchild, hchildNode⟩
  refine ⟨row, hmover, ?_, ?_, hchildNode⟩
  · simpa [hdS] using hreply
  · simpa [hdS] using hchild

omit [Fintype K] in
theorem checkStepDataList_of_chunks {b : BookData K}
    {nodeChunks : List (List (List (GridPoint K)))}
    {cellChunks : List (List (GridPoint K))} {chunks : List (List (StepData K))}
    (h : checkStepDataChunks (K := K) b nodeChunks cellChunks chunks = true) :
    checkStepDataList (K := K) b nodeChunks cellChunks chunks.flatten = true := by
  unfold checkStepDataChunks checkStepDataList at *
  exact allShort_flatten_true
    (fun d => checkStepData (K := K) b nodeChunks cellChunks d) h

omit [Field K] [Fintype K] in
theorem checkStepDataNodes_sound :
    ∀ {steps : List (StepData K)} {nodes : List (List (GridPoint K))},
      checkStepDataNodes (K := K) steps nodes = true ->
        steps.map StepData.node = nodes
  | [], [], _h => rfl
  | [], _node :: _nodes, h => by
      simp [checkStepDataNodes] at h
  | _d :: _ds, [], h => by
      simp [checkStepDataNodes] at h
  | d :: ds, node :: nodes, h => by
      unfold checkStepDataNodes at h
      rw [Bool.and_eq_true] at h
      rcases h with ⟨hd, htail⟩
      have hdnode : d.node = node := of_decide_eq_true hd
      have htailEq : ds.map StepData.node = nodes :=
        checkStepDataNodes_sound htail
      simp [hdnode, htailEq]

omit [Field K] [Fintype K] in
theorem checkStepDataNodeChunks_sound
    {stepChunks : List (List (StepData K))}
    {nodeChunks : List (List (List (GridPoint K)))}
    (h : checkStepDataNodeChunks (K := K) stepChunks nodeChunks = true) :
    stepChunks.flatten.map StepData.node = nodeChunks.flatten := by
  unfold checkStepDataNodeChunks at h
  exact checkStepDataNodes_sound h

omit [Field K] [Fintype K] in
theorem checkStepDataNodeChunkGroups_sound :
    ∀ {stepGroups : List (List (List (StepData K)))}
      {nodeGroups : List (List (List (List (GridPoint K))))},
      checkStepDataNodeChunkGroups (K := K) stepGroups nodeGroups = true ->
        stepGroups.flatten.flatten.map StepData.node = nodeGroups.flatten.flatten
  | [], [], _h => rfl
  | [], _nodeChunks :: _nodeGroups, h => by
      simp [checkStepDataNodeChunkGroups] at h
  | _stepChunks :: _stepGroups, [], h => by
      simp [checkStepDataNodeChunkGroups] at h
  | stepChunks :: stepGroups, nodeChunks :: nodeGroups, h => by
      unfold checkStepDataNodeChunkGroups at h
      rw [Bool.and_eq_true] at h
      rcases h with ⟨hhead, htail⟩
      have hheadEq :
          stepChunks.flatten.map StepData.node = nodeChunks.flatten :=
        checkStepDataNodeChunks_sound hhead
      have htailEq :
          stepGroups.flatten.flatten.map StepData.node = nodeGroups.flatten.flatten :=
        checkStepDataNodeChunkGroups_sound htail
      simp [List.map_append, hheadEq, htailEq]

omit [Field K] [Fintype K] in
theorem childAt_mem_nodesFinset {b : BookData K}
    {nodeChunkGroups : List (List (List (List (GridPoint K))))}
    {g c i : Nat} {child : List (GridPoint K)}
    (hflat : nodeChunkGroups.flatten.flatten = b.nodes)
    (h : childAt (K := K) nodeChunkGroups g c i = some child) :
    child.toFinset ∈ b.nodesFinset := by
  unfold childAt at h
  cases hg : nodeChunkGroups[g]? with
  | none =>
      simp [hg] at h
  | some chunks =>
      cases hc : chunks[c]? with
      | none =>
          simp [hg, hc] at h
      | some nodes =>
          cases hi : nodes[i]? with
          | none =>
              simp [hg, hc, hi] at h
          | some got =>
              simp [hg, hc, hi] at h
              have hgot : got = child := by
                simpa using h
              have hgmem : chunks ∈ nodeChunkGroups := List.mem_of_getElem? hg
              have hcmem : nodes ∈ chunks := List.mem_of_getElem? hc
              have himem : got ∈ nodes := List.mem_of_getElem? hi
              have hchildMem : child ∈ nodeChunkGroups.flatten.flatten := by
                rw [← hgot]
                have hnodesMem : nodes ∈ nodeChunkGroups.flatten :=
                  List.mem_flatten.mpr ⟨chunks, hgmem, hcmem⟩
                exact List.mem_flatten.mpr
                  ⟨nodes, hnodesMem, himem⟩
              unfold nodesFinset
              rw [List.mem_toFinset]
              exact List.mem_map.mpr ⟨child, by simpa [hflat] using hchildMem, rfl⟩

omit [Fintype K] in
theorem checkNodes_sound_of_bool {b : BookData K} (h : checkNodes (K := K) b = true) :
    ∀ S ∈ b.nodesFinset, GridCap (K := K) S := by
  unfold checkNodes at h
  simp only [allShort_eq_all] at h
  intro S hS
  unfold nodesFinset at hS
  have hSList : S ∈ b.nodes.map List.toFinset := List.mem_toFinset.mp hS
  rcases List.mem_map.mp hSList with ⟨xs, hxs, hxsS⟩
  have hxcheck : checkCap (K := K) xs = true :=
    (List.all_eq_true.mp h) xs hxs
  simpa [hxsS] using checkCap_sound (K := K) hxcheck

omit [Fintype K] in
theorem checkRowRefOn_sound {b : BookData K}
    {nodeChunkGroups : List (List (List (List (GridPoint K))))}
    {S : List (GridPoint K)} {x : GridPoint K} {rows : List (RowRefData K)}
    (hgroups : nodeChunkGroups.flatten.flatten = b.nodes)
    (hnodesCheck : checkNodes (K := K) b = true)
    (h : checkRowRefOn (K := K) nodeChunkGroups S x rows = true) :
    ∃ row : ReplyBookRow (GridPoint K),
      row.mover = x ∧
        Move (α := GridPoint K) (GridCap (K := K)) (insert x S.toFinset) row.reply ∧
          row.child = insert row.reply (insert x S.toFinset) ∧
            row.child ∈ b.nodesFinset := by
  unfold checkRowRefOn at h
  simp only [anyShort_eq_any] at h
  rcases List.any_eq_true.mp h with ⟨rr, _hrr, hrmatch⟩
  unfold checkRowRefMatch at hrmatch
  rw [Bool.and_eq_true] at hrmatch
  rcases hrmatch with ⟨hfront, href⟩
  let r := rr.row
  have hfrontProp :
      r.mover = x ∧
          r.reply ∉ insert x S.toFinset ∧
            r.child.toFinset = insert r.reply (insert x S.toFinset) := by
    exact of_decide_eq_true hfront
  have hrefProp :
      childAt (K := K) nodeChunkGroups rr.childGroup rr.childChunk rr.childSlot =
        some r.child := by
    exact of_decide_eq_true href
  rcases hfrontProp with ⟨hmover, hfresh, hchildEq⟩
  have hnode : r.child.toFinset ∈ b.nodesFinset :=
    childAt_mem_nodesFinset (K := K) hgroups hrefProp
  have hchildCap : GridCap (K := K) r.child.toFinset :=
    checkNodes_sound_of_bool (K := K) hnodesCheck r.child.toFinset hnode
  refine ⟨r.toBookRow, hmover, ?_, ?_, hnode⟩
  · show Move (α := GridPoint K) (GridCap (K := K)) (insert x S.toFinset) r.reply
    refine ⟨hfresh, ?_⟩
    simpa [hchildEq] using hchildCap
  · show r.child.toFinset = insert r.reply (insert x S.toFinset)
    exact hchildEq

omit [Fintype K] in
theorem checkNodeStepOnWithLocalRowRefs_sound {b : BookData K}
    {nodeChunkGroups : List (List (List (List (GridPoint K))))}
    {S : List (GridPoint K)} {rows : List (RowRefData K)}
    {cells : List (GridPoint K)}
    (hgroups : nodeChunkGroups.flatten.flatten = b.nodes)
    (hnodesCheck : checkNodes (K := K) b = true)
    (h : checkNodeStepOnWithLocalRowRefs (K := K) nodeChunkGroups S rows cells = true) :
    ∀ x ∈ cells, Move (α := GridPoint K) (GridCap (K := K)) S.toFinset x ->
      ∃ row : ReplyBookRow (GridPoint K),
        row.mover = x ∧
          Move (α := GridPoint K) (GridCap (K := K)) (insert x S.toFinset) row.reply ∧
            row.child = insert row.reply (insert x S.toFinset) ∧
              row.child ∈ b.nodesFinset := by
  unfold checkNodeStepOnWithLocalRowRefs at h
  simp only [allShort_eq_all] at h
  intro x hxmem hxmove
  have hxcheck :
      checkNodeCellWithLocalRowRefs (K := K) nodeChunkGroups S rows x = true :=
    (List.all_eq_true.mp h) x hxmem
  unfold checkNodeCellWithLocalRowRefs at hxcheck
  have hmoveBool : checkMoveFast (K := K) S x = true := checkMoveFast_true (K := K) hxmove
  rw [hmoveBool] at hxcheck
  exact checkRowRefOn_sound (K := K) hgroups hnodesCheck hxcheck

omit [Fintype K] in
theorem checkStepRefData_sound {b : BookData K}
    {nodeChunkGroups : List (List (List (List (GridPoint K))))}
    {cellChunks : List (List (GridPoint K))} {d : StepRefData K}
    (hgroups : nodeChunkGroups.flatten.flatten = b.nodes)
    (hnodesCheck : checkNodes (K := K) b = true)
    (hcells : cellChunks.flatten = b.cells)
    (hcellsAll : ∀ x : GridPoint K, x ∈ b.cells)
    (h : checkStepRefData (K := K) nodeChunkGroups cellChunks d = true) :
    ∀ x : GridPoint K,
      Move (α := GridPoint K) (GridCap (K := K)) d.node.toFinset x ->
        ∃ row : ReplyBookRow (GridPoint K),
          row.mover = x ∧
            Move (α := GridPoint K) (GridCap (K := K)) (insert x d.node.toFinset)
              row.reply ∧
              row.child = insert row.reply (insert x d.node.toFinset) ∧
                row.child ∈ b.nodesFinset := by
  intro x hxmove
  have hxmem : x ∈ cellChunks.flatten := by
    rw [hcells]
    exact hcellsAll x
  unfold checkStepRefData checkNodeStepChunksWithLocalRowRefs at h
  have hflat :
      checkNodeStepOnWithLocalRowRefs (K := K) nodeChunkGroups d.node d.rows
        cellChunks.flatten = true :=
    allShort_flatten_true
      (fun x => checkNodeCellWithLocalRowRefs (K := K) nodeChunkGroups d.node d.rows x) h
  exact checkNodeStepOnWithLocalRowRefs_sound (K := K) hgroups hnodesCheck hflat x hxmem hxmove

omit [Fintype K] in
theorem checkStepRefDataList_sound {b : BookData K}
    {nodeChunkGroups : List (List (List (List (GridPoint K))))}
    {cellChunks : List (List (GridPoint K))} {steps : List (StepRefData K)}
    (hgroups : nodeChunkGroups.flatten.flatten = b.nodes)
    (hnodesCheck : checkNodes (K := K) b = true)
    (hcells : cellChunks.flatten = b.cells)
    (hcellsAll : ∀ x : GridPoint K, x ∈ b.cells)
    (hcover : steps.map StepRefData.node = b.nodes)
    (h : checkStepRefDataList (K := K) nodeChunkGroups cellChunks steps = true) :
    ∀ S ∈ b.nodesFinset, ∀ x : GridPoint K,
      Move (α := GridPoint K) (GridCap (K := K)) S x ->
        ∃ row : ReplyBookRow (GridPoint K),
          row.mover = x ∧
            Move (α := GridPoint K) (GridCap (K := K)) (insert x S) row.reply ∧
              row.child = insert row.reply (insert x S) ∧
                row.child ∈ b.nodesFinset := by
  unfold checkStepRefDataList at h
  simp only [allShort_eq_all] at h
  intro S hS x hxmove
  have hSList : S ∈ b.nodes.map List.toFinset := by
    unfold nodesFinset at hS
    exact List.mem_toFinset.mp hS
  rcases List.mem_map.mp hSList with ⟨xs, hxs, hxsS⟩
  have hxsMap : xs ∈ steps.map StepRefData.node := by
    rw [hcover]
    exact hxs
  rcases List.mem_map.mp hxsMap with ⟨d, hd, hdnode⟩
  have hdcheck : checkStepRefData (K := K) nodeChunkGroups cellChunks d = true :=
    (List.all_eq_true.mp h) d hd
  have hdS : d.node.toFinset = S := by
    rw [hdnode, hxsS]
  have hxmove' :
      Move (α := GridPoint K) (GridCap (K := K)) d.node.toFinset x := by
    simpa [hdS] using hxmove
  rcases checkStepRefData_sound (K := K) hgroups hnodesCheck hcells hcellsAll hdcheck x hxmove' with
    ⟨row, hmover, hreply, hchild, hchildNode⟩
  refine ⟨row, hmover, ?_, ?_, hchildNode⟩
  · simpa [hdS] using hreply
  · simpa [hdS] using hchild

omit [Fintype K] in
theorem checkStepRefDataList_of_chunks
    {nodeChunkGroups : List (List (List (List (GridPoint K))))}
    {cellChunks : List (List (GridPoint K))} {chunks : List (List (StepRefData K))}
    (h : checkStepRefDataChunks (K := K) nodeChunkGroups cellChunks chunks = true) :
    checkStepRefDataList (K := K) nodeChunkGroups cellChunks chunks.flatten = true := by
  unfold checkStepRefDataChunks checkStepRefDataList at *
  exact allShort_flatten_true
    (fun d => checkStepRefData (K := K) nodeChunkGroups cellChunks d) h

omit [Field K] [Fintype K] in
theorem checkStepRefDataNodes_sound :
    ∀ {steps : List (StepRefData K)} {nodes : List (List (GridPoint K))},
      checkStepRefDataNodes (K := K) steps nodes = true ->
        steps.map StepRefData.node = nodes
  | [], [], _h => rfl
  | [], _node :: _nodes, h => by
      simp [checkStepRefDataNodes] at h
  | _d :: _ds, [], h => by
      simp [checkStepRefDataNodes] at h
  | d :: ds, node :: nodes, h => by
      unfold checkStepRefDataNodes at h
      rw [Bool.and_eq_true] at h
      rcases h with ⟨hd, htail⟩
      have hdnode : d.node = node := of_decide_eq_true hd
      have htailEq : ds.map StepRefData.node = nodes :=
        checkStepRefDataNodes_sound htail
      simp [hdnode, htailEq]

omit [Field K] [Fintype K] in
theorem checkStepRefDataNodeChunks_sound
    {stepChunks : List (List (StepRefData K))}
    {nodeChunks : List (List (List (GridPoint K)))}
    (h : checkStepRefDataNodeChunks (K := K) stepChunks nodeChunks = true) :
    stepChunks.flatten.map StepRefData.node = nodeChunks.flatten := by
  unfold checkStepRefDataNodeChunks at h
  exact checkStepRefDataNodes_sound h

omit [Field K] [Fintype K] in
theorem checkStepRefDataNodes_complete :
    ∀ {steps : List (StepRefData K)} {nodes : List (List (GridPoint K))},
      steps.map StepRefData.node = nodes ->
        checkStepRefDataNodes (K := K) steps nodes = true
  | [], [], _h => rfl
  | [], _node :: _nodes, h => by
      simp at h
  | _d :: _ds, [], h => by
      simp at h
  | d :: ds, node :: nodes, h => by
      simp only [List.map_cons, List.cons.injEq] at h
      rcases h with ⟨hnode, htail⟩
      unfold checkStepRefDataNodes
      simp [hnode, checkStepRefDataNodes_complete htail]

omit [Field K] [Fintype K] in
theorem checkStepRefDataNodeChunkGroups_sound :
    ∀ {stepGroups : List (List (List (StepRefData K)))}
      {nodeGroups : List (List (List (List (GridPoint K))))},
      checkStepRefDataNodeChunkGroups (K := K) stepGroups nodeGroups = true ->
        stepGroups.flatten.flatten.map StepRefData.node = nodeGroups.flatten.flatten
  | [], [], _h => rfl
  | [], _nodeChunks :: _nodeGroups, h => by
      simp [checkStepRefDataNodeChunkGroups] at h
  | _stepChunks :: _stepGroups, [], h => by
      simp [checkStepRefDataNodeChunkGroups] at h
  | stepChunks :: stepGroups, nodeChunks :: nodeGroups, h => by
      unfold checkStepRefDataNodeChunkGroups at h
      rw [Bool.and_eq_true] at h
      rcases h with ⟨hhead, htail⟩
      have hheadEq :
          stepChunks.flatten.map StepRefData.node = nodeChunks.flatten :=
        checkStepRefDataNodeChunks_sound hhead
      have htailEq :
          stepGroups.flatten.flatten.map StepRefData.node = nodeGroups.flatten.flatten :=
        checkStepRefDataNodeChunkGroups_sound htail
      simp [List.map_append, hheadEq, htailEq]

omit [Field K] [Fintype K] in
theorem checkStepRefDataNodeChunks_of_groups
    {stepGroups : List (List (List (StepRefData K)))}
    {nodeGroups : List (List (List (List (GridPoint K))))}
    {stepChunks : List (List (StepRefData K))}
    {nodeChunks : List (List (List (GridPoint K)))}
    (hstep : stepGroups.flatten = stepChunks)
    (hnode : nodeGroups.flatten = nodeChunks)
    (h : checkStepRefDataNodeChunkGroups (K := K) stepGroups nodeGroups = true) :
    checkStepRefDataNodeChunks (K := K) stepChunks nodeChunks = true := by
  unfold checkStepRefDataNodeChunks
  have hEq :
      stepGroups.flatten.flatten.map StepRefData.node = nodeGroups.flatten.flatten :=
    checkStepRefDataNodeChunkGroups_sound h
  exact checkStepRefDataNodes_complete (K := K) (by
    simpa [← hstep, ← hnode] using hEq)

def checkNodeStepOld (b : BookData K) (S : List (GridPoint K)) : Bool :=
  allShort
    (fun x => if checkMove (K := K) S x then checkRow (K := K) b S x else true)
    b.cells

def checkSteps (b : BookData K) : Bool :=
  allShort (fun S => checkNodeStep (K := K) b S) b.nodes

def checkStepsChunks (b : BookData K) (chunks : List (List (List (GridPoint K)))) : Bool :=
  allShort (fun nodes => allShort (fun S => checkNodeStep (K := K) b S) nodes) chunks

omit [Fintype K] in
theorem checkSteps_of_chunks {b : BookData K}
    {chunks : List (List (List (GridPoint K)))}
    (hflat : chunks.flatten = b.nodes)
    (h : checkStepsChunks (K := K) b chunks = true) :
    checkSteps (K := K) b = true := by
  unfold checkSteps
  unfold checkStepsChunks at h
  rw [← hflat]
  exact allShort_flatten_true (fun S => checkNodeStep (K := K) b S) h

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

omit [Fintype K] in
theorem validForLoose_of_stepData {b : BookData K}
    {nodeChunks : List (List (List (GridPoint K)))}
    {cellChunks : List (List (GridPoint K))} {steps : List (StepData K)}
    (hroot : b.root.toFinset ∈ b.nodesFinset)
    (hnodesCheck : checkNodes (K := K) b = true)
    (hcellsAll : ∀ x : GridPoint K, x ∈ b.cells)
    (hnodes : nodeChunks.flatten = b.nodes)
    (hcells : cellChunks.flatten = b.cells)
    (hcover : steps.map StepData.node = b.nodes)
    (hsteps : checkStepDataList (K := K) b nodeChunks cellChunks steps = true) :
    b.toLooseDAG.ValidFor (GridCap (K := K)) := by
  unfold toLooseDAG
  refine ⟨hroot, ?_, ?_⟩
  · intro S hS
    exact checkNodes_sound (K := K) hnodesCheck S hS
  · intro S hS x hxmove
    rcases checkStepDataList_sound (K := K) hnodes hcells hcellsAll hcover hsteps
        S hS x hxmove with
      ⟨row, hmover, hreply, hchild, hchildNode⟩
    exact ⟨row, trivial, hmover, hreply, hchild, hchildNode⟩

omit [Fintype K] in
theorem validForLoose_of_stepRefData {b : BookData K}
    {nodeChunkGroups : List (List (List (List (GridPoint K))))}
    {cellChunks : List (List (GridPoint K))} {steps : List (StepRefData K)}
    (hroot : b.root.toFinset ∈ b.nodesFinset)
    (hnodesCheck : checkNodes (K := K) b = true)
    (hcellsAll : ∀ x : GridPoint K, x ∈ b.cells)
    (hgroups : nodeChunkGroups.flatten.flatten = b.nodes)
    (hcells : cellChunks.flatten = b.cells)
    (hcover : steps.map StepRefData.node = b.nodes)
    (hsteps : checkStepRefDataList (K := K) nodeChunkGroups cellChunks steps = true) :
    b.toLooseDAG.ValidFor (GridCap (K := K)) := by
  unfold toLooseDAG
  refine ⟨hroot, ?_, ?_⟩
  · intro S hS
    exact checkNodes_sound (K := K) hnodesCheck S hS
  · intro S hS x hxmove
    rcases checkStepRefDataList_sound (K := K) hgroups hnodesCheck hcells hcellsAll hcover hsteps
        S hS x hxmove with
      ⟨row, hmover, hreply, hchild, hchildNode⟩
    exact ⟨row, trivial, hmover, hreply, hchild, hchildNode⟩

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

def toLooseCert (c : ClassData K) : GridClassCert K where
  classIndex := c.classIndex
  sizeThree := c.sizeThree.toFinset
  witness := c.witness
  book := c.book.toLooseDAG

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
