# Hexagons are the bestagons: a narrative and proof spine for the Clebsch paper

**Lane:** `crowns`

**Date:** 2026-07-19

**Status:** exposition blueprint updated through C381 and C374's exact LC/LU separation; C382 is
ready for its bounded marked-icosian comparison, while C375 retains the circuit gate

## Governing idea

“Hexagons are the bestagons” should be the paper's organizing promise, not a repeated joke.  The
fun comes from proving that one six-point object keeps changing mathematical languages without
changing identity:

```text
icosahedral orbit -> projective arc -> MDS code -> deep-hole geometry
                   -> association algebra -> perfect tensor
                   -> intrinsic recovery of the original hexagon.
```

The six-part structure is mathematically earned.  The six columns have fifteen pairs, twenty
triples split `10+10`, a twelve-direction deepest-syndrome locus at q=11, and eight affine syndrome
orbits.  None of these counts should be presented as numerology: each transition is an explicit
theorem or compatibility map.

The broadest proved mathematical story is now:

> The q=11 Clebsch hexagon is a non-Reed--Solomon MDS parent whose complete deepest-syndrome locus
> is a Reed--Solomon conic.  Its affine syndrome classes form a primitive Fourier-self-dual
> rank-eight `A5` association scheme, and the canonical coset graph of the bare code recovers the
> hexagon and its unordered `10+10` chirality torsor.  The conic forgets 22 Clebsch parents, but a
> canonical obstruction matching recovers each one; the 22 matchings form two
> `PSL_2(11)`-invariant one-factorizations whose cross-incidence is the eleven-point biplane.

Applying the standard MDS-to-AME construction adds the quantum reading:

> The same hexagon presents an `A5`-symmetric `AME(6,11)` perfect tensor whose Pauli-`X` error
> sectors carry that self-dual eight-class algebra.  Its exact minimal-support holonomy and
> triple-marginal moment distributions separate it, even up to party permutation, from every
> six-point GRS `AME(6,11)` class under local Clifford and general local unitary equivalence.

This is an explicit `A5`-symmetric non-GRS class outside all GRS classes, not a claim that the broad
existence of multiple `AME(6,11)` LU classes is new.

## The picture to show the reader

```text
                              A
                         [6] / \ [1]
                            /   \
                           F     B
                       [5] |     | [2]
                           E     C
                            \   /
                         [4] \ / [3]
                              D
```

Vertex legend:

| vertex | object |
|:---:|:---|
| `A` | integral `H3/A5` six-orbit, recovered again at the end |
| `B` | good-reduction projective six-arc |
| `C` | `[6,3,4]` MDS parent and its exact GRS phase |
| `D` | q=11 deep-hole conic, matching-decorated parent memory, and `[12,3,10]` GRS child |
| `E` | rank-eight syndrome fission, rank-16 golden refinement, and rank-four orthogonal fusion |
| `F` | `AME(6,11)` perfect-tensor presentation and its Pauli-error structure |

Side legend:

| side | proof-bearing transition |
|:---:|:---|
| `[1]` | integral symmetry to good-reduction arithmetic geometry |
| `[2]` | minors and conic determinant: six-arc to MDS/GRS code |
| `[3]` | secant complement and five-parent conics: code to deep holes and obstruction matchings |
| `[4]` | scalar orbitals, golden symmetry completion, and character sums: conic to self-dual schemes |
| `[5]` | stabilizer/Pauli dictionary: scheme classes to quantum error structure |
| `[6]` | canonical coset graph, cliques, and orbitals: derived presentation back to hexagon |

The standard MDS-to-AME construction is the chord `C -> F`, not one of the six sides.  The outside
path is the paper's distinctive contribution: it explains the arithmetic, error geometry, Fourier
algebra, quantum error structure, and reconstruction carried by that tensor presentation.

Two further proved chords enrich rather than replace the spine.  C376 sends the six-point blow-up
to the Clebsch cubic and identifies blowdown exchange with the same `S5/A5` quotient character as
code chirality.  C379 decorates the conic by a perfect matching to reverse its 22-to-one loss; the
binary outer passage exchanges two eleven-matching systems rather than two individual parents.

## A copy-ready Hexagon Spine Theorem

