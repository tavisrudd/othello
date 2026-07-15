# Gem mining, next steps — audit of the E_q plan + the census-gap machine (Fable, 2026-07-14)

**Lane**: `clebsch` — see CLAUDE.md § Lane routing. (Strategy note; findings 4, 5, 7, 10.1 bear
directly on the paper. No C-IDs allocated here; every proposal below needs an ID + user approval
before it becomes work.)

Response to Opus's E_q / census-gap proposal (parts A–E) and the user's two questions (next steps on
the mining ideas; how to hunt new objects/properties via hypothesized census gaps). Parts are
numbered for reference. Computed facts cite the script that produced them; everything else is marked
reasoned or speculative.

Scripts (session scratchpad — **promote to durable verifiers before relying on this note**, they are
not in git):

| script            | sha256 (prefix)   | what it does                                                        |
|-------------------|-------------------|---------------------------------------------------------------------|
| `gem_sweep.py`    | `b9886e3ecd3051…` | E_q build, pencil/degree checks, SRG tests, exhaustive arc-clique + healthy census, ω_arc B&B |
| `mathieu_poles.py`| `7a86488679420…` | S(5,6,12) on the conic of PG(2,11), chord-concurrence spectrum      |

Terminology used throughout: fix the conic C: XZ=Y² in PG(2,q), q odd. Off-conic points are
*external* (on 2 tangents) or *internal* (on 0). **E_q** = graph on the q² off-conic points, two
points adjacent iff their joining line is external to C (misses C). An **arc-clique** = a clique in
E_q with no 3 points collinear. A **healthy arc** = an arc-clique whose secants cover every
off-conic point outside it — equivalently, an arc whose deep-hole locus U is *exactly* the full
point set of a conic. The Clebsch hexagon is the healthy arc at q=11.

## 1. Headline judgments

1. **Opus's E_q reduction (A) is correct and I ran it.** The sweep Opus proposed as future work
   (steps B and C) took minutes, not a project: the arc+clique conditions collapse the search tree.
   Exhaustive for all primes q ≤ 37: **healthy arcs exist exactly at q ∈ {3, 5, 11}**.
2. **Step B is closed**: at q=11 the Clebsch hexagon is the unique arc of *any* size whose deep-hole
   locus is the full point set of a conic (degenerate conics impossible for every arc, two-line
   proof). This upgrades the paper's rigidity theorem from "among 6-arcs" to "among all arcs at
   q=11" — computed + short lemmas, essentially free.
3. **Two of Opus's supporting claims are wrong**: E_q is not strongly regular (computed: biregular,
   and the restricted graphs are regular but not SRG), the Hoffman route is dead a priori (every
   external line is a (q+1)-clique), and — the big one — **the ω_arc/n_min crossing story is
   refuted by computation**: ω_arc ≥ n_min at q = 13, 23, 29, 31, 37, yet no healthy arc exists at
   any of them. Nonexistence for q ≥ 13 is a census fact still lacking a structural cause.
4. **The E_q object is classical**: it is the *exterior-set* geometry of a conic. Edge (1956)
   already has the q=11 hexagon with all 15 joins skew to the conic and the 10 Brianchon points —
   he even names Clebsch — and Blokhuis–Seress–Wilbrink (1991) use the same 6-point set as one of
   two known extremal examples, with an open 1991 conjecture attached. **The manuscript cites
   neither** (checked). Fixing this is the single most urgent item in this note.
5. **The census-gap machine works, demonstrated live**: one cross-categorical experiment run cold
   this session (conic polarity × Mathieu hexads) produced a clean candidate theorem — *a 6-subset
   of the conic in PG(2,11) is a hexad of S(5,6,12) iff no three of its chords are concurrent
   outside it* — with a gap in its spectrum. Needs a literature check before any claim.
6. **Ranking for a second gem**: (i) hexad/octad polarity program, (ii) ω_arc growth census
   (= a strengthening of the open BSW conjecture), (iii) the k=4 twisted-cubic healthy search — all
   above a further q-sweep hardening, which is now cheap enough to just finish as a by-product.

## 2. Computed results (the data everything below stands on)

