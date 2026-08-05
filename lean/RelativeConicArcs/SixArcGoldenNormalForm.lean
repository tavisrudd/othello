import RelativeConicArcs.GoldenHexagonNormalForm
import RelativeConicArcs.SixArcHexagonalOrder
import RelativeConicArcs.SixArcOneFactorization

/-!
# Six-arcs with ten triple-concurrence points are golden hexagons

Let `A` be a six-arc of the projective plane `PG(2,K)` over a field in which two is invertible, and
suppose `A` attains the bound of ten on the number of points off `A` lying on three of its secants.
This file assembles the earlier combinatorial and coordinate results into a normal form for `A`:
there is a projective frame `u₀, u₁, u₂` of `K³` and a scalar `φ` with `φ² = φ + 1` in which the six
points of `A` are

`(1 : 0 : 0)`, `(φ : 1 : 1)`, `(0 : 1 : 0)`, `(1 : φ : 1)`, `(0 : 0 : 1)`, `(1 : 1 : 2 - φ)`.

In particular the ground field contains a root of the golden relation whenever such an arc exists.

The assembly has three parts.  The chord matchings of `A` that are not concurrent are five in
number and pairwise share no chord, so they partition the fifteen chords; this is
`RelativeConicArcs.SixArcOneFactorization`.  Two of those five factors, having no common chord,
close a hexagon on the six points by `RelativeConicArcs.SixArcHexagonalOrder`, which produces a
listing `p₁, …, p₆` in which the two factors are `{p₁p₂, p₃p₄, p₅p₆}` and `{p₂p₃, p₄p₅, p₆p₁}`.
Relabelling that listing by `(p₄ p₅ p₆) ↦ (p₅ p₆ p₄)` carries the four chord matchings consumed by
`RelativeConicArcs.GoldenHexagonNormalForm.golden_normal_form_of_concurrent_matchings` off the
one-factorization: each of the four shares a chord with one of the two chosen factors while
differing from it, hence is not a factor and is therefore concurrent.  The remaining three factors
are never identified.

The non-degeneracy hypotheses of the normal form are discharged from the arc condition alone.  A
triple of distinct points of `A` is non-collinear by definition of an arc, and a triple consisting
of two points of `A` and a concurrence point `x` is non-collinear because `x` lies off `A` on a
chord of the configuration: the line joining `x` to an endpoint of that chord is the chord itself,
and it meets `A` only in the chord's two endpoints.
-/

namespace RelativeConicArcs
namespace SixArcGoldenNormalForm

open Finset Configuration Projectivization
open SixArcChordMatchings SixArcOneFactorization

section ChordCombinatorics

variable {P : Type*} [DecidableEq P]

/-- Two two-element sets with pairwise distinct entries are disjoint. -/
private theorem disjoint_pair {a b c d : P} (hac : a ≠ c) (had : a ≠ d) (hbc : b ≠ c)
    (hbd : b ≠ d) : Disjoint ({a, b} : Finset P) ({c, d} : Finset P) := by
  refine Finset.disjoint_left.mpr ?_
  intro p hp hp'
  simp only [Finset.mem_insert, Finset.mem_singleton] at hp hp'
  rcases hp with rfl | rfl <;> rcases hp' with rfl | rfl
  exacts [hac rfl, had rfl, hbc rfl, hbd rfl]