Let `O=Z[tau]`, with `tau^2-tau-1=0`, and let `X_P` be the reduction modulo an odd prime ideal `P`
of the six fivefold axes of the integral projectivized `H3` arrangement.  Let `C_P` be the kernel
of the corresponding `3 x 6` parity-check matrix.

The paper should announce one theorem with six clauses.

1. **Integral orbit and parent code.** Every odd reduction preserves the `6_5,10_3,15_2` mirror
   lattice and faithful projective `A5`; `X_P` is the transitive `A5/D5` six-arc and `C_P` is an
   `[6,3,4]` MDS code.
2. **Exact GRS phase.** The parent is GRS exactly in characteristic five.  At the ramified prime,
   the six source columns are the full rational locus of the invariant conic
   `Q:X^2+Y^2+Z^2=0`.
3. **Deep-hole transform.** At both q=11 split fibres the parent is non-GRS, but its complete
   projective weight-three syndrome locus is `Q(F_11)`.  As a generator-column system this is an
   extended GRS `[12,3,10]_11` child.  Its twelve points all extend the parent to `[7,4,4]` MDS
   kernels and uniform weak degree-two del Pezzo surfaces with one `A1` singularity, while the
   undecorated transform terminates at the next step.  On the complete 22-parent `A5_6` locus, six
   five-parent conics give a perfect matching that recovers the parent; the matchings form two
   `PSL_2(11)`-invariant one-factorizations of `K_12`, exchanged by the golden outer map, with
   complementary `2-(11,5,2)` biplane cross-incidence.  Away from the small exceptional fibres and
   for `q>14`, the larger deep-hole child intrinsically recovers the mirrors and parent.
4. **Fourier syndrome algebra.** At q=11 the eight scalar-closed `A5` syndrome orbits form a
   primitive Fourier-self-dual translation association scheme.  In the intrinsic ordering,
   `P=Q`, `P^2=1331I`, and the entire Krein tensor equals the intersection tensor.  The scheme is
   a rank-eight `A5`-Schurian fission of the rank-four affine orthogonal scheme and has exactly one
   additional proper rank-six fusion.  Adjoining the golden outer map completes `A5` to
   `PGL_2(11)` and gives exactly the rank-four fusion.  The two conjugate rank-eight schemes have a
   Fourier-self-dual rank-16 scalar-`A4` common coherent refinement with an exact four-dimensional
   signed Fourier block.
5. **Intrinsic reconstruction and chirality.** The full automorphism group of the scheme, already
   of its single 60-valent column constituent, is

   ```text
   F_11^3 semidirect (F_11^* x A5).
   ```

   The canonical quotient graph of the bare Hamming code recovers syndrome addition, six
   projective column directions, the degree-six `A5`, and the unordered pair of ten-element
   triple classes.  The outer coset in the order-120 `S6` normalizer exchanges the two classes but
   does not lift within one q=11 fibre.  Blowing up the six points gives the Clebsch cubic, and the
   natural quintic passage between its distinguished double-six blowdowns realizes exactly the
   same quotient character, without choosing a preferred chirality sheet.
6. **Perfect-tensor corollary and GRS separation.** The standard MDS construction produces an
   `A5`-symmetric minimal-support `AME(6,11)` stabilizer state.  Classical syndrome weight becomes
   minimum Pauli-`X` error weight, so the conic and the eight-dimensional Bose--Mesner algebra
   describe exact error sectors of this presentation.  Its 450-entry minimal-support holonomy
   signature differs from all four `PGL_2(11)` orbits of six-point GRS evaluation sets, and its
   exact triple-marginal moments prove local-unitary inequivalence, with party permutation, from
   every such GRS class.

Clauses 1--2 are the C368 arithmetic phase theorem assembled from C339/C341/C346.  Clause 3 combines
C368's parent-to-child theorem with C379's extension, decorated inversion, and
one-factorization/biplane certificate.  Clause 4 combines C341/C372 with C378.  Clause 5 combines
C373's bare-code hand-back to C207 with C376's cubic compatibility.  Clause 6 uses the standard
MDS-to-AME theorem with the preceding exact syndrome identifications and C374's exact LC/LU
separation.  The paper must keep those ownership and prior-art boundaries visible.

## The six proof-bearing sides

### Side 1 — symmetry becomes arithmetic geometry

