# Continuation-graph rigidity — external citation-audit scope

**Date:** 2026-07-11
**Lane:** the `[PROVED]` theorems of
[`2026-07-10-continuation-graph-rigidity-upgrades.md`](2026-07-10-continuation-graph-rigidity-upgrades.md)
(embedded recovery / intrinsic traces / semilinear extension of the cap continuation graph +
continuation complex).
**Why this note exists:** the 07-10 upgrade note is an **internal** audit baseline authored by Codex
(§7.5 moduli identification + novelty boundary, §8.5 Bruck/Metsch/Batten prior-art boundary, §12
scope audit). Those sections *name* the candidate prior art but explicitly defer the full-text
collision check ("A full-text audit of Metsch's uniqueness chapter is still required…"; §7.5's
non-implication of Bruno–Mella is *asserted*, not verified). This note runs the **external
full-text pass** Codex flagged as pending. It does not re-derive the internal boundary; it tries to
break it.

**Method + house style** match
[`2026-07-11-twisted-cubic-axis-lrc-audit-scope.md`](2026-07-11-twisted-cubic-axis-lrc-audit-scope.md):
atomic novelty claims `N1…N5`; per-claim prior-art **RISK** tier; named candidate-collision papers;
**searches run** logged so each none-found is auditable; full-text **CHECKED** / **collision** /
**none-found** verdict; explicit **KILL CONDITION**; house tags `[CHECKED]` (full text opened this
session) / `[VERIFY]` (only abstract/secondary reached — paywalled or PDF-unparsed).

**Tooling caveat (transparency).** Only **one** candidate was opened in genuine full text this
session: Bruno–Mella arXiv:1006.0987 (pdftotext). ScienceDirect / Springer / Cambridge / JLMS
targets are paywalled; their statements below are from abstracts + secondary sources and carry
`[VERIFY]`. This is a **first external pass**, adversarial but not yet a MathSciNet/zbMATH
full-text clearance for the §8 genre.

---

## The lane, decomposed into atomic novelty claims

The executive conclusion advertises **two** headline theorems (7.4 semilinear frame rigidity;
8.4 full-complex reconstruction) plus supporting structure (Lemma 4.1 clique bound, Theorem 6.2
rook graph, Theorem 8.2 two-point complex, Theorem 5.1 centre recovery, Theorem 2.1 support
degree). These factor into five atomic claims with **materially different** prior-art risk. A
collision on any one resizes (not necessarily kills) that piece; the two headlines are `N1` and `N2`.

---

### N1 — Semilinear rigidity of the four-point frame graph (Thm 7.4) *(headline; MEDIUM risk)*

**Claim.** For every prime power `q ≥ 13`, the *abstract* graph `G_K` of a projective frame
`K ⊂ PG(2,q)` has automorphism group **exactly** the ambient stabilizer
`Stab_{PΓL(3,q)}(K) ≅ S₄ × Gal(F_q/F_p)`, order `24·[F_q:F_p]`. `Omega = M_{0,5}(F_q)` and `G_K`
is the *uncoloured four-forgetful-map fibre-coincidence graph*: adjacency = "some one of the four
retained cross-ratio coordinates `x, y, x/y, (x−1)/(y−1)` agrees." The engine is intrinsic recovery
of the four fibre partitions (Thms 4.2 + 5.1) followed by the functional-equation classification
(Lemmas 7.2–7.3 → Frobenius).

**Prior-art risk: MEDIUM.** The moduli identification is real and classical, so a reader will
reach for the known `M_{0,n}` automorphism theorem and the cross-ratio-graph automorphism corpus.
The whole novelty rests on the claim that *neither* applies to an **arbitrary set permutation of the
finite `F_q`-point set preserving one uncoloured binary relation.**

**Candidate-collision papers:**
- **Bruno–Mella, *The automorphism(s) group of `M_{0,n}`*, JEMS 15 (2013) 949–968**
  (arXiv:1006.0987). The obvious "this is already known" hit.
- **Gardiner–Praeger–Zhou, *Cross ratio graphs*, JLMS 64 (2001) 257–272**
  (doi:10.1112/S0024610701002150). The automorphism-method prior art in exactly this
  cross-ratio-over-`PG(1,q)` neighborhood.
- Bruno–Mella forgetful-map machinery (Kapranov description) — the tool, checked for scope.

