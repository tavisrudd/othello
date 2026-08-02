# C761 concrete four-anchor automorphism transport

**Lane:** `clebsch`

**Date:** 2026-08-02

## Result

Every permutation of the 78 indexed internal points that preserves the six-valued polar relation
is one of the 2184 symmetric-square maps induced by the normalized invertible two-by-two matrices
over `ZMod 13`.  The formal proof now follows the human proof exactly:

1. the first three anchors lie in a regular projective orbit of ordered triples with relation
   pattern `(10,3,9)`;
2. the signature `(3,1,9)` relative to that triple forces the fourth anchor; and
3. the four-anchor signatures separate all 78 points.

The theorem exported to the paper is
`PassantCodeQ13.Gates.Main.ellipticSchemeAutomorphismsAreProjective`.  It identifies the
automorphisms of the polar-relation scheme.  The passage from automorphisms of the decoded
minimum-support hypergraph to polar-relation automorphisms remains the human concurrence argument,
and the claim map states that boundary explicitly.

## Formal and evidence surfaces

- `RelativeConicArcs.PassantCodeQ13.LogicalSpine.four_anchor_transport_rigidity` is the abstract
  symbolic closure for a concrete family of bijective transports.
- `PassantCodeQ13.Automorphisms.Base` fixes the four indexed anchors, normalized matrix action,
  relation-preservation predicate, triple domain, and signatures.
- `TripleOrbit`, `FourthAnchor`, and `Signatures` are separate bounded native leaves for the three
  finite inputs.
- `PassantCodeQ13.Automorphisms.Transport` performs only symbolic normalization and signature
  transport; it contains no native evaluation.
- `PassantCodeQ13.Gates.Main` exports the terminal, and `Gates.AxiomAudit` prints the actual axiom
  closure of every new leaf and the symbolic aggregate under the pinned toolchain.
- `verification/check_q13_tangent_code.py` remains the independent route.  It reconstructs the
  relation colors and performs a stabilizer-chain enumeration, obtaining exactly 2184
  automorphisms without importing the Lean definitions.

The manuscript now includes a compact proof-flow diagram

```text
regular (10,3,9) triple  ->  forced (3,1,9) fourth anchor  ->  separating signatures
```

immediately before the anchor count.  It adds no graphics dependency and remains legible at
publication size.

## Reproduction and validation

From the repository root, the independent replay is

```sh
cd papers/q13-passant-code
python3 verification/check_q13_tangent_code.py
```

and returns

```text
q=13 tangent-code replay: PASS (omega = 5, d = 12, 364 minimum words, 78 rows recovered, Aut = PGL(2,13))
```

`python3 verification/verify_evidence.py` passes the manifest, canonical and independent
weight-ten checks, full tangent-code replay, and semantic rank regeneration.  `make check` passes
the complete paper evidence gate, spacing lint, two XeLaTeX passes, warning scan, and seven-page
PDF.  The anchor diagram on page 5 and the revised trust-boundary paragraph on page 6 were also
inspected in rendered form.

The guarded formal runs were:

- shared symbolic gate: `run-20260802-105725-590b7835`, 13.40 seconds and 1,841,160 kB peak;
- exhaustive triple-orbit leaf: `run-20260802-110201-58570696`, 26:50.09 and 1,855,236 kB peak;
- final transport/Main/axiom aggregate: `run-20260802-112944-ae25784e`; Transport passed in
  3.83 seconds, Main in 1:39.58 with 2,082,680 kB peak, the axiom audit in 3.67 seconds, and the
  trace-only aggregate passed.

The load-bearing source hashes and byte counts are:

| source | bytes | SHA-256 |
|---|---:|---|
| `RelativeConicArcs/PassantCodeQ13/LogicalSpine.lean` | 13,995 | `21187c5ef1910baee55ea83b5e93dd91ddc609f5b8e3e9541ec9d4aafc16cf2f` |
| `Automorphisms/Base.lean` | 2,482 | `41d375441796ba2b9e56e53233742a2040f4c19655af56e2a2194fcd282ecc68` |
| `Automorphisms/TripleOrbit.lean` | 1,878 | `6ed6f94c63b8d71a1fc2421a9c65c835ba09ec60a3a213ad1832e4220f5a697b` |
| `Automorphisms/FourthAnchor.lean` | 596 | `3babe2cd2b6fc688f0aa20d9b809222bf7a7138587c787821827b511f6c15979` |
| `Automorphisms/Signatures.lean` | 549 | `80001e0a3725f2d016401b233b98bd3429512a61e235d28e9e5e0e6078ca5a83` |
| `Automorphisms/Transport.lean` | 7,030 | `8bb6a5ea40ed4e85dda6ecdc56f3ca5ff71ce88bfe813684b07db1cb11d6d6c6` |

The independent replay is tracked at 26,948 bytes with SHA-256
`49ff490110856dd0a613c76a83dbfb30df6fc2dbfaee27db5fd597f3c375f36d`, as recorded in
`verification/evidence_manifest.json`.

## Scope boundary

The formal theorem classifies automorphisms that preserve `rhoAt`; it does not yet formalize that
every minimum-support-hypergraph automorphism preserves the complete six-valued relation.  That
implication is proved in the manuscript by invariance of pair and triple concurrence.  This is an
explicit formal-coverage boundary, not a gap in the human theorem or in the independent replay.

## Mystery ledger

- **Why a fourth anchor? — settled.**  Three anchors normalize the projective action through the
  regular triple orbit; the fourth is the unique point with signature `(3,1,9)` and makes the full
  signature map injective.  The displayed diagram now exposes those two different jobs.
- **Could the exact projective action hide duplicate normalized matrices? — settled.**  The matrix
  list has length 2184 and its anchor-triple image has cardinality 2184, so the induced maps are
  distinct before the closure theorem is applied.
- **Minimum-support automorphism to polar-relation automorphism in Lean — open formal boundary.**
  The exact missing interface is concurrence equivariance plus transport of the six recovered
  colors.  It is not required for the honest partial formal coverage of Paper IV; release audit is
  the next owner of any decision to formalize it.

No unexplained mathematical feature remains in the concrete four-anchor classification.

## EJ+TT closeout

- **Essential judgment:** use a regular triple orbit and signature transport, rather than enumerate
  arbitrary coordinate permutations or formalize a quotient presentation of `PGL(2,13)`.
- **Truth tracking:** the Lean leaves check the three irreducible finite inputs, the symbolic theorem
  performs the closure, and the Python stabilizer-chain replay reaches the same order by a different
  route.
- **Cheap upgrade taken:** the manuscript diagram exposes the normalization/point-separation split,
  and the rendered page was inspected after the warning-free build.
- **Tao-style compression:** the 2184 projective maps are used only to certify one regular orbit and
  relation preservation; the proof never searches the full permutation group on 78 coordinates.

**Vibe check:** the final rigidity step now has the same clean causal shape in the paper, Lean, and
independent replay, with the sole narrower formal boundary stated rather than blurred.
