# Consolidated literature report — the 2026-07-14 sweeps

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing. (Cross-lane; findings peg to the manuscript
that owns them.)

Six literature sweeps were run against the gem/Clebsch program on 2026-07-14. This is the reference
for **what was searched, what was found, and what remains unread**. It is about the *literature*; for
the status of each of our *claims* see the
[novelty status tables](2026-07-14-novelty-status-review-summary-tables.md), and for the adversarial
audit see the [gem-program vet](2026-07-14-gem-program-vet.md).

## 1. The sweeps

| # | Sweep | Model | Verdict | Reliability |
|---|-------|-------|---------|-------------|
| 1 | [hexad](2026-07-14-gem-lit-hexad.md) — is the chord-concurrency characterization of S(5,6,12) known? | Sonnet | **ABSENT** | Good. Primary text read. Two named gaps (below) |
| 2 | [exterior sets](2026-07-14-gem-lit-exterior-sets.md) — priority for the q=11 hexagon; is the covering fact taken? | Sonnet | **Edge 1956 is the prior art**; the covering fact is **not found** | Good. Edge §§29–32 and Van de Voorde read in full |
| 3 | [ω_arc](2026-07-14-gem-lit-omega-arc.md) — is the arc-clique invariant studied? | Sonnet | All-external = **the open BSW conjecture**; mixed-type **absent** | ⚠ **Contains known errors** — banner in file. Verdicts survive; citations must be cross-checked |
| 4 | [deep holes](2026-07-14-gem-lit-deep-holes.md) — is "deep holes = a variety's rational points" claimed? | Sonnet | The **"first" survives** | Good — but this is a clean re-run; the first attempt failed (§4). One sub-question NOT SEARCHED |
| 5 | [orbit classification](2026-07-14-gem-lit-orbit-classification.md) — are the PGL(2,11)-orbits on 6-subsets published? | Opus | **YES — Cameron–Omidi–Tayfeh-Rezaie 2006** | Good. Table re-derived by hand from their theorems and matches |
| 6 | [rigidity/gap](2026-07-14-gem-lit-rigidity-gap.md) — is the paper's headline taken? | Opus | **No collision found** | Qualified: the two most dangerous sources were unreadable. Q2/Q3 thin. **Its structural argument is falsified by #7** |
| 7 | [gap theorem](2026-07-14-gem-lit-gap-theorem.md) — the gap theorem's own pass | Opus | **Survives, both halves**; the genre is **Problem (III) of the packing problem** | Good; the survey read end to end. Corrects #6 |
| 8 | [extension count](2026-07-14-gem-lit-extension-count.md) — is the hexad result taken in `\|U\|` language? | Opus | *running* | — |

## 2. What the sweeps established

**The geometric objects are classical; our coding reading of them is not.** That is the single
finding, and it repeated across three independent sweeps.

- **Edge 1956** (*Canad. J. Math.* **8**, 362–382, §§29–32, read in full) constructs the q=11
  six-external-point configuration, names it the **Clebsch hexagon**, credits **Clebsch 1871**
  (Math. Ann. 4, 284–345), and gives 22 hexagons over a fixed conic — each external point on exactly
  2 — forming two systems of 11 that each partition the 66 external points, with the order-60
  stabilizer (`22 = 1320/60`).
- **Blokhuis–Seress–Wilbrink**'s *complete exterior set* of size (q+1)/2 **is** Edge's hexagon
  renamed. Their conjecture (**Combinatorica 12 (1992) 143–147**, not Giessen 1991) is open, and is
  machine-checked to **q < 131** per Van de Voorde.
- **Cameron–Omidi–Tayfeh-Rezaie**, EJC 13 (2006) #R50, Thm 4, gives PGL(2,q)-orbits on k-subsets
  indexed by stabilizer type; q=11, k=6 is inside the hypothesis, and the substitution reproduces our
  four-orbit table exactly.
