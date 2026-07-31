# C727 — cross-paper recovery--propagation and minimal marking

**Date:** 2026-07-31
**Lane:** `golden`
**Status:** theorem proved; paper-facing interface installed

## Outcome

The Paper I composite is true after one exact correction to the provisional
framing.  The unlabelled projective deep-hole locus is the twelve-point conic
and does not canonically remember a Clebsch parent.  The coarsest Paper I
object that does remember the Golden source is the **monomial Clebsch code
class**, equivalently the conic together with a selected geometric Clebsch
parent, or \(A_5\)-reduction.  Its unordered (10+10) split of the
three-coordinate supports is already a regular two-graph.  Either half
recovers a symmetric conference matrix \(C\), uniquely up to diagonal
switching, and the other half recovers \(-C\).  Thus the code class canonically
recovers the unoriented switching line

\[
 \ell_C=\{[C],[-C]\}.
\]

The \(S_6\)-orbit of this line is the outer six-set.  Choosing a half of the
support split lifts it to the coherent oriented six-family, with only a common
sign ambiguity; choosing switching representatives adds only diagonal gauge.
The frozen C720 propagation theorem therefore descends to the monomial code
class.  Projective cubic, determinant, polar, probability, parity-wall, and
anomaly outputs need no orientation choice.  A signed Pfaffian, Majorana
parity, Slater amplitude, or one golden resolution/MCM summand needs exactly
the marking recorded below.

The recovery cycle closes at the two-graph level:

\[
 \{\mathcal O_+,\mathcal O_-\}
 \longleftrightarrow \ell_C
 \longleftrightarrow [Z_C]
 \longleftrightarrow [\det[D_x,C]]
 \longleftrightarrow \text{relative dimer fingerprint}.
\]

It does not reconstruct the twelve-point conic or its factorization cover
from the operator shadow.  This is the exact information boundary.

## Input hierarchy and the first sufficient level

The recovery levels must not be treated as one monotone chain: the
twelve-point factorization cover and the six-coordinate support two-graph are
different markings.

| Paper I datum | What Paper I proves it retains | Golden verdict |
|---|---|---|
| unlabelled projective deep-hole locus | the full rational conic | insufficient: no preferred parent, secant matching, coordinate six-set, or orientation |
| conic with scalar decoder multiplicities | the ten Brianchon directions are distinguished | insufficient under the frozen theorem: scalar counts do not identify the six support labels or an \(A_5\)-reduction |
| decoder with its nearest-error supports | the ten outside matchings and the unique synthematic total | sufficient because retaining the six support labels is the monomial code marking in operational form |
| monomial Clebsch code class | the coordinate six-set, \(A_5\) stabilizer, and unordered (10+10) support split | coarsest proved sufficient source |
| marked twelve-point factorization cover | unordered (11+11) sheets; a signed cubic chooses a sheet; a singleton chooses a decorated row | transverse, not sufficient by itself: Paper I explicitly proves no row-to-geometric-parent bridge |
| chosen half of the support split | an oriented regular two-graph | recovers \(C\) rather than only \(\{C,-C\}\) |
| chosen switching gauges and determinant-line/golden marks | literal matrices and signed cross blocks | fully marked C720 input |

Thus “the syndrome locus determines the Golden family” is valid only if
“syndrome datum” includes the recovered monomial parent/support labels.  For
the bare unlabelled locus it is false as a canonical reconstruction statement.

## Support two-graph theorem

Let \(X\) be the six-coordinate set of the Clebsch code and let
\(H\cong A_5\) be its monomial permutation group.  Paper I proves that the
twenty triples split into two complementary \(H\)-orbits
\(\mathcal O_+,\mathcal O_-\), each of size ten, with no preferred sign.

### Theorem 1 (Paper I/C691 two-graph recovery)

For either choice of sign function

\[
 t_{ijk}=\begin{cases}
 +1,&\{i,j,k\}\in\mathcal O_+,\\
 -1,&\{i,j,k\}\in\mathcal O_-,
 \end{cases}
\]

