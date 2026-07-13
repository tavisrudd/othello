import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_090_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,269}, reject := .fullRank { members := ![0,1,17,34,52,69,126,269], points := ![86,89,92,103,104,131], inverse := ![14,4,3,11,5,6,6,3,11,11,2,7,12,13,1,0,0,0,8,3,4,12,4,7,13,5,8,4,4,0,11,7,12,1,1,0] } }
theorem leafL_090_0_valid : (leafL_090_0).reject.ValidFor (leafL_090_0).leaf := by decide

noncomputable def leafL_090_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,271}, reject := .fullRank { members := ![0,1,17,34,52,69,126,271], points := ![89,93,96,103,112,138], inverse := ![0,9,0,0,14,6,12,0,2,6,15,7,8,10,2,0,0,0,6,4,13,11,3,7,2,8,10,8,8,0,15,6,9,2,2,0] } }
theorem leafL_090_1_valid : (leafL_090_1).reject.ValidFor (leafL_090_1).leaf := by decide

noncomputable def leafL_090_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,135}, reject := .fullRank { members := ![0,1,17,34,52,69,127,135], points := ![89,90,92,110,156,163], inverse := ![2,7,9,1,6,10,15,14,14,1,11,5,14,9,7,0,0,0,1,3,5,9,2,12,5,14,3,8,8,8,11,8,1,2,2,2] } }
theorem leafL_090_2_valid : (leafL_090_2).reject.ValidFor (leafL_090_2).leaf := by decide

noncomputable def leafL_090_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,137}, reject := .fullRank { members := ![0,1,17,34,52,69,127,137], points := ![90,92,93,103,104,152], inverse := ![15,6,15,15,4,12,13,2,5,0,4,14,12,3,15,0,0,0,2,11,2,7,2,14,15,10,5,4,4,0,14,12,2,1,1,0] } }
theorem leafL_090_3_valid : (leafL_090_3).reject.ValidFor (leafL_090_3).leaf := by decide

noncomputable def leafL_090_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,151}, reject := .fullRank { members := ![0,1,17,34,52,69,127,151], points := ![89,90,93,107,138,166], inverse := ![15,6,14,2,9,13,2,12,7,15,9,15,13,11,6,0,0,0,13,4,3,0,13,7,11,8,9,3,7,14,5,9,7,4,5,10] } }
theorem leafL_090_4_valid : (leafL_090_4).reject.ValidFor (leafL_090_4).leaf := by decide

noncomputable def leafL_090_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,152}, reject := .fullRank { members := ![0,1,17,34,52,69,127,152], points := ![90,92,93,103,107,137], inverse := ![3,10,0,5,11,6,1,5,10,10,3,7,12,3,15,0,0,0,4,7,12,2,10,7,3,9,10,14,14,0,13,8,5,10,10,0] } }
theorem leafL_090_5_valid : (leafL_090_5).reject.ValidFor (leafL_090_5).leaf := by decide

noncomputable def leafL_090_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,154}, reject := .fullRank { members := ![0,1,17,34,52,69,127,154], points := ![89,92,93,104,137,144], inverse := ![5,3,15,14,0,6,11,12,9,9,8,15,10,2,8,0,0,0,0,4,11,8,6,1,3,0,3,0,8,8,0,2,2,0,2,2] } }
theorem leafL_090_6_valid : (leafL_090_6).reject.ValidFor (leafL_090_6).leaf := by decide

noncomputable def leafL_090_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,163}, reject := .fullRank { members := ![0,1,17,34,52,69,127,163], points := ![93,94,96,107,110,135], inverse := ![2,3,8,10,4,6,8,6,0,14,7,7,14,9,7,0,0,0,12,14,13,6,14,7,3,0,3,11,11,0,3,2,1,6,6,0] } }
theorem leafL_090_7_valid : (leafL_090_7).reject.ValidFor (leafL_090_7).leaf := by decide

noncomputable def leavesL_090 : List RejectedLeaf := [leafL_090_0,leafL_090_1,leafL_090_2,leafL_090_3,leafL_090_4,leafL_090_5,leafL_090_6,leafL_090_7]

theorem leavesL_090_valid : LeafListValid leavesL_090 := by
  intro x hx
  simp only [leavesL_090, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_090_0_valid
  · exact leafL_090_1_valid
  · exact leafL_090_2_valid
  · exact leafL_090_3_valid
  · exact leafL_090_4_valid
  · exact leafL_090_5_valid
  · exact leafL_090_6_valid
  · exact leafL_090_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
