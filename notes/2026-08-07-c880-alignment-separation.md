# 2026-08-07 — C880: the seven-point hypothesis is sharp, and thirty alignment tests are optimal there

**Task:** C880 (lane `clebsch`), work items 1, 2 and 4 of
`notes/clebsch-tasks/c880-aligned-query-complexity.md`, the part of item 3 that
the small cases decide, and the positioning that follows from the literature
audit in `notes/2026-08-07-c880-literature-audit.md`. Research and computation
only; no manuscript file is touched, and item 7 is not drafted here.

## What is settled

1. **Six points is not enough, and not only for the degenerate reason.** The
   full family of alignment tests fails to determine a two-graph up to
   complement on four, five and six points, and determines it on seven. At six
   points the failure survives well away from the empty-family case: of the 512
   complement pairs, 96 share their aligned family with another pair, and only 6
   of those have no aligned four-set at all. So the manuscript's hypothesis
   \(|V|\ge7\) in `thm:aligned-faithfulness` is sharp, and there is a witness
   pair to cite that has aligned four-sets.
2. **At seven points the minimum is thirty of the thirty-five tests.** No family
   of twenty-nine alignment tests determines a two-graph on seven points up to
   complement, and several families of thirty do. This is exact, and it was
   computed twice by different methods, plus a third time in an independent
   replay.
3. **The manuscript's selected family is one test above that optimum at seven
   points, and the redundant member is the anchor's own test.** The family of
   four-sets meeting the anchor in at least two points has \(3n^2-23n+45=31\)
   members at \(n=7\); dropping the test on the anchor itself leaves 30, which
   is optimal. The same drop is valid at eight points.
4. **At eight points the manuscript's family is not optimal, and the bracket is
   \(25\le\mathrm{minimum}(8)\le44\).** Iterated local search finds a
   separating family of 44 tests where the anchor family uses 53; the lower end
   is an entropy bound proved in section 5, which improves on the counting bound
   20 at every \(n\). The exact value at eight points is open: the
   small-difference method that settles seven points exactly is vacuous there.
5. **The scenario has no published competitor, and should not be sold as an
   algorithm.** No located source reconstructs from an indicator family of fixed
   order minors, so there is no state of the art for this oracle; but the
   natural switching-invariant observable is the triple rather than the
   four-set, and the triples through one fixed point already solve the problem
   at the optimum. Section 7 sets out the positioning that follows: a rigidity
   and redundancy result about the aligned design, with the coherence price as
   robustness, not a query-complexity contribution.
6. **Adaptivity strictly helps, and the coherence restriction is cheap.** A
   greedy adaptive decoder finishes in 22 questions at seven points against the
   proved nonadaptive minimum of 30, which is a separation; at eight points it
   finishes in 30 against a nonadaptive bracket of 25 to 44. Measured against
   the value oracle's optimum — the two-graph dimension \(\binom{n-1}2\), which
   order-three minor values achieve with no waste — the adaptive worst case
   costs 1.47 and 1.43 and the mean costs 1.041 and 1.043.
7. **Where the coarsening pays is space and estimation, not queries.** The
   aligned design compresses from \(\binom n4\) entries to a determining
   \(3n^2-23n+45\) by projection onto a subset of coordinates; and because the
   closed four-walk weight of a four-set is 24 when aligned and \(-8\)
   otherwise, the aligned density is a reparametrization of the fourth spectral
   moment, estimable from \(O(\varepsilon^{-2})\) sampled four-sets in
   \(O(\log n)\) space without forming the matrix. Section 8 gives the measured
   count distribution that decides what such an estimator can separate.
8. **The alignment code's minimum distance jumps from two to four.** At seven
   points there are pairs of two-graphs whose aligned families differ in exactly
   two four-sets — 315 difference patterns, which is what makes the exact bound
   at seven points possible — and at eight points there are none of weight two,
   none of weight three, and 315 of weight four. Odd weights are absent at both,
   consistent with C810's even distance spectrum.

The reading to carry forward: the seven-point near-optimality of the exhibited
family is a small-case fact, not evidence about the constant 3. At seven points
the whole test set has only 35 members and any separating family needs 30 of
them, so a construction of size 31 could hardly be far off. At eight points the
same construction is nine tests above what a search achieves, and the ratio
between the best lower bound and the exhibited \(3n^2-23n+45\) still tends to
4.87. Work item 3 therefore stands untouched by these two cases,
and needs either a structural lower bound or a better construction.

The second reading, which took the literature audit to see: the interest of this
material is not that it counts queries well. Against a value oracle the same
reconstruction is already exactly optimal, and our oracle is deliberately
weaker. What survives is a rigidity and redundancy statement about the
determinant-minus-three design, a measurement of what the coherence restriction
costs — about four percent on average — and one setting, sublinear estimation of
a spectral moment, in which the four-set probe is the natural unit of work
rather than a handicap. Sections 7 and 8 develop that, and it is the framing the
manuscript should inherit.

## Conventions

