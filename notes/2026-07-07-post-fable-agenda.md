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

7. **First Lean-verified weak solution of a classic solved game (Qubic).** The C9/C11
   reply-book checker IS a game-solution certificate format; pointing it at a famous solved
   game is the high-visibility payoff. Qubic is the right first target — Patashnik's 1980
   solution is literally a strategy book + coverage check (the n20 plan's prior-art anchor),
   the game is impartial-adjacent but mainstream-recognizable, and a modern re-solve to emit
   our certificate format is small compute (PN search on this box). "Machine-checked: the
   first player wins 4×4×4 tic-tac-toe" is an ITP-paper headline with popular reach. **Odds:
   ~45–55% once C11's checker exists; near-zero marginal tooling.**
8. **Queens-graph domination open values (scouting).** γ(Q_n) and its diagonal/independent
   variants still have open exact values in published tables (Ostergård–Weakley lineage);
   our queens bitboard + canonicalization + exact-search stack is purpose-built for it, and
   any closed value is a citable unit with recreational-math visibility. Same protocol as
   item 6: one scouting session against the current tables, pick at most one value, go/no-go.
   Adjacent same-shape alternative if scouting fails: exact Davenport constants for specific
   small abelian groups (sum-free machinery reuse). **Odds: ~35–45% conditional on scoping.**

### Part III bankers (added on request: high-visibility AND P ≥ 80%)

9. **JOSS paper + artifact release of the solver stack** (~85%). The queens/nimber/grid-cap
   solvers are already validation-gated, documented in handoffs, and methodologically unusual
   (auditable exact search). Package + document + submit to the Journal of Open Source
   Software: near-certain acceptance for working, documented research software, a DOI every
   subsequent paper cites, and standing visibility in the computational-math tooling world.
   Opus-executable end to end; user approves the release boundary.
10. **mathlib foundations PR: finite projective/affine planes, arcs, conics** (~80–85%). The
   guaranteed floor under the Segre bet (item 3): land the vocabulary layer (PG(2,q)/AG(2,q),
   arcs, tangent counts, the conic basics the ProjectiveCap work already states privately) as
   mathlib contributions. mathlib PRs are high-visibility in formalization, Codex owns the
   lane, and the work is not wasted in any Segre outcome — it is the prerequisite either way.
11. **Affine complete-cap spectra census, q ≤ 19** (~80%). Our defect/feat/escape runs already
   enumerate the odd maximal grid caps; the one-step generalization (full complete-cap size
   spectra in AG(2,q), all parities, with counts up to equivalence) is certain compute on
   in-hand code, fills a census cell the projective-arc literature mostly skips (novelty
   search first, nofil rule), and ships as OEIS sequences + a short JCD/Ars Combinatoria-style
   census note that P3 then cites. Opus-executable against a spec; the exact-canon check (C8)
   is the soundness gate it inherits.

### Part III area-openers (added on request: NEW territory this team could define, not
existing problems to close — each seeded by an artifact already on this list)

12. **A universal certificate standard for solved games ("DRAT for games").** Solved-game
   claims (Checkers, Connect-4, Othello 2023, our n=18) are trust-our-code claims; SAT fixed
   the same credibility gap by standardizing DRAT + independent checkers, and that standard
   MADE the modern SAT-results ecosystem. Nobody has done it for game solutions. We are
   unusually placed: the C9/C11 reply-book format + Lean checker is a working prototype, and
   Qubic (item 7) + queens n=18 are the first two certified instances. Opening move: format
   spec + two reference checkers (fast native + Lean) + the two instances + a position paper
   ("solved games should ship certificates"). If it catches, every future solving claim cites
   the format. Visibility: SAT/ICGA/ITP triple audience.
