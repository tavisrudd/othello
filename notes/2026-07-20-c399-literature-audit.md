# C399 literature audit — classical conic configurations and surviving code theorem

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `SURVIVES AFTER REFRAMING; CLASSICAL FINITE-GEOMETRY CORE PRE-EMPTED`

## Executive conclusion

C399 survives as a uniform reflection-arrangement complement-code theorem, not as the discovery of
the three exceptional finite-plane configurations.  The strongest literature-surviving statement is
the exact nonmirror-line maximum

```text
M_T(q) = q-h+1,
```

and hence the uniform minimum distance

```text
d_T(q) = (q-h/2-1)(q-h+1)
```

for `T=A3,B3,H3`, together with the common Coxeter-number specialization `q=h+1`.  No exact
predecessor for that three-type package was located in the coverage below.

The following are not available as novelty claims:

- the individual conic configurations over `F_5`, `F_7`, and `F_11`;
- the counts `5,14,22`, their `S4,S4,A5` stabilizers, or the fact that the full conic group is
  transitive on the corresponding markers;
- much of the pairwise/intersection geometry of those marker fibres;
- the raw octahedral `3+6` split underlying the `B3` short/long-root decomposition;
- characteristic-polynomial complement counts, the conic--MDS/GRS dictionary, or the generic idea
  of evaluating codes on arrangement complements.

The manuscript-safe contribution is therefore the common Coxeter-number explanation, the exact
line-defect/distance theorem, its arrangement-complement and coding formulation, stable recovery,
and the precise deepest-syndrome consequence of the classical `B3` split.  The direct rank-four
quadric point-count failure is a useful scope boundary, not a standalone headline.

## Project state immediately before C399

- C211 paired the reduced `A3/F_5` frame arrangement with the `H3/F_11` Clebsch arrangement and
  recorded their two complement factorizations.
- C339 and C346 supplied the all-good-reduction `H3` line spectrum, complement-code parameters,
  arithmetic descent, and stable recovery.
- C368 supplied the q=11 non-GRS parent, full-conic deepest-syndrome locus, and extended-GRS child.
- C398 classified all non-GRS six-arcs with a nonempty conic-contained complete syndrome locus and
  showed that the q=11 full-conic member is unique but classically present in finite geometry.

C399's actual increment was to insert `B3`, discover the common Coxeter-number line-defect law, and
package all three irreducible rank-three types into one exact distance and `q=h+1` phase theorem.
The literature audit then separated that new-looking synthesis from the much older individual
configurations.

## Claim-by-claim disposition

| C399 seam | Literature disposition | Paper treatment |
|:---|:---|:---|
| Complement length `(q-h/2)(q-h+1)` | Classical finite-field method plus Coxeter exponent factorization | Credit as infrastructure |
| Maximum nonmirror intersection `q-h+1` and exact distance | No exact predecessor located | Principal theorem claim |
| Uniform `q=h+1` complement/conic phase across `A3/B3/H3` | Individual cases classical; common Coxeter-number statement not located | Principal synthesis claim, without “first” |
| Conic gives `[q+1,3,q-1]` extended GRS | Classical arc--MDS/normal-rational-curve dictionary | Corollary and interpretation |
| Stable recovery of mirrors from the complement | No exact reflection-code formulation located; proof is an elementary blocking observation | Structural corollary |
| `5,14,22` parent fibres and ambiguity | Edge and Dye substantially pre-empt the counts, stabilizers, transitivity, and geometric-marker meaning | Classical context; claim only the Coxeter/code identification |
| Fibre intersection/coherent geometry | Edge and Dye already give much of the relation skeleton and valencies | C404 closed; no novelty wording |
| `B3` short-root polar triangle versus long-root `D3=A3` | Edge's octahedral involutions already have the underlying `3+6` split | Credit geometry; claim the exact complement/deep-hole consequence only |
| Direct rank-four continuation | No predecessor located for the displayed point-count screen | Scope boundary only |
| Entire deepest-syndrome locus of the non-GRS `H3` parent becomes the full-conic GRS child | General deep-hole/MDS-extension machinery and the q=11 incidence are classical; this exact full-locus coding package was not located | Narrow surviving coding formulation, qualified by coverage |

## Primary-source ledger

This combined delegated audit read **eight distinct sources at full text**, with further sources at
targeted partial or abstract/metadata depth.  Depth markers below are unconditional; cached bytes do
not themselves certify reading.

