import ProjectiveCap.CertCheck

namespace ProjectiveCap
namespace Certificate
namespace CertData
namespace Q5

instance : Fact (Nat.Prime 5) := Fact.mk (by decide)

abbrev K := ZMod 5
abbrev P := GridPoint K

def pt (r c : Nat) : P := ((r : K), (c : K))

def allCellsChunk0 : List P :=
  ([pt 0 0, pt 0 1, pt 0 2, pt 0 3, pt 0 4, pt 1 0, pt 1 1, pt 1 2, pt 1 3, pt 1 4, pt 2 0] : List (P))
def allCellsChunk1 : List P :=
  ([pt 2 1, pt 2 2, pt 2 3, pt 2 4, pt 3 0, pt 3 1, pt 3 2, pt 3 3, pt 3 4, pt 4 0, pt 4 1] : List (P))
def allCellsChunk2 : List P :=
  ([pt 4 2, pt 4 3, pt 4 4] : List (P))
def allCellChunks : List (List P) :=
  ([allCellsChunk0, allCellsChunk1, allCellsChunk2] : List (List P))
def allCells : List P :=
  allCellChunks.flatten
theorem allCells_mem (x : GridPoint K) : x ∈ allCells := by
  rcases x with ⟨r, c⟩
  fin_cases r <;> fin_cases c <;> decide

def class0_s3 : List P :=
  ([pt 0 0, pt 1 1, pt 2 3] : List (P))
def class0_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 3, pt 3 4] : List (P))
def class0_nodes : List (List P) :=
  ([class0_node0] : List (List P))
def class0_rows : List (CertCheck.RowData K) :=
  ([] : List (CertCheck.RowData K))
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
  witness := pt 3 4
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
    CertCheck.checkMove (K := K) class0_s3 (pt 3 4) = true := by
  rfl
theorem class0_root_eq_check :
    decide (class0_book.root.toFinset = insert (pt 3 4) class0_s3.toFinset) = true := by
  rfl
theorem class0_root_check :
    CertCheck.BookData.checkRoot (K := K) class0_book = true := by
  rfl
theorem class0_node0_cap_check :
    CertCheck.checkCap (K := K) class0_node0 = true := by
  rfl
theorem class0_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class0_book = true := by
  simp [CertCheck.BookData.checkNodes, class0_book_nodes_eq, class0_nodes, class0_node0_cap_check]
theorem class0_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class0_book class0_node0 allCellChunks = true := by
  rfl
theorem class0_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class0_book class0_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class0_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class0_step0_chunks_check
theorem class0_steps_check :
    CertCheck.BookData.checkSteps (K := K) class0_book = true := by
  simp [CertCheck.BookData.checkSteps, class0_book_nodes_eq, class0_nodes, class0_step0_check]
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
  ([pt 0 0, pt 1 1, pt 2 4, pt 4 2] : List (P))
def class1_nodes : List (List P) :=
  ([class1_node0] : List (List P))
def class1_rows : List (CertCheck.RowData K) :=
  ([] : List (CertCheck.RowData K))
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
  witness := pt 4 2
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
    CertCheck.checkMove (K := K) class1_s3 (pt 4 2) = true := by
  rfl
theorem class1_root_eq_check :
    decide (class1_book.root.toFinset = insert (pt 4 2) class1_s3.toFinset) = true := by
  rfl
theorem class1_root_check :
    CertCheck.BookData.checkRoot (K := K) class1_book = true := by
  rfl
theorem class1_node0_cap_check :
    CertCheck.checkCap (K := K) class1_node0 = true := by
  rfl
theorem class1_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class1_book = true := by
  simp [CertCheck.BookData.checkNodes, class1_book_nodes_eq, class1_nodes, class1_node0_cap_check]
theorem class1_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class1_book class1_node0 allCellChunks = true := by
  rfl
theorem class1_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class1_book class1_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class1_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class1_step0_chunks_check
theorem class1_steps_check :
    CertCheck.BookData.checkSteps (K := K) class1_book = true := by
  simp [CertCheck.BookData.checkSteps, class1_book_nodes_eq, class1_nodes, class1_step0_check]
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
  ([pt 0 0, pt 1 1, pt 3 2] : List (P))
def class2_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 3 2, pt 4 3] : List (P))
def class2_nodes : List (List P) :=
  ([class2_node0] : List (List P))
def class2_rows : List (CertCheck.RowData K) :=
  ([] : List (CertCheck.RowData K))
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
  witness := pt 4 3
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
    CertCheck.checkMove (K := K) class2_s3 (pt 4 3) = true := by
  rfl
theorem class2_root_eq_check :
    decide (class2_book.root.toFinset = insert (pt 4 3) class2_s3.toFinset) = true := by
  rfl
theorem class2_root_check :
    CertCheck.BookData.checkRoot (K := K) class2_book = true := by
  rfl
theorem class2_node0_cap_check :
    CertCheck.checkCap (K := K) class2_node0 = true := by
  rfl
theorem class2_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class2_book = true := by
  simp [CertCheck.BookData.checkNodes, class2_book_nodes_eq, class2_nodes, class2_node0_cap_check]
