# C1015 — global obstruction beyond the six-local matching test

**Lane:** `relconic`

**Status:** The ten-point theorem is now universal: every geometrically
transversal one-factorization of (K_{10}) is a pencil, over every field.
For the regular matching design this forces every canonical
one-factorization line, after which Nagy's theorem gives the exact field
boundary. The nine-point extension and broader literature-priority audit remain open;
the geometric closest-seed and graph-shadow bounded sweeps are closed. No
manuscript, summary,
mirror, formal, release, or Ergodis source edits are authorized.

Literature depth for the sources added or reused in this report: **eight were
read at full-text depth** (Nagy; Korchmaros--Pace--Sonnino; Dinitz--Dukes--
Stinson; Meszka; Kaski--de Souza Medeiros--Ostergard--Wanless; Venkaiah--
Ramanjaneyulu--Jampala--Prasad; Allsop; and the arXiv version of Erskine--
Griggs). Tohaneanu--Xie, Dinitz--Garnick--McKay, Gelling, Ziegler,
Kiss--Korchmaros--Romaniello--Smaldore, and the later published Erskine--Griggs
passage were read at the explicitly recorded partial depths below. The
literature-priority verdict remains bounded and provisional.

## Starting point

C1003 classified the four simple `MATCH(9,4,1)` designs over arbitrary
fields. Exactly one odd-characteristic representative passes the C1002/C1008
test on every six-set. Seven concurrence equations admit the human reduction

\[
-\frac{2(r-1)^2}{r^2}=0,
\]

where the frame arc inequalities give `r!=0,1`; this also explains the
characteristic-two degeneration. Exact elimination independently yields
`x_8^2(x_8-1)^2`. The replay is
`notes/c1003_match9_rank_three.py`; the publication and literature context is
`notes/2026-08-30-c1003-matching-design-publication-routing.md`.

## Objective

Make the ratio defect projectively intrinsic and determine the strongest
reusable theorem it supports. The preferred outcome is a global compatibility
or holonomy invariant forced by rank-three chord concurrency and strictly
refining all six-local tests.

## Literature correction and priority ceiling

Nagy, _Embeddings of Ree unitals in a projective plane over a field_, proves
that the Ree unital `R(3)` embeds in `PG(2,K)` if and only if `F_8` is a
subfield of `K`, and then the embedding is unique and contained in an
order-eight subplane. In the regular-hyperoval model its 63 dual points are
exactly the 63 perfect-matching centers. Its 28 dual lines are exactly the 28
one-factorizations of `K_10`, each collecting nine matching centers.

The C1003 replay now verifies this intrinsically: the regular matching design
has exactly 28 one-factorizations, each block occurs in four, and each pair of
factorizations shares exactly one block, giving a `2-(28,4,1)` design. The
nonhyperoval class has only one one-factorization. The identification of the
regular incidence design with `R(3)` uses Nagy's external-point/external-line
model; the count and intersection parameters are exact internal computation.

Our realization hypothesis does not assume those nine-point sets collinear;
it assumes only that each perfect matching is realized by concurrent secants.
Thus the first literature-priority question is now the **Ree bridge**:

> Does every rank-three realization of the regular `MATCH(10,5,1)` design, or
> either of its nine-point deletions, force the nine centers in each canonical
> one-factorization to be collinear?

If yes, Nagy's theorem replaces the entire regular-class coordinate
classification and adds uniqueness, admissibility, and subplane containment.
The publishable contribution would be the automatic completion from secant
concurrences to the Ree-unital line structure, not the already classical `F_8`
boundary. Nagy's odd-characteristic factor `2` and characteristic-two cubic
`v^3+v^2+1` closely parallel the C1003 calculation; checking whether the seven
blocks are a literal super O'Nan shadow is mandatory before a novelty claim.

## Landed judo theorem: Hamilton pairs force pencils

Let (K) be a field, let (L_0,\ldots,L_{2m-1}) be lines in
\(\operatorname{PG}(2,K)\) with no three concurrent, and let \(\mathcal F\)
be a one-factorization of (K_{2m}). Suppose that for every factor
\(M\in\mathcal F\) there is a transversal (T_M) containing all (m) star
points (L_i\cap L_j) with (ij\in M).

**Star-factorization interpolation theorem.** Choose defining forms
\(\ell_i,t_M\), put (P=\prod_i\ell_i) and
\(Q=\prod_{M\in\mathcal F}t_M\). There are nonzero scalars (c_i), unique
up to common scaling, such that

\[
 Q=\sum_i c_i\frac{P}{\ell_i}.
\]

For every edge (ij\in M), restriction to (T_M) and cancellation of the
two simple poles at (L_i\cap L_j) give

\[
 t_M\ \doteq\ c_j\ell_i+c_i\ell_j.
\]

Here \(\doteq\) means equality up to a nonzero scalar. Equivalently, after
putting (u_i=\ell_i/c_i),

\[
 t_M\ \doteq\ u_i+u_j \qquad(ij\in M).                 \tag{1}
\]

This is a self-contained degree-((2m-1)) interpolation identity. On (L_i),
(Q) and (P/\ell_i) have the same (2m-1) distinct zeros, so their
restrictions are proportional. Subtracting all resulting terms gives a form
of degree (2m-1) divisible by all (2m) lines, hence zero. None of the
constants vanishes because no transversal can equal a carrier line.

**Hamilton-pair parity theorem.** Suppose (A,B\in\mathcal F) form a
Hamilton cycle. Set (W=\langle t_A,t_B\rangle), start the alternating cycle
at vertex (0), and let (x) have cycle distance (r) from (0). If (M_x)
is the factor containing (0x), normalize its defining form by
\(t_{M_x}=u_0+u_x\). Then

\[
 t_{M_x}\equiv \bigl(1+(-1)^r\bigr)u_0\pmod W.        \tag{2}
\]

Indeed, (1) along each alternating edge says
\(u_{r+1}\equiv-u_r\pmod W\), and the edge (0x) says
\(t_{M_x}\doteq u_0+u_x\). Thus in every characteristic the factor centers
split into two parity layers modulo the pencil generated by (A,B). In
characteristic two the layers collapse, every (t_M\in W), and all
transversals (T_M) are concurrent. Dually, all matching centers are
collinear.

There is a stronger all-characteristic consequence that does not require a
closure computation when (m) is odd. The Hamilton cycle is bipartite, with
parts (X,Y) of size (m). If a factor (C) has any edge (xy) crossing this
bipartition, then the alternating recurrence gives

\[
 u_y\equiv-u_x\pmod W,
 \qquad t_C\doteq u_x+u_y\in W.
\]

When (m) is odd, every perfect matching has a crossing edge: otherwise it
would restrict to perfect matchings of the two odd sets (X) and (Y).
Consequently **one Hamilton pair forces every transversal into its pencil
over every field whenever (m) is odd**. When (m) is even, the only factors
not forced onto this pencil are those that split as perfect matchings inside
(X) and inside (Y). Multiple Hamilton pairs can still eliminate that residual
set: if the resulting forced-factor sets have connected closure under union
of sets sharing two factor labels, their pencils coincide.

This has three useful general forms.

1. Every geometrically transversal one-factorization over a field of
   characteristic two that contains a perfect pair has all its transversals
   in one pencil. In particular this holds for every geometrically realized
   perfect one-factorization.
2. Over an arbitrary field, if (m) is odd, a geometrically transversal
   one-factorization containing just one Hamilton pair has all its
   transversals in one pencil.
3. Fix vertex (0), label a factor by its partner (k) at (0), and attach
   the triple \(\{i,j,k\}\) whenever (ij\in M_k\). In characteristic two,
   (1) makes the three corresponding transversal forms collinear in their
   parameter plane. Therefore it is enough that these triples have connected
   closure under union of triples sharing two labels. A Hamilton pair implies
   this closure condition, but is not necessary.

The factor (2) in (2) is the invariant mechanism behind the odd/characteristic-
two split seen in the seven-concurrence calculation. It replaces a normalized
ratio accident by a projective parity holonomy.

## Universal order-ten pencil theorem

The Hamilton-pair theorem admits a complete order-ten closure.

> **Theorem.** Let (L_0,\ldots,L_9) be ten lines in
> \(\operatorname{PG}(2,K)\) with no three concurrent. If the edges of
> (K_{10}) admit a one-factorization such that the five star points belonging
> to every factor are collinear, then the nine factor transversals form a
> pencil. This holds over every field and for every one-factorization of
> (K_{10}).

Here (m=5) is odd. Thus the preceding theorem makes the pencil conclusion
immediate as soon as the factorization has one Hamilton pair. The direct
rooted lemma proved below handles the complementary case without a global
one-factorization census.

- If at least one pair of factors is Hamilton, the odd-half theorem gives the
  pencil directly.
