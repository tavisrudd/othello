# C132 — Second-instance spike: is there another "deep-hole locus = F_q-points of a named variety"?

**Date**: 2026-07-14
**Verdict**: **NO clean second instance among the four tested targets.** The 27-lines/W(E₆),
Valentiner A₆, 57-cell/PSL₂(19), and Hesse candidates each fail the arc/deep-hole template. The
Valentiner and Hesse computations are independently reproducible; the negative closes this spike,
not the global search for a second named-variety deep-hole example.

## Adversarial correction (2026-07-14)

The first committed report conflated two models of `GQ(2,4)`, placing its 27 points in `PG(5,4)`
and claiming that they had no ambient complement. The classical projective model is instead the
elliptic quadric `Q⁻(5,2) ⊂ PG(5,2)`, whose complement has 36 points. The local rejection still
holds because the quadric contains 45 projective lines and hence is not a cap. The audit also
removed the stronger claim that these four failures exhaust every genus-zero or `P¹` route.

Template being replicated (icosahedral F₁₁ case, SOLVED): a small **arc** config `A` (6 axis-poles,
a genuine 6-arc) in `PG(2,11)`, whose **deep-hole locus** `U` = points off `A` and off all 15
secants = the **full 12 F₁₁-points of the A₅-invariant conic** (= P¹), with group cause A₅.

## Common diagnostic and candidate-specific failures

The template needs the config to be an **arc / cap** (NO 3 collinear) and the *exceptional named
variety to sit on the DEEP-HOLE side* (the uncovered locus), while the config is a plain arc.

The gem detector was keyed to coincidences of the form `|config|=|space|`, which often selects
rich-incidence configurations rather than caps. That mismatch kills the 27-line and Hesse targets;
the Valentiner and 57-cell targets fail for the separate orbit-size and group-embedding reasons
below. Thus there is a useful common diagnostic, but not one theorem disposing of every candidate.

The icosahedral case is rare precisely because it **decouples**: the exceptional structure
(icosahedron = 12 conic points) is the deep-hole locus, and the config (6 poles) is a separate,
genuine 6-arc. None of the candidates reproduce that decoupling.

## Framing verdict for 27-lines / W(E₆) (the ½-value task)

**The proposed arc/MDS covering reading fails. Decisive for this template.**

