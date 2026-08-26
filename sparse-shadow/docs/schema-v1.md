# Schema v1 boundary

Schema `sparse-shadow/v1` has five tagged profile adapters. It does not assert
that the profiles are instances of one mathematical functor.

This version names the input interchange schema. Canonical output uses
`sparse-shadow-canonical/v2`: v2 adds the verified point-stabilizer surface to
the earlier canonical wrapper. The independent canonical proof remains
`sparse-shadow-certificate/v1` because its eight-rule payload did not change.
Paper-I reconstruction uses `sparse-shadow-reconstruction/v2`. Paper II uses
`sparse-shadow-paper-ii-reconstruction/v1`; Paper IV uses
`sparse-shadow-paper-iv-reconstruction/v1` with a typed full-plane carrier.
Paper V uses `sparse-shadow-paper-v-reconstruction/v1` with the marked
chordal/conference carrier and its finite-field verification reduction.

| adapter | observed shadow | action | recovered carrier | residual ambiguity | v1 state |
|---|---|---|---|---|---|
| `paper_i_orientation` | two five-valent orbital relations, antipodes, optional calibrated triangle | color-preserving vertex permutations preserving named relations | six-axis/conference carrier | free orientation `C2` unless calibrated | enabled |
| `paper_ii_trade` | 22 perfect matchings split into two signed 11-element sheets, with cubic odd calibration | declared `PGL2(11)` endpoint action | the H3 matching carrier and oriented sheet pair | orientation `C2`, killed by the cubic calibration | enabled |
| `paper_iii_four_shadow` | reduced branch sextic plus one rational fibre, and the marked family of aligned four-sets | marked-vertex action | rational quadratic twist and two-graph/conference signing | rational square-class before the fibre; complement/global-negation `C2` before triangle calibration | gated |
| `paper_iv_minimum_words` | weighted pair section of the 78-coordinate minimum-support hypergraph | coordinate action preserving pair multiplicities | incidence/code, elliptic scheme, `PG(2,13)`, conic, polarity | ordered-frame/field-labeling `PGL2(13)` torsor | enabled |
| `paper_v_chordal_conference` | signed six-axis residue, an order-four outer lift, and selected chordal line | full six-axis relabeling action | singular quartic, twelve points, six-axis carrier, chordal/conference companions | outer-coset `C2`, killed by the selected line | enabled |

Unknown fields are rejected at struct and tagged-enum boundaries, including
profile tags, actions, base fields, ambiguity kinds, and certificate outcomes.
The four source-gate fixtures have exact value-level parse/serialize round trips;
Paper IV's separate paper-owned export is enabled and fully replayed.
Paper II's separate paper-owned export is likewise enabled; its disabled fixture
remains the fail-closed schema example.
Paper V's paper-owned export additionally distinguishes the rational conference
matrix from its exact `F11` cubic and singular-locus verification data.
Vertices are numbered `0..n-1`; each named
undirected relation is a duplicate-free list of ordered-normalized pairs
`[min,max]`. Relation order is semantic and frozen. A canonical artifact
renumbers vertices, sorts relation pairs, and serializes compact JSON before
computing its BLAKE3 identity. It reports the full automorphism order, a compact
generating set, vertex orbits, and the point stabilizer of the least
representative in each vertex orbit. Each stabilizer carries its own order,
generators, and vertex-orbit decomposition.
The committed Paper-I golden contract pins the stable summary of both
calibrated and uncalibrated canonical artifacts and their recovered carriers.
Its `cli_stdout_blake3` map additionally freezes exact stdout bytes for the six
enabled validate, canonicalize, reconstruct, and equivalence invocations, so a
cross-build serialization change fails independently of semantic summaries.
The Paper-IV contract additionally freezes its 2,184-element automorphism
group, 3,901-node/2,184-leaf exhaustion, full projective reconstruction census,
and the independent nauty colored-incidence identity.

Canonical wrapper v2 uses two explicit coordinate bases:

| field | coordinate basis |
|---|---|
| `canonical` and the typed carrier's six `axes` | canonical vertices |
| `input_to_canonical` | map from raw input vertices to canonical vertices |
| `automorphism_generators`, `vertex_orbits`, and `point_stabilizers` | raw input vertices |
| certificate `automorphisms` and `input_to_canonical` | raw input vertices, with the latter mapping to canonical vertices |

Thus a consumer conjugates an input automorphism by `input_to_canonical` before
applying it to `canonical` or to recovered carrier axes. Point-stabilizer
representatives are likewise input labels, not canonical labels. A regression
test performs this conjugation for every emitted generator in both Paper-I
fixtures and requires the canonical shadow to remain exactly unchanged.

The optional Paper-I calibration is an increasing triple of distinct vertices
whose three pairs lie in `orbital_positive`. This is the schema realization of
the frozen calibrated triangle sign, not an arbitrary odd-cardinality marking.
The committed exhaustive census checks all 220 triples: precisely 20 are
admissible, and all 20 have one exact canonical payload with automorphism order
6. Every admitted triangle has an independently replayed transporter to a fixed
representative; the conclusion does not rely only on equal hashes.
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
`fixtures/SHA256SUMS` freezes the exact bytes of all four gates, both Paper-I
inputs, and the golden contract.
