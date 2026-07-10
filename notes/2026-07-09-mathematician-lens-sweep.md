# Six-lens ideation sweep: what Tao, Erdős, Conway, Alon, Segre, and Lovász would each bring to the odd-plane kernel

Date: 2026-07-09.

Purpose: a disciplined ideation exercise over the main open problem — prove `PG(2,q)` is P for
every odd `q` — channeling six mathematicians' documented styles. Every attack below is checked
against the program's negatives (handoff §What Is Dead; the Hall/pairing constant-slack death at
the `q=23..25` frontier; C35's conic⊕zone non-decomposition; the failed polarity identities; the
exhaustively mined mirror families; the refuted cross-`q` finite-type collapse and C42 census
propagation) and deduped against the two existing sweeps
([spinoff bridges A–F + New Candidate Mappings](handoffs/2026-07-09-spinoff-bridges-duals-isomorphisms.md))
and the queued C55–C60 tasks
([codex queue priority section](2026-07-07-codex-task-queue.md)).

Ground truth engaged throughout: frame reduction → residual grid → size-3 escape
(`q²−9q+21` children) → conic localization / (ON) → intrusion calculus (Lemmas V–VII of the
[NK involution note](2026-07-08-nk-involution-residual.md): kill-set law, dihedral `C_{2d}`
spectrum on the divisor lattice of `q±1`, even-cycle Grundy-0, value in the Dawson defect
skeleton) → the open core: a zero-xor maintenance/termination invariant for steering, plus the
unexplained arc-depleted-orders dichotomy (the 119 shared integral configurations flip N at
`q ∈ {11,17}`, P at `{13,19}`).

Rules observed: no fabricated results ([VERIFY] tags where a real theorem is invoked but not
pinned); every attack carries a kill-test the existing solvers/dumps can run cheaply; speculation
is labeled.

---

## 1. Terence Tao

**(a) Toolkit/style.** Quantitative structure-vs-randomness dichotomies; transference; "cheap"
asymptotic versions first; moment/concentration heuristics upgraded to exact identities; relentless
bookkeeping of where each error term dies.

The program has already run one Tao-style instrument (the §6 witness-count first-moment heuristic
in the [falsification map](2026-07-09-odd-plane-falsification-map.md)); these attacks are the next
moves in that idiom, not a rerun.

### (b) Attacks

**T1 — Inverted selector search scored by exact character sums.** The steering lane's stated
blocker is that the mined zero-xor maintenance witnesses are *value-defined, not geometrically
definable* (queue sixth-pass method note). The queue already records the payoff if that changes:
every object in the conic residual is genus 0, so quadratic-character counts of a *geometric*
selector family are exact — no Weil loss, no `q ≥ q₀` gap. Tao would invert the search direction:
instead of mining values and hoping a geometric rule emerges, enumerate a library of
algebraically natural selector families up front (candidates: internal intruders on the polar
line of the last opponent cell; cells whose two tangent parameters bracket the surviving defect
path; cells minimizing `live_on` subject to a quadratic-character sign condition on the
cross-ratio with the burned directions; the unique conic-killer pattern generalizing the q=17
score-9 guard) and *score each family against the mined witness corpora* (the q=23 zero-xor rows
across all 22 buckets, the q=19 steering rows, the q=17 score-9 guards). Constraint check: this
is not a counting argument (no constant-factor slack to die at the frontier — existence becomes
an exact count once the family is fixed), not a static snapshot invariant (the selector is a
reply *rule*, evaluated dynamically), and the failed polarity identities only kill the one
polar-line candidate, which stays in the library as a control. *Kill-test:* a scoring script over
existing `s4xormine`/steering TSVs — for each family, the fraction of obligations where its
selected cell is one of the verified maintainable zero-xor P replies. Hours; no new solves.
*Leverage: strong* — it attacks the single named blocker of the maintenance lane, and a hit
converts to a uniform existence statement at all `q` simultaneously via exact counting.

**T2 — An exact sum rule behind the onP point mass.** The on-conic P-count per size-3 class is a
near-point-mass (dispersion ≤ 0.4) at every computed `q`, yet C42 proved there is *no census
mechanism* (all-P orders have maximally distinct stabilizer-census vectors). Tao's reading: a
deterministic concentration with no combinatorial census behind it usually means an *identity* —
an averaging/sum rule at the level of game values, not features. Concretely: test whether the
onP count, viewed as a class function on the size-3 classes (equivalently on
`PGL(2,q)`-orbits of 6-point conic configurations, the `M₂(F_q)` picture already noted for C56),
satisfies an exact linear relation under orbit-averaging over a larger group (`PΓL`, or the
Frobenius twist at prime-power `q`), or an exact convolution identity linking class counts at
fixed `q`. Constraint check: this is not the dead static feature dictionary — it does not try to
*predict* value from features; it looks for a conservation law *among* the values, which is the
kind of statement C42's negative leaves untouched. Speculative as mechanism, but cheap.
*Kill-test:* from the existing feat-mode censuses (`q ≤ 19`) and the q=23 bucket labels, compute
onP as a vector over classes and test smallest-integer-relation candidates (LLL over the vectors,
orbit-sum comparisons under `PΓL`). Hours. *Leverage: medium* — if an identity exists it converts
the class-stability lemma of falsification-map §6 from an empirical target into algebra; if
nothing shows, the negative is itself informative for the A5 lane.

