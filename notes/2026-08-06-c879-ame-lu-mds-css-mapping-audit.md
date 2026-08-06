# C879 — audit of the paper-extraction plan and module-name mapping for AME--LU and MDS--CSS

**Lane:** `build-sys` · **Date:** 2026-08-06 · **Status:** audit complete; corrections proposed, none applied

Scope: `notes/2026-08-06-c879-finitegeom-paper-extraction-plan.md` and
`notes/2026-08-06-c879-module-name-mapping.json`, restricted to the `ame_lu` and
`mds_css_transversal` groups and everything they touch (the shared `amelu_api` group, the
beyond-four PRS balanced adapter that consumes them, and the plan steps that order them).

Read-only. No Lean elaboration, no build, no export, no source move.

## Verdict

The two papers' entries are the weakest part of the mapping. Sixteen of the fifty-six AME--LU
library modules are assigned to no group at all, one trust-declared AME--LU gate is missing from the
mapping entirely, and the MDS--CSS paper's dependency on the AME--LU paper — nine direct gate
imports, already acknowledged in `lean/trust/papers.toml` — is undeclared. Separately, everything
the mapping does assign to `Shared.AMELU` was chosen by transitive reachability from the balanced
quantum gate, which leaves `Papers/ame_lu` holding no mathematics and contradicts the plan's own
rule against closure-as-ownership. The plan's step ordering for this pair is self-contradictory.
Nothing is broken in the tree: the plan authorizes no source move, so these are corrections to a
planning artifact made before it is executed.

## Method and replay

```text
python3 notes/scripts/c879_module_closure.py
```

The script computes each gate's project-owned transitive import closure directly from the Lean
sources (regex import scan, no Lake, no elaboration) and compares it against the mapping's group
assignments. Inputs: the mapping JSON and `lean/` at `8e3cb3c0`. Cross-checks used
`lean/trust/areas/relconic.toml`, `lean/trust/papers.toml`, `lean/trust/export/ame_lu.toml`,
`lean/trust/export/mds_css_transversal_groups.toml`, and the sealed areas in the finitegeom repo.

Measured closures (project-owned modules; foreign imports dropped):

| Gate                                              | Closure | AME--LU library modules | Imported gates | Unassigned |
|---------------------------------------------------|--------:|------------------------:|---------------:|-----------:|
| `RelativeConicArcs.Gates.AMELUAggregate`           |      67 |                      49 |              7 |          9 |
| `RelativeConicArcs.Gates.MDSCSSTransversalGeometry`|      66 |                      46 |              9 |          6 |
| `RelativeConicArcs.Gates.AMELUTwoUniformRigidity`  |       8 |                       7 |              0 |          7 |
| `RelativeConicArcs.Gates.PRSBalancedQuantumExtension` |   52 |                      37 |              0 |          0 |

Both paper closures use the same shared modules: five projective (`Arc`, `Plane`,
`PlaneTransitivity`, `Projective`, `ProjectiveBridge`), three coding (`Code`, `CodingBridge`,
`SyndromeGeometry`), two incidence (`Defect`, `Moments`).

## Findings

### 1. Sixteen AME--LU modules are assigned to nothing (blocking)

`shared_groups.amelu_api` lists forty legacy modules: exactly the thirty-seven the balanced quantum
gate reaches, plus `ExtensionFieldPencil`, `SyndromeGeometry`, and `TransportDivisor`. That part of
the mapping's own note is accurate. But the AME--LU aggregate's closure holds forty-nine AME--LU
modules and the MDS--CSS closure holds forty-six, and `RelativeConicArcs/AMELU/` holds fifty-six.
The residue appears in no shared group, in no `paper_private_modules` list, and in no exclusion
record:

- shared by both papers (6): `AutomorphismExactSequence`, `DiagonalIsoduality`, `FourCopyContraction`,
  `MarginalMoment`, `NonabelianExtensionInvariant`, `PartyExtensionSplitting`;
