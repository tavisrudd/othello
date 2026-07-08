import ProjectiveCap.CertCheck

namespace ProjectiveCap
namespace Certificate
namespace CertData
namespace Q7

instance : Fact (Nat.Prime 7) := Fact.mk (by decide)

abbrev K := ZMod 7
abbrev P := GridPoint K

def pt (r c : Nat) : P := ((r : K), (c : K))

def allCellsChunk0 : List P :=
  ([pt 0 0, pt 0 1, pt 0 2, pt 0 3, pt 0 4, pt 0 5, pt 0 6, pt 1 0, pt 1 1, pt 1 2, pt 1 3] : List (P))
def allCellsChunk1 : List P :=
  ([pt 1 4, pt 1 5, pt 1 6, pt 2 0, pt 2 1, pt 2 2, pt 2 3, pt 2 4, pt 2 5, pt 2 6, pt 3 0] : List (P))
def allCellsChunk2 : List P :=
  ([pt 3 1, pt 3 2, pt 3 3, pt 3 4, pt 3 5, pt 3 6, pt 4 0, pt 4 1, pt 4 2, pt 4 3, pt 4 4] : List (P))
def allCellsChunk3 : List P :=
  ([pt 4 5, pt 4 6, pt 5 0, pt 5 1, pt 5 2, pt 5 3, pt 5 4, pt 5 5, pt 5 6, pt 6 0, pt 6 1] : List (P))
def allCellsChunk4 : List P :=
  ([pt 6 2, pt 6 3, pt 6 4, pt 6 5, pt 6 6] : List (P))
def allCellChunks : List (List P) :=
  ([allCellsChunk0, allCellsChunk1, allCellsChunk2, allCellsChunk3, allCellsChunk4] : List (List P))
def allCells : List P :=
  allCellChunks.flatten
theorem allCells_mem (x : GridPoint K) : x ∈ allCells := by
  rcases x with ⟨r, c⟩
  fin_cases r <;> fin_cases c <;> decide

def class0_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 2 3] : List (P))
def class0_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 3, pt 3 2] : List (P))
def class0_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 2 3, pt 3 2, pt 5 6, pt 6 5] : List (P))
def class0_nodes : List (List P) :=
  ([class0_node0, class0_node1] : List (List P))
def class0_row0 : CertCheck.RowData K where
  node := class0_node0
  mover := pt 5 6
  reply := pt 6 5
  child := class0_node1
def class0_row1 : CertCheck.RowData K where
  node := class0_node0
  mover := pt 6 5
  reply := pt 5 6
  child := class0_node1
def class0_rows : List (CertCheck.RowData K) :=
  ([class0_row0, class0_row1] : List (CertCheck.RowData K))
def class0_book : CertCheck.BookData K where
  cells := allCells
  root := class0_node0
  nodes := class0_nodes
  rows := class0_rows
theorem class0_book_cells_eq : class0_book.cells = allCells := by
  rfl
theorem class0_book_nodes_eq : class0_book.nodes = class0_nodes := by
  rfl
def class0_data : CertCheck.ClassData K where
  classIndex := 0
  sizeThree := class0_s3
  witness := pt 3 2
  book := class0_book
def class0 : GridClassCert K :=
  class0_data.toCert
theorem class0_size_check :
    decide (class0_s3.toFinset.card = 3) = true := by
  rfl
theorem class0_s3_cap_check :
    CertCheck.checkCap (K := K) class0_s3 = true := by
  rfl
theorem class0_witness_check :
    CertCheck.checkMove (K := K) class0_s3 (pt 3 2) = true := by
  rfl
theorem class0_root_eq_check :
    decide (class0_book.root.toFinset = insert (pt 3 2) class0_s3.toFinset) = true := by
  rfl
theorem class0_root_check :
    CertCheck.BookData.checkRoot (K := K) class0_book = true := by
  rfl
theorem class0_node0_cap_check :
    CertCheck.checkCap (K := K) class0_node0 = true := by
  rfl
theorem class0_node1_cap_check :
    CertCheck.checkCap (K := K) class0_node1 = true := by
  rfl
theorem class0_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class0_book = true := by
  simp [CertCheck.BookData.checkNodes, class0_book_nodes_eq, class0_nodes, class0_node0_cap_check, class0_node1_cap_check]
theorem class0_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class0_book class0_node0 allCellChunks = true := by
  rfl
theorem class0_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class0_book class0_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class0_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class0_step0_chunks_check
theorem class0_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class0_book class0_node1 allCellChunks = true := by
  rfl
theorem class0_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class0_book class0_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class0_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class0_step1_chunks_check
theorem class0_steps_check :
    CertCheck.BookData.checkSteps (K := K) class0_book = true := by
  simp [CertCheck.BookData.checkSteps, class0_book_nodes_eq, class0_nodes, class0_step0_check, class0_step1_check]
theorem class0_book_valid :
    class0_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class0_book.cells := by
    intro x
    rw [class0_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class0_book.root.toFinset)
    (nodes := class0_book.nodesFinset)
    (rows := class0_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class0_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class0_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class0_steps_check)
theorem class0_valid : class0.Valid := by
  unfold class0 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class0_size_check
  · exact CertCheck.checkCap_sound (K := K) class0_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class0_witness_check)
  · exact of_decide_eq_true class0_root_eq_check
  · exact class0_book_valid

def class1_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 2 4] : List (P))
def class1_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 4, pt 4 6] : List (P))
def class1_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 2 4, pt 4 6, pt 5 2, pt 6 3] : List (P))
def class1_nodes : List (List P) :=
  ([class1_node0, class1_node1] : List (List P))
def class1_row0 : CertCheck.RowData K where
  node := class1_node0
  mover := pt 5 2
  reply := pt 6 3
  child := class1_node1
def class1_row1 : CertCheck.RowData K where
  node := class1_node0
  mover := pt 6 3
  reply := pt 5 2
  child := class1_node1
def class1_rows : List (CertCheck.RowData K) :=
  ([class1_row0, class1_row1] : List (CertCheck.RowData K))
def class1_book : CertCheck.BookData K where
  cells := allCells
  root := class1_node0
  nodes := class1_nodes
  rows := class1_rows
theorem class1_book_cells_eq : class1_book.cells = allCells := by
  rfl
theorem class1_book_nodes_eq : class1_book.nodes = class1_nodes := by
  rfl
def class1_data : CertCheck.ClassData K where
  classIndex := 1
  sizeThree := class1_s3
  witness := pt 4 6
  book := class1_book
def class1 : GridClassCert K :=
  class1_data.toCert
theorem class1_size_check :
    decide (class1_s3.toFinset.card = 3) = true := by
  rfl
theorem class1_s3_cap_check :
    CertCheck.checkCap (K := K) class1_s3 = true := by
  rfl
theorem class1_witness_check :
    CertCheck.checkMove (K := K) class1_s3 (pt 4 6) = true := by
  rfl
theorem class1_root_eq_check :
    decide (class1_book.root.toFinset = insert (pt 4 6) class1_s3.toFinset) = true := by
  rfl
theorem class1_root_check :
    CertCheck.BookData.checkRoot (K := K) class1_book = true := by
  rfl
theorem class1_node0_cap_check :
    CertCheck.checkCap (K := K) class1_node0 = true := by
  rfl
theorem class1_node1_cap_check :
    CertCheck.checkCap (K := K) class1_node1 = true := by
  rfl
theorem class1_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class1_book = true := by
  simp [CertCheck.BookData.checkNodes, class1_book_nodes_eq, class1_nodes, class1_node0_cap_check, class1_node1_cap_check]
theorem class1_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class1_book class1_node0 allCellChunks = true := by
  rfl
theorem class1_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class1_book class1_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class1_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class1_step0_chunks_check
theorem class1_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class1_book class1_node1 allCellChunks = true := by
  rfl
theorem class1_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class1_book class1_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class1_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class1_step1_chunks_check
theorem class1_steps_check :
    CertCheck.BookData.checkSteps (K := K) class1_book = true := by
  simp [CertCheck.BookData.checkSteps, class1_book_nodes_eq, class1_nodes, class1_step0_check, class1_step1_check]
theorem class1_book_valid :
    class1_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class1_book.cells := by
    intro x
    rw [class1_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class1_book.root.toFinset)
    (nodes := class1_book.nodesFinset)
    (rows := class1_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class1_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class1_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class1_steps_check)
theorem class1_valid : class1.Valid := by
  unfold class1 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class1_size_check
  · exact CertCheck.checkCap_sound (K := K) class1_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class1_witness_check)
  · exact of_decide_eq_true class1_root_eq_check
  · exact class1_book_valid

