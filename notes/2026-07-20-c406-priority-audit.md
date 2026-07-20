# C406 priority audit — matching factorizations, cubic sheet memory, and depth--Fourier bridge

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `STRONG COMPOSITE RESULT; CLASSICAL FACTORIZATION/DESIGN LAYER PRE-EMPTED; CONIC-QUOTIENT CUBIC MECHANISM LIKELY NEW WITHIN BOUNDED COVERAGE`

## Executive conclusion

This audit records **six distinct sources at full-text depth**. Three were read completely in
this pass (Filmus--Lindzey, Chien--Kang, and Bamberg--Klawuhn); Edge, Dye, and
Lansdown--Martin had already been read completely in the C399/C378 audits, and their
load-bearing passages were reread for this audit. Six further sources were read at partial or
abstract/metadata depth. Cache verification covered 164 entries with zero hash problems.

The priority boundary is sharper than C406's original bounded screen. The raw combinatorial
layer is substantially classical:

- Edge owns the `A3` synthematic total and the two `H3` sets of eleven Clebsch hexagons,
  including their exchange by the outer conic coset.
- Cameron--Korchmaros classify the doubly transitive one-factorizations relevant here: the
  `K_6` and `K_12` sporadic examples and, for `K_8`, the affine line-parallelism family.
- Bamberg--Klawuhn now explicitly place one-factorizations and their generalizations inside the
  perfect-matching association scheme as Delsarte designs. Thus neither “the sheets are
  one-factorizations” nor “one-factorizations are matching-scheme designs” is available as a
  novelty claim.
- Pan--Wu--Yin identify the same `PGL_2(11)/A5` 22-point coset action with the bipartite
  Hadamard incidence/nonincidence orbital graphs and record `A4` and `D10` stabilizers for
  incident and nonincident cross-sheet pairs. Thus the appearance of the common `A4` and the
  coarse `5+6` cross-sheet split are also classical.

What survives is the *composition with the conic-ideal factorization map*. No located source
forms canonically scaled ternary secant products, divides their differences by the conic equation,
identifies the resulting finite-field harmonic/radial image, reconstructs the two sheets as the
unique balanced halves in first and second tensor moments, or obtains a first nonzero cubic
relative invariant and the associated plane tensor syzygies. No located source gives C406's exact
`22 -> 6 -> 2 -> 1` scalar-`A4` depth-profile lattice or its explicit map into C378's oriented
Fourier sector. These are **likely-new compositions within the recorded coverage**, not
unrestricted priority claims.

The strongest paper-facing crown is therefore not a new one-factorization or a new matching
design. It is:

```text
classical exceptional one-factorizations
  + the C403 conic-ideal secant-product quotient
  + exact balanced-half reconstruction
  + cubic-first orientation and plane syzygies
  + the H3 scalar-A4 depth--Fourier bridge.
```

The three-dimensional relative-invariant space, failed polarization/singular-locus recovery,
and scalar-weight obstruction are valuable positioning and scope controls. They are not novelty
headlines.

## Claim-by-claim disposition

The four disposition fields are intentionally separate. “Likely new” always means “no
predecessor located in the bounded coverage below.”

