# Write-up: "A game tablebase meets CGT — the S4 query tool in context"

**Lane**: `cap` — see CLAUDE.md § Lane routing.

**Date**: 2026-07-09
**Created by**: Fable (2026-07-09 discussion; no prior session context needed)
**Purpose**: Bank a calibrated assessment of how novel the S4 memo-dump/query tooling is within
combinatorial game theory (CGT), as a future short methods note or blog post.

---

## Context

The projective-cap/Nofil proof program built a well-engineered query tool around its impartial
game solver: a solver that computes P/N values, a memo dump to a sorted mmap store keyed by a
symmetry-quotiented 128-bit canonical key, a compact BuRR archive with fingerprint membership, a
line-protocol query shell (`state`/`moves`/`play`/`pop`/`replies`), a batch feature miner
(`s4mine`) that BFS-dedups reachable states and emits structured graph invariants, and a targeted
on-demand solver (`s4xormine`). The question this write-up answers: **how novel is this sort of
tool in CGT, and is the tooling itself worth writing up?**

The short answer, to expand into the piece: the individual components are mostly standard
game-solving engineering; the *assembly* is uncommon **within CGT practice** because it imports the
game-solving / game-AI toolchain into a corner of math that rarely reaches for it; and two specific
choices are genuinely fresh. Tool novelty is **methods-level, not theorem-level** — the publishable
*math* novelty rides in the results the tool produces (the outcome theorems and structural lemmas;
see the deliverables proposal), not in the tool.

This is a standalone communication deliverable. It is **not** tied to the active proof program and
does not block or depend on any C-task. Pick it up whenever there is appetite for a methods/blog
piece.

## Scope

- **In**: a calibrated positioning of the tool against CGT computational practice and the
  game-solving/tablebase tradition; the three-bucket structure below; a real literature check
  before any novelty wording; a venue decision (short methods note vs blog post).
- **Out**: no new tooling, no changes to the solver, no proof work. This is writing only.
- **Out**: do not claim the tool is a research contribution on its own terms until the lit check
  supports it — default posture is "competent adoption of known technique into a community that
  mostly hasn't adopted it," with two fresh wrinkles.

## Work Items

**A. Literature check FIRST (gates all novelty wording).** The assessment below is from-knowledge
and unverified. Search MathSciNet / arXiv / Google Scholar / DBLP for prior art on: "game tablebase
for CGT / lemma discovery", "retrieval data structure game database", "endgame database
combinatorial game theory", computational-CGT methodology notes, and any tool combining a
symmetry-reduced solved-position store with a feature-mining query layer. Record what exists.
Tools are the "dark matter" of computational math — widely built, rarely written up — so treat a
null lit result as "unverifiable, hedge accordingly," not as "definitely first."

**B. Draft around three buckets.**
1. **Standard (novel nowhere).** Value oracle / transposition table, mmap sorted store, versioned
   integrity-checked binary formats, query shell, BFS state dedup. The tablebase lineage is deep
   and published: Awari (Romein–Bal 2003, parallel retrograde), checkers (Schaeffer/Chinook 2007),
   chess EGTBs (Nalimov; Syzygy/de Man; Lomonosov 7-piece), Nine Men's Morris (Gasser 1993). Having
   a symmetry-reduced persistent game database is not new.
2. **Uncommon in CGT specifically.** CGT-theory (Berlekamp–Conway–Guy tradition) and
   game-solving engineering are largely separate communities with separate tools. The CGT standard
   is **CGSuite** (Aaron Siegel) — an in-memory algebra system for canonical forms, temperatures,
   atomic weights, misère quotients — not a persistent symmetry-quotiented tablebase with a mining
   layer. The other CGT staple is octal-game nim-sequence hunts (Flammenkamp) — 1-D sequences, not
   random-access position stores. A purpose-built game tablebase + query DSL + structured feature
   miner aimed at discovering structural lemmas for an **open outcome theorem** is not typical CGT
   practice.
3. **Genuinely fresh (foreground these two).** (a) **BuRR** (Bumped Ribbon Retrieval,
   Dillinger–Hübschle-Schneider–Sanders–Walzer, ~2022) used as a **lossy** game-value store with
   tunable fingerprint bits and accepted false positives — tablebases are almost always exact
   because you play from them; trading exactness for footprint because the consumer is a
   conjecture-miner, not a player, is the non-obvious move. (b) The reduction group is the
   **algebra, not the board** — folding the **PGL(2,q)** action into the canonical key, rather than
   the board's dihedral symmetry, is domain-specific and mathematically apt.

**C. Keep the caveats visible.** The cross-pollination is the interesting bit: outcome-theorem
framing is CGT, the toolchain is game-AI/strong-solving. State that the novelty is methods-level and
verify against the lit check before any "first"/"new" wording.

**D. Venue decision.** Based on the lit check: a short *computational-methodology* note for the
computational-CGT niche if there's a gap to fill, or a blog post if the value is expository. If a
methods note, the two things to foreground are the BuRR-as-lossy-store idea and the PGL-quotiented
key — a tablebase engineer would already have everything else.

## Codebase Reference

| What | Where |
|------|-------|
| S4 tool source (modes `s4dump`/`s4freeze`/`s4query`/`s4mine`/`s4xormine`/`s4bucketlist`) | `rust/notes/2026-07-06-grid-cap-solver.rs` |
| S4 dump/query manual (formats, guards, recipes) | `notes/2026-07-08-s4-memo-dump-query-manual.md` |
| Deliverables framing (where the math novelty lives, not the tool) | `notes/2026-07-09-stepping-stone-deliverables-proposal.md` |
| BuRR shared substrate | the queens BuRR archive (same retrieval structure reused) |

## Principles / Constraints

- Calibrated, not promotional — do not overclaim tool novelty; the results carry the math novelty.
- No specific counts in the prose (project doc-style rule): "modes", "each", not "N modes".
- The lit check gates the novelty language; a null result means hedge, not "first".

## Delegation

- **Can delegate to sub-agent?** Yes — this is self-contained.
- **Model**: Opus for the framing/prose; the lit-check phase can be a Sonnet sub-agent that only
  gathers and summarizes what exists (no root-cause / no novelty verdict — that's the writer's job).
- **Notes**: needs web/lit-search access for Work Item A. Do not write novelty wording before A is
  done.
