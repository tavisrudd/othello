# 2026-08-19 — C880: the cost-per-bit constant, and which side of the bracket is loose

**Task:** C880 (`clebsch`), follow-on to
`notes/2026-08-19-c880-nonadaptive-constant.md`, which left the nonadaptive
bracket at \(0.616\,n^2\le\mathrm{minimum}(n)\le\tfrac98n^2+O(n)\) and a
mystery: every exactly measured cost sits at 2.25 to 3 alignment tests per
recovered bit, a covering heuristic predicts about 2.409, and the entropy floor
licenses 1.2326. Research and computation only; no manuscript file and no Lean
file is touched.

**Conventions** are inherited unchanged from the predecessor report: points
\(0,\dots,n-1\); a two-graph is the switching class of a graph, indexed by the
\(2^{\binom{n-1}2}\) graphs on \(1,\dots,n-1\); a 4-set is aligned when its four
triples carry equal \(\tau\); \(D=\binom{n-1}2\) is the number of bits to
recover; \(g(m)\) is the least number of triples of \(m\) known points that
determine one new point's attachment for **every** two-graph on those points.

## Objective and plan, written before any computation

Decide which end of the bracket is loose, and say why with evidence rather than
with a preference. The plan, in the order it was executed:

1. **Take the coordinator's lead 1 seriously as a structural question, not a
   numerical one.** The exact values \(g(5),g(6),g(7)=9,12,15\) rise by three,
   which is exactly the attachment lemma's marginal, and the verified
   \(g(8)\le17\) breaks it. Settle \(g(8)\) exactly, then test whether a block
   of fresh points can ever cost less than \(9/4\) per point, which is the only
   thing that moves the leading constant.
2. **Look for a proved lower bound above the entropy floor.** The predecessor's
   polynomial-method attempt stalled at \(n^2/4\). Two new ingredients are tried
   here: the observation that every alignment test's flat contains the
   complementation vector, which turns separation into injectivity on a space of
   dimension \(D-1\); and a star-flip argument that reduces a lower bound on the
   whole problem to a lower bound on one attachment layer.
3. **Decide the verdict, and record the proved negatives with their exact
   searched domain and stop condition.**

Everything below is appended in the order it was found.

## 1. A new lower bound: star flips, and what they cap out at

**The bound.** Let \(F\) be any separating family on \(n\) points and \(v\) a
point. Two two-graphs that agree off \(v\) and differ at \(v\) are never
complementary (complementing changes every triple, so it changes the
restriction too, as soon as \(n\ge4\)), so \(F\) must separate them outright —
and only tests containing \(v\) can, since every other test reads the same
data on both. Writing \(F_v\) for the tests through \(v\), regarded as triples
of \(V\setminus\{v\}\), that says exactly: **\(F_v\) is an attachment family for
the other \(n-1\) points**, so \(\lvert F_v\rvert\ge g(n-1)\). Each test has
four points, so \(\sum_v\lvert F_v\rvert=4\lvert F\rvert\) and

\[
  \mathrm{minimum}(n)\;\ge\;\left\lceil \frac{n\,g(n-1)}{4}\right\rceil .
\]

**It beats the entropy floor where \(g\) is known exactly.** At \(n=7\) it gives
\(\lceil 7\cdot12/4\rceil=21\) against the entropy floor 18; at \(n=8\),
\(\lceil8\cdot15/4\rceil=30\) against the floor 25 — and 30 is exactly the best
lower bound the predecessor lane had at eight points, which it obtained from a
partial-spread argument in \(\mathrm{PG}(3,2)\). The star-flip argument
reproduces that number in two lines from \(g(7)=15\), which is a second,
independent derivation of it.

So the answer to the coordinator's lead 2, in the form that matters, is **yes:
there is a proved lower bound above the entropy floor**, at every \(n\) where
the attachment cost is known exactly.

**And it can never beat the floor asymptotically.** The same construction that
gives the \(9/8\) upper bound proves \(g(m)\le\tfrac94 m\), so

\[
  \frac{n\,g(n-1)}{4}\;\le\;\frac{9n(n-1)}{16}\;\approx\;0.5625\,n^2
  \;<\;0.616\,n^2 .
\]

This is a **proved negative with an exact reason**: the star-flip route is
capped below the entropy floor by the very construction that makes the upper
bound good. Improving it would require \(g(m)\ge2.4646\,m\), which is false.
The searched domain is the whole route, not a computation: any bound of the
form \(n\cdot(\text{lower bound on }g(n-1))/4\) is dead, whatever \(g\) turns
out to be, because \(g\) is squeezed from above by the block construction.

**What it does buy: the layered shape is within a factor two of optimal.**
Both ends of

