# Novelty check: arcs complete outside a conic and the `q=16` refinement

**Date:** 2026-07-13

## Verdict

The raw count of 2633 projective eight-arc classes in `PG(2,16)` is prior art. The present
enumeration independently reproduces it. The generic evaluation obstruction is elementary linear
algebra inside an established arcs-and-quadrics tradition and should not be claimed as a new
theorem by itself.

The following remain plausible original contributions after this bounded search:

1. the parameter for arcs disjoint from a prescribed conic whose secants cover every point off the
   arc and conic;
2. the prescribed-hole defect identity and its stability/lower-bound consequences in the stated
   form;
3. applying quadratic evaluation rank to the *ordinary-uncovered locus* of each arc to reject a
   conic as the allowed exceptional locus;
4. the refinement of the 2633 ordinary eight-arc classes into 2630 full-rank leaves and three
   rank-five forced-hit leaves, including the exceptional-form anatomy; and
5. the exact relative value `rho_C(16)=9`, with a strict-trust Lean proof.

These are search findings, not a priority certificate. Exact terminology may differ, sources may
be unindexed, and the 2018 classification data could have been reused privately to test other
properties.

## Direct prior art and closest neighbors

- N. A. M. Al-Seraji and R. A. B. Al-Ogali, [*Classification of Arcs in Finite Projective Plane of
  Order Sixteen*](https://mjs.uomustansiriyah.edu.iq/index.php/MJS/article/download/184/pdf/2715),
  Al-Mustansiriyah Journal of Science 29(1), 2018,
  doi:10.23851/mjs.v29i1.184. Theorem 3.8.1 gives exactly 2633 projectively distinct eight-arcs;
  Theorem 3.8.2 gives eleven eight-arc classes contained in a conic. Its tables organize ordinary
  arcs by stabilizer and secant-index data. Text searches found no quadratic-rank, uncovered-locus,
  `2630+3`, or relative-completeness analysis.
- D. G. Glynn, [*On the construction of arcs using quadrics*](https://ajc.maths.uq.edu.au/?page=get_volumes&volume=9),
  Australasian Journal of Combinatorics 9 (1994), 3--19, and S. Ball,
  [*On Arcs and Quadrics*](https://web.mat.upc.edu/simeon.michael.ball/arcsandquadrics.pdf),
  WAIFI 2016 / LNCS 10064 (2017), 95--102. These establish linear spaces of quadrics vanishing on arcs as standard
  machinery. They support treating the paper's generic evaluation lemma as a reusable formulation,
  not as a novelty claim. The checked arguments concern quadrics containing selected arc points,
  rather than a quadric forced through the ordinary-uncovered locus while avoiding the arc.
- D. Bartoli, A. A. Davydov, S. Marcugini, and F. Pambianco, [*On the smallest size of an almost
  complete subset of a conic in PG(2,q) and extendability of Reed--Solomon codes*](https://arxiv.org/abs/1609.05657), Problems of
  Information Transmission 54 (2018), 101--115; arXiv:1609.05657. Their selected set lies on the
  conic and its chords cover specified complementary points. This is close prescribed coverage but
  geometrically opposite to an arc required to avoid the conic.
- S.-L. Ng and P. R. Wild, [*On k-Arcs Covering a Line in Finite Projective Planes*](https://combinatorialpress.com/article/ars/Volume%20058/volume-58-paper-27.pdf), Ars
  Combinatoria 58 (2001), 289--300. This prescribes a line that must be covered, whereas the present
  conic is the locus allowed to remain uncovered.
- Z. L. Nagy, [*Saturating sets in projective planes and hypergraph covers*](https://arxiv.org/abs/1701.01379), Discrete Mathematics
  341 (2018), 1078--1083; arXiv:1701.01379. Saturating sets cover every outside point and need not
  be arcs; there is no prescribed exceptional locus.
- G. Korchmáros, G. P. Nagy, and T. Szőnyi, [*Algebraic approach to the completeness problem for
  (k,n)-arcs in planes over finite fields*](https://arxiv.org/abs/2302.10162), Journal of Combinatorial Theory A 204 (2024), 105851;
  arXiv:2302.10162. This is relevant algebraic completeness work involving uncovered points, but
  for `(k,n)`-arcs and associated curves, not the relative conic problem or the evaluation-rank
  certificate used here.
- G. Van de Voorde, [*On sets without tangents and exterior sets of a conic*](https://arxiv.org/abs/1201.0484), Designs, Codes and
  Cryptography 65 (2012), 243--252; arXiv:1201.0484. Exterior sets require secants of the selected
  set to be external to a conic, a different incidence condition.

## Search boundary

Queries combined the phrases `complete outside a conic`, `relative complete arc`, `prescribed
exceptional locus`, `uncovered points`, `secants cover a conic/line`, `saturating set`, `arc
quadratic rank`, `PG(2,16) 8-arcs`, and the discovered authors/titles. Searches covered publisher
pages, arXiv, journal PDFs, references in the closest papers, and text within the 2018 `PG(2,16)`
classification and Ball's arcs-and-quadrics paper. No exact match for the relative definition,
`rho_C`, the `2630+3` invariant, or the exact relative value was found.

## Claim discipline for the manuscript

- Cite the 2018 classification adjacent to the 2633 count and label the computation an independent
  reproduction plus a new invariant/refinement.
- Call the evaluation obstruction elementary; cite Glynn and Ball as the surrounding algebraic
  tradition.
- Use `we did not locate` or `plausibly new`, never an unconditional first-discovery claim.
- Keep the exact value's strongest defensible novelty statement narrow: no prior statement was
  found for the relative parameter or `rho_C(16)=9`, and the supplied proof is independently
  reproducible and kernel checked.
