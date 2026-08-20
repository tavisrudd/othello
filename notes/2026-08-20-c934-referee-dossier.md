# C934 referee dossier: integral cohomology and modular decomposition

**Manuscript:** *Integral Cohomology and Modular Decomposition for the Theta
Divisor of a Cubic Threefold*

**Frozen authority:** commit
`53e19feff1f66e7b4b453a38fcc0f239ece007d6`; PDF SHA-256
`108983c8420086abb85889c4d3eff32e1c40fc281e28d6599feacd03d21ddc6e`.
The PDF has 11 A4 pages.  Its abstract has 180 whitespace tokens.

## Editorial question

Does the new integral/modular decomposition theorem turn the formerly
Proceedings-scale lattice note into a sound and significant specialist
geometry paper, and is every new integral, modular, and Fano claim proved at
the advertised coefficient level?

The permitted verdicts are:

- **A:** accept / ready to submit;
- **B:** minor revision, with every required local repair pinpointed;
- **C:** major revision or theorem overclaim;
- **D:** reject / central argument fails.

Give separate recommendations for *Algebraic Geometry*, *Mathematische
Zeitschrift*, and *Proceedings of the AMS*.  Venue judgment must be separated
from correctness.

## Referee pool and literature fit

These are expertise matches, not assertions about availability or conflicts.

| individual | directly relevant literature / expertise | best packet |
|---|---|---|
| Daniel Juteau | *Parity Sheaves*; decomposition numbers and modular perverse sheaves | modular reduction, point-summand rank |
| Carl Mautner | *Parity Sheaves*; tilting/parity phenomena | modular indecomposability and semisimplicity |
| Geordie Williamson | *Parity Sheaves*; intersection forms and failure of decomposition in positive characteristic | bad-prime theorem and significance |
| Mark Andrea A. de Cataldo | decomposition theorem, topology of algebraic maps, refined intersection forms | integral splitting mechanism and rational boundary |
| Luca Migliorini | decomposition theorem and intersection forms for resolutions | stalk/costalk shifts and point summands |
| Alessio Cipriani | *Indecomposable extensions of perverse sheaves over a closed stratum* | small-extension / indecomposability logic |
| Laurentiu Maxim | isolated singularities, perverse sheaves, zig-zag descriptions | link, truncation, and coefficient change |
| Thomas Krämer | cubic-threefold theta divisor and the rational three-skyscraper formula | priority and comparison with the known decomposition |
| Arend Bayer | moduli-space realization of the theta resolution | cubic geometry and resolution model |
| Benjamin Schmidt | moduli-space realization of the theta resolution | cubic geometry and Fano/moduli interface |

## Load-bearing claim map

| claim | printed location | inputs that must be checked |
|---|---|---|
| rank-130 degree-three lattice and mod-two fibre product | Theorems 1.1--1.2, Sections 2--5 | inherited C931 A-verdict package; confirm no regression |
| integral outer splitting | Theorem 1.4; Section 7, equations (19)--(21) | shifts in `i^*K`, `i^!K`; adjunction; unit intersection forms; simultaneous idempotents |
| central non-splitting over `Z` | Section 7, equation (21) | exact Gysin attachment and Smith factor three |
| localization away from three | equation (22) | normalized point split and characterization of the intermediate extension |
| characteristic-three indecomposable nonsemisimple factor | equation (23) | derived universal coefficients, the extra Tor class, no point summand, not-simple argument |
| degree-four Fano lift | equation (24) | all-degree clean base change, point input, restriction to a line, pushforward to `[F]` |
| exact index-three global attachment | equation (25) | rational boundary vanishing, infinite-order lift, truncation exactness |
| ordinary equals intersection cohomology in degrees at least four | equation (26) | constant-to-Deligne triangle, shifts, endpoint surjectivity |
| priority framing | abstract, introduction, Section 6, ledgers | Krämer, JMW, de Cataldo--Migliorini, Cipriani; no unqualified firstness |

## Packet A: modular and perverse-sheaf audit

Read the entire frozen PDF.  Reconstruct equations (19)--(23) without using
the research notes as proof.  Check:

1. the stalk and costalk shifts;
2. whether the two unit blocks really produce integral direct summands;
3. whether the residual object satisfies the perverse bounds over `Z`;
4. whether derived reduction gives dimensions 11 and the displayed exact
   arrows in characteristic three;
5. whether indecomposable and nonsemisimple follow, rather than merely
   failure of the rational decomposition;
6. the exact boundary between the manuscript and JMW/Cipriani.

Primary sources: Juteau--Mautner--Williamson, arXiv:0906.2994, Sections
3.1--3.3; Cipriani, arXiv:2607.09379, especially Lemma 3.12 and Corollary
3.22; Goresky--MacPherson's Deligne construction as cited.

## Packet G: cubic geometry and global attachment audit

Read the entire frozen PDF.  Reconstruct equations (24)--(26).  Check:

1. that Lemma 4.1 extends to the degree-four point input without an excess
   or multiplicity factor;
2. `e^*u_4=ell` and `b_*u_4=[F]`, including sign and degree conventions;
3. the infinite-order argument after restriction to `U`;
4. the rational rank argument forcing `H^4(U,Q)->H^4(K,Q)` to vanish;
5. the index-three exact sequence and constant-to-IC triangle;
6. that the earlier degree-three theorem is unchanged.

Primary sources: Clemens--Griffiths Sections 2 and 11; Beauville's theta
singularity paper; Krämer Corollary 6; Bayer et al. Theorem 7.1.

## Packet E: editorial, priority, and presentation audit

Read the entire frozen PDF and the two paper ledgers.  Check:

1. title and abstract accurately lead with the upgraded spine;
2. abstract remains below 250 words;
3. rational prior art and general modular mechanisms are attributed exactly;
4. the mod-two/mod-three synthesis is theorem-backed rather than rhetorical;
5. all equations and references render cleanly;
6. give independent venue recommendations and identify the most likely
   specialist target.

Priority sources and read depths are in
`notes/2026-08-20-c934-priority-audit.md`.  A referee must verify any source
on which a negative or mandatory finding relies.

## Isolation and report contract

Each mathematical packet writes only its assigned report file.  Do not edit
the manuscript.  Record the frozen commit and PDF hash, sources actually
opened, read depth, exact findings, confidence, and venue recommendations.
An `A` report must still list the main failure modes explicitly checked.

Suggested report paths:

- `notes/2026-08-20-c934-referee-A-modular.md`
- `notes/2026-08-20-c934-referee-G-geometry.md`
- `notes/2026-08-20-c934-referee-E-editorial.md`
- `notes/2026-08-20-c934-referee-synthesis.md`

## Synthesis rule

Synthesis begins only after the packet reports are frozen.  Any C/D finding
blocks submission.  Any B finding must be repaired and then re-read on a new
PDF hash.  An A synthesis states the strongest supported venue, not the most
prestigious conceivable one.
