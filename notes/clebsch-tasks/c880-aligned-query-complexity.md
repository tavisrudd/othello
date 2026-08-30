# C880 — query complexity of aligned-design reconstruction

**Lane:** `clebsch`
**Status:** active; research and computation only
**Paper:** III (`papers/clebsch-passages`), theorem `thm:aligned-faithfulness`

## State

Work items 1, 2, 4, 6 and 7 are closed, item 3 is closed on the adaptive
side, and item 5 is closed on the promised-anchor side and reduced to a single
open counting question on the regular side. Only item 8, the nonadaptive
constant, and that counting question remain.

**2026-08-30: the eight-point attachment constant is settled exactly:**
\(g(8)=17\). Exact-cardinality 15 and 16 reduce to compact parity CNFs and are
UNSAT with independently replayed DRAT certificates; a 17-triple family is
replayed by the separate Rust cut-graph checker. This closes the finite loose
end in the 2026-08-19 cost-per-bit report and confirms that the previous upper
witness was optimal. Report and compact certificates:
`notes/2026-08-30-c880-exact-eight-point-attachment.md`.

**2026-08-19: the nonadaptive bracket narrowed by a factor 8/3 from above.**
It now reads \(0.616\,n^2\le\mathrm{minimum}(n)\le\frac98n^2+O(n)\), a factor of
1.827 rather than the 4.87 recorded below. A nonadaptive family decomposes as a
seven-point base of 30 tests plus one attachment layer per further point, and a
layer is built from blocks of four fresh points costing nine tests each against
the gauge point alone; correctness is an attachment lemma by pigeonhole plus a
composition argument, resting on exhaustive constants \(g(5)=9\), \(g(6)=12\),
\(g(7)=15\). Route (b), the weight-four difference masks, was dropped: it is
proved capped at 30 at seven and eight points and deciding it at nine is a
\(10^{16}\)-pair scan. A second lower bound by covering and the polynomial
method was derived and settled negatively at \(\approx n^2/4\), dominated by the
entropy floor at every \(n\) because the yes-count cancels. Report:
`notes/2026-08-19-c880-nonadaptive-constant.md`.

Reports: `notes/2026-08-07-c880-alignment-separation.md` (computation),
`notes/2026-08-07-c880-mask-ilp-bound.md` (the exact eight-point mask bound),
`notes/2026-08-07-c880-literature-audit.md` (audit, verdict per claim),
`notes/2026-08-07-c880-tetrad-screen.md` (the vanishing-tetrad screen),
`notes/2026-08-07-c880-manuscript-wording.md` (item 7, drafted LaTeX) and
`notes/2026-08-07-c880-adaptive-decoder.md` (the adaptive decoder) and
`notes/2026-08-11-c880-item5-conference-promise.md` (item 5, all proofs by hand).

- Seven points is sharp: the alignment tests fail to determine a two-graph up to
  complement at six points, in 46 groups covering 96 of the 512 complement
  pairs, only 6 of which have an empty aligned family. A non-degenerate witness
  pair is recorded for the manuscript.
- The exact nonadaptive minimum at seven points is 30 of the 35 tests, with 56
  optimal families in two orbits, computed by three independent routes.
- The manuscript's selected family separates unconditionally, and at seven
  points its single redundant member is the test on the anchor itself; the same
  drop is valid at eight points.
- Every test answers yes with probability exactly one quarter, so subadditivity
  of entropy gives a **nonadaptive** floor
  \(k\ge(\binom{n-1}2-1)/H(1/4)\approx0.616\,n^2\) at every \(n\). It beats
  the counting bound by a factor 1.2326 and cuts the asymptotic gap against the
  exhibited \(3n^2-23n+45\) from 6 to 4.87. It does not bind adaptive decoders,
  whose floor stays the counting bound.
- A test on \(\{p,q,x,y\}\) notices the elementary flip of the pair
  \(\{x,y\}\) exactly when \(\tau(pxy)=\tau(qxy)\), so a separating family
  must give every pair a non-bipartite link graph. That is the exact form of the
  card's structural obstacle, and it is necessary but not sufficient: the
  triangle-anchor family has non-bipartite links everywhere and fails at seven
  and at eight points.
- Within the single-anchor shape the six tests per outside pair are forced: of
  the 64 subgraphs of the anchor's \(K_4\) link, only the complete one
  separates, at seven and at eight points. The manuscript's constant is
  therefore not slack inside its own class, and any improvement must share tests
  between outside pairs instead of spending six private ones on each.
