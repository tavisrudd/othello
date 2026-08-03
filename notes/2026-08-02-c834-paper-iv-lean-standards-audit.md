# Paper IV Lean standards audit

**Date:** 2026-08-02

**Lane:** `clebsch`

**Disposition:** release-blocking trust findings and prose repairs identified; the audit itself is
read-only with respect to Lean source; complete repair checklist allocated as C857

## Scope

The source-side audit covers 190 project-owned Lean modules:

- all 169 modules under `papers/q13-passant-code/lean-certificates/PassantCodeQ13`;
- all eight modules under `lean/RelativeConicArcs/PassantCodeQ13` and the two associated shared
  gates; and
- the eleven additional shared modules in the transitive project-local import closure of
  `PassantCodeQ13.Gates.Main`.

The public gate closure itself contains 80 modules: 60 paper-owned modules and 20 shared modules.
The source scan includes the isolated weight-ten reachability packet under construction even though
that packet is not yet imported by the public gate. Vendored Lake packages and Mathlib are excluded.

The audit applies `lean/AGENTS.md`, `papers/style-guide.md`, and
`notes/research-reproducibility-conventions.md`: kernel-checkable release claims, an explicit trust
boundary and exact finite domain for computation, reader-facing module and declaration docs,
mathematical rather than workflow language, precise external citations, and reproducible generated
data.

## Overall assessment

The paper-owned and q=13-specific source is unusually strong on documentation. All 643 public
declarations in those 179 modules have adjacent docstrings. The source scan found no `sorry`, unsafe
declaration, `implemented_by`, task identifier, private path, or unresolved `TODO`/`FIXME`. The new
reachability files state their generated provenance and kernel trust mode locally.

The current release gate nevertheless fails the principal trust standard. Its exact project-local
closure contains 82 uses of `native_decide` in 48 modules, and its axiom-audit header explicitly
expects declaration-local native-decision axioms. The isolated reachability packet improves one
seven-shard family but is not yet connected to the public gate; the remaining native leaves cover
several independent mathematical families.

## Findings

### 1. The public gate is not a kernel-only release closure

`papers/q13-passant-code/lean-certificates/PassantCodeQ13/Gates/Main.lean:1-10` imports the current
shared gate, weight-ten aggregate, minimum-word exhaustion and reconstruction, association leaves,
automorphism transport, and structural upgrades. Their transitive project-local closure contains 82
`native_decide` occurrences in 48 files:

- 18 in the shared semantic modules;
- 22 in `MinimumWords`;
- 16 in the paper-owned `WeightTen` modules;
- 9 in `StructuralUpgrade.lean`;
- 8 in `AssociationTransport`;
- 6 in `Automorphisms`; and
- 3 in `AssociationAlgebra.lean`.

The release audit confirms that this is intentional current behavior rather than a dead-source
artifact: `PassantCodeQ13/Gates/AxiomAudit.lean:6-7` says that every aggregate native terminal is
expected to expose declaration-local axioms. The public weight-ten theorem still obtains its result
from `WeightTen.Aggregate` (`Gates/Main.lean:40-51`), whose header says it joins fourteen native
terminals and whose local-partition and pair-partition leaves use native evaluation
(`WeightTen/Aggregate.lean:16-30,59-64`).

This blocks a kernel-only Paper IV release. Replacing only the seven isolated-profile leaves is not
sufficient: all seven groups above remain in the theorem-facing import closure until replaced or
removed from the public gate.

There is also a release-surface mismatch: `lean-certificates/README.md:25-29` describes the old
syndrome shards as an independent regression check, while `Gates/Main.lean:2,40-51` still imports
their aggregate and exports it as `weightTenCertificate`. Either the modules are public evidence, in
which case their trust mode blocks the gate, or they are independent replay, in which case the
public aggregate must stop importing and re-exporting them.

### 2. The release audit is live source only, not a frozen rejecting gate

The package has `PassantCodeQ13/Gates/AxiomAudit.lean`, and the evidence manifest tracks that source
file, but Paper IV has no frozen q=13 axiom transcript under `lean/verification`, no public Lean
allowlist, and no single `verify_release.py` comparable to the other numbered-paper packages. The
current replay command in `lean-certificates/README.md:61-65` merely builds the gate and prints the
audit. It does not compare the output with a tracked transcript or reject a new project-local or
native-decision axiom.

Consequently, complete `#print axioms` coverage is observable but not release-enforced. The final
gate needs a frozen transcript, a curated public module/theorem allowlist, and a verifier that fails
on transcript drift, missing theorem-map rows, untracked generated artifacts, or forbidden axioms.

