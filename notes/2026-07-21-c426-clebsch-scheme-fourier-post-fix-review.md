# C426 q=11 scheme Fourier development — independent post-fix review

**Date:** 2026-07-21

**Reviewer:** Codex subagent `/root/c426_initial_review`, launched explicitly by the user

**Reviewed implementation commits:**
`4c7a848291906b3961f8af9eb86dd30da30e0f9b` and
`892cb8f5d7a5797261b5833547f039d5b2fda456`

**Current repository head during review:** `7cf50ffcaed60878a295750d709024fa958a6b1c`
(no later commit modifies a reviewed C426 path)

**Verdict:** **NO-GO**

The Lean theorem/gate repair is technically successful and resolves the important semantic and
certificate-checking defects in the initial artifact. The remaining blocker is narrower: initial
finding R6 is not actually complete, and stale claims in the purported enduring generator also
leave R4 only partially resolved. The stable bundle still contains workflow-ID schemas, omits the
generator for its frozen comparison certificate, records a source hash that does not identify the
bundled orbit file, and says Lean proves primitivity of the geometric scheme even though the repaired
Lean module and gate correctly deny that claim. This prevents a final referee-ready GO under
`lean/AGENTS.md`.

I made no change to any implementation source, generated output, verifier, gate, or implementer
report. This post-fix review is my only repository change.

## Scope and direct checks

I re-read the complete initial report and directly inspected:

- every declaration and all prose in
  `RelativeConicArcs.ClebschSchemeFourierData`,
  `RelativeConicArcs.ClebschSchemeFourier`, and
  `RelativeConicArcs.Gates.ClebschSchemeFourier`;
- `lean/verification/clebsch_scheme_fourier/generate.py`, its generated Lean template,
  `orbit_construction.py`, `data.json`, `scheme_certificate.json`, and `SHA256SUMS`;
- the complete implementer report, exact terminal appendix, validation evidence, axiom groups,
  judgment calls, exclusions, and proposed C320 ledger delta; and
- the actual path sets and diffs of both reviewed commits.

Independent replay and identity checks performed from the repository root:

```text
PYTHONDONTWRITEBYTECODE=1 python3 \
  lean/verification/clebsch_scheme_fourier/generate.py --check
  -> CHECK OK

sha256sum -c lean/verification/clebsch_scheme_fourier/SHA256SUMS
  -> all five listed files OK
```

The eight byte counts and SHA-256 values reported by the implementer match the landed files. The
exact gate was independently checked against the current content trace with:

```text
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.Gates.ClebschSchemeFourier \
  --profile single --threads 1 \
  --aggregate RelativeConicArcs.Gates.ClebschSchemeFourier --cores 20-23
```

Review run `20260721-185633-eddef5ab` reported the target already current and passed the trace-only
aggregate gate. Source inspection found no `sorry`, `native_decide`, project `axiom`, or opaque
oracle in the three-module C426 closure. The implementer's reported axiom groups are consistent
with the declaration proofs and contain only `propext`, `Classical.choice`, and `Quot.sound` where
listed; no forbidden axiom is claimed. The lack of a retained audit wrapper is not made a new
blocker because the durable report records every terminal and its complete axiom set, but a stable
audit harness would make the C320 verify-all integration stronger.

## Initial finding dispositions

| Initial finding | Post-fix disposition |
|---|---|
| **R1 — gate not green** | **Resolved.** All theorem types elaborate in the landed module; the implementer records measured data/theorem/gate builds, and this review independently confirmed an exact trace-current aggregate gate. |
| **R2 — lookup failure could masquerade as relation zero** | **Resolved.** `relationOf?` preserves failure as `none`. `frozen_witnesses_break_additive_closure` requires successful `some r` classification for both summands and their nonzero sum; no negative claim can be discharged by lookup failure. |
| **R3 — character sum disconnected from scalar-line formula** | **Resolved.** `nonzeroScalarLineContribution` follows from `characterSum`; `scalarLineContributionsSum` proves the general `11 * count 0 - length` formula; `scalarLineEigenvalue` names the integer specialization used in `frozen_eigenmatrix_scalar_line_formula`. The geometric use of the frozen counts remains explicitly external. |
| **R4 — scheme-level prose stronger than theorem types** | **Partially resolved; still blocking through the generator.** The Lean module, names, gate, report routes, and C320 rows now correctly distinguish literal kernel checks from external geometric identification. However, the enduring `generate.py` still says the frozen fact “the scheme is primitive” is established downstream in Lean. That contradicts the gate and must be corrected. |
| **R5 — false subgroup assertion** | **Resolved.** The generator now describes an exhaustive witness search and explicitly says no subgroup classification is assumed. |
| **R6 — internal/non-self-contained referee provenance** | **Not resolved; blocking.** Details and exact repairs are below. |
| **R7 — dimensions and constants unbound** | **Resolved.** `frozen_table_shapes` checks all relevant outer and row dimensions; product theorems use `schemeOrder` and `schemeRank`; indexed multiplication avoids the previous `List.transpose` reduction problem. |
| **R8 — gate rank/scheme overclaim** | **Resolved.** The gateway import and literal rank bridge are gone. The gate accurately says it checks frozen data and does not prove semantic scheme rank, Fourier self-duality, or primitivity of the geometric scheme. JC-1 route 2 is faithfully implemented. |
| **R9 — incomplete exit report** | **Substantially resolved, but final accuracy depends on R4/R6 repair.** The report has exact types, routes, hashes/bytes, validation, axiom groups, exclusions, judgments, checklist, and C320 rows. Its claims that all findings are repaired and that the enduring bundle is complete are currently false; JC-3 also still says the gateway fusion list “is imported” although the C426 gateway import was removed. |

