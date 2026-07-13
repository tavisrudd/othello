import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_225_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,172,271}, reject := .fullRank { members := ![0,1,17,34,52,71,172,271], points := ![91,93,104,110,121,133], inverse := ![11,8,7,3,10,12,7,5,14,11,12,11,10,14,10,14,4,4,11,11,3,4,15,8,5,9,8,4,12,12,6,3,13,8,5,5] } }
theorem leafL_225_0_valid : (leafL_225_0).reject.ValidFor (leafL_225_0).leaf := by decide

noncomputable def leafL_225_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,173,181}, reject := .fullRank { members := ![0,1,17,34,52,71,173,181], points := ![83,94,96,124,127,138], inverse := ![11,14,2,6,8,8,10,5,8,2,11,14,6,4,2,0,0,0,5,0,2,0,8,15,14,13,3,5,5,0,9,3,10,12,12,0] } }
theorem leafL_225_1_valid : (leafL_225_1).reject.ValidFor (leafL_225_1).leaf := by decide

noncomputable def leafL_225_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,173,186}, reject := .fullRank { members := ![0,1,17,34,52,71,173,186], points := ![96,101,104,124,140,144], inverse := ![0,0,7,9,0,15,9,12,2,7,13,13,2,12,14,2,3,1,13,3,9,2,9,12,14,4,10,14,15,1,7,6,1,7,2,5] } }
theorem leafL_225_2_valid : (leafL_225_2).reject.ValidFor (leafL_225_2).leaf := by decide

noncomputable def leafL_225_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,173,188}, reject := .fullRank { members := ![0,1,17,34,52,71,173,188], points := ![83,94,104,106,110,122], inverse := ![3,12,3,15,4,6,3,10,8,9,15,7,0,0,7,4,3,0,1,9,9,12,10,7,14,14,8,6,14,0,8,8,4,7,3,0] } }
theorem leafL_225_3_valid : (leafL_225_3).reject.ValidFor (leafL_225_3).leaf := by decide

noncomputable def leafL_225_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,173,197}, reject := .fullRank { members := ![0,1,17,34,52,71,173,197], points := ![83,92,104,110,122,126], inverse := ![5,10,7,15,13,11,15,6,2,12,11,12,13,13,1,1,12,12,10,2,1,14,11,12,6,6,0,0,9,9,6,6,15,15,7,7] } }
theorem leafL_225_4_valid : (leafL_225_4).reject.ValidFor (leafL_225_4).leaf := by decide

noncomputable def leafL_225_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,173,216}, reject := .fullRank { members := ![0,1,17,34,52,71,173,216], points := ![83,96,101,106,110,122], inverse := ![9,6,4,8,4,6,12,5,9,0,7,7,0,0,8,1,9,0,5,13,10,12,9,7,7,7,1,14,15,0,4,4,4,4,0,0] } }
theorem leafL_225_5_valid : (leafL_225_5).reject.ValidFor (leafL_225_5).leaf := by decide

noncomputable def leafL_225_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,173,223}, reject := .fullRank { members := ![0,1,17,34,52,71,173,223], points := ![83,94,96,101,104,122], inverse := ![12,6,5,8,0,6,9,6,6,8,6,7,6,4,2,0,0,0,12,14,10,4,11,7,7,0,7,13,13,0,6,13,11,14,14,0] } }
theorem leafL_225_6_valid : (leafL_225_6).reject.ValidFor (leafL_225_6).leaf := by decide

noncomputable def leafL_225_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,173,239}, reject := .fullRank { members := ![0,1,17,34,52,71,173,239], points := ![92,94,104,122,126,139], inverse := ![8,7,8,5,3,0,5,11,9,10,10,7,7,12,11,5,14,11,4,4,7,12,3,8,7,2,5,3,6,5,13,6,11,10,1,11] } }
theorem leafL_225_7_valid : (leafL_225_7).reject.ValidFor (leafL_225_7).leaf := by decide

noncomputable def leavesL_225 : List RejectedLeaf := [leafL_225_0,leafL_225_1,leafL_225_2,leafL_225_3,leafL_225_4,leafL_225_5,leafL_225_6,leafL_225_7]

theorem leavesL_225_valid : LeafListValid leavesL_225 := by
  intro x hx
  simp only [leavesL_225, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_225_0_valid
  · exact leafL_225_1_valid
  · exact leafL_225_2_valid
  · exact leafL_225_3_valid
  · exact leafL_225_4_valid
  · exact leafL_225_5_valid
  · exact leafL_225_6_valid
  · exact leafL_225_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
