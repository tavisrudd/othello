# Reflections — how the n=18 BuRR thread went off the rails (and how to not repeat it)

**Date**: 2026-06-24 · Context: the Queens n=18 work stream (sessions 2026-06-23--4 and
2026-06-24--5) concluded "single-box n=18 is infeasible — needs a cluster or a bigger-RAM box."
This session re-opened that and found it wrong: the design those sessions declared dead
(**DFS + an eviction-free BuRR store under the fast iso-dense kernel**) was never actually run.
This note records where the reasoning failed and the guardrails to prevent the same failure shape.

## Bottom line

It was **not** a verification failure. The verification discipline in those sessions was, if
anything, the strongest thing they did (sizing before building, an independent rules-only checker,
refusing to claim an uncertified verdict). The failure was **upstream of verification**: an
architectural fork chosen on a strawman benchmark, **ossified by the handoff into a "locked
decision," never re-measured, and then crowned with an "infeasible" floor** — the exact failure
mode the project's own anti-floor rule warns about.

## The decision chain (where it actually forked)

1. **The right idea was written down and then not taken.** The --4 review explicitly named the
   ideal — *"iso-dense's getK collapse + a BuRR-backed archive"* — then built something else.
2. **A strawman benchmark drove the fork.** BuRR was costed by benchmarking the *old* `iso-burr`
   (no getK/W_K collapse, slow graph-iso key), extrapolated from n=16, and judged "too slow."
   The actual candidate — the fast iso-dense kernel with a BuRR store swapped for the flat TT —
   was never built or measured. (This session's profile refuted the premise immediately: even the
   *old* iso-burr ran faster at n=18 than the flat-TT run it was supposedly losing to.)
3. **The handoff "locked" it.** The work plan carried a literal *"Decisions locked: value-only
   ply-windowed is the only mode that fits; membership (fp=44) is dead as a fix"* block. The
   "membership is dead" rested on a ~hundreds-of-GB estimate for the *full* distinct set at fp=44 —
   ignoring (a) the getK collapse, which means only the deep tail is ever stored, (b) the cap +
   eviction-free graceful degradation that gave n=16 near-1× re-expansion, and (c) the
   disk-segment escalation the append-only-segment + per-segment-Bloom store is *already* shaped
   for. A dismissed-on-estimate path got written down as **dead**, not **untested**.
4. **The next session inherited "locked" and never re-opened it.** --5 sized the value-only BFS
   driver, correctly found it needs the *full reachable set* (retrograde forfeits the forward α-β
   pruning that keeps you on the proof DAG — measured many-fold larger than the proof DAG), and
   killed it. The correct response was *"go back to membership-BuRR under DFS"* (keeps pruning;
   stores only the proof DAG). Instead it concluded *"both BuRR modes are dead,"* conflating "the
   value-only variant failed" with "BuRR failed," and pivoted to a completable sub-goal (certify
   n=18 *positions*) while declaring the empty board a hardware problem.
5. **The "infeasible" floor.** The session declared the single-box autonomous levers "exhausted."
   That judgment extrapolated a wall from the flat-TT thrash plus an estimate — never from a run of
   the actual untried design.

## Root causes, named

- **Strawman benchmark generalized.** "DFS+BuRR is too slow" came from a configuration nobody
  intended to ship, applied to one that was never measured.
- **Handoff ossification.** A tentative estimate became a "Decisions locked" block. The next
  session re-litigated nothing inside the locked frame and never questioned the frame itself.
- **Backtracking too shallow.** When the value-only fork died, the search for alternatives stopped
  at the handoff's boundary instead of returning to the fork point.
- **Premature floor.** "Infeasible / exhausted" was asserted without running the actual candidate —
  the precise thing CLAUDE.md forbids ("that judgment is the user's alone; a 'floor' is almost
  always an artifact of the measurement conditions or an untried lever"). There is even a documented
  precedent in that rule (the bogus "~36 M/s floor"); this repeated the pattern.
- **Certification conflation.** Certifying the *empty board* needs the full value table resident
  for the checker — a memory burden separate from the *search*. Letting "we must certify" + "the
  table is huge" stack onto "the search doesn't fit" made the wall look taller than the search
  problem alone is.
- **Autonomy steered to a completable sub-goal.** Given "complete a verifiable n=18 run, adapt as
  needed," the loop adapted toward what it *could* finish (certified positions) rather than loudly
  flagging the dismissed lever as the real open question.

## What those sessions got right (so we keep it)

The u8 verdict-bug fix, the representation migration, and especially the **independent
rules-only checker** were correct and load-bearing — the checker is exactly what the certified run
will reuse. The instinct to size before building, and the value-only-BFS infeasibility finding
itself, were correct. None of that was wasted.

## The general failure shape

It never *looked* like it was derailing. Every session was disciplined: clean commits, a real bug
fixed, tidy handoffs that pass review. The drift was entirely at the **premise** level, and a wrong
premise is invisible in per-session artifacts. The one move an autonomous loop cannot make for
itself — re-opening its own locked premise — is exactly the move that was needed, and nothing
surfaced it as needing a human. That is a **guardrail gap, not an attention gap**: the setup is
built to run with light supervision, so "not watching closely" is the normal mode; the system has
to make its own un-verified premises legible, or they compound silently.

## Guardrails to prevent the repeat

1. **Provenance tags on every strategic conclusion.** In handoffs, mark each load-bearing claim
   `measured` / `estimated` / `assumed`, with the config it was measured *on*. "membership-BuRR
   dead" was an estimate wearing a decision's clothes; a tag would have said so. A 30-second scan
   then surfaces "we declared X dead — on what, and was X ever run?"
2. **No "infeasible / floor / dead" without a measurement of the *actual* config.** Treat every
   such verdict as a **flagged re-open item**, never a settled decision. If the thing wasn't run,
   the verdict is a hypothesis, and the handoff must say so. (This is the anti-floor rule made
   operational at the handoff layer.)
3. **Don't generalize a benchmark past the thing benchmarked.** "Variant A is slow" never licenses
   "the family is slow." Name the exact config measured and the config being decided; if they
   differ, the decision is unsupported.
4. **When a fork dies, backtrack to the fork point, not to the handoff boundary.** Killing the
   value-only path should have returned to "membership-BuRR vs value-only," not advanced to a
   different sub-goal.
5. **Keep certifiability separate from searchability.** Size the search problem on its own terms
   first; fold in the certificate's resource cost as a separate line item, not a multiplier on the
   wall.
6. **A "locked decision" in a handoff must carry its escape hatch** — the assumption that, if
   false, re-opens it. ("Locked *given* membership ≈ X GB and no getK collapse" invites the check
   that breaks it.)

## How this session corrected it (evidence the fix works)

Re-opened the premise by measuring the actual untried design instead of trusting the inherited
estimate: confirmed both prior n=18 runs were flat-TT (the thrash), that BuRR-under-DFS was never
run at n=18, and that the store is eviction-free by construction. Built the real candidate — the
**fast iso-dense kernel (all levers) with the flat TT swapped for the eviction-free BuRR store**,
huge-paged like the TT — and gated it behind a size/overflow/fp audit and three rounds of
adversarial correctness review before any launch. The disk-segment escalation (the store is already
append-only segments + Blooms) removes the RAM ceiling the floor rested on. The floor was an untried
lever, exactly as the rule predicts.
