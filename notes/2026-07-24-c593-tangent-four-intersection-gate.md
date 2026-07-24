# C593: tangent-derived four-intersection obstruction gate

**Lane:** `relconic`

**Date:** 2026-07-24

**Status:** COMPLETE NEGATIVE

## Objective

At zero relative-conic defect, determine whether the global arrangement of
tangents to the arc supplies the rank-three compatibility invariant missing
from C554--C555 and C592.  Audit prior tangent-envelope, few-intersection-set,
and few-weight-code results; then test the strongest applicable incidence,
polynomial, and code-weight constraints.  C556 opens only if this gate yields
a field-uniform carrier or positive-defect mechanism.

## Exact input

Let \(A\) be a \(k\)-arc in \(\PG(2,q)\), let \(r(x)\) count its secants
through \(x\notin A\), and let \(\tau_A(x)\) count its tangents through \(x\).
Then
\[
 k=2r(x)+\tau_A(x).
\]
If \(\mathcal T_A\subset\PG(2,q)^*\) is the set of dual points representing
all tangents, then
\[
 |\mathcal T_A|=k(q+2-k).
\]
Zero defect gives \(r(x)\in\{0,1,\lfloor k/2\rfloor\}\), so the line
intersection spectrum of \(\mathcal T_A\) is contained in
\[
 \{q+2-k,0,k-2,k\}\quad(k\ \mathrm{even})
\]
or
\[
 \{q+2-k,1,k-2,k\}\quad(k\ \mathrm{odd}).
\]
Moreover the number of zero-secants in even size is \((k-1)(k-3)\), and the
number of one-secants in odd size is \(k(k-2)\).

## Stable reformulation

The tangent set retains the full defect, not only its zero locus.  For a dual
line \(\ell=x^*\), put \(j(\ell)=|\ell\cap\mathcal T_A|=\tau_A(x)\), so
\[
 r(x)=\frac{k-j(\ell)}2.
\]
The exact defect identity becomes
\[
 m\Delta_{\mathcal C}(A)=
 \sum_{x\in\mathcal X_{\mathcal C}(A)}
 \left(\frac{k-j(x^*)}{2}-1\right)
 \left(m-\frac{k-j(x^*)}{2}\right)
 \sum_{y\in\mathcal C}
 \frac{k-j(y^*)}{2}
 \left(m-\frac{k-j(y^*)}{2}\right).
\]
Thus \(\Delta_{\mathcal C}(A)\) is a weighted distance from a
four-intersection spectrum, with a distinguished \(q+1\)-line family
\(\{y^*:y\in\mathcal C\}\) carrying the shifted weight.  A useful theorem must
exploit either this tangent-derived contact structure or stability of this
almost-few-intersection set.  An exact zero-defect classification alone cannot
improve the asymptotic bound unless it supplies a quantitative stability gap.

## Characteristic-two code bridge

There is an elementary identity stronger than the generic few-weight-code
translation.  Work over \(\mathbb F_2\), and write
\(\mathbf 1_{a^*}\) for the incidence vector of the dual line corresponding
to \(a\in A\).  At a dual point representing a primal line \(\ell\),
\[
 \sum_{a\in A}\mathbf 1_{a^*}(\ell)
 =|A\cap\ell|\pmod2.
\]
An arc line contains zero, one, or two points of \(A\), so its odd
intersection lines are exactly its tangents.  Therefore
\[
 \boxed{\quad
 \mathbf 1_{\mathcal T_A}=\sum_{a\in A}\mathbf 1_{a^*}
 \quad\text{in }\mathbb F_2^{q^2+q+1}. \quad}
\]
In particular \(\mathbf 1_{\mathcal T_A}\) belongs to the binary line code
\(C_2(\PG(2,q)^*)\).  Its scalar product with a dual line \(x^*\) is
\(\tau_A(x)\bmod2=k\bmod2\), both for \(x\notin A\) by
\(k=2r(x)+\tau_A(x)\) and for \(x\in A\) because
\(\tau_A(x)=q+2-k\).  Hence, for even \(q\),
\[
 \begin{cases}
 \mathbf 1_{\mathcal T_A}\in C_2\cap C_2^\perp,&k\text{ even},\\
 \mathbf 1_{\PG(2,q)^*\setminus\mathcal T_A}\in
 C_2\cap C_2^\perp,&k\text{ odd},
 \end{cases}
\]
using that the all-one vector belongs to \(C_2\).  The even-\(k\) hull word
has exact weight \(k(q+2-k)\).  This supplies a precise code-classification
target; it is not yet an obstruction, since existing hull weight ranges must
be checked at the target scale \(k\asymp\sqrt{2q}\).