def class2_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 2 5] : List (P))
def class2_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 5, pt 3 6] : List (P))
def class2_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 2 5, pt 3 6, pt 4 2, pt 6 4] : List (P))
def class2_nodes : List (List P) :=
  ([class2_node0, class2_node1] : List (List P))
def class2_row0 : CertCheck.RowData K where
  node := class2_node0
  mover := pt 4 2
  reply := pt 6 4
  child := class2_node1
def class2_row1 : CertCheck.RowData K where
  node := class2_node0
  mover := pt 6 4
  reply := pt 4 2
  child := class2_node1
def class2_rows : List (CertCheck.RowData K) :=
  ([class2_row0, class2_row1] : List (CertCheck.RowData K))
def class2_book : CertCheck.BookData K where
  cells := allCells
  root := class2_node0
  nodes := class2_nodes
  rows := class2_rows
theorem class2_book_cells_eq : class2_book.cells = allCells := by
  rfl
theorem class2_book_nodes_eq : class2_book.nodes = class2_nodes := by
  rfl
def class2_data : CertCheck.ClassData K where
  classIndex := 2
  sizeThree := class2_s3
  witness := pt 3 6
  book := class2_book
def class2 : GridClassCert K :=
  class2_data.toCert
theorem class2_size_check :
    decide (class2_s3.toFinset.card = 3) = true := by
  rfl
theorem class2_s3_cap_check :
    CertCheck.checkCap (K := K) class2_s3 = true := by
  rfl
theorem class2_witness_check :
    CertCheck.checkMove (K := K) class2_s3 (pt 3 6) = true := by
  rfl
theorem class2_root_eq_check :
    decide (class2_book.root.toFinset = insert (pt 3 6) class2_s3.toFinset) = true := by
  rfl
theorem class2_root_check :
    CertCheck.BookData.checkRoot (K := K) class2_book = true := by
  rfl
theorem class2_node0_cap_check :
    CertCheck.checkCap (K := K) class2_node0 = true := by
  rfl
theorem class2_node1_cap_check :
    CertCheck.checkCap (K := K) class2_node1 = true := by
  rfl
theorem class2_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class2_book = true := by
  simp [CertCheck.BookData.checkNodes, class2_book_nodes_eq, class2_nodes, class2_node0_cap_check, class2_node1_cap_check]
theorem class2_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class2_book class2_node0 allCellChunks = true := by
  rfl
theorem class2_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class2_book class2_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class2_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class2_step0_chunks_check
theorem class2_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class2_book class2_node1 allCellChunks = true := by
  rfl
theorem class2_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class2_book class2_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class2_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class2_step1_chunks_check
theorem class2_steps_check :
    CertCheck.BookData.checkSteps (K := K) class2_book = true := by
  simp [CertCheck.BookData.checkSteps, class2_book_nodes_eq, class2_nodes, class2_step0_check, class2_step1_check]
theorem class2_book_valid :
    class2_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class2_book.cells := by
    intro x
    rw [class2_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class2_book.root.toFinset)
    (nodes := class2_book.nodesFinset)
    (rows := class2_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class2_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class2_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class2_steps_check)
theorem class2_valid : class2.Valid := by
  unfold class2 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class2_size_check
  · exact CertCheck.checkCap_sound (K := K) class2_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class2_witness_check)
  · exact of_decide_eq_true class2_root_eq_check
  · exact class2_book_valid

def class3_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 2 6] : List (P))
def class3_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 6, pt 3 5] : List (P))
def class3_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 2 6, pt 3 5, pt 4 3, pt 5 4] : List (P))
def class3_nodes : List (List P) :=
  ([class3_node0, class3_node1] : List (List P))
def class3_row0 : CertCheck.RowData K where
  node := class3_node0
  mover := pt 4 3
  reply := pt 5 4
  child := class3_node1
def class3_row1 : CertCheck.RowData K where
  node := class3_node0
  mover := pt 5 4
  reply := pt 4 3
  child := class3_node1
def class3_rows : List (CertCheck.RowData K) :=
  ([class3_row0, class3_row1] : List (CertCheck.RowData K))
def class3_book : CertCheck.BookData K where
  cells := allCells
  root := class3_node0
  nodes := class3_nodes
  rows := class3_rows
theorem class3_book_cells_eq : class3_book.cells = allCells := by
  rfl
theorem class3_book_nodes_eq : class3_book.nodes = class3_nodes := by
  rfl
def class3_data : CertCheck.ClassData K where
  classIndex := 3
  sizeThree := class3_s3
  witness := pt 3 5
  book := class3_book
def class3 : GridClassCert K :=
  class3_data.toCert
theorem class3_size_check :
    decide (class3_s3.toFinset.card = 3) = true := by
  rfl
theorem class3_s3_cap_check :
    CertCheck.checkCap (K := K) class3_s3 = true := by
  rfl
theorem class3_witness_check :
    CertCheck.checkMove (K := K) class3_s3 (pt 3 5) = true := by
  rfl
theorem class3_root_eq_check :
    decide (class3_book.root.toFinset = insert (pt 3 5) class3_s3.toFinset) = true := by
  rfl
theorem class3_root_check :
    CertCheck.BookData.checkRoot (K := K) class3_book = true := by
  rfl
theorem class3_node0_cap_check :
    CertCheck.checkCap (K := K) class3_node0 = true := by
  rfl
theorem class3_node1_cap_check :
    CertCheck.checkCap (K := K) class3_node1 = true := by
  rfl
theorem class3_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class3_book = true := by
  simp [CertCheck.BookData.checkNodes, class3_book_nodes_eq, class3_nodes, class3_node0_cap_check, class3_node1_cap_check]
theorem class3_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class3_book class3_node0 allCellChunks = true := by
  rfl
theorem class3_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class3_book class3_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class3_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class3_step0_chunks_check
theorem class3_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class3_book class3_node1 allCellChunks = true := by
  rfl
theorem class3_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class3_book class3_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class3_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class3_step1_chunks_check
theorem class3_steps_check :
    CertCheck.BookData.checkSteps (K := K) class3_book = true := by
  simp [CertCheck.BookData.checkSteps, class3_book_nodes_eq, class3_nodes, class3_step0_check, class3_step1_check]
theorem class3_book_valid :
    class3_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class3_book.cells := by
    intro x
    rw [class3_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class3_book.root.toFinset)
    (nodes := class3_book.nodesFinset)
    (rows := class3_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class3_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class3_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class3_steps_check)
theorem class3_valid : class3.Valid := by
  unfold class3 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class3_size_check
  · exact CertCheck.checkCap_sound (K := K) class3_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class3_witness_check)
  · exact of_decide_eq_true class3_root_eq_check
  · exact class3_book_valid

def class4_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 3 2] : List (P))
def class4_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 3, pt 3 2] : List (P))
def class4_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 2 3, pt 3 2, pt 5 6, pt 6 5] : List (P))
def class4_nodes : List (List P) :=
  ([class4_node0, class4_node1] : List (List P))
def class4_row0 : CertCheck.RowData K where
  node := class4_node0
  mover := pt 5 6
  reply := pt 6 5
  child := class4_node1
def class4_row1 : CertCheck.RowData K where
  node := class4_node0
  mover := pt 6 5
  reply := pt 5 6
  child := class4_node1
def class4_rows : List (CertCheck.RowData K) :=
  ([class4_row0, class4_row1] : List (CertCheck.RowData K))
def class4_book : CertCheck.BookData K where
  cells := allCells
  root := class4_node0
  nodes := class4_nodes
  rows := class4_rows
theorem class4_book_cells_eq : class4_book.cells = allCells := by
  rfl
theorem class4_book_nodes_eq : class4_book.nodes = class4_nodes := by
  rfl
def class4_data : CertCheck.ClassData K where
  classIndex := 4
  sizeThree := class4_s3
  witness := pt 2 3
  book := class4_book
def class4 : GridClassCert K :=
  class4_data.toCert
theorem class4_size_check :
    decide (class4_s3.toFinset.card = 3) = true := by
  rfl
theorem class4_s3_cap_check :
    CertCheck.checkCap (K := K) class4_s3 = true := by
  rfl
theorem class4_witness_check :
    CertCheck.checkMove (K := K) class4_s3 (pt 2 3) = true := by
  rfl
theorem class4_root_eq_check :
    decide (class4_book.root.toFinset = insert (pt 2 3) class4_s3.toFinset) = true := by
  rfl
theorem class4_root_check :
    CertCheck.BookData.checkRoot (K := K) class4_book = true := by
  rfl
theorem class4_node0_cap_check :
    CertCheck.checkCap (K := K) class4_node0 = true := by
  rfl
theorem class4_node1_cap_check :
    CertCheck.checkCap (K := K) class4_node1 = true := by
  rfl
