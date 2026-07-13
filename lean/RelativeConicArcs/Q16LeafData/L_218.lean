import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_218_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,159,171}, reject := .fullRank { members := ![0,1,17,34,52,71,159,171], points := ![83,106,109,120,124,133], inverse := ![12,2,9,10,15,3,5,10,8,5,14,12,5,12,9,1,4,5,9,15,1,15,9,1,12,6,10,0,12,12,8,10,2,1,9,8] } }
theorem leafL_218_0_valid : (leafL_218_0).reject.ValidFor (leafL_218_0).leaf := by decide

noncomputable def leafL_218_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,159,205}, reject := .fullRank { members := ![0,1,17,34,52,71,159,205], points := ![96,104,120,122,131,169], inverse := ![11,9,12,6,15,6,10,1,1,7,5,8,4,11,14,1,10,10,1,2,8,9,11,9,15,3,0,13,9,8,14,4,13,0,11,12] } }
theorem leafL_218_1_valid : (leafL_218_1).reject.ValidFor (leafL_218_1).leaf := by decide

noncomputable def leafL_218_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,159,222}, reject := .fullRank { members := ![0,1,17,34,52,71,159,222], points := ![83,93,96,106,109,121], inverse := ![15,15,15,0,8,6,7,5,11,6,8,7,12,1,13,0,0,0,3,14,5,11,4,7,10,11,1,10,10,0,14,8,6,11,11,0] } }
theorem leafL_218_2_valid : (leafL_218_2).reject.ValidFor (leafL_218_2).leaf := by decide

noncomputable def leafL_218_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,159,235}, reject := .fullRank { members := ![0,1,17,34,52,71,159,235], points := ![83,93,110,120,122,124], inverse := ![14,1,8,5,10,9,8,1,14,11,6,10,0,0,0,13,8,5,9,1,15,14,5,12,5,5,0,12,15,3,8,8,0,8,8,0] } }
theorem leafL_218_3_valid : (leafL_218_3).reject.ValidFor (leafL_218_3).leaf := by decide

noncomputable def leafL_218_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,159,243}, reject := .fullRank { members := ![0,1,17,34,52,71,159,243], points := ![93,106,121,124,133,144], inverse := ![5,2,12,0,3,9,3,4,8,5,7,13,15,15,12,3,14,1,6,1,4,13,10,4,4,4,2,6,15,11,1,1,4,5,12,13] } }
theorem leafL_218_4_valid : (leafL_218_4).reject.ValidFor (leafL_218_4).leaf := by decide

noncomputable def leafL_218_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,159,249}, reject := .fullRank { members := ![0,1,17,34,52,71,159,249], points := ![92,93,104,106,109,120], inverse := ![15,0,4,5,9,6,14,7,4,5,15,7,0,0,15,14,1,0,0,8,7,0,8,7,13,13,10,15,5,0,6,6,13,4,9,0] } }
theorem leafL_218_5_valid : (leafL_218_5).reject.ValidFor (leafL_218_5).leaf := by decide

noncomputable def leafL_218_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,159,262}, reject := .fullRank { members := ![0,1,17,34,52,71,159,262], points := ![83,92,96,109,110,120], inverse := ![0,15,0,0,8,6,15,4,2,6,8,7,8,9,1,0,0,0,15,3,4,11,4,7,11,4,15,4,4,0,14,6,8,1,1,0] } }
theorem leafL_218_6_valid : (leafL_218_6).reject.ValidFor (leafL_218_6).leaf := by decide

noncomputable def leafL_218_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,159,267}, reject := .fullRank { members := ![0,1,17,34,52,71,159,267], points := ![92,93,104,106,120,121], inverse := ![5,10,12,4,14,8,5,12,6,8,5,2,7,7,12,12,3,3,13,5,12,3,12,11,5,5,5,5,15,15,12,12,5,5,8,8] } }
theorem leafL_218_7_valid : (leafL_218_7).reject.ValidFor (leafL_218_7).leaf := by decide

noncomputable def leavesL_218 : List RejectedLeaf := [leafL_218_0,leafL_218_1,leafL_218_2,leafL_218_3,leafL_218_4,leafL_218_5,leafL_218_6,leafL_218_7]

theorem leavesL_218_valid : LeafListValid leavesL_218 := by
  intro x hx
  simp only [leavesL_218, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_218_0_valid
  · exact leafL_218_1_valid
  · exact leafL_218_2_valid
  · exact leafL_218_3_valid
  · exact leafL_218_4_valid
  · exact leafL_218_5_valid
  · exact leafL_218_6_valid
  · exact leafL_218_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
