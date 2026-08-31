# C1003 — matching-design publication routing

**Lane:** `relconic`

**Status:** Complete; forward-paper strengthening selected, with no manuscript,
summary, mirror, formal, release, or Ergodis source edit.

## Decision

Integrate the C1002/C1008 packet into the existing equality-classification
appendix of `papers/arcs_complete_outside_conic/`. Do not open a companion or
standalone paper from the present result.

The publication unit is:

1. an all-size, odd-characteristic six-local necessary condition for a
   rank-three realization of a simple maximum-matching design;
2. the equivalent scalar certificate
   \[
   D(G)=\sum_v\deg(v)^2-2|E(G)|-6T(G)
       =2\#\{\hbox{induced }P_3\};
   \]
3. the exact local-concurrence average; and
4. the three-block human exclusion of both ten-point abstract classes in odd
   characteristic.

Use this packet to replace only the odd-characteristic elimination paragraph
in Theorem `thm:match-ten-realization`. Retain the characteristic-two exact
elimination, the forced root `t^3+t+1`, the `F_8` construction, and their
public certificate.

This is the right destination because the arcs paper already owns all three
interfaces the result needs: the equality-to-matching-design transfer, the
definition of rank-three realization, and the ten-point field classification.
The new proof turns a trusted computer exclusion into a short geometric one
and supplies a reusable obstruction for every size. A separate paper would
need substantially more: an infinite-family exclusion, a sufficient
criterion, or a genuine representation classification.

## What has actually been proved

The packet has three different strengths and they should not be conflated.

- **Family theorem:** for every simple
  `MATCH(k,floor(k/2),1)` design admitting a rank-three realization over an
  odd-characteristic field, each six-set has a concurrence graph which is a
  disjoint union of cliques and has an odd component. Equivalently, its
  scalar defect is zero and it has an even-degree vertex. Its concurrence
  count lies in `{0,1,2,3,4,6,10}`.
- **Global numerical consequence:** the mean six-set concurrence is
  \[
  \frac{30(m-2)}{(k-4)(k-5)},\qquad m=\lfloor k/2\rfloor,
  \]
  namely `15/(k-5)` for even `k` and `15/(k-4)` for odd `k`.
- **Complete ten-point consequence:** Mathon's two abstract
  `MATCH(10,5,1)` classes both fail in odd characteristic, witnessed in each
  representative by the same three blocks through one edge. Combined with
  the existing characteristic-two computation, this preserves the current
  all-field ten-point theorem.

Thus the new general result is a **family-level necessary obstruction**, not
a full representation classification. The `k=10` corollary participates in
a full classification only because the two abstract classes and the
characteristic-two branch are supplied independently.

## The classical seam and the calibrated novelty claim

For even `k=q+2`, a simple `MATCH(k,k/2,1)` design is exactly an abstract
hyperoval of order `q`: its blocks are fixed-point-free involutions, and the
matching-design axiom says that every two disjoint transpositions occur in a
unique involution. Equivalently, its edge/block incidence structure is the
associated partial geometry. This vocabulary should be added to the arcs
paper; omitting it makes the ten-point discussion look farther from the
classical literature than it is.

The following parts are classical or externally supplied.

- Hyperfactorizations/perfect-matching designs and the hyperoval construction
  predate the arcs paper.
- There are exactly two abstract hyperovals of order eight, equivalently two
  `MATCH(10,5,1)` designs; their associated partial geometries are Mathon's
  two `pg(5,7,3)` geometries.
- Classical abstract-oval work separates the embeddable and nonembeddable
  order-eight class. Here *embeddable/projective* means arising from a
  hyperoval in a projective plane of order eight.

The arcs paper uses a different, weaker-completion but stricter-linear notion:
it embeds only the 73-point secant ambient into `PG(2,K)`, for an arbitrary
field `K`, and does not assume that this partial incidence configuration
completes to a plane of order eight. The literature located in this audit did
not state the C1002 six-local odd-characteristic obstruction, its exact
average, the scalar induced-`P_3` certificate, or the three-block weak
field-realizability exclusion.

The owning novelty-ledger wording should therefore be no stronger than:

> Abstract hyperovals and the two order-eight classes are classical. What
> was not located in the searched literature is the six-point
> odd-characteristic obstruction for weak rank-three realizations over an
> arbitrary field, together with its scalar certificate and the resulting
> three-block exclusion of the two order-eight classes.

Do not claim a first classification of order-eight abstract hyperovals, a
first nonembeddability result, or a new classification of `pg(5,7,3)`. Do not
use an unqualified priority claim: the original Buekenhout and Faina full
texts were not both available here.

## Exact paper integration

