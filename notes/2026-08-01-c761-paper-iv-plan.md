# C761 — Paper IV infrastructure, proof, and release plan

**Lane:** `clebsch`

**Date:** 2026-08-01

## Decision

Paper IV is a standalone coding and finite-geometry paper, not a computational
appendix to Paper I. Its memorable theorem is reconstruction: the minimum
words of one binary incidence code recover the conic's passant geometry and
its full projective symmetry. The parameters `[78,36,12]_2` provide the front
door; reconstruction is the reason for the paper.

Working title:

> *A binary [78,36,12] code from the passant lines of a conic over F13*

The Roman numeral is a restrained program mark. The title and abstract remain
independently intelligible, and no repeated series epigraph is used.

## Exposition spine

1. Define the conic, internal points, passant lines, polarity, incidence
   matrix `M`, and code `K = ker M`.
2. State one principal theorem: parameters, the 364-word minimum layer, four
   orbits, orbit spanning, geometric reconstruction, and automorphism group.
3. Prove `d=12` in causal order: parity lower bound; tangent-product reduction
   and five-row clique closure for weight eight; exhaustive pencil profiles
   and syndrome certificates for weight ten; explicit weight-twelve witness.
4. Classify the minimum layer from four orbit representatives and exact
   concurrence profiles.
5. Explain the result structurally: the binary elliptic association algebra
   proves every orbit spans, and four anchors prove the automorphism group.
6. End with the reconstruction lesson, not the verification apparatus or the
   neighboring all-k conjecture.

Target length is 14--18 pages including verification and references. Exact
support lists, large tables, hashes, and commands belong in the artifact.

## Theorem ownership and public-version policy

Paper IV owns the full q13 code theorem beginning with its first posting.
Paper I may retain a one-paragraph statement explaining why the theorem arose
in the conic-filling boundary. Its computational companion should receive a
forward public version replacing the full proof by a precise summary and
Paper-IV citation. Previously released versions remain immutable historical
records and are not rewritten.

Paper IV cites Paper I for motivation only. No proof step imports Paper I, an
internal report, or a private repository.

## Human and formal proof architecture

The desired Lean endpoint is the whole principal theorem, not an assortment
of nearby finite facts. Formalization follows the human dependency graph:

| layer | human mechanism | Lean target |
|---|---|---|
| general setup | conic polarity and binary incidence code | reusable `ConicPassantCode` definitions and incidence lemmas |
| dimension | published formula plus direct rank check | exact rank theorem for the q13 incidence matrix |
| weight 8 | parity, saturated pencils, tangent product, cyclic clique closure | formal reduction plus kernel-checked five-row closure |
| weight 10 | two exhaustive pencil profiles | proved coverage maps plus two sharded syndrome-disjointness certificates |
| weight 12 | explicit dihedral support | kernel-checked witness and syndrome equality |
| 364 words | four projective orbits | orbit generation, disjointness, and exhaustion certificates |
| spanning | mod-two association-algebra identities | symbolic matrix proof with finite intersection-number leaves |
| reconstruction | pair/triple concurrence and zero-triple cliques | formal recovery maps and uniqueness theorem |
| automorphisms | regular triple orbit and fourth anchor | formal stabilizer reduction plus finite signature uniqueness |

The shared `finitegeom` library owns general definitions and symbolic
arguments. A standalone q13 certificate repository owns generated finite
leaves and its light aggregate. Paper IV pins both revisions and archives
them with one release manifest. One semantic gate,
`RelativeConicArcs.Gates.PassantCodeQ13`, is the manuscript-facing exit.

No task ID, paper section number, internal report, or agent terminology enters
the Lean API. Generated shards are named by mathematical partitions such as
the isolated and cycle weight-ten profiles. Every public declaration receives
a self-contained mathematical docstring and every externally generated table
states its generator, schema, finite domain, and checking route.

## Exact evidence migration

The first extraction preserves the existing Paper-I files byte-for-byte and
records their source commit and hashes. Subsequent edits occur only in the
Paper-IV copies. The aggregate verifier must check:

- rank and displayed incidence conventions;
- all cyclic adjacency differences and five clique-closure rows;
- complete coverage of the two weight-ten raw domains;
- the weight-twelve witness;
- four orbit representatives, stabilizers, orbit masses, and all 364 words;
- pair and triple concurrence profiles and recovery of the 78 incidence rows;
- orbit Gram matrices and spanning identities;
- the anchor/stabilizer computation and exact automorphism group.

The independent replay must reconstruct the conic and incidence matrix from
the displayed normalization rather than consume the primary certificate.

## Red-team pass

