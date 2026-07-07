# Central-child certificate extractor — design spec (Fable, 2026-07-07)

Executes W2-3 of the day plan; the build task is queued as C11 (gated on C10 = P0a probe GO).
Parent plan: `2026-07-04-n20-lucky-first-win-plan.md`. Calibration target: n=18 after I9
(known P-child); goal target: n=20 after J10. This spec is the soundness contract — the
builder may choose data structures freely but may NOT weaken any obligation below.

## Position model

Residual `R_n` after the central strike `c* = (n/2−1, n/2−1)`: live set = board minus `N[c*]`.
Core `S = [0..n−3]²` with `tau(x) = (n−3−x_r, n−3−x_c)`; border `L` = live cells of
`row n−1 ∪ col n−1` (two clique arms; NOTE arm-vs-arm diagonal attacks exist — never treat the
arms as independent cliques). Opponent moves first. tau facts the code may assume ONLY after
asserting them at startup for the concrete n: (i) no live core cell is tau-fixed (center dead);
(ii) `x` attacks `tau(x)` iff `x` is on a center line, all dead post-strike; (iii) point
reflection preserves the attack relation, so `N[tau(x)] ∩ S = tau(N[x] ∩ S)` and tau-closure of
the live core is preserved by an `(x, tau(x))` exchange.

## Certificate = reply book with node kinds

Every certified node carries a P-claim and a handler for EVERY legal opponent move (coverage is
checked as exact set equality against the live set, not against move classes).

1. **PairedCore node** — invariant: live core is tau-closed; any border subset `B` may be live.
   - Core move `x` with `tau(x)` live → reply `tau(x)` (legal by (i)–(iii); assert anyway).
     Child is again PairedCore (border shrinks by `N[x] ∪ N[tau(x)]`) → recurse.
   - Border move (either arm) → explicit reply from the exception table; child must be a
     certified node (any kind). No default.
   - Scar moves cannot occur here (all live core is paired); assert, don't assume.
   - **Core-empty / core-thin parity case (the plan's endgame trap):** when the live core is
     empty the node is a border-only position — evaluate EXACTLY inline (≤ 2 more moves since
     arms are cliques, but arm-vs-arm attacks change who gets the last move; enumerate, never
     use a parity formula). A PairedCore node with live border is NEVER certified by "mirror to
     the end"; the border handlers must exist at every depth.
2. **Exception node** (post border/scar event) — one of: explicit reply table (bounded depth,
   each child certified); **S1 leaf** (closed non-attacking pairing of the whole live set —
   Copying Lemma, pairing witness stored); **tau-symmetric leaf** (live set tau-closed +
   non-self-attacking pairs ⇒ S1 with the tau pairing; store as S1); **dense/solved leaf**
   (exact solver verdict on a small position; store the live set + verdict + node count).
3. **Unresolved leaf** — allowed in extractor output, NOT in a final certificate. Emit with the
   plan's fields (border state, scar incidence signature, tried replies + asymmetry ranks, best
   child live count, shallow refutation attempt).

## Soundness rules (non-negotiable)

- Signatures (arm occupancy, incidence multisets, v1 of the P0a probe) are ORGANIZING/ordering
  devices only. The certificate cache is keyed by the exact live set (or an exact canonical
  form); a signature never substitutes for a position in any soundness check.
- Candidate rankings (asymmetry, B6 minimizers, deletion counts, n=18 killers) generate and
  order replies only; every kept reply is certified by its child's certificate.
- The checker is a SEPARATE pass (independent code path, ideally a separate binary): walks the
  book, re-derives legal move sets from the position, verifies coverage equality, reply
  legality, invariant assertions, S1 pairing validity (pairwise non-attacking + covers live
  set), and solved-leaf claims by re-solving (leaves must be small enough to re-solve at check
  time — cap them; larger ones stay unresolved).
- Mutation gate: the checker must REJECT single-field corruptions (flip one reply, drop one
  table entry, break one pairing). Build this test in from day one.

## Validation gates (in order; a failed gate stops the line)

- **G1:** extractor + checker on central children n=6..12: verdict matches a direct memoized
  solve of the same residual (the P0a probe's `valtest` solver is the reference — share code).
- **G2:** mutation tests pass (checker rejects ≥ a few dozen randomized corruptions per n).
- **G3 (Phase 0 proper):** n=18 I9 — certificate accepted by the checker ⇒ child is P ⇒ first
  player wins n=18: agrees with the production result. Corroboration only: reply-book overlap
  with the production 15-move PV / extracted killers. Report compression stats (states handled
  by tau rule vs exception entries vs unresolved leaves) — these numbers decide the n=20 GO.

## Lean interface (C9 alignment)

Certificate datatype mirrors the node kinds: `pairedStep` (tau rule as a function on core
moves), `borderEntry`/`scarEntry` (explicit reply tables), `s1Leaf` (pairing witness),
`solvedLeaf` (deferred/trusted or sub-certificate). The coverage induction is exactly the
reply-book kernel lemma in `lean/NodeKayles/Certificate.lean`; `solvedLeaf` is the one piece
Lean cannot discharge cheaply — represent it so it can later be replaced by a sub-certificate
without changing the datatype.

## Explicitly out of scope

Root fanout (one root only: I9 / J10); false-twin compression (until proved); any n=20 run
before the n=18 Phase-0 GO; any RAM growth past the box constraint while the z5 run lives.
