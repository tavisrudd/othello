import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_157_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,158,208}, reject := .fullRank { members := ![0,1,17,34,52,70,158,208], points := ![83,91,95,101,103,115], inverse := ![11,7,3,7,15,6,3,13,7,15,1,7,12,7,11,0,0,0,0,2,10,12,3,7,8,7,15,2,2,0,14,12,2,9,9,0] } }
theorem leafL_157_0_valid : (leafL_157_0).reject.ValidFor (leafL_157_0).leaf := by decide

noncomputable def leafL_157_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,158,218}, reject := .fullRank { members := ![0,1,17,34,52,70,158,218], points := ![83,91,95,101,117,120], inverse := ![6,10,3,8,15,9,7,5,11,14,7,0,12,7,11,0,0,0,13,10,15,15,8,15,1,7,6,0,15,15,1,12,13,0,7,7] } }
theorem leafL_157_1_valid : (leafL_157_1).reject.ValidFor (leafL_157_1).leaf := by decide

noncomputable def leafL_157_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,101}, reject := .fullRank { members := ![0,1,17,34,52,71,90,101], points := ![121,124,126,131,139,147], inverse := ![8,10,6,6,8,11,8,2,9,8,0,11,8,12,4,0,0,0,0,11,9,4,13,11,6,3,5,4,4,0,9,3,10,15,15,0] } }
theorem leafL_157_2_valid : (leafL_157_2).reject.ValidFor (leafL_157_2).leaf := by decide

noncomputable def leafL_157_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,109}, reject := .fullRank { members := ![0,1,17,34,52,71,90,109], points := ![124,127,131,144,150,155], inverse := ![0,4,14,0,0,11,8,11,9,1,11,0,1,1,10,10,9,9,5,7,4,13,0,11,4,4,11,11,0,0,3,3,11,11,4,4] } }
theorem leafL_157_3_valid : (leafL_157_3).reject.ValidFor (leafL_157_3).leaf := by decide

noncomputable def leafL_157_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,121}, reject := .fullRank { members := ![0,1,17,34,52,71,90,121], points := ![101,104,131,133,139,150], inverse := ![3,10,15,9,11,5,13,15,6,7,5,6,0,0,11,9,2,0,15,2,0,12,13,12,6,6,1,5,4,0,7,7,3,6,5,0] } }
theorem leafL_157_4_valid : (leafL_157_4).reject.ValidFor (leafL_157_4).leaf := by decide

noncomputable def leafL_157_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,126}, reject := .fullRank { members := ![0,1,17,34,52,71,90,126], points := ![101,104,131,139,150,166], inverse := ![11,14,10,3,7,10,4,2,5,12,9,6,8,4,14,10,2,10,8,8,1,10,9,2,9,8,5,11,7,8,13,2,10,15,11,1] } }
theorem leafL_157_5_valid : (leafL_157_5).reject.ValidFor (leafL_157_5).leaf := by decide

noncomputable def leafL_157_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,131}, reject := .fullRank { members := ![0,1,17,34,52,71,90,131], points := ![101,109,121,126,150,168], inverse := ![8,14,4,12,6,9,10,11,4,1,10,14,0,5,12,15,11,13,4,0,1,7,0,2,13,4,1,6,13,3,5,1,9,4,2,11] } }
theorem leafL_157_6_valid : (leafL_157_6).reject.ValidFor (leafL_157_6).leaf := by decide

noncomputable def leafL_157_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,139}, reject := .fullRank { members := ![0,1,17,34,52,71,90,139], points := ![101,104,121,126,158,166], inverse := ![3,8,5,7,9,1,7,7,1,10,3,8,12,7,10,2,12,15,12,0,9,6,4,7,9,5,11,15,6,14,0,5,15,12,11,13] } }
theorem leafL_157_7_valid : (leafL_157_7).reject.ValidFor (leafL_157_7).leaf := by decide

noncomputable def leavesL_157 : List RejectedLeaf := [leafL_157_0,leafL_157_1,leafL_157_2,leafL_157_3,leafL_157_4,leafL_157_5,leafL_157_6,leafL_157_7]

theorem leavesL_157_valid : LeafListValid leavesL_157 := by
  intro x hx
  simp only [leavesL_157, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_157_0_valid
  · exact leafL_157_1_valid
  · exact leafL_157_2_valid
  · exact leafL_157_3_valid
  · exact leafL_157_4_valid
  · exact leafL_157_5_valid
  · exact leafL_157_6_valid
  · exact leafL_157_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
