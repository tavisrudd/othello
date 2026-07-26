# C662 — human passant-bound boundary theorem

**Lane:** `clebsch`

**Status:** complete and integrated into Paper I.  A uniform
human cover theorem and a uniform saturation reconstruction are proved below.
They recover the exact \(k=7,8\) terminal window and identify two endpoint
cases with minimum-weight incidence-code supports, but they do **not** exclude
the five terminal pairs.  Thus C662 does not replace the C605 searches.  It
does strengthen Paper I's general conic-filling window and simplify its
terminal field sieve.

## Result

Let \(\mathcal C\) be a nonsingular conic in
\(\operatorname{PG}(2,q)\), \(q\) odd, and let \(A\) be a \(k\)-arc disjoint
from \(\mathcal C\).  Suppose that the union of the chords of \(A\) is exactly
\(\operatorname{PG}(2,q)\setminus\mathcal C\); equivalently, \(A\) is
conic-filling with uncovered conic \(\mathcal C\).  Put
\(m=\binom{k}{2}\).

Then:

1. every chord of \(A\) is passant to \(\mathcal C\), and
   \[
     m\ge \frac{3(q-1)}2,
     \qquad
     q\le \frac{k(k-1)+3}{3};
   \]
2. for \(k=7,8\), together with the elementary passant-pencil bound
   \(q\ge2k-3\), this leaves exactly
   \[
   \begin{array}{c|c}
   k& q\\ \hline
   7&11,13\\
   8&13,17,19
   \end{array}
   \]
   among odd prime powers;
3. if \(q=2k-3\), then every point of \(A\) is internal to
   \(\mathcal C\), the \(k-1=(q+1)/2\) chords through each point exhaust
   its passant pencil, and the characteristic vector of \(A\) is a
   weight-\((q+3)/2\) word in the binary nullspace of the incidence
   matrix of passant lines versus internal points;
4. in that saturation case, the tangent lines of the arc \(A\) at each
   vertex are exactly the secant lines to \(\mathcal C\) through that
   vertex.

Conversely, an arc-supported word of weight \((q+3)/2\) in that binary
nullspace is a set of internal points whose pairwise joins are passant and
whose passant pencil is saturated at every point.

There is also a useful dual reconstruction.  Under the conic polarity, the
\(m\) chord lines become \(m\) internal points
\[
 B=\{(P_iP_j)^\perp:1\le i<j\le k\}.
\]
They are the pairwise intersections of the \(k\) polar lines
\(P_1^\perp,\ldots,P_k^\perp\), no three of which are concurrent.  Conic
filling is equivalent to \(B\) meeting every non-tangent line.  Thus the
terminal problem is simultaneously an arc-generated internal blocking-set
problem.

For the five terminal pairs the excess over the universal elliptic-line
cover bound is respectively
\[
\begin{array}{c|ccccc}
(k,q)&(7,11)&(7,13)&(8,13)&(8,17)&(8,19)\\ \hline
m-\frac{3(q-1)}2&6&3&10&4&1.
\end{array}
\]
Thus \((8,19)\) is already a one-line-above-minimum elliptic cover problem,
whereas \((7,11)\) and \((8,13)\) are the two minimum-weight
passant/internal-code problems.

## Human proof

The \(m\) chord lines cover every point outside \(\mathcal C\) and no point
of \(\mathcal C\).  They are therefore a partial line cover of
\(\operatorname{PG}(2,q)\) with exactly \(h=q+1\) holes, and the holes are
not collinear.

The partial-cover bound of Blokhuis--Brouwer--Szőnyi says that a partial
cover with \(h>0\) noncollinear holes has at least
\(2q-1-h/2\) lines.  In this conic case its short proof is especially
transparent.  Add at most \((q+1)/2\) lines which cover all but one conic
point: pair conic points by chords, and if necessary use one final line
through the unpaired point while avoiding the point chosen to remain
uncovered.  The resulting cover has one hole.  The
Brouwer--Schrijver/Jamison polynomial bound says that a one-hole cover of
\(\operatorname{PG}(2,q)\) has at least \(2q-1\) lines.  Hence
\[
 m+\frac{q+1}{2}\ge2q-1,
 \qquad
 m\ge\frac{3(q-1)}2.
\]
This proves the first assertion without enumeration.

