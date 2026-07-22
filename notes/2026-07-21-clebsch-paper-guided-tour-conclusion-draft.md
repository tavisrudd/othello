# Clebsch paper: guided-tour and conclusion prose draft

**Lane:** `clebsch`

**Date:** 2026-07-21

**Status:** manuscript-facing prose draft for the selected factorization-memory paper.  It does
not edit or supersede the protected manuscript.  The final source pass must insert theorem,
section, figure, artifact, and bibliography references and conform notation to the manuscript.

## A guided tour: what the conic forgets

The reconstruction problem of this paper begins with a tension.  On one hand, the projective
deep-hole locus of the Clebsch code is exceptionally rigid: among six-arcs in
`PG(2,11)`, its containment in a conic determines the Clebsch class and recovers the group `A5`.
On the other hand, the conic itself is a familiar object.  Its twelve rational points support the
extended Reed--Solomon code, and the bare conic carries no record of which six-point parent
produced it.  Thus the same passage is rigid globally and forgetful internally.  The purpose of
this section is to describe, before entering the proofs, exactly what is lost and how it returns.

For a redundancy-three MDS code, the columns of a parity-check matrix form an arc in a projective
plane.  A syndrome direction has weight one if it is a column, weight two if it lies on a chord of
the arc, and weight three if it is missed by every chord.  The projective deep-hole locus is
therefore the uncovered locus of the arc.  For the Clebsch six-arc this locus consists of all
twelve points of a nonsingular conic.  Taking those directions as a projective system gives the
canonical conic code, but it also performs the first forgetting operation in the paper: the
resulting unmarked GRS child does not retain a preferred secant matching, a preferred parent, or an
orientation of the two parent sheets.

This phenomenon is not introduced as an isolated accident at eleven.  The irreducible
rank-three Coxeter systems `A3`, `B3`, and `H3` have Coxeter numbers `4`, `6`, and `10`.  At the
fields

```text
q=h+1=5,7,11,
```

the complement of the projectivized reflection arrangement is the full rational conic.  More
generally, the three complement codes have one common length and distance law, with the Coxeter
number controlling both the extremal nonmirror line and the conic specialization.  The Coxeter
square has order `(q-1)/2` and generates the split maximal torus in `PSL_2(q)`; its two moving
orbits are the two Legendre cosets.  The three small fields are therefore the complete rank-three
phase, not three examples chosen after the fact.  The A3 case is the fused control, B3 is the
root-length-defect case, and H3 is the case in which the lost factorization data reconstruct the
Clebsch parent.

The basic algebraic operation is elementary.  A perfect matching `M` of the `q+1` conic points
determines a product `P_M` of its secant lines.  Every conic point occurs exactly once, so after a
canonical scaling the restrictions of all such products to the conic agree.  Consequently

```text
P_M-P_N
```

is divisible by the conic equation `Q` for every two matchings `M,N`.  Restriction has forgotten
the pairing, but the quotient

```text
(P_M-P_N)/Q
```

retains a controlled residue of it.  Applied to the Coxeter-selected matching orbits, these
quotients have ranks `3`, `6`, and `10` for A3, B3, and H3.  Their images are described uniformly
by the top conic-harmonic layer, together with the radial line in even degree.  This is the first
recovery step: one passes from an equality on the conic to a nontrivial configuration in its
ideal quotient.

In B3 and H3 the matching orbit splits into two `PSL_2(q)` sheets exchanged by the outer coset of
`PGL_2(q)`.  Nothing linear distinguishes them: the sums of the quotient points on the two sheets
are equal.  Their second tensor moments are equal as well.  These cancellations are not evidence
that the quotient has forgotten the sheets.  They characterize them.  Among the complementary
halves of the quotient configuration, the two sheets are the unique pair with equal first and
second moments.  Thus quadratic data recover the unordered partition, although they cannot choose
one half.

The primary meaning of the “bit” in this paper is this unchosen two-element set: a `C2`-torsor on
which the outer coset acts freely.  An orientation is a choice of one sheet, and one bit of advice
is the data of such a choice.  The cubic below detects the corresponding quotient character.  No
entropy interpretation is intended without an additional probability distribution, and the term
does not assert that every functorial image of the parent retains the torsor.

