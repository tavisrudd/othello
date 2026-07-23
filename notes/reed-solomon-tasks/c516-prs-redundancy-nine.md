# C516 — PRS redundancy-nine residual-quadratic theorem

**Lane:** `reed-solomon` · **Date queued:** 2026-07-23 · **Gate:** after C513

## Objective

Prove the next fixed-level application of C512 for
\[
 \operatorname{PRS}(q-8),
\]
using C513's exact redundancy-nine gate rather than an ambient syndrome census.

1. Construct the residual-quadratic cover over the five-marker configuration space and descend it
   to binary-quartic \(PGL_2\)-orbits.
2. Compute and separate its determinant, discriminant, pairwise diagonal, fixed-root collision,
   and squarefreeness divisors.
3. Prove generic absolute irreducibility/geometric monodromy, or classify the exact reducible and
   singular strata that obstruct it.
4. Resolve the characteristic-seven prime-diagonal carrier
   \(\mathbf P(\det^2\otimes\operatorname{Sym}^4E)\), including the relation between rootless
   binary quartics and shallow/deep lifts over extension fields.
5. Combine the generic and modular analyses into the strongest justified high-field
   deep-syndrome and \(PGL_2/P\Gamma L_2\) orbit theorem.

## Entry evidence

- `notes/2026-07-23-c512-general-polar-flag-theorem.md` supplies the characteristic-free pointed
  contraction functor and effective contained-or-transverse theorem.
- `notes/2026-07-23-c513-prs-redundancy-eight.md` identifies the redundancy-nine generic spine,
  the characteristic-seven binary-quartic carrier, the `q=7` rootless calibration, and the exact
  residual-quadratic discriminant/collision gate.

## Exit gate

- Exact equations and divisor ledger for the residual-quadratic cover.
- A proved generic component/monodromy theorem or a precise obstruction.
- Complete contained-carrier analysis in characteristic seven.
- A theorem with an explicit field threshold and exact exceptional hypotheses, or a rigorous
  statement of why the threshold cannot yet be obtained.
- Every paper-facing computation follows the atomic reproducibility convention.
- No ambient projective syndrome census substitutes for the geometric gates.
- An extra-juice closeout refreshes the mystery ledger before lifecycle closure.

## Deliverable

Task report: `notes/2026-07-23-c516-prs-redundancy-nine.md`.
