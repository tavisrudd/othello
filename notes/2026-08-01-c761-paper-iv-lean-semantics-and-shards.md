# C761 Paper IV q13 Lean semantics and certificate shards

Date: 2026-08-01

## Outcome

Paper IV is led by a human structural proof.  Computation records discovery
and is retained only where finite bulk has not admitted conceptual
compression.  Within that hierarchy, Paper IV now has two green Lean
supporting surfaces.  The shared
`RelativeConicArcs.PassantCodeQ13` modules define the normalized conic,
internal/passant geometry, incidence code, rank-nullity interface, tangent
graph and its normalized semantic transport, arbitrary-word weight-ten pencil profiles, association relations, and reconstruction interfaces.  The standalone
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
- `WeightEight.lean`: saturation of the seven base pencils from code row parity, the conic-secant
  tangent product, the semantic identification of all 42 base neighbors with the cyclic graph, its
  70 four-cliques and unique extensions, and the conditional exclusion theorem after the classical
  arc/tangent lemma supplies pairwise passant joins and holonomy one.
- `WeightTen.lean`: the seven-line passant pencil through an arbitrary supported point, the exact
  secant/passant dichotomy, odd row fibres, the support partition, and transport of every
  weight-ten word to the isolated `(3,1^6;0)` or cycle `(1^7;2)` profile.
- `AssociationAlgebra.lean`: the rho/elliptic relation semantics and the
  concurrence-recovery interface.
- `Reconstruction.lean`: passant joins, reconstructed incidence rows, the
  minimum-layer certificate record, and the coordinate-automorphism
  identification interface.
- `LogicalSpine.lean`: proof-only reductions for the seven-companion lower
  bound, `s=0 or 2`, the exact `(3,1,1,1,1,1,1;0)` and
  `(1,1,1,1,1,1,1;2)` fibre multiplicities, association-kernel rigidity and
  surjectivity, `im B = ker A`, orbit spanning from a factorization `B=NᵀN`,
  and the abstract four-anchor closure.  It contains no native evaluation.
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

The deeper think-through pass closed a previously loose point in item 3:
Lean now proves that seven positive fibres of total size seven are all
singletons, and that seven positive odd fibres of total size nine are exactly
one triple and six singletons.  Thus the finite leaves begin only after the
two displayed profiles have been logically derived.

## Further compression from the extra-juice passes

Execution sharding and mathematical case splitting are different layers.
The following reductions should govern the next Lean pass:

1. The fourteen weight-ten files may remain as parallel build shards, but the
   theorem has only two mathematical leaves.  Prove stabilizer equivariance
   of the exceptional-fibre and endpoint-residue partitions, then transport
   one representative isolated leaf and one representative cycle leaf.  Do
   not remove aggregate dependencies until the implemented partitions are
   proved equivariant.
2. The seventy tangent four-cliques are fourteen translates of the five
   representatives printed in the manuscript.  Prove simultaneous
   `Z/14`-translation invariance, classify the five representative orbits,
   and retain only those five checks as load-bearing leaves.  The full
   enumeration remains useful corroboration.
3. The association deduction is now complete at the abstract level:
   squaring identities imply injectivity on `ker A`, finite dimension gives
   surjectivity, hence `im B=ker A`, and `B=NᵀN` with orbit rows in the code
   forces those rows to span.  The remaining work is only to identify the
   executable relation and Gram matrices with these semantic linear maps.
4. Minimum-layer exhaustion should use the 56 supports through one fixed
   point, their four disjoint 14-element orbit slices, transitivity, and the
   double count `56*78/12=364`.  The finite leaf is the fixed-point slice,
   not a second global enumeration.
5. Pair and triple concurrence should be proved equivariant under every
   support-hypergraph automorphism.  Once the projective action bridge is in
   place, row comparison can descend from all 78 rows to one representative.
6. Automorphism classification has exactly three finite inputs: simple
   transitivity on triples of relation pattern `(10,3,9)`, uniqueness of the
   fourth anchor with signature `(3,1,9)`, and separation by four-anchor
   signatures.  The abstract closure is already proved, so no full
   coordinate-permutation search is needed.

