# C855 — Paper I Lean referee-artifact standards remediation

**Lane:** `clebsch`

**Status:** active. Section 1 (ownership and release-closure freeze) is complete and
recorded in [`../2026-08-02-c855-paper-i-closure-freeze.md`](../2026-08-02-c855-paper-i-closure-freeze.md).
Section 2's assertion inventory and bidirectional correspondence map are complete and
recorded in [`../2026-08-02-c855-paper-i-assertion-inventory.md`](../2026-08-02-c855-paper-i-assertion-inventory.md);
the formalization bullets of section 2 and all of sections 3--11 are open. Required before the Paper I formal artifact is called
referee-ready or packaged for its next public release.

## Decisions (2026-08-03, author-delegated)

- The exhaustive 160,930-conic distance audit is demoted from a claim row to
  reported computation: rigidity plus the now-human gap theorem make it
  redundant, and only a descriptive sharpness figure survives. Authorized by
  Tavis via `yc`.
- The q=23 eight-point-passant-arc sharpness witness lands as a Lean theorem
  and, in the same future manuscript pass, as a companion remark; the
  `q = 2k - 3` pencil-saturation mechanism is extracted as a named lemma.
- `HassettTschinkelProposition10` is renamed semantically; the citation moves
  to its docstring and the formal map.
- The q13/q17/q19 maximum-six family ships as a compressed verified checker
  (no structural route exists: the bound fails at q=23), first in the
  checker prototype order.

- Manuscript-strengthening triage approved by Tavis: the batched manuscript
  pass integrates (a) the all-odd-order concurrence-spectrum proposition with
  its equivalence-relation mechanism, (b) the golden normal form and uniform
  rigidity package (one orbit, existence iff 5 square, A5 stabilizer, unique
  polarity over Z[phi]) replacing the Dye citation block, (c) the pentagon
  converse and sharpened twelve-pentagon count in the orientation two-graph
  theorem, and (d) the mandatory order-eleven tagging fix for Edge's
  external/internal reading (types invert at order nineteen). Companion
  additions: the q=23 sharpness witness, the pencil-saturation lemma, and the
  characteristic-3/5 conic-avoidance caveats. Proof-route improvements
  (Brauer-free, Dye-free, characteristic-three splitting) stay out of the
  claim surface and go to formal-boundary prose. No new statement carries
  novelty language until a bounded literature check under
  `notes/literature-audit-conventions.md` clears it; that check gates the
  manuscript pass.

## Objective

Bring the complete Paper I Lean artifact—not merely the files changed by the
latest proof work—into compliance with the current scholarly-artifact,
reproducibility, naming, documentation, trust, and release standards. Make the
formalization theorem-complete: every mathematical assertion used in Paper I
or its computational companion must map to a kernel-checked Lean theorem.
Preserve the mathematics and every existing theorem gate. Do not weaken,
remove, or reclassify a paper claim, gate, audit, or replay requirement to make
the remediation pass.

## Governing standards

The task is governed by the current versions of:

- the [workspace guide](../../AGENTS.md), including guarded Lean entry points,
  dirty-worktree ownership, standalone-mirror direction, and release rules;
- the [Lean workspace guide](../../lean/AGENTS.md), including scholarly module
  prose, semantic public APIs, trust disclosure, generated-artifact rules,
  transitive gates, and build ownership;
- the [paper style guide](../../papers/style-guide.md), including mathematical
  exposition, citations, theorem/proof correspondence, and referee-facing
  language;
- the [research reproducibility conventions](../research-reproducibility-conventions.md),
  including committed scripts, compact evidence, exact replay commands,
  hashes, and independent checks; and
- the [task lifecycle conventions](../task-lifecycle-conventions.md), including
  allocation, live-queue, handoff, closeout, and archive mechanics.

There is no grandfathering for files inherited from an earlier Paper I
package: every file in the published transitive closure is in scope.

## Frozen audit boundary and starting evidence

