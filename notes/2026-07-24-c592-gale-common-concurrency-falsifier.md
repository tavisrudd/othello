# C592: six-point Gale common-concurrency falsifier

**Lane:** `relconic`

**Date:** 2026-07-24

**Status:** complete negative.  The entire fifteen-bit perfect-matching
concurrence pattern is Gale self-dual.  Its six-subset aggregate is exactly
the raw third secant moment already proved subordinate in C555.  The candidate
therefore does not open C556.

## Question and gate

C555 proves that raw secant moments and the conic chord graph are subordinate
to the prescribed-hole defect.  C402 supplies, for a six-arc \(S\) with Gale
dual \(S^*\), the common-concurrency count
\[
 b(S,S^*)=
 \#\{M:\text{\(M\) is a perfect matching whose three chords concur in both
 \(S\) and \(S^*\)}\}.
\]
This task tests whether aggregating that count over six-subsets of an arc
produces information not determined by the C554--C555 concurrence-index data.

The task passes only if the paired original/Gale equations impose a
rank-three compatibility condition coupling distinct concurrence matching
cliques and not determined by the distribution of the indices \(r(x)\).
It fails if the statistic reduces to the existing moment hierarchy or varies
freely among realizations with the same matching-clique data.

## Bounded plan

1. Normalize a generic six-arc as \(P=[I_3\mid X]\) and use the canonical
   Gale matrix \(P^*=[-X^T\mid I_3]\).
2. Derive the concurrence determinant for each of the fifteen perfect
   matchings on both \(P\) and \(P^*\).
3. Determine the algebraic relation between the two sets of determinants and
   identify what information the common-zero count retains.
4. Test independence from the C554--C555 data on exact finite-field
   realizations only if the symbolic relation does not already decide the
   gate.  Any computation will be committed as a deterministic report,
   checker, canonical certificate, and checksum manifest.
5. Calibrate against the committed \(\F_4\) six-hyperoval and the regular
   \(\F_8\) hyperoval realization without turning the calibration into a
   field census.

## Inputs and boundary

- `notes/2026-07-23-c402-h3-ame-uniform-lu-separation.md` proves the portable
  formula \(60+b(S,S^*)\).
- `notes/2026-07-24-c555-small-defect-third-moment.md` proves the subordinate
  raw-moment boundary and states the missing mixed rank-three compatibility
  layer.
- C556 remains gated unless this task exposes the required invariant.

No manuscript claim or asymptotic improvement is assumed.

## Gale self-duality of matching concurrence

Let \(P=(p_1,\ldots,p_6)\) be a rank-three \(3\times6\) matrix representing
a six-arc, and let \(Q=(q_1,\ldots,q_6)\) be any Gale matrix, so
\(PQ^T=0\).  Write \([ijk]_P=\det(p_i,p_j,p_k)\), and similarly for \(Q\).
Grassmann duality gives a nonzero scalar \(\lambda\) such that
\[
 [I]_Q=\lambda\epsilon_I[I^c]_P
\]
for every three-subset \(I\), where \(\epsilon_I\) is the sign of the
concatenation \((I,I^c)\).

For a perfect matching
\[
 M=\{ab,cd,ef\},
\]
let \(\kappa_P(M)\) be the determinant of the three chord-line coordinates.
The vector identity
\[
 (p_c\times p_d)\times(p_e\times p_f)
 =[cdf]_Pp_e-[cde]_Pp_f
\]
gives
\[
 \kappa_P(M)
 =[cdf]_P[abe]_P-[cde]_P[abf]_P.
\]
Each bracket in either product is paired with its complementary bracket.
Since
\(\epsilon_I\epsilon_{I^c}=(-1)^{3\cdot3}=-1\), the same calculation for
the Gale matrix gives
\[
 \kappa_Q(M)=-\lambda^2\kappa_P(M).
\]
Changing pair orientations or the order of the three pairs changes only an
overall sign.  Therefore
\[
 \kappa_P(M)=0\quad\Longleftrightarrow\quad\kappa_Q(M)=0
\]
for each of the fifteen perfect matchings separately.

Thus C402's “common” matching-concurrence set is not an intersection of two
independent rank-three conditions: the two fifteen-bit incidence vectors are
identical for every six-arc.

## Collapse of the global aggregate

