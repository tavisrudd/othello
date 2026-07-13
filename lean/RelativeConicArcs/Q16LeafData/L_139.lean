import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_139_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,263}, reject := .fullRank { members := ![0,1,17,34,52,70,95,263], points := ![104,107,109,115,120,139], inverse := ![15,8,0,5,12,15,11,13,1,2,12,9,7,15,8,0,0,0,6,13,12,11,4,8,9,12,5,14,14,0,7,3,4,8,8,0] } }
theorem leafL_139_0_valid : (leafL_139_0).reject.ValidFor (leafL_139_0).leaf := by decide

noncomputable def leafL_139_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,264}, reject := .fullRank { members := ![0,1,17,34,52,70,95,264], points := ![103,125,131,133,135,158], inverse := ![4,2,12,9,0,2,12,9,11,9,4,3,0,0,5,10,15,0,9,6,12,15,9,5,15,1,9,12,1,10,4,6,10,12,13,9] } }
theorem leafL_139_1_valid : (leafL_139_1).reject.ValidFor (leafL_139_1).leaf := by decide

noncomputable def leafL_139_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,267}, reject := .fullRank { members := ![0,1,17,34,52,70,95,267], points := ![104,115,120,131,133,135], inverse := ![7,15,6,1,5,11,7,0,14,14,2,5,0,0,0,5,10,15,7,4,11,12,5,1,0,4,4,7,13,10,0,11,11,8,10,2] } }
theorem leafL_139_2_valid : (leafL_139_2).reject.ValidFor (leafL_139_2).leaf := by decide

noncomputable def leafL_139_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,107}, reject := .fullRank { members := ![0,1,17,34,52,70,96,107], points := ![115,120,122,131,137,152], inverse := ![12,10,2,5,11,11,5,0,6,12,4,11,1,14,15,0,0,0,12,15,1,6,15,11,5,10,15,14,14,0,4,14,10,12,12,0] } }
theorem leafL_139_3_valid : (leafL_139_3).reject.ValidFor (leafL_139_3).leaf := by decide

noncomputable def leafL_139_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,120}, reject := .fullRank { members := ![0,1,17,34,52,70,96,120], points := ![107,109,137,139,140,147], inverse := ![0,9,2,12,3,5,11,9,14,3,9,6,0,0,7,9,14,0,4,9,2,14,13,12,3,3,14,10,4,0,10,10,3,12,15,0] } }
theorem leafL_139_4_valid : (leafL_139_4).reject.ValidFor (leafL_139_4).leaf := by decide

noncomputable def leafL_139_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,137}, reject := .fullRank { members := ![0,1,17,34,52,70,96,137], points := ![101,107,108,120,122,147], inverse := ![12,10,10,1,15,3,0,15,2,14,15,12,11,3,8,0,0,0,12,2,4,8,5,7,14,7,9,5,5,0,1,1,0,1,1,0] } }
theorem leafL_139_5_valid : (leafL_139_5).reject.ValidFor (leafL_139_5).leaf := by decide

noncomputable def leafL_139_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,140}, reject := .fullRank { members := ![0,1,17,34,52,70,96,140], points := ![101,107,115,120,122,147], inverse := ![1,13,12,5,7,3,6,11,13,4,8,12,0,0,1,14,15,0,0,10,9,15,11,7,6,6,14,14,0,0,1,1,0,1,1,0] } }
theorem leafL_139_6_valid : (leafL_139_6).reject.ValidFor (leafL_139_6).leaf := by decide

noncomputable def leafL_139_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,147}, reject := .fullRank { members := ![0,1,17,34,52,70,96,147], points := ![108,117,120,122,137,140], inverse := ![7,11,5,7,5,10,7,2,10,6,0,9,0,13,1,12,0,0,7,12,15,12,8,0,0,8,15,7,2,2,0,14,14,0,14,14] } }
theorem leafL_139_7_valid : (leafL_139_7).reject.ValidFor (leafL_139_7).leaf := by decide

noncomputable def leavesL_139 : List RejectedLeaf := [leafL_139_0,leafL_139_1,leafL_139_2,leafL_139_3,leafL_139_4,leafL_139_5,leafL_139_6,leafL_139_7]

theorem leavesL_139_valid : LeafListValid leavesL_139 := by
  intro x hx
  simp only [leavesL_139, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_139_0_valid
  · exact leafL_139_1_valid
  · exact leafL_139_2_valid
  · exact leafL_139_3_valid
  · exact leafL_139_4_valid
  · exact leafL_139_5_valid
  · exact leafL_139_6_valid
  · exact leafL_139_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
