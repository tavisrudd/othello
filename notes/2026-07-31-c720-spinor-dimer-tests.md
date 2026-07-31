# C720 pure-spinor and \(K_{3,3}\) discriminator tests

**Lane:** golden

**Date:** 2026-07-31

**Status:** complete; spinor test split, dimer test positive

## Outcome

The two tests have different answers.

1. The naive claim that the Segre cubic is forced by pure-spinor/Wick
   geometry alone is **false**.  Each golden Majorana matrix does define a
   pure spinor, but the six matrices define six synchronized pure spinors,
   not six coordinates of one six-mode pure spinor.  Wick identities alone
   place no relation on their six independent top Pfaffians.
2. The \(K_{3,3}\) test is **positive and stronger than proposed**.  A signed
   \(K_6\) matrix is golden conference precisely when every \(3|3\) cross
   block has five determinant-matching terms of one sign and one of the
   other.  The relative matching signs recover its switching class up to
   global negation, hence recover exactly the unoriented two-graph line
   \(\{c,-c\}\).  The twelve oriented normalized conference signings pair
   into exactly six such frustration fingerprints: the six shadow sisters.

The dimer statement belongs in the Golden paper's theorem spine.  The
pure-spinor statement remains useful, but its correct form is a synchronized
product construction rather than a parent that independently explains the
Segre equation.

## The pure-spinor test

For each of the six outer conference matrices \(C_T\), put
\[
 A_T(x)=[D_x,C_T],
 \qquad
 w_T(S)=\operatorname{Pf}(A_T(x)_S)
 \quad (|S|\text{ even}).
\]
The 32 coordinates \(w_T(S)\), indexed by the even subsets of six labels,
are the big-cell principal-Pfaffian coordinates of a pure spinor in the
half-spin representation for \(\operatorname{Spin}(12)\).  The exact check
constructs all \(6\cdot32\) coordinates and verifies the Pfaffian/Wick
recurrences.  Their two-body coordinates are synchronized by
\[
 w_T(\{i,j\})=(x_i-x_j)(C_T)_{ij},
\]
while their top coordinates are
\[
 w_T([6])=\operatorname{Pf}A_T(x)=4Z_T(x).
\]
The six top Pfaffians have polynomial rank five and satisfy exactly the two
known Golden identities
\[
 \sum_T w_T([6])=0,
 \qquad
 \sum_T w_T([6])^3=0.
\]

This does **not** make the Segre relation a bare Wick relation.  Take six
independent skew matrices.  In the first, use three disjoint \(2\times2\)
blocks with entries \(1,1,1\); in the other five, make one block zero.  All
six principal-Pfaffian systems satisfy every Wick identity, while their top
coordinates are \((1,0,0,0,0,0)\), violating even the Segre linear equation.
Thus the correct statement is:

> The golden family is a common five-parameter linear slice of a product of
> six pure-spinor/matchgate big cells.  The Segre equations arise from the
> golden synchronization of those six cells, not from Wick identities alone.

The computation proves that the two Segre relations vanish after this exact
substitution.  It does not claim that a Groebner elimination of all
synchronized Wick equations has no further scheme-theoretic generators.

## The dimer theorem

Let \(B\) be a symmetric zero-diagonal \(6\times6\) sign matrix, considered
under vertex switching \(B\mapsto DBD\).  For a partition
\(L\sqcup R=[6]\) with \(|L|=|R|=3\), expand
\[
 \det B_{L,R}
 =\sum_{\pi\in S_3}\operatorname{sgn}(\pi)
   \prod_{i\in L}B_{i,\pi(i)}.
\]
The six summands are the signed perfect matchings of the corresponding
\(K_{3,3}\).

### Theorem

The following are equivalent.

1. On every one of the ten \(3|3\) cuts, the six matching terms split
   \(5{:}1\) by sign.
2. Every cross determinant has absolute value four, the maximum possible for
   a \(3\times3\) sign matrix.
3. \(B^2=5I_6\); that is, \(B\) is a symmetric conference matrix.
4. After switching to \(B_{0i}=1\), the negative edges among
   \(\{1,2,3,4,5\}\) form a five-cycle.

Consequently there are twelve oriented gauge-normalized solutions, one for
each labeled five-cycle.  Global negation complements the five-cycle and
pairs these solutions into six unoriented classes.

### Human proof

Switch so that \(B_{0i}=1\).  Represent every cut by
\(L=\{0,i,j\}\).  The first row of its \(3\times3\) cross block is then
\((1,1,1)\).  A \(3\times3\) sign determinant is either zero or has absolute
value four.  It is nonzero exactly when its three rows are distinct modulo
sign; equivalently its six determinant terms split \(5{:}1\).  This proves
the equivalence of the first two conditions.

Fix \(i\in\{1,\ldots,5\}\).  For every choice of \(j\ne i\), nonvanishing
of the cut determinant says that the three signs from \(i\) to the vertices
other than \(i,j\) are not constant.  Among the four internal edges incident
to \(i\), this is possible for every removed \(j\) only when exactly two are
positive and two are negative.  Hence the negative internal graph is
two-regular on five vertices, and therefore is a five-cycle.

