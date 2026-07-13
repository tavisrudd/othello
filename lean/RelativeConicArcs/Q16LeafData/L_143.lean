import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_143_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,175}, reject := .fullRank { members := ![0,1,17,34,52,70,107,175], points := ![83,96,120,126,131,151], inverse := ![12,11,12,2,8,0,11,6,9,5,13,12,4,2,10,9,1,4,11,0,7,9,13,8,0,10,6,3,3,12,12,5,14,3,10,14] } }
theorem leafL_143_0_valid : (leafL_143_0).reject.ValidFor (leafL_143_0).leaf := by decide

noncomputable def leafL_143_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,188}, reject := .fullRank { members := ![0,1,17,34,52,70,107,188], points := ![94,96,115,122,126,131], inverse := ![8,15,4,2,8,8,11,12,11,14,12,14,0,0,14,12,2,0,2,5,8,13,13,15,8,8,11,13,6,0,13,13,1,8,9,0] } }
theorem leafL_143_1_valid : (leafL_143_1).reject.ValidFor (leafL_143_1).leaf := by decide

noncomputable def leafL_143_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,202}, reject := .fullRank { members := ![0,1,17,34,52,70,107,202], points := ![94,95,120,126,127,131], inverse := ![13,10,15,11,10,8,15,8,12,0,5,14,0,0,11,4,15,0,1,6,11,12,15,15,1,1,14,3,13,0,7,7,0,7,7,0] } }
theorem leafL_143_2_valid : (leafL_143_2).reject.ValidFor (leafL_143_2).leaf := by decide

noncomputable def leafL_143_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,205}, reject := .fullRank { members := ![0,1,17,34,52,70,107,205], points := ![94,96,122,124,126,131], inverse := ![8,15,5,1,10,8,11,12,15,6,0,14,0,0,15,10,5,0,2,5,3,2,9,15,8,8,12,6,10,0,13,13,13,13,0,0] } }
theorem leafL_143_3_valid : (leafL_143_3).reject.ValidFor (leafL_143_3).leaf := by decide

noncomputable def leafL_143_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,208}, reject := .fullRank { members := ![0,1,17,34,52,70,107,208], points := ![83,94,95,115,124,133], inverse := ![6,14,15,9,7,8,12,4,15,15,6,14,15,9,6,0,0,0,14,3,10,6,14,15,9,3,10,4,4,0,6,12,10,1,1,0] } }
theorem leafL_143_4_valid : (leafL_143_4).reject.ValidFor (leafL_143_4).leaf := by decide

noncomputable def leafL_143_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,231}, reject := .fullRank { members := ![0,1,17,34,52,70,107,231], points := ![96,115,122,124,137,158], inverse := ![2,9,13,1,0,6,6,14,0,14,9,15,0,10,11,1,0,0,9,15,2,2,3,5,9,2,15,0,10,14,10,8,9,4,3,12] } }
theorem leafL_143_5_valid : (leafL_143_5).reject.ValidFor (leafL_143_5).leaf := by decide

noncomputable def leafL_143_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,237}, reject := .fullRank { members := ![0,1,17,34,52,70,107,237], points := ![83,94,96,115,122,133], inverse := ![11,7,11,10,4,8,7,9,9,6,15,14,6,4,2,0,0,0,4,10,9,0,8,15,10,4,14,10,10,0,8,12,4,11,11,0] } }
theorem leafL_143_6_valid : (leafL_143_6).reject.ValidFor (leafL_143_6).leaf := by decide

noncomputable def leafL_143_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,239}, reject := .fullRank { members := ![0,1,17,34,52,70,107,239], points := ![83,94,120,122,126,131], inverse := ![2,5,14,5,5,8,7,0,13,12,8,14,0,0,7,4,3,0,15,8,0,0,8,15,11,11,3,7,4,0,4,4,2,10,8,0] } }
theorem leafL_143_7_valid : (leafL_143_7).reject.ValidFor (leafL_143_7).leaf := by decide

noncomputable def leavesL_143 : List RejectedLeaf := [leafL_143_0,leafL_143_1,leafL_143_2,leafL_143_3,leafL_143_4,leafL_143_5,leafL_143_6,leafL_143_7]

theorem leavesL_143_valid : LeafListValid leavesL_143 := by
  intro x hx
  simp only [leavesL_143, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_143_0_valid
  · exact leafL_143_1_valid
  · exact leafL_143_2_valid
  · exact leafL_143_3_valid
  · exact leafL_143_4_valid
  · exact leafL_143_5_valid
  · exact leafL_143_6_valid
  · exact leafL_143_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