- [x] Record and retain the audited base commit
  `570086982b26075a71a331a81bb1b519e9a27e7f`.
- [x] Record and retain the q11 source/gate commit
  `81bae5e0eb02c26992f21b71808ef74a22e3b406`.
- [x] Record and retain the q11 manifest-seal commit
  `09d8e174880e7370966da788da3c5d303df8af4f`.
- [x] Freeze the current Paper I aggregate gate's project-owned-module transitive
  closure before edits. The recomputed closure has 198 project-owned modules: 188 in
  `RelativeConicArcs` plus seven `ProjectiveCap` and three `CapGame` modules reached
  through three crossing imports. The non-Lean dependency closure remains open.
- [ ] Preserve the verified positive baseline as starting evidence: no `sorry`;
  exactly two explicit Dye axioms; 51 gate terminals matching 51 axiom-audit rows; no published
  terminal exposing a native-execution axiom; q11 manifest hashes valid for 121
  modules and its generator; base target-manifest hashes valid for 273 sources;
  q11 generator staleness check green; no private path, task ID, status, or
  novelty language in the 30 changed Paper I modules.
- [ ] Preserve an audit ledger for the 30 changed modules and the full closure.
  The initial syntactic census found, in the changed set, 48 public theorems,
  26 definitions, 22 abbreviations, and one inductive declaration without an
  immediately preceding docstring; the full closure produced 1,047 candidates
  in 141 modules requiring manual adjudication.

## Exhaustive remediation checklist

### 1. Freeze ownership and the exact release closure

- [x] Start from clean, content-addressed authoritative and standalone roots;
  record both `HEAD`s and every intentionally dirty task-owned path.
- [x] Recompute the import closure from every Paper I public gate rather than
  trusting the frozen count of 188. The gate is
  `RelativeConicArcs.Gates.ClebschRigidityTrust` and the recomputed closure is 198
  project-owned modules over 43 `Mathlib` roots.
- [ ] Enumerate every generator, generated leaf, certificate, manifest, axiom
  audit, claim map, correspondence table, README, toolchain pin, and replay
  script consumed by the aggregate verifier.
- [ ] Reconcile that computed set against the q11 `MANIFEST`, the base
  `TARGET_MANIFEST`, the paper release manifest, and all verification allowlists.
- [ ] Classify every path changed since the audited base as Paper I-owned,
  shared-with-explicit-owner, or foreign. Coordinate shared/foreign repairs with
  their owners; do not silently absorb another lane's work.
- [ ] Use only the guarded Lean entry points and owning build window prescribed
  by the Lean workspace guide. Do not invoke bare `lake` or an improvised guard.

### 2. Close every mathematical statement in Lean

- [x] Build a sentence-level inventory of every mathematical assertion in the
  main paper and companion, including abstracts, theorem/lemma/corollary
  statements, proof-body claims, displayed identities, examples, tables,
  captions, appendices, and mathematically substantive README claims. Recorded in
  [`../2026-08-02-c855-paper-i-assertion-inventory.md`](../2026-08-02-c855-paper-i-assertion-inventory.md).
  README claims are not yet swept; the two manuscripts are complete.
- [ ] Give every inventoried assertion a stable Lean declaration and record the
  exact declaration name in a bidirectional paper-to-Lean correspondence map.
- [ ] Formalize every previously human-only proof step. Expository proof prose
  may remain, but it must summarize a checked Lean proof rather than carry an
  independent mathematical obligation.
- [ ] Formalize every finite classification and certificate-backed conclusion
  in Lean. A compact certificate may be consumed by a verified Lean checker,
  but an external script's exit status or an unverified data file is not a
  theorem.
- [ ] Eliminate every trusted-execution-only mathematical boundary. Native
  evaluation may accelerate a proof only when the final theorem's axiom audit
  remains within the accepted foundational/library trust base.