\[
  \frac{n\,g(n-1)}{4}\;\le\;\mathrm{minimum}(n)\;\le\;30+\sum_{m=7}^{n-1}g(m)
\]

are governed by the same function. If \(g(m)/m\to\gamma\), the left side is
\(\gamma n^2/4\) and the right side \(\gamma n^2/2\). So **base-plus-layers
costs at most a factor 2**, unconditionally and without knowing \(\gamma\).
That settles the second half of the coordinator's lead 3 in the negative
direction: the shape does not cost a large constant factor, and no
reorganisation of the layers can win more than a factor 2.

| \(n\) | entropy floor | star-flip bound | best lower bound | block construction |
|---|---|---|---|---|
| 7 | 18 | **21** | 21 | 30 |
| 8 | 25 | **30** | 30 | 45 |
| 9 | 34 | 21 (layer entropy only) | 34 | 62 |
| 20 | 210 | 115 (layer entropy only) | 210 | 393 |

The rows from \(n=9\) on use the layer entropy floor for \(g\), because \(g(8)\)
is not exact — §3 leaves it bracketed at \(15\le g(8)\le17\). Substituting the
proved lower end changes the \(n=9\) row and nothing else: the star-flip bound
becomes \(\lceil9\cdot15/4\rceil=34\), which **ties** the entropy floor of 34
rather than beating it. So the two sizes where this bound is strictly better
than entropy are \(n=7\) and \(n=8\), and settling \(g(8)\) at 16 or 17 would
push \(n=9\) to 36 or 39 and make it three.

## 2. Why the covering heuristic is not a bound, and why no covering argument can be

The predecessor report's 2.409 came from a random-covering estimate: a **no**
answer removes a quarter of the candidates, so if the quarters behaved
independently the expected number of survivors after \(k\) tests would be
\(2^{m}(3/4)^{k}\), and setting that to one gives \(k=\log2/\log(4/3)\cdot m
=2.409\,m\). Three things say that number cannot be turned into a lower bound.