theorem class4_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class4_book = true := by
  simp [CertCheck.BookData.checkNodes, class4_book_nodes_eq, class4_nodes, class4_node0_cap_check, class4_node1_cap_check]
theorem class4_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class4_book class4_node0 allCellChunks = true := by
  rfl
theorem class4_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class4_book class4_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class4_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class4_step0_chunks_check
theorem class4_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class4_book class4_node1 allCellChunks = true := by
  rfl
theorem class4_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class4_book class4_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class4_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class4_step1_chunks_check
theorem class4_steps_check :
    CertCheck.BookData.checkSteps (K := K) class4_book = true := by
  simp [CertCheck.BookData.checkSteps, class4_book_nodes_eq, class4_nodes, class4_step0_check, class4_step1_check]
theorem class4_book_valid :
    class4_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class4_book.cells := by
    intro x
    rw [class4_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class4_book.root.toFinset)
    (nodes := class4_book.nodesFinset)
    (rows := class4_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class4_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class4_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class4_steps_check)
theorem class4_valid : class4.Valid := by
  unfold class4 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class4_size_check
  · exact CertCheck.checkCap_sound (K := K) class4_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class4_witness_check)
  · exact of_decide_eq_true class4_root_eq_check
  · exact class4_book_valid

def class5_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 3 4] : List (P))
def class5_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 3 4, pt 4 5] : List (P))
def class5_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 3 4, pt 4 5, pt 5 3, pt 6 2] : List (P))
def class5_nodes : List (List P) :=
  ([class5_node0, class5_node1] : List (List P))
def class5_row0 : CertCheck.RowData K where
  node := class5_node0
  mover := pt 5 3
  reply := pt 6 2
  child := class5_node1
def class5_row1 : CertCheck.RowData K where
  node := class5_node0
  mover := pt 6 2
  reply := pt 5 3
  child := class5_node1
def class5_rows : List (CertCheck.RowData K) :=
  ([class5_row0, class5_row1] : List (CertCheck.RowData K))
def class5_book : CertCheck.BookData K where
  cells := allCells
  root := class5_node0
  nodes := class5_nodes
  rows := class5_rows
theorem class5_book_cells_eq : class5_book.cells = allCells := by
  rfl
theorem class5_book_nodes_eq : class5_book.nodes = class5_nodes := by
  rfl
def class5_data : CertCheck.ClassData K where
  classIndex := 5
  sizeThree := class5_s3
  witness := pt 4 5
  book := class5_book
def class5 : GridClassCert K :=
  class5_data.toCert
theorem class5_size_check :
    decide (class5_s3.toFinset.card = 3) = true := by
  rfl
theorem class5_s3_cap_check :
    CertCheck.checkCap (K := K) class5_s3 = true := by
  rfl
theorem class5_witness_check :
    CertCheck.checkMove (K := K) class5_s3 (pt 4 5) = true := by
  rfl
theorem class5_root_eq_check :
    decide (class5_book.root.toFinset = insert (pt 4 5) class5_s3.toFinset) = true := by
  rfl
theorem class5_root_check :
    CertCheck.BookData.checkRoot (K := K) class5_book = true := by
  rfl
theorem class5_node0_cap_check :
    CertCheck.checkCap (K := K) class5_node0 = true := by
  rfl
theorem class5_node1_cap_check :
    CertCheck.checkCap (K := K) class5_node1 = true := by
  rfl
theorem class5_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class5_book = true := by
  simp [CertCheck.BookData.checkNodes, class5_book_nodes_eq, class5_nodes, class5_node0_cap_check, class5_node1_cap_check]
theorem class5_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class5_book class5_node0 allCellChunks = true := by
  rfl
theorem class5_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class5_book class5_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class5_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class5_step0_chunks_check
theorem class5_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class5_book class5_node1 allCellChunks = true := by
  rfl
theorem class5_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class5_book class5_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class5_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class5_step1_chunks_check
theorem class5_steps_check :
    CertCheck.BookData.checkSteps (K := K) class5_book = true := by
  simp [CertCheck.BookData.checkSteps, class5_book_nodes_eq, class5_nodes, class5_step0_check, class5_step1_check]
theorem class5_book_valid :
    class5_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class5_book.cells := by
    intro x
    rw [class5_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class5_book.root.toFinset)
    (nodes := class5_book.nodesFinset)
    (rows := class5_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class5_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class5_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class5_steps_check)
theorem class5_valid : class5.Valid := by
  unfold class5 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class5_size_check
  · exact CertCheck.checkCap_sound (K := K) class5_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class5_witness_check)
  · exact of_decide_eq_true class5_root_eq_check
  · exact class5_book_valid

def class6_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 3 5] : List (P))
def class6_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 6, pt 3 5] : List (P))
def class6_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 2 6, pt 3 5, pt 4 3, pt 5 4] : List (P))
def class6_nodes : List (List P) :=
  ([class6_node0, class6_node1] : List (List P))
def class6_row0 : CertCheck.RowData K where
  node := class6_node0
  mover := pt 4 3
  reply := pt 5 4
  child := class6_node1
def class6_row1 : CertCheck.RowData K where
  node := class6_node0
  mover := pt 5 4
  reply := pt 4 3
  child := class6_node1
def class6_rows : List (CertCheck.RowData K) :=
  ([class6_row0, class6_row1] : List (CertCheck.RowData K))
def class6_book : CertCheck.BookData K where
  cells := allCells
  root := class6_node0
  nodes := class6_nodes
  rows := class6_rows
theorem class6_book_cells_eq : class6_book.cells = allCells := by
  rfl
theorem class6_book_nodes_eq : class6_book.nodes = class6_nodes := by
  rfl
def class6_data : CertCheck.ClassData K where
  classIndex := 6
  sizeThree := class6_s3
  witness := pt 2 6
  book := class6_book
def class6 : GridClassCert K :=
  class6_data.toCert
theorem class6_size_check :
    decide (class6_s3.toFinset.card = 3) = true := by
  rfl
theorem class6_s3_cap_check :
    CertCheck.checkCap (K := K) class6_s3 = true := by
  rfl
theorem class6_witness_check :
    CertCheck.checkMove (K := K) class6_s3 (pt 2 6) = true := by
  rfl
theorem class6_root_eq_check :
    decide (class6_book.root.toFinset = insert (pt 2 6) class6_s3.toFinset) = true := by
  rfl
theorem class6_root_check :
    CertCheck.BookData.checkRoot (K := K) class6_book = true := by
  rfl
theorem class6_node0_cap_check :
    CertCheck.checkCap (K := K) class6_node0 = true := by
  rfl
theorem class6_node1_cap_check :
    CertCheck.checkCap (K := K) class6_node1 = true := by
  rfl
theorem class6_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class6_book = true := by
  simp [CertCheck.BookData.checkNodes, class6_book_nodes_eq, class6_nodes, class6_node0_cap_check, class6_node1_cap_check]
theorem class6_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class6_book class6_node0 allCellChunks = true := by
  rfl
theorem class6_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class6_book class6_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class6_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class6_step0_chunks_check
theorem class6_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class6_book class6_node1 allCellChunks = true := by
  rfl
theorem class6_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class6_book class6_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class6_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class6_step1_chunks_check
theorem class6_steps_check :
    CertCheck.BookData.checkSteps (K := K) class6_book = true := by
  simp [CertCheck.BookData.checkSteps, class6_book_nodes_eq, class6_nodes, class6_step0_check, class6_step1_check]
theorem class6_book_valid :
    class6_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class6_book.cells := by
    intro x
    rw [class6_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class6_book.root.toFinset)
    (nodes := class6_book.nodesFinset)
    (rows := class6_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class6_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class6_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class6_steps_check)
theorem class6_valid : class6.Valid := by
  unfold class6 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class6_size_check
  · exact CertCheck.checkCap_sound (K := K) class6_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class6_witness_check)
  · exact of_decide_eq_true class6_root_eq_check
  · exact class6_book_valid

def class7_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 3 6] : List (P))
def class7_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 5, pt 3 6] : List (P))
def class7_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 2 5, pt 3 6, pt 4 2, pt 6 4] : List (P))
def class7_nodes : List (List P) :=
  ([class7_node0, class7_node1] : List (List P))
def class7_row0 : CertCheck.RowData K where
  node := class7_node0
  mover := pt 4 2
  reply := pt 6 4
  child := class7_node1
def class7_row1 : CertCheck.RowData K where
  node := class7_node0
  mover := pt 6 4
  reply := pt 4 2
  child := class7_node1
def class7_rows : List (CertCheck.RowData K) :=
  ([class7_row0, class7_row1] : List (CertCheck.RowData K))
