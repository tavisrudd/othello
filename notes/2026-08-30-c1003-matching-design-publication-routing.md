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
3. the exact local-concurrence average;
4. the three-block human exclusion of both ten-point abstract classes in odd
   characteristic; and
5. the all-field rank-three classification of the four nine-point abstract
   classes, including a sharp counterexample to sufficiency of the six-local
   test.

Use this packet to replace only the odd-characteristic elimination paragraph
in Theorem `thm:match-ten-realization`. Retain the characteristic-two exact
elimination, the forced root `t^3+t+1`, the `F_8` construction, and their
public certificate.

This is the right destination because the arcs paper already owns all three
interfaces the result needs: the equality-to-matching-design transfer, the
definition of rank-three realization, and the ten-point field classification.
The new proof turns a trusted computer exclusion into a short geometric one
and supplies a reusable obstruction for every size. The nine-point boundary
classification is strong enough to publish in the appendix, but a separate
paper would still need substantially more, such as an infinite-family
exclusion or a structural representation theorem.

## What has actually been proved

The packet has four different strengths and they should not be conflated.

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
- **Complete nine-point consequence:** every `MATCH(9,4,1)` design completes
  canonically to a `MATCH(10,5,1)` design. Hence the two ten-point classes
  and their two point orbits supply exactly four nine-point classes. The two
  regular-hyperoval deletions are rank-three realizable over `K` exactly when
  `char(K)=2` and `K` contains `F_8`; the two nonhyperoval deletions are never
  realizable. In odd characteristic three classes fail the six-local test,
  while the fourth passes every six-set and is excluded by a seven-
  concurrence human proof whose last identity is
  `-2(r-1)^2/r^2=0`. Thus the local condition is necessary but not sufficient,
  and the precise global obstruction degenerates in characteristic two.

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
The later audit did locate a close priority ceiling: Nagy proves that the Ree
unital `R(3)` embeds in a projective plane over `K` exactly when `K` contains
`F_8`, with uniqueness and containment in `PG(2,8)`. For the regular hyperoval,
the 63 matching blocks are the same 63 external points, while the 28 external
lines are the one-factorizations of `K_10`. Nagy's hypothesis assumes those 28
nine-point sets are lines. The present rank-three hypothesis assumes only the
hyperoval secant concurrences. No source located here proves that the latter
automatically upgrades to the former.

An exact enumeration makes this bridge canonical rather than terminological.
The regular ten-point matching design has exactly 28 one-factorizations; every
matching block belongs to four, and every pair of factorizations intersects in
one block. Hence the factorization/block incidence is a `2-(28,4,1)` design,
identified with `R(3)` by the regular-hyperoval model in Nagy's Section 2. The
nonhyperoval matching design has only one one-factorization. The remaining
geometric question is exactly whether rank-three secant concurrence forces the
nine matching centers in each of the regular class's 28 factorizations to be
collinear. The ordered factorization-list SHA-256 values are
`6408d524c6f0f50905c6bafe2d03624472a13ebccd8360e973d2ed08f12bc987`
(regular) and
`929e9543b96272615536dc3886c7abc5cb429b8680d56f1c37454a7d567fce7e`
(nonhyperoval).

The owning novelty-ledger wording should therefore be no stronger than:

> Abstract hyperovals and the two order-eight classes are classical. What
> was not located in the searched literature is the six-point
> odd-characteristic obstruction for weak rank-three realizations over an
> arbitrary field, together with its scalar certificate and the resulting
> three-block exclusion of the two order-eight classes. Nagy's Ree-unital
> embedding theorem already supplies the same `F_8` field boundary for the
> regular external-line design under a stronger incidence hypothesis. What was
> not located is the automatic passage from the matching design's secant-
> concurrence realization to that Ree-unital embedding, or the all-field
> nonrealizability of the two nonhyperoval deletions.

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
5. the present six/seven, nine-point, and ten-point results as applications.

