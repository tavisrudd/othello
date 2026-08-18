# C917 — Classical Hodge comparison and 2026 atomic positioning in the one-stabilization epilogue

**Date:** 2026-08-18 · **Lane:** `cubic-threefolds` · **Task:** C917
**Manuscript:** `papers/cubic-stabilization-epilogue/` (build target
`irrationality_after_one_stabilization`, 49 pages)

## What landed

The author-supplied edit specification
(`notes/cubic-threefolds-tasks/c917-epilogue-hodge-and-guere-positioning.md`)
offered a long and a compact variant for each of its two paragraphs. The
manuscript now carries the **long classical paragraph** (specification §1/§11
first paragraph) and the **compact related-work sentence pair**
(specification §12), both inside the introduction's *Relation with earlier
rationality results*. The mix was chosen because the referee question the
paragraph answers — why Clemens--Griffiths does not already obstruct
`X x P^1` — deserves the displayed Kuenneth and Tate facts and the explicit
Fano-surface identification, whereas the Guere and
Benedetti--Fay--Guere--Manivel--Perrin material is comparison rather than
mechanism and would restate `b_3 = 10` and the Tate middle `H^4` a second
time in its long form. This is the fallback the specification itself
recommends when the introduction is already dense; the introduction grew from
four pages to five in a 49-page paper.

Edits, all in `sections/01-introduction.tex` and
`cubic_stabilization_epilogue.tex`:

1. The second sentence of the Clemens--Griffiths paragraph was replaced by
   the classical comparison: `H^3(X x P^1, Q) = H^3(X, Q)` and
   `H^4(X x P^1, Q) = Q(-2)^2`; a smooth surface center contributes
   `H^1(S, Q)(-1)` to `H^3`; the Fano surface satisfies
   `Alb(F(X)) = J(X)` (Clemens--Griffiths Theorem 11.19), hence
   `H^1(F(X), Q)(-1) = H^3(X, Q)`; so the surviving weight-three Hodge
   structure is already of surface-center type while the middle `H^4` is
   Tate, and the standard intermediate-Jacobian and blowup bookkeeping gives
   no contradiction — without excluding more elaborate classical
   Hodge-theoretic obstructions. It closes by saying what the atom argument
   adds: it follows the quantum spectral packet carrying the Hodge
   representation rather than `H^3` alone.
2. A new comparison paragraph cites Guere for a projective-K3-type Hodge
   necessary condition on rational cubic fourfolds and
   Benedetti--Fay--Guere--Manivel--Perrin for a monodromy and coarse-atom
   irrationality criterion, and records that the latter assumes `b_3 = 0`,
   which `X x P^1` fails with `b_3 = 10`.
3. Two bibliography entries: `Guere` (arXiv:2603.04518v1) and `BFGMP`
   (arXiv:2607.26718v1).

Theorem statements, hypotheses, proofs, Section 4's structure, and the
abstract are unchanged.

## Source verification

- **Guere, *On the irrationality of cubic fourfolds*, arXiv:2603.04518v1
  (4 March 2026).** Fetched into the shared literature cache
  (`litcache.py get arXiv:2603.04518`, sha256
  `eb84753911c97a6b618975be5da4dc3b5bdec2b66edf11063d09d75e475abfdc`). Read
  the abstract, Section 0, and the opening of Section 1. His Theorem 56: if
  `X` is a rational smooth complex cubic fourfold then
  `H^4(X, Q)_prim = H^2(S, Q)(-1)` for a projective K3 surface `S`. He states
  explicitly that he chose not to discuss Hodge atoms because they are not
  directly necessary for his proof, while noting that his evaluation maps are
  closely related to the atom construction. The manuscript therefore cites him
  only for the necessary condition and never calls his proof a Hodge-atom
  proof.
- **Benedetti--Fay--Guere--Manivel--Perrin, *An atomic criterion for
  irrationality without quantum computations*, arXiv:2607.26718v1 (29 July
  2026).** Already in the cache. Read the abstract, introduction, and
  Theorem 4.1, whose hypotheses are `b_1(X) = b_3(X) = 0`,
  `h^{3,1}(X) > h^{3,1}(Y)` for the ambient Fano fivefold `Y`, and
  `b_4(X)_van >= 10 + 12 h^{3,1}(X)`, concluding irrationality for
  Hodge-general `X`. Their applications are the very general cubic,
  Gushel--Mukai, and Kuechle (c5) fourfolds. Remark 4.2's maximal-spectrum
  subtlety for evaluation maps was read and is not imported: Section 4 of the
  epilogue does not use their evaluation argument.

