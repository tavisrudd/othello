# C545 full cold read of *Projective Reed--Solomon syndromes beyond redundancy four* at `fbf6099ef1a8685473fe3a71d08bf16840576407`

**Date:** 2026-07-23  
**Immutable review target:** `fbf6099ef1a8685473fe3a71d08bf16840576407`  
**Reviewer:** 5.6-sol-xhigh  
**Scope:** `papers/beyond4_prs/main.tex`, all twelve `\input` sources, `refs.bib`, and only the paper-local certificate/release records needed to test manuscript claims, all read from the immutable target.

## Overall verdict

**HOLD / NOT RELEASE-READY.** The paper has a strong, intelligible theorem spine and several excellent local arguments, but it does not yet meet its own “proof-complete pre-release candidate” description. There are two demonstrated mathematical proof blockers:

1. the redundancy-nine theorem uses a four-marker lower-package implication that is not stated or proved; Proposition `prop:r9-budgets` supplies only numerical budgets, not the missing monodromy, recursive-stratum, and contained-component package;
2. the ordered-Hessian degeneracy and root-compatible pullback classifications replace the decisive component/elimination calculations by assertions (“normal forms show” and “Lucas' theorem gives precisely”), while the verification section expressly says the finite Hessian certificate is only a regression test.

There are further major proof-completeness problems in the redundancy-six component argument and in the very long redundancy-eight pointed lower-package proof. Independently, a DOI release is mechanically blocked because `supplement/RELEASE-MANIFEST.md` is still a template with every immutable-release field and artifact row marked `TBD`.

This verdict is not “the results look false.” The residual algebra, point-count arithmetic, Hankel dictionary, coherent-marker mechanism, rank-two containment argument, and degree-nine \(e_7\) witness construction mostly check out. The verdict is that several load-bearing classifications are not established by the prose printed at this SHA.

### Explicit pass criteria

A release pass requires all of the following:

1. Add and prove the actual pointed degree-seven/four-marker lower package needed by `thm:r9`, or weaken the R9 theorem to the conditional statement currently shown in the overview table.
2. Expand `thm:hessian` and `prop:hessian-pullback` into checkable component proofs: equations/ideals, all characteristic-two normal-form cases, vertical-factor removal, both ruling conics, scheme/reduced semantics, and the root-compatible overlap calculation.
3. Expand the R6 and R8 component arguments identified below, with explicit equations or precise supporting lemmas. Correct the characteristic restriction in `prop:r6-degrees`.
4. Reconcile every theorem/overview/boundary statement and state characteristic and covering-radius hypotheses at the declaration where they are used.
5. Ship a self-contained paper-only supplement containing the actual generators, certificates, replays, commands, hashes, byte counts, Lean pin/targets, repository URL, tag, commit, archive identifier, and DOI; make the release manifest complete.
6. Re-run the immutable-source build and every declared replay, and obtain an independent proof cold read with no BLOCKER and no unresolved MAJOR affecting a headline theorem.

The exact snapshot compiled successfully with `make check` in an immutable `git archive` extraction (35 pages, no warning selected by the Makefile gate). That is a typesetting pass, not a proof pass. The checked-out historical `main.pdf` had a different byte hash from the rebuilt PDF, plausibly because the build is not reproducible at the byte level; the release bundle must either make the build reproducible or record and explain the build metadata.

## Ranked top five standouts

1. **The syndrome/Hankel/radius separation is exceptionally clear.** `03-dictionary.tex:20-53` cleanly distinguishes split-free systems from code deep holes and prevents the small-field R7 certificate from being silently promoted.
2. **The marked-root mechanism is the conceptual center and is genuinely persuasive.** Equation `eq:lift` and `thm:polar-construction` (`05-polar-induction.tex:9-20,109-127`) explain exactly why an unmarked lower witness is insufficient and how squarefree lifting works.
3. **The contained rank-two line lemma is the strongest self-contained proof in the paper.** `prop:contained-rank-two` (`05-polar-induction.tex:213-264`) turns the geometric claim into a short rank--nullity and hyperplane-intersection argument valid in every characteristic.
4. **The R9 residual algebra and rational base-selection architecture are unusually explicit.** `07-fixed-level-eight-nine.tex:315-458`, together with `supplement/R9-SLICE-DATA.md`, separates identities, geometric coverage, rational selection, and deletion degrees. The Bézout identity is used as a family cover rather than misrepresented as six point tests.
5. **The \(e_7\) endpoint closes with a simple constructive witness.** `09-lucas-carriers.tex:199-229` bypasses the generic Artin--Schreier cover and uses three-dimensional \(\mathbb F_2\)-subspaces directly; the count and orbit transport check cleanly.

## Ranked worst five issues and actionable repairs

1. **BLOCKER — missing R9 lower package.**  
   **Anchors:** `02-overview.tex:101-106`; `07-fixed-level-eight-nine.tex:292-313,568-586`; `11-provenance-boundary.tex:25-27`.  
   The overview calls R9 a “conditional persistent-only target,” while `thm:r9` and the boundary call it complete. `prop:r9-budgets` proves only \(\delta=36\) and a first-line degree budget. Unlike R8, there is no `LP(7,1)`-type theorem proving the recursive four-marker identity twists, exact-gcd strata, inseparable/cyclic/wild boundaries, or intermediate contained/collision assertions. The proof sentence “Proposition `prop:r9-budgets` handles every transverse nonmodular point” does not follow from the proposition.  
   **Repair:** state the required lower package formally, print its equations and component proof, and invoke it in `thm:r9`; otherwise make R9 conditional everywhere.

2. **BLOCKER — ordered-Hessian classification is asserted, not proved.**  
   **Anchors:** `08-ordered-hessian.tex:59-121`.  
   The complete degeneracy locus of a family of \((2,2)\) curves and the exact reduced root-compatible pullback are headline results. The proof gives no normal forms, equations, ideal decomposition, or exhaustive characteristic-two case analysis. The phrases “Semisimple and unipotent normal forms show” and “Lucas' theorem gives precisely” are the missing theorem. The paper itself says Certificate Hessian is only a \(PG(3,4)\) regression and does not replace this proof.  
   **Repair:** print the Plücker-coordinate equations, factor/component ideals, vertical-factor saturation, both Fano rulings, the scheme/reduced distinction, and the consecutive-Hankel elimination. A compact appendix is preferable to prose assurances.

3. **BLOCKER (release) — the public trust route is not self-contained or immutable.**  
   **Anchors:** `10-verification.tex:75-83`; `supplement/REPRODUCING.md:1-26,60-79`; `supplement/RELEASE-MANIFEST.md:1-36`.  
   The paper-local supplement points back to development-monorepo `notes/` paths for the actual artifacts, while the release manifest contains only `TBD`. This is candidly disclosed, but it means no DOI-bearing release can presently satisfy the paper's own verification claims.  
   **Repair:** create the fresh-history export, include minimal artifacts and replay code, fill every manifest row from released bytes, pin the Lean commit, and test the archive from a clean environment.

4. **MAJOR — the R6 all-field proof rests on underproved and once incorrectly scoped component claims.**  
   **Anchors:** `06-redundancies-six-seven.tex:89-165,190-218`.  
   `prop:r6-degrees(i)` says “characteristic different from two” but writes \(\operatorname{diag}(1,4,6,4,1)^{-1}\), which is undefined in characteristic three. Parts (ii), the wild-cone overlap, and the binary-plane uniqueness are dispatched by one-line assertions without the promised overlap equations. These claims are then used to bridge finite certificates to every field.  
   **Repair:** change (i) to characteristic different from two **and three** (or explicitly say the tame stratum is empty in characteristic three), print the derivative-minor/gcd argument, and give the consecutive-row eliminations for the wild cone and binary plane.

5. **MAJOR — the R8 lower-package proof is too compressed to audit its claimed exhaustiveness.**  
   **Anchors:** `07-fixed-level-eight-nine.tex:46-194`.  
   The proposition is load-bearing and much improved over an announcement, but it still asserts that Fitting-minor images are the complete strata, that the inseparable degeneration adds no stratum, that several pulled-back minors cannot vanish identically, and that every collision maps into a chosen ramification divisor without enough local algebra to verify those implications.  
   **Repair:** split this proof into named lemmas (gcd strata, cyclic/wild/inseparable strata, marker divisors, collision separability, outer and recursive parameter selection), with one explicit ideal or coefficient calculation per noncontainment claim.

## Compact defect table

| ID | Severity | Type | Exact anchor | Finding | Required action |
|---|---|---|---|---|---|
| D1 | BLOCKER | demonstrated gap | `07-fixed...tex:292-313,568-586` | R9 budgets do not imply the missing four-marker lower package | prove `LP(7,1)` analogue or weaken theorem |
| D2 | BLOCKER | demonstrated gap | `08-ordered-hessian.tex:59-121` | component and pullback exhaustions omit decisive calculations | add ideal/normal-form/elimination proof |
| D3 | BLOCKER | demonstrated release gate | `supplement/RELEASE-MANIFEST.md:1-36` | immutable release fields and artifact rows are all `TBD` | build and validate self-contained release |
| D4 | MAJOR | demonstrated statement error | `06-redundancies...tex:92-108` | inverse binomial rescaling is claimed in characteristic three, where \(6=0\) | restrict to \(\operatorname{char}\ne2,3\) and separate char. 3 |
| D5 | MAJOR | demonstrated proof gap | `06-redundancies...tex:118-165` | Wronskian nonvanishing and modular component uniqueness are asserted without calculations | print overlap/gcd equations |
| D6 | MAJOR | demonstrated proof gap | `07-fixed...tex:55-194` | R8 lower-package exhaustiveness has several unsupported component/noncontainment steps | split into explicit lemmas |
| D7 | MAJOR | demonstrated scope omission | `07-fixed...tex:381-427` | `prop:r9-components` is stated without characteristic seven, but its proof is over \(\mathbb F_7\) | add characteristic-seven hypothesis |
| D8 | MAJOR | demonstrated inconsistency | `02-overview.tex:101-106` vs. `07-fixed...tex:270-285,568-586` | overview calls R8/R9 conditional while theorems call them complete | reconcile after proof gates close |
| D9 | MAJOR | demonstrated exposition gap | `04-redundancy-five.tex:224-233` | inseparable trivial-gcd exhaustion is reduced to “overlap equations” with no equations | add a lemma/classification calculation |
| D10 | MAJOR | demonstrated dependency gap | `07-fixed...tex:278-285,576-585` | “imported covering-radius theorem” is unnamed at use and its exact inequality is not checked | cite and verify the specialization in each proof |
| D11 | MINOR | precision | `05-polar-induction.tex:223-264` | “scheme-theoretically” modifies a truth-valued containment and is stronger than the pointwise wording | formulate the universal minors/ideal statement |
| D12 | MINOR | terminology | `07-fixed...tex:365-379` | “squarefree reduction ... not a square” is redundant/unclear in odd characteristic | say \(K\notin\bar k(x)^{\times2}\) and give the reduced branch degree |
| D13 | MINOR | prose/scope | `01-introduction.tex:133-138` | “displayed finite domains through \(q=32\)” is not a mathematical domain specification | list the domain or point to the exact certificate row |
| D14 | QUERY | clarification request | `06-redundancies...tex:211-218`; paper-local records | the public JSON proves exhaustion identities but does not itself rerun the finite classifications | say prominently that it is a deterministic projection, and ship replays in release |
| D15 | QUERY | clarification request | `08-ordered-hessian.tex:135-153` | the two selected equations \(A,B\) depend on the syndrome; this is valid pointwise but not stated | state the quantifier order and why both pullbacks are nonzero |
| D16 | PRAISE | robust boundary | `03-dictionary.tex:43-53`; R7 records | split-free and code-deep flags are kept separate | preserve this wording |
| D17 | PRAISE | robust mechanism | `05-polar-induction.tex:109-127` | marker avoidance exactly characterizes squarefree lifting | retain as the organizing lemma |

“Demonstrated gap” means the printed implication is absent or the printed formula is invalid in part of its stated characteristic range. “Query” means the argument may be correct but the manuscript should clarify the quantifier or trust boundary; it is not asserted here to be false.

## Sequential paragraph/source coverage ledger

I read the source in include order, not by topic search. The twelve included files contain 224 blank-line-delimited source blocks; every block was traversed. Contiguous clean prose blocks are consolidated below, while every proof is separately itemized in the next section.

| Order | Immutable source and complete line coverage | Sequential notes |
|---:|---|---|
| 0 | `main.tex:1-106` | Preamble and include order compile. Abstract `60-87` accurately distinguishes R7's radius gate and the open degree-nine strata, but overstates R9 until D1 closes. |
| 1 | `01-introduction.tex:1-209` (13 source blocks) | `3-24` dictionary/context clear; `49-62` terminology useful; `64-69` candid release status; `71-111` R5 headline inherits P06/P08 gaps; `124-163` spine inherits D1/D4-D6; `165-197` prior-work boundary is well organized; `199-209` organization accurate except for proof-completeness status. |
| 2 | `02-overview.tex:1-143` (11 blocks) | `7-48` is the best prose explanation of the mechanism; `81-109` contains the stale conditional/unconditional conflict D8; `111-138` trust-boundary table is excellent; `140-143` is accurate as an intended flow, not as a completed R9 proof. |
| 3 | `03-dictionary.tex:1-64` (7 blocks) | Coordinates and split-free/radius distinction checked; proof P01 below; `55-64` persistent gcd bound correct. |
| 4 | `04-redundancy-five.tex:1-262` (24 blocks) | Coordinates, radius, gcd strata, cubic cover, cyclic and \(S_3\) cases, finite bridge, and table all traversed. Arithmetic totals and sporadic table reconcile with the paper-local classification records. D9 is the main missing proof step. |
| 5 | `05-polar-induction.tex:1-293` (23 blocks) | Definitions, figures, transverse theorem, threshold table, rank-two containment, orbit paragraph, and scope remark all checked. Threshold algebra is correct. The rank-two proof is notably economical. |
| 6 | `06-redundancies-six-seven.tex:1-424` (38 blocks) | R6 persistent, secant, cyclic/collision, modular, nucleus, theorem/certificate bridge; then R7 pointed/gcd/collision/central/contained/theorem and field ledger. D4-D5 affect the R6 bridge. R7's field coverage has no numerical gap: the certificate ends at 32 and the theorem range begins at the next prime power 37. |
| 7 | `07-fixed-level-eight-nine.tex:1-592` (50 blocks) | All R8 lower-package equations and budgets, modular/contained claims, R8 theorem; all R9 residual formulas, slice data, rational selection, deletion, finite bridges, orbit laws, modular/contained claims, and R9 theorem. D1, D6, and D7 are the main findings. |
| 8 | `08-ordered-hessian.tex:1-167` (14 blocks) | Setup, figure, geometric theorem, pullback, effective corollary, and boundary all checked. Degree arithmetic in the effective corollary is correct conditional on the missing component theorem; D2 is load-bearing. |
| 9 | `09-lucas-carriers.tex:1-235` (22 blocks) | Lucas overlap, linearized cover, \(e_7\) orbit, Artin--Schreier quotient, additive cover, witness count, and final boundary checked. The direct witness count is correct. |
| 10 | `10-verification.tex:1-128` (7 blocks) | Trust routes, ten certificate labels, release boundary, Lean limits, and formal table checked. It is admirably candid, but the release route is not yet self-contained (D3). |
| 11 | `11-provenance-boundary.tex:1-49` (6 blocks) | Provenance and six boundary items checked. R9 completeness in `25-27` must follow the resolution of D1. |
| 12 | `appendices/statement-adequacy.tex:1-95` (9 blocks) | Verbatim definitions, synthesis terminal, explanatory boundary, and axiom audit checked. The terminal is logically adequate only because the geometric/coding inputs are explicit hypotheses; it does not strengthen the manuscript proofs. |
| 13 | `refs.bib:1-176` | All 13 entries traversed. DOI/arXiv fields are syntactically consistent and the bibliography compiles. The key `GmainerHavlicek2013` names an article whose journal year is 2000 and whose arXiv posting is 2013; harmless internally but worth renaming for human clarity. |

Paper-local records additionally checked at the same SHA:

- `supplement/CERTIFICATE-SCHEMA.md:1-83`;
- `supplement/CLASSIFICATION-RECORDS.json` (19 R5, 11 R6, and 14 R7 field rows; all recorded exhaustion identities true; R7 radius status null at \(q=7,8,9\));
- `supplement/R9-SLICE-DATA.md:1-129`;
- `supplement/REPRODUCING.md:1-79`;
- `supplement/RELEASE-MANIFEST.md:1-36`;
- `verification-map.md:1-103`.

These records corroborate the finite domains and the R9 Bézout data. They do not fill the missing geometric proofs, and the schema explicitly says they should not.

## Proof-by-proof verdict ledger (47/47)

Each entry records the claim, mechanism, correctness verdict, hidden assumptions/boundary cases, and whether a simpler exposition is available.

1. **P01 — `lem:hankel`, `03-dictionary.tex:20-41`.** Claim: span membership is equivalent to a split recurrence polynomial in \(W_f\), including confluent/infinity cases. Mechanism: ordinary and confluent Vandermonde recurrence bases. **Verdict: PASS, terse.** Assumes the coefficient-extraction pairing fixes the sign/reversal convention; infinity is only described. Simpler: print one coefficient identity \(H_fg=0\) and obtain all charts by equivariance.
2. **P02 — `prop:r5-radius`, `04-redundancy-five.tex:12-32`.** Claim: \(\rho(\PRS(q-4))=4\) for all \(q\ge7\). Mechanism: Seroussi--Roth completeness inequality. **Verdict: PASS conditional on the cited theorem.** Boundary exceptions \(k=2,q-2\) are checked correctly. Simpler: substitute \(k=q-4\) into the inequality in one displayed line.
3. **P03 — `prop:r5-gcd2`, `04...tex:36-60`.** Claim: quadratic-gcd pencils give tangent/conjugate-secant families and counts. Mechanism: dimension, factor types, confluent/conjugate Hankel dictionary. **Verdict: PASS.** Assumes established lower-redundancy orbit counts. Simpler: tabulate the three factor types and outcomes.
4. **P04 — `prop:r5-gcd1`, `04...tex:62-78`.** Claim: every linear-gcd pencil is shallow for \(q\ge8\). Mechanism: rational deck involution of a separable quadratic pencil plus deletions; exclude inseparability by Hankel overlap. **Verdict: PASS but counting prose is opaque.** Fixed points and points over branch values overlap, so the deletion explanation should distinguish ordered graph points from fibers. The bound is safely conservative. Simpler: count directly on the involution graph.
5. **P05 — `prop:r5-incidence`, `04...tex:88-117`.** Claim: trivial-gcd cubic pencil gives a degree-three map and residual \((2,2)\) fiber square. Mechanism: graph/bidegree and monodromy-orbit correspondence. **Verdict: PASS.** Geometric gcd-freeness and separability are the key assumptions. Simpler: call \(X_f\) the graph of \([c_1:c_2]\), hence isomorphic to \(\mathbb P^1\).
6. **P06 — `lem:cyclic`, `04...tex:119-185`.** Claim: tame osculating-pair and wild characteristic-three cyclic families. Mechanism: Riemann--Hurwitz, Frobenius action on a deck generator, Hasse derivative nucleus, Artin--Schreier normal form. **Verdict: MAJOR EXPANSION NEEDED.** The tame calculation checks, but the classification of every remaining wild cover by the displayed normal form is compressed into “comparing coefficients.” Hidden boundaries are \(a=0\), inseparability, infinity, and stabilizer completeness. Simpler: isolate a normal-form lemma with the translation equations.
7. **P07 — `lem:s3`, `04...tex:187-212`.** Claim: no \(S_3\)-stratum deep pencil for \(q\ge23\). Mechanism: geometrically integral residual curve, Aubry--Perret, 4 diagonal plus 8 singular-fiber deletions. **Verdict: PASS.** The strict inequality is correct at 23. State explicitly that two rational roots force the third rational by rational coefficients. Simpler: one deletion table.
8. **P08 — `prop:r5-bridge`, `04...tex:214-234`.** Claim: gcd/cyclic/\(S_3\)/certificate cases exhaust R5. Mechanism: trichotomy by gcd and monodromy. **Verdict: MAJOR GAP.** The inseparable trivial-gcd case is asserted from unprinted “overlap equations”; certificate semantics do not prove the all-field inseparable reduction. Simpler: add a short inseparable-pencil lemma.
9. **P09 — `thm:polar-construction`, `05-polar-induction.tex:109-127`.** Claim: contraction is equivariant and marker-avoiding lower witnesses lift squarefreely. Mechanism: perfect pairing and repeated `eq:lift`. **Verdict: PASS.** Configuration-space distinctness is the only boundary. This is already near-minimal.
10. **P10 — `thm:induction`, `05...tex:144-177`.** Claim: a proved lower package plus `CC(n,j)` and two numerical inequalities force split-free points into contained carriers. Mechanism: choose a rational contraction parameter, then a rational lower-cover point outside deletions. **Verdict: PASS as a conditional theorem.** Assumes every selected lower point lies on a recorded rational twist and that \(b+c\) includes all parameter-level exclusions. Simpler: split parameter selection and cover-point selection into two lemmas.
11. **P11 — `prop:contained-rank-two`, `05...tex:213-264`.** Claim: a whole polar line lies in lower rank two iff the upper three-row catalecticant has rank at most two; otherwise degree at most three. Mechanism: restriction to \(\lambda\Sym^{n-3}\), rank--nullity, intersection of all divisibility hyperplanes. **Verdict: PASS.** Requires injective first contraction and \(n\ge5\). Simpler exposition is not needed; only clarify “scheme-theoretically.”
12. **P12 — `prop:r6-persistent`, `06-redundancies...tex:19-46`.** Claim: persistent R6 count and \(T/T^5\) orbit law. Mechanism: annihilator line for fixed \(Q\), endpoint removal, direct stabilizer action. **Verdict: PASS, with hidden duality step.** Explain why containment \(Q\Sym^2\subset W_f\) is equivalent to annihilating \(Q\Sym^3\). Simpler: one dual exact-sequence sentence.
13. **P13 — `prop:r6-secant`, `06...tex:48-87`.** Claim: contraction identity and degree-three lower secant pullback. Mechanism: explicit catalecticant product and Cauchy--Binet cubic. **Verdict: PASS.** The equivalence “all minors zero iff quadratic gcd” should cite the preceding catalecticant fact. The determinant formula is a simpler argument than elimination.
14. **P14 — `prop:r6-degrees`, `06...tex:89-132`.** Claim: tame cyclic, pointed ramification, and deletion degrees. Mechanism: Veronese model, Wronskian, bottom-cover deletion. **Verdict: MAJOR / PARTLY INVALID AS STATED.** The inverse diagonal is undefined in characteristic three despite the stated \(\operatorname{char}\ne2\); the small-characteristic Wronskian exclusions are asserted. Simpler: state three characteristic cases separately and print the overlap rows.
15. **P15 — `prop:r6-modular`, `06...tex:134-165`.** Claim: no char.-3 wild-cone polar line and unique char.-2 binary contained line. Mechanism: rulings plus consecutive-row overlap/direct substitution. **Verdict: MAJOR EXPANSION NEEDED.** The variables in the substitution are not defined and the overlap eliminations are not shown. Boundary at infinity is asserted. Simpler: two coefficient matrices and their row reductions.
16. **P16 — `prop:r6-nucleus`, `06...tex:167-184`.** Claim: binary nucleus line is one orbit and split-free iff \(m\) odd. Mechanism: linearized quartic kernel and Borel orbit. **Verdict: PASS.** Boundaries \(B=0\), \(C=0\), and infinity are implicit but harmless. Simpler: state that any split member must have \(C\ne0\).
17. **P17 — `thm:r6`, `06...tex:190-218`.** Claim: all-field R6 deep-hole classification. Mechanism: P12--P16, conceptual thresholds, finite certificate bridge, radius gate. **Verdict: NOT YET PROOF-COMPLETE because P14--P15 are load-bearing.** Field coverage itself is complete (finite list plus characteristic-specific next fields). Simpler: a characteristic-by-characteristic range table inside the proof.
18. **P18 — `prop:r7-pointed`, `06...tex:251-267`.** Claim: two-marker bottom deletion is 24 and works from \(q=37\). Mechanism: R5 curve plus two six-point marker fibers. **Verdict: PASS.** Uses \(\kappa=0\) conservatively. Simpler: reuse the threshold table explicitly.
19. **P19 — `prop:r7-gcd1`, `06...tex:269-287`.** Claim: exact-gcd-one lower net has a split cubic avoiding two markers for \(q\ge16\). Mechanism: ordered pair count on \(\mathbb P^1\times\mathbb P^1\) and bidegree union bound. **Verdict: PASS.** Nonzero-divisor assertions rely on the spanning of double-root cubics, which is valid. Simpler: list the five bad divisors and summed bidegree 10.
20. **P20 — `prop:r7-collision`, `06...tex:289-300`.** Claim: self-collision degree at most eight. Mechanism: ramification of separable \(g^3_5\). **Verdict: PASS, terse.** An inseparable series factors after fixed-divisor removal; say this explicitly. Simpler: cite the standard Wronskian degree formula.
21. **P21 — `prop:r7-central`, `06...tex:310-325`.** Claim: unique coherent binary lift and odd/even law. Mechanism: row support overlap, contraction to R6 nucleus, \(t^4+t\) witness. **Verdict: PASS.** Infinity is correctly simple after homogenization. Already simple.
22. **P22 — `cor:r7-contained`, `06...tex:327-343`.** Claim: complete degree-six contained rank-two component. Mechanism: P11 plus quadratic factor types and P21. **Verdict: PASS conditional on treating the binary nucleus separately.** No simpler argument needed.
23. **P23 — `thm:r7`, `06...tex:345-382`.** Claim: all-field split-free R7 classification and deep-hole promotion for \(q\ge11\). Mechanism: transverse bounds, contained components, finite bridge, radius theorem. **Verdict: PASS modulo certificate trust and the earlier component calculations.** No prime-power range gap. Simpler: cite the field-range table in the proof.
24. **P24 — `prop:r8-bottom`, `07-fixed...tex:5-32`.** Claim: R8 deletion 30 and parameter budget 14. Mechanism: three marker fibers, catalecticant/nucleus intersections, \(g^4_6\) ramification. **Verdict: PASS as a budget lemma.** Separability dimension count is correct but should name fixed-factor removal. Simpler: one two-level budget table.
25. **P25 — `prop:r8-lp61`, `07-fixed...tex:46-194`.** Claim: complete pointed lower package with outer/recursive budgets 15/19 and unique genus-one twist. Mechanism: explicit Hankel minors, carrier normal forms, monodromy, gcd-one deck involution, ramification bounds. **Verdict: MAJOR PROOF-COMPLETENESS GAP.** Several scheme-image, inseparable, nonidentical-vanishing, and collision implications are asserted rather than derived. Boundary charts are mentioned but not shown. Simpler: decompose into five named lemmas.
26. **P26 — `prop:r8-modular`, `07-fixed...tex:196-219`.** Claim: degree-seven Lucas lifts and shallowness. Mechanism: Lucas supports, \(t^5-t\), and a conic avoidance construction. **Verdict: PASS conditional on the unprinted Lucas row reduction.** The conic deletion bound is safe. Simpler: include the support matrices from Certificate R8.
27. **P27 — `prop:r8-contained`, `07-fixed...tex:221-260`.** Claim: all degree-seven contained components and finite collision. Mechanism: P11, overlap for central lift, Lucas list, separability/ramification. **Verdict: PASS conditional on P26's complete overlap claim.** Dimension inequality is correct. Simpler: explicitly define the moving series after fixed-divisor removal.
28. **P28 — `thm:r8`, `07-fixed...tex:270-285`.** Claim: persistent-only R8 for \(q\ge43\). Mechanism: P24--P27 plus covering radius. **Verdict: MAJOR HOLD because P25 is not yet referee-checkable.** The covering-radius import also needs its exact specialization. Simpler: state the radius inequality.
29. **P29 — `prop:r9-budgets`, `07-fixed...tex:292-313`.** Claim: four-marker deletion 36 and first-line budget 17. Mechanism: bottom curve, four marker fibers, carrier intersections, \(g^5_7\) ramification. **Verdict: PASS AS BUDGETS ONLY.** It does not prove a lower splitting package. This distinction is the key R9 blocker.
30. **P30 — `prop:r9-residual`, `07-fixed...tex:336-363`.** Claim: residual quadratic formulas and collision divisors. Mechanism: two Hankel equations and Cramer's rule. **Verdict: PASS.** Requires \(D\ne0\); the \(D=0\) boundary is correctly separated. This is already minimal.
31. **P31 — `prop:r9-slice`, `07-fixed...tex:365-379`.** Claim: one-moving-root branch degree and genus. Mechanism: degree count and hyperelliptic formula. **Verdict: PASS in odd characteristic.** The statement should explicitly inherit characteristic seven and replace the redundant “squarefree ... not a square” wording.
32. **P32 — `prop:r9-components`, `07-fixed...tex:381-458`.** Claim: every nonzero geometric carrier quartic has a good slice; rational base for \(q>102\). Mechanism: six-section Bézout cover of squarefree moduli, boundary normal forms, subdiscriminant and Schwartz--Zippel. **Verdict: PASSABLE IN CHARACTERISTIC SEVEN, INVALIDLY UNSCOPED AS WRITTEN.** The proof data live in \(\mathbb F_7\); add that hypothesis. The degree-102 argument checks. Simpler: move the long explicit data reference into a lemma named “principal-open cover.”
33. **P33 — `prop:r9-deletion`, `07-fixed...tex:460-481`.** Claim: deletion total 32 on a normalized good slice. Mechanism: pullback degrees under a double cover, with branch points counted once. **Verdict: PASS.** Assumes no listed resultant vanishes identically on the chosen good slice; say how base selection avoids that. The five-entry list is already simple.
34. **P34 — `prop:r9-char7`, `07-fixed...tex:483-506`.** Claim: 819 rootless quartics at \(q=7\), exhaustive witnesses at \(q=49\). Mechanism: projective inclusion--exclusion and one exhaustive certificate. **Verdict: PASS at the declared trust boundary.** The \(q=49\) clause is not independently exhaustive, and the text says so. Simpler: none.
35. **P35 — `prop:r9-orbits`, `07-fixed...tex:508-523`.** Claim: \(T/T^8\) and tangent orbit law. Mechanism: powers, inversion, Frobenius, unipotent translation. **Verdict: PASS.** The phrase “coefficient Frobenius” should consistently mean \(p\)-power action. Simple already.
36. **P36 — `prop:r9-other-modular`, `07-fixed...tex:525-538`.** Claim: only char.-5 line and char.-7 quartic carrier; char.-5 shallow. Mechanism: Lucas overlap and \((t^5-t)(t-a)\). **Verdict: PASS conditional on the complete Lucas support calculation.** Requires \(a\notin\mathbb F_5\), available for every char.-5 \(q>5\). Simple.
37. **P37 — `prop:r9-contained`, `07-fixed...tex:540-566`.** Claim: complete degree-eight contained components and finite collision. Mechanism: P11, P36, inseparability dimension bound, ramification. **Verdict: MAJOR EXPANSION NEEDED.** It inherits the unprinted “complete Lucas overlap” and does not address the missing intermediate four-marker lower package. The collision calculation itself is sound. Simpler: separate component classification from collision finiteness.
38. **P38 — `thm:r9`, `07-fixed...tex:568-586`.** Claim: persistent-only R9 for \(q\ge53\). Mechanism claimed: P29 budgets, P37 containment, modular witnesses, radius. **Verdict: BLOCKER / NOT PROVED AS PRINTED.** P29 does not provide the lower package required by P10; the logical arrow is missing. The char.-7 \(q\ge343\) argument is otherwise coherent. Repair by proving the missing package.
39. **P39 — `thm:hessian`, `08-ordered-hessian.tex:59-84`.** Claim: complete degeneracy locus and no rank-two complementary-ruling pullback. Mechanism claimed: \((1,1)+(1,1)\) factorization, projectivity normal forms, quadric rulings, overlap. **Verdict: BLOCKER / SUBSTANTIAL PROOF OMITTED.** Hidden cases include inseparability, vertical/horizontal factors, nonreduced curves, and all characteristic-two projectivity types. No simpler proof is evident; print the actual classification.
40. **P40 — `prop:hessian-pullback`, `08...tex:86-121`.** Claim: reduced pullback is exactly persistent/Lucas and complementary ruling is empty in rank two. Mechanism claimed: Plücker minors, rank--nullity, Lucas supports, UFD propagation. **Verdict: BLOCKER / SUBSTANTIAL ELIMINATION OMITTED.** Equality on geometric points would justify reduced schemes only after the point classification is proved. Simpler: provide the elimination as a table of ideals/support cases.
41. **P41 — `prop:hessian-effective`, `08...tex:123-162`.** Claim: effective split-base selection and deletion \(3n-4\). Mechanism: select one nonzero equation from each bad component, Vandermonde plus Schwartz--Zippel or disjoint 9-point grids, genus-one count. **Verdict: PASS CONDITIONAL ON P39--P40.** Quantifier order for \(A,B\) and the field of definition should be explicit. Both numerical bounds and degree sum check.
42. **P42 — `prop:lucas-kernel`, `09-lucas...tex:18-36`.** Claim: power-of-two nucleus/lift and endpoint intersection. Mechanism: Lucas zeros and adjacent Hankel coefficients. **Verdict: PASS.** Endpoint conventions are implicit. Simpler: include the two row-support sets.
43. **P43 — `prop:linearized`, `09...tex:38-72`.** Claim: full affine monodromy, minimal constant field, and \(s\mid m\) split criterion. Mechanism: Kummer scaling, generalized Artin--Schreier equation, root-difference ratios. **Verdict: PASS.** Boundaries \(B=0,C=0\) are handled. “Geometric monodromy” versus “minimal constant field” should be terminologically distinguished. Argument is already efficient.
44. **P44 — `prop:e7-orbit`, `09...tex:79-96`.** Claim: Borel stabilizer, \(\mathbb P^1\) orbit, and kernel. Mechanism: explicit transformed coefficient and Hankel equations. **Verdict: PASS.** Contragredient action is stated. Simple.
45. **P45 — `prop:e7-as`, `09...tex:98-150`.** Claim: framed quotient is geometrically integral Artin--Schreier cover with trace law. Mechanism: elementary symmetric equations and nonsquare leading pole coefficient. **Verdict: PASS.** Open collision conditions are fully interpreted. This is one of the best detailed proofs.
46. **P46 — `prop:e7-additive`, `09...tex:152-189`.** Claim: additive family has connected affine-frame cover with \(\operatorname{AGL}_3(\mathbb F_2)\). Mechanism: subspace-polynomial recursion and free frame torsor. **Verdict: PASS.** Generic separability uses \(A_1\ne0\). The invariant-function-field sentence could cite finite free quotient theory, but the mechanism is clear.
47. **P47 — `thm:e7`, `09...tex:199-229`.** Claim: entire \(e_7\) orbit shallow for \(m\ge3\) with exact witness count. Mechanism: subspace polynomials, Gaussian binomial, affine cosets, orbit transport. **Verdict: PASS.** Count \( {m\brack3}_2(q/8)=q(q-1)(q-2)(q-4)/1344\) checks. This is the simplest available proof.

### The three theorem-like declarations without their own proof environments

- **`cor:splitfree`, `03-dictionary.tex:43-47`: PASS.** Immediate from P01 and the explicit radius hypothesis.
- **`thm:r5`, `01-introduction.tex:71-98`: distributed proof P02--P08.** The counts reconcile, but the theorem is not release-passed until P06/P08 are expanded and the finite artifacts are shipped.
- **`thm:spine`, `01-introduction.tex:124-156`: distributed proof P17/P23/P28/P38.** R7 is carefully scoped; R6/R8 inherit major gaps and R9 inherits D1.

## Constants, quantifiers, characteristic restrictions, and dependency direction

- The point-count threshold formula in `thm:induction` is algebraically correct: its integer definition forces the strict inequality \(q+\kappa-2g\sqrt q>\delta\).
- Table thresholds \(23,29,37,43,53\) are the first prime powers above the respective real cutoffs.
- R7's finite-to-asymptotic bridge has no omitted prime power.
- The Hessian selection bounds simplify correctly with \(m=n-4\): \(8m+\binom m2=m(m+15)/2\), and the deletion degrees sum to \(3n-4\).
- The R9 rational base polynomial degree \(96+6=102\) and first characteristic-seven field \(343\) are correct.
- The \(e_7\) witness count and \(s\mid m\) constant-field criterion are correct.
- The explicit characteristic error is D4. The explicit missing characteristic hypothesis is D7.
- Covering radius is correctly separated from split-freeness at R7. At R8/R9 the dependency direction is plausible from Seroussi--Roth but should be stated, not called only “the imported theorem.”
- Certificate-to-theorem direction is mostly honest: finite certificates close only frozen finite domains. The missing R9 and Hessian geometry cannot be supplied by the declared certificates, and the schema itself confirms that.

## Open questions and highest-EV revisions

1. **Highest EV:** Is there already a complete pointed degree-seven/four-marker lower-package proof in a source report? If yes, transplant it as a named proposition before changing any R9 theorem text. If no, downgrade R9 immediately.
2. Can the ordered-Hessian component computation be expressed as a small saturated-ideal identity in Plücker coordinates? That would close both P39 and much of P40 more reliably than a long normal-form narrative.
3. For R6, are the characteristic-two/three overlap eliminations short enough to print as matrices? They appear to be; doing so would remove two major concerns cheaply.
4. For R8, can equations (25)--(32) be reorganized into a reusable “pointed cubic-cover package” proposition with five independently checkable sublemmas? This would improve both R8 and the missing R9 successor.
5. Should the headline remain one large paper? The cleanest release path is likely to keep it integrated but move the long component computations and public certificate schemas into rigorous appendices, leaving the current conceptual flow in the body.

### Simplest high-EV revision sequence

1. Reconcile the overview and theorem claims today: mark R9 conditional until its package exists.
2. Add the two missing characteristic qualifiers (D4, D7) and name the covering-radius specialization in R8/R9.
3. Expand R6 matrices; this is likely the cheapest headline-proof repair.
4. Formalize/print the R9 lower package.
5. Print the Hessian ideal decomposition and pullback elimination.
6. Run a second independent cold read, then build the paper-only immutable release and fill its manifest.

## Extra-juice / Tao closeout and mystery ledger

The closeout asked what a skeptical expert would try to falsify first: not the displayed point counts, which are mostly sound, but the transitions “budget \(\Rightarrow\) lower package,” “finite regression \(\Rightarrow\) geometric component exhaustion,” and “support overlap \(\Rightarrow\) complete carrier list.” That check exposed D1, D2, D5, and D6.

| Mystery | Status after closeout | Exact remaining evidence gap / owner |
|---|---|---|
| Why does R9 have budgets but no printed four-marker package? | **Unsettled; release blocker.** | Need a theorem at the pointed degree-seven level, not another finite census. |
| Is the Hessian degeneracy really only \(\Sigma\) plus two ruling conics after saturation? | **Plausible, not demonstrated here.** | Need saturated ideal/component computation over characteristic two and a hand-verifiable derivation. |
| Could an identically colliding/inseparable R8 stratum evade equations (25)--(29)? | **Not ruled out by the printed details.** | Need explicit Fitting/saturation and inseparability lemmas. |
| Do the finite classifications themselves internally sum correctly? | **Settled at the paper-local record level.** | All 44 R5--R7 field rows report true exhaustion identities; release still needs the actual replays. |
| Is the \(e_7\) order-three section evidence for deepness? | **Settled negatively.** | P47's direct subspace witnesses make the whole orbit shallow; no mystery remains there. |

## Release recommendation

Do not mint a DOI or label this SHA proof-complete. Preserve it as a valuable internal pre-release milestone. The paper is closer to a strong refereeable manuscript than the number of defects suggests: the highest-value repairs are concentrated in three transitions (R6 component details, the missing R9 lower package, and the Hessian component/pullback proof), while much of the arithmetic and conceptual infrastructure already survives a cold read.

**Vibe check:** mathematically promising and unusually well organized, but still one serious proof-expansion pass away from a defensible public priority claim.

Signed: 5.6-sol-xhigh
