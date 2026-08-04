import RelativeConicArcs.Moments
import RelativeConicArcs.ProjectiveBridge

/-!
# Triple-concurrence points of a six-arc

For an arc `A` in a projective plane, an off-arc point lies on at most `|A| / 2` secants of `A`,
because the secants through it meet `A` in pairwise disjoint pairs.  For a six-arc the extreme case
is a point lying on three secants, whose three pairs of endpoints therefore partition the six arc
points.  Such points are the *triple-concurrence points* of the arc; classically they are the
Brianchon points of a hexagon.

Everything here is incidence-theoretic and holds in an arbitrary finite projective plane.  The
results describe how the chords through a triple-concurrence point pair up the arc: they partition
the six arc points, two such points on a common secant cannot share a chord, and once one chord of
such a point is known its remaining chord joins the two remaining arc points off the secant.

The counting result of this file is conditional: it reduces a bound of ten triple-concurrence
points to a bound of two of them on each secant, by counting incidences between the arc's fifteen
secants and its triple-concurrence points in two ways.  The per-secant bound needs coordinates and
a field in which two is invertible; it, and the resulting unconditional bound, are established in
`RelativeConicArcs.SixArcConcurrenceBound`.
-/

namespace RelativeConicArcs
namespace SixArcConcurrence

open Finset Configuration

section Plane

