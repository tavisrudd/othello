# Literature exposure check — extension-count form of the hexad characterization

**Date**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: COMPLETE for Q1 (the priority); Q2 partial, Q3 answered. Gaps listed under Limitations.

## Scope

Exposure check on **Form 2** of our hexad characterization:

> For a 6-subset `H` of a conic `C` in `PG(2,11)`, let `U(H)` = points of the plane off `H` and off
> all 15 chords of `H` (= points extending `H` to a 7-arc). Then `|U(H)| = 22` (the maximum) iff `H`
> is a hexad of one of the two `S(5,6,12)` systems on `P^1(F_11)`.

Histogram of `|U|` over all 924 six-subsets of the conic: `{18: 110, 19: 220, 20: 330, 22: 264}`.

Form 1 (concurrency, `t(H) = 60`) was swept previously and found ABSENT. Form 2 was never searched
and is a priori far more likely to be classical — extension counting is the arc-classification
school's standard method.

**Evidence tiers**: VERIFIED (opened it — URL + quote) / INFERRED (abstract or snippet only) /
NOT FOUND / NOT SEARCHED.

---

## VERDICT (Q1)

**The hexad characterization SURVIVES. Form 2 is not taken. No downgrade or retraction is
indicated, and C155 is clear to proceed.**

Direct answer to Q1: **NOT FOUND.** Nobody has characterized the `S(5,6,12)` hexads — or the
6-subsets of a conic — by an extension-count / uncovered-point / 7-arc-extension property. Nobody has
tabulated extension counts of 6-subsets of a conic in `PG(2,q)` for `q = 11` or in general, and
nobody has observed that the maximum picks out a design.

**But the exposure instinct was right, and the finding is not "the sweep was clear".** Form 2 is
*much* closer to the literature than Form 1 was. The invariant is not ours — it is a named, actively
studied quantity with an established notation that happens to be the same letter we chose. Three
findings drive the verdict:

1. **A very close near miss exists and must be cited: Bartoli–Davydov–Marcugini–Pambianco (§1).**
   They study *exactly* subsets of a conic in `PG(2,q)` by *exactly* our invariant, which they write
   `U(K)` — points of `PG(2,q) \ C` not covered by a bisecant. They print the `w = 5` case of our
   `t + |U|` identity. And for every `q ≤ 32`, **including `q = 11`, they enumerated the inequivalent
   6-subsets of the conic in MAGMA and computed coverage on them** — then published only `t(q)`, the
   smallest almost-complete subset size (`t(11) = 8`). Our histogram is one unprinted line of output
   from work they actually ran. They never mention Steiner, Mathieu, hexads, designs, or concurrency.
   **Their question is the `#U → 0` regime (how small can a fully-covering subset be); ours is
   extremal at fixed size (which 6-subsets maximize `#U`).** Different question, same machinery.
   Failing to cite them would be the real risk here — not priority, but the appearance of having
   missed the field our own invariant lives in.

2. **The classical side is not a threat, and there is a clean structural reason why (§3–§4).** Our
   Form 1 sharpens to: *`H` is a hexad iff none of the 15 main-diagonal triples (synthemes) of `H` is
   concurrent* — because any three chords concurrent off `H` must be pairwise disjoint. The classical
   literature knows both halves of this and cares about neither: the concurrency criterion for an
   inscribed hexagon's main diagonals is a known (if "lesser known") classical result, and
   Halbeisen–Hungerbühler state our exact count — 6 points on a conic give 15 lines meeting in
   **"in general, 45 intersection points"** — and then *choose coordinates so that all 45 are
   distinct*. Over `Q`/`R`/`C` the condition defining our hexads is **generic**, hence classically
   vacuous: an annoyance to sidestep, never a theorem. Over `F₁₁` the conic has only 12 points, there
   is nothing to choose, genericity fails for 660 of 924 six-subsets, and the 264 survivors are
   exactly the Mathieu hexads. **Our theorem cannot be stated in the classical setting.** That is a
   strong novelty argument and belongs in the write-up.

