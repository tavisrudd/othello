import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_164_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,131}, reject := .fullRank { members := ![0,1,17,34,52,71,92,131], points := ![101,126,159,168,169,174], inverse := ![0,10,5,9,4,3,15,14,13,12,9,9,0,0,0,10,7,13,14,0,5,9,6,4,8,9,4,6,0,3,3,1,8,4,6,8] } }
theorem leafL_164_0_valid : (leafL_164_0).reject.ValidFor (leafL_164_0).leaf := by decide

noncomputable def leafL_164_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,139}, reject := .fullRank { members := ![0,1,17,34,52,71,92,139], points := ![101,104,126,154,158,159], inverse := ![7,11,14,11,13,5,8,5,1,10,13,11,0,0,0,8,10,2,7,13,13,6,7,6,2,2,0,11,1,10,13,13,0,0,13,13] } }
theorem leafL_164_1_valid : (leafL_164_1).reject.ValidFor (leafL_164_1).leaf := by decide

noncomputable def leafL_164_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,147}, reject := .fullRank { members := ![0,1,17,34,52,71,92,147], points := ![101,122,126,141,169,173], inverse := ![6,7,9,6,2,13,7,12,2,9,8,8,9,1,11,13,11,5,12,15,4,4,2,1,2,5,11,1,6,11,0,2,2,0,2,2] } }
theorem leafL_164_2_valid : (leafL_164_2).reject.ValidFor (leafL_164_2).leaf := by decide

noncomputable def leafL_164_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,154}, reject := .fullRank { members := ![0,1,17,34,52,71,92,154], points := ![99,104,126,127,133,139], inverse := ![0,7,8,1,10,5,12,11,2,12,9,0,12,12,14,14,11,11,9,14,4,11,14,6,13,13,4,4,3,3,3,3,4,4,5,5] } }
theorem leafL_164_3_valid : (leafL_164_3).reject.ValidFor (leafL_164_3).leaf := by decide

noncomputable def leafL_164_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,158}, reject := .fullRank { members := ![0,1,17,34,52,71,92,158], points := ![101,104,122,127,138,139], inverse := ![10,13,12,5,15,0,11,12,5,11,11,2,5,5,8,8,15,15,1,6,4,11,0,8,9,9,11,11,10,10,7,7,0,0,7,7] } }
theorem leafL_164_4_valid : (leafL_164_4).reject.ValidFor (leafL_164_4).leaf := by decide

noncomputable def leafL_164_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,159}, reject := .fullRank { members := ![0,1,17,34,52,71,92,159], points := ![104,109,122,131,133,139], inverse := ![12,11,9,7,5,13,14,9,14,9,7,7,0,0,0,11,9,2,2,5,15,14,2,4,4,4,0,2,11,9,11,11,0,9,4,13] } }
theorem leafL_164_5_valid : (leafL_164_5).reject.ValidFor (leafL_164_5).leaf := by decide

noncomputable def leafL_164_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,168}, reject := .fullRank { members := ![0,1,17,34,52,71,92,168], points := ![101,109,122,126,131,138], inverse := ![12,11,3,10,2,13,5,2,13,3,4,13,2,2,8,8,2,2,10,13,10,5,0,8,0,0,5,5,13,13,13,13,12,12,8,8] } }
theorem leafL_164_6_valid : (leafL_164_6).reject.ValidFor (leafL_164_6).leaf := by decide

noncomputable def leafL_164_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,173}, reject := .fullRank { members := ![0,1,17,34,52,71,92,173], points := ![104,122,126,127,139,147], inverse := ![9,12,7,11,13,5,15,5,5,2,12,1,0,8,10,2,0,0,14,4,2,13,11,14,14,11,1,3,2,5,12,0,14,4,14,8] } }
theorem leafL_164_7_valid : (leafL_164_7).reject.ValidFor (leafL_164_7).leaf := by decide

noncomputable def leavesL_164 : List RejectedLeaf := [leafL_164_0,leafL_164_1,leafL_164_2,leafL_164_3,leafL_164_4,leafL_164_5,leafL_164_6,leafL_164_7]

theorem leavesL_164_valid : LeafListValid leavesL_164 := by
  intro x hx
  simp only [leavesL_164, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_164_0_valid
  · exact leafL_164_1_valid
  · exact leafL_164_2_valid
  · exact leafL_164_3_valid
  · exact leafL_164_4_valid
  · exact leafL_164_5_valid
  · exact leafL_164_6_valid
  · exact leafL_164_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
