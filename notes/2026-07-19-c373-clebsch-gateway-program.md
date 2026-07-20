# C373 companion — the Clebsch gateway program

Date: 2026-07-19  
Status: research-program note; exact C368/C372/C373 results separated from proposed bridges  
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
                              deep-hole conic + 10+10 torsor
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
  local-Clifford equivalence class relative to Reed--Solomon presentations remains open.
- The arithmetic evidence gives split behavior at 11, internal `S5` behavior at the ramified
  prime 5, and a candidate Frobenius-semilinear realization at inert primes.

## Door I — the Clebsch cubic surface, 27 lines, and `E6`

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

### First theorem target

Construct the blow-up and anticanonical map directly from the exact q=11 six-arc and prove a
commutative dictionary among

- the two C373 ten-element leader-support sheets;
- the two invariant double-sixes or blowdown markings;
- the ten Eckardt points or the appropriate ten tritangent incidences; and
- the outer normalizer coset exchanging chirality.

The exact correspondence is deliberately not asserted yet: the counts are suggestive, but the
incidence map must be computed.  A positive result would geometrize the code's chirality; a
negative result would still identify which distinct classical `C2` torsors are present.

### Cheap exact gate

1. Form the four-dimensional linear system of plane cubics through the six q=11 points.
2. Compute its anticanonical image and verify the resulting cubic is the mod-11 Clebsch surface.
3. Enumerate the 27 line classes and all tritangent/Eckardt incidences symbolically.
4. Map each of the 20 weight-three deep-hole leader supports into that incidence table.
5. Test whether the C373 `10+10` split is one of the two invariant double-six/blowdown choices.

This computation is finite, exact, and likely cheaper than the remaining local-Clifford search.

### Further consequences if positive

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
cubic surfaces over the golden integer ring.  Its two-sheeted cover would be the master object;
the codes, graphs, and tensors would be associated realizations.

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

## Door IV — quantum invariants and exact eight-state dynamics

### Geometric local-Clifford profile

A single Pauli-`X` syndrome scheme depends on the chosen stabilizer presentation.  To obtain a
state invariant, form the multiset of syndrome schemes over all local Pauli Lagrangian frames,
quotiented by the local symplectic group.  Test whether this `scheme profile`

- separates the Clebsch AME presentation from all GRS presentations;
- yields a short invariant that is complete for the relevant `AME(6,11)` family; or
- reduces C374 to a small number of mixed `X/Z` cases.

General complete finite LC invariants are prior art.  Novelty would be the small, geometric,
rank-eight certificate and its completeness in this exceptional family.

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

Recommended immediate sequence:

1. compute the Clebsch cubic and 27-line incidence dictionary from the exact six-arc;
2. test complementary leader supports against the two sheets and genus-two `3+3` partitions;
3. compute `D(D(C))`;
4. derive the symbolic golden intertwiner and compare its action on the surface marking;
5. feed the resulting symmetry restrictions into C374;
6. run the type-II/Hadamard equations as an independent cheap surprise gate.

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

Not covered: MathSciNet, zbMATH, Google Scholar, forward citations, the full cubic-surface
literature, the full genus-two/theta literature, or prior classifications of type-II matrices in
rank-eight translation schemes.