**Searches run:** `Bruno Mella automorphisms moduli space M_{0,n} symmetric group`;
`Gardiner Praeger Zhou cross ratio graphs projective line automorphism`;
`automorphisms M_{0,n} over finite field rational points combinatorial reconstruction cross-ratio`.

**Full-text verdict: [CHECKED — non-colliding] (Bruno–Mella opened in full).** pdftotext of
arXiv:1006.0987 gives the exact statements. **Theorem 3:** "Assume `n ≥ 5`, then `Aut(M_{0,n}) = S_n`."
The *entire method* is **Theorem 1/2**: "any dominant morphism with connected fibers
`f : M_{0,n} → M_{0,r₁}×…` is a forgetful map" — i.e. the result classifies **biregular
(algebraic) automorphisms of the variety** over the ground field via birational/forgetful-map
geometry (Kapranov's Hilbert-scheme description of `\bar M_{0,n}`). It says **nothing** about a
set-theoretic permutation of `M_{0,5}(F_q)` preserving a combinatorial adjacency; it never touches
`F_q` at all. The `S₅` it produces is exactly the frame's ambient `S₄` (after stabilizing the
omitted marking) — which Thm 7.4 *also* recovers as its projective factor. So Bruno–Mella supplies
the *geometric* automorphisms but does **not** rule out extra non-geometric graph automorphisms; that
exclusion is precisely the four-fibre-partition recovery (Thms 4.2/5.1) + isotopy classification
(Lemmas 7.2–7.3), which is the actual content. **The §7.5 non-implication is confirmed.**

**[VERIFY] Gardiner–Praeger–Zhou** — abstract + UWA-repository page reached (full JLMS text
paywalled). Confirmed: vertices are **ordered pairs of distinct points on `PG(1,q)`**, adjacency by
a cross-ratio orbit — a **different** graph from the four-map coincidence graph on `M_{0,5}` (which
is on the *5-point moduli* set, unordered, four-relation-union). GPZ determine *their* graphs'
automorphism groups by the automorphism method; they do **not** treat the four-map reduct. Adjacent
methodology, not a subsumption. The one residual is the exact adjacency subset in GPZ, which cannot
change the fact that the vertex set and relation differ.

**Verdict: none-found; N1 survives external scrutiny.** Risk **MEDIUM → LOW-MEDIUM.** The moduli
picture is honest-to-goodness prior art but points the *other* way: the classical theorem is
algebraic over `C`, the novelty is combinatorial rigidity over `F_q` from one uncoloured relation,
and the two are provably different objects. Frame the paper as "finite-field graph-permutation
rigidity of the `M_{0,5}` four-map reduct, strengthening the geometric `S₄` to the *only*
automorphisms," explicitly citing Bruno–Mella (as the algebraic analogue that does **not** imply it)
and GPZ (as adjacent cross-ratio-graph automorphism method).

**Minor correction for the manuscript.** §7.5 calls Bruno–Mella a theorem about "the full
**compactified** moduli space." arXiv:1006.0987 Thm 3 is stated for the **open** `M_{0,n}`
(`Aut(M_{0,n}) = S_n`); the compactified `\bar M_{0,n}` statement is the same group but a distinct
theorem. Audit-immaterial (both are biregular-over-`C`), but pin the exact object before citing.

**Kill condition.** Any prior work computing the automorphism group of the **finite** `M_{0,5}(F_q)`
point set under a fibre-coincidence (or cross-ratio-coincidence) adjacency, i.e. a set-permutation
rigidity theorem rather than a biregular/collineation one; or any statement that the four-map reduct
is a corollary of an `S_n`-type automorphism theorem. The two named candidates are cleared; a
MathSciNet forward-citation sweep of Bruno–Mella and GPZ for finite-field/combinatorial spinoffs is
the remaining diligence.

---

### N2 — Full continuation-complex reconstruction of plane + secants + arc (Thms 8.4 / 8.3) *(headline; HIGH risk)*

**Claim.** For a `k`-arc `K` (`k ≥ 3`) in an *arbitrary* plane of order `q`, once
`q ≥ max{a_K²−a_K+k, k²−3k+3, a_K+k²−k+1}`, the **abstract** simplicial complex
`Delta_K` (faces = caps over `K`), given only via its binary + ternary minimal nonfaces
(Prop 8.1), canonically reconstructs (i) the whole incidence plane, (ii) the `C(k,2)`-secant
arrangement, (iii) the arc `K` itself (degree characterization (8.4)); hence every complex
isomorphism `Delta_K ≅ Delta_J` extends uniquely to `(Π,K) ≅ (Π',J)`, semilinear for
Desarguesian planes. The engine (Thm 8.3) is a Deza-clique arrangement-complement completion.