| C406 finding | Classical ownership | Likely-new composition | Exact pre-emption / limitation | Unresolved priority |
|:---|:---|:---|:---|:---|
| **Uniform `A3/B3/H3` matching-factorization interface** | Edge gives the `A3` synthematic total and the two `H3` eleven-hexagon systems. Cameron--Korchmaros classify the corresponding highly symmetric `K_6`, affine `K_8`, and sporadic `K_12` one-factorizations. Bamberg--Klawuhn place one-factorizations in the perfect-matching association scheme. | The simultaneous identification of each Coxeter-parent coset with its unique invariant matching, together with the exact canonical secant-product restriction and the use of that interface as input to one conic-quotient theorem, was not located. | The factorization sheets themselves, their edge law, and the statement that they are matching designs are not new. The `5,14,22` marker spaces are already Edge/Dye territory. | The exact uniform parent-to-matching normalization may be new, but should be presented as infrastructure for the quotient theorem, not as an independent discovery. |
| **Harmonic/radial factorization-difference module** | Harmonic presentations of functions on the full perfect-matching space are developed by Filmus--Lindzey using edge variables and vertex-sum differential operators. Classical conic representation theory supplies harmonic/radial decompositions of ternary forms. | C406's map `Phi(M)=(P_M-P_0)/Q`, its exact images `H_d` or `H_d+F_q Q^(d/2)`, ranks `3,6,10`, and restricted `S4/S4/A5` module decompositions are a different construction and were not located. | “Harmonic polynomials on perfect matchings” is occupied terminology. C406 must say **conic-ideal harmonic quotient of secant products**, not imply discovery of matching harmonic analysis. | Medium confidence. The exact small-field composition survived all fingerprint searches, but a broad modular-invariant literature closure was not performed. |
| **Balanced-half reconstruction** | Group-orbit and Delsarte design theory characterizes low moments or dual-degree vanishing in general. Bamberg--Klawuhn characterize matching subsets that are `lambda`-factorizations; Chien--Kang classify real spherical two-design group orbits. | Among the `2q` quotient points, the two `PSL_2(q)` sheets being the **only** complementary `q`-subsets with equal first and second tensor moments is an exact finite reconstruction theorem not found in those sources. | This is not a general classification of nonlinear sheet statistics and not an all-field theorem. It is an exhaustive `B3/H3` statement in the frozen quotient configurations. | High-value likely-new finite theorem. Priority remains qualified because the design-trade and modular-orbit literature was only boundedly screened. |
| **Minimal signed moment degree and plane tensor syzygies** | Vanishing moments are standard design language; Chien--Kang treat first/second moments of real group orbits. Classical trades equate incidence counts through a fixed strength, as in Ghorbani--Kamali--Khosrovshahi--Krotov. | The characteristic-`p` signed sheet measure with `mu_1=mu_2=0`, `mu_3 != 0`, its base independence, and the identities between the two sums of `q` secant-product factorizations before conic restriction were not located. The symmetric-square identity and cubic `Q^(symmetric 3) mu_3` identity sharpen the result beyond design terminology. | “Cubic is minimal” is safe only for signed power-sum/tensor moments and their linear functionals. It does not rule out every nonlinear statistic. Calling the object a classical `t`-trade without qualification would be misleading: the blocks here are quotient vectors over `F_q`, not subsets of one ground set. | This is the strongest likely-new seam. A dedicated modular cubature/design-trade audit could improve confidence, but the exact conic/factorization fingerprint is highly distinctive. |
| **`PSL_2` tensor stabilizer and `PGL_2` projective-line stabilizer** | The determinant-square character, index-two restriction, and the general fact that an anti-invariant tensor is fixed by the kernel and its line by the full group are elementary relative-invariant theory. | The particular nonzero `mu_3` obtained from the two factorization sheets realizes this character inside the conic stabilizer; that realization was not located. | Do not claim a new general stabilizer theorem, and do not claim the full `GL(W)` stabilizer. The statement is internal to `G=PGL_2(q)`. | Likely new as an interpretation of the C406 tensor; modest standalone priority because the group-theoretic deduction is formal once `mu_3` is known. |
| **Uniform `A3` nonsplitting explanation** | Restriction of a transitive `G/H` action to an index-two normal subgroup splits exactly when `H` lies in that subgroup. Edge/Dye already expose the `PSL/PGL` orbit boundary. | Packaging `A3/B3/H3` as “one orbit exactly when the parent is not contained in `PSL_2`, two sheets otherwise” is a clean uniform synthesis. | This is not a new group theorem. In particular, the order obstruction to `S4 < PSL_2(5) ~= A5` is immediate. | Manuscript-useful but low novelty; state as the conceptual explanation of the observed exception. |
| **Three-dimensional outer-odd relative-invariant space; polarization and singular negatives** | Finite-group invariant theory and classical `PSL_2(11)`-invariant cubics create a broad terminology collision. The Klein cubic threefold is unrelated: it is a complex cubic in five variables, not C406's characteristic-eleven cubic tensor on the ten-dimensional quotient image. | Exact dimension `3` for the `PSL_2(q)`-fixed, outer-odd part of `Sym^3(W)` in both `B3/H3`, plus the frozen contraction, flattening, and gradient data, appear to be new computations about this representation. | Uniqueness fails; contraction does not split H3's `4+5`; the naive quotient-point singular-locus recovery fails. These are bounded negative results, not priority claims. | Positioning only. A conceptual character calculation for the dimension three would strengthen exposition, but it would not restore uniqueness. |
| **`22 -> 6 -> 2 -> 1` double-coset information lattice** | Cosets, double cosets, and subgroup-orbit fibres are classical. Edge/Dye own the `22 -> 2 -> 1` conic-marker/sheet/conic layers. Pan--Wu--Yin identify `PGL_2(11)/A5`, its Hadamard incidence/nonincidence orbital graphs, the valencies `5,6`, and cross-sheet pair stabilizers `A4,D10`; hence the common `A4` and coarse incidence split are pre-empted. | Identifying **all six** `A4`-orbits with the six depth fibres, equivalently the full relevant `A4\PGL_2(11)/A5` double-coset data, with sizes `1,4,6 / 1,4,6`, supplies the new exact intermediate level. | The lattice is for the **factorization-decorated** object. It does not show that the undecorated GRS child remembers a matching or chirality. Do not claim discovery of the `A4` intersection or the Hadamard orbital graphs. | Medium-high likely-new composition. A Hecke/double-coset derivation without enumeration is still open and would materially improve priority and portability. |
| **Scalar-`A4` depth profiles and golden singleton recovery** | Relation algebras and orbit refinements are standard; C378's rank-16 scheme itself has only bounded priority coverage. | The six displayed zero-depth vectors, their exact `1,4,6` fibres on each sheet, and the singleton pair that recovers the unordered golden matchings are explicit factorization-derived data not found in the literature screens. The two singleton fibres are exactly the frozen base matching and its `J`-mate. Thus they recover the unordered golden matching pair and, via C379, the unordered parent pair; choosing a sheet selects one member. | “Golden” is project terminology, not a literature-recognized object. The profile determines a scalar-`A4` matching orbit, not an individual matching outside the singleton fibres. Parent recovery consumes C379 and supplied factorization decoration. | Likely-new exact bridge data, but best sold as part of the C406/C378/C379 reconstruction chain rather than alone. |
| **Compressed cubic trade and exact profile plane** | Matching-scheme designs and ordinary trades are classical. | The positive profiles `v_1=(-6,0,12,-12)`, `v_2=(-3,3,0,3)`, and `v_3=(3,-2,-2,0)` span the exact two-dimensional `F_11` plane `2a+2b+c=0`, `9a+8b+d=0` and satisfy `v_1+4v_2+6v_3=0`. With opposite profiles on the other sheet, their pushed-forward signed tensor moments vanish in degrees one and two and are nonzero in degree three. This exact push-forward was not located. | It is a six-profile weighted identity, not a general trade classification. The profile span is **two-dimensional**, not three-dimensional; it must not be conflated with the three-dimensional outer-odd cubic relative-invariant space. | Likely new but secondary to the uncompressed balanced-half/cubic theorem. |
| **Explicit `J`-odd/C378 Fourier-sector bridge** | Translation association schemes, Fourier eigenmatrices, and fusion/refinement machinery are classical. Hollmann--Xiang treat conic-stabilizer association schemes; Lansdown--Martin treat fusion and MacWilliams/Galois behavior. | The map `D(M)` from zeros of the original degree-six secant product on four oriented C378 relation pairs, with `D(JM)=-D(M)` and hence `M_odd D(JM)=-M_odd D(M)`, is an explicit factorization-derived map into the certified Fourier-stable odd sector. No predecessor was located. | It is not a linear cubic-to-Fourier intertwiner, not an isomorphism, and `M_odd` does not permute the six raw profiles. C378 priority itself remains bounded. | High-value composition, medium priority confidence. A conceptual polar/incidence interpretation of `M_odd D(M)` remains open. |
| **Scalar-weight obstruction to a linear intertwiner** | Central-character mismatch and Schur's lemma are standard representation-theoretic obstructions. | Applying scalar weights `4` versus `0` to explain why every scalar-equivariant linear map from the quartic quotient module to the ordinary scalar-line relation algebra vanishes is a useful exact diagnosis. | This should not be advertised as a new theorem. It rules out that category of linear map, not nonlinear, zero-locus, twisted-character, or cocycle-valued bridges. | Settled as a scope boundary; it opens twisted Fourier theory but carries little independent novelty. |

