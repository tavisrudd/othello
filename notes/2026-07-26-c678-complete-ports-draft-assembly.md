# C678 complete-ports modular draft assembly

**Lane:** `complete-ports`

**Status:** COMPLETE — the theorem-backed draft is modular, the MDS reconstruction theorem is
visible across pages 1--2, finite evidence is appendix-only, the paper/control ledgers agree, and
the TeX, Lean, and area-local trust gates pass.  C325 owns the consolidated appendix verifier next.

## Closeout report

The active driver now contains only the preamble, abstract, introduction, page-1 MDS theorem,
module imports, disclosure, and bibliography.  The mathematical dependency order is frozen in
eight files under `papers/complete-repair-ports/sections/`: complete ports, confinement/transfer,
positive-density realization, reliability/EXIT, pointed Tutte, geometric applications,
mathematical conclusion, and the formal-verification/finite-evidence appendix.  Geometry therefore
follows the general reconstruction, transfer, and reliability theory instead of organizing it.

The opening states `thm:mds-reconstruction` as an actual theorem.  Its proof immediately follows
the coefficient-port and reconstruction-radius definitions and uses the common-core/private-pivot
basis argument.  In the rebuilt PDF the statement begins on page 1 and finishes at the top of page
2.  Every theorem-like environment now has a stable semantic label.

The helper protocol is explicit: each contacted helper transmits its stored scalar in
`\(\mathbb F_q\)`, the decoder applies the normalized recovery coefficient, and no subsymbol-access
or minimum-bandwidth assertion is made.  The bounded-EXIT proposition remains a bounded-query
decoder statement; full symbol-MAP and capacity language remain excluded.

All exact field-nine rows, the strict Singer-shifted calculation, harmonic finite profiles, and
finite propagation witnesses now live in the evidence appendix.  The body retains only the
theorem-level consequences and explicit appendix pointers.  No main-body theorem uses a
certificate, generated table, replay, or finite profile.

The theorem map, claim/proof/novelty ledger, formalization ledger, statement-adequacy table, and
verification map now match the printed order and scope.  In particular, the probability layer is
no longer stale-pending after C675, and the cubic application is reconciled with its exact
characteristic-three, `q >= 9`, small-circuit, row-invariant, and all-symbol-gap Lean chain.

Validation:

```text
nix shell nixpkgs#tectonic -c tectonic complete_repair_ports.tex
  PASS — 17-page PDF; no TeX warning, unresolved reference, or bibliography drift

lean/scripts/lean-build-queue.py build \
  RepairPorts.Gates.CompletePorts RepairCodes.AxisTwistedCubicInvariants --cores 20-23
  PASS — aggregate gate passed; CompletePorts current; cubic invariants rebuilt

python3 scripts/lean-trust-spine.py audit --area complete_ports
  PASS — 0 error, 0 warn, 0 info

nix develop path:.#manuscript --command make TEXSHELL= check
  PASS — pinned XeLaTeX build, 17 pages, clean final warning scan

python3 papers/scripts/export-paper-repos.py plan \
  --source-ref HEAD --repository complete-repair-ports
python3 papers/scripts/export-paper-repos.py audit \
  --source-ref HEAD --repository complete-repair-ports
  PASS — 18 selected files, 9 explicit private exclusions, 0 reference findings
```

The manuscript milestone is commit `9033d5103`, made with the complete explicit C678 path list.
Paper-local `.zenodo.json` metadata now supplies the canonical title, abstract-level description,
author ORCID/affiliation, the approved MIT license, preprint type, and subject keywords.  It
does not create a deposit, DOI, release, or public repository.

The paper package now follows the standalone-paper surface used elsewhere in the repository:
external-reader-facing `README.md`, tracked PDF link, pinned `flake.nix`/`flake.lock`, warning-failing
`make check`, and a tracked `LICENSE`.  `papers/repositories.toml` selects the PDF and excludes every
private review, proof-development, adequacy, and cold-read file.  The C275 allowlist is reconciled
with the modular sources and executable exporter.

`referee-dossier.md` is the private cold-read context.  It separates coding/storage, matroid/Tutte,
finite-geometry, probability, formal-verification, and adjacent-reader lenses; fixes the paper's
nonclaims; and requires isolated reports with page/semantic-label findings and explicit
`GO`/`MINOR`/`MAJOR`/`BLOCK` verdicts.  The exporter excludes it.

## Extra value and expert-pressure pass

The storage-model pressure pass changed the paper at the right interface: coefficient-valued
repair is now a concrete scalar download protocol, while array-code access and bandwidth are
identified as different optimization problems.  The exposition pass also promoted MDS
reconstruction from a roadmap promise to the opening theorem and separated the mechanism paragraph
from its formal common-core proof.

