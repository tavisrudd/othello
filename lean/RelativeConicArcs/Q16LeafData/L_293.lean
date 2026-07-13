import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_293_0 : RejectedLeaf := { leaf := {0,1,17,34,52,73,110,188}, reject := .fullRank { members := ![0,1,17,34,52,73,110,188], points := ![91,125,128,133,141,144], inverse := ![7,0,14,8,0,0,7,8,1,13,3,0,0,0,0,6,5,3,7,13,5,13,6,4,0,12,12,10,13,7,0,14,14,0,14,14] } }
theorem leafL_293_0_valid : (leafL_293_0).reject.ValidFor (leafL_293_0).leaf := by decide

noncomputable def leafL_293_1 : RejectedLeaf := { leaf := {0,1,17,34,52,73,110,199}, reject := .fullRank { members := ![0,1,17,34,52,73,110,199], points := ![90,115,127,133,141,155], inverse := ![7,9,7,7,15,0,15,3,14,5,6,1,13,4,11,6,3,7,4,11,11,4,2,2,5,12,7,5,13,6,1,9,0,4,3,15] } }
theorem leafL_293_1_valid : (leafL_293_1).reject.ValidFor (leafL_293_1).leaf := by decide

noncomputable def leafL_293_2 : RejectedLeaf := { leaf := {0,1,17,34,52,73,110,216}, reject := .fullRank { members := ![0,1,17,34,52,73,110,216], points := ![90,115,125,127,133,135], inverse := ![7,2,15,3,1,9,7,2,9,2,11,5,0,13,8,5,0,0,7,5,15,2,8,7,0,9,9,0,3,3,0,0,9,9,9,9] } }
theorem leafL_293_2_valid : (leafL_293_2).reject.ValidFor (leafL_293_2).leaf := by decide

noncomputable def leafL_293_3 : RejectedLeaf := { leaf := {0,1,17,34,52,73,110,264}, reject := .fullRank { members := ![0,1,17,34,52,73,110,264], points := ![125,133,135,151,155,156], inverse := ![4,13,3,5,11,5,3,14,6,6,12,1,0,0,0,14,10,4,2,14,7,9,1,3,0,6,6,2,4,6,0,4,4,8,10,2] } }
theorem leafL_293_3_valid : (leafL_293_3).reject.ValidFor (leafL_293_3).leaf := by decide

noncomputable def leafL_293_4 : RejectedLeaf := { leaf := {0,1,17,34,52,73,110,269}, reject := .fullRank { members := ![0,1,17,34,52,73,110,269], points := ![90,91,115,128,133,144], inverse := ![0,7,0,14,8,0,1,6,13,4,2,12,7,7,6,6,5,5,14,9,15,7,3,12,3,3,6,6,9,9,1,1,3,3,8,8] } }
theorem leafL_293_4_valid : (leafL_293_4).reject.ValidFor (leafL_293_4).leaf := by decide

noncomputable def leafL_293_5 : RejectedLeaf := { leaf := {0,1,17,34,52,73,120,140}, reject := .fullRank { members := ![0,1,17,34,52,73,120,140], points := ![91,96,106,107,109,155], inverse := ![12,10,2,4,13,12,10,0,0,4,0,14,0,0,8,12,4,0,9,2,2,5,2,14,1,1,4,9,13,0,11,11,11,0,11,0] } }
theorem leafL_293_5_valid : (leafL_293_5).reject.ValidFor (leafL_293_5).leaf := by decide

noncomputable def leafL_293_6 : RejectedLeaf := { leaf := {0,1,17,34,52,73,120,172}, reject := .fullRank { members := ![0,1,17,34,52,73,120,172], points := ![91,96,103,109,141,143], inverse := ![14,7,14,0,15,9,13,3,11,2,9,14,1,1,4,4,12,12,12,3,12,4,2,5,13,13,0,0,15,15,4,4,5,5,8,8] } }
theorem leafL_293_6_valid : (leafL_293_6).reject.ValidFor (leafL_293_6).leaf := by decide

noncomputable def leafL_293_7 : RejectedLeaf := { leaf := {0,1,17,34,52,73,120,199}, reject := .fullRank { members := ![0,1,17,34,52,73,120,199], points := ![95,107,112,140,141,143], inverse := ![9,7,9,1,15,8,14,12,5,13,6,12,0,0,0,15,3,12,15,3,11,0,10,13,0,2,2,15,15,0,0,12,12,12,0,12] } }
theorem leafL_293_7_valid : (leafL_293_7).reject.ValidFor (leafL_293_7).leaf := by decide

noncomputable def leavesL_293 : List RejectedLeaf := [leafL_293_0,leafL_293_1,leafL_293_2,leafL_293_3,leafL_293_4,leafL_293_5,leafL_293_6,leafL_293_7]

theorem leavesL_293_valid : LeafListValid leavesL_293 := by
  intro x hx
  simp only [leavesL_293, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_293_0_valid
  · exact leafL_293_1_valid
  · exact leafL_293_2_valid
  · exact leafL_293_3_valid
  · exact leafL_293_4_valid
  · exact leafL_293_5_valid
  · exact leafL_293_6_valid
  · exact leafL_293_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
