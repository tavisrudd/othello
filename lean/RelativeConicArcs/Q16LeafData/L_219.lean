import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_219_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,166,191}, reject := .fullRank { members := ![0,1,17,34,52,71,166,191], points := ![90,94,99,106,110,120], inverse := ![1,14,9,10,11,6,12,5,14,4,4,7,0,0,14,12,2,0,2,10,14,10,11,7,12,12,13,4,9,0,13,13,0,13,13,0] } }
theorem leafL_219_0_valid : (leafL_219_0).reject.ValidFor (leafL_219_0).leaf := by decide

noncomputable def leafL_219_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,166,216}, reject := .fullRank { members := ![0,1,17,34,52,71,166,216], points := ![83,96,99,106,110,126], inverse := ![4,11,11,9,10,6,4,13,5,8,3,7,0,0,14,12,2,0,13,5,10,13,8,7,7,7,5,9,12,0,4,4,7,11,12,0] } }
theorem leafL_219_1_valid : (leafL_219_1).reject.ValidFor (leafL_219_1).leaf := by decide

noncomputable def leafL_219_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,166,217}, reject := .fullRank { members := ![0,1,17,34,52,71,166,217], points := ![83,96,99,109,110,120], inverse := ![2,13,6,4,10,6,3,10,7,13,4,7,0,0,11,3,8,0,10,2,15,1,1,7,7,7,7,15,8,0,4,4,13,6,11,0] } }
theorem leafL_219_2_valid : (leafL_219_2).reject.ValidFor (leafL_219_2).leaf := by decide

noncomputable def leafL_219_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,166,233}, reject := .fullRank { members := ![0,1,17,34,52,71,166,233], points := ![90,93,94,99,106,126], inverse := ![8,10,13,8,0,6,1,4,12,12,2,7,6,11,13,0,0,0,13,12,9,7,8,7,4,6,2,7,7,0,9,3,10,5,5,0] } }
theorem leafL_219_3_valid : (leafL_219_3).reject.ValidFor (leafL_219_3).leaf := by decide

noncomputable def leafL_219_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,166,239}, reject := .fullRank { members := ![0,1,17,34,52,71,166,239], points := ![90,93,99,126,128,133], inverse := ![5,14,12,5,7,4,1,0,6,13,2,8,11,15,4,3,7,4,1,8,14,6,0,1,7,13,10,15,5,10,14,0,14,0,14,14] } }
theorem leafL_219_4_valid : (leafL_219_4).reject.ValidFor (leafL_219_4).leaf := by decide

noncomputable def leafL_219_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,166,248}, reject := .fullRank { members := ![0,1,17,34,52,71,166,248], points := ![93,94,96,99,106,121], inverse := ![15,10,10,3,11,6,15,4,2,3,13,7,14,9,7,0,0,0,13,9,12,8,7,7,0,11,11,7,7,0,7,4,3,5,5,0] } }
theorem leafL_219_5_valid : (leafL_219_5).reject.ValidFor (leafL_219_5).leaf := by decide

noncomputable def leafL_219_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,166,249}, reject := .fullRank { members := ![0,1,17,34,52,71,166,249], points := ![83,90,93,106,109,120], inverse := ![2,10,7,7,15,6,7,0,14,7,9,7,15,1,14,0,0,0,7,13,2,10,5,7,6,4,2,10,10,0,0,11,11,11,11,0] } }
theorem leafL_219_6_valid : (leafL_219_6).reject.ValidFor (leafL_219_6).leaf := by decide

noncomputable def leafL_219_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,166,267}, reject := .fullRank { members := ![0,1,17,34,52,71,166,267], points := ![93,94,99,106,120,121], inverse := ![11,4,9,1,8,14,5,12,1,15,7,0,6,6,7,7,3,3,4,12,4,11,1,6,1,1,12,12,2,2,8,8,6,6,13,13] } }
theorem leafL_219_7_valid : (leafL_219_7).reject.ValidFor (leafL_219_7).leaf := by decide

noncomputable def leavesL_219 : List RejectedLeaf := [leafL_219_0,leafL_219_1,leafL_219_2,leafL_219_3,leafL_219_4,leafL_219_5,leafL_219_6,leafL_219_7]

theorem leavesL_219_valid : LeafListValid leavesL_219 := by
  intro x hx
  simp only [leavesL_219, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_219_0_valid
  · exact leafL_219_1_valid
  · exact leafL_219_2_valid
  · exact leafL_219_3_valid
  · exact leafL_219_4_valid
  · exact leafL_219_5_valid
  · exact leafL_219_6_valid
  · exact leafL_219_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