- Adaptivity strictly helps, and the coherence restriction is cheap. The
  structural decoder below supersedes the greedy measurement that first showed
  this, but the greedy numbers remain the mean-cost evidence: measured against
  the value oracle's optimum — the two-graph dimension \(\binom{n-1}2\), which
  order-three minor values achieve with no waste — the greedy adaptive worst
  case costs 1.47 and 1.43 at seven and eight points, and its mean at most 1.041
  and 1.043, an upper bound since greedy is not optimal. The mean price's sign
  is open: any complement-invariant one-bit oracle has floor
  \(\binom{n-1}2-1\), one below the triple oracle's, so the coarser observable
  could be cheaper on average. Reviewed by a Fable pass, whose corrections are
  applied: `notes/2026-08-07-c880-framing-review.md`.
- At eight points the bracket is \(30\le\mathrm{minimum}\le44\) against the
  exhibited 53, so the construction is not optimal. The lower end is the exact
  minimum hitting set of the weight-four difference masks, proved optimal by two
  solvers and by a structural argument: the masks are the evenly crossing pairs
  of four-four splits of the eight points, a hitting set touches all but a
  pairwise unevenly crossing family, and such a family is a set of pairwise skew
  lines of \(\mathrm{PG}(3,2)\), so it has at most five members and the bound is
  \(35-5\). The same 315 constraints are the seven-point weight-two masks under
  the split correspondence, which is why both sizes give 30 — and why this route
  cannot give more than 30 at eight points. Improving it needs constraints from
  pairs at alignment distance five or more.

The audit changes the framing more than it changes the mathematics. Principal-minor
reconstruction solves the same problem up to the same gauge — principal minors are
invariant under diagonal sign similarity, which for a Seidel matrix is switching, and
Oeding's theorem says equal principal minors means the same two-graph. Against a
*value* oracle it is already solved in \(O(n^2)\) queries by published algorithms
that call themselves asymptotically optimal, and for a Seidel matrix the cycle-basis
route needs only \(\binom n2-n+1\) order-three minors, a factor six below the
exhibited count. Nothing is pre-empted, because the alignment decoder receives neither
values nor order-three data, only one indicator bit per four-set — but every sentence
claiming \(O(n^2)\) selected determinants as a contribution must name that
restriction or it reads as pre-empted. Three further wording consequences: the
determinant-family identification becomes a citation to Greaves and Suda, whose Table 1
and Example 2.3 already give the two-valued fourth-order spectrum and the design; the
entropy bound must be presented as an application of the standard information-theoretic
bound of combinatorial search theory, its content being the measured quarter marginal
rather than the method; and the six-point sharpness must be positioned explicitly
against Dammak, Lopez, Pouzet and Si Kaddour, whose \(v\ge7\) is the endpoint of
\(4\le k\le v-3\) and whose own sharpness remark is about \(k\), so they prove no
six-point failure. The non-bipartite link criterion and the exact seven-point value
have no located predecessor; the link criterion is the weakest supported, since Boolean
sensitivity and certificate complexity was not searched.

The tetrad screen adds no pre-emption and one setting. No source counts
four-variable tests as a query complexity or bounds their number, so nothing is
pre-empted; but the FindOneFactorClusters algorithm of Kummerfeld and Ramsey does
take a four-set indicator as its primitive observation and pays \(\binom n4\) of
them in the worst case, each a hypothesis test on sampled data. That is a genre
match rather than a matched-units baseline — it recovers a clustering under a
one-factor measurement model, not a two-graph — so item 8 may name it and may not
claim a speedup against it. Three wording constraints follow for item 7: cite
that algorithm rather than presenting the four-set oracle as unusual; say
"removable without losing separation" in full, because "nonredundant tetrad" is
an occupied term of art meaning rank-redundancy in a fixed model's implied
constraints; and position the complexity claim inside the existing
query-counting genre of structure learning, where Franquesa Monés, Zhang and
Uhler prove matching bounds for conditional-independence tests.

