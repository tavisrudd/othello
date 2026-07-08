import ProjectiveCap.CertData.Q11
import ProjectiveCap.PlaneOutcome

namespace ProjectiveCap
namespace Certificate
namespace CertData
namespace Q11

set_option maxHeartbeats 4000000

def classForThird (x : P) : GridClassCert K :=
  if x.1 = (2 : K) then
    if x.2 = (3 : K) then class0 else
    if x.2 = (4 : K) then class1 else
    if x.2 = (5 : K) then class2 else
    if x.2 = (6 : K) then class3 else
    if x.2 = (7 : K) then class4 else
    if x.2 = (8 : K) then class5 else
    if x.2 = (9 : K) then class6 else
    if x.2 = (10 : K) then class7 else
    class0
  else
  if x.1 = (3 : K) then
    if x.2 = (2 : K) then class8 else
    if x.2 = (4 : K) then class9 else
    if x.2 = (5 : K) then class10 else
    if x.2 = (6 : K) then class11 else
    if x.2 = (7 : K) then class12 else
    if x.2 = (8 : K) then class13 else
    if x.2 = (9 : K) then class14 else
    if x.2 = (10 : K) then class15 else
    class0
  else
  if x.1 = (4 : K) then
    if x.2 = (2 : K) then class16 else
    if x.2 = (3 : K) then class17 else
    if x.2 = (5 : K) then class18 else
    if x.2 = (6 : K) then class19 else
    if x.2 = (7 : K) then class20 else
    if x.2 = (8 : K) then class21 else
    if x.2 = (9 : K) then class22 else
    if x.2 = (10 : K) then class23 else
    class0
  else
  if x.1 = (5 : K) then
    if x.2 = (2 : K) then class24 else
    if x.2 = (3 : K) then class25 else
    if x.2 = (4 : K) then class26 else
    if x.2 = (6 : K) then class27 else
    if x.2 = (7 : K) then class28 else
    if x.2 = (8 : K) then class29 else
    if x.2 = (9 : K) then class30 else
    if x.2 = (10 : K) then class31 else
    class0
  else
  if x.1 = (6 : K) then
    if x.2 = (2 : K) then class32 else
    if x.2 = (3 : K) then class33 else
    if x.2 = (4 : K) then class34 else
    if x.2 = (5 : K) then class35 else
    if x.2 = (7 : K) then class36 else
    if x.2 = (8 : K) then class37 else
    if x.2 = (9 : K) then class38 else
    if x.2 = (10 : K) then class39 else
    class0
  else
  if x.1 = (7 : K) then
    if x.2 = (2 : K) then class40 else
    if x.2 = (3 : K) then class41 else
    if x.2 = (4 : K) then class42 else
    if x.2 = (5 : K) then class43 else
    if x.2 = (6 : K) then class44 else
    if x.2 = (8 : K) then class45 else
    if x.2 = (9 : K) then class46 else
    if x.2 = (10 : K) then class47 else
    class0
  else
  if x.1 = (8 : K) then
    if x.2 = (2 : K) then class48 else
    if x.2 = (3 : K) then class49 else
    if x.2 = (4 : K) then class50 else
    if x.2 = (5 : K) then class51 else
    if x.2 = (6 : K) then class52 else
    if x.2 = (7 : K) then class53 else
    if x.2 = (9 : K) then class54 else
    if x.2 = (10 : K) then class55 else
    class0
  else
  if x.1 = (9 : K) then
    if x.2 = (2 : K) then class56 else
    if x.2 = (3 : K) then class57 else
    if x.2 = (4 : K) then class58 else
    if x.2 = (5 : K) then class59 else
    if x.2 = (6 : K) then class60 else
    if x.2 = (7 : K) then class61 else
    if x.2 = (8 : K) then class62 else
    if x.2 = (10 : K) then class63 else
    class0
  else
  if x.1 = (10 : K) then
    if x.2 = (2 : K) then class64 else
    if x.2 = (3 : K) then class65 else
    if x.2 = (4 : K) then class66 else
    if x.2 = (5 : K) then class67 else
    if x.2 = (6 : K) then class68 else
    if x.2 = (7 : K) then class69 else
    if x.2 = (8 : K) then class70 else
    if x.2 = (9 : K) then class71 else
    class0
  else
  class0

theorem class0_sizeThree_eq :
    class0.sizeThree = ({pt 0 0, pt 1 1, pt 2 3} : Finset P) := by
  rfl
theorem class1_sizeThree_eq :
    class1.sizeThree = ({pt 0 0, pt 1 1, pt 2 4} : Finset P) := by
  rfl
theorem class2_sizeThree_eq :
    class2.sizeThree = ({pt 0 0, pt 1 1, pt 2 5} : Finset P) := by
  rfl
theorem class3_sizeThree_eq :
    class3.sizeThree = ({pt 0 0, pt 1 1, pt 2 6} : Finset P) := by
  rfl
theorem class4_sizeThree_eq :
    class4.sizeThree = ({pt 0 0, pt 1 1, pt 2 7} : Finset P) := by
  rfl
theorem class5_sizeThree_eq :
    class5.sizeThree = ({pt 0 0, pt 1 1, pt 2 8} : Finset P) := by
  rfl
theorem class6_sizeThree_eq :
    class6.sizeThree = ({pt 0 0, pt 1 1, pt 2 9} : Finset P) := by
  rfl
theorem class7_sizeThree_eq :
    class7.sizeThree = ({pt 0 0, pt 1 1, pt 2 10} : Finset P) := by
  rfl
theorem class8_sizeThree_eq :
    class8.sizeThree = ({pt 0 0, pt 1 1, pt 3 2} : Finset P) := by
  rfl
theorem class9_sizeThree_eq :
    class9.sizeThree = ({pt 0 0, pt 1 1, pt 3 4} : Finset P) := by
  rfl
theorem class10_sizeThree_eq :
    class10.sizeThree = ({pt 0 0, pt 1 1, pt 3 5} : Finset P) := by
  rfl
theorem class11_sizeThree_eq :
    class11.sizeThree = ({pt 0 0, pt 1 1, pt 3 6} : Finset P) := by
  rfl
theorem class12_sizeThree_eq :
    class12.sizeThree = ({pt 0 0, pt 1 1, pt 3 7} : Finset P) := by
  rfl
theorem class13_sizeThree_eq :
    class13.sizeThree = ({pt 0 0, pt 1 1, pt 3 8} : Finset P) := by
  rfl
theorem class14_sizeThree_eq :
    class14.sizeThree = ({pt 0 0, pt 1 1, pt 3 9} : Finset P) := by
  rfl
theorem class15_sizeThree_eq :
    class15.sizeThree = ({pt 0 0, pt 1 1, pt 3 10} : Finset P) := by
  rfl
theorem class16_sizeThree_eq :
    class16.sizeThree = ({pt 0 0, pt 1 1, pt 4 2} : Finset P) := by
  rfl
theorem class17_sizeThree_eq :
    class17.sizeThree = ({pt 0 0, pt 1 1, pt 4 3} : Finset P) := by
  rfl
theorem class18_sizeThree_eq :
    class18.sizeThree = ({pt 0 0, pt 1 1, pt 4 5} : Finset P) := by
  rfl
theorem class19_sizeThree_eq :
    class19.sizeThree = ({pt 0 0, pt 1 1, pt 4 6} : Finset P) := by
  rfl
theorem class20_sizeThree_eq :
    class20.sizeThree = ({pt 0 0, pt 1 1, pt 4 7} : Finset P) := by
  rfl
theorem class21_sizeThree_eq :
    class21.sizeThree = ({pt 0 0, pt 1 1, pt 4 8} : Finset P) := by
  rfl
