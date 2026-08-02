# Lean certificates for the passant code over F13

This Lake package checks the finite leaves used by the human structural proof of the binary
incidence code of the passant lines of the standard conic `XZ-Y^2=0` over `ZMod 13`.  Its
computations record discovery and handle only bulk that has not admitted useful conceptual
compression; they are not the narrative proof.  The package depends on the reusable semantic
definitions in `RelativeConicArcs.PassantCodeQ13`.

The weight-ten certificate fixes the internal point `(1,0,2)`.  Seven isolated-profile shards
partition by the passant fibre containing three further support points.  Seven cycle-profile shards
partition the unordered pairs of secant-join neighbors by the first endpoint's coordinate index
modulo seven.  `PassantCodeQ13.WeightTen.Aggregate` verifies that these partitions cover both parity
profiles and that their syndrome sets are disjoint.

`PassantCodeQ13.Rank` checks binary row rank 42 for the displayed incidence matrix.
`PassantCodeQ13.SemanticTransports` supplies checked recovery and expansion maps for a
42-column basis and proves that this executable rank is `Module.finrank` of the semantic incidence
map. Rank-nullity therefore gives code dimension 36 in the aggregate gate. The tracked generator
`generate_rank_transport.py` reproduces `PassantCodeQ13.RankTransportData` byte for byte.
`PassantCodeQ13.AssociationAlgebra` checks the ranks and squaring identities of the four binary
elliptic relation matrices used by the orbit-spanning argument.  The minimum-word modules expand
one symmetric-stabilizer and three dihedral-stabilizer representatives into four disjoint
91-element kernel orbits, each of binary span rank 36.  The reconstruction leaf checks pair-color
recovery of passant joins and the zero-triple signatures of all 78 geometric rows.

The terminal theorems use native evaluation.  The axiom audit must therefore report the
declaration-local native-decision axioms emitted by the pinned Lean toolchain.  No hash is used as a
substitute for checking the incidence semantics or profile coverage.

The package does not prove that the two local parity profiles exhaust arbitrary weight-ten
codewords, prove that the four projective orbits
exhaust the complete weight-twelve layer, prove uniqueness of the recovered row family, or classify
all coordinate automorphisms.  These are explicit semantic boundaries, not computational claims.

From this package root, the public replay command is:

```sh
nix develop --command lake build PassantCodeQ13.Gates.Main PassantCodeQ13.Gates.AxiomAudit
```
