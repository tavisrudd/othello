# Relative-conic cold-read research frontier

**Lane:** `relconic`

**Date:** 2026-07-25

## Source and scope

Two independent cold readers read the complete current manuscript without
receiving prior reviews, intended answers, handoff history, or one another's
reports.  Each answered:

1. What questions does the paper beg?
2. What does it imply that one would next check or try to prove?
3. What strong mathematical connections does it miss or leave implicit?

This note records the consensus, separates cheap consequences from research
programs, and supplies stable entry points for the allocated successors.  An
item's presence here does not assert novelty or correctness beyond the theorem
statements already in the manuscript.

## Consensus

The readers independently identified the same central frontier.  The exact
defect does more than bound coverage: it turns equality into a rank-three
star--matching realization and small defect into an edge/vertex removal
statement for the bad-concurrence graph.  The next layer must therefore mix
matching compatibility with projective realizability.  Raw incidence moments
alone are already known to stop short.

The strongest underdeveloped connections were:

- rank-three matroid realization spaces, bracket algebra, characteristic sets,
  and universal partial fields;
- Johnson/Kneser association schemes, clique geometries, and design completion;
- completely regular or uniformly packed codes and Delsarte constraints on
  syndrome representation numbers;
- Hilbert functions, Veronese spans, separators, and finite-field
  Cayley--Bacharach phenomena;
- conic polarity and orthogonal association schemes; and
- six-point projective geometry as the first rank-three-sensitive layer behind
  a third secant moment.

The broad asymptotic question remains whether
\(\rho_{\mathcal C}(q)=\Theta(\sqrt q)\).  That is already the lane's governing
problem and is not duplicated as a new task below.

## Allocated research programs in expected-value order

### C625 — rank-three star--matching obstruction

Classify or obstruct rank-three realizations of the star--matching
pairwise-balanced design, with the surviving \((q,k)=(4096,92)\) equality
candidate as the first target.  Use matroid/bracket realization, conic polarity,
or a genuinely new global invariant.  Do not repeat the closed resolution,
binary-residue, tangent-spectrum, or quadratic/Arf gates from C556, C593, and
C596, and do not replace a structural argument by a broad finite census.

Entry report:
`notes/2026-07-25-c625-rank-three-star-matching-obstruction.md`.

### C626 — rank-three-sensitive third layer

Seek an inequality or invariant that detects projective compatibility among
concurrent triples of disjoint secants.  The raw statistic
\(\sum_x\binom{r(x)}3\) and its six-subset Gale transfer are already subordinate
to the defect by C555 and C592.  A successful result must retain bracket,
Brianchon, polarity, carrier, or square-restriction information that those
aggregates discard.  The handoff's unallocated square-restriction degeneracy
locus \(F_A|_{x^*}\in K[x_0,x_1]^2\) is an admissible first gate.

Entry report:
`notes/2026-07-25-c626-rank-three-sensitive-third-layer.md`.

### C627 — bad-concurrence removal and design completion

Starting from the checked edge and vertex-cover bounds, determine whether a
small-defect clique geometry can be completed or edited to a genuine
\(\operatorname{MATCH}(k,\lfloor k/2\rfloor,1)\) design or rank-three
realization.  The target output is a quantitative defect gap derived from
nonrealizability, or a precise falsifier showing why abstract removal/design
completion cannot preserve the geometric incidence data.  Do not reprove the
existing secant-deletion theorem.

Entry report:
`notes/2026-07-25-c627-bad-concurrence-design-completion.md`.

### C628 — uniform quadratic-hull obstruction

Recast the evaluation obstruction through Hilbert functions, Veronese spans,
and separators, then determine whether the \(q=16\) quadratic-avoidance theorem
extends structurally to other orders or degrees.  The unresolved
\(q=13,17,19\) lower-bound cases are bounded pilots, not a license for an
unstructured census.  Any paper-facing finite computation must satisfy the
repository reproducibility convention.

Entry report:
`notes/2026-07-25-c628-uniform-quadratic-hull-obstruction.md`.

## Cheap consequences retained in the current thread

The following are to be checked before deciding whether they belong in the
manuscript:

1. the discrete gap
   \(m\Delta_{\mathcal H}(A)=0\) or
   \(m\Delta_{\mathcal H}(A)\ge m-2\) for \(m\ge3\);
