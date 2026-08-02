# C761 Paper IV q13 Lean semantics and certificate shards

Date: 2026-08-01

## Outcome

Paper IV is led by a human structural proof.  Computation records discovery
and is retained only where finite bulk has not admitted conceptual
compression.  Within that hierarchy, Paper IV now has two green Lean
supporting surfaces.  The shared
`RelativeConicArcs.PassantCodeQ13` modules define the normalized conic,
internal/passant geometry, incidence code, rank-nullity interface, tangent
graph, association relations, and reconstruction interfaces.  The standalone
paper-owned package evaluates the irreducibly finite q13 leaves in small,
auditable shards.  The semantic modules prove the logical spine and the
shards check its terminal leaves; neither replaces the human proof or licenses
a claim that the complete main theorem is Lean-proved.

## Shared semantic modules

- `Geometry.lean`: normalized points of `PG(2,13)`, conic polarity,
  internal/passant predicates, incidence, the code, and native cardinalities
  `183`, `78`, and `78`, with list/finset bridges.
- `Rank.lean`: the concrete incidence map, the rank-42 certificate interface,
  and the symbolic rank-nullity conclusion `finrank C = 36`.
- `WeightEight.lean`: the 42-vertex cyclic tangent graph, its 70 four-cliques,
  unique extensions, 14 five-cliques, and maximality checks.
- `AssociationAlgebra.lean`: the rho/elliptic relation semantics and the
  concurrence-recovery interface.
- `Reconstruction.lean`: passant joins, reconstructed incidence rows, the
  minimum-layer certificate record, and the coordinate-automorphism
  identification interface.
- `LogicalSpine.lean`: proof-only reductions for the seven-companion lower
  bound, the two weight-ten pencil profiles, association-kernel rigidity and
  surjectivity, and the abstract four-anchor closure.  It contains no native
  evaluation.
- `Gates/PassantCodeQ13.lean` and `PassantCodeQ13AxiomAudit.lean`: aggregate
  coverage and explicit trust audit.

## Paper-owned certificate structure

The package under `papers/q13-passant-code/lean-certificates/` uses direct
normalized conic geometry and 78-bit natural-number syndromes.

- Weight ten is reduced once to the isolated and cycle profiles.  Each profile
  is split into seven independent leaves: fibres `0`--`6` for the isolated
  case and first-endpoint residues `0`--`6` for the cycle case.  The light
  aggregate theorem joins all fourteen leaves and checks the exact partition.
- Minimum words use four displayed symmetric-square `PGL(2,13)` orbits.  Each
  orbit has 91 distinct kernel words and span rank 36; the three dihedral
  orbits are pairwise disjoint, so their union with the `S4` orbit has size
  364.
- Pair concurrence recovers the passant join, and the 78 geometric rows have
  the certified seven-point zero-triple signatures.
- The rank leaf checks exact binary row rank 42.
- The association leaf checks relation ranks `42,36,36,36`,
  `A0^2 = I + A9 + A10 + A12`, and the squaring cycle
  `A9^2=A10`, `A10^2=A12`, `A12^2=A9`.

The cycle leaves precompute 1,296 tail syndromes and pair syndromes.  This is
the main computational compression: it preserves the exact domain while
avoiding repeated evaluation inside each shard.

## Structural compression of the human proof

The proof is shortest when treated as a dependency graph rather than as one
large enumeration:

1. Rank is `rank(H)=42` followed by rank-nullity, rather than a second direct
   dimension enumeration.
2. Weight eight passes through the tangent-product graph: 70 four-cliques
   extend to exactly 14 maximal five-cliques.
3. One parity/pencil lemma reduces weight ten to two local profiles; symmetry
   then yields fourteen small terminal leaves.
4. The minimum layer is generated from four representatives and
   orbit-stabilizer data rather than listing 364 supports as primary proof
   objects.
5. Orbit spanning is compressed by the association-algebra squaring cycle.
6. Reconstruction factors through pair concurrence to passants and then
   zero-triple signatures to rows.
7. Automorphism rigidity should be closed by a regular triple orbit, a forced
   fourth anchor, and the recovered signatures, not by searching all
   coordinate permutations.

This is the useful Tao-style compression: the invariant reductions are the
proof, while native evaluation records discovery and checks only finite
terminal nodes that remain uncompressible.

## Validation

- Shared exact gate and audit:
  `/home/tavis/.cache/othello-lean-build/run-20260802-005420-71bb12da`.
- Logical-spine extension: direct pinned build of
  `RelativeConicArcs.Gates.PassantCodeQ13` and its axiom audit green; the new
  profile, association, and anchor deductions have no native-decision axiom.
- Standalone full shard run:
  `/home/tavis/.cache/othello-lean-build/run-20260802-004847-bc341bd6`.
- Standalone final gate and audit:
  `/home/tavis/.cache/othello-lean-build/run-20260802-005551-9fa98dbc`.
- `python3 verify_evidence.py`: canonical hash, independent replay, and full
  q13 replay green (`omega=5`, `d=12`, 364 minimum words, 78 rows, automorphism
  group `PGL(2,13)`).
- `make check`: warning-free six-page PDF, 76,812 bytes.

The axiom audits show only Lean's standard `propext`, `Classical.choice`, and
`Quot.sound`, together with declaration-local axioms generated by
`native_decide` for the finite terminal checks.  There are no opaque axioms or
`sorry` declarations.

## Exact remaining formal boundary

All seven items remain inside C761 rather than becoming successor mysteries:

1. prove that the bit-row rank evaluator computes `Module.finrank` of the
   semantic incidence map;
2. formalize transport from a weight-eight word through the arc/tangent lemma
   to a seven-clique in the concrete tangent graph;
3. formalize transport from an arbitrary weight-ten codeword to the two
   parity profiles;
4. prove that the four fixed-point orbits exhaust the entire weight-twelve
   layer;
5. connect the concrete relation matrices and orbit Gram identities to the
   proved abstract association-kernel spine;
6. prove uniqueness of the reconstructed 78-row family;
7. connect the regular triple orbit, forced fourth anchor, and separating
   signatures to the proved abstract four-anchor closure.

## EJ+TT closeout and mystery ledger

The cheap high-value upgrades are complete: exact rank and association leaves,
projective orbit shards, precomputed cycle syndromes, a precise manuscript
trust statement, and an axiom-audited aggregate gate.  No new mathematical
mystery appeared.  The remaining work is exactly the seven semantic transports
above plus the ordinary release audit and publication steps.
