# C373 companion — the Clebsch gateway program

Date: 2026-07-19  
Status: research-program router updated through C381 and C374; C382 ready for its bounded
marked-icosian comparison and C375 retains the circuit gate
Parent: `2026-07-19-c373-clebsch-scheme-automorphisms.md`

## Executive thesis

The Clebsch object is useful as a cross-field gateway because the passages below preserve enough
structure to transport theorems, and several of them are reversible:

```text
icosahedral A5 representation <-> six points in P2 <-> [6,3,4] MDS code
             |                         |                       |
       golden arithmetic       Clebsch cubic surface      AME(6,11)
             |                  / 27 lines / E6                  |
             v                         v                       v
      split/inert/ramified     affine Cayley graph <-> rank-eight Fourier scheme
                                       |
                                       v
                    deep-hole conic + matching sheets + 10+10 torsor
```

The crucial C373 input is reconstruction: the unlabelled q=11 column graph recovers the unique
translation group, the six projective directions, and the unordered chiral `10+10` pair.  Thus the
graph is not merely associated to the code.  It is an intrinsic carrier from which the geometric
and coding presentation can be recovered.

The flagship program is now the combination of two ideas:

1. one golden descent torsor should control the representation, arc, code, scheme, and AME
   presentations; and
2. blowing up the same six points gives the Clebsch diagonal cubic surface, whose two
   `A5`-equivariant blowdowns are exchanged by `S5 \ A5`.

The second fact provides a classical algebro-geometric candidate for what the C373 chirality
torsor *is*.  Establishing or refuting that identification is the highest-value next check.

## Disposition through C379

The first gateway wave has now resolved four major questions.

- **C376:** the natural quintic passage between the two rows of the Clebsch double-six induces
  exactly the outer `S5-A5` coset, so cubic blowdown exchange and code chirality are the same
  quotient character.
- **C377:** the integral golden involution and its specializations are exact, but Benson pre-empts
  the generic three-dimensional `A5` descent mechanism.
- **C378:** adjoining that involution completes `A5` to `PGL_2(11)`, gives exactly the rank-four
  orthogonal fusion, and places the two golden rank-eight schemes inside a Fourier-self-dual
  rank-16 common refinement with a four-dimensional odd block.
- **C379:** the undecorated deep-hole transform terminates and its parent fibre has 22 elements, not
  two.  Six five-parent conics give a perfect matching that recovers the parent.  The 22 matchings
  split into two `PSL_2(11)`-invariant one-factorizations of `K_12`, exchanged by the golden outer
  map; their cross-incidence is the eleven-point biplane.
- **C380:** the stable deep-syndrome/arc-extension, quotient-character, finite matching-sheet, and
  C378 fusion interfaces are formalized behind bounded leaves and a clean import-only gate; no
  general surface or `E8` infrastructure was introduced.

The corrected information-loss chain is therefore

```text
two golden orientation sheets
          |
          v
two eleven-matching one-factorizations
          |
          | choose one matching
          v
matching-decorated child (Q,M_X) <-> one of 22 Clebsch parents
          |
          | forget M_X
          v
undecorated GRS conic Q.
```

This is not the same quotient as C378's rank-four fusion.  The speculative doors below remain a
reservoir, but no moduli, Mathieu, or exceptional-geometry expansion is authorized merely by these
positive finite theorems.

## The magic hexagon and the novelty standard

It is useful to organize the program as a six-vertex hexagon:

```text
                 (1) golden arithmetic / A5
                    /                     \
       (6) AME tensor                       (2) six-arc
                 |       MAGIC HEXAGON          |
       (5) Fourier scheme                    (3) cubic surface / E6
                    \                     /
                 (4) MDS code / deep holes
```

There are also diagonals: the six-arc directly builds the MDS code; the MDS code builds the
syndrome graph and AME tensor; the graph reconstructs the arc; and the arithmetic outer action is
visible at several vertices.

Prior art is welcome infrastructure.  MDS-to-AME, six-point blow-ups, the 27 lines and `E6`,
translation schemes, LC invariants, and type-II searches need not be reinvented.  The novelty
target is a new *path through the hexagon*.  A pathway earns theorem status when it does at least
one of the following:

- constructs an edge between two vertices that the prior literature treats separately;
- proves that two routes between the same vertices commute;
- transports one intrinsic invariant—especially the chiral `C2` torsor—around three or more
  vertices and recovers the same object;
- turns an obstruction in one field into a shorter proof in another;
- explains the split/inert/ramified phase simultaneously in several realizations; or
- produces an operational output, such as a decoder, LC certificate, channel law, or circuit
  bound, that no individual vertex supplies alone.

This changes the research question from “is each ingredient new?” to the sharper question “which
closed walks through the magic hexagon yield a new theorem?”  The most valuable possible result is
a path-independence theorem: starting with the golden `A5` datum and traveling through either the
cubic-surface route or the code/scheme route should recover the same chirality torsor and outer
involution.

## Certified input

The following are proved in the cited local reports and are not conjectural premises of this note.

