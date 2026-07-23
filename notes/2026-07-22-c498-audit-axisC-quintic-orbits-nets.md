# C498 literature audit — Axis C: orbit-classification toolkit for redundancy six

## Opening summary

**Full-text sources: 1** (arXiv:2605.04935, read in entirety from the cache). All other sources
below are read at **partial** (targeted sections of a cached full text) or **abstract/metadata only**
(WebFetch of the abstract, or search-result snippet); each carries its own READ-DEPTH field.

**One-line verdict:** No finished PGL_2(q)-orbit classification of binary *quintics* over F_q exists to
cite — the published toolkit gives only (a) the *characteristic-0 / algebraically-closed* invariant
theory and canonical forms of quintics, and (b) a *characteristic-free Waring-type / catalecticant-rank
stratification* over prime fields (Ishitsuka, arXiv:2605.04935); C498 must build the F_q-orbit
enumeration itself, and nothing in the deep-hole/MDS literature has yet applied quintic orbits or nets
of quartics to PRS, so there is a tool gap but no pre-emption.

Read-depth legend: **full text** = whole paper in context; **partial** = specific sections of a cached
full text; **abstract/metadata only** = abstract via WebFetch or a search snippet only.

---

## (C1) PGL_2(q)-orbits / invariant theory of binary QUINTIC forms over F_q

### The quartic template it must match (for contrast)

- **Kaipa, Patanker, Pradhan — "On the PGL_2(q)-orbits of lines of PG(3,q) and binary quartic forms",
  arXiv:2312.07118v3 (2023, rev. 9 Aug 2025), sha256 2ea8efc0…9752.** READ-DEPTH: **partial** —
  read Abstract, §1 (Introduction + Conjecture 1.1), §5.2 Lemma 5.3 (orbit table for the
  discriminant-zero locus F^0), §5.3 setup. This is the finished template: it gives a *complete*
  PGL_2(q)-orbit decomposition of binary quartics over F_q using two fundamental GL_2-invariants —
  the **apolar invariant** I(f) (weight 4, degree 2) and the **catalecticant** J(f) (weight 6,
  degree 3), with Δ = I³ − J². The Δ=0 stratum splits into the orbits G·X⁴, G·X³Y, G·X²Y²,
  G·(X²−εY²)², G·X²Y(Y−X), G·X²(X²−εY²) — i.e. the "O±"/nucleus strata that C491 named at
  redundancy 5. Does **not** treat quintics.
- **Kaipa, Pradhan — "…and binary quartic forms in characteristic three", arXiv:2508.11229 (2025).**
  READ-DEPTH: **abstract/metadata only** (WebFetch). The char-3 companion completing 2312.07118's
  one excluded characteristic (the "wild" quartic case). No quintics, no nets. Confirms the quartic
  program is only now char-complete — the analogous quintic program does not exist.

### Binary quintics: what actually exists

- **Ishitsuka — "Exponential sums over singular binary quintics", arXiv:2605.04935v1 (6 May 2026),
  sha256 428a5cec…03a0.** READ-DEPTH: **full text** (16 pp, entire cached extraction). This is the
  closest thing to a finite-field structural handle on binary quintics, and the single most
  load-bearing source for C498's C1 axis. Key facts, stated as the paper proves them:
  - It works over prime fields F_p in a **characteristic-free** way (an explicit char-2 Appendix).
  - It stratifies nonzero binary quintics w ∈ V_5 by **catalecticant rank** (rank(w) ∈ {1,2,3},
    Thm 2.1 via the Hankel/catalecticant matrices A_{s,t;r}) and by **Waring type** = the splitting
    type of the minimal apolar generator φ_{rank(w)}. For odd degree the apolar ideal is a complete
    intersection (Iarrobino–Kanev), so φ_{rank} is unique up to scalar and the Waring type is
    well-defined. The catalecticant covariant Cat_{2,2}(x,y:w) ∈ V_3* is the degree-3 apolar cubic;
    its vanishing detects rank < 3.
  - Explicit Waring-type list at r=6 syndrome level: ∅, ⟨1⟩, ⟨1²⟩, ⟨1,1⟩, ⟨2⟩, ⟨1³⟩, ⟨1²,1⟩,
    ⟨1,1,1⟩, ⟨2,1⟩, ⟨3⟩ (§2.4). This is a *coarse* PGL-invariant stratification — orbits within a
    Waring type (especially the rank-3 types ⟨1,1,1⟩, ⟨2,1⟩, ⟨3⟩) are **not** enumerated; the paper
    only needs a bounded count of apolar quadrics, not orbit representatives.
  - Structural warning it makes explicit (§1, citing Geyer and Grace–Young): the space of binary
    quintics is **not coregular** (unlike binary quartics, which are coregular but not
    prehomogeneous). This is the reason there is no clean quartic-style two-invariant orbit
    separation — it is a genuine obstruction C498 inherits, not an oversight in the literature.
  - Relevance/pre-emption: the *application* is number-theoretic (2-Selmer / discriminant counting),
    **not** coding theory. It supplies the catalecticant-rank + Waring-type toolkit but does not
    touch Reed–Solomon, MDS arcs, or deep holes. No pre-emption; strong tool.
  - Its bibliography is the citable classical spine for quintic invariant theory: Grace–Young
    *The Algebra of Invariants* (1903); Kung–Rota "The invariant theory of binary forms" Bull. AMS
    10 (1984); Iarrobino–Kanev *Power Sums, Gorenstein Algebras, and Determinantal Loci* (LNM 1723,
    1999); Geyer "Invarianten binärer Formen" (LNM 412, 1974). READ-DEPTH of these four: **secondary
    only** (seen as citations in 2605.04935, not independently consulted).

