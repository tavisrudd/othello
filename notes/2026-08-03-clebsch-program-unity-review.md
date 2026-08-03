# Clebsch program unity review

**Date:** 2026-08-03
**Lane:** `clebsch` (program-level; advisory, no manuscript edit)
**Author:** session review (Fable main agent), from the same-day fresh reads
of Papers I, II, III, the Paper IV and golden lane context, and the C855
proof results. Brief by design.

## What actually unifies the program

The series has a stated unity — the epigraph's arc (takes shape, finds its
bearings, stands fixed while its shadows move) — and a real mathematical
one: a single golden orientation torsor on six axes, with operator identity
`B² = 5I` and triangle-holonomy cubic, examined through forgetful passages.
Paper I recovers it from nearest-codeword data at eleven; Paper II recovers
it from the conic quotient of the icosahedral matching; Paper III descends
its sign from characteristic-zero arithmetic and realizes it operatorially;
Paper IV reconstructs the ambient plane at thirteen from the binary shadow.
The common genre across all four is recognition: small data determine the
golden structure. Three registers recur everywhere — golden-integer
arithmetic (`Z[φ]`, conductor two), icosahedral representation theory, and
finite incidence geometry — and the shared Lean base (now cap-free after
C860 stage 1) gives the program artifact-level unity no comparable series
has.

## The unity gaps, ranked

**U1 — the three cubics are identified nowhere.** The support cubic of
Paper I, the sheet-sign cubic of Paper II's icosahedral case, and Paper
III's marked triangle cubic are the same object, but that identification is
series folklore: no manuscript states and proves the three-way equality
under explicit markings. The formal tree even names the concept — a
torsor-Rosetta gate exists — so pieces are likely already kernel-checked.
One short Rosetta statement (a section of the golden paper, or a small
series note) proving the three constructions yield one torsor is the
single highest-value program-level move. It converts "a tetralogy about
related objects" into "one object's biography," which is the marketing the
epigraph already promises.

**U2 — register convergence is routed but unfinished.** Papers I and II are
uniform-theorem papers; IV is a single-field reconstruction; III is a
suite. The C815/C823 recognition route brings III into the shared genre,
and the same-day framing reviews for II and III both recommend
recognition-first re-centering. Once those integration passes land, the
four papers read as four instances of one theorem shape.

**U3 — formal-standard asymmetry.** The theorem-complete bar currently
binds Paper I (C855) and Paper IV (C834/C857); Paper II sits at structural
closure and Paper III at partial. The endpoint worth naming as a goal: one
uniform theorem-complete standard across the numbered series, which would
support a program-level claim (a fully kernel-checked paper series in a
field with no prior formalization) that none of the papers can make alone.
C861's plan review is the natural place to cost this for II and III.

**U4 — the unnumbered companions lack stable locators.** The computational
companion and the golden quantum-statistics companion are cited from the
numbered papers but cannot be firmly cited until the golden paper and the
companion have public locators; the citation graph of the series is
incomplete until then. Existing rule (cite only after a stable locator)
is right; the gap just argues for sequencing the golden release before the
next numbered forward versions.

## Program-level recommendation

Adopt U1 as an explicit deliverable owned by the golden lane (it owns the
operator corpus and may cite all numbered papers), sequenced after C855's
manuscript pass so the Rosetta statement can cite Paper I's self-contained
Dye package. U2 and U3 are already carried by routed tasks (C816/C824,
C577, C834/C857, C861); no new allocation needed. U4 is a sequencing
preference, not a task.

## Rosetta hosting and the series map

**Decision input (session discussion, 2026-08-03):** the Rosetta theorem is
hosted by the golden lane's standalone operator paper — *Golden conference
operator and its shadow sisters*, the paper the 2026-07-31 ownership
decision assigned the C704--C710 corpus to. That manuscript is not yet
live; the lane's only live manuscript, the quantum-statistics
interferometer companion, is the wrong host (physics register and
audience). If the operator paper stays unstarted when the Rosetta is
wanted, the fallback is a short standalone series note in the golden lane,
not the quantum companion. The operator paper owns the corpus the proof
draws on,
sits outside the numbered series so it may cite all four papers freely, and
is not constrained by released-version immutability; the torsor-Rosetta Lean
gate is its formal anchor. Paper III is the runner-up but may not absorb the
golden corpus under the lane boundary, and Papers I/II each own only one
vertex of the identification.

**Repeated diagram:** each numbered paper's forward version carries one
standardized series map with its own node emphasized ("you are here") and a
caption asserting only what that paper proves or can cite. Until the golden
paper has a stable public locator, captions point at the identifications,
not at the unproved Rosetta theorem. The figure lands only through the
already-scheduled passes (C855 window for I, C577 for II, C816/C824 for
III, C761 packaging for IV): no extra release churn.

ASCII master of the series map (TikZ versions derive from this):

```
                     Paper III  (passages)
             arithmetic source:  z^2 = 5*J0
        operator shadows: Pf / det / wedge^3 / polar
                            |
                    descends the sign
                            |
                            v
 Paper I  <-----------  GOLDEN TORSOR  ----------->  Paper II
 deep-hole syndrome     B^2 = 5*I                conic quotient of
 and decoder data       c_ijk = B_ij B_jk B_ki   the icosahedral
 at q = 11 recover      one oriented cubic Z     matching recovers
 B and the support         |            |        sheets and the
 cubic                     |            |        sheet-sign cubic
                           |            |
              binary shadow|            |harmonic / quantum
                           v            v        return
                      Paper IV      Golden paper
                reconstructs        hosts the Rosetta
                PG(2,13) from       theorem: support,
                the minimum-word    sheet-sign, and marked
                layer               cubics are one torsor
```

Left and right edges are recognition passages (outward forgetting, inward
recovery proved by the named paper); the top edge supplies the sign from
characteristic zero; the bottom edges are the two returns. The Rosetta
theorem asserts that the three cubic vertices name one object under the
explicit markings.

No manuscript was edited; advisory input to the golden lane, C861, and the
series' next forward versions.
