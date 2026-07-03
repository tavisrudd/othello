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
