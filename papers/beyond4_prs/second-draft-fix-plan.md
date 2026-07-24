# Second-draft referee fix plan

Date: 2026-07-23

This plan responds to the full-paper review of the fifteen-page C538 draft.  The
review's central diagnosis is accepted: the draft is a research announcement
with a strong theorem spine, not yet a proof-complete submission.  No release
may be described as proof-complete until every proof-critical gate below is
closed.

## Status vocabulary

- **Closed in source** means the manuscript itself contains the correction.
- **Scaffolded** means the statement, definitions, and proof obligations have
  been separated, but a full proof is still required.
- **Open** means new mathematical exposition or an immutable external archive
  is required.

## Correctness gates

| Gate | Required change | Destination | Acceptance test | Status |
|---|---|---|---|---|
| N1 | Use `q >= 43` consistently for redundancy eight. | Abstract, Theorems 1.2 and 6.1 | No `q>43` occurrence; all three statements say `q\ge 43`. | Closed in source |
| N2 | Replace the mixed point-count conventions by `q+kappa-2g sqrt(q)>delta`. | Polar-induction section | A single definition of `H_kappa`; the retained applications are evaluations of the uniform \(Q_r\) formula. | Closed in source |
| N3 | Recompute the displayed redundancy-eight and nine thresholds from that convention. | Sections 6.1--6.2 | The table gives `(g,delta,kappa)=(1,30,1)` and `(1,36,1)` and first prime powers 43 and 53. | Closed in source |
| N4 | Preserve the singular cubic-cover correction separately. | Section 3 | The cubic argument quotes the exact `q+1-2 sqrt(q)` Aubry--Perret bound, deletes the possible rational singular point, and records `(g,delta,kappa)=(1,13,1)`. | Closed in source |
| N5 | Remove the duplicated `and and`. | Section 6.2 | Literal search is empty. | Closed in source |

## Proof-architecture gates

| Gate | Required change | Acceptance test | Status |
|---|---|---|---|
| P1 | Define the syndrome scheme, contraction strata, ordered marker spaces, lower splitting incidence, bad schemes, collision divisors, and all numerical indices before the induction theorem. | Every symbol and quantified object in the theorem is introduced in the definitions subsection. | Closed by symbol audit |
| P2 | State and prove an intrinsic polar-flag construction theorem, including base change, equivariance, infinity, and marker propagation. | The construction is independent of the contained/transverse dichotomy. | Closed and cold-read |
| P3 | Replace the hidden contained-case hypothesis by proved contained-component theorems. | No general theorem concludes `P_n union M_n` merely from an assumed implication; every proved degree points to a named component result. | Closed through `CC(8,1)`: ordinary rank two, modular overlaps, and collision finiteness are printed |
| P4 | State the effective transverse theorem conditionally and visibly. | Its conclusion uses only named lower-cover, point-bound, and deletion hypotheses. | Closed in source |
| P5 | Expand every asserted intersection degree, containment, ramification degree, genus, and deletion budget into a lemma or proposition. | Assertion audit maps each numerical claim to a proof or immutable certificate. | Closed through R9 by the assertion-map cold read |
| P6 | Replace the ordered-Hessian proof outline by a complete proof. | The ambient scheme, factorization types, ruling conics, pullbacks, selection polynomial, and `3n-4` budget are all proved. | Closed with the honest degree-eight global-union polynomial and correspondingly revised threshold |
| P7 | Split the degree-nine `e_7` theorem into Artin--Schreier normalization, additive subcover, and shallow-orbit propositions and prove each. | No theorem-strength assertion is supported only by a synopsis paragraph. | Closed in source and cold-read |

## Classification and finite-range gates

