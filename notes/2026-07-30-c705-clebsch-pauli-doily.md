# C705 — Clebsch orientation and the two-qubit Pauli doily

**Date:** 2026-07-30

**Lane:** `clebsch`

**Status:** exact incidence dictionary and sign comparison complete; ordinary
contextuality-cocycle crown is negative, with an equivariant-lift successor.

## Outcome

There is an exact \(S_6\)-equivariant identification of the C705
\(15/10/6\) configuration with the two-qubit Pauli doily:

\[
\begin{array}{c|c}
\text{Clebsch--Segre--Igusa object}&\text{Pauli-doily object}\\ \hline
15\text{ duads}&15\text{ nonidentity Pauli observables}\\
15\text{ synthemes / Segre planes / Igusa lines}
 &15\text{ maximal commuting contexts}\\
10\text{ complementary }3+3\text{ partitions / Segre nodes}
 &10\text{ Mermin grids}\\
6\text{ axes / odd theta characteristics}
 &6\text{ ovoids}.
\end{array}
\]

The sign comparison is positive at the level of the standard Mermin
obstruction but negative as a Clebsch-specific invariant.  Every one of the
ten grids has product \(-1\) for both the Pauli context signs and the
Pfaffian/Clebsch context signs.  However, the two line-sign systems differ
by rephasing the fifteen point observables.  More sharply, the conference
factor in the Clebsch sign is itself exactly such a point rephasing.
Therefore the ordinary contextuality class sees the Pfaffian/symplectic
extension, not the special golden conference operator \(C\) or
\(K=*\Lambda^3C\).

This is a useful negative: the \(15/10/6\) quantum dictionary is real, but a
claim that the Clebsch orientation creates a new Mermin cocycle is false.
The nearest surviving question is equivariant.  Although the Clebsch
cochain is gauge-trivial after forgetting symmetry, it may define a
nontrivial \(S_6\)- or Clifford-equivariant lift, central extension, or
distinguished \(A_5\) phase convention.  C706 owns that sharper gate.

## Explicit dictionary

Write a vector of \(\mathbf F_2^4\) as \((x,z)\), with symplectic form
\[
 B((x,z),(y,t))=x\mathbin{\cdot}t+z\mathbin{\cdot}y.
\]
The six odd genus-two theta characteristics are the pairs
\((a_i,b_i)\in\mathbf F_2^2\times\mathbf F_2^2\) satisfying
\(a_i\cdot b_i=1\).  Label them lexicographically.  The duad
\(\{i,j\}\) maps to
\[
 v_{ij}=(b_i+b_j,\ a_i+a_j),
\]
because the difference of the two quadratic refinements is
\(B(v_{ij},-)\).  The fifteen duads map bijectively to the fifteen nonzero
vectors.

Two duads are disjoint exactly when their vectors are symplectically
orthogonal.  Hence a syntheme
\[
 \{\{i,j\},\{k,l\},\{m,n\}\}
\]
maps to the three nonzero vectors of a maximal isotropic plane, or
equivalently a maximal commuting Pauli context.  Exhausting all \(720\)
permutations of the six odd characteristics produces \(720\) distinct
symplectic maps, giving the concrete isomorphism
\[
 S_6\cong\operatorname{Sp}_4(\mathbf F_2).
\]

For an unordered partition \(Q\sqcup Q^c\) with \(|Q|=3\), the nine crossing
duads are the points of a grid and its six crossing synthemes are its
contexts.  This gives the ten Mermin grids.  For each \(i\), the five duads
containing \(i\) are pairwise nonorthogonal and form an ovoid.  This gives
the six ovoids.

## Exact sign theorem

Use the Hermitian Pauli section
\[
 P(x,z)=i^{x\cdot z}X^xZ^z.
\]
For a syntheme \(M\), let \(\mu(M)\in\{\pm1\}\) be defined by
\[
 \prod_{\{i,j\}\in M}P(v_{ij})=\mu(M)I.
\]
Let \(\epsilon(M)\) be the Pfaffian sign of the ordered matching, and define
the Clebsch sign
\[
 \lambda_C(M)=\epsilon(M)\prod_{\{i,j\}\in M}C_{ij}.
\]
The exact calculation gives a point-sign function
\(\eta:\binom{[6]}2\to\{\pm1\}\) such that
\[
 \lambda_C(M)=\mu(M)\prod_{\{i,j\}\in M}\eta_{ij}
\]
for all fifteen contexts.  The binary point-line incidence matrix has rank
\(10\), and the certificate records one explicit solution \(\eta\).

