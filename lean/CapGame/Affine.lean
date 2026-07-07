import CapGame.BuildGame
import Mathlib.Data.Fintype.Pi
import Mathlib.LinearAlgebra.AffineSpace.FiniteDimensional
import Mathlib.LinearAlgebra.AffineSpace.Midpoint

/-!
# Affine cap achievement game

This file formalizes the affine cap-set game from the notes.  A position is a
finite affine cap in a vector space over a field; a move adds one point while
preserving the cap condition; normal play is supplied by `FiniteBuildGame.Win`.
-/

namespace CapGame
namespace Affine

variable (K V : Type*) [Field K] [AddCommGroup V] [Module K V]

/-- `a`, `b`, `c` are affine-collinear.  This wraps mathlib's symmetric set predicate. -/
def Collinear (a b c : V) : Prop :=
  _root_.Collinear K ({a, b, c} : Set V)

/-- A finite affine cap: no three distinct selected points are collinear. -/
def Cap (S : Finset V) : Prop :=
  ∀ ⦃a b c : V⦄,
    a ∈ S -> b ∈ S -> c ∈ S ->
      a ≠ b -> a ≠ c -> b ≠ c -> ¬ Collinear K V a b c

variable {K V}

theorem cap_mono {S T : Finset V} (hST : S ⊆ T) (hT : Cap K V T) :
    Cap K V S := by
  intro a b c ha hb hc hab hac hbc
  exact hT (hST ha) (hST hb) (hST hc) hab hac hbc

theorem cap_of_card_le_two {S : Finset V} [DecidableEq V] (hcard : S.card ≤ 2) :
    Cap K V S := by
  intro a b c ha hb hc hab hac hbc hcol
  have hsub : ({a, b, c} : Finset V) ⊆ S := by
    intro x hx
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl | rfl
    · exact ha
    · exact hb
    · exact hc
  have hthree : ({a, b, c} : Finset V).card = 3 := by
    simp [hab, hac, hbc]
  have hle := Finset.card_le_card hsub
  omega

@[simp] theorem cap_empty [DecidableEq V] : Cap K V (∅ : Finset V) :=
  cap_of_card_le_two (K := K) (V := V) (by simp)

@[simp] theorem cap_singleton [DecidableEq V] (a : V) : Cap K V ({a} : Finset V) :=
  cap_of_card_le_two (K := K) (V := V) (by simp)

theorem cap_pair [DecidableEq V] (a b : V) : Cap K V ({a, b} : Finset V) :=
  cap_of_card_le_two (K := K) (V := V) (by
    by_cases h : a = b <;> simp [h])

theorem collinear_swap_left {a b c : V} :
    Collinear K V a b c ↔ Collinear K V b a c := by
  rw [Collinear, Collinear, Set.insert_comm a b {c}]

theorem collinear_rotate_right {a b c : V} :
    Collinear K V a b c ↔ Collinear K V c a b := by
  rw [Collinear, Collinear]
  have h : ({a, b, c} : Set V) = ({c, a, b} : Set V) := by
    ext z
    simp [or_comm, or_left_comm]
  rw [h]

theorem cap_insert_of_cap [DecidableEq V] {S : Finset V} {y : V}
    (hS : Cap K V S) (hnew : y ∉ S)
    (hline : ∀ ⦃p q : V⦄, p ∈ S -> q ∈ S ->
      y ≠ p -> y ≠ q -> p ≠ q -> ¬ Collinear K V y p q) :
    Cap K V (insert y S) := by
  intro a b c ha hb hc hab hac hbc hcol
  by_cases hay : a = y
  · subst hay
    have hbS : b ∈ S := by
      rcases Finset.mem_insert.mp hb with rfl | hbS
      · exact (hab rfl).elim
      · exact hbS
    have hcS : c ∈ S := by
      rcases Finset.mem_insert.mp hc with rfl | hcS
      · exact (hac rfl).elim
      · exact hcS
    exact hline hbS hcS hab hac hbc hcol
  by_cases hby : b = y
  · subst hby
    have haS : a ∈ S := by
      rcases Finset.mem_insert.mp ha with rfl | haS
      · exact (hay rfl).elim
      · exact haS
    have hcS : c ∈ S := by
      rcases Finset.mem_insert.mp hc with rfl | hcS
      · exact (hbc rfl).elim
      · exact hcS
    exact hline haS hcS hab.symm hbc hac
      ((collinear_swap_left (K := K) (V := V)).1 hcol)
  by_cases hcy : c = y
  · subst hcy
    have haS : a ∈ S := by
      rcases Finset.mem_insert.mp ha with rfl | haS
      · exact (hay rfl).elim
      · exact haS
    have hbS : b ∈ S := by
      rcases Finset.mem_insert.mp hb with rfl | hbS
      · exact (hby rfl).elim
      · exact hbS
    exact hline haS hbS hac.symm hbc.symm hab
      ((collinear_rotate_right (K := K) (V := V)).1 hcol)
  exact hS
    (by simpa [hay] using ha)
    (by simpa [hby] using hb)
    (by simpa [hcy] using hc)
    hab hac hbc hcol

