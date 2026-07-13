import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_007_0 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,181}, reject := .fullRank { members := ![0,1,17,34,52,67,91,181], points := ![110,127,141,143,144,158], inverse := ![11,3,11,4,14,8,2,0,4,4,4,6,0,0,7,9,14,0,1,10,5,15,5,4,8,12,14,13,6,1,5,14,3,13,3,6] } }
theorem leafL_007_0_valid : (leafL_007_0).reject.ValidFor (leafL_007_0).leaf := by decide

noncomputable def leafL_007_1 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,182}, reject := .fullRank { members := ![0,1,17,34,52,67,91,182], points := ![106,110,121,122,137,138], inverse := ![12,11,13,4,14,1,7,0,0,14,0,9,6,6,5,5,14,14,7,0,9,6,9,1,6,6,2,2,8,8,0,0,1,1,1,1] } }
theorem leafL_007_1_valid : (leafL_007_1).reject.ValidFor (leafL_007_1).leaf := by decide

noncomputable def leafL_007_2 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,185}, reject := .fullRank { members := ![0,1,17,34,52,67,91,185], points := ![106,110,127,138,144,168], inverse := ![14,10,0,10,13,2,15,8,14,10,3,0,15,11,15,3,1,9,4,1,1,3,10,13,4,0,15,7,5,9,0,4,15,9,11,9] } }
theorem leafL_007_2_valid : (leafL_007_2).reject.ValidFor (leafL_007_2).leaf := by decide

noncomputable def leafL_007_3 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,198}, reject := .fullRank { members := ![0,1,17,34,52,67,91,198], points := ![106,109,127,144,149,158], inverse := ![11,15,2,5,8,10,5,3,6,15,6,9,1,4,14,13,3,5,2,8,13,0,8,15,8,0,12,5,7,6,15,13,3,12,7,10] } }
theorem leafL_007_3_valid : (leafL_007_3).reject.ValidFor (leafL_007_3).leaf := by decide

noncomputable def leafL_007_4 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,201}, reject := .fullRank { members := ![0,1,17,34,52,67,91,201], points := ![110,122,127,138,143,149], inverse := ![9,7,7,11,6,5,4,0,5,15,12,2,8,3,15,5,0,1,4,2,6,13,15,2,13,8,10,15,7,7,0,6,6,6,6,0] } }
theorem leafL_007_4_valid : (leafL_007_4).reject.ValidFor (leafL_007_4).leaf := by decide

noncomputable def leafL_007_5 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,220}, reject := .fullRank { members := ![0,1,17,34,52,67,91,220], points := ![110,121,127,138,141,144], inverse := ![7,5,12,10,4,1,7,7,9,3,8,2,0,0,0,4,8,12,7,11,4,7,5,10,0,6,6,10,5,15,0,7,7,7,0,7] } }
theorem leafL_007_5_valid : (leafL_007_5).reject.ValidFor (leafL_007_5).leaf := by decide

noncomputable def leafL_007_6 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,224}, reject := .fullRank { members := ![0,1,17,34,52,67,91,224], points := ![108,110,122,137,141,143], inverse := ![3,4,9,8,1,6,11,12,14,11,11,9,0,0,0,5,15,10,14,9,15,0,0,8,3,3,0,9,4,13,10,10,0,10,0,10] } }
theorem leafL_007_6_valid : (leafL_007_6).reject.ValidFor (leafL_007_6).leaf := by decide

noncomputable def leafL_007_7 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,229}, reject := .fullRank { members := ![0,1,17,34,52,67,91,229], points := ![106,109,110,121,122,143], inverse := ![8,0,15,11,2,15,4,10,9,12,2,9,6,11,13,0,0,0,2,10,15,0,15,8,6,9,15,3,3,0,0,14,14,14,14,0] } }
theorem leafL_007_7_valid : (leafL_007_7).reject.ValidFor (leafL_007_7).leaf := by decide

noncomputable def leavesL_007 : List RejectedLeaf := [leafL_007_0,leafL_007_1,leafL_007_2,leafL_007_3,leafL_007_4,leafL_007_5,leafL_007_6,leafL_007_7]

theorem leavesL_007_valid : LeafListValid leavesL_007 := by
  intro x hx
  simp only [leavesL_007, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_007_0_valid
  · exact leafL_007_1_valid
  · exact leafL_007_2_valid
  · exact leafL_007_3_valid
  · exact leafL_007_4_valid
  · exact leafL_007_5_valid
  · exact leafL_007_6_valid
  · exact leafL_007_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
