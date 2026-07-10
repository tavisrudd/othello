# Frame exercise: proof-shape census for the odd-plane cap-game conjecture

Date: 2026-07-09.  Frame: instead of asking what the problem connects to, enumerate every SHAPE
the final proof could have — what does the last page look like? — eliminate shapes against the
program's known negatives, and develop the survivors into concrete lemma obligations.

Inputs: the [program handoff](handoffs/2026-07-06-projective-cap-game-handoff.md) (What Is Dead,
Intrusion/Defect program, Current Lean Map, C30/C50/certcheck certificate machinery), the
[NK involution residual note](2026-07-08-nk-involution-residual.md) (Lemmas V–VII, NK1–NK4), the
[falsification map](2026-07-09-odd-plane-falsification-map.md) (A/B modes, the trap equivalence),
and the queue priority section (C55–C60 dedupe).  This is framing + proposal, not results; every
proposal below carries its kill-test.  Speculation is labeled as speculation.

## 0. The target and the constraint set

Target statement (Lean-anchored): for every odd prime power `q`, `PG(2,q)` is P.  By the C41
equivalence this is exactly: **no odd `q` admits a trapped size-3 residual position** (a size-3
whose `q² − 9q + 21` size-4 children are all N).  Proved in Lean `q ≤ 13`, computed through
`q = 23`, bucket-certified at `q = 23`.

Any surviving proof shape must respect the program's negatives:

- static snapshot invariants dead (parity, area bounds, feature dictionaries, census uniformity
  C42, residue classes C29);
- fixed mirrors and play-closed symmetric families exhaustively killed (C27/C28, `resym`, C32);
- no decomposition: `g ≠ g_conic ⊕ g_zone`, measured (C35);
- counting with constant-factor slack dies at the `q = 23–25` frontier (Hall/pairing needed
  `q ≥ 38`; the reservoir bound is vacuous at `k = 7`, `q = 23`);
- polarity identities false on mined data;
- cross-`q` value transport refuted (119 integral configurations flip: N at the arc-depleted
  orders `q ∈ {11,17}`, P at the full orders `{13,19}`);
- per-`q` computation is never class-closing (falsification map §2 — the category error).

The last constraint is the frame's sharpest filter: the last page must contain a **`q`-uniform,
finite** object — a finite list of shapes, a finite alphabet, a finite check plus a uniform
argument — because the tail of odd `q` is infinite.

## 1. (a) The census — every mechanism by which "P for an infinite family" gets proven

### Inside impartial CGT

- **S1. Pairing / mirror (Tweedledum–Tweedledee).**  Fixed-point-free involution + reply map;
  folklore since Bouton, systematized in Berlekamp–Conway–Guy, *Winning Ways* (1982); pairing
  strategies for positional games in Hales–Jewett, Trans. AMS 106 (1963).  This program's own
  closed families are all S1: `initialPStatement_of_fixedPointFree_collinearity_preserving_involution`,
  the elliptic mirror for `PG(2m−1,q)`, the char-2 translation mirror, the C48 hyperbolic-quadric
  harvest.  The C27 correction (`MirrorStepGood` — the mirror-chord obstruction) is the precise
  legality condition.
- **S2. Strategy stealing.**  Nash's Hex argument (c. 1949, recorded in Gale, Amer. Math. Monthly
  86 (1979)); Hales–Jewett (1963) for achievement games.  Requires an "extra move never hurts"
  monotonicity and concludes first-player win (N), not P.
- **S3. Weight / potential / monovariant functions.**  Bouton's nim-sum (Ann. of Math. 3 (1901))
  is the canonical conserved weight; Fraenkel's numeration-system invariants for Wythoff-type
  games (e.g. Amer. Math. Monthly 89 (1982)) [VERIFY exact citation].  Two sub-shapes: an exact
  conserved quantity (static), or an **amortized potential** maintained by the winning player
  (dynamic) — the queue's seventh-pass method note already distinguishes these.
- **S4. Parity / counting arguments.**  Free-placement parity ("she-loves-me-she-loves-me-not",
  *Winning Ways*); the program's ovoid rows `Q⁻(3,q)`.  Also Rivest–Vuillemin-style counting on
  group orbits (Theoret. Comput. Sci. 3 (1976/77)).
- **S5. Grundy periodicity / closure certified by a finite check.**  Guy–Smith, "The G-values of
  various games", Proc. Cambridge Philos. Soc. 52 (1956) 514–526: an octal game whose Grundy
  sequence repeats over a long-enough window is eventually periodic **forever** — the canonical
  "finite computation ⇒ infinite-family theorem" in impartial CGT.  Dawson's chess = octal 0.137,
  period 34 (OEIS A002187) — already load-bearing in Corollary VII of the NK note.
