import RelativeConicArcs.ClebschDoubleCosetDepth
import RelativeConicArcs.ClebschGatewayQ11Fusion

/-!
# A modular Fourier contraction in four dimensions

This module checks a concrete linear-algebra package over `ZMod 11`.  An integral four-by-four
matrix is divided by eleven and reduced modulo eleven to give a square-zero operator `F`.  A
second displayed matrix `h` contracts it: `Fh + hF = 1` and `h² = 0`.  The weighted depth-profile
matrix imported from `ClebschDoubleCosetDepth` spans the image of `h`; the image of `F` is its
complement.

The diagonal form with entries `1,1,2,2` makes `F` self-adjoint.  The displayed two-column basis
of `im(F)` has a left inverse and zero Gram matrix, which is the finite coordinate certificate that
`im(F)` is a Lagrangian plane.

The final checks concern two ordered flags in two-dimensional metric spaces.  The target metric
and flag have only scalar isometric stabilizers.  In contrast, every pairing induced on the source
flag by the displayed two-parameter polarization space is diagonal in that flag.  Its cross-pairing
is therefore zero, whereas the target cross-pairing is nonzero.  Thus this module proves the exact
finite flag-orbit obstruction; it does not construct a source-to-target isometry.

All conclusions are obtained by kernel reduction from the displayed matrices and from the imported
depth-profile values.  The identification of those matrices with association-scheme Fourier data,
matching geometry, or Tate cohomology is not formalized here.
-/

namespace RelativeConicArcs
namespace ClebschModularFourierContraction

open Matrix

/-- The prime field used by every matrix in this module. -/
abbrev F11 := ZMod 11

/-- Coordinate vectors of a specified finite dimension over `ZMod 11`. -/
abbrev Vec (n : Nat) := Fin n → F11

/-- The integral quotient of the displayed odd Fourier matrix by eleven. -/
def dividedFourierInt : Matrix (Fin 4) (Fin 4) Int := ![
  ![-1, 0, 4, -2],
  ![0, -1, 2, 4],
  ![2, 1, 1, 0],
  ![-1, 2, 0, 1]
]

/-- The integral quotient really multiplies back to the imported odd Fourier matrix. -/
theorem eleven_smul_dividedFourierInt :
    (11 : Int) • dividedFourierInt = ClebschGateway.Q11Fusion.oddFourier := by
  decide

/-- The divided odd Fourier operator reduced modulo eleven. -/
def dividedFourier : Matrix (Fin 4) (Fin 4) F11 := ![
  ![10, 0, 4, 9],
  ![0, 10, 2, 4],
  ![2, 1, 1, 0],
  ![10, 2, 0, 1]
]

/-- The depth-selected contracting homotopy. -/
def contraction : Matrix (Fin 4) (Fin 4) F11 := ![
  ![3, 5, 5, 9],
  ![8, 10, 2, 9],
  ![0, 3, 8, 8],
  ![8, 7, 5, 1]
]

/-- Inclusion of the three positive profile labels into the six signed profile labels. -/
def positiveProfileIndex (j : Fin 3) : Fin 6 := ⟨j.val, by omega⟩

/-- The three positive profiles weighted by their orbit sizes `1,4,6`. -/
def depthMatrix : Matrix (Fin 4) (Fin 3) F11 :=
  fun i j => (![1, 4, 6] : Fin 3 → F11) j *
    ClebschDoubleCosetDepth.representativeProfile (positiveProfileIndex j) i

/-- The depth matrix is recomputed from the imported profile values and orbit weights. -/
theorem depthMatrix_values : depthMatrix = (![
    ![5, 10, 7],
    ![0, 1, 10],
    ![1, 0, 10],
    ![10, 1, 0]
  ] : Matrix (Fin 4) (Fin 3) F11) := by
  unfold depthMatrix positiveProfileIndex
  rw [show ClebschDoubleCosetDepth.representativeProfile = ![
      ![5, 0, 1, 10], ![8, 3, 0, 3], ![3, 9, 9, 0],
      ![6, 0, 10, 1], ![3, 8, 0, 8], ![8, 2, 2, 0]
    ] from ClebschDoubleCosetDepth.representativeProfile_values]
  decide