- If no pair is Hamilton, every factor pair has
  cycle type (4+6). Its parity constraints are the twelve triples of the
  Steiner triple system (AG(2,3)) on the nine factor forms. Adding any other
  collinear triple makes the two-point closure all nine, so a non-pencil
  realization would have to be an exact projective representation of
  (AG(2,3)). Ziegler's classical coordinatization says that such a
  representation exists precisely when the field contains a root of
  \(\omega^2-\omega+1\); it is not restricted to characteristic three.
  The exceptional factorization itself has the transparent affine form
  \[
  M_a=\{\{\infty,a\}\}\cup
      \{\{x,y\}:x+y=-a\},\qquad a\in\mathbf F_3^2,
  \]
  and automorphism-group order 432. Thus the appearance of the affine-plane
  shadow is structural, not an accidental isomorphism found after the census.
  Write (z=u_\infty). The edge \(\infty a\in M_a\) and (1) give

  \[
  u_a=-z+s_at_a
  \]

  for some scalar (s_a). If \(\{a,x,y\}\) is an affine line, then
  (x+y=-a), so (xy\in M_a\). Its lift equation becomes

  \[
  -2z+s_xt_x+s_yt_y\in\langle t_a\rangle.
  \]

  The three Hesse points (t_a,t_x,t_y) are collinear. Hence (2z) lies in
  the vector plane defining every Hesse line. In fact three lines suffice:
  (012) and (036) meet only at Hesse point (0), while (138) avoids
  that point. Their three vector planes have zero total intersection.
  Therefore (z=0) whenever (2\ne0), impossible for a carrier defining
  form. In characteristic two, the universal characteristic-two triple
  closure already forces the nine transversals to be a pencil. This kills the
  exceptional class over every field without coordinates or row reduction.

  Only six instances of (1) are used. In affine-point labels they are the
  three edges \(\infty0,\infty1,\infty3\) and

  \[
  01\in M_2,\qquad 03\in M_6,\qquad 13\in M_8.
  \]

  They produce the three Hesse lines (012,036,138), respectively. This is
  minimal within the three-line method: three vector-plane constraints need
  three finite-edge equations, and three distinct finite edges use at least
  three endpoint equations; choosing a triangle attains six. Thus the
  exceptional census class is excluded by a bounded **Hesse-tripod lemma**
  involving only four carrier variables and six factor points. The lemma
  applies to any larger transversal design containing this incidence shadow,
  independently of a complete one-factorization.

  As independent regression evidence, the earlier exact Hesse lift still
  finds a full minor (-8(1+\omega)), of norm 192, and the characteristic-
  three specialization has rank 74 with its unique nullvector satisfying
  (u_\infty=0\). Those computations are no longer load-bearing for the
  theorem.

The global 396-class census can now be removed from the load-bearing proof.
Fix one factor (F), and regard its five edges as the vertices of a (K_5).
For every other factor (G), the assumed absence of a Hamilton pair means that
(F\cup G) has cycle type (4+6). Let (s(G)) be the pair of (F)-edges in its
four-cycle, and let (d_e) count factors with signature (e\in E(K_5)). The
four original graph edges between the two (F)-edges indexed by (e) give

\[
 2d_e+\sum_{f\cap e=\varnothing}d_f=4.             \tag{2a}
\]

The nonnegative integral solutions with (\sum d_e=8) have only two
(S_5)-orbits, and this needs no finite search. The disjointness graph on
(E(K_5)) is the Petersen graph. Its adjacency operator (A) acts by (-2) on
the four-dimensional standard module

\[
 (a_i)_{i=0}^4\longmapsto (a_i+a_j)_{ij},
 \qquad \sum_i a_i=0,
\]

while it acts by (3) on constants. Hence all rational solutions of (2a) have
the form

\[
 d_{ij}=\frac45+a_i+a_j=x_i+x_j,
 \qquad \sum_i x_i=2.                              \tag{2b}
\]

Because every (x_i+x_j) is integral, all (x_i) have the same fractional
part. Pair sums make that fractional part either (0) or (1/2), and the sum
of five (x_i) rules out (1/2). Thus the (x_i) are integers. Nonnegativity of
all pair sums rules out a negative entry: a unique negative entry would force
the other four to be at least one and make their sum exceed two. Therefore
the only partitions of two are

\[
 (2,0,0,0,0),\qquad (1,1,0,0,0),
\]

up to permutation. They give respectively:

- the **star pattern**, with multiplicity two on the four edges through one
  vertex of (K_5) and zero elsewhere;
- the **(3+2) pattern**, with multiplicity two on the edge inside the
  two-part, multiplicity one on the six crossing edges, and zero on the
  three edges inside the three-part.

The same operator gives a more general census-free Hamilton-shadow formula.
Suppose (F) has (h) Hamilton partners, and let (s_{ij}) count how many of
their contracted five-cycles use edge (ij) of the (K_5). The remaining
factors have signature multiplicities (d_{ij}), and edge coverage gives

\[
 (2I+A)d=4\mathbf1-s.                              \tag{2c}
\]

Every vertex of the weighted graph (s) has degree (2h). Hence (s) has no
component in the (-2)-eigenspace of the Petersen adjacency operator: it is
the sum of its constant component ((h/2)\mathbf1) and a vector in the
(1)-eigenspace. Inverting (2I+A) on those two nonsingular summands gives the
**Petersen potential formula**

\[
 d_{ij}=\frac{h+12}{15}-\frac{s_{ij}}3+a_i+a_j,
 \qquad \sum_i a_i=0.                              \tag{2d}
\]

In particular, integrality of (d) forces the ternary quadrilateral law

\[
 s_{ij}+s_{k\ell}-s_{ik}-s_{j\ell}\equiv0\pmod3   \tag{2e}
\]

for all four distinct indices. No factor can therefore have exactly one
Hamilton partner: a single contracted five-cycle, say
(01,12,23,34,40), violates (2e) on indices (0,1,2,4), where the displayed
alternating sum is (1). Thus the Hamilton-pair graph on the nine factors has
no leaves. At (h=0), formula (2d) reduces to (2b), so the no-leaves theorem
and the zero-degree classification are two specializations of one character
formula rather than separate coincidences.

Equivalently, the Hamilton shadow modulo three lies in the potential code

\[
 \mathcal C_5=
 \{(r_i+r_j+c)_{ij}:r_i,c\in\mathbf F_3\}
 \subseteq\mathbf F_3^{10}.                        \tag{2f}
\]

This is a ([10,5,4]_3) code with weight distribution

\[
 1+30z^4+60z^6+120z^7+20z^9+12z^{10}.
\]

There is a census-free general form of this code calculation. For (m\ge3),
put

\[
 \mathcal C_m=\{(r_i+r_j+c)_{ij}:r_i,c\in\mathbf F_3\}.
\]

The kernel of the displayed parametrization consists exactly of
((r_i,c)=(t,-2t)), so (\dim\mathcal C_m=m). Shifting every (r_i) by a
common constant gives each word a unique representative with (c=0). If
(n_0,n_1,n_2) are the multiplicities of the three values among the (r_i),
the number of zero coordinates is

\[
 \binom{n_0}{2}+n_1n_2.
\]

Consequently the Hamming weight enumerator is

\[
 W_m(z)=\sum_{n_0+n_1+n_2=m}
 \binom{m}{n_0,n_1,n_2}
 z^{\binom m2-\binom{n_0}{2}-n_1n_2}.             \tag{2g}
\]

For (m\ge5), convexity in (n_0), after maximizing (n_1n_2) for fixed
(n_0), shows that the largest zero set of a nonzero word has size
(\binom{m-1}{2}). Hence (\mathcal C_m) has parameters
([\binom m2,m,m-1]_3). At (m=5), (2g) gives the displayed distribution
directly; the 243-word check is therefore regression evidence rather than a
proof ingredient. This theorem identifies the invariant target at every
Johnson level. It does **not** by itself show that the contracted Hamilton
shadow of an arbitrary (K_{2m}) factorization lies in (\mathcal C_m); that is
the substantive higher-order question.

Thus (2f) packages more than the no-leaves statement. A single contracted
five-cycle would have forbidden weight five. If (h=2), the shadow support is
the union of the two contracted five-cycles. Two five-cycles in (K_5) meet in
(0,2,3), or (5) edges, giving union weights (10,8,7), or (5); the code allows
only (10) and (7). Hence the two cycles must meet in exactly zero or three
edges. The rooted certificate independently enumerates all 243 potential-code
words and checks the displayed weight distribution.

