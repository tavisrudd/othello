# 2026-08-07 — C880 work item 7: drafted manuscript wording for the aligned-design query claims

**Task:** C880 (lane `clebsch`), work item 7 of
`notes/clebsch-tasks/c880-aligned-query-complexity.md`.

**Status:** complete for every C880 finding that has survived validation and the
audit as of this date, including the adaptive decoder, whose text is in the
addendum at the end. A referee pass on the same date is applied throughout:
`notes/2026-08-07-c880-adaptive-and-wording-referee-review.md`.

**Boundary.** No manuscript file is edited here. C816 owns promotion and C824
owns the final Paper III pass; either may reject or reshape any of this. Every
draft below quotes the exact lines it replaces, in
`papers/clebsch-passages/sections/05-golden-operator.tex`,
`sections/08-verification.tex`, `sections/10-references.tex`, and
`literature-boundaries.md`.

**Sources this drafting is bound by.** The verdicts and constraints come from
`notes/2026-08-07-c880-literature-audit.md` (item 6) and
`notes/2026-08-07-c880-tetrad-screen.md` (the vanishing-tetrad screen); the
mathematics comes from `notes/2026-08-07-c880-alignment-separation.md` and
`notes/2026-08-07-c880-mask-ilp-bound.md`. Style per `papers/style-guide.md`.

---

## The five constraints, and where each is discharged

| Constraint | Source | Discharged in |
|---|---|---|
| Name the order-four indicator restriction, against the published \(O(n^2)\) value-oracle principal-minor algorithms | audit, verdict C | Draft 1 (final clause) and Draft 2 (first paragraph) |
| Cite Greaves and Suda for the determinant-\((-3)\) fibre rather than stating it | audit, verdict F | Draft 1 (first sentence) and Draft 5 |
| Present the entropy bound as an application of the standard search-theoretic bound, its content being the quarter marginal | audit, verdict D(ii) | Draft 2 (second paragraph) |
| Cite Kummerfeld and Ramsey for a deployed four-set indicator oracle; claim no speedup against it | tetrad screen, consequence 1 | Draft 2 (third paragraph) |
| Do not use "nonredundant"; say "removable without losing separation" in full | tetrad screen, consequence 3 | Draft 6, and nowhere else does the word occur in any draft |

Two further positioning requirements are discharged with them: the six-point
sharpness is placed explicitly against Dammak, Lopez, Pouzet and Si Kaddour
(Draft 4), and no draft contains "first", "new", or an unqualified priority
claim — every novelty-bearing sentence lives in the `OPER-4` ledger row
(Draft 9) and the manuscript quotes none of it.

---

## Draft 1 — the theorem statement

**Replaces** `sections/05-golden-operator.tex` lines 236--247, currently:

```tex
For a symmetric conference matrix of order \(n\geq10\), its marked family of
principal four-subsets with determinant \(-3\) therefore determines its
signing up to diagonal switching and global negation.  After one aligned
four-set \(Q\) is known, the
\[
 1+4(n-4)+6\binom{n-4}{2}=3n^2-23n+45
\]
tests on four-sets meeting \(Q\) in at least two points suffice, and the
decoder in the proof uses exactly this many.
An aligned anchor is found deterministically with at most twenty tests, so
the complete marked reconstruction uses \(O(n^2)\) selected determinants.
One calibrated triangle product selects between the two global orientations.
```

**With:**

```tex
For a symmetric conference matrix of order \(n\geq10\), its marked family of
principal four-subsets with determinant \(-3\), which is the design of
Greaves and Suda \cite[Table~1 and Example~2.3]{GreavesSuda}, therefore
determines its signing up to diagonal switching and global negation.  After
one aligned four-set \(Q\) is known, the
\[
 1+4(n-4)+6\binom{n-4}{2}=3n^2-23n+45
\]
tests on four-sets meeting \(Q\) in at least two points suffice, and the
decoder in the proof uses exactly this many.  An aligned anchor is found
deterministically with at most twenty tests.  Each of those queries reads one
bit, whether a single fourth-order principal minor equals \(-3\); the
reconstruction consumes no minor value and no minor of any other order.
One calibrated triangle product selects between the two global orientations.
```