**T3 — Counterexample compression (quantitative trap anatomy).** A trap at odd `q` means all
`q²−9q+21` size-4 children are N; each N child has a winning move; C46's depletion ladder and the
C59 arc-stability import (large terminals are conic-contained by theorem) constrain where those
winning moves can live. Tao would push the union of the children's winning first moves into a
single incidence object and look for an overload: the trap forces `Θ(q²)` winning-move witnesses
into a structure whose capacity the depletion ladder bounds. This extends C47's
minimal-counterexample package from a theorem *list* to a quantitative pipeline. Constraint
check: the danger is exactly the Hall/pairing precedent — a constant-factor counting argument
dies at the frontier — so the target must be *structural* overload (forced conic containment,
forced tangency coincidences) rather than a numeric inequality with slack. *Kill-test:* run the
pipeline on near-traps that actually exist — the q=17 min-escape classes (one on-conic witness,
the knife edge) — and measure how much structural slack remains; if the machinery cannot even
distinguish the knife-edge classes from generic ones, it will never bite a real trap. Days.
*Leverage: medium* — high payoff (it is the only attack shape that addresses A3 eventual failure
directly), but the constant-slack failure mode is a real risk it must design around.

**T4 — (Considered and set aside) entropy compression / algorithmic LLL for maintenance.** A
Moser–Tardos-style argument that the re-zeroing reply always exists because failure histories
compress. Killed on arrival by measured structure: the q=23 off-conic zone conflict graph is one
dense component touching every unused row and column (`zone_comp = 1`, full row/column support),
so there is no bounded dependency structure for LLL, and compression arguments are counting
arguments in disguise — the Hall precedent applies. *Leverage: weak.* Recorded so nobody re-derives
it.

### (c) Spinoffs

- **Value-level pseudorandomness of P/N labels.** Test whether the P/N labeling over the S5/S6
  position space passes natural pseudorandomness tests against incidence-defined test sets. A
  positive turns the long string of feature-mining negatives (C18, C36's nonconstant types, C39's
  non-decisive monovariants) into one publishable statement: the value set is
  quasi-random relative to all low-complexity incidence features, i.e. *no simple certificate
  exists* — a "why this is hard" theorem-shaped diagnostic. Distinct from C57, which probes the
  zone conflict *graph*; this probes the *value labeling*. *Spinoff value: medium.*
- **The safety-margin heuristic as a transferable method.** The §6 witness-count first-moment
  instrument (Poisson null over canonical classes, margin `mu − ln N_canon`) written up as a
  general diagnostic for avoidance-game conjectures. Not in either existing sweep. *Spinoff
  value: weak-medium* (methods-note tier).

### (d) The question nobody has asked

"You have a deterministic point mass with no census behind it — what is the *identity* that
forces it? Nobody has looked for a conservation law among the values themselves, only for
predictors of them."

---

## 2. Paul Erdős

**(a) Toolkit/style.** Elementary counting and extremal set theory; name the right function, ask
for its growth rate, and chase the extremal configurations; minimal counterexamples; concrete
prize-sized questions.

### (b) Attacks

**E1 — Pin down `Z(q)`: growth rate and extremal configurations.** The recursive steering
ceiling is the program's most route-deciding unnamed function: `Z(13) = 2`, `Z(17) = 9`,
`Z(19) = 16`, and A3's verdict says a uniform `Z`-bound would close the eventual-failure mode.
Erdős would refuse to proceed without knowing `Z(23)` (and the q=25 shape), and would ask for the
*extremal* steering states attaining it — three data points fit anything; the extremal witnesses
say whether growth is forced by geometry (intruder-zone volume, `Θ(q)`) or an artifact of small
`q`. Constraint check: this is a measurement, not a snapshot invariant; it feeds the live
steering lane rather than a dead one. *Kill-test:* extract the steering ceiling over the existing
q=23 chunked `s4xormine`/maintenance corpora (bucket `1,3,4,9` is fully censused; the other 21
have first-ply data), plus targeted chunk runs where coverage is thin. Hours to a day of solver
time within existing caps. *Leverage: strong* — cheapest route-deciding number in the program:
bounded or `O(√q)` growth keeps the small-`Z` base-law route alive; clearly linear growth
redirects all effort to the amortized-potential form.

