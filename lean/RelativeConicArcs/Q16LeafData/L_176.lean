import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_176_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,186}, reject := .fullRank { members := ![0,1,17,34,52,71,101,186], points := ![93,96,121,124,127,131], inverse := ![1,6,10,12,8,8,3,4,0,15,6,14,0,0,12,8,4,0,13,10,0,9,1,15,1,1,8,4,12,0,7,7,7,7,0,0] } }
theorem leafL_176_0_valid : (leafL_176_0).reject.ValidFor (leafL_176_0).leaf := by decide

noncomputable def leafL_176_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,205}, reject := .fullRank { members := ![0,1,17,34,52,71,101,205], points := ![90,94,124,126,127,131], inverse := ![14,9,12,7,5,8,6,1,1,1,9,14,0,0,4,12,8,0,11,12,8,3,3,15,4,4,14,14,0,0,15,15,14,6,8,0] } }
theorem leafL_176_1_valid : (leafL_176_1).reject.ValidFor (leafL_176_1).leaf := by decide

noncomputable def leafL_176_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,207}, reject := .fullRank { members := ![0,1,17,34,52,71,101,207], points := ![83,92,94,121,124,139], inverse := ![0,4,3,7,9,8,9,13,3,7,14,14,3,14,13,0,0,0,9,5,11,10,2,15,7,13,10,15,15,0,14,2,12,7,7,0] } }
theorem leafL_176_2_valid : (leafL_176_2).reject.ValidFor (leafL_176_2).leaf := by decide

noncomputable def leafL_176_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,217}, reject := .fullRank { members := ![0,1,17,34,52,71,101,217], points := ![83,94,124,131,138,139], inverse := ![10,13,14,2,10,0,8,15,9,7,1,8,0,0,0,6,3,5,4,3,8,2,13,0,10,10,0,14,13,3,9,9,0,11,7,12] } }
theorem leafL_176_3_valid : (leafL_176_3).reject.ValidFor (leafL_176_3).leaf := by decide

noncomputable def leafL_176_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,218}, reject := .fullRank { members := ![0,1,17,34,52,71,101,218], points := ![83,96,121,124,127,139], inverse := ![7,0,8,3,5,8,6,1,4,12,1,14,0,0,12,8,4,0,1,6,5,8,5,15,12,12,4,12,8,0,2,2,5,10,15,0] } }
theorem leafL_176_4_valid : (leafL_176_4).reject.ValidFor (leafL_176_4).leaf := by decide

noncomputable def leafL_176_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,223}, reject := .fullRank { members := ![0,1,17,34,52,71,101,223], points := ![83,90,93,121,138,141], inverse := ![3,10,14,14,10,2,13,1,11,9,6,8,15,1,14,0,0,0,4,9,10,8,0,15,6,8,14,0,6,6,0,8,8,0,8,8] } }
theorem leafL_176_5_valid : (leafL_176_5).reject.ValidFor (leafL_176_5).leaf := by decide

noncomputable def leafL_176_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,232}, reject := .fullRank { members := ![0,1,17,34,52,71,101,232], points := ![83,92,93,126,127,138], inverse := ![13,9,3,10,4,8,8,6,9,6,15,14,6,12,10,0,0,0,10,10,7,0,8,15,4,2,6,15,15,0,12,8,4,7,7,0] } }
theorem leafL_176_6_valid : (leafL_176_6).reject.ValidFor (leafL_176_6).leaf := by decide

noncomputable def leafL_176_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,233}, reject := .fullRank { members := ![0,1,17,34,52,71,101,233], points := ![90,94,96,124,126,138], inverse := ![2,11,14,2,12,8,0,9,14,14,7,14,5,15,10,0,0,0,11,8,4,4,12,15,4,4,0,14,14,0,10,0,10,10,10,0] } }
theorem leafL_176_7_valid : (leafL_176_7).reject.ValidFor (leafL_176_7).leaf := by decide

noncomputable def leavesL_176 : List RejectedLeaf := [leafL_176_0,leafL_176_1,leafL_176_2,leafL_176_3,leafL_176_4,leafL_176_5,leafL_176_6,leafL_176_7]

theorem leavesL_176_valid : LeafListValid leavesL_176 := by
  intro x hx
  simp only [leavesL_176, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_176_0_valid
  · exact leafL_176_1_valid
  · exact leafL_176_2_valid
  · exact leafL_176_3_valid
  · exact leafL_176_4_valid
  · exact leafL_176_5_valid
  · exact leafL_176_6_valid
  · exact leafL_176_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