theorem collinear_affineEquiv (e : V ≃ᵃ[K] V) {a b c : V} :
    Collinear K V (e a) (e b) (e c) ↔ Collinear K V a b c := by
  rw [Collinear, Collinear, _root_.collinear_iff_not_affineIndependent_set,
    _root_.collinear_iff_not_affineIndependent_set]
  exact not_congr (by
    convert (e.affineIndependent_iff (p := ![a, b, c])) using 2
    ext i
    fin_cases i <;> rfl)

theorem cap_image_affineEquiv [DecidableEq V] (e : V ≃ᵃ[K] V) {S : Finset V}
    (hS : Cap K V S) : Cap K V (S.map e.toEquiv.toEmbedding) := by
  intro a b c ha hb hc hab hac hbc hcol
  rcases Finset.mem_map.mp ha with ⟨a₀, ha₀, rfl⟩
  rcases Finset.mem_map.mp hb with ⟨b₀, hb₀, rfl⟩
  rcases Finset.mem_map.mp hc with ⟨c₀, hc₀, rfl⟩
  have hab₀ : a₀ ≠ b₀ := fun h => hab (by simp [h])
  have hac₀ : a₀ ≠ c₀ := fun h => hac (by simp [h])
  have hbc₀ : b₀ ≠ c₀ := fun h => hbc (by simp [h])
  exact hS ha₀ hb₀ hc₀ hab₀ hac₀ hbc₀
    ((collinear_affineEquiv (K := K) (V := V) e).1 hcol)

theorem mem_of_image_eq_self [DecidableEq V] (e : V ≃ᵃ[K] V) {S : Finset V}
    (hinv : S.map e.toEquiv.toEmbedding = S) {x : V} (hx : x ∈ S) :
    e x ∈ S := by
  rw [← hinv]
  exact Finset.mem_map_of_mem _ hx

theorem mem_iff_of_image_eq_self [DecidableEq V] (e : V ≃ᵃ[K] V) {S : Finset V}
    (hinvol : ∀ z : V, e (e z) = z) (hinv : S.map e.toEquiv.toEmbedding = S) {x : V} :
    e x ∈ S ↔ x ∈ S := by
  constructor
  · intro hx
    have hpre := mem_of_image_eq_self (K := K) (V := V) e hinv hx
    simpa [hinvol x] using hpre
  · exact mem_of_image_eq_self (K := K) (V := V) e hinv

