# Diagonal isoduality and transversal Clifford groups

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21766797-blue.svg)](https://doi.org/10.5281/zenodo.21766797)

This source tree contains *Diagonal Isoduality and Transversal Clifford Groups
of MDS--CSS Codes* and its paper-local verification package.

[Read the paper (PDF).](mds-css-transversal-groups.pdf)

For an odd-prime linear `[2m,m,m+1]_q` MDS code, the paper proves that the
space of diagonal code-to-dual multipliers has nullity zero or one and that
this nullity selects the exact fixed-party projective transversal logical
group: `F_q^2 ⋊ SL_2(q)` on the diagonally isodual branch and `F_q^2 ⋊ T`
otherwise.  Stabilizer-AME rigidity supplies the converse: every
tensor-product logical implementation is Clifford factor by factor.  The
linear `SL_2(q)` action has coherent Weil lifts, while its affine extension
retains the Heisenberg obstruction to scalar splitting.

For six coordinates, diagonal isoduality is exactly self-association of the
six-arc and hence the conic boundary.  On an explicit non-GRS pencil, one
degree-eight quotient classifies projective and monomial-code equivalence over
odd fields and local-Clifford and local-unitary equivalence over odd prime
fields.  The Clebsch code supplies the worked syndrome-geometric example.
Exact certificates cover the finite six-point calculations; the all-length
multiplier and group theorems are conceptual.

Build and verify from this directory:

```text
make check
python3 supplement/verify.py --replay
```

The TeX source, bibliography, figures, and evidence package are entirely
local to this root. No symlink or parent-relative TeX input crosses into the
companion AME-rigidity paper.

The formal source lives in the shared `RelativeConicArcs.AMELU` Lean namespace.
This paper's checked surface is exactly the transitive closure of the
import-only gate `RelativeConicArcs.Gates.MDSCSSTransversalGeometry`, and the
axiom dependencies of every declaration the paper cites are printed by
`RelativeConicArcs.Gates.MDSCSSTransversalGeometryAxioms`. A content-addressed
record of that closure — its modules, imports, terminal names, axiom facts,
exporter digest, and toolchain identity — is kept with the Lean development and
is summarized in `supplement/EVIDENCE.md`. The dictionary, multiplier-line,
syndrome, pencil quotient, Frobenius-sector, and party-splitting statements are
checked by kernel reduction; the exact-carrier, classification, logical-phase,
separator, and transport terminals derive their conclusions from structures
whose fields state the inputs the manuscript proves or certifies separately; three six-party graph cardinalities use
exhaustive native evaluation, and the two marginal-moment terminals proved from
the star count inherit its evaluation axiom.

The source is licensed under CC BY 4.0. Public identifiers, remote creation,
push, deposit, and submission remain author decisions.