def class7_book : CertCheck.BookData K where
  cells := allCells
  root := class7_node0
  nodes := class7_nodes
  rows := class7_rows
theorem class7_book_cells_eq : class7_book.cells = allCells := by
  rfl
theorem class7_book_nodes_eq : class7_book.nodes = class7_nodes := by
  rfl
def class7_data : CertCheck.ClassData K where
  classIndex := 7
  sizeThree := class7_s3
  witness := pt 2 5
  book := class7_book
def class7 : GridClassCert K :=
  class7_data.toCert
theorem class7_size_check :
    decide (class7_s3.toFinset.card = 3) = true := by
  rfl
theorem class7_s3_cap_check :
    CertCheck.checkCap (K := K) class7_s3 = true := by
  rfl
theorem class7_witness_check :
    CertCheck.checkMove (K := K) class7_s3 (pt 2 5) = true := by
  rfl
theorem class7_root_eq_check :
    decide (class7_book.root.toFinset = insert (pt 2 5) class7_s3.toFinset) = true := by
  rfl
theorem class7_root_check :
    CertCheck.BookData.checkRoot (K := K) class7_book = true := by
  rfl
theorem class7_node0_cap_check :
    CertCheck.checkCap (K := K) class7_node0 = true := by
  rfl
theorem class7_node1_cap_check :
    CertCheck.checkCap (K := K) class7_node1 = true := by
  rfl
theorem class7_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class7_book = true := by
  simp [CertCheck.BookData.checkNodes, class7_book_nodes_eq, class7_nodes, class7_node0_cap_check, class7_node1_cap_check]
theorem class7_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class7_book class7_node0 allCellChunks = true := by
  rfl
theorem class7_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class7_book class7_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class7_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class7_step0_chunks_check
theorem class7_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class7_book class7_node1 allCellChunks = true := by
  rfl
theorem class7_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class7_book class7_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class7_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class7_step1_chunks_check
theorem class7_steps_check :
    CertCheck.BookData.checkSteps (K := K) class7_book = true := by
  simp [CertCheck.BookData.checkSteps, class7_book_nodes_eq, class7_nodes, class7_step0_check, class7_step1_check]
theorem class7_book_valid :
    class7_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class7_book.cells := by
    intro x
    rw [class7_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class7_book.root.toFinset)
    (nodes := class7_book.nodesFinset)
    (rows := class7_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class7_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class7_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class7_steps_check)
theorem class7_valid : class7.Valid := by
  unfold class7 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class7_size_check
  · exact CertCheck.checkCap_sound (K := K) class7_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class7_witness_check)
  · exact of_decide_eq_true class7_root_eq_check
  · exact class7_book_valid

def class8_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 4 2] : List (P))
def class8_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 5, pt 4 2] : List (P))
def class8_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 2 5, pt 3 6, pt 4 2, pt 6 4] : List (P))
def class8_nodes : List (List P) :=
  ([class8_node0, class8_node1] : List (List P))
def class8_row0 : CertCheck.RowData K where
  node := class8_node0
  mover := pt 3 6
  reply := pt 6 4
  child := class8_node1
def class8_row1 : CertCheck.RowData K where
  node := class8_node0
  mover := pt 6 4
  reply := pt 3 6
  child := class8_node1
def class8_rows : List (CertCheck.RowData K) :=
  ([class8_row0, class8_row1] : List (CertCheck.RowData K))
def class8_book : CertCheck.BookData K where
  cells := allCells
  root := class8_node0
  nodes := class8_nodes
  rows := class8_rows
theorem class8_book_cells_eq : class8_book.cells = allCells := by
  rfl
theorem class8_book_nodes_eq : class8_book.nodes = class8_nodes := by
  rfl
def class8_data : CertCheck.ClassData K where
  classIndex := 8
  sizeThree := class8_s3
  witness := pt 2 5
  book := class8_book
def class8 : GridClassCert K :=
  class8_data.toCert
theorem class8_size_check :
    decide (class8_s3.toFinset.card = 3) = true := by
  rfl
theorem class8_s3_cap_check :
    CertCheck.checkCap (K := K) class8_s3 = true := by
  rfl
theorem class8_witness_check :
    CertCheck.checkMove (K := K) class8_s3 (pt 2 5) = true := by
  rfl
theorem class8_root_eq_check :
    decide (class8_book.root.toFinset = insert (pt 2 5) class8_s3.toFinset) = true := by
  rfl
theorem class8_root_check :
    CertCheck.BookData.checkRoot (K := K) class8_book = true := by
  rfl
theorem class8_node0_cap_check :
    CertCheck.checkCap (K := K) class8_node0 = true := by
  rfl
theorem class8_node1_cap_check :
    CertCheck.checkCap (K := K) class8_node1 = true := by
  rfl
theorem class8_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class8_book = true := by
  simp [CertCheck.BookData.checkNodes, class8_book_nodes_eq, class8_nodes, class8_node0_cap_check, class8_node1_cap_check]
theorem class8_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class8_book class8_node0 allCellChunks = true := by
  rfl
theorem class8_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class8_book class8_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class8_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class8_step0_chunks_check
theorem class8_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class8_book class8_node1 allCellChunks = true := by
  rfl
theorem class8_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class8_book class8_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class8_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class8_step1_chunks_check
theorem class8_steps_check :
    CertCheck.BookData.checkSteps (K := K) class8_book = true := by
  simp [CertCheck.BookData.checkSteps, class8_book_nodes_eq, class8_nodes, class8_step0_check, class8_step1_check]
theorem class8_book_valid :
    class8_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class8_book.cells := by
    intro x
    rw [class8_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class8_book.root.toFinset)
    (nodes := class8_book.nodesFinset)
    (rows := class8_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class8_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class8_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class8_steps_check)
theorem class8_valid : class8.Valid := by
  unfold class8 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class8_size_check
  · exact CertCheck.checkCap_sound (K := K) class8_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class8_witness_check)
  · exact of_decide_eq_true class8_root_eq_check
  · exact class8_book_valid

def class9_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 4 3] : List (P))
def class9_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 6, pt 4 3] : List (P))
def class9_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 2 6, pt 3 5, pt 4 3, pt 5 4] : List (P))
def class9_nodes : List (List P) :=
  ([class9_node0, class9_node1] : List (List P))
def class9_row0 : CertCheck.RowData K where
  node := class9_node0
  mover := pt 3 5
  reply := pt 5 4
  child := class9_node1
def class9_row1 : CertCheck.RowData K where
  node := class9_node0
  mover := pt 5 4
  reply := pt 3 5
  child := class9_node1
def class9_rows : List (CertCheck.RowData K) :=
  ([class9_row0, class9_row1] : List (CertCheck.RowData K))
def class9_book : CertCheck.BookData K where
  cells := allCells
  root := class9_node0
  nodes := class9_nodes
  rows := class9_rows
theorem class9_book_cells_eq : class9_book.cells = allCells := by
  rfl
theorem class9_book_nodes_eq : class9_book.nodes = class9_nodes := by
  rfl
def class9_data : CertCheck.ClassData K where
  classIndex := 9
  sizeThree := class9_s3
  witness := pt 2 6
  book := class9_book
def class9 : GridClassCert K :=
  class9_data.toCert
theorem class9_size_check :
    decide (class9_s3.toFinset.card = 3) = true := by
  rfl
theorem class9_s3_cap_check :
    CertCheck.checkCap (K := K) class9_s3 = true := by
  rfl
theorem class9_witness_check :
    CertCheck.checkMove (K := K) class9_s3 (pt 2 6) = true := by
  rfl
theorem class9_root_eq_check :
    decide (class9_book.root.toFinset = insert (pt 2 6) class9_s3.toFinset) = true := by
  rfl
theorem class9_root_check :
    CertCheck.BookData.checkRoot (K := K) class9_book = true := by
  rfl
theorem class9_node0_cap_check :
    CertCheck.checkCap (K := K) class9_node0 = true := by
  rfl
theorem class9_node1_cap_check :
    CertCheck.checkCap (K := K) class9_node1 = true := by
  rfl
theorem class9_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class9_book = true := by
  simp [CertCheck.BookData.checkNodes, class9_book_nodes_eq, class9_nodes, class9_node0_cap_check, class9_node1_cap_check]
theorem class9_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class9_book class9_node0 allCellChunks = true := by
  rfl
theorem class9_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class9_book class9_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class9_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class9_step0_chunks_check
theorem class9_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class9_book class9_node1 allCellChunks = true := by
  rfl
theorem class9_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class9_book class9_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class9_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class9_step1_chunks_check
theorem class9_steps_check :
    CertCheck.BookData.checkSteps (K := K) class9_book = true := by
  simp [CertCheck.BookData.checkSteps, class9_book_nodes_eq, class9_nodes, class9_step0_check, class9_step1_check]
