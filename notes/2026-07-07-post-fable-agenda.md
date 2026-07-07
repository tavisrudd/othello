# Post-Fable research agenda (2026-07-07)

Written by Fable 5 on its one available day, as the standing plan for Opus + Codex + user after
today. Part I = this repo. Part II = open problems elsewhere that this team could actually close,
with calibrated odds and explicit refusals. The ranking criterion throughout: **probability of a
finished, submittable artifact** × its value — not interestingness alone.

## Codex execution overlay (2026-07-07)

This overlay records post-agenda gate status without rewriting Fable's ranked memo.

- **Label warning:** Track-C labels below are agenda-local. They are not the same namespace as
  `2026-07-07-codex-task-queue.md` (`C1..C11`).
- **q=23 escape table is C3-unblocked but compute-gated.** Codex queue C8 is reported
  (exact-canon check passed), and the C3 q=17/q=19 private-memo runs passed their gate; see
  `2026-07-07-codex-esc-gate-report.md` plus the persisted full logs
  `2026-07-07-escape-q17-full.log` and `2026-07-07-escape-q19-full.log`. Do not launch q=23 until
  the box policy/user timing allows a heavy run.
- **GF(49) hygiene can start.** Codex queue C6 is no longer blocked by a live q=19 process; the
  old-binary run is auditable through the persisted logs above. Keep any GF(49) verification runs
  light until the sum-free z5 run frees the box.
- **Certificate-standard items are downgraded for now.** C9 produced a Lean statement scaffold, but
  C10's P0a probe is a no-go for C11: mixed-value valtest buckets at n=8/n=10, n=12 valtest exceeds
  the 1 GB gate, and the 10 GB diagnostic reaches only n=18 depth 2. So items depending on "C9/C11
  reply-book checker as a working prototype" should be read as future work, not current
  infrastructure.
- **Immediate agenda work that is still safe while heavy compute is constrained:** GF(49) hygiene,
  P1 paper assembly/proof cleanup, P2 release-boundary/reproducibility planning, agenda Track-C4
  arc-census cross-check, and Lean WP-1/WP-2 statement/proof work. Avoid new heavy compute until
  the sum-free z5 run frees the box.
- **Track-C4 arc-census cross-check has a first pass:** see
  `2026-07-07-arc-census-cross-check.md`. No mismatch found; the key correction is that grid
  maximal caps are only affine-relative complete after adding the two direction points, so the
  literature spectra are a size gate until an infinity-point completeness filter plus full
  projective recanon exist.
- **P1 paper assembly moved:** all four `paper-sumfree-capgame/kernels/*.tex` slots now have
  first-pass content: cyclic mod-6 theorem proof with corrected Lemma 4, affine cap mirror proof,
  Nofil convention/corollaries, and conic-localization partial results plus the on-conic
  conjecture. Full TeX compile not run locally because `latexmk`/`pdflatex` are not installed in
  the current path.
- **P1 bibliography tightened:** `paper-sumfree-capgame/refs.bib` metadata was filled for the
  Nofil follow-up, Sieben hypergraph games, group-generation achievement games, Anti-Set,
  FunSearch, Diananda--Yap, Green--Ruzsa, and Node-Kayles nimber references. Remaining TODOs in
  the paper directory are just title/authors plus the missing local TeX compile.
- **P2 queens paper stale-G17 pass done:** `queens-n18-paper.md` now treats `G(17)=2` as verified
  (not in flight), records the odd-side failure of the 0/1 oscillation, and leaves only exact
  `G(18)` as the nimber computation still open.
- **P2 release boundary scoped:** see `2026-07-07-queens-release-boundary.md`. P2 should ship a
  small evidence capsule (frozen configs/logs/gates/OEIS source), while full solver packaging and
  performance history belong to the later JOSS/artifact item. Main housekeeping gap: fill the
  2026-07-07 `G(17)` verification log/config pointer in the nimber handoff.
- **A344227 OEIS package updated:** `2026-07-03-oeis-a344227-submission.md` now appends
  `a(14)..a(17)=0,1,0,2` in the DATA/b-file/credit/checklist, with companion upload file
  `b344227.txt` validated against the proposed DATA line. User submits; Codex does not.
- **Part III top-items research note added:** see `2026-07-07-part-iii-top-items-research.md`.
  Main correction: torus no-three-in-line needs a line-convention spec before code, item 12/Qubic
  are blocked on a real C11 checker path, and item 16 splits into an easy benchmark package plus a
  speculative certified-isomorph-rejection wedge.
