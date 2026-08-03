# C845 Golden full-forward export preparation

**Lane:** `golden`

**Status:** source preparation committed; canonical Lean export stopped at a missing guarded exporter contract

## Result

Commit `ee60800ccd611afbbc0ccc391335217ff2ce72a0` is the immutable
authoritative source checkpoint for this preparation pass. It adds the
import-only gate `RelativeConicArcs.Gates.GoldenQuantumStatistics`, declares
its four exact terminals in the monorepo trust spine, and makes the paper
exporter's tracked-PDF disposition explicit as `immutable-source`.

No file under `/home/tavis/src/math-papers/golden-quantum-statistics`,
`/home/tavis/src/lean/finitegeom`, or the superseded
`/home/tavis/src/lean/finitegeom-golden-quantum-statistics` clone was edited.
No remote, branch, tag, or repository history was advanced.

## Formal-coverage ledger

The optional companion exposes four symbolic commutative-ring identities:

| Formal terminal | Manuscript correspondence | Boundary |
|---|---|---|
| `signedTriangle_sq_entries` | signed-triangle square used in the small-order step of `thm:general-exchange-rigidity` and the proof of `thm:exchange-boundary` | mechanism only; it proves neither theorem |
| `crossGramDet_eq_sixteen` | determinant `16` for the balanced cross Gram matrix underlying the `16/125` exterior-sector value | scalar specialization only |
| `traceContraction_eq_twelve` | trace contraction behind the balanced fourth-word calculation | scalar specialization only |
| `fourthWordTrace_from_block_formula` | substitution into the order-six block formula, giving `-42` | checker-side identity, not an independent manuscript theorem |

Everything else in the sixteen-page manuscript remains human, cited, or
certificate-backed rather than Lean-backed:

- `thm:orbit-boundary`, `prop:unique-orientation-carrier`, and the
  orientation-chambers corollary;
- the full all-orders statement, purity formula, inclusion/Ramsey converse,
  and equality boundary of `thm:general-exchange-rigidity`;
- the spectrum, symmetric-function values, Schur--Weyl checksum, and
  orientation-blind conclusion of `thm:exchange-boundary` beyond the four
  scalar mechanisms above;
- `thm:continuous-control`, `thm:hermitian-landscape`,
  `thm:squared-rigidity`, and `prop:balance-obstruction`;
- the Greaves--Suda aligned design, Johnson mean/variance formulas, order-ten
  cut split, and Paper-III collective inverse statement;
- the six sign words, distance-six code, three- and five-cut schedules,
  nearest-word radius, and calibrated orientation convention;
- the Givens decompositions, exact and rounded netlists, fifteen-cell direct
  compilation, filtered mesh, and numerical reconstruction bounds;
- coherent-transfer tomography, gain/orientation calibration, structural
  residuals, determinant-error bound, and identifiability claims; and
- all feasibility, photon-source, fidelity, indistinguishability,
  copy-matching, analyzer, shot-budget, and experimental design-limit clauses.

The public description must therefore be “optional formal companion for four
symbolic balanced-cut mechanisms.” It must not say that a manuscript theorem
is fully formalized or depends on Lean.

## Paper exporter gate

The paper exporter now records `release_output_policy = "immutable-source"`.
A release PDF is copied byte-for-byte from the selected immutable Othello
commit. A disposable `make check` may rebuild its local copy, but those
nonreproducible bytes are discarded; every forward delta is computed from a
separate pristine materialization.

For source commit `ee60800c`:

- `plan`: 24 source files, 674,871 bytes, zero unresolved references;
- `audit`: zero private-reference findings;
- two materializations were byte-identical before build;
- both pristine manifests verified, and isolated `make check` passed at 16 pages;
- pristine export-manifest SHA-256:
  `2e305ff56cd5c4a8bfc6f3f62ce5166eef1a564edd1916c69d85c35f6bbaf13f`;
- immutable release-PDF SHA-256:
  `316d3d17bc7f15f564917b6348c3b8fa24af1bcf3fcc60b69e74d712a6604bbc`;
- the disposable rebuild produced different PDF bytes
  (`7f17db91c0b4f656930b486bc96aca1e69bc74b6948d8d67b8f886a3a8e2143d`),
  confirming why it cannot become the forward input; and