- At q=11 the full automorphism group of the rank-eight scheme, and already of the column graph,
  is

  ```text
  F_11^3 semidirect (F_11^* times A5), order 798600.
  ```

- The translation subgroup is the unique normal Sylow-11 subgroup.  The graph intrinsically
  reconstructs its affine structure and six direction classes.
- The graph intrinsically reconstructs an unordered `10+10` chirality torsor, but no graph
  automorphism chooses one sheet.
- Its spectrum is `60^1, 16^150, 5^420, (-6)^760`; all arc-direction graphs with the same `(q,k)`
  share the same four eigenvalues even though graph isomorphism can recover the projective arc.
- The distance-three shell is precisely the 120-vector deep-hole orbit.  The graph is not
  distance-regular: its distance-two shell fractures into five `A5` orbits.
- The rank-eight translation scheme is Fourier self-dual with `P=Q`, and its intersection and
  Krein tensors coincide.
- The q=11 code is a non-GRS `[6,3,4]` MDS code.  Its deepest projective syndrome directions form
  a conic, hence define a GRS child.
- The MDS code supplies a six-party minimal-support `AME(6,11)` stabilizer presentation.  Its
  exact holonomy and triple-marginal moments prove LC and LU inequivalence, with party permutation,
  from every six-point Reed--Solomon presentation; comparison with arbitrary non-GRS classes remains
  outside the bounded result.
- The arithmetic evidence gives split behavior at 11, internal `S5` behavior at the ramified
  prime 5, and a candidate Frobenius-semilinear realization at inert primes.

## Door I — the Clebsch cubic surface, 27 lines, and `E6`

**C376 status: positive.**  The exact q=11 quintic contraction from the `E_i` blowdown to the
`Q_i` blowdown induces precisely `N_S6(A5) \ A5` on the six labels.  It therefore exchanges the
same two triple orbits as C373 chirality.  The second blowdown is projectively the golden-conjugate
`tau=4` configuration; its equivalences to that model induce precisely `A5`.  The checker also
recovers all 27 lines, 45 tritangent triples, ten Eckardt triples, 72 sixers, and 36 double-sixes,
with an independent replay.  See `2026-07-19-c376-clebsch-cubic-chirality.md`.  Door I is no longer
a candidate edge: over q=11 it is certified.  Integral descent and all-prime compatibility remain
Door II.

### Classical bridge

The six projective points coming from the long axes of the icosahedron are also a blow-up model of
the Clebsch diagonal cubic surface.  Blowing up six points in general position in `P2` produces a
degree-three del Pezzo surface.  Its 27 exceptional lines are organized as

```text
6 exceptional divisors + 15 transforms of pair-lines + 6 transforms of five-point conics.
```

For the icosahedral configuration, the resulting surface is the Clebsch cubic.  Classical
birational geometry supplies two `A5`-equivariant blowdowns to `P2`, corresponding to two invariant
double-sixes; elements of `S5 \ A5` exchange them.  The orthogonal complement of the canonical
class in the Picard lattice is the `E6` root lattice, and the 27-line monodromy lies in `W(E6)`.

This is remarkably close to the C373 picture: two chiral geometric presentations, individually
preserved by `A5`, exchanged by an outer `S5` coset.

### Certified theorem

Construct the blow-up and anticanonical map directly from the exact q=11 six-arc and prove a
commutative dictionary among

- the two C373 ten-element leader-support sheets;
- the two invariant double-sixes or blowdown markings;
- the ten Eckardt points or the appropriate ten tritangent incidences; and
- the outer normalizer coset exchanging chirality.

The exact certificate proves that quintic blowdown exchange and C373 code chirality are the same
quotient character `S5 -> C2`, without choosing a preferred sheet.  Identification of the second
blowdown with the golden-conjugate model induces precisely `A5`; the outer normalizer coset induces
the exchange.

### Exact certificate

1. The four-dimensional linear system of plane cubics through the six q=11 points gives the
   anticanonical model and verifies the mod-11 Clebsch surface.
2. The symbolic incidence table contains all 27 line classes, 45 tritangent triples, ten Eckardt
   triples, 72 sixers, and 36 double-sixes.
3. Exact enumeration of the two blowdowns and the golden-conjugate frame maps separates the 60
   inner from the 60 outer label permutations.
4. The outer permutations exchange C373's `10+10` split, proving the common quotient character.

This finite computation is complete, exact, and independently replayed in C376.

### Consequences and remaining extensions

- **Conceptual automorphisms.**  Recover `A5` as the stabilizer of a marked blowdown and the outer
  `S5` coset as blowdown exchange.  This may supply a second broad-audience explanation of why the
  residual group is exactly scalar times `A5`.
- **Arithmetic geometry.**  Track Frobenius on the 27 lines and Picard lattice across primes.  The
  code's split/inert/ramified phase may become the reduction theory of a marked cubic surface.
- **Exceptional Lie theory.**  Interpret syndrome orbits, leader supports, or chirality through
  weights and roots of `E6`.  The aim is an explicit incidence-preserving map, not the generic
  observation that cubic surfaces involve `E6`.
