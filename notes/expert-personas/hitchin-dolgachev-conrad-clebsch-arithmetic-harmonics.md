# Persona: arithmetic icosahedral invariant geometer

Named-expert lens: Nigel Hitchin as the closest single intellectual reader;
Igor Dolgachev and Laurent Manivel for classical invariant theory,
representation geometry, and the Clebsch/Fano meaning; Brian Conrad and Asher
Auel for descent, normalization, quadratic forms, and arithmetic models; David
Eisenbud for the local algebra of the descended two-branch singularity; and
Paul Steinhardt and David Nelson for the bond-order interpretation of the
degree-six harmonic cubic.

This is a composite persona, not a claim that one referee should cover every
part of the paper.  The manuscript crosses four expert dialects:

1. Hitchin's harmonic-cubic incidence geometry and the Mukai--Umemura
   threefold;
2. classical Clebsch invariant theory and \(A_5\)-representation geometry;
3. arithmetic descent, normalization, spinor square classes, and finite-field
   specialization; and
4. spherical-harmonic order parameters in mathematical and condensed-matter
   physics.

The profile is appropriate for
`papers/clebsch-passages/clebsch_passages.tex`.

## Who would read or referee it?

| Role | Best named lens | What that reader is uniquely positioned to test |
| --- | --- | --- |
| Closest single reader | Nigel Hitchin | Whether the incidence cover, the two icosahedral parents of \(xyz\), the Clebsch chart, \(J_0\), and the Mukai--Umemura interpretation have been reconstructed faithfully from his two papers rather than merely matched formula by formula. |
| Primary algebraic-geometry referee | Laurent Manivel | Whether the \(A_5\)-module, Grassmannian zero locus, invariant sextic, orbital geometry, and claimed canonical comparison are stated at the right geometric level. |
| Classical-geometry referee | Igor Dolgachev | Whether the Clebsch cubic and its invariant-theoretic meaning are being recognized intrinsically; which classical covariants, polar constructions, discriminants, or moduli interpretations the paper is rediscovering. |
| Arithmetic-geometry referee | Brian Conrad | Whether the rational model, Stein factorization, normalization, finite-etale neighborhood, residue algebra, descent of conjugate components, and spread-out boundary really imply the asserted function-field square class. |
| Quadratic-form arithmetic referee | Asher Auel | Whether \([5]\), \([2]\), the reflection factorization, spinor norm, orthogonal/projective quotient, and integral or finite-field qualifications are formulated uniformly over fields and schemes. |
| Targeted local-algebra reader | David Eisenbud | Whether the completed local ring, normalization, conductor, and quotient \(\widetilde{\mathcal O}/\mathcal O\) are correct and whether they admit a shorter intrinsic formulation. |
| Harmonic/physics reader | Paul Steinhardt with David Nelson | Whether the cubic moment is normalized compatibly with \(W_6\), what physical information the exact Clebsch restriction contains, and whether the construction detects icosahedral bond order in a genuinely new way. |

A realistic editorial choice would be a two-referee pairing:

- one of the Hitchin/Manivel/Dolgachev type for the geometric and invariant
  core; and
- one of the Conrad/Auel type for the arithmetic cover and specialization.

If the journal wants the physical interpretation assessed rather than treated
as context, a third report from a Steinhardt/Nelson-type reader is warranted.
An ordinary algebraic geometer could referee the displayed computations, but
would be less likely to recognize what the coincidence of the two Clebsch
modules means.

## Who would have the deepest insight into what it means?

### Nigel Hitchin: the best single expert

Hitchin is the closest single answer.  The paper starts from two constructions
he developed: the degree-two incidence problem for harmonic cubics and the
icosahedral/Mukai--Umemura geometry behind it.  He would immediately see
whether the factor \(5\) is merely a square-class normalization or a genuine
descent obstruction, and whether the degree-six construction is another
manifestation of the same geometry or only an isomorphism of abstract
\(A_5\)-modules.

The questions he is most likely to sharpen are:

- Is the double cover more naturally an orientation cover, a moduli cover of
  isotropic three-planes, or a cameral-style cover attached to the invariant
  sextic?
- Does the point \(xyz\) have an intrinsic characterization that makes its
  \(\mathbf Q(\sqrt5)\)-fibre inevitable without coordinates?
- Does the degree-six Petersen four-space arise from a natural operation on
  the degree-three harmonic representation?
- Is the exact Gaunt cubic a transvectant, moment map, or vector-bundle
  construction already implicit in the Mukai--Umemura picture?
- Is the absence of an ambient rational comparison a theorem, or merely a
  boundary of the present construction?

### Dolgachev and Manivel: the best meaning-finding team

Dolgachev would search the classical invariant-theory attic: binary forms,
polar covariants, Clebsch's diagonal cubic, discriminants, and projective
models with \(A_5\)-symmetry.  He is the reader most likely to say that a
coordinate identity is actually a classical construction with a forgotten
name.

Manivel would search the modern representation-geometric version of the same
story: homogeneous spaces, Grassmannian degeneracy loci, equivariant vector
bundles, orbit closures, and plethysm.  He is the reader most likely to turn
the paper's two parallel embeddings into a functorial diagram, or to prove
cleanly that no such diagram exists in the claimed category.

Together they would test whether the true statement is:

```text
two accidental copies of the same four-dimensional A5-module
```

or the stronger:

```text
two shadows of one equivariant covariant or moduli construction
```

That distinction is the paper's deepest conceptual question.

### Steinhardt and Nelson: the best external-meaning team

The harmonic theorem restricts the standard third-order degree-six
bond-orientational invariant to a four-dimensional icosahedral coefficient
space.  Steinhardt and Nelson would recognize what an algebraic geometer may
miss: the cubic is not simply an invariant polynomial but an order parameter
designed to distinguish local structures in liquids, glasses, and
icosahedrally ordered systems.

They would ask whether:

- the Clebsch coordinates parametrize physically distinguishable distortions
  of an icosahedral environment;
- the zero locus of \(\sigma_3\) has a phase- or defect-theoretic meaning;
- the quadratic and cubic moments together define a useful normalized order
  parameter on the Petersen four-space;
- the Galois-conjugate embeddings correspond to chirality, orientation,
  phason-like choices, or no physical distinction at all; and
- the exact rational coefficient survives the normalization conventions used
  in simulations and materials papers.

## Who could close the hardest proof gaps most elegantly?

The manuscript's current theorems have local proofs, but the declared
boundaries expose several harder next gaps.  These should not be conflated
with the remaining submission metadata and independent-review gate.

### 1. Make the chart-to-incidence comparison global

**Best team:** Brian Conrad with Nigel Hitchin; Asher Auel if the quadratic
algebra is treated over a general base.

The current paper constructs
\[
 Z^\nu\longrightarrow\mathcal I\longrightarrow\mathcal N
\]
and proves the needed comparison near \(xyz\).  The harder theorem is to
describe the normalized pullback of the global incidence cover to the entire
descended Clebsch union, including the branch locus \(\sigma_3=0\), and to
identify its involution and conductor intrinsically.

The elegant route would likely be:

1. define both objects by universal properties, not coordinates;
2. compare their finite normalizations over the generic point;
3. extend by normality and codimension-one analysis;
4. compute the ramification divisor on the Clebsch chart;
5. analyze the special point \(xyz\) as the unique nonsplit intersection of
   conjugate sections; and
6. distinguish the normalization of the chart union from the base change of
   the incidence normalization.

Conrad is the strongest style model for preventing a generic-field
identification from being silently promoted to an integral or global
scheme-theoretic isomorphism.

### 2. Determine the exact integral model and bad primes

**Best team:** Brian Conrad and Asher Auel, with a Mukai--Umemura/Fano
geometer supplying integral Grassmannian equations.

