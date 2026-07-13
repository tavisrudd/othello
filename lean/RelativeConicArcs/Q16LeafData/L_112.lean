import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_112_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,163,247}, reject := .fullRank { members := ![0,1,17,34,52,69,163,247], points := ![86,91,93,107,110,126], inverse := ![7,10,2,6,14,6,13,1,5,0,14,7,3,13,14,0,0,0,0,8,0,8,7,7,6,1,7,11,11,0,3,10,9,6,6,0] } }
theorem leafL_112_0_valid : (leafL_112_0).reject.ValidFor (leafL_112_0).leaf := by decide

noncomputable def leafL_112_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,163,249}, reject := .fullRank { members := ![0,1,17,34,52,69,163,249], points := ![86,90,107,112,122,126], inverse := ![9,6,0,8,13,11,3,10,12,2,4,3,9,9,10,10,9,9,12,4,12,3,14,9,3,3,12,12,7,7,7,7,14,14,13,13] } }
theorem leafL_112_1_valid : (leafL_112_1).reject.ValidFor (leafL_112_1).leaf := by decide

noncomputable def leafL_112_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,163,256}, reject := .fullRank { members := ![0,1,17,34,52,69,163,256], points := ![90,93,94,122,126,137], inverse := ![2,11,14,0,14,8,8,14,1,6,15,14,6,11,13,0,0,0,4,15,12,11,3,15,15,10,5,9,9,0,15,0,15,15,15,0] } }
theorem leafL_112_2_valid : (leafL_112_2).reject.ValidFor (leafL_112_2).leaf := by decide

noncomputable def leafL_112_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,163,262}, reject := .fullRank { members := ![0,1,17,34,52,69,163,262], points := ![90,96,107,112,126,127], inverse := ![2,13,1,9,0,6,12,5,1,15,4,3,7,7,3,3,11,11,9,1,4,11,1,6,11,11,7,7,2,2,14,14,14,14,14,14] } }
theorem leafL_112_3_valid : (leafL_112_3).reject.ValidFor (leafL_112_3).leaf := by decide

noncomputable def leafL_112_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,163,270}, reject := .fullRank { members := ![0,1,17,34,52,69,163,270], points := ![86,91,96,122,127,135], inverse := ![6,12,13,13,3,8,15,15,7,11,2,14,10,7,13,0,0,0,12,7,12,4,12,15,10,9,3,12,12,0,10,11,1,3,3,0] } }
theorem leafL_112_4_valid : (leafL_112_4).reject.ValidFor (leafL_112_4).leaf := by decide

noncomputable def leafL_112_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,166,183}, reject := .fullRank { members := ![0,1,17,34,52,69,166,183], points := ![90,93,110,120,127,128], inverse := ![9,6,8,10,10,6,12,5,14,4,8,11,0,0,0,13,2,15,4,12,15,10,14,3,14,14,0,14,11,5,12,12,0,9,13,4] } }
theorem leafL_112_5_valid : (leafL_112_5).reject.ValidFor (leafL_112_5).leaf := by decide

noncomputable def leafL_112_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,166,186}, reject := .fullRank { members := ![0,1,17,34,52,69,166,186], points := ![89,93,96,99,112,127], inverse := ![13,7,5,7,15,6,14,3,4,13,3,7,8,10,2,0,0,0,0,2,10,4,11,7,9,5,12,3,3,0,9,8,1,4,4,0] } }
theorem leafL_112_6_valid : (leafL_112_6).reject.ValidFor (leafL_112_6).leaf := by decide

noncomputable def leafL_112_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,166,203}, reject := .fullRank { members := ![0,1,17,34,52,69,166,203], points := ![89,90,99,110,112,127], inverse := ![8,7,13,12,9,6,10,3,5,1,10,7,0,0,6,4,2,0,3,11,15,3,3,7,5,5,8,3,11,0,1,1,10,5,15,0] } }
theorem leafL_112_7_valid : (leafL_112_7).reject.ValidFor (leafL_112_7).leaf := by decide

noncomputable def leavesL_112 : List RejectedLeaf := [leafL_112_0,leafL_112_1,leafL_112_2,leafL_112_3,leafL_112_4,leafL_112_5,leafL_112_6,leafL_112_7]

theorem leavesL_112_valid : LeafListValid leavesL_112 := by
  intro x hx
  simp only [leavesL_112, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_112_0_valid
  · exact leafL_112_1_valid
  · exact leafL_112_2_valid
  · exact leafL_112_3_valid
  · exact leafL_112_4_valid
  · exact leafL_112_5_valid
  · exact leafL_112_6_valid
  · exact leafL_112_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