This reduction has a direct rooted completion lemma. After fixing endpoint
labels on the five edges of (F), the star pattern has 640 exact-cover
completions. Their numbers of Hamilton pairs away from (F) are respectively
(0,12,16), with multiplicities (16,192,432). The sixteen Hamilton-free
completions form one orbit under the explicit
(S_4\ltimes C_2^5)-action, and every one has a single vertex common to all
36 four-cycles. The (3+2) pattern has 192 completions, one orbit under the
explicit ((S_3\times S_2)\ltimes C_2^5)-action; every completion has exactly
23 Hamilton pairs away from (F), so this pattern is impossible in the
zero-Hamilton case. The remaining star orbit is the affine (AG(2,3))
factorization displayed above. Thus the finite residue is a five-pair
endpoint chase, not an enumeration of one-factorizations of (K_{10}).
More generally, this proves the rooted spectrum statement: if the
Hamilton-pair graph has an isolated factor, then its total number of edges is
one of (0,12,16,23). The zero case is exactly the affine factorization.

There is also a sharp **rooted Hamilton-gap theorem**. For every
one-factorization of (K_{10}), its Hamilton-pair graph (H) satisfies

\[
 E(H)=\varnothing\quad\hbox{or}\quad |E(H)|\ge12.                 \tag{2h}
\]

Moreover, if (H) has no isolated vertex, then

\[
 |E(H)|\ge18.                                                     \tag{2i}
\]

Both bounds are attained. The current proof is a direct finite rooted proof,
not a consequence of the 396-class census. If (H) is nonempty, choose one
Hamilton pair and relabel its alternating ten-cycle to a fixed pair of
matchings. There are 293 perfect matchings disjoint from that pair and exactly
173,008 exact covers of the remaining 35 edges by seven of them. Direct cycle
testing gives minimum 12 over all completions and minimum 18 over completions
with no isolated factor. At equality 12 the only degree sequences are

\[
 (0,2,2,2,2,2,2,6,6),\qquad(0,2,2,2,3,3,4,4,4),
\]

while equality 18 has six degree sequences, frozen in the rooted certificate.
The order-20 dihedral stabilizer of the rooted Hamilton cycle is applied
explicitly only to summarize equality orbits; it is not used to discard any
completion. A conceptual propagation proof of (2h)--(2i), presumably using
compatibility between the two oriented shadows of each Hamilton pair, remains
an important proof-compression problem.

The rooted data isolate a substantially smaller structural lemma. If (FG) is
an edge of (H), then

\[
 d_H(F)+d_H(G)\ge6.                                  \tag{2j}
\]

Equivalently, after deleting the rooted edge, if (A) of the remaining seven
factors are Hamilton with (F) and (B) are Hamilton with (G), then
(A+B\ge4). In particular, a degree-two factor can be adjacent only to factors
of degree at least four. The fixed-Hamilton-pair certificate proves (2j)
without the global census; a human proof of this two-root amplification lemma
is the immediate local target.

Modulo that local lemma, (2h) already has a short structural proof. If (H)
has an isolated vertex, the rooted spectrum above gives (0,12,16), or (23).
Otherwise the ternary code gives minimum degree at least two. Let (a,b,c) be
the numbers of vertices of degrees (2), (3), and at least (4). If (a=0), the
handshake lemma gives at least 14 edges. If (a>0), (2j) sends all (2a)
incidences from the degree-two vertices into the (c) high-degree vertices, so
(c\ge2) and

\[
 2|E(H)|\ge 2a+3b+\max(4c,2a)\ge24,
 \qquad a+b+c=9.
\]

The last inequality is a two-case check according as (a\le2c) or (a>2c).
Thus a nonempty Hamilton graph has at least 12 edges. This reduces the human
proof of the first gap from 173,008 completions to the single local statement
(2j).

There are two further exact structural reductions for (2j)--(2i). First, the
Hamilton cycle (F\cup G) has a (5+5) alternating bipartition. Every other
factor crosses this cut an odd number of times, and the seven crossing counts
sum to 15. Hence their multiplicities at (1,3,5) are exactly one of

\[
 (3,4,0),\qquad(4,2,1),\qquad(5,0,2).              \tag{2k}
\]

This turns (2j) into a bounded matching problem on the two (K_5) halves,
rather than a one-factorization census.

The degree-two case of this local problem is smaller still. Contract such a
factor (F), and let (C_1,C_2) be the two five-cycles supplied by its Hamilton
partners. The potential-code argument says that (|C_1\cap C_2|) is zero or
three. Up to the Petersen action, the edge-coverage multiplicities (d) from
(2c) then have only the following four shapes. The last column is presently
a rooted-certificate consequence; turning it into a four-row endpoint-bit
chase would be a human proof of the degree-two case of (2j).

\[
\begin{array}{c|c|c}
 |C_1\cap C_2|&\text{nonzero multiplicities in }d
    &\text{minimum degree of either Hamilton partner}\\ \hline
 0&1^6&5\\
 3&1^6&4\\
 3&2,1^4&4\\
 3&2^2,1^2&4
\end{array}
\]

There is also a topological formulation of the full two-root lemma. Regard
(F\cup G) as an alternating Hamilton decagon. For any remaining factor (M),
attach a disc to every bicolored cycle of the properly three-edge-colored
cubic graph (F\cup G\cup M). This gives a connected closed surface. Write
(\epsilon_{FM}) and (\epsilon_{GM}) for the indicators that the indicated
factor pairs are Hamilton. Its three numbers of bicolored faces are

\[
 1,\qquad 2-\epsilon_{FM},\qquad2-\epsilon_{GM},
\]

so, from ten vertices and fifteen edges,

\[
 \chi(M)=-(\epsilon_{FM}+\epsilon_{GM}),\qquad
 \gamma(M)=2+\epsilon_{FM}+\epsilon_{GM},           \tag{2l}
\]

where (\gamma=2-\chi) is Euler genus. The seven factors (M) partition the
35 diagonals of the decagon. Consequently (2j) is exactly the assertion

\[
 \sum_M\bigl(\gamma(M)-2\bigr)\ge4,
 \quad\text{equivalently}\quad \sum_M\chi(M)\le-4.  \tag{2m}
\]

This reframes the endpoint chase as a genus-defect packing problem for a
one-factorization of the diagonals of a decagon. It is not yet a proof: the
missing step is to show that seven disjoint chord matchings cannot all have
total Euler-genus excess at most three. But it exposes a plausible route via
rotation systems or matching book embeddings and explains why the desired
quantity is additive over the seven residual factors.

Third, let (\tau_1,\ldots,\tau_9) be the matching involutions on the
ten-dimensional permutation space (U), and put

\[
 T=\sum_{i=1}^9\bigwedge\nolimits^2\tau_i
 \quad\hbox{on }\bigwedge\nolimits^2U.
\]

For (i\ne j), the product (\tau_i\tau_j) has cycle type ((5,5)) on a
Hamilton pair and ((2,2,3,3)) otherwise. The exterior-square character has
values (0) and (-2) on those two types. Therefore

\[
 \operatorname{tr}(T^2)
 =9\binom{10}{2}-4(36-|E(H)|)
 =261+4|E(H)|.                                      \tag{2n}
\]

Thus (2h) is the spectral-energy jump (261\to309), while the no-isolate
bound (2i) is exactly the stronger jump to (333). The operator (T) is a
canonical integral signed operator on the 45 edges, with a forced
nine-dimensional (-1)-eigenspace coming from the standard representation.
Proving the (333) lower bound from that forced module and the absence of an
isolated factor is the cleanest current route to a fully structural proof of
(2i).

There is a sharper local presentation of the 640-row star table. Form a graph
on its four two-factor signature groups, joining two groups when all four
cross-pairs have cycle type (4+6). Each such group edge has a color: the
endpoint of the distinguished base edge used by its four-cycles. The only
possible uncolored graphs are the empty graph, a perfect matching, a triangle,
and (K_4), occurring respectively (512,48,64,16) times. The perfect-matching
edges have opposite colors, while every triangle and (K_4) is monochromatic.
Thus the zero-Hamilton hypothesis produces a monochromatic (K_4), and its
color is the common vertex of all 36 four-cycles. A direct bit-table proof of
this **endpoint-closure lemma** is the remaining presentation compression;
the exact rooted proof already verifies it without the global census.

Once the common vertex (\infty) is known, recognition of the affine residue
is entirely human. Label each factor (M_a) by the finite vertex paired with
(\infty). For distinct (a,b), the unique four-cycle of (M_a\cup M_b) contains
(\infty,a,b) and one further vertex (c). Its alternating edges give
(bc\in M_a) and (ac\in M_b). Applying the same statement to
(M_a,M_c) then gives (ab\in M_c). Thus (\{a,b,c\}) is symmetric in its
three entries, and every pair of the nine finite vertices lies in exactly one
such triple. These twelve triples form an (STS(9)), which is uniquely the
affine plane (AG(2,3)). This identifies the remaining factorization with

