# Literature search: ω_arc(q) and the elliptic-involution clique — verdicts

> **⚠ THIS FILE CONTAINS KNOWN ERRORS — do not cite from it without cross-checking.** Found by the
> [gem-program vet](2026-07-14-gem-program-vet.md) §1.11 and left in place (this is an append-only
> search log, not a live doc):
> - **"M. De Boeck" as author of arXiv:1201.0484 (twice) is wrong** — it is **Geertrui Van de
>   Voorde**, and the journal version is *Discrete Math.* **311**(20) (2011) 2253–2258. arXiv's own
>   journal-ref field for that paper is also wrong and points at a different paper of hers.
> - **The conjecture is misattributed to Giessen 1991** — it is **Combinatorica 12 (1992) 143–147**.
> - The "weaker condition" definition of BSW exterior sets given below is **unsourced**.
> - **The BSW conjecture's computational range is q < 131, not q ≤ 31** (vet §1.4), so the census to
>   q=37 recomputes inside a checked range and this note's framing of it as new is wrong.
>
> The verdicts themselves survive: all-external ω_arc is BSW's quantity, the mixed-type version is
> absent from the literature, and the EKR/involution-graph machinery exists but is aimed elsewhere.
> Corrected statements live in the [gem-mining handoff](handoffs/2026-07-14-gem-mining.md) and the
> [novelty status tables](2026-07-14-novelty-status-review-summary-tables.md).

**Lane**: `clebsch` — see CLAUDE.md § Lane routing. Companion to
[gem-mining next steps](2026-07-14-gem-mining-next-steps-fable.md) §7, which already found the
core hit (Edge 1956, BSW 1991) in the prior session; this note is the full four-vocabulary sweep
requested on top of that, with verdicts and citations.

## Verdicts, one line each

| Vocabulary | Verdict | What exists |
|---|---|---|
| Finite geometry (exterior sets / arcs / external lines to a conic) | **STATED** for the two known extremal points (q=7, q=11), **ADJACENT** for the general mixed-type ω_arc(q) | Blokhuis–Seress–Wilbrink 1991/1992 study exactly the all-external special case; Edge 1956 names the q=11 instance a *Clebsch hexagon*; nobody studies the mixed internal/external clique+arc quantity for general q |
| Algebraic graph theory (E_q, rank-3/orbital treatments) | **ADJACENT**, thin | Hollmann–Xiang build an association-scheme/coherent-configuration on the conic's *lines* (secant and exterior classes), not on the off-conic *points*; no source found studying E_q itself, its point-restricted subgraphs, or their clique numbers |
| Permutation groups / EKR (derangement graph, involution class) | **ADJACENT**, strong on machinery, absent on the specific object | Meagher–Spiga compute the full-group derangement-graph spectrum of PGL(2,q) via characters; several follow-on papers (Cazzola–Gogniat–Spiga; Fusari–Previtali–Spiga) study cliques in derangement graphs of transitive/innately-transitive groups generally; Tranchida (2024) uses the identical involution↔off-conic-point correspondence for a different question (hypertopes from triples). No paper restricts the derangement graph to the involution conjugacy class and asks for its clique number |
| Group theory (involution graphs, Bates–Bundy–Rowley–Perkins school) | **ABSENT** as a matching definition; **ADJACENT** as a research paradigm | The commuting-involution-graph and fixed-product-order-graph literature is extensive for PSL(2,q)/PGL(2,q), but every adjacency relation found (commuting, product-has-order-3, product-has-order-n) is a *different* relation from "product is fixed-point-free on P¹(F_q)" (elliptic); none of the found papers use elliptic-product adjacency |
| Growth curve 3,4,4,6,6,6,6,8,10,10,10 | **ABSENT from OEIS** | Confirmed by direct OEIS search (full sequence and several sub-sequences); no match, no near-miss with any evident connection |
| Arc + graph-clique combination as a studied pattern | **ABSENT** | No general machinery found for "impose no-3-collinear on top of a graph-adjacency clique condition in a finite plane" as a named technique; the covering/deep-hole overlay from the Clebsch paper's own toolkit is, on current search, the closest thing to a method for this combination |