- reached only by the AME--LU aggregate (3): `HolonomyCentralizer`, `StabilizerAMERigidity`,
  `StabilizerAMESupport`;
- reached only by the two-uniform rigidity gate (7): `ApproximateSymmetryDecomposition`,
  `LocalGeneratorDecomposition`, `ProductUnitaryExponential`, `SiteOperators`,
  `TwoUniformDiscreteness`, `TwoUniformIsometry`, `TwoUniformProductSymmetry`.

The import-firewall chunk (C879.4) rejects roots outside the manifest closure, so these modules
would be reported as unowned on the checker's first real run.

### 2. A trust-declared AME--LU gate is missing from the mapping (blocking)

`RelativeConicArcs.Gates.AMELUTwoUniformRigidity` and its `...Axioms` sibling are declared in
`lean/trust/areas/relconic.toml` with their own terminal set, but have no export configuration under
`lean/trust/export/` and no entry anywhere in the mapping. The cause is a plan defect, not an
oversight: plan step 2 and chunk C879.2 derive the ownership graph "directly from the C864 area
manifests", and only exported areas have manifests, so any trust-declared gate that was never
exported is invisible to that derivation.

Fix both layers. The plan should derive ownership from the union of the trust-area gate
declarations and the export configurations. The mapping should give every trust-declared gate with
no export configuration an explicit disposition — the PRS group already does exactly this with
`not_in_current_paper_closure` and `unmapped_internal_modules`; the AME--LU family has no
equivalent.

### 3. The MDS--CSS to AME--LU paper dependency is undeclared (blocking)

The MDS--CSS gate directly imports nine AME--LU gate modules: `AMELUDefinitions`, `AMELUDictionary`,
`AMELUExtensionFieldPencil`, `AMELULogicalPhaseFourCopy`, `AMELUMarginalMoment`,
`AMELUPartyExtensionSplitting`, `AMELUPencilClassification`, `AMELUStabilizerDictionary`,
`AMELUTransportDivisor`. `lean/trust/papers.toml` already records the statement-level version of
this: the MDS--CSS entry says the companion rigidity paper owns the imported encoder-conversion and
equal-phase rigidity results that appear there.

The mapping models none of it. The `mds_css_transversal` group carries only `imports_shared`; the
only cross-paper dependency field in the file belongs to `beyond4_prs`. Two consequences:

- C879.4's shippable state is "existing tree passes", and it will not: the tree contains an
  undeclared paper-to-paper import that the enforcement rule is written to reject.
- None of those nine gates has a target name. The `ame_lu` group's `target_roots` are only
  `PaperInterface` and `Verification.AxiomAudit`, and the `unmapped_legacy_roles` patterns
  (`*Trust`, `*Human`, `*Additions`, `*Aggregate`, `*Axioms`) do not match them. A rename would
  leave MDS--CSS importing modules that no longer exist.

### 4. Both papers under-declare their shared dependencies (correctness)

`ame_lu` declares `split_shared_into = ["Shared.AMELU", "Shared.Coding"]` but its closure also uses
`Shared.Projective` and `Shared.Incidence`. `mds_css_transversal` declares `Shared.AMELU`,
`Shared.Coding`, `Shared.Projective` and omits `Shared.Incidence`. Both must list all four.

### 5. `AMEStabilizerRigidity` does not exist (correctness)

`ame_lu.legacy_roots_external_or_removed` names `RelativeConicArcs.Gates.AMEStabilizerRigidity` and
`...AMEStabilizerRigidityAxioms`. Neither name appears at any path in this repository's history
across all refs, nor anywhere in the finitegeom repo. The nearest live name is the library module
`RelativeConicArcs.AMELU.StabilizerAMERigidity`, which the AME--LU aggregate imports and which is
one of the three unassigned AME--LU-private modules in finding 1. Delete the entry, or restate it
against the module that actually exists.

