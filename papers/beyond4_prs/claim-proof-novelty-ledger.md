# Claim, proof, novelty, and formalization ledger

Governing rule: every assertion promoted to theorem or corollary status
appears here with its exact formal boundary.  Mathematical proof, executable
certification, imported input, formal-kernel checking, editorial disposition,
and novelty are independent fields.

## Status vocabulary

- `KERNEL`: checked by the trusted Lean kernel.
- `IMPORTED-1`: a named external theorem is consumed without reproving it.
- `MANUSCRIPT`: a mathematical proof is present in the manuscript.
- `CERTIFIED`: a finite executable certificate closes the stated finite domain.
- `LITERATURE`: a cited source supplies context or a non-load-bearing method.
- `PRIOR-ART`: the claimed content is already present in a cited source.
- `DERIVED`: follows immediately from rows whose hypotheses are all recorded.
- `NONE-FOUND`: the bounded novelty search located no prior statement; this
  authorizes only “we did not locate,” never an unconditional priority claim.
- `REVIEW-GATE`: a complete independent mathematical reread is required.
- `OPEN-MATH`: a proof, bridge lemma, or classification record is still absent.

Formal readiness is separate: `L1` means definitions/interfaces are ready,
`L2` means the theorem has explicit hypotheses and a formalizable proof
decomposition, and `L3` means a kernel-checked declaration exists.

Editorial disposition is one of `main theorem`, `supporting theorem`,
`boundary`, `supplement-only`, or `open/unallocated`.

## Mathematical result ledger