2. the exact even-\(k\) zero-defect spectrum for the line-hole/complete-affine
   specialization;
3. the odd-\(k\) conic equality formula and its first arithmetic sieve;
4. the equivalence between the hyperoval-scale equality branch and existence
   of a disjoint nonsingular conic;
5. the proposed forced tangent/bisecant/external secant split at
   \((q,k)=(4096,92)\); and
6. the exact parity-sensitive expansion of the integer threshold \(L_2(q)\),
   retained only if it improves the paper rather than adding algebraic bulk.

The open finite cases \(q=13,17,19\) move to C628 unless a cheap theorem settles
them without a classification computation.

## Cheap consequence outcomes

### 1. Discrete defect gap

Assume \(m\ge3\).  A positive required-point summand in the exact defect
identity has \(2\le r\le m-1\), hence
\[
 (r-1)(m-r)\ge m-2.
\]
A positive hole summand has \(1\le r\le m-1\), hence
\[
 r(m-r)\ge m-1.
\]
Therefore
\[
 m\Delta_{\mathcal H}(A)=0
 \quad\text{or}\quad
 m\Delta_{\mathcal H}(A)\ge m-2.
\]
This is a direct corollary of the existing quantitative-stability proof and
costs one sentence in the manuscript.

### 2. Complete-affine equality spectrum

Let \(k\ge6\) be even and \(m=k/2\).  If a complete affine \(k\)-arc attains
equality in the line-hole bound, then its zero-defect equation is
\[
 q^2-k
 =\binom{k}{2}(q-1)
  -\frac6m\binom{k}{4}
  -\frac1m\binom{k}{2}.
\]
The corresponding quadratic factors as
\[
 \bigl(q-(k-2)\bigr)
 \left(q-\left(\binom{k-1}{2}+1\right)\right)=0.
\]
Thus
\[
 q\in\left\{k-2,\binom{k-1}{2}+1\right\}.
\]
The middle value from the conic-hole spectrum is absent because every secant
has exactly one ideal point, so the ideal incidence is fixed rather than
variable.

### 3. Odd-size conic equality spectrum

Let \(k\ge7\) be odd, put \(Q=k-1\), \(m=Q/2\), and let
\[
 s=\bigl|\{y\in\mathcal C:r(y)=m\}\bigr|.
\]
Zero defect and relative completeness give
\[
 s=-q^2+\frac{k(k-1)}2q-\frac{k(k-1)(k-3)}2.
\]
Put
\[
 R=\binom{Q}{2}-1.
\]
The formula has the useful form
\[
 s=q-(q-Q)(q-R).
\]
The arc bound gives \(q\ge Q-1\), while the value at \(Q-1\) is negative for
\(Q\ge6\), so \(q\ge Q\).  If \(Q\le q\le R\), the constraint
\(s\le q+1\) gives
\[
 (q-Q)(R-q)\le1.
\]
Since \(R-Q>2\) for \(Q\ge6\), this forces \(q=Q\) or \(q=R\).  If
\(q=R+t\) with \(t\ge1\), then
\[
 s=q-t(q-Q).
\]
The case \(t=1\) is allowed and gives \(s=Q\); for \(t\ge2\), nonnegativity
would imply \(q\le2Q\), contradicting \(q\ge R+2>2Q\).  Hence
\[
 q\in
 \left\{
   k-1,\ \binom{k-1}{2}-1,\ \binom{k-1}{2}
 \right\}.
\]
The corresponding values of \(s\) are respectively
\[
 q,\qquad q,\qquad k-1.
\]

### 4. Characteristic-two geometry of the first branches

In the odd spectrum, suppose \(q=2^n\).  The value
\(\binom Q2\) cannot be a power of two for even \(Q\ge6\), since the coprime
factors \(Q/2\) and \(Q-1>1\) would both have to be powers of two.  For the
remaining large candidate
\[
 2^n=\binom Q2-1,
\]
write \(Q=2a\) and \(x=4a-1\).  Then
\[
 (x-3)(x+3)=2^{n+3}.
\]
The two positive powers of two differ by \(6\), so they would have to be
\(2\) and \(8\), giving \(x=5\), incompatible with integral \(a\).  Thus
only
\[
 q=Q=k-1
\]
remains.

