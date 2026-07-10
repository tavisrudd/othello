# Spinoff bridges A–F: literature + priority lit-check

**Date**: 2026-07-09
**Scope**: prior-art audit for the six spinoff items in
[`handoffs/2026-07-09-spinoff-bridges-duals-isomorphisms.md`](handoffs/2026-07-09-spinoff-bridges-duals-isomorphisms.md).
Extends, does not repeat, the existing
[novelty audit](2026-07-08-codex-projective-nofil-novelty-audit.md) and
[nofil-connection](2026-07-07-nofil-connection.md) notes (HHS = the anchored prior art for the
ruleset; the projective-family outcome theorems are the program's claimed contribution).

Method: WebSearch + WebFetch. Every citation below was reached via a search hit or an opened
page in this session; items I could not open to full text are tagged `[VERIFY]`. "None-found"
verdicts list the queries so absence of evidence is auditable.

---

## Item A — code-extension game (caps ↔ linear codes, build columns keeping d ≥ 4 / MDS)

**Searches run:** `impartial combinatorial game building linear code minimum distance`;
`lexicode game Conway Sloane greedy code`; `"arc" building game finite geometry combinatorial`;
`"MDS code" OR "maximum distance separable" game two-player extension append column construction`.

**What exists (the reverse arrow, game → code):**

- Conway & Sloane, *Lexicographic codes: error-correcting codes from game theory*
  (IEEE IT-32, 1986). The lexicode greedy construction; the resulting codes are exactly winning
  positions of an associated impartial (Nim-like) game, additive over GF(2), linear for field
  size 2^(2^k). Reached: Williams College PDF, Wikipedia "Lexicographic code", Semantic Scholar.
- *Complexity of error-correcting codes derived from combinatorial games* (Springer LNCS,
  10.1007/978-3-540-40031-8_14). Computes lexicodes in O(n^(d−1)) via two-player cellular-automata
  games. Title/abstract reached; full text behind an auth redirect `[VERIFY]`. Direction is
  dispositive from the abstract: codes are *derived from* games.

Both are the **opposite arrow** of item A: they extract a code from a game's P-positions. Item A
proposes a game whose *moves build the code* (append a parity-check column keeping any 3 columns
independent, i.e. d ≥ 4; a plane arc = an [n,3] MDS code), with the proved outcome theorems
(affine, even-q plane, elliptic mirror, binary) restated in code language.

**What does not exist:** no two-player game that appends generator/parity-check columns to grow a
linear code / arc / MDS code was found. Arc and MDS material is entirely static-structure
(Ball, *Arcs in finite projective spaces*, arXiv:1908.10772; Wikipedia "Arc (projective
geometry)"; MDS-conjecture literature) — "complete arc" is a terminal-position concept, never
framed as a game terminal. Closest impartial-game neighbor is the **general-position
achievement/avoidance game on graphs** (see item D), which is on graph geodesics, not on a
matroid/code column set.

**PRIOR ART: none-found** (for the code-*building* game). Justification: the only code↔game
bridge in the literature is lexicodes and its complexity follow-up, both game → code; the append-
column d ≥ 4 game and the code-language restatement of the proved outcomes have no located
precedent. **NOVELTY RISK: low.** Caveat: it is a *reframing* of already-proved theorems, so the
new mathematical content is the dictionary + positioning, not new outcomes — reviewers will read
it as an application note, and it must cite lexicodes prominently as the precedent for the bridge.

---

## Item B — SET / cap-set / 3-AP-free game + sum-free games on abelian groups

**Searches run:** `SET card game combinatorial game theory cap set avoidance`;
`van der Waerden game Maker-Breaker Beck arithmetic progression impartial avoidance`;
`sum-free set combinatorial game two players abelian group Schur triple`; WebFetch of
arXiv:2010.01882.

**HHS coverage (the gate the note demands), settled:** HHS (*Nofil on STS*, arXiv:2103.13501,
JCD 2022) compute nim-values for all STS up to order 15 plus samples at 19/21/25, and explicitly
identify STS(7) = PG(2,2) (value 0) and STS(9) = AG(2,3) (value 0). They prove
vertex-transitive ⇒ nim ∈ {0,1} and the Node-Kayles/PSPACE bridge. They do **not** prove any
infinite family — not AG(n,3), not PG(n,2). So the program's AG(n,q)-is-P theorem and the binary
projective family are the new outcomes; HHS is prior art for the ruleset and the two calibration
points only. (Re-confirmed this session against the Wiley + arXiv abstracts; consistent with the
existing audit.)

**SET as a game:** the SET ↔ cap-set = AG(4,3) dictionary is textbook (Davis & Maclagan,
*The card game SET*; Wikipedia "Cap set"). The recent structural paper *Toward a combinatorial
theory of SET and related card games* (arXiv:2010.01882) — fetched — is **enumerative /
equivalence-class counting, not a two-player game** (its "alternative games" are rule variants of
the puzzle, no strategic/nim analysis). No CGT treatment of a SET-deck *avoidance game* was found.

**Beck's van der Waerden games:** these exist as **Maker–Breaker** positional games (Wikipedia
"Arithmetic progression game"; Beck's threshold bounds; *Fast winning strategies in a generalized
van der Waerden game*, arXiv:2309.11367). Their generalization to linear systems is the
**Maker–Breaker Rado game** (*Maker–Breaker Rado games for equations with radicals*,
arXiv:2309.09145, INTEGERS 24), which **includes the Schur equation x+y=z** — i.e. a
Maker–Breaker sum-free game already exists. The **impartial shared-set avoidance** counterpart
(the program's convention: one common cap, last legal move wins) is not present in any of these —
same Maker-Breaker-vs-impartial-avoidance gap the audit already flags for vdW.

**Sum-free game on Z_n / abelian groups:** search returned only extremal/coloring results
(Treglown et al. on maximal sum-free sets; sum-free colorings) — **no two-player sum-free game**.

**PRIOR ART: partial-overlap.** Justification: the SET↔AG(4,3) identification and the
Maker–Breaker vdW/Rado (hence Schur) games are prior art; the **impartial-avoidance** SET/cap-set
game and the impartial sum-free game on abelian groups have no located precedent, and the outcome
theorems are the program's own. **NOVELTY RISK: low** for the game framing and the abelian-group
extension of `nonzero_initial_isP_zmod2`; **the framing must be stated as the impartial-avoidance
counterpart of Beck/Rado, not as a new AP-game**, and the SET↔cap-set dictionary cited as folklore.

---

## Item C — games-on-groups bridge + standalone Node-Kayles family

**Searches run:** `Anderson Harary achievement avoidance game generating group`;
`Benesh Ernst Sieben generation game finite group Node-Kayles nim-value`;
`generation game finite group connection projective plane geometry Node-Kayles graph reduction`;
`Node-Kayles polynomial time bounded degree graphs matchings union tractable Grundy`.

**The genre exists and is active:** Anderson & Harary, *Achievement and avoidance games for
generating abelian groups* (Int. J. Game Theory 16, 1987) — the DO/DON'T GENERATE games.
Benesh–Ernst–Sieben carried this into CGT: *Impartial avoidance/achievement games for generating
finite groups* (arXiv:1407.0784), *...symmetric and alternating groups* (arXiv:1508.03419),
*...nilpotent groups* (arXiv:1805.01409), and Ernst–Sieben *The spectrum of nim-values for
achievement games for generating finite groups* (arXiv:2004.08980, INTEGERS 2023; spectrum
{0,1,2,3,4}). Value is carried by the subgroup lattice — structurally the same "value carried by
generated subgroups" pattern the conic residual uses (dihedral subgroups of PGL(2,q)).

**No geometric client found:** the query pairing generation games with projective planes / finite
geometry / a Node-Kayles reduction returned **nothing** connecting the two genres. So the item-C(i)
claim "first geometric client of the generation-games genre" is supportable **as an
absence-of-evidence statement** — state it as "we did not find a prior geometric instance," not as
a proven first.

**Node-Kayles part (C-ii):** Node-Kayles is PSPACE-complete in general (Schaefer), poly-time on
cographs, cocomparability graphs, trees (*Node-Kayles on trees*, arXiv:2512.24221). A **union of
involution matchings has maximum degree ≤ 2 ⇒ it is a disjoint union of paths and cycles**, and
Node-Kayles on a path P_n is the classical octal game 0.137 = **Dawson's chess** (Guy–Smith;
*Winning Ways*), with cycles a standard near-variant. So the *tractability* of the degree-≤2 family
is **classical CGT, not new**; what is new is only **which** unions arise from PGL(2,q) conic
involutions and their arithmetic indexing by the divisor lattice of q±1 (Lemmas V–VII / Cor VII).
*Winner determination algorithms for graph games with matching structures* (arXiv:2211.05307) is
the closest algorithmic neighbor but I could not parse its PDF `[VERIFY]` — assume degree-≤2
Node-Kayles tractability is known and claim only the geometric indexing.