theorem class9_book_valid :
    class9_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class9_book.cells := by
    intro x
    rw [class9_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class9_book.root.toFinset)
    (nodes := class9_book.nodesFinset)
    (rows := class9_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class9_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class9_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class9_steps_check)
theorem class9_valid : class9.Valid := by
  unfold class9 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class9_size_check
  · exact CertCheck.checkCap_sound (K := K) class9_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class9_witness_check)
  · exact of_decide_eq_true class9_root_eq_check
  · exact class9_book_valid

def class10_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 4 5] : List (P))
def class10_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 3 4, pt 4 5] : List (P))
def class10_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 3 4, pt 4 5, pt 5 3, pt 6 2] : List (P))
def class10_nodes : List (List P) :=
  ([class10_node0, class10_node1] : List (List P))
def class10_row0 : CertCheck.RowData K where
  node := class10_node0
  mover := pt 5 3
  reply := pt 6 2
  child := class10_node1
def class10_row1 : CertCheck.RowData K where
  node := class10_node0
  mover := pt 6 2
  reply := pt 5 3
  child := class10_node1
def class10_rows : List (CertCheck.RowData K) :=
  ([class10_row0, class10_row1] : List (CertCheck.RowData K))
def class10_book : CertCheck.BookData K where
  cells := allCells
  root := class10_node0
  nodes := class10_nodes
  rows := class10_rows
theorem class10_book_cells_eq : class10_book.cells = allCells := by
  rfl
theorem class10_book_nodes_eq : class10_book.nodes = class10_nodes := by
  rfl
def class10_data : CertCheck.ClassData K where
  classIndex := 10
  sizeThree := class10_s3
  witness := pt 3 4
  book := class10_book
def class10 : GridClassCert K :=
  class10_data.toCert
theorem class10_size_check :
    decide (class10_s3.toFinset.card = 3) = true := by
  rfl
theorem class10_s3_cap_check :
    CertCheck.checkCap (K := K) class10_s3 = true := by
  rfl
theorem class10_witness_check :
    CertCheck.checkMove (K := K) class10_s3 (pt 3 4) = true := by
  rfl
theorem class10_root_eq_check :
    decide (class10_book.root.toFinset = insert (pt 3 4) class10_s3.toFinset) = true := by
  rfl
theorem class10_root_check :
    CertCheck.BookData.checkRoot (K := K) class10_book = true := by
  rfl
theorem class10_node0_cap_check :
    CertCheck.checkCap (K := K) class10_node0 = true := by
  rfl
theorem class10_node1_cap_check :
    CertCheck.checkCap (K := K) class10_node1 = true := by
  rfl
theorem class10_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class10_book = true := by
  simp [CertCheck.BookData.checkNodes, class10_book_nodes_eq, class10_nodes, class10_node0_cap_check, class10_node1_cap_check]
theorem class10_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class10_book class10_node0 allCellChunks = true := by
  rfl
theorem class10_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class10_book class10_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class10_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class10_step0_chunks_check
theorem class10_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class10_book class10_node1 allCellChunks = true := by
  rfl
theorem class10_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class10_book class10_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class10_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class10_step1_chunks_check
theorem class10_steps_check :
    CertCheck.BookData.checkSteps (K := K) class10_book = true := by
  simp [CertCheck.BookData.checkSteps, class10_book_nodes_eq, class10_nodes, class10_step0_check, class10_step1_check]
theorem class10_book_valid :
    class10_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class10_book.cells := by
    intro x
    rw [class10_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class10_book.root.toFinset)
    (nodes := class10_book.nodesFinset)
    (rows := class10_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class10_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class10_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class10_steps_check)
theorem class10_valid : class10.Valid := by
  unfold class10 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class10_size_check
  · exact CertCheck.checkCap_sound (K := K) class10_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class10_witness_check)
  · exact of_decide_eq_true class10_root_eq_check
  · exact class10_book_valid

def class11_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 4 6] : List (P))
def class11_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 4, pt 4 6] : List (P))
def class11_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 2 4, pt 4 6, pt 5 2, pt 6 3] : List (P))
def class11_nodes : List (List P) :=
  ([class11_node0, class11_node1] : List (List P))
def class11_row0 : CertCheck.RowData K where
  node := class11_node0
  mover := pt 5 2
  reply := pt 6 3
  child := class11_node1
def class11_row1 : CertCheck.RowData K where
  node := class11_node0
  mover := pt 6 3
  reply := pt 5 2
  child := class11_node1
def class11_rows : List (CertCheck.RowData K) :=
  ([class11_row0, class11_row1] : List (CertCheck.RowData K))
def class11_book : CertCheck.BookData K where
  cells := allCells
  root := class11_node0
  nodes := class11_nodes
  rows := class11_rows
theorem class11_book_cells_eq : class11_book.cells = allCells := by
  rfl
theorem class11_book_nodes_eq : class11_book.nodes = class11_nodes := by
  rfl
def class11_data : CertCheck.ClassData K where
  classIndex := 11
  sizeThree := class11_s3
  witness := pt 2 4
  book := class11_book
def class11 : GridClassCert K :=
  class11_data.toCert
theorem class11_size_check :
    decide (class11_s3.toFinset.card = 3) = true := by
  rfl
theorem class11_s3_cap_check :
    CertCheck.checkCap (K := K) class11_s3 = true := by
  rfl
theorem class11_witness_check :
    CertCheck.checkMove (K := K) class11_s3 (pt 2 4) = true := by
  rfl
theorem class11_root_eq_check :
    decide (class11_book.root.toFinset = insert (pt 2 4) class11_s3.toFinset) = true := by
  rfl
theorem class11_root_check :
    CertCheck.BookData.checkRoot (K := K) class11_book = true := by
  rfl
theorem class11_node0_cap_check :
    CertCheck.checkCap (K := K) class11_node0 = true := by
  rfl
theorem class11_node1_cap_check :
    CertCheck.checkCap (K := K) class11_node1 = true := by
  rfl
theorem class11_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class11_book = true := by
  simp [CertCheck.BookData.checkNodes, class11_book_nodes_eq, class11_nodes, class11_node0_cap_check, class11_node1_cap_check]
theorem class11_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class11_book class11_node0 allCellChunks = true := by
  rfl
theorem class11_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class11_book class11_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class11_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class11_step0_chunks_check
theorem class11_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class11_book class11_node1 allCellChunks = true := by
  rfl
theorem class11_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class11_book class11_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class11_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class11_step1_chunks_check
theorem class11_steps_check :
    CertCheck.BookData.checkSteps (K := K) class11_book = true := by
  simp [CertCheck.BookData.checkSteps, class11_book_nodes_eq, class11_nodes, class11_step0_check, class11_step1_check]
theorem class11_book_valid :
    class11_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class11_book.cells := by
    intro x
    rw [class11_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class11_book.root.toFinset)
    (nodes := class11_book.nodesFinset)
    (rows := class11_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class11_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class11_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class11_steps_check)
theorem class11_valid : class11.Valid := by
  unfold class11 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class11_size_check
  · exact CertCheck.checkCap_sound (K := K) class11_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class11_witness_check)
  · exact of_decide_eq_true class11_root_eq_check
  · exact class11_book_valid

def class12_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 5 2] : List (P))
def class12_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 4, pt 5 2] : List (P))
def class12_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 2 4, pt 4 6, pt 5 2, pt 6 3] : List (P))
def class12_nodes : List (List P) :=
  ([class12_node0, class12_node1] : List (List P))
def class12_row0 : CertCheck.RowData K where
  node := class12_node0
  mover := pt 4 6
  reply := pt 6 3
  child := class12_node1
def class12_row1 : CertCheck.RowData K where
  node := class12_node0
  mover := pt 6 3
  reply := pt 4 6
  child := class12_node1
def class12_rows : List (CertCheck.RowData K) :=
  ([class12_row0, class12_row1] : List (CertCheck.RowData K))
def class12_book : CertCheck.BookData K where
  cells := allCells
  root := class12_node0
  nodes := class12_nodes
  rows := class12_rows
theorem class12_book_cells_eq : class12_book.cells = allCells := by
  rfl
theorem class12_book_nodes_eq : class12_book.nodes = class12_nodes := by
  rfl
def class12_data : CertCheck.ClassData K where
  classIndex := 12
  sizeThree := class12_s3
  witness := pt 2 4
  book := class12_book
def class12 : GridClassCert K :=
  class12_data.toCert
theorem class12_size_check :
    decide (class12_s3.toFinset.card = 3) = true := by
  rfl
theorem class12_s3_cap_check :
    CertCheck.checkCap (K := K) class12_s3 = true := by
  rfl
