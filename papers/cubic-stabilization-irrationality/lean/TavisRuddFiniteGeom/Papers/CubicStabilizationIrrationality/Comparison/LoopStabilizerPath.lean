import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.TwoLayerDescentPacket

/-!
# Paths of loop-stabilizer packets

The stable-ledger obstruction can be consumed one blow-up edge at a time.  A
vertex carries one packet with an action of the actual loop group.  A forward
edge identifies the source packet with the disjoint union of the target packet
and one correction packet.  If the correction has no point with the selected
power-fixedness period, existence of such a point is equivalent at the two
vertices.  The same equivalence is used in reverse for a blow-down.

Because every edge is indexed by the exact values of one vertex family,
adjacent path steps cannot silently use different loop actions on two nominal
copies of the same intermediate vertex.  No split finite cyclic action is
required.

These results are finite-set and action-theoretic.  They do not construct the
marked primitive packet of a quantum differential module, identify its actual
loop action, prove an Iritani/KKPYY comparison equivariant, or exclude the
selected period from geometric correction packets.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.LoopStabilizerPath

open DescentPacket TwoLayerDescentPacket

universe uG uVertex uPoint

/-- One packet and its action of the actual loop group at a path vertex. -/
structure VertexPacket
    (G : Type uG) [Group G] where
  Point : Type uPoint
  [pointMulAction : MulAction G Point]

attribute [instance] VertexPacket.pointMulAction

/-- Reverse an equivariant equivalence. -/
def equivariantEquivSymm
    {G : Type uG} {A B : Type*}
    [Group G] [MulAction G A] [MulAction G B]
    (equivalence : EquivariantEquiv G A B) :
    EquivariantEquiv G B A where
  toEquiv := equivalence.toEquiv.symm
  map_smul g y := by
    apply equivalence.toEquiv.injective
    rw [equivalence.map_smul]
    simp

/-- An equivariant equivalence transports the complete fixedness fingerprint
under powers of a selected loop. -/
theorem hasPowerFixednessPeriod_map
    {G : Type uG} {A B : Type*}
    [Group G] [MulAction G A] [MulAction G B]
    (equivalence : EquivariantEquiv G A B)
    (generator : G) (period : ℕ) {x : A}
    (fixedness : HasPowerFixednessPeriod G generator period x) :
    HasPowerFixednessPeriod G generator period (equivalence.toEquiv x) := by
  intro k
  rw [← equivalence.map_smul]
  exact (equivalence.toEquiv.injective.eq_iff).trans (fixedness k)

/-- A vertex has selected-period support when one point has exactly that
power-fixedness fingerprint. -/
def HasPeriodAt
    {G : Type uG} [Group G]
    {Vertex : Type uVertex}
    (system : Vertex → VertexPacket.{uG, uPoint} G)
    (generator : G) (period : ℕ) (vertex : Vertex) : Prop :=
  ∃ x : (system vertex).Point,
    HasPowerFixednessPeriod G generator period x

/-- A stable-disjoint-union comparison.  The correction packet is edge-local,
while both endpoint packets are fixed values of the global vertex family. -/
structure Decomposition
    {G : Type uG} [Group G]
    {Vertex : Type uVertex}
    (system : Vertex → VertexPacket.{uG, uPoint} G)
    (source target : Vertex) where
  Correction : Type uPoint
  [correctionMulAction : MulAction G Correction]
  comparison :
    EquivariantEquiv G (system source).Point
      ((system target).Point ⊕ Correction)

attribute [instance] Decomposition.correctionMulAction

/-- A forward blowdown edge adds the correction-period exclusion needed to
force a selected source point into the ambient summand. -/
structure Edge
    {G : Type uG} [Group G]
    {Vertex : Type uVertex}
    (system : Vertex → VertexPacket.{uG, uPoint} G)
    (generator : G) (period : ℕ)
    (source target : Vertex)
    extends Decomposition system source target where
  correctionHasNoPeriod :
    ∀ correction : Correction,
      ¬ HasPowerFixednessPeriod G generator period correction

namespace Edge

variable
    {G : Type uG} [Group G]
    {Vertex : Type uVertex}
    (system : Vertex → VertexPacket.{uG, uPoint} G)
    (generator : G) (period : ℕ)

/-- Exact correction periods distinct from the selected period discharge the
correction-exclusion field. -/
def ofDistinctCorrectionPeriods
    {source target : Vertex}
    {Correction : Type uPoint} [MulAction G Correction]
    (comparison :
      EquivariantEquiv G (system source).Point
        ((system target).Point ⊕ Correction))
    (correctionPeriod : Correction → ℕ)
    (correctionFixedness : ∀ correction : Correction,
      HasPowerFixednessPeriod G generator
        (correctionPeriod correction) correction)
    (periodsDifferent : ∀ correction : Correction,
      period ≠ correctionPeriod correction) :
    Edge system generator period source target where
  Correction := Correction
  comparison := comparison
  correctionHasNoPeriod correction selectedFixedness := by
    obtain ⟨k, different⟩ :=
      exists_power_fixedness_divisibility_difference
        (periodsDifferent correction)
    apply different
    exact (selectedFixedness k).symm.trans
      (correctionFixedness correction k)