## Transversal-design sharpening

Put \(h=q+2-k\).  The tangent set splits into \(k\) groups
\[
 \mathcal T_a=\mathcal T_A\cap a^*,\qquad |\mathcal T_a|=h
 \quad(a\in A).
\]
A dual line not among the \(a^*\) contains at most one point of each group.
At zero defect, every line through points of two different groups is therefore
either a full \(k\)-transversal or a \((k-2)\)-transversal missing exactly the
two contacts joined by its unique primal secant.  For each missing pair there
are
\[
 d=\begin{cases}h,&k\text{ even},\\h-1,&k\text{ odd}\end{cases}
\]
such partial transversals.  Counting pairs between any two fixed groups gives
the number \(F\) of full transversals:
\[
 F=h^2-\binom{k-2}{2}d.
\]
All full transversals are dual to index-zero points of the prescribed conic,
so they belong to its distinguished dual-conic line family.  This is more
structured than an abstract four-character set: it is a collinearly embedded
\(\{k-2,k\}\)-group-divisible design of type \(h^k\) and index one, with
prescribed missing pairs.  It is not a dual \(k\)-net or
\(\operatorname{TD}(k,h)\), since its short blocks miss two groups.

The closest classical bridge would be a resolution of the C554 maximum-
matching focus family.  Such a resolution selects \(k-1\) pairwise
edge-disjoint matching blocks covering \(K_k\), hence makes \(A\) a
generalized hyperfocused arc in the standard sense.  Regularity alone does not
prove that a resolution exists.

As a bounded falsifier, both certified abstract \(\operatorname{MATCH}(10,5,1)\)
classes from C574 do contain a resolution.  The deterministic certificate
selects and directly verifies nine disjoint blocks in each of the two
63-block designs.  Thus the resolution gate survives the two known ten-point
classes; it does not distinguish the rank-three-realizable classical class
from the field-uniformly impossible Mathon class.

Replay from the repository root:

```bash
python3 notes/2026-07-24-c593-tangent-four-intersection-gate.py --check
sha256sum -c notes/2026-07-24-c593-tangent-four-intersection-gate.sha256
```

The load-bearing input is the committed C574 JSON certificate (77,761 bytes,
SHA-256
`ce83bb36f5dcaf8161a8e28a26878e009e74e24c6393576b5b1bb3c0c938ec95`).
The C593 generator is 3,811 bytes with SHA-256
`346c2cf13e79c825764d00d414655f910cc4e7174a2bc4b666368b5653d554ee`;
its canonical JSON output is 6,067 bytes with SHA-256
`0b7809574ce719061d4d9753dda2c2b8beff9716532be1f2b9c2f46eeda9c407`.
The checker trusts Python's JSON parser and integer/set operations.  Direct
union of the nine selected matchings independently verifies that every one of
the 45 edges occurs exactly once.  This finite existence result proves neither
that every matching design is resolvable nor that a resolution is
geometrically embedded.

## Bounded literature audit

**Depth and verdict.**  One of the ten primary sources below was read at
`full text` depth and nine at `partial` depth.  No theorem was located that
classifies or excludes the tangent-derived four-spectrum, or the equivalent
embedded mixed-block GDD, near \(k\sim\sqrt{2q}\) in characteristic two.
This is a bounded mechanism check, not a manuscript-grade novelty closure:
MathSciNet and Google Scholar were unavailable, and no three-service
forward-citation closure was attempted.  The classical ingredients
“tangent envelope,” “even-set codeword,” and “embedded 1-factorization” must
not be claimed as new.  The potentially new target is their simultaneous
multiply-hyperfocused, prescribed-conic realization.

### Closest sources

