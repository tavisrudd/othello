# C892 — Paper II initial formal-interface inventory

**Lane:** `clebsch` · **Date:** 2026-08-08 · **Status:** incomplete lower-bound inventory

This file records the first thirty-seven paper-facing declaration names and
the mathematical content already known to require direct types.  It is not a
complete assertion audit and does not freeze the final count.  A declaration
is complete only when its
elaborated type directly expresses the stated objects, hypotheses,
quantifiers, exceptional cases, equalities and uniqueness clauses.  It may
use proved helper structures, but it may not assume its conclusion, replace a
classification by a finite list predicate, or turn a cited input into a
project axiom.  The final trust manifest records fully qualified declaration
names and statement-identity hashes, not only evidence-bundle names.

The provisional namespace is `RelativeConicArcs.ClebschPaperII`.  The headline theorem is
a conjunction derived from the exact component declarations below; it is not
an independent certificate wrapper.

## Numbered statement interface

| manuscript label | provisional declaration | required type surface |
|---|---|---|
| `thm:factorization-recovery` | `factorizationRecovery` | all six printed clauses, including the all-odd-prime-power classification and fixed-line exception count |
| `prop:matching-secant-quotient` | `matchingSecantQuotient` | arbitrary `m ≥ 2`, arbitrary perfect matchings, conic restriction/divisibility, reference translation and determinant-normalized equivariance |
| `lem:projective-trade-reduction` | `projectiveTradeReduction` | the printed module data, both extension cases, and the exact Ext-class identity |
| `lem:lucas-socle-square-parity` | `lucasSocleSquareParity` | all odd prime powers, digitwise socle iff and Hom-basis claim, extension parity vanishings, and contraction/nonsplitting clause |
| `lem:uniform-sheet-exclusion` | `uniformSheetExclusion` | intrinsic full matching orbit hypotheses imply that either sheet has `q` members |
| `thm:balanced-orbit-completeness` | `balancedOrbitCompleteness` | intrinsic trade hypotheses classify exactly `B₃/F₇` and `H₃/F₁₁`, with both converses and intrinsic sheets |
| `lem:shared-radial-cycle` | `sharedRadialCycle` | endpoint-edge uniqueness, one shared edge, complementary alternating cycle and nonzero deepest radial projection for `q=7,11` |
| `thm:rank-three-quotients` | `rankThreeQuotients` | the three exact spaces/ranks, uniform Coxeter formula, fullness clauses and canonical `H₃` ten-space |
| `cor:h3-affine-origin` | `h3AffineOrigin` | one-dimensional cohomology, no equivariant origin, nonsplit homogeneous module and uniqueness up to equivalence/rescaling |
| `cor:h3-middle-layer` | `h3MiddleLayer` | Fischer direct sums, quotient identification, Laplacian characterization and exact omitted five-space |
| `prop:radical-hadamard` | `radicalHadamard` | the four printed hypotheses imply both Schur-square equalities and uniqueness of every strength-two trade |
| `prop:modular-sheet-mechanism` | `modularSheetMechanism` | both finite configurations satisfy all four Radical–Hadamard hypotheses with the stated harmonic/radial decomposition |
| `thm:fixed-line-chow-rigidity` | `fixedLineChowRigidity` | fixed affine line, distinct orbits/stabilizers, unique Chow point, noncoalescent orbit size/trade line and exactly `q-2` nonmatching exceptions |
| `lem:hyperplane-square` | `hyperplaneSquare` | finite `Ω`, unital `L`, `dim L > 1`, full-support weighted Schur-square hyperplane equality implies `L^{∘3}=k^Ω` |
| `thm:balanced-cubic` | `balancedCubic` | unique complementary balanced halves, moments `1,2` zero and `3` nonzero, reference independence, exact stabilizers and minimal signed-moment degree |
| `cor:graded-evaluation` | `gradedEvaluation` | every displayed Schur-power dimension, cubic fullness, Hilbert function and h-vector for both configurations |
| `cor:self-associated-gorenstein` | `selfAssociatedGorenstein` | reduced self-association, arithmetically Gorenstein property, deletion/Cayley–Bacharach statement, residue sign and cubic inverse-system line |
| `cor:secant-product-syzygies` | `secantProductSyzygies` | the two vanishing symmetric-tensor sums and the nonzero cubic identity through `Sym³(m_Q)` |
| `thm:six-profile-reconstruction` | `sixProfileReconstruction` | exact orbit sizes, six profiles/fibres, distinctness, double-coset recovery, rank-two plane, singleton recovery and larger-fibre limitation |
| `cor:decorated-sheet-classifier` | `decoratedSheetClassifier` | oriented profile determines sheet; antipodal singleton pair and oriented choice recover exactly the stated parents |
| `cor:profile-ray-weights` | `profileRayWeights` | normalized vectors recover orbit sizes and stabilizer orders, while rational rays alone do not |
| `prop:modular-depth-quotient` | `modularDepthQuotient` | projective-cover identification and Loewy layers, exact kernel, quotient isomorphism and negative sheet copy |
| `cor:h3-nine-space-bridge` | `h3NineSpaceBridge` | canonical module isomorphism with formula on augmentation classes and reference independence |
| `cor:h3-homogeneous-projective-cover` | `h3HomogeneousProjectiveCover` | homogeneous module isomorphism with printed formula, nonsplit exact sequence and full-affine decomposition |
| `lem:split-inert-frames` | `splitInertFrames` | all three factorizations, `F₂₅/F₅` Frobenius orbit, and root exchange by the split marker involutions |
| `thm:rank-three-arithmetic-gluing` | `rankThreeArithmeticGluing` | fused/split trichotomy, exact `A₅/A₄/PSL₂(11)/S₄` subgroup assertions, outer transporter and determinant/profile/sheet dictionary |
| `lem:three-ray-cubic` | `threeRayCubic` | arbitrary field of characteristic not `2,3`, nonzero weights and basis hypotheses imply moments `1,2` vanish and cubic tensor is nonzero |
| `cor:mass-zero-cubic` | `massZeroCubic` | the displayed tensor factorization, distinct doubled/residual lines and Hessian recovery |
| `prop:relative-cubic-tate-plane` | `relativeCubicTatePlane` | invariant/coinvariant dimensions, ranks, exact images/kernels, contraction matrix and common kernel line |