**What changed and why.** The clause "so the complete marked reconstruction
uses \(O(n^2)\) selected determinants" is deleted. Read against the
principal-minor assignment literature it is not a contribution: the same
reconstruction up to the same gauge is already done in \(O(n^2)\) queries by
published algorithms that call their count asymptotically optimal, and for a
Seidel matrix in \(\binom n2-n+1\) queries of order three. What is particular to
this decoder is the restriction of its input, so the sentence now states the
restriction and drops the rate. The rate returns in Draft 2, where it is
measured against the bounds that make it meaningful.

**Optional strengthening of the first paragraph**, if Draft 3 is taken. Replaces
lines 233--234:

```tex
If \(|V|\geq7\), then \(\mathcal A(\tau)\) determines \(\tau\) up to
complement.
```

with

```tex
If \(|V|\geq7\), then \(\mathcal A(\tau)\) determines \(\tau\) up to
complement, and seven is the least bound with this property.
```

---

## Draft 2 — a remark on what the count is measured against

**New**, to be placed immediately after the proof of
`thm:aligned-faithfulness` (after line 354) and before the principal-minor
paragraph, so that the paragraph beginning "The same statement in principal
minors" reads as its continuation.

```tex
\begin{remark}[What the query count is measured against]
\label{rem:alignment-query-count}
For a Seidel matrix this is the principal-minor assignment problem, whose
identifiability class is similarity by a diagonal matrix of signs
\cite[Thm.~6]{HoltzSturmfels}, that is, switching.  Against an oracle
returning minor \emph{values} the problem is solved in \(O(n^2)\) queries and
that count is asymptotically optimal
\cite{RisingKuleszaTaskar,BrunelUrschel}; for a Seidel matrix the cycle-basis
algorithm needs only the \(\binom n2-n+1\) principal minors of order three
\cite{BrunelSignedDPP}, each of which is twice a triangle sign and so returns
the two-graph outright.  The count above improves on none of that and is not
offered as an algorithm.  It is what a decoder pays when it is given only the
fourth-order indicator, which is invariant under global negation as the
order-three data is not.

Two lower bounds hold for that data.  Two-graphs on \(n\) points form an
\(\mathbf F_2\)-space of dimension \(\binom n2-n+1\); each test returns one
bit and determination up to complement allows fibres of size two, so any
family of tests --- and any decision tree, by its leaf count --- has at least
\(\binom n2-n\) members.  Families fixed in advance obey a stronger bound,
because the answers are biased.  A uniformly random two-graph restricts to a
uniformly random two-graph on any four points, and two of those eight are
aligned, so every alignment test answers yes with probability exactly
\(1/4\).  The information-theoretic bound of combinatorial search theory,
subadditivity of entropy applied to the entropy \(\binom{n-1}{2}-1\) of the
complement pair, which is what the answers determine, gives
\[
 k\;\ge\;\frac{\binom{n-1}{2}-1}{H(1/4)}
 \;=\;1.2326\Bigl(\tbinom{n-1}{2}-1\Bigr)\;\approx\;0.616\,n^2
\]
for every family of \(k\) tests that determines the two-graph.  Against
\(3n^2-23n+45\) the ratio tends to \(4.87\); the constant \(3\) is not known
to be optimal, and this bound says nothing about a decoder that chooses each
test in the light of earlier answers.

Tests indexed by four-sets occur elsewhere as a primitive observation.  The
causal-clustering algorithm of Kummerfeld and Ramsey \cite{KummerfeldRamsey}
decides one coherence bit per quartet of observed variables, up to
\(\binom n4\) of them, each by a pair of statistical tests on sampled data.  That test decides
whether covariance minors vanish under a one-factor measurement model, not
whether four triple signs cohere, so the two counts measure different work
and are not compared here.
\end{remark}
```

**Notes for the promoting task.**

- \(H(1/4)=0.8112781\ldots\) bits and \(1/H(1/4)=1.232623\ldots\); the displayed
  \(1.2326\) is truncated, not rounded, so the inequality stays valid as
  printed.
- The third paragraph is the whole of what the vanishing-tetrad screen
  supports. It names a setting and claims nothing about relative cost. If
  C816 wants the remark shorter, this paragraph is the one to cut; cutting it
  costs the paper a citation it does not need but leaves the four-set oracle
  looking unprecedented, which the screen shows it is not.
- If the remark is judged too long for the section, the second paragraph alone
  is the load-bearing one.

---

## Draft 3 — seven points is sharp

**New**, to be placed after Draft 2. This is a proof, not a computation: the
witness is verified by evaluating two graphs on six points.