- **Monodromy.**  Compare the affine graph's recovered torsor with monodromy on double-sixes inside
  `W(E6)`.  This could turn the isolated q=11 calculation into a local system over the moduli of
  marked cubic surfaces.
- **Degeneration.**  Characteristic five may be visible as a special degeneration or symmetry
  enhancement of the marked surface, explaining why the external involution becomes internal.

## Door II — one arithmetic torsor with many realizations

Construct a golden-conjugate intertwiner `J(tau)` over `Z[tau]` and compute its descent cocycle.
The theorem target is that one quadratic torsor controls

1. the two three-dimensional icosahedral representations;
2. the two projective six-arcs;
3. the two marked Clebsch-surface blowdowns;
4. the classical monomial-equivalence obstruction between codes;
5. the two syndrome-scheme fibers and leader-support sheets; and
6. the induced stabilizer/AME presentations.

Specialization should give a unified phase theorem:

| prime behavior | predicted realization |
|---|---|
| split | two rational fibers exchanged by the outer involution |
| inert | one fiber with outer action realized only after composing with Frobenius |
| ramified at 5 | the distinction collapses or becomes internal under `S5` |

The best formulation may be a moduli stack of marked six-point configurations or marked Clebsch
cubic surfaces over the golden integer ring.  Its two-sheeted orientation cover would be the
master object; the codes, graphs, and tensors would be associated realizations.  C379 shows that
this binary orientation cannot be identified with the individual-parent fibre of the q=11 conic:
it selects one of two eleven-parent factorization systems, and a further matching selects the
parent.

## Door III — the deep-hole transform

Define a partially defined operation on projective arcs or MDS codes:

```text
D(C) = projectivized deepest-syndrome locus of C,
```

whenever that locus is itself an arc.  For the q=11 Clebsch code, `D(C)` is a conic and therefore
defines a GRS child, despite the parent being non-GRS.

The first questions are exact and bounded.

- What is `D(D(C))` after choosing the natural child parity-check presentation?
- Is the construction involutive, periodic, or terminating?
- Does it commute with projective equivalence, duality, Galois conjugation, or cubic-surface
  blowdown?
- Can `D(C)` be read from the 27-line or Eckardt incidence geometry?
- Is the Clebsch point characterized among six-arcs by having a conic deep-hole transform?

A positive rigidity theorem would join covering codes, list decoding, moduli of arcs, and derived
algebraic-geometric codes.  Generic MDS coset-weight formulas do not provide this transform.

**C379 outcome.**  `D(D(C))` is empty because the 66 conic secants cover `PG(2,11)`.  All twelve
one-point extensions are `[7,4,4]` MDS but give weak degree-two del Pezzo surfaces with one `A1`.
The transform becomes reversible on the 22-parent locus after decorating the conic by its six-pair
obstruction matching.  Those matchings form two one-factorizations with biplane cross-incidence.
This is now the exact Door-III theorem; arbitrary q=11 six-arcs and other fields remain open.

## Door IV — quantum invariants and exact eight-state dynamics

### Exact LC/LU separation from GRS classes

**C374 outcome.**  The fixed `tau=8` CSS state is `AME(6,11)`.  Its 450-entry minimal-support
holonomy signature differs from all four `PGL_2(11)` orbits on the 924 six-point GRS evaluation
sets, proving LC separation with party permutation.  The stronger triple-marginal moment
distribution has 70 copies of `11^-4` and 385 of `11^-6`, versus 60, 62, 63, or 64 copies of
`11^-4` on the four GRS orbits, proving general LU separation.  The broad existence of many
`AME(6,11)` LU classes is prior art; the bounded theorem is the explicit `A5`-symmetric Clebsch
class outside every GRS class.  Arbitrary non-GRS classification remains unclaimed.

### Fourier--MacWilliams channel algebra

Because the scheme is closed under both convolution and Fourier-side multiplication, every
`A5`-invariant syndrome distribution evolves in eight parameters.  Seek an orbit-level
MacWilliams theorem in which the same tensor controls

- classical addition of syndrome noise;
- Fourier-dual measurement statistics;
- composition of invariant Pauli channels; and
- an exact stabilizer recovery or fidelity calculation.

The operational gate is mandatory.  `P=Q` alone is algebraic combinatorics; an exact decoder,
channel law, noise-estimation reduction, or experimentally measurable statistic makes it a
quantum-information theorem.

### Equivariant circuit obstruction

The two-sheeted chirality may obstruct choosing a globally `A5`-equivariant factorization of the
six-party tensor.  Express a proposed two-site-gate circuit as intertwining equations for the
relevant `A5` modules.  A nonzero cocycle or incompatible decomposition could give a circuit lower
bound; otherwise the same calculation constructs an equivariant preparation.  This is a more
specific target than generic perfect-tensor holography, whose known cells have the wrong arity.

## Door V — chirality as data, not decoration

### Signed list decoding

Each farthest coset has 20 minimum leaders by generic MDS theory.  Here their supports split into
intrinsic sheets of size ten.  Compute the two sheetwise incidence and intersection algebras and
define a signed leader enumerator