## Initial remarks and narrative floor

The statement extractor must cover these mathematical surfaces as well.  The
provisional declarations are `paleyCarrier`, `historicalRadialScalars`,
`fixedLineCoalescence`, `ambientIntrinsicSheetRecovery`, `badProfilePrimes`,
`cubicTargetFlag`, and `tateDepthBoundary`, matching the seven remark
environments in manuscript order.  Their types are not frozen by these names:
each remark first needs a clause-by-clause assertion audit.  In particular,
`tateDepthBoundary` must separately expose the non-isomorphism of labelled
source and depth planes, the integral-transfer obstruction, the invariant and
coinvariant maps and ranks, and the two distinct canonical-plane statements
made in the manuscript.  The unnumbered relative-cubic projective-line census
maps provisionally to `relativeCubicProjectiveLineCensus` and must state the
exact `1 + 1 + 131 = 133` rank distribution and uniqueness assertions.

Editorial or historical prose that makes no mathematical assertion remains
outside the gate.  Every proof and narrative paragraph still requires a
sentence-level pass.  Each further mathematical assertion found there is
added here and to statement identity before the interface can be frozen or
proof work declared complete.  This list is a floor, not an exemption
mechanism.

## Gate and ledger contract

- The final aggregate gate is generated only after the sentence-level audit.
  It includes at least these 37 provisional surfaces—29 numbered statements,
  seven remarks, and the projective-line census—but no exact terminal count is
  claimed yet.
- The release verifier compares the exact declaration-name identity and
  rejects duplicates, omissions and substitutions.
- Each trust-manifest row records its exact declaration and source-statement
  hash. Ingredient terminals remain useful provenance but cannot satisfy a
  paper-facing row.
- The headline theorem closes last, after its six component declarations are
  available without conclusion-bearing assumptions.