theorem class22_sizeThree_eq :
    class22.sizeThree = ({pt 0 0, pt 1 1, pt 4 9} : Finset P) := by
  rfl
theorem class23_sizeThree_eq :
    class23.sizeThree = ({pt 0 0, pt 1 1, pt 4 10} : Finset P) := by
  rfl
theorem class24_sizeThree_eq :
    class24.sizeThree = ({pt 0 0, pt 1 1, pt 5 2} : Finset P) := by
  rfl
theorem class25_sizeThree_eq :
    class25.sizeThree = ({pt 0 0, pt 1 1, pt 5 3} : Finset P) := by
  rfl
theorem class26_sizeThree_eq :
    class26.sizeThree = ({pt 0 0, pt 1 1, pt 5 4} : Finset P) := by
  rfl
theorem class27_sizeThree_eq :
    class27.sizeThree = ({pt 0 0, pt 1 1, pt 5 6} : Finset P) := by
  rfl
theorem class28_sizeThree_eq :
    class28.sizeThree = ({pt 0 0, pt 1 1, pt 5 7} : Finset P) := by
  rfl
theorem class29_sizeThree_eq :
    class29.sizeThree = ({pt 0 0, pt 1 1, pt 5 8} : Finset P) := by
  rfl
theorem class30_sizeThree_eq :
    class30.sizeThree = ({pt 0 0, pt 1 1, pt 5 9} : Finset P) := by
  rfl
theorem class31_sizeThree_eq :
    class31.sizeThree = ({pt 0 0, pt 1 1, pt 5 10} : Finset P) := by
  rfl
theorem class32_sizeThree_eq :
    class32.sizeThree = ({pt 0 0, pt 1 1, pt 6 2} : Finset P) := by
  rfl
theorem class33_sizeThree_eq :
    class33.sizeThree = ({pt 0 0, pt 1 1, pt 6 3} : Finset P) := by
  rfl
theorem class34_sizeThree_eq :
    class34.sizeThree = ({pt 0 0, pt 1 1, pt 6 4} : Finset P) := by
  rfl
theorem class35_sizeThree_eq :
    class35.sizeThree = ({pt 0 0, pt 1 1, pt 6 5} : Finset P) := by
  rfl
theorem class36_sizeThree_eq :
    class36.sizeThree = ({pt 0 0, pt 1 1, pt 6 7} : Finset P) := by
  rfl
theorem class37_sizeThree_eq :
    class37.sizeThree = ({pt 0 0, pt 1 1, pt 6 8} : Finset P) := by
  rfl
theorem class38_sizeThree_eq :
    class38.sizeThree = ({pt 0 0, pt 1 1, pt 6 9} : Finset P) := by
  rfl
theorem class39_sizeThree_eq :
    class39.sizeThree = ({pt 0 0, pt 1 1, pt 6 10} : Finset P) := by
  rfl
theorem class40_sizeThree_eq :
    class40.sizeThree = ({pt 0 0, pt 1 1, pt 7 2} : Finset P) := by
  rfl
theorem class41_sizeThree_eq :
    class41.sizeThree = ({pt 0 0, pt 1 1, pt 7 3} : Finset P) := by
  rfl
theorem class42_sizeThree_eq :
    class42.sizeThree = ({pt 0 0, pt 1 1, pt 7 4} : Finset P) := by
  rfl
theorem class43_sizeThree_eq :
    class43.sizeThree = ({pt 0 0, pt 1 1, pt 7 5} : Finset P) := by
  rfl
theorem class44_sizeThree_eq :
    class44.sizeThree = ({pt 0 0, pt 1 1, pt 7 6} : Finset P) := by
  rfl
theorem class45_sizeThree_eq :
    class45.sizeThree = ({pt 0 0, pt 1 1, pt 7 8} : Finset P) := by
  rfl
theorem class46_sizeThree_eq :
    class46.sizeThree = ({pt 0 0, pt 1 1, pt 7 9} : Finset P) := by
  rfl
theorem class47_sizeThree_eq :
    class47.sizeThree = ({pt 0 0, pt 1 1, pt 7 10} : Finset P) := by
  rfl
theorem class48_sizeThree_eq :
    class48.sizeThree = ({pt 0 0, pt 1 1, pt 8 2} : Finset P) := by
  rfl
theorem class49_sizeThree_eq :
    class49.sizeThree = ({pt 0 0, pt 1 1, pt 8 3} : Finset P) := by
  rfl
theorem class50_sizeThree_eq :
    class50.sizeThree = ({pt 0 0, pt 1 1, pt 8 4} : Finset P) := by
  rfl
theorem class51_sizeThree_eq :
    class51.sizeThree = ({pt 0 0, pt 1 1, pt 8 5} : Finset P) := by
  rfl
theorem class52_sizeThree_eq :
    class52.sizeThree = ({pt 0 0, pt 1 1, pt 8 6} : Finset P) := by
  rfl
theorem class53_sizeThree_eq :
    class53.sizeThree = ({pt 0 0, pt 1 1, pt 8 7} : Finset P) := by
  rfl
theorem class54_sizeThree_eq :
    class54.sizeThree = ({pt 0 0, pt 1 1, pt 8 9} : Finset P) := by
  rfl
theorem class55_sizeThree_eq :
    class55.sizeThree = ({pt 0 0, pt 1 1, pt 8 10} : Finset P) := by
  rfl
theorem class56_sizeThree_eq :
    class56.sizeThree = ({pt 0 0, pt 1 1, pt 9 2} : Finset P) := by
  rfl
theorem class57_sizeThree_eq :
    class57.sizeThree = ({pt 0 0, pt 1 1, pt 9 3} : Finset P) := by
  rfl
theorem class58_sizeThree_eq :
    class58.sizeThree = ({pt 0 0, pt 1 1, pt 9 4} : Finset P) := by
  rfl
theorem class59_sizeThree_eq :
    class59.sizeThree = ({pt 0 0, pt 1 1, pt 9 5} : Finset P) := by
  rfl
theorem class60_sizeThree_eq :
    class60.sizeThree = ({pt 0 0, pt 1 1, pt 9 6} : Finset P) := by
  rfl
theorem class61_sizeThree_eq :
    class61.sizeThree = ({pt 0 0, pt 1 1, pt 9 7} : Finset P) := by
  rfl
theorem class62_sizeThree_eq :
    class62.sizeThree = ({pt 0 0, pt 1 1, pt 9 8} : Finset P) := by
  rfl
theorem class63_sizeThree_eq :
    class63.sizeThree = ({pt 0 0, pt 1 1, pt 9 10} : Finset P) := by
  rfl
theorem class64_sizeThree_eq :
    class64.sizeThree = ({pt 0 0, pt 1 1, pt 10 2} : Finset P) := by
  rfl
theorem class65_sizeThree_eq :
    class65.sizeThree = ({pt 0 0, pt 1 1, pt 10 3} : Finset P) := by
  rfl
theorem class66_sizeThree_eq :
    class66.sizeThree = ({pt 0 0, pt 1 1, pt 10 4} : Finset P) := by
  rfl
theorem class67_sizeThree_eq :
    class67.sizeThree = ({pt 0 0, pt 1 1, pt 10 5} : Finset P) := by
  rfl
theorem class68_sizeThree_eq :
    class68.sizeThree = ({pt 0 0, pt 1 1, pt 10 6} : Finset P) := by
  rfl
theorem class69_sizeThree_eq :
    class69.sizeThree = ({pt 0 0, pt 1 1, pt 10 7} : Finset P) := by
  rfl