- the exact content delta against standalone commit `8929f2cf` is sixteen
  modified files, with no addition or deletion.

The pristine candidate is retained at
`/tmp/persistent/tavis/c845/paper/pristine`; the build-mutated tree is separate
and has no promotion role.

## Lean source gate and exact blocker

The clean disposable Othello worktree at `ee60800c` built
`RelativeConicArcs.Gates.GoldenQuantumStatistics` successfully through the
guarded queue (8.48 seconds, 880,208 KiB peak). The first aggregate
`--no-build` phase refused when a foreign Lean build became live. After that
build released the window, `lean-trust-extract.py` generated
`lean/trust/facts/RelativeConicArcs.Gates.GoldenQuantumStatistics.json` from
the clean worktree. Its exact observed axiom set is `{propext}` for each of the
four terminals, with no project axiom and no opaque declaration.

The exact project-local export closure is already frozen even though the
canonical materializer is absent:

| Module | Bytes | SHA-256 |
|---|---:|---|
| `RelativeConicArcs.GoldenBalancedCut` | 4,246 | `ea9aa97f486ef37d6cc8becbca8d6d71b202172d0282a95b8c0de120756ed22a` |
| `RelativeConicArcs.Gates.GoldenQuantumStatistics` | 614 | `ac102609c2a0d9143bf48fe1d16d0019c27d63640d03b56a780a3bf53aa5f468` |

Its only external import is `Mathlib.Tactic.Ring`. This is the source-manifest
input the guarded exporter must derive and verify, not a manually assembled
standalone manifest.

The area-wide trust-spine audit is not a usable C845 exit gate: it currently
reports 165 pre-existing errors across unrelated relconic/AME--LU/Q25 units,
including missing facts and unreached modules. Global external-view generation
also incorporates unrelated committed paper-fact changes. C845 therefore
commits only its generated unit fact and does not absorb or regenerate those
foreign surfaces. No clean-checkout aggregate or canonical-export claim is
made.

More fundamentally, the repository contains no guarded exporter that can
materialize an immutable Othello trust unit on top of an immutable canonical
`/home/tavis/src/lean/finitegeom` base. The old suffixed candidate commit is
read-only evidence and cannot fill that gap. The missing contract must:

1. accept exact Othello source and canonical finitegeom base commits;
2. derive the gate's project-local closure and exact four-terminal list;
3. materialize a new disposable repository while preserving the canonical
   base tree and history;
4. generate source, target, area, and global target manifests plus Lake-root,
   provenance, README, public trust, and axiom-audit surfaces mechanically;
5. verify byte identity, manifest completeness, clean base/destination state,
   and a deterministic repeat materialization;
6. reject the superseded suffixed clone as an authority or output target; and
7. expose a read-only forward delta without committing, fast-forwarding,
   pushing, or editing canonical finitegeom.

`lean/scripts/` has trust extraction and external-view generation, but no tool
with this source-to-canonical contract. That path is build-system-owned, so
C845 stops here instead of copying files or inventing an unguarded sync. Once
the contract exists, resume C845 to generate facts/external views, create the
single canonical exported candidate, and pass the remaining source, manifest,
prose, axiom, and deterministic-export gates before handing it to C840.

## Mystery ledger

- **Settled:** the tracked PDF is immutable source evidence, never disposable
  rebuild output.
- **Settled:** the four Lean declarations are mechanism-level partial coverage,
  not full theorem formalization.
- **Open:** the canonical finitegeom forward-export mechanism is absent. The
  exact required contract is the seven-point gate above; build-system ownership
  is the evidence gap.
- **Settled:** exact terminal facts are generated; all four terminals use only
  `propext` and introduce no project axiom.
- **Settled:** the project-local closure is exactly two modules and 4,860
  bytes; both source hashes are frozen above.
- **Open:** the aggregate no-build confirmation and canonical clean-checkout
  replay await the guarded exporter path.
- **Open:** the monolithic relconic trust-spine audit has 165 unrelated
  baseline errors, so a scoped unit check or a repaired area baseline is also
  required before a global external-view gate can be claimed.