- **Chipalkatti — "On Hermite's invariant for binary quintics", arXiv:math/0610639 (2006).**
  READ-DEPTH: **abstract/metadata only** (WebFetch of abstract). Studies the **Hermite skew
  invariant** H (weight-18 invariant vanishing on quintics "in involution"): singular locus,
  self-duality under an involution, perfect height-two Jacobian ideal, evectant formalism.
  Explicitly **characteristic 0 only** — no finite fields, no PGL_2(q) orbits. Confirms the classical
  quintic invariant ring is generated by invariants of degrees 4, 8, 12, 18 (Hermite), but as
  char-0 geometry.

- **Olive / "Invariants of Binary Forms", arXiv:1209.0446.** READ-DEPTH: **abstract/metadata only**
  (WebFetch). Generating invariants of binary forms with a method valid in **characteristic p > 5**
  (Hilbert in char 0; Mumford/Haboush in positive char), over **algebraically closed** fields — not
  finite fields, and orbit representatives/canonical forms are not the deliverable. Confirms the
  ring-of-invariants side extends to large char but stops short of an F_q orbit census.

- **Canonical form of square-free binary quintics** (search snippet, WebSearch): every non-zero
  square-free binary quintic is GL(2,K̄)-equivalent to z₁⁵+s z₁⁴z₂+t z₁³z₂²+z₂⁵ or to
  z₁⁴z₂+t z₁³z₂²+z₂⁵, with GL(2,K̄)-equivalence decided by absolute Clebsch invariants. READ-DEPTH:
  **abstract/metadata only** (search-result text; the exact source paper was not opened — *my
  inference* is that this is from the Isaev/Kruglikov classical-invariant-theory-of-singularities
  circle, arXiv:1106.2602 / 1110.2559, unconfirmed). This is a K̄ (geometric) canonical form, not an
  F_q-rational orbit classification: the arithmetic (which K̄-orbit representatives are F_q-rational,
  and how each geometric orbit splits into F_q-orbits) is exactly what is missing.

- **Tropical / arithmetic quintic invariants:** "Tropical invariants for binary quintics and
  reduction types of Picard curves", arXiv:2206.00420; Bhargava–Gross "Arithmetic invariant theory",
  arXiv:1206.4774. READ-DEPTH: **abstract/metadata only** (search snippets). Igusa extended
  Clebsch–Bolza invariants of binary forms of degree ≤ 6 to algebraically closed fields of any
  characteristic; quintic invariants give Picard-curve reduction types away from residue char 3.
  Arithmetic invariant theory (Bhargava–Gross) is the framework for counting rational orbits of
  binary forms but is developed over Z / local fields, not as an F_q orbit census for quintics.

**C1 conclusion.** There is (i) a complete char-0 / K̄ invariant theory and canonical form for
quintics, and (ii) a characteristic-free catalecticant-rank + Waring-type *stratification* over F_p
(Ishitsuka). There is **no** paper that enumerates PGL_2(q)-orbit representatives and sizes of binary
quintics over F_q the way arXiv:2312.07118 does for quartics. The non-coregularity of the quintic
space is a cited, genuine reason the quartic method does not transfer verbatim.

---

## (C2) NETS and WEBS of binary QUARTICS (and the classical net/pencil theory)

The r=6 Hankel kernel is a **net** (2-dim linear system) of binary quartics. No source treats *nets of
binary quartics* as a classified object; the citable neighbours are nets of quadrics/conics and
pencils of binary quartics.