theorem no_old_point_on_mirror_line [DecidableEq V] (e : V ≃ᵃ[K] V)
    (hinvol : ∀ z : V, e (e z) = z) {S : Finset V} {x z : V}
    (hcapx : Cap K V (insert x S)) (hinv : S.map e.toEquiv.toEmbedding = S)
    (hnofixS : ∀ ⦃z : V⦄, z ∈ S -> e z ≠ z)
    (hxmove : FiniteBuildGame.Move (Cap K V) S x) (hxfix : e x ≠ x)
    (hz : z ∈ S) :
    ¬ Collinear K V x (e x) z := by
  intro hline
  have hezS : e z ∈ S := mem_of_image_eq_self (K := K) (V := V) e hinv hz
  have hzez : z ≠ e z := by
    exact (hnofixS hz).symm
  have hxz : x ≠ z := fun h => hxmove.1 (h ▸ hz)
  have hxez : x ≠ e z := fun h => hxmove.1 (h ▸ hezS)
  have hz_line : z ∈ line[K, x, e x] := by
    exact (_root_.Collinear.mem_affineSpan_of_mem_of_ne
      (k := K) (s := ({x, e x, z} : Set V)) hline
      (by simp) (by simp) (by simp) hxfix.symm)
  have hline_img : Collinear K V (e x) (e (e x)) (e z) :=
    (collinear_affineEquiv (K := K) (V := V) e).2 hline
  have hez_line : e z ∈ line[K, x, e x] := by
    have hline_img' : _root_.Collinear K ({e x, x, e z} : Set V) := by
      simpa [Collinear, hinvol x] using hline_img
    exact (_root_.Collinear.mem_affineSpan_of_mem_of_ne
      (k := K) (s := ({e x, x, e z} : Set V)) hline_img'
      (p₁ := x) (p₂ := e x) (p₃ := e z)
      (by simp) (by simp) (by simp) hxfix.symm)
  have hx_line : x ∈ line[K, x, e x] := by
    exact left_mem_affineSpan_pair K x (e x)
  have hzez_col : Collinear K V x z (e z) := by
    exact _root_.collinear_triple_of_mem_affineSpan_pair
      (k := K) (p₄ := x) (p₅ := e x) hx_line hz_line hez_line
  exact hcapx (by simp) (by simp [hz]) (by simp [hezS]) hxz hxez hzez hzez_col

theorem collinear_midpoint_left [Invertible (2 : K)] (x y : V) :
    Collinear K V (midpoint K x y) x y := by
  rw [Collinear]
  exact _root_.collinear_insert_of_mem_affineSpan_pair (k := K)
    (by
      rw [midpoint]
      exact AffineMap.lineMap_mem_affineSpan_pair (k := K) (⅟2 : K) x y)

theorem mirror_move_legal [Fintype V] [DecidableEq V] (e : V ≃ᵃ[K] V)
    (hinvol : ∀ z : V, e (e z) = z) {S : Finset V} {x : V}
    (hinv : S.map e.toEquiv.toEmbedding = S)
    (hnofixS : ∀ ⦃z : V⦄, z ∈ S -> e z ≠ z)
    (hxmove : FiniteBuildGame.Move (Cap K V) S x) (hxfix : e x ≠ x) :
    FiniteBuildGame.Move (Cap K V) (insert x S) (e x) := by
  have hcapx : Cap K V (insert x S) := hxmove.2
  have hnew : e x ∉ insert x S := by
    intro hxold
    rcases Finset.mem_insert.mp hxold with hex | hexS
    · exact hxfix hex
    · have hxS : x ∈ S :=
        (mem_iff_of_image_eq_self (K := K) (V := V) e hinvol hinv).1 hexS
      exact hxmove.1 hxS
  refine ⟨hnew, ?_⟩
  apply cap_insert_of_cap (K := K) (V := V) hcapx hnew
  intro p q hp hq hyp hyq hpq hcol
  rcases Finset.mem_insert.mp hp with hpx | hpS
  · have hqS : q ∈ S := by
      rcases Finset.mem_insert.mp hq with hqx | hqS
      · exact (hpq (hpx.trans hqx.symm)).elim
      · exact hqS
    have hcol₀ : Collinear K V (e x) x q := by
      simpa [hpx] using hcol
    have hcol' : Collinear K V x (e x) q :=
      (collinear_swap_left (K := K) (V := V)).1 hcol₀
    exact (no_old_point_on_mirror_line (K := K) (V := V) e hinvol hcapx hinv
      hnofixS hxmove hxfix hqS) hcol'
  · rcases Finset.mem_insert.mp hq with hqx | hqS
    · have hcol₀ : Collinear K V (e x) p x := by
        simpa [hqx] using hcol
      have hcol' : Collinear K V x (e x) p :=
        (collinear_rotate_right (K := K) (V := V)).1 hcol₀
      exact (no_old_point_on_mirror_line (K := K) (V := V) e hinvol hcapx hinv
        hnofixS hxmove hxfix hpS) hcol'
    · have hepS : e p ∈ S := mem_of_image_eq_self (K := K) (V := V) e hinv hpS
      have heqS : e q ∈ S := mem_of_image_eq_self (K := K) (V := V) e hinv hqS
      have hxep : x ≠ e p := fun h => hxmove.1 (h ▸ hepS)
      have hxeq : x ≠ e q := fun h => hxmove.1 (h ▸ heqS)
      have hepq : e p ≠ e q := fun h => hpq (e.injective h)
      have hcol_img : Collinear K V x (e p) (e q) := by
        have hraw : Collinear K V (e (e x)) (e p) (e q) :=
          (collinear_affineEquiv (K := K) (V := V) e).2 hcol
        simpa [hinvol x] using hraw
      exact hcapx (by simp) (by simp [hepS]) (by simp [heqS])
        hxep hxeq hepq hcol_img

