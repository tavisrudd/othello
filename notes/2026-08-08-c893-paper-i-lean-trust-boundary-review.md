# C893 — Paper I Lean and trust-boundary review

**Date:** 2026-08-08  
**Artifact verdict:** **MAJOR**  
**Mathematical-kernel verdict:** **PASS for the advertised 55-terminal Lean
surface; not theorem-complete for the two manuscripts.**

## Executive finding

The formal core is substantially better than the published trust prose says.
All 55 tracked terminals match the current axiom transcript, and the only reported axioms are
`propext`, `Classical.choice`, and `Quot.sound`.  The complete 208-module
project-owned closure contains no `sorry`, project axiom, unsafe declaration,
`native_decide`, or compiled-evaluation escape.

The release/trust artifact nevertheless requires major revision.  Its current
trust manifest is stale against `README.md`; its validator accepts deletion of
a Lean terminal when the matching local axiom entry is deleted too; all 66
outputs of the q11 point-action generator fail the generator's own `--check`;
the companion and generated trust prose still claim two Dye assumptions that
do not exist; two orientation commutant equalities remain conditional on an
unproved proposition-valued representation-theoretic interface; substantial
paper assertions remain human, cited, finite-certificate, or trusted-execution
results; and 138 of the 208 project-owned modules expose scholarly
documentation debt.

The guarded build attempted during C893 was later found to have been refused
behind a foreign Lean process; its apparent success had been read from a
concurrent q13 run directory.  C855 therefore owns the fresh correctly
identified q11 gate replay.  This correction does not change the MAJOR verdict
or any source/axiom-set finding below.

This is not evidence of a false Lean proof or a concealed nonlogical axiom.
The main paper itself says that Lean is an independent cross-check rather than
a proof dependency.  It is evidence that the current release contract is
internally stale and that the artifact does not meet the present
theorem-complete/referee-ready standard owned by C855.

## Frozen review surface

- Paper authority: `papers/clebsch-rigidity/`, including all 2,098 lines of
  `clebsch_rigidity.tex`, all 1,053 lines of
  `clebsch_rigidity_computational_companion.tex`, the 19-row statement identity,
  the 19-row/26-check trust manifest, and all 37 verification files.
- Certificate package:
  `/home/tavis/src/lean/finitegeom-clebsch-q11-certificates` at
  `a80e7de66a65c1b9cc5367dabbfdb7b8576ba671`, exactly the pin in
  `FORMAL_COMPANION.json`.
- Shared dependency checkout: the package's `.lake/packages/finitegeom` at
  `575cf3e991168fb96eb24c318263c5d0552aa531`, exactly the shared-library pin.
- Aggregate gate:
  `RelativeConicArcs.Gates.ClebschRigidityWithOrderElevenCertificates`.
- Downstream standalone paper mirror:
  `/home/tavis/src/math-papers/clebsch-rigidity` at `87915b54`; all 62
  mirror-tracked paths were compared read-only, with zero byte differences on
  every path shared with the authority.  Its three mirror-only metadata files
  were not treated as authority inputs.

## Exact formal closure and trust

An import-graph traversal from the aggregate gate resolves:

| Owner | Project modules | Notes |
|---|---:|---|
| q11 certificate package | 115 | exactly the 115 sources sealed by package `MANIFEST.json` |
| pinned shared dependency | 93 | 85 `RelativeConicArcs`, five `ProjectiveCap`, three `CapGame` modules |
| total project-owned closure | **208** | plus 43 external Mathlib/toolchain imports |

The shared `trust/manifests/clebsch_rigidity.json` contains 94 sources because
it also seals its own base-only gate; the package gate imports the other 93.
The package gate contains exactly 55 `#print axioms` commands.  The union of
the 19 trust-manifest rows is exactly those same 55 terminal names, and the
tracked axiom audit has exactly those same 55 rows: no missing or extra name in
either comparison.  The observed axiom sets are exactly:

- `[propext]`;
- `[propext, Quot.sound]`; and
- `[propext, Classical.choice, Quot.sound]`.

The complete source-policy scan of the 208 project modules found no executable
`sorry`, `axiom`, `unsafe`, `admit`, `debug.skipKernelTC`, or `native_decide`.
The five textual `native_decide` occurrences are comments explicitly saying
that it is not used.  No high-confidence task identifier, private path,
assistant/session note, work status, or novelty claim was found in the formal
closure.

## Claim-to-evidence matrix

The exact names for each Lean component are the `terminals` arrays under the
corresponding row in `verification/trust_manifest.json`; their 55-name union was
independently reconciled to the gate and audit as described above.  “Partial”
means that the listed terminals kernel-check a stated subclaim, not the whole
printed theorem group.