## The 2026 matching-design correction

Bamberg--Klawuhn is the most important new source relative to the earlier C406 report. Its
Theorem 4.4 characterizes `lambda`-factorizations as Delsarte designs in the perfect-matching
association scheme, and Example 4.2 explicitly says that an `(n-1,1)`-factorization of index one
is a one-factorization. The paper also treats the `K_12` projective-line setting in Example 5.1,
although its displayed `AGL(1,11)` union is a different 33-matching `(4,2)`-factorization, not
C406's two eleven-matching sheets.

This source changes wording, not the mathematical C406 theorem:

- **pre-empted wording:** “the B3/H3 sheets form a new design on perfect matchings”;
- **safe wording:** “apply the conic-ideal secant-product quotient to the classical exceptional
  one-factorizations; their signed quotient images form a characteristic-`p` moment trade whose
  first nonzero tensor moment is cubic.”

Filmus--Lindzey creates the analogous terminology boundary for “harmonic polynomials on
perfect matchings.” Their variables mark graph edges and their harmonicity is annihilation by
vertex-sum derivatives on the full matching space. C406 instead maps a small Coxeter orbit of
matchings to ternary forms by multiplying secants and dividing by the conic equation. The two
constructions may ultimately be related representation-theoretically, but neither contains the
other as stated.