/-- One edge preserves existence of a point with the selected exact period.
The forward implication is precisely where correction exclusion is used. -/
theorem hasPeriodAt_iff
    {source target : Vertex}
    (edge : Edge system generator period source target) :
    HasPeriodAt system generator period source ↔
      HasPeriodAt system generator period target := by
  constructor
  · rintro ⟨x, sourceFixedness⟩
    have mappedFixedness :=
      hasPowerFixednessPeriod_map edge.comparison generator period
        sourceFixedness
    cases mapped : edge.comparison.toEquiv x with
    | inl targetPoint =>
        refine ⟨targetPoint, ?_⟩
        intro k
        simpa [mapped] using mappedFixedness k
    | inr correction =>
        exfalso
        apply edge.correctionHasNoPeriod correction
        intro k
        simpa [mapped] using mappedFixedness k
  · rintro ⟨targetPoint, targetFixedness⟩
    let reverse := equivariantEquivSymm edge.comparison
    have sumFixedness :
        HasPowerFixednessPeriod G generator period
          (Sum.inl targetPoint : (system target).Point ⊕ edge.Correction) := by
      intro k
      simpa using targetFixedness k
    exact ⟨reverse.toEquiv (Sum.inl targetPoint),
      hasPowerFixednessPeriod_map reverse generator period
        (x := Sum.inl targetPoint) sumFixedness⟩

end Edge

namespace Decomposition

variable
    {G : Type uG} [Group G]
    {Vertex : Type uVertex}
    (system : Vertex → VertexPacket.{uG, uPoint} G)
    (generator : G) (period : ℕ)

/-- The ambient packet injects into the source packet through the inverse
decomposition.  No hypothesis about correction periods is needed in this
direction. -/
theorem hasPeriodAt_source_of_target
    {source target : Vertex}
    (decomposition : Decomposition system source target)
    (targetHasPeriod : HasPeriodAt system generator period target) :
    HasPeriodAt system generator period source := by
  rcases targetHasPeriod with ⟨targetPoint, targetFixedness⟩
  let reverse := equivariantEquivSymm decomposition.comparison
  have sumFixedness :
      HasPowerFixednessPeriod G generator period
        (Sum.inl targetPoint :
          (system target).Point ⊕ decomposition.Correction) := by
    intro k
    simpa using targetFixedness k
  exact ⟨reverse.toEquiv (Sum.inl targetPoint),
    hasPowerFixednessPeriod_map reverse generator period
      (x := Sum.inl targetPoint) sumFixedness⟩

end Decomposition

/-- An oriented typed step.  Blowup-to-base traversal needs correction
exclusion; base-to-blowup traversal uses only the inverse ambient inclusion. -/
inductive Step
    {G : Type uG} [Group G]
    {Vertex : Type uVertex}
    (system : Vertex → VertexPacket.{uG, uPoint} G)
    (generator : G) (period : ℕ) :
    Vertex → Vertex → Type (max (uPoint + 1) (max uVertex uG))
  | forward {source target : Vertex} :
      Edge system generator period source target →
        Step system generator period source target
  | reverse {source target : Vertex} :
      Decomposition system target source →
        Step system generator period source target

/-- A finite path whose adjacent occurrences share their packet and loop
action by construction. -/
inductive Path
    {G : Type uG} [Group G]
    {Vertex : Type uVertex}
    (system : Vertex → VertexPacket.{uG, uPoint} G)
    (generator : G) (period : ℕ) :
    Vertex → Vertex → Type (max (uPoint + 1) (max uVertex uG))
  | nil (vertex : Vertex) : Path system generator period vertex vertex
  | cons {source middle target : Vertex}
      (step : Step system generator period source middle)
      (tail : Path system generator period middle target) :
      Path system generator period source target

variable
    {G : Type uG} [Group G]
    {Vertex : Type uVertex}
    (system : Vertex → VertexPacket.{uG, uPoint} G)
    (generator : G) (period : ℕ)

/-- Either orientation of one typed edge transports selected-period support in
the direction of traversal. -/
theorem Step.hasPeriodAt_of
    {source target : Vertex}
    (step : Step system generator period source target)
    (sourceHasPeriod : HasPeriodAt system generator period source) :
    HasPeriodAt system generator period target := by
  cases step with
  | forward edge =>
      exact (edge.hasPeriodAt_iff system generator period).mp sourceHasPeriod
  | reverse decomposition =>
      exact decomposition.hasPeriodAt_source_of_target system generator period
        sourceHasPeriod

/-- Selected-period support transports along a typed finite path. -/
theorem Path.hasPeriodAt_of
    {source target : Vertex}
    (path : Path system generator period source target)
    (sourceHasPeriod : HasPeriodAt system generator period source) :
    HasPeriodAt system generator period target := by
  induction path with
  | nil => exact sourceHasPeriod
  | cons step tail inductionHypothesis =>
      exact inductionHypothesis
        (step.hasPeriodAt_of system generator period sourceHasPeriod)

