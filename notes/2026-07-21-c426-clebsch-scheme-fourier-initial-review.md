# C426 q=11 scheme Fourier development — independent initial review

**Date:** 2026-07-21

**Reviewer:** Codex subagent `/root/c426_initial_review`, launched explicitly by the user

**Reviewed worktree base:** `b9d8f661aef6` plus the uncommitted C426 artifact listed below

**Verdict:** **NO-GO** for the mandatory core gate and for any full-trust scheme-level claim

This is the required initial, pre-fix referee review. I made no change to the implementation,
generated data, generator, gate, or implementer report. The sole review-owned change is this file.
I did not run a Lean elaboration or generator replay: the implementer report already records that
the theorem module does not elaborate, and a build or generation run was unnecessary to establish
the blocking statement and trust-boundary findings below. Final validation, trace-current gate
evidence, hashes, and axiom audits therefore remain obligations of the post-review implementation
and final review.

## Material reviewed

- `lean/RelativeConicArcs/ClebschSchemeFourierData.lean` (generated definitions)
- `lean/RelativeConicArcs/ClebschSchemeFourier.lean` (all declarations and prose)
- `lean/RelativeConicArcs/Gates/ClebschSchemeFourier.lean` (import-only gate and prose)
- `notes/2026-07-20-c426-clebsch-scheme-fourier-lean.py`
- `notes/2026-07-20-c426-clebsch-scheme-fourier-lean.json`
- `notes/2026-07-20-c426-clebsch-scheme-fourier-lean.sha256`
- `notes/2026-07-20-c426-clebsch-scheme-fourier-lean.md`
- the imported boundary
  `lean/RelativeConicArcs/ClebschGatewayA5FourierPhase.lean`, especially
  `CertifiedPhaseProfile`, `certifiedPhaseProfile`, and its module-level trust disclosure

The JSON records eight relation labels, 133 classifier rows, and 126 witness rows. Its provenance
pins the orbit-construction hash and the frozen scheme-certificate hash. Those counts and hashes
are identity/provenance evidence, not by themselves soundness theorems for the geometric meanings
assigned to the tables.

## JC-1 disposition: choose repair route 2

**Selected route: 2 — keep the missing geometric rank/profile premise external and prevent the
literal gateway row from inheriting a full-trust label.**

The imported gateway is unusually explicit: `CertifiedPhaseProfile` carries no orbit witnesses or
checker proof, `certifiedPhaseProfile` is a literal external table, and the module says that the
legacy `certified*` names certify arithmetic only. Consequently
`schemeRank_eq_certified` proves only that the local literal `8` equals another literal `8`. It
cannot certify the rank of the reduced projective `A5` action. The gate currently calls the latter
quantity “the certified rank” and presents the bridge among the kernel-checked scheme terminals;
that contradicts the imported module's own boundary.

Route 1 would require a new sound checker connecting the action, scalar-line orbit partition,
relation coverage, and rank to the profile. That is a separate nontrivial finite formalization,
outside C426's owned files and unnecessary for the mandatory table consequences. The C426 core is
logically independent of the gateway declaration, so route 2 is both the narrowest honest repair
and the only proportionate one.

Required implementation of route 2:

1. Remove the gateway import, `schemeRank_eq_certified`, and the corresponding gate claim unless a
   genuinely semantic premise is introduced in a theorem type.
2. Record in the report/C320 delta that identification of these frozen relations with the q=11
   geometric orbit scheme, including its rank, is an exact external replay/certificate boundary.
3. Do not introduce a proposition whose definition is merely the desired literal equality and
   call the resulting implication conditional. A retained conditional theorem must quantify over
   an independently meaningful action/orbit/coverage premise; otherwise omission is clearer.

This choice leaves the abstract character-sum theorem and kernel evaluation of the frozen tables
available. It narrows only the geometric interpretation that the present types do not express.

## Blocking findings and required fixes

### R1 — The named gate is not green

The implementer records unresolved elaboration errors in `characterSum`, both matrix products, two
open-variable finite checks, and the primitivity checks. Therefore no mandatory terminal or gate
has current validation evidence. Repair every error, measure the primitivity computation, shard it
across module boundaries if required by the Lean guide, and obtain a trace-current build of
`RelativeConicArcs.Gates.ClebschSchemeFourier` before requesting the final review. A partial green
data module is not a gate result.

