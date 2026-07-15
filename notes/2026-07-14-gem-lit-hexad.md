# Literature check: chord-concurrency characterization of S(5,6,12) hexads

**Date**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.

## Verdict: ABSENT

No source found **states** the candidate theorem, and none **implies** it in one step. The
searches covered the Edge corpus (including the specific 1956 paper flagged as the likeliest
near-miss), the design-theory/Curtis-kitten/Conway-Sloane line, the ternary-Golay/coding line,
the group-theory PSL(2,11)-on-12-points line, arXiv full text, and the classical
hexagrammum-mysticum literature. The candidate appears novel.

The single most dangerous near-miss — Edge 1956 at p=11 — is a **false friend**, and the
distinction is now verified directly against Edge's own definitions rather than taken on
report. It is the polar-dual configuration on a different point set. Details below.

## The candidate (for reference)

In PG(2,11), a nondegenerate conic has 12 rational points ≅ P¹(F₁₁). For a 6-subset H, draw
the 15 chords and count concurrent chord-triples t(H). The 6 points of H each force C(5,3)=10,
so t(H) ≥ 60. Claim: t(H) = 60 iff H is a hexad of S(5,6,12). Spectrum over C(12,6)=924:
{60: 264, 62: 330, 63: 220, 64: 110}; 61 never occurs; the 264 at t=60 are exactly the union
of the two S(5,6,12) systems (132+132, swapped by PGL(2,11) \ PSL(2,11)).

## Verdict table

| Source / framing                                          | Verdict           | Why it is not our theorem                                     |
| --------------------------------------------------------- | ----------------- | ------------------------------------------------------------- |
| Edge 1956a, "Conics and orthogonal projectivities", §29–32 | ABSENT (dual)     | 6 points **external** to the conic; 66 e-points, 22 hexagons   |
| Edge 1956a §19 (q=5)                                        | ABSENT (degenerate) | On-conic and chord-concurrency, but q=5: hexad = whole conic |
| Edge 1975a, "A footnote on the mystic hexagram"             | ABSENT            | Real/complex + GF(5) full-conic; no q=11, no subset selection  |
| Edge 1972b, "Klein's encounter with … order 660"            | ABSENT            | Matching group order only; unrelated topic                     |
| Rest of Edge archive (~40 titles)                           | ABSENT            | Enumerated; none touch 12-point-conic hexad selection          |
| Curtis, kitten / MINIMOG                                    | ABSENT            | Same P¹(F₁₁) point set, but AG(2,3) triangle diagram device    |
| Conway & Sloane SPLAG ch. 10–11                             | ABSENT            | Tracks Curtis kitten; no PG(2,11)/concurrency framing          |
| Todd on M12/M24                                             | ABSENT            | No PG(2,11) model located                                      |
| Conway–Elkies–Martin M13 / pinball                          | ABSENT            | Uses PG(2,3) — 13 points, different plane                      |
| Havlicek, Veronese surface in PG(5,3) (arXiv:1210.2055)     | ABSENT (rival)    | Genuine geometric hexad characterization, different space      |
| Cameron, "Geometry of the Mathieu groups" ch. 9             | ABSENT            | M24/octads via PG(2,4); no conic/chord/concurrency (grepped)   |
| Lord, "Geometry of the Mathieu groups and Golay codes"      | ABSENT (abstract) | Works in PG(5,3), PG(11,2); full text paywalled                |
| Hollmann–Xiang, assoc. schemes from PGL(2,q) fixing a conic | ABSENT            | Closest by title; no q=11, no hexad/Mathieu content (grepped)  |
| Halbeisen–Hungerbühler, "Twins of Conic Hexagons" (2024)    | ABSENT (key)      | Exactly our 15-chord setup, but over R/Q; no finite field      |
| Bailey, "Decoding M12"; standard PSL(2,11) constructions    | ABSENT            | Abstract-line level; never embeds P¹(F₁₁) as a conic           |
| arXiv full text (many term combinations)                    | ABSENT            | No hit combining conic + PG(2,11) + hexad/S(5,6,12)            |

## The Edge near-miss, verified

This is the finding that most needed to be right, so it was checked against the primary text
directly (OCR layer extracted with `pdftotext`), not just via the search agents.

Edge's abstract says, at p=11, "the distribution of the points **external** to χ in sets of 6,
the 15 joins of points of such a set being all skew to χ and concurrent in threes at 10
different points all internal to χ". His §4 defines the vocabulary unambiguously: "We may call
external points *e*-points, and internal points *i*-points." And §29: "Given the conic χ there
are 22 Clebsch hexagons ℋ all of whose vertices are **e-points** and diagonals s-lines; each of
the 66 e-points is a vertex of 2 ℋ that belong one to each of 2 imprimitive systems of 11 ℋ."

