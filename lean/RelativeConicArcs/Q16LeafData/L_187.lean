import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_187_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,240}, reject := .fullRank { members := ![0,1,17,34,52,71,109,240], points := ![90,94,120,124,127,131], inverse := ![14,9,9,6,1,8,6,1,3,8,2,14,0,0,7,2,5,0,11,12,5,0,13,15,4,4,1,9,8,0,15,15,10,13,7,0] } }
theorem leafL_187_0_valid : (leafL_187_0).reject.ValidFor (leafL_187_0).leaf := by decide

noncomputable def leafL_187_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,246}, reject := .fullRank { members := ![0,1,17,34,52,71,109,246], points := ![91,92,94,120,124,131], inverse := ![12,11,0,13,3,8,0,4,3,11,2,14,6,7,1,0,0,0,6,4,5,4,12,15,6,14,8,7,7,0,13,2,15,5,5,0] } }
theorem leafL_187_1_valid : (leafL_187_1).reject.ValidFor (leafL_187_1).leaf := by decide

noncomputable def leafL_187_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,248}, reject := .fullRank { members := ![0,1,17,34,52,71,109,248], points := ![91,92,124,131,138,140], inverse := ![13,10,14,15,4,3,0,7,9,0,0,14,0,0,0,10,11,1,8,15,8,2,13,0,12,12,0,4,14,10,14,14,0,10,12,6] } }
theorem leafL_187_2_valid : (leafL_187_2).reject.ValidFor (leafL_187_2).leaf := by decide

noncomputable def leafL_187_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,262}, reject := .fullRank { members := ![0,1,17,34,52,71,109,262], points := ![90,92,120,124,127,138], inverse := ![3,4,0,6,8,8,7,0,6,12,3,14,0,0,7,2,5,0,8,15,2,11,1,15,8,8,2,14,12,0,13,13,3,11,8,0] } }
theorem leafL_187_3_valid : (leafL_187_3).reject.ValidFor (leafL_187_3).leaf := by decide

noncomputable def leafL_187_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,271}, reject := .fullRank { members := ![0,1,17,34,52,71,109,271], points := ![90,91,124,131,140,156], inverse := ![6,1,14,12,4,0,0,0,3,0,8,11,7,14,13,0,10,14,2,12,5,3,6,14,9,13,2,9,6,9,10,9,8,15,6,2] } }
theorem leafL_187_4_valid : (leafL_187_4).reject.ValidFor (leafL_187_4).leaf := by decide

noncomputable def leafL_187_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,128}, reject := .fullRank { members := ![0,1,17,34,52,71,110,128], points := ![93,131,139,147,172,182], inverse := ![9,9,15,13,4,7,1,8,10,6,8,13,4,6,3,5,8,12,0,6,12,12,14,8,10,6,4,14,0,6,14,14,0,0,14,14] } }
theorem leafL_187_5_valid : (leafL_187_5).reject.ValidFor (leafL_187_5).leaf := by decide

noncomputable def leafL_187_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,144}, reject := .fullRank { members := ![0,1,17,34,52,71,110,144], points := ![83,91,122,147,155,156], inverse := ![1,3,5,6,8,8,10,15,8,6,10,1,0,0,0,13,15,2,0,3,10,15,10,12,10,10,0,7,4,3,12,12,0,12,12,0] } }
theorem leafL_187_6_valid : (leafL_187_6).reject.ValidFor (leafL_187_6).leaf := by decide

noncomputable def leafL_187_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,155}, reject := .fullRank { members := ![0,1,17,34,52,71,110,155], points := ![144,168,172,182,185,189], inverse := ![9,15,12,11,15,15,12,14,15,4,8,1,0,0,0,8,1,9,7,14,3,11,1,0,0,9,9,8,4,12,0,6,6,4,3,7] } }
theorem leafL_187_7_valid : (leafL_187_7).reject.ValidFor (leafL_187_7).leaf := by decide

noncomputable def leavesL_187 : List RejectedLeaf := [leafL_187_0,leafL_187_1,leafL_187_2,leafL_187_3,leafL_187_4,leafL_187_5,leafL_187_6,leafL_187_7]

theorem leavesL_187_valid : LeafListValid leavesL_187 := by
  intro x hx
  simp only [leavesL_187, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_187_0_valid
  · exact leafL_187_1_valid
  · exact leafL_187_2_valid
  · exact leafL_187_3_valid
  · exact leafL_187_4_valid
  · exact leafL_187_5_valid
  · exact leafL_187_6_valid
  · exact leafL_187_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
