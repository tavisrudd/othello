import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.FixedPhaseReader
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.LawfulReaderIndex
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ComponentReader
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.CrossedEdgeComposition
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MonodromyImage
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.CanVariationCoverage
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.CanVariationCoordinates
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ProjectedVariation
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ModelCrossedCoordinates
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.SplitCrossedCoordinates
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RangeBaseChange
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.SemilinearVariation
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.VariationNormalFactor
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ResonantWindowRank
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MarkedMonodromyDiagram
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MarkedLocalSystem
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.SelectedLocalSystemReader
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.DescentPacket
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.TwoLayerDescentPacket
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.HorizontalReader
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.TraitHorizontalReader
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ProvenanceEdge

/-!
# Reviewer interface for the cubic-stabilization irrationality paper

The imported modules expose the typed fixed-phase reader interface, its
componentwise realization, the crossed-row algebra, and the closed-fibre
vanishing, composition, monodromy-image functoriality, and map-indexed
provenance witnesses. Projected monodromy variation is derived from a single
marked horizontal comparison of the common nearby-cycle spaces; the reduced
reader derives the model row from vector crossed coordinates and consumes
that comparison against an externally supplied actual receiver. Invertibility
of target monodromy also yields a kernel sieve for the crossed and moving
coordinate maps; the scalar crossed-row law alone does not construct the
model. A linear retraction of the combined crossed and moving map does construct
one explicit model, using an incoming shear and a target involution; an
integral equivalence realizing the full upper-triangular map supplies such a
retraction. Semilinear specialization transports the directed variation
without asserting that tensor
product commutes with monodromy-image formation. Vanishing transport also
allows the marked row to be preserved up to an arbitrary target scalar. The
direct scalar-normal-form consumer only requires the trait identity
`r (1 - T_j) (1 - T_i) = a lambda`; when `a` specializes to zero, this kills
the projected variation after incoming-image-spanning specialization. A
one-sided factorization `v c = 1 - T_i` and a row formula on variation values
imply this ambient identity. Neither the second can/variation triangle nor
coverage of the full variation image is needed for this conclusion. The
alternating coefficient over all nonempty masks of a resonant window
transition is also checked to equal one; this is the finite rank-preservation
identity for the source covector. The same law survives transport through
model and actual operator-diagram
equivalences with row factors when their factors satisfy the displayed
multiplicative compatibility. The can/variation factorization supplies
another coverage theorem: if can covers
the packet modulo the kernel of variation, the ambient monodromy image equals
the variation image. Packet-defect coverage modulo that kernel, full defect
surjectivity, and in finite dimension absence of packet fixed vectors are
successively stronger providers. A separate constructor attaches the
can/variation maps, the target crossed-coordinate equation, and the three row
restrictions to one externally supplied fixed-phase receiver; vanishing of the
crossed normal then kills that receiver's projected variation on its whole
incoming image. The sign convention is fixed by requiring both can/variation
composites to be identity minus monodromy. A source-facing form derives the
target component equations from one window comparison square and one window
row restriction; a common scalar row factor is also allowed for the one-way
vanishing theorem. The two monodromies and rank row form one endpoint-indexed
diagram, so a single naturality law supplies both
operator intertwining equations as one coherent package. More generally, the
stronger datum of a horizontal morphism of marked based-loop representations
supplies every selected directed two-loop diagram. The selected-local-system
adapter records the two required vertical identifications:
the loops and row selected from the trait representation must equal the model
diagram, and those selected from the fibre representation must equal the
externally supplied actual diagram. With these identifications, the global
horizontal morphism constructs the trait reader. Literal equality of frames
is unnecessary: marked gauge equivalences that conjugate both monodromies and
transport the row yield the same construction and preserve ambient
surjectivity. An explicit range base-change certificate gives a stronger form of
applications that require an image equivalence. The trait-horizontal reader
composes this specialization law with the crossed-coordinate normal-factor
calculation. Environment-indexed endpoints compute the quantum path and share
the phase, character, and
direction, so their compatibility certificate is derived rather than chosen.
At the set level, a regular descent orbit is distinguished from three fixed
points, while a unary correction is fixed only under an explicit stability
hypothesis for its singleton summand.  With two independent actions, a regular
external coordinate cannot be equivariantly identified with any packet on
which the external factor acts trivially, regardless of the internal action;
the obstruction persists after adjoining external-trivial corrections on the
source side.
-/