The adaptive side is closed. An explicit decoder reads the two-graph in
\(\binom n2+n-4\) alignment tests on every instance, against the counting lower
bound \(\binom n2-n\), so the adaptive constant is exactly \(1/2\) and the
coherence restriction costs nothing to leading order. Its mechanism is an attachment
lemma: once two edges at a new point are known, every further edge costs one
test, because a test one of whose two conditions is already decided — known to
hold, or known to agree with the other — reads as a single bit. The bootstrap
costs seven tests per point outside the monochromatic state, and exact minimax
play shows that optimal there; the monochromatic stages cost 4, except at most
one per instance at 9.
Adaptivity therefore strictly beats every fixed family from \(n=19\) on,
against the \(0.616\,n^2\) entropy floor, and beats the exhibited
\(3n^2-23n+45\) by a factor tending to six; the range \(8\le n\le18\) is open.
Verified exhaustively at seven and eight points and by sampling to \(n=40\), and
repaired after a referee pass:
`notes/2026-08-07-c880-adaptive-decoder.md` and
`notes/2026-08-07-c880-adaptive-and-wording-referee-review.md`.

Item 5 is answered, structurally and without certificates. Writing \(a(p)\) for
the number of coherent triples through a pair and \(m(p)=n-2-2a(p)\) for its
defect, the number of aligned four-sets is a function of the pair degrees alone:
\(\lvert A\rvert=\tfrac1{16}\bigl((n-6)\binom n3+\sum_p m(p)^2\bigr)\), with
spectral form \(\tfrac14\binom n4+\tfrac1{32}(\operatorname{tr}S^4-n(n-1)(2n-3))\).
The sum of squares gives the sharp conference bound:
\(\lvert A\rvert\ge n(n-1)(n-2)(n-6)/96\) with equality iff every defect
vanishes, iff \(S^2=(n-1)I\).  Thus conference two-graphs are the exact
minimisers whenever they exist, and the bound is the equality case of a
quasirandomness statement; attainment needs \(n\equiv2\pmod4\) and \(n-1\) a sum
of two squares, so an arithmetic condition controls a purely combinatorial
minimum, first failing at \(n=22\).  That single inequality proves both halves of
the point threshold — every two-graph on at least seven points has an aligned
four-set, and the six-point exceptions are precisely the conference two-graphs,
twelve labelled, matching the enumeration exactly. The promise therefore pins
the instance to the sparsest-signal extreme rather than to an easier one. Three
further results say why nothing is gained: the aligned family is a
\(3\)-\((n,4,\tfrac{n-6}4)\) design exactly for conference two-graphs and only a
2-design for the other regular ones, but the law is inert, inflating a decoder's
known set by at most \(1+O(1/n)\); the anchor promise is an index-four subgroup
condition, worth exactly two bits and no change to any bound; and no elementary
pair flip stays in the conference class, so every local lower-bound mechanism
dies, while the rigidity replacing it certifies only \(O(n)\) of savings. What
survives is a reduction: from below, the conference-promised complexity is
\(\log_2 N_n-1\) for \(N_n\) the number of labelled conference two-graphs, at
least \(n\log_2 n-O(n)\) unconditionally, and it drops below the unpromised
\(\Theta(n^2)\) exactly when \(\log_2 N_n=o(n^2)\) — an open counting question
about symmetric conference matrices. Details and proofs:
`notes/2026-08-11-c880-item5-conference-promise.md`.

Item 7 is drafted against all five audit and screen constraints, with the
LaTeX quoting the lines it replaces, the discarded alternatives named, and a
replacement `OPER-4` ledger row: `notes/2026-08-07-c880-manuscript-wording.md`.
The same referee pass reviewed the drafts; its repairs are applied.

## Open work, in the order a fresh session should take it

Each item below is self-contained: what is wrong or missing, why it matters, and
the concrete first move. Nothing here blocks the results already recorded; items
1 and 2 harden the adaptive result, item 3 is the remaining research question.

### 1. Retire the single-program dependence on the bootstrap constants

**State.** The adaptive bound \(\binom n2+n-4\) rests on three measured
constants: the bootstrap costs 7 tests on every non-monochromatic helper
configuration, at most 9 on a monochromatic one, and 4 when the pattern keeps
the known graph monochromatic. All three come from one exhaustive minimax search
inside `notes/2026-08-07-c880-adaptive-decoder.rs` (modes `bootopt` and
`degenerate`). The core's depth 22 is independently confirmed by the older
`notes/2026-08-07-c880-alignment-separation.rs`; the bootstrap constants are not
confirmed by anything.

**Why it matters.** `notes/research-reproducibility-conventions.md` wants an
independent replay or a stated reason none exists, and the 2026-08-07 referee
pass showed the argument that looked like an independent confirmation — the
entropy count \(\lceil5/H(1/4)\rceil=7\) — is invalid, because the
\(H(1/4)\)-per-test cap is a nonadaptive argument and a conditioned posterior
can be split evenly. Entropy licenses only 6 here. Do not reinstate that
argument.

