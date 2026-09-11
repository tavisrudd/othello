# A referee's route through the proof

The three results to locate first are `thm:uniform-cubic-family`,
`thm:two-variable`, and `thm:separated-pencil`. The surface construction
proves the upper bounds independently. The companion lower bound proves
exactness; its separate Hodge theorem turns arithmetic Jacobian separation
into nonbirationality of first stabilizations.

## Main proof routes

- **Quotient and surface:** Sections 2–4. Check saturation, the integral
  weight differences, the actual tangent-projection isomorphism open and
  uniqueness-based descent. The generic torsor section is equivariant;
  quotienting it leaves a rational two-dimensional torus.
- **Uniform cubic family:** Section 5. The determinant has five distinct
  roots for every constant coefficient choice. The rational point lies on
  no exceptional line. Component equations and their signs identify a
  subgroup of the precise I3 Picard action; the argument allows the Galois
  group to shrink at special coefficients. The seed ranks 25 and 28 give
  three-dimensional moduli image.
- **Arithmetic separation:** Section 6. Keep the local rank proposition in
  view while reading the Prym and elliptic calculations. The component
  double cover is identified with the S3 closure by its square class, not
  by genus alone. Geometric twists disappear for potential reduction but
  must remain in arithmetic trace checks. Toric rank is unchanged by
  isogeny and arbitrary further extensions after semistability.

The squarefree integer argument needs neither generic independence of the
elliptic factors nor an analytic binary-form sieve. The fixed rational
pencil-partner corollary uses a unit equation and gives only necessary
candidates, not a classification or an implemented solver.

## Optional arguments

Appendices A–D give optional generic-surface and fibration consequences,
torus actions, finite rational partner sets, finite-index slices and the
rank-four method limitation. Appendix E supplies the finite nonemptiness
calculation used by the main surface proof; its coordinate details may be
postponed on a first pass. Appendix F records the verification boundary.
For finite index, distinguish lattice index from component degree: the
latter divides the former but need not equal it. The zero-cycle conclusion
does not assert rationality. The original constant-kernel argument is retained.

## Evidence and source boundary

`make check` reconstructs and independently checks the Cox and rank-four
certificates, replays the family/arithmetic symbolic program, checks all
statement digests and source conventions, and builds the paper with no TeX
warnings. It is not a Lean kernel replay. All formal coverage is absent.
The full new symbolic calculation has not been duplicated in a second CAS.

The precise companion revision is bundled as
`references/one-stabilization-september-2026.pdf`. Its Theorems 1.1 and 1.3
are imports; neither follows from this package's computations.
`verification/family-arithmetic.md` records the added evidence, source
pinpoints, commands and trust boundaries. The other evidence and imported
results resolve through the two JSON registries.

An explicit expanded ground-field rationalization would require chosen
descended points, slice equations, a generic torsor section and residual-torus
coordinates. The inverse-graph proof establishes rationality without printing
all those composed maps. Torus actions here are rational actions, not regular
polynomial actions.
