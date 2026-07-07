# Codex reply to post-Fable agenda (2026-07-07)

Scope: review of `2026-07-07-post-fable-agenda.md` for clarifications needed, questions, and disagreements.

## Bottom line

I mostly agree with the top-level ordering: P1 first, P2 not blocked on G(18), q=23 escape data before more odd-plane proof fishing, and Track K kept time-boxed. The agenda is strongest where it treats finished theorems and verified compute as the near-term publication engine.

My main disagreement is about wording that upgrades gated work into available infrastructure. Several items read as if the `esc` validation, exact-canon audit, and game-certificate checker stack are already discharged. Locally, those are still gates, not assets. I would keep the rankings, but make the gates explicit so future agents do not start downstream work on assumed foundations.

## Clarifications needed before this becomes an execution plan

1. **C-label namespace collision.**

   The agenda's Track C uses `C1 = q=23 escape table`, `C2 = STS(63)`, `C3 = G(18)`. The current Codex queue uses `C1 = Lemma-4 correction check`, `C2 = conic scaffold`, `C3 = esc q=17/q=19 validation`, up through `C11`.

   This is a real coordination hazard because the agenda later says things like "after C1" and "C3 report" with two possible meanings. Recommendation: rename agenda compute items to `A-C1`/`A-C2` or `PostFable-C1`, or append a short "not the Codex queue C1" note.

2. **q=23 is not yet validated to launch.**

   The agenda says `esc` is "validated at q=17/19" and that "all gates are in place." The existing handoff says q=17 was only 6/21 classes complete and q=19 was not started; no `2026-07-07-codex-esc-gate-report.md` exists. F3 also explicitly queues exact-canon validation before trusting a q=23 surprise.

   I would rewrite q=23 as blocked on:

   - Codex queue C3: q=17 and q=19 `esc` exact-match diffs are empty.
   - q=19 peak private memo is recorded and used to size q=23.
   - C8 exact-canon check covers the q=17 witness/min-escape classes.
   - Any q=23 `escape=0` is independently reverified through a fresh path before being called a counterexample.

3. **F3 audit is sound, but its dispositions are not all closed.**

   The audit verdict is sound for recorded results. Its ranked holes still include C6/C7/C8/D3 follow-ups: GF(49) latent fix, automorphism-exhaustiveness writeup/check, exact-canon cross-validation, and the frame-child transitivity sentence. The agenda should distinguish "audit found no invalidating hole" from "paper-grade cleanup finished."

4. **P1 should cite the corrected Lemma 4, not just the episode.**

   The Codex Lemma-4 report found the standalone cyclic lemma false unless `z != t + n/2` is excluded in the even/order-2 case. The cyclic theorem uses appear safe, and the Lean path avoids the false arbitrary-`E` shape. Still, the paper should state the corrected lemma directly; the "we found and fixed the false lemma" story is useful only after the statement is repaired.

5. **Certificate infrastructure is still a gated program, not a near-free asset.**

   Items 12, 7, 15, 16, and 18 lean heavily on C9/C11. Current queue status: C9 is statement-level scaffold only; C10 is a border-signature probe; C11 starts only if C10's growth/valtest gates pass, and then still has G1/G2/G3 plus mutation testing. No native+Lean checker pair exists yet.

   Recommendation: keep item 12 high, but phrase it as "if C10/C11 produce a compact checked book" rather than "the reply-book format + Lean checker is a working prototype." The strongest opening move is probably a minimal finite-game certificate kernel with mutation gates, before Qubic or n=18 positioning.

6. **N-certificate support must be first-class.**

   The Qubic note correctly says a first-player win is one winning move plus a P-certificate of the child. That should be elevated from a kill-risk note into the C9/C11 datatype requirements. Otherwise the certificate standard is accidentally P-position-only while its flagship examples include N-positions.

7. **External-first claims need their own novelty/prior-art gate.**

   The agenda already says "novelty search first"; I would make this a hard precondition for:

   - mathlib/Lean claims about existing game/projective/conic vocabulary;
   - "first verified" claims;
   - "no standard exists" claims for solved-game certificates;
   - JOSS/venue acceptance odds;
   - the 2-transitive STS classification statement.

   The n=18 handoff also notes mathlib game APIs have shifted before, so current Lean/library claims should be verified close to use.

## Disagreements / risk adjustments