The first orientation appears one degree later.  Give the two sheets opposite signs and form their
signed tensor moments.  The moments in degrees one and two vanish, while the degree-three moment
is nonzero.  After compression to the six H3 profiles, antipodality kills every even signed moment
and the primitive weighted relation with coefficients `1:4:6` kills degree one.  Cubic survival
is therefore forced rather than observed.  The resulting cubic tensor is fixed by `PSL_2(q)` and
negated by the outer coset;
inside the conic group, its stabilizer is exactly `PSL_2(q)`, while its projective line is fixed by
`PGL_2(q)`.  In this precise moment sense, degree two recovers the two alternatives and degree
three orients them.

> **Orbit-fission principle.** Suppose an index-two orbit split has the sheet-sign line as the
> entire kernel of its degree-two feature map.  Then quadratic data intrinsically recover the
> unordered sheets.  If the quotient character first occurs in symmetric degree three, the
> resulting cubic anti-invariant orients them.

In the present paper this is an organizing sentence, not an additional theorem schema: the
radical--Hadamard theorem supplies the exact degree-two hypothesis, and the signed-moment and
parity theorems supply the cubic conclusion.  **TODO(xref):** replace this sentence by the final
theorem labels and exact feature-map notation.

For H3, a second compression makes the reconstruction visible without listing all twenty-two
matchings.  Let `G=PGL_2(11)`, let `H=A5` be a matching stabilizer, and let `K=A4` be the common
scalar subgroup.  The mixed double-coset space

```text
K \ G / H
```

has six elements.  On each sheet, subgroup marks give three `K`-orbits of sizes `1`, `4`, and
`6`.  One canonical secant-incidence calculation on each double-coset representative produces
six distinct depth profiles,

```text
v_1, v_4, v_6, -v_1, -v_4, -v_6,
```

with multiplicities `1,4,6 / 1,4,6`.  The positive profiles lie in a plane and satisfy the
primitive barycentre relation

```text
v_1+4v_4+6v_6=0.
```

This small relation contains the same cubic threshold as the full quotient configuration.  Its
signed first moment is zero, its even moments cancel across opposite profiles, and a cubic
coordinate is nonzero.  The profile map has rank two and a four-dimensional linear kernel, but it
separates the six double-coset labels as a set.  The rank drop is not accidental: in
characteristic eleven, an eleven-point sheet is the projective cover `P(1)` with Loewy layers
`1|9|1`, and the depth plane is `P(1)^A4` modulo its socle.

The complete information flow can now be read from one diagram.

> **Figure: the reconstruction arc.** The Clebsch parent and its secant matching map to the
> full-conic GRS child, which forgets pairing and orientation.  Dividing secant-product
> differences by `Q` gives twenty-two quotient points.  Balanced first and second moments recover
> the unique unordered `11+11` partition; the signed cubic orients it.  The `A4` depth map
> compresses the twenty-two points to six profiles of sizes `1,4,6 / 1,4,6`.  A singleton profile
> recovers the matching, and the decorated matching recovers the parent.

The singleton profiles are the final step.  Each identifies one of the two golden matchings, and
the matching-decorated recovery theorem returns the corresponding Clebsch parent.  Without a
chosen sheet the construction recovers the unordered golden pair; choosing a sheet and its
singleton matching selects one parent.  The sequence

```text
22 -> 6 -> 2 -> 1
```

is therefore an information ledger: twenty-two decorated alternatives, six depth labels, two
oriented sheets, and one chosen parent.  It is not a chain of faithful linear quotients.  Each
arrow records a different kind of information loss or recovery: an orbit map, a linear image, a
torsor quotient, a forgetting map, or a choice of section.  In particular, the two-dimensional
profile plane is not the same object as the two-element sheet set.

The two golden sheets also have an arithmetic origin.  A characteristic-zero golden matching
reduces at the two primes above eleven to the two singleton matchings.  Their `A5` stabilizers
meet in the same `A4` and together generate `PSL_2(11)`.  A rational rotation of spinor norm two
reduces to the outer element exchanging them; the common octahedral `S4`, with determinant kernel
`A4`, is the local gluing hinge.  The A3 and B3 controls show respectively projective fusion and
silver splitting.  This gives the rank-three story a closing arithmetic theorem without requiring
the quaternionic and descent mechanisms developed in the sequel.