**E2 — The depletion-fraction extremal question.** The (ON) route survives at q=17 on a knife
edge (min one on-conic witness; value-depletion ≈ 0.21·(q−4) of on-conic children N). Erdős
would name the function: `D(q)` = max over size-3 classes of the N-fraction among on-conic
children, and conjecture `D(q) ≤ 1 − c` for an absolute `c > 0` — then demand the exact sequence
and the histogram tails, not the mean (the §6 heuristic already did the mean). Constraint check:
distinct from the dead area/arc bound (`bad = o(q²)` was about *raw* counts and is refuted;
this is a bounded-away-from-1 fraction at the class level, which the q=17 data does not refute —
it sits at `D(17) ≈ 0.79` for the worst class [recompute in the kill-test]). *Kill-test:* exact
`D(q)` and min-witness count for `q = 5..19` from feat dumps and for q=23 from bucket labels;
plot worst-class trajectory. Hours. *Leverage: medium-strong* — if min-witness count is
increasing after the q=17 dip (q=19 and q=23 look all-P at bucket layer), the knife edge is a
small-`q` accident and the (ON) anchor target becomes `D(q)` bounded, a statement arc-depletion
arithmetic (A5) could plausibly deliver.

**E3 — Completion-poset correlate of the arc-depleted dichotomy.** The 119 flipping
configurations are N exactly at `q ∈ {11,17}`, P at `{13,19}` — the load-bearing unknown of the
(ON) route. C55 tests a group-theoretic mechanism (d-lattice side-switch); Erdős would run the
extremal-set mechanism in parallel: for each flipping 6-configuration, enumerate the poset of
complete arcs *containing* it at each order, and test whether the flip tracks a property of the
completion spectrum — existence of a short completion, parity of the number of maximal
completions, or the minimum completion size crossing a threshold. The name "arc-depleted orders"
is currently descriptive; this would make it causal. Constraint check: not a static 6-subset
feature (C18's dictionary used shallow cross-ratio/character/order features; the completion poset
is a global extremal object the dictionary never saw); not residue arithmetic (C29 killed mod-3);
complements rather than duplicates C55/C59 (C59 imports *bounds* on large complete arcs, not the
containment poset of specific configurations). *Kill-test:* exhaustive completion enumeration at
q=11/13 for all 119 configurations (small search — the solver's feat machinery plus a
straightforward branch over remaining cells), sampled at q=17/19. A day. *Leverage:
strong-medium* — the dichotomy has exactly two live mechanism candidates (C55's and this one);
either verdict shrinks the A5 lane sharply.

### (c) Spinoffs

- **Random sub-board thresholds.** The cap game on a `p`-random subset of `PG(2,q)` (or of the
  residual grid): for which densities does the P verdict survive? Threshold phenomena for game
  outcomes on random incidence sub-structures appear unstudied and the solver plays any point
  list already (the C58 input-mode work covers the plumbing). Not in either sweep. *Spinoff
  value: medium.*
- **Game saturation number of caps.** The length of the game under optimal play (and under
  both-players-shorten / both-players-prolong conventions) as a new arc-theoretic quantity, tied
  to the smallest complete arc `t(2,q)`. Saturation games are an existing genre in graph theory
  [VERIFY: Hefetz–Krivelevich-style saturation-game literature before claiming novelty]; the
  finite-geometry instance appears open. Not in either sweep (distinct from the no-three-in-line
  row, which is about the board, not the length functional). *Spinoff value: medium.*

### (d) The question nobody has asked

"What is `Z(23)` — you have named the one function whose growth decides your route and then not
computed its next value?"

---

## 3. John H. Conway

**(a) Toolkit/style.** Exact CGT: nimbers, quotients, octal games, misère quirks; find *the*
abstract ruleset hiding inside the concrete problem and solve it; strategy descriptions as
finite, nameable objects.

### (b) Attacks

**Co1 — Coupling-defect spectroscopy.** C35 measured the death of `g = g_conic ⊕ g_zone`. Conway
would not mourn the decomposition; he would study the *failure*: define the coupling defect
`δ(S) = g ⊕ g_conic ⊕ g_zone` on every S5/S6 state in the C35 Grundy dumps and ask whether `δ` is
a function of the conic–zone *interface* alone (the incidence pattern between intruders and the
surviving defect skeleton — which σ-images of played cells land on which paths), rather than of
the full state. A disjunctive sum fails precisely when components interact; the CGT move is to
quantify the interaction channel and check it is low-dimensional. Constraint check: engages C35's
negative head-on instead of ignoring it; not a static snapshot invariant claim — `δ` is allowed
to be dynamic, the question is whether its *support* is the interface. *Kill-test:* join the
existing `c35/` Grundy raw dumps with interface features (already computable from the σ data of
Lemma V) and test exact functional dependence by collision counting. Hours. *Leverage:
medium-strong* — if `δ` factors through a small interface, the maintenance invariant is
`g_conic ⊕ g_zone ⊕ δ(interface)` and the "coupled quantity" the queue calls for has a candidate
form; if `δ` needs the whole state, that is a real lower bound on invariant complexity.

**Co2 — Name and solve the abstract game: Node-Kayles with recruitment.** Lemma V says
conic-restricted play is Node-Kayles on a static union of involution matchings; the *real* game
lets players also recruit new involutions (intrude), each recruit adding a matching and shrinking
the recruit supply. The NK note §5.4 already warns this dynamic game is not a fixed octal game.
Conway's move: define the abstract two-zone ruleset — vertices on `P¹` plus a recruit pool with
an abstract conflict structure, forgetting all geometry except (matching added, pool shrinkage) —
and solve it exactly for small parameters. Comparing abstract values to true S5/S6 values then
*measures how much of the value is geometry* versus pure recruitment combinatorics. Constraint
check: this respects C35 (no decomposition is assumed — recruitment couples the zones by
construction); it is a new object, not a mined-out one. *Kill-test:* implement the abstract game
(small: pool ≤ 12, `P¹` size ≤ 24), compare its outcome table against matched real positions at
q=11/13 from existing dumps. A day. *Leverage: medium* — speculative, but if the abstract game is
tractable its P-condition is a candidate maintenance invariant born `q`-uniform.

**Co3 — The finite-state reply automaton.** The missing Good-closure lemma has the shape "for
every opponent move there is a reply returning to Good." Conway would insist Good be a *finite
nameable state set*: quotient the mined winning-reply data by (defect-skeleton spectrum type,
interface type, zone summary type) and test whether P2's winning replies factor through the
quotient — i.e. whether one finite automaton over defect/interface states generates a winning
reply at q=13, 17, 19, and (chunked) 23, *the same automaton at every q*. Constraint check: this
is exactly the steering follow-up lane's goal but sharpened into a falsifiable finite object; it
is not a static snapshot invariant (the automaton is a strategy, judged by play, the one thing
`resym` could not kill — `resym` killed play-closed *symmetric* families, not general
finite-state families); C36's strict-type machinery provides the state-coordinate
vocabulary. *Kill-test:* build the state quotient from the C38 forced-skeleton rows plus the
steering witness rows; count states, count conflicts (same state, contradictory required
replies); then replay the automaton against the exact solver at q=13/17 as adversary. Days,
all from existing artifacts plus replay runs. *Leverage: strong* — it is the falsifiable form of
the open core: a conflict-free cross-`q` automaton *is* the uniform strategy candidate, and a
forced conflict localizes exactly where any finite-state uniform strategy must fail.

### (c) Spinoffs

- **Recruitment games as a standalone CGT family.** If Co2's abstraction is clean: octal-style
  games where moves may add structure (matchings) rather than only remove it — a genuinely
  non-octal family with a geometric client. Distinct from sweep item C, which exports the
  *static* unions-of-matchings result (Corollary VII); the dynamic family is flagged in the NK
  note as open and belongs to nobody yet. *Spinoff value: medium.*
- **Grundy values of the closed boards as sequences.** The empty-board Grundy value of each
  solved family (`AG(2,q)`, `PG(2,q)` even `q`, `Q⁺`, small odd planes) as integer sequences —
  C35's oracle makes these computable; OEIS-grade, citable, cheap. Not in either sweep (C50 is
  the certificate *format*, not the sequences). *Spinoff value: weak-medium.*

