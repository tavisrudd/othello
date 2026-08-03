# C857 — Paper IV Lean standards closure

**Lane:** `clebsch`

**Status:** queued after C834; required before C761 release authority

**Sequencing and scope (2026-08-03).** Run the closure audit against the post-C860-stage-1 Paper IV
closure, not the current one: that stage removes `CapGame.BuildGame` and the cap-game API from
`RelativeConicArcs.Gates.PassantCodeQ13`, shrinking what section D has to document. C857 must not
audit, document, or remediate any `ProjectiveCap` or `CapGame` module. It consumes the audited,
relocated shared projective-plane base that C860 delivers under `RelativeConicArcs`, whose
declarations are documented during the move. Any residual cap-game import still in the Paper IV
closure after C860's stages is a defect to report to C860, not to repair here. Details and the
measured closure deltas are in `notes/2026-08-03-c860-execution-design.md`.

## Governing standards

This task closes the complete gap list in
`notes/2026-08-02-c834-paper-iv-lean-standards-audit.md` against:

- `lean/AGENTS.md` for the formal-source, trust, documentation, naming, build, and axiom rules;
- `papers/style-guide.md` for reader-facing mathematical exposition and precise scholarly claims;
- `notes/research-reproducibility-conventions.md` for generated artifacts, manifests, replay, and
  independent verification; and
- `notes/task-lifecycle-conventions.md` for task and release-record handling.

C834 owns the proof-producing mathematical replacements. C857 consumes its completed formal API,
repairs every remaining standards defect, and proves that the resulting public release surface is
complete and rejecting. It must not weaken a theorem, relabel native execution as a certificate, or
duplicate C834's finite computations merely to satisfy a checklist.

## Frozen audit baseline

At allocation, the audit covers 190 project-owned Lean modules: 169 paper-local modules, ten
q=13-specific shared modules/gates, and eleven additional shared dependencies. The current public
gate closure contains 80 modules and 82 `native_decide` occurrences in 48 modules. The
q=13-specific layer has complete declaration-docstring coverage, while eight row-uniqueness leaves
lack module docs and the additional shared closure has 86 undocumented public theorems plus two
undocumented abbreviations.

The baseline is diagnostic, not an allowlist. C857 must regenerate the inventory from the final
import closure and fail if new files or declarations escape classification.

## Complete closure checklist

### A. Public theorem and statement identity

- [ ] Add one public aggregate theorem whose statement matches every clause of the frozen Paper IV
  main theorem: `[78,36,12]_2`, all 364 minimum words, intrinsic identification of all four
  families, spanning by every family, exact weighted-pair reconstruction, recovery of the full
  marked `PG(2,13)`, and the automorphism group.
- [ ] Give every clause an exact theorem-to-source row and an exact manuscript locator.
- [ ] Preserve explicit human or classical boundaries only where C834's approved architecture does
  so; do not describe those clauses as kernel checked.
- [ ] Verify statement identity mechanically where possible and review every remaining semantic
  correspondence by hand.

### B. Trust closure

- [ ] Remove every `native_decide` dependency from the aggregate's transitive project-local import
  closure, covering shared semantics, `MinimumWords`, `WeightTen`, `StructuralUpgrade`,
  `AssociationTransport`, `Automorphisms`, and `AssociationAlgebra`.
- [ ] Remove legacy native regression modules from the public import closure; retain them only as
  explicitly independent replay if they remain useful.
- [ ] Reject `sorry`, unsafe declarations, `implemented_by`, project-local axioms, trusted Python
  premises, opaque execution oracles, and declaration-local native-decision axioms.
- [ ] Permit only the ordinary foundational axioms allowed by `lean/AGENTS.md`, and list their exact
  occurrence in the frozen transcript.
- [ ] Check comments and README language against the actual trust route; in particular, resolve the
  mismatch between “independent regression” wording and public re-export of the old weight-ten
  shards.

### C. Axiom audit and release enforcement

- [ ] Make the public axiom-audit module cover the aggregate theorem and every release terminal.
- [ ] Capture the pinned toolchain's complete output in a tracked, normalized q=13 axiom transcript
  under `lean/verification`.
- [ ] Add a curated public module and theorem allowlist that excludes operational guides, dormant
  native replay, and implementation-only modules.
