# Cocycle / gateway explorations — autonomous session

**Lane:** `crowns` (read-only `clebsch` inputs)

**Date:** 2026-07-20

**Status:** running exploration notebook. No task allocation, no manuscript change, no novelty
claim. Findings are dated spikes with evidence levels; promote anything via the normal C-ID/lane
process. Reproduction scripts are in the session scratchpad unless a spike is saved to `notes/`.

Context: this continues the C417 affine-cocycle work
(`notes/2026-07-20-c417-affine-cocycle-line-bundle.md`) and the gateway-objects map
(`notes/2026-07-20-clebsch-gateway-objects-brainstorm.md`). The organizing idea being tested: the
C417 base-change cocycle is the rigorous form of the gateway framework's "small forgotten
decoration," it gives a cocycle-nontriviality *falsifier* and a cubic-orientation statistic `mu_3`,
and the good-reduction resonance explains the q=7,11,19 exceptional-biplane vein.

---

## Spike 1 — B3 cross-incidence is the Fano plane / Fano-complement biplane (gateway experiment #1, G15 gate 1)

**Result — CHECKED (finite, exact over F_7).** The two B3 (q=7) matching sheets (7+7
one-factorizations of `K_8`) have cross-sheet shared-edge distribution `{0: 21, 1: 28}`, and the two
relations give exactly:

```text
disjoint (share 0 edges)   -> symmetric 2-(7,3,1)  = the Fano plane           (block size 3, lambda 1)
share one edge             -> symmetric 2-(7,4,2)  = the Fano-complement biplane (block size 4, lambda 2)
```

This is the precise q=7 analogue of C379's H3 `2-(11,6,3)/2-(11,5,2)` pair, so the "exceptional
biplane sequence" is now confirmed at both q=7 and q=11 by the *same* cross-sheet construction. G15's
first exact gate (verify or reject the Fano-complement biplane) **passes**.

C417 tools on the B3 side: the base-change cocycle is nontrivial over F_7 (C417 cert → the sheet
decoration is genuinely forgotten, falsifier passes), and `mu_3` (the outer-odd cubic relative
invariant, 9 nonzero terms) exists as the cubic-orientation datum G15 wants to transport to the
Hoggar/Klein side. The remaining G15 content — whether `mu_3` equals a Hoggar twin/triple-product
sign — is untouched by this spike.

## Spike 2 — the golden/outer exchange IS the 11-cell self-duality (gateway G16 core)

**Result — CHECKED (finite, exact over F_11).** Build the C379 H3 cross-sheet incidence on the two
11-matching sheets:

```text
share one edge  -> symmetric 2-(11,6,3)   (block size 6, lambda 3)   = 11-cell vertex-facet incidence
disjoint        -> symmetric 2-(11,5,2)    (block size 5, lambda 2)   = biplane complement
```

Identify sheet A = vertices, sheet B = facets. Then **all 660 outer elements (PGL_2(11) \ PSL_2(11),
which swap the two sheets) induce a polarity (incidence-reversing self-duality) of the 2-(11,6,3)
design.** Hence:

- `Aut(11-cell design) = PSL_2(11)` (the sheet-preserving elements); the **dualities are exactly the
  outer coset = the sheet-swap = the C417 chirality bit.**
- The gateway G16 target "the golden outer exchange becomes polytope self-duality" holds at the
  incidence level: the forgotten vertex/facet decoration is the one-bit chirality cocycle.

Consistent with Leemans–Schulte (11-cell automorphism group `PSL_2(11)`, self-dual). The novel
composition is the identification of the *self-duality choice* with the C417/C379 sheet cocycle. The
deeper G16 gates (edge/face reconstruction, C403 switches as flag moves) remain open.

**Connection made:** B3→Fano and H3→11-cell are the same phenomenon — a self-dual symmetric design
whose self-duality (polarity) is realized by the outer coset = the sheet/chirality cocycle. The
"forgotten decoration" of the gateway framework is, in both cases, the vertex/point ↔ facet/line
self-duality choice, and C417 says it is one bit and genuinely non-canonical.

## Spike 3 — uniform self-duality = chirality (B3 and H3), and the one-bit reconstruction synthesis

**Result — CHECKED (exact, both fields).** For the cross-sheet vertex-facet design (Fano at q=7,
11-cell at q=11):

```text
B3 q=7 :  PSL_2(7)  all 168/168 automorphisms ; outer coset all 168/168 polarities
H3 q=11:  PSL_2(11) all 660/660 automorphisms ; outer coset all 660/660 polarities
```

So uniformly `Aut(design) = PSL_2(q)` and `dualities = outer coset`. This is the same `C2` that C413
proved is the bare scheme's entire algebraic automorphism group. Therefore **four threads are one
bit:**

```text
C413 bare Aut = C2   =   C379 golden sheet-swap   =   G16 11-cell self-duality   =   C417 chirality (outer part of the cocycle).
```

