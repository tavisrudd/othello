import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_162_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,205}, reject := .fullRank { members := ![0,1,17,34,52,71,91,205], points := ![99,104,106,120,122,138], inverse := ![10,5,8,11,2,15,0,0,7,0,14,9,1,14,15,0,0,0,0,9,14,9,6,8,14,13,3,5,5,0,0,1,1,1,1,0] } }
theorem leafL_162_0_valid : (leafL_162_0).reject.ValidFor (leafL_162_0).leaf := by decide

noncomputable def leafL_162_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,207}, reject := .fullRank { members := ![0,1,17,34,52,71,91,207], points := ![99,110,120,121,122,141], inverse := ![10,13,6,14,1,15,13,10,0,3,13,9,0,0,11,8,3,0,11,12,2,13,0,8,3,3,8,10,2,0,9,9,9,9,0,0] } }
theorem leafL_162_1_valid : (leafL_162_1).reject.ValidFor (leafL_162_1).leaf := by decide

noncomputable def leafL_162_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,213}, reject := .fullRank { members := ![0,1,17,34,52,71,91,213], points := ![99,104,110,121,127,138], inverse := ![5,10,8,14,7,15,10,7,10,2,12,9,7,13,10,0,0,0,2,9,12,2,13,8,5,5,0,9,9,0,15,5,10,12,12,0] } }
theorem leafL_162_2_valid : (leafL_162_2).reject.ValidFor (leafL_162_2).leaf := by decide

noncomputable def leafL_162_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,216}, reject := .fullRank { members := ![0,1,17,34,52,71,91,216], points := ![99,106,109,122,127,141], inverse := ![7,4,4,7,14,15,4,6,5,4,10,9,15,1,14,0,0,0,9,14,0,3,12,8,2,6,4,10,10,0,10,7,13,2,2,0] } }
theorem leafL_162_3_valid : (leafL_162_3).reject.ValidFor (leafL_162_3).leaf := by decide

noncomputable def leafL_162_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,217}, reject := .fullRank { members := ![0,1,17,34,52,71,91,217], points := ![99,109,110,120,122,138], inverse := ![14,11,2,11,2,15,15,5,13,0,14,9,11,3,8,0,0,0,6,12,13,9,6,8,14,7,9,5,5,0,1,1,0,1,1,0] } }
theorem leafL_162_4_valid : (leafL_162_4).reject.ValidFor (leafL_162_4).leaf := by decide

noncomputable def leafL_162_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,229}, reject := .fullRank { members := ![0,1,17,34,52,71,91,229], points := ![104,106,109,121,122,141], inverse := ![2,8,13,12,5,15,8,4,11,3,13,9,15,14,1,0,0,0,1,3,5,2,13,8,14,2,12,3,3,0,7,2,5,14,14,0] } }
theorem leafL_162_5_valid : (leafL_162_5).reject.ValidFor (leafL_162_5).leaf := by decide

noncomputable def leafL_162_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,237}, reject := .fullRank { members := ![0,1,17,34,52,71,91,237], points := ![104,106,110,121,122,138], inverse := ![7,14,14,8,1,15,0,7,0,0,14,9,7,4,3,0,0,0,13,4,14,7,8,8,4,3,7,3,3,0,9,6,15,14,14,0] } }
theorem leafL_162_6_valid : (leafL_162_6).reject.ValidFor (leafL_162_6).leaf := by decide

noncomputable def leafL_162_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,239}, reject := .fullRank { members := ![0,1,17,34,52,71,91,239], points := ![104,150,154,158,168,174], inverse := ![13,1,11,0,5,3,14,13,3,10,10,0,0,12,11,7,0,0,14,12,15,6,9,2,0,3,9,10,10,10,0,4,5,1,12,12] } }
theorem leafL_162_7_valid : (leafL_162_7).reject.ValidFor (leafL_162_7).leaf := by decide

noncomputable def leavesL_162 : List RejectedLeaf := [leafL_162_0,leafL_162_1,leafL_162_2,leafL_162_3,leafL_162_4,leafL_162_5,leafL_162_6,leafL_162_7]

theorem leavesL_162_valid : LeafListValid leavesL_162 := by
  intro x hx
  simp only [leavesL_162, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_162_0_valid
  · exact leafL_162_1_valid
  · exact leafL_162_2_valid
  · exact leafL_162_3_valid
  · exact leafL_162_4_valid
  · exact leafL_162_5_valid
  · exact leafL_162_6_valid
  · exact leafL_162_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