### R2 — `relationOf` has a failure-as-identity path that makes the witness check inadequate

`relationOf` returns relation `0` both for the zero vector and whenever `List.find?` fails, via
`Option.elim 0`. For a nonzero witness sum, classifier lookup failure therefore satisfies
“relation outside the selected nonidentity relations.” The additional nonzero conjunct does not
close this hole. Neither classifier coverage nor successful lookup is a theorem in the module.

Use an option-valued lookup, or otherwise make lookup success explicit, and have the 126-witness
terminal prove successful classification of `x`, `y`, and `x+y` as well as the membership and
nonmembership claims. A global kernel-checked completeness/uniqueness theorem for the 133
normalized projective representatives is an acceptable stronger repair. Default values must not
be able to discharge a negative classification claim.

### R3 — The formal connection from the character sum to the frozen eigenmatrix is absent

`characterSum` is a genuine abstract cyclotomic identity. Separately,
`eigenmatrix_hyperplane_reconstruction` reduces a literal integer table equality. No Lean theorem
uses `characterSum` to derive a scalar-line contribution or connects such contributions to the
entries called `firstEigenmatrix`. Thus the module prose and gate say “from which the eigenvalues
arise” and “character-sum reconstruction,” but the formal dependency graph has two disconnected
branches.

Add a general scalar-line contribution theorem derived from `characterSum` (with the exact dot
product/orthogonality and line-cardinality hypotheses), and state precisely that applying it to the
frozen `z` and `ell` data yields the displayed formula. The last identification with the actual
orbit scheme may remain external under the declared mixed boundary, but the advertised in-kernel
character-sum-to-formula implication must be present. If that theorem is not added, rename and
relabel the table check so it is not represented as a formal reconstruction from `characterSum`.

### R4 — Scheme-level prose is stronger than the theorem types

There is no association-scheme object, group action, orbit-partition predicate, eigenmatrix
soundness predicate, or formal definition of primitivity in the module. The current kernel facts
are an abstract character sum and equalities/classifications about frozen lists. In particular,
`eigenmatrix_self_dual` proves equality of two definitions populated by the same table;
`eigenmatrix_dual_product` checks a concrete product; and the primitivity terminals check witness
records. These are useful certificate checks, but they do not by their types prove that the reduced
projective icosahedral action “forms a primitive translation association scheme” or that the lists
are its `P` and `Q`.

Keep the mixed-verification design, but make every header, docstring, gate sentence, report row,
and C320 row decompose the result accurately:

- full-trust Lean: the abstract character identity and exact consequences of the frozen literals;
- exact external replay/certificate: orbit/action construction, exhaustive relation coverage,
  identification of `P`, `Q`, `z`, and labels with that scheme, and the criterion transferring the
  checked relation-union certificate to the named geometric scheme unless formalized explicitly.

The gate must not describe the named geometric scheme itself as kernel-checked. If a scheme-level
full-trust exit remains mandatory, it needs meaningful semantic definitions and soundness theorems;
prose cannot supply that bridge.

### R5 — The generator contains a false and circular subgroup assertion

The witness-generation comment says existence is guaranteed because only `{0}` and all of
`F_11^3` are additive subgroups. This is false: the additive group of a three-dimensional vector
space has many proper nonzero subgroups. The relevant conclusion is that no proper union of these
specific orbit relations, together with zero, is a subgroup, and that is exactly what the exhaustive
witness search is intended to establish. Remove the claimed guarantee and describe the search as
an exhaustive test whose successful witness for every mask establishes nonclosure. Regenerate the
generated outputs and hashes if generator bytes or generated prose change.

### R6 — Referee-facing generated-artifact provenance violates the Lean guide

The generated header says a tracked generator and pinned construction/certificate exist but does
not name an exact admissible repository-relative artifact. Conversely, the actual load-bearing
generator and JSON live under internal `notes/` paths and encode C426, C341, and C372 workflow IDs
in filenames and provenance. The Lean guide expressly includes generators and certificates in the
referee-facing artifact, forbids task IDs and internal-note reverse references there, and requires
generated sources to name the tracked generator/schema and admissible enduring inputs.

