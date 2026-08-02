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

Complementation ($\tau\mapsto\tau+1$) preserves this family.

> **Aligned-design faithfulness theorem.**  If ($|V|\geq7$) and two
> two-graphs ($\tau,\tau'$) have the same aligned four-sets, then
> $\tau'=\tau$ or $\tau'=\tau+1$.  The bound seven is sharp.

The proof is human and elementary.  It replaces the C794 seven-vertex
exhaustion by a four-point cut argument.  The old census remains an exact
falsifier and confirms the labelled small-order fibre table, but it is no
longer part of the proof.

For a symmetric conference matrix, the determinant-$(-3)$ principal
four-sets of Greaves--Suda are exactly $\mathcal A(\tau)$.  Hence their
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

### ej2: a quadratic sparse inverse

Fix any aligned four-set $Q$, put $m=|V|-4$, and retain only

\[
 \mathcal F_Q=\left\{R\in\binom V4:|R\cap Q|\geq2\right\}.
\]

> **Sparse aligned-certificate theorem.**  For $|V|\geq7$, the restriction
> $\mathcal A(\tau)\cap\mathcal F_Q$, together with the knowledge that
> $Q$ is aligned, determines $\tau$ up to complement.  It uses exactly
>
> \[
> 1+4m+6\binom m2=3|V|^2-23|V|+45
> \]
>
> four-set answers, rather than $\binom{|V|}{4}$.

The $4m$ sets meeting $Q$ in three points give every one-point cut signature
$p_x$.  The $6\binom m2$ sets meeting $Q$ in two points give the pair
signatures.  The pair lemma forces all outside cuts to be simultaneously
unchanged or changed; any three outside points rule out the changed case, and
the same tests recover every outside edge $c_{xy}$.  Thus the switching
representative is recovered directly, without passing through all seven-sets.

The displayed certificate is nonadaptive and uses

\[
 q_{\rm nonad}=1+4m+6\binom m2=3|V|^2-23|V|+45
\]

answers.  There is a sharper adaptive decoder.  Query all one-point
signatures, use the full six pair tests only on three outside seed points and
between one fixed seed and each later point, and thereby recover every cut.
Once two cuts are known, the signatures for $c_{xy}=0$ and $c_{xy}=1$ are
distinct by the pair lemma, so one adaptively chosen four-set recovers that
remaining edge bit.  This gives

\[
 q_{\rm ad}
 =1+\binom m2+9m
 =\frac{|V|^2+9|V|-50}{2}. \tag{A}
\]

The bound is asymptotically information-optimal.  After orienting the known
aligned block to value zero, fix one cross edge per outside point by switching.
The remaining $3m+\binom m2$ graph bits vary freely and give distinct
two-graphs.  Any binary-query decision tree must therefore use at least

\[
 q_{\rm lb}=3m+\binom m2
 =\frac{|V|^2-3|V|-4}{2}. \tag{B}
\]

answers in the worst case.  Thus $q_{\rm ad}=q_{\rm lb}+6m+1$: its leading
constant is optimal and only a linear additive gap remains.  Both decoders
take $O(|V|^2)$ bit operations and $O(|V|)$ streaming workspace.  Producing a
switching representative costs $\Theta(|V|^2)$; explicitly listing all
recovered triples necessarily costs $\Theta(|V|^3)$ output time and space.

Against exhaustive testing, the nonadaptive query reduction factor is
$|V|^2/72+O(|V|)$, while the adaptive factor is
$|V|^2/12+O(|V|)$.  On seven points both bounds equal 31, forcing the other
four design coordinates.  At conference order ten the bounds are 115
nonadaptive and 70 adaptive, versus all 210 principal four-set tests; the
information lower bound is 33.

If the input is a block list, hashing it costs $O(|\mathcal A|)$ expected time
and space before the quadratic decode.  With only a membership oracle and no
supplied anchor, blind search is quartic in the worst case.  Conference
regularity makes randomized anchor discovery cheap: at order $2d$ the aligned
density is

\[
 \rho=\frac{d-3}{2(2d-3)}.
\]

The expected number of uniform determinant probes is
$1/\rho=2(2d-3)/(d-3)$: 7, $11/2$, and 5 at orders 10, 14, and 18, tending
to 4.  After $k$ with-replacement probes the failure probability is
$(1-\rho)^k$; sampling without replacement is at least as good.

The main commercially relevant transfers are exact signed-network/gauge
synchronization, sparse validation of conference or ETF codebooks, discrete
phase/sign tomography from quartic observables, and switching-class
fingerprinting or deduplication.  The gain is from exhaustive quartic minor
scans to quadratic local tests.  This theorem does **not** yet improve generic
real matrix completion, continuous phase retrieval, or noisy synchronization:
those require a stability theorem and a soft-data decoder.

### ej3: noise margins, information geometry, and active learning

In the conference case the binary aligned answer has a built-in analog
margin.  For a zero-diagonal symmetric $4\times4$ matrix with off-diagonal
entries $a,b,c,d,e,f$, its determinant is

\[
 a^2f^2+b^2e^2+c^2d^2
 -2(abef+acdf+bcde).
\]

At a sign matrix the aligned and nonaligned values are respectively $-3$ and
$5$.  Thresholding at 1 therefore tolerates any direct determinant error of
magnitude less than 4.

There is also an entrywise guarantee.  If every off-diagonal sign entry is
perturbed by at most $\varepsilon$ and the zero diagonal is retained, every
partial derivative of the displayed polynomial is at most
$6(1+\varepsilon)^3$ in magnitude along the connecting segment.  Hence

\[
 |\Delta\det|\leq36\varepsilon(1+\varepsilon)^3.
\]

The threshold decoder is certified whenever
$9\varepsilon(1+\varepsilon)^3<1$; in particular, $\varepsilon\leq0.08$
is a simple rigorous sufficient bound.  This is a worst-case entrywise bound,
not a typical-noise estimate.

For repeated noisy determinant measurements the sample complexity is also
explicit.  If a thresholded answer is independently flipped with probability
$p<1/2$, majority vote over $r$ repetitions makes all $q$ adaptive answers
correct with probability at least $1-\delta$ whenever

\[
 r\geq\frac{2\log(q/\delta)}{(1-2p)^2}.
\]

Thus the full noisy acquisition cost is
$O(n^2\log(n/\delta)/(1-2p)^2)$.  If the determinant error itself is
$\sigma$-sub-Gaussian, averaging $r$ repetitions and using the margin four
gives the sufficient bound

\[
 r\geq\frac{\sigma^2}{8}\log(q/\delta).
\]

These repetition guarantees handle stochastic measurement noise.  They do
not give adversarial error correction: that requires a lower bound on the
Hamming distance between distinct aligned certificates in the promised input
class.

The same channel gives an exact discrete information geometry.  Let
$a(\tau)$ be any fixed nonadaptive aligned-answer vector and transmit each
coordinate through a binary symmetric channel of crossover $p$.  If two
two-graphs differ in $h$ queried answers, the product distributions satisfy

\[
 D_{\rm KL}(P_\tau\Vert P_{\tau'})
 =h(1-2p)\log\frac{1-p}{p},
\]

and their Chernoff information is

\[
 h\left[-\log\!\left(2\sqrt{p(1-p)}\right)\right].
\]

Thus Hamming geometry of aligned designs is exactly statistical
distinguishability geometry for the natural noisy observation model.  Under
additive Gaussian determinant noise of variance $\sigma^2$, each differing
query contributes $32/\sigma^2$ to KL divergence because the two means are
eight apart.

This has three concrete translations beyond conference-matrix reconstruction.

1. **Active concept learning.**  With a known anchor the concept class has
   $2^{3m+\binom m2}$ members.  The adaptive decoder is a zero-error
   twenty-questions scheme whose transcript length differs from entropy by
   only $6m+1$ bits.  It is therefore asymptotically capacity-achieving.
2. **Gauge-invariant machine learning.**  The aligned four-set features are a
   complete labeled invariant of a signed complete graph under vertex
   switching, up to global sign reversal.  They can serve as an exact
   higher-order feature layer, kernel key, or supervision target for signed
   networks.  The sparse inverse matters when features are acquired on demand;
   it does not accelerate a model that already receives the full sign matrix.
3. **Information-geometric experimental design.**  Query choice directly
   controls KL and Chernoff separation through Hamming distance.  This turns
   sensor selection into choosing four-set tests that split the current
   version space, with the C794 decoder providing a near-entropy benchmark for
   learned or greedy policies.
4. **Exact finite-population statistics.**  The balanced-half block count
   $c_T$ is a degree-four finite-population U-statistic.  Its conference-null
   mean and variance are switching-class independent, while C794's
   triple-union formula shows that its third cumulant is the first
   design-unforced method-of-moments diagnostic.  Standardized skewness can
   therefore test higher block-intersection structure after the universal
   location and scale have been removed; at order 14 it is exactly
   $-8/\sqrt{105}$.
5. **Sequential quality control.**  Under the binary or Gaussian channel
   above, likelihood ratios add over queried four-sets.  Sequential
   probability-ratio tests can stop as soon as the accumulated evidence
   separates a promised conference model from a specified alternative, while
   held-out four-sets provide a direct goodness-of-fit check for the decoded
   switching representative.
6. **Signed graphical models.**  In binary signed Ising or correlation
   networks, vertex sign changes are gauge transformations and triangle
   products are frustration observables.  The aligned layer reconstructs the
   labeled frustration pattern up to global reversal.  It identifies sign
   structure, not interaction magnitudes or a partition function.

For permutation-unlabelled ML, C794 alone is not a complete graph-isomorphism
invariant: one must select an anchor canonically or combine the decoder with a
canonical-labelling step.  For continuous weights, a differentiable soft
surrogate and a stability theorem remain necessary.

### ej4: the corrected fingerprint cascade and three free algorithms

The C788--C794 invariants do support a classification cascade, but not a
literal chain of increasingly fine invariants.  At fixed conference order the
mean and variance are universal, so they validate the promise and
normalization but cannot reject two switching classes.  The third moment can
reject.  The triple-block union profile determines the third factorial moment,
whereas the full balanced-cut histogram determines every moment of $c_T$;
neither summary is known to determine the other.  They are complementary
branches, not successive complete refinements.

For one object with marked-query access, the $O(n^2)$ C794 decoder is normally
cheaper than either an exact full histogram or a naive triple-block census.
The useful database cascade is therefore

\[
\begin{array}{c}
\text{promise/order checks}\\
\downarrow\\
\text{sampled or cached third moment}\\
\downarrow\\
\text{cached histogram and/or triple-union profile}\\
\downarrow\\
\text{C794 decode to a switching representative}\\
\downarrow\\
\text{cheap graph invariants}\\
\downarrow\\
\text{canonical labelling only inside the surviving bucket}.
\end{array}
\]

Early mismatches prove inequivalence; matches only pass a candidate onward.
The exact final comparison is reconstruction followed by canonicalization,
not the third moment.

Three items in the proposed algorithmic programme close almost for free.

#### Deterministic anchor search and parallel rounds

Choose any seven vertices, distinguish one as $r$, and query the twenty
four-sets consisting of $r$ plus three of the other six vertices.  The derived
graph on those six vertices has a clique or independent triple by
$R(3,3)=6$, so at least one of the twenty answers is aligned.  Thus every
valid two-graph oracle of order at least seven supplies an anchor in one
nonadaptive round and at most twenty queries.  The earlier quartic blind-search
bound is unnecessary.

After the anchor, query in one parallel round all one-point signatures, all
six signatures on three fixed outside seeds, and all six signatures from one
fixed seed to every later point.  Decode the cuts, then use one final adaptive
round to recover each remaining outside edge.  Hence:

- with a supplied anchor, the adaptive decoder has two query rounds;
- without one, it has three query rounds;
- the nonadaptive quadratic decoder has one round after the anchor, at the
  larger factor-six leading query constant.

The total deterministic query bound without a supplied anchor is at most
$q_{\rm ad}+19$ because the successful anchor query is already counted in
$q_{\rm ad}$.

#### Promise-free recognition and property testing

For an arbitrary marked four-set family, run the twenty-query anchor test.  If
it fails, the family cannot be an aligned design.  Otherwise enumerate the at
most $3^3=27$ cut assignments on three outside seed points.  The pair lemma
propagates each seed assignment uniquely or rejects it, so all candidate
two-graphs are produced in $O(n^2)$ time.

Exact recognition verifies every four-set against the at most 27 candidates,
using $O(n^4)$ oracle queries and time.  For property testing, suppose distance
is normalized by $\binom n4$ and the input is promised either valid or
$\varepsilon$-far from every valid aligned design.  Test

\[
 h\geq\frac{\log(27/\delta)}{\varepsilon}
\]

uniform held-out four-sets.  Valid inputs are always accepted, while every
$\varepsilon$-far input is rejected with probability at least $1-\delta$.
The total query complexity is

\[
 O\!\left(n^2+\varepsilon^{-1}\log(1/\delta)\right).
\]

This is a tester for marked families; it does not solve noisy recovery when
the queried decoding coordinates themselves are adversarially corrupted.

#### Canonicalization and automorphisms

For each vertex $r$, form the derived graph $G_r$ on $V\setminus\{r\}$ with
$ij$ an edge exactly when $\tau(rij)=1$.  A complete canonical form of the
unlabelled complement pair is

\[
 \min_{r\in V}
 \left\{\operatorname{canon}(G_r),
       \operatorname{canon}(\overline{G_r})\right\}.
\]

An isomorphism between two derived graphs extends by sending their omitted
vertices to one another; the two-graph parity identity then recovers every
remaining triple.  Conversely every two-graph isomorphism induces such a
derived-graph isomorphism.  Thus canonicalization reduces to at most $2n$
ordinary graph-canonicalization calls on $n-1$ vertices, plus $O(n^3)$ work to
form all derived graphs.  The hard complexity is exactly the chosen
graph-isomorphism backend, not C794 reconstruction.

There is also an exact group statement.  Faithfulness gives

\[
 \operatorname{Aut}(\mathcal A(\tau))
 =\{\pi:\pi\tau=\tau\text{ or }\pi\tau=\tau+1\}.
\]

The ordinary automorphism group $\operatorname{Aut}(\tau)$ is the kernel of
the homomorphism to $C_2$ recording whether a permutation preserves or
complements $\tau$, hence has index one or two in the aligned-design
automorphism group.  A canonical-labelling backend can therefore return both
the extended group and the oriented subgroup.

#### Exact isomorphism reduction and conference/ETF recovery

For $n\geq 7$, faithfulness is equivalently the unlabelled statement

\[
 \mathcal A(\tau_1)\cong\mathcal A(\tau_2)
 \quad\Longleftrightarrow\quad
 \tau_1\cong\tau_2\text{ or }\tau_1\cong\overline{\tau_2}.
\]

Thus aligned-design isomorphism is exactly two-graph isomorphism modulo the
single complement bit.  It does not make graph isomorphism easy, but it proves
that the aligned design loses no information relevant to canonicalization,
deduplication, or automorphism extraction.

For a conference two-graph, choose a root $0$ and switch a Seidel or
conference representative so that $C_{0i}=1$ for every $i\ne0$.  The triangle
value on $\{0,i,j\}$ then determines the sign of $C_{ij}$.  Hence the marked
determinant-$(-3)$ predicate reconstructs the conference signing up to vertex
relabeling, diagonal switching, and global negation.  The last ambiguity is
exactly $\tau\leftrightarrow\overline\tau$ and one calibrated triangle-product
measurement selects its orientation.  Under the usual $G=I+\alpha C$
normalization, the same statement recovers the discrete ETF sign codebook.
It does not claim recovery of an unknown scale, physical basis, or arbitrary
real-valued perturbation.

This is a measurement-compression result: $O(n^2)$ selected quartic tests
recover the discrete codebook, whereas materializing the complete aligned
family uses $\binom n4=\Theta(n^4)$ tests.  It is also a non-hiding theorem.
Publishing the labelled determinant-$(-3)$ pattern exposes the switching
class to a quadratic-query adversary, so that pattern is not a
privacy-preserving or cryptographic digest of the conference signing.

#### Sparse certificates and the coding problem

The nonadaptive signature of length

\[
 4m+6\binom m2=3n^2-23n+44,
 \qquad m=n-4,
\]

together with the known aligned-anchor bit, certifies equality of promised
two-graphs up to complement.  The normalized message has
$3m+\binom m2=(n^2-3n-4)/2$ bits, so the signature rate tends to $1/6$.
The adaptive transcript has asymptotic rate one.  These quadratic signatures
support proof-carrying switching-class databases, compact deduplication
records, distributed verification, and streaming decoders without ever
materializing all four-sets.

The promise is essential: this certificate compares valid aligned designs;
by itself it does not certify that an arbitrary four-uniform family lies in
the image of $\tau\mapsto\mathcal A(\tau)$.  The exact-recognition and testing
procedures above supply that missing check at different costs.

The principal open coding-theoretic question is adversarial distance.  A
minimum-distance bound, a local-testability theorem, or an efficient decoding
radius would upgrade exact reconstruction to corrupted-test recovery, noisy
quartic tomography, and quantitative error localization.  The independent
noise guarantees in ej3 do not answer this adversarial question.

After these reductions, the genuinely new algorithmic priorities are:

1. adversarial certificate distance and robust decoding;
2. a canonicalization/automorphism reference implementation and benchmarks;
3. closing the remaining linear additive query gap;
4. a complete conference/ETF reconstruction package with noisy-data tests.

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

The four signs $\epsilon_{ijk}$ on a four-set have product one.  They are
all equal exactly when the sum of the three Hamilton-cycle signs is three,
equivalently when the principal determinant is (-3).  Thus
Greaves--Suda's $3\text{-}(4n+2,4,n-1)$ design is precisely the aligned
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
$\mathbf F_2$ matrix has rank 28 and nullity two.  Its kernel is spanned by
the constant coloring and the actual weight-15 coloring.  The two constant
solutions would make every four-set aligned and are rejected by the given
design; the two surviving nonconstant solutions are the weight-15 coloring
and its complement.  This explains why component propagation fails while
the functor remains faithful.

## The first design-unforced cut moment

Let $\mathcal B$ be any four-block family on ($v=2d$) points and let
$c_T=|\{B\in\mathcal B:B\subseteq T\}|$ for a uniformly chosen $d$-set.
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
$(32/(2d-1)^2)^3$, since C788 gives an affine function of $c_T$.

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

Greaves--Suda owns the determinant-$(-3)$ $3$-design construction.
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
- **Settled by ej2:** after one aligned anchor, the quadratic family of
  four-sets meeting it in at least two points is already faithful.  It gives
  an explicit $O(n^2)$ decoder, and conference density makes randomized
  anchor discovery constant expected cost.
- **Settled by ej3:** the conference determinant gap gives an exact threshold
  margin, an eight-percent worst-case entrywise perturbation guarantee, and
  logarithmic repetition overhead under stochastic noise.  The induced
  binary-channel model turns certificate Hamming distance into exact KL and
  Chernoff geometry and identifies active learning, finite-population
  inference, sequential testing, and gauge-invariant ML as literal, rather
  than metaphorical, transfers.
- **Open, robustness gate:** adversarial correction still needs the minimum
  Hamming distance of the promised conference certificate class; stochastic
  repetition does not settle it.
- **Settled by ej4:** deterministic anchor search costs at most twenty
  parallel queries; adaptive reconstruction takes three rounds without an
  anchor and two with one; exact recognition is quartic, while
  $\varepsilon$-far property testing is quadratic plus
  $O(\varepsilon^{-1}\log(1/\delta))$; canonicalization reduces to derived
  graph canonicalization, and the aligned-design automorphism group is the
  index-at-most-two extension allowing global complementation.
- **Corrected:** the moment/profile “cascade” is a rejection cascade, not a
  hierarchy of complete invariants.  Mean and variance are universal, and the
  full histogram and triple-union profile are incomparable summaries.
- **Settled by ej4, encoding:** the nonadaptive promised-equality certificate
  has asymptotic rate $1/6$; marked conference/ETF signs are recovered up to
  relabeling, switching, and one global bit.  Consequently the labelled
  determinant pattern is a compressed codebook, not a privacy-preserving
  digest.
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