Put the nine-point classification immediately before the ten-point theorem.
Its completion lemma is human proof; the count of four pointed classes is an
external-classification input; three odd-characteristic exclusions have
short local certificates; the remaining odd-characteristic exclusion has a
short normalized-coordinate proof; and only the characteristic-two
classification remains trusted exact computation.

### Draft nine-point theorem

> **Theorem (nine-point boundary).** Up to isomorphism there are four simple
> `MATCH(9,4,1)` designs. The two obtained by deleting a point from the
> regular order-eight abstract hyperoval admit a rank-three realization over
> a field `K` if and only if `K` has characteristic two and contains `F_8`.
> The other two admit no rank-three realization over any field.
>
> Every nine-point design completes canonically: adjoin a new vertex and, in
> each block, pair it with the unique omitted old vertex. For a fixed old
> edge the seven blocks through it partition the edges on the other seven
> vertices into near-one-factors; a degree count shows that each omitted
> vertex occurs once. The completion is therefore a `MATCH(10,5,1)` design.
> Mathon's two ten-point classes and their two point orbits give the four
> nine-point classes. Three representatives violate the six-local
> obstruction. The remaining regular-hyperoval deletion passes every local
> test. Normalize four points to the projective frame and put
> `a=x_8`, `b=y_8`, and `r=b/a`. Seven concurrence equations successively
> give `x_4=1/r`, `x_7=b`, `y_5=ar^2`, `y_6=r^2`,
> `r^2(a-1)=1-r`, and
> `a(r^2+r-2)+1/r-r^2=0`. Substitution reduces the last equation to
> `-2(r-1)^2/r^2=0`. The arc inequalities give `a,b!=0` and `a!=b`, hence
> `r!=1`, a contradiction in odd characteristic. In characteristic two,
> saturated lexicographic
> bases leave precisely `u^3+u^2+1=0` for the two regular deletions and give
> the unit ideal for both nonhyperoval deletions. Deleting a point from the
> regular hyperoval over `F_8` supplies the converse.

The final theorem should display the seven blocks/equations or point to a
compact certificate table. The normalized substitution proof is human; the
elimination remains independent regression evidence.

For the tracked ordering of the survivor's 126 equations, one minimal core
found by greedy deletion has indices `30,108,100,75,56,76,64`. The underlying
blocks are

```text
03|14|28|67   08|17|23|46   08|13|25|47   06|14|25|38
05|12|38|67   06|15|28|47   05|17|28|34
```

using the third line-concurrence equation in every block except the fourth,
where the fourth is used. Elimination leaves
`x8^4-2*x8^3+x8^2`. The full unsaturated-basis lift has only denominator
prime `2`; its 9,324-byte matrix has SHA-256
`0d30b437a8656c008414c0951002820f8474e74efda3f843591f3257e8c4cd54`.

For a human proof, those seven determinants simplify to

```text
x8=x4*y8,  x7=y8,  y5=x5*y8,
y6*x8-x4*y8+x4-y6-x8+y8=0,
y5*(x8-1)=x8-y8,  y6*x8=x5*y8,  y5*x8=x7*y8.
```

With `a=x8`, `b=y8`, and `r=b/a`, the arc inequalities permit division by
`a`, `b`, and `r`, and give `r!=1`. The first, third, sixth, and seventh
relations yield `x4=1/r`, `y5=ar^2`, and `y6=r^2`. The fifth gives
`a=(r^2-r+1)/r^2`. After these substitutions the fourth relation is

\[
 a(r^2+r-2)+\frac1r-r^2
 =-\frac{2(r-1)^2}{r^2}=0.
\]

