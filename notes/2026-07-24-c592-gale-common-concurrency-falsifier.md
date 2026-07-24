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

## Mystery ledger

| Feature | Disposition |
|:--|:--|
| Does Gale duality add an independent matching-concurrence condition? | **Settled negatively:** every one of the fifteen concurrence divisors is Gale self-dual. |
| Is the aggregate \(B(A)\) new information? | **Settled negatively:** it equals \(\sum_x\binom{r(x)}3\), the C555 third moment. |
| Could nonlinear functions of the per-six-set count \(t(S)\) be new? | **Open but not promoted:** pair overlaps do couple centres, but existing totals do not force them; a new geometric compatibility theorem is already needed. |
| Does C592 open C556? | **No:** no carrier or rank invariant independent of C554--C555 was exposed. |

## Evidence and trust boundary

The result is a direct Plücker-coordinate proof over an arbitrary field.
It uses only rank-three Grassmann duality, the displayed vector identity,
and the C554 bijection between triples of concurrent secants and perfect
matchings on six endpoints.  The exact finite-field sign check used during
drafting is not load-bearing and is not part of the evidence.  No
computational or literature claim is made.
