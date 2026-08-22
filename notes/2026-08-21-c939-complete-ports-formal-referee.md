# C939 formal-correspondence and reproducibility referee

**Date:** 2026-08-21  
**Frozen artifact:** `papers/complete-repair-ports/complete_repair_ports.pdf` (22 pages)  
**Verdict:** **MAJOR**

## Executive finding

The finite field-seven evidence and the immutable formal-boundary metadata are internally
consistent.  The public seed replay is exact, the manifest hash and counts agree with the committed
gate fact, and the audited paper-facing terminals use only `Classical.choice`, `Quot.sound`, and
`propext`.

The formal-correspondence claim for Theorem 6.5 is nevertheless not statement-adequate.  The named
terminal `RepairPorts.eventually_radiusThree_prescribedPortPair` proves simultaneous eventual
radius-three support- and coefficient-port transfer for two arbitrary inner codes using a common
outer family.  It does not state most of the theorem's matched asymptotic conclusions: fixed
alphabet `F_7`, the two concrete `[7,4,3]_7` seeds, asymptotic goodness, equal lengths and
dimensions, a common minimum-distance lower bound, density `1/7`, equality of the full pointed
profiles, or the two specific reliability laws.  Some ingredients exist separately in the gate or
in the finite certificate, but there is no formal theorem assembling them with the hypotheses and
quantifiers of Theorem 6.5.  This violates the paper lane's field-by-field statement-adequacy rule
for a body theorem.

## PDF-first provisional verdict

On a cold read of the PDF before opening any verification artifact, the provisional verdict was
**MINOR, conditional on an exact artifact match**.  The human proof of Theorem 6.5 is coherent:
the displayed matrices supply the seed data, a common outer family supplies matched global
parameters, and Theorem 4.1 transfers the ports.  The only apparent risk was the unusually broad
formal-verification paragraph on pages 18--19.  Artifact inspection changed the verdict to MAJOR
because the named matched-pair terminal covers only one part of the paper theorem.

## Field-by-field correspondence for Theorem 6.5

| Paper field | `eventually_radiusThree_prescribedPortPair` | Result |
|---|---|---|
| Two inner codes use one outer family | One `O` is passed to both inner codes | **Match** |
| Eventual statement, uniform in every block `j` | `exists N₀, forall N >= N₀, forall j : Fin N` | **Match** |
| Exact radius-three support-port copying | Equality with `embedHypergraph` for each code | **Match** |
| Exact radius-three coefficient-port copying | Equality with the image under `singleBlockWord` | **Match** |
| Fixed alphabet `F_7` | Generic fields `K` and `L`; no cardinality-seven hypothesis | **Missing** |
| Concrete displayed `[7,4,3]_7` seeds | Arbitrary `I₁`, `I₂`; assumes only nontrivial duals and dual distance at least four | **Missing** |
| Same length for every `N` | The index types `κ₁`, `κ₂` are arbitrary and need not have equal cardinality | **Missing** |
| Same dimension for every `N` | No paired dimension conclusion | **Missing** |
| Same proved lower bound on minimum distance | No primal-distance or concatenated-distance conclusion | **Missing** |
| Both families asymptotically good | Assumes only outer *dual* distance tends to infinity; no positive outer rate or primal relative-distance hypothesis/conclusion | **Missing** |
| Designated class has density exactly `1/7` | No density or seven-coordinate conclusion | **Missing** |
| Seed full pointed subset profiles agree | No pointed-profile hypothesis or conclusion | **Missing** |
| Seed locality three and exactly two minimum repairs | No such hypothesis or conclusion | **Missing** |
| Reliabilities `2s^3-s^6` and `2s^3-s^5` | Not in this theorem; generic pair formulas occur in separate gate terminals | **Missing from the cited correspondence** |
| Availability differs, two versus one | No matching-number conclusion | **Missing** |

The docstring accurately calls the declaration a “formal transfer statement” and says that the
concrete seed identifications are separate finite inputs.  The mismatch is therefore not a defect
in the Lean declaration itself.  It is a defect in presenting this terminal as the formal match for
the complete body theorem without an assembling terminal or an explicit partial-coverage map.

## Public field-seven replay

The public command

```text
python3 verification/f7-seed.py --check verification/f7-seed.json
```

passes byte-for-byte and reports 3,736 bytes with SHA-256
`8096230e66f634c820ae7ec4bacd9b2493006782ff02b8be3a8c7e1caf80de07`, exactly as printed in
Appendix A.1.  The replay confirms:

- rank four and no dependent triples for both matrices;
- dependent four-sets `0145, 0236, 2345` and `0123, 0256, 3456`;
- identical complete pointed profiles;
- minimal radius-three repairs `145,236` and `123,256`; and
- survivor-count rows `(0,0,0,2,6,6,1)` and `(0,0,0,2,6,5,1)`, yielding
  `2s^3-s^6` and `2s^3-s^5`.

This is good exact evidence for the displayed seed calculation.  It is not a Lean bridge from the
two matrices to the abstract inner-code arguments of the matched-pair terminal, and the PDF
correctly describes it as an independent finite replay rather than a kernel proof.

## Immutable manifest and axiom audit

The following claims in `verification/formal-boundary.json` agree exactly with the current
committed gate fact `lean/trust/facts/RepairPorts.Gates.CompletePorts.json` and gate source:

- gate: `RepairPorts.Gates.CompletePorts`;
- Lean: `leanprover/lean4:v4.32.0-rc1`;
- mathlib: `571b8a8e54219b4d393f75f4b8653fac08197fcc`;
- gate-fact SHA-256:
  `fbb29ef0bc559b9ac2ce3308a7b3c0572753ffd7163d6c15cd18e57464fc0a4d`;