theorem class70_sizeThree_eq :
    class70.sizeThree = ({pt 0 0, pt 1 1, pt 10 8} : Finset P) := by
  rfl
theorem class71_sizeThree_eq :
    class71.sizeThree = ({pt 0 0, pt 1 1, pt 10 9} : Finset P) := by
  rfl

theorem invalid_0_0
    (hcard : ({pt 0 0, pt 1 1, pt 0 0} : Finset P).card = 3)
    (_hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 0 0} : Finset P)) : False := by
  exact (by decide : ¬ (({pt 0 0, pt 1 1, pt 0 0} : Finset P).card = 3)) hcard

theorem invalid_0_1
    (_hcard : ({pt 0 0, pt 1 1, pt 0 1} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 0 1} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 0 1} : Finset P) := by simp
  have hx : pt 0 1 ∈ ({pt 0 0, pt 1 1, pt 0 1} : Finset P) := by simp
  have hrow : (pt 0 0).1 = (pt 0 1).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 0 0 ≠ pt 0 1) heq

theorem invalid_0_2
    (_hcard : ({pt 0 0, pt 1 1, pt 0 2} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 0 2} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 0 2} : Finset P) := by simp
  have hx : pt 0 2 ∈ ({pt 0 0, pt 1 1, pt 0 2} : Finset P) := by simp
  have hrow : (pt 0 0).1 = (pt 0 2).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 0 0 ≠ pt 0 2) heq

theorem invalid_0_3
    (_hcard : ({pt 0 0, pt 1 1, pt 0 3} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 0 3} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 0 3} : Finset P) := by simp
  have hx : pt 0 3 ∈ ({pt 0 0, pt 1 1, pt 0 3} : Finset P) := by simp
  have hrow : (pt 0 0).1 = (pt 0 3).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 0 0 ≠ pt 0 3) heq

theorem invalid_0_4
    (_hcard : ({pt 0 0, pt 1 1, pt 0 4} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 0 4} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 0 4} : Finset P) := by simp
  have hx : pt 0 4 ∈ ({pt 0 0, pt 1 1, pt 0 4} : Finset P) := by simp
  have hrow : (pt 0 0).1 = (pt 0 4).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 0 0 ≠ pt 0 4) heq

theorem invalid_0_5
    (_hcard : ({pt 0 0, pt 1 1, pt 0 5} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 0 5} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 0 5} : Finset P) := by simp
  have hx : pt 0 5 ∈ ({pt 0 0, pt 1 1, pt 0 5} : Finset P) := by simp
  have hrow : (pt 0 0).1 = (pt 0 5).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 0 0 ≠ pt 0 5) heq

theorem invalid_0_6
    (_hcard : ({pt 0 0, pt 1 1, pt 0 6} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 0 6} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 0 6} : Finset P) := by simp
  have hx : pt 0 6 ∈ ({pt 0 0, pt 1 1, pt 0 6} : Finset P) := by simp
  have hrow : (pt 0 0).1 = (pt 0 6).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 0 0 ≠ pt 0 6) heq

theorem invalid_0_7
    (_hcard : ({pt 0 0, pt 1 1, pt 0 7} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 0 7} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 0 7} : Finset P) := by simp
  have hx : pt 0 7 ∈ ({pt 0 0, pt 1 1, pt 0 7} : Finset P) := by simp
  have hrow : (pt 0 0).1 = (pt 0 7).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 0 0 ≠ pt 0 7) heq

theorem invalid_0_8
    (_hcard : ({pt 0 0, pt 1 1, pt 0 8} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 0 8} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 0 8} : Finset P) := by simp
  have hx : pt 0 8 ∈ ({pt 0 0, pt 1 1, pt 0 8} : Finset P) := by simp
  have hrow : (pt 0 0).1 = (pt 0 8).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 0 0 ≠ pt 0 8) heq

theorem invalid_0_9
    (_hcard : ({pt 0 0, pt 1 1, pt 0 9} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 0 9} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 0 9} : Finset P) := by simp
  have hx : pt 0 9 ∈ ({pt 0 0, pt 1 1, pt 0 9} : Finset P) := by simp
  have hrow : (pt 0 0).1 = (pt 0 9).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 0 0 ≠ pt 0 9) heq

theorem invalid_0_10
    (_hcard : ({pt 0 0, pt 1 1, pt 0 10} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 0 10} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 0 10} : Finset P) := by simp
  have hx : pt 0 10 ∈ ({pt 0 0, pt 1 1, pt 0 10} : Finset P) := by simp
  have hrow : (pt 0 0).1 = (pt 0 10).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 0 0 ≠ pt 0 10) heq

theorem invalid_1_0
    (_hcard : ({pt 0 0, pt 1 1, pt 1 0} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 1 0} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 1 0} : Finset P) := by simp
  have hx : pt 1 0 ∈ ({pt 0 0, pt 1 1, pt 1 0} : Finset P) := by simp
  have hcol : (pt 0 0).2 = (pt 1 0).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 0 0 ≠ pt 1 0) heq

theorem invalid_1_1
    (hcard : ({pt 0 0, pt 1 1, pt 1 1} : Finset P).card = 3)
    (_hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 1 1} : Finset P)) : False := by
  exact (by decide : ¬ (({pt 0 0, pt 1 1, pt 1 1} : Finset P).card = 3)) hcard

theorem invalid_1_2
    (_hcard : ({pt 0 0, pt 1 1, pt 1 2} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 1 2} : Finset P)) : False := by
  have hp : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 1 2} : Finset P) := by simp
  have hx : pt 1 2 ∈ ({pt 0 0, pt 1 1, pt 1 2} : Finset P) := by simp
  have hrow : (pt 1 1).1 = (pt 1 2).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 1 1 ≠ pt 1 2) heq

theorem invalid_1_3
    (_hcard : ({pt 0 0, pt 1 1, pt 1 3} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 1 3} : Finset P)) : False := by
  have hp : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 1 3} : Finset P) := by simp
  have hx : pt 1 3 ∈ ({pt 0 0, pt 1 1, pt 1 3} : Finset P) := by simp
  have hrow : (pt 1 1).1 = (pt 1 3).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 1 1 ≠ pt 1 3) heq

theorem invalid_1_4
    (_hcard : ({pt 0 0, pt 1 1, pt 1 4} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 1 4} : Finset P)) : False := by
  have hp : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 1 4} : Finset P) := by simp
  have hx : pt 1 4 ∈ ({pt 0 0, pt 1 1, pt 1 4} : Finset P) := by simp
  have hrow : (pt 1 1).1 = (pt 1 4).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 1 1 ≠ pt 1 4) heq

theorem invalid_1_5
    (_hcard : ({pt 0 0, pt 1 1, pt 1 5} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 1 5} : Finset P)) : False := by
  have hp : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 1 5} : Finset P) := by simp
  have hx : pt 1 5 ∈ ({pt 0 0, pt 1 1, pt 1 5} : Finset P) := by simp
  have hrow : (pt 1 1).1 = (pt 1 5).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 1 1 ≠ pt 1 5) heq

theorem invalid_1_6
    (_hcard : ({pt 0 0, pt 1 1, pt 1 6} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 1 6} : Finset P)) : False := by
  have hp : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 1 6} : Finset P) := by simp
  have hx : pt 1 6 ∈ ({pt 0 0, pt 1 1, pt 1 6} : Finset P) := by simp
  have hrow : (pt 1 1).1 = (pt 1 6).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 1 1 ≠ pt 1 6) heq

