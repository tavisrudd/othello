import ProjectiveCap.PlaneOutcome
import TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11

/-!
# Order-eleven projective-cap certificate bridge

This module is the first place where the human projective-plane development
and the independent, Mathlib-only order-eleven reply-book certificate are
imported together.  It identifies their residual-grid predicates, translates
the certificate's local reply-book semantics to the human game semantics, and
then performs the geometric normalization and projective transport.
-/

namespace TavisRuddFiniteGeom.Papers.ProjectiveCapQ11

open ProjectiveCap

/-- The certificate and human developments use definitionally equal affine-grid point types. -/
theorem gridPoint_type_compatibility (K : Type*) :
    TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.GridPoint K =
      ProjectiveCap.GridPoint K := by
  rfl

/-- The certificate and human developments use the same division-free collinearity relation. -/
theorem collinear_compatibility {K : Type*} [Field K]
    (p q r : ProjectiveCap.GridPoint K) :
    TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.Collinear p q r ↔
      ProjectiveCap.Collinear p q r := by
  rfl

/-- The certificate's local cap predicate is exactly the human residual-grid cap predicate. -/
theorem gridCap_compatibility {K : Type*} [Field K]
    (S : Finset (ProjectiveCap.GridPoint K)) :
    TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.GridCap S ↔
      ProjectiveCap.GridCap S := by
  rfl

/-- Legal one-point moves agree across the certificate and human local models. -/
theorem move_compatibility {K : Type*} [Field K] [Fintype K] [DecidableEq K]
    (S : Finset (ProjectiveCap.GridPoint K)) (x : ProjectiveCap.GridPoint K) :
    TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.Move
        (TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.GridCap (K := K)) S x ↔
      FiniteBuildGame.Move (ProjectiveCap.GridCap (K := K)) S x := by
  rfl

private def toHumanRow {K : Type*}
    (row : TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.ReplyBookRow
      (ProjectiveCap.GridPoint K)) :
    FiniteBuildGame.ReplyBookRow (ProjectiveCap.GridPoint K) where
  mover := row.mover
  reply := row.reply
  child := row.child

private def toHumanBook {K : Type*}
    (book : TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.ReplyBookDAG
      (ProjectiveCap.GridPoint K)) :
    FiniteBuildGame.ReplyBookDAG (ProjectiveCap.GridPoint K) where
  root := book.root
  Node := book.Node
  Row := fun S row => ∃ certificateRow, book.Row S certificateRow ∧
    toHumanRow certificateRow = row

/-- A valid local certificate reply book is a valid reply book for the human residual game. -/
theorem replyBook_validFor_compatibility {K : Type*}
    [Field K] [Fintype K] [DecidableEq K]
    {book : TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.ReplyBookDAG
      (ProjectiveCap.GridPoint K)}
    (hbook : TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.ReplyBookDAG.ValidFor
      (TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.GridCap (K := K)) book) :
    (toHumanBook book).ValidFor (ProjectiveCap.GridCap (K := K)) := by
  rcases hbook with ⟨hroot, hvalid, hstep⟩
  refine ⟨hroot, ?_, ?_⟩
  · intro S hS
    exact (gridCap_compatibility S).mp (hvalid hS)
  · intro S hS x hx
    have hxCertificate :
        TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.Move
          (TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.GridCap (K := K)) S x :=
      (move_compatibility S x).mpr hx
    rcases hstep hS x hxCertificate with
      ⟨row, hrow, hmover, hreply, hchild, hchildNode⟩
    refine ⟨toHumanRow row, ⟨row, hrow, rfl⟩, ?_, ?_, ?_, hchildNode⟩
    · exact hmover
    · exact (move_compatibility (insert x S) row.reply).mp hreply
    · exact hchild

