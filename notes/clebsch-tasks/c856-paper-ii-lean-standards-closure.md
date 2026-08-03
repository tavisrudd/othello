# C856 — Paper II Lean standards closure

**Lane:** `clebsch`

**Status:** complete 2026-08-02 for every project-owned surface; the four gates
and the full authoritative release aggregate are green and returned to C577.
One boundary remains outside this task's edit scope: the eight shared
projective-cap modules in the same transitive closure still carry reverse
references and undocumented public declarations, allocated to C860. Until C860
closes, "referee-ready" holds for the project-owned closure only.
Full report: `../2026-08-02-c856-paper-ii-lean-standards-closure.md`.

## Objective

Repair every gap found by the 2026-08-02 audit of the Lean added or changed
for Paper II since 2026-08-01, then re-audit the complete project-owned
closure of all four Paper II Lean gates against `lean/AGENTS.md`.

## Frozen audit baseline

The audit covered the twenty-seven changed Lean files in the combined
fifty-six-file project-owned import closure of:

- `RelativeConicArcs.Gates.ClebschArithmeticGluing`;
- `RelativeConicArcs.Gates.ClebschHilbertSymmetry`;
- `RelativeConicArcs.Gates.ClebschHyperplaneSquare`; and
- `RelativeConicArcs.Gates.ClebschPaperIIStructural`.

It found four repair classes:

1. `ClebschFixedLineRadialTranslation` assumes the three parameterwise
   Radical--Hadamard hypotheses in `RadicalHadamardFamily`; it does not derive
   their preservation from the invariant top configurations and first and
   second moments.  The trust manifest nevertheless says that Lean checks
   noncoalescent Radical--Hadamard inheritance.
2. Ten public declarations added in the audited delta lack the mandatory
   self-contained docstrings: one in
   `ClebschFixedLineRadialTranslation`, four in
   `ClebschOuterParityInjection`, and five in
   `ClebschPolynomialTopSliceDetection`.
3. The complete Paper II gate closure contains a further 116 public
   declarations without docstrings in thirteen pre-existing imported files:
   `Arc`, `Certificate`, `ClebschBalancedSheets`,
   `ClebschConicMatchingQuotient`, `ClebschGateway`,
   `ClebschHarmonicQuotient`, `CodingBridge`, `Conic`, `Defect`, `Moments`,
   `Plane`, `ProjectiveBridge`, and `SyndromeGeometry`.  The no-grandfathering
   rule makes these closure defects release-blocking.
4. `verification/verify_release.py` and
   `verification/evidence_fingerprint.json` pin an expected metadata success
   line with 28 statements, while the checked manifest contains and reports
   29; the check currently permits this stale expected-output string.

The audit found no `sorry`, explicit axiom, unsafe declaration,
`native_decide`, private workflow reference, task ID, agent/session language,
or machine-local path in the changed Lean files or the four-gate closure.
Those negative checks must be repeated after repair.

## Scope

1. Replace the fixed-line assumption gap by a reusable formal bridge whose
   hypotheses correspond exactly to the manuscript's unchanged top
   configurations, zero first moments, equal second moments, and separating
   radial level.  The bridge must derive every parameterwise
   Radical--Hadamard premise used at a noncoalescent parameter.  If some
   premise is genuinely not a consequence of those data, freeze the exact
   missing mathematical hypothesis and reconcile the manuscript and trust
   surface before claiming Lean inheritance; do not hide it in a structure
   field.
2. Give every scholarly-public declaration in each touched module a
   self-contained mathematical docstring.  Audit whole touched modules, not
   only the declarations named above.
3. Close the 116 pre-existing docstring defects throughout the complete
   four-gate project closure.  Comments must state the objects, domain,
   conventions, conclusion, and computational trust route where relevant;
   generated sources must be repaired through their owning generator rather
   than hand-edited.
4. Reconcile the fixed-line theorem, gate header and terminals, manuscript
   formal correspondence, verification README, trust manifest, checksum
   manifest, statement identity, and evidence fingerprint so that no surface
   claims more than the elaborated declarations prove.
5. Make the expected-success check derive or validate the actual 29-statement
   count, then pin the corrected output.  A stale self-consistent fingerprint
   must fail metadata-only verification.
6. Re-run the full names, pathnames, generated banners, reverse-reference,
   status-language, strength-name, trust-boundary, and public-docstring audit
   on every project-owned file in the transitive verification closure.

## Owned paths

- the Paper II-owned modules and gate under `lean/RelativeConicArcs/`;
- closure-wide prose-only docstring repairs in the fifty-six-file Paper II
  import closure, coordinated with any owning lane before touching a shared
  module;
- any owning generator, schema, template, or generated leaf required for an
  admitted generated-source prose repair;
- `papers/clebsch-factorization/verification/` and the exact formal-boundary
  prose in `papers/clebsch-factorization/clebsch_factorization.tex` if the
  repaired theorem requires it; and
- this task card, the Clebsch handoff, queue row, dated closeout report, and
  Clebsch discovery-track entry if the discriminator admits one.

The standalone `~/src/math-papers/clebsch-factorization` remains downstream.
C856 returns a validated authoritative tree to C577; C577 owns repackaging,
forward synchronization, and publication decisions.

## Acceptance gate

- The fixed-line formal theorem proves exactly the inherited premises and
  conclusion claimed by the manuscript and trust manifest, with no
  parameterwise conclusion-bearing assumptions disguised as family data.
- Every scholarly-public declaration in the complete project-owned closure
  has a self-contained docstring, and every computational theorem states its
  finite domain, kernel/certificate/native route, coverage, and residual
  trust.
- No prohibited workflow vocabulary, reverse reference, novelty claim,
  misleading strength name, unresolved repository-local reference, `sorry`,
  new axiom, unsafe declaration, or `native_decide` remains.
- All changed generated artifacts come from their tracked generators and are
  regenerated only inside the owning validated build window.
- The four documented Paper II gates pass through guarded entry points; the
  exact-target trace-current confirmation and the 54-terminal axiom audit
  pass with only the declared foundational allowlist.
- `python3 papers/clebsch-factorization/verification/verify_release.py
  --metadata-only` rejects a deliberately stale expected statement count and
  passes with the corrected 29-statement expectation.
- The complete authoritative Paper II aggregate, warning scan, PDF build,
  trust partition, statement identity, checksums, and evidence fingerprint
  pass from a clean task-owned state.
- A final independent cold audit confirms that the formal claims and trust
  prose match declaration types rather than implementation intent.

## Ordering

C856 starts before C577 repackaging.  It must coordinate any shared-library
docstring changes with the owning lanes and widen validation to every affected
reverse-import gate.  C577 resumes standalone synchronization only after C856
returns a green authoritative closure.
