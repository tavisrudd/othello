import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_084_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,214}, reject := .fullRank { members := ![0,1,17,34,52,69,120,214], points := ![93,94,96,99,107,137], inverse := ![11,5,7,14,0,6,1,14,1,15,6,7,14,9,7,0,0,0,1,0,14,3,11,7,4,13,9,9,9,0,6,12,10,15,15,0] } }
theorem leafL_084_0_valid : (leafL_084_0).reject.ValidFor (leafL_084_0).leaf := by decide

noncomputable def leafL_084_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,217}, reject := .fullRank { members := ![0,1,17,34,52,69,120,217], points := ![91,93,94,99,107,131], inverse := ![9,14,14,15,1,6,3,12,1,9,0,7,1,7,6,0,0,0,7,14,6,5,13,7,3,12,15,9,9,0,9,11,2,15,15,0] } }
theorem leafL_084_1_valid : (leafL_084_1).reject.ValidFor (leafL_084_1).leaf := by decide

noncomputable def leafL_084_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,218}, reject := .fullRank { members := ![0,1,17,34,52,69,120,218], points := ![94,95,112,131,139,151], inverse := ![1,7,11,8,8,12,7,5,13,15,1,1,5,0,3,13,15,4,5,9,9,13,5,13,6,4,15,11,1,7,5,11,11,7,4,6] } }
theorem leafL_084_2_valid : (leafL_084_2).reject.ValidFor (leafL_084_2).leaf := by decide

noncomputable def leafL_084_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,230}, reject := .fullRank { members := ![0,1,17,34,52,69,120,230], points := ![91,93,99,106,112,131], inverse := ![5,12,6,3,11,6,4,10,15,13,11,7,0,0,7,8,15,0,6,9,4,7,11,7,8,8,1,10,11,0,7,7,0,7,7,0] } }
theorem leafL_084_3_valid : (leafL_084_3).reject.ValidFor (leafL_084_3).leaf := by decide

noncomputable def leafL_084_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,246}, reject := .fullRank { members := ![0,1,17,34,52,69,120,246], points := ![91,94,96,99,131,141], inverse := ![8,5,4,14,14,8,8,2,4,9,7,0,15,3,12,0,0,0,2,1,12,8,5,2,15,5,10,0,4,4,9,11,2,0,1,1] } }
theorem leafL_084_4_valid : (leafL_084_4).reject.ValidFor (leafL_084_4).leaf := by decide

noncomputable def leafL_084_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,249}, reject := .fullRank { members := ![0,1,17,34,52,69,120,249], points := ![94,95,112,131,141,144], inverse := ![14,7,14,6,5,5,11,5,9,8,15,0,0,0,0,12,1,13,6,9,8,3,14,10,4,4,0,7,9,14,11,11,0,0,11,11] } }
theorem leafL_084_5_valid : (leafL_084_5).reject.ValidFor (leafL_084_5).leaf := by decide

noncomputable def leafL_084_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,254}, reject := .fullRank { members := ![0,1,17,34,52,69,120,254], points := ![95,96,106,107,131,139], inverse := ![6,15,6,8,7,1,4,10,10,3,12,11,3,3,8,8,1,1,11,4,12,4,12,11,13,13,9,9,9,9,7,7,13,13,2,2] } }
theorem leafL_084_6_valid : (leafL_084_6).reject.ValidFor (leafL_084_6).leaf := by decide

noncomputable def leafL_084_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,259}, reject := .fullRank { members := ![0,1,17,34,52,69,120,259], points := ![91,94,96,106,137,139], inverse := ![12,6,3,14,11,13,15,2,3,9,13,10,15,3,12,0,0,0,12,5,6,8,7,0,13,0,13,0,15,15,0,7,7,0,7,7] } }
theorem leafL_084_7_valid : (leafL_084_7).reject.ValidFor (leafL_084_7).leaf := by decide

noncomputable def leavesL_084 : List RejectedLeaf := [leafL_084_0,leafL_084_1,leafL_084_2,leafL_084_3,leafL_084_4,leafL_084_5,leafL_084_6,leafL_084_7]

theorem leavesL_084_valid : LeafListValid leavesL_084 := by
  intro x hx
  simp only [leavesL_084, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_084_0_valid
  · exact leafL_084_1_valid
  · exact leafL_084_2_valid
  · exact leafL_084_3_valid
  · exact leafL_084_4_valid
  · exact leafL_084_5_valid
  · exact leafL_084_6_valid
  · exact leafL_084_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