theorem invalid_1_7
    (_hcard : ({pt 0 0, pt 1 1, pt 1 7} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 1 7} : Finset P)) : False := by
  have hp : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 1 7} : Finset P) := by simp
  have hx : pt 1 7 ∈ ({pt 0 0, pt 1 1, pt 1 7} : Finset P) := by simp
  have hrow : (pt 1 1).1 = (pt 1 7).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 1 1 ≠ pt 1 7) heq

theorem invalid_1_8
    (_hcard : ({pt 0 0, pt 1 1, pt 1 8} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 1 8} : Finset P)) : False := by
  have hp : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 1 8} : Finset P) := by simp
  have hx : pt 1 8 ∈ ({pt 0 0, pt 1 1, pt 1 8} : Finset P) := by simp
  have hrow : (pt 1 1).1 = (pt 1 8).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 1 1 ≠ pt 1 8) heq

theorem invalid_1_9
    (_hcard : ({pt 0 0, pt 1 1, pt 1 9} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 1 9} : Finset P)) : False := by
  have hp : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 1 9} : Finset P) := by simp
  have hx : pt 1 9 ∈ ({pt 0 0, pt 1 1, pt 1 9} : Finset P) := by simp
  have hrow : (pt 1 1).1 = (pt 1 9).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 1 1 ≠ pt 1 9) heq

theorem invalid_1_10
    (_hcard : ({pt 0 0, pt 1 1, pt 1 10} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 1 10} : Finset P)) : False := by
  have hp : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 1 10} : Finset P) := by simp
  have hx : pt 1 10 ∈ ({pt 0 0, pt 1 1, pt 1 10} : Finset P) := by simp
  have hrow : (pt 1 1).1 = (pt 1 10).1 := by norm_num [pt]
  have heq := hcap.1.1 hp hx hrow
  exact (by decide : pt 1 1 ≠ pt 1 10) heq

theorem invalid_2_0
    (_hcard : ({pt 0 0, pt 1 1, pt 2 0} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 2 0} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 2 0} : Finset P) := by simp
  have hx : pt 2 0 ∈ ({pt 0 0, pt 1 1, pt 2 0} : Finset P) := by simp
  have hcol : (pt 0 0).2 = (pt 2 0).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 0 0 ≠ pt 2 0) heq

theorem invalid_2_1
    (_hcard : ({pt 0 0, pt 1 1, pt 2 1} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 2 1} : Finset P)) : False := by
  have hp : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 2 1} : Finset P) := by simp
  have hx : pt 2 1 ∈ ({pt 0 0, pt 1 1, pt 2 1} : Finset P) := by simp
  have hcol : (pt 1 1).2 = (pt 2 1).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 1 1 ≠ pt 2 1) heq

theorem invalid_2_2
    (_hcard : ({pt 0 0, pt 1 1, pt 2 2} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 2 2} : Finset P)) : False := by
  have hp0 : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 2 2} : Finset P) := by simp
  have hp1 : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 2 2} : Finset P) := by simp
  have hx : pt 2 2 ∈ ({pt 0 0, pt 1 1, pt 2 2} : Finset P) := by simp
  have h01 : pt 0 0 ≠ pt 1 1 := by decide
  have h0x : pt 0 0 ≠ pt 2 2 := by decide
  have h1x : pt 1 1 ≠ pt 2 2 := by decide
  have hcol : Collinear (K := K) (pt 0 0) (pt 1 1) (pt 2 2) := by
    norm_num [Collinear, pt]
  exact (hcap.2 hp0 hp1 hx h01 h0x h1x) hcol

theorem invalid_3_0
    (_hcard : ({pt 0 0, pt 1 1, pt 3 0} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 3 0} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 3 0} : Finset P) := by simp
  have hx : pt 3 0 ∈ ({pt 0 0, pt 1 1, pt 3 0} : Finset P) := by simp
  have hcol : (pt 0 0).2 = (pt 3 0).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 0 0 ≠ pt 3 0) heq

theorem invalid_3_1
    (_hcard : ({pt 0 0, pt 1 1, pt 3 1} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 3 1} : Finset P)) : False := by
  have hp : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 3 1} : Finset P) := by simp
  have hx : pt 3 1 ∈ ({pt 0 0, pt 1 1, pt 3 1} : Finset P) := by simp
  have hcol : (pt 1 1).2 = (pt 3 1).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 1 1 ≠ pt 3 1) heq

theorem invalid_3_3
    (_hcard : ({pt 0 0, pt 1 1, pt 3 3} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 3 3} : Finset P)) : False := by
  have hp0 : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 3 3} : Finset P) := by simp
  have hp1 : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 3 3} : Finset P) := by simp
  have hx : pt 3 3 ∈ ({pt 0 0, pt 1 1, pt 3 3} : Finset P) := by simp
  have h01 : pt 0 0 ≠ pt 1 1 := by decide
  have h0x : pt 0 0 ≠ pt 3 3 := by decide
  have h1x : pt 1 1 ≠ pt 3 3 := by decide
  have hcol : Collinear (K := K) (pt 0 0) (pt 1 1) (pt 3 3) := by
    norm_num [Collinear, pt]
  exact (hcap.2 hp0 hp1 hx h01 h0x h1x) hcol

theorem invalid_4_0
    (_hcard : ({pt 0 0, pt 1 1, pt 4 0} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 4 0} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 4 0} : Finset P) := by simp
  have hx : pt 4 0 ∈ ({pt 0 0, pt 1 1, pt 4 0} : Finset P) := by simp
  have hcol : (pt 0 0).2 = (pt 4 0).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 0 0 ≠ pt 4 0) heq

theorem invalid_4_1
    (_hcard : ({pt 0 0, pt 1 1, pt 4 1} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 4 1} : Finset P)) : False := by
  have hp : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 4 1} : Finset P) := by simp
  have hx : pt 4 1 ∈ ({pt 0 0, pt 1 1, pt 4 1} : Finset P) := by simp
  have hcol : (pt 1 1).2 = (pt 4 1).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 1 1 ≠ pt 4 1) heq

theorem invalid_4_4
    (_hcard : ({pt 0 0, pt 1 1, pt 4 4} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 4 4} : Finset P)) : False := by
  have hp0 : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 4 4} : Finset P) := by simp
  have hp1 : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 4 4} : Finset P) := by simp
  have hx : pt 4 4 ∈ ({pt 0 0, pt 1 1, pt 4 4} : Finset P) := by simp
  have h01 : pt 0 0 ≠ pt 1 1 := by decide
  have h0x : pt 0 0 ≠ pt 4 4 := by decide
  have h1x : pt 1 1 ≠ pt 4 4 := by decide
  have hcol : Collinear (K := K) (pt 0 0) (pt 1 1) (pt 4 4) := by
    norm_num [Collinear, pt]
  exact (hcap.2 hp0 hp1 hx h01 h0x h1x) hcol

theorem invalid_5_0
    (_hcard : ({pt 0 0, pt 1 1, pt 5 0} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 5 0} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 5 0} : Finset P) := by simp
  have hx : pt 5 0 ∈ ({pt 0 0, pt 1 1, pt 5 0} : Finset P) := by simp
  have hcol : (pt 0 0).2 = (pt 5 0).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 0 0 ≠ pt 5 0) heq

theorem invalid_5_1
    (_hcard : ({pt 0 0, pt 1 1, pt 5 1} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 5 1} : Finset P)) : False := by
  have hp : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 5 1} : Finset P) := by simp
  have hx : pt 5 1 ∈ ({pt 0 0, pt 1 1, pt 5 1} : Finset P) := by simp
  have hcol : (pt 1 1).2 = (pt 5 1).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 1 1 ≠ pt 5 1) heq

