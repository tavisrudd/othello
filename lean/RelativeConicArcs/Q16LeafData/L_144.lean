import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_144_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,243}, reject := .fullRank { members := ![0,1,17,34,52,70,107,243], points := ![94,96,122,127,133,140], inverse := ![8,15,0,14,6,14,4,3,12,5,9,7,10,10,3,3,9,9,15,8,10,2,1,14,7,7,7,7,4,4,15,15,13,13,12,12] } }
theorem leafL_144_0_valid : (leafL_144_0).reject.ValidFor (leafL_144_0).leaf := by decide

noncomputable def leafL_144_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,247}, reject := .fullRank { members := ![0,1,17,34,52,70,107,247], points := ![83,96,120,124,126,131], inverse := ![12,11,12,0,2,8,7,0,7,5,11,14,0,0,1,3,2,0,3,4,2,6,12,15,12,12,8,5,13,0,2,2,12,13,1,0] } }
theorem leafL_144_1_valid : (leafL_144_1).reject.ValidFor (leafL_144_1).leaf := by decide

noncomputable def leafL_144_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,249}, reject := .fullRank { members := ![0,1,17,34,52,70,107,249], points := ![94,95,115,122,126,131], inverse := ![13,10,14,1,1,8,15,8,3,3,9,14,0,0,14,12,2,0,1,6,14,12,10,15,1,1,10,10,0,0,7,7,6,14,8,0] } }
theorem leafL_144_2_valid : (leafL_144_2).reject.ValidFor (leafL_144_2).leaf := by decide

noncomputable def leafL_144_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,263}, reject := .fullRank { members := ![0,1,17,34,52,70,107,263], points := ![94,95,96,115,120,149], inverse := ![7,7,2,4,1,6,8,2,15,9,1,13,7,14,9,0,0,0,1,14,12,3,9,9,10,4,14,5,5,0,14,6,8,12,12,0] } }
theorem leafL_144_3_valid : (leafL_144_3).reject.ValidFor (leafL_144_3).leaf := by decide

noncomputable def leafL_144_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,269}, reject := .fullRank { members := ![0,1,17,34,52,70,107,269], points := ![83,96,115,126,133,140], inverse := ![3,4,12,2,15,7,5,2,5,12,5,11,2,2,12,12,8,8,3,4,0,8,9,6,13,13,5,5,4,4,0,0,8,8,8,8] } }
theorem leafL_144_4_valid : (leafL_144_4).reject.ValidFor (leafL_144_4).leaf := by decide

noncomputable def leafL_144_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,125}, reject := .fullRank { members := ![0,1,17,34,52,70,110,125], points := ![90,91,135,137,139,147], inverse := ![12,4,1,7,5,10,3,5,7,3,13,15,0,0,13,8,5,0,7,3,1,3,4,2,4,4,10,6,12,0,11,11,10,14,4,0] } }
theorem leafL_144_5_valid : (leafL_144_5).reject.ValidFor (leafL_144_5).leaf := by decide

noncomputable def leafL_144_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,127}, reject := .fullRank { members := ![0,1,17,34,52,70,110,127], points := ![83,89,90,135,137,147], inverse := ![5,13,0,12,15,10,12,2,8,15,6,15,9,12,5,0,0,0,0,5,1,10,12,2,3,2,1,4,4,0,11,7,12,1,1,0] } }
theorem leafL_144_6_valid : (leafL_144_6).reject.ValidFor (leafL_144_6).leaf := by decide

noncomputable def leafL_144_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,137}, reject := .fullRank { members := ![0,1,17,34,52,70,110,137], points := ![83,91,117,125,127,147], inverse := ![6,4,9,4,8,6,5,0,5,7,10,13,0,0,8,14,6,0,12,15,6,13,1,9,2,2,1,4,5,0,14,14,14,14,0,0] } }
theorem leafL_144_7_valid : (leafL_144_7).reject.ValidFor (leafL_144_7).leaf := by decide

noncomputable def leavesL_144 : List RejectedLeaf := [leafL_144_0,leafL_144_1,leafL_144_2,leafL_144_3,leafL_144_4,leafL_144_5,leafL_144_6,leafL_144_7]

theorem leavesL_144_valid : LeafListValid leavesL_144 := by
  intro x hx
  simp only [leavesL_144, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_144_0_valid
  · exact leafL_144_1_valid
  · exact leafL_144_2_valid
  · exact leafL_144_3_valid
  · exact leafL_144_4_valid
  · exact leafL_144_5_valid
  · exact leafL_144_6_valid
  · exact leafL_144_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
