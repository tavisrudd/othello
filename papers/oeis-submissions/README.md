# OEIS / sequence submissions

Sequence submissions (a different kind of deliverable than the manuscripts in `papers/`). Each
subdirectory gathers one sequence's ready-to-paste package via symlinks into `../../notes/`.

## `A344227-queens-nimbers` — extension of an existing entry

Sprague–Grundy values of Node-Kayles on the n-queens graph (the Non-Attacking Queens game),
catalogued through n=13. This package **extends** it with a(14)=0, a(15)=1, a(16)=0, a(17)=2
(new terms by Tavis Rudd). Status: ready-to-paste draft, not yet submitted.

- Priority-stamp subset can go immediately: DATA extension + b-file + `%E` credit + heap-sum
  method comment + the Jenrich `%H`.
- **Blocked** for the fuller version: the `%H` link to our own computation needs a public code
  mirror or arXiv preprint (none exists yet); the n=18 pattern-break comment wants the same
  citable artifact. Add those in a follow-up edit.

Files: the ready-to-paste package, the `b344227.txt` b-file, the conjecture-theory note, and the
validation-chain handoff.

## `sumfree-Zn-nimbers` — a new entry (no A-number yet)

Grundy value of the sum-free achievement game on ℤₙ (Node-Kayles on the Schur-triple hypergraph):
offset 1, terms through n=65, values in {0,1,2,3}. Proven outcome law — for n ≥ 5, a(n)=0 iff
n ≡ 0,1,5 (mod 6), by a negation/translation mirror strategy; values are not eventually periodic,
only the outcome is. Author/submitter: Tavis Rudd. Status: draft, not submitted.

- The genus is the published "nofil" game (Huggan–Huntemann–Stevens 2022); this ℤₙ instance
  appears unpublished. Distinct from the cap-set sequence A090245.
- Its proven outcome law (`2026-07-04-sumfree-game-theorem.md`) is **shared** with the
  `nofil-finite-geometry-outcomes` manuscript (the sum-free ℤₙ result in `main.tex`).
- Possible companions flagged in the draft: the mod-6 outcome-indicator sequence (an `easy`
  characteristic function) and the Paley-graph game sequence.

Files: the draft package, the b-file, and the proven outcome-law note.

## Shared blocker

Both packages (and any arXiv posting of the manuscripts) want a **public code/preprint URL** that
does not exist yet — the repo has no public remote. Creating a public mirror or preprint unblocks
the A344227 `%H`, the n=18 comment, and the sequences' program links at once. See
`../papers-planning.md`.
