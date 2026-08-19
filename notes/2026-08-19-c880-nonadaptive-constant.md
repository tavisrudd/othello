# 2026-08-19 — C880: the nonadaptive constant, attacked through one-point attachment

**Task:** C880 (`clebsch`), open item 3 of
`notes/clebsch-tasks/c880-aligned-query-complexity.md` — the nonadaptive query
complexity constant for aligned-design reconstruction, bracketed on entry
between the entropy floor \(0.616\,n^2\) and the exhibited family of
\(3n^2-23n+45\) tests. Research and computation only; no manuscript file and no
Lean file is touched.

**Predecessors read before starting:**
`notes/2026-08-07-c880-alignment-separation.md` (§5, the link criterion and the
entropy floor), `notes/2026-08-07-c880-mask-ilp-bound.md` (the exact eight-point
mask bound and why that route is capped at 30),
`notes/2026-08-07-c880-adaptive-and-wording-referee-review.md` (MAJOR 1 and
MAJOR 3 — the two arguments that looked right and were not).

## Result

The bracket narrows from above, by a factor of \(8/3\):

\[
  0.616\,n^2\;\le\;\mathrm{minimum}(n)\;\le\;\tfrac98n^2+O(n)
  \qquad\text{in place of}\qquad
  \mathrm{minimum}(n)\;\le\;3n^2-23n+45 .
\]

The construction is a base of 30 tests on seven points plus one layer per
further point, and a layer is built from blocks of four points costing nine
tests each. Its correctness is a proof — an attachment lemma and a composition
argument — resting on two exhaustively computed constants, \(g(5)=9\) and
\(g(6)=12\), each obtained by three independent solvers. The remaining gap
against the entropy floor is a factor \(1.827\) rather than \(4.87\), and every
exactly computed cost in this report says the floor rather than the
construction is now the loose end.

## Objective and plan, written before any computation

The card names two live routes. This report takes **route (a), a construction
that shares tests between outside pairs**, and drops route (b), the structural
account of weight-four difference masks at general \(n\), for the reason
recorded in "Route (b), and why it was dropped" below.

The plan, in the order it was executed:

1. Reduce the nonadaptive problem to a **one-point attachment problem**: a
   family built as a base on seven points plus, for each further point \(v\),
   a set of tests through \(v\) is separating as soon as each attachment layer
   determines the new point's edges given the two-graph already recovered. This
   is a legitimate nonadaptive construction — nonadaptivity constrains the
   queries, not the decoding — and it converts a quadratic construction problem
   into a linear one, repeated.
2. Identify the attachment problem exactly, as a combinatorial question about
   2-colourings and triples, and check the identification by machine.
3. Compute the exact minimum attachment cost \(g(m)\) for every \(m\) where
   exhaustion is affordable, with a certified lower bound and a verified
   witness family.
4. Turn the measured \(g(m)\) into a construction at general \(n\), or record
   exactly what blocks it.
5. Closeout `ej`+`tt` pass and a mystery ledger.

Everything below is appended in the order it was found, including the dead
ends.

## 1. The reduction: nonadaptive reconstruction is a base plus one-point attachments

**Nonadaptivity constrains the queries, not the decoding.** A fixed family may
therefore be decoded by arbitrary case analysis, and in particular in stages.
Let \(F_7\) be a separating family on the seven points \(\{0,\dots,6\}\) and,
for each \(v=7,\dots,n-1\), let \(\mathcal T_v\) be a set of 4-sets of the form
\(\{v\}\cup T\) with \(T\) a triple of \(\{0,\dots,v-1\}\). Then
\(F=F_7\cup\bigcup_v\{\{v\}\cup T: T\in\mathcal T_v\}\) separates as soon as each
\(\mathcal T_v\) recovers the new point's attachment from the two-graph already
recovered. Write \(g(m)\) for the least size of a family of triples of \(m\)
known points that does this for **every** two-graph on those points. Then

\[
  \mathrm{minimum}(n)\;\le\;30+\sum_{m=7}^{n-1}g(m).
\]

Conversely \(g\) is not a free parameter: if the tests through \(v\) failed to
determine \(v\)'s attachment for some two-graph on the earlier points, no test
outside \(v\) could repair it, because those tests are unchanged. So the
attachment problem is exactly the layer-by-layer content of any construction of
this shape.

### What the attachment problem is, in closed form

Points \(0,\dots,m-1\) carry a known two-graph, represented as usual by a graph
\(e\) with the point \(0\) isolated. The new point \(v\) contributes bits
\(x_p=[v\sim p]\), and \(x\) is defined only up to a global flip (flipping every
\(x_p\) is Seidel switching at \(v\)), so normalise \(x_0=0\); there are
\(2^{m-1}\) candidates. For a triple \(T=\{p,q,r\}\), a two-line computation
from \(\tau(vpq)=x_p+x_q+e_{pq}\) gives

> **Test identity.** \(\{v,p,q,r\}\) is aligned if and only if, for every two
> points \(a,b\) of \(\{p,q,r,v\}\) with third point \(c\) in the triple,
> \(x_a+x_b=e_{ac}+e_{bc}\); two of the three conditions imply the third.
> Equivalently \(x_p+x_q=e_{pr}+e_{qr}\) and \(x_p+x_r=e_{pq}+e_{qr}\).

