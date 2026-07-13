import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_314_0 : RejectedLeaf := { leaf := {0,1,17,34,52,75,127,195}, reject := .fullRank { members := ![0,1,17,34,52,75,127,195], points := ![93,103,104,108,135,141], inverse := ![9,7,15,6,3,5,14,8,15,14,0,7,0,4,10,14,0,0,15,4,8,4,14,9,0,12,5,9,13,13,0,12,8,4,6,6] } }
theorem leafL_314_0_valid : (leafL_314_0).reject.ValidFor (leafL_314_0).leaf := by decide

noncomputable def leafL_314_1 : RejectedLeaf := { leaf := {0,1,17,34,52,75,127,202}, reject := .fullRank { members := ![0,1,17,34,52,75,127,202], points := ![93,94,96,104,108,135], inverse := ![5,14,2,10,4,6,8,6,0,12,5,7,14,9,7,0,0,0,9,0,6,14,6,7,5,5,0,14,14,0,11,14,5,10,10,0] } }
theorem leafL_314_1_valid : (leafL_314_1).reject.ValidFor (leafL_314_1).leaf := by decide

noncomputable def leafL_314_2 : RejectedLeaf := { leaf := {0,1,17,34,52,75,127,264}, reject := .fullRank { members := ![0,1,17,34,52,75,127,264], points := ![83,94,96,103,108,135], inverse := ![2,13,6,4,10,6,11,9,12,9,0,7,6,4,2,0,0,0,14,1,0,3,11,7,15,1,14,3,3,0,4,0,4,4,4,0] } }
theorem leafL_314_2_valid : (leafL_314_2).reject.ValidFor (leafL_314_2).leaf := by decide

noncomputable def leafL_314_3 : RejectedLeaf := { leaf := {0,1,17,34,52,75,135,195}, reject := .fullRank { members := ![0,1,17,34,52,75,135,195], points := ![104,108,112,117,125,159], inverse := ![8,7,3,5,11,3,13,7,7,13,12,12,12,11,7,0,0,0,15,0,5,13,0,7,7,7,0,2,2,0,5,0,5,5,5,0] } }
theorem leafL_314_3_valid : (leafL_314_3).reject.ValidFor (leafL_314_3).leaf := by decide

noncomputable def leafL_314_4 : RejectedLeaf := { leaf := {0,1,17,34,52,75,141,182}, reject := .fullRank { members := ![0,1,17,34,52,75,141,182], points := ![95,104,121,124,126,147], inverse := ![6,11,2,6,4,12,13,5,6,7,3,10,0,0,8,12,4,0,9,9,1,4,14,11,5,13,11,4,6,1,8,5,12,5,3,7] } }
theorem leafL_314_4_valid : (leafL_314_4).reject.ValidFor (leafL_314_4).leaf := by decide

noncomputable def leafL_314_5 : RejectedLeaf := { leaf := {0,1,17,34,52,75,141,197}, reject := .fullRank { members := ![0,1,17,34,52,75,141,197], points := ![86,99,108,126,147,163], inverse := ![1,3,13,15,10,11,0,14,0,0,4,10,9,13,11,5,7,13,2,1,7,6,2,0,8,14,10,4,14,6,1,14,10,3,10,12] } }
theorem leafL_314_5_valid : (leafL_314_5).reject.ValidFor (leafL_314_5).leaf := by decide

noncomputable def leafL_314_6 : RejectedLeaf := { leaf := {0,1,17,34,52,75,141,202}, reject := .fullRank { members := ![0,1,17,34,52,75,141,202], points := ![95,96,99,104,108,124], inverse := ![8,7,10,12,14,6,2,11,4,7,13,7,0,0,5,2,7,0,13,5,1,7,9,7,5,5,0,14,14,0,1,1,12,3,15,0] } }
theorem leafL_314_6_valid : (leafL_314_6).reject.ValidFor (leafL_314_6).leaf := by decide

noncomputable def leafL_314_7 : RejectedLeaf := { leaf := {0,1,17,34,52,75,141,270}, reject := .fullRank { members := ![0,1,17,34,52,75,141,270], points := ![83,86,96,99,104,121], inverse := ![9,1,7,4,12,6,3,4,14,1,15,7,11,14,5,0,0,0,4,5,9,5,10,7,14,8,6,10,10,0,3,9,10,11,11,0] } }
theorem leafL_314_7_valid : (leafL_314_7).reject.ValidFor (leafL_314_7).leaf := by decide

noncomputable def leavesL_314 : List RejectedLeaf := [leafL_314_0,leafL_314_1,leafL_314_2,leafL_314_3,leafL_314_4,leafL_314_5,leafL_314_6,leafL_314_7]

theorem leavesL_314_valid : LeafListValid leavesL_314 := by
  intro x hx
  simp only [leavesL_314, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_314_0_valid
  · exact leafL_314_1_valid
  · exact leafL_314_2_valid
  · exact leafL_314_3_valid
  · exact leafL_314_4_valid
  · exact leafL_314_5_valid
  · exact leafL_314_6_valid
  · exact leafL_314_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
