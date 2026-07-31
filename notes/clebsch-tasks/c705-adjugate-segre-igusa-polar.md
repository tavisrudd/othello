# C705 — Adjugate realization of the Segre--Igusa polar map

**Lane:** `clebsch`

**Opened:** 2026-07-30

**Status:** in progress

## Objective

Determine whether the six adjugates
\(\operatorname{adj}(B_T(x))\), for
\[
B_T=P_{T,-}D_xP_{T,+},
\]
assemble intrinsically into the Segre--Igusa polar map without first
passing through the six scalar squares \(Z_T^2\).

## Frozen input

Import C704's conference operator, golden eigenspaces, signed Joubert
coordinates, cross-block determinant, matrix factorization, and
Segre--Igusa diagram.  Do not recompute their discovery history.

## Main gates

1. Decompose the span of the quadratic \(2\times2\) minors of all six
   cross-golden blocks under the signed outer \(S_6\)-action.
2. Compute the equivariant Hom space from that span to the outer-standard
   Igusa carrier.
3. Test whether contraction with the six frozen coefficient tensors gives
   the polar coordinates \(W_T\) up to one exact scalar.
4. If the raw adjugates fail, test the trace-free, compound-matrix, and
   exterior-square variants.
5. Identify the base locus scheme-theoretically.

## Upgrades

- Recover the fifteen singular Igusa lines as rank conditions.
- Test direct kernel descriptions of the ten Segre nodes and fifteen
  planes.
- Express the inverse Igusa-to-Segre map in the same operator language.

## Mining subtask — common \(E_8\) shadow source

Test whether the two polar five-spaces and their intertwiner are projections
of the same \(E_8\)-level object, rather than merely meeting after descent to
the exceptional outer action of \(S_6\).

1. Fix the exact \(E_8\) linkage already used for the Clebsch operator and
   branch it far enough to locate both outer five-dimensional \(S_6\)
   carriers simultaneously.
2. Search for one parent invariant, tensor, or differential whose two
   projections give \(q\) and \(W\), and whose mixed contraction gives
   \(A\) (hence explains \(\operatorname{adj}(A)=6Wq^{\mathsf T}\)).
3. Test whether the ten nodes, fifteen planes/lines, and bad-characteristic
   behavior are images of root-subsystem or discriminant strata upstairs.
4. Treat failure as evidence: identify the first incompatible branching or
   Hom space, and determine whether the nearest common source is instead
   \(E_6\), an \(A_2\)-lattice/Borcherds construction, or only outer
   \(S_6\).

The positive naming gate is an explicit common lift of \(q,W,A\); shared
\(S_6\) symmetry or membership in the same automorphic ecosystem is not
enough.  Until that gate passes, “\(E_8\) shadow sisters” remains a
conjectural strengthening of the proved “Clebsch shadow sisters.”

Situational source map:
`notes/2026-07-30-c705-shadow-sisters-literature-map.md`.

## Mining subtask — extended sister census

Determine whether the Segre--Igusa pair is the middle member of a larger
exceptional operator family.  A candidate earns “sister” status only if it
has:

1. two canonically paired exceptional carriers or polar systems;
2. one intrinsic parent tensor/operator producing both;
3. a generically corank-one mixed differential whose highest nonzero
   compound factors through the two polar directions;
4. complementary boundary contractions or rank strata; and
5. a restriction or degeneration compatible with the C705 identity.

Run the census in this dependency order.

1. **Ambient \(E_6\) lift.**  On Naruki's marked-cubic-surface space,
   identify the first-jet pairing of the two \(W(E_6)\)-equivariant
   contractions and test whether its restriction to every
   \(A_1\cong\overline M_{0,6}\) divisor is \(A\), up to the frozen
   determinant-line normalization.
2. **Coble cubic/sextic.**  Construct the mixed Jacobian of the dual Coble
   polar systems, determine its generic corank and minimal successful
   compound, and test whether the C705 factorization is a linear-section
   restriction.
3. **Weddle/Kummer sections.**  Restrict any Coble identity to the known
   genus-two special sections and decide whether this gives a new species
   or only inherited smaller shadows.
4. **Marked double-six.**  Compare its transpose-paired kernel systems
   with the sister criterion.  Record it as a sister only if a canonical
   mixed differential and compound factorization exist; otherwise classify
   the exact cousin relation.
5. **\(E_7/E_8\) extensions.**  Only after the preceding restriction maps
   are explicit, test Del Pezzo and Klein--McKay descendants for the same
   carrier/compound pattern.  Burkhardt and other modular varieties remain
   candidates, not presumed family members, until a paired carrier and
   parent operator are identified.

At every negative gate, record the first failed condition, the surviving
restriction, and the nearest positive relative.  The deliverable is a
rigid taxonomy—new sister, inherited shadow, elder parent, cousin, or
false analogy—not an unbounded catalogue of exceptional varieties.

## Mining subtask — Pauli-doily shadow

The \(S_6\cong\operatorname{Sp}_4(\mathbf F_2)\) dictionary is now exact:
the fifteen duads are the fifteen two-qubit Pauli points, synthemes are
commuting contexts, the ten \(3+3\) partitions are Mermin grids, and the six
stars are ovoids.  All ten Clebsch/Pfaffian grid parities equal \(-1\).

The first sign crown is negative and closed.  The Clebsch conference factor
in each context sign is point rephasing, and the \(K\)-diagonal triangle
tensor is an edge-cochain coboundary.  Thus unrestricted contextuality
cohomology does not see \(C\) or \(K\).  Full report and certificate:
`notes/2026-07-30-c705-clebsch-pauli-doily.md`.

The nearest positive repair is C706's equivariant Clifford-lift gate.
Separate queued packages C707--C710 own the ETF/POVM, incidence-code,
Majorana, and \(E_8\)--Hamming questions; they do not enlarge C705's
acceptance gate.

## Required closeout

No first-gate closure is allowed.  Run distinct `ej1`, `tt1`, `ej2`, and
`tt2` passes, incorporating and retesting all in-scope leads between the
pairs.  A negative result must identify the minimal obstruction,
obstruction locus, nearest positive repair, converse content, propagation
law, and one adjacent crown.  The final report must contain a mystery
ledger and the complete reproducibility bundle required for any
paper-facing computational claim.

## Acceptance

A positive result is a coordinate-free trace/adjugate diagram for the
Segre gradient, with exact scalar and base locus.  A negative result is a
representation-theoretic obstruction after the full route family and
negative-yield protocol have been exhausted.

## Boundary

Do not sweep arbitrary quadratic functions of \(B_T\), enlarge to WP2's
marked double-six comparison, or make a novelty claim without the
proportional literature audit.
