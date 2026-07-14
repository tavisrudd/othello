[REPORTED 2026-07-13]

# C127 — Novelty audit: the Klein mod-11 reduction, the arc, and the mod-p Platonic family

Literature calibration for
[`handoffs/2026-07-13-clebsch-paper.md`](handoffs/2026-07-13-clebsch-paper.md)
(FUSED FRAMING) and [`2026-07-13-c125-klein-resolvent.md`](2026-07-13-c125-klein-resolvent.md).
Builds on C122 ([`2026-07-13-c122-deep-hole-novelty-audit.md`](2026-07-13-c122-deep-hole-novelty-audit.md));
web-verified 2026-07-13. Full texts read: Storme–Van Maldeghem JCTA 1995
([open PDF](https://cage.ugent.be/~hvm/artikels/41.pdf)), Elkies *The Klein Quartic in Number
Theory* ([open PDF](https://library.slmath.org/books/Book35/files/elkies.pdf)), Ji
arXiv:2304.03345, Hitchin arXiv:0706.0088, Jones–Zvonkin arXiv:2104.12015 (grepped).

## Claim group 1 — the Klein reduction itself. Verdict: PARTIALLY KNOWN (skeleton classical, form-level reduction not found)

Sub-claim verdicts:

- **A₅ ⊂ PSL(2,11) as "the icosahedral group over F₁₁" — KNOWN, thoroughly classical.**
  Galois's last letter (1832; the three exceptional actions p = 5, 7, 11); Klein's 1879
  *Transformation elfter Ordnung* — Jones–Zvonkin
  ([arXiv:2104.12015](https://arxiv.org/abs/2104.12015)) state explicitly that "the starting
  point for Klein's work ... was the embedding of the icosahedral group A₅ in PSL₂(11)";
  Dickson, *Linear Groups* (1901) §§255–260 (two PSL-classes, fused in PGL); Kostant, PNAS 91
  (1994) 11714–11717 and [Notices AMS 42 (1995) 959–968](https://www.ams.org/notices/199509/kostant.pdf)
  (buckyball; but via the **degree-11** coset action, not our degree-12 vertex action);
  Martin–Singerman, *From biplanes to the Klein quartic and the buckyball*
  ([preprint 2008](http://www.neverendingbooks.org/DATA/biplanesingerman.pdf)) / *The geometry
  behind Galois' final theorem*, European J. Combin. 33 (2012). The transitive A₅ action on the
  12 points of P¹(F₁₁) with stabilizer C₅ is folklore within this circle (degree-12 dessins with
  group PSL₂(11) are treated in Jones–Zvonkin).
- **Correction to the handoff's suspect list:** no Adler paper titled *"The icosahedron and
  PSL₂(11)"* exists as far as this audit can determine. Adler's PSL(2,11) corpus is: *On the
  automorphism group of a certain cubic threefold* (Amer. J. Math. 100, 1978), *Invariants of
  PSL₂(F₁₁) acting on C⁵* (Comm. Algebra 20, 1992), *Modular correspondences on X(11)* (Proc.
  Edinb. Math. Soc. 35, 1992), *The Mathieu group M₁₁ and the modular curve X(11)* (Proc. LMS
  74, 1997) — all about the degree-11 / 5-dimensional representation and X(11), none about
  reducing the icosahedral binary forms mod 11. Remove the phantom title.
- **Reduction of Klein's literal invariant forms and group mod 𝔭 | 11** (vertex form f ↦
  z₁z₂(z₁¹⁰ − z₂¹⁰) vanishing on all of P¹(F₁₁); explicit conjugation to the arc stabilizer;
  H, T squarefree with no rational roots) — **NOT FOUND in print; NOVEL as an executed
  statement**, with two mandatory framings:
  1. *Genre precedent:* Elkies, *The Klein Quartic in Number Theory* (in The Eightfold Way,
     MSRI Publ. 35, 1999), §3.3 does exactly this program for the PSL(2,7) quartic at the primes
     2, 3, 7 dividing |G| — invariant degeneration Φ₄ ≡ Φ₂² mod 7, orbit collapses (56- and
     84-point orbits → the 14 F₄-points mod 2; 56+84 → 28 F₉-points mod 3), extremal point
     counts, and (citing Adler 1997) X(11) mod 3 acquiring M₁₁. Our mod-11 icosahedron is the
     P¹/A₅ sibling of this established genre — cite it as the model, claim the icosahedral
     instance.
  2. *Caveat B is classical machinery:* f mod 11 = xy(x¹⁰ − y¹⁰) is the standard degree-(q+1)
     invariant of modular invariant theory (Dickson, 1911; the form vanishing on all rational
     points, invariant under all of PGL₂(F_q)). Say "Klein's vertex form collapses to the
     Dickson–Euler form" and cite Dickson; the *observation that Klein's coefficient 11 dies mod
     11 and causes the collapse* is ours.
- **"p = 11 is the unique prime with p+1 = 12, so the vertices exhaust P¹(F_p)" — NOT FOUND
  stated anywhere**; claim as an observation (it is one line of arithmetic), not a theorem.
  Note it is *different from* Grothendieck's singular-characteristics phenomenon for the
  icosahedron, which picks characteristics **2 and 5** (Esquisse §4; see group 4) — worth one
  sentence distinguishing the two.
- **Syzygy H³ + T² = f⁵ via 1728 ≡ 1 (mod 11) — NOT FOUND**; trivial but unclaimed; keep as a
  remark, not a headline.

## Claim group 2 — the coding/deep-hole reading. Verdict: NOVEL (C122 confirmed, re-checked)

No paper connects this arc/hexagon (or any A₅-invariant object) to covering radius, deep holes,
or MDS codes. A 2026-07-13 refresh of the deep-hole literature (Roth–Lempel codes DCC 2025;
extended TGRS [arXiv:2604.05682](https://arxiv.org/abs/2604.05682); Cauchy codes AIMS Math 2025)
finds the field still entirely algebraic — no variety identification, no group-orbit
construction. C122's verdicts stand unchanged, including the hedges (Wu–Ding–Chen TIT 2025 kills
"first non-GRS determination"; DMP 2021 owns the coset machinery). **One residual risk:** Dye
1991 (below) analyzes the hexagon's bisecant geometry (Brianchon points = points on exactly 3
bisecants); his paper is paywalled and *could* also describe the points on **no** bisecant (= our
deep holes) as the invariant conic. Obtain Dye before final wording; the coding-theoretic
covering-radius reading would still be ours, but the geometric sentence "the 0-bisecant points
are the conic" may exist there.

## Claim group 3 — the arc. Verdict: KNOWN (settled; O'Keefe–Storme no longer blocking)

**The arc is in print, with coordinates, uniqueness, and the q=11 incompleteness.**
Storme–Van Maldeghem, *Primitive arcs in PG(2,q)*, J. Combin. Theory Ser. A 71 (1995) 175–190
(full text read, [open copy](https://cage.ugent.be/~hvm/artikels/41.pdf)):

- **Prop. 11:** explicit A₅-invariant 6-arc K₂ = {(1,0,±(1−2t)), (1,±2t,0), (0,1,±2t)} and
  10-arc K₁ in PG(2,q), q ≡ ±1 (mod 10); K₁ = the 10 points on exactly 3 bisecants of K₂.
- **Prop. 12:** K₂ and K₁ are **projectively unique** (unique A₅-orbits of sizes 6, 10). Our
  arc, having stabilizer exactly A₅ (C121), is projectively equivalent to their K₂ at q = 11.
- **Remark 2:** this hexagon is the **Clebsch hexagon**, "studied in detail" by **R. H. Dye,
  *Hexagons, conics, A₅ and PSL₂(K)*, J. London Math. Soc. (2) 44 (1991) 270–286**; it is *not
  contained in a conic* when q ≡ ±1 (mod 10); it has exactly 10 Brianchon points; its 5
  triangles are self-polar w.r.t. a **unique conic C** (= the A₅-invariant conic = our deep-hole
  conic).
- **Prop. 13 (+ computer check):** among complete 2-transitive arcs the 6-arc is complete only
  in PG(2,9); i.e. **they already knew the 6-arc is incomplete at q = 11** (our covering radius
  3 in arc language). The A₅-invariant **10-arc in PG(2,11) is complete** — also known.
- Characteristic-0 ancestor: the six icosahedral axes as 6 points of P² in general position
  lying on **no conic** is the classical construction of the **Clebsch diagonal cubic** (blow-up
  of P² at these 6 points; Clebsch 1871/Klein 1873); the exact off-every-conic argument appears
  verbatim in Hitchin, *Spherical harmonics and the icosahedron*
  ([arXiv:0706.0088](https://arxiv.org/abs/0706.0088), §2).

**O'Keefe–Storme, *Arcs fixed by A₅ and A₆*, J. Geom. 55 (1996) 123–138: not obtainable**
(Springer paywall; no repository, preprint, or citing description with content found beyond
bibliographic listings). Disposition: **no longer a blocking check** — SVM 1995 + Dye 1991
already settle existence, uniqueness, the conic, and q=11 incompleteness, so the "is the arc
new?" question is answered (no) without it. Still obtain it before submission for citation
completeness (it presumably extends the classification/completeness spectrum to other
A₅/A₆-invariant arcs, cf. Pace, J. Combin. Des. 22 (2014) on A₅-invariant 30-arcs).

**Required reframings:** call the arc by its name (the Clebsch hexagon in PG(2,11)); claim "a
new coding-theoretic/deep-hole reading of a known arc," never "a new arc." The (900,150,100)
leader split's 100 = 10×10 tie is the **10 Brianchon points** of Dye/SVM ×(q−1) scalars — cite
them for that structure. Dye's "5 self-polar triangles" is prior art adjacent to the C124
five-triangles/chirality discussion — check Dye before claiming any five-triangle statement as
new.

## Claim group 4 — the mod-p Platonic family. Verdict: PARTIALLY KNOWN skeleton, NOVEL as a coding construction

- **"Platonic solids over finite fields" is a Grothendieck program**: Esquisse d'un Programme §4
  (1984); interpreted and computed in C. Ji, *A note on regular polyhedra over finite fields*
  ([arXiv:2304.03345](https://arxiv.org/abs/2304.03345)): the icosahedron reduced mod p (p ≠ 2,5)
  remains an icosahedron with automorphism group A₅. Grothendieck's "most singular
  characteristics" for the icosahedron are **2 and 5** — his phenomenon lives at the ramified
  primes, ours at p+1 = vertex count; distinct, but his framework must be cited.
- **Group membership is Dickson**: A₅ ⊂ PSL(2,p) iff p ≡ ±1 (mod 5) or p = 5 (the "√5-primes"
  criterion for Family B); A₄, S₄ likewise classical (Dickson 1901). KNOWN.
- **Klein himself did the p = 5 member**: the six diagonals of the icosahedron labeled by
  P¹(F₅) with A₅ ≅ PSL(2,5) (*Lectures*, I.1 §8) — the ur-example of "solid orbit = projective
  line." KNOWN.
- **The assembled family** — vertex-count = p+1 ⇒ the solid's vertex orbit exhausts P¹(F_p)
  (octahedron/5, cube/7, icosahedron/11, dodecahedron/19), axis-pole arcs, deep holes = conic —
  **NOT FOUND anywhere as a construction or observation**, in either the dessins/Esquisse
  lineage or the finite-geometry invariant-arc lineage (SVM 1995; O'Keefe–Storme 1996;
  Giulietti–Korchmáros–Marcugini–Pambianco DCC 2013; transitive PSL(2,11)-invariant arcs in
  PG(4,q), [arXiv:1804.09707](https://arxiv.org/abs/1804.09707)). NOVEL as a family, provided
  each ingredient is cited to its classical source.

## BOTTOM LINE

**Single most defensible genuinely-new headline:** *the complete deep-hole set of the [6,3,4]₁₁
MDS code built on the Clebsch hexagon in PG(2,11) is the full point set of the A₅-invariant
conic — the first identification of an MDS code's deep holes with the rational points of a named
variety — and this is the mod-11 shadow of Klein's icosahedron: his vertex form collapses to the
Dickson form vanishing on all of P¹(F₁₁) at the unique prime with p+1 = 12, his six diagonals
reduce to the six chords whose poles are the arc.* (Plus the dual-variety conjecture as the
forward half — still unformulated anywhere, per C122 + this refresh.)

**Must be hedged/cited, not claimed new:**

- A₅ ⊂ PSL(2,11) and all "icosahedral group over F₁₁" group theory (Galois; Klein 1879; Dickson
  1901; Kostant 1994/95; Martin–Singerman 2012).
- The 6-arc itself, its uniqueness, the invariant conic, the 10 Brianchon points, q=11
  incompleteness (Dye 1991; Storme–Van Maldeghem JCTA 1995), and the char-0 six-axes/no-conic
  configuration (Clebsch cubic; Hitchin 2007).
- The reduce-Klein's-objects-mod-exceptional-primes genre (Elkies 1999 §3.3 for PSL(2,7); Adler
  1997 for X(11) mod 3).
- f mod 11 gaining full PGL₂-invariance = the classical Dickson invariant (Dickson 1911).
- Platonic-solids-over-F_p as a concept (Grothendieck Esquisse §4; Ji 2023).
- All C122 hedges (Wu–Ding–Chen 2025; DMP 2021; hexacode; Dür 1987) — unchanged.

**Handoff contradiction flags:** (1) the Adler title "The icosahedron and PSL₂(11)" does not
exist — replace with Adler's real X(11)/PSL₂(11) papers; (2) D3 is resolved: the arc is KNOWN
(drop "new arc" now, not conditionally); (3) the 100-coset/secant-3 structure must credit the
Brianchon points; (4) obtain Dye 1991 before final wording of any bisecant-geometry or
five-triangle sentence — it is the one remaining unread primary source with contradiction
potential.