**First move, either route.** A second implementation of the minimax search in a
different representation (the state is a subset of the 32 candidate assignments;
the 20 tests are fixed by the ten helper edges), written without reading the
Rust; or a structural proof of the 7 that engages the query geometry rather than
the answer marginal. The asymptotic result survives any constant \(c\): a
bootstrap bounded by \(c\) gives \(\binom n2+(c-6)n+O(1)\).

### 2. Close the separation for \(8\le n\le18\)

**State.** Adaptivity provably beats every fixed family at \(n=7\) (22 against
the exact nonadaptive minimum 30) and for every \(n\ge19\), where the proved
bound \(\binom n2+n-4\) drops below the nonadaptive floor
\(1.2326(\binom{n-1}2-1)\). Between them the proved bound sits above the floor,
so the question is open there — not answered negatively.

**Why the gap exists.** The bound charges every attachment 7 bootstrap tests
plus one per remaining edge, and adds 2 for the single stage that can cost 9;
the decoder's true worst case is smaller. At \(n=8\) the exhaustive worst case
is 30 against a bound of 32.

**First moves, cheapest first.** Compute the decoder's exact worst case at
\(n=9,\dots,12\) by exhaustive enumeration where it is affordable
(\(2^{\binom{n-1}2}\) instances: \(2^{28}\) at \(n=9\) is feasible in Rust,
\(2^{36}\) at \(n=10\) is not, so a worst-case search over stage configurations
is needed rather than over instances). Alternatively tighten the bound itself:
the core's 22 is a greedy tree, and an exact minimax core tree would likely be
smaller; the \(+2\) switch allowance can be charged more carefully.

### 3. The nonadaptive constant — the remaining research question

Superseded on the upper side by the 2026-08-19 round: the sharing construction
the link criterion demanded was found, and the bracket is now \(0.616\,n^2\) to
\(\frac98n^2+O(n)\). The difference-mask route stays exhausted for the reason
already recorded here, and the 2026-08-19 round added that deciding it at nine
points is a \(10^{16}\)-pair scan.

**The loose end is the lower bound, and the second 2026-08-19 round settled why**
— report `notes/2026-08-19-c880-cost-per-bit-constant.md`, commit `e02221130`.

- The apparent agreement of three arguments near 2.4 was not three arguments.
  The covering heuristic's 2.409 is the random model's cost for a requirement an
  optimal family can dodge; the deterministic covering constant is 1, since
  \(c_2^{\mathrm{aff}}(m)=m+1\) exactly for \(m\le5\) and seven codimension-two
  flats cover \(\mathbf F_2^m\) for every \(m\). What survives is measurement:
  2.00 tests per bit at \(n=7\), the one exactly known size.
- A new proved lower bound, by star flips: the tests through any point restrict
  to an attachment family for the other points, so
  \(\mathrm{minimum}(n)\ge\lceil n\,g(n-1)/4\rceil\). That is 21 against the
  entropy floor's 18 at \(n=7\) and 30 against 25 at \(n=8\), re-deriving the
  lane's best eight-point bound in two lines rather than by a partial-spread
  argument in \(\mathrm{PG}(3,2)\). It is capped at \(0.5625\,n^2\) by the block
  construction's own \(g(m)\le\frac94m\), so it never beats the floor
  asymptotically. Corollary: base-plus-layers is within a factor two of optimal,
  unconditionally.
- Both natural lower-bound routes are therefore closed with exact reasons: a
  cancellation theorem kills the covering route whatever its constant, and the
  star-flip route is capped by the construction. A third mechanism must come
  from the alignment code's distance distribution, which is the only mechanism
  ever tight in this lane — it gives exactly 30 at \(n=7\), the true minimum.
- \(g(8)=17\) exactly. The earlier weight-capped families supplied only the
  lower bound 15; the complete cut system, compiled through odd Eulerian
  witnesses and semantic symmetry, excludes exact sizes 15 and 16 with checked
  DRAT proofs. The \(+3\) progression is a theorem in the form \(P(k,1)=3\) and
  is broken at \(m=8\); the escape from it is batching, already visible at
  \(g(5)=9\).
- `P(2,6)` remains undecided after a capped branch and bound and a 6 GB HiGHS
  run, and cannot help the construction, because the one-anchor value it would
  have to beat is now exact.

The construction is known non-optimal at the one size where both numbers exist:
45 against 44 at eight points, with neither of its two parts slack now that
\(g(7)=15\) is exact.

### 4. Items 5 and 8

