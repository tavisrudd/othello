# C855 — Paper I human-proof structural reductions

**Date:** 2026-08-09  
**Status:** prioritization note; C855 remains active

## Landed in this batch

Items 3 and 4 below are now paper-facing kernel theorems rather than proposals.
`Q11DecodingSynthesis` defines the two ten-element support sheets, proves that
every distance-three syndrome has exactly those twenty supports, identifies the
sheets with the two generator orbits, and proves that the displayed outer
normalizer exchanges them.  Its bundled Brianchon theorem identifies the ten
triple-ambiguity directions, their perfect-matching leader supports, the
complement of the invariant one-factorization, and the three concurrent witness
chords.

The downstream finitegeom commit is
`187bed8895fc62784caf2022d717b4daa37871ad`.
The q11 certificate package is atomically sealed at
`38059cab5923dbb2a15d515c711b913d991432d5`; its root gate, audit, and guarded
transcript agree on 58 terminals.  Final-head guarded run
`20260809-051043-dead8cd3` passes.  The authority release is sealed through
`7095e6c0` and its immutable 26-check replay passes over 115 package and 95
shared modules.

## Authority correction

Commit `187bed8`, like the preceding commutant commit `5d9f53f`, was made
directly in finitegeom without a matching monorepo authority commit.  The q11
package pin and release replay validate that downstream state, but do not make
it an edit authority.  The finitegeom repository is never edited directly;
every byte changed there must be produced by the prescribed area exporter from
a committed `~/src/othello/lean` source.

The reviewed proof content is being re-applied in the monorepo authority.  It
must be built there, included in fresh 51-terminal rigidity and orientation
trust facts, and committed there before the exporter runs.  The two downstream
commits must never be passed as exporter `--source-commit` values or used as
precedent for direct finitegeom development.

## Result

The best remaining route is not to formalize the manuscripts' longest human
proofs literally.  Several can be replaced by smaller structural statements
whose conclusions imply the printed claims and whose hypotheses are already
present in the Paper I closure.  The unconditional odd-`A5` commutant is the
model: two generator matrices and a rank-34 system replace a proposition-valued
representation-theoretic interface.

The old assertion inventory also overstates the current human-only surface.
The Brianchon matching dictionary, switching reconstruction, five-cycle
normalization, trace-annihilator dimension, determinant/support-cubic identity,
and support-cubic stabilizer already have kernel-checked structural components.
Those rows first need correspondence bridges and gate exposure, not fresh
coordinate proofs.

## Highest-value further reductions

### 1. Replace the Brauer-character orbit derivation by a two-generator action proof

**Progress: complete.**  Package terminal
`twoGenerator_pointOrbit_partition` now gives short word certificates for all
sixty support permutations and all 133 projective points.  The support words
have length at most twelve; the representative-to-point words have length at
most nine.  Generator invariance and the point partition prove that the seven
reachability classes are exactly the displayed blocks, so no stabilizer census
is needed.

For the order-eleven point-orbit proposition, retain the explicit `A5` action
and prove only:

1. the displayed permutations generate the 60-element action group;
2. the seven displayed sets are invariant and partition the 133 projective
   points; and
3. every point in a displayed set is reached from its representative by a
   short word in the two generators.

The set cardinalities then give the orbit lengths and uniqueness statements.  This
removes Maschke, modular reduction, Brauer characters, and the full subgroup
fixed-point table from the formal dependency.  Paper I now uses this proof.

### 2. Prove the order-600 monomial group by exhibit-plus-upper-bound

Avoid classifying every monomial automorphism.  Exhibit the scalar kernel and
the two lifted `A5` generators, prove the resulting subgroup has 600 elements,
and prove that restriction to the six projective columns maps any monomial
automorphism injectively into the already identified projective stabilizer,
with the scalar kernel as its only ambiguity.  Matching lower and upper bounds
give the full automorphism group, its cyclic kernel, and the split quotient in
one argument.

The deep-hole orbit theorem should then be a corollary of equivariance: identify
the 120 projective deep-hole directions with a single orbit, lift through the
scalar kernel to received words, and obtain the order-five stabilizer from
orbit--stabilizer.  This is substantially smaller than a separate coset-action
classification.

### 3. Turn support chirality into a character-kernel theorem

**Progress:** the finite semantic bridge is complete: the two generated sheets,
their `10+10` cardinalities, the leader-support equality at every deep-hole
syndrome, and outer exchange are now Lean terminals.  The stronger statement
that every monomial automorphism preserves the unordered sheets still belongs
with item 2's full automorphism-group theorem.