theorem invalid_5_5
    (_hcard : ({pt 0 0, pt 1 1, pt 5 5} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 5 5} : Finset P)) : False := by
  have hp0 : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 5 5} : Finset P) := by simp
  have hp1 : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 5 5} : Finset P) := by simp
  have hx : pt 5 5 ∈ ({pt 0 0, pt 1 1, pt 5 5} : Finset P) := by simp
  have h01 : pt 0 0 ≠ pt 1 1 := by decide
  have h0x : pt 0 0 ≠ pt 5 5 := by decide
  have h1x : pt 1 1 ≠ pt 5 5 := by decide
  have hcol : Collinear (K := K) (pt 0 0) (pt 1 1) (pt 5 5) := by
    norm_num [Collinear, pt]
  exact (hcap.2 hp0 hp1 hx h01 h0x h1x) hcol

theorem invalid_6_0
    (_hcard : ({pt 0 0, pt 1 1, pt 6 0} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 6 0} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 6 0} : Finset P) := by simp
  have hx : pt 6 0 ∈ ({pt 0 0, pt 1 1, pt 6 0} : Finset P) := by simp
  have hcol : (pt 0 0).2 = (pt 6 0).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 0 0 ≠ pt 6 0) heq

theorem invalid_6_1
    (_hcard : ({pt 0 0, pt 1 1, pt 6 1} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 6 1} : Finset P)) : False := by
  have hp : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 6 1} : Finset P) := by simp
  have hx : pt 6 1 ∈ ({pt 0 0, pt 1 1, pt 6 1} : Finset P) := by simp
  have hcol : (pt 1 1).2 = (pt 6 1).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 1 1 ≠ pt 6 1) heq

theorem invalid_6_6
    (_hcard : ({pt 0 0, pt 1 1, pt 6 6} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 6 6} : Finset P)) : False := by
  have hp0 : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 6 6} : Finset P) := by simp
  have hp1 : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 6 6} : Finset P) := by simp
  have hx : pt 6 6 ∈ ({pt 0 0, pt 1 1, pt 6 6} : Finset P) := by simp
  have h01 : pt 0 0 ≠ pt 1 1 := by decide
  have h0x : pt 0 0 ≠ pt 6 6 := by decide
  have h1x : pt 1 1 ≠ pt 6 6 := by decide
  have hcol : Collinear (K := K) (pt 0 0) (pt 1 1) (pt 6 6) := by
    norm_num [Collinear, pt]
  exact (hcap.2 hp0 hp1 hx h01 h0x h1x) hcol

theorem invalid_7_0
    (_hcard : ({pt 0 0, pt 1 1, pt 7 0} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 7 0} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 7 0} : Finset P) := by simp
  have hx : pt 7 0 ∈ ({pt 0 0, pt 1 1, pt 7 0} : Finset P) := by simp
  have hcol : (pt 0 0).2 = (pt 7 0).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 0 0 ≠ pt 7 0) heq

theorem invalid_7_1
    (_hcard : ({pt 0 0, pt 1 1, pt 7 1} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 7 1} : Finset P)) : False := by
  have hp : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 7 1} : Finset P) := by simp
  have hx : pt 7 1 ∈ ({pt 0 0, pt 1 1, pt 7 1} : Finset P) := by simp
  have hcol : (pt 1 1).2 = (pt 7 1).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 1 1 ≠ pt 7 1) heq

theorem invalid_7_7
    (_hcard : ({pt 0 0, pt 1 1, pt 7 7} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 7 7} : Finset P)) : False := by
  have hp0 : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 7 7} : Finset P) := by simp
  have hp1 : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 7 7} : Finset P) := by simp
  have hx : pt 7 7 ∈ ({pt 0 0, pt 1 1, pt 7 7} : Finset P) := by simp
  have h01 : pt 0 0 ≠ pt 1 1 := by decide
  have h0x : pt 0 0 ≠ pt 7 7 := by decide
  have h1x : pt 1 1 ≠ pt 7 7 := by decide
  have hcol : Collinear (K := K) (pt 0 0) (pt 1 1) (pt 7 7) := by
    norm_num [Collinear, pt]
  exact (hcap.2 hp0 hp1 hx h01 h0x h1x) hcol

theorem invalid_8_0
    (_hcard : ({pt 0 0, pt 1 1, pt 8 0} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 8 0} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 8 0} : Finset P) := by simp
  have hx : pt 8 0 ∈ ({pt 0 0, pt 1 1, pt 8 0} : Finset P) := by simp
  have hcol : (pt 0 0).2 = (pt 8 0).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 0 0 ≠ pt 8 0) heq

theorem invalid_8_1
    (_hcard : ({pt 0 0, pt 1 1, pt 8 1} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 8 1} : Finset P)) : False := by
  have hp : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 8 1} : Finset P) := by simp
  have hx : pt 8 1 ∈ ({pt 0 0, pt 1 1, pt 8 1} : Finset P) := by simp
  have hcol : (pt 1 1).2 = (pt 8 1).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 1 1 ≠ pt 8 1) heq

theorem invalid_8_8
    (_hcard : ({pt 0 0, pt 1 1, pt 8 8} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 8 8} : Finset P)) : False := by
  have hp0 : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 8 8} : Finset P) := by simp
  have hp1 : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 8 8} : Finset P) := by simp
  have hx : pt 8 8 ∈ ({pt 0 0, pt 1 1, pt 8 8} : Finset P) := by simp
  have h01 : pt 0 0 ≠ pt 1 1 := by decide
  have h0x : pt 0 0 ≠ pt 8 8 := by decide
  have h1x : pt 1 1 ≠ pt 8 8 := by decide
  have hcol : Collinear (K := K) (pt 0 0) (pt 1 1) (pt 8 8) := by
    norm_num [Collinear, pt]
  exact (hcap.2 hp0 hp1 hx h01 h0x h1x) hcol

theorem invalid_9_0
    (_hcard : ({pt 0 0, pt 1 1, pt 9 0} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 9 0} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 9 0} : Finset P) := by simp
  have hx : pt 9 0 ∈ ({pt 0 0, pt 1 1, pt 9 0} : Finset P) := by simp
  have hcol : (pt 0 0).2 = (pt 9 0).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 0 0 ≠ pt 9 0) heq

theorem invalid_9_1
    (_hcard : ({pt 0 0, pt 1 1, pt 9 1} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 9 1} : Finset P)) : False := by
  have hp : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 9 1} : Finset P) := by simp
  have hx : pt 9 1 ∈ ({pt 0 0, pt 1 1, pt 9 1} : Finset P) := by simp
  have hcol : (pt 1 1).2 = (pt 9 1).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 1 1 ≠ pt 9 1) heq

theorem invalid_9_9
    (_hcard : ({pt 0 0, pt 1 1, pt 9 9} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 9 9} : Finset P)) : False := by
  have hp0 : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 9 9} : Finset P) := by simp
  have hp1 : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 9 9} : Finset P) := by simp
  have hx : pt 9 9 ∈ ({pt 0 0, pt 1 1, pt 9 9} : Finset P) := by simp
  have h01 : pt 0 0 ≠ pt 1 1 := by decide
  have h0x : pt 0 0 ≠ pt 9 9 := by decide
  have h1x : pt 1 1 ≠ pt 9 9 := by decide
  have hcol : Collinear (K := K) (pt 0 0) (pt 1 1) (pt 9 9) := by
    norm_num [Collinear, pt]
  exact (hcap.2 hp0 hp1 hx h01 h0x h1x) hcol

