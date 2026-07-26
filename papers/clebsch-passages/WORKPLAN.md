# Paper III work plan

## Final target

The final paper should prove the strongest coherent theorem complex supported
by the arithmetic and Hodge calculations:

1. Hitchin's ordered-icosahedron cover restricts on the Clebsch chart to the
   golden orientation torsor.
2. Its deck exchange specializes modulo `11` to the finite Clebsch sheet
   involution, and the signed matching tensor is the reduction of the same
   cubic orientation line.
3. The cubic orientation line is the four-channel restriction of the
   standard degree-six Gaunt/Steinhardt invariant on icosahedral face axes.
4. The two icosahedral multiplicity structures in the Klein intermediate
   Jacobian have an intrinsic relative invariant with discriminant `5`.
5. If the 55-curve index-two lattice detects the same orientation, state that
   as the integral geometric realization of the Hodge comparison.

Items 3 and 4 are not decorative applications.  If positive, they become the
second half of the main theorem and shape the title, abstract, and
introduction.

## Dependency graph

```text
C651 exact tensor bridge (complete)
          |
          +----> C652 arithmetic fibres / exchanger / T11 / carriers
          |                 |
          +----> C653 integral model / invariant theory / novelty
                            |
                            +----> core Hitchin--Clebsch theorem

C654 rational Klein representation / polarization / relative invariant
          |
          +----> 55-curve saturation and orientation test
          |
          +----> strong Klein theorem

C655 exact face-axis Gram matrix / Gaunt restriction / physical-source audit (complete)
          |
          +----> harmonic realization theorem

core theorem + harmonic theorem + strong Klein theorem + exact trust surface
          |
          +----> C579 synthesis, cold review, and release decision
```

## Drafting order

| Stage | Mathematical output | Manuscript destination | Gate |
|---|---|---|---|
| 1 | localized odd-generator lemma | Section 2 | prose proof complete |
| 2 | finite tensor bridge | Section 3 | C651 complete |
| 3 | golden fibres and `A4` hinge | Section 4 | C652 |
| 4 | exchanger, spinor class, and `T11` | Section 4 | C652 |
| 5 | integral base and invariant-ring input | Sections 2 and 4 | C653 |
| 6 | exact face-axis harmonic embedding and Gaunt cubic | Section 5 | C655 complete |
| 7 | exact Klein commutants and polarization | Section 6 | C654 |
| 8 | canonical discriminant-`5` invariant | Section 6 and main theorem | C654 |
| 9 | 55-curve orientation realization | Section 6 or appendix | conditional C654 continuation |
| 10 | consequences, novelty, and final hierarchy | Introduction/Section 7 | after C652--C655 |
| 11 | statement identity and release replay | Verification | C579 |

## Editorial acceptance

The manuscript advances to cold review only when:

- every theorem-like statement has a ledger row and an exact proof mode;
- the main theorem is visible on page 1 or 2 and has no gated clause;
- every finite computation has a primary certificate and independent replay;
- every classical input has been checked against its primary source;
- the integral exceptional-prime boundary is explicit;
- the Klein section contains a theorem, not a suggestive analogy;
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
- Failure to justify a sharp bad-prime set forces the theorem to use the
  proved spread-out finite-set formulation.
- A resemblance of fields is not a bridge: the final paper needs a canonical
  map or invariant.
