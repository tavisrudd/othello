# C132 — Second-instance spike: is there another "deep-hole locus = F_q-points of a named variety"?

**Date**: 2026-07-14
**Verdict**: **NO clean second instance found in this pass.** All fill-signature candidates
(27-lines/W(E₆), Valentiner A₆, 57-cell/PSL₂(19), Hesse) die, and they die by **one shared
structural mechanism**. The negative is well-argued and certificate-grade; the mechanism also
diagnoses a blind spot in the gem detector and prescribes the correct signature for a real
second instance.

Template being replicated (icosahedral F₁₁ case, SOLVED): a small **arc** config `A` (6 axis-poles,
a genuine 6-arc) in `PG(2,11)`, whose **deep-hole locus** `U` = points off `A` and off all 15
secants = the **full 12 F₁₁-points of the A₅-invariant conic** (= P¹), with group cause A₅.

## The one mechanism that kills every candidate

The template needs the config to be an **arc / cap** (NO 3 collinear) and the *exceptional named
variety to sit on the DEEP-HOLE side* (the uncovered locus), while the config is a plain arc.

Every "gem-detector" fill-signature candidate is the opposite: it is an exceptional
**configuration** — a point/line incidence geometry defined *by* rich collinearity — so its point
set (or every group orbit) carries many collinear triples and is **never an arc**. And
"size = |space|" (the signature the detector keys on) marks a **space-filling** object with **no
complement**, i.e. no external deep-hole locus at all. Both properties are exactly wrong for the
template.

The icosahedral case is rare precisely because it **decouples**: the exceptional structure
(icosahedron = 12 conic points) is the deep-hole locus, and the config (6 poles) is a separate,
genuine 6-arc. None of the candidates reproduce that decoupling.

## Framing verdict for 27-lines / W(E₆) (the ½-value task)

**A covering/deep-hole reading does NOT exist. Decisive.**

- The 27 lines' intrinsic linear-dependency (secant) structure is the **generalized quadrangle
  GQ(2,4)**: the 45 tritangent-plane triples are exactly the "collinear triples," and the 27
  objects are *precisely* the 27 points of GQ(2,4) (Schläfli graph = complement). A config that
  *fills its own incidence geometry* has **no external/uncovered locus** — the template needs
  `config ⊊ ambient PG(n,q)` with named uncovered points; here there is nothing external.
- The only rescue — realize the 27 lines as 27 points via the minuscule 27-rep of E₆, a subset of
  `PG(5,q)` — **fails the arc requirement**: those 27 points carry the 45 tritangent triples as
  genuine linear dependencies (three mutually-incident lines are coplanar / sum to a fixed weight),
  so they are **not a cap**. With 45 collinear triples there is no MDS/covering-radius reading, and
  the leftover of `PG(5,4)` off the 351 secants is a generic large remainder, not an orbit-closed
  named variety.
- Consequence: 27-lines/W(E₆) stays a **shared object** with the icosahedral case (via
  Brianchon=Eckardt → W(E₆), the R-A link) but is **not a second covering-instance**.

## Candidate ran in full: Valentiner A₆ ⊂ PGL₃ (fallback b) — DEAD, certificate-grade

Realized the genuine (irreducible, no-invariant-conic) Valentiner group over **F₁₉**
(19 ≡ 1 mod 3 and −15 = 4 = 2² is a square mod 19, so 3·A₆ ⊂ GL₃(19) is F₁₉-rational).

**Group**: `3.A₆` (order 1080), faithful 3-dim module over GF(19). Explicit generators
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

1. **27-lines / W(E₆) over F₄ — DEAD (no covering reading).** Config = GQ(2,4), fills its own
   incidence geometry; the PG(5,4) cap rescue fails (45 tritangent triples ⇒ not a cap). Structural,
   decisive. Keep only as a shared-object link (R-A).
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
Under this correct signature the icosahedral 6-arc is exactly the hit (detector rows 1–2), while all
the "config fills space" rows (9 = 27-lines, 16 = 57-cell, 19 = Hesse) are categorically different
and confirmed dead here.

Structural tension worth banking: a genuine *dimension-up* to a bigger exceptional group
(Valentiner, no invariant conic) **loses the invariant rational curve**, hence loses the clean
"fills the variety" count — its only named invariant is a high-genus curve (Wiman sextic). Groups
that *do* fix a conic/RNC (genus 0) are subgroups of PGL₂ acting on that curve, i.e. the **same P¹
lane** as the base case, not a new phenomenon. The parent program already exhausted that lane: the
A₅-prime family (C126, dead except p=11) and the k-tower / twisted-cubic dual-variety (C123, dead).

**Net**: no clean second instance in this pass; the icosahedral F₁₁ case remains singular, and the
reasons are now diagnosed structurally rather than by exhaustion.

## Reproduction

- Generators + orbits: GAP `PerfectGroup(IsPermGroup,1080,1)`, `IrreducibleModules(G,GF(19),3)`,
  `OrbitsDomain` with `NormedRowVector(v*mat)`.
- Geometry (arcs, secants, deep holes, form-fitting): `uv run --with numpy --with galois`; scripts
  `geom.py`, `valchar.py`, `hesse.py` (scratchpad, ephemeral — regenerate from the generators above).
- 57-cell: pure arithmetic (`5 ∤ |PGL₃(7)|`).