Points are \(0,\dots,n-1\). A two-graph is a map \(\tau\) from 3-subsets to
\(\mathbf F_2\) whose sum over the four triples of any 4-subset is even;
equivalently the switching class of a graph \(G\), with \(\tau(abc)\) the parity
of the number of edges of \(G\) inside \(\{a,b,c\}\). Every switching class has
exactly one representative graph in which the point 0 is isolated, so switching
classes are indexed by the \(2^{\binom{n-1}2}\) graphs on \(1,\dots,n-1\), and
the complementary two-graph \(\tau+1\) is the complement of that graph.

A 4-subset is **aligned** when its four triples carry equal \(\tau\) values; the
**alignment test** on that 4-subset returns that one bit. Alignment is invariant
under the global complement, so the object being reconstructed is a complement
pair, and the **alignment vector** of a two-graph is the \(\binom n4\)-bit word
of all its tests. A set of tests **separates** when distinct complement pairs
keep distinct projections onto it; the minimum size of a separating set is the
nonadaptive query complexity, and the counting lower bound is
\(\lceil\log_2(\text{number of complement pairs})\rceil = \binom n2-n\).

## 1. The point threshold

| \(n\) | switching classes | complement pairs | tests | distinct alignment vectors | colliding groups | pairs in a collision | pairs with empty aligned family |
|-------|-------------------|------------------|-------|----------------------------|------------------|----------------------|---------------------------------|
| 4     | 8                 | 4                | 1     | 2                          | 1                | 3                    | 3                               |
| 5     | 64                | 32               | 5     | 17                         | 6                | 21                   | 6                               |
| 6     | 1024              | 512              | 15    | 462                        | 46               | 96                   | 6                               |
| 7     | 32768             | 16384            | 35    | 16384                      | 0                | 0                    | 0                               |

At seven points every complement pair has its own alignment vector, which is the
manuscript's theorem, and no two-graph has an empty aligned family, which is the
computational form of `exists_distinct_alignedAnchor`. At six points 46 groups
of pairs collide; exactly one of those groups is the six pairs with no aligned
four-set at all, so 45 groups are collisions between two-graphs that do have
aligned four-sets.

**Witness for the manuscript.** Two two-graphs on \(\{0,\dots,5\}\), neither the
complement of the other, both with aligned family exactly
\(\{\{0,1,2,5\},\{0,1,3,4\}\}\): take the graphs on \(\{1,\dots,5\}\) with the
point 0 isolated and edge sets
\[
  \{12,\,15,\,24,\,25,\,35\}
  \qquad\text{and}\qquad
  \{13,\,14,\,24,\,34,\,35\},
\]
whose two-graphs are distinct and non-complementary. Both are verified against
the four-set parity law directly.

## 2. The exact minimum at seven points

Removability is downward closed: if a set of tests can be deleted and the rest
still separates, so can any subset of it. Level-wise enumeration therefore sees
every removable set.

| tests removed | families that still separate |
|---------------|------------------------------|
| 1             | 35                           |
| 2             | 280                          |
| 3             | 560                          |
| 4             | 280                          |
| 5             | 56                           |
| 6             | 0                            |

So the minimum is \(35-5=30\), and there are exactly 56 optimal families. They
fall into two orbits under the symmetric group on the seven points, and both are
local:

- **21 families** — delete the five 4-subsets of a fixed five-point subset.
  Equivalently, keep exactly the tests meeting a fixed pair of points.
- **35 families** — delete the four 4-subsets containing a fixed triple \(T\)
  together with the 4-subset \(V\setminus T\) complementary to it.

Each of the 280 removable 4-sets lies in exactly one removable 5-set
(\(56\times5=280\)), so any separating family of 31 tests has exactly one further
redundant member.

## 3. The manuscript's selected family

For the anchor \(Q=\{0,1,2,3\}\), the selected family — every 4-subset meeting
\(Q\) in at least two points — has \(3n^2-23n+45\) members, and it separates
unconditionally, with no promise that \(Q\) is aligned. At seven points its
complement is \(\{(V\setminus Q)\cup\{a\} : a\in Q\}\), which is the star of the
triple \(V\setminus Q\); the unique way to extend that to a removable 5-set is by
the complementary 4-subset of that triple, which is \(Q\) itself. Hence:

> At seven points, the manuscript's selected family minus the test on the anchor
> is an optimal separating family, and the anchor's own test is the only
> redundant member of it.

That drop is not a seven-point accident: at eight points the family of 53 also
still separates after the anchor test is removed.  In the unconditional problem measured here the anchor's own
answer is an ordinary informative bit, so its redundancy is a measured fact
rather than a consequence of the promise; the promised-anchor variant is a
different, smaller problem.

At eight points, greedy stripping removes eight of the 53 tests — the anchor
\(\{0,1,2,3\}\) and seven others — and the remaining 45 still separate all
\(2^{20}\) complement pairs.

## 4. Bounds at eight points

