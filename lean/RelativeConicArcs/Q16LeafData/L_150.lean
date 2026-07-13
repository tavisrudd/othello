import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_150_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,120,239}, reject := .fullRank { members := ![0,1,17,34,52,70,120,239], points := ![91,103,107,108,133,139], inverse := ![9,5,10,1,6,0,14,0,9,0,0,7,0,14,10,4,0,0,15,2,4,14,15,8,0,15,13,2,14,14,0,11,15,4,8,8] } }
theorem leafL_150_0_valid : (leafL_150_0).reject.ValidFor (leafL_150_0).leaf := by decide

noncomputable def leafL_150_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,120,240}, reject := .fullRank { members := ![0,1,17,34,52,70,120,240], points := ![95,109,137,140,141,151], inverse := ![15,12,11,2,2,9,2,13,1,9,6,1,0,0,10,2,8,0,10,11,7,7,5,4,1,14,12,2,11,10,6,2,4,9,0,9] } }
theorem leafL_150_1_valid : (leafL_150_1).reject.ValidFor (leafL_150_1).leaf := by decide

noncomputable def leafL_150_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,120,245}, reject := .fullRank { members := ![0,1,17,34,52,70,120,245], points := ![89,95,96,103,108,137], inverse := ![13,1,5,15,1,6,7,10,3,6,15,7,1,7,6,0,0,0,13,6,4,12,4,7,4,10,14,3,3,0,12,3,15,4,4,0] } }
theorem leafL_150_2_valid : (leafL_150_2).reject.ValidFor (leafL_150_2).leaf := by decide

noncomputable def leafL_150_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,120,247}, reject := .fullRank { members := ![0,1,17,34,52,70,120,247], points := ![83,96,107,139,140,141], inverse := ![14,7,14,7,8,9,12,2,9,3,15,11,0,0,0,7,6,1,0,15,8,5,9,11,5,5,0,1,15,14,13,13,0,1,5,4] } }
theorem leafL_150_3_valid : (leafL_150_3).reject.ValidFor (leafL_150_3).leaf := by decide

noncomputable def leafL_150_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,120,265}, reject := .fullRank { members := ![0,1,17,34,52,70,120,265], points := ![83,103,108,109,140,141], inverse := ![9,8,10,12,1,7,14,9,12,12,14,9,0,5,11,14,0,0,15,1,12,5,8,15,0,8,13,5,15,15,0,0,3,3,3,3] } }
theorem leafL_150_4_valid : (leafL_150_4).reject.ValidFor (leafL_150_4).leaf := by decide

noncomputable def leafL_150_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,120,267}, reject := .fullRank { members := ![0,1,17,34,52,70,120,267], points := ![89,95,133,137,141,147], inverse := ![7,15,13,11,5,10,12,10,9,4,4,15,0,0,12,11,7,0,3,7,4,6,4,2,2,2,8,13,5,0,12,12,8,9,1,0] } }
theorem leafL_150_5_valid : (leafL_150_5).reject.ValidFor (leafL_150_5).leaf := by decide

noncomputable def leafL_150_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,125,135}, reject := .fullRank { members := ![0,1,17,34,52,70,125,135], points := ![90,94,95,110,149,152], inverse := ![11,7,10,11,8,4,11,7,6,4,2,12,8,10,2,0,0,0,11,14,14,5,10,4,11,8,3,0,11,11,0,6,6,0,6,6] } }
theorem leafL_150_6_valid : (leafL_150_6).reject.ValidFor (leafL_150_6).leaf := by decide

noncomputable def leafL_150_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,125,137}, reject := .fullRank { members := ![0,1,17,34,52,70,125,137], points := ![91,94,95,101,103,147], inverse := ![5,1,2,1,10,12,14,4,0,8,12,14,8,2,10,0,0,0,6,13,0,11,14,14,13,13,0,2,2,0,8,12,4,9,9,0] } }
theorem leafL_150_7_valid : (leafL_150_7).reject.ValidFor (leafL_150_7).leaf := by decide

noncomputable def leavesL_150 : List RejectedLeaf := [leafL_150_0,leafL_150_1,leafL_150_2,leafL_150_3,leafL_150_4,leafL_150_5,leafL_150_6,leafL_150_7]

theorem leavesL_150_valid : LeafListValid leavesL_150 := by
  intro x hx
  simp only [leavesL_150, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_150_0_valid
  · exact leafL_150_1_valid
  · exact leafL_150_2_valid
  · exact leafL_150_3_valid
  · exact leafL_150_4_valid
  · exact leafL_150_5_valid
  · exact leafL_150_6_valid
  · exact leafL_150_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
