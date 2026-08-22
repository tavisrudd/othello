# C910 — the small even block reduction in Lean

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-m1/`.
**Date:** 2026-08-18.  **Authority commit:** `3b0d554ea`.
**Predecessors:** the gap audit `2026-08-18-c910-post-restructure-gap-audit.md`
(priority 0c) and the anchor report `2026-08-18-c910-atom-route-anchor.md`.

## What was formalized

`prop:cubic-block-data` is the calculation both routes of the paper share: from
Cai's displayed small even connection of a smooth cubic threefold to the
reduced rank-two zero block.  It is now checked in Lean, in the module
`Quantum/CubicSmallEvenBlockReduction.lean`, over any characteristic-zero field
with a nonzero square root `r` of three times the line-class Novikov variable.

- The constant separating change of basis has determinant `-486 r ^ 5`.
- It conjugates the doubled Euler multiplication matrix to
  `diag (6 r, -6 r, J)`, and the zero block `J = !![0, 2; 0, 0]` is nonzero and
  squares to zero, so the double eigenvalue at zero is a single rank-two Jordan
  block.
- It conjugates the grading matrix to the displayed separated form.
- Two explicit block-off-diagonal gauge coefficients make the first and second
  coefficients of the transformed system block diagonal, with rank-two blocks
  `diag (-19 / 18, 19 / 18)` and `!![0, -14 / (81 r ^ 2); -8 / 81, 0]`.
- The canonical elementary modification, implemented by the lattice change of
  basis `diag (1, z)`, has residue `!![-19 / 18, 2; -8 / 81, 1 / 18]`, trace
  `-1`, determinant `5 / 36`, and characteristic polynomial the rank-two
  indicial polynomial `X ^ 2 + X + 5 / 36`.

The residue matrix that the earlier atom-route work asserted,
`cubicZeroPacketResidue`, is now proved equal to the residue derived from the
block data, so the value `4 / 9` of the residue discriminant rests on the
reduction rather than on a transcribed matrix.

## What the premise of the cubic packet became

`prop:cubic-packet` previously had one premise: that the framed monodromy of
every smooth cubic threefold has a supplied characteristic polynomial, the
four-factor polynomial of Cai's block description.  A second terminal,
`cubicPacket_sixthMultiplicity_eq_two_of_block_exponents`, now reaches the same
value `nu_6(X) = 2` from a weaker premise: that framed monodromy exponentiates
the exponents of the reduced system, with two unit factors from the rank-one
blocks at the nonzero Euler eigenvalues.  Which exponents occur is no longer
assumed — Lean derives `-1 / 6` and `-5 / 6` from the block reduction through
the modified residue.

What stays external is exactly one step, the passage from a regular-singular
residue to framed formal monodromy.  Cai's role is reduced from supplying a
characteristic polynomial to supplying the connection matrix, which is what the
manuscript says the imported datum is.

## Scope of the formal statement

The Lean statement is a strictly weaker fragment of the manuscript's
proposition, and the claim map records it as `fragment` rather than complete.
Two restrictions:

- The gauge coefficients are supplied explicitly and the resulting identities
  verified.  Lean does not prove existence and uniqueness of the normalized
  gauge by the Sylvester recursion, and it does not treat orders beyond the
  second.  The second order is the last one the residue depends on, so nothing
  the paper uses is missing, but the general statement is not formalized.
- Lean does not construct the quantum connection and does not prove that the
  displayed matrices are the small even connection of a cubic threefold.

## Reproducibility record

The gauge coefficients were derived symbolically before being supplied to Lean.
The derivation is committed as
`papers/cubic-stabilization-m1/verification/small_even_block_reduction.py`
with its recorded output `small_even_block_reduction.txt`, documented in
`papers/cubic-stabilization-m1/verification/README.md`.  Replay from the
paper directory:

```sh
uv run --with sympy python3 verification/small_even_block_reduction.py
```

SHA-256, at the committed state:

```text
c35330b09b90ed446ec871d0e050c3a7a68f32f63a756e5868b681d5f86f4ac4  small_even_block_reduction.py
10f9eddad73a6256466fbdf0ec318cf521e4bf38359bb77cfd43af41b641fe79  small_even_block_reduction.txt
```

The independent replay is the Lean kernel.  The script solves for the gauge
coefficients; the Lean module states the identities with those coefficients
written out and proves them by exact matrix arithmetic, so no claim rests on the
symbolic algebra system.  The script's own output agrees with the manuscript's
displayed `D` and `E`, and with Cai's reduction as the manuscript cites it.

## Gates

All green at `3b0d554ea`.  Guarded queue built the two new modules, then
`PaperInterface`, then `Verification.AxiomAudit`.  `make check` and
`make formal-audit` pass: 98 sources, 175 terminals, 50 manuscript claims, 46
machinery rows, coverage 28 absent / 11 fragmentary / 10 conditional / 1
complete.  Each new terminal reports `propext, Classical.choice, Quot.sound`.
The manuscript was not edited in this pass, so the PDF is unchanged at 49 pages.

## Observations

Two things are worth keeping.  First, the reduction is entirely rational: the
only place `r` survives into the reduced data is the `(0, 1)` entry of the
second block, `-14 / (81 r ^ 2)`, and the modification discards exactly that
entry.  The exponents, the indicial polynomial, and the residue discriminant are
therefore independent of the Novikov variable, which is why a single rational
matrix carries the whole obstruction.

Second, the second-order gauge coefficient is needed only through its effect on
one entry, `(E)_{1 0} = -8 / 81`.  The manuscript already remarks that this
entry is what the modification retains; the formalization makes the dependence
exact, since the residue's characteristic polynomial is determined by
`D` and that single entry.

## Next

From the gap audit, still open: the product-formula corollaries `cor:p3-nu6`
and `cor:cubic-product-nu`, a terminal for `lem:six-point-hearts` from
declarations already in `GraphLattices`, the rank-two invariant chain behind
`prop:rank2-rigidity`, `lem:disc` and `lem:spectrum-transfer`, the missing
unconditional half of `cor:v14-one-step`, and the disposition of the four
orphaned machinery themes.

## Export status

Not exported.  The paper repository under `~/src/math-papers/` is now two
commits behind the authority.