## Source ledger

Every named source has an explicit read-depth field. A cache entry proves only that bytes were
fetched; the readings are recorded here.

| Source | Read depth, access, and version | Load-bearing boundary |
|:---|:---|:---|
| W. L. Edge, *Conics and orthogonal projectivities in a finite plane* (1956), DOI `10.4153/CJM-1956-041-6` | **full text**; published 21-page PDF previously read completely for C399; Sections 19--21 and 30--32 reread in this audit. Cache key `10.4153/CJM-1956-041-6`, SHA-256 `07149c0f963d2b31016a0ad992ff6f0af6a77775a574a6c76aa3621b68e189ef`. | Owns the q=5 synthematic total, the q=11 two eleven-hexagon systems, outer exchange, and classical triangle-product identities. Does not form `(P_M-P_N)/Q` or signed tensor moments. |
| R. H. Dye, *Hexagons, conics, A5 and PSL2(K)* (1991), DOI `10.1112/jlms/s2-44.2.270` | **full text**; published pp.270--286 scan previously read completely for C399; OCR pp.272, 279--280, and 282 reread here. Reconstruction SHA-256 `6d48847949e2b37c3a87557df9fa4147c9b1305d8469c7c06965c62b99fcbf92`. The load-bearing passages had been checked against authoritative page images in C399; the current audit reused that verification rather than trusting OCR formulas independently. | Owns conic-group transitivity, `A5` stabilizers, `PSL/PGL` orbit splitting, and further relation geometry. Does not supply the quotient moment construction. |
| Yuval Filmus and Nathan Lindzey, *Harmonic Polynomials on Perfect Matchings* (2022) | **full text**; all 12 pages of the SLC/FPSAC version read in this audit. Cache key `SLC:86B.59`, SHA-256 `babc314c816261a989fac593967f94ac3716ea23dfc0134f0157a60c4743b47d`. | Canonical harmonic presentations on the full perfect-matching space using edge variables, matching inclusion matrices, Specht polynomials, and Jack characters. It fixes the terminology boundary but does not pre-empt C406's ternary conic quotient. |
| Kuan-Cheng Chien and Ming-Hsuan Kang, *Spherical 2-Designs from Finite Group Orbits*, arXiv:2508.12580v1 | **full text**; all 14 pages read in this audit. Cache key `arXiv:2508.12580`, SHA-256 `cfb6ce0fbc86f6192aee57cf63c70557eccc331a82d2615f99d52ed7d0f97800`. This is the v1 preprint, not a later published version. | Classifies real spherical two-design group orbits through isotypic second-moment conditions. Adjacent to balanced moments, but not characteristic-`p` signed halves or cubic-first separation. |
| John Bamberg and Lukas Klawuhn, *On the association scheme of perfect matchings and their designs*, arXiv:2507.00813v2 | **full text**; all 19 pages read in this audit. Cache key `arXiv:2507.00813`, SHA-256 `561101aa8a3d74e6e338ca0aa8908a9eaf10f7ded440febca284e4a61cbd31c7`. The read version is the 18 March 2026 preprint; published metadata for DOI `10.5802/alco.490` was consulted but the typeset published bytes were not separately read. | Explicitly characterizes generalized one-factorizations as designs in the perfect-matching association scheme. Strongly pre-empts generic matching-design language; does not use conic secant products or tensor moments. |
| Jesse Lansdown and William J. Martin, *Rational Delsarte designs and Galois fusions of association schemes* (2025), DOI `10.4153/S000843952510146X` | **full text**; published 20-page version previously read completely for C378; Proposition 3.2, Section 3.1, and the opening of Section 4 reread here. Cache key `10.4153/S000843952510146X`, SHA-256 `13498249e762f205bafe72735ec480152b0c76fb90546535da09be19740257b5`. | Fusion meet behavior, Galois action on idempotents, and Delsarte/MacWilliams consequences. It does not identify C378's geometric common refinement or C406's depth profiles. |
| Murali K. Srinivasan, *The perfect matching association scheme*, arXiv:1807.00481v1 | **partial**; cached preprint Introduction through the statements and discussion of Theorems 1.1--1.2 reread here. Cache key `arXiv:1807.00481`, SHA-256 `d6cc59c76758dc33a4bbaed145fa27e20df39e94727632b431ea7eb7ef9acb8b`. | Multiplicity-free complex matching scheme, orbital eigenvalues, and symmetric-function machinery. Does not address the restricted modular Coxeter orbits or conic quotient. |
| E. Ghorbani, S. Kamali, G. B. Khosrovshahi, and D. S. Krotov, *On the volumes and affine types of trades*, arXiv:1810.02296v2 | **partial**; abstract, Introduction, definitions of `[t]`-trades, and scope/conclusion of the introductory section read. Cache key `arXiv:1810.02296`, SHA-256 `36cffc0509d205117fa339fde93046cd8f2bcc4eadbb3a9a4b70e47e286ae20b`. | Classical subset-block trade language and Boolean-function correspondence. It does not treat vector-valued tensor moments over finite fields. |
| Henk D. L. Hollmann and Qing Xiang, *Association schemes from the action of PGL(2,q) fixing a nonsingular conic in PG(2,q)*, arXiv:math/0503573v1 | **partial**; abstract, Introduction, and construction/scope statements for the conic-line coherent configurations and their fusions read. Cache key `arXiv:math/0503573`, SHA-256 `c7da1c736b1d229228f74cbcc22a77dd848a512e206c1cb88462fc3fd513ab4b`. | Classical conic-stabilizer association schemes on non-tangent lines. It does not contain scalar-`A4` factorization depth profiles. |
| Jiangmin Pan, Cixuan Wu, and Fugang Yin, *Edge-primitive Cayley graphs on abelian groups and dihedral groups* (2018), DOI `10.1016/j.disc.2018.08.023` | **partial**; official ScienceDirect HTML, abstract, Introduction, Example 3.1, and Lemma 3.2 read. The open-archive PDF endpoint returned HTTP 403, so no cache key/hash is available; access was through the publisher's rendered primary text. | Example 3.1 uses `X=PGL(2,11)`, `H=A5`, and the 22 cosets, while Lemma 3.2 gives Hadamard incidence/nonincidence valencies `5,6` and pair stabilizers `A4,D10`. It pre-empts the coarse orbital/A4 core, not C406's six depth vectors, full `A4` orbit partition, profile plane, or compressed cubic moments. |
| Peter J. Cameron and Gabor Korchmaros, *One-factorizations of complete graphs with a doubly transitive automorphism group* (1993), DOI `10.1112/blms/25.1.1` | **abstract/metadata only**; official Oxford abstract and bibliographic page. Full PDF was paywalled in this session. | The abstract classifies the relevant affine and three sporadic highly symmetric one-factorizations and lists full automorphism groups, including `PGL(2,5)` and `PSL(2,11)`. This is enough for positive pre-emption of raw factorization novelty, but no negative claim rests on unexamined internal details. |
| Xavier Roulleau, *The Fano surface of the Klein cubic threefold*, arXiv:1001.4853 | **abstract/metadata only**; official arXiv abstract returned by the search service; no PDF fetched. | Used only to delimit the classical “`PSL_2(11)`-invariant cubic” terminology collision. No comparison beyond the five-variable complex Klein cubic setting is asserted. |

