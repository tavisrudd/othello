# Version 2 theorem adoption map

This map records the claims adopted by Version 2. “Complete” always refers to
the stated field range; proof, certificate, formal, radius, and release
boundaries remain separate.

| Source | Manuscript result | Adopted strength | Exact boundary | Proof/evidence route |
|---|---|---|---|---|
| R5 | Complete redundancy-five classification | all prime powers q >= 7 | exact sporadic fields 7,8,9,11,13,17,19 | printed cubic-pencil proof plus Certificate R5 |
| R6 | Complete redundancy-six classification | all prime powers q >= 7 | bounded exception delta and recurring odd-binary nucleus orbit | printed depth-one proof plus R6/R6-NF certificates |
| R7 | Complete split-free classification | all prime powers q >= 7; deep holes for q >= 11 | no radius promotion at q=7,8,9 | printed depth-two proof plus compact R7 record and direct-locus replay |
| Polar escape | Finite-depth coherent marked contraction | arbitrary finite depth under explicit stagewise data | supplies neither carrier geometry nor radius | printed construction; contraction/lifting algebra kernel checked |
| Recursive carrier | Exact reduced contained carrier | every r >= 6, fibrewise over each characteristic | persistent scheme plus one maximal adjacent-zero Lucas carrier; no uniform nilpotent integral model | printed reduced-prime, Pascal, density, and generic-point proofs; stable-component replay; kernel-checked density/selection |
| Uniform consequence | Conditional split-free containment and high-characteristic classification | q >= 6r-15+floor(2 sqrt(6r-17)) | requires explicit stagewise lower packages; exact deep holes when these hold and char(F_q) > r-1 | recursive carrier plus stated package hypothesis and Seroussi--Roth--Dür radius route |
| R8 | Persistent-only deep holes | q >= 43 | no bounded-field classification | printed three-marker proof plus Certificate R8 |
| R9 | Persistent-only deep holes | q >= 53 | characteristic-seven carrier handled by slice theorem and finite bridge | printed residual-quadratic proof, appendix, and Certificate R9 |
| Higher Lucas | Empty first fresh carrier | every F_(2^m), m >= 4 | projective-subline endpoint attributed to Wang--Wu--Hu; full carrier uses the final-pair criterion | printed all-field proof; full-carrier q=16,32 certificates and invariant-block q=64 certificate with independent replay |
| R10 | Persistent-only deep holes | every prime power q >= 59 | odd fields from the recursive theorem; binary fields use the empty-carrier theorem | printed synthesis plus R10 and Lucas evidence bundles |
| Lean boundary | Algebra, arithmetic, density, selection, and conditional synthesis | exact declarations in formalization-ledger.md and supplement/LEAN-STATEMENTS.md | concrete carrier primes, group actions, cited theorems, and external certificate semantics remain explicit | 17-file paper-facing aggregate plus separately identified companion terminals |

## Stable source labels

- thm:main: Version 2 headline.
- thm:r5, thm:r6, thm:r7: all-field R5--R7 statements.
- thm:induction: finite-depth polar escape.
- thm:recursive-carrier: all-level reduced carrier and uniform consequence.
- thm:r8, thm:r9, cor:r10: fixed high-field classifications.
- thm:m9-shallow: empty first higher Lucas carrier.

The complete set of 71 numbered labels is reconciled mechanically against
supplement/LEAN-STATEMENTS.md.

## Boundaries

- Split-free and deep-hole statements are separated by a named radius premise.
- The all-level theorem classifies possible carriers in small characteristic,
  not the arithmetic of every later Lucas carrier.
- The reduced theorem is fibrewise. It does not assert a flat reduced
  arithmetic model or classify nilpotent/embedded structure of a chosen model.
- Wang--Wu--Hu Proposition 11 owns the projective-subline endpoint criterion.
- The second R7 direct-locus route shares the published direct-locus engine, the R5
  finite-field layer, and the proved R6 pointed classification from q >= 16;
  its checker is not a second finite-field implementation.
- Version 1, its public commit, DOI, tag, and archive remain immutable.