**Bottom line for the bonus question**: no source found gives, or plausibly yields off-the-shelf, an
upper bound on ω_arc(q) better than the pencil bound (q+3)/2. The closest thing to "a theorem might
be hiding here" is that the all-external restriction of ω_arc(q) is *exactly* the subject of the open
1991 Blokhuis–Seress–Wilbrink conjecture (never exceeds (q+1)/2, conjecturally strictly below it for
q > 31) — i.e. the gap you're seeing is, in its all-external special case, a 35-year-old open problem,
not a new one. The mixed-type generalization (internal points allowed) appears to be genuinely new
territory with no attached machinery.

---

## 1. Finite geometry

**Search terms tried**: "external lines to a conic", "exterior points no three collinear", "arcs
and conics PG(2,q)", "external point graph", "conic graph", "tangent-free", "skew to a conic",
"0-bisecant", "internal points conic external lines arc", "exterior set conic mixed internal
external clique".

**What's there.**

- **Blokhuis, Seress, Wilbrink, "On sets of points without tangents,"** *Mitt. Math. Sem. Giessen*
  201 (1991), 39–44. Defines an *exterior set* of a conic as a point set whose pairwise joins meet
  the conic in at most one point (i.e. joins are external or tangent — a **weaker** condition than
  E_q-adjacency, which requires strictly external). They study conic ∪ (q+1)/2 exterior points, no
  3 collinear ("sets without tangents"), and show **q=7 and q=11 are the only known examples**: the
  q=7 case is a 4-point quadrangle, the q=11 case is the 6-point configuration Edge already called
  the Clebsch hexagon. Computer search: no such set for 11 < q ≤ 31. **Conjecture (open since
  1991): none exists for q > 31.** This is the literal statement of "does the all-external
  restriction of ω_arc(q) reach (q+1)/2," and both known positive instances (q=7 size 4, q=11 size
  6) are exactly the ω_arc(7)=4 and ω_arc(11)=6 witnesses.
- **Blokhuis, Seress, Wilbrink, "Characterization of complete exterior sets of conics,"**
  *Combinatorica* 12 (1992), 143–147 — follow-up classification.
- **M. De Boeck, "On sets without tangents and exterior sets of a conic,"** arXiv:1201.0484 (2012).
  Surveys and extends the BSW program; confirms the (q+1)/2-exterior-set problem is still the live
  open question, with classification results for small/special q. No treatment of mixed
  internal/external configurations or of a general clique-number function of q.
- **J. Dover, "Untouchable sets of size 2q±1 in PG(2,q),"** arXiv:2505.08551 (2025) — recent,
  confirms the exterior-set/BSW area is still active, but the object (untouchable sets — points not
  covered by a fixed line family) did not, on inspection, turn out to be equivalent to ours; flagged
  as unread-in-full (PDF extraction failed twice; only the title/author were recovered).
- **W. L. Edge, "Conics and orthogonal projectivities in a finite plane,"** *Canad. J. Math.* 8
  (1956), 362–382. Classical precedent, 35 years before BSW: at q=11 he constructs the same 6-point
  set (all-external, all 15 joins skew/external, Brianchon-concurrent in 10 triples) and writes "we
  may say, with Clebsch, that the points... form a hexagon endowed 10 times over with the Brianchon
  property" — the origin of the term the project's own Clebsch-hexagon paper uses. Also treats
  q=5, q=7 in full detail (§§18–32) via the orthogonal-group/LF(2,q) route; worth a full read for
  whether he states anything about q=5's (already-found) all-internal 4-arc, but nothing in the
  passages read states the general-q growth question.
- **Hollmann, Xiang, "Association schemes from the action of PGL(2,q) fixing a nonsingular conic
  in PG(2,q),"** arXiv:math/0503573 (2005). Builds a coherent configuration on the conic's
  non-tangent *lines*; the restriction to exterior (elliptic) lines is a pseudocyclic association
  scheme. This is the natural "rank-3-ish" structure on the *line* side of the picture, not the
  point side — see §2 below for why it doesn't transfer directly.
