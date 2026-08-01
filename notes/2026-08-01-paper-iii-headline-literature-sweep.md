# Paper III headline literature sweep

**Date:** 2026-08-01  
**Paper:** `papers/clebsch-passages/`  
**Claim surface:** `ARITH-1`, `ARITH-2`, `ORIENT-1`, `HARM-1`, `HARM-2`

## Verdict

No exact predecessor was located for any paper-owned claim core: the rational
twist `5J0`, the displayed exchanger's spinor class, the marked golden sign
transport, the labelled ten-face-axis Petersen realization, or the exact
spherical cubic coefficient. This is a bounded negative, not a priority claim.

The sweep did identify two classical boundaries that the manuscript had not
made visible enough. The six icosahedral vertex axes and their signed
Gram/Seidel switching description are classical, and the decomposition of
spherical harmonics under icosahedral symmetry already includes degree six.
The manuscript now cites those precedents. Its defensible contribution is the
exact arithmetic normalization and the exact marked constructions and
constants, not conference matrices, the ambient icosahedral decomposition,
the Petersen spectrum, or the bond-order invariant themselves.

This report discusses sixteen individually named sources: three were read at
`full text`, ten at `partial`, two at `abstract/metadata only`, and one at
`secondary only`. Screened result and citing sets are recorded separately.

## Claim findings

### ARITH-1 — rational incidence cover and Stein algebra

Hitchin proves the generic degree, identifies the irreducible sextic branch,
constructs the golden Clebsch charts, computes
`iota_t^*J0=16 sigma3^2`, and describes the two configurations over `xyz`.
Neither Hitchin paper fixes the residual rational square class. Screening the
largest forward-citation sets of both papers found no later source that does.
The paper-owned step remains the use of the complete residue algebra
`Q(sqrt(5))` to determine the twist `5`, followed by the standard trace-split
description of the normalized double-cover algebra.

Verdict: not pre-empted in the searched literature. “We determine the
rational square class” is accurate. No “first” or “new” wording is licensed.

### ARITH-2 — golden fibre and spinor specialization

The golden configurations themselves are Hitchin's. Dye supplies the adjacent
square-`5` field-of-definition criterion for Clebsch hexagons. The exact
exchanger, its uniform spinor class `[2]` over the stated finite fields, and
the nontrivial specialization modulo `11` were not located. Broad “spinor”
results were dominated by unrelated physics and geometry, so this negative
rests on exact-combination queries and the Hitchin citation closure.

Verdict: the specialization is a paper-owned exact calculation. It remains
local to the displayed fibre, not good reduction of the global incidence
comparison.

### ORIENT-1 — normalized components and relative marked sign

Normalization of `z^2-a^2` into two branches is elementary. Godsil records
the six diagonals of the icosahedron as equiangular lines and the standard
signed Gram/Seidel matrix up to diagonal switching. Neither the conference
matrix nor switching invariance is therefore a novelty surface.

No consulted source follows Hitchin's deck exchange through the displayed
golden exchanger to the triangle cubic and then through the primitive
pair-sum map to the degree-six cubic. That comparison remains exact but
relative to the complete marking and normalized lift.

Verdict: not pre-empted at its stated marked level. Present it as a comparison
theorem, not an intrinsic orientation determined by an unmarked sheet and not
as priority for conference matrices.

### HARM-1 — ten face axes and Petersen four-space

Meyer treats invariant spherical harmonics for the icosahedral group and
constructs invariants in degrees `6`, `10`, and `15`. Cohan's official
abstract states that expansions for all icosahedral representations were
obtained through degree `14`. Dharmavaram et al. describe degree `6` as the
lowest nonconstant even icosahedral channel in a modern application. The
Petersen spectrum `3,1^5,(-2)^4` and its four-dimensional `-2` eigenspace are
standard algebraic graph theory.

These precedents do not state the present labelled construction from the ten
opposite-face axes, its exact zonal Gram kernel, or the primitive pair-sum
identification. Basak's 2026 Petersen/Clebsch paper concerns monodromy of the
27 lines on the Clebsch cubic surface; it is not a spherical-harmonic
face-axis construction.

Verdict: the exact labelled realization was not pre-empted, but its ambient
representation-theoretic ingredients are classical. The manuscript now says
so and makes no component-level priority claim.

### HARM-2 — exact Gaunt and bond-order coefficient

Steinhardt--Nelson--Ronchetti define the standard rotational invariants and
identify the degree-six icosahedral channel. DLMF supplies the Gaunt/`3j`
conversion. Exact searches for `-784000/1247103`, its numerator/denominator
pair, and a Clebsch/Petersen restriction returned no predecessor. The broad
physical `W_6` literature was not exhaustively screened; the claim here is
the exact restriction on this marked four-space, not novelty of `W_6`.

Verdict: “computes its exact restriction” is licensed. “New invariant” or an
unqualified claim that the harmonic theorem is new is not.

## Source audit

