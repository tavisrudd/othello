import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_237_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,205,213}, reject := .fullRank { members := ![0,1,17,34,52,71,205,213], points := ![99,104,124,126,127,131], inverse := ![13,10,1,3,11,15,7,0,2,11,7,9,0,0,4,12,8,0,4,3,7,5,13,8,5,5,9,9,0,0,8,8,8,0,8,0] } }
theorem leafL_237_0_valid : (leafL_237_0).reject.ValidFor (leafL_237_0).leaf := by decide

noncomputable def leafL_237_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,205,217}, reject := .fullRank { members := ![0,1,17,34,52,71,205,217], points := ![91,94,99,104,120,122], inverse := ![0,15,15,7,2,4,9,0,2,12,8,15,14,14,7,7,12,12,2,10,14,1,1,6,8,8,1,1,8,8,9,9,5,5,11,11] } }
theorem leafL_237_1_valid : (leafL_237_1).reject.ValidFor (leafL_237_1).leaf := by decide

noncomputable def leafL_237_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,205,222}, reject := .fullRank { members := ![0,1,17,34,52,71,205,222], points := ![90,96,99,106,124,150], inverse := ![5,2,9,4,12,7,9,7,3,12,5,4,2,0,9,5,11,5,15,13,6,0,6,2,6,8,13,15,4,8,14,7,10,9,6,12] } }
theorem leafL_237_2_valid : (leafL_237_2).reject.ValidFor (leafL_237_2).leaf := by decide

noncomputable def leafL_237_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,205,224}, reject := .fullRank { members := ![0,1,17,34,52,71,205,224], points := ![91,99,101,104,122,124], inverse := ![15,1,0,9,12,10,9,9,14,9,10,13,0,4,12,8,0,0,8,12,9,10,9,14,0,0,15,15,8,8,0,13,15,2,7,7] } }
theorem leafL_237_3_valid : (leafL_237_3).reject.ValidFor (leafL_237_3).leaf := by decide

noncomputable def leafL_237_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,205,239}, reject := .fullRank { members := ![0,1,17,34,52,71,205,239], points := ![91,94,99,122,126,131], inverse := ![8,15,0,13,3,8,2,11,14,6,1,0,2,11,9,10,3,9,4,13,14,12,10,1,8,1,9,3,10,9,0,4,4,0,4,4] } }
theorem leafL_237_4_valid : (leafL_237_4).reject.ValidFor (leafL_237_4).leaf := by decide

noncomputable def leafL_237_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,205,249}, reject := .fullRank { members := ![0,1,17,34,52,71,205,249], points := ![90,94,101,104,106,122], inverse := ![9,6,2,14,4,6,9,0,0,0,14,7,0,0,13,1,12,0,7,15,12,13,14,7,12,12,11,6,13,0,13,13,11,9,2,0] } }
theorem leafL_237_5_valid : (leafL_237_5).reject.ValidFor (leafL_237_5).leaf := by decide

noncomputable def leafL_237_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,205,259}, reject := .fullRank { members := ![0,1,17,34,52,71,205,259], points := ![90,94,96,104,106,124], inverse := ![11,10,14,8,0,6,7,8,6,2,12,7,5,15,10,0,0,0,11,1,2,10,5,7,8,0,8,12,12,0,9,1,8,3,3,0] } }
theorem leafL_237_6_valid : (leafL_237_6).reject.ValidFor (leafL_237_6).leaf := by decide

noncomputable def leafL_237_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,205,267}, reject := .fullRank { members := ![0,1,17,34,52,71,205,267], points := ![99,101,104,120,122,133], inverse := ![13,10,0,5,12,15,1,4,2,13,3,9,4,12,8,0,0,0,15,15,7,13,2,8,15,13,2,5,5,0,14,10,4,1,1,0] } }
theorem leafL_237_7_valid : (leafL_237_7).reject.ValidFor (leafL_237_7).leaf := by decide

noncomputable def leavesL_237 : List RejectedLeaf := [leafL_237_0,leafL_237_1,leafL_237_2,leafL_237_3,leafL_237_4,leafL_237_5,leafL_237_6,leafL_237_7]

theorem leavesL_237_valid : LeafListValid leavesL_237 := by
  intro x hx
  simp only [leavesL_237, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_237_0_valid
  · exact leafL_237_1_valid
  · exact leafL_237_2_valid
  · exact leafL_237_3_valid
  · exact leafL_237_4_valid
  · exact leafL_237_5_valid
  · exact leafL_237_6_valid
  · exact leafL_237_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
