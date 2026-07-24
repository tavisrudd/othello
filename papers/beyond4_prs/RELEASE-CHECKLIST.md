# Proof-complete Version 1 checklist

Date: 2026-07-23

This is the operative C545 checklist.  A row is `PASS` only when its
acceptance test has reproducible evidence in the paper tree.  `REVIEW` means
that candidate material exists but still needs a mathematical or rendered
cold read.  `FAIL` means that a required proof, record, or release artifact is
absent.  Passing compilation never upgrades a mathematical row.

## 1. Claim and numerical consistency

| ID | Status | Pass criterion | Current evidence or review action |
|---|---|---|---|
| N1 | PASS | Abstract, Theorems 1.2 and 6.1 all use `q >= 43`; no `q>43` variant remains. | Exact source scan finds zero `q>43` variants. |
| N2 | PASS | One definition of `H_kappa`; every point-bound application records `kappa`. | Definition at `main.tex:711`; application convention at lines 745--750. |
| N3 | PASS | R8/R9 table records `(g,delta,kappa)=(1,30,1)` and `(1,36,1)`, with first prime powers 43 and 53. | Threshold table and preceding calculation at lines 748--764. |
| N4 | PASS | The singular cubic-cover correction is separately assigned `kappa=0`. | `main.tex:745` and `main.tex:1123`. |
| N5 | PASS | Literal `and and` scan is empty. | Exact source scan is empty. |
| SCOPE | FAIL | Every theorem advertised in the abstract is unconditional, or the abstract explicitly presents the object as a research announcement rather than proof-complete Version 1. | R8 and R9 remain conditional headline theorems.  C545 requires the former branch. |

## 2. Proof architecture

| ID | Status | Pass criterion | Current evidence or review action |
|---|---|---|---|
| P1 | REVIEW | Every scheme, stratum, marker space, incidence, bad scheme, collision divisor, and numerical index in transverse induction is defined before use. | Definitions exist in Section 4; run a symbol-by-symbol theorem audit after P2--P7 edits. |
| P2 | REVIEW | Polar construction has a standalone proof of base change, equivariance, infinity, and marker propagation, independent of the dichotomy. | Construction theorem exists; proof needs a cold algebraic read against the source report. |
| P3-R6 | REVIEW | Every R6 contained component is a named proved proposition, including exceptional characteristics. | Ordinary rank-two proposition and `CC(6,1)` text exist; audit all modular branches. |
| P3-R7 | REVIEW | `CC(7,1)` has printed central, collision, and modular proofs. | Candidate expansion exists; verify that no certificate-only step remains. |
| P3-R8 | PASS | The full pointed lower package `LP(6,1)` has printed defining equations, component/monodromy proof, and marker-deletion argument for every recursive stratum. | Proposition `prop:r8-lp61` prints the rank/gcd, cyclic/wild, inseparable, branch, and marker equations; exhausts the degree-three monodromy cases; proves the `S_3` identity twist; and checks outer/inner degree budgets 15/19 plus deletion degree 30. |
| P4 | PASS | Effective transverse theorem is visibly conditional only on named lower-cover, point-bound, deletion, and contained-component hypotheses. | The induction theorem exposes these inputs. |
| P5 | FAIL | Every intersection, containment, ramification, genus, and deletion number maps to a named proof or immutable public certificate. | Assertion audit still has open R5--R9 degree/deletion rows. |
| P6 | FAIL | Ordered-Hessian section proves the ambient incidence, factorization strata, ruling conics, pullbacks, selection argument, and deletion budget; the global bad-union bound is valid. | Root-compatible pullback and one global bad-union argument remain open. |
| P7 | PASS | `e_7` is split into proved Artin--Schreier normalization, additive subcover, and direct shallow-orbit propositions, including translation and no-overcount. | The source derives every collision open, proves the nonconstant geometric Artin--Schreier class and trace law, constructs the connected affine-frame normalization with exact `AGL_3(F_2)` group, and counts translated three-spaces without overcount. |

## 3. Classification and finite ranges

| ID | Status | Pass criterion | Current evidence or review action |
|---|---|---|---|
| C1-R5 | FAIL | Public table gives canonical representatives, invariants, stabilizers, Frobenius fusion, and completeness for every R5 orbit, including equal-size classes. | Certificate schema exists; public records are incomplete and manuscript still names internal C491 data. |
| C1-R6 | FAIL | Same public record for R6. | Manuscript still names internal C498 data. |
| C1-R7 | FAIL | Same public record for R7, with split-free versus code-deep status separated. | Manuscript still names internal C509 data. |
| C2 | REVIEW | Every prime power below every geometric threshold is assigned to geometry, a direct certificate, radius exclusion, or an explicit open gate. | Field-range tables exist; cross-check them against certificate domains and radius premises. |
| C3 | PASS | Every R7 code-deep statement retains the `q>=11` covering-radius premise. | Closed in manuscript; retain during proof edits. |
| C4 | PASS | The characteristic-seven carrier is separate from whole-code R9 classification. | Separate proposition and non-classification warning are present. |