section Game

variable [Fintype V] [DecidableEq V]

/-- Legal affine cap-game extensions. -/
noncomputable def LegalExtensions (S : Finset V) : Finset V :=
  FiniteBuildGame.LegalExtensions (Cap K V) S

theorem mem_legalExtensions {S : Finset V} {x : V} :
    x ∈ LegalExtensions (K := K) (V := V) S ↔
      x ∉ S ∧ Cap K V (insert x S) :=
  FiniteBuildGame.mem_legalExtensions

/-- Normal-play affine cap-game win predicate. -/
abbrev Win (S : Finset V) : Prop :=
  FiniteBuildGame.Win (Cap K V) S

/-- Target statement for the affine theorem proved in prose: the empty affine game is P. -/
def InitialPStatement : Prop :=
  FiniteBuildGame.IsP (Cap K V) (∅ : Finset V)

/--
A mirror-ready affine cap position.

The final field is deliberately explicit: fixed points of the involution must already be illegal
as moves, not merely absent from the current position.
-/
def MirrorGood (e : V ≃ᵃ[K] V) (S : Finset V) : Prop :=
  Cap K V S ∧
    S.map e.toEquiv.toEmbedding = S ∧
    (∀ ⦃z : V⦄, z ∈ S -> e z ≠ z) ∧
    (∀ z : V, FiniteBuildGame.Move (Cap K V) S z -> e z ≠ z)

theorem mirrorGood_step (e : V ≃ᵃ[K] V) (hinvol : ∀ z : V, e (e z) = z) :
    ∀ {S : Finset V}, MirrorGood (K := K) (V := V) e S ->
      ∀ x : V, FiniteBuildGame.Move (Cap K V) S x ->
        ∃ y : V,
          FiniteBuildGame.Move (Cap K V) (insert x S) y ∧
            MirrorGood (K := K) (V := V) e (insert y (insert x S)) := by
  intro S hgood x hxmove
  rcases hgood with ⟨hcapS, hinv, hnofixS, hnofixLegal⟩
  let y := e x
  have hxfix : e x ≠ x := hnofixLegal x hxmove
  have hymove : FiniteBuildGame.Move (Cap K V) (insert x S) y := by
    simpa [y] using mirror_move_legal (K := K) (V := V) e hinvol hinv
      hnofixS hxmove hxfix
  refine ⟨y, hymove, ?_⟩
  have hsubS : S ⊆ insert y (insert x S) := by
    intro z hz
    simp [hz]
  refine ⟨hymove.2, ?_, ?_, ?_⟩
  · subst y
    simp [Finset.map_insert, hinv, hinvol x, Finset.insert_comm]
  · intro z hz
    subst y
    rcases Finset.mem_insert.mp hz with hz | hz
    · subst hz
      simpa [hinvol x] using hxfix.symm
    · rcases Finset.mem_insert.mp hz with hz | hzS
      · subst hz
        exact hxfix
      · exact hnofixS hzS
  · intro z hzmove
    have hznotS : z ∉ S := fun hzS => hzmove.1 (hsubS hzS)
    have hcapzS : Cap K V (insert z S) :=
      cap_mono (K := K) (V := V) (Finset.insert_subset_insert z hsubS) hzmove.2
    exact hnofixLegal z ⟨hznotS, hcapzS⟩

theorem isP_of_mirrorGood (e : V ≃ᵃ[K] V) (hinvol : ∀ z : V, e (e z) = z)
    {S : Finset V} (hgood : MirrorGood (K := K) (V := V) e S) :
    FiniteBuildGame.IsP (Cap K V) S :=
  FiniteBuildGame.isP_of_replyStrategy
    (Valid := Cap K V) (Good := MirrorGood (K := K) (V := V) e)
    (mirrorGood_step (K := K) (V := V) e hinvol) S hgood

/--
Whole-board mirror theorem for an affine fixed-point-free involution.

