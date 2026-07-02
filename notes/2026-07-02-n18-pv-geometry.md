# n=18 winning-PV geometry — structural findings (2026-07-02)

Independent pure-arithmetic analysis (python, no solver) of the validated 15-move PV
`I9 K8 G10 J11 H3 M7 N16 E4 P6 D12 O13 F2 R5 L17 A14` from the n=18 first-player-win solve
([umbrella](handoffs/2026-06-23-queens-n18-umbrella.md)). Coordinates 0-indexed (col A=0, row 1=0);
I9 = (8,8). Companion to the [conjecture-theory note](2026-07-02-a344227-conjecture-theory.md)
(Theorem 3: even-n wins must strike a long diagonal).

## Verified facts

1. **The PV is a legal game re-verified independently**: all 15 placements mutually
   non-attacking and available when played; after the winner's 15th move the available set is
   exactly EMPTY (loser stuck with nothing on the board). A cheap third correctness check of
   the n=18 result, independent of both solver kernels.
2. **Deletion schedule** (avail after each move):
   `I9:-68→256, K8:-56→200, G10:-44→156, J11:-46→110, H3:-22→88, M7:-25→63, N16:-19→44,
   E4:-12→32, P6:-9→23, D12:-9→14, O13:-5→9, F2:-4→5, R5:-2→3, L17:-2→1, A14:-1→0`.
   I9's 68 is the board maximum (17+17+17+16+self — the two central main-diagonal squares are
   the most-forcing squares on any even board). Game length 15 (odd) ⇒ first player moves last.
3. **Diagonal membership**: exactly two PV squares are on long diagonals — **I9 (main, the
   winner's strike) and K8 (anti, the loser's first reply)**. All other 13 squares are off-diagonal.
4. **I9 is an embedded odd-board center**: (8,8) is the exact center of the 17×17 sub-board
   [0..16]², and the squares I9 deletes are precisely the self-mirroring lines of the point
   reflection τ(x) = (16,16) − x — i.e. the strike reproduces the ODD-board Lemma-2 structure
   (center + mirror) on the embedded 17×17, leaving a **32-square live L-border** (col R + row 18,
   minus the two I9-attacked squares) as the only τ-unpairable region.
5. **τ-mirror evidence, first reply only**: the winner's reply to K8 is G10 = τ(K8) exactly.
   Later winner replies are NOT τ-mirrors (τ-partners verified available in at least one case),
   so pure τ-mirroring is not the played strategy — but PV opponent moves are ordering
   artifacts (every reply in a won line loses; the engine reports its dynamic-order-first one),
   so this neither confirms nor refutes a τ-based strategy with border handling.
6. **Curios** (n=1 sample, likely noise): the winner's last two moves R5=(17,4), A14=(0,13) are
   an exact ρ-pair (180° of each other); the loser's early replies hug the diagonals
   (diag-dist 0,1,1,1 for K8,J11,M7,E4) while the winner's mid-game moves sit 2–5 off-diagonal.

## What this yields

- **Search guidance (even-n N-hunts, n=20/22...):** the winning opening was the most-forcing
  square, which the existing degree ordering already tries first — the top-4 central squares of
  any even board are all long-diagonal squares, so degree order and Theorem 3 agree at the head
  of the root queue. The theorem's added value is the TAIL: in a parallel `.any()` root hunt,
  never spend early cores on non-diagonal roots (they cannot be witnesses... they CAN win in
  principle — Theorem 3 forbids only diagonal-FREE lines — but every observed/predicted witness
  is diagonal, and diagonal roots are the only ones with a theory-backed win mechanism).
  Concretely: schedule roots diagonal-first, central-out.
- **Theorem candidate (the interesting one): the embedded-odd-center reduction.** For even n,
  playing the central main-diagonal square (n/2−1, n/2−1) yields "odd-board center residual on
  (n−1)×(n−1) ∪ live L-border of 2(n−2) squares". First player wins if he wins the *border
  battle*: τ-mirror the sub-board, handle border intrusions. Quick checks show no clean
  secondary pairing for the border (σ-transpose partners share an anti-diagonal; ρ maps the
  border off itself), so this is real work — but it reduces "why n=18?" to a question about a
  2(n−2)-square 1-D structure vs an O(n²) pairing, which plausibly flips with n (border grows
  linearly, paired region quadratically). A future theory session could attack: does the
  τ-mirror-with-border-repair strategy win for all even n ≥ some n₀?
- **Deferred experiments** (needs the box, cheap): (a) optimal game LENGTHS for n=10..16 —
  the outcome is exactly elimination-parity combat (odd length ⟺ first wins); do P-boards
  force even length everywhere or only at the root? (b) after I9 at n=18, compute G of the
  residual restricted to sub-board vs border interaction (engine sub-position solves) to test
  the border-battle framing. (c) the §5 experiments of the theory note.

## Method note

Analysis script: `pv18.py` (scratchpad, single file, ~O(n²) arithmetic). PV move semantics:
letter = column A..R (0..17), number−1 = row. Verified against the umbrella's I9=(8,8) reading.