### (d) The question nobody has asked

"What is the game? You have solved positions of `PG(2,q)` for six years of `q` — name the
abstract ruleset the conic residual is an instance of, and solve *that*; the plane is one board
of it."

---

## 4. Noga Alon

**(a) Toolkit/style.** Polynomial method and Combinatorial Nullstellensatz; spectral/pseudorandom
graph arguments with exact eigenvalue computations; derandomization — replace existence proofs by
explicit constructions.

### (b) Attacks

**A1 — Polynomialize the reply obligation.** The maintenance obligation is: given the position,
there exists a legal cell whose selection restores conic-xor 0. Alon would try to make the
obligation the non-vanishing of an explicit polynomial over `F_q`. The legality constraints are
already polynomial (non-collinearity = nonvanishing of 3×3 determinants). The obstruction is the
xor condition — but Corollary VII reduces the conic value to Dawson values of path lengths, and
path lengths are orbit lengths of dihedral groups pinned to the divisor lattice of `q±1`
(Lemma VI), i.e. multiplicative-order conditions, i.e. character conditions. The attack: for the
*bounded* defect skeletons that actually occur (C45's realizability classification is the
gatekeeper), tabulate which skeleton transitions restore xor 0 and express the transition
condition as a finite system of order/character constraints on the candidate cell; then existence
is a character-sum count — exact at genus 0 (same exactness lever as T1, approached from the
constraint side rather than the selector side). Constraint check: NK4's "no single-`d` law" is
respected — the claim is never that one order decides, but that the *finite system over the whole
skeleton* does; the dead static-dictionary result concerned shallow features of the 6-subset, not
skeleton-transition systems. *Kill-test:* on q=13/17 exact dumps, for each obligation compute the
skeleton-transition system and check whether its character-sum solution set coincides with the
verified maintainable replies. A day. *Leverage: medium* — a long chain, but each link is
individually checkable, and it is the only attack that could make the maintenance lemma a
*theorem schema* uniform in `q`.

