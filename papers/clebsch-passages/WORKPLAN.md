# Paper III work plan

**Status:** two-leg synthesis complete; aggregate release gate and cold review
green on 2026-07-26.

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
          +----> C652 arithmetic fibres / exchanger / T11 / carriers
          |                 |
          +----> C653 integral model / invariant theory / novelty
                            |
                            +----> core Hitchin--Clebsch theorem

C655 exact face-axis Gram matrix / Gaunt restriction / physical-source audit (complete)
          |
          +----> harmonic realization theorem

core theorem + harmonic theorem + exact trust surface
          |
          +----> C579 synthesis and cold review (complete)
```

## Drafting order

| Stage | Mathematical output | Manuscript destination | Gate |
|---|---|---|---|
| 1 | localized odd-generator lemma | Section 2 | prose proof complete |
| 2 | finite tensor bridge | Section 3 | C651 complete |
| 3 | golden fibres and `A4` hinge | Section 4 | C652 |
| 4 | exchanger, spinor class, and `T11` | Section 4 | C652 |
| 5 | rational cover, abstract integral base, invariant-ring input, and finite-set incidence boundary | Sections 2 and 4 | C653 complete |
| 6 | exact face-axis harmonic embedding and Gaunt cubic | Section 5 | C655 complete |
| 7 | exact Klein commutants and polarization | omitted after discriminant-zero test | C654 complete |
| 8 | consequences, novelty, and final hierarchy | Introduction/Section 7 | after C652--C655 |
| 9 | statement identity and release replay | Verification | C579 |

## Editorial acceptance

The cold review confirmed:

- every theorem-like statement has a ledger row and an exact proof mode;
- the main theorem is visible on page 1 or 2 and has no gated clause;
- every finite computation has a primary certificate and independent replay;
- every classical input has been checked against its primary source;
- the integral exceptional-prime boundary is explicit;
- the harmonic section proves equality with the established order parameter
  under an explicit normalization and does not claim empirical utility;
- theta, Fourier, quantum, and holonomy material has either become a
  consequence or been cut; and
- the PDF builds without warnings.

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