## 4. Reproducibility and formal boundary

| ID | Status | Pass criterion | Current evidence or review action |
|---|---|---|---|
| R1 | FAIL | Public-facing manuscript uses stable `Certificate R5`--`Certificate e7` labels, with no internal C-number artifact references. | Exact scan finds four C-number lines. |
| R2 | REVIEW | Certificate schema lets an external implementer identify inputs, outputs, orbit convention, stop condition, and independent replay class. | `supplement/CERTIFICATE-SCHEMA.md` exists; cold implementer read required. |
| R3 | REVIEW | Reproduction guide gives literal commands, working directories, toolchains, searched domains, and stop conditions. | `supplement/REPRODUCING.md` exists; execute every public command from the export. |
| R4 | FAIL | Immutable manifest contains final commit, archive identifier, hashes, byte counts, toolchain lock, and one row per public artifact. | Development template has 12 `TBD` lines. |
| R5 | FAIL | Public paper-only repository URL, immutable tag/commit, and DOI/permanent archive URL resolve. | No public release exists. |
| F1 | REVIEW | Statement-adequacy appendix reproduces each adopted Lean headline and states the exact paper-to-formal boundary. | Appendix and formalization ledger exist; C540--C544 remain queued. |
| F2 | FAIL | Aggregate C544 import, axiom, target, and manuscript-reconciliation gates pass on one pinned shared-public-Lean commit. | C544 is not complete. |

## 5. Exposition, literature, and responsibility

| ID | Status | Pass criterion | Current evidence or review action |
|---|---|---|---|
| E1 | PASS | Abstract is 180--220 words and contains only the dictionary, mechanism, classifications, and one characteristic-two sentence. | Mechanical extraction counts 191 words; retain during theorem edits. |
| E2 | REVIEW | Notation and terminology tables precede first technical use and cover every stable term. | Notation table begins at `main.tex:116`; cold read required. |
| E3 | REVIEW | Roadmap visibly shows construction followed by transverse/contained branches and lifting. | Overview table exists; inspect rendered page after source split. |
| E4 | REVIEW | Paper contains mathematical comparison, not dated search-process narrative or database disclaimers. | Run paragraph-level literature cold read. |
| E5 | FAIL | Every novelty comparison has a verified citation with complete metadata and an archived literature-audit record. | Source audit remains open. |
| E6 | PASS | Long theorem inventories are upright and the literal phrase `paper spine` is absent. | Exact phrase scan is empty. |
| E7 | REVIEW | Public verification table is compact, breakable, and does not create a nearly empty preceding page. | Inspect final rendered PDF after all row changes. |
| E8 | FAIL | Thin driver, one file per major section, and separate appendices all build. | Most of the manuscript remains in the monolithic `main.tex`. |
| PR | REVIEW | Titled provenance/responsibility section identifies derivation, computation, formalization, and author responsibility without overstating review. | Section exists; author confirmation remains external. |

## 6. Adversarial and release gates

| ID | Status | Pass criterion | Current evidence or review action |
|---|---|---|---|
| A1 | FAIL | Claim/proof ledger has no `OPEN-MATH` or `REVIEW-GATE` row for an abstract theorem. | Current ledger has 12 `OPEN-MATH` occurrences. |
| A2 | FAIL | Independent cold reader marks every L1 claim green or supplies a closed correction. | Adversarial audit has six open theorem/repair rows. |
| A3 | REVIEW | Every paper-facing computational statement replays from committed public inputs by a structurally independent check. | Verification map exists; execute after public-export assembly. |
| X1 | FAIL | Paper-only fresh-history export builds and replays from a clean checkout and pins exactly one public Lean commit, target list, and axiom audit. | Export not yet created. |
| X2 | FAIL | All authors, order, affiliations, acknowledgements, and account authority are confirmed. | Requires author confirmation immediately before release. |
| X3 | FAIL | Selected journal family and its current preprint/prior-publication policy are archived with date and stable URL. | Defer exact policy check until the artifact and venue choice are final. |
| X4 | FAIL | Exact same-file preprint records are cross-linked, visibly unrefereed, and use one title/abstract/claim set. | No upload attempted. |
| X5 | FAIL | DOI, timestamp, version, source commit, hashes, and public URLs are recorded and resolve. | No upload attempted. |

## Work order

1. Close P3-R8, P5, P6, and P7 without weakening the advertised theorem
   scope.
2. Publish the R5--R7 classification records and close C2/R1--R3.
3. Complete C540--C544 and reconcile F1--F2.
4. Close E5 and perform the symbol, rendered, and adversarial cold reads.
5. Split the source, build/replay the clean paper-only export, and fill R4/X1.
6. Confirm authors and venue, recheck policy, then prepare the exact upload
   artifact.  External publication remains a separate irreversible action.