At eight points there are 1,048,576 complement pairs and 70 tests. The
manuscript's family has 53 members, greedy stripping under twenty-three
different orders reaches 45, iterated local search reaches 44, and the entropy
bound of section 5 gives 25. So

\[
  25 \;\le\; \mathrm{minimum}(8) \;\le\; 44 \;<\; 53 = 3n^2-23n+45.
\]

The exact value is open, and the method that closes seven points cannot close
this one. At seven points the bound comes from pairs of two-graphs whose
alignment vectors differ in exactly two coordinates: those 315 patterns force
one of their two tests into every separating family, and the largest set of
tests containing no such pair has size 5, which gives \(35-5=30\) — tight. At
eight points a pigeonhole neighbour search over all pairs finds no difference of
weight two or three at all and exactly 315 of weight four, and 315 four-element
constraints on 70 tests leave a mask-free set of at least 40, so that route
yields nothing above the counting bound, and nothing above the entropy bound
either. The weight scan itself is complete through
weight four, which is what licenses the flat statement that no difference of
weight two or three exists; it is the *mask-free* search over those 315
constraints that was capped and did not complete, and an incomplete search would
only overstate the bound, so its value is discarded rather than reported.

The 44 is an upper bound with a witness family recorded in the certificate; it
is not claimed optimal.

**Superseded, same day.** The capped search was replaced by an exact integer
program: the minimum hitting set of those 315 constraints is exactly 30, the
mask-free set of 40 is maximum, and the bracket is
\(30\le\mathrm{minimum}(8)\le44\). The masks turn out to be the evenly crossing
pairs of four-four splits of the eight points, which are the seven-point
weight-two masks in disguise, and their hitting number is 35 minus the largest
partial spread of \(\mathrm{PG}(3,2)\). Every eight-point statement below that
uses 25 as the lower end is superseded by
`notes/2026-08-07-c880-mask-ilp-bound.md`; the entropy bound itself is unchanged
and remains the only bound that grows with \(n\).


## 5. A sharper lower bound, and what forces the constant

**Every alignment test answers yes with probability exactly one quarter.** The
restriction of a two-graph to any four points is uniform over the eight
two-graphs on four points, of which two — all triples coherent, all triples
incoherent — are aligned. The measured marginal over all two-graphs is
0.250000 at seven and at eight points. Hence, if the answers on a family of
\(k\) tests determine the two-graph up to complement,
\[
  \binom{n-1}2-1 \;=\; H(\tau) \;\le\; H(A_1,\dots,A_k)
  \;\le\; \sum_i H(A_i) \;=\; k\,H(1/4),
\]
so
\[
  k \;\ge\; \frac{\binom{n-1}2-1}{H(1/4)} \;=\; 1.2326\left(\binom{n-1}2-1\right)
  \;\approx\; 0.616\,n^2 .
\]
This beats the counting bound by the same factor everywhere: 18 rather than 14 at
seven points, and 25 rather than 20 at eight, which tightens the eight-point
bracket to \(25\le\mathrm{minimum}(8)\le\) 44. Against the exhibited
\(3n^2-23n+45\) the remaining asymptotic gap is a factor of 4.87 rather than 6.

**What a single test can possibly notice.** The elementary perturbation
\(\delta_{xy}\) adds 1 to \(\tau(xyz)\) for every \(z\); it is a two-graph
perturbation, and only tests containing both \(x\) and \(y\) can see it. The
test on \(\{p,q,x,y\}\) sees it exactly when \(\tau(pxy)=\tau(qxy)\): the two
triples through the pair flip together, and the other two triples decide whether
alignment was possible at all. Writing \(\chi(p)=\tau(pxy)\), which the
adversary may choose to be any two-colouring of the remaining \(n-2\) points,
the family detects \(\delta_{xy}\) at every two-graph if and only if the **link
graph** \(H_{xy}=\{pq : \{p,q,x,y\}\in S\}\) admits no proper two-colouring.

> **Necessary condition.** In any separating family, every link graph is
> non-bipartite.

That is the precise form of the obstacle the task card names: a "no" answer is
uninformative exactly when the colouring is proper, and only an odd cycle in the
link rules that out at every two-graph. It also explains the manuscript's
construction, which gives every outside pair the complete graph on the four
anchor points as its link — \(K_4\) being the obvious non-bipartite choice.

**Non-bipartite links are not sufficient, and \(K_4\) is not slack.** The
triangle-anchor family — every 4-set meeting a fixed triple in at least two
points — has every link non-bipartite and fails to separate, at seven points (22
tests) and at eight (35 tests). Sweeping all 64 subgraphs \(R\) of the anchor's
link, with the family taken to be the tests meeting the anchor in three or four
points together with the two-point tests whose anchor pair lies in \(R\): at
seven and at eight points the only \(R\) that separates is the complete \(K_4\).
Its non-bipartite proper subgraphs — a triangle, a triangle with a pendant edge,
and \(K_4\) minus an edge — all fail. So the six tests per outside pair are
forced within the single-anchor shape at both sizes, and the constant 3 is not
loose there.