Two restatements that make the combinatorics visible.

- **Degree parity.** A graph on four points is switching-equivalent to the empty
  graph or to the complete one exactly when its four degrees have equal parity.
  So a 4-set is aligned iff all four induced degrees have the same parity, and
  the test on \(\{v\}\cup T\) asks whether the partition of \(T\) induced by
  \(x\) equals the partition of \(T\) by degree parity in \(e|_T\).
- **A pattern-match on a triple.** Each test therefore reports one bit: *does
  the unknown 2-colouring \(x\) restrict on \(T\) to a prescribed bipartition?*
  Exactly two of the eight colourings of a triple match, which is the measured
  quarter marginal of the entropy floor seen locally, and
  \(g(m)\ge\lceil(m-1)/H(1/4)\rceil\) follows from the same subadditivity
  argument applied inside one layer.

Both restatements are verified by machine rather than trusted: `selfcheck`
checks the degree-parity identity on all 64 four-point graphs and the test
identity against the direct four-triples definition on all
\(2^{10}\cdot2^{5}\cdot20=655{,}360\) (two-graph, attachment, triple) cases at
\(m=6\).

## 2. The exact attachment cost at six points, and the marginal cost of three

**\(g(6)=12\)**, exactly, by three independent solvers agreeing on the same
constraint family, with the optimal family confirmed by an exhaustive sweep over
all \(2^{10}\) two-graphs and all \(\binom{32}{2}=496\) pairs of attachments per
two-graph. One optimal family is

\[
  \{012,013,014,023,024,025,035,123,124,134,234,235\}.
\]

That is already below \(6m-20=16\), the number of tests through one point in the
manuscript's anchor family.

**The marginal cost of an extra known point is at most three**, and the proof is
a pigeonhole on one bit.

> **Attachment lemma.** Let \(C\) be a set of six of the known points and
> \(\mathcal C\) a family of triples inside \(C\) that determines \(x|_C\) for
> every two-graph on \(C\). Fix a triple \(T_0=\{t_1,t_2,t_3\}\subseteq C\).
> Then
> \(\mathcal C\cup\{\{t_i,t_j,w\}: 1\le i<j\le3,\ w\notin C\}\)
> determines \(x\).
>
> *Proof.* The tests of \(\mathcal C\) involve only points of \(C\); their
> answers depend only on the two-graph restricted to \(C\) and on \(x|_C\), so
> they determine \(x|_C\) (normalise the global flip by \(x_{t_1}=0\)). Fix
> \(w\notin C\) and put \(s_i=x_{t_i}+e_{t_iw}\), a known bit. By the test
> identity, \(\{v,t_i,t_j,w\}\) is aligned iff
> \(x_{t_i}+x_{t_j}=e_{t_iw}+e_{t_jw}\) — that is, \(s_i=s_j\) — and
> \(x_{t_i}+x_w=e_{t_it_j}+e_{t_jw}\). Three bits \(s_1,s_2,s_3\) cannot be
> pairwise distinct, so some \(s_i=s_j\); for that pair the first condition
> holds and is known to hold, so the answer is exactly the truth value of the
> second, which determines \(x_w\). \(\square\)

Hence \(g(m)\le g(6)+3(m-6)=3m-6\) for every \(m\ge6\), and

\[
  \mathrm{minimum}(n)\;\le\;30+\sum_{m=7}^{n-1}(3m-6)
  \;=\;\tfrac32n^2-\tfrac{15}2n+9 .
\]

**This halves the manuscript's constant**, from \(3n^2-23n+45\) to
\(1.5n^2-7.5n+9\), and cuts the asymptotic gap against the entropy floor
\(0.616\,n^2\) from a factor \(4.87\) to a factor \(2.435\). At \(n=7\) it
returns exactly the known optimum 30; at \(n=8\) it gives 45 against the
manuscript's 53 and the best known 44; at \(n=9\), 63 against 81; at \(n=20\),
459 against 785.

The lemma's family is checked, not merely derived: it separates for every one of
the \(2^{15}\) two-graphs at \(m=7\), every one of the \(2^{21}\) at
\(m=8\), and every one of the \(2^{28}\) at \(m=9\), where it has
\(3\cdot9-6=21\) members. Section 3 supersedes it: the same layer can be
built from 2.25 tests per point instead of 3.

## 3. Sharing between outside pairs: blocks of four, and \(1.125\,n^2\)

The attachment lemma spends three private tests on each old point outside the
core. The card's route (a) asks for a construction that **shares** tests, and
the attachment picture says exactly where sharing can live: inside one layer,
between the old points whose attachment bits are still unknown.

### The marginal problem

Write \(P(k,j)\) for the least number of triples that determine the new point's
attachment on \(j\) further old points, given that it is already known on \(k\)
old points, for every two-graph on the \(k+j\) points. Tests may use any of the
\(k+j\) points. The gauge fixes the attachment at one point for free, so
\(P(1,j)=g(j+1)\), and \(P\) is what the layer's cost is really made of. Two
facts make \(P\) the right object.

- **\(P(k,j)\) does not depend on \(k\) beyond a point.** Measured:
  \(P(4,2)=P(5,2)=P(6,2)=6\); \(P(3,3)=P(4,3)=P(5,3)=8\); \(P(3,4)=P(4,4)=9\).
  Extra known points do not buy anything at these sizes.
