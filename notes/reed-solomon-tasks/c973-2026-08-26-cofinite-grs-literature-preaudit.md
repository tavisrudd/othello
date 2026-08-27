# C973 checkpoint — cofinite GRS top-shell literature preaudit

**Lane:** `reed-solomon` · **Date:** 2026-08-26 · **Status:** scoped preaudit,
not a novelty verdict

## Claim under audit

For a redundancy-`r` GRS code supported on
`P1(F_q)\A`, with fixed `s=|A|`, C973 now proves in its pointed field range:

1. every syndrome outside `P_r union M^max_(r,p)` has coset-leader weight at
   most `r-2` and has many explicit locators avoiding `A`; and
2. if `p>r-1`, the complete weight-`r` and weight-`r-1` shells and their
   counts are those in
   `c973-2026-08-26-cofinite-grs-transfer.md`.

The affine deep shell itself is excluded from novelty consideration: it is
classical in this high-rate range.  The only claims needing a novelty audit
are the arbitrary-`r` next-to-deep shell, its cofinite-support count, and the
constructive `r-2` separation.

## Primary-source comparison completed in this pass

| source | access actually read | overlap | boundary |
|---|---|---|---|
| Seroussi--Roth, *On MDS Extensions of Generalized Reed--Solomon Codes* (IEEE TIT 32 (1986), Thm. 1 and Cor. 2) | primary PDF, abstract, definitions, Theorem 1, geometric restatement, and Corollary 2 with proof | exact deep-shell input: in the high-rate range an MDS extension column is precisely a missing Veronese column, apart from the even `k=3` nucleus exception | does not give the weight-`r-1` shell or an `r-2` locator outside a carrier |
| Xu--Hong--Xu, *On deep holes of generalized projective Reed--Solomon codes*, arXiv:1705.07823, current 2026 version | primary arXiv full-text rendering, abstract, introduction, Theorems 1.4--1.7, and the displayed proof endpoint for Theorem 1.4 | deleted evaluation sets; degree-`k` and reciprocal received-word families characterized by subset-sum/product conditions | degree-specific families, not an all-syndrome cofinite top-two-shell enumerator |
| Li--Wan, *Distance Distribution in Reed--Solomon Codes* (2019) | primary PDF, abstract, introduction, Theorem 1.2, scope of the main counting theorem, and the distinct-root character-sum setup | standard affine RS distance/list distribution for a fixed received polynomial; asymptotic formulas and root counts | not an exact coset-leader shell classification for arbitrary syndromes or bounded projective deletions |
| Blokhuis--Pellikaan--Szoenyi, *The extended coset leader weight enumerator of a twisted cubic code* (2022) | primary arXiv full-text rendering, abstract, Sections 1--2, statement of the codimension-four scope, and conclusion | exact coset-leader enumerator for the full `q+1` support in codimension four; establishes that shell enumeration is a recognized invariant | fixed codimension four and unpunctured support, not arbitrary `r` or cofinite support |
| Riasat--Mahdavifar, *Efficient Covering Using Reed--Solomon Codes*, arXiv:2502.01984 | primary arXiv full-text rendering, abstract, introduction, covering setup, and algorithm scope | recent constructive covering via successive puncturing and standard decoders; average covering performance | guarantees a word within the redundancy bound, not exact top shells or proof-carrying `r-2` witnesses |

## NMDS-extension refinement from the Tao pass

The identity

\[
d(\ker[H_S\mid f])=d_S(f)+1
\]

turns the same claim into a classification of projective one-column
extensions: the deep shell is MDS, the next shell is NMDS (the dual defect is
also one), and the remaining columns have Singleton defect at least two.
Kaipa, arXiv:1612.05447, explicitly supplies the deep-hole/MDS one-digit
dictionary, but not the NMDS classification.  The targeted NMDS comparison
also checked Bartoli--Davydov--Marcugini--Pambianco, arXiv:1609.05657;
Li--Sun--Zhu, arXiv:2401.04360; and the 2026 Wang--Chen--Yan preprint,
arXiv:2605.23329.  The latter two construct and analyze different non-GRS or
twisted-GRS MDS/NMDS families; neither abstract states the ordinary cofinite-
GRS single-column classification here.

This remains a scoped negative comparison.  It licenses the MDS/NMDS
reframing, not a novelty adjective.  A final audit should search the terms
`almost MDS extension`, `near MDS extension`, `single-element extension`, and
`NRC defect-one extension` through those citation graphs.

## Search boundary

Targeted searches were run for combinations of:

* `punctured generalized Reed Solomon` with `coset leader enumerator`;
* `normal rational curve` with `coset leader`;
* `near deep holes` and `second covering radius` with Reed--Solomon; and
* punctured NRC distance partitions.

They recovered the fixed-codimension full-support enumerator literature,
general distance-distribution work, deep-hole/subset-sum papers, and recent
algorithmic covering papers.  They did not surface an arbitrary-redundancy
cofinite-support theorem matching the C973 `r-1` shell.  This is a negative
search result only, not evidence of absence.

## Positioning verdict licensed now

The paper successor may safely say:

* GRS covariance is elementary monomial equivalence;
* the full-affine and bounded-deletion deep shell in the displayed high-rate
  range follows from Seroussi--Roth;
* C973 strengthens that input by locating the entire next-to-deep shell and
  constructing abundant witnesses below it.

It may not yet say `new`, `first`, `previously unknown`, or `complete
enumerator beyond codimension four`.  A final audit must still follow the
citation graph of the fixed-codimension enumerator papers, search finite-
geometry work on deleting points from NRCs, and compare the exact shell count
against generalized/projective RS coset-weight papers not indexed by the
queries above.

The current manuscript bibliography and audit pin `XuHongXu2017` to arXiv
version 1 and mark it abstract/metadata only.  The present preaudit read the
current 2026 arXiv rendering.  A paper successor that cites a load-bearing
statement from that source must reconcile the version metadata and upgrade
the literature-audit access row; it must not silently treat this preaudit as
the manuscript's completed source audit.

## Highest-EV literature gate for the paper successor

Audit one precise statement, not the whole transfer package:

> For `r>=6`, `p>r-1`, and cofinite support `P1(F_q)\A`, the projective
> syndrome directions of coset-leader weight `r-1` are exactly the tangent,
> conjugate-secant, and `A`-incident split-secant interiors, with count
> `q(q+1)^2/2+(q-1)s(2q+1-s)/2`.

If prior art contains this statement, the theorem remains valuable as a
length-neutral unification and constructive proof.  If it does not, this is
the cleanest new GRS-facing headline; the affine deep-hole statement should
still be presented as classical.