- **Affine cap Lean theorem completed:** commit `965d660` proves the all-nontrivial finite affine
  cap-game theorem in `CapGame.Affine.initialP_of_nontrivial`, with polished `ι -> K` and
  `Fin n -> K` variants. The live Lean lane now moves to ProjectiveCap WP-1: prove the
  frame-to-grid validity bridge in `ProjectiveCap.FrameGridBridge`.

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

### E3. P2 — the queens Node-Kayles paper (rank #3)

**Why #3:** now UNBLOCKED (G(17)=2 verified 2026-07-07) and the results became strictly
better while we waited: both halves of the conjectured pattern are now broken — even→0 dies
at n=18 (first-player win), odd→1 dies at n=17 (G=2). A paper that merely extended a table
became a paper that refutes the standing structural guess about A344227. Ranks below P1 only
because assembly is heavier (methodology sections) and below 12 only on ceiling.

**Contents ranked:**
1. **Outcome n ≤ 18** — n=18 was genuinely open; extends Jenrich (arXiv:1312.5135); the even
   first-player win is the surprise. Two independent evaluator configs agreeing on verdict +
   winning move + 15-move PV at different node counts is the credibility core.
2. **Nimbers n = 14..17 (G = 0, 1, 0, 2)** — the A344227 extension (user submits the OEIS
   side). G(17)=2 breaking odd→1 turns the sequence from "resonant" to "wild", which is the
   interesting claim; the theory note's failed ~88% G=1 prediction is worth reporting as a
   calibration datum.
3. **Methodology** — the W_K dense-layer hierarchy, canonicalization stack, and the
   verification discipline (independent-oracle differential, int-sizing audit, Jenrich n ≤ 16
   reproduction). Enough to reproduce, not a solver tour; the JOSS artifact (item 9) is where
   the full engineering story lives — cross-cite instead of bloating this paper.

**Kill risks:** (i) *reproducibility skepticism* — mitigated by the two-config agreement and,
if item 12 moves fast enough, by shipping the n=18 reply-book certificate WITH the paper (the
ideal version: first solved-game paper whose headline claim is independently checkable).
Decide at assembly time whether to wait for C11 — recommendation: do NOT block on it; add the
certificate in revision if ready. (ii) *The G(18) question* — the paper is complete without
it; say "open" plainly. C3's weeks-scale gamble is a separate user decision and must not gate
submission. (iii) Venue fit — Integers (games section) or ICGA Journal; Jenrich lineage
suggests the former.

**Execution shape:** Opus assembles from the n=18 umbrella + nimber handoff (both are
publication-grade logs already); Fable-successor/user writes only the introduction's claims
paragraph and checks every "proven/computed/verified" verb. The OEIS b-file and the paper
must quote identical numbers from one generated source — no hand-copied tables.

**Unlocks:** the A344227 OEIS update (user); the n=18 certificate becomes item 12's flagship
instance; the methodology section seeds item 9 (JOSS) and item 14's case-study corpus.

### E4. C1 — the q=23 escape table (rank #4)