## Search record

### Exact queries

The following load-bearing web queries were issued verbatim. Search responses were screened over
title and snippet/abstract fields; promoted works received the individual read-depth entries above.

```text
"signed moments" finite field design trade
finite field point sets equal moments polynomial design trade
"moment vanishing" "finite field" group orbit
"first nonzero moment" design trade

"A_4" "PGL(2,11)" "A_5" double coset
"A4" "PGL(2,11)" "A5" orbits
"PGL(2,11)" "one-factorization"
"PSL(2,11)" one-factorization K12

"One-factorizations of the complete graph with a doubly transitive automorphism group" DOI
site:cambridge.org "One-factorizations of the complete graph" Cameron Korchmaros
site:combinatorics.org one-factorizations complete graph doubly transitive automorphism group Cameron Korchmaros
"10.1112/blms/25.1.1" pdf

PSL(2,q) relative invariant determinant character symmetric power finite field
"relative invariant" "PSL(2,q)"
"PGL(2,q)" relative invariants determinant square character
invariant cubic PSL(2,11) representation

Klein cubic threefold automorphism group PSL(2,11) paper DOI
site:arxiv.org Klein cubic threefold PSL(2,11) automorphism

"Harmonic Polynomials on Perfect Matchings" DOI Filmus Lindzey

perfect matching one-factorization equal first second moments finite field
"balanced half" perfect matchings moments
"one-factorization" cubic moment
"one-factorization" harmonic polynomial conic

"On the association scheme of perfect matchings and their designs"
site:arxiv.org "association scheme of perfect matchings" designs

"Edge-primitive Cayley graphs on abelian groups and dihedral groups"
"S0012365X18302814" PGL(2,11) A5 A4
"PGL(2,11)" "A_vw" A4 Hadamard design
"Example 3.1" "PGL(2,11)" "Hadamard design"
"A_vw" "PGL(2,11)" A4
"non-incidence graph" "PGL(2,11)" A4 D10
```