\[
M_a=\{\infty a\}\cup\{xy:x+y=-a\}
\]

without coordinates or an isomorphism computation.

### Geometric origin of the affine residue

C1014 supplies a stronger identification of this exception. On
(\mathbf P^1(\mathbf F_9)), the exponent-(4) Baer coloring has 30 zero-color
four-sets, exactly the Baer sublines or circles of the Miquelian inversive
plane of order three. Fix a point (P). For every (Q\ne P), the four circles
through (P,Q) have four residual pairs that partition the remaining eight
points, and

\[
 F_{P,Q}=\{PQ\}\cup\{\text{those four residual pairs}\}
\]

is a perfect matching. The nine matchings ((F_{P,Q})_{Q\ne P}) factor
(K_{10}). For (P=\infty), this family is set-equal to the affine family
((M_a)) above, and every factor pair has type (4+6). Thus the exceptional
zero-Hamilton factorization is not merely coordinatized by (AG(2,3)): it is
the rooted residual-pair factorization of the Miquelian inversive plane.

The exact C1014 bridge check verifies all ten roots. Inside
(PGL_2(9)), the factorization stabilizer has order 72, so its orbit has size
(720/72=10), precisely the ten choices of root; the semilinear stabilizer has
order 144. This is an abstract/geometric construction of the exceptional
factorization, not a rank-three realization of the C1015 carrier-transversal
incidence, so it does not evade the Hesse obstruction. It does suggest a more
conceptual stability route to (2h): interpret Hamilton pairs as defects of the
rooted circle-residue structure and prove that any nonzero defect orbit has
size at least 12.

The independent 396-class census remains useful regression evidence. It is
normalized by the classical totals 396 unlabelled classes and 1,225,566,720
labelled factorizations, the latter recovered from the computed automorphism
orders. This also detects and avoids the erroneous 1,255,566,720 count
repeated in some secondary sources.

For the regular Ree factorization, the nine non-Hamilton pairs form three
disjoint triangles, so its Hamilton-pair graph is (K_{3,3,3}). These are
exactly the three diagonal-triple packets found in the preliminary
quadrangle calculation. The 27 cross-part Hamilton pairs supply the global
glue that the local characteristic-two argument lacked.

## Odd near-factorization completion as a balanced-gain problem

The adjoint argument is not special to nine carriers. Let (n) be odd, let
(L_1,\ldots,L_n) be carrier lines, and let
((M_h)_{h=1}^n) be a near-one-factorization of (K_n), indexed so that
(M_h) misses (h). If a transversal (T_h) contains the star points assigned
by (M_h), define (P=\prod_i\ell_i) and (Q=\prod_ht_h). The argument below
proves the following **odd near-factorization adjoint theorem**.

- The assigned transversal directions admit an adjoint
  (F=\sum_i a_iP/\ell_i), with every (a_i\ne0), exactly when their edge gain
  is balanced.
- Under the expected-incidence hypothesis, balance forces the (n) residual
  points (L_h\cap T_h) to be collinear, producing the missing
  ((n+1))-st carrier.

Indeed there are (\binom n2) assigned contacts, of total length
(2\binom n2=n(n-1)), which exhaust the complete intersection of (P) with
the degree-((n-1)) adjoint (F). Thus (Q=cP+\ell_0F), and the residual points
lie on (\ell_0). The first assertion is just the graph-theoretic fact that
edge ratios are vertex ratios exactly when all cycle holonomies are trivial.
The present nine-point calculation is an unresolved geometric instance of
this general theorem.

The deletion problem has a frame-free reduction that is substantially smaller
than the original concurrence system. Let (L_1,\ldots,L_9) be the carrier
lines, and index the nine near-perfect matching blocks so that (M_h) misses
vertex (h). Let (T_h) be its four-star-point transversal and put

\[
P=\prod_{i=1}^9\ell_i,\qquad Q=\prod_{h=1}^9t_h.
\]

On (L_h), the degree-eight forms (Q/t_h) and (P/\ell_h) have the same
eight simple zeros. Hence there are nonzero constants (c_h) and a constant
(c) such that

\[
Q=cP+\sum_{h=1}^9 c_h t_h\frac{P}{\ell_h}.       \tag{3}
\]

Indeed the indicated choice makes the difference vanish on every (L_h), so
the degree-nine difference is a scalar multiple of (P). This is the exact
nine-carrier analogue of star interpolation; its coefficients are linear
forms (c_ht_h), rather than the constants available with ten carriers.

For an edge (ij\in M_h), write uniquely up to common scale

\[
t_h=A_{ij}\ell_i+B_{ij}\ell_j,
\qquad \gamma_{ij}=B_{ij}/A_{ij},\qquad
\gamma_{ji}=\gamma_{ij}^{-1}.                    \tag{4}
\]

The coefficients are nonzero in a faithful realization. Regard
(\gamma) as a multiplicative gain on the oriented edges of (K_9).
Then the following are equivalent.

1. The gain is balanced: its product around every cycle is one; it is enough
   to test the 28 triangles through a fixed vertex.
2. There are nonzero vertex weights (a_i), unique up to common scale, with
   \(\gamma_{ij}=a_i/a_j\), equivalently
   \(t_h\doteq a_j\ell_i+a_i\ell_j\) for every (ij\in M_h\).
3. The degree-eight star-adjoint
   \[
   F=\sum_i a_i\frac{P}{\ell_i}
   \]
   contains, at every star point (L_i\cap L_j), the length-two local
   intersection of (P=0) with its assigned transversal (T_h).
4. Under the expected-incidence hypothesis (no accidental extra
   carrier/transversal incidences), the nine diagonal points
   \(R_h=L_h\cap T_h\) are collinear, so their line is the missing tenth
   carrier and the realization completes geometrically.

The equivalence of (1) and (2) is ordinary gain-graph gauge exactness. At
(L_i\cap L_j), only the (i,j) summands of (F) have linear terms, namely
(a_i\ell_j+a_j\ell_i), which proves (2) equivalent to (3). Finally (P=Q=0)
is a degree-((9,9)) complete intersection. The 36 assigned star contacts
have total length 72 and lie on (F=0) of degree eight. Since all (a_i\ne0),
(F) shares no carrier component with (P), so those contacts exhaust the
degree-((9,8)) complete intersection (P=F=0) by Bezout. The complete-
intersection ideal is ((P,F)); because (Q) contains it and has degree nine,
the AF+BG form is

\[
Q=cP+\ell_0F
\]

for a linear form (\ell_0). On (P=0), the remaining nine intersections
therefore lie on (\ell_0=0). Conversely, a completion supplies (2) from the
ten-carrier interpolation theorem.

Thus the nine-point frontier is now exact: it asks whether the prescribed
matching concurrences force this edge-gain to be balanced. A single triangle
with nonunit holonomy is a projectively intrinsic obstruction; no coordinate
normalization or field-specific elimination is needed to state it. Accidental
incidences require the scheme-theoretic version of the residual statement and
remain to be checked before promoting the criterion without the faithful-
realization qualifier.

## Application to the Ree bridge

Exact enumeration gives 28 one-factorizations in the regular
`MATCH(10,5,1)` design. Every one has exactly 27 Hamilton pairs (out of 36),
and the 27 resulting five-factor pencil sets have connected two-point-overlap
closure. The theorem therefore forces the nine centers of every
one-factorization to be collinear over **every field**, not only in
characteristic two. Consequently
the 63 matching centers automatically acquire all 28 lines of the canonical
`2-(28,4,1)` incidence design identified with the Ree unital `R(3)`. Nagy's
embedding theorem now supplies the full conclusion directly: a rank-three
realization exists only when (K) contains \(\mathbf F_8\), and then it is
unique, admissible, and contained in an order-eight subplane. In particular,
odd characteristic is excluded without the seven-equation calculation. The
new step is precisely the missing implication from matching concurrence alone
to Nagy's line hypothesis.

The nonhyperoval class has one one-factorization and no Hamilton pair, although
its full triple-overlap closure is still connected; the second form of the
theorem would force its nine centers collinear if such a characteristic-two
realization existed. Its nonexistence remains supplied by the C1003 algebra.

This proves the full ten-point Ree bridge. It does **not** yet prove that an
arbitrary nine-point deletion realization reconstructs the missing tenth
carrier line, so the deletion version remains a distinct extension problem.

## Exact finite certificate

The load-bearing finite lemma now has the smaller pure-Python bundle
`c1015_zero_hamilton_rooted.py`, `c1015_zero_hamilton_rooted.json`, and
`c1015_zero_hamilton_rooted.sha256`. Replay from the repository root with

```text
uv run python notes/c1015_zero_hamilton_rooted.py --check
```