Define the ordered six columns once over `Z[tau]`.  Establish their `A5/D5` orbit description and
identify their fifteen joins with the reduced `H3` mirrors.  C346 supplies the exact good-reduction
boundary: `(2)` is the unique bad mirror-lattice prime; split, inert, and ramified primes have
different fields of definition but every odd fibre retains the faithful projective `A5`.

This side gives every later object a common integral origin.  The code, conic, scheme, and tensor
must not look like independently chosen examples.

### Side 2 — arithmetic geometry becomes an MDS/GRS code

The twenty three-column minors are the first bridge: their norms are `+/-4`, so every odd fibre is
a six-arc and the parity-check kernel is `[6,3,4]` MDS.  The single quadratic evaluation
determinant

```text
16(3*tau-4),                 norm = -2^8*5,
```

is the second bridge: it vanishes precisely over five and therefore proves the exact GRS phase.
At that fibre the columns equal `Q(F_5)`, not merely a six-point subset of a conic.

The point is not “arcs correspond to MDS codes” or “conics correspond to GRS codes”; both
dictionaries are classical.  The theorem is that one integral orbit determinant controls the
entire arithmetic boundary.

### Side 3 — the code becomes a geometry of hard errors

State the span-weight lemma explicitly:

```text
minimum syndrome weight(s)
  = min {|I| : s lies in the span of the parity-check columns indexed by I}.
```

Thus columns are projective weight-one directions, their fifteen secants are the weight-at-most-two
locus, and the complement is exactly the complete projective weight-three/deep-hole locus.  Every
three columns are a basis, so no decoder convention or covering-radius assumption remains hidden.

At q=11 the complement equals `Q(F_11)`, giving the sharp reversal:

> The errors of the non-Reed--Solomon hexagon organize themselves into a Reed--Solomon code.

Be precise that the child is the generator-column `[12,3,10]` code, not the unrelated kernel
`[12,9,4]` code.

C379 gives this side a second movement.  Every child point grows the parent to a seven-arc, but the
unique six-point conic in each extension produces one effective `E7` root, so the surface is weak
degree two with one `A1` rather than smooth.  The six five-parent conics pair the twelve child
points.  That matching is exactly the datum needed to reverse the transform on the 22-parent
locus.  The 22 matchings then split into two one-factorizations of `K_12`, and their disjointness
matrix is the `2-(11,5,2)` biplane.  This is a particularly reader-friendly surprise: the failed
smooth extension supplies the memory that makes the lossy code transform reversible.

### Side 4 — the deep-hole geometry becomes an eight-class algebra

Lift projective directions to `V=F_11^3` and act by `F_11^* x A5`.  The eight orbit valencies are

```text
1, 60, 100, 120, 150, 300, 300, 300.
```

The 120-class is the scalar lift of the twelve-point deep-hole conic.  The full 512 intersection
numbers prove closure under convolution.

C372 supplies the conceptual reason behind the spectrum.  The reduced `H3` form identifies `V`
with `V*`; scalar-line character sums are integers `11z-ell`; and primal and dual orbits have the
same labels.  Hence `P=Q` and the same eight classes organize differences and Fourier characters.

The fusion lattice is a useful zoom rather than an appendix curiosity.  The rank-six and rank-four
fusions are distinct branches, not a nested chain:

```text
                         rank 8 Clebsch/A5 scheme
                           /                 \
        rank 6 additional exact fusion    rank 4 affine orthogonal fusion
                           \                 /
                              rank 2 trivial fusion.
```

Do not print the full `8 x 8` eigenmatrix in the introduction.  State `P=Q`, the orthogonal fission,
and the error/observable meaning there; give the exact matrix in the theorem section.

C378 supplies the symmetry bridge.  The same integral outer map used for golden conjugation
completes the projective `A5` to the full conic group `PGL_2(11)`, and its three affine nonzero
orbits are exactly the rank-four fusion blocks.  Place the rank-16 common coherent refinement above
the two conjugate rank-eight fissions and show the four-dimensional odd Fourier block explicitly.
Do not say that rank four merely forgets one chirality bit: `J` has a twelve-dimensional fixed
algebra in the rank-16 refinement.

### Side 5 — the algebra becomes quantum error structure

