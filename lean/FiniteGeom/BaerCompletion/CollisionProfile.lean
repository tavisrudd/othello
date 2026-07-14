import FiniteGeom.BaerCompletion.PairExtension

/-!
# Exact charge-support and collision accounting

This file separates three quantities that the uniform pair-extension bound deliberately conflates:

* a finite set of available obstruction orbits;
* the visible orbits that charge a candidate on a chosen carrier;
* the distinct support of those charges.

The difference between all and visible orbits is the invisible mass. The difference between
visible mass and support size is collision redundancy. The main theorem is subtraction-free, so it
remains exact over `ℕ` even when the first-order expression `N - M` truncates.

These are finite fiber-counting identities. Identifying geometric visibility with the position of a
Frobenius secant-orbit center is a separate incidence theorem.
-/

namespace FiniteGeom.BaerCompletion

open Finset

variable {R Q : Type*} [DecidableEq R] [DecidableEq Q]

/-- Distinct candidates hit by at least one visible obstruction orbit. -/
def chargeSupport (visible : Finset R) (charge : R → Q) : Finset Q :=
  visible.image charge

/-- Number of visible obstruction orbits charging a given candidate. -/
def chargeMultiplicity (visible : Finset R) (charge : R → Q) (q : Q) : ℕ :=
  (visible.filter fun r => charge r = q).card

/-- Excess visible charge mass beyond one charge per point of the support. -/
def collisionRedundancy (visible : Finset R) (charge : R → Q) : ℕ :=
  ∑ q ∈ chargeSupport visible charge, (chargeMultiplicity visible charge q - 1)

/-- Obstruction orbits that do not charge a candidate on the chosen carrier. -/
def invisibleOrbits (orbits visible : Finset R) : Finset R :=
  orbits \ visible

omit [DecidableEq R] in
theorem chargeMultiplicity_pos (visible : Finset R) (charge : R → Q)
    {q : Q} (hq : q ∈ chargeSupport visible charge) :
    0 < chargeMultiplicity visible charge q := by
  obtain ⟨r, hr, hcharge⟩ := Finset.mem_image.mp hq
  apply Finset.card_pos.mpr
  exact ⟨r, Finset.mem_filter.mpr ⟨hr, hcharge⟩⟩

omit [DecidableEq R] in
/-- Visible charge mass is distinct support plus collision redundancy. -/
theorem card_visible_eq_support_add_collisionRedundancy
    (visible : Finset R) (charge : R → Q) :
    visible.card =
      (chargeSupport visible charge).card + collisionRedundancy visible charge := by
  let support := chargeSupport visible charge
  have hmaps : ∀ r ∈ visible, charge r ∈ support := by
    intro r hr
    exact Finset.mem_image.mpr ⟨r, hr, rfl⟩
  have hfiber : visible.card =
      ∑ q ∈ support, chargeMultiplicity visible charge q := by
    rw [Finset.card_eq_sum_card_fiberwise hmaps]
    simp only [chargeMultiplicity]
  rw [hfiber]
  calc
    (∑ q ∈ support, chargeMultiplicity visible charge q) =
        ∑ q ∈ support, (1 + (chargeMultiplicity visible charge q - 1)) := by
      apply Finset.sum_congr rfl
      intro q hq
      have hpos : 0 < chargeMultiplicity visible charge q :=
        chargeMultiplicity_pos visible charge hq
      omega
    _ = (∑ _q ∈ support, 1) +
        ∑ q ∈ support, (chargeMultiplicity visible charge q - 1) := by
      rw [Finset.sum_add_distrib]
    _ = (chargeSupport visible charge).card + collisionRedundancy visible charge := by
      simp [support, collisionRedundancy]

/-- With multiplicity at most four, each local second-moment contribution is at most twice its
collision redundancy. -/
theorem choose_two_le_two_mul_pred_of_le_four {n : ℕ} (hn : n ≤ 4) :
    n.choose 2 ≤ 2 * (n - 1) := by
  interval_cases n <;> decide

/-- A capped secant index has second moment at most three halves of its first moment. -/
theorem two_mul_choose_two_le_three_mul_of_le_four {n : ℕ} (hn : n ≤ 4) :
    2 * n.choose 2 ≤ 3 * n := by
  interval_cases n <;> decide

/-- If one fixed secant is already present and at most three nonfixed secants remain, the local
second moment is at most twice the number of nonfixed secants. -/
theorem choose_two_succ_le_two_mul_of_le_three {r : ℕ} (hr : r ≤ 3) :
    (r + 1).choose 2 ≤ 2 * r := by
  interval_cases r <;> decide

omit [DecidableEq R] in
/-- Summed second moment is controlled by twice the collision redundancy when every charge fiber
has size at most four. -/
theorem sum_choose_chargeMultiplicity_le_two_mul_collisionRedundancy
    (visible : Finset R) (charge : R → Q)
    (hle : ∀ q ∈ chargeSupport visible charge, chargeMultiplicity visible charge q ≤ 4) :
    (∑ q ∈ chargeSupport visible charge,
        (chargeMultiplicity visible charge q).choose 2) ≤
      2 * collisionRedundancy visible charge := by
  unfold collisionRedundancy
  rw [Finset.mul_sum]
  apply Finset.sum_le_sum
  intro q hq
  exact choose_two_le_two_mul_pred_of_le_four (hle q hq)