**Prior-art risk: HIGH.** "Delete a small arrangement of lines from a projective plane, recover the
plane uniquely" is a **crowded, decades-old genre** (complements/pseudo-complements). The note's own
§8.5 already concedes the `r=2` case is "at most a new short proof" and "fixed `r=3,4` claims carry
high prior-art risk." The external question is whether the arc-specific + intrinsic-complex increment
is a real delta.

**Candidate-collision papers (the genre):**
- **Batten, *A dual approach to embedding the complement of two lines in a finite projective plane*,
  J. Aust. Math. Soc. A 51 (1991)** (doi:10.1017/S1446788700034595) — the `r=2` case, cited by the
  note. Bibliographically confirmed.
- **Mullin, *Embedding the pseudocomplement of a quadrilateral in a finite projective plane*,
  Ann. NY Acad. Sci. (1979)**, and **Drake–Sané (?), *Embedding of finite pseudo-complements of
  quadrilaterals*, J. Stat. Plann. Inf. (1986)** (doi:0378375886901242). Pseudo-complement of a
  **quadrilateral** = complement of **4 lines**; a pseudo-complement of order `n` has `n²−3n+3`
  points and embeds **uniquely** in a plane of order `n` for `n > 23`.
- **Günaltılı–Olgun, *On the embedding of some linear spaces in finite projective planes*,
  J. Geom.** (BF01221065) — complements of a **pentagon / hexagon / heptagon** (5/6/7-line
  arrangements) embed uniquely; "regular hyperbolic plane" (Graves/Ostrom) framing.
- **Beutelspacher–Metsch, *Embedding finite linear spaces in projective planes* I (1986) & II,
  Discrete Math. 66 (1987) 219–230** — long-line linear space of point-degree `n+1` embeds in a
  plane of order `n`. The general embedding engine.
- **Bruck (finite-net completion, Pacific J. Math. 13 (1963) 421) + Metsch cubic improvement** —
  net completion; adjacent (retains all points), cited by note.

**Searches run:** `Batten complement of two lines embedding projective plane pseudo-complement
quadrilateral`; `Metsch pseudo-complement quadrilateral complete quadrangle unique embedding`;
`complement of an arc in projective plane reconstruction secant arrangement embedding linear space`;
`"On the embedding of some linear spaces…" complement pentagon hexagon heptagon regular hyperbolic
plane`; `complement of complete quadrangle six lines reconstruction projective plane arc k-arc
secants embedding unique`; `Beutelspacher Metsch embedding finite linear spaces projective planes
long lines`; `reconstruct projective plane from simplicial complex independent sets cap
collinearity`.

**Full-text verdict: [VERIFY on full text — but the decisive kill question is now RESOLVED from
abstracts/parameters] — partial-overlap / genre-collision on the *engine*, none-found on the
arc-specific step; the arc-recovery kill is NOT triggered.** Drake–Sané and the Metsch chapter
were NOT opened in genuine full text this session (both paywalled; no open copy located — see the
per-item logs below and Housekeeping). But the retrieved abstracts + the exact parameter arithmetic
settle the one decisive question the gate turns on:

- **[VERIFY — full text not opened; decisive question RESOLVED] Drake–Sané / Mullin–Vanstone,
  "pseudo-complement of a **quadrilateral**."** Confirmed via multiple independent search hits
  (ScienceDirect abstract text, Mullin–Vanstone NYAS abstract): the object is a *linear space*
  (`(n+1)`-regular, `n²−3n+3` points, `n²+n−3` lines, ≥3 lines of size `n−1`), and the theorem is
  "for `n > 23` it embeds in a **unique** projective plane of order `n`." The deleted configuration
  is a **quadrilateral = 4 LINES**: the `n²−3n+3` point count is exactly `PG(2,n)` minus the
  `4(n+1)−6 = 4n−2` points on four general-position lines (6 vertices of multiplicity 2). This is a
  **low-multiplicity line arrangement**, categorically NOT an arc's secant arrangement (`C(k,2)`
  lines, `k` points of multiplicity `k−1`; for `k=4` that is **6** secants, not 4 lines). And the
  theorem **recovers the deleted LINES by unique embedding of a linear space** — there is no
  arc, no distinguished-point set, and **no degree/multiplicity recovery of a distinguished point
  set** (the arc-recovery step (8.4) `deg_D(P)=k−1 ⇒ P∈K`). **Kill test NOT met:** Drake–Sané
  embeds a linear space and restores lines; it does not recover an arc-like distinguished point set
  from a secant-arrangement complement.
