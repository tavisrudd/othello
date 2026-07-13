import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_172_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,233}, reject := .fullRank { members := ![0,1,17,34,52,71,94,233], points := ![101,106,109,124,127,133], inverse := ![6,0,1,12,5,15,5,14,12,15,1,9,9,10,3,0,0,0,3,9,13,11,4,8,11,1,10,14,14,0,0,8,8,8,8,0] } }
theorem leafL_172_0_valid : (leafL_172_0).reject.ValidFor (leafL_172_0).leaf := by decide

noncomputable def leafL_172_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,237}, reject := .fullRank { members := ![0,1,17,34,52,71,94,237], points := ![104,106,121,124,127,131], inverse := ![0,7,0,0,9,15,12,11,9,4,3,9,0,0,12,8,4,0,14,9,0,4,11,8,6,6,0,14,14,0,1,1,10,4,14,0] } }
theorem leafL_172_1_valid : (leafL_172_1).reject.ValidFor (leafL_172_1).leaf := by decide

noncomputable def leafL_172_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,239}, reject := .fullRank { members := ![0,1,17,34,52,71,94,239], points := ![104,122,128,131,133,140], inverse := ![7,14,7,9,6,0,7,10,4,10,11,8,0,0,0,14,13,3,7,1,14,7,13,2,0,6,6,3,9,10,0,7,7,7,7,0] } }
theorem leafL_172_2_valid : (leafL_172_2).reject.ValidFor (leafL_172_2).leaf := by decide

noncomputable def leafL_172_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,240}, reject := .fullRank { members := ![0,1,17,34,52,71,94,240], points := ![101,104,109,120,122,131], inverse := ![9,9,7,13,4,15,8,0,15,11,5,9,5,3,6,0,0,0,0,15,8,7,8,8,7,6,1,5,5,0,15,6,9,1,1,0] } }
theorem leafL_172_3_valid : (leafL_172_3).reject.ValidFor (leafL_172_3).leaf := by decide

noncomputable def leafL_172_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,259}, reject := .fullRank { members := ![0,1,17,34,52,71,94,259], points := ![104,106,120,121,124,172], inverse := ![6,12,14,6,4,7,7,1,10,14,13,15,0,0,15,9,6,0,0,4,1,13,10,2,6,6,12,4,8,0,1,1,12,14,2,0] } }
theorem leafL_172_4_valid : (leafL_172_4).reject.ValidFor (leafL_172_4).leaf := by decide

noncomputable def leafL_172_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,267}, reject := .fullRank { members := ![0,1,17,34,52,71,94,267], points := ![101,104,106,120,121,133], inverse := ![5,3,1,15,6,15,4,12,15,6,8,9,13,1,12,0,0,0,15,2,10,14,1,8,14,11,5,11,11,0,10,15,5,9,9,0] } }
theorem leafL_172_5_valid : (leafL_172_5).reject.ValidFor (leafL_172_5).leaf := by decide

noncomputable def leafL_172_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,269}, reject := .fullRank { members := ![0,1,17,34,52,71,94,269], points := ![104,124,128,133,140,155], inverse := ![12,8,6,10,10,3,12,14,7,11,13,3,2,10,9,6,10,13,13,12,12,15,14,12,5,7,9,10,7,6,5,15,1,7,10,6] } }
theorem leafL_172_6_valid : (leafL_172_6).reject.ValidFor (leafL_172_6).leaf := by decide

noncomputable def leafL_172_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,96,101}, reject := .fullRank { members := ![0,1,17,34,52,71,96,101], points := ![121,126,127,131,141,155], inverse := ![0,0,4,14,0,11,5,14,8,15,7,11,4,8,12,0,0,0,1,13,14,8,1,11,10,11,1,10,10,0,1,12,13,3,3,0] } }
theorem leafL_172_7_valid : (leafL_172_7).reject.ValidFor (leafL_172_7).leaf := by decide

noncomputable def leavesL_172 : List RejectedLeaf := [leafL_172_0,leafL_172_1,leafL_172_2,leafL_172_3,leafL_172_4,leafL_172_5,leafL_172_6,leafL_172_7]

theorem leavesL_172_valid : LeafListValid leavesL_172 := by
  intro x hx
  simp only [leavesL_172, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_172_0_valid
  · exact leafL_172_1_valid
  · exact leafL_172_2_valid
  · exact leafL_172_3_valid
  · exact leafL_172_4_valid
  · exact leafL_172_5_valid
  · exact leafL_172_6_valid
  · exact leafL_172_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
