# C794 — aligned-design faithfulness and higher cut moments

**Date:** 2026-08-02

**Lane:** `golden`

## Result

Let a two-graph on a finite set (V) be a function

\[
 \tau:\binom V3\longrightarrow \mathbf F_2
\]

whose four values on every four-set have even sum.  Call a four-set
(Q) **aligned** when those four values are all equal, and write

\[
 \mathcal A(\tau)=
 \left\{Q\in\binom V4:\tau|_{\binom Q3}\text{ is constant}\right\}.
\]

Complementation (	au\mapsto\tau+1) preserves this family.

> **Aligned-design faithfulness theorem.**  If (|V|\geq7) and two
> two-graphs (	au,	au') have the same aligned four-sets, then
> (	au'=	au) or (	au'=	au+1).  The bound seven is sharp.

The proof is human and elementary.  It replaces the C794 seven-vertex
exhaustion by a four-point cut argument.  The old census remains an exact
falsifier and confirms the labelled small-order fibre table, but it is no
longer part of the proof.

For a symmetric conference matrix, the determinant-((-3)) principal
four-sets of Greaves--Suda are exactly (mathcal A(	au)).  Hence their
marked design reconstructs the conference two-graph up to complement at
every order at least ten.  Order six is a real exception: the design is
empty and has twelve labelled two-graph preimages, although these preimages
are all relabellings of the unique unlabelled order-six conference class.

The first balanced-cut statistic not fixed by the (3)-design parameters is
also explicit.  If (c_T) counts aligned blocks inside a balanced half (T),
its third centered moment is a weighted functional of the ordered
triple-block union profile.  The exact Paley values are

\[
 \mu_3(c_T)=-\frac{840}{1331}\quad(v=14),\qquad
 \mu_3(c_T)=\frac{9216}{17875}\quad(v=18).
\]

Thus the triple-block union profile, and already its displayed scalar
projection when values differ, is the first design-unforced candidate for
separating conference switching classes.  No claim that the scalar is a
complete invariant is made.

## The seven-point proof

### An aligned anchor always exists

Fix (r\in V) and put an ordinary graph (G_r) on (V\setminus\{r\}) by

\[
 ij\in E(G_r)\quad\Longleftrightarrow\quad \tau(rij)=1.
\]

The two-graph equation gives

\[
 \tau(ijk)=\tau(rij)+\tau(rik)+\tau(rjk).
\]

Consequently ({r,i,j,k}) is aligned exactly when (ijk) is a clique or
an independent triple of (G_r).  If (|V|\geq7), the graph (G_r) has at
least six vertices, so (R(3,3)=6) supplies such a triple.  Every two-graph
in the claimed range therefore has an aligned four-set.

### Cuts relative to the anchor

It suffices first to treat (|V|=7).  Choose an aligned four-set
(Q=\{1,2,3,4\}).  Complement one of the two candidate two-graphs if
necessary so that they agree with value zero on all four triples of (Q).
Represent each two-graph by a graph whose restriction to (Q) is empty;
this is possible because zero triangle parity on (Q) makes its graph
restriction a cut, which switching removes.

For (x\notin Q), let

\[
 p_x=(e_{1x},e_{2x},e_{3x},e_{4x})\in\mathbf F_2^4/\langle(1,1,1,1)\rangle.
\]

Changing the representative is just switching at (x).  For a triple
(S\in\binom Q3), the four-set (S\cup\{x\}) is aligned exactly when the
three coordinates of (p_x) indexed by (S) are equal.  Hence these four
alignment tests determine the cut (p_x), except in one case: every balanced
(2+2) cut has no constant three-subset, so the three bipartitions

\[
 12|34,qquad13|24,qquad14|23
\]

have the same empty one-point signature.

The only remaining input is the following six-test lemma.

> **Balanced-pair lemma.**  Let (p,q) be the cuts attached to two outside
> points (x,y), and let (c=e_{xy}).  Suppose (p',q',c') give the same
> alignment answers on all six four-sets ({i,j,x,y}), and that (p,p')
> and (q,q') have already passed the one-point tests.  Then either
>
> 1. (p'=p, q'=q, c'=c), after choosing the same cut representatives; or
> 2. (p,q) are distinct balanced cuts,
>    (p'=q, q'=p, c'=c).

This is a three-cut calculation, not an exhaustion of two-graphs.  Indeed
({i,j,x,y}) is aligned precisely when

\[
 p_i+p_j=q_i+q_j=p_i+q_i+c=p_j+q_j+c. \tag{1}
\]

The one-point test says that a changed cut must move between two of the three
displayed balanced bipartitions.  Substitution in (1) shows that changing
only one endpoint never preserves the six answers, while changing both does
so only by interchanging two distinct balanced cuts; it also forces
(c'=c).  This proves the lemma.

There are three points (x,y,z) outside (Q).  The pair lemma says that for
each outside pair either both endpoint cuts are unchanged or both are
changed.  Thus all three cuts have the same status.  If all are unchanged,
the lemma also recovers all three outside edges and the two graph
representatives coincide.  If all are changed, the pair (x,y) forces
(p'_x=p_y), while (x,z) forces (p'_x=p_z); hence (p_y=p_z).  But the
pair (y,z) requires those two balanced cuts to be distinct, a contradiction.
The two two-graphs therefore agree after the initial possible complement.

### Local-to-global extension

For arbitrary (|V|\geq7), restrict the two candidates to every seven-set.
The base lemma says that on each seven-set they agree or are complementary.
Adjacent seven-sets in the Johnson graph share six vertices, hence a common
triple; inspecting that triple forces the two local choices to agree.  The
Johnson graph on seven-subsets is connected, so one choice holds on every
seven-set and therefore on every triple of (V).  This proves the theorem.

## Sharp fibres below seven

The same cut calculation gives a structural explanation of every exceptional
fibre.  Fibre sizes below count labelled two-graphs, so complementation is
included.

\[
\begin{array}{c|c|c|c}
v&\text{aligned-family type}&\text{number of images}&\text{fibre size}\\ \hline
4&\varnothing&1&6\\
4&\binom V4&1&2\\ \hline
5&\varnothing&1&12\\
5&|\mathcal A|=1&5&6\\
5&|\mathcal A|=2&10&2\\
5&|\mathcal A|=5&1&2\\ \hline
6&\varnothing&1&12\\
6&\{Q,Q'\},\ |Q\cap Q'|=2&45&4\\
6&\text{every other realized family}&416&2
\end{array}
\]

For (v=4), a nonaligned four-set has the six balanced colorings.  For
(v=5), one outside point leaves the three balanced (2+2) cuts
indistinguishable, giving the size-six singleton fibres after complementing.
The empty fibre is represented, after normalization at a vertex, by the
twelve labelled copies of (P_4).  For (v=6), two outside points allow the
balanced-pair swap, producing exactly the 45 size-four fibres indexed by two
aligned blocks meeting in two points.  With no aligned anchor, the normalized
graph is one of the twelve labelled (5)-cycles.  A third outside point is
exactly what destroys the balanced-pair swap.

The finer size distribution of the 416 complement-pair fibres at (v=6) is

\[
 |\mathcal A|=3,4,5,6,9,15
 \quad\text{for respectively}\quad
 195,90,45,70,15,1\text{ images}.
\]

These tables agree exactly with the pre-existing certificate
`notes/2026-08-02-c794-aligned-design-fibres.json`.

## Conference reconstruction and the order-ten algorithm

For a Seidel matrix (C), put

\[
 \epsilon_{ijk}=C_{ij}C_{ik}C_{jk}.
\]

The four signs (epsilon_{ijk}) on a four-set have product one.  They are
all equal exactly when the sum of the three Hamilton-cycle signs is three,
equivalently when the principal determinant is (-3).  Thus
Greaves--Suda's (3	ext{-}(4n+2,4,n-1)) design is precisely the aligned
family of the conference two-graph.  The faithfulness theorem gives marked
reconstruction up to complement for (4n+2\geq10).

The obvious equality-propagation algorithm uses a graph whose vertices are
triples and whose edges join triples in a common aligned block.  It works in
the tested Paley orders 14 and 18, where its two components are the coherent
and incoherent triples.  It genuinely degenerates at order ten: the design is
an (S(3,4,10)), so every triple belongs to one block and the graph is the
disjoint union of thirty four-vertex components.

The full marked design still reconstructs.  Give the thirty blocks binary
colors, and for every one of the 180 nonblock four-sets impose the two-graph
parity equation on the four block colors owning its four triples.  The exact
(mathbf F_2) matrix has rank 28 and nullity two.  Its kernel is spanned by
the constant coloring and the actual weight-15 coloring.  The two constant
solutions would make every four-set aligned and are rejected by the given
design; the two surviving nonconstant solutions are the weight-15 coloring
and its complement.  This explains why component propagation fails while
the functor remains faithful.

## The first design-unforced cut moment

Let (mathcal B) be any four-block family on (v=2d) points and let
(c_T=|\{B\in\mathcal B:B\subseteq T\}|) for a uniformly chosen (d)-set.
For (r=1,2,3), let (N_r(u)) be the number of unordered (r)-sets of
distinct blocks whose union has size (u).  Double counting a chosen block
tuple inside (T) gives the factorial moments

\[
 M_r:=\mathbf E(c_T)_r
 =r!\sum_u N_r(u)
 \frac{\binom{v-u}{d-u}}{\binom vd}. \tag{2}
\]

Therefore

\[
 \mathbf E(c_T-\mathbf Ec_T)^3
 =M_3+3M_2+M_1-3M_1(M_2+M_1)+2M_1^3. \tag{3}
\]

For a (3)-design, the one- and two-block intersection totals, hence
(M_1,M_2), are fixed by the design parameters.  The three-block union
profile in (M_3) is the first new input.  This gives the precise sense in
which the third cut moment is the first design-unforced statistic.

For the Paley order-14 design, the union counts relevant to a seven-half are

\[
 N_3(6)=3458,\qquad N_3(7)=65156,
\]

and (2)--(3) give

\[
 M_1=\frac{70}{11},\quad M_2=35,\quad M_3=\frac{1785}{11},
 \quad \operatorname{Var}(c_T)=\frac{105}{121},\quad
 \mu_3=-\frac{840}{1331}.
\]

For order 18, the relevant union counts are

\[
 \begin{array}{c|rrrr}
 u&6&7&8&9\\ \hline
 N_3(u)&40188&807840&5060016&12272640,
 \end{array}
\]

giving

\[
 M_1=\frac{126}{5},\quad M_2=\frac{87570}{143},\quad
 M_3=\frac{2049624}{143},\quad
 \operatorname{Var}(c_T)=\frac{9072}{3575},\quad
 \mu_3=\frac{9216}{17875}.
\]

The complete cut histograms and union profiles are in the certificate.  For
exchange purity, multiply the centered third moment by
((32/(2d-1)^2)^3), since C788 gives an affine function of (c_T).

## Exact evidence and trusted boundary

Replay from the repository root:

```sh
python3 notes/2026-08-02-c794-aligned-design-fibres.py --check
python3 notes/2026-08-02-c794-aligned-design-moments.py --check
python3 notes/2026-08-02-c794-aligned-design-moments-replay.py
```

The new deterministic generator constructs the order-ten integral conference
matrix and the Paley matrices of orders 14 and 18.  It cross-checks aligned
blocks by Hamilton-cycle signs and by constant triangle parity, verifies the
conference identities and (3)-design degrees, certifies the order-ten rank,
enumerates projective balanced cuts, records pair/triple union profiles, and
checks (2)--(3) against the empirical moments.  The independent replay uses a
separate Legendre-symbol edge function and triangle-parity block test.

The trusted boundary is Python integer arithmetic, exact rational arithmetic,
canonical subset enumeration, the standard Paley prime-field construction,
and the displayed order-ten Gram construction.  The computations certify only
the named matrices and finite fibre tables.  The unrestricted faithfulness
theorem is the human proof above, not an extrapolation from these checks.  The
certificate does not classify conference switching classes and does not show
that the scalar third moment separates every pair of them.

Files:

- `notes/2026-08-02-c794-aligned-design-moments.py`;
- `notes/2026-08-02-c794-aligned-design-moments-replay.py`;
- `notes/2026-08-02-c794-aligned-design-moments.json`;
- `notes/2026-08-02-c794-aligned-design-moments.sha256`.

## Literature boundary

Greaves--Suda owns the determinant-((-3)) (3)-design construction.
Gillespie supplies the classical regular-two-graph coherent/incoherent
four-set parameter framework.  Pouzet--Si Kaddour--Trotignon is the closest
reconstruction predecessor found: it classifies pairs of ordinary graphs with
the same homogeneous triples, exactly the one-point invariant used above.
It does not add the away-from-anchor four-set data and does not state the
two-graph faithfulness theorem.

The bounded audit located no exact predecessor for aligned-design
faithfulness, but MathSciNet and Google Scholar were not covered and the
Crossref forward graph for the Greaves--Suda arXiv seed was unresolved.
Accordingly the safe status is a qualified candidate: “we prove,” with “to
our knowledge” if absence is mentioned, never “first.”  Formula (2) is
standard factorial-moment double counting; no novelty claim attaches to the
generic formula.  Full records are in
`notes/2026-08-02-c794-aligned-design-faithfulness-literature-audit.md`.

No manuscript edit is authorized by this task.

## `ej` + `tt` closeout and Mystery ledger

- **Settled:** the seven-vertex census has been removed from the theorem's
  trust boundary; the balanced-cut ambiguity gives a human proof and explains
  exactly why the cutoff is seven.
- **Settled:** the order-ten overlap-graph paradox is not a counterexample.
  The rank-28 block-color system recovers the complementary pair after the two
  constant colorings are rejected.
- **Settled:** the first design-unforced moment is not merely “third order.”
  Equations (2)--(3) identify its exact owner as the triple-block union
  profile.
- **Open, evidence gap:** no audited pair of inequivalent conference
  switching classes at one order has yet been shown to have distinct third
  moments.  The full triple-union profile is the sharper candidate; a future
  classification-backed census would own this test.
- **Open, literature gate:** MathSciNet, Google Scholar, the Crossref forward
  graph, and a subject-expert check remain uncovered.  These gaps block an
  unqualified priority claim, not the theorem.
- **No manufactured mystery:** the small-order fibre multiplicities and the
  sign change between the order-14 and order-18 third moments are completely
  explained by the recorded cut signatures and triple-union profiles.

