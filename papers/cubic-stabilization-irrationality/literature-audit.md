# Literature audit

Date: 2026-08-14

Scope: theorem and source-characterization audit for the claims used in the
manuscript. This is not an exhaustive citation-graph or novelty search.

## Source ledger

| Key | Version and cache identity | Read depth | Manuscript use | Boundary |
|---|---|---|---|---|
| Gu--Yu--Yu | arXiv:2508.15770v1; cache key `arXiv:2508.15770`; SHA-256 `9c00f826cb13ad243bd2ad126e74733cacf650a385160a11adc785693c01a358` | Introduction; Sections 3.5--3.6, 4.3--4.4, 5.1--5.5, 6.1--6.2; Lemma 3.27; Propositions 4.21, 5.2, 5.9; Lemmas 5.8, 5.10, 5.13; Theorems 5.5, 6.2 | Formal QDM decomposition, completed-source Fourier isomorphisms, common-point lift, Fourier covariance, mirror-coordinate specialization | Formal Laurent/completed comparison; no Gamma/Stokes theorem |
| Shen--Shoemaker | arXiv:2502.08762v2; cache key `arXiv:2502.08762v2`; SHA-256 `2c1d25490d53d1eb04da11e4ad8eec2d9834b25e765462186181292e7f085cce` | Full dependency audit of Theorems 1.2, 1.4, 9.14; Sections 4, 7--9; Appendix A | Conditional identification of ambient/wall Gamma asymptotic spans; sector conventions | Extremal fixed-parameter asymptotics; discrepancy-one printed proof needs the separately prepared correction; not a common full-Novikov sectorial realization |
| Iritani | arXiv:2307.15938; cache key `arXiv:2307.15938`; SHA-256 `462f2e0d6eff6315d9fcc2e0db78f95f14558d532d118e31b74f2270c2e0ab8a` | Full 18-page survey, especially Sections 1.2--1.3 | Gamma integral section, product/Euler pairing conventions, point-row normalization | Survey/theorem source for framing; does not prove the wall comparisons in this paper |
| Iritani global toric mirror | arXiv:1906.00801v2; cache key `arXiv:1906.00801`; SHA-256 `dc25e5cbd849ee5daa7643d69ae2e77936d5cd343ceb66ce8bbd8e03fbf874c7` | Theorems 1.3, 4.8, 7.5, 7.25, 7.31, 7.33 and the weak-Fano toric blowup specialization | One global Brieskorn module, chamber mirror isomorphisms, and Gamma-framed ambient/residual comparison in the toric calibration | Supplies an intrinsic one-object toric model; the blowup direction is nonneutral, and the source does not identify a projective rank-one cobordism's Woodward clutching tails in a fixed common input frame |
| Lee--Lin--Qu--Wang | arXiv:1401.7097; cache key `arXiv:1401.7097`; SHA-256 `eeb1d87ae279a04c0ce5e9df66ce820aa87443fa6494f21d24269891a905b19c` | Theorem 0.1.1; Sections 1.2--1.3; quotient-class continuation conventions | Ordinary-flop graph gauge, pairing and quantum-product continuation, analytic extremal/formal transverse coefficient ring | Ancestors and primary theory, not full descendant invariance |
| Reichelt--Schulze--Sevenheck--Walther | arXiv:2004.07262; cache key `arXiv:2004.07262`; SHA-256 `4ec2933d806effbfa4cef9301348e0f6649c949830fa951b0c84944b40bdbdf8` | Definition 5.6 and discussion of the four-term comparison; relevant non-affine mirror summary | Localized partial Fourier--Laplace and loss of free constant modules | Does not identify the two-wall point row |
| Špenko--Van den Bergh | *Advances in Mathematics* 402 (2022), 108307, DOI `10.1016/j.aim.2022.108307`; arXiv:2007.04924; cache key `arXiv:2007.04924`; SHA-256 `73dffed6c948ac1dd48de1bab994a09e55e875b29dc69473d1d5d6d1e324fd0d` | Main schober/GKZ comparison and quasi-symmetric hypotheses | Scope paragraph on categorical window markings | Quasi-symmetric, nonresonant setting; no discrepant confluence theorem used |
| Acosta--Shoemaker | arXiv:1604.03491v2; cache key `arXiv:1604.03491`; SHA-256 `c9762c933a64ea3d415bd1ad955f673d6d8e24a7c130a573fbd96d7aeb6bbd94` | Main discrepant toric continuation statements and complete-intersection compatibility | Scope paragraph on general toric asymptotic continuation | No general Gamma/window-calibrated two-wall point-row theorem |
| Woodward | arXiv:1408.5869v7; cache key `arXiv:1408.5869`; SHA-256 `5aa794f4d83dd8d127aab769d95a71a4691d7a35d220e81ca73c5b8bb360ea51` | Corollary 9.10; equations (54), (56)--(59), Definition 9.13, equation (68); rotation-localization, clutching, and adiabatic-limit sections | Exhaustive rotation-fixed graph loci, virtual-normal splitting, clutching factors, localized gauged maps | Does not state constancy of the fixed obstruction theory along an affine clutching tail or marked compatibility across its finite thresholds; fixed-locus classification is coefficientwise at sufficiently large area |
| Woodward II | arXiv:1408.5864v4; cache key `arXiv:1408.5864`; SHA-256 `018530b8cc031ab5020120259ee0f4eca0688829c79076d0d603cb76f91d349c` | Examples 5.23 and 5.25; toric quotient and gauged-map constructions | Rank-two affine presentation of \(\mathbf P^2\) and its point blowup; explicit common marked equivariant input | The affine presentation is not the manuscript's rank-one cobordism, and the source supplies no quantum reduction-in-stages identification of the two clutching theories |
| Gonzalez--Woodward | arXiv:1208.1727v7; cache key `arXiv:1208.1727`; SHA-256 `2c99203c8e1d7dd373112629bbfac0760e7a3812d348e9110a1eb2b894d9d84c` | Proposition 3.15(c), Lemma 3.17, Proposition 3.18, Theorem 1.17, Remark 4.7, virtual Kalkman formula | Marking/node support on wall-fixed loci, polarization localization, and the distributional crepant boundary | Crepant equality is only almost everywhere modulo delta derivatives and explicitly does not supply analytic continuation without convergence |
| Aleshkin--Liu | arXiv:2301.01266v1; cache key `arXiv:2301.01266`; SHA-256 `921af8ed2105d6a511c0cf485550a263e222983c6fcc628b44c838bb3d8de81f` | Definition 5.18, Theorem 5.21, Remark 5.4 and surrounding Mellin--Barnes construction | Linear abelian GLSM model for balanced contour continuation | Requires linear charge data, adjacent secondary-fan chambers, a circuit, Calabi--Yau balance, and a grade-restriction window; it does not prove the nonlinear virtual extension |
| Coates--Iritani--Jiang | arXiv:1410.0024v2; cache key `arXiv:1410.0024`; SHA-256 `a9f3b7222b3c85e9dcd5bd6f2c008a68a9dc18aa3682ac2ad480154f209e53cc` | Theorems 6.1, 6.3, 6.13, 6.19, 6.23 and the global quantum-connection construction | Neutral toric one-object continuation, pairing/grading compatibility, and Gamma/Fourier--Mukai transport of the common-open point row | Linear toric crepant wall; does not supply zero-mode reduced nearby cycles or a comparison for every projective Wlodarczyk master |
| Cai | arXiv:2608.01577v1; cache key `arXiv:2608.01577`; SHA-256 `06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e` | Full paper, especially Section 3 and Proposition 6 | Cubic small-connection matrices, primitive-sixth block, and big/small flatness | The manuscript reconstructs the indicial polynomial and independently computes the Gamma point coefficient; Cai is not used in the birational transport theorem |
| NIST DLMF | Section 16.11, equations 16.11.2 and 16.11.8; official web reference accessed 2026-08-14 | Generalized-hypergeometric algebraic asymptotic coefficients | Two nonzero Barnes coefficients for the cubic point period | Standard analytic source; branch phases affect only nonzero scalar factors |
| Rudd epilogue | Zenodo DOI `10.5281/zenodo.21909944`; current companion preprint | Main dimension-four theorem and universal-CH0 examples | Independent `X × P^1` comparison and cycle-theoretic context | Logically separate proof; not used in the all-`m` transport argument |
| Wlodarczyk | arXiv:math/9904074v1; cache key `arXiv:math/9904074`; SHA-256 `ac86c460c3a039284565630ef63a77028af53a71697d4d0deb356574d2b3aa9c` | Propositions 1--2, Lemmas 4, 9, 11, Theorems 1--3, definitions and local quotient example | Scope of birational cobordism and finite-quotient chamber singularities | Smooth master does not force smooth chamber quotients |
| Abramovich--Karu--Matsuki--Wlodarczyk | arXiv:math/9904135; cache key `arXiv:math/9904135`; SHA-256 `55bbc2c58f29d4b9dbe965035f80f3844f6968eaf98076ac625132ac3b3977a5` | Theorems 0.1.1, 0.3.1, 2.3.1, 2.6.2, 2.7.1 and surrounding quotient/subdivision lemmas | Scope of locally toric wall quotients and the cost of desingularizing them | Smooth weak factorization replaces walls by actual blow-ups/down |