- [ ] Add a machine-readable formal theorem map, trust manifest, generated-artifact provenance map,
  and statement-identity record using the series-standard schemas.
- [ ] Add one paper-local `verify_release.py` that rejects transcript drift, forbidden axioms,
  missing or surplus theorem-map rows, unallowlisted public modules, stale hashes or byte counts,
  untracked generated files, and statement-identity drift.
- [ ] Ensure the verifier starts from the public aggregate rather than trusting a handwritten list
  of its transitive dependencies.

### D. Module and declaration documentation

- [ ] Add self-contained module docs to `MinimumWords/RowUniqueness/ResidueZero.lean` through
  `ResidueSix.lean`, stating each exact residue domain, enumerated extension domain, seven-shard
  coverage relation, and final trust mode.
- [ ] Add the analogous exact-domain and trust-boundary module doc to
  `MinimumWords/RowUniqueness/GeometricRows.lean`.
- [ ] Add non-redundant docstrings to the public theorems and abbreviations identified in the
  additional shared closure, prioritizing `RelativeConicArcs/Moments.lean` and
  `RelativeConicArcs/CodingBridge.lean`. `ProjectiveCap/PlaneTransitivity.lean` is removed from this
  item as of 2026-08-03: C860 relocates the shared content it supplies into the documented
  `RelativeConicArcs` base, and the remainder is cap-owned and out of the Paper IV closure.
- [ ] Re-run the declaration-docstring audit on the final transitive closure; every public
  scholarly theorem and every non-obvious public definition must be documented.
- [ ] Re-run the module-header audit and ensure every module explains its mathematical object,
  proof or computation mechanism, exact domain, and trust boundary.
- [ ] Remove task IDs, lane/session/agent language, private paths, temporary status words, novelty or
  priority claims, and repository-relative workflow prose from public Lean source.
- [ ] Check every strength-bearing declaration and module name against the theorem actually proved.

### E. External inputs and citations

- [ ] Replace “classical arc/tangent lemma” in the weight-eight module and shared gate by a stable
  pinpoint citation naming the source, exact theorem or proposition, and page or section.
- [ ] Audit every other external or classical input in the final closure for the same citation
  precision.
- [ ] Put bibliography-heavy detail in a stable claim/trust ledger when repeating it in Lean would
  harm readability, and link the Lean boundary to the exact ledger row.
- [ ] Verify that no Lean comment makes an unsupported novelty, priority, or attribution claim.

### F. Generated certificates and reproducibility

- [ ] Identify every generated Lean or data file locally with its generator, schema, exact semantic
  domain, and logical trust boundary.
- [ ] Track deterministic generators and manifests with paths, byte counts, SHA-256 hashes, schema
  versions, and complete output inventories.
- [ ] Make every generator's `--check` mode reproduce its outputs byte for byte and reject obsolete
  or surplus outputs.
- [ ] Prove in Lean that generated transition, coverage, and disjointness data imply the public
  semantic statements; Python assertions carry no logical authority.
- [ ] Retain an independently specified replay for computational evidence where the standards call
  for one, and document that it is a cross-check rather than a proof premise.

### G. Build, source-hygiene, and cold-checkout gates

- [ ] Build every expensive certificate through `lean/scripts/lean-build-queue.py` with the measured
  resource profile; do not run Lean or Lake manually.
- [ ] Pass focused builds for every new leaf, then the public aggregate and axiom audit, under the
  pinned toolchain.
- [ ] Run scoped source scans over the complete final closure for forbidden axioms, native
  evaluation, placeholders, internal paths, workflow identifiers, and undocumented declarations.
- [ ] Run all deterministic generator checks, independent replays, evidence-manifest checks, and the
  single release verifier.
- [ ] Validate from a clean public checkout with only allowlisted files and immutable dependency
  pins; no local sibling path or untracked artifact may be required.
- [ ] Freeze the successful commands, toolchain identity, transcript, hashes, resource envelope, and
  clean-checkout result in the release evidence.

## Acceptance

C857 closes only when every checkbox above has evidence, the final audit reports no unresolved
standards gap, the public aggregate's actual axiom closure contains no native-evaluation or
project-local axiom, and the paper-local release verifier rejects each deliberately perturbed trust,
allowlist, transcript, theorem-map, and generated-artifact fixture. C761 remains blocked until this
task and C834 are both archived complete.