**Where the slack must be instead.** The manuscript's family shares nothing
between outside pairs: a test \(\{p,q,x,y\}\) with \(p,q\) in the anchor serves
only the pair \(\{x,y\}\) as a link edge, while a test whose four points are all
outside the anchor serves six pairs at once. Any construction below \(3n^2\)
must share, and eight points confirm the slack is real: iterated local search
finds a separating family of 44 tests where the anchor family needs 53.
Its links are smaller than the anchor family's — the smallest link has four
edges rather than six, and the mean is 9.43 against 11.36 — which is what
sharing looks like.

**Adaptivity is the obvious place to look next, and the sensitivity rule says
why.** One test settles one new coordinate provided a reference point already
known to satisfy \(\tau(pxy)=\tau(qxy)\) is available, and a decoder that has
already recovered part of the two-graph can choose that reference. That suggests
an adaptive decoder needing about \(\binom{n-1}2\) tests, a factor of six below
the nonadaptive construction. This is a sketch, not a result: the cases where no
such reference exists need a fallback. **The entropy bound above is nonadaptive
only.** Subadditivity uses the unconditional quarter marginal of a fixed test,
and an adaptive decoder chooses each test to split the survivors evenly, driving
the conditional marginal towards a half and the per-question entropy towards one
full bit. Against adaptive decoders the floor falls back to the counting bound,
\(\binom{n-1}2-1\) — 14 at seven points and 20 at eight.

## 6. The price of the coherence restriction, and adaptivity

The audit (`notes/2026-08-07-c880-literature-audit.md`) establishes that the
principal-minor literature reconstructs the same object up to the same gauge, so
there is a benchmark to measure against: the two-graph has dimension
\(\binom n2-n+1=\binom{n-1}2\), and for a Seidel matrix that many order-three
minor *values* achieve it, one bit of information per query with no waste. The
question this task should answer is therefore not "how many tests" but **what
the coherence restriction costs**, where the decoder is denied the values and
the order-three data and gets one bit per four-set instead.

A greedy adaptive decoder — at each step ask the test splitting the surviving
candidates most evenly — answers that.

| \(n\) | dimension, and the value-oracle optimum | entropy bound | greedy adaptive, worst case | greedy adaptive, mean | nonadaptive minimum | the manuscript's family |
|---|---|---|---|---|---|---|
| 7 | 15 | 18 | 22 | 15.61 | 30 | 31 |
| 8 | 21 | 25 | 30 | 21.90 | 25 to 44 | 53 |

Three readings, in increasing order of interest.

**Adaptivity strictly helps, and at seven points that is proved.** The
nonadaptive minimum there is exactly 30, and an adaptive decoder finishes in 22
questions in the worst case, so no nonadaptive family can match adaptive
behaviour. At eight points the greedy adaptive worst case is 30 against a
nonadaptive bracket of 25 to 44, which is consistent with a separation but does
not establish one.

**The worst-case price of the restriction is under a half.** Adaptive worst case
against the value-oracle optimum is \(22/15=1.47\) at seven points and
\(30/21=1.43\) at eight — against the manuscript family's factor of six
asymptotically, and the nonadaptive minimum's factor of two at seven points.

**The average price is at most about four percent, and its sign is not
established.** The mean number of coherence questions is 15.61 against 15, and
21.90 against 21 — ratios 1.041 and 1.043. But the greedy mean is an upper bound
on the optimal adaptive mean, whose floor is the counting bound 14, so at seven
points the true mean price lies somewhere in \([14/15,\,15.61/15]\), between
about \(-7\%\) and \(+4\%\). It could be negative, and there is a reason to
think it might be: the alignment bit is complement-invariant while a value bit
spends part of itself on the gauge. Any complement-invariant one-bit oracle has
floor \(\binom{n-1}2-1\), one below the triple oracle's \(\binom{n-1}2\), so
a saving of exactly one query is available to the coarser observable by
definition. Whether a decoder can realize it on average is open, and settling it
would be the most striking sentence this material could carry. To our knowledge
no such comparison has been made, the model not having been defined before; the
audit's negative for this cluster is bounded by the sources it could not
obtain.

Two cautions on that table. The greedy tree is an upper bound on the adaptive
optimum, not the optimum. And the entropy bound column is a **nonadaptive** floor
only, for the reason given at the end of section 5; the valid adaptive floor is
the counting bound, 14 and 20. The value-oracle optimum of 15 and 21 is exact
even adaptively: after any \(\binom{n-1}2-1\) independent triple values the two
survivors lie in distinct complement pairs, since the all-ones two-graph vanishes
on no triple, so one further query is forced and value queries cannot exploit the
complement quotient.

## 7. What this scenario is, and what it is not

The audit settles where this work sits, and it is worth writing the position
down before any of it reaches the manuscript, because the natural reading of a
query count is a claim about an algorithm and that is not what these numbers
are.

