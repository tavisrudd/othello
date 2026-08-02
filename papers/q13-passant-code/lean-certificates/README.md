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
The shared `RelativeConicArcs.PassantCodeQ13.WeightEight` module derives saturation of the seven
base pencils from code membership, identifies the 42 semantic passant-join neighbors with the
three cyclic vertex orbits, checks that tangent holonomy is exactly the displayed adjacency, and
proves the five-clique bound.  Its terminal theorem excludes a normalized weight-eight word once
the classical arc/tangent lemma supplies pairwise passant joins and tangent holonomy one.
The shared `RelativeConicArcs.PassantCodeQ13.WeightTen` module then treats an arbitrary supported
point of an arbitrary weight-ten word: its seven passant fibres are odd, the complementary joins
are secants, and the support partition forces the isolated `(3,1^6;0)` or cycle `(1^7;2)` profile.
`PassantCodeQ13.AssociationAlgebra` checks the ranks and encoded squaring identities of the four
binary elliptic relation matrices used by the orbit-spanning argument.
`PassantCodeQ13.AssociationTransport` proves once that Boolean parity multiplication is ordinary
matrix multiplication over `ZMod 2`; four one-product relation shards and four orbit shards then feed the concrete
squares and Gram/kernel identities to the computation-free abstract association-kernel spine.
The minimum-word modules expand
one symmetric-stabilizer and three dihedral-stabilizer representatives into four disjoint
91-element kernel orbits, each of binary span rank 36.  At a fixed point, the order-28 point
stabilizer acts transitively on each 14-support slice.  The reconstruction leaf checks pair-color
recovery of passant joins.  Seven first-index residue leaves check every four-subset of the local
extension pool of each of the 4,186 canonically ordered admissible three-point seeds; the largest
non-row pool has ten points.  A symbolic
coverage argument then proves that the intrinsic seven-clique test recovers exactly the 78
geometric rows; the independent replay instead enumerates all 1716 passant seven-cliques.

The terminal theorems use native evaluation.  The axiom audit must therefore report the
declaration-local native-decision axioms emitted by the pinned Lean toolchain.  No hash is used as a
substitute for checking the incidence semantics or profile coverage.

The package does not transport the fixed-point exhaustion to equality of the four projective orbits
with the complete weight-twelve layer, or classify all coordinate automorphisms.  These are
explicit semantic boundaries, not computational claims.

From this package root, the public replay command is:

```sh
nix develop --command lake build PassantCodeQ13.Gates.Main PassantCodeQ13.Gates.AxiomAudit
```