```text
L_plus(z) - L_minus(z).
```

Determine whether the sign transforms under the arithmetic outer involution and whether either
sheet has a distinct exact design, transition, robustness, or ambiguity statistic.  If no such
observable exists, the decoding interpretation stops.

### Genus-two theta-characteristic dictionary

Six labeled Weierstrass points of a genus-two hyperelliptic curve carry six odd and ten even theta
characteristics; the ten even characteristics can be indexed by unordered `3+3` partitions.  The
20 three-subsets are the oriented double cover of those ten partitions.  This gives a precise
combinatorial model for a `10+10` split.

The cheap test is whether every complementary pair of leader supports meets the two C373 sheets
once each, and whether the `S6` action agrees with the standard `Sp4(F2)` action.  A positive test
would identify chirality with an orientation of even theta characteristics.  A canonical genus-two
curve or Jacobian must then be constructed from the Clebsch data; without that construction this
remains a combinatorial dictionary, not a geometric theorem.

### Secret sharing and complementary recovery

Minimal-support AME states and MDS codes already yield threshold secret-sharing structures.  The
new question is whether the two oriented `3+3` sheets distinguish two complementary reconstruction
maps, phases, or transversal operations while leaving the ordinary access structure unchanged.
This door survives only if the signed refinement changes an operational recovery observable.

## Door VI — what spectra forget and richer invariants recover

All `(q,k)` arc-direction graphs have the same four eigenvalues, whereas their isomorphism types
can recover inequivalent projective arcs under the known linear-representation hypotheses.  The
Clebsch example supports several controlled separation problems.

### `Can one hear the arc?`

Choose a bounded pair of inequivalent q=11 six-arcs and compare, in order,

```text
spectrum -> walk counts -> coherent closure -> k-WL -> graph isomorphism -> recovered chirality.
```

The desired theorem is the first exact point at which the pair separates.  This connects inverse
spectral graph theory, graph isomorphism, finite geometry, and code equivalence without requiring a
broad census.

### Matroid realization invariant

Every six-arc realizes the same uniform matroid `U(3,6)`, so the ordinary matroid and Tutte
polynomial forget the projective moduli just as the graph spectrum does.  The recovered Cayley
graph suggests a `realization enhancement` of a representable matroid: attach its direction graph
or coherent configuration.  Study whether this enhancement is faithful on the relevant
realization space and how golden Galois conjugation acts on it.

This could connect matroid realization spaces, partial fields/cross-ratios, CI graphs, and coding.
The first gate is to express the q=11 chirality invariant directly as a projective cross-ratio or
bracket invariant.

### Robust reconstruction

C373 reconstructs the exact geometry from maximum cliques.  Ask for a stability theorem: after a
bounded number of adversarial edge changes, can one still recover the six parallel classes and
the underlying arc?  The graph has degree 60 and second eigenvalue 16, just above the Ramanujan
bound `2 sqrt(59)`.  Spectral expansion plus clique stability may yield an error-correcting
canonical form for geometric data.

The theorem should state an explicit noise radius and recovery algorithm; otherwise `near
Ramanujan` is only a numerical curiosity.

## Door VII — new algebraic-combinatorial and physical tests

### Type-II matrices, complex Hadamards, and spin models

Search the eight-dimensional Bose--Mesner algebra for a matrix

```text
W = sum_i w_i A_i
```

that is complex Hadamard or type II.  This reduces to finitely many exact polynomial equations in
the eight coefficients because the eigenmatrix is known.  Association-scheme type-II matrices
connect to spin models and link invariants, so a solution would send the Clebsch scheme into knot
theory and exactly solvable statistical mechanics.  A proof of nonexistence is also a clean
classification result.  Self-duality alone does not imply such a matrix exists.

### Quantum walks and chiral transfer

For each orbital graph, fusion, or real weighted combination, solve the eigenvalue phase
conditions for perfect state transfer or fractional revival.  Translation schemes make the
amplitudes exact character sums.  The interesting outcome would be transfer that detects or
exchanges the two chiral sheets; generic periodicity is not enough.

### Spherical designs from primitive idempotents

Embed the 1,331 vertices using each nontrivial primitive idempotent of ranks 150, 420, and 760.
Compute the resulting inner products and design strengths.  Then restrict to the deep-hole orbit
and the two leader sheets.  New tight frames, few-distance sets, or spherical designs would connect
the syndrome scheme to Euclidean discrete geometry.  Delsarte embeddings are generic; only an
extremal or previously unidentified parameter set is worth promoting.

### Optimized invariant expanders

The column graph misses the Ramanujan bound by less than one in its largest nontrivial eigenvalue.
Use the full rank-eight eigenmatrix to optimize sparse unions or weighted combinations of orbitals
for spectral gap, integrality, and chirality sensitivity.  This is an exact finite optimization
problem.  The output needs a new extremal graph or a useful robust-reconstruction consequence.

## Door VIII — lattices, tropicalization, and arithmetic moduli

### Code lattices