- **\(P(1,\cdot)\) is subadditive**, because blocks of fresh points share only
  the gauge point: a family for a block depends on the two-graph restricted to
  that block plus the anchor, and on the attachment there, so it keeps working
  when other points are present. That transfer is checked directly, not
  assumed: the nine-triple block family on \(\{0\}\cup\{4,5,6,7\}\) determines
  the attachment on \(\{4,5,6,7\}\) given it on \(\{0,1,2,3\}\), for every one
  of the \(2^{21}\) two-graphs on eight points.

### The measured values

| block size \(j\) | \(P(1,j)\) | per point | how |
|---|---|---|---|
| 1 | \(\infty\) (needs two anchors; \(P(k,1)=3\) for \(k\ge3\)) | 3 | exact |
| 2 | \(P(k,2)=6\) | 3 | exact |
| 3 | \(P(k,3)=8\) | 2.667 | exact |
| **4** | **\(P(1,4)=g(5)=9\)** | **2.25** | exact |
| 5 | \(P(1,5)=g(6)=12\); \(P(2,5)=12\) | 2.4 | exact |
| 6 | \(P(1,6)=g(7)=15\) | 2.5 | exact |
| 7 | \(g(8)\le17\) | \(\le2.43\) | verified family |

Every entry marked exact is a minimum hitting set of the **complete** family of
difference masks — every pair of attachments agreeing on the known set, over
every two-graph — so it is a true minimum, not a bound from a truncated
constraint set; only the last row is an upper bound. The \(j=4\) row is the
best ratio, and the optimal family is transparent:

> **The block of four.** For a block \(B=\{b_1,b_2,b_3,b_4\}\) of fresh points
> and the anchor \(0\), take the six triples \(\{0,b_i,b_j\}\) and the three
> triples of \(B\) that contain \(b_1\). Nine tests determine the attachment on
> \(B\).

Three of the nine tests have all their points inside \(B\), so they serve three
outside pairs at once; the six anchored ones serve two. That is the sharing the
link criterion said any improvement would have to find.

### The construction and its size

Blocks meet only in the gauge point, so a layer decomposes with no interaction:
partition the old points other than \(0\) into blocks of four, with one final
block of four to seven points handled by the stored small family. Hence

\[
  g(m)\;\le\;9\left\lceil\frac{m-1}4\right\rceil,\qquad
  \mathrm{minimum}(n)\;\le\;30+\sum_{m=7}^{n-1}g(m)\;=\;\tfrac98 n^2+O(n).
\]

| \(n\) | block construction | anchor family \(3n^2-23n+45\) | entropy floor | ratio to floor |
|---|---|---|---|---|
| 7 | 30 | 31 | 18 | 1.67 |
| 8 | 45 | 53 | 25 | 1.80 |
| 9 | 62 | 81 | 34 | 1.82 |
| 10 | 80 | 115 | 44 | 1.82 |
| 16 | 241 | 445 | 129 | 1.87 |
| 20 | 393 | 785 | 210 | 1.87 |
| 32 | 1065 | 2381 | 572 | 1.86 |
| 40 | 1693 | 3925 | 913 | 1.85 |

**So the nonadaptive constant is at most \(9/8=1.125\)**, against the
manuscript's 3, and the asymptotic gap against the entropy floor
\(0.616\,n^2\) falls from a factor 4.87 to a factor **1.827**. At \(n=7\) the
construction returns the known exact optimum 30, and at \(n=8\) it gives 45
against the best previously known 44 — so it is not optimal at the smallest
size, and the improvement is asymptotic.

### End-to-end verification, from the alignment definition

The composition is proved, but it is also checked whole. `fullverify` builds
the entire family at \(n\) points — the optimal 30 on the first seven, then one
layer per further point — evaluates each test by the four-triples definition of
alignment (not by the attachment identity used to design it), and requires the
answer map's fibres to be exactly the complement pairs. At \(n=7\) the 30 tests
give 16,384 distinct answer vectors on 32,768 two-graphs; at \(n=8\) the 45
tests give 1,048,576 on 2,097,152. Both pass.

## 4. Route (b), and why it was dropped

The card offers a second route: a structural account of the weight-four
difference masks at general \(n\), the mechanism that produced the exact
eight-point lower bound of 30. It was not taken, for a reason the predecessor
report already establishes rather than a guess.

`notes/2026-08-07-c880-mask-ilp-bound.md` proves that the 315 weight-four masks
at eight points **are** the 315 weight-two masks at seven points, transported by
the correspondence between four-subsets of a seven-set and four-four splits of
an eight-set, and that their hitting number is \(35\) minus the largest partial
spread of \(\mathrm{PG}(3,2)\), namely 30 at both sizes. Its own mystery ledger
names the possibility that minimum-weight differences are always inherited from
a seven-point subconfiguration, in which case the hitting-set route is capped at
30 for **every** \(n\) and yields nothing asymptotically. Nothing found here
contradicts that, and the enumeration that would decide it — the minimum-weight
difference spectrum at nine points, a scan over pairs drawn from \(2^{28}\)
two-graphs, of order \(10^{16}\) — is the computation the predecessor recorded
as out of reach of its program, and nothing in this report's toolkit makes it
cheaper. The \(2^{28}\) sweeps run here are single passes over the two-graphs,
not passes over their pairs.