The note already records that the **static** side is owned (Coolsaet–Sticker, EJC 17 (2010) #R112,
two-involution conic spectrum; Tranchida, arXiv:2411.10299, involution triples). Confirmed the
claimable delta is the **game layer** only.

**PRIOR ART: partial-overlap.** Justification: the games-on-groups genre and degree-≤2 Node-Kayles
tractability are both established; the bridge (conic residual ⇒ involution-selection game in
PGL(2,q)) and the arithmetic-indexed *geometric* Node-Kayles family are unlocated. **NOVELTY RISK:
medium** — the bridge is a "connection note" (soft novelty), and C(ii) must be scoped to the
geometric indexing so it does not re-announce classical Dawson-on-paths as new.

---

## Item D — matroid circuit-avoidance games

**Searches run:**
`combinatorial game on matroid circuit avoidance independence Shannon switching game`;
`impartial game matroid independent set building Nim matroid`;
`general position game graph "no three in line" impartial combinatorial game achievement`.

**Games-on-matroids is a crowded, founding area:**

- **Shannon switching game** (Shannon ~1955), **solved by Lehman on matroids** (*A solution of
  the Shannon switching game*, SIAM J. Appl. Math. 1964) — the first application of matroid theory
  to a game. It is a **Maker–Breaker connectivity/partizan** game (Short builds a circuit through a
  distinguished element, Cut destroys it), extended to oriented matroids (*Directed switching games
  on graphs and matroids*, JCTB 40, 1986). Circuit-relevant but not impartial building-avoidance.
