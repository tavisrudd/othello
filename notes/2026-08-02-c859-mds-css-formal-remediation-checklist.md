# C859 — Paper II formal and trust remediation checklist

**Lane:** `ame-lu`

**Status:** closed 2026-08-03. Every box below is closed except the three
cross-lane coordination items and the queue-archive step, which need the
owners' or the user's decision. Results, hashes, and the remaining boundaries
are in `2026-08-03-c859-mds-css-formal-remediation.md`.

**Scope:** close the Paper II formal-companion and public trust gaps without
changing theorem strength or importing the Paper I quantitative chain

Every checkbox is mandatory unless the final report gives a locatored,
standards-based reason that the item is inapplicable. Cross-lane files require
coordination with their recorded owners; do not edit foreign dirty work.

## 1. Freeze statement ownership and the exact formal crosswalk

- [x] Read C858, the full Paper II manuscript, theorem map, verification map,
  formalization ledger, claim/proof/novelty ledger, supplement evidence report,
  and `papers/ame_lu/cross-paper-theorem-ownership.md` before editing.
- [x] Enumerate every Paper II theorem/corollary/lemma label and classify it as
  manuscript-only, unconditional Lean, conditional Lean interface,
  certificate-backed, cited external, or imported Paper I.
- [x] Add the imported minimum-support atlas to `theorem-map.md`; remove the
  false “one imported dependency” and “atlas excluded” statements.
- [x] Preserve Paper I ownership of rigidity, transversal no-go, phase
  correction, and the minimum-support atlas; Paper II may import but may not
  duplicate those results.
- [x] Confirm that the seven two-uniform/quantitative modules added on
  2026-08-02 remain outside both Paper II semantic roots.
- [x] Record exact fully qualified Lean declarations for every formalized row,
  and ensure manuscript-only/certificate/external rows name no Lean terminal.

## 2. Create the semantic import gate

- [x] Add
  `lean/RelativeConicArcs/Gates/MDSCSSTransversalGeometry.lean` as an
  import-only Paper II root with a self-contained mathematical header.
- [x] Import every and only the modules needed for Paper II's claimed Lean
  surface: dictionary/stabilizer dictionary, multiplier/nullity and
  hypothesis-explicit carrier, logical phase/four-copy, pencil quotient and LU
  implication, extension-field divisor algebra, syndrome geometry,
  marginal-moment algebra/interface, transport algebra/interface, and abstract
  party-splitting consequences.
- [x] Include imported Paper I formal terminals only where Paper II genuinely
  cites them, and explain the one-way ownership boundary without referring to
  task records or workflow state.
- [x] Exclude Paper I quantitative rounding, partial-Weyl recognition,
  two-uniform stability/discreteness, robust atlas, and unrelated shared-AMELU
  topology from the Paper II closure.
- [x] Check the gate header against every imported module and every claimed
  terminal; distinguish unconditional theorems, explicit input structures,
  native evaluation, and external certificates.
- [x] Audit the full transitive project-owned closure for scholarly docstrings,
  stable names, precise scope, trust disclosures, and forbidden workflow or
  machine-local references; record any foreign-owned cleanup instead of
  editing it opportunistically.  **Scope note (2026-08-03):** this audit
  excludes every `ProjectiveCap` and `CapGame` module.  Run it against the
  post-C860 closure, which consumes the audited, relocated shared
  projective-plane base under `RelativeConicArcs` — documented by C860 during
  the move — rather than the cap-game library.  A residual cap-game import in
  the AME-LU gate closure (`RelativeConicArcs.Gates.AMELUAggregate` and its
  axiom audit) after C860's stages is a defect to report to C860, not to repair
  here.  See `notes/2026-08-03-c860-execution-design.md`.

## 3. Create and verify the axiom audit

- [x] Add
  `lean/RelativeConicArcs/Gates/MDSCSSTransversalGeometryAxioms.lean`, importing
  only the new semantic gate.
- [x] List `#print axioms` for every paper-facing terminal named by the formal
  crosswalk, including conditional terminals whose assumptions are ordinary
  structure arguments rather than axioms.
- [x] Include all native-evaluated graph-count terminals and record the exact
  implementation axioms printed by the pinned Lean toolchain; do not infer an
  historical axiom name.
- [x] Include abstract party-extension consequences and every logical-phase,
  four-copy, and transport terminal actually cited by Paper II.
- [x] Exclude the unclaimed extension-field full orbit-classification terminal
  unless the manuscript and ownership ledgers are deliberately expanded and
  independently re-audited.
- [x] Reconcile the axiom output with module headers, the manuscript
  verification section, and the supplement; no stronger trust claim may
  survive.

## 4. Build the recursive formal trust contract

- [x] Use the repository trust tooling to compute the recursive closure from
  the two Paper II roots; do not use `AMELU` filename globs or the mixed
  `AMELUAggregate` as evidence.
