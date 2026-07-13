import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_159_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,205}, reject := .fullRank { members := ![0,1,17,34,52,71,90,205], points := ![99,101,124,126,127,131], inverse := ![8,15,4,12,1,15,7,0,2,11,7,9,0,0,4,12,8,0,12,11,15,14,14,8,14,14,2,7,5,0,12,12,12,12,0,0] } }
theorem leafL_159_0_valid : (leafL_159_0).reject.ValidFor (leafL_159_0).leaf := by decide

noncomputable def leafL_159_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,222}, reject := .fullRank { members := ![0,1,17,34,52,71,90,222], points := ![99,109,124,131,139,144], inverse := ![12,11,9,10,9,12,10,13,14,9,6,6,0,0,0,9,3,10,13,10,15,4,9,5,13,13,0,10,0,10,8,8,0,6,11,13] } }
theorem leafL_159_1_valid : (leafL_159_1).reject.ValidFor (leafL_159_1).leaf := by decide

noncomputable def leafL_159_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,229}, reject := .fullRank { members := ![0,1,17,34,52,71,90,229], points := ![104,109,126,131,147,150], inverse := ![10,4,13,12,0,14,15,9,6,15,2,13,10,5,1,4,15,5,12,4,14,12,12,6,8,6,9,2,15,10,3,5,5,7,13,9] } }
theorem leafL_159_2_valid : (leafL_159_2).reject.ValidFor (leafL_159_2).leaf := by decide

noncomputable def leafL_159_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,240}, reject := .fullRank { members := ![0,1,17,34,52,71,90,240], points := ![99,101,104,124,127,131], inverse := ![12,3,8,0,9,15,15,11,3,10,4,9,4,12,8,0,0,0,7,5,5,4,11,8,2,9,11,14,14,0,8,0,8,8,8,0] } }
theorem leafL_159_3_valid : (leafL_159_3).reject.ValidFor (leafL_159_3).leaf := by decide

noncomputable def leafL_159_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,269}, reject := .fullRank { members := ![0,1,17,34,52,71,90,269], points := ![104,124,131,133,150,155], inverse := ![9,0,1,12,4,1,10,12,5,4,6,1,10,15,2,11,1,13,4,4,0,2,15,13,5,14,3,14,11,13,14,9,5,7,8,13] } }
theorem leafL_159_4_valid : (leafL_159_4).reject.ValidFor (leafL_159_4).leaf := by decide

noncomputable def leafL_159_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,104}, reject := .fullRank { members := ![0,1,17,34,52,71,91,104], points := ![121,141,158,169,172,176], inverse := ![14,4,1,7,6,11,1,10,9,7,14,11,0,0,0,2,10,8,6,13,15,8,12,0,14,14,14,0,4,10,15,15,15,3,14,2] } }
theorem leafL_159_5_valid : (leafL_159_5).reject.ValidFor (leafL_159_5).leaf := by decide

noncomputable def leafL_159_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,106}, reject := .fullRank { members := ![0,1,17,34,52,71,91,106], points := ![121,147,150,168,169,172], inverse := ![10,5,0,6,1,9,11,11,8,5,15,2,0,0,0,15,9,6,11,6,4,2,8,3,0,3,3,15,0,15,0,6,6,9,12,5] } }
theorem leafL_159_6_valid : (leafL_159_6).reject.ValidFor (leafL_159_6).leaf := by decide

noncomputable def leafL_159_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,109}, reject := .fullRank { members := ![0,1,17,34,52,71,91,109], points := ![120,127,138,144,150,168], inverse := ![1,3,3,11,13,6,10,15,12,2,13,6,13,10,1,6,7,7,12,6,5,4,3,8,0,5,12,9,5,5,5,14,8,3,11,11] } }
theorem leafL_159_7_valid : (leafL_159_7).reject.ValidFor (leafL_159_7).leaf := by decide

noncomputable def leavesL_159 : List RejectedLeaf := [leafL_159_0,leafL_159_1,leafL_159_2,leafL_159_3,leafL_159_4,leafL_159_5,leafL_159_6,leafL_159_7]

theorem leavesL_159_valid : LeafListValid leavesL_159 := by
  intro x hx
  simp only [leavesL_159, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_159_0_valid
  · exact leafL_159_1_valid
  · exact leafL_159_2_valid
  · exact leafL_159_3_valid
  · exact leafL_159_4_valid
  · exact leafL_159_5_valid
  · exact leafL_159_6_valid
  · exact leafL_159_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
