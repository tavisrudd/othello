import RelativeConicArcs.SixArcChordMatchings

/-!
# Hexagonal order from two chord matchings without a common chord

Let `A` be a six-element point set and let `M` and `N` be chord matchings of `A` — each a set of
three chords with pairwise disjoint endpoint pairs — with no chord in common.  Then the six chords
of `M` and `N` form a single closed hexagon on `A`: the points of `A` can be listed as
`p₁, …, p₆` so that

```
M = {p₁p₂, p₃p₄, p₅p₆},   N = {p₂p₃, p₄p₅, p₆p₁}.
```

This is the labelling step that puts a six-point configuration in hexagonal position.  It is purely
combinatorial: no incidence structure, no coordinates, and no arc hypothesis appear.

The construction walks the hexagon.  Fix a chord `p₁p₂` of `M`.  The chord of `N` through `p₁` and
the chord of `N` through `p₂` reach two of the four remaining points, and those two points lie in
different chords of `M`: if they lay in the same chord of `M`, the two points left over would be
joined by a chord belonging to `M` and to `N` alike, which having no common chord forbids.  The
third chord of `N` then joins the two points not yet reached, closing the hexagon.
-/

namespace RelativeConicArcs
namespace SixArcHexagonalOrder

open Finset
open SixArcChordMatchings

variable {P : Type*} [DecidableEq P]

/-- A six-entry list enumerating a six-element set has no repeated entry. -/
private theorem nodup_of_toFinset_eq {A : Finset P} (hcard : A.card = 6) {l : List P}
    (hl : l.toFinset = A) (hlen : l.length = 6) : l.Nodup := by
  have h1 : (↑l : Multiset P).toFinset.card = Multiset.card (↑l : Multiset P) := by
    rw [Multiset.coe_card]
    show l.toFinset.card = l.length
    rw [hl, hcard, hlen]
  exact Multiset.coe_nodup.mp (Multiset.toFinset_card_eq_card_iff_nodup.mp h1)

omit [DecidableEq P] in
/-- Two chords of `N` are distinct once one contains a point the other misses. -/
private theorem ne_of_mem_notMem {A : Finset P} {n₁ n₂ : ArcPair A} {p : P}
    (h₁ : p ∈ n₁.1) (h₂ : p ∉ n₂.1) : n₁ ≠ n₂ := fun h => h₂ (h ▸ h₁)

/-- Exchanging the last two entries of a three-element set. -/
private theorem insert_pair_comm (a b c : P) : ({a, b, c} : Finset P) = {a, c, b} := by
  rw [Finset.pair_comm b c]

/-- The six points of a chord matching of a six-element set, listed by its three chords. -/
private theorem eq_six_of_chords {A : Finset P} (hcard : A.card = 6)
    {M : Finset (ArcPair A)} (hM : IsChordMatching A M) {c₁ c₂ c₃ : ArcPair A}
    (hMval : M = {c₁, c₂, c₃}) {a₁ a₂ b₁ b₂ d₁ d₂ : P}
    (h₁ : c₁.1 = {a₁, a₂}) (h₂ : c₂.1 = {b₁, b₂}) (h₃ : c₃.1 = {d₁, d₂}) :
    A = {a₁, a₂, b₁, b₂, d₁, d₂} := by
  classical
  rw [← biUnion_eq_of_isChordMatching hcard hM, hMval]
  ext p
  simp only [Finset.mem_biUnion, Finset.mem_insert, Finset.mem_singleton]
  constructor
  · rintro ⟨c, hc, hpc⟩
    rcases hc with rfl | rfl | rfl
    · rw [h₁] at hpc
      simp only [Finset.mem_insert, Finset.mem_singleton] at hpc
      tauto
    · rw [h₂] at hpc
      simp only [Finset.mem_insert, Finset.mem_singleton] at hpc
      tauto
    · rw [h₃] at hpc
      simp only [Finset.mem_insert, Finset.mem_singleton] at hpc
      tauto
  · intro hp
    rcases hp with rfl | rfl | rfl | rfl | rfl | rfl
    · exact ⟨c₁, by tauto, by rw [h₁]; simp⟩
    · exact ⟨c₁, by tauto, by rw [h₁]; simp⟩
    · exact ⟨c₂, by tauto, by rw [h₂]; simp⟩
    · exact ⟨c₂, by tauto, by rw [h₂]; simp⟩
    · exact ⟨c₃, by tauto, by rw [h₃]; simp⟩
    · exact ⟨c₃, by tauto, by rw [h₃]; simp⟩