/-- A valid certificate class supplies a P-position witness in the human residual game. -/
theorem isP_witness_of_certificate {K : Type*}
    [Field K] [Fintype K] [DecidableEq K]
    {certificate :
      TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.GridClassCert K}
    (hcertificate : certificate.Valid) :
    ProjectiveCap.GridGame.IsP (K := K)
      (insert certificate.witness certificate.sizeThree) := by
  have hbook := replyBook_validFor_compatibility hcertificate.2.2.2.2
  have hroot : FiniteBuildGame.IsP (ProjectiveCap.GridCap (K := K))
      (toHumanBook certificate.book).root :=
    FiniteBuildGame.ReplyBookDAG.isP_root hbook
  simpa [toHumanBook, hcertificate.2.2.2.1] using hroot

private theorem escape_at_preimage_of_gridSymmetry {K : Type*}
    [Field K] [Fintype K] [DecidableEq K]
    {f : ProjectiveCap.GridPoint K → ProjectiveCap.GridPoint K}
    (hf : ProjectiveCap.ConicLocalization.GridSymmetry (K := K) f)
    {S : Finset (ProjectiveCap.GridPoint K)}
    {certificate :
      TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.GridClassCert K}
    (hcertificate : certificate.Valid)
    (hrep : certificate.sizeThree = S.image f) :
    ∃ p : ProjectiveCap.GridPoint K,
      p ∈ ProjectiveCap.GridGame.LegalExtensions (K := K) S ∧
        ProjectiveCap.GridGame.IsP (K := K) (insert p S) := by
  classical
  let e : ProjectiveCap.GridPoint K ≃ ProjectiveCap.GridPoint K :=
    Equiv.ofBijective f hf.1
  have hmap : ∀ T : Finset (ProjectiveCap.GridPoint K),
      T.map e.toEmbedding = T.image f := by
    intro T
    ext y
    rw [Finset.mem_map_equiv, Finset.mem_image]
    constructor
    · intro hy
      exact ⟨e.symm y, hy, e.apply_symm_apply y⟩
    · rintro ⟨x, hx, hxy⟩
      have hex : e x = y := by simpa [e] using hxy
      have hxey : e.symm y = x := by
        rw [← hex, Equiv.symm_apply_apply]
      simpa [hxey] using hx
  have hValid : ∀ T : Finset (ProjectiveCap.GridPoint K),
      ProjectiveCap.GridCap (K := K) (T.map e.toEmbedding) ↔
        ProjectiveCap.GridCap (K := K) T := by
    intro T
    rw [hmap T]
    exact hf.2 T
  let p : ProjectiveCap.GridPoint K := e.symm certificate.witness
  refine ⟨p, ?_, ?_⟩
  · have hmoveCertificate := hcertificate.2.2.1
    have hmoveImage : FiniteBuildGame.Move (ProjectiveCap.GridCap (K := K))
        (S.image f) certificate.witness := by
      exact (move_compatibility (S.image f) certificate.witness).mp (by
        simpa [hrep] using hmoveCertificate)
    have hpimage : e p = certificate.witness := by simp [p]
    have hmoveMap : FiniteBuildGame.Move (ProjectiveCap.GridCap (K := K))
        (S.map e.toEmbedding) (e p) := by
      simpa [hmap S, hpimage] using hmoveImage
    exact ProjectiveCap.GridGame.mem_legalExtensions.mpr
      ((FiniteBuildGame.move_map (Valid := ProjectiveCap.GridCap (K := K)) e hValid).mp
        hmoveMap)
  · have hPimage : ProjectiveCap.GridGame.IsP (K := K)
        (insert certificate.witness (S.image f)) := by
      simpa [hrep] using isP_witness_of_certificate hcertificate
    have hpimage : e p = certificate.witness := by simp [p]
    have himage : (insert p S).image f = insert certificate.witness (S.image f) := by
      rw [← hmap (insert p S), Finset.map_insert, hmap S]
      simp [hpimage]
    exact (ProjectiveCap.ConicLocalization.gridSymmetry_isP_image
      (K := K) hf (insert p S)).mp (by simpa [himage] using hPimage)