**There is no published state of the art for this oracle.** No located source
reconstructs from an indicator family of fixed-order minors. The nearest
published work misses in four different directions: principal-minor assignment
recovers the same object up to the same gauge but from minor *values*;
Dammak, Lopez, Pouzet and Si Kaddour query the same four-point locality but
receive the whole induced isomorphism type up to complementation and never
minimize a query count; Greaves and Suda describe the same design without
reconstructing anything; and higher-order group synchronization puts
measurements on hyperedges but they are group-ratio tuples. Being the only
entrant in a model is not a result, and the negative is bounded by the access
gaps the audit records.

**The natural gauge-invariant primitive is the triple, not the four-set, and it
is already optimal.** Switching changes individual Seidel signs, so those are
not observable in principle — but \(\tau(abc)\) is switching-invariant, and in
signed-graph language it is exactly the balance bit of the triangle. The
manuscript's own proof displays the identity
\(\tau(ijk)=\tau(rij)+\tau(rik)+\tau(rjk)\), so the triples through a single
fixed point — exactly \(\binom{n-1}2\) of them, the dimension — determine the
two-graph outright, with one bit of information per query and no waste. Any
setting in which "only local coherence is measurable" therefore hands the
decoder triangle coherence and is solved at the optimum immediately. The
four-set alignment test is a strict coarsening of that, and for the coarser
oracle to be the primitive one would need a probe that responds to four-point
coherence and not to three-point coherence. The lane knows no reason why
anything would. This paragraph is an argument, not a measurement; item 8 of the
task card is what would settle it, and it is unrun.

**So the query count should not be presented as an algorithmic contribution.**
Read as an algorithm against a value oracle, the work is pre-empted by
construction: the state of the art is already exactly optimal, and our own
oracle is deliberately weaker. Read as an applications claim it would need a
setting nobody has exhibited.

**Read as rigidity and redundancy of the aligned design, none of that applies.**
The aligned family is the Greaves and Suda determinant-minus-three design, which
the paper's geometry hands over as an object rather than as a measurement
protocol. The natural questions about a determining set are then whether it
determines, from what size, and how much of it is redundant — and every number
in this report answers one of those: the design determines the two-graph from
seven points, six points genuinely fails and not only in the empty-family case,
exactly 30 of its 35 members are needed at seven points, the optimal deletions
form two named orbits, and within the anchor construction the complete \(K_4\)
link is forced. None of this depends on anyone measuring anything.

**The coherence price is then a robustness statement, and it reads better
backwards.** Since the triple is the natural observable, the four percent of
section 6 says that being forced down from triple data to four-set coherence —
by noise, by censoring, or by an apparatus that reports only whether a small
subsystem is coherent — costs about four percent on average and under a half in
the worst case. That is a statement about how much the coarser design still
carries, and it is true whether or not any such apparatus exists.

**Recommended framing for the manuscript**, subject to C816 and C824, who own
promotion: a rigidity and redundancy result about the aligned design, with the
coherence-restriction price as a robustness remark, and a plain sentence saying
that no setting is known whose primitive observation is a four-set alignment
test. That is what the evidence supports, and it is also where the audit's three
required wording changes were already pointing.

## 8. Where a coarsening could actually pay: space and estimation, not queries

Section 7 argues the four-set oracle is a coarsening of a triple oracle that is
already optimal, which forecloses any saving in *query count* — entropy forbids
a coarser observable from beating a finer one at exact recovery. If the
coarsening pays anywhere it pays somewhere else, and there are three places.

### 8.1 It is the invariant of a larger group, and that is a proof, not a prior

The triple statistic \(\tau(abc)\) is switching-invariant but not
complement-invariant: complementing the two-graph flips every triple. The
four-set alignment bit is invariant under both. So for \(\lvert V\rvert\ge7\) the aligned family is
precisely the invariant of the group generated by Seidel switching and global
complementation — at six points section 1's collisions show it is not a complete
invariant — which is exactly the equivalence the reconstruction theorem
works modulo. Anything needing a canonical fingerprint for that class reads it
off the aligned design natively, while a triple-based fingerprint must first fix
a global sign. This is the one respect in which the four-set observable is not
merely a lossy version of the three-set one, and it is settled by the definition
rather than by a search for applications.

### 8.2 Space: the design compresses from quartic to quadratic, by projection

The aligned design has \(\binom n4\) entries, and this task shows it is
determined by a designated \(3n^2-23n+45\) of them, with no determining set
smaller than about \(0.616\,n^2\). The compression is by *projection onto a
subset of coordinates*, not by an arbitrary encoding, which is what makes it
usable: a verifier can store the sub-design, recover the two-graph from it, and
expand any other entry on demand. Nothing here measures decode time; the
certificates measure separation only.

| \(n\) | \(\binom n4\) | determining family | entropy floor | ratio |
|---|---|---|---|---|
| 7 | 35 | 31 | 18 | 1.13 |
| 8 | 70 | 53 | 25 | 1.32 |
| 9 | 126 | 81 | 34 | 1.56 |
| 16 | 1820 | 445 | 129 | 4.09 |
| 32 | 35960 | 2381 | 572 | 15.10 |
| 64 | 635376 | 10861 | 2407 | 58.50 |

