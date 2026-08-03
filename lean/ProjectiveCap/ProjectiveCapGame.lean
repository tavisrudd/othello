import ProjectiveCap.Projective
import CapGame.BuildGame

/-!
# The achievement game played on projective caps

Let `K` be a field, `V` a `K`-vector space with finitely many projective points,
and let `Point K V = Projectivization K V`.  A *cap* is a finite set of points no
three of which are distinct and collinear (`ProjectiveCap.Projective.Cap`,
defined in `ProjectiveCap.Projective`).

This module equips that cap predicate with the normal-play achievement game of
`CapGame.BuildGame`: two players alternately add one point to the current
position, a move is legal exactly when the enlarged set is again a cap, and a
player unable to move loses.  Everything here is the instantiation of the
generic `FiniteBuildGame` interface at `Cap K V`; the underlying plane geometry
carries no game content and lives in `ProjectiveCap.Projective`.

The declarations are stated in the namespace `ProjectiveCap.Projective`, the
same namespace as the cap predicate they refer to.

Nothing in this module is used by the relative-conic-arc development.  It is
separated from `ProjectiveCap.Projective` so that consumers of the projective
plane vocabulary alone do not acquire the build-game interface.
-/

open scoped LinearAlgebra.Projectivization

namespace ProjectiveCap
namespace Projective

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

section Game

variable [Fintype (Point K V)] [DecidableEq (Point K V)]

/-- The points that may legally be added to the cap `S`: those outside `S` whose
insertion leaves a cap. -/
noncomputable def LegalExtensions (S : Finset (Point K V)) : Finset (Point K V) :=
  FiniteBuildGame.LegalExtensions (Cap K V) S

theorem mem_legalExtensions {S : Finset (Point K V)} {x : Point K V} :
    x ∈ LegalExtensions (K := K) (V := V) S ↔
      x ∉ S ∧ Cap K V (insert x S) :=
  FiniteBuildGame.mem_legalExtensions

/-- The position `S` is a win for the player to move in the normal-play cap
achievement game. -/
abbrev Win (S : Finset (Point K V)) : Prop :=
  FiniteBuildGame.Win (Cap K V) S

/-- The empty projective cap position is a previous-player win: the proposition
that the second player wins the cap achievement game from the empty board. -/
def InitialPStatement : Prop :=
  FiniteBuildGame.IsP (Cap K V) (∅ : Finset (Point K V))

/-- Single-orbit transitivity of cap-preserving point permutations on one size
layer of cap positions.  For `k ≤ 4` this is the game-facing form of
`PGL`-transitivity on points, pairs, triangles, and frames. -/
def CapTransitiveStatement (k : ℕ) : Prop :=
  ∀ ⦃S T : Finset (Point K V)⦄, Cap K V S -> Cap K V T ->
    S.card = k -> T.card = k ->
      ∃ e : Point K V ≃ Point K V,
        (∀ U : Finset (Point K V), Cap K V (U.map e.toEmbedding) ↔ Cap K V U) ∧
          S.map e.toEmbedding = T

/--
Frame reduction, game-theoretic half: single-orbit transitivity at sizes
`1..4` plus extendability below size `4` collapse the projective conjecture to
the value of a single frame position.  The four transitivity hypotheses and
the extendability hypothesis are the remaining geometric obligations.
-/
theorem initialPStatement_iff_isP_frame
    (h1 : CapTransitiveStatement (K := K) (V := V) 1)
    (h2 : CapTransitiveStatement (K := K) (V := V) 2)
    (h3 : CapTransitiveStatement (K := K) (V := V) 3)
    (h4 : CapTransitiveStatement (K := K) (V := V) 4)
    (hext : ∀ S : Finset (Point K V), Cap K V S -> S.card ≤ 3 ->
      ∃ x : Point K V, FiniteBuildGame.Move (Cap K V) S x)
    {F : Finset (Point K V)} (hF : Cap K V F) (hFcard : F.card = 4) :
    (InitialPStatement (K := K) (V := V) ↔ FiniteBuildGame.IsP (Cap K V) F) :=
  FiniteBuildGame.isP_empty_iff_isP_of_frame_chain
    (FiniteBuildGame.sizeValueConstant_of_transitive h1)
    (FiniteBuildGame.sizeValueConstant_of_transitive h2)
    (FiniteBuildGame.sizeValueConstant_of_transitive h3)
    (FiniteBuildGame.sizeValueConstant_of_transitive h4)
    hext (cap_empty (K := K) (V := V)) hF hFcard

end Game

end Projective
end ProjectiveCap
