# C122 — Deep-hole novelty audit for the icosahedral `[6,3,4]₁₁` MDS code

`[REPORTED 2026-07-13]`

Literature audit for the spin-off lane
[icosahedral MDS deep-holes handoff](handoffs/2026-07-13-icosahedral-mds-deep-holes.md).
Five novelty questions, each with closest prior work and a verdict
(**NOVEL / PARTIALLY KNOWN / KNOWN**). Web-verified 2026-07-13; abstracts and (where
noted) full texts checked.

## Q1. Deep holes of non-GRS MDS codes — any prior exact determination?

**Verdict: PARTIALLY KNOWN — "first for a non-GRS MDS code" is NOT claimable.**

Closest prior work:

- **Wu, Ding, Chen**, *Covering radii and deep holes of two classes of extended twisted
  GRS codes and their applications*, IEEE Trans. Inf. Theory **71**(5), 3516–3530 (2025)
  ([IEEE 10884922](https://ieeexplore.ieee.org/document/10884922/)). Explicitly obtains
  "classes of **non-GRS MDS codes with known covering radii and deep holes**" — complete
  determinations for ETGRS families. This directly overlaps the "first non-GRS
  deep-hole determination" framing.
- **Deep holes of twisted Reed–Solomon codes** (ISIT 2024 + journal version,
  [arXiv:2403.11436](https://arxiv.org/abs/2403.11436)) — deep holes of TRS codes, most
  of which are non-GRS MDS.
- **Li, Lu, Ling, Lam**, *A framework for constructing non-GRS MDS–NMDS codes from deep
  holes* ([arXiv:2605.12133](https://arxiv.org/abs/2605.12133), 2026) — systematizes the
  deep-hole → extended-code pipeline for non-GRS MDS codes; cites Ma–Kai–Zhu (FFA 2026)
  as further non-GRS deep-hole work. The area is **active right now**.
- **Davydov, Marcugini, Pambianco**, *On the weight distribution of the cosets of MDS
  codes* ([arXiv:2101.12722](https://arxiv.org/abs/2101.12722), 2021; full text checked).
  Their Theorem 6.3 gives, for **any** `[n,n−3,4]_q` MDS code (GRS or not), the complete
  coset weight distribution from the arc's secant data `(c_i)`, including the weight-3
  (deep-hole) cosets: covering radius 3 ⇔ arc incomplete, `(q−1)c₀` deep-hole cosets
  where `c₀` = points of PG(2,q) on **no bisecant** of the arc.

"Deep holes = rational points of a variety" as an explicit framing: **not found anywhere**.
The nearest analogues are Kaipa's / Wu–Ding–Chen's "deep hole ⇔ MDS extension" dictionary
(Q5) and DMP's `c₀`-point description, neither of which identifies the deep-hole set with
a named variety. That identification (here: a conic; conjecturally the dual variety of the
RNC) is the new content.

## Q2. Small MDS codes with 2-transitive (A₅) permutation automorphism groups

**Verdict: PARTIALLY KNOWN — 2-transitivity per se is not new; the odd-q non-GRS instance is.**

- **The hexacode `[6,3,4]₄`** is a direct precedent: its **permutation automorphism group
  is exactly A₅ acting 2-transitively on the 6 coordinates** (full monomial group 3.A₆,
  3.S₆ with Galois); its 6 columns are a **hyperoval in PG(2,4)**, hence a non-classical
  MDS code. See the [Error Correction Zoo hexacode entry](https://errorcorrectionzoo.org/c/hexacode)
  and [Wikipedia: Hexacode](https://en.wikipedia.org/wiki/Hexacode). So "a `[6,3,4]` MDS
  code with PAut = 2-transitive A₅" **already exists in the literature at q=4**. Our
  headline must be scoped: q **odd**, prime field, arc off **every** conic (hyperovals
  need even q), deep holes a conic.
- Extended/doubly-extended RS codes have **3-transitive** PΓL(2,q) automorphisms
  (Dür, *The automorphism groups of Reed–Solomon codes*, J. Combin. Theory Ser. A 44
  (1987)); so large-transitivity MDS automorphism groups are classical for GRS.
- No prior appearance of this exact `[6,3,4]₁₁` code found in the deep-hole or MDS-code
  literature. But see Q3 — the underlying arc may be catalogued in finite geometry.

## Q3. The 6-arc in PG(2,11) from icosahedral axis poles

**Verdict: PARTIALLY KNOWN — A₅-invariant arcs are a studied genre; the pole-of-axes /
deep-hole-conic observation not found, but two must-read papers could contain the arc itself.**

- **O'Keefe, Storme**, *Arcs fixed by A₅ and A₆*, J. Geom. **55**, 123–138 (1996) —
  exactly the genre "arcs invariant under A₅ in PG(2,q)". **Must be obtained and checked
  before claiming the arc is new**; a 6-point A₅-orbit arc is plausibly listed there.
- *Primitive arcs in PG(2,q)*, J. Combin. Theory Ser. A (1995)
  ([ScienceDirect](https://www.sciencedirect.com/science/article/pii/0097316595900519)) —
  classifies arcs with a stabilizer primitive on the arc; A₅ on 6 points is primitive, so
  our arc falls in this classification's scope. **Second must-check.**
- **Pace**, *On small complete arcs and transitive A₅-invariant arcs in PG(2,q)*,
  J. Combin. Des. **22**, 425–434 (2014): for q a power of 5 or q ≡ ±1 (mod 10), PG(2,q)
  admits A₅ and transitive A₅-invariant **30-arcs** exist — the same A₅ ⊂ PGL(3,q) orbit
  lattice (6, 10, 15, 30, 60), with attention on the 30-orbit, not the 6-orbit.
- Related genre: **Giulietti, Korchmáros, Marcugini, Pambianco**, *Transitive
  A₆-invariant k-arcs in PG(2,q)* ([arXiv:1108.0358](https://arxiv.org/abs/1108.0358),
  DCC 2013; full text checked — surveys invariant-arc literature, subgroup existence via
  Mitchell's 1911 classification of subgroups of PGL(3,q)); **Indaco, Korchmáros**,
  *42-arcs in PG(2,q) left invariant by PSL(2,7)* (DCC 2011).
- The A₅-on-12-conic-points icosahedral action (A₅ ⊂ PGL(2,11)) and the six-diameters
  realization of the exotic S₆ embedding are classical folklore (Klein; see e.g.
  [Baez, "Some thoughts on the number six"](https://math.ucr.edu/home/baez/six.html)).
  What is **not found in print**: "the six poles of the icosahedral axes form a 6-arc off
  every conic, and this arc's uncovered points are exactly the conic".

## Q4. Covering radius / coset geometry of MDS codes via arcs and conics

**Verdict: KNOWN framework, new instance.**

- The dictionary is fully published: complete arc ⇔ covering radius 2, incomplete ⇔ 3;
  deep-hole syndromes = points on **no bisecant** of the arc; coset weight distributions
  from the secant spectrum `(c_i)` — **Davydov–Marcugini–Pambianco 2021**
  ([arXiv:2101.12722](https://arxiv.org/abs/2101.12722)), Definition 6.1 + Theorem 6.3,
  building on the classical complete-arc/saturating-set literature (Hirschfeld, *PGOFF*;
  Davydov et al. covering-code tables, e.g. [arXiv:1712.07078](https://arxiv.org/pdf/1712.07078)).
- **Direct consequences for our "verified facts"** (see contradiction flags below): the
  uniform `C(6,3)=20` leader tie, the count `120=(q−1)c₀`, and the leader-count/secant-
  spectrum tie are all **instances of DMP Theorem 6.3**, valid for every `[n,n−3,4]_q R=3`
  MDS code. They are correct but must be cited as known machinery, not new results.
- DMP even compute the conic (`R=2` odd q, `R=3` even q with the nucleus as the unique
  `c₀`-point — a one-point deep-hole locus) and shortened-conic cases. What they never
  exhibit: an arc whose `c₀`-set is itself **a whole conic's worth of rational points**,
  nor any non-GRS odd-q example, nor a group-theoretic explanation.

## Q5. Dual-variety / discriminant framing of deep holes

**Verdict: NOVEL as a framing/conjecture; adjacent geometric interpretations exist.**

- **Zhang, Wan, Kaipa**, *Deep holes of projective Reed–Solomon codes*
  ([arXiv:1901.05445](https://arxiv.org/abs/1901.05445); IEEE TIT 2020): deep-hole
  classes of PRS codes with a geometric interpretation via **tangent lines to the degree
  (q−k) rational normal curve** (incl. over a quadratic extension); complete for
  redundancy ≤ 4. This is the closest published contact between deep holes and
  RNC tangency geometry — dual-variety-adjacent but never stated as "deep holes =
  F_q-points of the dual variety".
- **Kaipa**, *Deep holes and MDS extensions of Reed–Solomon codes*, IEEE TIT 2017, and
  **Wu, Ding, Chen**, *Extended codes and deep holes of MDS codes*
  ([arXiv:2312.05534](https://arxiv.org/abs/2312.05534), 2023): for a general MDS `[n,k]`
  code, the extension by u is MDS iff ρ(C^⊥)=k and u is a deep hole of C^⊥ — i.e. "deep
  holes ⇔ arc-extension points", the algebraic twin of DMP's `c₀`-points. Algebraic, no
  variety identification.
- No paper found connecting deep holes to **projective duality / discriminants / the
  tangent developable of the twisted cubic**. The R3 conjecture (k=4 → tangent-developable
  quartic) appears to be genuinely unformulated in the literature.

## Contradiction / correction flags for the handoff

1. **"First exact complete deep-hole determination of a non-GRS MDS code" — drop.**
   Wu–Ding–Chen (TIT 2025) and the TRS line (2024–26) already do this for infinite
   non-GRS MDS families. Re-scope to the variety identification + symmetry.
2. **Uniform 20-way tie is not a special property** of this code: DMP 2021 Thm 6.3(iii)
   forces `B₃ = C(n,3)` leaders in every weight-3 coset of any `[n,n−3,4]_q` MDS code.
   Same for `120 = (q−1)c₀` and the distance-2 leader/secant-spectrum split (their
   Thm 6.3(ii)). Keep them as verified instantiations, cite DMP.
3. **"Generic MDS: trivial permutation aut group" as the contrast for R1** needs hedging:
   extended GRS have 3-transitive PΓL(2,q) (Dür 1987), and the **hexacode** is a
   `[6,3,4]` MDS code with PAut = 2-transitive A₅ on 6 coordinates. Headline the
   odd-characteristic / off-every-conic / conic-polarity-realizes-the-outer-automorphism
   angle, not bare 2-transitivity.
4. **Arc novelty is unverified** until O'Keefe–Storme 1996 and *Primitive arcs in
   PG(2,q)* (JCTA 1995) are checked — both are exactly the drawers this arc would be
   filed in. Neither was retrievable online during this audit (paywalled).

## Bottom line

**Safe to headline as new** (nothing found in the literature):

- **Deep holes = the rational points of a conic** — the first identification of the full
  deep-hole set of an MDS code with the F_q-points of a (named, positive-dimensional)
  variety, with a group-theoretic cause (poles of the six icosahedral axes of
  A₅ ⊂ PGL(2,11) on the deep-hole conic). This is the strongest claim.
- The **dual-variety conjecture** (deep holes of non-GRS `[n,k]` MDS ↔ dual variety of
  the RNC; k=4 tangent-developable test) — unformulated anywhere; Zhang–Wan–Kaipa's
  tangent-line interpretation is the only adjacent result and should be cited as the
  precursor.
- The **synthesis**: icosahedral-orbit construction principle (group orbit → prescribed
  deep-hole variety), and the conic-polarity realization of the exotic S₆ hexad action on
  a q=11 code.

**Needs hedging / citation**: any "first non-GRS deep-hole determination" phrasing
(Wu–Ding–Chen 2025); coset-distribution facts (DMP 2021); 2-transitive MDS automorphism
groups (hexacode, Dür); A₅-invariant arcs as a genre (O'Keefe–Storme 1996, Pace 2014).

**Blocking checks before submission**: obtain O'Keefe–Storme (J. Geom. 1996) and
*Primitive arcs in PG(2,q)* (JCTA 1995); if the 6-arc appears there, the finite-geometry
half of the paper becomes "known arc, new coding-theoretic/deep-hole structure", which is
still publishable but changes the framing.