theorem invalid_10_0
    (_hcard : ({pt 0 0, pt 1 1, pt 10 0} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 10 0} : Finset P)) : False := by
  have hp : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 10 0} : Finset P) := by simp
  have hx : pt 10 0 ∈ ({pt 0 0, pt 1 1, pt 10 0} : Finset P) := by simp
  have hcol : (pt 0 0).2 = (pt 10 0).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 0 0 ≠ pt 10 0) heq

theorem invalid_10_1
    (_hcard : ({pt 0 0, pt 1 1, pt 10 1} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 10 1} : Finset P)) : False := by
  have hp : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 10 1} : Finset P) := by simp
  have hx : pt 10 1 ∈ ({pt 0 0, pt 1 1, pt 10 1} : Finset P) := by simp
  have hcol : (pt 1 1).2 = (pt 10 1).2 := by norm_num [pt]
  have heq := hcap.1.2 hp hx hcol
  exact (by decide : pt 1 1 ≠ pt 10 1) heq

theorem invalid_10_10
    (_hcard : ({pt 0 0, pt 1 1, pt 10 10} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, pt 10 10} : Finset P)) : False := by
  have hp0 : pt 0 0 ∈ ({pt 0 0, pt 1 1, pt 10 10} : Finset P) := by simp
  have hp1 : pt 1 1 ∈ ({pt 0 0, pt 1 1, pt 10 10} : Finset P) := by simp
  have hx : pt 10 10 ∈ ({pt 0 0, pt 1 1, pt 10 10} : Finset P) := by simp
  have h01 : pt 0 0 ≠ pt 1 1 := by decide
  have h0x : pt 0 0 ≠ pt 10 10 := by decide
  have h1x : pt 1 1 ≠ pt 10 10 := by decide
  have hcol : Collinear (K := K) (pt 0 0) (pt 1 1) (pt 10 10) := by
    norm_num [Collinear, pt]
  exact (hcap.2 hp0 hp1 hx h01 h0x h1x) hcol


theorem classForThird_valid (x : P) : (classForThird x).Valid := by
  rcases x with ⟨r, c⟩
  fin_cases r <;> fin_cases c
  all_goals
    first
    | change class0.Valid
      exact class0_valid
    | change class1.Valid
      exact class1_valid
    | change class2.Valid
      exact class2_valid
    | change class3.Valid
      exact class3_valid
    | change class4.Valid
      exact class4_valid
    | change class5.Valid
      exact class5_valid
    | change class6.Valid
      exact class6_valid
    | change class7.Valid
      exact class7_valid
    | change class8.Valid
      exact class8_valid
    | change class9.Valid
      exact class9_valid
    | change class10.Valid
      exact class10_valid
    | change class11.Valid
      exact class11_valid
    | change class12.Valid
      exact class12_valid
    | change class13.Valid
      exact class13_valid
    | change class14.Valid
      exact class14_valid
    | change class15.Valid
      exact class15_valid
    | change class16.Valid
      exact class16_valid
    | change class17.Valid
      exact class17_valid
    | change class18.Valid
      exact class18_valid
    | change class19.Valid
      exact class19_valid
    | change class20.Valid
      exact class20_valid
    | change class21.Valid
      exact class21_valid
    | change class22.Valid
      exact class22_valid
    | change class23.Valid
      exact class23_valid
    | change class24.Valid
      exact class24_valid
    | change class25.Valid
      exact class25_valid
    | change class26.Valid
      exact class26_valid
    | change class27.Valid
      exact class27_valid
    | change class28.Valid
      exact class28_valid
    | change class29.Valid
      exact class29_valid
    | change class30.Valid
      exact class30_valid
    | change class31.Valid
      exact class31_valid
    | change class32.Valid
      exact class32_valid
    | change class33.Valid
      exact class33_valid
    | change class34.Valid
      exact class34_valid
    | change class35.Valid
      exact class35_valid
    | change class36.Valid
      exact class36_valid
    | change class37.Valid
      exact class37_valid
    | change class38.Valid
      exact class38_valid
    | change class39.Valid
      exact class39_valid
    | change class40.Valid
      exact class40_valid
    | change class41.Valid
      exact class41_valid
    | change class42.Valid
      exact class42_valid
    | change class43.Valid
      exact class43_valid
    | change class44.Valid
      exact class44_valid
    | change class45.Valid
      exact class45_valid
    | change class46.Valid
      exact class46_valid
    | change class47.Valid
      exact class47_valid
    | change class48.Valid
      exact class48_valid
    | change class49.Valid
      exact class49_valid
    | change class50.Valid
      exact class50_valid
    | change class51.Valid
      exact class51_valid
    | change class52.Valid
      exact class52_valid
    | change class53.Valid
      exact class53_valid
    | change class54.Valid
      exact class54_valid
    | change class55.Valid
      exact class55_valid
    | change class56.Valid
      exact class56_valid
    | change class57.Valid
      exact class57_valid
    | change class58.Valid
      exact class58_valid
    | change class59.Valid
      exact class59_valid
    | change class60.Valid
      exact class60_valid
    | change class61.Valid
      exact class61_valid
    | change class62.Valid
      exact class62_valid
    | change class63.Valid
      exact class63_valid
    | change class64.Valid
      exact class64_valid
    | change class65.Valid
      exact class65_valid
    | change class66.Valid
      exact class66_valid
    | change class67.Valid
      exact class67_valid
    | change class68.Valid
      exact class68_valid
    | change class69.Valid
      exact class69_valid
    | change class70.Valid
      exact class70_valid
    | change class71.Valid
      exact class71_valid