- **[VERIFY — full text not opened] Metsch, *Linear Spaces with Few Lines* (LNM 1490) uniqueness
  chapter / Beutelspacher–Metsch.** No open copy located (Springer paywalled; Google Books preview
  exposes only the index term "pseudo-complement", no substantive page text). Search-confirmed as
  the **general linear-space → projective-plane embedding-uniqueness engine** (cf. Metsch, "A remark
  on the uniqueness of embeddings of linear spaces into desarguesian projective planes", J. Combin.
  Des. 3 (1995) 293–297). Same category as Drake–Sané: it embeds a linear space and restores
  *lines*; nothing located states an arc/secant-arrangement input or a degree-based recovery of a
  distinguished point set. The gate is *not* fully discharged without the full text, but the located
  evidence points away from a kill.

Supporting genre observations (unchanged from the first pass, abstracts decisive on scope):

- The completion **engine** (Thm 8.3: arrangement-complement → unique plane by Deza cliques) is
  **not new as a phenomenon.** Complements of `r`-line arrangements embedding uniquely is exactly
  Batten (`r=2`), pseudo-complement-of-quadrilateral (`r=4` lines), Günaltılı–Olgun
  (pentagon/hexagon/heptagon, `r=5,6,7`), all under a large-order hypothesis, all "unique
  embedding." A reader **will** call Thm 8.3 a Deza-flavored reproof/generalization of this corpus,
  not a new completion paradigm — which is precisely what §8.5 already says ("a structured
  promised-input refinement in their research neighborhood, not a wholly new completion paradigm").
- **BUT the located prior art removes polygons / pseudo-complements** (arrangements whose points have
  low multiplicity — a polygon has only its `r` vertices doubled). The `k`-arc **secant
  arrangement** is a *different* arrangement class: `C(k,2)` lines with `k` points of multiplicity
  `k−1`. No located paper reconstructs from the **secant arrangement of an arc**, and none performs
  step (iii) — **recovering the arc `K`** via `deg_D(P)=k−1` (8.4). That arc-recovery + the
  full-faithfulness statement `Delta_K ≅ Delta_J ⇒ (Π,K)≅(Π',J)` is unlocated.
- The **intrinsic-complex framing** (reconstruct from the abstract `Delta_K`'s binary+ternary
  minimal nonfaces, not from a given linear space) is also unlocated as a *result* — but it is thin:
  the ternary-nonface → external-line-trace step is essentially "an affine/linear space is
  determined by its collinear triples," and the direction of the literature (e.g.
  arXiv:2110.12314 *Simplicial complexes from finite projective planes*) is planes → complexes, the
  opposite of reconstruction. So this half reads as re-packaging, not a theorem.

**Verdict: SOFTEN.** The headline "the continuation complex reconstructs the plane" collides with
the complement/pseudo-complement genre and must not be advertised as first-of-kind. What survives
external search as genuinely unlocated is the **narrow chain §8.5 already isolates**: (a) the arc's
secant arrangement as the deleted object, and (b) arc-recovery by degree (8.4) giving
full-faithfulness on `(Π,K)`. Publication must center on that chain (and on any *improvement* to the
profile bound `q ≥ r²−r+k`), citing Batten / Mullin / Drake–Sané / Günaltılı–Olgun /
Beutelspacher–Metsch as the completion prior art it refines. **Risk stays HIGH until the Metsch
uniqueness chapter and the pseudo-complement-of-quadrilateral paper are read in full text** — the
§8.5 deferral is not yet discharged.

