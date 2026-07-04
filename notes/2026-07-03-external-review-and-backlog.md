# External review (ChatGPT) of the 2026-07-03 theory package — verdicts + exploration backlog

**Date**: 2026-07-03
**Source**: ChatGPT review of the paper draft + the 2026-07-02/03 theory notes, relayed by the user.
**Disposition**: paper-facing directives forwarded to the paper-update pass the same day
(claim-level laddering, no confidence percentages in the paper, PV-certificate caveat,
border-decomposition frame, framing-order check). This note banks the review's verdicts and
the exploration backlog.

## Novelty verdicts (as assessed by the reviewer)

**Likely new**: the n=18 first-player win; the G(14..16) extension; the Mirror-Obstruction
Lemma as a unified framework; the even-board long-diagonal necessary condition (on winning
LINES, not roots); the kings central-2×2 condition; the embedded odd-center decomposition
after the central strike; the border/scar/bounded-interaction framing; the
mirror-rule-plus-exceptions certificate idea.

**Known/classical/lower-novelty**: P/N recursion + Sprague-Grundy; general copying
strategies; odd-board center steal; rooks fixed-length; torus G ∈ {0,1} (already in OEIS
comments — cite); true-twin deletion (folklore-adjacent); knights/bishops solutions probably
folklore — **check the literature before claiming**.

**Correctness notes adopted**: the even-n self-mirroring set is exactly the two long
diagonals, disjoint for even n hence 2n squares; bishops need "closed attack set" wording
(already applied); the n=18 PV alone is not a minimax certificate — the win claim rests on
the solver's refutation of every reply (state explicitly).

**The claim ladder (canonical wording, use everywhere)**:
1. PROVEN: every first-player winning line on an even board eventually contains a
   long-diagonal move.
2. CONJECTURE (Forcing-Root): when B_n is N, the central diagonal strike c* wins.
3. HEURISTIC (large n): winning roots tend central/diagonal.

**The decomposition frame (canonical)**: R_n after the central strike =
odd-board center residual on B_{n−1} (P) ⊕ live L-border (2(n−2) squares) ⊕ cross-attack
entanglement. The first factor is P; ALL the n-dependent difficulty lives in the
border/scar entanglement. Pure pairing cannot repair a border intrusion (τ-partner
off-board; transpose partner self-attacked) ⇒ any proof needs inexact repair + counting/
potential/scar control.

## CGT next steps (reviewer's priority list, cross-referenced to ours)

1. **Refutation-geometry experiment n=10..16**: extract the intruder's winning PV after c*
   and check border/Δ usage — tests whether the border mechanism explains the smaller-even
   failures. (= the winning-geometry note's discriminator (1); n=10/12 border-necessity
   already COMPUTED exhaustively; n=14/16 need engine-scale runs.)
2. **n=8 winning openings**: DONE 2026-07-03 — c* wins UNIQUELY at n=8; the monotone
   border-ratio story already carries the small-n quarantine.