3. **The `S(5,6,12)`-on-a-conic crux holds (§7).** Independently re-checked, not inherited. Every
   geometric model of `S(5,6,12)`/`M₁₂` in the literature either stays on the projective *line*
   `P¹(F₁₁)` (Curtis/Conway "modulo 11" kitten — no plane, no chords, no extension points) or moves to
   characteristic 3 (Havlicek's `PG(2,3)` and `PG(5,3)`/Veronese models, Coxeter's cap, ternary
   Golay). **Caveat we must state ourselves:** the identification `conic in PG(2,11) ≅ P¹(F₁₁)` is
   standard textbook material and is *not* our contribution. Our contribution is the bridge — using
   the plane geometry that identification unlocks to characterize the hexads.

**Residual risk, stated plainly.** This is an absence-of-evidence verdict drawn from open-access
sources. Two specific items could still hold the result and were not readable: **Hirschfeld PGOFF
2nd ed. ch. 14** (small-`k` arc classification tables — the highest risk; if a printed table has a
`q = 11` 6-arc row with an extension column, it is there) and **Korchmáros–Storme–Szőnyi 1997**
(origin of "almost completeness"). Neither is likely to state a *design* connection — that leap is
absent from every neighbouring paper I did read — but ch. 14 could in principle contain the
histogram. I would close the ch. 14 gap before submission, not before writing.

**Recommended framing for C155.** Lead with Form 2 (it is the more natural invariant and the one the
field already cares about), cite BDMP as the home of the invariant and state plainly that our
identity is the `w = 6` refinement of their `w = 5` count with concurrency as the new ingredient,
cite Halbeisen–Hungerbühler for the classical 45 and make the genericity-fails-over-`F₁₁` point
explicitly, and cite COT-R as "follows from Thm 4" (see the accuracy caveat in §6).

---

## Search log

### 1. Bartoli–Davydov–Marcugini–Pambianco, "almost complete subsets of a conic" — **VERIFIED, NEAR MISS**

**The single closest item in the literature. Same object, same vocabulary, same notation — different question.**

- arXiv: https://arxiv.org/abs/1609.05657 (v3, 2017-12-27); published as *Problems of Information
  Transmission* **54** (2018) 101–115, https://link.springer.com/article/10.1134/S0032946018020011
- Authors: D. Bartoli, A. A. Davydov, S. Marcugini, F. Pambianco.
- Read in full (PDF → pdftotext, 39pp). Quotes below are verbatim from that text.

**They study subsets of a conic by coverage, with our notation.** Definitions (§1, p. 3–4):

> "An n-arc in PG(2, q) is a set of n points no three of which are collinear. A point P of PG(2, q)
> is **covered** by an arc K ⊂ PG(2, q) if P lies on a bisecant of K. Throughout the paper,
> C = {(1, t, t²) : t ∈ F_q} ∪ {(0,0,1)} is a fixed conic in PG(2, q)."

> "M_q := PG(2, q) \ C if q odd"

> "Definition 1.5. (i) In PG(2, q), an **almost complete subset of the conic C** (AC-subset, for
> short) is a proper subset of C covering all the points of M_q."

> "Let **U(K_w)** be the subset of points of M_q **not covered** by the subset K_w."

So their `U(·)` is literally our `U(H)` minus the six conic points of `C \ H` (conic points off `H`
lie on no chord of `H`, so `|U_ours(H)| = |U_BDMP(H)| + 6`). Our histogram `{18,19,20,22}` is their
`#U ∈ {12,13,14,16}`.

**They write our identity's `w = 5` analogue explicitly** (§4, after Thm 4.1):

> "It is easily seen that, for any q, there exists a 5-subset K_5 ⊂ C ⊂ PG(2, q) that does not cover
> #U(K_5) = #M_q − (10q − 25) ≤ U_5 = (q − 5)² points of M_q."

That is exactly our chord-pair count one step down: 10 chords × (q−1) points each, minus the
`C(10,2) − 5·C(4,2) = 45 − 30 = 15` chord-pairs meeting off the conic, giving `10q − 25` covered and
`q² − 10q + 25 = (q−5)²` uncovered — valid precisely when no three of the 10 chords concur off the
conic. **The `w = 6` case is the immediate next line of the same computation and they never write
it.** (Our `t + |U| = 82`: at `w = 6`, `15(q−1) − 45 = 105` covered for `q = 11` in general position,
`#U ∩ M = 121 − 105 = 16`, `|U| = 22`. Concurrency strictly *increases* coverage —
`covered = 105 + #{m=3} + 3·#{m=4} + …` — hence strictly decreases `|U|`, which is why the maximum
`|U| = 22` is exactly the no-concurrency case.)

