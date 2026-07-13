import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_194_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,213}, reject := .fullRank { members := ![0,1,17,34,52,71,121,213], points := ![83,91,93,104,131,138], inverse := ![4,9,4,14,8,14,5,4,15,9,9,14,2,11,9,0,0,0,15,3,3,8,0,7,3,5,6,0,12,12,7,14,9,0,3,3] } }
theorem leafL_194_0_valid : (leafL_194_0).reject.ValidFor (leafL_194_0).leaf := by decide

noncomputable def leafL_194_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,222}, reject := .fullRank { members := ![0,1,17,34,52,71,121,222], points := ![83,93,96,106,131,139], inverse := ![13,8,12,14,6,0,14,9,9,9,14,9,12,1,13,0,0,0,8,14,9,8,5,2,9,1,8,0,7,7,10,3,9,0,5,5] } }
theorem leafL_194_1_valid : (leafL_194_1).reject.ValidFor (leafL_194_1).leaf := by decide

noncomputable def leafL_194_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,224}, reject := .fullRank { members := ![0,1,17,34,52,71,121,224], points := ![91,101,104,133,141,150], inverse := ![2,6,0,9,14,2,8,10,1,8,2,9,13,6,12,8,4,11,15,12,4,9,14,0,11,15,7,12,13,2,3,9,8,4,11,13] } }
theorem leafL_194_2_valid : (leafL_194_2).reject.ValidFor (leafL_194_2).leaf := by decide

noncomputable def leafL_194_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,237}, reject := .fullRank { members := ![0,1,17,34,52,71,121,237], points := ![83,90,91,104,106,131], inverse := ![11,7,5,0,14,6,13,8,11,7,14,7,6,3,5,0,0,0,9,12,10,15,7,7,12,5,9,12,12,0,8,10,2,3,3,0] } }
theorem leafL_194_3_valid : (leafL_194_3).reject.ValidFor (leafL_194_3).leaf := by decide

noncomputable def leafL_194_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,259}, reject := .fullRank { members := ![0,1,17,34,52,71,121,259], points := ![90,94,96,104,106,139], inverse := ![10,3,0,2,12,6,1,11,4,11,2,7,5,15,10,0,0,0,13,2,0,3,11,7,8,0,8,12,12,0,9,1,8,3,3,0] } }
theorem leafL_194_4_valid : (leafL_194_4).reject.ValidFor (leafL_194_4).leaf := by decide

noncomputable def leafL_194_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,262}, reject := .fullRank { members := ![0,1,17,34,52,71,121,262], points := ![83,91,96,106,133,138], inverse := ![1,7,15,14,9,15,3,15,2,9,0,7,9,3,10,0,0,0,9,13,11,8,15,8,10,4,14,0,1,1,13,0,13,0,13,13] } }
theorem leafL_194_5_valid : (leafL_194_5).reject.ValidFor (leafL_194_5).leaf := by decide

noncomputable def leafL_194_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,267}, reject := .fullRank { members := ![0,1,17,34,52,71,121,267], points := ![93,94,104,106,133,144], inverse := ![1,8,1,15,15,9,0,14,6,15,3,4,13,13,6,6,6,6,2,13,13,5,0,7,7,7,9,9,5,5,6,6,7,7,4,4] } }
theorem leafL_194_6_valid : (leafL_194_6).reject.ValidFor (leafL_194_6).leaf := by decide

noncomputable def leafL_194_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,271}, reject := .fullRank { members := ![0,1,17,34,52,71,121,271], points := ![90,91,93,104,131,138], inverse := ![3,7,13,14,8,14,7,0,9,9,9,14,8,12,4,0,0,0,9,15,9,8,0,7,12,8,4,0,12,12,15,13,2,0,3,3] } }
theorem leafL_194_7_valid : (leafL_194_7).reject.ValidFor (leafL_194_7).leaf := by decide

noncomputable def leavesL_194 : List RejectedLeaf := [leafL_194_0,leafL_194_1,leafL_194_2,leafL_194_3,leafL_194_4,leafL_194_5,leafL_194_6,leafL_194_7]

theorem leavesL_194_valid : LeafListValid leavesL_194 := by
  intro x hx
  simp only [leavesL_194, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_194_0_valid
  · exact leafL_194_1_valid
  · exact leafL_194_2_valid
  · exact leafL_194_3_valid
  · exact leafL_194_4_valid
  · exact leafL_194_5_valid
  · exact leafL_194_6_valid
  · exact leafL_194_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