| Row | Manuscript identity | Lean terminals | Actual boundary and assessment |
|---:|---|---:|---|
| 2 | rigidity headline | 7 | Mixed cited/human, exact replay, and partial Lean.  Current Lean rigidity is axiom-clean; the manifest's Dye-axiom wording is false. |
| 11 | `prop:a5-point-orbits` | 7 | Partial Lean checks the explicit order-60 action and point-orbit partition; the classical identification remains cited. |
| 12 | `prop:deep-holes-conic` | 3 | Partial Lean plus exhaustive replay and a human/cited identification. |
| 13 | `cor:named-variety` | 0 | Human conceptual dictionary and exact counting only; no adjacent Lean label transfers to it. |
| 14 | `prop:deep-hole-orbit` | 0 | Human projective-action argument plus exact executable replay. |
| 15 | `prop:decoding-oracle` | 5 | Partial Lean for syndrome branches/leader strata plus exhaustive replay. |
| 16 | `lem:six-arc-line-bound` | 0 | Human combinatorial proof, with finite census only for displayed special values. |
| 17 | rigidity theorem and fixed-conic corollary | 7 | Partial Lean plus cited/human geometry.  The old “two Dye consequences” description is stale; no Dye axiom remains. |
| 18 | `prop:low-degree-rigidity` | 0 | Fourteen exact cubic-minor certificates and symbolic-kernel replay; explicitly no Lean theorem. |
| 19 | `cor:monomial-characterization` | 1 | One Lean subclaim, with the remaining corollary conceptual and dependent on row 18's finite proof surface. |
| 20 | `thm:gap` | 0 | Finite orbit/concurrence/chord certificates and retained exhaustive computation; no Lean theorem. |
| 21 | `prop:brianchon-support` | 0 | Human consequence of cited Edge--Dye geometry. |
| 22 | `cor:decoder-brianchon` | 5 | Human conceptual corollary; partial Lean checks exact witness rows. |
| 23 | support bipartition, orientation, cubic geometry | 24 | Broad Lean orientation spine plus exact replay and human proof.  The two commutant equalities remain conditional on `ClassicalOddA5ThreePlusThreeSplitting`. |
| 24 | chord defect, concurrence, filling window, q9 polarity | 4 | Human/cited all-field results; Lean checks selected six-arc and explicit clique specializations. |
| 25 | `thm:why11` | 2 | Partial Lean and exact replay.  The generated “inherits Dye” wording is stale. |
| 26 | golden normal form and family formula | 1 | Conceptual all-field argument; one partial Lean terminal and an exact q19 replay. |
| 29 | q13 passant code, pencil saturation, small-k classification | 4 | Small-arc moment reductions only in Lean.  Other parts are human proofs, finite certificates, and trusted execution, including the q13/q17/q19 leaves. |
| 58 | fifteen-class census table | 0 | Finite orbit ledger/local witnesses, with exhaustive normalized enumeration retained as trusted execution. |

No row was silently promoted from a neighboring Lean component.  In
particular, rows 13, 14, 16, 18, 20, 21, and 58 have no Lean terminal at all.

## Severity-ranked findings

### M1 — the current authoritative release surface is red

`python3 verification/verify_trust_manifest.py --lean-root
/home/tavis/src/lean/finitegeom-clebsch-q11-certificates` fails before Lean on
the public-document seal.  `verification/trust_manifest.json` expects
`README.md` SHA-256
`d4bd8002637173db23d3fdb992ac57a2370d99ee1d3b3a99866f810a568e7d45`;
the current file is
`40d15ff11e3b8b6346e750639fddead5d00b657addd14e067ada464ba57d70d3`.
An independent audit of all 50 unique pinned files found this as the sole hash
mismatch.  The tracked `verify-release-output.json` still says `passed`, so it
attests an older surface and cannot establish the current release.

### M2 — an omitted terminal can remain self-consistent and pass

Against a temporary manifest with only the current README hash repaired and
the stale recorded release output explicitly allowed, the validator accepted
deletion of one terminal when its matching axiom-map key was deleted from the
same claim.  It checks equality inside each local Lean component but never
compares the global manifest union with the 55 `#print axioms` commands in the
aggregate gate.  The unit suite has no omitted-terminal or exact-gate-closure
test; its import-noise test intentionally permits extra actual audit rows.

This means the current verifier cannot prove that the paper-facing manifest
covers every public terminal printed by its own gate.  It also content-hashes
the gate source without separately freezing elaborated theorem types, so axiom
agreement alone is not statement identity.

### M3 — the generated-source derivation is stale for all 66 outputs

