# C910 — anchoring the headline to the atomic route

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-m1/`.
**Date:** 2026-08-18.  **Authority commit:** `5d537f713`.
**Predecessor:** `2026-08-18-c910-post-restructure-gap-audit.md`, priority 0a
and part of 0b.

## What was wrong

After the 2026-08-16 atomic restructure, the claim map still pointed
`thm:every-cubic` at `irrational_of_nonzero_packet` and
`cubicThreefold_oneStep_irrational_of_packet_inputs`.  Those two terminals take
a framed primitive-sixth multiplicity, a weak-factorization birational input, a
rank-two projective-bundle formula, and vanishing on projective four-space —
the premises of the proof the manuscript had replaced.  The row therefore
reported the headline as covered by a deduction the paper no longer uses.

## Manuscript change

The framed route was promoted from an unnumbered remark to its own theorem,
`thm:every-cubic-conditional`, stated in the introduction's subsection on the
finer conditional framed invariant and proved in Section 5 where the remark
stood.  Its statement: under Hypotheses 5.7R and 5.7T, every smooth complex
cubic threefold satisfies `nu_6(X x P^1) = 4`, every rational smooth projective
fourfold has `nu_6 = 0`, and hence `X x P^1` is irrational.  The proof combines
the unconditional value from `cor:cubic-product-nu` with birational invariance
through dimension four and `nu_6(P^4) = 5 nu_6(pt) = 0`.

The new theorem sits after the existing statements, so no rendered number of an
earlier statement changed.  A sentence in the introduction and one after the
proof record that it is not the logical basis of `thm:every-cubic`: it reaches
the same conclusion under two hypotheses through an invariant of the whole
small even quantum connection rather than one atom, and its interest is that
the invariant is finer — it separates a cubic threefold from projective
three-space at the threefold level, where the atom argument gives nothing.

## Lean change

Three new modules, all Mathlib-only and free of `sorry`, project axioms, and
native evaluation:

- `Quantum/AtomicResidueDiscriminant.lean` defines
  `residueDiscriminant R = (trace R)^2 - 4 * det R` on two-by-two matrices,
  proves it is unchanged by adding a scalar multiple of the identity and equals
  `(r₁ - r₂)^2` for residue eigenvalues `r₁, r₂`, and evaluates it on the two
  explicit rational matrices of Section 4: `4/9` for the cubic zero-packet
  residue and `0` for every curve residue.
- `Quantum/OrdinaryAtomLedger.lean` types the ordinary Hodge-atom package as a
  ledger — dimension, rationality, product with a projective line, atomic
  multiplicity — with the projective-bundle formula and the ordinary
  non-rationality criterion as premises, and proves the two deductions on top:
  an atom occurring on a variety also occurs on its product with a projective
  line, and an atom of even rank two, odd rank at least four, and nonzero
  residue discriminant occurs on no variety of dimension at most two.
- `Applications/CubicAtomOneStep.lean` instantiates that at the cubic
  zero-packet atom and concludes that `X x P^1` is not rational.

Four reviewer terminals were added to `PaperInterface`:
`cubicZeroPacket_residueDiscriminant_eq`, `curve_residueDiscriminant_eq_zero`,
`cubicAtom_not_represented_in_dimension_le_two`, and
`cubicThreefold_oneStep_irrational_of_atom_inputs`.  The `thm:every-cubic` row
now lists exactly those four, with hypothesis and caution text rewritten to the
atom route; the two packet terminals moved unchanged to the new
`thm:every-cubic-conditional` row.  The caution on `thm:separation-family` now
names the framed input by its new label and records that the manuscript takes
its irrationality from the atomic route, and the caution on `cor:v14-one-step`
records that its unconditional half has no Lean terminal.

What Lean does not do is unchanged in kind: it constructs no variety, no
`A`-model `F`-bundle, no spectral cover, no atom, and no elementary
modification, and it does not prove that either displayed matrix is a geometric
residue.  The surface and curve analysis — point blowups, projective bundles,
the nef-canonical lemma, the classification of minimal smooth projective
surfaces — enters as the two exclusion premises.

## Gates

All green at `5d537f713`.

- Guarded queue built the three new modules, then `PaperInterface`, then
  `Verification.AxiomAudit`, against the package's pinned Mathlib.
- `make check`: lint, source-only claim gate, deterministic manuscript build,
  and the warning grep all pass.  The paper is warning-free at 49 pages, one
  page more than before.
- `make formal-audit` against the captured audit output passes: 96 sources,
  172 terminals, 50 manuscript claims, 46 machinery rows, coverage 29 absent /
  10 fragmentary / 10 conditional / 1 complete.  Each new terminal reports
  `propext, Classical.choice, Quot.sound`.
- Both coverage snapshots were updated, and `lean/README.md` now states which
  part of the atomic route is checked rather than calling the route absent.

## What this does and does not buy

The claim map no longer misreports the headline: the row that carries
`thm:every-cubic` mirrors the proof the paper gives it, and the framed spine
has its own manuscript theorem to answer to.  The arithmetic that does the work
in Section 4 — the separation `4/9` against `0` — is now kernel-checked, and so
is the deduction from the ordinary Hodge-atom premises down to irrationality.

The geometry above those premises is still unformalized, and the coverage
fraction barely moves: one row changed from conditional to conditional.  The
remaining audit priorities are unchanged — `prop:cubic-block-data` to discharge
the standing premise of `prop:cubic-packet`, the rank-two invariant chain
behind `prop:rank2-rigidity`, `lem:disc` and `lem:spectrum-transfer`, a
terminal for `lem:six-point-hearts` from declarations already in
`GraphLattices`, the missing unconditional half of `cor:v14-one-step`, and the
disposition of the four orphaned machinery themes.

## Export status

Not exported.  The paper repository under `~/src/math-papers/` was already
committed and unpushed before this change and is now one commit behind the
authority.