1. **Nigel Hitchin, _Spherical harmonics and the icosahedron_.** Read depth:
   `full text`, arXiv v1, Sections 3--4 and 9--10. Cache key
   `arXiv:0706.0088`, SHA-256
   `33cb8b2e5b7102c0adaeb1c00af1e8d1702f5fd086fa1abfddb739c149d05eeb`.
2. **Nigel Hitchin, _Vector bundles and the icosahedron_.** Read depth:
   `full text`, cached arXiv version, Sections 4--5 and 7--9. Cache key
   `arXiv:0906.4208`, SHA-256
   `7da4fb227846551a788821d2a6f8082aa4e75088d34633934ba34c4e7f59b722`.
3. **R. H. Dye, _Hexagons, conics, A5 and PSL2(K)_.** Read depth:
   `full text`; OCR reconstruction read and load-bearing passages on scanned
   pages 271, 272, 275, and 279 verified against authoritative images.
   Reconstruction SHA-256
   `6d48847949e2b37c3a87557df9fa4147c9b1305d8469c7c06965c62b99fcbf92`.
4. **Burnett Meyer, _On the Symmetries of Spherical Harmonics_.** Read depth:
   `partial`, introduction, group setup, generating-function discussion, and
   the icosahedral construction in Section IV.5. Cache key
   `10.4153/CJM-1954-016-2`, SHA-256
   `205a4464135573aa8dfa9aaa17a05071b7625b2046824ac60c2de6e0cad16bbd`.
5. **Norah V. Cohan, _The spherical harmonics with the symmetry of the
   icosahedral group_.** Read depth: `abstract/metadata only`, official
   Cambridge abstract and metadata. The attempted official PDF was an HTML
   access page and is recorded as `not-a-pdf`, cache key
   `10.1017/S0305004100033156`, SHA-256
   `0accf9c537d0f86cc5b4b7dcb8abab8dfebadda89b6d9737c042bc7459f860ab`.
6. **C. D. Godsil, _Problems in Algebraic Combinatorics_.** Read depth:
   `partial`, Sections 3--4 on equiangular lines, signed Gram matrices, and
   switching. Cache key `10.37236/1224`, SHA-256
   `5938dc3bfe6f03411430b6285c03352491dd5334f48938dd8f1db29511d7d22e`.
7. **Sanjay Dharmavaram et al., _Orientational Phase Transitions and the
   Assembly of Viral Capsids_.** Read depth: `partial`, abstract,
   introduction, and icosahedral-harmonic construction. Cache key
   `arXiv:1701.04452`, SHA-256
   `94b3449c8831605fc0adb19e1612a353e0e9dfbcb9394c0190f7d34e13359ac3`.
8. **P. J. Steinhardt, D. R. Nelson, and M. Ronchetti, _Icosahedral Bond
   Orientational Order in Supercooled Liquids_.** Read depth: `partial`,
   published abstract, order-parameter definition, and numerical discussion.
   Cache key `10.1103/PhysRevLett.47.1297`, SHA-256
   `762f38490ed9b29e6bec0d67113fc3e35d4493759ca3dbfa5798cae04f187eef`.
9. **P. J. Steinhardt, D. R. Nelson, and M. Ronchetti,
   _Bond-Orientational Order in Liquids and Glasses_.** Read depth: `partial`,
   introduction, Section II, equations (1.1)--(2.6), Figure 2, and Table I.
   Cache key `10.1103/PhysRevB.28.784`, SHA-256
   `0efaad674f48c98b716e6732c63e2b04b0d5339c0844c733e72d09d58d041fc5`.
10. **NIST Digital Library of Mathematical Functions.** Read depth:
    `partial`, Release 1.2.7, Sections 14.30 and 34.3(vii), online.
11. **Tathagata Basak, _Petersen graph and monodromy of the 27 lines on the
    Clebsch surface_.** Read depth: `partial`, arXiv v1 abstract,
    introduction, and Petersen-model setup. Cache key `arXiv:2607.01878`,
    SHA-256
    `1bd34c5689921f5bffb24cd1cb98db41bc18ac3eba617e2daf4f2e340dd3f7aa`.
12. **V. Krishnamoorthy, T. Shaska, and H. Völklein, _Invariants of Binary
    Forms_.** Read depth: `partial`, arXiv Sections 1--3.4. Cache key
    `arXiv:1209.0446`, SHA-256
    `33a6b9c20c469d89f21cbbc1e8e4cb3af3934332b7301d1957161dc30ec7620a`.
13. **Shigeru Mukai and Hiroshi Umemura, _Minimal rational threefolds_.**
    Read depth: `abstract/metadata only`; DOI metadata and later primary
    bibliographies. The full text was not reached, and no load-bearing
    formula is attributed to it.
14. **John H. Conway, Noam D. Elkies, and Jeremy L. Martin, _The Mathieu
    group M12 and its pseudogroup extension M13_.** Read depth: `partial`,
    arXiv Sections 3--4. Cache key `arXiv:math/0508630`, SHA-256
    `05dc75d74c729b1c1edc85542ae970a1b1f843fcbe0111043463e2a435c47c94`.
