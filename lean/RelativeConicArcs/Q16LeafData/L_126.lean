import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_126_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,172}, reject := .fullRank { members := ![0,1,17,34,52,70,90,172], points := ![109,110,125,133,139,147], inverse := ![0,4,2,13,8,2,9,9,3,12,4,11,3,11,12,11,14,1,12,4,14,7,11,10,12,15,11,11,1,2,8,1,4,0,3,14] } }
theorem leafL_126_0_valid : (leafL_126_0).reject.ValidFor (leafL_126_0).leaf := by decide

noncomputable def leafL_126_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,176}, reject := .fullRank { members := ![0,1,17,34,52,70,90,176], points := ![101,108,110,115,124,131], inverse := ![0,11,12,5,12,15,7,7,7,14,0,9,3,13,14,0,0,0,10,7,10,2,13,8,12,15,3,6,6,0,15,0,15,15,15,0] } }
theorem leafL_126_1_valid : (leafL_126_1).reject.ValidFor (leafL_126_1).leaf := by decide

noncomputable def leafL_126_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,184}, reject := .fullRank { members := ![0,1,17,34,52,70,90,184], points := ![101,108,109,126,127,131], inverse := ![3,10,14,0,9,15,15,8,0,13,3,9,1,5,4,0,0,0,14,9,0,12,3,8,11,13,6,1,1,0,13,14,3,11,11,0] } }
theorem leafL_126_2_valid : (leafL_126_2).reject.ValidFor (leafL_126_2).leaf := by decide

noncomputable def leafL_126_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,188}, reject := .fullRank { members := ![0,1,17,34,52,70,90,188], points := ![110,115,125,126,131,133], inverse := ![7,9,11,11,1,14,7,4,9,3,5,12,0,11,3,8,0,0,7,13,10,8,10,2,0,0,7,7,1,1,0,4,8,12,7,7] } }
theorem leafL_126_3_valid : (leafL_126_3).reject.ValidFor (leafL_126_3).leaf := by decide

noncomputable def leafL_126_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,191}, reject := .fullRank { members := ![0,1,17,34,52,70,90,191], points := ![101,108,109,115,126,133], inverse := ![9,6,8,8,1,15,6,5,4,13,3,9,1,5,4,0,0,0,7,8,8,11,4,8,12,5,9,11,11,0,9,9,0,9,9,0] } }
theorem leafL_126_4_valid : (leafL_126_4).reject.ValidFor (leafL_126_4).leaf := by decide

noncomputable def leafL_126_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,201}, reject := .fullRank { members := ![0,1,17,34,52,70,90,201], points := ![109,110,124,125,127,133], inverse := ![2,5,15,14,8,15,10,13,12,14,12,9,0,0,15,3,12,0,7,0,15,10,10,8,2,2,9,4,13,0,14,14,15,4,11,0] } }
theorem leafL_126_5_valid : (leafL_126_5).reject.ValidFor (leafL_126_5).leaf := by decide

noncomputable def leafL_126_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,203}, reject := .fullRank { members := ![0,1,17,34,52,70,90,203], points := ![108,110,115,126,127,131], inverse := ![11,12,7,15,1,15,4,3,6,6,14,9,0,0,15,9,6,0,15,8,3,0,12,8,14,14,14,12,2,0,12,12,2,3,1,0] } }
theorem leafL_126_6_valid : (leafL_126_6).reject.ValidFor (leafL_126_6).leaf := by decide

noncomputable def leafL_126_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,220}, reject := .fullRank { members := ![0,1,17,34,52,70,90,220], points := ![110,115,133,135,139,147], inverse := ![13,6,8,5,11,12,0,3,14,3,5,11,0,0,8,5,13,0,8,14,2,14,0,10,15,1,15,15,4,10,4,6,13,14,8,9] } }
theorem leafL_126_7_valid : (leafL_126_7).reject.ValidFor (leafL_126_7).leaf := by decide

noncomputable def leavesL_126 : List RejectedLeaf := [leafL_126_0,leafL_126_1,leafL_126_2,leafL_126_3,leafL_126_4,leafL_126_5,leafL_126_6,leafL_126_7]

theorem leavesL_126_valid : LeafListValid leavesL_126 := by
  intro x hx
  simp only [leavesL_126, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_126_0_valid
  · exact leafL_126_1_valid
  · exact leafL_126_2_valid
  · exact leafL_126_3_valid
  · exact leafL_126_4_valid
  · exact leafL_126_5_valid
  · exact leafL_126_6_valid
  · exact leafL_126_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