- **Sprague–Grundy function of matroids** (arXiv:1804.03692) — impartial **hypergraph Nim** on
  matroid circuits (a pile-*removal* game), and *Coloring games and algebraic problems on matroids*
  (arXiv:1501.00224). Impartial, matroid-native, but not a set-*building* avoidance game.
- **General position achievement/avoidance game on graphs** (Klavžar, Neethu, Chandran, 2021;
  arXiv:2111.07425; survey arXiv:2501.19385): players build a vertex set staying in
  general position (no 3 on a common geodesic), last-move win/lose. This is the **closest existing
  impartial "avoid a girth-3 dependency while building" game** — on graph geodesics rather than a
  matroid, but the same shape as item D's rank-3 case.

The specific object of item D — an **impartial circuit-avoidance *building* game on a general
matroid**, with caps/arcs as the rank-3 vector-matroid case — was not found verbatim. But
"no 3 collinear = girth condition in the rank-3 matroid, generalize to avoiding small circuits" is
a natural move that matroid game-theorists have most of the pieces for, and the area already has a
founding game (Lehman), a Sprague–Grundy theory, and coloring games. A standalone novelty claim
here is thin and exposed.

**PRIOR ART: partial-overlap.** Justification: no exact impartial circuit-avoidance building game
located, but games-on-matroids is a founding, well-populated area (Lehman, matroid SG-theory,
matroid coloring games) and the general-position graph game is a near-identical shape.
**NOVELTY RISK: medium-high** — smallest new-math delta of the six; the "positioning note" would be
mostly re-derivation of the matroid-game map with the proved cases dropped in.

---

## Item E — capacity-c games on t-designs / circle geometries + fpf-involution classification

**Searches run:** `avoidance game combinatorial design t-design inversive plane Nofil`;
`fixed-point-free involution classical groups PGL PSL polar spaces classification tabulated`.

**Design-game side (E-i):** beyond HHS-on-STS, the located design/avoidance-game literature is
HHS itself, *Transitive avoidance games* (Johnson, EJC), and colored positional games on planes
(Danziger et al., already in the audit). **No capacity-c (c ≥ 2) avoidance game on general
t-designs, and nothing on inversive/Laguerre/Minkowski (circle) geometries**, was found. The
capacity-3 circle-geometry game is unlocated but also low-audience.

**fpf-classification side (E-ii):** fixed-point-free involutions in classical groups are
**well-documented as group theory** — involution class data for PSL/PGL(2,q) is standard (e.g.
PSL(2,n): involutions have 0 fixed points for n ≡ 3 mod 4, 2 for n ≡ 1 mod 4), and *Fixed-point-
free involutions and Schur P-positivity* (arXiv:1706.06665) tabulates fpf involutions in symmetric
groups. A single citable table "which classical geometry / polar space carries an fpf automorphism
compatible with its block structure" was **not** found as a unit `[VERIFY]`, but the ingredients
(involution classes in classical groups, Aschbacher–Seitz-style) are tabulated. So E-ii is
**synthesis of tabulated group-theory data into a geometry-facing statement**, not a discovery.

**PRIOR ART: partial-overlap.** Justification: the design/circle-geometry *game* is unlocated
(none-found), but the fpf-involution existence data underlying E-ii is already tabulated in the
classical-groups literature. **NOVELTY RISK: low-medium**, but the audience is diffuse and the
deliverables split into one unlocated-but-low-value game and one synthesis note.

---

## Item F — order-9 non-Desarguesian solve as a plane invariant

**Searches run:**
`combinatorial game invariant distinguishing non-Desarguesian projective plane Hall Hughes`;
`Berlekamp switching game finite projective plane order 9 Hall Hughes invariant`.

**The four planes are confirmed and standard:** PG(2,9), the Hall plane, its dual, and the
self-dual Hughes plane are the complete list of order-9 projective planes (Wikipedia
"Non-Desarguesian plane"; Lam et al., *A computer search for finite projective planes of order 9*).
Existing invariants that distinguish them are **static combinatorial counts** — e.g. inequivalent
triangles (Hall: 6; Hughes: 16, with self-dual/dual-pair structure). No dynamic/game invariant
appears in that literature.

**Games on these planes exist but are a different genre:** *Berlekamp's switching game on finite
projective and affine planes* (arXiv:1208.1649) studies a light-flipping / covering-code game and
its worst-case lit arrangements by order parity — it is **not** a cap game and is **not** used as a
plane isomorphism invariant.

