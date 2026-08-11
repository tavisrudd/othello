# C904 Paper V structural inevitability spine

**Lane:** `clebsch`

**Date:** 2026-08-11

**Purpose:** identify every remaining place where Paper V can replace a
coordinate computation, repeated inverse, or declarative marking by a short
structural theorem. This is a proof-compression plan, not an expansion of the
paper's geometric scope.

**Forward hostile correction:**
`2026-08-11-c904-paper-v-inevitability-red-team-tt.md` supersedes the bare
minimal datum below. Over extensions containing \(\mu_3\), an actual cubic
does not kill scalar automorphisms. Use a normalized invariant quadratic form
and isometric morphisms (or the literal quadratic augmentation module), and
distinguish base change of the fixed package from classification of arbitrary
forms. The causal recovery of \(q_\Pi\) from the recovered six-set remains
valid.

## Central principle

The minimal common input should be one normalized actual chordal generator
\(h\) in the invariant pencil of the recovered five-dimensional \(A_5\)-module.
Everything else in the common carrier should be derived:

\[
h
\Longrightarrow R_h
\Longrightarrow A_5/C_5\to A_5/D_5=\Omega
\Longrightarrow q
\Longrightarrow c=8^{-1}(q-1)h
\Longrightarrow(c_{ijk})
\Longrightarrow[B]
\Longrightarrow D_6^\vee
\Longrightarrow H_{\mathbf F_4}.
\]

Here \(R_h\) is the singular rational normal quartic, \(q\) is the action of
the nontrivial normalizer coset on the invariant pencil, \(c\) is the oriented
conference cubic, and \(H_{\mathbf F_4}\) is the exotic natural heart.

This chain makes the result asymmetric in the correct way. A normalized
chordal generator determines its conference companion. An oriented conference
cubic alone remembers only the unordered pair of chordal lines; selecting one
line is the exact residual \(C_2\)-rigidification.

## 1. Make the invariant pencil representation-theoretic

Prove from the ordinary \(A_5\) character table that for the relevant
five-dimensional module \(A\),

\[
\dim\operatorname{Sym}^3(A^*)^{A_5}=2.
\]

Compute the normalizer action on this two-space by character/eigenspace
considerations. Since \(A_5\) fixes the pencil pointwise, every representative
of the outer coset induces the same involution. The conference line is its
anti-invariant line.

Consequences:

- the pencil is forced, not found by enumeration;
- every equivariant map into it is controlled by multiplicity one;
- Paper-II placement needs one geometric discriminator and one scalar, not a
  complete coefficient comparison;
- the outer-difference lemma is ordinary two-dimensional involution theory.

## 2. Replace the chordal singular-locus certificate by a determinantal lemma

Write the chordal generator as the determinant of the \(3\)-by-\(3\) Hankel
matrix. Prove that its Jacobian ideal, after saturation, is the ideal of the
rank-one Hankel locus. This is the rational normal quartic scheme, not merely
the same set of points.

To identify the Paper-II projection, prove that its singular scheme is that
quartic. The classical uniqueness of a cubic singular along a rational normal
quartic then places it on the chordal line. Multiplicity one fixes the
intertwiner; one coefficient fixes the pivot/scalar. The full coefficient
certificate becomes replay evidence only.

## 3. Replace the twelve-point census by subgroup theory

Once one geometric point has exact stabilizer \(C_5\), transitivity gives the
twelve-point orbit \(A_5/C_5\). The normalizer identity

\[
N_{A_5}(C_5)=D_5
\]

produces the canonical degree-two quotient

\[
A_5/C_5\longrightarrow A_5/D_5.
\]

This is exactly equal-stabilizer pairing. It yields six axes without testing
all pairs. Prove once that each resulting \(D_5\) fixes the corresponding
original Paper-II matching axis; equivariance handles the remaining five.

## 4. Make switching reconstruction cohomological

Regard edge signs on the complete graph as multiplicative one-cochains and
triangle signs as their coboundary. The tetrahedral identity

\[
c_{ijk}c_{ij\ell}c_{ik\ell}c_{jk\ell}=1
\]

is the two-cocycle condition on the full simplex. Since its positive-degree
cohomology vanishes, an edge signing exists and is unique modulo a vertex
zero-cochain, exactly diagonal switching.

Pair balance