Let \(A\) be a \(k\)-arc and let \(r(x)\) be its secant index at
\(x\notin A\).  For a six-subset \(S\subseteq A\), write \(t(S)\) for the
number of its concurrent perfect matchings.  The theorem above gives
\[
 b(S,S^*)=t(S).
\]

A concurrent perfect matching on \(S\) is exactly a choice of three distinct
secants of \(A\) through one centre \(x\).  Their six endpoints are distinct
because \(A\) is an arc.  Conversely, every three secants through \(x\)
produce one such six-subset and perfect matching.  Hence
\[
 \boxed{\displaystyle
 \sum_{S\in\binom A6}b(S,S^*)
 =\sum_{S\in\binom A6}t(S)
 =\sum_{x\notin A}\binom{r(x)}3.}
\]
This is precisely the third raw secant moment treated in C555.  Its exact
remainder has the same local factor \(m-r(x)\) as the C554 defect, so the
proposed statistic supplies no independent nonnegative term and cannot
improve the additive constant.

## `ej` and Tao closeout

The self-duality is stronger than the requested finite falsifier: no field
calibration or census is needed.  It also identifies the exact information
loss.  At matching-concurrence level, Gale duality contributes no second
realization at all; any successful use of six-subset Gale data must retain
projective values beyond the vanishing pattern.

The cheapest apparent rescue is the overlap statistic
\[
 \sum_{S\in\binom A6}\binom{t(S)}2,
\]
which couples two different concurrence centres on the same six vertices.
It is not forced by the existing moment totals.  Indeed C555 gives
\[
 \sum_S t(S)
 \le (m-2)\binom{k}{4},
\]
while
\[
 \frac{(m-2)\binom{k}{4}}{\binom{k}{6}}
 =
 \begin{cases}
 15/(k-5),&k\text{ even},\\
 15/(k-4),&k\text{ odd}.
 \end{cases}
\]
For \(k\ge21\), even the formal maximum first moment is below the number of
six-subsets, so counting alone cannot force any \(t(S)\ge2\).  A useful
overlap theorem would already require the new global rank-three compatibility
mechanism sought in C555; it is not a free continuation of C402.

No further same-statistic variant is promoted.  C556 remains behind its
original gate.

## Post-closeout `ej`: the projective Brianchon covariant

The identity
\[
 \kappa_Q(M)=-\lambda^2\kappa_P(M)
\]
uses the same scalar for all fifteen matchings.  It therefore preserves more
than the zero pattern.  The marked six-arc has a canonical homogeneous
covariant vector, defined up to one common nonzero scalar,
\[
 \widetilde{\boldsymbol\kappa}(S)
   =(\kappa_S(M))_{M\in\operatorname{PM}(6)}.
\]
Each coordinate is homogeneous of degree one in every point representative,
so independent rescaling of the six columns multiplies all coordinates by
the same scalar.  Projectivities have the same effect through their
determinant, relabelling permutes the coordinates up to signs, and Gale
duality fixes the vector up to scale.  Away from the common zero locus, this
defines
\[
 \boldsymbol\kappa(S)
   =[\kappa_S(M)]_{M\in\operatorname{PM}(6)}
   \in\mathbb P^{14}.
\]

The base locus is geometrically meaningful: all fifteen coordinates vanish
exactly when every perfect matching is concurrent.  This is the six-point
all-matching concurrence design forced by zero defect; in a Desarguesian
plane it is the
\(\F_4\)-hyperoval configuration classified in C554/C558.  Thus the covariant
degenerates at the sharp six-point extremum and records near-extremality as
coordinate sparsity.

Unlike its support, this covariant retains genuine six-arc moduli.  For
\[
 p_1=e_1,\quad p_2=e_2,\quad p_3=e_3,\quad p_4=(1,1,1),\quad
 p_5=(1,a,b),\quad p_6=(1,c,d),
\]
two coordinates are
\[
\begin{aligned}
 \kappa(12|34|56)&=b(c-1)-d(a-1),\\
 \kappa(13|24|56)&=a(d-1)+c(1-b),
\end{aligned}
\]
which are not proportional polynomials.  Thus the generic all-nonzero
support pattern is constant while \(\boldsymbol\kappa(S)\) varies.

This is the concrete non-scalar object suggested abstractly by the AME
operator-valued transfer.  It does not itself yield an inequality: finite
fields provide no order on its nonzero values, and every arc already satisfies
the overlap compatibility inherited from its point coordinates.  Its useful
next gate is narrower:

> Determine whether the projective \(\boldsymbol\kappa\)-vectors of overlapping
> six-subsets satisfy a bounded-rank or forbidden-minor condition that becomes
> stronger when many coordinates vanish in maximum-matching cliques.

The gate should start symbolically on seven marked points.  Compare the seven
six-subset covariants after eliminating point-rescaling gauge.  **GO** only if
the overlap relations impose a rank condition not generated by the individual
Plücker relations and the C555 moment identities.  **NO-GO** if the relations
merely reconstruct the original seven-point configuration with no extra
constraint on sparse concurrence patterns.  This is a plausible fresh C item,
but it is not allocated here.

## Post-closeout `ej2`: locality is too dilute; the tangent locus is global

The seven-point proposal is not the best first test.  At zero concurrence
defect, C555 gives
\[
 T:=\sum_{S\in\binom A6}t(S)=(m-2)\binom{k}{4}.
\]
Among all \(15\binom{k}{6}\) marked perfect matchings on six-subsets, the
vanishing-coordinate density is therefore
\[
 \frac{T}{15\binom{k}{6}}
 =
 \begin{cases}
 1/(k-5),&k\text{ even},\\
 1/(k-4),&k\text{ odd}.
 \end{cases}
\]
It tends to zero at the target scale.  A fixed six- or seven-point overlap
identity therefore sees the extremal matching structure only with
\(O(1/k)\) density; without a separate concentration theorem it cannot force
an asymptotic correction.  The useful object must be conditioned on entire
maximum matching cliques.

Two such cliques still impose no hidden holonomy.  Normalize their concurrence
centres to
\[
 x=(1,0,0),\qquad y=(0,1,0)
\]
and separate their possible common matching edge on \(xy\).  Work off \(xy\)
with points \((u,v,1)\).  Secants through \(x\) pair points
with the same \(v\), while secants through \(y\) pair points with the same
\(u\).  Every alternating cycle of their two matchings has the form
\[
\begin{aligned}
 &(u_1,v_1),(u_2,v_1),(u_2,v_2),(u_3,v_2),\ldots,\\
 &(u_r,v_r),(u_1,v_r),
\end{aligned}
\]
with the \(u_i,v_i\) otherwise free on a Zariski-open arc locus.  Thus
pair-of-matching cycle invariants, including a direct C475-style four-cycle
quotient, reconstruct row--column coordinates but give no rank-three
obstruction.

Three centres are not yet a convincing replacement.  For noncollinear centres
normalized to the coordinate points, their matchings pair equal values of
\[
 v,\qquad u,\qquad u/v.
\]
There is already an adverse scalable ansatz: take the row--column cycle cells
\[
 (u_i,v_i),\ (u_i,v_{i+1})
\]
and a homothetic copy
\[
 (a u_i,a v_i),\ (a u_i,a v_{i+1}).
\]
Every row, column, and represented slope then occurs exactly twice.  Whether
generic parameters avoid every unintended collinear triple needs a separate
check, but this is enough to demote the three-centre test: the pairing
conditions themselves plainly admit unbounded combinatorial families.

The higher-value reformulation is global and is already present in the C554
data.  Let \(\tau_A(x)\) be the number of tangent lines from an outside point
\(x\) to the \(k\)-arc \(A\).  Partitioning \(A\) by the lines through \(x\)
gives the exact identity
\[
 k=2r(x)+\tau_A(x).
\]
Consequently a maximum-index centre \(r(x)=m=\lfloor k/2\rfloor\) is exactly

\[
\begin{cases}
\text{a tangent-free outside point},&k\text{ even},\\
\text{an outside point on exactly one tangent},&k\text{ odd}.
\end{cases}
\]

At zero defect, C554 does not merely supply a sparse sample of such points.  It
forces
\[
 \#\{x:\tau_A(x)=0\}=(k-1)(k-3)\quad(k\ \text{even})
\]
or
\[
 \#\{x:\tau_A(x)=1\}=k(k-2)\quad(k\ \text{odd}).
\]
This \(\asymp k^2\) low-tangent locus is the non-dilute rank-three object that
the six-point determinant failed to expose.  Dually, it asks how the tangent
lines of an arc can leave so many points uncovered, or singly covered, while
the arc remains disjoint from the prescribed conic.