/-- Exact decomposition of all obstruction orbits into invisible mass, distinct visible support,
and collision redundancy. -/
theorem card_orbits_eq_invisible_add_support_add_redundancy
    (orbits visible : Finset R) (charge : R → Q) (hvisible : visible ⊆ orbits) :
    orbits.card = (invisibleOrbits orbits visible).card +
      (chargeSupport visible charge).card + collisionRedundancy visible charge := by
  have hinvisible := Finset.card_sdiff_add_card_eq_card hvisible
  have hvisible := card_visible_eq_support_add_collisionRedundancy visible charge
  unfold invisibleOrbits
  omega

/-- Subtraction-free exact legal-count correction. If charge support lies in the candidate set,
then legal candidates plus all obstruction orbits equal all candidates plus invisible mass plus
collision redundancy. -/
theorem card_legal_add_orbits_eq_candidates_add_invisible_add_redundancy
    (orbits visible : Finset R) (candidates : Finset Q) (charge : R → Q)
    (hvisible : visible ⊆ orbits)
    (hsupport : chargeSupport visible charge ⊆ candidates) :
    (candidates \ chargeSupport visible charge).card + orbits.card =
      candidates.card + (invisibleOrbits orbits visible).card +
        collisionRedundancy visible charge := by
  have hcandidates := Finset.card_sdiff_add_card_eq_card hsupport
  have horbits :=
    card_orbits_eq_invisible_add_support_add_redundancy orbits visible charge hvisible
  omega

variable {L : Type*} [DecidableEq L]

omit [DecidableEq L] in
/-- Aggregate exact balance over a finite family of carriers. -/
theorem sum_card_legal_add_carriers_mul_orbits_eq_sum_candidates_add_invisible_add_redundancy
    (carriers : Finset L) (orbits : Finset R)
    (visible : L → Finset R) (candidates : L → Finset Q) (charge : L → R → Q)
    (hvisible : ∀ l ∈ carriers, visible l ⊆ orbits)
    (hsupport : ∀ l ∈ carriers, chargeSupport (visible l) (charge l) ⊆ candidates l) :
    (∑ l ∈ carriers, (candidates l \ chargeSupport (visible l) (charge l)).card) +
        carriers.card * orbits.card =
      (∑ l ∈ carriers, (candidates l).card) +
        (∑ l ∈ carriers, (invisibleOrbits orbits (visible l)).card) +
          ∑ l ∈ carriers, collisionRedundancy (visible l) (charge l) := by
  have hsum :
      (∑ l ∈ carriers,
          ((candidates l \ chargeSupport (visible l) (charge l)).card + orbits.card)) =
        ∑ l ∈ carriers,
          ((candidates l).card + (invisibleOrbits orbits (visible l)).card +
            collisionRedundancy (visible l) (charge l)) := by
    apply Finset.sum_congr rfl
    intro l hl
    exact card_legal_add_orbits_eq_candidates_add_invisible_add_redundancy
      orbits (visible l) (candidates l) (charge l) (hvisible l hl) (hsupport l hl)
  simpa [Finset.sum_add_distrib, Finset.sum_const_nat] using hsum

omit [DecidableEq L] in
/-- If candidates plus invisible mass already exceed the first-order orbit budget in aggregate,
then some carrier has a legal candidate. Collision redundancy can only strengthen the conclusion. -/
theorem exists_legal_of_carriers_mul_orbits_lt_sum_candidates_add_invisible
    (carriers : Finset L) (orbits : Finset R)
    (visible : L → Finset R) (candidates : L → Finset Q) (charge : L → R → Q)
    (hvisible : ∀ l ∈ carriers, visible l ⊆ orbits)
    (hsupport : ∀ l ∈ carriers, chargeSupport (visible l) (charge l) ⊆ candidates l)
    (hcapacity : carriers.card * orbits.card <
      (∑ l ∈ carriers, (candidates l).card) +
        ∑ l ∈ carriers, (invisibleOrbits orbits (visible l)).card) :
    ∃ l ∈ carriers, (candidates l \ chargeSupport (visible l) (charge l)).Nonempty := by
  have hbalance :=
    sum_card_legal_add_carriers_mul_orbits_eq_sum_candidates_add_invisible_add_redundancy
      carriers orbits visible candidates charge hvisible hsupport
  have hpositive : 0 <
      ∑ l ∈ carriers, (candidates l \ chargeSupport (visible l) (charge l)).card := by
    omega
  rw [Finset.sum_pos_iff] at hpositive
  obtain ⟨l, hl, hcard⟩ := hpositive
  exact ⟨l, hl, Finset.card_pos.mp hcard⟩

end FiniteGeom.BaerCompletion
