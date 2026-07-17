# Missed A+ connections for rp-next / C239 (Fable 5, clean pass)

**Lane:** `rp-next` (external review; allocates no task, reopens no gate, changes no gate)

**Date:** 2026-07-17

**Reviewer model:** Claude Fable 5

**Reviewed:** the `rp-next` handoff, the [C239 domain-translation audit](2026-07-17-c239-domain-translation-audit.md),
the [open-doors brainstorm](2026-07-16-repairports-applications-open-doors-brainstorm.md) (items 1–28),
the [brainstorm response](2026-07-16-repairports-applications-brainstorm-response.md) (R1–R11), and the
[`rp-next` discovery track](2026-07-16-rp-next-discovery-track.md). Deliberately not read: the C239 and
C238 scratchpads, the `fable-do-NOT-read` branch file, the riffing archives.

**Relationship to the earlier draft.** A companion file
[`2026-07-17-fable5-rp-next-fresh-connections-review.md`](2026-07-17-fable5-rp-next-fresh-connections-review.md)
covers similar ground; it was drafted under a triggered-safeguard state and carries two technical
errors (flagged in §7 below). This report is the clean pass. Where it overlaps that draft or the two
brainstorms, it gives short xrefs and spends its tokens on connections neither found.

## 0. The organizing thesis (sharper than "search combinatorics not applications")

The prior brainstorms mine applications; the earlier draft's correction was "search combinatorics and
complexity, not systems." Both are right but understate the actual asset. The real A+ observation is
structural, not a matter of neighborhood:

> The cubic and harmonic port families are a **single explicit, highly symmetric, field-sensitive
> matroid family that simultaneously realizes the hard / boundary instance of several independent
> classification theorems** — because the one ingredient every one of those theorems needs on its hard
> side is *characteristic-sensitive coefficient geometry sitting over a rigid symmetric support*, which
> is exactly what C217/C218/C237/R6/R11 manufacture.

That is a stronger publishing move than any single "home." It says: package the family not as an
application of one theory but as a **gadget library / benchmark** whose members are the extremal witness
for a list of dichotomies at once. The list already visible in the material:

| Dichotomy / theorem | Its hard/boundary side | The family's witness |
|---|---|---|
| MSP field-sensitivity (Robere–Pitassi–Rossman–Cook; Pitassi–Robere) | small program only over fields with cube roots of unity | R6 AG(2,3) exclusion; R11 anharmonic collapse |
| matroid representability (Hesse / AG(2,3)) | representable iff char 3 or `omega in F` | R6 (proved, support-level) |
| ideal vs Mengerian clutters (Seymour; Q6) | ideal but packing fails | C218 nucleus (§2 below) |
| tropical rational-series equivalence (Krob) | undecidable off the sequential class | C232 non-twins relays (§1 below) |
| Tutte-plane evaluation (Jaeger–Vertigan–Welsh) | `#P`-hard except on measure-zero loci | C219 reliability point (§3 below) |
| square-code distinguishability (Couvreur et al.) | square dimension detects hidden structure | C237 `U(3,8)`, square rank 5 vs 6 (§4 below) |
| realization-space universality (Mnëv) | `∃ℝ`-complete in general | reconstruction program (earlier draft §7) |

The value proposition is that **one family sits on all these knife-edges for the same reason**, so a
single construction paper hands six mature communities a ready-made extremal instance. The rest of this
report supplies the four homes on that list the brainstorms and the earlier draft did not name, then
xrefs the rest.

## 1. Paper P has a decidability wall with a name: Krob undecidability (the decisive negative)

C234 states, correctly and carefully, that the delay-transfer carrier is infinite and makes *no*
rational-series claim. The reason that caution is right has an exact citation neither brainstorm nor the
earlier draft supplied, and naming it converts Paper P's open "canonical contextual quotient" from a
hopeful program into a **sharply bounded** one:

> C234's budget-indexed arrival profiles are a rational series over the tropical (min-plus) semiring.
> **Equality of tropical rational series is undecidable** (Krob 1994). Therefore Paper P's "canonical
> contextual equivalence for bounded-restoration modules" cannot be an effective quotient on the full
> C232 family — the non-twins triangle relays are exactly the min-plus non-determinizable instances
> where equivalence is undecidable.

This is the decisive-negative the lane's search discipline rewards, and it is *constructive* about the
escape, so it names a lever rather than a floor: C233's terminal-closure algebra is the **decidable
retract**. The dichotomy is clean and publishable as stated —

- **C232 regime** (pairwise-distinct relay delays, twins property fails): min-plus non-sequential,
  Krob-undecidable exact equivalence, no finite value quotient. This is the honest ceiling on Paper P's
  general theorem.