This is the formal strategy criterion used by the even-characteristic affine proof after choosing
a nonzero order-two translation.
-/
theorem initialP_of_fixedPointFreeInvolution (e : V ≃ᵃ[K] V)
    (hinvol : ∀ z : V, e (e z) = z) (hfpf : ∀ z : V, e z ≠ z) :
    InitialPStatement (K := K) (V := V) := by
  have hgood : MirrorGood (K := K) (V := V) e (∅ : Finset V) := by
    refine ⟨cap_empty (K := K) (V := V), ?_, ?_, ?_⟩
    · simp
    · intro z hz
      simp at hz
    · intro z hzmove
      exact hfpf z
  exact isP_of_mirrorGood (K := K) (V := V) e hinvol hgood

/--
Whole-board translation mirror for a nonzero order-two vector.

Over characteristic two this is the standard affine mirror: choose `v ≠ 0`, translate every move by
`v`, and use `v + v = 0` to make the translation an involution.
-/
theorem initialP_of_orderTwoTranslation (v : V) (hv0 : v ≠ 0) (hvv : v + v = 0) :
    InitialPStatement (K := K) (V := V) := by
  let e : V ≃ᵃ[K] V := AffineEquiv.constVAdd K V v
  have hinvol : ∀ z : V, e (e z) = z := by
    intro z
    change v + (v + z) = z
    rw [← add_assoc, hvv, zero_add]
  have hfpf : ∀ z : V, e z ≠ z := by
    intro z hz
    apply hv0
    have h := congrArg (fun p : V => p -ᵥ z) hz
    simpa [e, AffineEquiv.constVAdd] using h
  exact initialP_of_fixedPointFreeInvolution (K := K) (V := V) e hinvol hfpf

/--
Move-then-mirror criterion.

To prove the empty affine game is P, it is enough to show that every legal first move can be
answered by a move that lands in some certified `MirrorGood` position.  Subsequent play is handled
by `mirrorGood_step`.
-/
theorem initialP_of_opening_mirrorGood
    (hopen : ∀ x : V, FiniteBuildGame.Move (Cap K V) (∅ : Finset V) x ->
      ∃ (e : V ≃ᵃ[K] V) (y : V),
        (∀ z : V, e (e z) = z) ∧
          FiniteBuildGame.Move (Cap K V) (insert x (∅ : Finset V)) y ∧
            MirrorGood (K := K) (V := V) e (insert y (insert x (∅ : Finset V)))) :
    InitialPStatement (K := K) (V := V) := by
  let Good : Finset V -> Prop := fun S =>
    S = ∅ ∨ ∃ e : V ≃ᵃ[K] V, (∀ z : V, e (e z) = z) ∧
      MirrorGood (K := K) (V := V) e S
  have hstep :
      ∀ {S : Finset V}, Good S -> ∀ x : V,
        FiniteBuildGame.Move (Cap K V) S x ->
          ∃ y : V,
            FiniteBuildGame.Move (Cap K V) (insert x S) y ∧ Good (insert y (insert x S)) := by
    intro S hgood x hxmove
    rcases hgood with hSempty | ⟨e, hinvol, hmg⟩
    · subst S
      rcases hopen x hxmove with ⟨e, y, hinvol, hymove, hchild⟩
      exact ⟨y, hymove, Or.inr ⟨e, hinvol, hchild⟩⟩
    · rcases mirrorGood_step (K := K) (V := V) e hinvol hmg x hxmove with
        ⟨y, hymove, hchild⟩
      exact ⟨y, hymove, Or.inr ⟨e, hinvol, hchild⟩⟩
  exact FiniteBuildGame.isP_of_replyStrategy
    (Valid := Cap K V) (Good := Good) hstep (∅ : Finset V) (Or.inl rfl)

/--
Odd-characteristic affine mirror criterion, stated using the mathlib hypothesis that `2` is
invertible in the field.