| ID | Paper claim | Status | Formal declaration or certificate | Exact boundary / disposition |
|---|---|---|---|---|
| R5-radius | `rho(PRS(q-4))=4` for `q>=7` | `IMPORTED-1 / CERTIFIED` | Seroussi–Roth; Certificate R5 low band | Radius input, not claimed novel; `supporting theorem`; L1 |
| R5 | Complete redundancy-five families and counts | `MANUSCRIPT / CERTIFIED / LEAN-CONDITIONAL` | Certificate R5; `RelativeConicArcs.PRSRedundancyFiveCertified.redundancyFiveSynthesisWithCertificate` | Hankel algebra, projective scaling, family/count arithmetic, compact sporadic records, Frobenius fusion, and the exact synthesis implication are kernel checked; the converse span bridge, Seroussi--Roth, Aubry--Perret, cubic-cover classification, genuine group actions, and external certificate semantics remain named inputs; `main theorem`; L1 |
| PF | Polar-flag construction and squarefree lifting | `MANUSCRIPT` | `RelativeConicArcs.PRSPolarInduction` conditional terminals | Intrinsic construction only; no contained-component classification follows; `main theorem`; L3 at the interface boundary |
| TI | One-step and uniform transverse escape | `MANUSCRIPT / IMPORTED-1` | Hasse–Weil/Aubry–Perret input; `CoherentPolarInput.splitFree_implies_persistent_or_modular` for the one-step interface | The one-step theorem is conditional on a specified lower package.  Iteration through redundancy \(r\) is conditional on the full chain \(\mathrm{CC}(j-1,1)\), \(6\leq j\leq r\), and gives the explicit threshold \(6r-15+\lfloor2\sqrt{6r-17}\rfloor\); the component chain is not formalized or assumed proved in arbitrary degree; `supporting theorem`; L3 at the interface boundary |
| CC6 | Redundancy-six contained components | `MANUSCRIPT / CERTIFIED` | Certificates R6/R6-NF; `RelativeConicArcs.PRSRedundancySixSeven` | Secant degree, cyclic/wild surfaces, the explicit Wronskian collision divisor, and exceptional-characteristic components are named propositions; the Lean terminal consumes their geometric identification as an explicit input; `supporting theorem`; L3 at that boundary |
| R6 | Redundancy-six all-field classification | `MANUSCRIPT / CERTIFIED` | Certificates R6/R6-NF; `redundancySixAllFieldSynthesis` | The exact-linear-gcd lemma, one-step exhaustion, finite bridge, radius gate, projective counts, and printed semilinear representatives form the synthesis; the repaired threshold formula and all three instantiations have independent confirmation; `main theorem`; L3 at the synthesis boundary |
| CC7 | Redundancy-seven contained components | `MANUSCRIPT / CERTIFIED` | Certificate R7; `RelativeConicArcs.PRSRedundancySixSeven` | Rank--nullity, binary central lift, exact-gcd-one avoidance, and collision propositions close the component assertion; the Lean terminal keeps their geometric meaning explicit; `supporting theorem`; L3 at that boundary |
| R7-sf | Redundancy-seven split-free classification | `MANUSCRIPT / CERTIFIED` | Certificate R7; `redundancySevenAllFieldSynthesis` | Geometry closes `q>=37` through an explicit second-marker bad scheme and the pointed linear-gcd/\(S_3\) bottom packages; the certificate closes the finite bridge, and public representatives are present with the small-field radius flag separated. The repaired two-step proof, fixed-factor exclusion, marker--gcd branch, and sample census invariants have independent cold confirmation; `main theorem`; L3 at the synthesis boundary |
| R7-dh | Redundancy-seven deep-hole classification | `DERIVED / IMPORTED-1` | Seroussi–Roth radius theorem | Valid for `q>=11`; `q=7,8,9` are not promoted without a separate radius result; `boundary`; L1 |
| CC8 | Degree-seven contained components | `MANUSCRIPT / CERTIFIED` | Certificate R8; `RelativeConicArcs.PRSRedundancyEight` | Uniform rank-two containment, empty binary central lift, finite collision divisor, and shallow characteristic-three/five lifts; their concrete geometry remains an explicit terminal input; `supporting theorem`; L3 at that boundary |
| R8 | Redundancy-eight classification for `q>=43` | `MANUSCRIPT / CERTIFIED` | `LP(6,1)` proof; Certificate R8; `redundancyEightHighFieldSynthesis` | Recursive carrier equations, identity-twist monodromy, three-marker deletion, direct gcd-one strata, and `CC(7,1)` are proved and cold-read; exact threshold and synthesis arithmetic are kernel checked; no claim below 43; `main theorem`; L3 at the synthesis boundary |
| R9 | Redundancy-nine classification for `q>=53` | `MANUSCRIPT / CERTIFIED / LEAN-CONDITIONAL` | Certificate R9 plus `supplement/R9-SLICE-DATA.md`; `RelativeConicArcs.PRSRedundancyNine.redundancyNineSynthesis` | Universal good-base open, principal-open cover of the squarefree atlas, boundary-orbit exhaustion, Hermite-subdiscriminant rational selection, corrected deletion bound `32`, and `CC(8,1)` are printed and cold-read; Lean checks the residual algebra and synthesis implication while retaining the geometry, coding identification, exhaustion, and group action as explicit inputs; no claim below 53; `main theorem`; L3 at the synthesis boundary |
| R9-kernel | Residual quadratic algebra and synthesis implication | `KERNEL` | `RelativeConicArcs.Gates.PRSRedundancyNine` and axiom audit | Does not formalize geometric integrality, rational points, coding identification, exhaustion, or the group action; `supporting theorem`; L3 |
| R9-49 | Characteristic-seven carrier closure at `q=49` | `CERTIFIED` | Certificate R9-49 | Carrier result only, not a whole-code classification; `supplement-only`; L1 |
| Hessian | Characteristic-two ordered-Hessian degeneracy locus, contained pullback, and effective corollary | `MANUSCRIPT / CERTIFIED / LEAN-CONDITIONAL` | Certificate Hessian; `RelativeConicArcs.PRSCharacteristicTwoHessianLucas` ordered-Hessian terminals | Reduced pullback is the persistent/Lucas union; the complementary ruling has no rank-two pullback; a genuine degree-eight global-union polynomial gives the revised threshold and deletion budget; Lean checks coordinate algebra and conditional synthesis while the exhaustive geometry remains a structure field; `main theorem`; L3 at that boundary |
| Lucas | Power-of-two Lucas endpoint arithmetic | `MANUSCRIPT / CERTIFIED / KERNEL` | Certificate Lucas; `two_dvd_choose_two_pow`, `consecutiveOverlapIndex_iff`, and the three Lucas-carrier membership terminals | Lucas overlap arithmetic and modular-kernel instances are checked; constant-field and splitting semantics remain inputs; distinguished endpoint only; no claim for all Lucas-carrier points; `supporting theorem`; L3 at that boundary |
| e7-cover | Degree-nine ordered-root and additive covers | `MANUSCRIPT / CERTIFIED / LEAN-CONDITIONAL` | Certificate e7; `endpointLastPair_artinSchreier`, `EndpointArtinSchreierLiftingData.rational_lifts_iff_traceZero`, and `DegreeNineEndpointAdditiveData` | Printed open conditions, geometric Artin--Schreier integrality, trace law, connected affine-frame normalization, and exact `AGL_3(F_2)` deck group; Lean checks the equation and conditional interfaces but not geometric integrality or monodromy; `supporting theorem`; L3 at that boundary |
| e7-shallow | Full `PGL2` orbit of `e_7` is shallow | `MANUSCRIPT / CERTIFIED / LEAN-CONDITIONAL` | Certificate e7; `DegreeNineEndpointAdditiveData.exact_count_and_endpointOrbit_shallow` | Direct subspace-polynomial proof, translation factor, and no-overcount argument are printed and cold-read; Lean derives exact count and orbitwise shallowness from explicit witness-construction and transport fields; other degree-nine carrier strata remain outside the claim; `boundary`; L3 at that boundary |

