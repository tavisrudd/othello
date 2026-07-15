# C193 — BSW 1992 read: the exceptional census, and what it opens for this lane

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-07-15
**Status**: **REPORTED — the six-sweep ILL gate is OPEN.** BSW 1992 obtained and read at full text
from page scans. Quotations below are transcribed by eye from the scans and are **L4**; verify any
before manuscript use. Reasoning is a mining session's and is provisional until the user's vet.

Source: **A. Blokhuis, Á. Seress, H. A. Wilbrink, "Characterization of complete exterior sets of
conics", Combinatorica 12 (2) (1992) 143–147**, received July 11 1989. Scans at
`/tmp/persistent/tavis/lit-search/bsw-1992/bsw-14{3,4,5,6,7}.png`.

**Scope.** This report covers only what BSW means for **this lane**. The covering fact is owned by
`relconic`/`clebsch`, and another agent owns the manuscript's citations and priority — nothing here
routes there.

## The exceptional census — BSW §3, verbatim

The lane has been treating the exceptional complete exterior sets as its own territory. **They are a
published, complete, computer-verified classification.** BSW §3:

> For q ≡ 3 (mod 4) it turns out that there are some examples of complete exterior sets that do not
> consist of all exterior points of a passant, at least for small q. Two of those (the 4-arc in
> PG(2,7) and the 6-arc in PG(2,11)) were already found by G. Korchmáros [5] because of a relation of
> these structures with chains of circles on an elliptic quadratic and translation planes, motivated
> by work of Bruen [2]. By computer search we found all such sets for q = 7, 11, 19, 23, 27, 31. It
> turns out that there are not that many. **Andries Brouwer** found that up to isomorphism there are
> the following possibilities:

| q  | The configuration(s), as BSW describe them                                                        |
|----|----------------------------------------------------------------------------------------------------|
| 7  | one configuration, 4 points, no 3 collinear (**the 4-arc**)                                        |
| 11 | **two**: one a **6-arc**, the other a **Pasch-configuration**                                      |
| 19 | a Pasch-configuration, with 4 additional points on one of the 2-secants                            |
| 23 | **two**: two Pasch-configurations joined by three transversals (each 2-secant of one is a 2-secant of the other); *or* 6 lines having four points, such that at each of the 12 points 2 of the 4-lines meet |
| 27 | 3 Pasch-configurations on two points, with one further two-secant in common                        |
| 31 | **6 points forming an arc, and 10 points forming a Petersen graph** — every 2-secant of the 6-arc is also a 2-secant of the 10-set, and the 15 pairs thus obtained yield the structure of a Petersen graph |

> Andries Brouwer showed, again by computer search that no other examples exist for q = 43, …, 131,
> so we conjecture that for q > 31 there are no other complete exterior sets then the linear ones.
> **How to prove this we have no idea.**

## Five things this settles or changes for this lane

1. **The q=11 6-arc is Korchmáros 1981, not BSW and not ours.** *G. Korchmáros, "Example of a chain of
   circles on an Elliptic Quadric of PG(3,q), q = 7, 11", J. Comb. Theory A **31** (1981), 98–100.*
   The q=7 4-arc and the q=11 6-arc were found there, via **chains of circles on an elliptic quadric
   and translation planes**, motivated by Bruen's inversive geometry [2]. This is a **third**
   independent prior name for the Clebsch hexagon, after Edge 1956 and BSW's "complete exterior set" —
   and it arrives from a different direction again (PG(3,q), not PG(2,q)). **Korchmáros 1981 is not in
   the lane's literature record and should be obtained.**

2. **There is a second exceptional configuration at q=11 and this lane has never seen it.** BSW list
   **two** at q=11: the 6-arc *and* a **Pasch-configuration**. The healthy census only sees arcs, and
   a Pasch configuration has collinear points by construction, so the lane's ω_arc machinery is blind
   to it **by design**. The claim "healthy arcs exist exactly at q ∈ {3,5,11}" is untouched; the claim
   that the lane knows the q=11 exceptional landscape is not.

3. **The q<131 check is Brouwer's, inside BSW 1992 — not Van de Voorde's.** The handoff reports "Van
   de Voorde reports the conjecture machine-checked for q < 131". BSW §3 says Brouwer did q = 43,…,131
   *in this paper*, three years before Van de Voorde was writing. Van de Voorde is presumably
   reporting it. The lane's operative conclusion — **the census recomputes inside an already-checked
   range** — is unchanged and now rests on the primary source rather than a secondary report.