**A2 — Exact reservoir at `k = 7, 8`.** The reservoir bound `q − k − C(k,2) − 1` goes vacuous at
`k = 7`, `q = 23`, because it double-counts secant–row intersections. Alon would replace the
union bound by the exact distribution: the number of legal off-conic cells in an unused row is
`q` minus the exact count of *distinct* secant-trace points, computable from the incidence
pattern of the `C(k,2)` secants with that row (coincidences = concurrences of secants at row
points, a bounded incidence enumeration). Constraint check: C33's verdict is respected — this is
a base-layer *move-availability* fact only, never a Hall/pairing lever; its role is to extend the
availability floor two more plies at the frontier, which the maintenance argument's base case
needs. *Kill-test:* histogram exact per-row legal-cell counts at `k = 7, 8` from q=23 dumps
against the sharpened formula. Hours. *Leverage: medium* — modest but proof-shaped, and it
removes a stated vacuity in the current base layer.

**A3 — Exact spectrum of the zone conflict graph.** Sharpens C57: instead of statistical
quasi-randomness tests, compute the eigenvalues exactly — the zone conflict graph is defined by
collinearity relations, so its adjacency operator decomposes under the stabilizer action and its
spectrum should be expressible in character sums. Constraint check: overlap with C57 is explicit
and acknowledged; and the Hall precedent means no downstream *counting* use is planned — the
value is diagnostic (an `(n,d,λ)` certification would explain mechanically why every local zone
statistic looks featureless, converting the zone-mining negatives into one algebraic fact).
*Kill-test:* exact spectra for the q=13/17 zone graphs in the dumps; compare to the
character-sum prediction. Hours–day. *Leverage: weak-medium* — diagnostic only, by design.

**A4 — (Considered and set aside) slice-rank / Croot–Lev–Pach methods.** The cap-set polynomial
method bounds *densities* in `AG(n,3)`; game values are not densities, the affine game is already
closed, and no transfer from slice rank to outcome values is known. Recorded to prevent
re-derivation. *Leverage: weak.*

### (c) Spinoffs

- **Higher-degree avoidance games: "no `d+3` on a degree-`d` curve".** The cap game is the
  `d = 1` case of building sets with no `d+3` points on a curve of degree `d` (next case: no 6 on
  a conic). New board family, solver-adaptable, natural for the polynomial method, and the
  terminal objects are the classical "points in general position w.r.t. curves" configurations.
  Not in either sweep. *Spinoff value: medium.*
- **Nullstellensatz certificates for game values.** Replace reply-book certificates by polynomial
  identities certifying "every legal move keeps property X" — a compressed certificate format if
  A1's polynomialization works even partially. Complements C50 (kernel-checked Grundy
  certificates) rather than duplicating it — C50 verifies value sequences, this compresses the
  *strategy* witness. *Spinoff value: weak-medium* (speculative).

### (d) The question nobody has asked

"Can the witness be made explicit — an algebraic formula, not an existence claim — and if you
believe it cannot, what is the formal obstruction to derandomizing your own mined strategy?"

---

## 5. Beniamino Segre

**(a) Toolkit/style.** Arcs, caps, and conics over finite fields as algebraic-geometric objects;
the lemma of tangents; associating envelope curves to combinatorial configurations; "every oval
in odd order is a conic" as the archetype: rigidity theorems that convert combinatorics into
algebra.

### (b) Attacks

**S1 — Envelope invariants for the flipping configurations.** [Speculation, cheaply testable.]
Segre's signature move is to attach an algebraic envelope to an arc (lemma of tangents: for a
`k`-arc, tangent lines at its points satisfy multiplicative constraints; for `q` odd the tangents
of a conic-arc envelope a conic). For each of the 119 flipping configurations, compute
tangent-structure invariants at each order — the configuration is six points *on* a conic, so the
relevant object is the residual tangent/secant partition it induces on the off-conic points and
whether the six tangents at the configuration points are concurrent-free / envelope a second
conic with or without rational points. The dichotomy prediction to test: the flip at
`q ∈ {11,17}` tracks the arithmetic of the associated envelope (e.g. its point count or the
quadratic character of a resultant), which is order-dependent in exactly the way a fixed integral
configuration's value is observed to be. Constraint check: not the dead 6-subset dictionary —
C18's features were cross-ratios/characters/orders of the six points; the envelope is a *derived
curve* whose `F_q`-arithmetic varies with `q` for fixed integral data, which is precisely the
degree of freedom the cross-`q` flips demand and the static dictionary lacked. Complements C55
(group-side mechanism) and E3 (extremal-side mechanism) with the algebraic-geometry-side
mechanism. *Kill-test:* compute candidate envelope invariants for all 119 configurations at
`q = 11, 13, 17, 19`; a mechanism must be constant within {11,17} and within {13,19} and differ
across. Hours–day. *Leverage: medium* — three mechanism candidates now exist for the dichotomy;
this is the one that explains *why the same integral data changes value*, if it hits.