theorem class12_witness_check :
    CertCheck.checkMove (K := K) class12_s3 (pt 2 4) = true := by
  rfl
theorem class12_root_eq_check :
    decide (class12_book.root.toFinset = insert (pt 2 4) class12_s3.toFinset) = true := by
  rfl
theorem class12_root_check :
    CertCheck.BookData.checkRoot (K := K) class12_book = true := by
  rfl
theorem class12_node0_cap_check :
    CertCheck.checkCap (K := K) class12_node0 = true := by
  rfl
theorem class12_node1_cap_check :
    CertCheck.checkCap (K := K) class12_node1 = true := by
  rfl
theorem class12_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class12_book = true := by
  simp [CertCheck.BookData.checkNodes, class12_book_nodes_eq, class12_nodes, class12_node0_cap_check, class12_node1_cap_check]
theorem class12_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class12_book class12_node0 allCellChunks = true := by
  rfl
theorem class12_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class12_book class12_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class12_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class12_step0_chunks_check
theorem class12_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class12_book class12_node1 allCellChunks = true := by
  rfl
theorem class12_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class12_book class12_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class12_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class12_step1_chunks_check
theorem class12_steps_check :
    CertCheck.BookData.checkSteps (K := K) class12_book = true := by
  simp [CertCheck.BookData.checkSteps, class12_book_nodes_eq, class12_nodes, class12_step0_check, class12_step1_check]
theorem class12_book_valid :
    class12_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class12_book.cells := by
    intro x
    rw [class12_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class12_book.root.toFinset)
    (nodes := class12_book.nodesFinset)
    (rows := class12_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class12_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class12_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class12_steps_check)
theorem class12_valid : class12.Valid := by
  unfold class12 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class12_size_check
  · exact CertCheck.checkCap_sound (K := K) class12_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class12_witness_check)
  · exact of_decide_eq_true class12_root_eq_check
  · exact class12_book_valid

def class13_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 5 3] : List (P))
def class13_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 3 4, pt 5 3] : List (P))
def class13_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 3 4, pt 4 5, pt 5 3, pt 6 2] : List (P))
def class13_nodes : List (List P) :=
  ([class13_node0, class13_node1] : List (List P))
def class13_row0 : CertCheck.RowData K where
  node := class13_node0
  mover := pt 4 5
  reply := pt 6 2
  child := class13_node1
def class13_row1 : CertCheck.RowData K where
  node := class13_node0
  mover := pt 6 2
  reply := pt 4 5
  child := class13_node1
def class13_rows : List (CertCheck.RowData K) :=
  ([class13_row0, class13_row1] : List (CertCheck.RowData K))
def class13_book : CertCheck.BookData K where
  cells := allCells
  root := class13_node0
  nodes := class13_nodes
  rows := class13_rows
theorem class13_book_cells_eq : class13_book.cells = allCells := by
  rfl
theorem class13_book_nodes_eq : class13_book.nodes = class13_nodes := by
  rfl
def class13_data : CertCheck.ClassData K where
  classIndex := 13
  sizeThree := class13_s3
  witness := pt 3 4
  book := class13_book
def class13 : GridClassCert K :=
  class13_data.toCert
theorem class13_size_check :
    decide (class13_s3.toFinset.card = 3) = true := by
  rfl
theorem class13_s3_cap_check :
    CertCheck.checkCap (K := K) class13_s3 = true := by
  rfl
theorem class13_witness_check :
    CertCheck.checkMove (K := K) class13_s3 (pt 3 4) = true := by
  rfl
theorem class13_root_eq_check :
    decide (class13_book.root.toFinset = insert (pt 3 4) class13_s3.toFinset) = true := by
  rfl
theorem class13_root_check :
    CertCheck.BookData.checkRoot (K := K) class13_book = true := by
  rfl
theorem class13_node0_cap_check :
    CertCheck.checkCap (K := K) class13_node0 = true := by
  rfl
theorem class13_node1_cap_check :
    CertCheck.checkCap (K := K) class13_node1 = true := by
  rfl
theorem class13_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class13_book = true := by
  simp [CertCheck.BookData.checkNodes, class13_book_nodes_eq, class13_nodes, class13_node0_cap_check, class13_node1_cap_check]
theorem class13_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class13_book class13_node0 allCellChunks = true := by
  rfl
theorem class13_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class13_book class13_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class13_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class13_step0_chunks_check
theorem class13_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class13_book class13_node1 allCellChunks = true := by
  rfl
theorem class13_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class13_book class13_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class13_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class13_step1_chunks_check
theorem class13_steps_check :
    CertCheck.BookData.checkSteps (K := K) class13_book = true := by
  simp [CertCheck.BookData.checkSteps, class13_book_nodes_eq, class13_nodes, class13_step0_check, class13_step1_check]
theorem class13_book_valid :
    class13_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class13_book.cells := by
    intro x
    rw [class13_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class13_book.root.toFinset)
    (nodes := class13_book.nodesFinset)
    (rows := class13_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class13_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class13_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class13_steps_check)
theorem class13_valid : class13.Valid := by
  unfold class13 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class13_size_check
  · exact CertCheck.checkCap_sound (K := K) class13_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class13_witness_check)
  · exact of_decide_eq_true class13_root_eq_check
  · exact class13_book_valid

def class14_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 5 4] : List (P))
def class14_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 6, pt 5 4] : List (P))
def class14_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 2 6, pt 3 5, pt 4 3, pt 5 4] : List (P))
def class14_nodes : List (List P) :=
  ([class14_node0, class14_node1] : List (List P))
def class14_row0 : CertCheck.RowData K where
  node := class14_node0
  mover := pt 3 5
  reply := pt 4 3
  child := class14_node1
def class14_row1 : CertCheck.RowData K where
  node := class14_node0
  mover := pt 4 3
  reply := pt 3 5
  child := class14_node1
def class14_rows : List (CertCheck.RowData K) :=
  ([class14_row0, class14_row1] : List (CertCheck.RowData K))
def class14_book : CertCheck.BookData K where
  cells := allCells
  root := class14_node0
  nodes := class14_nodes
  rows := class14_rows
theorem class14_book_cells_eq : class14_book.cells = allCells := by
  rfl
theorem class14_book_nodes_eq : class14_book.nodes = class14_nodes := by
  rfl
def class14_data : CertCheck.ClassData K where
  classIndex := 14
  sizeThree := class14_s3
  witness := pt 2 6
  book := class14_book
def class14 : GridClassCert K :=
  class14_data.toCert
theorem class14_size_check :
    decide (class14_s3.toFinset.card = 3) = true := by
  rfl
theorem class14_s3_cap_check :
    CertCheck.checkCap (K := K) class14_s3 = true := by
  rfl
theorem class14_witness_check :
    CertCheck.checkMove (K := K) class14_s3 (pt 2 6) = true := by
  rfl
theorem class14_root_eq_check :
    decide (class14_book.root.toFinset = insert (pt 2 6) class14_s3.toFinset) = true := by
  rfl
theorem class14_root_check :
    CertCheck.BookData.checkRoot (K := K) class14_book = true := by
  rfl
theorem class14_node0_cap_check :
    CertCheck.checkCap (K := K) class14_node0 = true := by
  rfl
theorem class14_node1_cap_check :
    CertCheck.checkCap (K := K) class14_node1 = true := by
  rfl
theorem class14_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class14_book = true := by
  simp [CertCheck.BookData.checkNodes, class14_book_nodes_eq, class14_nodes, class14_node0_cap_check, class14_node1_cap_check]
theorem class14_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class14_book class14_node0 allCellChunks = true := by
  rfl
theorem class14_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class14_book class14_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class14_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class14_step0_chunks_check
theorem class14_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class14_book class14_node1 allCellChunks = true := by
  rfl
theorem class14_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class14_book class14_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class14_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class14_step1_chunks_check
theorem class14_steps_check :
    CertCheck.BookData.checkSteps (K := K) class14_book = true := by
  simp [CertCheck.BookData.checkSteps, class14_book_nodes_eq, class14_nodes, class14_step0_check, class14_step1_check]
theorem class14_book_valid :
    class14_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class14_book.cells := by
    intro x
    rw [class14_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class14_book.root.toFinset)
    (nodes := class14_book.nodesFinset)
    (rows := class14_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class14_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class14_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class14_steps_check)
theorem class14_valid : class14.Valid := by
  unfold class14 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class14_size_check
  · exact CertCheck.checkCap_sound (K := K) class14_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class14_witness_check)
  · exact of_decide_eq_true class14_root_eq_check
  · exact class14_book_valid

def class15_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 5 6] : List (P))
def class15_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 3, pt 5 6] : List (P))
def class15_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 2 3, pt 3 2, pt 5 6, pt 6 5] : List (P))
def class15_nodes : List (List P) :=
  ([class15_node0, class15_node1] : List (List P))