Conversely, for a five-cycle each internal vertex has two positive and two
negative incident edges.  A direct one-neighborhood check in the cycle gives
\((B^2)_{ij}=0\) for every distinct \(i,j\), while every diagonal entry is
five.  Thus \(B^2=5I\).  The reverse implication follows already from
\((B^2)_{0i}=0\): it forces two positive and two negative internal edges at
every \(i\), hence the same five-cycle.  This proves all four equivalences.

There are \((5-1)!/2=12\) labeled undirected five-cycles.  The complement of
a five-cycle is again a five-cycle and has no fixed point, leaving six
complement-pairs.

This also removes the last accidental-looking six.  A Sylow-\(5\) subgroup
of \(A_5\) has two inverse pairs of generators.  Their Cayley edge sets on
five letters are complementary five-cycles.  Conversely a complementary
pair determines that Sylow subgroup.  Hence the six frustration fingerprints
are canonically
\[
 \operatorname{Syl}_5(A_5)\cong A_5/D_5,
\]
the same six-axis carrier that appears in C691.  The outer-six labeling is
therefore forced by the local maximum-determinant condition, not appended
after the dimer calculation.

## Recovery of the unoriented two-graph

Vertex switching multiplies every matching term on a fixed \(3|3\) cut by
the same product of six vertex signs.  Relative matching signs are therefore
gauge invariant.  The ratio of two terms differing by a transposition is,
up to the known permutation minus sign, the holonomy around the corresponding
four-cycle.  Every four-cycle occurs this way on some \(3|3\) cut, so the ten
relative matching patterns recover all four-cycle holonomies.

On a complete graph, those holonomies determine an edge signing up to vertex
switching and global negation.  Indeed, for the quotient signing \(q_{ij}\)
of two candidates, switch so that \(q_{0i}=1\).  Trivial four-cycle
holonomies force all remaining \(q_{ij}\) to have one common value
\(\epsilon\), yielding either the trivial signing or its global negative.
Since
\[
 c_{ijk}=B_{ij}B_{jk}B_{ki},
\]
global negation sends \(c\mapsto-c\).  Thus the dimer fingerprint recovers
precisely the unoriented two-graph line \(\{c,-c\}\), not its orientation.
The Pfaffian sign still requires an oriented Majorana frame, exactly as in
C709.

This turns the six-shadow count into a structural statement:

> The six golden shadow sisters are the six complement-pairs of labeled
> five-cycles, equivalently the six gauge-inequivalent projective
> \(K_{3,3}\) frustration fingerprints for which every balanced cut has one
> exceptional perfect matching, and equivalently the six Sylow-\(5\)
> subgroups of \(A_5\).

## Reproducibility

From `/home/tavis/src/othello`:

```sh
python3 notes/2026-07-31-c720-spinor-dimer-tests.py --check
python3 notes/2026-07-31-c720-spinor-dimer-replay.py
```

The generator reconstructs the six outer conference matrices from their
triangle cubics, constructs all principal Pfaffians as exact sparse integer
polynomials, verifies the two Segre identities, and exhausts all \(2^{10}\)
gauge-normalized edge signings.  It checks, signing by signing, that the
all-cut \(5{:}1\) property is equivalent to \(B^2=5I\), and verifies that the
six outer matrices exhaust the six projective fingerprints.

The replay independently generates the twelve labeled five-cycles rather
than enumerating arbitrary signings, checks the conference and \(5{:}1\)
properties directly, and obtains six complement-paired fingerprints.  The
human proof above independently supplies the converse classification and the
cycle-holonomy recovery argument.  The certificate establishes these finite
and symbolic claims over the displayed conventions; it does not establish a
surface spin structure, an interacting fermion theory, or a positive dimer
partition function.

Hashes and byte counts are recorded in
`notes/2026-07-31-c720-spinor-dimer-tests.sha256`.

## Paper consequence

- Promote the \(K_{3,3}\) equivalence theorem and six-fingerprint corollary
  into the main fermionic section, immediately before the Majorana Pfaffian
  interpretation.
- Present the synchronized product of pure-spinor cells as a short structural
  proposition or remark.  Do not advertise the Segre cubic as a consequence
  of Wick identities alone.
- The result strengthens the paper's mechanism: the golden relation
  \(C^2=5I\), the six outer shadows, and irreducible nonplanar matching
  frustration are three equivalent manifestations of the same sign system.

## Mystery ledger

- **Settled negatively:** one pure spinor or Wick identities alone do not
  force the Segre equations.
- **Settled positively:** the six matrices form one synchronized
  five-parameter slice of six pure-spinor/matchgate cells.
- **Settled positively:** universal \(5{:}1\) \(K_{3,3}\) frustration is
  equivalent to the conference identity \(B^2=5I\).
- **Settled positively:** relative matching signs recover the unoriented
  two-graph, and the twelve orientations pair into the six shadow sisters.
- **Settled by the `ej`+`tt` closeout:** the criterion is local maximality of
  every balanced \(3\times3\) determinant, and its six classes are
  canonically \(\operatorname{Syl}_5(A_5)=A_5/D_5\), recovering the original
  six-axis carrier.
- **Still open:** whether the synchronized product has an intrinsic
  homogeneous-space or moduli description rather than the displayed
  coordinate synchronization.  This is a directions question unless C720
  finds a multiplicity-one construction.
