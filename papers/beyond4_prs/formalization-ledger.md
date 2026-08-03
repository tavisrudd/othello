# Formalization coverage ledger

A kernel-checked declaration proves its formal statement from its displayed
hypotheses. It does not prove the geometric, coding, literature, or external
certificate semantics supplied through those hypotheses.

## Shared paper-facing closure

The import gate is RelativeConicArcs.Gates.PRSBeyondRedundancyFour and the
tracked audit is
RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit. Recursive import
resolution gives 17 project-owned Lean files: six gates and eleven
mathematical modules. The closure covers:

- the Hankel split-free dictionary and separate covering-radius interface;
- divided-power contraction, iterated contraction, and squarefree lifting;
- R5 algebra, family/count arithmetic, and certified-table transcription;
- R6/R7 budget arithmetic and conditional all-field synthesis;
- the uniform Seroussi--Roth--Dür range arithmetic;
- polynomial density of monic split-squarefree coefficient tuples over an
  infinite field;
- closure transport, irreducible finite-component selection, and recursive
  persistent/modular descent.

The aggregate audit reports only the standard Lean/mathlib dependencies
propext, Classical.choice, and Quot.sound. It imports no native evaluator,
generated certificate, external oracle, project-local axiom, or declaration
containing sorry.

## Exact mathematical boundary

| Role | Kernel-checked content | Explicit external content |
|---|---|---|
| Hankel dictionary | logical equivalence between split-freeness and absence of a kernel witness | concrete parity-check/Hankel identification |
| Radius promotion | deep iff split-free under a radius-range premise | Seroussi--Roth, Dür, code duality, and field-range identification |
| Polar flags | contraction maps, finite sequence agreement, and conditional witness lifting | concrete polynomial multiplication and projective coordinate semantics |
| Uniform packages | deletion and parameter arithmetic, including Q_r | properness, integrality, scheme degrees, and point-to-polynomial construction |
| Recursive selection | split-coefficient pullback injectivity, polynomial density, closure transport, and finite-component selection | marker-to-rowspace identification, reduced bottom primes, and concrete component classification |
| R5 | Hankel identities, family/count arithmetic, finite-table arithmetic, conditional synthesis | cubic-cover classification, group actions, radius, and certificate semantics |
| R6/R7 | exact budget specializations, finite-row arithmetic, conditional synthesis | catalecticant/nucleus geometry, genuine projective actions, radius, and finite-record semantics |
| Persistent families | declared disjoint-union cardinality and cyclic quotient arithmetic | geometric parametrization, disjointness, stabilizers, and exhaustion |

## Version 2 degree-specific coverage

| Manuscript result | Formal status | Exact boundary |
|---|---|---|
| finite-depth escape | contraction/lifting algebra and conditional interface checked | successive marker choice and terminal point count are printed proofs |
| reduced recursive carrier | density, closure, component selection, and recursive implication checked | exact fibrewise primes, Pascal nesting, rowspace identification, and consecutive-row exclusions are printed/certified geometry |
| uniform high-characteristic theorem | threshold and radius-range composition checked | carrier geometry and cited coding theorems remain explicit |
| R5--R7 | conditional terminals in the paper-facing aggregate | concrete proofs and certificates retain their separate trust routes |
| R8 | existing companion conditional terminal | not silently imported into the 17-file aggregate; manuscript proof and Certificate R8 are authoritative |
| R9 | existing residual algebra and companion conditional terminal | slice geometry, characteristic-seven bridge, and Certificate R9 remain external |
| first higher Lucas carrier | no carrier-exhaustion Lean theorem | manuscript final-pair proof and q=16,32,64 certificates |
| R10 | conditional composition uses shared recursive/radius interfaces | the empty-carrier arithmetic is supplied by the manuscript and certificates |

The row-by-row reconciliation for all 71 numbered manuscript labels is
supplement/LEAN-STATEMENTS.md. That map distinguishes kernel algebra,
conditional terminals, manuscript proofs, cited results, and external
certificates for every label.

## Literature adapters

- Seroussi--Roth Theorem 1 supplies high-rate GRS nonextendability.
- Dür supplies completeness--covering-radius equivalence, in the form checked
  against Kaipa Section IV.
- Kaipa and Zhang--Wan--Kaipa supply the syndrome/MDS dictionary and lower
  persistent families.
- Aubry--Perret supplies the singular-curve point bound.
- Gmainer--Havlicek supplies the NRC nucleus criterion.
- Wang supplies étale splitting-family Frobenius semantics.
- Wang--Wu--Hu Proposition 11 supplies the projective-subline endpoint
  criterion.

Lean treats each consumed implication as a separate explicit input; it makes
no novelty or priority statement.

## Finite evidence

External JSON and text certificates are not called Lean proofs. The R5--R7
transcription modules kernel-check internal arithmetic while semantic
validation and exhaustive coverage remain public validation fields. R8, R9,
R10, stable-component, direct-locus, and Lucas-carrier bundles are checked by
the paper-local verifier and retain their own generator/replay boundaries.

## Reproduction

The supported aggregate gate is:

    (cd lean && nix develop --command lake build \
      RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit \
      RelativeConicArcs.Gates.PRSBeyondRedundancyFour)

The balanced q=8 quantum consequence retains its separate
RelativeConicArcs.Gates.PRSBalancedQuantumExtension gate and axiom audit so
the AME--LU dependency closure is not misreported as part of the PRS
geometric aggregate; those modules are outside this paper export.