**They enumerated our exact object — the orbits of 6-subsets of the conic — and did not look at the
histogram** (§5, on the Table 2 search):

> "The algorithm, used in the search, fixes a conic, **computes all the non-equivalent point subsets
> of the conic of a certain size (6 in our complete cases)** and extends each of them trying to obtain
> a minimal AC-subset."

So for every `q ≤ 32` — including `q = 11` — they had the inequivalent 6-subsets of a conic in hand
and ran coverage computations on them in MAGMA. They report only `t(q)`, the smallest AC-subset size.
**Table 2 gives `t(11) = 8`** (full row: `q=5→5, 7→6, 8→6, 9→6, 11→8, 13→8, 16→9, 17→10, 19→11,
23→12, 25→12, 27→13, 29→13, 31→14, 32→15`). Consistent with our data: our 6-subsets leave 12–16
points of `M_11` uncovered, all far from 0, so no 6-subset is AC at `q = 11` — you need 8.

**q = 11 is flagged as exceptional in their own bounds**, Theorem 5.1 (5.1):

> "t(q) < 1.525 √(q ln q),  8 ≤ q ≤ 887, q prime power, **q ≠ 11**;"

with `q = 11` pushed into the weaker `1.572` bound (5.3). They do not remark on why.

**What they do NOT do — grepped the full text:** no occurrence of *Steiner*, *Mathieu*, *hexad*,
*Witt*, *M12*, *orbit*, *stabilizer*, *PGL*, *PSL*, or *concurrent* anywhere in the paper. The only
hit for "design" is a book title in the bibliography. There is no histogram of `#U` by orbit, no
table of extension counts for a fixed subset size, and no design-theoretic remark of any kind.

**Assessment.** This is the strongest possible form of a near miss — the right school, the right
object, the right invariant, the right `q`, our notation, and the `w=5` version of our identity in
print — that nonetheless does not contain our theorem. Their question is asymptotic (*how small can
a fully-covering subset be?*, the `#U → 0` regime); ours is extremal-at-fixed-size (*which 6-subsets
maximize `#U`?*). Nothing here forces a downgrade, but this paper **must be cited** — it is the
natural home of the invariant and the closest prior art.

### 2. Upstream AC / normal-rational-curve references — **VERIFIED NOT FOUND**

Followed BDMP's own citation chain to the papers that own this invariant upstream. Both read in full
via pdftotext; grepped for `steiner|mathieu|hexad|witt|design|q=11|six|6-subset|concurren` — **zero
hits in either**:

- **L. Storme, "Completeness of Normal Rational Curves"**, J. Algebraic Combin. **1** (1992) 197–202.
  Free PDF: https://link.springer.com/content/pdf/10.1023/A:1022454221497.pdf (16 pp.)
- **S. Ball, J. De Beule, "On Subsets of the Normal Rational Curve"**, arXiv:1603.06714 (8 pp.)

Also identified but **NOT SEARCHED** (paywalled, not attempted): Korchmáros–Storme–Szőnyi,
"Space-Filling Subsets of a Normal Rational Curve", *J. Statist. Plan. Infer.* **58** (1997) 93–110 —
this is where BDMP say the term "almost completeness" was introduced ("[18, p. 94]"). It is the one
remaining upstream item that could plausibly hold a small-`q` table. Worth a library pull.

### 3. Hexagrammum mysticum / inscribed-hexagon diagonals — **VERIFIED; the classical condition
exists, but the classical question is the opposite one**

