import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_161_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,174}, reject := .fullRank { members := ![0,1,17,34,52,71,91,174], points := ![99,106,109,121,122,138], inverse := ![0,12,11,8,1,15,0,7,0,0,14,9,15,1,14,0,0,0,10,12,1,7,8,8,14,12,2,3,3,0,7,5,2,14,14,0] } }
theorem leafL_161_0_valid : (leafL_161_0).reject.ValidFor (leafL_161_0).leaf := by decide

noncomputable def leafL_161_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,176}, reject := .fullRank { members := ![0,1,17,34,52,71,91,176], points := ![99,104,120,127,138,150], inverse := ![0,14,6,11,12,14,7,8,13,15,12,1,7,4,12,7,10,2,15,1,9,2,11,14,11,13,13,8,7,4,7,11,10,0,14,8] } }
theorem leafL_161_1_valid : (leafL_161_1).reject.ValidFor (leafL_161_1).leaf := by decide

noncomputable def leafL_161_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,181}, reject := .fullRank { members := ![0,1,17,34,52,71,91,181], points := ![109,120,127,141,144,147], inverse := ![0,5,1,2,12,11,8,1,14,2,15,10,5,4,10,8,5,6,15,13,14,1,12,1,0,14,14,2,2,0,4,12,10,1,10,9] } }
theorem leafL_161_2_valid : (leafL_161_2).reject.ValidFor (leafL_161_2).leaf := by decide

noncomputable def leafL_161_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,182}, reject := .fullRank { members := ![0,1,17,34,52,71,91,182], points := ![99,104,106,121,122,138], inverse := ![11,11,7,8,1,15,0,0,7,0,14,9,1,14,15,0,0,0,11,1,13,7,8,8,12,2,14,3,3,0,5,2,7,14,14,0] } }
theorem leafL_161_3_valid : (leafL_161_3).reject.ValidFor (leafL_161_3).leaf := by decide

noncomputable def leafL_161_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,185}, reject := .fullRank { members := ![0,1,17,34,52,71,91,185], points := ![104,106,110,120,127,138], inverse := ![4,0,3,4,13,15,15,4,12,11,5,9,7,4,3,0,0,0,5,3,1,11,4,8,0,9,9,6,6,0,3,4,7,15,15,0] } }
theorem leafL_161_4_valid : (leafL_161_4).reject.ValidFor (leafL_161_4).leaf := by decide

noncomputable def leafL_161_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,186}, reject := .fullRank { members := ![0,1,17,34,52,71,91,186], points := ![99,104,121,127,141,144], inverse := ![15,8,6,15,6,9,2,5,0,14,7,14,2,2,6,6,10,10,0,7,10,5,8,0,5,5,9,9,0,0,10,10,10,10,10,10] } }
theorem leafL_161_5_valid : (leafL_161_5).reject.ValidFor (leafL_161_5).leaf := by decide

noncomputable def leafL_161_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,188}, reject := .fullRank { members := ![0,1,17,34,52,71,91,188], points := ![104,110,122,138,141,150], inverse := ![5,15,11,12,11,7,12,6,12,7,6,7,10,12,5,8,15,4,12,7,5,13,11,8,4,7,11,13,7,2,0,2,3,5,9,13] } }
theorem leafL_161_6_valid : (leafL_161_6).reject.ValidFor (leafL_161_6).leaf := by decide

noncomputable def leafL_161_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,191}, reject := .fullRank { members := ![0,1,17,34,52,71,91,191], points := ![99,106,110,120,121,138], inverse := ![5,2,0,8,1,15,8,10,5,9,7,9,14,12,2,0,0,0,14,14,7,12,3,8,6,8,14,11,11,0,9,0,9,9,9,0] } }
theorem leafL_161_7_valid : (leafL_161_7).reject.ValidFor (leafL_161_7).leaf := by decide

noncomputable def leavesL_161 : List RejectedLeaf := [leafL_161_0,leafL_161_1,leafL_161_2,leafL_161_3,leafL_161_4,leafL_161_5,leafL_161_6,leafL_161_7]

theorem leavesL_161_valid : LeafListValid leavesL_161 := by
  intro x hx
  simp only [leavesL_161, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_161_0_valid
  · exact leafL_161_1_valid
  · exact leafL_161_2_valid
  · exact leafL_161_3_valid
  · exact leafL_161_4_valid
  · exact leafL_161_5_valid
  · exact leafL_161_6_valid
  · exact leafL_161_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
