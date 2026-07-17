# Direction: the nucleus theorem — information-sufficient but locally unreachable

**Lane**: `rp-next`

**Date:** 2026-07-17
**Status:** DIRECTION DOC. Advisory; allocates no task, changes no gate. Built on the
[independent gap review](2026-07-17-fable5-rp-next-independent-gap-review.md) (items 1 and 4) and
the [theory-gap mining ledger](2026-07-17-fable5-theory-gap-mining.md) (survivor N2 and the
spreading-sets anchor), both PROVISIONAL pending a user-launched vet. Statements of lane results
below are as relayed by those documents; each must be re-verified against the primary C-reports
(especially C219, C226, C236) at promotion. Promotion requires normal C-ID allocation and dedupe
against the unread C239 material and the prior Fable review notes.

## The phenomenon, packaged as its own theorem

The lane holds, across two structured families, an exact constructive separation between *holding*
information and being able to *locally propagate* it:

- **Harmonic family** (rule system on a Steiner quadruple system `S(3,4,q+1)` with a designated
  nucleus element): there is a seed that **spans** — it determines the global state outright — yet
  its radius-four sequential closure is **inert**: no bounded-radius cascade recovers anything.
  With the nucleus present, the cascade completes.
- **Cubic–axis family:** the gap provably never occurs — sequential closure equals span for every
  seed over every `GF(3^h)` (C236) — and consequently the cascade threshold collapses to the span
  threshold, which is exactly computable.

The proposed paper makes this separation the headline object rather than a byproduct:

> **Theorem N (separation; assembly of existing results).** There exist natural, infinitely
> scalable rule systems in which some information-complete seed admits no bounded-radius recovery
> cascade, and becomes fully cascading upon adjoining one designated element; and sibling systems
> of the same type in which no such gap exists and the cascade threshold is exactly the
> (computable) span threshold.

plus the new problem class it opens:

> **Problem class (nucleus-gated bootstrap percolation).** Bootstrap percolation on
> `S(3,4,q+1)`-structured rule hypergraphs in which global completion is gated by a common nucleus
> — determine the random-seed cascade threshold, the serial-bottleneck (gate-waiting) time, and
> their windows.

## Context and the far-side anchor

Deterministic spreading questions of this shape have a far-side name: **spreading sets**
(Nagy–Szemerédi 2022, per the mining pass), covering the deterministic half for their structures.
The probabilistic half — random-seed thresholds — is hypergraph bootstrap percolation, an active
area. The mining ledger's search found **no treatment of a nucleus-gated variant** and no
threshold work on Steiner-quadruple-system rule structures of this kind [L1/L2; L3 read of the
spreading-sets paper unpaid — it is the one mandatory read before any novelty language is used].
The gap review independently flagged the same object (item 4) as "a new, well-posed threshold
problem with a serial bottleneck twist."

Tools already in hand for the probabilistic half: C219's Poisson windows and C226's transforms
(one-shot versions of exactly the quantities the iterated problem needs), and C236's threshold
collapse, which makes the cubic side of every comparison exactly solvable.

## Motivation

1. **The most exportable object the program owns.** Every earlier brainstorm round found that
   distant communities each have a *name* for "large coalition, powerless without one designated
   element" — and none has a rigorous, scalable example with certified thresholds. This paper is
   that example, delivered with both the phenomenon and its exactly-solved control case.
2. **Fastest to write of the three flagship directions.** Theorem N is an assembly-and-framing
   task over proved results; the genuinely new mathematics (the gated threshold) has its tools
   staged and its control case solved.
3. **It names a problem class.** The durable value of a first paper in a class is the
   definitions; the program gets to fix them, with the solved cubic case as the calibration.
4. **In-program:** this is the missing probabilistic leg of Paper B (gap review, item 4), and the
   separation theorem doubles as the sharpest advertisement for the classification direction (the
   peeling-completeness doc, sibling to this one).

## Desired outcomes, tiered

- **A:** the separation theorem + the exact (or sharply windowed) nucleus-gated threshold on the
  harmonic family, with the serial-bottleneck time identified — the full two-part paper.
- **A−:** separation theorem + the gated threshold in a Poissonized/mean-field regime with the
  window from second-moment methods, exact collapse on the cubic side, and simulations certified
  against small exact censuses.
- **B+:** separation theorem + problem-class definitions + the cubic exact solution + the harmonic
  one-shot transforms (C219/C226 material), with the iterated gated threshold posed as the open
  problem. Still a coherent, citable first paper in the class.
- **Kill condition:** the L3 read shows spreading sets (or an adjacent literature) already treats
  gated iterated cascades on Steiner-type systems. Then the export contracts to the separation
  theorem alone, reframed against that literature — smaller, still real.