**Kill condition.** Any paper (i) reconstructing a plane from the complement of an **arc's secant
arrangement** specifically, or (ii) recovering the *deleted configuration's distinguished point set*
(here, the arc) from an arrangement complement, or (iii) a general "complement of a `≤r`-line
arrangement embeds uniquely" theorem subsuming the secant-arrangement profile with the arc-recovery
corollary. Drake–Sané and the Metsch uniqueness chapter were the highest-probability full-text kills;
**neither open copy could be located this session (both paywalled), but their abstracts/parameters
resolve the decisive test against a kill:** Drake–Sané deletes a **quadrilateral (4 lines)** and
embeds a *linear space* uniquely (restoring lines) — it neither takes an arc's secant arrangement as
input nor recovers a distinguished point set by degree (test (ii) fails); Metsch is the general
linear-space embedding-uniqueness *engine*, same category. The gate is therefore **not full-text
discharged**, but the strongest candidate kill (test (ii), arc-point recovery) is **not exhibited by
the located evidence**. Residual: a MathSciNet full-text read of Drake–Sané / Metsch remains the only
way to *close* (vs. resolve-by-abstract) the gate before a first-of-kind claim.

---

### N3 — Non-tangent clique bound `k(k−2)+1` improving Deza (Lemma 4.1) *(LOW-MEDIUM risk)*

**Claim.** A clique of `G_K` not contained in one tangent trace has size `≤ k(k−2)+1`, improving
Deza's generic `k²−k+1` for `k`-uniform linear hypergraphs, *because* the continuation hypergraph's
symbols resolve into `k` selected centres.

**Prior-art risk: LOW-MEDIUM.** This is a domain-specific sharpening of a named classical bound;
the risk is only that the sharpened constant is already in some finite-geometry paper.

**Candidate-collision papers:**
- **Deza, *Solution d'un problème de Erdős–Lovász*, JCTB 16 (1974) 166–167**
  (doi:0095895674900598) — the parent bound.
- **Naik–Rao–Shrikhande–Singhi, *Intersection graphs of `k`-uniform linear hypergraphs*,
  EJC (1982)** — line-graph-of-linear-hypergraph structure, the object `G_K` sits inside.

**Searches run:** `Deza weak delta-system theorem … clique bound k^2-k+1 sunflower`;
`Deza 1974 Solution d'un probleme Erdos Lovasz maximum k-sets pairwise intersection one`;
`Naik Rao Shrikhande Singhi intersection graphs k-uniform linear hypergraphs`.

