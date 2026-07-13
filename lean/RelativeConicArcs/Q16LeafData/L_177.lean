import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_177_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,235}, reject := .fullRank { members := ![0,1,17,34,52,71,101,235], points := ![83,90,93,121,126,131], inverse := ![11,5,9,11,5,8,3,6,2,8,1,14,15,1,14,0,0,0,11,1,13,0,8,15,6,11,13,5,5,0,0,12,12,12,12,0] } }
theorem leafL_177_0_valid : (leafL_177_0).reject.ValidFor (leafL_177_0).leaf := by decide

noncomputable def leafL_177_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,243}, reject := .fullRank { members := ![0,1,17,34,52,71,101,243], points := ![93,94,121,124,127,138], inverse := ![7,0,3,4,9,8,15,8,12,10,15,14,0,0,12,8,4,0,2,5,4,9,5,15,3,3,6,1,7,0,9,9,11,15,4,0] } }
theorem leafL_177_1_valid : (leafL_177_1).reject.ValidFor (leafL_177_1).leaf := by decide

noncomputable def leafL_177_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,246}, reject := .fullRank { members := ![0,1,17,34,52,71,101,246], points := ![83,92,94,121,126,131], inverse := ![7,1,1,11,5,8,13,2,8,8,1,14,3,14,13,0,0,0,15,0,8,0,8,15,0,9,9,5,5,0,11,3,8,12,12,0] } }
theorem leafL_177_2_valid : (leafL_177_2).reject.ValidFor (leafL_177_2).leaf := by decide

noncomputable def leafL_177_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,248}, reject := .fullRank { members := ![0,1,17,34,52,71,101,248], points := ![93,94,96,121,124,131], inverse := ![14,1,8,1,15,8,10,4,9,10,3,14,14,9,7,0,0,0,7,15,15,3,11,15,0,8,8,15,15,0,7,0,7,7,7,0] } }
theorem leafL_177_3_valid : (leafL_177_3).reject.ValidFor (leafL_177_3).leaf := by decide

noncomputable def leafL_177_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,249}, reject := .fullRank { members := ![0,1,17,34,52,71,101,249], points := ![83,90,92,126,131,141], inverse := ![9,14,0,14,10,2,10,2,15,9,1,15,10,11,1,0,0,0,12,15,4,8,15,0,10,13,7,0,4,4,14,13,3,0,1,1] } }
theorem leafL_177_4_valid : (leafL_177_4).reject.ValidFor (leafL_177_4).leaf := by decide

noncomputable def leafL_177_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,267}, reject := .fullRank { members := ![0,1,17,34,52,71,101,267], points := ![92,93,94,127,128,147], inverse := ![3,1,0,8,13,6,9,5,9,2,10,13,1,6,7,0,0,0,2,15,14,10,0,9,1,5,4,2,2,0,0,9,9,9,9,0] } }
theorem leafL_177_5_valid : (leafL_177_5).reject.ValidFor (leafL_177_5).leaf := by decide

noncomputable def leafL_177_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,268}, reject := .fullRank { members := ![0,1,17,34,52,71,101,268], points := ![90,126,127,131,139,147], inverse := ![13,7,12,11,0,12,12,10,15,4,14,3,9,13,0,9,3,14,3,15,5,7,7,9,6,15,12,2,3,4,12,8,14,3,1,8] } }
theorem leafL_177_6_valid : (leafL_177_6).reject.ValidFor (leafL_177_6).leaf := by decide

noncomputable def leafL_177_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,121}, reject := .fullRank { members := ![0,1,17,34,52,71,104,121], points := ![90,91,94,139,141,158], inverse := ![1,1,8,5,6,10,8,7,9,10,3,15,10,2,8,0,0,0,2,12,10,2,4,2,8,9,1,5,5,0,6,13,11,12,12,0] } }
theorem leafL_177_7_valid : (leafL_177_7).reject.ValidFor (leafL_177_7).leaf := by decide

noncomputable def leavesL_177 : List RejectedLeaf := [leafL_177_0,leafL_177_1,leafL_177_2,leafL_177_3,leafL_177_4,leafL_177_5,leafL_177_6,leafL_177_7]

theorem leavesL_177_valid : LeafListValid leavesL_177 := by
  intro x hx
  simp only [leavesL_177, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_177_0_valid
  · exact leafL_177_1_valid
  · exact leafL_177_2_valid
  · exact leafL_177_3_valid
  · exact leafL_177_4_valid
  · exact leafL_177_5_valid
  · exact leafL_177_6_valid
  · exact leafL_177_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
