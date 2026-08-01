# Source catalogue: finite geometry and coding theory

## FG-2025-Hirschfeld-Thas

James W. P. Hirschfeld and Joseph A. Thas, *Arcs, Caps and Generalisations in a
Finite Projective Space*, Mathematics 13 (2025), article 1489.

- Stable ID: DOI `10.3390/math13091489`; arXiv `2503.06243`.
- Source: https://doi.org/10.3390/math13091489
- Kind: recent survey containing an explicitly numbered problem list.
- Scope: arcs, caps, ovals, hyperovals, ovoids, pseudo-ovals,
  pseudo-hyperovals, pseudo-ovoids/eggs and generalized quadrangles.
- Read depth: `partial`, published version, all numbered problem statements
  and their immediately preceding results inspected.  Cached as
  `10.3390/math13091489`, SHA-256
  `396813d44aebabc5a6a54520eaaafd9bee28dfbc3b701fae3ed3e1ba8a5f3f1e`.

The survey numbers sixteen visible statements as Problems 1--14 and 16--17
(there is no visible Problem 15 in the published text):

1. classify ovals and hyperovals for even field order;
2. determine all ovoids in `PG(3,q)` for even `q`;
3. decide whether every pseudo-oval and pseudo-hyperoval is regular;
4. decide whether every odd-characteristic pseudo-oval is isomorphic to its
   translation dual;
5. remove or weaken the prime/exponent and regular-spread hypotheses in a
   pseudo-oval regularity criterion;
6. decide whether every pseudo-oval on `E(5,q)`, `q` odd, is a pseudo-conic;
7. decide whether every even-characteristic pseudo-ovoid is regular;
8. decide whether every such pseudo-ovoid is isomorphic to its translation
   dual;
9. test whether containing a regular pseudo-oval forces regularity;
10. test whether every pseudo-ovoid or its translation dual is good;
11. test whether every good even-characteristic pseudo-ovoid is regular;
12. determine whether the field in the nonclassical odd-characteristic good
    case must have characteristic three, and classify the remaining case;
13. improve the stated large-field regularity inequality;
14. decide whether eggs `O(n,m,q)` with odd `q` and `m != 2n` exist;
16. settle the exceptional `K=F_2` case in the stated rank-two BN-pair
    characterization;
17. decide whether every weak generalized ovoid is a generalized ovoid.

## COD-PRS-deep-holes

Jun Zhang and Daqing Wan, *On Deep Holes of Projective Reed--Solomon Codes*,
arXiv `1605.02423`.

- Source: https://arxiv.org/abs/1605.02423
- Kind: canonical problem statement rather than a recent list.
- Scope: covering radii and classification of deep holes of projective
  Reed--Solomon codes.
- Read depth: `partial`, introduction and conjecture discussion inspected.
  Cached SHA-256
  `52ae5e2b988f8845d39339eb95a8c853378b7d3e427b9c4e72eb35802def38c2`.

The two stated frontiers are: determine the PRS covering radius (a special
case of the MDS conjecture), and, where the radius is known, determine all deep
holes.  The paper emphasizes that enumeration becomes difficult below
`k=q-3`.  This source is retained because current 2024--2026 deep-hole papers
continue to describe the classification problem as fundamental.

## COD-MDS-extension-dictionary

Krishna Kaipa, *Deep holes and MDS extensions of Reed--Solomon codes*, arXiv
`1612.05447`.

- Source: https://arxiv.org/abs/1612.05447
- Kind: precise bridge between PRS covering radius, deep holes and the MDS
  extension problem.
- Read depth: `partial`, introduction and the equivalence statements inspected.
  Cached SHA-256
  `1fe8de83c0b8cd3938e1a450fd49f376de795d7a317f099a730c63ab968178a4`.

The source makes the MDS-extension equivalence conditional on covering radius
`n-k` and explicitly explains why it fails when the radius is `n-k-1`.  This
distinction controls the negative MDS verdict in `plausible-bridges/mds.md`.

## FG-order-ten-certificates

Curtis Bright, Kevin K. H. Cheung, Brett Stevens, Ilias Kotsireas and Vijay
Ganesh, *Nonexistence Certificates for Ovals in a Projective Plane of Order
Ten*, arXiv `2001.11974`.

- Source: https://arxiv.org/abs/2001.11974
- Kind: proof-carrying computational precedent for finite-plane nonexistence.
- Read depth: `abstract/metadata only`.

The work combines cube-and-conquer, programmatic SAT and nauty symmetry
reduction, producing independently checkable certificates.  It concerns ovals
in the already excluded order-10 case, not order-12 nonexistence.

## COD-2025-twisted-deep-holes

Weijun Fang, Jingke Xu and Ruiqi Zhu, *Deep Holes of Twisted Reed--Solomon
Codes*, arXiv `2403.11436`, published in Finite Fields and Their Applications
in 2025.

- Source: https://arxiv.org/abs/2403.11436
- Kind: recent state-of-frontier research paper.
- Scope: covering radius and complete deep-hole classification for ranges of
  full-length twisted Reed--Solomon codes.
- Read depth: `abstract/metadata only`, arXiv abstract.
- Status: lead only; use to update the current boundary, not as a general list.

## LRC-2025-Haymaker-Malmskog-Matthews

Kathryn Haymaker, Beth Malmskog and Gretchen Matthews, *Algebraic hierarchical
locally recoverable codes with nested affine subspace recovery*, Designs,
Codes and Cryptography 93 (2025), 111--132.

- Source: https://doi.org/10.1007/s10623-024-01510-x
- Kind: recent paper with explicit future questions.
- Scope: hierarchical locality, availability and flexible recovery sets.
- Read depth: `partial`, abstract, introduction and publisher-visible open
  question inspected.

The source says that bounds fully capturing flexible hierarchical recovery and
availability remain open.  Exact parameterization of that question is still
to be extracted before crosswalk use.

## COD-2025-Oberwolfach

*Coding Theory*, Oberwolfach Report 41/2025.

- Source: https://oa.tib.eu/renate/server/api/core/bitstreams/6d00cace-d453-4f8d-b2e8-d6361ec0746f/content
- Kind: workshop report collecting current questions and emerging directions.
- Scope: broad contemporary coding theory.
- Read depth: `abstract/metadata only`, report metadata and overview.
- Status: lead only; individual problem extraction pending.