- [ ] Eliminate the two ad hoc Dye axioms: either import exact, audited
  kernel-checked library theorems with matching hypotheses and normalization,
  or formalize the required Dye results from definitions in the Paper I
  closure.
- [ ] Prove `ClassicalOddA5ThreePlusThreeSplitting` in Lean (possibly from
  already kernel-checked library results); a citation or declared unproved
  interface is not sufficient for release.
- [ ] Formalize every correspondence assertion connecting the q11 spine,
  orientation packets, finite-field leaves, code reconstruction, and companion
  classifications. No equality of “same mechanism” may live only in prose.
- [ ] Require both coverage directions: no paper assertion without a Lean
  theorem, and no release-gate theorem without an explicit paper/companion role
  or reusable-support classification. The reverse direction already holds: all 51
  gate terminals have a paper-facing role in the recorded map. The forward
  direction is the open half.
- [ ] Have an independent reviewer compare the rendered PDFs line by line with
  the final correspondence map and sign off on zero unformalized mathematics.

### 3. Replace manuscript-relative and false-strength API names

- [ ] Rename all eleven `PaperIOrientation*` modules to stable mathematical
  names and update their filenames, imports, namespaces, manifests, gates, and
  correspondence maps atomically.
- [ ] Remove `PaperI`, paper-number, task-number, and manuscript-section
  prefixes from public declarations where the mathematical object has a stable
  semantic name.
- [ ] Move manuscript correspondence into the paper's formal map or prose; do
  not encode it in reusable library identifiers.
- [ ] Audit every public identifier for unjustified strength words such as
  `canonical`, `unique`, `exact`, `complete`, `classification`, or
  `reconstruction`.
- [ ] Rename `OddSixArcPrismExtraction.canonicalLabel`: it is currently a
  noncomputably chosen equivalence obtained from `Finset.equivFinOfCardEq`, not
  a canonical construction. Use a chosen-label name unless an actual
  choice-independence/canonicity theorem is supplied.
- [ ] Check that theorem names state the real quantifiers, hypotheses, and
  conclusion and do not imply a stronger uniform or constructive result.
- [ ] Remove compatibility aliases that would keep misleading public names
  alive, unless a separately justified downstream migration requires one.

### 4. Document every scholarly declaration

- [ ] Give every public theorem in the changed closure an immediate docstring.
- [ ] Give every non-obvious public definition, abbreviation, structure,
  inductive type, instance, and namespace-level datum an immediate docstring.
- [ ] Resolve every initial changed-module candidate, including confirmed gaps
  in `OddSixArcPrismExtraction`, `PaperIOrientationCover`,
  `PaperIOrientationDeterminant`, `SixVertexOneFactorization`,
  `Q11A5PointOrbitsData`, and `ClebschGatewayQ11Extension` (using their renamed
  semantic module names where applicable).
- [ ] For each declaration, state the ambient objects, quantifiers, hypotheses,
  indexing convention, normalization, and the exact mathematical conclusion.
- [ ] For each nontrivial proof, add a concise structural proof idea explaining
  the mechanism rather than narrating tactics or computation.
- [ ] Manually adjudicate all 1,047 initial candidates across the full closure;
  record a reason for every intentional non-docstring case rather than treating
  a syntactic scan as the final verdict.
- [ ] Re-run the census after renames/regeneration and require zero unexplained
  public-documentation gaps.

### 5. Repair module headers, citations, and trust prose

- [ ] Make every changed module header self-contained: mathematical purpose,
  principal declarations, proof mechanism, imported assumptions, and trust
  boundary.
- [ ] Distinguish symbolic proof, finite decidable checking, generated data,
  native execution, and external mathematical assumptions precisely.
- [ ] Preserve honest disclosure of native execution where used internally,
  while ensuring no public terminal acquires a native-execution axiom.
- [ ] Correct the Dye attribution. The present generic reference to “Theorems
  1 and 3, pages 275–278” must be replaced by the exact source for each
  formalized transfer: the Section 2.2 bound and Theorem 1(ii), page 275.