theorem classForThird_sizeThree_of_gridCap (x : P)
    (hcard : ({pt 0 0, pt 1 1, x} : Finset P).card = 3)
    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, x} : Finset P)) :
    (classForThird x).sizeThree = ({pt 0 0, pt 1 1, x} : Finset P) := by
  rcases x with ⟨r, c⟩
  fin_cases r <;> fin_cases c
  all_goals
    first
    | change class0.sizeThree = ({pt 0 0, pt 1 1, pt 2 3} : Finset P)
      exact class0_sizeThree_eq
    | change class1.sizeThree = ({pt 0 0, pt 1 1, pt 2 4} : Finset P)
      exact class1_sizeThree_eq
    | change class2.sizeThree = ({pt 0 0, pt 1 1, pt 2 5} : Finset P)
      exact class2_sizeThree_eq
    | change class3.sizeThree = ({pt 0 0, pt 1 1, pt 2 6} : Finset P)
      exact class3_sizeThree_eq
    | change class4.sizeThree = ({pt 0 0, pt 1 1, pt 2 7} : Finset P)
      exact class4_sizeThree_eq
    | change class5.sizeThree = ({pt 0 0, pt 1 1, pt 2 8} : Finset P)
      exact class5_sizeThree_eq
    | change class6.sizeThree = ({pt 0 0, pt 1 1, pt 2 9} : Finset P)
      exact class6_sizeThree_eq
    | change class7.sizeThree = ({pt 0 0, pt 1 1, pt 2 10} : Finset P)
      exact class7_sizeThree_eq
    | change class8.sizeThree = ({pt 0 0, pt 1 1, pt 3 2} : Finset P)
      exact class8_sizeThree_eq
    | change class9.sizeThree = ({pt 0 0, pt 1 1, pt 3 4} : Finset P)
      exact class9_sizeThree_eq
    | change class10.sizeThree = ({pt 0 0, pt 1 1, pt 3 5} : Finset P)
      exact class10_sizeThree_eq
    | change class11.sizeThree = ({pt 0 0, pt 1 1, pt 3 6} : Finset P)
      exact class11_sizeThree_eq
    | change class12.sizeThree = ({pt 0 0, pt 1 1, pt 3 7} : Finset P)
      exact class12_sizeThree_eq
    | change class13.sizeThree = ({pt 0 0, pt 1 1, pt 3 8} : Finset P)
      exact class13_sizeThree_eq
    | change class14.sizeThree = ({pt 0 0, pt 1 1, pt 3 9} : Finset P)
      exact class14_sizeThree_eq
    | change class15.sizeThree = ({pt 0 0, pt 1 1, pt 3 10} : Finset P)
      exact class15_sizeThree_eq
    | change class16.sizeThree = ({pt 0 0, pt 1 1, pt 4 2} : Finset P)
      exact class16_sizeThree_eq
    | change class17.sizeThree = ({pt 0 0, pt 1 1, pt 4 3} : Finset P)
      exact class17_sizeThree_eq
    | change class18.sizeThree = ({pt 0 0, pt 1 1, pt 4 5} : Finset P)
      exact class18_sizeThree_eq
    | change class19.sizeThree = ({pt 0 0, pt 1 1, pt 4 6} : Finset P)
      exact class19_sizeThree_eq
    | change class20.sizeThree = ({pt 0 0, pt 1 1, pt 4 7} : Finset P)
      exact class20_sizeThree_eq
    | change class21.sizeThree = ({pt 0 0, pt 1 1, pt 4 8} : Finset P)
      exact class21_sizeThree_eq
    | change class22.sizeThree = ({pt 0 0, pt 1 1, pt 4 9} : Finset P)
      exact class22_sizeThree_eq
    | change class23.sizeThree = ({pt 0 0, pt 1 1, pt 4 10} : Finset P)
      exact class23_sizeThree_eq
    | change class24.sizeThree = ({pt 0 0, pt 1 1, pt 5 2} : Finset P)
      exact class24_sizeThree_eq
    | change class25.sizeThree = ({pt 0 0, pt 1 1, pt 5 3} : Finset P)
      exact class25_sizeThree_eq
    | change class26.sizeThree = ({pt 0 0, pt 1 1, pt 5 4} : Finset P)
      exact class26_sizeThree_eq
    | change class27.sizeThree = ({pt 0 0, pt 1 1, pt 5 6} : Finset P)
      exact class27_sizeThree_eq
    | change class28.sizeThree = ({pt 0 0, pt 1 1, pt 5 7} : Finset P)
      exact class28_sizeThree_eq
    | change class29.sizeThree = ({pt 0 0, pt 1 1, pt 5 8} : Finset P)
      exact class29_sizeThree_eq
    | change class30.sizeThree = ({pt 0 0, pt 1 1, pt 5 9} : Finset P)
      exact class30_sizeThree_eq
    | change class31.sizeThree = ({pt 0 0, pt 1 1, pt 5 10} : Finset P)
      exact class31_sizeThree_eq
    | change class32.sizeThree = ({pt 0 0, pt 1 1, pt 6 2} : Finset P)
      exact class32_sizeThree_eq
    | change class33.sizeThree = ({pt 0 0, pt 1 1, pt 6 3} : Finset P)
      exact class33_sizeThree_eq
    | change class34.sizeThree = ({pt 0 0, pt 1 1, pt 6 4} : Finset P)
      exact class34_sizeThree_eq
    | change class35.sizeThree = ({pt 0 0, pt 1 1, pt 6 5} : Finset P)
      exact class35_sizeThree_eq
    | change class36.sizeThree = ({pt 0 0, pt 1 1, pt 6 7} : Finset P)
      exact class36_sizeThree_eq
    | change class37.sizeThree = ({pt 0 0, pt 1 1, pt 6 8} : Finset P)
      exact class37_sizeThree_eq
    | change class38.sizeThree = ({pt 0 0, pt 1 1, pt 6 9} : Finset P)
      exact class38_sizeThree_eq
    | change class39.sizeThree = ({pt 0 0, pt 1 1, pt 6 10} : Finset P)
      exact class39_sizeThree_eq
    | change class40.sizeThree = ({pt 0 0, pt 1 1, pt 7 2} : Finset P)
      exact class40_sizeThree_eq
    | change class41.sizeThree = ({pt 0 0, pt 1 1, pt 7 3} : Finset P)
      exact class41_sizeThree_eq
    | change class42.sizeThree = ({pt 0 0, pt 1 1, pt 7 4} : Finset P)
      exact class42_sizeThree_eq
    | change class43.sizeThree = ({pt 0 0, pt 1 1, pt 7 5} : Finset P)
      exact class43_sizeThree_eq
    | change class44.sizeThree = ({pt 0 0, pt 1 1, pt 7 6} : Finset P)
      exact class44_sizeThree_eq
    | change class45.sizeThree = ({pt 0 0, pt 1 1, pt 7 8} : Finset P)
      exact class45_sizeThree_eq
    | change class46.sizeThree = ({pt 0 0, pt 1 1, pt 7 9} : Finset P)
      exact class46_sizeThree_eq
    | change class47.sizeThree = ({pt 0 0, pt 1 1, pt 7 10} : Finset P)
      exact class47_sizeThree_eq
    | change class48.sizeThree = ({pt 0 0, pt 1 1, pt 8 2} : Finset P)
      exact class48_sizeThree_eq
    | change class49.sizeThree = ({pt 0 0, pt 1 1, pt 8 3} : Finset P)
      exact class49_sizeThree_eq
    | change class50.sizeThree = ({pt 0 0, pt 1 1, pt 8 4} : Finset P)
      exact class50_sizeThree_eq
    | change class51.sizeThree = ({pt 0 0, pt 1 1, pt 8 5} : Finset P)
      exact class51_sizeThree_eq
    | change class52.sizeThree = ({pt 0 0, pt 1 1, pt 8 6} : Finset P)
      exact class52_sizeThree_eq
    | change class53.sizeThree = ({pt 0 0, pt 1 1, pt 8 7} : Finset P)
      exact class53_sizeThree_eq
    | change class54.sizeThree = ({pt 0 0, pt 1 1, pt 8 9} : Finset P)
      exact class54_sizeThree_eq
    | change class55.sizeThree = ({pt 0 0, pt 1 1, pt 8 10} : Finset P)
      exact class55_sizeThree_eq
    | change class56.sizeThree = ({pt 0 0, pt 1 1, pt 9 2} : Finset P)
      exact class56_sizeThree_eq
    | change class57.sizeThree = ({pt 0 0, pt 1 1, pt 9 3} : Finset P)
      exact class57_sizeThree_eq
    | change class58.sizeThree = ({pt 0 0, pt 1 1, pt 9 4} : Finset P)
      exact class58_sizeThree_eq
    | change class59.sizeThree = ({pt 0 0, pt 1 1, pt 9 5} : Finset P)
      exact class59_sizeThree_eq
    | change class60.sizeThree = ({pt 0 0, pt 1 1, pt 9 6} : Finset P)
      exact class60_sizeThree_eq
    | change class61.sizeThree = ({pt 0 0, pt 1 1, pt 9 7} : Finset P)
      exact class61_sizeThree_eq
    | change class62.sizeThree = ({pt 0 0, pt 1 1, pt 9 8} : Finset P)
      exact class62_sizeThree_eq
    | change class63.sizeThree = ({pt 0 0, pt 1 1, pt 9 10} : Finset P)
      exact class63_sizeThree_eq
    | change class64.sizeThree = ({pt 0 0, pt 1 1, pt 10 2} : Finset P)
      exact class64_sizeThree_eq
    | change class65.sizeThree = ({pt 0 0, pt 1 1, pt 10 3} : Finset P)
      exact class65_sizeThree_eq
    | change class66.sizeThree = ({pt 0 0, pt 1 1, pt 10 4} : Finset P)
      exact class66_sizeThree_eq
    | change class67.sizeThree = ({pt 0 0, pt 1 1, pt 10 5} : Finset P)
      exact class67_sizeThree_eq
    | change class68.sizeThree = ({pt 0 0, pt 1 1, pt 10 6} : Finset P)
      exact class68_sizeThree_eq
    | change class69.sizeThree = ({pt 0 0, pt 1 1, pt 10 7} : Finset P)
      exact class69_sizeThree_eq
    | change class70.sizeThree = ({pt 0 0, pt 1 1, pt 10 8} : Finset P)
      exact class70_sizeThree_eq
    | change class71.sizeThree = ({pt 0 0, pt 1 1, pt 10 9} : Finset P)
      exact class71_sizeThree_eq
    | exfalso
      exact invalid_0_0 hcard hcap
    | exfalso
      exact invalid_0_1 hcard hcap
    | exfalso
      exact invalid_0_2 hcard hcap
    | exfalso
      exact invalid_0_3 hcard hcap
    | exfalso
      exact invalid_0_4 hcard hcap
    | exfalso
      exact invalid_0_5 hcard hcap
    | exfalso
      exact invalid_0_6 hcard hcap
    | exfalso
      exact invalid_0_7 hcard hcap
    | exfalso
      exact invalid_0_8 hcard hcap
    | exfalso
      exact invalid_0_9 hcard hcap
    | exfalso
      exact invalid_0_10 hcard hcap
    | exfalso
      exact invalid_1_0 hcard hcap
    | exfalso
      exact invalid_1_1 hcard hcap
    | exfalso
      exact invalid_1_2 hcard hcap
    | exfalso
      exact invalid_1_3 hcard hcap
    | exfalso
      exact invalid_1_4 hcard hcap
    | exfalso
      exact invalid_1_5 hcard hcap
    | exfalso
      exact invalid_1_6 hcard hcap
    | exfalso
      exact invalid_1_7 hcard hcap
    | exfalso
      exact invalid_1_8 hcard hcap
    | exfalso
      exact invalid_1_9 hcard hcap
    | exfalso
      exact invalid_1_10 hcard hcap
    | exfalso
      exact invalid_2_0 hcard hcap
    | exfalso
      exact invalid_2_1 hcard hcap
    | exfalso
      exact invalid_2_2 hcard hcap
    | exfalso
      exact invalid_3_0 hcard hcap
    | exfalso
      exact invalid_3_1 hcard hcap
    | exfalso
      exact invalid_3_3 hcard hcap
    | exfalso
      exact invalid_4_0 hcard hcap
    | exfalso
      exact invalid_4_1 hcard hcap
    | exfalso
      exact invalid_4_4 hcard hcap
    | exfalso
      exact invalid_5_0 hcard hcap
    | exfalso
      exact invalid_5_1 hcard hcap
    | exfalso
      exact invalid_5_5 hcard hcap
    | exfalso
      exact invalid_6_0 hcard hcap
    | exfalso
      exact invalid_6_1 hcard hcap
    | exfalso
      exact invalid_6_6 hcard hcap
    | exfalso
      exact invalid_7_0 hcard hcap
    | exfalso
      exact invalid_7_1 hcard hcap
    | exfalso
      exact invalid_7_7 hcard hcap
    | exfalso
      exact invalid_8_0 hcard hcap
    | exfalso
      exact invalid_8_1 hcard hcap
    | exfalso
      exact invalid_8_8 hcard hcap
    | exfalso
      exact invalid_9_0 hcard hcap
    | exfalso
      exact invalid_9_1 hcard hcap
    | exfalso
      exact invalid_9_9 hcard hcap
    | exfalso
      exact invalid_10_0 hcard hcap
    | exfalso
      exact invalid_10_1 hcard hcap
    | exfalso
      exact invalid_10_10 hcard hcap

