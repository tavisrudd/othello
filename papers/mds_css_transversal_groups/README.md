# Diagonal isoduality and transversal Clifford groups

This directory is the authoritative monorepo source for *Diagonal Isoduality
and Transversal Clifford Groups of MDS--CSS Codes*.

For an odd-prime linear `[2m,m,m+1]_q` MDS code, the paper proves that the
space of diagonal code-to-dual multipliers has nullity zero or one and that
this nullity selects the exact fixed-party projective transversal logical
group: `F_q^2 ⋊ SL_2(q)` on the diagonally isodual branch and `F_q^2 ⋊ T`
otherwise. The six-coordinate applications include the conic boundary, the
non-GRS pencil quotient, Clebsch syndrome geometry, scalar separators, and
computed party extensions.

Build and verify from this directory:

```text
make check
python3 supplement/verify.py --replay
```

The TeX source, bibliography, figures, and evidence package are entirely
local to this root. No symlink or parent-relative TeX input crosses into the
companion AME-rigidity paper. The formal source remains in the shared
`RelativeConicArcs.AMELU` namespace; paper-specific semantic gates and the
release manifest are intentionally deferred to the coordinated formal split.

The source is licensed under CC BY 4.0. Public identifiers, remote creation,
push, deposit, and submission remain author decisions.
