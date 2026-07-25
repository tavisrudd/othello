# C545 — R5--R7 Lean trust-boundary reconciliation

**Lane:** `reed-solomon` · **Date:** 2026-07-25 · **Status:** local gate green

## Result

The adopted redundancy-five through redundancy-seven manuscript now has one
scope-exact formal and executable trust route. The repair changes no
mathematical declaration, theorem type, hypothesis, proof, certificate
semantics, or manuscript conclusion. It separates the shared finite-coordinate
contraction API from the companion redundancy-nine residual-quadratic module,
then makes the paper maps, verifier, evidence bundle, citations, and release
records agree with that closure.

This is a local pre-release repair. It does not authorize a public export,
identifier reservation, account action, preprint upload, or journal
submission.

## C603 finding closure

| C603 finding | Repair | Rechecked boundary |
|---|---|---|
| G1: obsolete R5--R9/Hessian/Lucas aggregate | The aggregate now directly imports only `PRSFoundation`, `PRSRedundancyFive`, `PRSPolarInductionRedundancySixSeven`, and `PRSStableComponents`. `PRSContraction.lean` holds the shared finite-coordinate API; `PRSFoundation.lean` no longer imports the residual-quadratic module. | The axiom-audit closure has exactly 15 project-owned files: six gates and nine mathematical modules. It excludes residual-quadratic, R8, R9, Hessian, general Lucas, and degree-nine endpoint modules. |
| G2: 11 missing and 24 obsolete statement rows | `supplement/LEAN-STATEMENTS.md` now has exactly one row for every retained label and no companion-work row. | Recursive TeX include resolution finds exactly 35 labels; the verifier requires set equality. |
| G3: R7 point-count overstatement and stale degree 24 | The `prop:r7-pointed` row now says that Lean consumes `lowerWitness`; genus/deletion fields are recorded but do not derive it. The manuscript proof retains the corrected \((g,\delta,\kappa)=(1,25,1)\). | The elaborated `CoherentPolarInput.splitFree_implies_persistent_or_modular` proof uses `lowerWitness`; the paper itself derives the point from Aubry--Perret and deletion degree 25. |
| G4: adoption/formalization/release ledger drift | The theorem map, claim/proof ledger, formalization ledger, verification map, README, certificate schema, reproduction guide, release manifest, and supplement generator now use the R5--R7 scope. | No obsolete certificate label or stale 24/47/48/103/113 count remains in the operative public maps. |
| G5: external dependency pinpoints | The manuscript and public dependency ledger now pinpoint Seroussi--Roth Theorem 1, Kaipa Proposition 1 and Theorem 2, Zhang--Wan--Kaipa Lemma II.4 and Theorems I.4--I.6, Aubry--Perret p. 468, Gmainer--Havlicek Lemma 1 and Theorem 1, and Wang Theorem 3.6. | The two formerly weak sources were checked against primary PDFs and added to the shared cache. |

## Exact Lean closure

The six gate files are:

- `RelativeConicArcs.Gates.PRSFoundation`;
- `RelativeConicArcs.Gates.PRSRedundancyFive`;
- `RelativeConicArcs.Gates.PRSPolarInductionRedundancySixSeven`;
- `RelativeConicArcs.Gates.PRSStableComponents`;
- `RelativeConicArcs.Gates.PRSBeyondRedundancyFour`; and
- `RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit`.

The nine mathematical files are:

- `RelativeConicArcs.PRSContraction`;
- `RelativeConicArcs.PRSFoundation`;
- `RelativeConicArcs.PRSRedundancyFive`;
- `RelativeConicArcs.PRSRedundancyFiveCertificate`;
- `RelativeConicArcs.PRSRedundancyFiveCertified`;
- `RelativeConicArcs.PRSPolarInduction`;
- `RelativeConicArcs.PRSRedundancySixSeven`;
- `RelativeConicArcs.PRSRedundancySixSevenCertificate`; and
- `RelativeConicArcs.PRSStableComponents`.

`PRSContraction.lean` preserves the established
`RelativeConicArcs.PRSResidualQuadratic.dividedPowerContraction*`
declaration names and their proofs. Moving those declarations changes only
their source module. `PRSResidualQuadratic.lean` imports the shared module, so
the companion R9 API is unchanged.

