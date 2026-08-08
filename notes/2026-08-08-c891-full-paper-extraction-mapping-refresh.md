# C891 — full paper-extraction mapping refresh

**Date:** 2026-08-08

**Lane:** `build-sys`

**Status:** complete; the C879 plan and mapping now match the full current
paper, repository, trust-gate, and export-area inventory

## Verdict

The 2026-08-06 C879 audit was valid but its proposed corrections had never been
applied.  Its plan and mapping were unchanged until this task, while several
paper-facing Lean surfaces changed underneath them.  C891 applies the AME--LU
and MDS--CSS corrections, generalizes the refresh to every registered paper,
and turns the old one-pair closure script into a current-tree failing preflight.

The refreshed snapshot contains:

- 16 paper-registry records;
- 14 standalone-repository records;
- 12 tracked Lean export areas;
- 17 paper-group records, of which 16 match the paper registry and one is the
  explicitly archived, unregistered Clebsch hexagon aggregate; and
- all 57 modules currently under `RelativeConicArcs/AMELU`, with no unassigned
  module.

No Lean source was moved or edited.  No Lean elaboration, build, export,
mirror synchronization, publication action, or remote action was performed.

## What changed since the C879 snapshot

The most visible stale counts were in AME and Golden Quantum Statistics.
C890 added `RelativeIntertwinerDecomposition`, raising the AME directory from
56 to 57 modules and the `AMELUTwoUniformRigidity` closure from eight to nine
project-owned modules.  Concurrent Golden work expanded
`GoldenQuantumStatistics` from a three-module matrix core to a nine-module
exchange-spectrum closure.  Both changes are now part of the immutable mapping
snapshot and checker.

The current tracked export areas and project-owned closure counts are:

| Area | Gate | Closure |
|---|---|---:|
| `ame_lu` | `AMELUAggregate` | 67 |
| `arcs_complete_outside_conic` | `ArcsCompleteOutsideConic` | 72 |
| `arcs_complete_outside_conic_additions` | `ArcsCompleteOutsideConicAdditions` | 31 |
| `clebsch_factorization` | `ClebschArithmeticGluing` | 31 |
| `clebsch_passages` | `ClebschPassages` | 19 |
| `clebsch_rigidity` | `ClebschRigidityTrust` | 94 |
| `clebsch_six_arc_concurrence` | `SixArcConcurrenceSpine` | 26 |
| `clebsch_support_cubic_orientation` | `SupportOrientationSpine` | 21 |
| `complete_ports` | `CompletePorts` | 31 |
| `golden_quantum_statistics` | `GoldenQuantumStatistics` | 9 |
| `mds_css_transversal_groups` | `MDSCSSTransversalGeometry` | 66 |
| `prs_beyond_redundancy_four` | `PRSBeyondRedundancyFour` | 16 |

## C879 AME--LU/MDS--CSS findings

All metadata corrections from the original audit are now represented:

1. The formerly unassigned AME modules are classified.  The six
   MDS--CSS headline modules, including `DiagonalIsoduality`, are paper-private
   to MDS--CSS.  The three exact rigidity modules and eight quantitative
   modules are paper-private to AME--LU.  The older forty-module AME list is
   retained only as a central reachability inventory pending declaration-level
   separation; it is explicitly not authorization to move all forty into
   `Shared.AMELU`.
2. `AMELUTwoUniformRigidity` is an AME--LU Paper I quantitative-core closure.
   It is trust-declared and extracted, has nine modules and 22 terminals, and
   still lacks an export configuration.  It is no longer described as a future
   paper or unclassified work.
3. The MDS--CSS dependency on AME--LU is explicit, including all nine directly
   imported AME gate modules.  The first physical split preserves their legacy
   names; one explicit paper adapter must replace them before namespace
   migration.
4. AME--LU and MDS--CSS now each declare all four shared families their current
   closures use: AME, coding, projective, and incidence.
5. The nonexistent `AMEStabilizerRigidity` gate entries are removed.
6. The PRS balanced adapter is an explicit paper dependency on AME--LU, not a
   reason to classify every reached AME theorem as shared.
7. The two-to-one PRS `QuantumExtension` target collision is removed by naming
   the source adapter `QuantumExtensionAdapter` separately from the gate.
8. The plan now freezes AME and other upstream APIs before downstream paper
   extraction, while moving their shared-heavy physical source families last.
9. The declaration-deletion failure mode from the 2026-08-03 MDS adoption is a
   mandatory firewall check: bytes and imports are insufficient when another
   area would lose declarations.
