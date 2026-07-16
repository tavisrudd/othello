# C211 cold read — the `A3/H3` manuscript integration

**Lane:** `clebsch`

**Date:** 2026-07-16

**Scope:** fresh referee-style read of the rendered 19-page Clebsch paper, with special attention
to narrative coherence, correctness and placement of the new reflection-arrangement material,
priority posture, characteristic boundaries, and whether the addition earns its space.

## Overall verdict

No blocking mathematical defect was found in the `A3/H3` addition. The root coordinates,
intersection ledger, characteristic polynomials, complement counts, q=11 ambiguity spectrum, and
q=5 frame calculation are mutually consistent. The priority posture is careful and credible.

The addition is a real upgrade: it gives a memorable structural explanation for the decoder strata
and prevents the `(4,5)` and `(6,11)` conic-filling exceptions from looking accidental. In the
reviewed draft, however, it appears too early and is partly duplicated. The paper is plausibly
publishable after a moderate organizational revision.

## Material findings

### 1. The `H3` material is deployed before the paper has introduced the code

The full complement and decoder spectrum appears in the Clebsch-hexagon section before the code is
formally introduced, while the decoding proposition later derives the same
`960,150,100,120` ambiguity data. This is genuine duplication and delays the title theorem, which
already arrives comparatively late.

**Recommended edit:** make the reflection-arrangement synthesis a capstone near the finite-field
and small-arc boundary. A coherent global order is

```text
hexagon/code locus -> rigidity -> decoder/chirality
                   -> finite-field boundary and A3/H3.
```

At minimum, keep the exact bridge and the arrangement consequences together rather than splitting
`H3` near the front and `A3` near the end.

### 2. “Explains conic filling” overstates the characteristic-polynomial calculation

The arrangement lattice explains the complement cardinalities and incidence/ambiguity strata. It
does not alone prove that a complement is the rational point set of a nonsingular conic. The H3
case also uses Dye's conic inclusion, while the A3 frame uses a direct quadratic verification.

**Recommended edit:** say that the arrangements *organize* the two cases, and explicitly separate
the size equation from the geometry upgrading equal cardinality to equality with a conic.

### 3. The characteristic-two sentence is imprecise

The q=4 root is obtained by formally continuing the factored H3 complement polynomial. The
displayed H3 arrangement does not retain its lattice in characteristic two.

**Recommended wording:**

> The extraneous root q=4 lies precisely in the bad characteristic-two regime, where the displayed
> H3 reduction degenerates.

This is a prose correction; the theorem independently excludes q=4 through the hyperoval
argument.

### 4. Keep the field-of-definition scope visible

The explicit H3 root model assumes characteristic different from two and a root of
`t^2-t-1`. The all-field Clebsch uncovered formula is separately safe because it follows from the
chord-defect identity for every existing Clebsch hexagon. The comparison must not make the stronger
root-model statement appear uniform over every finite field.

**Recommended edit:** qualify the comparison as occurring in the faithful-reduction range, while
distinguishing it from the combinatorial all-field count.

### 5. State the residual contribution more sharply

The novelty paragraph correctly concedes the classical icosahedral geometry and the general
derived-arrangement decoder machinery. Its final sentence should name the three paper-specific
additions:

1. the explicit `PGL_3(F_11)` bridge from the reduced H3 fivefold points to the displayed code;
2. the specialization of its strata to this code's decoder data;
3. the joint `A3/H3` organization of the two conic-filling exceptions.

### 6. Put `A3` and `H3` in one visible synthesis

In the reviewed draft, H3 and A3 are separated by roughly twelve pages. A single subsection such
as “The two reflection-arrangement exceptions” would make the comparison table function as the
promised synthesis. The small-k theorem is what makes A3 substantive rather than decorative; its
content should remain.

## Minor findings

- Use `F` rather than `K` for the field in the H3 coordinate model; `K` later denotes a Clebsch
  hexagon.
- State the coordinate convention for the dual action: if points are columns and `x -> T x`, a
  line written as a row transforms by `ell -> ell T^-1`.
- Define an ordinary mirror point as one lying on exactly one mirror.
- Explicitly distinguish the central rank-three hyperplane arrangement from its projectivized
  fifteen-line arrangement before dividing the characteristic-polynomial complement by `q-1`.
- Retain the abstract's A3/H3 sentence only if the body presents the synthesis with comparable
  integration.

## Publication assessment

The code/rigidity/small-k spine remains strong. The symmetry-free rigidity theorem is the genuine
conceptual center; the separation of conceptual proof from finite census is clear; decoder
reconstruction and chirality are natural consequences; and the finite-field/small-k boundary gives
the paper a satisfying finish.

The reflection-arrangement addition earns one compact subsection and materially improves
memorability. In the reviewed split form, it was estimated to be 25--35% longer and more intrusive
than warranted.

**Publication-grade verdict:** mathematically credible, priority posture sound, moderate revision
recommended.