This contradicts `r!=1` outside characteristic two. The obstruction is
therefore a genuine seven-block gluing defect, invisible on every six-set,
and its characteristic-two disappearance is structural rather than an
artifact of elimination.

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
- Add `notes/c1003_match9_rank_three.py` (or move a publication copy into the
  paper's checker directory after acceptance) as the exact nine-point replay.
  It derives all twenty labelled deletions from the tracked ten-point
  representatives, verifies canonical completion, emits all six-local
  witnesses, checks the four characteristic-two orbit representatives,
  verifies the odd-characteristic integral lift, and checks the seven-
  equation elimination polynomial. It also enumerates the 28 canonical regular
  one-factorizations, verifies their `2-(28,4,1)` intersection parameters, and
  distinguishes the nonhyperoval's unique factorization. Its input is the
  existing tracked JSON; it does not silently re-enumerate the abstract
  classes.

### Formal annotations

- Classify the six-local proposition, parity step, exact average, and
  three-block contradiction as human proof.
- Classify Mathon's two-class completeness as an external theorem.
- Classify the two point orbits in each ten-point class as an external input,
  and the canonical nine-to-ten completion as human proof.
- Classify the nine-point seven-concurrence substitution as human proof, its
  elimination as independent regression evidence, the characteristic-two
  branch as trusted exact computation, and
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

The nine-point survivor is the preferred hard-negative regression case: the
local prefilter must accept it, while the coordinate layer must reject it in
odd characteristic. A future control interface should expose stage-specific
outcomes such as `locally_rejected`, `locally_admissible`, and
`globally_inconsistent` rather than collapse every negative result to one
status. Preserve this as a product note; it does not justify an Ergodis
source edit here.

## Literature audit

Opening count: **three sources were read at full-text depth** in this audit.
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
- **Bamberg--Harris--Penttila, _On abstract ovals with Pascalian secant
  lines_ (2018), DOI `10.1515/jgth-2018-0028`.** Read depth: `full text`;
  author-accepted manuscript, all sections. Cache key
  `10.1515/jgth-2018-0028`, SHA-256
  `5dfeb843d0cd9342c6689aa96168f44e9bed7b37b0004248cb509658884351c7`.
  It characterizes abstract conics by regular involutions and Pascalian secant
  lines and reconstructs `PGL(2,F)` through Moufang sets. It does not study a
  projective realization of only the finite secant-concurrence reduct.
- **Nagy, _Embeddings of Ree unitals in a projective plane over a field_
  (2021), DOI `10.1016/j.ffa.2021.101875`.** Read depth: `full text` for
  arXiv v3 (`arXiv:2007.10464`, all sections), cache SHA-256
  `e268f76c7f01a40dd07d59f2077b0fb14a3b8c654041432d1dbf2296ea021f61`;
  the published version's Sections 1--5 were also checked, cache SHA-256
  `99e5b60d981c80fe358bad28ebbfe5d6cf18b4f19a50fe8480966c74477aed30`.
  Theorem 1 proves that `R(3)` embeds in `PG(2,K)` exactly when `F_8` is a
  subfield of `K`, uniquely and inside an order-eight subplane. Sections 2 and
  5 identify its dual model with the 63 external points and 28 external lines
  of the regular hyperoval and derive an odd-characteristic factor `2` followed
  by `v^3+v^2+1` in characteristic two. This is the firm priority ceiling for
  the regular nine-point field conclusion, but its input includes the 28
  external-line blocks absent from the matching-design realization notion.
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
- `"abstract oval" Pascalian secant lines`
- `"abstract hyperoval" projective embedding cross ratio`
- `hyperfactorization projective representation field concurrence`
- `"pg(5,7,3)" embedding projective plane`
- `projective plane punctured subplane embedding extends field monomorphism`
- `embedding partial projective plane into Desarguesian plane subfield theorem`
- `linear representation abstract conic secant incidence embedding`
- `"secant lines" "abstract conic" embedding`
- `"matching design" "Ree unital"`
- `"abstract oval" "Ree unital"`
- `"abstract hyperoval" "Ree unital"`
- `"MATCH(9,4,1)" unital`
- `one-factorization K10 collinear points hyperoval external line`
- `perfect matchings concurrence centers collinear projective geometry`
- `hyperoval one-factorization external lines matching design`
- `"one-factorization" "external line" hyperoval`

The searches promoted the classical matching-design, abstract-oval,
abstract-hyperoval, partial-geometry, Pascalian-secants, and Ree-unital sources
above. No result was found using the paper's arbitrary-field weak rank-three
notion, the six-local cluster obstruction, or an automatic one-factorization-
line completion from the secant-concurrence data. Nagy's theorem prevents any
claim that the bare `F_8` boundary or its factor-two/cubic coordinate mechanism
is new. No citation-graph exhaustiveness claim is made, and the negative verdict
does not rest on an enumerated citing set.

Coverage gaps: MathSciNet was not accessible; Google Scholar automated search
was not attempted; the original Buekenhout, Mathon, and Faina full texts were
not obtained; the Reichard--Woldar published version was not read; and
terminology for weak embeddings is not standardized enough for keyword search
alone to close priority. The exact equivalence, if any, between the seven-block
shadow here and Nagy's super O'Nan configuration has not yet been checked.
These gaps require the qualified novelty wording above.

### Verdict-change surface checklist

- Updated here: C1003 routing/novelty report, archive row, relconic handoff, and
  C1015 successor card/queue row.
- Not edited by instruction: manuscript, claim--proof--novelty ledger, README,
  results snapshot, portfolio summary, mirror, and formal/release surfaces.
  The scoped search found no existing `MATCH(9,4,1)` or Ree-unital claim on the
  manuscript/README/snapshot surfaces, so no published sentence was left with
  the superseded priority wording.

## `ej` + `tt` closeout

The extra-juice strengthening is now both conceptual and theorem-level. The
paper should identify its even matching designs as abstract hyperovals and
state exactly why its realization problem is not classical projectivity; it
can then classify all four nine-point deletions under the weaker arbitrary-
field rank-three notion. The Tao/literature pass then located Nagy's Ree-unital
theorem, which already owns the regular model's `F_8` boundary under the
external-line incidence hypothesis. The genuinely higher opportunity is now
to prove that secant concurrence forces those external lines: a completion
theorem turning the matching realization into a Ree-unital embedding.

The useful subtraction is equally important: after the human odd-
characteristic proof lands, the 189-equation presentation should no longer
lead the ten-point theorem. It remains only for characteristic two and as an
independent regression certificate.

## Mystery ledger

- **Weak-versus-Ree completion theorem — open, owned by C1015.** For the
  regular ten-point design, the 63 matching centers are Nagy's 63 dual
  Ree-unital points and the 28 one-factorizations are the missing external-
  line blocks. It is not known whether the concurrence realization forces
  each nine-center factorization to be collinear. A positive bridge would let
  Nagy's theorem replace the regular-class coordinate classification and add
  uniqueness, admissibility, and subplane containment.
- **Infinite-family force — open.** The six-local test is necessary for all
  sizes, but no infinite family of abstract designs is yet excluded by it.
  This is the main mathematical gate to a standalone representation paper.
- **Sufficiency — settled negatively.** The regular-hyperoval deletion at the
  distinguished point passes every six-set but is impossible in odd
  characteristic. It is a small explicit witness that local admissibility
  does not imply global realizability.
- **Human form of the seven-equation certificate — settled in normalized
  coordinates.** The seven determinants reduce by direct substitution to
  `-2(r-1)^2/r^2=0`, contradicting the arc inequality `r!=1` in odd
  characteristic. The exact elimination and integral lift remain independent
  regression evidence.
- **Projective meaning of the ratio defect — open, owned by C1015.** The
  normalized ratio `r=b/a` behaves like a transition/holonomy parameter, but
  the frame-free bracket or cross-ratio invariant and the class of incidence
  shadows carrying the same `2(r-1)^2` defect have not yet been identified.
- **Quantitative defect transfer — open.** One bad six-set certifies failure
  of zero defect, but no numerical lower bound on the global chord defect has
  yet been extracted from the number or type of bad six-sets.
- **Characteristic two local theory — open.** The diagonal determinant
  vanishes identically there, so a useful local obstruction needs a different
  invariant; the current exact computation should remain.
- **Ergodis prefilter — settled for this task.** Preserve the private
  contract; do not productize until a design-construction consumer exists.
