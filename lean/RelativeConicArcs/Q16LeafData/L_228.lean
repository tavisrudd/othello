import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_228_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,176,186}, reject := .fullRank { members := ![0,1,17,34,52,71,176,186], points := ![91,93,99,104,127,131], inverse := ![4,1,3,1,12,10,13,5,12,3,6,1,3,4,13,10,7,7,13,15,15,10,13,10,5,6,1,2,3,3,2,11,15,6,9,9] } }
theorem leafL_228_0_valid : (leafL_228_0).reject.ValidFor (leafL_228_0).leaf := by decide

noncomputable def leafL_228_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,176,191}, reject := .fullRank { members := ![0,1,17,34,52,71,176,191], points := ![90,91,92,99,101,120], inverse := ![10,7,2,15,7,6,5,12,0,7,9,7,7,14,9,0,0,0,6,1,15,8,7,7,12,14,2,15,15,0,6,13,11,7,7,0] } }
theorem leafL_228_1_valid : (leafL_228_1).reject.ValidFor (leafL_228_1).leaf := by decide

noncomputable def leafL_228_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,176,197}, reject := .fullRank { members := ![0,1,17,34,52,71,176,197], points := ![83,90,92,99,104,126], inverse := ![5,8,2,8,0,6,15,15,9,15,1,7,10,11,1,0,0,0,8,6,6,11,4,7,11,13,6,10,10,0,3,13,14,11,11,0] } }
theorem leafL_228_2_valid : (leafL_228_2).reject.ValidFor (leafL_228_2).leaf := by decide

noncomputable def leafL_228_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,176,205}, reject := .fullRank { members := ![0,1,17,34,52,71,176,205], points := ![90,91,99,101,104,120], inverse := ![5,10,12,2,6,6,5,12,7,9,0,7,0,0,4,12,8,0,3,11,9,4,2,7,3,3,12,10,6,0,14,14,0,14,14,0] } }
theorem leafL_228_3_valid : (leafL_228_3).reject.ValidFor (leafL_228_3).leaf := by decide

noncomputable def leafL_228_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,176,216}, reject := .fullRank { members := ![0,1,17,34,52,71,176,216], points := ![83,90,99,101,126,127], inverse := ![15,0,7,15,9,15,14,7,4,10,5,2,15,15,14,14,14,14,11,3,12,3,2,5,14,14,9,9,6,6,2,2,13,13,10,10] } }
theorem leafL_228_4_valid : (leafL_228_4).reject.ValidFor (leafL_228_4).leaf := by decide

noncomputable def leafL_228_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,176,223}, reject := .fullRank { members := ![0,1,17,34,52,71,176,223], points := ![83,93,94,101,104,126], inverse := ![3,14,2,11,3,6,14,5,2,2,12,7,11,3,8,0,0,0,3,15,4,14,1,7,12,13,1,13,13,0,5,7,2,14,14,0] } }
theorem leafL_228_5_valid : (leafL_228_5).reject.ValidFor (leafL_228_5).leaf := by decide

noncomputable def leafL_228_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,176,232}, reject := .fullRank { members := ![0,1,17,34,52,71,176,232], points := ![83,92,93,110,126,127], inverse := ![8,12,11,8,1,7,10,4,7,14,7,0,6,12,10,0,0,0,14,14,8,15,2,5,4,2,6,0,15,15,12,8,4,0,7,7] } }
theorem leafL_228_6_valid : (leafL_228_6).reject.ValidFor (leafL_228_6).leaf := by decide

noncomputable def leafL_228_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,176,237}, reject := .fullRank { members := ![0,1,17,34,52,71,176,237], points := ![83,90,91,104,110,127], inverse := ![10,3,6,14,6,6,1,6,14,12,2,7,6,3,5,0,0,0,1,0,9,15,0,7,6,0,6,5,5,0,3,6,5,12,12,0] } }
theorem leafL_228_7_valid : (leafL_228_7).reject.ValidFor (leafL_228_7).leaf := by decide

noncomputable def leavesL_228 : List RejectedLeaf := [leafL_228_0,leafL_228_1,leafL_228_2,leafL_228_3,leafL_228_4,leafL_228_5,leafL_228_6,leafL_228_7]

theorem leavesL_228_valid : LeafListValid leavesL_228 := by
  intro x hx
  simp only [leavesL_228, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_228_0_valid
  · exact leafL_228_1_valid
  · exact leafL_228_2_valid
  · exact leafL_228_3_valid
  · exact leafL_228_4_valid
  · exact leafL_228_5_valid
  · exact leafL_228_6_valid
  · exact leafL_228_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
