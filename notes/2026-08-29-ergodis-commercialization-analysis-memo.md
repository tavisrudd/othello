# Ergodis commercialization analysis memo

**Lane**: `complete-ports`

**Date**: 2026-08-29
**Status**: updated after exact closure of R2Elite01; private analysis record;
no product, publication, filing, push, or novelty claim authorized. Numbers
quoted from task reports are those reports' numbers. Market figures are
unvalidated planning assumptions, not forecasts.

Companion records: `2026-08-29-c998-ergodis-partition-design.md`,
`2026-08-29-c998-patent-landscape.md`,
`2026-08-29-ergodis-certificate-prior-art-veripb.md`,
`2026-08-28-ergodis-ldpc-quantum-angle.md`, and the C985 result notes dated
2026-08-29 (BB784, QDistSAT BB360, BB756, R2Elite01, R2Elite02, native and wide
CSS backend plans, Gurobi boundary memo).  The execution order for importing
theorems and methods from the wider portfolio is
`2026-08-29-c985-ergodis-portfolio-theorem-import-workplan.md`.

## 1. Licensing and release decisions taken in discussion

1. Public licence stays AGPL-3.0; commercial licence on the same code, no
   separate enterprise fork; contributor licence agreement before any outside
   merge; word-mark registration before announcement; no BSL/SSPL.
2. Release sequencing is fixed by disclosure: provisional-patent decision, then
   paper, then a fresh-history kernel-only push to the standalone repository,
   then crates.io (name verified free on 2026-08-29), then trademark, then
   CLA. Nothing has been publicly disclosed; both the monorepo and the
   standalone repository are private.
3. Five-tier partition (C998): public `ergodis` kernel and certificate formats;
   private `ergodis-symmetry`; private `ergodis-qec`; private `ergodis-storage`;
   private `ergodis-bench`. The partition note found zero public-to-private
   module edges and confirmed the observational compiler is dependency-free,
   so the MATA/Boa speed claim ships in the public tier.

## 2. Prior-art and patent verdicts already recorded

1. Certified compiler alone: do not file. Smetsers--Moerman--Jansen (LATA 2016)
   and Kupferman--Lavee--Sickert (ATVA 2021) anticipate per-pair separating
   certificates; VeriPB dominance covers the orbit cover; certified presolve
   with witness lifting ships in PAPILO.
2. Per-vertical landscape (C998): quantum patent-empty and the one place to
   file a narrow provisional; storage medium risk (US 10,187,088 helper-set
   selection) and the only vertical warranting paid freedom-to-operate work;
   automata and solver verticals low; the dominant risk is subject-matter
   eligibility, not prior art; Google Patents was unreachable during the
   survey, so CN/KR and legal-status coverage is recorded as a gap.

Section 6 below supersedes the quantum recommendation's *scope*; it does not
change the storage, automata, or solver verdicts.

## 3. Reflection: theorems from the arcs and Clebsch series as ergodis inputs

Sources read: abstracts of *Arcs complete outside a conic*, *Integral secant
distributions*, *Clebsch factorization*, *Clebsch passages*, the Clebsch
rigidity computational companion, and *Golden operator*; and the portfolio
snapshot entries for the Clebsch reconstruction, conic matching quotients,
golden descent, passant-code reconstruction, both arcs papers, and four-frame
semilinear rigidity.

### 3.1 One object underlies the set

Every result is a statement about coset leaders and deep holes of an MDS or
incidence code: the uncovered locus is the deep-hole syndrome set of the arc's
`[k,3,k-2]` code; relative completeness is syndrome confinement; the defect
identity is a weight-two leader-collision identity; the passant minimum words
are the first layer of the same weight structure; the Reed--Solomon lane is
deep holes by name. Ergodis computes prescribed-coset support costs
(`confinement.rs`) but has no first-class certified query for covering radius
and the deep-hole locus. Adding one would make ergodis the shared engine of the
arcs, Clebsch, and Reed--Solomon lanes, which currently maintain separate
scripts for the same computation, and would unify their certificate formats and
trust ledgers.

### 3.2 The certificates were Delsarte--Schrijver by hand

The passant paper's positive-semidefinite and line-moment certificates, the
arcs papers' moment identities whose real relaxation is the expander-mixing
inequality, and the integral-secant envelopes are instances of one machine:
moment identities on weight distributions, with Delsarte's linear-programming
bound as the relaxation and Schrijver's semidefinite refinement above it. The
systematic version for a specific code with automorphism group `G` is:
block-diagonalize the action of `G` (symmetry-adapted bases), solve the
orbit-reduced semidefinite programme, round to an exact rational dual
certificate, and emit "no word of weight below `d`" as a checkable object. The
same symmetry-adapted basis predicts contextual-quotient dimension for
field-valued observations (rank of a `G`-equivariant map per isotypic
component) and detects hidden scalar actions in the commutant. One primitive,
three uses; it belongs in the private symmetry tier.