- 36 closure modules, with the manifest list byte-for-byte equal to the gate fact's list;
- 61 paper-facing terminals, equal to the 61 `#print axioms` commands in the gate;
- 888,036 total source bytes across those 36 module files; and
- terminal-axiom union exactly `Classical.choice`, `Quot.sound`, and `propext`, with no project
  axioms in the fact.

The named matched-pair, parameter, density, and two reliability terminals each individually report
that same three-axiom set.  `python3 lean/scripts/lean-trust-spine.py audit --area complete_ports`
completed with `0 error, 0 warn, 0 info`.

The conditional-terminal entry is also accurate at the metadata level: it names
`RepairCodes.projectiveAxisTwistedCubic_strict_weighted_transfer_of_regular_projective_action`
and exposes regular Singer action as an external hypothesis.

## Reproducibility limitations observed

1. The exact guarded build replay could not complete during this review.  The repository queue
   refused the run after its standard quiet wait because a foreign Lean build was live.  No process
   was stopped and the unchanged command was not resubmitted.  This is an environmental limitation,
   not evidence of a build failure.
2. The exact area-export plan was refused because the canonical finitegeom checkout has uncommitted
   changes.  Its `HEAD` is the pinned commit
   `b871c10b4a91200a0913644d39b9f0ce44f655ca`, but the planner correctly requires a clean checkout.
3. The formal source commit `e45c925e11112b4a21a17ff23029243904fc5865` is not an object in the
   supplied monorepo checkout, and the public verification README does not identify an immutable
   repository URL or archive from which to obtain it.  A bare commit hash is not a reproducible
   source locator.  If the release archive itself contains the exact 36-module closure, the README
   must say so and the manifest must bind that archive; otherwise it must name the public repository
   and archival identifier.

## Exact required fixes

### Required for GO

1. **Close the Theorem 6.5 statement-adequacy gap.**  Add and gate one paper-facing Lean terminal
   whose hypotheses and conclusions assemble the matched result.  At minimum it must express:
   equal seven-coordinate inner index sizes; the common outer family; the paired concatenated
   length and dimension formulas; a common minimum-distance lower bound; exact density `1/7` of
   the designated targets; eventual exact radius-three port copying for both seeds; and transport
   of the two radius-three reliability formulas.  Asymptotic goodness may remain conditional on an
   explicitly stated outer-family rate/primal-distance hypothesis, with outer-family existence
   labeled classical as in the PDF.  The concrete matrix/profile facts must either be formalized or
   remain visibly identified as the exact finite inputs to this terminal.

   A weaker acceptable editorial route is to stop claiming field-by-field formal coverage of
   Theorem 6.5: explicitly label `eventually_radiusThree_prescribedPortPair` as covering only its
   transfer subclaim and mark the remaining theorem fields as human proof plus independent finite
   replay/classical existence.  Under the lane's stated main-proof admission rule, however, that
   route requires demoting or relabeling the body theorem rather than leaving it in the fully
   formal-matched proof spine.

2. **Update the immutable boundary after the new terminal or weakened claim map.**  Regenerate the
   import-only gate fact and `verification/formal-boundary.json`; update the terminal count, closure
   list/count/bytes, fact hash, and axiom union from actual `#print axioms` output.  Update pages
   18--19 so every named declaration is assigned only the fields it proves.

3. **Provide an actionable immutable formal-source locator.**  Add the public repository URL and
   archival release/DOI (or bind an included source archive by SHA-256) to the README and manifest,
   and verify that the pinned source commit is obtainable from that locator.  Name the exact
   finitegeom locator as well, not only its local-checkout role.

4. **Perform one clean independent replay.**  From the published source pin and a clean finitegeom
   checkout at the pinned base, run the guarded gate build, trust audit, and area-export plan.  Record
   the expected bounded outputs: 36 modules, 61 terminals (or updated counts), exact closure bytes,
   no prose drift, and the three permitted axioms.  The current refused runs do not satisfy this
   release gate.

### No fix required

- The field-seven matrices, circuit-hyperplane lists, minimal repairs, reliability formulas, JSON
  bytes, and certificate hash agree.
- The current manifest's gate-fact hash, toolchain, mathlib revision, module list/count, terminal
  count, source-byte total, and axiom set agree with the committed formal fact.
- No additional axiom, `sorry`, native computation, or hidden Singer assumption was exposed by the
  inspected gate fact.

## Acceptance condition

Keep the verdict at **MAJOR** until fixes 1--4 are complete.  If the theorem is assembled in one
statement-adequate terminal, the manifest is regenerated, the source pin is publicly resolvable,
and a clean replay matches, the formal/reproducibility verdict becomes **GO**.  Cosmetic prose
changes alone are insufficient.

**Vibe check:** the evidence is disciplined and mostly healthy; one central theorem currently
claims a broader formal match than its named terminal supplies.

## Mystery ledger

The closeout `ej`+`tt` pass settled the only cheap structural question: the theorem gap is not a
missing axiom or a stale manifest entry; it is a genuine mismatch between the fields of the paper
theorem and the type of the cited Lean terminal.  Two evidence gaps remain:

- the public origin of source commit `e45c925e11112b4a21a17ff23029243904fc5865` is not identifiable
  from the supplied verification bundle; required fix 3 owns this;
- clean build and area-export replay remain unobserved because of foreign live work and a dirty
  finitegeom checkout; required fix 4 owns this.

No further mathematical mystery was exposed by the bounded review.
