import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_193_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,174}, reject := .fullRank { members := ![0,1,17,34,52,71,121,174], points := ![91,93,101,131,138,144], inverse := ![7,14,14,14,15,7,10,4,9,1,10,12,0,0,0,7,8,15,2,13,8,11,11,7,2,2,0,1,0,1,12,12,0,0,12,12] } }
theorem leafL_193_0_valid : (leafL_193_0).reject.ValidFor (leafL_193_0).leaf := by decide

noncomputable def leafL_193_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,181}, reject := .fullRank { members := ![0,1,17,34,52,71,121,181], points := ![83,94,96,139,141,150], inverse := ![8,2,2,15,12,10,10,1,13,5,12,15,6,4,2,0,0,0,1,0,5,0,6,2,10,10,0,5,5,0,8,6,14,12,12,0] } }
theorem leafL_193_1_valid : (leafL_193_1).reject.ValidFor (leafL_193_1).leaf := by decide

noncomputable def leafL_193_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,182}, reject := .fullRank { members := ![0,1,17,34,52,71,121,182], points := ![91,93,96,101,104,131], inverse := ![1,0,8,8,6,6,2,0,12,8,1,7,4,12,8,0,0,0,13,7,5,4,12,7,12,4,8,13,13,0,0,14,14,14,14,0] } }
theorem leafL_193_2_valid : (leafL_193_2).reject.ValidFor (leafL_193_2).leaf := by decide

noncomputable def leafL_193_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,186}, reject := .fullRank { members := ![0,1,17,34,52,71,121,186], points := ![91,93,101,104,133,141], inverse := ![15,6,5,11,10,12,6,8,14,7,12,11,14,14,1,1,15,15,15,0,12,4,9,14,6,6,12,12,15,15,4,4,11,11,6,6] } }
theorem leafL_193_3_valid : (leafL_193_3).reject.ValidFor (leafL_193_3).leaf := by decide

noncomputable def leafL_193_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,191}, reject := .fullRank { members := ![0,1,17,34,52,71,121,191], points := ![91,94,101,106,131,133], inverse := ![2,11,9,7,14,8,13,3,5,12,7,0,1,1,1,1,3,3,12,3,14,6,15,8,4,4,10,10,8,8,12,12,14,14,13,13] } }
theorem leafL_193_4_valid : (leafL_193_4).reject.ValidFor (leafL_193_4).leaf := by decide

noncomputable def leafL_193_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,197}, reject := .fullRank { members := ![0,1,17,34,52,71,121,197], points := ![90,93,94,106,138,139], inverse := ![10,10,9,14,3,5,14,0,0,9,7,0,6,11,13,0,0,0,13,15,13,8,11,12,5,11,14,0,10,10,4,13,9,0,11,11] } }
theorem leafL_193_5_valid : (leafL_193_5).reject.ValidFor (leafL_193_5).leaf := by decide

noncomputable def leafL_193_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,207}, reject := .fullRank { members := ![0,1,17,34,52,71,121,207], points := ![83,90,91,101,139,141], inverse := ![14,8,15,14,15,9,14,15,15,9,5,2,6,3,5,0,0,0,9,4,2,8,0,7,4,6,2,0,5,5,10,14,4,0,12,12] } }
theorem leafL_193_6_valid : (leafL_193_6).reject.ValidFor (leafL_193_6).leaf := by decide

noncomputable def leafL_193_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,208}, reject := .fullRank { members := ![0,1,17,34,52,71,121,208], points := ![83,90,94,106,133,138], inverse := ![14,13,10,14,9,15,0,14,0,9,0,7,14,12,2,0,0,0,6,11,2,8,15,8,8,14,6,0,1,1,12,8,4,0,13,13] } }
theorem leafL_193_7_valid : (leafL_193_7).reject.ValidFor (leafL_193_7).leaf := by decide

noncomputable def leavesL_193 : List RejectedLeaf := [leafL_193_0,leafL_193_1,leafL_193_2,leafL_193_3,leafL_193_4,leafL_193_5,leafL_193_6,leafL_193_7]

theorem leavesL_193_valid : LeafListValid leavesL_193 := by
  intro x hx
  simp only [leavesL_193, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_193_0_valid
  · exact leafL_193_1_valid
  · exact leafL_193_2_valid
  · exact leafL_193_3_valid
  · exact leafL_193_4_valid
  · exact leafL_193_5_valid
  · exact leafL_193_6_valid
  · exact leafL_193_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