**Full-text verdict: [VERIFY — parent bound confirmed via secondary] non-colliding.** Deza's theorem
is confirmed (via multiple secondary sources): a family of `k`-sets with equal pairwise intersection
and `m ≥ k²−k+2` members is a sunflower — so a non-sunflower family has `≤ k²−k+1` members, exactly
the note's baseline (and Thm 8.4's "`k²−k+2` ⇒ common tangent"). Naik–Rao–Shrikhande–Singhi is the
Krausz-type characterization of line graphs of `k`-uniform linear hypergraphs (background, cited as
such, no clique-bound collision). **The `k(k−2)+1` sharpening is a genuine continuation-geometry
improvement** (the centre-resolution argument is specific to the "each edge has a unique selected
centre" structure of (1.1)); not located elsewhere.

**Verdict: non-colliding, but low citability.** Correct improvement of a classical bound; per §10
it is "a useful middle lemma rather than a headline" unless `m(k)` is pinned sharply. No prior-art
problem, modest standalone value.

**Kill condition.** A finite-geometry paper already giving an `O(k)`-type clique bound for
tangent-resolved arc continuation hypergraphs, or the exact value of `m(k)`.

---

### N4 — Two-point graph is the rook graph, plane-independently (Thm 6.2) *(LOW risk / folklore-adjacent)*

**Claim.** For `K={a,b}` in *any* plane of order `q`, `G_K ≅ K_q □ K_q` (the `q×q` rook graph),
independent of the plane; hence non-isomorphic planes of order `q` share a two-point continuation
graph, and `|Aut(G_K)| = 2(q!)²` dwarfs the `2q²(q−1)²` PGL stabilizer already at `q=5`.

**Prior-art risk: LOW (as novelty).** The construction (legal points = affine plane minus line `ab`;
map `x ↦ (ax,bx)`; rook adjacency) is elementary and the rook-graph/`SRG(q², 2(q−1), q−2, 2)`
automorphism `2(q!)²` is textbook. Likely folklore in the cap/arc-continuation setting.

**Searches run:** `rook graph K_q box K_q automorphism group projective plane conflict graph cap`;
`affine plane deleted line continuation graph two points rook graph … non-isomorphic planes same
graph`.

**Full-text verdict: none-found (no explicit prior statement located), but the fact is elementary.**
Not claimed as a headline — the note uses it purely as the **obstruction** proving semilinear
extension must begin at `k=4` and as the setup for Thm 8.2. No collision because there is no novelty
claim to collide with; the value is scope-classification.

**Kill condition.** N/A for novelty. (Only relevant if someone advertised it as new — don't.)

---

### N5 — Two-point complex reconstructs the plane (Thm 8.2) *(MEDIUM risk)*

**Claim.** For `q ≥ 3`, `K={a,b}`, the abstract complex `Delta_K` determines the affine plane
`Π∖ab`, its two distinguished parallel classes, the projective completion, and hence `(Π,{a,b})` up
to isomorphism — repairing the N4 obstruction (all planes share the graph; their complexes do not).

**Prior-art risk: MEDIUM.** The mathematical core — "an affine plane is determined by its lines /
collinear triples, and its projective completion is canonical" — is **classical**. The dressing (do
it from the ternary minimal nonfaces of the continuation complex, and observe graph-collision vs
complex-separation) is the candidate-new layer.

**Searches run:** covered by the N2 batch (`reconstruct projective plane from simplicial complex …`;
`affine plane deleted line …`).

**Full-text verdict: partial-overlap.** No paper located that phrases it as "two-point continuation
complex," but the reconstruction is the affine-plane-from-collinearity fact plus canonical
projective completion (both standard; cf. the affine-plane / truncated-projective-plane literature).
The genuinely publishable observation is the **contrast** with Thm 6.2 (graph invariant across
non-isomorphic planes, complex not) — a clean pedagogical point, not a deep theorem. It belongs with
N4 as scope/motivation for N2, not as a standalone result.

**Kill condition.** N/A beyond N2 — subsumed by the N2 completion genre (`r=1`/single deleted line
is the mildest arrangement-complement case).

---

## Overall verdict

**Does the lane's headline novelty survive external full-text scrutiny?**

| Claim | Piece | Risk (post-audit) | External verdict |
|---|---|---|---|
| **N1** | Thm 7.4 frame-graph semilinear rigidity (`M_{0,5}` four-map reduct) | LOW-MEDIUM | **Survives.** Bruno–Mella (opened) is biregular-over-`C` via forgetful maps, provably not about `F_q`-set permutations; GPZ is a different graph. Non-implication confirmed. |
| **N2** | Thm 8.4 / 8.3 full-complex reconstruction | **HIGH → MEDIUM-HIGH (kill test resolved, gate not full-text-closed)** | **Soften, but survives.** Engine collides with the complement / pseudo-complement genre (Batten, Mullin, Drake–Sané, Günaltılı–Olgun, Beutelspacher–Metsch). The decisive kill test — does the genre recover a *distinguished point set (an arc)* from a secant arrangement by degree — is **NOT met**: Drake–Sané deletes a **quadrilateral (4 lines)**, embeds a linear space uniquely (restores *lines*), never recovers arc points by degree; Metsch is the general embedding engine, same category. So the secant-arrangement-of-an-arc + arc-recovery (8.4) + intrinsic-complex framing is **unlocated and un-killed** — resolved from abstracts, not yet full-text-closed (no open copy of Drake–Sané/Metsch found). |
| **N3** | Lemma 4.1 clique bound `k(k−2)+1` | LOW-MEDIUM | Non-colliding domain sharpening of Deza; low citability. |
| **N4** | Thm 6.2 rook graph | LOW | Elementary scope result; no novelty claim to collide. |
| **N5** | Thm 8.2 two-point complex | MEDIUM | Partial-overlap; classical affine-reconstruction, value is the graph-vs-complex contrast. |

**Survive / soften / collapse call: the lane SURVIVES on its N1 headline and SOFTENS on its N2
headline.** The single strongest, cleanest, most defensible result is **N1 (Theorem 7.4)** — the
finite-field graph-permutation rigidity of the `M_{0,5}` four-map reduct. Its one plausible
"already known" objection (the classical `M_{0,n}` automorphism theorem) was read in full text and
provably points the other way: Bruno–Mella classify *biregular* automorphisms of the *variety* over
`C` by forgetful-map geometry and never constrain a set-permutation of `M_{0,5}(F_q)` preserving one
uncoloured adjacency. The novelty is exactly the intrinsic four-fibre recovery (Thms 4.2/5.1) that
lets an *arbitrary* graph automorphism be shown geometric. **N1 should be the paper's headline;**
lead with the four-map reduct, cite Bruno–Mella as the algebraic analogue it does *not* follow from,
and GPZ as adjacent cross-ratio-graph automorphism method.

**N2 must be re-framed, not led with.** "The continuation complex reconstructs the projective plane"
is a first-of-kind-sounding claim in a genre that has published complement/pseudo-complement
uniqueness theorems since 1979. It should be presented as the note's own §8.5 already prescribes —
as the *arc-specific chain* (secant-arrangement complement + degree-based arc recovery +
full-faithfulness on `(Π,K)`), a refinement in the Bruck–Metsch–Batten neighborhood, not a new
completion paradigm.

**The single decisive remaining gate — now RESOLVED against a kill (from abstracts), not yet
full-text-closed.** The gate was a **full-text read of the two paywalled `r=4`/engine pieces —
Drake–Sané *Embedding of finite pseudo-complements of quadrilaterals* and Metsch's uniqueness
chapter (LNM 1490 / Beutelspacher–Metsch) — for whether either reconstructs the deleted
configuration's distinguished points (the arc) from an arrangement complement.** No open copy of
either could be located this session (both paywalled: ScienceDirect and Springer both 403 to fetch;
the Metsch Google Books preview shows only the index term, no page text). **But the retrieved
abstracts + the exact parameter arithmetic answer the decisive question without the full text:**
Drake–Sané / Mullin–Vanstone delete a **quadrilateral = 4 lines** (the `n²−3n+3` point count is
`PG(2,n)` minus the four general lines) and prove a **unique embedding of a linear space** — they
restore *lines*, take no arc/secant-arrangement input, and perform **no degree-based recovery of a
distinguished point set**. The `k`-arc secant arrangement (`C(k,2)` lines, `k` points of
multiplicity `k−1`; **6** lines at `k=4`, not 4) and the arc-recovery step (8.4) have **no analogue
in the located genre**. So **N2's surviving increment does NOT collapse:** the kill (arc-point
recovery from an arrangement complement) is not exhibited. The lane keeps its N1 headline *and* the
narrow, un-killed N2 arc-chain. Residual diligence (does not change the verdict, only *closes* vs.
*resolves* the gate): a MathSciNet full-text read of Drake–Sané / Metsch + forward-citation sweep for
"complement of an arc / secant arrangement." Until then the N2 arc-chain is **plausible and
un-killed** — carry it with a `[VERIFY]` on the full text, not with a suspected collision. N1 is
clear now.