The adopted axiom audit contains 53 exact `#print axioms` targets. The
paper-local verifier pins their ordered target-list hash to
`106c846bdd0f80ed3993b6ec7e9e2b3fc318c1b9a7adce2c7d4c4c2364e69f49`
and separately pins the exact 15-module transitive closure.

## Lean/prose proof reconciliation

| Paper mechanism | Lean statement | Agreement |
|---|---|---|
| Hankel and radius dictionary | `PRSFoundation.HankelKernelDictionary` and `CoveringRadiusInput` terminals | Lean proves implications from an abstract concrete-dictionary/radius interface; the manuscript proves or cites the concrete bridge. |
| Polar contraction and lifting | `PRSPolarInduction.iteratedProjectiveSequenceContraction_map`, `sequenceContraction_agrees_with_finite`, and `PointedKernelLift.lift_splitSquarefreeKernelMember` | The checked coordinate and lift logic matches the displayed divided-power contraction. Concrete polynomial/kernel identification remains a paper input. |
| One-step escape | `CoherentPolarInput.splitFree_implies_persistent_or_modular` | Lean chooses a marker outside two finite sets and consumes `lowerWitness`. The paper proves `lowerWitness` from integrality, Aubry--Perret, deletion bounds, and squarefree lifting. The numerical fields are not described as proving the witness in Lean. |
| R6 | `redundancySixHighFieldSynthesis` with `q≥29`, budgets `7` and `6`; `redundancySixAllFieldSynthesis` | These are exactly the paper's one-marker threshold and finite-bridge structure. Geometric components, actions, radius, and certificate semantics remain inputs. |
| R7 | `redundancySevenHighFieldSynthesis` with `q≥37`, budgets `4` and `8`; `redundancySevenAllFieldSynthesis` with `q≥11` | These match the paper's high-field and radius-gated coding claims. The paper's two-marker deletion degree 25 is manuscript mathematics, not a hidden Lean conclusion. |
| Stable components | the ten audited `PRSStableComponents` factorization, coherent-Fano, modular-kernel, and block-coverage terminals | Lean checks the coordinate identities. Density, projective row-space transport, saturation semantics, and component exhaustion remain manuscript/Certificate SC proofs. |

No prose proof was shortened or replaced by the module split. The only TeX
changes add statement-level citation locators and preserve every mathematical
formula and conclusion.

## Public evidence and dependency repair

The paper-local evidence pack now has 42 artifacts and only five public
certificate families: R5, R6, R6-NF, R7, and SC. The repack removed public
copies of R8, R9, R9-49, Hessian, Lucas, and `e7` evidence. Their development
sources remain tracked and unchanged outside the paper export.

The primary Seroussi--Roth scan was checked at Theorem 1 and its corollary and
cached as `10.1109/TIT.1986.1057188`, SHA-256
`0b5c152819f91d5e410146ada3527b5b795a55fc6170c14a27e43b8c3e39a5f9`.
The Aubry--Perret article was checked at the arithmetic-genus point bound on
p. 468 and cached as `10.1007/BF02567835`, SHA-256
`e189e1897b06c5de5018e4b0d5538aec4303ec71839d37fa5b023285c6387c37`.
The literature ledger records both at partial read depth. No novelty verdict
or absence claim was changed.

## Validation

- `python3 supplement/verify.py`: pass; exact 35-label set, four direct Lean
  imports, 15-module transitive closure, 53-target audit hash, 42-artifact
  evidence manifest, classification-record extraction, R6 paper table,
  classification hashes, and local release rows all pass.
- `make check`: pass; canonical PDF rebuilt to 33 pages,
  252,752 bytes, SHA-256
  `058f6c859724e10580b59153328b1c9c4e79e6e8599b0ad104397dcc87cc7afa`.
- `make tit-check`: pass; the IEEEtran single-column review build is 25 pages.
- Lean guarded queue
  `/home/tavis/.cache/othello-lean-build/run-20260725-163716-2ec723b6`:
  foundation audit, adopted aggregate audit, and companion R9 regression
  audit elaborate; the exact R5--R7 and R9 import gates pass trace-only
  currentness.
- The 15-file closure has no `sorry`, declared project axiom, unsafe
  declaration, or native decision; the new module passes the referee-facing
  prose and naming review.
- `git diff --check` on every owned source passes.

## Release verdict

The C603 R5--R7 local trust boundary is reconciled and release-unblocking.
C545 remains externally blocked on the publicly fetchable flake-pinned Lean
revision, exact paper-only public export and immutable identifiers, two final
independent specialist signoffs, and author/account confirmation. The public
release checker remains fail-closed.

