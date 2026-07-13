import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_181_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,245}, reject := .fullRank { members := ![0,1,17,34,52,71,104,245], points := ![91,94,140,154,156,158], inverse := ![7,15,3,0,7,13,1,7,9,11,12,8,0,0,0,15,10,5,3,7,6,14,9,5,4,4,0,14,9,7,9,9,0,12,11,7] } }
theorem leafL_181_0_valid : (leafL_181_0).reject.ValidFor (leafL_181_0).leaf := by decide

noncomputable def leafL_181_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,259}, reject := .fullRank { members := ![0,1,17,34,52,71,104,259], points := ![90,92,94,121,126,139], inverse := ![6,0,1,9,7,8,15,11,3,2,11,14,15,10,5,0,0,0,0,9,14,7,15,15,0,9,9,5,5,0,1,5,4,12,12,0] } }
theorem leafL_181_1_valid : (leafL_181_1).reject.ValidFor (leafL_181_1).leaf := by decide

noncomputable def leafL_181_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,267}, reject := .fullRank { members := ![0,1,17,34,52,71,104,267], points := ![92,94,121,128,141,154], inverse := ![0,8,0,0,3,10,6,1,5,12,14,0,0,10,14,11,3,12,7,8,14,2,2,1,9,7,1,6,12,5,10,15,4,15,8,6] } }
theorem leafL_181_2_valid : (leafL_181_2).reject.ValidFor (leafL_181_2).leaf := by decide

noncomputable def leafL_181_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,271}, reject := .fullRank { members := ![0,1,17,34,52,71,104,271], points := ![90,91,121,141,155,156], inverse := ![9,8,13,9,12,8,2,8,6,11,2,5,2,12,7,12,3,6,4,14,7,10,12,11,14,10,2,15,9,0,8,4,6,2,3,11] } }
theorem leafL_181_3_valid : (leafL_181_3).reject.ValidFor (leafL_181_3).leaf := by decide

noncomputable def leafL_181_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,121}, reject := .fullRank { members := ![0,1,17,34,52,71,106,121], points := ![91,93,94,133,139,150], inverse := ![11,1,2,1,2,10,5,13,14,1,8,15,1,7,6,0,0,0,5,13,12,9,15,2,6,13,11,4,4,0,5,6,3,1,1,0] } }
theorem leafL_181_4_valid : (leafL_181_4).reject.ValidFor (leafL_181_4).leaf := by decide

noncomputable def leafL_181_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,126}, reject := .fullRank { members := ![0,1,17,34,52,71,106,126], points := ![96,139,140,144,147,150], inverse := ![8,7,0,4,4,14,6,14,4,3,14,1,0,11,13,6,0,0,4,15,5,12,7,5,0,0,3,3,8,8,0,9,4,13,5,5] } }
theorem leafL_181_5_valid : (leafL_181_5).reject.ValidFor (leafL_181_5).leaf := by decide

noncomputable def leafL_181_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,140}, reject := .fullRank { members := ![0,1,17,34,52,71,106,140], points := ![93,94,96,126,147,150], inverse := ![3,3,2,5,4,2,10,10,5,8,12,1,14,9,7,0,0,0,9,11,1,10,4,13,14,7,9,0,2,2,13,7,10,0,9,9] } }
theorem leafL_181_6_valid : (leafL_181_6).reject.ValidFor (leafL_181_6).leaf := by decide

noncomputable def leafL_181_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,147}, reject := .fullRank { members := ![0,1,17,34,52,71,106,147], points := ![91,96,124,126,133,140], inverse := ![1,6,4,10,12,4,11,12,14,7,1,15,12,12,13,13,8,8,4,3,8,0,12,3,9,9,10,10,11,11,6,6,8,8,12,12] } }
theorem leafL_181_7_valid : (leafL_181_7).reject.ValidFor (leafL_181_7).leaf := by decide

noncomputable def leavesL_181 : List RejectedLeaf := [leafL_181_0,leafL_181_1,leafL_181_2,leafL_181_3,leafL_181_4,leafL_181_5,leafL_181_6,leafL_181_7]

theorem leavesL_181_valid : LeafListValid leavesL_181 := by
  intro x hx
  simp only [leavesL_181, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_181_0_valid
  · exact leafL_181_1_valid
  · exact leafL_181_2_valid
  · exact leafL_181_3_valid
  · exact leafL_181_4_valid
  · exact leafL_181_5_valid
  · exact leafL_181_6_valid
  · exact leafL_181_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
