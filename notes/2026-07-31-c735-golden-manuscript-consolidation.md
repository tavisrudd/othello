# C735 — Golden manuscript consolidation and proof architecture

**Date:** 2026-07-31

**Lane:** `golden`

**Status:** complete; operator-first central draft, ledgers, replay, and build gates passed

## Architecture verdict

The paper is operator-first.  Its headline theorem begins with a fully marked
coherent outer six-family of order-six conference operators and proves one
common mechanism:

1. middle exterior power reads triangle holonomy as the Joubert cubic;
2. the diagonal commutator gives the same cubic as a Pfaffian;
3. golden eigenspace compression gives the same cubic as a determinant and
   its adjugate matrix factorization;
4. the two generic kernel lines of the assembled differential give the
   special-conformal source direction and the Segre--Igusa conormal direction.

Balanced-cut rigidity and the `6 -> 10` Naimark--Gram construction are the
first conceptual consequence.  Recovery from the Clebsch support two-graph
comes next.  Spinor, Slater, Majorana, and anomaly results are instruments of
the operator theorem, not coequal sources.  Exceptional, Clifford, code,
bad-prime, and lattice relatives remain skippable branches.

This changes the C720 charter only in placement and proof hierarchy.  It does
not change the frozen marked source object or any theorem interface.

## Post-charter placement delta

Every completed post-charter result has exactly one disposition below.

| source | result family | disposition | manuscript home or sequel boundary |
|---|---|---|---|
| C715 | rational inverse of the Golden/Joubert map; stable fibres | main-text corollary | recovery/instruments section, after the operator theorem |
| C715 | Vandermonde identity and pair-collision divisor | main-text corollary | anomaly inverse proof |
| C715 | exact Slater normalization and one rational witness | compressed example | instruments section |
| C715 | height-three census and seven-chamber real optimum | appendix | verification/optimization appendix; not in the central proof |
| C715 | universal quartic critical equation | appendix | same optimization appendix |
| C716 | anomaly equations as line containment on the Segre cubic | main-text corollary | instruments section |
| C716 | fifteen fixed-collision plane components | main-text corollary | two-Abelian subsection |
| C716 | six one-moving-path degree-five del Pezzo components and minimal degree-one controls | main theorem | compact theorem in the instruments section |
| C716 | exact chiral/nonchiral witnesses and 21-family tables | appendix | evidence supplement |
| C717 | 860 chambers, coset graph, Specht spectrum, quadratic-order lattice, and parity-pump obstruction | sequel | no gap in the operator spine requires these results; C728 supplies the base-scheme theorem and C709 supplies the parity wall |
| C727 | support split is the conference two-graph | main theorem | recovery section |
| C727 | recovery--propagation and minimal marking | main theorem | recovery section, after propagation |
| C727 | determinant/dimer reverse faithfulness | main-text corollary | recovery theorem and proof |
| C727 | centered-square fibre classification | appendix | geometric appendix; only generic faithfulness and the ten-node base locus are needed centrally |
| C728 | synchronized Cartan-cell construction and multiplicity-one tangent map | main theorem | immediately after the headline operator theorem |
| C728 | exact Segre image ideal | main-text corollary | synchronized-spinor proposition |
| C728 | reduced fifteen-line base scheme and ten nodal images | appendix | statement retained centrally; reducedness proof and elimination details in verification appendix |
| C729 | simplex-to-conference theorem and reverse sign factorization | main theorem | balanced-cut subsection |
| C729 | order-ten cut split, 36-cut orbit, reflection mechanism, and local `10 -> 6` borders | sequel | useful continuation, but not needed to prove the headline mechanism |
| C729 | Paley order-14/order-18 censuses, designs, cross-ratio signatures, and higher moments | sequel | no main-paper placement |

C718 and C719 remain deferred.  Consolidation found no theorem-level gap that
requires either task.

## Revised contents and length budget

The target is 46 pages of main argument and 60 pages total.

