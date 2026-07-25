# C603 — beyond-four PRS paper-facing Lean trust audit

**Lane:** `reed-solomon` · **Date:** 2026-07-25 · **Status:** complete

## Verdict

The retained R5--R7 manuscript is **not release-ready at its Lean trust
boundary**.  The kernel evidence is green, but the object being checked is the
pre-scope-reset R5--R9/Hessian/Lucas aggregate rather than the adopted
manuscript closure.  The paper-facing ledgers consequently fail their own
claim/declaration reconciliation gate.

No source or ledger finding was repaired in C603.  This report records the
independent audit state required before C545 may prepare a public release.

## Audited target and method

The adopted manuscript is the common source selected by `main.tex` and
`main-tit.tex`: abstract, overview, dictionary, redundancy five, coherent polar
induction, redundancies six/seven, verification, provenance, and scope.  It
contains 35 numbered theorem/proposition/corollary/lemma labels.

The formal target advertised by the manuscript and ledgers is
`RelativeConicArcs.Gates.PRSBeyondRedundancyFour`, with
`RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit`.  Recursive import
resolution gives 20 project-owned Lean files in the import closure and 21 when
the audit file itself is included:

- 12 mathematical modules;
- 8 import gates; and
- the aggregate axiom-audit file.

The review covered all 4,253 lines in those files, their module headers,
public declaration prose and types, trust-sensitive constructs, pathnames,
imports, repository references, and the sole non-Lean artifact named by the
closure.  It also compared the adopted TeX labels against
`supplement/LEAN-STATEMENTS.md`, `formalization-ledger.md`,
`claim-proof-novelty-ledger.md`, `theorem-map.md`, `verification-map.md`,
`README.md`, the operative scope-reset plan, and the release documents.

## Reproduced evidence

- `python3 supplement/verify.py`: pass.  The classification-record hashes,
  generated R6 paper table, and local release-manifest rows pass.
- Guarded exact target plus trace-only aggregate:
  `/home/tavis/.cache/othello-lean-build/run-20260725-155914-d601ba32`.
  The audit target was trace-current and the aggregate gate passed.
- Fresh guarded single-file elaboration of
  `PRSBeyondRedundancyFourAxiomAudit.lean`: pass.  It executed 113
  `#print axioms` commands: 19 declarations were axiom-free and 94 reported
  only `propext`, `Classical.choice`, and/or `Quot.sound`.
- `supplement/CLASSIFICATION-RECORDS.json`: 545,912 bytes, SHA-256
  `b3441d983798793f211878de7e72b976be9170b580041f460cf981a73dbf66a2`,
  agreeing with both transcription-module headers and the paper-local
  manifest.

These checks establish elaboration, the stated standard-axiom set, and local
artifact integrity.  They do not establish that the gate matches the adopted
paper.

## Findings

### G1 — critical: the aggregate is not the adopted manuscript closure

The 2026-07-24 scope reset says that the submission stops at R7 and that R8,
R9, ordered Hessians, general Lucas carriers, and the distinguished
degree-nine endpoint are companion work and are not dependencies of the
submission theorems.

Nevertheless, `PRSBeyondRedundancyFour.lean` imports the R8, R9, and
characteristic-two Hessian/Lucas gates and describes redundancies five through
nine and the degree-nine endpoint as the paper-facing closure.
`PRSBeyondRedundancyFourAxiomAudit.lean` correspondingly audits terminals from
all of those packages and calls them paper-adopted.  In addition,
`Gates/PRSFoundation.lean` imports the whole redundancy-nine synthesis module,
so removing only the three top-level companion gates would still not produce
an R5--R7 closure.  `PRSFoundation.lean` also imports the residual-quadratic
module to reuse contraction definitions; that shared API and its unrelated
degree-nine declarations are not separated at module level.

The gate is mathematically consistent and elaborates, but it fails C544's
stated acceptance condition that one paper-facing closure reach every adopted
terminal and no unadopted theorem.

### G2 — critical: declaration reconciliation is stale and incomplete

The adopted TeX graph has 35 numbered mathematical labels.
`supplement/LEAN-STATEMENTS.md` has 48 rows:

- 11 current labels are absent:
  `lem:hankel`, `lem:cyclic`, `lem:s3`, `lem:marker-collision`,
  `lem:uniform-collision`, `lem:linear-modular-pullback`, `lem:r6-gcd1`,
  `prop:r6-contained`, `prop:r6-one-step`, `thm:uniform-transverse`, and
  `cor:large-characteristic-stable`;
- 24 rows refer to labels removed by the scope reset: every listed R8, R9,
  Hessian, Lucas, and `e7` statement; and
- the `thm:spine` row still says that the current theorem aggregates R8 and R9,
  although the adopted theorem contains only the R6/R7 clauses and persistent
  orbit law.