It fixes one factor, independently derives all 15 labelled solutions of
(2a), and exhausts exactly the 640 star-pattern and 192 (3+2)-pattern rooted
exact covers. It quotients only by explicitly generated permutations of the
five base edges and their endpoint flips; it uses no canonical-labelling or
graph-isomorphism library. It also independently enumerates the 243 words of
the ternary potential code (2f) and checks its exact weight distribution. Two
independent Hamilton tests agree on every
factor pair: connected-component size ten and cycle type ((5,5)) for the
product of the matching involutions. The existing full-census bundle below
independently recovers the same unique zero-Hamilton class by a different
canonical-augmentation route. The rooted bundle proves only the exact
order-ten finite lemma; it does not prove the interpolation, pencil, or Hesse
arguments.

The independent bundle `c1015_hamilton_gap_rooted.py`,
`c1015_hamilton_gap_rooted.json`, and `c1015_hamilton_gap_rooted.sha256`
proves (2h)--(2i) after fixing one Hamilton pair. Replay with

```text
python notes/c1015_hamilton_gap_rooted.py --check
```

It exhausts 173,008 residual exact covers, uses two agreeing Hamilton tests,
and invokes no graph-isomorphism package or global one-factorization census.
Its equality-orbit summary uses only the explicitly generated order-20
dihedral stabilizer of the rooted ten-cycle.

The bundle `c1015_ree_bridge.py`, `c1015_ree_bridge.json`, and
`c1015_ree_bridge.sha256` independently enumerates the contained
one-factorizations, counts Hamilton pairs both by component traversal and by
the product of the two matching involutions, checks the odd-distance
five-factor pencil closures, and checks the more general characteristic-two
triple-overlap closure. Replay from the repository root with

```text
python3 notes/c1015_ree_bridge.py --check
```

It certifies exactly the two tracked ten-point designs: the regular class has
28 factorizations, each with 27 Hamilton pairs and one nine-label closure; the
27 five-factor sets also close to all nine factor labels in every regular
factorization. The nonhyperoval class has one factorization, zero Hamilton
pairs, and one characteristic-two nine-label triple closure. The finite check
does not prove the interpolation or parity theorem; those are the human
argument above. The pre-existing C1003 enumerator provides an independent
check of the counts and canonical hashes, while the two Hamilton tests
cross-check each other.

The second bundle `c1015_k10_factorization_closure.py`,
`c1015_k10_factorization_closure.json`, and
`c1015_k10_factorization_closure.sha256` performs independent canonical
augmentation of colored incidence graphs through all nine factors. It checks
the 396-class and labelled-count census, that exactly 395 classes have a
Hamilton pair, every parity closure over all ten base vertices as independent
regression evidence, the universal characteristic-two triple closure, the
unique (AG(2,3)) sparse-shadow dichotomy, the generic Hesse lift determinant,
and the final rank-74 ternary specialization. Replay with

```text
uv run --with pynauty python notes/c1015_k10_factorization_closure.py --check
```

The trusted boundary for the finite dichotomy is `pynauty` canonical labeling
plus the Hamilton-cycle test: 395 classes have a Hamilton pair and the unique
remaining class is the affine one. Parity-shadow closure is no longer
load-bearing for those 395 classes. The geometric exclusion of the exceptional
class is the three-Hesse-line human argument above. The output
is cross-checked against Gelling's 396 classes, the classical labelled total,
the independently enumerated regular-design factorizations, and two separate
Hamilton-cycle tests. Exact row reduction over \(\mathbf Q(\omega)\) and
\(\mathbf F_3\) remains a non-load-bearing independent replay. A handwritten
presentation should replace only the finite 72-extra-triple check by the
short affine-plane closure lemma before manuscript insertion.

The compression bundle `c1015_hesse_compression_campaign.py`, its JSON
certificate, the exact high-level plan, the three-plan lowered seed batch,
and `c1015_hesse_compression_campaign.sha256` records the Ergodis pass. It
enumerates all 4,096 subfamilies of the twelve affine lines and independently
replays the controller's two first obstructions and exact conjunction. A
filesystem-clean replay is

```text
c1015_tmp=$(mktemp -d)
python3 notes/c1015_hesse_compression_campaign.py "$c1015_tmp/data.jsonl" --certificate "$c1015_tmp/certificate.json"
cmp "$c1015_tmp/certificate.json" notes/c1015_hesse_compression_campaign.json
sha256sum -c notes/c1015_hesse_compression_campaign.sha256
```

The control run used the experimental-v0 interface: `ceiling` reported 48
feature vectors and zero unavoidable errors; `batch` tested the three lowered
plans and found the conjunction uniquely perfect at 4,096/4,096. The Python
replay independently obtains the same counts without trusting Ergodis. The
controller is diagnostic only and is not part of the mathematical proof.
The same certificate minimizes the lift support inside this method: three
infinity edges plus three finite edges, with 216 labelled minimizers; its
first canonical witness is the six-equation triangle displayed above.

| Artifact | Bytes | SHA-256 |
|---|---:|---|
| `notes/c1015_zero_hamilton_rooted.py` | 14,840 | `79d73b9a1b7d796e341bdbac2d8b498613dcd9f54a60ea1b43ac61a2a3bd30e7` |
| `notes/c1015_zero_hamilton_rooted.json` | 4,070 | `17190516e63f4ac072c35185b33895f20de5466809eb46d8851d0512700190de` |
| `notes/c1015_zero_hamilton_rooted.sha256` | 206 | `00abab945d9ef05469ec33b69557cfd742a5f1f919f9bab5e3216fe55a59d998` |
| `notes/c1015_ree_bridge.py` | 10,728 | `7b60af8c3583a754db5ddc28d75cc065ca8d8906443e4b4f66903284e60fb123` |
| `notes/c1015_ree_bridge.json` | 1,263 | `1545f49a4d66d33d5d90d0ee99d5eaf39640c0170c99db2a7b6e78697a279b50` |
| `notes/c1015_ree_bridge.sha256` | 317 | `249bd54b32d954d1fd1c3751b99638219af40b905cbeedd7b85c0cc598fdd9b1` |
| `notes/c1015_k10_factorization_closure.py` | 21,685 | `ca2a693ac5051a60c0c580540de61c9931a07892db3f24ed6b84a0c3f6c01dfc` |
| `notes/c1015_k10_factorization_closure.json` | 6,779 | `909bcaec05c378c3ff4fb5279f44535cb49b58150efbee1bdf7c9fc7223723a3` |
| `notes/c1015_k10_factorization_closure.sha256` | 216 | `2761a50545b2388b62e6d30e4e867bf5115121c9f3c9ca13ed67bcb1a0cdbe01` |
| `notes/c1015_hesse_compression_campaign.py` | 6,519 | `bf59ed28d49668c16b56d9581191cfd1308e8bd7af6a1d0ab3b99892dd8c65b9` |
| `notes/c1015_hesse_compression_campaign.json` | 1,699 | `ad126f40d89da51499d5ff1aed77323c61ca19aff4fd06eb6c918717e904a283` |
| `notes/c1015_hesse_force_zero_plan.json` | 446 | `37e951bf3b1e4bb357ec45954403fd35df1b4961cd454bd7f51a3fe58ef4682f` |
| `notes/c1015_hesse_compression_seeds.jsonl` | 666 | `84d28e86afc5d1520538fae247b60a966cdada78c2af90d0295b70dc377390b3` |
| `notes/c1015_hesse_compression_campaign.sha256` | 431 | `38c4b1aa01d5ab3cfd52add3dec4c72a34f97dfa4d1e5fe7c6f9ec664a77da73` |
| tracked input JSON | 79,326 | `c2c3619a1c074bd28a9e0b967a4ac1762496589ede0cc636431f484d67fba357` |

## Literature position of the move

The interpolation input is classical star-configuration algebra: for a
codimension-two star configuration, Tohaneanu--Xie, Lemma 3.1, records that
the ideal is generated in degree (s-1) by the products omitting one defining
linear form. Read depth: `partial`, arXiv v1, Lemma 3.1 and its surrounding
setup; cache key `arxiv:1906.08346`, cached PDF SHA-256
`9f5515d754ef1d818a9fe8dd8695827300df9f4f25826b7be702f0f1bda77ece`).
The proof above specializes this standard generator statement and extracts
the edgewise residue relation (1).

Perfect pairs and perfect one-factorizations are classical graph-theoretic
notions. Korchmaros--Pace--Sonnino (JCTA 160 (2018), 62--83,
doi:10.1016/j.jcta.2018.06.006) explicitly study geometric
one-factorizations arising from ovals. Read depth: `full text`, published
version, all sections; cache key `10.1016/j.jcta.2018.06.006`, SHA-256
`30399d2ed0aee41d37cac7c184a7f512aabc4919ddd49dfb917d2b8bf947e401`.
Section 2 represents a factor either by an external line or by a chord plus
one exceptional pole, poses the broad all-lines Problem 1, and says uniqueness
of its easy solution is out of reach. It also records the stronger known
negative answer for all-external-line solutions in Desarguesian odd-order
planes via Segre's tangent lemma. The paper contains no Hamilton-pair,
star-interpolation, parity-layer, or automatic-pencil theorem; Section 7's
sporadic highly symmetric cases are (K_{12}) and (K_{28}), not (K_{10}).
Thus this closest full-text threat does not pre-empt the present converse.

