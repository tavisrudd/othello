import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_202_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,131,240}, reject := .fullRank { members := ![0,1,17,34,52,71,131,240], points := ![90,94,109,110,120,150], inverse := ![0,0,0,12,14,3,4,12,6,14,11,11,15,5,0,9,1,2,2,10,11,4,7,0,14,3,4,12,3,6,11,15,1,10,5,10] } }
theorem leafL_202_0_valid : (leafL_202_0).reject.ValidFor (leafL_202_0).leaf := by decide

noncomputable def leafL_202_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,131,271}, reject := .fullRank { members := ![0,1,17,34,52,71,131,271], points := ![96,109,110,121,126,156], inverse := ![5,8,9,14,9,2,7,4,8,3,0,8,1,14,8,14,2,11,7,13,6,12,3,3,13,8,0,4,7,6,13,4,12,2,1,6] } }
theorem leafL_202_1_valid : (leafL_202_1).reject.ValidFor (leafL_202_1).leaf := by decide

noncomputable def leafL_202_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,139,156}, reject := .fullRank { members := ![0,1,17,34,52,71,139,156], points := ![101,104,110,121,166,176], inverse := ![13,9,14,12,0,7,15,7,14,9,13,2,15,4,11,0,0,0,15,14,5,6,12,14,12,7,11,0,5,5,0,1,1,0,1,1] } }
theorem leafL_202_2_valid : (leafL_202_2).reject.ValidFor (leafL_202_2).leaf := by decide

noncomputable def leafL_202_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,139,173}, reject := .fullRank { members := ![0,1,17,34,52,71,139,173], points := ![92,101,104,106,124,126], inverse := ![15,7,5,10,10,12,9,2,10,6,7,0,0,13,1,12,0,0,8,7,0,8,10,13,0,12,3,15,9,9,0,15,8,7,12,12] } }
theorem leafL_202_3_valid : (leafL_202_3).reject.ValidFor (leafL_202_3).leaf := by decide

noncomputable def leafL_202_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,139,181}, reject := .fullRank { members := ![0,1,17,34,52,71,139,181], points := ![121,124,150,154,156,166], inverse := ![12,6,8,7,10,14,9,2,10,10,3,8,0,0,13,5,8,0,12,7,12,2,12,9,8,8,15,14,1,0,1,1,4,7,3,0] } }
theorem leafL_202_4_valid : (leafL_202_4).reject.ValidFor (leafL_202_4).leaf := by decide

noncomputable def leafL_202_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,139,197}, reject := .fullRank { members := ![0,1,17,34,52,71,139,197], points := ![90,92,93,104,106,120], inverse := ![6,7,14,10,2,6,8,12,13,14,0,7,12,3,15,0,0,0,10,11,9,6,9,7,9,2,11,12,12,0,6,14,8,3,3,0] } }
theorem leafL_202_5_valid : (leafL_202_5).reject.ValidFor (leafL_202_5).leaf := by decide

noncomputable def leafL_202_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,139,217}, reject := .fullRank { members := ![0,1,17,34,52,71,139,217], points := ![101,104,120,124,154,156], inverse := ![3,15,3,13,3,0,13,0,12,13,4,8,6,6,6,6,2,2,5,15,13,0,15,8,9,9,11,11,2,2,6,6,11,11,10,10] } }
theorem leafL_202_6_valid : (leafL_202_6).reject.ValidFor (leafL_202_6).leaf := by decide

noncomputable def leafL_202_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,139,222}, reject := .fullRank { members := ![0,1,17,34,52,71,139,222], points := ![90,92,93,121,124,150], inverse := ![4,3,5,7,2,6,2,6,1,7,15,13,12,3,15,0,0,0,13,4,10,10,0,9,8,8,0,15,15,0,11,5,14,7,7,0] } }
theorem leafL_202_7_valid : (leafL_202_7).reject.ValidFor (leafL_202_7).leaf := by decide

noncomputable def leavesL_202 : List RejectedLeaf := [leafL_202_0,leafL_202_1,leafL_202_2,leafL_202_3,leafL_202_4,leafL_202_5,leafL_202_6,leafL_202_7]

theorem leavesL_202_valid : LeafListValid leavesL_202 := by
  intro x hx
  simp only [leavesL_202, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_202_0_valid
  · exact leafL_202_1_valid
  · exact leafL_202_2_valid
  · exact leafL_202_3_valid
  · exact leafL_202_4_valid
  · exact leafL_202_5_valid
  · exact leafL_202_6_valid
  · exact leafL_202_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