the following hold.

1. Every four-subset contains two positive and two negative triples, so
   \(t\) is a two-graph cocycle.
2. There is a symmetric zero-diagonal sign matrix \(C\), unique up to
   diagonal switching, whose triangle holonomies are
   \(C_{ij}C_{jk}C_{ki}=t_{ijk}\).
3. Every pair lies in two positive and two negative triples, and hence
   \(C^2=5I\).
4. Interchanging the two support orbits sends the switching class of \(C\)
   to that of \(-C\).  The unordered support split therefore determines
   exactly the switching line \(\ell_C=\{[C],[-C]\}\).

The conclusion is the frozen C690/C691 Paper I interface.  The following
orbit-incidence argument is a shorter proof at exactly the quotient level
needed for C727.

#### Proof

The degree-six \(A_5\)-action is two-transitive.  Hence it is transitive on
pairs and, by complementation, on four-subsets.  Count incidences between
\(\mathcal O_+\) and four-subsets.  Each of the ten triples lies in three
four-subsets, giving thirty incidences distributed over fifteen four-subsets;
each four-subset therefore contains two members of \(\mathcal O_+\).  This is
the two-graph parity condition.

Choose \(r\in X\), put \(C_{ri}=1\), and for \(i,j\ne r\) put
\(C_{ij}=t_{rij}\).  The four-set identity gives

\[
 C_{ij}C_{jk}C_{ki}
 =t_{rij}t_{rjk}t_{rki}=t_{ijk}.
\]

A different choice of \(r\), or of the signs in the \(r\)-row, changes \(C\)
by diagonal switching.  This is also the standard inverse from a two-graph
to its switching class.

For a fixed pair, the same incidence count gives two positive triples among
the four triples containing it.  Therefore, for \(i\ne j\),

\[
 (C^2)_{ij}
 =\sum_{k\ne i,j}C_{ik}C_{kj}
 =C_{ij}\sum_{k\ne i,j}t_{ijk}=0,
\]

while \((C^2)_{ii}=5\).  Finally, \(-C\) negates every triangle holonomy, so
interchanging the two orbits produces \(-C\).  ∎

## Coherent outer completion and stabilizers

The oriented two-graph has stabilizer \(A_5\); its unoriented line has
stabilizer \(N_{S_6}(A_5)\cong S_5\).  Consequently

\[
 |S_6/A_5|=12,
 \qquad
 |S_6/S_5|=6.
\]

The twelve oriented classes pair under \(C\mapsto-C\) into the outer
six-set \(\mathcal T\).  Equivalently, after choosing one support half, its
\(A_6\)-orbit is a coherent oriented six-family.  Reversing that choice
negates all six members.  Literal matrices require a switching lift for each
member, but two lifts differ by diagonal conjugation and hence define the
same gauge-class outputs.  This proves the completion gate left open by
C720: Paper I's support split generates the coherent outer family; it does
not merely recover one unrelated conference matrix.

The stabilizer statement also shows why the marking is minimal.  The
unoriented line is an \(S_5\)-object, while a chosen orientation is an
\(A_5\)-object.  No \(S_5\)-equivariant rule can choose one of its two
\(A_5\)-sheets.

## Covariance and ambiguity ledger

Let \(\Gamma=(\{\pm1\}^X/\{\pm1\})\rtimes S_X\) be the
switching--permutation group.  The additional involutions are common
conference reversal \(\iota:C\mapsto-C\) and golden conjugation
\(\sigma:\sqrt5\mapsto-\sqrt5\).

