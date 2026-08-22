# C933 -- Hodge-atom marker-ledger companion

**Lane:** cubic-threefolds

**Status:** complete and reported 2026-08-20

## Goal

Write a short, self-contained companion paper showing that the standard
Hodge-atom construction is a specialization of the generalized
occurrence-indexed marker ledger.  Prove the carrier, thin-groupoid,
additive-fold, and dimension-filtration laws used by the specialization
inside the companion.  Keep the paper strictly at \(m=1\).

## Scope

- New paper authority: `papers/hodge-atom-marker-ledger/`.
- The companion may cite the antecedent Hodge-atom and chemical-formula
  literature for context and terminology, but its mathematical statement
  must not rely on an unaudited theorem-level import.
- The cubic-stabilization epilogue receives exactly one sentence referring to
  the companion.  That sentence must not enter any theorem hypothesis,
  dependency annotation, or proof step.
- `papers/cubic-stabilization-irrationality/` and every \(m\ge2\) argument are
  outside scope.
- No standalone mirror is created or synchronized without a separate release
  decision after the authoritative manuscript passes.

## Acceptance gate

1. The exact source terminology and theorem boundary are audited against the
   authoritative source.
2. The manuscript defines the occurrence-indexed carrier and its presented
   thin groupoid before stating the specialization theorem.
3. The additive fold and filtration descent are proved, not attributed to a
   preprint.
4. The relationship to the epilogue's atomic direct-QDM marker is stated as a
   sibling specialization, never an identification.
5. The companion contains no \(m=2\) or all-stabilization claim.
6. The epilogue contains exactly one non-load-bearing reference sentence and
   retains its existing theorem graph and page count unless the added sentence
   forces an unavoidable one-page reflow.
7. Both manuscripts build without rejected warnings and pass their scoped
   source and reference checks.
8. A hostile mathematical and copy-edit read returns no unresolved blocker.

## Starting points

- `notes/2026-08-20-c930-categorical-direct-qdm-proof-memo.md`
- `notes/cubic-threefolds-tasks/c925-modular-direct-qdm-proof-packet.md`
- `papers/cubic-stabilization-m1/sections/04-categorical-one-step.tex`

## Result

- Companion authority: [Hodge-atom marker-ledger paper](../../papers/hodge-atom-marker-ledger/)
  and [six-page PDF](../../papers/hodge-atom-marker-ledger/hodge_atom_marker_ledger.pdf).
- Archival DOI: [10.5281/zenodo.22036391](https://doi.org/10.5281/zenodo.22036391).
- Epilogue authority: [cubic-stabilization epilogue](../../papers/cubic-stabilization-m1/)
  and [fifty-page PDF](../../papers/cubic-stabilization-m1/irrationality_after_one_stabilization.pdf).
- Source audit: `notes/2026-08-20-c933-hodge-atom-source-audit.md`.
- Closeout and hostile-read record:
  `notes/2026-08-20-c933-hodge-atom-marker-ledger-companion.md`.
- Standalone exports:
  `~/src/math-papers/hodge-atom-marker-ledger/` and
  `~/src/math-papers/cubic-stabilization-m1/`.
