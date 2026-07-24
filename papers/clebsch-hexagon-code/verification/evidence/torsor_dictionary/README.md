# Torsor-dictionary evidence

This bundle supplies the exact finite and arithmetic evidence used by the paper's orientation
torsor dictionary.

- The matching, common-duality, and affine-cocycle checks construct the finite matching modules,
  their two sheets, and the obstruction to an equivariant choice.
- The orbit-selector certificate exhausts its stated finite support and verifies that one chosen
  sheet is sufficient and no invariant choice exists.
- The arithmetic-orientation and fixed-child checks independently reconstruct the prime/sheet
  dictionary and the twenty-two-parent quotient above the fixed conic child.
- The design--Fourier hinge check reconstructs the quadratic-residue, common-duality, Hadamard, and
  outer-hinge finite tables.  Its separate replay derives the same conclusions without importing
  the primary generator.
- The trichotomy and characteristic-zero checks combine these explicit inputs into the
  split/inert rank-three models and the quadratic-field reduction interface.

Run `python3 verify.py`.  It first checks every source and certificate against
`manifest.sha256`, then runs each primary checker and each independent replay.  The finite domains
are the displayed fields, projective lines, matching orbits, matrices, and assignment graphs; no
sampling is used.

`coxeter-phase.py` is retained as an imported arithmetic/permutation helper for
`matching-module.py`.  Its historical standalone certificate entry point depends on source
records deliberately omitted from this flattened bundle and is not a public replay command.
`verify.py` exercises the imported helper through the primary matching-module check and the
separately written matching-module replay.

The residual trusted boundary consists of the semantic identification of the coordinate tables
with the named classical Coxeter and projective groups, the cited spinor and number-field
interpretations, and the interpretation of the explicit descent data as Čech or Hilbert--90
objects.  The bundle proves neither an absolute cohomology classification nor an all-prime
classification.