After those transports, the plausibly irreducible finite bulk is two
representative weight-ten disjointness checks, five tangent representatives,
the fixed-point weight-twelve exhaustion, the small relation/Gram tables, and
the concrete fourth-anchor uniqueness/signature checks.  Rank elimination,
full orbit generation, and all-row reconstruction remain valuable independent
evidence and discovery provenance without being the narrative proof.

## Interface declarations that are not yet proof coverage

- `MinimumLayerCertificate.rows_recovered` is an exact required field; its
  accessor theorem does not itself prove reconstruction.
- `CoordinateAutomorphismIdentification.preserves_iff_in_range` freezes the
  desired output type but takes the classification as input.
- Native rank 36 for each orbit verifies spanning numerically but does not
  instantiate the human association-algebra mechanism.

These interfaces remain useful, but the gate and claim map must not count
them as completed semantic transports.

## Validation

- Normalized weight-eight semantic transport, shared aggregate gate, and axiom audit:
  `/home/tavis/.cache/othello-lean-build/run-20260802-024309-4d173679`.
- Standalone aggregate and axiom audit against the updated shared semantic dependency:
  `/home/tavis/.cache/othello-lean-build/run-20260802-024415-2236232f`.
- Semantic rank transport, aggregate gate, and axiom audit:
  `/home/tavis/.cache/othello-lean-build/run-20260802-020741-d62d2530`.
- Arbitrary weight-ten profile transport, shared aggregate gate, exact-target confirmation, and
  axiom audit: `/home/tavis/.cache/othello-lean-build/run-20260802-032342-cfd6684b`; final audit
  including the secant/passant dichotomy:
  `/home/tavis/.cache/othello-lean-build/run-20260802-033104-9fc2935a`.
- Paper-owned aggregate and axiom audit after importing the arbitrary-word transport:
  `/home/tavis/.cache/othello-lean-build/run-20260802-032759-c8e80a89`.
- `python3 generate_rank_transport.py --check`: byte-identical recovery and expansion data green.
- Shared exact gate and audit:
  `/home/tavis/.cache/othello-lean-build/run-20260802-005420-71bb12da`.
- Logical-spine extension: direct pinned build of
  `RelativeConicArcs.Gates.PassantCodeQ13` and its axiom audit green; the new
  secant-count, exact fibre-profile, association, range/factorization, and
  anchor deductions have no native-decision axiom.
- Standalone full shard run:
  `/home/tavis/.cache/othello-lean-build/run-20260802-004847-bc341bd6`.
- Standalone final gate and audit:
  `/home/tavis/.cache/othello-lean-build/run-20260802-005551-9fa98dbc`.
- `python3 verify_evidence.py`: canonical hash, independent replay, and full
  q13 replay green (`omega=5`, `d=12`, 364 minimum words, 78 rows, automorphism
  group `PGL(2,13)`).
- `make check`: warning-free six-page PDF, 79,966 bytes.

The axiom audits show only Lean's standard `propext`, `Classical.choice`, and
`Quot.sound`, together with declaration-local axioms generated by
`native_decide` for the finite terminal checks.  There are no opaque axioms or
`sorry` declarations.

## Exact remaining formal boundary

The first transport is now closed: an explicit 42-column basis, checked left inverse, and checked
expansion of all 78 columns prove that the executable elimination computes `Module.finrank` of the
semantic incidence-map range. Rank-nullity then gives code dimension 36.  The second transport is
also closed: semantic row parity saturates the seven base pencils, cyclic coordinates enumerate
the 42 passant-join neighbors exactly, the six difference sets agree with passant join plus tangent
holonomy one, and unique extension forces clique size at most five.  The formal theorem takes the
classical arc/tangent lemma's pairwise-passant and holonomy-one conclusion as its named geometric
input.  The third transport is now closed: for an arbitrary weight-ten codeword and any supported
point, the seven semantic passant fibres are odd, their complement is exactly the secant-neighbor
set, and the support partition forces either `(3,1^6;0)` or `(1^7;2)`.  The following four items
remain inside C761 rather than becoming successor mysteries:

1. prove that the four fixed-point orbits exhaust the entire weight-twelve
   layer;
2. connect the concrete relation matrices and orbit Gram identities to the
   proved abstract association-kernel spine;
3. prove uniqueness of the reconstructed 78-row family;
4. connect the regular triple orbit, forced fourth anchor, and separating
   signatures to the proved abstract four-anchor closure.

## Extra-juice closeout and mystery ledger