/-- Deleting two disjoint pairs from six distinct points leaves the remaining pair. -/
private theorem pair_eq_sdiff_union {x₁ x₂ u u' w w' : P}
    (h₁ : w ≠ x₁) (h₂ : w ≠ x₂) (h₃ : w ≠ u) (h₄ : w ≠ u')
    (h₅ : w' ≠ x₁) (h₆ : w' ≠ x₂) (h₇ : w' ≠ u) (h₈ : w' ≠ u') :
    ({w, w'} : Finset P) =
      ({x₁, x₂, u, u', w, w'} : Finset P) \ (({x₁, u} : Finset P) ∪ {x₂, u'}) := by
  ext p
  simp only [Finset.mem_insert, Finset.mem_singleton, Finset.mem_sdiff, Finset.mem_union]
  constructor
  · rintro (rfl | rfl)
    · exact ⟨by simp, by simp [h₁, h₂, h₃, h₄]⟩
    · exact ⟨by simp, by simp [h₅, h₆, h₇, h₈]⟩
  · rintro ⟨hp, hp'⟩
    rcases hp with rfl | rfl | rfl | rfl | rfl | rfl
    · simp at hp'
    · simp at hp'
    · simp at hp'
    · simp at hp'
    · exact Or.inl rfl
    · exact Or.inr rfl

/-- The two chords of `N` through the endpoints of a chord of `M` cannot reach the same chord of
`M`: the two points left over would then carry a chord of `M` that is also the third chord of `N`. -/
private theorem not_partners_in_same_chord {A : Finset P} (hcard : A.card = 6)
    {M N : Finset (ArcPair A)} (hM : IsChordMatching A M) (hN : IsChordMatching A N)
    (hMN : Disjoint M N) {x₁ x₂ u u' w w' : P}
    {m₁ mU mW n₁ n₂ : ArcPair A} (hMval : M = {m₁, mU, mW})
    (hm₁ : m₁.1 = {x₁, x₂}) (hmU : mU.1 = {u, u'}) (hmW : mW.1 = {w, w'})
    (hn₁N : n₁ ∈ N) (hn₁ : n₁.1 = {x₁, u}) (hn₂N : n₂ ∈ N) (hn₂ : n₂.1 = {x₂, u'}) : False := by
  classical
  have hAval : A = {x₁, x₂, u, u', w, w'} := eq_six_of_chords hcard hM hMval hm₁ hmU hmW
  have hmWM : mW ∈ M := by rw [hMval]; simp
  have hnodup : ([x₁, x₂, u, u', w, w'] : List P).Nodup :=
    nodup_of_toFinset_eq hcard (by rw [hAval]; simp) rfl
  simp only [List.nodup_cons, List.mem_cons, List.not_mem_nil,
    not_or, List.nodup_nil, not_false_eq_true, and_true] at hnodup
  obtain ⟨⟨hx₁x₂, hx₁u, hx₁u', hx₁w, hx₁w'⟩, ⟨hx₂u, hx₂u', hx₂w, hx₂w'⟩,
    ⟨huu', huw, huw'⟩, ⟨hu'w, hu'w'⟩, hww'⟩ := hnodup
  have hn₁n₂ : n₁ ≠ n₂ :=
    ne_of_mem_notMem (p := x₁) (by rw [hn₁]; simp)
      (by rw [hn₂]; simp [hx₁x₂, hx₁u'])
  have hNval : N = {n₁, n₂, mW} := by
    refine eq_triple_of_mem hcard hN hn₁N hn₂N hn₁n₂ ?_
    rw [hmW, hn₁, hn₂, hAval]
    exact pair_eq_sdiff_union (Ne.symm hx₁w) (Ne.symm hx₂w) (Ne.symm huw) (Ne.symm hu'w)
      (Ne.symm hx₁w') (Ne.symm hx₂w') (Ne.symm huw') (Ne.symm hu'w')
  exact Finset.disjoint_left.mp hMN hmWM (by rw [hNval]; simp)

/-- The hexagonal order, assembled from the chords of `N` through the endpoints of one chord of `M`.
Here `x₁x₂` is a chord of `M`, the other two chords of `M` are `qq'` and `rr'`, and `N` contains
`x₁q` and `x₂r`. -/
private theorem hexagonal_order_of_partners {A : Finset P} (hcard : A.card = 6)
    {M N : Finset (ArcPair A)} (hM : IsChordMatching A M) (hN : IsChordMatching A N)
    {x₁ x₂ q q' r r' : P}
    {m₁ mQ mR n₁ n₂ : ArcPair A}
    (hm₁ : m₁.1 = {x₁, x₂}) (hmQ : mQ.1 = {q, q'}) (hmR : mR.1 = {r, r'})
    (hMval : M = {m₁, mQ, mR})
    (hn₁N : n₁ ∈ N) (hn₁ : n₁.1 = {x₁, q}) (hn₂N : n₂ ∈ N) (hn₂ : n₂.1 = {x₂, r}) :
    ∃ (p₁ p₂ p₃ p₄ p₅ p₆ : P) (c₁ c₂ c₃ d₁ d₂ d₃ : ArcPair A),
      ([p₁, p₂, p₃, p₄, p₅, p₆] : List P).Nodup ∧
      A = {p₁, p₂, p₃, p₄, p₅, p₆} ∧
      c₁.1 = {p₁, p₂} ∧ c₂.1 = {p₃, p₄} ∧ c₃.1 = {p₅, p₆} ∧
      d₁.1 = {p₂, p₃} ∧ d₂.1 = {p₄, p₅} ∧ d₃.1 = {p₆, p₁} ∧
      M = {c₁, c₂, c₃} ∧ N = {d₁, d₂, d₃} := by
  classical
  have hAval : A = {x₁, x₂, q, q', r, r'} := eq_six_of_chords hcard hM hMval hm₁ hmQ hmR
  have hnodup : ([x₁, x₂, q, q', r, r'] : List P).Nodup :=
    nodup_of_toFinset_eq hcard (by rw [hAval]; simp) rfl
  simp only [List.nodup_cons, List.mem_cons, List.not_mem_nil,
    not_or, List.nodup_nil, not_false_eq_true, and_true] at hnodup
  obtain ⟨⟨hx₁x₂, hx₁q, hx₁q', hx₁r, hx₁r'⟩, ⟨hx₂q, hx₂q', hx₂r, hx₂r'⟩,
    ⟨hqq', hqr, hqr'⟩, ⟨hq'r, hq'r'⟩, hrr'⟩ := hnodup
  have hn₁n₂ : n₁ ≠ n₂ :=
    ne_of_mem_notMem (p := x₁) (by rw [hn₁]; simp) (by rw [hn₂]; simp [hx₁x₂, hx₁r])
  obtain ⟨n₃, hn₃⟩ : ∃ t : ArcPair A, t.1 = {q', r'} :=
    exists_arcPair_val (by rw [hAval]; simp) (by rw [hAval]; simp) hq'r'
  have hNval : N = {n₁, n₂, n₃} := by
    refine eq_triple_of_mem hcard hN hn₁N hn₂N hn₁n₂ ?_
    rw [hn₃, hn₁, hn₂, hAval,
      show ({x₁, x₂, q, q', r, r'} : Finset P) = {x₁, x₂, q, r, q', r'} by
        ext p; simp only [Finset.mem_insert, Finset.mem_singleton]; tauto]
    exact pair_eq_sdiff_union (Ne.symm hx₁q') (Ne.symm hx₂q') (Ne.symm hqq') hq'r
      (Ne.symm hx₁r') (Ne.symm hx₂r') (Ne.symm hqr') (Ne.symm hrr')
  refine ⟨x₁, x₂, r, r', q', q, m₁, mR, mQ, n₂, n₃, n₁, ?_, ?_, hm₁, hmR, ?_, hn₂, ?_, ?_, ?_, ?_⟩
  · exact nodup_of_toFinset_eq hcard (by rw [hAval]; ext p; simp; tauto) rfl
  · rw [hAval]; ext p; simp; tauto
  · rw [hmQ]; exact Finset.pair_comm q q'
  · rw [hn₃]; exact Finset.pair_comm q' r'
  · rw [hn₁]; exact Finset.pair_comm x₁ q
  · rw [hMval]; ext c; simp; tauto
  · rw [hNval]; ext c; simp; tauto

/-- **Two chord matchings of a six-element set without a common chord close a hexagon.**  The points
of `A` can be listed as `p₁, …, p₆` so that the chords of the first matching are `p₁p₂`, `p₃p₄` and
`p₅p₆`, and those of the second are `p₂p₃`, `p₄p₅` and `p₆p₁`. -/
theorem exists_hexagonal_order {A : Finset P} (hcard : A.card = 6)
    {M N : Finset (ArcPair A)} (hM : IsChordMatching A M) (hN : IsChordMatching A N)
    (hMN : Disjoint M N) :
    ∃ (p₁ p₂ p₃ p₄ p₅ p₆ : P) (c₁ c₂ c₃ d₁ d₂ d₃ : ArcPair A),
      ([p₁, p₂, p₃, p₄, p₅, p₆] : List P).Nodup ∧
      A = {p₁, p₂, p₃, p₄, p₅, p₆} ∧
      c₁.1 = {p₁, p₂} ∧ c₂.1 = {p₃, p₄} ∧ c₃.1 = {p₅, p₆} ∧
      d₁.1 = {p₂, p₃} ∧ d₂.1 = {p₄, p₅} ∧ d₃.1 = {p₆, p₁} ∧
      M = {c₁, c₂, c₃} ∧ N = {d₁, d₂, d₃} := by
  classical
  obtain ⟨m₁, m₂, m₃, h₁₂, h₁₃, h₂₃, hMval⟩ := Finset.card_eq_three.mp hM.1
  obtain ⟨x₁, x₂, hx, hm₁⟩ := m₁.exists_eq_pair
  obtain ⟨y₁, y₂, hy, hm₂⟩ := m₂.exists_eq_pair
  obtain ⟨z₁, z₂, hz, hm₃⟩ := m₃.exists_eq_pair
  have hA6 : A = {x₁, x₂, y₁, y₂, z₁, z₂} :=
    eq_six_of_chords hcard hM hMval hm₁ hm₂ hm₃
  have hmemM : ∀ {c : ArcPair A}, c ∈ ({m₁, m₂, m₃} : Finset (ArcPair A)) → c ∈ M := by
    intro c hc; rw [hMval]; exact hc
  obtain ⟨n₁, q, hn₁N, hqx₁, hn₁⟩ :=
    exists_mem_val_pair hcard hN (show x₁ ∈ A by rw [hA6]; simp)
  obtain ⟨n₂, r, hn₂N, hrx₂, hn₂⟩ :=
    exists_mem_val_pair hcard hN (show x₂ ∈ A by rw [hA6]; simp)
  have hqx₂ : q ≠ x₂ := by
    intro h
    have hn : n₁ = m₁ := Subtype.ext (by rw [hn₁, hm₁, h])
    exact Finset.disjoint_left.mp hMN (hmemM (by simp)) (hn ▸ hn₁N)
  have hrx₁ : r ≠ x₁ := by
    intro h
    have hn : n₂ = m₁ := Subtype.ext (by rw [hn₂, hm₁, h]; exact Finset.pair_comm x₂ x₁)
    exact Finset.disjoint_left.mp hMN (hmemM (by simp)) (hn ▸ hn₂N)
  have hqr : q ≠ r := by
    intro h
    have hne : n₁ ≠ n₂ :=
      ne_of_mem_notMem (p := x₁) (by rw [hn₁]; simp)
        (by rw [hn₂]; simp [hx, Ne.symm hrx₁])
    have hq₁ : q ∈ n₁.1 := by rw [hn₁]; simp
    have hq₂ : q ∈ n₂.1 := by rw [hn₂, h]; simp
    exact Finset.disjoint_left.mp (hN.2 hn₁N hn₂N hne) hq₁ hq₂
  have hqmem : q ∈ ({y₁, y₂, z₁, z₂} : Finset P) := by
    have hqA : q ∈ A := n₁.subset (by rw [hn₁]; simp)
    rw [hA6] at hqA
    simp only [Finset.mem_insert, Finset.mem_singleton] at hqA ⊢
    rcases hqA with h | h | h | h | h | h
    · exact absurd h hqx₁
    · exact absurd h hqx₂
    · exact Or.inl h
    · exact Or.inr (Or.inl h)
    · exact Or.inr (Or.inr (Or.inl h))
    · exact Or.inr (Or.inr (Or.inr h))
  have hrmem : r ∈ ({y₁, y₂, z₁, z₂} : Finset P) := by
    have hrA : r ∈ A := n₂.subset (by rw [hn₂]; simp)
    rw [hA6] at hrA
    simp only [Finset.mem_insert, Finset.mem_singleton] at hrA ⊢
    rcases hrA with h | h | h | h | h | h
    · exact absurd h hrx₁
    · exact absurd h hrx₂
    · exact Or.inl h
    · exact Or.inr (Or.inl h)
    · exact Or.inr (Or.inr (Or.inl h))
    · exact Or.inr (Or.inr (Or.inr h))
  simp only [Finset.mem_insert, Finset.mem_singleton] at hqmem hrmem
  rcases hqmem with hq | hq | hq | hq <;> rcases hrmem with hr | hr | hr | hr
  -- the partner of `x₁` lies in the second chord of `M`
  · exact absurd (hq.trans hr.symm) hqr
  · exact (not_partners_in_same_chord hcard hM hN hMN hMval hm₁
      (by rw [hq, hr]; exact hm₂) hm₃ hn₁N hn₁ hn₂N hn₂).elim
  · exact hexagonal_order_of_partners hcard hM hN hm₁ (by rw [hq]; exact hm₂)
      (by rw [hr]; exact hm₃) hMval hn₁N hn₁ hn₂N hn₂
  · exact hexagonal_order_of_partners hcard hM hN hm₁ (by rw [hq]; exact hm₂)
      (by rw [hr, hm₃]; exact Finset.pair_comm z₁ z₂) hMval hn₁N hn₁ hn₂N hn₂
  · exact (not_partners_in_same_chord hcard hM hN hMN hMval hm₁
      (by rw [hq, hr, hm₂]; exact Finset.pair_comm y₁ y₂) hm₃ hn₁N hn₁ hn₂N hn₂).elim
  · exact absurd (hq.trans hr.symm) hqr
  · exact hexagonal_order_of_partners hcard hM hN hm₁
      (by rw [hq, hm₂]; exact Finset.pair_comm y₁ y₂) (by rw [hr]; exact hm₃)
      hMval hn₁N hn₁ hn₂N hn₂
  · exact hexagonal_order_of_partners hcard hM hN hm₁
      (by rw [hq, hm₂]; exact Finset.pair_comm y₁ y₂)
      (by rw [hr, hm₃]; exact Finset.pair_comm z₁ z₂) hMval hn₁N hn₁ hn₂N hn₂
  -- the partner of `x₁` lies in the third chord of `M`
  · exact hexagonal_order_of_partners hcard hM hN hm₁ (by rw [hq]; exact hm₃)
      (by rw [hr]; exact hm₂) (by rw [hMval]; exact insert_pair_comm m₁ m₂ m₃)
      hn₁N hn₁ hn₂N hn₂
  · exact hexagonal_order_of_partners hcard hM hN hm₁ (by rw [hq]; exact hm₃)
      (by rw [hr, hm₂]; exact Finset.pair_comm y₁ y₂)
      (by rw [hMval]; exact insert_pair_comm m₁ m₂ m₃) hn₁N hn₁ hn₂N hn₂
  · exact absurd (hq.trans hr.symm) hqr
  · exact (not_partners_in_same_chord hcard hM hN hMN
      (by rw [hMval]; exact insert_pair_comm m₁ m₂ m₃) hm₁
      (by rw [hq, hr]; exact hm₃) hm₂ hn₁N hn₁ hn₂N hn₂).elim
  · exact hexagonal_order_of_partners hcard hM hN hm₁
      (by rw [hq, hm₃]; exact Finset.pair_comm z₁ z₂) (by rw [hr]; exact hm₂)
      (by rw [hMval]; exact insert_pair_comm m₁ m₂ m₃) hn₁N hn₁ hn₂N hn₂
  · exact hexagonal_order_of_partners hcard hM hN hm₁
      (by rw [hq, hm₃]; exact Finset.pair_comm z₁ z₂)
      (by rw [hr, hm₂]; exact Finset.pair_comm y₁ y₂)
      (by rw [hMval]; exact insert_pair_comm m₁ m₂ m₃) hn₁N hn₁ hn₂N hn₂
  · exact (not_partners_in_same_chord hcard hM hN hMN
      (by rw [hMval]; exact insert_pair_comm m₁ m₂ m₃) hm₁
      (by rw [hq, hr, hm₃]; exact Finset.pair_comm z₁ z₂) hm₂ hn₁N hn₁ hn₂N hn₂).elim
  · exact absurd (hq.trans hr.symm) hqr

end SixArcHexagonalOrder
end RelativeConicArcs