Apply the published MDS-to-minimal-support-AME construction in fixed Pauli conventions.  The
generator rows give `X` stabilizers, parity-check rows give `Z` stabilizers, and classical
parity-check syndromes label Pauli-`X` error sectors.

This makes the Bose--Mesner algebra operationally interpretable, but only up to the theorem actually
proved:

- class-invariant error distributions and transitions convolve in eight dimensions;
- deepest projective `X`-syndrome directions form the conic;
- Fourier self-duality identifies the error-class and character-class geometries.

Do not infer a threshold, channel capacity, experimental advantage, or classification against
arbitrary non-GRS `AME(6,11)` states.  C374 proves exact LC/LU separation from every six-point GRS
class; C375 owns minimal and `A5`-equivariant preparation circuits.

### Side 6 — the derived object returns to the hexagon

From the bare code `C <= F_11^6`, form the canonical quotient graph on `F_11^6/C`, joining two
cosets when their difference contains a weight-one vector.  This is precisely the 60-valent column
graph.

Its maximal eleven-cliques are the allowed affine lines.  The arc property prevents a clique from
mixing directions.  Their six global parallel classes recover the six projective columns.  The
unique regular Sylow-11 translation group recovers syndrome addition up to origin, and the full
graph automorphism group has point stabilizer `F_11^* x A5`.  Its orbitals recover the complete
eight-class scheme; the six-block action recovers the unordered `10+10` triple torsor.

This is the closing theorem.  The derived error graph does not merely remember coarse code
parameters or spectrum: it returns the original exceptional six-point structure and its chirality
obstruction.

The broad affine-rigidity mechanism is prior art through Cara--Rottey--Van de Voorde.  The paper may
give C373's elementary rook-grid proof because it is illuminating, but must not claim the general
odd-prime rigidity theorem as new.  The exact Clebsch recovery, fission, and chirality verdict are
the family-specific content.

## The arithmetic refrain: two conic phases and one outer symmetry

Two statements should recur at the relevant transitions:

> At five, the object becomes classical.  At eleven, its errors do.

More formally:

```text
q=5:   Q is the six-column source orbit       -> GRS parent, empty complement;
q=11:  Q is the twelve-direction deep locus  -> non-GRS parent, GRS child;
q>14:  the larger deep locus                 -> intrinsically recovers the parent.
```

C373 adds the chirality interpretation.  In one q=11 fibre the outer normalizer coset is absent
from the automorphism group, but exactly sixty cross-fibre projectivities exchange the golden-
conjugate `tau=8` and `tau=4` fibres and swap the two ten-sets.  At the ramified prime five, the
roots coalesce and this outer symmetry becomes internal in

```text
A5 < PGL_2(5) ~= S5.
```

That arithmetic passage is now exact:

> The integral involution `J(x,y,z)=(x,-z,-y)` carries the ordered golden model to its conjugate,
> has cocycle square one, specializes to the q=11 outer passage, and lies inside the enhanced
> characteristic-five conic stabilizer.

C377 certifies those identities and specializations, but Benson already owns the general
three-dimensional `A5` outer-Galois descent and trivial Brauer obstruction.  Use C377 as exact
Clebsch glue, not as a new generic descent theorem.  The new q=11 consequences are downstream:
`J` completes the syndrome action to `PGL_2(11)` in C378 and exchanges the two
one-factorizations of the matching-decorated child in C379.

## The “hexagon passport”

A single recurring table can help readers keep their bearings.

| visible data | mathematical identity |
|:---|:---|
| six fivefold axes | `A5/D5` orbit and `[6,3,4]` MDS parent |
| fifteen pairs | secants and projectivized `H3` mirrors |
| twenty triples | two intrinsic ten-element chirality classes |
| twelve q=11 uncovered directions | conic and `[12,3,10]` GRS deep-hole child |
| 22 obstruction matchings | two one-factorizations of `K_12` and the eleven-point biplane |
| eight affine syndrome orbits | primitive Fourier-self-dual translation scheme |
| two golden rank-eight fissions | rank-16 common refinement and rank-four `PGL_2(11)` fusion |
| computational-support superposition | `AME(6,11)` perfect tensor |

## Recommended paper architecture

1. **Prologue: one hexagon, six identities.** Give the picture, the Hexagon Spine Theorem, the
   contribution/prior-art boundary, and a short reader's guide.