The semantic rank transport is now complete.  Its deterministic generator, checked left inverse,
all-column expansion, semantic span equality, rank-nullity conclusion, and axiom-audited aggregate
close the first formal boundary without trusting the generator for theorem correctness.  The first
42 displayed columns happen to form the selected basis; this is an ordering-dependent certificate
convenience and carries no geometric invariance claim.

The weight-eight transport is now complete at its honest formal boundary.  It formalizes the code
row-saturation step, the exact normalized conic-to-cyclic-graph correspondence, and the
unique-extension contradiction.  Segre's lemma of tangents and the identification of the support's
combinatorial tangents with the conic secants remain the explicitly cited classical input rather
than a hidden certificate assumption.  The axiom audit exposes only the expected finite native
terminals plus Lean's standard logical axioms.

The arbitrary weight-ten profile transport is now complete.  It quantifies over every word and
every supported base point, identifies the seven actual passant lines through that point, proves
their support fibres odd from the code row equations, and partitions the other nine support points
into passant fibres and secant neighbors.  The two logical profile lemmas then give precisely the
isolated and cycle inputs used by the paper-owned certificate shards.  Its axiom audit exposes
Lean's standard logical axioms and the bounded native checks for the seven-line pencil, joining-line
uniqueness, and the two-element coefficient field.

The other cheap high-value upgrades are complete: exact rank and association leaves,
projective orbit shards, precomputed cycle syndromes, a precise manuscript
trust statement, the abstract `im B=ker A` and orbit-factorization spanning
chain, and an axiom-audited aggregate gate.  Fourteen execution shards are not
fourteen mathematical cases, and full enumerations are now explicitly
corroboration wherever symmetry transport can reduce them.  No new
mathematical mystery appeared.  The remaining work is exactly the four
semantic transports above plus the ordinary release audit and publication
steps.

**EJ+TT closeout.**  The cheap strengthening was to derive the clique bound logically from the
70-member unique-extension certificate instead of adding a second six-clique enumeration.  The
formal transport now exposes each change of language: code row sums, saturated base pencils,
semantic conic-secant products, cyclic vertex coordinates, and finite unique closure.  The Tao-style
question is whether the six difference sets have a uniform torus explanation.  C761 needs only the
exact q13 correspondence proved here; a uniform explanation belongs to C756 and is not a Paper-IV
release gate.  The paper and public verification guide now name the exact terminal declaration,
`RelativeConicArcs.Gates.PassantCodeQ13.weightEight_semantic_transport`, so the trust claim has a
stable theorem-level locator rather than only a module-level description.

The weight-ten EJ+TT pass added the cheap semantic strengthening that the complement of passant
join is exactly conic-secant join for distinct internal points; thus “secant neighbor” is a checked
geometric term rather than a name for a Boolean complement.  It also carries the arbitrary-word
theorem through the paper-owned aggregate, axiom audit, verification guide, claim map, and
manuscript trust paragraph.  The Tao-style compression is the support partition itself: seven odd
fibres plus the secant complement leave only the two displayed profiles, so no word or support
enumeration belongs in this transport.  This theorem reduces arbitrary words to the two profile
shapes; the paper-owned fixed-base disjointness shards remain the separate finite leaves and the
formal aggregate still does not claim the complete minimum-distance theorem.

**Mystery ledger.**

| feature | status | exact evidence gap or owner |
|---|---|---|
| first 42 incidence columns form the chosen basis | settled as an ordering-dependent certificate fact | no geometric invariance claim |
| normalized weight-eight semantic transport | settled | `RelativeConicArcs.Gates.PassantCodeQ13.weightEight_semantic_transport`; Segre's lemma and projective normalization remain explicit classical inputs |
| arbitrary weight-ten profile transport | settled | `RelativeConicArcs.Gates.PassantCodeQ13.arbitrary_weightTen_profile_transport`; the two paper-owned disjointness aggregates remain the finite terminal leaves |
| unique closure of the q13 tangent graph | settled exactly | finite q13 native terminals; no second clique enumeration |
| uniform source of the six cyclic difference sets | outside C761 | C756 owns any all-field torus explanation |
| remaining Paper-IV formal seams | open and fully enumerated | the four transports in the preceding section |

No further C761-owned mathematical mystery arose in the weight-eight or weight-ten profile passes.