### 3. The public gate does not state the paper's main theorem

`PassantCodeQ13/Gates/Main.lean:20-25` explicitly says that the gate does not claim the full
minimum-distance or reconstruction theorem. Its thirteen public theorems are useful component
certificates, but there is no release terminal whose statement matches every clause of the frozen
Paper IV main theorem. In particular, the gate does not itself state one theorem combining
parameters `[78,36,12]_2`, complete 364-word classification, intrinsic four-family identification,
spanning, exact pair reconstruction, marked-plane recovery, and automorphism group.

This candor prevents accidental overclaiming, but it also means statement identity cannot yet be
audited at the release boundary. A theorem-to-source map cannot substitute for the missing aggregate
statement; the aggregate and map are both required.

### 4. Eight native row-uniqueness leaves have no module documentation

The following modules have theorem docstrings but no `/-! ... -/` module header:

- `MinimumWords/RowUniqueness/ResidueZero.lean` through `ResidueSix.lean`; and
- `MinimumWords/RowUniqueness/GeometricRows.lean`.

For example, `ResidueZero.lean:5-8` gives only a one-sentence theorem docstring followed by
`native_decide +revert`. A module header should identify the exact residue domain, the enumerated
extension domain, the coverage relationship to the seven residue shards, and the native or
certificate trust boundary. `GeometricRows.lean` needs the analogous exact domain statement for its
geometric-row check.

### 5. Eighty-six imported public theorems lack declaration docstrings

The q=13-specific source has complete adjacent-docstring coverage, but the additional shared import
closure contributes 86 undocumented public theorems and two undocumented public abbreviations. The
largest concentrations are:

- `lean/ProjectiveCap/PlaneTransitivity.lean`: 25;
- `lean/RelativeConicArcs/Moments.lean`: 25;
- `lean/RelativeConicArcs/CodingBridge.lean`: 11;
- `lean/RelativeConicArcs/Defect.lean`: 9;
- `lean/CapGame/BuildGame.lean`: 5; and
- `lean/RelativeConicArcs/Arc.lean`: 5.

The remaining eight occur in `ProjectiveCap/Projective.lean`, `RelativeConicArcs/Plane.lean`,
`RelativeConicArcs/ConicPassantCode.lean`, and `RelativeConicArcs/ProjectiveBridge.lean`. These are
part of the public theorem's verification closure, so the release documentation standard applies
even though they are reusable rather than paper-local.

### 6. The named classical weight-eight input has no pinpoint citation

`lean/RelativeConicArcs/PassantCodeQ13/WeightEight.lean:7-17` and
`lean/RelativeConicArcs/Gates/PassantCodeQ13.lean:51-65` refer to a “classical arc/tangent lemma.”
The Lean theorem honestly exposes the resulting conditions as hypotheses, so this is not a hidden
axiom. It is still not an independently checkable scholarly reference. The module or stable claim
ledger should identify the exact theorem, source, and page or theorem number that supplies the two
geometric hypotheses.

## What is already working

- None of the 190 audited project-owned modules contains `sorry`, an unsafe declaration,
  `implemented_by`, a private filesystem path, or a public workflow identifier.
- Every public declaration in the 169 paper-local modules and ten q=13-specific shared modules has
  an adjacent docstring.
- All but the eight row-uniqueness leaves have module documentation.
- `PassantCodeQ13.Gates.AxiomAudit` names all thirteen public theorems exported by
  `PassantCodeQ13.Gates.Main`; audit coverage is complete even though the reported trust mode is not
  release-ready.
- The tracked rank generator identifies its generated module, and the isolated reachability
  generator identifies 98 generated modules and records a byte-for-byte manifest.
- The source scan found no novelty or priority claim in Lean comments.

## Recommended repair order

1. Complete kernel/certificate replacements for every native leaf reachable from
   `PassantCodeQ13.Gates.Main`, then make the axiom audit reject project-local or native-decision
   axioms.
2. Connect only the new certificate aggregates to the public gate and remove legacy native replay
   modules from its import closure.
3. Add a frozen axiom transcript, public allowlist, exact theorem map, and rejecting release
   verifier.
4. Add the single theorem matching every clause of the manuscript main theorem and connect every
   theorem-map row to it.
5. Add exact trust-and-domain module headers to the eight row-uniqueness leaves.
6. Document the 88 public declarations in the additional shared closure, prioritizing
   `PlaneTransitivity`, `Moments`, and `CodingBridge`.
7. Replace the generic “classical arc/tangent lemma” phrase with a stable pinpoint citation.
