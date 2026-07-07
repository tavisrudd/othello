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
  win breaks the conjectured pattern) + nimbers n = 14..16 (+17 when the running G(17)
  finishes). Blocked only on G(17); G(18) is a judgment call (see C3). OEIS A344227 extension
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
   **Odds: G(17) ~95% (running), G(18) ~50% on this box.**
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

### Sequencing recommendation

Month 1: P0, P1, C1, WP-1/WP-2 (+ C5 in idle cycles). Month 2: P2 (post-G(17)), C2, item 4,
WP-5. Month 3: P3 assembly, item 1 scouting → go/no-go, item 5 if WP queue is clear. Track K
stays a fixed small time-box throughout. Re-rank on any C1 surprise (a q=23 escape=0 flips
everything to counterexample characterization — which would itself be the best paper of the
lot).