Weighed against that, route (a) had a concrete testable mechanism (sharing,
which the link criterion says any improvement must use), it moves the quantity
the manuscript actually prints, and — as it turned out — it admits a proof
rather than a certificate. That is why it was taken.

## 5. A second lower bound, and why it does not help

One lower-bound idea was pursued far enough to be settled, and it is recorded
because it is settled negatively with an exact reason rather than abandoned.

An alignment test is the conjunction of two \(\mathbf F_2\)-linear conditions,
so a **yes** answer pins the two-graph to a codimension-two affine subspace and
a **no** answer merely excludes one. Fix a separating family \(F\) of \(k\)
tests and a two-graph \(\tau\); let \(y\) be the number of tests answering yes.
The yes answers impose at most \(2y\) linear conditions, so the affine space
\(V\) of two-graphs matching every yes answer has dimension
\(d\ge D-2y\), where \(D=\binom{n-1}2\). Every \(\tau'\in V\) reproduces all the
yes answers, so separation forces the no tests to cover \(V\setminus\{\tau,
\bar\tau\}\) by their codimension-two flats. Taking the product of the flats'
indicator polynomials, a polynomial of degree at most twice the number of no
tests equals the indicator of the antipodal pair \(\{\tau,\bar\tau\}\), whose
multilinear degree is \(d-1\). Hence

\[
  k-y\;\ge\;\frac{d-1}2\;\ge\;\frac{D-2y-1}2,
  \qquad\text{so}\qquad k\;\ge\;\frac{D-1}2\;\approx\;\tfrac14n^2 .
\]

The bound is real, it is proved, and it is **weaker than the entropy floor
\(0.616\,n^2\) at every \(n\)**, because the \(y\)-dependence cancels exactly.
It is a genuinely different mechanism — covering rather than counting — so it
is worth having on file, but it does not move the bracket, and no way was found
to combine it with the entropy argument.

## 6. What the bracket now is

\[
  0.616\,n^2\;\le\;\mathrm{minimum}(n)\;\le\;\tfrac98n^2+O(n),
\]

a factor of **1.827** rather than the 4.87 the task card recorded. The lower end
is unchanged — the entropy floor of the predecessor report, whose content is the
measured quarter marginal — and the upper end is the block construction above,
proved and machine-checked layer by layer and end-to-end at seven and eight
points. The whole replay list was re-run from the committed generator in a
clean environment after its last edit, and every certificate reproduced byte
for byte.

Against the other two reference numbers: the counting bound \(n(n-3)/2\) is a
factor \(2.25\) below the construction, and the adaptive decoder's
\(\binom n2+n-4\) is a factor \(2.25\) below it as well — so nonadaptive
reconstruction now costs at most about \(2\tfrac14\) times what an adaptive
decoder pays, where the manuscript's family cost about six times.

The separation range of the card's open item 2 moves with this. Adaptivity is
proved to beat every fixed family from \(n=19\) on, using the entropy floor;
that argument is untouched, because it compares the adaptive bound to a
**lower** bound on nonadaptive cost. But the reverse comparison changes: the
adaptive bound \(\binom n2+n-4\) and the nonadaptive construction
\(\tfrac98n^2\) now differ by a factor tending to \(2.25\), not 6, so the
price of nonadaptivity in this model is much smaller than the manuscript's
numbers suggest.

## 7. What is proved, what is measured, and what is trusted

**Proved by hand, no computation involved.**
- The test identity and its degree-parity form, and the reduction of a
  nonadaptive family to a base plus attachment layers.
- The attachment lemma (three tests per outside old point), by pigeonhole.
- Composition of blocks: a block family's answers depend only on the two-graph
  restricted to the block plus its anchor and on the attachment there, so a
  block family keeps working inside a larger point set and blocks meeting only
  in the gauge point do not interact. This is what turns the finite block fact
  into the bound at every \(n\).
- The covering lower bound \(k\ge(\binom{n-1}2-1)/2\) of section 5, and that it
  is dominated by the entropy floor.

**Exact, by exhaustive computation over a complete constraint family.**
\(g(5)=9\), \(g(6)=12\), \(g(7)=15\), and the marginal values \(P(k,1)=3\),
\(P(k,2)=6\), \(P(k,3)=8\), \(P(k,4)=9\), \(P(2,5)=12\) for the \(k\) listed in
section 3.
Each is a minimum hitting set of every difference mask arising from any
two-graph and any pair of attachments agreeing on the known set, so the value
is both a lower bound (every mask must be hit) and an upper bound (the hitting
set is checked to separate). \(g(5)\) and \(g(6)\) are confirmed a second and
third time by HiGHS and by CBC on the same committed constraint files, and
\(g(7)=15\) is HiGHS on the complete \(m=7\) constraint file — 46,837
inclusion-minimal masks — matching the family the search had already found and
`verifymarginal` had already certified.

**Upper bound with a verified witness, not proved optimal.** \(g(8)\le17\): an
explicit family checked against every two-graph on eight points. It enters only
the additive constant of the construction, never its leading term.

**Not deterministic, and therefore not evidence.** The generator's `build` mode
is a lazy greedy search whose violation sampling depends on thread scheduling;
it was used to *find* the \(g(7)\) and \(g(8)\) witnesses and its own output is
not a certificate. Every number quoted above comes from a deterministic mode.

**The trusted boundary** is the alignment predicate and the switching-class
indexing. Both are re-derived inside the program: `selfcheck` proves the
degree-parity identity on all 64 four-point graphs, and checks the attachment
identity against the direct four-triples definition on all 655,360
(two-graph, attachment, triple) cases at \(m=6\). `fullverify` evaluates the
final family from the four-triples definition alone, so the end-to-end check
does not reuse the identity the construction was designed around.

**What the computations do not certify.** Nothing here is exhaustive above the
sizes listed: \(g(m)\) is bounded, not computed, for \(m\ge8\); the block
values are exact only for block size at most 6; and the end-to-end check of the
whole family runs at \(n=7\) and \(n=8\) only, with the \(m=9\) attachment
layer checked separately over all \(2^{28}\) two-graphs. Everything at larger
\(n\) rests on the composition proof.

## 8. Closeout pass: what is surprising, and what it changes

**The entropy floor is probably not the truth, and every measurement says so.**
Every exactly computed cost in this report sits between 2.25 and 3 tests per
recovered bit, where the entropy floor licenses 1.2326: the exact nonadaptive
minimum at seven points is 30 against a floor of 18, and the exact block costs
are 3, 3, 2.667, 2.25, 2.4 and 2.5 tests per bit. There is a heuristic reason to
expect the truth near 2.4 rather than near 1.23. A **no** answer removes a
quarter of the candidates, so covering all but the antipodal pair of a
\(d\)-dimensional space with such quarters takes about
\(\log2/\log(4/3)=2.409\) tests per dimension if the quarters behaved like
random ones. The measured 2.25 for a block of four is just below that, which is
what one expects of a designed family rather than a random one. So the right
reading of the bracket is that the upper end has moved most of the way and the
lower end is the loose one — the opposite of how a gap of a factor 1.83 usually
reads.

**Blocks of four are the sweet spot, and the reason is visible.** The block
family spends \(\binom j2\) anchored tests plus a linear number of internal
ones, so its cost per point falls while \(j\le4\) and the quadratic term takes
over after; \(j=5\) already costs 2.4 per point and \(j=6\) costs 2.5, against
2.25.

**The construction is not optimal at the one size where both numbers exist.**
At eight points it gives 45 where iterated local search found 44, and with
\(g(7)=15\) exact neither of its two parts is slack. What that does *not* show
is that the base-plus-layers shape is itself lossy: a layered family need not
have a base that separates on its own, since the layer's answers also depend on
the earlier two-graph. Whether the shape costs a constant factor asymptotically
is open, and it is the first thing a successor should ask, because the whole
\(9/8\) rests on it.

**Two consequences outside this task.** First, the manuscript's factor-six
statement — that an adaptive decoder beats the exhibited family by a factor
tending to six — remains true of *that family*, but the factor is now known to
be a property of the construction and not of nonadaptivity: the nonadaptive
problem costs at most about \(2\tfrac14\) times the adaptive bound. Any
sentence that reads the six as the price of nonadaptivity is wrong, and this
report is what a wording task would need. Second, the predecessor report's
compression table (its §8.2, "determining family" against \(\binom n4\)) is
superseded by these numbers: at \(n=64\) the determining family drops from
10,861 to 4,441, against the entropy floor 2,407.

Neither observation is acted on here: manuscript wording belongs to C816 and
C824, and the predecessor report is another task's record.

## 9. Mystery ledger

| open item | what is surprising or unexplained | what the closeout settled | exact evidence gap or successor |
|---|---|---|---|
| The factor 1.83 between \(0.616\,n^2\) and \(\tfrac98n^2\) | Every exactly computed cost in this report is 2.25 to 3 tests per recovered bit, never near the entropy floor's 1.2326 — including the exact seven-point minimum, 30 against a floor of 18. | The closeout supplies a reason to expect the floor to be the loose end: covering a \(d\)-dimensional space by quarter-sized flats, which is what a **no** answer does, costs about \(\log2/\log(4/3)=2.409\) per dimension for random flats, and every measured design sits just under that. | Not a bound. What is wanted is a covering lower bound for this specific family of codimension-two flats. Section 5 shows the direct polynomial-method version caps at \(\tfrac14n^2\), below the entropy floor, so a sharper argument has to use that the flats come from alignment tests. Unowned. |
| Whether some block larger than four beats \(9/4\) | Costs per point run 3, 3, 2.667, **2.25**, 2.4, 2.5 for block sizes 1 to 6, so the minimum is interior and might recur. | Block sizes 1 through 6 are exact against a single anchor, and none beats 2.25; the two-anchor value \(P(2,6)\) satisfies \(P(2,6)\le P(1,6)=15\) and would have to be at most 13 to beat \(9/4\). | Not decided. The exhaustive route is the \(2^{21}\)-two-graph sweep at \(m=8\) with a two-point anchor, which yields 752,179 inclusion-minimal masks; neither the branch and bound on a 1,500-mask capped pool (killed at 100 s) nor HiGHS on the full family (killed at 6 GB resident) resolved it. Successor: a symmetry-reduced integer program, or a structural cost formula for a block. |
| Whether the base-plus-layers shape is lossy | The construction gives \(30+g(7)=45\) at eight points, while the predecessor's iterated local search found a separating family of 44. | The construction is not optimal at the only size where both numbers are known, and with \(g(7)=15\) now exact the 45 is not slack in either of its two parts. But the shape itself is not proved lossy: a layered family need not have a base that separates on its own, since the layer's answers also depend on the earlier two-graph, so 45 is not a lower bound for the shape. | Whether the loss is \(O(1)\) or a constant factor is open, and it is the assumption the whole \(9/8\) rests on. Deciding it needs the exact nonadaptive minimum at \(n=8\) or \(n=9\), which the predecessor already recorded as out of reach by its method. |
| Exact \(g(8)\) | The attachment cost is exact at \(m=5,6,7\) (9, 12, 15) and only bounded above at \(m=8\). | **Settled for \(m=7\):** \(g(7)=15\), by HiGHS on the complete family of 46,837 inclusion-minimal masks, matching the certified witness. So \(g(5),g(6),g(7)=9,12,15\) rises by exactly the attachment lemma's three per extra old point, even though the four-point block shows the eventual marginal is 2.25; the \(g(8)\le17\) witness is the first step that does better than three. | \(g(8)\) is still only bounded above. The \(m=8\) mask sweep is affordable but its constraint family is two orders of magnitude larger than the \(m=7\) one; the same HiGHS route is the obvious successor. These constants change only the additive \(O(n)\) term, never the \(9/8\). |
| Why the marginal cost stops depending on the known set | \(P(k,j)\) is the same for every \(k\) measured — \(P(4,2)=P(5,2)=P(6,2)\), \(P(3,3)=P(4,3)=P(5,3)\), \(P(3,4)=P(4,4)\), and even \(P(1,4)=P(2,4)\). | Explained on one side: the block family that realises the optimum uses only the gauge point, so extra known points are simply unused. Why they cannot help at all is not explained. | A proof that the optimum never uses more than one anchor would make the composition argument cleaner and is finitely checkable at each \(j\); not attempted. |

No mystery is manufactured here: the first row is the one that matters, and it
says the remaining factor is more likely to be closed from below than from
above.

## 10. Reproduction

The block below is self-contained: it assumes nothing but `rustc` and `uv` on
the path, and sets its own working directory and scratch directory in its first
two lines. `rustc 1.93.1`, `rustc -O`, no
external crates; every mode is deterministic — canonical enumeration, no
randomness, and the thread count changes nothing because every collection is
sorted before use. Run in place, the block rewrites exactly the committed
certificates and must leave the worktree clean.

```sh
cd /home/tavis/src/othello/notes          # or <your checkout>/notes
S=$(mktemp -d)

rustc -O -o $S/c880nc 2026-08-19-c880-nonadaptive-constant.rs

# the identities the reduction rests on
$S/c880nc selfcheck > 2026-08-19-c880-selfcheck.txt

# exact attachment costs g(5) = 9 and g(6) = 12
$S/c880nc marginal --m 5 --known 1 --out 2026-08-19-c880-attach-g5.json
$S/c880nc marginal --m 6 --known 1 --out 2026-08-19-c880-attach-g6.json

# exact marginal costs P(k,j): 3, 6, 8, 9, 12, 15 for j = 1..6
$S/c880nc marginal --m 8 --known 7 --out 2026-08-19-c880-marginal-k7j1.json
$S/c880nc marginal --m 6 --known 4 --out 2026-08-19-c880-marginal-k4j2.json
$S/c880nc marginal --m 7 --known 5 --out 2026-08-19-c880-marginal-k5j2.json
$S/c880nc marginal --m 8 --known 6 --out 2026-08-19-c880-marginal-k6j2.json
$S/c880nc marginal --m 6 --known 3 --out 2026-08-19-c880-marginal-k3j3.json
$S/c880nc marginal --m 7 --known 4 --out 2026-08-19-c880-marginal-k4j3.json
$S/c880nc marginal --m 8 --known 5 --out 2026-08-19-c880-marginal-k5j3.json
$S/c880nc marginal --m 6 --known 2 --out 2026-08-19-c880-marginal-k2j4.json
$S/c880nc marginal --m 7 --known 3 --out 2026-08-19-c880-marginal-k3j4.json
$S/c880nc marginal --m 8 --known 4 --out 2026-08-19-c880-marginal-k4j4.json
$S/c880nc marginal --m 7 --known 2 --out 2026-08-19-c880-marginal-k2j5.json   # ~10 min

# the attachment lemma's own family, 3m-6 tests, at m = 7, 8, 9 (the last ~2 min)
$S/c880nc template --m 7 --t0 0,1,2 --out 2026-08-19-c880-template7.json
$S/c880nc template --m 8 --t0 0,1,2 --out 2026-08-19-c880-template8.json
$S/c880nc template --m 9 --t0 0,1,2 --out 2026-08-19-c880-template9.json

# the witness families realising g(7) = 15 and g(8) <= 17
$S/c880nc verifymarginal --m 7 --known 1 \
  --family "0,1,2;0,1,4;0,1,6;0,2,4;0,2,6;0,4,6;1,2,4;1,2,6;1,3,4;1,3,6;1,4,5;1,5,6;2,4,6;3,4,6;4,5,6" \
  --out 2026-08-19-c880-attach-g7-witness.json
$S/c880nc verifymarginal --m 8 --known 1 \
  --family "0,1,2;0,1,4;0,1,5;0,2,4;0,2,5;0,4,5;1,2,3;1,2,5;1,2,6;1,2,7;1,3,6;1,3,7;1,4,5;1,6,7;2,3,6;2,3,7;2,5,6" \
  --out 2026-08-19-c880-attach-g8-witness.json

# a block family keeps working inside a larger known set
$S/c880nc verifymarginal --m 8 --known 4 \
  --family "0,4,5;0,4,6;0,4,7;0,5,6;0,5,7;0,6,7;4,5,6;4,5,7;4,6,7" \
  --out 2026-08-19-c880-blocktransfer.json

# two blocks of four compose: g(9) <= 18, over every two-graph on nine points (~4 min)
$S/c880nc verifymarginal --m 9 --known 1 \
  --family "0,1,2;0,1,3;0,1,4;0,2,3;0,2,4;0,3,4;1,2,3;1,2,4;1,3,4;0,5,6;0,5,7;0,5,8;0,6,7;0,6,8;0,7,8;5,6,7;5,6,8;5,7,8" \
  --out 2026-08-19-c880-chain9.json

# the whole family, evaluated from the four-triples definition of alignment
$S/c880nc fullverify --n 7 --out 2026-08-19-c880-fullverify7.json
$S/c880nc fullverify --n 8 --out 2026-08-19-c880-fullverify8.json

# the construction's size against the anchor family and both lower bounds
$S/c880nc blocktotals --nmax 64 --out 2026-08-19-c880-blocktotals.json

# independent replay of g(5) and g(6) by two further solvers
C880NC_DUMP=2026-08-19-c880-masks-g5.json $S/c880nc marginal --m 5 --known 1
C880NC_DUMP=2026-08-19-c880-masks-g6.json $S/c880nc marginal --m 6 --known 1
uv run --with numpy --with scipy --with pulp python3 2026-08-19-c880-attach-ilp.py \
    --masks 2026-08-19-c880-masks-g5.json --out 2026-08-19-c880-ilp-g5.json --cbc
uv run --with numpy --with scipy --with pulp python3 2026-08-19-c880-attach-ilp.py \
    --masks 2026-08-19-c880-masks-g6.json --out 2026-08-19-c880-ilp-g6.json --cbc

# exact g(7) = 15 on the complete m=7 constraint family (HiGHS, ~40 min)
C880NC_DUMP=2026-08-19-c880-masks-g7.json $S/c880nc marginal --m 7 --known 1
uv run --with numpy --with scipy --with pulp python3 2026-08-19-c880-attach-ilp.py \
    --masks 2026-08-19-c880-masks-g7.json --out 2026-08-19-c880-ilp-g7.json
```

Everything except `marginal --m 7 --known 2`, `verifymarginal --m 9` and the
final integer program runs in seconds to a couple of minutes on 24 threads.

**Independent replay.** \(g(5)=9\) and \(g(6)=12\) are each produced three
times: by the generator's own branch and bound, by HiGHS through
`scipy.optimize.milp`, and by CBC through PuLP, the last two on committed
constraint files that the Python driver re-checks against a freshly derived
triple indexing before solving. \(g(7)=15\) is produced twice, by HiGHS on the
complete constraint file and by the certified witness family, which pin the
value from below and above. The composition that turns these numbers
into the bound at every \(n\) is proved by hand, and separately confirmed at
\(m=9\) by exhaustive sweep and at \(n=7,8\) end-to-end from the alignment
definition. The `build` mode has no independent replay and is not used as
evidence; the families it found are certified by the deterministic
`verifymarginal` runs above.

**Replay status.** The block above was run verbatim in a clean environment —
fresh scratch directory, generator rebuilt from the committed source — after
the generator's last edit. Every certificate it writes came back byte for byte
identical to the committed file, so the bundle contains no output of a
superseded code path.

**What is not replayed.** \(g(8)\) is bounded, not computed, and the two-anchor
value \(P(2,6)\) is undecided — though the one-anchor value \(P(1,6)=g(7)=15\)
is now exact, so a block of six does not beat a block of four in the shape the
construction actually uses. The searched domains and stop conditions are in the
mystery ledger.

### Artifacts

The `.md` row is the report itself and is excluded; every other file below is
either the generator, its driver, or an output of the replay list above.

| file | bytes | sha256 |
|------|-------|--------|
| `2026-08-19-c880-nonadaptive-constant.rs` | 47059 | ddddaaf35f066a2c90a2a851dcfa93b4c47ff90d1920029d8d62d54387ec74aa |
| `2026-08-19-c880-attach-ilp.py` | 4793 | 4d7e4c2ae234750db23c851f65288bbda0880873a1cabee31ac840914b9d8496 |
| `2026-08-19-c880-selfcheck.txt` | 155 | b42e884d44bf3633d3a21d79ad420bbb208d97337ec90cbdf4297a7e4b56e7ca |
| `2026-08-19-c880-attach-g5.json` | 315 | d72cceece17665aec4e4e532d10bbf2234662fb60576a7a15acac8fa08772ef1 |
| `2026-08-19-c880-attach-g6.json` | 350 | 8b1f55c63b4544ad5db1d35e8d4292a88cec04a0d2e4c979ec7970c4f8b619ef |
| `2026-08-19-c880-attach-g7-witness.json` | 155 | bd374599c69f90cf89c73eb03831dfd57218c0d50a5ee28234fec7fb6de11a30 |
| `2026-08-19-c880-attach-g8-witness.json` | 157 | 30b1162f65f9c007724fbc1af14e6070aa9af90ee37e6c44b72a3f2b0c6ad53e |
| `2026-08-19-c880-marginal-k7j1.json` | 276 | a93bf81494ce19ca47471c927c29a31295dcc7d3085e5079e1b49056c206c786 |
| `2026-08-19-c880-marginal-k4j2.json` | 293 | 1f7c0c12362e04102a6775074f5a53dc6a2e49e024b171c9384e987add85fb7a |
| `2026-08-19-c880-marginal-k5j2.json` | 298 | c3ed32d84edf9470576cbe044c19e33e36b3d10a7a014d508c260c25a4494aaf |
| `2026-08-19-c880-marginal-k6j2.json` | 304 | a648b5f80170695e8c08540089fca5b55de9b8854e9d8338291860687f072ff7 |
| `2026-08-19-c880-marginal-k3j3.json` | 312 | 6c95d528226dc48e73d2f032aea77bdc6ba8793863154f4a4c1240beb5fe0afa |
| `2026-08-19-c880-marginal-k4j3.json` | 317 | 4d546a95e19a7569a611df6288ac6920584776fb8fda111d55e51f0414848740 |
| `2026-08-19-c880-marginal-k5j3.json` | 323 | d83b6ff6e21fdef83d8e3d034561f660a68ea6f8123f292dab401ef0fd8ac46f |
| `2026-08-19-c880-marginal-k2j4.json` | 322 | c7400cfe9311e39233914a2c5342cbc00ceabe8cb0a5d864d2fa0d9028b0ae51 |
| `2026-08-19-c880-marginal-k3j4.json` | 328 | 1bdccbbca036062ae271c8b8cde7a93bb884058ff8ae70b35d02499fed744f98 |
| `2026-08-19-c880-marginal-k4j4.json` | 334 | 72d757ffa6ca2a1ceb974d5f8470ee8b2b6fd14dd22a7df41a459ff3d4053519 |
| `2026-08-19-c880-marginal-k2j5.json` | 356 | ee7b7ea6268b3951a9fa2843a239dc89f65bd46c956c3b85590765a161a94f79 |
| `2026-08-19-c880-blocktransfer.json` | 156 | 18662b03bcec60ecf1cb1b338ca47191ddecc6c18b0c56cabc09c7fcf00aa69f |
| `2026-08-19-c880-template7.json` | 332 | 366b4fdbd8bc343187bffff7620ce6b7266c227568d65950e1510f2a9e32fa84 |
| `2026-08-19-c880-template8.json` | 359 | 5fee0081f0a6099ec3380b3a7e2e6811a8ea88494fefb56e4b1112d02bf23112 |
| `2026-08-19-c880-template9.json` | 385 | 5cf162922ad6216ffdb4e92a20f4868e5ef21ba4f202ec29e312824a2a84888a |
| `2026-08-19-c880-chain9.json` | 159 | d766794cc52699db00f9843276cb66b04fbbc8ed171b0d563387afcc1d31e237 |
| `2026-08-19-c880-fullverify7.json` | 244 | 679e11095bb2115d8425b3c9da88eef5aa834357e3532e1cf6db9c6465cd703f |
| `2026-08-19-c880-fullverify8.json` | 250 | 598f68cb759c268fc7abfa97dd5872bcd0fc89c3cf9d6c0a8db41617fdffafbb |
| `2026-08-19-c880-blocktotals.json` | 8046 | c943d8f610dd7cffcce1a4f8bb98789feea554db788b154f74cf7b7e8d1fafe0 |
| `2026-08-19-c880-masks-g5.json` | 746 | 1b750156f05e7c301863d196230418779a9fbb29161326ce7fccb60f054d5814 |
| `2026-08-19-c880-masks-g6.json` | 25878 | 55f22b0cba7fccbc5fd77288405270f0fe3b9152f0d09ed5f8710cd0b78d12d3 |
| `2026-08-19-c880-ilp-g5.json` | 460 | 7dde02a289907f68126243e29317c34ce87430760678a82077529a1d81a8811e |
| `2026-08-19-c880-ilp-g6.json` | 494 | 26e68a30a06a86414d87cb3dee2c80afbb1f2929093c3964f9ef9e9c4c284e2f |
| `2026-08-19-c880-masks-g7.json` | 1960509 | f8f8a68d1263e1666a86b2571e50f36a0e14a9988b46b0143bb94c0aadaa0c34 |
| `2026-08-19-c880-ilp-g7.json` | 479 | 2c2e7f6e80e9a1cbb549407fe56f7c6690d742e7c5f7b92bee11ea7270f989ae |

Every one of these outputs was regenerated from the committed generator after
its last edit and compared byte for byte against the committed file.