The corresponding eleven search batches returned, after the search service's own deduplication,
`29, 21, 17, 10, 38, 27, 16, 38, 13, 17, 3` result cards. Every card was screened over the returned
title/snippet; exact fingerprints promoted Cameron--Korchmaros, Filmus--Lindzey,
Bamberg--Klawuhn, Chien--Kang, Hollmann--Xiang, Pan--Wu--Yin, and the Klein-cubic boundary. The finite-field
moment batch also returned algorithmic moment-subset-sum work, but no conic, one-factorization,
or signed-design overlap, so no such result was promoted to source-level discussion.

### Forward-citation graphs

Citation enumeration supports only the narrow negatives stated here. Counts are in
OpenAlex/Crossref/Semantic Scholar order.

- **Cameron--Korchmaros**, pinned by DOI `10.1112/blms/25.1.1`: `37/25/41`. All three services
  resolved the pinned title, distinguishing results from errors. The largest set was Semantic
  Scholar's 41 citing works. A mechanical screen ran over title and available abstract using the
  discriminator
  `moment|harmonic|secant|conic|fourier|relative invariant|cubic|coxeter|A4|factorization`.
  It promoted 15 generic factorization hits for title review; none described conic-ideal quotient
  moments or the C378 bridge. Duplicate records remained in the service response and were not
  silently collapsed.