```tex
\begin{remark}[Seven points is sharp]
\label{rem:six-point-witness}
Six points do not suffice, and not only because a two-graph may have no
aligned four-set at all.  Represent a two-graph on \(\{0,\dots,5\}\) by the
unique graph in its switching class in which \(0\) is isolated, and take
\[
 G=\{12,\,15,\,24,\,25,\,35\},
 \qquad
 H=\{13,\,14,\,24,\,34,\,35\}.
\]
Both two-graphs have aligned family exactly
\(\bigl\{\{0,1,2,5\},\{0,1,3,4\}\bigr\}\), and \(H\) is neither \(G\) nor its
complement.  So \(\mathcal A\) does not determine a two-graph on six points up
to complement, and the hypothesis \(|V|\ge7\) of
Theorem~\ref{thm:aligned-faithfulness} cannot be weakened.
\end{remark}
```

**Optional census sentence**, to be appended to that remark only if the
certificate travels with the paper (see Draft 7):

```tex
The failure is not isolated: of the 512 complement pairs on six points, 96
share an aligned family with another pair and only 6 of those have no aligned
four-set.
```

**Why this matters beyond the sentence.** Line 369 of
`sections/05-golden-operator.tex` already asserts "that seven vertices are
enough and six are not". Nothing in the paper currently proves the second
half. Draft 3 discharges an existing unsupported claim; if C816 declines the
remark, that clause has to come out instead.

---

## Draft 4 — positioning the sharpness against the graph theorem

**Replaces** the final sentence of the paragraph at lines 372--383, currently
ending:

```tex
The two-graph parity
axiom therefore lowers that general threshold to four, with ambient order
seven sharp.  The homogeneous-triple analysis of ordinary graphs
\cite{PouzetHomogeneousTriples} supplies the one-anchor viewpoint; the
away-from-anchor tests above remove its balanced-cut ambiguity.
```

**With:**

```tex
The two-graph parity
axiom therefore lowers that general threshold to four, with ambient order
seven sharp.  That sharpness is a separate statement from Dammak, Lopez,
Pouzet, and Si Kaddour's: their \(v\ge7\) is the endpoint of the admissible
range \(4\le k\le v-3\), and the sharpness they remark on is in \(k\), so no
six-point failure follows from their work for either observable.  The homogeneous-triple analysis of
ordinary graphs \cite{PouzetHomogeneousTriples} supplies the one-anchor
viewpoint; the away-from-anchor tests above remove its balanced-cut
ambiguity.
```

This is required by the audit: the six-point witness must not be presented as
filling an empty neighbourhood when a neighbouring paper states a superficially
similar bound for a different reason.

---

## Draft 5 — the principal-minor paragraph

**Replaces** lines 363--370, currently:

```tex
reconstruction up to switching is immediate.  The theorem consults none of
them.  Its data are the fourth-order principal minors, through
\(\det C[Q]=3-2w(Q)\) below, and these are invariant under global negation, so
they cannot distinguish \(C\) from \(-C\) and see each four-set only through
the single bit \(\det C[Q]\in\{-3,5\}\).  The content is that this
negation-invariant fourth-order data still determines the matrix up to exactly
that ambiguity, that seven vertices are enough and six are not, and that a
quadratic family of these determinants suffices.
```

**With:**

```tex
reconstruction up to switching is immediate.  The theorem consults none of
them.  Its data are the fourth-order principal minors, through
\(\det C[Q]=3-2w(Q)\) below; that these take only the two values \(-3\) and
\(5\) is Greaves and Suda's Table~1, and the \(-3\) fibre is their design.
They are invariant under global negation, so they cannot distinguish \(C\)
from \(-C\) and see each four-set only through the single bit
\(\det C[Q]\in\{-3,5\}\).  The content is that this negation-invariant
fourth-order data still determines the matrix up to exactly that ambiguity,
that seven vertices are enough and six are not by
Remark~\ref{rem:six-point-witness}, and that a quadratic family of these
determinants suffices.
```

---

## Draft 6 — how much of the family is needed at seven points

**New and optional**, to be placed after Draft 3. This one is
certificate-backed rather than proved in the text, and it is the draft most
likely to be cut for space. It is worth having because it is the only place
the paper could say what the selected family costs against an exact optimum.