The twenty three-subsets need not be classified twice.  Define the support
sign as the triangle holonomy, use the existing two ten-element generated
orbits, and show that the normalizer's sign character has the orientation-
preserving subgroup as kernel.  Its two cosets are exactly the two support
classes; an orientation reverser swaps them.  This simultaneously proves:

- the unordered intrinsic bipartition;
- ten leaders in each class;
- the global `1200+1200` split after orbit multiplication; and
- preservation by automorphisms and exchange by the outer normalizer coset.

The reusable ingredients already exist in `ClebschSchemeChirality`,
`SupportOrientationHolonomy`, and
`SupportOrientationSymmetryGenerators`; the missing work is one semantic bridge,
not a new exhaustive table.

### 4. Collapse the Brianchon/support proof to `K6` matching combinatorics

**Progress:** complete for the decoder corollary.  The new bundled terminal
proves the ten direction identities, perfect-matching supports, complement of
the five invariant matchings, and concurrence of all three witness chords.
The manuscript's stronger `A5`-equivariance formulation remains naturally
paired with item 1's explicit-action theorem.

The geometric statement can factor through the fifteen edges and fifteen
perfect matchings of `K6`.  The five self-polar matchings form the invariant
one-factorization; the complementary ten are exactly the antipodal matchings
of the alternating six-cycles.  One checked concurrence representative plus
equivariance proves all ten geometric incidences, while the independent
45-pair ledger supplies a finite sanity check.

Most of this is already formalized in `Q11BrianchonPetersen`; the reduction is
to make its intrinsic matching theorem, rather than ten coordinate rows, the
paper-facing bridge to decoding supports.

### 5. Replace invariant-cubic character calculations by generator-fixed equations

Represent a cubic on the five-dimensional augmentation quotient in a monomial
basis.  Invariance under the same order-three and order-five generators gives a
small rational linear system.  A rank certificate showing a one-dimensional
kernel, followed by one evaluation, identifies the line with the Clebsch cubic.
This is the cubic analogue of the commutant proof and avoids a general character
calculation.  The existing translation invariance, trace-annihilator,
determinant, and normalization theorems then identify the support cubic with
that line.

### 6. Use rigidity to delete the largest conic-distance obligation

The 160,930-conic nearest-locus scan is mathematically redundant.  Once the
uniform rigidity theorem and the human gap theorem are formal, a non-Clebsch
class cannot have its uncovered locus on a nearer conic.  Keep the exhaustive
scan only as a reproducible sharpness audit, not as a theorem dependency.  This
reduction was already authorized in C855 and should be reflected in the final
claim map.

### 7. Make the fifteen-class census an orbit certificate, not a raw enumeration

Normalize a projective frame, let its finite stabilizer act on admissible
remaining pairs, and certify one representative per orbit.  The checker needs
only closure, disjointness, coverage, stabilizer size, and the local invariants
of each representative.  Orbit--stabilizer mass identities then recover the
global census and extension spectrum.  This removes repeated evaluation across
all normalized presentations while retaining a kernel-checked finite theorem.

### 8. Factor the q13 minimum-layer proof into module theory plus two local exclusions

Use the structural facts already isolated by C855: the binary code kernel has
dimension 36, is irreducible under `PGL(2,13)`, and has endomorphism field
`F_8`.  Hence every nonzero minimum word spans the code; no orbit-by-orbit span
computation is needed.  The remaining minimum-distance work separates into the
elementary parity lower bound, the geometric weight-eight exclusion, and a
certificate checker only for weight ten.  The association-scheme reconstruction
then works from one adjacency operator and the minimum-word incidence matrix,
not from replaying every word orbit.

### 9. Quotient the small-arc search by rooted extension states

For the terminal-field small-arc classification, the root-edge DAG should be
the formal object.  A state records only the stabilizer orbit of the current
arc and the invariant data needed for legal extension.  Prove that each raw arc
maps to exactly one state and that every child transition is complete.  Global
mass follows from stabilizer indices.  This is both faster and easier to audit
than formalizing the raw search tree.

## Recommended order

1. Land the semantic bridges for chirality and Brianchon, because most of their
   proof ingredients already exist.
2. Do the explicit-action orbit theorem and reuse it for the order-600
   automorphism and deep-hole orbit results.
3. Apply the generator-fixed linear-system pattern to the invariant cubic.
4. Reclassify the conic-distance scan as nonessential evidence.
5. Build generic orbit-certificate infrastructure once, then use it for the
   fifteen-class census and the small-arc DAG.
6. Keep q13 as a separate package: structural module theory first, the residual
   weight-ten checker second.

This order maximizes theorem coverage per new abstraction and avoids another
full-package reseal until a coherent batch of paper-facing terminals is ready.