For every \(3+3\) partition, each of its nine points occurs twice among its
six contexts.  Point rephasings therefore cancel, and
\[
 \prod_{M\text{ in the grid}}\lambda_C(M)
 =
 \prod_{M\text{ in the grid}}\mu(M)
 =
 \prod_{M\text{ in the grid}}\epsilon(M)
 =-1.
\]
The last equality is checked for all ten grids and also follows directly
from the six Pfaffian signs of the perfect matchings of \(K_{3,3}\).

## Why the Clebsch contribution disappears

The conference factor has the form
\[
 \lambda_C(M)/\epsilon(M)=\prod_{\{i,j\}\in M}C_{ij}.
\]
It is therefore literally the point rephasing
\(P(v_{ij})\mapsto C_{ij}P(v_{ij})\).  Switching the six representatives,
\(C_{ij}\mapsto s_iC_{ij}s_j\), multiplies every context sign by the same
factor \(\prod_i s_i\), which is again gauge-trivial.

The same issue appears one level up.  The diagonal of C704's operator is
\[
 K_{SS}/4=C_{ij}C_{jk}C_{ki}
\qquad(S=\{i,j,k\}).
\]
Thus its twenty triangle signs are the coboundary of the edge cochain
\((C_{ij})\) on the complete \(5\)-simplex.  The phases of the corresponding
three pairwise anticommuting Pauli observables are also a triangle
coboundary: their product around every tetrahedron is \(+1\).  Ordinary
cohomology consequently cannot distinguish them.

## Extra-juice upgrade: complete ordinary-gauge classification

The ten grid parities are not merely ten successful comparisons.  They are
a complete system of invariants for context signs modulo arbitrary point
rephasing.

Let \(I\) be the binary \(15\times15\) context--point incidence matrix and
let \(H\) be the binary \(10\times15\) grid--context matrix.  Every point of
a grid lies on two of its six contexts, so
\[
 HI=0.
\]
Exact elimination gives
\[
 \operatorname{rank}_{\mathbf F_2}I=10,\qquad
 \operatorname{rank}_{\mathbf F_2}H=5.
\]
The left kernel of \(I\) has dimension \(15-10=5\), hence the rows of \(H\)
span the whole kernel.  Therefore two context-sign assignments are related
by point rephasing if and only if all ten of their grid parities agree.
There is no additional unrestricted sign invariant hidden beyond the grids.

The possible ten-bit grid-parity words form a binary
\([10,5,4]\) code with weight enumerator
\[
 1+15y^4+15y^6+y^{10}.
\]
Both the Pauli and Clebsch/Pfaffian systems give the all-one word.  Thus the
negative result is maximal in the ordinary gauge category: every ordinary
contextual sign test factors through the same five-dimensional grid-parity
quotient.  Identification and structural interpretation of this small code
belong to C708; C705 uses only its complete-invariant consequence.

### Second-order extra juice: the node--plane code is isodual

The fifteen weight-four words of the parity code are exactly its fifteen
context-column generators.  On the geometric side, a syntheme labels a
Segre plane and the four nonzero coordinates of its word are precisely the
four \(3+3\) partitions, hence the four Segre nodes, incident with that
plane.  The weight-four layer therefore forms a
\[
 2\text{-}(10,4,2)
\]
design on the ten nodes: every pair of nodes lies in exactly two of the
fifteen planes.  Exhaustion of all \(10!\) coordinate permutations gives
full permutation automorphism group of order \(720\), recovering the outer
\(S_6\) action from the code alone.