## House-keeping

- `[CHECKED]` (full text this session): Bruno–Mella arXiv:1006.0987 only.
- `[VERIFY]` (abstract/secondary only — paywalled or PDF-unparsed): GPZ (JLMS), Deza (JCTB),
  Naik–Rao–Shrikhande–Singhi (EJC), Batten (JAustMS), Mullin–Vanstone (Ann. NYAS), Drake–Sané (JSPI),
  Günaltılı–Olgun (J. Geom.), Beutelspacher–Metsch I/II (Discrete Math.), Metsch LNM 1490 (Springer),
  Bruck (Pacific J. Math.).
- **N2 gate update (2026-07-11 external pass 2):** the two decisive `r=4`/engine items (Drake–Sané,
  Metsch LNM 1490) still have **no locatable open full text** — searched Google/Google Scholar,
  ScienceDirect (403), Springer + Google Books preview (index term only, no page text), Semantic
  Scholar, ResearchGate (403), the ring-geometry history survey arXiv:2003.02881 (Hjelmslev-only,
  no embedding content), zbMATH (403). **But the decisive kill question is resolved from the
  abstracts/parameters:** Drake–Sané / Mullin–Vanstone delete a **quadrilateral (4 lines)** and prove
  a *unique linear-space embedding* (restore lines) — no arc, no secant arrangement, no degree-based
  distinguished-point recovery; Metsch is the general embedding engine, same category. **Kill NOT
  triggered; N2's arc-chain survives.** The gate is resolved-by-abstract, not full-text-closed.
- This remains a first external pass; a definitive MathSciNet/zbMATH forward-citation run (auth-gated)
  + full text of Drake–Sané/Metsch is the residual diligence to *close* (vs. resolve) the N2 gate.
</content>
</invoke>
