import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_239_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,213,249}, reject := .fullRank { members := ![0,1,17,34,52,71,213,249], points := ![83,92,93,131,144,147], inverse := ![12,7,3,1,2,10,6,0,0,9,0,15,6,12,10,0,0,0,10,11,5,15,9,2,14,1,15,1,1,0,7,12,11,13,13,0] } }
theorem leafL_239_0_valid : (leafL_239_0).reject.ValidFor (leafL_239_0).leaf := by decide

noncomputable def leafL_239_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,213,268}, reject := .fullRank { members := ![0,1,17,34,52,71,213,268], points := ![93,104,110,126,127,128], inverse := ![15,7,15,3,11,14,9,4,10,10,14,3,0,0,0,7,14,9,8,13,2,13,4,14,0,11,11,15,14,1,0,4,4,13,7,10] } }
theorem leafL_239_1_valid : (leafL_239_1).reject.ValidFor (leafL_239_1).leaf := by decide

noncomputable def leafL_239_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,213,271}, reject := .fullRank { members := ![0,1,17,34,52,71,213,271], points := ![91,93,110,121,124,131], inverse := ![12,13,6,15,7,14,9,15,1,6,14,15,11,10,1,12,13,1,14,8,1,15,6,14,4,8,12,0,12,12,3,8,11,10,1,11] } }
theorem leafL_239_2_valid : (leafL_239_2).reject.ValidFor (leafL_239_2).leaf := by decide

noncomputable def leafL_239_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,214,249}, reject := .fullRank { members := ![0,1,17,34,52,71,214,249], points := ![90,92,93,101,109,131], inverse := ![4,9,4,2,12,6,3,11,6,11,2,7,12,3,15,0,0,0,9,14,8,3,11,7,4,12,8,9,9,0,8,4,12,15,15,0] } }
theorem leafL_239_3_valid : (leafL_239_3).reject.ValidFor (leafL_239_3).leaf := by decide

noncomputable def leafL_239_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,216,233}, reject := .fullRank { members := ![0,1,17,34,52,71,216,233], points := ![90,91,96,99,101,126], inverse := ![3,9,5,8,0,6,15,1,7,6,8,7,12,8,4,0,0,0,10,4,6,9,6,7,6,5,3,15,15,0,7,0,7,7,7,0] } }
theorem leafL_239_4_valid : (leafL_239_4).reject.ValidFor (leafL_239_4).leaf := by decide

noncomputable def leafL_239_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,216,239}, reject := .fullRank { members := ![0,1,17,34,52,71,216,239], points := ![90,91,99,122,126,128], inverse := ![12,3,8,9,14,1,13,4,14,9,3,13,0,0,0,5,15,10,10,2,15,4,14,13,1,1,0,5,14,11,7,7,0,11,3,8] } }
theorem leafL_239_5_valid : (leafL_239_5).reject.ValidFor (leafL_239_5).leaf := by decide

noncomputable def leafL_239_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,216,249}, reject := .fullRank { members := ![0,1,17,34,52,71,216,249], points := ![83,90,101,106,109,122], inverse := ![1,14,7,11,4,6,0,9,0,14,0,7,0,0,9,10,3,0,11,3,10,0,5,7,2,2,3,3,0,0,5,5,7,13,10,0] } }
theorem leafL_239_6_valid : (leafL_239_6).reject.ValidFor (leafL_239_6).leaf := by decide

noncomputable def leafL_239_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,216,262}, reject := .fullRank { members := ![0,1,17,34,52,71,216,262], points := ![83,90,91,99,109,126], inverse := ![14,11,10,8,0,6,15,8,14,1,15,7,6,3,5,0,0,0,13,15,10,6,9,7,12,5,9,12,12,0,8,10,2,3,3,0] } }
theorem leafL_239_7_valid : (leafL_239_7).reject.ValidFor (leafL_239_7).leaf := by decide

noncomputable def leavesL_239 : List RejectedLeaf := [leafL_239_0,leafL_239_1,leafL_239_2,leafL_239_3,leafL_239_4,leafL_239_5,leafL_239_6,leafL_239_7]

theorem leavesL_239_valid : LeafListValid leavesL_239 := by
  intro x hx
  simp only [leavesL_239, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_239_0_valid
  · exact leafL_239_1_valid
  · exact leafL_239_2_valid
  · exact leafL_239_3_valid
  · exact leafL_239_4_valid
  · exact leafL_239_5_valid
  · exact leafL_239_6_valid
  · exact leafL_239_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