## Residual blocking findings

### P1 — The stable generator contradicts the repaired trust boundary

`lean/verification/clebsch_scheme_fourier/generate.py` says in its module docstring that “the
scheme is primitive” is established downstream in Lean. It also describes itself as reusing an
“intersection tensor” and places that tensor in its trusted boundary, but `build()` does not consume
or check the intersection tensor; it imports orbit-construction functions, reconstructs the orbit
tables and witnesses, and compares selected spectral/count fields from the frozen certificate.

The repaired Lean theorem and gate deliberately prove only literal witness nonclosure and explicitly
leave transfer to geometric scheme primitivity external. Therefore the enduring generator must use
the same decomposition. It must also remove the unused intersection-tensor claim or actually state
the limited role of the comparison certificate without implying that the optional tensor is checked
by this generator.

### P2 — Workflow IDs remain inside enduring schemas

The stable `orbit_construction.py` emits schema `c341-a5-subgroup-decoder-v1`, and the stable
`scheme_certificate.json` contains schema `c372-clebsch-scheme-fourier-v1`. These are precisely the
task-ID variants forbidden in names, generated metadata, and verification artifacts by the Lean
guide. Moving the files to a neutral directory did not remove the reverse workflow references from
their contents.

Replace both with semantic, workflow-neutral schema identifiers. Because these are generated or
comparison artifacts, update them through their producing source/checker rather than hand-editing a
frozen output, then regenerate all dependent hashes and data.

### P3 — The comparison certificate is not self-contained or reproducible from the stable bundle

`scheme_certificate.json` records
`trusted_input.source_orbit_construction_sha256 = 4419cf...`, while the bundled
`orbit_construction.py` has manifest hash `0973e9...`. The difference is explainable—the bundled
file is a two-line metadata/path neutralization of the older source—but no enduring artifact states
that mapping. More importantly, the stable bundle contains the comparison JSON but not the checker
that generated its eigenmatrices, intersection tensor, and 877-partition fusion census. That checker
still exists only as an internal task-dated source, so a referee with the declared stable bundle
cannot reproduce the comparison certificate or interpret its old source hash without internal
workflow context.

This contradicts the implementer report's description of a “complete load-bearing bundle” and the
R6/JC-10 disposition. The fact that `generate.py --check` successfully compares selected fields does
not reproduce the comparison certificate itself.

### P4 — The implementer report has two stale trust/provenance statements

After P1–P3 are fixed, update the report rather than merely changing the stable files:

- JC-3 says the gateway's q=11 fusion list “is imported literal data under the same JC-1 boundary,”
  but the C426 module no longer imports the gateway. Describe the 877-partition result only through
  its actual external certificate/checker route.
- R6 and JC-10 call the current bundle complete and say all internal workflow identifiers are gone.
  Those statements must name the new stable checker/schema artifacts and their actual replay roles.

The C320 rows themselves are otherwise well decomposed: no optional tensor/fusion theorem is
exported, the geometric identification stays external, and the gate target is correct.

## Exact required repair

1. Correct `generate.py`'s module docstring and trusted-boundary prose so it says Lean checks the
   abstract character identity and frozen literals only; scheme primitivity/Fourier interpretation
   remains external. Remove the inaccurate claim that this C426 generator consumes or checks the
   intersection tensor.
2. Add a workflow-neutral stable checker/generator for `scheme_certificate.json`, or explicitly
   replace that comparison input with a smaller independently reproducible certificate whose exact
   producing source is in the stable bundle. The stable checker must use stable paths, state its
   mathematical semantics, and have a `--check` mode.
3. Replace the `c341` and `c372` schema strings with semantic identifiers and regenerate rather
   than hand-edit all affected artifacts. Make the comparison certificate's source hash either
   match the bundled source it actually consumes or explicitly encode and verify a self-contained
   source-to-relocated-source equivalence without relying on internal notes.
4. Extend `SHA256SUMS` to cover the added checker and every resulting load-bearing file; rerun both
   checker `--check` commands, `generate.py --check`, and the exact gate after regeneration.
5. Update the implementer report's R4/R6/R9 dispositions, JC-3, JC-10, artifact table, replay
   commands, final hashes/bytes, validation evidence, and C320 verify-all delta. Keep JC-1 route 2
   and all current optional exclusions unchanged.
6. Stop and request another user-launched post-fix review. No Lean theorem redesign or optional
   tensor/fusion Lean leaf is required for these repairs.

## Adequacy assessment apart from the residual provenance blocker

The current theorem types are nonvacuous and match their narrowed names. The matrix checks bind
dimensions and normalization; witness lookup is total where used; mask coverage is exact; the
abstract character argument and its scalar-line aggregation are properly general; and the gate
imports the complete mandatory literal-check API while explicitly excluding geometric semantics,
intersection/Krein equality, fusion census, separability, and automorphism groups. The C320 ledger
correctly treats Fourier self-duality, multiplicity/valency meaning, and primitivity of the named
scheme as combined Lean-literal plus external-enumeration claims.

Accordingly, the remaining NO-GO is not a defect in the repaired Lean mathematics. It is a
referee-facing evidence and claim-consistency failure in the enduring verification closure, which
the repository rules make release-blocking.

**Further post-fix review status:** required; only a user-launched independent review may issue GO.