**A sharpening of Form 1 that makes the classical comparison exact.** Any three chords of `H`
concurrent *off* `H` must be pairwise disjoint: if two chords share a vertex `A` of `H` they already
meet at `A`, and a third chord through `A` would meet the conic in three points. So the concurrent
triples away from `H` are exactly the **perfect matchings** of `H` whose three chords concur — and a
perfect matching of 6 points is precisely the **main-diagonal triple `A₁A₄, A₂A₅, A₃A₆` of an
inscribed hexagon**. There are 15 matchings, so:

> `t(H) = 60 + c(H)`, where `c(H)` = number of the 15 inscribed-hexagon main-diagonal triples that
> are concurrent; and `|U(H)| = 22 − c(H)`.

This reproduces `t + |U| = 82` exactly, and the observed `c ∈ {4, 3, 2, 0}` matches the histogram
(`|U| = 18,19,20,22`) — including why `|U| = 21` never occurs (`c = 1` never happens).

**The classical criterion is known** (metric form, cyclic case). N. Anghel, "Concurrency and
Collinearity in Hexagons", *J. Geom. Graph.* **20** (2016) 159–171,
http://dynamicmathematicslearning.com/concurrency-collinearity-hexagons-anghel.pdf — opened, §1:

> "Let A₁A₂A₃A₄A₅A₆ be a cyclic hexagon. **A lesser known but nonetheless beautiful result** states
> that the three main diagonals A₁A₄, A₂A₅, and A₃A₆ are concurrent if and only if
> A₁A₂ · A₃A₄ · A₅A₆ = A₂A₃ · A₄A₅ · A₆A₁ [4]."

i.e. the classical `ace = bdf` condition on alternate sides. Its projective form is immediate for a
conic parametrized as `{(1, t, t²)}`: the chord through parameters `a, b` is the line
`[ab, −(a+b), 1]`, so the matching `(t₁t₄)(t₂t₅)(t₃t₆)` is concurrent iff

```
det [ t₁t₄  −(t₁+t₄)  1 ;  t₂t₅  −(t₂+t₅)  1 ;  t₃t₆  −(t₃+t₆)  1 ] = 0.
```

**Why this does not touch our result.** That determinant is a *single* polynomial condition —
codimension 1 in the six parameters. Over `R` or `C`, a generic 6-subset has `c = 0`, so "no matching
is concurrent" is the **generic** condition and is classically vacuous — nothing to characterize. The
content of our theorem is a purely finite-field phenomenon: over `F₁₁` the conic has only 12 points,
generic behaviour is *rare* (264 of 924, under 30%), and the 6-subsets achieving it are exactly the
Mathieu hexads. The classical school has no reason to state this and does not.

**Confirmed from the modern hexagrammum literature that the question there is the reverse one** —
they hunt for concurrences that hold *identically*, deliberately using generic parameters to filter
out accidents. N. Hungerbühler, M. Pirron, "Variations on Pascal's Hexagon Theorem", *Creat. Math.
Inform.* **34** (2025) 341–352,
https://math.ch/norbert.hungerbuehler/publications/Variations_on_Pascals_Hexagon_Theorem.pdf —
opened, §2.2:

> "Choose six different integers, e.g., (θ₁,…,θ₆) = (3, 7, 11, 17, 23, 29). … one can see if three of
> these lines, say f, g, h, are concurrent by checking if det(f, g, h) = 0. … The program returns
> (apart from the 12 points in P) exactly 19 new points where three of the 54 lines intersect. Of
> course, the incidences found in this way **can have come about by chance due to the special
> choice**."

Their 54 lines come from 12 points (a circumscribed hexagon `P₁…P₆` plus its contact points
`A₁…A₆`) and their 19 concurrency points are Pascal/Brianchon/Kirkman *identities*. Accidental
concurrences are exactly what they screen out; accidental concurrences are exactly our subject. Also
checked: this paper contains no *Steiner-system* content (the "Steiner" in it is Steiner points of
the mysticum, a different object).

Also opened: X. Ge / *Illumination of Pascal's Hexagrammum and Octagrammum Mysticum*,
arXiv:1209.4795 — pure characteristic-0 incidence geometry (Pascal lines, Steiner/Kirkman points,
Cayley–Salmon lines); no finite fields, no extension counts, no designs.

### 4. The classical "45 points" — **VERIFIED; the decisive framing**

