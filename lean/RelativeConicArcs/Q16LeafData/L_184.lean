import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_184_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,243}, reject := .fullRank { members := ![0,1,17,34,52,71,106,243], points := ![93,94,121,124,133,144], inverse := ![4,3,8,6,15,7,1,6,0,9,12,2,1,1,1,1,10,10,15,8,6,14,12,3,6,6,10,10,4,4,8,8,6,6,10,10] } }
theorem leafL_184_0_valid : (leafL_184_0).reject.ValidFor (leafL_184_0).leaf := by decide

noncomputable def leafL_184_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,248}, reject := .fullRank { members := ![0,1,17,34,52,71,106,248], points := ![93,94,96,121,124,133], inverse := ![9,0,14,10,4,8,2,1,4,11,2,14,14,9,7,0,0,0,4,5,6,1,9,15,0,8,8,15,15,0,7,0,7,7,7,0] } }
theorem leafL_184_1_valid : (leafL_184_1).reject.ValidFor (leafL_184_1).leaf := by decide

noncomputable def leafL_184_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,249}, reject := .fullRank { members := ![0,1,17,34,52,71,106,249], points := ![94,126,140,144,147,156], inverse := ![1,13,9,0,10,14,0,3,4,12,13,6,5,11,4,12,14,8,2,3,3,4,10,12,4,2,13,2,15,6,10,5,10,9,12,0] } }
theorem leafL_184_2_valid : (leafL_184_2).reject.ValidFor (leafL_184_2).leaf := by decide

noncomputable def leafL_184_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,259}, reject := .fullRank { members := ![0,1,17,34,52,71,106,259], points := ![94,96,121,124,139,144], inverse := ![12,11,9,7,11,3,15,8,2,11,12,2,2,2,4,4,7,7,10,13,0,8,11,4,8,8,15,15,0,0,12,12,5,5,10,10] } }
theorem leafL_184_3_valid : (leafL_184_3).reject.ValidFor (leafL_184_3).leaf := by decide

noncomputable def leafL_184_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,267}, reject := .fullRank { members := ![0,1,17,34,52,71,106,267], points := ![93,94,121,133,144,150], inverse := ![7,7,4,2,12,11,12,8,1,7,0,2,8,14,3,15,14,4,8,13,9,15,14,13,3,10,13,0,10,14,11,12,10,7,1,11] } }
theorem leafL_184_4_valid : (leafL_184_4).reject.ValidFor (leafL_184_4).leaf := by decide

noncomputable def leafL_184_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,120}, reject := .fullRank { members := ![0,1,17,34,52,71,109,120], points := ![91,94,131,138,140,155], inverse := ![14,6,12,7,8,10,6,0,15,10,12,15,0,0,10,11,1,0,3,7,3,4,1,2,14,14,2,6,4,0,2,2,13,9,4,0] } }
theorem leafL_184_5_valid : (leafL_184_5).reject.ValidFor (leafL_184_5).leaf := by decide

noncomputable def leafL_184_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,128}, reject := .fullRank { members := ![0,1,17,34,52,71,109,128], points := ![131,138,140,150,154,166], inverse := ![7,11,6,14,1,4,8,6,5,8,0,3,10,11,1,0,0,0,10,8,9,15,6,2,15,1,14,11,11,0,5,8,13,15,15,0] } }
theorem leafL_184_6_valid : (leafL_184_6).reject.ValidFor (leafL_184_6).leaf := by decide

noncomputable def leafL_184_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,131}, reject := .fullRank { members := ![0,1,17,34,52,71,109,131], points := ![90,94,120,128,150,156], inverse := ![14,12,14,11,12,10,12,9,3,11,15,2,12,12,1,1,4,4,7,4,1,11,5,12,12,12,2,2,9,9,1,1,8,8,11,11] } }
theorem leafL_184_7_valid : (leafL_184_7).reject.ValidFor (leafL_184_7).leaf := by decide

noncomputable def leavesL_184 : List RejectedLeaf := [leafL_184_0,leafL_184_1,leafL_184_2,leafL_184_3,leafL_184_4,leafL_184_5,leafL_184_6,leafL_184_7]

theorem leavesL_184_valid : LeafListValid leavesL_184 := by
  intro x hx
  simp only [leavesL_184, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_184_0_valid
  · exact leafL_184_1_valid
  · exact leafL_184_2_valid
  · exact leafL_184_3_valid
  · exact leafL_184_4_valid
  · exact leafL_184_5_valid
  · exact leafL_184_6_valid
  · exact leafL_184_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
