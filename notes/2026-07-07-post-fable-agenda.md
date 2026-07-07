# Post-Fable research agenda (2026-07-07)

Written by Fable 5 on its one available day, as the standing plan for Opus + Codex + user after
today. Part I = this repo. Part II = open problems elsewhere that this team could actually close,
with calibrated odds and explicit refusals. The ranking criterion throughout: **probability of a
finished, submittable artifact** × its value — not interestingness alone.

## Part I — repo follow-on, by track

### Track P: papers (Opus assembles, user reviews/submits)

- **P1. Sum-free + affine-cap paper** (working title: *Achievement games on sum-free sets and
  affine caps*). Kernels written by Fable (day plan F1); Opus: LaTeX assembly, related work from
  the O3/O4 scaffolds, consistency pass. Frame INSIDE the nofil genus (JCD 2022) — contributions
  are the theorems and the first infinite determined STS family, not a new game. Venue: J.
  Combin. Designs (natural referees: Huggan/Huntemann/Stevens) or Integers. **Ready to draft
  now; highest completion probability in the repo.**
- **P2. Queens Node-Kayles paper**: outcome n ≤ 18 (new, extends Jenrich; even-n first-player
  win breaks the conjectured pattern) + nimbers n = 14..17 (**G(17) = 2 VERIFIED 2026-07-07**
  — breaks odd→1, strengthening the paper). UNBLOCKED; G(18) is a judgment call (see C3). OEIS A344227 extension
  goes with it (user submits).
- **P3. Projective cap partial-results paper**: q-even theorem, frame reduction, total lemma,
  conic localization, dead-end map, ladder to q=19, PSPACE motivation via nofil. Assemble AFTER
  C1 (q=23 data) and the F3 audit verdict. This is publishable WITHOUT the odd-q theorem —
  do not hold it hostage to the open kernel.
- **P0 (immediate, user):** OEIS sum-free submission — draft is ready, nofil reference added.

### Track C: compute (Opus; box gates everything on the G(17) run finishing)

- **C1. q=23 (ON)/escape table** via the `esc` subtree mode (spec in the day plan; validated at
  q=17/19). THE falsification frontier: if any class hits escape=0 the conjecture is false and
  the program pivots to characterizing the counterexample. Extend to q=25, 27 as memory allows.
- **C2. STS(63) = `F₂⁶` sum-free = nofil on PG(5,2)** — the smallest open case of the
  2-transitive-STS conjecture (Part II, #2). Needs the canonical-solver treatment (naive memo
  blew 1.3 GB); the grid-cap arena pattern ports. One clean new data point with a paper hook.
- **C3. G(18) queens nimber**: expensive (weeks-scale risk). Decide with the user after G(17)
  lands; P2 does not require it.
- **C4. Arc-census cross-check**: with O1's tables, verify our odd-maximal-cap counts against
  the published complete-arc spectra where they overlap (translation: grid-maximal caps =
  arcs through the two direction points, complete relative to affine points). Any mismatch is
  either our bug or a new observation — both valuable.
- **C5. Nofil mod-6 sample at scale**: port the arena to general STS input, rerun their orders
  19/21/25 sampling 100× larger + orders 27/31/33. Cheap, directly answers a published open
  question's data side, and seeds Part II #1.

### Track L: Lean (Codex, its standing workstream)