- **S6. Quotient monoids / algebraic closure.**  Plambeck, "Taming the wild in impartial
  combinatorial games", INTEGERS 5 (2005); Plambeck–Siegel, "Misère quotients for impartial
  games", J. Combin. Theory Ser. A 115 (2008): a finite commutative monoid certifies outcomes for
  *all* heap positions of a ruleset.  Same "finite algebra ⇒ infinite family" DNA as S5.
- **S7. Structural induction / disjunctive-sum decomposition.**  Sprague–Grundy sum theory; the
  colon principle (*Winning Ways*).  The family is closed under a composition operation and values
  compose.
- **S8. Zermelo backward induction with certified finite kernels.**  Zermelo (1913); "Checkers is
  solved", Schaeffer et al., Science 317 (2007); this program's Lean certificate assemblies
  (`CertData.Q11/Q13`), C30 route-C books, C50 kernel-checked Grundy certificates, C54 rules-only
  DAG checking.  Alone it proves per-`q` rows, never the family.

### Transplants from outside CGT

- **S9. KSS fixed-point / equivariant-topology shape.**  Kahn–Saks–Sturtevant, "A topological
  approach to evasiveness", Combinatorica 4 (1984) 297–306: non-evasive monotone property ⇒ its
  simplicial complex is collapsible ⇒ ℤ_p-acyclic; Oliver's fixed-point theorem (Comment. Math.
  Helv. 50 (1975): a group with normal `p`-subgroup and cyclic quotient acting on a ℤ_p-acyclic
  finite complex has a fixed point) + vertex-transitivity ⇒ contradiction ⇒ evasive for
  prime-power `n`.  Relevance: **this program has a positions complex** (all caps of `PG(2,q)`,
  a simplicial complex — the legal complex of a strong placement game in the
  Huntemann–Nowakowski sense) **with a `PGL(3,q)` action** and a fixed-point-free Singer cyclic
  subgroup of order `q² + q + 1`.
- **S10. Four Color Theorem shape: unavoidable set + machine-checked reducibility + discharging.**
  Appel–Haken (Illinois J. Math. 21 (1977)); Robertson–Sanders–Seymour–Thomas (J. Combin. Theory
  Ser. B 70 (1997) 2–44, 633 configurations); Gonthier's Coq formalization (Notices AMS 55
  (2008)).  Shape: a minimal counterexample must contain a member of a finite configuration list
  (proved by discharging a conserved charge derived from Euler's formula); each member is
  machine-checked reducible (cannot occur in a minimal counterexample).  **The program already
  owns the reducibility half**: certcheck / s4pncheck / C50 / the Q11–Q13 Lean assemblies are
  4CT-style machine-checked per-configuration certificates.
- **S11. Entropy compression / algorithmic Lovász Local Lemma.**  Moser–Tardos, J. ACM 57(2)
  (2010); Grytczuk–Kozik–Micek, "New approach to nonrepetitive sequences", Random Structures
  Algorithms 42 (2013); the name is Tao's.  Shape: a deterministic/randomized local-repair
  procedure must terminate because a long failure trace would compress its own random input;
  proves existence-under-adversity statements with no global counting.  Already used on these
  boards for coloring: "Entropy Compression Method and Legitimate Colorings in Projective Planes"
  (Bosek et al.) [VERIFY authors/venue].
- **S12. Sperner/Brouwer-style game arguments.**  Gale, "The game of Hex and the Brouwer
  fixed-point theorem", Amer. Math. Monthly 86 (1979): no-draw/existence via a combinatorial
  fixed-point lemma.
- **S13. Compactness / transfer between characteristics.**  Lefschetz-principle / ultraproduct
  transfer (Ax–Grothendieck style): prove for one characteristic family, transfer first-order
  consequences.
- **S14. Polynomial method / algebraic rank.**  Croot–Lev–Pach and Ellenberg–Gijswijt (Ann. of
  Math. 185 (2017)) — the cap-set bound: a `q`-uniform extremal statement about caps proved by a
  rank identity.  Segre's theorem (1955): every oval of `PG(2,q)`, `q` odd, is a conic — the
  model uniform-in-`q` theorem already sitting under the program's conic localization; the queue's
  C59 (Voloch/Ball arc-stability import) is this shape in support role.
- **S15. First-moment / concentration heuristics.**  Tao-style pseudo-randomness tests; the
  program's witness-count heuristic (already run; diagnostic, explicitly not a proof — the counts
  are deterministic).