omit [DecidableEq P] in
/-- A point of one chord's endpoint pair that is missing from another's separates the chords. -/
private theorem ne_of_mem_notMem_val {A : Finset P} {e f : ArcPair A} {p : P}
    (hp : p ∈ e.1) (hp' : p ∉ f.1) : e ≠ f := fun h => hp' (h ▸ hp)

/-- Membership in a three-element set of chords is refuted by three inequalities. -/
private theorem notMem_triple {A : Finset P} {e c₁ c₂ c₃ : ArcPair A}
    (h₁ : e ≠ c₁) (h₂ : e ≠ c₂) (h₃ : e ≠ c₃) :
    e ∉ ({c₁, c₂, c₃} : Finset (ArcPair A)) := by
  simp [h₁, h₂, h₃]

/-- Listing the last three entries of a six-element set in the order `e`, `f`, `d` gives the same
set. -/
private theorem sextuple_cycle_last_three {a b c d e f : P} :
    ({a, b, c, d, e, f} : Finset P) = {a, b, c, e, f, d} := by
  ext p
  simp only [Finset.mem_insert, Finset.mem_singleton]
  tauto

end ChordCombinatorics

section Coordinate

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

noncomputable local instance instFintypePoint : Fintype (ProjectiveBridge.Point K) :=
  Fintype.ofFinite _

noncomputable local instance instDecidableEqPoint : DecidableEq (ProjectiveBridge.Point K) :=
  Classical.decEq _

noncomputable local instance instDecidableCoordinateIncidence
    (p l : ProjectiveBridge.Point K) : Decidable (p ∈ l) :=
  Classical.propDecidable _

/-- A chord matching sharing a chord with a chord matching that is not concurrent, while
containing a chord that the latter does not, is itself concurrent.  Two chord matchings that are
not concurrent share no chord, so the shared chord prevents the first from belonging to the
one-factorization, and every chord matching outside it is concurrent. -/
private theorem exists_concurrentAt_of_shared_chord (h2 : (2 : K) ≠ 0)
    {A : Finset (ProjectiveBridge.Point K)}
    (hA : Arc (L := ProjectiveBridge.Point K) A) (hcard : A.card = 6)
    (hten : (SixArcConcurrence.triplePoints (L := ProjectiveBridge.Point K) A).card = 10)
    {F M : Finset (ArcPair A)}
    (hF : F ∈ nonconcurrentMatchings (L := ProjectiveBridge.Point K) A)
    (hM : IsChordMatching A M) {e f : ArcPair A}
    (heF : e ∈ F) (heM : e ∈ M) (hfM : f ∈ M) (hfF : f ∉ F) :
    ∃ x : ProjectiveBridge.Point K, ConcurrentAt (L := ProjectiveBridge.Point K) A M x := by
  classical
  by_cases hMn : M ∈ nonconcurrentMatchings (L := ProjectiveBridge.Point K) A
  · have hMF : M ≠ F := fun h => hfF (h ▸ hfM)
    exact absurd heF (Finset.disjoint_left.mp
      (disjoint_of_mem_nonconcurrentMatchings h2 hA hcard hten hMn hF hMF) heM)
  · have hMc : M ∈ concurrentMatchings (L := ProjectiveBridge.Point K) A := by
      rw [nonconcurrentMatchings, Finset.mem_sdiff, not_and, not_not] at hMn
      exact hMn (mem_matchings.mpr hM)
    exact (mem_concurrentMatchings.mp hMc).2

omit [Fintype K] in
/-- The two endpoints of a chord of a concurrent chord matching are collinear with the
concurrence point. -/
private theorem projectiveCollinear_of_chord {A : Finset (ProjectiveBridge.Point K)}
    {M : Finset (ArcPair A)} {x : ProjectiveBridge.Point K}
    (hx : ConcurrentAt (L := ProjectiveBridge.Point K) A M x)
    {e : ArcPair A} (heM : e ∈ M) {a b : ProjectiveBridge.Point K} (hval : e.1 = {a, b}) :
    ProjectiveCap.Projective.Collinear K (Fin 3 → K) a b x :=
  ProjectiveBridge.collinear_iff_projective_collinear.mp
    ⟨e.line (L := ProjectiveBridge.Point K),
      e.mem_line (by rw [hval]; exact Finset.mem_insert_self a {b}),
      e.mem_line (by rw [hval]; exact Finset.mem_insert_of_mem (Finset.mem_singleton_self b)),
      hx e heM⟩

omit [Fintype K] in
/-- Three distinct points of an arc are not collinear, in the coordinate sense. -/
private theorem not_projectiveCollinear_of_arc {A : Finset (ProjectiveBridge.Point K)}
    (hA : Arc (L := ProjectiveBridge.Point K) A) {a b c : ProjectiveBridge.Point K}
    (ha : a ∈ A) (hb : b ∈ A) (hc : c ∈ A) (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    ¬ ProjectiveCap.Projective.Collinear K (Fin 3 → K) a b c := fun h =>
  hA ha hb hc hab hac hbc (ProjectiveBridge.collinear_iff_projective_collinear.mpr h)

omit [Fintype K] in
/-- An endpoint of a chord through a point `x` off the arc, a point of the arc outside that chord,
and `x` are not collinear: the line joining the endpoint to `x` is the chord, which meets the arc
only in its two endpoints. -/
private theorem not_projectiveCollinear_of_concurrence {A : Finset (ProjectiveBridge.Point K)}
    (hA : Arc (L := ProjectiveBridge.Point K) A) {x : ProjectiveBridge.Point K} (hxA : x ∉ A)
    {e : ArcPair A} (hxe : x ∈ e.line (L := ProjectiveBridge.Point K))
    {a c : ProjectiveBridge.Point K} (hae : a ∈ e.1) (hcA : c ∈ A) (hce : c ∉ e.1) :
    ¬ ProjectiveCap.Projective.Collinear K (Fin 3 → K) a c x := by
  intro hcol
  obtain ⟨l, hal, hcl, hxl⟩ := ProjectiveBridge.collinear_iff_projective_collinear.mpr hcol
  have hax : a ≠ x := fun h => hxA (h ▸ e.subset hae)
  obtain ⟨m, _hm, huniq⟩ := Configuration.HasLines.existsUnique_line
    (P := ProjectiveBridge.Point K) (L := ProjectiveBridge.Point K) a x hax
  have hle : l = e.line (L := ProjectiveBridge.Point K) := by
    rw [huniq l ⟨hal, hxl⟩, huniq (e.line (L := ProjectiveBridge.Point K))
      ⟨e.mem_line hae, hxe⟩]
  exact hce (ArcPair.mem_of_mem_arc_of_mem_line hA e hcA (hle ▸ hcl))

/-- **A six-arc attaining the ten-point concurrence bound is a golden hexagon.**  In the projective
plane over a field in which two is invertible, a six-arc with exactly ten triple-concurrence points
carries a projective frame `u` and a scalar `φ` with `φ * φ = φ + 1` in which its six points are

`(1 : 0 : 0)`, `(φ : 1 : 1)`, `(0 : 1 : 0)`, `(1 : φ : 1)`, `(0 : 0 : 1)`, `(1 : 1 : 2 - φ)`.

No hypothesis on the field beyond the invertibility of two is used, and no finiteness beyond that
already carried by the ambient coordinate plane. -/
theorem exists_golden_frame (h2 : (2 : K) ≠ 0)
    {A : Finset (ProjectiveBridge.Point K)}
    (hA : Arc (L := ProjectiveBridge.Point K) A) (hcard : A.card = 6)
    (hten : (SixArcConcurrence.triplePoints (L := ProjectiveBridge.Point K) A).card = 10) :
    ∃ (u : Fin 3 → (Fin 3 → K)) (_ : LinearIndependent K u) (φ : K), φ * φ = φ + 1 ∧
      ∃ (h₀ : u 0 ≠ 0) (h₁ : u 1 ≠ 0) (h₂ : u 2 ≠ 0)
        (h₃ : φ • u 0 + u 1 + u 2 ≠ 0) (h₄ : u 0 + φ • u 1 + u 2 ≠ 0)
        (h₅ : u 0 + u 1 + (2 - φ) • u 2 ≠ 0),
        A = {Projectivization.mk K (u 0) h₀,
             Projectivization.mk K (φ • u 0 + u 1 + u 2) h₃,
             Projectivization.mk K (u 1) h₁,
             Projectivization.mk K (u 0 + φ • u 1 + u 2) h₄,
             Projectivization.mk K (u 2) h₂,
             Projectivization.mk K (u 0 + u 1 + (2 - φ) • u 2) h₅} := by
  classical
  -- Two distinct factors of the one-factorization produced by the equality case.
  have hfive := card_nonconcurrentMatchings h2 hA hcard hten
  obtain ⟨F, hF, G, hG, hFG⟩ :=
    Finset.one_lt_card.mp (by rw [hfive]; norm_num :
      1 < (nonconcurrentMatchings (L := ProjectiveBridge.Point K) A).card)
  have hFmatch : IsChordMatching A F :=
    mem_matchings.mp (Finset.mem_sdiff.mp hF).1
  have hGmatch : IsChordMatching A G :=
    mem_matchings.mp (Finset.mem_sdiff.mp hG).1
  have hFGdisj : Disjoint F G :=
    disjoint_of_mem_nonconcurrentMatchings h2 hA hcard hten hF hG hFG
  -- The hexagonal listing of the arc along the union of the two factors.
  obtain ⟨p1, p2, p3, p4, p5, p6, c₁, c₂, c₃, d₁, d₂, d₃, hnodup, hAval,
    hc₁, hc₂, hc₃, hd₁, hd₂, hd₃, hFval, hGval⟩ :=
    SixArcHexagonalOrder.exists_hexagonal_order hcard hFmatch hGmatch hFGdisj
  simp only [List.nodup_cons, List.mem_cons, List.not_mem_nil, not_or, List.nodup_nil,
    not_false_eq_true, and_true] at hnodup
  obtain ⟨⟨h12, h13, h14, h15, h16⟩, ⟨h23, h24, h25, h26⟩, ⟨h34, h35, h36⟩,
    ⟨h45, h46⟩, h56⟩ := hnodup
  have hp1A : p1 ∈ A := by rw [hAval]; simp
  have hp2A : p2 ∈ A := by rw [hAval]; simp
  have hp3A : p3 ∈ A := by rw [hAval]; simp
  have hp4A : p4 ∈ A := by rw [hAval]; simp
  have hp5A : p5 ∈ A := by rw [hAval]; simp
  have hp6A : p6 ∈ A := by rw [hAval]; simp
  -- The five further chords used by the four matchings of the normal form.
  obtain ⟨e13, he13⟩ := exists_arcPair_val hp1A hp3A h13
  obtain ⟨e15, he15⟩ := exists_arcPair_val hp1A hp5A h15
  obtain ⟨e26, he26⟩ := exists_arcPair_val hp2A hp6A h26
  obtain ⟨e35, he35⟩ := exists_arcPair_val hp3A hp5A h35
  obtain ⟨e46, he46⟩ := exists_arcPair_val hp4A hp6A h46
  -- The four matchings, in the relabelled hexagon `p1 p2 p3 p5 p6 p4`.
  have hXmatch : IsChordMatching A ({c₁, e35, e46} : Finset (ArcPair A)) :=
    isChordMatching_triple
      (by rw [hc₁, he35]; exact disjoint_pair h13 h15 h23 h25)
      (by rw [hc₁, he46]; exact disjoint_pair h14 h16 h24 h26)
      (by rw [he35, he46]; exact disjoint_pair h34 h36 (Ne.symm h45) h56)
  have hQ1match : IsChordMatching A ({e15, d₁, e46} : Finset (ArcPair A)) :=
    isChordMatching_triple
      (by rw [he15, hd₁]; exact disjoint_pair h12 h13 (Ne.symm h25) (Ne.symm h35))
      (by rw [he15, he46]; exact disjoint_pair h14 h16 (Ne.symm h45) h56)
      (by rw [hd₁, he46]; exact disjoint_pair h24 h26 h34 h36)
  have hQ2match : IsChordMatching A ({e13, e26, d₂} : Finset (ArcPair A)) :=
    isChordMatching_triple
      (by rw [he13, he26]; exact disjoint_pair h12 h16 (Ne.symm h23) h36)
      (by rw [he13, hd₂]; exact disjoint_pair h14 h15 h34 h35)
      (by rw [he26, hd₂]; exact disjoint_pair h24 h25 (Ne.symm h46) (Ne.symm h56))
  have hQ3match : IsChordMatching A ({e15, e26, c₂} : Finset (ArcPair A)) :=
    isChordMatching_triple
      (by rw [he15, he26]; exact disjoint_pair h12 h16 (Ne.symm h25) h56)
      (by rw [he15, hc₂]; exact disjoint_pair h13 h14 (Ne.symm h35) (Ne.symm h45))
      (by rw [he26, hc₂]; exact disjoint_pair h23 h24 (Ne.symm h36) (Ne.symm h46))
  -- Each of the four shares a chord with a factor while differing from it, hence is concurrent.
  have he35F : e35 ∉ F := by
    rw [hFval]
    exact notMem_triple
      (ne_of_mem_notMem_val (p := p3) (by rw [he35]; simp) (by rw [hc₁]; simp [(Ne.symm h13), (Ne.symm h23)]))
      (ne_of_mem_notMem_val (p := p5) (by rw [he35]; simp) (by rw [hc₂]; simp [(Ne.symm h35), (Ne.symm h45)]))
      (ne_of_mem_notMem_val (p := p3) (by rw [he35]; simp) (by rw [hc₃]; simp [h35, h36]))
  have he15F : e15 ∉ F := by
    rw [hFval]
    exact notMem_triple
      (ne_of_mem_notMem_val (p := p5) (by rw [he15]; simp) (by rw [hc₁]; simp [(Ne.symm h15), (Ne.symm h25)]))
      (ne_of_mem_notMem_val (p := p1) (by rw [he15]; simp) (by rw [hc₂]; simp [h13, h14]))
      (ne_of_mem_notMem_val (p := p1) (by rw [he15]; simp) (by rw [hc₃]; simp [h15, h16]))
  have he15G : e15 ∉ G := by
    rw [hGval]
    exact notMem_triple
      (ne_of_mem_notMem_val (p := p1) (by rw [he15]; simp) (by rw [hd₁]; simp [h12, h13]))
      (ne_of_mem_notMem_val (p := p1) (by rw [he15]; simp) (by rw [hd₂]; simp [h14, h15]))
      (ne_of_mem_notMem_val (p := p5) (by rw [he15]; simp) (by rw [hd₃]; simp [h56, Ne.symm h15]))
  have he13G : e13 ∉ G := by
    rw [hGval]
    exact notMem_triple
      (ne_of_mem_notMem_val (p := p1) (by rw [he13]; simp) (by rw [hd₁]; simp [h12, h13]))
      (ne_of_mem_notMem_val (p := p1) (by rw [he13]; simp) (by rw [hd₂]; simp [h14, h15]))
      (ne_of_mem_notMem_val (p := p3) (by rw [he13]; simp) (by rw [hd₃]; simp [h36, Ne.symm h13]))
  obtain ⟨x, hx⟩ := exists_concurrentAt_of_shared_chord h2 hA hcard hten hF hXmatch
    (e := c₁) (f := e35) (by rw [hFval]; simp) (by simp) (by simp) he35F
  obtain ⟨q1, hq1⟩ := exists_concurrentAt_of_shared_chord h2 hA hcard hten hG hQ1match
    (e := d₁) (f := e15) (by rw [hGval]; simp) (by simp) (by simp) he15G
  obtain ⟨q2, hq2⟩ := exists_concurrentAt_of_shared_chord h2 hA hcard hten hG hQ2match
    (e := d₂) (f := e13) (by rw [hGval]; simp) (by simp) (by simp) he13G
  obtain ⟨q3, hq3⟩ := exists_concurrentAt_of_shared_chord h2 hA hcard hten hF hQ3match
    (e := c₂) (f := e15) (by rw [hFval]; simp) (by simp) (by simp) he15F
  have hxA : x ∉ A := notMem_of_concurrentAt hA hcard hXmatch hx
  -- The frame-defining concurrence lies on the chords `p1p2` and `p3p5`.
  have hxc₁ : x ∈ c₁.line (L := ProjectiveBridge.Point K) := hx c₁ (by simp)
  have hxe35 : x ∈ e35.line (L := ProjectiveBridge.Point K) := hx e35 (by simp)
  have hgold := GoldenHexagonNormalForm.golden_normal_form_of_concurrent_matchings
    (K := K) (V := Fin 3 → K) (Module.finrank_fin_fun K)
    (p1 := p1) (p2 := p2) (p3 := p3) (p4 := p5) (p5 := p6) (p6 := p4)
    (x := x) (q1 := q1) (q2 := q2) (q3 := q3)
    (not_projectiveCollinear_of_arc hA hp1A hp3A hp6A h13 h16 h36)
    (not_projectiveCollinear_of_concurrence hA hxA hxc₁
      (by rw [hc₁]; simp) hp3A (by rw [hc₁]; simp [(Ne.symm h13), (Ne.symm h23)]))
    (not_projectiveCollinear_of_concurrence hA hxA hxc₁
      (by rw [hc₁]; simp) hp6A (by rw [hc₁]; simp [(Ne.symm h16), (Ne.symm h26)]))
    (not_projectiveCollinear_of_concurrence hA hxA hxe35
      (by rw [he35]; simp) hp6A (by rw [he35]; simp [(Ne.symm h36), (Ne.symm h56)]))
    (not_projectiveCollinear_of_arc hA hp1A hp3A hp2A h13 h12 (Ne.symm h23))
    (not_projectiveCollinear_of_arc hA hp1A hp3A hp5A h13 h15 h35)
    (not_projectiveCollinear_of_arc hA hp1A hp3A hp4A h13 h14 h34)
    (not_projectiveCollinear_of_arc hA hp1A hp6A hp4A h16 h14 (Ne.symm h46))
    (not_projectiveCollinear_of_arc hA hp1A hp6A hp5A h16 h15 (Ne.symm h56))
    (not_projectiveCollinear_of_arc hA hp3A hp6A hp2A h36 (Ne.symm h23) (Ne.symm h26))
    (fun h => hxA (h ▸ hp2A))
    (projectiveCollinear_of_chord hx (by simp) hc₁)
    (projectiveCollinear_of_chord hx (by simp) he35)
    (projectiveCollinear_of_chord hx (by simp)
      (show e46.1 = {p6, p4} by rw [he46]; exact Finset.pair_comm p4 p6))
    (projectiveCollinear_of_chord hq1 (by simp) he15)
    (projectiveCollinear_of_chord hq1 (by simp) hd₁)
    (projectiveCollinear_of_chord hq1 (by simp)
      (show e46.1 = {p6, p4} by rw [he46]; exact Finset.pair_comm p4 p6))
    (projectiveCollinear_of_chord hq2 (by simp) he13)
    (projectiveCollinear_of_chord hq2 (by simp) he26)
    (projectiveCollinear_of_chord hq2 (by simp)
      (show d₂.1 = {p5, p4} by rw [hd₂]; exact Finset.pair_comm p4 p5))
    (projectiveCollinear_of_chord hq3 (by simp) he15)
    (projectiveCollinear_of_chord hq3 (by simp) he26)
    (projectiveCollinear_of_chord hq3 (by simp) hc₂)
  obtain ⟨u, hu, φ, hφ, ⟨hu0, hu0'⟩, ⟨hu1, hu1'⟩, ⟨hu2, hu2'⟩, ⟨hv2, hv2'⟩, ⟨hv4, hv4'⟩,
    ⟨hv6, hv6'⟩⟩ := hgold
  refine ⟨u, hu, φ, hφ, hu0, hu1, hu2, hv2, hv4, hv6, ?_⟩
  rw [hu0', hu1', hu2', hv2', hv4', hv6', hAval]
  exact sextuple_cycle_last_three

/-- **A six-arc attaining the ten-point concurrence bound forces a golden root in the ground
field.**  If the projective plane over a field in which two is invertible carries a six-arc with
exactly ten triple-concurrence points, then `x² = x + 1` is solvable in that field.  Contrapositively
the bound of ten is not attained over a field in which five is a nonsquare and the characteristic is
not five. -/
theorem exists_golden_root (h2 : (2 : K) ≠ 0)
    {A : Finset (ProjectiveBridge.Point K)}
    (hA : Arc (L := ProjectiveBridge.Point K) A) (hcard : A.card = 6)
    (hten : (SixArcConcurrence.triplePoints (L := ProjectiveBridge.Point K) A).card = 10) :
    ∃ φ : K, φ * φ = φ + 1 := by
  obtain ⟨_u, _hu, φ, hφ, _⟩ := exists_golden_frame h2 hA hcard hten
  exact ⟨φ, hφ⟩

end Coordinate
end SixArcGoldenNormalForm
end RelativeConicArcs