- **C233 regime** (terminal saturation, finite monotone boundary control): the determinizable / twins-
  satisfied subclass, where sequentiality is decidable (Mohri; Kirsten–Lombardy) and the contextual
  quotient *is* effective and canonical.

So Paper P's theorem should be stated as: *bounded restoration has a canonical minimal contextual
quotient exactly on the terminal-control (twins) subclass, and provably no effective one off it, by
Krob.* That is a theorem with a matched positive and negative, which grades far above "we propose a
bespoke quotient." It also tells the drafter precisely where to stop pushing.

Anchor: Krob, *The equality problem for rational series with multiplicities in the tropical semiring is
undecidable* (1994); the sequential-side decidability is Mohri / Kirsten–Lombardy (xref earlier draft §3,
with which I concur as the positive half).

## 2. C235's availability-vs-throughput gap is ideal-but-not-Mengerian, not "minimally non-ideal"

R9 and item 6 correctly identify batch/PIR service and the fractional LP. The exact governing dichotomy
is clutter integrality, but the precise class matters and the earlier draft mislabeled it. Two integrality
properties must be kept apart:

- **Ideal** (covering LP integral for all right-hand sides) governs **availability**;
- **Mengerian / MFMC** (packing LP integral for all capacities) governs **throughput**.

These are different: MFMC implies ideal, never the converse, and the canonical separating object is `Q_6`,
which is **ideal but not Mengerian**. That is exactly the C218 nucleus phenomenon, and it explains R9's
otherwise-puzzling pairing precisely:

> Every curve target has single-target profile `(nu, tau) = (1,1)` with **zero covering gap** — the port
> clutter is **ideal**, so availability is gap-free (matching R9). But the common nucleus forces a
> **packing** (max-flow) gap — the clutter is **not Mengerian** — so simultaneous throughput collapses to
> one. The harmonic nucleus port is a repair-theoretic `Q_6`-type witness: ideal, not Mengerian.

This both corrects the earlier draft (which called it "minimally non-ideal / non-packing," the wrong class —
mni clutters fail idealness itself, but here idealness *holds* and packing fails) and upgrades C235 from a
worked example to a classification target: **characterize which port clutters are Mengerian** (throughput-
integral, no nucleus bottleneck) versus **ideal-only** (available but throughput-capped), via Seymour's MFMC
characterization (excluded `Q_6`/odd-hole minors). The `8/3`-to-`1` nucleus ratio is then the size of the
fractional-vs-integral packing gap of a specific non-Mengerian minor, which is a theorem shape, not a census.

Anchor: Seymour, *The matroids with the max-flow min-cut property*; Cornuéjols, *Combinatorial Optimization:
Packing and Covering* (`Q_6` as the ideal-not-Mengerian exemplar).

## 3. Every port query has its exact complexity read off the Tutte plane (Vertigan)

The item-7 critique already gives the hardness *half* (graphic ports are two-terminal reliability, so
pointed reliability is `#P`-hard by Provan–Ball; minimum blockers contain minimum-weight-codeword, NP-hard
by Vardy). C227 makes this sharper than a pair of reductions: since the port is the Las Vergnas perspective
`M\x -> M/x` and reliability is a specialization of its two-variable polynomial, the **Jaeger–Vertigan–Welsh /
Vertigan dichotomy** classifies the complexity of *every* Tutte-plane query at once — `#P`-hard everywhere
except a measure-zero set of special points and curves where it is polynomial.

The fresh content for Paper N (the KC map): the "which queries are tractable" axis the audit wants to build
by hand is, on the exact-evaluation side, **already resolved by the plane** — availability, reliability,
blocker count, and ETA are distinct Tutte-plane points, and their tractable/hard status is not open, it is
a lookup once the specialization coordinates are fixed. The genuinely open axis is *succinctness of the
representation*, which is the earlier draft's monotone-span-program lower bounds (§2 there). So Paper N
splits cleanly into a **solved evaluation-complexity half (Vertigan) and an open representation-succinctness
half (MSP lower bounds)** — two mature bodies of theory, neither needing bespoke complexity proofs.

Caveat worth one line in the paper: JVW is stated for the ordinary Tutte polynomial; the pointed/perspective
polynomial needs its dichotomy confirmed (expected to inherit, since its reliability specializations already
land on the ordinary plane). That confirmation is a bounded literature/reduction task, not a research
program.

Anchor: Jaeger–Vertigan–Welsh, *On the computational complexity of the Jones and Tutte polynomials*;
Vertigan's plane dichotomy.