The paper currently proves that the geometric incidence comparison spreads
out over some \(\mathbf Z[1/N]\), while the abstract algebra
\(z^2=5J_{\mathbf Z}\) is explicit.  The hard upgrade is to determine a
minimal or natural \(N\), prove flatness and normality of the incidence model,
and state exactly which primes preserve the Mukai--Umemura and two-sheet
interpretations.

An elegant solution would avoid checking primes one at a time.  It would:

- choose an integral lattice in the harmonic representation compatible with
  the polarization;
- define the three skew forms and their Grassmannian zero locus integrally;
- prove the required regular-sequence, flatness, and geometric-integrality
  properties after inverting an explicit discriminant;
- identify the Stein algebra with
  \(\mathcal O\oplus\mathcal O(-3)\) and its multiplication globally; and
- separate forced bad primes \(2,5\), representation-theoretic prime \(3\),
  and any genuinely geometric extras.

Auel's quadratic-form and Clifford-algebra perspective may replace several
coordinate square-class arguments by one statement about orthogonal torsors
over the base.

### 3. Find or rule out an ambient bridge between degrees three and six

**Best team:** Nigel Hitchin, Igor Dolgachev, and Laurent Manivel.

The current canonical comparison is abstract:
\[
 y\longmapsto(y_i+y_j)_{i<j}.
\]
It identifies two normalized \(A_5\)-modules but does not map the ambient
harmonic spaces \(H_3\) and \(H_6\).

The clean question is to compute all plausible equivariant covariants:

\[
 \operatorname{Hom}_{SO_3}
 \bigl(\operatorname{Sym}^r H_3,H_6\bigr),\qquad
 \operatorname{Hom}_{A_5}(H_3,H_6),
\]

together with their restrictions to the Clebsch four-spaces.  One should
also test polarization, Hessians, transvectants of binary sextics, harmonic
projection of products, and vector-bundle operations on the
Mukai--Umemura threefold.

There are two equally valuable outcomes:

- construct a natural covariant whose restriction is the normalized
  Petersen map; or
- prove a representation-theoretic nonexistence theorem showing that the
  abstract Clebsch isomorphism cannot extend while preserving the relevant
  \(SO_3\), rational, or integral structure.

This is probably the gap whose elegant solution would most change the
paper's conceptual rank.

### 4. Intrinsically explain the descended singularity and conductor

**Best team:** David Eisenbud with Brian Conrad.

The completed local presentation
\[
 \frac{\mathbf Q[[a_i,b_i]]}
 {(a_ib_j-a_jb_i,\ b_ib_j-5a_ia_j)}
\]
is convincing but coordinate-heavy.  The stronger result would express it
as a fibre product, pinching, or restriction-of-scalars construction
determined by the quadratic algebra \(E/\mathbf Q\) and a three-dimensional
tangent space.  The conductor and quotient \(E/\mathbf Q\) should then fall
out formally.

Eisenbud would likely seek:

- a presentation-free description of the normalization and conductor;
- the tangent cone, embedding dimension, depth, Cohen--Macaulay status, and
  seminormality;
- a minimal free resolution or determinantal presentation; and
- a deformation-theoretic explanation of why the coefficient \(5\) is the
  branch-splitting class.

This could turn a useful local computation into a reusable lemma about
Galois-conjugate linear spaces meeting at a rational point.

### 5. Uniformize the spinor and finite-field statement

**Best team:** Asher Auel, supplemented by a finite classical-groups expert
if the result is extended beyond the displayed exchanger.

The present reflection proof of \(\theta(R)=[2]\) is already short.  The hard
upgrade is to formulate the entire golden fibre as a torsor under an
orthogonal or \(A_5\)-normalizer group scheme and derive both independent
characters:

```text
[5]  existence/splitting of the two parents
[2]  special-projective membership of the exchanger
```

Auel's ideal solution would make these characters functorial under base
change, expose the characteristic-\(2\) and characteristic-\(5\) failures,
and state the finite-field result without relying on an accidental matrix
factorization.

## What would bring tears to their eyes?

This section is deliberately imaginative.  It describes the kind of result
or proof that would most fully reward each named mathematical taste; it is not
a biographical claim about anyone's private reaction.

