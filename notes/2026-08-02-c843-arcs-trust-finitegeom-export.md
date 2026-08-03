# C843 — arcs Lean trust and `finitegeom` export closure

**Lane**: `relconic`

**Status:** QUEUED

**Date:** 2026-08-02

## Objective

Publish an honest, independently replayable human-scale Lean companion for
*Arcs complete outside a prescribed conic* in `~/src/lean/finitegeom`.  Use the
Clebsch Paper I package as the structural model: one narrow import-only paper
gate, a machine-readable area manifest with explicit terminals and expected
axioms, a short prose trust boundary, an axiom-audit entry point, content
manifests for the source and exported closures, and documented replay commands.

The task is trust and release engineering.  It must not silently strengthen a
mathematical claim, turn an exhaustive computation into a Lean theorem, or
fold unrelated `RelativeConicArcs` work into the public paper boundary.

## Current state and exact gaps

The monorepo already contains and builds the mathematical Lean sources needed
for the two paper additions:

- `RelativeConicArcs.Gates.C637Witnesses` audits the normalization identities,
  three checked witnesses, upper bounds
  `rhoC_ZMod13_le_eight`, `rhoC_ZMod17_le_nine`, and
  `rhoC_ZMod19_le_ten`, plus ordinary completeness of the q=19 witness.  It
  deliberately does not formalize the exhaustive lower classifications.
- `RelativeConicArcs.Gates.MatchingPackingDefect` audits the leave-completion
  theorem, the matching-packing deficiency comparison, the impossibility of a
  one-block-short packing, and the resulting two-unit defect implication.

Both gates are named in `lean/trust/areas/relconic.toml`, but that broad area is
not an acceptable paper export gate: it owns the whole shared tree and its
fresh trust-spine check currently fails on unrelated missing facts, unreachable
modules, and external-input anchors.  In addition:

1. `lean/RelativeConicArcs/TRUST.md` records the C637 boundary but does not give
   the matching-packing result its own theorem-map entry.
2. Neither dedicated gate has a generated trust-facts JSON artifact.
3. `~/src/lean/finitegeom` predates both gates and all supporting modules.
4. The standalone arcs manifest and human gate cover the older paper surface
   only; they do not name the new terminals.
5. `lean/scripts/external-trust-exports.py` generates summary projections.  It
   is not a source-tree synchronizer and therefore cannot perform this export.

The destination's existing `ClebschRigidityHuman` package is the model, not a
file-for-file source: it uses a paper-local gate and area rather than relying
on the broad shared `relconic` registry, explicitly lists every terminal and
expected axiom set, separates human theory from downstream certificate data,
and records both immutable source and transformed target closures.

## Claim boundary to preserve

The public trust documentation must distinguish all three evidence classes:

1. **Lean theorem:** the matching-packing nonexistence hypothesis forces block
   deficiency at least two and hence the stated quantitative scaled-defect
   lower bound.  The exact exported terminal names and their actual
   `#print axioms` results are authoritative.
2. **Lean upper certificate:** the q=13, q=17, and q=19 witnesses give only the
   upper bounds 8, 9, and 10; q=19 ordinary completeness is also kernel checked.
3. **External exhaustive classification:** the lower bounds, and therefore the
   exact equalities `rho_C(13)=8`, `rho_C(17)=9`, and `rho_C(19)=10`, remain
   computational results outside Lean.  The public manifest must not list
   equality declarations that do not exist.

The restored Korchmaros--Nagy--Szonyi priority citation is manuscript prose,
not a Lean terminal.  The proposed `(k,n)` generalization, nine-point matching
design experiment, q=11 affine search, and coding-theory reconstruction audit
are research frontiers and are explicitly outside C843.

## Work package

### 1. Freeze the authoritative monorepo boundary

- Add a narrow `RelativeConicArcs.Gates.ArcsCompleteOutsideConicHuman` gate in
  the monorepo, derived from the existing standalone human gate but importing
  the new C637 and matching-packing human modules.
- Print every paper-facing terminal explicitly.  Do not rely on imported
  dedicated gates to make terminal coverage implicit.
- Keep generated q16 transition, row, and leaf families out of this gate.  The
  human package may retain the existing two-sided q16 bound and checker
  semantics; the separate `finitegeom-q16-certificates` package remains the
  owner of the exact q16 exhaustive theorem.
- Add or refresh the paper-local area manifest, prose trust document, and
  axiom-audit module.  The narrow area must own only its import-only gate and
  use closure coverage, matching the Clebsch Paper I layout.
- Add the matching-packing theorem family to
  `lean/RelativeConicArcs/TRUST.md`; retain the C637 paragraph's explicit
  upper-versus-lower evidence split.

### 2. Generate and check trust evidence

- Build the paper-human gate and the two dedicated gates through the guarded
  Lean entry point required by `lean/AGENTS.md`.
- Extract fresh facts for the narrow paper area and dedicated units.  Record
  the exact terminal set and observed axioms; expected sets must be copied from
  extraction, not assumed from nearby theorems.
- Make the paper-local trust check independently green.  Do not claim that the
  broad `relconic` portfolio is green, and do not repair unrelated portfolio
  findings under C843.