| Gate | Required change | Acceptance test | Status |
|---|---|---|---|
| C1 | Give public canonical representatives, stabilizers, invariants, Frobenius fusion, and completeness records for R5--R7. | Repeated orbit sizes are distinguishable without internal task reports. | Closed by generated, hash-pinned public JSON and Markdown records |
| C2 | Add a field-range ledger for every prime power below each geometric threshold. | Every field is assigned to geometry, direct certificate, radius exclusion, or an explicitly open gate. | Closed against the frozen certificate domains and radius premises |
| C3 | Keep split-free syndrome and code deep-hole classifications distinct at redundancy seven. | Every summary retains the `q>=11` covering-radius gate. | Closed in source |
| C4 | Separate the characteristic-seven carrier calibration from whole-code redundancy-nine classification. | The carrier result is a separate proposition with an explicit non-classification warning. | Closed in source; exposition strengthened in this revision |

## Reproducibility gates

| Gate | Required change | Acceptance test | Status |
|---|---|---|---|
| R1 | Replace paper-facing C-numbers by stable labels `Certificate R5`, ..., `Certificate e7`. | The manuscript table uses only public labels. | Closed in source |
| R2 | Document the certificate schema and what each replay independently rederives. | `supplement/CERTIFICATE-SCHEMA.md` is complete enough for an external implementer. | Closed with normalization, flags, exhaustion, trust classes, and extraction check |
| R3 | Give exact commands, working directories, searched domains, stop conditions, and toolchain requirements. | `supplement/REPRODUCING.md` contains literal commands and boundaries. | Closed; `supplement/verify.py` is the single entry point |
| R4 | Create an immutable release manifest with hashes and byte counts without rewriting predecessor manifests. | Manifest names the release commit, archive identifier, and every public artifact. | Scaffolded; final hashes/DOI open until release |
| R5 | Supply a repository URL, immutable tag/commit, and DOI or permanent archive URL. | All three resolve externally. | Open; must close before C545 |
| R6 | Add tracked `flake.nix` and `flake.lock` to the fresh paper export, pinning `finitegeom`, every required external certificate package, the Lean toolchain, and system dependencies. | A clean checkout resolves and replays through the locked flake without machine-local paths. | Open; must close before C545 |

## Exposition and literature gates

| Gate | Required change | Acceptance test | Status |
|---|---|---|---|
| E1 | Reduce the abstract to the dictionary, mechanism, classifications, and one characteristic-two sentence. | Roughly 180--220 words; no orbit-size inventory or quotient formula. | Closed in source |
| E2 | Add notation and terminology tables before first technical use. | `r,n,d,s`, carrier terminology, and cover terminology are stable. | Closed by source and rendered cold read |
| E3 | Add a contraction/deletion/lifting roadmap diagram. | Both contained and transverse branches are visible. | Closed by rendered page-5 cold read |
| E4 | Replace the dated search-process paragraph by mathematical comparison. | No search date, citation-graph narrative, or database disclaimer remains in the paper. | Closed by paragraph and exact-source cold read |
| E5 | Expand the bibliography by role and complete metadata after a source audit. | Every novelty comparison has an appropriate citation and verified metadata. | Closed by the role-based audit and DOI metadata reconciliation |
| E6 | Use upright long-theorem text and replace “paper spine.” | Long theorem inventories are roman; literal phrase is absent. | Closed in source |
| E7 | Replace the floating filename table by a compact breakable public verification table. | The verification table begins without leaving a nearly empty preceding page. | Closed by rendered page-31 cold read |
| E8 | Split the growing source into a thin driver, one file per major section, and separate appendices. | Section reviews and trust-ledger anchors do not depend on one monolithic file. | Closed; exact expanded-source equivalence and `make check` pass |

## Required proof expansion by section

### Redundancy five

The full draft must derive the gcd strata and cyclic/wild normal forms, prove
invariance, exhaustion, orbit transitivity, stabilizers, degenerations, and
overlaps, and construct the cubic fiber-square curve scheme-theoretically.
Geometric integrality, genus, deletion bounds, infinity, and the implication
from a retained rational point to three distinct roots require separate
lemmas.

### Redundancies six and seven

Each intersection, ramification, deletion, and containment number becomes a
named proposition.  The manuscript must explain every prime power below the
geometric threshold and expose sufficient public orbit data to distinguish
equal-size orbits.

### Redundancies eight and nine

