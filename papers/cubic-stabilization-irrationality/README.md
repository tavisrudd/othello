# Two-Dimensional Stabilization of Quartic del Pezzo Surfaces

This manuscript proves that a smooth quartic del Pezzo surface over a
characteristic-zero field, with a rational point and stably permutation
geometric Picard lattice, becomes rational after adjoining two independent
variables. It applies the theorem to both Tschinkel--Zhang cubic families.
Combined with the separately cited one-stabilization irrationality theorem,
this determines the stabilization index of their cubic threefolds and gives
nonrational smooth projective fourfolds that become rational after
affine-line stabilization.  This birational statement is distinct from the
isomorphism problem usually called Zariski cancellation.

Build and verify from this directory with:

```sh
make check
```

The exact tangent-incidence certificate is checked with SymPy 1.14.0. The
paper proves the quotient, descent, and function-field arguments in prose.
No Lean development formalizes the rationality statements; every theorem
and corollary is annotated with formal coverage `absent`.