The insertion point is the start of Appendix `sec:equality-classifications`,
after Definition `def:rank-three-realization` and before the six/seven-point
corollary. The logical order should be:

1. one paragraph identifying even maximum-matching designs with abstract
   hyperovals and citing the classical terminology;
2. a proposition titled, for example, **Six-local obstruction in odd
   characteristic**;
3. a one-paragraph scalar reformulation as a remark or corollary;
4. the exact-average lemma; and
5. the present six/seven and ten-point results as applications.

The ten-point proof should preserve its abstract-classification and
partial-geometry paragraphs, then replace the normalized 189-equation
odd-characteristic argument by the three-block proof. The coordinate
elimination subsection remains, explicitly limited to characteristic two.

### Draft proposition language

> **Proposition (six-local obstruction).** Let `D` be a simple
> `MATCH(k,floor(k/2),1)` design with a rank-three projective realization over
> a field of characteristic different from two. For every six vertices
> `S`, form the graph whose vertices are the six one-factorizations of `K_S`,
> joining two when the corresponding pair of perfect matchings extends to a
> block of `D`. Then this graph is a disjoint union of cliques and at least
> one clique has odd order. Consequently its number of edges belongs to
> `{0,1,2,3,4,6,10}`.

> **Proof sketch.** Restrict the realized design blocks to the six vertices;
> each supported perfect matching is a triple-chord concurrence.  Under the
> classical bijection between the fifteen perfect matchings and the pairs of
> the six one-factorizations, the Pappian double-perspectivity determinant
> makes adjacency transitive, hence an equivalence relation.  The three
> perfect matchings containing any fixed edge correspond to a perfect
> matching of the six factorization vertices.  If all three were concurrent,
> the three diagonal points of the complementary quadrangle would lie on one
> chord, impossible in odd characteristic.  Thus the cluster graph has no
> perfect matching, equivalently it has an odd component.  The displayed
> edge set follows by enumerating the permitted partitions of six.

The final manuscript proof should use the fully expanded incidence and
double-perspectivity argument from C1002/Paper I rather than rely on this
compressed sketch.

### Draft scalar remark

> For a graph `G`,
> \[
> \sum_v\deg(v)^2-2|E(G)|-6T(G)
> \]
> is twice the number of induced three-vertex paths. Hence the union-of-
> cliques condition is the single equality `D(G)=0`; the odd-component
> condition is equivalent, for a six-vertex cluster graph, to the existence
> of an even-degree vertex.

### Draft ten-point replacement

> For `k=10`, the four-point complement of any six-set has three perfect
> matchings.  The two edges of each determine a unique design block, whose
> other three edges perfectly match the six-set; hence every six-set has
> concurrence count three (in agreement with the exact average).  Its
> concurrence graph must therefore be `K_3 disjoint union 3K_1`; the
> alternative `3K_2` is forbidden. In each of Mathon's two representatives
> the blocks
> \[
> 09|12|34|57|68,\quad
> 09|13|24|58|67,\quad
> 09|14|23|56|78
> \]
> restrict on `{0,1,2,3,4,9}` to `3K_2`. Geometrically, their concurrence
> would put all three diagonal points of the quadrangle `{1,2,3,4}` on the
> chord `09`, impossible outside characteristic two.

## Post-acceptance deliverables

### Human proof and citations

- Add the full six-local proof and exact double count from C1002.
- Add the C1008 induced-`P_3` identity as a compact recognition certificate;
  do not present its exhaustive graph census as proof.
- Add terminology citations to Polster for abstract hyperovals and their
  secant ambient, and retain Alspach--Heinrich, Mathon, and
  Reichard--Woldar for matching designs and the two order-eight partial
  geometries.
- Add Faina only for the classical order-at-most-eight abstract-oval
  classification, with wording no stronger than the source access permits.
- State explicitly that classical projectivity/embeddability and the paper's
  arbitrary-field rank-three realization are different notions.

### Computational evidence

- Keep `check_match10_rank_three.py`, JSON, and checksum because the
  characteristic-two nonrealizability and `F_8` necessity still depend on
  them.
- Mark the odd-characteristic rational-module lifts as **superseded for the
  theorem proof but retained as independent regression evidence**. Do not
  delete the evidence bundle merely because the proof no longer needs that
  branch.
- Add a tiny deterministic checker for the three displayed blocks only if
  the paper's evidence schema requires every imported representative fact to
  be replayable. It should emit the bad six-set and `3K_2`, not rerun
  coordinate elimination.
- The 32,768-graph C1008 census is optional audit evidence. The public
  theorem should rest on the induced-`P_3` identity.

### Formal annotations