- **Bamberg--Klawuhn**, pinned by DOI `10.5802/alco.490`: `0/0/0`. Each service returned the
  exact pinned title and an explicit zero, so these are genuine empty forward sets rather than
  API errors. The paper was published only on 1 July 2026, so zero forward citations carry very
  little evidentiary weight.
- **Lansdown--Martin**, pinned by DOI `10.4153/S000843952510146X`: `0/0/0`, reused from the C378
  audit. Each service had resolved the pinned title and explicitly returned zero. This supports
  only the bounded absence of a successor to its fusion theory that already contains C378/C406.
- **Filmus--Lindzey** could not be pinned uniformly: exact-title searches in OpenAlex and
  Crossref returned no exact record among the first five results, while Semantic Scholar returned
  HTTP 429. This is **NOT COVERED**, not a zero, and no negative claim relies on its forward tree.

For comparison, the C399 audit's already-recorded Edge and Dye counts were `7/6/10` and
`13/10/14`. They are used here only for positive classical ownership, not to license a new
absence claim, so their citing sets were not re-enumerated.

### Coverage gaps

- MathSciNet was not institutionally accessible: **NOT COVERED**.
- Automated Google Scholar access was unavailable: **NOT COVERED**.
- zbMATH Open was not closed claim-by-claim: **NOT COVERED**.
- Cameron--Korchmaros full text was paywalled; its abstract suffices for the positive
  one-factorization pre-emption but licenses no internal negative.
- Pan--Wu--Yin's publisher HTML exposed the load-bearing example and lemma, but its PDF endpoint
  returned HTTP 403. Claims beyond the explicitly read HTML passages remain **NOT COVERED**.
- The published typeset Bamberg--Klawuhn paper was not separately read; arXiv v2 was read in
  full. Any post-v2 textual change is an access/version gap.
- The broad literature on modular cubature, orthogonal arrays, and trades was screened only by
  the recorded fingerprints. A portable all-field “first surviving moment” theorem would require
  a dedicated audit.
- The C378 rank-16 scheme still lacks a complete claim-specific priority closure. Therefore the
  depth--Fourier bridge inherits C378's qualification even though the factorization map itself was
  not located.

## Ranked priority verdict

