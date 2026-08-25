# Schema v1 boundary

Schema `sparse-shadow/v1` has five tagged profile adapters. It does not assert
that the profiles are instances of one mathematical functor.

| adapter | observed shadow | action | recovered carrier | residual ambiguity | v1 state |
|---|---|---|---|---|---|
| `paper_i_orientation` | two five-valent orbital relations, antipodes, optional calibrated triangle | color-preserving vertex permutations preserving named relations | six-axis/conference carrier | free orientation `C2` unless calibrated | enabled |
| `paper_ii_trade` | signed strength-two trade and carrier metadata | declared matching/configuration permutation action | surviving matching configuration and sheet pair | unordered complementary sheets | gated |
| `paper_iii_four_shadow` | four aligned shadow channels | aligned-design action | marked operator carrier | marking/harmonic gap data | gated |
| `paper_iv_minimum_words` | minimum-word incidence shadow | point/word action compatible with incidence | `PG(2,13)`, conic, polarity | projective orbit | gated |
| `paper_v_chordal_conference` | chordal/conference incidence and signs | declared projective/switching action | chordal and conference cubic carrier | residual chordal-line `C2` torsor | gated |

Unknown fields are rejected. Vertices are numbered `0..n-1`; each named
undirected relation is a duplicate-free list of ordered-normalized pairs
`[min,max]`. Relation order is semantic and frozen. A canonical artifact
renumbers vertices, sorts relation pairs, and serializes compact JSON before
computing its BLAKE3 identity.

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