The ratio is \(\Theta(n^2)\) asymptotically and negligible at the sizes this
report computes exactly, which is worth saying plainly: the compression is real
but it is an asymptotic statement, and nothing here verifies it above eight
points.

### 8.3 Estimation: the aligned density is a constant-space probe of the fourth
spectral moment

This is the direction with an actual sublinear algorithm behind it. The lane
already proved (`notes/2026-08-06-c815-fourth-trace-and-swap-descent.md`) that
the closed four-walk weight of a four-set is \(24\) when it is aligned and
\(-8\) when it is not, so \(\operatorname{tr}(A^4)\) is an affine function of the
number of aligned four-sets. The aligned density is therefore a
reparametrization of the fourth spectral moment of the Seidel matrix — and it is
estimable by sampling.

Draw a uniform four-set and ask whether it is aligned. That is one Bernoulli
draw whose mean is the two-graph's aligned density, and the draws are cheap and
need \(O(\log n)\) space, never forming the matrix. **But the sample complexity
is not constant.** The four-set term enters \(\operatorname{tr}(A^4)\) scaled by
\(\binom n4\) and centred at the quarter mean, so an additive error
\(\varepsilon\) in the density is an error of order \(\varepsilon n^4\) in the
moment, against a typical moment of order \(n^3\). Relative-error estimation of
the fourth moment therefore needs \(\Theta(n^2)\) samples, the same order as
reconstruction. What survives is the space saving — \(O(\log n)\) working space
against the \(O(n^2)\) of forming the matrix — and the resolution limit is
explicit: the estimator sees deviations of order \(n^4\) in the moment, which is
the scale of \(\Theta(n)\) eigenvalues.

The draws are also **pairwise independent**, which is why the population variance
of the aligned count is exactly the independent-trials value \(3\binom n4/16\):
6.5625 and 13.125, matching the measured standard deviations 2.5617 and 3.6228 to
every digit recorded.

What the estimator can and cannot do is decided by the spread of the density
across two-graphs, which this report measures exactly:

| \(n\) | four-sets | mean aligned count | \(\binom n4/4\) | standard deviation | range | distinct values |
|---|---|---|---|---|---|---|
| 7 | 35 | 8.7500 | 8.75 | 2.5617 | 5 to 35 | 9 |
| 8 | 70 | 17.5000 | 17.50 | 3.6228 | 10 to 70 | 29 |

The mean is exactly a quarter of the four-sets, which is the marginal of section
5 seen a second way. The relative spread is 0.29 and 0.21 and falling, so for
large \(n\) almost every two-graph sits at density one quarter: the statistic
carries almost nothing about *which* two-graph one has, and is correspondingly
sharp as a test for *atypicality*. The extremes are the structured objects — the
complete two-graph attains every four-set, and conference-like two-graphs sit at
the bottom of the range, the order-six conference having no aligned four-set at
all. **That last reading does not survive to large \(n\).** The aligned
four-sets of a symmetric conference matrix form a \(3\text-(2d,4,(d-3)/2)\)
design, whose density is \(\lambda/(v-3)=\tfrac14\bigl(1-\Theta(1/n)\bigr)\):
a conference two-graph sits \(\Theta(n)\) population standard deviations below
the mean and yet needs \(\Theta(n^2)\) samples to tell apart from a generic one,
because the gap itself shrinks. Sampled coherence is a sharp test for
atypicality only at the small sizes computed here; asymptotically it is not a
shortcut to detecting regularity, and the surviving payoff of this section is the
space bound, not a sublinear tester.

### 8.4 Candidate settings, ranked by how much they would need to be true

Local four-point coherence as a primitive observation is not exotic in every
field. Ranked by plausibility rather than by appeal: a tetrahedral plaquette in
frustrated magnetism, where the unit cell is four sites and the natural local
question is whether its faces agree, is the closest physical analogue and has
the right arity for the wrong reason — the standard local rule there constrains
site spins, not face frustration. Quartet methods in phylogenetics have the
arity and an uninformative-answer phenomenon of their own, but the audit records
the analogy as formal. The lane's own golden-operator material remains the one
candidate where a four-set alignment test might be a realizable measurement, and
costing it is work item 8. None of these is claimed; they are what item 8 should
examine, and the prior remains that no setting has this oracle.

## Mystery ledger

Required by the task card's acceptance list. What the closeout pass settled is
recorded above; these are the surprises it did not.