Each stage of the polar tower must identify its lower stratum, marked roots,
bad schemes, contained components, and deletion contribution.  Modular lifts
are recorded in characteristic-by-characteristic tables.  The
characteristic-seven carrier calculation remains separate from the
whole-syndrome theorem.

### Ordered Hessian

The final proof must define the ambient Grassmannian incidence and exhaust all
factorization types; prove the Veronese and Fano-ruling degeneracy loci; rule
out the complementary ruling; identify the scheme-theoretic contained
pullback; derive the base-selection polynomial and both field bounds; and name
the five divisors contributing `3n-4`.

### Degree-nine `e_7`

The final proof is divided into ordered-root Artin--Schreier normalization,
the additive `AGL_3(F_2)` subcover, and the direct subspace-polynomial
shallowness argument.  The witness count must include the translation factor
and a no-overcount proof.

## Proof blockers exposed during expansion

The source-report extraction found three gaps that must not be hidden behind
the original theorem synopsis:

1. **Later contained flags and the pointed R8 package.**  The rank--nullity argument proves
   scheme-theoretically, in every characteristic, that a first-polar line
   contained in the lower rank-two carrier comes from the upper rank-two
   carrier.  This closes `CC(6,1)` and the ordinary persistent part in later
   degrees.  The central, collision, and modular calculations now also close
   `CC(7,1)`.  The two-old-marker recursion now prints the rank/gcd,
   cyclic/wild/inseparable, branch, and marker-collision equations, proves
   the geometric-`S3` identity twist and deletion degree `30`, and closes
   `LP(6,1)`.  R8 is unconditional for `q>=43`.
2. **R9 slices and base selection.**  The six reduced discriminants, their
   Bézout identity, the multiple-root branch polynomials, and the nonzero
   rational-base polynomial with its degree accounting are now printed in
   the public supplement and proved in the manuscript.  The independent
   replay checks the polynomial identity.  Together with `CC(8,1)`, this
   makes R9 unconditional for `q>=53`.
3. **Ordered-Hessian union bound.**  Individual degeneracy generators of
   root-degree at most four do not by themselves produce one degree-four
   polynomial vanishing on the whole bad union.  Either exhibit such a
   polynomial, prove a componentwise hitting lemma, or weaken the threshold.
   The manuscript now takes the last route: one nonzero Veronese equation
   times one nonzero complementary-ruling equation gives a single
   degree-eight polynomial, and the threshold is revised to
   `min((n-4)(n+11)/2+1, 9(n-4))`.  Vertical factors are removed
   scheme-theoretically before this test.

All three exposed mathematical blockers are now closed in source.  The
weaker Hessian constant is a mathematical correction, not merely an
expositional change.

## Third-draft referee polish

The 39-page cold review judged the mathematical architecture
substantially repaired and identified a final submission-polish pass.
That pass is now closed locally:

- every displayed equation uses automatic numbering and labels;
- Theorem 1.3(b) states the all-field redundancy-seven classification
  without suggesting that the exceptional small-field list persists;
- the six R9 sections, every $\Delta_i$, and every B\'ezout coefficient
  are printed in Appendix A;
- Propositions 4.3, 5.7, 7.3, and 9.2 and Theorem 8.1 contain the
  requested counting, boundary, exhaustiveness, normal-form, and
  monodromy details;
- the R8 proof has a final stratum/equation/degree/contained/transverse
  table;
- the draft-status paragraph is removed, the disclosure is framed as
  assistance plus authorial responsibility, and data/code availability
  is stated conventionally;
- verbatim Lean source is in the electronic supplement while the
  statement-adequacy appendix retains the exact paper-to-formal
  boundary;
- `supplement/verify.py` is the single verification entry point.

The rendered paper is 41 pages.  Two additional diagrams explain the
R9 open-cover surjectivity and the Kummer/additive monodromy tower.
No new mathematical scope is claimed: arbitrary redundancy remains
level-specific, R8/R9 remain high-field results, and the unclassified
Lucas strata remain open.

## Scope reset and cold-session queue

Date: 2026-07-24

