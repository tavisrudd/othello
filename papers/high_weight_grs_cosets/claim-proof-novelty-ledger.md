# Version 2 claim, proof, novelty, and formalization ledger

Mathematical proof, executable certification, imported input, kernel checking,
editorial adoption, and novelty are independent fields. No finite certificate
is used to infer a covering radius or an unrestricted geometric statement.

## Status vocabulary

- MANUSCRIPT: a proof is printed in the paper.
- CERTIFIED: an exact finite certificate closes the stated domain.
- KERNEL: Lean checks the stated algebra, arithmetic, or conditional implication.
- IMPORTED-1: one named external theorem is used at its exact hypotheses.
- PRIOR-ART: the cited source already contains the stated item.
- NONE-FOUND: no predecessor was located within the recorded bounded search.
- DERIVED: follows from rows whose hypotheses are recorded.
- GENERALIZES-CITED: the row strictly contains a cited theorem; the citation is to the source, and the extension is what is claimed.
- COMPANION-SOURCE: retained in the source/evidence record but not claimed by the current submission.
- RETRACTED: the row was adopted and is now withdrawn; the reason is recorded in place.

## Mathematical result ledger

| ID | Adopted claim | Status | Exact proof/trust boundary |
|---|---|---|---|
| R5 | complete redundancy-five deep holes for q >= 7 | MANUSCRIPT / CERTIFIED / KERNEL-CONDITIONAL | cubic-pencil geometry, R5 certificate over the seven fields 7,8,9,11,13,17,19, cited radius theorem; q=16 is closed structurally by the characteristic-two branch budget and its certificate row is a regression check; the pencil-level split-free criterion is prior art, see the R5-PENCIL and R5-SYN rows |
| R5-PENCIL | which pencils of binary cubics contain no completely split squarefree member | PRIOR-ART | equivalently which lines of PG(3,q) lie in no plane meeting the twisted cubic in three distinct rational points. Settled for q >= 23 in every characteristic by Blokhuis--Pellikaan--Szonyi Thm. 7.1 and Prop. 7.4, with the genus-one double-point-scheme threshold in their Rem. 6.12; exact counts for non-generic classes by Davydov--Marcugini--Pambianco Thm. 3.3 (q >= 5) and Gunay--Lavrauw; for the generic class by Kaipa--Pradhan Thm. 1.3 (char != 2,3), their characteristic-three companion, and Ceria--Pavese (char 2). The manuscript reproves this in divided-power coordinates and must cite it; the Aubry--Perret substitution for Hasse--Weil, which drops the simplicity hypothesis, is the only difference |
| R5-COUNT | exact split-witness count on the trivial-gcd separable stratum, every characteristic | MANUSCRIPT / CERTIFIED / GENERALIZES-CITED | #Y_f = 6 N_f + 3 d2 + d3, proved by a member-by-member root count with no discriminant and no invariant theory, with the Riemann-Hurwitz branch budget d2 + 2 d3 <= 4 (sharper, d2 + d3 <= 2, in characteristic two). Consequences: the two-sided Chebotarev splitting law N_f = (q+1)/6 + O(sqrt q), the q >= 20 threshold, and the forced fibre-square invariants at q = 17, 19. In characteristic other than two and three, with the pencil missing the twisted cubic, it is equivalent to Kaipa--Pradhan's generic-line incidence count (their Prop. 4.5(3) with Thm. 5.1; the denominator printed in their displayed Thm. 1.3(3) is a slip). The identity drops both their characteristic restriction and their genericity restriction, so this row records a generalization of a cited theorem rather than an independent discovery of it. Exhaustive verification over every point of PG(4,q) for prime powers 4 <= q <= 32 in `supplement/evidence/r5-elliptic-incidence/` |
| R5-SYN | the redundancy-five syndrome layer | NONE-FOUND | the divided-power Hankel passage f -> W_f, the exclusion of line classes no rank-two syndrome realizes (characteristic-two inseparable unisecants), the split-free syndrome inventory with representatives, orbit sizes, stabilizers, and Frobenius fusion, and the covering-radius promotion to deep holes. No source in the recorded search states a projective Reed--Solomon deep-hole, covering-radius, or syndrome result. Search boundary, read depths, screened citing set with its three separate graph counts, and coverage gaps are in `literature-audit.md` |
| PF | finite-depth coherent polar escape for fixed-level refinements | SUPPLEMENTARY MANUSCRIPT / KERNEL-ALGEBRA | concrete stagewise carrier and curve data remain inputs; this row is not an input to the arbitrary-redundancy theorem |
| RC | reduced recursively contained carrier equals persistent plus maximal Lucas | MANUSCRIPT / CERTIFIED-ELIMINATION / KERNEL-CONDITIONAL | concrete terminal primes and consecutive-row exclusions are manuscript/certificate inputs; density and finite-component selection are kernel checked |
| UC | pointed split-squarefree locator outside the recursive carrier | MANUSCRIPT | for deleted set size s, q >= 6(r+s)-16+floor(2 sqrt(6(r+s)-18)), with the sharper binary bound; composite contraction, a degree-six selector, the Vandermonde grid, and the exact R5 count replace every stagewise package |
| HC | all cosets of weight at least r-1 for point-deleted GRS/EGRS support | MANUSCRIPT / DERIVED / IMPORTED-1 / NONE-FOUND | To our knowledge, no earlier result classifies, for arbitrary redundancy, every projective syndrome direction of a generalized or extended Reed--Solomon code supported on a projective line with finitely many prescribed points deleted that has coset weight at least r-1. In the range of Theorem `thm:main`, these directions are exactly the omitted curve points in weight r, and the tangent, conjugate-secant, and deleted-point-incident split-secant directions in weight r-1. The bounded audit and explicit noncoverage are in `notes/reed-solomon-tasks/c975-2026-08-26-full-literature-audit.md` |
| EXT | one-column MDS/NMDS extension classification for the point-deleted family | MANUSCRIPT / DERIVED / NONE-FOUND | d(ker[H_S|f])=d_S(f)+1 and the general deep-hole/MDS-extension mechanism are prior art; the printed circuit and dual-distance arguments identify the exact columns yielding MDS or NMDS codes from HC. No earlier exact-column classification for this family was located within the C975 audit boundary |
| AGG | family-aggregate NMDS weight enumerators | MANUSCRIPT / DERIVED / IMPORTED-1 / NONE-FOUND | the three configuration-free family incidence sums were not located in the C975 audit or the focused C977 delta, but are presented only as derived double counts; the cited standard NMDS recurrence determines every remaining coefficient and is prior art; the printed closed aggregate formula is its direct family-wise sum, not a separate novelty claim; no priority adjective and no equality of individual family members is claimed. Audits: `notes/reed-solomon-tasks/c975-2026-08-26-full-literature-audit.md`, `notes/reed-solomon-tasks/c977-2026-08-27-family-aggregate-enumerator-novelty-delta.md` |
| R6 | complete redundancy-six deep holes for q >= 7 | MANUSCRIPT / CERTIFIED / KERNEL-CONDITIONAL | R6/R6-NF certificates and exact radius endpoint |
| R7-SF | complete redundancy-seven split-free classification for q >= 7 | MANUSCRIPT / CERTIFIED / KERNEL-CONDITIONAL | uniform T/T^6 spine from q >= 13; central odd-binary singleton separate; exception delta only at 7,8,9,11 |
| R7-DH | complete redundancy-seven deep holes for every q>=7 | DERIVED / IMPORTED-1 / CERTIFIED | the radius is six at q=7 by the projective-line bound, at q=9 by Ball--De Beule's MDS length theorem, and for q>=11 by Seroussi--Roth with Dür; Wu--Ding--Chen gives `rho=7` at q=8, where exact extraction over 46 frozen and four persistent semilinear representatives leaves the nine-direction diagonal tangent orbit and fixed central nucleus, ten projective directions total |
| R7-DL | direct-locus finite completeness replay | CERTIFIED | shares the direct-locus engine, R5 field layer, and R6 pointed theorem from q >= 16; not a second field implementation |
| R8 | persistent-only deep holes for q >= 43 | COMPANION-SOURCE / CERTIFIED / KERNEL-CONDITIONAL | three-marker package and Certificate R8; omitted from the current submission |
| R9 | persistent-only deep holes for q >= 53 | COMPANION-SOURCE / CERTIFIED / KERNEL-CONDITIONAL | residual-quadratic slice, characteristic-seven bridge, Certificate R9; omitted from the current submission |
| WWH | projective-subline Lucas endpoint iff a divides e | PRIOR-ART / IMPORTED-1 | Wang--Wu--Hu Proposition 11; no novelty claim for this criterion |
| M9 | first fresh higher Lucas carrier is entirely shallow for m >= 4 | COMPANION-SOURCE / CERTIFIED | all-field final-pair proof; exact full-carrier q=16,32 certificates and q=64 invariant-block certificate; omitted from the current submission |
| R10 | persistent-only deep holes for every prime power q >= 59 | DERIVED / COMPANION-SOURCE / CERTIFIED | odd fields use RC; binary fields use M9; separate radius route; omitted from the current submission |
| R5-Q | WITHDRAWN 2026-08-07 — balanced q=8 AME and quantum-MDS consequence | RETRACTED | the claim rested on a split-free direction giving a one-column MDS extension. It does not: an extension needs a point outside the span of every r-1 parity-check columns, split-freeness gives only r-2, and Dur's equivalence makes covering radius r-1 equivalent to completeness of the normal-rational-curve arc, so no extension exists at any redundancy classified here. A [10,5,6]_8 MDS code would also be a 10-arc in PG(4,8), where the maximum is 9. The exact count of 1116 split-free directions at q=8 is unaffected and is recorded as a deep-hole count. The diagnosis and affected surfaces are recorded in `verification-map.md` and Remark `rem:q8-no-extension` |

