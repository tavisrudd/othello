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
6. **Manuscript proposal.** Write the exact replacement sentences for the
   complexity claim and, if item 1 produces a witness, for the point hypothesis.
   Do not edit the manuscript; promotion belongs to C816 and the final Paper III
   pass to C824.

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
- A mystery ledger records what the closeout pass settled and what it did not.