### 3.3 Mechanisms, certificate kinds, and fixtures

Mechanisms: hidden operator field as semantic symmetry (passant code:
commutant of the `PGL(2,13)` action is `F_8`, which forces every minimum-word
orbit to span); trades as non-separability witnesses dual to separator
certificates; small observation sets as complete invariants (uncovered locus;
weighted pair concurrences of minimum words) as a reconstruction gate for
choosing observation profiles; the sharp evaluation dichotomy converting
separator existence into a feature-map rank test; representation-theoretic
state counting (conic-quotient ranks 3, 6, 10 by `SL_2`-module irreducibility);
symmetry-transfer soundness (four-frame automorphism group equals the geometric
stabilizer), which is the domain-adapter invariance obligation discharged by a
theorem, with the continuation complex as a future-test state space.

Certificate kinds: compatibility-graph clique bounds and exact PSD/moment
certificates excluding low weights without enumeration; the prescribed-hole
defect identity as a decomposable dual bound with nonnegative per-point slack
(sensitivity analysis and deletion stability for free); integral envelopes and
the modular-lift dichotomy as theorem-derived valid inequalities for incidence
integer programmes; tight-bound-forces-normal-form as an optimality check.

Fixtures: the passant code (`PGL(2,13)`, exact `d = 12`, four minimum-word
orbits, hand-built PSD certificates), the Clebsch hexagon (`A_5` recovered,
rigidity gap 0 to 18), exact `rho_C(q)` values with kernel-checked witnesses,
and the order-ten conference matrix.

### 3.4 Quantitative points a strong outside reader would raise

1. The C997 Gurobi experiment's 13.1x is under a fifth of the ideal orbit
   reduction for a group of order 72; the queued orbital-branching gate should
   report that ratio, not only the multiplier. (Moot for the native backend;
   see section 4.)
2. Rigidity gaps are a product feature: certify `d`, the number of weight-`d`
   words, and emptiness of `(d, d+g)`, not `d` alone. Minimum-weight
   multiplicity drives logical error rate and information-set-decoding cost.
3. Whether the integral-secant arithmetic correction is a rank-one
   Chvatal--Gomory cut of the moment inequality, or a new cut family, is one
   afternoon's check and decides whether it can be emitted automatically.
4. Field support is a prerequisite defect: golden normal forms over
   `F_q(phi)`, the `F_8` operator field, and exact rational SDP rounding are
   outside the current field module.
5. Open: a general criterion for when a permutation-invariant code carries a
   larger scalar field in its commutant, and whether the bivariate-bicycle ring
   structure gives one that orbit search currently discards.

Verdict on the set: two items change what ergodis is, the covering-radius and
deep-hole query and the symmetry-reduced dual certificate; the rest are
patterns and fixtures. They justify one task with the passant code as the
acceptance instance and the gross code as the second gate.

## 4. Native backend results that supersede the earlier framing

The 2026-08-28 quantum-angle note advised against selling faster search and
proposed a symmetry front end for Gurobi and MaxSAT. The C985 notes dated
2026-08-29 record a native exact connected-support backend that changes the
product:

| instance | source | result | search |
|--------------------------------------|---------------------------|-----------------------------------------|-------------------------------|
| bivariate bicycle `[[784,24,24]]` | Bravyi et al. | exact `d = 24`, witness plus exclusion | 127 s, 16 threads, 23 MiB RSS |
| QDistSAT `BB_360_12_?` | official benchmark input | exact `[[360,12,24]]`, both directions | about 470 s combined |
| bivariate bicycle `[[756,16,<=34]]` | Bravyi et al. | `d >= 24` certified; exact value open | 27.51 s clean mean; Gurobi licence refused |
| lifted product `R2Elite02` | Liu--Marquardt | exact `[[1496,198,16]]` | 116.97B candidates, 647.943 s |
| lifted product `R2Elite01` | Liu--Marquardt | exact `[[1496,194,20]]` | 712.48B exclusion candidates, 4,247.838 s combined; deterministic weight-20 witness at RIS trial 765 |
| C997 control, one core | gross code | 0.12 s compile + 0.15 s search | Gurobi one-thread 3.8 s |

The 2026-08-30 compiler/search continuation materially strengthens the native
product.  Clean same-host A/B gives 3.361x faster BB756 compilation, 476x
faster R2Elite01 compilation, 1.460x faster BB756 radius-22 search, and 1.389x
faster R2Elite02 Z exact search.  R2Elite01 compiler RSS falls 1.64x; BB756
search remains about 24 MiB.  The detailed statistical and counter record is
`2026-08-30-c985-completion-compression-and-wide-search.md`.

