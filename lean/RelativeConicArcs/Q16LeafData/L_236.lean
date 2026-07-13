import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_236_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,203,217}, reject := .fullRank { members := ![0,1,17,34,52,71,203,217], points := ![96,99,109,110,131,141], inverse := ![9,8,2,4,8,14,14,13,6,2,8,15,0,11,3,8,0,0,15,3,15,4,9,14,0,5,12,9,14,14,0,8,8,0,8,8] } }
theorem leafL_236_0_valid : (leafL_236_0).reject.ValidFor (leafL_236_0).leaf := by decide

noncomputable def leafL_236_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,203,223}, reject := .fullRank { members := ![0,1,17,34,52,71,203,223], points := ![83,93,96,106,122,126], inverse := ![9,1,7,8,11,13,8,14,15,14,7,0,12,1,13,0,0,0,2,14,4,15,9,14,3,12,15,0,9,9,1,13,12,0,15,15] } }
theorem leafL_236_1_valid : (leafL_236_1).reject.ValidFor (leafL_236_1).leaf := by decide

noncomputable def leafL_236_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,203,233}, reject := .fullRank { members := ![0,1,17,34,52,71,203,233], points := ![90,93,99,106,109,126], inverse := ![14,1,7,1,14,6,12,5,10,7,3,7,0,0,15,1,14,0,1,9,10,10,15,7,1,1,6,15,9,0,11,11,0,11,11,0] } }
theorem leafL_236_2_valid : (leafL_236_2).reject.ValidFor (leafL_236_2).leaf := by decide

noncomputable def leafL_236_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,203,239}, reject := .fullRank { members := ![0,1,17,34,52,71,203,239], points := ![90,93,99,122,128,133], inverse := ![15,7,15,7,6,7,8,3,12,1,4,2,13,8,5,12,9,5,13,6,12,11,15,3,10,5,15,9,6,15,14,0,14,0,14,14] } }
theorem leafL_236_3_valid : (leafL_236_3).reject.ValidFor (leafL_236_3).leaf := by decide

noncomputable def leafL_236_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,203,243}, reject := .fullRank { members := ![0,1,17,34,52,71,203,243], points := ![90,93,106,127,133,140], inverse := ![9,12,2,12,14,4,5,9,11,2,1,4,13,6,11,11,10,1,4,7,4,12,1,10,7,15,8,8,4,12,0,15,15,15,0,15] } }
theorem leafL_236_4_valid : (leafL_236_4).reject.ValidFor (leafL_236_4).leaf := by decide

noncomputable def leafL_236_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,203,249}, reject := .fullRank { members := ![0,1,17,34,52,71,203,249], points := ![83,90,109,122,126,131], inverse := ![8,4,11,8,13,3,1,8,14,5,2,0,4,1,5,10,15,5,1,1,7,14,1,8,4,9,13,0,13,13,6,5,3,9,10,3] } }
theorem leafL_236_5_valid : (leafL_236_5).reject.ValidFor (leafL_236_5).leaf := by decide

noncomputable def leafL_236_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,203,259}, reject := .fullRank { members := ![0,1,17,34,52,71,203,259], points := ![90,96,106,110,126,127], inverse := ![12,3,6,14,5,3,5,12,2,12,10,13,9,9,9,9,14,14,7,15,5,10,4,3,15,15,6,6,11,11,6,6,12,12,15,15] } }
theorem leafL_236_6_valid : (leafL_236_6).reject.ValidFor (leafL_236_6).leaf := by decide

noncomputable def leafL_236_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,203,262}, reject := .fullRank { members := ![0,1,17,34,52,71,203,262], points := ![83,90,96,99,106,126], inverse := ![12,14,13,8,0,6,9,12,12,12,2,7,7,8,15,0,0,0,2,6,12,7,8,7,6,5,3,7,7,0,5,5,0,5,5,0] } }
theorem leafL_236_7_valid : (leafL_236_7).reject.ValidFor (leafL_236_7).leaf := by decide

noncomputable def leavesL_236 : List RejectedLeaf := [leafL_236_0,leafL_236_1,leafL_236_2,leafL_236_3,leafL_236_4,leafL_236_5,leafL_236_6,leafL_236_7]

theorem leavesL_236_valid : LeafListValid leavesL_236 := by
  intro x hx
  simp only [leavesL_236, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_236_0_valid
  · exact leafL_236_1_valid
  · exact leafL_236_2_valid
  · exact leafL_236_3_valid
  · exact leafL_236_4_valid
  · exact leafL_236_5_valid
  · exact leafL_236_6_valid
  · exact leafL_236_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
