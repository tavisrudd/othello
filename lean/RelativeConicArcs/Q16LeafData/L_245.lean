import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_245_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,246,271}, reject := .fullRank { members := ![0,1,17,34,52,71,246,271], points := ![91,96,104,110,121,122], inverse := ![5,10,7,15,10,12,4,13,5,11,13,10,15,15,5,5,2,2,9,1,13,2,12,11,9,9,12,12,11,11,1,1,10,10,13,13] } }
theorem leafL_245_0_valid : (leafL_245_0).reject.ValidFor (leafL_245_0).leaf := by decide

noncomputable def leafL_245_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,249,268}, reject := .fullRank { members := ![0,1,17,34,52,71,249,268], points := ![90,93,101,104,109,122], inverse := ![6,9,10,15,13,6,9,0,5,12,7,7,0,0,5,3,6,0,4,12,2,9,4,7,1,1,14,12,2,0,11,11,3,4,7,0] } }
theorem leafL_245_1_valid : (leafL_245_1).reject.ValidFor (leafL_245_1).leaf := by decide

noncomputable def leafL_245_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,253,267}, reject := .fullRank { members := ![0,1,17,34,52,71,253,267], points := ![99,104,120,121,127,133], inverse := ![11,12,8,5,4,15,12,11,4,15,5,9,0,0,3,13,14,0,10,13,11,5,1,8,5,5,0,9,9,0,8,8,3,1,2,0] } }
theorem leafL_245_2_valid : (leafL_245_2).reject.ValidFor (leafL_245_2).leaf := by decide

noncomputable def leafL_245_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,90,101}, reject := .fullRank { members := ![0,1,17,34,52,72,90,101], points := ![115,124,137,139,143,150], inverse := ![10,14,13,14,13,11,2,1,1,13,4,11,0,0,10,15,5,0,7,5,12,5,0,11,14,14,10,7,13,0,2,2,11,10,1,0] } }
theorem leafL_245_3_valid : (leafL_245_3).reject.ValidFor (leafL_245_3).leaf := by decide

noncomputable def leafL_245_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,90,135}, reject := .fullRank { members := ![0,1,17,34,52,72,90,135], points := ![99,115,125,149,150,163], inverse := ![10,3,15,7,7,7,6,9,0,0,0,15,2,15,0,7,6,12,12,5,10,9,13,7,4,3,14,4,6,11,4,8,5,13,15,11] } }
theorem leafL_245_4_valid : (leafL_245_4).reject.ValidFor (leafL_245_4).leaf := by decide

noncomputable def leafL_245_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,90,139}, reject := .fullRank { members := ![0,1,17,34,52,72,90,139], points := ![101,112,115,125,151,163], inverse := ![2,4,4,12,6,9,2,3,15,10,10,14,13,9,15,2,2,11,3,7,4,2,0,2,11,8,12,13,8,10,7,11,3,7,6,14] } }
theorem leafL_245_5_valid : (leafL_245_5).reject.ValidFor (leafL_245_5).leaf := by decide

noncomputable def leafL_245_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,90,149}, reject := .fullRank { members := ![0,1,17,34,52,72,90,149], points := ![135,163,166,169,188,190], inverse := ![9,9,12,6,13,6,12,7,1,7,1,12,0,14,11,5,0,0,7,14,13,14,0,10,0,7,7,0,6,6,0,9,10,3,12,12] } }
theorem leafL_245_6_valid : (leafL_245_6).reject.ValidFor (leafL_245_6).leaf := by decide

noncomputable def leafL_245_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,90,151}, reject := .fullRank { members := ![0,1,17,34,52,72,90,151], points := ![99,101,112,125,139,166], inverse := ![11,0,5,3,2,14,0,1,5,7,1,2,15,8,7,0,0,0,1,0,5,6,0,2,3,12,4,4,12,3,0,8,1,10,13,14] } }
theorem leafL_245_7_valid : (leafL_245_7).reject.ValidFor (leafL_245_7).leaf := by decide

noncomputable def leavesL_245 : List RejectedLeaf := [leafL_245_0,leafL_245_1,leafL_245_2,leafL_245_3,leafL_245_4,leafL_245_5,leafL_245_6,leafL_245_7]

theorem leavesL_245_valid : LeafListValid leavesL_245 := by
  intro x hx
  simp only [leavesL_245, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_245_0_valid
  · exact leafL_245_1_valid
  · exact leafL_245_2_valid
  · exact leafL_245_3_valid
  · exact leafL_245_4_valid
  · exact leafL_245_5_valid
  · exact leafL_245_6_valid
  · exact leafL_245_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