The forward-citation closure of that exact seed was run on 2026-08-30 using
the pinned DOI `10.1016/j.jcta.2018.06.006`. The independent counts were
OpenAlex 5 (`W2808718921`), Crossref 3 (`is-referenced-by-count`), and
Semantic Scholar 6 (`ffcc31a9bff1e2ef3a5fe9b4246963746c608a5c`). All three
requests returned HTTP success and the matching seed DOI/title, so none of
the counts is an error-coded empty response. The load-bearing queries were:

```text
https://api.openalex.org/works/https://doi.org/10.1016/j.jcta.2018.06.006
https://api.crossref.org/works/10.1016/j.jcta.2018.06.006
https://api.semanticscholar.org/graph/v1/paper/DOI:10.1016%2Fj.jcta.2018.06.006?fields=title,citationCount,citations.title,citations.abstract,citations.year,citations.externalIds,citations.url
```

The largest set, Semantic Scholar's six citing works, was screened over title,
year, external identifiers, and every available abstract. The mechanical
discriminator was whether the metadata asserted a converse, classification,
concurrency/pencil theorem, projective representation theorem, or a result on
all-line transversals rather than another construction of one-factorizations.
Five works were construction papers (hyperbolae, odd square orders,
circular-linear factorizations, parabolas, and the Lee metric) and did not pass
that discriminator.

The sixth work did pass and was promoted: Kiss--Korchmaros--Romaniello--
Smaldore, _A Note on Parabolic and Linear One-Factorizations of the Complete
Graph (K_{p+1})_ (CEUR Workshop Proceedings 3792, 2024). Read depth:
`partial`, published proceedings PDF, abstract, introduction, Definitions
3.4--3.6, all of Section 4, and references; cache key
`ceur:3792:paper16`, SHA-256
`273b4319bc8435b013642f6e90d435765784a481637e1adc8a25118d49f2e9c4`.
Its Theorem 4.1 proves that an all-line representation on a conic over odd
(\mathbf F_q\), (q\ge5), must use at least one chord representative; it does
not derive a pencil and its chord factors do not put all edge/star points on
one line. Thus it strengthens the adjacent conic-specific negative result but
does not contain the arbitrary-carrier, all-field automatic-pencil theorem.

Ziegler, _Matroid representations and free arrangements_ (Trans. AMS 320
(1990), 525--541), Example 4.1, gives the exact representation condition for
the exceptional sparse shadow: (AG(2,3)) is representable over (K) if and
only if (K) contains a root of \(\omega^2-\omega+1\), together with the
nine Hesse coordinates used above. Read depth: `partial`, published author
scan, Example 4.1 and its two following cases; the load-bearing formula was
verified against the page image. Cache key
`10.1090/S0002-9947-1990-0986703-7`, SHA-256
`6e1c8ed5d8373a6693c2e0f08862d085e27926b94ba86c3c81c7d52c1a5b1785`.

Dinitz--Garnick--McKay, _There are 526,915,620 nonisomorphic
one-factorizations of K12_ (1994), supplies the classical 396-class and
1,225,566,720 labelled (K_{10}) totals used only as external census checks.
Read depth: `partial`, published paper, introduction and the (K_{10}) census
passage; cache key `10.1002/jcd.3180020406`, SHA-256
`f54a59d8e91729f69ec125d99a16ffb30c574e4000943c6ddbe42801e61ada3a`.
Gelling's 1973 thesis is an earlier source for the 396 representatives. Read
depth: `partial`, published scan, appendix pages 61--82 inspected through OCR
with representative tables checked against page images; cache key
`gelling:1973:k10`, SHA-256
`64614781270098af2f1086df5e5684f9a2e98bb3661be35bef1e90243cee93a4`.
The computation here does not import either classification.

The graph-theoretic audit changes the literature-priority statement for the exceptional
class but not for the new proof mechanism. Dinitz--Dukes--Stinson,
_Sequentially Perfect and Uniform One-Factorizations of the Complete Graph_
(Electron. J. Combin. 12 (2005), R1, DOI `10.37236/1898`), explicitly says in
Section 3 that one-factorization #1 in Gelling's list is a uniform
one-factorization of (K_{10}) of type (4+6). Thus existence of the
zero-Hamilton affine class, and even its uniform cycle type, is classical and
must not be advertised as a new classification result. Read depth: `full
text`, published version, all sections; cache key `10.37236/1898`, SHA-256
`db08a69ac75f057aebb21556a7104bc8b7a6b90e0203fd01abf020a6f9200348`.
The paper does not prove uniqueness of this class, derive the rooted Petersen
system (2a), or discuss the Hamilton-pair graph or its ternary shadow.

Meszka, _k-Cycle Free One-Factorizations of Complete Graphs_ (Electron. J.
Combin. 16 (2009), R3, DOI `10.37236/92`), studies avoidance of a prescribed
cycle length and records the uniform/perfect background, but contains no
Hamilton-pair degree spectrum, fixed-factor contraction, Petersen operator,
or modular potential code. Read depth: `full text`, published version, all
sections; cache key `10.37236/92`, SHA-256
`42d212e1e85e43b5de5f408ce48b204d4d4364e2904012b6ede03688c51df320`.

Kaski--de Souza Medeiros--Ostergard--Wanless, _Switching in
One-Factorisations of Complete Graphs_ (Electron. J. Combin. 21 (2014), P2.49,
DOI `10.37236/3606`), is the strongest census-adjacent full-text check. It
constructs four switching graphs through order twelve, characterizes perfect
factorizations as factor-switching isolated vertices, and gives complete
(K_{10}) switching-graph degree data. Its switching-graph degree is a degree
between **isomorphism classes**, not the degree of a factor in the
Hamilton-pair graph. It contains no assertion that the latter graph has no
leaves and no Petersen potential or ternary-code calculation. Read depth:
`full text`, published version, all sections; cache key `10.37236/3606`,
SHA-256
`075f23efc12609b42b17eeff5b775a48e60bc673a673f7623406f7de54ed2e52`.

Venkaiah--Ramanjaneyulu--Jampala--Prasad, _Equivalence of Lower Bounds on the
Number of Perfect Pairs_ (arXiv:1412.6793), studies the **maximum total number**
of perfect pairs and product lower bounds. It does not impose or derive local
degree restrictions inside a given factorization. Read depth: `full text`,
arXiv v1, all sections; cache key `arXiv:1412.6793`, SHA-256
`55d9e70e0e37d4e453d4fd760ce52aa3546445b7a8c4c53860250d59ee1ee579`.

Allsop, _Cycles of Quadratic Latin Squares and Anti-perfect
1-factorisations_ (J. Combin. Des. 31 (2023), 447--475; arXiv:2302.12942v3),
proves that anti-perfect one-factorizations of (K_{2n}) exist exactly for
(2n >= 8), and in Section 6 explicitly identifies Dinitz--Dukes Theorem 3.2 as
the four-cycle criterion for one finite-field starter family. This makes the
existence side of the K10 anti-perfect phenomenon emphatically classical, but
again supplies neither a K10 uniqueness proof nor any of (2a)--(2f). Read
depth: `full text`, arXiv v3, all sections; cache key `arXiv:2302.12942`,
SHA-256
`c65bb3421c3d8d11c8fab3ea71eec91f8a6880a6664b42061d3e09c205378f14`.

There is also a concrete downstream correction opportunity. The indexed
open-access text of Erskine--Griggs, _Cycle Switching in Steiner Triple Systems
of Order 19_ (J. Combin. Des. 33 (2025), 195--204, DOI
`10.1002/jcd.21975`), says in its discussion of the order-24 component that
all but one of the 396 (K_{10}) one-factorizations exhibit both cycle types and
that the sole exception is the perfect class. This omits the classical uniform
type-(4+6) class just recorded by Dinitz--Dukes--Stinson. The relevant
statement is absent from arXiv v1 and was added later. Read depth: `full text`
for arXiv:2405.07750v1, all sections, cache SHA-256
`b9980303ecfe56ebd43b404280ed4e974a578a6cb61ad83c0a617aaef4831152`;
`partial` for the later published/open-repository version, exact K10 paragraph
as indexed by the Open University repository and publisher metadata. The
publisher and repository PDFs returned access denials, so the printed page
image remains an explicit verification gap. The safe claim is therefore that
the rooted theorem gives a direct proof of the missing second exception and a
potential correction to recent downstream literature, not that it discovers
the exception itself.