| change | source effect | descended effect |
|---|---|---|
| axis permutation \(g\) | transports the support split and conjugates the switching class | permutes the outer six-set; \(Z_{gT}=\operatorname{sgn}(g)gZ_T\) in a signed lift |
| diagonal switch \(D\) | \(C_T\mapsto DC_TD\) | commutators conjugate; determinants, zero loci, probabilities, and gauge classes are fixed; Pfaffian representatives acquire the frame-orientation character |
| support-half exchange | \(C_T\mapsto-C_T\) for every \(T\) | \(Z\) and Pfaffians negate; \(Z^2,W\), determinants, probabilities, and walls are fixed |
| axis-orientation reversal | reverses the Hodge star | negates the middle-exterior \(Z\)-lift; projective lines and even shadows are fixed |
| \(x\mapsto x+c\mathbf1\) | no source change | every commutator shadow is fixed |
| \(x\mapsto\lambda x\) | projective source scaling | \(Z\mapsto\lambda^3Z\), while determinant and \(W\) scale by \(\lambda^6\) |
| golden conjugation | exchanges \(V_+\) and \(V_-\) | transposes the cross block and exchanges the two resolutions and rank-one MCM summands; their rational rank-two descent is fixed |

There are two sign choices in a fully marked formula: the support-half sign
of \(C\) and the orientation used by the Hodge/Pfaffian conventions.  Only
their product is visible in the projective Joubert vector.  Neither affects
the determinant square or centered square.

## Exact descent targets

| Golden output | Object descending from the monomial code class | Extra marking for a literal representative |
|---|---|---|
| middle exterior/Joubert | projective outer-six cubic map and its six projective cubic lines | support-half/Hodge orientation for a signed six-vector |
| Segre--Igusa | projective Segre point and rational polar map \(W\) | none beyond coordinate transport; \(W\) forgets the common sign |
| commutator Pfaffian | projective cubic line and zero locus | switching-frame/Pfaffian orientation for a signed polynomial |
| commutator determinant | projective sextic line, canonically reverse-faithful for \(\ell_C\) | none |
| cross-golden block | unordered conjugate pair of determinantal representations, small resolutions, and rank-one MCM sheaves; canonical rational rank-two descent | a choice of \(\sqrt5\), one summand, and compatible determinant-line orientation |
| assembled adjugate | projective rank-one factorization \([W][q]^{\mathsf T}\) | quotient bases for a displayed matrix |
| Cartan restriction | projective/gauge class of the Pfaffian linear section | an ambient Cartan coordinate frame and Pfaffian orientation for a literal section |
| Slater | squared success probability \(Z_T^2/500\) | golden frames and determinant phase for an amplitude |
| Majorana | signed-permutation/orthogonal-gauge class of the Hamiltonian family and the wall \(Z_T=0\) | a Majorana-frame orientation for the parity sign |
| synchronized spinors | unordered six-cell synchronized product with projective top coordinates | cell labels, gauges, and common Pfaffian sign |
| anomaly | projective six-charge solution modulo permutation, scale, and common sign | labelled normalized charges |
| dimer syndrome | relative matching-sign word and switching line \(\ell_C\) | an absolute matching sign or Pfaffian orientation is not recoverable |

The Clifford/doily, exceptional-parent, \(E_8\)--Hamming, and hyperbolic
lattice packages remain contextual relatives, not arrows in this composite:
the frozen interface supplies no functor from \(\ell_C\) to their full marked
objects.

## Reverse faithfulness and the smallest closing shadows

C720 proves

\[
 \Delta_C(x)=\det[D_x,C]=16Z_C(x)^2
\]

and

\[
 [x_i^2x_j^2x_kx_l]\Delta_C
 =32,t_{ijk}t_{ijl}.
\]

The Veronese square recovers \([Z_C]\).  Its squarefree coefficients recover
the triangle table up to common negation, and the displayed
((2,2,1,1))-coefficients recover the four-cycle holonomies directly.  Both
recover \(\ell_C\), exactly as the relative \(K_{3,3}\) matching signs do.
Hence the determinant sextic and the dimer fingerprint are two canonically
equivalent smallest reverse witnesses.  They split the recovery map on the
unoriented two-graph class.