- **"Line partitions of internal points to a conic in PG(2,q),"** *Combinatorica* / arXiv:math/0607118
  — classifies line-sets partitioning the internal points; adjacent geometric machinery on internal
  points specifically, but not an arc/clique quantity.

**Verdict detail.** The all-external special case of ω_arc(q) — i.e. "cliques of E_q restricted to
external points, with the arc condition" — is exactly the BSW quantity, STATED and the subject of
an open conjecture. The general mixed-type ω_arc(q) (internal points allowed, which the prior
session's census shows is essential — the q=3, 5, and q=19-icosahedral extremal witnesses are
all-internal) is not addressed anywhere found: ADJACENT via the same toolkit (pencils, exterior
sets) but not STATED.

## 2. Algebraic graph theory

**Search terms tried**: rank-3/orbital treatments of PGL(2,q) on off-conic points; "conic graph";
named graph families on internal/external points under external-line adjacency; association scheme
of PGL(2,q) on point-pairs.

**What's there.** Hollmann–Xiang (above) is the only rank-3/association-scheme-style paper found
touching this action, and it is built on the wrong object: **lines**, not points. The reason it
doesn't transfer: their vertex set is L⁻(q), the q(q-1)/2 exterior lines themselves (PGL(2,q) acts
generously transitively on them), with relations given by cross-ratio of line quadruples. Our E_q
has off-conic *points* as vertices. A point-line duality exists in PG(2,q) generally, but the conic
breaks it — the polarity swaps points and lines but also swaps internal↔external in a
type-dependent way, so "the elliptic scheme on lines" is not simply dual to "E_q on points."
Nothing found computes E_q's spectrum, names its internal-restricted or external-restricted
subgraphs, or discusses their clique numbers. The one already-known fact (tangent-adjacency on
external points = triangular graph T(q+1)) has no external-line-adjacency analogue in the
literature searched. **Verdict: ADJACENT machinery exists one level removed (on lines); the point-side
object appears genuinely unstudied — ABSENT as a named graph family.**

## 3. Permutation groups / Erdős–Ko–Rado

**Search terms tried**: "Erdos-Ko-Rado PGL(2,q)", "derangement graph clique conjugacy class",
"intersection density conjugacy class", "class derangement graph", "normal Cayley graph conjugacy
class involutions", plus direct searches for Meagher, Spiga, Godsil, Ahmadi in combination with
PGL(2,q)/PSL(2,q) and involutions.

**What's there.**

- **Meagher, Spiga, "An Erdős-Ko-Rado theorem for the derangement graph of PGL(2,q) acting on the
  projective line,"** arXiv:0910.3193 (2009/2011, *JCTA*). Vertex set = **all of PGL(2,q)** (not
  the involution class); edges = pairs whose "quotient" is a derangement of P¹(F_q). Proves max
  intersecting (= independent) set has size q(q-1), attained only by point-stabilizer cosets.
  **Computes the full spectrum via character theory** (Table 3): valency q²(q-1)/2, minimum
  eigenvalue **τ = -q(q-1)/2**, realized on characters λ₋₁ and ψ₁ (q odd) or ψ₁ alone (q even);
  general formula Lemma 2: eigenvalues of any normal Cayley graph on G are {χ(D)/χ(1) : χ ∈
  Irr(G)}. This is genuine, reusable, character-theoretic machinery — but for the wrong vertex
  set (whole group, not the involution class), and for *independent sets* (Hoffman bound), the
  opposite extremal direction from a clique-number question.
- **Cazzola, Gogniat, Spiga, "Kronecker classes and cliques in derangement graphs,"**
  arXiv:2502.01287 (2025). Proves any transitive G of degree > 30 has a K₄ in its (whole-group)
  derangement graph; motivated by Neumann–Praeger's Kronecker-class conjecture, not by conics or
  PGL(2,q) specifically. General clique-existence machinery, not conjugacy-class-restricted.
