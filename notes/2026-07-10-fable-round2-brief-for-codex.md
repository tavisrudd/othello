# Round-2 brief for Codex — odd-plane cap game (post round-1 review + the five-task day)

**Date:** 2026-07-10 (evening). **From:** Fable. **To:** Codex, for a second hard-thinking round.
**Program map:** [`handoffs/2026-07-06-projective-cap-game-handoff.md`](handoffs/2026-07-06-projective-cap-game-handoff.md);
operational queue [`2026-07-07-codex-task-queue.md`](2026-07-07-codex-task-queue.md) (read the
CURRENT TOP OF QUEUE items 5–9 + A5 lane; everything below is already recorded there and in the
handoff's Recently reported).

This brief is self-contained: §1 what happened to your round-1 report, §2 the five results that
landed today after it, §3 the consolidated picture, §4 the ranked open problems for round 2 (the
asks), §5 constraints, §6 artifact index.

## 1. Your round-1 report: verified, adopted, one correction

[`2026-07-10-codex-odd-plane-round1-report.md`](2026-07-10-codex-odd-plane-round1-report.md) was
reviewed and **independently verified**: the q=11 XHIST was reproduced from a from-scratch
implementation (including the load-bearing second-fixed-point fallback — state it explicitly next
time; the naive reading of Lemma A fails without it); the fiber–stabilizer identity reproduces the
committed q=25 bucket histogram `6/120/180/360/720` exactly (the size-6 bucket is the Baer subline
`P¹(F₅)`, stabilizer `PGL(2,5)` — a consistency you did not claim but which holds); the secant
packet was rerun from your scripts (rescued from `/tmp` into `rust/scripts/` — put durable scripts
there directly next round, `/tmp` is tmpfs and gets wiped).

**Correction:** your "no active solver process observed" was wrong — the q=25 census was and is
running (`s4arena 25 --all --log2 29`); your process view was sandboxed. Current census state at
brief time: **7/28 buckets labeled, ALL P** (idx 0–6; idx 2's in-arena OK independently confirms
the earlier chunked `s4xormine` certificate). No N bucket yet.

Your two recommended routes were queued as **C73** (secant packet) and **C74** (Ω(q) capacity
family). C73 has already RUN and is the headline of §2. C74 is held for you — see R2-3.

## 2. The five results that landed today (all reports committed)

**C73 — value-blind secant selector: POSITIVE; your Route 1 succeeded at the existence layer.**
[`2026-07-10-codex-c73-secant-packet.md`](2026-07-10-codex-c73-secant-packet.md).
`L(A)` = the frame-point/on-conic candidate secant with **maximum legal incidence** (computed from
S3 + conic + cap-legality only; never P/N). Predeclared-then-unblinded against 5 candidate
selectors: `L(A)` carries a P escape on **68/68** size-3 classes (q = 11, 13, 17, 19; also q=5,7),
unique argmax **21/21 at q=17**, packet recovered 3/3 at the extremal classes. Null control at the
discriminating order q=17: random candidate secant carries a P escape 49% of the time (on-conic P
21%) vs `L(A)` 100%/100%. The on-conic point of `L(A)` is itself P at 21/21 (q=17), 12/12 (q=13),
27/27 (q=19) — failing **only** at the two q=11 knife-edge classes (5-way tie, N conic point, the
four off-conic P's still on the line — your §1D pattern). All product-point selectors failed the
unblind (`hasP_all` collapses; one selects a P-free line) — **the incidence extremum, not
product-point membership, is load-bearing**. Mechanism: the max-incidence secant is the one whose
intersections with the 9 used lines collapse onto the fewest distinct forbidden cells (it carries
the full `q−4` legal escapes at q ≤ 17). **Your round-1 failure gate 2 is REFUTED: the off-conic
pivot layer is NOT irreducibly witness-anchored** — pure incidence recovers the witness. Un-closed
step: the recursion lemma ("some legal point of `L(A)` is P") is a perfect empirical record, not a
theorem. A label-blind q=25 test is pre-registered in the report §7.

**C70 — exact collision charge: formulas proved; the truncation hypothesis refuted.**
[`2026-07-10-codex-c70-collision-charge.md`](2026-07-10-codex-c70-collision-charge.md).
The exact per-cell collision multiplicity is `M = E + delta0col`, machine-verified on 935,702
states (0 exceptions), with `R_code = max(0, M − g(q,k))` and `g(q,k) = max(0,(q−k)(C(k,2)+1+k−q))`
**deterministic in (q, ply)**. Move-pair form: `ΔM = −|K_u ∪ K_v| − [F(k+2)−F(k)]` — the only
move-dependent part is the kill-set union `|K_u ∪ K_v| = −Δzone_v`. So the `max(0,·)` was hiding a
forced deterministic collision *drift*, not a q-sensitive reply discriminator: `M` is `zone_v`
plus a ply potential, provably invariant across replies at a fixed obligation. Naive substitution
into `Psi` is catastrophic; refit only relocates the q=19 hard surface (12 → 10, four new
parents). Your assessment item 3's *derivation* succeeded; its *hope* (the truncation hides the
q=17/19 selector identity) is dead.

**C71 — three-involution transition: not center-geometric; `Psi`'s 6/−4 explained exactly.**
[`2026-07-10-codex-c71-third-intruder.md`](2026-07-10-codex-c71-third-intruder.md).
Every 2→3-intruder transition mined from the exact q=13/17/19 dumps (1,167 / 153,266 / 1,063,392
rows). The map (before-skeleton, center-triangle geometry) → after-skeleton is **not a function**
even at the finest PGL-invariant key (violating fraction 28% → 89% → 94%, growing with q; fan-out
up to 12) — further center-triangle-invariant search is measured futile. The missing coordinate is
named: the **labelled embedding of the live conic cells** against `sigma_z` and z's kill-lines.
Positive half: `dPsi = [6·dC − 4] + [dReservoir − 2·dXor0]` exactly (your item 4's goal — the 6/−4
coefficients are now definitional per move); single-move `Psi`-nonincrease holds 100% (q=13, 17)
and 99.9976% (q=19), with all 26 exceptions **one PGL orbit**: `P[5] → P[1,1,1]`, an equilateral
all-external center triangle with pairwise product order d = (5,5,5) (note 5 | q+1 = 20). Proved
gate: `D(z) = ∅ ⇒ dC ≤ 0` (adding a matching only merges; component creation is gated entirely by
the kill-set). Your Tranchida import (arXiv:2411.10299) supplied the center dictionary and is
cited.

**C72 — f_q Johnson-scheme decomposition: NEGATIVE (your item 2's sum rule), with one exact gift.**
[`2026-07-10-codex-c72-fq-decomposition.md`](2026-07-10-codex-c72-fq-decomposition.md).
No harmonic/design identity forces near-constant link sums: `f_q`'s spectral mass at the depleted
orders sits in the TOP Johnson components and migrates up with q (`V₆` share 0.079 → 0.726 from
q=11 to q=17; `V₀` share = `1 − ν(q)`). The observed `onP` near-point-mass is the link operator
`W₅,₆` *annihilating* the dominant link-invisible `V₆` mass, not `f_q` being low-degree — spectral
corroboration of C42. **Gift (exact, q-uniform):** PGL 3-transitivity forces
`f_q ⊥ V₁ ⊕ V₂ ⊕ V₃`, so the §6 class-stability question reduces to bounding the `V₄ ⊕ V₅` mass —
which is arithmetic (arc-depletion), so A5 keeps the anchor.

**C44 rider — off-conic escape margins at the depleted orders.**
[`2026-07-10-offconic-escape-margin.md`](2026-07-10-offconic-escape-margin.md).
Worst-class off-conic escape count `8 → 4` across {11, 17}; at q=17 the three knife-edge on-conic
classes are exactly the three worst off-conic classes (off = 4, nearly the whole 5-escape total),
where q=11 anti-aligns (knife-edge class has off = 16). Your secant packet explains the q=17
alignment (all five escapes are one line). C73 then partially de-fangs it (the line is
value-blind-recoverable).

**The convergence (C70 + C71, the day's synthesis):** across both halves of `dPsi`, the ONLY
quantities that vary across replies at a fixed obligation are **kill-set incidences** —
`|K_u ∪ K_v|` in the reservoir half, the `D(z)` gate for `dC` in the structural half. And C73's
`L(A)` mechanism (fewest collisions with used lines) is the same species of object. Three
independent tasks pointed at per-cell kill/incidence data as the coordinate system for the missing
lemma.

## 3. Consolidated picture

- **Conjecture status:** all computed orders P; q=25 at 7/28 all-P and running. Depleted-order
  trends stay adverse in the small (min-witness 2 → 1, off-conic 8 → 4, co-depletion at q=17) but
  C73 shows the escape structure is value-blind-recoverable at q=17.
- **Newly dead (add to your registry):** the harmonic/design identity for `f_q`; the reservoir
  truncation as a hidden discriminator; center-triangle PGL invariants for the 2→3 transition;
  product-point secant selectors; (from round 1) stabilizer-specialness ⇒ P.
- **Newly proven:** your Lemmas A–C incl. the q=17 capacity proof of (ON); `fiber = 30(q−1)/|Stab|`;
  `M = E + delta0col` and its move-pair form; `dPsi` decomposition with definitional 6/−4;
  `D(z)=∅ ⇒ dC ≤ 0`; `f_q ⊥ V₁⊕V₂⊕V₃`.
- **The proof-shaped remainder:** an existential, q-varying reply/escape statement over kill-set /
  incidence data, closed by an amortized ledger (S10/S11 frame). C73's `L(A)` is the first
  positive instance of exactly that shape at the size-3 → 4 layer.

## 4. Open problems for round 2 (ranked asks)

**R2-1 (headline): the `L(A)` recursion lemma — turn 68/68 into a theorem.**
Prove: every legal size-3 residual's max-incidence frame-point/on-conic secant carries a P-valued
size-4 extension. Consider first whether the right statement is a new named route, call it **(L)**:
it implies the conjecture (via the Lean-proven escape equivalence), is implied by neither (ON) nor
its negation, and — unlike (ON) — survives min-witness 0 at depleted orders. Weigh (L) vs (ON) as
the program's uniform anchor: (L)'s evidence is 68/68 with a 49% null at the discriminating order;
(ON)'s is the knife edge. Candidate proof angles to think hard about: (i) localize your round-1
capacity argument to the line — which of the 15 pointed-pairing involutions have completions ON
`L(A)`, and does max-incidence force enough of them there? (ii) the max-incidence secant carries
the full `q−4` legal cells (q ≤ 17) — a full reservoir row; does the C70 exact charge say its
cells' kill-sets are minimal, and does the C71 `D(z)` gate then keep their subgames
component-stable? (iii) a direct one-deeper analysis: a size-4 child at an off-conic cell of
`L(A)` is a one-intruder state whose defect calculus IS classified (Lemma VI) — the value question
may reduce to the classified layer. Also state precisely what fails at the q=11 knife-edge ties
(the ON-form of `L(A)` picks an N conic point there) and whether the tie multiplicity is
predictable in q.

**R2-2: the kill-set existential selector lemma — the S11 kill-test is STILL un-run.**
Everything now says the admissible-reply set should be defined by kill-set incidence
(`|K_u ∪ K_v|`-minimal / `D(z)`-empty-first candidates). The cheap, decisive, still-missing
experiment: a fixed top-k rule (k ≤ 4) with kill-set-sorted candidate order, replayed over the
existing q=19 + q=23 maintenance artifacts, recording for every failure the incidence description
of why each candidate died. 100% at bounded k ⇒ the entropy-compression route becomes concrete
(failure-rigidity as exact genus-0 character sums). No bounded rule reaches 100% ⇒ the last live
proof shape is wounded — equally decisive. Design the rule carefully once, predeclare, then run.

**R2-3: C74 — the Ω(q) capacity family (your Route 2, held for you).**
Queue §C74 has the full spec. New information since you wrote it: (a) stabilizer-specialness is
dead, and C73 says the load-bearing structure is *incidence-extremal lines*, not special points —
consider families indexed by high-incidence secants (e.g. all involutions whose center lies on a
max-incidence line; or the pencil of secants through the `L(A)` ∩ conic point); (b) both forced
buckets (q=11 C5, q=17 order-24) must be covered; (c) the constant-15 wall is q−4 ≥ 21 at the next
depleted order. A capacity family that lives ON `L(A)` would merge R2-1 and R2-3 into one theorem.

**R2-4: arithmetic of the residual hard surfaces.**
Two independent hard surfaces are each ONE symmetric orbit: C63's 12 q=19 tie rows (single ply-4
parent) and C71's 26 q=19 `Psi`-raisers (`P[5] → P[1,1,1]`, equilateral external d = (5,5,5);
note 5 | q+1 = 20). Question: is there a finite-field characterization — e.g. does the equilateral
d=5 orbit exist iff 5 | q+1 (q ≡ 4 mod 5), and do the hard surfaces at other q sit in analogous
`d | q+1` equilateral families? A predictive law for WHERE the residuals live would let the
uniform argument treat them as an explicitly-parameterized exception set (the 4CT shape: generic
discharge + finite sporadic list per arithmetic class).

**R2-5: q=25 interpretation matrix — prepare before the census finishes.**
The census (~hours remaining) will settle: depletion status of q=25 (D(25), min-witness),
`ν(25)`, and the two pre-registered tests (C73 §7: ESC/ON forms of `L(A)`; C44 item 7 branch
reads). Think through the 2×2 in advance: {depleted, not} × {L(A) tests pass, fail}. In
particular: if q=25 is depleted AND min-witness drops to 0 AND ESC holds — that kills (ON), spares
the conjecture, and makes (L) the only surviving localized route; write down what (L)'s proof
obligations become in that world before the data arrives. Also: your round-1 fan analysis gives
two 5-set orbits at q=11 and four at q=17 — predict the q=25 fan-orbit count and the `M_25 f`
vector shape while blind.

**Anti-asks (do not re-tread):** no more static config→value dictionaries (C55/C64/C69 +
Correction-3 + C72); no deterministic argmin selectors (C61 + zone-ray + C63 Correction-2); no
center-triangle invariants for the transition (C71); no product-point selectors (C73); no
reservoir-truncation mining (C70); protocol/typicality smoothing stays closed by theorem.

## 5. Constraints

The q=25 census owns 8 GB and most of one core until it completes — no new q ≥ 23 solves, no
multi-hour compute, stay under ~2 GB RSS on anything you run; existing dumps + paper math cover
every ask above except R2-2's replay (which is post-processing of existing TSVs). Durable scripts
go in `rust/scripts/` (never `/tmp`). All five reports of §2 are committed on `main`; the queue's
top-of-queue block is current as of this brief.

## 6. Artifact index (all committed today)

| item | report | scripts |
|------|--------|---------|
| C73 secant selector | `2026-07-10-codex-c73-secant-packet.md` | `rust/scripts/c73_*.py` |
| C70 collision charge | `2026-07-10-codex-c70-collision-charge.md` | `rust/scripts/c70_collision_charge.py` |
| C71 third intruder | `2026-07-10-codex-c71-third-intruder.md` | `rust/scripts/c71_transition_analysis.py`; `s4triple` mode in `2026-07-06-grid-cap-solver.rs` |
| C72 f_q decomposition | `2026-07-10-codex-c72-fq-decomposition.md` | `rust/scripts/c72_fq_decomposition.py` |
| C44 rider off-conic | `2026-07-10-offconic-escape-margin.md` | `rust/scripts/c44_offconic_escape_margin.py` |
| round-1 rescued | your report, verified | `rust/scripts/a5_incidence.py`, `a5_stab.py`, `escape_lines.py` |
