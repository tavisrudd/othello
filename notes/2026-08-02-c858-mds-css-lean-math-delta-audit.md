# C858 — Paper II Lean and mathematical delta audit

**Lane:** `ame-lu`

**Status:** complete; remediation required under C859

**Audit window:** 2026-08-01 00:00 PDT through 2026-08-02

## Verdict

**FAIL for formal/release readiness; PASS for the mathematical manuscript and
paper-local computation boundary.** I found no false theorem, changed constant,
hidden finite premise, or new unsupported mathematical conclusion in the
audited Paper II delta. The all-length multiplier/nullity theorem remains
conceptual, the exact group theorem retains its odd-prime, fixed-party scope,
and every finite application remains separated from that headline theorem.

The paper is not yet compliant with the repository's formal-companion and
referee-facing artifact standards. It has no Paper-II-specific semantic gate,
axiom audit, recursive formal-root contract, registered Lean-terminal set, or
tracked paper-facts artifact. Three public surfaces describe those missing
artifacts as future work. The internal theorem map also became false when the
minimum-support atlas import was made explicit. C859 is the required
remediation item; its exhaustive checklist is
`notes/2026-08-02-c859-mds-css-formal-remediation-checklist.md`.

## Audited delta

Paper II was introduced in commit `1ce760c1` on 2026-08-02 and subsequently
received the split-boundary, provenance, standalone-neutrality, lint, and DOI
repairs in `b3525c21`, `b5d7a4df`, `07e195d0`, `b00ef327`, and `c0b7a0bc`.
Accordingly, the mathematical audit covers the complete
`papers/mds_css_transversal_groups` tree, not merely later diffs.

Seven Lean modules changed after the cutoff:

- `ApproximateSymmetryDecomposition.lean`;
- `LocalGeneratorDecomposition.lean`;
- `ProductUnitaryExponential.lean`;
- `SiteOperators.lean`;
- `TwoUniformDiscreteness.lean`;
- `TwoUniformIsometry.lean`; and
- `TwoUniformProductSymmetry.lean`.

Their exact import closure terminates at
`RelativeConicArcs.Gates.AMELUTwoUniformRigidity`; none is imported by
`RelativeConicArcs.Gates.AMELUAggregate` or by any Paper II gate. They are the
Paper I quantitative/two-uniform chain and are therefore outside Paper II's
semantic delta. This separation must be preserved when C859 creates the
Paper II gate.

The Paper II formal crosswalk currently names eleven relevant shared modules:
`GenericDefinitions`, `GenericMDS`, `GenericDiagonalTensor`,
`DiagonalIsoduality`, `EncoderTransversal`, `LUPencilClassification`,
`ExtensionFieldPencil`, `SyndromeGeometry`, `MarginalMoment`,
`TransportDivisor`, and `PartyExtensionSplitting`, together with the existing
dictionary, logical-phase/four-copy, and focused import gates. I reviewed the
complete headers, terminal statements, conditional-input structures, and
existing gate/axiom surfaces for those claims.

## Findings

### F1 — Paper-specific formal closure is absent (release blocker)

The internal formalization ledger explicitly names the intended roots at
`papers/mds_css_transversal_groups/formalization-ledger.md:3`, but neither
`RelativeConicArcs.Gates.MDSCSSTransversalGeometry` nor its axiom-audit module
exists. The only broad candidate is `AMELUAggregate`, whose imports at
`lean/RelativeConicArcs/Gates/AMELUAggregate.lean:1` mix Paper I rigidity,
atlases, topological symmetry, and Paper II applications. Its own header
confirms that mixed scope at lines 24--69. It cannot serve as Paper II's release
contract.

This also means there is no exact Paper II terminal list whose transitive
closure can be reviewed, built, axiom-audited, hashed, or exported. The
shared-library exit standard is therefore unmet even though the individual
modules state their conditional hypotheses honestly.

### F2 — Trust registry and generated paper facts are incomplete (release blocker)

The Paper II registry row at `lean/trust/papers.toml:116` declares only the ID,
directory, main source, and lane. It has no `adopted_labels`, verification
manifest, manifest-label path, or `lean_terminals`. The read-only command

```text
python3 lean/scripts/paper-facts.py check --paper mds_css_transversal_groups --json
```