No even shadow can split the orientation cover: \(C\) and \(-C\) have the
same determinant, \(W\), probability, parity wall, and relative dimer word.
A signed Pfaffian or signed Slater amplitude retains the bit only after the
corresponding frame orientation has been supplied.

## Complete nonzero fibres of centered squaring

Work over an algebraically closed field of characteristic zero.  Put

\[
 S=\{[z]\in\mathbf P^5:\sum z_i=\sum z_i^3=0\}
\]

and let

\[
 \pi([z])=[w],\qquad
 w_i=z_i^2-\frac16\sum_jz_j^2.
\]

The base locus consists of the ten Segre nodes, represented by the \(3+3\)
sign vectors.  Away from them, the fibres are as follows.

### Theorem 2 (polar-fibre classification)

1. If \(w\) is a smooth point of the Igusa quartic, \(\pi^{-1}(w)\) is one
   reduced projective point.
2. The singular locus of the Igusa quartic is the union of fifteen lines
   \(L_M\), indexed by perfect matchings
   \(M=ij|kl|mn\).  A point of \(L_M\) has coordinates
   \((\alpha,\alpha,\beta,\beta,\gamma,\gamma)\), after reordering, with
   \(\alpha+\beta+\gamma=0\).
3. If \(w\in L_M\) lies on no other singular line, its fibre is the smooth
   conic in the Segre plane
   \(\Pi_M=\{z_i+z_j=z_k+z_l=z_m+z_n=0\}\) given, in coordinates
   \((a,-a,b,-b,c,-c)\), by

   \[
   (\beta-\gamma)a^2-(\alpha-\gamma)b^2
      +(\alpha-\beta)c^2=0.
   \]
4. The fifteen intersection points of the singular lines have four equal
   coordinates and two equal coordinates.  Three singular lines pass
   through each.  The fibre there is the union of six projective lines; it
   is the union of the two components of the three degenerate conics from
   (3).

#### Proof

The map is the Gauss map of the Segre cubic.  Segre--Igusa duality makes it
birational, and at a smooth dual point the tangent hyperplane is unique;
this gives (1).  The classical fifteen Segre planes are contracted to the
fifteen singular Igusa lines, giving (2).

For the remaining assertions no classification theorem is needed.  If
\(w\in L_M\), equality of paired \(w\)-coordinates forces equality of the
corresponding \(z\)-squares.  Away from the intersections of singular lines,
the equations \(\sum z_i=\sum z_i^3=0\) force the signs in each pair to be
opposite.  Thus \(z=(a,-a,b,-b,c,-c)\).  The condition
\([\operatorname{center}(a^2,b^2,c^2)]=[\alpha,\beta,\gamma]\) is exactly the
displayed conic.  Its three diagonal coefficients are nonzero away from
\(\alpha=\beta\), \(\beta=\gamma\), or \(\gamma=\alpha\), so it is smooth.

At, say, \(w=(1,1,1,1,-2,-2)\), the first four \(z_i\) have a common square
and the last two have a common square.  The linear and cubic equations force
two plus and two minus signs among the first four and opposite signs in the
last pair.  Modulo common sign there are six sign patterns, each with one
free ratio of the two magnitudes.  They are six projective lines.  The three
pairings of the first four indices give the three singular lines through
\(w\), and each associated conic splits into two of these lines.  ∎

Projectively the smooth fibre is one point: common orientation reversal has
already been quotiented.  On a signed affine lift, centered squaring has the
unavoidable pair \(z,-z\).  At \(W=0\), twenty oriented \(3+3\) sign vectors
pair into the ten projective base points.  Thus the polar output is generically
faithful only after passing to projective orientation classes, and its exact
exceptional loss is the fifteen-plane contraction above.

## Minimal-marking obstruction

The bare projective deep-hole locus is a full rational conic.  Its
projectivity group is \(\mathrm{PGL}_2(11)\), while a Clebsch parent has
stabilizer \(A_5\).  The fixed conic therefore carries

\[
 [\mathrm{PGL}_2(11):A_5]=1320/60=22
\]