15. **Peter J. Cameron, _Hadamard matrices_.** Read depth: `partial`,
    Sections 3--4 of the online Encyclopedia of Design Theory PDF. It is
    retained context from the earlier broader candidate and carries no
    current headline claim.
16. **Marshall Hall, Jr., _Note on the Mathieu group M12_.** Read depth:
    `secondary only` through the partially read Cameron and
    Conway--Elkies--Martin sources. It carries no current headline claim.

## Search coverage

Load-bearing exact queries run on 2026-08-01 were:

- `"Hitchin" "5J_0" Clebsch cubic incidence cover`;
- `"z^2=5J" Clebsch Hitchin`;
- `icosahedron exchanger "spinor class" Clebsch`;
- `conference matrix icosahedron Clebsch cubic orientation`;
- `"pair-sum" "Petersen" eigenspace`;
- `icosahedron face axes Petersen eigenspace degree six harmonics`;
- `"Clebsch cubic" "Petersen" spherical harmonics`;
- `"784000" "1247103" spherical harmonic`; and
- `"Clebsch cubic" "Wigner" icosahedron`.

OpenAlex searches screened title, year, DOI, and available abstract metadata
for the first 15 results, or the whole set when smaller. Counts were: 3 for
`Hitchin Clebsch incidence double cover square class`; 96 for `icosahedron
spinor norm exchanger finite field`; 179 for `conference matrix Clebsch cubic
orientation`; 5 for `Petersen eigenspace icosahedron spherical harmonics`;
and 9 for `degree six Gaunt cubic Clebsch spherical harmonic`. The larger two
sets were noisy and their first 15 results were unrelated; they license no
exhaustive negative. The three small sets were screened in full.

Forward-citation counts for Hitchin's two papers were obtained independently:

| seed DOI | OpenAlex | Crossref | Semantic Scholar |
|---|---:|---:|---:|
| `10.1090/crmp/047/14` | 6 | 2 | 7 |
| `10.1090/conm/522/10292` | 5 | 3 | 6 |

The largest sets, Semantic Scholar's seven and six records, were screened in
full by title, year, and identifier. None concerns the rational twist,
exchanger spinor class, marked orientation transport, or exact face-axis
cubic. The services disagree on both counts; they are not collapsed.

Crossref returned broad, low-precision keyword sets and then HTTP 429; those
searches license no negative. Semantic Scholar keyword search returned HTTP
errors for four queries and a four-item irrelevant set for the fifth. The
failures are errors, not zeros. zbMATH REST attempts returned HTTP 422;
site-index searches recovered Hitchin but no auditable exhaustive set.

MathSciNet and Google Scholar were not covered. Cohan's full text and the
Mukai--Umemura and Hall originals remain inaccessible. The physical `W_6`
citation universe was not exhaustively screened. These gaps forbid
unqualified priority language.

## Cache and paper changes

The shared cache verified 400 pre-existing entries with zero hash problems.
It now also contains verified PDFs and text for Meyer
(`10.4153/CJM-1954-016-2`), Godsil (`10.37236/1224`), and Dharmavaram et al.
(`arXiv:1701.04452`) with the hashes above. The failed Cohan download is
recorded as `not-a-pdf` so it cannot be mistaken for a full-text read.

The manuscript now cites the classical icosahedral-harmonic and six-axis
Seidel boundaries. `papers/clebsch-passages/claim-proof-novelty-ledger.md`
records all five headline rows and is in the public release allowlist. Every
theorem statement and trust-manifest claim row is unchanged. No novelty
adjective or priority claim was added.

## Mystery ledger

| feature | status | remaining evidence gap |
|---|---|---|
| rational twist `5J0` | bounded negative supports paper ownership | MathSciNet and successful zbMATH query remain uncovered |
| uniform spinor class `[2]` | no predecessor located | no exhaustive finite-orthogonal-group survey |
| marked golden sign transport | no predecessor located | construction is too specialized for reliable keyword recall |
| ten-face-axis Petersen realization | ambient ingredients are classical; exact map not located | Cohan full text remains inaccessible |
| exact cubic scalar | exact-number and structural searches negative | physical `W_6` citations not exhaustively screened |

The manuscript wording boundary is now settled. The remaining gaps concern
strength of priority evidence, not correctness or the stated theorem surface.

## Validation

The ordinary paper-local aggregate and an isolated copy containing only the
paper directory both pass all release checks, including the primary and
independent arithmetic, orientation, and harmonic replays and the
warning-free manuscript build. Visual inspection of the revised positioning
paragraph, conference citation, and bibliography pages found no layout defect.
The rebuilt 17-page PDF has SHA-256
`8edbdca1056d0bd6f9720fea0cd95691b0230a51485031d186d131eecaa758bd`;
the refreshed statement identity has SHA-256
`b2346ed09f686a4d41b908b584207edc2c0695be53af93e67678f2a20eaac1de`.
