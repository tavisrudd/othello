import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_100_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,138,183}, reject := .fullRank { members := ![0,1,17,34,52,69,138,183], points := ![86,91,95,107,126,127], inverse := ![13,9,11,8,4,2,8,12,13,14,5,2,14,2,12,0,0,0,1,2,11,15,6,1,6,3,5,0,15,15,6,8,14,0,7,7] } }
theorem leafL_100_0_valid : (leafL_100_0).reject.ValidFor (leafL_100_0).leaf := by decide

noncomputable def leafL_100_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,138,198}, reject := .fullRank { members := ![0,1,17,34,52,69,138,198], points := ![92,95,99,104,126,127], inverse := ![13,2,14,6,3,5,11,2,7,9,11,12,12,12,8,8,12,12,13,5,6,9,5,2,8,8,4,4,9,9,11,11,11,11,0,0] } }
theorem leafL_100_1_valid : (leafL_100_1).reject.ValidFor (leafL_100_1).leaf := by decide

noncomputable def leafL_100_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,138,214}, reject := .fullRank { members := ![0,1,17,34,52,69,138,214], points := ![92,99,107,115,127,128], inverse := ![15,7,15,4,4,6,9,5,11,14,5,12,0,0,0,14,10,4,8,11,4,4,6,5,0,13,13,0,3,3,0,5,5,12,13,1] } }
theorem leafL_100_2_valid : (leafL_100_2).reject.ValidFor (leafL_100_2).leaf := by decide

noncomputable def leafL_100_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,138,223}, reject := .fullRank { members := ![0,1,17,34,52,69,138,223], points := ![86,99,104,126,128,151], inverse := ![3,13,11,2,11,13,9,3,13,8,15,0,2,7,11,7,12,5,6,14,3,6,5,8,11,7,8,10,7,9,11,10,5,5,8,9] } }
theorem leafL_100_3_valid : (leafL_100_3).reject.ValidFor (leafL_100_3).leaf := by decide

noncomputable def leafL_100_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,138,236}, reject := .fullRank { members := ![0,1,17,34,52,69,138,236], points := ![86,99,107,126,128,151], inverse := ![6,7,12,6,6,12,0,2,15,13,12,12,7,13,12,3,1,4,0,2,8,15,2,7,8,1,4,7,13,7,1,13,11,13,1,11] } }
theorem leafL_100_4_valid : (leafL_100_4).reject.ValidFor (leafL_100_4).leaf := by decide

noncomputable def leafL_100_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,138,246}, reject := .fullRank { members := ![0,1,17,34,52,69,138,246], points := ![91,95,99,104,126,127], inverse := ![2,13,2,10,9,15,7,14,6,8,3,4,10,10,1,1,8,8,2,10,10,5,15,8,12,12,10,10,0,0,7,7,10,10,8,8] } }
theorem leafL_100_5_valid : (leafL_100_5).reject.ValidFor (leafL_100_5).leaf := by decide

noncomputable def leafL_100_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,138,262}, reject := .fullRank { members := ![0,1,17,34,52,69,138,262], points := ![91,92,95,99,126,127], inverse := ![1,2,12,8,6,0,10,7,4,14,15,8,13,11,6,0,0,0,10,1,3,15,1,6,15,2,13,0,15,15,4,2,6,0,7,7] } }
theorem leafL_100_6_valid : (leafL_100_6).reject.ValidFor (leafL_100_6).leaf := by decide

noncomputable def leafL_100_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,150}, reject := .fullRank { members := ![0,1,17,34,52,69,139,150], points := ![89,95,103,115,122,126], inverse := ![4,11,8,5,12,15,15,6,14,13,4,14,0,0,0,14,12,2,11,3,15,8,8,7,9,9,0,15,2,13,10,10,0,14,3,13] } }
theorem leafL_100_7_valid : (leafL_100_7).reject.ValidFor (leafL_100_7).leaf := by decide

noncomputable def leavesL_100 : List RejectedLeaf := [leafL_100_0,leafL_100_1,leafL_100_2,leafL_100_3,leafL_100_4,leafL_100_5,leafL_100_6,leafL_100_7]

theorem leavesL_100_valid : LeafListValid leavesL_100 := by
  intro x hx
  simp only [leavesL_100, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_100_0_valid
  · exact leafL_100_1_valid
  · exact leafL_100_2_valid
  · exact leafL_100_3_valid
  · exact leafL_100_4_valid
  · exact leafL_100_5_valid
  · exact leafL_100_6_valid
  · exact leafL_100_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
