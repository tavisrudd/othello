# Hexagons are the bestagons: a narrative and proof spine for the Clebsch paper

**Lane:** `crowns`

**Date:** 2026-07-19

**Status:** exposition blueprint updated through C368, C372, and the amended C373

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
> hexagon and its unordered `10+10` chirality torsor.

Applying the standard MDS-to-AME construction adds the quantum reading:

> The same hexagon presents an `A5`-symmetric `AME(6,11)` perfect tensor whose Pauli-`X` error
> sectors carry that self-dual eight-class algebra.

The second sentence is a structured presentation and error-algebra theorem.  It is not yet a claim
of a new local-Clifford or local-unitary AME class.

## The picture to show the reader

```text
                       (1) integral H3/A5 six-orbit
                         /                         \
              good reduction                       minors and determinant
                       /                               \
          (6) recovered hexagon                 (2) arc / MDS parent
             and 10+10 torsor                       |             \
                       |                    minimum spans       MDS-to-AME
               clique and orbital                     |               \
                  reconstruction              (3) secant arrangement   AME(6,11)
                       |                              |                 /
          (5) Fourier-self-dual              complement at q=11      /
              rank-eight scheme                      |               /
                         \                    (4) deep-hole conic    /
                          \________________ scalar-orbit lift ______/
```

The diagonal `MDS -> AME` is standard.  The outside path is the paper's distinctive contribution:
it explains the arithmetic, error geometry, Fourier algebra, and reconstruction carried by that
particular tensor presentation.

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
   extended GRS `[12,3,10]_11` child.  Away from the small exceptional fibres and for `q>14`, the
   larger deep-hole child intrinsically recovers the mirrors and parent.
4. **Fourier syndrome algebra.** At q=11 the eight scalar-closed `A5` syndrome orbits form a
   primitive Fourier-self-dual translation association scheme.  In the intrinsic ordering,
   `P=Q`, `P^2=1331I`, and the entire Krein tensor equals the intersection tensor.  The scheme is
   a rank-eight `A5`-Schurian fission of the rank-four affine orthogonal scheme and has exactly one
   additional proper rank-six fusion.
5. **Intrinsic reconstruction and chirality.** The full automorphism group of the scheme, already
   of its single 60-valent column constituent, is

   ```text
   F_11^3 semidirect (F_11^* x A5).
   ```

   The canonical quotient graph of the bare Hamming code recovers syndrome addition, six
   projective column directions, the degree-six `A5`, and the unordered pair of ten-element
   triple classes.  The outer coset in the order-120 `S6` normalizer exchanges the two classes but
   does not lift within one q=11 fibre.
6. **Perfect-tensor corollary.** The standard MDS construction produces an `A5`-symmetric
   minimal-support `AME(6,11)` stabilizer state.  Classical syndrome weight becomes minimum
   Pauli-`X` error weight, so the conic and the eight-dimensional Bose--Mesner algebra describe
   exact error sectors of this presentation.

Clauses 1--3 are the C368 arithmetic phase theorem assembled from C339/C341/C346.  Clause 4 is
C341/C372.  Clause 5 is C373 with the bare-code hand-back to C207.  Clause 6 uses the standard
MDS-to-AME theorem with the preceding exact syndrome identifications.  The paper must keep those
ownership and prior-art boundaries visible.

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

### Side 5 — the algebra becomes quantum error structure

Apply the published MDS-to-minimal-support-AME construction in fixed Pauli conventions.  The
generator rows give `X` stabilizers, parity-check rows give `Z` stabilizers, and classical
parity-check syndromes label Pauli-`X` error sectors.

This makes the Bose--Mesner algebra operationally interpretable, but only up to the theorem actually
proved:

- class-invariant error distributions and transitions convolve in eight dimensions;
- deepest projective `X`-syndrome directions form the conic;
- Fourier self-duality identifies the error-class and character-class geometries.

Do not infer a threshold, channel capacity, experimental advantage, or a new AME equivalence class.
C374 owns local-Clifford/local-unitary classification; C375 owns minimal and `A5`-equivariant
preparation circuits.

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

This motivates a strong future theorem:

> Golden conjugation is an external chirality symmetry between split fibres, becomes semilinear
> after inert descent, and becomes internal linearly exactly at the ramified GRS phase.

Only the q=11 split and q=5 ramified clauses are currently certified.  The all-good-prime statement
requires a symbolic outer intertwiner, its cocycle square, and its inert-prime specialization.

## The “hexagon passport”

A single recurring table can help readers keep their bearings.

| visible data | mathematical identity |
|:---|:---|
| six fivefold axes | `A5/D5` orbit and `[6,3,4]` MDS parent |
| fifteen pairs | secants and projectivized `H3` mirrors |
| twenty triples | two intrinsic ten-element chirality classes |
| twelve q=11 uncovered directions | conic and `[12,3,10]` GRS deep-hole child |
| eight affine syndrome orbits | primitive Fourier-self-dual translation scheme |
| computational-support superposition | `AME(6,11)` perfect tensor |

## Recommended paper architecture

1. **Prologue: one hexagon, six identities.** Give the picture, the Hexagon Spine Theorem, the
   contribution/prior-art boundary, and a short reader's guide.
2. **Six points, fifteen mirrors.** Define the integral orbit, `A5/D5` action, and `H3` lattice.
3. **The two conic phases.** Prove the minor and conic determinants and the q=5/q=11 arithmetic
   phase theorem.
4. **The blind spot is a conic.** Prove the syndrome-span bridge and non-GRS-to-GRS deep-hole
   transform.
5. **Eight ways to be wrong.** Construct the rank-eight scheme, prove Fourier self-duality, and
   explain the branching fusion lattice.