| open item | what is surprising | evidence gap or owner |
|---|---|---|
| The 315-to-315 coincidence | Weight-two difference patterns at seven points number 315; weight-four patterns at eight points also number 315 — the same count at consecutive sizes for different weights. | A lifting mechanism, each seven-point weight-two pair extending through the added point, is finitely checkable and would seed the structural lower bound that item 3 wants. Unchecked. |
| Parity of the aligned count | At seven points the count is always odd, supported on 5, 7, 9, 11, 13, 17, 19, 25, 35; at eight points both parities occur. | A mod-two invariant at \(n\equiv3\pmod4\), or an accident of the size. Settled by computing the histogram at nine points, which the current enumeration cannot reach. |
| Near-palindromic removability levels | 35, 280, 560, 280, 56 almost mirrors and does not, and 280 occurs at two different levels. | Orbit counting under the symmetric group should explain it; not attempted. |
| Gaps in the seven-point histogram | No two-graph has exactly 15, 21 or 23 aligned four-sets, and the upper tail takes the shape 210, 105, 21, 1. | The tail values look like orbit sizes; an orbit-counting explanation is the obvious candidate and is not attempted. |
| Sign of the coherence price | Whether the coherence oracle costs more or less than the value oracle on average is open, and the one-query floor gap says less is possible. | Needs the optimal adaptive mean at seven points, or any decoder beating mean 15. A lookahead search would settle it cheaply. |

## What this certifies, and what it does not

- The threshold and the seven-point minimum are exhaustive statements over all
  two-graphs on the stated point sets. They say nothing about \(n\ge9\).
- The exact minima of sections 2 and 4 are **nonadaptive**, over families fixed
  in advance. Section 6 measures an adaptive decoder separately; its worst case
  is an upper bound from a greedy rule, not the adaptive optimum.
- Separation is unconditional: no promise that any particular four-set is
  aligned. The promised-anchor variant of item 5 is a different, smaller problem
  and is not measured here.
- The trusted boundary is the alignment predicate and the switching-class
  indexing, both of which are stated above and re-derived independently in the
  replay.
- The literature audit is `notes/2026-08-07-c880-literature-audit.md`, and its
  verdicts govern what may be claimed here: nothing supports "first", every
  claim keeps "to our knowledge", the determinant-family identification becomes
  a citation to Greaves and Suda, the entropy bound is an application of the
  standard information-theoretic bound of combinatorial search theory rather
  than a new method, and the six-point sharpness must be positioned against
  Dammak, Lopez, Pouzet and Si Kaddour. Its negatives are bounded by the access
  gaps it records, chiefly the unobtained separating-systems classics and the
  unsearched Boolean sensitivity literature.
- The eight-point bracket's lower end is analytic, not mechanical: the
  certificate records the counting bound 20, and the 25 is the entropy bound of
  section 5 computed by hand from the same quarter marginal.
- Section 7 is positioning and argument, not measurement. That the triple is the
  natural switching-invariant observable is a proof from the manuscript's own
  identity; that no real setting has the four-set oracle is a prior, and item 8
  of the card is what would test it.
- Manuscript wording (item 7 of the card) is still not drafted here, and C816
  and C824 own promotion.

## Reproduction

From `notes/`, with a scratch directory `$S`:

```sh
rustc -O -o $S/c880 2026-08-07-c880-alignment-separation.rs
$S/c880 threshold --nmax 7 --out $S/threshold.json      # section 1
$S/c880 census    --n 7      --out $S/census7.json      # section 2, level-wise
$S/c880 minimize  --n 7 --seed-weight 3 --out $S/min7.json  # section 2, hitting set
$S/c880 paper     --n 7      --out $S/paper7.json       # section 3
$S/c880 paper     --n 8      --out $S/paper8.json       # section 3
$S/c880 bounds    --n 7 --weight 4 --out $S/bounds7.json    # section 4 control
$S/c880 bounds    --n 8 --weight 4 --out $S/bounds8.json    # section 4
$S/c880 search    --n 8 --iters 400 --kick 8 --out $S/search8.json  # section 4 upper bound
$S/c880 family    --n 7 --anchor 3 --out $S/family7-triangle.json   # section 5
$S/c880 family    --n 8 --anchor 3 --out $S/family8-triangle.json   # section 5
$S/c880 links     --n 7 --out $S/links7.json                        # section 5 sweep
$S/c880 links     --n 8 --out $S/links8.json                        # section 5 sweep
$S/c880 adaptive  --n 7 --out $S/adaptive7.json                     # section 6
$S/c880 adaptive  --n 8 --out $S/adaptive8.json                     # section 6
$S/c880 stats     --n 7 --out $S/stats7.json                        # section 8
$S/c880 stats     --n 8 --out $S/stats8.json                        # section 8
uv run --with numpy python3 2026-08-07-c880-alignment-separation-replay.py \
    --census 2026-08-07-c880-alignment-separation-census7.json --out $S/replay.json
```

Everything is deterministic: the enumerations are canonical, and the only
randomized part — the restart orders of the greedy strip at eight points — uses a
fixed seed recorded in the source.

**Three independent routes to the same minimum at seven points.** The `minimize`
mode solves a minimum hitting set over pair-difference masks with lazy
constraint generation, accepting a family only after a direct separation check.
The `census` mode ignores that machinery and enumerates removable sets level by
level. The `bounds` mode derives the bound from the weight-two difference
patterns alone, as a vertex cover. All three return 30. The numpy replay
recomputes the alignment data from a different representation — full graph
enumeration with no switching representative chosen — and re-verifies both the
six-point collision counts and, at seven points, that all 56 reported families
are removable and that none extends.

