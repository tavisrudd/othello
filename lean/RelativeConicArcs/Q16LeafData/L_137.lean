import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_137_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,133}, reject := .fullRank { members := ![0,1,17,34,52,70,95,133], points := ![103,107,120,124,126,147], inverse := ![6,10,3,12,1,3,7,10,6,1,6,12,0,0,1,3,2,0,0,10,15,15,13,7,7,7,1,10,11,0,6,6,6,6,0,0] } }
theorem leafL_137_0_valid : (leafL_137_0).reject.ValidFor (leafL_137_0).leaf := by decide

noncomputable def leafL_137_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,135}, reject := .fullRank { members := ![0,1,17,34,52,70,95,135], points := ![109,124,125,126,149,168], inverse := ![11,3,11,10,9,1,10,9,0,4,6,1,0,1,6,7,0,0,13,3,2,0,13,1,7,13,1,0,10,1,6,2,1,1,3,7] } }
theorem leafL_137_1_valid : (leafL_137_1).reject.ValidFor (leafL_137_1).leaf := by decide

noncomputable def leafL_137_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,137}, reject := .fullRank { members := ![0,1,17,34,52,70,95,137], points := ![103,107,120,124,125,147], inverse := ![6,10,8,9,15,3,7,10,9,12,4,12,0,0,4,9,13,0,0,10,9,3,7,7,7,7,8,11,3,0,6,6,6,6,0,0] } }
theorem leafL_137_2_valid : (leafL_137_2).reject.ValidFor (leafL_137_2).leaf := by decide

noncomputable def leafL_137_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,147}, reject := .fullRank { members := ![0,1,17,34,52,70,95,147], points := ![103,104,120,126,133,137], inverse := ![14,9,15,6,8,7,1,6,5,11,11,2,1,1,11,11,13,13,2,5,8,7,0,8,13,13,4,4,7,7,6,6,3,3,2,2] } }
theorem leafL_137_3_valid : (leafL_137_3).reject.ValidFor (leafL_137_3).leaf := by decide

noncomputable def leafL_137_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,149}, reject := .fullRank { members := ![0,1,17,34,52,70,95,149], points := ![104,107,109,125,135,144], inverse := ![7,8,8,9,13,2,11,10,6,14,3,10,7,15,8,0,0,0,1,5,3,15,9,1,8,5,13,0,5,5,12,15,3,0,1,1] } }
theorem leafL_137_4_valid : (leafL_137_4).reject.ValidFor (leafL_137_4).leaf := by decide

noncomputable def leafL_137_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,168}, reject := .fullRank { members := ![0,1,17,34,52,70,95,168], points := ![103,124,126,131,133,135], inverse := ![7,5,12,9,11,13,7,13,3,10,7,4,0,0,0,5,10,15,7,8,7,6,15,1,0,6,6,12,8,4,0,7,7,7,7,0] } }
theorem leafL_137_5_valid : (leafL_137_5).reject.ValidFor (leafL_137_5).leaf := by decide

noncomputable def leafL_137_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,172}, reject := .fullRank { members := ![0,1,17,34,52,70,95,172], points := ![103,104,107,120,125,131], inverse := ![6,15,14,5,12,15,11,0,12,1,15,9,10,4,14,0,0,0,8,6,9,4,11,8,3,7,4,15,15,0,7,5,2,3,3,0] } }
theorem leafL_137_6_valid : (leafL_137_6).reject.ValidFor (leafL_137_6).leaf := by decide

noncomputable def leafL_137_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,174}, reject := .fullRank { members := ![0,1,17,34,52,70,95,174], points := ![103,115,120,124,131,135], inverse := ![7,1,3,11,5,10,7,4,15,5,0,9,0,5,2,7,0,0,7,10,14,11,8,0,0,11,2,9,8,8,0,14,9,7,13,13] } }
theorem leafL_137_7_valid : (leafL_137_7).reject.ValidFor (leafL_137_7).leaf := by decide

noncomputable def leavesL_137 : List RejectedLeaf := [leafL_137_0,leafL_137_1,leafL_137_2,leafL_137_3,leafL_137_4,leafL_137_5,leafL_137_6,leafL_137_7]

theorem leavesL_137_valid : LeafListValid leavesL_137 := by
  intro x hx
  simp only [leavesL_137, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_137_0_valid
  · exact leafL_137_1_valid
  · exact leafL_137_2_valid
  · exact leafL_137_3_valid
  · exact leafL_137_4_valid
  · exact leafL_137_5_valid
  · exact leafL_137_6_valid
  · exact leafL_137_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