The evidence pass exposed a structural problem in the monolithic draft: several paragraphs called
themselves appendix-only while still occupying the geometric body, and verification followed the
geometry as an ordinary numbered section.  Physical modularization and `\appendix` now enforce the
claimed proof/evidence boundary rather than merely describing it.

## Mystery ledger

- **Settled:** a complete uniform MDS support clutter does not prevent reconstruction.  The
  target-normalized coefficient words with a common `k-1` helper core and private pivots form a
  basis of the dual.
- **Settled:** the page-2 promise was not previously backed by a printed theorem statement.  The
  theorem is now in the introduction and its proof is the first load-bearing proof in Section 2.
- **Settled:** modular source order and rhetorical order can differ at the end: the mathematical
  conclusion is read before the verification appendix, although its file is `08-conclusion.tex`.
- **Boundary made explicit:** the strict field-nine, Bernstein/EXIT, Poisson, and propagation data
  remain evidence-only.  C325 must supply their consolidated manifest and independent replay.
- **No open C678 mathematical mystery remains.**  Public export, consolidated executable evidence,
  and final draft-readiness audit remain with C325/C679 and the existing release gates.

## Objective

Assemble the theorem-backed revision of *Complete Bounded Repair Ports: Local Memory, Transfer,
and Reliability* as a modular manuscript.  Put the general reconstruction theorem and MDS
coefficient-port example on page 2, keep transfer, reliability, bounded EXIT, and pointed Tutte in
the main theorem spine, subordinate the Clebsch, cubic--axis, and quartic--nucleus geometries to
applications, and move every surviving computation, finite table, certificate, replay command,
and field-specific witness into explicit appendices.

No main-body theorem may depend on a finite certificate.  The manuscript theorem hierarchy,
formalization ledger, statement-adequacy table, verification map, and claim/proof/novelty ledger
must agree with the final section order and scope.

## Required expert lens

Use the paper-specific dossier `papers/expert-profiles/05-complete-repair-ports.md`.  Final assembly
requires the Yaakobi/Tamo operational-storage read: distinguish coefficient-valued repair from
support-only locality, state the helper-download model, and avoid interpreting bounded repair as
full symbol-MAP decoding or a capacity theorem.

## Assembly constraints

- Lead with the coefficient-port object, intrinsic reconstruction radius, and the MDS common-core
  reconstruction theorem.
- Present exact pointed confinement and positive-density transfer only after reconstruction is
  established.
- Keep finite reliability, bounded EXIT, and the pointed Tutte specialization theorem-led and
  independent of exact finite profiles.
- Treat Clebsch, cubic--axis, and harmonic quartic--nucleus systems as applications of the general
  theory, not as the organizing spine.
- Put all exact finite rows, Bernstein/EXIT tables, propagation witnesses, enumerator outputs,
  hashes, and replay instructions in appendices with explicit evidence-only labels.
- Preserve the C676 filtration boundary and C677 characteristic-three/nucleus boundary exactly.
- Do not restore C220's omitted claims, full-MAP language, capacity claims, or harmonic-cascade
  threshold claims.

## Owned paths

- `notes/2026-07-26-c678-complete-ports-draft-assembly.md`;
- `notes/handoffs/2026-07-17-complete-ports-paper.md` and the live/archive task queues at closeout;
- `papers/complete-repair-ports/complete_repair_ports.tex` and its tracked PDF;
- modular sources under `papers/complete-repair-ports/sections/`;
- the complete-ports theorem, proof, novelty, formalization, adequacy, and verification ledgers;
- paper-local README and bibliography only where final assembly requires reconciliation.

Shared Lean, certificate generators, generated evidence, other manuscripts, and public standalone
repositories are outside this task unless a defect is first recorded and separately routed.

## Acceptance gates

1. The page-2 reconstruction/MDS promise is visible in the rebuilt PDF.
2. The main body contains complete human proofs for every admitted theorem and no certificate
   dependency.
3. Geometry is visibly subordinate to the general repair-port theory.
4. Every computation and replay description is confined to an explicitly labeled appendix.
5. All complete-ports control ledgers match the final theorem order and scope.
6. The aggregate Lean gate and area-local trust audit remain green without changing their theorem
   meanings.
7. The manuscript rebuilds without TeX warnings, unresolved references, or bibliography drift.
8. Operational claims pass the Yaakobi/Tamo storage-model pressure test.
9. Extra-value and expert-pressure closeout records a mystery ledger.
10. Lifecycle closeout archives C678, advances routing to C325, and commits only explicit
    task-owned paths.

## First move

Inventory the current TeX body by theorem, proof, application, and computational evidence.  Freeze
the desired modular section order before moving prose, then make the smallest sequence of section
extractions that preserves labels and bibliography keys.