Apply Construction A, and where appropriate number-field variants, to the two golden or chiral
code presentations.  Compare Gram forms, theta series, automorphism groups, and Euclidean
isometry.  MDS weight enumerators coincide, so a pair of isospectral but nonisometric lattices or
flat tori is conceivable but not implied.  Complete weight enumerators and exact lattice-isometry
tests are the first gate.

The cubic surface already supplies a more canonical lattice: its Picard lattice contains `E6`.
The deeper target is an explicit homomorphism from code/syndrome data into the Picard or `E6`
lattice, not two unrelated uses of the word lattice.

### Arithmetic moduli and zeta data

View the Clebsch configuration as a point of the moduli of six marked points in `P2`, or of marked
cubic surfaces.  Its golden conjugate pair should define a degree-two arithmetic point.  Reduction
at split, inert, and ramified primes can then be measured through

- Frobenius on the 27 lines and double-sixes;
- the Picard rank and surface zeta function;
- the number and fields of definition of blowdowns; and
- the induced code and scheme isomorphism classes.

This would promote the observed modular phase diagram to arithmetic geometry.  The cheap gate is
to compute the Frobenius permutation representation on the 27 line classes from the exact integral
model.

### Tropical degeneration

Tropical cubic del Pezzo surfaces retain an `E6`-controlled 27-line combinatorics.  Valuations of
the golden integral model might convert prime degeneration into a tropical marked surface whose
combinatorial type predicts code degeneration.  This is a third-tier direction until the ordinary
surface dictionary and Frobenius action are explicit.

## Atlas of famous objects reachable from the hexagon

This section asks for recognizable destinations, not merely neighboring theories.  The entries are
ranked by how canonical the path from the present six-arc appears.  Prior art may establish every
intermediate construction; the proposed contribution is the marked path, commuting diagram, or
transported chirality invariant.

### 1. The Clebsch graph and Schlaefli graph — direct

The del Pezzo blow-up ladder immediately reaches two famous strongly regular graphs.

- Blowing up five points gives a degree-four del Pezzo with 16 exceptional curves and root system
  `D5`; their incidence/skewness graph gives the 16-vertex Clebsch-graph geometry.
- Blowing up six points gives the cubic surface with 27 lines and root system `E6`; skewness of the
  lines gives the 27-vertex Schlaefli graph.
- Equivalently, fixing one line in the 27-line geometry leaves a 16-line residue whose appropriate
  incidence complement is the Clebsch graph.

Thus puncturing one coordinate of the `[6,3,4]` code should have a geometric shadow

```text
Schlaefli / E6  ->  Clebsch / D5.
```

The new theorem target is functoriality: code puncturing, surface blowdown, root-system deletion,
and graph residue should form a commuting square, with the `A5` marking tracked throughout.

### 2. The exceptional del Pezzo--Lie--Gosset ladder — direct infrastructure, new marked path

Extending or deleting points in a planar arc matches the standard del Pezzo ladder:

| arc size | code | blow-up surface | root system | famous configuration |
|---:|---|---|---|---|
| 5 | `[5,3,3]` | degree 4 | `D5` | 16 exceptional curves / Clebsch graph |
| 6 | `[6,3,4]` | degree 3 | `E6` | 27 lines / Schlaefli graph / `2_21` Gosset polytope |
| 7 | `[7,3,5]` | degree 2 | `E7` | 56 exceptional curves / 28 bitangents |
| 8 | `[8,3,6]` | degree 1 | `E8` | 240 exceptional curves / `E8` roots |

For a code theorist, adding a column is an MDS extension problem.  For an algebraic geometer it is
another blow-up.  For Lie theory it advances from `D5` through `E6,E7,E8`.  The magic-hexagon
question is whether the Clebsch arithmetic marking selects distinguished extensions and whether
deep-hole directions are precisely the allowable or obstructed blow-up points.

This could turn covering-radius data into a finite-field rule for navigating the exceptional
Dynkin tower.  Conversely, exceptional-curve incidence might classify which code extensions
preserve the chiral torsor.

For the Clebsch q=11 family, C379 blocks the smooth last two rungs in a precise way.  Every
seven-point extension contains a six-point conic and is only weak degree two.  Any eight-point set
containing it inherits that forbidden six-subset, so no extension through the C379 child can be a
smooth degree-one del Pezzo.  The surviving `E8` question concerns the effective-root subsystem of
a weak eight-point blow-up, not the existence of its abstract Picard `E8` lattice.

### 3. Gosset polytopes and minuscule representations — direct after the surface dictionary

The 27 lines are the 27 vertices of the `2_21` Gosset/Schlaefli polytope and the weights of the
minuscule 27-dimensional `E6` representation.  The 56 exceptional curves at degree two similarly
belong to the minuscule `E7` geometry, while degree one reaches the 240 `E8` roots.

An explicit map from code leader supports or syndrome relations to faces of these polytopes would
convert Hamming geometry into exceptional weight geometry.  The gate is strict: counts and group
names do not suffice; adjacency, intersection, and the outer involution must be preserved.

### 4. The 600-cell, icosians, and `E8` — corrected two-stage route C381--C382

There are two independent routes from the magic hexagon toward `E8`, but C379 changes the first
endpoint.