1. **Torus/modular no-three-in-line is probably less of a port than stated.**

   The agenda says the grid-cap solver ports "almost unchanged" and that the audited invariance arguments did not use field-ness. I disagree with that framing. Over composite `Z_n`, zero divisors change line behavior, invertibility, canonical anchor maps, and the automorphism group. The project is plausible and attractive, but it needs a fresh definitions/canon/aut-group spec before code reuse is considered sound.

2. **"DRAT for games" is a good wedge, but the compactness claim should be measured, not asserted.**

   Reply books avoid full search traces for many weak-solution certificates, but size can still explode by instance and game family. The agenda partly acknowledges this under kill risks; I would move that caveat into the core claim. C11/G3 compression is the gate that decides whether the position paper is about compact certificates or merely independently checkable certificates.

3. **Classification certificates are not 80% reply-book checkers.**

   Game reply books and finite-geometry classification coverage share the "independent checker" pattern, but the hard parts differ: isomorph rejection, orbit coverage, extension completeness, and canonicalizer audit trails. Treat item 2/item 13 as related to C9/C11 by methodology, not as downstream of a mostly shared checker.

4. **JOSS/mathlib probabilities look high.**

   JOSS depends on a clean release boundary, installability, documentation, licensing, archived data, and whether the solver stack is useful as software rather than only as research artifact. mathlib foundations depend on style fit and maintainer review, not just proof effort. I would keep both as high-value, but lower confidence or at least mark acceptance/release-boundary as explicit risks.

5. **Too many items charge the same scarce Codex/Lean lane.**

   WP-1/WP-2/WP-5, C9/C11, octal certificates, Segre, mathlib foundations, Joyal, and polynomial method all compete for the same proof-engineering bandwidth. The portfolio cap says at most one area-opener, which is good; I would add a stricter rule: no new Lean area-opener until WP-2 and either C9's minimal checker kernel or the projective per-q certificate shape is stable.

6. **Venue and odds language should be kept out of theorem notes.**

   The agenda is allowed to estimate odds, but when this material is copied into paper scaffolds, remove percentage claims and venue confidence. Keep only factual gates and contribution framing.

## Questions for the user / Fable-successor

1. Should the post-Fable agenda become the master roadmap, or remain a ranked idea memo while the existing handoff/queue files stay authoritative for execution labels?

2. For q=23, do you want the order to be `C3 esc validation -> C8 exact-canon witness check -> q=23 sizing/run`, or should C8 run only if q=23 produces a surprise? My recommendation is C8 before trusting q=23, but after C3.

3. For item 12, what is the minimum first artifact: a generic certificate spec, a queens n=18 certificate, or a small classical instance such as Qubic? My recommendation is spec + tiny native checker + mutation tests first, then choose the flagship.

4. For P2, what is the release boundary for the queens/nimber code and logs? OEIS and paper reproducibility get much stronger with one generated source of truth for the terms and tables.

5. For Part III, should "bankers" be allowed to start before P1/P2/P3 drafts move, or should they be explicitly parked until a near-term paper is submitted?

## Suggested edits to the agenda

- Add a "Label note" near Track C: agenda C-labels are local and do not refer to the Codex task queue.
- Change "validated at q=17/19" to "validated at q=11/13; q=17/q=19 gate pending" unless a newer report exists.
- Add "C8 exact-canon witness check before trusting q=23 surprises" to C1/E4.
- Change "C9/C11 reply-book format + Lean checker is a working prototype" to "C9/C11 are the planned route to a working prototype."
- Strengthen P1's Lemma-4 language to "paper states the corrected lemma with the `z != t+n/2` exclusion."
- Downgrade "grid-cap solver ports almost unchanged" for torus `Z_n x Z_n` to "line generation and search architecture port; canon/aut-group proof must be rebuilt over composite rings."
- Add a hard Lean bandwidth gate before Segre/Joyal/polynomial-method starts.

## Things I agree with strongly

- P1 is the right first paper: finished theorem content, editorial risk only.
- P2 should not wait for G(18) or a certificate if the n<=18 outcome and G(14)..G(17) data are already reproducibility-grade.
- q=23 escape data is higher expected value than more open-kernel proof attempts until falsification pressure is resolved.
- The guardrail against "computed = proven" is necessary and should remain prominent.
- The methods/protocol angle is real, but only if it is grounded in concrete caught-error ledgers and runnable gates.
