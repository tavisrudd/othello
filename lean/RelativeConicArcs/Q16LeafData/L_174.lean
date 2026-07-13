import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_174_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,96,188}, reject := .fullRank { members := ![0,1,17,34,52,71,96,188], points := ![106,131,141,159,166,205], inverse := ![1,14,2,10,10,12,9,9,15,9,9,15,2,9,2,15,0,6,1,7,13,9,3,1,6,7,14,7,15,7,3,10,12,12,4,13] } }
theorem leafL_174_0_valid : (leafL_174_0).reject.ValidFor (leafL_174_0).leaf := by decide

noncomputable def leafL_174_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,96,216}, reject := .fullRank { members := ![0,1,17,34,52,71,96,216], points := ![99,101,106,127,131,140], inverse := ![0,0,7,9,15,0,6,2,3,14,5,12,8,15,7,0,0,0,3,9,13,15,1,9,13,5,8,0,5,5,3,15,12,0,1,1] } }
theorem leafL_174_1_valid : (leafL_174_1).reject.ValidFor (leafL_174_1).leaf := by decide

noncomputable def leafL_174_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,96,217}, reject := .fullRank { members := ![0,1,17,34,52,71,96,217], points := ![99,120,131,141,154,156], inverse := ![6,1,9,0,13,2,14,10,12,6,9,7,7,13,11,10,3,8,0,2,3,10,0,11,5,14,1,12,11,13,3,11,9,3,9,11] } }
theorem leafL_174_2_valid : (leafL_174_2).reject.ValidFor (leafL_174_2).leaf := by decide

noncomputable def leafL_174_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,96,271}, reject := .fullRank { members := ![0,1,17,34,52,71,96,271], points := ![121,126,131,140,141,147], inverse := ![4,0,14,14,14,11,5,6,9,2,3,11,0,0,6,12,10,0,3,1,13,4,0,11,4,4,3,1,2,0,11,11,12,13,1,0] } }
theorem leafL_174_3_valid : (leafL_174_3).reject.ValidFor (leafL_174_3).leaf := by decide

noncomputable def leafL_174_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,126}, reject := .fullRank { members := ![0,1,17,34,52,71,101,126], points := ![90,92,96,131,138,147], inverse := ![13,13,8,8,11,10,14,11,3,9,0,15,10,15,5,0,0,0,13,8,1,0,6,2,13,1,12,12,12,0,4,12,8,3,3,0] } }
theorem leafL_174_4_valid : (leafL_174_4).reject.ValidFor (leafL_174_4).leaf := by decide

noncomputable def leafL_174_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,128}, reject := .fullRank { members := ![0,1,17,34,52,71,101,128], points := ![83,94,131,138,139,147], inverse := ![15,7,7,5,1,10,6,0,9,0,0,15,0,0,6,3,5,0,5,1,3,14,11,2,10,10,14,13,3,0,9,9,11,7,12,0] } }
theorem leafL_174_5_valid : (leafL_174_5).reject.ValidFor (leafL_174_5).leaf := by decide

noncomputable def leafL_174_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,131}, reject := .fullRank { members := ![0,1,17,34,52,71,101,131], points := ![90,92,94,121,126,150], inverse := ![14,7,11,10,15,6,1,3,7,13,5,13,15,10,5,0,0,0,15,10,6,10,0,9,0,9,9,5,5,0,1,5,4,12,12,0] } }
theorem leafL_174_6_valid : (leafL_174_6).reject.ValidFor (leafL_174_6).leaf := by decide

noncomputable def leafL_174_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,139}, reject := .fullRank { members := ![0,1,17,34,52,71,101,139], points := ![90,92,93,121,124,150], inverse := ![4,3,5,7,2,6,2,6,1,7,15,13,12,3,15,0,0,0,13,4,10,10,0,9,8,8,0,15,15,0,11,5,14,7,7,0] } }
theorem leafL_174_7_valid : (leafL_174_7).reject.ValidFor (leafL_174_7).leaf := by decide

noncomputable def leavesL_174 : List RejectedLeaf := [leafL_174_0,leafL_174_1,leafL_174_2,leafL_174_3,leafL_174_4,leafL_174_5,leafL_174_6,leafL_174_7]

theorem leavesL_174_valid : LeafListValid leavesL_174 := by
  intro x hx
  simp only [leavesL_174, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_174_0_valid
  · exact leafL_174_1_valid
  · exact leafL_174_2_valid
  · exact leafL_174_3_valid
  · exact leafL_174_4_valid
  · exact leafL_174_5_valid
  · exact leafL_174_6_valid
  · exact leafL_174_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