theorem class2_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class2_book class2_node0 allCellChunks = true := by
  rfl
theorem class2_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class2_book class2_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class2_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class2_step0_chunks_check
theorem class2_steps_check :
    CertCheck.BookData.checkSteps (K := K) class2_book = true := by
  simp [CertCheck.BookData.checkSteps, class2_book_nodes_eq, class2_nodes, class2_step0_check]
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
  ([pt 0 0, pt 1 1, pt 3 4] : List (P))
def class3_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 3, pt 3 4] : List (P))
def class3_nodes : List (List P) :=
  ([class3_node0] : List (List P))
def class3_rows : List (CertCheck.RowData K) :=
  ([] : List (CertCheck.RowData K))
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
  witness := pt 2 3
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
    CertCheck.checkMove (K := K) class3_s3 (pt 2 3) = true := by
  rfl
theorem class3_root_eq_check :
    decide (class3_book.root.toFinset = insert (pt 2 3) class3_s3.toFinset) = true := by
  rfl
theorem class3_root_check :
    CertCheck.BookData.checkRoot (K := K) class3_book = true := by
  rfl
theorem class3_node0_cap_check :
    CertCheck.checkCap (K := K) class3_node0 = true := by
  rfl
theorem class3_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class3_book = true := by
  simp [CertCheck.BookData.checkNodes, class3_book_nodes_eq, class3_nodes, class3_node0_cap_check]
theorem class3_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class3_book class3_node0 allCellChunks = true := by
  rfl
theorem class3_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class3_book class3_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class3_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class3_step0_chunks_check
theorem class3_steps_check :
    CertCheck.BookData.checkSteps (K := K) class3_book = true := by
  simp [CertCheck.BookData.checkSteps, class3_book_nodes_eq, class3_nodes, class3_step0_check]
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
  ([pt 0 0, pt 1 1, pt 4 2] : List (P))
def class4_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 2 4, pt 4 2] : List (P))
def class4_nodes : List (List P) :=
  ([class4_node0] : List (List P))
def class4_rows : List (CertCheck.RowData K) :=
  ([] : List (CertCheck.RowData K))
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
  witness := pt 2 4
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
    CertCheck.checkMove (K := K) class4_s3 (pt 2 4) = true := by
  rfl
theorem class4_root_eq_check :
    decide (class4_book.root.toFinset = insert (pt 2 4) class4_s3.toFinset) = true := by
  rfl
theorem class4_root_check :
    CertCheck.BookData.checkRoot (K := K) class4_book = true := by
  rfl
theorem class4_node0_cap_check :
    CertCheck.checkCap (K := K) class4_node0 = true := by
  rfl
theorem class4_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class4_book = true := by
  simp [CertCheck.BookData.checkNodes, class4_book_nodes_eq, class4_nodes, class4_node0_cap_check]
theorem class4_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class4_book class4_node0 allCellChunks = true := by
  rfl
theorem class4_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class4_book class4_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class4_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class4_step0_chunks_check
theorem class4_steps_check :
    CertCheck.BookData.checkSteps (K := K) class4_book = true := by
  simp [CertCheck.BookData.checkSteps, class4_book_nodes_eq, class4_nodes, class4_step0_check]
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
  ([pt 0 0, pt 1 1, pt 4 3] : List (P))
def class5_node0 : List P :=
  ([pt 0 0, pt 1 1, pt 3 2, pt 4 3] : List (P))
def class5_nodes : List (List P) :=
  ([class5_node0] : List (List P))
def class5_rows : List (CertCheck.RowData K) :=
  ([] : List (CertCheck.RowData K))
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
  witness := pt 3 2
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
    CertCheck.checkMove (K := K) class5_s3 (pt 3 2) = true := by
  rfl
theorem class5_root_eq_check :
    decide (class5_book.root.toFinset = insert (pt 3 2) class5_s3.toFinset) = true := by
  rfl
theorem class5_root_check :
    CertCheck.BookData.checkRoot (K := K) class5_book = true := by
  rfl
theorem class5_node0_cap_check :
    CertCheck.checkCap (K := K) class5_node0 = true := by
  rfl
theorem class5_nodes_check :
    CertCheck.BookData.checkNodes (K := K) class5_book = true := by
  simp [CertCheck.BookData.checkNodes, class5_book_nodes_eq, class5_nodes, class5_node0_cap_check]
theorem class5_step0_chunks_check :
    CertCheck.BookData.checkNodeStepChunks (K := K) class5_book class5_node0 allCellChunks = true := by
  rfl
theorem class5_step0_check :
    CertCheck.BookData.checkNodeStep (K := K) class5_book class5_node0 = true := by
  unfold CertCheck.BookData.checkNodeStep
  rw [class5_book_cells_eq]
  unfold allCells
  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) class5_step0_chunks_check
theorem class5_steps_check :
    CertCheck.BookData.checkSteps (K := K) class5_book = true := by
  simp [CertCheck.BookData.checkSteps, class5_book_nodes_eq, class5_nodes, class5_step0_check]
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

end Q5
end CertData
end Certificate
end ProjectiveCap