- [x] Produce content-addressed facts/manifest artifacts in the established
  `lean/trust` schema, covering source paths, hashes, imports, terminal names,
  axiom facts, toolchain identity, and any non-Lean inputs needed by a claimed
  formal terminal.
- [x] Register Paper II's `adopted_labels`, verification manifest,
  `manifest_labels`, and fully qualified `lean_terminals` in
  `lean/trust/papers.toml`.
- [x] Generate and track
  `lean/trust/paper-facts/mds_css_transversal_groups.json` through the official
  tooling; do not hand-edit generated facts.
- [x] Run the paper-facts audit/check for Paper II and obtain zero Paper-II
  errors and no unexplained warnings.
- [x] Decide and document the `.bbl` reproducibility policy so the compiled PDF
  has either a tracked/pinned bibliography output or a reproducible declared
  generation route accepted by the trust checker.

## 5. Replace public status prose with a present-tense boundary

- [x] Rewrite `README.md` so it points to the existing semantic gate, axiom
  audit, and content-addressed formal contract; remove “deferred” workflow
  language.
- [x] Rewrite `sections/08-verification-boundary.tex` so the manuscript states
  what the checked formal companion covers now, what remains conditional or
  external, and how the exact artifacts are identified; remove “scheduled” and
  “draft” status language.
- [x] Rewrite the Lean crosswalk in `supplement/EVIDENCE.md` from future tense
  to exact current roots, terminal names, trust route, and limitations.
- [x] Scan every exported text, generator banner, diagnostic, and enduring
  verification artifact for task IDs, lanes, agents/models, sessions, private
  paths/URLs, mutable commits used as authority, and prohibited planning/status
  vocabulary.
- [x] Ensure every external mathematical dependency has a stable public
  citation with exact result locator, including the companion Paper I rigidity
  and atlas results; do not invent a locator if publication ordering still
  blocks it.

## 6. Reconcile portfolio and cross-lane drift

- [x] Coordinate the Paper II title additions required by
  `notes/2026-07-31-work-summary.md` and `papers/papers-index.md` with their
  owners.
- [x] Coordinate correction of the stale self-authored title in
  `papers/beyond4_prs/refs.bib:RuddAMELU2026` with the `reed-solomon` owner.
- [x] Re-run the bounded Paper II paper-facts audit after those owner-approved
  changes and record each cleared finding.
- [x] Update Paper II's internal formalization, theorem, verification, and
  claim/proof ledgers so they agree exactly with the new gate, axiom audit,
  public manifest, and atlas import.

## 7. Guarded validation

- [x] Wait for a quiescent owned Lean window; never stop or build through a
  foreign lane's process or dirty closure.
- [x] Build the exact semantic gate and axiom-audit targets through the managed
  Lean queue with the documented profile and ownership lock.
- [x] Obtain trace-current exact-target `--no-build` confirmations after the
  builds.
- [x] Capture and inspect the actual bounded `#print axioms` output; reconcile
  every dependency with the public trust prose and generated facts.
- [x] Run reverse-import/blast-radius checks and every affected gate required by
  shared-library policy; defer only with an explicit recorded owner conflict.
- [x] Run Paper II `make check` and the full
  `python3 supplement/verify.py --replay` command.
- [x] Run the official paper-facts, trust-spine, manifest, private-reference,
  and exporter plan/audit checks selected by the repository contracts.
- [x] Inspect the rebuilt PDF pages affected by verification prose and confirm
  warning-free TeX output and working DOI/PDF links.

## 8. Public formal export and standalone synchronization

- [x] Coordinate any required public `finitegeom` materialization with the
  owning build-system lane; do not directly edit or publish its foreign tree
  without authority.
- [x] Verify that the public formal export contains the exact two semantic
  roots, their recursive closure, axiom facts, and content-addressed manifest,
  with no internal workflow artifacts.
- [x] Materialize two disposable Paper II standalone candidates from one
  immutable authoritative source commit and require byte identity.
- [x] Verify the standalone export manifest, force a clean manuscript build,
  replay all eight evidence bundles, reverify the manifest, and require a clean
  Git worktree.
- [x] Forward-synchronize the validated candidate into
  `~/src/math-papers/mds-css-transversal-groups` without rewriting its history.
- [x] Do not push, tag, publish, alter the DOI deposit, or submit unless the user
  separately authorizes that external action.

## 9. Closeout

- [x] Produce a locatored remediation report listing the exact semantic roots,
  terminal set, closure/manifest hashes, axiom results, guarded build run,
  paper-facts result, paper/evidence results, standalone commit, and all
  remaining manuscript-only/certificate/external boundaries.
- [x] State explicitly whether Paper II is manuscript-ready,
  formal-companion-ready, standalone-ready, and public-release-ready; do not
  collapse those states.
- [ ] Archive C859 and remove its live queue row only after every applicable
  checkbox is closed and no required work remains.