- Generate deterministic source-closure and target-closure manifests using the
  same schema as Clebsch Paper I.  Each must content-address every shipped Lean
  module and disclose deliberate source-to-target transformations.

### 3. Forward export to `~/src/lean/finitegeom`

- Treat the monorepo as authoritative and preserve the standalone repository's
  existing history.  Apply the update as an ordinary forward commit; do not
  reinitialize, overwrite, or merge changes back into the monorepo.
- Copy only the reviewed human closure and required shared modules.  Exclude
  generated q16 data and every unrelated research gate.
- Update the existing standalone files rather than creating a second arcs
  trust surface:
  `RelativeConicArcs/Gates/ArcsCompleteOutsideConicHuman.lean`,
  `trust/areas/arcs_complete_outside_conic_human.toml`,
  `trust/ARCS_COMPLETE_OUTSIDE_CONIC.md`, the axiom-audit module, both content
  manifests, and the README replay list.
- Document any target-only edit exactly.  Permitted examples are removal of
  private workflow references or replacement of the monorepo's exact-q16
  aggregate by the human two-sided boundary.  No declaration-changing rewrite
  may be described as prose-only.

### 4. Validate the exported package

The task is complete only when all of the following pass at the recorded
commits:

- guarded monorepo builds of the paper-human, C637-witness, and
  matching-packing gates;
- the paper-local trust extraction/check with no missing facts, absent
  terminals, unexpected axioms, stale generated regions, or closure drift;
- source-manifest verification before copying and target-manifest verification
  after copying;
- guarded standalone build of
  `RelativeConicArcs.Gates.ArcsCompleteOutsideConicHuman`;
- standalone axiom-audit elaboration, with every listed terminal matching its
  manifest axiom set;
- a bounded source/target diff showing that every difference is one of the
  documented target-only transformations;
- a negative closure check showing that no generated q16 transition, row, or
  leaf module entered the human package; and
- clean scoped Git status followed by separate forward commits in the
  monorepo and `~/src/lean/finitegeom`.

The completion report must record both commit IDs, exact guarded replay
commands, gate/facts hashes, source- and target-manifest hashes, the exported
module count, the terminal count, observed axiom sets, and the explicit list of
external claims that Lean does not certify.

## Expected task-owned paths

Monorepo authority:

- `notes/2026-08-02-c843-arcs-trust-finitegeom-export.md`;
- `notes/2026-07-07-codex-task-queue.md` and the relconic handoff/archive for
  lifecycle updates;
- `lean/RelativeConicArcs/Gates/ArcsCompleteOutsideConicHuman.lean`;
- `lean/RelativeConicArcs/Gates/C637Witnesses.lean` and
  `lean/RelativeConicArcs/Gates/MatchingPackingDefect.lean` only if extraction
  exposes a genuine gate defect;
- the human closure modules required by those gates only when an exportability
  issue is demonstrated;
- `lean/RelativeConicArcs/TRUST.md`;
- `lean/trust/areas/arcs_complete_outside_conic_human.toml` and the minimal
  portfolio registration needed for its independent check;
- `lean/trust/ARCS_COMPLETE_OUTSIDE_CONIC.md`;
- `lean/trust/ArcsCompleteOutsideConicHumanAxiomAudit.lean`;
- the corresponding generated facts, source manifest, target manifest, and
  deterministic external trust summaries; and
- `lean/README.md` only if the monorepo documents paper-local replay commands
  there.

Standalone forward export:

- the reviewed `RelativeConicArcs` human closure;
- `RelativeConicArcs/Gates/ArcsCompleteOutsideConicHuman.lean`;
- `trust/areas/arcs_complete_outside_conic_human.toml`;
- `trust/ARCS_COMPLETE_OUTSIDE_CONIC.md`;
- `trust/ArcsCompleteOutsideConicHumanAxiomAudit.lean`;
- `trust/source-manifests/arcs_complete_outside_conic_human.json`;
- `trust/manifests/arcs_complete_outside_conic_human.json`;
- generated paper-local trust facts/summaries if the standalone trust schema
  requires them; and
- `README.md`, `lakefile.toml`, and declaration/provenance inventories only to
  the extent required by the reviewed closure.

Any newly required path must be added to the live handoff before editing it.
Foreign dirty files in either repository remain untouched.

## Stop conditions

Stop and report rather than widening the task if:

- either new paper claim requires an axiom beyond the actual existing
  standard axiom boundary;
- the human closure unexpectedly depends on generated q16 data;
- synchronizing a required module would pull in an unrelated unpublished
  research closure;
- a source/target declaration differs for a reason not covered by a reviewed
  target-only transformation; or
- standalone history cannot be preserved by an ordinary forward commit.

## Completion artifact

Replace this queued plan with a dated results section containing the immutable
source and target commit IDs, exact replay transcript summaries, hashes,
counts, axiom table, disclosed exclusions, and a concise explanation of every
source-to-target transformation.  Then archive C843 exactly once, remove it
from the live queue, and refresh the relconic handoff in the same coherent
completion commit.