private theorem axisAffine_bijective {K : Type*} [Field K]
    {rowScale rowShift colScale colShift : K}
    (hrow : rowScale ≠ 0) (hcol : colScale ≠ 0) :
    Function.Bijective
      (ProjectiveCap.ConicLocalization.axisAffine
        (K := K) rowScale rowShift colScale colShift) := by
  constructor
  · intro p q hpq
    have hrowEq := congrArg Prod.fst hpq
    have hcolEq := congrArg Prod.snd hpq
    ext
    · apply mul_left_cancel₀ hrow
      exact (add_right_injective rowShift) (by
        simpa [ProjectiveCap.ConicLocalization.axisAffine, add_comm] using hrowEq)
    · apply mul_left_cancel₀ hcol
      exact (add_right_injective colShift) (by
        simpa [ProjectiveCap.ConicLocalization.axisAffine, add_comm] using hcolEq)
  · intro y
    refine ⟨(rowScale⁻¹ * (y.1 - rowShift), colScale⁻¹ * (y.2 - colShift)), ?_⟩
    ext <;> simp [ProjectiveCap.ConicLocalization.axisAffine]
    · field_simp [hrow]
      ring
    · field_simp [hcol]
      ring

private theorem axisAffine_first_eq_iff {K : Type*} [Field K]
    {rowScale rowShift colScale colShift : K} (hrow : rowScale ≠ 0)
    (p q : ProjectiveCap.GridPoint K) :
    (ProjectiveCap.ConicLocalization.axisAffine
      (K := K) rowScale rowShift colScale colShift p).1 =
        (ProjectiveCap.ConicLocalization.axisAffine
          (K := K) rowScale rowShift colScale colShift q).1 ↔ p.1 = q.1 := by
  constructor
  · intro h
    apply mul_left_cancel₀ hrow
    exact (add_right_injective rowShift) (by
      simpa [ProjectiveCap.ConicLocalization.axisAffine, add_comm] using h)
  · intro h
    simp [ProjectiveCap.ConicLocalization.axisAffine, h]

private theorem axisAffine_second_eq_iff {K : Type*} [Field K]
    {rowScale rowShift colScale colShift : K} (hcol : colScale ≠ 0)
    (p q : ProjectiveCap.GridPoint K) :
    (ProjectiveCap.ConicLocalization.axisAffine
      (K := K) rowScale rowShift colScale colShift p).2 =
        (ProjectiveCap.ConicLocalization.axisAffine
          (K := K) rowScale rowShift colScale colShift q).2 ↔ p.2 = q.2 := by
  constructor
  · intro h
    apply mul_left_cancel₀ hcol
    exact (add_right_injective colShift) (by
      simpa [ProjectiveCap.ConicLocalization.axisAffine, add_comm] using h)
  · intro h
    simp [ProjectiveCap.ConicLocalization.axisAffine, h]

private theorem collinear_axisAffine_iff {K : Type*} [Field K]
    {rowScale rowShift colScale colShift : K}
    (hrow : rowScale ≠ 0) (hcol : colScale ≠ 0)
    (p q r : ProjectiveCap.GridPoint K) :
    ProjectiveCap.Collinear (K := K)
        (ProjectiveCap.ConicLocalization.axisAffine
          (K := K) rowScale rowShift colScale colShift p)
        (ProjectiveCap.ConicLocalization.axisAffine
          (K := K) rowScale rowShift colScale colShift q)
        (ProjectiveCap.ConicLocalization.axisAffine
          (K := K) rowScale rowShift colScale colShift r) ↔
      ProjectiveCap.Collinear (K := K) p q r := by
  unfold ProjectiveCap.Collinear ProjectiveCap.ConicLocalization.axisAffine
  constructor
  · intro h
    apply mul_left_cancel₀ (mul_ne_zero hrow hcol)
    convert h using 1 <;> ring
  · intro h
    have hscaled := congrArg (fun t => rowScale * colScale * t) h
    convert hscaled using 1 <;> ring