**One-bit reconstruction synthesis (REASONED from the above, CHECKED components).** The bare
(undecorated) matching scheme recovers the cross-sheet symmetric self-dual design *up to its
polarity* — equivalently the unordered pair {vertices, facets} of the self-dual 11-cell (Fano at
q=7). The polarity ambiguity is exactly **one bit** — the design is genuinely self-dual with a
nontrivial duality coset (`Aut = PSL_2(q) != PGL_2(q)`) — and fixing it (a sheet / a chirality / a
vertex-vs-facet label) canonically orders the golden parent pair (C379/C413). Hence:

> Parent recovery from the bare scheme costs exactly one bit, and that bit *is* the self-duality of
> the exceptional `PSL_2(q)` design (Fano / 11-cell). Necessary because the design is genuinely
> self-dual; sufficient because the vertex/facet labeling orders everything downstream.

This is the "use #1" reconstruction bound, now grounded in a concrete self-dual object rather than an
abstract cohomology class. It strengthens the C366/C413 reconstruction narrative: the decoration a
gauge-free decoder cannot supply is precisely one vertex/facet bit of an exceptional self-dual
geometry.

## Spike 4 — the cross-sheet designs carry the two exceptional PERFECT codes (gateway G19)

**Result — CHECKED (p-ranks exact).** Incidence-matrix ranks of the cross-sheet designs:

```text
B3 q=7  disjoint (Fano 2-(7,3,1)) :  rank_F2 = 4   -> the [7,4,3] Hamming code (perfect)
H3 q=11 disjoint (2-(11,5,2) biplane): rank_F3 = 6 -> the [11,6,5] ternary Golay code (perfect;
                                                       extends to the [12,6,6] extended Golay, Aut ~ M_12)
```

(The signed Seidel-type `+-1` version of the H3 biplane also has F_3-rank 6.) **Minimum distances
confirm the exact codes, not just dimensions:** the F_2 code of the Fano disjoint design is `[7,4,3]`
and the F_3 code of the 2-(11,5,2) biplane is `[11,6,5]`, both meeting the sphere-packing bound with
equality (perfect). So the Clebsch matching sheets, through the same cross-sheet construction, realize
**the two nontrivial exceptional perfect codes** — Hamming at q=7 and ternary Golay at q=11 — and the
C417 chirality/outer coset is their self-duality / outer symmetry.

**New structural observation — the code tower and the polytope tower diverge at q=19.** By the
classification of perfect codes, the exceptional perfect codes over small fields are exactly the
Hamming and the (binary/ternary) Golay codes; the ternary Golay at q=11 is the last one reachable by
this q-family. So the *code* endpoint is a two-term exceptional pattern (q=7, q=11), whereas the
*polytope* endpoint (Fano plane, 11-cell, 57-cell) continues to q=19 (Leemans–Schulte). The two
"operational endpoints" the gateway map seeks therefore split:

```text
q = 7      q = 11         q = 19
Hamming    ternary Golay  (no third perfect code)      <- code tower stops
Fano       11-cell        57-cell                      <- polytope tower continues
```

This is a genuine phenomenon forecast: whatever object explains the convergence must reproduce a
*perfect-code* structure exactly at q=7,11 and a *self-dual-polytope* structure at q=7,11,19, so it
cannot be a single uniform code family. A cheap falsifier for any proposed "one object" is whether it
predicts a spurious q=19 perfect code.

## Spike 5 — the one bit is constructively measurable as the sign of the cubic moment