## Imported theorem ledger

| Source | Exact use | Non-use |
|---|---|---|
| Seroussi--Roth; Dür; Kaipa | high-rate nonextendability, completeness--radius equivalence, and syndrome/MDS dictionary | no syndrome classification |
| Zhang--Wan--Kaipa | lower persistent families and projective syndrome dictionary | no beyond-four exhaustion |
| Aubry--Perret | rational-point lower bound on the stated integral curves | no integrality or deletion proof |
| Gmainer--Havlicek | normal-rational-curve nuclei and binomial coordinates | no coherent lift or split-incidence theorem |
| Wang | Frobenius/factorization semantics on the étale locus | no Hankel carrier or marked recursion |
| Wang--Wu--Hu | projective-subline endpoint criterion | no adjacent-zero union, recursive transport, or full M9 shallowness |

## Companion algorithm ledger

| ID | Adopted claim | Status | Exact proof/trust boundary |
|---|---|---|---|
| SW-CAN | exact semilinear lex canonical form and transporter for every nonzero binary form with `r>=5`, `q>=r` | IMPLEMENTED / DIFFERENTIAL-CERTIFIED / QUALIFIED-NOVELTY | all rational-root multiplicity strata, including characteristic-two and Lucas degeneracies; `O(m r q^2)` retained transports; fixed-degree quartic orbit classifications, smooth-form isomorphism algorithms, and irreducible-place enumeration are prior art and delimit the claim |
| SW-DEC | exact syndrome distance, nearest-error output, and replayable locator witness for every `r>=5`, `q>=r`, within the explicit candidate budget | IMPLEMENTED / TRUSTED-SEARCH / CERTIFICATE-REPLAY | trusted exhaustive locator search through degree `r-1`, then an `r`-column NRC basis; streamed locator enumeration; the certificate checks the displayed upper-bound witness but not lower-degree exhaustion; no radius theorem and no R11+ deep-hole promotion |
| SW-EVEN-DIAG | the `e_(r-2)` semilinear orbit is certified deep for every even `q` at `r=q-1` | PRIOR-ART / IMPORTED / CERTIFICATE-REPLAY | Wu--Ding--Chen Thm. 17 supplies `rho(PRS(2))=q-1`; Xu 2023 supplies the explicit family; the companion toolkit replays the intrinsic terminal-locator/two-element-complement criterion and orbit transporter, including GF(8)/R7 and GF(16)/R15; at q=8 a separate exhaustive certificate also finds the fixed central deep direction and proves all other split-free orbits shallow |
| SW-CERT | versioned locator and positive deep certificate replay | IMPLEMENTED / TESTED | locator replay reconstructs the displayed error pattern and upper bound but does not certify lower-degree exhaustion; positive replay recomputes normalization, transporter, family evidence, theorem-domain lookup, and radius source while retaining the registry's mathematics as a trusted input |