WP-1 (frame⇄grid bridge) → WP-2 (q-even theorem in Lean — with WP-1 this is the first full
projective outcome theorem formalized) → WP-5 conic localization (new; statement vocabulary in
`GridCounting.lean`) → WP-3 per-q certificates. Stretch (see Part II #5): a verified
octal-periodicity certificate checker.

### Track K: the open kernel (strictly time-boxed, anyone)

(ON) via stability/polynomial method — continue ONLY in time-boxed sessions with written
outcomes. Falsification watch (C1) is the higher-expected-value use of the same curiosity.
Escalation rule for Opus: any claimed proof progress on route (B)/(ON) goes to the user before
it goes in a note as more than "attempt log".

### Standing guardrails for Opus sessions

The traps in this repo are calibration traps, not coding traps: computed ≠ proven (q ≤ 19 is
data, not a theorem); "appears novel" requires an actual search (the nofil revision is the
cautionary tale); solver "simplifications" that change node sets need the validation gates
(`solver_lineage_agrees`, n=12/n=14 distinct counts, escape-table exact match); and no
declaring floors/limits — that call is the user's (CLAUDE.md rule, repeatedly vindicated).

## Part II — open problems elsewhere this team could actually close

Selection filter: (i) success = finite computation + a modest lemma, both inside the team's
demonstrated toolkit (exact solvers at scale, canonicalization under group actions, pairing/
mirror proofs, Lean); (ii) a community that publishes such results; (iii) failure still yields
a citable negative or data. Odds are my calibrated guesses for "submittable result within a
few months of part-time effort".

1. **Nofil on the classical STS constructions (Bose v ≡ 3 mod 6, Skolem v ≡ 1 mod 6).**
   The Bose/Skolem systems are built from abelian groups — they carry translation-like
   automorphisms, which is exactly the substrate our P0/P0′ pairing lemmas + obstruction-census
   proofs consume (the sum-free Z_n proof IS this shape). Compute outcomes for the families at
   small orders (C5 tooling), hunt the mirror, prove the family theorem. This would give nofil
   its second/third infinite determined families and attack their published mod-6 question on
   the structured side. **Odds: ~60%. Best new-work bet outside the repo's own program.**
2. **Complete "nofil on 2-transitive STS".** The 2-transitive STS are exactly AG(n,3) and
   PG(n,2) (classical classification). Affine column: done (our theorem). Projective column:
   P for m ≤ 4 (ours), open beyond; pairing is genuinely obstructed (char-2 involutions have
   huge fixed spaces). C2 closes m=5 computationally (~90%); the all-m theorem is a real open
   problem with a beautiful endpoint statement. **Odds on the theorem: ~25–30%; on the m=5
   data point: ~90%.**
3. **A344227 completion (queens nimbers through 17/18)** — already ours; compute-gated.
   **Odds: G(17) DONE (= 2, verified 2026-07-07), G(18) ~50% on this box.**
4. **The "no-3-collinear permutation" objects from our own program.** Our odd maximal grid caps
   = complete permutation-arcs through two directions — as far as our searches show, an
   unstudied object class adjacent to both the no-three-in-line problem and complete-arc
   theory. Enumerate/classify for q ≤ 19 (data exists in our solver's reach), state the basic
   structure lemmas, submit sequences to OEIS + a note. Low glamour, high certainty, and it
   feeds P3. **Odds: ~80%.**
5. **First verified octal-game periodicity certificates (Lean, Codex).** A certificate checker
   for sparse-space octal-game G-sequences + formalized verification of a classical period
   (Dawson's chess 0.137, period 34) — first-of-kind formalization, ITP/CICM/CPP-shaped, and
   it dovetails with our unbounded-nimber interval-octal data (a verified negative-space
   around an open phenomenon). **Odds: ~65% with Codex owning it.**
6. **One targeted game-saturation gap.** The saturation-games literature (odd cycles, trees)
   leaves specific small open constants/gaps; our exact-solver + potential-function experience
   applies. Pick ONE after reading the current state (O4 summary); do not commit before
   scoping. **Odds: ~30–40%, scoping required.**

### Explicit refusals (where a weaker judgment says yes and burns the quarter)

Union-closed sets conjecture, Frankl-type problems, sunflower improvements, R(5,5), Schur
number S(7), van der Waerden W(2,7), anything Collatz-adjacent: not compute-shaped at this
box's scale, not lemma-shaped at this team's size, and the failure mode yields nothing
citable. The repo's own open kernel (ON)/PG(2,q) is already the team's one justified moonshot;
a second one is portfolio malpractice.

## Part III — beyond CGT (added 2026-07-07, second pass)

Part II stays inside the games program. The transferable assets are actually broader than
games: (a) exact solvers with canonicalization under group actions at the billion-node scale;
(b) finite-geometry/abelian-group fluency (GF(q), conics, arcs, caps, semilinear groups);
(c) pairing/obstruction proof craft; (d) Lean certificate checkers (Codex); (e) the
falsification-first methodology with validation gates. Below: where those close non-game
problems, same filter and odds discipline as Part II. None of these start before the Part II
month-1 items are moving.

1. **No-three-in-line on the torus / modular grids (caps in `Z_n × Z_n`, composite n).**
   For prime n this is literally our affine-cap object; the open territory is composite n,
   where the line structure changes and exact maximum/maximal classifications are known only
   for scattered n (Misiak–Stępień line of work). The grid-cap solver ports almost unchanged
   (line masks from the Z_n module structure instead of GF(q); the canon group shrinks to
   monomial-affine over Z_n). Deliverable: exact values + full classification for a swath of
   composite n, structure lemmas via the CRT decomposition, OEIS sequences, Discrete-Math-length
   note. Directly adjacent to Part II item 4 (permutation-arcs) — do them together. **Odds:
   ~70%. The best beyond-CGT starter; mostly Opus-executable against a spec.**
2. **Verified classification certificates for finite geometry (first-of-kind).** Classical
   computational classifications (complete arcs for small q, hyperovals through PG(2,32)) are
   trusted replays of decades-old search code. We now have both halves of the remedy: exact
   canonical forms with machine-checked invariance arguments (the F3-audit style) and Lean
   reply-book/coverage checkers (C9's format is 80% of a classification-certificate checker —
   coverage proof = "every extension of every node is handled"). Pick ONE modest published
   classification, regenerate it emitting an isomorph-rejection audit trail, verify the trail
   with an independent checker, publish artifact + method. Venue: ITP/CPP or JCD. **Odds: ~50%
   for one verified classification; the framework generalizing is upside, not the promise.**
3. **Segre's theorem in Lean (every oval in PG(2,q), q odd, is a conic).** Self-contained,
   celebrated, unformalized as far as we know (VERIFY with an actual search before claiming —
   nofil rule), and our `ProjectiveCap`/`GridCounting` vocabulary plus the C2/C9 scaffolds are
   already building the prerequisites (conics, arcs, tangent counts). The classical proof is
   elementary but convention-dense (cross-ratio products, the "lemma of tangents") — exactly
   the trap profile Codex handles well under a written decomposition. First formalization would
   anchor an ITP paper and a mathlib contribution, and it retroactively certifies the Segre
   inputs our feat-mode analysis leans on. **Odds: ~35–45%, months-scale, Codex-owned with
   user-reviewed statement conventions.**
4. **Maximal sum-free sets in finite abelian groups — census + structure (non-game).** The
   z5/multiplier-quotient solver machinery enumerates sum-free structure we never mined outside
   the game: exact counts/classifications of maximal (by inclusion) sum-free sets across small
   abelian groups, against the Green–Ruzsa-era structure theory (asymptotics known, exact small
   data sparse and scattered). Deliverable: census + the structure lemmas the data forces +
   OEIS. Cheap, reuses running code, seeds nothing risky. **Odds: ~65% for data + note;
   theorem upside modest.**
5. **The methods paper: auditable AI-assisted exact mathematics.** The n=18 solve, G(17)=2,
   and today's F3 audit are a documented pipeline — adversarial soundness audits, validation
   gates, negative-results ledger, delegation with exact-match gates — that the 2026 discourse
   on AI-assisted mathematics mostly lacks in concrete, replicable form. Write the case study
   around the repo's artifacts (the handoffs ARE the lab notebook). Venue: Experimental
   Mathematics / ICGA Journal / a solicited essay. User-fronted; Opus drafts from the handoffs.
   **Odds: ~50%, writing-bound not research-bound; do it alongside P2, not instead.**
6. **Scoped extremal-graph small cases (scouting only).** C4-free extremal numbers ex(n; C₄)
   and Zarankiewicz-type small cases sit on projective-plane structure we know well, and exact
   values for specific small n remain open in published tables; symmetry-guided exact search +
   SAT hybrid is the modern route. Like Part II item 6: read the current state FIRST, pick at
   most one target, go/no-go in one scouting session. **Odds: ~30–40% conditional on scoping;
   do not commit blind.**

### Part III refusals (same rule as Part II)

Max cap in AG(7,3) (search space beyond any single box; heavily attempted), hyperovals in
PG(2,64) (same), 2-(22,8,4) existence (decades of specialist search), the FLAT no-three-in-line
record past n≈46 (Flammenkamp-scale symmetric searches; only the torus/modular variant above is
box-shaped), full Othello variants. Each pattern-matches to our toolkit but fails the
"finishable on this box by this team" test — the failure mode is a quarter with no artifact.

### Part III sequencing

Ramp only as Part II month-1 lands: item 1 (torus no-3-in-line) first — shared tooling with
Part II item 4, one spec, Opus-executable. Item 3 (Segre) enters the Codex queue only after
WP-2 + the per-q certificates are stable, and starts with the formalization-prior-art search.
Item 5 (methods paper) rides with P2's writing window. Items 2 and 6 are explicitly
scout-then-decide. Standing rule unchanged: every new item gets its own novelty search before
any "new/first" claim is written down.

### Sequencing recommendation

Month 1: P0, P1, C1, WP-1/WP-2 (+ C5 in idle cycles). Month 2: P2 (post-G(17)), C2, item 4,
WP-5. Month 3: P3 assembly, item 1 scouting → go/no-go, item 5 if WP queue is clear. Track K
stays a fixed small time-box throughout. Re-rank on any C1 surprise (a q=23 escape=0 flips
everything to counterexample characterization — which would itself be the best paper of the
lot). Part III interleaves per its own sequencing note above — it never displaces a Part I/II
item that is already moving.
