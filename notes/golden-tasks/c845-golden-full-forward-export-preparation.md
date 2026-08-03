# C845 Golden full-forward export preparation

**Lane:** `golden`

**Status:** active; paper forward-exported by explicit user instruction, stopped at the missing canonical finitegeom exporter contract

## Objective

Prepare one committed authoritative source state for exporter-only full-forward
materialization of the Golden quantum-statistics paper and its optional partial
Lean companion.  The paper destination is
`/home/tavis/src/math-papers/golden-quantum-statistics`; the Lean destination is
the canonical `/home/tavis/src/lean/finitegeom` repository.

This task prepares source roots and export contracts.  It does not publish,
push, replace repository history, or claim that the paper is fully formalized.

## Source and destination boundary

- Paper changes originate only in `papers/golden-quantum-statistics/` and are
  exported with `papers/scripts/export-paper-repos.py` from an immutable Othello
  commit.  No paper file is copied manually into `~/src/math-papers`.
- Lean and trust-spine changes originate only in Othello's `lean/` tree.  Use
  the guarded trust extraction and external-trust export tools to prepare the
  standalone surface; do not hand-edit exported Lean files.
- `/home/tavis/src/lean/finitegeom-golden-quantum-statistics` is a derived,
  superseded candidate clone.  It is read-only evidence during this task and
  is neither an authority nor an editing surface.
- `/home/tavis/src/lean/finitegeom` is the canonical Lean destination.  Its
  existing history is preserved and it advances only through the repository's
  export/forward-sync mechanism after the exported tree passes its gates.

## Work

1. Reconcile the sixteen-page paper against the exact reusable declarations in
   `RelativeConicArcs.GoldenBalancedCut`, recording the four covered scalar
   mechanisms and every human-only theorem, proposition, design, decoder,
   compilation, tomography, and experimental clause.
2. Prepare the authoritative trust roots for a narrow Golden
   quantum-statistics extraction unit: import-only gate, exact terminal list,
   expected axiom sets, area ledger, source/facts manifests, public trust prose,
   and release-facing external-trust view.  Generated facts must come from
   `lean/scripts/lean-trust-extract.py`; release views must come from
   `lean/scripts/external-trust-exports.py`.
3. Identify and exercise the repository-owned forward exporter that targets
   `/home/tavis/src/lean/finitegeom`.  If that path is not yet represented by a
   guarded exporter contract, stop at the exact missing contract rather than
   copying or editing the destination.
4. Run the paper exporter `plan` and `audit` from the selected immutable source
   commit, prepare a disposable materialization, and record the exact forward
   delta against the existing standalone history.  Resolve the tracked-PDF
   release-output disposition in the exporter contract; never replace the
   content-addressed PDF with nonreproducible rebuild bytes.
5. Leave C840 a single canonical exported Lean candidate to validate.  Remove
   every instruction that treats the superseded suffixed clone as a source or
   authoring worktree.

## Acceptance gate

- The owned Othello source paths are clean and committed before either exporter
  reads them.
- Paper `plan`, private-reference `audit`, deterministic disposable
  materialization, manifest verification, isolated `make check`, and exact
  forward-delta checks pass without mutating the live standalone repository.
- The trust-spine plan names the Golden extraction unit and its four exact
  terminals; the coverage ledger explicitly excludes all unformalized paper
  claims.
- Trust-spine checks, generated external views, manifests, referee-facing prose
  audit, and the guarded target/axiom contract pass on authoritative source.
  Any real elaboration follows `lean/AGENTS.md` and the shared quiet-window
  protocol.
- A clean disposable export to the canonical finitegeom layout is byte- and
  manifest-verified.  No file under either Lean destination is manually edited,
  and no remote creation, push, history rewrite, or final promotion occurs.

## Successor boundary

C840 validates the prepared canonical Lean export, including clean-checkout
elaboration and axiom reconciliation.  C841 then adds the public companion
declaration and performs the history-preserving standalone paper promotion.

## Current checkpoint

The committed source checkpoint, paper-export evidence, formal-coverage
ledger, and exact missing-contract boundary are recorded in
`notes/2026-08-02-c845-golden-full-forward-export-preparation.md`. Resume this
task only after the repository-owned guarded exporter can target canonical
finitegeom from immutable source and base commits. Do not use the superseded
suffixed clone to bypass that gate.

The paper-only mirror advance is complete at local standalone commit
`8aee16d93d738e3e9add479b74d248bdf3c76a9f`, produced from immutable Othello
commit `3c5c72dd8c259cca10cf1a024caf4766277a1e85`. It contains no formal-companion
declaration and was not pushed or tagged.