1. **Highest priority, likely new within coverage:** the C403/C406 conic-ideal quotient applied
   to the classical exceptional one-factorizations, with exact balanced-half reconstruction,
   minimal cubic signed moment, and the plane tensor syzygies. These clauses form one theorem;
   splitting them into several novelty claims would weaken the honest boundary.
2. **High-value composite extension:** the H3 `22 -> 6 -> 2 -> 1` depth-profile lattice, exact
   `J`-odd map into C378's Fourier-stable sector, compressed cubic trade, and C379 parent-recovery
   consequence. This is explicit and structurally informative, but priority is inherited from
   three internally developed ingredients rather than a closed external literature class.
3. **Medium priority structural theorem:** the uniform harmonic/radial image and restricted
   module decompositions. These are likely new, but the terminology must be kept distinct from
   Filmus--Lindzey's matching harmonic polynomials.
4. **Manuscript-ready explanation, not novelty:** the `PSL_2` tensor/`PGL_2` line stabilizers and
   the `A3` nonsplitting explanation. They are elegant consequences of the nonzero cubic and
   the index-two subgroup structure.
5. **Scope/positioning only:** relative-invariant dimension three, failed contraction and naive
   singular recovery, and the scalar-weight obstruction. Preserve these to prevent overclaiming;
   do not headline them.
6. **Classically owned:** the raw `A3/B3/H3` one-factorizations, their design status, and the
   `5,14,22` homogeneous marker spaces.

The bounded follow-up tasks must keep two distinct scopes. **C411** is the H3-specific
double-coset/Hecke explanation of the six scalar-`A4` fibres, their `1,4,6` multiplicities, and
the exact profile plane. **C409** is the general trade-filtration problem asking for a portable
criterion for the first surviving signed moment. Success on one would inform the other, but the
H3 Hecke calculation is not itself the general filtration theorem and should not inherit a
broader novelty claim.

## Manuscript-safe wording

Recommended principal statement:

> The exceptional `A3`, `B3`, and `H3` conic markers admit classical descriptions by highly
> symmetric one-factorizations. We apply the conic-ideal secant-product quotient to these
> factorizations. Its image is a uniform harmonic/radial module. In the `B3` and `H3` cases the
> two `PSL_2` sheets are the unique complementary halves with equal first and second tensor
> moments, while their first nonzero signed tensor moment is cubic. This cubic is fixed by
> `PSL_2` and negated by the outer `PGL_2` coset, and the lower-moment cancellations lift to
> explicit identities among the plane secant-product factorizations.

Recommended H3 bridge statement:

> For `H3`, zero-depth differences across the four oriented scalar-`A4` relation pairs define an
> explicit map from the 22 matching factorizations to C378's Fourier-stable odd sector. Its six
> fibres, of sizes `1,4,6` on each sheet, are exactly the scalar-`A4` matching orbits and yield the
> decorated information lattice `22 -> 6 -> 2 -> 1`.

Required credit and limits:

> Edge and Dye own the exceptional conic-marker geometry and its `PSL/PGL` sheet structure;
> Cameron--Korchmaros own the relevant highly symmetric one-factorizations; and
> Bamberg--Klawuhn place one-factorizations in the perfect-matching association scheme as
> designs. The contribution claimed here is the conic-ideal quotient, its balanced and cubic
> tensor memory, and the explicit depth--Fourier composition. The cubic and depth profiles
> belong to the factorization-decorated orbit, not to the undecorated GRS child.

Avoid:

- “a new one-factorization,” “a new matching design,” or “the first harmonic theory of perfect
  matchings”;
- “the cubic is the unique relative invariant”;
- “cubic degree is minimal among all nonlinear statistics”;
- “the cubic recovers the individual matching”;
- “the cubic is linearly identified with C378's four-space”;
- “the bare child code remembers chirality”; and
- unqualified “first” or “previously unknown.”

The safe priority phrase is **“no predecessor for this conic-quotient/moment/Fourier composition
was located in the recorded coverage.”**