1. Ball--Csajbók, [*On Segre's Lemma of
   Tangents*](https://doi.org/10.1016/j.endm.2018.06.003), published 2018
   version.  **Read depth:** `full text`, all six pages, cached from the UPC
   repository under `10.1016/j.endm.2018.06.003`, fetched 2026-07-24,
   SHA-256
   `32ed679c03be2c4dfbb65931b1419bea49d47aefdcaf8e05fdb228126d58cde4`.
   Theorem 1.2 puts the \(t(q+2-t)\) dual tangent points of a
   \((q+2-t)\)-arc on a degree-\(t\) curve when \(q\) is even.  Here
   \(t=q+2-k\sim q\), so the envelope is too high-degree to force the desired
   carrier.
2. Giulietti--Montanucci, [*On Hyperfocused Arcs in
   \(\operatorname{PG}(2,q)\)*](https://arxiv.org/abs/math/0601488),
   arXiv:math/0601488v1 (2006).  **Read depth:** `partial`, Introduction,
   Sections 2--3, and Section 5 theorem statements; cached from arXiv,
   fetched 2026-07-18, SHA-256
   `feb9f148d51c22df3f9ba35867137a0870ca220b1b233c03b0319de720c263f9`.
   This supplies the exact generalized-hyperfocused / embedded
   1-factorization terminology; its non-linear classification is only for
   \(k\le10\).
3. Blokhuis--Marino--Mazzocca, [*Generalized Hyperfocused Arcs in
   \(\operatorname{PG}(2,p)\)*](https://arxiv.org/abs/1304.3617),
   arXiv:1304.3617v1 (2013).  **Read depth:** `partial`, Introduction,
   preliminaries, Theorem 7, and closing examples; cached from arXiv, fetched
   2026-07-24, SHA-256
   `e99476de7becd4a901b3235fb342fcd1869f5555e6902a5f502ec0ab8430d903`.
   Its \(k\in\{1,2,4\}\) conclusion is for prime fields and does not cover
   \(q=2^h\) except \(q=2\).
4. DeOrsey--Hartke--Williford, [*A Classification of Hyperfocused
   12-Arcs*](https://arxiv.org/abs/2105.08300), arXiv:2105.08300v1 (2021).
   **Read depth:** `partial`, Introduction, Section 2 Theorems 5--6, and
   Section 3 Theorem 8; cached from arXiv, fetched 2026-07-24, SHA-256
   `8fa29316865402e57eb62a85d15953c8e1e6bd078e65720f2d3cac9c720c4dfe`.
   This is a fixed-\(k\), linear-focus classification, useful as evidence that
   the known results are specialized rather than asymptotic.
5. Weiner--Szőnyi, [*On the Stability of Sets of Even
   Type*](https://doi.org/10.1016/j.aim.2014.09.007), 2014 author manuscript
   carrying the published-paper text.  **Read depth:** `partial`,
   Introduction, Theorem 1.1, Corollary 1.2, Remarks 1.3--1.4, and Section 4
   Result 4.1, Proposition 4.2, and Theorem 4.6 statement; cached from the MTA
   repository, fetched 2026-07-24, SHA-256
   `84a1c7a75e344fa9fa9479daa10de11e3f0509c79aac99f41d516ca6a9c7a9e9`.
   Its sharp odd-secant stability threshold is asymptotic to \(q^{3/2}\),
   below the present weight \(\sim\sqrt2q^{3/2}\); moreover
   \(\mathcal T_A\) is already an even set when \(k\) is even.
6. Durante, [*On Sets with Few Intersection Numbers in Finite Projective
   and Affine Spaces*](https://www.combinatorics.org/ojs/index.php/eljc/article/download/v21i4p13/pdf/),
   published EJC 21(4), P4.13 (2014).  **Read depth:** `partial`, abstract,
   Section 1.1 definitions and Theorems 3--6, and Section 1.2 main-scope
   statement; cached from EJC under `EJC-21-4-P4.13`, fetched 2026-07-24,
   SHA-256
   `44165ad75ef7652c9e59ebd98a53c6936e93e5507041e196b782448a5fc1be27`.
   The classifications have one proper intersection number, not the present
   four characters.
7. De Boeck--Van de Voorde, [*Elation
   KM-Arcs*](https://arxiv.org/abs/1705.06372), arXiv:1705.06372v1 (2017).
   **Read depth:** `partial`, abstract and first-page definitions and
   classification scope; cached from arXiv, fetched 2026-07-24, SHA-256
   `e8af761177126f3eef5f2abf2e867a83513fece6e864448818b833a2d47910e1`.
8. De Boeck--Van de Voorde, [*A Linear Set View on
   KM-Arcs*](https://arxiv.org/abs/1512.04818), arXiv:1512.04818v1 (2015).
   **Read depth:** `partial`, abstract and first-page definitions and
   construction scope; cached from arXiv, fetched 2026-07-24, SHA-256
   `76bca713d3bad08db9aa7588ae6da1a8bff861a1eafedd2f2d4001dc852e3a4b`.
   Sources 7--8 concern size \(q+t\) and spectrum \(\{0,2,t\}\), so KM-arcs
   and generalized maximal arcs are false friends here.
9. Ball--Lavrauw, [*Planar Arcs*](https://arxiv.org/abs/1705.10940),
   arXiv:1705.10940v4 (2018).  **Read depth:** `partial`, Introduction,
   Theorem 1, and Section 4 Corollaries 8--9; cached from arXiv, fetched
   2026-07-24, SHA-256
   `e9f316f5759f310c829489471b41c84972459482236df5023fb6e1f463c55872`.
   Its strongest Segre-lemma consequences concern large arcs, principally in
   odd characteristic, not \(k\sim\sqrt q\) in even characteristic.
10. Korchmáros--Nagy--Pace, [*\(k\)-Nets Embedded in a Projective Plane over
    a Field*](https://arxiv.org/abs/1306.5779), arXiv:1306.5779v1 (2013).
    **Read depth:** `partial`, abstract, Introduction, Theorems 4.2--4.4, 5.2,
    and 5.4; cached from arXiv, fetched 2026-07-24, SHA-256
    `52dc4d6a47717cc158ac7735f3cc619088f75bb77e53ca017593b148ded60a56`.
    The nonexistence hypotheses fail in characteristic two.  More
    importantly, Theorem 5.4 says that a genuine embedded \(k\)-net with two
    pencil components has all components pencils with collinear bases.
    Therefore the present star-line groups, whose bases are the noncollinear
    arc \(A\), cannot simply complete to a genuine \(k\)-net.

### Search coverage

The shared literature-cache manifest was screened over title and author
fields with the regular expression
`arc|tangent|intersection|weight|character|KM|Segre`: 38 hits were returned
and the first 20 inspected.  The OpenAI web-search backend was screened over
titles and snippets with these query families:

```text
finite projective plane tangent set arc few intersection set theorem PG(2,q)
Segre lemma of tangents arc characteristic two theorem tangent envelope
few intersection sets projective plane two character sets code finite geometry
KM arcs generalized KM arcs line intersection numbers characteristic 2
four-intersection set PG(2,q)
classification projective four-weight codes dimension 3 q-ary
points with no tangents arc PG(2,q)
hyperfocused arcs secants focus line classification characteristic two k-arc
generalized hyperfocused arc secants finite projective plane
k-nets embedded in a projective plane
dual k-net with holes projective plane finite field
holey transversal design embedded projective plane
q+2-k; k(q+2-k); {k-2,k}-GDD; block sizes k-2 and k group divisible design
```

Direct arXiv, DOI, EJC, UPC, and MTA repository PDFs were then checked as
recorded above.  MathSciNet was **not covered** because institutional
authentication was unavailable.  Google Scholar was **not covered** because
automated access was unavailable.  OpenAlex, Crossref, and Semantic Scholar
forward-citation graphs were not queried because this bounded mechanism check
does not claim citation-graph or priority closure.  No located load-bearing
primary source was inaccessible.

## Characteristic-two equality arithmetic

The even-\(k\) equality alternatives from C558 collapse almost completely
when the plane order is a power of two.

### Theorem

Let \(q=2^n\) and let \(k\ge6\) be even.  If a
\(\mathcal C\)-complete \(k\)-arc has zero defect, then
\[
 k=q+2
 \qquad\text{or}\qquad
 (q,k)=(4096,92).
\]
Thus \((4096,92)\) is the only even, square-root-scale zero-defect parameter
pair in a Desarguesian plane of characteristic two.

### Proof

Put \(Q=k-2\).  C558 gives exactly
\[
 q=Q,\qquad q=\frac{Q(Q+1)}2,\qquad
 q=\frac{Q(Q+1)}2+1.
\]
The first alternative is \(k=q+2\).  In the second,
\[
 Q(Q+1)=2^{n+1}.
\]
Since \(Q\) is even and \(\gcd(Q,Q+1)=1\), the odd factor \(Q+1\) would have
to equal one, impossible for \(Q\ge4\).

In the third alternative, set \(x=2Q+1=2k-3\).  Then
\[
 x^2+7=8q=2^{n+3}.
\]
The Ramanujan--Nagell theorem says that the only positive solutions of
\(x^2+7=2^N\) have
\[
 (N,x)=(3,1),(4,3),(5,5),(7,11),(15,181).
\]
Here \(N=n+3\ge5\).  The remaining values give
\[
 (q,k)=(4,4),(16,7),(4096,92),
\]
and only the last has even \(k\ge6\).

For the Diophantine input, Banwait,
[*A Formal Proof of the Ramanujan--Nagell Theorem in Lean
4*](https://arxiv.org/abs/2604.09808), arXiv:2604.09808 (2026), was read at
`partial` depth: Introduction, the theorem statement, Sections 2.1--2.2, and
Section 2.8.  The cached arXiv PDF was fetched 2026-07-24, has 18 pages and
SHA-256
`a138007f55d02c3440e4697490ca43753d8b4750eb472c84e7992b24c5256508`.
It supplies both a conventional proof exposition and a machine-checked Lean 4
formalization of the complete solution list.

This is an exact equality classification, not the requested asymptotic gain.
Excluding zero defect supplies only the smallest positive local defect unless
a stability theorem amplifies it.  The robust mixed-block GDD / tangent-contact
problem therefore remains the load-bearing C593 gate; the arithmetic result
removes every even square-root-scale exact equality case except one finite
parameter pair.

## Prescribed-conic spectral gate: exact no-go

The proposed polarity--spectral amplification does not survive its first
structural test.  In characteristic two, the bilinear polar form of a conic
has the nucleus as radical, so the conic does not supply a nondegenerate
orthogonal polarity.  The surviving real operator is ordinary incidence
between the \(q+1\) conic points and all projective lines.

Let \(B\) be that \(0\)-\(1\) incidence matrix and let \(f\) be the indicator
of the tangent-line set \(\mathcal T_A\), viewed on primal lines.  Put
\(d=Bf\), so \(d_y=\tau_A(y)\) for \(y\in\mathcal C\).  Since two distinct
conic points determine one line,
\[
 BB^\mathsf T=qI+J.
\]
Thus the only singular values are \(\sqrt{2q+1}\) on constants and
\(\sqrt q\) on their orthogonal complement.

The apparent extra structure of \(f\) also collapses over the reals.  If
\(\mathcal S_A\) is the set of secant lines of \(A\), then the arc property
gives the exact lift of the binary hull identity
\[
 f=\sum_{a\in A}\mathbf 1_{a^*}-2\mathbf 1_{\mathcal S_A}.
\]
Applying \(B\) yields only
\[
 d=k\mathbf 1-2r,
\]
because each conic point and \(a\in A\) determine one line, while
\((B\mathbf 1_{\mathcal S_A})_y=r(y)\).

For even \(k=2m\), the conic part of the defect is consequently
\[
 D_{\mathcal C}
 =\sum_{y\in\mathcal C}r(y)(m-r(y))
 =\frac m2\mathbf 1^\mathsf T d-\frac14\lVert d\rVert^2.
\]
This is exactly C555's conic incidence quadratic form.  The centered spectral
estimate
\[
 \left\|d-\frac{\mathbf 1^\mathsf T d}{q+1}\mathbf 1\right\|^2
 \le q\,|\mathcal T_A|
 =qk(q+2-k)
\]
has an error of order \(q^{5/2}\) at \(k\asymp\sqrt q\), larger than the
order-\(q^2\) defect scale one would need to control.  Its induced lower bound
on \(D_{\mathcal C}\) is therefore vacuous.

Refining by the conic line orbits does not repair this.  Secant lines of
\(\mathcal C\) are chords on its \(q+1\) points and tangent lines are vertex
flags; C555 already proves that an arbitrary chord graph plus arbitrary
tangent flags is realizable before requiring all selected lines to arise from
one common arc.  Hence every spectral kernel using only conic--line incidence
remains below the established incidence-only ceiling.  The binary hull word
adds parity but no real spectral gap.

**NO-GO:** the prescribed-conic incidence spectrum supplies no new
rank-three term and does not open C556.

## Alternative attacks after the spectral no-go

1. **Four-base cross-ratio kernel (promoted).**  Normalize four arc points
   and encode mixed-block transversals by Möbius/cross-ratio maps between the
   corresponding tangent groups.  Search first for a forced rank or minor
   relation coming from the rule that every short block misses exactly two
   prescribed groups.  This is the smallest gate that genuinely couples the
   embedded GDD to rank-three realization.
2. **Approximate-design repair.**  Combine C554's bad-edge bound with a
   matching-design removal/stability theorem, then test whether a nearly
   resolved embedded design must approach a generalized hyperfocused arc.
   This is asymptotically relevant but risks ineffective constants and an
   abstract/geometric gap.
3. **Segre-polynomial stability.**  Ask whether near-extreme tangent
   multiplicities force repeated factors or derivative collapse in the Segre
   tangent polynomial.  The immediate risk is the envelope degree
   \(q+2-k\sim q\).
4. **The finite \((4096,92)\) exception.**  Exact rank-three exclusion would
   complete even equality, but cannot improve the asymptotic constant and is
   therefore deprioritized.

## Four-base cross-ratio gate: density is tautological

The promoted near-net test also closes negatively at its bounded gate.  Choose
four arc points and projectively normalize their four dual carrier lines to
\[
 X=0,\qquad Y=0,\qquad Z=0,\qquad X+Y+Z=0.
\]
Away from at most one chart-boundary point on each carrier, parameterize the
first two groups by
\[
 p_1(a)=(0:1:a),\qquad p_2(b)=(1:0:b).
\]
The line through them has equation
\[
 bX+aY+Z=0.
\]
Its intersections with the other two carriers have parameters
\[
 c=\frac ba,\qquad d=\frac{b+1}{a+1}.
\]
Thus the exact four-group condition is the pair of Möbius tests
\[
 \frac ba\in T_3,\qquad \frac{b+1}{a+1}\in T_4.
\]

This initially looks like an approximate embedded \(4\)-net.  It carries no
new density rigidity, however.  Every tangent group \(T_i\) has size
\[
 h=q+2-k
\]
inside a carrier line of size \(q+1\); its complement is exactly the \(k-1\)
secant directions from the corresponding arc point.  For either Möbius test,
fixing one input and a forbidden output determines at most one value of the
other input.  The union bound therefore gives at most
\[
 2h(k-1)
\]
failed pairs among the \(h^2\) pairs in \(T_1\times T_2\), already yielding
success density \(1-O(k/h)=1-O(1/k)\) at \(h\asymp q\), \(k\asymp\sqrt q\).

The zero-defect GDD count merely sharpens the same bookkeeping.  Put
\[
 e=\begin{cases}h,&k\text{ even},\\h-1,&k\text{ odd}.\end{cases}
\]
There are \(e\) short transversals for each missing pair and
\[
 F=h^2-\binom{k-2}{2}e
\]
full transversals.  The blocks containing all four selected groups number
\[
 F+\binom{k-4}{2}e
 =h^2-(2k-7)e.
\]
The exceptional \(O(kh)\) pairs are precisely the blocks whose missing pair
contains group three or four.  No cross-ratio concentration beyond the
co-small complements has appeared.

The Möbius formulas are still an exact coordinate reconstruction of the
embedded GDD, but extracting a new inequality from their exceptional sets
would require additional compatibility across many different choices of four
bases.  That is the original missing rank-three theorem, not a consequence of
near-net density.

**NO-GO:** a four-base robust-net theorem would return only the already-known
fact that each tangent group is close to its full carrier line.  It supplies
no quantitative defect amplification and does not open C556.

## `ej`+`tt` closeout

The closeout pass retained three genuine upgrades:

1. the tangent indicator is an explicit binary projective-plane code-hull
   word (or its complement is), not merely a generic few-weight codeword;
2. zero defect is exactly a collinearly embedded mixed-block GDD, and both
   certified ten-point matching designs possess generalized-hyperfocused
   resolutions;
3. Ramanujan--Nagell reduces even characteristic-two square-root equality to
   the single finite pair \((4096,92)\).

It also closes the standard amplification routes.  Generic few-intersection
classifications miss the parameters; ordinary incidence and Pless moments
repackage C554--C555; prescribed-conic spectral energy is exactly C555's
quadratic form; resolution does not distinguish realizability; and four-base
near-net density follows from the \(k-1\) missing secant directions on each
carrier.

The remaining mystery is precise rather than programmatic: one needs a
many-base rank-three compatibility theorem for the exceptional Möbius sets,
or a different mechanism altogether.  C593 found no bounded invariant meeting
that gate.  C556 therefore remains gated.

## Acceptance gate

1. Identify the closest primary-source classification theorems and verify
   their exact hypotheses; separate false friends such as maximal arcs or
   generic few-intersection sets that do not encode tangent contact.
2. Derive the full line-intersection distribution and associated projective
   code weight enumerator, marking every consequence already equivalent to
   C554--C558.
3. Test the first genuinely new feasibility constraints: the binary
   projective-plane code hull identity above, dual-code coefficients,
   polynomial/tangent-envelope identities, and any applicable
   characteristic-two classification.
4. **GO:** expose a carrier, forbidden spectrum, or quantitative positive
   defect on an infinite target family.  **NO-GO:** prove that the standard
   few-intersection and code-moment machinery is subordinate to the existing
   matching design, and name the exact missing geometric input.

## Evidence boundary

The four-intersection spectrum is an exact reformulation of the zero-defect
matching theorem, not itself a new obstruction.  No literature theorem or
code classification is load-bearing until its statement and parameter
hypotheses have been checked against this tangent-derived set.

## Mystery ledger

| Feature | Disposition |
|---|---|
| Does the four-intersection spectrum have a known classification at \(k\asymp\sqrt{2q}\)? | No applicable theorem was located in the bounded ten-source audit; this is not a full novelty closure. |
| Do ordinary incidence or Pless moments improve C558's arithmetic alternatives? | Likely no: the first two moments are the existing clique decomposition; higher code coefficients must be separated from automatic collinearity counts. |
| Does tangent contact impose more than the abstract spectrum? | Open; this is the likely source of any genuine carrier obstruction. |
| Can exact rigidity improve the asymptotic lower bound by itself? | No: a quantitative stability gap for the displayed weighted distance is required. |
| Does the binary hull identity hit a classified weight range? | Open: the relevant word has weight \(k(q+2-k)\asymp q^{3/2}\), so small-weight results may not reach it. |
| Must the regular focus family contain a generalized-hyperfocused resolution? | Open in general; both certified \(k=10\) classes pass the bounded existence test, so resolution alone does not detect rank-three realizability. |
| Can the mixed-block GDD be completed to a genuine embedded net? | No: the embedded-net pencil theorem would force the noncollinear arc bases to be collinear.  A new near-net stability theorem would be required. |
| Which even characteristic-two square-root parameters can attain exact zero defect? | Reduced arithmetically to the single pair \((q,k)=(4096,92)\); hyperoval-scale \(k=q+2\) remains separate. |
| Does that equality classification improve the asymptotic lower bound? | Not alone: one needs a defect-stability gap, not merely \(\Delta_{\mathcal C}(A)>0\). |
| Does prescribed-conic incidence have a useful spectral gap? | **Settled negatively:** \(BB^\mathsf T=qI+J\), the real tangent identity gives \(d=k\mathbf1-2r\), and the resulting quadratic form is exactly C555's incidence-only term with a vacuous error at the target scale. |
| Does four-base cross-ratio compatibility amplify the defect? | **Settled negatively at the density gate:** its \(1-O(1/k)\) success rate follows from each tangent group missing only \(k-1\) carrier points. |
| What genuinely remains? | A many-base rank-three theorem for the correlated exceptional Möbius sets, with no bounded invariant currently exposed; C556 stays gated. |