An independent full-manuscript cold read found the redundancy-five core
and the coherent-marker mechanism strong, but judged the combined
R5--R9/Hessian/Lucas paper too broad for submission.  The submission
manuscript now stops at R7.  An independent R8 exhaustion cold read
found that the fixed-level component theorem still needs new
scheme-theoretic work, so R8 and R9 form the fixed-level companion
queue.  The ordered Hessian, general Lucas carriers, and distinguished
\(e_7\) orbit are reserved for separate companion work.  None is a
dependency of the submission theorems.

Run the following cold sessions independently.  A reader assigned one
session should not read the earlier review or another session's report
before delivering a verdict.

| Session | Cold-read target | Acceptance gate | Status |
|---|---|---|---|
| F1 | Main-theorem hierarchy and synthesis | Each headline theorem has one primary equivalence relation and an explicit proof assembling exhaustion, counts, radius promotion, and Frobenius fusion. | Queued |
| F2 | R6/R7 exceptional classifications | The printed paper identifies every exceptional class by representative, stabilizer, and fusion, or consistently calls the output a certified census. | Closed: R7 prints one representative per size block and the complete Markdown-record locator; the reader reproduced sample \(E_f\) and \(\tau_5\) entries |
| F3 | Effective polar induction | A reader can reconstruct the full marker iteration, indeterminacy budget, and hypotheses without importing the fixed-level examples. | Closed: the uniform theorem states the full \(\mathrm{CC}(j-1,1)\) chain, \(\delta_r=6r-17\), and \(d_r\leq3r-5\); R6/R7 discharge the required contained assertions |
| F4 | R8 component exhaustion | Decide whether the printed component argument is independently complete. | Closed: cut R8 to companion |
| F5 | Computational/formal trust boundary | A frozen archive, exact domains, acceptance criteria, resource envelope, and honest formal coverage are sufficient to audit every retained headline claim. | Queued |
| F6 | Exposition-only pass | The R5 example appears before the abstract machinery; duplicated roadmaps and audit prose are removed; the marked-factor mechanism remains the narrative spine. | Queued |
| C1 | R8 homogeneous strata | Produce the complete kernel-chart atlas, eliminated and saturated ideals, infinity charts, and characteristic \(2,3,5\) component decompositions; prove that the displayed rank, gcd, cyclic, wild, inseparable, and branch strata exhaust the bad locus. | Companion queue |
| C2 | R8 collisions and deletion degrees | Write the marker-collision and moving-gcd incidences, prove containment in the asserted ramification divisors, justify degrees \(6,8,10,30\) with multiplicities, and display the five exact-gcd-one fallback equations. | Companion queue |
| C3 | R8 modular and final synthesis | Print the complete Lucas row calculation, prove the characteristic-three orbit claim and every shallow witness, then give one exhaustive contained/transverse/marker/radius synthesis proof. | Companion queue |
| C4 | R9 carrier consistency and exhaustion | Resolve the characteristic-five line/point contradiction and prove the complete contained-component decomposition before restoring any R9 classification claim. | Companion queue |
| C5 | R9 binary-quartic slices | Prove the characteristic-seven normal-form atlas, quotient coverage, stabilizers, boundary, and descent of the six principal opens. | Companion queue |
| C6 | Ordered-Hessian/Lucas/\(e_7\) paper | Establish an independent theorem hierarchy and state exactly which carrier strata remain unclassified; no dependence on the R5--R7 submission narrative. | Companion queue |

## Release rule

C545 is blocked as a **proof-complete Version 1** until the retained
R5--R7 manuscript passes sessions F1--F3 and F5--F6, an independent final reader,
the clean public export/replay, immutable repository and archive
identifiers, and author/account confirmation.  An earlier DOI release
is not authorized.

The development monorepo is never the publication repository.  Release uses a
reviewed paper-only fresh-history export containing the manuscript, public
supplement, minimal verifiers/certificates, adequacy/provenance sources, and a
tracked `flake.nix` and `flake.lock` resolving exact `finitegeom` and required
external certificate-package commits, target lists, the Lean toolchain, and
system dependencies without machine-local paths.