### 6. Transitive closure was used as ownership, so `Papers/ame_lu` holds no mathematics (design)

Membership in `Shared.AMELU` was decided by what the balanced quantum gate reaches. That is a
reachability set, not an API: it pulls in deep rigidity internals because the adapter transitively
touches them. The result is that all forty modules become a shared library while the `ame_lu` paper
group carries no `paper_private_modules` at all — unlike `arcs_complete_outside_conic`, which has
two. The AME--LU paper would extract as a `PaperInterface` and an axiom audit over a shared library
containing its entire subject.

This contradicts the plan twice over: step 2 says to treat an area manifest as an export boundary
rather than proof of declaration-level ownership, and the red-team list says shared code must
contain no paper-specific results. Recommended shape: `Shared.AMELU` is the declaration-level
surface the balanced adapter and MDS--CSS actually use; the rigidity results (`LURigidity`,
`GenericLURigidity`, `MarginalAxisRigidity`, `StabilizerAMERigidity`, `StabilizerAMESupport`,
`HolonomyCentralizer`) stay in `Papers/ame_lu` unless declaration-level review shows genuine reuse.
That review is plan step 3 and has not been run for this family.

### 7. `DiagonalIsoduality` is a published paper's headline object (design)

It sits in both closures, so an "in two closures, therefore shared" rule sends it to
`Shared.AMELU`. It is the title object of *Diagonal Isoduality and Transversal Clifford Groups of
MDS--CSS Codes* (DOI 10.5281/zenodo.21766797). Decide explicitly rather than by rule: either it
stays in `Papers/mds_css_transversal_groups` and AME--LU consumes it through a declared adapter, or
the mapping states why it is a reusable API. The same question applies to the other five modules
shared by the two closures.

Related: renaming touches a published surface. Both areas are sealed in the finitegeom repo with
`RelativeConicArcs.*` module names inside `trust/areas/ame_lu.toml`,
`trust/areas/mds_css_transversal_groups.toml`, `trust/AME_LU.md`,
`trust/MDS_CSS_TRANSVERSAL_GROUPS.md`, and the two axiom-audit files, and the MDS--CSS artifact is
already published under a DOI. The mapping freezes the q11 and q16 certificate repositories against
renaming but takes no position on an already-released paper artifact.

### 8. The plan's ordering for this pair is self-contradictory (plan)

Step 9 extracts MDS--CSS "after the AME--LU API is frozen". Step 10 freezes the arcs and AME--LU
shared APIs last, after every leaf paper. Both the MDS--CSS extraction and the PRS balanced adapter
wait on that freeze, so it is a mid-sequence prerequisite, not the final act. Restate step 10 as
freezing the arcs and AME--LU *public APIs* before extracting their downstream consumers, while
moving their sources last.

### 9. The red team omits the defect class the MDS--CSS adoption itself caused (plan)

The build-sys handoff records it: an area export can byte-identically replace a shared base module
and delete declarations that consumers outside its closure depend on, leaving no dangling import and
passing every gate. The MDS--CSS transversal-group adoption did this on 2026-08-03. The plan's red
team covers namespace moves breaking seals and `open`-reached declarations, but not this. Add the
mitigation: any chunk replacing a module that another area also exports must diff the declaration
set, not only bytes and imports.

### 10. The schema is uneven enough that a checker cannot consume it (schema)

Across the twelve paper groups: `split_shared_into` appears in nine, `imports_shared` in two, and
`paper_private_modules` in one. `mds_css_transversal` is one of three groups with no
`split_shared_into`, and it is not obvious whether `imports_shared` means the same thing. Two
further defects: both `RelativeConicArcs.Gates.PRSBalancedQuantumExtension` and
`RelativeConicArcs.PRSBalancedQuantumExtension` map to the single target
`TavisRuddFiniteGeom.Papers.Beyond4PRS.QuantumExtension` — a two-into-one collision in the adapter
that consumes AME--LU; and `SyndromeGeometry` is a leaf name in both `Shared.Coding` and
`Shared.AMELU`, which is fine as module paths but is an `open`-collision hazard the plan's own red
team warns about.