So Edge's object is: 6 points **off** the conic, drawn from 66 e-points, giving 22 hexagons
(11+11). Ours is: 6 points **on** the conic, drawn from 12, giving 264 subsets (132+132) out of
924. Same field, same Clebsch/Brianchon vocabulary, and — notably — **the same PGL\PSL
two-system-swap motif** ("The operations of Ω(3,11) that are outside Ω⁺(3,11) transpose the 2
systems"). But it is a different point set with a different count, and Edge never mentions
Mathieu, Steiner, or hexads (grepped: zero hits — the paper predates that framing).

The one place Edge *is* on-conic with chord concurrency is §19 at **q=5**, where the conic has
exactly q+1=6 points, so the "hexagon" is the entire conic and there is no subset to choose:
"the points of χ form a hexagon endowed 10 times over with the Brianchon property." That is the
degenerate boundary case of our question, not an instance of it.

**Assessment**: Edge had the field, the vocabulary, the polarity machinery, and the PGL/PSL
swap — and did not ask our question. This raises rather than lowers the value of the negative:
the closest expert to the result did not state it.

## Why the classical literature could not have had this

Halbeisen–Hungerbühler (J. Geometry, 2024) study precisely our construction — the 15 chords of
6 points on a nondegenerate conic — over R/Q. Their load-bearing sentence: those 15 lines yield
"**in general**, 45 intersection points different from the points Pᵢ."

That is the structural reason the classical literature has no spectrum result. Over R/C the
generic hexad sits at t=60 with all 45 non-trivial chord-pairs distinct; any extra concurrence
is a measure-zero special-position condition, studied one construction at a time (Clebsch's
icosahedral hexagon, self-polar-triangle hexads). With a continuum of conic points there is no
finite set of hexads to survey, so "tabulate t(H) over all hexads and read off the spectrum" is
not a well-posed classical question. It only becomes well-posed once the conic is finite. This
supports the result being a genuinely finite-geometry phenomenon rather than a specialization
of a known char-0 theorem.

The char-0 corpus does supply the vocabulary and isolated nontrivial-concurrence instances:
- Clebsch, Math. Ann. 4 (1871), 284–345, p. 336 — the original "Brianchon-endowed hexagon",
  via the diagonal cubic surface / regular icosahedron. This is Edge's cited ancestor.
- Edge 1975a §4 — a self-polar-triangle hexad on a conic with six explicitly enumerated extra
  chord concurrences, in syntheme language. Closest classical analogue to counting t(H), but
  for one symmetric hexad, not a survey.
- Pascal's hexagrammum mysticum (60 Pascal lines, Steiner/Kirkman/Cayley/Salmon points) —
  right shape of machinery, but built from opposite-side intersections and never specialized to
  F₁₁ or connected to M12.

## How crowded is "geometric characterizations of S(5,6,12) hexads"?

Sparse — essentially one established relative, in a different ambient geometry:

- **Havlicek / Coxeter / Pellegrino**, "The Veronese Surface in PG(5,3) and Witt's 5-(12,6,1)
  Design" (arXiv:1210.2055): "The internal points of those conics form a 12-cap which is a
  point model for Witt's 5-(12,6,1) design… any five distinct points of K span a prime
  (hyperplane) of PG(5,3) which contains exactly six points of K." Hexads = hyperplane sections
  of a 12-cap in PG(5,3). Analogous in spirit (conics → hexads via an incidence condition), but
  dimension 5 over F₃, and uses spanning/incidence, not concurrency.
- Cameron ch. 9 gives geometric models in PG(2,4) — but for M24 octads, not S(5,6,12) hexads.
- Everything else (Curtis kitten, MINIMOG, quadratic-residue base hexad, ATLAS-style
  PSL(2,11) generators) is combinatorial or group-theoretic.

Notably, Curtis/Conway/Bailey all use the *identical* 12-point set P¹(F₁₁) as our candidate but
never embed it as a conic in the ambient plane PG(2,11) — so that machinery could not have
produced a concurrency statement even in passing.

## Residual risk

Two items were not verified at full text (both paywalled, 403 on IAS/Springer/ResearchGate):
- Lord, "Geometry of the Mathieu groups and Golay codes", Proc. Indian Acad. Sci. 98 (1988),
  153–177. The abstract places it in PG(5,3) and PG(11,2), so PG(2,11) content is unlikely, but
  this is inference from the abstract, not a grep.
- ScienceDirect item on PGL(2,11)/PSL(2,11).

Also unchecked in the Edge archive: 1965a "Some implications of the geometry of the 21-point
plane" (PG(2,4) → M22/S(3,6,22) territory, different design) and 1955b "31-point geometry"
(PG(2,5); cited by 1956a as background for the q=5 material, so likely the same content).

None of these are likely to overturn the verdict, but they are the edges where it is untested.

## Search terms used (so the negative has weight)

Design theory: hexad+conic; "S(5,6,12)"+PG(2,11); Curtis kitten/MINIMOG+conic; geometric/
intrinsic characterization of Mathieu design hexads; Hirschfeld, Hirschfeld–Thas.
Finite geometry: hexads on a conic; 6-arcs on a conic PG(2,11); Brianchon point + finite plane;
hexagrammum mysticum finite field; Pascal lines PG(2,q); concurrent diagonals; self-polar;
syntheme; synthematic total.
Group theory: PSL(2,11) on 12 points; exotic/2-transitive actions; two S(5,6,12) systems +
PGL/PSL swap; outer automorphism of S6; Brianchon+M12/Steiner/hexad.
Coding: ternary Golay [12,6,6]; weight-6 codewords = hexads; conic/projective model of the
ternary Golay code.
Classical: Clebsch hexagon; Clebsch Kegelschnitt; Weddle; Kummer; icosahedron+PSL(2,11);
self-polar hexagon.
arXiv full text across the above combinations.

## Recommendation

The novelty claim survives. Cite Edge 1956a as the nearest prior art and state explicitly that
his p=11 Clebsch hexagons are the external-point (polar-dual) configuration on 66 e-points, and
that his on-conic Brianchon result is the q=5 degenerate case — this pre-empts the obvious
referee objection. Cite Clebsch (Math. Ann. 4, 1871, p. 336) as the char-0 ancestor and
Halbeisen–Hungerbühler for the generic-position baseline that makes t=60 the expected floor.
Cite Havlicek/Coxeter/Pellegrino as the one existing geometric hexad characterization, and
position ours as the planar/concurrency counterpart to their PG(5,3) spanning one.