```tex
\begin{remark}[The family at seven points]
At \(n=7\) the whole test set has \(\binom74=35\) members.  An exhaustive
level-wise search shows that no 29 of them determine a two-graph up to
complement and that several sets of 30 do, so 30 is exactly the minimum
there; the selected family, which has \(3n^2-23n+45=31\) members at \(n=7\),
has exactly one member that can be removed without losing separation, namely
the test on the anchor itself.  The 56 optimal sets fall into two orbits of
the symmetric group: keep the tests meeting a fixed pair of points, or delete
the four four-sets containing a fixed triple together with the four-set
complementary to it.  This is a statement about seven points and not evidence
about the constant \(3\): at eight points the same construction spends 53
tests where a search finds a separating family of 44, against a lower bound
of 30.
\end{remark}
```

The phrase "removable without losing separation" is written out in full
deliberately. Confirmatory tetrad analysis uses "nonredundant" for
rank-redundancy among the constraints a fixed model implies, and a reader from
that field would take the shorter phrasing the other way.

---

## Draft 7 — the verification section

**Appends** to `sections/08-verification.tex` after line 71, which ends the
paragraph carrying the human-proof list; line 67 ends a sentence but not that
paragraph, so inserting there would split it.

```tex
The sharpness of the seven-point hypothesis is proved in the text by the
six-point pair of Remark~\ref{rem:six-point-witness} and is not a Lean
statement.  The six-point census, the exact minimum of 30 tests at seven
points, and the bracket \(30\le\text{minimum}\le44\) at eight points are
certificate-checked computations recorded in the \texttt{verification}
directory; no formal statement covers them, and none of them is used in the
proof of Theorem~\ref{thm:aligned-faithfulness}.
```

**Precondition for promotion.** This sentence is false until the C880
certificates and their generator move from `notes/` into the paper's
`verification` directory with the release manifest updated, per
`notes/research-reproducibility-conventions.md`. If C816 takes Draft 3 alone
and drops Drafts 6 and the optional census sentence, the appended paragraph
reduces to its first sentence and no artifact has to travel.

---

## Draft 8 — new bibliography entries

**Appends** to `sections/10-references.tex`. Every entry describes the version
the audit actually read; the two published versions that were not obtained are
cited as published with the preprint's arXiv identifier retained.

```tex
\bibitem{HoltzSturmfels}
O.~Holtz and B.~Sturmfels,
\emph{Hyperdeterminantal relations among symmetric principal minors},
J. Algebra \textbf{316} (2007), 634--648; arXiv:math/0604374v2.

\bibitem{RisingKuleszaTaskar}
J.~Rising, A.~Kulesza, and B.~Taskar,
\emph{An efficient algorithm for the symmetric principal minor assignment
problem},
Linear Algebra Appl. \textbf{473} (2015), 126--144.

\bibitem{BrunelUrschel}
V.-E.~Brunel and J.~Urschel,
\emph{Recovering a magnitude-symmetric matrix from its principal minors},
arXiv:2404.06302v2 (2024).

\bibitem{BrunelSignedDPP}
V.-E.~Brunel,
\emph{Learning signed determinantal point processes through the principal
minor assignment problem},
arXiv:1811.00465v1 (2018).

\bibitem{KummerfeldRamsey}
E.~Kummerfeld and J.~Ramsey,
\emph{Causal clustering for 1-factor measurement models},
in: Proc. 22nd ACM SIGKDD Internat. Conf. on Knowledge Discovery and Data
Mining, ACM, 2016; doi:10.1145/2939672.2939838.
```

Page numbers for the KDD paper are not asserted because the audit read the
PubMed Central copy, which does not carry them.

Three mechanical points for whoever promotes these. The bibliography opens
`\begin{thebibliography}{9}`, whose width argument is already too narrow for a
two-digit entry count; widen it to `{99}` while the file is open. The entries
above abbreviate journal names and give a bare `doi:`, where the existing
entries spell journals out and wrap DOIs in `\href`; harmonize on promotion.
And Draft 2's first paragraph and the existing paragraph at lines 357--370 both
explain that order-three data trivializes the problem, so one of the two
tellings should be trimmed rather than both kept.

---

## Draft 9 — the `OPER-4` ledger row

Novelty wording has one home, and it is this row of
`papers/clebsch-passages/literature-boundaries.md`. The manuscript drafts above
quote none of it. **Replaces** the `Established literature boundary` and
`Paper-owned content and wording boundary` cells of the `OPER-4` row.

**Established literature boundary (replacement cell):**