**Why #4 despite being "just compute":** it is the only item on the list with a live
possibility of CHANGING WHAT IS TRUE for the whole program, in either direction, and the
2026-07-06 correction made that possibility real. The old reading ("min-escape relaxes as q
grows") died: min-escape is erratic — 1, 7, 13, 13, 46, then **5 at q=17 with bad = 152 of
157**. The crux is a near-cancellation, not a comfortable margin. q=23 is the next
uncomputed rung where the cancellation could complete. Every session spent on route-(B)
invariants or Lean certificates is working ON a conjecture that q=23 could simply refute —
which is why the falsification data outranks all of Track K at current odds.

**Both outcomes are wins, asymmetrically:**
- *escape = 0 at some class:* PG(2,23) is N — the conjecture is FALSE, the program pivots to
  characterizing the counterexample, and that paper (a first-player win in a projective cap
  game, against the parity heuristic and the q ≤ 19 data) is the best publication the program
  could produce. Everything else on the list re-ranks the same day.
- *min-escape ≥ 1:* the ladder extends, the erratic-margin data sharpens (does the q=17 crash
  recur? deepen?), P3 gains its strongest table, and the odd-complete-arc-abundance coupling
  gets a real test (O1's census gives the arc counts to correlate against).

**Execution state (all gates in place):** the `esc` private-memo mode exists precisely for
this (the q=19 global-arena wall), C3 is finishing its q=17/q=19 exact-match validation gate
now, and the mode's class-index filter makes the campaign resumable class-by-class under the
box's memory ceiling. Remaining unknowns: per-class peak memo at q=23 (C3's report gives the
q=19 scaling datum; extrapolate before committing the box) and wall-clock (campaign-sized,
fine to spread across days as the z5 run allows).

**Kill risks:** (i) *memory* — a q=23 class blows the `--cap`; mitigation is built in (abort
+ report + resume), and a handful of walled classes still yields a partial table with the
min over solved classes as a conditional bound — report it as PARTIAL, never as the verdict.
(ii) *Silent wrongness* — the F3 audit + C8 exact-canon check exist for exactly this run;
run C8's q=17 witness recheck BEFORE trusting a q=23 surprise in either direction. A q=23
escape=0 claim goes through independent re-verification of that single class (fresh code
path, exact canon) before anyone says "counterexample."

**Unlocks:** P3's data spine; the (ON)/route-(B) go/no-go re-rank; item 11's census shares
the same runs.

### E5. Item 13 — the verified small-geometry database (rank #5)

**Why #5:** second-best compounding item after 12, and the two reinforce each other — but it
ranks below 12 because its adoption story is harder (databases win by content volume and
maintenance, not by a position paper) and its seed artifacts are one step further out (items
2/4/11 must exist first). What lifts it above the remaining bankers is asymmetric upside at
banker-like floor: even if NOBODY else ever contributes, v0 is still "our verified censuses,
queryable, citable" — the floor is item 11's value plus infrastructure credit.

**The wedge that makes it viable for a small team:** do NOT build LMFDB. Build one schema +
one validator: every row is (object, canonical form, generation trace, checker verdict), and
the DATABASE ACCEPTS ONLY ROWS ITS CHECKER VALIDATES. That inversion — the DB as a checker
with storage, rather than tables with provenance notes — is the novel claim, it is exactly
our C8/item-2 machinery productized, and it scales by letting OTHERS submit certified rows
rather than by us computing everything. v0 content: our affine cap spectra (11), permutation-
arcs (Part II 4), the arc cross-check (C4), sum-free censuses (4). One static site + a
downloadable validator is enough; no service infrastructure.

**Kill risks:** (i) *maintenance gravity* — the classic infrastructure trap; capped by the
static-site + validator shape (no uptime obligation) and by the standing rule that the DB
never blocks a paper (papers cite frozen snapshots). (ii) *Community indifference* — floor
case above; the O1 paywalled-gaps experience suggests real demand, but do not staff beyond
v0 until an external group asks for write access or cites a snapshot. (iii) *Verification
theater* — a checker that validates trivialities; the mutation-gate discipline (C11's) applies
to the DB validator too.

### E6. Item 1 (Part III) — torus/modular no-three-in-line (rank #6)

**Why #6:** the best ratio of certainty to novelty on the list — ~70% odds, and unlike the
bankers it opens genuinely uncharted territory (composite n, where the known results are
scattered single-n papers). It is the natural FIRST beyond-CGT move because it is a port,
not a build: grid-cap solver + Z_n line masks + the shrunken canon group, all machinery with
audited soundness arguments (F3) that transfer because the invariance proofs never used
field-ness — only the group action.

**The mathematical hook that makes it more than a census:** composite n forces the CRT
decomposition Z_n ≅ Z_p^a × Z_q^b into view — lines through composite moduli behave
differently per factor, and the maximum no-3-collinear sets should reflect the factor
structure (the prime case = our caps; prime powers ≠ primes; mixed moduli new). The
deliverable ladder: exact values + classifications for a swath of composite n (data, ~90%),
CRT-structure lemmas the data forces (~60%), a product/lifting theorem if one is there
(upside). Plus OEIS sequences either way.

**Kill risks:** (i) *prior-art surprise* — the Misiak–Stępień line plus scattered notes must
be swept BEFORE claiming any value is new (nofil rule; assign the search to the same session
that writes the spec). (ii) *combinatorial explosion at mixed moduli* — cap n by measured
class counts, publish the swath that finishes; a partial table of exact values is still the
best table in existence. (iii) Definitional forks (lines vs geodesics vs 3-term APs on the
torus) — pick the AP/modular-line convention the literature uses, state it in the note's
first section, and add the convention-equivalence check to the validation gates.

## Part III elaborations (same fashion; items 12, 13, 1 already covered as E2/E5/E6)

Rank within Part III after those three: **7 → 14 → 16 → 2 → 3**, then the tail in compact
form.

### E7. Item 7 — Lean-verified Qubic (Part III rank #4)

**Why here:** the cheapest high-visibility artifact on the whole list ONCE C11 exists — the
marginal work is a re-solve plus certificate emission for a game whose solution shape
(strategy book + coverage) was published in 1980. It is also item 12's adoption engine: a
standard with only our own queens instance looks self-serving; a standard whose second
instance certifies a 45-year-old celebrated result looks like infrastructure.

**Contents:** (1) modern re-solve of Qubic emitting the reply-book format (PN search;
small compute on this box); (2) checker validation, native + Lean; (3) the comparison
nobody has done — our machine-derived reply book vs Patashnik's hand-built 2,929-move book:
where they agree, where machine play is simpler, what his book's redundancy was. That
comparison section is what makes it a paper rather than a stunt.

**Kill risks:** (i) *first-move asymmetry* — Qubic is a first-player WIN, so the certificate
is an N-certificate (our reply-book kernel proves P-positions; the N-form is "one winning
move + P-certificate of the child" — the C9 datatype must support this from day one, note it
in the format spec NOW). (ii) Patashnik's book may be unrecoverable in machine form —
acceptable; the comparison degrades to statistics vs his paper's counts. (iii) State-space
size surprises — Qubic's tree with modern ordering is well inside this box; if not, weak-
solve one symmetry class of openings and say so.

### E8. Item 14 — soundness engineering for AI-assisted math (Part III rank #5)

**Why here:** the highest-variance item after 12 — its value is set by an external clock
(the 2026 AI-math moment) that we do not control, which caps its rank despite the ceiling.
The team's edge is unfakeable evidence: a repo where the protocols VISIBLY caught errors
(the false Lemma 4, the wrong "S2 dead" call, the GF(49) latent bug, the erratic-margin
correction) — most writing in this space has no such ledger.

**Contents ranked:** (1) the protocol paper — named, reusable mechanisms (adversarial audit
passes, exact-match validation gates, negative-result ledgers, delegation contracts with
report files) each illustrated by a real caught error; (2) the benchmark — research tasks
with machine-checkable gates harvested from the C-queue pattern, scored on soundness (did
the agent's claim survive the gate?) not helpfulness; (3) the essay claim: capability
evaluation without soundness evaluation is mismeasuring research AI.

**Kill risks:** (i) *genre saturation* — many AI-math manifestos; the differentiator is the
ledger of caught errors and the runnable benchmark; if reduced to opinion, drop it. (ii)
*Benchmark gaming/contamination* — publish gates + a holdout protocol, accept imperfection;
the protocol paper carries the load. (iii) User-facing: this one is ABOUT our workflow, so
the user decides voice, venue, and what internal material is publishable.

### E9. Item 16 — SAT/QBF benchmarks + certified isomorph rejection (Part III rank #6)

**Why here:** the banker half is nearly free and buys entry into the SAT community; the
opener half is the sharpest technical wedge on the beyond-CGT list. VeriPB-era proof logging
certifies propositional reasoning and (recently) symmetry BREAKING, but isomorph-rejection
SEARCH — canonical-form-based pruning of a search tree, nauty-style — still terminates in
"trust the canonicalizer." Our F3-audited canon + C8 exact-canon machinery is a worked
answer: log the anchor-image argument as a checkable claim per pruned branch.

**Contents:** (a) benchmark family: queens Node-Kayles, cap escape instances, sum-free games
as QBF/SAT with (n, q) scaling knobs and certificate-backed ground truth; submit to
QBFEVAL/SAT Competition. (b) the wedge paper: a certified-isomorph-rejection schema (what a
canonicalization must emit for a proof logger to check it) + implementation on one of our
censuses, aimed at SAT conference.

**Kill risks:** (i) benchmark ignored — cheap enough not to matter; ground-truth certificates
are the differentiator. (ii) The wedge may need VeriPB extensions (group-action reasoning
is exactly what current proof formats handle awkwardly) — if so, the paper becomes "here is
the gap + a proposed rule + a prototype," which the SAT community historically welcomes.
(iii) Encoding quality: naive game→QBF encodings are strawmen; use the published positional-
game encodings (Mayer-Eichberger–Saffidine lineage) as the baseline, not our own first cut.

### E10. Item 2 — verified classification certificates (Part III rank #7)

**Why here:** the load-bearing middle of the verification cluster — it feeds 13 (DB rows),
16(b) (the logged-proof schema), and 12 (same checker discipline), but unlike them it has a
self-contained first artifact: ONE published classification regenerated with an audit trail
and re-checked independently. Rank capped by scoping risk: the right first target must be
small enough to finish and known enough to matter.

**Target selection criteria (do this scoping in one session):** a classification (a) whose
original was computer-assisted with no published certificate, (b) reproducible on this box
in days, (c) with a community that will notice — candidates: complete arcs in PG(2,q) for
one small q, or the hyperoval classification at q=32 (Penttila–Royle) if sizing permits.
Deliverable: regenerated classification + audit trail + independent checker + a "certificate
or it didn't happen" methods section.

**Kill risks:** (i) *sizing surprise* — the original searches ran on 1990s hardware but with
domain-specific pruning we would have to re-derive and VERIFY (that is the actual work; do
not underestimate it). (ii) *A mismatch with the published result* — treat exactly like the
C8 protocol: independent re-verification of the disputed orbit before any claim in either
direction; a confirmed mismatch is a major finding handled with maximal care. (iii) Checker
scope creep — the checker validates the isomorph-rejection logic, not the domain math;
state the trust boundary explicitly.

### E11. Item 3 — Segre's theorem in Lean (Part III rank #8)

**Why here:** the prestige formalization target, ranked below the verification cluster
because it is months-scale with real convention risk and no partial-credit publication until
item 10's foundations exist (which ARE the partial credit — that is why 10 is a banker and
this is a bet).

**Decomposition (the part that decides success):** (1) foundations = item 10 (arcs, tangent
lines, conics over GF(q) in mathlib style); (2) the lemma of tangents (the convention-dense
core: products of tangent-direction ratios via the multiplicative structure of GF(q)*; every
sign/orientation convention is a trap — this is where a written expert decomposition earns
its keep); (3) the counting finish (q odd ⇒ the (q+1)-arc's tangent structure forces a
conic). Milestone rule: (2) alone, formalized, is announceable at a Lean community level
even if (3) stalls.

**Kill risks:** (i) *someone is already doing it* — the mandatory prior-art sweep includes
asking on the Lean Zulip, not just searching; (ii) *convention drift between (1) and (2)* —
freeze the geometry conventions in a design doc reviewed by the user before (2) starts;
(iii) Codex bandwidth — this enters the queue only after WP-2 and the C-queue clear; it is
the first thing to PAUSE if C11 or the falsification frontier needs Lean support.

### E12. Part III tail, compact (ranks #9–#15)

- **Item 9 (JOSS):** do it the month P2 ships — the release is P2's reproducibility story;
  risk is only the release-boundary review (user). Zero research risk; don't let it drift.
- **Item 10 (mathlib foundations):** start when Segre's prior-art sweep comes back clean;
  it is also the dependency of 17 and the floor under 3 — highest-priority tail item.
- **Item 11 (affine cap census):** ride the C1/q=23 runs — same enumeration, one extra
  reporting pass; publish with the C8 gate stamped in the methods section.
- **Item 4 (sum-free census):** idle-cycle work for the z5-era tooling; batch with 11's
  OEIS submissions.
- **Item 5 (methods case study):** fold INTO E8's protocol paper unless a solicited venue
  appears — one strong paper beats two thin ones.
- **Item 15 (Joyal):** gate on 12's format spec v1 — the semantics section should be written
  against a frozen format, not a moving one.
- **Item 17 (polynomial method):** strictly after 10; first milestone = formalized statement
  (not proof) of one Szőnyi–Weiner-style stability lemma, which already sharpens Track K.
- **Item 8 (queens domination) / item 6 (extremal scouting):** each gets ONE scouting
  session against current tables before any commitment; the scouting note is the deliverable
  either way.
- **Item 18 (commercial):** entirely user-paced; the only preparation worth doing now is
  keeping 12's checker demo runnable in minutes — that demo IS the pitch.

### Sequencing recommendation

Month 1: P0, P1, C1, WP-1/WP-2 (+ C5 in idle cycles). Month 2: P2 (post-G(17)), C2, item 4,
WP-5. Month 3: P3 assembly, item 1 scouting → go/no-go, item 5 if WP queue is clear. Track K
stays a fixed small time-box throughout. Re-rank on any C1 surprise (a q=23 escape=0 flips
everything to counterexample characterization — which would itself be the best paper of the
lot). Part III interleaves per its own sequencing note above — it never displaces a Part I/II
item that is already moving.