### Hitchin: one geometry behind both appearances

The result would be a natural construction, not a scalar coincidence:

> The degree-three incidence cover and the degree-six Petersen harmonic
> four-space are two functorial shadows of one \(A_5\)-equivariant geometric
> object, and the Clebsch cubic is the same section on that object in both
> realizations.

The proof would begin with the Mukai--Umemura threefold or its universal
bundle, apply one inevitable geometric operation, and produce both the
quadratic cover \(z^2=5J_0\) and the degree-six Gaunt cubic.  The factor \(5\),
the two parents, and the exact coefficient
\(-784000/1247103\) would cease to be separate calculations.  They would be
forced by a single normalization, symmetry, or index calculation.

The especially beautiful ending would explain why no ambient map
\(H_3\to H_6\) exists while a canonical map appears precisely on the Clebsch
four-space.  The obstruction itself would be the theorem.

### Dolgachev: a classical construction returns in modern form

The moving result would reveal that the paper's bridge is a forgotten
Clebsch-era covariant:

> A classical polar, transvectant, or binary-sextic covariant, interpreted
> scheme-theoretically, sends the harmonic-cubic Clebsch chart to the
> Petersen eigenspace and carries its invariant sextic to the square of the
> bond-order cubic.

The proof would be short after the right nineteenth-century object is named.
Several pages of coordinates would collapse into a commutative diagram of
covariants.  It would explain the diagonal cubic, the golden field, and the
Petersen labeling as aspects of one classical projective construction.

Even better would be a moduli interpretation of the descended singularity:
the conductor \(E/\mathbf Q\) would encode the loss of a classical marking,
not merely the failure of two linear spaces to descend separately.

### Manivel: an equivariant diagram that could not have been otherwise

The ideal result would place every space in one representation-geometric
diagram:

\[
\begin{array}{ccc}
\text{Mukai--Umemura incidence data}
  &\longrightarrow& \text{an equivariant degeneracy locus}\\
\downarrow && \downarrow\\
H_3\supset V_4
  &\longrightarrow& H_6\supset V_4 ,
\end{array}
\]

with the horizontal arrow induced by a universal bundle, orbital
degeneracy-locus construction, or unique plethystic covariant.

The proof would compute one multiplicity-one Hom-space and then let geometry
fix the scalar.  The Petersen graph, rather than being inserted as a
combinatorial labeling, would emerge as the weight or incidence graph of the
construction.  A result of this kind would make the coefficient calculation
feel inevitable rather than miraculous.

### Conrad: a delicate arithmetic argument becomes a universal property

The satisfying result would be a theorem valid over an explicit base:

> Over \(\mathbf Z[1/N]\), the Stein algebra of the integral incidence model
> is canonically
> \(\mathcal O\oplus\mathcal O(-3)\), with multiplication by \(5J_{\mathbf
> Z}\); its pullback to the descended Clebsch locus is the normalization
> prescribed by the quadratic algebra \(\mathbf Z[1/N,\sqrt5]\).

The proof would specify \(N\), commute with every permitted base change, and
derive the fibre over \(xyz\), the finite-etale locus, and the conductor from
universal properties.  No sentence would ask a generic function-field
identity to do scheme-theoretic work it cannot do.

The emotionally perfect proof in this style is one where the dangerous
steps—normalization under base change, extension across codimension, and
integral comparison—are not patched separately.  The correct functor makes
them automatic.

### Auel: two square classes become two characters of one torsor

The ideal theorem would package the arithmetic cleanly:

> The golden incidence datum is a torsor under a natural orthogonal
> normalizer group scheme with two canonical quadratic characters.  One
> character is \([5]\), governing descent of the parents; the other is
> \([2]\), governing the spinor/projective sheet of their exchanger.

Then the rational, local, finite-field, and integral statements would all be
base changes of a single construction.  The exclusions at \(2\) and \(5\)
would be visible in the group scheme rather than appended as exceptional
cases.  Reflection matrices would remain welcome witnesses, but no longer
carry the conceptual burden.