| part | target pages | job |
|---|---:|---|
| Abstract and introduction | 4 | source object, principal theorem, three mechanisms, novelty/trust boundary |
| Marked operator and common propagation proof | 13 | covariance, exterior/Joubert/commutator, golden compression, polar adjugate |
| Balanced cuts and `6 -> 10` | 5 | frustration characterization, simplex, ETF, Naimark conference lift |
| Recovery and minimal marking | 7 | support two-graph, descent, reverse witnesses |
| Spinor and determinantal geometry | 5 | synchronized cells, image, resolutions and MCM pair |
| Fermionic and anomaly instruments | 8 | Slater/Majorana interface, inverse, one-moving-path theorem |
| Boundaries and conclusion | 4 | optional exceptional/Clifford/code/lattice map; precise nonclaims |
| Appendix A: centred-square fibres | 4 | exceptional fibres and degenerations |
| Appendix B: optimization and witnesses | 4 | height, Sturm, quartic critical equations, exact examples |
| Appendix C: verification and attribution | 6 | finite domains, commands, hashes, independent replay, citations |

The optional exceptional/Clifford/lattice material has a hard four-page main
budget.  Anything that cannot fit without interrupting the proof moves to a
sequel rather than expanding the main argument beyond 50 pages.

## Theorem--proof--trust ledger

This ledger covers every numbered result currently in
`papers/golden-operator/golden_operator.tex` after consolidation.

| label | exact hypotheses and statement scope | ownership | reader-facing proof | computation/formal dependency | remaining debt |
|---|---|---|---|---|---|
| `thm:propagation` | characteristic zero; fully marked coherent outer six-family; signed determinant-line choice only for a selected golden block; proves Joubert/Segre covariance, commutator Pfaffian, golden determinant/MCM pair, and normalized assembled polar adjugate | paper-owned synthesis; Joubert and Segre--Igusa identifications classical | complete proof immediately after theorem; HMSV citations mark classical quotient step | exact coefficient and cofactor normalization checks in C704/C705 bundles; no formal proof | display the exact cofactor witness in Appendix C before submission |
| `prop:synchronized-spinors` | same marked family; Cartan graphs of the six alternating commutators; equivariance, multiplicity-one linear map, exact projected Segre ideal, reduced base scheme, ten nodal images | paper-owned synchronization; Cartan big cell and six-point GIT classical | complete equivariant and dimension/prime-ideal proof in text | Singular is load-bearing only for radical/minimal-prime reducedness; C728 generator and independent replay | move the raw elimination transcript out of the eventual main PDF; add theorem/page-level HMSV citation |
| `thm:frustration` | arbitrary symmetric zero-diagonal order-six sign matrix; equivalence of all-cut `5:1`, maximal cross determinant, conference identity, and five-cycle gauge; six simplex words | paper-owned order-six characterization | complete switching and graph proof in text | sign tables checked by C720/C729 bundles but not logically required | none |
| `cor:naimark` | a `6 x 10` sign matrix with the proved row-simplex Gram identity; exhaustive balanced-column conclusion, ETF, order-ten conference operator, reverse sign-factor uniqueness | paper-owned consequence; ETF/Naimark terminology classical | complete cut-incidence and Gram proof in text | finite displayed matrix checked by C729 bundle; no classification dependency | cite a standard ETF/Naimark reference for terminology |
| `prop:support-two-graph` | Clebsch coordinate six-set with its unordered pair of ten-element `A5` triple orbits | transported C690/C691 input plus paper-owned short descent proof | complete incidence and switching proof in text | none | add exact source theorem citation when Paper I bibliography entry is installed |
| `thm:recovery-propagation` | monomial Clebsch code class; descent only modulo common reversal, switching, permutation, and golden conjugation | paper-owned cross-paper theorem | complete covariance, UFD, holonomy, and stabilizer proof in text | none; determinant coefficient identity has symbolic C720 proof | add Paper I theorem number and replace report-language provenance before release |
| `prop:polar-fibres` | algebraically closed characteristic-zero field; resolved Gauss map of the Segre cubic | classical Segre--Igusa duality plus paper-owned explicit fibre equations | complete reduction and degeneration proof in text | none | verify Kondo theorem/page pinpoint; move proposition to Appendix A |
| `thm:anomaly-inverse` | rational Segre point; stable-locus fibre statement; normalized filter for probability and a named rational example | quotient/inverse classical or prior art; marked normalization and cost paper-owned | complete rational chart, divisor, and normalization proof; finite height clause explicitly isolated | C715 exact height/Sturm checker and independent replay | move height clause to appendix theorem; add stable archival citation for 2025 anomaly paper |
| `thm:two-u1-lines` | rational two-charge line on Segre; all 21 Fano components under marked Golden inverse | Fano classification classical/imported; one-control marking and Pfaffian normalization paper-owned | complete multi-affinity, moduli, and coefficient proof in text | C716 exact family certificate and independent Pfaffian replay | verify theorem/page for the 21-component classification when final publication metadata exists |