def class15_row0 : CertCheck.RowData K where
  node := class15_node0
  mover := pt 3 2
  reply := pt 6 5
  child := class15_node1
def class15_row1 : CertCheck.RowData K where
  node := class15_node0
  mover := pt 6 5
  reply := pt 3 2
  child := class15_node1
def class15_rows : List (CertCheck.RowData K) :=
  ([class15_row0, class15_row1] : List (CertCheck.RowData K))
def class15_book : CertCheck.BookData K where
  cells := allCells
  root := class15_node0
  nodes := class15_nodes
  rows := class15_rows
theorem class15_book_cells_eq : class15_book.cells = allCells := by
  rfl
theorem class15_book_nodes_eq : class15_book.nodes = class15_nodes := by
  rfl
def class15_data : CertCheck.ClassData K where
  classIndex := 15
  sizeThree := class15_s3
  witness := pt 2 3
  book := class15_book
def class15 : GridClassCert K :=
  class15_data.toCert
theorem class15_size_check :
    decide (class15_s3.toFinset.card = 3) = true := by
  rfl
theorem class15_s3_cap_check :
    CertCheck.checkCap (K := K) class15_s3 = true := by
  rfl
theorem class15_witness_check :
    CertCheck.checkMove (K := K) class15_s3 (pt 2 3) = true := by
  rfl
theorem class15_root_eq_check :
    decide (class15_book.root.toFinset = insert (pt 2 3) class15_s3.toFinset) = true := by
  rfl
theorem class15_root_check :
    CertCheck.BookData.checkRoot (K := K) class15_book = true := by
  rfl
theorem class15_node0_cap_check :
    CertCheck.checkCap (K := K) class15_node0 = true := by
  rfl
theorem class15_node1_cap_check :
    CertCheck.checkCap (K := K) class15_node1 = true := by
  rfl
theorem class15_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class15_book = true := by
  simp [CertCheck.BookData.checkNodes, class15_book_nodes_eq, class15_nodes, class15_node0_cap_check, class15_node1_cap_check]
theorem class15_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class15_book class15_node0 allCellChunks = true := by
  rfl
theorem class15_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class15_book class15_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class15_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class15_step0_chunks_check
theorem class15_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class15_book class15_node1 allCellChunks = true := by
  rfl
theorem class15_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class15_book class15_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class15_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class15_step1_chunks_check
theorem class15_steps_check :
    CertCheck.BookData.checkSteps (K := K) class15_book = true := by
  simp [CertCheck.BookData.checkSteps, class15_book_nodes_eq, class15_nodes, class15_step0_check, class15_step1_check]
theorem class15_book_valid :
    class15_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class15_book.cells := by
    intro x
    rw [class15_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class15_book.root.toFinset)
    (nodes := class15_book.nodesFinset)
    (rows := class15_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class15_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class15_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class15_steps_check)
theorem class15_valid : class15.Valid := by
  unfold class15 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class15_size_check
  · exact CertCheck.checkCap_sound (K := K) class15_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class15_witness_check)
  · exact of_decide_eq_true class15_root_eq_check
  · exact class15_book_valid

def class16_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 6 2] : List (P))
def class16_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 3 4, pt 6 2] : List (P))
def class16_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 3 4, pt 4 5, pt 5 3, pt 6 2] : List (P))
def class16_nodes : List (List P) :=
  ([class16_node0, class16_node1] : List (List P))
def class16_row0 : CertCheck.RowData K where
  node := class16_node0
  mover := pt 4 5
  reply := pt 5 3
  child := class16_node1
def class16_row1 : CertCheck.RowData K where
  node := class16_node0
  mover := pt 5 3
  reply := pt 4 5
  child := class16_node1
def class16_rows : List (CertCheck.RowData K) :=
  ([class16_row0, class16_row1] : List (CertCheck.RowData K))
def class16_book : CertCheck.BookData K where
  cells := allCells
  root := class16_node0
  nodes := class16_nodes
  rows := class16_rows
theorem class16_book_cells_eq : class16_book.cells = allCells := by
  rfl
theorem class16_book_nodes_eq : class16_book.nodes = class16_nodes := by
  rfl
def class16_data : CertCheck.ClassData K where
  classIndex := 16
  sizeThree := class16_s3
  witness := pt 3 4
  book := class16_book
def class16 : GridClassCert K :=
  class16_data.toCert
theorem class16_size_check :
    decide (class16_s3.toFinset.card = 3) = true := by
  rfl
theorem class16_s3_cap_check :
    CertCheck.checkCap (K := K) class16_s3 = true := by
  rfl
theorem class16_witness_check :
    CertCheck.checkMove (K := K) class16_s3 (pt 3 4) = true := by
  rfl
theorem class16_root_eq_check :
    decide (class16_book.root.toFinset = insert (pt 3 4) class16_s3.toFinset) = true := by
  rfl
theorem class16_root_check :
    CertCheck.BookData.checkRoot (K := K) class16_book = true := by
  rfl
theorem class16_node0_cap_check :
    CertCheck.checkCap (K := K) class16_node0 = true := by
  rfl
theorem class16_node1_cap_check :
    CertCheck.checkCap (K := K) class16_node1 = true := by
  rfl
theorem class16_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class16_book = true := by
  simp [CertCheck.BookData.checkNodes, class16_book_nodes_eq, class16_nodes, class16_node0_cap_check, class16_node1_cap_check]
theorem class16_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class16_book class16_node0 allCellChunks = true := by
  rfl
theorem class16_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class16_book class16_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class16_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class16_step0_chunks_check
theorem class16_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class16_book class16_node1 allCellChunks = true := by
  rfl
theorem class16_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class16_book class16_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class16_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class16_step1_chunks_check
theorem class16_steps_check :
    CertCheck.BookData.checkSteps (K := K) class16_book = true := by
  simp [CertCheck.BookData.checkSteps, class16_book_nodes_eq, class16_nodes, class16_step0_check, class16_step1_check]
theorem class16_book_valid :
    class16_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class16_book.cells := by
    intro x
    rw [class16_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class16_book.root.toFinset)
    (nodes := class16_book.nodesFinset)
    (rows := class16_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class16_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class16_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class16_steps_check)
theorem class16_valid : class16.Valid := by
  unfold class16 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class16_size_check
  · exact CertCheck.checkCap_sound (K := K) class16_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class16_witness_check)
  · exact of_decide_eq_true class16_root_eq_check
  · exact class16_book_valid

def class17_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 6 3] : List (P))
def class17_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 4, pt 6 3] : List (P))
def class17_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 2 4, pt 4 6, pt 5 2, pt 6 3] : List (P))
def class17_nodes : List (List P) :=
  ([class17_node0, class17_node1] : List (List P))
def class17_row0 : CertCheck.RowData K where
  node := class17_node0
  mover := pt 4 6
  reply := pt 5 2
  child := class17_node1
def class17_row1 : CertCheck.RowData K where
  node := class17_node0
  mover := pt 5 2
  reply := pt 4 6
  child := class17_node1
def class17_rows : List (CertCheck.RowData K) :=
  ([class17_row0, class17_row1] : List (CertCheck.RowData K))
def class17_book : CertCheck.BookData K where
  cells := allCells
  root := class17_node0
  nodes := class17_nodes
  rows := class17_rows
theorem class17_book_cells_eq : class17_book.cells = allCells := by
  rfl
theorem class17_book_nodes_eq : class17_book.nodes = class17_nodes := by
  rfl
def class17_data : CertCheck.ClassData K where
  classIndex := 17
  sizeThree := class17_s3
  witness := pt 2 4
  book := class17_book
def class17 : GridClassCert K :=
  class17_data.toCert
theorem class17_size_check :
    decide (class17_s3.toFinset.card = 3) = true := by
  rfl
theorem class17_s3_cap_check :
    CertCheck.checkCap (K := K) class17_s3 = true := by
  rfl
theorem class17_witness_check :
    CertCheck.checkMove (K := K) class17_s3 (pt 2 4) = true := by
  rfl
theorem class17_root_eq_check :
    decide (class17_book.root.toFinset = insert (pt 2 4) class17_s3.toFinset) = true := by
  rfl
theorem class17_root_check :
    CertCheck.BookData.checkRoot (K := K) class17_book = true := by
  rfl
theorem class17_node0_cap_check :
    CertCheck.checkCap (K := K) class17_node0 = true := by
  rfl
theorem class17_node1_cap_check :
    CertCheck.checkCap (K := K) class17_node1 = true := by
  rfl