Thus the former “47-label” reconciliation and the later “48-label” checklist
claim are both false for the adopted source.  The local verifier does not
compare the TeX include graph with the statement table, so its green result
does not detect this failure.

### G3 — high: one formal-coverage description overstates what Lean checks

`PRSPolarInduction.LowerCoverStratum` records genus, deletion degree,
geometric integrality, and two numerical inequalities.  The synthesis theorem
`CoherentPolarInput.splitFree_implies_persistent_or_modular` does not derive a
witness from those numerical fields.  Its `lowerWitness` field directly
assumes a witness at each admissible marker; the proof uses that assumption
and the stratum's geometric-integrality proposition, but not its genus,
deletion, or Hasse--Weil fields.

The conditional theorem is sound and its witness boundary is explicit.
However, the `prop:r7-pointed` row in `LEAN-STATEMENTS.md` says that the
“logical use of genus/deletion data is checked.”  That is too strong.
The same row calls the manuscript input “degree 24,” while the adopted proof
and adversarial ledger use the corrected deletion degree 25.  Lean checks the
outer R7 threshold and first-marker budgets `37`, `4`, and `8`; it does not
kernel-check the two-marker `δ=25` point-count derivation.

### G4 — high: the trust and adoption ledgers disagree with the operative scope

The following repository-paper records still present removed companion
material as adopted or current:

- `theorem-map.md` calls R8, R9, Hessian, Lucas, and `e7` adopted manuscript
  results and says the aggregate contains exactly the adopted terminals;
- `claim-proof-novelty-ledger.md` retains those results as main/supporting
  theorems and keeps release-checklist rows tied to them;
- `formalization-ledger.md` describes degree-specific R8/R9/Hessian/Lucas
  coverage as part of the paper-facing boundary;
- `supplement/LEAN-STATEMENTS.md` and the aggregate gate retain the old
  declaration set;
- `README.md` correctly describes the R5--R7 scope but still says the present
  draft passes the aggregate formalization gate; and
- the C544 report says 103 audited terminals, while the current audit file and
  fresh output contain 113.  The historical release checklist has the newer
  number but is explicitly superseded and still asserts obsolete label
  reconciliation.

The manuscript's own verification paragraph is narrower and honest: it says
that no geometric classification theorem is claimed formalized and that Lean
checks coordinate algebra and conditional implications.  The defect is the
repository-to-paper trust route, not that paragraph.

### G5 — medium: external mathematical dependencies need a sharper public ledger

The retained proof has four load-bearing external roles:

| Source/result | Use in the adopted paper | Present boundary |
|---|---|---|
| Seroussi--Roth | R5--R7 normal-rational-curve completeness / covering-radius promotion | Load-bearing; exact theorem/pages appear in the Lean module header, but not at the manuscript citation. |
| Aubry--Perret | arithmetic-genus-one rational-point lower bound | Load-bearing; the R5 use has a page pinpoint and later polar bounds reuse the same result. |
| Kaipa and Zhang--Wan--Kaipa | syndrome/MDS/uncovered-point dictionary and lower tangent/conjugate-secant families/counts | Load-bearing; cited without theorem/page pinpoints at the uses. |
| Lucas' theorem | modular-kernel support and the large-characteristic corollary | Load-bearing; invoked by name but uncited in the retained proof. |

Wang's Frobenius/factorization theorem is named with a theorem pinpoint in
the introduction.  Gmainer--Havlicek is described as an input for nuclei but
without a statement-level locator.  Ball--Lavrauw, Dür, Zhang--Wan,
Xu--Hong--Xu, Xu, Wu--Ding--Chen, Iarrobino--Kanev, Comas--Seiguer, and
Cesaratto--Matera--Pérez serve comparison, background, or method context in
the retained text rather than a displayed proof step.

This inventory does not re-audit the external papers.  It identifies the
public dependency roles and the citation-pinpoint gaps required by
`papers/style-guide.md` and `lean/AGENTS.md`.

## Repository and executable dependency ledger

| Claim group | Mathematical/repository proof route | Executable/formal route | Boundary |
|---|---|---|---|
| R5 | manuscript cubic-pencil proof plus the three external roles above | Certificates R5; R5 Lean algebra, arithmetic, and conditional synthesis | finite-orbit semantics, geometric exhaustion, genuine actions, and cited theorems remain external to Lean |
| R6 | manuscript one-marker, contained-component, and point-count proof | Certificates R6/R6-NF; R6 conditional synthesis and arithmetic | geometry, radius, actions, and certificate semantics are inputs |
| R7 | manuscript two-marker, contained-component, and radius-gated proof | Certificate R7; R7 conditional synthesis and summary arithmetic | `q=7,8,9` remain split-free only; `δ=25` is manuscript mathematics |
| all-level stable components/transverse threshold | manuscript rowspace, integral component, Lucas, collision, and point-count proof; Certificate SC | stable-component coordinate identities and generic conditional polar implication | Lean does not formalize rowspace density, component exhaustion, or derive witnesses from the recorded Hasse--Weil fields |
| finite classifications | `supplement/CLASSIFICATION-RECORDS.json` and public schema/generators/replays | Lean reduces transcribed arithmetic | identification with finite-field syndrome orbits and exhaustive-search semantics remain externally validated |