Item 5's promised-anchor half is closed negatively and its design half is closed
by an inertness proof. One question survives it, and one route.

**The surviving question.** Is \(\log_2 N_n=o(n^2)\), where \(N_n\) counts
labelled conference two-graphs on \(n\) points? This is the entire lower-bound
content of the conference promise, and it is a counting problem about symmetric
conference matrices rather than about alignment tests. The 2026-08-07 literature
audit did not search it. Nothing else in C880 depends on the answer.

**The one upper-bound route that beats the general decoder.** Learn
\(\Theta(n/\log n)\) full rows of the Seidel matrix at one test per pair, then
solve for every remaining row from its orthogonality against them: each equation
cuts the \(\pm1\) solution count by about \(\sqrt n\), so the decoder should
finish in \(O(n^2/\log n)\) tests. Worst-case correctness is exactly an inverse
Littlewood--Offord statement for the rows of a conference matrix, and the
support-rigidity theorem is the \(k=0\) case of the same mechanism.

**The route that would produce a separation.** Narrow the promise from "some
conference two-graph" to "some labelled copy of the Paley conference two-graph".
Reconstruction becomes labelling recovery, and a counting argument suggests
\(\Theta(n\log n)\) nonadaptive tests suffice: a permutation moving \(k\) points
should change the alignment of a \(\Theta(k/n)\) fraction of four-sets, while
only \(n^{O(k)}\) such permutations exist. The missing step is exactly that
discrimination bound, which for Paley is a character-sum estimate. Proving it
would give the first genuine separation between the promised and unpromised
problems; everything else in item 5 says the general promise gives none.

Item 8 has a named genre match, Kummerfeld and Ramsey's four-set indicator
oracle, but no matched-units baseline, so no speedup may be claimed against it.

### 5. Handoff of the drafted wording

The drafted wording was promoted into Paper III on 2026-08-07 at explicit
user instruction, ahead of the serialized route: Drafts 1--5, 8 and 9 are in
`sections/05-golden-operator.tex`, `sections/10-references.tex`,
`sections/08-verification.tex` and `literature-boundaries.md`, and the
manuscript build gate passes warning-free at thirty pages, its expected page
count re-pinned from twenty-nine in the same commit. Three referee passes are
applied; the third judged the promoted text in context.

Draft 6 and the exact adaptive constant were deliberately left out, and the
reasoning is recorded under "Decision, 2026-08-07" in
`notes/2026-08-07-c880-manuscript-wording.md`: the \(n-4\) is a property of
one decoder rather than of the problem, the threshold \(n\ge19\) is where two
loose bounds cross rather than where adaptivity starts helping, and the
migration they need would put a new category of evidence on a release surface
C824 owns. The manuscript claims \(\binom n2+O(n)\) instead, proved in the
text from the paper's own theorem. Revisit only if open item 2 pins the
second-order term, or if C824 adopts the rigidity-and-redundancy framing.
C816 and C824 still own any reshaping of what is now in the manuscript.

## Working notes for whoever picks this up

- **Regenerate every certificate after any change to the generator.** The
  referee pass found `verify8.json` stale — produced by a pre-final variant of
  the decoder — and diagnosed it by reproducing the stale bytes from the old
  code path. The full replay command list is in the Reproduction section of
  `notes/2026-08-07-c880-adaptive-decoder.md`; run all of it, not the modes you
  think you touched.
- **The decoder's helper choice is load-bearing, not an optimization.** It picks
  five known points carrying both an edge and a non-edge. That is what removes
  the monochromatic configuration from every stage but at most one, and it is
  why there is a single bound rather than one bound plus an exceptional class.
- **`verify --n 8` takes about 40 seconds and `sample --n 40` a few minutes.**
  Exhaustive `verify` is limited to \(n\le8\) by an assertion.
- **Read the referee review before extending any claim**:
  `notes/2026-08-07-c880-adaptive-and-wording-referee-review.md`. Its MAJOR 1
  and MAJOR 3 are the two places where a plausible-looking argument was wrong,
  and both are the kind of mistake that would recur.

## Objective

Decide how strong a complexity statement Paper III can make about
aligned-four-set reconstruction, replacing "the decoder in the proof uses
exactly this many" and "uses \(O(n^2)\) selected determinants" with a claim that
has a matching or near-matching lower bound — in general, and in the special
cases where the extra structure might buy something.

The paper currently exhibits a family of \(3n^2-23n+45\) alignment tests and
proves it sufficient. Nothing says a quadratic count is forced, nothing says the
constant \(3\) is the right one, and nothing distinguishes what an adaptive
decoder could do from what this fixed family does.