/-- The primitive dependence of the three weighted depth columns. -/
theorem depthMatrix_socle :
    depthMatrix *ᵥ (![1, 1, 1] : Vec 3) = 0 := by
  rw [depthMatrix_values]
  decide

/-- The displayed socle line is the complete kernel of the weighted depth matrix. -/
theorem depthMatrix_kernel (x : Vec 3) :
    depthMatrix *ᵥ x = 0 ↔
      ∃ c : F11, x = c • (![1, 1, 1] : Vec 3) := by
  constructor
  · intro hx
    rw [depthMatrix_values] at hx
    have h0 := congrFun hx 2
    have h1 := congrFun hx 1
    simp [Matrix.mulVec, dotProduct, Fin.sum_univ_succ] at h0 h1
    have hchar : (11 : F11) = 0 := ZMod.natCast_self 11
    refine ⟨x 2, ?_⟩
    funext i
    fin_cases i
    · simp
      linear_combination h0 - x 2 * hchar
    · simp
      linear_combination h1 - x 2 * hchar
    · simp
  · rintro ⟨c, rfl⟩
    rw [mulVec_smul, depthMatrix_socle, smul_zero]

/-- Two independent columns spanning the depth plane. -/
def depthBasis : Matrix (Fin 4) (Fin 2) F11 := ![
  ![5, 10],
  ![0, 1],
  ![1, 0],
  ![10, 1]
]

/-- A left inverse for the displayed depth basis. -/
def depthLeftInverse : Matrix (Fin 2) (Fin 4) F11 := ![
  ![8, 10, 3, 9],
  ![9, 10, 10, 0]
]

/-- The divided Fourier operator is square-zero. -/
theorem dividedFourier_sq :
    dividedFourier * dividedFourier = 0 := by
  decide

/-- The contraction is square-zero. -/
theorem contraction_sq :
    contraction * contraction = 0 := by
  decide

/-- The two operators satisfy the contracting-homotopy identity. -/
theorem contraction_identity :
    dividedFourier * contraction + contraction * dividedFourier = 1 := by
  decide

/-- The depth and radical projectors. -/
def depthProjector : Matrix (Fin 4) (Fin 4) F11 := contraction * dividedFourier

/-- The projector onto the square-zero Fourier image. -/
def radicalProjector : Matrix (Fin 4) (Fin 4) F11 := dividedFourier * contraction

/-- The depth projector is split by the displayed depth basis and its left inverse. -/
theorem depthBasis_split :
    depthLeftInverse * depthBasis = 1 ∧
      depthBasis * depthLeftInverse = depthProjector := by
  constructor <;> decide

/-- The three weighted depth columns lie exactly in the displayed two-column depth plane. -/
def depthCoordinates : Matrix (Fin 2) (Fin 3) F11 := ![
  ![1, 0, 10],
  ![0, 1, 10]
]

theorem depthMatrix_factorization :
    depthMatrix = depthBasis * depthCoordinates := by
  rw [depthMatrix_values]
  decide

/-- The complementary projectors give the direct-sum certificate. -/
theorem complementary_projectors :
    depthProjector * depthProjector = depthProjector ∧
    radicalProjector * radicalProjector = radicalProjector ∧
    depthProjector * radicalProjector = 0 ∧
    radicalProjector * depthProjector = 0 ∧
    depthProjector + radicalProjector = 1 := by
  constructor <;> decide

