import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_295_0 : RejectedLeaf := { leaf := {0,1,17,34,52,73,140,183}, reject := .fullRank { members := ![0,1,17,34,52,73,140,183], points := ![86,91,101,107,112,120], inverse := ![1,14,8,10,10,6,1,8,13,3,0,7,0,0,15,14,1,0,14,6,12,9,10,7,14,14,15,4,11,0,8,8,12,13,1,0] } }
theorem leafL_295_0_valid : (leafL_295_0).reject.ValidFor (leafL_295_0).leaf := by decide

noncomputable def leafL_295_1 : RejectedLeaf := { leaf := {0,1,17,34,52,73,140,195}, reject := .fullRank { members := ![0,1,17,34,52,73,140,195], points := ![86,106,107,109,126,151], inverse := ![7,12,0,1,12,7,2,14,5,10,10,9,0,8,12,4,0,0,14,9,10,11,9,15,13,11,8,11,3,6,6,8,11,4,14,15] } }
theorem leafL_295_1_valid : (leafL_295_1).reject.ValidFor (leafL_295_1).leaf := by decide

noncomputable def leafL_295_2 : RejectedLeaf := { leaf := {0,1,17,34,52,73,140,199}, reject := .fullRank { members := ![0,1,17,34,52,73,140,199], points := ![96,99,101,107,115,120], inverse := ![15,8,2,2,4,2,9,0,5,11,6,1,0,11,9,2,0,0,8,0,5,10,7,0,0,0,6,6,14,14,0,7,5,2,8,8] } }
theorem leafL_295_2_valid : (leafL_295_2).reject.ValidFor (leafL_295_2).leaf := by decide

noncomputable def leafL_295_3 : RejectedLeaf := { leaf := {0,1,17,34,52,73,140,243}, reject := .fullRank { members := ![0,1,17,34,52,73,140,243], points := ![86,96,101,109,112,127], inverse := ![15,0,12,9,13,6,6,15,10,4,0,7,0,0,6,5,3,0,14,6,8,2,5,7,9,9,5,3,6,0,12,12,3,5,6,0] } }
theorem leafL_295_3_valid : (leafL_295_3).reject.ValidFor (leafL_295_3).leaf := by decide

noncomputable def leafL_295_4 : RejectedLeaf := { leaf := {0,1,17,34,52,73,144,158}, reject := .fullRank { members := ![0,1,17,34,52,73,144,158], points := ![86,90,95,99,107,120], inverse := ![10,11,14,7,15,6,13,15,11,12,2,7,4,9,13,0,0,0,13,13,8,0,15,7,13,10,7,9,9,0,9,8,1,15,15,0] } }
theorem leafL_295_4_valid : (leafL_295_4).reject.ValidFor (leafL_295_4).leaf := by decide

noncomputable def leafL_295_5 : RejectedLeaf := { leaf := {0,1,17,34,52,73,144,167}, reject := .fullRank { members := ![0,1,17,34,52,73,144,167], points := ![90,91,95,99,107,125], inverse := ![3,14,2,0,8,6,1,8,0,13,3,7,2,10,8,0,0,0,3,8,3,1,14,7,2,6,4,9,9,0,11,12,7,15,15,0] } }
theorem leafL_295_5_valid : (leafL_295_5).reject.ValidFor (leafL_295_5).leaf := by decide

noncomputable def leafL_295_6 : RejectedLeaf := { leaf := {0,1,17,34,52,73,144,188}, reject := .fullRank { members := ![0,1,17,34,52,73,144,188], points := ![95,107,110,126,150,167], inverse := ![6,6,4,7,1,3,11,1,11,5,1,5,5,15,11,14,12,3,5,3,11,1,8,4,12,13,6,12,6,13,10,0,10,0,10,10] } }
theorem leafL_295_6_valid : (leafL_295_6).reject.ValidFor (leafL_295_6).leaf := by decide

noncomputable def leafL_295_7 : RejectedLeaf := { leaf := {0,1,17,34,52,73,147,263}, reject := .fullRank { members := ![0,1,17,34,52,73,147,263], points := ![86,92,95,106,110,120], inverse := ![0,15,0,0,8,6,15,8,14,8,6,7,15,14,1,0,0,0,4,12,0,6,9,7,15,15,0,1,1,0,15,5,10,13,13,0] } }
theorem leafL_295_7_valid : (leafL_295_7).reject.ValidFor (leafL_295_7).leaf := by decide

noncomputable def leavesL_295 : List RejectedLeaf := [leafL_295_0,leafL_295_1,leafL_295_2,leafL_295_3,leafL_295_4,leafL_295_5,leafL_295_6,leafL_295_7]

theorem leavesL_295_valid : LeafListValid leavesL_295 := by
  intro x hx
  simp only [leavesL_295, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_295_0_valid
  · exact leafL_295_1_valid
  · exact leafL_295_2_valid
  · exact leafL_295_3_valid
  · exact leafL_295_4_valid
  · exact leafL_295_5_valid
  · exact leafL_295_6_valid
  · exact leafL_295_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