2. **Six points, fifteen mirrors.** Define the integral orbit, `A5/D5` action, and `H3` lattice.
3. **The two conic phases.** Prove the minor and conic determinants and the q=5/q=11 arithmetic
   phase theorem.
4. **The blind spot is a conic—and the conic remembers.** Prove the syndrome-span bridge,
   non-GRS-to-GRS deep-hole transform, weak-`E7` extensions, matching-decorated inversion, and the
   two one-factorizations/biplane theorem.
5. **Eight ways to be wrong.** Construct the rank-eight scheme, prove Fourier self-duality, explain
   the branching fusion lattice, and use golden passage to reach the full conic symmetry and
   rank-16 common refinement.
6. **From six columns to six qudits.** State the standard AME construction and identify its exact
   Pauli-`X` error algebra.
7. **Closing the hexagon.** Recover the affine addition, six columns, full `A5`, scheme, and
   unordered chirality torsor from the canonical coset graph; then identify its exchange character
   with the Clebsch cubic's double-six blowdown exchange.
8. **Six unclosed sides.** End with the six future questions below.

“Hexagons are the bestagons” is suitable as an epigraph, talk title, informal subsection tag, or
last line.  A formal paper title should carry the mathematical content, for example:

- *The Clebsch Hexagon: arithmetic phases, Fourier-self-dual syndromes, and perfect tensors*;
- *From a Clebsch MDS code to a self-dual syndrome scheme*; or
- *The Clebsch Hexagon and its deep-hole transform*.

## Style rules: rigorous mathematics that remains fun

- Open each section with one human sentence and one exact bridge proposition.
- Reuse one ordered integral column matrix and record every coordinate change, especially the q=11
  map to the manuscript conic.  Do not make the reader re-identify the object in each language.
- Mark statements as **classical fact**, **theorem proved here**, **corollary**, **interpretation**,
  or **open gate**.  Playfulness must not blur ownership.
- Prefer conceptual proofs in the main text and exact finite certificates as independent checks.
  For C373, the clique/rook-grid proof should lead and equitable refinement should certify it.
- Let the central diagram fill in as the paper proceeds.  Each completed side should visibly hand
  its output to the next proof.
- Use memorable theorem names for genuine structure—“Two Conic Phases,” “The Blind Spot Is a
  Conic,” and “Closing the Hexagon”—while keeping lemma names conventional.
- Credit the classical Clebsch/icosahedral geometry, conic--GRS and MDS--AME dictionaries,
  outer-`S6` `10+10` model, arrangement-to-coset-leader machinery, and general affine rigidity.
- Do not force every list or proof into length six.  The spine is useful because the maps are real,
  not because six is a formatting quota.

## Copy-ready opening

> Six points in a projective plane seem too small to sustain much geometry.  The Clebsch hexagon
> disagrees.  Its fifteen joins form the projectivized `H3` reflection arrangement; its twenty
> triples divide into two opposite icosahedral classes; and over `F_11` the directions missed by
> those joins form a conic.  The same six points define a non-Reed--Solomon MDS code and hence a
> six-party perfect tensor.  We prove that its affine syndrome orbits form a primitive
> Fourier-self-dual rank-eight association scheme and, conversely, that the canonical coset graph
> of the unmarked code recovers the six columns and their unordered chirality torsor.  The conic
> initially forgets 22 possible parents, yet six elementary obstruction pairs restore the chosen
> one; taken together, those matchings form two one-factorizations whose cross-incidence is an
> eleven-point biplane.  These are not numerical coincidences but different shadows of one integral
> `A5`-symmetric object.

## Publication strength and broad interest

C368 and C372--C379 now give a closed pure-mathematical spine with a substantial gateway layer:

- an all-odd-prime arithmetic phase theorem;
- an exact non-GRS-parent-to-GRS-deep-hole-child transform;
- a primitive Fourier-self-dual rank-eight `A5` fission with complete fusion data;
- a full automorphism theorem and intrinsic recovery of affine addition, the hexagon, and its
  unordered chirality torsor from the bare-code coset graph;
