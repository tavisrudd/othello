# C634: square-root carrier formalization

**Lane:** `relconic`

**Date:** 2026-07-25

**Status:** active.  Formalize the stable local and combinatorial core of
C626's square-root carrier theorem without enlarging the manuscript or
claiming that Lean checks the global Chow-product gluing argument.

## Mathematical scope

The formal target has three layers.

1. A linear jet on three carrier directions kills the conductor covariant
   whenever the directions satisfy their unique linear relation.
2. In characteristic two, the square of that covariant is the weighted sum of
   the second Hasse coefficients.
3. If every arc in a finite carrier set has size at most `k`, any deletion
   which leaves an arc removes at least `|X|-k` points.

The global statement that square restrictions of the dual Chow product glue
over a general-position line arrangement remains an analytic theorem unless a
short axiom-free implementation is supported by the pinned polynomial and
projectivization APIs.

## `ej`, degrees of freedom, and Tao stress pass

The useful upgrade is the normalization-conductor formulation.  At a point
where `s` carrier lines meet, pairwise equality of the canonical square roots
settles their common value but leaves
\[
 \binom{s-1}{2}
\]
local compatibility coordinates.  For `s=3`, the sole coordinate is the
first-jet covariant formalized here.  Higher multiplicity requires jets
through order `s-2`; pretending that pairwise values suffice would incorrectly
force the global Chow product to be a square.

The unexplained degrees of freedom are:

- the scalar representative of the Chow product, absorbed by perfectness;
- representatives of the carrier directions and their one linear relation;
- the local trivialization of the degree-`m` line bundle;
- the distribution of carrier-line multiplicities above three;
- the missing upper bound on the resulting conductor class; and
- in odd characteristic or odd arc size, the noncanonical removal of the
  residual tangent factor.

The zero or nonzero value of the first-jet covariant is unchanged by the first
three choices.  The fourth is genuine mathematical data.  The fifth is the
remaining route to a defect gap.  The sixth marks the current parity boundary.

The Tao-style check asks for the invariant object rather than a coordinate
formula.  It is the class of the tuple of canonical linewise square roots in
the conductor quotient of the normalization of the carrier-line arrangement.
Its square descends because it is the restriction of the global Chow product,
while the class itself need not vanish.  The local first-jet covariant is the
first coordinate of this Frobenius-killed obstruction.

## Acceptance gate

- dedicated Lean module elaborates through `lean/scripts/guarded-lean`;
- dedicated import-only gate elaborates and prints the axioms of every public
  terminal;
- all terminals use only the standard kernel trust boundary reported by
  `#print axioms`;
- the module-wide prose and naming audit passes; and
- the report distinguishes formalized statements from the analytic global
  carrier theorem.
