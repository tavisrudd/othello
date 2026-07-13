import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_163_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,246}, reject := .fullRank { members := ![0,1,17,34,52,71,91,246], points := ![104,109,110,120,121,138], inverse := ![6,7,6,8,1,15,15,3,11,9,7,9,9,5,12,0,0,0,14,14,7,12,3,8,0,2,2,11,11,0,12,15,3,9,9,0] } }
theorem leafL_163_0_valid : (leafL_163_0).reject.ValidFor (leafL_163_0).leaf := by decide

noncomputable def leafL_163_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,248}, reject := .fullRank { members := ![0,1,17,34,52,71,91,248], points := ![99,109,121,138,147,154], inverse := ![0,12,14,0,3,0,0,11,4,7,2,10,15,2,2,8,1,6,10,2,14,12,13,7,14,6,12,5,14,15,7,2,14,13,0,6] } }
theorem leafL_163_1_valid : (leafL_163_1).reject.ValidFor (leafL_163_1).leaf := by decide

noncomputable def leafL_163_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,262}, reject := .fullRank { members := ![0,1,17,34,52,71,91,262], points := ![99,106,110,120,121,138], inverse := ![5,2,0,8,1,15,8,10,5,9,7,9,14,12,2,0,0,0,14,14,7,12,3,8,6,8,14,11,11,0,9,0,9,9,9,0] } }
theorem leafL_163_2_valid : (leafL_163_2).reject.ValidFor (leafL_163_2).leaf := by decide

noncomputable def leafL_163_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,268}, reject := .fullRank { members := ![0,1,17,34,52,71,91,268], points := ![104,109,110,122,127,144], inverse := ![12,2,9,15,6,15,8,1,14,2,12,9,9,5,12,0,0,0,4,5,6,9,6,8,12,3,15,10,10,0,1,4,5,2,2,0] } }
theorem leafL_163_3_valid : (leafL_163_3).reject.ValidFor (leafL_163_3).leaf := by decide

noncomputable def leafL_163_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,269}, reject := .fullRank { members := ![0,1,17,34,52,71,91,269], points := ![110,120,138,144,147,150], inverse := ![12,14,0,0,0,3,2,0,13,9,13,11,14,9,11,9,0,5,15,3,15,2,5,4,8,12,11,14,8,9,9,4,10,9,5,11] } }
theorem leafL_163_4_valid : (leafL_163_4).reject.ValidFor (leafL_163_4).leaf := by decide

noncomputable def leafL_163_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,271}, reject := .fullRank { members := ![0,1,17,34,52,71,91,271], points := ![104,109,121,122,138,141], inverse := ![6,1,4,13,13,2,10,13,7,9,15,6,8,8,14,14,12,12,9,14,1,14,9,1,15,15,1,1,14,14,6,6,12,12,14,14] } }
theorem leafL_163_5_valid : (leafL_163_5).reject.ValidFor (leafL_163_5).leaf := by decide

noncomputable def leafL_163_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,109}, reject := .fullRank { members := ![0,1,17,34,52,71,92,109], points := ![127,138,155,159,168,171], inverse := ![1,11,11,5,15,10,1,10,13,4,14,12,6,6,10,12,3,5,12,7,3,6,15,1,0,0,15,15,6,6,3,3,8,11,12,15] } }
theorem leafL_163_6_valid : (leafL_163_6).reject.ValidFor (leafL_163_6).leaf := by decide

noncomputable def leafL_163_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,126}, reject := .fullRank { members := ![0,1,17,34,52,71,92,126], points := ![101,104,131,138,139,147], inverse := ![4,13,5,7,15,5,6,4,7,8,11,6,0,0,6,3,5,0,10,7,3,15,13,12,6,6,10,13,7,0,7,7,0,7,7,0] } }
theorem leafL_163_7_valid : (leafL_163_7).reject.ValidFor (leafL_163_7).leaf := by decide

noncomputable def leavesL_163 : List RejectedLeaf := [leafL_163_0,leafL_163_1,leafL_163_2,leafL_163_3,leafL_163_4,leafL_163_5,leafL_163_6,leafL_163_7]

theorem leavesL_163_valid : LeafListValid leavesL_163 := by
  intro x hx
  simp only [leavesL_163, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_163_0_valid
  · exact leafL_163_1_valid
  · exact leafL_163_2_valid
  · exact leafL_163_3_valid
  · exact leafL_163_4_valid
  · exact leafL_163_5_valid
  · exact leafL_163_6_valid
  · exact leafL_163_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