The closest inaccessible source is Dinitz--Dukes, _On the Structure of Uniform
One-Factorizations from Starters in Finite Fields_ (Finite Fields Appl. 12
(2006), 283--300, DOI `10.1016/j.ffa.2005.05.008`). Publisher metadata and the
abstract say that it gives general cycle-existence conditions and completely
characterizes four-cycles in the Horton-starter family. The Crossref TDM
endpoint returned metadata only and requires an API key for full text; the
ScienceDirect PDF endpoint returned HTML and was rejected by the literature
cache. Read depth: `metadata and abstract only`. Cameron, _Minimal
Edge-Colourings of Complete Graphs_ (1975), the Mendelsohn--Rosa survey, and
the Wallis survey/book were likewise not available at full-text depth. These
are the principal reasons the negative verdict below remains bounded.

Two exact forward-citation sweeps were run on 2026-08-30. For
`10.37236/1898`, the independently returned counts were OpenAlex 33
(`W2767999306`), Crossref 11, and Semantic Scholar 36. For
`10.1016/j.ffa.2005.05.008`, the corresponding counts were OpenAlex 11
(`W2004773548`), Crossref 9, and Semantic Scholar 19. Each service returned
the matching seed title and identifier with HTTP success. The larger Semantic
Scholar set was screened in each case over all returned titles, years,
identifiers, and available abstracts. The mechanical discriminator was a
claim about the cycle spectrum or perfect-pair degrees **inside one fixed
one-factorization**, a K10 classification, a fixed-factor contraction, or a
Petersen/code constraint. The promoted works were Meszka, Kaski et al.,
Venkaiah et al., and Allsop; the remaining records concerned starter
constructions, perfect-pair lower bounds in other settings, switching,
orthogonal factorizations, or unrelated uses of the word factorization.

The bounded topical sets were also recorded. OpenAlex
`filter=title.search:uniform one-factorization` returned four records; all
four were screened, with the two Dinitz papers promoted and the hypergraph and
2025 product-of-cycles papers rejected by title/domain. OpenAlex search for
the exact phrase `"Hamilton pair" one-factorization` returned one unrelated
numerical-analysis record. The broader query `one-factorization Petersen
ternary code` returned 65 records; all titles/domains were screened and none
was a one-factorization result involving the Petersen contraction or the
weight enumerator in (2f). Exact web searches for `Hamilton pair graph`,
`number of perfect pairs`, `anti-perfect K10`, and the ([10,5,4]_3) weight
enumerator promoted the sources above but found no predecessor for the local
shadow consequences.

Accordingly, the present bounded verdict is:

- the affine/Steiner zero-Hamilton example and its uniform (4+6) cycle type
  are classical;
- its uniqueness among K10 factorizations is already implicit in the old 396
  table, so the contribution is a short direct rooted proof and a correction
  of a later omission, not a new census fact;
- no checked source contains the Petersen potential formula (2d), the ternary
  code (2f), the no-leaves theorem for the Hamilton-pair graph, or the
  zero-or-three intersection theorem for two Hamilton partners.

The last bullet is a provisional literature-priority claim, suitable for planning and a
carefully attributed literature paragraph but not yet for unqualified
manuscript language. Semantic Scholar, OpenAlex, Crossref, and ordinary web
search were covered. zbMATH's API returned an HTTP 502 proxy page;
MathSciNet and Google Scholar were not covered.

Nagy (2021) remains the exact literature-priority ceiling after the pencil has been
produced: his theorem assumes the Ree-unital line structure rather than
deriving it from the 63 matching concurrences. Read depth: `full text` for
arXiv v3, all sections, cache key `arxiv:2007.10464`, SHA-256
`e268f76c7f01a40dd07d59f2077b0fb14a3b8c654041432d1dbf2296ea021f61`;
Sections 1--5 of the published version (DOI
`10.1016/j.ffa.2021.101875`) were also checked, SHA-256
`99e5b60d981c80fe358bad28ebbfe5d6cf18b4f19a50fe8480966c74477aed30`.

Searches for `one-factorization star configuration projective plane`,
`perfect one-factorization projective geometry transversals`,
`one-factorization secants concurrent projective plane`, and
`one-factorization characteristic two geometry` found the adjacent literatures
but no statement of (1), (2), or the automatic-pencil consequence. The 2018
JCTA full-text threat and its three-graph forward-citation set are now closed.
This remains a bounded provisional novelty result rather than a categorical
global literature-priority verdict: MathSciNet and Google Scholar were not covered, and
the topical search was bounded rather than an exhaustive MSC sweep.
Manuscript language such as "new" or "to our knowledge" is not yet authorized.

## Work programme

1. **Landed:** replace the normalized substitution chain by the frame-free
   star-interpolation identity and Hamilton-pair parity holonomy.
2. **Landed universally for ten points:** the odd-half theorem handles every
   one-factorization having one Hamilton pair. A direct rooted classification,
   independent of the 396-class census, identifies the complementary case as
   the affine (AG(2,3)) factorization, which the six-equation Hesse tripod
   kills. Determine whether a nine-point realization itself reconstructs the
   missing tenth carrier line.
3. Determine the actual carrier of the obstruction: seven displayed blocks,
   their vertex/block incidence shadow, or a smaller invariant subdiagram.
4. Test relabellings and deletions to decide whether the certificate is a
   nine-point phenomenon or the first instance of a uniform seven-/eight-/
   nine-local compatibility law.
5. Formulate a characteristic-sensitive invariant whose odd-characteristic
   specialization forces the contradiction and whose characteristic-two
   degeneration explains the `F_8` survivor.
6. Audit primary literature on representations/embeddings of abstract ovals,
   abstract hyperovals, hyperfactorizations, and `pg(5,7,3)` for such global
   compatibility laws, following `notes/literature-audit-conventions.md`.
7. Use Ergodis only through its control interface, if useful, to rank or
   compress candidate identities. Record control/provenance improvements but
   do not edit Ergodis source.

## Success gates

- **Base — landed:** a human derivation of `-2(r-1)^2/r^2=0` from the seven
  displayed concurrences, with every division and characteristic exception
  explicit.
- **Strong — landed universally for ten points:** a frame-free interpolation
  identity, parity invariant, direct rooted zero-Hamilton classification, and
  the sharp rooted Hamilton gaps (2h)--(2i), together with the Ree bridge
  giving all 28 one-factorization lines from matching concurrences. The
  396-class certificate is an independent cross-check.
- **Priority-judo — provisionally landed:** the universal (K_{10}) pencil
  theorem answers the order-ten instance of the geometric-transversal problem
  at a level above the Ree field boundary. Final literature-priority status awaits the
  broader topical closure; the exact Korchmaros--Pace--Sonnino seed, its
  forward citations, and the later 2024 linear-factorization theorem have now
  been checked convention by convention.

## Extra-juice and Tao-style closeout

The next structural level is a discrete flatness principle. Formula (2f)
says that the additive curvature of the Hamilton shadow vanishes on every
quadrilateral, hence the shadow is a vertex potential. The deletion criterion
says that the multiplicative curvature of the transversal directions
vanishes on every triangle, hence those directions are vertex ratios. These
are the additive and multiplicative forms of the same complete-graph
Poincaré lemma. The useful research question is therefore not merely whether
one can check more cycles, but whether star interpolation forces a flat
connection in a wider class of extremal incidence designs. The odd
near-factorization adjoint theorem above is the first general theorem in that
direction; forcing its balance from concurrence alone would solve the
nine-point problem and explain what the order-ten character formula is a
special case of.

The decisive Tao-style simplification is the odd-half theorem: relative to a
Hamilton cycle, every perfect matching on two odd bipartition classes must
cross the cut, and one crossing edge already puts its transversal in the
Hamilton pencil. This removes the 395-class parity-closure computation from
the proof. The finite residue is now a direct five-pair signature equation and
rooted exact-cover lemma. Its two local patterns have respectively 640 and 192
completions; explicit symmetry reduces the Hamilton-free residue to one affine
orbit. The six-equation Hesse tripod then excludes it geometrically.

The Hesse row reduction has now been replaced by a three-line incidence
argument: the exceptional lift puts (2u_\infty) in Hesse lines (012),
(036), and (138), whose vector planes have zero total intersection. The
affine rule still suggests a higher-order family on
(\{\infty\}\cup\mathbf F_p^d), with factors pairing (x) to
(2a-x). Determining whether the parity-shadow/Hesse dichotomy is the first
case of a uniform affine-round-robin obstruction is a genuine successor,
not needed for the order-ten theorem.

### Mystery ledger