The source-by-source comparison and the boundary between imported orbit data
and the toolkit's certificate-replay contribution are recorded in
`literature-audit.md` and the ledger above.

## Formal boundary

The 17-file paper-facing aggregate checks the shared Hankel interfaces,
contraction algebra, R5--R7 conditional syntheses, uniform threshold
arithmetic, polynomial density, closure transport, and finite-component
selection. Existing companion R8/R9/residual modules are identified
statement by statement but are not silently folded into that aggregate.
Concrete primary decompositions, projective group actions, point-existence
arguments, literature theorems, and external certificate semantics remain
explicit. The exact row-by-row map is supplement/LEAN-STATEMENTS.md.

## Novelty boundary

The recorded audit located no predecessor for the exact conjunction of the
reduced terminal decomposition, maximal adjacent-zero carrier, recursive
transport, and PRS split-free consequence. This licenses only qualified
wording within the stated search boundary. The paper makes no claim to solve
the general Reed--Solomon deep-hole conjecture. MathSciNet and Google Scholar
were not covered. Wang--Wu--Hu receives exact theorem-level attribution.

## Consistency checklist

- [x] Every adopted theorem has a printed proof or an exact
  certificate/formal/import route.
- [x] Split-free and deep-hole statements are separated by a radius row.
- [x] The R7 direct-locus replay states its shared executable and theorem input.
- [x] Version 1 release identifiers and bytes remain immutable.
- [ ] Version 2 candidate hashes and cold-reader signoffs are frozen after the
  final repaired build.
