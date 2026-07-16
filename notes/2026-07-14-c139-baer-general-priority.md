# C139 — general quadratic-Frobenius priority search

**Date:** 2026-07-14
**Lane:** `baer`
**Status:** REPORTED — no exact precursor located in the bounded general search

## Goal

Search specialist databases, monographs, and primary literature for the general quantitative
quadratic-Frobenius pair-extension criterion, separately from C134's uniform `PG(2,25)` search.

## Criterion searched

For a Frobenius-invariant arc in `PG(2,s²)`, with `f` selected fixed points and `e` selected
nonfixed conjugate pairs, the searched statement was the assembled orbit-valued criterion with

```text
E=s²+s+1-(f(s+1)-binom(f,2)+e),
N=(s²-s)/2,
M=fe+e(e-1),
N_pair(C) ≥ E*(N-M)_+,
```

together with the sharper carrierwise count by distinct forbidden support and the interpretation of
an extension as a fresh degree-two Frobenius orbit. Searches were also run for the individual
vocabularies “Baer involution/collineation,” “semilinear invariant arc,” “conjugate pair/point,”
“degree-two closed point,” and Galois-constrained two-column MDS lengthening.

## Databases and result

The search used zbMATH Open, OpenAlex, Crossref, and primary-source web text. The exact OpenAlex
query for a Frobenius-invariant projective-plane arc, conjugate pair, and extension returned zero
records. The exact zbMATH query returned zero; broader zbMATH queries returned 11 records for
`Galois invariant arcs`, 48 for `Baer subplane arcs`, and two for `conjugate points arcs projective
plane`. Exact-vocabulary searches for `Frobenius automorphism complete arc`, `semilinear invariant
arc projective plane`, and `Galois orbit extension arc` returned no records. On the coding side,
`Galois invariant MDS codes` and `conjugate columns MDS` returned no records; the ten records for
`MDS code extension arcs` concern ordinary extension.

No located record states the displayed formula, a carrierwise lower bound for legal Frobenius
orbits, or a symmetry-preserving two-column MDS lengthening theorem of this form.

## Strongest adjacent sources

| Source | Relevant content | Why it does not contain the criterion |
|---|---|---|
| Baker–Wantz, *An arc partition of the Hughes plane using a field-theoretic model* (2005), [DOI](https://doi.org/10.2140/iig.2005.2.83) | Uses Frobenius-invariant arcs. In the maximality proof it adjoins a point and considers its Frobenius image; depending on the mate line, this yields a larger arc or a larger arc after deleting one of the two new points. | This is genuine precedence for the conjugate-point maneuver, but it supplies no empty-Baer-line count, forbidden-secant-orbit charge, global legal-pair count, or small-invariant-arc extension theorem. |
| Dye, *Hexagons, conics, A₅ and PSL₂(K)* (1991), [DOI](https://doi.org/10.1112/jlms/s2-44.2.270) | Theorem 8 gives an exact completion locus for the special family of Clebsch hexagons; Proposition 1 and Theorem 7 give a five-valent shared-triangle graph. In characteristic five the six points of a subfield conic are a Clebsch hexagon. | This is direct precedence for exact completion geometry and a graph on symmetric finite-plane configurations, but it neither imposes the quadratic field-Frobenius involution on arbitrary arcs nor counts fresh legal conjugate-pair extensions. |
| Blokhuis–Seress–Wilbrink, *Characterization of complete exterior sets of conics* (1992), [DOI](https://doi.org/10.1007/BF01204717) | Classifies extremal complete exterior sets relative to a conic; at `q=25`, a size-13 complete exterior set is the exterior-point set on a passant. | Its specialized completeness notion, cross-ratio model, and Paley-graph proof do not concern invariant eight-arcs, paired extensions, or arbitrary deletion and replacement. |
| Jungnickel, *Divisible semiplanes, arcs, and relative difference sets* (1987), [DOI](https://doi.org/10.4153/CJM-1987-051-1) | Studies maximal arcs after deleting a Baer subplane and gives constructions and bounds in the resulting Baer semiplane. | Its arc has an additional point-class condition in a different incidence structure. The source contains no Frobenius or conjugate-point argument and no orbit-valued extension count. |
| Ueberberg, *Frobenius collineations in finite projective planes* (1997), [record and full text](https://eudml.org/doc/120043) | Develops geometries of Frobenius collineations and records complete arcs arising as point orbits of projective collineations associated with Baer involutions. | It studies collineation and Baer-partition geometry, not extension of an arc by an orbit of the field Frobenius; no legal-pair criterion appears. |
| Alderson–Bruen–Silverman, *Maximum distance separable codes and arcs in projective spaces* (2007), [DOI](https://doi.org/10.1016/j.jcta.2006.11.005), and Alderson, *Extending MDS Codes* (2005), [DOI](https://doi.org/10.1007/s00026-005-0245-7) | Give general ordinary MDS/arc extendability results, principally in long-code regimes. | Neither constrains two added columns to be a quadratic Galois orbit or supplies the fixed-carrier obstruction count. |
| Alderson, *When arcs extend uniquely: a higher-dimensional generalization of Barlotti's result* (2026), [arXiv](https://arxiv.org/abs/2511.06193) | Proves unique ordinary one-point extension for long `(n,k+s-1)`-arcs under divisibility and size hypotheses. | It has neither a field-automorphism invariance hypothesis nor a conjugate-pair extension conclusion; its parameter regime and continuation unit are different. |
| López–Maisner–Nart–Xarles, *Orbits of Galois Invariant n-Sets of P¹ under PGL₂* (2002), [DOI](https://doi.org/10.1006/ffta.2001.0335) | Classifies Galois-invariant point sets on the projective line. | This concerns conic-contained configurations and orbit classification, not arbitrary plane arcs or legal pair extensions. |

The usual monograph/survey arc and MDS vocabularies led back to ordinary completeness, long-arc
extension, group-orbit constructions, Baer-semiplane arcs, or the Hughes-plane maneuver above.
None located the paper's combination of fixed empty carriers, nonfixed secant orbits, and semantic
global legal-pair cardinality.

The full texts of Dye 1991 and Blokhuis–Seress–Wilbrink 1992 were subsequently checked directly.
The 1991 predecessor cited by Blokhuis–Seress–Wilbrink, *On sets of points without tangents*, was
not available in the local source cache and remains outside this source-level gate.

## Disposition and limitations

The general criterion may be described as **having no exact precursor located in this bounded
specialist-vocabulary and database search**. Its counting ingredients are elementary and classical;
the candidate contribution is their exact orbit-valued assembly for arbitrary quadratic-field-
Frobenius-invariant arcs, together with multiplicity and replacement consequences, not a new
counting paradigm or the first exact completion geometry for a symmetric arc. Do not call the
criterion historically first, certified novel, or definitively absent from the literature.

Direct MathSciNet subscription access was unavailable. Crossref's broad token searches were noisy,
and Baker–Wantz has zero resolved citing works in both OpenAlex and Crossref, so those services do
not provide a usable forward-citation chain. Non-digitized proceedings, older monographs without
full-text indexing, and sources using unexpected terminology remain outside the negative result.