reports `paper-facts-missing` for
`lean/trust/paper-facts/mds_css_transversal_groups.json`. It also reports two
title-drift errors in the portfolio index/work summary, one self-citation title
drift in `papers/beyond4_prs/refs.bib`, and a warning that the generated `.bbl`
reaches the PDF without a tracked reproducibility declaration. The cross-lane
findings must be repaired by their owners or explicitly coordinated; they may
not be silently waived.

### F3 — Public verification prose contains prohibited planning/status language

The exported README says the gate and manifest are “intentionally deferred”
at `papers/mds_css_transversal_groups/README.md:27`. The manuscript says they
are “scheduled” at
`papers/mds_css_transversal_groups/sections/08-verification-boundary.tex:33`.
The public supplement says the terminals “will be” and “must” be created at
`papers/mds_css_transversal_groups/supplement/EVIDENCE.md:52`, then refers to
the “future semantic gate” at line 72. These sentences truthfully avoid a false
coverage claim, but the referee-facing standard forbids workflow plans and
forecasts in an enduring artifact. After the formal roots exist, all three
surfaces must state the present-tense, content-addressed verification boundary
instead.

### F4 — Theorem ownership map is stale after the atlas repair

The introduction now states the imported minimum-support atlas at
`papers/mds_css_transversal_groups/sections/01-introduction.tex:84`, and the
pencil proof uses it at
`papers/mds_css_transversal_groups/sections/04-pencil-classification.tex:104`.
The cross-paper ownership ledger already assigns that result to Paper I.
However, `papers/mds_css_transversal_groups/theorem-map.md:3` still says there
is only one imported Paper I dependency, and lines 20--22 say the paper excludes
minimum-support classification except for the rigidity/no-go input. The map
must add the atlas import and distinguish it from the separately imported
rigidity, encoder no-go, and Pauli phase correction.

### F5 — Lean source hygiene is acceptable within the reviewed Paper II surface

The relevant module headers identify ambient fields, objects, theorem scope,
conditional structures, and trust routes. Bounded scans found no `sorry`,
project-local axiom declaration, task ID, agent/lane/session reference, private
filesystem path, or hidden generated input. Public non-obvious structures and
terminal theorems have mathematical docstrings; the undocstringed hits are
routine `[simp]` evaluation lemmas. `MarginalMoment` correctly discloses its
three exhaustive `native_decide` graph counts, while the other reviewed modules
state kernel checking or explicit hypothesis/certificate inputs. No source
rename or declaration-strength defect was found.

This is a source review, not a release-ready closure review: without F1, the
required transitive referee-facing audit and exact axiom record cannot be
completed.

## Validation evidence

- `make check` in `papers/mds_css_transversal_groups`: PASS; 17 evidence
  artifacts verified, 14 TeX files linted, and the 22-page XeLaTeX target is
  current.
- `python3 supplement/verify.py --replay`: PASS; all 17 artifacts verified and
  all eight evidence bundles regenerated and compared successfully.
- Standalone `~/src/math-papers/mds-css-transversal-groups`: clean at
  `1057d12`; no audit mutation was made there.
- Initial guarded single-file elaboration: inconclusive because the local
  `AMELUDefinitions.olean` dependency was absent.
- Managed exact build request for `AMELUAggregate` and
  `AMELUAggregateAxioms`: safely refused before mutation because a foreign Lean
  build owned the tree. Per the ownership rule it was not stopped, bypassed, or
  resubmitted. C859 must obtain fresh guarded builds and actual `#print axioms`
  output for the new Paper II roots.

## Mathematical conclusion

The proof/evidence partition added yesterday is coherent: conceptual
all-length results do not depend on the six-point census; prime-field LU/LC
claims are not extended to extension fields; conditional Lean interfaces do
not masquerade as unconditional reconstruction theorems; and the certificate
replay supports exactly the finite domains advertised. The audit therefore
opens no mathematical correction item beyond reconciling the already-correct
atlas import in the ownership maps.

The blocker is formal publication engineering and its public description, not
the mathematical statements. C859 must close every item in its checklist
before Paper II is described as formal-companion-ready or release-ready.

## Discovery discriminator

No incidental mathematical lead arose outside the requested audit. Nothing
was added to the discovery track.