variable {P L : Type*} [Membership P L] [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

noncomputable local instance instDecidableIncidence (p : P) (l : L) : Decidable (p ∈ l) :=
  Classical.propDecidable _

/-- The off-arc points lying on three secants of `A`. -/
noncomputable def triplePoints (A : Finset P) : Finset P := by
  classical
  exact (Finset.univ \ A).filter fun x => pointIndex (L := L) A x = 3

theorem mem_triplePoints {A : Finset P} {x : P} :
    x ∈ triplePoints (L := L) A ↔ x ∉ A ∧ pointIndex (L := L) A x = 3 := by
  classical
  simp [triplePoints]

/-- Through a triple-concurrence point of a six-arc, every arc point has a joining secant. -/
theorem exists_pair_through {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 6)
    {x : P} (hx : x ∈ triplePoints (L := L) A) {p : P} (hp : p ∈ A) :
    ∃ f : ArcPair A, p ∈ f.1 ∧ x ∈ f.line (L := L) := by
  classical
  obtain ⟨hxA, hidx⟩ := mem_triplePoints.mp hx
  set E := pairsThrough (L := L) A x with hE
  have hEcard : E.card = 3 := by
    rw [hE, ← pointIndex_eq_card_pairsThrough (L := L) hA x]
    exact hidx
  have hdisj : ((E : Finset (ArcPair A)) : Set (ArcPair A)).PairwiseDisjoint fun f => f.1 := by
    simpa [hE] using pairsThrough_pairwiseDisjoint (L := L) hA hxA
  set U := E.biUnion fun f => f.1 with hU
  have hUcard : U.card = 6 := by
    rw [hU, Finset.card_biUnion hdisj]
    calc
      (∑ f ∈ E, f.1.card) = ∑ _f ∈ E, 2 := Finset.sum_congr rfl fun f _ => f.card
      _ = 6 := by simp [Finset.sum_const, hEcard]
  have hUsub : U ⊆ A := by
    intro q hq
    obtain ⟨f, _hf, hqf⟩ := Finset.mem_biUnion.mp hq
    exact f.subset hqf
  have hUA : U = A := Finset.eq_of_subset_of_card_le hUsub (by rw [hUcard, hcard])
  have hpU : p ∈ U := by rw [hUA]; exact hp
  obtain ⟨f, hf, hpf⟩ := Finset.mem_biUnion.mp hpU
  exact ⟨f, hpf, mem_pairsThrough.mp (by simpa [hE] using hf)⟩

omit [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L] in
/-- Two lines through the same two distinct points coincide. -/
private theorem line_eq_of_two_points {l m : L} {x y : P} (hxy : x ≠ y)
    (hxl : x ∈ l) (hyl : y ∈ l) (hxm : x ∈ m) (hym : y ∈ m) : l = m := by
  obtain ⟨n, _hn, huniq⟩ := Configuration.HasLines.existsUnique_line (P := P) (L := L) x y hxy
  rw [huniq l ⟨hxl, hyl⟩, huniq m ⟨hxm, hym⟩]

/-- Through a triple-concurrence point on a secant, every arc point off that secant is joined to a
second arc point off that secant. -/
theorem exists_partner_off_secant {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 6)
    {e : ArcPair A} {x : P} (hx : x ∈ triplePoints (L := L) A) (hxe : x ∈ e.line (L := L))
    {a : P} (ha : a ∈ A \ e.1) :
    ∃ b ∈ A \ e.1, b ≠ a ∧ RelativeConicArcs.Collinear (L := L) a b x := by
  classical
  obtain ⟨hxA, _hidx⟩ := mem_triplePoints.mp hx
  obtain ⟨f, haf, hxf⟩ := exists_pair_through (L := L) hA hcard hx (Finset.mem_sdiff.mp ha).1
  obtain ⟨p, q, hpq, hfpq⟩ := f.exists_eq_pair
  set r : P := if a = p then q else p with hr
  have hrf : r ∈ f.1 := by
    rw [hfpq]
    by_cases h : a = p
    · rw [hr, if_pos h]; simp
    · rw [hr, if_neg h]; simp
  have hra : r ≠ a := by
    by_cases h : a = p
    · have hrq : r = q := by rw [hr, if_pos h]
      rw [hrq, h]
      exact fun hqp => hpq hqp.symm
    · have hrp : r = p := by rw [hr, if_neg h]
      rw [hrp]
      exact fun hpa => h hpa.symm
  have hrA : r ∈ A := f.subset hrf
  have hdisj : ((pairsThrough (L := L) A x : Finset (ArcPair A)) : Set (ArcPair A)).PairwiseDisjoint
      fun h => h.1 := pairsThrough_pairwiseDisjoint (L := L) hA hxA
  have hfmem : f ∈ pairsThrough (L := L) A x := mem_pairsThrough.mpr hxf
  have hemem : e ∈ pairsThrough (L := L) A x := mem_pairsThrough.mpr hxe
  have hfe : f ≠ e := by
    intro hfeeq
    have : a ∈ e.1 := by rw [← hfeeq]; exact haf
    exact (Finset.mem_sdiff.mp ha).2 this
  have hre : r ∉ e.1 := fun hre =>
    (Finset.disjoint_left.mp (hdisj hfmem hemem hfe) hrf) hre
  exact ⟨r, Finset.mem_sdiff.mpr ⟨hrA, hre⟩, hra,
    ⟨f.line (L := L), f.mem_line haf, f.mem_line hrf, hxf⟩⟩

/-- Through a triple-concurrence point on a fixed secant, a fourth arc point off that secant is
joined to the one remaining arc point.  Here `a` and `b` are the endpoints of one chord through
`x`, and `c`, `d` are the two remaining arc points off the fixed secant. -/
theorem collinear_complement {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 6)
    {e : ArcPair A} {x : P} (hx : x ∈ triplePoints (L := L) A) (hxe : x ∈ e.line (L := L))
    {a b c d : P}
    (ha : a ∈ A \ e.1) (hb : b ∈ A \ e.1) (hc : c ∈ A \ e.1) (hd : d ∈ A \ e.1)
    (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d) (hbc : b ≠ c) (hbd : b ≠ d) (hcd : c ≠ d)
    (hcol : RelativeConicArcs.Collinear (L := L) a b x) :
    RelativeConicArcs.Collinear (L := L) c d x := by
  classical
  obtain ⟨hxA, hidx⟩ := mem_triplePoints.mp hx
  -- the chord of `x` through `c`
  obtain ⟨f, hcf, hxf⟩ := exists_pair_through (L := L) hA hcard hx (Finset.mem_sdiff.mp hc).1
  obtain ⟨p, q, hpq, hfpq⟩ := f.exists_eq_pair
  set r : P := if c = p then q else p with hr
  have hrf : r ∈ f.1 := by
    rw [hfpq]
    by_cases h : c = p
    · rw [hr, if_pos h]; simp
    · rw [hr, if_neg h]; simp
  have hrc : r ≠ c := by
    by_cases h : c = p
    · have hrq : r = q := by rw [hr, if_pos h]
      rw [hrq, h]
      exact fun hqp => hpq hqp.symm
    · have hrp : r = p := by rw [hr, if_neg h]
      rw [hrp]
      exact fun hpc => h hpc.symm
  have hrA : r ∈ A := f.subset hrf
  have hcolcr : RelativeConicArcs.Collinear (L := L) c r x :=
    ⟨f.line (L := L), f.mem_line hcf, f.mem_line hrf, hxf⟩
  -- the chord through `a` and `b`
  have haA : a ∈ A := (Finset.mem_sdiff.mp ha).1
  have hbA : b ∈ A := (Finset.mem_sdiff.mp hb).1
  obtain ⟨lab, halab, hblab, hxlab⟩ := hcol
  have hgpair : ∃ g : ArcPair A, g.1 = {a, b} := by
    refine ⟨⟨{a, b}, ?_⟩, rfl⟩
    rw [Finset.mem_powersetCard]
    exact ⟨by
      intro p hp
      simp only [Finset.mem_insert, Finset.mem_singleton] at hp
      rcases hp with rfl | rfl
      · exact haA
      · exact hbA, by simp [hab]⟩
  obtain ⟨g, hg⟩ := hgpair
  have hxg : x ∈ g.line (L := L) := by
    have : g.line (L := L) = lab := by
      apply g.line_unique
      intro p hp
      rw [hg] at hp
      simp only [Finset.mem_insert, Finset.mem_singleton] at hp
      rcases hp with rfl | rfl
      · exact halab
      · exact hblab
    rw [this]
    exact hxlab
  -- `f`, `g` and `e` are three distinct chords through `x`, so their endpoint pairs are disjoint
  have hdisj : ((pairsThrough (L := L) A x : Finset (ArcPair A)) : Set (ArcPair A)).PairwiseDisjoint
      fun h => h.1 := pairsThrough_pairwiseDisjoint (L := L) hA hxA
  have hfmem : f ∈ pairsThrough (L := L) A x := mem_pairsThrough.mpr hxf
  have hgmem : g ∈ pairsThrough (L := L) A x := mem_pairsThrough.mpr hxg
  have hemem : e ∈ pairsThrough (L := L) A x := mem_pairsThrough.mpr hxe
  have hfg : f ≠ g := by
    intro hfgeq
    have : c ∈ g.1 := by rw [← hfgeq]; exact hcf
    rw [hg] at this
    simp only [Finset.mem_insert, Finset.mem_singleton] at this
    rcases this with h | h
    · exact hac h.symm
    · exact hbc h.symm
  have hfe : f ≠ e := by
    intro hfeeq
    have : c ∈ e.1 := by rw [← hfeeq]; exact hcf
    exact (Finset.mem_sdiff.mp hc).2 this
  have hrg : r ∉ g.1 := by
    intro hrg
    exact (Finset.disjoint_left.mp (hdisj hfmem hgmem hfg) hrf) hrg
  have hre : r ∉ e.1 := by
    intro hre
    exact (Finset.disjoint_left.mp (hdisj hfmem hemem hfe) hrf) hre
  have hra : r ≠ a := by
    intro h
    exact hrg (by rw [hg, h]; simp)
  have hrb : r ≠ b := by
    intro h
    exact hrg (by rw [hg, h]; simp)
  -- the four arc points off the fixed secant are exactly `a`, `b`, `c`, `d`
  have hQcard : (A \ e.1).card = 4 := by
    rw [Finset.card_sdiff_of_subset e.subset, hcard, e.card]
  have hsub : ({a, b, c, d} : Finset P) ⊆ A \ e.1 := by
    intro p hp
    simp only [Finset.mem_insert, Finset.mem_singleton] at hp
    rcases hp with rfl | rfl | rfl | rfl
    · exact ha
    · exact hb
    · exact hc
    · exact hd
  have hcard4 : ({a, b, c, d} : Finset P).card = 4 := by
    rw [Finset.card_insert_of_notMem (by simp [hab, hac, had]),
      Finset.card_insert_of_notMem (by simp [hbc, hbd]),
      Finset.card_insert_of_notMem (by simp [hcd]), Finset.card_singleton]
  have hQ : ({a, b, c, d} : Finset P) = A \ e.1 :=
    Finset.eq_of_subset_of_card_le hsub (by rw [hQcard, hcard4])
  have hrQ : r ∈ A \ e.1 := Finset.mem_sdiff.mpr ⟨hrA, hre⟩
  have hrd : r = d := by
    have := hrQ
    rw [← hQ] at this
    simp only [Finset.mem_insert, Finset.mem_singleton] at this
    rcases this with h | h | h | h
    · exact absurd h hra
    · exact absurd h hrb
    · exact absurd h hrc
    · exact h
  rw [← hrd]
  exact hcolcr

/-- Distinct triple-concurrence points on a common secant join a fixed arc point off that secant
to different arc points: a shared chord would meet the secant twice. -/
theorem not_collinear_common_chord {A : Finset P} (hA : Arc (L := L) A)
    {e : ArcPair A} {x y a b : P}
    (hxe : x ∈ e.line (L := L)) (hye : y ∈ e.line (L := L)) (hxy : x ≠ y)
    (ha : a ∈ A \ e.1) (hab : a ≠ b)
    (hx : RelativeConicArcs.Collinear (L := L) a b x)
    (hy : RelativeConicArcs.Collinear (L := L) a b y) : False := by
  classical
  obtain ⟨l, hal, hbl, hxl⟩ := hx
  obtain ⟨m, ham, hbm, hym⟩ := hy
  have hlm : l = m := line_eq_of_two_points (L := L) hab hal hbl ham hbm
  have hyl : y ∈ l := by rw [hlm]; exact hym
  have hle : l = e.line (L := L) := line_eq_of_two_points (L := L) hxy hxl hyl hxe hye
  have hae : a ∈ e.line (L := L) := by rw [← hle]; exact hal
  have haA : a ∈ A := (Finset.mem_sdiff.mp ha).1
  exact (Finset.mem_sdiff.mp ha).2 (ArcPair.mem_of_mem_arc_of_mem_line (L := L) hA e haA hae)

/-- **Incidence count for triple-concurrence points.**  A six-arc has fifteen secants, each
triple-concurrence point lies on three of them, so a bound of two such points per secant bounds
their total number by ten. -/
theorem card_triplePoints_le_ten_of_secant_bound {A : Finset P} (hA : Arc (L := L) A)
    (hcard : A.card = 6)
    (hsecant : ∀ e : ArcPair A,
      ((triplePoints (L := L) A).filter fun x => x ∈ e.line (L := L)).card ≤ 2) :
    (triplePoints (L := L) A).card ≤ 10 := by
  classical
  set B := triplePoints (L := L) A with hB
  have hswap : (∑ x ∈ B, (pairsThrough (L := L) A x).card) =
      ∑ e : ArcPair A, (B.filter fun x => x ∈ e.line (L := L)).card := by
    simp only [pairsThrough, Finset.card_filter]
    rw [Finset.sum_comm]
  have hleft : (∑ x ∈ B, (pairsThrough (L := L) A x).card) = 3 * B.card := by
    have hterm : ∀ x ∈ B, (pairsThrough (L := L) A x).card = 3 := by
      intro x hx
      rw [← pointIndex_eq_card_pairsThrough (L := L) hA x]
      exact (mem_triplePoints.mp (by rwa [hB] at hx)).2
    rw [Finset.sum_congr rfl hterm, Finset.sum_const, smul_eq_mul, Nat.mul_comm]
  have hpairs : (Finset.univ : Finset (ArcPair A)).card = 15 := by
    rw [Finset.card_univ, card_arcPair A, hcard]
    rfl
  have hright : (∑ e : ArcPair A, (B.filter fun x => x ∈ e.line (L := L)).card) ≤ 30 := by
    calc
      (∑ e : ArcPair A, (B.filter fun x => x ∈ e.line (L := L)).card)
          ≤ ∑ _e : ArcPair A, 2 := Finset.sum_le_sum fun e _ => hsecant e
      _ = 30 := by rw [Finset.sum_const, hpairs]; rfl
  have h3 : 3 * B.card ≤ 30 := by
    rw [← hleft, hswap]
    exact hright
  omega

end Plane

end SixArcConcurrence
end RelativeConicArcs