10. Paper groups use one `imports_shared` key, secondary manuscript entry points
    alias their parent formal surface, and terminal axiom expectations remain
    sourced from the applicable trust-area registry rather than duplicated.

## Whole-portfolio reconciliation

The mapping now includes every paper ID from `lean/trust/papers.toml`, including
the entries absent from the old map:

- the beyond-four submission entry point and Clebsch computational companion,
  both correctly aliased to their parent formal surfaces;
- continuation graph rigidity and dihedral Schreier Node Kayles, which have no
  tracked finitegeom paper export;
- Golden Quantum Statistics and its current nine-module export; and
- the normalized registry IDs `mds_css_transversal_groups` and
  `passant_code_q13`.

It also distinguishes tracked export areas from papers.  The six-arc
concurrence and support-cubic orientation areas are real, sealed companion
boundaries but do not yet have a settled paper owner.  Conversely, equivariant
completion, q13 passant code, the Golden operator, continuation, and dihedral
are registered papers with no tracked finitegeom export area.  Neither class is
silently omitted.

The Clebsch factorization entry now names the configured
`ClebschArithmeticGluing` gate and records `ClebschFactorization` as its
superseded root.  The complete-ports paper points to its separate
`complete_ports` trust registry.  Every other mapped gate points to the
per-terminal axiom expectations in `relconic.toml`.

## Replay and validation

Replay:

```text
python3 notes/scripts/c879_module_closure.py
```

The script now checks, without Lean elaboration:

- exact paper-registry and repository-registry inventories;
- the set and configured gate of every tracked export area;
- all 12 recorded transitive closure counts;
- every active or archived paper-group disposition;
- parent aliases, cross-paper dependency roots, and trust-area files;
- existence of every mapped source and legacy root;
- duplicate target names in every module map;
- both AME gate dispositions and all 57 AME module assignments; and
- absence of Lean-tree drift from the mapping's immutable authority commit.

The final replay reports `papers=16 repositories=14 exports=12 AMELU=57/57`
and `mapping audit: PASS`.  A second JSON parse rejects duplicate object keys
and also passes.  Scoped whitespace validation is clean.

## Remaining execution gates

This refresh makes the plan current; it does not make the source split ready to
execute.  The remaining blockers are explicit:

- run declaration-level review before promoting any provisional family into a
  shared API; several paper groups intentionally record that their private
  module list is not yet enumerated;
- create a narrow exact Paper I AME interface instead of treating the wider
  pre-split `AMELUAggregate` as the paper boundary;
- add an export configuration for the AME two-uniform quantitative gate;
- decide paper ownership for the six-arc concurrence and support-cubic
  orientation companion areas;
- decide whether and how the five registered papers with no tracked export area
  enter finitegeom; and
- complete the applicable C864 endpoint and certificate prerequisites before
  any source move.

## EJ + Tao closeout

The cheap upgrade was to make staleness executable.  The old audit could say a
map was current only once; the refreshed script makes paper, repository, export,
closure, source, target, and authority drift fail every future replay.

The deeper separation is between three notions the old map conflated:
reachability, current export packaging, and mathematical ownership.  They now
have separate fields and statuses.  That prevents a large transitive closure
from becoming a public shared API merely because two gates happen to reach it,
while still allowing source to remain physically central until ownership is
proved.

## Mystery ledger

| Question | C891 resolution | Remaining gate |
|---|---|---|
| Where did the forty-module `Shared.AMELU` list come from? | Settled: balanced-gate reachability plus three extra common modules; it is now labelled provisional, not ownership. | declaration-level AME review |
| Who owns `DiagonalIsoduality`? | Settled: the published MDS--CSS paper. | none |
| What is the two-uniform gate? | Settled: AME--LU Paper I's quantitative core, including C890. | tracked export configuration still needed |
| Are every paper and export area represented? | Settled: 16 paper records, 14 repositories, and 12 export areas are checked exactly. | none |
| Do six-arc concurrence and support-cubic orientation belong to a current paper package? | Unsettled; they are exported companion boundaries with no paper binding. | Clebsch lane ownership decision |
| Is `AMELUAggregate` the exact Paper I surface? | No; it is explicitly wider than the current manuscript. | narrow AME exact interface |
| Are all paper-private module lists complete? | No; completeness is recorded only where reviewed. | declaration-level review per paper before extraction |

## Vibe check

Good recovery.  The plan is again synchronized with the real portfolio, and
its remaining uncertainty is now mathematical ownership work rather than
silent schema or inventory drift.