/-- Coordinate form of `im(F) = ker(F)`, with the contraction providing the reverse witness. -/
theorem mem_range_dividedFourier_iff (y : Vec 4) :
    (∃ x : Vec 4, dividedFourier *ᵥ x = y) ↔ dividedFourier *ᵥ y = 0 := by
  constructor
  · rintro ⟨x, rfl⟩
    rw [mulVec_mulVec, dividedFourier_sq, zero_mulVec]
  · intro hy
    refine ⟨contraction *ᵥ y, ?_⟩
    have h := congrArg (fun M : Matrix (Fin 4) (Fin 4) F11 => M *ᵥ y)
      contraction_identity
    rw [add_mulVec, one_mulVec, ← mulVec_mulVec, ← mulVec_mulVec] at h
    simpa [hy] using h

/-- The valency form on the four-dimensional odd relation space. -/
def valencyForm : Matrix (Fin 4) (Fin 4) F11 := diagonal ![1, 1, 2, 2]

/-- The divided Fourier operator is self-adjoint for the valency form. -/
theorem dividedFourier_selfAdjoint :
    dividedFourier.transpose * valencyForm = valencyForm * dividedFourier := by
  decide

/-- A two-column basis of the Fourier image. -/
def radicalBasis : Matrix (Fin 4) (Fin 2) F11 := dividedFourier * depthBasis

/-- A left inverse for the Fourier-image basis. -/
def radicalLeftInverse : Matrix (Fin 2) (Fin 4) F11 := ![
  ![3, 1, 0, 0],
  ![2, 1, 0, 0]
]

/-- The Fourier image has dimension two and is totally isotropic: the coordinate Lagrangian
certificate. -/
theorem radicalBasis_lagrangian_certificate :
    radicalLeftInverse * radicalBasis = 1 ∧
      radicalBasis.transpose * valencyForm * radicalBasis = 0 := by
  constructor <;> decide

/-- The target metric on the depth-plane coordinates. -/
def targetMetric : Matrix (Fin 2) (Fin 2) F11 := ![![3, 7], ![7, 10]]

/-- The ordered doubled and residual target lines. -/
def doubledLine : Vec 2 := ![1, 10]

/-- The residual member of the ordered target flag. -/
def residualLine : Vec 2 := ![1, 9]

/-- A matrix preserves a projective line when the two displayed vectors have zero determinant. -/
def fixesLine (A : Matrix (Fin 2) (Fin 2) F11) (v : Vec 2) : Prop :=
  (A *ᵥ v) 0 * v 1 = (A *ᵥ v) 1 * v 0

/-- The target metric-plus-ordered-flag stabilizer consists only of scalar matrices. -/
theorem targetFlag_projectivelyRigid (a00 a01 a10 a11 : F11) :
    let A : Matrix (Fin 2) (Fin 2) F11 := ![![a00, a01], ![a10, a11]]
    let pulled := A.transpose * targetMetric * A
    pulled 0 0 = 3 → pulled 0 1 = 7 → pulled 1 0 = 7 → pulled 1 1 = 10 →
    fixesLine A doubledLine →
    fixesLine A residualLine →
    ∃ c : F11, A 0 0 = c ∧ A 0 1 = 0 ∧ A 1 0 = 0 ∧ A 1 1 = c := by
  dsimp
  intros h00 h01 h10 h11 hd hr
  simp [targetMetric, fixesLine, doubledLine, residualLine, Matrix.mul_apply,
    Matrix.mulVec, dotProduct, Fin.sum_univ_succ] at h00 h01 h10 h11 hd hr
  ring_nf at h00 h01 h10 h11 hd hr
  have hchar : (11 : F11) = 0 := ZMod.natCast_self 11
  have hc : a10 = 9 * a01 := by
    linear_combination hr - 2 * hd + (-a11 + a00 + 10 * a01) * hchar
  simp only [hc] at hd h00 h01 h10 h11
  have hdiag : a11 = a00 - 3 * a01 := by
    linear_combination hd + (a11 - 8 * a01 - a00) * hchar
  simp only [hdiag] at h00 h01 h10 h11
  have hlam : 10 * (a00 - a01) ^ 2 = 10 := by
    linear_combination h00 - h01 - h10 + h11 +
      (-1 + 4 * a00 * a01 + a00 ^ 2 - 115 * a01 ^ 2) * hchar
  have hmu : 4 * (a00 - 2 * a01) ^ 2 = 4 := by
    linear_combination h00 - 2 * h01 - 2 * h10 + 4 * h11 +
      (1 + 30 * a00 * a01 - a00 ^ 2 - 166 * a01 ^ 2) * hchar
  have hcross : 2 * (a00 - a01) * (a00 - 2 * a01) = 2 := by
    linear_combination h00 - 2 * h01 - h10 + 2 * h11 +
      (16 * a00 * a01 - 139 * a01 ^ 2) * hchar
  have hlam1 : (a00 - a01) ^ 2 = 1 := by
    linear_combination 10 * hlam +
      (9 + 18 * a00 * a01 - 9 * a00 ^ 2 - 9 * a01 ^ 2) * hchar
  have hcross1 : (a00 - a01) * (a00 - 2 * a01) = 1 := by
    linear_combination 6 * hcross +
      (1 + 3 * a00 * a01 - a00 ^ 2 - 2 * a01 ^ 2) * hchar
  have hprod : (a00 - a01) * a01 = 0 := by
    linear_combination hlam1 - hcross1
  have hne : a00 - a01 ≠ 0 := by
    intro hz
    rw [hz] at hlam1
    norm_num at hlam1
  have hb : a01 = 0 := (mul_eq_zero.mp hprod).resolve_left hne
  refine ⟨a00, rfl, hb, ?_, ?_⟩
  · simpa [hb] using hc
  · simpa [hb] using hdiag