## External-release preparation follow-up

The paper supplement now contains
`supplement/prepare_release_export.py`, a deterministic fresh-history exporter.
It refuses dirty release-owned source or an existing destination, archives the
committed paper tree and exact 15-module Lean closure, and creates separate
paper and Lean repositories. Two independent runs from source commit
`ec39cf0fce475077fc28942c454c308b39845664` produced paper commit
`07da7e76ba9703fd87b6edfe71390fecabc65a99` and Lean commit
`dddf7a8dc1a7fd6f4c079f09ef4fd3a73dd8256c` both times. The exporter uses
separate last-modification timestamps for the paper and Lean allowlists, so
unrelated repository work and paper-only edits do not perturb the Lean commit.
The resulting paper candidate passed the
43-artifact quick verifier and rebuilt the 33-page canonical and 25-page TIT
PDFs byte-for-byte; both repositories remained clean after the builds. The
full paper-local replay also passed from a clean exported candidate in
7 minutes 24 seconds. Later changes touched only the release gate and exporter,
not any replay program, input, certificate, or acceptance criterion.

The final-reader form now names only the retained R5--R7, polar-induction, and
stable-component boundaries. The release verifier additionally requires the
two readers' candidate commit and canonical PDF hash to equal the release
manifest. This closes a false-green route in which signoffs for the former
R5--R9/Hessian/Lucas scope, or for a different candidate, could have satisfied
the string-level gate.

The same-day policy recheck remains favorable but does not replace account
confirmation. IEEE's current Author Center policy permits preprints on arXiv,
TechRxiv, or another PSPB-approved not-for-profit server and does not treat
them as prior publication
(`https://journals.ieeeauthorcenter.ieee.org/become-an-ieee-journal-author/publishing-ethics/guidelines-and-policies/post-publication-policies/`,
checked 2026-07-25). Zenodo's current documentation states that a published
record receives a DOI and permits reserving that DOI in advance
(`https://help.zenodo.org/docs/get-started/quickstart/` and
`https://help.zenodo.org/docs/deposit/describe-records/reserve-doi/`, checked
2026-07-25).
No upload was performed: this checkout has no Git remote, GitHub or Zenodo
credential, author/account confirmation, or final independent-reader
attestation. The tracked release flake also still lacks the required public
`finitegeom` input; it can be locked only after the exact Lean revision is
publicly fetchable.

## Extra-juice and Tao closeout

The closeout asked whether a direct-import check alone could regress while
remaining green. It could: `PRSFoundation` had still imported the whole
residual-quadratic module. Splitting the contraction API reduced the actual
paper closure without renaming a declaration or changing a theorem. The
verifier now checks the complete transitive closure, so reintroducing that
coupling fails locally.

The same pass tested whether citation pinpoints merely decorated the prose.
They do not: they now identify the exact external statements that supply the
radius, point-count, coding-dictionary, persistent-family, Lucas, and
factorization inputs, while the formal ledger says precisely which remain
Lean hypotheses.

## Mystery ledger

Settled:

- **Could the adopted aggregate exclude companion gates but still import
  companion mathematics transitively?** Yes before this repair; no afterward.
  The shared contraction split and exact closure check settle it.
- **Did the structural Lean change alter a paper proof or formal type?** No.
  All contraction names and proofs are preserved; R6/R7 terminal types and
  manuscript formulas are unchanged.
- **Does Lean derive the R7 point-count witness from deletion degree 25?** No.
  The paper does; Lean consumes `lowerWitness`. Both public descriptions now
  say so.
- **Are the load-bearing literature statements pinpointed and checked?** Yes,
  including the two primary-source gaps identified by C603.

Open, with owner and gate:

- **What immutable public Lean revision and export commit will carry this
  closure?** The deterministic local candidates now exist, but C545's
  public-export gate still requires authenticated publication and a
  publicly resolving `finitegeom` flake lock.
- **Will both final independent specialists sign the exact repaired
  artifact?** C545's reader-signoff gate.
- **What DOI/archive/account metadata will identify Version 1?** C545's
  irreversible external-release gate and author confirmation.
- **Can the public release checker close without the exact reviewed bytes?**
  No. It now binds both reader records to the manifest's export commit and
  canonical PDF hash; public URL and DOI resolution remain external facts.

No incidental finding met the discovery-track discriminator.
