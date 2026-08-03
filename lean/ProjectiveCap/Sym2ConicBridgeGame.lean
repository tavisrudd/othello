import ProjectiveCap.Sym2ConicBridge
import ProjectiveCap.ProjectiveCapGame

/-!
# Game value transport along the symmetric-square collineation

Let `K` be a field, `Line K = Fin 2 → K` and `Plane K = Fin 3 → K`, and let
`veronesePoint : Projectivization K (Line K) → Projectivization K (Plane K)` be
the degree-two Veronese parametrization of the conic `Y² = XZ`, as constructed
in `ProjectiveCap.Sym2ConicBridge`. A matrix `M` with `IsUnit M.det` acts on the
line by `lineEquiv hM` and on the plane by the collineation `sym2Collineation hM`
induced by its symmetric square, and the two actions agree under
`veronesePoint`.

This module records what that geometry implies for the normal-play cap
achievement game of `ProjectiveCap.ProjectiveCapGame` played on
`ProjectiveCap.Projective.Cap K (Plane K)`:

* `sym2Collineation_isP_transport` and `sym2Collineation_win_transport` —
  positions related by `sym2Collineation hM` have equal previous-player-win and
  win values. These carry no conic content on their own; they are the
  instantiation of the general collineation transport
  (`ProjectiveCap.Projective.cap_map_mapEquiv` together with
  `FiniteBuildGame.isP_map`) at this particular collineation, and the same
  statement holds for any `g : Plane K ≃ₗ[K] Plane K`.
* `onconic_value_bridge` and `onconic_win_bridge` — for a set `σ` of conic
  parameters, the on-conic cap `σ.image veronesePoint` has the same value as the
  on-conic cap of the Möbius-transformed parameters
  `σ.image (Projective.mapEquiv (lineEquiv hM))`. Here the conic is genuinely on
  the proof path: the composition uses `sym2Collineation_image_veronesePoint`,
  which says that pushing an on-conic cap through the collineation gives the
  on-conic cap of the transformed parameters. Hence conic parameter sets in the
  same full-`PGL(2, K)` orbit yield equal residual game value, and the parameter
  set is the entire game datum.

The underlying incidence geometry — the Veronese map, the symmetric-square
matrix identities, the conic predicate, and the realization of the Möbius action
— mentions no game and is in `ProjectiveCap.Sym2ConicBridge`.
-/

open scoped LinearAlgebra.Projectivization
open scoped Matrix
open Projectivization

namespace ProjectiveCap
namespace Sym2Bridge

variable {K : Type*} [Field K]

/-! ## Generic value transport under the Sym² collineation

These are the game-theoretic half.  They carry **no on-conic content on their
own**: they are the instantiation of the linear-collineation transport
(`PlaneTransitivity.cap_map_mapEquiv` + `FiniteBuildGame.isP_map`) at the
particular collineation `sym2Collineation hM`, and the same shape holds for any
`g : Plane ≃ₗ[K] Plane`.  The on-conic orbit bridge below feeds them the geometry
half so the composed statement is genuinely about the Veronese conic. -/

variable [Fintype (Projective.Point K (Plane K))]
  [DecidableEq (Projective.Point K (Plane K))]

/-- Two plane cap positions related by the Sym² collineation of a line map with
invertible determinant have the same normal-play `IsP` value. -/
theorem sym2Collineation_isP_transport {M : Matrix (Fin 2) (Fin 2) K}
    (hM : IsUnit M.det) {S T : Finset (Projective.Point K (Plane K))}
    (hST : S.map (sym2Collineation hM).toEmbedding = T) :
    FiniteBuildGame.IsP (Projective.Cap K (Plane K)) S ↔
      FiniteBuildGame.IsP (Projective.Cap K (Plane K)) T := by
  subst hST
  exact (FiniteBuildGame.isP_map (sym2Collineation hM)
    (fun U => Projective.cap_map_mapEquiv (sym2Equiv hM) U) S).symm

/-- Win-value form of the generic transport. -/
theorem sym2Collineation_win_transport {M : Matrix (Fin 2) (Fin 2) K}
    (hM : IsUnit M.det) {S T : Finset (Projective.Point K (Plane K))}
    (hST : S.map (sym2Collineation hM).toEmbedding = T) :
    FiniteBuildGame.Win (Projective.Cap K (Plane K)) S ↔
      FiniteBuildGame.Win (Projective.Cap K (Plane K)) T := by
  subst hST
  exact (FiniteBuildGame.win_map (sym2Collineation hM)
    (fun U => Projective.cap_map_mapEquiv (sym2Equiv hM) U) S).symm

variable [DecidableEq (Projective.Point K (Line K))]

/--
**On-conic full-`PGL(2,q)` orbit bridge.**

For any set `σ` of points of the projective line, the on-conic cap
`σ.image veronesePoint` — the cap on the Veronese conic carried by those conic
parameters — has the same normal-play previous-player-win value as the on-conic
cap of the Möbius-transformed parameters `σ.image (Projective.mapEquiv (lineEquiv hM))`.

The proof composes the Möbius realization `sym2Collineation_veronesePoint`
(geometry) with `sym2Collineation_isP_transport` (game). Hence two parameter
sets in the same full-`PGL(2, K)` orbit yield equal game value: the parameter
set alone determines the value, with no further dependence on the points.
-/
theorem onconic_value_bridge {M : Matrix (Fin 2) (Fin 2) K} (hM : IsUnit M.det)
    (σ : Finset (Projective.Point K (Line K))) :
    FiniteBuildGame.IsP (Projective.Cap K (Plane K)) (σ.image veronesePoint) ↔
      FiniteBuildGame.IsP (Projective.Cap K (Plane K))
        ((σ.image (Projective.mapEquiv (lineEquiv hM))).image veronesePoint) :=
  sym2Collineation_isP_transport hM (sym2Collineation_image_veronesePoint hM σ)

/-- Win-value form of the on-conic orbit bridge. -/
theorem onconic_win_bridge {M : Matrix (Fin 2) (Fin 2) K} (hM : IsUnit M.det)
    (σ : Finset (Projective.Point K (Line K))) :
    FiniteBuildGame.Win (Projective.Cap K (Plane K)) (σ.image veronesePoint) ↔
      FiniteBuildGame.Win (Projective.Cap K (Plane K))
        ((σ.image (Projective.mapEquiv (lineEquiv hM))).image veronesePoint) :=
  sym2Collineation_win_transport hM (sym2Collineation_image_veronesePoint hM σ)

end Sym2Bridge
end ProjectiveCap