After P1 opens at `x`, choose any `y ≠ x`; the point reflection about `midpoint x y` swaps
`x` and `y`, and its unique fixed point is already dead because it is collinear with them.
-/
theorem initialP_of_pointReflection [Nontrivial V] [Invertible (2 : K)] :
    InitialPStatement (K := K) (V := V) := by
  apply initialP_of_opening_mirrorGood (K := K) (V := V)
  intro x hxmove
  obtain ⟨y, hyx⟩ := exists_ne x
  let c : V := midpoint K x y
  let e : V ≃ᵃ[K] V := AffineEquiv.pointReflection K c
  have hex : e x = y := by
    simp [e, c]
  have hey : e y = x := by
    simp [e, c]
  have hinvol : ∀ z : V, e (e z) = z := by
    intro z
    exact AffineEquiv.pointReflection_involutive K c z
  have hymove : FiniteBuildGame.Move (Cap K V) (insert x (∅ : Finset V)) y := by
    refine ⟨?_, ?_⟩
    · simp [hyx]
    · simpa [Finset.insert_comm] using cap_pair (K := K) (V := V) y x
  have hcx : c ≠ x := by
    intro hcx
    have hxy : y = x := by
      calc
        y = e x := hex.symm
        _ = x := by simp [e, hcx]
    exact hyx hxy
  have hcy : c ≠ y := by
    intro hcy
    have hxy : x = y := by
      calc
        x = e y := hey.symm
        _ = y := by simp [e, hcy]
    exact hyx hxy.symm
  have hcenter_col : Collinear K V c x y := by
    simpa [c] using collinear_midpoint_left (K := K) (V := V) x y
  refine ⟨e, y, hinvol, hymove, ?_⟩
  refine ⟨hymove.2, ?_, ?_, ?_⟩
  · ext z
    simp [hex, hey, or_comm]
  · intro z hz
    simp at hz
    rcases hz with rfl | rfl
    · simpa [hey] using hyx.symm
    · simpa [hex] using hyx
  · intro z hzmove hfix
    have hz_center : z = c := by
      exact (AffineEquiv.pointReflection_fixed_iff_of_module (k := K) (x := c) (y := z)).1
        (by simpa [e] using hfix)
    subst z
    exact hzmove.2 (by simp) (by simp) (by simp) hcx hcy hyx.symm hcenter_col

/--
The affine cap achievement game is a P-position on every finite nontrivial
affine space over a field.

If `(2 : K) = 0`, a nonzero translation is a fixed-point-free involution.  If
`(2 : K) ≠ 0`, point reflection after the opening exchange gives the
self-blocking mirror center.
-/
theorem initialP_of_nontrivial [Nontrivial V] :
    InitialPStatement (K := K) (V := V) := by
  by_cases h2 : (2 : K) = 0
  · obtain ⟨v, hv0⟩ := exists_ne (0 : V)
    have hvv : v + v = 0 := by
      rw [← two_smul K v, h2, zero_smul]
    exact initialP_of_orderTwoTranslation (K := K) (V := V) v hv0 hvv
  · letI : Invertible (2 : K) := invertibleOfNonzero h2
    exact initialP_of_pointReflection (K := K) (V := V)

/-- Coordinate-space form: the affine cap game on `K^ι` is P for every
nonempty finite coordinate set over a finite field. -/
theorem initialP_pi {ι : Type*} [Fintype K] [DecidableEq K] [Fintype ι] [DecidableEq ι]
    [Nonempty ι] :
    InitialPStatement (K := K) (V := ι -> K) :=
  initialP_of_nontrivial (K := K) (V := ι -> K)

/-- Paper-facing finite-dimensional form: the affine cap game on `AG(n,K)` is
P for every positive finite dimension over a finite field. -/
theorem initialP_fin (n : ℕ) [Fintype K] [DecidableEq K] (hn : 0 < n) :
    InitialPStatement (K := K) (V := Fin n -> K) := by
  haveI : Nonempty (Fin n) := ⟨⟨0, hn⟩⟩
  exact initialP_pi (K := K) (ι := Fin n)

end Game

section ClassicalCapSet

variable {W : Type*} [AddCommGroup W]

/-- Three-term arithmetic progression with `b` as midpoint. -/
def ThreeAP (a b c : W) : Prop :=
  a + c = b + b

/-- Classical cap-set predicate, useful over vector spaces of characteristic `3`. -/
def APFree (S : Finset W) : Prop :=
  ∀ ⦃a b c : W⦄,
    a ∈ S -> b ∈ S -> c ∈ S ->
      a ≠ b -> a ≠ c -> b ≠ c -> ¬ ThreeAP a b c

end ClassicalCapSet

end Affine
end CapGame
