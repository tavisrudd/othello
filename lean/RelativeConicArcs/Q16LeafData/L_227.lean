import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_227_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,174,233}, reject := .fullRank { members := ![0,1,17,34,52,71,174,233], points := ![91,93,101,106,109,124], inverse := ![3,12,13,1,4,6,3,10,9,7,0,7,0,0,9,10,3,0,1,9,3,9,5,7,8,8,5,2,7,0,7,7,8,6,14,0] } }
theorem leafL_227_0_valid : (leafL_227_0).reject.ValidFor (leafL_227_0).leaf := by decide

noncomputable def leafL_227_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,174,235}, reject := .fullRank { members := ![0,1,17,34,52,71,174,235], points := ![93,99,120,121,122,131], inverse := ![10,13,10,12,5,5,0,7,3,9,4,9,0,0,11,8,3,0,3,4,10,10,12,11,5,5,12,7,14,5,8,8,6,12,2,8] } }
theorem leafL_227_1_valid : (leafL_227_1).reject.ValidFor (leafL_227_1).leaf := by decide

noncomputable def leafL_227_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,174,243}, reject := .fullRank { members := ![0,1,17,34,52,71,174,243], points := ![101,106,121,124,127,138], inverse := ![4,3,6,1,14,15,0,7,13,10,9,9,0,0,12,8,4,0,15,8,10,1,4,8,8,8,14,11,5,0,13,13,6,12,10,0] } }
theorem leafL_227_2_valid : (leafL_227_2).reject.ValidFor (leafL_227_2).leaf := by decide

noncomputable def leafL_227_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,174,246}, reject := .fullRank { members := ![0,1,17,34,52,71,174,246], points := ![91,92,99,109,120,121], inverse := ![1,14,9,1,15,9,0,9,7,9,4,3,1,1,2,2,9,9,2,10,1,14,9,14,13,13,15,15,4,4,14,14,14,14,14,14] } }
theorem leafL_227_3_valid : (leafL_227_3).reject.ValidFor (leafL_227_3).leaf := by decide

noncomputable def leafL_227_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,174,253}, reject := .fullRank { members := ![0,1,17,34,52,71,174,253], points := ![99,120,121,124,131,138], inverse := ![7,2,9,2,6,9,7,2,4,8,9,0,0,15,9,6,0,0,7,6,15,6,2,10,0,4,15,11,13,13,0,1,10,11,5,5] } }
theorem leafL_227_4_valid : (leafL_227_4).reject.ValidFor (leafL_227_4).leaf := by decide

noncomputable def leafL_227_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,174,259}, reject := .fullRank { members := ![0,1,17,34,52,71,174,259], points := ![106,120,121,124,144,154], inverse := ![6,1,13,13,9,15,13,13,14,2,0,12,0,15,9,6,0,0,9,11,9,4,10,5,7,11,1,7,1,11,6,10,6,9,7,4] } }
theorem leafL_227_5_valid : (leafL_227_5).reject.ValidFor (leafL_227_5).leaf := by decide

noncomputable def leafL_227_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,174,267}, reject := .fullRank { members := ![0,1,17,34,52,71,174,267], points := ![92,93,99,101,106,120], inverse := ![15,0,11,9,10,6,14,7,8,5,3,7,0,0,8,15,7,0,0,8,9,13,11,7,13,13,4,13,9,0,6,6,15,8,7,0] } }
theorem leafL_227_6_valid : (leafL_227_6).reject.ValidFor (leafL_227_6).leaf := by decide

noncomputable def leafL_227_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,176,181}, reject := .fullRank { members := ![0,1,17,34,52,71,176,181], points := ![83,91,120,138,139,140], inverse := ![11,12,14,10,8,10,6,1,9,9,5,2,0,0,0,7,14,9,14,9,8,1,6,8,8,8,0,6,1,7,5,5,0,6,2,4] } }
theorem leafL_227_7_valid : (leafL_227_7).reject.ValidFor (leafL_227_7).leaf := by decide

noncomputable def leavesL_227 : List RejectedLeaf := [leafL_227_0,leafL_227_1,leafL_227_2,leafL_227_3,leafL_227_4,leafL_227_5,leafL_227_6,leafL_227_7]

theorem leavesL_227_valid : LeafListValid leavesL_227 := by
  intro x hx
  simp only [leavesL_227, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_227_0_valid
  · exact leafL_227_1_valid
  · exact leafL_227_2_valid
  · exact leafL_227_3_valid
  · exact leafL_227_4_valid
  · exact leafL_227_5_valid
  · exact leafL_227_6_valid
  · exact leafL_227_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