### Artifacts

| file | bytes | sha256 |
|------|-------|--------|
| `2026-08-07-c880-alignment-separation.rs` | 62332 | 946583c8841e54985a5d57d6c632bedc885c6e0d57e0fa734d0b78ad9f38906d |
| `2026-08-07-c880-alignment-separation-replay.py` | 8373 | 95cc38756438c7a9d5e7b893b6bdbf917aa7425e9518290022b42982c5ba7fd4 |
| `2026-08-07-c880-alignment-separation-threshold.json` | 2810 | efe57db769fb9b33500cf31b13fac7e10ee103f5f653fefdb6a90c2fedbe9423 |
| `2026-08-07-c880-alignment-separation-census7.json` | 677 | cea77f21fef491a53a1d2cff21ad482a5208f121f0d8bc8ba634ef16d78b3a8b |
| `2026-08-07-c880-alignment-separation-min7.json` | 769 | c8121ae8374507fc9e5ff0625adedd0a7a3e5caf167819ac4058b857fa74ea6b |
| `2026-08-07-c880-alignment-separation-paper7.json` | 256 | 6cf7ce5bd451eeec4b489d6767720c872e53e792cda3fa1946a9518e7cfb22fc |
| `2026-08-07-c880-alignment-separation-paper8.json` | 328 | c15873562c3e0860fc610012bd505ad435e28a10c1bebd5e7e5b9aa88da44fa5 |
| `2026-08-07-c880-alignment-separation-bounds7.json` | 520 | d1dae32cacae8a42fda37710706389bf9585d0484ed2d768d68ab002af6ee3af |
| `2026-08-07-c880-alignment-separation-bounds8.json` | 572 | 2b42d2b48ef9c922fe256b9c5c736105a0ab6f9c36a5e3c16ec2dd29d8972058 |
| `2026-08-07-c880-alignment-separation-family7-triangle.json` | 283 | f3bdf96d29d0bcd304d6c73b53accce9edf5d8e86d535361dd0c7432937baf06 |
| `2026-08-07-c880-alignment-separation-family8-triangle.json` | 285 | f1c5ee83831a95c358e22e4965e43958fbd6b05f6bdacb189ccb713cd2ae3eac |
| `2026-08-07-c880-alignment-separation-links7.json` | 5149 | 956ad6e11799d39c65695f4b4b956519c2ffb8715a24333f5450fb4bfa5bc2d5 |
| `2026-08-07-c880-alignment-separation-links8.json` | 5151 | 6a6a9188d963a6662c2d8e2a411f15a25a9ecb00b500fc6f6d9d67098d36c03f |
| `2026-08-07-c880-alignment-separation-search8.json` | 637 | 3fa2ddde31d27989afc568d077697a875b674f09ec2d6213b9f8e7e39838993b |
| `2026-08-07-c880-alignment-separation-adaptive7.json` | 289 | 95f5ec5f2d049c8d62e1529036f0a07b400ca2ba311ee28ec82de6c773131c94 |
| `2026-08-07-c880-alignment-separation-adaptive8.json` | 293 | 77e2f8e89e39c4208adb4d93454d3e4a8f53c38dd3af75d1f8d47bcc0a6b9c9c |
| `2026-08-07-c880-alignment-separation-stats7.json` | 309 | b722b3d42ce83c63ce37e1e35e59ebef2ce1e645d42293c2f4386898f3044c0e |
| `2026-08-07-c880-alignment-separation-stats8.json` | 535 | 991c9f2f46e371988b10bcc5d819247ea0027da0cc113a66d5fe74a17414c2d2 |
| `2026-08-07-c880-alignment-separation-replay.json` | 1638 | a306367330ba08a393df7dc83faf1c8b9226cf420c7fd8ebfe7a1c3a09138394 |

## Next in this task

- Item 3 has moved: the entropy bound of section 5 beats counting at every
  \(n\), and the eight-point gap between 44 and 53 says the exhibited
  construction is not optimal. What is open is the constant, now bracketed
  between \(0.616\,n^2\) and \(3n^2\).
- The link-graph rule says any better construction must share tests between
  outside pairs rather than spend six private ones on each. A family in which
  most tests have all four points generic would reach about \(n^2/2\) if
  non-bipartite links were sufficient — they are not, so the question is what
  the true local condition is.
- The weight-two difference patterns at seven points are the mechanism behind
  the exact bound; identifying them structurally for general \(n\) is the most
  direct route to a proved lower bound, and it is a finite question at each \(n\).
- Item 5 (regular two-graphs and the promised anchor) is untouched. Item 8 (a
  setting whose primitive observation is a four-set alignment test) is the one
  that decides whether section 7's positioning can be softened; the lane's prior
  expectation is that it cannot.
