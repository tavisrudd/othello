# C475 — Veronese determinant and balanced-cycle quotient

**Lane:** `reed-solomon`

## Target

For a finite field `F`, a distinct support `S subset P1(F)`, and a projective deepest syndrome
`u`, prove the factorization of every edge determinant into the Veronese support bracket and one
binary bilinear form. Determine the rational quotient of the nonzero edge labels by syndrome,
column, and coordinate scaling, and descend it under the semilinear stabilizer of `S`.

## Work package

1. Prove the affine and homogeneous identities, including the point at infinity and characteristic
   two.
2. Derive the complete scaling-weight matrix for `d_ij`.
3. Determine whether balanced four-cycle ratios generate the required rational invariant field; if
   not, give a minimal explicit extension.
4. Divide out the known support brackets and give a reconstruction/equality criterion for the
   syndrome bilinear form.
5. Prove the permutation and Frobenius transformation laws.

## Acceptance

- A coordinate-free theorem with a fully explicit affine chart.
- An exact invariant-generation proof, not only examples.
- A precise statement distinguishing labelled reconstruction, support-stabilizer orbits, and
  semilinear orbits.
- Report: `notes/2026-07-22-c475-reed-solomon-determinant-atlas.md`.

## Stop rule

If four-cycles do not generate, compute the exact missing lattice generators. Do not guess higher
degree invariants or enumerate new fields. C476 remains gated until the quotient is proved.