**The flats are linear, and they all contain the complementation vector.** An
alignment test on \(S\) is aligned exactly when the three 4-cycles of \(S\)
have even edge count, so its yes-set \(W_S\) is the common kernel of a
2-dimensional space of cycles — a **linear** codimension-two subspace, not an
affine one. Every 4-cycle has four edges, so it vanishes on the all-ones graph,
which is the complementation vector \(J\); hence \(J\in W_S\) for every \(S\),
which is complement-invariance seen algebraically. Everything therefore
descends to \(V'=\mathbf F_2^{D}/\langle J\rangle\) of dimension \(m=D-1\), and
**separation is exactly injectivity of the answer map on \(V'\)**: for the true
\(\tau\), the tests answering no must cover \(V'\) minus the single point
\(\tau\), inside whatever subspace the yes answers have already pinned.

**Linear flats cover far better than random ones.** Seven codimension-two
linear subspaces cover *all* of \(\mathbf F_2^m\), for every \(m\): take a
3-dimensional subspace \(U\) of the dual and the seven 2-subspaces of \(U\);
any \(v^\perp\) meets \(U\) in dimension at least two, so it contains one of
them. Verified by machine at \(m=3,4,5\). So covering, as a counting matter,
costs \(O(1)\), not \(2.409\,m\) — the random estimate is wrong by an unbounded
factor because the objects are subspaces through a common point, not random
sets.

**What actually costs something is leaving exactly one point uncovered.**
Write \(c_2(m)\) for the least number of codimension-two linear subspaces of
\(\mathbf F_2^m\) whose union is \(\mathbf F_2^m\) minus one point. Computed
exactly by minimum set cover over every candidate flat:

| \(m\) | 3 | 4 | 5 |
|---|---|---|---|
| \(c_2(m)\) | 6 | 6 | 6 |

At \(m=6\) the exact search did not finish inside 110 s and is not reported;
the value is not needed, for the reason below.

**The cancellation theorem: no covering argument of this shape can exceed
\(\tfrac12\) test per bit.** Suppose \(c_2(d)\ge\alpha d\) for all \(d\), for
whatever constant \(\alpha\) one can prove. Fix the true \(\tau\) and let \(Y\)
be its yes-set. The yes answers confine \(\tau\) to \(V'_Y=\bigcap_{S\in
Y}\overline W_S\), of dimension \(m-c(Y)\ge m-2\lvert Y\rvert\), and the no
tests must cover \(V'_Y\) minus the one point \(\tau\), so
\(k-\lvert Y\rvert\ge\alpha\,(m-2\lvert Y\rvert)\), that is
\(k\ge\alpha m+\lvert Y\rvert(1-2\alpha)\). For \(\alpha>\tfrac12\) the
coefficient of \(\lvert Y\rvert\) is negative, and the adversary chooses
\(\tau\), so the guaranteed bound is at \(\lvert Y\rvert=k\):
\[
  k\;\ge\;\alpha m+k(1-2\alpha)\quad\Longrightarrow\quad k\;\ge\;\frac m2 .
\]
**The constant \(\alpha\) cancels exactly.** However strong the covering
estimate, this route yields \(k\ge(D-1)/2\approx n^2/4\), which is
\(\tfrac12\) test per bit and below the entropy floor's 1.2326. That is why the
predecessor's polynomial-method attempt came out at \(n^2/4\): not because the
polynomial bound was weak, but because the route is capped.

**What would have to change.** The cancellation is driven by
\(c(Y)\le2\lvert Y\rvert\) — a yes answer buying two full dimensions. If the
2-spaces of 4-cycles were dependent enough that \(c(Y)\le\beta\lvert Y\rvert\)
with \(\alpha\beta<1\), the coefficient would turn positive and the bound would
become \(k\ge\alpha m\). Beating the entropy floor then needs
\(\alpha>1.2326\) together with \(\beta<1/\alpha<0.81\). So the open question
this route reduces to is sharp and stated in one line: **how dependent are the
4-cycle pairs of the tests a decoder answers yes on?** Nothing here bounds
that, and the adversary picks \(Y\).

### The covering constant, measured

The covering estimate can be checked rather than argued about, because the
covering problems it rests on are small and exactly solvable.

Inside one attachment layer a test's yes-set is an **affine** codimension-two
flat — its two conditions have known, generally nonzero targets — so the
all-no instance of a layer asks: cover \(\mathbf F_2^{m}\) minus the origin by
codimension-two affine flats, none containing the origin. Writing
\(c_2^{\mathrm{aff}}(m)\) for the least number:

| \(m\) | 2 | 3 | 4 | 5 |
|---|---|---|---|---|
| \(c_2^{\mathrm{aff}}(m)\) | 3 | 4 | 5 | 6 |

exactly \(m+1\), against a polynomial-method bound of \(\lceil m/2\rceil\) and
an explicit pairing construction (the three nonzero patterns on each pair of
coordinates) that is verified to cover. **So the deterministic covering
constant is 1 per dimension, not 2.409.**

That is the whole answer to where 2.409 came from. The random model says a
family of \(k\) tests leaves about \(2^m(3/4)^k\) instances indistinguishable
from the all-no one, which needs \(k=2.409\,m\); the deterministic optimum needs
\(m+1\). Worse for the argument, an efficient family need not have an all-no
instance at all: with \(k\approx1.23\,m\) tests only \(2^m\) of the
\(2^{k}\) patterns are achieved and the typical achieved pattern has weight
about \(k/4\), so a well-designed family can simply avoid the all-no pattern
and no covering argument bites at full strength.

**Conclusion for lead 2.** A covering argument that uses the geometry rather
than the count is available, and it is *weaker*, not stronger: the geometry says
codimension-two flats cover unusually well. Combining the covering constant
\(\alpha\) with the pattern count gives a bound above the entropy floor only if
\(\alpha>2.409\), and the measured \(\alpha=1\) with the proved
\(\alpha\le1.5\) from the pairing construction rules that out. **Lead 2 is
closed negatively, with the searched domain being the covering formulation
itself and the stop condition being the exact values above.**

## 3. Lead 1: the \(+3\) law is a theorem, and the escape is batching

**The \(+3\) law is exactly the cost of adding one point at a time, and it is
optimal for that shape.** Suppose the attachment is already known on all old
points but one, \(w\). Only triples containing \(w\) can see a flip at \(w\),
and the test \(\{v,a,b,w\}\) distinguishes the flip exactly when
\(x_a+x_b=e_{aw}+e_{bw}\). Writing \(s_a=x_a+e_{aw}\) — an arbitrary
2-colouring of the other points, since the edges \(e_{aw}\) are free — the test
distinguishes iff \(s_a=s_b\). So the link graph
\(L_w=\{\{a,b\}:\{a,b,w\}\in\mathcal T\}\) must have a monochromatic edge under
every 2-colouring, that is, **\(L_w\) must be non-bipartite**, so
\(\deg_{\mathcal T}(w)\ge3\); and a triangle suffices, by the attachment
lemma's pigeonhole. Hence \(P(k,1)=3\) exactly. The measured
\(g(5),g(6),g(7)=9,12,15\) is that law running: each new point costs its three
tests and no fewer.

**The escape is batching, and it is not new at \(m=8\).** Four *fresh* points
cost \(P(1,4)=9\), not \(3\cdot4=12\); that is already the value \(g(5)=9\),
the very first term of the progression. So the coordinator's two phenomena are
one: the \(+3\) law prices a **sequential** shape, batching beats it by
\(9/12=0.75\), and the \(g(8)\le17\) witness is the first \(m\) at which a
family can rebatch rather than append. The saving is exactly the difference
between the naive \(\tfrac32n^2\) construction of the predecessor report and
its \(\tfrac98n^2\) successor: a factor \(0.75\), bought once.

**Does the same mechanism buy more asymptotically?** Only if some block bigger
than four costs less than \(9/4\) per point. Measured exactly:

| fresh points \(j\) | 1 | 2 | 3 | **4** | 5 | 6 | 7 | 8 |
|---|---|---|---|---|---|---|---|---|
| \(P(1,j)=g(j+1)\) | — | 6 | 8 | **9** | 12 | 15 | \(\le17\) | \(\le18\) |
| per point | 3 | 3 | 2.667 | **2.25** | 2.4 | 2.5 | \(\le2.43\) | \(\le2.25\) |

(the \(j=1\) column is the sequential law, which needs two anchor points rather
than one). Blocks of five, six and seven are all worse than blocks of four, and
a block of eight ties it. So within everything computed, **\(9/4\) is the floor
of this method**, and the \(\tfrac98n^2\) is the floor of the construction —
not because no better shape exists, but because none of the eight shapes that
fit in reach is better.

### Settling \(g(8)\): what was searched, and where it stopped

The complete difference-mask family at \(m=8\) has minimum weight **9** — there
is no lighter difference between two attachments at eight points — and exactly
280 masks of that weight. Solving the minimum hitting set of the masks of
weight at most \(w\) gives a valid lower bound for \(g(8)\) whatever lies above
the cap, and the bound saturates:

| weight cap \(w\) | 9 | 12 | 14 | 16 |
|---|---|---|---|---|
| inclusion-minimal masks | 280 | 728 | 7,028 | 27,139 |
| hitting number | 8 | 14 | **15** | **15** |

**Exactly what that table says.** Each entry is the exact minimum hitting set of
a *subfamily* of the true constraints — the pairs of attachments whose answers
differ in at most \(w\) tests. Dropping constraints can only lower a hitting
number, so **15 is a proved lower bound for \(g(8)\)**, and it is proved twice,
by the weight-14 and the weight-16 families independently. It is **not** an
upper bound and it is **not** the hitting number of the complete family: masks
of weight 17 and above exist at \(m=8\) and were never enumerated, so this
route is not exhausted — it merely stopped improving between the two caps
tried. "Saturates at 15" therefore means *the two largest weight caps that were
affordable both return 15*, not *no further constraint can force more*.

So

\[
  15\;\le\;g(8)\;\le\;17,
\]

the upper end from the certified witness family, which this report's
independently written generator re-verifies over all \(2^{21}\) two-graphs.
**\(g(8)\) is not settled.** Either it is 15 and the witness of 17 is two above
optimal, or it is 16 or 17 and the extra tests are forced only by masks of
weight at least 17; nothing here distinguishes those cases. The stop condition
is exact: the generator's own branch and bound was killed at 900 s on the
728-mask family without reaching a decision, and HiGHS took about 25 minutes on
the 27,139-mask family to return the same 15; the complete family was never
built.

**The \(+3\) progression is broken, and that does not depend on the bracket.**
\(g(5),g(6),g(7)=9,12,15\) predicts \(g(8)=18\). The verified witness gives
\(g(8)\le17\), so the progression fails at \(m=8\) **whatever \(g(8)\) turns out
to be** — the break is established by the upper bound alone, which is a
certificate, not by the unsettled lower bound. What remains open is only how
far below 18 the truth sits.

At \(m=9\) the same route gives only \(11\le g(9)\le18\) (masks of weight at
most 16 over a 1-in-4096 sample of the two-graphs; the upper end is the block
construction, re-verified here over all \(2^{28}\) two-graphs). A direct search
for a family of 17 at \(m=9\) ran 40 rounds of lazy greedy against an
80,000-mask sampled pool without certifying anything below 18.

## 4. The reduction that makes the question tractable

Put the two directions together. With \(\gamma\) the layer constant, meaning
\(g(m)\sim\gamma\,m\):

\[
  \underbrace{1.2326}_{\text{entropy floor}}\;\le\;
  \frac{\mathrm{minimum}(n)}{D}\;\le\;\gamma,
  \qquad
  \underbrace{1.2326}_{\text{layer entropy floor}}\;\le\;
  \frac{g(m)}{m-1}\;\le\;\gamma .
\]

The global cost-per-bit bracket **is** the one-layer cost-per-bit bracket: same
lower end, because the layer entropy floor and the global entropy floor are the
same argument applied to \(m-1\) and to \(D\) bits; same upper end, because
layers compose with no loss. So the cost-per-bit constant of aligned-design
reconstruction is a property of a single attachment layer, and the layer is a
much smaller object: determining a hidden 2-colouring of \(m\) points from
queries that ask whether it matches a prescribed bipartition of a triple, with
\(2^{\binom{m-1}2}\) prescriptions to survive. At \(n=9\) the global problem
already needs \(2^{28}\) two-graphs; the layer at \(m=9\) needs the same
\(2^{28}\) but recovers only 8 bits instead of 28, so every search is
exponentially cheaper in the quantity that matters.

**That is the practical content of this round:** whoever wants the constant
should stop working on two-graphs and work on the layer.

## 5. Verdict: the floor is the loose side, and here is the reason

**The entropy floor is loose, and every exact number in the lane says so.**

- At \(n=7\), the only size where the nonadaptive minimum is *known*, it is 30
  tests for 15 bits — **2.00 tests per bit** against a floor of 1.2326. That is
  a measured factor of 1.62, not a conjecture.
- The exactly known layer costs are 2.25, 2.4 and 2.5 tests per bit at
  \(m=5,6,7\), and the layer floor is the same 1.2326. Again a factor near two,
  three times over, at three different sizes.
- No family found in this lane, by any method — anchor, block, greedy strip,
  iterated local search, or exact minimum hitting set — has ever come within
  60% of the floor.

**Why it is loose: the floor is blind to the alignment code's distance
distribution.** The entropy argument prices a test at \(H(1/4)\) bits and knows
nothing else. What actually forces tests into a family is that many pairs of
instances differ in very few tests, and each such pair forces one of them. That
is a covering-design constraint. It is exactly tight where it has been computed
to completion: at \(n=7\) the hitting number of the weight-two difference masks
is 30, which **is** the nonadaptive minimum. Entropy gives 18 there. The gap
between 18 and 30 is the gap between an information bound and a design bound,
and the design bound is the true one.

**The three arguments near 2.4 are not three arguments.** The covering
heuristic is not independent evidence: §2 shows its 2.409 is what the *random*
model costs, that the deterministic covering constant is 1, and that an optimal
family can dodge the all-no instance the estimate prices. What remains is the
measured evidence — the exact minimum at \(n=7\) and the exact layer costs —
and those are measurements of the truth at small sizes, not of a method.

**What would settle it.** The mask/hitting-set route at the layer level is the
only mechanism that has ever been tight in this lane, and at the layer it is
fresh rather than exhausted: the layer's minimum difference weight grows (9 at
\(m=8\), at most 12 at \(m=9\)), unlike the global masks, which the predecessor
proved to be a seven-point statement in disguise at both \(n=7\) and \(n=8\).
Concretely: compute the hitting number of the **complete** layer mask family at
\(m=8\), which would settle \(g(8)\) and pin the constant's third digit, then
at \(m=9,10\). If those grow like \(2.25\,m\) the constant is settled at
\(\tfrac98\) from both sides and the floor is proved loose by a factor 1.83; if
they fall towards \(1.23\,m\), the construction is the loose side after all and
the block shape is not the right one.

**Both routes to a proved bound above the floor are now closed with exact
reasons**, and that is a real deliverable rather than a gap: the covering route
by the cancellation theorem and the measured covering constant (§2), the
star-flip route by the block construction's own upper bound on \(g\) (§1). A
third route has to come from the distance distribution, which is where the only
tight bound in the lane's history came from.

## 6. Mystery ledger

| open item | what is surprising or unexplained | what this round settled | exact evidence gap or successor |
|---|---|---|---|
| The factor 1.83 between \(0.616\,n^2\) and \(\tfrac98n^2\) | Three arguments were said to cluster near 2.4 tests per bit while the floor sits at half that. | **Settled which side is loose, and that the cluster is not three arguments.** The covering heuristic's 2.409 is the random-model cost of a requirement an optimal family can dodge; the deterministic covering constant is 1 (\(c_2^{\mathrm{aff}}(m)=m+1\), exact for \(m\le5\)). What is left is measurement: 2.00 tests per bit at \(n=7\) and 2.25–2.5 in the layers, all against a floor of 1.2326. | The floor is loose, but nothing here proves it asymptotically. The successor is the layer mask hitting number at \(m=8,9,10\) — the one mechanism that has ever been tight in this lane. |
| Whether a proved bound can exceed the entropy floor | The floor ignores all geometry, so it ought to be beatable. | **Yes at small \(n\), no asymptotically, both proved.** The star-flip bound gives 21 at \(n=7\) and 30 at \(n=8\), above the floor's 18 and 25; and it is capped at \(0.5625\,n^2<0.616\,n^2\) by the block construction's own bound on \(g\). | Any bound of the form \(n\cdot(\text{lower bound on }g(n-1))/4\) is dead. A third mechanism must price several points at once without the factor-four loss from counting each test in four stars. |
| Exact \(g(8)\) | The attachment cost is exact at \(m=5,6,7\) and stuck at \(15\le g(8)\le17\). | **Not settled**, and the \(+3\) progression \(9,12,15\) is nonetheless **proved broken** at \(m=8\), by the certified witness of 17 against the predicted 18. The lower end 15 is a proved bound from two independent weight-capped families (caps 14 and 16, hitting numbers 8, 14, 15, 15 for caps 9, 12, 14, 16); it is not the hitting number of the complete family, which was never built. | Either \(g(8)=15\) and the witness is two above optimal, or the extra tests are forced by masks of weight \(\ge17\), which were not enumerated. The generator's branch and bound was killed at 900 s on 728 masks; HiGHS took about 25 minutes on 27,139 masks to return 15. A symmetry-reduced program over the complete family is the obvious successor. |
| Whether any block beats \(9/4\) per point | The per-point costs 3, 3, 2.667, **2.25**, 2.4, 2.5 have an interior minimum, which invites the thought that it recurs. | Blocks of five, six and seven are worse; a block of eight ties at \(\le2.25\). A 40-round lazy search at \(m=9\) never certified anything below 18. | \(g(9)\) is bracketed \([11,18]\), so a block of eight costing 17 is not excluded. Deciding it needs the complete \(m=9\) mask family, a \(2^{28}\)-two-graph sweep over all attachment pairs. |
| Why the layer and the whole problem have the same bracket | The reduction is exact in both directions, which is unusual for a lower bound and an upper bound derived by different means. | **Explained.** The upper end composes with no loss because blocks share only the gauge point; the lower end is literally the same entropy computation applied to \(m-1\) bits instead of \(D\). | Nothing open. This is the round's most useful structural output: the constant is a property of one layer. |

No mystery is manufactured. The first row is the one that matters, and this
round moved it from "three arguments disagree" to "one measurement, twice
confirmed, against a floor that is provably blind to the mechanism that
actually binds".

## 7. What is proved, what is measured, and what is trusted

**Proved by hand.**
- The star-flip bound \(\mathrm{minimum}(n)\ge\lceil n\,g(n-1)/4\rceil\), and
  that it is capped below the entropy floor by \(g(m)\le\tfrac94m\).
- The factor-two optimality of base-plus-layers.
- \(P(k,1)=3\) exactly, from the non-bipartite link criterion below and the
  attachment lemma above.
- The cancellation theorem of §2: a covering argument on the surviving subspace
  yields \(k\ge(D-1)/2\) whatever the covering constant.
- That every alignment test's yes-set is a linear codimension-two subspace
  containing the complementation vector, so separation is injectivity on a
  space of dimension \(D-1\).
- The consistency computation showing a covering argument beats the entropy
  floor only if the covering constant exceeds \(\log2/\log(4/3)=2.409\).

**Exact, by exhaustive computation.** \(c_2(m)=6\) for \(m=3,4,5\);
\(c_2^{\mathrm{aff}}(m)=m+1\) for \(m=2,3,4,5\); the minimum attachment
difference weight 9 at \(m=8\) with 280 masks at that weight; the hitting
numbers 8, 14, 15, 15 of the weight-capped families at \(m=8\).

**Verified witnesses, re-derived here.** \(g(8)\le17\) and \(g(9)\le18\), each
checked by this report's independently written generator over all \(2^{21}\)
and all \(2^{28}\) two-graphs respectively. These are the previous round's
families; re-verifying them with a separately written program is an
independent replay of the two facts the \(\tfrac98\) construction rests on.

**Not deterministic, and not used as evidence.** The `search` mode samples
two-graphs and its violation set depends on thread scheduling. It found
nothing below 18 at \(m=9\) and that negative is reported as a bounded search,
not as a bound.

**The trusted boundary** is the attachment identity, which `selfcheck` verifies
against the direct four-triples definition of alignment on all 655,360
(two-graph, attachment, triple) cases at \(m=6\).

**What is not certified.** \(g(8)\) and \(g(9)\) are bracketed, not computed;
\(c_2(6)\) did not finish; and every asymptotic statement about \(\gamma\)
rests on block sizes at most eight.

## 8. Reproduction

The block below is self-contained: it assumes `rustc` and `uv` on the path and
sets its own working directory and scratch directory in its first two lines.
`rustc 1.93.1`, `rustc -O`, no external crates. Every generator mode is
deterministic — canonical enumeration, no randomness, every collection sorted
before use — except `search`, which is a candidate finder and whose output is
not used as evidence. Run in place, the block rewrites exactly the committed
certificates and must leave the worktree clean.

```sh
cd /home/tavis/src/othello/notes          # or <your checkout>/notes
S=$(mktemp -d)

rustc -O -o $S/gen 2026-08-19-c880-cost-per-bit-constant.rs

# the attachment identity, against the direct four-triples definition
$S/gen selfcheck > 2026-08-19-c880-cpb-selfcheck.txt

# covering constants: linear flats (c2), then affine flats (c2aff)
for m in 3 4 5; do
  $S/gen flatcover --m $m --out 2026-08-19-c880-cpb-flatcover-m$m.json
done
for m in 2 3 4 5; do
  $S/gen affcover --m $m --out 2026-08-19-c880-cpb-affcover-m$m.json
done

# the star-flip lower bound against the entropy floor and the construction
$S/gen bracket --nmax 40 --out 2026-08-19-c880-cpb-bracket.json

# attachment difference masks: complete at m=8, sampled 1-in-4096 at m=9
for w in 9 12 14 16; do
  $S/gen masks --m 8 --maxweight $w --out 2026-08-19-c880-cpb-masks-m8w$w.json
done
$S/gen masks --m 9 --stride 4096 --maxweight 16 \
  --out 2026-08-19-c880-cpb-masks-m9w16.json

# the witness families of the 9/8 construction, re-verified by this generator
$S/gen verify --m 8 \
  --family "0,1,2;0,1,4;0,1,5;0,2,4;0,2,5;0,4,5;1,2,3;1,2,5;1,2,6;1,2,7;1,3,6;1,3,7;1,4,5;1,6,7;2,3,6;2,3,7;2,5,6" \
  --out 2026-08-19-c880-cpb-verify-g8.json
$S/gen verify --m 9 \
  --family "0,1,2;0,1,3;0,1,4;0,2,3;0,2,4;0,3,4;1,2,3;1,2,4;1,3,4;0,5,6;0,5,7;0,5,8;0,6,7;0,6,8;0,7,8;5,6,7;5,6,8;5,7,8" \
  --out 2026-08-19-c880-cpb-verify-g9.json          # ~2 min

# exact minimum hitting sets of those mask families (the g lower bounds).
# The driver is the previous round's, unchanged; it re-derives the triple
# indexing from m before solving and records the SHA-256 of its input.
uv run --with numpy --with scipy --with pulp python3 2026-08-19-c880-attach-ilp.py \
    --masks 2026-08-19-c880-cpb-masks-m8w9.json  --out 2026-08-19-c880-cpb-ilp-m8w9.json --cbc
uv run --with numpy --with scipy --with pulp python3 2026-08-19-c880-attach-ilp.py \
    --masks 2026-08-19-c880-cpb-masks-m9w16.json --out 2026-08-19-c880-cpb-ilp-m9w16.json --cbc
uv run --with numpy --with scipy --with pulp python3 2026-08-19-c880-attach-ilp.py \
    --masks 2026-08-19-c880-cpb-masks-m8w12.json --out 2026-08-19-c880-cpb-ilp-m8w12.json
uv run --with numpy --with scipy --with pulp python3 2026-08-19-c880-attach-ilp.py \
    --masks 2026-08-19-c880-cpb-masks-m8w14.json --out 2026-08-19-c880-cpb-ilp-m8w14.json   # ~15 min
uv run --with numpy --with scipy --with pulp python3 2026-08-19-c880-attach-ilp.py \
    --masks 2026-08-19-c880-cpb-masks-m8w16.json --out 2026-08-19-c880-cpb-ilp-m8w16.json   # ~25 min
```

**Replay status.** The generator was rebuilt from the committed source in a
fresh scratch directory after its last edit, and every one of the fifteen
certificates it owns — selfcheck, three `flatcover`, four `affcover`,
`bracket`, five mask files, and the \(m=8\) verification — came back byte for
byte identical, as did the \(m=9\) verification over all \(2^{28}\) two-graphs
and the two short integer programs — \(m=8\) at weight cap 9 and \(m=9\) at
weight cap 16 — which were re-solved from scratch and returned identical bytes.
Each integer-program certificate records the SHA-256 of the mask file it
consumed, and all five match the committed mask files, so the solver chain is
pinned to bytes that themselves replay.

**What is not replayed and why.** The three longer integer programs
(\(m=8\), weight caps 12, 14 and 16) were each solved once; their inputs
replay and their recorded input hashes match, which is the provenance link the
convention asks for. The `search` mode is
nondeterministic by construction and is not part of the certificate set; its
only role in this report is the bounded negative that 40 rounds at \(m=9\)
certified nothing below 18.

### Artifacts

The report itself is excluded; `2026-08-19-c880-attach-ilp.py` is the previous
round's driver, unchanged and already committed with its own hash there.

| file | bytes | sha256 |
|------|-------|--------|
| `2026-08-19-c880-cost-per-bit-constant.rs` | 32173 | a19c1b3d643fd7a7ea28b53599e11ff54ee4115e76b847de1333ba7c99edcfd1 |
| `2026-08-19-c880-cpb-selfcheck.txt` | 96 | 3c7715d580cbf1ff9f4b915f2b05dd4df5a6ae1322e91605cef0be5f04d3e437 |
| `2026-08-19-c880-cpb-flatcover-m3.json` | 201 | 3360c50c15294c2b28b4bd6763447e526143c0e543700bc7985973d9f98c50fd |
| `2026-08-19-c880-cpb-flatcover-m4.json` | 205 | 8deaf3749128144fca08d6baa432730e9664c1d6c20c32caae2182b97935f35a |
| `2026-08-19-c880-cpb-flatcover-m5.json` | 209 | 733a428624c43fab6b5eb3db0858b9bd894e6c5e0dc721fee79354156adf79d8 |
| `2026-08-19-c880-cpb-affcover-m2.json` | 209 | 6db8b4899a8d343d3a92467fa69a095a99031fbac99401904971173915397bbb |
| `2026-08-19-c880-cpb-affcover-m3.json` | 211 | 9406285348dec1c9cdc9aa2d2305c77b179e5efb35cad3fc788f99af16df244e |
| `2026-08-19-c880-cpb-affcover-m4.json` | 217 | 4d764ae4b6e7237b53f781cf8f40989d45d6ebc22bcdf8871eb86c9b3d4f94f6 |
| `2026-08-19-c880-cpb-affcover-m5.json` | 222 | 5c2407caf2aaf7576f688dc31062a0f73c2a9e6cfcb59f6951f9ceaa58b856a1 |
| `2026-08-19-c880-cpb-bracket.json` | 6071 | 8ebd94595a09960133458065fc3047a4e3ef4f9c0cb84049fc5231556ac2983d |
| `2026-08-19-c880-cpb-masks-m8w9.json` | 9844 | 1fe921d67dadb1d3175860620d01f2738cacdaed525a09cc687c9bcd2caa1349 |
| `2026-08-19-c880-cpb-masks-m8w12.json` | 27675 | 07373f2d59eb8ab7399397b94eb15310727a065d515d2138c758714274e7815c |
| `2026-08-19-c880-cpb-masks-m8w14.json` | 320626 | 021fe3f36f66cafd16003c0510843010452ce0fc3e44b81f6e134d943c842cfc |
| `2026-08-19-c880-cpb-masks-m8w16.json` | 1369114 | 5b0656b6cd04f50aeccaabe403b42b823ba5ef8d70afb2458917328afaaa8f14 |
| `2026-08-19-c880-cpb-masks-m9w16.json` | 49879 | 445a27460b129cccda4d119c5cf187af2d8a0fcf56703690ea4852696cfced1f |
| `2026-08-19-c880-cpb-ilp-m8w9.json` | 468 | 5ade0e6b67c21954ad2b5a0c22cae6f2b7dcc7ef9de2d1ae2de4f78c22028899 |
| `2026-08-19-c880-cpb-ilp-m8w12.json` | 478 | 83cb96077f5e98ef17e18148dac43a330ab0586de5f052635c9fd97d0bd36247 |
| `2026-08-19-c880-cpb-ilp-m8w14.json` | 489 | 521f88914aa177eafc42ff06195e03aad4d0b2bc1c38f136a86c47e187d03aeb |
| `2026-08-19-c880-cpb-ilp-m8w16.json` | 491 | eeef8001d7d3f8818db8da538ed451a076707627a8cde4addc37c87365149127 |
| `2026-08-19-c880-cpb-ilp-m9w16.json` | 497 | 339948a05f5217870de25615f36b22bcfadc2dbcc9bf1ec6a6b583f1078a9f41 |
| `2026-08-19-c880-cpb-verify-g8.json` | 286 | b08e2da598dac6b40d12c316640c501b47801f6acde27341e45ea7f1b772c18f |
| `2026-08-19-c880-cpb-verify-g9.json` | 296 | f0b3ec531407f82f261195861144b1dba6bbaf94c65ddd6382741f1b4cd90fed |