3. **Attack D1 before the full Border Battle**: ρ-symmetric even-board position with exactly
   one live diagonal pair has G ≤ 1 — the right scale for inventing the "almost mirror"
   method. (= cgt-laws note Conjecture D1 + its concrete n=6-DAG check.)
   **DONE + REFUTED (2026-07-03, [almost-mirror](2026-07-03-almost-mirror-method.md)):
   D1 is FALSE at n = 10 (G = 3 at d = 1, empty scar included); the general one-defect
   pairing form fails already at 4 vertices
   ([defective involutions](2026-07-03-defective-involutions.md) §4.4). The redirect:
   extract the finite repair-oracle vocabulary (Theorem S2's conditional form is proven)
   + run the certificate-uniformity probe at n = 10/12.**
4. **Closed-Pairing S1**: supplied pairing = easy verification; FINDING one is the separate
   problem. (Proven 2026-07-03; the n=6/8 empirical non-existence already shows the static
   form is insufficient — the strategy-content upgrade S2 is the open piece.)
5. **Well-Covered Parity Law** as a collapse mechanism beyond rooks. (Proven 2026-07-03.)
6. **Certificate uniformity probe**: for even P-boards n ≤ 16, can diagonal strikes from
   reachable symmetric contexts be refuted by a small uniform rule/table? If yes,
   mirror-plus-exceptions certificates might be tiny. (NEW — not yet in our backlog;
   engine-scale, pairs with the certified-nimbers stage-1 Phase B probe.)
7. **Misère stays separate**: mirror proofs and heap-sum tricks do not transfer (mirror
   player makes the last move = loses misère). Misère A344227 is its own benchmark.

## Open-problem connections worth pursuing

1. A344227 as a geometric analogue of finite-octal nim-sequence questions (periodic?
   bounded? eventually nonzero? chaotic?).
2. Node-Kayles on structured families: PSPACE-complete in general, but is P/N for queen
   graphs decidable in poly(n)? Eventually periodic?
3. **Bounded-interaction sums**: no off-the-shelf CGT theorem exists for sums with ≤ k
   cross-interaction events and O(n) scars — the theorem shape the border battle needs.
4. **Pairing strategies with bounded defects**: impartial deletion games with a large paired
   region + thin exceptional set + bounded defect events — the general theory our even-n
   program is an instance of.
5. Proof/certificate complexity: do even-board P-verdicts admit polynomial-size
   mirror-plus-exceptions certificates?
6. Misère A344227 as a misère-quotient benchmark.

## Non-CGT isomorphisms (banked for the framing/abstract + future work)

1. **4-uniform hypergraph matching**: square (r,c) ↦ hyperedge {row r, col c, diag r−c,
   anti-diag r+c}; attack ⟺ intersection; the game = alternating greedy maximal matching.
   Rooks are the 2-uniform case (explains fixed length).
2. Adversarial construction of an independent dominating set (terminal positions = maximal
   independent sets); parameters α(G), i(G) relevant but the game value is subtler.
3. Well-covered graphs = fixed-length collapse criterion (the proven parity law).
4. Independence-complex topology: rooks collapse because the complex is pure; queens are
   hard because it is not; the mirror is an involution on the complex with the diagonals as
   obstruction set.
5. QBF/alternation: the solver proves a structured QBF; mirror-plus-exceptions = a
   compressed strategy certificate.
6. Transposition DAG = partial-order reduction; D4/iso canonicalization = symmetry
   reduction/quotient states (model checking).
7. Quantified exact-cover/adversarial set packing over the row/col/diag resource system.
8. Random sequential adsorption/jamming: random play = lattice parking process; ours is the
   adversarial perfect-play version — strategic jamming with boundary defects.
9. Cayley-graph view: torus = Z_n × Z_n with translation symmetry (hence the collapse);
   the flat board is a finite box whose boundary breaks it — the central strike exposes
   bulk core + boundary defect.
10. Dense W_k evaluators = truth tables of the Boolean function edge-bits(k-graph) ↦
    outcome/Grundy; connects to BDD/ZDD compression + circuit complexity of game outcomes.
11. **Defective graph involutions** (the generalization): for any graph automorphism
    involution ρ, copying works except where v ~ ρ(v); classify families with small
    obstruction sets and repairable exceptions.

**Reviewer's outside-CGT abstract** (banked for cross-community framing): the game is an
alternating greedy maximal-matching process on a structured 4-uniform hypergraph; the solver
collapses the interleaving tree into a symmetry-quotiented DAG; the theory identifies a 180°
involution whose only even-board obstruction is a thin diagonal set, making compact strategy
certificates a question about bounded defects of a near-perfect pairing.

## Publication-framing decisions adopted

- Main paper spine: prior work → new computed results + validation → Mirror-Obstruction
  Lemma → long-diagonal condition → n=18 geometry → solver summary → conjectures.
- Primer, CGT-laws, n=20 map, border diagnostics, certificates: companion notes/appendices.
- No subjective confidence percentages in the paper (structural rankings + falsifiable
  conjectures instead; percentages live in the research-log notes).
- Bottom-line claim wording: "We extend the known Non-Attacking Queens Game sequence
  computationally, prove a general mirror-obstruction theorem that sharply restricts
  even-board wins, and use the n=18 winning line to identify a border-tempo mechanism that
  explains where the mirror strategy fails and where a future theorem might live."

## Second review (2026-07-03, later): the Codex border overlap-graph results

Verdict: "a major clarification pass — it did not find a small closed-form repair rule,
but it identified the right invariant hierarchy." The useful invariant is no longer
parity/endpoint/center-gap/offset; it is **overlap structure among active scar lines and
their tau-mate lines**: `combined_asym(x,y) = |A(x,y) Δ tau(A(x,y))|` with `A(x,y)` the
union of the six active line masks.

**Strongest theorem-ready piece = Lemma O4** (active/mate incidence masks; asymmetry =
xor-support count). It is definition-level exact, not empirical — use it to REPLACE any
weaker "pairwise overlap might explain it" language.

**B6 is now split into three claims (canonical statuses, use everywhere):**

- **B6a** — exact incidence formula (O4). PROVEN by arithmetic.
- **B6b** — row/col-kind quotient preserves the asymmetry score. Verified n ≤ 100 (2×
  compression, zero score ambiguity); THE proof target (= closing Lemma O6).
- **B6c** — asymmetry minimizers form small structured candidate sets (mean ~14, ~21% of
  legal replies; exact-family buckets nearly tight, 78 extras all at score delta 4).
  Verified n ≤ 100; a candidate GENERATOR, not a universal repair theorem.

Do NOT state "B6 gives the repair move." State: "B6 gives a small arithmetic candidate
set for border repair moves; strategic correctness still requires row/residual context."

**Stop pursuing:** scalar orbit-count/cover/overlap summaries as theorem invariants
(score-exact on only 7% of rows); cap4/cap2/boolean bucket signatures (spread up to 736 —
metric scale is essential); any universal `y = f(x)` reply formula (O9: minimizer status
is row-relative by definition, so no local signature can decide it).

**O6 proof shape (the cleanest low-memory math target):** (1) six active line masks for
the pair (x,y); (2) their six tau-mates via O1; (3) express |combined_asym| via O4;
(4) transposition swaps row/col kinds and commutes with tau (= O5); (5) **the gap** —
show the row/col quotient identifies only patterns whose xor-incidence counts are
transpose-equivalent (never merges non-transpose patterns with different counts);
(6) conclude the quotient preserves |combined_asym| for all even n.

**Priority call adopted:** the solver-side telemetry test ("do solver-winning repair
replies lie among exact asymmetry minimizers? if not, what is their asymmetry rank?")
is now MORE important than extending the border tables past n=100. Telemetry fields per
the Codex schema (n, ply, pc, root/parent/opponent move, candidate reply, tau legality,
border state, combined_asym + rank, full-kind and row/col-quotient edge hashes, line-load
deltas, child value).

**Canonical model stack (current best):** mirror core + border occupancy ≤ 2 + exact
active/mate incidence hypergraph + row/col quotient score invariant + asymmetry-rank
candidate set + residual-state repair oracle.

**Paper phrasing (banked verbatim-adjacent):** "The border-repair geometry admits an
exact incidence description. For a row-to-column border exchange, the live scar is the
union of six line masks in the embedded core, and its tau-asymmetry is the xor support
between these active masks and their tau-mates. Exhaustive enumeration through n ≤ 100
shows that simple coordinate rules do not determine the asymmetry minimizers. However,
full line-kind overlap signatures determine the asymmetry score exactly, and quotienting
row and column kinds preserves the score while giving a nontrivial 2× compression. Thus
the border repair problem is not governed by a single offset formula; it is governed by
a small incidence/overlap structure plus row-context-dependent ranking."

**Next mathematical prize:** prove B6b (close O6), then solver evidence that low
asymmetry rank correlates with actual winning repair moves.