`python3 gem_sweep.py 3 5 7 11 13 17 19 23 29 31 37 --collect6` (collect6 on 11–19), exhaustive
DFS over arc-cliques containing a fixed representative of each point type (Stab(C) = PGL₂(q) is
transitive on internals and on externals, so every class is met). All rows complete, no node limit
hit.

| q  | n_min | ceiling ext/int | ω_arc | healthy classes (up to Stab(C))                    |
|----|-------|-----------------|-------|-----------------------------------------------------|
| 3  | 3     | 2 / 3           | 3     | 1 — n=3, all-internal, stab 24 (all of PGL₂(3))     |
| 5  | 4     | 3 / 4           | 4     | 1 — n=4, all-internal, stab 24 = S₄ (the frame)     |
| 7  | 5     | 4 / 5           | 4     | none                                                |
| 11 | 6     | 6 / 7           | 6     | 1 — n=6, all-external, stab 60 = A₅ (**Clebsch**)   |
| 13 | 6     | 7 / 8           | 6     | none                                                |
| 17 | 7     | 9 / 10          | 6     | none                                                |
| 19 | 7     | 10 / 11         | 6     | none                                                |
| 23 | 8     | 12 / 13         | 8     | none                                                |
| 29 | 9     | 15 / 16         | 10    | none                                                |
| 31 | 9     | 16 / 17         | 10    | none                                                |
| 37 | 10    | 19 / 20         | 10    | none                                                |

Here n_min = least n with n(n−1)(q−1)/2 ≥ q²−n (covering capacity); the ceilings are the pencil
bounds of §3.3. Supporting detail:

- **q=11**: there is exactly **one** size-6 arc-clique class *at all* — all-external, stabilizer 60,
  and it covers exactly. The covering condition is not even needed to isolate Clebsch among 6-point
  configurations; "6 off-conic points, no 3 collinear, all 15 joins external" already forces it.
- **q=13**: two size-6 classes (stabs 6 and 12), both leave 24 off-conic points uncovered (|U|=38).
- **q=19**: 94 size-6 classes; the minimum-uncovered one is **all-internal with stabilizer 60** and
  |U| = 20+120 = **140** — the icosahedral arc, independently reproducing the handoff's
  `check_q19_nonexample.py` value. (Note the type flip: arc points external at q=11, internal at
  q=19 — 5 | q−1 vs 5 | q+1.)
- Pencil counts and E_q degrees verified against the formulas at every q (internal: (q+1)/2
  external lines through it; external: (q−1)/2; degrees q(q+1)/2 / q(q−1)/2).
- SRG tests (`--srg`, q=11,13): E_q biregular, hence not SRG. Internal and external restricted
  graphs under external-line adjacency: **regular but NOT strongly regular** (λ, μ non-constant).
  The only SRG in the family is external-points/tangent-adjacency, which is the triangular graph
  T(q+1) in disguise (external point = unordered pair of conic points; tangent-join = pairs sharing
  a point) — nothing new.

The two positives at small q, decoded:

- **q=5 (new to the repo's tables): the deep holes of the projective frame are a conic.** All
  4-arcs in PG(2,q) are projectively equivalent (a frame), so this is a fact about PG(2,5) itself:
  the 6 points off the frame's 6 sides and off the frame form a nondegenerate conic; stabilizer S₄
  (the full frame stabilizer) sits inside the conic's PGL₂(5). Coding reading: the deep holes of
  the [4,1,4]₅ code are the conic — a k=1 baby sibling of the Clebsch [6,3,4]₁₁. All-internal,
  with each point's external-line pencil saturated (3 = n−1). The C126 family-tree row "octahedron
  p=5: arc too small" tested the wrong orbit; the group-free census finds what the S₄-ansatz
  missed.
- **q=3**: the triangle of the 3 internal points, invariant under the whole conic stabilizer;
  degenerate as a code (n−3 = 0). Boundary case, listed for completeness.

## 3. Audit of Opus part A (the reduction) — correct, with three repairs

3.1 **The unfolding is right.** U(A) ⊇ C ⟺ A∩C = ∅ *and* every secant external (the A∩C=∅ clause
is implicit in Opus's phrasing; it matters — an arc through a conic point can never have U = C).
U(A) ⊆ C ⟺ secants cover all off-conic points off A. Fixing C loses nothing (all nondegenerate
conics are PGL₃-equivalent, and U(A) = C pins C from A, so PGL₃-classes of healthy arcs =
Stab(C)-classes of arc-cliques-that-cover). The signature "arc + clique in E_q + covering" is
exactly right, group-free and complete. This genuinely answers C132's residual caveat: the sweep's
negatives are exhaustive per q, with no "does not exhaust every P¹ route" asterisk.

3.2 **Arc points are NOT forced external** — Opus's a-priori doubt was correct, and the data
settles it: the q=3, q=5 healthy arcs are all-internal, the q=19 icosahedral arc-clique is
all-internal, and mixed-type classes dominate the q ≥ 17 censuses. Any search keyed to external
points only (as the BSW literature is, §7) would have missed them.

3.3 **The pencil bound is the missing structural lemma, and it is linear, not √q.** All secants
external means the n−1 secants through an arc point all lie in that point's external-line pencil:
n−1 ≤ (q+1)/2 for an internal point, (q−1)/2 for an external one. So ω_arc ≤ (q+3)/2 always, and
≤ (q+1)/2 the moment one point is external. At q=11 this alone kills n ≥ 8, and forces a
hypothetical 7-point arc-clique to be all-internal with every pencil saturated. The Clebsch hexagon
saturates the *external* bound (6 = (q+1)/2); the q=3, 5 arcs saturate the *internal* bound
((q+3)/2). Two different extremal mechanisms, both realized.

3.4 **The torus-involution clique**: yes, the poles of the q+1 involutions inverting a nonsplit
torus are collinear — they are points of the invariant external line (the join of the torus's
conjugate fixed pair), and *any* external line is trivially a (q+1)-clique of E_q (the joining line
of two of its points is the line itself). Opus's example is correct but is just "an external line"
in disguise; the general fact is stronger and simpler. Consequence: ω(E_q) ≥ q+1, so no spectral
clique bound can ever see ω_arc. Reasoned, not computed; the collinearity claim follows from the
dihedral normalizer preserving the axis.

3.5 **n_min values**: n_min(11) = 6 ✓; n_min(19) = 7 (Opus's "≈6.2" is the asymptotic √(2q); the
exact threshold matters and is 7 — his conclusion stands). q=19 |U| = 140 reading ✓ (reproduced
independently, §2).

## 4. Step B — closed. The all-n rigidity upgrade at q=11

Statement now provable: **in PG(2,11), the Clebsch hexagon is the unique arc, of any size, whose
deep-hole locus is the full F₁₁-point set of a conic, degenerate conics included.** Proof structure:

1. *Degenerate targets are impossible for every arc and every q* (new, two lines): U ⊇ ℓ for a
   full line ℓ forces A ∩ ℓ = ∅ (a point of ℓ in A is not in U, breaking U ⊇ ℓ); but any secant
   of A meets ℓ somewhere (two lines always meet in PG(2,q)), necessarily at a non-arc point,
   which is then on a secant and so not in U — contradiction. Arcs of size ≥ 2 have a secant. So
   U never contains a full line; line-pairs and double lines are out.
2. *Nondegenerate target* ⟹ all secants external ⟹ A is an arc-clique of E₁₁.
3. n ≤ 5: covering capacity fails (n(n−1)·10/2 < 121−n). n = 6: the census (§2) has exactly one
   class, the Clebsch hexagon, and it covers. n ≥ 7: **ω_arc(E₁₁) = 6** (computed, exhaustive) —
   no 7-point arc-clique exists at all; n ≥ 8 also killed on paper by the pencil bound (3.3).

This upgrades the paper's headline theorem for the cost of one lemma and one already-run
computation. The manuscript's rigidity census (1548 6-arcs) stays as-is; this adds the n ≥ 7
exclusion it currently lacks. Recommend folding into §4 of the .tex (with a durable checker — see
§12) rather than a separate note.

## 5. Step C — ran it. The healthy census and what it changes

The sweep Opus scoped as the next project is the table in §2. Consequences:

- **§6 of the paper ("why the tested generalizations fail") upgrades from heuristic to census**:
  for all prime q ≤ 37, deep holes of an arc fill a conic only at q ∈ {3, 5, 11}, and the q ≤ 14
  counting bound for n=6 is replaced by an unconditional exhaustive statement below 37. Scope,
  stated plainly: primes only (the script is GF(p); q = 9, 25, 27 need a field extension pass —
  q=9 matters, it is SVM's Brianchon-on-conic case).
- **The "family" now has three members, not one**, with a clean shape: q=3 (degenerate), q=5 (the
  frame, S₄, k=1), q=11 (Clebsch, A₅, k=3), and nothing after — conjecturally ever. "Why 11"
  becomes "why does the sequence stop": at q=5 and 11 the extremal exterior-arc *is* rigid-and-
  covering; from 13 on, arc-cliques of covering-capable size exist (§6) but never cover.
- The q=5 frame fact is a free standalone paragraph for the paper (or a Monthly-style remark): it
  is the unique-smaller sibling and sharpens the "singular at 11" story rather than diluting it —
  the k=3 (plane MDS code) instance is still unique; q=5 lives at k=1.

## 6. Step D — the crossing mechanism is refuted; what "why 11" still lacks

Opus's step D predicted: ω_arc(E_q) stays below n_min(q) ≈ √(2q) after 11, making 11 "the last q
where ω_arc clears n_min," provable by a spectral bound. Computation says otherwise:

- ω_arc = n_min exactly at q = 13, 23, 37; ω_arc > n_min at q = 29, 31. Healthy arcs still do not
  exist at any of these (exhaustive). So **capacity + clique size do not explain nonexistence**;
  the covering fails for finer reasons at every single candidate, and "why 11" remains a census
  fact without a structural cause. The plain state: the uniqueness conjecture is well-supported
  and unexplained.
- The spectral half was dead independently: ω(E_q) ≥ q+1 (external lines, 3.4), E_q is not SRG
  (computed), so no Hoffman/ratio bound applies to anything relevant. The arc condition is the
  whole content, and spectral methods cannot see it.
- What survives of D: **ω_arc(E_q) as a census invariant is genuinely new data** (3, 4, 4, 6, 6,
  6, 6, 8, 10, 10, 10 for the primes 3…37) — a slow, irregular growth curve sitting well below
  both pencil bounds, with jumps at 23 and 29. No obvious closed form. This connects to an open
  conjecture (§7), which is where its value lives now.

## 7. Literature (Opus's question 2) — yes, the object is classical, and it changes the paper

Three findings, in decreasing order of certainty:

1. **Exterior sets.** A set of points whose pairwise joins are all external to C is an *exterior
   set* of the conic. **Blokhuis–Seress–Wilbrink**, "On sets of points without tangents," *Mitt.
   Math. Sem. Giessen* 201 (1991) 39–44 — the same Giessen series as Hirschfeld–Sadeh — take the
   conic plus (q+1)/2 exterior points, no 3 collinear, as a set without tangents; **q=7 and q=11
   are their only examples** (q=7: the quadrangle; q=11: the Clebsch hexagon, as an exterior set).
   Their computer search shows no such set for 11 < q ≤ 31 and they **conjecture none exists for
   q > 31** — open since 1991. Follow-ups: Blokhuis–Seress–Wilbrink, "Characterization of complete
   exterior sets of conics," *Combinatorica* 12 (1992) 143–147; M. De Boeck, "On sets without
   tangents and exterior sets of a conic," arXiv:1201.0484; a 2025 arXiv line on "untouchable
   sets" (2505.08551) shows the area is active. Consequences: (a) the *object* "6-arc with all
   joins external at q=11" is prior art and must be cited; (b) the BSW question is exactly
   "does ω_arc-restricted-to-external-points reach (q+1)/2" — our census is the finer invariant
   and **already verifies the BSW bound at q=37 in the stronger mixed-type form**, one prime past
   their 31; (c) the covering/deep-hole overlay — the entire coding reading, rigidity TFAE, gap,
   chirality — appears nowhere in this literature. Sources:
   [arXiv:1201.0484](https://arxiv.org/abs/1201.0484),
   [Combinatorica](https://link.springer.com/article/10.1007/BF01204717),
   [arXiv:2505.08551](https://www.arxiv.org/pdf/2505.08551).
2. **Edge 1956 is the true nearest prior art, 35 years before Dye.** W. L. Edge, "Conics and
   orthogonal projectivities in a finite plane," *Canad. J. Math.* 8 (1956) — fetched and read in
   part this session
   ([PDF](https://webhomes.maths.ed.ac.uk/~icheltso/edge2016/pdf/1956a.pdf)): at p=11 he describes
   "the distribution of the points external to χ in sets of 6, the 15 joins of points of such a set
   being all skew to χ and concurrent in threes at 10 different points all internal to χ," develops
   the syntheme/synthematic-total (S₆) structure, and writes "we may say, **with Clebsch**, that
   the points of χ form a hexagon endowed 10 times over with the Brianchon property."
   **The manuscript cites neither Edge nor BSW** (grepped). The priority footnote currently argued
   against Dye 1991 must be re-based on Edge 1956; his §§18–32 (detailed p = 5, 7, 11 geometry)
   must be read in full before locking wording — the risk that Edge states the covering fact
   ("every other external point lies on a join") somewhere in there is real, though nothing in the
   passages read says it. Note also his phrase "sets of 6" (plural): he appears to partition the
   66 external points into hexagons — the 22 copies of the hexagon over a fixed conic organize as
   2 × 11.
3. **The involution lens** (flagged speculative, from memory): off-conic points = involutions in
   PGL₂(q); external join = elliptic product = the two involutions differ by a derangement of
   P¹(F_q). So arc-cliques are cliques in the derangement graph of PGL₂(q) restricted to the
   involution class, with the arc condition on top — adjacent to the sharply-transitive-sets /
   Erdős–Ko–Rado-for-PGL₂ literature (Meagher–Spiga school). Representation-theoretic clique
   machinery lives there if anyone attacks ω_arc structurally. Not verified this session.

Also from the search trail: the (15,3)-arc of PG(2,7) literature already uses "complete quadrangle
whose lines are all external to a conic" — the q=7, size-4 exterior set — as a building block
([MDPI](https://www.mdpi.com/2227-7390/9/5/486)). Consistent with ω_arc(E₇) = 4.

## 8. Strategy verdicts (Opus's question 3)

- **"Is the q-sweep a caveated negative one order more expensive than C132?" — No, and the premise
  dissolved.** It cost minutes, its negatives are exhaustive-per-q (theorem-grade, unlike C132's
  curated non-exhaustive negative), and it returned positives: the q=5 instance, the ω_arc census,
  the q=11 all-n closure. The generator critique was right about the fill-miner; it does not carry
  over to census generators. Sunk-cost direction: finish it (prime powers, Rust for q > 37), but as
  a by-product, not the flagship.
- **Phone-call ranking** (what I would spend compute on for a *second gem*, in order):
  1. **The hexad/no-Brianchon characterization (§10.1)** — already in hand, one lit-check from
     being claimable, and squarely in the repo's S₆/syntheme/chirality wheelhouse.
  2. **The k=4 twisted-cubic healthy search (§10.3)** — the repo's own analysis says the family
     runs through k, not p; this is the one direction where a hit is a *new kind* of object, not a
     sibling.
  3. **ω_arc growth + BSW strengthening (§10.2)** — piggybacks on an open 1991 conjecture;
     even the negative rows are publishable data in that conversation.
  4. The remaining q-sweep hardening (prime powers, q ≤ 100) — referee-grade support for the
     paper, not a gem hunt.
- **What I would NOT do**: re-key the fill-signature miner (retire it — §9 explains why it can't
  be fixed); a Dickson-subgroup group-caused sweep as a separate project (the group-free census
  subsumes it up to 37, and rigidity shows groups are outputs, not inputs — only worth reviving if
  chasing q in the hundreds where exhaustion dies).

## 9. The machine (Opus's question 4): census × cross-category invariant × declared null × upgrade

Opus's three rules are right. Sharpened into an operating procedure with the discipline points that
actually decided this session's outcomes:

1. **Generator = a complete census, never a list.** The domain must come with an exhaustion
   guarantee (enumerable by machine at each parameter, or classified in the literature: arcs of
   small planes, Dickson's PGL₂(q) subgroups, Mitchell–Hartley for PGL₃, hyperovals q ≤ 32/64,
   2-transitive groups, SRG feasibility tables). A hit over a census upgrades itself: uniqueness,
   gaps, and "for all members" statements come for free. A hit over a curated list is a coincidence
   with an asterisk, and a miss is worthless. That asymmetry — what a MISS buys — is the test to
   apply before building any detector.
2. **Invariant = valued in another classified category.** Compute, per census member, something
   whose value can *land on a name*: deep-hole locus → curve type; residual/Schreier graph → named
   graph; stabilizer → named group; concurrence defect → design membership. Cross-category is what
   made every hit here (coding → conic; involutions → icosahedron; polarity → Mathieu). Same-
   category size-equalities (the fill-miner) are numerology by construction.
3. **Declare the null before looking.** State what a typical member scores: the forced/baseline
   count (60 = 6·C(5,3) in §10.1), the capacity bound (n_min), a first-moment estimate, or a
   random-member simulation. A *hypothesized gap* is exactly "the bulk sits at ≥ X for combinatorial
   reasons; anything at X or below is caused." This converts noticing into predicting, and it is
   what separates a gap theorem from an after-the-fact coincidence.
4. **Upgrade protocol on any hit, immediately**: (i) stabilizer (group cause), (ii) distance to
   second-best (gap statement), (iii) perturbation instability, (iv) the same invariant at the
   neighboring parameter (q±, k±, n±). The Clebsch paper is precisely coincidence + these four.

Why the fill-miner fails this standard on all four counts: curated list (no exhaustion, so C132's
negative had to carry a caveat), same-category invariant (|config| = |space|), no null (hand-tuned
interest score), no upgrade path (a size-equality has no spectrum to be extremal in). C132's re-key
prescription fixed the invariant's *side* (deep-hole) but not the generator; Opus's E_q move fixed
the generator. Retire the table (keep it as the record of a closed spike); the corrected search
prescription in the C132 note should point at census sweeps, not at a re-keyed famous-objects scan.

The transverse-loci miner (7023c5d) already passes rules 1–3 (its domain is a residue-classified
catalogue, its invariant is dimension/density, its negative is declared informative) — it was
always the better-shaped tool. Its POC script must be rebuilt as a repo file; only the result
paragraph survived.

## 10. Fully-specified proposals (each: census, invariant, hypothesized gap, what each outcome buys)

10.1 **Polarity-defect characterization of Mathieu hexads — RUN, HIT, needs lit-check.**
Census: all C(12,6) = 924 6-subsets of the conic's 12 points in PG(2,11) (complete by
construction). Invariant: t(H) = number of collinear triples among the 15 poles of H's chords
(= concurrent chord triples, by polarity). Null (declared before running): every point of H forces
C(5,3) = 10 concurrent triples at itself, so t ≥ 60, with equality iff *no three chords meet
outside H*. Computed (`mathieu_poles.py`; S(5,6,12) realized as the PSL₂(11)-orbit of {0,1,3,4,5,9},
Steiner property verified): spectrum **{60: 264, 62: 330, 63: 220, 64: 110}** — value 61 never
occurs (gap), and **the t = 60 stratum is exactly the union of the two S(5,6,12) systems on
P¹(F₁₁)** (both verified Steiner, disjoint, swapped by PGL₂(11)∖PSL₂(11) — a chirality echo).
Statement: *a hexad is a 6-subset of the conic no three of whose chords are concurrent off it; every
non-hexad has at least two accidental concurrences.* Outcomes: if absent from the literature (check
Edge 1956/his LF(2,11) papers, Todd, Curtis's kitten, Conway–Sloane ch. 10–11), this is a new
synthetic characterization of S(5,6,12) via conic polarity — phone-call-adjacent, decide-grade
Lean-able, and it makes Edge's Brianchon machinery and the repo's M₁₂/F3 thread one object. If
known, it cost one script and still feeds §10.1's extension: **octads**: same invariant for the
C(24,8) 8-subsets of the conic in PG(2,23) vs the 759 octads of S(5,8,24) (null: t ≥ 8·C(7,3) =
280; M₂₄ does not sit in PGL₂(23) the same way — PSL₂(23) is a maximal subgroup of M₂₄ — so a hit
or a structured miss are both informative). Also cheap: the same t-invariant on the *known* 132
hexads vs the icosahedral 12-point structure (Edge's "10 times over" is t-language for the full
12-set).

10.2 **ω_arc growth census = a strengthening of the open BSW conjecture.**
Census: max arc-clique of E_q, split by type profile (all-external = BSW's exterior-arc quantity;
mixed/internal = new), prime powers included, q ≤ ~150 (Rust port of `gem_sweep.py`'s B&B; Python
died at 37 ≈ 9 min). Invariant: ω_arc(q) and the extremal witnesses' stabilizers. Hypothesized
gaps: (a) all-external ω never again reaches (q+1)/2 — that IS Blokhuis–Seress–Wilbrink 1991,
open for q > 31, and any counterexample refutes a 35-year conjecture; (b) the full mixed curve
(3,4,4,6,6,6,6,8,10,10,10 so far) has bounded ratio to √q or to q — either resolution is a new
theorem-shaped fact about conics; (c) the extremal witnesses at 23–37 are uninspected — compute
their stabilizers; a big group there is a gem candidate nobody has looked at (they are maximal
exterior-arc configurations outside the BSW size regime). Outcomes: data contribution to a live
conjecture (publishable even as negatives), possible new named objects at the extremes, and the
healthy-census hardening to all q ≤ 150 falls out for free.

10.3 **k=4: the twisted-cubic healthy search (the repo's own "family runs through k").**
Census: n-point sets in PG(3,q) in general position (no 4 coplanar), q = 11, 13; up to
Stab(twisted cubic) = PGL₂(q). Invariant: the deep-hole locus of the [n, n−4] MDS code = points
off every trisecant plane (weight-4 cosets; the R=4 analogue of DMP's dictionary — the red-team
killed deep-holes-on-the-*developable*, and the chord-locus version, but left "= the curve itself"
open as the one surviving forward question). Healthy condition: every 3-subset's plane misses the
cubic's q+1 rational points, and those planes cover everything else off the cubic. Nulls:
capacity C(n,3)(q²+q+1) ≥ q³+q²+q − n gives n ≥ 5 at q=11; the pencil analogue (planes through a
chord of the set must avoid the cubic — the q+1 cubic points distribute over the q+1 planes
through a line, so cubic-free planes through a line are scarce) gives a real ceiling to compute.
Search: DFS as in `gem_sweep.py` with plane-masks; ~1300 off-cubic points at q=11, PGL₂(11)
symmetry order 1320 — Rust-scale, feasible. Outcomes: a hit is a genuinely new object (first
deep-holes-fill-a-curve instance beyond the plane, rung 2 of the k-tower — the paper's own
"path from singular to family"); a miss at 11 and 13 is exhaustive-per-cell and would close the
manuscript's one open forward question with a census instead of a shrug.

10.4 **The U-atlas (generalizing the one hit's whole pipeline).**
Census: all n-arcs of PG(2,q) up to PGL₃(q), q ≤ 13, all n (the q=11, n=6 cell is the paper; the
enumeration technique — frame-normalize 4 points, sweep completions — is already in
`check_rigidity_degenerate_conic.py`). Invariants per class: |U|, and *curve-fit of U* (contained
in / equal to the rational points of a line, conic, cubic — cubics split by singular type and
j-invariant). Null: generic U fits no curve of degree ≤ 3 once |U| > 9ish; fit-dimension counting
says exact-fill events should essentially never happen by chance. Hypothesized gap: exact fills
(U = all points of the curve) are isolated and group-caused; the census finds every one, including
**elliptic-curve targets that the C132 genus-0 prescription excluded by fiat** — dropping that
dogma is the cheapest way this program finds a *new kind* of gem (deep holes = E(F_q), |U| in the
Hasse window, automorphisms from E's 3-torsion/Hesse structure). Outcomes: each exact-fill cell is
a candidate theorem with the §9.4 upgrade protocol; the min-|U|(q,n) table alone extends the
paper's census sentence to a spectrum nobody has printed (concede raw extension-counts to the
Sadeh-school as the paper already does; the curve-fit column is ours).

## 11. New properties on known objects (Opus's question 5) — the concrete list

Beyond 10.1 (hexads — run) and 10.2's witness-stabilizers:

- **The arcs-paper census, (c)-column**: for every complete-outside-conic arc the `arcs` manuscript
  knows at any q, record whether U is the *full* conic (the (b) vs (c) distinction from the family
  tree). The healthy census says the answer is "only Clebsch" for prime q ≤ 37; the arcs paper's
  own examples at other q deserve the column filled in from its side of the fence.
- **Schreier column over the Dickson census**: for each subgroup H ≤ PGL₂(q) (Dickson's list is a
  complete census) and each involution-class orbit, the Schreier graph on the conic; flag planar /
  Whitney / named-polyhedral outputs. Null: generic Schreier graphs are none of these. The
  icosahedron hit (§loop-back) becomes row one of a table instead of a hand-found miracle; the
  interesting hypothesized gap is "polyhedral outputs occur only at fills-the-line parameters."
- **The q=5 frame code**: dual/coset structure of [4,1,4]₅ and whether the S₄-chirality analogue
  behaves as C126's sign-character theory predicts (S₄ has a sign character, so its two-orbit
  splitting should *merge* — a clean negative control for the chirality proposition, strengthening
  the paper's "only A₄/A₅" argument with an in-family witness).
- **Edge's partition**: verify his "sets of 6" partition of the 66 external points into 11
  hexagons over a fixed conic, and how the 22 = 2×11 copies split by chirality — connects Edge
  1956 directly to the paper's ℤ/2 and costs an afternoon.
- **The E_q involution lens** (§7.3): translate ω_arc into the derangement-graph frame and ask the
  EKR-for-PGL₂ people's tools the question; even a failed transfer identifies which algebraic
  structure the arc condition destroys.

## 12. Verification ledger

Computed this session (commands as cited; scripts in scratchpad, sha256 in header — **promote to
`notes/` verifiers on approval, they are not yet durable**):
- Everything in §2's table and bullets (`gem_sweep.py`).
- Hexad spectrum + two-Steiner identification (`mathieu_poles.py` + inline orbit check).
- Edge 1956 passages (fetched PDF, pdftotext, quoted verbatim); manuscript's missing Edge/BSW
  citations (grep).

Reasoned, not machine-checked: the pencil bounds (3.3); the degenerate-conic impossibility (§4.1);
the torus-clique collinearity (3.4); the q=5 frame-equivalence reading (standard); "S₄/A₅" names
for the computed stabilizer orders 24/60 inside PGL₂(5)/PGL₂(11) (order + classical subgroup
classification; the 60 at q=11 is independently the paper's).

Speculative / unverified: BSW paper contents beyond the search-result summaries (get the Giessen
1991 and Combinatorica 1992 texts — same ILL batch as Hirschfeld–Sadeh); whether Edge's §§18–32
contain the covering fact (read before re-locking the priority footnote); De Boeck's exact
classification claims; the Meagher–Spiga recollection; everything in §10.3's dictionary details
(re-derive DMP's R=4 coset correspondence before building); prime-power gaps in the census
(q = 9, 25, 27, 49 unswept).

Known limitations: censuses are prime-q only; ω_arc witnesses at q ≥ 23 not canonicalized or
stabilizer-typed; the hexad result has had no literature check yet; no C-IDs allocated — items in
§§4, 5, 10, 11 each need an ID and lane pegging (most are `clebsch`; 10.3 plausibly `cubic`) before
any of this becomes queued work.
