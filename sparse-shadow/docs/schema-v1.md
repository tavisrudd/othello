# Schema v1 boundary

Schema `sparse-shadow/v1` has five tagged profile adapters. It does not assert
that the profiles are instances of one mathematical functor.

This version names the input interchange schema. Canonical output uses
`sparse-shadow-canonical/v2`: v2 adds the verified point-stabilizer surface to
the earlier canonical wrapper. The independent canonical proof remains
`sparse-shadow-certificate/v1` because its eight-rule payload did not change.

| adapter | observed shadow | action | recovered carrier | residual ambiguity | v1 state |
|---|---|---|---|---|---|
| `paper_i_orientation` | two five-valent orbital relations, antipodes, optional calibrated triangle | color-preserving vertex permutations preserving named relations | six-axis/conference carrier | free orientation `C2` unless calibrated | enabled |
| `paper_ii_trade` | signed strength-two trade and carrier metadata | declared matching/configuration permutation action | surviving matching configuration and sheet pair | unordered complementary sheets | gated |
| `paper_iii_four_shadow` | reduced branch sextic plus one rational fibre, and the marked family of aligned four-sets | marked-vertex action | rational quadratic twist and two-graph/conference signing | rational square-class before the fibre; complement/global-negation `C2` before triangle calibration | gated |
| `paper_iv_minimum_words` | weighted pair section of the 78-coordinate minimum-support hypergraph | coordinate action preserving pair multiplicities | incidence/code, elliptic scheme, `PG(2,13)`, conic, polarity | ordered-frame/field-labeling `PGL2(13)` torsor | gated |
| `paper_v_chordal_conference` | retained Paper-II residue, outer involution, and optional selected chordal line | marked residue action | singular quartic, twelve points, six-axis carrier, chordal/conference companions | conference opposition `C2`; exact return only with the selected line | gated |

Unknown fields are rejected. Vertices are numbered `0..n-1`; each named
undirected relation is a duplicate-free list of ordered-normalized pairs
`[min,max]`. Relation order is semantic and frozen. A canonical artifact
renumbers vertices, sorts relation pairs, and serializes compact JSON before
computing its BLAKE3 identity. It reports the full automorphism order, a compact
generating set, vertex orbits, and the point stabilizer of the least
representative in each vertex orbit. Each stabilizer carries its own order,
generators, and vertex-orbit decomposition.
The committed Paper-I golden contract pins the stable summary of both
calibrated and uncalibrated canonical artifacts.

The optional Paper-I calibration is an increasing triple of distinct vertices
whose three pairs lie in `orbital_positive`. This is the schema realization of
the frozen calibrated triangle sign, not an arbitrary odd-cardinality marking.
The committed exhaustive census checks all 220 triples: precisely 20 are
admissible, and all 20 lie in one canonical orbit with automorphism order 6.
For the uncalibrated fixture, exchanging the two five-valent orbital payloads
has the same canonical identity and an independently replayed transporter. This
is the regression law for the residual orientation involution.

Source locators are validated provenance but are normalized to the adapter
identifier before canonical serialization. They cannot change mathematical
identity; relation names, action metadata, vertex data, and calibration remain
semantic and do participate.

The enabled engine supports permutation actions only. The gated profile schemas
already distinguish vertex-permutation from projective-semilinear actions and
require an exact field modulus, element encoding, matrices, and Frobenius powers.
Those witnesses cannot be enabled until their arithmetic and normalization are
implemented and independently replayed; the schema never silently converts them
to graph permutations.

Every gated profile also carries a frozen source locator and SHA-256, its
recovered-carrier name, an explicit ambiguity kind, optional odd calibration,
and collision artifacts for each minimality boundary it claims. An empty
collision list means that the artifact makes no minimality claim.

The Paper-I source locator is the C905 reconstruction-profile report, section
“Paper I: syndrome geometry and golden orientation,” itself a synthesis of the
frozen Paper-I theorem surfaces. The fixture encodes the twelve-point `A5` set:
the icosahedral adjacency relation and its distance-two mate are the two
five-valent orbitals, and the perfect matching is the antipodal relation. The
fixture is a schema test, not a new theorem export.

The four `fixtures/gated-*.json` artifacts are fail-closed schema fixtures.
Their `PENDING` source hashes and empty mathematical payloads are deliberate:
nearby evidence JSON files prove component claims but are not complete exported
shadows. A gate cannot be enabled by filling those placeholders from manuscript
prose or by treating a trust manifest as the missing mathematical export.