## Starting facts

These are established and are the task's inputs, not its deliverables.

- **Sufficiency.** The four-point subsets meeting a fixed aligned four-point
  anchor in at least two points determine a two-graph up to one global
  complement bit:
  `RelativeConicArcs.AlignedQueryFaithfulness.exists_complementBit_of_selectedQueryFamily_eq`.
  Their number is `card_selectedQueryFamily`, namely \(3n^2-23n+45\). The anchor
  itself exists on any point set with at least seven points
  (`exists_distinct_alignedAnchor`).
- **A counting lower bound.** Two-graphs on \(n\) labelled points form an
  \(\mathbf F_2\)-space of dimension \(\binom n2-n+1\). Each alignment test
  returns one bit determined by the two-graph, and determination up to
  complement allows fibres of size two, so any family with that property — and
  any adaptive decision tree, by the leaf count — has at least
  \(\binom n2-n=n(n-3)/2\) members. The exhibited family is therefore within a
  factor tending to six of this bound. At \(n=7\) the two numbers are \(31\) and
  \(14\); at \(n=8\) they are \(53\) and \(20\).
- **One economization is measured and fails.** Dropping the \(4(n-4)\) tests
  meeting the anchor in three points and keeping only the \(6\binom{n-4}2\)
  two-anchor-point tests collapses the 4,096 normalized seven-point
  configurations to 2,329 signatures:
  `notes/2026-08-07-c815-pair-signature-only.py`.

## The structural obstacle worth naming first

An alignment test is not a linear functional. Writing the two-graph additively,
\(\{a,b,c,d\}\) is aligned exactly when \(\tau(abc)+\tau(abd)=0\) and
\(\tau(abc)+\tau(acd)=0\); the fourth equality is then forced by the four-set
parity law. So each test reports whether two independent linear forms vanish
simultaneously, and a negative answer distinguishes three cases without saying
which.

That has a sharp consequence. If two two-graphs both have empty aligned family,
every alignment test answers "no" on both and no family whatever separates them.
The order-six conference two-graph has empty aligned family, so the question of
whether seven points is the sharp hypothesis and the question of what these
queries can possibly determine are the same question. Any lower bound stronger
than the counting one should come from this asymmetry — the "no" answers carry
much less than a bit — rather than from cardinality alone.

## Work items

These are the original definitions, kept for reference. Items 1, 2, 4, 6 and 7
are closed, item 3 is closed on the adaptive side and open on the nonadaptive
one, and items 5 and 8 are untouched; the State section above is authoritative
on what remains.

1. **Sharp point threshold.** Enumerate the two-graphs on six points — the
   \(2^{10}\) switching classes of graphs on six vertices — group them by aligned
   family, and report whether two non-complementary classes share one. Repeat on
   five and four points. A collision makes \(\lvert V\rvert\ge 7\) sharp and
   gives the manuscript a witness; no collision means the theorem holds lower
   than stated and the seven is an artifact of the proof route. Either outcome
   is a strictly better sentence than the present one.
2. **Exact minimum at small \(n\).** For \(n=7\) there are only \(\binom 74=35\)
   possible tests, so the minimum separating subfamily is an exactly decidable
   question: find the smallest set of four-sets whose alignment pattern
   separates all \(2^{15}\) two-graphs up to complement. Do the same at \(n=8\)
   (\(70\) tests, \(2^{21}\) two-graphs) if it stays tractable, with exact
   optimality or explicit upper and lower bounds. Compare against \(31\) and
   \(53\). This is the fastest way to learn whether the constant \(3\) is loose.
3. **Improve or defend the constant.** If the small cases show slack, look for a
   smaller family with a proof: candidates are anchor families using two anchors,
   families that reuse a partial reconstruction to choose later tests
   (adaptivity), and families exploiting that a recovered cut constrains its
   neighbours. If instead the small cases sit near \(3n^2\), try to prove
   optimality within the natural class — for instance that no family based on a
   single anchor can do better, which is a statement about the normalized
   seven-point model and may be decidable there.
4. **Adaptive versus nonadaptive.** State whether adaptivity helps beyond the
   twenty tests already spent locating the anchor. The counting bound applies to
   both, so a separation would have to be constructive.
5. **Special cases.** Regular two-graphs — the aligned four-sets of a symmetric
   conference matrix form a \(3\)-\((2d,4,(d-3)/2)\) design — carry uniform local
   statistics that a general two-graph does not. Ask whether reconstruction
   inside that class needs fewer tests, and whether the design property itself
   can be assumed by the decoder rather than discovered. Also consider the class
   with a promised anchor, which is what the paper's decoder actually solves.