/-- A selected-period source witness cannot reach a target with no such
point. -/
theorem Path.false_of_sourcePeriod_of_targetNoPeriod
    {source target : Vertex}
    (path : Path system generator period source target)
    (sourceHasPeriod : HasPeriodAt system generator period source)
    (targetHasNoPeriod : ¬ HasPeriodAt system generator period target) : False := by
  exact targetHasNoPeriod
    (path.hasPeriodAt_of system generator period sourceHasPeriod)

/-!
## Direct orbit transport

The ambient-plus-correction edge above is the natural output shape of a
blow-up formula.  It is not logically necessary for the endpoint
contradiction.  A second interface asks only for an injective equivariant map
between consecutive vertex packets.  This is suitable when geometry can
prove directly that the carried marked orbit lands in the ambient packet,
without classifying every correction point.
-/

namespace OrbitTransport

/-- An injective equivariant map.  Surjectivity and a correction decomposition
are deliberately absent. -/
structure Map
    {G : Type uG} {A B : Type*}
    [Group G] [MulAction G A] [MulAction G B] where
  toFun : A → B
  injective : Function.Injective toFun
  map_smul : ∀ (g : G) (x : A), toFun (g • x) = g • toFun x

/-- An injective equivariant map preserves the full stabilizer of a point. -/
theorem Map.hasSameStabilizer_map
    {G : Type uG} {A B : Type*}
    [Group G] [MulAction G A] [MulAction G B]
    (map : Map (G := G) (A := A) (B := B)) (x : A) :
    HasSameStabilizer G x (map.toFun x) := by
  intro g
  constructor
  · intro fixed
    rw [← map.map_smul, fixed]
  · intro fixed
    apply map.injective
    rw [map.map_smul]
    exact fixed

/-- Exact power-fixedness period is preserved by an injective equivariant
map. -/
theorem Map.hasPowerFixednessPeriod_map
    {G : Type uG} {A B : Type*}
    [Group G] [MulAction G A] [MulAction G B]
    (map : Map (G := G) (A := A) (B := B))
    (generator : G) (period : ℕ) {x : A}
    (fixedness : HasPowerFixednessPeriod G generator period x) :
    HasPowerFixednessPeriod G generator period (map.toFun x) := by
  intro k
  exact (map.hasSameStabilizer_map x (generator ^ k)).symm.trans
    (fixedness k)

/-- One directed transport between exact values of the vertex packet family. -/
structure Edge
    {G : Type uG} [Group G]
    {Vertex : Type uVertex}
    (system : Vertex → VertexPacket.{uG, uPoint} G)
    (source target : Vertex) where
  comparison :
    Map (G := G) (A := (system source).Point) (B := (system target).Point)

/-- A finite directed path of injective equivariant packet maps.  Reverse
traversal is available only when geometry supplies the reverse directed map;
it is not inferred from injectivity. -/
inductive Path
    {G : Type uG} [Group G]
    {Vertex : Type uVertex}
    (system : Vertex → VertexPacket.{uG, uPoint} G) :
    Vertex → Vertex → Type (max (uPoint + 1) (max uVertex uG))
  | nil (vertex : Vertex) : Path system vertex vertex
  | cons {source middle target : Vertex}
      (edge : Edge system source middle)
      (tail : Path system middle target) : Path system source target

variable
    {G : Type uG} [Group G]
    {Vertex : Type uVertex}
    (system : Vertex → VertexPacket.{uG, uPoint} G)
    (generator : G) (period : ℕ)

/-- A directed injective equivariant edge transports selected-period support
forward. -/
theorem Edge.hasPeriodAt_of
    {source target : Vertex}
    (edge : Edge system source target)
    (sourceHasPeriod : HasPeriodAt system generator period source) :
    HasPeriodAt system generator period target := by
  rcases sourceHasPeriod with ⟨x, fixedness⟩
  exact ⟨edge.comparison.toFun x,
    edge.comparison.hasPowerFixednessPeriod_map generator period fixedness⟩

/-- A directed path of injective equivariant maps transports
selected-period support. -/
theorem Path.hasPeriodAt_of
    {source target : Vertex}
    (path : Path system source target)
    (sourceHasPeriod : HasPeriodAt system generator period source) :
    HasPeriodAt system generator period target := by
  induction path with
  | nil => exact sourceHasPeriod
  | cons edge tail inductionHypothesis =>
      exact inductionHypothesis
        (edge.hasPeriodAt_of system generator period sourceHasPeriod)

/-- A direct orbit-transport path from a selected-period source to a target
without that period is impossible. -/
theorem Path.false_of_sourcePeriod_of_targetNoPeriod
    {source target : Vertex}
    (path : Path system source target)
    (sourceHasPeriod : HasPeriodAt system generator period source)
    (targetHasNoPeriod : ¬ HasPeriodAt system generator period target) : False := by
  exact targetHasNoPeriod
    (path.hasPeriodAt_of system generator period sourceHasPeriod)

end OrbitTransport

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.LoopStabilizerPath
