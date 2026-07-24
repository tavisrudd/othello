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
| N2 | Replace the mixed point-count conventions by `q+kappa-2g sqrt(q)>delta`. | Section 4 and threshold table | A single definition of `H_kappa`; every application records `kappa`. | In this revision |
| N3 | Recompute the displayed redundancy-eight and nine thresholds from that convention. | Sections 6.1--6.2 | The table gives `(g,delta,kappa)=(1,30,1)` and `(1,36,1)` and first prime powers 43 and 53. | In this revision |
| N4 | Preserve the singular cubic-cover correction separately. | Section 3 | The cubic argument explicitly uses `kappa=0`, or absorbs the normalization defect into `delta`. | In this revision |
| N5 | Remove the duplicated `and and`. | Section 6.2 | Literal search is empty. | In this revision |

## Proof-architecture gates

| Gate | Required change | Acceptance test | Status |
|---|---|---|---|
| P1 | Define the syndrome scheme, contraction strata, ordered marker spaces, lower splitting incidence, bad schemes, collision divisors, and all numerical indices before the induction theorem. | Every symbol and quantified object in the theorem is introduced in the definitions subsection. | In this revision |
| P2 | State and prove an intrinsic polar-flag construction theorem, including base change, equivariance, infinity, and marker propagation. | The construction is independent of the contained/transverse dichotomy. | Scaffolded in this revision |
| P3 | Replace the hidden contained-case hypothesis by proved contained-component theorems. | No general theorem concludes `P_n union M_n` merely from an assumed implication; every proved degree points to a named component result. | Closed through `CC(8,1)`: ordinary rank two, modular overlaps, and collision finiteness are printed |
| P4 | State the effective transverse theorem conditionally and visibly. | Its conclusion uses only named lower-cover, point-bound, and deletion hypotheses. | In this revision |
| P5 | Expand every asserted intersection degree, containment, ramification degree, genus, and deletion budget into a lemma or proposition. | Assertion audit maps each numerical claim to a proof or immutable certificate. | Open |
| P6 | Replace the ordered-Hessian proof outline by a complete proof. | The ambient scheme, factorization types, ruling conics, pullbacks, selection polynomial, and `3n-4` budget are all proved. | Closed with the honest degree-eight global-union polynomial and correspondingly revised threshold |
| P7 | Split the degree-nine `e_7` theorem into Artin--Schreier normalization, additive subcover, and shallow-orbit propositions and prove each. | No theorem-strength assertion is supported only by a synopsis paragraph. | Closed in source and cold-read |

## Classification and finite-range gates

| Gate | Required change | Acceptance test | Status |
|---|---|---|---|
| C1 | Give public canonical representatives, stabilizers, invariants, Frobenius fusion, and completeness records for R5--R7. | Repeated orbit sizes are distinguishable without internal task reports. | Schema added in this revision; records open |
| C2 | Add a field-range ledger for every prime power below each geometric threshold. | Every field is assigned to geometry, direct certificate, radius exclusion, or an explicitly open gate. | In this revision |
| C3 | Keep split-free syndrome and code deep-hole classifications distinct at redundancy seven. | Every summary retains the `q>=11` covering-radius gate. | Closed in source |
| C4 | Separate the characteristic-seven carrier calibration from whole-code redundancy-nine classification. | The carrier result is a separate proposition with an explicit non-classification warning. | Closed in source; exposition strengthened in this revision |

## Reproducibility gates

| Gate | Required change | Acceptance test | Status |
|---|---|---|---|
| R1 | Replace paper-facing C-numbers by stable labels `Certificate R5`, ..., `Certificate e7`. | The manuscript table uses only public labels. | In this revision |
| R2 | Document the certificate schema and what each replay independently rederives. | `supplement/CERTIFICATE-SCHEMA.md` is complete enough for an external implementer. | In this revision |
| R3 | Give exact commands, working directories, searched domains, stop conditions, and toolchain requirements. | `supplement/REPRODUCING.md` contains literal commands and boundaries. | In this revision |
| R4 | Create an immutable release manifest with hashes and byte counts without rewriting predecessor manifests. | Manifest names the release commit, archive identifier, and every public artifact. | Scaffolded; final hashes/DOI open until release |
| R5 | Supply a repository URL, immutable tag/commit, and DOI or permanent archive URL. | All three resolve externally. | Open; must close before C545 |

## Exposition and literature gates

| Gate | Required change | Acceptance test | Status |
|---|---|---|---|
| E1 | Reduce the abstract to the dictionary, mechanism, classifications, and one characteristic-two sentence. | Roughly 180--220 words; no orbit-size inventory or quotient formula. | In this revision |
| E2 | Add notation and terminology tables before first technical use. | `r,n,d,s`, carrier terminology, and cover terminology are stable. | In this revision |
| E3 | Add a contraction/deletion/lifting roadmap diagram. | Both contained and transverse branches are visible. | In this revision |
| E4 | Replace the dated search-process paragraph by mathematical comparison. | No search date, citation-graph narrative, or database disclaimer remains in the paper. | In this revision |
| E5 | Expand the bibliography by role and complete metadata after a source audit. | Every novelty comparison has an appropriate citation and verified metadata. | Open; no unverified citations will be invented |
| E6 | Use upright long-theorem text and replace “paper spine.” | Long theorem inventories are roman; literal phrase is absent. | In this revision |
| E7 | Replace the floating filename table by a compact breakable public verification table. | The verification table begins without leaving a nearly empty preceding page. | In this revision |
| E8 | Split the growing source into a thin driver, one file per major section, and separate appendices. | Section reviews and trust-ledger anchors do not depend on one monolithic file. | In progress |

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

## Release rule

C545 is blocked as a **proof-complete Version 1** until P5--P7, C1--C2,
R4--R5, and E5 are closed and an independent cold read confirms the assertion
audit.  An earlier DOI release is permissible only if it is labelled
unambiguously as a research announcement and does not claim proof
completeness.

The development monorepo is never the publication repository.  Release uses a
reviewed paper-only fresh-history export containing the manuscript, public
supplement, minimal verifiers/certificates, adequacy/provenance sources, and a
pin to one shared-public-Lean commit and target list.