No row with `OPEN-MATH` or `REVIEW-GATE` is called proof-complete.

## Imported theorem ledger

| Source | Consumed statement | Exact use / non-use |
|---|---|---|
| Seroussi–Roth | normal-rational-curve completeness / PRS radius range | Promotes split-free directions to code deep holes only in its stated fields. |
| Zhang–Wan–Kaipa; Kaipa | syndrome/MDS/uncovered-point dictionary and lower persistent families | Does not supply the redundancy-five or higher classifications. |
| Aubry–Perret / Hasse–Weil | rational-point lower bounds for the specified integral curve models | Does not prove integrality, genus, or deletion budgets. |
| Kaipa–Patanker–Pradhan | binary-quartic orbit and apolar-invariant tools | Does not prove the PRS carrier classification. |
| Cesaratto–Matera–Pérez | factorization-pattern precedent | Context only; not a proof of the exceptional Hankel families. |
| Gmainer–Havlicek | binomial-coordinate NRC nuclei | Locates possible modular kernels; coherent lifts are computed here. |
| Wang | Frobenius/monodromy semantics for splitting families | Does not prove the pointed Hankel induction or its contained cases. |

## Scope-survival ledger

| Mechanism | What survives | What it does not supply |
|---|---|---|
| Hankel correspondence | split-free syndrome criterion | covering radius or code deepness |
| Radius theorem | promotion from split-free to deep in stated fields | syndrome classification |
| Polar-flag construction | coherent markers and squarefree lifting | contained-component exhaustion |
| Transverse induction | a witness outside finite bad/deletion loci | classification of identically contained lines |
| Contained analysis | persistent/modular carriers in the proved degrees | arbitrary-degree classification |
| Finite certificates | exact bounded domains and orbit records | geometric integrality outside the domain |
| Lean kernel | residual algebra and conditional synthesis implication | geometric hypotheses or genuine `PGL2/PGammaL2` orbit derivation |

## Context and novelty ledger

| Claim under comparison | Status | Permitted wording |
|---|---|---|
| R5--R7 classifications | `NONE-FOUND / QUALIFIED` | “To our knowledge, no prior classification was located in the recorded search boundary.” |
| Coherent marked contraction | `NONE-FOUND / QUALIFIED` | “The construction used here differs from the cited unmarked splitting-family semantics.” |
| R8/R9 fixed-level bounds | `NONE-FOUND / QUALIFIED` | “To our knowledge, the recorded search located no such fixed-level PRS bounds.” |
| Ordered-Hessian and Lucas-carrier results | `NO PRIORITY CLAIM` | State the proved boundaries; do not claim first discovery or absence of predecessors. |

The search method and database limitations belong in an adversarial novelty
ledger, not in the mathematical manuscript.

## Optional strengthening ledger

| Direction | Status | Present boundary |
|---|---|---|
| Uniform arbitrary-degree all-carrier contained-component theorem | `OPEN-MATH` | The ordinary rank-two carrier is uniform; marker, modular, and residual carriers remain degree-specific. |
| Bounded-field completion of R8/R9 | `OPEN-MATH` | Theorems begin at 43 and 53. |
| Remaining degree-nine Lucas strata / redundancy ten | `OPEN-MATH` | Only the distinguished `e_7` orbit is closed. |
| Full Lean proof of R9 | `OPEN-MATH` | C517 checks algebra and a conditional implication only. |

## Consistency and release checklist

### Mathematical statements

- [ ] Every “complete,” “exactly,” and “no other” points to a manuscript proof
  plus any finite certificate required for the bounded bridge.
- [x] Split-free and deep-hole statements are separated by a radius row.
- [x] The `q=43` and `q=53` endpoints use the normalized
  `q+kappa-2g sqrt(q)>delta` convention.
- [ ] Every genus, degree, intersection, and deletion number has a named proof.

### Formal and executable trust

- [x] Kernel-checked implications are separated from geometric hypotheses.
- [x] Public certificate labels are separated from internal C-numbers.
- [ ] The immutable release manifest contains hashes, byte counts, commit, tag,
  archive identifier, DOI, and toolchains.
- [ ] Every public classification record exposes canonical representatives,
  stabilizers, invariants, Frobenius fusion, and exhaustion.

### Prose, novelty, and package synchronization

- [x] The manuscript contains mathematical comparison rather than a search diary.
- [x] The role-based bibliography audit is complete, including the pinned
  three-graph forward-citation screen and statement-level Wang citation.
- [ ] `main.tex`, theorem map, proof ledger, verification map, supplement, and
  release metadata agree after the final cold read.
- [ ] No DOI release is labelled proof-complete while an `OPEN-MATH` or
  `REVIEW-GATE` row remains.