- the equality of Clebsch-cubic blowdown exchange and code chirality as one quotient character;
- golden completion to `PGL_2(11)`, a rank-16 common refinement, and a signed Fourier sector; and
- a reversible matching-decorated child whose 22 parents form two one-factorizations with biplane
  cross-incidence.

That is an A-range mathematical core with serious entry points for finite geometry, coding theory,
algebraic combinatorics, representation theory, and quantum information.  C374 supplies a proved
quantum capstone; C375's circuit question remains optional and is not a prerequisite for the
paper's mathematical identity.

The principal limitation is generality and source disposition: this remains one exceptional object
over a special field, and the classical one-factorization/biplane literature still needs focused
closure.
For the broadest general-mathematics audience, one portable theorem would materially raise the
ceiling.  The best candidates are a general reflection-orbit MDS phase mechanism, a classification
of non-GRS-to-GRS deep-hole transforms, a reusable criterion for Fourier-self-dual orbit fissions,
or the golden outer/Galois phase theorem.

If the rank-eight fission is eventually identified with a known scheme, the paper remains strong:
the exact arithmetic transform, self-dual error algebra, closed reconstruction cycle, and C374's
proved separation from every six-point GRS `AME` class do not depend on standalone-scheme priority.

## Six future directions, one for each unclosed side

These are natural because each asks whether a proved map generalizes, inverts, classifies, or has
operational force.  The bare-code reconstruction question is no longer open after amended C373.

### 1. How exceptional is the integral hexagon?

Classify integral reflection-group orbits in `P^2` whose maximal minors remain units away from a
finite bad-prime set and whose conic-incidence determinant has a controlled arithmetic support.
Does the `H3/A5` construction belong to a general Coxeter-orbit source of uniformly MDS codes?

### 2. When do non-GRS errors become GRS?

Characterize rank-three non-GRS MDS codes whose complete maximum-weight projective syndrome locus
is itself an arc, conic, or rational-normal-curve projective system.  Determine when the deep-hole
transform is MDS or GRS, when it terminates, and when a canonical obstruction decoration recovers
its parent.  C381 has completed the bounded two-point continuation: its three marked integral root
types `(D8,A2)`, `(3A1,2A1)`, and `(4A1,2A1)` recover the obstruction matching and decide MDS
status, while the inherited six-conic obstruction rules out a smooth degree-one surface.  C382 is
now ready to compare the marked `D8<E8` embedding, glue, and centralizer data with the icosian model;
an abstract `E8` isomorphism remains a red result.

### 3. When does a deep-hole child carry a factorization double cover?

Generalize C379's decomposition of 22 parent matchings into two `PSL_2(11)`-invariant
one-factorizations.  Determine which conic children canonically carry such an unordered pair,
whether Frobenius acts on it arithmetically, and when cross-incidence produces a biplane or another
symmetric design.  The finite q=11 theorem is certified; its classical-source disposition and any
all-prime transport remain open.

### 4. Why is the syndrome algebra an eight-class fission?

Decide separability and give a conceptual geometric or group-theoretic meaning to the unexplained
rank-six fusion.  Explain the rank-16 common refinement and four-dimensional signed Fourier block
representation-theoretically, and determine whether the Clebsch pair of fissions occurs in a wider
family.  Identify which intersection, spectral, fusion, or automorphism data characterize it up to
combinatorial isomorphism.

### 5. Does the chiral self-dual error algebra have operational force?

Split the twenty minimum-weight leaders of each farthest coset into the intrinsic `10+10` support
classes and compute their sheetwise incidence or transition algebras.  Continue only if the
refinement yields an exact design, robustness, list-decoding, Pauli-channel, mixing, or observable-
estimation invariant beyond known multiple-covering and orbit-compression theory.

### 6. How far does the intrinsic Clebsch tensor structure extend?

C374 proves local-Clifford and general local-unitary inequivalence, with party permutation, from
every six-point GRS presentation.  Classify the state relative to other non-GRS `AME(6,11)` classes
only if a finite exact invariant supplies a bounded family.  Independently, determine whether a
minimal three-two-site-gate preparation exists and whether it can implement the `A5` action
equivariantly.  An exact circuit and a symmetry-forced obstruction are both successful answers.

## Claim boundary for the final manuscript

Already classical or externally pre-empted:

- the Clebsch/icosahedral six-point geometry and `10+10` outer-`S6` dictionary;
- arc--MDS, conic--GRS, and MDS--AME correspondences;
- general arrangement-to-coset-leader machinery;
- generic automorphism-aided decoding; and
- general odd-prime affine rigidity of spanning arc-direction graphs;
- general outer-Galois descent of the golden three-dimensional `A5` representation; and
- the classical `PGL_2(11)`, one-factorization, and eleven-point biplane ingredients, pending exact
  source attribution.

Exact family-specific content established locally:

- the all-odd arithmetic phase theorem and characteristic-five determinant boundary;
- the q=11 non-GRS-parent/deep-hole-conic/GRS-child transform;
- the primitive Fourier-self-dual rank-eight `A5` fission, exact eigen/Krein data, and all fusions;
- the exact full automorphism group of the scheme and column graph;
- intrinsic recovery of syndrome addition, the six columns, deep-hole relation, and unordered
  chirality torsor from the canonical bare-code coset graph; and
- the equality of cubic blowdown exchange and code chirality as quotient characters;
- q=11 golden completion to `PGL_2(11)`, the rank-16 common coherent refinement, and its signed
  four-dimensional Fourier block;
- exact LC and LU separation, with party permutation, of the Clebsch `AME(6,11)` state from every
  six-point GRS class;
- twelve uniform weak-degree-two-del-Pezzo extensions and termination of the undecorated deep-hole
  transform; and
- reversible parent recovery by 22 obstruction matchings, their two one-factorizations, and the
  exact `2-(11,5,2)` biplane cross-incidence; and
- C381's three marked integral `E8` root types and their exact recovery of the matching, parent,
  and MDS status.

Not yet safe without the stated gates:

- that the rank-eight fission is new or separable;
- classification of the Clebsch state against arbitrary non-GRS `AME(6,11)` classes;
- that the tensor has a new minimal or equivariant circuit;
- that Fourier self-duality improves a physical noise or decoding quantity;
- that the C379 one-factorization/biplane compatibility is new before focused source closure;
- an intrinsic all-prime Frobenius action on the fission or factorization two-set;
- any icosian/path-independence theorem before C382 clears its marked-embedding, representation,
  consequence, and literature gates; or
- any Clebsch holographic-code claim.

## Copy-ready closing cadence

> The Clebsch hexagon begins as six points, becomes a code, turns its failures into a conic, and
> organizes those failures into a Fourier-self-dual algebra.  The process is reversible: the
> canonical coset graph returns the six directions and their two icosahedral triple classes, while
> an obstruction matching lets the conic return any one of its 22 Clebsch parents.  Those matchings
> arrange themselves into two one-factorizations and an eleven-point biplane.  At characteristic
> five the hexagon itself is the conic; at eleven its blind spot is—and even the blind spot
> remembers.  The six open questions above ask how much of this cycle belongs to the exceptional
> hexagon and how much is the first visible instance of a wider theory.

In this precise and unusually literal sense, hexagons are the bestagons.

## Local theorem sources

- `notes/2026-07-19-c368-h3-a5-arithmetic-phase.md`
- `notes/2026-07-19-c372-clebsch-scheme-fourier.md`
- `notes/2026-07-19-c373-clebsch-scheme-automorphisms.md`
- `notes/2026-07-19-c374-clebsch-ame-equivalence.md`
- `notes/2026-07-19-c376-clebsch-cubic-chirality.md`
- `notes/2026-07-19-c377-clebsch-golden-descent.md`
- `notes/2026-07-19-c378-clebsch-common-duality.md`
- `notes/2026-07-19-c379-clebsch-deep-hole-extension.md`
- `notes/2026-07-19-c379-one-factorization-biplane-companion.md`
- `notes/2026-07-19-c380-clebsch-gateway-lean-foundations.md`
- `notes/2026-07-19-c381-clebsch-e8-extension-obstruction.md`
- `notes/2026-07-19-c382-clebsch-icosian-e8-path-independence.md`
- `notes/2026-07-18-c339-clebsch-deep-hole-transform.md`
- `notes/2026-07-18-c341-a5-subgroup-decoder.md`
- `notes/2026-07-18-c346-h3-clebsch-good-reduction.md`
- `notes/2026-07-19-c371-clebsch-cross-field-literature-audit.md`