The classical literature states our exact count and then explicitly *assumes it away*. L. Halbeisen,
N. Hungerbühler, "Twins of Conic Hexagons", *J. Geometry* **115** (2024), art. 31,
https://doi.org/10.1007/s00022-024-00731-8; free author PDF (opened, read):
https://people.math.ethz.ch/~halorenz/publications/pdf/Twin_Conics.pdf — §1:

> "distinct points P₁, P₂, …, P₆ on a non-degenerate conic C, called a **conic hexa-set**, define
> (6 choose 2) = 15 lines which in turn yield, **in general, 45 intersection points** different from
> the six given points."

Their 45 is exactly our 45 chord-pairs meeting off the conic (`C(15,2) − 6·C(5,2) = 105 − 60 = 45`),
and "in general" is exactly our `c(H) = 0` / `t(H) = 60` / `|U(H)| = 22` condition. And in §1 they say
how they handle the non-generic case:

> "We chose six different points P₁, P₂, …, P₆ with rational coordinates on a non-degenerate conic C
> **in such a way, that S consists of 45 different points**."

**This is the whole novelty story in one sentence.** Over `Q`/`R`/`C` the 45-distinct condition is
generic and can always be arranged by choosing coordinates, so it is an annoyance to be sidestepped,
never an object of study — which is why the vast classical hexagon literature has no theorem about
it. Over `F₁₁` the conic has only 12 points, so there is nothing to choose: the condition genuinely
fails for 660 of the 924 six-subsets, and the 264 where it holds are exactly the Mathieu hexads.
Our result is a statement that **cannot be formulated in the classical setting** — it is about the
failure of genericity on a finite conic. That is a strong structural argument for novelty, and it
should go in the write-up.

### 5. Witt design built from conics/quadrics — **VERIFIED; exists, but wrong characteristic and a
different mechanism**

There *is* a "W₁₂ from conics" literature, by Hans Havlicek. A referee could raise it, so it is worth
pre-empting; it is not our construction.

- **H. Havlicek, "A Model of the Witt Design W₁₂ based on Quadrics of PG(2,3)"**, arXiv:1304.0089 —
  opened, read. Abstract:
  > "The points of the design will be all points but one of the projective plane of order three, the
  > blocks are defined via quadratic equations. Some blocks are subsets of quadrics, others are sets
  > of points related with quadrics, e.g., the set of external points of a conic."
- **H. Havlicek, "The Veronese Surface in PG(5,3) and Witt's 5-(12,6,1) Design"**, arXiv:1210.2055 —
  opened. 12-point cap in `PG(5,3)`, blocks = hyperplane sections of size 6.
- Related: "Giuseppe Veronese and Ernst Witt — Neighbours in PG(5,3)", arXiv:1210.1926 (not opened).

**Why these are not us.** Both live in **characteristic 3**. In Havlicek's planar model the 12 points
are 12 of the 13 points of `PG(2,3)` — they are emphatically *not* the points of a conic (a conic in
`PG(2,3)` has only 4 points), and the conics enter as *block-defining* objects (external-point sets
etc.), not as the ambient point set. Grepped both for `PG(2,11)` / `GF(11)` / `q=11`: no hits. Our
construction — the 12 points **are** a conic, in `PG(2,11)`, and the blocks are cut out by a chord
incidence property — is a different object in a different characteristic.

### 6. Cameron–Omidi–Tayfeh-Rezaie orbit classification — **VERIFIED, with a citation-accuracy
caveat**

P. J. Cameron, G. R. Omidi, B. Tayfeh-Rezaie, "3-Designs from PGL(2,q)", *Electron. J. Combin.* **13**
(2006) #R50 — PDF opened and read in full.

**Caveat, flagged for the C155 write-up.** Theorem 4 is *not* a table of the `q = 11, k = 6` orbits.
It is a general formula giving **the number of orbits of `PGL(2,q)` on `k`-subsets of the projective
line, broken down by stabilizer type** (`id, A₄, S₄, A₅, C₂ (two classes), C_d, D₄, D_{2d}`), valid
for `k ≢ 0, 1 (mod p)`. Our four orbits with stabilizers `D₁₂, S₃, V₄, C₅` and sizes
`110, 220, 330, 264` **follow from** Theorem 4 specialized to `q = 11, k = 6`; they are not displayed
there. Cite it as "follows from [COT-R, Thm 4]", **not** as "tabulated in". (Sanity check on our own
numbers: `|PGL(2,11)| = 1320`, and `1320/264 = 5` ✓ `C₅`; `110+220+330+264 = 924` ✓.)

