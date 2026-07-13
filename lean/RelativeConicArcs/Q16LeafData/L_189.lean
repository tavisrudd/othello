import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_189_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,197}, reject := .fullRank { members := ![0,1,17,34,52,71,110,197], points := ![83,93,122,128,139,141], inverse := ![8,15,4,10,11,3,15,8,6,15,3,13,2,2,14,14,5,5,2,5,8,0,7,8,12,12,4,4,12,12,0,0,7,7,7,7] } }
theorem leafL_189_0_valid : (leafL_189_0).reject.ValidFor (leafL_189_0).leaf := by decide

noncomputable def leafL_189_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,203}, reject := .fullRank { members := ![0,1,17,34,52,71,110,203], points := ![83,93,122,127,128,131], inverse := ![13,10,3,4,9,8,7,0,8,10,11,14,0,0,1,6,7,0,4,3,4,8,4,15,5,5,3,8,11,0,8,8,14,11,5,0] } }
theorem leafL_189_1_valid : (leafL_189_1).reject.ValidFor (leafL_189_1).leaf := by decide

noncomputable def leafL_189_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,213}, reject := .fullRank { members := ![0,1,17,34,52,71,110,213], points := ![83,91,128,131,147,155], inverse := ![10,4,3,2,14,0,6,0,0,9,15,0,13,10,10,6,2,9,15,11,0,6,9,11,8,5,15,5,6,1,12,12,0,0,12,12] } }
theorem leafL_189_2_valid : (leafL_189_2).reject.ValidFor (leafL_189_2).leaf := by decide

noncomputable def leafL_189_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,216}, reject := .fullRank { members := ![0,1,17,34,52,71,110,216], points := ![83,122,127,128,131,133], inverse := ![7,5,9,2,10,2,7,8,10,11,14,0,0,1,6,7,0,0,7,5,13,0,1,14,0,0,7,7,1,1,0,7,0,7,7,7] } }
theorem leafL_189_3_valid : (leafL_189_3).reject.ValidFor (leafL_189_3).leaf := by decide

noncomputable def leafL_189_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,217}, reject := .fullRank { members := ![0,1,17,34,52,71,110,217], points := ![83,91,122,131,141,144], inverse := ![10,13,14,5,2,15,14,9,9,14,9,9,0,0,0,12,1,13,5,2,8,8,14,9,8,8,0,4,4,0,5,5,0,10,3,9] } }
theorem leafL_189_4_valid : (leafL_189_4).reject.ValidFor (leafL_189_4).leaf := by decide

noncomputable def leafL_189_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,237}, reject := .fullRank { members := ![0,1,17,34,52,71,110,237], points := ![91,122,127,131,133,139], inverse := ![7,2,12,5,9,4,7,12,5,15,3,2,0,0,0,11,9,2,7,14,6,3,3,15,0,1,1,10,8,2,0,6,6,12,14,2] } }
theorem leafL_189_5_valid : (leafL_189_5).reject.ValidFor (leafL_189_5).leaf := by decide

noncomputable def leafL_189_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,240}, reject := .fullRank { members := ![0,1,17,34,52,71,110,240], points := ![127,131,141,155,159,166], inverse := ![4,14,0,11,0,0,11,4,4,11,8,8,5,6,3,15,10,5,9,8,10,1,1,11,2,10,8,8,10,2,6,15,9,8,14,6] } }
theorem leafL_189_6_valid : (leafL_189_6).reject.ValidFor (leafL_189_6).leaf := by decide

noncomputable def leafL_189_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,245}, reject := .fullRank { members := ![0,1,17,34,52,71,110,245], points := ![91,93,122,139,144,147], inverse := ![11,0,8,12,6,8,11,14,8,9,9,13,11,3,4,5,8,1,3,13,5,13,8,14,7,4,8,12,5,2,7,15,4,13,0,1] } }
theorem leafL_189_7_valid : (leafL_189_7).reject.ValidFor (leafL_189_7).leaf := by decide

noncomputable def leavesL_189 : List RejectedLeaf := [leafL_189_0,leafL_189_1,leafL_189_2,leafL_189_3,leafL_189_4,leafL_189_5,leafL_189_6,leafL_189_7]

theorem leavesL_189_valid : LeafListValid leavesL_189 := by
  intro x hx
  simp only [leavesL_189, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_189_0_valid
  · exact leafL_189_1_valid
  · exact leafL_189_2_valid
  · exact leafL_189_3_valid
  · exact leafL_189_4_valid
  · exact leafL_189_5_valid
  · exact leafL_189_6_valid
  · exact leafL_189_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