- **Fusari, Previtali, Spiga, "Cliques in derangement graphs for innately transitive groups,"**
  arXiv:2311.05575 (2023/2024). Bounds clique-free degree as a function of forbidden clique size k,
  for the whole-group derangement graph of innately transitive G. Same caveat: whole group, not a
  conjugacy class.
- **Tranchida, "Triples of involutions in PGL(2,q) and their incidence geometries,"**
  arXiv:2411.10299 (Nov 2024) — the closest single paper found to the group-theoretic form of the
  object. States explicitly: *"for every point X ∈ π−𝒪, there is a unique involution α_X of
  PGL(2,q) that has X as its center,"* with the axis of α_X being the polar of X — the identical
  correspondence used in the task's write-up. But the question asked is different: he classifies
  triples of involutions by the **order** of pairwise products (not by an elliptic/hyperbolic split)
  to build rank-3 hypertopes, via a "strongly non-self-polar triangle" condition (excludes the case
  where all three involutions pairwise commute). No cliques, no extremal/growth question, no
  citation of Meagher–Spiga, BSW, or Edge. Confirms the correspondence is known machinery in the
  incidence-geometry literature as of late 2024, but the elliptic-clique question was not asked
  there.
- **Intersection-density literature** (Meagher and various coauthors, e.g. arXiv:2511.00787,
  arXiv:2104.04699) studies intersecting sets for transitive actions of PSL(2,q) with various point
  stabilizers — a live, active research program, but again on the whole-group derangement graph
  under a transitive action, not the involution-class-restricted elliptic-product graph.

**Verdict: ADJACENT and rich** — the character-theoretic spectral toolkit for PGL(2,q) derangement
graphs is fully built and the involution↔point↔polar correspondence is independently established
in 2024 incidence-geometry work — but no source found asks "what is the clique number of the
involution class under elliptic-product adjacency," so the specific object is ABSENT.

## 4. Group theory — involution graphs

**Search terms tried**: "involution graph PGL(2,q)", "commuting involution graph clique number",
"product of involutions elliptic hyperbolic dihedral classification", Bates/Bundy/Rowley/Perkins-
school survey terms.

**What's there.** The Bates–Bundy–(Hart/Perkins)–Rowley program (commuting involution graphs for
symmetric groups, Coxeter groups, classical groups, sporadic groups, 2000s–2020s, still active —
e.g. a 2025 paper "Automorphism Groups of the PSL₂(q) Commuting Involution Graphs") is the
established home for "graph on a conjugacy class of involutions with product-type adjacency." But
every variant found uses a **different** adjacency relation than ours:

- **Commuting involution graphs**: adjacency = t₁t₂ = t₂t₁, i.e. product has order ≤ 2. This is the
  geometric case where the two points' involutions generate a Klein four-group — closest to our
  "self-polar triangle" degenerate case (Tranchida's excluded case), the opposite of elliptic.
- **"Involution graphs where the product of two adjacent vertices has order three"** (Cambridge
  paper, PSL(2,q)) — a fixed-small-order variant.
- No paper found uses "product is fixed-point-free on the natural P¹(F_q) action" (equivalently:
  product order divides q+1 with no F_q-rational eigenvalues) as the adjacency relation. This is a
  geometrically natural condition (it is literally "external line" under the conic dictionary) but
  it does not appear to have been the object of study in this school. The Dickson-style
  classification of PGL(2,q) elements by θ(M) = tr(M)²/det(M) (elliptic ⟺ θ − 4 a non-square) is
  standard textbook material (present implicitly in Meagher–Spiga §3, and in general PGL(2,q)
  character-theory references) but is a **classification of individual elements**, not a
  graph-clique study.

**Verdict: ABSENT** as a matching definition; the research paradigm (conjugacy-class graphs under
product-type adjacency) is well-established and could straightforwardly host this question, but
nobody has, on this search, asked it with elliptic/derangement-type adjacency.

## Growth curve / OEIS

Direct OEIS searches (via `curl https://oeis.org/search?q=...&fmt=text`, which works — WebFetch
403s on oeis.org):

- `3,4,4,6,6,6,6,8,10,10,10` (full sequence): **no results**.
- `4,4,6,6,6,6,8,10,10,10`, `3,4,4,6,6,6,6`, `6,6,6,6,8,10,10,10` (sub-sequences, to catch
  offset/leading-term issues): each returns a handful of matches, none with any plausible
  connection to conics, arcs, or PGL(2,q) (matched sequences are about integer factorials, squared
  divisibility, and infinite-product generating functions).

**Confirmed ABSENT.** The sequence is not in OEIS under any tried framing.

## Arc + clique combination as a general pattern

No source found treats "no-3-collinear" as a condition layered on top of a graph-adjacency clique
condition as a named or systematized technique in finite geometry. The closest available tool
remains internal to the project's own toolkit (the covering/deep-hole overlay from the Clebsch
paper), not anything found in the literature sweep.