**And it makes no geometric contact whatsoever.** Grepped the full text for
`steiner|mathieu|hexad|witt|conic|arc|extension|cover` — **zero hits for every one of them**. It is a
pure group-theoretic orbit count. Nobody reading it would learn that the 264-orbit is the two Steiner
systems, let alone that it is the extension-count maximum. So the one published fact adjacent to our
theorem (the orbit decomposition) carries none of its content.

### 7. Geometric models of S(5,6,12) / M₁₂ in the literature — **VERIFIED; the prior sweep's crux
claim holds**

The task asked me to confirm or refute, from my own reading, that the standard sources use the
`P¹(F₁₁)` point set but never embed it as a conic. **Confirmed.** The geometric models of
`S(5,6,12)` / `M₁₂` that actually appear in the literature are:

1. **`P¹(F₁₁)` with `PSL(2,11)`** — blocks = the orbit of a base hexad under linear fractional maps.
   This is the Curtis/Conway "kitten" with the **"modulo 11" labelling**. Confirmed via the SageMath
   `sage.games.hexad` documentation (https://doc.sagemath.org/html/en/reference/games/sage/games/hexad.html),
   which implements exactly this and describes the labelling as "either the 'modulo 11' labeling or
   the 'shuffle' labeling". **This is the projective *line*** — a 1-dimensional object with no chords,
   no plane, and no extension points. There is no ambient `PG(2,11)`.
2. **12-point cap in `PG(5,3)`** (Coxeter's configuration; blocks = hyperplane sections of size 6),
   and the Veronese-surface model — Havlicek arXiv:1210.2055, and P. J. Cameron, *Projective and Polar
   Spaces*, ch. 9 "The geometry of the Mathieu groups",
   https://webspace.maths.qmul.ac.uk/p.j.cameron/pps/pps9.pdf — opened; it gives `M₁₂` as the
   stabiliser of a dodecad in `M₂₄`, via the ternary Golay code, and as "a set of 12 points in
   PG(5,3) on which M₁₂ [acts]". **No conic, no `PG(2,11)`** (grepped: no hits for `conic`, `PG(2,11)`,
   `PG(1,11)`).
3. **`PG(2,3)`-based** — Havlicek arXiv:1304.0089, §5 above (characteristic 3).
4. **Ternary Golay code** — hexads = weight-6 codewords' supports.

**Not found in any of them: the 12 points realized as a conic in `PG(2,11)`, with the plane's chord
geometry used to characterize the blocks.** Every model either stays on the line (model 1) or moves
to characteristic 3 (models 2–3).

**An important check on what is and isn't ours.** The *identification* `conic in PG(2,11)`
`≅ P¹(F₁₁)`, with `PGL(2,11)` as the conic's stabiliser in `PGL(3,11)`, is completely standard
textbook material (the conic is a rational normal curve; Hirschfeld PGOFF ch. 8). We must not claim
that as new. Adjacent published work using precisely that setup: **A. Hanaki, et al. / "Association
schemes from the action of PGL(2,q) fixing a nonsingular conic in PG(2,q)"**, arXiv:math/0503573
(found, **INFERRED** from search snippet only, not opened) — it studies the `PGL(2,q)`-action on
points *off* the conic (internal/external, hyperbolic and elliptic schemes), i.e. 2-point orbits, not
6-subsets, and not extension counts. **What is ours is the bridge**: using the plane geometry that the
identification makes available (chords, concurrency, extension points) to characterize the hexads
combinatorially. Nobody has crossed that bridge.

### 8. Other items checked — **VERIFIED NOT RELEVANT**

- **A. Staicu, "Counting 7-Arcs in Projective Planes over Finite Fields"**, arXiv:2311.16578 — opened.
  Despite the promising title, this counts Frobenius-invariant `n`-arcs via arithmetic-geometry /
  quasipolynomial methods (in the Glynn / Bergvall / Das / O'Connor line), for characteristic 2. It
  counts arcs *in aggregate*; it never counts extensions of a *given* subset. Grepped:
  no `steiner|mathieu|hexad|witt|S(5,6,12)|q=11|conic`.
- **"Arcs, Caps and Generalisations in a Finite Projective Space"** (2025 survey), arXiv:2503.06243 —
  opened and grepped. Standard Segre-school survey (ovals, Segre's theorem, completeness). No
  extension-count tables for subsets of a conic, no design connection.

---

## Q2 — the `t + |U| = 82` identity: **PARTIAL — the *type* of relation is in print; ours is not**

The closest thing in the literature is **BDMP's `w = 5` line** (§1 above):

> "It is easily seen that, for any q, there exists a 5-subset K₅ ⊂ C ⊂ PG(2, q) that does not cover
> #U(K₅) = #M_q − (10q − 25) ≤ U₅ = (q − 5)² points of M_q."

So a chord-count ↔ uncovered-count relation for subsets of a conic **is** known and used, one size
below ours, by exactly the group whose vocabulary we share. What is *not* in print is (a) the `w = 6`
instance, and (b) the reading of the correction term as a **concurrency count** — BDMP never mention
concurrency at all (grepped: zero hits for `concurren`). Our identity in the sharp form

> `t(H) + |U(H)| = 82`, equivalently `t(H) = 60 + c(H)` and `|U(H)| = 22 − c(H)` with `c(H)` = the
> number of concurrent main-diagonal triples (synthemes) of `H`

is **NOT FOUND**. It should be presented as the natural `w = 6` refinement of BDMP's count, with the
concurrency reading as the new ingredient — which is also the correct and generous way to cite them.

## Q3 — the `{18:110, 19:220, 20:330, 22:264}` histogram: **NOT FOUND**

Not published anywhere I can find, and I checked the two places it would most plausibly sit:

- **BDMP (§1)** had the inequivalent 6-subsets of the conic in MAGMA for every `q ≤ 32` — including
  `q = 11` — and ran coverage computations on them. They report only `t(q)`. **The histogram is one
  line of output away from work they actually ran, and they did not print it.** This is the single
  most likely source of a future "this was known" challenge, and the strongest reason to cite them
  prominently and frame our contribution precisely.
- **COT-R (§6)** had the four orbits with the right stabilizers, and no geometry at all.

So both halves of the table exist in print, in different papers, in different languages, and nobody
has joined them. **NOT FOUND**, with the caveat that this is an absence-of-evidence verdict over
open-access sources; see Limitations.

---

## Limitations — what I could NOT check

- **Hirschfeld, *Projective Geometries over Finite Fields*, 2nd ed., ch. 8 and ch. 14** — **NOT
  SEARCHED** (in-copyright; per the task, already established as inaccessible today; I found no new
  route in). Ch. 14's classification of small `k`-arcs in `PG(2,q)` for small `q` is the highest
  residual risk in this entire sweep: if any printed table lists 6-arcs on a conic at `q = 11` with
  an extension-count column, it is there. **This is the one gap I would close before publishing.**
- **Sadeh's Sussex thesis** — **NOT SEARCHED** (not online, per task).
- **Korchmáros–Storme–Szőnyi, "Space-Filling Subsets of a Normal Rational Curve"**, *J. Statist. Plan.
  Infer.* **58** (1997) 93–110 — **NOT SEARCHED** (paywalled; not attempted). Origin of the
  "almost completeness" term. Second-highest residual risk.
- **Salmon, *Conic Sections*; Baker; Coxeter; Dolgachev *Classical Algebraic Geometry*** — **NOT
  SEARCHED** directly. Mitigated by §4: the classical `45-points` fact is well attested in the modern
  literature descending from these, and it is a *genericity* statement, which is structurally
  incapable of containing our finite-field theorem.
- **Conway–Ryba's hexagrammum paper** — **NOT SEARCHED** directly; covered indirectly by §3–§4, which
  establish that the whole mysticum school studies *identical* incidences, not accidental ones.