> Greaves--Suda own the forward determinant-`(-3)` design and the two-valued
> fourth-order spectrum `{-3,5}` of a symmetric Seidel matrix.
> Dammak--Lopez--Pouzet--Si Kaddour own four-local reconstruction up to
> complement for ordinary graphs, and their `v >= 7` is the endpoint of the
> range `4 <= k <= v-3` with sharpness remarked in `k`; Pouzet--Si Kaddour
> prove that arbitrary 3-uniform hypergraphs have eventual local threshold
> five; Pouzet--Si Kaddour--Trotignon own the homogeneous-triple analysis used
> at an anchor. Holtz--Sturmfels own the identification of the principal-minor
> identifiability class with diagonal sign similarity. Rising--Kulesza--Taskar
> and Brunel--Urschel own `O(n^2)`-query reconstruction against a principal-minor
> *value* oracle, with the count called asymptotically optimal there; Brunel
> owns the cycle-basis algorithm; its Seidel specialization, computed in the
> audit rather than stated there, costs `C(n,2)-n+1` order-three minors. Subadditivity of entropy over biased binary
> tests is the standard information-theoretic bound of combinatorial search
> theory. Kummerfeld--Ramsey own a deployed algorithm whose primitive
> observation is a four-set indicator.

**Paper-owned content and wording boundary (replacement cell):**

> Equality of aligned families is four-hypomorphy up to complementation within
> the two-graph subclass. The sharp theorem that two-graph parity lowers the
> arbitrary 3-uniform local threshold from five to four, with ambient order
> seven sharp, was not located in the bounded audit, and the six-point witness
> proving that sharpness is paper-owned. The conference inversion, quadratic
> decoder, and one-bit calibration are corollaries. Paper-owned in the query
> claims: the restriction of the decoder's input to fourth-order indicators;
> the marginal that every alignment test answers yes with probability `1/4`
> and the resulting constant `1.2326`; and the exact small-case values at
> seven and eight points. Say "we prove"; claim no priority for the general
> hypomorphy framework, homogeneous triples, conference designs, graph
> canonicalization, the entropy method, or the four-set observation model, and
> claim no speedup against any named algorithm. Every negative keeps "to our
> knowledge"; none supports "first". Search record:
> `notes/2026-08-07-c880-literature-audit.md` and
> `notes/2026-08-07-c880-tetrad-screen.md`, with their access gaps ---
> Griffin--Tsatsomeros, the Renyi/Katona/Aigner search-theory sources, Boolean
> sensitivity and certificate complexity, and the two Seidel surveys.

---

## Wordings drafted for outcomes that did not occur, and discarded

Item 7 asks for one wording per outcome. Four of the five outcomes it names did
not occur, and the drafts for them are not written. Naming them:

1. **A matching lower bound.** Discarded: the bracket is \(0.616\,n^2\) to
   \(3n^2\), a factor of 4.87, and both ends are believed loose --- the lower
   because it ignores adaptivity and the geometry of which pairs a test can
   separate, the upper because at eight points a search beats the construction
   by nine tests. A sentence claiming optimality would be false.
2. **An optimality proof restricted to single-anchor families.** Partially
   earned and still discarded. Within the single-anchor shape the six tests per
   outside pair are forced, but this is verified only at \(n=7\) and \(n=8\) by
   enumerating the 64 subgraphs of the anchor's \(K_4\) link. A manuscript
   sentence would have to say "for \(n=7,8\)", which reads as a computation
   rather than a theorem; the general statement is unproved. If C816 wants it,
   the sentence is: *within the single-anchor construction the six tests spent
   on each outside pair cannot be reduced, since of the 64 subgraphs of the
   anchor's link only the complete one separates* --- and it must carry the
   restriction to \(n=7,8\) explicitly.
3. **A better decoder.** This one occurred after the drafts above were written;
   see the addendum, which supplies its text. The paragraph as first written
   read: "Not yet. The nonadaptive construction is beaten at eight points by a
   search that supplies no general family, and the adaptive decoder is under
   construction." It is superseded.
4. **The audit finds the claim known, and a citation replaces a theorem.** This
   happened for exactly one claim, the determinant-\((-3)\) family, and Drafts 1
   and 5 make it a citation. It did not happen for the faithfulness theorem,
   the point threshold, the query bounds, or the small-case values, so no
   further citation-instead-of-theorem wording is drafted.

---

## What promoting these drafts requires