The code is not self-dual on the frozen node marking, but its dual has the
same weight enumerator and is coordinate-equivalent to it.  Exactly \(720\)
coordinate permutations take the code to its dual; they form a torsor under
its \(720\)-element automorphism group.  Thus
\[
 \mathcal C_{\mathrm{node/plane}}\ne
 \mathcal C_{\mathrm{node/plane}}^\perp,
 \qquad
 \mathcal C_{\mathrm{node/plane}}\simeq
 \mathcal C_{\mathrm{node/plane}}^\perp .
\]
This is a finite combinatorial shadow of the sister pattern that survives
the contextual-sign negative: the two five-spaces are paired rather than
equal, and the set of identifications has the correct outer-\(S_6\) size.
It does not yet identify the isoduality permutation with the C705
Segre--Igusa polar operator; that is now a sharp C708 comparison.

### Third-order extra juice: \(R_{10}\), \(W_{10}\), and a polarity class

The code and its dual meet as little as their common all-one word permits:
\[
 \mathcal C\cap\mathcal C^\perp=\langle{\bf1}\rangle,\qquad
 \mathcal C+\mathcal C^\perp=E_{10},
\]
where \(E_{10}\) is the nine-dimensional even-weight code.  Thus the paired
five-spaces share one radial line and fill the ambient even ten-space.  This
is a particularly clean characteristic-two sister pattern.

The fifteen minimum words of \(\mathcal C^\perp\) are disjoint from the
fifteen minimum words of \(\mathcal C\).  Their union has thirty
four-subsets, and exact enumeration shows that every three-subset of the ten
coordinates lies in exactly one of them.  Hence the two minimum layers are
the two \(15\)-block halves of the Steiner system
\[
 S(3,4,10)=W_{10}.
\]
Exhaustion of all \(10!\) coordinate permutations gives \(1440\)
automorphisms of this union: \(720\) preserve the two halves and \(720\)
exchange them.  There is no additional automorphism that mixes the halves
block by block.

The exchange coset is not merely an undifferentiated torsor.  Its order
distribution is
\[
 2^{36}\,4^{180}\,8^{360}\,10^{144}
\]
in multiplicity notation.  The 36 involutions all have cycle type
\(2^5\), so they are fixed-point-free on the ten nodes, and conjugation by
the half-preserving automorphism group is transitive on them.  They
therefore form one distinguished 36-element class of combinatorial
polarities exchanging \(\mathcal C\) with \(\mathcal C^\perp\).  Whether
the specific C705 Segre--Igusa polar operator canonically selects one member
of this class remains an operator-level question; the finite target is now
sharp.

There is also an explicit standard-code identification.  In the frozen node
order, the coordinate permutation
\[
 (0,1,2,6,4,9,3,7,8,5)
\]
takes \(\mathcal C\) to the kernel of Seymour's displayed parity-check
matrix for the exceptional regular-matroid code \(R_{10}\).  This removes
the ambiguity left by the existence of four inequivalent binary
\([10,5,4]\) codes.  Literature identifies the unique isodual member with
the shortened-hexacode/binary quadratic-residue model used to construct the
isodual lattice \(Q_{10}\); consequently the natural Construction-A lift of
this seam is indeed \(Q_{10}\), not automatically \(E_8\).

The negative is exact only for unrestricted point gauge.  It does not
settle whether an equivariant gauge exists, whether the signed outer action
lifts to the two-qubit Clifford group with the same central extension, or
whether the \(A_5\) stabilizer of \(C\) selects a distinguished metaplectic
phase.  Those are the falsifiers in C706.

## Preliminary novelty assessment

The quantum-incidence crown is pre-empted.  The doily is already presented
in the quantum-information literature as the Cremona--Richmond
configuration, with duads as points and synthemes as lines.  Independently,
the fifteen planes of the Segre cubic are already identified with its
associated Cremona--Richmond configuration.  Consequently the chain
\[
 \text{Segre planes}
 \longleftrightarrow
 \text{synthemes}
 \longleftrightarrow
 \text{two-qubit commuting contexts}
\]
is a composition of known identifications, not a new quantum geometry.
The counts \(15/10/6\), their \(S_6\cong\operatorname{Sp}_4(\mathbf F_2)\)
symmetry, and the interpretation of grids as Mermin squares and ovoids as
five mutually noncommuting observables are likewise standard.

What appears less standard in the bounded screen is the route from C704's
specific golden conference operator and
\(K=*\Lambda^3C\) to a fully explicit Pauli labeling and sign comparison.
That packaging is task-owned, but its first possible quantum invariant is
negative:

- the conference factor is ordinary point gauge;
- the \(K\)-triangle tensor is a simplex coboundary; and
- the ten Mermin parities are the standard Pfaffian/symplectic obstruction,
  independent of the Clebsch switching class.

This makes the calculation useful as a compatibility and obstruction
lemma, but not presently a standalone quantum theorem.  The only plausible
quantum crown left by this computation is C706's sharper question: whether
the gauge trivialization fails after imposing the outer \(S_6\), Clifford,
integral, or golden-\(A_5\) equivariance.  A positive equivariant
central-extension comparison could be genuinely new; an unrestricted-gauge
rephrasing cannot.

The operator origin may still matter to the algebraic-geometry story:
C704/C705 do not merely notice the abstract Cremona--Richmond incidence
configuration; they derive its Segre coordinates, polar system, and signs
from one conference/exterior-power tower.  That possible novelty belongs to
the operator/compound theorem, not to the bare doily dictionary.

## Mystery ledger

| feature | status | exact remaining gate or owner |
|---|---|---|
| Are the ten Mermin parities sufficient to compare all ordinary sign systems? | settled: their five independent checks span the full left kernel of the point--context incidence map | none |
| Does any unrestricted contextual sign invariant see \(C\) or \(K\)? | settled negatively: the complete quotient identifies the Clebsch and Pauli systems | none |
| Why the parity quotient is the \([10,5,4]\) code with enumerator \(1+15y^4+15y^6+y^{10}\) | settled more sharply: it is explicitly coordinate-equivalent to Seymour's exceptional \(R_{10}\) code | none |
| Why the code is isodual but not self-dual | finite structure settled: the two minimum layers halve \(W_{10}\), meet through the common repetition line, and are exchanged by a 720-element coset containing one 36-element involution class | operator identification remains in C708 |
| Whether this is the classical binary quadratic-residue \([10,5,4]\) code and Construction-A \(Q_{10}\) lattice | settled up to the standard literature equivalences: explicit \(R_{10}\) coordinates plus uniqueness of the isodual class identify the QR/shortened-hexacode model and hence \(Q_{10}\) | C710 owns any bridge onward to \(E_8\) |
| Does the gauge trivialization respect outer \(S_6\), the Clifford lift, or golden \(A_5\)? | open and now the only surviving sign crown | C706 |
| Does the operator tower have an operational POVM meaning despite sign triviality? | open and logically independent of contextual signs | C707 |

## Literature boundary

No novelty or priority verdict is made.  Zero sources were read at full
text for this bounded positioning pass.

- Planat--Saniga, *On the Pauli graphs of N-qudits*,
  arXiv:quant-ph/0701211 — `abstract/metadata only`, arXiv abstract retrieved
  on 2026-07-30.  It identifies the two-qubit Pauli graph with the generalized
  quadrangle of order two and its grids and ovoids with Mermin squares and
  five mutually noncommuting observables.
- Okay--Chung--Ipek, *Mermin polytopes in quantum computation and
  foundations*, arXiv:2210.10186 — `abstract/metadata only`, arXiv abstract
  retrieved on 2026-07-30.  It treats context-sign functions up to the
  parity distinction in the Mermin scenario.
- Muller--Saniga--Giorgetti--De Boutray--Holweck, *Multi-qubit doilies:
  enumeration for all ranks and classification for ranks four and five*,
  arXiv:2206.03599 — `partial`, author-hosted text, introductory
  duad--syntheme and Cremona--Richmond descriptions read on 2026-07-30.
  It explicitly presents the doily as the Cremona--Richmond configuration,
  generalized quadrangle \(GQ(2,2)\), and symplectic polar space
  \(W(3,2)\), before studying signed higher-qubit doilies.
- Pokora--Szemberg, *A Pascal-type construction of the Segre cubic and the
  Cremona--Richmond configuration*, arXiv:2606.18387 —
  `abstract/metadata only`, arXiv abstract retrieved on 2026-07-30.  It
  explicitly couples the fifteen planes of the Segre cubic to the
  associated Cremona--Richmond configuration.  No formula-level comparison
  with the C704/C705 conference or compound operators was available at this
  depth.