```text
six-arc -> two child points -> weak eight-point blow-up -> marked effective subsystem in E8

golden A5 -> binary icosahedral group -> 600-cell / icosians -> E8 lattice.
```

The second route is classical: the icosian ring over the golden field constructs the `E8` lattice
and links the icosahedron, quaternions, `H4`, and the 600-cell.  C381 has now supplied the exact
marked endpoint required to compare the first route without collapsing it to that dictionary.

**C381 outcome.**  The complete `22*66` domain has three marked integral root types:
`(D8,A2)` on the 132 matched pairs, `(3A1,2A1)` on 660 weak MDS pairs, and `(4A1,2A1)` on 660 weak
non-MDS pairs.  Root intersection recovers the obstruction matching, hence the parent, and the
marked type decides eight-arc/MDS status.  The matched `D8` has index two in `E8`, but its abstract
`C2` glue quotient cannot carry chirality because `Aut(C2)` is trivial.

**C382** is ready for the bounded marked comparison.  It first compares the `A5` actions by the
free `A5/D10,A5/C2,A5/C2` permutation characters, root orbits, marked `D8<E8` embedding and glue,
and centralizer/normalizer ambiguity.  Only if those match in the same category may it construct
an integral isometry to the icosian model and test path independence and golden-involution
compatibility; an arbitrary `E8` isometry is a red result.

```text
C381 green marked-E8 invariant
    |
    +-- C382 character/embedding gate --> integral comparison only on a match
    |
    +-- mismatch or abstract-C2-only result --> close the route
```

This two-stage route is fully specified in
`notes/2026-07-19-c381-clebsch-e8-extension-obstruction.md` and
`notes/2026-07-19-c382-clebsch-icosian-e8-path-independence.md`.  An abstract `E8` lattice, equal
root counts, or an arbitrary comparison isometry cannot clear the gate.

### 5. Segre cubic, Igusa quartic, Kummer surfaces, and `M_0,6` — canonical six-label network

Six labeled objects carry a famous `S6` moduli web:

- six points on a projective line describe genus-two branch data and `M_0,6`;
- the Segre cubic and its dual Igusa quartic encode closely related six-point quotients;
- the Segre cubic has the characteristic `10`-node and `15`-plane combinatorics;
- genus-two Jacobians lead to Kummer surfaces with 16 nodes/tropes; and
- `S6 ~= Sp4(F2)` organizes the six odd and ten even theta characteristics.

The Clebsch data already carries the same raw numbers—six labels, fifteen pairs, twenty oriented
triples, ten complementary `3+3` partitions, and an intrinsic `10+10` cover.  The theorem target is
to construct a canonical point or cycle in this moduli web from the six-arc or cubic-surface
marking, then show that its theta orientation equals C373 chirality.

This route is especially attractive because it can explain the outer `S6` combinatorics while the
cubic-surface route explains the outer `S5` geometry.  A compatibility theorem between the two
would connect two famously exceptional symmetric-group phenomena.

### 6. Hilbert modular surfaces over `Q(sqrt(5))` — direct classical destination

Hirzebruch classically related the Clebsch--Klein cubic to the Hilbert modular group of the golden
field: blowing up the ten Eckardt points gives the relevant level-two Hilbert modular surface.
This makes the golden arithmetic in C368 more than coefficient arithmetic.

The new route to test is

```text
code chirality -> Eckardt/double-six orientation -> Hilbert modular involution
              -> split/inert/ramified reduction of the syndrome scheme.
```

If the same involution acts on modular forms and on the code torsor, the finite-field phase theorem
could become a reduction theorem for a Hilbert modular surface.  Point counts or Frobenius traces
would then provide arithmetic invariants independent of the graph computation.

### 7. Petersen graph and monodromy of 27 lines — direct literature, new code interpretation

Recent work describes monodromy of the 27 lines on the Clebsch surface using the Petersen graph.
Once the six-arc-to-surface dictionary is explicit, pull that Petersen structure back to code
supports or syndrome orbits.  The useful outcome would be a ten-object code configuration whose
monodromy generates or detects the C373 outer torsor.

This is another possible explanation for the repeated ten-element sets, but it must be matched by
an exact incidence map; the shared number ten is not evidence by itself.

### 8. Type `D4` cluster algebras and tropical Grassmannians — direct from the parity-check matrix

A full-rank `3 x 6` parity-check matrix is a point of `Gr(3,6)`, with its `3 x 3` minors as Pluecker
coordinates; the MDS condition says those coordinates do not vanish.  The positive tropical
Grassmannian `Gr(3,6)` is governed by cluster combinatorics of type `D4`.

This supplies a new coordinate language for the Clebsch point.  Compute its cluster variables and
ask whether

- golden conjugation is a cluster automorphism;
- the two chiral sheets are chambers or seeds exchanged by that automorphism;
- the deep-hole transform is a mutation sequence; or
- finite-field degeneration is tropical wall crossing.

A single explicit mutation identity linking chirality or the GRS child would be a meaningful new
edge between coding and cluster geometry.  Merely locating the matrix in `Gr(3,6)` is prior
infrastructure.