1. Drafts 1 and 4 are self-contained and can go in as they stand. Draft 5
   depends on Draft 3, whose label `rem:six-point-witness` it cites; taking it
   alone leaves an undefined reference.
2. Drafts 2 and 3 add two remarks and five bibliography entries. Draft 2's
   third paragraph and Draft 3's optional census sentence are separable.
3. Draft 6 and the second sentence of Draft 7 need the C880 certificates to
   move into the paper's `verification` directory first.
4. Draft 9 goes in before any of the others, since the manuscript's novelty
   posture is quoted from it.
5. The `PouzetHypergraphIsomorphy`, `DammakGraphHypomorphy` and `GreavesSuda`
   keys already exist; the five keys of Draft 8 are new and no existing key is
   reused with a different meaning.

---

## Addendum, same day — the adaptive decoder landed

`notes/2026-08-07-c880-adaptive-decoder.md` proves an adaptive decoder using at
most \(\binom n2+n-4\) alignment tests on every instance, against a counting
lower bound of \(\binom n2-n\) that binds every decoder. Two things in the
drafts above change.

**Draft 2's last sentence is replaced.** It currently reads:

```tex
Against
\(3n^2-23n+45\) the ratio tends to \(4.87\); the constant \(3\) is not known
to be optimal, and this bound says nothing about a decoder that chooses each
test in the light of earlier answers.
```

Replace with:

```tex
Against \(3n^2-23n+45\) the ratio tends to \(4.87\), and the constant \(3\)
is not known to be optimal.  The bound also does not apply to a decoder that
chooses each test in the light of earlier answers, and for \(n\geq19\) such a
decoder does better than any fixed family can: reading the two-graph on seven
points, and then adding one point at a time, costs at most \(\binom n2+n-4\)
tests.  Two known edges at a new point make every further edge cost one test,
because a test one of whose two conditions is already decided --- known to
hold, or known to agree with the other --- reads as a single bit; the whole
cost of adding a point is the cost of its first two edges, and seven tests buy
five of them.  So the price of the coherence restriction is a price of fixing
the tests in advance: adaptively the fourth-order indicator matches the
order-three minor values to leading order, both at \(n^2/2\).
```

**A new bibliography entry is not needed**, and no novelty adjective is used:
the claim is a construction with a stated count, and its comparison is to the
counting bound, which is standard. The `OPER-4` ledger cell of Draft 9 gains one
clause in its paper-owned list, after "the exact small-case values at seven and
eight points":

> and the adaptive decoder reaching \(\binom n2+O(n)\) tests, with the
> attachment lemma that makes each further edge cost one test.

**What the manuscript should not say.** Not that the decoder is optimal — the
adaptive complexity is pinned only to a window of width \(2n-4\). Not that
adaptivity helps at every \(n\) — the proved separation against the entropy
floor holds for \(n\ge19\), and at \(n=7\) it is exact (22 against 30), but
for \(8\le n\le18\) neither bound settles it. Not that this improves on the
principal-minor literature, whose value oracle is stronger.

**Where it goes.** Draft 2 already sits after the proof of
`thm:aligned-faithfulness`, which is the location item 7 names for a sharper
decoder. The theorem statement itself is unchanged: the manuscript's family
remains the one the proof uses, and the adaptive count is a remark about the
model, not a replacement for the construction the faithfulness proof carries.

## Mystery ledger for item 7

- **Settled here.** Whether the manuscript's \(O(n^2)\) sentence survives the
  audit: it does not, and Draft 1 replaces it with the restriction that is
  actually particular to this decoder. Whether the six-point failure needs a
  certificate to enter the paper: it does not --- the witness pair is a proof.
- **Closed by the addendum.** Whether the manuscript can state a decoder better
  than \(3n^2-23n+45\). It can: \(\binom n2+n-4\) adaptively, with the
  attachment lemma as the mechanism, and a separation from every fixed family
  proved for \(n\ge19\).
- **Open, owned by C816.** Whether Drafts 6 and 7 are worth the artifact
  migration. The lane's reading is that Draft 6 earns its place only if the
  paper wants the rigidity-and-redundancy framing that
  `notes/2026-08-07-c880-alignment-separation.md` §7 recommends; on its own it
  is a small-case table.
- **No genuine mystery** remains in the wording itself. The five constraints
  are mechanical once the audit's verdicts are accepted, and each is
  discharged at a named line.