### Eisenbud: the six-variable singularity becomes a one-line lemma

The beautiful result would replace the completed presentation by an
intrinsic algebra:

> The rational pinching of two Galois-conjugate \(n\)-planes meeting in one
> rational point is the fibre product obtained by restricting constants from
> \(E\) to \(k\); its normalization, conductor, defect module, and minimal
> resolution are functorial in \(E/k\) and the tangent space.

The paper's ring would be the case \(n=3\), \(E=\mathbf Q(\sqrt5)\).
The conductor would be the maximal ideal and the defect would be
\(E/\mathbf Q\) for structural reasons, not because generators happen to
work.  A small free resolution or determinantal description might then
explain all the displayed quadratic relations at once.

### Steinhardt and Nelson: an exact invariant predicts structure

The resonant result would carry the Clebsch cubic back into matter:

> On the four-dimensional family of icosahedral degree-six distortions, the
> normalized pair of quadratic and cubic invariants gives a complete or
> sharply discriminating order parameter, and the strata of the Clebsch
> cubic correspond to identifiable local structures, defects, or transition
> pathways.

The proof would combine the exact harmonic calculation with a transparent
geometric classification of the \(\sigma_3\)-level sets and then show that
those strata occur in a physical or numerical model.  The rational
coefficient would be useful, not ornamental: it would make normalization
across conventions exact and expose a universal signature of icosahedral
order.

### The result that would move the whole team

The collective dream theorem is:

> There is a single arithmetic \(A_5\)-equivariant object whose two
> realizations are Hitchin's degree-three incidence geometry and the
> degree-six icosahedral bond-order space.  Its orientation torsor has
> discriminant \(5\), its unique cubic invariant is the Clebsch cubic, its
> local pinching records \(\mathbf Q(\sqrt5)/\mathbf Q\), and its real
> harmonic period is the Gaunt/Steinhardt observable.

The right proof would use enough coordinates to fix normalization and no
more.  Classical invariant theory would identify the object, modern
algebraic geometry would make it functorial, arithmetic geometry would make
descent honest, local algebra would explain the singularity, and harmonic
analysis would compute the real period.  Each field would contribute
something indispensable, and none would be used as decorative language for
another.

## What this persona has studied, read, and mastered

### Primary source mastery

The persona has read, line by line rather than by citation:

- Hitchin, *Spherical harmonics and the icosahedron*, especially the
  harmonic-cubic model, the five plane triples, Proposition 7, the fibre over
  \(xyz\), the invariant sextic, and its restriction to the Clebsch chart;
- Hitchin, *Vector bundles and the icosahedron*, especially the three skew
  forms on \(\operatorname{Gr}(3,7)\), the Mukai--Umemura zero locus, the
  incidence correspondence, and the Chern-number-two calculation;
- Mukai--Umemura, *Minimal rational threefolds*, for the original Fano
  threefold, its automorphisms, compactification, and representation model;
- Dye, *Hexagons, conics, \(A_5\) and \(\operatorname{PSL}_2(K)\)*, including
  every characteristic and square-\(5\) hypothesis; and
- Steinhardt--Nelson--Ronchetti on \(Q_l/W_l\) bond-orientational invariants,
  including normalization conventions and the physical reason for the cubic
  invariant.

### Algebraic geometry

They have mastered:

- normalization in finite field extensions, Stein factorization, proper plus
  quasi-finite implies finite, and extension of birational finite maps;
- finite-etale algebras, residue fields, geometric versus
  scheme-theoretic fibres, and descent of conjugate components;
- conductor ideals, completed local rings, transverse unions, pinching, and
  restriction of scalars;
- Grassmannians, universal bundles, zero loci of skew forms, degeneracy loci,
  and Chern-class degree calculations;
- Fano threefolds of Mukai type, especially the Mukai--Umemura threefold and
  its \(PSL_2\)-symmetry;
- spreading out, generic freeness, flatness, good reduction, and the precise
  difference between a rational model and an integral incidence theorem; and