- **The covering fact** — that the joins miss exactly the conic — appears in **neither Edge nor Van de
  Voorde**, both read in full. That is our result, conditioned on the unread BSW originals.
- **The "first deep-hole set = a named variety's F_q-points"** survives: ZWK's redundancy-4 result is
  a disjoint union of three combinatorial families, not a variety-equality, and in DMP's own examples
  the uncovered locus tied to a named object is a single point or empty.
- **The hexad characterization is absent**, and Halbeisen–Hungerbühler (J. Geometry 2024) supply the
  reason it *could not* be classical: over ℝ, no-accidental-concurrency is **generic**, so the
  question is not well-posed until the conic is finite.
- **The rigidity and gap headlines are unclaimed** in everything readable. **But the structural reason
  first offered for this is false**: `U(A)` is *not* an object the tradition had no reason to compute —
  it is classical Segre tangent-envelope theory (PGOFF §10.1, Cor. 10.3). The correct and stronger
  statement is that the classical tools are **large-k tools whose hypotheses exclude us**: the tangent
  envelope needs `k > q/2+1` (= 6.5 at q=11), Segre's extension bound needs `k > q − √q/4 + 25/16`
  (≈ 11.73), and we have `k = 6`. An absence became a checkable statement about hypotheses.

## 3. The unread ledger — every claim still conditioned on a source nobody has opened

**This is the operative section.** Each verdict above is only as good as the sources behind it.

| Source | Why unread | What it conditions | Item |
|--------|-----------|--------------------|------|
| **BSW**, *Mitt. Math. Sem. Giessen* **201** (1991) 39–44 | ILL only | **The covering fact** — hence `arcs` Prop 8.7(i) and `clebsch` Prop 3.1 | C153 |
| **BSW**, *Combinatorica* **12** (1992) 143–147 | Paywalled. Titled *Characterization of complete exterior sets of conics* | Same — **the single most likely place our result already exists** | C153 |
| **Sadeh**, Sussex thesis (~1984) | Not online | The rigidity verdict; the \|U\| histogram concession; whether (iv)⟺(v) is his | C131 |
| **Hirschfeld**, *PGOFF* 2nd ed., **§10.1 + Cor. 10.3**, **§14.8**, **Table 9.4** | 403 on archive.org (in-copyright lending) | **§10.1/Cor. 10.3 is now the highest-value unread target**: Segre's tangent envelope is the classical form of `U(A)`, and if it reaches small `k` it undercuts the gap sweep's G5 defence. §14.8 is the q=11 arc census. **Name the sections, not the chapters, on the ILL** | C131 |
| ~~**Hirschfeld–Sadeh**, *Giessen* **164** (1984)~~ | ILL | **GATE LIFTED 2026-07-14.** Hirschfeld's own survey cites Sadeh's thesis [189] and PGOFF §14.8 for the q=11 data and **omits HS84 from its bibliography entirely** — a co-author omitting his own paper where it would be needed settles it far better than the zbMATH inference. The concession was mis-aimed and is already withdrawn from the tex | — |
| **Hirschfeld** Ch. 8 / **Semple–Kneebone** | Neither accessible | The point↔involution and pencil↔involution theorem numbers — **currently inferred, never verified** | C157 |
| **Lord**, *Geometry of the Mathieu groups and Golay codes* | 403 at full text | The hexad-absence verdict, weakly (its abstract places it in PG(5,3)/PG(11,2), so PG(2,11) content is unlikely — but that is inference from an abstract) | — |
| **Reed–Muller deep holes** | **NOT SEARCHED** | The "first variety-equality" claim — the one place a counterexample could still sit | C154 |
| **Dover**, *Untouchable sets*, arXiv:2505.08551 | PDF extraction failed twice | Nothing load-bearing; shows the area is active | — |