## 4. C217/C237 holonomy is a square-code distinguisher — a cryptanalytic home, not only an MPC one

R5 computes the right number (square dimension `2k-1 = 5` for the conic/GRS `[8,3]` versus `6` for generic,
same support `U(3,8)`) and cites Mirandola–Zémor and Couvreur et al. as tools. The connection the brainstorms
stopped short of naming as a **home**: this quantity *is* the Couvreur–Márquez-Corbella–Pellikaan square-code
distinguisher — the exact primitive that breaks GRS- and AG-code-based McEliece. That reframes two loose
threads into concrete objects:

- **item 18's "information exposure" becomes a theorem, not a caution.** Publishing the complete repair port
  leaks the support matroid (L0); it does *not* leak holonomy (L1). But the **Schur/star-product** of the
  repair equations *does* expose the square dimension, so a deployment that reveals enough repair relations
  to reconstruct `C^{*2}` leaks whether the code is structured (GRS/conic) or generic. That is a precise
  structural-leakage statement with an attack model attached.
- **the positive primitive:** a support-identical / square-different pair is a **structural fingerprint** —
  a code-based watermark or tamper-evidence gadget where two deployments are operationally interchangeable
  (identical ports, identical access structure) yet efficiently distinguishable by their square. C237 already
  built the witness; naming it as a distinguisher primitive is the paper move.

This sits *beside* the MPC reading (R5/C228: does holonomy change strong multiplicativity), not instead of
it: strong multiplicativity is the constructive use of `C^{*2}`, the distinguisher is its cryptanalytic use,
and both are governed by the same square matroid. C237's rank-5-vs-6 separation is therefore one object with
two audiences.

Anchor: Couvreur–Márquez-Corbella–Pellikaan, *A polynomial-time attack on the BBCRS scheme* / square-code
distinguishers for GRS and AG codes; Wieschebrink (square-code attack lineage).

## 5. The harmonic reliability enumerator lives in a Delsarte association scheme (home for R8's open α₄)

R8 leaves the general harmonic-arc number `alpha_4(q)` open and (rightly) flags it for separate allocation.
The mature machinery for that object was not named: the `S(3,4,q+1)` port is a **3-design carrying the full
`PGL(2,q)` action**, so its block-free-set / independence enumerator — which R8 proves *is* the nucleus
reliability table — is an inner-distribution quantity of the associated **association scheme**, and
**Delsarte's linear-programming bound** governs `alpha_4(q)` the same way it bounds anticodes and independent
sets in designs. This gives R8's deferred additive-geometry question a standard attack (LP bound + the
scheme's eigenvalues) rather than a bespoke arc count, and it ties the reliability polynomial (C219/C226) to
the design's spectrum, which is the kind of "explanatory compression that replaces a census" the search
discipline asks for. Confidence: medium — the identification is clean, the sharpness of the LP bound for this
specific scheme needs checking, but either outcome (tight → theorem; loose → the gap is the content) is
publishable, exactly parallel to how R8 already treats the Poisson windows.

Anchor: Delsarte, *An algebraic approach to the association schemes of coding theory*; the LP bound for
`t`-designs.

## 6. One fresh cross-link the layer decomposition hides: Papers O and C235 are the same integrality question

The audit files Paper O (failure-aware multi-extraction) under L2/L3 and C235 (batch service) under L3, as
if separate. They are two faces of **hypergraph-flow integrality**. The earlier draft correctly homes Paper
O's engine in min-cost directed hyperpaths (Knuth's grammar problem / weighted deduction — I concur). The
capacitated, multi-target version of that engine — Paper O's actual novelty increment (shared capacities +
failures) — is a **hyperflow** (Cambini–Gallo–Scutellà), and its integrality is governed by the same
balanced/Mengerian condition as C235 §2. So:

> Paper O's "does a bounded certified schedule exist under shared capacity" and C235's "is the throughput
> region integral" are one question — hyperflow integrality — and the C218 nucleus is the shared obstruction
> (non-Mengerian minor) that makes *both* fractional-but-not-integral.

That merges Paper O's capacity increment and C235 under one theorem umbrella and gives Paper O a non-e-graph
theoretical spine (it is not only "Knuth plus engineering"; the capacity layer is a genuine integrality
dichotomy). This link is not in either brainstorm or the earlier draft.

Anchor: Cambini–Gallo–Scutellà, *Flows on hypergraphs*; xref §2 above and earlier draft §4.

## 7. Corrections to the earlier draft

The companion `fresh-connections-review.md` is substantively strong; two items need fixing before anything is
promoted from it:

- **Its §5 conflates idealness with the max-flow-min-cut (packing) property and calls the nucleus "minimally
  non-ideal."** Wrong class. The nucleus port is **ideal** (covering integral — that is *why* availability is
  gap-free, matching R9) but **not Mengerian** (packing fails — that is why throughput caps). Replace with §2
  above; the exemplar is `Q_6`, not an mni clutter, and Lehman's mni theorem is the wrong anchor.
- **Its §1 states the Baker–Bowler/foundation dictionary is "exact, not analogical" and pre-grades it "A+"
  while §10 also lists the circuit-axiom instantiation as the to-do that would verify it.** Those are in
  tension. Soften to "conjecturally exact pending the tract circuit-axiom check." The tract home (matroids
  over hyperfields; foundation = universal representation) is the right one — I concur it belongs *before*
  the oriented-matroid audit — but the confidence should follow the verification, not precede it.

Minor: its letter grades throughout are strategic bets, not measured findings, and should carry that label so
they are not quoted downstream as results.

## 8. Short xrefs (overlap with the brainstorms and the earlier draft)

- **Concur** with R1 (blockers = minimal codewords through a coordinate) as the spine, and with the earlier
  draft that the tract/foundation view is its moduli completion.
- **Concur** with the earlier draft §2 (port as monotone span program; field-sensitive MSP size lower bounds
  are the A+ separation lever). One refinement: the interesting quantity is the *minimum* MSP size over a
  field versus the given representation's size; R6/R11 are the seed gadgets because a function whose small MSP
  needs cube roots of unity is a field-sensitivity separation — this is §0's first table row.
- **Concur** with the earlier draft §3 (twins property / tropical automata) as the positive half of Paper P;
  §1 above adds the negative half (Krob) it omitted.
- **Concur** with the earlier draft §4 (min-cost hyperpaths / Knuth / weighted deduction) for Paper O; §6
  above adds the capacity-integrality spine it did not connect to C235.
- **Concur** with the earlier draft §6 (bootstrap percolation = metabolic scope = target-set selection, one
  monotone closure) and §7 (Mnëv `∃ℝ` bound on reconstruction). Both are correctly placed.
- **Concur** with R4(d)/(e), R6, R11 as unit tests and with the item-7 critique that C216-as-stated gives
  `O(1)` transfer; §3 above turns its hardness half into the full Tutte-plane picture.
- **Reject** promoting "operational provenance" (Paper S) as a distinct A-target — it is weighted logic
  programming over an unusual semiring (§4 of the audit half-says this; fold into the hyperpath framing).
- **Reject** the audit's framing of Paper M as "may already be in oriented-matroid theory, audit later." It
  is in *tract* theory specifically; oriented matroids are the sign-hyperfield slice only.

## 9. Suggested bounded actions (user's disposition; ordered by grade-lift per effort)

1. **Add Krob (§1) as Paper P's decidability wall and state the C232/C233 dichotomy.** Highest lift: it
   converts an open bespoke-quotient program into a matched positive/negative theorem, cost is two citations.
2. **Rewrite C235 on the ideal-vs-Mengerian axis (§2), and merge Paper O's capacity layer into it (§6).** One
   dichotomy replaces two bespoke region computations and gives Paper O a theoretical spine.
3. **Package C237's square separation as a distinguisher/fingerprint primitive (§4)** alongside the MPC
   reading — same object, second audience, concrete attack/leakage statement for item 18.
4. **Cite Vertigan (§3) to close Paper N's evaluation-complexity half** and isolate the open half as MSP
   succinctness (earlier draft §2).
5. **Route R8's `alpha_4(q)` to the Delsarte LP (§5)** when the harmonic-arc question is allocated.
6. **Adopt §0's gadget-library framing** as the construction paper's headline: one family, extremal witness
   for six dichotomies, same underlying reason.

**Vibe check.** The material is strong and unusually disciplined, and the two prior brainstorms plus the
earlier draft have already found most of the good homes. My net addition is four things they missed and one
they got wrong: a named decidability wall for Paper P (Krob) with its decidable retract, the correct clutter
class for C235 (ideal-not-Mengerian, which also fixes the earlier draft), the full Tutte-plane complexity
picture for the query map, and the cryptanalytic reading of the holonomy separation. The single highest-value
idea is the §0 reframe — that this one family is the shared extremal instance of many independent theorems —
because it turns a portfolio of B+/A− applications into one A-grade construction that several communities
each want. Momentum is good; the risk is breadth, and the discipline that mitigates it is exactly the
matched-negative habit (Krob, Mnëv, `Q_6`) the lane already practices.

This review allocates no task and changes no gate.