The repository-only `verification-map.md` records internal predecessor
generators and replay paths.  The paper-local supplement is the intended
self-contained public route.  A public export must not make the development
monorepo or internal task records a mathematical dependency.

## Referee-facing Lean source review

The 21-file source closure passes the source-hygiene portion of
`lean/AGENTS.md`:

- no task ID, lane, agent/model, session, internal-note path, local filesystem
  path, TODO/FIXME, or planning/status vocabulary occurs;
- no declaration uses `sorry`, a project-local `axiom`, `unsafe`,
  `native_decide`, or an opaque oracle;
- all 286 detected public theorem/lemma/definition/structure/class
  declarations have an adjacent docstring;
- module and declaration names are mathematical rather than chronological;
  and
- the one repository artifact cited from Lean has a stable path, described
  semantics, matching bytes/hash, and an explicit external-semantics boundary.

The exception is scope language: the aggregate and audit headers call the
obsolete larger closure “paper-facing” and “paper-adopted.”  That is a false
current-scope claim even though it is not private workflow vocabulary.

## Style and release-readiness matrix

| Gate | Result | Reason |
|---|---|---|
| Kernel elaboration and standard-axiom audit | pass | fresh 113-command audit reports only the three disclosed standard dependencies |
| No hidden oracle/generated Lean certificate | pass | source and import review agree with the headers |
| Finite-record bytes/hash and quick verifier | pass | public JSON and local manifest agree |
| Exact adopted import closure | **fail** | R8/R9/Hessian/Lucas companion gates remain imported |
| Every adopted manuscript label reconciled | **fail** | 11 missing current rows and 24 obsolete rows |
| Claim/declaration descriptions agree | **fail** | R7 deletion route is overstated and carries stale degree 24 |
| Trust/adoption/release documents synchronized | **fail** | maps and ledgers straddle pre- and post-scope-reset papers |
| External theorem pinpoints | review | several load-bearing uses lack statement-level locators |
| Immutable public Lean/export identity | open | already owned by C545 after the local trust boundary is repaired |

The operative F5 cold-session gate therefore fails.  C545 must not describe
the current artifact as a proof-complete release candidate until the adopted
R5--R7 closure, axiom target list, statement map, trust ledgers, verifier, and
public export agree and the repaired package is independently rerun.

## Extra-juice and Tao closeout

The closeout tested whether the green checks could be made scope-sensitive
without changing mathematics.  It exposed two high-value facts:

1. the supplement verifier checks bytes and generated tables but has no
   semantic assertion that its statement map equals the current TeX include
   graph; and
2. a valid conditional Lean theorem can still be described too strongly when
   numerically meaningful structure fields are merely recorded while a
   separate witness field supplies the actual proof.

Both belong in the release repair: an exact label-set/target-set check is a
cheap regression, and the public prose should distinguish “data carried in
the interface” from “data used to derive the conclusion.”

## Mystery ledger

Settled:

- **Is the reported standard-axiom set reproducible?** Yes: a fresh
  elaboration reports only `propext`, `Classical.choice`, and `Quot.sound`.
- **Is a hidden local axiom, native evaluator, generated Lean certificate, or
  reverse workflow reference present?** No.
- **Does the paper-local classification record match the Lean headers?** Yes,
  exactly by bytes and SHA-256.
- **Why can all automated gates be green while F5 fails?** They check the
  obsolete aggregate and manifest bytes, not equality with the adopted
  manuscript label and target sets.

Open, with exact owner/gate:

- **What is the minimal scholarly R5--R7 Lean closure?** C545's pre-release
  repair must choose it explicitly.  The current foundation module couples the
  shared contraction API to residual-quadratic declarations, and the
  foundation gate imports the full R9 synthesis module.
- **Should the lower-cover numerical fields be connected by a formal
  point-existence theorem or merely described as external metadata?** C545
  must choose one honest public boundary; C603 does not change architecture.
- **Do the external-paper statements match the precise manuscript uses?**
  Statement-level citation verification remains required for the missing
  pinpoints before release.

No incidental observation met the discovery-track discriminator; every
finding above was sought by the C603 audit.