structure TransportWitness (S : Finset P) where
  classCert : GridClassCert K
  symmetry : P -> P
  gridSymmetry : ConicLocalization.GridSymmetry (K := K) symmetry
  valid : classCert.Valid
  representsImage : classCert.sizeThree = S.image symmetry

theorem exists_transportWitness (S : Finset P) (hcard : S.card = 3)
    (hcap : GridCap (K := K) S) : Nonempty (TransportWitness S) := by
  classical
  rcases (Finset.card_eq_three.mp hcard) with ⟨p, q, r, hpq, hpr, hqr, hS⟩
  have hp : p ∈ S := by simp [hS]
  have hq : q ∈ S := by simp [hS]
  have hr : r ∈ S := by simp [hS]
  have hrow : q.1 - p.1 ≠ 0 :=
    ConicLocalization.gridCap_row_ne_of_ne (K := K) hcap hp hq hpq
  have hcol : q.2 - p.2 ≠ 0 :=
    ConicLocalization.gridCap_col_ne_of_ne (K := K) hcap hp hq hpq
  let f : P -> P := ConicLocalization.anchorAxisAffine (K := K) p q
  let x : P := f r
  have hf : ConicLocalization.GridSymmetry (K := K) f :=
    ConicLocalization.anchorAxisAffine_gridSymmetry (K := K) hrow hcol
  have hcapImage : GridCap (K := K) (S.image f) := (hf.2 S).2 hcap
  have himage : S.image f = ({pt 0 0, pt 1 1, x} : Finset P) := by
    rw [hS]
    simp [f, x, pt, ConicLocalization.anchorAxisAffine_left,
      ConicLocalization.anchorAxisAffine_right (K := K) hrow hcol]
  have hcardImage : (S.image f).card = S.card :=
    Finset.card_image_of_injOn (fun a _ha b _hb hab => hf.1.1 hab)
  have hcardAnchor : ({pt 0 0, pt 1 1, x} : Finset P).card = 3 := by
    rw [← himage, hcardImage, hcard]
  have hcapAnchor : GridCap (K := K) ({pt 0 0, pt 1 1, x} : Finset P) := by
    simpa [← himage] using hcapImage
  refine ⟨{
    classCert := classForThird x
    symmetry := f
    gridSymmetry := hf
    valid := classForThird_valid x
    representsImage := ?_
  }⟩
  rw [himage]
  exact classForThird_sizeThree_of_gridCap x hcardAnchor hcapAnchor

noncomputable def transportWitness (S : Finset P) (hcard : S.card = 3)
    (hcap : GridCap (K := K) S) : TransportWitness S :=
  Classical.choice (exists_transportWitness S hcard hcap)

noncomputable def transportBookCertificate :
    GridOddEscapeTransportBookCertificate K where
  classCert S hcard hcap := (transportWitness S hcard hcap).classCert
  symmetry S hcard hcap := (transportWitness S hcard hcap).symmetry
  gridSymmetry S hcard hcap := (transportWitness S hcard hcap).gridSymmetry
  representsImage S hcard hcap := (transportWitness S hcard hcap).representsImage
  valid S hcard hcap := (transportWitness S hcard hcap).valid

theorem oddEscapeGameStatement :
    Almost.OddEscapeGameStatement (K := K) :=
  transportBookCertificate.oddEscapeGameStatement

variable {V : Type*} [AddCommGroup V] [Module K V]
variable [Fintype (Projective.Point K V)] [DecidableEq (Projective.Point K V)]

theorem initialPStatement_finrank (hrank : Module.finrank K V = 3) :
    Projective.InitialPStatement (K := K) (V := V) :=
  GridMirror.initialPStatement_of_oddEscapeStatement_finrank
    (K := K) (V := V) oddEscapeGameStatement hrank

#print axioms initialPStatement_finrank

end Q11
end CertData
end Certificate
end ProjectiveCap