6. **Literature audit.** Any strengthened complexity sentence is a claim about
   what is not already known, so it is a bound deliverable under
   `notes/literature-audit-conventions.md`: read depth on every named source,
   the coverage statement, screened-set records, and forward-citation counts
   taken independently from OpenAlex, Crossref and Semantic Scholar with each
   count recorded separately. Check the shared cache before fetching, per
   `CLAUDE.md` § "Literature cache". Five bodies of work carry the real
   pre-emption risk, and the audit stands or falls on how carefully they are
   read rather than on breadth:

   - **The principal-minor assignment problem.** This is the closest
     literature and the most serious risk, because it asks precisely when
     principal minors determine a symmetric matrix up to diagonal similarity,
     and the classical answer runs through relations among minors of order at
     most four. Holtz and Sturmfels on hyperdeterminantal relations among
     symmetric principal minors, Griffin and Tsatsomeros on the reconstruction
     algorithm, and the later algorithmic solutions are the seeds. Establish
     exactly what data those results consume: the paper's decoder is given only
     the indicator of which four-by-four principal minors equal \(-3\), not the
     values of any minors, so the two settings may be far apart — but that has
     to be shown by reading, not asserted.
   - **Learning a hidden graph from queries.** Reconstruction of a graph under
     the additive model (Grebinski and Kucherov) and learning with
     edge-detecting queries (Angluin and Chen, and the Alon–Beigel–Kasif–
     Rudich–Sudakov line) are the standard sources for query lower bounds of
     the shape wanted here, including the \(\Theta(n^2/\log n)\) phenomena that
     arise when a query returns more than one bit's worth of structure. An
     alignment test returns one bit about two linear forms, so these models
     bracket ours on both sides.
   - **Quartet-based reconstruction.** Determining a global structure from
     four-element local tests is the phylogenetic quartet problem, which has
     its own query lower bounds and its own notion of a quartet being
     uninformative. The analogy may be only formal, but the uninformative-answer
     phenomenon identified above has a direct counterpart there.
   - **Separating systems and combinatorial search.** The minimum size of a
     family of tests separating a set is classical (Rényi, Katona, and the
     Körner–Simonyi line). If a sharper counting bound exists for tests that are
     conjunctions of linear conditions, it is likely here.
   - **Two-graphs and switching classes.** Seidel and Taylor, and Brouwer and
     Van Maldeghem § 1.1.12, which the paper already cites, together with
     Greaves and Suda for the determinant-\((-3)\) design. The earlier audits of
     the faithfulness theorem itself established the reconstruction benchmark —
     Dammak, Lopez, Pouzet and Si Kaddour for \(4\le k\le v-3\) — and settled
     that the two theorems are independent. Determine whether that audit's
     coverage extends to the *query count* and to the point threshold, which are
     different claims, and do not re-derive its verdict on the theorem.

   Report the outcome as a verdict per claim: the quadratic upper bound, the
   lower bound, the sharp point threshold, and the determinant-family
   identification each get their own. A verdict of "already known" is as useful
   as a negative and closes the corresponding manuscript ambition cleanly.

7. **Manuscript language, if the result checks out.** Whenever a finding
   survives both its own validation and the audit above, the report carries
   ready-to-paste LaTeX for it rather than a description of what should be said.
   Write it against the current source, quoting the exact lines it replaces, and
   in the paper's own voice per `papers/style-guide.md`. Three locations are in
   scope, and a proposal names which of them it touches:

   - the statement of `thm:aligned-faithfulness` in
     `sections/05-golden-operator.tex`, where the sentences on the
     \(3n^2-23n+45\) tests, the twenty anchor tests and the \(O(n^2)\) selected
     determinants live, and where a lower bound would turn a count into an
     optimality claim;
   - the closing paragraph of that theorem's proof, which is where a sharper
     decoder or a proof of optimality within a named class would go;
   - the coverage prose of `sections/08-verification.tex`, if what is proved in
     Lean changes.

   Supply one drafted wording per outcome rather than one for the outcome hoped
   for: a matching lower bound, a bound with a stated constant gap, a better
   decoder, an optimality proof restricted to single-anchor families, and the
   case where the audit finds the claim already known and the right move is a
   citation instead of a theorem. A drafted sentence that the computation or the
   audit does not support is not written.

   Do not edit the manuscript. Promotion belongs to C816 and the final Paper III
   pass to C824, and either may reject or reshape a proposal; the value here is
   that they receive text and evidence together rather than a finding to
   translate. Any novelty or priority wording goes first into the row of
   Paper III's claim–proof–novelty ledger that owns it, and every other surface
   quotes that row rather than restating it.

