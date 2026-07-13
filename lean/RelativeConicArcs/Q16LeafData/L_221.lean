import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_221_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,168,259}, reject := .fullRank { members := ![0,1,17,34,52,71,168,259], points := ![90,92,96,106,121,124], inverse := ![1,11,5,8,10,12,15,5,3,14,11,12,10,15,5,0,0,0,10,13,15,15,1,6,8,8,0,0,15,15,8,3,11,0,7,7] } }
theorem leafL_221_0_valid : (leafL_221_0).reject.ValidFor (leafL_221_0).leaf := by decide

noncomputable def leafL_221_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,168,267}, reject := .fullRank { members := ![0,1,17,34,52,71,168,267], points := ![93,101,106,121,122,144], inverse := ![13,1,11,4,0,2,3,1,5,11,6,10,14,1,15,12,2,14,10,14,3,2,7,2,6,2,4,2,4,6,13,9,4,11,6,13] } }
theorem leafL_221_1_valid : (leafL_221_1).reject.ValidFor (leafL_221_1).leaf := by decide

noncomputable def leafL_221_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,168,271}, reject := .fullRank { members := ![0,1,17,34,52,71,168,271], points := ![90,91,96,109,110,121], inverse := ![12,9,10,8,0,6,13,5,1,3,13,7,12,8,4,0,0,0,5,7,10,14,1,7,14,4,10,4,4,0,5,13,8,1,1,0] } }
theorem leafL_221_2_valid : (leafL_221_2).reject.ValidFor (leafL_221_2).leaf := by decide

noncomputable def leafL_221_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,169,208}, reject := .fullRank { members := ![0,1,17,34,52,71,169,208], points := ![94,124,133,141,155,158], inverse := ![7,14,12,4,8,8,1,10,13,2,11,15,15,14,12,7,10,0,1,11,13,3,10,14,10,5,0,3,4,8,15,14,13,6,15,5] } }
theorem leafL_221_3_valid : (leafL_221_3).reject.ValidFor (leafL_221_3).leaf := by decide

noncomputable def leafL_221_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,169,223}, reject := .fullRank { members := ![0,1,17,34,52,71,169,223], points := ![94,99,104,106,122,139], inverse := ![14,5,10,6,7,1,8,13,5,7,6,1,0,1,14,15,0,0,6,15,8,6,9,14,11,12,11,12,11,11,9,5,14,2,9,9] } }
theorem leafL_221_4_valid : (leafL_221_4).reject.ValidFor (leafL_221_4).leaf := by decide

noncomputable def leafL_221_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,169,232}, reject := .fullRank { members := ![0,1,17,34,52,71,169,232], points := ![92,106,127,128,141,144], inverse := ![6,1,9,6,8,1,9,14,2,5,15,15,9,9,0,9,14,7,6,1,13,4,0,14,15,15,7,8,8,7,1,1,1,0,1,0] } }
theorem leafL_221_5_valid : (leafL_221_5).reject.ValidFor (leafL_221_5).leaf := by decide

noncomputable def leafL_221_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,169,243}, reject := .fullRank { members := ![0,1,17,34,52,71,169,243], points := ![94,104,106,124,127,128], inverse := ![15,2,10,10,6,10,9,4,10,9,12,2,0,0,0,6,11,13,8,5,10,5,3,1,0,6,6,14,14,0,0,1,1,13,15,2] } }
theorem leafL_221_6_valid : (leafL_221_6).reject.ValidFor (leafL_221_6).leaf := by decide

noncomputable def leafL_221_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,169,246}, reject := .fullRank { members := ![0,1,17,34,52,71,169,246], points := ![92,94,96,104,124,127], inverse := ![11,1,5,8,6,0,6,14,1,14,2,5,5,10,15,0,0,0,15,14,9,15,0,7,9,9,0,0,5,5,4,5,1,0,12,12] } }
theorem leafL_221_7_valid : (leafL_221_7).reject.ValidFor (leafL_221_7).leaf := by decide

noncomputable def leavesL_221 : List RejectedLeaf := [leafL_221_0,leafL_221_1,leafL_221_2,leafL_221_3,leafL_221_4,leafL_221_5,leafL_221_6,leafL_221_7]

theorem leavesL_221_valid : LeafListValid leavesL_221 := by
  intro x hx
  simp only [leavesL_221, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_221_0_valid
  · exact leafL_221_1_valid
  · exact leafL_221_2_valid
  · exact leafL_221_3_valid
  · exact leafL_221_4_valid
  · exact leafL_221_5_valid
  · exact leafL_221_6_valid
  · exact leafL_221_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