Not every natural passage preserves the oriented bit, and this is part of the result.  The
cross-sheet incidence designs retain exact quadratic-residue shadows and generate perfect binary
Hamming and ternary Golay-parameter codes.  Golden reduction is visible or fused according to an
exact law modulo forty.  By contrast, theta parity agrees on the two sheets, and the associated golden
quantum states are locally unitary equivalent even with the party labels fixed.  The Fourier
matrices used in the reconstruction are restrictions of one ambient Weil Weyl operator, but the
restricted spaces are not small Weil modules.  These positive and negative statements delimit
the bit more sharply than a list of analogies could: the paper identifies which structures retain
orientation, which retain only an unordered shadow, and which erase it completely.

The remainder of the paper proves the arrows in this order.  We first establish the Clebsch
rigidity theorem and the rank-three Coxeter phase.  We then construct the conic-ideal quotient,
prove balanced-sheet uniqueness and cubic-first orientation, derive the six profiles from double
cosets, and reconstruct the parent.  The final sections prove the arithmetic gluing theorem,
record the survival/forgetting ledger, and give the formal and computational trust map for every
claim.

## Conclusion: from reconstruction to mechanism

The projective deep-hole conic of the Clebsch code is both rigid and forgetful.  As an unmarked
locus it characterizes the parent among six-arcs of `PG(2,11)`, yet as a conic code it retains no
preferred secant pairing or orientation.  The conic ideal resolves this tension.  Secant-product
differences vanish on the child but survive after division by its equation; their quotient
configuration recovers the unique unordered sheets from second moments, orients them in degree
three, compresses them to six double-coset profiles, and recovers the decorated parent from the
singleton fibres.  The result is a closed reconstruction chain in which every information loss
and every recovery step is explicit.

The rank-three Coxeter phase shows why this chain belongs to a complete small family.  The
reflection-complement codes for A3, B3, and H3 obey one distance law and become conic codes at
`q=h+1`.  Their matching data fuse in the A3 control, split through the silver primes in B3, and
split through the golden primes in H3.  In the last case the two stabilizers meet along `A4`,
generate `PSL_2(11)`, and are exchanged through the rational `S4/A4` hinge.  Thus the exceptional
field eleven is not treated as an unexplained numerical coincidence: it is the apex of the
rank-three construction and the point at which factorization memory returns the Clebsch parent.

The survival ledger also gives a precise boundary to the reconstruction.  Quadratic-residue
designs and perfect-code spans retain certified shadows of the sheet geometry, and golden
reduction obeys a visible/fused law modulo forty.  Theta parity does not orient the sheets.  The
golden quantum states are locally unitary equivalent, even with fixed parties.  The relevant
Fourier operators are projectively Weil, but the quotient spaces are not the conjectured small
Weil modules, and no Klein five-space supplies the missing linear bridge.  These failures are not
exceptions to be repaired inside the present argument.  They show that orientation is carried by
specific comparison data rather than by every natural invariant of the objects involved.

This is the point of departure for the sequel.  Several parts of the arithmetic mechanism are
already exact.  The two H3 sheets arise as reductions of one icosian maximal order at the two
golden primes; the B3 sheets have the analogous binary-octahedral description.  The golden
six-arc has a unique quadratic descent with rational stabilizer `S3`, while its missing choice is
encoded by a resolvent and by companion torsors.  The mod-forty law is realized on the tested
golden-split primes by the rational octahedral hinge: the sheets fuse precisely when that `S4`
lies in `PSL_2(q)`, equivalently when `(2/q)=+1`.  At prime 31, the Klein cubic supplies a separate
arithmetic carrier in which the golden cyclotomic field and `Q(sqrt(-11))` act together on one
irreducible octic factor, but its zeta data are blind to the fusion bit.

Paper 2 therefore does not begin by asserting that all these structures are the same.  The
literal incidence-module, theta, Klein-five-space, and quantum-identification versions of that
claim are false.  Its problem is narrower and more structural: to determine which arithmetic or
metaplectic comparison maps carry the orientation character, how the quaternionic reductions,
descent torsors, quadratic characters, and ambient Weil operator fit into one functorial picture,
and why other natural passages erase the same bit.  The present paper supplies the object to be
explained, its minimal signed-moment detector, its reconstruction theorem, and a certified list of
the shadows that any such explanation must preserve or deliberately forget.