**No combinatorial game has been used as an invariant of a projective plane** was found — the
query returned only static distinguishers and the Berlekamp switching genre. So item F's core idea
(the impartial cap-game outcome, and the Hall-vs-dual-Hall asymmetry once self-duality fails, as a
*game invariant of the plane*) is unlocated in the literature.

**PRIOR ART: none-found** (for a game-as-plane-invariant). Justification: order-9 planes are
distinguished only by static counts in the located literature; the one game on planes (Berlekamp
switching) is a covering game, not an invariant of the plane and not a cap game.
**NOVELTY RISK: low.** Plus F is the only item that produces **new computational results** and
feeds the odd-plane kernel (falsification-map constraint either way).

---

## Cross-cutting adjacent prior art to cite in any write-up

| Prior art                                             | Genre / why cite                                                       | Relevant to |
|-------------------------------------------------------|------------------------------------------------------------------------|-------------|
| HHS, Nofil on STS (arXiv:2103.13501, JCD 2022)        | The ruleset anchor; STS(7)/STS(9) calibration; PSPACE/Node-Kayles      | all (B esp) |
| Conway–Sloane lexicodes (IEEE IT-32, 1986)            | Only code↔game bridge; **reverse arrow** (game → code) precedent       | A           |
| Klavžar–Neethu–Chandran general-position game (2021)  | Closest impartial "avoid girth-3 while building" game (graph geodesics)| A, D        |
| Beck vdW / Maker–Breaker Rado (incl. Schur)           | Maker–Breaker counterpart; our game is the impartial-avoidance dual    | B           |
| Anderson–Harary; Benesh–Ernst–Sieben generation games | Games-on-groups genre; value carried by subgroup lattice               | C           |
| Lehman / Shannon switching on matroids (SIAM 1964)    | Founding matroid game (Maker–Breaker); crowds D's space                | D           |
| Matroid Sprague–Grundy / hypergraph Nim (1804.03692)  | Impartial matroid game (removal, not building)                         | D           |
| Coolsaet–Sticker (EJC 2010 #R112); Tranchida (2411.10299) | Own the **static** two-/three-involution conic side; claim game only | C, E        |
| Berlekamp switching on planes (arXiv:1208.1649)       | Only located game on planes; covering genre, not a plane invariant     | F           |

---

## Priority re-ranking

**Note's current rough order:** A, B, F, C, D, E.

Scoring axes (lower risk = better; lower effort = better; higher audience = better). Strategic
column flags the feed-into-kernel bonus, which only F carries.

| Item | Prior-art verdict | Novelty risk | Effort   | Audience value          | Strategic       |
|------|-------------------|--------------|----------|-------------------------|-----------------|
| A    | none-found        | low          | low      | high (coding / MDS adj.)| satellite       |
| B    | partial-overlap   | low          | low–med  | high (SET / cap-set)    | flagship's face |
| C    | partial-overlap   | medium       | medium   | medium                  | satellite       |
| D    | partial-overlap   | medium–high  | low      | low–medium              | satellite       |
| E    | partial-overlap   | low–medium   | med–high | low–medium (diffuse)    | satellite       |
| F    | none-found        | low          | medium   | medium–high             | **feeds kernel**|

**Recommended re-ranking: F, A, B, C, E(rescoped), D(fold).**

| Rank | Item | Move vs note | Why                                                                             |
|------|------|--------------|---------------------------------------------------------------------------------|
| 1    | F    | ↑ from 3     | Only item with new results + only clean none-found + feeds the odd-plane kernel |
| 2    | A    | ↑ from 1→2*  | Lowest-effort/highest-leverage reframing; none-found; big adjacent audience     |
| 3    | B    | ≈            | Public face of the flagship AG(n,q) theorem; low risk; real abelian-group math  |
| 4    | C    | ≈            | Bridge is soft-novel; C(ii) must be scoped to geometric indexing (Dawson known) |
| 5    | E    | ≈ (rescope)  | Keep only the fpf-classification synthesis (E-ii); defer the circle-geom game    |
| 6    | D    | ↓ (fold)     | Games-on-matroids is crowded; fold the matroid/dual-code angle into A instead    |

*A drops one slot only because F is promoted; A and B remain the two strongest satellites.

**Explicit drop / rescope calls:**

- **D — rescope/fold, do not write standalone.** Games-on-matroids has a founding game (Lehman),
  an SG-theory, and coloring games; the general-position graph game is nearly the same shape. A
  standalone note would be mostly re-derivation. Fold "no-3-collinear = rank-3 girth" and the
  matroid-duality ↔ dual-code observation into **item A** as a closing subsection (the note itself
  already ties D back to A via dual codes). Recovers most of D's value at ~no marginal effort.
- **E — rescope to E-ii only.** Drop/defer the capacity-3 circle-geometry game (unlocated but
  low-audience). Keep the fpf-block-compatible-involution note, framed as **synthesis** of tabulated
  classical-group involution data into a geometry-facing criterion (C27 + C48), not as new existence
  results — the involution classes are already documented.
- **C(ii) — scope tightly.** Claim only the geometric/arithmetic indexing of which Node-Kayles
  path/cycle families arise from conic involutions. Degree-≤2 Node-Kayles = Dawson's chess is
  classical; do not present it as new.
- **A, B, F — proceed.** All three are low-risk; F first for strategic + freshest results, A/B as
  the two flagship-adjacent reframings.

**Gate reminder honored:** the item-B HHS overlap is settled (HHS prove no infinite family; the
program's AG(n,q) and binary-projective theorems are the new outcomes), so A's and D's novelty
claims are not resized downward by any HHS coverage — the resizing pressure on A/D comes instead
from lexicodes (A) and the matroid-game corpus (D), as recorded above.

---

## Broader-sweep candidates (second pass)

Lit check for the handoff's "New Candidate Mappings (2026-07-09 broader sweep)" section. Depth
proportional to spinoff rating; same rules (no fabricated references; `[VERIFY]` on anything not
opened; none-found verdicts log their queries). Two candidates rated weak (arc stability,
online/amortized potentials) are pure imports with no outward claim, so they carry no prior-art
exposure and got no sweep.

### S1. No-three-in-line game (spinoff: strong)

**Searches:** `"no-three-in-line" game combinatorial two players`; `"no three in line"
achievement game grid collinear Maker-Breaker`; `no three collinear game infinite plane points
collinearity game recreational mathematics`.

The static problem is Dudeney 1900/1917 (Wikipedia "No-three-in-line problem"; Gardner's minimum
variant, arXiv:1206.5350 — the *saturated* small sets, i.e. our terminal positions). **No game
version on the Euclidean grid was found** — not impartial, not Maker–Breaker, not achievement.
The load-bearing adjacent prior art is the **general position achievement/avoidance game on
graphs** (Klavžar–Neethu–Chandran 2021, arXiv:2111.07425; avoidance + hardness follow-up
arXiv:2205.03526; survey arXiv:2501.19385): explicitly Dudeney-motivated, same conventions
(achievement = normal, avoidance = misère), but "general position" there means no 3 on a common
*graph geodesic* — on grid graphs that is monotone-lattice-path collinearity, **not** Euclidean
collinearity, so the classical n×n no-three-in-line game is genuinely open. Erdős–Szekeres
Maker–Breaker games (arXiv:2505.15366) are the convex-position cousin.

**PRIOR ART: none-found** (for the Euclidean-grid game) with a **named adjacent genre**.
**NOVELTY RISK: low-medium** — the general-position-game community will read this as their
variant unless the note positions against them explicitly (geodesic vs Euclidean collinearity,
plus the row/column capacity structure). Effort ~zero: the grid solver plays it today.

### S2. Singer / Sidon-set games (spinoff: strong)

**Searches:** `Sidon set game two players building difference set impartial`; `Singer difference
set game cyclic projective plane perfect difference set game`; `"Sidon" OR "B_2 set" avoidance
achievement game arXiv combinatorial game theory integers` (three-probe sweep).

Sidon/B₂ and perfect-difference-set literature is entirely static: size/diameter bounds
(arXiv:2207.07800, 2310.20032), Sidon set systems (arXiv:1802.10511), and — notably — *Forbidden
Sidon subsets of perfect difference sets* (arXiv:2510.19804, Erdős problem 707), which is exactly
the Singer-cycle ∩ Sidon intersection **as a static question** and is the natural citation
anchoring the board. Singer's construction (points of PG(2,q) = Z_{q²+q+1}, lines = translates of
a perfect difference set) is classical and confirmed (Singer difference sets / projective norm
graph, arXiv:1908.05591; prime-power-conjecture background). **No two-player Sidon-set,
difference-set, or B_h-set building game was found anywhere.**

**PRIOR ART: none-found.** **NOVELTY RISK: low** — cleanest of the sweep; elementary statement,
active static community (Erdős-problem adjacency), and the Singer model ties it to the main
program's boards.

### S3. Quantum caps PG(n,4) (spinoff: medium-strong)

**Searches:** `caps PG(n,4) quaternary additive codes quantum stabilizer Glynn Tonchev`;
`quantum error-correcting code construction game combinatorial two-player`; `"PG(3,4)" cap game
nim-value avoidance impartial 85 points`.

**The correspondence is established and citable:** quantum caps = caps in PG(n,4) ↔ additive
quaternary self-orthogonal codes ↔ distance-4 stabilizer codes. Sources reached: Tonchev,
*Quantum codes from caps* (ResearchGate listing); the Bierbrauer–Edel lineage — *New quantum caps
in PG(4,4)* (arXiv:0905.1059), *The spectrum of quantum caps in PG(4,4)* (arXiv:0912.4461),
*The structure of quaternary quantum caps* (DCC 2013; PDF at yvesedel.de); Glynn–Gulliver–Maks–
Gupta, *The geometry of additive quantum codes* (2006 manuscript, cited in the above) `[VERIFY]`
for the exact Glynn attribution. **No game-theoretic work on quantum-code construction in the CGT
sense exists**: the only game-flavored item is *Game-theoretic discovery of QEC codes through
Nash equilibria* (arXiv:2510.15223) — an optimization framework, not an alternating-move
combinatorial game. The **PG(3,4) cap-game outcome is untouched**: the targeted search found
nothing (results degenerated to generic Nim/CGT pages — a strong none-found signal).

**PRIOR ART: none-found** (game layer; the correspondence itself is covered, which is what the
item needs). **NOVELTY RISK: low.** Bonus: PG(3,4) (85 points) is a solvable open board in our
own table — besides S1, the one sweep candidate that yields a new computational result.

### S4. Placement complexes / discrete Morse (spinoff: medium-strong)

**Searches:** `Faridi Huntemann Nowakowski simplicial complex placement games`; `discrete Morse
theory combinatorial game strategy pairing acyclic matching`.

**Citation confirmed:** Faridi–Huntemann, *Simplicial complexes are game complexes*
(arXiv:1608.05629, EJC 26(3) #P34) — every simplicial complex is the legal complex of an
invariant strong placement game; plus Faridi–Huntemann–Nowakowski, *Games and complexes I:
transformation via ideals* (arXiv:1310.1281) and *II: weight games and Kruskal–Katona type
bounds* (arXiv:1310.1327), both in Games of No Chance 5. (The EJC paper is Faridi–Huntemann;
Nowakowski joins on I/II — cite accordingly.) **No discrete-Morse ↔ game-strategy connection was
found**: the acyclic-matching literature (Forman DMT; optimal matchings NP-hard, Hersh;
independence-complex matchings, arXiv:2604.12606) never mentions game strategies, and no paper
casts a pairing strategy as a gradient vector field.

**PRIOR ART: partial-overlap** (the complex dictionary is published; the Morse analogy is
unclaimed). **NOVELTY RISK: low for the analogy, but it is an analogy** — the handoff itself says
"to develop, not a theorem." Value soft until pairing-strategy ⇒ acyclic-matching is a statement;
the f-vector = arc-spectrum observation is a nice expository hook.

### S5. Misère siblings (spinoff: medium-strong)

**Searches:** `misere quotient Plambeck Siegel placement game geometric avoidance`.

Machinery confirmed: Plambeck–Siegel, *Misère quotients for impartial games* (arXiv:math/0609825)
and Siegel, *Misère games and misère quotients* (arXiv:math/0612616); the miseregames.org corpus.
Applications are to octal/heap-type games; **nothing geometric or placement-flavored found**
(closest: *Partizan Kayles and misère invertibility*, arXiv:1309.1631). The general-position
*avoidance* game (arXiv:2205.03526) is the misère sibling of the graph cousin and is already
studied — cite it when positioning.

**PRIOR ART: none-found** (geometric misère quotients). **NOVELTY RISK: low on priority,
medium-high on delivery** — misère analysis is structurally hard, mirror strategies break by
design, and the program has no misère infrastructure. High effort, uncertain yield.

### S6. Positional-game comparisons on finite geometries (spinoff: medium-strong)

**Searches:** `Maker-Breaker positional game projective plane lines finite geometry`; `Kusch Rué
Spiegel Maker-Breaker games random boards hypergraphs`; WebFetch of arXiv:2605.05455 and the MAA
Fire-and-Ice article.

Real prior art on the other side of the comparison:

- Bastioni–Giannoni–Lobillo-Olmedo, *Thresholds for tic-tac-toe on finite affine spaces*
  (arXiv:2605.05455, fetched): **Maker–Maker** on F_q^m with affine-subspace winning sets;
  a threshold T(n,q) between draw and first-player win; strategy stealing, Erdős–Selfridge,
  pairing strategies. Fresh (2026) and directly on our boards.
- Kusch–Rué–Spiegel–Szabó, *On the optimality of the uniform random strategy*
  (arXiv:1711.07251, RSA 2019): biased Maker–Breaker under container-type conditions, covering
  H-building and generalized van der Waerden games. (The half-remembered "Kusch/Rué/Spiegel on
  projective planes" is this — random/biased MB, **not** planes; corrected.)
- Danziger–Huggan–Malik–Marbach, tic-tac-toe on AG(2,4) (already in the audit).
- Recreational: *Fire and Ice* (Schliemann) is a commercial achievement game on nested Fano
  planes; Riegel's 2012 dissertation gives a strategy-stealing first-player win (MAA Math Values
  article, fetched).

**PRIOR ART: partial-overlap** — the Maker–Maker/Maker–Breaker side on finite geometries is an
active, current lane; the impartial-shared side is ours; the *comparison paper itself* is
unwritten. **NOVELTY RISK: medium** — expository-comparative by nature, and the affine-spaces
paper shows the other community is moving; timeliness cuts both ways.

### S7. Genus-2 moduli / Igusa invariants (spinoff: medium)

**Searches:** `Igusa invariants genus 2 curves finite fields moduli binary sextics PGL(2,q)`.

**Statement verified as the handoff frames it:** every genus-2 curve over k has a model
z²y⁴ = f(x,y) with f a binary sextic of nonzero discriminant, and two curves are isomorphic iff
the sextics are GL₂(k)-conjugate (Shaska, *The arithmetic of genus two curves*, arXiv:1209.0439);
so unordered 6-subsets of P¹(F_q) mod PGL(2,q) ↔ classes of binary sextics ↔ points of M₂,
**modulo exactly the twist/automorphism bookkeeping the handoff already flags** (F_q-isomorphism
vs geometric classes differ by twists; the game configuration is the 6-point set, a geometric
datum with a field of definition). Citable for Igusa invariants over finite fields: the LMFDB
knowledge entry `g2c.igusa_invariants` (reviewed; J₂…J₁₀ weighted projective, defined over Z,
reduction-mod-p behavior) and, for the small-characteristic caveat, *Modular forms of degree two
and curves of genus two in characteristic two* (arXiv:2003.00249). No game-valued stratification
of any moduli space was found (as expected; the framing is ours).

**PRIOR ART: none-found** (for the game-stratification framing); the dictionary itself is
classical and covered. **NOVELTY RISK: low on correctness; audience niche** — arithmetic
geometers will ask what the Grundy value sees that Igusa invariants don't; have an answer before
drafting.

### S8. Complexity landscape (spinoff: medium)

**Searches:** `Schaefer 1978 PSPACE-complete Node-Kayles generalized Kayles avoidance game
complexity` (plus hits surfaced by the other sweeps).

Citation verified: Schaefer, *On the complexity of some two-person perfect-information games*,
JCSS 16 (1978) 185–225 — Node-Kayles PSPACE-complete. The landscape is **already dense**: HHS
Cor. 11 (Nofil positions on STS PSPACE-complete), Slany (*Sim-like graph Ramsey avoidance
endgames are PSPACE-complete*, TCS 2002), *Avoidance games are PSPACE-complete*
(arXiv:2209.11698), general-position-game hardness (arXiv:2205.03526), Maker-Maker rank-4 PSPACE
(arXiv:2504.14256), Maker-Breaker rank-3 polynomial (arXiv:2209.12819).

**PRIOR ART: covered** (the hardness half is essentially done; HHS embedding already reaches our
genus). **NOVELTY RISK: high** for a standalone "Schaefer-style program" note — the open half
(tractable structured geometries) *is the main program*, not a spinoff. **Recommend: drop as a
spinoff; keep as the citation block** in whichever papers need motivation.

### S9. Achievement / partizan siblings (spinoff: medium)

**Searches:** `Sim game variant Ramsey avoidance geometric triangle PSPACE Slany` (plus the
first-pass CMVH status from the audit).

Sim and its graph-Ramsey avoidance generalizations are classical/complete (Slany, TCS 2002);
partizan colored avoidance on projective binary STSs is the **Clark–Mancini–Van Hook lane, still
unverified at full text** (the audit's C24 guard stands); impartial *achievement* games on convex
geometries exist (arXiv:2010.11319), as does the brand-new avoidance companion
(arXiv:2512.06267, Shim, Dec 2025 — trees/extreme-point targets; no finite-geometry boards). The
convex-geometry lane the main handoff's novelty guard flagged is therefore **live and moving**.

**PRIOR ART: partial-overlap.** **NOVELTY RISK: medium-high** — gated on the CMVH full-text
check, and the convex-geometries group could plausibly move onto geometric boards next.
**Recommend: fold into the C24 guard task**; no standalone item until CMVH is read.

### S10. Buildings / flip theory (spinoff: medium)

**Searches:** `flips of buildings Gramlich Phan theory involution centralizer classification`.

The framework exists and is directly citable: flips (= Phan involutions) of twin buildings, with
**published classifications** — *On flips of unitary buildings I: Classification of flips*
(arXiv:1012.2301); Gramlich, *Developments in finite Phan theory* (arXiv:0710.0034). This is
what E-ii wanted: the fpf-block-compatible-involution question for classical geometries sits
inside an existing classification program, upgrading E-ii from bookkeeping to citation + gap
analysis.

**PRIOR ART: covered** (as a framework — the good outcome for an import). **NOVELTY RISK: low**
*provided* it is framed as applying flip theory, never as classifying flips.
**Recommend: merge into item E-ii** rather than standalone.

### S11. Reconfiguration graphs (spinoff: medium)

**Searches:** `reconfiguration independent sets hypergraph token sliding arcs caps finite
geometry`.

Token sliding/jumping reconfiguration of graph independent sets is a large active area
(PSPACE-complete in general; arXiv:2203.16861 and successors); **nothing found on caps/arcs in
finite geometries** as the reconfigured objects. None-found on the boards, but the deliverable is
a reconfiguration (not CGT) result — a different community and toolset from the program's.

**PRIOR ART: none-found** (geometric boards). **NOVELTY RISK: low-medium; strategic fit weak** —
keep on the backlog, spend no main-program time.

### S12. Hypergraph containers (spinoff: weak-medium)

**Searches:** `hypergraph containers caps finite geometry counting cap sets container method`.

**Already done by others:** *Upper bounds for the number of substructures in finite geometries
from the container method* (arXiv:2404.05305) applies containers to exactly our 3-uniform
collinearity hypergraph — counting caps, partial ovoids, partial spreads in PG(r,q), with
asymptotically sharp instances (see also the Balogh–Morris–Samotij survey, arXiv:1801.04584).
Nothing is left of this candidate as an outward claim; it is an import for mid-game structure
statements only.

**PRIOR ART: covered.** **NOVELTY RISK: n/a — drop as spinoff**, keep arXiv:2404.05305 on the
import shelf.

### S13. Infinite boards (spinoff: weak-medium)

**Searches:** `no three collinear game infinite plane points collinearity game recreational
mathematics`.

Static infinite no-3-in-line theory exists and is current (*On infinite sets with no 3 on a
line*, arXiv:2602.21275; density-in-Z² results; *On the general no-three-in-line problem*,
arXiv:2106.15621). **No infinite-board game version found.** Monthly-note ceiling, as the handoff
says.

**PRIOR ART: none-found** (game). **NOVELTY RISK: low; value low** — backlog.

### S14–S15. Arc stability (Segre–Voloch–Ball) and online/amortized potentials

Pure imports (queued as C59 and the steering method note respectively); neither makes an outward
claim, so neither carries prior-art exposure. No sweep run; nothing to verify beyond the standard
citations already attached to the queue entries.

### Sweep notes (cross-item)

The Sidon three-probe sweep also surfaced Sieben, *Impartial hypergraph games* (EJC 30(2) #P13)
— the taxonomy paper the main novelty guard requires citing; and the S3 targeted probe's
degeneration to generic Nim pages is itself the auditable none-found evidence for PG(3,4).

### Re-ranked sweep table

Handoff's spinoff-value order (strong → weak) vs this check's recommended order, on
(novelty risk, effort, audience):

| Rank | Candidate                    | Verdict (game layer) | Risk     | Effort   | Audience      | Call                          |
|------|------------------------------|----------------------|----------|----------|---------------|--------------------------------|
| 1    | S1 No-three-in-line game     | none-found           | low-med  | ~zero    | broad         | proceed; position vs gp-games |
| 2    | S2 Singer / Sidon games      | none-found           | low      | low      | good (CGT+NT) | proceed                       |
| 3    | S3 Quantum caps PG(n,4)      | none-found           | low      | medium   | large (QEC)   | proceed; solve PG(3,4)        |
| 4    | S6 Positional comparisons    | partial-overlap      | medium   | medium   | good, timely  | proceed if a slot frees       |
| 5    | S10 Buildings / flips        | covered (framework)  | low      | medium   | group theory  | **merge into E-ii**           |
| 6    | S7 Genus-2 / Igusa           | none-found (framing) | low      | med-high | niche         | hold for C56 need             |
| 7    | S4 Placement / Morse         | partial-overlap      | low      | med-high | CGT niche     | hold (analogy only)           |
| 8    | S5 Misère siblings           | none-found           | low      | high     | CGT core      | hold (effort)                 |
| 9    | S13 Infinite boards          | none-found           | low      | low      | Monthly       | backlog                       |
| 10   | S11 Reconfiguration          | none-found           | low-med  | medium   | off-genre     | backlog                       |
| —    | S9 Achievement/partizan sibs | partial-overlap      | med-high | medium   | CGT           | **fold into C24 guard**       |
| —    | S8 Complexity landscape      | covered              | high     | —        | —             | **drop (citation block only)**|
| —    | S12 Hypergraph containers    | covered              | —        | —        | —             | **drop (import only)**        |
| —    | S14 Arc stability            | import (C59)         | —        | —        | —             | already queued                |
| —    | S15 Online/amortized         | internal template    | —        | —        | —             | already recorded              |

**Headline deltas vs the handoff's ordering:** the top two (no-three-in-line, Singer/Sidon)
survive the check; S1 keeps rank 1 on audience + zero effort but carries the one real adjacency
(the general-position game genre must be cited and distinguished — geodesic vs Euclidean
collinearity), while nothing at all sits next to S2. Quantum caps is *upgraded* by the check
(correspondence citable, game layer empty, plus a concrete solvable board). Three explicit kills:
**complexity landscape** (the hardness half is already published several times over),
**hypergraph containers** (arXiv:2404.05305 already did the counting on our exact hypergraph),
and **achievement/partizan siblings** as a standalone (blocked on the CMVH full text; the
convex-geometries avoidance lane, arXiv:2512.06267, is actively publishing one door away — a
general timeliness signal for the whole sweep).
