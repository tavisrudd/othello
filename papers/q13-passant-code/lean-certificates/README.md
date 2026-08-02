# Lean certificates for the passant code over F13

This Lake package checks the finite leaves used by the binary incidence code of the passant lines
of the standard conic `XZ-Y^2=0` over `ZMod 13`.  It depends on the reusable semantic definitions
in `RelativeConicArcs.PassantCodeQ13`.

The weight-ten certificate fixes the internal point `(1,0,2)`.  Seven isolated-profile shards
partition by the passant fibre containing three further support points.  Seven cycle-profile shards
partition the unordered pairs of secant-join neighbors by the first endpoint's coordinate index
modulo seven.  `PassantCodeQ13.WeightTen.Aggregate` verifies that these partitions cover both parity
profiles and that their syndrome sets are disjoint.

The terminal theorems use native evaluation.  The axiom audit must therefore report the
declaration-local native-decision axioms emitted by the pinned Lean toolchain.  No hash is used as a
substitute for checking the incidence semantics or profile coverage.
