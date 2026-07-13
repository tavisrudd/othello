import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_131_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,201}, reject := .fullRank { members := ![0,1,17,34,52,70,91,201], points := ![103,104,109,120,122,140], inverse := ![12,10,1,2,11,15,14,0,9,2,12,9,12,5,9,0,0,0,7,12,12,15,0,8,5,13,8,5,5,0,7,12,11,1,1,0] } }
theorem leafL_131_0_valid : (leafL_131_0).reject.ValidFor (leafL_131_0).leaf := by decide

noncomputable def leafL_131_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,205}, reject := .fullRank { members := ![0,1,17,34,52,70,91,205], points := ![101,117,120,122,147,151], inverse := ![12,9,2,5,2,1,13,6,15,8,6,10,0,13,1,12,0,0,10,9,4,0,9,14,0,8,8,0,11,11,0,14,8,6,4,4] } }
theorem leafL_131_1_valid : (leafL_131_1).reject.ValidFor (leafL_131_1).leaf := by decide

noncomputable def leafL_131_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,208}, reject := .fullRank { members := ![0,1,17,34,52,70,91,208], points := ![103,109,117,137,141,147], inverse := ![12,14,7,9,11,6,7,8,2,10,6,1,14,1,1,2,6,10,15,6,6,11,1,5,14,3,2,2,10,7,10,1,7,1,14,3] } }
theorem leafL_131_2_valid : (leafL_131_2).reject.ValidFor (leafL_131_2).leaf := by decide

noncomputable def leafL_131_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,211}, reject := .fullRank { members := ![0,1,17,34,52,70,91,211], points := ![103,104,109,117,120,137], inverse := ![11,3,15,3,10,15,7,9,9,3,13,9,12,5,9,0,0,0,8,11,4,1,14,8,0,10,10,1,1,0,6,8,14,11,11,0] } }
theorem leafL_131_3_valid : (leafL_131_3).reject.ValidFor (leafL_131_3).leaf := by decide

noncomputable def leafL_131_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,220}, reject := .fullRank { members := ![0,1,17,34,52,70,91,220], points := ![101,110,117,141,144,149], inverse := ![10,15,10,13,14,13,13,0,1,0,0,12,1,0,8,5,3,15,9,4,0,7,6,12,12,7,7,9,6,3,4,1,14,5,8,6] } }
theorem leafL_131_4_valid : (leafL_131_4).reject.ValidFor (leafL_131_4).leaf := by decide

noncomputable def leafL_131_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,237}, reject := .fullRank { members := ![0,1,17,34,52,70,91,237], points := ![104,110,117,122,127,140], inverse := ![5,2,14,10,13,15,12,11,4,8,2,9,0,0,5,11,14,0,6,1,10,7,2,8,11,11,3,2,1,0,4,4,4,0,4,0] } }
theorem leafL_131_5_valid : (leafL_131_5).reject.ValidFor (leafL_131_5).leaf := by decide

noncomputable def leafL_131_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,239}, reject := .fullRank { members := ![0,1,17,34,52,70,91,239], points := ![103,108,117,120,125,140], inverse := ![7,0,9,0,0,15,0,7,6,11,3,9,0,0,5,3,6,0,6,1,14,4,5,8,8,8,8,6,14,0,13,13,10,5,15,0] } }
theorem leafL_131_6_valid : (leafL_131_6).reject.ValidFor (leafL_131_6).leaf := by decide

noncomputable def leafL_131_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,247}, reject := .fullRank { members := ![0,1,17,34,52,70,91,247], points := ![104,110,127,140,141,144], inverse := ![8,15,9,4,13,6,6,1,14,10,12,15,0,0,0,8,2,10,4,3,15,6,13,3,1,1,0,5,4,1,6,6,0,2,14,12] } }
theorem leafL_131_7_valid : (leafL_131_7).reject.ValidFor (leafL_131_7).leaf := by decide

noncomputable def leavesL_131 : List RejectedLeaf := [leafL_131_0,leafL_131_1,leafL_131_2,leafL_131_3,leafL_131_4,leafL_131_5,leafL_131_6,leafL_131_7]

theorem leavesL_131_valid : LeafListValid leavesL_131 := by
  intro x hx
  simp only [leavesL_131, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_131_0_valid
  · exact leafL_131_1_valid
  · exact leafL_131_2_valid
  · exact leafL_131_3_valid
  · exact leafL_131_4_valid
  · exact leafL_131_5_valid
  · exact leafL_131_6_valid
  · exact leafL_131_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
