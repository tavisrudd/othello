[REPORTED 2026-07-13]

# C129 — Must-read prior-art sources: acquisition + verdicts

Gate check for the icosahedral MDS deep-holes paper
([handoff](handoffs/2026-07-13-clebsch-paper.md), RED-TEAM MUST-DO list;
builds on [C127](2026-07-13-c127-klein-reduction-novelty.md)).

## PRIORITY 1 — Dye 1991 (the GATE)

**R.H. Dye, "Hexagons, conics, A₅ and PSL₂(K)", J. Lond. Math. Soc. (2) 44 (1991) 270–286.**
DOI [10.1112/jlms/s2-44.2.270](https://doi.org/10.1112/jlms/s2-44.2.270).

**Full text: NOT openly available.** Wiley/LMS archive returns HTTP 402 (paywall);
pdfdirect endpoint serves a Cloudflare challenge; no copy on IA Scholar, CORE,
ResearchGate (bot-blocked), Semantic Scholar OA, or any repository found. **ILL remains
the only route to the full text.** Best URL for a library/ILL fetch:
`https://londmathsoc.onlinelibrary.wiley.com/doi/pdf/10.1112/jlms/s2-44.2.270`.

**Verdict on the decisive question (does Dye state that the 0-bisecant points are the
A₅-invariant conic, over F_q or F₁₁?): NO, on strong proxy evidence — risk LOW but not
zero without the full text.** Three independent proxies, none mentioning any 0-bisecant
statement or any q=11 point count:

1. **zbMATH review Zbl 0698.20032 — author-written (signed R.H. Dye), detailed.**
   Retrieved in full via the zbMATH Open API
   (`https://api.zbmath.org/v1/document/_search?search_string=Dye%20hexagons%20conics`).
   Contents of the 1991 paper per this review: existence criterion for Clebsch hexagons
   (char ≠ 2, 5 a square in K); 10 Brianchon points (points on exactly 3 edges); the 5
   triangles partitioning the vertices; the **unique orthogonal polarity/conic C with all
   5 triangles self-polar**; stabilizer A₅ (Σ₅ in char 5); PGL₃(K)-transitivity on Clebsch
   hexagons; double-contact conics through 5 vertices; triple-perspective triangle pairs;
   self-duality of the hexagon+triangles+Brianchon figure. Nothing about points on no
   bisecant; no finite point counts.
2. **Dye's own open-access 1997 follow-up** (Space sextic curves with six bitangents,
   Proc. Edinb. Math. Soc. 40, [open PDF at Cambridge](https://www.cambridge.org/core/services/aop-cambridge-core/content/view/C880C5E0EC58C311EB54B5A3599833A1/S0013091500023452a.pdf/div-class-title-space-sextic-curves-with-six-bitangents-and-some-geometry-of-the-diagonal-cubic-surface-div.pdf))
   recaps [3]=Dye 1991 with page-precise citations: p. 274 coordinates (vertices
   (1,±j,0)... with j²=j+1), p. 275 (≤10 Brianchon pts; all such hexagons equivalent),
   p. 277 (C is x²+y²+z²), p. 278 (edge-transitivity), p. 281 (**C contains no vertex** —
   the strongest incidence statement he cites), p. 283 (double contact), p. 285 (no 3
   Brianchon pts collinear). No 0-bisecant statement anywhere in the recap.
3. **Storme–Van Maldeghem 1995** ([open PDF](https://cage.ugent.be/~hvm/artikels/41.pdf)),
   Remark 2, summarizes Dye [5] for the finite plane: occurrence conditions
   (q ≡ ±1 mod 10, q=5^h, q=2^{2h}); Brianchon points; the invariant conic C; and the one
   bisecant-stratum↔C incidence they extract: **Brianchon points ∈ C iff q = 3^{2h}**.
   They then prove incompleteness of the 6-arc at q=11 by computer (Prop. 13 context)
   *without* citing any such fact from Dye — which they surely would have used had it
   been in [5].

**Structural argument reinforcing NO:** "C ∩ (bisecants) = ∅" is intrinsically a
per-q rationality fact, not a general-K statement — over any infinite K every bisecant
meets C, and at q = 9 the Brianchon points (each on 3 bisecants) lie ON C. Dye's paper
is general-K synthetic geometry; the q=11 filling statement has no natural home there.
Residual risk: a finite-field aside in the body (he does treat q ≡ ±1 mod 10
occurrence conditions), unverifiable without the full text. **Recommend: keep the ILL
request; safe to draft now with a cite of Dye for the hexagon/conic apparatus and a
footnote that the q=11 0-bisecant identification does not appear in Dye's stated
results (per his own zbMATH summary and his 1997 self-recap).**

Citing-literature sweep (Semantic Scholar: 14 citing papers, all checked by
title/availability; the open ones — Bring's curve arXiv:2208.13692, binary-codes-from-
conics arXiv:1104.0324 line — cite Dye only for the coordinates/pencil or the hexagon's
existence): **no citing paper restates a 0-bisecant/conic theorem.**

## PRIORITY 2 — secondary gates

- **O'Keefe–Storme, "Arcs fixed by A₅ and A₆", J. Geom. 55 (1996) 123–138.** DOI
  [10.1007/BF01223038](https://doi.org/10.1007/BF01223038) (Springer, paywalled; no OA
  copy found). zbMATH review **Zbl 0848.51007** (via API): determines the k-arcs in
  **PG(n,q)** fixed by primitive A₅/A₆ — normal rational curves plus 6-arcs and 10-arcs.
  It does catalogue the A₅ 6-arc family (ours is the planar case), but the review shows
  no extension-point data; **SVM 1995 supersedes it for the planar uniqueness claim.
  Cite it for completeness; not a gate.** Full text via ILL if the referee insists.
- **DMP twisted-cubic / covering series — the k=4 "uncovered locus" IS answered there.**
  [arXiv:1909.00207](https://arxiv.org/abs/1909.00207) (Bartoli–Davydov–Marcugini–
  Pambianco, *On planes through points off the twisted cubic in PG(3,q) and multiple
  covering codes*) is the right citation: **Theorem 3.1 + Tables 1–2** give the full
  point-orbit (C-, T-, 3Γ-, 1Γ-, 0Γ-points) × plane-orbit incidence counts (r_ij =
  planes of each class through each point class = the coset/weight data), and
  **Definition 7.1(M2) + Theorem 7.2** state outright that the points off every bisecant
  (real chord) of the cubic are exactly the non-RC points (tangent points T ∪ the
  Γ-classes off real chords), i.e. the codim-4 GDRS code is quasi-perfect with R=3 and
  the distance-3 cosets are stratified by those tables (Theorem 7.3). Companions
  ([arXiv:2104.12254](https://arxiv.org/abs/2104.12254) point-line,
  [arXiv:2103.11248](https://arxiv.org/abs/2103.11248) plane-line,
  [arXiv:2112.14803](https://arxiv.org/abs/2112.14803) line-orbits II) refine
  line-orbit data; 1909.00207 alone carries the citation we need.
- **Zhang–Wan–Kaipa [arXiv:1901.05445](https://arxiv.org/abs/1901.05445)** (*Deep Holes
  of Projective Reed–Solomon Codes*, IEEE-IT 2020) — theorem numbers CONFIRMED:
  **Thm I.4** (the q classes (α₁^k,…,α_q^k,a) — from [17]), **Thm I.5** (q² classes;
  geometric interpretation = **tangent lines to the degree-(q−k) NRC**, made explicit in
  the remark after the proof in §II-D), **Thm I.6** ((q+1)q(q−1)/2 classes from monic
  irreducible quadratic denominators = **quadratic-extension family**, interpreted on
  the NRC over F_{q²}), **Thm I.7** (for k = q−3 these are ALL deep holes; count
  q(q+1)²/2, restated as Thm III.1 = (q³+2q²+q)/2). Cite I.4–I.7 exactly as planned.
- **PG(2,11) complete-arc classification (definitive, must cite before "first"):**
  **J.W.P. Hirschfeld & A.R. Sadeh, "The projective plane over the field of eleven
  elements", Mitt. Math. Sem. Giessen 164 (1984) 245–257**, plus A.R. Sadeh's Sussex
  thesis (*Classification of k-arcs in PG(2,11) and cubic surfaces in PG(3,11)*) and the
  tables in Hirschfeld, *Projective Geometries over Finite Fields*, 2nd ed. (1998),
  Ch. 14. These classify the (complete) arcs of PG(2,11); Sadeh's cyclic complete 7-arc
  is the standard citation from this line. For group-invariant uniqueness use SVM 1995
  (Prop. 13 and Remark 2); for transitive A₅-invariant arcs at other sizes, N. Pace,
  J. Combin. Des. 22 (2014), DOI 10.1002/jcd.21372 (30-arcs; not a gate for the 6-arc).

## URL list (readable copies)

| Source                            | Readable URL                                                                     |
| --------------------------------- | -------------------------------------------------------------------------------- |
| Dye 1991 (full text)              | none open — ILL; paywalled PDF: londmathsoc.onlinelibrary.wiley.com/doi/pdf/10.1112/jlms/s2-44.2.270 |
| Dye 1991 (author-written review)  | zbMATH API, Zbl 0698.20032 (full review text retrieved, quoted above)             |
| Dye 1997 recap (open)             | cambridge.org (.../S0013091500023452a.pdf, Proc. Edinb. Math. Soc. 40, 85–97)     |
| SVM 1995 (open)                   | https://cage.ugent.be/~hvm/artikels/41.pdf                                        |
| O'Keefe–Storme 1996               | paywalled, DOI 10.1007/BF01223038; review Zbl 0848.51007                          |
| DMP covering (open)               | https://arxiv.org/abs/1909.00207 (+ 2104.12254, 2103.11248, 2112.14803)           |
| ZWK (open)                        | https://arxiv.org/abs/1901.05445                                                  |
| PG(2,11) arcs                     | Hirschfeld–Sadeh 1984 (no OA found); Hirschfeld PGOFF 2nd ed. Ch. 14              |
