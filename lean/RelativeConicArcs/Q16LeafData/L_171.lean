import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_171_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,173}, reject := .fullRank { members := ![0,1,17,34,52,71,94,173], points := ![101,104,122,124,127,140], inverse := ![12,11,11,11,9,15,15,8,4,13,7,9,0,0,3,12,15,0,6,1,11,2,6,8,15,15,8,8,0,0,11,11,6,3,5,0] } }
theorem leafL_171_0_valid : (leafL_171_0).reject.ValidFor (leafL_171_0).leaf := by decide

noncomputable def leafL_171_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,176}, reject := .fullRank { members := ![0,1,17,34,52,71,94,176], points := ![101,104,120,131,133,140], inverse := ![1,6,9,14,7,6,0,7,14,6,14,1,0,0,0,14,13,3,6,1,15,4,3,15,6,6,0,11,13,6,7,7,0,2,12,14] } }
theorem leafL_171_1_valid : (leafL_171_1).reject.ValidFor (leafL_171_1).leaf := by decide

noncomputable def leafL_171_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,191}, reject := .fullRank { members := ![0,1,17,34,52,71,94,191], points := ![101,106,121,128,133,155], inverse := ![6,5,14,1,4,9,10,11,12,7,14,4,3,13,6,15,2,5,1,2,12,5,3,9,8,8,10,10,0,0,7,5,5,6,12,13] } }
theorem leafL_171_2_valid : (leafL_171_2).reject.ValidFor (leafL_171_2).leaf := by decide

noncomputable def leafL_171_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,205}, reject := .fullRank { members := ![0,1,17,34,52,71,94,205], points := ![101,104,106,120,122,131], inverse := ![12,5,14,13,4,15,15,5,13,11,5,9,13,1,12,0,0,0,2,6,3,7,8,8,10,8,2,5,5,0,0,1,1,1,1,0] } }
theorem leafL_171_3_valid : (leafL_171_3).reject.ValidFor (leafL_171_3).leaf := by decide

noncomputable def leafL_171_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,207}, reject := .fullRank { members := ![0,1,17,34,52,71,94,207], points := ![101,109,120,122,124,140], inverse := ![2,5,3,13,7,15,4,3,1,6,9,9,0,0,13,8,5,0,5,2,6,3,10,8,13,13,12,6,10,0,5,5,8,2,10,0] } }
theorem leafL_171_4_valid : (leafL_171_4).reject.ValidFor (leafL_171_4).leaf := by decide

noncomputable def leafL_171_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,217}, reject := .fullRank { members := ![0,1,17,34,52,71,94,217], points := ![101,104,109,120,122,131], inverse := ![9,9,7,13,4,15,8,0,15,11,5,9,5,3,6,0,0,0,0,15,8,7,8,8,7,6,1,5,5,0,15,6,9,1,1,0] } }
theorem leafL_171_5_valid : (leafL_171_5).reject.ValidFor (leafL_171_5).leaf := by decide

noncomputable def leafL_171_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,223}, reject := .fullRank { members := ![0,1,17,34,52,71,94,223], points := ![101,104,106,121,155,169], inverse := ![14,11,2,6,15,15,1,14,9,9,0,15,13,1,12,0,0,0,4,15,9,4,3,5,5,4,6,12,10,1,3,12,11,13,2,11] } }
theorem leafL_171_6_valid : (leafL_171_6).reject.ValidFor (leafL_171_6).leaf := by decide

noncomputable def leafL_171_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,229}, reject := .fullRank { members := ![0,1,17,34,52,71,94,229], points := ![104,106,120,121,122,131], inverse := ![0,7,12,14,11,15,12,11,7,4,13,9,0,0,11,8,3,0,14,9,0,12,3,8,6,6,13,9,4,0,1,1,1,0,1,0] } }
theorem leafL_171_7_valid : (leafL_171_7).reject.ValidFor (leafL_171_7).leaf := by decide

noncomputable def leavesL_171 : List RejectedLeaf := [leafL_171_0,leafL_171_1,leafL_171_2,leafL_171_3,leafL_171_4,leafL_171_5,leafL_171_6,leafL_171_7]

theorem leavesL_171_valid : LeafListValid leavesL_171 := by
  intro x hx
  simp only [leavesL_171, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_171_0_valid
  · exact leafL_171_1_valid
  · exact leafL_171_2_valid
  · exact leafL_171_3_valid
  · exact leafL_171_4_valid
  · exact leafL_171_5_valid
  · exact leafL_171_6_valid
  · exact leafL_171_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