### 11. No axiom-expectation field (schema gap)

The plan's first acceptance gate and its per-paper manifest both require axiom expectations, and
this pair has live history there: five AME--LU terminals were discharged by native evaluation, that
reached the MDS--CSS area, and the three underlying marginal counts were reproved by kernel
reduction. The mapping has no slot for axiom expectations, so a rename can carry a terminal across
without its evaluation-axiom status moving with it.

## What checked out

- Filesystem aliases are exact: `papers/ame_lu` and `papers/mds_css_transversal_groups` both exist
  under those names, as `naming.filesystem_aliases_are_exact` asserts.
- `authority.source_commit` `f8447f74` is an ancestor of `HEAD`, and no file under
  `lean/RelativeConicArcs/AMELU` or `lean/RelativeConicArcs/Gates` has changed since it. The map is
  current against the tree it names.
- The plan's counts for the balanced quantum branch are exact: 52 project-owned modules, 53 with the
  audit, 37 of them AME--LU.
- The mapping's claim that three modules beyond the balanced closure are shared by the AME--LU and
  MDS--CSS closures is exactly right, and they are `ExtensionFieldPencil`, `SyndromeGeometry`, and
  `TransportDivisor`.
- Both areas have tracked export configurations under `lean/trust/export/` and are sealed in the
  finitegeom repo, so the C864 substrate the plan depends on exists for this pair.

## Recommended correction order

Each item is metadata-only and needs no Lean elaboration.

1. Add the six shared-with-MDS modules and the three AME--LU-private modules to the mapping, with
   `paper_private_modules` on `ame_lu` (findings 1 and 6).
2. Add a disposition record for the two-uniform rigidity gate and its seven modules, modelled on the
   PRS `not_in_current_paper_closure` block (finding 2).
3. Declare the MDS--CSS to AME--LU paper dependency and give the nine imported AME--LU gates target
   names, or record them as remaining central until the adapter exists (finding 3).
4. Correct both papers' shared dependency lists and drop or restate the `AMEStabilizerRigidity`
   entry (findings 4 and 5).
5. Normalize the paper-group schema on one dependency key, fix the `QuantumExtension` collision, and
   add an axiom-expectation field (findings 10 and 11).
6. Amend plan steps 9 and 10 and add the declaration-deletion red-team entry (findings 8 and 9).
7. Run plan step 3's declaration-level review for the AME--LU family before any `Shared.AMELU`
   boundary is treated as settled (findings 6 and 7). This is the only item that needs mathematical
   judgement from the `ame-lu` lane.

## Mystery ledger

- The MDS--CSS gate imports two AME--LU sub-gates that the AME--LU aggregate itself does not
  (`AMELUExtensionFieldPencil`, `AMELUPartyExtensionSplitting`). Either the aggregate is not the
  whole AME--LU paper surface, or those two results belong to MDS--CSS. Unsettled; the `ame-lu` lane
  owns the answer, and the paper boundary cannot be fixed before it.
- The two-uniform rigidity gate has a trust declaration, terminals, and eight modules, but no export
  configuration and no paper. Unpublished AME--LU-adjacent result, a future paper, or abandoned
  work? Owner: `ame-lu` lane.
- `AMEStabilizerRigidity` has no trace in either repository's history. Most likely a drafting error
  in the mapping rather than a gate that was removed, but its intended referent is unconfirmed.
- Settled by this pass: the 40-module `Shared.AMELU` figure is not arbitrary — it is the balanced
  gate's reachability set plus exactly the three modules the two paper closures add. The mystery was
  where the number came from; the defect is that reachability was used as ownership.