In \(\mathrm{PG}(2,q)\), the resulting \(q+1\)-arc is an oval.  Its nucleus
is the unique external point of secant index zero; every other external point
has index \(q/2=m\).  Since \(s=q\), a zero-defect prescribed conic contains
the oval nucleus.  Conversely, an oval disjoint from a nonsingular conic that
contains its nucleus is automatically complete outside that conic and has zero
defect.

The even first branch is parallel: a \((q+2)\)-arc is a hyperoval, every
external point has index \((q+2)/2\), and every nonsingular conic disjoint from
it gives a zero-defect relative-complete pair.

### 5. Forced secant types at \((q,k)=(4096,92)\)

Here \(m=46\), and the even equality spectrum gives exactly \(91\) conic
points of index \(46\).  Therefore
\[
 I_{\mathcal C}(A)=91\cdot46=\binom{92}{2}=4186.
\]
Let \(\nu\) be the conic nucleus.  If \(\nu\in A\), the nucleus-in parity
theorem gives
\(I_{\mathcal C}(A)\equiv91\pmod2\), contradicting the displayed even value.
Thus \(\nu\notin A\).  The nucleus-out theorem and zero defect give
\(r(\nu)\in\{1,46\}\), while
\[
 I_{\mathcal C}(A)\equiv r(\nu)\pmod2
\]
forces \(r(\nu)=46\).  Hence exactly \(46\) arc secants are tangent to
\(\mathcal C\).

If \(T,B,E\) denote the numbers of tangent, bisecant, and external arc
secants relative to \(\mathcal C\), then
\[
 T=46,\qquad T+2B=I_{\mathcal C}(A)=4186,\qquad T+B+E=4186.
\]
Consequently
\[
 (T,B,E)=(46,2070,2070).
\]
This is a genuine new restriction on the sole non-hyperoval
characteristic-two equality candidate.

### 6. Items not promoted by the cheap pass

The exact parity-sensitive expansion of \(L_2(q)\) is algebraically available
but does not change the leading constant or close a branch.  It should not
displace conceptual material.  The finite cases \(q=13,17,19\) require
classification or evaluation-rank computation and remain assigned to C628.

## Manuscript decision gate

An item earns space in Version 1 only if it does at least one of the following:

- strengthens a displayed theorem at negligible proof cost;
- closes a visible logical branch, especially the affine, odd-\(k\), hyperoval,
  or \((4096,92)\) branch;
- materially clarifies the mechanism behind defect stability; or
- changes the reader's view of the main theorem without enlarging the trust
  surface.

Any addition must identify what it displaces.  Likely displacement candidates
are repeated prose summaries of the defect mechanism, secondary exact-value
commentary, or coarse asymptotic algebra superseded by a sharper compact
statement.  The main identity, matching-design theorem, ten-point realization
classification, \(q=16\) theorem, verification boundary, and reconstruction
theorem are not displacement candidates.

## Manuscript adoption decision

The cheap pass promoted five consequences into the paper:

1. the discrete defect gap;
2. the two complete-affine equality roots;
3. the full odd-size conic equality spectrum;
4. the characteristic-two oval/hyperoval interpretation; and
5. the forced tangent/bisecant/external split at \((4096,92)\).

They strengthen or close branches already visible in the manuscript and use
only analytic consequences of existing results.  The proof audit now says
explicitly that these are paper proofs, not new Lean terminals; the
\((4096,92)\) split uses the already formalized nucleus propositions.

No theorem should be displaced.  The additions increase the compiled draft
from 22 to 24 pages, but replacing any main result would reduce the paper's
logical value more than it saves.  If a hard 22-page limit later applies, cut
or compress repeated explanatory prose and secondary exact-value commentary
before moving any of these five consequences.  The parity-sensitive
\(L_2(q)\) expansion and the \(q=13,17,19\) pilots were not promoted.

## Administrative note

The first allocator call returned C621--C624 because the live queue already
contained foreign-lane rows with those numbers that had not been recorded in
the allocation ledger.  Those foreign rows were left untouched.  The relconic
successors use the fresh replacement block C625--C628.  Resolving the preexisting
C621--C624 queue/ledger inconsistency belongs to the queue coordinator and must
not be handled by silently re-pegging either lane.