private theorem gridCap_image_axisAffine_iff {K : Type*}
    [Field K] [Fintype K] [DecidableEq K]
    {rowScale rowShift colScale colShift : K}
    (hrow : rowScale ≠ 0) (hcol : colScale ≠ 0)
    (S : Finset (ProjectiveCap.GridPoint K)) :
    ProjectiveCap.GridCap (K := K)
        (S.image (ProjectiveCap.ConicLocalization.axisAffine
          (K := K) rowScale rowShift colScale colShift)) ↔
      ProjectiveCap.GridCap (K := K) S := by
  let f := ProjectiveCap.ConicLocalization.axisAffine
    (K := K) rowScale rowShift colScale colShift
  have hf : Function.Bijective f := axisAffine_bijective hrow hcol
  constructor
  · intro himage
    let g := ProjectiveCap.ConicLocalization.axisAffine (K := K)
      rowScale⁻¹ (-rowScale⁻¹ * rowShift) colScale⁻¹ (-colScale⁻¹ * colShift)
    have hgf : Function.LeftInverse g f := by
      intro p
      ext <;> simp [f, g, ProjectiveCap.ConicLocalization.axisAffine]
      · field_simp [hrow]
        ring
      · field_simp [hcol]
        ring
    have hback : (S.image f).image g = S := by
      ext x
      constructor
      · intro hx
        rcases Finset.mem_image.mp hx with ⟨y, hy, rfl⟩
        rcases Finset.mem_image.mp hy with ⟨z, hz, rfl⟩
        simpa [hgf z] using hz
      · intro hx
        exact Finset.mem_image.mpr
          ⟨f x, Finset.mem_image.mpr ⟨x, hx, rfl⟩, hgf x⟩
    have hgrow : rowScale⁻¹ ≠ 0 := inv_ne_zero hrow
    have hgcol : colScale⁻¹ ≠ 0 := inv_ne_zero hcol
    rw [← hback]
    rcases himage with ⟨⟨hrowSparse, hcolSparse⟩, hcap⟩
    refine ⟨⟨?_, ?_⟩, ?_⟩
    · intro p q hp hq hpq
      rcases Finset.mem_image.mp hp with ⟨p0, hp0, rfl⟩
      rcases Finset.mem_image.mp hq with ⟨q0, hq0, rfl⟩
      have hpq0 := (axisAffine_first_eq_iff hgrow p0 q0).mp hpq
      rw [hrowSparse hp0 hq0 hpq0]
    · intro p q hp hq hpq
      rcases Finset.mem_image.mp hp with ⟨p0, hp0, rfl⟩
      rcases Finset.mem_image.mp hq with ⟨q0, hq0, rfl⟩
      have hpq0 := (axisAffine_second_eq_iff hgcol p0 q0).mp hpq
      rw [hcolSparse hp0 hq0 hpq0]
    · intro a b c ha hb hc hab hac hbc hcollinear
      rcases Finset.mem_image.mp ha with ⟨a0, ha0, rfl⟩
      rcases Finset.mem_image.mp hb with ⟨b0, hb0, rfl⟩
      rcases Finset.mem_image.mp hc with ⟨c0, hc0, rfl⟩
      exact hcap ha0 hb0 hc0 (fun h => hab (by rw [h]))
        (fun h => hac (by rw [h])) (fun h => hbc (by rw [h]))
        ((collinear_axisAffine_iff hgrow hgcol a0 b0 c0).mp hcollinear)
  · intro hS
    rcases hS with ⟨⟨hrowSparse, hcolSparse⟩, hcap⟩
    refine ⟨⟨?_, ?_⟩, ?_⟩
    · intro p q hp hq hpq
      rcases Finset.mem_image.mp hp with ⟨p0, hp0, rfl⟩
      rcases Finset.mem_image.mp hq with ⟨q0, hq0, rfl⟩
      have hpq0 := (axisAffine_first_eq_iff hrow p0 q0).mp hpq
      rw [hrowSparse hp0 hq0 hpq0]
    · intro p q hp hq hpq
      rcases Finset.mem_image.mp hp with ⟨p0, hp0, rfl⟩
      rcases Finset.mem_image.mp hq with ⟨q0, hq0, rfl⟩
      have hpq0 := (axisAffine_second_eq_iff hcol p0 q0).mp hpq
      rw [hcolSparse hp0 hq0 hpq0]
    · intro a b c ha hb hc hab hac hbc hcollinear
      rcases Finset.mem_image.mp ha with ⟨a0, ha0, rfl⟩
      rcases Finset.mem_image.mp hb with ⟨b0, hb0, rfl⟩
      rcases Finset.mem_image.mp hc with ⟨c0, hc0, rfl⟩
      exact hcap ha0 hb0 hc0 (fun h => hab (by rw [h]))
        (fun h => hac (by rw [h])) (fun h => hbc (by rw [h]))
        ((collinear_axisAffine_iff hrow hcol a0 b0 c0).mp hcollinear)