**Result — CHECKED.** The signed cubic moment `M_3 = sum_M eps(M) D(M)^{tensor 3}` on the depth
profiles has `M_3[0,0,0] = 6 mod 11` (matching C411's independently derived value), and under the
sheet swap `eps -> -eps` every coordinate negates, so `M_3[0,0,0] -> 5 = -6`. Hence the chirality bit
is not just abstractly "one bit" — it is **read off the sign of a measurable cubic statistic:**

```text
sheet A: first cubic-moment coordinate = 6 mod 11
sheet B: first cubic-moment coordinate = 5 = -6 mod 11
```

This makes the one-bit reconstruction bound *constructive*: a decoder measures the cubic moment
(= C406's `mu_3` outer-odd relative invariant, whose sign flips under the outer coset, Spike 3), and
its value selects the sheet / vertex-facet labeling / self-duality orientation. So the gateway
framework's wish for "a measurable cubic observable that restores a forgotten choice" is realized by
`mu_3` on the Clebsch configuration, with the explicit `±6` readout at q=11.

## Spike 6 — A3/q=5 is the doily (gateway G18), the nonsplitting endpoint of the family

**Result — CHECKED.** The A3 orbit is 5 perfect matchings of `K_6` (each a *syntheme* of the 6 conic
points). They are **pairwise disjoint** (shared-edge distribution `{0: 10}`) and together cover all 15
duads exactly once — i.e. a **one-factorization of `K_6` = a Sylvester synthematic total = a spread of
the doily `GQ(2,2)`**. The acting group is `PGL_2(5) ≅ S_5`, the total-stabilizer inside the outer
`S_6` (which permutes the 6 totals). So the gateway map's G18 doily is the **A3 endpoint** — and it is
the *nonsplitting* case (A3 has one sheet, no chirality), structurally distinct from the self-dual /
perfect-code / chirality cases at B3 and H3.

This places the whole family on one axis by the parent's relation to `PSL`:

```text
A3 q=5  (parent not in PSL, NONSPLITTING):  doily GQ(2,2) / six-label synthemes / Sylvester total  [no chirality]
B3 q=7  (splitting):                         Fano plane 2-(7,3,1) / [7,4,3] Hamming perfect code    [chirality]
H3 q=11 (splitting):                         11-cell 2-(11,6,3) / [11,6,5] ternary Golay perfect     [chirality]
```

So the "six labels / doily" and the "self-dual design + perfect code + chirality" are the two faces of
the same construction, separated exactly by whether the Coxeter parent lies in `PSL_2(q)` (C406's
nonsplitting criterion). The chirality bit exists precisely in the splitting cases.

Because A3/B3/H3 are the *complete* list of irreducible rank-3 finite Coxeter groups, this is a
finished small statement, not a fragment of a tower: **each irreducible rank-3 Coxeter conic marker,
at its conic phase `q = h_cox + 1`, realizes an exceptional self-dual geometry (doily / Fano /
11-cell) whose classical code is a perfect code (—/Hamming/ternary Golay), with a chirality bit
present exactly when the parent leaves `PSL_2(q)`.** The rank-4 continuation (`H_4`/q=31, 57-cell at
q=19) is the genuine open frontier.

## Synthesis — one narrative across C406–C417 and the gateway map

The spikes above collapse a large part of the branch into a single picture:

```text
Clebsch matching sheets (C406/C379)
   --cross-sheet incidence-->  self-dual exceptional design       (Fano @7, 11-cell @11)  [Spikes 1,2]
   --disjoint-relation code-->  exceptional perfect code          ([7,4] Hamming, [11,6] ternary Golay) [Spike 4]
   --forgotten decoration-->    the self-duality / polarity        = one bit                [Spikes 2,3]
   --that bit is-->             the C417 chirality cocycle         = C413 bare Aut C2 = C379 golden swap [Spike 3]
   --measured by-->             sign of the cubic moment mu_3      = ±6 mod 11               [Spike 5]
```

Two operational endpoints the gateway map sought are realized (self-dual polytope; perfect code), the
"small forgotten decoration" is pinned to one chirality bit, and that bit is both *cohomological*
(the C417 cocycle) and *measurable* (the cubic moment). This is the composition the lane cares about;
each classical ingredient (biplane, self-dual polytope, perfect code, relative invariant) is credited.

**Phenomenon forecasts (leads, not claims).**
1. The *code tower stops at q=11* (no third perfect code) while the *polytope tower continues to
   q=19* (57-cell). Any single "convergence object" must reproduce both, so it is not a uniform code
   family; a spurious q=19 perfect code falsifies it.
2. The rank-3 cases (A3/B3/H3) are the ternary-conic floor; the rank-4 golden case **H4 / q=31**
   (600-cell, quadric in P^3) is the predicted next gateway with its own cocycle + cubic bit — the
   biggest open probe, requiring quaternary-quadric reconstruction the current C406 machinery lacks.
3. `mu_3`'s sign being the chirality connects to the ternary-Golay / M_12 completion (G19): the
   sheet-swap should be a specific outer element in `2.M_12 = Aut([12,6,6])`; identifying it would
   give the Clebsch chirality an M_12 meaning.

**Refinement of forecast 3 — the chirality is NOT the Golay/M_12 symmetry (REASONED, classical group
theory).** The code's permutation-automorphism group is `M_11` (perm part of `2.M_11`), which
contains `PSL_2(11)` as a **maximal** subgroup (index 12; the classical `M_11` maximal-subgroup list
is `M_10, PSL_2(11), 3^2:Q8.2, S5, GL_2(3)`). The Clebsch chirality lives in the *other* overgroup of
`PSL_2(11)`, namely `PGL_2(11)` (index 2). Since `PSL_2(11)` is maximal in `M_11` and
`PGL_2(11) != M_11`, we have `PGL_2(11) not-subset M_11`, so the chirality/outer element is **not**
a Golay code automorphism. Hence the design self-duality (chirality) and the `M_11/M_12` Golay
symmetry are two *distinct* enlargements of the shared `PSL_2(11)`. The Clebsch sheets supply the
code (via `PSL_2(11) < M_11`), but the chirality is a separate involution, not the sporadic
extension. This sharpens G19: the sheets give the Golay geometry, but the "canonical sign/generator"
they supply is the `PGL` self-duality, orthogonal to the `M_12` structure.

## Reproducibility (Spikes 1–4)

```bash
python3 notes/2026-07-20-cocycle-gateway-explorations.py
```

reconstructs the B3/H3 sheets from the SHA-pinned C406 module and prints every count above (A3 is
the one-sheet nonsplitting control). Exploratory script; trusted boundary is exact `F_q` arithmetic
plus the frozen C406 secant/matching geometry. The classical identifications (Fano/Hamming, 11-cell,
2-(11,5,2)/ternary Golay, self-dual `L_2(q)` polytopes) are cited, not re-derived.