13. **A verified small-geometry database (LMFDB-style, for finite geometry).** The
   finite-geometry literature runs on scattered tables in papers (the O1 census's paywalled
   gaps are the symptom). An open, queryable database of small-q objects — arcs, caps,
   spectra, automorphisms, completeness certificates — with every entry carrying an
   isomorph-rejection audit trail (item 2's machinery) would do for the field what LMFDB did
   for number theory, at a tractable scale. v0 = our own verified censuses (items 4, 11, the
   arc cross-check C4) behind one schema. Infrastructure prestige compounds; every census
   note thereafter is also a database release.
14. **Soundness engineering for AI-assisted mathematics (protocol + benchmark).** Item 5 is
   the case study; the area is the generalization: named, reusable protocols (adversarial
   audit passes, exact-match validation gates, negative-result ledgers, delegation contracts)
   plus a benchmark built from REAL research tasks with machine-checkable gates — this repo
   has dozens (the C-queue's report-file gates are exactly that shape). The 2026 discourse on
   AI mathematics is loud on capability and thin on auditability; the team that names the
   discipline and ships the benchmark gets cited by both sides. User-fronted; Fable-style
   audits are the method being packaged.

15. **Joyal's category of games in Lean/mathlib (strategies as morphisms).** The one
   category-theory item that passes the filter. Joyal (1977) observed that Conway games form
   a category — morphisms ARE winning strategies, composition is strategy pasting — the
   ancestor of compositional game theory. mathlib already has `SetTheory.Game` and surreals
   but (verify first) NOT the categorical structure. Formalizing the category (and as stretch,
   its monoidal/compact-closed structure with disjunctive sum as tensor and Sprague–Grundy as
   a monoidal functor to nimbers) is Codex-lane work sitting directly on our
   NodeKayles/Certificate development — a reply-book certificate IS a strategy-morphism made
   concrete, so item 12's format spec gets its semantics section for free (certificate
   composition = morphism composition; the coverage proof = totality of the strategy).
   Audience: CT + formalization + CGT simultaneously — rare triple. **Odds: ~45–55% for the
   category + functor; compact-closed stretch lower. Refusal boundary: no applied-CT framing
   papers without a formalized theorem attached — the artifact is mathlib code, not diagrams.**

16. **SAT/QBF: benchmark family + certified isomorph rejection.** Two-part item, both
   SAT-community-shaped. (a) ~85% banker: package our games as a structured QBF/SAT benchmark
   family with VERIFIED ground truth (queens Node-Kayles n ≤ 18, projective-cap escape
   instances, sum-free games — positional games are an established QBF application, and
   benchmark families with known answers + scaling knobs (n, q) are exactly what QBFEVAL/SAT
   Competition want; our certificates make the answers trustworthy, which most game
   benchmarks lack). (b) the opener: SAT's proof-logging wave (DRAT → VeriPB, certified
   symmetry breaking is an active frontier) has not reached isomorph-rejection SEARCH — our
   exact-canon audit trails (C8, item 2) are precisely the missing certificate; bridging our
   censuses to VeriPB-style logged proofs would land finite-geometry classification inside
   SAT's verification ecosystem. Seed: item 2 + the C8 exact-canon work.
17. **The finite-field polynomial method, formalized (the algebraic-geometry boundary).**
   Genuine scheme-theoretic algebraic geometry is outside this team's toolkit — refusal. The
   boundary that IS ours: the polynomial method over F_q (Rédei polynomials, Blokhuis/Szőnyi
   lacunary-polynomial machinery, Szőnyi–Weiner stability) — the workhorse of every modern
   finite-geometry bound including the (ON) kernel's own inputs, and unformalized. Calibration
   anchor: the Ellenberg–Gijswijt cap-set proof WAS formalized (Dahmen–Hölzl–Lewis, ITP 2019)
   — that is the existence proof that this genre lands at ITP, and the reason to verify
   prior art before every claim here. The Rédei/lacunary layer + one applied bound would be
   the natural sequel, extends items 3/10 on the same Codex lane, and directly serves Track K
   (a formalized Szőnyi–Weiner statement sharpens what the (ON) attempt may assume). **Odds:
   ~35–45%; enter only after item 10's foundations exist.**