**S2 — The grid-terminal spectrum: complete caps under row/column constraints.** The game's
terminal positions in the residual model are *complete caps of the grid game* — maximal legal
positions under caps + row/column capacities. This object is not the classical complete-arc
spectrum (the row/column constraints are new) and nobody has computed it. Segre would classify
it: sizes, structure (how much is conic-contained — the C59 Voloch/Ball import says
large ones are; what do *small* grid-complete caps look like), and stabilizers. Constraint check:
naive parity over terminals is dead (breaks at q=11) — this is not a parity argument; it supplies
the *terminal stratification* that any termination invariant for the maintenance lane has to land
in (the endgame law of NK note §5a — empty conic + 2-cell zone — is the first stratum of exactly
this spectrum). *Kill-test:* exhaustive maximal-position enumeration for `q ≤ 13`, sampled q=17;
the solver's legality machinery already prunes, only the enumeration driver is new. A day.
*Leverage: medium-strong* — the maintenance argument needs a termination target; currently the
program knows the *start* of steering in detail and its *end* not at all.

**S3 — The extension deadline.** For odd `q`, `q`-arcs and `(q−1)`-arcs in `PG(2,q)` are known to
extend to conics [VERIFY exact thresholds — Segre-lineage extension theorems; the program's C59
note has the Voloch/Ball citations for the modern form]. Game consequence: any play reaching size
near `q` is conic-confined by theorem, so the off-conic zone has a hard geometric *deadline* —
intruder play cannot continue past the extension threshold. Combining the deadline (upper bound
on active plies from above) with C46's depletion ladder (lower bound on live conic from below)
sandwiches the window in which steering must succeed into an explicit interval. Constraint check:
this is a structural import, not a counting argument with slack; it extends C46/C59 (both queued/
reported) by *composing* them, which neither task does. *Kill-test:* measure in the dumps the
maximum ply at which any off-conic move occurs, versus the predicted deadline, `q ≤ 19`. Hours.
*Leverage: medium* — it does not produce the invariant, but it bounds the battlefield, which the
termination half of the maintenance lemma needs.

### (c) Spinoffs

- **The cap game on cubic curves.** Collinearity on a plane cubic in group form is `x+y+z = 0`,
  so the cap game on `E(F_q)` is the sum-free building game on the group — and the mirror method
  has a *provable boundary* here: any collinearity-compatible involution has the form
  `σ(x) = c − x` with `3c = 0`, and then `x = 2c` is always a fixed point (since `2(2c) = 4c = c`),
  so no fpf mirror exists on any cubic. Sharper than sweep item B's generic
  "sum-free games on finite abelian groups" chase: this adds the geometric family, the explicit
  no-fpf-mirror theorem (extending the C48 boundary dichotomy to genus 1), and solver-ready
  boards whose outcomes test whether group order drives value where no mirror can. *Spinoff
  value: medium-strong.*
- **Game-reachable complete arcs as a new arc invariant.** Which complete arcs occur as terminals
  of *optimal* play? The reachable spectrum is a game-theoretic refinement of the classical
  complete-arc spectrum, computable from existing dumps, and plausibly a finer invariant of the
  plane than the outcome (ties into C58's order-9 comparison — two planes with equal outcome may
  differ in reachable terminal spectra). Not in either sweep. *Spinoff value: medium.*

### (d) The question nobody has asked

"Which complete arcs can optimal play actually reach — is the game's terminal spectrum a new
invariant of the plane, finer than the outcome you are trying to prove constant?"

---

## 6. László Lovász

**(a) Toolkit/style.** Duality and relaxation (LP/SDP, theta function); local-vs-global
transfer (local lemma, graph limits); algorithmic reformulation — a proof is a construction with
bounded resources; matroids and geometric representations.

### (b) Attacks

**L1 — Fit the amortized potential by linear programming; read the dual.** The queue's
seventh-pass method note already concludes the termination invariant is likely an *amortized
potential* (charged mix of conic xor, reservoir slack, zone size), every snapshot-conserved
candidate having died. Lovász would operationalize the search: over the exact transition data
(C35 Grundy dumps + steering rows at q=13/17), pose feasibility as an LP — find feature weights
such that P2's verified replies never increase the potential, every P1 option from a Good state
fails to break it, and terminal Good states are winning — and, crucially, *read the dual on
infeasibility*: the dual certificate names the exact transition combinations that defeat every
potential in the chosen feature span, telling the miners which feature to add next. Iterating
LP-fit / dual-read / feature-extend is a disciplined replacement for guessing invariants.
Constraint check: builds directly on the amortized-potential method note (which names the
template but no instrument); respects C35 (features may be coupled, nothing assumes a component
xor); it is not a static snapshot claim (the potential is a Lyapunov function for a *strategy*,
exactly the object class the negatives leave open). *Kill-test:* the LP itself — q=13 full data
first (small), q=17 second; infeasibility with a small dual support is as informative as
feasibility. A day. *Leverage: strong-medium* — either output advances the open core: a feasible
potential is the termination invariant candidate; a dual certificate is the first *machine-readable
impossibility statement* for a whole invariant class, upgrading "we tried and failed" to a lemma.