Move or expose the load-bearing generator, schema/data, and required provenance under stable
workflow-neutral verification paths, or obtain an owner-approved packaging design that supplies
equivalent enduring artifacts without the internal names. Update the generated header to name the
exact generator/schema and explain each input's trust role. The dated C426 report may continue to
point forward to those artifacts. Do not silently treat a task note as an enduring verifier.

This may require coordination because the currently pinned C341/C372 inputs are outside C426's
edit ownership. Coordination is preferable to copying or renaming foreign evidence without
authority.

### R7 — Matrix dimensions and normalization constants need explicit checked bindings

The public API defines `schemeRank = 8` and `schemeOrder = 1331`, but matrix theorems hard-code
`8` and `1331`; no terminal states that every row of `P`, `Q`, and `z` has length `schemeRank`, and
`schemeOrder` is unused. Add checked shape theorems and formulate product/normalization statements
through `schemeRank` and `schemeOrder` (with the necessary integer coercion). This prevents the
defaulting `entry` and list-matrix implementation from masking ragged-data or constant drift and
makes the intended normalization explicit in theorem types.

### R8 — The gate currently repeats the JC-1 overclaim and lacks a trust decomposition

The import-only gate advertises a primitive Fourier-self-dual association scheme and a bridge to
the “certified rank.” Under route 2, remove the rank bridge and state that the gate re-exports
kernel checks of frozen data, while the geometric identification is external. Preserve its good
negative boundary for the intersection tensor, Krein equality, fusion census, separability, and
automorphism groups.

### R9 — The durable implementation report is not yet an exit report

Its current paused status, open-error list, deferred JC-1, unchecked closing checklist, absent
axiom outputs, absent pinned final commit, and absent C320 rows correctly describe work in progress.
Before final review it must incorporate this report's dispositions; give exact final theorem types
and fully qualified names; distinguish every formal and external component; record replay command,
hashes and byte counts after the final regeneration; give trace-current gate evidence; include the
complete `#print axioms` audit; and supply one C320 ledger row per claim plus the verify-all delta.

## Findings that do not require expansion of scope

- Keeping the 512-entry intersection tensor/Krein equality and the 877-partition fusion census as
  exact external replay/certificate results is approved. No optional checker leaf should be started
  during this repair pass.
- The 133-line representation plus 126 mask-indexed witnesses is a reasonable compact certificate
  architecture once lookup failure is impossible and elaboration is measured.
- The cyclic-shift proof strategy for the root sum is mathematically appropriate; its current
  elaboration errors are mechanical, not a reason to expand the Mathlib dependency closure.
- Equality of the frozen `P` and `Q` tables, their product, and row-zero/valency equality are
  meaningful kernel checks after the matrix implementation and dimensions are green. The review
  objection is to the unformalized geometric interpretation, not to those literal equalities.
- The optional exclusions in the gate are appropriately explicit and should remain.

## Required consolidated repair order

1. Apply JC-1 route 2 and narrow the module/gate/report trust language.
2. Remove the `relationOf` default-value hole and add the required classifier-success check.
3. Add or honestly narrow the character-sum-to-eigenvalue connection.
4. Correct the generator's subgroup statement and resolve the enduring-artifact provenance issue
   without editing foreign inputs unilaterally.
5. Repair the six recorded elaboration failures, add shape/normalization bindings, and measure the
   primitivity check; shard only if the measured profile requires it.
6. Regenerate atomically, run `--check`, build the exact import-only gate through the prescribed
   Lean runner, and audit axioms for every claimed terminal.
7. Finish the implementation report, judgment calls, statement-adequacy material, exclusions, and
   C320 ledger delta; then stop and ask the user to launch the post-fix review.

## Review gate conclusion

The mathematical data pipeline looks plausible and the selected finite-certificate architecture is
salvageable, but the artifact is not presently an adequate full-trust exit. The immediate NO-GO is
not just the six known elaboration errors: the gateway rank bridge is semantically unsupported, a
failed classifier lookup can masquerade as relation zero, the advertised character-sum connection
is absent from the theorem dependency graph, and the referee-facing provenance does not meet the
repository's enduring-artifact rules. All are repairable without attempting the optional tensor or
fusion leaves.

**Post-fix review status:** required; only a user-launched independent final review may issue GO.
