# Ergodis commercialization analysis memo

**Lane**: `complete-ports`

**Date**: 2026-08-29
**Status**: analysis record of the 2026-08-29 discussion; private; no product,
publication, filing, push, or novelty claim authorized. Numbers quoted from
task reports are those reports' numbers; market figures are estimates and are
marked as such.

Companion records: `2026-08-29-c998-ergodis-partition-design.md`,
`2026-08-29-c998-patent-landscape.md`,
`2026-08-29-ergodis-certificate-prior-art-veripb.md`,
`2026-08-28-ergodis-ldpc-quantum-angle.md`, and the C985 result notes dated
2026-08-29 (BB784, QDistSAT BB360, BB756, R2Elite01, R2Elite02, native and wide
CSS backend plans, Gurobi boundary memo).

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
| bivariate bicycle `[[756,16,<=34]]` | Bravyi et al. | `d >= 24` certified; exact value open | 33 s; Gurobi licence refused |
| lifted product `R2Elite02` | Liu--Marquardt | exact `[[1496,198,16]]` | published bound was randomized |
| lifted product `R2Elite01` | Liu--Marquardt | `[[1496,194,d]]`, `d >= 16` | exact value open |
| C997 control, one core | gross code | 0.12 s compile + 0.15 s search | Gurobi one-thread 3.8 s |

The Gurobi boundary memo fixes the product boundary: domain object, then
ergodis to a smaller certified model, then any backend (Gurobi, SCIP, Kissat,
or the native search), then ergodis to a lifted exact witness. Persistence of
compiled filters passed its gate; parallel orbit anchors and a diversified
qLDPC suite are next. The QDistSAT 27-instance suite, including the open
`LP_1768_224`, has not been swept.

Consequences for the analysis above:

1. Exact certification at 1,496 coordinates in minutes, where the authors
   published randomized upper bounds, is a capability no surveyed tool has.
   The product is exact certification at a scale the field treats as out of
   reach, with the certificate as the deliverable.
2. The Delsarte--Schrijver dual certificate remains valuable but moves to the
   instances beyond exhaustive reach (the BB756 gap, the R2Elite01 exact
   value) and to compact replacement of billion-candidate replay records.
3. The deep-hole unification and passant fixtures stand; they are consumers
   of a proven engine rather than reasons to build one.
4. The patent object changes from "symmetry reduction of an optimization
   model" to the native method itself: connected-support enumeration with
   exact syndrome tracking, projected completion filters whose collisions can
   only admit candidates, witness transport by certified isomorphism, and
   persisted source-bound compiled filters. That is implementation-specific,
   has a measurable technical effect, and is a materially better
   subject-matter-eligibility position.

## 5. Revised market sizing (estimates)

Serviceable market for certified qLDPC and stabilizer-code distance:

| segment | approximate count | willingness | plausible annual spend |
|------------------------------------------------------------------|-------------------|---------------------------------------------------------------|------------------------|
| hardware roadmap owners betting on qLDPC (IBM, Google, Infleqtion, Quantinuum, PsiQuantum, AWS, lifted-product groups' spinouts) | eight to twelve | high: roadmap parameters now rest on randomized bounds these results replace | US$100k--500k each |
| decoder and software companies (Riverlane, Q-CTRL, Classiq, MQT) | about ten | medium | US$10k--50k |
| academic QEC groups | one to two hundred | near zero cash; citations and benchmark adoption | none |
| code-based post-quantum cryptography parameter audit (HSM and PQC vendors, certification labs) | ten to twenty | medium to high once regulators ask for reproducible evidence | US$25k--150k |
| classical LDPC silicon | about six | latent; solved by hiring today | none near term |

Base case: US$2--5M per year at maturity within quantum plus PQC, up from the
US$1--3M estimated before the native results, because exact certification of
roadmap codes is a gating item rather than a convenience. First-two-year
capture: two to four hardware customers, US$0.3--1.5M per year. The larger
value remains strategic: the customers are the acquirers, and the same engine
is the credibility proof for the general certified symmetry compiler whose
market (exact-optimization tooling, EDA formal) is fifty times larger.

What would move the number: sweeping the QDistSAT suite and closing
`LP_1768_224` (a headline no competitor can match today); closing the BB756
exact value; and a customer whose roadmap code exceeds exhaustive reach, which
would make the dual-certificate route the paid feature.

## 6. Revised patent recommendation

1. File one narrow US provisional on the native backend method, not on
   symmetry reduction: connected-support enumeration with exact syndrome
   tracking, projected completion filters with the one-sided-collision
   guarantee, certified witness transport between CSS directions, and the
   persisted compiled-filter artifact with source fingerprint checks. Cite
   the Dumer--Kovalev--Pryadko irreducible-cluster method, `dist_m4ri`, and the
   connected-cluster backend in `codeDistance` as the closest prior art and
   state the residue over them in one sentence before drafting.
2. Re-run the quantum landscape search against Google Patents and Lens once
   they are reachable, restricted to code-distance computation, connected or
   irreducible cluster enumeration, and syndrome filtering claims.
3. Keep the earlier verdicts: nothing on the certified compiler alone; paid
   freedom-to-operate work only for storage; automata and solvers low risk.
4. Sequencing is unchanged: provisional decision before the paper, the paper
   before any public push, and no push of the native backend code before the
   decision, because publishing the checker publishes the method.

## 7. Actions

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
