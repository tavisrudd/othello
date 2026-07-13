import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_169_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,243}, reject := .fullRank { members := ![0,1,17,34,52,71,93,243], points := ![101,106,121,124,127,140], inverse := ![10,13,7,10,4,15,13,10,9,0,7,9,0,0,12,8,4,0,11,12,6,12,5,8,8,8,14,11,5,0,13,13,6,12,10,0] } }
theorem leafL_169_0_valid : (leafL_169_0).reject.ValidFor (leafL_169_0).leaf := by decide

noncomputable def leafL_169_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,245}, reject := .fullRank { members := ![0,1,17,34,52,71,93,245], points := ![99,110,120,139,140,144], inverse := ![0,7,9,10,13,8,11,12,14,2,10,1,0,0,0,11,13,6,4,3,15,5,1,12,15,15,0,15,14,1,4,4,0,13,12,1] } }
theorem leafL_169_1_valid : (leafL_169_1).reject.ValidFor (leafL_169_1).leaf := by decide

noncomputable def leafL_169_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,248}, reject := .fullRank { members := ![0,1,17,34,52,71,93,248], points := ![99,101,106,121,124,140], inverse := ![8,5,10,11,2,15,14,11,2,0,14,9,8,15,7,0,0,0,10,3,14,9,6,8,10,0,10,1,1,0,7,14,9,11,11,0] } }
theorem leafL_169_2_valid : (leafL_169_2).reject.ValidFor (leafL_169_2).leaf := by decide

noncomputable def leafL_169_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,249}, reject := .fullRank { members := ![0,1,17,34,52,71,93,249], points := ![101,120,140,144,154,158], inverse := ![0,4,6,8,5,14,0,3,3,11,9,2,13,2,1,9,7,0,11,5,5,3,4,12,1,8,7,1,1,14,0,0,2,2,2,2] } }
theorem leafL_169_3_valid : (leafL_169_3).reject.ValidFor (leafL_169_3).leaf := by decide

noncomputable def leafL_169_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,267}, reject := .fullRank { members := ![0,1,17,34,52,71,93,267], points := ![99,101,106,120,121,144], inverse := ![2,2,7,12,5,15,8,11,4,10,4,9,8,15,7,0,0,0,5,7,5,9,6,8,7,11,12,11,11,0,1,7,6,9,9,0] } }
theorem leafL_169_4_valid : (leafL_169_4).reject.ValidFor (leafL_169_4).leaf := by decide

noncomputable def leafL_169_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,271}, reject := .fullRank { members := ![0,1,17,34,52,71,93,271], points := ![110,121,140,166,172,186], inverse := ![10,2,6,2,1,12,14,5,14,5,7,7,12,2,6,11,3,0,11,11,7,5,3,1,4,8,1,4,15,6,0,14,6,13,9,12] } }
theorem leafL_169_5_valid : (leafL_169_5).reject.ValidFor (leafL_169_5).leaf := by decide

noncomputable def leafL_169_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,101}, reject := .fullRank { members := ![0,1,17,34,52,71,94,101], points := ![121,124,127,131,155,173], inverse := ![0,0,4,14,11,0,7,9,12,9,10,1,12,8,4,0,0,0,2,12,10,15,13,6,7,1,15,9,9,9,12,15,9,10,10,10] } }
theorem leafL_169_6_valid : (leafL_169_6).reject.ValidFor (leafL_169_6).leaf := by decide

noncomputable def leafL_169_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,106}, reject := .fullRank { members := ![0,1,17,34,52,71,94,106], points := ![121,124,133,140,156,166], inverse := ![3,2,2,9,14,5,0,3,0,8,11,0,9,7,11,5,14,14,7,15,1,2,1,10,3,9,3,9,10,10,8,12,5,1,4,4] } }
theorem leafL_169_7_valid : (leafL_169_7).reject.ValidFor (leafL_169_7).leaf := by decide

noncomputable def leavesL_169 : List RejectedLeaf := [leafL_169_0,leafL_169_1,leafL_169_2,leafL_169_3,leafL_169_4,leafL_169_5,leafL_169_6,leafL_169_7]

theorem leavesL_169_valid : LeafListValid leavesL_169 := by
  intro x hx
  simp only [leavesL_169, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_169_0_valid
  · exact leafL_169_1_valid
  · exact leafL_169_2_valid
  · exact leafL_169_3_valid
  · exact leafL_169_4_valid
  · exact leafL_169_5_valid
  · exact leafL_169_6_valid
  · exact leafL_169_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