| Source | Read depth and access | Load-bearing boundary |
|:---|:---|:---|
| Edge, *Conics and orthogonal projectivities in a finite plane* (1956), DOI `10.4153/CJM-1956-041-6` | **full text**, published 21-page PDF, all sections; cache SHA-256 `07149c0f963d2b31016a0ad992ff6f0af6a77775a574a6c76aa3621b68e189ef` | Sections 19--21, 23--28, and 29--32 give the `5,14,22` conic markers and substantial relation geometry. Sections 12--17 give the octahedral `3+6` split and conic group action. |
| Dye, *Hexagons, conics, A5 and PSL2(K)* (1991), DOI `10.1112/jlms/s2-44.2.270` | **full text**, published scan, pp.270--286; OCR reconstruction SHA-256 `6d48847949e2b37c3a87557df9fa4147c9b1305d8469c7c06965c62b99fcbf92`; load-bearing pp.272,279,280,282 verified against authoritative page images | Theorems 4 and 7--8 give conic-group transitivity, stabilizers, the q=11 count, adjacency, and further intersection geometry. |
| Blokhuis--Seress--Wilbrink, *Characterization of complete exterior sets of conics* (1992) | **full text**, published five-page scan, pp.143--147; reconstruction SHA-256 `2ae266849748949c2388bcf5ae202799a2bf4bae32f5f583cbc5ed231972c7c4`; load-bearing pp.143,146 image-verified | Records the q=7 four-arc and q=11 six-arc exterior configurations and attributes them to Korchmaros. |
| Giudici, *Maximal subgroups of almost simple groups with socle PSL(2,q)*, arXiv:math/0703685 | **full text**, all 11 pages; SHA-256 `2c829b573dadf9ee2c71a9f85f92e1fb2d7443f64242dbe4a829c6246d9ae8e9` | Supplies the relevant `PSL_2/PGL_2` subgroup-class fusion and normalizer boundary. |
| Kaipa, *Deep holes and MDS extensions of Reed--Solomon codes*, arXiv:1612.05447 | **full text**, all 14 pages; SHA-256 `1fe8de83c0b8cd3938e1a450fd49f376de795d7a317f099a730c63ab968178a4` | Deep hole iff one-coordinate MDS extension and redundancy-three GRS classifications; does not form C399's child from the entire locus of a non-GRS parent. |
| Ardila, *Computing the Tutte polynomial of a hyperplane arrangement*, arXiv:math/0409211 | **full text**; SHA-256 `8d67ee9aa7b1f2948ead7fdfba545fe48c7da78a5fff3e79451545d1a96f5eaf` | Finite-field/coboundary method; controls complement length and mirror-incidence counts, not C399's nonmirror-line maximum. |
| Berg--Wakefield, *Skeleton Simplicial Evaluation Codes*, arXiv:1112.0283 | **full text**, all 16 pages; SHA-256 `9122564a0d28721e295e501a22ca8bb6de801f86d195424a80b296db9259887c` | Evaluation on unions of subspace arrangements, with characteristic-polynomial length and special exact distances; adjacent but not the projective complement theorem. |
| Settepanella, *Blocking Sets in the complement of hyperplane arrangements in projective space*, arXiv:0802.2045 | **full text**; SHA-256 `21ee5625ee080c874ef1223d5590817f9d701a5de24d72f38864e2abc05174f2` | Blocking sets in arrangement complements; no exact reflection-complement code reconstruction theorem. |
| Denef--Loeser, *Character sums associated to finite Coxeter groups*, DOI `10.1090/S0002-9947-98-02025-X` | **partial**, published version, Introduction and Sections 1.1--1.5; SHA-256 `9cd64541ae4052a871ac0b089957b88e1b4c11fc11009cb8e5b7d837e2fd2b6b` | Good reduction, invariant forms, and Coxeter degrees; no projective complement-code phase. |
| Monson--Schulte, *Modular Reduction in Abstract Polytopes*, arXiv:0805.1479 | **partial**, Sections 2--3.2; SHA-256 `149eeb36d30adc3cba20813bc7dad33d7a42cc0f39de0f3f3b9e6ab501c019ee` | Modular Coxeter reduction infrastructure. The closest Part I paper remained inaccessible beyond abstract/indexed snippets. |
| Palezzato--Torielli, *Combinatorially equivalent hyperplane arrangements*, arXiv:1906.05463 | **partial**, Sections 4, 6, and 7; SHA-256 `01973a6ff9a6a09303473f787afad0b15e153d6d24b6ce6b761d0d2fac9c0003` | Good/lucky-prime and lattice-preservation boundary. |
| Jurrius--Pellikaan, *Codes, arrangements and matroids*, DOI `10.1142/9789814335768_0006` | **partial**, targeted code/arrangement and weight-enumerator sections; SHA-256 `a5cbdf99d6156be47975cdfaa4c6ef9a5e26b23ea0ea75d0294dee4c2828b676` | A code's column arrangement determines its weight enumerator. For C399 this is the dual arrangement of complement points, not the original Coxeter mirrors. |
| Plesken--Bachler, code/matroid weight-enumerator treatment, DOI `10.4171/DM/447` | **partial**, targeted theorem sections; SHA-256 `a7e9d4398ba5e0eb4f9558af09bb2fafb597bcd76c2dce97a1b1c9982afa1436` | Same code-column-matroid boundary; does not shortcut the mirror-complement line spectrum. |
| Ball--Lavrauw, *Arcs in finite projective spaces*, arXiv:1908.10772 | **partial**, Sections 1--3 and 5 as used; SHA-256 `00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4` | Standard arc--MDS and conic--extended-GRS dictionary. |
| Raja, *Numerical semigroups, hyperplane arrangements, and linear codes over finite fields*, DOI `10.3934/amc.2026042` | **abstract/metadata only**, official publisher abstract and comparison table; advertised PDF unavailable/paywalled | Explicitly constructs codes on complements of difference arrangements, with characteristic-controlled lengths and distance bounds. Generic complement-code novelty is pre-empted; exact theorem overlap remains an access gap. |
| Korchmaros, 1981, DOI `10.1016/0097-3165(81)90056-X` | **secondary only**, through BSW (**full text**) and a targeted partial reading of Bamberg--Lansdown--Van de Voorde | Primary three-page paper was not obtained; no negative rests solely on its absence. |
| Wu--Ding--Chen, DOI `10.1109/TIT.2024.3494813` | **partial**, published pp.263--266 through Theorem 1 and targeted arXiv sections; arXiv SHA-256 `9fe6878668bafce0ba1eb759f9fee16ab10f77b5520b47eb1c4626aec5f76000` | General MDS parent/deep-hole extension equivalence, not the entire-locus non-GRS-to-GRS transform. |
| Zhang--Wan--Kaipa, arXiv:1901.05445 | **partial**, opening, principal theorems, syndrome preliminaries, and conclusion; SHA-256 `5c2b9e2508c7200428c441b7a41da1596b1c9b0851f5632e2297cdbed41caf24` | PRS deep-hole classification and `PGL_2` orbits; no C399 package. |
| Li--Lu--Ling--Lam, arXiv:2605.12133 | **partial**, Introduction, Theorems 1 and 10, Section IV.C, and conclusion; SHA-256 `8f854dcb3ad549b8bfdcaac6f585edc9d9516c7ea9674e970f54020657c0fa7d` | Recent non-GRS deep-hole constructions; the screened construction keeps non-GRS input non-GRS. |

