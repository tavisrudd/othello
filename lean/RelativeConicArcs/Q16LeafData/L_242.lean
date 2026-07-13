import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_242_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,223,249}, reject := .fullRank { members := ![0,1,17,34,52,71,223,249], points := ![83,90,93,101,104,122], inverse := ![6,3,10,8,0,6,4,15,2,8,6,7,15,1,14,0,0,0,10,11,9,4,11,7,5,15,10,13,13,0,4,13,9,14,14,0] } }
theorem leafL_242_0_valid : (leafL_242_0).reject.ValidFor (leafL_242_0).leaf := by decide

noncomputable def leafL_242_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,223,253}, reject := .fullRank { members := ![0,1,17,34,52,71,223,253], points := ![83,90,99,121,122,126], inverse := ![2,13,8,5,9,10,9,0,14,12,9,2,0,0,0,11,13,6,13,5,15,15,3,11,15,15,0,15,1,14,11,11,0,8,5,13] } }
theorem leafL_242_1_valid : (leafL_242_1).reject.ValidFor (leafL_242_1).leaf := by decide

noncomputable def leafL_242_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,223,267}, reject := .fullRank { members := ![0,1,17,34,52,71,223,267], points := ![94,99,101,104,121,122], inverse := ![15,1,1,8,15,9,9,7,11,2,15,8,0,4,12,8,0,0,8,15,0,0,5,2,0,7,6,1,3,3,0,9,3,10,14,14] } }
theorem leafL_242_2_valid : (leafL_242_2).reject.ValidFor (leafL_242_2).leaf := by decide

noncomputable def leafL_242_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,224,235}, reject := .fullRank { members := ![0,1,17,34,52,71,224,235], points := ![93,99,120,121,122,150], inverse := ![12,2,14,10,5,14,14,15,6,7,4,4,0,0,11,8,3,0,0,10,8,9,12,7,3,10,8,1,14,14,9,3,9,13,2,12] } }
theorem leafL_242_3_valid : (leafL_242_3).reject.ValidFor (leafL_242_3).leaf := by decide

noncomputable def leafL_242_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,224,237}, reject := .fullRank { members := ![0,1,17,34,52,71,224,237], points := ![91,92,121,122,124,133], inverse := ![7,0,9,11,12,8,11,12,15,6,0,14,0,0,14,9,7,0,9,14,1,0,9,15,3,3,12,11,7,0,9,9,9,9,0,0] } }
theorem leafL_242_4_valid : (leafL_242_4).reject.ValidFor (leafL_242_4).leaf := by decide

noncomputable def leafL_242_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,224,249}, reject := .fullRank { members := ![0,1,17,34,52,71,224,249], points := ![92,93,101,104,109,122], inverse := ![8,7,1,7,14,6,15,6,7,3,10,7,0,0,5,3,6,0,1,9,1,8,6,7,13,13,10,1,11,0,6,6,9,2,11,0] } }
theorem leafL_242_5_valid : (leafL_242_5).reject.ValidFor (leafL_242_5).leaf := by decide

noncomputable def leafL_242_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,224,253}, reject := .fullRank { members := ![0,1,17,34,52,71,224,253], points := ![99,104,120,121,122,133], inverse := ![11,12,2,12,7,15,12,11,5,9,2,9,0,0,11,8,3,0,10,13,0,10,5,8,5,5,12,7,11,0,8,8,6,12,10,0] } }
theorem leafL_242_6_valid : (leafL_242_6).reject.ValidFor (leafL_242_6).leaf := by decide

noncomputable def leafL_242_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,232,249}, reject := .fullRank { members := ![0,1,17,34,52,71,232,249], points := ![83,92,94,101,126,141], inverse := ![6,10,10,1,15,9,13,9,15,12,5,2,3,14,13,0,0,0,2,12,1,8,0,7,4,1,0,5,5,5,10,1,7,12,12,12] } }
theorem leafL_242_7_valid : (leafL_242_7).reject.ValidFor (leafL_242_7).leaf := by decide

noncomputable def leavesL_242 : List RejectedLeaf := [leafL_242_0,leafL_242_1,leafL_242_2,leafL_242_3,leafL_242_4,leafL_242_5,leafL_242_6,leafL_242_7]

theorem leavesL_242_valid : LeafListValid leavesL_242 := by
  intro x hx
  simp only [leavesL_242, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_242_0_valid
  · exact leafL_242_1_valid
  · exact leafL_242_2_valid
  · exact leafL_242_3_valid
  · exact leafL_242_4_valid
  · exact leafL_242_5_valid
  · exact leafL_242_6_valid
  · exact leafL_242_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