Coxeter matching rows, exactly the \(22\)-point matching orbit of Paper I.
The action is transitive, so there is no equivariant selection of one parent.
The first two quotient moments recover only an unordered (11+11) split;
the signed cubic and singleton profile select a sheet and a decorated row,
but Paper I explicitly leaves the row-to-geometric-parent map unproved.

This proves sharpness in the frozen cross-paper category:

- the unlabelled conic and its scalar decoder counts do not canonically
  produce the six-axis augmentation space on which the Golden operator acts;
- a factorization-sheet orientation is not a substitute for a support-half
  orientation;
- selecting a geometric Clebsch parent, equivalently retaining the monomial
  code class/support-labelled decoder, is sufficient;
- after that selection, the only further bit needed for signed odd shadows is
  a choice of one support half, and even/projective shadows need no such bit.

The theorem does not assert that the abstract isomorphism type of the order-six
conference matrix is hard to guess: it is unique.  The obstruction is to a
canonical, input-relative recovery map and to the identification of its six
axes and variables.

## Claim-by-claim dependency map

| arrow or assertion | source |
|---|---|
| deep-hole conic criterion and monomial Clebsch class | Paper I, rigidity theorem |
| decoder reconstruction of Brianchon matchings and support split | Paper I, Brianchon/support propositions |
| factorization sheets, signed sheet cubic, and no parent bridge | Paper I, factorization recovery and retention ledger |
| support split, continuation operator, and their mutual recovery | C690/C691 Paper I source theorem; C727 supplies the short orbit-incidence descent proof in Theorem 1 |
| completion to the coherent outer six-family | new C727 \(A_5\subset A_6\subset S_6\) orbit argument |
| marked forward shadows and formula-level covariance | frozen C720 operator interface |
| determinant/dimer reverse faithfulness | frozen C720 post-freeze and ej2 corollaries |
| exact nonzero polar fibres | new C727 Gauss-map and paired-square proof, Theorem 2 |
| minimal parent marking | new C727 transitive \(22=[\mathrm{PGL}_2(11):A_5]\) obstruction combined with Paper I's explicit source boundary |

## Bounded literature and priority audit

Two of the four external sources named below were available at `full text`;
the other two were read at the stated partial depth.  The audit supports the
terminology and classical boundary, not an absence-based originality claim.

- Goethals and Seidel, *Orthogonal matrices with zero diagonal* — `full
  text`, published 1967 article, all ten pages read from cache key
  `10.4153/CJM-1967-091-8`, SHA-256
  `68c0ef0b8fda6d44325382a047a873d2075ed2ad3cf9d0e6ec27ba7ace60b734`.
  It defines symmetric conference matrices, their switching/permutation
  equivalence, and the Paley projective-line construction.  It does not make
  the present Paper-I-to-shadow composite.
- Bussemaker--Mathon--Seidel, *Tables of two-graphs* — `partial`, 1979
  technical-report version corresponding to the later published chapter;
  Chapter 2 read from cache key `10.1007/BFb0092256`, SHA-256
  `ac9d300a4a0e5f46d4d4b36b66d5f620f616ffad3197ae93fad50b8ff224748a`.
  Chapter 2 gives the even-four-set definition and the exact equivalence
  between labelled two-graphs and switching classes used by Theorem 1.
- Kondō, *The Segre cubic and Borcherds products* — `partial`, arXiv
  version 1110.1126, Introduction and Section 2 read from cache key
  `arXiv:1110.1126`, SHA-256
  `0595df2ed7631ba366b1603aca9a924ef08cb93cdc84b906f2877b68c777e9be`.
  It states that the Segre dual map is birational, is undefined at the ten
  nodes, and is given by quadrics; it also records the fifteen Segre planes.
- Howard--Millson--Snowden--Vakil, *A description of the outer automorphism
  of \(S_6\), and the invariants of six points in projective space* — `full
  text` in the inherited C704 audit, all eight pages, cache key
  `arXiv:0710.5916`, SHA-256
  `d2da258cd8513a9b782a8270baa82acc51bc8d552e18db104967c2a08bffebfc`.
  It supplies the classical outer-six/Joubert/Segre--Igusa context already
  separated by C704 from the operator lift.