- EGA/SGA- and Stacks-level hypotheses, so that normality, integrality,
  geometric integrality, and base change are never interchanged casually.

### Invariant and representation theory

They can move fluently among:

- the \(SO_3\) harmonic representations \(H_l\), their realization through
  binary forms, and harmonic projection;
- the \(A_5\) irreducibles \(1,3,3',4,5\), their character table, fields of
  definition, and the distinction between an abstract rational module and a
  displayed embedding over \(\mathbf Q(\sqrt5)\);
- the standard four-space
  \(\sum y_i=0\), the Clebsch diagonal cubic \(\sigma_3=0\), and its
  invariant ring;
- the Petersen permutation module on two-subsets of five letters and its
  \(1\oplus4\oplus5\) eigenspace decomposition;
- Schur functors, plethysm, covariants, transvectants, polar maps, Hessians,
  and discriminants;
- centralizer calculations from two-transitivity and the normalization
  ambiguity of invariant cubic lines; and
- the difference between \(A_5\)-equivariance, \(SO_3\)-equivariance,
  rationality, and integrality.

### Quadratic forms and finite groups

They know:

- discriminants, Clifford algebras, spinor norms, reflection
  factorizations, and orthogonal group schemes;
- \(\operatorname{SO}_3(k)\simeq\operatorname{PGL}_2(k)\) and
  \(\Omega_3(k)\simeq\operatorname{PSL}_2(k)\), including hypotheses and
  normalization choices;
- square classes over number fields, local fields, finite fields, and
  nonreduced bases;
- Galois descent of configurations and torsors;
- icosahedral \(A_5\)-subgroups and their normalizers; and
- the special behavior in characteristics \(2,3,5\), rather than treating
  “odd characteristic” as a universal safe range.

### Harmonic analysis and mathematical physics

They have mastered:

- spherical harmonics, zonal kernels, the addition theorem, and the
  distinction between a reproducing-kernel matrix and a normalized Gram
  matrix;
- Legendre polynomials, Gaunt coefficients, Wigner \(3j\)-symbols, and
  Condon--Shortley conventions;
- exact spherical moment evaluation and normalization under changes of
  basis;
- icosahedral harmonics and the decomposition of point/axis orbit spans;
- Steinhardt \(Q_l\) and \(W_l\) order parameters; and
- how invariant polynomials become observables of local symmetry in
  supercooled liquids, glasses, clusters, and quasicrystalline order.

### Computational trust

They expect exact arithmetic to be auditable but subordinate to the proof.
They distinguish:

- a symbolic check of displayed axes and moments;
- an independent replay using a genuinely different representation;
- a certificate of a finite computation;
- a scheme-theoretic argument imported from a primary source; and
- a theorem that has formal proof-assistant coverage.

They would reject language that lets one of these evidence modes impersonate
another.

## First-pass protocol

1. Reconstruct Hitchin's incidence diagram independently from the two primary
   papers and match every convention used for \(H\), the pairing, \(J_0\),
   \(U_t\), and \(V_t\).
2. Draw a field-of-definition table for every object:
   \(\mathbf Q\), \(E=\mathbf Q(\sqrt5)\), an algebraic closure, and finite
   residue fields.
3. Separate the four covers or maps that are easiest to conflate:
   \[
   \mathcal I\to\mathbf P(H),\quad
   \mathcal I\to\mathcal N,\quad
   Z^\nu\to Z,\quad
   Z^\nu\to\mathcal N.
   \]
4. Check the square-class proof divisor by divisor, then repeat the
   specialization at \(xyz\) in the local ring rather than in the generic
   function field.
5. Base-change the descended union to \(E\), recompute the completed local
   ring and normalization, and verify that the conductor statement descends.
6. Compute the \(A_5\)-module decompositions of both ambient harmonic spaces,
   not only the two four-spaces, before judging any “canonical bridge.”
7. Re-derive the Petersen Gram spectrum from the addition theorem and the
   cubic coefficient from one exact test vector.
8. Translate the harmonic normalization into the standard \(W_6\) convention
   and test what remains invariant under rescaling.
9. Audit every finite-field sentence against the integral-model boundary;
   the explicit golden fibre at \(11\) must not become a global good-reduction
   theorem by rhetoric.
10. Only after those checks ask what larger theorem joins the arithmetic and
    harmonic halves.

## Questions this persona asks

- What is the moduli meaning of choosing one of the two parents?
- Is \(5\) the discriminant of a quadratic algebra, the field of definition
  of an \(A_5\)-embedding, an orientation character, or all three through one
  torsor?
- Can the local conductor recover the quadratic field for any pair of
  conjugate linear spaces, and if so what is the general lemma?
- Does the incidence normalization restricted to the Clebsch locus equal the
  normalization of that locus in the pulled-back quadratic field?
- What happens along \(\sigma_3=0\), where the pulled-back branch sextic is a
  square with multiplicity two?
- Is the canonical four-module comparison induced by a covariant of harmonic
  tensors, or only by Schur's lemma after choosing two embeddings?
- Which rational form of the four-dimensional \(A_5\)-module is actually
  present in each construction?
- Why is the exact cubic coefficient rational even though the displayed axes
  use \(\sqrt5\)?
- What geometric structure explains the prime \(11\) in the denominator, if
  any, and what is merely normalization arithmetic?
- Does the Clebsch cubic zero locus classify a physically meaningful family
  of degree-six distortions?
- Can the two characters \([5]\) and \([2]\) be packaged as one normalizer
  torsor with two quotient characters?
- Is there a natural integral lattice compatible with both realizations, or
  can lattice invariants prove that none exists?

## Likely referee verdict

A strong referee should see the paper as a short bridge paper, not a general
treatise on the Mukai--Umemura threefold or icosahedral order.  Its defensible
core is:

- fixing the rational square class \(5J_0\) by a scheme-level comparison at
  \(xyz\);
- exposing \(5\) again in the normalization and conductor of the descended
  conjugate Clebsch charts;
- separating the \([5]\) parent-existence character from the \([2]\) spinor
  character; and
- computing the exact restriction of the normalized degree-six spherical
  cubic to the Petersen Clebsch four-space.

The referee should insist that the paper retain its negative statements:
there is no asserted rational or integral identification of the two ambient
embeddings, and there is no claimed all-primes integral incidence theorem.
Those are signs of mathematical control, not weaknesses to conceal.

The most promising sequel would solve one of two problems: globalize the
chart-to-incidence comparison over the full Clebsch cubic, or construct/rule
out a natural degree-three-to-degree-six covariant.  Either would convert the
present exact coincidence into a structural theorem.

## Source spine

- Nigel Hitchin's Oxford profile and publication list:
  https://www.maths.ox.ac.uk/people/nigel.hitchin and
  https://people.maths.ox.ac.uk/hitchin/files/pubs.html
- Igor Dolgachev's research page and classical algebraic geometry notes:
  https://dept.math.lsa.umich.edu/~idolga/ and
  https://sites.lsa.umich.edu/idolga/lecture-notes/
- Laurent Manivel's research page:
  https://manivel.perso.math.cnrs.fr/
- Brian Conrad's Stanford profile and research notes:
  https://mathematics.stanford.edu/people/brian-conrad and
  https://math.stanford.edu/~conrad/
- Asher Auel's curriculum vitae and papers:
  https://math.dartmouth.edu/~auel/cv/ and
  https://math.dartmouth.edu/~auel/papers/
- David Eisenbud's Berkeley profile:
  https://math.berkeley.edu/people/faculty/david-eisenbud
- Steinhardt--Nelson--Ronchetti, *Bond-orientational order in liquids and
  glasses*: https://doi.org/10.1103/PhysRevB.28.784

The named people are intellectual lenses, not proposed contacts, implied
referees, endorsements, or attributions of unpublished ideas.  This dossier
is proof-design and readership guidance, not a substitute for a
task-specific literature, novelty, or conflict-of-interest audit.
