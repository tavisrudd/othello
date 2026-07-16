# Spinoff Bridges: Proved Cap-Game Assets Through Duals and Isomorphisms

**Lane**: `cap` — see CLAUDE.md § Lane routing.

**Date**: 2026-07-09
**Created by**: 2026-07-09--11 (`8b6d1419-df84-4895-8bec-907fb3a79c36`)
**Purpose**: Develop the satellite projects that fall out of the program's *proved* theorems
when pushed through standard equivalences (codes, additive combinatorics, games on groups,
matroids, designs, non-Desarguesian planes).

---

## Context

The projective cap/Nofil program (see the
[projective cap game handoff](2026-07-06-projective-cap-game-handoff.md)) has a body of
finished results: the affine cap theorem (`AG(n,q)` is P), `PG(n,2)` via the sum-free bridge,
odd-dimensional odd-q spaces via the elliptic fpf-involution mirror, even-q planes via the
char-2 translation mirror, the C48 harvest (hyperbolic quadrics `Q⁺(2m−1,q)` P for odd q, plus
the general fpf sub-board lemma), the Node-Kayles structure theorems for the conic residual
(Lemmas V–VII of the [NK involution note](../2026-07-08-nk-involution-residual.md)), and the
capacity-mirror obstruction lemma (C27, vetted in the
[line-capacity framing vet](../2026-07-09-line-capacity-framing-vet-extensions.md)).

A 2026-07-09 assessment session found that several of these become *bridge theorems* into
other subfields under standard isomorphisms — mostly reframing plus modest new work, since the
theorems, Lean infrastructure, and solver corpus already exist. This document specifies those
satellites. They are outward-facing publications/notes, **except item F**, which also feeds
the main odd-plane program directly.

Blanket dualization of the game itself is a no-op (`PG(2,q)` is self-dual, and a correlation
maps points to lines so it can never be a reply map); the leverage is in the isomorphisms
below, and duality only becomes intrinsically interesting at item F, where self-duality fails.

## Scope

- In scope: outward-facing satellite notes/papers built on already-proved results; the
  order-9 non-Desarguesian solve (F) including any solver input-mode work it needs.
- Out of scope: the odd-plane kernel itself (steering/maintenance/termination lanes), any
  claim of a new general class of impartial games (novelty guard below), and broad new Lean
  abstractions (e.g. a generic `LineCapacityGame`) — the vet already deprioritized those.

## Work Items

Items A–E are independent; F is independent of all of them.

**Lit/priority check done (Opus delegate, 2026-07-09):** full findings with citations and search
logs in [`../2026-07-09-spinoff-bridges-litcheck.md`](../2026-07-09-spinoff-bridges-litcheck.md).
Revised value order: **F, A, B, C, E, D**. Verdicts: A none-found/low-risk; B partial-overlap/low
(the HHS gate is settled — they prove no infinite family, so the AG(n,q)/binary-projective
outcomes are ours; frame as the impartial counterpart of Beck/Rado Maker–Breaker); C
partial-overlap/medium (no geometric client of the generation-games genre found, but scope the
Node-Kayles export to the geometric/arithmetic indexing only — degree-≤2 unions-of-matchings per
se is classical Dawson); E rescoped to the fpf-classification synthesis only (defer the
circle-geometry game; the group-theory data is tabulated, the work is synthesis); D folded into A
as a subsection (games-on-matroids is crowded and the general-position graph game is nearly the
same shape — do not write standalone); F none-found/low (games have never been used as a plane
invariant) and queued as **C58** in the codex task queue.