There is a sharper dual package.  Let \(\mathcal T_A\subset\PG(2,q)^*\) be the
set of dual points representing all tangent lines of \(A\).  Each point of
\(A\) lies on \(q+2-k\) tangents, so
\[
 |\mathcal T_A|=k(q+2-k).
\]
For \(x\notin A\), the dual line \(x^*\) meets \(\mathcal T_A\) in
\(\tau_A(x)\) points; for \(x\in A\), it meets it in \(q+2-k\) points.  The
zero-defect condition \(r(x)\in\{0,1,m\}\) therefore makes
\(\mathcal T_A\) a four-intersection set, with line-intersection spectrum
contained in
\[
 \{q+2-k,\,0,\,k-2,\,k\}\quad(k\text{ even})
\]
and
\[
 \{q+2-k,\,1,\,k-2,\,k\}\quad(k\text{ odd}).
\]
In particular, two tangents with distinct contact points cannot meet in an
ordinary double point: their intersection lies on \(k-2\) or \(k\) tangents
regardless of parity.  The associated projective incidence code is
correspondingly a few-weight code.  This exposes a concrete route for
finite-geometry polynomial or code-weight tools that the local Gale covariant
could not see.

The best unallocated gate is therefore a tangent-arrangement/envelope
falsifier:

1. classify or rule out tangent-derived four-intersection sets with the above
   size and spectrum, using incidence moments, polynomial methods, or
   few-weight-code constraints;
2. test whether the exact low-multiplicity line counts force a low-degree
   carrier or a hyperoval-type exceptional family;
3. couple any such rigidity to disjointness from the prescribed conic;
4. **GO** toward C556 only if this yields positive defect or a carrier
   invariant; **NO-GO** if general-position tangent arrangements attain the
   required \(\asymp k^2\) loci.

This does not assert an available classification theorem; a
Segre-lemma/tangent-envelope and few-intersection-set literature audit would be
part of the gate.  It replaces both the seven-point overlap and the raw
three-centre classification as the highest-value next lower-bound experiment.
It remains unallocated, and C556 remains gated.

## Mystery ledger

| Feature | Disposition |
|:--|:--|
| Does Gale duality add an independent matching-concurrence condition? | **Settled negatively:** every one of the fifteen concurrence divisors is Gale self-dual. |
| Is the aggregate \(B(A)\) new information? | **Settled negatively:** it equals \(\sum_x\binom{r(x)}3\), the C555 third moment. |
| Could nonlinear functions of the per-six-set count \(t(S)\) be new? | **Open but not promoted:** pair overlaps do couple centres, but existing totals do not force them; a new geometric compatibility theorem is already needed. |
| Does the determinant calculation retain anything beyond concurrence support? | **Settled positively by the post-closeout `ej`:** the full homogeneous vector \(\widetilde{\boldsymbol\kappa}(S)\) is a nonconstant Gale-invariant covariant and projectivizes off its zero-defect base locus. |
| What is the covariant's base locus? | **Settled:** simultaneous vanishing of all fifteen coordinates is exactly the six-point all-matching concurrence design forced by zero defect, hence the \(\F_4\)-hyperoval configuration in the Desarguesian case. |
| Can fixed six-/seven-point \(\boldsymbol\kappa\)-overlaps force an asymptotic correction? | **Deprioritized by `ej2`:** their zero-coordinate density is only \(1/(k-5)\) or \(1/(k-4)\), so locality needs an unavailable concentration theorem. |
| Do two maximum-matching centres impose cycle holonomy? | **Settled negatively by `ej2`:** after normalization they are arbitrary row--column alternating cycles on a Zariski-open arc locus. |
| Do three maximum-matching centres give the missing gate? | **Deprioritized:** simultaneous row, column, and slope pairings have an explicit scalable combinatorial ansatz; generic arc realizability is not checked. |
| Where is the first non-dilute compatibility object? | **Open at the dual tangent set:** zero defect makes the \(k(q+2-k)\) tangents a four-intersection set and requires \((k-1)(k-3)\) zero-secants of it for even \(k\), or \(k(k-2)\) one-secants for odd \(k\). |
| Does C592 open C556? | **No:** no carrier or rank invariant independent of C554--C555 was exposed. |

## Evidence and trust boundary

The result is a direct Plücker-coordinate proof over an arbitrary field.
It uses only rank-three Grassmann duality, the displayed vector identity,
and the C554 bijection between triples of concurrent secants and perfect
matchings on six endpoints.  The exact finite-field sign check used during
drafting is not load-bearing and is not part of the evidence.  No
computational or literature claim is made.
