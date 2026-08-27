# Version 2 theorem adoption map

This map records the claims adopted by Version 2. “Complete” always refers to
the stated field range; proof, certificate, formal, radius, and release
boundaries remain separate.

| Source | Manuscript result | Adopted strength | Exact boundary | Proof/evidence route |
|---|---|---|---|---|
| R5 | Complete redundancy-five classification | all prime powers q >= 7 | exact sporadic fields 7,8,9,11,13,17,19 | printed cubic-pencil proof plus Certificate R5 |
| R6 | Complete redundancy-six classification | all prime powers q >= 7 | bounded exception delta and recurring odd-binary nucleus orbit | printed depth-one proof plus R6/R6-NF certificates |
| R7 | Complete split-free classification | all prime powers q >= 7; complete deep holes for q=8 and q >= 11 | radius open at q=7,9 | printed depth-two proof plus compact R7 record, direct-locus replay, imported even-diagonal radius, and exact q8 distance extraction |
| Stagewise polar interface | Finite-depth coherent marked contraction | fixed-level refinements under explicit stagewise data | appendix mechanism only; not an input to the arbitrary-redundancy theorem | self-contained printed proofs; contraction/lifting algebra partly kernel checked |
| Recursive carrier | Exact reduced contained carrier | every r >= 6, fibrewise over each characteristic | persistent scheme plus one maximal adjacent-zero Lucas carrier; no uniform nilpotent integral model | explicitly defined terminal elimination scheme, computer-assisted prime decomposition, printed Pascal/density/generic-point proofs, and kernel-checked density/selection |
| Simultaneous escape | Pointed split-squarefree locator outside the carrier | every r >= 6 and q >= 6(r+s)-16+floor(2 sqrt(6(r+s)-18)); sharper binary bound | avoids any prescribed deleted set of size s; no intermediate lower packages | composite contraction, degree-six selector, Vandermonde grid, and exact R5 pencil count |
| High-weight cosets | Every coset of weight at least r-1 for point-deleted GRS/EGRS support | same pointed range; exact classification when char(F_q) > r-1 | s=0 has only the r-1 shell; s>0 has the r and r-1 shells | simultaneous escape, rank-two stratification, arc independence, and Seroussi--Roth deep-shell input |
| One-column extensions | Complete MDS/NMDS appended-column classification | high-weight-coset range | full support has no MDS extension; other columns have defect at least two | circuit identity d(ker[H_S|f])=d_S(f)+1 and dual-distance argument |
| Family-aggregate NMDS enumerators | Exact tangent, conjugate-secant, and incident-split-secant aggregate enumerators | high-weight-coset range | aggregates and averages, not equality of individual coset distributions | family-wise hyperplane incidence count plus the standard NMDS recurrence |
| Lean boundary | Algebra, arithmetic, density, selection, and conditional synthesis | exact declarations in formalization-ledger.md and supplement/LEAN-STATEMENTS.md | concrete carrier primes, group actions, cited theorems, and external certificate semantics remain explicit | 17-file paper-facing aggregate plus separately identified companion terminals |
| Companion toolkit | Canonical forms, exact distance/decoding execution, theorem-gated classification, and certificate replay | structural and metric commands for every `r>=5`, `q>=r`; classification registry R5--R10 plus the even diagonal family | locator replay checks the displayed error pattern but not lower-degree exhaustion; no generic R11+ deep-hole promotion | locked Rust tests, versioned registries, software manifest, and standalone extraction replay |

## Stable source labels

- thm:main: Version 2 headline.
- thm:composite-contraction, lem:vandermonde-grid, lem:terminal-selector,
  thm:simultaneous-marker-escape, cor:split-witness-abundance: uniform
  arbitrary-redundancy mechanism.
- cor:one-column-extensions, thm:family-aggregate-nmds: coding consequences.
- thm:r5, thm:r6, thm:r7: all-field R5--R7 statements.
- thm:induction: supplementary stagewise fixed-level interface.
- thm:recursive-carrier: all-level reduced carrier and uniform consequence.
- R8--R10 fixed-level calculations remain in the companion source/evidence
  record and are not claims of this submission.

The complete set of 55 numbered labels is reconciled mechanically against
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
