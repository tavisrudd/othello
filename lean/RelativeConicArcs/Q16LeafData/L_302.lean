import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_302_0 : RejectedLeaf := { leaf := {0,1,17,34,52,74,110,185}, reject := .fullRank { members := ![0,1,17,34,52,74,110,185], points := ![86,93,115,117,133,144], inverse := ![8,15,6,8,12,4,3,4,11,2,10,4,14,14,10,10,3,3,13,10,14,6,15,0,11,11,0,0,12,12,10,10,12,12,1,1] } }
theorem leafL_302_0_valid : (leafL_302_0).reject.ValidFor (leafL_302_0).leaf := by decide

noncomputable def leafL_302_1 : RejectedLeaf := { leaf := {0,1,17,34,52,74,110,203}, reject := .fullRank { members := ![0,1,17,34,52,74,110,203], points := ![89,93,115,125,131,133], inverse := ![3,4,15,1,10,2,10,13,3,10,1,15,9,9,10,10,15,15,2,5,9,1,12,3,12,12,11,11,2,2,4,4,12,12,6,6] } }
theorem leafL_302_1_valid : (leafL_302_1).reject.ValidFor (leafL_302_1).leaf := by decide

noncomputable def leafL_302_2 : RejectedLeaf := { leaf := {0,1,17,34,52,74,110,256}, reject := .fullRank { members := ![0,1,17,34,52,74,110,256], points := ![93,115,117,133,137,141], inverse := ![7,4,10,6,6,8,7,15,6,3,6,11,0,0,0,12,11,7,7,0,8,8,0,7,0,6,6,1,10,11,0,7,7,11,8,3] } }
theorem leafL_302_2_valid : (leafL_302_2).reject.ValidFor (leafL_302_2).leaf := by decide

noncomputable def leafL_302_3 : RejectedLeaf := { leaf := {0,1,17,34,52,74,117,141}, reject := .fullRank { members := ![0,1,17,34,52,74,117,141], points := ![83,86,110,147,150,167], inverse := ![14,12,15,11,3,4,12,5,7,9,4,3,2,6,4,11,15,4,4,8,2,13,4,7,10,5,15,6,9,15,9,9,0,9,9,0] } }
theorem leafL_302_3_valid : (leafL_302_3).reject.ValidFor (leafL_302_3).leaf := by decide

noncomputable def leafL_302_4 : RejectedLeaf := { leaf := {0,1,17,34,52,74,117,195}, reject := .fullRank { members := ![0,1,17,34,52,74,117,195], points := ![86,92,93,104,109,137], inverse := ![2,8,3,1,15,6,3,13,0,10,3,7,6,10,12,0,0,0,7,15,7,3,11,7,12,10,6,7,7,0,14,7,9,5,5,0] } }
theorem leafL_302_4_valid : (leafL_302_4).reject.ValidFor (leafL_302_4).leaf := by decide

noncomputable def leafL_302_5 : RejectedLeaf := { leaf := {0,1,17,34,52,74,117,235}, reject := .fullRank { members := ![0,1,17,34,52,74,117,235], points := ![86,93,104,110,112,137], inverse := ![11,2,13,4,7,6,9,7,15,12,10,7,0,0,8,6,14,0,2,13,6,0,14,7,10,10,11,8,3,0,2,2,7,6,1,0] } }
theorem leafL_302_5_valid : (leafL_302_5).reject.ValidFor (leafL_302_5).leaf := by decide

noncomputable def leafL_302_6 : RejectedLeaf := { leaf := {0,1,17,34,52,74,117,259}, reject := .fullRank { members := ![0,1,17,34,52,74,117,259], points := ![86,92,104,107,110,143], inverse := ![11,2,10,11,15,6,5,11,14,2,5,7,0,0,5,11,14,0,11,4,10,8,10,7,15,15,9,6,15,0,3,3,11,10,1,0] } }
theorem leafL_302_6_valid : (leafL_302_6).reject.ValidFor (leafL_302_6).leaf := by decide

noncomputable def leafL_302_7 : RejectedLeaf := { leaf := {0,1,17,34,52,74,120,172}, reject := .fullRank { members := ![0,1,17,34,52,74,120,172], points := ![83,93,95,131,133,147], inverse := ![1,15,6,9,10,10,6,0,0,9,0,15,13,8,5,0,0,0,11,10,5,13,11,2,4,13,9,5,5,0,14,5,11,12,12,0] } }
theorem leafL_302_7_valid : (leafL_302_7).reject.ValidFor (leafL_302_7).leaf := by decide

noncomputable def leavesL_302 : List RejectedLeaf := [leafL_302_0,leafL_302_1,leafL_302_2,leafL_302_3,leafL_302_4,leafL_302_5,leafL_302_6,leafL_302_7]

theorem leavesL_302_valid : LeafListValid leavesL_302 := by
  intro x hx
  simp only [leavesL_302, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_302_0_valid
  · exact leafL_302_1_valid
  · exact leafL_302_2_valid
  · exact leafL_302_3_valid
  · exact leafL_302_4_valid
  · exact leafL_302_5_valid
  · exact leafL_302_6_valid
  · exact leafL_302_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