## Inference boundaries checked

1. The Gu--Yu--Yu point theorem asserts only the ambient coordinate.
2. The simple-wall primitive-sixth corollary is conditional on a common
   sectorial realization.
3. The ordinary-flop proof is a new one-column consequence of the published
   connection comparison; it is not attributed to a descendant theorem.
4. The incomplete-Gamma and Weyl-algebra calculations are proved directly
   and are not presented as geometric quantum examples.
5. The local two-wall result remains an implication from a named factorwise
   hypothesis. The global conditional criterion bypasses, rather than proves,
   that local hypothesis.
6. No cited factorization theorem is used to claim that every intermediate
   chamber remains smooth projective. The global proof forms quantum
   D-modules only at the two smooth endpoints.
7. The manuscript proves coefficientwise Gamma-ratio reduction and identifies
   the rank-one derived clutching stacks along every tail, yielding
   clutching-tail holonomicity. Marked threshold compatibility is the remaining
   analytic hypothesis requiring isomorphisms of the cyclic Rees
   z-modules which intertwine formal monodromy and carry the point row.
8. Cai is not cited for point-row nonvanishing. His matrices and flatness
   identify the cubic block; the point coefficient is derived from the
   hypergeometric Barnes expansion in the manuscript.

## Priority boundary

No exhaustive novelty search was undertaken and the manuscript makes no
negative novelty claim. Any claim of firstness or absence from the literature
is outside this audit.

## Published-metadata corrections

The bibliography was checked against the publisher records on 2026-08-13.
In particular, Acosta--Shoemaker is *IMRN* 2020(20), 7037--7072,
doi:10.1093/imrn/rnz001, and Reichelt--Schulze--Sevenheck--Walther is
*Beitr. Algebra Geom.* 62(1), 137--203,
doi:10.1007/s13366-020-00560-1.