6. **From six columns to six qudits.** State the standard AME construction and identify its exact
   Pauli-`X` error algebra.
7. **Closing the hexagon.** Recover the affine addition, six columns, full `A5`, scheme, and
   unordered chirality torsor from the canonical coset graph.
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
> of the unmarked code recovers the six columns and their unordered chirality torsor.  These are not
> numerical coincidences but different shadows of one integral `A5`-symmetric object.

## Publication strength and broad interest

C368, C372, and C373 now give a closed pure-mathematical spine rather than a proposed one:

- an all-odd-prime arithmetic phase theorem;
- an exact non-GRS-parent-to-GRS-deep-hole-child transform;
- a primitive Fourier-self-dual rank-eight `A5` fission with complete fusion data;
- a full automorphism theorem and intrinsic recovery of affine addition, the hexagon, and its
  unordered chirality torsor from the bare-code coset graph.

That is an A-range mathematical core with serious entry points for finite geometry, coding theory,
algebraic combinatorics, representation theory, and quantum information.  C374/C375 are quantum
capstones, not prerequisites for the paper's mathematical identity.

The principal limitation is generality: this remains one exceptional object over a special field.
For the broadest general-mathematics audience, one portable theorem would materially raise the
ceiling.  The best candidates are a general reflection-orbit MDS phase mechanism, a classification
of non-GRS-to-GRS deep-hole transforms, a reusable criterion for Fourier-self-dual orbit fissions,
or the golden outer/Galois phase theorem.

If the rank-eight fission is eventually identified with a known scheme and the AME state proves
equivalent to a standard Reed--Solomon state, the paper remains strong: its contribution is then
the exact arithmetic transform, self-dual error algebra, and closed reconstruction cycle rather
than priority for new standalone objects.

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
transform is MDS or GRS and when it recovers its parent.

### 3. Where does the outer symmetry live arithmetically?

Construct the symbolic golden-conjugate outer intertwiner over `Z[tau]`, compute its cocycle square,
and prove the split/inert/ramified trichotomy suggested by C373: cross-fibre projective at split
primes, internal semilinear after inert descent, and internal linear at the ramified characteristic-
five GRS phase.

### 4. Why is the syndrome algebra an eight-class fission?

Decide separability and give a conceptual geometric or group-theoretic meaning to the unexplained
rank-six fusion.  Determine whether the Clebsch fission occurs in a wider family and which of its
intersection, spectral, fusion, or automorphism data characterize it up to combinatorial
isomorphism.

### 5. Does the chiral self-dual error algebra have operational force?

Split the twenty minimum-weight leaders of each farthest coset into the intrinsic `10+10` support
classes and compute their sheetwise incidence or transition algebras.  Continue only if the
refinement yields an exact design, robustness, list-decoding, Pauli-channel, mixing, or observable-
estimation invariant beyond known multiple-covering and orbit-compression theory.

### 6. Is the perfect tensor intrinsically Clebsch?

Decide local-Clifford equivalence, with party permutation, between the Clebsch `AME(6,11)` state
and standard Reed--Solomon presentations; use finite exact invariants before any LU claim.  Then
determine whether a minimal three-two-site-gate preparation exists and whether it can implement
the `A5` action equivariantly.  An exact equivalence map and a symmetry-forced obstruction are both
successful answers.

## Claim boundary for the final manuscript

Already classical or externally pre-empted:

- the Clebsch/icosahedral six-point geometry and `10+10` outer-`S6` dictionary;
- arc--MDS, conic--GRS, and MDS--AME correspondences;
- general arrangement-to-coset-leader machinery;
- generic automorphism-aided decoding; and
- general odd-prime affine rigidity of spanning arc-direction graphs.

Exact family-specific content established locally:

- the all-odd arithmetic phase theorem and characteristic-five determinant boundary;
- the q=11 non-GRS-parent/deep-hole-conic/GRS-child transform;
- the primitive Fourier-self-dual rank-eight `A5` fission, exact eigen/Krein data, and all fusions;
- the exact full automorphism group of the scheme and column graph;
- intrinsic recovery of syndrome addition, the six columns, deep-hole relation, and unordered
  chirality torsor from the canonical bare-code coset graph; and
- the exact q=11 split-fibre and q=5 ramified outer-symmetry behavior.

Not yet safe without the stated gates:

- that the rank-eight fission is new or separable;
- that the AME state is a new LC or LU class;
- that the tensor has a new minimal or equivariant circuit;
- that Fourier self-duality improves a physical noise or decoding quantity;
- the proposed all-good-prime outer/Galois phase; or
- any Clebsch holographic-code claim.

## Copy-ready closing cadence

> The Clebsch hexagon begins as six points, becomes a code, turns its failures into a conic, and
> organizes those failures into a Fourier-self-dual algebra.  The process is reversible: the
> canonical coset graph returns the six directions and their two icosahedral triple classes.  At
> characteristic five the hexagon itself is the conic; at eleven its blind spot is.  The six open
> questions above ask how much of this cycle belongs to the exceptional hexagon and how much is the
> first visible instance of a wider theory.

In this precise and unusually literal sense, hexagons are the bestagons.

## Local theorem sources

- `notes/2026-07-19-c368-h3-a5-arithmetic-phase.md`
- `notes/2026-07-19-c372-clebsch-scheme-fourier.md`
- `notes/2026-07-19-c373-clebsch-scheme-automorphisms.md`
- `notes/2026-07-18-c339-clebsch-deep-hole-transform.md`
- `notes/2026-07-18-c341-a5-subgroup-decoder.md`
- `notes/2026-07-18-c346-h3-clebsch-good-reduction.md`
- `notes/2026-07-19-c371-clebsch-cross-field-literature-audit.md`