4. **Giessen 1991 is confirmed as the other paper, and it is not the conjecture.** BSW's ref [1] is
   *A. Blokhuis, Á. Seress, H.A. Wilbrink, "On sets of points without tangents", Mitt. Math. Sem.
   Giessen **201** (1991), 39–44.* The handoff's correction — "the conjecture is **Combinatorica
   1992**, not Giessen 1991" — is **confirmed from the primary source**. Giessen 1991 remains unread;
   it is the sets-without-tangents paper, and it is now the lane's only unread BSW original.

5. **BSW's own starting problem is a coding link the lane has not used.** BSW §1: their motivation is
   *the minimal cardinality of a set of points in PG(2,q) without tangents*, and at q=11 their example
   is **"18 = 12 + 6 points consisting of the 12 points of a conic together with a set of 6 exterior
   points"** — the conic plus a Clebsch hexagon. **Sets without tangents is precisely Van de Voorde's
   LDPC stopping-set link**, the one existing coding connection to this object [in-repo, handoff §
   Literature]. So the hexagon already sits inside a configuration whose far side is coding, by the
   lane's own record, and nobody has pulled the thread.

## The Petersen echo — the strongest lead here

BSW's **q=31** configuration: a 6-arc plus a 10-set, where the 6-arc's **15 2-secants** meet the
10-set in **15 pairs forming a Petersen graph**.

This lane owns a **Brianchon–Petersen dictionary at q=11**
(`notes/2026-07-15-c176-brianchon-petersen-dictionary.md`, `clebsch`-pegged), and the numerology is
the same shape: a 6-arc has **15 joins**; the Petersen graph has **10 vertices and 15 edges**; the
Clebsch hexagon has **10 Brianchon points**.

**Stated as a question, not a claim**: is BSW's q=31 Petersen the same structure as the lane's q=11
Brianchon–Petersen, or a coincidence of 10s and 15s? The lane has a recorded failure of exactly this
shape — *"759 subsets at max t looks like a second Steiner system → numerology"* — so this is a lead
with an obvious null (**the 15-edge/10-vertex match is forced by any 6-arc and carries no content**),
and it is cheap to settle: both configurations are small and computable.

**Do not promote this before the null is refuted.** If it survives, the interesting fact is that the
structure appears at **q=31**, where there is *no* 6-arc complete exterior set of the q=11 kind —
which would make it a deformation across the exceptional family rather than a q=11 accident, and the
mechanism-deformation predicate is the one C177 is predicted to fail.

## Cells this opens

BSW's exceptional list satisfies rule 1 (**census, not a curated list**): Brouwer's search is
exhaustive up to isomorphism for q = 7, 11, 19, 23, 27, 31, with nothing further to q=131. That is
the exhaustion guarantee the generator needs, and it is published rather than ours to produce.

- **The exceptional configurations, transported to coding.** Six named small configurations, complete
  up to isomorphism. The far side is already attached (sets without tangents → stopping sets). **Run
  the factoring check first**: the q=7 and q=11 members are Korchmáros's chains of circles, so the
  geometry is spoken for and only the coding reading is candidate territory.
- **The Pasch members.** Pasch configurations dominate the list (q=11, 19, 23, 27). The lane has never
  looked at them because they are not arcs. A Pasch configuration is a named object in design theory
  and matroid theory.
- **BSW's open problem, stated by the authors**: *"How to prove this we have no idea."* An explicitly
  open problem from the primary source, and the lane's E_q reduction is a framing of the same
  question. Note the handoff's standing verdict — **the census contributes nothing to the conjecture,
  decided not open** — which this does not overturn: recomputing inside q<131 is still worthless. What
  BSW's remark licenses is work on a *proof*, which is a different activity from a wider search.

## What I have not done

- **Pages 144–145 unread** — the theorem's proof for q ≡ 1 (mod 4). Read them before any claim about
  BSW's method.
- **Korchmáros 1981 not obtained.** It is the true first appearance of the q=7 and q=11 configurations
  and is absent from the lane's record.
- **Giessen 1991 not obtained.** Still the lane's only unread BSW original.
- **The Petersen echo not computed.** No comparison of BSW's q=31 structure with the lane's q=11
  Brianchon–Petersen has been attempted; the null is not refuted.
- The scans are not in the cache manifest — `litcache.py` requires a PDF and cannot hold page scans.