- [ ] Give `ClassicalOddA5ThreePlusThreeSplitting` an authoritative external
  author/title/year/stable locator and exact pinpoint in addition to its
  kernel-checked Lean proof.
- [ ] Audit every external theorem transfer for matching hypotheses,
  normalizations, characteristic restrictions, and conclusion; record exact
  locators and pinpoints.
- [ ] Remove internal workflow labels such as `WP-1`, planning language,
  private paths, task IDs, transient status, reviewer simulation, and novelty
  assertions from the public artifact.

### 6. Repair generated-source provenance and scholarly surface

- [ ] Fix the q11 leaf template's repository-relative generator path. It emits
  `lean/scripts/generate-q11-a5-point-action.py`, while the package path is
  `scripts/generate-q11-a5-point-action.py`; repair all 66 affected generated
  modules through the generator, not by hand.
- [ ] Make every generated header identify its semantic input, generator,
  deterministic invocation, output domain, and independent verification.
- [ ] Add docstrings to generated public declarations through the template.
- [ ] Make `Q11A5PointOrbitsData` distinguish semantic input data from derived
  output and compact certificates.
- [ ] Document why the generation is deterministic and why groups 0–4 exhaust
  the declared domain; retain an independent check rather than relying only on
  generator self-consistency.
- [ ] Regenerate only in the guarded owner window, validate atomically, and
  require the changed path set to equal the expected generated allowlist.
- [ ] Run the generator's checked/staleness mode and verify byte identity on a
  second clean replay.
- [ ] Refresh every affected generator hash and generated-source hash in every
  manifest.

### 7. Resolve the contaminated base-commit distribution boundary forward

- [ ] Record that base commit `5700869...` also contains unrelated CapGame and
  ProjectiveCap changes, including workflow prose (`WP-1`, “projective-cap
  plan”, and “future parser/checker”) and removed public documentation.
- [ ] Do not rewrite or discard published/shared history. Resolve the package
  boundary by ordinary forward commits with the relevant owners.
- [ ] Decide and document one defensible release model: either clean the entire
  distributed repository closure to the same standard, or define a narrow,
  deterministic Paper I allowlist whose completeness is proved from the gate
  roots.
- [ ] If the full repository is distributed, repair the foreign workflow prose
  and restored public documentation with owner approval.
- [ ] If an allowlist is used, make it content-addressed, manifest-backed,
  import-closed, independently checked, and impossible to bypass through an
  unlisted runtime/generated dependency.
- [ ] Verify that public tarballs, mirrors, and replay instructions expose only
  the selected, audited boundary.

### 8. Repair public and maintainer replay documentation

- [ ] Separate the third-party public replay recipe from workspace-maintainer
  commands that are subject to the guarded entry point.
- [ ] Remove or qualify README commands that tell workspace maintainers to run
  bare `lake`/`nix ... lake` in conflict with the Lean workspace guide.
- [ ] Give exact guarded maintainer commands, worker/memory constraints, root
  selection, and expected terminal artifacts.
- [ ] Verify every documented path from both the authoritative repository and
  the standalone export; no command may depend on a private absolute path.
- [ ] Test the public recipe in a fresh isolated checkout and the maintainer
  recipe through the canonical guard.

### 9. Reconcile theorem, trust, and manuscript correspondence

- [ ] Update the aggregate import gate after all semantic renames.
- [ ] Run reverse-import checks so no gate terminal is available through an
  unintended umbrella import or foreign theorem surface.
- [ ] Regenerate the 51-terminal axiom audit from the final tree and require
  exact one-to-one agreement with the aggregate gate.
- [ ] Require no ad hoc Dye axiom, `sorry`, `unsafe`, oracle,
  native-execution axiom, trusted-execution theorem, or newly imported project
  axiom at a public terminal.
- [ ] Reconcile all nineteen Paper I/companion statement rows with the exact
  final kernel-checked Lean declarations; no human-only or computational-only
  mathematical boundary may remain.