## Research plan

**Phase 0 — vet, source-verify, and the one mandatory read (gate).** Vet of the underlying
reviews; re-verification of the harmonic inert-seed witness and C236 at their sources; the L3 read
of Nagy–Szemerédi 2022 and a bounded scan of its citers for gated variants. Cheap, decisive, and
first.

**Phase 1 — assemble Theorem N.** No new mathematics: state the rule-system framework, import the
harmonic witness and the C236 completeness proof, and prove the separation statement as a
corollary of the two. Fix the problem-class definitions (gate, cascade, bottleneck time) here,
with care — this vocabulary is the paper's most durable export.

**Phase 2 — the cubic control case, closed exactly.** Random-seed threshold = span threshold
(C236 collapse); compute the span threshold and its window explicitly via the coupon-collector /
linear-algebra-over-`GF(3^h)` structure, with C219/C226 supplying the distributional transforms.
Deliverable: the exactly solved member of the class.

**Phase 3 — the harmonic gated threshold.** The new work. Decompose the cascade probability by
conditioning on the gate:
`P(full cascade) = P(nucleus becomes active) · P(completion | nucleus active) + (gate-free paths, if any)`.
Sub-questions, each a bounded work item: (a) the pre-gate reachable set's growth law (a subcritical
cascade confined by the gate); (b) the hitting time of the nucleus (the serial bottleneck); (c) the
post-gate supercritical completion, which should reduce to a standard bootstrap argument on the
quadruple system once the gate is open. Methods: second-moment/branching comparisons for (a) and
(c); (b) is the novel serial-bottleneck analysis and the paper's technical heart.

**Phase 4 — certification and simulation hygiene.** Exact small-`q` censuses (the lane's standard
discipline) certify every asymptotic claim's finite shadow; simulations are calibrated against
them, never freestanding.

**Phase 5 — write-up and formalization.** Theorem N and the cubic collapse are
formalization-friendly now (finite witnesses + an already-proved uniform theorem). The
probabilistic Phase-3 material formalizes only as far as its combinatorial lemmas; state the
probability results classically and formalize the deterministic core — consistent with the lane's
existing gate practice.

## Starting theorems and proof spines

**Theorem 1 (separation — provable now by assembly).** As Theorem N above. Spine: the harmonic
inert-seed witness gives the gap; C236 gives the gap-free sibling; the only new content is the
common framework in which both are instances, which Phase 1 fixes. Risk: none mathematical; the
work is definitional taste.

**Theorem 2 (cubic threshold — provable now from C236 + computation).** For random seeds of
density `p` on the cubic–axis family, the cascade probability transitions exactly at the span
threshold, with window governed by the rank-deficiency distribution of random subsets over
`GF(3^h)`. Spine: C236 reduces cascade to span; span of random subsets is a classical
random-matrix-over-finite-fields computation; C219/C226 supply the refined window. This is the
paper's fully solved exhibit.

**Candidate Theorem 3 (harmonic pre-gate confinement).** Below the gate's activation, the
radius-bounded reachable set of a random seed is confined: its expected growth is subcritical with
an explicit rate determined by the quadruple-system degree structure. Spine: branching-process
upper bound on rule firings that avoid the nucleus; the Steiner regularity gives exact expected
offspring counts. This formalizes the "inertness is typical, not just worst-case" half.

**Candidate Theorem 4 (gate hitting time / serial bottleneck).** The time (or seed density) at
which the nucleus activates is the threshold's dominant term, with the post-gate completion
contributing lower order. Spine: the nucleus activates only via its own rule neighborhood, so its
hitting time is a first-passage problem over a sparse set of derivations; compare with (a)'s
confinement to show pre-gate growth cannot shortcut it. This is the genuinely new analysis and
the result that names the class.

**Candidate Proposition 5 (no gate-free completion).** No seed completes while avoiding the
nucleus (or: the gate-free paths have vanishing probability) — the probabilistic strengthening of
the deterministic inertness witness. Spine: expected to follow from the same structural fact that
makes the witness inert; if it fails, the class definition gains a parameter (partial gates),
which is a feature, not a bug.

## Risks and unknowns

- **The Phase-0 read is load-bearing.** All novelty language is conditional on the spreading-sets
  read and its citer scan; the mining evidence is L1/L2 only.
- The harmonic inertness witness is, per the gap review, a specific seed at a specific radius; the
  paper needs the phenomenon stated at the right generality (all radii? all spanning seeds of its
  type?). Source re-verification in Phase 0 determines how much strengthening Phase 1 needs.
- Serial-bottleneck analysis on hypergraph bootstrap has no off-the-shelf template; Phase 3(b) is
  the item most likely to grow. The B+ tier exists precisely so the paper does not hostage itself
  to it.