No post-700 theorem is Lean-verified.  The C712 formal package covers only the
sub-700 source interface and is not cited as proof of any theorem above.

## Claim-level attribution and verification map

| claim cluster | attribution boundary | exact evidence/replay |
|---|---|---|
| exterior/Joubert/Segre and commutator normalization | Joubert quotient classical; common marked operator realization paper-owned | C704 report/bundle and independent replay listed in `papers/golden-operator/verification/README.md` |
| golden determinant, resolutions, MCM pair | standard determinantal geometry imported; cross-golden realization and descent paper-owned | C704/C705 exact scalar and rank witnesses |
| assembled polar adjugate | Segre--Igusa duality classical; two-kernel operator factorization paper-owned | C705 generator, compact certificate, independent replay |
| synchronized spinors | Cartan/Wick identities classical factorwise; golden synchronization and exact image paper-owned | `python3 notes/2026-07-31-c728-synchronized-pure-spinor-geometry.py --check`; independent replay command in verification README |
| balanced frustration and `6 -> 10` | maximum determinant elementary; equivalence, simplex, descent, and reverse factorization paper-owned | human proof; C729 cut-moment generator/replay checks frozen tables |
| recovery from support split | Paper I supplies unordered support split; Paper IV proves two-graph descent and propagation | C727 human proof; C720 symbolic sextic/dimer equivalence |
| anomaly inverse and physical cost | six-point quotient and rational anomaly parametrization classical/prior; Golden marking and Slater normalization paper-owned | C715 checker and independent replay |
| two-Abelian lines | 21-component Fano classification imported; one-moving-path realization and exact marking paper-owned | C716 checker and independent replay |

The synchronized verification surface is
`papers/golden-operator/verification/README.md`.  It now names C727--C729,
states which claims have complete human proofs, and separates central theorem
checks from sequel-only finite censuses.

## Gates

- **Placement:** passed.  Every post-charter result, including report-only
  C717, has one home or sequel verdict.
- **Proof:** passed.  The central spine has reader-facing proofs; exact finite
  normalization and reducedness steps are isolated in the trust ledger.
- **Hierarchy:** the abstract and introduction name the marked source, common
  theorem, three mechanisms, and application boundary.
- **Trust:** passed.  C704, C705, C715, C716, C728, and C729 primary checks and
  every available independent replay passed from the repository root.
- **Build:** passed.  `make check` in `papers/golden-operator/` is warning-free;
  the central draft is 13 pages.

## `ej` + `tt` closeout and mystery ledger

- **Settled by `ej`:** the paper invoked a fully marked presentation without
  defining its exact data.  A definition now precedes the principal theorem
  and separates rational shadows from the determinant-line choices needed to
  select one golden summand.
- **Settled by `ej`:** the verification surface named C704/C705 source bundles
  but omitted their replay commands.  The five central commands and their
  trust role are now explicit.
- **Settled by `tt`:** C717's 860-chamber and Specht-spectrum package is not a
  missing proof of the operator theorem.  C728 already supplies the reduced
  common base scheme and C709 supplies the parity-wall interface.  C717 is
  therefore sequel material, not an appendix allowed to grow by inertia.
- **Settled by `tt`:** the order-ten conference shadow belongs in the main
  argument only through the simplex/incidence theorem.  The 36-cut reflection,
  higher Paley censuses, and local border retractions remain sequel material.
- **Open editorial debt:** the final 55--65-page submission still needs the
  bounded exceptional/boundary section and controlled appendices described by
  the length budget.  This is manuscript completion, not uncertainty in the
  central mechanism; no new shadow theorem is needed to write it.
- **Open citation debt:** the exact theorem/page pinpoints for the Paper I
  support-split import, standard determinantal MCM language, and the final
  publication form of the two-Abelian Fano classification must be installed
  before release.  The ledger names each location and no priority claim rests
  on the missing pinpoints.
- **Open mathematical frontier:** C729's local `10 -> 6` borders do not yet
  recover the six Golden sisters canonically.  This is owned by C739's cubic
  lift/recovery tests, not by the present manuscript proof.

No genuine mystery remains in the fully marked propagation formulas or their
normalizations.  The remaining items are bounded editorial/citation work and
the allocated C739 inverse frontier.