**A. Code-extension game reframing (caps ↔ linear codes).**
A cap in `PG(n,q)` is a parity-check-matrix column set with any 3 columns independent, i.e. a
code with minimum distance ≥ 4; a plane arc is an `[n,3]` MDS code. The game is: alternately
append columns keeping `d ≥ 4`; last mover wins. Terminal positions = complete caps/arcs =
non-extendable codes (adjacent to the MDS conjecture / Ball's prime-field arc work). Restate
the proved outcome theorems (affine, even-q plane, elliptic mirror, binary) in code language;
position against Conway–Sloane lexicodes as precedent for game↔code bridges (reverse arrow:
game theorems about code building). Done = a drafted note with the dictionary, the restated
theorems, and a literature check finding no prior impartial code-extension game.

**B. SET / cap-set / 3-AP-free game + sum-free games on abelian groups.**
`AG(n,3)` is the SET-deck avoidance game; the affine theorem says every generalized SET-free
building game is a second-player win. General `AG(n,q)` is the impartial avoidance counterpart
of Beck's Maker–Breaker van der Waerden games. Separately, the `Sumfree.Game` Lean
infrastructure behind `PG(n,2)` generalizes from nonzero vectors over GF(2) to finite abelian
groups — chase how far `nonzero_initial_isP_zmod2_of_finrank_ge_two` extends (elementary
abelian p-groups, cyclic groups). **Gate**: check exactly what Huggan–Huntemann–Stevens
already cover for Nofil on `AG(n,3)`/`PG(n,2)` (start from the
[novelty audit](../2026-07-08-codex-projective-nofil-novelty-audit.md)) before claiming the
flagship. Done = overlap verdict + either a drafted note or a documented negative.

**C. Games-on-groups bridge + standalone Node-Kayles family.**
Lemmas V–VII prove intruder play is players selecting involutions in `PGL(2,q)`, value carried
by the generated dihedral subgroups (orders pinned to the divisor lattice of q±1) via Dawson
arithmetic. Two deliverables: (i) a bridge note connecting the conic residual to the
achievement/avoidance-games-on-groups genre (Anderson–Harary generation games;
Benesh–Ernst–Sieben DNG/GEN) — the first geometric client of that genre found so far; (ii) a
standalone CGT export: Node-Kayles on unions of involution matchings is Dawson-tame with the
cycle bulk Grundy-0 (Corollary VII), an arithmetic-indexed tractable family. C45
(defect-skeleton realizability, in the codex queue) is the mathematical core of the expository
version ("Dawson's chess inside conics over GF(q)"); coordinate rather than duplicate.

**D. Matroid circuit-avoidance games.**
"No 3 collinear" is a girth condition in the rank-3 vector matroid, so the game generalizes to
building a set avoiding small circuits in a matroid; queens/Node-Kayles is the graphic shadow,
the proved theorems are the projective/affine cases, and matroid duality ties back to item A
(dual codes). Done = a short positioning note defining the generalization, placing the proved
results in it, and listing which matroid classes have any hope of outcome theorems.

**E. Design-theory capacity games + fpf classification note.**
The C27 capacity-mirror obstruction + C48's `initialSubCapP_of_fpf_collinearity_preserving`
form a general criterion: any board with an fpf block-compatible involution whose mirror-pair
chords avoid slack-1 blocks is P. Two deliverables: (i) capacity-c avoidance games on
t-designs and circle geometries (inversive/Laguerre/Minkowski planes — there "no 3 on a block"
is trivial, the natural game is capacity-3); (ii) the C48 boundary dichotomy generalized to a
classification note — which classical geometries carry an fpf automorphism compatible with
their block structure — citable in finite-group/geometry territory independent of any game.

**F. Order-9 non-Desarguesian plane solve (feeds the main program).**
Non-Desarguesian planes are not self-dual (a Hall plane and its dual are non-isomorphic), so
there the cap game and its dual game genuinely differ and the outcome becomes a candidate
invariant of the *plane*, not the order. Order 9 is the smallest non-Desarguesian order and is
solver-feasible (91 points; `PG(2,9)` is already exhaustively solved P).
- Add an incidence-matrix (or point/line-list) input mode to the solver
  (`notes/2026-07-06-grid-cap-solver.rs`) or a small standalone solver — the existing modes
  assume coordinatized `PG(2,q)`.
- Construct the four projective planes of order 9: `PG(2,9)`, Hall, dual Hall, Hughes.
  Verify each incidence structure honestly (axioms + parameters) before solving, per the C48
  precedent of building boards from their defining data.
- Exact-solve the cap game on each (and note that Hall vs dual Hall is the duality
  comparison; Hughes is self-dual).
- Done = an outcome table + report note. Inward payoff either way: any N verdict proves the
  odd-plane conjecture is about Desarguesian structure rather than order (a falsification-map
  constraint); all-P pressures the eventual proof to use less algebraic structure than conic
  localization currently does. Cross-link the result into the falsification map and the main
  handoff.

## New Candidate Mappings (2026-07-09 broader sweep)

A second sweep brainstormed further categories/structures/subfields, each assessed on two axes:
spinoff value (outward-facing papers/notes) and leverage on the main odd-plane conjecture.

**Second-pass lit check done (Opus delegate, 2026-07-09; findings appended to the
[litcheck report](../2026-07-09-spinoff-bridges-litcheck.md) §Broader-sweep candidates).**
Verdicts: **proceed** — no-three-in-line game (none-found; must cite and distinguish the
Dudeney-motivated general-position games on graphs, which use geodesics not Euclidean
collinearity), Singer/Sidon games (cleanest none-found of the sweep; bonus static anchor:
forbidden Sidon subsets of perfect difference sets, Erdős problem 707), quantum caps
(correspondence citable via Tonchev / Bierbrauer–Edel; game layer none-found; PG(3,4) outcome
untouched anywhere), positional comparisons (a 2026 Maker–Maker-on-AG-spaces paper gives the
comparison a live other side; note the Kusch–Rué–Spiegel memory was corrected — that is biased
Maker–Breaker/containers, not projective planes). **Merge/hold** — buildings/flips merges into
item E-ii as its citation backbone (flip classifications are published); Igusa verified correct
(held for C56); placement/Morse confirmed FHN citations but no Morse↔strategy connection exists
anywhere (analogy only, hold); misère none-found but high effort (hold); infinite boards and
reconfiguration to backlog. **Drop** — complexity landscape (hardness already published
repeatedly: Schaefer 1978, HHS, Slany, and a dedicated avoidance-games-PSPACE paper — keep as a
citation block only); hypergraph containers (arXiv:2404.05305 **already applies containers to
our exact collinearity hypergraph** — caps/ovoids/spreads — so this flips from spinoff to a
main-program import worth reading); achievement/partizan folds into the C24
Clark–Mancini–Van Hook guard. A convex-geometry avoidance lane publishing as of late 2025 is a
timeliness signal for the whole sweep.
The main-conjecture-relevant items are already queued per Fable's call: **C59** (arc-stability
constraint import) and **C60** (Singer-model circulant probe) in the codex task queue; Igusa
invariants are folded into C56 as candidate canonical coordinates; the amortized-potential
template is recorded in the queue's steering method note.