**L2 — Strategy-complexity dichotomy: lower bounds, not just candidates.** Complementing Co3
(which hunts a finite-state strategy), Lovász would run the impossibility half: formalize
memory-`k` / lookahead-`k` local rules and *prove lower bounds* from the tablebases — exhibit
position pairs identical under every memory-`k` view that require different winning replies. A
growing-in-`q` lower bound would be the first theorem explaining the negatives (why mirrors,
snapshot invariants, and shallow dictionaries all failed: the strategy provably needs
`ω(1)` state), and would redirect the program to potentials/amortization for principled reasons
rather than empirical ones. Constraint check: consistent with all negatives by construction — it
would *derive* them. *Kill-test:* automated search for such distinguishing pairs at k = 0, 1, 2
over q=13/17 dumps. A day. *Leverage: medium* — it cannot prove the conjecture, but it can prove
which proof shapes cannot work, and the program has paid repeatedly for lacking exactly that.

**L3 — Local convergence of the zone ensembles.** [Speculation.] Treat the zone conflict graphs
across `q` as a graph sequence and test Benjamini–Schramm-style local convergence of neighborhood
statistics. If the local statistics converge while `Z(q)` grows, the growth is driven by global
(boundary/interface) structure, not local density — which would say the steering difficulty lives
at the conic–zone interface, corroborating Co1's target from a different side. Overlaps C57 in
instrumentation (acknowledged); differs in question (convergence across `q`, not quasi-randomness
at fixed `q`). *Kill-test:* neighborhood-distribution comparison across q=13..23 zone graphs from
dumps. Hours. *Leverage: weak-medium* — diagnostic.

**L4 — (Considered and set aside) Lovász Local Lemma for reply existence.** Needs bounded
dependency; the measured zone is one dense component with full row/column support. Dead on
arrival; recorded. *Leverage: weak.*

### (c) Spinoffs

- **Strategy complexity of impartial geometric games.** A hierarchy paper: 0-memory (mirrors) ⊂
  finite-state ⊂ local-rule-with-potential ⊂ unrestricted, with the program's own families as
  separating examples (mirror-closed boards at the bottom; the odd plane conjecturally higher).
  The existing sweep's "complexity landscape" row is PSPACE-hardness of *deciding* values; this is
  complexity of *winning strategies*, a different axis. *Spinoff value: medium.*
- **LP/SDP certificate formats for game outcomes.** If L1's potentials work even at fixed `q`,
  a weighted-potential certificate is a new compressed certificate genre beside reply books
  (C30) and Grundy sequences (C50). *Spinoff value: weak-medium* (speculative).

### (d) The question nobody has asked

"What is the minimal memory of any winning second-player strategy — and can you prove a lower
bound from your own tablebases before spending another month searching the classes below it?"

---

## Summary table — all proposed attacks and spinoffs