/-- The two target flag lines have nonzero cross-pairing. -/
theorem targetFlag_crossPairing :
    dotProduct doubledLine (targetMetric *ᵥ residualLine) = 2 := by
  decide

/-- The complete source polarization image is diagonal in its ordered flag basis. -/
def sourceMetric (a b : F11) : Matrix (Fin 2) (Fin 2) F11 := ![![a, 0], ![0, b]]

/-- The rank-one member of the ordered source flag, in its intrinsic flag basis. -/
def sourceRankOneLine : Vec 2 := ![1, 0]

/-- The rank-nine member of the ordered source flag, in its intrinsic flag basis. -/
def sourceRankNineLine : Vec 2 := ![0, 1]

/-- Every induced source pairing makes the ordered source flag orthogonal. -/
theorem sourceFlag_crossPairing_zero (a b : F11) :
    dotProduct sourceRankOneLine (sourceMetric a b *ᵥ sourceRankNineLine) = 0 := by
  simp [sourceRankOneLine, sourceRankNineLine, sourceMetric, Matrix.mulVec,
    dotProduct, Fin.sum_univ_succ]

/-- Nonzero rescalings cannot carry an orthogonal source flag to the nonorthogonal target flag. -/
theorem source_target_flag_orbits_disjoint (a b sd sr : F11) :
    a ≠ 0 → b ≠ 0 → sd ≠ 0 → sr ≠ 0 →
    dotProduct sourceRankOneLine (sourceMetric a b *ᵥ sourceRankNineLine) ≠
      dotProduct (sd • doubledLine) (targetMetric *ᵥ (sr • residualLine)) := by
  intros _ _ hsd hsr
  rw [sourceFlag_crossPairing_zero]
  have hchar : (11 : F11) = 0 := ZMod.natCast_self 11
  have hscaled :
      dotProduct (sd • doubledLine) (targetMetric *ᵥ (sr • residualLine)) =
        2 * sd * sr := by
    simp [doubledLine, residualLine, targetMetric, Matrix.mulVec, dotProduct,
      Fin.sum_univ_succ]
    linear_combination (94 * sd * sr) * hchar
  rw [hscaled]
  exact (mul_ne_zero (mul_ne_zero (by decide : (2 : F11) ≠ 0) hsd) hsr).symm

end ClebschModularFourierContraction
end RelativeConicArcs