18. **Commercial face: certified plans + agent verification harnesses.** Two transfers with
   real 2026 demand, both re-uses of what's already being built. (a) A reply-book certificate
   IS a machine-checkable *contingent plan* — a policy with a coverage proof over every
   adversary/environment move. That is what safety-critical autonomy, logistics, and
   reactive-synthesis-adjacent controller verification pay for: expensive planner emits,
   cheap independent checker validates, auditor re-runs the checker (the SAT/DRAT commercial
   pattern, applied to planning). Seed: C9/C11 + item 12's format — the demo is "certified
   adversarial plan, checked in milliseconds". (b) The audit-gate delegation protocol (exact-
   match validation gates, adversarial audit passes, report-file contracts — the C-queue
   mechanics) is a working QA harness for agentic AI, which enterprises currently lack and
   are actively buying; item 14's benchmark is its evidence base. Disposition: NOT a paper
   lane — user decides whether/how to commercialize (open-core protocol + consulting is the
   low-lift shape); the research items stand alone regardless.

These are portfolio-capped: at most ONE area-opener active at a time, entered only through
its already-listed seed artifact (12 ← items 7 + C9/C11; 13 ← items 2/4/11; 14 ← item 5;
15 ← the NodeKayles Lean development + item 12's format; 16 ← item 2/C8 + the certificates;
17 ← item 10's foundations), so a failed opening still leaves the seed's standalone value.

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

## Elaborations — highest-value items, one at a time (Fable, in rank order)

Overall rank by the agenda's own criterion (P × value): **P1 → item 12 → P2 → C1 → item 13 →
item 1 (torus)**. Elaborations added as written; each states contribution weight, kill risks,
and execution shape.

### E1. P1 — the sum-free + affine-cap paper (rank #1)

**Why it outranks everything:** it is the only item where the research is FINISHED and the
value locked in — two proven theorems plus a new object, needing only assembly. Every other
high-value item carries compute risk (C1; P2's G(18) call), adoption risk (12, 13), or proof
risk (Track K). P1's residual risk is editorial. A ~95% × high-value item gets finished first,
and it is the team's proof-of-credibility for the ambitious items behind it.

**Contents ranked by contribution weight:**

1. **The AG(n,q) cap-game theorem — P for all n, EVERY prime power q.** Stronger than it
   looks: the whole affine hierarchy settled with no compute in the proof — two mirrors split
   by characteristic (reflection σ_c + parity lemma, q odd; translation τ_v, fixed-point-free
   exactly because 2v = 0, char 2), unified by the shared parity lemma. Subsumes the q=3
   cap-set game conjecture, settles all dimensions. Referee-attractive: the char-2/odd
   dichotomy is EXPLAINED by the mechanism, not case-bashed.
2. **The sum-free Z_n outcome theorem, all six residues.** New impartial game, new sequence
   (no OEIS match to n=61), complete classification via obstruction counting (O2/O3 by n mod
   6; translation-mirror rescue at n≡0). The Lemma-4 episode goes IN the paper as a remark —
   we found our own false lemma, corrected it, machine-checked to n ≤ 120 (C1 report). It
   forecloses the exact hole a referee would hunt and displays the verification discipline.
3. **The nofil corollaries** — first infinite determined STS family (AG(n,3) as STS) + the
   PG(m,2)/mod-6 observation. The positioning contribution: answers a published question's
   structured side and frames everything inside an existing genus (JCD 2022), not a
   self-invented game.

**Kill risks + mitigations in place:** (i) the convention equivalence (nofil's conventions vs
ours) — a silent mismatch would invalidate the corollaries; that is why kernel (c) proves the
equivalence carefully, and it is the one section Opus must not touch beyond typesetting.
(ii) Novelty wording — the nofil prior-art revision is the cautionary tale; the abstract
claims the theorems and the family, never "a new game."

**Execution shape (~2 Opus sessions + one user pass):** F1 kernels = the load-bearing
sections, written; O3 scaffold compiles with `\input` slots; O4 related work pulled. Opus:
drop kernels into slots, write intro/discussion FROM the kernels, consistency pass under the
standing guardrails; user review → venue. Venue: J. Combin. Designs first (nofil framing
hands them natural referees: Huggan/Huntemann/Stevens); Integers fallback costs only
reformatting.

**Unlocks:** P0 ships WITH it (b-file ↔ paper cross-citation); P3 cites its framing; Part II
item 1 (Bose/Skolem) becomes "the sequel" with a warm referee pool.

### E2. Item 12 — the certificate standard for solved games (rank #2)

**Why #2:** highest ceiling on the list. P1 is the best bounded artifact; this is the best
*compounding* one — a standard, if adopted, gets cited by every subsequent solving claim in
the field, and we would own the reference implementation. It ranks above P2 because its seed
artifacts (C9/C11, Qubic) are being built anyway, so the marginal cost of the OPENING move is
one format spec + one position paper.

**The core claim that sells it:** solved-game results are today verified by trusting the
solver's authors — Checkers (2007), Othello (2023), our n=18 all share this gap. SAT had the
identical credibility problem and fixed it structurally: DRAT made "solved" mean "shipped a
proof an independent 500-line checker validates." Nothing plays that role for games, and the
technical obstacle (win certificates look exponential) is FALSE for the reply-book form: a
P-proof needs one reply per opponent move, not all replies — compactness is exactly what our
n=18/n=20 certificate program measures. That measured compression ratio becomes the position
paper's central evidence.

**What "opening the area" concretely means (in order):**
1. **Format spec v1** — the reply-book/coverage format from the C9 datatype: node kinds,
   terminal claims, composition (sub-certificates), and a versioned container. Written
   AGAINST two implemented checkers, never speculative.
2. **Two independent checkers** — fast native + Lean kernel (C9/C11 deliverables). The pair
   is the point: format bugs die when two implementations must agree.
3. **Two flagship instances** — Qubic (item 7; historic, popular, small) and queens n=18
   (ours, new, big — proves the format scales past toy games).
4. **The position paper** — "solved games should ship certificates": the trust gap, the
   format, the two instances, compression data, and an explicit call with a hosted validator.
   Venue: ICGA Journal for the community + an ITP/CPP tool paper for the checker.

**Kill risks:** (i) *compression fails at scale* — if n=18's certificate is not compellingly
smaller than the search trace, the standard claim weakens to "verifiable" without "compact";
still publishable, ceiling drops. This is measured by C11/G3 BEFORE any position paper is
written — the gate is built in. (ii) *Adoption inertia* — mitigated by picking instances
people already care about and by the validator being trivially runnable; but adoption is
genuinely out of our control, which is why this is an area-opener (option-priced), not a
banker. (iii) Scope creep toward partizan/scoring games in v1 — refuse; v1 is
outcome-certificates for finite two-player perfect-information games, extensions are v2.

**Unlocks:** item 15 supplies the semantics section (certificate composition = strategy-
morphism composition); item 16(a) benchmarks carry the certificates as ground truth; item 18's
"certified contingent plans" is this format sold to a different buyer.

### Sequencing recommendation

Month 1: P0, P1, C1, WP-1/WP-2 (+ C5 in idle cycles). Month 2: P2 (post-G(17)), C2, item 4,
WP-5. Month 3: P3 assembly, item 1 scouting → go/no-go, item 5 if WP queue is clear. Track K
stays a fixed small time-box throughout. Re-rank on any C1 surprise (a q=23 escape=0 flips
everything to counterexample characterization — which would itself be the best paper of the
lot). Part III interleaves per its own sequencing note above — it never displaces a Part I/II
item that is already moving.
