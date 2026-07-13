import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_117_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,183,259}, reject := .fullRank { members := ![0,1,17,34,52,69,183,259], points := ![86,90,91,106,110,124], inverse := ![2,1,12,7,15,6,6,10,5,9,7,7,15,6,9,0,0,0,10,5,7,7,8,7,8,13,5,1,1,0,11,15,4,13,13,0] } }
theorem leafL_117_0_valid : (leafL_117_0).reject.ValidFor (leafL_117_0).leaf := by decide

noncomputable def leafL_117_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,183,271}, reject := .fullRank { members := ![0,1,17,34,52,69,183,271], points := ![89,93,107,122,124,126], inverse := ![15,0,8,15,11,2,4,13,14,0,1,6,0,0,0,15,10,5,0,8,15,4,0,3,4,4,0,0,14,14,15,15,0,15,0,15] } }
theorem leafL_117_1_valid : (leafL_117_1).reject.ValidFor (leafL_117_1).leaf := by decide

noncomputable def leafL_117_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,186,195}, reject := .fullRank { members := ![0,1,17,34,52,69,186,195], points := ![86,89,91,103,127,137], inverse := ![5,4,7,1,15,9,2,15,9,3,10,13,6,2,4,0,0,0,5,10,9,1,9,14,4,14,8,2,2,2,2,4,15,9,9,9] } }
theorem leafL_117_2_valid : (leafL_117_2).reject.ValidFor (leafL_117_2).leaf := by decide

noncomputable def leafL_117_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,186,201}, reject := .fullRank { members := ![0,1,17,34,52,69,186,201], points := ![86,91,96,99,112,124], inverse := ![11,2,6,5,13,6,11,0,2,1,15,7,10,7,13,0,0,0,1,4,13,8,7,7,13,8,5,3,3,0,15,6,9,4,4,0] } }
theorem leafL_117_3_valid : (leafL_117_3).reject.ValidFor (leafL_117_3).leaf := by decide

noncomputable def leafL_117_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,186,214}, reject := .fullRank { members := ![0,1,17,34,52,69,186,214], points := ![89,93,96,99,103,127], inverse := ![2,15,2,13,5,6,13,4,0,15,1,7,8,10,2,0,0,0,11,15,12,7,8,7,10,2,8,1,1,0,13,13,0,13,13,0] } }
theorem leafL_117_4_valid : (leafL_117_4).reject.ValidFor (leafL_117_4).leaf := by decide

noncomputable def leafL_117_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,186,217}, reject := .fullRank { members := ![0,1,17,34,52,69,186,217], points := ![91,93,96,107,115,131], inverse := ![5,0,3,1,15,9,12,4,15,0,9,14,4,12,8,0,0,0,1,4,15,13,5,2,5,9,5,9,9,9,15,0,0,15,15,15] } }
theorem leafL_117_5_valid : (leafL_117_5).reject.ValidFor (leafL_117_5).leaf := by decide

noncomputable def leafL_117_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,186,222}, reject := .fullRank { members := ![0,1,17,34,52,69,186,222], points := ![89,96,99,107,115,124], inverse := ![13,2,6,14,7,1,10,3,15,1,15,8,6,6,10,10,15,15,9,1,10,5,11,12,15,15,15,15,5,5,2,2,3,3,10,10] } }
theorem leafL_117_6_valid : (leafL_117_6).reject.ValidFor (leafL_117_6).leaf := by decide

noncomputable def leafL_117_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,186,246}, reject := .fullRank { members := ![0,1,17,34,52,69,186,246], points := ![91,96,99,115,124,131], inverse := ![1,13,11,13,8,3,0,0,7,14,0,9,3,10,9,9,0,9,12,10,1,11,2,14,15,8,7,3,4,7,6,5,3,2,1,3] } }
theorem leafL_117_7_valid : (leafL_117_7).reject.ValidFor (leafL_117_7).leaf := by decide

noncomputable def leavesL_117 : List RejectedLeaf := [leafL_117_0,leafL_117_1,leafL_117_2,leafL_117_3,leafL_117_4,leafL_117_5,leafL_117_6,leafL_117_7]

theorem leavesL_117_valid : LeafListValid leavesL_117 := by
  intro x hx
  simp only [leavesL_117, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_117_0_valid
  · exact leafL_117_1_valid
  · exact leafL_117_2_valid
  · exact leafL_117_3_valid
  · exact leafL_117_4_valid
  · exact leafL_117_5_valid
  · exact leafL_117_6_valid
  · exact leafL_117_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