theorem class17_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class17_book = true := by
  simp [CertCheck.BookData.checkNodes, class17_book_nodes_eq, class17_nodes, class17_node0_cap_check, class17_node1_cap_check]
theorem class17_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class17_book class17_node0 allCellChunks = true := by
  rfl
theorem class17_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class17_book class17_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class17_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class17_step0_chunks_check
theorem class17_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class17_book class17_node1 allCellChunks = true := by
  rfl
theorem class17_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class17_book class17_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class17_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class17_step1_chunks_check
theorem class17_steps_check :
    CertCheck.BookData.checkSteps (K := K) class17_book = true := by
  simp [CertCheck.BookData.checkSteps, class17_book_nodes_eq, class17_nodes, class17_step0_check, class17_step1_check]
theorem class17_book_valid :
    class17_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class17_book.cells := by
    intro x
    rw [class17_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class17_book.root.toFinset)
    (nodes := class17_book.nodesFinset)
    (rows := class17_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class17_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class17_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class17_steps_check)
theorem class17_valid : class17.Valid := by
  unfold class17 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class17_size_check
  · exact CertCheck.checkCap_sound (K := K) class17_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class17_witness_check)
  · exact of_decide_eq_true class17_root_eq_check
  · exact class17_book_valid

def class18_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 6 4] : List (P))
def class18_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 5, pt 6 4] : List (P))
def class18_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 2 5, pt 3 6, pt 4 2, pt 6 4] : List (P))
def class18_nodes : List (List P) :=
  ([class18_node0, class18_node1] : List (List P))
def class18_row0 : CertCheck.RowData K where
  node := class18_node0
  mover := pt 3 6
  reply := pt 4 2
  child := class18_node1
def class18_row1 : CertCheck.RowData K where
  node := class18_node0
  mover := pt 4 2
  reply := pt 3 6
  child := class18_node1
def class18_rows : List (CertCheck.RowData K) :=
  ([class18_row0, class18_row1] : List (CertCheck.RowData K))
def class18_book : CertCheck.BookData K where
  cells := allCells
  root := class18_node0
  nodes := class18_nodes
  rows := class18_rows
theorem class18_book_cells_eq : class18_book.cells = allCells := by
  rfl
theorem class18_book_nodes_eq : class18_book.nodes = class18_nodes := by
  rfl
def class18_data : CertCheck.ClassData K where
  classIndex := 18
  sizeThree := class18_s3
  witness := pt 2 5
  book := class18_book
def class18 : GridClassCert K :=
  class18_data.toCert
theorem class18_size_check :
    decide (class18_s3.toFinset.card = 3) = true := by
  rfl
theorem class18_s3_cap_check :
    CertCheck.checkCap (K := K) class18_s3 = true := by
  rfl
theorem class18_witness_check :
    CertCheck.checkMove (K := K) class18_s3 (pt 2 5) = true := by
  rfl
theorem class18_root_eq_check :
    decide (class18_book.root.toFinset = insert (pt 2 5) class18_s3.toFinset) = true := by
  rfl
theorem class18_root_check :
    CertCheck.BookData.checkRoot (K := K) class18_book = true := by
  rfl
theorem class18_node0_cap_check :
    CertCheck.checkCap (K := K) class18_node0 = true := by
  rfl
theorem class18_node1_cap_check :
    CertCheck.checkCap (K := K) class18_node1 = true := by
  rfl
theorem class18_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class18_book = true := by
  simp [CertCheck.BookData.checkNodes, class18_book_nodes_eq, class18_nodes, class18_node0_cap_check, class18_node1_cap_check]
theorem class18_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class18_book class18_node0 allCellChunks = true := by
  rfl
theorem class18_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class18_book class18_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class18_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class18_step0_chunks_check
theorem class18_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class18_book class18_node1 allCellChunks = true := by
  rfl
theorem class18_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class18_book class18_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class18_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class18_step1_chunks_check
theorem class18_steps_check :
    CertCheck.BookData.checkSteps (K := K) class18_book = true := by
  simp [CertCheck.BookData.checkSteps, class18_book_nodes_eq, class18_nodes, class18_step0_check, class18_step1_check]
theorem class18_book_valid :
    class18_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class18_book.cells := by
    intro x
    rw [class18_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class18_book.root.toFinset)
    (nodes := class18_book.nodesFinset)
    (rows := class18_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class18_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class18_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class18_steps_check)
theorem class18_valid : class18.Valid := by
  unfold class18 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class18_size_check
  · exact CertCheck.checkCap_sound (K := K) class18_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class18_witness_check)
  · exact of_decide_eq_true class18_root_eq_check
  · exact class18_book_valid

def class19_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 6 5] : List (P))
def class19_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 3, pt 6 5] : List (P))
def class19_node1 : List P :=
  ([pt 0 0, pt 1 1, pt 2 3, pt 3 2, pt 5 6, pt 6 5] : List (P))
def class19_nodes : List (List P) :=
  ([class19_node0, class19_node1] : List (List P))
def class19_row0 : CertCheck.RowData K where
  node := class19_node0
  mover := pt 3 2
  reply := pt 5 6
  child := class19_node1
def class19_row1 : CertCheck.RowData K where
  node := class19_node0
  mover := pt 5 6
  reply := pt 3 2
  child := class19_node1
def class19_rows : List (CertCheck.RowData K) :=
  ([class19_row0, class19_row1] : List (CertCheck.RowData K))
def class19_book : CertCheck.BookData K where
  cells := allCells
  root := class19_node0
  nodes := class19_nodes
  rows := class19_rows
theorem class19_book_cells_eq : class19_book.cells = allCells := by
  rfl
theorem class19_book_nodes_eq : class19_book.nodes = class19_nodes := by
  rfl
def class19_data : CertCheck.ClassData K where
  classIndex := 19
  sizeThree := class19_s3
  witness := pt 2 3
  book := class19_book
def class19 : GridClassCert K :=
  class19_data.toCert
theorem class19_size_check :
    decide (class19_s3.toFinset.card = 3) = true := by
  rfl
theorem class19_s3_cap_check :
    CertCheck.checkCap (K := K) class19_s3 = true := by
  rfl
theorem class19_witness_check :
    CertCheck.checkMove (K := K) class19_s3 (pt 2 3) = true := by
  rfl
theorem class19_root_eq_check :
    decide (class19_book.root.toFinset = insert (pt 2 3) class19_s3.toFinset) = true := by
  rfl
theorem class19_root_check :
    CertCheck.BookData.checkRoot (K := K) class19_book = true := by
  rfl
theorem class19_node0_cap_check :
    CertCheck.checkCap (K := K) class19_node0 = true := by
  rfl
theorem class19_node1_cap_check :
    CertCheck.checkCap (K := K) class19_node1 = true := by
  rfl
theorem class19_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class19_book = true := by
  simp [CertCheck.BookData.checkNodes, class19_book_nodes_eq, class19_nodes, class19_node0_cap_check, class19_node1_cap_check]
theorem class19_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class19_book class19_node0 allCellChunks = true := by
  rfl
theorem class19_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class19_book class19_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class19_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class19_step0_chunks_check
theorem class19_step1_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class19_book class19_node1 allCellChunks = true := by
  rfl
theorem class19_step1_check :
    CertCheck.BookData.checkNodeStep (K := K) class19_book class19_node1 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class19_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class19_step1_chunks_check
theorem class19_steps_check :
    CertCheck.BookData.checkSteps (K := K) class19_book = true := by
  simp [CertCheck.BookData.checkSteps, class19_book_nodes_eq, class19_nodes, class19_step0_check, class19_step1_check]
theorem class19_book_valid :
    class19_book.toDAG.ValidFor (GridCap (K := K)) := by
  have hcells : ∀ x : GridPoint K, x ∈ class19_book.cells := by
    intro x
    rw [class19_book_cells_eq]
    exact allCells_mem x
  unfold CertCheck.BookData.toDAG
  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows
    (Valid := GridCap (K := K))
    (root := class19_book.root.toFinset)
    (nodes := class19_book.nodesFinset)
    (rows := class19_book.rowsFinset)
    (CertCheck.BookData.checkRoot_sound (K := K) class19_root_check)
    (CertCheck.BookData.checkNodes_sound (K := K) class19_nodes_check)
    (CertCheck.BookData.checkSteps_sound (K := K) hcells class19_steps_check)
theorem class19_valid : class19.Valid := by
  unfold class19 CertCheck.ClassData.toCert GridClassCert.Valid
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact of_decide_eq_true class19_size_check
  · exact CertCheck.checkCap_sound (K := K) class19_s3_cap_check
  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) class19_witness_check)
  · exact of_decide_eq_true class19_root_eq_check
  · exact class19_book_valid

end Q7
end CertData
end Certificate
end ProjectiveCap