Adjacent simplicial-game literature located while checking S9 (none is an outcome⇔topology
bridge for the build game):

- Ehrenborg–Steingrímsson, "Playing Nim on a simplicial complex", Electron. J. Combin. 3 (1996)
  — a *different* game (piles on vertices, moves on faces); winning strategies under matroid
  conditions.
- Faridi–Huntemann–Nowakowski, "Simplicial Complexes are Game Complexes", Electron. J. Combin.
  26(3) (2019), plus "Games and Complexes I/II" (Games of No Chance 5, MSRI 70 (2017)): strong
  placement games ↔ legal-position complexes; **isomorphic legal complexes ⇒ isomorphic game
  trees ⇒ equal values** — the one verified bridge statement, and it is a tautological-direction
  one.
- "Playing impartial games on a simplicial complex as an extension of the emperor sum theory"
  (arXiv:2202.00197) — again vertex-pile games, not the face-building game.
- Search result: **no published theorem was found linking the face-building ("last player able to
  extend a face wins") game's outcome to Euler characteristic, collapsibility, or homology.**
  The folklore on "the game of building a face" appears to be exactly the pairing-strategy
  special case this program already formalized.  Tagged as an absence claim, checked by search,
  not provable by search [VERIFY].

## 2. (b) The elimination table

Verdicts: **dead** (a known negative kills it), **wounded** (killed in its natural form; a named
variant remains possible), **alive** (no current negative reaches it).

| #   | Shape                              | What it needs here                                          | Killing / wounding negative                                                              | Verdict                       |
|-----|------------------------------------|-------------------------------------------------------------|------------------------------------------------------------------------------------------|-------------------------------|
| S1  | Pairing / fixed mirror             | One involution/reply map legal through all play             | C27/C28 zero `MirrorStepGood` hits; `resym` q=11,13,17; C32 composite refuted             | dead (as the odd-plane route) |
| S2  | Strategy stealing                  | Extra-move monotonicity; concludes N anyway                 | Cap constraint makes extra stones harmful; target is P, not N                             | dead                          |
| S3  | Static weight / conserved quantity | A snapshot function constant on P-positions                 | Whole static-invariant graveyard (parity, area, census, residues, polarity)               | dead as static; amortized variant alive → S11/S10 |
| S4  | Parity / global counting           | Uniform count with slack                                    | Naive parity breaks at q=11; Hall/pairing precedent needs q ≥ 38; reservoir vacuous k=7    | dead                          |
| S5  | Grundy periodicity in q (Guy–Smith)| A recurrence/embedding `PG(2,q) → PG(2,q′)` transporting values | Cross-q transport refuted (119 flips, {11,17} vs {13,19}); no board embedding exists   | dead as stated; period-34 Dawson layer survives *inside* S10 |
| S6  | Quotient monoid / misère-quotient  | Family of positions closed under a f.g. algebra with q-uniform relations | Family parameter q changes the whole board; within-q it reduces to certificates (S8) | wounded — per-q compression tool only |
| S7  | Disjunctive-sum induction          | `g = g_conic ⊕ g_zone` or similar composition               | C35 measured: fails on most rows even with computable zone Grundy                          | dead as clean sum; coupled-alphabet variant folds into S10 |
| S8  | Certified finite kernel per q      | —                                                            | Category error: per-q solves never close an infinite tail (falsification map §2)          | alive as **component only** (the reducibility half of S10) |
| S9  | KSS equivariant fixed point        | An outcome ⇒ topology bridge + equivariant acyclicity input | Outcome is not a homotopy or collapsibility invariant (counterexample in §3.2); no bridge theorem exists; cross-q flips stress any q-blind invariant | wounded-but-variant-possible (survivor 3) |
| S10 | Discharging + unavoidable set + machine reducibility | A finite q-uniform configuration alphabet + a discharged quantity + per-class certificates | C36/C42 killed *naive* alphabets (types, censuses); Z grows 2→9→16; C35 forbids product alphabets | **alive** (survivor 1) |
| S11 | Entropy compression / algorithmic LLL | A definable repair selector + an information ledger beating the adversary's move budget | Naive first-candidate selector already fails 3/108 (one-pair maintenance); mined witnesses are value-defined, not yet geometric | **alive** (survivor 2) |
| S12 | Sperner / Brouwer game argument    | A draw/existence gap for a fixed-point lemma to fill        | Impartial normal play has no draws; nothing for the lemma to produce                       | dead                          |
| S13 | Compactness / characteristic transfer | Outcome as one first-order sentence uniform in q          | Game length grows with q (not one sentence); cross-q transport empirically refuted         | dead                          |
| S14 | Polynomial method / algebraic rank | A rank identity deciding game value, not extremal size      | Attacks the wrong quantity (size spectra); value is not a rank statement                   | wounded — support role for A5/C59 (arc-depletion arithmetic input) |
| S15 | First-moment / concentration       | Randomness that is not there                                 | Counts are deterministic; heuristic already run, margin erratic                            | dead as proof; retained as A3 diagnostic |

Dedupe note (C55–C60 + spinoff-bridges): nothing above re-proposes C55 (d-lattice side-switch),
C56 (group-indexed type alignment), C57 (zone quasi-randomness), C58 (order-9 planes), C59
(arc-stability import — S14's support role *is* C59, cited not duplicated), or C60 (Singer
circulant — S9 consumes its group but asks a different question).  The survivors' kill-tests
below are new measurements over existing artifacts.

## 3. (c) Deep development of the survivors

### 3.1 Survivor 1 — the discharging shape (S10): unavoidable steering states + Lean reducibility

**What the last page looks like.**  "Let `q` be odd and suppose `T` is a trapped size-3 in
`PG(2,q)`.  By the Structure Lemma, every state reachable in the refutation of `T` presents, at
each opponent move, a coupled steering snapshot lying in the finite alphabet `A` (independent of
`q`).  By the Reply Lemmas — machine-checked, one per element of `A` — each snapshot admits a
Good-restoring reply.  Hence some size-4 child of `T` is P; contradiction.  Finitely many small
`q` outside the ladder's range are closed by the existing Lean certificates."

**The three 4CT roles, transplanted.**

| 4CT role            | 4CT object                                  | Transplant here                                                                 |
|---------------------|---------------------------------------------|----------------------------------------------------------------------------------|
| Minimal counterexample | Smallest planar non-4-colorable triangulation | A trapped size-3 at some odd q (C41 makes this exact, both directions, in Lean) |
| Unavoidable set     | 633 configurations; every triangulation contains one | Finite alphabet `A` of coupled steering snapshots; every trap-refutation obligation lands in `A` |
| Discharging         | Redistribute Euler charge `deg − 6` to show the list is unavoidable | Redistribute *strategy obligations* along the conic parameter line: the even-cycle bulk carries zero charge (Corollary VII), so all obligation concentrates on the O(1)-per-intruder defect set + the bounded zone interface |
| Reducibility        | Machine-checked ring analysis per configuration | Lean/certcheck reply-schema certificate per element of `A` — infrastructure already built (C30/C50/certcheck, Q11/Q13 assemblies) |

**Over what objects?**  Not size-3 classes (C42 killed census propagation), not exact point
configurations (C36: strict types don't transport; 119 cross-q value flips), not conic types
alone (C35: no conic⊕zone product).  The candidate objects are **coupled NK steering snapshots**:

```text
a = ( defect-skeleton spectrum reduced mod the Dawson period 34,
      secant/tangency/parabolic incidence type of the active intruder pair (d | q−1 vs d | q+1 vs d = p),
      zone interface of bounded size Z*,
      depletion regime marker from the C46 ladder (t vs T(q)) )
```

taken **jointly** (one alphabet symbol, not a tuple of independent coordinates — this is the C35
lesson).  Crucially the alphabet must certify **reply existence**, not value.

**What quantity gets discharged?**  The obligation count.  In a hypothetical trap, all
`q² − 9q + 21` children are N, so each carries a winning-move obligation for the opponent; the
refutation must produce, for each opponent threat, a Good-restoring reply.  Assign charge +1 per
threat.  The discharging rules move charge off the conic bulk: Lemma V (kill-set law) says a
conic move's whole effect is `{σ_x(p)}`; Corollary VII says every free dihedral orbit (even
cycle) is Grundy-0, i.e. **carries no charge**; Lemma VI pins the cycle spectrum to the divisor
lattice of `q ± 1`.  What remains charged is: ≤ 2 tangency paths per intruder, ≤ 1 secant pair
per intruder pair, ≤ c kill-scars, plus the zone interface.  The `q`-uniform discharging
inequality is then

```text
(threats per state)  ≤  (charge absorbable by the finite defect alphabet)  +  0 · (cycle bulk)
```

with the left side bounded per state (not per board) because a single opponent move perturbs the
NK graph by one matching and the zone by O(1) — the inequality is **per-move and existential**,
never a global constant-factor count.  That is exactly how it dodges the Hall/pairing death
(`q ≥ 38`): nothing is summed over the board.

**Confronting the obstruction (configuration space grows with `q`).**  4CT's finiteness comes
from bounded ring size: a configuration meets the rest of the graph through a bounded boundary.
The transplant needs two finiteness suppliers, both already mined:

1. **Dawson period 34** (A002187): path-defect lengths grow with `q`, but their *game data* lives
   in a finite set — path length mod 34 (plus the sub-period sparse exceptions at indices 0,14,34,
   which are finite and explicit).  The cycle bulk is uniformly zero (Corollary VII, all even
   `n ≥ 4`).  So the conic side of the interface is finite **by theorem**, not by bound.
2. **Bounded zone interface** — the genuine open half.  The raw zone grows (dense one-component
   conflict graphs, `zone_v = 100..120` at q=23), so the alphabet cannot contain the zone itself.
   The C31 data says the *steering-relevant* part might be bounded: optimal recursive steering
   ceilings are `Z = 2, 9, 16` at `q = 13, 17, 19` — growing, which is the standing threat.  The
   shape therefore FORCES a **bounded-interface lemma**: a `Z*` (constant or certified slow) such
   that reply existence depends only on the radius-`Z*` zone neighborhood of the threat, with the
   rest of the zone screened by a reservoir-availability argument (the `q − k − C(k,2) − 1`
   bound used only as base-layer availability, per C33).  If `Z` is genuinely unbounded in the
   *interface* sense, this shape dies — that is its falsifiable core.

**The exact missing lemma (forced by the shape).**

> **Finite steering alphabet lemma.**  There is a finite set `A` of coupled steering snapshots
> and a snapshot map `α`, both independent of `q`, such that (i) *unavoidability*: from any Good
> state, every legal opponent move produces a state whose snapshot lies in `A`; (ii)
> *reducibility*: for each `a ∈ A` there is a reply schema (a geometrically defined move
> selector) that restores Good, checkable per-`a` by a kernel-checked certificate.

Note the deliberate weakening relative to everything already killed: `α` need not determine the
**value** of the state (C36/C42 killed that); it must only determine **existence of a
Good-restoring reply**.  The 119 cross-q flips killed value-transport of integral point
configurations; they said nothing about reply-existence-transport of coupled NK snapshots.  That
untested gap is where the shape lives.

**Cheap kill-test (against existing data, no new solves).**  Over the existing exact artifacts —
q=13/17/19 full dumps, the 22 q=23 bucket dumps, the C35 Grundy dumps, and especially the
`s4xormine` maintenance rows (28,646/28,646 accepted obligations plus the 1,513 residuals with
`live_on = 3..6`) — compute the coupled snapshot `α` for every (state, opponent-move) obligation
and test: **do two obligations with the same snapshot ever differ on "a zero-xor Good-restoring
reply exists"?**  A single same-snapshot yes/no collision at the current alphabet kills that
alphabet (then refine once along the C55 d-lattice axis before declaring the shape dead — this
is where C55's side-switch diagnostic feeds in rather than being duplicated).  Secondary probe:
the two q=17 score-9 orbits (already isolated, two `PGL(2,17)` orbits) must be *in* the alphabet
as its hardest members; check their snapshots are not shared by any reply-less state.

**Leverage: STRONG.**  (1) It is the only shape whose expensive half is already built and
validated — the program's Lean certificate machinery is a working reducibility engine, and C50
extends it to Grundy sequences.  (2) Every one of its ingredients is a proven or machine-verified
statement (Lemma V/VI/VII, C46 ladder, C41 equivalence) rather than a hoped-for pattern.  (3) It
respects all negatives by construction: nothing static (the snapshot is a *maintained* strategy
state), nothing product-form (coupled alphabet), nothing constant-slack (per-move existential
inequality), nothing cross-q about values (transports reply schemas only).  Its one exposed organ
is the bounded interface `Z*` against the growing `2, 9, 16` sequence — a concrete, measurable
risk, which is what a good top shape should have.

### 3.2 Survivor 3 — the KSS fixed-point shape (S9): equivariant topology of the positions complex

(Developed second because it shares the "what would the bridge even say" analysis with 3.1's
alphabet; ranked third in the verdict.)

**Setup.**  Let `Δ_q` be the simplicial complex whose faces are the nonempty caps of `PG(2,q)`
(the legal complex of the strong placement game, in the Faridi–Huntemann–Nowakowski sense).  The
cap game is the **face-building game** on `Δ_q`: players alternately extend the current face by a
vertex; last able to move wins.  Two exact structural facts: (i) the game from position `S` is
the face-building game on the **link** `lk_{Δ_q}(S)` — frame reduction is PGL-transitivity on
links; (ii) `PGL(3,q)` acts simplicially on `Δ_q`, its Singer subgroup (order `q² + q + 1`)
without fixed vertices, and value is constant on orbits (fixed `q` — the C53 bridge is the
on-conic instance).

**What KSS actually provides, and the precise gap.**  KSS's engine is:
game-theoretic hypothesis ⇒ topological consequence (non-evasive ⇒ the decision tree collapses
the complex ⇒ collapsible ⇒ ℤ_p-acyclic), then Oliver's fixed-point theorem + transitivity ⇒
contradiction.  The transplant needs the analogous **outcome ⇒ topology** theorem for the
build game, and none exists — worse, none *can* exist at the level of homotopy or even
collapsibility:

> Counterexample (elementary, worth recording).  `Δ = {v}` (one vertex): first player takes `v`,
> second player is stuck — **N**.  `Δ = path a–b–c` (faces `a, b, c, ab, bc`): every first move
> has a reply ending the game (`a→b, b→a, c→b`) — **P**.  Both complexes are collapsible (both
> contractible).  So build-game outcome is not a function of homotopy type, Euler characteristic,
> or collapsibility.  Any bridge must use finer data.

What finer data could work: the game respects the **grading** of the face poset (each move raises
dimension by 1) and the moves-from-`S` structure is the link.  The natural precise candidate is
discrete-Morse-theoretic: a second-player strategy *is* a perfect rank-matching on the face poset
(match each even-size position `S` reached in play with its reply `S ∪ {f(S)}`), with an extra
**game-compatibility** condition — the matching must be simultaneously valid on all
play-reachable orders, which is strictly stronger than Forman acyclicity.  The program's C27
`MirrorStepGood/MirrorClosed` condition is *exactly* game-compatibility for the sub-class of
matchings induced by a vertex involution.  So the correct reading of this shape for the program:

- The mirror graveyard killed only the **involution-induced** matchings.  The KSS-shape's
  genuine content is the strictly larger class of **game-compatible acyclic matchings** on the
  face poset of the residual complexes, plus (speculation) an equivariant existence argument —
  averaging or Smith-theory over the Singer cycle or over `PGL(2,q)` on the conic line — that
  produces such a matching without exhibiting a formula.
- The fixed-point direction runs the other way from what we want: Oliver + fixed-point-free
  Singer action shows `Δ_q` (if it were ℤ_p-acyclic) would have a fixed cap — there is none for
  the full group — so it proves `Δ_q` is **not** acyclic: a statement about topology *from*
  symmetry, with no outcome content.  Getting outcome OUT requires the missing bridge, full stop.

**The exact missing lemma (two, in series).**

> **Bridge lemma (plausible, provable-looking).**  For a finite complex `Δ`, the build game on
> `Δ` is P iff the augmented face poset admits a *game-compatible* perfect matching (every face
> of odd dimension matched upward; compatibility: for every play order, the matched reply is
> legal — formalizable as: the matching restricted to every principal order filter reachable in
> play is still perfect on its play-closure).  Cost: near-tautological in one direction; the
> content is finding a local (Morse-type) criterion implying compatibility.

> **Equivariant existence lemma (the hard, speculative one).**  For `Δ = lk(size-3 residual)` in
> odd characteristic, a game-compatible matching exists — proved not by formula but by an
> equivariant/fixed-point argument over the conic `PGL(2,q)`-action, e.g. Smith theory applied
> to the involution graph of Lemma V.  No known theorem does this; this is a new-mathematics
> obligation, labeled as such.

**Cheap kill-test.**  (1) Enumerate `Δ_q` fully for `q = 5, 7` (small) and the q=11 residual
links from existing dumps; extract second-player strategy DAGs from the C38 forced-skeleton rows
(`c38-forced/*.forced.rows` — already on disk); check whether the induced matchings are Forman-
acyclic.  If winning strategies routinely induce **non-acyclic** matchings, the Morse-flavored
bridge is dead as stated.  (2) The 119 flipping configurations give pairs of links that are
integrally "the same" with opposite outcomes across `q ∈ {11,17}` vs `{13,19}`: any candidate
topological/Morse invariant must separate them using GF(q)-internal data (where the σ-orbits
differ); compute the candidate on both sides of one flip pair — if it cannot separate, dead.

**Leverage: WEAK-to-MEDIUM.**  Two missing theorems in series, one of them genuinely new
mathematics; no literature bridge (checked; absence claim [VERIFY]).  Its value is conceptual
even on failure: it is the only shape that explains the program's mirror machinery as a special
case of something larger, and kill-test (1) is nearly free given C38 artifacts.

### 3.3 Survivor 2 — entropy compression for the maintenance/steering existence lemma (S11)

**Why this is the natural third survivor.**  The open obligation on the frontier route is the
maintenance lemma — an existence-under-adversity statement:

```text
Good S, opponent plays legal x  ⇒  some legal reply y has Good (S + x + y).
```

The mined evidence is strikingly *algorithmic*: at q=23, all 5,734 first moves across all 22
buckets have a zero-xor P reply **within the first four** zero-xor candidates sorted by
`live_on`; the one-pair maintenance census found existential selectors covering 28,646/28,646
obligations, 94.7% of accepted replies descending to `live_on ≤ 2`.  "A greedy local-repair
procedure with a tiny candidate budget always succeeds" is precisely the phenomenon entropy
compression (Moser–Tardos; Grytczuk–Kozik–Micek) turns into a theorem: if the deterministic
repair procedure could fail, its failure trace would encode more information than the adversary
budget can supply.

**Shape of the argument here.**  Fix a definable priority rule `R` (candidate order on replies).
Suppose at some state the top-`k` candidates all fail.  Each failure is a specific incidence
coincidence — candidate `y_i` fails because a collinearity/xor condition holds, i.e. a polynomial
equation over `GF(q)` in the coordinates of the played points.  A `k`-fold failure is a `k`-fold
coincidence; the compression ledger charges these against the adversary's move budget (game
length ≤ `q + 2`).  Two program-specific advantages over the generic method:

- **Exactness (no `q ≥ q₀` gap).**  Every object in the conic residual is genus 0, so the
  candidate counts are exact quadratic-character sums — the queue's sixth-pass method note —
  rather than Weil-approximate.  Standard LLL-style arguments lose constants; this one need not,
  which matters because constant-slack counting is exactly what dies at the frontier.
- **Amortization matches the data.**  The seventh-pass method note says the missing termination
  invariant looks amortized, not conserved.  Entropy compression *is* an amortized potential —
  the ledger, not a snapshot — so it is the formal home for that note, and it dodges the static-
  invariant graveyard by construction.

How it differs from the dead Hall/pairing counting: no global matching, no board-level sum; the
inequality is per-failure-record — `bits to describe the coincidence` > `bits of adversary
freedom consumed` — and the `q ≥ 38` precedent does not apply to it.

**The exact missing lemma (forced).**

> **Geometric selector lemma.**  There is a priority rule `R`, definable from the position's
> incidence data (first-order in the field with quadratic-character predicates, no value oracle),
> and constants `(k, c)`, such that failure of `R`'s top-`k` candidates at any Good-descended
> state forces ≥ `c` algebraically independent incidence coincidences.  (Then the compression
> ledger closes the maintenance lemma for all `q` above a *computed, small* bound, with the rest
> covered by existing certificates.)

The blocker is stated in the queue already and is the same one: **the mined repair witnesses are
value-defined, not yet geometrically definable**.  This shape does not remove that blocker; it
sharpens exactly what the definable rule must satisfy (top-`k` + failure-rigidity), which is a
much weaker demand than "the rule's choice is always optimal".

**Cheap kill-test.**  Run the concrete deterministic policy "first zero-xor candidate in
`live_on`-sorted order, budget k=4" — not the existential selector — over the existing q=19 and
q=23 maintenance artifacts (the naive *first*-candidate rule is already known to fail 3/108 on
one chunk, so the base point is measured).  Record: (a) success rate of the fixed rule at each
budget `k = 1..4`; (b) for every failure, the incidence description of *why* each candidate died.
If no bounded-budget definable rule reaches 100% on data already on disk, the shape is wounded at
the selector stage before any ledger mathematics is attempted.  If some `k ≤ 4` rule does reach
100%, the failure-rigidity half becomes a concrete character-sum exercise on the recorded
failure patterns.

**Leverage: MEDIUM.**  The empirical signature (tiny candidate budget, always succeeds) is the
method's fingerprint, the exact-counting advantage is real and program-specific, and the
kill-test costs one script over existing dumps.  Held below strong because the definable-selector
blocker is real, currently unsolved, and the method contributes nothing until it falls.
Composition note: S11 is not exclusive of S10 — a proven selector lemma is precisely a reply
schema for alphabet elements, i.e. S11 is the natural discharge/reducibility engine *inside* the
S10 frame for the unbounded-looking regimes.

## 4. (d) Verdict

Ranking:

1. **S10 discharging / unavoidable set + machine reducibility** — strong.  The only shape whose
   hard half (reducibility) is already engineered and Lean-validated, whose finiteness suppliers
   (Dawson period 34, O(1)-per-intruder defect sets, C46 ladder) are proven, and whose exposed
   risk (bounded zone interface vs `Z = 2, 9, 16`) is concrete and measurable.
2. **S11 entropy compression for the maintenance lemma** — medium; independently valuable and
   composable as S10's reply-schema engine; blocked on the geometric selector.
3. **S9 KSS / equivariant Morse** — weak-to-medium; two missing theorems, one genuinely new;
   cheap first kill-test via C38 artifacts; conceptual payoff even on failure.

Everything else: dead as a main route (S1, S2, S4, S5, S12, S13, S15), component/support only
(S8 inside S10; S14 feeding A5/C59), or per-q tooling (S6, S3-static, S7).

**The single lemma obligation to add to the queue if the program adopts the top shape** (proposed
ID **C61**, new — deduped against C55–C60; it consumes C35/s4xormine artifacts, feeds on a C55
positive, and is the S10 kill-test made operational):

> **C61 — coupled-snapshot reply-existence classes (the finite-steering-alphabet test).**  Over
> the existing exact dumps (q=13/17/19 full, 22 q=23 buckets, C35 Grundy dumps, s4xormine
> maintenance rows incl. the 1,513 `live_on = 3..6` residuals): compute for every
> (state, opponent-move) obligation the coupled NK snapshot (defect spectrum mod 34 + intruder-
> pair incidence type + bounded zone interface + C46 depletion marker) and test whether snapshot
> class ever collides on the predicate "a Good-restoring zero-xor reply exists".  Zero collisions
> at a bounded interface radius = the unavoidable-set alphabet exists at this layer and the
> discharging shape is promoted to the program's frame; collisions that survive one C55-informed
> refinement = the shape is dead and the census's verdict column gets its next negative.

This is the census's output in one sentence: the program already owns a 4CT-grade reducibility
engine; the only question worth an immediate task is whether a `q`-uniform finite alphabet of
coupled steering snapshots exists for reply-*existence* — and that question is decidable this
week against data already on disk.

## References checked this session

- Kahn–Saks–Sturtevant, Combinatorica 4 (1984) 297–306 — [Springer](https://link.springer.com/article/10.1007/BF02579140)
- Oliver fixed-point background via the evasiveness literature — [survey PDF](https://fredzhang.me/pdf/note/evasiveness.pdf), [arXiv:1603.04412](https://arxiv.org/pdf/1603.04412)
- Guy–Smith, Proc. Cambridge Philos. Soc. 52 (1956) — [Cambridge Core](https://www.cambridge.org/core/journals/mathematical-proceedings-of-the-cambridge-philosophical-society/article/abs/gvalues-of-various-games/B5C925C1BCF73C0DB7F35EEA160EBB4B); octal periodicity — [Wikipedia](https://en.wikipedia.org/wiki/Octal_game), [A002187 note](https://oeis.org/A002188/a002188_1.pdf)
- Ehrenborg–Steingrímsson, Electron. J. Combin. 3 (1996) — [EuDML](https://eudml.org/doc/118950)
- Faridi–Huntemann–Nowakowski, "Simplicial Complexes are Game Complexes", Electron. J. Combin. 26(3) (2019) — [EJC](https://www.combinatorics.org/ojs/index.php/eljc/article/view/v26i3p34), [arXiv:1608.05629](https://arxiv.org/abs/1608.05629); Games and Complexes I/II — [GONC5](https://library.slmath.org/books/Book70/files/1011.pdf)
- Emperor-sum simplicial games — [arXiv:2202.00197](https://arxiv.org/pdf/2202.00197)
- Moser–Tardos / entropy compression / Grytczuk–Kozik–Micek — [arXiv:1112.5524](https://arxiv.org/pdf/1112.5524), [Esperet–Parreau line](https://www.sciencedirect.com/science/article/pii/S0195669813000310), [projective-plane coloring application](https://www.researchgate.net/publication/320517094_Entropy_Compression_Method_and_Legitimate_Colorings_in_Projective_Planes)
- Unverified-by-search items are tagged [VERIFY] inline (Fraenkel citation; the absence-of-bridge
  claim, which search supports but cannot prove; the projective-plane entropy-compression paper's
  author list).