- Kramer, *Some small large sets of \(t\)-designs* — `partial`,
  author-hosted PDF, §5 read on 2026-07-30.  It records the three
  nonisomorphic \(2\)-\((10,4,2)\) designs and the distinguished class with
  automorphism group of order \(720\).  The identification of the C705
  weight-four design with that class is our exact inference from its
  computed full automorphism order.
- Abdukhalikov--Bannai, *Association schemes related to universally optimal
  configurations* — `abstract/metadata only`, 2006 conference-program
  abstract retrieved on 2026-07-30.  It associates a binary
  quadratic-residue \([10,5,4]\) code to the Construction-A isodual lattice
  \(Q_{10}\) with automorphism group \(2^{10}\!:\!S_6\).
- Rains--Sloane, *Self-Dual Codes* — `partial`, author-hosted full text,
  §2.6 read on 2026-07-30.  It records the shortened-hexacode construction
  of an isodual binary \([10,5,4]\) code.
- Kashyap, *A decomposition theory for binary linear codes* — `partial`,
  author-hosted full text, Theorem 5.4 and its displayed matrix read on
  2026-07-30.  It identifies Seymour's \(R_{10}\) as the exceptional
  regular, neither graphic nor cographic, isodual \([10,5,4]\) code.  The
  coordinate equivalence above is an exact C705 computation against that
  displayed matrix.
- Alber--Beth--Charnes--Delgado, *A new class of designs which protect
  against quantum jumps* — `partial`, author-hosted full text, relevant
  isodual-code example read on 2026-07-30.  It states uniqueness of the
  isodual \([10,5,4]\) code and associates its two weight-four layers with
  a \(2\)-SEED.
- Bartoli--Marcugini--Pambianco, *Finite geometry and the Gale transform*
  — `abstract/snippet only`, publisher record retrieved on 2026-07-30.  It
  records uniqueness of the Steiner system \(S(3,4,10)=W_{10}\).  The
  occurrence and the order-\(1440\) marked automorphism calculation here
  are independently exact.

Eight metadata searches screened titles and abstracts for
`two-qubit Pauli doily duads synthemes Mermin grids ovoids S6 Sp(4,2)`,
`conference matrix Mermin square contextuality Pfaffian signs`,
`Clebsch cubic Pauli contextuality doily`, and
`Clebsch conference matrix contextuality`, followed by the exact-phrase
queries `Clebsch Pauli doily contextuality`,
`Segre cubic Pauli contextuality`,
`Cremona-Richmond Pauli`, and
`synthemes Pauli Segre cubic`.  They located the standard
doily/contextuality literature but no visible Clebsch, conference-matrix,
or compound-operator comparison.  This is not a full-text absence audit;
zbMATH, MathSciNet, citation graphs, and the full texts of the named sources
remain uncovered.

## Reproducibility

Primary exact generator:

```sh
cd /home/tavis/src/othello
python3 notes/2026-07-30-c705-clebsch-pauli-doily.py --check
```

Independent direct \(4\times4\) matrix replay:

```sh
cd /home/tavis/src/othello
python3 notes/2026-07-30-c705-clebsch-pauli-doily-replay.py
```

The primary generator uses only the Python standard library.  It checks the
complete \(15\)-point/\(15\)-context incidence dictionary, all \(720\)
induced symplectic maps, all ten grids, all six ovoids, both fifteen-entry
context-sign vectors, one exact gauge solution, the ranks \(10\) and \(5\)
of the incidence and grid-check matrices, completeness of the grid
invariants, the \([10,5,4]\) parity code and its full weight enumerator, all
fifteen weight-four design blocks, the full \(10!\)-permutation
automorphism and isoduality counts, all twenty triangle phases, all fifteen
tetrahedron relations, and all \(2^6\) conference switchings.
The replay independently multiplies explicit \(4\times4\) complex Pauli
matrices and rechecks the ten grid parities, the two binary ranks, the full
parity-code enumerator, the \(2\)-design, both exhaustive permutation
counts, and the conference rephasing identity.  It does not test the
still-open equivariant Clifford lift or identify the code with a classical
quadratic-residue presentation.

Hashes and byte counts are recorded in
`notes/2026-07-30-c705-clebsch-pauli-doily.sha256`.
