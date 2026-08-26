# C973 Tao second pass — theorem architecture and next proof gates

**Lane:** `reed-solomon` · **Date:** 2026-08-26 · **Status:** adopted as the
second-sprint work programme

## Central judgment

The strongest paper is no longer “R5 through R10 plus a conditional recursive
theorem.”  It is a three-lemma arbitrary-redundancy proof:

1. a terminal-selector converse extracted from C820;
2. rational distinct-marker selection by one Vandermonde product; and
3. the exact R5 member count with one forbidden member charged per marker.

The fixed levels become exact small-field and modular calibrations.  They are
not rungs needed to prove the arbitrary-level theorem.

## Two load-bearing seams

### Seam A — selector converse

The exact statement needed by the main proof is:

> If `f` lies outside `P_r union M^max_(r,p)`, then some homogeneous equation
> `F` of the reduced terminal carrier, of degree at most six, has
> `F(iota_R f)` nonzero as a polynomial in the degree-`r-5` marker form `R`.

This must follow from the C820 row-space theorem on the dense admissible-marker
open without confusing rational points, a projective kernel, or a union of
components.  It should be printed as one standalone proposition rather than
left as an inference across the carrier section.

### Seam B — terminal open

The exact statement needed by the R5 count is:

> A nonzero redundancy-five syndrome outside the reduced terminal carrier has
> a base-point-free cubic pencil, a separable degree-three map, and geometric
> monodromy `S_3`.

The proof must route positive gcd to the Hankel cubic `D=0`, inseparability to
the characteristic-three wild component, and cyclic monodromy to the residual
component in every characteristic.  This too should be a standalone lemma.

These are the two first targets of the second sprint.  If either fails, the
headline theorem must be narrowed immediately.

## Threshold verdict

The improved threshold is likely optimal for this proof architecture.  The
terminal branch weight `12` is sharp, and `m` retained roots can occupy `m`
different split pencil members.  Reducing the constant further would require
new arithmetic information correlating branch fibers with marker fibers, not
better stage bookkeeping.

The specialization

\[
 Q_r^*=28,35,42,50,56\quad(r=6,\ldots,10)
\]

followed by prime-power rounding to `29,37,43,53,59` is structural evidence:
the fixed proofs and the simultaneous proof charge the same terminal object.

## Quantitative opportunity

The lower-bound leading term

\[
                  q^{r-4}/(r-2)!
\]

equals the random codimension-two expectation for split squarefree forms.
The immediate paper claim remains a lower bound.  A stronger generic
asymptotic equality would require controlling selector-zero overlaps and the
distribution of the two moment conditions on `(r-2)`-subsets.  This is a
potential secondary theorem, not a prerequisite for the main result.

## Algorithmic shadow

The Vandermonde proof is constructive with symbolic access to the selector.
Fix marker variables sequentially while preserving a nonzero residual
polynomial; in each variable at most `d` selector values, the previously used
roots, and the prescribed forbidden roots are unavailable.  This suggests a
deterministic fixed-`r` witness finder using `O(mq)` selector evaluations plus
the terminal cubic solver.  C973 may record the theorem, but implementation
and classifier adoption remain foreign.

## Lucas abstraction

The all-level object is a directed graph of adjacent-zero Pascal blocks, not a
list of digit patterns.

- A **transverse edge** leaves the lower carrier and is handled by the pointed
  simultaneous theorem.
- A **coherent edge** lands in a lower carrier and needs one-extra-root
  abundance there.
- A **fresh vertex** introduces genuinely new arithmetic, such as the first
  binary degree-nine final-pair cover.

R11 closes all first blocks asymptotically.  At R12 the fresh
characteristic-five block is transverse, while the `2/3/7` blocks are coherent
and expose the next exact gate: pointed abundance on the R11 constructions.

## Paper-scope judgment

The main paper should not wait for an all-digit-pattern Lucas theorem.  After
the two seams pass independent review, integrate:

- unconditional arbitrary-`r` containment;
- exact large-characteristic deep holes;
- the improved and fixed-level-matching threshold;
- the quantitative witness lower bound; and
- a short R11/R12 calibration of the remaining Lucas arithmetic.

An all-level zero-run graph theorem is a follow-up unless it closes without
lengthening the paper.  The lower-package machinery may be deleted from the
headline spine, but lemmas still cited by exact fixed-level or R11 arithmetic
must be localized rather than removed blindly.

## Second-sprint acceptance gates

1. reconstruct Seam A without appealing to the C973 selector conclusion;
2. reconstruct Seam B directly from the terminal Hankel and monodromy strata;
3. state exact characteristic and zero/rank boundaries in both lemmas;
4. rerun the main theorem composition against the reconstructed statements;
5. pursue either pointed R11 abundance or the deterministic selector theorem,
   whichever is cheaper after the seam audit; and
6. update the paper-successor deletion map if any old package remains cited.

The external independent-specialist gate remains open even if the author-side
reconstruction passes.