private def anchorAxisAffine {K : Type*} [Field K]
    (p q : ProjectiveCap.GridPoint K) :
    ProjectiveCap.GridPoint K → ProjectiveCap.GridPoint K :=
  ProjectiveCap.ConicLocalization.axisAffine (K := K)
    (q.1 - p.1)⁻¹ (-(q.1 - p.1)⁻¹ * p.1)
    (q.2 - p.2)⁻¹ (-(q.2 - p.2)⁻¹ * p.2)

private theorem anchorAxisAffine_gridSymmetry {K : Type*}
    [Field K] [Fintype K] [DecidableEq K]
    {p q : ProjectiveCap.GridPoint K}
    (hrow : q.1 - p.1 ≠ 0) (hcol : q.2 - p.2 ≠ 0) :
    ProjectiveCap.ConicLocalization.GridSymmetry (K := K) (anchorAxisAffine p q) := by
  refine ⟨?_, ?_⟩
  · exact axisAffine_bijective (inv_ne_zero hrow) (inv_ne_zero hcol)
  · exact gridCap_image_axisAffine_iff (inv_ne_zero hrow) (inv_ne_zero hcol)

private theorem anchorAxisAffine_left {K : Type*} [Field K]
    (p q : ProjectiveCap.GridPoint K) : anchorAxisAffine p q p = (0, 0) := by
  ext <;> simp [anchorAxisAffine, ProjectiveCap.ConicLocalization.axisAffine]

private theorem anchorAxisAffine_right {K : Type*} [Field K]
    {p q : ProjectiveCap.GridPoint K}
    (hrow : q.1 - p.1 ≠ 0) (hcol : q.2 - p.2 ≠ 0) :
    anchorAxisAffine p q q = (1, 1) := by
  ext <;> simp [anchorAxisAffine, ProjectiveCap.ConicLocalization.axisAffine]
  · field_simp [hrow]
    ring
  · field_simp [hcol]
    ring

private theorem gridCap_row_ne_of_ne {K : Type*} [Field K]
    {S : Finset (ProjectiveCap.GridPoint K)} (hS : ProjectiveCap.GridCap (K := K) S)
    {p q : ProjectiveCap.GridPoint K} (hp : p ∈ S) (hq : q ∈ S) (hpq : p ≠ q) :
    q.1 - p.1 ≠ 0 := by
  intro hzero
  apply hpq
  exact hS.1.1 hp hq (sub_eq_zero.mp hzero).symm

private theorem gridCap_col_ne_of_ne {K : Type*} [Field K]
    {S : Finset (ProjectiveCap.GridPoint K)} (hS : ProjectiveCap.GridCap (K := K) S)
    {p q : ProjectiveCap.GridPoint K} (hp : p ∈ S) (hq : q ∈ S) (hpq : p ≠ q) :
    q.2 - p.2 ≠ 0 := by
  intro hzero
  apply hpq
  exact hS.1.2 hp hq (sub_eq_zero.mp hzero).symm