The non-coding application frontier is no longer generic speculation.  The
ranked C985 scan identifies exact real-rooted polynomial enumeration for the
open `R^18` equiangular-line problem and C80's odd-plane cap game as flagship
adapters, with a double-coset continuation hierarchy as their common small
theory fixture.  See `2026-08-30-c985-ergodis-cross-domain-gem-scan.md`; the
large C1000 enumeration remains separately gated and unapproved.

The Gurobi boundary memo fixes the product boundary: domain object, then
ergodis to a smaller certified model, then any backend (Gurobi, SCIP, Kissat,
or the native search), then ergodis to a lifted exact witness. Persistence of
compiled filters passed its gate; parallel orbit anchors and a diversified
qLDPC suite are next. The QDistSAT 27-instance suite, including the open
`LP_1768_224`, has not been swept.

Consequences for the analysis above:

1. R2Elite01 closes at `[[1496,194,20]]`: the two exact misses cover
   712,476,065,846 candidates in 4,247.838 s (about 70.8 minutes), while a
   deterministic native RIS run supplies the independently checked weight-20
   logical. Its exact rate-distance figure of merit is `9700/187 =
   51.871657754...`, 2.70165 times BB360's 19.2 and 1.531 times R2Elite02's.
   Within the recorded comparison, exact distance at this scale where the
   source result used randomized bounds is the strongest demonstrated product
   fact.
2. The Delsarte--Schrijver dual certificate remains valuable but moves to the
   instances beyond exhaustive reach (the BB756 gap, `LP_1768_224`, and
   customer roadmap codes) and to compact replacement of hundred-billion-
   candidate replay records.
3. The deep-hole unification and passant fixtures stand; they are consumers
   of a proven engine rather than reasons to build one.
4. The native implementation facts include connected-support enumeration,
   exact syndrome tracking, one-sided projected-completion filters, witness
   transport by checked isomorphism, persisted source-bound filters, and a
   verified central involution reducing 1,496 anchors to 748. The blockwise
   deck calculation found identity and central actions in each tested family;
   it is not a full automorphism-group classification. These facts explain a
   measurable technical effect but do not establish patent novelty; section 6
   records the adverse prior-art conclusion.

### 4.1 Evidence products and trust levels

The commercial language must distinguish three different deliverables:

1. **Replayable upper witness.** A low-weight logical and its transport data
   are small and independently checkable without trusting the search.
2. **Exact exhaustive-computation bundle.** The current lower bound consists
   of canonical input reconstruction, source-bound artifact hashes, enumerator
   and filter versions, deterministic parameters, counters, timings, and an
   auditable implementation. It supports reproduction and attestation, but its
   compact record does not independently replay 712.48 billion misses.
3. **Succinct lower-bound certificate.** A future LP, SDP, dual, or other proof
   object would let a small checker verify the exclusion much more cheaply
   than rerunning the search.

Until level 3 exists, describe the result as an **exact audited computation
with a reproducibility bundle**, not as a succinct independently checkable
lower-bound proof certificate. The immediate product wedge is an independent
qLDPC parameter audit: reconstruct the customer's code, bind every artifact to
that source, produce exact exclusions where feasible, return a replayable
logical witness, and issue a precise audit report. The broader compositional
compiler remains an expansion option; the quantum result alone does not yet
validate demand for that general product.

## 5. Revised market sizing (unvalidated planning assumptions)

Serviceable market for certified qLDPC and stabilizer-code distance:

| segment | approximate count | willingness | plausible annual spend |
|------------------------------------------------------------------|-------------------|---------------------------------------------------------------|------------------------|
| hardware roadmap owners betting on qLDPC (IBM, Google, Infleqtion, Quantinuum, PsiQuantum, AWS, lifted-product groups' spinouts) | eight to twelve | high: roadmap parameters now rest on randomized bounds these results replace | US$100k--500k each |
| decoder and software companies (Riverlane, Q-CTRL, Classiq, MQT) | about ten | medium | US$10k--50k |
| academic QEC groups | one to two hundred | near zero cash; citations and benchmark adoption | none |
| code-based post-quantum cryptography parameter audit (HSM and PQC vendors, certification labs) | ten to twenty | medium to high once regulators ask for reproducible evidence | US$25k--150k |
| classical LDPC silicon | about six | latent; solved by hiring today | none near term |

Planning scenario, not forecast: US$2--5M per year at maturity within quantum
plus PQC, up from the US$1--3M estimate made before the native results.
First-two-year scenario: two to four hardware customers and US$0.3--1.5M per
year. None of the customer counts, willingness-to-pay ranges, conversion
rates, acquisition thesis, or the claimed fifty-times-larger general market
has been validated by customer evidence.

What would move the number: sweeping the QDistSAT suite and closing
`LP_1768_224` (a headline no competitor can match today); closing the BB756
exact value; and a customer whose roadmap code exceeds exhaustive reach, which
would make the dual-certificate route the paid feature.

The first commercial evidence gate is five to ten disclosure-safe interviews
with qLDPC roadmap owners. Ask whether an independent exact parameter audit
changes a tape-out, architecture, publication, procurement, or investor
decision; what evidence their internal reviewers require; which instances are
currently supported only by randomized search; and whether they would pay for
a private audit. Until those interviews, treat the table as a prioritization
device only.

## 6. Revised patent recommendation

Superseded in part by the re-scope addendum
`2026-08-29-c998-native-backend-patent-rescope.md` and by the source check
recorded in section 6.1. Current recommendation:

1. **Do not file** on the native backend method. Connected-support
   enumeration for exact distance is the Dumer--Kovalev--Pryadko irreducible-
   cluster method, implemented publicly in `dist_m4ri` (GPL-2.0) and wrapped by
   `codeDistance`; the addendum's only surviving residue was the
   constraint-driven branching rule plus the one-sided projected completion
   filter, and section 6.1 shows the branching rule is already in
   `dist_m4ri`. What remains — a Bloom-filtered set of completable projected
   syndromes with a one-sided soundness guarantee — is a standard
   filter-then-verify pattern and is not worth a filing on its own.
2. The nearest patent, US 11,552,653 B2 (Microsoft, 2023), claims growing a
   cluster around each unsatisfied check for *decoding*; it is not a blocking
   risk for distance computation but should be cited in any paper's related
   work to pre-empt the comparison.
3. Keep the earlier verdicts: nothing on the certified compiler alone; paid
   freedom-to-operate work only for storage; automata and solvers low risk.
   Lens remains uncovered; Google Patents claim-text queries returned nothing
   relevant.
4. Disclosure: with no filing intended, the paper and the code push are no
   longer gated on a patent decision. The addendum's sharper point stands —
   a checker cannot replay a hundred-billion-candidate exhaustion, so an
   exact-distance paper must disclose the enumerator, and the moat is speed,
   engineering, certificate discipline, and the trademark, not a claim.

### 6.1 Source check of `dist_m4ri` (2026-08-29)

Clone of `github.com/QEC-pages/dist-m4ri` (depth one) read at
`src/dist_cc.c`, function `start_CC_recurs`. The recursion selects
`row = syn[w]->vec[0]`, documented as "row with the first non-zero syndrome
bit", and extends the current error only by columns incident to that row;
it descends only while the syndrome is nonzero, accepts a zero-syndrome
vector at the weight limit after a logical-nontriviality test against `L`,
and prunes with a per-weight minimum-syndrome-weight hash
(`hash_add_maybe`, `p_swei`). So constraint-driven branching on the first
unsatisfied check is present in the published tool. It does not contain a
precompiled completable-syndrome filter; ergodis' compact and wide backends
compile pair and triple completion keys into sorted `u128` tables and Bloom
filters (`compile_large_completion_filters` in `css_distance.rs`), which is
the remaining engineering difference and the likely source of the measured
speed. That difference is an optimisation, not a claimable method.

## 7. Actions

- Replace every external-facing use of "certificate" with the evidence level
  in section 4.1; reserve "succinct certificate" for a cheap independently
  checkable lower-bound object.
- After disclosure and counsel review make outreach safe, conduct five to ten
  qLDPC-roadmap interviews before turning the market ranges into a forecast or
  committing to a product build.
- Queue one `complete-ports` task for the covering-radius/deep-hole query,
  the symmetry-reduced dual certificate, and extension-field support, with
  the passant code as acceptance instance and the gross code as second gate.
- Discovery-track entries (complete-ports): commutant scalar-field criterion
  for permutation-invariant codes; Chvatal--Gomory rank of the integral-secant
  correction.
- Amend the C998 partition note: symmetry-adapted bases and the certificate
  emitter go in `ergodis-symmetry`; the covering-radius query goes public.
- Sweep the QDistSAT 27-instance suite with the native backend before any
  external claim; it is the benchmark the field scores on.
- Package R2Elite01 as the reference audit bundle: canonical reconstruction,
  source-bound hashes, both exhaustive exclusion records, deterministic RIS
  witness, independent witness check, resource measurements, and exact
  parameter/FOM statement.
