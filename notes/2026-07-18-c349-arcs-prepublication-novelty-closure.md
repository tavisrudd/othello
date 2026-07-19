# C349: arcs pre-publication novelty closure

## Verdict

The novelty gate closes with a narrowed, source-backed boundary. Korchmaros--Nagy--Szonyi already
give an exact proper-subplane uncovered-locus theorem: for odd `q` and odd `r>=5`, the points left
uncovered by the `(q+1)`-secants of their rational BKS `(k,q+1)`-arc in `PG(2,q^r)` are exactly the
points of `PG(2,q)` not on the arc. The manuscript therefore does not claim that localization of an
uncovered locus on a prescribed subgeometry is new.

The paper's contribution remains the exact defect identity for an arbitrary prescribed hole set,
its nonnegative local remainder and equality/stability consequences, and its conic specialization
for ordinary `2`-arcs, including the certified finite conclusions.

## Released wording

The introduction now says:

> Localization of an uncovered locus on a proper subgeometry is also known for curve-derived arcs
> with larger line intersections. Korchmaros, Nagy, and Szonyi prove that, for odd q and odd r at
> least 5, the points left uncovered by the (q+1)-secants of their rational BKS (k,q+1)-arc in
> PG(2,q^r) are exactly the points of the proper subplane PG(2,q) not belonging to the arc. Thus
> localization of holes in a prescribed subplane is prior art. Their theorem concerns a particular
> curve-derived (k,q+1)-arc; the contribution here is instead the exact defect identity for an
> arbitrary prescribed hole set, together with its equality and stability theory and its
> specialization to a prescribed conic for ordinary arcs.

The bibliography gives the version of record as G. Korchmaros, G. P. Nagy, and T. Szonyi,
*Algebraic approach to the completeness problem for (k,n)-arcs in planes over finite fields*,
Journal of Combinatorial Theory, Series A 204 (2024), 105851,
doi:`10.1016/j.jcta.2023.105851`, arXiv:`2302.10162`.

## Source and forward-citation check

- Primary theorem: the cached arXiv source `arXiv:2302.10162`, Theorem 7.5 and its introduction.
  Cached PDF SHA-256 `32cfd5b1cb4f28c171418f61d467fc0accee8adc269ae9cf36a517158917b6b7`,
  361,592 bytes. The version of record and publisher abstract state the same localized-uncovered
  conclusion.
- Version/correction boundary: arXiv lists only version 1, submitted 20 February 2023. The checked
  publisher and repository metadata identify JCTA 204 (2024), article 105851 and the DOI above; no
  correction or retraction was found in those records as checked on 18 July 2026. This is a source
  check, not a claim that no future or unindexed correction exists.
- Forward citations: OpenAlex work `W4389697054` listed three citing works on 18 July 2026:
  Asgarli--Ghioca--Yip, *Plane curves giving rise to blocking sets over finite fields*
  (doi:`10.1007/s10623-023-01264-y`); Borges--Korchmaros--Speziali, *Plane curves with a large
  linear automorphism group in characteristic p* (doi:`10.1016/j.ffa.2024.102402`); and
  Bartoli--Timpanella, *Complete (k,q+1)-arcs in PG(2,F_(q^6)) from the Hermitian curve*
  (doi:`10.1007/s10801-025-01456-w`). The latter explicitly treats the Hermitian continuation of
  the cited paper. None of the checked records supplies a correction to the rational-BKS
  proper-subplane statement. OpenAlex is an indexing aid, not an exhaustive priority certificate.

## Downstream code-language audit

The committed C329 theorem already calls the family collision-free without claiming relative
coverage. C330 proves it is not complete outside the prescribed conic and explicitly limits the
obstruction to the four full constant-height carrier architecture.

The completed C337 theorem proves recognition, recovery of a complete invariant, equivalence, and
non-GRS structure; it makes no inference from arc completeness to code nonextendibility. Its phrase
“completeness of `I(A)`” refers to completeness of the recovered invariant, not completeness of the
arc. The live C348 specification asks for exact syndrome multiplicities, the deep-hole locus, and
the MDS-extension complex of the C329 family; it credits the generic deep-hole/extension dictionary
as prior art and does not claim the first subgeometry-localized deep-hole family. Those boundaries
must remain in any eventual C348 theorem statement.

## Evidence boundary

This task changes literature positioning only. It reopens no theorem, computation, certificate, or
Lean gate. Search and citation indexes were used to locate and cross-check sources, never as proof
of novelty from absence.
