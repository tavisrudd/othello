# Lean companion to the cubic-stabilization irrationality paper

This is a paper-local Mathlib package. Its top-level namespace is

```text
TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality
```

and its reviewer-facing entry point is

```text
TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.PaperInterface
```

The modules isolate the fixed-phase identification interface. Lean checks the
crossed-row algebra, endpoint-indexed path syntax, monodromy-image
functoriality, and naturality of the directed projected variation. Vector
crossed-coordinate equations derive the model row reading. The reduced
horizontal reader proves that one marked comparison intertwining the two
monodromies transports model-side vanishing to an externally supplied actual
receiver when its induced incoming-image map is surjective.
The model construction is split into three separately inhabitable capability
records: incoming-image realization, target vector coordinates, and scalar row
coordinates. Only their assembly yields the full crossed-coordinate model.
The trait-level module proves the weaker specialization law actually consumed
by the vanishing argument: pointwise specialized variation commutes with a
marked semilinear comparison, so a normal-factor reading whose normal maps to
zero kills the fibre variation without asserting a tensor-product description
of the image packet.
The two named monodromies and the row form one endpoint-indexed diagram. A
single naturality field packages both intertwining equations; this is the same
mathematical input as the two equations in the semilinear-specialization
record. When the stronger datum of a horizontal morphism of full based-loop
representations is available, selecting loop classes constructs that diagram
morphism uniformly for every directed comparison.
The selected-local-system adapter makes the required vertical identifications
explicit: the pair selected from the trait representation must be the crossed
coordinate model diagram, and the pair selected from the fibre representation
must be the supplied actual fixed-phase diagram. With those two identifications
and ambient surjectivity, the global horizontal morphism constructs the full
trait-horizontal reader.
The same construction accepts marked gauge equivalences instead of literal
equality of frames. Each equivalence conjugates both selected monodromies and
transports the scalar row; the global semilinear map is transported through
the two gauges. Ambient surjectivity is invariant under this transport.
The horizontal morphism carries an explicit homomorphism between the trait and
fibre loop groups, so ramified loop reindexing is not identified with equality.
An endpoint-loop assignment can be constructed from the endpoint's QDM/deck
path and one supplied path-to-loop interpretation, eliminating per-edge loop
choice relative to that interpretation.
Common outputs carry a dependent provenance witness indexed by their actual
value: marking an output as moving-produced requires a moving source whose
crossed image is that value.
Environment-indexed endpoints compute the quantum path from the chamber path
and share their phase, character, and direction as type parameters, so those
compatibility equations are obtained by construction.
The descent-packet module separately checks the elementary equivariant
distinction between one regular orbit and three fixed points. It also makes the
load-bearing qualification explicit: a one-element correction is fixed only
when its singleton is stable under the supplied descent action. A unary outer
constructor otherwise retains the full action on its inner packet.

The geometric comparison with the actual QDM packet remains an explicit
inhabited-structure proposition. In particular, the package does not assume
that monodromy-image formation commutes with specialization. An application
may provide a marked semilinear comparison whose induced incoming image spans
the fibre packet. An explicit range base-change certificate is a stronger
implementation of that coverage condition; the monodromy and row compatibility
remain separate data.
Ambient surjectivity is another sufficient implementation: it formally makes
the induced incoming image surjective, hence spanning. The constructor
`TraitHorizontalReader.Reader.ofSurjective` packages that specialization.
Exact row normalization is not needed for vanishing. The scaled semilinear
reader permits the actual row to pull back to any target-scalar multiple of the
specialized model row; projected variation acquires the same factor, so a
normal specializing to zero still kills it.
For a whole based-loop representation, operator-diagram equivalences with row
factors on the model and actual sides are also accepted: their factors `alpha`
and `beta` need only
satisfy `beta = c * specialize alpha` for the residual row factor `c`. No
division by either row factor occurs.

The algebraic model has a compact sufficient constructor. If the combined
crossed and moving map `(B,D)` admits a linear retraction, an explicit incoming
shear and target involution construct every crossed-coordinate field. An
integral linear equivalence realizing the full upper-triangular edge supplies
such a retraction. This condition is sufficient, not necessary, and generic
invertibility alone does not imply it over a trait ring. Because this target
operator is an involution, an actual comparison using this constructor must
separately justify involutivity on the covered target packet.

Incoming-image coverage also has a can/variation implementation. If the two
composites are the identity-minus-monodromy operators on the ambient and
packet modules, and can covers the packet modulo the kernel of variation, the
ambient monodromy image is exactly the variation image. Packet-defect coverage
modulo that kernel and full packet-defect surjectivity are stronger; in finite
dimension, absence of packet fixed vectors implies full surjectivity. The
`FixedReceiverCertificate` attaches these maps, the target crossed-coordinate
equation, and the three row restrictions to one externally supplied
fixed-phase receiver. If the crossed normal vanishes, its projected variation
vanishes on the whole incoming image. This avoids both a manufactured target
operator and an image/base-change isomorphism; identifying the supplied
certificate with the intended geometric packet remains part of the input.
The source-facing `FixedReceiverWindowCertificate` compresses the target
components to one window map: it asks for the single square
`T_j * v_i = j_+ * (B,D)` and one target window-row restriction. Its scaled
variant permits one common scalar on the source and target window rows; no
unit hypothesis is needed for the forward zero conclusion.

`PaperInterface.lean` is the reviewer-facing aggregate.  The companion
`Verification/AxiomAudit.lean` prints the axioms of every exported terminal in
this comparison package.