8. **Where a smaller query count would actually buy something.** A better
   constant is only worth claiming if some setting pays per query. The question
   to answer is narrow and should be answered narrowly: *is there a real
   setting whose primitive observation is a four-set alignment test, rather
   than the pairwise signs?* If the pairwise data is directly observable, every
   result here is a curiosity, because reading all \(\binom n2\) signs is already
   cheaper than \(3n^2\) tests. The interesting settings are the ones where the
   individual signs are unobservable in principle — gauge-equivalent data — and
   only local coherence can be measured. Four candidates, each to be judged
   against the method actually used in that field and costed in the same units:

   - **Learning a determinantal point process kernel, and the principal-minor
     assignment problem it rests on.** Each principal minor is a marginal
     probability estimated from samples, so the number of minors consumed is a
     sample-complexity cost, not a bookkeeping one. Establish what the standard
     approach consumes — which orders of minor, how many — and whether the
     sparse four-set data studied here has any counterpart there. The Seidel
     restriction may make the comparison vacuous; say so if it does.
   - **Synchronization over the two-element group.** Recovering node signs from
     relative measurements is exactly the gauge situation of a switching class,
     and the standard spectral and semidefinite methods consume pairwise
     measurements. Ask whether any deployment observes only higher-order
     consistency — whether a small group of measurements is coherent — rather
     than individual pairwise relations, and what it does today.
   - **Signed networks and balance.** Balance theory reads exactly the coherence
     of small vertex sets in a signed graph. Determine whether inference there
     is ever driven by four-set coherence counts rather than by edge signs.
   - **Measurement protocols on the golden operator.** The lane's own
     `golden` material already casts the triangle cubic as a success
     probability and states a query-optimality result in a coherent black-box
     model. If a four-set alignment test corresponds to a realizable
     measurement, the query count is experiment count and a factor of six is a
     factor of six in laboratory time. This is the candidate most likely to be
     concrete and the one least likely to be already studied.

   For each candidate record the state-of-the-art method by name, its cost in
   queries or samples as a function of \(n\), the cost of the decoder studied
   here in the same units, and a verdict. "No setting has this oracle, so the
   count is of internal interest only" is an acceptable and likely conclusion,
   and is more useful than a speculative application. Do not claim a speedup
   without a named baseline and matched units, and do not write an applications
   paragraph into the manuscript on the strength of an analogy.

## Boundaries

- Research, computation, and written proposals only. No manuscript edits.
- Any Lean statement that emerges is proposed here and landed under the task
  that owns the module; the aligned-design modules are C815's until it closes.
- Every computational claim follows `notes/research-reproducibility-conventions.md`:
  committed generator, committed compact certificate, exact replay command,
  SHA-256 hashes, and either an independent replay or a stated reason none
  exists. Negatives are stated with the exact searched domain and stop
  condition.
- Enumerations at \(n=8\) and above are compute-heavy; write them in Rust from
  the start rather than prototyping in Python and porting.

## Acceptance

Met, with the evidence named:

- The six-point threshold question is answered, with a witness pair a reader can
  check by hand.
- The exact minimum test count is known at \(n=7\) (30 of 35) and bracketed at
  \(n=8\) (30 to 44 against the exhibited 53).
- The complexity claim Paper III should make is written out with both bounds and
  the size of the gap: adaptively \(\binom n2-n\) to \(\binom n2+n-4\), a
  window of width \(2n-4\); nonadaptively \(0.616\,n^2\) to \(3n^2\), where
  the lower end is believed loose because it ignores which pairs a test can
  separate.
- The literature audit carries a verdict per claim, read depths, a full-text
  count, and a coverage statement separating searched-and-found-nothing from
  could-not-access.
- Every surviving finding arrives as drafted LaTeX quoting the lines it
  replaces, with the alternatives that did not occur named and discarded.
- The mystery ledger in each report records what the closeout and the referee
  pass settled and what they did not.

Not met, and carried as open work above:

- Item 8's acceptance condition — a named baseline with matched units — is not
  met by any setting located, and the report says so rather than reaching.
- The bootstrap constants have no independent replay; the reason is stated in
  the report's Reproduction section rather than being papered over.
