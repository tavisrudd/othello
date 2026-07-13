import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_173_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,96,120}, reject := .fullRank { members := ![0,1,17,34,52,71,96,120], points := ![99,131,140,147,159,166], inverse := ![15,1,14,15,11,5,2,4,0,6,0,0,10,8,14,2,1,15,1,6,3,12,2,10,4,5,8,1,14,6,6,10,8,0,1,5] } }
theorem leafL_173_0_valid : (leafL_173_0).reject.ValidFor (leafL_173_0).leaf := by decide

noncomputable def leafL_173_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,96,121}, reject := .fullRank { members := ![0,1,17,34,52,71,96,121], points := ![101,106,141,156,166,168], inverse := ![14,4,12,12,13,6,8,13,8,0,3,14,13,11,2,1,11,14,15,9,9,8,8,15,6,13,8,4,8,15,13,3,11,12,8,1] } }
theorem leafL_173_1_valid : (leafL_173_1).reject.ValidFor (leafL_173_1).leaf := by decide

noncomputable def leafL_173_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,96,126}, reject := .fullRank { members := ![0,1,17,34,52,71,96,126], points := ![101,106,131,140,147,154], inverse := ![2,11,15,2,8,13,14,12,13,9,12,10,2,2,2,2,14,14,9,4,5,4,13,1,0,0,11,11,12,12,6,6,5,5,15,15] } }
theorem leafL_173_2_valid : (leafL_173_2).reject.ValidFor (leafL_173_2).leaf := by decide

noncomputable def leafL_173_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,96,155}, reject := .fullRank { members := ![0,1,17,34,52,71,96,155], points := ![101,140,166,168,169,181], inverse := ![15,5,10,10,4,15,15,0,2,13,9,9,0,0,2,4,6,0,3,10,7,1,15,0,15,12,1,5,3,4,13,11,11,8,13,8] } }
theorem leafL_173_3_valid : (leafL_173_3).reject.ValidFor (leafL_173_3).leaf := by decide

noncomputable def leafL_173_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,96,159}, reject := .fullRank { members := ![0,1,17,34,52,71,96,159], points := ![106,120,166,168,169,182], inverse := ![8,14,10,13,2,2,10,5,0,1,2,12,0,0,2,4,6,0,6,4,6,9,15,2,13,13,7,0,10,13,9,9,7,2,12,9] } }
theorem leafL_173_4_valid : (leafL_173_4).reject.ValidFor (leafL_173_4).leaf := by decide

noncomputable def leafL_173_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,96,166}, reject := .fullRank { members := ![0,1,17,34,52,71,96,166], points := ![99,106,120,121,126,140], inverse := ![1,6,5,12,0,15,3,4,10,2,6,9,0,0,10,7,13,0,13,10,7,3,11,8,10,10,8,13,5,0,3,3,2,12,14,0] } }
theorem leafL_173_5_valid : (leafL_173_5).reject.ValidFor (leafL_173_5).leaf := by decide

noncomputable def leafL_173_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,96,169}, reject := .fullRank { members := ![0,1,17,34,52,71,96,169], points := ![99,106,127,131,140,141], inverse := ![0,7,9,15,0,0,13,10,14,15,11,13,0,0,0,6,12,10,5,2,15,10,12,14,4,4,0,7,1,6,11,11,0,7,13,10] } }
theorem leafL_173_6_valid : (leafL_173_6).reject.ValidFor (leafL_173_6).leaf := by decide

noncomputable def leafL_173_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,96,181}, reject := .fullRank { members := ![0,1,17,34,52,71,96,181], points := ![120,121,127,140,141,147], inverse := ![7,7,4,1,15,11,1,12,14,3,11,11,3,13,14,0,0,0,13,1,14,13,4,11,0,6,6,7,7,0,3,10,9,6,6,0] } }
theorem leafL_173_7_valid : (leafL_173_7).reject.ValidFor (leafL_173_7).leaf := by decide

noncomputable def leavesL_173 : List RejectedLeaf := [leafL_173_0,leafL_173_1,leafL_173_2,leafL_173_3,leafL_173_4,leafL_173_5,leafL_173_6,leafL_173_7]

theorem leavesL_173_valid : LeafListValid leavesL_173 := by
  intro x hx
  simp only [leavesL_173, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_173_0_valid
  · exact leafL_173_1_valid
  · exact leafL_173_2_valid
  · exact leafL_173_3_valid
  · exact leafL_173_4_valid
  · exact leafL_173_5_valid
  · exact leafL_173_6_valid
  · exact leafL_173_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