- **Wall — "Singularities of nets of quadrics", Compositio Math. 42 (1980) 187–212** (numdam).
  READ-DEPTH: **abstract/metadata only** (search result + numdam listing; not opened). The classical
  reference for **nets of quadrics**: singularity/degeneracy stratification of a 2-dimensional linear
  system of quadrics. This is the structural template for "exceptional nets classified by degenerate
  strata," but it is over C/general fields and concerns quadrics, not quartics.

- **Nets of conics over finite fields (the closest finite-field net theory):**
  - Lavrauw–Popiel–Sheekey, "Combinatorial invariants for nets of conics in PG(2,q)",
    arXiv:2010.00177.
  - "Nets of conics of rank one in PG(2,q), q odd", arXiv:2003.06275.
  - "Nets of conics containing a double line in PG(2,q), q even", arXiv:2509.03840.
  - "Webs and squabs of conics over finite fields", arXiv:2405.10710 (Adv./FFA).
  READ-DEPTH for all four: **abstract/metadata only** (search snippets). These classify pencils
  (1-dim), **nets (2-dim), webs (3-dim), squabs (4-dim)** of *conics* in PG(2,q) into PGL(3,q)-orbits
  via the Veronesean in PG(5,q) and combinatorial (orbit-distribution) invariants. They establish the
  vocabulary (pencil/net/web/squab) and the method (lift to orbits of subspaces meeting a Veronese
  variety, use orbit-distribution as a complete invariant for rank-one nets over odd q) that a net-of-
  quartics classification would imitate — but the ambient Veronesean is the quartic (degree-4) rational
  normal curve C_4 ⊂ PG(4,q), not the conic Veronesean, so these are analogues, not the object itself.

- **Pencils of binary quartics / pencils of quadrics:** Wood and others, "Pencils of quadrics, binary
  forms and hyperelliptic curves" (research-gate listing); quartic del Pezzo = complete intersection
  of two quadrics in P^4. READ-DEPTH: **abstract/metadata only** (search snippets). A *pencil* (1-dim)
  of binary quartics carries genus-1 / hyperelliptic and del Pezzo structure and is well studied
  arithmetically; the step up to a *net* of quartics is not a classified object in what was found.

**C2 conclusion.** Nets/webs are a classified object **for conics over F_q** (Lavrauw et al.) and
nets of **quadrics** over general fields (Wall); there is **no** classification of nets of binary
*quartics*. The exceptional-net strata C498 expects ("higher analogues of O±/nucleus/wild") would be
new, built by analogy to (a) the quartic Δ=0 orbits of 2312.07118 and (b) the conic-net method of
Lavrauw–Popiel–Sheekey.

---

## NRC nuclei / the degree-5 normal rational curve