Sorted by spinoff value:

- **No-three-in-line game** — the residual grid game *is* a finite-field no-three-in-line
  problem (Dudeney's classic) with row/column capacities, and the classical near-2n
  constructions are conics mod p. A game version of the classical problem appears unstudied;
  the grid solver plays it today with trivial modification.
- **Singer / Sidon-set games** — under the Singer cycle the plane is a cyclic board (points
  `Z_{q²+q+1}`, lines = translates of a perfect difference set); one step away is the
  Sidon-set building game on `Z_n` (capacity-1 on difference lines), clean, elementary, and
  apparently unstudied.
- **Quantum caps** — caps in `PG(n,4)` ↔ additive quaternary codes ↔ stabilizer quantum codes
  (Glynn–Tonchev lineage); the cap game there is a quantum-code-extension game, and `PG(3,4)`
  is an open board in our own outcome table (85 points, plausibly solvable).
- **Placement complexes / discrete Morse** — the cap game is a strong placement game, so
  positions form a simplicial complex (Faridi–Huntemann–Nowakowski dictionary); its f-vectors
  are the arc-spectrum tables finite geometers already compile; pairing strategy ↔ acyclic
  matching, defect skeleton ↔ critical cells (analogy to develop, not a theorem).
- **Misère siblings** — every closed family has an untouched misère version; mirror strategies
  characteristically break under misère; Plambeck–Siegel quotient machinery on geometric
  avoidance is unworked.
- **Positional-game comparisons** — the same collinearity hypergraph under Maker–Breaker /
  Avoider–Enforcer / Client–Waiter conventions vs our impartial shared game; a comparison
  paper with mature machinery (Erdős–Selfridge, pairing criteria) on the other side.
- **Genus-2 moduli / Igusa invariants** — on-conic 6-subsets mod `PGL(2,q)` are (modulo
  twist/automorphism bookkeeping and small characteristics) F_q-points of the genus-2 moduli
  space M₂; a game-valued stratification of a moduli space, with Igusa invariants as the
  canonical cross-q coordinates for exactly these configurations.
- **Complexity landscape** — PSPACE-completeness territory for Nofil/cap games on arbitrary
  partial linear spaces vs structured geometries (Schaefer-style program).
- **Achievement / partizan siblings** — geometric Sim / colored SET achievement on the same
  boards; adjacent prior art exists (the C24 Clark–Mancini–Van Hook guard) — lit-check first.
- **Buildings & flip theory** — flips of buildings (Bennett–Gramlich et al.) as the
  classification framework for the fpf-involution question; upgrades item E-ii from
  bookkeeping to a citable framework.
- **Reconfiguration graphs** — token-move reconfiguration between caps/arcs of fixed size in
  finite geometries; active community, unmined boards, easy first results.
- **Hypergraph containers** — structure/clustering statements for mid-size caps; asymptotic-q
  only, with weak constants at the frontier (the Hall/pairing precedent applies).
- **Infinite boards** — the no-3-collinear game on R², Q², `P²(F̄_q)`; determinacy and draw
  conventions; a Monthly-style note at best.
- **Arc stability (Segre–Voloch–Ball)** — pure import, hence low spinoff value and the
  highest main-lane value of the sweep: every complete arc not contained in a conic has size
  ≤ q − c√q (odd q), so large terminal positions are conic-contained by theorem. Queued as
  C59.
- **Online / amortized potentials** — the zero-xor maintenance/termination invariant as
  adversarial dynamic maintenance; a design template (charged potential, not a single
  conserved quantity), recorded in the queue's steering method note.

| Mapping                        | Spinoff       | Main conjecture |
|--------------------------------|---------------|-----------------|
| No-three-in-line game          | strong        | medium          |
| Singer / Sidon-set games       | strong        | medium          |
| Quantum caps `PG(n,4)`         | medium-strong | weak-medium     |
| Placement complexes / Morse    | medium-strong | medium-weak     |
| Misère siblings                | medium-strong | weak-medium     |
| Positional-game comparisons    | medium-strong | weak            |
| Genus-2 moduli / Igusa         | medium        | medium          |
| Complexity landscape           | medium        | weak            |
| Achievement/partizan siblings  | medium        | weak            |
| Buildings / flip theory        | medium        | weak            |
| Reconfiguration graphs         | medium        | weak            |
| Hypergraph containers          | weak-medium   | medium-weak     |
| Infinite boards                | weak-medium   | weak            |
| Arc stability (Voloch–Ball)    | weak          | medium-strong   |
| Online/amortized potentials    | weak          | medium          |

## Codebase Reference

| What                                | Where                                                          |
|-------------------------------------|----------------------------------------------------------------|
| Canonical program handoff           | `notes/handoffs/2026-07-06-projective-cap-game-handoff.md`     |
| NK structure theorems (Lemmas V–VII)| `notes/2026-07-08-nk-involution-residual.md`                   |
| Novelty audit (prior-art list)      | `notes/2026-07-08-codex-projective-nofil-novelty-audit.md`     |
| Line-capacity framing vet           | `notes/2026-07-09-line-capacity-framing-vet-extensions.md`     |
| Affine theorem (Lean)               | `lean/CapGame/Affine.lean`                                     |
| Sum-free / binary bridge (Lean)     | `lean/ProjectiveCap/Binary.lean`                               |
| Elliptic mirror (Lean)              | `lean/ProjectiveCap/EllipticMirror.lean`                       |
| C48 general fpf sub-board lemma     | `lean/ProjectiveCap/HyperbolicQuadricMirror.lean`              |
| Exact solver (for item F)           | `notes/2026-07-06-grid-cap-solver.rs`                          |
| C48 board-construction precedent    | `rust/scripts/projcap_mirror_harvest.py`                       |

## Principles / Constraints

- **Novelty guard (from the main handoff)**: claim structured subfamilies and bridges, never a
  new general game class; the bare `Nofil = Node-Kayles` collapse is HHS prior art; verify
  each adjacent-prior-art item (Sieben's taxonomy, general-position games, Arc-Kayles
  generalizations) before drafting.
- Record all findings in git-tracked notes/handoffs, never the auto-memory.
- These are satellites: do not let them displace the odd-plane kernel lanes; F is the only
  item with a claim on main-program time.

## Delegation

- **Can delegate to sub-agent?** Yes, per item. A–E are research/drafting tasks; F splits
  into solver plumbing (delegable) + plane construction/verification (delegable with the
  honest-construction gate).
- **Model**: Opus for the math-heavy drafting (A, B, C, E) and for F's plane construction;
  either for D and F's input-mode plumbing.
- **Notes**: the item-B HHS overlap check is DONE (see the lit-check note above) — the gate is
  discharged. For F, verify plane axioms/parameters machine-side before trusting any solve;
  cross-check `PG(2,9)` reproduces the known P verdict as the calibration run. Two `[VERIFY]`
  loose ends from the lit check (a paywalled lexicode-complexity paper; arXiv:2211.05307
  unparsed) — neither changes a verdict, but check them before drafting A or C.