### 9. Exceptional Jordan algebra and the cubic norm — conditional

The 27-line configuration realizes the 27-dimensional minuscule `E6` geometry, while the
exceptional Jordan algebra also carries a 27-dimensional representation with an invariant cubic
norm.  The Clebsch surface is itself cubic.  After the 27-line dictionary, test whether the
weight-three leader incidence or anticanonical cubic embeds naturally into this cubic norm
structure.

This could connect the code to octonionic/projective-plane geometry, but it is a second-stage door:
without an explicit cubic-form or incidence-preserving map it is only an `E6` association.

### 10. The Witt design, `M12`, and the ternary Golay corridor — speculative but sharply gated

The deep-hole conic has `q+1=12` rational points and is canonically a projective line over `F11`.
The same 12-point set is a classical model for the Witt design `S(5,6,12)`, with `PSL2(11)` inside
the Mathieu group `M12`; the ternary Golay code is another famous 12-point realization.

The corridor becomes real only if the Clebsch construction canonically selects Witt hexads or the
Witt incidence relation on its 12 conic points.  C379 now selects two one-factorizations and an
eleven-point biplane, which is genuine extra incidence but is not a Witt `5-(12,6,1)` design.
Concrete gates are:

1. transport the original six-arc/deep-hole incidence to six-subsets of the conic;
2. test the Steiner `5-(12,6,1)` property;
3. compare the induced automorphism group with `PSL2(11)` and `M12`; and
4. determine whether chirality becomes a choice of complementary hexad.

Failure of the Steiner property closes the door.  No Golay or Mathieu claim follows from the
numbers 11 and 12, from `PSL_2(11)`, or from the biplane alone.

### 11. Automorphic forms and Galois representations — conditional on the Hilbert route

The cubic-surface literature already connects Frobenius on 27 lines, `W(E6)`-valued Galois
representations, and automorphic forms in other settings.  The Clebsch gateway offers a concrete
finite combinatorial observable—the syndrome scheme—on which to see the same Frobenius.

The theorem target is equality of two characteristic polynomials or `L`-factors: one from the
Picard/27-line representation, another from an explicitly defined code/scheme module.  This would
connect a finite decoder geometry to arithmetic automorphic data.  It is high upside but should
follow, not precede, the exact surface and Frobenius dictionaries.

### Recommended famous-object sequence

The shortest credible chain is

```text
Clebsch code
  -> marked Clebsch cubic
  -> 27 lines / Schlaefli graph / E6
  -> puncture and extend through Clebsch graph, 28 bitangents, and E8
  -> compare the E8 endpoint with the icosian / 600-cell endpoint.
```

In parallel, use the `20 -> 10` complementary-support quotient to enter

```text
genus-two theta characteristics -> Segre/Igusa/Kummer moduli
                               -> Hilbert modular surface over Q(sqrt(5)).
```

Those two chains are largely classical internally but appear capable of carrying the *same exact
chiral torsor* from coding theory into exceptional geometry and arithmetic.  That transported
object—not the fame of the destinations—is the proposed novelty.

## Ranked execution plan

| rank | project | cost of first gate | upside | stop condition |
|---:|---|---|---|---|
| 1 | cubic-surface incidence dictionary | low | very high | `10+10` has no natural 27-line/double-six interpretation |
| 2 | symbolic golden descent cocycle | medium | very high | no uniform specialization across split/inert/ramified primes |
| 3 | one iteration of deep-hole transform | low | high | child transform is presentation-dependent or structureless |
| 4 | genus-two complementary-pair test | very low | medium/high | sheets do not select opposite orientations consistently |
| 5 | C374 scheme-profile obstruction | medium | high | profile collapses across all AME presentations |
| 6 | type-II/Hadamard polynomial solve | low/medium | high but uncertain | exact system has only generic/trivial solutions |
| 7 | signed leader incidence algebra | low | medium | sheets have identical unsigned and signed operational data |
| 8 | bounded cospectral/WL pair | medium | medium/high | no clean invariant separation at small q=11 sample |
| 9 | Frobenius on 27 lines | medium | high after rank 1 | no match to code arithmetic phase |
| 10 | spherical/walk/expander searches | low each | opportunistic | no extremal or chirality-sensitive output |
| 11 | code-lattice comparison | low/medium | speculative | lattices are plainly isometric or theta data generic |
| 12 | tropical and secret-sharing lifts | high | speculative | no concrete map or operational statistic |

The table records the original triage; ranks 1--3, the foundation track, C374's quantum-equivalence
gate, and C381's marked-root classification have been resolved by C374 and C376--C381.  The current
immediate sequence is:

1. run C382's cheap marked-embedding/character gate and proceed to an integral icosian comparison
   only if it yields an intrinsic quotient and a consequence beyond C381;
2. run C375's fixed-convention minimal and `A5`-equivariant circuit gate independently of the pure
   mathematical paper;
3. retain the C379 one-factorization/biplane theorem only as Clebsch compatibility, without abstract
   novelty language, because the focused audit pre-empts its classical core;