1. **Salami slicing.** The paper is defensible only if reconstruction, orbit
   spanning, and the automorphism theorem remain central. A distance-only
   extraction would be too thin. The released companion must point forward
   rather than compete with Paper IV.
2. **Meaning of reconstruction.** “Reconstructs” must specify the input and
   equivalence: from the unlabeled minimum-support hypergraph on 78
   coordinates, recover the six-class relation scheme and the 78 parity-check
   supports up to coordinate and row permutation. It does not recover a
   preferred conic equation or labelled projective coordinates.
3. **Automorphism ambiguity.** Distinguish the linear code automorphism group,
   the coordinate-permutation group of the minimum supports, and the collineation
   group. The headline uses the second and proves its identification with
   `PGL(2,13)` in the symmetric-square action.
4. **Dihedral notation.** State “dihedral group of order 24”; do not rely on
   the ambiguous symbol `D_24`.
5. **Trust inflation.** Until the aggregate theorem exists, do not call the
   complete result Lean-proved. A Lean-checked table without a formal coverage
   bridge is not an orbit classification or a minimum-distance proof.
6. **Certificate opacity.** The weight-ten search spaces are large but have a
   small mathematical partition. The paper must prove why the two profiles
   exhaust all candidates and why the meet-in-the-middle sets cover each raw
   domain; hashes alone prove neither fact.
7. **Literature boundary.** Madison--Wu own the general dimension formula and
   Hollmann--Xiang own the elliptic association scheme. The paper claims the
   q13 minimum distance, minimum-layer classification, reconstruction, and
   exact symmetry only after a targeted original-source and forward-citation
   audit.
8. **Generalization pressure.** Do not turn C756's open all-k problem into an
   implied consequence. Paper IV is strongest when it proves one exact
   reconstruction theorem completely.

## Tao-style pass

- The conceptual theorem is not `d=12`; it is that extremal codewords remember
  their defining geometry. Put reconstruction in the theorem title, abstract,
  introduction, and conclusion.
- The proof should explain why the number 12 appears. Weight eight would force
  an impossible tangent clique; weight ten leaves only two parity profiles;
  the first surviving support is a dihedral twelve-set. This is a progression,
  not three unrelated searches.
- The association algebra is the explanatory center after distance is known.
  It turns four finite orbits into spanning theorems and converts concurrence
  data into intrinsic geometry. Expand this argument and compress raw orbit
  enumeration.
- Ask whether the minimum-support hypergraph determines the field model or only
  its permutation representation. The proved statement is the latter; the
  paper should say so precisely and leave coordinatization as a corollary only
  if it is actually derived.
- A second proof of rank 36 is valuable: the published dimension formula gives
  context, while exact elimination makes the paper and formal artifact
  self-contained at q13.

## Extra-juice pass

Cheap upgrades now in reach:

1. Factor the general conic/passant-code definitions into a reusable Lean
   module. This makes Paper IV the formal method pilot for C756 without adding
   the all-k conjecture to the manuscript.
2. Make every one of the four minimum-word orbits a spanning set in the
   headline theorem. This converts an orbit census into four redundant
   reconstruction channels.
3. Expose the code, minimum-support hypergraph, elliptic scheme, and incidence
   matrix as four mutually recoverable finite objects, to the exact extent
   proved by the existing concurrence arguments.
4. Give the paper one small diagram showing
   `minimum words -> concurrence colors -> elliptic scheme -> passant rows`.
   This is more useful than a large coordinate figure.
5. Provide a machine-readable reconstruction witness: the six concurrence
   tables, the selected 78 cliques, and a canonical relabelling hash. This
   makes the reconstruction claim independently inspectable without rerunning
   the full orbit search.
6. Test whether the four orbit designs have additional exact design strength
   or distinguishable weight-12 intersection spectra. Promote only a theorem
   with a conceptual role; otherwise record the result in the discovery track.

## Gates and order

1. Freeze theorem language and complete the novelty audit.
2. Extract and independently replay the evidence under Paper-IV paths.
3. Complete the human manuscript through the association-algebra proof.
4. Freeze the Lean interface, implement general modules, then shard the finite
   certificate leaves.
5. Run exact-target elaboration, aggregate gate, axiom audit, and transitive
   referee-facing prose review.
6. Synchronize manuscript claims to the achieved formal boundary.
7. Run adversarial and context-free reads, isolated replay, warning-free build,
   and artifact-hash validation.
8. Deposit immutable source and Lean artifacts, insert locators, and post the
   arXiv preprint.

The arXiv version should not wait for journal-specific formatting. It must
wait for exact theorem wording, honest trust claims, and a replayable public
artifact.
