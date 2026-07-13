import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_055_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,247}, reject := .fullRank { members := ![0,1,17,34,52,69,96,247], points := ![99,107,120,126,127,137], inverse := ![7,0,0,9,0,15,5,2,13,10,9,9,0,0,11,4,15,0,11,12,6,11,2,8,13,13,15,10,5,0,5,5,7,13,10,0] } }
theorem leafL_055_0_valid : (leafL_055_0).reject.ValidFor (leafL_055_0).leaf := by decide

noncomputable def leafL_055_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,248}, reject := .fullRank { members := ![0,1,17,34,52,69,96,248], points := ![99,106,137,151,156,163], inverse := ![2,5,6,15,6,9,2,11,12,2,0,7,8,3,8,12,8,7,1,12,1,4,8,0,2,0,15,14,0,3,0,9,7,14,4,4] } }
theorem leafL_055_1_valid : (leafL_055_1).reject.ValidFor (leafL_055_1).leaf := by decide

noncomputable def leafL_055_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,254}, reject := .fullRank { members := ![0,1,17,34,52,69,96,254], points := ![103,106,107,120,122,131], inverse := ![6,12,13,13,4,15,1,14,8,11,5,9,15,9,6,0,0,0,5,8,10,7,8,8,11,5,14,5,5,0,12,14,2,1,1,0] } }
theorem leafL_055_2_valid : (leafL_055_2).reject.ValidFor (leafL_055_2).leaf := by decide

noncomputable def leafL_055_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,259}, reject := .fullRank { members := ![0,1,17,34,52,69,96,259], points := ![106,107,120,126,127,139], inverse := ![12,11,9,15,15,15,0,7,1,13,2,9,0,0,11,4,15,0,2,5,2,11,6,8,15,15,14,13,3,0,11,11,0,11,11,0] } }
theorem leafL_055_3_valid : (leafL_055_3).reject.ValidFor (leafL_055_3).leaf := by decide

noncomputable def leafL_055_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,262}, reject := .fullRank { members := ![0,1,17,34,52,69,96,262], points := ![99,103,106,126,127,137], inverse := ![7,0,0,9,0,15,14,1,8,15,1,9,12,2,14,0,0,0,3,0,4,10,5,8,10,0,10,1,1,0,5,1,4,11,11,0] } }
theorem leafL_055_4_valid : (leafL_055_4).reject.ValidFor (leafL_055_4).leaf := by decide

noncomputable def leafL_055_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,270}, reject := .fullRank { members := ![0,1,17,34,52,69,96,270], points := ![99,122,127,137,139,141], inverse := ![7,5,12,11,9,13,7,11,5,11,5,7,0,0,0,15,10,5,7,9,6,15,14,9,0,1,1,15,11,4,0,6,6,15,13,2] } }
theorem leafL_055_5_valid : (leafL_055_5).reject.ValidFor (leafL_055_5).leaf := by decide

noncomputable def leafL_055_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,271}, reject := .fullRank { members := ![0,1,17,34,52,69,96,271], points := ![99,103,122,126,137,156], inverse := ![7,0,0,9,15,0,1,8,1,6,11,5,1,6,11,6,1,11,11,10,3,9,15,4,13,2,14,15,4,10,10,10,10,10,0,0] } }
theorem leafL_055_6_valid : (leafL_055_6).reject.ValidFor (leafL_055_6).leaf := by decide

noncomputable def leafL_055_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,99,128}, reject := .fullRank { members := ![0,1,17,34,52,69,99,128], points := ![86,93,94,138,150,151], inverse := ![2,11,1,3,8,2,0,11,13,9,6,9,13,2,15,0,0,0,8,10,6,6,9,11,10,0,10,0,11,11,5,4,1,0,6,6] } }
theorem leafL_055_7_valid : (leafL_055_7).reject.ValidFor (leafL_055_7).leaf := by decide

noncomputable def leavesL_055 : List RejectedLeaf := [leafL_055_0,leafL_055_1,leafL_055_2,leafL_055_3,leafL_055_4,leafL_055_5,leafL_055_6,leafL_055_7]

theorem leavesL_055_valid : LeafListValid leavesL_055 := by
  intro x hx
  simp only [leavesL_055, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_055_0_valid
  · exact leafL_055_1_valid
  · exact leafL_055_2_valid
  · exact leafL_055_3_valid
  · exact leafL_055_4_valid
  · exact leafL_055_5_valid
  · exact leafL_055_6_valid
  · exact leafL_055_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