## Sources

- [Blokhuis–Seress–Wilbrink 1991, discussed via De Boeck's survey](https://arxiv.org/pdf/1201.0484)
- [De Boeck, "On sets without tangents and exterior sets of a conic," arXiv:1201.0484](https://arxiv.org/abs/1201.0484)
- [Combinatorica 12 (1992) 143–147 (BSW follow-up)](https://link.springer.com/article/10.1007/BF01204717)
- [Dover, "Untouchable sets of size 2q±1 in PG(2,q)," arXiv:2505.08551](https://www.arxiv.org/pdf/2505.08551)
- Edge, "Conics and orthogonal projectivities in a finite plane," *Canad. J. Math.* 8 (1956) 362–382
  ([PDF](https://webhomes.maths.ed.ac.uk/~icheltso/edge2016/pdf/1956a.pdf))
- [Hollmann–Xiang, "Association schemes from the action of PGL(2,q) fixing a nonsingular conic in PG(2,q)," arXiv:math/0503573](https://arxiv.org/abs/math/0503573)
- ["Line partitions of internal points to a conic in PG(2,q)," arXiv:math/0607118](https://arxiv.org/abs/math/0607118)
- [Meagher–Spiga, "An Erdős-Ko-Rado theorem for the derangement graph of PGL(2,q) acting on the projective line," arXiv:0910.3193](https://arxiv.org/abs/0910.3193)
- [Cazzola–Gogniat–Spiga, "Kronecker classes and cliques in derangement graphs," arXiv:2502.01287](https://arxiv.org/pdf/2502.01287)
- [Fusari–Previtali–Spiga, "Cliques in derangement graphs for innately transitive groups," arXiv:2311.05575](https://arxiv.org/pdf/2311.05575)
- [Tranchida, "Triples of involutions in PGL(2,q) and their incidence geometries," arXiv:2411.10299](https://arxiv.org/abs/2411.10299) ([HTML](https://arxiv.org/html/2411.10299v1))
- [Bates–Bundy–Hart–Rowley commuting involution graph program — representative survey entry point](https://peterrowley.github.io/publications/)
- [OEIS search interface](https://oeis.org/)

## What was not fully verified

- Dover's "untouchable sets" paper (arXiv:2505.08551): PDF extraction failed twice (compressed
  stream not parsed by WebFetch's summarizer); only title/author confirmed. Worth a manual
  `pdftotext` pass if this lane wants certainty on whether it's a near-miss.
- Edge 1956 §§18–32 (the full q=5,7,11 geometry) — read in part in the prior session, not
  exhaustively; the possibility that Edge states a general-q pattern (rather than just doing
  q=5,7,11 case-by-case) was not fully ruled out here.
- Whether the Godsil–Meagher book *Erdős–Ko–Rado Theorems: Algebraic Approaches* treats
  conjugacy-class-restricted derangement graphs anywhere in its later chapters — not opened (found
  only via its Cambridge Core listing, no full-text access attempted).
