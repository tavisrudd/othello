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

The lemma's family is checked, not merely derived: for \(m=7\) it separates for
every one of the \(2^{15}\) two-graphs and every choice of the core triple
\(T_0\) tried, and for \(m=8\) for every one of the \(2^{21}\) two-graphs.