At a point off an odd-order conic there are \((q+1)/2\) passant lines if
the point is internal and \((q-1)/2\) if it is external.  The \(k-1\)
distinct chord lines through a vertex of an arc are all passant, so
\(k-1\le(q+1)/2\), equivalently \(q\ge2k-3\).  Combining the two bounds
and retaining only odd prime powers gives the displayed terminal table.

Suppose now that \(q=2k-3\).  An external vertex has only
\((q-1)/2=k-2\) passants, fewer than its \(k-1\) chords, so every vertex
is internal.  An internal vertex has exactly \((q+1)/2=k-1\) passants,
and its chord lines exhaust them.  Since \(A\) is an arc, every passant
line consequently meets \(A\) in zero or two points.  This is precisely
the assertion that its characteristic vector lies in the binary nullspace
of the passant-line/internal-point incidence matrix.  Its weight is
\(k=(q+3)/2\), the elementary Tanner lower bound: after choosing one
support point, every passant through it needs a distinct second support
point.

The remaining \((q+1)/2\) lines through an internal vertex are the secants
to \(\mathcal C\).  They are also the \(q+2-k=(q+1)/2\) tangent lines of
the \(k\)-arc, proving the tangent reconstruction.  Reversing the parity
and counting argument proves the converse.

For the dual assertion, polarity sends a chord \(P_iP_j\) to
\(P_i^\perp\cap P_j^\perp\), which is internal because the chord is
passant.  The arc condition says that no three of the polar lines are
concurrent.  A point \(X\) lies on a chord if and only if the polar line
\(X^\perp\) contains the pole of that chord.  Since the only points not on
chords are the conic points, whose polars are precisely the tangent lines,
the claimed blocking equivalence follows.

## Why this does not replace C605

The cover inequality is sharp as a general human theorem.  Blokhuis,
Brouwer, and Szőnyi explicitly record that the minimum
\(3(q-1)/2\) is attained for \(q=3,5,7,11\); their further statement that
there is no other equality example for odd \(q<25\) came from a computer
search, so it is not an admissible crown for C662.

The saturation reconstruction is also a reduction, not an exclusion.
Droms--Mellinger--Meyer prove only
\[
 \frac{q+3}{2}\le d\le q-1
\]
for the binary code defined by passant lines and internal points.
Madison--Wu determine the nullspace dimension and its representation
structure, not the minimum-weight supports.  Excluding arc-supported words
at the lower bound for \(q=11,13\) is therefore exactly a residual
minimum-distance classification problem, not a consequence of the known
dimension theorem.

The Blokhuis--Seress--Wilbrink complete-exterior-set theorem does not bridge
this gap.  It concerns \((q+1)/2\) **external** points, whereas the two
saturated terminal cases force \((q+3)/2\) **internal** points.  Mixed-type
terminal arcs are outside its hypotheses as well.

The natural association-scheme attack also misses the needed conclusion,
and this can be checked without searching for arcs.  For \(q=13\), put a
graph on the 78 internal points, joining two when their line is passant.
The elliptic association scheme of Hollmann--Xiang gives an equitable
seven-cell quotient (identity plus the six pair relations).  If the cells
are ordered by the normalized orthogonal invariant
\[
 *,0,1,3,9,10,12,
\]
where \(*\) is the singleton identity cell,
the quotient matrix for the union of the three passant relations
\(9,10,12\) is
\[
\begin{pmatrix}
0&0&0&0&14&14&14\\
0&6&8&8&4&8&8\\
0&4&6&8&10&8&6\\
0&4&8&6&6&10&8\\
1&2&10&6&7&6&10\\
1&4&8&10&6&7&6\\
1&4&6&8&10&6&7
\end{pmatrix}.
\]
This is a specialization of the published intersection-number formulae,
so it is a small association-algebra calculation, not an arc census.  Its
characteristic polynomial is
\[
 (x-42)(x+6)(x-2)^2(x^3+x^2-37x-29).
\]
The ordinary ratio bound cannot be applied to cliques using the least
eigenvalue of this graph; doing so would confuse the clique and coclique
bounds.  Applying the full Delsarte positivity inequalities of the
six-class scheme gives only
\(\omega\le 8\).  The terminal \(8\)-arc would itself be an
eight-clique, so even the full scheme stops exactly one integer short of
the required \(\omega\le7\).  This rules out a cheap spectral promotion
while preserving the negative conclusion.