Neither source pre-empts anything in the epilogue. Both bound its novelty
posture, and the recorded posture is in
`papers/cubic-stabilization-epilogue/claim-proof-novelty-ledger.md`: no
novelty is claimed for the broad idea of localizing Hodge data into quantum
spectral packets, nor for being the first atomic refinement of a classical
Hodge obstruction.

## Specification checklist

Every item of specification §14 was checked against the landed text. The
paragraph says surface centers *may* occur and never that `F(X)` is an actual
blowup center; it says "direct" before "Clemens--Griffiths mechanism"; it
keeps the caveat about more elaborate classical Hodge methods; it does not
attribute surface exclusion to the residue discriminant (Propositions 4.16
and 4.17 exclude surfaces by parity rank and the classification of minimal
surfaces, and the discriminant excludes only the genus-five curve); and it
does not claim the joint paper avoids quantum information, only explicit
quantum computations — a claim it does not make at all in the compact form.

## Validation

`make check` in the paper root: green (lint, source-only formal check,
49-page manuscript build, and the zero-warning gate).

Standalone repository `~/src/math-papers/cubic-stabilization-epilogue`
synchronized from monorepo commit `9cf7433ae` by
`papers/scripts/export-paper-repos.py sync`, its own `make check` replayed
green, tracked PDF byte-identical to the authority
(`c73c63b5430e70a2e38b3ad73172bd26b7447f10ac5ae4f16c9c9cedc85a6b21`), and
`export-paper-repos.py verify` passing on 131 tracked files. The sync also
carried the C910 Lean companion deltas committed since the previous sync,
because the standalone repository had been left unsynchronized at the close of
C912. Nothing was pushed.

## Proofreading and citation check (same day, after the first close)

Every citation added by this task was checked against its source rather than
against the specification:

- `\cite[Theorem~11.19]{CG}` is exact. The Clemens--Griffiths paper reads
  "THEOREM 11.19. `q': Alb(S) -> J(V)` is an isomorphism", with `S` the Fano
  surface of lines and `V` the cubic threefold, verified in the
  Institute-for-Advanced-Study-hosted scan of the published paper. The
  Hodge consequence used in the manuscript follows: `H^1(J(X), Q) = H^3(X, Q)(1)`,
  so `H^1(F(X), Q)(-1) = H^3(X, Q)`, and the weights agree.
- The printed bibliography places Benedetti--Fay--Guere--Manivel--Perrin at
  [5], between Behrend and Cai, and Guere at [14], between Grieve and
  Hartlieb; both alphabetical, both with the correct arXiv identifiers,
  versions, and years, and both rendering their accents correctly.
- The Kuenneth statements are correct as printed:
  `H^3(X x P^1) = H^3(X)` because `H^1(X) = 0`, and
  `H^4(X x P^1) = H^4(X) + H^2(X)(-1) = Q(-2)^2`.

Two precision repairs followed the proofread and are in the manuscript:

1. The opening sentence now binds the notation, "its intermediate Jacobian
   `J(X)`", which the new paragraph then uses.
2. The joint criterion is now described with its ambient hypothesis —
   Hodge-general Fano fourfolds *that are hyperplane sections of smooth Fano
   fivefolds* — matching their Theorem 4.1 rather than describing it as a
   criterion for Fano fourfolds in general.

The manuscript remains 49 pages with `make check` green, and the standalone
repository was re-synchronized and verified at 132 tracked files.

## Portfolio summary

`papers/summary/README.md` carries the paper's abstract as a verbatim
blockquote; a normalized token comparison against the manuscript abstract
shows no difference beyond accent and subscript encoding, and this task did
not touch the abstract, so no update was needed there. The "Why it matters"
paragraph now records the classical limit and the criterion mismatch, and
states that no novelty is claimed for the broad quantum/Hodge philosophy —
the posture already recorded in the paper's ledger. The summary's downstream
copy at `~/src/math-papers/math-papers-summary` was refreshed from the
authority and committed.

## Concurrent-session note

A second session committed C910 Lean work into this repository during the
task (`83bc43d40`, rank-two residue rigidity) and continued editing that file
afterwards. Both standalone synchronizations therefore carried C910's
committed Lean state downstream. Nothing was pushed, and whoever closes C910
should re-synchronize at that point.