`scripts/generate-q11-a5-point-action.py --check` fails immediately at
`RelativeConicArcs/Q11A5PointOrbitsRowsG05.lean`.  A complete independent
comparison found all 66 declared outputs stale: 55 row leaves G05--G59 and 11
aggregators.  The first difference is already provenance text: the checked-in
leaf says `scripts/generate-q11-a5-point-action.py`, while the generator emits
`lean/scripts/generate-q11-a5-point-action.py` (generator line 85; leaf line 6).
The package manifest seals generator and output bytes independently but does
not validate their derivation relation.  Consequently `seal_manifest.py`
passes while the generator's own reproducibility check fails.

### M4 — the public trust prose asserts nonexistent Dye assumptions

The computational companion at line 955 says that the axiom audit contains
“two explicit Dye assumptions.”  The same obsolete model is generated by
`verification/build_trust_manifest.py` at lines 451, 500, and 572 and appears
in `verification/trust_manifest.json` for rows 2, 17, and 25.  The current q11
modules instead prove the ten-point bound and equality classification, and the
55-row audit contains no Dye or other project axiom.  This is a direct public
trust-boundary contradiction, even though it understates rather than
overstates the current kernel result.

### M5 — axiom-clean does not mean assumption-free or theorem-complete

In the pinned shared module
`RelativeConicArcs/SupportOrientationCommutant.lean`, lines 107--109 define the
proposition-valued interface `ClassicalOddA5ThreePlusThreeSplitting`.  The
rational and integral commutant equalities at lines 113 and 171 take an
inhabitant of that interface as a theorem parameter.  It therefore does not
appear in `#print axioms`, but the manuscripts' unconditional commutant
conclusion is not recovered from empty hypotheses by Lean.

More broadly, the matrix shows entire human/cited/certificate/trusted rows and
partial Lean coverage in many mixed rows.  This is compatible with the main
paper's explicit “independent cross-check, not a proof dependency” boundary.
It is incompatible with calling the current pair theorem-complete under the
new Paper I standard.

### M6 — the documented aggregate replay does not close the dependency boundary

The README's release command supplies only `--lean-root`.  In that mode
`verification/verify_release.py` prints `UNCHECKED` for dependency-owned Paper
I sources but is still capable of producing `status: passed`.
`--finitegeom-root` is optional, and the direct dependency list is a hardcoded
12-file subset rather than the exact 93-module shared closure.  The runner also
embeds a bare `nix ... lake build` command, while this workspace's maintained
Lean workflow requires the guarded build queue.  The separate formal-companion
resolver correctly verifies both Git pins when both roots are supplied; the
public aggregate should make that complete boundary mandatory rather than an
optional strengthening.

### M7 — the formal package is not yet a referee-ready scholarly artifact

A uniform immediate-docstring inventory over public theorem, lemma, definition,
abbreviation, structure, inductive, and class declarations found:

| Closure part | Reviewed declarations | Missing immediate docstrings | Affected modules |
|---|---:|---:|---:|
| q11 package | 807 | 753 | 96 |
| shared dependency | 1,314 | 218 | 42 |
| total | **2,121** | **971** | **138** |

This is a conservative triage metric, not a claim that every flagged helper
must be public API.  Representative manual review confirms that the debt is
real: `Q11A5PointOrbitsFixed00.lean` has a one-line module header and 19 public
theorems without declaration docstrings, while generated row modules expose
undocumented public declarations.  Eighteen shared semantic modules have no
module docstring at all: `ExampleChecks.Q11`; `Q11SemanticDistribution`;
`Q11SemanticIndexCases`; `Q11SemanticOneAvoidance`; `Q11SemanticOneRep`;
`Q11SemanticPairAvoidance`; `Q11SemanticPairRep`; `Q11SemanticPairRepA` through
`D`; `Q11SemanticRayData`; `Q11SemanticSpectrum`; `Q11SemanticTwoRep`; and
`Q11SemanticTwoRepA` through `D`.  Forty package headers are additionally too
thin to explain the mathematical role of their module.

## Positive and negative validation