- **Why 27 Hamilton pairs in the regular Ree factorization — settled.** The
  nine non-Hamilton pairs are three disjoint triangles, so the Hamilton graph
  is (K_{3,3,3}); these are the three diagonal packets from the local
  quadrangle calculation.
- **Why the other 395 census classes close — settled conceptually.** They do
  not need a many-pair closure calculation. Since (K_{10}) has odd half-size
  five, one Hamilton pair forces all nine factors into its pencil.
- **Why the unique zero-Hamilton class produces (AG(2,3)) — settled without
  the global census.** The rooted signature equation is the singular
  Petersen-graph system (2a); its standard-module kernel rewrites every
  solution as (d_{ij}=x_i+x_j), so the two partitions of two give exactly the
  star and (3+2) patterns. Every (3+2) completion has 23 Hamilton pairs; the sixteen
  Hamilton-free star completions form one explicit-symmetry orbit and have a
  common four-cycle vertex. The fourth vertices of those cycles form the
  unique (STS(9)), so this orbit is exactly the affine factorization
  (M_a=\{\infty a\}\cup\{xy:x+y=-a\}), with automorphism order 432; its
  twelve parity triples are the affine lines. A handwritten endpoint chase
  replacing the 640+192 rooted exact-cover table would be a presentation
  upgrade, not a logical or global-classification gap.
- **Why the rooted completion counts are (640,192), and why their Hamilton
  spectra are (0,12,16) and (23) — open but non-load-bearing.** The
  endpoint-closure graph explains the sixteen zero-Hamilton completions, but
  not yet the full numerical distributions. A closed orbit-stabilizer or
  binary-cochain count would turn the remaining table into conceptual
  enumeration; it is optional presentation extra juice, not a theorem gap.
- **Why Hamilton degree one never occurs — settled.** A single contracted
  Hamilton five-cycle violates the ternary quadrilateral law (2e) forced by
  the Petersen potential formula. Hence the Hamilton-pair graph has no leaves
  without any census input. More generally, (2d) controls every local
  Hamilton shadow, not only degrees zero and one: modulo three it lies in the
  ([10,5,4]) potential code (2f), whose missing weights also force the
  zero-or-three intersection law for two Hamilton partners.
- **Global Hamilton-gap theorem — first gap structurally reduced; second
  finite.**
  The rooted Hamilton-pair certificate proves the sharp dichotomy “empty or
  at least 12 Hamilton pairs” and the stronger bound 18 when there is no
  isolated factor. Both are attained. It fixes one Hamilton pair and checks
  173,008 exact-cover completions, independently of the 396-class census. The
  same root proves the sharper local amplification law (2j); no-leaves,
  (2j), the isolated-factor spectrum, and a short degree count then prove the
  12-gap structurally. The remaining human local task is to prove (2j) from
  the three cut types (2k), or equivalently the genus-defect packing bound
  (2m); for a degree-two endpoint this is reduced to the displayed four-row
  signature table. For the 18-gap, the exterior-square identity (2n)
  reduces the problem exactly to the energy bound
  (\operatorname{tr}(T^2)\ge333) under no isolation. A proof from the forced
  standard module would replace rooted exhaustion completely.
- **Why the affine exception exists — settled geometrically by C1014.** It is
  the residual-pair factorization obtained by rooting the Miquelian inversive
  plane of order three at a point of (\mathbf P^1(\mathbf F_9)). The ten
  choices of root are exactly its (PGL_2(9))-orbit. This explains the
  (AG(2,3)) residue and suggests treating Hamilton pairs as stability defects
  of a Baer-circle structure; it does not supply a forbidden rank-three
  realization.
- **Potential code at all Johnson levels — algebra settled, realization
  open.** Formula (2g) gives (\mathcal C_m) explicitly, including parameters
  ([\binom m2,m,m-1]_3) for every (m\ge5), without enumeration. What remains
  open is the important part: construct a canonical shadow of a
  (K_{2m}) one-factorization whose local coverage equations force membership
  in this code (or in the correct higher Johnson analogue).
- **Why the Hesse exception cannot lift — settled conceptually.** Three
  affine lines force (2u_\infty) into vector planes with zero total
  intersection. This kills every characteristic except two; the existing
  characteristic-two closure kills the remainder. The determinant
  (-8(1+\omega)) and its norm 192 survive only as regression evidence; their
  prime factorization is no longer an unexplained proof dependency.
- **Size of the obstruction carrier — settled within the incidence method.**
  The Hesse tripod uses exactly six lift equations on four carrier variables;
  fewer cannot supply three distinct vector-plane constraints and their
  endpoint eliminations. Whether a fundamentally different five-equation
  obstruction exists is not needed and has not been claimed.
- **Nine-point deletion completion — reduced, still open.** The missing line
  exists exactly when the 36 edge gains (4) are balanced; 28 fixed-base
  triangle products are a complete frame-free test. AF+BG then constructs the
  missing line from the degree-eight star adjoint. The remaining evidence gap
  is to prove that the prescribed matching concurrences force balance, or to
  realize one nonunit triangle holonomy as a counterexample. Accidental extra
  incidences also require the scheme-theoretic cleanup stated above.
- **Odd near-factorization adjoint theorem — settled generalization.** The
  balance-to-completion implication and its AF+BG proof work for every odd
  (n), not only (n=9): a balanced transversal realization of a
  near-one-factorization of (K_n) has its (n) residual points on one missing
  carrier. This separates the universal adjoint theorem from the genuinely
  order-specific question of whether matching concurrence forces flatness.
- **Higher affine round-robin family — open successor.** The evidence gap is
  a general parity-shadow closure/representation theorem for
  (K_{p^d+1}), beginning with the midpoint factorization above.
- **Johnson-scheme shadow code — open successor.** For general (K_{2m}),
  contraction by one factor records every other factor as a 2-regular
  multigraph on (m) vertices. At (m=5), the Kneser/Petersen eigenspaces force
  (2d)--(2f). The exact next question is whether the corresponding Johnson-
  scheme decomposition for odd (m) produces modular potential codes and
  forbidden Hamilton degrees uniformly. This could upgrade the order-ten
  invariant into an infinite-family theorem; no such derivation is yet in
  hand.
- **Closest-seed literature priority — settled; global literature priority remains bounded.** The
  Korchmaros--Pace--Sonnino full text and its largest three-graph citing set
  are cleared, including the 2024 characterization paper. MathSciNet and
  Google Scholar remain uncovered, and no exhaustive MSC sweep has been run.
- **Ergodis compression pass — settled, with interface debt recorded.** The
  frozen campaign contained all 4,096 subfamilies of the twelve affine lines.
  Its feature ceiling had 48 vectors and zero unavoidable errors. The two
  weakened rules exposed exactly the missing proof ingredients: “a line
  outside the largest pencil” alone has 16 false positives, first a parallel
  pair; “an incident pair” alone has 99, first a two-line pencil. Their
  conjunction is exact on all 4,096 rows and says precisely: two selected
  lines meet at a Hesse point and a third avoids it. This selected the
  three-line proof above. No Ergodis source was edited. Two control-interface
  issues should be repaired by the owning lane: high-level `expr` plans work
  with `try` but are rejected by `batch`, and `synthesize` failed here with
  `plan result sort does not match its declared output` despite a zero-error
  feature ceiling. A second diagnostic pass over all 640 rooted star
  completions reduced the endpoint data to six feature vectors, again with
  zero unavoidable errors. It exposed the empty/matching/triangle/(K_4)
  block-graph hierarchy and its endpoint-color rule now independently frozen
  in the rooted certificate. `synthesize` reproduced the same output-sort
  failure on this smaller exact dataset. The earlier fixed-base undercount
  and mistaken characteristic-three inference remain useful additional
  regressions. The Hamilton-gap compression exposes a third, distinct
  interface boundary: (2m) is a grouped assertion about the sum of seven
  matchings in one exact cover, whereas the current campaign evaluator sees
  one flat row at a time. Supplying precomputed group sums would only encode
  the desired conclusion as a feature. A useful future extension would be a
  bounded multiset/group-aggregation layer (counts, sums, and minima over a
  fixed parent key), with the resulting candidate still replayed and proved
  independently. No Ergodis source change is made here.

## Publication decision after proof

The universal (K_{10}) pencil theorem clears the threshold for a short
standalone representation paper if the literature-priority audit stays clean. Its spine
would be interpolation, the general odd-half Hamilton-pair theorem, the unique
zero-Hamilton (K_{10}) residue, and the Hesse obstruction; Ree rigidity would
be the marquee application.
It also strengthens the arcs equality paper by replacing the regular
characteristic-two coordinate classification with automatic Ree completion
plus Nagy's theorem. The best integration decision should follow the
nine-point completion attempt and literature-priority audit, but the theorem no longer
needs an infinite-family extension to justify standalone treatment.
