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
| R5 | Complete redundancy-five families and counts | `MANUSCRIPT / CERTIFIED / REVIEW-GATE` | Certificate R5; C540 planned | Full normal-form, stabilizer, degeneration, and cubic-cover proofs must be expanded before green status; `main theorem`; L1 |
| PF | Polar-flag construction and squarefree lifting | `MANUSCRIPT` | C539 planned | Intrinsic construction only; no contained-component classification follows; `main theorem`; L2 |
| TI | Effective transverse induction | `MANUSCRIPT / IMPORTED-1` | Hasse–Weil/Aubry–Perret input; C541 planned | Conditional on a named lower package and a separately proved `CC(n,j)`; `main theorem`; L2 |
| CC6 | Redundancy-six contained components | `MANUSCRIPT / CERTIFIED / OPEN-MATH` | Certificates R6/R6-NF; C541 planned | Every intersection, ramification, and exceptional-characteristic calculation needs a full proposition proof; `supporting theorem`; L1 |
| R6 | Redundancy-six all-field classification | `MANUSCRIPT / CERTIFIED / REVIEW-GATE` | Certificate R6; C541 planned | Finite bridge and radius gate separate; `main theorem`; L1 |
| CC7 | Redundancy-seven contained components | `MANUSCRIPT` | C541 planned | The characteristic-free rank--nullity proof closes `CC(6,1)`; the binary central lift is Proposition R7-central; `supporting theorem`; L2 |
| R7-sf | Redundancy-seven split-free classification | `MANUSCRIPT / CERTIFIED` | Certificate R7; C541 planned | Geometry closes `q>=37`, the certificate closes the finite bridge, and public representatives remain required in the release artifact; `main theorem`; L1 |
| R7-dh | Redundancy-seven deep-hole classification | `DERIVED / IMPORTED-1` | Seroussi–Roth radius theorem | Valid for `q>=11`; `q=7,8,9` are not promoted without a separate radius result; `boundary`; L1 |
| CC8 | Degree-seven contained components | `MANUSCRIPT / CERTIFIED` | Certificate R8; C542 planned | Uniform rank-two containment, empty binary central lift, finite collision divisor, and shallow characteristic-three/five lifts; `supporting theorem`; L2 |
| R8 | Redundancy-eight classification for `q>=43` | `MANUSCRIPT / CERTIFIED` | `LP(6,1)` proof report; Certificate R8; C542 planned | Recursive carrier equations, identity-twist monodromy, three-marker deletion, direct gcd-one strata, and `CC(7,1)` are proved and cold-read; no claim below 43; `main theorem`; L1 |
| R9 | Redundancy-nine classification for `q>=53` | `MANUSCRIPT / CERTIFIED / OPEN-MATH` | Certificate R9; C544 planned | Slice integrality, deletion degrees, and component exhaustion remain manuscript obligations; `main theorem`; L1 |
| R9-kernel | Residual quadratic algebra and synthesis implication | `KERNEL` | `RelativeConicArcs.Gates.PRSRedundancyNine` and axiom audit | Does not formalize geometric integrality, rational points, coding identification, exhaustion, or the group action; `supporting theorem`; L3 |
| R9-49 | Characteristic-seven carrier closure at `q=49` | `CERTIFIED` | Certificate R9-49 | Carrier result only, not a whole-code classification; `supplement-only`; L1 |
| Hessian | Characteristic-two ordered-Hessian degeneracy locus and conditional contained/effective corollary | `MANUSCRIPT / CERTIFIED / OPEN-MATH` | Certificate Hessian; C543 planned | Geometric strata are separated from the unproved root-compatible pullback and global-union base-selection polynomial; `main theorem`; L1 |
| Lucas | Power-of-two Lucas endpoint arithmetic | `MANUSCRIPT / CERTIFIED` | Certificate Lucas; C543 planned | Distinguished endpoint only; no claim for all Lucas-carrier points; `supporting theorem`; L2 |
| e7-cover | Degree-nine ordered-root and additive covers | `MANUSCRIPT / CERTIFIED / OPEN-MATH` | Certificate e7; C543 planned | Open conditions, integrality, trace law, and monodromy proof must be expanded; `supporting theorem`; L1 |
| e7-shallow | Full `PGL2` orbit of `e_7` is shallow | `MANUSCRIPT / CERTIFIED / REVIEW-GATE` | Certificate e7; C543 planned | Direct subspace-polynomial proof; other degree-nine carrier strata remain open; `boundary`; L2 |

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
| R5--R7 classifications | `NONE-FOUND / REVIEW-GATE` | “We did not locate a prior classification in the recorded search boundary.” |
| Coherent marked contraction | `NONE-FOUND / REVIEW-GATE` | “The construction used here differs from the cited unmarked splitting-family semantics.” |
| R8/R9 fixed-level bounds | `NONE-FOUND / REVIEW-GATE` | “We did not locate these fixed-level PRS bounds.” |
| Ordered-Hessian and Lucas-carrier results | `NONE-FOUND / REVIEW-GATE` | No priority wording until the role-based literature audit is complete. |

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
- [ ] The role-based bibliography audit is complete.
- [ ] `main.tex`, theorem map, proof ledger, verification map, supplement, and
  release metadata agree after the final cold read.
- [ ] No DOI release is labelled proof-complete while an `OPEN-MATH` or
  `REVIEW-GATE` row remains.