- [ ] Replace the five-mode ledger's mathematical boundaries with a theorem-
  complete ledger: human exposition, published citations, finite certificates,
  and execution may explain provenance or proof method, but every resulting
  mathematical claim must terminate in a checked Lean theorem.
- [ ] Check both directions: the paper must not claim more than Lean proves,
  and every public formal theorem must have a clear paper-facing purpose or be
  explicitly identified as reusable support.
- [ ] Update the formal-boundary prose minimally and only where the completed
  audit changes what a referee should understand; make no new mathematical or
  novelty claim.
- [ ] Rebuild all claim maps, correspondence tables, trust manifests, source
  manifests, counts, and hashes from the final authoritative tree.

### 10. Validation and release replay

- [ ] Elaborate every edited handwritten module through the canonical guard.
- [ ] Validate generated q11 leaves under the finite-certificate sharding rules;
  do not substitute one large unbounded build.
- [ ] Pass the complete Paper I aggregate Lean gate and exact axiom audit.
- [ ] Pass generator staleness, manifest-integrity, reverse-import,
  correspondence, privacy, and scholarly-prose/name scans.
- [ ] Perform a manual review after automated scans; regex success is not an
  acceptance substitute.
- [ ] Run the authoritative Paper I twenty-six-check aggregate release verifier
  with the explicit Lean root.
- [ ] Rebuild and visually inspect both the main-paper and computational-
  companion PDFs if formal-boundary prose, locators, or evidence tables change.
- [ ] Regenerate release identities, page counts, manifest hashes, and expected
  output only after all source and PDF surfaces are final.
- [ ] Forward-synchronize the authoritative sources, PDFs, bibliography,
  manifests, and Lean export manifest to `~/src/math-papers/clebsch-rigidity`
  as an ordinary unsigned commit preserving standalone history.
- [ ] Replay the complete standalone release gate in a clean state and require
  agreement with the authoritative release identity.
- [ ] Do not GPG-sign and do not push any local or remote branch.

### 11. Independent closeout

- [ ] Run an adversarial red-team review focused on false strength, hidden
  assumptions, generated-data circularity, underdocumented APIs, and mismatch
  between prose and formal dependencies.
- [ ] Run a fresh-reader replay using only the public README and distributed
  artifact; the reader must not need workspace history or private knowledge.
- [ ] Re-run the full missing-docstring/name/provenance/citation scan and require
  zero unexplained findings.
- [ ] Perform the required `ej` plus `tt` closeout pass and add the mystery
  ledger to the dated C855 report, with an exact owner/gate for every residual.
- [ ] Update the live handoff, archive the queue row, and close the lifecycle in
  one coherent commit only after every acceptance condition below passes.

## Acceptance conditions

C855 is complete only when:

1. the complete published transitive closure—not merely the recent diff—passes
   manual scholarly prose and semantic-name review;
2. every generated source has correct, reproducible provenance and documented
   public declarations;
3. no public API encodes a paper/task number or claims unsupported canonicity,
   uniqueness, exactness, or completeness;
4. every mathematical assertion in both rendered papers has an exact
   kernel-checked Lean declaration, and the bidirectional correspondence audit
   has no human-only, certificate-only, trusted-execution-only, or cited-axiom
   gap;
5. every external source has an exact authoritative citation and every used
   mathematical transfer is itself proved in Lean or imported as an audited
   kernel-checked library theorem;
6. the aggregate gate and axiom audit agree exactly, with no ad hoc Dye,
   native-execution, oracle, or project axiom at a terminal;
7. manifests and claim/correspondence maps describe the final closure exactly;
8. all guarded Lean, generator, manifest, reverse-import, PDF, and twenty-six-
   check release gates pass in the authority; and
9. the forward-synchronized standalone repository reproduces the same release
   from its public instructions, with unsigned local commits and no push.

Successful elaboration alone does not satisfy this task.