| Check | Result |
|---|---|
| Guarded aggregate gate build | **NOT ESTABLISHED BY C893**; the attempted run was refused, and the recorded run ID belonged to a concurrent q13 build; fresh replay assigned to C855 |
| 55 gate terminals versus 55 audit rows | **PASS**, exact name equality and foundational allowlist only |
| Package and shared Git pins via `verify_formal_companion.py` | **PASS**, both pinned roots |
| Package `seal_manifest.py` | **PASS**, 115 modules |
| Generator `--check` | **FAIL**, 66/66 outputs stale |
| Statement-identity extraction | **PASS**, 19 rows |
| Computational-companion aggregate | **PASS**, 12 claims, five modes, ten checks, four artifacts, seven finite-boundary claims |
| Verification-tool tests | **PASS**, 15 tests |
| All recorded checker outputs | **PASS**, 20/20 exact replay, 4m35s |
| Main and companion builds | **PASS**, 27 and 13 pages, zero warnings, tracked PDFs current |
| Current trust-manifest validator | **FAIL**, README hash mismatch |
| Standalone shared-path byte comparison | **PASS**, zero differences |

Mutation results against the minimally rebased temporary manifest were:

| Mutation | Expected | Observed |
|---|---|---|
| baseline with current README hash | accept | accepted |
| altered expected axiom | reject | rejected |
| pinned checksum drift | reject | rejected |
| omitted claim row | reject | rejected |
| stale statement count | reject | rejected |
| omitted terminal plus its local axiom entry | reject | **accepted** |

No artifact under review was edited to obtain these results.

## Bounded remediation ownership

C855 already owns every material repair exposed here; C893 creates no parallel
implementation task.

1. Reseal the current README and regenerate the release transcript only after
   all other corrections, so the authoritative aggregate is green on the exact
   current surface.
2. Make the verifier derive and compare the exact aggregate-gate terminal set,
   reject missing or extra terminals/modules, and add rejecting tests for
   terminal, closure, source-policy, and generated-relation drift.
3. Correct the Dye prose in the companion, trust-manifest generator, generated
   manifest, and any derived public document.
4. Prove the `ClassicalOddA5ThreePlusThreeSplitting` interface or weaken the
   paper-facing formal-coverage claim; complete the remaining human,
   certificate, and trusted-execution theorem surface under C855's chosen
   theorem-complete scope.
5. Make both pinned roots and the exact transitive closure mandatory for a
   passing release, and route maintained Lean validation through the guarded
   entry point.
6. Reconcile the generator's path/provenance convention, regenerate all 66
   outputs, make `--check` part of the release gate, and then repair module and
   declaration documentation across the exact closure.

## `ej` + `tt` closeout

### Easy jumps

- The highest-value cheap correctness upgrade is an exact set comparison
  between gate `#print axioms` names, manifest terminal names, and audit names.
  It directly closes the demonstrated omission exploit without changing a
  theorem.
- Running the generator's existing `--check` inside the release aggregate is a
  cheap provenance upgrade; the generator already exposes the correct
  rejection behavior.
- Requiring both pinned roots is cheaper and clearer than maintaining a
  hand-selected dependency subset.
- The stale Dye wording and README seal are mechanical only after the semantic
  boundary is corrected; doing them earlier would merely reseal a false model.

### Tao tests

- **Can an axiom audit conceal a hypothesis?** Yes.  A theorem parameter such as
  `ClassicalOddA5ThreePlusThreeSplitting` is not an axiom and therefore requires
  independent theorem-type review.
- **Does sealing generator and generated bytes prove the derivation?** No.  The
  present manifest passes while every generated output fails `--check`.
- **Does local terminal/axiom consistency prove complete gate coverage?** No.
  The omitted-terminal mutation is a constructive counterexample.
- **Does a green historical release transcript prove the current tree?** No.
  The current README hash mismatch is a constructive counterexample.
- **Is the core formal trust suspect?** No evidence found.  The exact closure,
  guarded build, source scan, and axiom comparison agree on a clean logical
  core.

### Mystery ledger

**Settled**

- There are no hidden Dye axioms, project axioms, unsafe/native evaluation
  escapes, or admitted proofs in the exact aggregate closure.
- The current aggregate source prints 55 terminals over 208 project modules,
  and the tracked axiom transcript matches those terminals exactly; fresh
  elaboration remains a distinct C855 gate.
- The release failure is precisely the README seal; the generator failure is
  precisely reproducible across all 66 outputs; and the omitted-terminal
  weakness is a verifier defect, not a speculative concern.
- The authority and standalone mirror agree byte-for-byte on all shared paths.

**Open under C855**

- Completing the sentence-level paper-to-Lean proof surface, especially the
  classical `3+3'` interface and the finite/trusted rows.
- Manually adjudicating which of the 971 docstring candidates are genuinely
  public scholarly declarations, then documenting or privatizing them.
- Choosing the final exact public closure schema after the theorem-complete
  module set changes; today's 208-module closure is the reviewed baseline, not
  permission to freeze known incompleteness.

There is no unexplained mathematical trust mystery left by C893.  The remaining
work is concrete artifact remediation and theorem completion already assigned
to C855.
