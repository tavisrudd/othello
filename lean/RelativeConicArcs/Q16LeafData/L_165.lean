import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_165_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,182}, reject := .fullRank { members := ![0,1,17,34,52,71,92,182], points := ![99,101,104,126,127,131], inverse := ![12,3,8,0,9,15,5,6,4,13,3,9,4,12,8,0,0,0,3,9,13,12,3,8,12,8,4,1,1,0,0,11,11,11,11,0] } }
theorem leafL_165_0_valid : (leafL_165_0).reject.ValidFor (leafL_165_0).leaf := by decide

noncomputable def leafL_165_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,185}, reject := .fullRank { members := ![0,1,17,34,52,71,92,185], points := ![104,109,126,127,131,138], inverse := ![6,1,11,2,4,11,9,14,13,3,9,0,3,3,5,5,5,5,7,0,7,8,3,11,10,10,1,1,0,0,11,11,0,0,11,11] } }
theorem leafL_165_1_valid : (leafL_165_1).reject.ValidFor (leafL_165_1).leaf := by decide

noncomputable def leafL_165_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,207}, reject := .fullRank { members := ![0,1,17,34,52,71,92,207], points := ![99,101,109,122,126,141], inverse := ![6,14,15,10,3,15,8,14,1,10,4,9,9,11,2,0,0,0,8,7,8,6,9,8,14,14,0,4,4,0,2,15,13,10,10,0] } }
theorem leafL_165_2_valid : (leafL_165_2).reject.ValidFor (leafL_165_2).leaf := by decide

noncomputable def leafL_165_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,213}, reject := .fullRank { members := ![0,1,17,34,52,71,92,213], points := ![99,104,126,127,131,138], inverse := ![6,1,15,6,0,15,2,5,0,14,4,13,10,10,9,9,9,9,0,7,7,8,3,11,9,9,15,15,14,14,15,15,10,10,1,1] } }
theorem leafL_165_3_valid : (leafL_165_3).reject.ValidFor (leafL_165_3).leaf := by decide

noncomputable def leafL_165_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,214}, reject := .fullRank { members := ![0,1,17,34,52,71,92,214], points := ![99,101,109,122,127,131], inverse := ![1,4,2,0,9,15,2,2,7,11,5,9,9,11,2,0,0,0,8,12,3,1,14,8,5,15,10,10,10,0,11,4,15,2,2,0] } }
theorem leafL_165_4_valid : (leafL_165_4).reject.ValidFor (leafL_165_4).leaf := by decide

noncomputable def leafL_165_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,237}, reject := .fullRank { members := ![0,1,17,34,52,71,92,237], points := ![104,122,127,131,133,138], inverse := ![7,15,6,1,9,7,7,1,15,14,9,14,0,0,0,8,15,7,7,3,12,0,13,5,0,1,1,9,14,7,0,6,6,15,8,7] } }
theorem leafL_165_5_valid : (leafL_165_5).reject.ValidFor (leafL_165_5).leaf := by decide

noncomputable def leafL_165_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,249}, reject := .fullRank { members := ![0,1,17,34,52,71,92,249], points := ![101,104,122,126,141,147], inverse := ![4,4,3,7,14,11,14,0,2,8,10,14,14,2,7,13,14,8,5,10,13,14,13,1,9,8,7,15,6,15,15,0,8,9,4,10] } }
theorem leafL_165_6_valid : (leafL_165_6).reject.ValidFor (leafL_165_6).leaf := by decide

noncomputable def leafL_165_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,259}, reject := .fullRank { members := ![0,1,17,34,52,71,92,259], points := ![104,126,139,154,168,171], inverse := ![5,2,11,5,15,7,6,13,4,4,4,15,10,1,7,2,14,0,0,13,6,4,2,13,7,12,0,10,10,11,11,2,10,6,8,13] } }
theorem leafL_165_7_valid : (leafL_165_7).reject.ValidFor (leafL_165_7).leaf := by decide

noncomputable def leavesL_165 : List RejectedLeaf := [leafL_165_0,leafL_165_1,leafL_165_2,leafL_165_3,leafL_165_4,leafL_165_5,leafL_165_6,leafL_165_7]

theorem leavesL_165_valid : LeafListValid leavesL_165 := by
  intro x hx
  simp only [leavesL_165, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_165_0_valid
  · exact leafL_165_1_valid
  · exact leafL_165_2_valid
  · exact leafL_165_3_valid
  · exact leafL_165_4_valid
  · exact leafL_165_5_valid
  · exact leafL_165_6_valid
  · exact leafL_165_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
