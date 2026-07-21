# C426 q=11 scheme Fourier development — second independent post-fix review

**Date:** 2026-07-21

**Reviewer:** Codex subagent `/root/c426_initial_review`, launched explicitly by the user

**Reviewed repair commits:**
`517faaf625136e4b96a33d43aa2e54e33f3396e6` and
`0b7978159db08cd18e249e127d5f2e6537bdf1eb`

**Verdict:** **GO**

The four residual provenance findings from the first post-fix review are fully resolved, and the
full enduring verification closure shows no regression. The stable bundle is now self-contained,
workflow-neutral, exactly reproducible, and consistent with the deliberately mixed Lean/external
trust boundary. The unchanged Lean theorem and import-only gate remain adequate for the narrowed
claims recorded in the report and proposed C320 ledger delta.

I made no change to any implementation source, generated output, verifier, gate, or implementer
report. This second post-fix review is my only repository change.

## Direct verification

From the repository root I ran the requested commands with bytecode generation disabled:

```text
PYTHONDONTWRITEBYTECODE=1 python3 \
  lean/verification/clebsch_scheme_fourier/check_scheme_certificate.py --check
  -> exit 0; sha256=5799c5382726031bce41cd4cbeecf5bcc9d44b712d10861362d06a0a9cab164f;
     bytes=12997

PYTHONDONTWRITEBYTECODE=1 python3 \
  lean/verification/clebsch_scheme_fourier/generate.py --check
  -> CHECK OK

sha256sum -c lean/verification/clebsch_scheme_fourier/SHA256SUMS
  -> all six manifest entries OK
```

The certificate checker exhaustively reconstructs the q=11 orbit tables, the complete intersection
and Krein tensors, additive-subgroup closure tests for all relation unions, and the Bannai–Muzychuk
test over all 877 partitions. The Lean-data generator independently reconstructs the 133
projective-line classifier rows and 126 nonclosure witnesses, recomputes the candidate `P` and `Q`
tables and selected identities, and cross-checks the independently generated certificate.

The landed schemas and provenance are now:

- orbit source schema: `clebsch-a5-orbit-construction-v1`;
- complete certificate schema: `clebsch-scheme-fourier-certificate-v1`;
- Lean-data schema: `clebsch-scheme-fourier-lean-v1`;
- relocated orbit source SHA-256:
  `1ea02f4a27c59a24c780d6bc6ed3eb249de829fa9f55759ddb4cf73e32d51e32`, matching
  `check_scheme_certificate.py`, `generate.py`, `scheme_certificate.json`, `data.json`, and the
  manifest wherever the binding occurs.

No C-task identifier, internal note path, agent/session label, or workflow-status language remains
in the enduring checker/generator/data/Lean closure. The generated Lean header names the exact
stable generator, orbit construction, checker-produced comparison certificate, schema, and
canonical JSON, and accurately distinguishes external geometric semantics from kernel-checked
literal consequences.

## Build and axiom evidence

I inspected queue run `20260721-191939-1831e7cb` directly. Its status is `success`; it records:

| Target | Outcome | Wall time | Peak RSS |
|---|---|---:|---:|
| `RelativeConicArcs.ClebschSchemeFourierData` | built | 5.52 s | 1,132,740 kB |
| `RelativeConicArcs.ClebschSchemeFourier` | built | 9.87 s | 2,248,116 kB |
| `RelativeConicArcs.Gates.ClebschSchemeFourier` | built | 3.84 s | 1,797,220 kB |
| aggregate exact-target check | gate-passed | — | — |

The human-written theorem module and gate hashes remain
`3018501b6adb2f3218190490d197ae1c7021436b78a38bc2473a857337093764` and
`6a17f12f095aade20e5887d0c951da273febbcc9f23f8ea4ea025f8189cbebfa`, respectively,
so the evidence-only repair did not alter theorem types, proofs, or the gate boundary. Source
inspection again found no `sorry`, `native_decide`, project axiom, or opaque oracle. The recorded
terminal-by-terminal axiom audit remains applicable and lists only standard `propext`,
`Classical.choice`, and `Quot.sound` dependencies where present.

## P1–P4 dispositions

| Prior finding | Final disposition |
|---|---|
| **P1 — stable generator contradicted the Lean trust boundary** | **Resolved.** `generate.py` now says Lean proves the abstract character identity and checks frozen literals only. It explicitly leaves geometric Fourier self-duality and primitivity external and says the separate certificate checker—not the Lean-data generator—owns the optional tensor/fusion computations. |
| **P2 — workflow IDs remained in schemas** | **Resolved.** The `c341` and `c372` schemas were replaced with the semantic schemas listed above, and all dependent artifacts were regenerated. A direct bounded audit found no residual task IDs or internal workflow references. |
| **P3 — comparison certificate lacked a stable producer and matching source binding** | **Resolved.** `check_scheme_certificate.py` is a stable, self-contained producer/checker with `--check`; it pins the relocated orbit source by its actual hash and reproduces `scheme_certificate.json` byte-for-byte. The checker is itself covered by `SHA256SUMS`. |
| **P4 — implementer report retained stale trust/provenance statements** | **Resolved.** R4/R6/R9 and JC-10 describe the completed stable bundle accurately. JC-3 now cites the stable exhaustive 877-partition checker, states that C426 imports no gateway fusion data, and exports no Lean fusion theorem. Artifact identities, replay commands, build evidence, and the C320 verify-all delta match the landed files. |

## Full-boundary regression check

The Lean gate still exports only:

- the abstract `F_11` character identity and scalar-line aggregation;
- dimensions and exact arithmetic identities for frozen candidate `P`, `Q`, incidence, and
  valency tables; and
- exact mask coverage plus successful option-valued classification of all 126 recorded nonclosure
  witnesses.

It still explicitly does **not** prove semantic scheme rank, identify the frozen data with the
geometric association scheme, or prove Fourier self-duality or primitivity of that named scheme
without the external enumeration bridge. It exports no intersection tensor, Krein/intersection
equality, fusion census, separability, or automorphism-group theorem. The report and C320 rows assign
those claims to the same decomposed or exact external routes, with no gateway rank bridge restored.

The C320 verify-all delta is adequate: run the stable certificate checker, Lean-data generator, and
six-entry checksum manifest check; validate exact target
`RelativeConicArcs.Gates.ClebschSchemeFourier` trace-current; then apply the recorded terminal axiom
audit. This is sufficient to reproduce the enduring evidence while keeping optional external claims
outside the Lean gate.

## Final conclusion

Every initial R1–R9 finding and subsequent P1–P4 finding is now either repaired or, where the task
deliberately retains mixed verification, reflected honestly in theorem names, prose, exclusions,
and ledger routes. The mandatory literal-check core is green, the external certificate bundle is
reproducible, and their boundary is explicit. C426 passes its required independent review gate.

**Final review disposition:** **GO**. C426 may proceed to the repository's normal completion and
archival steps without another implementation repair pass.