The exact support-incidence proof, the composition with Paper I, the
marking ledger, and the complete coordinate fibre calculation were not found
as one theorem in this bounded search.  Because no exhaustive formula-level
or citation-graph audit was run, the manuscript must not say “first,” “new,”
or “to our knowledge” about the synthesis.  Its defensible statement is a
paper-owned composition and descent theorem whose ingredients include
classical two-graph switching and Segre--Igusa duality.

Load-bearing searches screened web metadata/full-text results for “regular
two-graphs conference matrices switching classes,” “Segre cubic Gauss map
Igusa quartic singular 15 lines fibers,” and “conference matrix two-graph six
vertices \(A_5\) outer automorphism \(S_6\).”  MathSciNet and zbMATH were not
covered; this licenses no global negative priority verdict.

## Paper-facing interface

The Golden paper may state the following corollary after its abstract marked
propagation theorem.

> **Recovery--propagation and minimal-marking corollary.**  A monomial
> Clebsch code class canonically determines the unoriented switching line of
> a golden conference operator and its coherent outer six-family modulo
> common reversal and diagonal gauge.  Hence every projective or even shadow
> in the Golden propagation theorem descends to that code class.  Choosing
> one half of the invariant support two-graph supplies the minimal extra bit
> for signed odd shadows; choosing a golden embedding supplies the independent
> bit selecting one cross-golden resolution or rank-one MCM summand.  The
> determinant sextic and relative dimer fingerprint each recover the
> unoriented switching line.  The unlabelled deep-hole conic alone does not
> determine this input-relative family: a geometric Clebsch parent, or
> equivalent monomial marking, is necessary.

No Clebsch manuscript edit is authorized.  After a stable Golden preprint,
Paper I may receive a separate conclusion-level pointer to the identity
\(\operatorname{Pf}[D_x,C]=4Z_C(x)\); that remains a Clebsch-lane decision.

## `ej` + `tt` closeout and mystery ledger

- **Settled at the C727 quotient level:** the C690/C691 support
  bipartition--continuation theorem descends by incidence counts alone; the
  two-graph parity and \(C^2=5I\) need no frozen coordinate matrix.
- **Settled by the main proof:** one recovered switching line completes to
  the coherent outer six-family through the \(A_5\subset A_6\subset S_6\)
  orbit; no six independent choices remain.
- **Settled by the reverse audit:** determinant and dimer shadows split the
  recovery map exactly at the unoriented two-graph level, not at the full
  conic-code level.
- **Settled by the polar audit:** the nonzero information loss is precisely
  the contraction of fifteen Segre planes to fifteen Igusa singular lines;
  generic exceptional fibres are conics and the fifteen triple-line points
  have six-line fibres.
- **Settled by the minimality audit:** the factorization orientation and the
  support-two-graph orientation are distinct torsors.  The former does not
  instantiate the Golden theorem without a row-to-parent bridge.
- **Open outside C727:** construct, or prove impossible, a canonical bridge
  from Paper I's oriented factorization row to its geometric Clebsch parent.
  This is not needed by the monomial-code corollary and requires a separately
  allocated cross-lane task before any Paper I edit.
- **Open outside C727:** determine whether C730 supplies a second provenance
  corollary from Paper III's arithmetic--harmonic source.  C727 does not
  depend on it.
- **No unexplained ambiguity remains in the C727 descent theorem.**  Every
  surviving choice is a named switching, permutation, support-orientation,
  projective-scale, frame-orientation, or golden-conjugation torsor.

**Vibe check:** strong positive with a useful correction.  The cross-paper
theorem closes cleanly at the monomial-code/two-graph level, while the bare
conic claim fails for a precise (22)-parent symmetry reason rather than a
missing calculation.
