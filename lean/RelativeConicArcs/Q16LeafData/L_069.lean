import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_069_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,169}, reject := .fullRank { members := ![0,1,17,34,52,69,107,169], points := ![92,95,122,124,127,131], inverse := ![10,13,4,3,9,8,5,2,6,4,11,14,0,0,3,12,15,0,14,9,12,12,8,15,14,14,15,12,3,0,12,12,0,12,12,0] } }
theorem leafL_069_0_valid : (leafL_069_0).reject.ValidFor (leafL_069_0).leaf := by decide

noncomputable def leafL_069_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,172}, reject := .fullRank { members := ![0,1,17,34,52,69,107,172], points := ![86,94,95,115,122,138], inverse := ![7,6,6,5,11,8,15,3,11,0,9,14,6,5,3,0,0,0,3,3,7,12,4,15,0,1,1,10,10,0,11,0,11,11,11,0] } }
theorem leafL_069_1_valid : (leafL_069_1).reject.ValidFor (leafL_069_1).leaf := by decide

noncomputable def leafL_069_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,173}, reject := .fullRank { members := ![0,1,17,34,52,69,107,173], points := ![86,92,94,122,124,131], inverse := ![6,13,12,8,6,8,7,1,1,15,6,14,2,9,11,0,0,0,4,2,1,11,3,15,15,14,1,1,1,0,4,11,15,13,13,0] } }
theorem leafL_069_2_valid : (leafL_069_2).reject.ValidFor (leafL_069_2).leaf := by decide

noncomputable def leafL_069_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,183}, reject := .fullRank { members := ![0,1,17,34,52,69,107,183], points := ![86,95,122,124,127,131], inverse := ![7,0,0,0,14,8,10,13,4,12,1,14,0,0,3,12,15,0,15,8,15,0,7,15,15,15,12,0,12,0,11,11,9,14,7,0] } }
theorem leafL_069_3_valid : (leafL_069_3).reject.ValidFor (leafL_069_3).leaf := by decide

noncomputable def leafL_069_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,186}, reject := .fullRank { members := ![0,1,17,34,52,69,107,186], points := ![86,96,115,124,127,131], inverse := ![7,0,0,0,14,8,9,14,4,14,3,14,0,0,7,5,2,0,5,2,14,3,5,15,7,7,6,13,11,0,6,6,12,15,3,0] } }
theorem leafL_069_4_valid : (leafL_069_4).reject.ValidFor (leafL_069_4).leaf := by decide

noncomputable def leafL_069_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,189}, reject := .fullRank { members := ![0,1,17,34,52,69,107,189], points := ![86,92,95,115,120,131], inverse := ![10,15,2,4,10,8,15,11,3,9,0,14,15,14,1,0,0,0,15,0,8,3,11,15,6,13,11,5,5,0,0,12,12,12,12,0] } }
theorem leafL_069_5_valid : (leafL_069_5).reject.ValidFor (leafL_069_5).leaf := by decide

noncomputable def leafL_069_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,195}, reject := .fullRank { members := ![0,1,17,34,52,69,107,195], points := ![86,94,127,137,150,151], inverse := ![1,4,15,6,4,9,8,6,4,4,5,11,14,10,2,15,3,10,15,15,2,9,3,8,10,10,0,0,11,11,3,11,4,13,0,1] } }
theorem leafL_069_6_valid : (leafL_069_6).reject.ValidFor (leafL_069_6).leaf := by decide

noncomputable def leafL_069_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,205}, reject := .fullRank { members := ![0,1,17,34,52,69,107,205], points := ![86,94,96,122,124,131], inverse := ![3,7,3,8,6,8,0,11,12,15,6,14,8,14,6,0,0,0,10,6,11,11,3,15,3,7,4,1,1,0,0,13,13,13,13,0] } }
theorem leafL_069_7_valid : (leafL_069_7).reject.ValidFor (leafL_069_7).leaf := by decide

noncomputable def leavesL_069 : List RejectedLeaf := [leafL_069_0,leafL_069_1,leafL_069_2,leafL_069_3,leafL_069_4,leafL_069_5,leafL_069_6,leafL_069_7]

theorem leavesL_069_valid : LeafListValid leavesL_069 := by
  intro x hx
  simp only [leavesL_069, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_069_0_valid
  · exact leafL_069_1_valid
  · exact leafL_069_2_valid
  · exact leafL_069_3_valid
  · exact leafL_069_4_valid
  · exact leafL_069_5_valid
  · exact leafL_069_6_valid
  · exact leafL_069_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
