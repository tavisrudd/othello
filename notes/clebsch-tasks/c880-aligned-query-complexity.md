# C880 — query complexity of aligned-design reconstruction

**Lane:** `clebsch`
**Status:** queued; research and computation only
**Paper:** III (`papers/clebsch-passages`), theorem `thm:aligned-faithfulness`

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

- The six-point threshold question is answered, with a witness or with an exact
  statement of the searched domain.
- The exact minimum test count is known at \(n=7\), and at \(n=8\) either exactly
  or with stated bounds.
- The complexity claim Paper III should make is written out, with its lower
  bound, its upper bound, and the size of the remaining gap stated plainly; if
  the gap cannot be closed, the report says which of the two sides is believed
  loose and why.
- The literature audit carries a verdict per claim, a read depth on every named
  source, a full-text count in its opening summary, and a coverage statement
  separating "searched and found nothing" from "could not access".
- Every finding that survives validation and the audit arrives as drafted
  manuscript LaTeX quoting the lines it replaces, with the alternative wordings
  for the outcomes that did not occur named and discarded explicitly.
- Each candidate application carries a named state-of-the-art baseline, its cost
  and this decoder's cost in the same units, and a verdict — with "no setting
  has this oracle" stated plainly if that is the answer, and no speedup claimed
  without matched units.
- A mystery ledger records what the closeout pass settled and what it did not.