- **Gmainer, Havlicek — "Nuclei of Normal Rational Curves", arXiv:1304.0088 (2013), sha256
  da688c01…26d0.** READ-DEPTH: **partial** — read Abstract, §1 (Introduction), §2 setup (Lucas'
  theorem, base-p digit apparatus). What it proves: for a normal rational curve of degree n in
  PG(n,F), a **k-nucleus** is the intersection of all k-dimensional osculating subspaces; in
  characteristic 0 all nuclei are empty, while in characteristic p>0 (with #F ≥ n) the **number of
  distinct nuclei equals the number of nonzero digits of n+1 in base p**, and an explicit dimension
  formula (via Pascal's triangle mod p / Lucas–Kummer) is given for #F ≥ k+1. This generalizes the
  even-characteristic conic nucleus (n=2, p=2) to all NRCs.
  - Degree-5 specialization (n=5, so n+1=6; *my computation* from the paper's rule): nonzero base-p
    digits of 6 are — base 3: 6=(20)_3 → **one** nucleus; base 2: 6=(110)_2 → two; base 5: 6=(11)_5
    → two. The characteristic where the degree-5 NRC acquires its single distinctive (non-hyperplane)
    nucleus is **char 3** — matching the "wild = char-3 Artin–Schreier family" the C498 task expects
    at the quintic/net level. This ties the char-3 quintic exceptional stratum to a concrete,
    citable nucleus computation.

- **Related cached items (not central):** arXiv:2607.12761 "Cyclic Projective Orbits on Rational
  Normal Curves and MDS Codes" (READ-DEPTH: **metadata only** — cache entry title/authors, Li–Yuan
  2026); potentially relevant to orbit sizes on C_5 but not opened here.

---

## Citable toolkit vs pre-emption

**Citable toolkit (tools to build on, no priority conflict):**
- arXiv:2312.07118 (+ 2508.11229 char-3) — the quartic F_q-orbit method to imitate.
- arXiv:2605.04935 — catalecticant-rank + Waring-type stratification of binary quintics,
  characteristic-free including char 2; the apolar/Hankel machinery.
- math/0610639, 1209.0446, Grace–Young, Kung–Rota, Iarrobino–Kanev, Geyer — classical quintic
  invariant theory and apolarity (char-0 / K̄ / large-char).
- Wall (1980) + Lavrauw–Popiel–Sheekey et al. (conic nets/webs over F_q) — the net/web classification
  *method*.
- arXiv:1304.0088 — NRC nuclei, giving the degree-5/char-3 nucleus explicitly.

**Pre-emption (someone already did C498's job):** none found. The quintic exp-sums paper is number
theory (2-Selmer), not codes. The PRS/MDS deep-hole literature reaches only lower redundancy and does
not use binary quintic orbits or nets of quartics:
- Zhang–Wan–Kaipa, "Deep Holes of Projective Reed-Solomon Codes", arXiv:1901.05445 (2019), sha256
  5c2b9e25…caf24. READ-DEPTH: **partial** (grepped/read §I–II scope). Classifies deep holes and
  covering radius of PRS(k) fully for **redundancy 3 and 4** (three explicit classes classify all
  redundancy-4 deep holes), states the covering-radius conjecture for 2≤k≤q−2, and uses PGL_2(F_q)
  orbits of deep-hole classes — but stops at redundancy 4 and does not invoke binary-quartic or
  -quintic form orbit classification.
- arXiv:1612.05447 (Deep holes & MDS extensions), arXiv:2312.05534 (Extended codes & deep holes of
  MDS codes), 10.1051/wujns/2023281015 (even-char PRS deep holes), arXiv:2509.08526 (twisted RS).
  READ-DEPTH: **metadata only** (cache titles). None reaches redundancy 6 via binary-form orbits.

---

## Coverage statement

- **Cache (litcache):** queried in full; read from it — 2605.04935 (**full text**), 2312.07118,
  1304.0088, 1901.05445 (**partial**).
- **arXiv abstracts via WebFetch:** 2508.11229, math/0610639, 1209.0446 (**abstract/metadata only**);
  1304.0088/2312.07118 abstracts corroborated against the cached full texts.
- **WebSearch:** ran on binary-quintic orbit classification, nets/webs of quartics and conics, PRS
  deep-hole covering radius, Igusa/arithmetic quintic invariants, pencils/nets of quartics.
- **zbMATH Open:** **COULD NOT ACCESS from this harness** — front-end returned HTTP 403 (bot block)
  and the API (/v1/document/_structured_search) returned HTTP 400/404 for every parameter form tried.
  This is an access failure, not a "found nothing." No zbMATH review number is cited below because
  none was retrievable.
- **MathSciNet:** **NOT COVERED** (not reachable / not attempted from this environment).
- **Found-nothing (searched, genuinely absent):** no paper enumerating PGL_2(q)-orbit representatives
  and sizes of binary *quintics* over F_q; no classification of *nets of binary quartics*; no
  application of quintic orbits or quartic nets to PRS/MDS deep holes. Search domain: arXiv +
  WebSearch (US) + the litcache; stop condition: repeated queries returned only the quartic program,
  the char-0/K̄ quintic invariant theory, the Ishitsuka stratification, and conic-net (not
  quartic-net) work.

---

## **VERDICT**

**No PGL_2(q)-orbit classification of binary quintics over F_q exists to cite — C498 must build it.**
The citable inputs are (a) the quartic F_q-orbit template arXiv:2312.07118 (+ char-3 companion
2508.11229), (b) the characteristic-free catalecticant-rank / Waring-type stratification of binary
quintics in arXiv:2605.04935 (which also flags the quintic space as *not coregular* — the structural
reason the quartic two-invariant method does not transfer), (c) the classical quintic invariant theory
(Hermite/Clebsch/Grace–Young/Kung–Rota, char-0 & K̄), and (d) the NRC-nucleus computation
arXiv:1304.0088 pinning the degree-5 nucleus to char 3. **Nets of binary quartics are likewise
unclassified**; only nets of conics over F_q (Lavrauw et al.) and nets of quadrics (Wall 1980) exist
as method-templates. **No pre-emption:** nothing in the deep-hole/MDS literature (which reaches only
redundancy ≤4) has applied binary quintic orbits or nets of quartics to projective Reed–Solomon deep
holes. The toolkit is partial and must be assembled; the crown is open.