private abbrev K := ZMod 11
private abbrev P := ProjectiveCap.GridPoint K
private def pt (r c : Nat) : P := ((r : K), (c : K))

/-- A certified anchored class together with the grid symmetry identifying an arbitrary cap. -/
structure TransportWitness (S : Finset P) where
  classCert : TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.GridClassCert K
  symmetry : P → P
  gridSymmetry : ProjectiveCap.ConicLocalization.GridSymmetry (K := K) symmetry
  valid : classCert.Valid
  representsImage : classCert.sizeThree = S.image symmetry

/-- Every three-point residual cap is carried to a class covered by the sealed Q11 certificate. -/
theorem exists_transportWitness (S : Finset P) (hcard : S.card = 3)
    (hcap : ProjectiveCap.GridCap (K := K) S) : Nonempty (TransportWitness S) := by
  classical
  rcases Finset.card_eq_three.mp hcard with ⟨p, q, r, hpq, hpr, hqr, hS⟩
  have hp : p ∈ S := by simp [hS]
  have hq : q ∈ S := by simp [hS]
  have hrow : q.1 - p.1 ≠ 0 := gridCap_row_ne_of_ne hcap hp hq hpq
  have hcol : q.2 - p.2 ≠ 0 := gridCap_col_ne_of_ne hcap hp hq hpq
  let f : P → P := anchorAxisAffine p q
  let x : P := f r
  have hf : ProjectiveCap.ConicLocalization.GridSymmetry (K := K) f :=
    anchorAxisAffine_gridSymmetry hrow hcol
  have hcapImage : ProjectiveCap.GridCap (K := K) (S.image f) := (hf.2 S).2 hcap
  have himage : S.image f = ({pt 0 0, pt 1 1, x} : Finset P) := by
    rw [hS]
    simp [f, x, pt, anchorAxisAffine_left, anchorAxisAffine_right hrow hcol]
  have hcardImage : (S.image f).card = S.card :=
    Finset.card_image_of_injOn (fun a _ b _ hab => hf.1.1 hab)
  have hcardAnchor : ({pt 0 0, pt 1 1, x} : Finset P).card = 3 := by
    rw [← himage, hcardImage, hcard]
  have hcapAnchor : ProjectiveCap.GridCap (K := K)
      ({pt 0 0, pt 1 1, x} : Finset P) := by simpa [← himage] using hcapImage
  refine ⟨{
    classCert := TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.classForThird x
    symmetry := f
    gridSymmetry := hf
    valid := TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.classForThird_valid x
    representsImage := ?_
  }⟩
  rw [himage]
  exact TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.classForThird_sizeThree_of_gridCap
    x hcardAnchor ((gridCap_compatibility _).mpr hcapAnchor)

private noncomputable def transportWitness (S : Finset P) (hcard : S.card = 3)
    (hcap : ProjectiveCap.GridCap (K := K) S) : TransportWitness S :=
  Classical.choice (exists_transportWitness S hcard hcap)

/-- The sealed Q11 reply books prove the residual odd-escape game statement. -/
theorem oddEscapeGameStatement : ProjectiveCap.GridGame.OddEscapeStatement (K := K) := by
  intro S hcard hcap
  let witness := transportWitness S hcard hcap
  exact escape_at_preimage_of_gridSymmetry witness.gridSymmetry witness.valid
    witness.representsImage

/-- The order-eleven projective cap game is a P-position in every rank-three model. -/
theorem initialPStatement_finrank
    {V : Type*} [AddCommGroup V] [Module K V]
    [Fintype (Projective.Point K V)] [DecidableEq (Projective.Point K V)]
    (hrank : Module.finrank K V = 3) :
    Projective.InitialPStatement (K := K) (V := V) :=
  ProjectiveCap.GridMirror.initialPStatement_of_oddEscapeStatement_finrank
    (K := K) (V := V) oddEscapeGameStatement hrank

end TavisRuddFiniteGeom.Papers.ProjectiveCapQ11