\[
\sum_{k\notin\{i,j\}}c_{ijk}=0
\]

is then precisely the off-diagonal equation in \(B^2=5I\). The diagonal
equation counts five signs. This eliminates gauge-by-gauge reconstruction and
makes the inverse valid in every scalar extension of \(\mathbf F_{11}\).

## 5. Minimize the carrier data

The expanded tuple \((\Pi,q,z,L,h,\Omega)\) is useful for exposition but is
not minimal:

\[
L=Kh,\qquad z=8^{-1}(q-1)h,\qquad
\Omega=\operatorname{Sing}(z)=\operatorname{NormQuot}(R_h).
\]

Prove equivalence between the minimal and expanded carrier groupoids. This
turns every apparent extra marking into either derived structure or an
explicit residual torsor. It also identifies unused markings before the
epilogue assigns them causal force.

## 6. Make naturality and triangle identities formal

Build both inverse functors entirely from functorial operations:

- singular schemes;
- projective-frame normalization;
- the normalizer quotient;
- simplicial cochain lifting modulo switching;
- the linear map \(q-1\).

Then any unit or counit is the unique carrier morphism fixing the recovered
frame and actual generator. Carrier rigidity makes both triangle identities
automatic. Do not check the two composites separately for all three source
papers.

The Paper-II tensor inverse, including pivot \(3\), belongs in one
inverse-formula lemma. Paper III returns only its declared retained output;
input chart lifts and global covers are outside the unit/counit.

## 7. Compute automorphisms from the recovered frame

Because six projective-frame points determine a projective automorphism, every
carrier automorphism injects into their permutation group. Impose preservation
of the \(A_5\)-action, triangle class, selected chordal generator, and outer
labels to identify each stabilizer. This supplies the V.D marking table and
the exact sequence between the oriented stabilizer and the full normalizer.

Use the actual action on the pencil. The outer involution exchanges chordal
lines and negates the conference generator; sheet reversal fixes one chordal
line and negates its actual generator. Their combined marking fibre must be
computed, not guessed to be a direct product.

## 8. Make the spectral arithmetic a universal property

Separate:

- the unpointed algebra \(\mathbf Q[B]=\mathbf Q[-B]\);
- the oriented embedding determined by \(\varphi=(I+B)/2\);
- the minimal stable lattice \(D_6^\vee\);
- the residue heart inside \(D_6^\vee/2D_6^\vee\).

The common-column argument proves minimality of the stable lattice. The
triangle-presentation calculation identifies the unique nonsplit middle
module. Reversal \(B\mapsto-B\) sends \(\varphi\mapsto1-\varphi\), which
reduces to Frobenius on \(\mathbf F_4\). No intertwiner matrix is needed.

## 9. Demote mechanism identities unless they earn their place

If the Pfaffian and determinant-norm formulas remain, derive them by invariant
lines:

1. show the Pfaffian construction is an \(A_5\)-invariant cubic in the
   anti-invariant conference line;
2. compare one coefficient to obtain the scalar;
3. obtain the determinant identity from the golden spectral factorization and
   norm.

Otherwise move them to a corollary or omit them. They should not serve as
extra recognition axioms after the triangle cocycle already reconstructs the
conference class.

## 10. Exact remaining hand checks

After this compression, the published proof should require only a few small
normalizations:

- one character inner product giving pencil dimension two;
- one nonzero coefficient locating/normalizing the Paper-II generator;
- the pivot factor \(3\);
- the outer-difference scalar \(8\);
- one point-stabilizer calculation \(C_5\);
- the relation-norm ranks \((1,0,0)\) for the Ext line.

Each is a displayed hand calculation. Scripts may replay them but do not
support a theorem.

## Publication effect

The strongest headline becomes:

> A normalized chordal shadow determines, through its singular scheme and
> outer difference, a unique oriented golden conference package; the reverse
> ambiguity is exactly the selected-line torsor. The resulting six-set
> canonically carries the root--weight normalization whose mod-two heart is the
> exotic natural \(A_5\)-module.

This is more inevitable and more reusable than a list of pairwise
identifications. It also shortens the proof: representation theory replaces
projection tables, determinantal geometry replaces a Jacobian census,
subgroup theory replaces twelve-point pairing, and simplex cohomology replaces
switching gauges.
