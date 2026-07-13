import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_324_0 : RejectedLeaf := { leaf := {0,1,17,34,52,80,107,239}, reject := .fullRank { members := ![0,1,17,34,52,80,107,239], points := ![86,92,117,122,131,133], inverse := ![14,9,7,9,4,12,2,5,12,5,13,3,9,9,2,2,12,12,7,0,9,1,3,12,1,1,11,11,10,10,12,12,1,1,10,10] } }
theorem leafL_324_0_valid : (leafL_324_0).reject.ValidFor (leafL_324_0).leaf := by decide

noncomputable def leafL_324_1 : RejectedLeaf := { leaf := {0,1,17,34,52,80,110,184}, reject := .fullRank { members := ![0,1,17,34,52,80,110,184], points := ![86,91,93,115,122,133], inverse := ![8,8,7,10,4,8,1,15,9,6,15,14,3,13,14,0,0,0,2,12,9,0,8,15,2,14,12,10,10,0,2,13,15,11,11,0] } }
theorem leafL_324_1_valid : (leafL_324_1).reject.ValidFor (leafL_324_1).leaf := by decide

noncomputable def leafL_324_2 : RejectedLeaf := { leaf := {0,1,17,34,52,80,125,188}, reject := .fullRank { members := ![0,1,17,34,52,80,125,188], points := ![95,103,149,151,155,163], inverse := ![1,12,9,2,0,7,1,15,4,9,8,11,0,0,8,5,13,0,7,9,1,11,8,12,11,11,10,3,2,11,3,3,0,0,3,3] } }
theorem leafL_324_2_valid : (leafL_324_2).reject.ValidFor (leafL_324_2).leaf := by decide

noncomputable def leafL_324_3 : RejectedLeaf := { leaf := {0,1,17,34,52,80,154,184}, reject := .fullRank { members := ![0,1,17,34,52,80,154,184], points := ![83,93,103,108,124,127], inverse := ![13,2,14,6,6,0,5,12,13,3,3,4,7,7,6,6,10,10,13,5,12,3,13,10,1,1,15,15,7,7,10,10,14,14,13,13] } }
theorem leafL_324_3_valid : (leafL_324_3).reject.ValidFor (leafL_324_3).leaf := by decide

noncomputable def leafL_324_4 : RejectedLeaf := { leaf := {0,1,17,34,52,80,191,229}, reject := .fullRank { members := ![0,1,17,34,52,80,191,229], points := ![86,89,91,106,108,122], inverse := ![2,2,15,9,1,6,5,7,11,14,0,7,6,2,4,0,0,0,15,4,3,2,13,7,12,15,3,2,2,0,0,9,9,9,9,0] } }
theorem leafL_324_4_valid : (leafL_324_4).reject.ValidFor (leafL_324_4).leaf := by decide

noncomputable def leafL_324_5 : RejectedLeaf := { leaf := {0,1,17,34,52,80,203,243}, reject := .fullRank { members := ![0,1,17,34,52,80,203,243], points := ![93,109,121,122,125,152], inverse := ![13,4,2,1,14,5,9,14,0,0,7,0,0,0,13,11,6,0,6,13,3,9,9,8,7,1,4,7,1,4,6,7,13,5,6,15] } }
theorem leafL_324_5_valid : (leafL_324_5).reject.ValidFor (leafL_324_5).leaf := by decide

noncomputable def leafL_324_6 : RejectedLeaf := { leaf := {0,1,17,34,52,91,101,158}, reject := .fullRank { members := ![0,1,17,34,52,91,101,158], points := ![70,80,121,127,137,138], inverse := ![11,13,11,7,1,10,8,14,14,5,14,3,3,3,7,7,12,12,12,10,7,13,4,8,9,9,0,0,4,4,9,9,1,1,3,3] } }
theorem leafL_324_6_valid : (leafL_324_6).reject.ValidFor (leafL_324_6).leaf := by decide

noncomputable def leafL_324_7 : RejectedLeaf := { leaf := {0,1,17,34,52,91,101,168}, reject := .fullRank { members := ![0,1,17,34,52,91,101,168], points := ![70,73,80,137,143,147], inverse := ![11,14,6,7,2,7,6,9,3,4,6,14,5,11,14,0,0,0,1,6,15,0,5,13,15,3,12,15,15,0,12,14,2,5,5,0] } }
theorem leafL_324_7_valid : (leafL_324_7).reject.ValidFor (leafL_324_7).leaf := by decide

noncomputable def leavesL_324 : List RejectedLeaf := [leafL_324_0,leafL_324_1,leafL_324_2,leafL_324_3,leafL_324_4,leafL_324_5,leafL_324_6,leafL_324_7]

theorem leavesL_324_valid : LeafListValid leavesL_324 := by
  intro x hx
  simp only [leavesL_324, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_324_0_valid
  · exact leafL_324_1_valid
  · exact leafL_324_2_valid
  · exact leafL_324_3_valid
  · exact leafL_324_4_valid
  · exact leafL_324_5_valid
  · exact leafL_324_6_valid
  · exact leafL_324_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