- The 27 objects with their 45 distinguished triples form the generalized quadrangle `GQ(2,4)`.
  Its classical projective realization is the elliptic quadric `Q⁻(5,2)` in `PG(5,2)`: 27 points
  on the quadric and 36 ambient points off it. Each of the 45 quadrangle lines is an actual
  three-point projective line, so the 27-point set is not a cap and cannot be the column set of the
  proposed MDS/deep-hole template. See the explicit `Q⁻(5,2)` models in
  [Saniga et al.](https://arxiv.org/abs/0903.0715) and
  [Blunck et al.](https://arxiv.org/abs/1009.1768).
- The `E₆` weight/minuscule description explains the line-configuration combinatorics, but the
  spike did not construct or validate a separate reduction in `PG(5,4)`. No assertion about the
  secant complement of such a reduction is retained.
- Consequence: 27-lines/W(E₆) stays a **shared object** with the icosahedral case (via
  Brianchon=Eckardt → W(E₆), the R-A link) but is **not a second covering-instance**.

## Candidate ran in full: Valentiner A₆ ⊂ PGL₃ (fallback b) — DEAD, certificate-grade

Realized the genuine (irreducible, no-invariant-conic) Valentiner group over **F₁₉**
(19 ≡ 1 mod 3 and −15 = 4 = 2² is a square mod 19, so 3·A₆ ⊂ GL₃(19) is F₁₉-rational).

**Group**: `3.A₆` (order 1080), with projective image of order 360, on a faithful 3-dim module over
GF(19). Explicit generators
(integer 3×3 matrices, GAP `PerfectGroup(1080,1)` → `IrreducibleModules(-,GF(19),3)`; primitive
root Z(19)=2):

```
M1 = [[4,13,0],[11,15,0],[4,6,8]]
M2 = [[4,3,15],[5,3,18],[8,1,12]]
M3 = [[8,13,1],[1,8,10],[18,10,3]]
```

**Orbits on the 381 points of PG(2,19)** (GAP and independent galois BFS agree):
`sizes = [36, 45, 60, 60, 180]` (sum 381).

**Every orbit is loaded with collinear triples → none is an arc:**

| orbit | collinear triples |
|-------|-------------------|
| 36    | 240               |
| 45    | 660               |
| 60    | 1560              |
| 60    | 1260              |
| 180   | (large)           |

Two independent kills:
1. **Max arc in PG(2,19) = q+1 = 20.** Every Valentiner orbit has ≥ 36 > 20 points, so **no orbit
   can be an arc**, and no A₆-invariant arc exists (it would be a union of orbits, min 36).
2. Measured: even the smallest orbit (36) has 240 collinear triples.

**No invariant conic** (genuine Valentiner): a conic holds ≤ 20 points and an invariant conic is a
union of orbits (min 36) — impossible.

So the base template (config = group-orbit that is an arc) **cannot instantiate** for Valentiner.
The named A₆-invariant curve that would have been the target — the **Wiman sextic** (degree 6,
genus 10) — is moot: there is no arc to generate deep holes, and a genus-10 curve would not give
the clean genus-0 "fills the variety" count anyway.

Certificate: the 36-orbit point set (canonical reps, first nonzero coord = 1) —
`(0,1,4),(0,1,8),(0,1,17),(1,0,1),(1,0,17),(1,1,0),(1,1,1),(1,1,6),(1,1,13),(1,3,10),(1,3,18),`
`(1,4,4),(1,4,9),(1,5,5),(1,5,9),(1,5,13),(1,5,16),(1,6,6),(1,6,18),(1,7,10),(1,7,15),(1,8,16),`
`(1,8,17),(1,11,5),(1,11,14),(1,11,15),(1,11,16),(1,12,0),(1,12,4),(1,12,10),(1,13,7),(1,13,9),`
`(1,14,4),(1,14,7),(1,15,14),(1,15,16)` over F₁₉.

## Ranked disposition of remaining candidates

1. **27-lines / W(E₆) — DEAD for the arc/MDS template.** The relevant projective model is
   `Q⁻(5,2) ⊂ PG(5,2)`, not `PG(5,4)`. Its 45 contained projective lines make the 27 points non-cap.
   Keep only as a shared-object link (R-A); other generalized-quadrangle coding readings are not
   excluded by this check.
2. **Valentiner A₆ ⊂ PGL₃(19) — DEAD (ran in full).** No orbit is an arc (all ≥ 36 > 20; measured
   collinear-triple counts above). No invariant conic. Certificate above.
3. **57-cell / PSL₂(19) / PG(2,7) — DEAD (group absent).** `57 = |PG(2,7)|` is a bare numerical
   coincidence: `|PGL₃(7)| = 2⁵·3³·7³·19` has **no factor 5**, but `|PSL₂(19)| = 2²·3²·5·19` does,
   so PSL₂(19) does **not** embed in PGL₃(7) — the causal group never acts on the plane. Also 57 ≫ 8
   = max arc in PG(2,7). No compute needed beyond the arithmetic.
4. **Hesse (9₄,12₃) / order-216 over F₇ — DEAD (ran).** The 9 inflections of the Fermat cubic have
   exactly **12 collinear triples on 12 lines** (the defining Hesse configuration) → not an arc; and
   their 12 secant lines cover all of PG(2,7), so the **deep-hole locus is empty**. Same mechanism.

## What a real second instance would require (corrected search prescription)

The gem detector keys on `|config| = |space over F_q|` (a *space-filling* signature). That is the
wrong signature — it selects rich-incidence configurations, the opposite of arcs. The correct
signature is:

> a **group orbit that is an arc** (size ≤ q+1, no 3 collinear) whose **secant-complement**
> (uncovered locus) equals the full F_q-points of a **rational (genus-0) named curve** (conic / RNC).

i.e. re-key the detector to the *deep-hole side* (`|U| = |conic| = q+1`), not the config side.
Under this corrected signature the icosahedral 6-arc is the known hit in the present table, while
the tested 27-line, 57-cell, Valentiner, and Hesse proposals fail for the reasons above.

Search heuristic worth banking: this Valentiner dimension-up loses an invariant rational curve;
its named invariant is instead the high-genus Wiman sextic. A group preserving a conic acts through
a subgroup of `PGL₂` on that curve, so the previously tested A₅-prime family and twisted-cubic
routes remain the nearest comparison class. Those tests do not exhaust all isolated `P¹` examples.

**Net**: no clean second instance among these four targets. The icosahedral F₁₁ case remains the
only verified instance in this program, without a global uniqueness claim.

## Reproduction

- Generators + orbits: GAP `PerfectGroup(IsPermGroup,1080,1)`, `IrreducibleModules(G,GF(19),3)`,
  `OrbitsDomain` with `NormedRowVector(v*mat)`.
- Independent durable check of the projective group order, point orbits, every orbit's collinear
  triples, and the Hesse cover:
  `python3 notes/2026-07-14-c132-verifier.py`.
  Source SHA-256: `c2cfdc6862b580977c1308ac92adfb9fd790bf33ac9d32e3e415a89fafc757b2`.
- 57-cell: pure arithmetic (`5 ∤ |PGL₃(7)|`).