| Lens   | ID  | Idea                                                | Main leverage | Spinoff value | Kill-test cost      |
|--------|-----|-----------------------------------------------------|---------------|---------------|---------------------|
| Tao    | T1  | Inverted selector search via exact character sums   | strong        | —             | hours (score TSVs)  |
| Tao    | T2  | Exact sum rule behind the onP point mass            | medium        | —             | hours (feat dumps)  |
| Tao    | T3  | Counterexample compression / trap anatomy           | medium        | —             | days (near-traps)   |
| Tao    | T4  | Entropy compression / LLL for maintenance (killed)  | weak          | —             | n/a (dead on data)  |
| Tao    | Ts1 | Value-level pseudorandomness of P/N labels          | —             | medium        | hours–day           |
| Tao    | Ts2 | Safety-margin heuristic as transferable method      | —             | weak-medium   | writing only        |
| Erdős  | E1  | Z(q) growth + extremal steering configurations      | strong        | —             | hours–day (q=23)    |
| Erdős  | E2  | Depletion-fraction extremal sequence D(q)           | medium-strong | —             | hours (dumps)       |
| Erdős  | E3  | Completion-poset correlate of the q∈{11,17} flips   | strong-medium | —             | day (q=11/13 exact) |
| Erdős  | Es1 | Random sub-board outcome thresholds                 | —             | medium        | uses C58 plumbing   |
| Erdős  | Es2 | Game saturation number of caps [VERIFY lit]         | —             | medium        | hours + lit check   |
| Conway | Co1 | Coupling-defect spectroscopy (δ = g⊕g_c⊕g_z)        | medium-strong | —             | hours (C35 dumps)   |
| Conway | Co2 | Abstract "Node-Kayles with recruitment" game        | medium        | —             | day (implement)     |
| Conway | Co3 | Finite-state reply automaton, cross-q               | strong        | —             | days (quotient+replay) |
| Conway | Cs1 | Recruitment games as standalone CGT family          | —             | medium        | follows Co2         |
| Conway | Cs2 | Grundy values of closed boards as sequences         | —             | weak-medium   | hours (C35 oracle)  |
| Alon   | A1  | Polynomialize the reply obligation                  | medium        | —             | day (q=13/17)       |
| Alon   | A2  | Exact reservoir at k = 7, 8                         | medium        | —             | hours (q=23 dumps)  |
| Alon   | A3  | Exact zone-graph spectrum (sharpens C57)            | weak-medium   | —             | hours–day           |
| Alon   | A4  | Slice-rank / CLP transfer (killed)                  | weak          | —             | n/a (no transfer)   |
| Alon   | As1 | "No d+3 on a degree-d curve" avoidance games        | —             | medium        | solver adaptation   |
| Alon   | As2 | Nullstellensatz strategy certificates               | —             | weak-medium   | follows A1          |
| Segre  | S1  | Envelope invariants for flipping configurations     | medium        | —             | hours–day           |
| Segre  | S2  | Grid-terminal spectrum (complete caps + capacities) | medium-strong | —             | day (q ≤ 13 exact)  |
| Segre  | S3  | Extension-theorem deadline × depletion ladder       | medium        | —             | hours (ply stats)   |
| Segre  | Ss1 | Cubic-curve cap game + no-fpf-mirror theorem        | —             | medium-strong | day (solve small E) |
| Segre  | Ss2 | Game-reachable complete-arc spectrum as invariant   | —             | medium        | hours (dumps)       |
| Lovász | L1  | LP-fit the amortized potential; read the dual       | strong-medium | —             | day (q=13 first)    |
| Lovász | L2  | Strategy-complexity lower bounds from tablebases    | medium        | —             | day (pair search)   |
| Lovász | L3  | Local convergence of zone ensembles                 | weak-medium   | —             | hours               |
| Lovász | L4  | LLL for reply existence (killed)                    | weak          | —             | n/a (dense zone)    |
| Lovász | Ls1 | Strategy-complexity hierarchy paper                 | —             | medium        | writing + L2 data   |
| Lovász | Ls2 | LP/SDP outcome-certificate formats                  | —             | weak-medium   | follows L1          |

Dedupe ledger (checked, not re-proposed): C55 d-lattice side-switch (E3/S1 are *complementary
mechanisms*, stated as such), C56 Igusa coordinates (T2 uses the same moduli picture for a
different question), C57 zone quasi-randomness (A3/L3 overlap flagged, both sharpen rather than
duplicate), C58 order-9 planes, C59 arc-stability import (S3 composes it with C46 rather than
re-importing), C60 Singer circulant; sweep items A–F and all New-Candidate-Mapping rows
(no-three-in-line, Sidon, quantum caps, placement complexes, misère, positional comparisons,
genus-2/Igusa, complexity landscape, achievement siblings, buildings, reconfiguration,
containers, infinite boards, online potentials) — none re-proposed; where adjacent (Ss1 vs item
B, Ls1 vs complexity row, Cs1 vs item C) the delta is stated inline.

## Top-5 shortlist across all six lenses

1. **Co3 (Conway) — finite-state reply automaton.** The open core (Good-closure) recast as a
   falsifiable finite object over data that already exists; a conflict-free cross-`q` automaton
   is the uniform strategy candidate, and a forced conflict is the first theorem-grade
   localization of where uniform strategies must fail.
2. **T1 (Tao) — inverted selector search scored by exact character sums.** Attacks the steering
   lane's one named blocker (value-defined witnesses) from the algebraic side, and the genus-0
   exactness lever means a hit is uniform in `q` with no frontier slack to die at.
3. **L1 (Lovász) — LP-fit the amortized potential and read the dual.** The only proposal whose
   failure mode is as valuable as its success: infeasibility duals convert invariant-hunting
   negatives into machine-readable impossibility lemmas that steer the feature search.
4. **E3 (Erdős) — completion-poset correlate of the arc-depleted dichotomy.** The dichotomy is
   the (ON) route's load-bearing unknown with exactly one queued mechanism candidate (C55); this
   adds the extremal-side candidate and is exactly checkable at q=11/13 in a day.
5. **E1 (Erdős) — pin down Z(23) and the extremal steering states.** The cheapest route-deciding
   measurement in the program: it arbitrates between the small-`Z` base-law route and the
   amortized-potential route before either consumes more proof effort.

Near-misses worth queuing behind these: S2 (grid-terminal spectrum — the termination target the
maintenance lane currently lacks), Co1 (coupling-defect spectroscopy — the constructive follow-up
to C35's negative), E2 (the D(q) extremal sequence).
