import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_053_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,173}, reject := .fullRank { members := ![0,1,17,34,52,69,96,173], points := ![103,106,107,122,126,131], inverse := ![7,8,8,2,11,15,11,0,12,12,2,9,15,9,6,0,0,0,10,1,12,12,3,8,12,10,6,4,4,0,8,13,5,10,10,0] } }
theorem leafL_053_0_valid : (leafL_053_0).reject.ValidFor (leafL_053_0).leaf := by decide

noncomputable def leafL_053_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,175}, reject := .fullRank { members := ![0,1,17,34,52,69,96,175], points := ![106,107,122,126,131,141], inverse := ![6,1,10,3,0,15,5,2,13,3,3,10,4,4,6,6,9,9,6,1,8,7,6,14,1,1,13,13,5,5,14,14,4,4,6,6] } }
theorem leafL_053_1_valid : (leafL_053_1).reject.ValidFor (leafL_053_1).leaf := by decide

noncomputable def leafL_053_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,182}, reject := .fullRank { members := ![0,1,17,34,52,69,96,182], points := ![103,106,107,122,126,131], inverse := ![7,8,8,2,11,15,11,0,12,12,2,9,15,9,6,0,0,0,10,1,12,12,3,8,12,10,6,4,4,0,8,13,5,10,10,0] } }
theorem leafL_053_2_valid : (leafL_053_2).reject.ValidFor (leafL_053_2).leaf := by decide

noncomputable def leafL_053_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,186}, reject := .fullRank { members := ![0,1,17,34,52,69,96,186], points := ![99,103,107,127,137,141], inverse := ![3,7,3,9,12,3,6,8,9,14,13,4,7,11,12,0,0,0,1,0,6,15,1,9,4,1,5,0,6,6,15,15,0,0,15,15] } }
theorem leafL_053_3_valid : (leafL_053_3).reject.ValidFor (leafL_053_3).leaf := by decide

noncomputable def leafL_053_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,189}, reject := .fullRank { members := ![0,1,17,34,52,69,96,189], points := ![99,106,120,122,127,131], inverse := ![0,7,0,0,9,15,7,0,9,3,4,9,0,0,6,10,12,0,1,6,4,13,6,8,10,10,14,11,5,0,3,3,11,12,7,0] } }
theorem leafL_053_4_valid : (leafL_053_4).reject.ValidFor (leafL_053_4).leaf := by decide

noncomputable def leafL_053_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,190}, reject := .fullRank { members := ![0,1,17,34,52,69,96,190], points := ![103,107,120,122,127,137], inverse := ![11,12,1,6,14,15,6,1,3,9,4,9,0,0,6,10,12,0,3,4,10,5,0,8,7,7,12,13,1,0,6,6,5,13,8,0] } }
theorem leafL_053_5_valid : (leafL_053_5).reject.ValidFor (leafL_053_5).leaf := by decide

noncomputable def leafL_053_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,201}, reject := .fullRank { members := ![0,1,17,34,52,69,96,201], points := ![103,106,120,122,126,139], inverse := ![9,14,10,7,4,15,4,3,7,7,14,9,0,0,7,4,3,0,1,6,6,1,8,8,3,3,7,0,7,0,9,9,13,12,1,0] } }
theorem leafL_053_6_valid : (leafL_053_6).reject.ValidFor (leafL_053_6).leaf := by decide

noncomputable def leafL_053_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,203}, reject := .fullRank { members := ![0,1,17,34,52,69,96,203], points := ![99,103,122,126,127,131], inverse := ![6,1,4,5,8,15,7,0,4,8,2,9,0,0,8,10,2,0,0,7,15,4,4,8,9,9,2,10,8,0,10,10,10,10,0,0] } }
theorem leafL_053_7_valid : (leafL_053_7).reject.ValidFor (leafL_053_7).leaf := by decide

noncomputable def leavesL_053 : List RejectedLeaf := [leafL_053_0,leafL_053_1,leafL_053_2,leafL_053_3,leafL_053_4,leafL_053_5,leafL_053_6,leafL_053_7]

theorem leavesL_053_valid : LeafListValid leavesL_053 := by
  intro x hx
  simp only [leavesL_053, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_053_0_valid
  · exact leafL_053_1_valid
  · exact leafL_053_2_valid
  · exact leafL_053_3_valid
  · exact leafL_053_4_valid
  · exact leafL_053_5_valid
  · exact leafL_053_6_valid
  · exact leafL_053_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