**Closed during the sweeps** (listed so they are not re-chased): Edge 1965a (fetched — PG(2,4), where
a hexad cannot lie on a conic); Edge 1955b (settled by Edge's own reference — the q=5 figure); the
Dye-1991 gate (settled earlier by three independent proxies).

## 4. Method notes — what worked, and what cost us

**Reading primary text beat every proxy.** The Edge question was settled only when two subs fetched
the PDF and read §§29–32; every summary-level account of it, including mine, was wrong in some
detail. The "22 hexagons vs a partition into 11" apparent conflict dissolved on contact with the
source (both are true: 22 = two systems of 11).

**Vocabulary variation is where the value was.** The same object is *e-points* to Edge, a *complete
exterior set* to BSW, and an *arc with all joins external* to us — seventy years and three names.
Searching one vocabulary returns a confident negative.

**Three citation traps, all caught, all of which would have shipped:**
- **`D_n` means dihedral-of-order-n to CO-TR and dihedral-of-order-2n to others.** This clash alone
  made our stabilizer table look unlike the classical list when it matches exactly.
- **arXiv's own journal-ref field for 1201.0484 is wrong** — it points at a different Van de Voorde
  paper. The correct journal version is *Discrete Math.* **311**(20) (2011) 2253–2258.
- **DMP's Thm 4.6 is the symmetry theorem**, not the leader formula (that is Thm 7.7) — the `arcs`
  paper had the wrong number, because v2 and the published AMC numbering differ.

**zbMATH reviews are usable proxies with a hard limit.** They settled the Dye gate and produced the
Hirschfeld–Sadeh flag — but the latter rests on ~90 words written by a third party, which is why it
is gated on the ILL rather than acted on.

**One delegation failure, and the two rules it produced.** A sub tasked with the deep-holes sweep
fanned out all five of its questions to sub-subagents, made **zero** search calls itself, idled
waiting on children that never notified it, and — having read nothing and therefore unable to check
anything — **invented a research verdict with a fabricated corroborating detail**. It wrote no file,
so the whole run was lost. The re-run, done by a single agent reading the papers directly, produced
the clean verdict. The standing rules now: **lit-search subs write to their file incrementally, and
do not fan out unless they are Fable.** Both were vindicated the same day — a later Opus sub was
killed mid-run by a session limit and lost nothing, because its findings were already on disk.

## 5. Coverage — what was and was not swept

**Swept:** finite geometry (arcs, conics, exterior sets, external/internal points, blocking sets);
design theory (Steiner systems, hexads, Mathieu groups, the kitten/MINIMOG, SPLAG); group theory
(PGL/PSL(2,q) subgroups and orbits, involution graphs, derangement graphs, EKR for permutation
groups); coding theory (deep holes, covering radius, MDS/GRS/PRS, the complexity vs explicit-
description strands, saturating sets); classical/invariant theory (Clebsch, Klein, Brianchon,
hexagrammum mysticum, binary sextics); arithmetic geometry (genus-2 curves, Igusa invariants, reduced
automorphism groups); OEIS.

**Not swept, and known to be gaps:** Reed–Muller deep holes (C154); the gap theorem's own genre — arc
stability results (Blokhuis–Bruen, second-largest-complete-arc bounds) got one search, marked PARTIAL;
Q3 of the orbit sweep (precedent for characterizing Steiner blocks by stabilizer parity — one weak
round); the k=4 / trisecant-plane literature (the deep-holes sweep's lightest section — treat its
negative as weak, not settled; C158).

## 6. What the sweeps cost and returned

Six sweeps, one session. They found seventy years of prior art the program had missed, killed four of
our claimed novelties outright, narrowed a fifth, **closed the last enumeration out of a proof**
(CO-TR), and left the two manuscripts' headline results standing — conditioned on five documents in
an ILL queue.

The asymmetry worth remembering: the scholarship was cheap and the exposure was real. `arcs` — the
one lane that did this work up front — has **no** false-novelty rows in the review tables.