The three mechanisms therefore meet at a clean boundary:

- the polynomial partial-cover theorem gives the uniform field window;
- the binary incidence code reconstructs the lower endpoint
  \(q=2k-3\);
- the full \(q=13\) elliptic scheme reaches, but does not exclude, size eight;
- none supplies the missing small-weight-support or
  near-minimum-cover classification.

The exact maximum-six searches in C605 remain the only accepted exclusion
of all five terminal pairs.

## Literature boundary

- A. Blokhuis, A. E. Brouwer, and T. Szőnyi, “Covering all points except
  one,” *Journal of Algebraic Combinatorics* **32** (2010), 59--66,
  doi: [10.1007/s10801-009-0204-1](https://doi.org/10.1007/s10801-009-0204-1).
  Proposition 1.5 is the partial-cover bound and Proposition 1.6 is its
  elliptic-line/conic specialization.
- S. V. Droms, K. E. Mellinger, and C. Meyer, “LDPC codes generated by
  conics in the classical projective plane,” *Designs, Codes and
  Cryptography* **40** (2006), 343--356,
  doi: [10.1007/s10623-006-0022-6](https://doi.org/10.1007/s10623-006-0022-6).
  Theorem 4.9 gives the stated minimum-distance interval.
- A. L. Madison and J. Wu, “On binary codes from conics in
  \(\operatorname{PG}(2,q)\),” *European Journal of Combinatorics*
  **33** (2012), 33--48,
  doi: [10.1016/j.ejc.2011.08.001](https://doi.org/10.1016/j.ejc.2011.08.001).
- A. Blokhuis, A. Seress, and H. A. Wilbrink, “Characterization of
  complete exterior sets of conics,” *Combinatorica* **12** (1992),
  143--147,
  doi: [10.1007/BF01204717](https://doi.org/10.1007/BF01204717).
- H. D. L. Hollmann and Q. Xiang, “Association schemes from the action of
  \(\operatorname{PGL}(2,q)\) fixing a nonsingular conic,”
  *Journal of Algebraic Combinatorics* **24** (2006), 157--193,
  doi: [10.1007/s10801-006-0005-8](https://doi.org/10.1007/s10801-006-0005-8).
  Their modified-cross-ratio relations and intersection parameters give
  the seven-cell calculation above.

## Paper I disposition

The partial-cover theorem is integrated into Paper I.  Although it leaves
the five terminal fields and every load-bearing C605 search unchanged, it
improves the general upper bound from
\(q<\binom{k}{2}\) to \(q\le(k(k-1)+3)/3\), simplifies the \(k=7,8\)
field sieve, and narrows the asymptotic conic-filling window from coefficient
\(1/2\) to \(1/3\).  The incidence-code, polarity, and association-scheme
reductions remain in this report: without a support classification they
would enlarge the manuscript without strengthening its classification.

## `aa` follow-up: a computation-free Paper I

The right alternative attack changes the output shape.  Paper I's headline
rigidity theorem is already human: the line bound and chord-defect identity
force ten Brianchon points, and Dye's equality theorem identifies the
Clebsch orbit.  Computation is load-bearing only for three strengthenings:

1. the degree-at-most-three recognition theorem and its fifteen-class table;
2. the numerical gap among all six-arcs in \(\operatorname{PG}(2,11)\);
3. the \(k=7,8\) terminal classification.

The highest-EV non-bloating revision is therefore **subtractive**.  Retain
the fixed-\(q=11\) rigidity theorem, decoder reconstruction, universal chord
defect, and partial-cover window.  Retain any broader small-\(k\) clause only
when its cited finite-graph input has a conceptual proof acceptable under the
same standard.  Remove the three items above from the manuscript and preserve
them in the computational companion record.  The executable replay table can
then leave the paper as well; exact scripts remain archival cross-checks
rather than proof routes.
This produces a shorter paper whose theorem chain is entirely human, at the
cost of giving up secondary strengthenings rather than replacing them by
several pages of small-field algebra.

There are two less attractive alternatives.

- A full replacement would need both a human exterior-arc theorem for the
  terminal fields and a human Hilbert-function argument for the low-degree
  and gap claims.  These are different problems, so solving them would add
  two proof mechanisms and work against the non-bloating requirement.
- A hybrid could retain the classification through eight points if a single
  short proposition proves that an arc whose chords are passant has size at
  most six for \(q=13,17,19\).  Until such a proposition exists, retaining
  the finite classification necessarily retains a load-bearing search.

The strongest concrete route toward that one-proposition hybrid is Segre's
lemma of tangents.  At a saturated endpoint \(q=2k-3\), let
\[
 S_P(X)=\prod_{\substack{\ell\ni P\\ \ell\text{ secant to }\mathcal C}}
 \ell(X).
\]
The saturation theorem says that \(S_P\) is exactly a tangent polynomial of
the \(k\)-arc at \(P\).  With \(t=q+2-k=(q+1)/2\), Segre's lemma forces, for
every distinct \(P,Q,R\in A\),
\[
 S_P(Q)S_Q(R)S_R(P)
 =(-1)^{t+1}S_P(R)S_R(Q)S_Q(P).
\]
Thus the \(q=11,k=7\) and \(q=13,k=8\) searches reduce to a signed
three-point compatibility problem intrinsic to the conic, rather than a
search over arcs.  A short spectral or two-graph bound for this compatibility
relation would be an admissible human replacement.  The ordinary
pair-association scheme cannot supply it: its \(q=13\) Delsarte bound permits
size eight.  The arc condition first appears in the displayed three-point
identity.

For the unsaturated cases, a second exact identity exposes the missing
mixed-type information.  If \(r_X\) is the number of chord lines through an
off-conic point \(X\), then
\[
 2\sum_{\substack{X\text{ external}\\\text{to }\mathcal C}}(r_X-1)
   =(q+1)\left(\binom{k}{2}-q\right).
\]
Indeed, on each tangent to \(\mathcal C\), the \(m=\binom{k}{2}\) chord
lines cover its \(q\) off-conic points, giving excess \(m-q\); summing over
the \(q+1\) tangents counts every external point twice and every internal
point zero times.  Combining this type-sensitive moment with Segre
compatibility is the most plausible human route for
\((7,13),(8,17),(8,19)\).  Neither identity alone excludes a terminal pair,
so neither belongs in the manuscript yet.

**Admission gate.**  Reintroduce a deleted strengthening only if one human
proposition replaces its whole exhaustive route and its proof fits in about
one manuscript page without a field-by-field matrix table.  Moving the same
enumeration into association-scheme or code language does not meet the gate.

## Vibe check

The geometry now has a clean human boundary theorem, but the desired human
terminal exclusion is genuinely still on the far side of that boundary.

## Extra-juice and Tao-style closeout

The `ej` pass added the polarity reconstruction above and the exact
five-entry excess table; both are free consequences that make the residual
geometry substantially easier to route.  The `tt` pass tested the strongest
plausible promotions: the general partial-cover theorem and its equality
case, the incidence-code distance bound, the complete-exterior-set
classification, and the full \(q=13\) elliptic association scheme.  None
excludes a terminal pair.  The scheme calculation is an instructive
one-unit near-miss, while importing the published small-\(q\) equality
census would merely replace one computation by another and would violate
C662's acceptance gate.  No further task-owned theorem follows cheaply
without solving one of the two support-classification problems recorded
next.

## Mystery ledger

- **Minimum-weight internal supports (not settled by `ej`+`tt`).**  Open at
  the human level needed
  here: classify arc-supported words of weight \((q+3)/2\) in the
  passant/internal nullspace, in particular for \(q=11,13\).  For
  \(q=13\), the complete elliptic-scheme LP bound is eight, so a strict
  improvement requires information beyond its pair distribution.
- **Near-minimum elliptic covers (not settled by `ej`+`tt`).**  Open at the
  required structural level:
  classify elliptic-line covers of a conic complement within a bounded
  excess of \(3(q-1)/2\), with the additional constraint that the lines are
  all chords of one arc.  The \((8,19)\) terminal case has excess one.
- **Segre tangent compatibility (reduced, not settled).**  In the saturation
  cases, the tangent
  polynomial at each arc point is the product of all conic-secants through
  that point.  Segre's lemma of tangents imposes a nontrivial compatibility
  condition, but this audit did not turn it into a support classification.

No successor ID is allocated.  The copy-pasteable continuation route is:

```text
go clebsch
```