- Classify the six-local proposition, parity step, exact average, and
  three-block contradiction as human proof.
- Classify Mathon's two-class completeness as an external theorem.
- Classify the characteristic-two branch as trusted exact computation and
  the `F_8` construction as direct finite-field verification.
- No Lean expansion is required for publication. A future formalization
  would naturally split into graph lemmas (`D=2 induced-P3` and cluster
  partitions of six), the exact double count, and the projective quadrangle
  determinant `-2`.

### Geometric transfer statement

Add one explicit transfer corollary back to the main defect theorem:

> If zero defect forces a simple maximum-matching design, then over an
> odd-characteristic field every six vertices of the equality arc obey the
> cluster-plus-odd-component test. Therefore one bad six-set certifies
> positive defect without solving coordinates globally.

Keep this as an equality obstruction, not a new numerical lower bound unless
the quantitative defect contribution of a bad six-set is separately proved.

### Release surfaces

- Update the manuscript's claim--proof--novelty ledger first; all summary
  wording must quote or point to that row.
- Then update the manuscript, proof audit, evidence map, formal annotation
  table, README, result snapshot, and portfolio summary.
- Rebuild the deterministic PDF, run the paper's proof/evidence/release
  gates, and synchronize the standalone mirror under the export rules.
- The abstract and title need not change. At most, the appendix description
  in the introduction should say that the ten-point odd-characteristic
  exclusion is now geometric rather than computational.

No one of these surfaces was edited in C1003.

## Ergodis decision

Do not add a public Ergodis command or modify Ergodis source now.

The test is worthwhile as a **private prefilter contract** for any future
maximum-matching-design coordinate search:

```text
input: labelled simple MATCH(k,floor(k/2),1) block list
for each six-set S:
    build its six-vertex concurrence graph G_S
    compute D(G_S) and degree parity
    if D(G_S)>0 or all degrees are odd:
        reject odd-characteristic rank-three realizability
        emit S and the extending blocks
output: pass means only "not rejected"
```

This is linear in the number of inspected local extensions once the block
index is built, returns a small human-readable certificate, and should run
before orbit or coordinate construction. It becomes worth productizing only
when a real design-generation workflow consumes it or when further local
obstructions make the filter a reusable hierarchy. The scalar expression,
certificate schema, and control-interface observations already recorded in
C1008 are sufficient design notes until then.

## Literature audit

Opening count: **one source was read at full-text depth** in this audit.
The negative verdict is therefore phrased as “not located in the searched
domain,” not as a categorical priority claim.

- **Alspach--Heinrich, _Matching Designs_ (1990).** Read depth: `partial`;
  published OCR PDF, abstract, Section 1 in full, the small-order
  classification paragraph, Theorem 1.2 and its hyperoval construction,
  Section 3's `MATCH(7,3,1)` nonexistence, and the bibliography were read.
  Cache key `dblp:journals/ajc/AlspachH90`, SHA-256
  `1a9dd6fb3f004d30fd24b6f531e8cd47c950b491768ec3d29b580c01761fedbb`.
  This verifies the matching-design definition, the report of Mathon's two
  ten-point classes, and the hyperoval construction.
- **Polster, _Abstract hyperovals and Hadamard designs_ (1997).** Read depth:
  `full text`; published OCR PDF, all sections. Cache key
  `ajc:16:polster-abstract-hyperovals`, SHA-256
  `f8dbb06290df3b4ee20d4c1ac777da10e7dfa0bbb1d05b335993dd74c5992e8c`.
  This verifies the abstract-hyperoval definition, equivalence with even
  abstract ovals, projective/embeddable terminology, and the 73-point secant
  ambient relevant at order eight.
- **Cooper, _Abstract hyperovals, partial geometries, and transitive
  hyperovals_ (2015 dissertation).** Read depth: `partial`; dissertation PDF,
  Chapters 6.1--6.3, the order-eight classification paragraph, the
  abstract-hyperoval/partial-geometry equivalence, and the relevant
  bibliography entries were read. Cache key `10.25675/3.018898`, SHA-256
  `4f418666a64b13e2b15e5461af9567f7c791866641ace62229d4f0f83faa4f37`.
  This secondary synthesis explicitly reports two abstract hyperovals of
  order eight, one embeddable and one nonembeddable, giving four pointed
  abstract ovals.
- **Faina, _The B-ovals of order q <= 8_ (1984), DOI
  `10.1016/0097-3165(84)90038-4`.** Read depth: `abstract/metadata only`;
  ScienceDirect title, abstract, DOI, and publication metadata. The abstract
  says that the paper classifies Buekenhout ovals through order eight and
  points out their relationship with `pg(t,2t-3,t-2)`. The full text was not
  reachable, so individual theorem wording is not attributed directly to it.
