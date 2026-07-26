# C632 — Lean formalization of signed Gale-kernel duality

**Date:** 2026-07-25

## Result

The reusable linear-algebra hinge in C621 is now formalized in
`RelativeConicArcs.ClebschSignedGaleDuality`.

For a matrix \(A\) and column weights \(\epsilon\), the module defines the
signed matrix with rows
\[
  (AD)_i(j)=A_{ij}\epsilon_j.
\]
It proves:

1. weighted row orthogonality is equivalent to
   \(A(AD)^{\mathsf T}=0\);
2. every row of \(AD\), and hence their span, lies in
   \(\ker A\);
3. equality of the two subspace dimensions identifies the signed-row span
   with \(\ker A\);
4. in the geometric \(q\)-by-\(2q\) shape, independent signed rows and full
   row rank supply that dimension equality automatically.

The matrix-form terminal theorem is
`RelativeConicArcs.SignedGaleDuality.signedRowSpace_eq_ker_of_mul_transpose_eq_zero`.
It is exposed by the import-only gate
`RelativeConicArcs.Gates.ClebschSignedGaleDuality`.

## Exact boundary

The formal theorem captures the implication
\[
 A D A^{\mathsf T}=0,\quad
 \operatorname{rank}(AD)=q,\quad
 \operatorname{rank}(A)=q,\quad
 \#\text{columns}=2q
 \ \Longrightarrow\
 \operatorname{rowspan}(AD)=\ker A.
\]
It therefore checks the linear-algebra step that turns the sheet sign into a
labelled Gale transform.

The artifact does not formalize the coordinate tables for the
\(B_3/\mathbb F_7\) and \(H_3/\mathbb F_{11}\) configurations, the signed
moment vanishings that establish the matrix identity, projectivization of the
column scaling, the quadratic Cayley--Bacharach defect, the
Eisenbud--Popescu criterion, Gorenstein descent, or the cubic inverse system.
Those remain on the exact and classical evidence routes stated in C621.
The existing theorem
`RelativeConicArcs.ClebschTorsorRosetta.no_invariant_point` separately
formalizes the elementary fixed-point obstruction for a free two-point
torsor. It does not encode C417's affine translation cocycle, and the new
Gale-kernel theorem does not claim to split or strengthen that obstruction.

## Validation and trust

The source module elaborates without warnings under the pinned Lean
toolchain. The dedicated gate builds through the guarded Lean build queue and
prints the axioms of all terminals. The reported dependency set is
`propext`, `Classical.choice`, and `Quot.sound`; there are no `sorry`
declarations, custom axioms, native evaluation, or imported certificates.

Replay:

```text
lean/scripts/guarded-lean RelativeConicArcs/ClebschSignedGaleDuality.lean
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.ClebschSignedGaleDuality \
  RelativeConicArcs.Gates.ClebschSignedGaleDuality \
  --profile single --threads 1 --cores 20-23
```

## Closeout

The extra-juice pass added the exact matrix-language equivalence
\(A(AD)^{\mathsf T}=0\), rather than leaving the hypothesis only as a
coordinate sum. The Tao-style pass replaced a bare equal-finrank corollary
with the half-size theorem: for \(2q\) columns, full row rank and independent
signed rows prove the required dimension equality by rank--nullity.

## Mystery ledger

- **Settled:** the formal proof needs no projective-coordinate API; its genuine
  reusable core is finite-dimensional linear algebra.
- **Settled by C635:** full row rank makes the original rows independent, and
  full-support coordinate scaling preserves their independence. The strengthened
  terminal now takes the exact matrix identity, full row rank, full-support
  weights, and the \(q\)-by-\(2q\) size directly.
- **Open, outside this task:** connect the two frozen configurations to these
  abstract hypotheses inside Lean. That requires formal coordinate or
  certificate bridges and must not be inferred from the Python/Singular
  evidence.
