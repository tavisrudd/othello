# Paper III work plan

**Status:** focused-note revision in progress after the first candidate
review; the next independent release decision is C670.

## Realized theorem surface

The paper proves the strongest coherent theorem complex supported by the
arithmetic and harmonic calculations:

1. Hitchin's ordered-icosahedron cover restricts on the Clebsch chart to the
   golden orientation torsor.
2. The explicit golden fibre and exchanger have good reduction modulo `11`;
   the exchanger becomes the finite Clebsch sheet involution, and the signed
   matching tensor lies on the same integral cubic orientation line.
3. The cubic orientation line is the four-channel restriction of the
   standard degree-six Gaunt/Steinhardt invariant on icosahedral face axes.
The exact C654 relative-commutant invariant has discriminant zero rather
than `5`.  The detachable Klein section is therefore excluded from the
paper.  Item 3 is the second theorem scale and shapes the title, abstract,
and introduction.

## Dependency graph

```text
C651 exact tensor bridge (complete)
          |
          +----> C652 arithmetic fibres / exchanger / T11
          |                 |
          +----> C653 integral model / invariant theory / novelty
                            |
                            +----> core Hitchin--Clebsch theorem

C655 exact face-axis Gram matrix / Gaunt restriction (complete)
          |
          +----> harmonic realization theorem

core theorem + harmonic theorem + exact trust surface
          |
          +----> C579 first candidate synthesis (complete)
          +----> C669 literature and claim-ownership audit (complete)
          +----> C668 focused-note revision
          +----> C670 independent release review
```

## Drafting order

| Stage | Mathematical output | Manuscript destination | Gate |
|---|---|---|---|
| 1 | localized odd-generator lemma | Section 2 | prose proof complete |
| 2 | finite tensor bridge | Section 3 | C651 complete |
| 3 | golden fibre | Section 4 | C652 |
| 4 | exchanger, spinor class, and `T11` | Section 4 | C652 |
| 5 | rational cover, abstract integral base, invariant-ring input, and finite-set incidence boundary | Sections 2 and 4 | C653 complete |
| 6 | exact face-axis harmonic embedding and Gaunt cubic | Section 5 | C655 complete |
| 7 | exact Klein commutants and polarization | omitted after discriminant-zero test | C654 complete |
| 8 | common-line boundary and final hierarchy | Introduction/Section 7 | C668 |
| 9 | statement identity and release replay | Verification | C668/C670 |

## Editorial acceptance

The focused revision requires:

- expand the rational square-class argument from the branch divisor to the
  golden fibre;
- state the finite matching quotient without requiring the factorization
  paper's notation;
- remove the detachable tetrahedral and marked-Mathieu branches;
- retain the exact Gaunt normalization while removing the speculative
  physical descriptor; and
- obtain a new context-free release review after the seven-statement trust
  surface and warning-free PDF are regenerated.

## Stop rules

- A negative C654 result does not weaken the arithmetic cover, but it must be
  reported exactly and the Klein section must not survive as speculation.
- Failure to identify the reduced exchanger with `T11` blocks the core
  theorem.
- The abstract quadratic algebra has forced bad primes `2,5`; the
  classical invariant presentation is used over `Z[1/30]`; the geometric
  incidence comparison uses the proved spread-out finite-set formulation
  because no source or available equation determines its minimal bad set.
- A resemblance of fields is not a bridge: the final paper needs a canonical
  map or invariant.