- **Giulietti--Montanucci, _Abstract ovals of order 9_ (2009).** Read depth:
  `partial`; published five-page scan, abstract, introduction, Section 2 and
  Theorem 3.2 were read through OCR. Cache key
  `ars-combinatoria:91:abstract-ovals-order-9`, SHA-256
  `059cf5ef78beae5f5d3cf0170d0f8f184b5ea197eaa8c675b415f6e411e963aa`.
  Load-bearing order-eight prose was **not** verified against the original
  page images and is used only as corroborating secondary history, not as the
  basis of the verdict.
- **Reichard--Woldar, _Constructing partial geometries from overlarge sets of
  Steiner systems_, DOI `10.1007/s13366-021-00570-7`.** Read depth: `partial`;
  author-uploaded preprint rendered by ResearchGate, abstract, introduction,
  Section 5 construction, Proposition 5.1.4, Proposition 5.1.5 and Corollary
  5.1.6. The downloadable PDF returned HTTP 403 and was not cached. The
  preprint constructs and distinguishes Mathon's two `pg(5,7,3)` geometries;
  it does not discuss weak rank-three field realizations.
- **Mathon, _The partial geometries pg(5,7,3)_ (1981).** Read depth:
  `secondary only`; Alspach--Heinrich (`partial` above), Cooper (`partial`
  above), and Reichard--Woldar (`partial` above) report its two-class
  classification. The original full text was not located.
- **Buekenhout, _Etude intrinsèque des ovales_ (1966).** Read depth:
  `secondary only`; Polster (`full text` above) and Cooper (`partial` above)
  supply the definition and projectivity terminology used here. The original
  French full text was not obtained.

### Searches and coverage

Exact web queries used:

- `"rank-three" "matching design" projective realization`
- `"MATCH(10,5,1)" projective realization`
- `matching designs concurrent chords arc projective plane`
- `"matching design" projective realization finite field`
- `"B-ovals" "pg(5,7,3)"`
- `"MATCH(10,5,1)" Mathon Faina`
- `"abstract hyperoval" embedding larger projective plane`
- `"abstract oval" "weakly embeddable"`
- `"B-oval" embedding Pappian plane field`
- `"abstract hyperoval" representable field`
- `"pg(5,7,3)" embedding projective plane`
- `"pg(5,7,3)" projective embedding`
- `"partial geometry pg(5,7,3)" representation field`

The searches promoted the classical matching-design, abstract-oval,
abstract-hyperoval, and partial-geometry sources above. No result was found
using the paper's arbitrary-field weak rank-three notion or the six-local
cluster obstruction. No citation-graph exhaustiveness claim is made, and the
negative verdict does not rest on an enumerated citing set.

Coverage gaps: MathSciNet was not accessible; Google Scholar automated search
was not attempted; the original Buekenhout, Mathon, and Faina full texts were
not obtained; the Reichard--Woldar published version was not read; and
terminology for weak embeddings is not standardized enough for keyword search
alone to close priority. These gaps require the qualified novelty wording
above.

## `ej` + `tt` closeout

The useful strengthening is conceptual rather than a larger theorem: the
paper should identify its even matching designs as abstract hyperovals and
state exactly why its realization problem is not classical projectivity.
That makes the new contribution easier to see and prevents an avoidable
priority objection.

The useful subtraction is equally important: after the human odd-
characteristic proof lands, the 189-equation presentation should no longer
lead the ten-point theorem. It remains only for characteristic two and as an
independent regression certificate.

## Mystery ledger

- **Weak-versus-projective embedding theorem — open.** It is not known from
  the sources read whether every weak rank-three realization of an abstract
  hyperoval over a Pappian plane satisfies a classical completion theorem.
  Such a theorem could pre-empt or greatly generalize the field-specific
  elimination and deserves a primary-source audit before any standalone
  claim.
- **Infinite-family force — open.** The six-local test is necessary for all
  sizes, but no infinite family of abstract designs is yet excluded by it.
  This is the main mathematical gate to a standalone representation paper.
- **Sufficiency — open and unlikely locally.** Passing every six-set does not
  currently construct coordinates or imply global realizability.
- **Quantitative defect transfer — open.** One bad six-set certifies failure
  of zero defect, but no numerical lower bound on the global chord defect has
  yet been extracted from the number or type of bad six-sets.
- **Characteristic two local theory — open.** The diagonal determinant
  vanishes identically there, so a useful local obstruction needs a different
  invariant; the current exact computation should remain.
- **Ergodis prefilter — settled for this task.** Preserve the private
  contract; do not productize until a design-construction consumer exists.
