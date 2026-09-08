# Complete-ports referee repairs and exposition review

Date: 2026-09-07. Lane: complete-ports.

## Scope and review standard

The user requested repair of the Astra cold-read findings, a journal-style
referee report with exposition feedback, and a direct review against
`papers/style-guide.md`. The latest direction makes the Ergodis section about
the mathematics it embodies and what this enables. Its intended publication
location remains `https://github.com/tavisrudd/ergodis`.

Primary audience: coding theorists working on concatenation, locality and
recovery structure. Adjacent readers: exact algorithms and distributed-storage
optimization. The revisions preserve the human proof spine and the existing
32-claim partition; no additional Lean coverage is claimed.

Astra's independent report on the frozen 43-page manuscript is
`2026-09-07-complete-ports-astra-cold-referee.md`; the journal-style supplement
is `2026-09-07-complete-ports-astra-journal-referee.md`. The supplement recommends
major revision chiefly for exposition, interface precision, and evidence
presentation. The later `2026-09-07-complete-ports-astra-revision-followup.md`
is explicitly a source-level follow-up, not a fresh cold read or release verdict.
Both journal reports remain private scholarly correspondence outside the paper.

## Mathematical and evidence corrections

- NONZERO-KERNEL-STATE: distinguish ordinary fibre minima from the additional
  minimum nonzero kernel lift needed to evaluate nonconfinement. The complete
  introductory formula, information diagram, confinement summary, and optimizer
  now consistently retain `d(I^perp)` via its existing recursive formula.
- MINIMAL-SUPPORT-IFF: the pointed proof retains the equivalence for exact
  support/equation confinement, and states minimal-support transfer only as a
  consequence. The stronger target-touching theorem remains separate.
- F4-TRACE-LABELS: the cost table uses the coordinate-dot-product pairing in
  basis `(1, omega)`, namely `a -> Tr(omega^2 c a)`. The common scaling preserves
  the outer linear dual subspace and the intended one-versus-two separation.
- SIMPLEX-COMPARISON: fix helper dimension and lower code `K=0`; explain
  averaging over nonzero words and then the hyperplane-multiplicity argument.
- TIMING-CONTRACT: reconcile external fresh-process timings, seven paired
  application rounds, three long-comparison rounds, one cold solve versus eight
  warm solves, and the 400-second long-process timeout. Remove the obsolete
  sub-microsecond reference and unrelated older protocol descriptions.
- SNAPSHOT-IDENTITY: `verification/artifact-versions.json` records the exact
  bytes of nine reviewed Ergodis source/doc files, three benchmark summaries,
  three raw sample files, and six unchanged Lean artifacts. Binary and runner
  identities are copied from the benchmark records and explicitly distinguished
  from the later source description. No experiment or kernel run is inferred
  from these identity checks.
- BENCHMARK-ATTRIBUTION: direct-CP-SAT comparisons measure complete approaches;
  neither the prose nor the figure attributes all gains to one reduction while
  the matched labelled-table control lacks this protocol's rerun.

The Ergodis file identities were taken from source revision
`67d929b0bf8f0be371911dd8d9cc52b193cd3d28` in the separate local repository.
The public manifest uses content hashes, not that development history as an
external citation. Each raw-sample hash agrees with its summary record.
The six Lean artifact files agree byte-for-byte with companion revision
`2d90a8b9cbb8721ea984fcd0684589096d40f5fe`.

## Style-guide assessment and applied repairs

1. **Precise theorem early.** Replace the schematic Gamma description and
   duplicate six-question table with actual definitions of both fibre minima,
   outer compatibility, and the full two-sector formula. The principal theorem
   and the distinct minimal-support transfer conclusion are both on page 2.
   The mechanism follows immediately: independent lifts in nonzero fibres;
   an external nonzero dual perturbation in the zero fibre; deletion of that
   perturbation for operational supports.
2. **Expose conventions at the language change.** State domains, recovered
   dimension, target normalization, the represented encoder, and the meaning of
   global normalized equations. The arbitrary mu fibre inherits map domains,
   not the inner-duality constraint. State finite attainment, not attainment of
   empty minima. Define rho_T where the quotient-lifting discussion first uses it.