## Search and forward-citation coverage

The audits screened exact/formula queries for reflection-arrangement complement codes,
`q=h+1`, invariant conics, `A3/B3/H3`, `5,14,22`, canonical triangles, octahedral structures,
Clebsch hexagons, non-GRS deep holes, and flag/coboundary line spectra.  The largest targeted
OpenAlex result sets were screened to their first 25 records where they exceeded that size.

Pinned forward graphs were checked independently in OpenAlex, Crossref, and Semantic Scholar for
Edge, Dye, Korchmaros, BSW, Kaipa, Wu--Ding--Chen, Monson--Schulte I, Denef--Loeser, Raja,
Berg--Wakefield, and Settepanella.  The largest accessible title/abstract set for each seed was
screened.  Representative counts were Edge `7/6/10`, Dye `13/10/14`, Korchmaros `8/8/8`, BSW
`9/3/11`, Kaipa `20/16/28`, and Wu--Ding--Chen `4/9/14`, in OpenAlex/Crossref/Semantic Scholar
order.  No screened successor supplied the uniform Coxeter-number distance/conic-phase theorem.

Coverage gaps remain: MathSciNet and Google Scholar were not covered; Korchmaros and Monson--Schulte
Part I were not obtained in primary full text; Raja's full text was inaccessible; some old citation
records lack abstracts; and large discovery sets were not exhaustively read beyond their first 25
OpenAlex records.  These gaps require “within the audit coverage” or equivalent language for
absence claims.  They do not weaken the positive Edge/Dye pre-emption.

## Manuscript-safe wording

> The classical configurations over `F_5`, `F_7`, and `F_11` admit a common Coxeter-number
> formulation.  Combining the finite-field method for reflection arrangements with an explicit
> analysis of nonmirror-line defects, we determine the length, extremal line intersection, and
> minimum distance of the projective evaluation codes supported on the `A3`, `B3`, and `H3`
> mirror complements.  At `q=h+1`, these codes specialize uniformly to the conic
> `[q+1,3,q-1]` MDS code.

Follow immediately with explicit credit:

> Edge and Dye already identify the exceptional conic markers and their `5,14,22` orbit counts,
> stabilizers, and several incidence relations.  We claim neither those configurations nor the
> resulting ambiguity of an unmarked conic as new.  Our contribution is their common
> reflection-arrangement complement-code mechanism, the exact distance law, and the recovery and
> deepest-syndrome consequences.

Avoid “first,” “previously unknown,” “Coxeter codes” (already occupied terminology), and any claim
that the original Coxeter arrangement's Tutte polynomial directly gives the complement code's
weight enumerator.  “Reflection-arrangement complement evaluation codes” is the safe family name.

## Planning consequence

C399 remains a medium-high-EV paper-heading theorem after reframing.  C403 is the highest-value
successor because it abstracts the exact line-defect/enumerator mechanism.  C404 closes at its
literature gate: Edge and Dye already own the intended fibre counts, marker meaning, and much of the
intersection skeleton, leaving no sufficiently distinct bounded target.  C405 remains an
independent high-upside rational-normal-curve pilot and moves ahead of any renewed fibre work.