4. keep genus-two, Mathieu/Witt, Jordan, and other famous-object doors closed until an additional
   canonical incidence theorem selects them.

## Claim and literature boundary

This document is a synthesis and proposal map, not a novelty certification.  The exact local
results are sourced by C368, C371, C372, and C373.  Established results are intentionally used as
infrastructure; a contribution may consist of a new edge, commuting diagram, transported torsor,
or operational consequence even when every vertex is classical.  None of those proposed pathways
should be claimed new without a source-level and forward-citation audit.

External sources consulted for this companion note:

- Prokhorov, [*Icosahedron in birational geometry*](https://arxiv.org/abs/2411.15334), arXiv
  `2411.15334`: **search-result abstract plus targeted result snippet only**.  The snippet states
  that the Clebsch cubic is the blow-up of the six long-diagonal points, has two `A5`-equivariant
  blowdowns, and that `S5 \ A5` exchanges them.  Full text not read in this amendment.
- Basak, [*Petersen graph and monodromy of the 27 lines on the Clebsch surface*](https://arxiv.org/abs/2607.01878),
  arXiv `2607.01878`: **abstract/metadata only**.  Used only to mark the `W(E6)` monodromy bridge as
  active prior art.
- Cueto and Deopurkar,
  [*Anticanonical tropical cubic del Pezzos contain exactly 27 lines*](https://arxiv.org/abs/1906.08196),
  arXiv `1906.08196`: **abstract/metadata only**.  Used only for the tropical/`W(E6)` boundary.
- Ikuta and Munemasa,
  [*Complex Hadamard matrices contained in a Bose--Mesner algebra*](https://arxiv.org/abs/1411.0057),
  arXiv `1411.0057`: **abstract/metadata only**.  Used to establish that type-II and complex
  Hadamard searches inside Bose--Mesner algebras are prior machinery.
- Chan and Godsil,
  [*Bose--Mesner algebras attached to invertible Jones pairs*](https://arxiv.org/abs/math/0303370),
  arXiv `math/0303370`: **abstract/metadata only**.  Used for the spin-model/link-invariant
  boundary.
- Van den Nest, Dehaene, and De Moor,
  [*Finite set of invariants to characterize local Clifford equivalence of stabilizer states*](https://arxiv.org/abs/quant-ph/0410165),
  arXiv `quant-ph/0410165`: **abstract/metadata only**.  Complete finite LC invariants are prior;
  only a small geometric completeness theorem could be new here.
- The genus-two fact that there are six odd and ten even theta characteristics, with the even ones
  indexed by `3+3` partitions of six Weierstrass points, was checked only through search-result
  snippets and secondary expository material.  It requires a primary-source audit before use.
- Baez, [*From the Icosahedron to E8*](https://arxiv.org/abs/1712.06436), arXiv `1712.06436`:
  **abstract/metadata only**.  Used for the classical icosian and Kleinian-singularity routes from
  the icosahedron to the `E8` lattice.
- Manivel, [*Configurations of lines and models of Lie algebras*](https://arxiv.org/abs/math/0507118),
  arXiv `math/0507118`: **abstract/metadata only**.  Used for the established `E6`/27-lines and
  `E7`/28-bitangents boundary and the exceptional-Lie interpretation of double-sixes and Steiner
  sets.
- Ren, Sam, and Sturmfels,
  [*Tropicalization of classical moduli spaces*](https://arxiv.org/abs/1303.1132), arXiv
  `1303.1132`: **abstract/metadata only**.  Used to establish that the Segre cubic, Igusa quartic,
  genus-two moduli, and marked del Pezzo spaces already form a classical/tropical network.
- Brodsky, Ceballos, and Labbe,
  [*Cluster Algebras of Type D4, Tropical Planes, and the Positive Tropical Grassmannian*](https://arxiv.org/abs/1511.02699),
  arXiv `1511.02699`: **abstract/metadata only**.  Used for the `Gr(3,6)`/type-`D4` cluster boundary.
- Hirzebruch,
  [*Hilbert's modular group of the field Q(sqrt(5)) and the cubic diagonal surface of Clebsch and Klein*](https://doi.org/10.1070/RM1976v031n05ABEH004190):
  **metadata and repository summary only**; full text not read.  Used for the classical Hilbert
  modular surface bridge.
- Darwin, [*A quadratically enriched count of lines on a degree 4 del Pezzo surface*](https://arxiv.org/abs/2205.04456),
  and Desjardins--Winter,
  [*Torsion points and concurrent exceptional curves on del Pezzo surfaces of degree one*](https://arxiv.org/abs/2210.11659):
  **abstract/metadata only**.  Used only to check the standard counts of 16 and 240 exceptional
  curves.  The full del Pezzo/code ladder still needs a dedicated source audit.

Not covered: MathSciNet, zbMATH, Google Scholar, forward citations, the full cubic-surface
literature, the full genus-two/theta literature, or prior classifications of type-II matrices in
rank-eight translation schemes.  No primary source was located in this amendment for the proposed
`P1(F11)`--Witt-design corridor, so it remains deliberately speculative.