3. **Preserve hierarchy.** Move detailed measurements to verification scope.
   Remove the campaign/browser/CSS feature inventory. Keep the optimizer,
   antichains, price/availability equivalence, width bound, and bilinear example
   together as mathematical consequences. Retain one information diagram after
   the principal results. Shorten the abstract's secondary-result catalogue.
4. **Explain what Ergodis enables.** Lead with functional compatibility,
   executable coefficient lifts, alternatives for changed prices/failures, and
   shared capacities. The final algorithmic subsection explains repair
   selection, workload allocation, reuse, and the distinction between a feasible
   witness and an optimum certificate. It does not claim full-oracle completeness
   merely from an option-consuming scheduler.
5. **State the observation contract once where needed.** The introductory
   numerical contextual congruence fixes the target leaf and induced target
   image; it does not silently promise overlap or arbitrary repricing.
   The simplex reliability paragraph distinguishes some recoverable target
   space from a fixed prescribed space.
6. **Legible secondary evidence.** Split the excessively reduced six-column
   application table into timing/control and instance/output panels at readable
   size. Pin sources without adding a publication-availability warning. Give
   the independent executable checkers their precise contract in verification;
   retain the limited Lean coverage and correct the human-only count to 31.
7. **Standalone identity.** No citation to the programme summary is introduced.
   The programme coda is self-contained. Journal reports remain outside the
   distributed artifact.

Astra's follow-up confirms that the new section reads as an algorithmic
consequence of the recovery theorems and that the introductory result is now
evaluable. Its local normalization, benchmark-attribution, checker-reference,
finite-attainment, and figure-terminology comments have been addressed.

## Verification and remaining review boundary

The deterministic paper gate is the unchanged `make update-pdf` / `make check`
route: warning-free TeX, exact 43-page pin, 32 registered claims, four unchanged
Lean terminals, and bytewise equality against a fresh build. No Lean/lake or
benchmarks were executed for this repair. The artifact identity comparison
checked all 15 Ergodis file hashes and all six Lean file hashes against their
specified source versions. `git diff --check` covers the edited paper surface.

The frozen baseline PDF has SHA-256
`3f7915129e8fbffc48b7799dc959d4d490ea2bff7d28ee906b9ae4fd1bedcbc7`
at authority revision `82f252fcd`. Before/after rendering copies are retained
in the disk-backed cache `~/.cache/complete-ports-revision/`.
Direct visual inspection covered revised pages 1–3, 26, 30, 37, and 39–41:
opening, algorithm and decision discussion, formal boundary, measurement table,
figure, and conclusion. Every page has extracted text; this is not a claim of
an exhaustive page-by-page typography audit. The aggregate submission audit,
including independent primary/adjacent-reader comparison, remains C953 after
C325. The optional deeper expansion of the reliability realization proof is
also for that complete proof/exposition audit, not a newly asserted defect.

## Closeout: ej + tt and mystery ledger

The cheap strengthening was to make the corrected interface evaluable at first
use, rather than only repair the later formula caption. It exposed a second
presentation hazard: reusing `(alpha,beta) as above` could accidentally import
inner-duality into a nonzero prescribed fibre. Explicit domains and constraints
settle that ambiguity. Moving the software evidence also exposed unsupported
causal speedup wording, now narrowed to the measured end-to-end comparison.

No new mathematical mystery remains from these repairs. The distinction
between coefficient confinement and operational support transfer is explained
by deletion of irrelevant external equations. The stronger catalogue theorem,
implicit construction costs, full pricing integration, and bandwidth interfaces
remain scoped research directions, not claims established by this revision.
The next acceptance boundary remains the lane's existing C325/C953 route.

Final authority gate: PASS (deterministic update plus fresh comparison).
Final PDF SHA-256: `ab3b881acc1fce532f9414d1c6e1ff84fb3f02f5eb06adee9e78a449513d3df9`.

Mirror synchronization: authority `2f4f82de5` exported through the guarded tool
and adopted by ordinary forward commit `2d5b252` in compositional-recovery.
All 43 distributed files agree byte-for-byte. Mirror `make check` and exporter
verification pass; exported content SHA-256 is
`e7ac0fd66044f95c0c8f85fa56a99c1266dcc8c9f2774b6940d90b533564bff2`.
No push or deposit was performed.
